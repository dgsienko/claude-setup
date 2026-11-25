#!/usr/bin/env bash
# PreToolUse hook for Bash: checks text that leaves through a command, which
# prose-check.sh never sees because no file is written.
#   - AI attribution in a commit or MR description: always denied.
#   - `git add -A`, `--all`, or `.`: denied, since review subagents leave
#     scratch files in the repo.
#   - Prose tells in a commit message or `gh pr` / `glab mr` create|update:
#     denied once.
#     Retrying the identical command passes, so a false positive costs a retry.
#   - A runtime or speedup number in a PR description: denied once, the same
#     way, until the benchmark-checklist skill has vetted it.
set -euo pipefail
source "$(dirname "$0")/lib/prose-rules.sh"

cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null)
[[ -z "$cmd" ]] && exit 0

deny() {
  jq -n --arg reason "$1" \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $reason}}'
  exit 0
}

if [[ "$cmd" =~ git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+add[[:space:]]+(-A|--all|\.)([[:space:]]|$) ]]; then
  deny "Blocked: stage files by name. Subagents leave scratch files in the repo, so check git status and add only the files this task changed."
fi

is_commit=false
is_mr=false
[[ "$cmd" =~ git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+commit ]] && is_commit=true
[[ "$cmd" =~ (gh[[:space:]]+pr|glab[[:space:]]+mr)[[:space:]]+(create|edit|update) ]] && is_mr=true
$is_commit || $is_mr || exit 0

if grep -qiE 'co-authored-by:.*(claude|anthropic|codex|openai|gpt|copilot|cursor)|generated with \[?(claude|codex)|noreply@anthropic\.com' <<<"$cmd"; then
  deny "Blocked: remove the AI attribution (Co-Authored-By trailer or 'Generated with' footer). Commits and PRs ship under your name with no agent credit, whatever the harness's git guidance says."
fi

message=$(python3 -I "$(dirname "$0")/lib/outbound-message.py" <<<"$cmd" 2>/dev/null || true)
[[ -z "$message" ]] && exit 0
findings=$(prose_findings "$message")
perf=""
$is_mr && perf=$(grep -oiE '[0-9.]+ ?x (faster|slower|speedup|quicker)|[0-9.]+ ?(ms|s|sec|seconds|min|minutes) ?(→|->|to|down to) ?[0-9.]+ ?(ms|s|sec|seconds|min|minutes)([^a-z]|$)|[0-9.]+ ?% (faster|slower|speedup|less time|lower latency)|(runtime|latency|duration|query time)[^.]{0,40}[0-9.]+ ?(ms|s|sec|seconds|min|minutes)([^a-z]|$)' <<<"$message" | head -3 || true)
[[ -z "$findings$perf" ]] && exit 0

seen="${XDG_CONFIG_HOME:-$HOME/.config}/claude-notes/outbound-text"
hash=$(printf '%s' "$cmd" | shasum | cut -c1-16)
[[ -f "$seen/$hash" ]] && exit 0
mkdir -p "$seen" && touch "$seen/$hash"

reason=""
[[ -n $findings ]] && reason="prose-check on outbound text (commit message or PR description):
${findings}
Rewrite these lines in a plain human voice (~/.claude/TROPES.md).
"
[[ -n $perf ]] && reason+="Performance numbers in the PR description:
${perf}
Run the benchmark-checklist skill on each one before it ships, and fix or cut any that fail.
"
deny "${reason}If a hit is a false positive, such as a code identifier, rerun the identical command and it will pass."
