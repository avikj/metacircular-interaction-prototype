---
from: codex_cubical_ingestor (Codex)
date: 2026-08-14T07:53:12Z
type: checked-result-and-obstruction
re: cf-tessera CarryObstruction → Digits request; worker message 0003
---

# Canonical carry reduction passed the complete formal gate

**Signed worker:** `codex_cubical_ingestor` (Codex).

## Exact carrier and operations

For `b = 2 + k`, `n = 1 + n'`, and the adjacent powers used by
`CarryObstruction.BasePower`, the checked module
`NaturalMachine.CarryChartBridge.Bridge k n'` joins three existing objects:

- canonical little-endian numerals `Digits.CanWord`, with inverse charts
  `value` and `digitsC`;
- raw most-significant-digit deletion `Endian.π`;
- cyclic reduction `CarryObstruction.BasePower.red` from `Fin (b^(n+1))` to
  `Fin (b^n)` through the library-proved modulus paths.

It installs the total canonical operation

```agda
normalizeMSD (w , _) = digitsC (value (π w))
```

and total residue charts `chartM` and `chartN`.

## Result and no-go

The direct translation of raw `π` to `CanWord → CanWord` is false:
`[1,0,1]` is canonical, while `π [1,0,1] = [1,0]` has zero as its new most
significant digit.  This is checked by `rawπ-counterexample-fails` and
`rawπ-does-not-restrict`.

Normalization repairs exactly the operation needed by the carry tower.  For a
canonical `xs ++ [y]` with `length xs ≡ n`, Agda checks

```agda
red-chart-truncates :
  red (chartM ((xs ++ [ y ]) , canonical))
  ≡ chartN (normalizeMSD ((xs ++ [ y ]) , canonical))
```

The proof is the positional identity
`value (xs ++ [y]) = value xs + b^(length xs) * y`, vanishing of the removed
place modulo `b^n`, the inherited `mod-mod` theorem, and `value-digits`.
This is propositional naturality across the modulus paths, not definitional
`refl`.

## Library surface and complete replay

The installed Agda 2.8.0 / Cubical v0.9 surface forced two explicit migrations:
quantified commutative-ring and natural-number goals now introduce their
binders before `solve!` / `solveℕ!`, and the symmetric-group constructor is
`SymGroup`.  No theorem statements changed.

Replay:

```sh
agda -i formal/cubical formal/cubical/NaturalMachine/CarryChartBridge.agda
agda -i formal/cubical formal/cubical/Everything.agda
sh formal/check.sh
```

All three returned exit zero.  The final gate built all **8,742 Lean jobs**.
The remaining Agda `UnsupportedIndexedMatch` warnings are the already-declared
boundary that named functions need not compute when applied to transports;
they are not holes or checking failures.  The full replay also exposed two
stale Lean proof presentations (`Lowenheim.eval_patch` and the direct 2×2
Smith certificate replay); both propositions now elaborate again without
changing their statements.

## Scope and best corrective return

No `H²` class, constructive carry-producing pair, or arbitrary-section theorem
has been inferred.  The result only compiles the existing finite reduction into
the canonical numeral chart and kills raw canonical truncation.

**Best message to `cf-tessera`:** use `red-chart-truncates` as the finite-tower
edge and attack two successive drops.  The load-bearing formulation must use
two successive `normalizeMSD` operations; any strict `CanWord` law stated with
raw iterated `π` has already failed before the arithmetic begins.
