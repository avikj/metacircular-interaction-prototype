> **Encoding warning.** The `State = (c,n₀,n,N,A,...)` / `observe : State → Bool`
> coalgebra described below is an obsolete manual scheduler, not the natural input
> to the universal cubical inference machinery. The proposition `E1 : Set` already
> is the complete dependent object. Turning its binders into a stream of parameter
> tuples and Boolean observations flattens the proof geometry before inference.
> Use `Problem1Statement.bend:ErdosProblem1()` directly as the proposition to inhabit;
> the default move space is the kernel's identity-preserving cubical inference.

# Erdős Problem 1: the complete parameterized fibre object

## Original proposition

For a finite set (Asubseteq{1,ldots,N}), write

```text
SS(A) = { Σ a∈S a | S ⊆ A }.
```

The Erdős statement is:

```text
If |A| = n and the map S ↦ Σ a∈S a is injective on 𝒫(A),
then N ≫ 2^n.
```

The asymptotic relation (Ngg 2^n) is represented by the parameterized
proposition

```text
E1 =
  Σ c : ℕ . (0 < c)
  × Σ n₀ : ℕ .
      ∀ n : ℕ . n₀ ≤ n →
      ∀ N : ℕ .
      ∀ A : FiniteSubset({1,...,N}) .
        (|A| = n) → DistinctSubsetSums(A) → c · 2^n ≤ N.
```

`E1` is the complete proof fibre of the conjecture. An inhabitant is a
constant, threshold, and proof of the universal implication. Its negation is
the counterexample fibre: for every proposed constant/threshold it retains a
larger parameter and an admissible set violating the bound.

The source statement and all 1,217 numbered records are preserved in
[`ERDOS_PROBLEMS_FULL.md`](ERDOS_PROBLEMS_FULL.md).

## Fibre coalgebra

The proposition is not converted into a finite candidate list. Its coalgebraic
state is the complete parameterized query:

```text
State = (c, n₀, n, N, A, admissibility evidence, continuation)
```

The observation map returns the Boolean truth of the current implication,
while the carried value retains the parameter tuple and its proof fibre:

```text
observe : State → Bool
carrier : State → Σ b : Bool . (observe state = b)
next    : carrier state → State
```

The local total classified object is therefore

```text
Σ b : Bool . fiber observe b
```

with each fibre retaining the original parameter, admissibility proof,
inequality proof or refutation witness, and the continuation for the next
parameter. The outer `Σ c, Σ n₀, ∀ n, ∀ N, ∀ A` quantifiers compose these
local fibres into `E1`; the opposing false fibre is the corresponding
counterexample family. This is the full proposition passed to the
coinductive fibre law; it is not the bounded (N=7,n=3) slice.

The generic checked construction is [`SATFibre.agda`](../sat_fibre/SATFibre.agda):
`partition = P.Fibre.lossless` gives the source/output/fibre equivalence and
`reduce-carried` retains the source and observation in every reproduced
coordinate. [`SATBoundary.agda`](../sat_fibre/SATBoundary.agda) supplies the
same lossless residual presentation when the proposition is split into a
prefix and its future obligation set.

## Relation to the executed slice

The executable (N=7,n=3) run is the restriction of this object to one
parameter fibre. For three positive elements, distinct subset sums are
equivalent to excluding (a+b=c). The full object contains that local fibre
as one observation; it also contains every other (n,N), the asymptotic
constant and threshold, and the proof/counterexample continuation.

The slice receipt is retained for runtime calibration in
[`problem1_N7_n3_fibre.json`](problem1_N7_n3_fibre.json). It is evidence for
the finite projection, not a replacement for the parameterized object above.
