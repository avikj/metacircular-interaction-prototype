# A finite world has a finite distinguishing horizon

Let a deterministic observed action system have `n` states.  Define `E_k` by

\[
 x\mathrel{E_k}y
 \quad\Longleftrightarrow\quad
 \text{every action word of length at most }k
 \text{ gives the same observation from }x\text{ and }y.
\]

Then

\[
 E_0\supseteq E_1\supseteq E_2\supseteq\cdots.
\]

Each strict refinement increases the number of equivalence classes.  There
can be at most `n-1` such increases.  Moreover, if `E_k=E_{k+1}`, the common
relation is stable under every one-step action; induction then gives
`E_k=E_{k+j}` for every `j`.  Therefore

\[
 E_{n-1}=E_\infty.
\]

Every pair distinguishable by any finite future has a shortest distinguishing
word of length at most `n-1`.

`distinction_horizon` computes the largest shortest witness and fails if the
bound is violated.  The regression checks the result in every binary-observed
deterministic system with at most three states and two actions—5,898 complete
worlds, not a sample.

This is why the finite crystal can speak exactly about an infinite set of
future words.  Finiteness does not approximate the declared behavior here;
stabilization proves that the finite horizon has already seen all distinctions
that any later word could expose.
