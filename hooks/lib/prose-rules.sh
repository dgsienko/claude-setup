# Sourced by prose-check.sh (files as they're written) and outbound-text.sh
# (commit messages and PR/MR descriptions). Rules come from ~/.claude/TROPES.md.
# Add a rule here when you catch yourself correcting the same phrase twice.
#
# prose_findings TEXT prints one "  label: line" row per hit, at most four per rule.
prose_findings() {
  local added="$1"
  check() {
    local pattern="$1" label="$2" hits hit
    hits=$(printf '%s\n' "$added" | grep -nEi -- "$pattern" | head -4)
    [ -n "$hits" ] || return 0
    while IFS= read -r hit; do
      printf '  %s: %s\n' "$label" "${hit#*:}"
    done <<< "$hits"
  }

  check '—' 'em-dash'
  check ' -- ' 'em-dash stand-in ( -- )'
  check ' rather than | instead of |, not [a-z]' 'contrastive (say what it IS)'
  check '(it|this|that) (is|was) not .{2,60}, (it|this|that) (is|was)' 'negative parallelism'
  check '\b(leverage|utilize|delve|streamline|seamless|synergy|paradigm|tapestry|robust)\b' 'AI vocabulary'
  check '\b(unleash|unlock|supercharge|turbocharge|skyrocket|revolutioniz|empower|elevate|foster|facilitate|harness|captivat|resonat)\w*\b' 'AI verb'
  check '\b(cutting.edge|game.chang|stellar|compelling|formidable|fast.paced|future.ready|mind.blowing)\w*\b' 'AI adjective'
  check '\b(realm|arena|arsenal|ecosystem|cornerstone|deep dive|secret sauce|secret weapon|nutshell|perfect storm|trailblazer|digital age|landscape)\b' 'AI noun'
  check "(in today's|in the era of|in the world of|moves the needle|drive impact|unlock value|here's the (deal|thing)|let's dive in|stay tuned|sneak peek|a testament to|nestled in|feel free to reach out|i hope this helps)" 'AI phrase'
  check '\b(moreover|furthermore|albeit|nevertheless|indeed),' 'formal transition'
  check '\b(continuous improvement|strategic alignment|operational excellence|organizational efficiency|circle back|align on)\b' 'corporate filler'
  check '\b(behaviour|colour|favour|honour|labour|flavour|neighbour|catalogue|centre|licence|analys(e|ed|ing)\b|(organi|recogni|normali|initiali|seriali|summari|optimi|prioriti|customi|authori|utili|reali|minimi|maximi|standardi|categori)s(e|ed|es|ing|ation))' 'British spelling (use American)'
  check '[a-z]\.\.\.([[:space:]]|$)' 'dramatic ellipsis'
  check '\b(serves as|stands as)\b' 'the "serves as" dodge'
  check '\bland(s|ed|ing)? (in|on|at|under|inside)\b' 'lands in/on (say what happens; planes only)'
  check "(it's worth noting|worth mentioning|it bears mentioning|^importantly,|^notably,)" 'empty transition'
  check '^[[:space:]]*[-*] \*\*[^*]+\*\*:' 'bold-first bullet'
}
