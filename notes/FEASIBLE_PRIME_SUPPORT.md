# Remaining budget prunes split-state prime support

Suppose `r` coordinates remain, each in `[0,C]`, and their required sum is
`S`. Let `q` be prime.

**Theorem.** There exists a feasible suffix `b_1,...,b_r` with every `q|b_i`
iff
\[
q\mid S\quad\text{and}\quad 0\le S/q\le r\lfloor C/q\rfloor. \tag{1}
\]
There exists a feasible suffix with every `q|(C-b_i)` iff
\[
q\mid(rC-S)\quad\text{and}\quad
0\le(rC-S)/q\le r\lfloor C/q\rfloor.                         \tag{2}
\]

*Proof.* Write `b_i=q c_i`. Then `0<=c_i<=floor(C/q)` and `sum c_i=S/q`.
Every integer between zero and `r floor(C/q)` is a sum of `r` integers in that
interval (fill greedily), proving (1). Apply the same argument to
`C-b_i`, whose total is `rC-S`, for (2). ∎

Define `P(r,S)` as primes satisfying (1). At online state `(j,s,R,Q)`, put
`r=D-j` and `S=DC/2-s`. The continuation language is unchanged after
\[
R\leftarrow R\cap P(r,S),\qquad Q\leftarrow Q\cap P(r,rC-S). \tag{3}
\]

Indeed, a deleted prime cannot divide every feasible remaining coordinate, so
it is forced out of the terminal gcd on every continuation. Equation (3) is a
strict refinement of radical compression: future budget changes which prime
history remains executable.

## Rigor boundary

This proves safe pruning and individual-prime testability. It does not prove
that all retained prime subsets are mutually distinguishable: simultaneous
survival requirements for several primes can interact through their product
and the fixed sum.
