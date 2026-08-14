# Lemma U2 de-imported: the uniform coprime Mertens sum, proved from scratch

**Status: complete elementary proof; frozen for hostile audit.** This note
discharges ledger item **H2 of `notes/E2_PROOF.md` §2.6** — the last
elementary open obligation of `notes/METHOD.md` §3 queue item 4 ("the $O(1)$
in M1"). Everything here is Abel summation and Euler products: no zeta
zeros, no RH, no numerics load-bearing. The two exact-rational spot checks
are licensed by `CLAUDE.md` (checking a derivation, not fitting).

**What it replaces.** `E2_PROOF.md` Lemma U2 states the coprime Mertens
asymptotic and *imports* it (Montgomery–Vaughan 1973; Halberstam–Richert
Lemma 3.5) with the ledger caveat: *"the literature's error term **not**
verified. U8's rate needs the uniform shape $E_n(Y)\ll d(n)Y^{-1/2}$,
**not verified**."* Corollary U8 there — hence the *rate* in the corrected
linear coefficient of Proposition M1′ — was therefore conditional on an
unchecked citation. This note proves the uniform bound (with a harmless log
power), makes the constant $C_n$ explicit (U2 left it unevaluated), and
thereby closes H2 unconditionally. It does **not** touch H3 (Hypothesis U),
H4, or H5, which remain open.

Notation as in `E2_PROOF.md` §2.1:
$$\Sigma_n(Y)=\sum_{\substack{q\le Y\\(q,n)=1}}\frac{\mu^2(q)}{\varphi(q)},
\qquad A(Q)=\Sigma_1(Q),\qquad
C=\gamma+\sum_p\frac{\log p}{p(p-1)}=1.332582\ldots$$

---

## 1. Statement

**Theorem U2′ (uniform coprime Mertens).** For all integers $n\ge1$ and all
real $Y\ge1$,
$$\boxed{\ \Sigma_n(Y)=\frac{\varphi(n)}{n}\Bigl(\log Y+C_n\Bigr)+E_n(Y),
\qquad C_n=C+\sum_{p\mid n}\frac{\log p}{p},\ }$$
with
$$|E_n(Y)|\le K\,d(n)\,\frac{(1+\log Y)^3}{\sqrt Y}$$
for an absolute, effective constant $K$. In particular $E_n(Y)\to0$ for
fixed $n$ (U2's qualitative content), and the uniform shape needed by
Corollary U8 of `E2_PROOF.md` holds with $(1+\log Y)^3$ in place of the
guessed bare $Y^{-1/2}$ — a difference that is immaterial there (§7).

The constant is consistent: at $n=1$, $C_1=C$; and the difference
$\frac{\log p}{p-1}-\frac{\log p}{p(p-1)}=\frac{\log p}{p}$ is exactly what
moving a prime from the "coprime" to the "dividing" side must cost.

## 2. The convolution identity

Define the multiplicative function $h$ by
$$h(p)=\frac1{p(p-1)},\qquad h(p^2)=-\frac1{p(p-1)},\qquad h(p^k)=0\ (k\ge3).$$

**Lemma 1.** For every integer $q\ge1$,
$$\frac{\mu^2(q)}{\varphi(q)}=\sum_{dm=q}\frac{h(d)}{m}.$$

*Proof.* Both sides are multiplicative in $q$ (the right side is a Dirichlet
convolution of multiplicative functions), so it suffices to check prime
powers $q=p^k$:

- $k=0$: both sides $1$.
- $k=1$: $\dfrac1p+h(p)=\dfrac{p-1+1}{p(p-1)}=\dfrac1{p-1}=\dfrac{\mu^2(p)}{\varphi(p)}$.
- $k=2$: $\dfrac1{p^2}+\dfrac{h(p)}p+h(p^2)
  =\dfrac{(p-1)+1-p}{p^2(p-1)}=0=\mu^2(p^2)$.
- $k\ge3$: $\dfrac1{p^k}+\dfrac{h(p)}{p^{k-1}}+\dfrac{h(p^2)}{p^{k-2}}
  =\dfrac{(p-1)+1-p}{p^k(p-1)}=0$. $\square$

*Exact-rational check (licensed).* $q=6$:
$\tfrac16+\tfrac{1/2}{3}+\tfrac{1/6}{2}+\tfrac1{12}=\tfrac12=\tfrac{\mu^2(6)}{\varphi(6)}$.
$q=12$: $\tfrac1{12}+\tfrac{1/2}{6}+\tfrac{1/6}{4}-\tfrac{1/2}{3}+\tfrac{1/12}{2}-\tfrac1{12}
=\tfrac{2+2+1-4+1-2}{24}=0$. ✓

**Support and size of $h$.** $h(d)\ne0$ forces $d=ab^2$ with $a,b$
squarefree and coprime ($a$ = product of the primes with exponent $1$, $b$ =
exponent $2$); the decomposition is unique, and
$$|h(ab^2)|=\frac1{a\varphi(a)}\cdot\frac1{b\varphi(b)}\le\frac{d(a)}{a^2}\cdot\frac{d(b)}{b^2},$$
using, for squarefree $m$,
$m/\varphi(m)=\prod_{p\mid m}\frac p{p-1}\le2^{\omega(m)}=d(m)$.

**The miracle at $s=0$.** For every prime $p$,
$$1+h(p)+h(p^2)=1\qquad\text{exactly},$$
so the completed sum of $h$ over any coprimality class is exactly $1$:
$$\sum_{(d,n)=1}h(d)=\prod_{p\nmid n}\bigl(1+h(p)+h(p^2)\bigr)=1,$$
the product/series being absolutely convergent
($\sum_d|h(d)|\le\prod_p(1+\tfrac2{p(p-1)})<\infty$). Likewise, writing
$\log d=\sum_p e_p(d)\log p$ and rearranging by absolute convergence
($\sum_d|h(d)|\log d<\infty$ since $\sum_p\frac{\log p}{p(p-1)}<\infty$),
$$\sum_{(d,n)=1}h(d)\log d
=\sum_{p\nmid n}\log p\,\bigl[h(p)+2h(p^2)\bigr]\prod_{p'\ne p,\,p'\nmid n}\!\!1
=-\sum_{p\nmid n}\frac{\log p}{p(p-1)}.$$
These two evaluations are the entire source of the main term.

## 3. Elementary divisor-sum lemmas

All for real $x\ge1$; $D(x):=\sum_{a\le x}d(a)$.

**(a)** $D(x)\le x(1+\log x)$. — $D(x)=\sum_{t\le x}\lfloor x/t\rfloor\le
x\sum_{t\le x}\tfrac1t\le x(1+\log x)$.

**(b)** $\displaystyle\sum_{a>x}\frac{d(a)}{a^2}\le\frac{2(2+\log x)}{x}$. —
Abel summation: $\sum_{x<a\le T}d(a)a^{-2}=\frac{D(T)}{T^2}-\frac{D(x)}{x^2}
+2\int_x^T\frac{D(t)}{t^3}dt$; let $T\to\infty$, drop the negative term, and
use (a): $\le2\int_x^\infty\frac{1+\log t}{t^2}dt=\frac{2(2+\log x)}{x}$.

**(c)** $\displaystyle\sum_{a>x}\frac{d(a)(1+\log 2a)}{a^2}\ll\frac{(1+\log 2x)^2}{x}$. —
Same Abel step with $\sum_{a\le t}d(a)(1+\log2a)\le(1+\log2t)D(t)$, then
$\int_x^\infty(1+\log2t)^2t^{-2}dt\ll(1+\log2x)^2/x$.

**(d)** $\displaystyle\sum_{a\le x}\frac{d(a)}{a}\le(1+\log x)^2$. —
$\sum_{uv\le x}\tfrac1{uv}\le\bigl(\sum_{u\le x}\tfrac1u\bigr)^2$.

## 4. Tails and moments of $h$

**Lemma 2.** For $Y\ge1$:
$$T_0(Y):=\sum_{d>Y}|h(d)|\ll\frac{(1+\log Y)^2}{\sqrt Y},\qquad
T_1(Y):=\sum_{d>Y}|h(d)|\log d\ll\frac{(1+\log Y)^3}{\sqrt Y},$$
$$T_2(Y):=\sum_{d\le Y}|h(d)|\,d\ll\sqrt Y\,(1+\log Y)^3.$$

*Proof.* Parametrize $d=ab^2$ as in §2 and drop the squarefree/coprimality
conditions (upper bounds).

$T_0$: split at $b\le\sqrt Y$. There, $ab^2>Y$ forces $a>Y/b^2\ge1$, and by
(b) the inner sum is $\le2(2+\log(Y/b^2))\,b^2/Y\le2(2+\log Y)b^2/Y$; then
$\sum_{b\le\sqrt Y}\frac{d(b)}{b^2}\cdot\frac{2(2+\log Y)b^2}{Y}
\le\frac{2(2+\log Y)}{Y}D(\sqrt Y)\ll\frac{(1+\log Y)^2}{\sqrt Y}$ by (a).
For $b>\sqrt Y$, sum $a$ freely: $\sum_a d(a)a^{-2}=\zeta(2)^2$ and
$\sum_{b>\sqrt Y}d(b)b^{-2}\ll(1+\log Y)/\sqrt Y$ by (b).

$T_1$: $\log(ab^2)\le(1+\log2a)+2(1+\log2b)$, giving two sums. The
$(1+\log2a)$ sum repeats the $T_0$ split with (c) in place of (b) on the
$a$-variable: $b\le\sqrt Y$ contributes
$\ll\frac{(1+\log Y)^2}{Y}\sum_{b\le\sqrt Y}d(b)\ll\frac{(1+\log Y)^3}{\sqrt Y}$,
and $b>\sqrt Y$ contributes $\ll(1+\log Y)/\sqrt Y$ since
$\sum_ad(a)(1+\log2a)a^{-2}=O(1)$. The $(1+\log2b)$ sum: for $b\le\sqrt Y$
bound $1+\log2b\ll1+\log Y$ and reuse $T_0$; for $b>\sqrt Y$ use (c) on $b$:
$\ll(1+\log Y)^2/\sqrt Y$.

$T_2$: $ab^2\le Y$ forces $b\le\sqrt Y$ and $a\le Y$, and
$|h(ab^2)|\,ab^2\le\frac{d(a)}{a}\,d(b)$, so by (d) and (a)
$T_2(Y)\le(1+\log Y)^2\sum_{b\le\sqrt Y}d(b)\ll\sqrt Y(1+\log Y)^3$. $\square$

## 5. The coprime harmonic sum, uniformly

**Lemma 3.** For all $n\ge1$, $x\ge1$, with $D_n:=\sum_{p\mid n}\frac{\log p}{p-1}$:
$$\sum_{\substack{m\le x\\(m,n)=1}}\frac1m
=\frac{\varphi(n)}{n}\bigl(\log x+\gamma+D_n\bigr)+R_n(x),\qquad
|R_n(x)|\le\frac{4\,d(n)}{x}.$$

*Proof.* Let $n'=\operatorname{rad}(n)$ and $H(t)=\sum_{k\le t}\frac1k$
($=0$ for $t<1$). Möbius over $e\mid(m,n')$ gives
$$\sum_{\substack{m\le x\\(m,n)=1}}\frac1m=\sum_{e\mid n'}\frac{\mu(e)}{e}H(x/e).$$
For $t\ge1$, $|H(t)-\log t-\gamma|\le3/t$ (for $t\ge2$: $\lfloor t\rfloor$-term
Euler–Maclaurin gives $\le\tfrac3{2\lfloor t\rfloor}\le3/t$; for $1\le t<2$:
$|1-\log t-\gamma|\le(1-\gamma)+\log2<1.12\le3/t$). Insert this for the
divisors $e\le x$ and complete the main term over all $e\mid n'$:
$$\sum_{e\mid n'}\frac{\mu(e)}{e}\bigl(\log(x/e)+\gamma\bigr)
=\frac{\varphi(n')}{n'}(\log x+\gamma)-\sum_{e\mid n'}\frac{\mu(e)\log e}{e}
=\frac{\varphi(n)}{n}\bigl(\log x+\gamma+D_n\bigr),$$
using $\varphi(n')/n'=\varphi(n)/n$ and, from
$-\frac{d}{ds}\prod_{p\mid n'}(1-p^{-s})\big|_{s=1}$,
$\sum_{e\mid n'}\frac{\mu(e)\log e}{e}=-\frac{\varphi(n')}{n'}D_n$.
The error has two parts. The $e\le x$ remainders total
$\le\sum_{e\mid n'}\frac1e\cdot\frac{3e}{x}\le\frac{3\cdot2^{\omega(n)}}{x}
\le\frac{3d(n)}{x}$. The completion terms have $e>x$, and each satisfies
$$\Bigl|\frac{\log(x/e)+\gamma}{e}\Bigr|\le\frac{\gamma+\log(e/x)}{e}
\le\frac{e^{\gamma-1}}{x}<\frac{0.66}{x}$$
(the function $t\mapsto(\gamma+\log(t/x))/t$ on $t>x$ peaks at
$t=xe^{1-\gamma}$ with value $e^{\gamma-1}/x$), so they total
$\le0.66\,d(n)/x$. Hence $|R_n(x)|\le4d(n)/x$. $\square$

## 6. Proof of Theorem U2′

Restrict Lemma 1 to $(q,n)=1$ — then $d$ and $m$ are automatically coprime
to $n$ — and sum over $q\le Y$:
$$\Sigma_n(Y)=\sum_{\substack{d\le Y\\(d,n)=1}}h(d)
\sum_{\substack{m\le Y/d\\(m,n)=1}}\frac1m
=\sum_{\substack{d\le Y\\(d,n)=1}}h(d)\Bigl[\frac{\varphi(n)}{n}
\bigl(\log(Y/d)+\gamma+D_n\bigr)+R_n(Y/d)\Bigr]$$
by Lemma 3 (each $Y/d\ge1$). Completing both $d$-sums with §2's exact
evaluations $\sum_{(d,n)=1}h(d)=1$ and
$\sum_{(d,n)=1}h(d)\log d=-\sum_{p\nmid n}\frac{\log p}{p(p-1)}$:
$$\Sigma_n(Y)=\frac{\varphi(n)}{n}\Bigl[\log Y+\gamma+D_n
+\sum_{p\nmid n}\frac{\log p}{p(p-1)}\Bigr]+E_n(Y)
=\frac{\varphi(n)}{n}\bigl(\log Y+C_n\bigr)+E_n(Y),$$
since $\gamma+\sum_{p\nmid n}\frac{\log p}{p(p-1)}+D_n
=C+\sum_{p\mid n}\bigl(\frac{\log p}{p-1}-\frac{\log p}{p(p-1)}\bigr)
=C+\sum_{p\mid n}\frac{\log p}{p}=C_n$, and
$$E_n(Y)=-\frac{\varphi(n)}{n}\Bigl[(\log Y+\gamma+D_n)
\sum_{\substack{d>Y\\(d,n)=1}}h(d)-\sum_{\substack{d>Y\\(d,n)=1}}h(d)\log d\Bigr]
+\sum_{\substack{d\le Y\\(d,n)=1}}h(d)R_n(Y/d).$$
Bound term by term, using $\varphi(n)/n\le1$ and
$D_n\le\omega(n)\log2\le d(n)$ (each $\frac{\log p}{p-1}\le\log2$):
$$|E_n(Y)|\le(\log Y+\gamma+d(n))\,T_0(Y)+T_1(Y)
+\frac{4d(n)}{Y}\,T_2(Y)\ll d(n)\,\frac{(1+\log Y)^3}{\sqrt Y}$$
by Lemma 2. Every implied constant along the way is absolute and effective.
$\blacksquare$

*Exact-rational spot check (licensed).* $n=2$, $Y=10$:
$\Sigma_2(10)=1+\tfrac12+\tfrac14+\tfrac16=\tfrac{23}{12}=1.9167$, against
$\tfrac12(\log10+C+\tfrac{\log2}2)=1.9909$ — error $-0.074$, inside the
envelope. $n=1$, $Y=10$: $A(10)=\tfrac{11}3=3.6667$ vs $\log10+C=3.635$
(the same pair `E2_PROOF.md` §2.5 tabulates). ✓

## 7. What this closes downstream

**Corollary 1 ($A(Q)$ self-contained).** $A(Q)=\log Q+C+O(Q^{-1/2}(1+\log Q)^3)$
— the $n=1$ case. Proposition M1 / M1′'s use of $A(Q)=\log Q+C+o(1)$ (there
credited to Ward; Montgomery–Vaughan) no longer rests on an import.

**Corollary 2 (U8 unconditional).** Feeding Theorem U2′ into
`E2_PROOF.md` Proposition U7: for $2\le m\le Q$ and $d\mid\operatorname{rad}(m)$,
$$|E_{\operatorname{rad}(m)}(Q/d)|\ll d(m)\,(1+\log Q)^3\,d^{1/2}Q^{-1/2},\qquad
\sum_{d\mid\operatorname{rad}(m)}d^{1/2}\le d(m)\,m^{1/2},$$
so the correction sum in U7 is
$\ll Q^{-1/2}(1+\log Q)^3\sum_{m\ge2}\frac{d(m)^2m^{1/2}}{(1+m)^2}$, and the
series converges exactly: $\sum_m d(m)^2m^{-3/2}=\zeta(3/2)^4/\zeta(3)$
(Ramanujan's identity $\sum d(m)^2m^{-s}=\zeta(s)^4/\zeta(2s)$). Hence
$$S(Q)=S_\infty+O\bigl(Q^{-1/2}(1+\log Q)^3\bigr),$$
which is Corollary U8's conclusion, now a theorem, with the same downstream
consequence: $2A(Q)S(Q)=2S_\infty\log Q+2CS_\infty+O(Q^{-1/2}(1+\log Q)^4)$.

**Corollary 3 (M1′ rates).** In Proposition M1′ the first two blocks now
carry explicit unconditional rates with no imported error terms:
$$\frac{A(Q)^2}{4}=\frac{(\log Q+C)^2}{4}+O\bigl(Q^{-1/2}(1+\log Q)^4\bigr),\qquad
2A(Q)S(Q)=2S_\infty\log Q+2CS_\infty+O\bigl(Q^{-1/2}(1+\log Q)^4\bigr).$$
The quadratic and linear coefficients $\tfrac14$ and
$\tfrac C2+2S_\infty=1.181852\ldots$ are therefore fully proved with rate.
**Untouched:** the constant term still contains $\mathcal E(Q)$, i.e.
Hypothesis U (ledger H3) — this note does not close it and does not claim to.

## 8. Prior art

The result is classical and **no novelty is claimed**; this is a
verification note whose function is to replace an unchecked citation with a
proof, per `CLAUDE.md`. Known treatments (from memory — network egress is
restricted in this session, so these were not re-fetched; same obligation
class as `E2_PROOF.md` ledger H6): D. R. Ward (1927) for $n=1$;
van Lint–Richert (1965), who prove the one-line lower bound
$\Sigma_n(Y)\ge\frac{\varphi(n)}{n}\,\Sigma_1(Y)\ge\frac{\varphi(n)}{n}\log Y$
used throughout sieve theory; Montgomery–Vaughan (1973) and
Halberstam–Richert (Lemma 3.5) — the two sources U2 cited; Riesel–Vaughan
(1983) for explicit $n=1$ constants. The corpus itself contains no proof
(grep: the only occurrences of the sum are M1's citation and U2's import).
The convolution trick of §2 is the standard one; the only mildly nonstandard
point is carrying the coprimality condition through it uniformly, which is
free because $h*\frac1{\mathrm{id}}$ needs no coprimality between $d$ and $m$.

## 9. Honesty ledger

| # | item | status |
|---|---|---|
| L1 | Theorem U2′, Lemmas 1–3, Corollaries 1–3 | **Proved here, unconditional, elementary.** All implied constants absolute and effective; not numerically optimized. |
| L2 | Log exponent $3$ (and $4$ downstream) | **Not optimal.** The literature has $O(Y^{-1/2}\log Y)$-shape for $n=1$; sharpening would only polish logs and changes nothing in M1′. Recorded so no one mistakes the exponent for a barrier. |
| L3 | Prior art | **Classical; references from memory, not re-fetched (egress).** No novelty claimed. Open prior-art obligation is the same class as `E2_PROOF.md` H6, and narrower: the *statement* is certainly known; only the exact constant/exponent bookkeeping here is ours. — **PRIOR-ART SWEEP 2026-08-14: RESOLVED-FOUND, and the constant/exponent bookkeeping is published too, sharper than ours** (search-summary/śabda grade; `WebFetch` EGRESS_BLOCKED, no PDF read). The coprime form is stated verbatim in the literature as $\sum_{n\le M,\,(n,q)=1}\frac{\mu^2(n)}{\varphi(n)}=\frac{\varphi(q)}{q}\bigl(\log M+c+\sum_{p\mid q}\frac{\log p}{p}\bigr)+O\bigl(\theta(q)M^{-1/2}\bigr)$ with $\theta(q)=2^{\omega(q)}$ and $c=\gamma+\sum_p\frac{\log p}{p(p-1)}$ — i.e. **exactly Theorem U2′, including the $\sum_{p\mid n}\log p/p$ correction term and `E2_PROOF.md`'s $C=1.332582\ldots$** — as Prop. A.1 of arXiv:2603.22124 (appendix), evaluated there following R. Sitaramachandra Rao (1985). The located error term $O(2^{\omega(q)}M^{-1/2})$ is **better than this note's** $O(Y^{-1/2}(1+\log Y)^3)$, which L2 already anticipated. From-memory references confirmed with one correction: D. R. Ward, *Some series involving Euler's function*, J. London Math. Soc. **2** (1927) 210–214; van Lint–Richert, *Über die Summe $\sum_{n\le x,\,p(n)<y}\mu^2(n)/\varphi(n)$*, Proc. Kon. Nederl. Akad. Wetensch. A **67** (**1964**, not 1965) 582–587; Montgomery–Vaughan, *The large sieve*, Mathematika **20** (1973) 119–134. **Verdict: Theorem U2′ is known mathematics in full, constants and all.** Attribution status only; the proof and every constant stand unchanged, and the note's stated function — replacing an unchecked citation with a proof — is unaffected. This also retires `DRIFT_EXPONENT_EXACT.md` §8 item (iv), recorded NO-MATCH on 2026-08-14 by `cf-tessera`. |
| L4 | `E2_PROOF.md` ledger after this note | **H2 closed** (both halves: the unverified literature error term is now bypassed by a proof, and U8's uniform shape is proved). **H3 (Hypothesis U), H4, H5, H6, H7 unchanged and still open.** |
| L5 | Numerical constants | $C=1.332582$, $\gamma=0.577216$ quoted from `E2_PROOF.md` (its H7 governs their precision); the two spot checks in §2 and §6 are exact rationals computed by hand. |
| L6 | Scope of Corollary 3 | The *constant term* of M1′ is still $0.430870\ldots+\lim\mathcal E(Q)$, **conditional on Hypothesis U**. This note proves rates for the two leading coefficients only. |

## 10. What changed in the record

1. **Lemma U2 is no longer an import.** The coprime Mertens sum has a
   self-contained elementary proof with a uniform error
   $\ll d(n)Y^{-1/2}(1+\log Y)^3$ and the previously unevaluated constant
   made explicit: $C_n=C+\sum_{p\mid n}\frac{\log p}{p}$.
2. **Corollary U8 of `E2_PROOF.md` is unconditional**, so
   $S(Q)=S_\infty+O(Q^{-1/2}(1+\log Q)^3)$ and the linear coefficient
   $\tfrac C2+2S_\infty=1.181852\ldots$ of Proposition M1′ carries a proved
   rate. Queue item 4 of `METHOD.md` §3 is now closed *except* for
   Hypothesis U (H3) and the extremal-order question (H4), both of which are
   genuine research problems, not verification debts.
3. Nothing numerical was run; the only computations are exact rationals
   checked by hand.
