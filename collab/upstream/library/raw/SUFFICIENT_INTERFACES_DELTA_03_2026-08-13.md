# Sufficient Interfaces — Delta 03: Regularization Theorem and the Fractional Limit

Date: 2026-08-13
Status: VERIFIED EXACT internally; KNOWN PRIOR ART identified for the hypergraph theorem
Depends on Deltas 01–02.

## 0. Resolution of the main live target

For a finite relation R:A↝B, let H_R have vertex set A and witness hyperedges E_b={a:b∈R(a)}.
Let κ_n(R)=τ(H_R^{×n}), where product hyperedges are Cartesian products.
Let τ*(H_R) be the fractional edge-cover number.

Delta 02 asked whether
    K∞(R)=lim_n (1/n) log κ_n(R)
equals log τ*(H_R).

ANSWER: YES.

This is not novel as a hypergraph theorem. Standard fractional graph/hypergraph theory states that the asymptotic covering number of a hypergraph equals its fractional covering number. Our contribution here is the exact identification of the relational-interface regularization with that theorem and its consequences for the Coordination Graph program.

## 1. Theorem

THEOREM 1 (regularized relational interface theorem).
For every finite total relation R,
    lim_{n→∞} κ0(R^{×n})^{1/n} = τ*(H_R),
hence
    K∞(R)=log τ*(H_R).

Proof.
The product relation's witness hypergraph is exactly the categorical/product hypergraph power H_R^{×n}. The asymptotic hypergraph covering theorem gives
    lim_n τ(H_R^{×n})^{1/n}=τ*(H_R).
Since κ0(R^{×n})=τ(H_R^{×n}) by Delta 01, substitute. QED.

Prior art: this equality is explicitly stated as Theorem 1.6.2 in Fractional Graph Theory: asymptotic covering number equals fractional covering number for every hypergraph. The surrounding theory also proves multiplicativity of fractional cover under hypergraph product.

## 2. Consequence: the integrality overhead is purely one-shot asymptotically

Define
    G1(R)=log κ0(R)-log τ*(R),
    G∞(R)=K∞(R)-log τ*(R).

COROLLARY 2.
    G∞(R)=0
for every finite relation.

Thus unrestricted block composition washes out the exponential rate contribution of the integral cover gap. There may remain subexponential overhead, but no positive per-instance logarithmic penalty.

This is a strong answer to Delta 02.

## 3. Triangle example solved

For the triangle witness hypergraph:
    κ0=2,
    τ*=3/2.

Therefore
    K∞=log(3/2).

Delta 02's two-shot code gave κ2=3 and rate (1/2)log 3, which is above the asymptotic optimum. Longer block codes approach log(3/2).

The asymptotic number of context/interface states grows as
    (3/2)^{n+o(n)}
rather than 2^n.

## 4. Dual form

Fractional edge cover primal:
    minimize Σ_b w_b
subject to
    Σ_{b:a∈E_b} w_b ≥1  for every a,
    w_b≥0.

Dual:
    maximize Σ_a α_a
subject to
    Σ_{a∈E_b} α_a ≤1 for every b,
    α_a≥0.

Thus the regularized interface complexity is the log of a convex optimization value with an exact dual.

Interpretation internal to the coordination program:
- primal weights are fractional mass on globally valid witness/actions;
- dual weights price distinguishable input states subject to the constraint that any one common witness can absorb at most unit total dual mass.

No economic interpretation is needed for the theorem, but this is the exact mathematical location where the library's dual-price coordination results can connect.

## 5. A compositional invariant

Define
    C0(R)=log κ0(R),
    C∞(R)=log τ*(H_R).

Then:
1. C∞(R)≤C0(R).
2. C∞(R×S)=C∞(R)+C∞(S), because τ* is multiplicative under product.
3. Under total postprocessing S after R,
       C∞(S∘R)≤C∞(R),
   since every R-compatible hyperedge is contained in a composite-compatible hyperedge.
4. C∞=0 iff one witness is valid for every input.

So C∞ is an additive tensor invariant with a data-processing inequality.

This is substantially cleaner than κ0.

## 6. Proof of postprocessing inequality directly at LP level

Let T=S∘R. For every R witness b choose some c_b∈S(b). Then
    E_b^R ⊆ E_{c_b}^T.
Any fractional cover w on R can be pushed forward by summing weights of b mapping to the same c. The resulting weights cover every a with no larger total mass.
Therefore
    τ*(T)≤τ*(R).

Hence C∞ obeys extensional data processing.

## 7. Why this matters for the proposed coordination category

The one-shot interface ideal Suff(R) is combinatorially irregular: joins fail and κ0 is nonmultiplicative.
Regularization produces a convexified invariant:
    relation R
      ↦ witness hypergraph H_R
      ↦ fractional cover polytope
      ↦ τ*(R)
      ↦ log τ*(R).

Parallel composition becomes addition after log.
Postprocessing becomes monotone decrease.

This resembles the passage from microscopic discrete configurations to an extensive thermodynamic potential. That analogy is optional; the exact content is the additive/monotone invariant above.

## 8. A candidate universal property

Let F be a real-valued invariant on finite total relations satisfying:
- tensor additivity F(R×S)=F(R)+F(S);
- postprocessing monotonicity;
- normalization on a deterministic k-valued surjection f: F(f)=log k;
- suitable asymptotic continuity/block-coding regularity.

QUESTION:
Is C∞ uniquely characterized by axioms of this kind?

Do not assume yes. This is a Shannon-style characterization problem.

A uniqueness theorem would make log τ* a canonical "coordination information" for zero-error relational realization rather than merely one useful invariant.

## 9. Deterministic specialization

If f:A→B is deterministic with image size k, witness hyperedges are the disjoint fibers f^{-1}(b).
Fractional covering requires weight at least 1 on every nonempty fiber, so
    τ*=k.
Thus
    C∞(f)=log |im f|,
matching exact zero-error deterministic output complexity.

For genuinely relational tasks, τ* can be nonintegral and block coding realizes the fractional value asymptotically.

This cleanly locates the extra power of relational choice.

## 10. Prime-Pair connection: what can and cannot transfer

The Prime-Pair reconstruction program studies whether restricted observable families distinguish a desired arithmetic charge/event. That is primarily reconstruction/function identification, not arbitrary relational selection.

Therefore the fractional-cover gain does NOT automatically imply a way around sieve parity.

A legitimate arithmetic instantiation would require defining:
- finite arithmetic state set A_z;
- observable quotient q_z;
- target relation R_z of acceptable certificates/actions;
- witness hypergraph H_{R_z};
and proving that its asymptotic fractional structure corresponds to an existing arithmetic object.

Possible test: the Cubical Agda finite sieve-observability model, where states are quotient-identified by divisibility information below scale z and a residual charge bit is added. Compute whether the residual charge changes τ* and whether the change survives inverse-limit refinement.

## 11. Agent-context consequence

Let Ω be research states and R(ω) valid next actions.
For n independent research states, naive safe context uses κ0(R)^n interface combinations.
Optimal joint safe context asymptotically uses
    τ*(R)^{n+o(n)}.

Thus the exact asymptotic semantic compression rate is C∞(R)=log τ*.

This is a theorem for the finite abstraction, not a claim about token counts of current LLMs.

## 12. New live frontier: stochastic/distributional rate

The zero-error support-size rate is solved by τ*.

The more relevant agent problem has distribution P on states and seeks minimum expected/entropy communication while selecting a valid action. Delta 01 defined one-shot minimum output entropy. The block regularization should be compared with Körner graph entropy and its hypergraph extensions.

Known adjacent result: normalized minimum chromatic entropy under graph OR powers converges to Körner graph entropy. Our admissible classes are witness hyperedges rather than independent sets of a simple graph, so the exact reduction must be written carefully.

TARGET:
Define a probabilistic hypergraph entropy
    H_R(P)=min_{random W: X∈W∈H_R} I(X;W)
or the correct dual form, and prove it equals the asymptotic minimum expected/entropy interface rate for iid P under relational validity.

This is likely known in zero-error source coding with side information; novelty should not be claimed before exact matching.

## 13. New live frontier: computationally bounded witnesses

Fractional cover assumes arbitrary block encoders/selectors. In executable mathematics, finding a valid witness may itself be expensive.

Refine R to R(x,y,w) with verifier V(x,y,w), and assign:
- proof length;
- verifier time;
- generator time;
- communication;
- leakage.

Then semantic C∞ is a lower bound on implementable coordination cost, but computational restrictions may create a gap.

Define candidate:
    C∞^poly(R)=inf asymptotic interface rate over polynomial-time encoders/verifiers.

Question:
Can C∞^poly > C∞ under standard complexity assumptions?
Almost certainly for suitably encoded relations, but formulate a clean theorem/reduction.

This is where proof complexity, NP witnesses, interactive proofs, SNARKs, and automated theorem proving enter mathematically.

## 14. New live frontier: proof-carrying relation composition

For relations R:A↝B and S:B↝C with certificate systems V_R and V_S, extensional composition existentially hides b:
    T(a,c) iff ∃b R(a,b)∧S(b,c).

A compositional proof system should transform certificates
    π_R for R(a,b),
    π_S for S(b,c)
into π_T for T(a,c)
without necessarily exposing b.

This is exactly a proof-carrying composition problem.

TARGET:
Formalize a category where morphisms are NP relations plus proof systems, and composition is existential conjunction. Study when proof size/verifier complexity/leakage are additive, subadditive, or recursively compressible.

This is a concrete bridge to ZK recursive proof composition and to the library's desired "certificates/proofs" coordinate.

## 15. Research status

VERIFIED EXACT internally:
- identification κ_n=hypergraph product cover;
- C∞=log τ* via known asymptotic cover theorem;
- additive tensor law;
- postprocessing monotonicity;
- deterministic specialization.

KNOWN PRIOR ART:
The core asymptotic cover=fractional cover theorem is classical hypergraph/fractional graph theory, not project novelty.

NEW SYNTHESIS:
Its role as the regularized semantic interface invariant for relational coordination, and the explicit bridge to the existing Coordination Graph / agent-context program.

NEXT:
probabilistic entropy; proof-carrying composition; computational gaps; finite sieve instantiation.
