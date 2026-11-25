# AI Writing Tropes to Avoid

When writing on behalf of the user (chat messages, PR descriptions, docs, tickets, emails,
announcements), avoid these patterns. Sources: [tropes.fyi](https://tropes.fyi),
[Content Beta's overused-word list](https://www.contentbeta.com/blog/list-of-words-overused-by-ai/),
and the AI-isms of Writing Bible.

These apply to code comments and docstrings too. Readers spot the same tells there.

Any of these used once might be fine. The problem is when several appear together, or when
one is used repeatedly.

## Word Choice

- Magic adverbs — "quietly" doing the work of real analysis, plus "deeply", "fundamentally", "remarkably", "arguably".
- "Delve" and friends — the overused AI vocabulary set: certainly, utilize, leverage (as a verb), robust, streamline, harness.
- Grandiose nouns — "tapestry" for anything interconnected, "landscape" for any field. Also paradigm, synergy, ecosystem, framework.
- The "serves as" dodge — pompous substitutes for plain "is": serves as, stands as, marks, represents.
- Formal transitions — moreover, furthermore, albeit, indeed, nevertheless, thus, hence. Cut them; the sentences flow without.
- Redundant adjective pairs — "dark and brooding", "quick and agile", "simple and clean". Pick the one that's true.

## Banned Vocabulary

Do not use these, in any form (plural, tense, hyphenated, -ing/-ity/-ful). If one seems
right, the plain word is better.

**Verbs:** delve, leverage, utilize, streamline, harness, unlock, unleash, unveil, uncover,
elevate, empower, foster, facilitate, revolutionize, supercharge, turbocharge, skyrocket,
catapult, embark, navigate (unless literal), tailor, craft, hone, resonate, captivate,
boost, enhance, dive into, tap into, land in/on/at (as placement).

**Adjectives:** robust, seamless, cutting-edge, game-changing, powerful, compelling,
stellar, fantastic, formidable, nimble, scrappy, future-ready, mind-blowing, fast-paced.

**Nouns:** tapestry, landscape, realm, arena, arsenal, ecosystem, paradigm, synergy,
cornerstone, deep dive, secret sauce, secret weapon, game changer, magic, nutshell,
sea of, perfect storm, trailblazer, digital age.

**Phrases:** in today's fast-paced world, in the era of, in the world of, welcome to the
world of, moves the needle, break the bank, drive impact, unlock value, elephant in the
room, here's the deal, here's the thing, let's dive in, stay tuned, sneak peek,
a testament to, nestled in, a delicate balance, comes to the rescue, saves the day,
I hope this helps, feel free to reach out.

**Corporate filler:** continuous improvement, strategic alignment, operational excellence,
organizational efficiency, solution development, align on, circle back, per my last message.

## Sentence Structure

- Negative parallelism — "It's not X, it's Y", often with an em dash. The single most commonly identified AI tell.
- The dramatic countdown — "Not ten. Not fifty. Five hundred and twenty-three."
- Self-posed rhetorical questions — "The result? Devastating." Asking something nobody asked, then answering it.
- Anaphora abuse — repeating the same sentence opening several times in quick succession.
- Tricolon abuse — one rule-of-three is fine; three back-to-back is a pattern failure. Includes stacked triples like "workflows, decisions, and interactions".
- Empty transitions — "It's worth noting", "It bears mentioning", "Importantly", "Interestingly", "Notably".
- Superficial trailing analysis — an "-ing" phrase tacked on to fake insight: "highlighting its importance", "reflecting broader trends", "underscoring its role as".
- False ranges — "from X to Y" where X and Y aren't on any real scale with a meaningful middle.
- The colon escalation — "X is bad. Y is worse: Z." Also the general "`<generic statement>`: `<more details>`" shape, where a vague lead is followed by a colon and the sentence that should have been the whole thing.
- Announcer labels — opening a sentence or paragraph with a short label and a colon that names what's coming: "One check:", "One thing:", "Heads up:", "Quick note:", "Worth flagging:". Drop the label and say the thing, or ask the question outright ("Is A on a branch? On main the sink still writes…").
- "Lands in" / "lands on" as a placement verb — "the order lands in the failed queue", "the request lands on the worker". Never use it. Say what actually happens: it returns, it's counted as, it goes to, it becomes, it shows up as. The only allowed use is an aircraft landing.
- Dropped relative "that" — "the rows the query returns", "the fee the order carries". A noun followed straight by a clause with its own subject reads clipped. Write "the rows that the query returns".
- Causal-chain compression — collapsing two steps of cause and effect into one vague verb or noun phrase ("caps the whole schedule", "forces the driver workflow", "has nowhere to go"), leaving the reader to reconstruct the middle. Say both steps.

## Paragraph Structure

- Punchy fragments as paragraphs — short sentence fragments standing alone for manufactured emphasis.
- Listicle in a trench coat — "The first… The second… The third…" disguising a list as prose.

## Tone

- False suspense — "Here's the kicker", "Here's the thing", "Here's where it gets interesting", "Here's what most people miss".
- The patronizing analogy — "Think of it as a Swiss Army knife for your workflow."
- Invitation to futurism — "Imagine a world where…" followed by wonders contingent on agreeing with the premise.
- False vulnerability — polished, risk-free self-awareness. Real vulnerability is specific and uncomfortable.
- Asserting instead of proving — "The reality is simpler", "History is unambiguous on this point", "but none of them is the real story". If you have to say the point is clear, it isn't.
- Stakes inflation — a post about API pricing becomes a meditation on the fate of civilization. "Will define the next era of computing."
- The pedagogical voice — "Let's break this down", "Let's unpack this", "Let's dive in".
- Vague attributions — "experts argue", "industry reports suggest", "observers note", without naming anyone.
- Invented concept labels — bolting paradox/trap/creep/divide/vacuum/inversion onto a domain word and using it as established term ("the supervision paradox", "workload creep").

## Formatting

- Em-dash addiction — a human might use 2-3 per piece; AI uses 20+.
- Bold-first bullets — every bullet opening with a bolded label ("**Security**: Environment-based…"). Almost nobody writes lists this way by hand; a telltale of AI-generated READMEs, especially with emojis.
- Emphasis overload — bold and italics sprinkled for drama. Roughly one per section, and only when the word carries weight.
- Dramatic ellipses — "And then... nothing." Use a period.
- Unicode decoration — arrows and smart/curly quotes that can't be typed on a standard keyboard. Real writers produce straight quotes and -> or =>.

## Composition

- Fractal summaries — "what I'm going to tell you / what I'm telling you / what I just told you" at every level.
- The dead metaphor — one metaphor repeated 5-10 times instead of used once and dropped.
- Historical analogy stacking — rapid-fire company or tech-revolution lists to build false authority ("Apple didn't build Uber. Facebook didn't build Spotify.").
- One-point dilution — a single argument restated ten ways across thousands of words.
- Content duplication — repeating whole sections verbatim after losing track of what's already written.
- The signposted conclusion — "In conclusion", "To sum up", "In summary". The reader can feel an ending without being told.
- "Despite its challenges…" — acknowledging problems only to immediately dismiss them, then closing optimistic.
