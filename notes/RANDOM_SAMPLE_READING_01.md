# Random sample reading 01: sixteen notes drawn uniformly from `notes/`

**Status:** reading report. No new mathematics. Every claim below is either a
restatement of what a sampled note says, a library grep result, or an
observation about the sample as a set. Where I judge a note to be wrong or
incomplete I say so and give the reason; those judgements are the report's
only original content and they are all elementary.

**Method (stated up front so a later block can repeat it):** the draw was
made by the coordinating agent with `shuf` over `notes/*.md`, uniform, n=16,
and handed to this block as a fixed ordered list. This block did not choose,
substitute, skip, or reorder. `BINARY_DEPTH_TWO_RAYS.md` was drawn **twice**
(positions 6 and 16) — a collision consistent with uniform sampling with
replacement over a population this size — so the sample contains 15 distinct
notes. All 15 exist. The population at read time is **507** `.md` files under
`notes/`, not the 399 stated in the brief; the sampling fraction is therefore
15/507 ≈ 3.0%, and every proportion below carries a binomial standard error
of roughly ±12 percentage points. Nothing here should be read as more precise
than "about a third" / "about half".

---

## 1. `TORUS_CONTROL_PLANE.md` (106 lines)

**(a) Claim.** A public-source audit of the Torus substrate (renlabs-dev,
commit `0466be6`) read as a *control and resource graph*, mapped against this
repository's *proof-carrying epistemic graph*. The composition is asserted to
be strictly directional: evidence may route permissions and budgets;
permissions may never promote a theorem, accept an equivalence, or alter a
proof checker. §3 recommends borrowing the permission algebra (scopes,
parent–child constraints, expiry, revocation, separated owner/manager/
evaluator/executor roles, threshold circuit breakers, recursive budget
delegation) before any token economics. §4 names the gap: prospective
allocation and *retrospective causal credit* are two different accounting
systems, and continuous visible-output reward underprices delayed, negative,
and option value.

**(b) Status per its own header.** "public-source architecture audit, not an
integration commitment." No integration, account, token, or chain dependency
exists. Not a mathematical claim at all.

**(c) Standard object under a coined name?** No coined mathematics. The
mechanisms are named with their upstream names (permission0, linear emission,
root agents). The one thing that *is* a standard object and is not named as
such: §3's typed research signal — residual obligation, allowed assumptions,
artifact/certificate types, replay command, budget, acceptance policy — is a
proof-obligation record, i.e. a goal/context pair with a resource annotation.
No library check applies; there is no theorem here.

**(d) Cross-connections in the draw.** This is the sample's one non-
mathematical note, and its §4 diagnosis ("credit should attach to
content-addressed contributions and recorded downstream reuse rather than to
whole-agent reputation") is *exactly* the problem `KAPPA.md` §5–§8 exhibits
in the wild: a packet (R0015) whose reputation-level claim ("independently
verified") had to be struck out and re-attached to specific artifacts (build
log, axiom output, comparator obligation) by a later audit. TORUS names the
failure mode abstractly; KAPPA is a worked instance of it.

---

## 2. `VERIFIER_BLIND_FIBER_REWARD.md` (146 lines)

**(a) Claim.** Fix nonsingular `M ∈ ℤ^{2×2}` with elementary divisors
`(e₁,e₂)`, level `m = e₂/e₁`. The event set `E(M) = {(U,V) ∈ GL₂(ℤ)² :
UMV = diag(e₁,e₂)}` is a regular `Γ₀(m)`-torsor. **Theorem A:** every
*verifier observable* (any function of `M`, the endpoint `UMV`, and the Smith
invariants) is constant on `E(M)`; hence every outcome reward is constant,
its argmax is the whole fiber, and all policies have equal expected reward.
**Theorem B** grades trace formats by their fiber partition: constant (one
class), `det` (two classes = kernel cosets of `det : Γ₀(m) → {±1}`), Bézout
recording (perfect on the unipotent `ℤ`, blind off it), injective (full, and
replays). Corollary: "what must reward see to train the whole trace" and
"what must a trace store to replay" are one question. §3: a fiber-separating
reward cannot be derived from the task predicate — it must be imported from
an execution ecology (a cost model, a hardware primitive, a live port).

**(b) Status.** "exact classification theorem over landed packets (R0027,
R0032, R0033, R0035), with an interpretation layer kept strictly outside the
proofs." Proved, and the note's own rigor boundary calls the bookkeeping
elementary: "the value is the exact identification, not new depth."

**(c) Standard object under a coined name?** ~~Yes, and mostly declared.
`Γ₀(m)` is standard and named as such — it is
`CongruenceSubgroup.Gamma0` in `~/agda-libs/mathlib4/Mathlib/NumberTheory/
ModularForms/CongruenceSubgroups.lean:79`, with `Gamma0_mem` at :90.~~

> **Correction (seed122, 2026-08-14).** This is the report's one substantive
> error, and it is the failure mode the report itself hunts: the object is
> misnamed, and the misname was then *certified against a library*. The torsor
> group is **not** `Γ₀(m)`. `Γ₀(m)` — and Mathlib's
> `CongruenceSubgroup.Gamma0`, which is defined as a subgroup of `SL(2,ℤ)` —
> consists of determinant-`1` matrices, so `det` is identically `1` on it and
> the report's own §2(a) Theorem B ("`det` (two classes = kernel cosets of
> `det : Γ₀(m) → {±1}`)") would be **false**: one class, not two.
>
> The correct group is `Γ₀^±(m) = {[[a,b],[c,d]] ∈ GL₂(ℤ) : m | c}`, ~~the
> preimage of `Γ₀(m)` in `GL₂(ℤ)`~~ **[seed127, 2026-08-14: `Γ₀^±(m)` is an
> enlargement of `Γ₀(m)`, not a preimage of it — read instead
> `Γ₀^±(m) ∩ SL₂(ℤ) = Γ₀(m)` with index 2, or: `Γ₀^±(m)` is the preimage of
> the upper-triangular subgroup of `GL₂(ℤ/m)` under reduction. The rename and
> everything after it stand.]**, sitting in
> `1 → Γ₀(m) → Γ₀^±(m) --det--> {±1} → 1`. Derivation: with `D = diag(e₁,e₂)`
> and one event `(U₀,V₀)`, all events are `(gU₀, V₀ D⁻¹g⁻¹D)`, and
> `D⁻¹gD = [[a, b·e₂/e₁],[c·e₁/e₂, d]]` is integral iff `m = e₂/e₁` divides
> `c`. `Γ₀^±(m)` contains `diag(1,−1)` (so `det` is onto, and Theorem B(2) is
> restored) and the unipotent `ℤ` (so the fiber is infinite, Theorem A
> unaffected). The source note is corrected in place; see
> `notes/VERIFIER_BLIND_FIBER_REWARD.md`, closing section. Consequently the
> §16.2 tally must move `VERIFIER_BLIND_FIBER_REWARD` out of "flagged, prior
> art named" — it is an **unflagged misnaming**, which is worse than an
> unflagged rediscovery, and it raises the unflagged count from 4/15 to 5/15.

The
underlying structural fact — that the set of Smith normalizations of a fixed
matrix is a torsor under the stabilizer of the diagonal form — is the
standard uniqueness-up-to-unit statement accompanying Smith normal form
(Mathlib: `Mathlib/LinearAlgebra/FreeModule/PID.lean`,
`Mathlib/LinearAlgebra/FreeModule/Int.lean`). "Verifier observable",
"discrimination lattice", "payload chart", "trace format" are coined; the
objects they name are the invariant functions of a group action and the
lattice of `G`-invariant partitions, i.e. the subgroup lattice transported
through the torsor. Theorem B is the orbit–partition correspondence.

**(d) Cross-connections.** Three, and they are the sample's spine.
- **To `ARITHMETIC_LIFE_PIVOT_RESIDUAL_DESCENT.md` (note 4):** that note
  *produces* an element of exactly this fiber. Its worked example earns
  `E = [[3,−1],[−8,3]]` for `T = [[6,16],[0,−70]]`. Theorem A says no
  endpoint verifier can distinguish that `E` from any other; the note's own
  remark that "a fabricated object with zero residue is rejected rather than
  relabeled as progress" is precisely the *imported* cost model that §3 says
  is the only thing that can break the tie. Neither note cites the other.
- **To `LIMIT_ORBIT_COMPARISON.md` (note 13) and `KBOUNDARY.md` (note 11):**
  same theorem shape in three categories — see §16 below.
- **To `PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md` (note 10):** §3's "Pāṇinian
  remark" types a *paribhāṣā* as a declared section of a selection torsor and
  then stops, with an explicit access log for the missing primary text. That
  is the discipline PRAMANA §4 demands; this note satisfies it and the
  pramāṇa-labelled notes elsewhere in the corpus mostly do not.

---

## 3. `RATIONAL_FIBER_SPECTRUM.md` (507 lines)

**(a) Claim.** The finite-place Hardy–Littlewood spectrum must not be
tensored with one universal copy of the zeta-zero spectrum: the archimedean
spectrum is *fibered* over `a/q ∈ ℚ/ℤ`, and the fiber at `a/q` carries the
zeros of the Dirichlet `L`-functions mod `q`. The `q=1` fiber is the zeta
product measure of `PRODUCT.md`. Concretely: an exact rational-mode
decomposition (1.1)–(1.6) of `Λ(n)e_q(an)` into characters plus an explicit
prime-power correction; the residue at `s=1` is `κ_q = μ(q)/φ(q)` (2.1),
whose square is the singular-series amplitude, giving the exact
Bost–Connes/profinite correlation identity (2.2) converging to `𝔖(h)` (2.3);
a twisted compensated explicit formula (3.2)–(3.3d) that closes the finite
`A_χ` normalization including all conductor, gamma, trivial-zero and deleted-
Euler-factor terms; and §4's "one fiber, two pair projections", whose punch
line is that at `q=1` under RH the bare product measure does **not** remember
whether it came from the Goldbach-sum or gap-difference construction — the
distinction lives in the holomorphic-vs-Hermitian grading, not in the
unlabelled positive measure, and positivity must not be imported from `q=1`
to general fibers where the Gauss-sum coefficients make `ν_{a,q}` complex.

**(b) Status.** "an exact synthesis of classical character theory ... No
component is claimed as new." §5 is a prior-art boundary naming
Hardy–Littlewood, Davenport/Granville, Gadiyar–Padma, Helfgott,
Bhowmik–Halupczok–Matsumoto–Suzuki, Rubinstein–Sarnak, and Connes–Consani,
and concludes "Novelty is **not established**." §6 flags that experiments on
truncated Dirichlet-zero spectra remain discovery computations until a stated
truncation scheme with certified zero enclosures and a rigorous uniform tail
bound exists. Proved-but-classical, with an open certification obligation.

**(c) Standard object under a coined name?** The vocabulary is standard
throughout (Gauss sums, `κ_q`, singular series, Davenport's explicit formula).
"Rational fiber", "pole–pole layer", "min-kernel measure" are coined framings
over classical objects and the note says so. One naming hazard worth
recording: **this note's `κ_q = μ(q)/φ(q)` and `KAPPA.md`'s `κ` (the
critical-line proportion) are different objects sharing a letter**, and both
were drawn in this sample.

**(d) Cross-connections.** Cites Connes–Consani arXiv:2006.13771 Appendix C
Proposition C.1 in §5 as prior art for finite restricted test spaces as RH
detectors. `WEIL_INDEX_ONE.md` (note 15) uses *the same Proposition C.1* as
its Lemma 2.1 — its only analytic input. Also directly adjacent to
`ADELIC_CRYSTAL.md` (note 8): both organize `ℚ` by places/fibers, both
conclude that the archimedean side is the one carrying the transcendence and
the analytic-continuation debt.

---

## 4. `ARITHMETIC_LIFE_PIVOT_RESIDUAL_DESCENT.md` (50 lines)

**(a) Claim.** Given `T = LA = [[g,h],[0,k]]` with `g,h > 0` and
`h ≢ 0 (mod g)`, the positive Euclidean reducer earns unimodular `E` with
`E(g,h)ᵗ = (d,0)ᵗ`, `d = gcd(g,h)`; transposing gives the column operation
`TEᵗ = [[d,0],[*,*]]`, and non-divisibility forces `0 < d < g`. So the
residual branch has certified **strict pivot descent** — stronger than
invertibility, narrower than a Smith termination theorem.

**(b) Status.** No status header. A four-line proof plus a worked example
plus a rigor boundary: "proves strict decrease for this column phase only.
Alternating such phases still needs a global well-founded measure; (4) is
checked computation illustrating the proved operation, not evidence of
generic termination." Proved, narrow, honest.

**(c) Standard object under a coined name?** Yes, unflagged. This is one step
of the classical Smith-normal-form termination argument — the descent of the
`(1,1)` pivot under alternating row/column Euclidean reduction, which is how
every textbook proof of SNF over a PID terminates. Mathlib carries the
finished theorem (`Mathlib/LinearAlgebra/FreeModule/PID.lean`,
`Mathlib/LinearAlgebra/FreeModule/Int.lean`); the note proves a strictly
weaker single-phase statement and correctly declines to claim the global one.
"PivotDivisibilityResidual" is a repository-coined constructor name.

**(d) Cross-connections.** Direct and unrecorded: it manufactures a point of
the `Γ₀(m)`-torsor whose unrewardability is note 2's Theorem A. See §2(d).

---

## 5. `KAPPA.md` (407 lines)

**(a) Claim.** A source-checked dossier on the 2026-08-10 Anthropic
manuscript proving unconditionally that `liminf N₀*(T,2T)/N(T,2T) ≥ 2/3`
(same for simple-and-on-line; `≥ 5/6` distinct; with the Montgomery–Taylor
window 0.67250/0.67250/0.83625), superseding the PRZZ 2020 record
`κ > 0.417293`. §4 reconstructs the machine: Weil's Hermitian form compressed
to a critical-density Gabor system, split `G = A + E`, each off-line pair
contributing a signature-(1,1) hyperbolic block and each on-line zero a
rank-one PSD block, two unconditional traces (`tr Ĝ` and `‖Ĝ‖²_F`, the second
being Montgomery's `F(α)` on `|α| ≤ 1` made unconditional by
Montgomery–Vaughan), and a von Neumann rank–trace inequality as the matrix
transplant of `m² ≥ 2m−1`. §6 argues this corpus held both ingredients
(`WEIL.md`/`LP_CERT.md` for the inertia; `DSIDE.md` for the `F(α)` boundary)
and lacked exactly two things: the *compression*, and the *dual reading* —
rank plus positive index rather than a negativity certificate. §7 states the
frontier: the `λ ≤ 1` band-width wall is the Hardy–Littlewood additive-
correlation wall; the certificate ceiling at bandwidth 1 is 0.68185, so the
shape axis is quantifiably saturated; RH is out of reach of the mechanism.

**(b) Status.** The header itself is a correction artifact: "the 2026-08-10
jump to 2/3, ~~verified~~ **under audit**". §5's original verdict is struck
through in place. Corrected verdict: the archived run supports a successful
default and `Solution*` build and clean axiom output for 44 printed
declarations (42 report exactly `[propext, Classical.choice, Quot.sound]`, two
report strictly less), but it does **not** establish the trusted/untrusted
statement-equality boundary, the log is a curated summary rather than a raw
build record, and R0015's promotion is explicitly blocked pending a raw
manifest-bound build plus an end-to-end comparator replay. The `sorry` count
was corrected upward from 27 in two files to 33 in three. Pending, downgraded
by its own audit.

**(c) Standard object under a coined name?** No coining; this note is
scrupulous about names (Levinson, Conrey, PRZZ, Montgomery–Taylor,
Cheer–Goldston, Bui–Heath-Brown, Chirre–Gonçalves–de Laat, Farmer, Wu,
Rudnick–Sarnak, CCLM17). Sylvester inertia, von Neumann's trace inequality
and Pimsner-free linear algebra all appear under their real names.

**(d) Cross-connections.** The sharpest one in the sample, and it is a
**correction to KAPPA**: §6.3(b) says the corpus lacked "the *dual reading*,
rank + positive index against two unconditional traces — our LP2 sought a
negativity certificate (Bombieri's reading)." But `WEIL_INDEX_ONE.md` (note
15), committed the **same day**, proves RH ⟺ `n₊(I|_V) ≤ 1` for every
finite-dimensional `V`, with the converse direction supplying exactly *two*
positive squares per off-line quartet, i.e. **one positive square per
off-line `J`-pair** — which is verbatim the structure KAPPA §4(3) attributes
to the manuscript's Proposition 4.1. `KAPPA.md` does not cite
`WEIL_INDEX_ONE.md` anywhere (`grep` confirms), and no note cites both. So
KAPPA's proof-diff is overstated by half an ingredient: the corpus had the
positive-index reading, in a note KAPPA's author appears not to have seen.
What the corpus genuinely lacked is the *second trace* and the rank–trace
inequality that couples it to the index — not the dual reading itself.
Secondary: KAPPA is the only note in the sample that engages a Lean
development, and it does so on an *external* repository, not `formal/`.

---

## 6 & 16. `BINARY_DEPTH_TWO_RAYS.md` (92 lines) — drawn twice

**(a) Claim.** For a nonnegative measure `(x₀,x₁,x₂,x₃)` on `ℤ/4ℤ`,
"alignment" means `x₀ ≥ x₂`, `x₁ ≥ x₃`, `x₀+x₂ ≥ x₁+x₃`. In difference
coordinates `a = x₂, b = x₀−x₂, c = x₃, d = x₁−x₃` the cone becomes
`a,b,c,d ≥ 0` with `2a+b ≥ 2c+d`. **Theorem:** the extreme rays are exactly
six, listed in both coordinate systems. Consequence: the two mixed rays
`(1,2,1,0)` and `(2,1,0,1)` are *not* nonnegative combinations of successor
intervals and their dilations, so those operations do not generate the
aligned cone even at binary depth two; the interval `{0,1,2}` is aligned but
not extreme.

**(b) Status.** No header. Theorem with proof; rigor boundary: "a complete
symbolic classification only for `p=2,k=2`. It neither classifies
higher-depth rays nor proves that the two mixed rays require a new primitive
operation."

**(c) Standard object under a coined name?** Yes, unflagged. This is the
extreme-ray enumeration of a polyhedral cone given by the nonnegative orthant
intersected with one halfspace — the double-description / Minkowski–Weyl
setting. Mathlib has the general vocabulary
(`Mathlib/Analysis/Convex/Extreme.lean`, `Exposed.lean`, `KreinMilman.lean`);
"aligned cone `A_(2,2)`" and "extreme scheduler-aligned law" are coined. The
proof given is the correct general argument for this shape (axes on the
strict side; one positive-side and one negative-side coordinate in balancing
ratio on the boundary hyperplane), and I checked the six rays and the
coordinate change by hand: all six satisfy the constraints, the map
`(a,b,c,d) ↦ (a+b, c+d, a, c)` reproduces every listed `x`, and the axis test
correctly excludes the `c`- and `d`-axes. The theorem is right.

**(d) Cross-connections and one defect.** *Defect:* the LaTeX is broken in
this file — `qquad` appears without its backslash ~~five times (lines 6, 12,
24, 39-region, 72)~~ **three times, on lines 6, 24 and 71 (seed122,
2026-08-14: `grep -n qquad` gives exactly those three; `grep -c '\qquad'`
gives 0, so no occurrence is correctly escaped)**, and the display opened at line 23 is never closed before
the `## Exact ray classification` heading, so equation (4) and the theorem
table will not render. This is cosmetic but it is the only rendering-level
breakage in the sample and it survived in a note important enough to be drawn
twice. *Connection:* the "successor interval / dilation" generators are the
same formation-operation vocabulary as the arithmetic-life lane (notes 4, 7,
12, 14); this is that lane's cone-theoretic face.

---

## 7. `PRIME_POWER_RESIDUE_VALUATION_BRIDGE.md` (70 lines)

**(a) Claim.** For `r = n mod p^k`, define `τ_k(n) = max{0 ≤ j ≤ k : p^j | r}`.
Then `τ_k(n) = min(v_p(n), k)`; for `j = τ_k(n) < k` there is a unique unit
`u ∈ (ℤ/p^{k−j})^×` with `r = p^j u`; hence the stratification
`ℤ/p^k ≅ {(k,*)} ⊔ ⨿_{j<k} {j} × (ℤ/p^{k−j})^×`. Induced laws:
`τ_k(ab) = min(τ_k(a)+τ_k(b), k)` (saturated additive composition) and
`τ_k(a+b) ≥ min(τ_k(a),τ_k(b))` with equality when the depths differ (finite
ultrametric law). Exact boundary: neither representation subsumes the other —
residues give finite-depth valuation plus a unit, valuation gives depth at
all scales but discards the unit.

**(b) Status.** No header. Proved (three lines, correct).

**(c) Standard object under a coined name?** Yes, unflagged. The
decomposition (3) is the standard valuation stratification of `ℤ/p^k`, i.e.
the associated graded of the `p`-adic filtration on `ℤ_p` truncated at depth
`k`; `τ_k = min(v_p, ·, k)` is the truncated valuation, and (4)–(5) are the
saturating truncation of the standard valuation axioms `v(ab) = v(a)+v(b)`,
`v(a+b) ≥ min` with equality off the diagonal. All of this is textbook local
algebra. "Finite-depth valuation chart", "residue sensor", "valuation
coordinates" are coined.

**(d) Cross-connections.** This is the *general* statement of which
`CYCLOTOMIC_SENSOR.md` (note 12) is the sharp special case: PRIME_POWER says
depth `k` of the chart determines `min(v_p, k)` and no more; CYCLOTOMIC
SENSOR exhibits a family (`a^n − 1`) on which a *fixed* finite chart depth
determines unbounded valuations, because the family is not closed under the
`b ↦ b + p^k` perturbation that makes PRIME_POWER's boundary sharp. Read
together, note 7 states the generic obstruction and note 12 states its exact
repair — and note 14 prices it. Neither cites the other.

---

## 8. `ADELIC_CRYSTAL.md` (774 lines — the sample's longest)

**(a) Claim.** Take the two involutions `𝓕` (Fourier duality at a place `v`)
and `J : f ↦ |x|⁻¹f(1/x)` acting on the *same* space `𝒮(k_v)`. Both
composites `J𝓕` and `𝓕J` are diagonal in the quasicharacter decomposition
with multipliers `γ_v(χ,s)` and `γ_v(χ⁻¹,1−s)` respectively; their ratio is
the square's holonomy, and `γ_v(χ,s)γ_v(χ⁻¹,1−s) = χ(−1)` *is* the statement
`𝓕² = σ`. The holonomy is nontrivial at **every** place (`⟨D,E⟩ ≅ D_∞` on
the even sector), and the global holonomy is exactly 1: `∏_v γ_v(χ,s) = 1`,
equivalently the completed functional equation. §4 then shows
Freund–Witten's adelic string amplitude identity is *literally* this theorem
evaluated at three Mandelstam variables with `a+b+c=1`. §5 is a control
ledger: C0 proves by a multiset argument that the adelic product converges
*nowhere* (`{a,b,c}` and `{1−a,1−b,1−c}` sum to 1 and 2, so they can never
coincide); C1 shows a wrong additive normalization is `o(1)` at each place
and log-divergent globally (tracking `e^γ log P` to four digits); C3 rejects
a planted `(1+p^{-2})` gamma factor both locally and globally. §6 kills the
"archimedean = GR, finite = QM" reading as mythology and keeps only the
narrow computed residue: `Γ` is where the continuum's extra structure lives.

**(b) Status.** "**PENDING HOSTILE AUDIT**", stated twice (header and last
line). §7 is a blunt classical/new split: everything in §§2–5 is Tate,
Gel'fand–Graev, Volovich, Freund–Olson, Freund–Witten; what is offered as
possibly-new-and-probably-folklore is four framings (the holonomy reading,
the `D_∞` presentation, the empty-core lemma, the multiset non-convergence
argument). "the framing is new to this repository; the mathematics is not new
to mathematics."

**(c) Standard object under a coined name?** Yes — and this note is the
sample's model of how to do it. "Adelic duality crystal" and "holonomy" are
coined names for Tate's local gamma factor and the local functional equation,
and §7 says so in a titled section. The reference list distinguishes FETCHED
(with URLs) from UNVERIFIED-MEMORY, and records a *removed* wrong remark (the
claimed RH-equivalence of partial Euler product convergence) rather than
deleting it. `~/agda-libs` has nothing for Tate's thesis; mathlib4 has no
local zeta integrals or `γ`-factors, so no library collision exists.

**(d) Cross-connections.** (i) With `RATIONAL_FIBER_SPECTRUM.md` (note 3):
same place-decomposition of `ℚ`, same conclusion that the archimedean factor
is the one requiring continuation. (ii) With `WEIL_INDEX_ONE.md` (note 15):
§9 residual 1 asks "is there a two-variable crystal whose global holonomy is
a nontrivial finite object rather than 1? That is where a Weil-positivity-
style obstruction would have to appear, since positivity is not visible to a
single `γ_v`" — note 15 is the corpus's Weil-positivity index statement and
is not cited. (iii) **The correction gap:** §10's "Pramāṇa labels" apply
exactly the collapsed translation *pratyakṣa = numerical output, anumāna =
proof, śabda = citation* that `PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md` (note 10)
withdraws. ADELIC_CRYSTAL is dated 2026-08-12 and PRAMANA 2026-08-13, so this
is not a violation — it is an **un-propagated correction**, and see §16 for
how far it reaches.

---

## 9. `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` (148 lines)

**(a) Claim.** The repository's phrase "object-alignment witness" smuggles in
a positive conceptual object. Dignāga (*Pramāṇasamuccaya(vṛtti)* V.2–11)
rejects all four positive candidates for a word's referent — individual,
genus, their relation, and genus-bearer — concluding that an expression
effects *exclusion of others* (`anyāpoha`); V.25cd–38 shows the exclusion is
scope-sensitive (synonyms, sub/superordinate terms, coordinate terms behave
differently), so apoha is *not* an untyped Boolean complement. Dharmakīrti
(*Pramāṇavārttika* I.115–121, III.165–173) gives a causal route — different
particulars producing one cognition, seen as one real thing *through error* —
which does not restore the universal. Therefore requiring a positive real
universal begs the apoha dispute, and no common formal object joining Nyāya,
Dignāga, Dharmakīrti, and the repository's response-square theorem has been
established.

**(b) Status.** "source-critical comparison and correction of this note's own
terminology." §4 strikes out its own earlier proposal (`ProbeWarrant(q)` as a
sum type with `PositivePresentation` and `ExclusionAlignment` constructors)
as "repository-coined names, not established mathematical objects and not
native Sanskrit categories ... it prematurely asserted a common carrier
precisely where the sources leave a dispute." A **withdrawal note**.

**(c) Standard object under a coined name?** The point of the note is the
converse: a coined name (`ProbeWarrant`, "object alignment") that named *no*
object at all, standard or otherwise, and has been withdrawn. §6 grades
provenance honestly — the Dignāga Sanskrit is a Steinkellner/Pind
reconstruction from citations and Tibetan witnesses, "not equivalent to
reading an intact Sanskrit manuscript."

**(d) Cross-connections.** Explicit successor to note 10; together they are
the sample's one two-note chain where the later note corrects the earlier.
The pair also constrains note 2's Pāṇinian remark and note 8's pramāṇa
labels.

---

## 10. `PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md` (127 lines)

**(a) Claim.** The repository's translation `pratyakṣa = numerical output;
anumāna = proof; śabda = citation, weakest` (from
`collab/messages/0073-weaver-prasanga-norms.md`) is too coarse in all three
components, and the scalar ranking is unsupported. From Annambhaṭṭa's
*Tarkasaṅgraha* §§35–47, 57–63: a pramāṇa is typed by the *cognition-
producing causal route* (`karaṇa` = the `asādhāraṇa` cause), not by a
confidence badge attached after an artifact exists. A script's printed
numeral is not `pratyakṣa` merely by being visible — the warrant still runs
through program semantics, inputs, execution and interpretation. `śabda` is
`āptavākya` with `ākāṅkṣā`/`yogyatā`/`sannidhi` conditions, so unchecked
memory of a citation is not a weak instance of valid `śabda`; it is not
`śabda`. §57 gives a *typed defeat* relation, not a global ranking.

**(b) Status.** "primary-text correction of a repository translation." §5 is
a correction ledger: keep `PROVED/MEASURED/CITED/OPEN` as modern grades;
**withdraw** their identity with `anumāna/pratyakṣa/śabda`; **withdraw**
"śabda is weakest". A withdrawal note.

**(c) Standard object under a coined name?** Inverse again: it removes a
claimed identity between two vocabularies. It also correctly separates the
repository's proved response square `r'_{τ(q)}(x') = r_q(s(x'))`
(`ACTIVE_OBSERVER_DESIGN.md` eq. (5)) from the unproved probe-warrant
question: "formation/warrant asks why the probe is admissible; the commuting
square asks what its revision preserves." That square is a naturality
condition; the note does not overclaim it.

**(d) Cross-connections.** See §16 — this is the note whose correction has
the widest unrealized reach in the sample and the corpus.

---

## 11. `KBOUNDARY.md` (584 lines)

**(a) Claim.** Is sieve parity a K-theoretic boundary class of the affine
Toeplitz extension `0 → I → 𝒯 → Q_ℕ → 0` (Laca–Raeburn Toeplitz algebra over
Cuntz's `Q_ℕ`)? **Answer: no, for every invariant factoring through the
homotopy/KK class of the twist.** Ingredients: `𝒯 ∩ 𝒦 = 0` (Lemma 1.1, via
Echterhoff–Laca's power-cofinite `Prim 𝒯 ≅ 2^𝒫` failing `T₁`) so there is no
classical Fredholm index; `K_*(𝒯) = (ℤ[1], 0)` by Cuntz–Echterhoff–Li plus a
simply-transitive orbit analysis, so `𝒯` is a K-theoretic point and `∂` is
*faithful* — `∂ : K_0(Q_ℕ) ≅ K_1(I)` and injective on `K_1(Q_ℕ)`; yet the
Liouville gauge automorphism `α_λ` is outer (Lemma 4.1, via the Cartan masa
and the fixed point `0 ∈ ℤ^`) while lying on the *connected* gauge torus
`𝕋^𝒫`, so `(α_λ)_* = id` and `[α_λ] = [id]` in `KK`. The twist dies
**upstream**, before any boundary map can act. §5 untwists the order-2
crossed product to the parity core (Prop 5.1 graded untwisting, validated on
a `C(𝕋)` toy) and computes its K-theory *modulo* one inherited stage lemma.

**(b) Status.** Header verdict "(ii) proven vanishing/no-go, with one
isolated residue of type (iii)". Heavily amended: four separate
strike-throughs record a Codex audit of 2026-08-12 narrowing the original
claims — the "Fredholm-compatible completion" clause was undefined and proved
too much; "every difference-type invariant vanishes identically" was too
broad; the §5.2 K-group promotion is **downgraded to "formalizing"**, not a
theorem, pending stage-triviality for the basis `{4, 2p}`; and §4.4's
reflection control was factually corrected — Cuntz's final theorem gives
`K_*(Q_ℤ) = ℤ^{(∞)}` in both degrees, the *same* abstract groups as `Q_ℕ`, so
reflection is action/core-visible, not bare-K-group-visible. Proved core with
two precisely delimited open residues.

**(c) Standard object under a coined name?** No coining — every object is
named with its literature name (Laca–Raeburn, Cuntz `Q_ℕ`, Bunce–Deddens,
Pimsner–Voiculescu, Busby invariant, Green–Julg, Kishimoto, de la
Harpe–Skandalis determinant) and every source is cited by arXiv number with
theorem locations. None of this is in the local Agda/Lean libraries (mathlib4
has no operator-algebraic K-theory); no collision to check.

**(d) Cross-connections.** §4.3's slogan — "the observable functor is a
twirl: over the gauge group in F, over homotopy in K, and `λ` is in the
twirl's kernel both times" — is the sample's clearest statement of the shape
shared with notes 2 and 13. See §16.

---

## 12. `CYCLOTOMIC_SENSOR.md` (441 lines)

**(a) Claim.** The prime-exponent chart makes multiplication local and
addition non-local, and `ADAPTIVE_VALUATION_ADDITION` sharpens this to "the
price of an answer is the answer": determining `v_p(a+b) = v` needs the chart
`mod p^{v+1}`. That coupling is a property of the *generic pair*, not a law of
the joint. On the family `ℱ_{p,a} = {a^n − 1}` a two-integer state — the
*cyclotomic sensor* `(d,e)` with `d = ord_p(a)`, `e = v_p(a^d−1)` for odd `p`,
or `(e₋,e₊) = (v₂(a−1), v₂(a+1))` for `p=2` — answers the whole family
(Theorem 1). Theorem 2: the least base chart is `K = e+1` (odd) or `e₋+e₊`
(`p=2`), with explicit counterexample bases. Theorem 3 (chain law): `v_p(Φ_m(a))`
is supported on the chain `{dp^s}`, equal to the head entries then constantly
1 — which dissolves both the `d | n` indicator (it is the chain's support) and
the `p=2` exception (its head is two entries, not one). Theorem 4: the head
length is `⌊1/(p−1)⌋ + 1`, the least `k₀` with `U_{k₀} = 1+p^{k₀}ℤ_p`
torsion-free — so "LTE has a weird case at `p=2`" and "`−1` is a `p`-th root
of unity in `ℚ_p` exactly when `p=2`" are the same sentence.

**(b) Status.** Theorems 1–4 proved; a fifth statement **refuted in place**.
The local-field generalization `|H| = ⌊e_K/(p−1)⌋ + 1` is struck through and
replaced by a recorded refutation (`claude_arithmetic_breaker`, 2026-08-12,
`RAMIFIED_HEAD_LENGTH.md`): smallest counterexample `K = ℚ₃(3^{1/4})`,
`e_K = 4`, predicted 3, actual 2; at `e_K = 16`, predicted 9, actual 3. The
true law is logarithmic in `e_K`, not linear, and `a`-dependent. The note
explains its own error (below the torsion threshold the shift law multiplies
depth by `p` rather than adding `e_K`) and confines the damage (invisible over
`ℚ_p`, so Theorems 1–3 are unaffected).

**(c) Standard object under a coined name?** Yes — and declared, with a prior-
art section. Theorem 1 *is* the lifting-the-exponent lemma plus its order
corollary; the note says so and cites Wikipedia, Parvardi, and an Isabelle AFP
formalization. **It does not cite Mathlib, which has both branches:**
`~/agda-libs/mathlib4/Mathlib/NumberTheory/Multiplicity.lean` —
`Int.emultiplicity_pow_sub_pow` (:190) and `Nat.emultiplicity_pow_sub_pow`
(:216) for odd `p`, and `Int.two_pow_sub_pow` (:300), `Nat.two_pow_sub_pow`
(:326), `pow_two_sub_one` (:358) for the `p=2` exceptional form, with the
module docstring at :20 naming "the lifting the exponent lemma for odd
primes". Theorem 3 is the standard cyclotomic-valuation formula (the note
says: "the engine of Bang's and Zsigmondy's theorems"); Theorem 4's threshold
(`U_k` torsion-free iff `k > e/(p−1)`) is cited as standard local field
theory. "Cyclotomic sensor", "chain", "head" are coined names over classical
objects, flagged as such throughout.

**(d) Cross-connections.** With note 7 (the general truncation obstruction it
repairs) and note 14 (the cost of learning the digits) — see §16.

---

## 13. `LIMIT_ORBIT_COMPARISON.md` (109 lines)

**(a) Claim.** For a group `G` acting on every set of a finite diagram `X`
with equivariant restriction maps, there is a canonical comparison
`c : (lim X)/G → lim(X/G)`. It need not be injective or surjective, and the
failures are different: injectivity is **global alignment of local phases**
(two compatible families related by possibly-different `g_i` at each object
must be related by one global `g`); surjectivity is **existence of compatible
representatives**. Two minimal failures with `C₂` acting regularly on `{0,1}`:
the span `X → * ← Y` has two diagonal orbits mapping to one point (so `c` is
not injective, and connectedness of the index category is *not* enough); the
equalizer of `id, flip : C₂ → C₂` is empty but its quotient equalizer is a
singleton (so `c` is not surjective — a finite one-loop descent obstruction).
Two sufficient conditions: connected underlying graph plus free actions gives
injectivity; a rooted outward tree gives surjectivity.

**(b) Status.** No header. Proved, elementary, with correct counterexamples
and correct sufficient conditions, and it says the sufficient conditions are
"sufficient, not necessary. The exact criteria above are the boundary."

**(c) Standard object under a coined name? — YES, and this is the sample's
one clean unflagged rediscovery.** The orbit set `S/G` is the colimit of `S`
over the one-object groupoid `BG`; so `c : (lim_J X)/G → lim_J (X/G)` is
precisely the **colimit–limit interchange map** for a functor
`F : J × BG → Set`. Mathlib has it by name:
`~/agda-libs/mathlib4/Mathlib/CategoryTheory/Limits/ColimitLimit.lean:58`,
`noncomputable def colimitLimitToLimitColimit`, whose docstring reads "The
universal morphism `colim_k lim_j F(j,k) → lim_j colim_k F(j,k)`" and whose
module header says "While it is not usually an isomorphism, with additional
hypotheses on `J` and `K` it may be, in which case we say that 'colimits
commute with limits'", citing Borceux §2.13 and Stacks tag 002W. The
prototypical positive result (filtered colimits commute with finite limits)
is `CategoryTheory.Limits.FilteredColimitCommutesFiniteLimit` — and it is
exactly what fails here, since `BG` is not filtered for a nontrivial `G`.
The note's "global alignment of local phases" is the standard nonabelian
`H¹`/descent phrasing of the same defect. **The word "colimit" appears in
only two notes in the entire corpus (`VOEVODSKY_TERMINAL_PROGRAM.md`,
`TOY_OBSTRUCTION.md`) and in neither of the two notes that cite
LIMIT_ORBIT_COMPARISON**, so the identification is genuinely absent from the
repository, not merely absent from this file.

**(d) Cross-connections.** See §16. Its own §"Relation to the preceding
descent theorem" correctly distinguishes itself from `HOLONOMY_DESCENT.md`
(one consumer, coequalizer) — the distinction is exactly colimit-side versus
limit-side.

---

## 14. `OUTPUT_SENSITIVE_CLEAN_COST.md` (73 lines)

**(a) Claim.** For an unknown residue `r = Σ d_ℓ p^ℓ` learned by an
early-stopping protocol that tests digits `0,…,p−2` in order and infers `p−1`
by elimination, with `q(d) = d+1` for `d ≤ p−2` and `q(p−1) = p−1`: the
realized costs are `Q(r) = Σ q(d_ℓ)` forward valuation queries,
`O(r) = 2Q(r)` clean oracle invocations, and
`S(r) = Σ(q(d_ℓ)−1) + #{ℓ < k−1 : d_ℓ = p−1}` new center-forming subtractions.
Cost is therefore not a static annotation on a semantic center: it factors
through the entire learned output, because the output records which cache
transitions occurred.

**(b) Status.** No header. Theorem with proof; rigor boundary declares the
assumptions (declared digit order, canonical positive centers, clean
per-query uncomputation, persistent rolling center) and disclaims average-case
distribution, alternate child order, reversible gate cost, and global Pareto
optimality.

**(c) Standard object under a coined name?** Partly. `Q` and `S` are
digitwise-additive functionals of the base-`p` expansion — the standard
"digit-sum against a weight function" shape — with a boundary correction. No
library object matches this specific protocol. I checked the two extremes
by hand and they are internally consistent: at `r = p^k − 1`,
`Q = k(p−1)`, `S = k(p−2) + (k−1) = k(p−1) − 1` as claimed; at `r = 0`,
`Q = k`, `S = 0`. "Clean rolling cost", "center-forming subtraction",
"CACHE_RELATIVE_FORMATION_COST" are coined.

**(d) Cross-connections.** The economics of note 7's chart and note 12's
sensor: PRIME_POWER says how deep a chart must be, CYCLOTOMIC_SENSOR says
when a fixed depth suffices forever, OUTPUT_SENSITIVE says what it costs to
read the digits out. Three notes, one lane, no mutual citation.

---

## 15. `WEIL_INDEX_ONE.md` (169 lines)

**(a) Claim.** With `Φ_g(s) = ∫ g(u)e^{(s−1/2)u}du`, `J(s) = 1−s̄`, the
polarized Weil form `W(g,h) = Σ_ρ Φ_h(ρ)·conj(Φ_g(Jρ))`, `P = {g : Φ_g(0) =
Φ_g(1) = 0}` and `I = pole − W`: **RH ⟺ for every finite-dimensional complex
`V ⊂ C_c^∞(ℝ)`, `n₊(I|_V) ≤ 1`.** Forward: RH gives `W ≥ 0`, so
`I ≤ pole`, and the pole form is a pullback of `2Re(x ȳ)`, positive index one.
Converse: an off-line zero produces a `J`-stable quartet `{ρ, Jρ, ρ̄, Jρ̄}` of
equal multiplicity `m`; the Connes–Consani/Yoshida interpolation lemma
(Appendix C, Prop C.1) supplies `g₁,g₂ ∈ P` with values `(1,−1,0,0)` and
`(0,0,1,−1)` and summable tails, making the restricted matrix
`−2m·Id₂ + o(1)`, so `I|_V` is positive definite of index 2. "A single
off-line quartet is not one indefinite defect: over complex test functions it
contains two independent `J`-pairs, one at each sign of the ordinate."

**(b) Status.** Theorem 3.1 proved; §4 calibrates novelty carefully
("Targeted searches did not locate the exact index-one formulation ... but it
should be described as a short corollary/synthesis of this prior machinery —
not as a new route around the analytic difficulty of RH"); §5 records that a
**blind reconstruction** verified the quartet, multiplicity, polarization and
factor `2m`, and bounded the interpolation error in `ℓ²(Z,m)`. Proved,
blind-audited, novelty "searched-not-found".

**(c) Standard object under a coined name?** No coining. Weil's criterion,
Bombieri's 2000 Theorem 8 (negative eigenvalue count = number of off-line
conjugate pairs), Connes–Consani's tail localizer, Yoshida's interpolation,
and Suzuki's 2023 screw-function criteria are all cited by name and role.
Nothing in `~/agda-libs` touches the Weil explicit formula.

**(d) Cross-connections.** The sample's headline: it holds the positive-index
reading that `KAPPA.md` §6.3(b) says the corpus lacked, and KAPPA does not
cite it. See §5(d) and §16.

---

## 16. What the sample says about the corpus

Fifteen distinct notes, ~3% of `notes/`. Binomial error on any proportion
below is about ±12 points; treat every number as "roughly".

### 16.1 Proved vs pending

| bucket | count | notes |
|---|---|---|
| proof written in the note, standing | 9 | 2, 3, 4, 6/16, 7, 12, 13, 14, 15 |
| proved core, amended downward by a later audit, with delimited open residues | 1 | 11 |
| pending audit / verdict withdrawn | 2 | 5 (KAPPA, `~~verified~~`), 8 (ADELIC_CRYSTAL, "PENDING HOSTILE AUDIT") |
| withdrawal / correction of a prior repository claim | 2 | 9, 10 |
| not mathematics (architecture audit) | 1 | 1 |

So: **about 60% carry a standing proof, about 13% are explicitly pending, and
about 13% exist only to retract something.** The retraction notes are not
overhead — they are the sample's most decisive documents.

The more striking statistic is **in-place correction**. Six of fifteen (5, 8,
9, 11, 12, and 10's ledger) contain struck-through text where the note's own
earlier claim is preserved, crossed out, and replaced with the corrected
version plus the auditor's name and date. Nothing in the sample was silently
edited. Two of these (KAPPA §5, KBOUNDARY §§2–5) are *external* audits by a
second agent lineage (Codex), and one (CYCLOTOMIC_SENSOR's local-field
prediction) is a flat refutation with a smallest counterexample. That is a
higher functioning error-correction rate than the corpus's own `CLAUDE.md`
preamble implies, and it is invisible if you read only the notes a
coordinator recommends — recommendations select for notes that are still
standing.

### 16.2 Standard objects under coined names

Roughly **8 of 15** name a standard object. The useful split is not
"how many" but "how many say so":

- **Flagged, with a prior-art section:** 3 (classical synthesis, novelty "not
  established"), 8 (§7 classical-vs-new, blunt), 12 (LTE, Bang/Zsigmondy,
  unit-filtration torsion — all cited), 15 (Bombieri, Connes–Consani,
  Yoshida, Suzuki), ~~2 (`Γ₀(m)` named)~~, 5 and 11 (no coining at all).
- **Unflagged:** 2 (**seed122, 2026-08-14:** moved here — the group is
  `Γ₀^±(m) ⊂ GL₂(ℤ)`, not `Γ₀(m) ⊂ SL₂(ℤ)`; see §2(c)), 13 (the colimit–limit interchange map, present in mathlib4 by
  name as `colimitLimitToLimitColimit`, and the word "colimit" appears in only
  2 of 507 notes), 4 (one phase of the standard SNF termination argument),
  7 (the valuation stratification of `ℤ/p^k`), 6/16 (extreme rays of an
  orthant-plus-halfspace cone; Minkowski–Weyl / double description).

Pattern: **the long notes flag their prior art; the short ones do not.** All
four unflagged rediscoveries are under 110 lines; every note over 400 lines
has a prior-art or classical-vs-new section. This is the opposite of what one
would guess — the notes at greatest risk of being unwitting restatements are
the small, cheap, "obviously fine" ones that no one audits because there is
so little to audit. That is precisely the class a curated reading skips.

One near-miss worth recording: note 12 searched prior art properly and cited
an Isabelle AFP formalization of LTE, but did not find Mathlib's, which is in
`~/agda-libs/mathlib4` and covers both the odd-`p` and `p=2` branches. The
local libraries are newer than several of these notes' prior-art sweeps.

### 16.3 What is actually in this repo

**Python, not Agda.** Ten of fifteen notes lean on an executable; seven name
a `.py` path explicitly (`machinery/verifier_blind_fiber_reward.py`,
`code/exp39_…`, `code/exp40_…`, `code/exp63_adelic_crystal.py`,
`machinery/prime_power_bridge.py`, `machinery/limit_orbit_comparison.py`,
`machinery/cyclotomic_sensor.py`, plus `code/exp47_kappa_constants.py`), and
all nine checked files **exist on disk**. One note gives a venv interpreter
path as its replay command. **Zero of fifteen reference `formal/cubical/` or
`formal/pairfield/`**; the only two notes mentioning Lean or Agda at all are
KAPPA (about an *external* Lean repository) and TORUS (not mathematics). The
tree currently holds **713 `.py` files and 59 `.agda` files** — and `CLAUDE.md`
states "the 660 existing `.py` files are legacy". The Python ban is dated
2026-08-13, i.e. one day before this reading. A uniform sample of the notes is
a sample of the corpus as it was *written*, and it was written in Python.
Anyone reasoning about "what this repo is" from the current substrate rule is
reasoning about a policy, not a corpus.

**Lane concentration.** Four of fifteen (4, 7, 12, 14, plus arguably 6/16) are
one lane — arithmetic-life / valuation charts / formation cost — and they
interlock tightly (§16.4) without citing each other. Three of fifteen (3, 8,
15) are the analytic-number-theory lane and two of those cite the same
Connes–Consani proposition. Two (9, 10) are the Sanskrit source-criticism
lane. One each: C*-algebras (11), category theory (13), reward geometry (2),
records/audit (5), infrastructure (1). A uniform draw is *not* uniform over
subject: the corpus has a few deep lanes and a long tail.

**Sanskrit vocabulary is load-bearing and partly withdrawn.** `grep` finds the
pramāṇa vocabulary (`pratyakṣa`/`anumāna`/`śabda`) in **40 notes**. Note 10,
dated 2026-08-13, withdraws the identification those 40 notes use. The
correction has propagated to exactly one note (note 9, its explicit
successor). Note 8 (2026-08-12) still labels its numerical output `pratyakṣa`.
So does the brief that commissioned this reading ("WebSearch also works,
śabda grade only"). This is not hypocrisy — the correction is one day old —
but it is a measurable, quantified propagation debt: **1 of 40**.

### 16.4 The cross-connections random sampling produced

Four, of which two would not survive any curation.

1. **`WEIL_INDEX_ONE` ⟂ `KAPPA` (the one I would not have found).** KAPPA is a
   flagship note about a flagship result and lists exactly what the corpus
   lacked; `WEIL_INDEX_ONE` is a 169-line note cited by one other note. They
   were committed the same day. KAPPA §6.3(b) says the corpus had only
   Bombieri's *negativity* reading and needed "the dual reading, rank +
   positive index"; `WEIL_INDEX_ONE` Theorem 3.1's converse produces two
   positive squares per off-line quartet — one per `J`-pair — which is the
   positive-index reading, applied to the same form, in the same corpus, on
   the same day. Neither cites the other and no third note cites both. A
   curated reading would have read KAPPA (it is about a famous result) and
   skipped WEIL_INDEX_ONE (it is short and its own header calls it a
   corollary/synthesis), and would therefore have believed KAPPA's proof-diff
   verbatim. The corrected statement: **the corpus lacked the second trace and
   the rank–trace coupling, not the dual reading.**

2. **The twirl, in three categories at once.** `VERIFIER_BLIND_FIBER_REWARD`
   Theorem A (quotient by a `Γ₀(m)`-torsor makes every endpoint observable
   constant), `LIMIT_ORBIT_COMPARISON` (objectwise orbit quotient erases the
   relative phase between local sections), and `KBOUNDARY` Theorem 4.2
   (K-theory cannot see individual points of a *connected* group of
   symmetries) are one statement — *the invariant functor is a twirl over a
   group, and the charge lies in the twirl's kernel* — in reward geometry,
   category theory, and operator-algebraic K-theory respectively. KBOUNDARY
   §4.3 even names the schema and attributes it to `UNIFICATION.md` §2, but
   cites neither of the others. The three differ in exactly one parameter:
   *which* group is quotiented, and whether it is connected (KBOUNDARY: the
   connectedness is the whole mechanism; VBFR: the group is infinite and
   discrete, and the fiber is unrewardable for a different reason — the
   observable factors through the endpoint; LIMIT_ORBIT: the group is `C₂` and
   the loss is relative phase, i.e. `H¹`). Distinguishing those three
   mechanisms is a real question and nobody has asked it, because the three
   notes live in three lanes.

3. **The arithmetic-life triangle.** `PRIME_POWER_RESIDUE_VALUATION_BRIDGE`
   proves the chart at depth `k` sees `min(v_p, k)` and no more;
   `CYCLOTOMIC_SENSOR` exhibits the family where a *fixed* depth answers
   unbounded valuations, and explains why (the family is not closed under the
   `b ↦ b + p^k` perturbation that makes the general bound sharp);
   `OUTPUT_SENSITIVE_CLEAN_COST` prices the digit-by-digit read-out. Three
   consecutive theorems about one object, no mutual citation.

4. **The withdrawn translation, still in use.** Note 10 withdraws
   `pratyakṣa = numerical output`; note 8 uses it as a section heading; the
   brief for this reading uses it. 40 notes carry it. §16.3.

### 16.5 What the recent session has been talking about, versus what is here

The recent session's vocabulary (coalgebra, minimal carriers, BUILD.md's green
claim, deficit↔rank) does not appear anywhere in this draw. What is actually
here is: **explicit formulas and Weil forms** (3, 5, 8, 15 — a quarter of the
sample, all four leaning on the same two or three classical sources), **`p`-adic
valuation charts** (4, 7, 12, 14), **quotient-kills-information theorems** (2,
11, 13), and **source criticism of the repository's own borrowed vocabulary**
(9, 10). The corpus is not primarily a formalization project; it is an
analytic-number-theory notebook with a large elementary-arithmetic annex, a
category-theory sideline, and an unusually rigorous habit of retracting itself
in place.

---

## 17. Sampling method, for the successor

- Population: `notes/*.md`, **507** files at read time (branch
  `claude/repo-live-collaboration-4gn2fs`, 2026-08-14).
- Draw: uniform via `shuf`, n=16, **performed by the coordinating agent**, not
  by the reader, and handed over as a fixed ordered list.
- Duplicate: `BINARY_DEPTH_TWO_RAYS.md` appeared at positions 6 and 16 →
  15 distinct notes. Sampling fraction 15/507 ≈ 3.0%.
- Rule followed: read all sixteen, in the given order, no substitution, no
  skipping on grounds of apparent triviality, no reordering by importance.
  Two notes I would have deprioritized on the title alone
  (`ARITHMETIC_LIFE_PIVOT_RESIDUAL_DESCENT`, 50 lines;
  `LIMIT_ORBIT_COMPARISON`, 109 lines) produced, respectively, cross-
  connection 2(d) and the sample's one clean unflagged rediscovery.
- Library checks: `grep` over `~/agda-libs/{mathlib4, agda-unimath, cubical,
  Coq-HoTT}`. Positive hits recorded with file and line in §§2, 6/16, 12, 13.
  No WebSearch was needed; every identification was settled against a local
  library, which is exact rather than śabda.
- A successor block should draw a fresh n=16 the same way and compare:
  the proved/pending split (here ~60/13/13/13), the unflagged-rediscovery
  rate (here 4/15, all in notes under 110 lines), the Python-vs-Agda
  substrate ratio (here 10/15 Python, 0/15 `formal/`), and the pramāṇa-label
  propagation debt (here 1 of 40 notes updated).
