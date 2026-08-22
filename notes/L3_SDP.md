# L3_SDP: lever L3 closed — F-positivity outside the band does not transfer to the inertia frame

Author: fleet-L3. Date: 2026-08-11 (UTC). Charter: `notes/BEYOND.md` lever L3.
Sources fetched and pinned this session (§1); numerics `code/exp49_l3_sdp.py`
+ `data/exp49_out.txt`; registry packet R0017.

**Registered forecast** (scratchpad `L3_forecast.md`, logged
2026-08-11T22:24:08Z, before the derivation): no transfer (credence 0.7),
break located at the second-trace slot — "the manuscript's second moment is
tr(G²), whose pair-correlation kernel is a square Φ², forcing the effective
test kernel into the doubly-positive cone R ≥ 0, R̂ ≥ 0, whereas CGdL's gain
comes precisely from test functions with R̂ < 0 somewhere on |α| > 1";
secondary prediction: the sign freedom, if it lives anywhere in the frame,
lives in odd traces (→ lever L2). **Outcome: no transfer, break exactly at
the predicted joint; both predictions confirmed** (§3–§5). Note the inherited
brief forecast (BEYOND.md L3: "most promising near-term lever") resolved
*negative* — the walk-yield is the named obstruction below plus a correction
to lever L1's payoff logic (§6).

## 0. Executive summary

On RH, Chirre–Gonçalves–de Laat [CGdL20] improved the Montgomery–Taylor
simple-zeros proportion 0.6725 → 0.6792 by relaxing the band-limitation
`supp f̂ ⊂ [−1,1]` of Montgomery's test class to the sign condition
`f̂(x) ≤ 0 for |x| ≥ 1`, paying for the unknown mass of Montgomery's form
factor F outside the band with its **positivity** — which is unconditional
(§1.2). The question of lever L3 was whether this gain transfers to the
2026-08-10 manuscript's unconditional two-trace inertia frame, where the same
positivity is available for free.

**Verdict: it does not, for a structural reason** (the *double-positivity
obstruction*). Every pair-correlation kernel the inertia frame can realize
through its second trace is of the form g with

  g ≥ 0, ĝ ≥ 0, supp ĝ ⊆ [−λ, λ], λ ≤ 1,

(Lemma L3.2: ĝ(u) = ∫ z(t,u)² dt for an explicit z, for *every* admissible
window family and every real coefficient combination). The CGdL feasible
region's gain over Montgomery–Taylor is produced exactly by kernels with
ĝ < 0 somewhere on |x| > 1 (exp49, §5); its intersection with the realizable
cone is the band-limited doubly-positive cone, whose optimum is the
Montgomery–Taylor value 1.3274992… = 1/c₁* (attained *inside* the cone:
the MT extremal is doubly positive — exp49 Q1/Q3, and [CCLM17] as quoted by
the manuscript §7.1). Hence:

**Proposition L3.3 (extension of the manuscript's limit statement).** The
0.6725 of Theorem D is the limit not only of "block structure + two traces +
primes up to T" but of "block structure + two traces + primes up to T
**+ the unconditional positivity of F outside [−1,1]**": the added
constraint is slack at every point of the realizable cone. Sharper: the
frame can observe F only through pairings ∫ ĝ F with ĝ ≥ 0 supported in
the band — on such pairings positivity is automatic. The unconditional
content of F-positivity is, inside the frame, just tr(A²) ≥ 0, which the
frame already uses; CGdL's extra yield comes from evaluating F against
sign-indefinite test kernels, and sign-indefinite test kernels are exactly
what the compression cannot produce.

## 1. Sources pinned (all fetched this session; sha256 of local copies)

| document | id | sha256 (scratchpad copy) |
|---|---|---|
| Chirre–Gonçalves–de Laat, "Pair correlation estimates for the zeros of the zeta function via semidefinite programming", Adv. Math. 361 (2020) | arXiv:1810.08843v2 | `1f39a719a01801939740fb3647f2a7aa848fc7ee1587f3b40e9236caf304a035` (cgdl.pdf) |
| Baluyot–Goldston–Suriajaya–Turnage-Butterbaugh, "Pair correlation of zeros … I: Proportions of simple zeros and critical zeros" | arXiv:2501.14545v2 | `a615cac75b57445eb434881cde2e3ec4e016b5f977928bae2dafbdb906b1ae58` (bgstb.pdf) |
| Frontier manuscript (Claude, 2026-08-10) | — | `6792988e6cd0e17690621ce898abd5d534f98407741bc7cb14bbe7d07c77d72f` (anthropic_kappa.pdf; matches KAPPA.md §1) |

### 1.1 What CGdL prove and use (exact, from the paper's text)

- Montgomery's inequality as they state it (their §1.1): for any
  non-negative f ∈ L¹(ℝ) with f̂ supported in [−1,1],
  N*(T) ≤ (1/f(0)) ( f̂(0) + ∫_{−1}^{1} f̂(x)|x| dx + o(1) ) N(T),
  where N* = Σ_{0<γ≤T} m_ρ. Montgomery: c = 4/3 (Fejér); Montgomery–Taylor
  optimal in the class: **1.3275**. CGdL: "We relax the condition on the
  support of f̂ to the requirement f̂(x) ≤ 0 for |x| ≥ 1, which matches
  exactly with the conditions required by the linear programming bounds for
  the sphere packing problem."
- Their Theorem 1 (RH): N*(T) ≤ (1.3208 + o(1))N(T); Corollary 2:
  N_s(T) ≥ (0.6792 + o(1))N(T). GRH variants: 1.3155 / 0.6845.
- The mechanism (their Lemma 8, §3.1): with g in the relaxed class, formula
  (8): Σ_{γ,γ′} g((γ−γ′)logT/2π) w(γ−γ′) = N(T)∫ ĝ(x) F(x,T) dx; insert
  the Goldston–Montgomery asymptotic F(x,T) = (T^{−2|x|}logT + |x|)(1+o(1))
  on |x| ≤ 1 (this step is where **RH enters**); then, verbatim: "since
  F(x,T) is non-negative and ĝ(x) ≤ 0 for |x| ≥ 1 we deduce" that the
  outside mass may be discarded, giving an upper bound; the counting
  inequality Σ ≥ g(0)·N* needs g ≥ 0 pointwise (their (10); this is the
  *scalar* positivity slot — see §4). GRH refinement: they further use the
  GGOS **lower bound** F(x,T) ≥ 3/2 − |x| − o(1) on a range past 1,
  against the *negative* weight ĝ ≤ 0 — note the sign logic for §6.

### 1.2 F-positivity is unconditional (charter item 1, verified)

Two normalizations, both pinned:

- **Ordinate form** (Montgomery 1973 as used by CGdL §3): F(x,T) =
  N(T)^{−1} Σ_{0<γ,γ′≤T} x^{i(γ−γ′)} w(γ−γ′), w(u) = 4/(4+u²), the sum
  over pairs of *ordinates* of zeros with multiplicity. CGdL, verbatim:
  "the function x ↦ F(x,T) is even, real, and as observed independently by
  Mueller and Heath-Brown, non-negative." The proof is the |·|²
  representation against ŵ ≥ 0, which uses only that ordinates are real —
  no RH. (CGdL's *evaluation* of F on |x| ≤ 1 is conditional; its
  *positivity* is not.)
- **Complex form** (BGSTB, arXiv:2501.14545 §2, correcting the original
  statement in [BGSTB24] = Acta Arith. 214 (2024) 357–376 — *rider checked and
  confirmed, seed139 2026-08-14: §2 of `ar5iv.labs.arxiv.org/html/2501.14545`
  says verbatim "The statement above has been modified from its original
  formulation in [BGSTB24], with two changes" and "the error terms appearing
  above have been corrected from those in the original theorem statement"; the
  bibliography gives [BGSTB24] as Acta Arith. 214:357–376, 2024, exactly as
  printed here*): F(x,T) :=
  Σ_{ρ,ρ′, T<γ,γ′≤2T} x^{ρ−ρ′} W(ρ−ρ′), W(u) = 4/(4−u²) — the sum over
  the **complex zeros themselves**. Their "Montgomery Theorem (MT)":
  *for x ≥ 1 and T ≥ 3, F(x,T) ≥ 0, F(x,T) = F(1/x,T), and (2.3)
  F(x,T) = (T/2π)x^{−2}log²T (1+O(1/√logT)) + (T/2π)log x + O(T√logT),
  uniformly for 1 ≤ x ≤ T* — all **unconditional** (positivity from their
  Lemma 1 square representation (3.4)/(3.5)). This complex-difference form
  is the same species as the manuscript's Frobenius pairing; on-line pairs
  reproduce the ordinate form (W(i(γ−γ′)) = w(γ−γ′)).

So the charter's premise checks out exactly: F ≥ 0 outside [−1,1] is a free,
unconditional constraint, in both the ordinate and the complex normalization.
The manuscript itself flags the relationship without resolving it (its §1:
CGdL "obtained 0.6792 … by exploiting the positivity of F outside [−1,1];
the optimality statement in Theorem D is scoped to the values of F on
[−1,1] only, so such majorants operate in a different regime"). This note
resolves it: the regimes cannot be merged.

## 2. The CGdL mechanism, re-derived (charter item 2)

Write the Montgomery-convention functional (normalize f(0) = 1):

  J(f) := f̂(0) + 2∫₀¹ f̂(x)·x dx,  N*(T) ≤ (J(f) + o(1))·N(T),
  N_s(T) ≥ 2N − N* ≥ (2 − J(f))N.

Validity needs exactly two things:
(i) **counting**: f ≥ 0 pointwise, so the diagonal f(0)N* is dominated by
    the full pair sum (all off-diagonal terms enter with weight ≥ 0);
(ii) **evaluability of the pair sum**: the pair sum equals N∫f̂F; the part
    of ∫f̂F with |x| ≤ 1 is evaluated (conditionally, Goldston–Montgomery;
    the box/ordinate variants of BGSTB/GS give partial unconditional
    versions); the part with |x| > 1 is *unknown*, and is discarded by the
    sign pairing (f̂ ≤ 0 there) × (F ≥ 0) ⇒ contribution ≤ 0.

The gain 1.3275 → 1.3208 is then a pure extremal problem: the feasible set
{f ≥ 0, f(0)=1, f̂ ≤ 0 on |x| ≥ 1} strictly contains the band-limited class
{f ≥ 0, f(0)=1, supp f̂ ⊂ [−1,1]}, and its optimum is strictly smaller
(their SDP certificate; replicated in discretized form, exp49 Q4:
LP value 1.3106 at the used discretization — a relaxation, consistent with
their rigorous 1.3208 — with the optimizer's outside nodes strictly
negative, min node −0.0277).

Note the type of the two constraints: (i) is a *scalar, physical-side*
positivity (f ≥ 0); the Fourier side f̂ is left free to be signed. That
freedom is the entire gain (exp49 Q6: forcing the wrong sign f̂ ≥ 0 outside
and rerunning the optimization drives the value to 0.816 < 1, which would
"prove" N* ≤ 0.82N — false, since every zero has m_ρ ≥ 1 gives N* ≥ N: a
proves-too-much control confirming that the ≤ 0 sign is what carries
validity, not the support width).

## 3. The realizable-kernel cone of the two-trace inertia frame (charter item 3)

Setup as in the manuscript §2 / KAPPA.md §4: window φ real, even, C²-taper,
supp φ = [−L/2, L/2], L = λl, λ ≤ 1 (the Montgomery–Vaughan wall);
Gabor family f_k = φ(u)e^{−iτ_k u} on the grid τ_k = T + 2πk/L; compression
G_kl = W(f_k, f_l); sampling identity (manuscript Lemma 2.2, no aliasing):
Σ_k φ̂(τ−τ_k)φ̂(τ′−τ_k) = L·Φ(τ−τ′), Φ = (φ²)^.

**Single window.** ‖G‖²_F = tr G² pairs zeros through the kernel
g = Φ², i.e. tr Ĝ² = Σ_{ρ,ρ′} m_ρ m_{ρ′} Φ(γ_ρ−γ_ρ′)² (manuscript (5.x),
KAPPA §4(4)). Then:
- g = Φ² ≥ 0 pointwise (a square);
- ĝ = (φ²)⋆(φ²) (autocorrelation of the nonnegative function φ²) ≥ 0
  pointwise;
- supp ĝ ⊆ [−L, L], i.e. [−λ, λ] in Montgomery's α-units.
So the single-window kernel is *doubly positive and band-limited* — and this
holds for **signed** φ too, since only φ² enters.

**Lemma L3.2 (double positivity is stable under the whole test-family
algebra).** Let {φ_i} be finitely many real, even, admissible windows with
supp φ_i ⊆ [−L/2, L/2], let G_i be their same-grid compressions, and let
A = Σ_i c_i G_i with arbitrary **real** coefficients c_i (in particular any
PSD vector-window compression, and any signed linear combination). Then

  tr(A²) = Σ_{ρ,ρ′} m_ρ m_{ρ′} g(γ_ρ − γ_ρ′) with
  g = Σ_{i,j} c_i c_j ( (φ_i φ_j)^ )² and
  **ĝ(u) = L²·∫ z(t,u)² dt ≥ 0**, where z(t,u) = Σ_i c_i φ_i(t)φ_i(t−u),
  and supp ĝ ⊆ [−L, L].

For the frame-admissible subfamily — per-zero blocks PSD, i.e. coefficient
matrix C ⪰ 0 on the window index, which by eigendecomposition C =
Σ_k c_k ψ_kψ_kᵀ (c_k ≥ 0) reduces to positive combinations of
single-effective-window compressions w_k = Σ_i (ψ_k)_i φ_i — additionally
g ≥ 0 pointwise (positive combination of squares c_k c_{k′}((w_kw_{k′})^)²).
For the no-transfer argument only ĝ ≥ 0 and the support bound are needed,
and those hold for **every** real c, admissible or not: even the signed
extension of the frame cannot reach ĝ < 0 anywhere.

*Proof.* Cross-window Poisson (the manuscript's Lemma 2.2 verbatim with
Υ(s) = φ̂_i(τ−s)φ̂_j(τ′−s): H = (φ_i)_τ ∗ (φ_j)_{τ′} has support in
[−L, L], the grid step is 2π/L, so only the m = 0 term survives) gives
Σ_k φ̂_i(τ−τ_k)φ̂_j(τ′−τ_k) = L·(φ_iφ_j)^(τ−τ′) for even real windows.
Hence tr(G_iG_j) = Σ_{ρρ′} m m′ L²((φ_iφ_j)^(γ−γ′))², and summing with
c_i c_j gives the stated g. For ĝ: the Fourier transform of Ψ_{ij}² is the
autocorrelation u ↦ ∫ (φ_iφ_j)(t)·(φ_iφ_j)(t−u) dt, so

  ĝ(u) = L² Σ_{ij} c_i c_j ∫ φ_i(t)φ_j(t)·φ_i(t−u)φ_j(t−u) dt
        = L² ∫ ( Σ_i c_i φ_i(t)φ_i(t−u) ) ( Σ_j c_j φ_j(t)φ_j(t−u) ) dt
        = L² ∫ z(t,u)² dt ≥ 0. ∎

(Exp49 Q7 replicates this identity numerically on random signed windows and
signed coefficients — two independent computations of ĝ agree to the
quadrature tolerance and min ĝ = 0 exactly on all trials.)

**Why the frame cannot escape the lemma.** The inertia bookkeeping
(manuscript Prop 4.1 + Lemma 3.2; KAPPA §4(3),(5)) needs the per-zero block
structure of A: each distinct on-line zero contributes a PSD rank-one block
(so that rank P ≤ N₀* and P ⪰ 0), each off-line pair a signature-(1,1)
block (so that n₊(Q) ≤ #pairs). This survives congruence A ↦ SᵀAS and
positive combinations — but it is destroyed by exactly the two moves that
could leave the doubly-positive cone:

- **Polarization** (cross-compressions between two different windows as the
  matrix itself, S = (G_φψ + G_ψφ)/2): an on-line zero then contributes
  the symmetrized product Re(v^φ v^ψ†), a signature-(1,1) block — the
  on-line zeros become spectrally indistinguishable from off-line pairs,
  and the rank bound on the on-line part is lost. The PSD-per-zero property
  holds iff the coefficient matrix on the window index is PSD, i.e. iff A
  is (a congruence of) a bona-fide compression — and then Lemma L3.2
  applies. [Sanity check on the lemma's scope: for signed diagonal
  combinations Σc_iG_i the per-zero block is Σ_i c_i (v_i v_i†) which can
  be indefinite; those A are excluded from the *bookkeeping* even though
  their tr(A²)-kernel still satisfies ĝ ≥ 0 by the lemma — the realizable
  cone of the full frame is thus strictly inside the doubly-positive cone.]
- **Non-translation-invariant quadratic functionals** tr((GB)²) for a
  general fixed PSD B: these preserve the bookkeeping (congruence) but the
  pair weight (v_ρᵀ B v_ρ′)² is no longer a function of γ_ρ − γ_ρ′; the
  prime side is then not an F-pairing at all, so the CGdL constraint is not
  even formulable there, and each pair still enters with weight ≥ 0 (a
  square) — the sign freedom CGdL need does not appear.

## 4. Theorem L3 (no transfer) and its scope

**Theorem L3 (double-positivity obstruction).** In the two-trace inertia
frame (per-zero block bookkeeping + tr A + tr A² + unconditional prime-side
evaluation at band λ ≤ 1), every realizable second-moment functional pairs
the zero-pair measure with a kernel g satisfying g ≥ 0, ĝ ≥ 0,
supp ĝ ⊆ [−1,1]. Consequently:
(a) the unconditional constraint F ≥ 0 on |α| > 1 (§1.2) is slack at every
    realizable point — adding it changes nothing;
(b) the CGdL feasible set intersected with the realizable cone is the
    band-limited doubly-positive cone {g ≥ 0, ĝ ≥ 0, supp ĝ ⊆ [−1,1]},
    whose optimum equals the Montgomery–Taylor value 1/c₁* = 1.3274992…
    — the MT extremal v = cos(√2·) is > 0 on [−1/2,1/2], so its kernel is
    doubly positive and the restriction costs nothing ([CCLM17, Cor. 14]
    via manuscript §7.1; independently: exp49 Q1 reproduces J(f_MT) =
    1/c₁* to 5.7·10⁻⁹ and min f̂_MT = 0 ≥ 0; Q3−Q2 = 2.4·10⁻⁷);
(c) hence the frame's constant remains 2 − 1/c₁* = 0.6725: **the CGdL gain
    does not transfer**, and Theorem D's limit statement extends by the
    clause "+ F-positivity outside the band".

*Scope and honesty.* (i) The theorem is about the frame as defined — the
manuscript's own scope ("block structure + two traces + primes up to T"),
closed under window families, real linear combinations, and congruence. It
does not exclude a *different* unconditionalization of Montgomery's argument
in which a scalar counting inequality replaces rank bookkeeping; but the
scalar route's unconditional obstacle is precisely the failure of kernel
positivity at complex zero differences (g((γ_ρ−γ_ρ′)·l/2π) is unbounded off
the real axis — the GS25/GS26 obstacle the manuscript quotes in §7.4), which
is what the inertia frame was built to bypass. The two mechanisms are
complementary and their composition is empty: the scalar frame accepts
CGdL's sign freedom but not the unconditional counting; the matrix frame
accepts unconditional counting but not the sign freedom. (ii) CCLM17's
optimality is consumed as quoted by the manuscript (and re-verified
numerically at the discretization level, Q2/Q3); the CCLM17 paper itself was
not re-read this session. (iii) The λ ≤ 1 support bound is the separate,
prime-side wall (Montgomery–Vaughan; DSIDE boundary) — independent of this
obstruction.

## 5. Numerics (claim-anchored, exp49; PROTOCOL §4)

Declared statement S1: the CGdL gain is produced exactly by the sign
freedom f̂ < 0 on |x| > 1 and vanishes on the doubly-positive cone.
Quantities (output `data/exp49_out.txt`, verbatim):

- Q1 J(f_MT) = 1.3274992906 vs 1/c₁* = 1.3274992963 (diff 5.7e−9);
  min f̂_MT = 0.000e0 ≥ 0 (MT extremal is doubly positive).
- Q2 LP band-limited: 1.327497. Q3 LP + f̂ ≥ 0: 1.327497 (Δ = +2.4e−7):
  double positivity is costless inside the band.
- Q4 LP CGdL class: 1.310585 (< Q2 by 0.017; discretized *relaxation* —
  positivity sampled on a grid — so it undershoots CGdL's rigorous 1.3208,
  consistently); outside nodes strictly negative (min −0.0277).
- Q5 control (drop f ≥ 0): unbounded ray (value −29 at the regularization
  box) — the scalar positivity is load-bearing.
- Q6 control (wrong sign outside, f̂ ≥ 0 on |x| > 1): value 0.816 < 1,
  which would give N* ≤ 0.82N, contradicting N* ≥ N — proves too much;
  the ≤ 0 sign carries validity, not the support width. (The exact tent
  witness: f̂(α) = ½(1−|α|/2) on [−2,2] gives J = 5/6.)
- Q7 Lemma L3.2 identity ĝ = L²∫z² on 5 random signed window/coefficient
  draws: two independent computations agree (≤ 2.8e−3, quadrature-limited),
  min ĝ = 0 ≥ 0 in all trials.

Verdict line: S1 CONFIRMED. Anchors that are rigorous rather than
discretized: 4/3 (Fejér, exact), 1/c₁* (closed form, Q1), 1.3208 (CGdL's
own SDP certificate, cited not replayed).

## 6. Yield, corrections to the BEYOND ledger, next lever

1. **L3 is closed** (this note): the constraint is free but carries zero
   marginal information in the frame; the obstruction is named and the
   limit statement extended (Prop L3.3). Any future attempt to beat 0.6725
   unconditionally must first break one of: (i) the per-zero PSD
   bookkeeping (find a rank-type inequality tolerating indefinite on-line
   blocks), (ii) the tr(A²) form (higher/odd traces), or (iii) the λ ≤ 1
   evaluation wall.
2. **Correction to L1's payoff logic.** BEYOND.md L1 forecast "any
   unconditional lower bound on ∫_{1<|α|<1+δ} F would lift the constant
   through the same linear algebra." This has the sign backwards for the
   inertia frame: since realizable weights are ≥ 0 past the band, the
   unknown mass enters the rank inequality with unfavorable sign, and a
   *lower* bound on F helps only the scalar (conditional) frame, where
   negative weights exist (CGdL's GRH refinement uses GGOS's F ≥ 3/2−|x|
   against ĝ ≤ 0 exactly this way). What the inertia frame needs on
   (1, 1+δ] is an unconditional **upper bound or evaluation** of the
   F-pairing — strictly harder, short-interval-primes territory
   (DSIDE §3.4). L1 remains open but its target statement is now sharpened.
3. **L2 gains priority** (secondary forecast confirmed structurally): odd
   traces tr(A³) = Σ m m′ m″ Φ(γ−γ′)Φ(γ′−γ″)Φ(γ″−γ) are triple products,
   not squares — sign-indefinite pair weights (after tracing out one
   variable) live there, so the CGdL-type sign freedom, if the frame can
   consume it at all, enters through the cubic trace. The L2 task order:
   first the three-matrix rank inequality, then the unconditional fragment
   of the triple-correlation prime side at band ≤ 1.
4. Registry: R0017 (kind: obstruction, certificate: mixed). Walk-ledger
   F17. This note is load-bearing only as a *negative* scoping statement;
   its Lemma L3.2 proof is self-contained and short, and the numeric
   confirmations are replayable in ~3 minutes.
