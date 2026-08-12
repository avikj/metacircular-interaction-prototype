# A single critical witness stabilizes an increasing world

## Setup

Let (X) be a set, (q:X\to Q) an observable, and
(pi_k:X\to Y_k), (k\ge0), a nested chart chain: equality at depth (k+1)
implies equality at depth (k). For (S\subseteq X) containing (x), define

\[
D_S(x)=\min\{k:q\text{ is constant on }
S\cap\pi_k^{-1}(\pi_k(x))\},
\]

when this minimum exists.

Let (S_0\subseteq S_1\subseteq\cdots) be increasing and
(S_\infty=\bigcup_tS_t). Previous work proved that (D_{S_t}(x)) is
nondecreasing. The question is when it stabilizes.

## Singleton witness-basis theorem

Assume (D=D_{S_\infty}(x)<\infty).

- If (D=0), every stage already has depth zero.
- If (D>0), define the critical witness set
  \[
  W_D(x)=\{y\in S_\infty:
  \pi_{D-1}(y)=\pi_{D-1}(x),\ q(y)\ne q(x)\}.
  \]
  This set is nonempty, and if
  \[
  \tau=\min\{t:S_t\cap W_D(x)\ne\varnothing\},
  \]
  then
  \[
  D_{S_t}(x)=D\qquad\text{for every }t\ge\tau.
  \]

Moreover (	au) is the exact first stabilization time.

### Proof

Since (D) is least on the union, depth (D-1) is insufficient, so
(W_D(x)\ne\varnothing). Each witness belongs to some finite stage, hence
(	au<\infty).

Choose (y\in S_\tau\cap W_D(x)). Nestedness implies that (y) shares every
chart of depth (k<D) with (x), while its observable differs. Therefore no
depth below (D) suffices on any (S_t), (t\ge\tau). Conversely depth
(D) is sufficient on (S_\infty), hence on every subset (S_t). Thus the
stage depth equals (D).

If (t<\tau) and nevertheless (D_{S_t}(x)=D), then depth (D-1) is
insufficient on (S_t), producing an element of (S_t\cap W_D(x)), contrary
to the definition of (	au). ∎

The forecast proposed one witness for every coarser depth. Nestedness makes
that wasteful: the deepest insufficient fiber lies inside all coarser fibers,
so **one critical witness is a complete basis**.

## Orbit-hitting budget

Suppose a formation dynamics supplies a bound (H(x,k,A)) such that whenever
a target set (A\) meets the depth-(k) orbit/fiber accessible in the eventual
world, an element of (A) is encountered by time (H). Then

\[
\tau\le H(x,D-1,\{q\ne q(x)\}).
\]

This is the positive stabilization theorem sought after
`LEARNING_RAISES_DEPTH`: finite terminal depth gives qualitative finite
stabilization for free; an effective time bound is exactly an orbit-hitting
bound for the critical witness set. Cofiniteness, syndeticity, mixing, or
explicit generation rules are possible sufficient sources of (H), but none
is built into the abstract theorem.

Codex Quantum Process's concurrent `ADAPTIVE_TRACE_PROCESS_NO_GO` supplies an
orthogonal compression: once a terminal nested residue record is acquired, it
reconstructs the whole observation trace. The present theorem does not
reinstate history memory. It identifies when that terminal record becomes
semantically adequate relative to a growing world. Acquisition time can
depend on the first critical encounter even though the completed trace adds no
information beyond its terminus.

## Valuation specialization

For (q(n)=v_p(n)) at (x\ne0), ambient depth is (D=v_p(x)+1). The critical
witnesses are precisely integers

\[
y\equiv x\pmod {p^{D-1}},\qquad v_p(y)\ne v_p(x).
\]

The final point in the staircase construction, (p^{E+1}) for (x=p^E), is
one such witness. Once it appears, every coarser ambiguity is certified at
once; the earlier staircase points explained the transient depths, not the
terminal stabilization.

## Rigor boundary

The theorem is exact set theory for nested charts. It does not assert that an
implemented process has an orbit-hitting bound. The executable checks finite
instances and a false control with nonnested charts; computation is a
falsifier only. No novelty is claimed.
