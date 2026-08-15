# Operator's guide to the Natural Machine

**What this is.** A runbook for the Cubical Agda development rooted at
`formal/cubical/NaturalMachine.agda`. It is written for a competent
mathematician who has never opened this repository and wants, in one sitting,
to know (1) what the thing says, (2) what is actually proved, (3) how to run
the checker, (4) what the deliberately-failing modules are for, and (5) where
the claims stop.

**What this is not.** It is not a second overview. The mathematical exposition
lives in `notes/NATURAL_MACHINE.md` — the "companion prose" the module header
names — and that note stays the source of truth for §§2–8 of the mathematics.
This guide is deliberately downstream of it: where the two disagree about a
theorem, `NATURAL_MACHINE.md` wins and this file is the bug. Where they
disagree about *scale* (that note describes an 8-module development from
2026-08-12; the tree is now 276 modules) this file is the current one, and says
so explicitly at each point.

Written 2026-08-15, after the first verification of the root aggregate against
the toolchain `formal/cubical/BUILD.md` actually pins. Everything below was
read out of the sources and the build notes, not out of a summary.

---

## 1. What the machine is

### 1.1 The thesis

The module header states it in one sentence:

> Symbols are π₀, geometry lives in identity types, and univalence is what
> makes them say the same thing.

Unpacked:

- **Symbols are π₀.** A numeral is not the number. A numeral names a
  *connected component* of a space of structured objects. Concretely: `FinSet`
  is a groupoid, not a set; two finite sets of the same cardinality are
  equivalent but not equal-on-the-nose, and the space of ways they are
  equivalent is Sₙ. Taking π₀ — the set-truncation `∥ FinSet ∥₂` — collapses
  each component to a point, and the resulting set is ℕ. The numeral `n` is
  the *name of a component*; what naming it forgets is exactly the loop space
  Sₙ. Module: `NaturalMachine/Decategorification.agda`
  (`ℕ≃π₀FinSet : ℕ ≃ ∥ FinSet ℓ-zero ∥₂`, assembled from the fibrewise
  `card≡MereEq : (card X ≡ card Y) ≃ ∥ X ≡ Y ∥₁`, with
  `FinSetLoop≃Sym : (𝔽 n ≡ 𝔽 n) ≃ (Fin n ≃ Fin n)` for the loop space).

- **Geometry lives in identity types.** In a univalent setting `X ≡ X` is not a
  one-point set; it is `X ≃ X`, and the equivalence is *multiplicative*, so the
  loop space of `Type` at `X` is the symmetric group of `X` as a group, not
  merely as a set. Module: `NaturalMachine/PathIsSymmetry.agda`
  (`pathIsSymmetry`, `pathToEquiv-∙`, `ΩGroup≃Symmetric`, `ΩFin≃Sym`). The
  symmetry that a structure *cuts down* is then measurable: `Aut` of ℕ as a
  bare type is nontrivial (`swap01-≢-id`), `Aut` of ℕ as the initial
  `(1 + X)`-algebra is trivial (`ℕ-algebra-Aut-trivial`). That contrast is the
  structure identity principle in its smallest honest instance.

- **Univalence is what makes them say the same thing.** The operational test
  the development submits to, and the reason it is not a tautology:

  > **An asserted isomorphism is not transport.**

  Define a structure natively on *each* side; construct (do not assert) an
  equivalence; take `ua` of it; transport the structure across; prove the
  transported structure *equals* the native one. Modules:
  `NaturalMachine/FreeMonoid.agda`, `Digits.agda`, `Transport.agda`. The
  payoff statement is `transport-+-is-⊕`: ℕ's addition pushed along the path
  ℕ ≡ CanWord is *literally* the schoolbook ripple-carry algorithm, which was
  defined independently digit-by-digit. And `ℕ-Monoid≡CanWord-Monoid`: the two
  monoids are **equal**, by SIP.

  This is what makes the exercise non-vacuous. If `_⊕_` had been *defined* as
  `f ∘ (+) ∘ f⁻¹`, the theorem would be `refl` and worth nothing. It is not:
  `_⊕_` is carry propagation over digit words, and associativity and unitality
  of the schoolbook algorithm are never proved directly — they arrive from ℕ
  through the equivalence.

### 1.2 The residual, which is the actual content

If univalence made everything interchangeable, none of this would be
interesting. It does not, and the place it visibly fails to is positional
notation. `NaturalMachine/Endian.agda` checks that the digit chart carries two
commuting involutions — reversal and digitwise complement — which the object ℕ
does not carry: **neither descends along the value map**. Complement is
π-equivariant, reversal is not; reversal instead exchanges the two truncations
(most- and least-significant). Hence the slogan the development actually
earns: *place value is a chart, not the object*, and endianness is the
obstruction to the chart being canonical.

---

## 2. What is proved, and what is scaffolding

### 2.1 The seven headline statements

These are the seven the root module's header lists, verified here by reading
`formal/cubical/NaturalMachine.agda:1-60` and spot-checking each named term in
its module. Line numbers are where the term is *defined*.

| # | Statement | Term(s) | Where |
|---|---|---|---|
| 1 | `(X ≡ X) ≃ (X ≃ X)` for any type, and it is a group isomorphism onto the symmetric group; at `Fin n` this is Sₙ | `pathIsSymmetry`, `pathToEquiv-∙`, `ΩGroup≃Symmetric`, `ΩFin≃Sym` | `PathIsSymmetry.agda` (:54, :70, :97) |
| 2 | The initial `(1 + X)`-algebra is rigid; ℕ as a bare type is not. Structure cuts symmetry — the SIP | `ℕ-algebra-Aut-trivial` (:140), `swap01-≢-id` (:125) | `PathIsSymmetry.agda` |
| 3 | Three presentations of ℕ, defined independently, with equivalences **constructed** (the digit one through the odometer `sucw` and injectivity of `value` on canonical words) | `ℕ≃Tally`, `ℕ≃CanWord`, `value-digits`, `digits-value` | `FreeMonoid.agda`, `Digits.agda` |
| 4 | Transporting ℕ's `+` along `ua` yields the schoolbook ripple-carry algorithm; and the two monoids are **equal** by SIP | `transport-+-is-⊕` (:260), `ℕ-Monoid≡CanWord-Monoid` (:274) | `Transport.agda` |
| 5 | Reversal and complement are commuting involutions of the digit chart, pairwise distinct with their composite; **neither descends** along `value`; complement is π-equivariant, reversal is not and instead swaps the truncations | `chartSymmetry` (record `ChartSymmetry`, :308/:325) | `Endian.agda` |
| 6 | ℕ is π₀ of FinSet: `ℕ ≃ ∥ FinSet ∥₂`, assembled from the fibrewise `card≡MereEq`; the loop space the numeral forgets is Sₙ | `ℕ≃π₀FinSet` (:99), `card≡MereEq` (:82), `FinSetLoop≃Sym` (:119) | `Decategorification.agda` |
| 7 | Controls: canonicity is load-bearing, the big-endian misreading is refuted, and deliberately wrong statements **fail** to typecheck | `Controls.agda` + `NaturalMachine/Control/*` | see §4 |

Two of these were once overstated in the header and have since been repaired,
which is worth knowing because it shows the audit loop working rather than
being decorative. `notes/NATURALMACHINE_CLAIM_AUDIT.md` (2026-08-13, hostile
breaker pass over 84 comment-level claims: 61 PROVED, 8 DEFINED-ONLY, 9
OVERSTATED, 6 VACUOUS) flagged headline 5 for asserting a Klein-four *group
object* that did not exist, and headline 6 for claiming a π₀ statement when
only the fibrewise `card≡MereEq` was checked. Both were fixed the correct way
— pairwise distinctness landed in `Endian.agda`, `ℕ≃π₀FinSet` landed in
`Decategorification.agda`, and the header now explicitly disclaims the group
object ("no group object is packaged"). Read that audit before quoting any
comment in this corpus as a theorem.

### 2.2 The other ~270 modules

`formal/cubical/NaturalMachine/` holds **276 `.agda` files, about 57 000
lines**, and `formal/cubical/` holds a further **53 top-level modules**. Only
the eight in §2.1 discharge the header's thesis. What are the rest?

They are not scaffolding in the sense of plumbing. They are a *different kind
of object*: each is a small, self-contained, kernel-checked model of a claim
made somewhere else in this repository's prose corpus — typically the minimal
finite structure on which a claimed implication either holds or visibly fails.
Read the one-paragraph comment above each `import` line in
`NaturalMachine.agda`; the root aggregate is, in effect, an annotated index.
Recurring families:

- **Observation / behaviour** — `FutureBehavior`, `ObservableHorizon`,
  `AdaptiveResidualAdapter`, `CompositionalContextAdapter`,
  `ContextCloneEquivalence`, `BehavioralHankel`. Behavioural congruences,
  quotients, and when a coarser observation still determines the finer one.
- **Formation / encountered worlds** — `FormationRelativeMinimality`,
  `FormationDirectionIncidence`, `FiniteWorldMaximizer`,
  `LineWorldTransport`. The finite models behind
  `notes/ENCOUNTERED_WORLDS.md`.
- **Defect / obstruction** — `Obstruction`, `StructuredDefect`,
  `DecategorifiedDefect`, `CarryObstruction`, `CompressionDefect`,
  `ProjectionChargeAudit`. Descent obstructions in the `¬ Σ` style.
- **Installation and the generative loop** — `CompileBridge`,
  `GenerativeLoop`, `ProofLabelNoGo`, `RewriteCertificate`,
  `HaskellDefinitionBoundary`. The seam between a claim and its installation
  in a store; see `collab/messages/0651` for the classification these check.
- **Digit tower / completion** — `DigitTowerLimit`, `DigitTowerFinLimit`,
  `FinTopSplit`. The inverse limits and the reversal equivalence between them.

A reader who wants to know whether one of these says something interesting
should read its header comment and then the type of its main term, in that
order, and should not assume the comment is accurate — see the audit note
again. **Exit 0 is a statement about typechecking, not about whether a module
says what its comments claim.** That sentence is `TOOLCHAIN_SKEW_AND_COVERAGE`
§5.5 and it is the single most important caveat in this guide.

---

## 3. How to check it

### 3.1 The pin

```
Agda            2.8.0
cubical library v0.9   (the release TAG v0.9, commit b150186 — not master)
```

`formal/cubical/natural-machine.agda-lib` declares `depend: cubical`, resolved
through `~/.agda/libraries`.

### 3.2 The locale requirement — read this before reporting a failure

```sh
export LC_ALL=C.UTF-8 LANG=C.UTF-8
```

**This is not cosmetic.** Agda's sources and its output are full of `ℕ`, `≃`,
`λ`, `∷`. In a non-UTF-8 locale, Agda dies inside `commitBuffer` while
*printing* any message and returns a nonzero exit code — 42 — that has nothing
to do with the mathematics. The maximally confusing part: **green builds are
unaffected**, because they print nothing worth crashing on. So the failure mode
is "a module that checks fine appears to fail, with an unreadable error".

This has produced multiple false reports in this repository, in both
directions, and they are documented rather than tidied away:
`TOOLCHAIN_SKEW_AND_COVERAGE.md` §0 records two false "exit 42" results
(`FillabilityCertificate`, `PolarityClosure`) traced to exactly this. If you
are about to report that this corpus is red, check your locale first.

### 3.3 Obtaining the pin

Both halves, roughly 75 minutes of wall clock (recipe from
`TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1, which is a record of it actually being
done, not a plan):

```sh
# --- library half (easy) ---
git clone --depth 1 --branch v0.9 https://github.com/agda/cubical \
    /root/agda-libs/cubical-v0.9

# --- compiler half ---
apt-get install -y cabal-install          # 3.8.1.0 known to work
cabal update
cabal get Agda-2.8.0                      # NOT `cabal install` — under cabal
                                          # 3.8 that dies in its sdist step
                                          # ("Could not find module:
                                          #  Agda.Benchmarking")
cd Agda-2.8.0
cabal build exe:agda --ghc-options=-j4    # system GHC 9.4.7 suffices;
                                          # Agda's tested-with says 9.4.8
# cabal build does NOT populate the prim bundle the binary looks for:
mkdir -p ~/.cabal/share/x86_64-linux-ghc-9.4.7/Agda-2.8.0
cp -r src/data/* ~/.cabal/share/x86_64-linux-ghc-9.4.7/Agda-2.8.0/
```

Traps worth knowing in advance:

- **v0.9 alone does not work.** cubical v0.9 uses `opaque` blocks that Agda
  2.6.3 cannot parse; it dies inside the *library*
  (`Cubical/Foundations/Structure.agda:28`) before reaching any repository
  module. You need both halves or neither.
- **There is no usable intermediate.** v0.6–v0.8 parse under 2.6.3 but v0.8
  fails on unsolved metas in `Cubical/Categories/…`; and the
  `Symmetric-Group` → `SymGroup` rename is a v0.8 → v0.9 change, so no earlier
  release satisfies `PathIsSymmetry.agda:98`.
- **Library naming.** Upstream's v0.9 `cubical.agda-lib` names the library
  `cubical-0.9`, while ours says `depend: cubical`. Agda resolves an
  unversioned dependency against a version-suffixed library, so they agree;
  `TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1 records an earlier run that renamed
  the field by hand instead. Either way, do not edit repository sources for
  this.

### 3.4 The invocation

The maintained way, which will refuse to lie to you:

```sh
formal/cubical/check.sh
```

`check.sh` sets `LC_ALL=C.UTF-8` unconditionally, locates the pinned compiler
and identifies cubical v0.9 *by content* (does
`Cubical/Algebra/SymmetricGroup.agda` export `SymGroup`?) rather than by
directory name, prints a per-module exit code without stopping at the first
red, and — the contract worth quoting — **exits nonzero regardless of what
Agda returned if it could not confirm it was running under the pin**. Override
with `AGDA_PIN`, `AGDA_CUBICAL_LIB`, `NM_MODULES`.

By hand, equivalently:

```sh
export LC_ALL=C.UTF-8 LANG=C.UTF-8
cd formal/cubical
agda --library-file=<v0.9 libraries file> NaturalMachine.agda   # must exit 0
```

**Expected output under the pin:** exit 0, zero errors, and **186
`UnsupportedIndexedMatch` warnings**. Those warnings are the documented
boundary recorded as `collab/FAILURES.md` F39. They are not failures and they
are not new.

### 3.5 What the green claim covers, exactly

This distinction has been got wrong here before, so state it precisely:

- **`NaturalMachine.agda` (the root aggregate) exits 0 under the pin.**
  Therefore so does every module it transitively imports. As of BUILD.md's
  2026-08-14 closure, the root transitively reaches *every* module in
  `NaturalMachine/`, so "the root exits 0" and "the directory checks" are the
  same claim. Quote the root, not the directory.
- **`Everything.agda` is one level up** — it imports every top-level module of
  `formal/cubical/` plus the root, and exists because a green claim covering 1
  of 34 top-level modules is not false but will be read for more than it says.
  It is a module rather than a paragraph on purpose: a paragraph rots, an
  import list fails the build.
- **The coverage check is mechanical. Run it; do not trust a hand-maintained
  list of orphans** — BUILD.md's own list had drifted in both directions
  within a day.

  ```sh
  cd formal/cubical
  rm -rf _build && agda NaturalMachine.agda            # must exit 0
  for f in NaturalMachine/*.agda; do
    m=$(basename "$f" .agda)
    find _build -name "$m.agdai" -path "*NaturalMachine*" | grep -q . || echo "ORPHAN: $m"
  done                                                 # must print nothing

  ls *.agda | grep -v '^Everything.agda$' | sed 's/\.agda$//' | sort > /tmp/a
  grep '^import ' Everything.agda | awk '{print $2}' | sort > /tmp/b
  comm -23 /tmp/a /tmp/b                               # must print nothing
  ```

  Grepping `NaturalMachine.agda` for import lines is **not** this check and
  gives the wrong answer: it once reported nine orphans where the interface
  files showed three, because six were reached transitively. The `.agdai`
  files are the ground truth about what the kernel checked.

---

## 4. `Control/` — a directory that must fail

`formal/cubical/NaturalMachine/Control/` currently holds five modules:
`WrongEquivalence`, `WrongFirstStep`, `QuantifierDrop`,
`MaximizerWithoutNonvanishing`, `InflationFlattened`. Every one carries the
banner

```
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
```

and every one is excluded from both aggregates, permanently, by design. **If a
future edit ever makes a `Control/` module check, that is the bug** — and it is
a bug in the mathematics, not in the build.

### Why this is the best instrument in the repository

A proof assistant tells you that what you wrote is true. It never tells you
that what you wrote is what you *meant*, and it is silent about the failure
mode this corpus actually suffers from: a theorem that is correct in its
module and then travels through prose losing a hypothesis. `Control/` is the
apparatus for exactly that. Each module takes a **real theorem from the
corpus**, applies a **specific documented distortion that a real summary
actually committed**, and asserts the distorted version. The checker's refusal
is then a proof that the dropped clause was load-bearing.

The distortions are not invented. They are cited:

- `QuantifierDrop` — `notes/ENCOUNTERED_WORLDS.md`'s line-world corollary is
  stated *for `f = X+Y`*; a summary message restated it for every integral
  `f`. The control asserts the quantified version. It fails at line 80 with
  `[UnequalTerms]` on the dropped quantifier, because
  `LineWorldTransport.dropped-hypothesis-false` derives ⊥ from precisely that
  type.
- `MaximizerWithoutNonvanishing` — "every finite `E` **with `f ≠ 0` on `E`**
  has a point that fails to transport" restated without the nonvanishing
  clause. The clause is what makes "the maximizer" *denote*: on `f = 0` there
  is no maximizer at all (`vanishing-world-has-no-maximizer`).
- `InflationFlattened` — "inflation is injective **along a quotient**"
  restated flat. Under the flat reading it would cover subgroup inclusions,
  where the map does not exist in that direction.
- `WrongEquivalence` — asserts `ℕ ≃ Word` for *raw* digit words, offering `tt`
  where a canonicity certificate is required. Fails with
  `Unit !=< (Canonical w)`. This is the control that keeps headline 3 from
  being a formality: `ℕ ≃ Word` is *false* (`Controls.no-raw-round-trip`), so
  the canonicity restriction is content.
- `WrongFirstStep` — `CompileBridge`'s §G1 `refl` asserted at a capability
  that *is* installed, so the first step cannot name it. If `refl` inhabited
  the residual type for an arbitrary capability, G1 would certify nothing.

Two disciplines make these instruments rather than decoration, and both should
be preserved by anyone touching the directory:

1. **A control must be confirmed to fail *for the intended reason*.** Exit 42
   is not enough — a typo also gives 42. The build notes record the line
   number and error constructor for each: `QuantifierDrop.agda:80`
   `[UnequalTerms]`, `MaximizerWithoutNonvanishing.agda:84` naming
   `NonVanishing W`, `InflationFlattened.agda:91` `k0 != kι`,
   `WrongEquivalence.agda:37,63-65` `Unit !=< (Canonical w)`.
2. **A control must fail under the pin too.** `QuantifierDrop` was re-run
   under Agda 2.8.0 / cubical v0.9 and still exits 42 for the same reason at
   the same line. A control that starts passing after a toolchain bump is the
   loudest possible alarm.

Alongside these live the *in-build* controls in
`NaturalMachine/Controls.agda`, which are ordinary checked theorems of
negative shape: `value-not-injective-on-Word`,
`no-raw-round-trip : ¬ ((w : Word) → digits (value w) ≡ w)`,
`wrong-endian-round-trip-fails`. Those are refutations that compile;
`Control/` holds assertions that must not. Both patterns are needed and they
are not interchangeable.

**What no control covers.** Nothing here tests whether the *statements* are
the interesting ones. A vacuously true formalization typechecks exactly as
happily as a substantial one. The guard against vacuity is the unchecked
ledger (§5) and hostile review, not the machine.

---

## 5. The gaps, stated as limits

### 5.1 The pin has been run on twelve modules, not on the tree

This is the sharpest limit and it is recent. As of 2026-08-15:

- **Green under the pin:** the root `NaturalMachine.agda` (exit 0, 186
  warnings, 0 errors) and therefore its whole transitive closure; plus
  `StagewiseComposite`, `SimplicialDefectFailure`, `Sl2DivisorLattice`,
  `DecategorifiedDefect`, `RepairTorsor`, `FillabilityCertificate`,
  `LineWorldTransport`, and (after its repair) `PolarityClosure`.
- **The direction of the tree is now decided.** `Sl2TensorProduct.agda` was
  the one module found green under 2.6.3/v0.5 and red under the pin — one
  token, `Cubical.Data.Int.Properties.·Rid` (v0.5) spelled `·IdR` in v0.9.
  Two agents correctly declined to fix it, on the ground that which toolchain
  the sources track is an owner decision to be made once for the whole tree.
  The owner made it on 2026-08-15: **the sources track the pin.** The rename
  landed and the module is now green under the pin and **red under
  `/usr/bin/agda` (2.6.3 / v0.5)**, which has no `·IdR`. That is the intended
  state for every file in this tree, not a regression, and it means older
  per-module "exit 0 under 2.6.3/v0.5" reports elsewhere in the corpus are now
  *historical evidence about a superseded toolchain*, not a current check.
  (`TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.7.)
- **`Everything.agda` no longer aborts at `Sl2TensorProduct`**, so its
  coverage caveat is lifted at that point and the aggregate reaches the
  modules imported after it. I have **not** seen a recorded exit code for a
  full `Everything.agda` run under the pin after that repair, so do not quote
  one; run `check.sh`, which checks both aggregates.
- **Everything else is unswept under the pin.** A tree-wide grep for five
  specific renamed identifiers (`·Rid`, `·Lid`, `+Rid`, `+Lid`,
  `Symmetric-Group`) now returns zero hits, which is reassuring and is not a
  proof: it is a grep for five names, not a check. Modules whose only recorded
  check is under **Agda 2.6.3 / cubical v0.5** — the OUTSTANDING set in
  BUILD.md — include `StagewiseCompositeB`, `TransmissionRefutations`,
  `FiniteWorldMaximizer`, `InflationVersusSubgroup`, and the two newer
  `Control/` modules (`MaximizerWithoutNonvanishing`, `InflationFlattened`).

Two further practical limits: the pinned Agda was **built into a session
scratchpad and is not installed as `/usr/bin/agda`** — what survives that pass
is a result table and a recipe, not a working environment; and the pin is Agda
2.8.0 *built from Hackage against GHC 9.4.7*, not a distributed 2.8.0 binary.

### 5.2 The Lean lane is a different, narrower thing

`formal/pairfield/` (Lean 4.33.0, mathlib `v4.33.0`) is the analytic lane and
is **unrelated to the Natural Machine**; it does not import it, is not
imported by it, and shares no toolchain. Its status
(`notes/LEAN_STATUS.md`, 2026-08-11): `lake build` completes, 8710 jobs, zero
sorries; `#print axioms` on all five theorems returns exactly
`propext, Classical.choice, Quot.sound`. Three targets at level V3 —
sum-marginal injectivity, `SO(1,1)(ℤ) = {±I}`, and reversal/UFD rigidity for
*irreducible* `F`. The scope limit stated there and worth repeating: the
cyclotomic-factor bookkeeping of the general reducible case and the reduction
from difference multisets are **not** formalized. Do not quote the Lean lane
as evidence about the Agda lane or vice versa.

### 5.3 Where prose outruns terms

`NATURAL_MACHINE.md` §7.3 is the standing unchecked ledger for the original
core, and it is honest; two of its six items have since been discharged
(§2.1 above), the rest have not. Live ones:

- **Aut of the digit chart over the value map is not computed.** What is
  checked is the contrast at both ends, plus a faithful pair of commuting
  involutions none of which descends. The full group of self-equivalences `φ`
  of `Word` with `value ∘ φ = value` — large, since the fibres of `value` are
  the zero-padding classes — is neither constructed nor computed.
- **The Klein-four *group* is prose.** Agda checks commuting involutions,
  pairwise distinctness, and nontrivial action; the group-theoretic inference
  is done in English. The header now says so ("no group object is packaged").
- **Universe levels.** `ΩGroup X : Group (ℓ-suc ℓ)` while
  `SymGroup X : Group ℓ`, so `ΩGroup≃Symmetric` is a `GroupEquiv`, not a path.
  "The loop group *equals* Sₙ" is not what was checked; "is isomorphic to" is.
- **The completion.** The bare-type inverse limits and the reversal
  equivalence are formalized (`DigitTowerLimit`), including `J ∘ R∞ = L`. The
  collapse of the Klein four to ℤ/2 on ℤ_b is **not** formalized, and the
  nonsplit extension / nonzero cohomology class remain a proposition in
  `ATLAS_OF_N`. Note the residual that bare univalence must not erase:
  most-significant truncation is a homomorphism under positional value,
  least-significant is not, so transporting a group law to `LSDLimit` does not
  make its native projections homomorphisms.
- **Comment-level claims across the ~270 supporting modules have been audited
  once**, on 2026-08-13, when there were 19 of them. That audit found 9
  OVERSTATED and 6 VACUOUS out of 84. The tree has grown by an order of
  magnitude since and **has not been re-audited at that granularity.** Treat a
  module header comment as a claim awaiting audit, not as a result.

### 5.4 What the whole development does not demonstrate

Quoting `NATURAL_MACHINE.md` §9 because it has not been superseded: this is
one theorem transported, by hand, between two presentations chosen in advance.
**There is no implemented system** — nothing caches, routes, content-addresses
or reuses across presentations automatically. It is not evidence that a
numeral system is better or worse than ℕ; the chart/object distinction says
which structure lives where, not which is preferable. The honest one-line
summary of the core remains: *an existence proof and a cost estimate, not an
implementation.*

---

## 6. Reading order for a cold start

1. This file, §1 and §3.
2. `formal/cubical/NaturalMachine.agda:1-60` — the header. Seven statements,
   sixty lines.
3. `notes/NATURAL_MACHINE.md` §§2–8 — the mathematics, at the scale of the
   original eight modules, which is the right scale to learn it at.
4. `notes/NATURALMACHINE_CLAIM_AUDIT.md` — the hostile pass. Read it before
   quoting any comment.
5. `formal/cubical/BUILD.md` — the build contract, including its own
   corrections. It is written as a sequence of *additions*, each narrowing an
   earlier overstatement; read it in order and the narrowing is the lesson.
6. `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6 — the pin, obtained and run.
7. `formal/cubical/NaturalMachine/Control/` — five short files, all of which
   must fail.

## 7. Scope of this guide

Written from: the root module header; `Decategorification.agda`,
`PathIsSymmetry.agda`, `Transport.agda`, `Endian.agda` (definition sites of
every headline term, read directly); all five `Control/` headers;
`formal/cubical/BUILD.md`; `formal/cubical/check.sh`;
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md`; `notes/NATURAL_MACHINE.md`;
`notes/NATURALMACHINE_CLAIM_AUDIT.md`; `notes/NATURAL_MACHINE_TOOLCHAIN_DRIFT.md`;
`notes/LEAN_STATUS.md`.

**No Agda was run for this document.** Every exit code quoted here is quoted
from the build notes, with the toolchain named; none is a fresh measurement,
and §5.1's table is exactly as stale as
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6. The pinned compiler is not
installed in this container. If you need a current result, run
`formal/cubical/check.sh` — it is designed to refuse to report green when it
cannot confirm the pin, which is more than this file can do.

The proof bodies of the ~270 supporting modules were **not** read. §2.2's
taxonomy is assembled from module names and the header comments in the root
aggregate, and inherits whatever inaccuracy those comments carry.
