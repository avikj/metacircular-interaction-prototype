# The reversal involution and the sign law of the cross-reversal charge

SEED-34 (Plimpton-322 lens). 2026-08-14. Companion to
`CROSS_REVERSAL_CHARGE.md` and `CROSS_REVERSAL_INDEX.md`.

A reciprocal table is a statement about the map \(x\mapsto x^{-1}\): which
entries close, which are fixed, and — the part the scribe never omits — the
exact list of exceptions. `CROSS_REVERSAL_CHARGE.md` builds an integer
\(\mathcal C(P)\) out of exactly that map and proves it multiplicative
(Theorem 2 there), but never asks how \(\mathcal C\) transforms under the
involution itself. Theorem 1 there cannot answer: it sees only
\(\mathcal C^2\). This note supplies the missing law, its fixed-point
analysis with the exceptions enumerated exhaustively, and a derivation
replacing the tabulated order computation of §4 there.

Everything below is exact algebra. Nothing is measured.

## 1. The pointed set and its involution

Let

\[
 \mathcal R_n=\{P\in\mathbb Z[x]:P\ \text{monic},\ \deg P=n,\ P(0)=1\},
 \qquad \mathcal R=\coprod_{n\ge0}\mathcal R_n,
\]

and \(P^*(x)=x^nP(x^{-1})\).

**Lemma 1.1.** \(*\) maps \(\mathcal R_n\) to \(\mathcal R_n\), is
multiplicative, and \((P^*)^*=P\).

*Proof.* The leading coefficient of \(P^*\) is \(P(0)=1\) and
\(P^*(0)\) is the leading coefficient of \(P\), which is \(1\); so \(P^*\in
\mathcal R_n\), and no degree is lost, which is what makes \(*\) an
involution rather than a partial map. Multiplicativity and involutivity are
immediate from \(x^{m+n}(PQ)(x^{-1})=x^mP(x^{-1})\cdot x^nQ(x^{-1})\). \(\square\)

The condition \(P(0)=1\) — "load-bearing" in `CROSS_REVERSAL_INDEX.md` §1 —
is exactly what makes \(\mathcal R\) closed. On monic \(P\) with
\(P(0)=-1\), \(*\) sends monic to anti-monic; the set is not closed and no
involution exists on the nose. Note also that the substitutions \(x\mapsto
\lambda x\) preserving \(\mathcal R\) are exactly \(\lambda=\pm1\): the
"unit group" of the table is \(\{\pm1\}\), and this is why §3 below has
endpoints \(1,-1\) and no others.

For \(P\in\mathcal R_n\) with roots \(\alpha_1,\dots,\alpha_n\) put, as in
(1.1) of the charge note,

\[
 \mathcal C(P)=\prod_{1\le i<j\le n}(1-\alpha_i\alpha_j)\in\mathbb Z,
 \qquad \mathcal C(P)=\det\!\big(1-\wedge^2A_P\big).
\]

Empty products are \(1\), so \(\mathcal C(1)=1\) and \(\mathcal C(x+1)=1\).

## 2. The sign law

Write \(N(n)=\binom n2=\tfrac{n(n-1)}2\).

**Theorem 2.1 (involution law for the charge).** For every \(P\in\mathcal R_n\),

\[
 \boxed{\ \mathcal C(P^*)=(-1)^{\binom n2}\,\mathcal C(P).\ }
\]

Equivalently, the charge is **conserved** by reversal when
\(n\equiv0,1\pmod4\) and **anti-conserved** when \(n\equiv2,3\pmod4\).

> **Scope, K1 (SEED-99, 2026-08-14).** Theorem 2.1 is confirmed unchanged by
> `notes/SEED45_REVERSAL_CHARGE_CORRECTION_TERMS.md` §1 (independently at
> \(n=3,4\) in closed form and structurally at \(n=8\)). What SEED-45 adds is a
> **scope warning that belongs here, at the theorem, and not only in §3.1(i)
> where this note in fact states it:** on the *reciprocal* locus \(P=P^*\) the
> law carries no information — for \(n\equiv0,1\pmod 4\) it reads
> \(\mathcal C(P)=\mathcal C(P)\), and for \(n\equiv2,3\) it gives
> \(\mathcal C(P)=0\), which Theorem 3.1 below proves anyway in all degrees by
> a route that does not use Theorem 2.1. The reciprocal octic layer of
> `collab/messages/0023-codex-reciprocal-octic.md` — the stratum at which the
> corpus actually applies this machinery — is exactly that locus, so there the
> law is true and vacuous and the corpus's square law is \(0=0\). The
> content-bearing replacement on that stratum is SEED-45's **reduced charge**:
> for reciprocal \(P\in\mathcal R_{2m}\) written \(P=x^m\widehat G(T)\),
> \(T=x+x^{-1}\), deleting the \(m\) forced vanishing factors gives
> \(\mathcal C^{\circ}(P)=\operatorname{disc}\widehat G\) and
> ~~\(\operatorname{disc}P=P(1)P(-1)\,\mathcal C^{\circ}(P)^2\)~~
> \(\operatorname{disc}P=(-1)^m\,P(1)P(-1)\,\mathcal C^{\circ}(P)^2\)
> (sign corrected 2026-08-14, SEED-103, at `SEED45` Thm 3.2; the struck form
> holds for even \(m\), which covers the octic stratum this box is about, and
> fails at \(m=1\): \(\operatorname{disc}(x^2+x+1)=-3\ne3\)). Read Theorem 2.1
> as a statement about the **non**-reciprocal stratum; there it is not vacuous,
> and Corollary 2.4's decic \(q_1\) is non-reciprocal
> (\(q_1^*=x^{10}+x^9+x^8+x^2+1\neq q_1\)), so Corollary 2.4 is unaffected.

*Proof.* The roots of \(P^*\) are \(\alpha_1^{-1},\dots,\alpha_n^{-1}\)
(none is \(0\), since \(P(0)=1\)). Hence

\[
 \mathcal C(P^*)=\prod_{i<j}\Big(1-\frac1{\alpha_i\alpha_j}\Big)
 =\frac{\prod_{i<j}(\alpha_i\alpha_j-1)}{\prod_{i<j}\alpha_i\alpha_j}
 =(-1)^{\binom n2}\,
 \frac{\mathcal C(P)}{\big(\prod_i\alpha_i\big)^{\,n-1}} .
\]

Each index occurs in exactly \(n-1\) unordered pairs, giving the exponent
\(n-1\). Now \(\prod_i\alpha_i=(-1)^nP(0)=(-1)^n\), so
\(\big(\prod_i\alpha_i\big)^{n-1}=(-1)^{n(n-1)}=1\), the exponent \(n(n-1)\)
being even for every \(n\). \(\square\)

The vanishing of the denominator is the whole content: the normalisation
\(P(0)=1\) is what makes the charge transform by a *sign* and not by a
scale. This is the same phenomenon as base-\(b\) regularity — a reciprocal
has a finite entry exactly when the norm is a unit — and it is recorded again
in §4.

**Corollary 2.2 (why Theorem 1 of the charge note cannot see this).** The
square law \(\operatorname{Res}(P,P^*)=(-1)^nP(1)P(-1)\mathcal C(P)^2\) is
invariant under \(P\mapsto P^*\) for *either* sign in Theorem 2.1.

*Proof.* \(P^*(1)=P(1)\), \(P^*(-1)=(-1)^nP(-1)\), and
\(\operatorname{Res}(P^*,P^{**})=\operatorname{Res}(P^*,P)
=(-1)^{n^2}\operatorname{Res}(P,P^*)\). Substituting, both sides of the
square law reproduce \(P(1)P(-1)\mathcal C(P)^2\), because \(n^2+n\) is
even; \(\mathcal C(P^*)\) enters squared. \(\square\)

So the sign law is genuinely independent information about the charge, not a
rearrangement of the published identity.

**Proposition 2.3 (consistency with multiplicativity — and why the sign must
be \((-1)^{\binom n2}\)).** For \(P\in\mathcal R_m\), \(Q\in\mathcal R_n\),

\[
 \operatorname{Res}(P^*,Q)=(-1)^{mn}\operatorname{Res}(P,Q^*),\qquad
 \operatorname{Res}(P^*,Q^*)=(-1)^{mn}\operatorname{Res}(P,Q).
\]

*Proof.* With \(\operatorname{Res}(A,B)=\operatorname{lc}(A)^{\deg B}
\prod_{A(\alpha)=0}B(\alpha)\) and both arguments monic:
\(Q(\alpha^{-1})=\alpha^{-n}Q^*(\alpha)\), so
\(\operatorname{Res}(P^*,Q)=\prod_i Q(\alpha_i^{-1})
=(\prod_i\alpha_i)^{-n}\operatorname{Res}(P,Q^*)=(-1)^{mn}
\operatorname{Res}(P,Q^*)\); the second identity is the same computation with
\(Q^*(\alpha^{-1})=\alpha^{-n}Q(\alpha)\). \(\square\)

Apply \(*\) to \(\mathcal C(PQ)=\mathcal C(P)\mathcal C(Q)
\operatorname{Res}(P,Q^*)\) (Theorem 2 of the charge note) and let
\(\varepsilon(n)\) be an unknown sign with \(\mathcal C(P^*)=
\varepsilon(\deg P)\mathcal C(P)\). Compatibility forces

\[
 \varepsilon(m+n)=\varepsilon(m)\varepsilon(n)(-1)^{mn},
\]

whose unique solution with \(\varepsilon(0)=1\) is
\(\varepsilon(n)=(-1)^{\binom n2}\), since \(\binom{m+n}2=\binom m2+\binom n2+mn\).
The multiplicativity law and the involution law determine each other. A
scribe checks the table twice; this is the second check.

**Corollary 2.4 (the corpus's decic).** \(n=10\), \(\binom{10}2=45\) odd, so
the charge of a decic is **anti-conserved**: \(\mathcal C(q^*)=-\mathcal C(q)\).
For the witness \(q_1=x^{10}+x^8+x^2+x+1\) of §4 there, with
\(\mathcal C(q_1)=-7=L\), one gets \(\mathcal C(q_1^*)=+7\) with no further
computation. The falsifier of §3 there is unaffected, since it depends on
\(L\) only through the primes dividing it.

## 3. Fixed points, and the exhaustive exception table

The fixed locus of the involution is \(\mathcal R_n^*=\{P:P=P^*\}\), the
reciprocal (palindromic) elements.

**Theorem 3.1 (vanishing on the fixed locus).** For \(P\in\mathcal R_n\)
reciprocal with \(n\ge2\), \(\mathcal C(P)=0\). The complete list of
reciprocal \(P\in\mathcal R\) with \(\mathcal C(P)\ne0\) is

\[
 \boxed{\;P=1\ (n=0),\qquad P=x+1\ (n=1);\quad\text{in both cases }
 \mathcal C(P)=1.\;}
\]

There are exactly two exceptions, and no others in any degree.

*Proof.* Two arguments; the first is short but partial, the second complete.

(i) *Sign argument.* If \(n\equiv2,3\pmod4\) and \(P=P^*\), Theorem 2.1 gives
\(\mathcal C(P)=-\mathcal C(P)\), so \(\mathcal C(P)=0\). This covers half the
degrees and nothing more: for \(n\equiv0,1\pmod4\) the law is vacuous on the
fixed locus. The vanishing is therefore *not* a consequence of the sign law,
and it is worth saying so, because the converse mistake — reading
"anti-conserved" as "vanishing" — would misdescribe degrees \(4,5,8,9,\dots\).

(ii) *Root argument, all degrees.* \(P=P^*\) means the multiset of roots is
stable under \(\alpha\mapsto\alpha^{-1}\). Suppose some root \(\alpha\) has
\(\alpha\ne\alpha^{-1}\). Then \(\alpha\) and \(\alpha^{-1}\) occupy two
distinct indices \(i<j\) with \(\alpha_i\alpha_j=1\), and that factor of
\(\mathcal C(P)\) is \(0\). Otherwise every root lies in \(\{1,-1\}\), so
\(P=\pm(x-1)^s(x+1)^t\); monic with \(P(0)=1\) forces
\((-1)^s=1\) after the sign is fixed, i.e. \(P=(x-1)^s(x+1)^t\) with \(s\)
even. If \(s\ge2\) two indices carry the root \(1\) and
\(1-1\cdot1=0\) kills the product; so \(s=0\). If \(t\ge2\) two indices carry
\(-1\) and again \(1-(-1)(-1)=0\); so \(t\le1\). Hence \(P=1\) or \(P=x+1\),
both of which have \(\binom n2=0\) and empty charge \(1\). \(\square\)

**Theorem 3.2 (the exact zero locus).** For \(P\in\mathcal R_n\),

\[
 \mathcal C(P)=0\iff \exists\,i<j:\ \alpha_i\alpha_j=1
 \iff
 \begin{cases}
 P\ \text{and}\ P^*\ \text{share a root }\gamma\notin\{\pm1\},\ \text{or}\\
 P\ \text{has a root }\gamma\in\{\pm1\}\ \text{of multiplicity}\ge2 .
 \end{cases}
\]

*Proof.* The first equivalence is the definition. \((\Rightarrow)\)
\(\alpha_j=\alpha_i^{-1}\) is a root of \(P\), so \(\alpha_i\) is a root of
\(P^*\); if \(\alpha_i\notin\{\pm1\}\) the first case holds, and if
\(\alpha_i\in\{\pm1\}\) then \(\alpha_j=\alpha_i\) and the multiplicity is at
least two. \((\Leftarrow)\) A common root \(\gamma\) of \(P,P^*\) gives
\(\gamma^{-1}\) as a root of \(P\); if \(\gamma\ne\gamma^{-1}\) these are two
distinct indices, and in the multiplicity case the two copies of \(\gamma=
\gamma^{-1}\) supply \(i<j\) directly. \(\square\)

**Corollary 3.3 (the zero locus is strictly larger than the fixed locus).**
\(\mathcal C\) vanishes on every \(P\) admitting a reciprocal factor of degree
\(\ge2\), by Theorems 3.1 and Theorem 2 of the charge note. Since
\(*\) is multiplicative, \(P=AB\) with \(A\) reciprocal of degree \(\ge2\)
and \(B\) non-reciprocal is itself non-reciprocal; e.g.

\[
 A=x^2+3x+1,\quad B=x^3+x^2+1,\quad
 P=AB\in\mathcal R_5,\quad \mathcal C(P)=0,\quad P\ne P^*.
\]

So \(\mathcal C\) is not a defining equation for the fixed locus; it is the
obstruction to \(\gcd(P,P^*)=1\) away from the endpoints. This is precisely
the role it plays in §3 of the charge note, where \(h_\ell=\gcd(\bar q,\bar
q^*)\) is nonconstant exactly because \(\ell\mid L\) and the endpoints are
invertible.

**Remark 3.4 (endpoints are the fixed points of the table, and nothing else).**
The factors \(P(1)P(-1)\) in the square law are the diagonal terms
\(i=j\) with \(\alpha_i^2=1\); these are the fixed points of
\(\alpha\mapsto\alpha^{-1}\), which by §1 number exactly two. This is the
same statement as "\(\pm1\) are the only units of the substitution group",
and it is why the charge note's Theorem 3 hypothesis
\(\ell\nmid q(1)q(-1)\) has exactly two conditions in it and never three.

## 4. Base-dependence: what is invariant, and what the actual variable is

The mandate's trap. Digit reversal in base \(b\) is not one map but a family;
a claim quoted without its \(b\) is the same failure this repository has
already recorded for a constant quoted without its \(X\)
(`HOLOGRAM.md` §7, `CLAUDE.md`). The audit below is exact.

**Proposition 4.1 (the digit-reversal comparison).** Let
\(P=\sum_{i=0}^na_ix^i\in\mathcal R_n\) and let \(b\ge2\) be an integer with
\(0\le a_i\le b-1\) for all \(i\). Let \(\rho_b\) denote reversal of the
base-\(b\) digit string of a positive integer, of length \(n+1\). Then

\[
 \rho_b\big(P(b)\big)=P^*(b).
\]

If some \(a_i\notin[0,b-1]\) — in particular whenever any coefficient is
negative, which is the generic case in this corpus — then \(P(b)\) carries
or borrows and the identity fails; \(\rho_b(P(b))\) is then not a function of
\(P\) alone.

*Proof.* Under the hypothesis the digits of \(P(b)\) are exactly
\((a_n,\dots,a_0)\), with no carries, and \(a_n=a_0=1\ne0\) so the string has
no leading-zero ambiguity in either direction. Reversing gives the integer
\(\sum_ia_{n-i}b^i=P^*(b)\). \(\square\)

**Consequence — the invariance audit.**

1. **Base-invariant (in fact base-free).** Lemma 1.1, Theorem 2.1,
   Theorems 3.1–3.2, Corollary 2.4, and every statement of
   `CROSS_REVERSAL_CHARGE.md` §§1–2 and `CROSS_REVERSAL_INDEX.md` §2. Reason:
   \(*\) is defined by \(x\mapsto x^{-1}\) on \(\mathbb Z[x]\), never by
   digits. No integer \(b\) appears in any hypothesis or conclusion. There is
   nothing to quote a \(b\) with.
2. **Not an artifact of base \(10\) or base \(2\).** Neither base occurs
   anywhere in the reversal corpus. Proposition 4.1 shows the *only* way a
   base could enter is as a digit lift of a polynomial, and ~~by Theorem 2.1~~
   **by the definition of \(\mathcal C\) in §1** (K3, SEED-99, 2026-08-14:
   \(\mathcal C\) is a symmetric function of the roots of \(P\) and no \(b\)
   occurs in it; Theorem 2.1 is a statement *about* \(\mathcal C\) and cannot
   be the ground of \(\mathcal C\)'s base-independence)
   the charge depends on the polynomial, so any two admissible bases give
   the same charge. Concretely, \(q_1\) has coefficients in \(\{0,1\}\), so
   Proposition 4.1 applies for every \(b\ge2\) simultaneously, and
   \(\rho_b(q_1(b))=q_1^*(b)\) for all of them: the witness is
   \(b\)-universal. There is no base-10 claim to retract and no base-2 claim
   to retract.
3. **The variable that *does* control the reversal statements is
   \((\ell,h_\ell)\), and it is the exact analogue of base regularity.** In
   \(R_\ell=\mathbb F_\ell[x]/(h_\ell)\), the class \(\beta\) of \(x\) is a
   unit precisely because \(h_\ell(0)\ne0\) — this is "\(\beta\) is
   \(\ell\)-regular", the terminating-reciprocal condition, and it is what
   licenses the finite table (4.2) of the charge note. Further, \(x\mapsto
   x^{-1}\) is a well-defined ring automorphism of \(R_\ell\) **iff**
   \(h_\ell\) is reciprocal, which Theorem 3 of the charge note supplies.
   The reciprocal table closes over \(R_\ell\); that is the entire reason a
   reversal syndrome exists there.

**Proposition 4.2 (the order \(r\), derived — replacing the tabulation).**
Let \(h_\ell\) be as in Theorem 3 of the charge note: reciprocal, with
\(h_\ell(\pm1)\ne0\) and \(h_\ell(0)\ne0\). Let \(g\mid h_\ell\) be
irreducible of degree \(d\) with root \(\beta\in\mathbb F_{\ell^d}\). Then
either

* \(g\) is reciprocal, in which case \(d\) is even and
  \(\operatorname{ord}(\beta)\mid \ell^{d/2}+1\); or
* \(g^*\ne g\), and \(g^*\mid h_\ell\) is a second irreducible factor of the
  same degree, with \(\operatorname{ord}(\beta)\mid\ell^d-1\).

Consequently \(r=\operatorname{ord}_{R_\ell}(x)\) is the lcm of these orders
over the factors, and in particular \(r\le\ell^3+1\) whenever
\(\deg h_\ell\le6\).

*Proof.* \(h_\ell\) reciprocal and \(g\mid h_\ell\) imply \(g^*\mid
h_\ell\). If \(g^*=g\) then \(\beta^{-1}\) is a root of \(g\), hence
\(\beta^{-1}=\beta^{\ell^k}\) for some \(0\le k<d\); applying the relation
twice gives \(\beta^{\ell^{2k}}=\beta\), so \(d\mid 2k\), so \(k=0\) or
\(2k=d\). The case \(k=0\) gives \(\beta^2=1\), i.e. \(\beta=\pm1\), excluded
by \(h_\ell(\pm1)\ne0\). Hence \(d=2k\) is even and
\(\beta^{\ell^{d/2}+1}=1\). Otherwise \(\beta\in\mathbb F_{\ell^d}^\times\)
and no more is claimed. \(\square\)

**Corollary 4.3 (the witness order \(r=8\), without powering).** For
\(\ell=7\), \(h_7=x^2+4x+1\): it is reciprocal and irreducible over
\(\mathbb F_7\) (its discriminant \(16-4=12\equiv5\) is a nonresidue mod
\(7\), the residues being \(1,2,4\)), of degree \(d=2\). By Proposition 4.2,
\(r\mid 7+1=8\). Now \(r\notin\{1,2\}\) since \(\beta\ne\pm1\), and \(r=4\)
would force \(\beta^2=-1\), i.e. \(h_7=x^2+1\), which it is not. Hence

\[
 \boxed{r=8\ \text{exactly},}
\]

and \(\beta^4=-1\), so the reversal automorphism of \(R_7\) is
\(\beta\mapsto\beta^{-1}=\beta^{7}\), i.e. the Frobenius. The table (4.2) of
the charge note — \(\beta^3=4+\beta\), \(\beta^5=6\beta\),
\(\beta^7=3+6\beta\) — is then a two-line consequence of
\(\beta^2=3\beta+6\) and \(\beta^4=-1\), and the modulus \(8\) of the counters
\(M_1,M_3,M_5,M_7\) is \(\ell+1\), not a chosen base.

That last sentence is the whole point of the audit: the "8" in the syndrome
of (4.3) is **not** a base and **not** a fitted parameter. It is
\(\ell+1\) for the unique odd prime \(\ell=7\) dividing \(L\), and it moves
when \(L\) moves. Anyone reusing the falsifier for a different \(q\) must
recompute \(r\) from Proposition 4.2 and must not carry \(8\) over. A number
without its dependence looks like knowledge; here the dependence is
\(r\mid\ell^{d/2}+1\).

## 5. Ledger

* New and proved here: Theorem 2.1 (sign law), Corollary 2.2 (independence
  from the square law), Proposition 2.3 (mutual determination with
  multiplicativity), Theorem 3.1 with its two-element exception list,
  Theorem 3.2 (exact zero locus), Corollary 3.3, Propositions 4.1–4.2,
  Corollary 4.3.
* Quoted from `CROSS_REVERSAL_CHARGE.md` without reproof: Theorem 1 (square
  law), Theorem 2 (multiplicativity), Theorem 3 (degree-six compression),
  and the data \(L=-7\), \(h_7=x^2+4x+1\), \(\mathcal C(q_1)=-7\).
* Nothing here is measured. No floating point, no fitted constant, no
  correlation. All finite verifications used (the discriminant \(12\equiv5\)
  nonresidue mod \(7\); the recursion \(\beta^2=3\beta+6\)) are exhaustive
  over finite sets and are exhibited in full.
* Prior art: the sign \((-1)^{\binom n2}\) is the determinant of the
  inversion action on \(\wedge^2\) of the root space, so a reader fluent in
  compound matrices would call Theorem 2.1 expected. It is nonetheless
  absent from this corpus, and the corpus's own Theorem 1 provably cannot
  supply it (Corollary 2.2). No novelty is claimed for the identity; the
  claim is that the decic sector is anti-conserving and that the reciprocal
  fixed locus has exactly two charged points.
* ~~Open, tagged `PROVE`~~ **CLOSED, negatively, by
  `notes/SEED45_REVERSAL_CHARGE_CORRECTION_TERMS.md` §4 (K1, SEED-99,
  2026-08-14).** There is **no** universal orientation. SEED-45 computes the
  quartic charge in closed form via the resolvent cubic,
  \(P=x^4+px^3+qx^2+rx+1\Rightarrow\mathcal C(P)=-(p-r)^2\), and the trace
  resultant there is \(L=(p-r)^2\); so \(\mathcal C=-L\) **identically in
  degree 4**, while the decic witness has \(\mathcal C(q_1)=+L\). The
  orientation sign is therefore a degree-by-degree invariant, not a universal
  one, and it is \(-1\) at the first degree where a closed form exists. The
  item's own reversal-parity reasoning survives as a consistency check and is
  not what fails; what fails is the hoped-for universality. SEED-45 records
  that this note was right to decline the universal claim. The struck text
  follows, for the record:
* ~~Open, tagged `PROVE`: does the sign law constrain which \(L\) can occur in
  degree \(n\equiv2,3\pmod4\)? Anti-conservation plus \(\mathcal C(q)=\pm L\)
  says the orientation of \(L\) flips under reversal, so any orientation
  convention for \(L\) in `CROSS_REVERSAL_INDEX.md` must be
  reversal-odd. Since \(K\mapsto-K\) and \(H\mapsto H\) under \(q\mapsto
  q^*\), and \(\operatorname{Res}_T(H,-K)=(-1)^{\deg H}\operatorname{Res}_T(H,K)
  =-L\) for \(\deg H=5\), the trace resultant is reversal-odd on the nose:
  this matches Theorem 2.1 at \(n=10\) and pins the sign in (0.2)
  consistently. Verifying that this determines \(\mathcal C(q)=+L\) rather
  than \(-L\) for all nonreciprocal decics — the note declines to claim a
  universal orientation — is the natural next item.~~
