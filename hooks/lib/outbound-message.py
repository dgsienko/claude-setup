"""Print the message text a shell command sends: `git commit -m/-F` and
`gh pr create|edit -t/-b` and `glab mr create|update -t/-d`. Prints nothing when the command can't be parsed.

`$(cat FILE)` and `-F FILE` are read from disk when FILE is a literal path.
"""

import re
import shlex
import sys
from pathlib import Path

TEXT_FLAGS = {"-m", "--message", "-t", "--title", "-d", "--description", "-b", "--body"}
FILE_FLAGS = {"-F", "--file", "--body-file"}
SEPARATORS = {";", "&&", "||", "|", "&", "(", ")"}


def read(path: str) -> str:
    try:
        return Path(path).expanduser().read_text()
    except OSError:
        return ""


def main() -> None:
    lexer = shlex.shlex(sys.stdin.read(), posix=True, punctuation_chars=True)
    lexer.whitespace_split = True
    try:
        tokens = list(lexer)
    except ValueError:
        return

    out = []
    active = False
    for i, tok in enumerate(tokens):
        if tok in SEPARATORS:
            active = False
        elif tok == "commit" and "git" in tokens[max(0, i - 3) : i]:
            active = True
        elif tok in ("create", "edit", "update") and tokens[i - 1 : i] in (["mr"], ["pr"]):
            active = True
        elif active and i + 1 < len(tokens):
            value = tokens[i + 1]
            if tok in TEXT_FLAGS:
                cat = re.fullmatch(r"\$\(cat ([^\s$)]+)\)", value)
                out.append(read(cat.group(1)) if cat else value)
            elif tok in FILE_FLAGS:
                out.append(read(value))
    print("\n".join(out))


main()
