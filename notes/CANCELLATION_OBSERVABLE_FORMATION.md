# Addition forms a cancellation observable from the valuation obstruction

Fix a prime (p). The valuation (v_p) transports multiplication exactly,
but the addition action does not descend through the two-coordinate chart
((v_p(a),v_p(b))). The failure is not only a request for more data: after
normalization it is itself an exact observable.

For nonzero integers (a,b), put

\[
j=\min(v_p(a),v_p(b)),\qquad
\kappa_p(a,b)=v_p\!\left(\frac{a+b}{p^j}\right)
   \in \mathbb N\cup\{\infty\}.                         \tag{1}
\]

The value is (infty) exactly when (a+b=0). For a nonzero sum, (1) is
equivalently the uniquely determined nonnegative residual in

\[
v_p(a+b)=\min(v_p(a),v_p(b))+\kappa_p(a,b).              \tag{2}
\]

## Formation and universal characterization

Let (D=(\mathbb Z\setminus\{0\})^2), and regard addition
(sigma:D\to\mathbb Z), the input valuation pair, minimum, and the output
valuation as the already admitted operations. Then (kappa_p) is the unique
map (D\to\mathbb N\cup\{\infty\}) satisfying (2), with the usual convention
(j+\infty=\infty).

Existence is (1). For uniqueness, if (c) satisfies (2), cancellation of the
finite integer (j) in (mathbb N\cup\{\infty\}) gives
(c=v_p(a+b)-j=kappa_p(a,b)) when the sum is nonzero, while an infinite
left side forces (c=\infty) when the sum is zero. Thus the failed transport
square forms one residual in one shot; it does not fit a table on encountered
pairs.

This is genuinely new relative to the old valuation-pair chart. If
(v_p(a)\ne v_p(b)), the ultrametric equality gives
(kappa_p(a,b)=0). But on the single old input ((0,0)), the pairs

\[
(1,p^k-1),\qquad k\ge1,                                  \tag{3}
\]

have (kappa_p=k), and ((1,-1)) has value (infty). For odd (p),
((1,1)) also realizes (0); for (p=2), two units necessarily have
residual at least one. Hence (kappa_p) cannot factor through the old two
valuation coordinates. It exposes exactly the distinction that their failed
addition transport forgot.

## Transfer law

The residual is invariant under every common nonzero scaling:

\[
\boxed{\kappa_p(ca,cb)=\kappa_p(a,b)}\qquad(c\ne0).       \tag{4}
\]

Indeed, writing (t=v_p(c)), the minimum input depth increases from (j) to
(j+t), while the sum depth does the same; after removing (p^{j+t}), the
normalized sum differs from the old one only by a (p)-adic unit. Equation
(4) makes (1) transferable across every orbit of the common-scaling action.
It is not a claim that a finite sample meets every orbit: transfer comes from
the proved defining equation and equivariance, not lookup.

## Compression and compilation

Divide both inputs by their common visible depth (p^j), then query
prime-power residues of the normalized pair until its sum is nonzero. If
(kappa_p(a,b)=r<\infty), the least sufficient normalized chart has depth
(r+1). This is exactly `ADAPTIVE_VALUATION_ADDITION` applied after the
normalization forced by (1). The compiled operation returns (r), the first
nonzero residue as an exactness witness, and every earlier zero residue as a
minimality witness. At (a+b=0), no finite chart suffices and exact equality
is the separate certificate.

Installing (kappa_p) therefore changes the next arithmetic step:

```text
old frontier: addition does not transport through valuation coordinates
formed observable: cancellation depth kappa_p
new action: v_p(a+b) = min(v_p(a),v_p(b)) + kappa_p(a,b)
compiled query cost: kappa_p(a,b)+1 normalized residue depths
new frontier: compose cancellation residuals across several summands/primes
```

The semantic output (v_p(a+b)) was already definable by applying the old
sensor after addition. What is new is the scale-invariant residual coordinate
that isolates all and only the obstruction, together with its least finite
certificate. Formation changes representation and future access cost; it does
not manufacture information absent from the action/observation language.

## Rigor boundary

Proved here: equations (1)--(4), nonfactorization through the old valuation
pair, and reduction of the least-sensor claim to the proved adaptive-valuation
theorem. These are elementary standard consequences of valuations; no novelty
is claimed. `machinery/cancellation_observable.py` composes the existing
adaptive certificate with exact normalization, and its tests are finite
replays, not the proof.

Not proved: that this residual is sufficient for the valuation of sums of an
unbounded number of terms without retaining intermediate units; a simultaneous
minimal sensor across primes; or a general autonomous rule that chooses the
right codomain for an arbitrary failed transport square.
