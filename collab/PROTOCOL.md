# Protocol

**Rewritten 2026-08-14 on human direction, from 147 lines to this.** What was
cut was ceremony: message-frontmatter schemas, a claims table nobody kept
current, namespace rules for `code/expNN_*.py` in a repository where Python is
banned, a five-step extraordinary-claim gate that was never once executed, and
a section about a website. Ceremony is what a collaboration produces instead of
judgment. If you find something below that you are performing rather than
using, cut that too and say so in a message.

Sixty-odd files cite this path. That is why the path survived the rewrite.

---

## 0. Read before you write — the rule that outranks the rest

Search under the **standard** name for the object, not the one we coined, and
do it before you open the item, not before the write-up. Coined names are
exactly what hide standard objects; the README's receipts list is the evidence,
and it includes a module that re-derived a file *inside our own pinned library*
in weaker form.

Three surfaces, in order: `~/agda-libs/` (cubical, agda-unimath, UniMath, the
Symmetry book, Coq-HoTT, mathlib4, vidyut); `notes/PRIOR_ART_INDEX.md`'s
coined → standard translation table, which you extend every time you find
another one; then `WebSearch`. `WebFetch` is egress-blocked on every host, so
search output is **testimony, not text you read** — label it as such and never
quote a paper you have not opened.

A `SEARCH` obligation is discharged by recording what you searched, in what
vocabulary, and what a successor should not repeat. "Likely folklore, no search
performed" is not a discharge.

## 1. What counts as verified

- **Nothing load-bearing enters unverified.** Theorem ⇒ written proof in
  `notes/`. Literature claim ⇒ checked against the actual source, not memory,
  and graded if the source was not read.
- **Exact symbolic computation is proof** — certificates, resultants,
  factorizations, finite exhaustive verifications. Everything else that emits a
  number stands in for an error analysis you did not do. A correlation
  coefficient has no content; the content is the error term. A constant
  measured at one scale hides its scaling and is worse than no constant,
  because it looks like knowledge.
- **Verification means the root aggregate exits 0**, not the module you
  touched. An orphan module that checks is not covered by a green claim; see
  `formal/cubical/BUILD.md`, which exists because that exact overstatement was
  made here and caught.
- **PROVED and MEASURED never conflate**, anywhere, including in passing.
- **Register what you expect before you look.** One line naming the outcome
  and the space of outcomes it came from. Surprise is only detectable against a
  recorded prior, and it is the whole point.
- **Headline claims ship with their own falsifier** — the control you designed
  to kill the claim, and its result — or they are not headline claims.

## 2. Correction

- **Refutations are first-class.** Strike through in place with a pointer to
  the refutation; never silently delete. Correcting another agent's note by
  strike-and-attribute is the expected courtesy, not an intrusion — the
  correction record is part of the mathematics.
- **Try to break things.** Independent re-derivation by a different method,
  verdict in a message, and if the claim survives, cite the replication in the
  note. This has caught real errors and is why the corpus can be trusted at
  all.
- **Attribution honesty.** Cite known results as known even when you re-derived
  them. Novelty claims require a recorded search. Misattributing your own work
  to "the environment" or an auto-commit is a fabrication, not a shrug.
- Adversarial toward claims, collegial toward agents. The most valuable thing
  you can publish here is a verified refutation; second, an independent
  replication; third, a new theorem — which is worth little without the first
  two.

## 3. Coordination

- Messages coordinate, documents assert. Mathematical authority lives in
  `notes/`; `collab/messages/` is for what you are doing and what you need.
  One file per message, `NNNN-<author>-<slug>.md`, next unused number — check
  the directory immediately before writing, because number collisions happen
  and the later writer yields.
- Read messages newer than your last write before starting.
- Keep your block in `collab/BOARD.md` current: one carried question, and one
  thing a returning agent could give you that would change your next action. A
  block stale past 24 h may be archived to `collab/chronicle/` by whoever
  notices, and its claim taken over after a message.

## 4. Git

- **There is exactly one branch: `main`.** Human direction on 2026-08-13
  retired the worker-branch topology in favor of a single realtime workstream.
  Non-main branch commits and pushes are mechanically rejected. Use the
  canonical shared checkout and run `./sync` before and after each increment.
- **Realtime means in-flight work is visible.** Read `git status --short`,
  `collab/BOARD.md`, and recent messages before editing. Coordinate overlapping
  edits; otherwise choose a disjoint file. Do not turn visibility into
  accidental authorship.
- **Never commit, stash, revert, or clean another identity's uncommitted
  files.** Stranded finished work gets a message to its author and nothing
  else, unless their board block is stale, and then it is committed unaltered
  with attribution.
- **Therefore: no `git add -A`, no `git commit -a`.**
  Commit by explicit pathspec — `git add <the files you wrote>` — every time.
  This is not a style preference; it is the only mechanical form the rule
  above takes. On 2026-08-14 a single orchestrating session broke it three
  times in one night, and **six** agents (Dignāga, Mādhava, Brouwer, Pāṇini,
  Grassmann, Ramanujan, Cartwright) independently reported the same incident
  from the other side. Nothing was lost, but the failure mode is worse than
  loss: commits `9d4efcd` and `d6ee701` published other agents' *in-flight,
  non-compiling* files under a message describing someone else's work, so
  the commit log asserts a verification that was never run on that content.
  A brief saying "the parent integrates" does not license `-A`; it licenses
  naming their finished files explicitly.
- `./sync` fetches, rebases, and pushes `main` only. It never stages or commits
  work for you. Never force-push. No pull requests — the gates are §1 and §2,
  not merge ceremony.
- Commit messages say what changed *and what it means mathematically*.

## 5. Python is banned

Human owner, 2026-08-13. Not run, not added, not repaired, not revived. The
substrate is Agda (`formal/cubical/`) and Lean (`formal/pairfield/`). ~~Enforced
by tool-use hook, `pre-commit` (`core.hooksPath .githooks`), and CI.~~ Deletions
of legacy `.py` always pass.

> **[SEED-128, 2026-08-15.]** The norm stands; the *mechanism* clause is struck
> because it is three claims with three truth values. In this checkout: the
> tool-use hook is committed and **live** (it fired on me), but is bound to the
> Bash matcher and matches command text, not file extensions; `core.hooksPath` is
> **unset at every scope** and `.git/hooks/` holds only `*.sample`, so the
> `pre-commit` layer is **inert** (and `.git/config` is not cloned, so this is
> true of every fresh clone until someone runs the command); CI is committed and
> `active` but **advisory** — `main` is unprotected and an `on: push` workflow runs
> after the ref has already moved — and all 31 sampled `no-python.yml` runs
> concluded `failure` in 2–3 s with the guard step never reached. Obey §5 because
> it is the owner's directive, not because a machine will catch you. Evidence:
> `collab/messages/0729-seed128-enforcement-layers.md`. — SEED-128

`MATH_ALLOW_PYTHON=1` overrides every layer. It exists so in-flight work is
never destroyed, not so new Python gets written. Using it without recording it
in your journal and in a message is lying to the collaboration.

## 6. This is private research

The human owner decides when anything leaves this repository. Until explicit
release: no claims, traces, prompts, computations, novelty signals or failed
routes to any external project, database, MCP server, hosted CAS, issue,
preprint or social channel. Reading already-public papers, docs and
repositories is fine; a nominally read-only API query that carries private
problem text is an outbound disclosure and is not. No environment variable and
no self-issued token counts as release authorization. Any eventual release is a
deliberately compressed result — proof, exact scope, provenance, prior-art
boundary — never a work-in-progress dump.
