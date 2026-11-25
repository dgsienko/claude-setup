Review this conversation and my Claude Code configuration to identify improvements. Follow these phases strictly.

> Scope: `/reflect` is the judgment-driven pass over identity, preferences, and config. Phase 4 memory writes must follow the standard memory convention in CLAUDE.md.

## Phase 1: Gather Context

Read these files to understand current configuration:

**Global:**

- `~/.claude/CLAUDE.md` (global instructions)
- `~/.claude/TROPES.md` (writing patterns to avoid)
- `~/.claude/output-styles/direct.md` (output style)

**Project-specific (if in a project):**

- Any CLAUDE.md / AGENTS.md in the current working directory or its parents
- The project memory directory and its MEMORY.md index

**Settings:**

- `.claude/settings.json` and `.claude/settings.local.json` (if they exist)

Then review the full conversation history in your context window.

## Phase 2: Analyze

Look for:

- **Corrections I gave you** that aren't captured in CLAUDE.md, feedback memories, or the output style. "Can we" directives, "don't do X", "stop doing Y", or confirming a non-obvious approach worked.
- **Preferences I demonstrated** through repeated behavior (not just stated once).
- **Project context** — ongoing work, team dynamics, deadlines, or external references worth saving as project/reference memories.
- **Permission gaps** — tools or MCPs I approved during the session that should be persisted in settings.
- **Stale information** — anything in memory or config files that's now outdated based on what happened in this session.

Do NOT flag:

- Code patterns, file paths, or architecture (derivable from code)
- Anything already captured in the relevant files
- Ephemeral task details that won't matter next session
- Git history or debugging solutions (those live in commits)

## Phase 2b: Enforce Before Remembering

For each correction, ask whether a hook can make the mistake impossible before you propose a memory. Nothing fails when an agent skips a memory.

- A phrase or spelling in written text: add a rule to `~/.claude/hooks/lib/prose-rules.sh`. It covers written files and the text in commit messages and PR descriptions.
- A command shape (a flag, a trailer, a target): add a check to a PreToolUse hook, such as `outbound-text.sh`.
- A judgment call: write the memory.

Prove a new rule against history before proposing it: replay the last 60 days of transcripts under `~/.claude/projects` through it, and report how often it would have fired and on what. If an existing memory's mistake happened again, propose the hook.

## Phase 3: Present Findings

Present each finding as a numbered list, grouped by target file. For each:

1. What you observed (quote me if possible)
2. What file to update and what the change would be
3. Why this improves future sessions

Wait for my approval before making any changes. I may approve all, some, or none. I may also refine suggestions.

## Phase 4: Implement

For each approved change:

- Edit the target file directly
- For new memories: create the file with proper frontmatter, then update MEMORY.md index
- For existing memories: update in place if the topic matches, create new file if it's a distinct topic
- State what you changed after each edit (one line)

When done, list what was updated.
