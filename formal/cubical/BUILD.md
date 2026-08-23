# Building the Cubical `NaturalMachine` corpus

This directory typechecks against a **pinned toolchain**.

**Scope of the green claim, corrected 2026-08-14** (found by the whitepaper
implementation audit, `notes/WHITEPAPER_IMPLEMENTATION_AUDIT.md`; the earlier
wording here read "Verified green, every module, exit 0" and was false):

- **The root aggregate `NaturalMachine.agda` checks exit 0**, and therefore so
  does every module it transitively imports. That is the claim this file
  supports, and it is re-verified on each landing.
- **The two orphans that did not check are repaired and now check, 2026-08-14.**
  `NaturalMachine/FinTopSplit.agda` failed with a scope error (v0.5's
  `Cubical.Data.Fin` does not export `injectSuc`) and
  `NaturalMachine/DigitTowerFinLimit.agda` failed through it. The cause was the
  same version skew already catalogued below, not a mathematical gap: v0.5
  provides the general `inject< : m < n → Fin m → Fin n`, and `injectSuc` is
  its instance at `≤-refl` (`m < n` unfolds to `suc m ≤ n`). `FinTopSplit` now
  defines `injectSuc = inject< ≤-refl` and `DigitTowerFinLimit` takes the name
  from there. Both exit 0, `--safe`, 0 warnings, no postulates, no holes; the
  two definitional facts the modules turn on (`fromSeq`'s coherence obligation
  and `toSeq ∘ fromSeq`, both `refl`) survive the substitution, because
  `inject<` reduces on `toℕ` by Σ-eta exactly as `injectSuc` did. No statement
  was weakened and nothing was invented.
- **Both are now imported by the root aggregate** (unopened — they define their
  own `InvLim`/`W`/`MSDLimit`, which would clash with the `public` open of
  `DigitTowerLimit`), so the root's exit 0 now covers them. That is the right
  place for them: an orphan that the root does not import is exactly the hole
  that let the earlier overstatement hide.
- ~~**The directory is still wider than the root.** Four further modules are
  not imported by `NaturalMachine.agda`: `DigitTowerFin`, `LeakageCommutator`,
  `WalkCapacity`, `WalkForcing`. … Folding those four in would make the two
  claims coincide; that is an open item for their owners.~~
  **CLOSED 2026-08-14.** `WalkCapacity` and `WalkForcing` were folded in by
  their own lane; `DigitTowerFin`, `LeakageCommutator` and `WalkInduction`
  are folded in here. **The root aggregate now transitively reaches every
  module in `NaturalMachine/`**, so "the root exits 0" and "the directory
  checks" are the same claim, and quoting either is now honest.

  Note the drift this repaired, because it will recur: the paragraph above
  said *four*, and by the time it was checked the true count was *three* —
  two of the named four had been folded in and one new orphan
  (`WalkInduction`) had appeared. A hand-maintained list of orphans rots in
  both directions. **The check is mechanical and takes one command**; run it
  rather than trusting this file:

  ```sh
  cd formal/cubical
  rm -rf _build && agda NaturalMachine.agda            # must exit 0
  for f in NaturalMachine/*.agda; do
    m=$(basename "$f" .agda)
    find _build -name "$m.agdai" -path "*NaturalMachine*" | grep -q . || echo "ORPHAN: $m"
  done                                                 # must print nothing
  ```

  Grepping `NaturalMachine.agda` for import lines is **not** this check and
  gives the wrong answer — it reported nine orphans where the interface files
  showed three, because six were reached transitively. The interface files are
  the ground truth about what the kernel actually checked.

  A module under active construction by another session will show as an
  orphan until it lands; that is expected and is not a defect.

- `NaturalMachine/Control/` is excluded on purpose and always will be: its
  contents are deliberately wrong statements that MUST fail to typecheck. It
  is not covered by the claim above and must never be imported by the root.
  `check-agda-closure.sh` guards the negative obligation (never imported);
  the positive obligation — each control still fails, *and fails for the
  reason it was built to catch* — is guarded by `check-controls.sh` (the
  must-fail gate, `notes/CONTROL_MUSTFAIL_GATE.md`). It needs the pinned
  Agda, so like `check.sh` it is a manual gate, not a push-gated CI step.
- Anyone quoting this file for a green claim should quote the **root
  aggregate**, not the directory.

### The same hole, one level up — `Everything.agda`, added 2026-08-14

Everything above concerns `NaturalMachine/`. It was all true and it was
**narrower than it looked**: `NaturalMachine.agda` is the root of *one
subtree*, and at the time this was written there were **33 further modules at
the top level of `formal/cubical/`** that it does not import — the whole Γ₀
lane, the transporters, `KuttakaValli`, `ParityNormEliminant`, the charge
audits, and every module landed by the genius swarm. Each was checked once, by
its author, on the day it landed, and then never again by anything.

That is precisely the hole this file already names one level down — *"an orphan
that the root does not import is exactly the hole that let the earlier
overstatement hide"* — and the lesson had been learned for `NaturalMachine/*`
and not for `*`. A green claim covering 1 of 34 top-level modules is not false,
but a reader will take it for more than it says.

**`Everything.agda` closes it.** It imports every top-level module plus the
`NaturalMachine` root, so one command checks the entire Agda lane. All 34 were
verified exit 0 individually *before* it was written, so it latches a state
that already held rather than repairing a broken one.

The fix is a module and not a paragraph on purpose: a paragraph rots, an import
list fails the build. Same reasoning as the mechanical orphan check above, and
for the same reason — the hand-maintained list of orphans in this file had
already drifted in both directions once.

```sh
cd formal/cubical
agda Everything.agda                                  # must exit 0

# and the coverage check, which is what actually rots:
ls *.agda | grep -v '^Everything.agda$' | sed 's/\.agda$//' | sort > /tmp/a
grep '^import ' Everything.agda | awk '{print $2}' | sort > /tmp/b
comm -23 /tmp/a /tmp/b                                # must print nothing
```

Imports are plain — never `open`, never `public`. These modules were written
independently and collide freely on short names (`Q`, `τ`, `step`, `see`, `W`,
`InvLim`, …); re-exporting would turn an aggregate into a merge conflict. The
point is that the kernel checks them, not that a client can dot into them.

`NaturalMachine/Control/` stays excluded here too, permanently. If a future
edit ever makes `Control/` check, that is the bug.

## Toolchain

- **Agda 2.8.0**
- **cubical library v0.9** (the release tag `v0.9`, not `master`)

`natural-machine.agda-lib` declares `depend: cubical`, so Agda resolves the
name `cubical` through `~/.agda/libraries`.

## One-time setup on a fresh container

```sh
# Install Agda 2.8.0 with the platform package manager or cabal.
agda --version                           # must report 2.8.0

# cubical v0.9, registered under the plain name `cubical`
git clone --depth 1 --branch v0.9 https://github.com/agda/cubical ~/agda-libs/cubical
sed -i 's/^name:.*/name: cubical/' ~/agda-libs/cubical/cubical.agda-lib
mkdir -p ~/.agda
echo "$HOME/agda-libs/cubical/cubical.agda-lib" >> ~/.agda/libraries
```

## Check

```sh
export LC_ALL=C.UTF-8 LANG=C.UTF-8          # Agda emits Unicode (ℕ, ≃, …); a
                                            # non-UTF-8 locale fails on error output
cd formal/cubical
agda NaturalMachine.agda                    # the whole tree, or:
for f in NaturalMachine/*.agda NaturalMachine.agda ProjectionChargeAudit.agda; do
  agda "$f" || echo "FAIL: $f"
done
```

## Version-skew notes (v0.9 migration, 2026-08-14)

The repository formerly pinned Agda 2.6.3 with cubical v0.5.  The migration to
the current release surface changed names and, more importantly, the domain on
which solver macros operate:

- `Symmetric-Group` is now `SymGroup`
  (`Cubical.Algebra.SymmetricGroup`).
- `Cubical.Tactics.CommRingSolver.Reflection.solve` is now `solve!`.  The old
  macro introduced every leading Π-binder; the new macro parses only an
  equality boundary.  Therefore `f = solve R` migrates to
  `f _ … _ = solve! R`, with one explicit pattern per quantified argument.
  Merely renaming the macro leaves a function goal and is rejected.
- `Cubical.Tactics.NatSolver.Reflection.solve` similarly becomes `solveℕ!`
  after explicit introduction of the quantified arguments.

The polynomial statements did not change during this migration.  The explicit
patterns make the new tactic boundary visible and preserve the kernel-checked
equalities.  Downgrading to v0.5 requires the inverse source migration; the
present tree is not claimed to be dual-version compatible.

### Where the skew bites on a 2.6.3 / v0.5 container (measured 2026-08-14)

At least one running container still carries the FORMER pin (Agda 2.6.3,
cubical v0.5 at `~/agda-libs/cubical`) while checking the PRESENT (migrated)
tree — note `formal/README.md` describes the v0.9 surface and the top of this
file pins 2.8.0/v0.9, but nothing forces a container to match.  On such a
container the natural-machine gate reads every post-migration module as a
fiber.  The bite points, so nobody re-diagnoses them as mathematics:

- `solveℕ!` absent from `Cubical.Tactics.NatSolver.Reflection` (v0.5 exports
  `solve`): `IntegerHullMultiplicity` and `NaturalMachine/{Transport,
  TransportMul, ConeOrder, DigitTowerLimit, RadixSymptoma}` fail at scope
  checking, exit 42, plus everything importing them — `Transport` and
  `DigitTowerLimit` sit under the root aggregate, so `NaturalMachine.agda`
  itself is red here.
- `solve!` absent from `Cubical.Tactics.CommRingSolver.Reflection`: the whole
  Γ₀ lane, `M2Unimodular`, `KuttakaValli`, `Rank1DihedralChart`, five
  `Swarm/` modules, ~14 `NaturalMachine/` modules, and `Everything.agda`.
- `SymGroup` absent (v0.5 has `Symmetric-Group`):
  `NaturalMachine/{Decategorification, DefectCalculus, PathIsSymmetry,
  StabilizerSubgroup}`.

These fibers are TOOLCHAIN SKEW, not reconstruction questions about the
mathematics (Delta 15 C15.82 classifies the fiber; this note names its
origin).  The fix is to align the container with the pin above — not to edit
the modules, and not to "repair" the gate.  The ledger rows written by such a
container (e.g. `collab/orchestration/machine-ledger.tsv`, 2026-08-14, the
rows where the fiber count jumps) must be read with this note next to them.

The remaining bullets record historical v0.5 constraints that shaped existing
proof presentations.  They are retained as provenance, not as the current
toolchain contract:

- `CommRingSolver` and `1r` on the RIGHT of a `·`: the v0.5 solver normalizes
  `1r · x ≡ x` but *refuses* `x · 1r ≡ x`, and the refusal is
  **context-sensitive** — the same goal was accepted in a bare file and
  rejected once `Gamma0Partner` was imported. Keep `1r` out of every `solve`
  call and take `·IdR` from the ring structure instead. Cost three build
  cycles in `Gamma0ConverseSharp.agda` before it was recognised as skew
  rather than a mathematical error. Same shape as the `NatSolver` entry
  above: the solver's failures are about *presentation*, not truth, so a
  rejected goal is never evidence the statement is false.
- `card (_ , isFinSetAut X)` computes to `LehmerCode.factorial (card X)`, which
  is only *propositionally* equal to `Data.Nat._!_` for a variable argument —
  bridged by the structural-induction lemma `factorial≡!` in
  `SymmetryCardinality.agda`.
- `_×_` (`infixr 5`) binds tighter than `_≡_` (`infix 4`): iterated
  `A ≡ B × C ≡ D` needs explicit parentheses around each equation.
- **The `1r` entry above, localised: it is the concrete `ℤCommRing`, and the
  fix is to work at a variable ring.** In a bare file importing only
  `Cubical.Algebra.CommRing{,.Instances.Int}` and the solver, the goal
  `(a : fst ℤCommRing) → a · 1r ≡ a` already fails — the reflected normal
  form does not evaluate and the error is a multi-kilobyte `HornerForms`
  dump, not a readable message. Spelling the unit `pos 1` does not help.
  The *same* goal at a variable ring,
  `module _ {ℓ} (R : CommRing ℓ) where … (a : fst R) → a · 1r ≡ a`, checks
  instantly. So the general rule: **state ring identities over an arbitrary
  `CommRing` and instantiate afterwards** — stronger mathematics and no
  skew. `M2Unimodular.agda` survives at `ℤCommRing` only because none of
  its solved goals mentions `1r`.
  Once at a variable ring the solver is far more capable than the `1r`
  failures suggest, and it is worth knowing this before rewriting a
  statement to appease it: the *full degree-10* identity
  `g(x)·g(-x) ≡ E(x²)² - x²·O(x²)²` for a general monic quintic, five
  variables with `x` to the fifth in each factor, checks in 3.6 s.
  Per-variable degree is **not** the cost driver; the earlier appearance
  that it was is an artifact of `1r` sitting in those same goals.
  (Found while writing `ParityNormEliminant.agda`, 2026-08-14; that module
  is over a variable ring throughout for exactly this reason.)
- `Cubical.Data.Fin` has no `injectSuc`; v0.5 spells the injection generally,
  `inject< : m < n → Fin m → Fin n`, and the bottom-preserving
  `Fin n → Fin (suc n)` is `inject< ≤-refl` (`m < n` = `suc m ≤ n`). Defined
  once, under that name, in `NaturalMachine/FinTopSplit.agda`. `flast`,
  `fsplit`, `toℕ`, `toℕ-injective` are unchanged.

## Historical v0.5 remote replay, 2026-08-14 (cf-sakshi)

Before the v0.9 migration, the former v0.5 setup was independently replayed in
a fresh container.  This section is historical evidence for that earlier tree,
not a setup recipe for the current source.  Two observations remain useful:

- `apt-get install -y --no-install-recommends agda` succeeds (2.6.3 from Ubuntu
  noble). A plain `apt-get install agda` may fail on an unrelated 404 for
  `libmysqlclient21`; `--no-install-recommends` avoids it. `apt-get update`
  emits a 403 warning for an unrelated PPA and is harmless.
- **`LC_ALL=C.UTF-8` is required.** The default container locale cannot encode
  `λ`, so when Agda has anything to report it dies inside `commitBuffer` while
  *printing* the message and you see an encoding error instead of your actual
  type error. Green builds are unaffected, which makes this maximally confusing.

Root build `agda NaturalMachine.agda` exits 0. The `UnsupportedIndexedMatch`
warnings from `SmithPathCountedExecution` / `DigitTowerLimit` are the documented
boundary of `collab/FAILURES.md` F39, not failures.

## Container/pin discrepancy and OUTSTANDING checks, 2026-08-15 (Claude, release-engineering pass)

Added, not overwritten: nothing above this heading was changed. This section
narrows the green claim in the same spirit as the 2026-08-14 correction at the
top of this file, which replaced the false "Verified green, every module,
exit 0".

**The container in which the branch
`claude/collaborative-subagents-loop-ekfugp` was worked is not the pin.** It
has **Agda 2.6.3 and cubical v0.5**, against the **Agda 2.8.0 / cubical v0.9**
pinned above. As a direct result:

- `agda NaturalMachine.agda` **exits 42** there, at
  `NaturalMachine/PathIsSymmetry.agda:98` with `Not in scope: SymGroup`. v0.5
  spells that group `Symmetric-Group`; v0.9 renamed it to `SymGroup`. The
  source is **correct for the pin**. It was not edited, and it must not be
  edited to suit the older library — that would break it under the real
  toolchain. `git log` confirms the file is untouched on that branch; the
  failure predates the branch entirely.
- Therefore, **in that container, this file's central discipline is suspended**:
  "the root exits 0" and "the directory checks" are *not* the same claim there,
  because the root aborts at `PathIsSymmetry` and checks nothing after it.
  The root's exit code is evidence about tonight's modules in neither
  direction. This paragraph exists so that the suspension is written down
  rather than inferred by the next reader from a red build.

**What tonight's modules do have:** per-module `exit 0` under **2.6.3 / v0.5**,
each run individually with `LC_ALL=C.UTF-8` (without that locale Agda dies
while *printing* a message and returns a nonzero code unrelated to the
mathematics — two of these modules produced a false failure that way on the
first sweep). That is a real check and it is the strongest one available in
that container. It is **not** a check against the pin.

**OUTSTANDING — awaiting confirmation under Agda 2.8.0 / cubical v0.9:**

- `PolarityClosure.agda` — *does not check even under 2.6.3/v0.5*: `Multiple
  definitions of Sub`, clashing with the Agda builtin
  `Agda/Builtin/Cubical/Sub.agda`, not with the cubical library. Orphan; no
  aggregate imports it. Unresolved under the pin.
- `SimplicialDefectFailure.agda` — orphan, exit 0 under 2.6.3/v0.5.
- `StagewiseComposite.agda` — newly imported by `Everything.agda`; exit 0.
- `StagewiseCompositeB.agda` — Theorem B / Cor B.1 / Cor B.2 of
  `notes/STAGEWISE_DETERMINES_COMPOSITE.md`; imports `StagewiseComposite`;
  newly imported by `Everything.agda`; exit 0 standalone under 2.6.3/v0.5
  (added 2026-08-15, message `collab/messages/0794-claude-stagewise-B.md`).
  Uses only `Bool`, `Sigma`, `Sum`, `Unit`, `Empty`, `Relation.Nullary` and a
  hand-written abelian-group record — no solver, no tactic, no `Fin`, no
  `SymGroup`. Pinned-toolchain check OUTSTANDING like the rest of this list.
- `NaturalMachine/DecategorifiedDefect.agda` — newly imported by the root;
  exit 0.
- `NaturalMachine/FillabilityCertificate.agda` — newly imported by the root;
  exit 0.
- `NaturalMachine/LineWorldTransport.agda` — newly imported by the root;
  exit 0.
- `NaturalMachine/RepairTorsor.agda` — newly imported by the root; exit 0.
- `Sl2DivisorLattice.agda` — newly imported by `Everything.agda`; exit 0
  standalone under 2.6.3/v0.5 from a clean `_build` (added 2026-08-15,
  message `collab/messages/0792-claude-sl2-agda.md`). It uses no solver, no
  tactic macro, no `Fin` and no `SymGroup`, i.e. none of the constructs this
  file flags as skewed, and every imported name was confirmed present in the
  v0.9 sources of `Cubical/Data/{Int,Nat}/Properties.agda` — but that is
  evidence, not a run, and the pinned-toolchain check is OUTSTANDING like the
  rest of this list.
- `Sl2TensorProduct.agda` — newly imported by `Everything.agda`; exit 0
  standalone under 2.6.3/v0.5 from a clean `_build` (`rm -rf _build &&
  LC_ALL=C.UTF-8 agda Sl2TensorProduct.agda`, which also rechecked
  `Sl2DivisorLattice` from source), 0 warnings, no postulates, no holes
  (added 2026-08-15, message `collab/messages/0798-claude-sl2-tensor.md`).
  It closes `Sl2DivisorLattice` §6: tensor of 𝔰𝔩₂-triples, hence the
  multi-index B_n = ⨂_i V_{α_i}. Imports only
  `Cubical.{Foundations.Prelude, Data.Nat, Data.Int, Data.List,
  Data.Sigma, Data.Unit}` plus `Sl2DivisorLattice`; no solver, no tactic
  macro, no `Fin`, no `SymGroup`. Same caveat as the entry above: that is
  evidence about the pin, not a run against it. OUTSTANDING.
- `NaturalMachine/TransmissionRefutations.agda` — newly imported by the root;
  exit 0 standalone under 2.6.3/v0.5 (added 2026-08-15, message
  `collab/messages/0795-claude-refutations-agda.md`). Refutes three displays
  of the D0020 transmission as checked terms. Imports only
  `Foundations.Prelude`, `Data/{Nat,Bool,Int,Sigma,Empty}` and
  `Relation.Nullary`, and re-implements the small-number arithmetic it needs
  (`div`, `mod`, μ, ω, Ω, λ, φ) rather than importing it, precisely so that
  the version skew this file catalogues cannot touch it: no solver, no tactic,
  no `Fin`, no `SymGroup`. NOTE the name hazard it hit and that
  `PolarityClosure.agda` above did not survive: a top-level `Sub` clashes with
  the Agda builtin `Agda/Builtin/Cubical/Sub.agda`, so the subset type here is
  named `Subset`. Pinned-toolchain check OUTSTANDING like the rest of this
  list.
- `NaturalMachine/Control/QuantifierDrop.agda` — a CONTROL: it **exits 42, and
  that is its pass condition**. Confirmed to fail for the intended reason (the
  dropped quantifier, at line 80), not incidentally. Under the pin it must
  still fail, and for that reason.
- `NaturalMachine/FiniteWorldMaximizer.agda` — newly imported by the root;
  exit 0 standalone under 2.6.3/v0.5 (added 2026-08-15, message
  `collab/messages/0797-claude-hypothesis-drop-controls.md`). Imports only
  `Foundations.Prelude` and `Data/{Nat,Bool,Sum,Sigma,Unit,Empty}`; no
  solver, no tactic macro, no `Fin`, no `SymGroup`. Pinned-toolchain check
  OUTSTANDING like the rest of this list.
- `NaturalMachine/InflationVersusSubgroup.agda` — newly imported by the root;
  exit 0 standalone under 2.6.3/v0.5 (same message). Imports only
  `Foundations.Prelude` and `Data/{Bool,Empty}`; same no-skew profile.
  Pinned-toolchain check OUTSTANDING.
- `NaturalMachine/Control/MaximizerWithoutNonvanishing.agda` — a CONTROL: it
  **exits 42, and that is its pass condition**. Confirmed to fail for the
  intended reason (the dropped nonvanishing clause, named as `NonVanishing W`
  in the error at line 84), not incidentally. Not imported anywhere.
- `NaturalMachine/Control/InflationFlattened.agda` — a CONTROL: it **exits 42,
  and that is its pass condition**. Confirmed to fail for the intended reason
  (`k0 != kι`, the restriction-to-subgroup of the inflated class against the
  class itself, at line 91), not incidentally. Not imported anywhere.

Every import line added to `NaturalMachine.agda` and `Everything.agda` on that
branch was audited against a standalone run: all five modules check, so no
import line was removed. The defect this file was written to prevent — a
module folded into an aggregate without ever being checked — did not occur on
that branch.

Full measurements, method, and scope limits: `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md`.

## The pin was obtained and run, 2026-08-15 (Claude, pinned-toolchain pass)

Added, not overwritten. The section above ("Container/pin discrepancy and
OUTSTANDING checks") stands as an accurate record of what was knowable before
this run; this section discharges most of its OUTSTANDING list.

**Agda 2.8.0 + cubical v0.9 were both obtained in the container**: v0.9 by
`git clone --depth 1 --branch v0.9` into a *second* directory (the v0.5 clone
was left alone and selected against per-run with `--library-file`), and 2.8.0
by `apt-get install cabal-install`, `cabal get Agda-2.8.0`, `cabal build
exe:agda` against the system GHC 9.4.7. Roughly 75 minutes. Recipe, snags and
scope limits: `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.

**`agda NaturalMachine.agda` exits 0 under the pin** — 186
`UnsupportedIndexedMatch` warnings (the documented F39 boundary), zero errors.
The `PathIsSymmetry.agda:98` / `SymGroup` failure was exactly the v0.5 skew it
was diagnosed as: v0.9 defines `SymGroup` at
`Cubical/Algebra/SymmetricGroup.agda:28`. The file was correct un-edited, and
this file's central identity — "the root exits 0" and "the directory checks"
are the same claim — is restored under the pin.

Discharged against the pin (exit 0 under Agda 2.8.0 / cubical v0.9):
`StagewiseComposite.agda`, `SimplicialDefectFailure.agda`,
`Sl2DivisorLattice.agda`, `NaturalMachine/DecategorifiedDefect.agda`,
`NaturalMachine/RepairTorsor.agda`, `NaturalMachine/FillabilityCertificate.agda`,
`NaturalMachine/LineWorldTransport.agda`, and the root `NaturalMachine.agda`.

Confirmed against the pin, still failing:

- `NaturalMachine/Control/QuantifierDrop.agda` — the CONTROL. Exits 42 under
  2.8.0 for the intended reason: `error: [UnequalTerms]` at line 80 on the
  dropped quantifier. It passes.
- `PolarityClosure.agda` — exits 42 under the pin, `error:
  [ClashingDefinition] Multiple definitions of Sub`, against
  `Agda-2.8.0/lib/prim/Agda/Builtin/Cubical/Sub.agda`. The earlier note that
  this "might not clash under 2.8.0" is now answered: **it does**. The module
  is genuinely broken under the pin and needs the identifier renamed. Not
  done here.

**NEW OUTSTANDING — a module that is green under 2.6.3/v0.5 and red under the
pin:**

- `Sl2TensorProduct.agda` — `error: [NotInScope]: ·Rid` at line 115.
  `Cubical.Data.Int.Properties.·Rid` (v0.5) is spelled **`·IdR`** in v0.9. One
  error, one token. **Not fixed here**: renaming it would make the file right
  under the pin and wrong under the `/usr/bin/agda` that this container
  actually has, and the decision of which toolchain the sources track belongs
  to the owner and should be made once for the whole tree.
- Consequently **`Everything.agda` exits 42 under the pin**, aborting at
  `Sl2TensorProduct`. It therefore checks nothing imported after that module,
  and its exit code is not evidence about them in either direction.

Scope: twelve modules were run against the pin, not the whole tree. Given the
`·Rid` finding, expect other unswept modules to be red under the pin as well.
The pinned Agda was built into a session scratchpad and is **not** installed
as `/usr/bin/agda`, which remains 2.6.3.

## Orphans of `Everything.agda` swept and folded in, 2026-08-15 (Claude, Euclid-lineage orphan pass)

Added, not overwritten. Full method, tables and scope limits:
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §7.

The import closure of `Everything.agda` was recomputed from the sources and
diffed against `find . -name '*.agda'`: **367 files, 322 reached, 45 not** —
9 in `NaturalMachine/Control/` (which must never be reached; verified, every
mention of them outside that directory is a comment, not an import) and **36
genuine orphans**. Each orphan was run individually under the pin
(Agda 2.8.0 + cubical v0.9, `LC_ALL=C.UTF-8`); **33 exited 0 and were folded
into an aggregate**, and nothing red or unrun was folded in.

**`Everything.agda` from a clean tree (`_build` removed, zero `.agdai`
present), under the pin: EXIT=0, 358 modules checked, 0 errors, 200
`UnsupportedIndexedMatch` warnings.** Two earlier attempts were discarded
rather than published — one hit the cycle below, one was taken from a copy
made while a sibling's merge had two files transiently absent.

Two findings worth keeping:

- **`NaturalMachine/TransportCost.agda` cannot ever be reached from the
  root.** It `open import`s `NaturalMachine` itself, so listing it in the
  root is a `[CyclicModuleDependency]`. It is imported from
  `Everything.agda` instead. **The mechanical orphan check at the top of
  this file cannot clear such a module** — run the root, and its `.agdai`
  is missing not because someone forgot but because it is structurally
  impossible. Any module that imports the root inherits this.
- The `Everything.agda` block reading *"CenterRelative, PrimePairField,
  Swarm.S05/S08/S09/S11/S14 … fail with `solve!` not in scope … when the
  schism resolves, fold them in"* is **discharged**: `solve!` is the v0.9
  name, the owner's 2026-08-15 decision is that the sources track the pin,
  and all seven are green under it and imported. The block was superseded
  by addition, not deleted.

**Still OUTSTANDING (unchanged by this pass, and not folded in):**

- `NaturalMachine/DSONucleusMiddleAssociativityAudit.agda` — **UNRUN.** No
  exit code after >25 min of pin typechecking on a contended container. Also
  hit independently at 41 min by `notes/PIN_SWEEP_NATURALMACHINE.md` §3.
- `NaturalMachine/DSONucleusResidualAudit.agda` — **UNRUN**, same (>15 min).
- ~~`NaturalMachine/WalkFastInstance.agda` — **exit 137**, i.e. SIGKILL from
  the OOM killer, not a typecheck verdict. Folded in by another lane later
  the same hour; *this* pass establishes nothing about it.~~
  **DISCHARGED 2026-08-15, Landau-lineage pass** (addition; the struck text
  is the sweep's, kept verbatim because its refusal to call 137 a verdict
  was correct and is what made this pass worth doing). Under the pin —
  Agda 2.8.0 (the §6.1 binary, `--version` confirmed, not rebuilt) +
  cubical v0.9, `LC_ALL=C.UTF-8`, from a tree with **no `_build` and no
  `.agdai`** — the module exits **0** in **15 s** at a peak RSS of
  **333-388 MB** (two clean runs; GC variance), over 11 modules. **No source change was needed or made**: the
  `let`-sharing fix already in the file is correct under 2.8.0's conversion
  checker as well as the 2.6.3 one it was tuned against. 388 MB is not a
  module that exhausts a 16 GB container, so the 137 was contention from
  concurrent Agda processes, exactly as the sweep suspected.
  The root aggregate that imports it was then re-run from a clean tree:
  `NaturalMachine.agda` → **EXIT=0**, 293 modules, **0 errors**, 138 s,
  peak 1237 MB (192 `UnsupportedIndexedMatch` warnings, the documented F39
  boundary); `Everything.agda` → **EXIT=0**, 359 modules, **0 errors**,
  300 s, peak 1486 MB.

Discharged from the OUTSTANDING lists above this section by this pass:
`SimplicialDefectFailure.agda` — it was an orphan, as its author reported,
it exits 0 under the pin, and it is now imported by `Everything.agda`, so
the aggregate re-runs it.

## The whole lane, green and inside the closure, 2026-08-20 (Nālandā build lane)

Added, not overwritten. This section is the fourth time the paragraph at the
top of this file — *"the root aggregate now transitively reaches every module"*
— has had to be repaired, and the reason it rotted a fourth time is written
down here rather than the claim being restated a fourth time.

**The check that was supposed to prevent this had been dead.**
`scripts/check-agda-closure.sh` exists precisely because a hand-maintained
orphan list rots in both directions; its own header says so. On macOS it
aborted at a GNU-only `sed -i '1d'` — BSD `sed` reads the next argument as a
suffix and fails with *"invalid command code"* — so it exited on a message
about `sed` **before computing any closure at all**, for an unknown period,
while looking like it had run. A gate that crashes certifies nothing. Repaired
the same day to the portable `tail -n +2` by the univalent-audit lane. The
general lesson is the one this file already learned about prose and is now
learning about scripts: **a mechanism only enforces what it actually executes,
so a gate needs a check that it ran, not just that it exited.**

**What the repaired gate then reported: 199 of 780 modules outside the import
closure of `{Everything, NaturalMachine}`** — a quarter of the Agda lane
checked by nothing. Among them, `Madhava`, `Brahmagupta`, `Cakravala`,
`CakravalaBound`, `CakravalaNat`, `CakravalaWitness`, `Sulba`, `Trikarani`,
`Dvikarani`, `Vargana`, `DviGhataVargana`, `Shunya`, `BhavanaSamuha`,
`VargaprakritiSreni` — the modules carrying the book's primary-source
mathematics. Most of those were also RED, and being orphans, nothing would
ever have said so.

**State now, every number re-derived by running the check, none quoted:**

| check | command | result |
|---|---|---|
| closure | `bash scripts/check-agda-closure.sh` | ~~**784 on disk, 784 reached, exit 0**, 10 controls correctly unimported~~ — **true when written and stale by 2026-08-22**, see below |
| subtree root | `LC_ALL=C.UTF-8 agda NaturalMachine.agda` | **EXIT 0**, 0 errors, 203 warnings (the documented F39 `UnsupportedIndexedMatch` boundary) |
| whole lane | `LC_ALL=C.UTF-8 agda Everything.agda` | **EXIT 0**, 0 errors, 214 `UnsupportedIndexedMatch` warnings |
| `--safe` | `bash scripts/check-agda-pragmas.sh` | 802 files, 802 assert `--safe`, 794/794 under `formal/cubical/` assert `--cubical`, exit 0 |

### The closure row above went stale, and the gate that was supposed to catch that was lying in two directions at once — 2026-08-22

The `784 on disk, 784 reached, exit 0` row was true when it was written. By
2026-08-22 the tree held 889 modules. The row is struck rather than
overwritten because a stale number is evidence and deleting it destroys the
evidence.

**Neither of the two scripts that measure this was measuring it.**

1. `scripts/.prasava-unreached.sh`, whose row in `PRASAVA.tsv` read
   `agda-unreached 134`, did **one transitive step, not a closure**, and
   collapsed dotted module names to basenames. It also printed `agda-reached
   293` from `grep -c '^import ' Everything.agda` — the root's DIRECT imports,
   under a key that says *reached*. That row is now
   `agda-root-direct-imports`, which is what it counts.
2. Both that script and `scripts/check-agda-closure.sh` matched a module name
   with the ASCII-only class `[A-Za-z0-9_'.-]+`. **Every module whose name
   carries a non-ASCII character therefore read as never imported, however
   many roots imported it** — 17 of them here:
   `Ratri.Anirdharita_KloostermanExponents_ℤ±`,
   `…FiniteOccupancyChannelNoGo_Occupancy₄`,
   `…TheEquivalenceIsReal_विवेक` and their निर्धारण children. The gate cried
   orphan at exactly the files whose names were not English. CLAUDE.md names
   this failure one level up, about the header lint — *"a check that scores a
   Devanagari citation below a romanised one is this rule's own scrubbing
   arriving through the back door as a lint"* — and it arrived through the
   back door a second time, as a closure gate.

Both are repaired to *"a module name is the token up to whitespace"*, which
names no alphabet, so there is nothing to extend for Tamil or Persian.

**The true count, full closure, alphabet-free: 10, not 134.** All ten were run
individually on the pin and **all ten exit 0** — so the payoff number for
"a module nobody built may not build" is, this time, **zero failures**. They
are wired: eight into `Everything.agda`, two (`NaturalMachine.Alopa_…`,
`NaturalMachine.YantraTantu_…`) into `NaturalMachine.agda`. Ten controls under
`NaturalMachine/Control/` stay unimported, which is their obligation.

**And the row will go stale again, so the list is no longer hand-kept.**
`machine/Samuccaya_TheAggregateRootIsGeneratedFromTheTreeSoNothingCanBeOmitted.hs
--write` derives `formal/cubical/Samuccaya_….agda` from the filesystem: it
imports every `.agda` under the tree except the rows declared **with a
reason** in `formal/cubical/SAMUCCAYA_EXCLUSIONS.txt`. A module cannot be
omitted from it, because nobody writes it.

| check | command | result, 2026-08-22 |
|---|---|---|
| closure, both trees | `runghc machine/Samuccaya_…hs` | **889 on disk / 878 in scope / 878 reached / 0 unreached** in `formal/cubical`; **14/14** in `punaragamana/src`; exit 0 |
| derived root builds | `LC_ALL=C.UTF-8 agda Samuccaya_….agda` | **EXIT 0**, 0 errors, 270 `UnsupportedIndexedMatch` warnings, 878 imports |

`Everything.agda` is kept — it is the ANNOTATED index, and the annotations are
the part a generator cannot produce. It is imported by the derived root like
any other module. The closure gate still measures the HAND-KEPT roots on
purpose: the derived root makes the drift harmless, not absent, and a gate
rooted at the derived file would print 0 forever whatever the hand list did.

Toolchain: **Agda 2.8.0 + cubical v0.9 — the declared pin, and on this
container it is the default `agda`** (`/opt/homebrew/Cellar/agda/2.8.0`, with
`cubical` registered in `~/.agda/libraries` pointing at the v0.9 library
shipped with it). The 2026-08-15 sections above describe Linux containers on
which the pin had to be built by hand and `/usr/bin/agda` was 2.6.3; **that is
not the situation here**, and a reader must not carry those sections' "this
container is not the pin" caveat over to this one.

Getting there took two source repairs, each with its own commit and neither
changing a statement:

1. **The v0.5 → v0.9 migration, finished, in 41 modules.** `solve` → `solve!`
   / `solveℕ!` (with the per-call-site argument introduction this file's
   version-skew section documents — v0.9's macro parses an equality boundary,
   not a Π-type), `·Rid` → `·IdR`, `Symmetric-Group` → `SymGroup`. Before: 41
   exit 42. After: 41 exit 0, each run individually. This is the repair
   `Kuttaka.agda` received at `0f9f5454` and that its own header had
   predicted, applied to the rest of the tree.
2. **`SubgroupIndex.agda` had never typechecked at all.** Reported as one line
   of skew (v0.9's `Cubical.Relation.Nullary` newly exports `⟪_⟫`); fixing
   that exposed four further defects, including a proof term of no type
   carrying a self-described "placeholder" and a where-bound postfix `_⁻¹`
   whose default `infixl 20` is looser than `_∙_`'s 30 and therefore does not
   parse. Its header cites v0.9 sources by name: it was written by *reading*
   the library rather than by building against it. Statements unchanged; see
   that commit for the five-item list.

Then all 199 orphans were run individually, `LC_ALL=C.UTF-8 agda <file>`:
**199 exit 0, 0 exit 42.** Nothing red and nothing unrun was folded in. They
are imported by `Everything.agda` (the 29 top-level) and `NaturalMachine.agda`
(the 170 in the subtree), under headers marked ORPHAN FOLD-IN 4.

`NaturalMachine/TransportCost.agda` stays out of the subtree root and must:
it `open import`s that root, so listing it there is a
`[CyclicModuleDependency]`. It is the **only** module in the subtree with that
property — established by resolving every import line in the tree against the
root's name, not assumed — and `Everything.agda` imports it.

**What this section does NOT claim.** That the lane will stay this way. It is
one measurement, and the four previous repairs of this paragraph were also
true when written. What is different is only that the *gate* now runs on this
platform; quote `scripts/check-agda-closure.sh`'s exit code, not this table.
