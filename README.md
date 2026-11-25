# claude-setup

The parts of my Claude Code setup that keep output from reading as AI slop and make the agent prove its work before it says it's done. The layout mirrors `~/.claude`, so each file copies straight across.

## What's here

| Path | What it does |
| --- | --- |
| `CLAUDE.md` | Global rules for scope, verification, data checks and the end-of-turn status line. Merge the sections you want into your own. |
| `TROPES.md` | The catalog of AI writing patterns to avoid. `CLAUDE.md` points the agent at it before it writes anything. |
| `output-styles/direct.md` | Output style with a 150-word default, no recaps, no filler. Turn it on with `/output-style` or `"outputStyle": "Direct"`. |
| `hooks/prose-check.sh` | After every Edit or Write, scans the new lines for em-dashes, banned vocabulary, "X, not Y" and similar, and feeds the hits back to the agent. Nothing is blocked. |
| `hooks/outbound-text.sh` | Before a Bash call, denies AI attribution in commits, `git add -A`, and prose tells or unvetted perf numbers in commit messages and `gh pr` / `glab mr` descriptions. A prose hit only blocks once, so a false positive costs one retry. |
| `hooks/lib/prose-rules.sh` | The regex rules both hooks share. Add a rule when you catch yourself correcting the same phrase twice. |
| `hooks/test.sh` | Regression cases for both hooks. Run it after changing a rule. |
| `skills/writing-tests` | Which tests earn their pipeline time, and the checks a test passes before it stays. |
| `skills/tidy` | Cheap per-commit cleanup of the staged diff, run as a forked Sonnet subagent. |
| `skills/benchmark-checklist` | Seven questions a perf number has to survive before it goes in a PR or reply. |
| `skills/efficient-fable` | When delegating to a subagent pays off, which model to give it, and how to vet what comes back. |
| `agents/` | Two review subagents: correctness, and test coverage in both directions (missing tests and tests to delete). |
| `commands/reflect.md` | `/reflect` reviews a session for corrections worth turning into a hook or a rule. |

## Install

```bash
git clone git@github.com:dgsienko/claude-setup.git
cd claude-setup
mkdir -p ~/.claude/{hooks/lib,skills,agents,commands,output-styles}
cp TROPES.md ~/.claude/
cp hooks/*.sh ~/.claude/hooks/ && cp hooks/lib/* ~/.claude/hooks/lib/
cp -r skills/* ~/.claude/skills/
cp agents/* ~/.claude/agents/ && cp commands/* ~/.claude/commands/
cp output-styles/* ~/.claude/output-styles/
~/.claude/hooks/test.sh
```

Then merge `settings.example.json` into `~/.claude/settings.json` and the parts of `CLAUDE.md` you want into `~/.claude/CLAUDE.md`. Check for name clashes before copying over files you already have.

The hooks need `jq` and `python3`.

## Tuning it

The prose rules hold my preferences, American spelling included. Edit `hooks/lib/prose-rules.sh` to match yours and rerun `hooks/test.sh`. `efficient-fable` names models and cost figures from late 2026, so adjust those to whatever you run.
