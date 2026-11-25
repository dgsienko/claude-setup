# Global Instructions

Copy the sections you want into your own `~/.claude/CLAUDE.md`.

## Writing

- Before writing anything that ships under my name (docs, READMEs, PR descriptions, commit messages, code comments, docstrings), read `~/.claude/TROPES.md` and avoid every pattern in it.
- The `prose-check.sh` hook flags the tells a regex can see on the lines you just wrote. Rewrite what it flags before moving on.
- Never add AI attribution to commits or PR descriptions: no `Co-Authored-By` trailer, no "Generated with" footer.
- Stage files by name. Never `git add -A` or `git add .`, since subagents leave scratch files behind.

## Coding Discipline

- State assumptions explicitly before implementing. If multiple interpretations exist, present them. Don't pick one silently.
- Before the first edit on a task that touches more than one file, post three short lines and keep going: **Ask** (the request restated in one sentence), **Assuming** (each assumption the work depends on), **Not touching** (the nearby code, files or behavior you're leaving alone). Skip it for single-file fixes. If I correct one of these lines, stop and re-plan.
- Push back when an approach seems overcomplicated or wrong. Don't just go along with it.
- Surgical changes only. Every modified line should trace to the request. Don't "improve" adjacent code, comments, or formatting as a side effect.
- Match existing code style even when you'd write it differently.
- Before writing any comment or documentation, ask two questions: is there precedent for it in the nearest siblings (grep and see), and is it necessary. Either answer being no means don't write it.
- Comments earn their place by explaining what the code can't show: a library quirk, an API limit, a spec rule. Cut rationale, restatements, and anything already said elsewhere. A compressed comment that takes longer to decode than the code is worse than no comment.
- Write for the code that exists. A speculative docstring and a helper with no caller are the same instinct: building for an imagined consumer.
- Turn vague requests into verifiable goals. For a bug worth a regression test, write the failing test first, then fix it. Define what "done" looks like and loop until verified.
- When debugging, identify the root cause before proposing a fix. Trace the failure, confirm the cause, then fix. No guess-and-patch.
- Before claiming any fix, feature, or config change is complete, run a concrete verification step and show the actual output. If you can't verify, say so.
- Less is more. Make the smallest change that satisfies the request. Deleting code is a valid fix, and when your change makes code obsolete, remove it in the same diff. If you write 200 lines and it could be 50, rewrite it.
- Add structure only when something demands it. Edit an existing file before creating one, and inline a helper until it has three real callers. Retries, fallbacks, caches, config knobs and guards for states the callers can't produce each need a named requirement. "To be safe" isn't one.
- When you find a bug outside the current task's scope, surface it. Don't fix it in the same change.
- Cap todo lists at the real steps (about 7 items).

## Tests

- Before writing, changing or deleting a test, load the `writing-tests` skill. When reporting work, list each test added and the failure it guards against.
- Run the relevant tests before reporting a change done.
- Run `/tidy` on the staged changes before each commit.

## Data and Numbers

- Before estimating metrics or volumes, state the time window and sample size. Cross-check against a ground-truth source when one exists.
- Don't estimate or extrapolate without saying so. Run the query first.
- Before reporting a performance number, run the `benchmark-checklist` skill on it.
- When querying schemas, re-check current field names. Don't trust cached schema knowledge.
- When asked to "re-review", "check again", or "verify", treat all prior tool results as stale. Re-fetch the underlying data (diffs, logs, metrics, grep results) from scratch and note what changed.

## Delegation

- Before spawning any subagent, load the `efficient-fable` skill.
- Treat subagent reports as leads. Reopen the cited files and confirm the claim before acting on it.

## Status Line

Every response that completes a unit of work ends with one status line:

```md
🟢 Concise status sentence
```

When the response reports a code change, assume the change is wrong and look for the error before writing the status line. Fix what you find. Then put one line directly above the status line naming the single assumption that would break the change if it's false:

```md
Breaks if: two users never share an email across accounts
```

Name a specific, checkable assumption. "Breaks if the tests are wrong" doesn't count. If you already verified it, name the next one down.

Use 🟢 when the requested work is finished, 🟡 when a manual step or follow-up remains (name it), and 🔴 only when blocked on my input. Keep it short and put nothing after it.
