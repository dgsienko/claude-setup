#!/usr/bin/env bash
# Regression cases for the hooks in this directory. Each feeds a hook the JSON
# Claude Code sends and checks what comes back.
#
# Usage: ~/.claude/hooks/test.sh   (exit 1 and a FAIL line per broken case)
set -uo pipefail

hooks=$(cd "$(dirname "$0")" && pwd)
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
export XDG_CONFIG_HOME="$T/config"

failed=0
check() {
  local name=$1 want=$2 got=$3
  if [[ -z $want && -n $got ]] || [[ -n $want && $got != *"$want"* ]]; then
    echo "FAIL $name: want ${want:-nothing}, got: ${got:0:200}"
    failed=1
  fi
}
run() { local hook=$1; shift; jq -n "$@" | "$hooks/$hook" 2>&1; }

# prose-check: written files get the tells; memory files are exempt.
check "prose: AI vocabulary" "AI vocabulary" "$(run prose-check.sh '{tool_input:{file_path:"/x/a.md",content:"We leverage the cache."}}')"
check "prose: British spelling" "British spelling" "$(run prose-check.sh '{tool_input:{file_path:"/x/a.md",content:"Keeps the behaviour."}}')"
check "prose: clean text" "" "$(run prose-check.sh '{tool_input:{file_path:"/x/a.md",content:"Reads the config once at startup."}}')"
check "prose: memory exempt" "" "$(run prose-check.sh --arg f "$HOME/.claude/projects/p/memory/MEMORY.md" '{tool_input:{file_path:$f,content:"- [a](a.md) — b"}}')"

# outbound-text: commit and PR text, plus staging rules.
cmd() { run outbound-text.sh --arg c "$1" '{tool_input:{command:$c}}' | jq -r '.hookSpecificOutput.permissionDecisionReason // empty'; }
check "outbound: git add -A" "stage files by name" "$(cmd 'git add -A')"
check "outbound: git add path" "" "$(cmd 'git add src/a.py')"
check "outbound: AI trailer" "AI attribution" "$(cmd $'git commit -m "Fix\n\nCo-Authored-By: Claude <noreply@anthropic.com>"')"
check "outbound: grep pattern is not prose" "" "$(cmd 'grep -nE "—| -- |rather than" x.md; git commit -m "Fix filter" -- a.py')"
check "outbound: British in PR" "British spelling" "$(cmd 'gh pr edit 1 --body "Keeps the colour"')"
check "outbound: retry passes" "" "$(cmd 'gh pr edit 1 --body "Keeps the colour"')"
check "outbound: perf claim in PR" "benchmark-checklist" "$(cmd "gh pr edit 1 --body \"Runs drop from 276s to 181s. $$\"")"
check "outbound: count is not perf" "" "$(cmd 'gh pr edit 1 --body "Adds 3 columns to the export"')"
check "outbound: perf in commit passes" "" "$(cmd 'git commit -m "Cut runtime from 276s to 181s" -- a.py')"

[[ $failed == 0 ]] && echo "all hook tests pass"
exit $failed
