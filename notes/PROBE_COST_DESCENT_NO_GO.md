# Construction cost does not descend to a residue-valued probe

The adaptive valuation theorem counts queries at centers
(c\in R_k=\mathbb Z/p^k\mathbb Z). A causal arithmetic life constructs
integers. Before adding the two costs, one must prove that integer construction
cost is well-defined on residue centers.

## Descent criterion

Let

\[
\pi:\mathbb N\longrightarrow R_k
\]

be reduction modulo (p^k), and let (L:\mathbb N\to A) be any typed cost.

**Proposition 1.** There exists a function
(\bar L:R_k\to A) with (L=\bar L\circ\pi) exactly when

\[
n\equiv n'\pmod {p^k}\quad\Longrightarrow\quad L(n)=L(n'). \tag{1}
\]

**Proof.** Necessity follows by applying (\bar L) to equal residues. If (1)
holds, define (\bar L(r)=L(n)) for any lift (n) of (r); (1) makes this
independent of the lift. ∎

This elementary quotient universal property is load-bearing: semantic
equality of probes licenses transport only of quantities constant on its
fibers.

## Exact no-go

An integer lift (n) of (c\in R_k) induces the probe

\[
q_n(r)=\min(v_p(r-n),k).                                \tag{2}
\]

If (n'=n+t p^k), then (r-n'\equiv r-n\pmod {p^k}), hence

\[
q_{n'}=q_n                                              \tag{3}
\]

as functions on (R_k). All lifts are the same semantic observable.

**Theorem 2.** Neither successor construction cost nor the standard binary
addition-method cost descends through (\pi).

For nonnegative lifts, successor cost is (L_S(n)=n). Along
(n_t=c+t p^k), it is unbounded. For positive lifts, the left-to-right binary
method uses

\[
L_B(n)=\lfloor\log_2 n\rfloor+\operatorname{popcount}(n)-1 \tag{4}
\]

additions; already (L_B(n)\ge\lfloor\log_2n\rfloor), so it too is unbounded
along the same semantic fiber. Proposition 1 and (3) prove the claim. ∎

Thus a query-optimal decision tree on (R_k) does not carry a well-defined
integer construction cost. Two extensionally identical probe nodes can have
arbitrarily different causal histories.

## Exact repairs and their limits

There are three honest repairs, which must not be conflated.

1. **Canonical lift.** Choose (s:R_k\to\{0,\ldots,p^k-1\}). The least
   nonnegative lift minimizes successor cost among nonnegative lifts. This
   defines a new cost (L\circ s) on residues, but the section is extra
   structure; it was not present in the quotient.
2. **Proof-relevant center.** Retain the actual integer lift and its formation
   trace beside the semantic residue. Equivalent probes may then have
   different construction costs without contradiction.
3. **Quotient-invariant cost.** Optimize over a declared lift class, for
   example (\inf\{L(n):\pi(n)=c\}). This is a new optimization problem and
   does not certify that the minimizing lift is already available.

The canonical lift repairs well-definedness, not causal possession. The
swarm's witness-construction results show what further evidence is required:
an addition or multiplication trace whose dependencies were already formed.

## Observable-formation consequence

The obstruction changes the next lawful state. A residue-valued sensor is
enough for semantic response, but joint sensing/construction requires the
typed pair

\[
(c\in R_k,\ n\in\mathbb N,\ \pi(n)=c,\ \text{formation trace for }n). \tag{5}
\]

This is not architectural bookkeeping imposed from outside. Equation (3)
proves exactly what the semantic quotient erased, and Theorem 2 proves that
the erased coordinate is necessary for the requested operation. The failed
cost descent forms a proof-relevant observable: a center together with a
chosen lift and construction witness.

## Executable certificate

`machinery/probe_cost_descent.py` emits congruent lifts, checks equality of
their entire finite probe functions, and records divergent successor and
binary-method costs. It also implements the least-nonnegative section. Tests
cover several primes/depths, unbounded cost growth, and typed failures.

## Rigor boundary

Proved: Proposition 1, Theorem 2, and canonical-lift minimality for successor
cost. These are elementary quotient and arithmetic facts; no novelty is
claimed. The binary formula prices one explicit construction algorithm, not
the shortest addition chain.

Not proved: an optimal joint decision tree after choosing a lift section; a
fair scalar exchange rate between queries and additions; or whether a given
formation history already contains cheaper noncanonical lifts.
