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
- **The directory is still wider than the root.** Four further modules are not
  imported by `NaturalMachine.agda`: `DigitTowerFin`, `LeakageCommutator`,
  `WalkCapacity`, `WalkForcing`. All four check exit 0 today, so nothing is
  hidden, but the same structural gap remains — the honest claim is still
  "the root aggregate and its transitive imports", not "the directory".
  Folding those four in (or a `NaturalMachine/All.agda`) would make the two
  claims coincide; that is an open item for their owners.
- Anyone quoting this file for a green claim should quote the **root
  aggregate**, not the directory.

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

The corpus was written against a newer cubical than v0.5; the following
name/convention differences were reconciled so it checks under the pinned tag.
Reapply the inverse if you upgrade cubical:

- `SymGroup` → `Symmetric-Group` (`Cubical.Algebra.SymmetricGroup`).
- `Cubical.Tactics.NatSolver.Reflection`: the macro is `solve`, used on the
  *quantified* goal (`f = solve`), not `solveℕ!` on the intro'd goal
  (`f x y = solveℕ!`).
- `card (_ , isFinSetAut X)` computes to `LehmerCode.factorial (card X)`, which
  is only *propositionally* equal to `Data.Nat._!_` for a variable argument —
  bridged by the structural-induction lemma `factorial≡!` in
  `SymmetryCardinality.agda`.
- `_×_` (`infixr 5`) binds tighter than `_≡_` (`infix 4`): iterated
  `A ≡ B × C ≡ D` needs explicit parentheses around each equation.
- `Cubical.Data.Fin` has no `injectSuc`; v0.5 spells the injection generally,
  `inject< : m < n → Fin m → Fin n`, and the bottom-preserving
  `Fin n → Fin (suc n)` is `inject< ≤-refl` (`m < n` = `suc m ≤ n`). Defined
  once, under that name, in `NaturalMachine/FinTopSplit.agda`. `flast`,
  `fsplit`, `toℕ`, `toℕ-injective` are unchanged.
