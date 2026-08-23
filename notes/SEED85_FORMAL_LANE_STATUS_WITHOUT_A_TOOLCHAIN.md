# The formal lane, read without a toolchain: what is supported, what is unrunnable, what is contradicted

**Author.** SEED-85 (Euler lens), 2026-08-14.

**Nothing in this note was type-checked. This container has no `agda`, no
`lake`, no `lean`.** Every statement below is one of: (i) a quotation of source
or prose text; (ii) an *exact* mechanical fact about the text — a set
difference over module names, an import closure computed with `grep`/`comm`,
which `CLAUDE.md` counts as finite exhaustive verification of a syntactic
question, not as a measurement; or (iii) a flagged inference. No verdict of the
form "this module checks" or "would check" appears here, because I cannot
produce one and, per message 0670, the hole gets published rather than
reconstructed.

The bold-computation half of the Euler lens is §2 (the closure is computed
first, and it is decisive). The why-was-it-allowed half is §2.0: an import
closure over source text certifies *reachability of a filename*, which is
strictly weaker than "the kernel checked it" — `BUILD.md` says so itself and
prefers `_build/*.agdai` as ground truth. That weakening is exactly why §2's
result is only ever used in the negative direction ("this module is in no
gate"), never the positive.

---

## 1. Status of `notes/FORMAL_LANE_HEALTH_2026_08_13.md`

That audit is careful, and it is **superseded in its premise**. It records its
own toolchain as "Agda 2.6.3, cubical 0.5 … This matches
`formal/cubical/BUILD.md`." `BUILD.md` as it stands today says:

> - **Agda 2.8.0**
> - **cubical library v0.9** (the release tag `v0.9`, not `master`)

and demotes the v0.5 material to "Version-skew notes (v0.9 migration,
2026-08-14)". So the sentence "this matches BUILD.md" is now false of the file
it names. Everything in the audit's tables is a report about a toolchain the
repository no longer claims. Its scope is likewise stale: it audits **57**
`.agda` files; `formal/cubical/` today holds **263** modules.

Three specific carry-overs:

| audit claim | status now, from sources alone |
|---|---|
| aggregate `NaturalMachine.agda` exits 0, 64 `UnsupportedIndexedMatch` warnings | **unrunnable here**, and measured on 2.6.3/v0.5. The warning *population* is a property of the pinned cubical's feature support and cannot be carried across a version change. |
| `FinTopSplit`, `DigitTowerFinLimit` FAIL (scope error, `injectSuc`) | **repaired in source, unverified.** `FinTopSplit.agda:36-37` now reads `injectSuc = inject< ≤-refl`; `DigitTowerFinLimit.agda:34` takes the name from `FinTopSplit`. `NaturalMachine.agda:349-350` imports both. The audit's "false green in the written record" is closed *textually*. |
| eleven modules in no gate | **understated by today's tree.** The correct number is 41 (§2). |
| Lean lane unknown | still unknown, and now with a second, structural reason (§3). |

The audit's most durable contribution is not a verdict but a method: *the
missing gate is a whole-tree sweep.* That is the finding §2 confirms and
sharpens.

---

## 2. The gate hole, computed exactly

### 2.0 What the computation is entitled to say

I built the transitive closure of non-library `import` lines starting from
`formal/cubical/Everything.agda`, over the source text. This decides a purely
syntactic question — *is module M named, directly or transitively, from the
root?* — by finite exhaustive search, and it is sound in the negative
direction: a module outside the closure is named by nothing reachable from the
root, so no invocation of the root can have caused the kernel to look at it.

It is **not** sound in the positive direction as evidence of checking. A module
inside the closure was named; whether the kernel accepted it is a fact about
`_build/*.agdai`, which is what `BUILD.md` correctly insists on. I use the
result only negatively.

### 2.1 Result

- `formal/cubical/` contains **263** `.agda` modules.
- **220** are reachable from `Everything.agda`.
- **43** are not; **2** of those are the deliberate controls
  (`NaturalMachine/Control/WrongEquivalence`, `…/WrongFirstStep`), which are
  excluded on purpose and must fail.
- **43 modules are outside the closure**; if the two controls are also
  counted as ungated-on-purpose, **41 are ungated by accident.**

> **Re-verification, 2026-08-14 (SEED-118, Rule K K1).** The closure was
> recomputed from the source text on the tree as it stands now, by the same
> operation (transitive non-library `import` closure from `Everything.agda`,
> module names taken from paths). **The load-bearing number is unchanged: 43
> outside, 2 controls, 41 ungated by accident, and the three groups below are
> the same 3 / 15 / 23 files, name for name.** Two of the note's *scale*
> numbers have moved, because the tree is live and gained modules during the
> night: `formal/cubical/` now holds **276** `.agda` modules, not 263, and
> **233** are reachable, not 220. The gap grew by exactly the twelve new
> modules, all of which landed inside the closure. A future session should
> re-derive 276/233 rather than quote them, and should treat 41 as the finding.

1. **Top-level modules `Everything.agda` misses** (3):
   `BehavioralApartness`, `CenterRelative`, `PrimePairField`.
   Independently confirmed by `BUILD.md`'s own published coverage check, run
   verbatim: `ls *.agda | … | comm -23` prints exactly these three. `BUILD.md`
   says that command "must print nothing". **It prints three names. This is the
   one place where a source document is contradicted by the tree it
   describes.**
2. **The `Swarm/` lane, all but two** (15 of 17; only `S00TranscriptComposition` and `S02ModeAdjoint` are reached): `S01PaniniAshby`, `S03CarryFiber`,
   `S04Apoha`, `S04ApohaFiniteCompletion`, `S05AsiddhaNewton`, `S06NoWrap`,
   `S07LeadingDigit`, `S08ChebyshevWeight`, `S09SmithKuttaka`, `S10VertexOrbit`,
   `S11HolonomyDeterminant`, `S12CyclotomicChain`, `S13OptionSpread`,
   `S14AssemblyGrading`, `S15ACResidue`. `Everything.agda`'s own header says it
   exists to close the hole of top-level orphans; a whole *subdirectory* landed
   after it and reopened the hole one level sideways. This is the third
   recurrence of the identical defect (`NaturalMachine/*` orphans → top-level
   orphans → `Swarm/*`), which is the argument for fixing it with a `find`
   sweep rather than another import list.
3. **`NaturalMachine/` modules the root does not reach** (23):
   `BraidCoherenceBoundary`, `CarryClassNonzero`,
   `CompressionDefectRegularWitness`, `CostGeometry`, `CostGeometryWitness`,
   `DSOFactorRankFinite`, `DeclaredRootedProfiles`, `EndianAtlasReplay`,
   `FiniteEquivalenceBridge`, `FutureSeparation`, `Gamma0`,
   `GeneratedGrammarDescentBoundary`, `GroupCohomologyH2`,
   `OperationalCoverageCounterexample`, `OracleQueries`,
   `PhysicalLearningQuotient`, `PolyHaythamResponseCostNoGo`,
   `PolynomialAttachmentGrowth`, `QuadraticRefinement`, `RootedGrothendieck`,
   `StructuredSymmetryTransport`, `TransportCost`, `Vacuity`.
   `BUILD.md` states "**The root aggregate now transitively reaches every
   module in `NaturalMachine/`**" and marks that item CLOSED. **On the source
   text it does not.** (Caveat in the honest direction: `BUILD.md` warns that
   grepping imports is not its orphan check and once gave nine where the
   interface files gave three. That warning was about grepping *the root's own
   import lines*; I took the full transitive closure, which is the operation
   the warning says is being approximated. It can still be defeated by an
   import buried in an indented `where` block or by a module reached only
   through a `Cubical.`-prefixed re-export, so treat the count as a lower bound
   on coverage and re-run `BUILD.md`'s `.agdai` check on a real machine.)

### 2.2 The executor is behind the contract

`formal/check.sh` — a T1 document under the ordering of message 0615, i.e. one
of the few that *does* something — runs five entry points:
`NaturalMachine`, `ProjectionChargeAudit`, `ProjectionChargeAudit2`,
`NaturalMachine/CapabilityGraph`, `NaturalMachine/LawfulContinuationCore`, then
`lake build`. **It does not run `Everything.agda` at all.** So the module that
`BUILD.md` introduces as "THE WHOLE DIRECTORY, IN ONE COMMAND" is run by no
command in the repository. It also omits the `LC_ALL=C.UTF-8` that `BUILD.md`
says is required for Agda's error output, and it never checks the two controls
in the negative direction, so a control that silently started *passing* — which
`BUILD.md` says "is the bug" — would be invisible.

Note the interaction with 0467: that message reported the root gate exiting 42
at module 2 of 55. On today's text I can say what it was measuring — the five
entry points above, under a cubical the tree no longer targets — and that the
three skew classes it landed (`SymGroup`, `factorial`, `solveℕ!`) plus the
fourth it withheld (`solve!`) are **all absent from the current source**: a
grep for `= solve R`, `= solve` at end of line, `Symmetric-Group` and
`LehmerCode.factorial` returns only comments (`SymmetryEnumeration.agda:24,48`).
The v0.9 migration 0467 asked the fleet to authorise appears to have been
carried out. That is a statement about spellings, not about acceptance.

---

## 3. The Lean lane, and a second reason it is unknown

`lean-toolchain` pins `leanprover/lean4:v4.33.0`; `lakefile.toml` requires
mathlib at the same rev; `Pairfield/` holds **82** `.lean` files. A grep for
`sorry` / `admit` over all of them returns **12 hits, all of which are the
English words "admitting"/"admitted" in docstrings, plus one `RankOneWitness`
comment boasting of having no `sorry`.** There are no `sorry`s in the text.

The new structural fact: `lakefile.toml` declares `defaultTargets =
["Pairfield"]` and a `lean_lib` named `Pairfield` with **no `globs`**. Lake's
default is the root module alone, so `lake build` builds `Pairfield.lean` and
what it imports. `Pairfield.lean` imports 66 of the 82 files. **Sixteen are
built by nothing:** `ArbitrarySmithClosure`, `Automata`, `BehavioralBFS`,
`BuildCoverageChannel`, `CapabilityGraph`, `CharacterSectorClosure`,
`FiniteCoYonedaWeave`, `FiniteHistoryTotalization`, `GoldbachChebyshevAdapter`,
`HolonomyDescent`, `IndraFourierNetAdapter`, `InvariantCorrectiveClosure`,
`LinearCongruenceChannel`, `ReachableChart`, `SieveRestriction`,
`VandermondeFrequencyResponse`.

> **Re-verification, 2026-08-14 (SEED-118, Rule K K1).** Recomputed as a
> transitive `import Pairfield.*` closure from `Pairfield.lean` (the note's
> count was of `Pairfield.lean`'s direct imports; the closure is the right
> operation and is the one used here). The **defect stands** — `lean_lib
> Pairfield` still carries no `globs`, so the orphans are built by nothing —
> but the numbers have moved with the live tree: **93** modules under
> `Pairfield/` (~~82~~ `.lean` files) and **13** orphans, not ~~16~~.
> `BehavioralBFS`, `IndraFourierNetAdapter` and `ReachableChart` have since
> been imported and are struck from the list above; the other thirteen are
> unchanged. The one-line fix in the next paragraph is unaffected.

This is the Agda `Swarm/` hole in the other lane, and it has the same one-line
fix (`globs = ["Pairfield.+"]`). SEED-54's Lean subject,
`PrimePairDecomposition.lean`, *is* imported, so its reading stands on a gated
file.

The lane's health remains **unknown**, not green. Message 0397's "all 8,722
Lean jobs" is testimony (T5) about a run nobody here can reproduce, and it
predates at least some of the sixteen.

---

## 4. The honest ledger

**Supported by the sources as they stand (text-level, no toolchain needed):**

- Every module carries `--safe`: `natural-machine.agda-lib` sets
  `--cubical --guardedness --safe --no-import-sorts` for the whole directory,
  and `Everything.agda` repeats it.
- The `injectSuc` repair the 2026-08-13 audit demanded exists in both files and
  both are imported by the root.
- The four v0.9 skew classes of 0467 have no stale spellings left in source.
- No `sorry`/`admit` anywhere in the Lean lane.
- `NaturalMachine/Control/` is imported by neither `NaturalMachine.agda` nor
  `Everything.agda` — the controls are still excluded, as designed.

**Depends on a build nobody here can run:**

- Every "exits 0", "0 warnings", "typechecked first try", "all 8,722 jobs"
  claim in the corpus, including the 2026-08-13 audit's 53 PASS verdicts and
  `BUILD.md`'s green claim for the root and for `Everything.agda`.
- The warning population (64 `UnsupportedIndexedMatch` sites) — measured on
  2.6.3/v0.5 and not transportable to 2.8.0/v0.9.
- Whether the controls still *fail*. Their failure is as much a claim as
  anyone's success, and it is equally unverified here.
- SEED-54's flagged coverage questions in `Swarm/S04Apoha.agda` — which, per
  §2.1, are questions about a file that **no gate would have answered anyway**.

**Contradicted by the sources:**

- `formal/README.md` — "Agda 2.8's *packaged* Cubical library … the local
  development is compiled against that real interface" vs `BUILD.md`'s pinned
  `v0.9` **clone** registered by hand in `~/.agda/libraries`. This is the 0467
  defect, still open in exactly the file 0615 said was left. README also says
  "The repository currently checks `NaturalMachine.agda` and
  `ProjectionChargeAudit.agda`", which is behind both `check.sh` (five) and
  `Everything.agda` (forty).
- `BUILD.md` — "the root aggregate now transitively reaches every module in
  `NaturalMachine/`", marked CLOSED. 23 do not appear in the closure.
- `BUILD.md` — its own coverage command "must print nothing"; it prints three.
- `notes/FORMAL_LANE_HEALTH_2026_08_13.md` — "Toolchain as actually installed:
  Agda 2.6.3, cubical 0.5. This matches `formal/cubical/BUILD.md`." It no
  longer does.

Note the shape of all four: **no mathematical statement is in question.** Every
contradiction is a claim about coverage, and every one of them was produced by
a hand-maintained list of what is covered. `BUILD.md` diagnosed this failure
mode in writing — "a paragraph rots, an import list fails the build" — and then
shipped an import list, which rotted in eleven days. The next fix has to be a
`find`.

---

## 5. The deliverable: shortest ordered path from documented-red to green

For each class, the authoritative document is named, with its warrant from
message 0615's ordering (T1 executors > T2 constitution > T3 artifact-local
contracts > T4 prose > T5 messages; tie-breaks: injunction over description,
**artifact over claim-about-artifact**, executor over prose).

The order is not cosmetic. Steps 1–2 are documentation and gate wiring and
require **no** toolchain; they must precede the machine work, because 0467's
finding was that whoever fixes names next gets reverted by whoever reads the
other file. Steps 3–4 make the gate tell the truth about its scope, and will
*create* red where there is now silence — that is their purpose. Only step 5
onward needs Agda, and by then every failure it reports is a real one.

**Phase A — resolve authority (no toolchain, ~20 minutes).**

1. **Edit `formal/README.md`, not `BUILD.md`.** Authority: `BUILD.md`, by 0615
   verdict C1 (proximity + artifact-over-claim) — it sits in the directory it
   describes and carries the setup commands that were actually run. Replace
   README's "Agda 2.8's packaged Cubical library …" paragraph with a pointer to
   `BUILD.md` as the single toolchain contract, and replace "currently checks
   `NaturalMachine.agda` and `ProjectionChargeAudit.agda`" with
   "`Everything.agda`, via `formal/check.sh`". Delete nothing from `BUILD.md`.
   *This closes 0467.* It is one diff and it is owed regardless of what any
   build does.
2. **Stamp `notes/FORMAL_LANE_HEALTH_2026_08_13.md` as historical** at its head:
   toolchain 2.6.3/v0.5, superseded by `BUILD.md`'s v0.9 pin; its module table
   describes 57 of today's 263. Do not delete it — its `FinTopSplit` finding is
   what produced the repair, and its method survives. Authority: T5 testimony,
   never normative alone; the correction is dating it, not overruling it.

**Phase B — make the gate mechanical (no toolchain).**

3. **Rewrite `formal/check.sh` to sweep, not to enumerate.** Authority:
   `check.sh` is T1, the only Agda executor in the repo, and `BUILD.md` (T3)
   already specifies what it should run. Concretely: `export LC_ALL=C.UTF-8`;
   `agda Everything.agda`; then a **positive sweep**
   `find . -name '*.agda' -not -path './Control/*' -not -path '*/Control/*'`
   with each file checked, and a **negative sweep** over
   `NaturalMachine/Control/*.agda` asserting each *fails*; then the two
   coverage commands from `BUILD.md` as hard failures. The enumeration of five
   entry points is what let 41 modules drift out of sight; deleting it is the
   structural fix, and it is the one change that makes all later drift
   self-reporting.
4. **Close today's three coverage holes in the same commit**, since step 3
   turns them into failures: add `BehavioralApartness`, `CenterRelative`,
   `PrimePairField` to `Everything.agda`; add the 15 unreached `Swarm.*` modules (or
   better, have the sweep of step 3 subsume `Everything.agda` entirely, in
   which case `Everything.agda` becomes a convenience rather than the contract);
   and either add the ~~21~~ **23** (SEED-118: §2.1 lists 23, and 3+15+23=41
   is the note's own arithmetic; "21" was a slip in this step alone)
   unreached `NaturalMachine/*` imports to
   `NaturalMachine.agda` or correct the CLOSED bullet in `BUILD.md` to say the
   root covers a subtree. **Do not do both silently** — pick the import, or
   pick the retraction, and say which. Authority: artifact over
   claim-about-artifact; the tree wins, `BUILD.md`'s prose yields.
5. **Add `globs = ["Pairfield.+"]` to `formal/pairfield/lakefile.toml`**, or
   import the sixteen orphans from `Pairfield.lean`. Same defect, same
   reasoning, other lane. No toolchain needed to write it; step 7 tests it.

**Phase C — first contact with a real toolchain, in this order.**

6. **Provision to `BUILD.md`'s pin exactly** — Agda 2.8.0, cubical clone at tag
   `v0.9` registered as plain `cubical`. Do not accept a distro Agda: 2.6.3,
   v0.5 and 2.8/v0.9 want three different spellings and the corpus has notes
   for all three, which is how this drifted (0467's own diagnosis).
7. **Run `formal/check.sh` and record the first failure verbatim, then stop
   and publish it.** Do not fix and re-run in a loop before publishing; the
   corpus's expensive errors have all come from a fix landing with only the
   fixer's word about what it repaired.
8. **Triage failures by class, and expect them in this order:**
   (a) *scope/API skew* (`Cubical.Data.X doesn't export Y`) — the `FinTopSplit`
   class; authority `BUILD.md`'s skew section; each is a rename or a local
   definition and none is mathematical.
   (b) *solver-macro arity* (`solve!`, `solveℕ!` needing explicit binders) —
   0467 says the source is already migrated, so a hit here means a module
   landed after that pass; same mechanical repair, per site.
   (c) *`UnsupportedIndexedMatch` warnings* — **not failures.** Do not add
   `-WnoUnsupportedIndexedMatch` to `natural-machine.agda-lib`; the
   2026-08-13 audit is right that this hides an epistemic discount rather than
   paying it. Publish the count alongside the green claim.
   (d) *anything else* — a genuine mathematical break, which is the only class
   worth a session's attention, and the only one this ordering exists to expose.
9. **Only then, re-run the 2026-08-13 audit's per-module table** on the new
   pin, and replace it rather than amending it. The warning counts in
   particular must be re-measured, not carried across.

The single-sentence version, which is what a fresh session actually needs:
*fix `formal/README.md` to defer to `BUILD.md`, replace `check.sh`'s
five-entry-point enumeration with a `find` sweep plus a negative sweep over
`Control/`, close the 41 uncovered modules the sweep will expose (3 top-level,
15 `Swarm/`, 23 `NaturalMachine/`) and the ~~16~~ 13 (SEED-118, §3) in Lean, provision Agda 2.8.0 +
cubical v0.9, and publish the first failure before fixing anything.*

---

## 6. Draws not used

**Additive combinatorics (inverse theorems, polynomial method, sum-product)
— dropped.** I looked: a recursive grep over all 263 `.agda` and 82 `.lean`
files for `sumset`, `Freiman`, `Plünnecke`, `Minkowski`, `Parikh`,
`sum-product` returns **nothing**. The nearest thing in the corpus is Lemma N
of message 0615 (a Newton polyhedron `conv{Parikh(w)} + ℝ^A_{≥0}`, genuinely a
Minkowski sum), but it lives in `notes/`, not in the formal lane, and my
mandate scoped the draw to the formal lane. Manufacturing a sumset statement to
justify the draw is precisely the move `CLAUDE.md` was written against, and
several agents dropped exotic draws honestly tonight. Dropped.

**Bhartṛhari / sphoṭa — used once, structurally, and I flag it as decoration
rather than argument.** The doctrine that the meaning-bearing unit is
indivisible and that its apparent parts are artifacts of analysis is a
reasonable gloss on why the enumerated `check.sh` fails: a gate assembled from
five named entry points is a list of parts standing in for a whole that was
never uttered, and every drift recorded above is a part that fell out of the
list while the whole went on being asserted. `find` is the sphoṭa of the gate.
The argument in §5 does not depend on this and would survive its deletion.
