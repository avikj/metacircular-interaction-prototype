# The adelic layer: critical-BC correlators, sector symmetry, and the two-body decomposition

Companion to `REPORT.md` / `APPENDIX_D.md`. This document assesses and extends the
Bost–Connes/adelic reading of the pair field: the identification of the
Hardy–Littlewood singular series with renormalized critical-BC correlation
functions, the finite-place equivalence of Goldbach and gaps, the reflection
unitarity $JSJ=D$, and the program of a two-body adelic explicit formula. All
identities below are machine-verified in `code/exp8_adelic.py`.

---

## 1. The critical-BC correlator identity: verified, contextualized, strengthened

**Verified (exp8).** With $e_F=\prod_{p\in F}1_{\mathbb Z_p^\times}$, Haar $\mu$ on
$\widehat{\mathbb Z}$, and $C_F(h)=\mu(e_F\,\tau_he_F)/\mu(e_F)^2$:

- the product evaluation $C_F(h)=\prod_{p\in F,\,p\nmid h}\bigl(1-\tfrac1{(p-1)^2}\bigr)\prod_{p\in F,\,p\mid h}\tfrac{p}{p-1}$ agrees with direct counting on $\mathbb Z/30030\mathbb Z$ to $10^{-12}$;
- $C_F(h)\to\mathfrak S(h)$ as $F$ exhausts the primes (e.g. $h=2$: $1.367,1.3228,1.32049,1.320337\to1.320324$);
- the $k$-tuple version with $\nu_p(H)$ forbidden classes is exact (checked for $H=\{0,2,6\}$);
- the Ramanujan expansion $\mathfrak S(h)=\sum_q\mu(q)^2\varphi(q)^{-2}c_q(h)$ converges as claimed.

At $\beta=1$ the unique KMS state of the BC system restricts to additive Haar
measure on the diagonal $C(\widehat{\mathbb Z})$, so the boxed identity
$\mathfrak S(h)=\lim_F \omega_{\beta=1}(e_F u^h e_F u^{-h})/\omega_{\beta=1}(e_F)^2$
is correct as stated.

**Prior art (adversarial duty).** The mathematical content — singular series as
correlations of the "random profinite integer" local model — is the classical
local-density heuristic, and the spectral reading of §3 (Ramanujan–Fourier +
Wiener–Khintchine ⟹ Hardy–Littlewood, heuristically) is due to
**Gadiyar–Padma, Physica A 269 (1999) 503–510** (their unjustified limit
interchange is precisely the minor-arc problem in disguise; see also their
Czechoslovak Math. J. 2014 paper on Conjecture D). The *operator-algebraic
phrasing* — sieve projections in the BC algebra, critical KMS state, Cuntz
$ax{+}b$ unitary implementing translation — appears to be unclaimed, and
"proposition-level new synthesis" is the right classification. The dressing
becomes a *tool*, not a language, at exactly one point, which is new:

**Proposition E0 (criticality of $\beta=1$).** For $0<\beta<\infty$ let
$\mu_\beta$ be the restriction to $C(\widehat{\mathbb Z})$ of the KMS$_\beta$ state
(so $v_p$ is geometric with ratio $p^{-\beta}$ and unit classes are uniform), and
$$C_{F,\beta}(h)=\frac{\mu_\beta(e_F\,\tau_he_F)}{\mu_\beta(e_F)^2}
=\prod_{\substack{p\in F\\ p\mid h}}\frac{1}{1-p^{-\beta}}
\prod_{\substack{p\in F\\ p\nmid h}}\frac{p-2}{(p-1)(1-p^{-\beta})}.$$
Then $\lim_F C_{F,\beta}(h)$ exists and is finite and nonzero **iff $\beta=1$**,
where it equals $\mathfrak S(h)$. (Proof: $\log$ of the $p$-factor is
$p^{-\beta}-p^{-1}+O(p^{-2\beta}+p^{-2})$, and $\sum_p(p^{-\beta}-p^{-1})$
diverges to $+\infty$ for $\beta<1$ and to $-\infty$ for $\beta>1$.)
Numerically (exp8): partial products at $B=10^3,10^4,10^5$ for $h=2$:
$\beta=0.9$: $2.87,4.08,6.11$ (diverges); $\beta=1$: $1.32049,1.32034,1.32032$
(locks to $\mathfrak S(2)$); $\beta=1.1$: $0.77,0.66,0.57$ (dies).

So the existence of renormalized prime-pair local densities *selects the critical
temperature* — equivalently, the pole of $\zeta$ at $s=1$ is re-derived as the
unique temperature at which the arithmetic gas has finite pair correlations.
This is the first statement in this program where the KMS parameter does work
that the bare local model cannot even express.

**Galois remark.** The BC symmetry group $\widehat{\mathbb Z}^\times$ fixes each
$e_F$ (units are Galois-stable), so all correlators above are Galois-invariant —
consistent, but not yet leverage. A genuine BC-theoretic lever would need the
class-field action to move a sieve-type projection nontrivially; none of the
natural projections here does.
**[Update — exp21_fingerprints / `FAMILY.md`: the lever exists; the family provides it.
The finite-place fingerprints split into three visibility classes: $\Lambda$
is visible to the Galois-invariant (Ramanujan) algebra (atoms
$|\mu(q)|/\varphi(q)$, projections $\mu(q)$ — measured to 4 decimals);
$\Lambda\chi_3$ has *vanishing* Ramanujan projections but nonzero individual
atoms ($\sin(2\pi/3)=0.8661$ at levels 3, 6), and the class-field action
$u=2$ moves its level-3 atom by exactly $\chi(2)=-1$ while fixing
$\Lambda$'s; $\lambda,\mu$ are invisible at every level. The character
sector is precisely the part of the BC diagonal on which
$\widehat{\mathbb Z}^\times$ acts nontrivially — the twisted pair fields
(exp20_dirichlet) are the objects this lever moves.]**

---

## 2. The reflection symmetry, and a new rigidity consequence

The $J$-unitarity is correct and worth stating exactly: on
$\ell^2(\mathbb Z\setminus\{0\})^{\otimes2}$ with $J|m,n\rangle=|-m,n\rangle$:
$JSJ=D$, $JDJ=S$, $J(W\otimes W)J=W\otimes W$ for any even weight
$W=\Lambda(|N|)$. Goldbach pairs are signed gaps crossing the origin; the
$S/D$ distinction — hence the entire holomorphic/Hermitian dichotomy of
`REPORT.md` §6 — is the choice of the positive cone, i.e. archimedean. At
finite places the two problems are literally isomorphic via $y=-x$ (unit-ness is
even), which *explains structurally* the identical singular series that exp4
measured (ratios 0.99997/0.99925 on the two marginals).

This has a consequence for Theorem A that neither document had:

**Proposition E1 (the phase problem is an artifact of the positive cone).**
Let $a:\mathbb Z\to\mathbb R_{\ge0}$ be finitely supported and **even**
($a_{-n}=a_n$). Then its autocorrelation equals its additive convolution,
$c_a=a*a$; hence by Theorem A(i) the difference marginal is **injective** on
even nonnegative sequences. Consequently, for any homometric pair $A\not\cong B$
of subsets of $\mathbb N$ (Theorem A(ii)), the symmetrizations
$A\cup(-A)$ and $B\cup(-B)$ are *not* homometric.

*Proof.* $c_a(h)=\sum_n a_na_{n+h}=\sum_n a_{-n}a_{n+h}\overset{m=-n}{=}
\sum_m a_ma_{h-m}=(a*a)(h)$. Injectivity is Theorem A(i); the last claim follows
since equal symmetrized autocorrelations would force equal symmetrized sets,
hence $A=B$. $\square$

**Verified (exp8):** the minimal homometric pair $\{0,1,2,6,8,11\}\sim\{0,1,6,7,9,11\}$
has identical gap data on the positive cone (`True`) and distinct gap data after
symmetrization (`False`), with $c_{\tilde a}=\tilde a*\tilde a$ holding to machine
precision. **Crystallographic phase loss for difference data is exactly the
restriction to a half-line**; on the full signed line, gap data *is* Goldbach
data. This closes the conceptual loop: Theorem A's homometry, the
holomorphic/Hermitian dichotomy, and the archimedean sector-breaking are one
phenomenon seen three ways.

**Sector decomposition (verified to machine precision).** For the symmetrized
weight $\tilde\Lambda(n)=\Lambda(|n|)$:
$$r_{\tilde\Lambda}(N)\;=\;\underbrace{r_\Lambda(N)}_{\text{Goldbach sector}}
\;+\;2\!\!\underbrace{c_\Lambda(N)}_{\text{gap sector}},$$
e.g. $N=10^4$ in window $2\cdot10^5$: $16{,}855+2\cdot335{,}364=687{,}583$ ✓.
Positivity of the symmetrized field is the statement *"every even $N$ is a sum
or a difference of two prime powers"* — strictly weaker than Goldbach, still
open for primes as stated (the difference version, "every even number is a
difference of two primes," is itself open, though Chen-type results give
$p-P_2$), but the decomposition quantifies how lopsided the sectors are: at
$N\ll X$ the gap sector dominates by orders of magnitude, and the two sectors
exchange dominance as $N\to X$ purely through the archimedean geometry of the
constraint segment — the singular series being sector-blind.

---

## 3. Theorem E: the two-body adelic decomposition (the boxed target, made precise)

> **Corrected downstream, and the correction is now a theorem.**
> `notes/E2_PROOF.md` §1.5 confirms the correction to this section: the
> single-zero layer needs a pole at $s=1$ in one factor, $A^\flat$ has none,
> so $[\flat\flat]$ **cannot** contain it — "pole × zero" is literally
> $\operatorname{Res}_{s=1}\times\operatorname{Res}_{s=\rho}$.  It also adds a
> refinement this section misses: $[\flat\flat]$ *does* carry single-$\gamma$
> lines at $w=\rho+1-j$, scale $X^{3/2}$.  Pointer added 2026-08-23 because
> the correction existed and nothing here named it, so a reader landing on
> this section could not reach it.

The requested object — *actual $\Lambda$-pair kernel = critical-BC/local kernel
+ global zero-spectrum correction, with Goldbach and gaps as archimedean sectors
of one kernel* — can be constructed canonically. Here is the precise scheme and
an honest account of what it does and does not buy.

**The canonical projector.** On the Besicovitch space of almost-periodic
arithmetic functions with mean inner product
$\langle f,g\rangle=\lim_X X^{-1}\sum_{n\le X}f(n)\overline{g(n)}$, the
functions with profinite frequency of exact denominator $q$ (primitive
$q$-periodic waves) span orthogonal blocks indexed by $\mathbb Q/\mathbb Z$ —
which is exactly the spectrum of the BC diagonal $C^*(\mathbb Q/\mathbb Z)\cong
C(\widehat{\mathbb Z})$. Hardy's classical computation gives the projection of
$\Lambda$ onto the level-$q$ block as $\tfrac{\mu(q)}{\varphi(q)}c_q(n)$. Define
$$\Lambda^\sharp_Q=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q,\qquad
\Lambda^\flat_Q=\Lambda-\Lambda^\sharp_Q .$$
$\Lambda^\sharp_Q$ is *not* an ad-hoc circle-method approximant: it is the
conditional expectation of $\Lambda$ onto the BC diagonal at profinite
resolution $Q$. (Its Mellin dual: $\Lambda^\flat$ carries the archimedean
frequencies — the zeros.)

**The decomposition.** For any two-variable statistic $f$:
$$\sum_{m,n}\Lambda(m)\Lambda(n)f(m,n)
=\underbrace{[\sharp\sharp]}_{\text{BC block}}
+\underbrace{[\sharp\flat]+[\flat\sharp]}_{\text{mixed}}
+\underbrace{[\flat\flat]}_{\text{zero block}}.$$

- **BC block.** A finite exact computation reducing, after renormalization, to
  the critical correlators of §1: for $f$ supported on the line $m+n=N$ (resp.
  $m-n=h$) it produces $\mathfrak S(N)\cdot I_\infty^{+}(N)$ (resp.
  $\mathfrak S(h)\cdot I_\infty^{-}(h,X)$), where $I_\infty^{\pm}$ are the
  archimedean integrals over the constraint segment intersected with the chosen
  sign sector. *The finite-adelic factor is sector-blind (§2); the sectors
  differ only in $I_\infty$.* This is the precise sense in which "Hardy–Littlewood
  local arithmetic = renormalized critical-BC $k$-point functions" enters an
  actual prime-counting identity.
- **Zero block.** In the Goldbach sector with one Cesàro smoothing, the
  $[\flat\flat]$ block is the **double**-zero (pair) sum of Theorem D with the
  $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ weights: *evaluable from zero
  locations alone.* **[Corrected + verified, exp11_blocks / `BLOCKS.md` §1:** the
  *single*-zero sums arise from the pole × zero cross term and therefore live in
  the **mixed** block, not here; measured: $[\flat\flat]$ matches the pair model at
  corr 0.9997, and its single-$\gamma$ lines are $\sim4000\times$ smaller than the
  mixed block's.**]** In the gap sector at fixed $h$ it is a bilinear form on
  the zeros concentrated near the diagonal $\gamma\approx\gamma'$: *evaluable only
  given pair-correlation information.* The provability asymmetry of the two
  sectors (REPORT §6) is thus a property of one kernel's two sector
  projections — as demanded.
- **Mixed blocks.** Vanish in Besicovitch mean by orthogonality (verified,
  exp11_blocks: means $\approx10^{-4}$), but are **not pointwise small**: they carry the
  entire single-zero layer $-2\sum_\rho X^{\rho+2}/(\rho(\rho+1)(\rho+2))$ at scale
  $X^{5/2}$ (corr 1.0000 with the model — `BLOCKS.md` §1). Their *uniform*
  control in the sector parameter is the large sieve on average and the
  minor-arc problem pointwise.

**Honest assessment (canonical vs. circle-method rearrangement).** The blocks
are canonical (orthogonal projections in adelic harmonic analysis; no arbitrary
major/minor arc cut — $Q$ enters only as a resolution filtration, and
$Q\to\infty$ limits of each block exist in the smoothed sectors). What the
construction does *not* do is convert the minor-arc estimate into algebra: the
pointwise control of $[\sharp\flat]$ and $[\flat\flat]$ against a *fixed-$h$ or
fixed-$N$ sector functional* remains exactly the open uniformity problem, now
localized in two specific matrix blocks. The gain is organizational but real:
(i) every provable statement in this program (Thms C, D; Fujii; LZ;
Goldston–Montgomery; the Bhowmik–Grimmelt-type "sparse Hardy–Littlewood
hypotheses exclude exceptional zeros" phenomenon) is a statement about a named
block in a named sector; (ii) the conjectures divide cleanly into *block
positivity* (Goldbach: BC block dominates the zero block pointwise in the
$+{+}$ sector) and *block correlation* (gaps: the zero block's diagonal
concentration); (iii) Proposition E0 pins the entire BC block to the critical
temperature, so the decomposition is not tunable — it is forced.

> **[Conditionality added in place by SEED-114, 2026-08-14, Rule K1/K3, from
> `notes/SEED77_BLOCKS_POSTCONDITION.md` §3.** Item (ii) — *block positivity*,
> "BC block dominates the zero block pointwise in the $+{+}$ sector" — is a
> statement about the blocks **by size**, i.e. SEED-77's `P_arith`. What
> `BLOCKS.md` proves is `P_spec`: disjointness of $\log X$ frequency supports
> and the coefficient-$2$ mixed-block identification, *after* frequency-$0$
> detrending. SEED-77 derives (not measures) the range in which `P_spec`
> upgrades to `P_arith`:
> $$X^{1/2+\varepsilon}\ll Q=o(X),$$
> the upper constraint from `BLOCKS.md`'s own Lemma
> ($\ll X^{3/2}\sum_{q\le Q}\mu^2(q)q/\varphi(q)\asymp QX^{3/2}$, relative
> $Q/X$), the lower from the singular-series tail
> ($\mathfrak S_Q-\mathfrak S\ll_\varepsilon Q^{-1+\varepsilon}$, giving a
> smooth deficit $Q^{-1+\varepsilon}X^3$ that must sit below $X^{5/2}$).
> **Consequently the sentence above should be read as conditional on
> $X^{1/2+\varepsilon}\ll Q=o(X)$.** In particular the clause three lines
> earlier, "$Q$ enters only as a resolution filtration", is true of the
> *construction* but not of item (ii)'s use of it: outside the window the
> smooth truncation deficit exceeds the $X^{5/2}$ layer by a factor
> $X^{1/2}/Q$, so no pointwise size comparison between blocks is available at
> the fixed $Q\in\{1,10,30,100\}$ of the cited measurements. The measured
> correlations quoted in the bullets above (corr $0.9997$, corr $1.0000$) are
> band-passed statistics and support `P_spec` only.
> SEED-77 §5 explicitly **declined** to make this edit ("let the next block
> propagate it deliberately") and queued it; this is that propagation. No
> statement of §3 is retracted — a hypothesis is recorded.**]**

**Next derivations in order of tractability.**
1. ~~Write out $[\sharp\sharp]$ for the smoothed Goldbach sector at finite $Q$ and
   verify numerically that the blocks reproduce $G_1(X)$.~~ **Done — exp11_blocks /
   `BLOCKS.md` §1 (Theorem E2):** exact closure to $2\times10^{-13}$; each spectral
   layer sits in exactly one block ($[\sharp\sharp]$ smooth, mixed = single-zero
   layer, $[\flat\flat]$ = pair layer); Hardy projection and $Q$-orthogonality
   verified.
2. The $\beta$-deformed pair field: compute the full BC-block flow in $\beta$
   and identify what arithmetic function replaces $\mathfrak S$ in the scaling
   window $\beta\to1^\pm$ (Proposition E0 suggests a logarithmic scaling law —
   the "specific heat" of the prime gas at its phase transition).
3. The Krein/screw join of `APPENDIX_D.md` §D.6, now with the BC block
   subtracted first — the natural guess is that Matsumoto–Suzuki's screw
   function is precisely the Krein transform of the zero block alone.
   **[Update, exp12_krein / `BLOCKS.md` §2: the naive positivity of
   $\sum W_{ij}\delta_{\gamma_i+\gamma_j}$ is refuted — the measure is chirped with
   phase law $\arg W=-(\gamma+\gamma')H(\gamma/(\gamma+\gamma'))-5\pi/4$ (Theorem D‴)
   and equidistributing atom phases; any screw join must go through the
   Hermitian square $|W|^2=2\pi(\gamma+\gamma')^{-5}$, and by the corrected block
   attribution the screw kernel should pair with the *mixed* (first-variation)
   block.]**
