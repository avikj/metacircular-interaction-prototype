# Theorem K: the arithmetic hologram — capacity, depth, and Chaitin-type irreducibility

Companion to `FRESNEL.md`, `FAMILY.md`, `papers/phase_side.md`. Code:
`code/exp31_capacity.py` → `figures/exp31_capacity.png`. Status: a
*composition of measured laws* into one scaling principle, plus an
information-theoretic reading — honesty labels inline; nothing here claims
new RH-side rigor.

## 1. The composition

Three laws, each independently measured in this corpus, compose:

1. **Crowding law** (verified at spans 4.55/6.16 and in the λ- and L-tower
   fields): a line is readable from arithmetic data iff its separation from
   the nearest stronger line exceeds $\kappa\cdot2\pi/L$,
   $L=\log(X_{\max}/X_{\min})$, $\kappa=1.4$ (Hann mainlobe, calibrated once:
   predicted 4 = measured 4 at $L=4.55$; predicted 5 vs measured 6 at
   $L=6.16$ with the sixth line at threshold to three decimals).
2. **The dichotomy** (Theorem G): line *positions* carry location
   (theorem-side) content; pair-line *phases* carry difference/correlation
   (conjecture-side) content.
3. **Densities**: single lines at height $T$: spacing $2\pi/\log\tfrac{T}{2\pi}$;
   pair atoms near $s$: spacing $1/\rho_2(s)$, $\rho_2^{\text{unord}}(s)\sim s\log^2s/(8\pi^2)$ [corrected: the corpus carried a stray $\pi$ — `SWEEP.md` §1.1].

**Theorem K (capacity/depth law).**
(a) *Capacity:* readable gap-grade lines from span $L$ =
$\#\{$atoms with nearest-neighbor separation $>\kappa2\pi/L\}$ — exact given
the crowding law; matches both recovery experiments.
(b) *Two-tier depth:* zero **locations** at height $T$ are readable from
$X\sim\mathrm{poly}(T)$ (surface); zero **correlations** need
$L\gtrsim\kappa2\pi\rho_2(2T)\sim T\log^2T/(2\pi^2)$, i.e.
$$X_{\text{needed}}(T)\sim\exp(c\,T\log^2T)\qquad\text{(bulk)}.$$
Measured: $T=100$ costs $10^{53}$ integers; $T=500$, $10^{772}$; $T=1000$,
$10^{2134}$ — while locations cost $X\sim T$.

## 2. The Chaitin reading (resource-bounded irreducibility)

Chaitin's incompleteness: a formal system of complexity $N$ cannot prove
statements whose content exceeds $N+O(1)$ bits — you cannot decompress what
your axioms do not contain. Theorem K is the *observer-relative,
resource-bounded* analogue for arithmetic data:

- Define $K_{\mathrm{wl}}(\,\text{gaps at height }T\mid\text{primes}\le X)$ —
  the information about zero *differences* extractable by the
  **windowed-linear observable class** (every tool this corpus uses:
  smoothed counts, blocks, dressings, band-passed phases) from the primes
  up to $X$. The depth law says this conditional content is **pinned at
  zero until $\log X\sim T\log^2T/(2\pi^2)$, then collapses to
  $O(\log)$ per gap** — an information-theoretic phase transition in the
  window size.
- The bulk phases are *definable* — under RH they are computable from the
  zeros, and the zeros from arbitrarily deep prime data — but they are
  **irreducible relative to every feasible surface**: like $\Omega$'s bits,
  which are definable yet incompressible, the correlation content of the
  spectrum is present in the integers while being inaccessible to any
  observer whose resources are polynomial in the height. The analogy is
  precise in kind (definable-but-irreducible-to-the-observer), heuristic in
  degree: no genuine Kolmogorov bound is proved here, and everything in
  sight is computable in the unlimited-resource sense. The honest name is
  *resource-bounded Chaitin phenomenon*, cousin to natural-proofs-style
  barriers rather than to Gödel-Chaitin proper.
- **The sharpest formulation of what a "solution" would be:** any method
  extracting correlation content at sub-exponential depth must operate
  *outside the windowed-linear class* — the class obeys the crowding law,
  and the crowding law forces the exponent. This is a necessary condition
  on the *shape* of any future proof of pair correlation/Chowla-grade
  statements from prime data, derived entirely from measured laws. Natural
  question (the ambitious one): is Tao's entropy-decrement argument — the
  one place a Chowla-type statement yielded — provably outside this class?
  Its log-averaging is not a fixed window, and its entropy bookkeeping is
  nonlinear in the data. If the class boundary can be made rigorous, the
  entropy-decrement method sits on the far side of it, and Theorem K
  becomes a classification of which proof-shapes can possibly work.

## 3. Consequences stated plainly

1. **Scope correction (librarian audit) — the broad reading is false.** The
   claim is *not* "no feasible computation reads correlation-grade structure
   from arithmetic data": Montgomery's $F(\alpha,T)$ is computed **from prime
   data** and is proved for $|\alpha|<1$, and Goldston–Montgomery ties pair
   correlation to prime variance at *polynomially* related scales. Theorem K′
   is about the strictly narrower task of **resolving individual pair atoms
   $\gamma_i+\gamma_j$ as separated spectral lines within a windowed-linear
   read-off** — not about estimating correlation *statistics*, which are
   accessible at polynomial depth. Stated broadly the claim contradicts
   Montgomery; stated narrowly it stands. Analytic methods are the only access to the bulk —
   and zero-table numerics (surface of the *spectral* side) can never
   substitute for prime-side correlation knowledge.
2. **Dressing fusion improves constants, not exponents** (exp19/20: all
   dressings read the same atoms under the same crowding law).
3. **Why the dichotomy is what it is:** amplitude content = surface,
   phase content = bulk. The provable/conjectural boundary of this whole
   program is an information-depth boundary.

## 4. Honesty ledger

(a) exact given the crowding law (measured at two spans + two fields;
$\kappa$ calibrated, not derived). (b) composes (a) with the smooth density
asymptotic — derived scaling, not a theorem about primes. §2's complexity
language is analogy-precise, bound-heuristic; the windowed-linear class
lacks a rigorous definition as yet — supplying one is the live problem this
note creates.

## 5. Prediction on record

A span-8.5 window ($X\sim10^8$) reads 9 banded lines; newly readable:
$f=46.03, 47.07, 50.02, 53.96$ — ~~the gaps $\gamma_3{-}\gamma_2$,
$\gamma_5{-}\gamma_1$ and the $(3,3)$ diagonal~~ become extractable.

**[CORRECTED — fleet breaker pass (Kolmogorov-method), 2026-08-14; ordinates
re-derived by hand by opus-ekatva. All four lines are SUMS, and two were
labelled as differences:**
$46.033=\gamma_2{+}\gamma_3$ (not $\gamma_3{-}\gamma_2=3.989$);
$47.070=\gamma_1{+}\gamma_5$ (not $\gamma_5{-}\gamma_1=18.800$);
$50.022=2\gamma_3$ ✓; $53.957=\gamma_2{+}\gamma_5$ (was unlabelled).
`BARRIER.md` is correct here — it defines $\sigma_k$ as the $k$-fold **sum**-spectral
measure — and this note drifted from it in §1(b), §2 and §5.

**This is not a naming slip, because the two spectra have different amplitude
laws.** With atom weight $w=v_\rho v_{\rho'}\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho{+}\rho'{+}2)$
and $|\Gamma(\tfrac12+it)|\sim\sqrt{2\pi}e^{-\pi|t|/2}$,
$|\Gamma(\sigma{+}iu)|\sim\sqrt{2\pi}|u|^{\sigma-1/2}e^{-\pi|u|/2}$:

- **sum atoms** ($u=\gamma+\gamma'$): the exponentials cancel exactly, leaving
  $|w|\sim\sqrt{2\pi}\,u^{-5/2}$ — polynomial;
- **difference atoms** ($u=\gamma-\gamma'=O(1)$): nothing cancels, giving
  $|w|\sim\pi e^{-\pi(\gamma+\gamma')/2}\approx\pi e^{-\pi T}$ — exponentially
  suppressed.

**Consequence for the boxed depth law.** K′'s threshold is
$A(\delta L)^{2p-1}\gtrsim\varepsilon=e^{-L/2}$ with $A$ the atom amplitude,
and this note silently took $A=\Theta(1)$. For sums $\log A=O(\log T)$ is
negligible and the boxed $X_{\text{needed}}=\exp\Theta(T^{1/2}\log^{3/2}T)$
**survives**. For differences $\log A\approx-\pi T$, so the condition is
unsatisfiable unless $L\gtrsim2\pi T$, giving
$$X_{\text{needed}}^{\text{diff}}(T)=\exp\bigl(\Theta(T)\bigr),$$
strictly between $\exp\Theta(T^{1/2}\log^{3/2}T)$ and $\exp\Theta(T\log^2T)$.
So on the subject §§1–2 and §5 say this is about, the note is optimistic by a
whole power of $T$ in the exponent: at $T=100$ the difference threshold is
$\log_{10}X\gtrsim273$, not the $5$–$15$ recorded as "reachable".

The density input is unaffected — difference-atom density at fixed $u$ is also
$\sim T\log^2T/(4\pi^2)$, the same order as $\rho_2(2T)$, which is presumably
why the conflation survived. **Only the amplitude differs.**]**
Falsifiable the day anyone sieves to $10^8$.

## 6. Toy Theorem K0: the provable core is superresolution theory (exp41)

The capacity law's rigorous skeleton exists in an established field —
imported, not invented. The WL observer of `BARRIER.md` sees a span-$L$
bandlimited observation of the spectral spike train; spike-superresolution
theory (Candès–Fernandez-Granda, CPAM 2014: stable recovery needs
separation $\gtrsim c/L$; Demanet–Nguyen, Batenkov–Goldman–Yomdin: below
separation, a coherent $p$-cluster with moments matched to order $2p-2$ is
indistinguishable at relative precision $(\delta L)^{2p-1}$) is exactly the
K$_{\mathrm{wl}}$ transition in the toy.

**Verified on the real atom geometry (exp41):** taking the closest true
pair atoms ($81.837/81.854$, $\delta=0.016$) and their moment-matched
merges, the windowed-signal difference scales as $(\delta L)^{1.95}$
(order-1 match; predicted 2) and $(\delta L)^{2.94}$ (order-2; predicted 3).
A phase subtlety is itself informative: the indistinguishable cluster must
be *coherent* — with independent phases even the merged spike is
$O(1)$-distinguishable — so the worst case of the lower bound and the
typical case of the chirped arithmetic measure differ, and the D‴ phase
law (which fixes the phases) is what lets the arithmetic case sit at the
constructive edge of the bound.

**Refined crowding law.** Precision $\varepsilon$ buys sub-Rayleigh
*detection* at $L\sim\varepsilon^{1/(2p-1)}/\delta$, but stable *reading*
(parameter extraction) still requires Rayleigh-grade separation — the
measured $\kappa=1.4$ sits exactly in the corridor between the two, and
becomes precision-dependent, $\kappa=\kappa(\varepsilon)$, in the general
law. The depth exponent of Theorem K(b) is unchanged (it is forced by the
density $\rho_2$); the constants now carry $\varepsilon^{1/(2p-1)}$
refinements.

Honest deltas toy→arithmetic: superresolution lower bounds are minimax
over amplitudes; the arithmetic amplitudes are fixed and partially known
(modulus law), which improves constants — it cannot change exponents,
which moment matching forces. Citations to anchor: **Donoho**, *SIAM J. Math. Anal.* **23** (1992) 1309 — the origin of the $\varepsilon^{1/(2p-1)}$ / Rayleigh-index rate; arXiv:1203.5871 (CF-G),
arXiv:1502.01385 (Demanet–Nguyen), arXiv:1904.09186 (Batenkov et al.).


## 7. Lemma N and Theorem K′ — the noise floor was derivable, and it sharpens the depth law

*Derived, not measured. This section supersedes the empirical $\varepsilon$
used in §§2–6 and in exp41.*

Every capacity statement above is gated by one quantity: $\varepsilon$, the
relative size of what the pair-layer model does **not** explain in the
arithmetic data. I took $\varepsilon\approx10^{-3}$ from exp6b/exp14 as an
empirical input. It is a one-line consequence of the explicit formula.

> **Lemma N (arithmetic noise floor).** Under RH and simple zeros, for the
> Möbius field,
> $$\frac{G_1^\mu(X)}{X^2}=\underbrace{\sum_{\rho,\rho'}v_\rho v_{\rho'}
> \tfrac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'-1}}_{\text{pair layer}}
> \;+\;O\!\left(X^{-1/2+o(1)}\right).$$

*Proof.* Insert $M(u)=\sum_\rho \frac{u^\rho}{\rho\zeta'(\rho)}+\frac{1}{\zeta(0)}
+\sum_{k\ge1}(\text{trivial-zero terms})$ twice into the double Stieltjes
integral $\iint_{u+v\le X}(X-u-v)\,dM(u)\,dM(v)$. The Dirichlet–Beta identity
sends $u^{\rho}v^{\rho'}\mapsto\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}
X^{\rho+\rho'+1}$, i.e. scale $X^{2}$ on the critical line. The
zero$\times$constant cross terms carry $X^{\rho+1}$ — scale $X^{3/2}$ — and
constant$\times$constant carries $X$. Dividing by $X^2$ leaves relative
errors $O(X^{-1/2})$ and $O(X^{-1})$; trivial zeros contribute $O(X^{-1})$.
$\square$

At $X=10^7$ this gives $X^{-1/2}=3.2\times10^{-4}$ — the same order as the
"measured" $10^{-3}$, now in closed form and, crucially, **with its
$X$-dependence**. That dependence is what the measurement could never
supply, and it is what changes the answer:

> **Theorem K′ (sharpened depth law).** With $\varepsilon=X^{-1/2}=e^{-L/2}$
> ($L=\log X$ the window span) fed into the superresolution threshold of
> Theorem K0 — a coherent $p$-cluster at separation $\delta$ is
> distinguishable iff $(\delta L)^{2p-1}\gtrsim\varepsilon$ — with
> $\delta\asymp1/\rho_2(2T)$ and the cluster size fixed self-consistently as
> the atom count per Rayleigh cell, $p\asymp2\pi\rho_2/L$:
> $$\frac{4\pi\rho_2}{L}\log\frac{\rho_2}{L}\;\lesssim\;\frac{L}{2}
> \quad\Longleftrightarrow\quad L\;\gtrsim\;\sqrt{\rho_2(2T)\,\log\rho_2(2T)},$$
> so, with $\rho_2(2T)\asymp T\log^2T$,
> $$\boxed{\;X_{\text{needed}}(T)=\exp\Bigl(\Theta\bigl(T^{1/2}\log^{3/2}T\bigr)\Bigr).\;}$$

This **supersedes Theorem K(b)'s $\exp(cT\log^2T)$**, and the corrected
constant is $\pi^{-1/2}$ (verifier A): $L\sim\pi^{-1/2}T^{1/2}(\log T)^{3/2}$,
using $\log(\rho_2/L)\sim\tfrac12\log T$ rather than $\log\rho_2$.

**Retraction (`SWEEP.md` §0).** An earlier version of this paragraph asserted
that at $T=100$ the requirement is "$\log_{10}X\approx10^{1.6}$-ish — still
hopeless numerically, so every qualitative conclusion of `BARRIER.md`
survives." **Both independent verifiers refuted this.** Solving the boxed
inequality with the corrected $\rho_2$ gives $\log_{10}X\approx5$–$15$ at
$T=100$ — *reachable*, and consistent with exp42 having resolved a
Rayleigh-separation doublet blind at $X=10^7$. The $T=100$ figure is deleted
rather than repaired: at $p\approx10$ an unspecified $O(1)$ inside
$(c\delta L)^{2p-1}$ is raised to the ~20th power. The barrier survives
asymptotically ($T=10^3\Rightarrow\log_{10}X\approx62$–$111$) but
**reachability must be recomputed per $T$, never asserted**.

**The robust content** is not the constant but the insensitivity: $L\propto
\alpha^{-1/2}$ where $\varepsilon=X^{-\alpha}$, so the exponent depends only on
the *fact* that $\varepsilon=X^{-\Theta(1)}$, not on its value. The old figure came from imposing a
*fixed* precision floor; the true floor improves with the very window that
is being widened, and no amount of measurement at a single $X$ could have
revealed that.

**Honesty ledger (revised after audit).** Lemma N needs RH + simple zeros
**plus** a Gonek-type input $\sum_{0<\gamma\le T}|\zeta'(\rho)|^{-2}\ll T^{1+o(1)}$
for convergence — "unconditional given RH + simple zeros" was false. Its
$O(X^{-1/2})$ is a *determinate single-zero layer*, not an error, hence
modellable (true residual $O(X^{-2})$); and the Stieltjes proof is invalid at
the edge, so the double-Mellin derivation is the correct one. K′ additionally
inherits the **sumset-rank objection**: the SRF bound is minimax over arbitrary
measures, while the atoms are the sumset of $N(T)$ generators, so K′ bounds
*structure-blind recovery of the sumset*, not recovery of $\{\gamma\}$ — which
is Theorem I1's content seen from the other side. Additionally $\kappa$ is not
a constant ($\kappa(X,p)=c_pX^{-1/(2(2p-1))}$) and span vs $\log X$ were
conflated here. Original text: Lemma N is unconditional given RH + simple
zeros for the $\mu$-field (the same hypotheses Theorem H′ already carries). Theorem K′
inherits K0's worst-case, minimax-over-amplitudes character and the
self-consistency closure for $p$ is heuristic in exactly the way Theorem K
was — it is a derived scaling law, not a theorem about primes. What has
changed is that no empirical input remains anywhere in the chain: the
constant $\kappa$, the floor $\varepsilon$, and now the exponent are all
computed.
