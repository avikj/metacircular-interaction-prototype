# Formal chain audit: `GoldbachDecisionRange` and `GoldbachCrossover`

Date: 2026-08-14

Scope: independent proof audit of the current-HEAD files
`formal/pairfield/Pairfield/GoldbachDecisionRange.lean` and
`formal/pairfield/Pairfield/GoldbachCrossover.lean`.  This audit performs no
Goldbach evaluation, census, or numerical experiment.

## Reproduction

Both commands completed with no diagnostics:

```text
lake env lean Pairfield/GoldbachDecisionRange.lean
lake env lean Pairfield/GoldbachCrossover.lean
```

## `GoldbachDecisionRange` boundary audit

The membership theorem has the exact endpoint conversion needed by the
checker:

```text
N ∈ List.range (X + 1)  iff  N < X + 1  iff  N ≤ X.
```

The filter then adds exactly `4 ≤ N` and `Even N`.  Consequently:

- `X < 4`: `goldbachTargets X` is empty and `GoldbachUpTo X` is vacuous,
  because its hypotheses include both `4 ≤ N` and `N ≤ X`.  Thus a `true`
  range check here does not assert a hidden small-center theorem.
- `X = 4`: the range includes `4` (`4 < 5`) and the filter retains it.  The
  upper endpoint is not lost.
- `N = 0`, `N = 1`, and odd `N`: these do not belong to the declared target
  list, exactly matching the hypotheses of `GoldbachUpTo`.
- `goldbachUpToCheck_eq_true_iff` uses the same membership theorem in both
  directions.  There is neither a sampled candidate set nor a finite-set/list
  coercion gap.
- `goldbachUpToCertificateOfCheck` applies the successful `List.all` proof
  only after reconstructing membership from `4 ≤ N`, `N ≤ X`, and `Even N`.
  The returned value is an actual `GoldbachFiber N`; wrapping it in
  `Nonempty` is exactly `GoldbachAt N`.

Verdict: no threshold or empty-range defect.

## Exact-contamination equivalence

Write

```text
M = mangoldtGoldbachCoeff N
P = primeLogGoldbachCoeff N
C = primePowerContamination N = M - P.
```

Over `ℝ`, `C < M` is exactly `M - P < M`, hence exactly `0 < P`.
`primeLogGoldbachCoeff_pos_iff N` identifies `0 < P` with `GoldbachAt N`.
Therefore

```text
primePowerContamination N < mangoldtGoldbachCoeff N ↔ GoldbachAt N
```

is valid for every natural center; it does not require `4 ≤ N` or parity.
At `N = 0` and `N = 1`, both sides are false.  At odd centers the theorem
remains a correct pointwise support statement (for example, its type permits
an odd center represented using the prime `2`); odd centers are simply outside
`StrongGoldbach` as defined here.

This equivalence is tautological after the exact definition of contamination.
The module documentation says so explicitly.  It is a contract boundary, not
an analytic estimate.

## Crossover case split

For a target supplied to `StrongGoldbach`, the proof splits on `N ≤ N₀`:

- If `N ≤ N₀`, `GoldbachUpTo N₀` receives all four required arguments:
  `N`, `4 ≤ N`, `N ≤ N₀`, and `Even N`.
- Otherwise, natural-number linear order converts `¬ N ≤ N₀` to `N₀ < N`,
  exactly the strict hypothesis of the tail.
- At `N = N₀`, the first branch applies.  There is no uncovered equality
  case and no duplicated obligation.
- If `N₀ < 4`, the finite premise is vacuous, but every eligible target has
  `N₀ < N` and is therefore correctly delegated to the tail.
- Odd `N` and `N < 4` never enter the body of `StrongGoldbach`, since its
  caller must first supply `Even N` and `4 ≤ N`.

The explicit crossover calls
`primePowerContamination_le_four_sqrt_mul_log_sq`, whose only threshold is
`1 ≤ N`; the in-scope hypothesis `4 ≤ N` proves this.  No missing `4 ≤ N`
assumption occurs in that use.

The certificate and Boolean-check variants merely transport the same finite
premise into this split.  They add no new endpoint.

## Result and rigor boundary

No confirmed defect was found, so no formal module was patched.

The checked chain proves a conditional composition theorem.  It does not
provide a value of `N₀`, execute `goldbachUpToCheck N₀`, or prove either tail
hypothesis.  In particular, the exact-contamination tail is pointwise
equivalent to Goldbach itself.  The sharper `4 * sqrt N * log(N)^2` tail is a
genuine sufficient lower-bound target, but no such Mangoldt lower bound is
established by these modules.
