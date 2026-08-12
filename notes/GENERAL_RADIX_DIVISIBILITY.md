# Finite signatures for divisibility in every radix

Fix a base \(b\ge2\) and modulus \(m\ge1\). A remainder \(r\) evolves after
appending a digit \(d\) by

\[
r\longmapsto br+d\pmod m,
\]

and the only observation is whether the current remainder is zero. Two
remainders are behaviorally equal when every future digit word gives the same
divisibility answer.

Let \(K\) be the least integer with \(b^K\ge m\), and put

\[
t_k(r)=(-b^k r)\bmod m\quad(0\le t_k(r)<m).
\]

For \(k<K\), define

\[
e_k(r)=
\begin{cases}
t_k(r),&t_k(r)<b^k,\\
\bot,&t_k(r)\ge b^k.
\end{cases}
\]

Finally put \(g_K=\gcd(m,b^K)\) and define the finite signature

\[
\Sigma_{b,m}(r)=
\left(e_0(r),\ldots,e_{K-1}(r),
r\bmod \frac m{g_K}\right).                       \tag{1}
\]

## Theorem

Two remainders have the same future divisibility behavior if and only if
their signatures (1) are equal. Consequently the minimal deterministic
automaton is the image of \(\Sigma_{b,m}\), and its exact number of states is

\[
\left|\{\Sigma_{b,m}(r):0\le r<m\}\right|.          \tag{2}
\]

### Proof

A word of length \(k\) represents a unique integer \(n\) with
\(0\le n<b^k\), and it is accepted from \(r\) exactly when

\[
n\equiv-b^k r\pmod m.                               \tag{3}
\]

If \(k<K\), then \(b^k<m\), so the interval contains at most one integer in
the residue class (3). Its complete accepting-suffix set is therefore the
singleton \(\{t_k(r)\}\) when \(t_k(r)<b^k\), and is empty otherwise. This
is exactly \(e_k(r)\).

At length \(K\), the interval \([0,b^K)\) contains a representative of every
residue modulo \(m\). Hence two states have equal accepting suffix sets at
that length exactly when

\[
b^K(r-s)=0\pmod m,
\]

or equivalently \(r=s\pmod{m/g_K}\). For every \(k>K\),
\(\gcd(m,b^K)\mid\gcd(m,b^k)\), so this congruence already implies equality
of the length-\(k\) accepting sets. Thus (1) is sufficient. Every coordinate
of (1) is itself a future-language observation, so it is also necessary. ∎

## Relation to the binary theorem

For \(b=2\) and \(m=2^a q\) with \(q\) odd, the signature fibers simplify
to zero, the \(q-1\) nonzero residue classes modulo \(q\), and the \(a\)
finite two-adic depths among nonzero multiples of \(q\). Formula (2) therefore
reduces to \(q+a\), recovering `BINARY_DIVISIBILITY_CRYSTAL.md`.

For composite bases several prime-adic depths interact through the short
reachability coordinates; no replacement \(q+K\) is valid. The smallest
control in the tests is base ten modulo twelve: \(K=2\) and the coprime part
is three, but the minimal automaton has seven states rather than five.

## Execution and boundary

`radix_divisibility_signature` and `radix_divisibility_classes` implement
(1)--(2). Tests compare the closed signature partition with independent
behavioral refinement for every \(2\le b\le10\), \(1\le m\le60\), and check
that the prior binary closed form is exactly the base-two specialization.
These finite comparisons replay the proof; they are not evidence for it.

The theorem is elementary Myhill--Nerode analysis for a divisibility language.
No literature-novelty claim is made. Its value here is assimilation: a pattern
first observed in one radix becomes the exact sufficient statistic for all
radices, including the obstruction to the tempting binary extrapolation.
