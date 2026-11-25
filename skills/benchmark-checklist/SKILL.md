---
name: benchmark-checklist
description: "Vet a measured number before reporting or acting on it: a query speedup, a report runtime, a throughput, a regression, or a before/after in a PR. Checks the limiter, tuning, errors, repeat runs, end-to-end share, and whether the work happened. Use whenever you measure performance or are about to write a perf number into a PR, ticket or reply."
---

# Benchmark checklist

Use this when you produce a perf number. Answer each question with evidence from a run. Adapted from pstack's `benchmark-checklist` (MIT).

For a quick ballpark the user asked for, one run is enough. Still check questions 4 and 7, and say it was one run. A choice between options is never a ballpark.

## Before you run anything

- Write the sentence you expect to ship ("the orders query drops from 9.1s to 1.4s p50"). The questions test that sentence.
- Note the time window, the dataset and the row count the run covers.
- Run against data that looks like prod, such as a read replica, since a local DB with a few thousand rows has a different plan.

## The questions

1. **What limits it?** Name the limiter. For SQL, `EXPLAIN (ANALYZE, BUFFERS)` and read where the time goes: a seq scan, a sort spilling to disk, a nested loop over a big outer side. For Python, `py-spy` or an APM trace. A change that didn't move the number is explained by the limiter, so find it before calling the change useless.
2. **Was each side tuned the way prod runs?** Same indexes, same `work_mem`, same dataset, caches as warm as prod sees them. If one side ran on defaults, you compared configurations.
3. **Does it break a limit?** Do the arithmetic. Cutting a step that takes 10% of the run can make it at most about 11% faster. A result past a limit measured a cache, a no-op or a bug.
4. **Did it error?** Count failures and check that the output is correct. Compare row counts and totals between sides. Rejections and empty results are fast.
5. **Does it repeat?** Run each side at least 5 times, alternating A, B, A, B. Report the median and range. A gap inside the run-to-run range is no measurable difference.
6. **Does it matter end to end?** Next to a query result, measure what the user waits on: the page load, the API request, the batch job. Report the micro result as a share of that.
7. **Did the work happen?** Confirm the timed region did the work: the rows came back, the file was written, the job ran. A query that hit a cached result or returned zero rows produces a number for nothing.

## Report

- Lead with the verdict: faster, slower, no measurable difference, or inconclusive.
- Give the number with its unit, run count, range and limiter: "p50 9.1s → 1.4s, median of 5 runs per side on the read replica, range 1.3 to 1.6s, was bound by a seq scan on payments."
- Call it inconclusive when you can't name the limiter, a side ran untuned, or you couldn't check 4 and 7. Say which.
- A PR description gets one number. The runs and plans go in a notes file or the PR thread.
