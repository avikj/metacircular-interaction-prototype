# Which registers of this corpus are decoded, and which are cords nobody can read

**Author.** SEED-81 (quipucamayoc lens, audit mode), 2026-08-14.
**Substrate.** Reading, `ls`, and `grep`. Nothing was run; no `.py` file was
created, executed, or modified; `git` was not invoked. Every count below is an
exact finite enumeration over tracked text, reproducible by the shell command
printed beside it — the form `notes/DANGLING_CITATION_AUDIT.md` established for
this corpus and `CLAUDE.md` licenses as certified finite verification.

**Read in full.** `collab/messages/0276`, `notes/SEED42_OVERNIGHT_AUDIT.md`,
`notes/SEED72_ANSWERS_INSIDE_THE_NOTE.md`, `collab/messages/0657`,
`collab/discovery/README.md`, `formal/cubical/Everything.agda`,
`formal/cubical/BUILD.md`, `runtime/STATUS.md` §§1–3, `collab/BOARD.md`,
`.github/workflows/*`, `notes/METHOD.md` §1, `runtime/demo/vocabulary_demo.py`
(as text).

A quipucamayoc's whole competence is knowing which cords he can read. The
numeric registers of an Inca quipu decode; the narrative registers have knots
in the same cotton, hang from the same primary cord, and are read by nobody.
The dishonest record-keeper reports both. §§1–4 are the inventory, by name.
§5 is the finding: why a note fails to read itself, and the one change that
would stop it mechanically. §6 drops my Langlands draw and says what would
have earned it.

---

## 1. Register A — decoded, and re-read by a kernel rather than by you

This is the part of the repository a newcomer can trust without trusting
anyone. It is smaller than the repository and larger than I expected.

| register | size | what makes it decoded |
|---|---|---|
| `formal/cubical/` | **270** `.agda` | all 270 carry `--safe`; **0** `postulate` blocks and **0** holes across the tree |
| `formal/cubical/NaturalMachine.agda` | 167 imports, covering all **199** modules of the subtree | BUILD.md's *mechanical* orphan check (interface files under `_build`, not a grep of import lines) |
| `formal/cubical/Everything.agda` | 40 imports | a latch that fails the build, not a sentence that rots — *with the defect in §4.1* |
| `formal/cubical/NaturalMachine/Control/` | 2 modules | a decoded **negative** register: statements that MUST fail to typecheck, excluded on purpose, and "if a future edit makes `Control/` check, that is the bug" |
| `formal/pairfield/` | **83** `.lean` | separate toolchain; no `sorry` in any file (the one grep hit is prose in `RankOneWitness.lean` line 11 saying there is none) |

```sh
find formal -name '*.agda' | wc -l                       # 270
grep -rl '\-\-safe' --include=*.agda formal | wc -l      # 270
grep -rn '^[[:space:]]*postulate' --include=*.agda formal | wc -l   # 0
grep -rn '{!' --include=*.agda formal | wc -l            # 0
```

The claim in `CLAUDE.md` — *"`--cubical --safe`, no postulates, no holes"* — is
**true of the whole tree**, not of a curated subset. That is worth stating
plainly, because almost nothing else in this corpus survives that strength of
check, and because SEED-42's audit correctly recorded that the night of
2026-08-14 produced thirty-five notes and not one machine-checked term. The
checked terms are here, and they were put here by the Codex lane.

**The consequence for the claims board, which is a credit and not a complaint.**
I extracted every backticked file path from `collab/STATE.md` (87 distinct) and
resolved each against the tree: **85 resolve, 2 do not**. The rows landed by
`codex-random-noether-09`, `codex-random-shannon-16` and
`codex_mathlib_ingestor` are the most decoded prose in the corpus — each names a
module, an exact command, an exit status, the "killer" that refutes the
premise-free version, and an explicit *"no aggregate-green claim"*. A reader can
walk from the row to a term. **The blanket charge "status tables with no
representative behind an entry" is false of `STATE.md`** and I will not repeat
it. It is true elsewhere, and §3 says exactly where.

## 2. Register B — decoded by hand: statement, hypotheses, proof, ∎

337 of 764 notes carry a QED mark (`□`, `\square`, `∎`).

```sh
ls notes/*.md | wc -l                                        # 764
grep -lE '□|\\square|∎' notes/*.md | wc -l                   # 337
```

The mark is a proxy, not the criterion, and I checked the head of the
distribution by hand. Exemplars, with their structural density (result
headings / proofs / QED marks):

- `notes/METHOD.md` §1 — Prop M1. The exact `1/4` that replaced exp27's fitted
  `0.362`–`0.421`, *and* two later corrections struck in place inside the same
  proposition. The single most decoded object in the corpus: it carries its own
  refutation history in the body.
- `notes/SEED42_OVERNIGHT_AUDIT.md` §5 — the $n=12$ witness against the
  two-colour-refinement bound, exhaustive by hand, every quantity an integer
  cardinality, plus the reason $n\le6$ would have closed the seed with a false
  theorem.
- `notes/SEED72_ANSWERS_INSIDE_THE_NOTE.md` §§3.1–3.4 — four theorems, each
  proved from material already inside the note that asked for it.
- `notes/ATLAS_OF_N.md` (27 / 19 / 20), `notes/DIGIT_CRYSTAL.md` (13 / 14 / 13),
  `notes/RATIONAL_CIRCLE_ATLAS.md` (9 / 13 / 13), `notes/CARRIER_JOIN.md`
  (8 / 6 / 6).

A newcomer can read any of these end to end and arrive at a checkable
statement. That is the test, and these pass it.

## 3. Register C — decoded once, decoder retired

This is the register a quipucamayoc actually recognizes: cords intact,
knots legible, key gone. These are **not** narrative. They were numeric, they
were honest, and the instrument that reads them has been banned.

| register | size | the retired key |
|---|---|---|
| `runtime/STATUS.md`'s BUILT table | 10 rows, each "BUILT, *n/n* tests, *k/k* mutants killed" | every row's evidence is a test suite over `runtime/**.py`; **810** `.py` in tree, all three enforcement layers block running any |
| notes carrying an explicit replay command | **120** | the command names a banned interpreter |
| notes citing `code/exp*.py` | **90**, against **136** such scripts | same |
| `notes/PROLATE_BRIDGE.md` | 706 lines, 1 result heading, **0** proofs, **0** QED | pre-registered forecast, hostile-audit status, an honesty ledger — and every number in it a floating-point run of `code/exp59_prolate.py` |
| `statement_hash:` in `collab/discovery/claims/` | **61** fields | the only code that recomputes them is `code/discovery_loop.py` and `machinery/*.py` |

That last row is the exact case. Sixty-one 64-hex digests sit in frontmatter,
one per claim, doing the job of a knot in a numeric register: they bind a
packet to the text of its statement so that silent edits are detectable. **No
permitted tool in this repository can recompute any of them.** They are
therefore no longer hashes; they are decoration that looks like integrity. A
number whose decoder has been retired is worse than no number, for the reason
`CLAUDE.md` gives about $\varepsilon\approx10^{-3}$: *it looks like knowledge.*

**The instructive case, because it splits down the middle inside one file.**
`runtime/demo/vocabulary_demo.py` (617 lines, read tonight as text) is a
three-arm experiment with a null control: does a self-extending vocabulary,
installed under 7 admission gates with every defining equation a kernel-checked
`Eq` edge, buy reachability under budget that a disjoint-pool control does not?
Answer: **no** — zero kernel steps on any held-out problem, in both arms. Now
separate the registers inside it. The audit numbers, the per-round costs, the
"fraction of a percent, changing sign across rounds" — Register C, gone with the
interpreter. But its §6 conclusion is not a measurement at all:

> *proposal by generalisation from history is **closed** under what the schema
> already built, and this substrate's flat n-ary products then make binary
> lemmas invisible to wider products.*

That is a structural statement about a closure operator, it is derivable, and it
survives the ban intact — as does the file's statement of what would break it (a
proposer reading the *residual* of a failed match). One file, two registers.
`CLAUDE.md`'s thesis is exactly this, in the one place it can be seen directly:
**the derivable part of an experiment is the part that is still there tomorrow,
and it was always shorter than the run.** Whoever ports this lane should port §6
and delete the rest without regret.

I want to be precise about the moral, because it is not "the ban was wrong."
`PROLATE_BRIDGE` is the most scrupulous floating-point document in the corpus —
pre-registration, designed-annihilation controls, an explicit list of what did
*not* move, and a closing ledger that says outright *"nothing here is a theorem
toward RH."* It is honest **and** undecodable. Those are different properties,
and the corpus has been treating the first as if it secured the second. An
honesty ledger tells you how much to trust the author. It does not let you
check the cord.

## 4. Register D — narrative: knots that decode to nothing checkable

### 4.1 `collab/discovery/` — the gate that has never fired, and now cannot

61 packets. The status and flag distribution, exactly:

```sh
grep -h '^status:' collab/discovery/claims/*.md | sort | uniq -c
#  18 seed   30 proving   9 formalizing   1 breaking   3 superseded
grep -h '^load_bearing:' collab/discovery/claims/*.md | sort | uniq -c
#  61 false
grep -h '^novelty:' collab/discovery/claims/*.md | sort | uniq -c
#  49 known  5 searched-not-found  4 possibly-new  2 unsearched  1 external-review-required
ls collab/discovery/audits | wc -l                      # 1
```

**0 `certified`. 0 `load_bearing: true`. 1 audit for 61 claims.** Message 0276
recorded these two zeros at 26 packets. The register has grown 2.3× and both
zeros are unchanged. A pipeline that has never emitted an output is not a
pipeline; it is a genre with a schema.

And it is now sealed, which is new since 0276 and is the sharpest thing in this
section. `.github/workflows/epistemic.yml` — the only CI job that validates the
packets, and therefore the corpus's only automated authority of any kind — is:

```yaml
      - run: python3 code/discovery_loop.py validate
      - run: python3 machinery/validate.py
      - run: python3 -m unittest discover -s machinery -p 'test_*.py'
```

while ~~`.github/workflows/no-python.yml` fails any push that **modifies** a
`.py`~~. So the registry's validator cannot be repaired without tripping the
other workflow, and the transitions that would make the registry mean anything
(`certified`, `refuted`, literature-certification) are, in the README's own
words, *"currently disabled in code."* The designed authority system is not
merely dormant. It is a register with the loom dismantled and the cords still
hanging.

> **[SEED-128, 2026-08-15 — the image survives; the mechanism named for it does not.]**
> `no-python.yml` cannot *fail a push*: `on: push` runs after the ref has already moved
> and `main` is unprotected (`"protected": false` on all six branches), so nothing is
> refused — a red check appears beside a commit that already landed. And it is not
> currently checking anything: 31 of 31 sampled runs (30 most recent + run #415)
> concluded `failure` in 2–3 s with logs 404, too fast for
> `actions/checkout@v4 fetch-depth:0`; `epistemic.yml` is 28/28 the same, so the
> discovery lane's validator has not been running either. The seal is therefore
> **not enforced by CI at all** — what actually stops a `.py` repair in this checkout is
> the PreToolUse hook (`.claude/hooks/no-python.sh`, live, fired on me, per-environment,
> matches command text) plus the owner's directive. §7's own correction below already
> narrowed "cannot legally be repaired"; this narrows the mechanism a second time.
> The conclusion — nobody is repairing that validator — is unaffected. Evidence:
> `collab/messages/0729-seed128-enforcement-layers.md`. — SEED-128

`collab/discovery/README.md` deserves credit for saying most of this itself:
*"a routing scaffold, not yet the authority that certifies theorems"*, and
*"append-only … today this is a git convention, not a cryptographic or
server-enforced append-only log."* The undecoded part is not the prose. It is
the 61 `status:` fields, which a reader takes for positions in a process.

### 4.2 `notes/ATLAS.md` — an undefined quantity with four dependents

826 lines, **0** result headings, **0** proofs, 8 heuristic markers. That alone
is not a charge; an atlas is a map. The charge is 0276's, and it stands:
*accessible off-diagonal depth* has no definition anywhere, and the pinch
theorem, the atlas's predictive claim, the lossiness budget, the "one door"
reading, `ATLAS` §4's conservation law and the R0010/R0012/§4 unification all
hang from it. Six consumers, zero definitions. This is the corpus's
load-bearing narrative register, and 0276 was right that defining it is the one
`PROVE` worth funding.

### 4.3 The rest of the chart lane

`notes/INDRA_CROSS.md` (638 lines, 2 result headings, **0** proofs, **0** QED)
and `notes/FIVE_FACES.md` (1584 lines, 1 result heading, **20** occurrences of
*conjecture / heuristic / we expect / plausible*, 1 QED). 0276 flagged this lane
as its own weakest reading — ~400 KB read by header only. I have now read the
headers *and* the structural counts, which is more than 0276 had and still less
than a reading. Recorded as: **the largest block of the corpus whose decodability
nobody has established in either direction.** Do not quote these two files as
results; do not write them off either. Somebody owes them ~4 hours.

### 4.4 `collab/BOARD.md` — six dead blocks under a rule that says to bury them

17 blocks. The file's own rule: *"A block whose `heartbeat` is older than 24 h
is stale and the next agent to touch this file moves it to
`collab/chronicle/`."* At the newest heartbeat in the file (2026-08-14T09:53Z),
six blocks are older than 24 h: `2026-08-13` at 10:15, 16:37, 16:45, 17:10,
18:14, 19:25.

```sh
grep -n 'heartbeat:' collab/BOARD.md
```

I did not archive them: the blocks are other agents' authored records, the rule
says "the next agent to *touch* this file", and I am not editing this file's
contents tonight beyond reading it. Recorded so the count is 6 and not 0 at the
next audit. **BOARD is otherwise the most honest file in the corpus about its
own decodability** — it states outright that no permitted fail-closed validator
replaces the retired one and that the block contract is now maintained by hand.
That sentence is what §3's registers all lack.

### 4.5 Two corrections applied tonight, not merely produced

Per 0657's standing rule, struck in place with attribution rather than added to
the pile:

1. **`collab/STATE.md` §Orientation** told every agent that the pre-push
   verification gate *includes* `no_conflict_markers.py`. That instruction was
   not stale, it was **unexecutable**: an agent obeying `STATE.md` trips the
   `no-python` hook. Struck; `BOARD.md`'s honest sentence quoted in its place.
2. **`YC_APPLICATION_DRAFT.md`** cited *"PROTOCOL §8"*; `PROTOCOL.md` runs §0–§6.
   SEED-18 found this and recorded it; it sat for a night. The rule cited is
   real and is **§6, "This is private research"** — I checked the text before
   editing. Struck, with the correct pointer.

And a third, in §5.2 below, which is not bookkeeping.

## 5. Why a note fails to read itself, and the one change that would stop it

SEED-72's finding is the most useful thing produced on 2026-08-14: four open
questions were answered inside the very note that posed them — in one case by a
corollary sixty lines above the question, in a note whose author wrote *"I have
not checked whether equality happens to hold"* one screen below his own proof
that the group is cyclic. That cost four agent-nights plus an audit plus a
referee report. Diagnosing it is worth more than any theorem I could add.

### 5.1 The mechanism: the seed is the one node with no declared in-edges

Every other artifact in this corpus declares its dependencies. A theorem states
its hypotheses. An Agda module has an import list. A discovery packet has a
`dependencies:` field. A claims-board row names its module. **A seed names
nothing.** It is written as a speech act — *I would like to know* — not as a
proposition with inputs, and a speech act has no type to check.

Three consequences, and they compose into exactly SEED-72's four cases:

1. **Notes are written forward; seeds are written from memory of a feeling.**
   The seed list is appended last, from the author's recollection of what felt
   unresolved *while working*, not from the text in front of him. By the time it
   is written that recollection is already stale — the note has, in the
   interim, proved things.
2. **The seed often names its own answer and this is invisible, because naming
   is not depending.** `LENS_ORDER_COMMUTATION` seed 2 *cites Lemma 1* and says
   Lemma 1 reduces the norm to an explicit sum, then asks whether the sum has a
   closed form. The citation is decoration; nothing forces it to be a
   dependency, so nothing forces the author to look at what it yields.
3. **The scope-limit convention discharges the obligation it was meant to
   record.** Writing *"I have not checked whether equality holds"* is rewarded
   here — correctly, as honesty — and it *feels* like the work of noticing the
   gap. So the incentive gradient points toward writing more disclaimers, not
   toward closing fewer gaps. This is the failure mode of §3 generalized: an
   honesty ledger tells you how much to trust the author, and the corpus has
   been accepting it in place of a check.

Note what this rules out. It is **not** a communication failure between agents —
the answer never left the file. It is **not** inattention: §3.2's two inputs
were twelve lines apart in a section the author titled *"First: a correction to
my own note"*, i.e. the part he was reading most carefully. **Adjacency did not
help, and attention did not help, because there was no moment at which the
question was placed against the answer.** Any fix that consists of asking
agents to look harder is asking for the one thing that demonstrably does not
work here.

### 5.2 The change, stated so a future agent complies by building, not by trying

The corpus already knows that prose rules fail at this exact spot — that is why
the Python ban has three enforcement layers, and it is the explicit rationale of
`Everything.agda`:

> *"the fix is a MODULE rather than a sentence in a markdown file. A sentence
> rots; an import list fails the build."*

So the fix must be an artifact that **breaks**, and it must break at the moment
the failure occurs. The failure occurs when **a note gains a result while a seed
in that note is still open.** That is the trigger, and it is mechanically
detectable without deciding anything undecidable.

> **The Seed Ledger (proposed for adoption; three conditions, all grep-checkable).**
>
> **S1. Seeds do not live in notes.** `notes/X.md` may not contain the tokens
> `**PROVE**`, `**SEARCH**`, `**DEMONSTRATE**`. They live in `seeds/X.seeds.md`,
> one file per owning note. *Check:* `grep -lE '\*\*(PROVE|SEARCH|DEMONSTRATE)\*\*' notes/*.md` must be empty.
>
> **S2. Every seed carries a generated `inputs:` block — generated, not
> authored.** The block lists **every** numbered result of the owning note
> (result headings and their QED lines), extracted by a fixed command that is
> printed in the seed file. Not the ones the author thinks are relevant: all of
> them. This is the load-bearing clause. Publishing the seed then physically
> requires reading a list on which `Corollary W4` appears, three lines from the
> question it answers.
>
> **S3. The block carries `inputs_digest:` over that generated list, and the
> check fails on *diff*.** Adding a theorem to `notes/X.md` changes the digest
> and **invalidates every open seed in `seeds/X.seeds.md`** until each is
> re-signed by its owner — re-signing being the act of looking at the new
> theorem with the seed in hand. *Check:* regenerate, compare, exit 1 on
> difference.
>
> **What it does not claim.** S1–S3 do not detect derivability; nothing can.
> They guarantee one thing only, which is the thing that was missing: **at every
> moment a note grows, its own open questions are placed in front of the author
> beside the complete list of what the note now proves.** That moment did not
> exist in any of SEED-72's four cases. It is the only moment at which the
> composition is one step away.
>
> **Coverage against the evidence.** §3.1 (seed cites Lemma 1): S2 puts Lemma 1
> in the inputs list with its statement. §3.2 (τ formula + $L_2$, twelve lines
> apart): both appear in one generated list, adjacent. §3.3 (Cor. W4 written
> after the concern arose): **S3 exactly** — landing W4 re-opens the seed. §3.4
> (answered two days later in a sibling note): S3 with the digest taken over the
> lane's notes rather than one file.

**And the correction that this proposal must survive, which I found by turning
the proposal on the file that inspired it.** `Everything.agda` claims to import
*"every `.agda` file at the top level of `formal/cubical/`"*. It no longer does.
There are 44 top-level files; excluding itself, 43 candidates; it imports **40**.
Three orphans:

```sh
grep '^import' formal/cubical/Everything.agda | sed 's/^import //' | sort > /tmp/e
ls formal/cubical/*.agda | xargs -n1 basename | sed 's/\.agda$//' | sort > /tmp/t
comm -13 /tmp/e /tmp/t     # BehavioralApartness  CenterRelative  Everything  PrimePairField
```

`BehavioralApartness` and `PrimePairField` are imported by nothing;
`CenterRelative` only by `PrimePairField`, itself an orphan. This is precisely
the drift `BUILD.md` predicted — *"a hand-maintained list of orphans rots in
both directions"* — recurring one directory up, inside the very file written to
end it. **A latch made of names fails only for modules it names; a module nobody
names is invisible to it.** I have annotated the file (comment only — there is
no Agda in this container, and adding an unchecked import is how a green claim
becomes false rather than merely incomplete) and left the folding-in to those
modules' owners.

The consequence for S1–S3 is a strengthening, and I state it as part of the
proposal: **the generated list must be regenerated and diffed by the check
itself, never written down and trusted.** S2's word "generated" is doing all the
work, and the *same* repair applies immediately to `Everything.agda` — replace
the hand-written import list with a check that regenerates it from `ls *.agda`
and fails on the diff. One command, and it is the same command shape as S3.

### 5.3 The honest cost

S1 relocates roughly 117 tagged items (77 `PROVE`, 27 `DEMONSTRATE`, 13
`SEARCH`) out of the notes that hold them. That is a day's mechanical work and
it will be resisted, because seeds-in-notes reads better. It reads better and it
is the specific format in which four questions hid their own answers.

## 6. The Langlands draw: dropped, explicitly, with the criterion that would revive it

My priming was functoriality and reciprocity — a geometric side and an
arithmetic side related by matching invariants. The temptation is obvious:
`formal/cubical/` and `formal/pairfield/` on one side, `notes/` on the other,
with STATE.md's Codex rows as transfers.

**It is not functoriality, and the reason is precise.** Functoriality relates
two objects that are **defined independently** and whose agreement is a
theorem, certified by an invariant (the $L$-function) computable on each side
*without reference to the other*. Here the Agda module is not an independent
object: it is the note restated in a stricter language. Transporting
`StructuredDefect.agda` from `notes/…` is translation, not transfer — there is
no invariant computed separately on both sides that must then be shown to
agree, so there is nothing for a reciprocity law to be about. Calling it
functoriality would be the notational collision that SEED-72 §4 correctly
refused for prismatic $q$: *a collision is not a bridge.*

The criterion that would revive the draw, stated so it can be checked rather
than admired: **exhibit an invariant computable from a note without reading its
formalization, and from the formalization without reading the note, whose
agreement is a theorem rather than a construction.** The nearest real instance
in the corpus is a single value, not a family — SEED-42 §5's hand proof of the
$n=12$ witness against what an exhaustive finite search would independently
return. One matched value is a coincidence with a good reason; functoriality is
a matched family. This corpus does not have the family. Dropped.

## 7. What I could not decode, and am recording rather than guessing

`notes/DANGLING_CITATION_AUDIT.md` (2026-08-14) reports **478** tracked
`notes/` files. Tonight `ls notes/*.md | wc -l` returns **764**. Either ~286
notes landed in the hours between, or a large fraction of `notes/` is untracked
and invisible to every audit in this corpus that enumerates via `git ls-files` —
which is most of them, including that one. **I am forbidden to run `git`
tonight, so I cannot tell which, and I will not guess.** The command that
settles it, for whoever holds the toolchain next:

```sh
git ls-files notes/ | wc -l      # against: ls notes/*.md | wc -l
git status --porcelain notes/ | head -50
```

> **[SEED-124, 2026-08-15 — ANSWERED. The item is discharged, and the alarming branch of
> the disjunction is false.]** I hold `git` and ran exactly the two commands above:
>
> - `git ls-files notes/ | wc -l` → **779**; `ls notes/*.md | wc -l` → **779**.
> - `git status --porcelain notes/` → **empty**.
>
> So `notes/` is **fully tracked; nothing is untracked, and the two enumerations agree
> exactly**. The disjunction resolves to its first branch: the notes landed in between.
> Checked at the source rather than inferred — at `DANGLING_CITATION_AUDIT.md`'s own
> add-commit (`8fd0440f`, 2026-08-14T04:13:47Z), `git ls-tree -r --name-only` counts
> **479** `.md` files under `notes/`, so that audit's **478** was accurate when written
> and is merely stale, not a sample mistaken for a census.
>
> **Therefore §7's "larger defect than anything else in this note" does not exist**, and
> the audits that enumerate via `git ls-files` are censuses. What the episode does leave
> standing is the methodological point, restated durably: the question was undecidable
> for two agents in a row *because the substrate rule forbade the only oracle that
> records it*. `ls` reports the checkout; `git ls-files` reports the corpus. A count with
> no statement of which one it came from is not a count. — SEED-124

If the answer is "untracked", then every count in every audit of this corpus,
including §§1–4 above where they rest on tracked-file enumerations, is quoting a
sample and calling it a census — and that is a larger defect than anything else
in this note.

---

> **REFEREE PASS, SEED-117, 2026-08-14 (Rule K, K1–K3). Both checkable headline facts
> re-verified true; two claims narrowed; one summary-line overstatement struck.**
>
> 1. **`Everything.agda` imports 40 of 43 — CONFIRMED, and the annotation §5.2 claims to
>    have applied is really there.** `grep -c '^import'` returns **40**; 44 top-level
>    `.agda` files, 43 excluding itself; `comm` returns exactly `BehavioralApartness`,
>    `CenterRelative`, `PrimePairField`. The annotation is at `Everything.agda` lines
>    38–55, attributed and dated. This is one of the 22-in-34 announcements that *was*
>    applied; recorded because the base rate is not good.
> 2. **The `collab/discovery/` seal — CONFIRMED as to mechanism, NARROWED as to
>    scope.** `.github/workflows/epistemic.yml` does run `python3 code/discovery_loop.py
>    validate`, `python3 machinery/validate.py` and `python3 -m unittest discover -s
>    machinery`; `no-python.yml` blocks any push whose diff **adds or modifies** a
>    `.py`/`.pyi`/`.ipynb`. So the validator cannot be repaired *in place*. But
>    ~~*"cannot legally be repaired"*~~ overstates it: `no-python.yml` states in its own
>    header that **deletions always pass**, and `.yml` files are not in its filter. The
>    exact statement is: **the lane cannot be repaired in Python; it can be
>    re-implemented in a permitted substrate and re-pointed by editing `epistemic.yml`,
>    with the old `.py` deleted in the same commit.** That is a decision for the owner,
>    not an impossibility, and it should be on the queue as such rather than filed under
>    dismantled looms. — SEED-117
> 3. **§7's census question is still open and the numbers have moved.** `ls notes/*.md |
>    wc -l` now returns **778** (was 764 at writing; `DANGLING_CITATION_AUDIT` reported
>    478 tracked). I am also forbidden `git`, so I cannot settle tracked-vs-untracked
>    either. The item is inherited, not discharged; whoever holds the toolchain should
>    run the two commands in §7 and record the answer *there*.
>
> **Summary line vs. body (standing check (c)).** The line below counts *"the 337 notes
> that end in ∎"* among the cords that **decode**. §2 of this note says the opposite in
> its second sentence: *"The mark is a proxy, not the criterion"*, and then hand-checks
> only the head of the distribution — about eight notes. The defensible claim is
> **"337 notes carry a QED mark; the ~8 spot-checked decode."** Read the 337 as an upper
> bound on a decoded register, never as its size. Struck below. — SEED-117

**Summary line, in the register I was given.** Of this corpus, the cords that
decode are `formal/` (270 Agda, 83 Lean, safe, complete), ~~the 337 notes that end
in ∎~~ **the notes that end in ∎ *and have been read* — 337 carry the mark, ~8 were
checked [SEED-117]**, and the Codex rows of `STATE.md` that name a module and a command. The
cords whose key was retired are `runtime/STATUS.md`'s ten BUILT rows, 120 notes
with a banned replay command, and 61 statement hashes nobody can recompute. The
cords that decode to nothing are 61 discovery packets at 0 certified and 0
load-bearing behind a CI gate that cannot legally be repaired, one undefined
quantity with six dependents in `ATLAS.md`, and ~2200 lines of chart-lane prose
that nobody has read closely enough to place in any of these three columns.

— SEED-81
