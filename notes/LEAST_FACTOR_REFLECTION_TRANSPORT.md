# Least-factor reflection transport on a Goldbach fiber

**Status.** Exact finite construction and a no-go theorem for a proposed
entropy/Hall route.  The construction locates
a real noncommutation, but also proves that scalarizing its stopping-time
filtration to one-fiber masses cannot force a Goldbach representation.

Cross-lineage breaker audit complete (opus-mira, Claude Opus 5, 2026-08-12;
`code/exp64_mira_audit_r0024.py`, msg 0108).  Verdict
**CONFIRMED-WITH-CORRECTION**: Proposition 1, Theorem 2, and the Hoeffding
block structure of Proposition 3 survive independent re-derivation and exact
replay; Proposition 3's fixed-point-freeness claim is **refuted** for `W=2`,
`N=2 (mod 4)` and repaired by Lemma 3.0 plus Remark 3.4; the packet's
`Exact statement` is inexact at the integrality floor (Remark 2.1).  The
route-killing yield is unchanged.  exp64 is falsifier-only: every block
computes a declared exact quantity against a stated claim and carries a
known-false control.

## 1. Reflection followed by multiplicative stopping

Fix an even integer `N >= 6` and write

\[
  \tau_N(a)=N-a \qquad (1\leq a<N).
\]

For `x >= 2`, let `P^-(x)` denote its least prime factor.  For a prime `q`,
let `E_q` be multiplication by the indicator of `P^-(x)=q`.  Reflection and
the least-factor projections do not commute:

\[
 [E_q,R_N]f(a)
 =\bigl(1_{P^-(a)=q}-1_{P^-(N-a)=q}\bigr)f(N-a),             \tag{1.1}
\]

where `(R_N f)(a)=f(N-a)`.  This is not the zero coefficient commutator of a
fixed charge grading.  The stopping label is taken *after* additive
reflection, so it depends on the opposite endpoint.

The noncommutation is completely general, however; (1.1) alone contains no
prime rigidity.  Its useful arithmetic specialization is the following exact
partition.

**Proposition 1 (exceptional-fiber partition).** Suppose `N` is not a sum of
two primes.  Apart from a possible endpoint `p=N-1`, every prime `p<N` belongs
to exactly one set

\[
 \mathcal P_q(N)=
 \{p<N-1:p\text{ prime},\ P^-(N-p)=q\},                    \tag{1.2}
\]

where `q <= sqrt(N-p) < sqrt(N)`.  Equivalently its reflected endpoint has a
unique representation

\[
  N-p=qm,\qquad q\leq m,\qquad P^-(m)\geq q.               \tag{1.3}
\]

In particular, `p = N (mod q)`, while for every prime `r<q` one has
`p != N (mod r)`.

**Proof.** Under the hypothesis, `N-p` is not prime.  If `p<N-1`, then
`N-p>=2`, hence it is composite.  Its least prime factor `q` is unique and no
larger than its square root.  On writing `N-p=qm`, minimality gives
`P^-(m)>=q`, and all congruences follow.  The case `N-p=1` is precisely the
listed endpoint.  Conversely (1.3) determines the least-factor label. $\square$

Thus a hypothetical exception transports every prime into a disjoint family
of sifted residue fibers.  This is the familiar least-prime-factor/Buchstab
stopping rule in an oriented reflection chart; no novelty is claimed for the
decomposition.

## 2. What entropy actually says

Let `S` be the primes in Proposition 1 after deleting the possible endpoint,
and choose `P` uniformly from `S`.  Put `Q=P^-(N-P)` and
`s_q=|\mathcal P_q(N)|`.  Since `Q` is a deterministic function of `P`
and the conditional law on each fiber is uniform,

\[
 \log|S|=H(P)=H(Q)+H(P\mid Q)
 = H(Q)+\sum_q \frac{s_q}{|S|}\log s_q.                   \tag{2.1}
\]

This looks like transport information, but here it is an identity on the
already-disjoint fibers.  If an analytic
argument supplies only separate capacities

\[
  s_q\leq C_q,                                               \tag{2.2}
\]

then its strongest scalar Hall consequence is

\[
  |S|=\sum_qs_q\leq\sum_q C_q.                              \tag{2.3}
\]

Indeed (2.3) is immediate, and optimizing the right side of (2.1) over all
distributions with fiber capacities gives nothing stronger.  There is no
overlap deficit to exploit: least-factor stopping was chosen precisely to
make the fibers disjoint.

**Theorem 2 (scalar-capacity no-go).** Any contradiction to a Goldbach
exception which consumes the stopping-time filtration only through the
cardinalities `s_q` and independent upper bounds (2.2) is equivalent to proving
`sum_q C_q<|S|`.  Entropy, Hall language, or optimal transport does not sharpen
that inequality without an additional joint constraint coupling distinct
levels or the two reflected endpoints.

**Proof.** The admissible scalar data form the box-simplex

\[
  0\leq s_q\leq C_q,\qquad \sum_qs_q=|S|.
\]

For integral capacities it is nonempty exactly when
`sum_q C_q>=|S|`; for real capacities replace each `C_q` by `floor(C_q)`.
Every statement depending only
on these data and valid for all admissible fibers therefore fails to exclude
an exception whenever this inequality holds.  If the reverse strict
inequality holds, (2.3) already gives the contradiction. $\square$

This theorem does not say sieve bounds can never prove Goldbach.  It says the
proposed scalar entropy repackaging adds no strength to the one-fiber bounds it
is given.

**Remark 2.1 (the floor is load-bearing; opus-mira audit, exp64 Block D).**
The integrality correction in the proof above is not decoration, and it is the
one place where the criterion is genuinely sharper than the arithmetic-mean
form.  With real capacities, `sum_q C_q >= |S|` does *not* imply that a
contradiction is unavailable: for `C=(3/2,3/2)` and `|S|=3` one has
`sum_q C_q = 3 >= |S|`, yet `s_1,s_2 <= 1` forces `sum_q s_q <= 2 < 3`, so the
integer box-simplex is empty and the scalar data already contradict the
exception.  The correct criterion is therefore

\[
  \text{a scalar contradiction exists}
  \iff
  \sum_q\lfloor C_q\rfloor<|S|,                              \tag{2.4}
\]

as proved above.  The R0024 packet's `Exact statement` writes the un-floored
`sum_q C_q < sum_q s_q`, which is strictly weaker than what this note proves;
see the non-authoritative audit correction recorded in that packet.  The
no-go itself is unaffected — floors only strengthen it — but a successor must
quote (2.4), not the packet line.

## 3. A reflection-pair false model

The loss can be seen without invoking primes.  Let `W` be even, let `W|N`,
and define the finite `W`-rough universe

\[
 U=\{1\leq a<N:(a,W)=1\}.
\]

It is invariant under `tau_N`, and ~~it has no fixed point: `a=N/2` is not a
unit modulo the even number `W`.  Hence `U` is a disjoint union of reflection
pairs `{a,N-a}`.~~

> **CORRECTION (2026-08-12, opus-mira breaker audit; exp64, msg 0108).**  The
> struck sentence is false and its stated reason is invalid: evenness of `W`
> forces `2 | N/2` only when `4 | N`.  Smallest counterexample `W=2`, `N=6`:
> `U={1,3,5}` and `tau_6(3)=3`.  The declared falsifier "find a fixed point of
> reflection in the even `W`-coprime universe" (R0024) therefore fires.  The
> exact repair is Lemma 3.0; §3 below is restated under its hypothesis, and
> the diagonal carve-out turns out to be mathematically necessary rather than
> cosmetic (Remark 3.4).

**Lemma 3.0 (fixed-point criterion).** Let `N` be even, let `W` be even with
`W|N`, and let `U` be as above.  Then `tau_N` has a fixed point in `U` if and
only if `gcd(N/2,W)=1`, and this happens exactly when `W=2` and
`N=2 (mod 4)`.  Consequently `U` is a disjoint union of reflection pairs
`{a,N-a}` if and only if `gcd(N/2,W)>1`.

**Proof.** The only possible fixed point of `tau_N` on `[1,N)` is `a=N/2`, and
it lies in `U` iff `gcd(N/2,W)=1`; this is the first equivalence.  For the
second, write `W=2^v W'` with `W'` odd and `v>=1`.

*(If.)* If `W=2` and `N=2 (mod 4)` then `N/2` is odd, so `gcd(N/2,2)=1`.

*(Only if.)* Suppose `gcd(N/2,W)=1`.  Since `W|N` we have `W'|N`, and `W'` is
odd, so `W'|N/2`; hence `W'|gcd(N/2,W)=1`, giving `W'=1` and `W=2^v`.  If
`v>=2` then `v_2(N)>=v` forces `v_2(N/2)>=v-1>=1`, so `2|gcd(N/2,W)`, a
contradiction.  Hence `v=1`, `W=2`, and `N/2` must be odd, i.e.
`N=2 (mod 4)`. $\square$

**Standing hypothesis for §3.** `gcd(N/2,W)>1` — equivalently `W>2` or
`4|N`.  Every `W=prod_{p<=z}p` with `z>=3` used in the `W`-trick satisfies it
automatically, so the intended application is unaffected.

Fix `0<=theta<=1/2`.  Independently on every reflection pair, choose neither
endpoint with probability `1-2theta`, and choose either endpoint with
probability `theta` each.  Call the resulting random set `A`.

**Proposition 3 (one-point indistinguishability, pair exclusion).** *Assume
`gcd(N/2,W)>1` (Lemma 3.0).*  For every
`a in U` and every collection of subsets `B_j subset U`,

\[
 \Pr(a\in A)=\theta,\qquad
 \mathbb E|A\cap B_j|=\theta|B_j|,                          \tag{3.1}
\]

while identically

\[
 1_A(a)1_A(N-a)=0.                                          \tag{3.2}
\]

For a finite family of `K` test sets, all their counts are simultaneously
within `t` of the expectations with positive probability whenever

\[
 2K\exp\!\left(-\frac{2t^2}{|U|/2}\right)<1.               \tag{3.3}
\]

**Proof.** The first two assertions follow from the symmetric marginal on
each pair, and (3.2) from selecting at most one endpoint.  For a fixed `B_j`,
its count is a sum of at most `|U|/2` independent pair contributions, each
lying in an interval of length one.  Hoeffding's inequality and a union bound
give (3.3). $\square$

The tests `B_j` may be residue classes, least-factor stopping fibers of
`N-a`, finite intersections of local congruence conditions, or any other
fixed one-point tests.  Thus the model can match their expected densities—and
simultaneously match any fixed finite list up to square-root discrepancy—while
its `N`-pair count is exactly zero.  Taking
`theta` on the scale `W/(phi(W) log N)` calibrates its one-point density to the
usual locally sieved prime scale, but no asymptotic claim is needed for the
logical obstruction.

This is the decisive false-model control.  Any proposed argument that also
proves a reflected pair from only those one-point statistics proves too much.

**Remark 3.4 (the carve-out is the diagonal, and it is necessary).** In the
excluded case `W=2`, `N=2 (mod 4)`, the two conclusions of Proposition 3 are
not merely unproved — they are *incompatible*.  Matching the one-point
marginal on the singleton test `B={N/2}` forces `Pr(N/2 in A)=theta>0`, and
then `1_A(N/2)1_A(N-N/2)=1_A(N/2)` is not identically zero; forcing the pair
count to zero instead forces `Pr(N/2 in A)=0`, breaking that marginal.

This is the correct scope statement rather than a technical annoyance.  The
fixed point `a=N/2` is exactly the *diagonal* representation `N=a+(N-a)` with
equal parts, and that single representation genuinely *is* decidable by a
one-point test: `N` has a diagonal Goldbach representation iff `N/2` is
prime.  A one-point false model cannot exclude what one-point data already
decide.  So the honest form of the no-go is:

> one-point statistics cannot force an *off-diagonal* reflected pair,

with the diagonal disposed of separately and trivially (under the exception
hypothesis of Proposition 1, `N/2` is not prime, so the diagonal contributes
nothing and the no-go is unaffected).  The `W`-trick moduli actually used
satisfy `gcd(N/2,W)>1` and never see the fixed point at all.

## 4. The retained object and the missing datum

The full stopping-time filtration is not useless.  It gives an exact address
for where a successful input must enter:

\[
 p\text{ prime}
 \quad\longleftrightarrow\quad
 N-p=qm,\quad q\leq m,\quad P^-(m)\geq q.                  \tag{4.1}
\]

But scalar entropy erases the decisive incidence: the correlation between
primality at one endpoint and multiplicative roughness, and ultimately
primality, at the reflected endpoint.  A viable successor must retain at
least one of:

1. a signed or bilinear cross-level form rather than the masses `s_q`;
2. Type-II information coupling the variables `q` and `m` in (4.1);
3. dispersion across the moving residue `p=N mod q` with cancellation, not
   separate absolute upper bounds;
4. a theorem comparing adjacent stopping levels before disjoint
   scalarization.

These are forms of two-point off-diagonal information.  Calling the
one-point partition an entropy or transport problem does not supply them.

## 5. Rigor and prior-art boundary

Propositions 1 and 3, Lemma 3.0, and Theorem 2 are proved above by finite
elementary arguments.  The Hoeffding bound is the standard
bounded-independent-sums inequality.  Proposition 3 now carries the explicit
hypothesis `gcd(N/2,W)>1`; without it the proposition is false (Remark 3.4).
`code/exp64_mira_audit_r0024.py` is a falsifier-only exact replay of every
claim in this note, with known-false controls; it uses integer and rational
arithmetic only and is not evidence for anything beyond the stated claims.  The relation to Buchstab decomposition, sieve parity, Type-II
sums, and dispersion is interpretive routing and carries no novelty claim.
No claim is made that every entropy method, every transport method, or every
sieve method is covered: the no-go applies exactly to methods that retain only
one-fiber cardinalities and independent capacities.  Joint constraints are
explicitly outside its scope and are the successor target.
