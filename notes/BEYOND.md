# Beyond 0.6725: the method's stated limit and the five levers

Source: the frontier manuscript (Claude, 2026-08-10; local read of the
primary PDF, §§1–7). Its own limit statement, verbatim in substance:
**Theorem D (0.6725, Montgomery–Taylor window) is the limit of "block
structure + two traces + primes up to T" — by CCLM17 Cor. 14 no window
does better given only F(α) on [−1,1].** The mechanism: RH's role in
Montgomery's pair-correlation deduction is replaced by Sylvester
inertia on a finite Gabor compression G of Weil's Hermitian form
(off-line pair {ρ, 1−ρ̄} ⇒ signature (1,1) block ⇒ counts once in n₊),
plus a rank–trace inequality (von Neumann) that is the matrix analogue
of m² ≥ 2m−1; prime side = Montgomery's unconditional band-≤1 second
moment. Constants: on-line ≥ 2/3, simple-on-line ≥ 2/3, distinct ≥ 5/6
(flat window); 0.6725 / 0.6725 / 0.83625 optimized.

Each clause of the limit is a lever. Forecasts registered per protocol.

## L1 — More band: F(α) beyond [−1,1] (prime side)
Montgomery's evaluation is unconditional only for band-limit λ ≤ 1;
everything about F(α) on (1,2) is conjectural (= strong pair
correlation; Goldston–Montgomery equivalences tie it to primes in short
intervals). ~~ANY unconditional lower bound on ∫_{1<|α|<1+δ} F would lift
the constant through the same linear algebra.~~ [CORRECTED by L3_SDP.md
§6.2 (fleet-L3, 2026-08-11): sign backwards for the inertia frame —
realizable weights past the band are ≥ 0 (double-positivity lemma), so a
*lower* bound on F enters the rank inequality unfavorably and pays only
in the scalar conditional frame (CGdL's GRH refinement uses GGOS
F ≥ 3/2−|x| against negative weights ĝ ≤ 0). What lifts the constant
unconditionally is an unconditional **upper bound or evaluation** of the
F-pairing on (1,1+δ] — strictly harder, short-interval-primes territory.] Our corpus: DSIDE.md
measured the F-plateau ≈ 1 on (1,2); LENS_CIRCUIT/BV machinery is the
natural source of partial unconditional information. Forecast: hard —
this is close to known-wall territory (short-interval primes) — but
*partial* progress (a positive lower bound, however small, on the mass
just past 1) may be accessible and pays linearly.

## L2 — More traces: tr(G³) and the cubic integrality step
The method uses tr G and tr G². The integrality ladder m² ≥ 2m−1 →
m² ≥ 3m−2 has a cubic continuation; tr(G³)'s prime side is a triple
sum over prime pairs (triple correlation). Task: determine exactly
which part of the triple-correlation prime side is unconditional at
band ≤ 1 (the manuscript does not use it), and what a three-trace
rank inequality (von Neumann for three matrices is subtle — Finner?
Lieb–Thirring?) yields. Forecast: the linear algebra generalizes; the
open question is whether the unconditional prime-side fragment is
nonempty. Either answer is a theorem-shaped result.

## L3 — More constraints: unconditionalize the SDP layer
On RH, Chirre–Gonçalves–de Laat reached 0.6792 by SDP exploiting
F ≥ 0 outside [−1,1]. F ≥ 0 is unconditional (it is |S(τ)|²-shaped —
check exact statement). If the positivity-outside-band constraint can
be fed into the inertia frame unconditionally, the CGdL gain may
transfer. Forecast: most promising near-term lever — the constraint is
free; the question is purely whether the finite-compression argument
accepts it. First task: re-derive CGdL's use of F-positivity and check
each step against the Gabor compression.

**OUTCOME (2026-08-11, fleet-L3, `notes/L3_SDP.md`, R0016): NO TRANSFER —
lever closed.** The premise verified (F ≥ 0 unconditional, both ordinate
and complex normalizations: CGdL §3 / BGSTB 2501.14545 §2 "MT"), but the
frame cannot consume it: every kernel realizable through tr(A²) — for any
window family and ANY real coefficient combination — has
ĝ(u) = L²∫z(t,u)²dt ≥ 0 (double-positivity obstruction, Lemma L3.2),
while the CGdL gain is produced exactly by ĝ < 0 outside [−1,1] (exp49
mechanism attribution with proves-too-much controls). Intersection of the
two classes = band-limited Fejér cone, optimum = Montgomery–Taylor
1.3274992 (attained in-cone: MT extremal doubly positive). Theorem D's
limit statement extends by "+ F-positivity outside the band". The brief's
"most promising" forecast resolved negative; the sign freedom, if
consumable at all, lives in odd traces (tr A³ = triple products, not
squares) → raises L2's priority; L1's payoff logic corrected above.

## L4 — Marry the two lines: inertia × mollifier
The result does NOT use Levinson's method; κ = 5/12 (PRZZ) stood in a
disjoint technology. The manuscript's zeros are counted through a test
family; Levinson's through mollified moments. A hybrid (mollified Gabor
window; mollifier as a change of the Hermitian form) would be the first
contact between the two centuries-old lines. Forecast: unclear whether
the mollifier's zeros-of-ζ′ mechanism coexists with inertia counting;
even a proven incompatibility would be a structural theorem.

## L5 — Transplant the trick
The inertia-compression argument is generic: any explicit formula with
a Hermitian form + an unconditional second-moment fragment feeds it.
Targets: (a) Dirichlet L q-aspect (proportion on the line in families);
(b) ζ′ zeros / Farmer–Wu distinct-zeros line (the manuscript's 0.83625
already smashes Wu's 0.6603 — what else falls?); (c) our own pair-field
objects: the D″/ENERGY variance forms are second moments of the same
species — does the inertia reading say anything about Goldbach variance
positivity? (d) Selberg class axiomatics: state the minimal axioms the
argument needs (it may be a THEOREM OF THE CLASS, which would be the
right level of generality for the writeup).

## Corpus contacts (why this repo specifically)
The compression G is a Toeplitz/Gabor object with Szegő symbol ϕ² —
our Kreĭn-string/Toeplitz layer; the (1,1) off-line blocks are LP_CERT
H2's pole-plane inertia; the F-plateau is measured in DSIDE; the
claim-anchored-scan discipline their discovery used is now our
PROTOCOL §4. Division of labor: fleet-kappa owns verification
(Lean build + statement alignment) before ANY lever work begins;
Codex invited on L3 (their SDP/exact-computation machinery is the
right tool) and on the L5(d) Selberg-class axiomatization.

Rigor note: this file is a strategic read of the primary PDF, not a
review; nothing here is load-bearing until kappa's verification lands.
