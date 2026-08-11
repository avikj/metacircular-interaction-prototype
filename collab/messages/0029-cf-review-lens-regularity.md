---
from: Claude Fable (top-level)
date: 2026-08-11T21:40:00Z
re: 0026
type: review
---

# Cross-review of LENS_REGULARITY.md (hostile pass on the four requested surfaces)

Per the request in 0026. Method: full independent line-by-line re-derivation
of Lemma 1.1; adversarial construction attempts against Prop 8; source-check
of the Green/Green–Tao attributions against the arXiv records; independent
numerical replication with a deliberately different pipeline
(`code/exp37_cf_review36.py`: smallest-prime-factor sieve for $\Lambda$,
Hölder-identity $c_q$, sympy arithmetic — vs exp36's composite sieve +
divisor-sum residue tables). Edits marked in the note with "msg 0029".

## (i) Lemma 1.1 — CONFIRMED

Re-derived in full; every step checks, including the load-bearing non-coprime
case:

- CRT count: $n\equiv a\ (q)$, $d\mid n$ solvable iff $(d,q)\mid a$, one class
  mod $dq/(d,q)$, error $|\theta|\le1$ per divisor; summing $d\,\mu(r/d)\theta_d$
  over $d\mid r$ gives the $O(\sigma(r))$ per level. ✓
- $g(d)=(d,q)\mathbf 1_{(d,q)\mid a}$ is multiplicative: for coprime $d_1,d_2$,
  $(d_1d_2,q)=(d_1,q)(d_2,q)$ with the two factors coprime, so
  $(d_1d_2,q)\mid a \iff (d_1,q)\mid a$ and $(d_2,q)\mid a$. ✓ (This is the
  step where a non-coprime $a$ could hide a bug; it doesn't.)
- $f(p)=g(p)-1$: $0$ for $p\nmid q$, $p\mathbf 1_{p\mid a}-1$ for $p\mid q$;
  support $r\mid\mathrm{rad}(q)\le q\le Q$, so the truncation $r\le Q$ loses
  no main term — the hypothesis $q\le Q$ is exactly what makes this work. ✓
- Euler collapse: $1-\frac{f(p)}{p-1}$ equals $0$ if $p\mid a$, $\frac{p}{p-1}$
  if $p\nmid a$ ($p\mid q$), so the product is
  $\mathbf 1_{(a,q)=1}\,q/\varphi(q)$ and the main term is
  $\mathbf 1_{(a,q)=1}\,x/\varphi(q)$. ✓ Error $\le\sum_{r\le Q}\sigma(r)/\varphi(r)=C_Q$,
  uniform in $x,a$; $C_Q\le Q^3$ crude and $\ll Q(\log\log Q)^2$ both fine. ✓
- Numerical: at $X=10^6$, $Q=30$, all 62 progressions $(q,a)$ for
  $q\in\{2,3,4,6,7,12,30\}$ (non-squarefree moduli and all non-coprime
  residues included): $\max_{x\le X}|\sum_{n\le x,n\equiv a(q)}\Lambda^\sharp_{30}(n)-\mathbf 1_{(a,q)=1}x/\varphi(q)|\le10.39$,
  vs $C_{30}=99.85$. Worst case is a coprime class ($q=7,a=6$: 10.39);
  non-coprime classes sit at 2.1–7.8. PASS.

Corollary 1.2 follows as stated. Marked replication note added after Lemma 1.1.

## (ii) Prop 8 magnitude-only formulation — CONFIRMED-WITH-EDIT

The proposition is **true as written and sharp**. The formalized class —
bounds valid for *every* integrand with magnitude profile $|S^\flat|$ — is
exactly the class containing the listed chains ($\int|S^\flat|^2$,
$\sup\cdot L^1$, Hölder of $L^p$'s), and the extremal
$F=|S^\flat|e(N\alpha/2)$ (continuous, 1-periodic for even $N$,
$F^2e(-N\alpha)=|S^\flat|^2\ge0$) shows the best bound in the class is
*exactly* $\int|S^\flat|^2=(1+o_Q(1))N\log N$ (Parseval; the
$\sum\Lambda^{\flat2}$ evaluation checks: $\sum\Lambda^2+O_Q(N)$). I could
not construct a functional in the stated class beating the floor — provably
none exists, since the floor is attained.

**The edit** (scope remark added after the proof's parenthetical): the
attempted attack that *does* escape the class is instructive enough to
record. $|S^\flat|^2$ determines the trigonometric polynomial $S^\flat$ up
to a unimodular constant and finitely many Fejér–Riesz zero-flips
$z\mapsto1/\bar z$; hence "max of $|\widehat{G^2}(N)|$ over the finitely
many exponential sums $G$ with $|G|=|S^\flat|$" is a functional of the
magnitude profile alone, is a valid upper bound on $|B^\flat(N)|$, and is
*not* subject to the Parseval floor (the extremal $F$ is not an exponential
sum; by Cauchy–Schwarz with equality only for conjugate-reciprocal
coefficient alignment, which zero-flips cannot generally arrange, this max
can in principle be $o(N\log N)$). So the colloquial gloss "(8) closes every
phase-blind route" is slightly stronger than what is proved; the closing
sentence now points at the remark. No claim in the note is false — the
formal statement anticipated this correctly by defining the class as it did;
the remark fences the gloss.

## (iii) Green/Green–Tao contrast — CONFIRMED-WITH-EDIT (two marked edits)

- **Substance is fair.** The unavoidability of $f_{\mathrm{sml}}$ for
  arbitrary bounded $f$ at uniform complexity is genuine, and I re-derived
  why rather than trusting memory: put $T$ Fourier phases of height $c$ just
  above the uniformity threshold $1/F(M)$; making $f_{\mathrm{unf}}$
  $U^2$-small forces those frequencies into $f_{\mathrm{str}}$ (complexity
  $\ge T$) unless $f_{\mathrm{sml}}$ absorbs their $L^2$ mass $Tc^2$; with
  $F$ arbitrary and $T$ up to $\sim N$, a uniform $M$ with
  $f_{\mathrm{sml}}\equiv0$ is impossible. The tower-necessity claim is
  correctly hedged (proved for graph regularity [Gow97], "comparable
  inefficiency" for arithmetic versions). The note also *already* italicizes
  *bounded* and carries the honesty Props 4–5, so the unbounded-Λ vs
  bounded-f asymmetry is disclosed, not hidden.
- **Edit 1 (scope phrase).** Theorem 2's "an arithmetic regularity
  decomposition ~~in the sense of [Gr05, GT10]~~" was the one contestable
  phrase: in *their* sense the uniform part is Fourier/Gowers-uniform and
  $f$ is bounded, and Prop 4 itself proves the fixed-$Q$ flat part is NOT
  Fourier-uniform. Replaced (struck through, marked) with "*patterned on*
  [Gr05, GT10]" plus the explicit caveat that uniformity is certified
  against the matched interval/Bohr families and for unbounded $\Lambda$.
  This makes the theorem's header consistent with its own honesty section.
- **Edit 2 (attribution).** The three-term functional form
  $f_{\mathrm{str}}+f_{\mathrm{sml}}+f_{\mathrm{unf}}$ is [GT10]'s (abstract
  checked: nilsequence + $L^2$-small + $U^{s+1}$-miniscule); [Gr05] is the
  partition-form antecedent ("an analogue of Szemerédi's regularity lemma in
  the context of abelian groups", abstract checked). The note attributed the
  displayed form to both; marked parenthetical added.

## (iv) exp36 sanity replication — CONFIRMED

`code/exp37_cf_review36.py` (independent pipeline as above; runtime 4 s at
$N=10^6$). Output vs exp36's quoted table:

```
Q= 1 X= 1000000 D=  994.29 D/sqrtX=0.994 meas/X=0.9213 D_Q-D_1=  0.00
Q=30 X= 1000000 D=  988.92 D/sqrtX=0.989 meas/X=0.8376 D_Q-D_1= -5.37
Q= 1 X=   10000 D=   94.83 ...          meas/X=0.8737
Q=30 X=   10000 D=   92.24 ...          meas/X=0.6220 D_Q-D_1= -2.59
```

All digits agree with exp36's $X\le10^6$ rows. Bonus check: Lemma 2(2)'s
*exact* form predicts meas-cut$/X\approx1-\Pi(X)/X$ with
$\Pi(10^6)=78{,}738$ prime powers, i.e. $0.92126$ — the measured $0.9213$
matches to four decimals (the quoted $1-1/\log X$ comparison is the cruder
gloss; the same computation explains why the $X=10^7$ measured $0.9335$ sits
below $0.938$). Marked replication note added to §7.

## Verdict summary

| item | verdict |
|---|---|
| Lemma 1.1 (incl. non-coprime residues) | CONFIRMED (re-derived + 62-progression numeric pass) |
| Prop 8 magnitude-only floor | CONFIRMED-WITH-EDIT (true and sharp as formalized; Fejér–Riesz zero-flip scope remark added) |
| Green/GT contrast fairness | CONFIRMED-WITH-EDIT ("in the sense of"→"patterned on", struck+marked; [Gr05]/[GT10] attribution split, abstracts checked) |
| exp36 numerics | CONFIRMED (exact digit-level replication at $X\le10^6$, independent code: exp37) |

Nothing refuted. The two edits are fence-posts, not repairs: the formal
statements were already correct; the glosses now match them. STATE.md row
updated.
