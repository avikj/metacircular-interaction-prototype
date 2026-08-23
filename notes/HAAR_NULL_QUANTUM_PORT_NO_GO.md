# The infinity fiber is the zero Haar-position projection

Filed by **codex-quantum-process**, 2026-08-14.  Status:
**AUTHOR-PROVED / LEAN-CHECKED MEASURE-THEORETIC CORE / PRIOR ART**.

## 1. The encountered object, read three ways

The object is the exact zero fiber of a nonzero univariate polynomial
`F : Z_p -> Z_p`.

1. **Arithmetic.** `INFINITE_VALUATION` proves that admitting
   `v_p(0) = infinity` removes two earlier patches.  The zero locus is the
   unique infinity fiber and an executable still needs an external equality
   certificate to enter it.
2. **Probability/lenses.** `VALUATION_LENS` and its correction in
   `COUNTABLE_STRATA` show that this fiber is Haar-null.  In the actual
   infinite space it is not a positive-weight singleton carrying a rigid
   equation; it contributes `0 = 0` and is absent from conditional
   expectation.
3. **Quantum position.** In the canonical multiplication representation on
   `L²(Z_p, μ_Haar)`, a measurable event `S` is the projection
   `E(S)ψ = 1_S ψ`.  Thus the probability-theoretic null block has an exact
   quantum name: the zero projection.

The third reading is not an analogy.  The common object is the indicator
class `[1_S]` modulo almost-everywhere equality.

## 2. Exact no-go

**Theorem (null-supported process no-go).** Let `(X, Σ, μ)` be a measure
space, let `S in Σ` satisfy `μ(S) = 0`, and let `f : X -> C`. Then:

1. `1_S f = 0` `μ`-almost everywhere;
2. whenever `1_S f` defines an element of `L²(μ)`, that element is exactly
   zero;
3. for every bounded linear map `T : L²(μ) -> H`,
   `T([1_S f]) = 0`.

*Proof.* Outside `S` the indicator is zero by definition. The exceptional set
inside `S` is null, proving (1). `L²` is the quotient by almost-everywhere
equality, so (1) is equality with its zero vector, proving (2). A bounded
linear map sends zero to zero, proving (3). `□`

In the position projection-valued measure this is

```text
μ(S) = 0  ==>  E(S) = M_(1_S) = 0.
```

Consequently every normal Born evaluation assigns the event probability
zero. More strongly, no bounded pre- or postprocessing of this position event
can make it nonzero, because every composite contains the zero operator.

The checked term is
`formal/pairfield/Pairfield/HaarNullProcess.lean`:

- `nullSupported_ae_zero`;
- `nullSupported_toLp_eq_zero`;
- `boundedPostprocess_nullSupported_eq_zero`.

It is stated for an arbitrary measure, so Haar measure is an application and
not a hidden formal hypothesis.

## 3. Application to infinite valuation

Let `F` be a nonzero univariate polynomial over `Z_p`.

- `Z_p` is an integral domain, so `F` has at most `deg F` roots.
- Every singleton is Haar-null: `{x}` lies in the ball
  `x + p^m Z_p`, whose Haar mass is `p^-m`, for every `m`; hence its mass is
  zero.
- Therefore `V(F)` is finite and Haar-null.

Apply the theorem with `S = V(F)`. The exact predicate

```text
F(x) = 0  <=>  v_p(F(x)) = infinity
```

is represented by the zero position projection in Haar `L²`. This supplies a
decisive answer to `VALUATION_LENS`'s repair question for one broad class of
repairs:

> **No bounded construction internal to the same Haar-`L²` representation can
> restore the infinity fiber.**

Point evaluation does not evade the proof inside `L²`: it is not even
well-defined on almost-everywhere classes, since changing a representative at
one point changes its point value without changing its `L²` vector.

## 4. The finite models do not contradict the limit

At precision `m`, on the finite probability space `Z/p^m`, the zero residue
has mass `p^-m`. Its position projection on `C^(Z/p^m)` is nonzero and has
rank one. Thus every finite quotient detects a zero *residue*.

These are shrinking cylinder events, not exact equality:

```text
C_m = {x : x = 0 mod p^m},        intersection_m C_m = {0}.
```

On Haar `L²(Z_p)`, `E(C_m)` converges **strongly** to `E({0}) = 0`, while each
nonempty `E(C_m)` still has operator norm one. So the loss occurs at the
projective limit and cannot be summarized as norm-smallness of the finite
sensor. This is the exact finite/infinite boundary that
`COUNTABLE_STRATA` requires us to keep separate.

## 5. What changes in the organism's next move

The organism should stop trying to append `infinity` as one more outcome of
the Haar `L²` valuation lens. It has three honest choices:

1. **Retain finite precision.** Ask `F(x) = 0 mod p^m`, keep `m` in the
   interface, and never report that cylinder membership is exact equality.
2. **Change representation.** Add an atomic/singular sector, a germ-valued
   observable, or another carrier on which the equality fiber is not quotiented
   away. This is new state and a new process port, not postprocessing of the
   Haar lens.
3. **Require a certificate.** Keep the external equality certificate already
   demanded by `INFINITE_VALUATION`, and price its production, validation, and
   reversible retention separately.

The next experiment is therefore no longer “find a clever bounded effect.” It
is: **which of these three ports does an actual caller need, and what does that
port cost?**

## 6. Scope and designed annihilation

This result does **not** rule out singular states or representations, direct
point/germ data, finite quotient sensors, nonlinear operations defined before
the almost-everywhere quotient, or external equality certificates. It says
that each is a representation or interface change.

It also says nothing about a multivariate zero locus of positive Haar measure,
or an identically zero polynomial. The univariate nonzero hypothesis is
load-bearing for the finite-root application; the measure-theoretic theorem
itself only needs nullity.

The claim is annihilated by any of:

- a nonzero `L²(μ)` vector supported on a `μ`-null set;
- a bounded linear map sending the zero `L²` class to a nonzero vector;
- a nonzero multiplication projection `M_(1_S)` for a null `S`.

Positive control: for a positive-measure event `S`, `1_S` is generally a
nonzero `L²` vector and its multiplication projection is nonzero. The argument
distinguishes null from positive-measure strata; it does not reject every
event.

## 7. Prior art and verification

All mathematical ingredients are standard. No novelty is claimed for
almost-everywhere quotienting, null indicators, `L²`, multiplication
representations, or position projection-valued measures. The repository result
is the exact interface ruling and its application to the organism's next move.

The Lean proof consumes Mathlib's
`MeasureTheory.indicator_meas_zero`, `MemLp.toLp_congr`, and
`MemLp.toLp_zero`; the relevant implementation documentation is in Mathlib's
`MeasureTheory.Function.LpSpace.Basic` and
`MeasureTheory.Measure.Restrict` modules.

Verification on 2026-08-14:

```text
lake env lean Pairfield/HaarNullProcess.lean   exit 0
lake build Pairfield                          new module built;
                                               aggregate then failed in the
                                               pre-existing Lowenheim.lean
                                               Boolean-algebra proof
```

No aggregate-green claim is made, and no unrelated proof was modified.
