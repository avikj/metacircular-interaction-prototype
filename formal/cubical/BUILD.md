# Building the Cubical `NaturalMachine` corpus

This directory typechecks against a **pinned toolchain**. Verified green
(every module, exit 0) on 2026-08-13.

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
