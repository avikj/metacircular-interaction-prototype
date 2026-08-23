# The width of the parity barrier: two failure layers and the uniformity ladder

Companion to `PARITY.md` §2.2(2) (which posed this as target 5), `GAUGE.md`
§F.6 (which restated it), and `BUCHSTAB_WINDOW.md` (Codex's polynomial-depth
bridge, whose mean-defect regime is exactly the *first* of the two layers
separated below). Numerics: `code/exp24_width.py`, `figures/exp24_width.png`.

Honesty header: everything cited below is classical or recent published work;
the contribution of this note is (i) the assembly of the uniformity ladder in
one normalization, (ii) the two-layer separation of the barrier's failure
modes and the resulting "infinite width in the exponent scale" formulation,
and (iii) the measurement that the barrier is *invisible* at polynomial level
— which is itself the content, not a failed detection. Citations whose
journal data I could not re-verify from this offline session are marked
[cite-check].

---

## 1. Setup and normalization

For the Liouville function $\lambda=(-1)^\Omega$ put
$$D_\lambda(X;q,a)=\sum_{\substack{n\le X\\ n\equiv a\ (q)}}\lambda(n),
\qquad
W(Q;X)=\max_{q\le Q}\ \max_{a\bmod q}\ \frac qX\,|D_\lambda(X;q,a)| .$$
$W(Q;X)\to0$ is the quantitative form of $E_Q[\lambda]=0$ — blindness of the
level-$Q$ profinite conditional expectation (the BC-diagonal projector of
`ADELIC.md` §3) to the parity charge. The **exponent scale** is
$\theta=\log Q/\log X$. Two kinds of savings must be kept separate:

- **log-savings**: $|D_\lambda|\ll_A (X/q)\log^{-A}X$;
- **power savings**: $|D_\lambda|\ll (X/q)\,X^{-\delta}$ for fixed $\delta>0$.

The distinction is not cosmetic: §3 shows power savings at even a *single*
real character is Siegel-zero-hard.

## 2. The uniformity ladder (best known levels)

**(a) Individual moduli, Siegel–Walfisz regime: $Q=\log^AX$, log-savings,
ineffective.** For every $A,B>0$,
$$\sup_{q\le(\log X)^A}\ \sup_{a\bmod q}|D_\lambda(X;q,a)|
\ll_{A,B} X(\log X)^{-B},$$
with ineffective constant (Siegel). This is the classical Siegel–Walfisz
theorem transported to $\lambda$ (equivalently $\mu$; see Iwaniec–Kowalski,
*Analytic Number Theory*, Cor. 5.29 for the $\mu$ statement; $\lambda=\mu*
1_{\square}$ transfers it). Note the savings are log-power only. Power
savings here is a different world: already at $q=1$,
$\sum_{n\le X}\lambda(n)\ll X^{1-\delta}$ for some $\delta>0$ is equivalent to
$\zeta(s)\ne0$ in $\Re s>1-\delta$ (Landau's classical equivalence); under RH
one gets $X^{1/2+\varepsilon}$, and under GRH the same uniformly in
$q\le X^{1-\varepsilon}$, i.e. **conditionally the whole ladder collapses to
one line: GRH $\Rightarrow$ $\theta$-uniformity up to $1$ with square-root
savings.** Everything below is about what is *unconditionally* known.

**(b) Averaged moduli, Bombieri–Vinogradov regime: $Q=X^{1/2}\log^{-B}X$,
log-savings on average.** BV *does* hold for $\lambda$: for every $A>0$ there
is $B=B(A)$ with
$$\sum_{q\le X^{1/2}(\log X)^{-B}}\ \max_{a\bmod q}
|D_\lambda(X;q,a)|\ \ll_A\ X(\log X)^{-A}.$$
This is contained in Motohashi's induction principle for Bombieri-type
theorems (Y. Motohashi, *An induction principle for the generalization of
Bombieri's prime number theorem*, Proc. Japan Acad. **52** (1976), 273–275),
which covers Möbius-like coefficients; the modern systematic treatment is the
multiplicative-function framework of Granville–Harper–Soundararajan
(pretentious mean-value theory) as executed by Granville–Shao, *Bombieri–
Vinogradov for multiplicative functions, and beyond the $x^{1/2}$-barrier*
(2018) [cite-check for journal]: any 1-bounded multiplicative $f$ satisfying
a Siegel–Walfisz hypothesis obeys BV to level $X^{1/2-\varepsilon}$, and for
$\mu$-like $f$ (which do not pretend to be $\chi(n)n^{it}$) they push the
level *beyond* the half barrier, to $X^{20/39-\varepsilon}$ for fixed residue
classes — ~~the only known crossing of $\theta=1/2$ in any averaged sense~~
**[CORRECTED 2026-08-14 by `cf-tessera-02`, per `FRONTIER_2026_MAP.md` rows
A5/A6 (śabda grade, `WebFetch` EGRESS_BLOCKED): FALSE AS WORDED. Lichtman,
arXiv:2309.08522, gives primes level of distribution $66/107\approx0.617$ with
triply-well-factorable weights, and Pascadi, arXiv:2505.00653, gives
$5/8=0.625$ for primes and smooth numbers. Both cross $\theta=1/2$ in an
averaged sense. The defensible statement is the narrow one this note's object
$D_\lambda$ actually needs: **the Granville–Shao $20/39$ is the only crossing
known for $\lambda$/$\mu$-type multiplicative functions.** Nothing this note
proves depends on the uniqueness claim — Lemma W1 and the infinite-width
statement are untouched. The note's §4 taxonomy also omits the
Helfgott–Radziwiłł expander layer (arXiv:2103.06853, `FRONTIER_2026_MAP.md`
A8) and its two-point-correlation state of the art is Tao-era rather than
Pilatte-era (arXiv:2310.19357, A7); those are gaps, recorded here, not
corrected here.]**
Earlier work on multiplicative functions in progressions on average: Elliott;
Balog–Granville–Soundararajan, *Multiplicative functions in arithmetic
progressions* (2013) [cite-check]. So: **$\theta_{\rm avg}=1/2$ (plus
$\varepsilon$-crossings), log-savings, unconditional.**

**(c) Conjectural ceiling, Elliott–Halberstam regime: $Q=X^{1-\varepsilon}$.**
The $\lambda$-analog of Elliott–Halberstam (same shape as (b) with
$Q=X^{1-\varepsilon}$) is conjectured and completely open for every
$\theta>20/39$ in any form. The *endpoint* $Q=X/(\log X)^B$ is provably
false: the Maier-matrix oscillation results of Friedlander–Granville
(*Limitations to the equi-distribution of primes I*, Ann. of Math. **129**
(1989), 363–382) and Friedlander–Granville–Hildebrand–Maier (*Oscillation
theorems for primes in arithmetic progressions and for sifting functions*,
J. Amer. Math. Soc. **4** (1991)) show equidistribution fails at
$Q=X/\log^BX$ for the prime-counting sequence, and the same matrix method
obstructs $\mu$/$\lambda$-type sequences. So $\theta=1$ is a genuine ceiling
for the *entire* additive-sampling framework: **all finite results, and all
conjecturally attainable ones, live at $\theta\le1$.**

**(d) What primality certification actually needs:
$Q_{\rm cert}(X)=\exp((1+o(1))\sqrt X)$.** By the sampling identity of the
affine update (§F, audited in `PARITY.md` §1):
$1_{\mathbb P}(n)=V(\sqrt n)\,\mathcal G_{\sqrt n}(\Delta n)$ — primality of
$n\le X$ is a *residue* statement, but at the profinite level
$M(z)=\prod_{p\le z}p=e^{(1+o(1))z}$ with $z=\sqrt X$. Certifying primality
(equivalently, resolving the parity of $\Omega$ pointwise on the rough set)
through congruence data alone therefore requires controlling residue means at
modulus level $\exp((1+o(1))\sqrt X)$, while only $X$ samples are available
(§G's geometric obstruction). On the exponent scale,
$$\theta_{\rm cert}(X)=\frac{\log Q_{\rm cert}}{\log X}
=(1+o(1))\frac{\sqrt X}{\log X}\ \longrightarrow\ \infty .$$

**Theorem-level summary (the width statement).**
*On the exponent scale $\theta=\log Q/\log X$, the parity barrier has
infinite width. Unconditionally: individual uniformity is known only at
$\theta=0$ (with log-savings, ineffectively); averaged uniformity is known
at $\theta=1/2$ (Motohashi/Granville–Shao, log-savings, with an
$\varepsilon$-crossing to $20/39$); the conjectural ceiling of the entire
framework is $\theta=1$ (EH-analog; the endpoint provably fails). Pointwise
primality certification through the sampling geometry requires
$\theta_{\rm cert}\sim\sqrt X/\log X\to\infty$: it does not sit at any finite
exponent. The distance from every attainable result to the certification
level is therefore not a numerical gap to be narrowed but a change of scale
— finite results live at exponent $\le1$; certification needs
superpolynomial level.*

## 3. Why individual power savings is Siegel-hard (the sharpest open question)

**Lemma W1.** Let $q$ be fixed and suppose
$\max_a|D_\lambda(X;q,a)|\ll X^{1-\delta}$ for some $\delta>0$ and all large
$X$. Then every Dirichlet $L$-function $L(s,\chi)$ with $\chi$ real mod $q$
has no zeros in $\Re s>1-\delta$ — an *effective* Siegel-zero-free region for
the modulus $q$.

*Proof sketch.* Character orthogonality turns the hypothesis into
$\sum_{n\le X}\lambda(n)\chi(n)\ll X^{1-\delta}$ for each $\chi$ mod $q$. For
real $\chi$, the Dirichlet series is
$$\sum_{n\ge1}\frac{\lambda(n)\chi(n)}{n^s}
=\frac{L(2s,\chi^2)}{L(s,\chi)}
=\frac{\zeta(2s)\prod_{p\mid q}(1-p^{-2s})}{L(s,\chi)},$$
and a partial-summation/Landau argument converts the power-saving partial
sums into analyticity of $1/L(s,\chi)$ — hence non-vanishing of $L(s,\chi)$ —
in $\Re s>1-\delta$. $\square$

So the ladder's fine print is forced: **power savings at even one real
character of one modulus already yields an effective zero-free region**,
which is beyond current technology (this is the quantitative face of the
ineffectivity in rung (a)). The sharpest open question in this direction is
therefore surprisingly small:

> **Open question (one modulus past the barrier).** Exhibit any
> $\varepsilon>0$ and any infinite sequence of moduli $q\sim X^{1/2+
> \varepsilon}$ with a bound $\max_a|D_\lambda(X;q,a)|=o(X/q)$ — even with
> savings $(\log X)^{-1}$, even for special $q$ (smooth, prime, ...). Any
> such *individual* estimate beyond $\theta=1/2$ would break genuinely new
> ground; ~~the averaged $20/39$ of Granville–Shao is the only crossing known,
> and it cannot isolate a single modulus.~~ **[CORRECTED 2026-08-14, same
> correction as §2(b): the averaged $20/39$ of Granville–Shao is the only
> crossing known *for $\lambda$/$\mu$-type multiplicative functions*, and it
> cannot isolate a single modulus. For primes the averaged record is
> $5/8$ (Pascadi arXiv:2505.00653), after $66/107$ (Lichtman
> arXiv:2309.08522). The open question as posed — an *individual* estimate
> past $\theta=1/2$ for $D_\lambda$ — is unaffected by either.]**

The Siegel-zero connection cuts both ways, and recent work makes the
converse direction precise: *if* Siegel zeros exist infinitely often, then
$\lambda$'s correlations become computable in their vicinity —
Heath-Brown, *Prime twins and Siegel zeros*, Proc. London Math. Soc. **47**
(1983), 193–224 (twin primes from Siegel zeros), and Tao–Teräväinen, *The
Hardy–Littlewood–Chowla conjecture in the presence of a Siegel zero*
(arXiv:2109.06291) [cite-check for published version], which proves
Chowla-type correlations of $\lambda$ in the exceptional regime. In the
language of `GAUGE.md`: an exceptional character is a finite-place probe
that *almost* carries the parity charge ($\lambda$ pretends to be $\chi$),
and in its presence the charged sector briefly becomes computable. The
dichotomy "either no Siegel zeros (effectivity, zero-free regions) or
computable parity correlations" is the individual-modulus face of the
barrier's width.

## 4. The two failure layers (naming the width's anatomy)

Codex's `BUCHSTAB_WINDOW.md` supplies the missing lower layer, and the two
must not be conflated; the barrier fails in *two structurally different
ways* at the two depths.

**Layer 1 — the density-defect layer (Buchstab layer). Polynomial depth,
archimedean, deterministic, correctable.** At sieve depth $w=X^{1/u}$ (fixed
$u$), the finite-adic model $\nu_{W(w)}$ has the *right* local correlations
but the *wrong one-body mean* on $[1,X]$:
$$\frac1X\sum_{n\le X}\nu_W(n)\longrightarrow e^\gamma\omega(u)\ne1$$
(`BUCHSTAB_WINDOW.md` §3). The defect is the Buchstab oscillation: an
archimedean boundary effect, exactly computable, removed by the corrected
density $\widetilde\nu_{X,w}$ (their Theorem 4.1), with variance law
$1-1/(u\omega(u))$ and the $u=2$ endpoint exhausted by the deterministic
$\log$-weight mismatch (their §5 — explicitly *not* a hidden zero field, and
not parity). In this layer the model's mean is wrong but *everything is
visible and finite*: the defect is a known function of $u$.

**Layer 2 — the equidistribution-defect layer (charge layer). Superpolynomial
level, arithmetic, invisible, uncontrolled.** To pass from density statements
on the rough set to *pointwise* parity (primes vs. semiprimes — precisely the
population entering at $u>2$ in Layer 1), the sampling geometry demands
residue control at level $Q_{\rm cert}=e^{(1+o(1))\sqrt X}$. There, no
theorem controls $E_Q[\lambda]$ at all — not the size, not the sign: **the
mean itself is uncontrolled**, and by `GAUGE.md` Theorem F the equilibrium
carries exactly zero information about it (the charged sector has vanishing
expectation identically, so there is nothing for a sieve-type argument to
converge *to*). All unconditional control stops at $\theta\le1/2$ on
average, $\theta=0$ individually.

The separation in one line:

> **At polynomial depth the model's mean is wrong by a computable
> archimedean factor ($e^\gamma\omega(u)$ — Layer 1, the Buchstab layer); at
> superpolynomial level the arithmetic's mean is not wrong but *unknown*
> (Layer 2, the charge layer). The parity barrier's width is the extent of
> Layer 2: infinite on the exponent scale, and starting exactly where
> Layer 1's corrections end.**

This also disambiguates a possible misreading of `BUCHSTAB_WINDOW.md` §5:
the vanishing of the naive variance coefficient at $u=2$ and its
deterministic resolution are Layer-1 phenomena; they neither witness nor
contradict the parity barrier, which lives entirely in Layer 2.

## 5. Numerics (exp24): the barrier is invisible at polynomial level — and that is the measurement

`code/exp24_width.py`, $X=2\times10^6$, all squarefree $q\le50$ plus 160
log-spaced squarefree $q\le3000$, exact residue bucketing of $\lambda$.
Random model for comparison: each residue class holds $\sim X/q$ signs, so
$W(q)\approx\sqrt{2q\log q/X}$ (max of $\sim q$ half-normals).

| $Q$ | $W(Q)$ measured | random model $\sqrt{2Q\log Q/X}$ |
|---|---|---|
| 10 | 0.0056 | 0.0048 |
| 50 | 0.0135 | 0.0140 |
| 300 | 0.0386 | 0.0414 |
| 1000 | 0.0770 | 0.0831 |
| 3000 | 0.1376 | 0.1550 |

Departure ratio $W(q)/\sqrt{2q\log q/X}$ over all 160 sampled moduli:
median $0.894$, max $1.528$ (at $q=5$, an ordinary small-$q$ fluctuation),
min $0.560$; worst progression overall $q=2837$, $a=2421$. Global check:
$\sum_{n\le X}\lambda(n)=-1234$, well inside $\sqrt X\approx1414$.

**Reading.** Square-root cancellation holds in every measured progression;
nothing distinguishes $\lambda$ from a Bernoulli sequence at any modulus
accessible to any polynomial-scale experiment ($\theta\le0.55$ here). This
is the expected null result stated positively: *the parity barrier casts no
shadow at polynomial level.* Its width is not measurable from inside the
window — exactly as the two-layer statement predicts, since every
observable at this level is a Layer-1 (neutral-sector) quantity, and the
figure `figures/exp24_width.png` is a picture of the charge layer's perfect
camouflage. Contrast `figures/exp10_parity.png` (atom deaths): exp10 showed
the *spectral* blindness at fixed frequency; exp24 shows the *uniform*
blindness over all moduli up to the polynomial horizon, with the random
model overlaid.

## 6. Status

- Ladder (a)–(c): assembled from the cited literature; nothing new claimed.
  (d) and the width formulation: new packaging of the affine §F/G geometry.
- Lemma W1: standard argument, stated here because it pins the *reason*
  individual results stop at $\theta=0$ with log-savings.
- Two-layer separation: new organization joining `BUCHSTAB_WINDOW.md`
  (Layer 1) to `GAUGE.md`/`PARITY.md` (Layer 2); proposed as the program's
  canonical answer to "how wide is the parity barrier?"
- Open: the one-modulus-past-the-barrier question of §3; and whether the
  graded-KMS route (`PARITY.md` §2.2(1), closed as a no-go in `CORE_KMS.md`)
  admits any *non-equilibrium* refinement that sees Layer 2 at finite level.
