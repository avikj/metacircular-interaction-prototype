# Euclidean descent as a formation update

**Status.** Exact executable reconstruction of one historically attested
arithmetic move. It is not a claim that Euclid used modern state-machine or
invariant terminology.

## Source event

Euclid, *Elements* VII.1 asks when continual mutual subtraction leaves the
unit and thereby establishes that the original numbers are prime to one
another. VII.2 asks for the greatest common measure of two non-coprime numbers:
continually subtract the lesser from the greater until a remainder measures
the preceding number, then prove that this remainder measures the originals
and every common measure measures it.

Primary text: [Greek VII.1](https://www.physics.ntua.gr/mourmouras/euclid_desktop/book7/postulate1.html),
[Greek VII.2](https://www.physics.ntua.gr/mourmouras/euclid_desktop/book7/postulate2.html),
and [Heath translation at Perseus](https://www.perseus.tufts.edu/hopper/text?doc=Euc.+7&fromdoc=Perseus%3Atext%3A1999.01.0086).

The historical formation is precise: comparison and repeated subtraction,
which initially only transform a pair, produce a stable relational object—the
greatest common measure—and split the next question into coprime and reducible
frontiers.

## One-shot update

For positive integers (a,b), one execution emits

\[
(a,b;\ \text{compare/subtract})
\longmapsto
(\text{descent trace},\ d,\ \text{frontier}),
\]

where each step is

\[
x=qy+r,qquad 0\le r<y,
\]

and the formed invariant is

\[
\operatorname{CD}(x,y)=\operatorname{CD}(y,r).       \tag{1}
\]

Indeed, (c\mid x,y) implies (c\mid x-qy=r); conversely
(c\mid y,r) implies (c\mid qy+r=x). Since the second coordinate strictly
decreases when nonzero, descent terminates. At ((d,0)), (1) gives

\[
\operatorname{CD}(a,b)=\operatorname{CD}(d,0)
=\{c:c\mid d\},
\]

so (d=\gcd(a,b)).

The obstruction is terminal form:

- (d=1): no non-unit common measure exists; the common-measure search closes
  and a Bézout construction becomes the next frontier;
- (d>1): the pair reduces immediately to the coprime pair
  ((a/d,b/d)).

Example:

\[
(180,48)\to(48,36)\to(36,12)\to(12,0),
\]

forming (12) and replacing the original divisibility question by the
coprime quotient pair ((15,4)).

## Executable artifact

`machinery/euclidean_formation.py` returns the old operation vocabulary, exact
division trace, terminal obstruction, formed gcd, divisor-preservation
certificate, and changed frontier in one immutable record. Four tests include
the twelve-valued example, the unit obstruction, trace identities, and invalid
inputs.

## Rigor and translation boundary

The gcd proof is elementary and complete above. The source claim is restricted
to VII.1--2. Euclid describes mutual subtraction and common measurement, not
our quotient/remainder optimization, Bézout coefficients, immutable records,
or “formation operators.” Those are explicit modern translations. The key
non-metaphorical continuity is equation (1): the operation becomes valuable
because it preserves a newly recognized relational invariant while strictly
reducing the state.
