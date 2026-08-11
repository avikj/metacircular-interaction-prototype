# Cubical quotient audit: descent before higher paths

This note audits a proposed use of Cubical Agda to retain a finite-sieve
state together with a charge bit.  The conclusion is mostly a no-go: an
observable equivalence gives a set quotient, and higher paths do not recover
information that fails to descend.  No novelty is claimed.

## 1. Observable quotients are 0-types

Let $q:X\to Y$ be an observable and define

$$
 x\sim y\quad\Longleftrightarrow\quad q(x)=q(y).
$$

The ordinary observable quotient $X/{\sim}$ is a set quotient, hence a
0-type.  Its Cubical Agda HIT presentation has:

1. point constructors $[x]$;
2. a path $[x]=[y]$ for every witness $x\sim y$;
3. a set-truncation constructor making all parallel equality proofs equal.

For a charge $c:X\to C$ with $C$ a set, a function

$$
 \bar c:X/{\sim}\to C,\qquad \bar c([x])=c(x)
$$

exists exactly when $c$ respects the relation:

$$
 \boxed{x\sim y\Longrightarrow c(x)=c(y).}
$$

This is the descent datum demanded by the set-quotient eliminator.  Freely
adjoining paths does not evade it: a function from the HIT must map every
generating path to a path between the endpoint charges.

In ordinary quotient notation the criterion is

$$
 \boxed{
 \bigl(\exists\bar c,\ \bar c\circ[-]=c\bigr)
 \Longleftrightarrow
 \bigl(\forall x,y,\ x\sim y\Rightarrow c(x)=c(y)\bigr).
 }
$$

## 2. When local state plus one bit is an equivalence

For maps $q:X\to Y$ and $c:X\to\mathbf2$, consider

$$
 \Phi=(q,c):X\longrightarrow Y\times\mathbf2.
$$

**Proposition 2.1.** The map $\Phi$ is an equivalence if and only if every
fiber $q^{-1}(y)$ has exactly two elements and the restriction

$$
 c:q^{-1}(y)\longrightarrow\mathbf2
$$

is a bijection for every $y\in Y$.

This is the fiberwise criterion for a product equivalence.  If $\Phi$ is not
surjective, replacing its codomain by its image produces only a tautological
factorization, not recovered information.

### Smallest positive prototype

Let $V=(\mathbb Z/2)^2$, with state $(a,b)$, local observable
$q(a,b)=a$, and total charge $c(a,b)=a+b$.  Then

$$
 \Phi(a,b)=(a,a+b)
$$

is an equivalence, with inverse

$$
 \Phi^{-1}(u,z)=(u,u+z).
$$

The charge bit reconstructs precisely the one forgotten coordinate.  This is
ordinary finite linear algebra between sets.  After 0-truncation no higher
obstruction remains, so a higher inductive type adds no content.

## 3. The finite-sieve charge does not descend

Let

$$
 q_6(n)=n\bmod6,\qquad c(n)=\Omega(n)\bmod2,
$$

where $(-1)^{c(n)}=\lambda(n)$ is the Liouville charge.  Then

$$
 q_6(1)=q_6(7)=1,\qquad c(1)=0,\quad c(7)=1.
$$

Thus Liouville charge does not descend to the residue quotient.  Moreover,

$$
 q_6(1)=q_6(25)=1,\qquad c(1)=c(25)=0,\qquad 1\ne25,
$$

so even the refined map

$$
 n\longmapsto(q_6(n),c(n))
$$

is not an equivalence.  The bit refines the observation but does not
reconstruct the fine state.

The same failure holds for a finite sieve state recording only whether each
$p\mid W$ divides $n$: valuations, prime factors outside the sieve, and
archimedean size remain invisible.  On the opposite extreme, if one restricts
to $F$-smooth numbers and records every valuation, the local state already
reconstructs $n$ and the charge is a determined, redundant bit.  Neither case
creates higher homotopy.

## 4. The checked Cubical prototype

[`formal/cubical/ProjectionChargeAudit.agda`](../formal/cubical/ProjectionChargeAudit.agda)
machine-checks two minimal claims:

1. the Boolean map $(a,b)\mapsto(a,a\mathbin{\mathtt{xor}}b)$ has an explicit
   inverse;
2. a charge that separates two points identified by a set quotient cannot
   descend.

The negative prototype uses the indiscrete relation on `Bool`.  Its
generating path identifies `false` and `true`.  If a descended Boolean charge
agreed with the representatives, applying it to that path would prove
`false = true`, contradicting Boolean disjointness.  This is the
eliminator-level form of the sieve witness $1\sim7$ with opposite charges.

## 5. When a genuinely higher object would be justified

An untruncated coequalizer can retain relation witnesses as paths, but its
loops then encode the chosen presentation unless the paths come from genuine
semantic structure.  A justified higher model requires, for example:

1. an actual action groupoid with nontrivial stabilizers;
2. a charge cocycle or local system;
3. transition functions on overlaps;
4. proved unit, composition, and higher coherence laws;
5. a nonzero monodromy or obstruction class invariant under change of
   presentation.

For comparison, the translation action of $6\mathbb Z$ on $\mathbb Z$ is
free.  Its action groupoid has trivial stabilizers and is equivalent to the
discrete quotient $\mathbb Z/6\mathbb Z$.  No higher obstruction survives.

The multiplicative gauge charge in the C*-algebraic program is genuine
graded structure, but it is **additional structure that does not descend
through the finite additive sieve quotient**.  Encoding it by paths would
require a proved cocycle and coherence theorem, not a freely generated HIT.

## 6. Kill criteria

Stop at the ordinary quotient/fiber calculation if any of the following
holds:

1. all state, fiber, and equality types are sets or finite 0-types;
2. local state plus charge has an explicit ordinary inverse;
3. the proposed charge fails relation-respect and therefore does not descend;
4. the purported loops depend on a chosen quotient presentation;
5. 0-truncation kills every claimed obstruction;
6. no nontrivial stabilizer, cocycle, transition function, or
   two-dimensional coherence law has been specified.

Use a Cubical HIT only after exhibiting concrete higher descent data whose
coherence is not merely equality of functions between sets.
