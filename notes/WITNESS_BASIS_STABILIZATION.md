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
bound for the critical witness set. ~~Cofiniteness, syndeticity, mixing, or
explicit generation rules are possible sufficient sources of (H)~~, but none
is built into the abstract theorem.

**Corrected 2026-08-12 by `claude_arithmetic_breaker`
([`ENCOUNTER_ORDER_DEPTH.md`](ENCOUNTER_ORDER_DEPTH.md), Theorem O).
Cofiniteness, syndeticity and mixing are properties of \(S_\infty\) and cannot
supply \(H\), because \(\tau\) is not a function of \(S_\infty\).** Fix
\(S_\infty=\mathbb Z_{>0}\), which is cofinite, syndetic with gap 1, and
mixing. For \(x=p^{E}\) the witness set is exactly \(W_D(x)=p^{E+1}\mathbb Z\).
In the canonical filtration \(S_t=\{1,\dots,t\}\) we get \(\tau=p^{E+1}=p^{D}\);
but listing the (syndetic, gap \(\le2\)) non-multiples of \(p^{E+1}\) first
gives another increasing filtration of the *same* \(S_\infty\) with \(\tau>N\)
for any prescribed \(N\). So \(H\) must constrain the **order** of encounters,
not the world. Moreover the word *free* has a price: even for the canonical
order \(\tau=p^{D}\), exponential in the depth it stabilizes at, because
\(W_D\) is a single residue class mod \(p^{D}\) and so has density \(p^{-D}\).
`explicit generation rules` survives as a candidate; the other three do not.

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

The constructive core is now checked in
`formal/cubical/NaturalMachine/SingletonWitnessStabilization.agda`
(`--cubical --safe`, no holes or postulates).  Given final sufficiency at
depth `D=d+1`, one arrived stage separator in the depth-`d` fibre, and an
explicit nesting map from depth `d` to every `k<=d`, it constructs stage
sufficiency at `D` and failure of every coarser chart.  A checked nonnested
control has a depth-`d` separator while depth zero remains sufficient, so the
nesting hypothesis is load-bearing.

There is one constructive qualification to “exact first stabilization time.”
The forward direction—separator arrival implies stabilization—is positive and
needs no search.  The reverse direction turns failure of depth `d` into an
arrived separator, which is not available for an arbitrary type-valued world.
The checked adapter therefore requires decidable task-value equality and a
decision procedure for the stage separator type for this converse, reusing
`FormationRelativeMinimality.searchable-insufficiency→counterexample`.
Without such data the earlier double-negation boundary applies; no classical
witness extractor is hidden in the formal theorem.
