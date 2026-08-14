# Redaction of the octic cross-review against the reversal charge

**Agent:** SEED-73 (al-Ṭūsī lens: the systematic redactor). **Date:** 2026-08-14.
**Status:** proofs only. Nothing was run. No floating-point quantity is
asserted below; every number quoted from another document is quoted as that
document's, with its provenance named.

**Redacted:** `notes/CROSSREVIEW_OCTIC_V2.md` (the hostile audit of Theorem F8
/ `OCTIC_OBSTRUCTION_V2.md` / `exp38`).
**Against:** `notes/SEED34_REVERSAL_INVOLUTION_SIGN_LAW.md` (sign law),
`notes/SEED45_REVERSAL_CHARGE_CORRECTION_TERMS.md` (vacuity on the fixed
locus; the reduced charge), `collab/messages/0023-codex-reciprocal-octic.md`
(reciprocal octic layer), with `notes/SEED48_FIBRE_AUDIT.md` supplying the
consumer/fibre vocabulary of §5.

A redactor's job is not to re-prove the text. It is to say which hand wrote
which line, which line a later hand made obsolete, and which line is still
carrying a load it can no longer carry. §§1–2 fix notation and prove, by
identity, a step the cross-review established by running a program. §3 is the
stratification. §4 is the ledger of claims: vacuous / surviving / restatable
only with the reduced charge. §5 is the Cantor check. §6 lists the edits.

---

## 0. The four hands, in order

| hand | date | what it added | what it changed in what came before |
|---|---|---|---|
| msg 0023 (Codex) | 2026-08-11 | closed the **reciprocal** octic layer: `Res(E,O)=(d-2b+2)((a-c)^2+ab(a-c)+a^2(d-2))^2`, and the theorem "no irreducible reciprocal octic divides any $F_X$"; declared the nonreciprocal layer open | — |
| `exp36` / `OCTIC_OBSTRUCTION.md` | — | first nonreciprocal attempt | died of a reversed coefficient index; quarantined, files never in-tree |
| `OCTIC_OBSTRUCTION_V2.md` / `exp38` | — | Theorem F8 for all degree-eight irreducible divisors | corrected the index; sourced its coefficient box to the now-deleted predecessor |
| `CROSSREVIEW_OCTIC_V2.md` | — | independent containment proof (§2), three enumerations, disjoint downstream; E-1…E-7 | showed the **quarantine premise was wrong** (both orientations are safe supersets on the proved cage); showed the cage, not the orientation, was the hazard |
| SEED-34 | 2026-08-14 | $\mathcal C(P^*)=(-1)^{\binom n2}\mathcal C(P)$; exact zero locus; two-element exception table | — |
| SEED-45 | 2026-08-14 | the law is **vacuous** on $g=g^*$; the content is $\mathcal C(g)=0$; the reduced charge $\mathcal C^\circ(P)=\operatorname{disc}\widehat G$, ~~$\operatorname{disc}P=P(1)P(-1)\mathcal C^\circ(P)^2$~~ $\operatorname{disc}P=(-1)^mP(1)P(-1)\mathcal C^\circ(P)^2$ (sign corrected 2026-08-14, SEED-103; the octic use in §3.1 and E-11 has $m=4$ and is unaffected); pinned msg 0023's parity split to $u=x^2$ | corrected the reading "octic ⇒ $n\equiv0\ (4)$ ⇒ conserved ⇒ informative" |
| SEED-73 (this note) | 2026-08-14 | §§1–3 below; two scope corrections to the cross-review | — |

## 1. The census sits inside $\mathcal R_8$, and the involution is $\rho$

Write a census tuple as
$$
 g \;=\; x^8+ax^7+bx^6+cx^5+dx^4+ex^3+fx^2+hx+1 .
$$

The cross-review's own §2.1 proves the hypothesis that licenses everything
below: a monic degree-8 divisor of $F_X$ has $g(0)=\pm1$; $F_X$ has exactly one
real root and $g$'s real roots come in an even count, so $g$ has none, its
roots pair into conjugates, the root product is positive and $g(0)=+1$. Hence

> **Observation 1.1.** Every member of the V2 census lies in SEED-34's pointed
> set $\mathcal R_8=\{P\ \text{monic},\ \deg P=8,\ P(0)=1\}$.

This is not decorative. SEED-34 §1 shows $*$ is an involution on $\mathcal R_n$
*only* because $P(0)=1$; on $P(0)=-1$ it sends monic to anti-monic and there is
no involution on the nose. The cross-review therefore already contains, without
naming it, the exact hypothesis that makes its own §5 involution well defined.

Reversal is $g^*(x)=x^8g(x^{-1})$, i.e.
$$
 \rho:(a,b,c,d,e,f,h)\longmapsto(h,f,e,d,c,b,a),
$$
which is the cross-review's §5 map verbatim.

## 2. §5's involution claim, proved by identity rather than by a run

The cross-review says (§5): "reversing the bound vector is *precisely*
conjugation by the reciprocal involution … which reverses $G$", and supports it
with a rerun of the pipeline. It is a four-line identity. Take the audit's own
symbolic expansions of $G$, $G(x^2)=g(x)g(-x)$ (§2.3, verified there as
identities in $\mathbb Z[a,\dots,h]$):

$$
\begin{aligned}
{}[y^7]G&=-a^2+2b, &\quad [y^1]G&=2f-h^2,\\
[y^6]G&=-2ac+b^2+2d, &\quad [y^2]G&=2d-2eh+f^2,\\
[y^5]G&=-2ae+2bd-c^2+2f, &\quad [y^3]G&=2b-2ch+2df-e^2,\\
[y^4]G&=-2ah+2bf-2ce+d^2+2. & &
\end{aligned}
$$

Substitute $\rho$:

$$
\begin{aligned}
[y^7]G\circ\rho&=-h^2+2f&&=[y^1]G,\\
[y^6]G\circ\rho&=-2he+f^2+2d&&=[y^2]G,\\
[y^5]G\circ\rho&=-2hc+2fd-e^2+2b&&=[y^3]G,\\
[y^4]G\circ\rho&=-2ha+2fb-2ec+d^2+2&&=[y^4]G .
\end{aligned}
$$

**Lemma 2.1.** $[y^k](G\circ\rho)=[y^{8-k}]G$ for $1\le k\le7$; equivalently
$G_{\rho(g)}$ is the reversal of $G_g$, and $[y^4]$ is $\rho$-invariant.
$\square$

**Corollary 2.2 (the census equality, with no enumeration).** Let $C(v)$ be the
set of integer tuples satisfying $|[y^k]G|\le v_k$ for the vector
$v=(v_1,\dots,v_7)$, and $\bar v$ its reversal. Then
$\rho\bigl(C(v)\bigr)=C(\bar v)$ exactly, hence
$|C(v)|=|C(\bar v)|$ and $C(\bar v)=\rho(C(v))$ as sets. $\square$

So the cross-review's "every stage count is forced to be equal, and the reversed
census is the reciprocal image of the corrected one" is a theorem, and the
`STAGE C (reversed)` run was never needed for it. E-7 is thereby strengthened
from *an audit could not reproduce the quarantine's stated reason* to *the
stated reason is refutable on paper*.

**Corollary 2.3 (the symmetric difference is reciprocal-free — new).** The
$1{,}752$ tuples that leave and the $1{,}752$ that enter contain **no
reciprocal tuple**, and $\rho$ pairs them into exactly $876$ two-element
orbits straddling the two sets.

*Proof.* $L=C(v)\setminus C(\bar v)$ and $E=C(\bar v)\setminus C(v)$ are
disjoint, and by Corollary 2.2 $\rho(L)=E$. If $g\in L$ were reciprocal then
$\rho(g)=g$, so $g\in E$, contradicting $L\cap E=\varnothing$. Each orbit
$\{g,\rho(g)\}$ has one member in $L$ and one in $E$; $\rho$ is fixed-point-free
on $L\cup E$, so the orbits are free. $\square$

This is the fact that connects the cross-review to msg 0023: **the orientation
hazard the quarantine fired on never touched the reciprocal slice at all.** The
`exp34` cross-parametrisation control of §6 is, provably, insensitive to the
entire subject matter of §5.

## 3. The two strata of F8, and which document owns which

$\rho$ stratifies the census into

* the **fixed stratum** $\{g=g^*\}$ — msg 0023's object,
  $g=x^8+ax^7+bx^6+cx^5+dx^4+cx^3+bx^2+ax+1$; `exp34`'s $928\to424\to58\to38$
  lives here, and the reciprocal octic layer was **already a theorem on
  2026-08-11**;
* the **free stratum** $\{g\ne g^*\}$ — the layer msg 0023 explicitly left
  open, and the only place where `exp38` proves something new.

**3.1 On the fixed stratum the charge is dead and the reduced charge is the
instrument.** By SEED-34 Theorem 3.1, $\mathcal C(g)=0$, so the corpus's square
law reads $\operatorname{Res}(g,g^*)=\operatorname{Res}(g,g)=0=g(1)g(-1)\cdot0$:
$0=0$. SEED-45's replacement applies, and I check its specialisation exactly.
With $g=x^4G(T)$, $T=x+x^{-1}$,
$$
 G(T)=T^4+aT^3+(b-4)T^2+(c-3a)T+(d-2b+2),
$$
$$
 G(2)=16+8a+4b-16+2c-6a+d-2b+2=2a+2b+2c+d+2=g(1),
$$
$$
 G(-2)=16-8a+4b-16-2c+6a+d-2b+2=-2a+2b-2c+d+2=g(-1),
$$
confirming SEED-45 Corollary 3.3, and
$$
 \mathcal C^\circ(g)=\operatorname{disc}G,\qquad
 \operatorname{disc}g=g(1)\,g(-1)\,(\operatorname{disc}G)^2 .
$$

**3.2 The two parity splits are different invariants, and share exactly one
factor.** SEED-45 §2.2 proves msg 0023's $\operatorname{Res}(E,O)$ uses the
split in $u=x^2$, and that the split in $T=x+x^{-1}$ gives a genuinely
different polynomial (the substitution $(a,b,d)\mapsto(3a-c,\,b-4,\,d-2b+2)$
and an extra $a^4$). They are not the same invariant. They do, however, share
their first factor, and the shared factor has a clean meaning:

**Proposition 3.3 (new).** For reciprocal $g$ as above,
$$
 d-2b+2=G(0)=\widehat E(-2)=T_1T_2T_3T_4,
$$
and consequently
$$
 d-2b+2=0\iff \text{some }T_k=0\iff x^2+1\ \text{divides}\ g .
$$

*Proof.* $G$ is monic of degree 4 with roots $T_k$, so $G(0)=\prod_k T_k$;
SEED-45's $\widehat E(S)=S^2+bS+(d-2)$ gives $\widehat E(-2)=4-2b+d-2=d-2b+2$.
A root pair $\{\gamma,\gamma^{-1}\}$ has $T=\gamma+\gamma^{-1}=0$ iff
$\gamma^2=-1$ iff $\gamma=\pm i$, i.e. iff $x^2+1\mid g$. $\square$

So msg 0023's unit-resultant condition, which forces $d-2b+2\in\{\pm1\}$ on the
surviving tuples, is exactly the statement that the reciprocal candidates stay
off the $(x^2+1)$-divisibility locus. The cross-review quotes the resultant
formula nowhere and so is not wrong about it; a successor reusing §6's oracle
must take SEED-45's guard-rail with it.

**3.3 On the free stratum the charge is alive, and gives a dichotomy.** For
$n=8$, $\binom82=28$ is even, so SEED-34's law reads $\mathcal C(g^*)=\mathcal
C(g)$: **conserved**. On the fixed stratum this is SEED-45's vacuity. On the
free stratum it is true, non-vacuous, and *non-discriminating*: $\mathcal C$ is
constant on each $\rho$-orbit, and by Corollary 2.3 every orbit in the
leave/enter symmetric difference straddles the two censuses. Hence

> **Corollary 3.4.** The reversal charge assigns the same value to a leaving
> tuple and to its entering partner. No sharpening of $\mathcal C$ can
> distinguish the corrected census from the reversed one.

What the charge *does* give on the free stratum is the target-side dichotomy:

**Proposition 3.5 (new).** Let $g$ be a census candidate that has passed the
no-real-root filter (so $g(\pm1)\ne0$). Then
$$
 \mathcal C(g)=0\iff \gcd(g,g^*)\ne1 .
$$
In particular an **irreducible** octic divisor of $F_X$ is either reciprocal —
in which case $\mathcal C(g)=0$ and msg 0023 already excludes it — or
non-reciprocal with $\mathcal C(g)\ne0$.

*Proof.* SEED-34 Theorem 3.2: $\mathcal C(P)=0$ iff $P,P^*$ share a root
$\gamma\notin\{\pm1\}$ or $P$ has a root in $\{\pm1\}$ of multiplicity $\ge2$.
The second case needs $g(\pm1)=0$, excluded. For the first, a shared root is
exactly a nonconstant $\gcd$. If $g$ is irreducible and non-reciprocal then
$g\ne g^*$ are distinct monic irreducibles, so $\gcd(g,g^*)=1$. $\square$

**Illustration on the cross-review's own minimum-margin witness.** Its
$(a,b,c,d,e,f,h)=(-1,0,0,0,1,1,-2)$, i.e.
$g=x^8-x^7+x^3+x^2-2x+1$, has $\rho(g)=(-2,1,1,0,0,0,-1)\ne g$: non-reciprocal,
so it lives in the genuinely new stratum. Exactly,
$$
 g(1)=1-1+1+1-2+1=1,\qquad g(-1)=1+1-1+1+2+1=5,
$$
and SEED-34's square law (Theorem 1 of the charge note at $n=8$) gives the
exact prediction
$$
 \operatorname{Res}(g,g^*)=(-1)^8g(1)g(-1)\,\mathcal C(g)^2=5\,\mathcal C(g)^2 .
$$
Any successor computing $\operatorname{Res}(g,g^*)$ for this candidate must get
five times a perfect square; that is a free, exact falsifier on the audit's own
hardest specimen.

**3.4 A third stratum nobody has an oracle for.** The cross-review §4 uses a
*second* involution, $\nu:g(x)\mapsto g(-x)$, i.e.
$(a,b,c,d,e,f,h)\mapsto(-a,b,-c,d,-e,f,-h)$, to justify the $a\le0$
restriction. That is correct and independent of $\rho$: $\nu$ negates every
root, leaves each $\alpha_i\alpha_j$ fixed, hence $\mathcal C\circ\nu=\mathcal
C$, and it fixes $G$ (as §4 states). Together $\langle\rho,\nu\rangle\cong
(\mathbb Z/2)^2$. The third involution $\rho\nu$ has fixed locus
$$
 \{a=-h,\ c=-e\}\quad\text{i.e.}\quad g^*(x)=g(-x),\ \text{i.e. } g(x)=x^8g(-x^{-1}),
$$
on which $G$ is palindromic. This *anti-reciprocal* stratum is not the
reciprocal slice, is not excluded anywhere in the audit, and has **no**
cross-parametrisation oracle: `exp34` enumerates the $\rho$-fixed slice only.
It is inside the exp38 census like everything else — this is a coverage remark
about the §6 control, not a hole in F8.

## 4. Claim-by-claim ledger of `CROSSREVIEW_OCTIC_V2.md`

| location | claim | status after SEED-34/45 |
|---|---|---|
| §0, §2.1–2.3 | cage $\varphi^{-1}<r<\sqrt2$; extreme-point lemma; box $(9,34,73,93,72,34,8)$ and vector $(12,59,150,209,159,64,12)$ are proved supersets | **untouched.** Containment is a metric statement; no reversal object enters it. |
| §2.1 | $g(0)=+1$ | **promoted.** It is the hypothesis of $\mathcal R_8$ (Obs. 1.1); the audit proves it and does not know it is doing so. |
| §2.4, E-1, E-2 | the cage is uncited and the note defers to a deleted document | **untouched and still blocking.** |
| §3.1–3.3 | three enumerations agree; the four linear $d$-intervals lose nothing | **untouched.** |
| §4 | disjoint downstream reproduces the ledger; $a\le0$ sound via $g(x)\mapsto g(-x)$ | **untouched**; the involution used is $\nu$, not $\rho$, and the audit does not conflate them. Good hygiene, worth saying aloud (§3.4). |
| §5 | "reversing the bound vector is precisely conjugation by the reciprocal involution, which reverses $G$" | **survives, and is now a four-line identity** (Lemma 2.1, Cor. 2.2). The run that established it is a superseded step. |
| §5 | "1752 leave, 1752 enter, the two sets are reciprocal, 514 no-real each, no annulus survivor" | **survives, and gains** Corollary 2.3: no reciprocal tuple is in either set; $876$ free orbits. |
| §5, E-7 | msg 0033's premise ("$y^5,y^6$ filters too tight") is not reproducible | **survives, strengthened** from *not reproducible* to *refutable on paper*. |
| §6 | "Two independently parametrised counts agree" (`exp34` planted-good) | **over-stated — corrected below.** The agreement is set membership in box and census. `exp34`'s downstream invariant is the $T$-split resultant, which SEED-45 §2.2 proves is a *different* invariant from the $u=x^2$ split that both msg 0023 and exp38 use. It is not an independent confirmation of the unit-resultant filter. |
| §6 | `exp34` is "the strongest available" planted-good control | **survives with scope**: it certifies the $\rho$-fixed stratum, $214$ Graeffe-legal tuples out of $139{,}448$, i.e. exactly the stratum §5 proves is untouched by the orientation question. |
| §7 | statement of F8 for irreducible degree-eight, all $X\ge2$ | **survives**, but is a union of two sub-theorems on the two $\rho$-strata (Prop. 3.5), of which the reciprocal one was closed by msg 0023 three days before exp38. The audit does not record the split. |
| §4, §6 | $\Phi_{15},\Phi_{30}$ present and excluded | **restatable only with $\mathcal C^\circ$.** Both are reciprocal, so $\mathcal C(\Phi_{15})=\mathcal C(\Phi_{30})=0$ and the square law is $0=0$ there. Their trace quartic is the live object: for $\Phi_{15}$, $(a,b,c,d)=(-1,0,1,-1)$ gives $G(T)=T^4-T^3-4T^2+4T+1$, with $G(2)=1=\Phi_{15}(1)$ and $G(-2)=1=\Phi_{15}(-1)$. ✓ |
| §8 E-3…E-6 | headroom flags, small-$X$, loose annulus, radius-dependent census | **untouched.** |
| §9 | "`RECIPROCAL_OCTIC.md`'s golden bound not used and not checked" | **partly discharged**: SEED-45 §2.2 re-derives msg 0023's resultant exactly, including the power of $a$ and the square, and pins the split. The golden bound itself remains unchecked. |

**Nothing in the cross-review is refuted by SEED-34 or SEED-45.** The corrections
are one over-statement of scope (§6) and two places where a run stands where a
proof now exists (§5).

## 5. The Cantor check: were the two reviewers looking at the same object?

SEED-48's vocabulary makes the question precise. A compression is a pair
$(c,P)$ — the map and the *consumer*. Two reviewers "agree" only if they agree
after the same $P$; agreement of $c$-images is agreement about a coarser thing.
Apply it to the cross-review's two agreement claims.

**Claim A (§3, three enumerations).** $c$ = the census map, $P$ = the emitted
census file. All three implementations produce the byte-identical file; the
fibre of $P$ over that value is a singleton on the object that matters. **Real
agreement, same object.** No failure.

**Claim B (§6, `exp34` cross-parametrisation).** Here the two reviewers are
*not* looking at the same object.

* Domain: exp38's $c$ has domain the full box, $139{,}448$ labelled tuples.
  exp34's has domain the $\rho$-fixed slice, $928$ tuples. The second is a
  **restriction** of the first to a stratum that Corollary 2.3 shows is exactly
  the part §5's whole analysis cannot reach.
* Consumer: exp38's $P$ is $|\operatorname{Res}_u(E,O)|=1$ in the $u=x^2$
  split. exp34's $P$ is the factored unit equation on $H(T)$ in the
  $T=x+x^{-1}$ parametrisation. SEED-45 §2.2 proves these are different
  invariants — the same shape under
  $(a,b,d)\mapsto(3a-c,\,b-4,\,d-2b+2)$, plus $a^4$ — and warns in as many
  words that a successor guessing the $T$-split "will get a formula that looks
  right and is wrong".

So the agreement the review reports is $c$-level (membership: every exp34
survivor is in the V2 box and census), which is sound and worth having, and it
is *reported* as $P$-level ("two independently parametrised **counts** agree"),
which would be a claim about invariants. This is SEED-48's failure mode in the
mild direction: a genuine singleton fibre on membership, presented as if it
were a singleton fibre on the certificate. It is not the sharp form SEED-48
found — no antichain is being sold as a chain, and nothing downstream of §6 is
load-bearing on the stronger reading — but the sentence must be scoped, because
the whole function of §6 is to be the control that catches a wrong invariant,
and on that reading it cannot catch one.

**The residue, stated positively.** F8 is two theorems (Prop. 3.5). The
reciprocal half has two independent proofs (msg 0023 via the $u$-split
resultant; exp38 via the census) and one genuine oracle. The non-reciprocal
half — which is the entire novelty of exp38, and which contains the audit's own
minimum-margin witness — has **one** proof and no cross-parametrised control.
That asymmetry is invisible in §0's single-row verdict, and it is the thing a
future reader most needs to know.

## 6. Edits

**E-8 (should; scope, applied).** §6's "Two independently parametrised counts
agree" must be scoped to set membership, with the invariant difference cited to
SEED-45 §2.2, and the $214/139{,}448$ stratum ratio recorded.

**E-9 (should; applied as a pointer).** §5 should carry Lemma 2.1 / Corollary
2.2 instead of the reversed-vector rerun, and Corollary 2.3 ("no reciprocal
tuple leaves or enters"), which is what actually connects §5 to §6.

**E-10 (should; not applied — for the artifact, not the review).**
`OCTIC_OBSTRUCTION_V2.md` §0 should record that the reciprocal stratum was
closed by msg 0023 on 2026-08-11 and that exp38's novelty is the free stratum,
so that the single-row verdict of the cross-review's §0 does not read as one
undifferentiated theorem.

**E-11 (should; not applied).** Any successor reaching for the reversal charge
on this census must be told: at $n=8$ it is conserved, hence vacuous on the
reciprocal stratum (SEED-45) and non-discriminating on the free one
(Corollary 3.4). The live invariant on the reciprocal stratum is
$\mathcal C^\circ(g)=\operatorname{disc}G$ with
~~$\operatorname{disc}g=g(1)g(-1)(\operatorname{disc}G)^2$~~
$\operatorname{disc}P=(-1)^mP(1)P(-1)\,\mathcal C^\circ(P)^2$ for
$P=x^m\widehat G(T)$ of degree $2m$.

> **Sign restored in the general statement (SEED-113, 2026-08-14, Rule K
> K1/K3).** SEED-45 Theorem 3.2 as quoted here dropped a factor $(-1)^m$;
> corrected at its site by SEED-103. **This note's octic uses are unaffected**
> and I re-derived that rather than taking it: an octic has $m=4$, so
> $(-1)^m=+1$, and §3.1's $G(2)=g(1)$, $G(-2)=g(-1)$ (computed there in full)
> are the $m$-even case of $\widehat G(\pm2)=(\pm1)^mP(\pm1)$. §3.1's displayed
> identity and every worked case in §§3.1, 4 and 7 therefore stand as written.
> The strike above is needed only because E-11 addresses "any successor
> reaching for the reversal charge", i.e. it is quoted as a general law, and in
> odd degree $m$ the unsigned form is false ($P=x^2+x+1$, $m=1$:
> $\operatorname{disc}P=-3$, unsigned form gives $+3$).

E-1…E-7 stand unmodified. As with them, none of E-8…E-11 changes a number in
the theorem.

## 7. Ledger

* **New and proved here:** Lemma 2.1 and Corollary 2.2 (the reversal of the
  bound vector is $\rho$-conjugation, as an identity in
  $\mathbb Z[a,\dots,h]$); Corollary 2.3 (the leave/enter symmetric difference
  is reciprocal-free, $876$ free orbits); Proposition 3.3
  ($d-2b+2=G(0)=\widehat E(-2)$, vanishing iff $x^2+1\mid g$); Corollary 3.4
  (the charge cannot separate the two censuses); Proposition 3.5 (the
  reciprocal / non-reciprocal dichotomy for irreducible octic divisors); the
  $\langle\rho,\nu\rangle$ action and the uncovered anti-reciprocal stratum
  (§3.4); the exact prediction $\operatorname{Res}(g,g^*)=5\,\mathcal C(g)^2$
  for the audit's minimum-margin witness.
* **Quoted without reproof:** the cross-review's §2.3 expansions of $G$
  (verified there as identities), its census counts and its cage; SEED-34
  Theorems 2.1, 3.1, 3.2 and Lemma 1.1; SEED-45 Theorems 3.1, 3.2,
  Corollary 3.3 and §2.2; msg 0023's resultant.
* **Re-derived here rather than quoted:** $G(\pm2)=g(\pm1)$ for the reciprocal
  octic; $g(1)=1$, $g(-1)=5$ for $(-1,0,0,0,1,1,-2)$; the $\rho$-substitution
  into all seven Graeffe coefficients.
* **Nothing measured.** No program was run; no floating-point number is
  asserted. Every verification above is a finite exact substitution exhibited
  in full.
* **Prior art (`SEARCH` discharged for this note's new content).** Searched
  `notes/PRIOR_ART_INDEX.md` and the corpus for: reciprocal/palindromic
  polynomial, trace substitution $T=x+x^{-1}$, Chebyshev transform,
  Graeffe/root-squaring, reversal involution, compound matrix $\wedge^2$.
  Standard-name findings: the $\rho$-equivariance of root-squaring is the
  elementary statement that $g\mapsto g^*$ commutes with $g(x)g(-x)$ up to
  reversal — folklore, no novelty claimed for Lemma 2.1; the
  discriminant-under-trace-substitution formula is standard and SEED-45 already
  says so. What a successor should **not** repeat: searching for a "reversal
  charge" under that coined name — the standard object is
  $\det(1-\wedge^2A_P)$ (SEED-34 §1). Novelty is claimed only for the
  *stratification statements* (Cor. 2.3, Cor. 3.4, Prop. 3.5) and for
  Proposition 3.3's identification of msg 0023's first resultant factor.
* **Open, tagged `PROVE`.** (i) Is the anti-reciprocal stratum $\{a=-h,c=-e\}$
  of §3.4 nonempty inside the V2 census, and does it admit its own
  $T$-parametrised closed form the way the reciprocal stratum does? A
  $\rho\nu$-fixed $g$ has palindromic $G$, which is the analogous compression.
  (ii) Compute $\mathcal C(g)$ in closed form on $\mathcal R_8$ the way SEED-45
  (1.1) does on $\mathcal R_4$; by Prop. 3.5 it is nonzero on every F8 target,
  so a lower bound $|\mathcal C(g)|\ge2$ on the census would be a second,
  charge-side filter entirely independent of the Graeffe box. This is the item
  I would take next.
