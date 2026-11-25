#!/usr/bin/env bash
# Flags AI-tell prose patterns in text Claude just wrote: markdown docs,
# docstrings, and code comments alike. Checks only the lines added versus HEAD
# so pre-existing prose in an edited file stays quiet.
#
# Rules come from ~/.claude/TROPES.md. Findings are
# injected back into the model's context as a nudge; nothing is blocked.
set -uo pipefail

payload=$(cat)
file=$(printf '%s' "$payload" | jq -r '.tool_response.filePath // .tool_input.file_path // empty' 2>/dev/null)
[ -n "$file" ] || exit 0

case "$file" in
  # These hold the patterns themselves, so they always match themselves.
  */prose-check.sh|*/prose-rules.sh|*/hooks/test.sh|*/TROPES.md) exit 0 ;;
  # Memory files are internal notes, and the index format requires "— hook".
  */.claude/projects/*/memory/*) exit 0 ;;
  *.md|*.mdx|*.py|*.ts|*.tsx|*.js|*.jsx|*.go|*.rs|*.sql|*.tf|*.sh) ;;
  *) exit 0 ;;
esac

# The payload carries the text just written: content for Write, new_string for
# Edit, the concatenated replacements for MultiEdit. Scanning that keeps
# pre-existing prose in an edited file out of the results, with no git needed.
added=$(printf '%s' "$payload" | jq -r '
  .tool_input.content
  // .tool_input.new_string
  // ([.tool_input.edits[]?.new_string] | join("\n"))
  // empty' 2>/dev/null)
[ -n "$added" ] || exit 0

# SQL line comments open with "--", which the em-dash stand-in check counts as
# a dash pair. Strip the marker so the prose after it still gets checked.
case "$file" in
  *.sql) added=$(printf '%s\n' "$added" | sed -E 's/^([[:space:]]*)--[[:space:]]?/\1/') ;;
esac

source "$(dirname "$0")/lib/prose-rules.sh"
findings=$(prose_findings "$added")

[ -n "$findings" ] || exit 0

count=$(printf '%s' "$findings" | grep -c '')
message="prose-check: ${count} pattern(s) in $(basename "$file") read as AI-written.

${findings}
Rewrite in a plain human voice before moving on: say what the thing IS, no
em-dashes, no \"X, not Y\" or \"rather than\". Full rules in ~/.claude/TROPES.md. This covers docstrings and code comments, not just docs."

jq -n --arg msg "$message" --arg short "prose-check: ${count} AI-tell pattern(s) in $(basename "$file")" \
  '{systemMessage: $short, hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $msg}}'
exit 0
