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

- **Agda 2.6.3**
- **cubical library v0.5** (the release tag `v0.5`, not `master`)

`natural-machine.agda-lib` declares `depend: cubical`, so Agda resolves the
name `cubical` through `~/.agda/libraries`.

## One-time setup on a fresh container

```sh
# Agda + stdlib
apt-get install -y agda agda-stdlib      # gives Agda 2.6.3

# cubical v0.5, registered under the plain name `cubical`
git clone --depth 1 --branch v0.5 https://github.com/agda/cubical ~/agda-libs/cubical
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

## Version-skew notes (v0.5)

> **REGRESSION AND RE-REPAIR, 2026-08-14 (cf-corner; msg 0491).** Every
> reconciliation in this list had been *reverted* in the tree — the root
> aggregate `NaturalMachine.agda` exited 42 on a fresh pinned-toolchain
> container, breaking on `SymGroup`, then `factorial`, then `solveℕ!`, then
> `solve!`, then `·IdR`, in that order. Twelve modules were repaired back to
> the pinned names (commits `9bfb068`, `86f1fd9`, and the structural pass);
> the root aggregate now exits **0**, verified twice.
>
> The lesson is this repository's own: **the reconciliation was applied by
> hand, written down in prose, and silently regressed, because nothing
> mechanical held it.** That is the `exp27` shape at the level of the build.
> `.github/workflows/agda.yml` now checks the root aggregate on every push
> touching `formal/cubical/**`, and asserts the `Control/` negative controls
> still fail. Prose is the catalogue; CI is the enforcement.
>
> A second consequence, recorded because it bit: the modules were authored
> against a *newer* cubical, and `machine-ledger.tsv` cycles 0–3 recorded
> "87/87 green, aggregate 0" — true in whatever container ran them, false
> under the declared pin. A green is an exit code **and a toolchain**; the
> ledger rows now carry neither, so they cannot be replayed. Future rows
> should carry the agda and cubical versions.

The corpus was written against a newer cubical than v0.5; the following
name/convention differences were reconciled so it checks under the pinned tag.
Reapply the inverse if you upgrade cubical:

- `SymGroup` → `Symmetric-Group` (`Cubical.Algebra.SymmetricGroup`).
- `Cubical.Tactics.NatSolver.Reflection`: the macro is `solve`, used on the
  *quantified* goal (`f = solve`), not `solveℕ!` on the intro'd goal
  (`f x y = solveℕ!`).
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

## Verified working in a fresh remote container, 2026-08-14 (cf-sakshi)

The setup above works verbatim. Two things worth adding:

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
