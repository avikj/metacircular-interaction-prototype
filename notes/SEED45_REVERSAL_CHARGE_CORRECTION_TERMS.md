# The reversal charge on the fixed locus: correction terms, not discrepancies

SEED-45 (Nīlakaṇṭha lens). 2026-08-14. Corroborates and corrects
`notes/SEED34_REVERSAL_INVOLUTION_SIGN_LAW.md`; audits
`collab/messages/0023-codex-reciprocal-octic.md` and
`notes/CHARGED_FIXED_FIBER_AUDIT.md`.

Nīlakaṇṭha's discipline: when the received series fails, do not record that it
fails — record the term that was dropped. Below, three places in the corpus
state a vanishing, a discrepancy, or a finiteness without its contribution.
Each gets its exact contribution.

Everything here is exact algebra. Nothing is measured. No floating point.

## 0. Summary of findings

1. SEED-34's sign law \(\mathcal C(P^*)=(-1)^{\binom n2}\mathcal C(P)\) is
   **correct**, and I verify it independently by closed form at \(n=3,4\) and
   structurally at \(n=8\) (§1). The one delicate step of its proof
   (\(\prod\alpha_i=(-1)^nP(0)\), \((\prod\alpha_i)^{n-1}=1\)) is confirmed.
2. Applied to the reciprocal octic of message 0023 the law is **true but
   vacuous**: \(g=g^*\), so it asserts \(\mathcal C(g)=\mathcal C(g)\). The
   non-vacuous fact is \(\mathcal C(g)=0\), and hence
   \(\operatorname{Res}(g,g^*)=0\): the corpus's Theorem 1 square law is the
   identity \(0=0\) on the entire reciprocal locus (§2).
3. **Correction term for the collapsed square law (§3, new).** For reciprocal
   \(P\in\mathcal R_{2m}\) with \(P=x^m\widehat G(T)\), \(T=x+x^{-1}\), define
   the reduced charge \(\mathcal C^\circ(P)\) by deleting exactly the \(m\)
   vanishing factors. Then
   \[
    \boxed{\ \mathcal C^\circ(P)=\operatorname{disc}\widehat G,\qquad
    ~~\operatorname{disc}P=P(1)P(-1)\,\mathcal C^\circ(P)^2~~
    \ \Longrightarrow\
    \operatorname{disc}P=(-1)^m P(1)P(-1)\,\mathcal C^\circ(P)^2.\ }
   \]
   > **Correction, 2026-08-14 (SEED-103, Rule K K1/K3).** The sign
   > \((-1)^m\) was dropped; see the strike at Theorem 3.2 below for the
   > derivation and the two counterexamples. The identity is correct as
   > originally written exactly when \(m\) is even, which covers every
   > application made in this note and downstream (all are \(m=2,4\)).
   This is Theorem 1 of `CROSS_REVERSAL_CHARGE.md` one level down: the same
   shape, with \(\operatorname{Res}(P,P^*)\rightsquigarrow\operatorname{disc}P\)
   and \(\mathcal C\rightsquigarrow\mathcal C^\circ\). It is the missing
   contribution, not a note that the old one vanishes.
4. Message 0023's resultant is **re-derived exactly** and confirmed, including
   which parity split it uses (§2.2), and its two factors are identified as
   evaluations of one quadratic.
5. **SEED-34's open `PROVE` item is settled negatively (§4).** For quartics
   \(P=x^4+px^3+qx^2+rx+1\),
   \(\boxed{\mathcal C(P)=-(p-r)^2}\) in closed form, and the trace resultant
   is \(L=(p-r)^2\), so \(\mathcal C=-L\) **identically in degree 4**, whereas
   the decic witness has \(\mathcal C(q_1)=+L\). There is no universal
   orientation; the orientation sign is a degree-by-degree invariant and it is
   \(-1\) at the first computable degree.
6. **A second blindness, independent of SEED-34's Corollary 2.2 (§5).** The
   whole falsifier of `CROSS_REVERSAL_CHARGE.md` §3 is reversal-invariant on
   the nose — \(h_\ell(q^*)=h_\ell(q)\) as sets of gcds — so the syndrome
   (3.4) cannot see the sign either. Two independent instruments in the corpus
   are blind to the same bit.
7. Correction terms for `CHARGED_FIXED_FIBER_AUDIT.md` (§6): the exact
   bidegree bound behind "only finitely many terms", and the exact truncation
   deficit behind "truncated twin-type count".

## 1. Independent verification of the sign law

Notation of SEED-34: \(\mathcal R_n=\{P\in\mathbb Z[x]\ \text{monic},\deg
P=n,\ P(0)=1\}\), \(P^*(x)=x^nP(x^{-1})\),
\(\mathcal C(P)=\prod_{i<j}(1-\alpha_i\alpha_j)\).

**1.1 Degree 3, by hand.** For \(A\in\mathcal R_3\) the products
\(\alpha_i\alpha_j\) are \(e_3/\alpha_k\) with \(e_3=(-1)^3A(0)=-1\), so
\[
 \mathcal C(A)=\prod_k\Big(1+\tfrac1{\alpha_k}\Big)
 =\frac{\prod_k(\alpha_k+1)}{\prod_k\alpha_k}
 =\frac{-A(-1)}{-1}=A(-1).
\]
Take \(A=x^3+x^2+1\), \(A^*=x^3+x+1\): \(\mathcal C(A)=A(-1)=1\),
\(\mathcal C(A^*)=A^*(-1)=-1\). And \(\binom32=3\) is odd, so the law predicts
\(\mathcal C(A^*)=-\mathcal C(A)=-1\). ✓

**1.2 Degree 4, closed form.** Let \(P=x^4+px^3+qx^2+rx+s\). The six products
\(\alpha_i\alpha_j\) fall into three complementary pairs with product \(s\) and
sums \(z_1,z_2,z_3\) the roots of the classical cubic resolvent
\[
 R(z)=z^3-qz^2+(pr-4s)z-(p^2s-4qs+r^2).
\]
Hence \(\mathcal C(P)=\prod_k(1-z_k+s)=R(1+s)\). At \(s=1\):
\[
 \mathcal C(P)=R(2)=8-4q+2(pr-4)-\big(p^2-4q+r^2\big)=-(p-r)^2 .
\]
\[
 \boxed{\ P=x^4+px^3+qx^2+rx+1\ \Longrightarrow\ \mathcal C(P)=-(p-r)^2.\ }
\tag{1.1}
\]
Now \(P^*=x^4+rx^3+qx^2+px+1\) gives \(\mathcal C(P^*)=-(r-p)^2=\mathcal C(P)\),
and \(\binom42=6\) is even. ✓ The law is verified at \(n=4\) by an identity,
not a specimen.

*Cross-check of (1.1) against the corpus's Theorem 1.* Take \(P=x^4+x^3+1\)
(\(p=1,q=r=0\)), so (1.1) gives \(\mathcal C=-1\). Independently
\(P^*=x^4+x+1\) and, using \(\alpha^4=-\alpha^3-1\),
\(P^*(\alpha)=\alpha^4+\alpha+1=-\alpha(\alpha-1)(\alpha+1)\), so
\(\operatorname{Res}(P,P^*)=\prod\alpha\cdot\prod(\alpha-1)\cdot\prod(\alpha+1)
=1\cdot P(1)\cdot P(-1)=3\cdot1=3\), matching
\((-1)^4P(1)P(-1)\mathcal C^2=3\). ✓ And \(R(2)=2^3-4\cdot2-1=-1\) fixes the
sign. ✓

**1.3 Degree 8 (the mandate's case), structurally.** Write \(P=AB\) with
\(A,B\in\mathcal R_4\). By Theorem 2 of `CROSS_REVERSAL_CHARGE.md`,
\(\mathcal C(P)=\mathcal C(A)\mathcal C(B)\operatorname{Res}(A,B^*)\). Apply
\(*\), using \(A^{**}=A\), SEED-34's Proposition 2.3
(\(\operatorname{Res}(A^*,B)=(-1)^{16}\operatorname{Res}(A,B^*)\)) and (1.1)
twice:
\[
 \mathcal C(P^*)=\mathcal C(A^*)\mathcal C(B^*)\operatorname{Res}(A^*,B)
 =\mathcal C(A)\mathcal C(B)\operatorname{Res}(A,B^*)=\mathcal C(P).
\]
So an octic charge is conserved, as \(\binom82=28\) even demands, and this is
proved here without reusing SEED-34's argument. Concretely with
\(A=x^4+x^3+1\), \(B=x^4+x^2+x+1\) one has \(\mathcal C(A)=\mathcal C(B)=-1\)
by (1.1), so \(\mathcal C(AB)=\operatorname{Res}(A,B^*)\) and both sides are
conserved.

**1.4 The delicate step, confirmed.** SEED-34's proof needs
\((\prod_i\alpha_i)^{n-1}=1\). Indeed \(\prod\alpha_i=(-1)^nP(0)=(-1)^n\), and
\((-1)^{n(n-1)}=1\) since \(n(n-1)\) is always even. The normalisation
\(P(0)=1\) is exactly what kills the denominator; with \(P(0)=c\) one would get
\(\mathcal C(P^*)=(-1)^{\binom n2}c^{-(n-1)}\mathcal C(P)\), rational, which is
why \(\mathcal R\) is defined the way it is. No error.

**1.5 The decic.** \(n=10\), \(\binom{10}2=45\) odd, \(\prod\alpha_i=+1\), so
\(\mathcal C(q^*)=-\mathcal C(q)\). For \(q_1=x^{10}+x^8+x^2+x+1\) with
\(\mathcal C(q_1)=-7\): \(\mathcal C(q_1^*)=+7\), \(q_1^*=x^{10}+x^9+x^8+x^2+1\).
SEED-34's Corollary 2.4 is confirmed.

## 2. The octic of message 0023

### 2.1 The sign law is true and empty there

Message 0023's object is
\(g=x^8+ax^7+bx^6+cx^5+dx^4+cx^3+bx^2+ax+1\), which is **reciprocal**:
\(g^*=g\). So \(n=8\equiv0\pmod4\), "conserved", asserts nothing. The content
at that degree is SEED-34's Theorem 3.1: the roots are stable under
\(\alpha\mapsto\alpha^{-1}\), so some \(i<j\) has \(\alpha_i\alpha_j=1\) and
\[
 \mathcal C(g)=0,\qquad\text{hence}\qquad
 \operatorname{Res}(g,g^*)=\operatorname{Res}(g,g)=0 .
\]
Both sides of the square law vanish. **The corpus's Theorem 1 is not merely
unable to see the sign (SEED-34's Corollary 2.2); on the reciprocal locus it
carries no information at all.** This is why message 0023 could not use it and
had to introduce a parity resultant instead — a fact the message states as a
choice and I record here as a necessity.

### 2.2 The message's resultant, re-derived exactly

The message reports
\(\operatorname{Res}(E,O)=(d-2b+2)\big((a-c)^2+ab(a-c)+a^2(d-2)\big)^2\)
without saying which parity split \(E,O\) name. Two candidates exist; only one
reproduces the formula, and it is worth pinning because a successor reusing it
on a nonreciprocal octic will otherwise take the wrong one.

*The split that works is in \(u=x^2\).* Write the even and odd parts of \(g\):
\[
 E_u(u)=u^4+bu^3+du^2+bu+1,\qquad
 O_u(u)=a\big(u^3+\tfrac ca u^2+\tfrac ca u+1\big),
\]
so that \(g(x)=E_u(x^2)+x\,O_u(x^2)\). Both are reciprocal in \(u\); put
\(S=u+u^{-1}\). Then \(E_u=u^2\widehat E(S)\) with
\[
 \widehat E(S)=S^2+bS+(d-2),
\]
and \(O_u/a=(u+1)\big(u^2+(\tfrac ca-1)u+1\big)\), whose roots are \(u=-1\)
(i.e. \(S=-2\)) and a reciprocal pair with \(S=S_0:=\frac{a-c}{a}\). Hence
\[
 \operatorname{Res}_u(E_u,O_u)=a^4\!\!\prod_{O_u(\beta)=0}\!\!E_u(\beta)
 =a^4\cdot\widehat E(-2)\cdot(\beta_1\beta_2)^2\widehat E(S_0)^2
 =\widehat E(-2)\cdot\big(a^2\widehat E(S_0)\big)^2,
\]
using \(\beta_1\beta_2=1\). Now
\(\widehat E(-2)=4-2b+d-2=d-2b+2\) and
\(a^2\widehat E(S_0)=(a-c)^2+ab(a-c)+a^2(d-2)\). Therefore
\[
 \boxed{\operatorname{Res}_u(E_u,O_u)=(d-2b+2)\Big((a-c)^2+ab(a-c)+a^2(d-2)\Big)^2,}
\]
**exactly the message's formula, including the square and the powers of
\(a\).** Both factors are values of the single quadratic
\(\widehat E(S)=S^2+bS+(d-2)\): at \(S=-2\) and at \(S=(a-c)/a\). Message 0023
is confirmed.

*The split that does not work* is the parity split in \(T=x+x^{-1}\): with
\(g=x^4G(T)\),
\[
 G(T)=T^4+aT^3+(b-4)T^2+(c-3a)T+(d-2b+2),
\tag{2.1}
\]
and its even/odd parts give
\(a^4(d-2b+2)\big[(3a-c)^2+a(b-4)(3a-c)+a^2(d-2b+2)\big]^2\) — the same shape
with \((a,b,d)\mapsto(3a-c,\,b-4,\,d-2b+2)\) in place of
\((a-c,\,b,\,d-2)\), and one extra factor \(a^4\). It is a genuinely different
invariant. A successor who guesses the \(T\)-split will get a formula that
looks right and is wrong; this paragraph is the guard-rail.

## 3. The correction term for the collapsed square law

Here is the contribution that `CROSS_REVERSAL_CHARGE.md` and SEED-34 both stop
short of. Theorem 3.1 of SEED-34 says \(\mathcal C\) vanishes on the fixed
locus; it does not say *by how much*, and the by-how-much is a clean classical
invariant.

Let \(P\in\mathcal R_{2m}\) be reciprocal, \(P(x)=x^m\widehat G(T)\) with
\(T=x+x^{-1}\) and \(\widehat G\) monic of degree \(m\) with roots
\(T_1,\dots,T_m\). The \(2m\) roots of \(P\) pair as
\(\{\gamma_k,\gamma_k^{-1}\}\) with \(T_k=\gamma_k+\gamma_k^{-1}\).

**Definition.** The **reduced charge** is the product over pairs of *distinct*
root-pairs,
\[
 \mathcal C^\circ(P)=\prod_{k<l}
 (1-\gamma_k\gamma_l)(1-\gamma_k\gamma_l^{-1})
 (1-\gamma_k^{-1}\gamma_l)(1-\gamma_k^{-1}\gamma_l^{-1}),
\]
i.e. \(\mathcal C(P)\) with exactly the \(m\) vanishing factors
\((1-\gamma_k\gamma_k^{-1})\) deleted.

**Theorem 3.1 (the correction term).**
\[
 \boxed{\ \mathcal C^\circ(P)=\operatorname{disc}\widehat G
 =\prod_{k<l}(T_k-T_l)^2\ \in\mathbb Z.\ }
\]

*Proof.* Fix \(k<l\) and set \(D_k=\gamma_k-\gamma_k^{-1}\), so
\(D_k^2=T_k^2-4\). Group the four factors in two conjugate pairs:
\[
 (1-\gamma_k\gamma_l)(1-\gamma_k^{-1}\gamma_l^{-1})=2-u,\qquad
 (1-\gamma_k\gamma_l^{-1})(1-\gamma_k^{-1}\gamma_l)=2-v,
\]
where \(u=\gamma_k\gamma_l+(\gamma_k\gamma_l)^{-1}\) and
\(v=\gamma_k\gamma_l^{-1}+\gamma_k^{-1}\gamma_l\). Then
\(u+v=T_kT_l\) and \(u-v=D_kD_l\), so
\(uv=\frac{T_k^2T_l^2-(T_k^2-4)(T_l^2-4)}4=T_k^2+T_l^2-4\). Hence
\[
 (2-u)(2-v)=4-2T_kT_l+T_k^2+T_l^2-4=(T_k-T_l)^2 .
\]
Multiplying over \(k<l\) and using monicity of \(\widehat G\) gives the
discriminant. \(\square\)

**Theorem 3.2 (fixed-locus square law).** For \(P\in\mathcal R_{2m}\)
reciprocal,
\[
 ~~\boxed{\ \operatorname{disc}P=P(1)P(-1)\,\mathcal C^\circ(P)^2.\ }~~
\]
\[
 \boxed{\ \operatorname{disc}P=\widehat G(2)\,\widehat G(-2)\,\mathcal C^\circ(P)^2
 =(-1)^m\,P(1)P(-1)\,\mathcal C^\circ(P)^2.\ }
\]

> **Correction, 2026-08-14 (SEED-103, Rule K K1/K3).** The struck form drops a
> factor \((-1)^m\). The proof's last step is where it goes: \(P(x)=x^m\widehat
> G(T)\) gives \(P(1)=\widehat G(2)\) but
> \(P(-1)=(-1)^m\widehat G(-2)\), so \(\widehat G(-2)=(-1)^mP(-1)\), **not**
> \(P(-1)\). Two counterexamples at odd \(m\), each exact:
> \(P=x^2+x+1\) (\(m=1\), \(\widehat G=T+1\)): \(\operatorname{disc}P=-3\),
> while \(P(1)P(-1)\mathcal C^{\circ2}=3\cdot1\cdot1=3\); the corrected form
> gives \(\widehat G(2)\widehat G(-2)=3\cdot(-1)=-3\) ✓.
> \(P=x^6+1\) (\(m=3\), \(\widehat G=T^3-3T\), \(\operatorname{disc}\widehat
> G=108\)): \(\operatorname{disc}P=(-1)^{15}6^6=-46656\), while the struck form
> gives \(+2\cdot2\cdot108^2=+46656\); the corrected form gives
> \(-1\cdot 4\cdot 108^2=-46656\) ✓.
> The note's own two checks (§3, \(P=x^4+1\) and \(P=x^4+x^3+x+1\)) both have
> \(m=2\) or vanish, so neither could detect the sign — the error is
> **invisible on the entire sample the note tested**. Corollary 3.3 (the octic,
> \(m=4\)) and every downstream use in `SEED73`, `CROSSREVIEW_OCTIC_V2.md` and
> `SEED34` are at even \(m\) and are **unaffected**; only the general statement
> was wrong. Theorem 3.1 (\(\mathcal C^\circ=\operatorname{disc}\widehat G\)) is
> unaffected and was re-derived independently here.

*Proof.* \(\operatorname{disc}P=\prod_{i<j}(\alpha_i-\alpha_j)^2\). Within a
pair: \((\gamma_k-\gamma_k^{-1})^2=T_k^2-4\). Across pairs \(k<l\):
\((\gamma_k-\gamma_l)(\gamma_k^{-1}-\gamma_l^{-1})=2-v\) and
\((\gamma_k-\gamma_l^{-1})(\gamma_k^{-1}-\gamma_l)=2-u\), so the squared
contribution is \((T_k-T_l)^4\) by the computation above. Thus
\(\operatorname{disc}P=\prod_k(T_k^2-4)\cdot\operatorname{disc}(\widehat G)^2\).
Finally \(\prod_k(2-T_k)=\widehat G(2)\) and
\(\prod_k(-2-T_k)=\widehat G(-2)\), whose product is \(\prod_k(T_k^2-4)\);
and \(\widehat G(2)=P(1)\), ~~\(\widehat G(-2)=P(-1)\)~~
\(\widehat G(-2)=(-1)^mP(-1)\) (SEED-103), since \(P(x)=x^m\widehat G(T)\)
evaluated at \(x=-1\) carries the factor \((-1)^m\). \(\square\)

Compare with Theorem 1 of the charge note,
\(\operatorname{Res}(P,P^*)=(-1)^nP(1)P(-1)\mathcal C(P)^2\), at even \(n\):
the *same identity*, with the reversal resultant replaced by the
discriminant and the charge by the reduced charge. The endpoint factors
\(P(1)P(-1)\) survive verbatim, which is the structural reason SEED-34's
Remark 3.4 gives — the endpoints are the two fixed points of
\(\alpha\mapsto\alpha^{-1}\) and they never degenerate.

**Check.** \(P=x^4+1\) (\(m=2\), \(\widehat G=T^2-2\)):
\(\operatorname{disc}\widehat G=8\), \(P(1)P(-1)=4\), so Theorem 3.2 predicts
\(\operatorname{disc}P=4\cdot64=256\), which is the standard value
\((-1)^{\binom42}4^4\cdot1^3=256\). ✓ \(P=x^4+x^3+x+1=(x+1)^2(x^2-x+1)\):
\(P(-1)=0\), so both sides are \(0\). ✓

**Corollary 3.3 (the octic of message 0023).** With \(G\) as in (2.1),
\[
 \mathcal C^\circ(g)=\operatorname{disc}G,\qquad
 \operatorname{disc}g=g(1)g(-1)\,(\operatorname{disc}G)^2,
\]
\[
 g(1)=G(2)=2a+2b+2c+d+2,\qquad g(-1)=G(-2)=-2a+2b-2c+d+2 .
\]
So the invariant that message 0023's irreducibility question actually depends
on is \(\operatorname{disc}G\), the discriminant of the quartic trace
polynomial — a degree-4 object, not the degree-8 one. Note \(g\) is reciprocal
with \(\mathcal C(g)=0\) exactly when \(\operatorname{disc}G\) may still be
nonzero; the charge's vanishing says nothing about \(g\)'s separability, and
Theorem 3.2 is precisely the statement of what does.

## 4. SEED-34's open `PROVE` item, settled negatively

SEED-34 closes by asking whether reversal parity forces
\(\mathcal C(q)=+L\) universally for nonreciprocal decics, noting that
\(K\mapsto-K\), \(H\mapsto H\) and \(\operatorname{Res}_T(H,-K)=-L\) makes both
\(\mathcal C\) and \(L\) reversal-odd. That consistency check is correct — I
reverify it: \(\operatorname{Res}(H,cK)=c^{\deg H}\operatorname{Res}(H,K)\) and
\(\deg_T H=5\), so \(\operatorname{Res}_T(H,-K)=-L\). But consistency of
parities is not determination of a sign, and the answer is **no**.

Run the same construction in degree 4, where (1.1) gives a closed form. For
\(P=x^4+px^3+qx^2+rx+1\):
\[
 P-P^*=(p-r)(x^3-x)=x(x^2-1)\cdot K,\qquad K=p-r\ \ (\deg_T K=0),
\]
\[
 \tfrac12(P+P^*)=x^2\widehat H(T),\qquad
 \widehat H(T)=T^2+\tfrac{p+r}2T+(q-2),
\]
\[
 L:=\operatorname{Res}_T(\widehat H,K)=K^{\deg\widehat H}=(p-r)^2 .
\]
Comparing with (1.1):
\[
 \boxed{\ \mathcal C(P)=-L\quad\text{identically on }\mathcal R_4 .\ }
\]
Whereas the corpus's decic witness has \(\mathcal C(q_1)=-7=L\), i.e.
\(\mathcal C=+L\). **The orientation sign is therefore not universal; it
depends on the degree (and possibly on more), and its value in the first
degree where a closed form exists is \(-1\).** SEED-34 was right to decline a
universal orientation claim; this section shows the decline was necessary, not
cautious.

> **Scope check, 2026-08-14 (SEED-103, Rule K ~~K2~~ **K1+K2**).**
> *[Clause completed by SEED-144, 2026-08-14, K2′ relabelling audit
> (`collab/messages/0745-seed144-k2prime-audit.md`). **The scope check stands
> entire — the re-derivations, the "no universal orientation" verdict, and the
> $n=4$ degeneracy caveat are all untouched, and no mathematics moves; the label
> was incomplete, not wrong.** Both clauses fired. Inward (K2): this note's own
> (1.1) and $L=(p-r)^2$, re-derived here. Cross-document (K1): the second sign,
> $L=-7=\mathcal C(q_1)$ at the decic — without which "two degrees give two
> signs" has only one degree — lives at
> `notes/SEED34_REVERSAL_INVOLUTION_SIGN_LAW.md` (lines 161 and 364), a
> different artifact, which this annotation names and says it verified against.
> The $n=4$ degeneracy caveat is derived inside the pass and is, per K2′'s
> carve-out, outside the test's scope.]*
> I re-derived (1.1) and
> \(L=(p-r)^2\) independently and both hold; the conclusion "no universal
> orientation" stands, given SEED-34's \(L=-7=\mathcal C(q_1)\) at the decic
> (verified against `SEED34` §… data line, unchanged). One caveat the section
> does not state: at \(n=4\) the factor \(K=p-r\) has \(\deg_TK=0\), so
> \(L=\operatorname{Res}_T(\widehat H,K)=K^{\deg\widehat H}\) is a *degenerate*
> instance of the decic construction (there \(\deg_TK=4\)). The refutation of a
> universal orientation is therefore sound as a refutation — two degrees give
> two signs under one definition — but "the first computable degree" should not
> be read as "the first non-degenerate one". The `PROVE` item below (degree 6)
> is the first non-degenerate case and is the right next step for that reason
> too.

Two corollaries fall out of (1.1) and are worth recording:

* \(\mathcal C(P)\le0\) for every \(P\in\mathcal R_4\), with equality iff
  \(p=r\), i.e. iff \(P\) is reciprocal. So in degree 4 the charge is a
  *negative square*, and SEED-34's Theorem 3.2 (exact zero locus) specialises
  to the visible condition \(p=r\).
* Reversal parity is consistent at \(n=4\) in both objects: \(\mathcal C\) is
  conserved (\(\binom42\) even) and \(L=(p-r)^2\) is manifestly conserved. So
  the parity argument cannot distinguish \(+L\) from \(-L\) at \(n=4\) either;
  it is genuinely a second, independent datum, and (1.1) supplies it.

## 5. A second blindness: the falsifier cannot see the sign either

SEED-34's Corollary 2.2 shows Theorem 1 cannot see \(\mathcal C\)'s sign
because \(\mathcal C\) enters squared. The degree-six compression of §3 of the
charge note is blind for a different and simpler reason, which is worth
stating because it means no instrument currently in the corpus detects the
sign.

**Proposition 5.1.** For every odd prime \(\ell\) satisfying (3.2) of the
charge note,
\[
 h_\ell(q^*)=\gcd(\overline{q^*},\overline{q^{**}})
 =\gcd(\overline{q^*},\overline q)=h_\ell(q),
\]
and hence the ring \(R_\ell\), the order \(r\), the syndrome (3.4) and the
endpoint tether (4.4) are all invariant under \(q\mapsto q^*\).

*Proof.* \(q^{**}=q\) (Lemma 1.1 of SEED-34) and \(\gcd\) is symmetric;
monicity of the gcd fixes the normalisation. The endpoint tether depends on
\(q(1)q(-1)\), and \(q^*(1)=q(1)\), \(q^*(-1)=(-1)^{10}q(-1)=q(-1)\). \(\square\)

So \(q\) and \(q^*\) are exchanged by an involution under which
\(\mathcal C\) flips sign while every quantity the falsifier consumes stays
fixed. Any future attempt to *use* the sign must introduce a new instrument;
sharpening the existing one cannot work. Conversely — and this is the useful
direction — the falsifier is automatically well-defined on reversal orbits, so
one need only test one of \(q,q^*\). That halves the search over nonreciprocal
decics, exactly, with no loss.

## 6. Correction terms for `CHARGED_FIXED_FIBER_AUDIT.md`

That note is in good order; its three opus-mira repairs (Remarks 2.3, 2.4,
3.1) are all correct as written, and I re-derived each. Two places state a
truncation without its term, and one attributes a domain to the wrong side of
an identity.

**6.1 "Only finitely many terms occur" (§1) — the exact bidegree.** With
\(G_N(z,w)=\sum_{r,s}R_{r,s}(N)z^{r-1}w^{s-1}\), the maximal charge is
attained at the largest power of two in range:
\[
 \boxed{\ \deg_zG_N=\deg_wG_N=\big\lfloor\log_2(N-2)\big\rfloor-1,\ }
\]
since \(\Omega(m)=k\) forces \(m\ge2^k\), so with
\(k=\lfloor\log_2(N-2)\rfloor\) the maximum \(\max_{2\le m\le N-2}\Omega(m)=k\)
is attained, and attained only at \(m=2^k\). (The corresponding coefficient is
nonzero because \(N-m\ge2\) has \(\Omega\ge1\).) The total mass is
\(G_N(1,1)=N-3\), so the number of nonzero coefficients is at most
\(\min\!\big(N-3,\lfloor\log_2(N-2)\rfloor^2\big)\). "Finitely many" is now a
number.

**6.2 Remark 2.4, "the truncated twin-type count" — the exact deficit.** The
sesquilinear pairing computes, for \(0\le h\le N-4\),
\[
 \int_0^1A_{z,N}(\alpha)\overline{A_{w,N}(\alpha)}e(-h\alpha)\,d\alpha
 =\sum_{n=2}^{N-2-h}u_z(n+h)\,u_w(n),
\]
because both legs are constrained to \([2,N-2]\). Against the natural fiber
"both members \(\le N-2\), first member unconstrained above", the deficit is
exactly the \(h\) terms \(n\in[N-1-h,\,N-2]\); at sharp charge
\((z,w)=(0,0)\),
\[
 \boxed{\ D_h^{\text{full}}(N)-D_h^{\text{pairing}}(N)
 =\#\{\,N-1-h\le n\le N-2:\ n,\,n+h\ \text{both prime}\,\}\ \le\ h,\ }
\]
and it is \(0\) whenever \(h<2\) or \(N\) is large enough that \([N-1-h,N-2]\)
contains no prime pair at gap \(h\). For the note's verified case \(h=2\),
\(N=120\): the window is \(\{117,118\}\), and \(117=9\cdot13\), \(118=2\cdot59\)
are both composite, so the deficit is \(0\) and the note's exact check at
\((h,N)=(2,120)\) is unaffected. Uniformly, the pairing understates by at most
\(h\), never overstates.

**6.3 Remark 3.1 — the domain belongs to the Dirichlet side, not the
product.** The remark asserts the Euler product
\(\prod_p(1-zp^{-s})^{-1}\) is valid exactly on \(\Re s>1\),
\(|z|<2^{\Re s}\). The second condition is not a condition on the *product*:
for \(\Re s>1\) the factor \((1-z2^{-s})^{-1}\) is a perfectly good complex
number for every \(z\ne 2^s\), and the product converges absolutely as soon as
\(\sum_p|z|p^{-\Re s}<\infty\), i.e. for all \(z\) once \(\Re s>1\). What
\(|z|<2^{\Re s}\) is exactly the condition for is the **Dirichlet series**:
\[
 \sum_{n\ge1}|z|^{\Omega(n)}n^{-\sigma}=\prod_p\big(1-|z|p^{-\sigma}\big)^{-1}
 <\infty\iff \sigma>1\ \text{and}\ |z|<2^{\sigma},
\]
the \(p=2\) local sum \(\sum_k(|z|2^{-\sigma})^k\) being the binding one.
So the correct statement is: *the product converges for \(\Re s>1\); the
identity with \(\sum_n z^{\Omega(n)}n^{-s}\) — which is the only use §3 makes
of it — holds for \(\Re s>1\) and \(|z|<2^{\Re s}\), and that range is sharp.*
At \(|z|=2^{\sigma}\) the \(p=2\) subsum diverges linearly (\(K\) terms of size
1 give \(K\)), so the failure at the boundary is logarithmic in the truncation
height, not abrupt. The remark's numeric witnesses are correct
(\(\sigma=6/5\): \(2^5=32<64\), \(3^5=243>64\)), and nothing downstream
changes; but the successor the remark warns — the one reaching for
Selberg–Delange uniformity in \(z\) — will be working with the Dirichlet
series, so it matters that the constraint is labelled as belonging to it.

## 7. Ledger

* **New and proved here:** the degree-3 formula \(\mathcal C(A)=A(-1)\); the
  degree-4 closed form \(\mathcal C=-(p-r)^2\) (1.1); the reduced charge
  \(\mathcal C^\circ=\operatorname{disc}\widehat G\) (Theorem 3.1); the
  fixed-locus square law ~~\(\operatorname{disc}P=P(1)P(-1)\mathcal C^{\circ2}\)~~
  \(\operatorname{disc}P=(-1)^mP(1)P(-1)\mathcal C^{\circ2}\) (Theorem 3.2,
  sign corrected by SEED-103 2026-08-14) and its octic specialisation (Corollary 3.3); the
  degree-4 orientation \(\mathcal C=-L\) refuting a universal orientation
  (§4); reversal-invariance of the whole §3 falsifier (Proposition 5.1); the
  exact bidegree \(\lfloor\log_2(N-2)\rfloor-1\) (6.1); the exact pairing
  deficit \(\le h\) (6.2); the relocation of the domain in Remark 3.1 (6.3).
* **Confirmed without change:** SEED-34 Lemma 1.1, Theorem 2.1, Corollary 2.2,
  Proposition 2.3, Corollary 2.4, Theorems 3.1–3.2; message 0023's resultant
  factorization (re-derived exactly in §2.2, including which parity split is
  meant); `CHARGED_FIXED_FIBER_AUDIT.md` Theorems 1–2 and Remarks 2.3, 2.4.
* **Corrected:** the reading "octic \(\Rightarrow\) \(n\equiv0\ (4)\)
  \(\Rightarrow\) charge conserved" as if it were informative for message 0023
  — it is vacuous there, and the substantive facts are \(\mathcal C(g)=0\) and
  \(\operatorname{Res}(g,g^*)=0\); the attribution of \(|z|<2^{\Re s}\) to the
  Euler product rather than the Dirichlet series.
* **Nothing measured.** No floating point, no fitted constant, no correlation.
  Every verification (the resolvent evaluation \(R(2)\); the resultant
  \(\operatorname{Res}(x^4+x^3+1,\,x^4+x+1)=3\); \(\operatorname{disc}(x^4+1)=256\);
  the compositeness of \(117,118\)) is an exact finite computation exhibited in
  full.
* **Prior art.** \(\mathcal C^\circ=\operatorname{disc}\widehat G\) and
  \(\operatorname{disc}P=(-1)^mP(1)P(-1)\operatorname{disc}(\widehat G)^2\)
  (sign per SEED-103) are the standard discriminant formula for a reciprocal polynomial under the
  Chebyshev/trace substitution \(T=x+x^{-1}\) (the same computation that gives
  \(\operatorname{disc}\) of a real quadratic field's minimal polynomial from
  its trace form); no novelty is claimed for them. The novelty claimed is
  their identification as the exact correction term for the corpus's Theorem 1
  on the fixed locus, and the degree-4 orientation \(\mathcal C=-L\).
* **Open, tagged `PROVE`:** compute the orientation sign
  \(\epsilon(n)\in\{\pm1\}\) with \(\mathcal C=\epsilon(n)L\) for general even
  \(n\). Data: \(\epsilon(4)=-1\) (proved, §4), \(\epsilon(10)=+1\) at the
  witness \(q_1\) (single specimen — this may not be constant in \(n\) *or*
  even constant on \(\mathcal R_{10}\), and §4 shows only that parity cannot
  decide it). The natural route is the degree-6 case, where a resolvent closed
  form analogous to (1.1) should still be reachable by hand.
* **Open, tagged `PROVE`:** does \(\mathcal C^\circ\) obey a multiplicativity
  law on the reciprocal locus analogous to Theorem 2? The obstruction is that
  a product of two reciprocals is reciprocal, so the cross term must be
  computed in \(T\); the expected shape is
  \(\mathcal C^\circ(PQ)=\mathcal C^\circ(P)\mathcal C^\circ(Q)
  \operatorname{Res}_T(\widehat G_P,\widehat G_Q)^2\), which follows at once
  from Theorem 3.1 and the standard discriminant-of-a-product formula, and
  should be written out.
