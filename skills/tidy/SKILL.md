---
name: tidy
description: "Cheap single-pass cleanup of staged changes before a commit. Cuts dead code, over-engineering and low-value tests while keeping behavior identical. Use before each commit, or when asked to tidy. Use /simplify before a push."
context: fork
agent: general-purpose
model: sonnet
---

# Tidy

A per-commit cleanup that costs about the size of the staged diff. `/simplify`
is the deep, whole-branch pass and runs before a push. This one runs before
every commit and stays cheap.

You run as a forked Sonnet subagent with no conversation history. The staged
diff is your whole context. Run inline in a long session, every tool call
re-read 300k+ tokens.

Behavior stays exactly the same. Inputs, outputs, side effects, log lines and
error types do not change. If a fix would change any of them, skip it.

## Cost rules

- No further subagents.
- Read the staged diff once. Open other files only to check a specific
  finding, for example a grep for an existing helper or for other callers.
- One pass. Don't loop back for a second review after fixing.
- Batch shell work: one call for the diff, one for the greps, one test-and-lint
  run at the end.

## Step 1: Get the diff

```bash
git diff --cached --stat && git diff --cached -U3
```

Skip the rest and say "nothing to tidy" when the diff is under ~20 changed
lines, or touches only docs, config, lockfiles or generated files.

## Step 2: Check the added lines

Only lines this commit adds are in scope. Leave code that was already there
alone, and mention a problem in it only if it's a bug.

Look for:

1. Dead code: unused functions, variables, imports, parameters, branches that
   can't be reached.
2. Speculative code: config options, parameters, hooks or abstractions with no
   current caller, and code written for a future consumer.
3. Thin wrappers: a helper with one caller that adds nothing over inlining it,
   or a class that could be a function.
4. Duplication: logic that an existing helper already does. One grep for the
   obvious name is enough.
5. Defensive noise: try/except, None checks or validation for cases the
   callers can't produce.
6. Overgrown control flow: nesting that an early return flattens, or flags
   that a direct expression removes.
7. Low-value tests, judged by the `writing-tests` skill. Fold
   near-duplicate tests into a parametrize case.
8. Comments that restate the code. Leave deeper prose review to `/docs-audit`.

Match the repo's existing style. A cleanup that makes the code unlike its
neighbors is not a cleanup.

## Step 3: Fix, verify, restage

Apply all the fixes, then run the tests and linters for the touched files once.
If something fails, revert the fix that caused it and rerun. Then `git add` the
files you changed. Don't commit.

## Report

Your final message is all the parent session sees. One line per fix, or
"nothing to tidy", plus the test command and its pass count. Name anything you
spotted but left for `/simplify` because it reaches past this commit.
