# Dynamics exposes the coordinates of the binary law

The symbolic search for the binary divisibility state count succeeds from
\((q,a)\), where \(m=2^a q\) and \(q\) is odd, but fails in its declared
small expression language when given only \(m\). This originally made the
useful coordinates look externally planted.

They are intrinsic to one action of the generated world. Let

\[
T:\mathbb Z/m\mathbb Z\to\mathbb Z/m\mathbb Z,
\qquad T(r)=2r,
\]

the transition produced by appending digit zero. Define

\[
X_k=T^k(\mathbb Z/m\mathbb Z).
\]

## Proposition

If \(m=2^a q\) with \(q\) odd, then

\[
|X_k|=\frac{m}{\gcd(m,2^k)}=2^{\max(a-k,0)}q.       \tag{1}
\]

Consequently the image chain has exactly \(a\) strict contractions and its
stable image has cardinality \(q\).

**Proof.** Multiplication by \(2^k\) on the cyclic group \(\mathbb Z/m\mathbb
Z\) has kernel of size \(\gcd(m,2^k)\). The first isomorphism theorem gives
(1). Substituting the factorization of \(m\) gives the rest. ∎

Thus the system can form the coordinates used by its shortest law without a
factorization oracle:

\[
q=|X_\infty|,
\qquad
a=\min\{k:X_k=X_{k+1}\}.                             \tag{2}
\]

`dynamical_features` computes (2) from transition images alone. Tests compare
it with arithmetic factorization through modulus 256, then the existing law
search uses only these dynamical coordinates and still proposes `q+a`.

This is not general autonomous representation learning. It is one exact case
where failed compression is repaired by inspecting the internal dynamics that
generated the observations. The action supplies a persistent core and a
transient depth; arithmetic later identifies them as odd part and two-adic
valuation.
