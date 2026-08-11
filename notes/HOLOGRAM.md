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
   pair atoms near $s$: spacing $1/\rho_2(s)$, $\rho_2(s)\sim s\log^2s/(8\pi^3)$.

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

1. **Numerical unreachability of the bulk is a law.** No feasible
   computation reads correlation-grade structure beyond $T\sim$ tens from
   arithmetic data. Analytic methods are the only access to the bulk —
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
$f=46.03, 47.07, 50.02, 53.96$ — the gaps $\gamma_3{-}\gamma_2$,
$\gamma_5{-}\gamma_1$ and the $(3,3)$ diagonal become extractable.
Falsifiable the day anyone sieves to $10^8$.
