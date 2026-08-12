# The forest: one rigid point and one noncommuting action

Program navigation: `PRIME_PAIR_FIELD_PROGRAM_LIBRARY_INDEX.md` records the
user-supplied Prime Pair Field corpus through Delta 12. It is an index, not a
verification upgrade; this file remains the compressed exact center of the
Liouville/parity branch.

This page is the compressed center of the Liouville/parity program. It keeps
only exact statements and names the open interface without pretending that
the interface is already a theorem.

## 1. The object

Let

\[
\lambda=(\lambda(1),\lambda(2),\ldots)\in\{\pm1\}^{\mathbb N},
\qquad (T_mx)(n)=x(mn),\qquad (Sx)(n)=x(n+1).
\]

The completely multiplicative sign sequences form the compact abelian group

\[
\mathcal M=\{x\in\{\pm1\}^{\mathbb N}:x(mn)=x(m)x(n)\},
\]

under pointwise multiplication. Restriction to the primes identifies
\(\mathcal M\) with \(\{\pm1\}^{\mathcal P}\): prime values are free, and
unique factorization determines every other coordinate.

## 2. The exact dilation spectrum

For every \(m\geq1\),

\[
\boxed{T_m\lambda=\lambda(m)\lambda.} \tag{2.1}
\]

Thus every prime generator has eigenvalue \(-1\), while a general semigroup
element has eigenvalue \(\lambda(m)=(-1)^{\Omega(m)}\). It is incorrect to
say that every element of the multiplicative semigroup has eigenvalue
\(-1\): eigenvalues must multiply, and \(T_pT_q\lambda=+\lambda\).

The prime-generator spectrum characterizes the point up to global sign.

**Proposition 2.1 (prime-spectrum uniqueness).** If
\(x\in\{\pm1\}^{\mathbb N}\) satisfies \(T_px=-x\) for every prime \(p\),
then

\[
x=x(1)\lambda.
\]

**Proof.** If \(n=p_1\cdots p_r\), repeated application of the eigenvalue
equations gives \(x(n)=(-1)^r x(1)=\lambda(n)x(1)\). \(\square\)

This is multiplicative rigidity, not additive randomness. General
simultaneous dilation eigenvectors can be completely structured—the constant
sequence is the simplest counterexample. Even the all-prime \(-1\) spectrum
forces randomness only if one has independently proved a randomness theorem
about the uniquely selected point \(\lambda\).

## 3. The real interface: dilation does not commute with shift

The additive and multiplicative actions meet in the exact affine-semigroup
relation

\[
\boxed{S T_m=T_m S^m.} \tag{3.1}
\]

Indeed, both sides evaluated at coordinate \(n\) equal \(x(mn+m)\). The
shift does not preserve \(\mathcal M\), so there is no joint diagonalization
that turns Chowla into a formal consequence of (2.1). The research problem
is to understand shift-orbit measures of the rigid point selected by the
dilation spectrum, using the noncommuting relation (3.1) plus genuinely
arithmetic input.

This formulation is close in spirit to \(\times2,\times3\) measure rigidity,
but it is not an instance of a solved classification theorem. The Furstenberg
classification is conjectural in general; the Rudolph--Johnson theorem
handles a positive-entropy invariant/ergodic regime. Entropy-decrement
arguments for logarithmic Liouville correlations use much more than (2.1),
including logarithmic averaging, short-interval estimates, and
approximate-independence machinery.

## 4. The exact statistical target

For \(\varepsilon=(\varepsilon_1,\ldots,\varepsilon_k)\in\{\pm1\}^k\),
put

\[
f_{k,\varepsilon}(X)=\frac1X\#\{n\leq X:
(\lambda(n+1),\ldots,\lambda(n+k))=\varepsilon\}.
\]

Boolean/Walsh inversion gives the clean equivalence

\[
\boxed{
\text{full Cesàro Chowla}
\quad\Longleftrightarrow\quad
f_{k,\varepsilon}(X)\longrightarrow2^{-k}
\text{ for every }k,\varepsilon.} \tag{4.1}
\]

One direction expands a pattern indicator as
\(2^{-k}\prod_j(1+\varepsilon_j\lambda(n+j))\); the other takes marginals
and Walsh coefficients. Mere occurrence, positive upper density, positive
lower density, and limiting density \(2^{-k}\) are four different claims and
must not be interchanged.

The current unconditional sign-pattern frontier recorded here is:

- every pattern of length at most four occurs with positive lower density;
- at length five, at least 24 of the 32 patterns are known to occur with
  positive upper density;
- all-pattern length five remains open.

The finite census in `code/exp43_sign_patterns.py` finds all patterns through
length six below \(10^7\). This is a regression/falsification datum only. A
finite census proves neither global occurrence nor positive density, and its
bit labels are printed in reverse temporal order because the encoding is
little-endian.

## 5. What this does—and does not—redirect

The useful redirect is precise:

1. classify which shift-invariant measures can arise from points of
   \(\mathcal M\);
2. isolate the additional arithmetic input that selects the Liouville orbit
   from structured completely multiplicative orbits;
3. exploit (3.1) quantitatively enough to force new Walsh coefficients or
   sign patterns;
4. compare the integer dependency graph with function-field monodromy proofs,
   with all characteristic/degree/uniformity regimes stated explicitly.

Repository no-go theorems eliminate only the observer, cone, functor, or
proof classes they define. They do not prove that every method failing to use
(2.1) is blind, and the gauge twirl is not globally identical to dilation
symmetrization.

Finally, Chowla for \(\lambda\) does not by itself prove twins or Goldbach:
unweighted density-scale Liouville correlations cannot isolate the sparse
prime set. The prime-pair field and rational-character channels remain the
separate machinery that records where prime weights, local factors, and pair
projectors enter.

That is the forest: a uniquely rigid multiplicative point, a noncommuting
additive action, and an open measure-classification problem at their
interface.
