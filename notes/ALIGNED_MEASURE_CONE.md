# Scheduler-compatible worlds form a p-adic measure cone

Let `mu:Z/p^k Z -> R_{>=0}` be a finite nonnegative measure. For
`0<=ell<k`, `0<=u<p^ell`, and `0<=d<p`, define the child mass

\[
m_\mu(\ell,u,d)=
\sum_{\substack{x\bmod p^k\\x\equiv u+d p^\ell\ (\bmod p^{\ell+1})}}
\mu(x).                                                       \tag{1}
\]

Call `mu` **canonically aligned** when

\[
m_\mu(\ell,u,0)\ge m_\mu(\ell,u,1)\ge\cdots\ge
m_\mu(\ell,u,p-1)                                             \tag{2}
\]

for every prefix node.

## Cone and scheduling theorem

**Theorem 1.** Canonically aligned measures form a closed convex polyhedral
cone `A_(p,k)` in `R^(p^k)`. If `mu` has positive total mass, canonical child
order minimizes expected valuation queries and signed-scale center motion
separately under the normalized law `mu/mu(Z/p^kZ)`.

*Proof.* Each condition in (2) is a homogeneous closed linear inequality in
the coordinates `mu(x)`, together with coordinate nonnegativity. Their finite
intersection is a closed convex polyhedral cone. At every positive-mass
prefix, division of (2) by the prefix mass gives decreasing conditional child
probabilities. `MONOTONE_LAW_ORDER` applies nodewise and then globally. ∎

The absence of conditional denominators is load-bearing: scheduler
compatibility survives addition of formed mass.

**Corollary 2 (superposition).** If `mu,nu` are aligned and `a,b>=0`, then
`a mu+b nu` is aligned. In particular, the counting measure of a disjoint
union of aligned finite sets is aligned.

This does not assert closure of set union with overlap: indicator union uses
subtraction of the intersection, and the cone is not closed under subtraction.

## Dilation preservation

Embed measures from `Z/p^kZ` into `Z/p^(k+1)Z` by

\[
(D\mu)(px)=\mu(x),\qquad (D\mu)(y)=0\quad(p\nmid y).          \tag{3}

**Theorem 3.** `D(A_(p,k))` is contained in `A_(p,k+1)`.

*Proof.* At level zero, the child masses of `Dmu` are `(mu(X),0,...,0)`, hence
decreasing. At level `ell>=1`, a prefix `u` not divisible by `p` has all child
masses zero. If `u=pv`, division by `p` identifies its child masses exactly
with

\[
m_{D\mu}(\ell,pv,d)=m_\mu(\ell-1,v,d),                       \tag{4}
\]

which decrease by alignment of `mu`. ∎

Thus the operations “superpose already certified mass” and “append a zero
low digit by multiplication by `p`” carry their scheduling certificate
forward without rerunning the exponential Bellman optimizer.

## Position of successor intervals

The counting measures of all initial intervals `{0,...,N-1}` lie in
`A_(p,k)` by `SUCCESSOR_PREFIX_LAW`; they are examples, not claimed generators
or extreme rays. The cone is strictly formation-sensitive: the point mass
`delta_0` is aligned, while its translate `delta_1` is not, since its root
child masses begin `(0,1,0,...)`.

## Rigor boundary

Theorems 1--3 classify the inequality certificate and two preserving
operations, not the cone's extreme rays or every operation preserving it.
Arbitrary translation, overlapping Boolean union, convolution, and
subtraction-only motion remain outside the proved closure laws. No claim is
made that a natural arithmetic ensemble must lie in the cone.

