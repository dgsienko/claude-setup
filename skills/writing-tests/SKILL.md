---
name: writing-tests
description: Rules for which tests to write and how. Use before writing, changing or deleting any test, and when deciding whether a change needs a test at all.
---

# Writing Tests

- Every test costs pipeline time, so each one has to earn its place. Before writing a test, name the bug it would catch that no existing test already catches. If you can't name one, don't write it.
- Tests worth writing: a regression test for a real bug, business logic and edge cases where being wrong costs something, and contracts other code depends on. Tests to skip: ones that restate the implementation, exercise library or framework behavior, check trivial wiring or getters, or repeat coverage another test already has.
- Three checks before a test stays. Not vacuous: it fails if you delete the line under test or stub the function to return None. Behavioral: it asserts what a caller sees (a return value, a row written, an event emitted, an error raised). Mock call counts, substrings of generated SQL and private state tie the test to the implementation, so cut those. Not redundant: if another test already drives the same path, add a parametrize case there or skip it.
- When a change needs many tests, question the code first. A helper whose cache and backoff paths need six tests is usually a helper that shouldn't cache or back off.
- Deleting tests counts as progress. When a change makes a test obsolete or a new test subsumes an old one, remove the old one in the same MR.
- Default to feature tests: exercise the code the way its caller does (real API requests in-process against a containerized DB, mocking only IO we don't control). They survive refactors, and a bug report becomes the regression test. Keep granular unit tests for pure, complex logic (recurrence, money, timezones, parsers). Reuse running infrastructure so feature tests stay fast: one container or DB per session, with each test truncating tables or deleting the rows it wrote. Prefer extending an existing test (a new parametrize case) over a new test file.
