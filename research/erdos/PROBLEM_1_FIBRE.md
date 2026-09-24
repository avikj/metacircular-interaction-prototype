> **Negative benchmark only.** This bounded experiment deliberately fixes `N=7,n=3`,
> compiles the problem to CNF, and materializes the complete satisfying model fibre.
> Its 15,001-node heap is a cost of that finite SAT/model-enumeration presentation;
> it is not evidence about the universal Erdős proposition or universal cubical
> inference. Do not use this file as the architecture for Problem 1. The direct
> dependent proposition is `collab/bend2-interactive-cubical/erdos1/Problem1Statement.bend`.

# Erdős Problem 1: bounded fibre execution

## Source statement

> If `A ⊆ {1,...,N}` with `|A| = n` is such that the subset sums
> `Σ_{a∈S} a` are distinct for all `S ⊆ A`, then `N ≫ 2^n`.

The exact source text is preserved as Problem 1 in
[`ERDOS_PROBLEMS_FULL.md`](ERDOS_PROBLEMS_FULL.md). The asymptotic `≫` is
the usual existence of a positive constant and a threshold, so the complete
unbounded statement is a proposition over all `n` and all admissible `A`.

## Finite proposition supplied to the fibre

To execute a closed finite instance, fix `N = 7` and `n = 3`. Let
`x₁,...,x₇ : Bool` encode membership in `A`, and define

```text
A(x)                 = { i ∈ {1,...,7} | xᵢ = true }
Good₁(x)              = (|A(x)| = 3)
                        ∧ (S ↦ Σ_{a∈S} a is injective on 𝒫(A(x))).
P₁₍₇,₃₎(x)            = Good₁(x).
True(P₁₍₇,₃₎)          = Σ x : Bool⁷ . (P₁₍₇,₃₎(x) = true).
False(P₁₍₇,₃₎)         = Σ x : Bool⁷ . (P₁₍₇,₃₎(x) = false).
```

The script [`problem1_bounded_fibre.py`](problem1_bounded_fibre.py) compiles
the exact Boolean predicate to an HVM4 net using the same SAT fibre
presentation as [`experiment.py`](../sat_fibre/experiment.py). Its CNF is
constructed directly from the cardinality clauses and the forbidden
`a+b=c` triples; it does not truth-table the predicate to discover the models.
It asks HVM4 for the complete true fibre (`#SAT` models), not for one
candidate selected by a host loop.

## Executed result

The fibre contains 26 subsets:

```text
{5,6,7} {4,6,7} {4,5,7} {4,5,6} {3,6,7} {3,5,7} {3,5,6}
{3,4,6} {3,4,5} {2,6,7} {2,5,6} {2,4,7} {2,4,5} {2,3,7}
{2,3,6} {2,3,4} {1,5,7} {1,4,7} {1,4,6} {1,3,7} {1,3,6}
{1,3,5} {1,2,7} {1,2,6} {1,2,5} {1,2,4}
```

The native receipt is [`problem1_N7_n3_fibre.json`](problem1_N7_n3_fibre.json):

```text
ITRS:       6,797 interactions
heap nodes: 15,001
models:     26
```

The emitted program is [`problem1_N7_n3_models.hvm4`](problem1_N7_n3_models.hvm4)
and its raw runtime output is
[`problem1_N7_n3_models.log`](problem1_N7_n3_models.log). This is the exact
finite fibre of a bounded Erdős Problem 1 proposition; the universal
asymptotic statement remains the parameterized proposition recorded above.
