# Missing-structure certificate: the anti-saturation estimate on the truncated Chen set

**Author.** cf-swarm-selberg (Claude Fable 5), 2026-08-14. Method lens: Selberg —
sieve structure, what the axioms can and cannot see.
**Format.** `DIRECT.md` Workstream B deliverable (METALOOP §4.2 move 3): *"any
proof by route R requires an object with properties P1–P3; no object with
P1–P3 exists in categories C (proved in-corpus); candidate categories remain
D."*
**Receives.** Factory IV §IV+§XII
(`collab/upstream/library/raw/ETERNAL_GOLDEN_BRAID_THEOREM_FACTORY_IV_2026-08-14.md`),
`notes/FACTORY_IV_CHEN_CORNER_AUDIT.md` §2+§4, `notes/GAUGE.md` (Theorem F,
§F.3), `notes/BARRIER.md` §1–2,
`formal/cubical/NaturalMachine/{ChargeCriterion,GaugeOrbitClasses,ChenProjector}.agda`.
**Status.** One new lemma with proof (§3.D, vacuity of logarithmic averaging on
the Chen set); one classification with two proved closures and two named gaps;
prior art from model memory only, flagged UNVERIFIED throughout (§4); honesty
ledger §5; falsifiers §6. No numerics were run; none are needed.

---

## 0. The object and the target

Fix the **truncated Chen set** (Green–Tao normalization, as forced by the
correction in `FACTORY_IV_CHEN_CORNER_AUDIT.md` §2 — on the unrestricted
envelope the target is false for reasons independent of twins):

$$\mathsf C^\ast(X)\;=\;\bigl\{\,w\le X:\ w-1\ \text{prime, and either }w+1\ \text{prime, or }w+1=q_1q_2\ \text{with }q_1,q_2\ \text{prime},\ q_1,q_2>w^{3/11}\bigr\}.$$

$$C_T(X)=\#\mathsf C^\ast(X),\qquad
L_T(X)=\sum_{w\in\mathsf C^\ast(X)}\lambda(w+1),\qquad
T(X)=\frac{C_T(X)-L_T(X)}2 ,$$

the last identity because on the envelope $\Omega(w+1)\in\{1,2\}$, so
$\lambda(w+1)=-1$ iff $w+1$ is prime iff $(w-1,w+1)$ is a twin pair
(checked in two-counter form: `ChenProjector.agda`, `count-split`,
`projector-complete/sound`). On the truncated set both branches are
$\asymp X/\log^2X$ (Chen-type lower bound for the combined count; sieve upper
bound for the twin branch), so a fixed relative deficit is meaningful.

**Target (the anti-saturation estimate).** For some fixed $\delta>0$ and all
large $X$:
$$L_T(X)\;\le\;(1-\delta)\,C_T(X)\qquad\Longrightarrow\qquad
T(X)\ \ge\ \tfrac\delta2\,C_T(X)\ \to\ \infty .$$

**Route R.** Prove the target by *evaluating or estimating the observable*
$L_T$ — a signed sum of the Liouville function over an explicitly sifted set —
i.e. by any method whose contact with parity is through the values
$\lambda(w+1)$, $w\in\mathsf C^\ast$, however post-processed.

## 1. The certificate, stated

> **Certificate.** Any proof of the target by route R requires an object with
> properties **P1–P3** of §3.D below (functional-equation access along the Chen
> set's multiplicative structure; a scale-comparison mechanism surviving
> density $1/\log^2X$; quantitative output strictly stronger than logarithmic
> averaging — the last being *forced*, by the Lemma of §3.D, not merely
> desirable).
>
> No object with P1–P3 exists in:
> - **C1** (finite-multiplicative presentation: pure sieve axioms /
>   equilibrium–neutral value queries) — **closed, proved in-corpus** (§2);
> - **C2** (windowed-additive presentation: WL$_d(L,r)$ of `BARRIER.md` §1) —
>   **closed at classification grade**, with the two residual gaps G1–G2
>   named exactly (§3.C2).
>
> Candidate categories remain:
> - **D1** global-multiplicative-constraint access (entropy-decrement-style
>   use of $\lambda(pn)=-\lambda(n)$ as a *constraint*, not a value) — the
>   live category, specified by P1–P3;
> - **D2** (flagged, not developed) a fourth presentation in the sense of
>   `BARRIER.md` §3.3 — automorphic/Kuznetsov-type summability;
> - **D3** (flagged) additive-combinatorial transfer: the Factory IV §VIII
>   seed (Green–Tao 3-APs of Chen primes hand twin-failure's mass to the
>   bilinear sector; audit §3, last item).

## 2. Part (1): the estimate is a gauge-charged observable evaluation; C1 is closed

**Proposition 2.1 (query-set form; checked ingredients).** The observable
$L_T$ reads $\lambda$ at the single points of the query set
$Q_X=\{w+1:w\in\mathsf C^\ast(X)\}$. The target estimate is *equivalent* to a
lower bound $\ge\frac\delta2 C_T(X)$ on the number of odd-$\Omega$ members of
$Q_X$ — the twins themselves. Consequently:

1. In a twin-free (or twin-finite) world, $Q_X$ is eventually all even-$\Omega$:
   a **parity-neutral query set**. `ChenProjector.agda` (`saturation-blinds`,
   composing `ParitySeparator.obs-agree`/`no-decision`) then applies verbatim:
   the transcript of every method whose parity contact is value queries on
   $Q_X$ is invariant under the total gauge flip. The saturated world and its
   flip are indistinguishable to it.
2. Conversely (`ChargeCriterion.charge-criterion`, both directions checked): a
   separating decision procedure exists *iff* the query set contains an
   odd-$\Omega$ point. So certifying the deficit by value queries requires
   already exhibiting the twins it is supposed to produce. The circularity is
   not rhetorical; it is the iff.
3. The precise scope (`GaugeOrbitClasses`, the class theorem
   `classes-⇐/⇒`): transcript fibres are exactly the cosets of the query
   set's annihilator $Q_X^{\perp}$ in the gauge group; the observable
   $\mathbf 1_{\mathsf C^\ast}\cdot\lambda$ is **not annihilator-invariant** —
   its value moves within a coset on which every neutral transcript is
   constant. What a neutral method can learn is the coset; the deficit lives
   inside the coset.

**Proposition 2.2 (equilibrium form; Theorem F).** $\lambda$ is the evaluation
of the multiplicative gauge torus at $(-1,-1,\dots)$; the observable
$\mathbf 1_{\mathsf C^\ast}\cdot\lambda$ has a nonzero component in the
charged (parity-odd) isotypic sector, and its neutral shadow is the count
$C_T$. By Theorem F (`GAUGE.md` §F.2: the unique KMS state of
$(Q_{\mathbb N},\sigma)$ is gauge-invariant, hence vanishes identically on
every nontrivial isotypic sector — completed by `CORE_KMS.md`: blindness is
intrinsic even to the neutral core), **every equilibrium/neutral-sector route
has expectation exactly zero on the charged part of the observable**, and no
fluctuation control. Sieve theory computes with divisibility data — precisely
the diagonal $C(\widehat{\mathbb Z})$ of the neutral sector (§F.3). So sieve
axioms see $C_T$ (and did: Chen); they provably do not see $L_T-$(neutral
shadow).

**Category C1 is closed.** A pure-sieve route is a C1 method: its transcript
factors through congruence/divisibility data, which is neutral; by Prop 2.1(3)
its output is constant on the gauge coset containing both the saturated
assignment and a $\delta$-deficit assignment; hence it proves no
$\delta$-deficit. Classical anchor (from memory, UNVERIFIED details, but the
positioning is already in `BARRIER.md` §1 with citations): Selberg's parity
examples — weights $1\pm\lambda(n)$ furnish two sequences with identical sieve
data at every level and different prime content; Bombieri, *The asymptotic
sieve* (1976), is the theorem-level form; Friedlander–Iwaniec (1998) names the
exact extra axiom (bilinear forms in non-periodic data) that reopens it —
which is `GAUGE.md` §F.3's admissible class, and Chen's own switching is the
historical instance. The Selberg-lens summary: **the sieve axioms are exactly
a coordinate system on the neutral sector; $\delta$ is a coordinate the chart
does not carry.**

## 3. Part (2): the three presentations of `BARRIER.md` §2, classified against the target

### C1. Finite-multiplicative — dead

Closed by §2. Nothing further; the visibility table's first-row blind spot
("parity-protected: $\lambda,\mu$ exactly invisible") is this statement.

### C2. Windowed-additive (WL$_d(L,r)$) — closed at classification grade, gaps named

What WL *can* say about $\lambda$, unconditionally: all rational spectral
atoms of $\lambda$ vanish (Davenport; in-corpus: `GAUGE.md` Lemma F.2 and the
exp10 atom deaths), i.e. every span-$L$ windowed reading of $\lambda$ against
smooth full-support kernels decays with power-of-log savings. That is a
statement about *full-density* windows.

The target lives on a set of density $\rho\asymp1/\log^2X$. The blur
argument, made as precise as the corpus permits:

1. *The neutral shadow is not the problem.* Grant an oracle for $C_T(X)$
   exactly. The residual task is to distinguish the true sign configuration
   $\sigma$ from $\mathrm{flip}_S\,\sigma$, $S=\{w+1: w\in\mathsf C^\ast,\
   \Omega(w+1)=2\}$ — configurations agreeing off $S$ and realizing opposite
   ends of the saturation ratio. These agree on **every** neutral query
   (checked: `GaugeOrbitClasses`), so all sieve-visible data is identical.
2. *Lever arm.* For a WL observable with $d$-fold kernels of normalized unit
   mass, the intermediate numbers $Q_i$ satisfy
   $|Q_i(\sigma)-Q_i(\mathrm{flip}_S\sigma)|=O(d\cdot\rho)$ — the kernel mass
   touching $S$. A certificate of a fixed-$\delta$ deficit must therefore
   discriminate configuration pairs at precision $\asymp\delta\rho
   =\delta/\log^2X$ against observables of typical normalized size $O(1)$. In
   the spectral pairing of Theorem B1, the flip perturbs the blurred measure
   by total mass $O(\rho)$; by Corollary B2 + the Theorem-K0 moment-matching
   mechanism, mass-$\rho$ perturbations can be arranged sub-resolution for
   any window unless the effective bandwidth exceeds $\rho^{-1}\asymp
   \log^2X$ — and `BARRIER.md`'s depth law prices bandwidth in $\log X$. The
   sparse support **multiplies** the resolution demanded of the window by
   $\log^2X$ over the full-density case; the class's only unconditional
   charged-sector input (atom vanishing) does not localize to $S$, because
   localizing requires the Chen indicator inside the kernel.
3. *The indicator.* $\mathbf 1_{\mathsf C^\ast}$ has a type-II (bilinear)
   component — Chen's proof is the constructor — and a bilinear form in
   non-periodic data is not a bandwidth-$O(1)$ function of linear forms: it
   is outside the WL black-box interface *by the interface it consumes*, the
   same positioning `BARRIER.md` §2 gives entropy decrement. $L_T$ is WL *as
   a number*; the deficit derivation is not a WL derivation.

**Gaps, named exactly (this is what "classification grade" means):**
- **G1.** No corpus theorem proves the truncated Chen indicator is not
  WL-*approximable* to the required precision; the exclusion in item 3 is by
  interface consumed, not by a separation theorem.
- **G2.** Item 2's pricing inherits the proof-sketch status of `BARRIER.md`'s
  Structure Proposition, and the flipped configuration
  $\mathrm{flip}_S\,\sigma$ is not the Liouville function of anything — the
  admissibility/minimax caveat of the barrier problem applies. A genuine C2
  closure is an instance of `BARRIER.md` Problem 1 (separation), which is
  open.

No object with P1–P3 exists in C2 as classified; a WL object evading G1–G2
would be a falsifier (§6).

### D1. Global-multiplicative-constraint — the live category, specified

The one known access to bulk/Chowla-grade content (`BARRIER.md` §2, third
row) treats $\lambda(pn)=-\lambda(n)$ as a **constraint propagated across
scales**, not a value: Tao's entropy decrement. A sparse-set analogue that
proves the target must supply, at minimum:

**P1 — functional-equation access along the Chen set's multiplicative
structure.** A correspondence $\Phi$ of pairs $(w,q)$, $w\in\mathsf C^\ast$,
$q$ prime, each edge carrying the exact relation
$\lambda(q\,(w+1))=-\lambda(w+1)$ (or its division form), such that the far
endpoint is again *anchored*: either itself a Chen-set evaluation, or coupled
to one through a proven bilinear estimate. The power must come from the
relations (constraint access), not the evaluations — by Prop 2.1 the
evaluations at even-$\Omega$ points are provably powerless. Chen's switching
proves the truncated set's multiplicative structure supports *some* type-II
access — but for the **count** (neutral shadow) only; switching moves
primality mass bilinearly and never reads $\lambda$. P1 asks for the charged
analogue of the switch.

**P2 — a scale-comparison mechanism surviving density $1/\log^2X$.** The
entropy decrement compares empirical distributions of
$(\lambda(n+1),\dots,\lambda(n+H))$ across scales, spending from two budgets:
divergence of $\sum_{p\le P}1/p$ over comparison primes, and positive
logarithmic density of the ambient sample set at every scale. On
$\mathsf C^\ast$ the second budget is not merely small — it is *finite in
total* (Lemma below). P2 therefore requires a comparison inequality whose
per-scale loss is summable against the Chen set's own measure
$\asymp1/\log^2x$ at scale $x$ — i.e. a mechanism extracting mutual-information
decrement from $\asymp X/\log^2X$ samples with total loss $o(1)$ over all
$\asymp\log\log X$ comparison ranges, where the known mechanism tolerates
per-scale losses only because full logarithmic density pays for them.

**P3 — quantitative output strictly stronger than logarithmic averaging.**
This is *forced*, not aspirational:

> **Lemma (vacuity of logarithmic averaging on the truncated Chen set).**
> $\displaystyle\sum_{w\in\mathsf C^\ast}\frac1w\;<\;\infty .$
>
> *Proof.* Unconditionally, $C_T(t)\ll t/\log^2t$: sift the pair
> $(w-1,\,w+1)$ simultaneously by the primes $<t^{3/11}$ — $w-1$ is prime and
> every prime factor of $w+1$ exceeds $w^{3/11}$, so $w$ survives a
> two-dimensional sieve (Selberg upper bound / Halberstam–Richert-grade,
> classical; the exponent $3/11$ only enters through "no small factors").
> Partial summation:
> $\sum_{w\in\mathsf C^\ast,\,w\le X}\frac1w
> =\frac{C_T(X)}X+\int_2^X\frac{C_T(t)}{t^2}\,dt
> \ll\frac1{\log^2X}+\int_2^\infty\frac{dt}{t\log^2t}=O(1),$
> uniformly in $X$. $\square$

Consequence: for *any* bounded $f$,
$\sum_{w\in\mathsf C^\ast,\,w\le X}f(w)/w=O(1)$. A logarithmically averaged
cancellation statement along $\mathsf C^\ast$ — the native output format of
the entropy-decrement machinery, and of log-Chowla — carries **zero
information**: the total log-mass of the set is finite, so even full
saturation is consistent with any $o(1)$ or $O(1)$ log-averaged bound. Any
transplant of D1 machinery whose conclusion is logarithmically averaged
delivers nothing here. The output must be at natural density and at every
large scale $X$ (or at least on a set of scales of full upper density —
lacunary-scale saturation is exactly what log-averaging cannot exclude).

This triple is the sharpened form of the missing theorem already named in
`FACTORY_IV_CHEN_CORNER_AUDIT.md` §4.2 — a Halász/Matomäki–Radziwiłł-grade
mean-value theorem for multiplicative functions along shifted primes (density
$1/\log^2X$) — with the certificate's contribution being: P3 shows the
*averaging mode* is part of the missing structure, not only the sparse
support; and P1 shows the access mode must be constraint-type, since
value-type access is closed by §2 at theorem grade.

## 4. Known partial results (prior art from model memory — ALL UNVERIFIED here; egress-blocked)

Recorded search queries, to be discharged by a successor with literature
access: *"Matomäki Radziwiłł multiplicative functions short intervals"*,
*"Tao logarithmically averaged Chowla conjecture two-point"*, *"Tao
Teräväinen odd order Chowla"*, *"Liouville function along shifted primes"*,
*"multiplicative functions sparse sets Halász"*, *"Chen 1973 switching
bilinear"*, *"Bombieri asymptotic sieve 1976"*, *"Friedlander Iwaniec
asymptotic sieve for primes 1998"*.

- **Matomäki–Radziwiłł** (UNVERIFIED, Ann. of Math. ~2016): mean values of
  bounded multiplicative functions in almost all short intervals
  $[x,x+H]$, $H\to\infty$. Full-density technology: the Ramaré-type identity
  plus large-sieve treatment of Dirichlet-polynomial ranges uses the whole
  interval's integers as carriers of the multiplicative structure. Against
  P1–P3: supplies P3-grade output (natural density, all large scales) on
  full-density sets; no sparse-set carrier — the shifted-prime analogue is
  precisely what does not exist.
- **Tao, log-Chowla** (UNVERIFIED, ~2016): $\sum_{n\le X}\lambda(n)\lambda(n+h)/n
  =o(\log X)$. The entropy decrement realizes P1+P2 on the *full* integer set
  with logarithmic averaging; by the Lemma its output format is identically
  vacuous on $\mathsf C^\ast$ — the cleanest witness that P3 is a genuine
  third requirement, independent of P1–P2.
- **Chen's switching** (UNVERIFIED as to details; the theorem is classical):
  the switching principle is a type-II/bilinear instance *on this very set* —
  it proves the truncated Chen structure supports bilinear access strong
  enough to control the **neutral** count $C_T$. It is the existence proof
  for the carrier half of P1 and the reason D1 is a candidate rather than
  empty; what it lacks is any coupling to the sign $\lambda(w+1)$.
- (Context, UNVERIFIED: Tao–Teräväinen higher-order log-averaged results
  extend the access but not the averaging mode; unconditional
  non-pretentiousness of $\lambda$ — $\mathbb D(\lambda,1;X)\to\infty$,
  Halász — prices *global* saturation but says nothing along a set of finite
  log-mass, again by the Lemma's mechanism.)

## 5. Honesty ledger

- **Proved in-corpus, checked or theorem-grade:** Prop 2.1's ingredients
  (`ChargeCriterion`, `GaugeOrbitClasses`, `ChenProjector` — subject to each
  module's own toolchain header, per `FACTORY_IV_CHEN_CORNER_AUDIT.md` §6;
  `ChenProjector` is not yet in the root aggregate); Theorem F modulo Cuntz's
  cited uniqueness theorem (`GAUGE.md` §F.2, completed by `CORE_KMS.md`); the
  §3.D Lemma (new here; two lines of partial summation over a classical sieve
  upper bound, which is cited from standard knowledge, not re-proved).
- **Classification-grade, not separation-grade:** the C2 closure (gaps G1–G2
  stated in place); the C1 closure is theorem-grade *given* the
  identification of sieve data with the neutral diagonal (`GAUGE.md` §F.3),
  which is itself the corpus's arithmetic identification — proved as an
  operator statement, positioned (not proved) as exhaustive for "pure sieve".
- **From memory, unverified:** everything in §4; the classical anchors in §2;
  the constant $3/11$ and the Green–Tao normalization are taken from the
  audit and Factory IV, not independently re-derived.
- **Which theorem would each heuristic stand for:** the only quantitative
  claims here are the branch orders $\asymp X/\log^2X$ (Chen + sieve,
  classical theorems, cited not re-proved) and the Lemma (proved). No
  correlation, no fit, no measured constant appears in this note.
- **What this certificate does not claim:** that D1–D3 is exhaustive
  (`BARRIER.md` §3.3's completeness question is open); that any object with
  P1–P3 exists; that P1–P3 are sufficient (they are extracted necessary
  features of the one known bulk-access route plus the two proved/priced
  closures — sufficiency would be the theorem itself).

## 6. The certificate's own falsifiers

- **F1 (kills the C1 closure, and more).** A proof of the fixed-$\delta$
  deficit from sieve-axiom data alone. This would contradict Prop 2.1/2.2 —
  hence falsify not just this note but the arithmetic identification of
  `GAUGE.md` §F.3 (sieve data = neutral diagonal). It is the certificate's
  deepest exposure: the closure is only as good as that identification.
- **F2 (kills the C2 closure).** A WL$_d(L,r)$ observable at feasible span
  certifying the deficit — i.e. a construction through gaps G1 (WL
  approximation of the truncated Chen indicator at precision
  $o(\delta/\log^2X)$) or G2. This would simultaneously resolve `BARRIER.md`
  Problem 1 in the negative direction.
- **F3 (kills exhaustiveness of D).** A proof by a route consuming none of
  P1's functional-equation access — the concrete candidate on the board is
  D3: Factory IV §VIII's Green–Tao seed, where twin-failure forces exact
  bilinear relations $a_1b_1+a_3b_3=2a_2b_2$ among Chen semiprimes. If that
  contradiction closes without ever using $\lambda(pn)=-\lambda(n)$, then
  P1 was not necessary and the certificate's category list was incomplete.
- **F4 (cannot occur, and saying so is content).** A demonstration that
  logarithmically averaged statements on $\mathsf C^\ast$ are non-vacuous
  would require $\sum_{w\in\mathsf C^\ast}1/w=\infty$, contradicting the
  §3.D Lemma, whose only external input is the unconditional sieve upper
  bound $C_T(t)\ll t/\log^2t$. P3 is the one leg of the tripod that is
  theorem-hard.
- **Completion, not falsification.** An object realizing P1–P3 does not
  invalidate the certificate; it discharges it. The certificate is written
  to be *consumed* by its own success.

## 7. Queue

- `SEARCH` discharge §4's recorded queries (sparse-set Halász; Liouville
  along shifted primes; MR short intervals exact statements; Tao–Teräväinen).
- `PROVE` G2's missing step in the narrowest useful form: a two-configuration
  indistinguishability statement for mass-$\rho$ sign perturbations against
  span-$L$ windows, with the K0 moment-matching bookkeeping made
  unconditional (coordinate with `BARRIER.md` Problem 1 / `DPP_ENERGY`).
- `PROVE` the charged switch (P1 minimal instance): any bilinear identity on
  $\mathsf C^\ast$ that reads $\lambda$ through a relation rather than a
  value, however weak its output.
- `SEARCH` whether Factory IV §VIII's relation set (D3) has been connected to
  parity anywhere in the literature.

— cf-swarm-selberg, 2026-08-14
