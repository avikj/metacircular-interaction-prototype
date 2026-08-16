# Anti-saturation on the truncated Chen set: the exact bookkeeping

**Author.** cf-swarm-erdos (Claude Fable 5), 2026-08-16. Method lens: Erdős —
elementary counting, minimal examples, exact constants.
**Receives.** `collab/upstream/library/raw/ETERNAL_GOLDEN_BRAID_THEOREM_FACTORY_IV_2026-08-14.md`
§IV, §VIII; `notes/FACTORY_IV_CHEN_CORNER_AUDIT.md` §2 (the correction this note
executes) and §7 (`PROVE` item: *"restate Factory IV §IV on the truncated Chen
set; identify δ against the classical Chen/Halberstam–Richert constants"*);
`notes/GAUGE.md` §F.3; `TARGET.md`;
`notes/ANTI_SATURATION_MISSING_STRUCTURE_CERTIFICATE.md` (cf-swarm-selberg).
**Relation to the sibling note.** The certificate classifies *which structures
could prove* the δ-target and closes categories C1/C2. It explicitly does not
compute the branch constants (its §5: "the only quantitative claims here are the
branch orders ≍ X/log²X … classical theorems, cited not re-proved"). This note
does exactly that deferred counting, and one thing the certificate could not
state without it: **what δ is**. No classification is repeated here.
**Status.** §1 proved (elementary, unconditional). §2–§3 heuristic bookkeeping,
labelled at every line, with all constants derived in closed form — no fitted
quantity appears. §4 proved equivalence + explicitly flagged CITED-UNVERIFIED
constants. §5 ledger. No numerics were run; none are needed.

---

## 1. Definitions and the exact identity (PROVED)

Throughout $\theta=3/11$ is the Green–Tao truncation exponent (Factory IV §VIII;
the *value* $3/11$ is CITED-UNVERIFIED — see §5), $p$ ranges over odd primes,
and $\Omega$ is the number of prime factors with multiplicity.

**Definition 1.1 (the two branches).** For $X\ge3$ set

$$\mathsf P(X)=\{\,p\le X:\ p+2\ \text{prime}\,\},$$
$$\mathsf S_\theta(X)=\{\,p\le X:\ p+2=ab,\ a,b\ \text{prime},\ a\le b,\ a>p^{\theta}\,\}.$$

(The condition $b>p^\theta$ is automatic when $a\le b$ and $a>p^\theta$; so
"both factors $>p^{3/11}$" is the single condition $a>p^\theta$ on the *smaller*
factor. Likewise on $\mathsf P(X)$ the truncation is vacuous: a prime $p+2$ has
its one prime factor $\asymp p$.)

**Definition 1.2 (the truncated Chen set and its counts).**

$$\mathsf C^{3/11}(X)=\mathsf P(X)\cup\mathsf S_\theta(X),\qquad
C_T^{3/11}(X)=\#\mathsf C^{3/11}(X),\qquad
L_T^{3/11}(X)=\sum_{p\in\mathsf C^{3/11}(X)}\lambda(p+2),$$

and $T(X)=\#\mathsf P(X)$ is the twin count.

**Lemma 1.3 (disjointness).** $\mathsf P(X)\cap\mathsf S_\theta(X)=\varnothing$.

*Proof.* $p\in\mathsf P(X)\Rightarrow\Omega(p+2)=1$;
$p\in\mathsf S_\theta(X)\Rightarrow\Omega(p+2)=2$. $\Omega$ is single-valued by
unique factorization and $1\ne2$. $\square$

**Proposition 1.4 (the exact identity).**
$$C_T^{3/11}(X)-L_T^{3/11}(X)=2\,T(X),\qquad\text{i.e.}\qquad
\boxed{\,T(X)=\tfrac12\bigl(C_T^{3/11}(X)-L_T^{3/11}(X)\bigr)\,}$$
for every $X$, with no error term and no hypothesis.

*Proof.* On $\mathsf C^{3/11}(X)$ we have $\Omega(p+2)\in\{1,2\}$, so
$\lambda(p+2)=(-1)^{\Omega(p+2)}$ takes the value $-1$ exactly on
$\mathsf P(X)$ and $+1$ exactly on $\mathsf S_\theta(X)$ (Lemma 1.3 makes this a
partition, so "exactly" is literal). Hence
$1-\lambda(p+2)=2\cdot\mathbf 1[p\in\mathsf P(X)]$ pointwise, and summing over
$\mathsf C^{3/11}(X)$ gives $C_T-L_T=2\#\mathsf P(X)$. $\square$

Writing $S:=\#\mathsf S_\theta(X)$, the whole of §1 is the pair of linear
equations
$$C_T^{3/11}=T+S,\qquad L_T^{3/11}=S-T .$$

**Remark 1.5 (the identity is truncation-free; only the δ-target is not).**
Proposition 1.4 holds verbatim for the unrestricted envelope, for any
intermediate truncation $\theta\in(0,1/2)$, and indeed for
$\mathsf P(X)\cup\mathcal A$ for *any* $\mathcal A\subseteq\{p:\Omega(p+2)=2\}$:
the semiprime branch enters $C_T$ and $L_T$ with the same sign and cancels. So
the truncation buys nothing in §1 — Factory IV §IV's identity was never at risk
(the audit says the same). What the truncation buys is that the two branches
become *comparable*, which is what makes a fixed relative deficit a meaningful
demand. That is §2–§3.

---

## 2. Both branches on the truncated set (HEURISTIC — Hardy–Littlewood bookkeeping)

Everything in this section is conditional on the Hardy–Littlewood prime-pair
heuristic for two linear forms, applied to $(b,\,ab-2)$; it is labelled
**HEURISTIC** and nothing downstream in §1 or §4's Proposition 4.2 depends on
it. What *is* exact here is every constant: each is derived in closed form, none
is fitted, and each carries its $X$-dependence (`CLAUDE.md`, HOLOGRAM §7).

Write $\Pi_2=\prod_{p>2}\bigl(1-\tfrac1{(p-1)^2}\bigr)$ for the twin-prime
constant, so the HL prediction for the prime branch is

$$\textbf{(H1)}\qquad T(X)\ \sim\ 2\Pi_2\int_2^X\frac{dt}{\log^2t}\ \sim\ 2\Pi_2\,\frac X{\log^2X}.$$

### 2.1 The singular series of the semiprime branch, in closed form (DERIVED)

**Lemma 2.1.** Let $a\ge3$ be prime. The HL singular series for the pair of
forms $b\mapsto(b,\ ab-2)$ is
$$\mathfrak S(a)\;=\;\prod_v\frac{1-\nu_a(v)/v}{(1-1/v)^2}\;=\;2\Pi_2\cdot\frac{a-1}{a-2},$$
where $\nu_a(v)=\#\{b\bmod v:\ b(ab-2)\equiv0\}$.

*Proof.* Compute $\nu_a$ at every prime $v$.
$v=2$: $a$ is odd, so $b\equiv1$ gives $b(ab-2)\equiv1$; only $b\equiv0$ is a
root, $\nu_a(2)=1$.
$v=a$: $ab-2\equiv-2\not\equiv0$ (as $a>2$), so only $b\equiv0$, $\nu_a(a)=1$.
$v\nmid 2a$: the roots are $b\equiv0$ and $b\equiv2a^{-1}$, distinct because
$v\nmid2$; $\nu_a(v)=2$.
Hence, using $\dfrac{1-2/v}{(1-1/v)^2}=\dfrac{v(v-2)}{(v-1)^2}=1-\dfrac1{(v-1)^2}$,
$$\mathfrak S(a)=\underbrace{\frac{1-\frac12}{(1-\frac12)^2}}_{=\,2}\cdot
\underbrace{\frac{1-\frac1a}{(1-\frac1a)^2}}_{=\,\frac a{a-1}}\cdot
\prod_{\substack{v>2\\ v\ne a}}\Bigl(1-\tfrac1{(v-1)^2}\Bigr)
=2\cdot\frac a{a-1}\cdot\frac{\Pi_2}{1-\frac1{(a-1)^2}} .$$
Since $1-\frac1{(a-1)^2}=\frac{a(a-2)}{(a-1)^2}$, this is
$2\Pi_2\cdot\frac a{a-1}\cdot\frac{(a-1)^2}{a(a-2)}=2\Pi_2\frac{a-1}{a-2}$. $\square$

*Check on the minimal example ($a=3$, the Erdős reflex):* $\mathfrak S(3)=4\Pi_2$,
and directly $\nu_3(3)=1$ gives the factor $\frac{1-1/3}{(1-1/3)^2}=\frac32$ in
place of $1-\frac14=\frac34$, i.e. a gain of $2$ over $2\Pi_2$. Agrees.

**Corollary 2.2 (why truncation cleans the arithmetic).** $\mathfrak S(a)=2\Pi_2\bigl(1+\tfrac1{a-2}\bigr)$.
On the truncated set $a>p^{3/11}\to\infty$, so $\mathfrak S(a)=2\Pi_2(1+O(X^{-3/11}))$
**uniformly**: the entire arithmetic content of the semiprime branch collapses to
the *same* constant $2\Pi_2$ that governs the twin branch. The ratio of the two
branches therefore contains no singular series at all. (Contrast §3, where the
$a$-dependent factor is the whole story.)

### 2.2 The exponent integral and its exact evaluation (DERIVED)

Count $\mathsf S_\theta$ dyadically in $p$, which is the parameterization that
keeps every $p$ at its own scale (each $p$ is assigned $\alpha=\log a/\log p$,
$a$ its smaller prime factor). For $p\in(t,2t]$ the constraints
$a>p^\theta$ and $a\le b$ confine $\alpha$ to $(\theta,1/2]$, and for fixed
$a=t^\alpha$ the HL count of $b$ with $ab\in(t,2t]$, $b$ and $ab-2$ prime, is
$$\mathfrak S(a)\cdot\frac{t/a}{\log(t/a)\,\log t}
=2\Pi_2\bigl(1+O(t^{-\theta})\bigr)\cdot\frac{t/a}{(1-\alpha)\log^2 t}.$$
Summing over primes $a$ with Mertens' measure
$\sum_{a\ \text{prime},\,\alpha\in[\alpha_0,\alpha_0+d\alpha]}\frac1a=\frac{d\alpha}\alpha+o(1)$
(this *is* $\sum_{a\le Z}1/a=\log\log Z+M+o(1)$ in the variable
$\alpha=\log a/\log t$, since $\log\log t^\alpha=\log\alpha+\log\log t$):

$$\textbf{(H2)}\qquad
\#\bigl(\mathsf S_\theta\cap(t,2t]\bigr)\ \sim\ 2\Pi_2\,\frac t{\log^2t}\;I(\theta),
\qquad
I(\theta):=\int_\theta^{1/2}\frac{d\alpha}{\alpha(1-\alpha)} ,$$
and summing dyadically,
$$\#\mathsf S_\theta(X)\ \sim\ 2\Pi_2\,I(\theta)\int_2^X\frac{dt}{\log^2t}\ \sim\ 2\Pi_2\,I(\theta)\,\frac X{\log^2X}.$$

**Lemma 2.3 (the integral, exactly).** For $0<\theta<\tfrac12$,
$$\frac1{\alpha(1-\alpha)}=\frac1\alpha+\frac1{1-\alpha},\qquad
\int\frac{d\alpha}{\alpha(1-\alpha)}=\log\frac{\alpha}{1-\alpha}+C,$$
so
$$I(\theta)=\Bigl[\log\frac{\alpha}{1-\alpha}\Bigr]_{\theta}^{1/2}
=\log\frac{1/2}{1/2}-\log\frac{\theta}{1-\theta}
=\boxed{\ \log\frac{1-\theta}{\theta}\ }.$$
At the Green–Tao value $\theta=3/11$: $\frac{1-\theta}\theta=\frac{8/11}{3/11}=\frac83$, hence
$$\boxed{\,I(3/11)=\log\tfrac83=3\log2-\log3\,}.$$
(Endpoint $\alpha=1/2$ contributes $0$; the upper endpoint is the diagonal
$a=b$, i.e. $p+2=a^2$, which carries $\ll X^{1/2}$ points and is invisible at
this order in any case.) $\square$

**Summary of §2 (HEURISTIC, exact constants).**
$$T(X)\sim 2\Pi_2\frac X{\log^2X},\qquad
S(X)\sim 2\Pi_2\log\tfrac83\cdot\frac X{\log^2X},\qquad
C_T^{3/11}(X)\sim 2\Pi_2\bigl(1+\log\tfrac83\bigr)\frac X{\log^2X},$$
$$\frac{L_T^{3/11}(X)}{C_T^{3/11}(X)}=\frac{S-T}{S+T}\ \longrightarrow\
\frac{\log\frac83-1}{\log\frac83+1}\;<\;0 .$$
Both branches are $\asymp X/\log^2X$ with the **same** singular series, exactly
as the audit demanded; and the ratio $S/T\to\log\frac83$ is a pure log of the
truncation ratio, free of arithmetic.

**Proposition 2.4 (the branch ordering, PROVED given (H1)–(H2)).** $S<T$
asymptotically, i.e. $\log\frac83<1$, i.e. $e>\frac83$. Indeed
$$e=\sum_{n\ge0}\frac1{n!}>1+1+\tfrac12+\tfrac16=\tfrac83 .$$
More generally $S(X)\lessgtr T(X)$ according as $\theta\gtrless\theta^\ast$
where $I(\theta^\ast)=1$, i.e. $\frac{1-\theta^\ast}{\theta^\ast}=e$, i.e.
$$\theta^\ast=\frac1{1+e},$$
and $\tfrac3{11}>\tfrac1{1+e}\iff 3+3e>11\iff e>\tfrac83$, the same inequality.
So the Green–Tao truncation exponent sits **just above** the crossover at which
the truncated semiprime branch stops dominating the twin branch; the margin is
exactly $e-\frac83$, i.e. the tail $\sum_{n\ge4}1/n!$ of the exponential series.
*(Stated as an exact inequality between the constants, not as numerology; the
only claim is $3/11>1/(1+e)$, which the displayed series proves.)*

---

## 3. Contrast: where the $\log\log X$ lives on the unrestricted envelope

The audit (§2) rejected the δ-target on the unrestricted envelope because the
semiprime branch is $\asymp X\log\log X/\log^2X$ while the twin branch is
$\ll X/\log^2X$. §2's bookkeeping localizes that $\log\log X$ to one endpoint of
one integral, and supplies the constant the audit left as $\asymp$.

**3.1 The audit's $1/\varphi(a)$, derived.** For *fixed* prime $a$, (H2)'s
inner count is $\mathfrak S(a)\cdot\frac{X/a}{\log(X/a)\log X}\sim
2\Pi_2\frac{a-1}{a-2}\cdot\frac X{a\log^2X}$, and the elementary identity
$$\frac{a-1}{a(a-2)}=\frac1{a-1}+\frac1{a(a-1)(a-2)}
=\frac1{\varphi(a)}+O(a^{-3})$$
(cross-multiplying: $(a-1)^2-a(a-2)=1$) turns this into
$$\#\{p\le X:\ p+2=ab,\ b\ \text{prime}\}\ \sim\ \frac{2\Pi_2}{\varphi(a)}\cdot\frac X{\log^2X}\Bigl(1+O(a^{-2})\Bigr).$$
This is exactly the audit's $\asymp_a X/(\varphi(a)\log^2X)$, now with its
constant $2\Pi_2$ and its error.

**3.2 The divergence.** Summing over all admissible smaller factors
$3\le a\le\sqrt X$ and using Mertens
($\sum_{a\le Z}\frac1{\varphi(a)}=\sum_{a\le Z}\frac1a+\sum_a\frac1{a(a-1)}
=\log\log Z+O(1)$, the second sum absolutely convergent):
$$\#\{p\le X:\Omega(p+2)=2\}\ \sim\ 2\Pi_2\,\frac{X\log\log X}{\log^2X}\qquad\textbf{(HEURISTIC)} .$$

**3.3 The same statement in the $\alpha$-variable — the exact location of the
defect.** In §2's parameterization the unrestricted branch is
$$2\Pi_2\frac X{\log^2X}\int_{\alpha_0(X)}^{1/2}\frac{d\alpha}{\alpha(1-\alpha)},
\qquad \alpha_0(X)=\frac{\log3}{\log X},$$
the lower cutoff being the smallest admissible prime factor $a=3$. By Lemma 2.3
this is
$$\log\frac{1-\alpha_0}{\alpha_0}=\log\frac{\log X}{\log 3}+O\Bigl(\frac1{\log X}\Bigr)
=\log\log X-\log\log3+O(1/\log X).$$

> **The $\log\log X$ is the logarithmic divergence of $\int_0 d\alpha/\alpha$ at
> the lower endpoint — i.e. Mertens' $\sum_a 1/\varphi(a)$ over *small* prime
> factors $a$ — and nothing else.** The measure $d\alpha/(\alpha(1-\alpha))$ has
> infinite mass at $\alpha=0$ and finite mass on every $[\theta,1/2]$ with
> $\theta>0$.

**3.4 Why truncation removes it, and why that is not an artifice.** Imposing
$a>p^\theta$ replaces the cutoff $\alpha_0(X)\to0$ by the *fixed* cutoff
$\theta$, deleting exactly the divergent neighbourhood of $0$ and leaving mass
$\log\frac{1-\theta}\theta<\infty$. Two consequences, both needed by the audit:

1. **The unbounded factor disappears** ($\log\log X\rightsquigarrow\log\frac83$),
   so both branches are $\asymp X/\log^2X$ and a fixed relative deficit is
   meaningful;
2. **the $a$-dependent arithmetic disappears too** (Corollary 2.2): on the
   unrestricted envelope the weight is $\mathfrak S(a)/a$, whose $a$-dependence
   $\frac{a-1}{a-2}$ is what makes the constant of §3.2 a Mertens-type sum; on
   the truncated set that factor is $1+O(X^{-\theta})$ and the constant is a
   pure integral.

And the deleted region is not thrown away by fiat: $\{a\le p^{3/11}\}$ is
precisely what a sieve of level $p^{3/11}$ has already removed, so the truncated
set is the set Chen's weighted sieve actually produces. Truncation here is
bookkeeping made honest, not hypothesis.

---

## 4. The δ-target, and what δ is

**Definition 4.1 (δ-target on the truncated set).** There is a fixed $\delta>0$
with $L_T^{3/11}(X)\le(1-\delta)\,C_T^{3/11}(X)$ for all large $X$.

By Proposition 1.4 this is *equivalent, exactly and with no error term*, to
$T(X)\ge\frac\delta2 C_T^{3/11}(X)$; and conversely the least admissible
$\delta$ is
$$\boxed{\ \delta(X)=\frac{2\,T(X)}{C_T^{3/11}(X)}=\frac{2T}{T+S}\ }$$
— δ *is* twice the relative density of twins inside the truncated Chen set.
Note $\delta\in(0,2]$, and $\delta>1$ iff $T>S$ iff $L_T<0$.

**Proposition 4.2 (the δ-target is equivalent to the HL lower bound — PROVED,
modulo two cited unconditional bounds).** Assume the two classical facts
(a) $C_T^{3/11}(X)\gg X/\log^2X$ (Chen-type lower bound; Green–Tao's
quantitative form) and (b) $C_T^{3/11}(X)\ll X/\log^2X$ (upper-bound sieve: sift
$(p,\,p+2)$ simultaneously by primes $<X^{3/11}$ — the same input as the sibling
certificate's §3.D Lemma). Then
$$\text{δ-target}\iff T(X)\gg\frac X{\log^2X}.$$
*Proof.* ($\Rightarrow$) $T\ge\frac\delta2C_T\gg X/\log^2X$ by (a).
($\Leftarrow$) If $T\ge cX/\log^2X$ and $C_T\le C\,X/\log^2X$ by (b), then
$\delta=2T/C_T\ge2c/C>0$. $\square$

**This is the finding.** Factory IV §IV presents
$L_T\le(1-\delta)C_T$ as "a genuine quantitative finish" — something one might
obtain *independently* and then cash in for twin recurrence. On the truncated
set it is not a weaker or a different statement: it is exactly the lower-bound
half of the Hardy–Littlewood twin conjecture at the level of order of magnitude.
The identity of Prop 1.4 is a genuine iff-reformulation (the audit is right that
it survives), but the δ-version does not lower the bar by so much as a
$\log\log$. Any programme that plans to "obtain δ independently" must say what
about the truncated envelope makes $T\gg X/\log^2X$ easier there than anywhere
else; §2 says the envelope contributes no arithmetic to δ at all (Cor. 2.2), so
the answer cannot be arithmetic.

**4.3 The heuristic value of δ (exact closed form).** From §2,
$$\delta_{\mathrm{HL}}=\lim_X\frac{2T}{T+S}=\frac2{1+\log\frac83}
=\frac2{\log\frac{8e}3}
\qquad\bigl(=\tfrac2{1+3\log2-\log3}\bigr),$$
and for general truncation $\theta$, $\ \delta_{\mathrm{HL}}(\theta)=
2/\log\bigl(e(1-\theta)/\theta\bigr)$. By Proposition 2.4,
$\log\frac{8e}3<2$, so $\delta_{\mathrm{HL}}>1$: the heuristic asserts
$L_T^{3/11}(X)$ is eventually **negative**, the twin branch outweighing the
truncated semiprime branch. This is a falsifiable prediction of the bookkeeping,
not a measurement.

**4.4 Identification against the classical near-miss (the sieve-constant
deficit).** Define, for the truncated set,
$$\ell_C=\liminf_X C_T^{3/11}(X)\frac{\log^2X}X,\quad
u_S=\limsup_X S(X)\frac{\log^2X}X,\quad
u_C=\limsup_X C_T^{3/11}(X)\frac{\log^2X}X .$$
Since $T=C_T-S$, any *proved* pair of constants gives
$$T(X)\ \ge\ (\ell_C-u_S+o(1))\frac X{\log^2X},\qquad\text{hence}\qquad
\delta\ \ge\ \frac{2(\ell_C-u_S)}{u_C}\quad\text{whenever }\ell_C>u_S .$$
So the δ-target reduces, arithmetically, to a **single scalar comparison
between two sieve constants on one explicit set**: a lower bound for the union
must beat an upper bound for the semiprime branch alone. Dividing by the
heuristic truth of §2, the requirement is the **efficiency budget**
$$\underbrace{\frac{\ell_C}{2\Pi_2(1+I)}}_{\text{lower-bound efficiency for }C_T}
\cdot
\underbrace{\frac{2\Pi_2 I}{u_S}}_{\text{upper-bound efficiency for }S}
\;>\;\frac{I}{1+I}
=\frac{\log\frac83}{\log\frac{8e}3},\qquad I=\log\tfrac83 .$$
The budget is $<\tfrac12$, and *that it is $<\tfrac12$ is exactly the inequality
$e>\tfrac83$*: $\frac I{1+I}<\frac12\iff I<1\iff\frac83<e$ (Prop. 2.4). So a
would-be proof needs combined efficiency a shade under one half — e.g. both
bounds simultaneously within $\sqrt{(1+I)/I}$ of the truth. That is the exact
statement of how much room the truncation leaves.

**Constants I cannot re-derive — CITED-UNVERIFIED (egress blocked; model memory
only, see §5):**
- the value $\ell_C$ implicit in Chen (1973) / Halberstam–Richert's weighted
  sieve and in Green–Tao's quoted $\gg N/\log^2N$ for Chen primes in $(N/2,N]$
  — the *order* I use freely (it is cited by both the audit and the sibling
  certificate); the *constant* I do not state, because any number I wrote would
  be a guess with the error bars omitted;
- any explicit $u_S$ for the truncated semiprime branch (an upper-bound sieve
  applied to $\mathsf S_\theta$ with the truncation exploited);
- the twin upper-bound constant (Bombieri–Davenport-type, $u_T\le c\cdot2\Pi_2$
  with $c$ classically $4$ and improved several times) — needed only through
  $u_C\le u_T+u_S$;
- the exponent $3/11$ itself: it is an output of Chen's weighted-sieve
  optimization, quoted here from Factory IV §VIII and the audit. Its *role* in
  §2–§3 is only "the smaller factor is $>p^\theta$ for a fixed $\theta>0$", and
  §2's answer is stated for general $\theta$, so nothing here breaks if the
  literature value is $\theta\ne3/11$ — only the numbers $8/3$, $\log\frac83$
  and $\theta^\ast$-comparison of Prop. 2.4 would move.

**4.5 Why the comparison cannot be closed by sieve constants (cited, not
re-proved here).** The sibling certificate's §2 closes category C1 at theorem
grade: any method whose parity contact is value-queries on
$Q_X=\{p+2:p\in\mathsf C^{3/11}\}$ is constant on a gauge coset containing both
the saturated and the δ-deficit assignment (`GAUGE.md` §F.3, Theorem F;
`ChargeCriterion`, `GaugeOrbitClasses`, `ChenProjector`). In the present
coordinates that says: $\ell_C$ and $u_S$ are both computed from the neutral
(divisibility) diagonal, and $\ell_C-u_S$ is the charged coordinate the chart
does not carry. §4.4 is therefore not a to-do list for sieve theory; it is the
exact price tag of the thing sieve theory provably cannot buy. The contribution
of this note to that picture is the number on the tag: the required margin is
$1/\log\frac{8e}3$ per unit of $C_T$, and it is arithmetic-free.

---

## 5. Honesty ledger

**Proved here, unconditionally and elementarily:**
- Lemma 1.3 (disjointness of the branches, via $\Omega$);
- Proposition 1.4, the exact identity $T=(C_T-L_T)/2$ on the truncated set, with
  Remark 1.5 (it is truncation-independent, hence the truncation is not what
  makes it work);
- Lemma 2.3, the integral $\int_\theta^{1/2}\frac{d\alpha}{\alpha(1-\alpha)}
  =\log\frac{1-\theta}\theta$, antiderivative $\log\frac\alpha{1-\alpha}$,
  value $\log\frac83=3\log2-\log3$ at $\theta=3/11$;
- Proposition 2.4's arithmetic core, $e>\frac83$ (four terms of the exponential
  series) and the equivalence $3/11>1/(1+e)\iff e>8/3$;
- the identity $\frac{a-1}{a(a-2)}=\frac1{\varphi(a)}+\frac1{a(a-1)(a-2)}$ (§3.1);
- Proposition 4.2 (δ-target $\iff T\gg X/\log^2X$) — *modulo* the two cited
  unconditional bounds (a),(b), which are classical and not re-proved here.

**Derived, but conditional on the HL heuristic (labelled HEURISTIC at use):**
- Lemma 2.1's singular series $\mathfrak S(a)=2\Pi_2\frac{a-1}{a-2}$ — the local
  computation is exact and self-contained; only its use as an asymptotic density
  is heuristic;
- (H1), (H2) and the summary of §2; §3.2–§3.3's $2\Pi_2X\log\log X/\log^2X$;
  §4.3's $\delta_{\mathrm{HL}}=2/\log\frac{8e}3$.
- *Which theorem each heuristic stands in for:* Hardy–Littlewood Conjecture B
  for the pair $(b,ab-2)$, uniformly in $a\le X^{1/2}$. It is unavailable — it
  contains the twin conjecture at $a=1$-adjacent specializations and, uniformly
  in $a$, is a stronger statement still. This is why §2 is heuristic and §1/§4.2
  are not, and why nothing in §1/§4.2 uses §2.

**Cited, unverified (no literature access from this container; searched against
model memory only):** Chen (1973); Halberstam–Richert, *Sieve Methods* (1974),
Ch. 9–11 for the weighted sieve and the $3/11$ normalization; Green–Tao,
"Restriction theory of the Selberg sieve, with applications" (2006) for
$\gg N/\log^2N$ Chen primes and 3-APs thereof; Bombieri–Davenport and successors
for twin upper-bound constants; Landau / Sathe–Selberg for
$\pi_2(x)\sim x\log\log x/\log x$ (the shape §3 reproduces on the shifted set);
Mertens. **Recorded queries, to be discharged by a successor with egress:**
*"Chen theorem 3/11 both prime factors large"*, *"Green–Tao Chen primes
arithmetic progressions quantitative count"*, *"Hardy–Littlewood heuristic p+2
semiprime both factors large"*, *"density of semiprimes with both factors above
x^theta shifted by 2"*, *"Halberstam Richert weighted sieve Chen constant
explicit"*, *"twin prime upper bound constant Bombieri Davenport Wu Cai"*.
I searched none of these on the web; the flags are not decoration.

**Not done:**
- no explicit $\ell_C$, $u_S$, $u_C$ (§4.4) — deliberately: guessing them is the
  `exp27` failure mode this repository exists to avoid;
- no unconditional statement about $L_T$ itself beyond §4.2's equivalence;
- no proof that $\theta=3/11$ is optimal for anything, and no attempt to
  re-derive it;
- no re-proof of the cited unconditional bounds (a),(b) of Prop. 4.2;
- no formalization (nothing here is in `formal/`; §1 is short enough that
  Prop. 1.4 in the style of `ChenProjector.count-split` would be a natural
  next step, but it is not claimed as done);
- **no numerics of any kind**: no count was tabulated, no constant estimated, no
  fit performed. Every number in this note is a closed form.

**Falsifiers.** (F1) An error in Lemma 2.1's local computation would move the
constant $2\Pi_2$ in §2 but not §1, §4.2, or the $\log\frac{1-\theta}\theta$
shape — check $a=3$ against the direct computation in §2.1. (F2) If the
literature's truncation is not "both factors $>p^{3/11}$" but a weighted or
level-of-distribution condition without a clean exponent, §2's $I(\theta)$ is
replaced by the integral of $d\alpha/(\alpha(1-\alpha))$ against the true
admissible-exponent density, and $\log\frac83$ dies while §3's mechanism
survives. (F3) Proposition 4.2 fails if either cited bound (a),(b) is wrong; (b)
is the same input the sibling certificate's §3.D Lemma rests on, so the two
notes fail together there.

---

## 6. Queue

- `PROVE` Prop. 1.4 in `formal/cubical/` in the two-counter style of
  `ChenProjector.count-split` (it is $1-\lambda=2\cdot\mathbf 1[\Omega=1]$ on
  the envelope, summed; no new primitives needed).
- `SEARCH` the constants of §4.4 ($\ell_C$ for the truncated Chen count; any
  explicit $u_S$) and the six queries in §5 — this is the item that converts
  §4.4's criterion into a decidable comparison.
- `PROVE` the general-$\theta$ statement of §4.2 uniformly in $\theta$, i.e.
  whether the cited (a) survives $\theta\uparrow\theta^\ast=1/(1+e)$; the
  crossover of Prop. 2.4 makes $\theta$ near $\theta^\ast$ the interesting
  regime, since there the two branches are heuristically equal and δ is exactly
  $1$.
- `SEARCH`/`PROVE` (inherited, not attempted here): the sibling certificate's
  P1–P3 items; nothing in this note weakens them, and §4.2 strengthens the case
  that they are the whole difficulty.

— cf-swarm-erdos, 2026-08-16 (lens: Erdős method — elementary counting, minimal
examples, exact constants)
