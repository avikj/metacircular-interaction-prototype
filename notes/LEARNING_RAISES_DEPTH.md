# Learning can make an old observation cost more

## Relative depth is monotone in the formed world

Let (q:X\to Q) be an observable and
(pi_0,pi_1,ldots) a nested chain of residue charts. For a formed world
(S\subseteq X) containing (x), write

\[
D_S(x)=\min\{k:q\text{ is constant on }S\cap\pi_k^{-1}(\pi_k(x))\}.
\]

If (S\subseteq T), then

\[
D_S(x)\le D_T(x).
\]

Indeed, every (T)-fiber contains the corresponding (S)-fiber, so any
chart sufficient on (T) is sufficient on (S). Enlarging experience cannot
make a previously necessary distinction disappear. It can make a previously
sufficient chart fail by adding an adversary to its fiber.

For valuation on an ambient integer domain, this monotone growth is bounded by
the ambient least depth. The bound can nevertheless be attained one digit at
a time.

## Exact staircase theorem

Fix a prime (p) and (E\ge0). Let the observable be

\[
q(n)=v_p(n),\qquad x=p^E.
\]

For (1\le j\le E), define

\[
y_j=p^E+p^{j-1},
\]

and define the final adversary (y_{E+1}=p^{E+1}). Put

\[
S_0=\{x\},\qquad S_k=\{x,y_1,\ldots,y_k\}quad(1\le k\le E+1).
\]

**Theorem.** The least residue depth determining (v_p(x)=E) relative to
(S_k) is exactly

\[
D_{S_k}(x)=k.
\]

*Proof.* For (j\le E),

\[
y_j-x=p^{j-1},\qquad v_p(y_j)=j-1,
\]

because (y_j=p^{j-1}(1+p^{E-j+1})), whose parenthesis is a unit. The final
point satisfies

\[
y_{E+1}-x=p^E(p-1),\qquad v_p(y_{E+1})=E+1.
\]

For every (d<k), the point (y_{d+1}\in S_k) agrees with (x) modulo
(p^d) and has a different valuation. Hence no depth (d<k) suffices.

At depth (k), each previously added (y_j), (j\le k), differs from (x)
by a number of valuation (j-1<k). Thus none lies in the depth-(k) fiber of
(x); that fiber inside (S_k) is the singleton ({x}), so depth (k)
suffices. ∎

The endpoint (k=E+1) is the ambient valuation depth. Before the final
encounter, the world has not earned the adversary that forces it.

## What this says about action groupoids and jets

The example uses the identity polynomial, whose derivative is always a unit.
Therefore delayed cost growth does not require singularities, Hessians, or
late formal Taylor terms. It comes from **late incidence**: the critical
direction exists ambiently from the beginning but enters the formed action
groupoid only when the corresponding point is encountered.

For a fixed point of finite valuation, growth is bounded by its ambient depth;
there is no infinite staircase at that point. But (E) is arbitrary, so no
bound depending only on polynomial degree, dimension, or current world size
can force uniform stabilization across states. A stabilization theorem needs
a dynamical hypothesis such as cofinal residue incidence, syndeticity, or a
bounded-time orbit-hitting condition.

This also separates two memories:

- the scaled jet records which directions would change the observable;
- the formed action records which such directions have become accessible.

Neither determines future cost alone.

## Rigor boundary

The monotonicity and staircase theorem are proved above. The executable checks
many primes and heights and uses a literal fiber definition; this is a
falsifier, not proof. No novelty is claimed for the elementary construction.
