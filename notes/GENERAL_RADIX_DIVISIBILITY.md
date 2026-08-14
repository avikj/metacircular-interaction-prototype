# Finite signatures for divisibility in every radix

**Prior art.** Boris Alexeev, *Minimal DFAs for Testing Divisibility*, JCSS 69
(2004), 235--243 ([arXiv:cs/0309052](https://arxiv.org/abs/cs/0309052)), gives
the complete minimal automaton and an exact closed state-count formula in every
radix. The signature theorem below is an independently derived sufficient-
statistic presentation of the same Myhill--Nerode classes, not a novelty claim.
Alexeev's strict-solution-set packages remove redundant signature coordinates
and count the image in closed form.

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
Its value here is assimilation and independent replay: a pattern
first observed in one radix becomes the exact sufficient statistic for all
radices, including the obstruction to the tempting binary extrapolation.

## Alexeev's sharper closed count

Write \(\ell(x,y)=x/\gcd(x,y)\). Alexeev proves

\[
f_b(m)=\ell(m,b^\infty)+
\sum_{\alpha\ge0}
\min\!\left(
\ell(b^\alpha,m),
\ell(m,b^\alpha)-\ell(m,b^{\alpha+1})
\right).                                             \tag{3}
\]

The sum is finite once the gcd chain stabilizes. In the present notation, a
term at level \(\alpha\) counts the nonempty *new* accepting-suffix classes
first appearing at that length; \(\ell(m,b^\infty)\) counts the final
eventual-congruence package. Thus (3) counts exactly the nonredundant image of
our signature (1). For \(b=2\), \(m=2^a q\), each transient level contributes
one and the eventual package contributes \(q\), giving \(q+a\).

## Pointer: signature (1) is not minimal

`notes/RADIX_SHORTEST_COMPLETION_INVARIANT.md` (2026-08-14) shows that (1)
factors through a **two-coordinate** invariant
\(\sigma(r)=(\kappa(r),\,b^{\kappa(r)}r\bmod m)\), where \(\kappa(r)\) is the
least length of a digit word completing \(r\) to a multiple of \(m\): the
coordinates \(e_k\) are \(\bot\) exactly for \(k<\kappa(r)\) and are functions
of \(b^{\kappa(r)}r\bmod m\) thereafter. The two-coordinate form needs no
\(K\), no interval test and — unlike the proof above — no assumption that the
digit alphabet is \(\{0,\dots,b-1\}\); it is machine-checked for an arbitrary
alphabet in `formal/cubical/NaturalMachine/RadixSymptoma.agda`.
