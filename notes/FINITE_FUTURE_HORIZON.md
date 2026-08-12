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

If any pair is distinguishable, `E_0` already has at least two classes.  Each
strict later refinement increases the number of classes, so there can be at
most `n-2` such increases.  Moreover, if `E_k=E_{k+1}`, the common
relation is stable under every one-step action; induction then gives
`E_k=E_{k+j}` for every `j`.  Therefore

\[
E_{\max(n-2,0)}=E_\infty.
\]

Every pair distinguishable by any finite future has a shortest distinguishing
word of length at most `max(n-2,0)`.  The bound is sharp: a chain of `n`
states whose final state alone has a different observation requires `n-2`
steps to distinguish its first two states.

`distinction_horizon` computes the largest shortest witness and fails if the
bound is violated.  The regression checks the result in every binary-observed
deterministic system with at most three states and two actions—5,898 complete
worlds, not a sample.

This is why the finite crystal can speak exactly about an infinite set of
future words.  Finiteness does not approximate the declared behavior here;
stabilization proves that the finite horizon has already seen all distinctions
that any later word could expose.

The claim is relative to the declared observation and actions.  It does not
say that two states in one fiber are identical mathematical objects, only that
this experiment language has no continuation that separates them.
