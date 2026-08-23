# Finite Cesàro convolution is a layer-cake identity

**Status:** machine-checked in Lean.  The exact theorem surface is
`formal/pairfield/Pairfield/FiniteCesaroConvolution.lean`.

## Result

The sampled `E2B_PROOF` begins its analytic argument with the elementary
identity that a tent-weighted convolution equals an integral of two partial
sums.  This leaf checks its finite counting-measure skeleton without importing
any of the later analytic claims.

For a horizon `N`, a pair `(m,n)` and split point `u` are compatible when

```text
m ≤ u,       n < N-u.
```

The endpoints are deliberately asymmetric: the left prefix contains `u`,
while the right prefix stops before `N-u`.  The admissible split points are
exactly `N-m-n` in number, with natural subtraction making the weight zero
when `m+n ≥ N`.

`finite_layer_cake` proves this before multiplication enters.  For any
additive commutative monoid `A` and any `h : ℕ → ℕ → A`, it identifies

```text
Σ (u,m,n), m ≤ u and n < N-u, h(m,n)
```

with

```text
Σ m<N, Σ n<N, (N-m-n) • h(m,n).
```

The proof is an explicit bijection of witnesses:

```text
(u,m,n) ↦ (m,n,u-m),
(m,n,j) ↦ (m+j,m,n).
```

Lean checks membership, injectivity, surjectivity, and preservation of the
summand.  No finite table or search proves the theorem.

For an arbitrary commutative semiring `R`, define

```text
partialSum f k = Σ n<k, f(n),
additiveConvolution f g k = Σ m+n=k, f(m)g(n),
finiteCesaro f g N = Σ k<N, (N-k) • additiveConvolution f g k.
```

The module then proves

```text
finiteCesaro_eq_sum_prefix_mul_prefix :
  finiteCesaro f g N
    = Σ u<N, partialSum f (u+1) * partialSum g (N-u).
```

This is not obtained by treating the two presentations as definitionally
equal.  A second explicit reindexing

```text
(k,m) ↦ (m,k-m),
(m,n) ↦ (m+n,m)
```

checks the regrouping by Mathlib's actual natural-number antidiagonals.
`finiteCesaro_eq_tentPairSum` records the intermediate equality, so the
antidiagonal step can be consumed independently.

## Endpoint falsifier

Let `deltaZero` be unit mass at `0`.  At `N=1`, Lean reduces the following
without a tactic or enumerator:

```text
finiteCesaro deltaZero deltaZero 1 = 1,
Σ u<1, partialSum deltaZero (u+1) * partialSum deltaZero (1-u) = 1.
```

Two hostile alternatives also reduce definitionally:

```text
Σ u<1, partialSum deltaZero u     * partialSum deltaZero (1-u)   = 0,
Σ u<1, partialSum deltaZero (u+1) * partialSum deltaZero (1-u-1) = 0.
```

Thus omitting either load-bearing endpoint already fails on the smallest
nonempty instance.

## Prior-art and novelty boundary

The identity is elementary finite Fubini/layer-cake algebra, and no
mathematical novelty is claimed.  The tracked corpus already contains
antidiagonal convolution coefficients in `Pairfield.GoldbachWeightedBoundary`
and `Pairfield.SumRigidity`; Mathlib already contains Cauchy-product and
antidiagonal enumeration lemmas.  A search through the frozen draw tree and
the then-current `origin/main` found no theorem combining tent weights with
the complementary-prefix product identity.  This leaf adds that exact checked
adapter and its endpoint controls.

## Analytic scope fence

This theorem is not the continuous identity in `E2B_PROOF` Lemma C1: no
Lebesgue/Riemann integral or real interval measure appears.  It is the exact
counting-measure analogue at an integer horizon.  It does not formalize or
verify:

- `Λ♯`, `Λ♭`, their periodic means, or their partial-sum estimates;
- the truncated von Mangoldt explicit formula or Riemann–von Mangoldt;
- RH, nontrivial zeros, Gamma/reflection formulas, or Beta integrals;
- absolute convergence of either zero sum or the pair-tail bound;
- any error term or blockwise E2b asymptotic;
- any prior-art or novelty statement about the analytic theorem.

The sampled note remains a prose analytic proof using imported theorems.  The
kernel has checked only the finite algebraic seam stated above.

## Draw provenance

Draw 13 froze `origin/main` commit
`c12210eaf98d48de347eca3d936bea4948336f08`, tree
`5f595688af0efbb3dd3ab6a3a5fd8da4d00ca425`.  The frame was the C-sorted
tracked semantic corpus under `formal/`, `notes/`, and `papers/`, restricted to
`.agda`, `.lean`, and `.md`, excluding build products and the exact twelve
earlier samples.  It contained 1,046 paths and had SHA-256
`b4752431356a58dc5cc9781a470f5769ab010d055ae18b6dcae567df91ac5c40`.

The unbiased acceptance limit was `4294967002` (tail size 294).  The sole
native `/dev/urandom` uint32 was `3494484698`, accepted at zero-based index
576 (one-based position 577), selecting `notes/E2B_PROOF.md`, blob
`d962602cf0e2b9c17c929ac89377c1d3163a74a6`, 23,859 bytes.  The sampled
object's provenance commit is `fde46d462bd9765d2a3bb0861bc44397de19dd5c`.

## Verification

From `formal/pairfield/`:

```sh
lake env lean Pairfield/FiniteCesaroConvolution.lean
lake build Pairfield.FiniteCesaroConvolution
```

Both exit 0; the focused build completes 8,706 jobs.  The leaf contains no
`sorry`, `admit`, or declared axiom and is not imported by the foreign-modified
Pairfield aggregate.
