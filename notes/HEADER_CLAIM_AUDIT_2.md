# Header claims against checked terms, pass 2: the modules the first audit did not read

*Audit pass, 2026-08-15, Claude (Hilbert lineage: the question is which
claims the formal system actually supports, and a header is a claim).
Extends `notes/HEADER_CLAIM_AUDIT.md`, whose stated scope was the 45 Agda
modules added on 2026-08-15 and whose stated limit was "the other ~332 were
not audited". Corrections here are by ADDITION only; no dated sentence was
deleted or rewritten anywhere.*

---

## 0. Verdict, and the denominator (which is not 332)

| | count |
|---|---|
| `.agda` files under `formal/cubical/` | **371** |
| `.agda` files under `formal/` (all lanes) | **379** |
| paths added since 2026-08-15T00:00 (`--diff-filter=A`, `formal/**/*.agda`) | **50** |
| candidate set = `formal/cubical/` minus that added set | **323** |
| candidates given the mechanical identifier pass | **323 (100%)** |
| candidates read header-against-terms | **34 (10.5%)** |
| dangling header identifiers found, over all 323 | **1** |
| header OVERSTATEMENTS found | **2** (§3.1, §3.2) |
| corrections applied by addition | **2 blocks in 2 files** |
| items left to the module's author | **2** (the mathematical repair in each of §3.1, §3.2) |

**The prompt's "~332" is 323 here.** The figure is `find formal/cubical
-name '*.agda'` (371) minus the 50-path added set intersected with that tree;
`comm -23` of the two sorted lists gives 323. I did not inherit the number.

**Both defects are in modules OUTSIDE my read sample.** They were surfaced by
the mechanical pass (§2), which is the finding about method: at 323 modules
the cheap pass is not merely a scoping device for the reading, it is a
detector in its own right. The first audit ran the same pass over 45 modules
and got zero hits, which is consistent with a defect rate that only becomes
visible at 7× the denominator.

---

## 1. The sampling rule, fixed before any filename was seen

Written down before inspecting the file list, and reproduced verbatim from
the working record:

> Candidate set = all `.agda` under `formal/cubical/` minus the
> 2026-08-15-added set already audited. For each candidate compute
> `git hash-object <file>` on current content; **include iff the blob
> SHA-1's first hex digit is `0` or `1`** (expected rate 2/16 = 12.5%).

Reproduce with:

```sh
while read f; do h=$(git hash-object "$f"); case "$h" in [01]*) echo "$f";; esac; done < candidates.txt
```

Realised N = **34** of 323 (10.5%; the shortfall from 12.5% is ordinary
binomial noise — sd ≈ 5.9 files). Content-addressed, so anyone can
regenerate the identical sample from the same tree state, and it cannot
correlate with subject matter, lane, author, or how interesting a filename
looks. **No module was substituted, skipped, or added.** Five of the 34
turned out to have no leading comment block at all (`ControlledGrammar`,
`DigitTowerLimit`, `IntrinsicProductiveInstall`, `PolynomialRewrite`,
`ProductiveIndraNet`); they were kept in the denominator
rather than swapped out, since "no header" is a datum about the corpus and
not a licence to redraw.

The sample, in tree order: `BehavioralApartness`, `DescentLaw`,
`M2Unimodular`, and under `NaturalMachine/`:
`AbstractSpinNetworkKinematics`, `ActionRefinement`, `ControlledGrammar`,
`Controls`, `CoprimeSplitting`, `DSOBellmanFinite`,
`DSONucleusExecutionCalibration`, `DeclaredRootedProfiles`,
`DiagonalEndpoint`, `DigitTowerLimit`, `ExactHadamardInterference`,
`FiniteNonabelianHolonomy`, `HolonomyFluxDerivation`,
`IntrinsicProductiveInstall`, `LinearOrderFinite`,
`NormalizedFiniteInstrument`, `NormalizedFrameCovariance`,
`ObservableHorizon`, `OracleQueries`, `ParetoCost`,
`PauliJointPhaseRealization`, `PolyHaythamResponseCostNoGo`,
`PolynomialRewrite`, `ProductiveIndraNet`, `ProductiveObservabilityBridge`,
`RootedIndraTotal`, `S3IntegerRelativeCoordinates`, `TransportMulWitness`,
`WalkUnconditional`; and `Swarm/S09SmithKuttaka`,
`Swarm/S11HolonomyDeterminant`.

---

## 2. The mechanical pass, over all 323

Method, repeating the first audit's at 7× scale. From each candidate's
header region (everything before its `module` line) extract every
backticked token containing no whitespace; resolve it against (a) an
identifier index built from **all 379** `.agda` files under `formal/`, (b)
the filesystem, for path-shaped tokens, (c) the token's last dotted
component, for qualified names like `Cubical.Data.Nat.Mod` or
`ChargeCriterion.neutral⇒no-separator`.

* **1879 (file, identifier) pairs; 1474 distinct identifiers.**
* First index build was wrong and the failure is worth recording: I
  tokenised on `[^A-Za-z0-9_'?-]`, which shreds every Agda name containing
  `≡`, `→`, `∣`, or a subscript, and reported **580 "dangling"** — i.e. a
  ~40% false-positive rate produced entirely by the tool. Re-splitting on
  Agda's actual delimiters (whitespace and `(){};@"`) dropped it to 55.
  *A mechanical pass with an unstated tokeniser is not evidence.*
* Of the surviving 55: 22 are external-library paths (`Cubical/…`,
  `Mathlib/…`, agda-unimath's `elementary-number-theory/`,
  `finite-group-theory/sign-homomorphism`), 14 are glob or ellipsis
  shorthands the header itself marks as such (`sec-*`,
  `tower-commutes-*`, `forever-refl/sym/trans`, `no-fibrewise-…`), 11 are
  prose or maths set in backticks (`3^k`, `[MINE]`, `anyāpoha`,
  `U/N_obs`, `⟨q,c⟩`), 7 are truncated citations whose targets I opened
  and confirmed exist (`notes/CHAIN_PAYLOAD_CLOSURE.md`,
  `notes/INDIC_FORMAL_TRADITIONS_MAP.md`,
  `notes/SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md`,
  `notes/TYPED_BOUNDED_UNFOLD.md`,
  `notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md`,
  `collab/messages/0161-codex-formation-subset-sum-carrier-result.md`,
  `collab/messages/0440-fleet-blind-r0033-audit-verdict.md`).
* One is a header identifier that names an object no module in the
  repository constructs: **`half⇒equiv`** in
  `NaturalMachine/CenterRelativeIntegral.agda`. §3.2.

Two further residues were read rather than dismissed, and both are clean:
`CertificateFibration.certIso≡curry-totalEquiv` is a name its own header
explicitly says is *not* proved ("`certIso≡curry-totalEquiv` is NOT
proved"), which is a scope statement, not a dangling claim; and
`PerspectiveCore.inhabited↛contr` is a §-label whose actual term is
`fibre-not-prop`, which proves something **stronger** (not a proposition,
hence a fortiori not contractible) — understatement, not repaired, per
mandate.

**Cross-file resolution.** Restricted to the 34-module sample, **21**
qualified header identifiers name something outside their own file
(`ChargeCriterion.neutral⇒no-separator`, `Cubical.Data.Nat.Mod`,
`NaturalMachine.WalkJumps.strip`, `Descent.Descends`, …) and a further 35
bare backticked names have no definition in their own file. All 56 resolve:
to the standard library (`Dec`, `refl`, `Fin`, `hProp`, `hPropExt`,
`SumFin`, `Type₀`), to a sibling module (`isContrOrdTotal`,
`lcmList-exists`, `prime-power-not-covered`, `zero-charac-gen`,
`isBehavioralCongruence`, `LeastNonDivisor`), to the legacy Python the
header explicitly cites (`offer` is
`machinery/descent_formation_machine.py:42`; `meet_smith` is in
`machinery/coupled_encounter_engine.py`, exactly as `ActionRefinement`'s
header says), to ordinary prose set in backticks (`q`, `action`, `value`,
`with`), or — in one case, `charge-++` — to their own file under a layout my
matcher missed. This reproduces the first audit's structural finding —
headers in this corpus cite real objects — at the larger denominator, with
the single exception of §3.2.

---

## 3. The two overstatements

### 3.1 `formal/cubical/BehavioralApartness.agda` — a one-system counterexample stated as a law

**The defect.** The header's central pair reads

> * FutureEq is a PROPOSITION (isPropFutureEq): sameness carries no data;
> * Apart is NOT a proposition (ApartNotProp): distinction carries data.

The first sentence is general and the term carries it: `isPropFutureEq` (line
113) is proved for every `(step, obs)` with `isSet Obs`. The second is a term
**inside `module Minimal`** (line 166), of type
`¬ (isProp (Apart false true))`, over one system — two states, one action,
identity dynamics, state-as-observation — at one pair of states.

Read as stated it is not merely unproved but **false**: whenever
`FutureEq x y` holds, `Apart x y` is empty and so *is* a proposition, and
nothing in the module excludes that case. The correct pairing is *sameness
is always a proposition; distinction is not always one, and `Minimal` is the
witness*, which is still an asymmetry between a theorem and a
counterexample, and is exactly what the terms give.

**The body is already right where it is local.** §5 is headed "Control", says
"The minimal witnessing system", and ends with `falseApartTrue` labelled "so
§5 is not vacuous". Only the header generalises — the same shape as
`HEADER_CLAIM_AUDIT.md` §2.2, where a module's own §-comment was accurate and
its summary was not.

**Repaired** by an appended dated block. Whether to add a general hypothesis
(two separating words of different length) and promote the counterexample to
a theorem is a mathematical judgement and is left to the author.

### 3.2 `formal/cubical/NaturalMachine/CenterRelativeIntegral.agda` — an equivalence claimed, a retract delivered

**The defect.** The "WHAT IS CHECKED" list says

> §4 `half⇒equiv` — the bridge back: given `half`, doubling is invertible
> and §2 collapses to `CenterRelative`'s T14.1. **Stated as the explicit
> inverse pair** rather than by importing …

Two things are wrong, both in the comment; the terms are innocent.

1. **`half⇒equiv` does not exist.** `grep -rn 'half⇒' formal/` returns
   exactly two lines: this header line and the definition `half⇒retract`
   (line 237). This is the mechanical pass's single hit over 323 modules,
   and it is the defect class the first audit flagged twice on 2026-08-15 —
   *a header reading off a result about an object the module never
   constructed*, surviving a green typecheck because a typechecker does not
   read comments.
2. **`half⇒retract` is one-sided.** Its type gives
   `(half · Ψ(Φ′(p,q)).fst , half · Ψ(Φ′(p,q)).snd) ≡ (p , q)` — one
   composite, scaled. The other composite (`Φ′Ψ-is-double`, §2) is never
   scaled by `half`; the file contains no `Iso`, no `≃`, and no
   inverse-pair term. The file ends at line 243 (before this audit's
   appended block), so there is nowhere else it could be. "Invertible" and
   "the explicit inverse pair" are both stronger than what is checked.

The statement is true and easy over a ring with `half`; that is not the
point. What §4 licenses today is a **left inverse up to the stated scaling**,
and it should be cited as `half⇒retract`.

**Repaired** by an appended dated block naming both errors, listing the §§1–3
and §5 identifiers that *do* match their header descriptions (all nine
checked, all present), and leaving the upgrade to the author.

---

## 4. What was NOT found, stated because absence is evidence

* **No header/header contradiction.** Nothing in the sample parallels
  `HEADER_CLAIM_AUDIT.md` §3. Version claims in this sample are homogeneous:
  the three modules that state one (`CoprimeSplitting`, `TransportMulWitness`,
  `WalkUnconditional`) all say "Agda 2.6.3, cubical v0.5, `--cubical --safe`",
  dated 2026-08-13/14 — the v0.5 cluster which `notes/VERSION_CLAIM_FORENSICS.md`
  established is a real container, not the disputed v0.7 one.
* **No header cites a note whose statement differs.** I opened the cited
  passage for four modules with substantive citations:
  `OracleQueries` → `TARGET.md` §6 item 2 (verbatim: "Then read `BARRIER.md`
  §3 Problem 2 (the oracle model: value queries vs functional-equation
  queries) against that criterion") and `notes/BARRIER.md` §3 item 2 and §4's
  honesty ledger (the header's quotation "reading Tao's published argument
  through this lens (no new analysis of it here)" is verbatim, with its
  qualifier);
  `CoprimeSplitting` → `notes/WALK_INSTALLS_ARE_JUMPS.md` §(c), whose
  (⇒)/(⇐) labels the header uses in the note's own orientation;
  `S09SmithKuttaka` → `notes/LEAN_SMITH_CERTIFICATE_GATE.md` and
  `collab/messages/workers/…--codex_arithmetic_life--0002.md`, both present;
  `LinearOrderFinite` → `NaturalMachine.AtlasResiduals`'s residue statement.
* **Every header-named theorem in the sample has a term.** Spot-verified by
  name for all 34 and by reading the full body for five
  (`BehavioralApartness`, `DescentLaw`, `M2Unimodular`, `S11HolonomyDeterminant`
  §§detShift/detClass/noSurjectivity, `OracleQueries` contents list). No
  further gap between a listed name and a definition was found.
* **`M2Unimodular` is a clean instance of the good pattern**: its header
  claims exactly three things (adjugate identities entrywise, Binet at n=2,
  ε²=1 ⇒ ε≠0) and names the one place discreteness of ℤ enters ("1 ≠ 0");
  the body's `adjL`/`adjR`, `detMul`, `unimodularNonzero` and `oneNotZero`
  (via `snotz ∘ injPos`) match line for line.

---

## 5. The scope-limit habit reproduces, at a different denominator

The first audit's strong prior — 22 of 45 modules carrying an explicit
negative-scope block, every one checked being *stronger* than needed —
**holds in this sample, and the ratio is nearly identical**.

Of the 34 modules, 5 have no leading comment block at all. Of the remaining
29, **22 carry an explicit negative-scope statement.** Classified by hand
from the header text (a regex undercounted, because the phrases break across
comment lines — 14 by pattern, 22 by reading, and the reading is the number):

`AbstractSpinNetworkKinematics` ("does not pretend to formalize SU(2), tensor
products, or the LQG Hilbert space"), `ActionRefinement` ("No novelty is
claimed"; "The bytes nominate this theorem; they are not evidence for it"),
`Controls`, `CoprimeSplitting` ("WHAT REMAINS OPEN", three items),
`DSOBellmanFinite` ("does not claim a quantale theorem, an infinite infimum,
or an optimizer"), `DSONucleusExecutionCalibration`, `DeclaredRootedProfiles`
("does not identify Huayan/Indra's Net with a type-theoretic profile family"),
`DiagonalEndpoint` ("No prime theorem is postulated"),
`FiniteNonabelianHolonomy` ("a precursor test only: it is not SU(2), a Hilbert
representation, or a continuum LQG construction"), `HolonomyFluxDerivation`
(names seven things it does not supply), `LinearOrderFinite` ("WHAT IS NOT
CLAIMED", five items), `NormalizedFiniteInstrument`,
`NormalizedFrameCovariance`, `ObservableHorizon` ("deliberately does not port
the visited-pair implementation"), `OracleQueries` (two separate "NOT claimed"
paragraphs), `ParetoCost`, `PauliJointPhaseRealization`,
`PolyHaythamResponseCostNoGo`, `ProductiveObservabilityBridge` ("it is not
transferred to the indexed, branching `IndraNet.Coinductive.Net`"),
`RootedIndraTotal`, `S3IntegerRelativeCoordinates`, `S11HolonomyDeterminant`
("Only the necessity half and the witness are machine-checked here").

**22/29 = 76%, against the first audit's 22/45 = 49% — and the higher rate is
in the OLDER, less scrutinised modules.** That is the reportable finding: the
habit is not an artifact of one night's heightened care, it predates it. Of
these I checked four line by line against their terms
(`LinearOrderFinite`'s elaboration-cost caveat and its `embSurj`
level-restriction; `OracleQueries`' two exclusions; `S11HolonomyDeterminant`'s
"necessity half only", whose `noSurjectivity` is indeed only the negative
direction with the positive one deferred to a swarm note;
`ProductiveObservabilityBridge`'s non-transfer) and in each case the block is
accurate and, as in the first audit, **stronger than it needed to be**.

Both defects found tonight are in modules **without** such a block. That is
one bit of correlation from two events and I am not asserting it as a law.

---

## 6. Scope limits of this audit

1. **No Agda was run**, and no exit code is quoted anywhere above. The
   version strings in §4 are quoted from the modules' own headers, attributed
   there, not re-verified. Per the standing check: if a future pass quotes an
   exit code for these files it must name the toolchain **and** a path or
   commit, because `notes/VERSION_CLAIM_FORENSICS.md` established two
   containers were in play on 2026-08-15.
2. **Coverage is 100% mechanical (323/323) and 10.5% read (34/323).** The
   two overstatements are a count over the modules actually examined, not an
   estimate for the tree. Nothing here licenses "the rest are clean"; it
   licenses "no header in `formal/cubical/` names a nonexistent object except
   one, and of 34 read at random, two overstate".
3. **Headers were compared against identifiers and types, not against
   proofs.** That a term named `detMul` proves Binet is the typechecker's
   claim, not mine.
4. **The Lean lane (`formal/pairfield/`) is untouched**, as is the 50-path
   set of 2026-08-15 additions covered by pass 1.
5. **The five headerless modules were not otherwise assessed.** A module with
   no header makes no claim to overstate; whether it should have one is a
   different question and not this audit's.
6. **Two corrections, two files, both appended.** No sentence anywhere was
   deleted or altered, and each block states what it does *not* correct.
