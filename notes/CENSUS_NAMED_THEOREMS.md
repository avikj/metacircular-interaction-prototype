# Census of named theorems living in prose

*Compiled 2026-08-23 from the corpus's own indices (`REPORT.md`, `INDEX.md`,
`METHOD.md`, `HOLOGRAM.md`, `JEWELS.md`, `ATLAS_OF_N.md`) and the notes they
point to. Scope: PROVED mathematical results whose primary home is a prose
derivation in `notes/`, whether or not a formal term also exists. Statements
are compressed to one or two lines; the note cited is the proof's home, not
merely a mention. Status vocabulary: **proved** (derivation complete,
unconditional unless a hypothesis is named); **proved-with-strikes** (claim
stands but the note carries recorded corrections/retractions en route);
**conditional** (hypotheses named); **assembled** (proof is a join of cited
literature results, correctly attributed); **derived scaling** (no empirical
input remains, but a heuristic closure step blocks theorem status). RH =
Riemann Hypothesis; SZ = simple zeros; Gonek = $\sum_\gamma|\zeta'(\rho)|^{-2}\ll T^{1+o(1)}$.*

File name kept as the commissioning instruction specified; this is apparatus
(an index of the book's proofs), not a chapter.

---

## The table

| # | Theorem | Statement (compressed) | Proved in | Formal term | Status |
|---|---|---|---|---|---|
| **A. Explicit-formula / trace-formula lane (analytic number theory)** |
| 1 | **Theorem A** (marginal rigidity) | $r_a=r_b\Rightarrow a=b$ for nonnegative sequences (sum marginal injective, integral-domain squares); difference marginal has exactly the classical homometry kernel; heat resolution restores completeness. | `REPORT.md` §2 | existence half of A(2): `formal/cubical/HomometricPair.agda` (checked) | proved; A(1) is Lambek–Moser 1959 folklore per `INVERSE.md` attribution |
| 2 | **Theorem A′** | If the non-cyclotomic part of $F_X=\sum_{p\le X}x^{p-2}$ is irreducible, any $B$ with $c_B=c_{P_X}$ is a translate/reflection of $P_X$. | `REPORT.md` §2.1 (+ `REDTEAM.md` patches) | — | proved-with-strikes, conditional on irreducibility; superseded by A″ |
| 3 | **Theorem A″** (prime phase rigidity) | For every $X\ge3$, any finite $B\subset\mathbb Z$ with $c_B=c_{P_X}$ is a translate of $P_X$ or its reflection — unconditional, via singleton parity (after shift by 2: one even element, rest odd). | `PARITY_RIGIDITY.md`; `REPORT.md` §2.1 | layers 2–3 in `formal/pairfield/Pairfield/ParityRigidity.lean` (`core`, `rigidity_normalized`); translation bookkeeping + prime corollary **not** checked | **proved, unconditional**; partially formalized |
| 4 | **Theorem B / B′** (intertwining; aperture law) | In the zero-pair expansion of $Z$, $\log r$ is conjugate to $\gamma+\gamma'$ and $\arg z$ to $\gamma-\gamma'$, marginal-to-marginal; truncation error $\varepsilon$ needs $\gamma_{\max}\gtrsim(\theta/t)\log(1/\varepsilon)$. | `REPORT.md` §3 | — | proved under RH (Stirling); frequency-support statement stands, phase mixing added by G |
| 5 | **Theorem C** (smoothing trivialization) | RH $\iff \sum_N(\Lambda*\Lambda)(N)e^{-Nt}=(1/t-\log2\pi)^2+O(t^{-3/2-\varepsilon})$ — a two-line algebraic equivalence via square-root uniqueness; the sharp-cutoff difficulty is the cutoff's, not the arithmetic's. | `REPORT.md` §4 | — | **proved, unconditional equivalence** |
| 6 | **Theorem D / D′** (sum-spectrum identity; weight law) | Under RH, $G_1(X)=X^3/6-2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}+\sum_{\rho,\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}+O(X^2)$; $\lvert W\rvert\asymp(\gamma+\gamma')^{-5/2}$ same-sign, exponentially suppressed opposite-sign. | `REPORT.md` §5 | — | proved under RH; identity is Languasco–Zaccagnini $k{=}1$, rederived with attribution |
| 7 | **DPP Theorem 1** (D′ sharpened) | $\lvert W\rvert\le\sqrt{2\pi}\,s^{-5/2}$ for **every** same-sign pair, unconditionally; $\lvert W\rvert^2=2\pi s^{-5}(1+\theta)$, $-0.0063\le\theta\le0$ — derives exp12's measured 0.31% as $\tfrac52 s^{-2}$. | `DPP.md` §1 | — | proved, exact and elementary (no Stirling) |
| 8 | **Theorem D″ resolved** (DPP 2, 3, 6, 7, 8) | Under RH: $V(T,L)\to V_\infty=\sum_f\lvert\widetilde m(f)\rvert^2$ uniformly in $u_0$; $\limsup_x\lvert\Delta(x)\rvert/x^2\ge1.27\times10^{-3}$ (Ω-result under RH alone, by an order argument); $cD\le V_\infty\le CD$; $V_\infty=D$ iff the sum spectrum is simple (under SSH). | `DPP.md` §§2–4 (correcting `APPENDIX_D.md` §D.4) | — | proved under RH; constant-1 question open, equivalent to sum-spectrum simplicity |
| 9 | **DPP Proposition 9 + Theorem 10** (no-go) | Near-diagonal additive energy $N_T(\eta)\ll\eta T^3\log^4T$ (best possible); and **no asymptotic zero-statistics input** (zero density, TTY energy, pair correlation, GUE) can decide $V_\infty=D$ — the weight $2\pi s^{-5}$ concentrates the sum at the bottom of the spectrum. | `DPP.md` §5 | — | proved; also corrects the TTY route in `METHOD.md` §3.5 as a category error |
| 10 | **Theorem D‴** (entropy phase law) | $W_k=(2\pi)^{(k-1)/2}s^{-(k+3)/2}e^{-i(sH_k(\vec p)+(k+3)\pi/4)}(1+O(\min\gamma_i^{-1}))$: the modulus knows only $s=\sum\gamma_i$, the phase is the splitting entropy $H_k=-\sum p_i\log p_i$. | `BLOCKS.md` §2; proof = Theorem I2 (`INVERSE.md`) | — | proved (exact factorization + stationary phase); verified $k=2,3,4$ |
| 11 | **Theorem E2** (block spectral support) | In $G_1=[\sharp\sharp]+[\sharp\flat]+[\flat\sharp]+[\flat\flat]$ under $\Lambda=\Lambda^\sharp_Q+\Lambda^\flat_Q$: the sharp block owns the pole at $s=1$ (smooth terms), mixed blocks carry exactly the single-zero layer, $[\flat\flat]$ exactly the pair layer — as a statement about poles of Mellin transforms. | `E2_PROOF.md` Part 1 (two pole-lemmas; demotes exp11 to illustration) | — | proved; no numerics load-bearing |
| 12 | **Proposition M1** (running law; the exp27 refutation) | $[\sharp\sharp]$-constant $=\tfrac14\log^2Q+(\tfrac C2+2S_\infty)\log Q+O(1)$ with $\tfrac C2+2S_\infty=1.181852\ldots$ — the published fitted $0.362$–$0.421$ was an artifact of fitting $L^2$ vs $L$ over one decade. | `METHOD.md` §1; `E2_PROOF.md` §2 (Ramanujan-coefficient correction $\varphi(m)/m$) | — | proved-with-strikes; two leading coefficients unconditional, explicit $O(1)$ rests on Hypothesis U (bilinear cancellation) |
| 13 | **Theorem MF** (Mertens floor) | The $X^2$ coefficient of $[\sharp\sharp]_Q$ is exactly $-\tfrac12M(Q)$: via $\Lambda^\sharp_Q(P_Q)=M(Q)$ (exact, every $Q$), mean value exactly 1, and the sawtooth mean $\tfrac12$ counted twice by bilinearity. | `MERTENS_FLOOR.md` (mechanism = `E2_PROOF.md` Prop U4) | — | proved (one transcribed $X$-coefficient slip corrected in situ; claim untouched) |
| 14 | **Theorem G** (Fresnel coupling) | The sum-spectrum atom at $f=\gamma+\gamma'$ carries phase $-f\log2-\tfrac{5\pi}4+\frac{(\gamma-\gamma')^2}{2f}+\frac{37}{12f}+\cdots$: the difference spectrum lives in the *phases* of the sum lines as a Fresnel chirp — fills the 2×2 dictionary's off-diagonal for non-Hermitian statistics. | `FRESNEL.md` §2 | — | proved under RH (Stirling expansion of $\arg W$); blind-recovery framing corrected per `CROSSREVIEW_WAVE2.md` |
| 15 | **Theorem H** (Liouville–Goldbach trace formula) | Under RH+SZ+Gonek: $G_1^\lambda(X)=\frac{\pi X^2}{8\zeta(1/2)^2}+$ single layer $+$ pair layer, **all at scale $X^2$** (parity pole at $s=\tfrac12$): the λ-field is a scale-degenerate pure spectrum. | `LIOUVILLE.md` §2 | — | proved-conditional; identity presumptively prior art (Cantarini–Gambini–Zaccagnini arXiv:2603.10241) — read as rederivation; scale-degeneracy reading repo-new |
| 16 | **Theorem H′** (Möbius = pure pair field) | Under RH+SZ+Gonek: $G_1^\mu(X)=\sum_{\rho,\rho'}v_\rho v_{\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}+O(X^{3/2+\varepsilon})$, $v_\rho=1/\zeta'(\rho)$: no pole ⟹ no main term, no single layer — the terminal object of the dressing family (layer count = pole count + 1). | `FAMILY.md` §1–2 | — | proved-conditional; same prior-art caveat as H |
| 17 | **Theorem B0** (smoothing threshold) | For the $k$-fold field with $j$ Cesàro smoothings, the zero$^{\times k}$ layer converges absolutely **iff $k\le2j$** — "absolute convergence after one smoothing" is false for $k\ge3$, and Theorem B1's proof invoked it. | `BARRIER_UNIFORM.md` §2 | — | proved given RH; prior-art sweep: phenomenon known (Cesàro-order lower bounds grow with factor count), exact threshold $k\le2j$ unmatched in located sources |
| 18 | **Theorem U1 / B1′** (WL structure, uniform) | WL observables factor through the blurred spectral measure with error window controlled at $\alpha=\tfrac12$ for $a=E,\Lambda,\mu,\lambda$ — with B2 **false as stated** (corrected B2′ demands every lower-arity layer at precision $\epsilon X^{-r/2}$) and the $d$ row struck (needs the functional equation). | `BARRIER_ERROR_WINDOW.md`, `BARRIER_SMOOTH_TERM.md`, `BARRIER_UNIFORM.md` | negative/near-law half: `formal/cubical/Asanna_TheNearIsNotTheEqualAndTheBarrierDiesInTheGap.agda` (checked); the analytic factorization half open | proved-with-strikes given RH; B2′ itself still open (`METHOD.md` §3.1) |
| 19 | **Lemma N** (arithmetic noise floor) | For the μ-field, $G_1^\mu(X)/X^2=$ pair layer $+O(X^{-1/2+o(1)})$: the "measured" $\varepsilon\approx10^{-3}$ is $X^{-1/2}$, in closed form with its $X$-dependence. | `HOLOGRAM.md` §7 | — | proved under RH+SZ+Gonek (ledger corrected: not "unconditional given RH+SZ") |
| 20 | **Theorem K′** (depth law, sharpened) | Feeding $\varepsilon=X^{-1/2}$ into the superresolution threshold: resolving pair atoms at height $T$ needs $X=\exp(\Theta(T^{1/2}\log^{3/2}T))$ (supersedes K(b)'s $\exp(cT\log^2T)$); difference atoms need $\exp(\Theta(T))$. Robust content: $L\propto\alpha^{-1/2}$ for $\varepsilon=X^{-\alpha}$. | `HOLOGRAM.md` §7 (+ §5 correction: the four predicted lines are SUMS; `SWEEP.md` §0 retraction of $T=100$ reachability) | — | derived scaling (no empirical input remains; self-consistent cluster-size closure heuristic; sumset-rank caveat) |
| 21 | **Theorem K / K0** (capacity) | Readable lines from span $L$ = atoms separated by $>\kappa\cdot2\pi/L$; rigorous core is spike-superresolution (Candès–Fernandez-Granda; Donoho), imported. | `HOLOGRAM.md` §§1, 6 | — | measured composition + imported theorem; honest ledger inline; narrow (windowed-linear) reading only — broad reading contradicts Montgomery and is struck in §3 |
| **B. Inverse problems and homometry (measure/combinatorial)** |
| 22 | **Theorem I1** (sum spectrum determines) | Positive locally finite measures with support bounded below: $\mu*\mu=\mu'*\mu'\Rightarrow\mu=\mu'$ (Titchmarsh half-line domain; positivity kills the sign). So the pair layer's frequencies determine the zeros. | `INVERSE.md` §1 | — | proved; classical with full attribution (Titchmarsh 1926; Weiss 1968; Gorenflo–Hofmann 1994 stronger) |
| 23 | **Theorem I2** (weight = simplex integral) | $W_k$ is exactly the Dirichlet integral over $\Delta_k$; it factors exactly into radial Beta × angular simplex; stationary phase at $w=p$ gives phase $=-sH_k(\vec p)$ (the action), exact amplitude–Hessian cancellation (splitting-blind modulus), Maslov $(k+3)\pi/4$. | `INVERSE.md` §2 | — | proved (first proof's three errors recorded and corrected in situ) |
| 24 | **Off-diagonal no-go** | The unordered off-diagonal pair multiset $\{\gamma_i+\gamma_j\}_{i<j}$ does **not** determine the configuration: $f_A(x)^2-f_A(x^2)=2g_A(x)$ + Prouhet/Thue–Morse evil–odious partition gives an infinite counterexample in exactly the corpus's regime. The diagonal is load-bearing. | `OFFDIAGONAL_NO_GO.md` | — | proved (identity + classical citation; finite table is a check, not evidence) |
| 25 | **Off-diagonal uniqueness** | The evil/odious split is the *unique* nontrivial partition of $\mathbb Z_{\ge0}$ into two sets with equal off-diagonal pairwise sums — derived by a two-line recursion, exhibiting the obstruction's fiber (one bit). | `OFFDIAGONAL_NO_GO_UNIQUENESS.md` | — | proved (independent re-derivation audit of the parent note included) |
| 26 | **Off-diagonal fiber, general** | In the general regime (arbitrary infinite multisets, support bounded below) the fiber of the off-diagonal map is one bit *per total multiset*: a one-line solution of the functional equation generating Thue–Morse and the Selfridge–Straus twins as one object at two $q$. | `OFFDIAGONAL_NO_GO_FIBER.md` | — | proved |
| **C. Prime-prefix polynomial algebra** |
| 27 | **Effective factor-degree divergence** | $\delta(F_X)\to\infty$ effectively: $\delta(F_X)\gg\log_2X(\log_4X)^4/(\log_3X)^4$, nonreciprocal case $\gg\log_2X\log_4X/\log_3X$ — Lenstra's lacunary gap theorem + Ford–Maynard–Tao prime-gap chains, with the repo's cyclotomic classification removing Lenstra's root-of-unity exception. | `ASYMPTOTIC_FACTOR_RIGIDITY.md` | — | proved, effective constants |
| 28 | **Parity resultant reduction** | $F_X(x)+F_X(-x)=2$ for $X\ge5$; quartic resultant/eliminant reduction for parity-compatible factors ($g\mid F_X\iff H_g\mid N_X$ with $H$ multiplicative — Brahmagupta bhāvanā composition); uniform finiteness in every odd degree. | `PARITY_RESULTANT.md`, `REFLECTION_NORM.md` | eq. (2.3): `formal/cubical/ParityNormEliminant.agda`; sextic spine: `SexticParityEliminant.agda` | proved |
| **D. Operator algebras and the parity sector** |
| 29 | **Theorem F** (gauge no-go) | The unique KMS state $\omega$ of $(Q_{\mathbb N},\sigma)$ (Cuntz, $\beta=1$) is invariant under the full multiplicative gauge torus $\mathbb T^{\mathcal P}$ and vanishes on every nontrivial isotypic sector — every parity-odd observable has exactly zero equilibrium expectation; equilibrium is supported on the multiplicatively neutral sector (diagonal $=C(\widehat{\mathbb Z})$). | `GAUGE.md` F.2 | — | proved (two lines on top of Cuntz's uniqueness); arithmetic identification with the sieve parity barrier is the repo-new content |
| 30 | **CORE_KMS theorem** | The gauge-neutral core $Q^0$ is the Bunce–Deddens algebra $C(\widehat{\mathbb Z})\rtimes\mathbb Z$; $\sigma$ restricts trivially; $Q^0$ has a unique trace, $=\omega|_{Q^0}$; restriction on KMS simplices is a bijection precisely at $\beta=1$. No hidden neutral-sector equilibria; the no-go closes at the core, and at every intermediate core. | `CORE_KMS.md` | — | proved |
| 31 | **Theorem P** (two spectral types) | $m_\Lambda(a/q)=\mu(q)^2/\varphi(q)^2$ (Siegel–Walfisz); under Hardy–Littlewood these atoms exhaust $\sigma_{\Lambda-1}$ (purely atomic on $\mathbb Q/\mathbb Z$); $\sigma_\lambda$ is atomless **unconditionally** (Davenport); Chowla $\iff\sigma_\lambda=$ Lebesgue. | `PARITY.md` | — | assembled from known results, correctly attributed; atomicity clause conditional on HL |
| **E. Weil positivity / LP certificates** |
| 32 | **Proposition LP1** | On the primitive subspace $P=\{\Phi_g(0)=\Phi_g(1)=0\}$ the pole form vanishes and (under RH) $W|_P$ is PSD termwise — the naive Hodge negativity question is trivially answered "no"; the real object is the zero-free intersection form $I=\text{prime}-\text{arch}$. | `LP_CERT.md` §2 | — | proved |
| 33 | **Proposition LP2** (H1, H2: the $n_+\le1$ index bound) | Under RH: $I|_P\le0$ (primitive negativity, a zero-free prime-vs-archimedean budget inequality); and on every finite-dimensional test space $n_+(I|_V)\le1$ (Weyl monotonicity against the rank-2 hyperbolic pole form). Converse: H1 on all of $C_c^\infty\cap P$ implies RH (Connes–Consani Appendix C, applied with vanishing set $\{0,1\}$). | `LP_CERT.md` §2 | — | proved conditional on RH; the "stronger form inequality" overstatement struck (it is Weil's criterion in intersection vocabulary); converse cited, not re-proved |
| **F. Foundations: the atlas of $\mathbb N$** |
| 34 | **ATLAS_OF_N package** (Thms 2.1–2.13, 3.1–3.2, 4.2, 5.1, 5.3, 6.1) | Seven charts of $\mathbb N$ with all transition maps proved and residuals named: chart (a)≡(b) with *contractible* comparison; decategorification residual $=S_n=\pi_1(BS_n)$; ordinals rigidify ($\sum_X\mathrm{LinOrd}(X)$ contractible), divergence exactly at $\omega$; base-$b$ needs 3 choices — base ($\mathrm{rad}\,b$ invariant), endianness ($\mathbb Z/2$-torsor), carry ($[c_n]\ne0$ in $H^2$, so carrying is unremovable); $\mathrm{Aut}(\mathbb N_{>0},\times)=\mathrm{Sym}(P)$ vs $\mathrm{Aut}(+,\times)=1$ ($2^{\aleph_0}$ additions per multiplication); no completion retains induction; unique factorization does not categorify (exact non-fullness index). | `ATLAS_OF_N.md` | Thm 2.1 contractibility, Thm 3.2, Thm 3.1 loop half, Thm 2.7, carry adapter: checked (`AtlasResiduals`, `LinearOrderFinite`, `PathIsSymmetry`/`Decategorification`, `Digits`, `CarryCohomologyAdapter`); Prop 2.11's $H^2$ class partially | proved (assembly of classical + three claimed-new items, attributed line by line in §9) |
| **G. Indian mathematics lane (kuṭṭaka / cakravāla / vargaprakṛti)** |
| 35 | **Cakravāla turn cap** (conditional) | If Bhāskara's wheel reaches क्षेप $=1$ at all, it does so within $B^2$ turns ($B$ least with $4D<B^2$): the state box $m^2\le4D$, $k^2\le4D$ plus pigeonhole. Remaining gap to a checked cap: step determinism (solution set $=$ class of $-m$ needs the kuṭṭaka coprimality already produced elsewhere; tie-breaking in Bhāskara's rule). | `AvasthaBaddha_TheCakravalaStateBoxIsChecked.md`, `DosaLekha_TheCakravalaTurnCapIsNotABound.md` | state box + pigeonhole + self-propagation: `formal/cubical/GunakaKsepa_...agda`, `CakravalaBound.agda` (checked); determinism wiring **not** done | proved-in-part; **termination of the cakravāla itself remains open** (recorded in both notes); `Nalanda.hs`'s 400-turn cap shown not a bound (fails at $D=73516$) |
| 36 | **Kuṭṭaka termination / bhāvanā** | The vallī terminates for every pair; Brahmagupta's bhāvanā: composition of two norms is a norm (the composition law of the pair field). | prose in kuṭṭaka notes; substance lives formally | `KuttakaSamapti_...agda`, `KuttakaValli.agda`, `Bhavana_...lean`, `Cakravala_TheBhavanaStep...lean` (all checked) | proved and formalized — listed for completeness; primary home is the formal lane, not prose |
| **H. Meta-results with proof content** |
| 37 | **Pinch theorem** (barrier atlas) | Any unconditional certificate in the frontier frame using a trace of order $k\ge3$ operates at band $\lambda<\tfrac23$ and certifies at most $(\tfrac23+o(1))N$ — strictly dominated by the $0.6725$ attained with two traces at band 1. | `ATLAS.md` §1 | — | conditional exactly on the two cited statements (Cap Prop 7.4; Rudnick–Sarnak correlation budget) |
| 38 | **Asanna near-law** | With equality relaxed to a tolerance, the WL obstruction survives iff the decoder respects the tolerance and the tolerance excludes the separation; near-blindness alone (with arbitrary $\Phi$) obstructs nothing (checked counterexample). Names the missing distinction in the WL definition: prove B2′ or add a modulus on $\Phi$. | `METHOD.md` §3.1 (2026-08-22 finding) | `formal/cubical/Asanna_...agda` (checked, wired into `Everything.agda`) | proved (the formal statements); the analytic barrier lemma remains open with its residue sharpened |

**Count: 38 catalogued entries carrying ~50 named results** (the DPP note
alone resolves D″ into eight numbered theorems; the ATLAS_OF_N package holds
~14; REPORT holds A/A′/A″/B/B′/C/D/D′).

---

## Judgment: the 10 strongest prose-lane results as mathematics

Ranked by depth × sharpness × unconditionality, not by effort:

1. **Theorem A″** (`PARITY_RIGIDITY.md`). Unconditional, elementary, and
   apparently new: every prime prefix is determined by its difference multiset
   up to congruence, by singleton parity. It answers a natural question not
   found in the literature and it killed its own conditional predecessor (A′).
2. **Theorem C** (`REPORT.md` §4). An RH-equivalence with a two-line proof,
   plus the diagnosis that the celebrated sharp-cutoff difficulty
   (Granville; Bhowmik–Schlage-Puchta) is a property of the cutoff. The
   highest insight-to-length ratio in the corpus.
3. **The DPP resolution of D″** (`DPP.md`). An unconditional-under-RH Ω-result
   by a pure order argument, $V_\infty\asymp D$ as a theorem, the reduction of
   the constant to sum-spectrum simplicity — and Theorem 10, a structural
   no-go proving no asymptotic zero-statistics input can decide the question.
   The no-go is the most mature piece: it explains why a whole planned route
   (TTY) was a category error.
4. **Theorem I2** (`INVERSE.md` §2). The exact Beta × simplex factorization
   with the entropy phase as a genuine stationary action, exact
   amplitude–Hessian cancellation, and the Maslov constant decomposed. One
   computation retroactively proves the measured laws of three notes
   (D‴, the $k$-body ladder, exp17/22/30).
5. **Theorem F + CORE_KMS** (`GAUGE.md`, `CORE_KMS.md`). The parity barrier
   identified as the gauge-protected sector of the unique KMS state of
   $Q_{\mathbb N}$, closed off at every intermediate core. Short on top of
   Cuntz, but the arithmetic identification is genuinely new and organizes
   Davenport/Chowla/parity as one statement.
6. **The off-diagonal trilogy** (`OFFDIAGONAL_NO_GO*.md`). A sharp negative
   solution — diagonal removed, uniqueness dies, and the fiber is exactly one
   bit per total multiset — connecting Titchmarsh, Prouhet–Thue–Morse, and
   Selfridge–Straus in a complete classification. Closed in three
   independent, mutually auditing notes.
7. **Theorem B0** (`BARRIER_UNIFORM.md`). An exact convergence threshold
   ($k\le2j$) that falsified a load-bearing assumption of the corpus's own
   barrier theorem, with the phenomenon located in the Cesàro literature but
   the threshold apparently unstated. Self-correction with new content.
8. **Proposition M1 + Theorem MF** (`METHOD.md`, `MERTENS_FLOOR.md`,
   `E2_PROOF.md`). The fitted $0.362$ refuted by the exact $\tfrac14$; the
   block floor exactly $-\tfrac12M(Q)$ via the identity
   $\Lambda^\sharp_Q(P_Q)=M(Q)$ — which also produced the sharpest fact in
   the lane: the sieve kernel's pointwise failure *is* the Mertens function,
   and it is annihilated by the weight. The corpus's founding lesson, as
   mathematics.
9. **Effective factor-degree divergence**
   (`ASYMPTOTIC_FACTOR_RIGIDITY.md`). A genuine unconditional theorem joining
   Lenstra's lacunary gap theorem to Ford–Maynard–Tao prime gaps, with the
   repo's own cyclotomic classification closing Lenstra's exception. The most
   "publishable as-is" single result in the algebraic lane.
10. **Lemma N + Theorem K′** (`HOLOGRAM.md` §7). The noise floor derived with
    its $X$-dependence, changing the depth-law exponent from $T\log^2T$ to
    $T^{1/2}\log^{3/2}T$ — the corpus's clearest demonstration that a measured
    constant without its scaling is worse than no constant. Kept at #10
    because the closure step is heuristic (derived scaling, not theorem).

Honorable mentions: Theorem G (the off-diagonal cell was never empty — phases
carry the difference spectrum), Theorem E2 (poles, not correlations), the
ATLAS_OF_N carry cocycle ($[c_n]\ne0$: carrying is cohomologically
unremovable), LP2's $n_+\le1$ index bound.

## The 5 that most deserve formalization next

1. **Theorem A″, the missing layers** (`ParityRigidity.lean`). The corpus's
   flagship unconditional theorem is two routine layers (translation
   bookkeeping; the prime-prefix corollary needing only "2 is the unique even
   prime") away from being a checked term end to end. Highest value per hour
   anywhere in the queue — the hard algebra (`core`) is already in Lean.
2. **The off-diagonal trilogy's spine.** The identity
   $f_A(x)^2-f_A(x^2)=2g_A(x)$, the two-line uniqueness recursion, and the
   one-bit fiber formula are finite algebra over polynomial rings — exactly
   the shape Agda/Lean digest — and they anchor a complete classification
   that currently rests entirely on prose.
3. **Theorem I2's exact half.** Not the stationary phase: the exact
   statements — $W_k$ as the Dirichlet simplex integral and the exact
   radial × angular factorization ($W_k=\frac1{S(S+1)}\cdot\prod\Gamma(\rho_i)/\Gamma(S)$).
   These are identities in $\Gamma$-function algebra; mathlib has the
   Beta/Gamma machinery. Formalizing them pins the layer every trace formula
   (D, H, H′, ladder) hangs from.
4. **MF/M1's exact identities.** $\Lambda^\sharp_Q(P_Q)=M(Q)$,
   $\sum_{d\le Q}A_d/d=1$, and the sawtooth-doubling mechanism are exact
   rational statements (the note's own tables are already exact-rational).
   They guard the corpus's most important correction against regression, and
   the Mertens identity is independently striking.
5. **The cakravāla turn cap's last two inches.** Wire
   `CakravalaDescent.oneCongruenceCoprime` and a tie-break lemma into
   `GunakaKsepa`, making "reaches 1 ⟹ within $B^2$ turns" a checked term —
   the named missing piece in `AvasthaBaddha` §4, replacing `Nalanda.hs`'s
   400-turn cap (already shown wrong at $D=73516$) with a theorem. This is
   the one item where formalization changes running code, and it advances the
   book's primary lane (Jayadeva/Bhāskara) rather than the appendix.

*Not recommended next, despite temptation: Theorems C, D, H, H′, K′ — their
content is inseparable from ζ-analytics (explicit formula, Gonek bounds,
contour shifts) that no current library carries; formalization effort there
buys scaffolding, not the theorem.*
