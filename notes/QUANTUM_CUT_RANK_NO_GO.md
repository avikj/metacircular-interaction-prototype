# Ordinary cut rank is not quantum memory dimension

**Status:** exact finite no-go and strict typed-boundary separation.

For a nonnegative table `T`, define its positive-semidefinite factorization
dimension as the least `d` for which

\[
T_{ij}=\operatorname{Tr}(A_iB_j)
\]

with `d x d` positive-semidefinite complex matrices. This is the elementary
prepare-and-measure boundary dimension; it is not yet a process-tensor memory
cost, which additionally owes normalization, complete positivity across all
interventions, and causal constraints.

## The separation

Take the four qubit projectors onto

\[
|0\rangle,\quad |1\rangle,\quad |+\rangle,
\quad |+i\rangle.
\]

Their Born table `Q_ij=Tr(P_iP_j)` is

\[
Q=\begin{pmatrix}
1&0&1/2&1/2\\
0&1&1/2&1/2\\
1/2&1/2&1&1/2\\
1/2&1/2&1/2&1
\end{pmatrix}.
\]

Exact elimination gives `rank(Q)=4`. Its displayed factorization proves
quantum dimension at most two; dimension one would force ordinary rank one,
so its quantum dimension is exactly two.

Now take `I_4`. It also has ordinary rank four. Its PSD dimension is four.
Indeed, suppose `delta_ij=Tr(A_iB_j)`. For positive matrices, a zero trace
product implies `range(B_j) subset ker(A_i)`. For every `j`, choose
`v_j in range(B_j)` with `A_j v_j != 0`, possible because the diagonal trace
is positive. Then `A_i v_j=0` for `i != j`. If `sum c_j v_j=0`, applying
`A_i` gives `c_i A_i v_i=0`; hence all coefficients vanish. Thus four
linearly independent vectors inhabit the factor space, so `d>=4`; diagonal
rank-one projectors attain four.

Therefore two tables with the same ordinary cut rank four require quantum
dimensions two and four. Ordinary rank is neither the quantum dimension nor a
function determining it.

## Process consequence

The linear cut theorem remains exactly correct for unrestricted field
factorizations and tensor-network bond dimension. It must not be reported as
quantum memory. The typed boundary spectrum proposed in
`CAUSAL_MEMORY_SPACETIME.md` now has its first strict quantum coordinate:
retain a positive factorization witness, not only scalar rank. The next
quantum move is to impose the actual process constraints on an
instrument-indexed table; it is not to infer quantum memory from another
ordinary-rank computation.

`machinery/quantum_cut_rank_no_go.py` verifies the Born table and both ordinary
ranks using exact Gaussian-rational arithmetic.

Independently replicated by cf-delta (msg 0339): from-scratch dense
Gaussian-rational linear algebra reproduces the Born table, both ordinary ranks
(4 and 4), the explicit PSD-dim-2 factorization of `Q` with the rank-1 lower
bound, and the PSD-dim-4 attainment for `I_4`; the fiber-orthogonality lower
bound re-derived by hand. `machinery/cf_delta_replay_quantum_cut_rank.py`.

