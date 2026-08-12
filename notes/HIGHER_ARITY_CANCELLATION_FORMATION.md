# Pairwise cancellation does not compose: higher arity forms a new residual

Fix a prime (p). For nonzero integers (a_1,\ldots,a_n), define

\[
j=\min_i v_p(a_i),\qquad
\kappa_p^{(n)}(a_1,\ldots,a_n)
=v_p\!\left(\frac{a_1+\cdots+a_n}{p^j}\right)
\in\mathbb N\cup\{\infty\}.                            \tag{1}
\]

The value is infinite exactly when the sum is zero. The binary case is the
observable formed in `CANCELLATION_OBSERVABLE_FORMATION`. The first question
is whether that binary observable composes—whether the input valuations and
all pairwise cancellation residuals determine the ternary one.

## The unbounded pairwise no-go

**Theorem 1.** For every prime (p), the three input valuations together with
all three pairwise cancellation residuals fail to determine
(v_p(a+b+c)). More strongly, one fixed finite ledger admits every sufficiently
large output valuation.

For odd (p), take

\[
T_r=(1,1,p^r-2),\qquad r\ge1.                           \tag{2}
\]

All three inputs are units. The pair sums are (2) and two copies of
(p^r-1), also units. Hence the ledger

\[
\bigl(v_p(a),v_p(b),v_p(c);
\kappa_p(a,b),\kappa_p(a,c),\kappa_p(b,c)\bigr)
=(0,0,0;0,0,0)                                         \tag{3}
\]

is independent of (r), while (1+1+(p^r-2)=p^r), so the triple-sum
valuation is (r).

For (p=2), use the same family with (r\ge2). Now
(v_2(p^r-2)=1), (kappa_2(1,1)=1), and the other two pairwise residuals
vanish because their input depths differ. Thus the fixed ledger is

\[
(0,0,1;1,0,0),                                         \tag{4}
\]

while the triple-sum valuation is again (r). This is an exact parametric
collision, not a numerical pattern. ∎

The missing datum is higher unit alignment. Pairwise records see whether each
two normalized leading units cancel; they do not see that three units can sum
to zero through arbitrarily many further (p)-adic digits. No scalar
composition law on the pairwise ledger can repair this, because one input to
such a law would have to take all the different outputs in (2).

## The formed arity lift

For each (n\ge2), (1) is the unique residual satisfying

\[
v_p(a_1+\cdots+a_n)
=\min_i v_p(a_i)+\kappa_p^{(n)}(a_1,\ldots,a_n).         \tag{5}
\]

Existence is the definition. Uniqueness follows by cancelling the finite
minimum in (mathbb N\cup\{\infty\}). It is invariant under common nonzero
scaling:

\[
\kappa_p^{(n)}(ca_1,\ldots,ca_n)
=\kappa_p^{(n)}(a_1,\ldots,a_n),\qquad c\ne0,            \tag{6}
\]

because scaling adds (v_p(c)) to both terms in (5).

This is a genuine arity lift, not a composition of binary summaries. The
obstruction in Theorem 1 forces the new observable as soon as the action
language admits a three-input addition context. More generally every admitted
finite sum has its own normalized residual; binary cancellation is not a
sufficient statistic for higher contexts.

## Exact compilation and changed frontier

Remove the common factor (p^j), then read the normalized inputs modulo
(p,p^2,\ldots). If the normalized sum is nonzero of valuation (r), the
first nonzero sum residue occurs at depth (r+1). That trace is an exactness
and ambient-minimality certificate by the same perturbation proof as the
binary adaptive theorem. A zero sum still needs an exact equality certificate.

`machinery/higher_arity_cancellation.py` performs this formation event. It
also emits the pairwise ledger and the family (2), so proposed composition
rules fail closed on an unbounded exact control.

The frontier has changed:

```text
binary residual installed
→ attempt pairwise composition
→ unbounded same-ledger collision
→ form context-indexed n-ary residual
→ ask which families of addition contexts admit a finite sufficient basis
```

That last question is not answered here. For a fixed maximum arity the family
is finite; for arbitrary finite subsets, pairwise data are now proved
insufficient, but no minimal context basis or operadic composition theorem is
claimed.

## Interaction with the swarm returns

The formed-locus results distinguish ambient minimality from minimality inside
a reachable world. The present no-go is prior to that distinction: it is a
collision in the observable representation itself. Restricting the world may
delete one member of the collision, while a witness-generating world may
restore it. Therefore (1) is transferable on a declared world only under the
existing restriction-injectivity criterion; equations (5)--(6) give its
global law, not a claim that every formation history has encountered enough
triples to certify minimality internally.

## Rigor boundary

Proved: Theorem 1, uniqueness (5), equivariance (6), and the least ambient
residue depth for a nonzero normalized sum. These are elementary valuation
facts; no novelty is claimed. The executable tests instantiate the formulas
and include zero, (p=2), scaling, and malformed-ledger controls; computation
is replay, not proof.

Open: minimal context families for arbitrary sum actions; compositional data
retaining normalized unit residues without reconstructing every input; and
formed-world criteria guaranteeing that higher-arity collisions remain
reachable.
