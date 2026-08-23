# Singleton-parity rigidity for integer homometry

> **Formalization status (Tarski, 2026-08-15).** Two of this proposition's
> three layers are now checked terms in
> `formal/pairfield/Pairfield/ParityRigidity.lean` (Lean 4.33.0 + mathlib
> `v4.33.0`; `lake build Pairfield.ParityRigidity` → **exit 0**, olean
> present; `#print axioms` on every named result gives only
> `propext, Classical.choice, Quot.sound`):
>
> | layer | statement | term |
> |---|---|---|
> | 2 (algebraic core) | `U,V` odd-supported in `ℤ[T;T⁻¹]`, `(1+U)(1+U)* = (1+V)(1+V)*` ⟹ `U = V` or `U = V*` | `core` |
> | 3 (set conclusion) | `0 ∈ A,B`, all other elements odd, equal difference multisets ⟹ `B = A` or `B = -A` | `rigidity_normalized`, `rigidity_normalized_diff` |
> | — (bridge) | `coeff_h (1_A · 1_A*) = #{(a,a') ∈ A² : a-a' = h}` | `coeff_autocorr` |
> | 1 (arithmetic half) | `e+o = N`, `eo = N-1` ⟹ `e = 1` or `o = 1` | `parity_class_sizes` |
>
> **Not** checked: the rest of layer 1 — the *translation bookkeeping* that
> reduces the general statement below to the normalized one (that `c_A(0) =
> |A|`; that the positive odd part of `c_A` counts opposite-parity pairs, so
> `parity_class_sizes` applies to `B`; and that translating each singleton to
> `0`, after an odd translation if the class names must be swapped, lands in
> the normalized form). It is routine but it is not there, so the boxed
> theorem below is **not** a checked term; its two substantive layers are.
> Nor is the prime-prefix corollary formalized (it needs `2` odd-prime
> arithmetic on top of layer 3).
>
> The core statement in the term is *stronger* than the note's: it carries no
> `0`–`1` hypothesis on coefficients, and no finiteness beyond that of a
> Laurent polynomial. The `ReversalRigidity.lean` machinery suggested as an
> ingredient by `notes/AGDA_COVERAGE_LEDGER.md` §6 item 5 was **not** used and
> does not apply: the involution here is `LaurentPolynomial.invert`
> (`T n ↦ T (-n)`), not `Polynomial.reverse`, and the domain fact needed is
> `NoZeroDivisors (AddMonoidAlgebra ℤ ℤ)`, which mathlib supplies via
> `UniqueSums ℤ`.

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

**Second search, 2026-08-15 (Tarski), before the formalization write-up.**
The ambient framework is confirmed classical and is exactly the one used
here: Rosenblatt--Seymour (*The structure of homometric sets*, SIAM J. Alg.
Disc. Meth. **3** (1982) 343–350) characterize homometry by factor
allocation, $A = PQ$, $B = PQ^{*}$, in the Laurent ring; Katz--Rahman--Ward,
*Sequences with identical autocorrelation functions* (arXiv:2308.07467, 2023)
work in $\mathbb{R}[z,z^{-1}]$ with the same conjugate-reversal involution
and call the translation/reflection partners *trivially equicorrelational*.
Neither gives a sufficient condition in terms of the **parity of the
positions** of the support; Katz--Rahman--Ward's structural constraints come
from palindromy and from the unit group, and their only mod-2 use is a parity
count on exponent totals. The sparse-phase-retrieval line
(arXiv:1308.3058, arXiv:1311.2745) states uniqueness under *collision-free*
hypotheses on the autocorrelation, which is a different and incomparable
condition — a set with a singleton parity class generally has collisions.
So: the framework is classical, this sufficient condition was not located in
it, and the present proof does **not** route through Rosenblatt--Seymour
(deducing rigidity from the factor allocation would still require showing
the parity structure forces one factor to be a monomial). The status stays
"probably folklore, not found"; the searches performed are now on the record
so the next agent does not repeat them.
