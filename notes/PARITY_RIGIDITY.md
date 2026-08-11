# Singleton-parity rigidity for integer homometry

Let \(A\subset\mathbb Z\) be finite and write

\[
  c_A(h)=\#\{(a,a')\in A^2:a'-a=h\}.
\]

Thus \(c_A\) is the full pairwise difference multiset, or equivalently the
autocorrelation of \(1_A\). Translation and reflection preserve \(c_A\).
This is much richer data than the list of consecutive gaps between sorted
elements.

## The theorem

> **Theorem (singleton-parity rigidity).** Suppose one of the two parity
> classes \(A\cap2\mathbb Z\) and \(A\cap(2\mathbb Z+1)\) has exactly one
> element. If a finite set \(B\subset\mathbb Z\) satisfies \(c_B=c_A\), then
> \(B\) is a translate of \(A\) or of \(-A\).

### Proof

Put \(N=|A|\). The coefficient \(c_A(0)\) gives \(N\). Moreover,

\[
  \sum_{\substack{h>0\\h\ {\rm odd}}}c_A(h)
  =|A\cap2\mathbb Z|\,|A\cap(2\mathbb Z+1)|=N-1,
\]

because every opposite-parity unordered pair contributes exactly one positive
odd difference. If \(e_B,o_B\) are the two parity-class sizes of \(B\), then
\(e_B+o_B=N\) and \(e_Bo_B=N-1\). Hence

\[
  (e_B-1)(e_B-(N-1))=0,
\]

so \(B\) also has a singleton parity class.

Equivalently, this first step is Fourier analysis on the quotient
\(\mathbb Z/2\mathbb Z\): if \(C_A(x)=A(x)A(x^{-1})\), then
\[
  C_A(-1)=A(-1)^2=(|A\cap2\mathbb Z|-|A\cap(2\mathbb Z+1)|)^2,
\]
while \(c_A(0)\) gives the sum of the two class sizes. One quotient character
therefore detects the singleton class before any factorization is attempted.
The case \(N=1\) is already trivial; the same equations and proof also cover
it with \(U=V=0\).

Translate the singleton point of each set to \(0\). If necessary, translation
by an odd integer interchanges the names of the parity classes. We may
therefore write their Laurent polynomials as

\[
  A(x)=1+U(x),\qquad B(x)=1+V(x),
\]

where every exponent occurring in \(U,V\in\mathbb Z[x,x^{-1}]\) is odd. Put
\(P^*(x)=P(x^{-1})\). Equality of difference data is

\[
  (1+U)(1+U^*)=(1+V)(1+V^*).
\]

The odd-exponent and even-exponent parts of this identity give separately

\[
  U+U^*=V+V^*,\qquad UU^*=VV^*.
\]

Let \(W=U-V\). The first identity says \(W^*=-W\). Substitution into the
second gives

\[
  0=(V+W)(V^*-W)-VV^*=W(V^*-V-W).
\]

The Laurent polynomial ring is an integral domain. Thus either \(W=0\), so
\(U=V\), or \(W=V^*-V\), so \(U=V^*\). Therefore the translated sets are
equal or reflections of one another. Undoing the translations proves the
claim. \(\square\)

The proof also covers the apparent ambiguity when the singleton parity point
lies in the interior: the odd part of the autocorrelation records the
singleton-to-opposite-class distances, while the even part forces all choices
of their signs to agree globally, up to reflection.

## Prime-prefix consequence: \(2\) is the anchor

For \(X\ge3\), normalize the prime set by subtracting \(2\):

\[
  P_X-2=\{p-2:p\le X\}.
\]

It contains the single even point \(0\); every other exponent is odd.
Equivalently, in the original prime set the unique even prime \(2\) is a
\(2\)-adic anchor. Every odd pairwise difference of primes must involve \(2\),
so the positive odd part of the difference multiset literally lists

\[
  \{p-2:3\le p\le X\}
\]

once each. The prime \(p=2\), previously appearing as the exceptional parity
place where sum and difference coordinates cease to be unimodular, rigidifies
this inverse problem completely.

> **Corollary (unconditional prime phase rigidity).** For every \(X\ge3\),
> the set of primes at most \(X\) is determined by its full pairwise
> difference multiset, up to translation and reflection.

There is an explicit \(O(D)\) reconstruction from a difference-count array
\((c(h))_{0\le h\le D}\): read off every positive odd \(h\) for which
\(c(h)=1\), form

\[
  \{0\}\cup\{h>0:h\ {\rm odd},\ c(h)=1\},
\]

and translate it by \(2\). For genuine prime-prefix data this is exactly the
original prefix; reflection gives the only congruent alternative. Here \(D\)
is the diameter. Again, this uses **all pairwise differences with
multiplicity**, not merely the consecutive prime gaps.

Equivalently, if \(F_X(x)=\sum_{p\le X}x^{p-2}\) and
\(G\in\{0,1\}[x,x^{-1}]\) satisfies

\[
  G(x)G(x^{-1})=F_X(x)F_X(x^{-1}),
\]

then \(G\) is a monomial translate of \(F_X\) or of \(F_X(x^{-1})\).

This settles the original \(0\)--\(1\) homometry question without any
irreducibility hypothesis. It does **not** prove that the non-cyclotomic part
of \(F_X\) is irreducible, nor does it classify algebraic spectral factors
whose coefficients need not be \(0\) or \(1\). The cyclotomic, low-degree,
and asymptotic factor results remain independent algebraic information.

## Prior-art boundary

The ambient problem is the classical turnpike/homometry problem, and the
factor-allocation description of one-dimensional homometric sets belongs to
that literature (notably Rosenblatt--Seymour, 1982, and the polynomial model
of Yovanof--Golomb, 1998). Targeted searches for
“singleton parity,” “unique even point,” and parity reconstruction in the
turnpike literature did not locate this exact lemma. The argument is
elementary enough that it may well be implicit or previously observed; no
novelty claim should be made without a broader specialist search.
