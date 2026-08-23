# Finite positive exposed-point rigidity

Status: **checked finite quantitative theorem**.

`formal/pairfield/Pairfield/FinitePositiveExposedPoint.lean` formalizes the
finite complex kernel of `EXPOSED_POINT_RIGIDITY.md`. For a finite index type,
weights `wᵢ : ℝ`, and unit-disc coefficients `cᵢ : ℂ`, define

```text
deficit(w,c) = Σᵢ wᵢ (1 - Re(cᵢ)).
```

The leaf proves the exact identity

```text
deficit(w,c) = Σᵢ wᵢ - Re(Σᵢ wᵢ cᵢ).
```

## Quantitative theorem

For every unit-disc point,

```text
‖1-c‖² ≤ 2(1-Re(c)).
```

The constant two is attained at `c=-1`. If all weights are nonnegative and a
declared `μ≥0` satisfies `μ≤wⱼ`, the checked coordinate estimate is

```text
μ ‖1-cⱼ‖² ≤ 2 deficit(w,c).
```

Thus a coefficient separated from one and carrying a known weight floor
forces a visible real-part deficit. This is the quantitative successor named
but not proved in the sampled note.

If every weight is strictly positive and the deficit is zero, the estimate at
each coordinate forces every coefficient to equal one. In particular, exact
equality of the finite complex aggregate with its all-ones value exposes the
all-ones coefficient family.

## Two controls

On `Bool`, take coefficients `(1,-1)` and weights `(1,ε)`. The leaf checks

```text
deficit = 2ε,
‖1-(-1)‖ = 2.
```

At `ε=0`, all weights are nonnegative and the full complex aggregate is
unchanged, yet the second coefficient is not one. Strict positivity is
therefore load-bearing for exact rigidity.

For every `η>0`, choosing `ε=η/4` makes both weights strictly positive while
retaining displacement two and giving `deficit<η`. Thus positivity alone does
not supply one stability constant uniform across **all varying weight
families**; a declared lower weight bound is load-bearing for the quantitative
estimate. This does not deny that any one fixed finite positive family has a
positive minimum weight.

## Scope

This leaf proves finite `Fintype` sums only. It does not formalize countable or
summable families, interchange real parts with infinite sums, define a
Dirichlet series, derive complete-multiplicative coefficient bounds, prove
analytic continuation, or establish the sampled note's Dirichlet corollary.
The theorem is elementary and no novelty is claimed.

The prior `Swarm.S13OptionSpread.sum-rigid` proves an unweighted natural-list
analogue by termwise order. The present result is nonduplicate: it supplies
complex unit-disc geometry, arbitrary finite nonnegative weights, the exact
aggregate identity, a sharp coordinate stability inequality, and the two
weight controls. The Pairfield aggregate remains untouched.

## Draw 6 provenance

Literal no-redraw Draw 6 froze origin
`457b42cf36d6f97228f7d58d75402f5c143a035c`, tree
`dccf8796bdc310f22d2cc6667b70596bd52dabd6`. The 1,070-path C-sorted tracked
`.agda`/`.lean`/`.md` frame under `formal/`, `notes/`, and `papers/` excluded
build paths and the five prior sampled objects; SHA-256 was
`c813138de9870248e45bb5f0271f3d3b2a63764389a8f664d77ce84fde377dbb`.
The rejection limit was `4294967160`; the sole `/dev/urandom` uint32
`1937596209` was accepted with zero rejections at zero-based index 619
(position 620), selecting `notes/EXPOSED_POINT_RIGIDITY.md`, blob
`9a8708d905f630d18d804f9a2ef668b17a60f03e`. There was no redraw.
