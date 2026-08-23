# The barrier program: three presentations of the arithmetic, and who can see the bulk

Companion to `HOLOGRAM.md` (Theorem K), `FAMILY.md` §2.2/2.4, sibling
`LENS_CIRCUIT.md`. Status: definitions + one structure proposition
(proof-sketch grade) + a classification supported by this corpus's measured
results; honesty ledger in §5. This note *creates* the rigorous problem it
does not yet solve.

## 1. The windowed-linear class, defined

Fix a window $[X_0,X]$, span $L=\log(X/X_0)$, degree $d$, and arity $r$.

**Definition (WL$_d(L,r)$).** An observable of arithmetic data
$a\!\restriction\![1,X]$ of the form $O(a)=\Phi(Q_1,\dots,Q_r)$, where each
$$Q_i \;=\; \sum_{n_1,\dots,n_k\le X} a(n_1)\cdots a(n_k)\,K_i(n_1,\dots,n_k),
\qquad k\le d,$$
whose kernel factors through *log-scale windows of resolution $L$ on linear
forms*: $K_i(\vec n)=g_i\bigl(\log\ell_1(\vec n),\dots\bigr)$ with each $g_i$
having log-Fourier content confined to bandwidth-$O(1)$ windows measurable
at resolution $2\pi/L$, and $\Phi$ arbitrary (even non-computable)
post-processing of the $r$ numbers. **The class treats $a$ as a black-box
sequence: only its additive presentation (values against windowed kernels
of linear forms) is accessed.**

Everything this corpus computes is WL: smoothed counts ($d=2$, kernel in
$m+n$), blocks (Ramanujan-twisted kernels), all band-passed phases, the
Fresnel readings, the twisted fields, the $k$-body fields ($d=k$).
Classical major/minor-arc circle-method quantities are WL. 

**Theorem B1 (Structure Theorem for windowed observables).** Let
$\Psi_k(X)=\sum_{n_1+\dots+n_k\le X}a(n_1)\cdots a(n_k)\,(X-\textstyle\sum n_j)$
be the $k$-fold Cesàro-1 field of a dressing $a$ in the residue-dressing
family, and write $\psi(u)=\Psi_k(e^u)e^{-(k+1)u}$ for the field at its
natural scale. Let $w\in C_c^\infty$ be a window supported in an interval of
length $L$, and let $Q_w=\int w(u)\psi(u)\,du$ be the corresponding **span-$L$
windowed observable**. Then, with
$$\sigma_k \;=\; \sum_{\rho_1,\dots,\rho_k} W_k(\vec\rho)\,
\delta_{\gamma_1+\dots+\gamma_k}$$
the $k$-fold sum-spectral measure ($W_k$ as in Theorem D‴-$k$),
$$\boxed{\;Q_w \;=\; \langle \sigma_k,\widehat w\,\rangle \;+\;
\langle w,\mathrm{Smooth}\rangle \;+\; \langle w, E\rangle\;}$$
and for every $N$, atoms at distance $>R/L$ from $\operatorname{supp}\widehat w$'s
centre contribute $\ll_N R^{-N}\|\sigma_k\|$, where
$\|\sigma_k\|=\sum|W_k|<\infty$.

*Proof.* Substitute the explicit formula for each of the $k$ factors and
integrate against the Cesàro weight; the Dirichlet–Beta identity
$\iint_{\sum u_j\le X}\prod u_j^{\rho_j-1}(X-\sum u_j)\,du
=\frac{\Gamma(2)\prod\Gamma(\rho_j)}{\Gamma(\sum\rho_j+2)}X^{\sum\rho_j+1}$
sends the zero$^{\times k}$ term to $\sum_{\vec\rho}W_k(\vec\rho)
e^{i(\sum\gamma_j)u}$, the pole-containing terms to $\mathrm{Smooth}$, and
the remainder to $E$. Absolute convergence of the multiple zero sum after one
Cesàro smoothing is Theorem D′/D‴-$k$ ($|W_k|\asymp s^{-(k+3)/2}$ against
pair density $\asymp s\log^2 s$), so the interchange of $\int w$ with
$\sum_{\vec\rho}$ is justified. Termwise,
$\int w(u)e^{i\xi u}du=\widehat w(-\xi)$, giving the pairing. The tail bound
is Paley–Wiener: $w\in C_c^\infty$ of support length $L$ has
$\widehat w(\xi)\ll_N (1+|\xi|L)^{-N}$, and $\|\sigma_k\|<\infty$ by the same
convergence. $\square$

**Corollary B2 (indistinguishability).** Two spectral configurations
$\sigma_k,\sigma_k'$ with $\langle\sigma_k-\sigma_k',\widehat w\rangle=0$ for
every span-$L$ window $w$ produce **identical values of every span-$L$
windowed observable**. Since $\widehat w$ resolves at scale $2\pi/L$, it
suffices that $\sigma_k-\sigma_k'$ be annihilated at that resolution — the
moment-matched sub-resolution clusters of Theorem K0 are exactly such
differences, with mismatch $O((\delta L)^{2p-1})$.

> **STRUCK 2026-08-22 — B2 is FALSE AS STATED, and the retraction has been
> sitting in three other files since 2026-08-20 without ever reaching this
> one.** `METHOD.md` §3 item 6 and `BARRIER_SMOOTH_TERM.md` §5 both record it;
> `OPEN_PROBLEMS_WE_TOUCH.md` :508 repeats it; `SamagraDarsana…md` :505 still
> presents B2 unmarked as "the fibre, named". The wrong version is the two
> sentences above and is left in place rather than erased.
>
> **Why it fails.** B2 concludes "identical values of every span-$L$ windowed
> observable" from agreement of the *spectral* pairing alone. But B1's own
> boxed identity has three terms, $\langle\sigma_k,\widehat w\rangle+
> \langle w,\mathrm{Smooth}\rangle+\langle w,E\rangle$, and the other two are
> **configuration-dependent**: `BARRIER_ERROR_WINDOW.md` Theorem U1 gives
> $E(u)=k\,D_a(0)e^{-u/2}\mathcal Z_{k-1}(u)+O(e^{-u})$, whose leading term is
> the $(k-1)$-fold wave layer of the *same* configuration, and
> `BARRIER_SMOOTH_TERM.md` shows $\mathrm{Smooth}$ is a graded ladder that for
> $a=\Lambda$, $k\ge2$ **exceeds** $\mathcal Z_k$ by $X^{(k-1)/2}$. Two
> configurations annihilated at resolution $2\pi/L$ in arity $k$ therefore
> agree on the first term and need not agree on the other two.
>
> **The corrected form is B2′** (`BARRIER_SMOOTH_TERM.md` §5): every
> *lower-arity* layer must also match, at precision $\epsilon X^{-r/2}$. B2′
> is strictly stronger and is not implied by the sub-resolution moment
> matching B2 invokes.
>
> **And the residual gap is not closable by matching harder** — see
> `formal/cubical/Asanna_TheNearIsNotTheEqualAndTheBarrierDiesInTheGap.agda`
> (checked, `--cubical --safe`, 2026-08-22). B2's conclusion is *identical
> values*, i.e. exact equality, which is what the corpus's general
> obstruction theorem (`Vaidharmya`, generalising
> `NaturalMachine.QuotientFiberLaw`) requires and all it requires. What B2
> can actually deliver is agreement **to within** the mismatch
> $O((\delta L)^{2p-1})$ — close, not equal — and that module's §४ exhibits a
> one-query counterexample showing that near-blindness plus B3's arbitrary
> post-processing obstructs **nothing**. So B2 must be repaired to exact
> agreement (B2′), or B3 must acquire a modulus on $\Phi$; there is no third
> option, and B3 as written rules out the second by construction.

**Proposition B3 (nonlinear closure).** Any $O=\Phi(Q_{w_1},\dots,Q_{w_r})$
with arbitrary — even non-computable — post-processing $\Phi$ is a function of
$r$ numbers each of which factors as in B1. Hence the entire class
$\mathrm{WL}_d(L,r)$ factors through the blurred measure
$\sigma_k * K_L$, $K_L$ any kernel dominating the $\widehat w_i$. *Post-processing
cannot recover information the windows did not pass.*

**What B1–B3 do and do not establish.** They prove that the *access mode* is
lossy at resolution $2\pi/L$, with quantified tails. They do **not** yet
prove a barrier against inferring $\zeta$'s correlations, because that
requires exhibiting **two admissible spectra** — both satisfying the
counting law $N(T)\sim\frac{T}{2\pi}\log\frac{T}{2\pi}$, the functional
equation constraints, and (if assumed) RH — whose blurred measures agree.
The superresolution construction perturbs an abstract spike measure; the
zeros of $\zeta$ cannot be moved. So the honest form is minimax over a
hypothesis class:

> **The barrier problem (precise).** Exhibit, or rule out, a pair of
> admissible zero configurations indistinguishable to all
> $\mathrm{WL}_d(L,\mathrm{poly})$ observables at $L=o\bigl(\sqrt{\rho_2\log\rho_2}\bigr)$
> but with different pair-correlation statistics.

**Positioning against the existing theorem-level barriers** (librarian audit —
these were uncited and are the right template): **Bombieri**, *The asymptotic
sieve*, Mem. Accad. Naz. dei XL (5) **1/2** (1976) 243 is the classical
theorem-level statement that sieve axioms alone cannot resolve parity;
**Friedlander–Iwaniec**, *Asymptotic sieve for primes*, Ann. of Math. **148**
(1998) 1041 is its sharp complement, identifying *exactly which extra axiom* (a
bilinear-form hypothesis) breaks it — precisely the "class C + axiom A ⟹
detection; class C alone ⟹ not" shape this program's Problem 1 asks for.
**Green–Tao–Ziegler**'s inverse theorems are the one place in the field where
"what a whole class of observables can and cannot see" is a *theorem*
(obstructions to uniformity are exactly nilsequences) — the structural
precedent for Theorem B1. And for the record: **no general formalization of the
parity barrier exists**; Tao (2007) states it semi-formally and concludes it is
"probably premature ... to try to find a systematic way to get around the
parity problem in general". So this ground is genuinely open.

This is exactly the natural-proofs situation: the structure theorem is the
easy half (there, "natural properties are constructive and large"), and the
hard half is producing pseudorandom candidates inside the class. Naming it
this precisely is the contribution; solving it is open.

**Barrier corollary (= Theorem K restated).** A WL observable determines
correlation-grade information at height $T$ only if the blur resolves the
pair atoms: $L\gtrsim\kappa\,2\pi\rho_2(2T)$, i.e. ~~$X\sim\exp(cT\log^2T)$~~.
Within WL, the depth law is not an artifact of our methods — it is the
information geometry of the class.

> **STRUCK 2026-08-22 — this note was the inheriting downstream and was never
> repaired.** The exponent above is Theorem K(b)'s, and `HOLOGRAM.md` §7 says
> in those words that Theorem K′ *"supersedes Theorem K(b)'s
> $\exp(cT\log^2T)$"*: the fixed precision floor $\varepsilon\approx10^{-3}$ was
> an empirical input, Lemma N derives it as $X^{-1/2}$ — with its
> $X$-dependence — and the corrected law is
> $$X_{\text{needed}}(T)=\exp\bigl(\Theta(T^{1/2}\log^{3/2}T)\bigr).$$
> `HOLOGRAM.md` §5 sharpens this further for *differences* (as against sums),
> where the atom amplitude $\log A\approx-\pi T$ gives
> $X^{\text{diff}}_{\text{needed}}(T)=\exp(\Theta(T))$ — so the correct figure
> for the correlation-grade content this corollary is about is
> $\exp(\Theta(T))$, strictly between the two.
> `CROSS_LENS.md` §7 item 3 logged this site on 2026-08-21 ("`BARRIER` §1
> inherits it") and nobody carried the correction here; `HOLOGRAM.md` §1 was
> marked the same day and this file was not. The line is struck rather than
> rewritten because the retraction is the content.

## 2. The three presentations, and the measured visibility table

The corpus has now probed the arithmetic through three inequivalent
presentations, and the results align exactly:

| presentation | probe class | measured face | what it sees | blind spot |
|---|---|---|---|---|
| **finite-multiplicative** (divisibility) | SIEVE$_d$ (sibling), Ramanujan/BC blocks | exp21/24 fingerprints | singular series, character sectors (one literal deep) | **parity-protected**: $\lambda,\mu$ exactly invisible (gauge no-go) |
| **additive-windowed** | WL$_d(L,r)$ (this note) | the whole phase-side corpus | the blurred spectral measure: locations cheap, layer structure, amplitudes | **bulk-blind**: correlations cost ~~$\exp(cT\log^2T)$~~ $\exp(\Theta(T))$ (Theorem K′ + `HOLOGRAM.md` §5; struck 2026-08-22, see §1) |
| **global-multiplicative** | functional-equation access: $a(np)=a(n)a(p)$ used as a *constraint*, not a value | Tao's entropy decrement (log-Chowla) | the one known access to Chowla-grade (bulk) content | quantitatively weak so far (logarithmic averaging only) |

The alignment is the point: **the sieve parity barrier, the Theorem-K depth
barrier, and the sum-product philosophy (`REPORT.md` §7c) are the same
three-way classification seen from three corners.** Sieves fail on parity
because finite-multiplicative probes can't see the gauge charge (proved,
sibling). WL fails on correlations because additive-windowed probes see
only the blurred spectrum (this note). And the single case where a
bulk-grade conjecture yielded — logarithmic Chowla — used precisely the
presentation the other two classes never touch: the *global* multiplicative
functional equation as a constraint propagated across scales
(entropy decrement), a nonlinear, non-windowed operation.

**Position of entropy decrement (the probe of priority-question 1).** Its
correlator $\sum\lambda(n)\lambda(n+h)/n$ is WL as a *number*; the proof is not
a WL *derivation*: the decrement step compares the empirical distribution
of $(\lambda(n+1),\dots,\lambda(n+H))$ across scales using
$\lambda(pn)=-\lambda(n)$ — accessing $a$'s functional equation, outside the
black-box-sequence interface of WL by construction. So within this
taxonomy: entropy decrement $\notin$ WL, *by the interface it consumes*.
What is missing for a theorem: a proof that no WL post-processing $\Phi$
can simulate that interface — i.e., a separation, not just a
classification. That is the barrier program's Problem 1.

## 3. The program (problems this note creates)

1. **Separation:** prove no $O\in$WL$_d(L,\mathrm{poly})$ with
   $L=o(\rho_2(2T))$ determines gap-grade statistics at height $T$ (make
   the Structure Proposition a theorem; then an information bound on
   blurred measures — DPP-grade tooling; coordinate with the auditor
   branch's `DPP_ENERGY` lane).
2. **Interface formalization:** define "multiplicative-constraint access"
   (oracle model: queries to $a$'s functional equation vs value queries)
   and re-derive entropy decrement inside it; measure its "bulk bits per
   log-scale" — is logarithmic averaging *forced* by the interface?
3. **Completeness question (the mad one):** are the three presentations
   exhaustive for "natural" methods? A fourth presentation — e.g.
   automorphic summability (the $d(n)$ row's $GL_2$ access, unavailable to
   primes) — is what the divisor field has and $\Lambda$ lacks; classify
   Kuznetsov/Voronoi access as presentation #4 and ask what its
   $\Lambda$-shadow would need to be. The Langlands-functoriality reading:
   presentations = choices of group; the bulk is what no abelian ($GL_1$)
   presentation reaches at feasible depth.

## 4. Honesty ledger

The Definition is rigorous; the Structure Proposition is a sketch whose
convergence bookkeeping is the D-family's (verified numerically, proved
only conditionally); the visibility table's first two rows are backed by
proofs/measurements in this corpus, the third by reading Tao's published
argument through this lens (no new analysis of it here); §2's separation
claim is *definitional* (interface-level), and honest about what a real
separation theorem still requires. Nothing here proves any new bound on
any arithmetic sum.

## 5. Prediction inherited

`HOLOGRAM.md` §5's span-8.5 prediction stands; a confirmed reading at
$X\sim10^8$ of the predicted new lines would be the third dataset on the
capacity curve.

---

## Appendix (appended 2026-08-18): the barrier problem is a two-witness problem

The precise form stated above — *"Exhibit, or rule out, a **pair** of
admissible zero configurations indistinguishable to all
$\mathrm{WL}_d(L,\mathrm{poly})$ observables but with different
pair-correlation statistics"* — reached the number **2** from the
mathematics. `NaturalMachine.BarrierIsTwoWitnesses` says why it is 2, and
why it can be neither 1 nor more, using only the structure B3 already
establishes.

**B3 is a probe statement.** "Any $O=\Phi(Q_{w_1},\dots,Q_{w_r})$ with
arbitrary — even non-computable — post-processing $\Phi$ … factors
through the blurred measure" says exactly that the decoders are the
post-processings and what they may read is the blur. Formally, with
`blur : Config → Blur` and `stat : Config → Stat`:

```agda
Recovers Φ   = (c : Config) → Φ (blur c) ≡ stat c
BarrierHolds = ¬ Σ[ Φ ∈ (Blur → Stat) ] Recovers Φ
```

Three facts, checked, over abstract `Config`/`Blur`/`Stat` — which is the
right generality precisely because B3 lets $\Phi$ be arbitrary:

1. **One configuration is never enough**, with no hypothesis whatever.
   `one-config-never-suffices` — the constant post-processing
   `λ _ → stat c` answers any single configuration, however extreme. So a
   programme of the form *construct a single spectrum with property P* is
   looking at the wrong kind of object. This is the methodological
   content.
2. **A pair is the whole content, not evidence for it.**
   `barrier-from-a-pair` — two configurations the blur identifies and the
   statistic separates kill *every* $\Phi$ at once, which is what B3's
   "arbitrary, even non-computable" is there to make meaningful.
   `barrier-witness-number-2` gives exactly 2.
3. **On a finite family with no such pair, the barrier provably fails.**
   `no-pair-on-a-family` (needs comparable blur values) — a
   post-processing answering the whole family is constructed by table
   lookup. So the search cannot be narrowed to a family already checked
   pairwise.

**Nothing analytic is claimed.** No pair is asserted to exist, nothing
about $\zeta$, admissibility, the counting law, the functional equation,
$L$, or resolution. This establishes strictly less than B3 — it is a
statement about the shape of the target, confirming from the other side
this note's own ledger that B1–B3 do not establish a barrier against
inferring $\zeta$'s correlations. B3 supplies the probe structure; the
probe structure is what makes the cost exactly two.

The general theory is in `notes/THE_WITNESS_NUMBER.md`; the relevant
theorem is that over decoders reading a discrete probe, an obstruction of
this shape costs 2 whenever it costs anything finite.
