# Sufficient Interfaces — Delta 02: Tensor Products and Emergent Compression

Date: 2026-08-13
Status: VERIFIED EXACT finite results + LIVE FRONTIER
Depends on: SUFFICIENT_INTERFACES_DELTA_01_2026-08-13.md

## 0. Main result

Delta 01 proved submultiplicativity
    κ0(R1×R2) ≤ κ0(R1)κ0(R2)
and left strictness open.

Strict submultiplicativity already occurs in the smallest interesting symmetric example. This means jointly solving two independent relational tasks can require fewer interface states than separately minimizing and multiplying their interfaces.

## 1. Triangle relation

Let A={1,2,3}, B={12,13,23}, with
    R(1)={12,13},
    R(2)={12,23},
    R(3)={13,23}.

Equivalently the witness hyperedges are
    E_12={1,2}, E_13={1,3}, E_23={2,3}.

THEOREM 1.
κ0(R)=2.

Proof.
No one hyperedge covers all three vertices, so κ0≥2. Any two distinct edges cover A, so κ0≤2. QED.

## 2. Product compression

THEOREM 2.
For the Cartesian product relation R×R on A²,
    κ0(R×R)=3 < 4=κ0(R)^2.

Proof.
Each product witness gives a 2×2 rectangle E_e×E_f, containing 4 of the 9 points. Hence two rectangles cover at most 8 points, so κ0≥3.

Three rectangles suffice:
    E_12×E_12,
    E_13×E_23,
    E_23×E_13.

Explicitly:
E_12×E_12 covers
    (1,1),(1,2),(2,1),(2,2).
E_13×E_23 covers
    (1,2),(1,3),(3,2),(3,3).
E_23×E_13 covers
    (2,1),(2,3),(3,1),(3,3).

Their union is all 9 points. Therefore κ0=3. QED.

This kills the naive multiplicativity conjecture.

## 3. Interpretation

The product task has independent admissibility:
    (b1,b2) is valid at (a1,a2) iff b1∈R(a1) and b2∈R(a2).

Yet a globally chosen partition of A² can correlate which product witness is used across the two coordinates. The interface is not required to factor as q1×q2. This correlation produces compression.

This is a zero-error coordination analogue of block coding: joint coding across independent instances can outperform symbolwise coding.

Define the n-shot interface number
    κ_n(R)=κ0(R^{×n}).

By product construction:
    κ_{m+n}(R) ≤ κ_m(R)κ_n(R).

Hence a_n=log κ_n(R) is subadditive.

THEOREM 3 (asymptotic interface rate exists).
The limit
    K∞(R)=lim_{n→∞} (1/n) log κ_n(R)
exists and equals
    inf_n (1/n)log κ_n(R).

Proof.
Apply Fekete's lemma to the subadditive sequence a_n. QED.

For the triangle relation,
    K∞(R) ≤ (1/2)log 3 < log 2 = log κ0(R).

Thus asymptotic coordination complexity is genuinely different from one-shot interface complexity.

## 4. Hypergraph capacity/entropy direction

R determines a hypergraph H_R on A whose hyperedges are witness-compatible sets E_b. κ_n is the minimum number of product hyperedges needed to cover A^n.

Therefore exp(K∞) is an asymptotic covering growth rate of strong Cartesian powers of the witness hypergraph.

This is almost certainly adjacent to established hypergraph entropy / graph entropy / zero-error source coding / covering theory. PRIOR-ART SEARCH REQUIRED before novelty claims.

The important internal result is exact regardless of naming: the correct compositional invariant is asymptotic, not κ0 alone.

## 5. Distribution-dependent block coding

For iid X^n define
    κH,n(R;X)= inf H(F(X^n))
over valid selectors F:A^n→B^n satisfying coordinatewise validity.

Subadditivity follows by concatenating optimal block selectors:
    κH,m+n ≤ κH,m+κH,n.

Hence
    KH,∞(R;X)=lim_n κH,n/n
exists by Fekete.

The one-shot minimum-entropy labeling from Delta 01 may therefore also be strictly improvable by block coding.

LIVE FRONTIER:
Identify KH,∞ with the appropriate graph/hypergraph entropy and derive single-letter formulas under structural conditions.

## 6. A structural lesson for agent systems

Suppose R describes valid next actions given a research state. Compressing each independent research subproblem separately and concatenating contexts can be suboptimal. A joint context code over several subproblems may expose fewer total interface states because the selector can correlate choices across tasks.

This is not an LLM-specific claim. It is already forced by finite relational combinatorics.

For executable mathematics, this suggests batching is mathematically meaningful even before computational economies of scale:
    independent task validity + non-factorized interface = possible semantic compression.

## 7. Reconstruction dual

The same phenomenon has a reconstruction reading. If the goal is not to reconstruct each hidden state but merely to choose a valid witness for each coordinate, block observations can be strictly more efficient than coordinatewise sufficient observations.

This distinguishes:
- exact state reconstruction;
- exact deterministic target reconstruction;
- relational witness realization.

Only the third has selector freedom large enough for the triangle compression above.

That distinction should be preserved when importing Prime-Pair observability language: prime detection/reconstruction may be function-like, whereas research/action coordination is naturally relational.

## 8. Tensor structure for the proposed coordination category

A candidate symmetric monoidal structure has:
- objects: state spaces;
- morphisms: relations/processes;
- tensor: Cartesian product / parallel composition.

The invariant κ0 is submultiplicative under tensor:
    κ0(R⊗S)≤κ0(R)κ0(S),
but not multiplicative.

The regularized invariant
    K∞(R)=lim_n n^{-1}log κ0(R^{⊗n})
is additive under taking tensor powers of one object by construction:
    K∞(R^{⊗k})=k K∞(R).

Whether K∞(R⊗S)=K∞(R)+K∞(S) for distinct relations is a separate question and must not be assumed.

## 9. Fractional cover lower bound

Let τ*(H_R) be the fractional hyperedge-cover number:
minimize Σ_b w_b
subject to w_b≥0 and
    Σ_{b:a∈E_b} w_b ≥1 for every a.

THEOREM 4.
τ*(H_R) ≤ κ0(R).

Standard LP relaxation.

For product hypergraphs, fractional covers tensor naturally. Candidate theorem:
    τ*(H_{R×S}) = τ*(H_R)τ*(H_S).
This should be proved by primal product for ≤ and dual product for ≥.

Proof.
Primal: if w_b and v_c are fractional covers, assign z_(b,c)=w_b v_c. At (a,d),
Σ_{b:a∈E_b,c:d∈F_c} z_(b,c)
=(Σ_b w_b)(local? correction)
More precisely the local sum factors:
(Σ_{b:a∈E_b}w_b)(Σ_{c:d∈F_c}v_c)≥1.
Total weight factors, proving ≤.

Dual: fractional packing dual variables α_a, β_d with
Σ_{a∈E_b}α_a≤1 and Σ_{d∈F_c}β_d≤1.
Set γ_(a,d)=α_aβ_d. Every product edge obeys
Σ_{(a,d)∈E_b×F_c}γ=(Σ_{a∈E_b}α_a)(Σ_{d∈F_c}β_d)≤1.
Objective factors, proving ≥ by strong LP duality. QED.

Thus:
    τ*(R×S)=τ*(R)τ*(S).

COROLLARY 4.1.
For every n,
    κ0(R^n) ≥ τ*(R)^n,
hence
    K∞(R) ≥ log τ*(R).

For the triangle hypergraph, τ*=3/2, so
    log(3/2) ≤ K∞(R) ≤ (1/2)log 3.

Determining whether the asymptotic integral cover rate collapses to the fractional cover rate is now a precise question. This is likely governed by known asymptotic covering theory; search prior art.

## 10. Coordination "integrality gap"

Define one-shot overhead
    G1(R)=log κ0(R)-log τ*(R) ≥0.

Define asymptotic overhead
    G∞(R)=K∞(R)-log τ*(R) ≥0.

If G∞=0 for broad finite classes, then repeated parallel composition washes out the combinatorial integrality penalty and fractional coordination becomes operationally exact asymptotically.

This would be conceptually important for the library's economic/dual-variable work: LP dual prices may emerge as asymptotically sufficient coordination statistics even when one-shot integral coordination requires discrete extra states.

LIVE FRONTIER:
Prove or disprove G∞=0 for finite witness hypergraphs under unrestricted block selectors.

## 11. Link to economic dual variables

The library's convex coordination theorems show that m global coupling constraints can be mediated by an m-dimensional dual price vector. Fractional hypergraph cover duality is a finite analogue:
- primal weights distribute coverage resources over witnesses;
- dual weights price input states subject to witness-capacity constraints.

Tensor multiplicativity of the fractional optimum is exactly what one expects from a compositional "price" invariant.

This suggests a concrete bridge:
    discrete one-shot coordination → integral cover;
    convexified coordination → fractional cover/dual prices;
    repeated composition → regularized rate.

That is mathematics, not metaphor. The next task is to establish the exact asymptotic theorem and identify its known information-theoretic name.

## 12. Immediate queue

1. Prove/disprove K∞=log τ*.
2. Compute κ_n exactly for the triangle for n=3,4 if feasible; infer sequence.
3. Search graph/hypergraph entropy and asymptotic covering literature.
4. Extend to weighted/distributional entropy.
5. Add certificates and computational constraints.
6. Instantiate finite sieve observability as a witness hypergraph and compute κ0, τ*, K∞ for small prime sets.
7. Compare resulting dual variables with the library's finite-adic Walsh/charge modes.
