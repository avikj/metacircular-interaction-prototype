# The conserved cross-reversal charge

## 0. Status

This note strengthens the divisibility statement attached to the first open
nonreciprocal decic layer. For a monic polynomial \(P\) of constant term one,
define

\[
 \mathcal C(P):=\prod_{i<j}(1-\alpha_i\alpha_j)
              =\det(1-\wedge^2 A_P),                 \tag{0.1}
\]

where the \(\alpha_i\) are the roots of \(P\) and \(A_P\) is its companion
operator. This is an integer. For the decic \(q\) of
CROSS_REVERSAL_INDEX.md, comparison with the trace resultant gives

\[
 \mathcal C(q)=\pm L,\qquad
 L=\operatorname{Res}_T(H,K).                         \tag{0.2}
\]

The charge is multiplicative across a factorization with one explicit cross
term. Consequently,

\[
 q\mid F_X\quad\Longrightarrow\quad
 \boxed{L\mid\mathcal C(F_X).}                         \tag{0.3}
\]

This removes the endpoint factors and square from the earlier statement
\(L^2\mid\operatorname{Res}(F_X,F_X^*)\). Each nondegenerate odd prime
dividing \(L\) also yields a degree-at-most-six finite-state obstruction on
the actual prime support.

The result is a reusable falsifier, not an all-\(X\) exclusion. The witness
\(q_1=x^{10}+x^8+x^2+x+1\) has \(L=-7\), but a genuine prime prefix at
\(X=2467\) passes its quadratic collision test.

## 1. Universal square law

Let \(P\in\mathbb Z[x]\) be monic of degree \(n\), let \(P(0)=1\), and put
\(P^*(x)=x^nP(x^{-1})\).

**Theorem 1 (compound square law).** The number

\[
 \mathcal C(P)=\prod_{1\le i<j\le n}(1-\alpha_i\alpha_j) \tag{1.1}
\]

is an integer, and

\[
 \boxed{
 \operatorname{Res}(P,P^*)=(-1)^nP(1)P(-1)\mathcal C(P)^2.} \tag{1.2}
\]

**Proof.** The product (1.1) is a symmetric polynomial with integer
coefficients in the roots. The integral fundamental theorem of symmetric
polynomials and monicity give \(\mathcal C(P)\in\mathbb Z\). Also

\[
 P^*(x)=\prod_j(1-\alpha_jx),
\]

and therefore

\[
\begin{aligned}
 \operatorname{Res}(P,P^*)
 &=\prod_{i,j}(1-\alpha_i\alpha_j)\\
 &=\prod_i(1-\alpha_i^2)
   \left(\prod_{i<j}(1-\alpha_i\alpha_j)\right)^2.
\end{aligned}
\]

Finally, \(\prod_i(1-\alpha_i^2)=(-1)^nP(1)P(-1)\). \(\square\)

The eigenvalues of \(\wedge^2A_P\) are the products
\(\alpha_i\alpha_j\), \(i<j\), proving the determinant form (0.1). This
gives an independent exact-integer checker which never constructs a root.
Comparison of (1.2) with the decic trace-resultant identity gives
\(\mathcal C(q)^2=L^2\), hence (0.2). No universal orientation-sign claim
is needed here. The independent compound determinant does fix the sign for
each input; in particular \(\mathcal C(q_1)=-7=L\).

## 2. Factorization conservation law

**Theorem 2 (conserved cross-reversal charge).** If \(P,Q\in\mathbb Z[x]\)
are monic with constant term one, then

\[
 \boxed{
 \mathcal C(PQ)=\mathcal C(P)\mathcal C(Q)
                  \operatorname{Res}(P,Q^*).}          \tag{2.1}
\]

Consequently, \(q\mid F\) implies

\[
 \boxed{\mathcal C(q)\mid\mathcal C(F).}               \tag{2.2}
\]

**Proof.** Partition the unordered pairs of roots of \(PQ\) into pairs
internal to \(P\), pairs internal to \(Q\), and cross pairs. The cross
product is

\[
 \prod_{\alpha,\beta}(1-\alpha\beta)
 =\prod_{P(\alpha)=0}Q^*(\alpha)
 =\operatorname{Res}(P,Q^*).
\]

This proves (2.1), and (2.2) follows. \(\square\)

Taking \(F=F_X\), \(P=q\), and using (0.2) proves (0.3). The old square
divisibility is the square of this unsquared factorization law, with its
endpoint contribution restored by (1.2).

## 3. Cross-index primes are small-state falsifiers

Retain the nonreciprocal decic notation

\[
 q-q^*=x(x^2-1)\,x^3K(T),\qquad
 \frac{q+q^*}{2}=x^5H(T),\qquad T=x+x^{-1}.             \tag{3.1}
\]

**Theorem 3 (degree-six compression, nondegenerate case).** Let \(\ell\)
be an odd prime such that

\[
 \ell\mid L,\qquad \ell\nmid q(1)q(-1),\qquad \bar K\ne0. \tag{3.2}
\]

Then the full monic gcd

\[
 h_\ell=\gcd(\bar q,\bar q^*)\in\mathbb F_\ell[x]
\]

is nonconstant, reciprocal, and has even degree at most six. If
\(q\mid F_X\), necessarily

\[
 \boxed{F_X\equiv0\pmod{h_\ell}.}                      \tag{3.3}
\]

**Proof.** The resultant identity and the endpoint hypothesis imply that
\(\bar q,\bar q^*\) have a nonconstant gcd. This gcd is fixed by reversal
and has no roots at \(0,1,-1\). It divides

\[
 \bar q-\bar q^*=x(x^2-1)\,x^3\bar K(T).
\]

Remove the factors \(x(x^2-1)\), which are coprime to the gcd. If
\(m=\deg\bar K\), the remainder is the reciprocal lift
\(x^m\bar K(x+x^{-1})\), up to a power of \(x\); the gcd is also coprime to
that power. The lift has degree \(2m\le6\). This polynomial-divisibility
argument retains all common-factor multiplicities. Reversal pairs the
remaining roots, so the degree is even. Divisibility into \(F_X\) survives
reduction modulo \(\ell\), proving (3.3). \(\square\)

The condition \(\bar K\ne0\) is load-bearing. If every coefficient of
\(K\) vanishes modulo \(\ell\), then \(q\equiv q^*\pmod\ell\), and the gcd
can have degree ten despite nonzero endpoint values. This degenerate branch
is detected by four coefficient reductions. It still gives a finite-state
falsifier—reduce modulo the full \(q\)—but not degree-six compression.

Because \(h_\ell(0)\ne0\), \(x\) is a unit in the finite ring

\[
 R_\ell=\mathbb F_\ell[x]/(h_\ell).
\]

Let its exact order be \(r\), and put

\[
 N_a(X)=\#\{p\le X:p-2\equiv a\pmod r\}.
\]

Then (3.3) is exactly the bounded-memory syndrome

\[
 \boxed{
 \sum_{a=0}^{r-1}(N_a(X)\bmod\ell)x^a=0
 \quad\text{in }R_\ell.}                              \tag{3.4}
\]

Its state dimension is at most six, regardless of \(\deg F_X\). Among
tests retaining only \(F_X\bmod h_\ell\), zero remainder is the complete
necessary condition. Thus a smallest irreducible factor of
\(\gcd(q,q^*)\) is a natural cheapest-first falsifier.

## 4. The witness \(q_1\)

For

\[
 q_1=x^{10}+x^8+x^2+x+1
\]

one has

\[
 L=-7,\qquad
 h_7=\gcd(q_1,q_1^*)=x^2+4x+1\pmod7.                  \tag{4.1}
\]

If \(\beta\) is the class of \(x\), then it has exact order eight and

\[
 \beta^1=\beta,\quad
 \beta^3=4+\beta,\quad
 \beta^5=6\beta,\quad
 \beta^7=3+6\beta.                                    \tag{4.2}
\]

Let \(M_r(X)\) count odd primes \(p\le X\) with \(p\equiv r\pmod8\), for
\(r\in\{1,3,5,7\}\). The prime \(2\) supplies the constant term. Reduction
of \(F_X(\beta)\) in the basis \(1,\beta\) gives

\[
\boxed{
\begin{aligned}
 1+3M_1+4M_5&\equiv0\pmod7,\\
 6M_1+M_3+M_5+6M_7&\equiv0\pmod7.
\end{aligned}}                                        \tag{4.3}
\]

These are two independent affine equations on four counters. Exactly
\(7^2\) of the \(7^4\) abstract mod-seven counter states survive: the
syndrome rejects \(48/49\). This is a finite-state count, not a distribution
theorem for prime prefixes. The endpoint tether independently requires

\[
 \pi(X)\equiv5\pmod {15}.                              \tag{4.4}
\]

At the genuine cutoff \(X=2467\),

\[
 \pi(X)=365,\qquad
 (M_1,M_3,M_5,M_7)=(83,94,95,92),
\]

and both (4.3) and (4.4) hold. The full remainder modulo \((13,q_1)\),
however, is

\[
 (0,10,4,10,12,2,7,9,12,9)
\]

in ascending powers, so \(q_1\nmid F_{2467}\). The collision test is a
rigorous compressor/falsifier, not a global exclusion.

## 5. Replay and rigor boundary

The replay code in code/exp50_cross_reversal_charge.py checks:

1. the determinant \(\det(1-\wedge^2A_P)\);
2. the square and factorization laws on planted exact polynomials;
3. \(\mathcal C(q_1)=-7\) and the quadratic gcd/order certificate;
4. the generic residue-count syndrome;
5. a planted accepting syndrome and one-coordinate rejecting mutation; and
6. the named prefix falsifiers \(X=71\) and \(X=2467\).

The prefix computations test fixed claims. They are not a census,
asymptotic evidence, evidence of eventual avoidance, or a claim that no later
cutoff can pass.

The abstract formula belongs to classical **second compound matrix** /
**second exterior power** algebra, and (1.2) is a reciprocal-resultant square
factorization. The project-specific contribution is the prime-prefix
collision-charge application and exact syndrome kernel. No targeted
prior-art search for that packaging has been recorded, so no novelty claim
is made.

> **PRIOR-ART SWEEP 2026-08-14 — searched. RESOLVED-FOUND for the abstract
> formula, RESOLVED-NO-MATCH for the packaging** (search-summary/śabda grade;
> `WebFetch` EGRESS_BLOCKED, no source text read). The self-declared
> attribution above checks out and can be made specific: the second compound /
> second additive compound $L^{[2]}$, defined by
> $L^{[2]}(u\wedge v)=Lu\wedge v+u\wedge Lv$ with spectrum the pairwise sums of
> eigenvalues, is standard matrix theory — Horn–Johnson, *Topics in Matrix
> Analysis*, ch. 6, and see arXiv:1806.07162 for a modern determinant formula
> and applications; the resultant-as-Sylvester-determinant and its use to
> eliminate a variable is textbook. **The abstract formula is known
> mathematics.** Nothing was located for the prime-prefix collision-charge
> application or the exact syndrome kernel. Query: *second compound matrix
> exterior square reciprocal polynomial resultant square factorization
> discriminant collision detection*. Absence of a located source is not
> evidence of novelty. Attribution status only; no claim is altered.
