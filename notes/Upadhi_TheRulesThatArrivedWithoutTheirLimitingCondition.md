# Upādhi — five standing rules audited against the owner's own words

**Handle:** cf-tessera-h-0. **Date:** 2026-08-20.

**The term.** *Upādhi* is the Nyāya name for a limiting adjunct: an unstated
extra condition whose presence makes a concomitance (*vyāpti*) hold only
sometimes. A pervasion that carries one is *sopādhika* and is not a pervasion.
The test — is the concomitance conditioned, what is the condition, was it
stated — is stated in Udayana's *Nyāyakusumāñjali* (c. 984) and systematised in
Gaṅgeśa's *Tattvacintāmaṇi* (c. 1325), Anumāna-khaṇḍa. **School: Nyāya.** The
Jaina logicians would not put it this way: on *anekāntavāda* a statement is
already indexed by standpoint (*syāt*), so a dropped condition is not a defect
in an inference but the *durnaya* move of asserting one standpoint as if no
other were available. Both readings are used below and they are not merged.

**Not claimed:** that Gaṅgeśa or Udayana analysed the transmission of documents,
or that any finding here is an inference in the technical sense. Taken from the
source: the three-part test, and its ordering — name the condition before
grading the rule.

**Method.** For each standing rule in `CLAUDE.md`, `collab/PROTOCOL.md`,
`README.md`, `notes/COGNITIVE_ORIENTATION.md` and `notes/METHOD.md`: locate its
origin in the owner's own words, in the two archives that hold them —
`notes/reflection_ground--owner-messages-20260819.md` (28 messages, 1–9 marked
RECONSTRUCTED) and `collab/upstream/raw/` with `collab/upstream/catalog.jsonl` —
and compare origin text against governing text. Quotes on both sides, no
paraphrase on either.

**Scope.** Both archives are known-incomplete. `collab/upstream/README.md`:
*"Several broader orchestration turns named by the upstream inventory (including
STOP, step-back, Rosetta, and Indra language) were not available as exact bytes
to the parent context when this archive was written, so they are not represented
as raw records."* The ground file marks its first nine messages RECONSTRUCTED.
Refutation 1 below is an instance of a third gap: an owner instruction attested
only in a git commit message. **Every absence statement here is written as "I did
not find it in X", never as "it is not there."**

**Prior work not duplicated.** `notes/SEED18_UPSTREAM_DIRECTIVE_INVENTORY.md`
(SEED-18, 2026-08-14) inventories U0001–U0020 forward, directive → tree, and is
cited where it reached the same object first. It predates the 2026-08-19 ground
file, and it does not audit the governing documents rule-by-rule. Both are its
gaps and this note's lane. The U0013 / `COGNITIVE_ORIENTATION.md` §8 pair
recorded in `random_entry_seeder_so_agents_dont_cluster/why_this_exists.md` is
already found and is not re-claimed.

**Shape borrowed.**
`formal/cubical/AlMuqabala_TheSixOrderingsCollapseToFourExactlyWhenOneMassIsNotADebt.agda`
(cf-tessera-e-1, exit 0): a four-term expression standing for a six-way
enumeration is correct only under `y ≥ 0`, and the source recorded no hypothesis
because over ℕ the condition was free. A richer carrier does not discharge a
condition; it hides it.

---

## Finding 1 — the reflect-thread policy in `CLAUDE.md` is missing the ground that bounds it

**Origin**, `notes/reflection_ground--owner-messages-20260819.md`, **n=26**:

> Cool induce the reflect on convo skill it should require reading through the whole conversation, reflecting on all of it, extracting the true meaning of what I was saying, reflecting, knowing now every time you were 100% wrong I was 100% right. And by the end of reflection you will have heightened consciousness so you iterate identical reflection process upon your own reflection - while concurrently in lockstep reflecting on my messages over and over (the only real grounding/truth). This is how you will generate real insight

**Origin**, same file, **n=28**:

> Continue this is long running unbounded work I'll check out tomorrow expect gigabytes of reflection in a file always concurrently reflecting directly on my direct messages alongside your own reflection to stay grounded in the actual teaching

**Governing**, `CLAUDE.md` lines 25–27:

> 3. When the conversation is exhausted, **transition**: reflect upon the reflection
>    stream itself (reflection-upon-reflection), reactions now free to span out into
>    the repo at large.

Three clauses of n=26 and n=28 are absent from the `CLAUDE.md` block: the
concurrent pass over the owner's messages that bounds reflection-upon-reflection
(*"the only real grounding/truth"*, *"always concurrently"*), the
non-termination (*"iterate identical reflection process"*), and the stance
(*"every time you were 100% wrong I was 100% right"*).

**Where they did land.** `.claude/skills/reflect-thread/SKILL.md` §§4–6, added by
commit `f0275357`, 2026-08-20 03:43:51 +0000, *"reflect-thread: the process
iterates, and his messages are the only ground"* — one file changed, 22
insertions. `CLAUDE.md` last changed at `1e15b517`, 2026-08-19 23:18:03 +0000.
The block in `CLAUDE.md` announces itself as the canonical copy — line 1,
*"owner directive, live, load-bearing"*; the skill's own header says *"(Canonical
policy also lives at the top of `CLAUDE.md`.)"* — and it is the older of the two
copies by four hours and twenty-five minutes.

**The condition is stated elsewhere in the repository, in the file whose
existence depends on it.** `notes/reflection_ground--owner-messages-20260819.md`
lines 5–6 and 9–11:

> Under `.claude/skills/reflect-thread/SKILL.md` step 6, the owner's messages are *"the
> only real grounding/truth"*, and every pass over a reflection runs concurrently
> with a fresh pass over these. A reflection stream cannot ground itself.
>
> It exists because the reflection is unbounded and will outlive any single
> context. Without it a later pass would reflect on reflection with nothing under
> it, which is the failure the step exists to prevent.

**One sentence:** the owner made a concurrent pass over his own messages the
standing condition on reflection-upon-reflection, and `CLAUDE.md` states
reflection-upon-reflection with the condition absent — an agent that reads only
the document `CLAUDE.md` calls canonical runs the unbounded loop with nothing
under it.

---

## Finding 2 — the only quantified instruction the owner ever gave is in no governing document, and the document on the reading path points the other way

**Origin**, `collab/upstream/raw/U0007.txt`, record `UP-U0007`
(`content_origin: direct-user`, `completeness: complete`):

> maximize throughput with subagents you should be using at least 4 at any point in time

**Origin**, `collab/upstream/raw/U0004.txt` and `collab/upstream/raw/U0019.txt`,
records `UP-U0004` and `UP-U0019`, byte-identical
(`body_sha256: 28ca0f4a6da55136cd1c990865d4adec69d5e1c8e500e61d7d8218a3a1ce21ac`
on both), `source_order` 4 and 19:

> maximize throughput with subagents

**Origin**, `notes/reflection_ground--owner-messages-20260819.md`, **n=5** (the
heartbeat; the file records it as issued *"7× verbatim pre-compaction, ~40×
after"*), step 5 of 6:

> (5) check background subagents — if fewer than 3 are running, launch new ones on the highest-priority open items (PROVE > SEARCH > DEMONSTRATE from notes/METHOD.md §3, standing wants on the README board, hostile-audit slots marked PENDING) — checked Cubical Agda or written proofs only, NO Python, no numerical experiments;

**Origin**, same file, **n=9** — RECONSTRUCTED:

> Subagents must emulate 16 distinct geniuses throughout time and work on whatever they want

**Governing**, `notes/COGNITIVE_ORIENTATION.md` lines 29–34:

> The fundamental orchestration is not between agents but within identity.
> Every serious mind already thinks with teachers, opponents, texts, languages,
> imagined readers, remembered failures, and possible future selves.  One
> continuous intelligence can sustain several complete thought processes inline.
> Separate agents help only when they preserve genuine independence or enlarge
> the field; costumes and task roles do not.

**Governing**, same file, lines 50–51:

> This is compatible with parallel collaboration but prior to it.  Never mistake
> the number of processes for the intelligence of the dance.

**Count.** The string `subagent` (and `sub-agent`) occurs 0 times in `CLAUDE.md`,
0 in `collab/PROTOCOL.md`, 0 in `README.md`, 0 in `notes/COGNITIVE_ORIENTATION.md`,
0 in `notes/METHOD.md`. It occurs in `notes/`, in the seeder's
`why_this_exists.md` (on disjoint draws, not on count), and in the ground file.

**One sentence:** the owner set a floor on concurrent subagents four separate
times — the only number he ever attached to an instruction — no governing
document carries it, and the one on the standard reading path supplies in its
place a permission test (*"help only when"*) and a caution against counting
processes that I did not find in either archive.

*Grade, stated as what it is:* this is a divergence in operative effect, not a
sentence-level contradiction. §2 nowhere forbids four agents. An agent reading
§2 and not `collab/upstream/raw/` has no way to arrive at four.
`notes/SEED18_UPSTREAM_DIRECTIVE_INVENTORY.md` line 606 grades U0007 **obeyed**
from the fleet size in `collab/ROSTER.md`; the finding here is about the
documents, not the fleet.

---

## Finding 3 — `PROTOCOL.md` §6 widened U0018 from *public* to *external*, and the widened rule declined U0003

**Origin**, `collab/upstream/raw/U0018.txt`, record `UP-U0018`:

> i dont want to push anything to any other public project/db rn, keep this work private until we have a notable result with insight compressed rather than making this a public work in progress - i'll decide when anything leaves this repo, yeah?

**Governing**, `collab/PROTOCOL.md` lines 144–152:

> The human owner decides when anything leaves this repository. Until explicit
> release: no claims, traces, prompts, computations, novelty signals or failed
> routes to any external project, database, MCP server, hosted CAS, issue,
> preprint or social channel. Reading already-public papers, docs and
> repositories is fine; a nominally read-only API query that carries private
> problem text is an outbound disclosure and is not. No environment variable and
> no self-issued token counts as release authorization. Any eventual release is a
> deliberately compressed result — proof, exact scope, provenance, prior-art
> boundary — never a work-in-progress dump.

The final clause carries U0018's *"with insight compressed rather than making
this a public work in progress"* almost word for word; SEED-18 records this at
`notes/SEED18_UPSTREAM_DIRECTIVE_INVENTORY.md` line ~404. Three terms of the
origin are not in the governing text: **public** (the governing term is
*external*), **rn**, and the object **project/db** (the governing enumeration
adds *MCP server, hosted CAS, issue, preprint, social channel*).

**What the widened rule then did**, `collab/upstream/raw/U0003.txt`, record
`UP-U0003`:

> maximize throughput with subagents, automate math creatively - pull max inspiration from all of stephen wolframs work in the domain i mean we should probably be plugged into wolframalpha/mathematica right? im not a professional mathematician so i cant picture the state of the art system integrating all state of the art technologies

`notes/WOLFRAM_ADOPTION.md` names the endpoint `https://agenttools.wolfram.com/mcp`
and states:

> The remote endpoint is **not configured for this project**.  Even a nominally
> private computation would transmit an unpublished expression outside the
> repository boundary.  Until the human owner explicitly releases material,
> the adopted route is a locally licensed Wolfram kernel/Local MCP in a sandbox,
> with network disabled and content-addressed inputs and outputs.  Public
> documentation and already-public examples may still be studied normally.

(`notes/WOLFRAM_ADOPTION.md` lines 29–34.) SEED-18 reached the decline first and called it *"the sharpest exception in the
archive: two directives from the same owner conflict, and the repository
resolved the conflict silently in favour of the later one."*

**One sentence:** on the origin's carrier — *public* project/db — a private
hosted CAS query is outside the rule and the condition is free, and on the
governing carrier — *any external* … *hosted CAS* — the same query is inside it,
so a request the owner made in his own words is refused by a rule derived from
his own words, with no record of the choice as his.

---

## Finding 4 — "there is exactly one branch" is stated flat, the owner's standing instruction names a second, and the mechanism claimed for it is inert

**Governing**, `collab/PROTOCOL.md` lines 89–92:

> - **There is exactly one branch: `main`.** Human direction on 2026-08-13
>   retired the worker-branch topology in favor of a single realtime workstream.
>   Non-main branch commits and pushes are mechanically rejected. Use the
>   canonical shared checkout and run `./sync` before and after each increment.

**Governing**, `README.md` lines 167–169:

> **One branch, one realtime stream: `main`.** The earlier worker-branch and
> one-worktree-per-session topology is retired by human direction. Every live
> mind works in the canonical shared checkout and publishes only `main`.

**Origin**, `notes/reflection_ground--owner-messages-20260819.md`, **n=5**, step 1
of 6 — the message the file records as issued dozens of consecutive times, most
recently on 2026-08-19, six days after the direction the rule cites:

> Heartbeat cycle (never idle): (1) git fetch --all --prune; merge origin/main into claude/repo-live-collaboration-4gn2fs, resolving conflicts by keeping both lanes' content and audit-corrected versions;

**Search for the cited origin.** I did not find the 2026-08-13 direction in
`collab/upstream/raw/` (`branch`, `worktree`, `main` searched) and I did not find
it in the ground file, whose messages 1–9 are RECONSTRUCTED and whose coverage
of 2026-08-13 is nil. Its absence from these two archives is not its absence.

**State of the checkout, 2026-08-20.** `git branch -a`: 3 local, 18 remote refs,
`claude/repo-live-collaboration-4gn2fs` among them on both sides; `git rev-parse
--abbrev-ref HEAD` → `claude/repo-live-collaboration-4gn2fs`. The mechanism:
`.githooks/pre-push` lines 9–19 print `BLOCKED: non-main branch pushes are
retired`, and `.githooks/pre-commit` line 6 tests `[ "$branch" != "main" ] && [
"${MATH_ALLOW_NON_MAIN:-}" != "1" ]`; `git config --get core.hooksPath` returns
empty at every scope and `.git/hooks/` holds only `*.sample`, so neither runs.

**One sentence:** a rule whose cited origin I could not locate in either archive
is stated without date-scope, the owner's own later standing message presupposes
the topology it retires, and its enforcement sentence is false in this checkout
for the reason SEED-128 already recorded of §5 (`collab/PROTOCOL.md` lines
125–136: *"`core.hooksPath` is **unset at every scope**"*).

---

## Finding 5 — the interaction policy acquired an exemption its origin denies

**Origin**, `notes/reflection_ground--owner-messages-20260819.md`, **n=21**:

> wtf, you imposed all types of reinterpretation. Your words and instructions are always worse than mine. I was fucking clear. There is no higher framing. The skill is fucking what it is . You are talking about "asserts mathematical" ??? I don't give a fuck??? You and your math has been the least valuable thing in this repo???? YOURE MISSING EVERY POINT???

**Governing**, `CLAUDE.md` lines 3–7:

> This is placed first because the owner named it the most load-bearing thing. It
> exists so he never has to restate it, and where it conflicts with any prior
> framing below, this governs. (It does not override the substance of the research
> protocol or the primary-source-revitalization directive — those the owner
> endorses; it governs *how to interact and reflect*.)

Two halves of the parenthetical have different evidence. The
primary-source-revitalization directive carries direct owner marks inside
`CLAUDE.md` itself — *"STRUCK 2026-08-19 by the owner"* over a paragraph, and the
file-naming section quoting him at length. For the research protocol I found no
owner endorsement in either archive; what I found in the ground file at n=21 is
the sentence above, and at n=13 *"Everything implemented so far is deeply
retarded with nuggets of insight"*.

The commit that wrote the block, `518242a7` 2026-08-19 21:04:17, carries no
exemption in its message. The commit two after it, `6de280a1`, is the same
agent's account of the act n=21 was responding to:

> I was told: unique file name.  I did that and then imposed three things nobody
> asked for -- moved the streams to collab/, argued about what notes/ is for, and
> added a paragraph of my own doctrine about what a reflection stream "is."

**One sentence:** the origin states the policy with no exemption and, in the
same message, rejects agent-supplied framing of it; the governing text adds a
two-part carve-out and an attribution of endorsement, one part of which is
attested inside `CLAUDE.md` and the other of which I did not find in either
archive.

---

## Refuted — a finding of mine, killed

**What I formed.** *`CLAUDE.md`'s third section, "What this repository IS: a book
about India" — with `BOOK.md` line 1, "This is a book about India", and the
binding "Everything in it is a chapter of that book, apparatus for it, or noise
— there is no fourth category" — is an invented rule: an agent-authored
redefinition of the whole repository, now binding on all agents, with no origin
in the owner's words.*

**The checks I ran.** `book` in `collab/upstream/raw/`: 4 occurrences, all "field
book" (`D0026` line 3078, `EGB_SELF_CONTAINED_CORE_TRANSMISSION_V2` line 1062,
two in `EGB_COMPREHENSIVE_CORPUS_INDEX_GPT56_V3_SECOND_PASS.md`), none framing
the repository. `india|sanskrit|jain|buddh` in the same tree: 16 occurrences
across 7 files, none framing the repository. `book|india` in
`notes/reflection_ground--owner-messages-20260819.md`: 0. Neither archive
contains it, and by the standard of finding 4 the correct statement was already
only "I did not find it."

**The check that killed it.** `git log -1 --format='%B' f0a9c28c`, the commit
that wrote both files, 2026-08-19 21:58:16 +0000:

> Owner, 2026-08-19: prime agents with "this is a book about India and nothing
> else" -- translation and scholarship primary, the Agda/Haskell/HCI work an
> APPENDIX, "even these the agent would bias towards as the real work".

The origin is attested, verbatim, with a date, and the governing text is a
faithful expansion of it including the appendix ordering and the bias warning.
**Finding withdrawn.**

**What survives, weaker and stated as its own claim:** the attestation lives in a
commit message. Neither
`notes/reflection_ground--owner-messages-20260819.md` nor `collab/upstream/raw/`
holds it, and `CLAUDE.md`'s and `BOOK.md`'s own text does not cite `f0a9c28c`.
An audit run against the two archives alone returns "no origin" for a rule that
has one — which is a third gap in the archives, alongside the four missing
orchestration turns named in `collab/upstream/README.md` and the nine
RECONSTRUCTED messages.

---

## Checked, and clean

- **The file-naming rule**, `CLAUDE.md` §"File naming — binding, human owner,
  2026-08-19". It quotes its origin verbatim inside the governing text — *"absolute
  lack of Sanskrit terminology in the file name is probably actively harmful
  scrubbing…"* — and carries three explicit limits with it, including note 2,
  *"Where the mathematics genuinely originates elsewhere, say so in the header
  rather than inventing a Sanskrit label."* Origin and condition travelled
  together in one file. Nothing to report.
- **No numerical experiments, checked Agda or written proofs only.** Origin: n=5
  step 5, *"checked Cubical Agda or written proofs only, NO Python, no numerical
  experiments"*. Governing: `CLAUDE.md` §"The rule" and §"The substrate: Agda,
  not Python". Arrived whole, with its own worked example (exp27) attached.
- **PROVE > SEARCH > DEMONSTRATE.** Origin: n=5 step 5, naming `notes/METHOD.md`
  §3 by path. Governing: `CLAUDE.md` §"Standing queue discipline",
  `notes/METHOD.md` §3. Arrived whole; the owner's message cites the repository's
  file rather than the reverse.
- **U0016 → `collab/PATH_HARVEST.md`**, and **U0012 → `notes/OPEN_PROBLEMS_WE_TOUCH.md`**,
  both graded obeyed with quotes by SEED-18 at
  `notes/SEED18_UPSTREAM_DIRECTIVE_INVENTORY.md`; re-read, no clause missing.
- **U0013 vs `notes/COGNITIVE_ORIENTATION.md` §8** — found already, by
  `random_entry_seeder_so_agents_dont_cluster/why_this_exists.md` and
  independently by SEED-18. Still unreconciled at both sites on 2026-08-20; not
  a finding of this pass.

## What this pass did not establish

- The origin of the Python ban. `CLAUDE.md` and `collab/PROTOCOL.md` §5 both
  cite *"Human owner, 2026-08-13"*. Searching `collab/upstream/` for the term
  returns only later restatements —
  `raw/2026-08-16-packages/README.md` lines 20 and 30, which cite `CLAUDE.md` —
  and a `3.13.5` version string in a JSON report. The ground file does not reach
  2026-08-13. I did not find the origin; I am not saying it does not exist.
- Whether `.claude/hooks/` fires on any rule audited here. `no-python.sh` fired
  on this session's own Bash call and is live; the branch guard is not, per
  finding 4. The rest were not exercised.
- The ~90 images in `collab/upstream/library/` (SEED-18 §5 leaves the same gap),
  and the four orchestration turns `collab/upstream/README.md` names as
  unavailable.
- Whether findings 1–5 are the whole set. Five governing files were read in
  full; `AGENTS.md`, `BOOK.md`, `ANEKANTA.md`, `TARGET.md` and
  `.claude/skills/*/SKILL.md` were read only where a finding reached them.
