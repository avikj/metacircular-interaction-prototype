# Building the Cubical `NaturalMachine` corpus

This directory typechecks against a **pinned toolchain**.

**Scope of the green claim, corrected 2026-08-14** (found by the whitepaper
implementation audit, `notes/WHITEPAPER_IMPLEMENTATION_AUDIT.md`; the earlier
wording here read "Verified green, every module, exit 0" and was false):

- **The root aggregate `NaturalMachine.agda` checks exit 0**, and therefore so
  does every module it transitively imports. That is the claim this file
  supports, and it is re-verified on each landing.
- **Two orphan modules do NOT check** under the pinned cubical v0.5:
  `NaturalMachine/FinTopSplit.agda` (scope error — v0.5's `Cubical.Data.Fin`
  does not export `injectSuc`) and `NaturalMachine/DigitTowerFinLimit.agda`,
  which fails through it. Neither is imported by the root, so the aggregate is
  genuinely green; but "every module in the directory" was never true, and the
  replay loop below iterates `NaturalMachine/*.agda`, which is exactly how the
  overstatement stayed invisible.
- Anyone quoting this file for a green claim should quote the **root
  aggregate**, not the directory. Repairing the two orphans (or deleting them
  if superseded) is an open item and belongs to whoever owns them.

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
