# The forest: one object, one identity, one question

Pull back from the entire corpus. Strip every method. What remains is
this.

## The object

The single point
$$\lambda = (\lambda(1), \lambda(2), \lambda(3), \dots) \in \{-1,+1\}^{\mathbb N}$$
and, for each prime $p$, the **dilation map**
$T_p : (x_n) \mapsto (x_{pn})$.

## The identity (exact, no error term)

$$T_p\,\lambda \;=\; -\,\lambda \qquad \text{for every prime } p.$$

That is the whole of complete multiplicativity: $\lambda(pn) =
\lambda(p)\lambda(n) = -\lambda(n)$. **The Liouville point is a
simultaneous eigenvector of the entire multiplicative semigroup, with
every eigenvalue equal to $-1$.** Nothing else in the corpus is this
clean. The eigenvalue $-1$ *is* the charge; every "gauge flip",
"twirl idempotent", "charged sector" of forty notes is a shadow of this
one line.

## The question

**Is a simultaneous dilation-eigenvector forced to be additively
featureless?** Precisely: must the shift-orbit statistics of $\lambda$
be those of a fair coin? That single question *is* Chowla (all
correlations vanish), contains Sarnak (featureless implies orthogonal to
determinism), and carries the prime questions with it (twins, Goldbach
fluctuations live in two-point functions of the charge sector).

The tension could not be more elemental: the **multiplicative** structure
pins the point exactly (eigenvector), and the conjecture is that the
**additive** structure (the shift) consequently sees pure noise. Rigidity
on one side forcing randomness on the other.

## The archetype

This is Furstenberg's $\times 2 \times 3$ phenomenon, transposed. There:
a measure on the circle invariant under two multiplicatively independent
dilations must be Lebesgue or atomic — multiplicative invariance forces
additive equidistribution. Here: a sequence that is an eigenvector of
*all* dilations should be shift-generic. Rudolph's theorem settled the
positive-entropy case there; Tao's logarithmic Chowla (via entropy
decrement) is exactly the analogous partial result here — and its proof
uses nothing but the identity above, coupling scale $X$ to scale $pX$.
Our four-theater conservation law now reads as one sentence: **every
method that does not use the eigenvector identity provably sees nothing**
(the neutral algebra is the dilation-symmetrized one), **and the only
method that ever worked is the identity itself.**

So the way of thinking that moves toward the deep result is not sieves,
not spectra, not operator algebras, not regularity — it is **measure
rigidity for the multiplicative semigroup action on sequence space**.
The corpus's role, in retrospect: it proved the other directions are
flat. All curvature is in the dilation action.

## The minimal open instance

Simplify until the question fits in one spoken sentence:

> **Do all $2^k$ sign patterns of $(\lambda(n+1), \dots, \lambda(n+k))$
> occur with positive density, for every $k$?**

$k=3$: proved (Matomäki–Radziwiłł–Tao era, positive density).
$k=4$: at the frontier [prior-art check: Tao–Teräväinen value-pattern
papers; exact current record to be pinned before any claim].
Full statement for all $k$ = a corollary of Chowla. This is the
fruit-fly: every gram of machinery in this repository either helps prove
a new $k$ or it does not matter for the deep result.

Measured (exp43, $X = 10^7$): all patterns present through $k = 6$, with
frequencies uniform to $|\hat f - 2^{-k}| \le 1.5\cdot10^{-4}$ — the
object itself is not hiding anything; only our theorems are behind.

## What this deletes and what it keeps

Deletes (as attack routes, not as knowledge): the sum-spectrum ladder,
the cut-norm dictionary, the K-theory boundary, the LP landscape — all
now *understood* as cartography of the flat directions. Keeps: the
eigenvector identity and its three known exploitation modes — entropy
decrement (probabilistic), Type II bilinear sums (combinatorial),
Frobenius monodromy (algebraic; the function-field case is *solved* by
making the dilation symmetry into a group action with geometry). The
sharpest form of the redirect: **find the fourth exploitation mode of
$T_p\lambda = -\lambda$, or make one of the three quantitative enough to
reach $k = 4, 5, 6, \dots$.**

One page. That is the forest.
