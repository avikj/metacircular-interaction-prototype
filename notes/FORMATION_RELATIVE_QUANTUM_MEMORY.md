# Quantum memory lower bounds are relative to the formed world

**Status:** exact finite restriction theorem and infinite-domain no-go.

Let `q:X->Y` be a deterministic sensor and let `S subset X` be the states an
organism has actually formed. For the overwritten coherent interface

\[
V|x\rangle=|q(x)\rangle|e_x\rangle,
\]

the exact environment dimensions are

\[
d_X(q)=\max_y|q^{-1}(y)|,
\qquad
d_S(q)=\max_y|S\cap q^{-1}(y)|.                 \tag{1}
\]

The proof is the fiber-orthogonality theorem applied to the two declared
domains. Consequently `d_S(q)<=d_X(q)`. Equality holds exactly when `S`
contains, for some ambient maximum fiber, as many of its points as the ambient
maximum size. Formation-restricted execution therefore gives a lower bound on
ambient coherent memory, never an automatic ambient certificate.

This is the quantum/process form of `FORMATION_SUFFICIENCY`'s warning:
necessity and minimality proofs quantify over the comparison domain. Deleting
unformed counterexamples can make a coarser chart appear sufficient; deleting
unformed members of a large quotient fiber can make a smaller environment
appear reversible.

## Infinite no-go

For `q_m(n)=n mod m` on the natural numbers, every fiber is countably infinite,
so no finite-dimensional overwritten coherent dilation exists. Yet every
finite formed set `S` has `d_S(q_m)<=|S|<infinity`. Hence:

> No finite formed world, by its exact restricted dilation alone, certifies
> the infinite ambient memory cost of a residue sensor on `N`.

For the initial segments `S_N={0,...,N-1}`, the restricted cost is
`ceil(N/m)` and diverges only along the declared exhaustion. The exhaustion
law—not any single finite run—is the ambient conclusion.

## Changed next move

Every quantum/process memory statement must carry its domain. The arithmetic
organism should report `d_S` for current execution and separately prove any
ambient or asymptotic claim. A formed-world profile may guide present resource
allocation; it cannot establish global minimality unless a coverage theorem
shows that the relevant maximum fibers are represented.

This theorem concerns exact basis overwrite. It does not turn formation sets
into physical state spaces or address approximate compression.

