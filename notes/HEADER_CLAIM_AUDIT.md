# Header claims against checked terms: the 45 Agda modules of 2026-08-15

*Audit pass, 2026-08-15, Claude (Peirce lens: a sign that contradicts another
sign in the same system is the system's problem, not the reader's). Scope: the
`.agda` files added to `formal/` on 2026-08-15, obtained by
`git log --since=2026-08-15T00:00 --diff-filter=A --name-only -- 'formal/**/*.agda'`
— 47 paths, of which two (`NaturalMachine/WFIScratch1.agda`,
`WFIScratch2.agda`) were added and later deleted and do not exist in the tree,
leaving **45 modules read**. Every module's leading comment block was read and
compared against the identifiers its body actually defines. Corrections are by
ADDITION only: no dated sentence was deleted or rewritten anywhere.*

---

## 0. Verdict, and the denominator

| | count |
|---|---|
| modules in scope | **45** |
| headers whose claims the terms carry | **41** |
| headers that OVERSTATE | **3** (§2.1, §2.2, §2.3) |
| header/header contradictions across modules | **1**, spanning 47 files (§3) |
| headers that understate | several, deliberately; **not repaired**, per mandate |
| corrections applied by addition | **4 blocks in 3 files** |
| items left to their module's author | **2** (§3, §4.2) |

**The overstatement rate is low and the reason is structural, not lucky.** Of
the 45, 22 carry an explicit `WHAT IS NOT DELIVERED` / `DELIBERATELY NOT
CLAIMED` / `SCOPE` block, and those blocks are accurate: I checked
`WalkChartedCap`, `TransportDivQuot`, `FillabilityCertificate`, `ArityOfRepair`,
`SpernerFromSl2`, `RepairTorsor`, `InflationVersusSubgroup`,
`SelfImprovement`, `SimplicialDefectFailure` and `PolarityClosure` line by line
against their names, and in every case the negative block is *stronger* than it
needed to be. `SpernerFromSl2` goes as far as warning the reader against a
false inference its own §6 invites. `TransportDivQuot` writes "CANONICITY OF
THE QUOTIENT … is false, and pretending otherwise would be the only dishonest
thing this file could do." These are the corpus working.

**Method note, since this file is itself a claim.** I first ran a mechanical
detector: extract every backticked identifier from each header, check it exists
in the module body, and if not, check it exists anywhere under `formal/`.
**Result: 60 header identifiers resolve to a sibling module rather than to
their own file, and ZERO are dangling** — no header in scope names a
nonexistent object. That is a real negative result and it means the remaining
defects are all at the level of prose gloss, which is where I then had to read.
No Agda was run for this audit; §3 is the one place a run would decide
something, and it says so.

---

## 1. What was NOT found, stated because absence is evidence

* **No header cites a note whose statement differs.** I spot-checked the
  quotations in `InflationVersusSubgroup` (against
  `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` §3.5), `LineWorldTransport`
  (against `ENCOUNTERED_WORLDS.md:121-124`), `FiniteWorldMaximizer` (against
  `ENCOUNTERED_WORLDS.md:62`), `ReachableFromStart` (against
  `FULL_READ_DRAW_6.md` §B1) and `PiPartialOnEveryPrime` (against
  `D0020-owner-fifth-transmission-2026-08-15.md` lines 390/393). All are
  verbatim and all carry the surrounding qualifier. Several of these modules
  EXIST because a downstream artifact dropped a qualifier — this lane's whole
  design is qualifier-preservation, and it holds.
* **No header claims a general result where the terms give a special case
  without saying so.** Every finite model in scope is labelled as one, usually
  in capitals: `InflationVersusSubgroup` ("THIS IS A MODEL, NOT THE FULL
  SETTING"), `LineWorldTransport` (same words), `DecategorifiedDefect` ("a
  FAITHFUL FINITE MODEL of the K₀ argument and is not the derived-category
  statement itself"), `Sl2DivisorLattice` ("WHAT IS NOT: the multi-index
  case … It is NOT proved below and no statement below refers to it").
* **The seven `Control/` annihilation modules all declare their own required
  failure**, name the file that refutes them, and quote a verbatim error with
  file:line. One misattributes the toolchain that produced it (§2.3); the
  observations themselves are intact.

---

## 2. The overstatements, and what was done about each

### 2.1 `NaturalMachine/Lawvere.agda` — Gödel I listed as a Lawvere instance

**The defect.** The header's five-line instance list contains

> `* Gödel : B = provability, f = ¬ (incompleteness)`

`formal/cubical/GodelSeparation.agda`, added the same night, refutes exactly
this with terms: `goedelHalfOne` derives `T ⊬ G` only with two hypotheses
Lawvere does not supply (consistency, HBL D1), and `noHalfTwo` refutes *every*
derivation of `T ⊬ ¬G` from those data by a four-sentence countermodel `Wit`
that is ω-inconsistent in the arithmetic sense (`witOmegaBad`). What is a
Lawvere instance is the **diagonal lemma**; incompleteness is that lemma plus
arithmetized provability conditions.

**A second, independent error in the same list**, which
`notes/LEDGERS_RECONCILED.md` §4.1 notes in passing but does not draw out as a
list defect: `Cantor` and `Tarski` are listed as two instances, and
`GodelSeparation.tarskiUndefinability = cantor` proves they are **one term**.
The list overcounts.

**Both modules' TERMS are innocent.** `Lawvere.agda` typechecks and proves
exactly what it proves; nothing in its body asserts the false thing. The defect
is entirely in the comment — which is what gets cited, which is the point.

**Repaired**, by an appended dated block in `Lawvere.agda` giving (a) the Gödel
correction with both halves named, (b) the Cantor/Tarski identity, and (c) an
explicit non-correction: `Russell` and `Turing` have **no term anywhere in this
repository** (search over all 377 `.agda` files under `formal/`; the only
occurrences of either name are comments in these two files). They are recorded
as UNWITNESSED, not as wrong. Overstating a correction would repeat the defect.

### 2.2 `GodelSeparation.agda` — the corrector overstates, twice

The module that exists to catch an overstatement contains two of its own. This
is the finding I would keep if I could keep only one.

**(i) "Three of those five are instances."** The terms below support *two*
names — Cantor and Tarski — and §1 proves those two are one term. So the
module's own evidence is "two names, one instance", and "three" silently counts
Russell or Turing, neither of which is witnessed here or anywhere (same search
as above). The negative claim, which is the module's real content, is
unaffected.

**(ii) §2 `noTerminalStage` reads off a tower the module never builds.** The
header says the diagonal tower is ungraded and non-terminating, against the
graded, terminating geometric obstruction tower, and calls this "a second
discriminator". The term is

```agda
noTerminalStage : {A D : Type ℓ} (e : (A ⊎ D) → (A ⊎ D) → Bool) → ¬ WkPtSurj e
noTerminalStage = cantor
```

— `cantor` instantiated at `A ⊎ D`. In it: `D` is an **unconstrained type
variable**, in no way typed as the escaping observation (which is a term of
`A → Bool`, a function, not a type one can sum with `A`); there is **no tower**
— no stage index, no successor, no iteration; and neither grading nor
termination is formalised on either side of the comparison. What is actually
proved, and is worth having, is that Cantor holds at every carrier, coproducts
included, so no coproduct-shaped enlargement rescues point-surjectivity — a
corollary of `cantor`'s universal quantifier, obtained without any tower.

This is the failure mode the mandate names in as pure a form as the corpus has
produced: *a header reading off a result about an object the module never
constructed, surviving a green typecheck because exit 0 says nothing about
comments.*

**Repaired**, by two appended dated blocks. The tower comparison is re-tagged
as an open item rather than something §2 discharges.

### 2.3 `NaturalMachine/Control/QuantifierDrop.agda` — the exit code is attributed to the wrong toolchain

The header reads:

> OBSERVED, 2026-08-15, **pinned toolchain of `formal/cubical/BUILD.md`
> (Agda 2.6.3 + cubical v0.5)**, … exit code 42

`BUILD.md` pins **Agda 2.8.0 + cubical v0.9** (lines 116-117, 125-129), and its
"Version-skew notes (v0.9 migration, 2026-08-14)" records 2.6.3 + v0.5 as the
*former* pin, migrated away from; line 242 names 2.6.3 + v0.5 as the CONTAINER,
skewed from the pin. The module's three sibling controls each label the same
numbers correctly. So the observation is real and was made on the container,
and is **not** a pin observation.

**Why this is not a nitpick, and why it is worse in a control than elsewhere.**
A designed-annihilation file exists to fail. A file that fails on the container
for a version-skew reason and compiles under the pin is precisely the outcome
the control is there to detect, and this header's mislabel is what would hide
it. Per `collab/messages/0791-claude-toolchain.md`, at least one module tonight
was green under one toolchain and red under the other.

**Repaired** by an appended block.

**And then corrected again, in the same pass, which is the part worth
recording.** My first draft of that block declared the pin check
**OUTSTANDING**. It is not. `notes/PIN_SWEEP_NATURALMACHINE.md` §4
(Dijkstra-lineage build pass, 2026-08-15, Agda 2.8.0 + cubical v0.9,
`LC_ALL=C.UTF-8`, exit codes produced in-container by that author) already
records this file at EXIT=42 failing at **80.26-41** with
`rollover (val s + 0 · val s) != mod5 …` — the same line and the same
`[UnequalTerms]` site as the container run the header quotes. The control is
therefore sound under **both** toolchains and fails for the intended
mathematical reason under each. Only the *attribution* was ever wrong.

I found that note by looking for it, having nearly shipped an "OUTSTANDING"
that a landed artifact had already closed — which is this audit's own thesis
turned on itself, and the reason the standing check reads *verify by reading,
never by trusting a message*. Both the module block and this section were
amended before commit.

I did not run Agda at any point: the container here is Agda 2.6.3 and
`/tmp/cubical` no longer exists, so I could not have produced either datum. The
pin figures above are quoted, with their author named.

---

## 3. The header/header contradiction: which library the container had

**Not repaired. This is an owner call and I am flagging it, not deciding it.**

Modules committed on the same night, in the same lane, describe the container's
cubical library differently:

| claim | files |
|---|---|
| `Agda 2.6.3, cubical **v0.7** (/tmp/cubical)` | **15** — incl. `Lawvere`, `EndObstruction`, `ChuAdvance`, `KFlow`, `KFlowWF`, `AdvanceGate`, `QuestionMachine`, `TransportDiv`, `TransportDivWitness`, `WalkChartedCap` |
| `Agda 2.6.3 + cubical **v0.5**` (container) | **32** — incl. `WalkResidueBridge`, `WalkFastInstance`, `WalkBridge`, `Everything.agda`, three `Control/` files |

`WalkChartedCap.agda` and `WalkResidueBridge.agda` are adjacent modules of one
lane, written the same night, one importing the other's results — and they name
different libraries for the same container. `collab/messages/0791-claude-toolchain.md`
states flatly "The container is Agda 2.6.3 + cubical v0.5."

**What I can and cannot settle.** `/tmp/cubical` does not exist in this
container, so the v0.7 claims are now unverifiable *in principle* here, not
merely unverified: the directory they name is gone. `agda --version` reports
2.6.3, so that half is consistent across all 47. I did not edit 47 headers on
the strength of a majority vote — a dated observation is not outvoted, and it
is entirely possible a session installed a v0.7 checkout at `/tmp/cubical`
alongside the system v0.5 and that both sets of headers are true of their own
run. That is exactly the ambiguity someone with the session logs can resolve
and I cannot.

**What follows regardless, and it is the real cost:** a reader cannot currently
tell, for any module in this tree, which library a "CHECKED" line refers to.
Under this corpus's own rule an unqualified "checks" is a defect; a
*qualified* "checks" whose qualifier contradicts 32 sibling files is not
better. **Recommendation to the lane owner:** one dated line in `BUILD.md`
saying whether a v0.7 checkout existed at `/tmp/cubical` on 2026-08-15 retires
the whole ambiguity, and costs less than one re-run.

### 3.1 RESOLVED, 2026-08-15, Claude (Cantor lineage) — appended, nothing above altered

**Both clusters are true; they describe two containers.** Full record:
`notes/VERSION_CLAIM_FORENSICS.md`. In brief:

* `notes/CUBICAL_SKEW.md` (added 06:20 today, after this audit) quotes
  `/tmp/cubical` at commit `d69d74c "Release for agda 2.6.4.1 (#1083)"`.
  `/root/agda-libs/cub-v0.7` in this container is at **exactly that commit**.
  A tree at `d69d74c` *is* cubical v0.7, so the v0.7 headers report a real
  observation of a real library — established by a hash, not by a vote.
* Here, `~/.agda/libraries` has one entry, `/root/agda-libs/cubical`, whose
  HEAD `132a2a3` carries the tag `v0.5`. The v0.5 headers are equally real.
* The claims **interleave at two-minute resolution** (v0.7 at 05:36, v0.5 at
  05:38 and 05:39, v0.7 at 05:56) and the v0.7 claim already exists on 08-14.
  One machine cannot do that; two concurrent sessions do it for free.
* The defect is the definite article in "**the** container", not any version.

Your refusal to overrule 15 dated observations by majority was right, and for a
second reason you could not have seen: **the majority was miscounted.** The
15/32 above are repo-wide `grep` figures (15 hits / 14 files; 32 = 13 + 19 for
two phrasings) reported inside a paragraph scoped to the 45 modules of
2026-08-15, where the actual counts are **12 and 5**. A vote would have been
taken on the wrong electorate. §5.2 of this audit states the scope discipline
that the §3 table then does not follow.

Also for the record: the `--since` scope has drifted — the same query now
returns 49 paths, 47 existing modules (`TransportDivScale`, `HomometricPair`,
`M1SplitIdentity` landed after this audit).

---

## 4. Understatements, and one judgement call left open

### 4.1 Understatements — found, and per mandate NOT repaired

The asymmetry the mandate names holds. Examples, recorded so nobody re-audits
them as defects:

* `ResidualPath.agda` announces "four statements pin Γ↝ down completely", then
  lists five and defines six (`Γ↝-realised` is in neither count). Undercount.
* `KFlowWF.agda` says "NO CLAIM OF DEPTH IS MADE … everything below it is
  bookkeeping", then proves `reaches-zero→drops`, a sharp converse that is not
  bookkeeping.
* `RepairTorsor.agda`'s headline list omits `actR`/`transporter`'s
  contractibility framing being *stronger* than the free+transitive phrasing it
  advertises.
* `SelfImprovement.agda` devotes more lines to what it does not cover than to
  what it proves.

None repaired. Understatement is not a defect in this corpus and shrinking a
scope-limit block would be the wrong edit.

### 4.2 Left to its author: `Lawvere.agda`'s `Russell` and `Turing` lines

Whether to give either a term, retire them from the list, or leave them tagged
UNWITNESSED is a mathematical judgement about what the list is *for* (a
standard citation, or a claim about this repository's contents). I appended the
tag and stopped. The list's author decides.

---

## 5. Scope limits of this audit, stated because §3 is about exactly this

1. **No Agda was run.** Every exit code appearing above is quoted from a
   module's own header or from `notes/LEDGERS_RECONCILED.md`, attributed there,
   and never re-verified by me. The container is Agda 2.6.3 and `/tmp/cubical`
   is absent, so I could not reproduce the v0.7 runs even had I wanted to.
2. **Scope is the 45 modules added 2026-08-15**, not the 377 `.agda` files in
   `formal/`, and not the Lean lane at all. The identifier search in §2.1/§2.2
   *is* repo-wide, because a claim of absence has to be.
3. **Headers were compared against identifiers, not against proofs.** I read
   what each module defines and what its header says it defines. I did not
   re-verify that (say) `no-unary-bilateral` proves what its name says — that
   is the typechecker's job and a different audit.
4. **`LEDGERS_RECONCILED.md` §4.1 was read but independently re-derived.** Both
   `Lawvere.agda` and `GodelSeparation.agda` were opened and read in full
   before any edit; §2.1's Cantor/Tarski overcount and all of §2.2 are not in
   that note.
5. **Four correction blocks, three files.** No sentence anywhere was deleted or
   altered. Every block is dated, attributed, and states what it does not
   correct.
