---
name: efficient-fable
description: Use when deciding whether and how to delegate on an expensive model (Fable or Opus) — which work to fan out, which model to give a subagent, how to write the handoff packet, and when delegating costs more than doing it inline.
---

# Efficient Fable

Use Claude Fable as the orchestrator, architect, synthesizer, and final judge.
Use cheaper subagents for token-heavy research, coding, testing, and
summarization that do not require Fable's full judgment.

## Where Fable Shines

Reserve Fable for:

- Decomposing ambiguous work into clean parallel slices.
- Architecture, product, and safety tradeoffs.
- Reading conflicting subagent reports and deciding what matters.
- Integrating partial implementations into one coherent plan.
- Final review, risk assessment, and user-facing synthesis.

## Delegation Pattern

1. Name the expensive-token risk: large repo search, long logs, broad docs, or
   repetitive edits.
2. Split independent work into subagents before reading everything yourself.
3. Use cheaper models for research scans, inventory, search summaries, narrow
   bug hunts, browser/testing passes, test output reduction, and bounded code
   edits.
4. Ask subagents for concise evidence: files, line references, commands run,
   diffs, uncertainties, and stop conditions they hit.
5. Spend Fable tokens on the decision layer: compare results, resolve conflicts,
   choose the implementation path, and review the final patch.

Prefer parallel subagents when the slices do not depend on each other. Keep
blocking or highly coupled work local.

## Handoff Packets

Write delegated prompts as if the subagent has no useful chat context. Include
only the context it needs:

- The repo path and exact objective.
- The files, packages, or surfaces in scope and anything explicitly out of
  scope.
- The evidence format to return: files, line refs, commands, diffs, failures,
  screenshots, and uncertainty.
- The verification commands or browser flows to run, plus what success should
  look like when that is knowable.
- Stop conditions: if the code does not match the prompt, a command fails after
  a reasonable retry, or the task needs out-of-scope files, stop and report
  instead of improvising.

## When Not to Delegate

Cost scales with reading, not editing — the bill is `O(reads)`. A subagent starts
with no shared context, re-reads everything the orchestrator already read, and
works from a lossy handoff prompt. Delegating a single linear task therefore pays
the expensive read cost twice and discards grounded understanding.

Delegate when work **fans out** (independent slices, each reading only its own
files), needs **isolation** (keeping a long session's context clean), or
**amortizes reads** (one subagent making many edits). Otherwise do it inline.

For a linear task, the cheaper move is `/model sonnet` mid-session: the same
conversation, so no re-read, and the cheaper model inherits grounded context
instead of a plan document. The swap invalidates the prompt cache once, at
Sonnet's cheaper input rate — still far less than a subagent re-reading through
its own tool calls.

Measured costs (October 2026):

- A subagent's biggest cost is the cold-start cache write of its own prefix, at
  about 60% of subagent spend. Its output is a small share. So a few meaty
  agents beat many small ones, and an agent spawned early pays off over every
  remaining turn that never re-reads its payload. Near the end of a session,
  inline is cheaper for a one- to three-turn task.
- A multi-turn task in a big context costs more inline, because every tool call
  re-reads the whole context. A 16-turn `/tidy` at 330k context cost about 400k,
  about 5x a Sonnet subagent working from the diff alone.
- Delegating saves money by keeping a large payload out of the main thread's
  prefix. Reaching a cheaper model saves little.

A large context window raises the delegation bar rather than lowering it: the
orchestrator already holds grounded context cheaply, which makes the
read-duplication tax proportionally worse.

## Choosing the Subagent Model

Subagents inherit the parent model by default, which is wrong for delegated
execution. Name the model explicitly on every delegation path — the Agent tool's
`model` param and Workflow `agent()`'s `opts.model`:

- `sonnet` → coding, research, grep-heavy exploration, testing, bounded edits,
  log reduction. The normal case.
- `haiku` → trivial mechanical work: file inventory, rote find-and-replace,
  boilerplate.
- `opus` / `fable` → reserve for the orchestrator's own judgment layer. Use for a
  subagent only when the delegated task itself needs delicate synthesis or
  high-stakes review, which should be rare.

The default main thread is Opus with Fable attached as its advisor, which is
on by default. Opus calls Fable for the judgment calls listed under Where
Fable Shines, so a whole session doesn't have to run at Fable rates.

Per-commit and per-push skills that only need the diff run as forked Sonnet
skills (`context: fork`, `model: sonnet`).

The model only changes who runs a delegated task, never whether to delegate.
A linear coding task stays inline on Fable and Opus alike. Delegate it only
when it fans out, needs isolation, or amortizes reads (see When Not to
Delegate).

## Vetting Delegated Work

Treat subagent reports as leads, not facts. Before using a high-impact finding,
opening a PR, or telling the user the work is done, Fable should reopen the
important cited files, confirm the relevant line refs or failures, and review
the final diff against the task. Let lighter agents gather signal; keep
truth-judgment with Fable.

When a subagent has to return structured output, require the payload itself in
its final message. An agent that ends with "findings reported above" loses
everything it emitted mid-run; re-request via `SendMessage` instead of
proceeding on the summary.

## Common Scenarios

Treat these as soft defaults, not rigid rules:

- Research: ask lighter agents to scan docs, prior art, APIs, and repo surfaces;
  Fable decides what evidence changes the plan.
- Coding: give cheaper agents bounded edits or candidate patches; Fable owns
  shared-file coordination, integration, and final review.
- Testing: have Fable suggest the validation direction and the scripts or
  browser checks that matter. Let lighter agents run targeted tests, browser
  flows, screenshots, and log reduction, then report exact commands, failures,
  likely causes, and whether failures look flaky, environmental, or real.
- Debugging: use cheaper agents to cluster logs, reproduce issues, and try
  small fixes; Fable decides which diagnosis is most trustworthy.

If a task is tiny or the validation itself needs delicate judgment, keep it
with Fable.
