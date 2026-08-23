# Gter: revelation cost, revelation time, and the two-coordinate defect

**Task.** Q9 of `notes/D0026_BUILD_QUEUE.md` §4b — ingest D0026 §7 (owner Deltas
37–38), which the queue's mechanical sweep found never ingested here. Source:
`collab/upstream/raw/D0026-owner-egb-core-transmission-v2-2026-08-16.md`
lines 2456–2700 (§§7.1–7.5), read in full.

**Status.** Proved. Four exact statements, two finite witnesses (minimal in all
three shape parameters), one correction to a repository note, one truncation
proposition, and one exact disagreement located *inside* D0026 between §7.3 and
§7.5. No experiment was run. No Python. Nothing kernel-checked (this container
has no toolchain); §4.7 gives the Agda shape the witnesses want.

**Verdict in one line.** Of the four items the queue flagged, **two were already
held** (ρ_P collapses to the repo's `d_Q`, adjudicated in `D0026_COMPARISON_MAPS`
§4.2; restricted-Yoneda density is held *twice*, generally and in exact finite
form — the queue and `D0026_COMPARISON_MAPS` §4.3 were both wrong to call it
absent), **one was genuinely absent and is the centerpiece** (§7.3's two-coordinate
defect, here given a finite model in which the independence claim is not merely
asserted but is a surjectivity theorem onto a 2×2 grid, with both requested
witnesses built at size (1,2,1) and proved minimal), and **one is not yet a
criterion at all** (§7.5's `GterStep`: its second conjunct quantifies over an
object D0026 never defines, and its first conjunct requires an exchange rate
between the two coordinates that §7.3's own sentence refuses and that Theorem 4
shows is never forced).

---

## 0. Prior-art sweep, performed before anything was written

Per the standing rule installed by `D0026_BUILD_QUEUE` §4b.1 (the rule Q2
violated). Read **in full**: `CHANGING_TESTS_VERSUS_SHRINKING.md`,
`ACTIVE_OBSERVER_DESIGN.md`, `D0026_COMPARISON_MAPS.md`,
`OPERATIONAL_SITE_CRYSTAL.md`, `OPERATIONAL_SITE_NEEDS_COVERAGE_LAWS.md`;
skimmed with section index: `SHRINKING_TESTS_LOWER_CURVATURE.md`,
`ADVANCE_CONJUNCTS_DEFINED.md`, `TESTER_OPERATIONAL_QUOTIENT.md`,
`GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`,
`NON_SCALAR_KNOWLEDGE_CAPABILITY_SYSTEM.md`. Greps over `notes/` and
`formal/cubical/` for `Gter` (3 files, all queue/index/comparison — the queue's
"never ingested" finding confirmed), `revelation` (5), `revelation time` (1),
`separator` (92), `distinguishing cost` (1), `probe` (115), `restricted Yoneda`
(3), `tear` (26), `coend` (27), `annihilator` (10), `tomograph` (8),
`compositional insufficiency` (0), `certified reach` (0).

| D0026 §7 item | status here, **before** this note |
|---|---|
| §7.1 Galois connection `R ⊆ E(P) ⟺ P ⊆ A(R)`, closures `ν_𝒪, ν_X` | **held**, with a uniqueness theorem and a no-go D0026 lacks: `CHANGING_TESTS_VERSUS_SHRINKING` Thms B/E/F, Prop. 6.3; adjudicated `D0026_COMPARISON_MAPS` §4 (verdict RESTRICTS-TO). Not restated here. |
| §7.2 revelation cost `ρ_P(x,y)` | **held** as `d_Q` (`ACTIVE_OBSERVER_DESIGN` §1(1)); the singleton-attainment identification is `D0026_COMPARISON_MAPS` §4.2. §1 below supplies what that row asserted but did not prove, and draws the consequence. |
| §7.2 probe filtration, revelation time `τ` | **dictionary row only** (`D0026_COMPARISON_MAPS` §4.2, "budget filtration"), no theorem. §2 below. |
| §7.2 restricted-Yoneda density = complete revelation | **held twice**, contrary to `D0026_COMPARISON_MAPS` §4.3's "no repo analogue": generally in `GENERABILITY_VERSUS_RECONSTRUCTIBILITY` §§1–3 (with literature), and as an exact finite criterion in `OPERATIONAL_SITE_CRYSTAL` Thm 4.1. §3 below records the correction and the gap the two notes together expose. |
| §7.3 two-coordinate defect `𝔤(P,Σ) = (E(P), ⋏_Σ)` | **absent in every dialect** — confirmed (`compositional insufficiency`: 0 hits; no note pairs a probe defect with a gluing defect). §4 below: the centerpiece. |
| §7.4 annihilator `𝔄_0^⊥`, incidence `(v,T,∂)` | **held in the roles-reversed form**: `TESTER_OPERATIONAL_QUOTIENT` §2 (annihilator `N_𝒞`, kernel theorem 2.1, quotient, and the realization-cost boundary). Not my assignment; recorded, not restated. |
| §7.5 `GterStep` admissibility | **absent**; the repo's nearest installed norms are named and honestly related in §5. |

Two adjacent repo results the sweep turned up that bear directly and are cited,
not restated: `OPERATIONAL_SITE_CRYSTAL` §2's three-way judgment
(separated / effective descent / reconstruction), and
`OPERATIONAL_SITE_NEEDS_COVERAGE_LAWS`' typed site-to-crystal map, whose closing
paragraph already separates "fibers measure failure of separatedness" from "the
complement of the image inside the matching-family equalizer measures failure of
existence in effective descent". That is the two-judgment discipline §7.3 needs,
already installed here for a *different* comparison map.

---

## 1. §7.2's revelation cost is definitionally a one-probe quantity

D0026 §7.2 defines, for a cost `c : 𝒪 → ℝ_{≥0}`,

  ρ_P(x,y) = inf { Σ_{r∈R} c(r) : (x,y) ∉ E(P ∪ R) },   R ⊆ 𝒪.

**Theorem 1 (collapse, unconditional).** For all `P ⊆ 𝒪` and all `x,y ∈ X`,

  ρ_P(x,y) = 0                              if (x,y) ∉ E(P),
  ρ_P(x,y) = min { c(r) : r ∈ 𝒪, r(x) ≠ r(y) }   otherwise
        ( = +∞ if no probe of 𝒪 separates (x,y) ).

*Proof.* `E(P ∪ R) = ⋂_{o ∈ P∪R} kerpair(o)`, so `(x,y) ∉ E(P∪R)` iff **some
single** `o ∈ P∪R` has `o(x) ≠ o(y)`. If some `o ∈ P` does, `R = ∅` is
admissible and its cost is the empty sum, `0`. Otherwise every admissible `R`
contains a separating `r`, and since `c ≥ 0` the sum over `R` is at least
`c(r)`; conversely the singleton `{r}` is admissible. The infimum is therefore
attained on singletons. ∎

**Corollary 1.1.** The infimum over *sets* in §7.2's display is decorative: the
set quantifier can be replaced by a probe quantifier without changing the
function. In particular ρ_P is `ACTIVE_OBSERVER_DESIGN`'s `d_Q` relativised to
the pool, which is the identification `D0026_COMPARISON_MAPS` §4.2 asserted;
Theorem 1 is the proof that row wanted, and it says more than the row did — the
collapse needs no hypothesis beyond `c ≥ 0` and additivity, and holds for
infinite `𝒪` with `min` read as `inf`.

**Corollary 1.2 (what ρ_P therefore cannot see).** Every quantity that makes
multi-probe experiment design non-trivial is invisible to ρ_P: cost interaction
(shared setup, submodularity), ordering, and above all **adaptivity** — choosing
`r_{k+1}` after seeing `r_k`'s outcome. `ACTIVE_OBSERVER_DESIGN` §6 already
records that "globally optimal adaptive experiment design is generally
combinatorial; it is not implemented here", and its §2 policy is explicitly
myopic. So the repo and D0026 hold the *same* non-adaptive quantity, and the
adaptive one is absent on both sides. Naming it: the sequential distinguishing
cost is not `inf` over sets but the value of a decision tree, and it is the
object the "distinguishing cost" name in `ACTIVE_OBSERVER_DESIGN` §3 is
carefully *not* claiming to be. This is not a deficiency of §7.2; it is the
scope of the symbol, and the symbol's shape hides it.

*Fence.* Theorem 1 assumes probe outcomes are compared pointwise
(`kerpair(o) = {(x,y) : o(x) = o(y)}`, §7.1's own definition). A probe universe
whose separating power is *joint* — where two probes separate a pair that
neither separates alone — cannot be presented as a family of maps `o : X → Y_o`
in the first place; §7.1 forecloses that case at the definition, and Theorem 1
is the price.

---

## 2. Revelation time and revelation cost are one datum, not two

D0026 §7.2 introduces a probe filtration `P_0 ⊆ P_1 ⊆ ⋯` with
`τ(x,y) = inf{ t : (x,y) ∉ E(P_t) }` immediately after ρ_P, as a second
apparatus. It is the same apparatus.

**Theorem 2 (inter-definability).** Let `X`, `𝒪` be as in §7.1.

 (a) Given `c : 𝒪 → ℝ_{≥0}` and `P ⊆ 𝒪`, define the **cost filtration**
   `P_t := P ∪ { r ∈ 𝒪 : c(r) ≤ t }` for `t ≥ 0`. It is a filtration
   (monotone in `t`), and for all `x,y`: `τ(x,y) = ρ_P(x,y)`.

 (b) Conversely, given any filtration `(P_t)_{t≥0}` with `P_0 = P`, define
   `c(r) := inf { t : r ∈ P_t }`. Then `ρ_P(x,y) = τ(x,y)` for all `x,y`.

*Proof.* (a) `(x,y) ∉ E(P_t)` iff some `o ∈ P_t` separates `(x,y)` (as in
Theorem 1), i.e. iff `(x,y) ∉ E(P)` or some `r` with `c(r) ≤ t` separates.
Taking the infimum over such `t` gives `0` in the first case and
`min{c(r) : r separates}` in the second — which is Theorem 1's right-hand side.
(b) Same computation read backwards: `(x,y) ∉ E(P_t)` iff `(x,y) ∉ E(P)` or some
separating `r` has entry time `≤ t`; the infimum over `t` is `0` or
`min{c(r) : r separates}`, which is `ρ_P(x,y)` by Theorem 1. ∎

**Corollary 2.1.** §7.2 presents two notions where there is one. A filtration
carries exactly the information of a cost function *up to the level sets of that
cost*, and nothing more: two filtrations induce the same `τ` iff their entry-time
functions have the same separating-minimum profile. Consequently "revelation
time" is not a dynamical notion in §7.2 — no probe acquisition process, budget
depletion, or feedback appears in it. A genuinely temporal `τ` would need the
filtration to depend on outcomes already observed, i.e. exactly the adaptive
structure Corollary 1.2 shows ρ_P cannot express.

*Fence.* (b) needs `inf ∅ = +∞` and, for the `min` in Theorem 1 to be attained,
either finiteness of `𝒪` or lower semicontinuity of `c`; with `inf` throughout,
both parts hold verbatim for infinite `𝒪`.

---

## 3. Density: already held twice — and it is *not* the same criterion as E(P) = Δ

**Correction (this note's, against a repo note).** `D0026_COMPARISON_MAPS` §4.3
states: *"Their restricted-Yoneda density criterion (complete revelation = probe
density) likewise has no repo analogue."* This is false, on two counts, and
`D0026_BUILD_QUEUE` §4b Q9 inherits the error:

1. **General form, with literature.** `GENERABILITY_VERSUS_RECONSTRUCTIBILITY`
  §1.2 and §3 carry the restricted Yoneda embedding `Ñ_G : 𝒞 → [J^op, S]`, the
  nerve–realization adjunction `|−|_G ⊣ Ñ_G`, density as full faithfulness of
  the restricted embedding, the codensity monad as the measure of its failure,
  and a searched prior-art section (Isbell 1960 adequacy; nLab *dense functor*;
  Leinster, TAC 2013). It even records the enrichment hypothesis density is
  sensitive to — a hypothesis §7.2 leaves unstated.
2. **Exact finite form.** `OPERATIONAL_SITE_CRYSTAL` Thm 4.1: on the powerset
  poset `𝒫(Ω)` with a full probe subcategory `ℬ`, the restricted nerve is fully
  faithful **iff** `ℬ` contains every singleton — a computable density criterion
  with a witness for the failure (a missing singleton manufactures a spurious
  profile morphism `N({ω}) → N(∅)`). `OPERATIONAL_SITE_NEEDS_COVERAGE_LAWS`
  confirms this theorem survives that note's correction untouched.

No claim of equivalence with D0026 §7.2 is made here beyond what
`D0026_COMPARISON_MAPS` §4 already establishes for §7.1–7.2; the corrected row is
a *presence* claim about this repository, not a new map.

What the two repo notes jointly expose, and which is worth stating because §7.2
elides it:

**Proposition 3 (separation is strictly weaker than density, and §7.2 changes
ambient categories mid-sentence).** §7.1 defines hiddenness on a bare **set** `X`;
"complete revelation" in that setting means `E(P) = Δ_X`. §7.2's criterion is
full faithfulness of `N_𝒫` on a **category** `𝒞`. These agree exactly when `𝒞` is
discrete. Otherwise density is strictly stronger, and the gap is realised at two
objects and one probe: let `𝒞` have objects `A, B` with
`Hom(A,B) = Hom(B,A) = ∅`, and `𝒫` the full subcategory on `A`. Then
`N_𝒫(A) = {id_A}`, `N_𝒫(B) = ∅`, so `N_𝒫` is injective on objects and faithful
(all hom-sets are empty or singletons) — the probes separate every pair of states
— yet the unique map `∅ → {id_A}` is a natural transformation
`N_𝒫(B) → N_𝒫(A)` with `Hom_𝒞(B,A) = ∅` beneath it. `N_𝒫` is not full, hence not
dense. ∎

This is `OPERATIONAL_SITE_CRYSTAL` Cor. 4.2's remark ("a merely injective object
code need not be a dense nerve; density reconstructs compositional relations as
well") supplied with the smallest witness. It matters for §7 specifically:
§7.3's whole point is that *compositional* structure is a second coordinate, and
§7.2's density criterion is already the categorical shadow of that same second
coordinate — so §7.2's sentence "complete revelation is probe density" is not a
strengthening of `E(P) = Δ`, it is a silent change of subject to the coordinate
§7.3 then declares independent.

---

## 4. §7.3, the centerpiece: static hiddenness and compositional insufficiency, and their independence proved

D0026 §7.3 asserts, without proof or witness:

> They are independent. A state space can be fully separated while its boundary
> description fails to compose. A cut can compose perfectly while its probes
> collapse distinct states. The two-coordinate defect is `𝔤(P,Σ) = (E(P), ⋏_Σ)`.

I verified the claim by constructing both witnesses. They are finite, minimal,
and exact.

### 4.1 A finite model in which both coordinates are defined

D0026's `⊖` in `⋏_{Σ_1} = 𝔗_02^{direct} ⊖ ∫^{Σ_1} 𝔗_01 ⊗ 𝔗_12` is undefined in
the transmission (the same defect `SHRINKING_TESTS_LOWER_CURVATURE` §0 records
for D0016's `⊖`). I therefore fix a model, name it, and prove inside it.

**Definition 4.1 (finite cut system).** A *cut system* is
`𝔖 = (Σ_0, Σ_1, Σ_2 ; 𝔗_01, 𝔗_12, 𝔗_02)` with `Σ_i` finite sets,
`𝔗_01 ⊆ Σ_0 × Σ_1`, `𝔗_12 ⊆ Σ_1 × Σ_2`, `𝔗_02 ⊆ Σ_0 × Σ_2`. The **glued
realization** is relational composition,

  (𝔗_01 ⊙ 𝔗_12)(a,c) ⟺ ∃ b ∈ Σ_1 : (a,b) ∈ 𝔗_01 ∧ (b,c) ∈ 𝔗_12,

which is the decategorification of `∫^{Σ_1} 𝔗_01 ⊗ 𝔗_12` (profunctor
composition is that coend; the relational case is its `(-1)`-truncation). The
**tear** is

  ⋏(𝔖) := ( 𝔗_02 ≠ 𝔗_01 ⊙ 𝔗_12 )  ∈ {0, ≠0}.

**Definition 4.2 (the interface-intrinsic probe pool).** The states probed are
the cut states `X := Σ_1`. The probes available *at the interface* are the two
profile maps

  L : Σ_1 → 𝒫(Σ_0),  L(b) = { a : (a,b) ∈ 𝔗_01 },
  R : Σ_1 → 𝒫(Σ_2),  R(b) = { c : (b,c) ∈ 𝔗_12 },

and `P_can := {L, R}`, so `E(P_can) = { (b,b') : L(b)=L(b') ∧ R(b)=R(b') }`.

This choice is the point. Taking `P_can` maximal-intrinsic means **both
coordinates of `𝔤` are functions of the same data `(𝔗_01, 𝔗_12, 𝔗_02)`** — the
independence below is not manufactured by letting the probes and the gluing
range over unrelated parameters, and `P_can` is the pool with the *greatest*
separating power available from the interface, so "the probes collapse distinct
states" is the hardest possible cell to reach. Any smaller pool only makes the
theorem easier.

Write `sep(𝔖) :⟺ E(P_can) = Δ_{Σ_1}` and `comp(𝔖) :⟺ 𝔗_01 ⊙ 𝔗_12 ≠ ∅`.

### 4.2 The independence theorem

**Theorem 4 (four-cell surjectivity; the sharp, parameter-free form).** On the
shape `|Σ_0| = 1, |Σ_1| = 2, |Σ_2| = 1`, the map

  (𝔗_01, 𝔗_12) ⟼ ( sep, comp ) ∈ {T,F} × {T,F}

is **surjective**. Neither coordinate is a function of the other, and this
already holds with `𝔗_02` not yet chosen — so the independence is not an artifact
of `𝔗_02^{direct}` being a free datum.

*Proof.* Write `Σ_0 = {a}`, `Σ_2 = {c}`, `Σ_1 = {b_1, b_2}`. Then `𝔗_01` is a
subset `S_L ⊆ Σ_1`, `𝔗_12` a subset `S_R ⊆ Σ_1`; `L(b)` is determined by
`b ∈ S_L`, `R(b)` by `b ∈ S_R`, so `sep ⟺ (χ_{S_L}, χ_{S_R})(b_1) ≠
(χ_{S_L}, χ_{S_R})(b_2)`, and `comp ⟺ S_L ∩ S_R ≠ ∅`. Four systems, each
verified by inspection of the two-element table:

| # | `S_L` | `S_R` | profile of `b_1` | profile of `b_2` | `sep` | `comp` |
|---|---|---|---|---|---|---|
| 1 | `{b_1}` | `{b_1}` | `(1,1)` | `(0,0)` | **T** | **T** |
| 2 | `{b_1}` | `{b_2}` | `(1,0)` | `(0,1)` | **T** | **F** |
| 3 | `{b_1,b_2}` | `{b_1,b_2}` | `(1,1)` | `(1,1)` | **F** | **T** |
| 4 | `∅` | `∅` | `(0,0)` | `(0,0)` | **F** | **F** |

All four cells are hit. ∎

**Corollary 5 (the two witnesses D0026 asserts).** Adjoin `𝔗_02 := {(a,c)}` to
rows 2 and 3:

- **Witness (i) — separated, tear ≠ 0.** Row 2 with `𝔗_02 = {(a,c)}`.
 The probes `L, R` distinguish `b_1` from `b_2` completely (`E(P_can) = Δ`), yet
 `𝔗_01 ⊙ 𝔗_12 = ∅ ≠ {(a,c)} = 𝔗_02`, so `⋏ ≠ 0`. *Reading:* there is a direct
 `a ⇝ c` process, and no state on the cut carries it — `b_1` meets the left
 boundary only, `b_2` the right only. A perfect instrument on a broken interface.
- **Witness (ii) — tear = 0, probes collapse distinct states.** Row 3 with
 `𝔗_02 = {(a,c)}`. Here `𝔗_01 ⊙ 𝔗_12 = {(a,c)} = 𝔗_02`, so `⋏ = 0` exactly, while
 `E(P_can) = Σ_1 × Σ_1`: the interface probes cannot tell `b_1` from `b_2` at all.
 A perfect interface on a blind instrument. ∎

**Corollary 5.1 (full `𝔤`-surjectivity).** Since `𝔗_02` is a free datum, for
*every* `(𝔗_01, 𝔗_12)` both tear values occur (take `𝔗_02 := 𝔗_01 ⊙ 𝔗_12` and
`𝔗_02 := ` its complement in `Σ_0 × Σ_2`). Combined with Theorem 4,
`𝔖 ↦ (sep, ⋏ = 0?)` is surjective onto `{T,F}²`, fibrewise in the static
coordinate. The forward half of this is cheap and I say so; the content is
Theorem 4, where no free parameter is available.

**Theorem 6 (minimality of the shape, all three parameters).** The shape
`(|Σ_0|, |Σ_1|, |Σ_2|) = (1,2,1)` is minimal for Theorem 4.

*Proof.* If `|Σ_1| ≤ 1` then `E(P_can) ⊆ Σ_1 × Σ_1 = Δ_{Σ_1}` always, so
`sep ≡ T` and the cells with `sep = F` are unreachable. If `Σ_0 = ∅` (resp.
`Σ_2 = ∅`) then `Σ_0 × Σ_2 = ∅`, forcing `𝔗_01 ⊙ 𝔗_12 = 𝔗_02 = ∅`, so `comp ≡ F`
and `⋏ ≡ 0`; the cells with `comp = T` are unreachable. Hence
`|Σ_0|, |Σ_2| ≥ 1` and `|Σ_1| ≥ 2`, and the table of Theorem 4 attains all three
bounds simultaneously. ∎

*(For witness (i) alone the shape `(1,1,1)` suffices — `S_L = S_R = {b}`,
`𝔗_02 = ∅` — but there `sep` holds vacuously and the claim is degenerate. The
minimal shape carrying the **joint** statement is (1,2,1).)*

### 4.3 The tear is not one number: `⊖` must declare its truncation

**Proposition 7.** Replace relations by `Set`-valued profunctors
(`𝔗_01 : Σ_0^op × Σ_1 → Set`, etc.), so that
`(∫^{Σ_1} 𝔗_01 ⊗ 𝔗_12)(a,c) = ⨿_{b ∈ Σ_1} 𝔗_01(a,b) × 𝔗_12(b,c)` is the honest
coend, and let `γ : ∫^{Σ_1} 𝔗_01 ⊗ 𝔗_12 → 𝔗_02` be the canonical comparison.
Then witness (ii) has `γ` a **2-to-1 surjection**: two glued histories
(`a → b_1 → c` and `a → b_2 → c`) over one direct realization. Hence

  ⋏ = 0 in the relational reading  and  ⋏ ≠ 0 in the `Set`-valued reading,

on the *same* cut system. `⋏` is therefore **not truncation-invariant**, and
D0026's `⊖` is under-determined until the truncation level is declared. ∎

**Corollary 7.1 (the tear has two independent failure modes).** `γ` fails to be
an isomorphism in two ways: **not surjective** — a direct realization that no
gluing over the cut produces (witness (i)); **not injective** — distinct
histories through the cut with a single direct shadow (witness (ii),
`Set`-valued). These are exactly the two judgments this repository already
separates for a *different* comparison map: `OPERATIONAL_SITE_CRYSTAL` §2's
separated (injective) versus effective descent (bijective), and
`OPERATIONAL_SITE_NEEDS_COVERAGE_LAWS`' closing map ("fibers measure failure of
separatedness; the complement of the image inside the matching-family equalizer
measures failure of existence"). **I claim shape-similarity of the discipline,
not identity of the two comparison maps** — the sheaf comparison
`F(e) → Eq(∏F(e_i) ⇉ ∏F(e_i ×_e e_j))` and `γ` are different arrows, and no map
between them is exhibited here.

Corollary 7.1 is the sharpest thing §7's own title asks for: **hidden-history
tomography is the non-injective half of `γ`**, and it is invisible to any tear
defined at the relational level. A tear reported as a single symbol has already
discarded it.

### 4.4 What the independence does *not* say

The witnesses show `sep` and `comp` are logically independent as coordinates.
They do **not** show the coordinates are causally unrelated in any given family;
`comp` is a statement about the *union* of the profiles' supports and `sep`
about their *separating power*, and on richly structured families (e.g. where
every cut state must meet both boundaries) the cells can be constrained. The
theorem is: no such constraint is implied by the definitions.

### 4.5 Legacy-Python note

`OPERATIONAL_SITE_CRYSTAL` §6 reports a "deliberately restricted global state
set is separated but not effective" as a control in `machinery/operational_site.py`.
That is the same phenomenon family as witness (i), and under `CLAUDE.md` it is
**not proof**: it is a script whose reader must trust the script, its author, and
the run. §4.2's witnesses are displayed tables checkable by reading, which is
why they were built rather than cited.

### 4.6 Prior-art posture for §4

Theorem 4 is elementary; I would be unsurprised to find it folklore in one of the
neighborhoods named in §6, and it is marked SEARCH-pending accordingly. What I
did not find anywhere in this corpus is the **pairing** — a probe defect and a
gluing defect carried as one two-coordinate object — which is D0026's
contribution (Deltas 37–38) and is why the queue ranked Q9 highest.

### 4.7 Agda shape (refl-certificate material; not written, not checked)

Everything in §4.2 is decidable on a two-element carrier, so both witnesses and
the whole of Theorem 4 are `refl` after Boolean evaluation. The module should
live at `formal/cubical/NaturalMachine/GterTwoCoordinate.agda`,
`--cubical --safe`, no postulates, no holes, and be added to `Everything.agda`
(the Q8 latch). Shape:

```agda
{-# OPTIONS --cubical --safe --no-import-sorts #-}
module NaturalMachine.GterTwoCoordinate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; _or_ ; not)

-- Σ₀ = Σ₂ = Unit, Σ₁ = Bool.  A relation Σ₀×Σ₁ is then Bool → Bool.
Cut : Type₀
Cut = Bool

Side : Type₀
Side = Cut → Bool          -- S_L, or S_R

eqb : Bool → Bool → Bool
eqb true  b = b
eqb false b = not b

-- comp : does some cut state carry the a ⇝ c composite?
comp : Side → Side → Bool
comp l r = ((l false) and (r false)) or ((l true) and (r true))

-- sep : do the interface-intrinsic probes {L,R} separate the two cut states?
sep : Side → Side → Bool
sep l r = not ((eqb (l false) (l true)) and (eqb (r false) (r true)))

-- tear against a declared direct realization d : Bool
tear : Side → Side → Bool → Bool
tear l r d = not (eqb (comp l r) d)

-- Row 2 of Theorem 4  →  witness (i): separated, tear ≠ 0
Lᵢ Rᵢ : Side
Lᵢ = λ b → b
Rᵢ = λ b → not b

wit-i-sep  : sep  Lᵢ Rᵢ      ≡ true
wit-i-sep  = refl
wit-i-tear : tear Lᵢ Rᵢ true ≡ true
wit-i-tear = refl

-- Row 3 of Theorem 4  →  witness (ii): tear = 0, probes collapse
Lᵢᵢ Rᵢᵢ : Side
Lᵢᵢ = λ _ → true
Rᵢᵢ = λ _ → true

wit-ii-collapse : sep  Lᵢᵢ Rᵢᵢ      ≡ false
wit-ii-collapse = refl
wit-ii-notear   : tear Lᵢᵢ Rᵢᵢ true ≡ false
wit-ii-notear   = refl

-- Theorem 4: all four (sep, comp) cells realized.  Rows 1 and 4:
row1 : (sep (λ b → b) (λ b → b) , comp (λ b → b) (λ b → b)) ≡ (true , true)
row1 = refl
row4 : (sep (λ _ → false) (λ _ → false) , comp (λ _ → false) (λ _ → false))
     ≡ (false , false)
row4 = refl
-- rows 2,3 are (true , false) and (false , true), likewise refl.
```

Theorem 6 (minimality) is *not* refl-material — it quantifies over shapes and is
the hand proof of §4.2. Proposition 7 is not either: it needs `Set`-valued
profunctors and the coend, which is a real construction, not a Boolean table.
Flagged honestly rather than promised.

---

## 5. §7.5's `GterStep`, related honestly to this repository's installed-operator norms

D0026 §7.5 declares `τ ∈ GterStep(K_t)` iff (1) `ΔComplexity(𝔡_t) < 0`,
(2) `ΔCone_cert(K_t; τ) > 0`, (3) an explicit comparison or witness map exists,
where `𝔡_t = (E_t, ⋏_t, 𝒪_t^⊥, Hol_t, SpecBad_t)`.

**5.1 Conjunct (3) is already this repository's installed norm.** It is verbatim
the no-premature-Rosetta law: `D0026_COMPARISON_MAPS`' rubric (typed map +
preserved invariant + round trip + defect + epistemic status) and `CLAUDE.md`'s
demand that a certificate be the object rather than a report of one. Nothing to
ingest; the norm is older here than the transmission's statement of it.

**5.2 Conjunct (2) is not yet a criterion.** `Cone_cert` is used twice in D0026
(§7.5 and §14.3) and **defined nowhere** in it; a grep of this repository returns
zero occurrences of `certified reach`, `ΔReach`, or `Cone_cert`. The nearest
installed thing here is coverage bookkeeping (`AGDA_COVERAGE_INVENTORY.md`,
`AGDA_COVERAGE_LEDGER.md`) plus the Q8 latch, which counts *modules reached by
the kernel*, not theorems reachable by a grammar. I record conjunct (2) as
**undischargeable as written**, on both sides, and do not repair it: supplying a
definition would be inventing the owner's object.

**5.3 Conjunct (1) requires an exchange rate that §7.3 refuses and Theorem 4
shows is never forced.** This is where the centerpiece does work.

- §7.3's own acceptance sentence — *"should reduce one or both coordinates
 without silently worsening the other"* — is the **product order** on
 `(E, ⋏)`: a partial order.
- §7.5's conjunct (1) is a **scalar** `Complexity : 𝔡 ↦ ℝ`: a total order.
- By Theorem 4 the product order on the first two coordinates has genuinely
 incomparable pairs, realized at shape (1,2,1): the transition from row 3 with
 `𝔗_02 = 𝔗_01 ⊙ 𝔗_12` (`E` = everything, `⋏ = 0`) to row 2 with
 `𝔗_02 = {(a,c)}` (`E = Δ`, `⋏ ≠ 0`) strictly improves the static coordinate and
 strictly worsens the dynamic one. §7.3 declines to decide it. §7.5 decides
 it — in whichever direction the undeclared weights point.

So the two sections are not the same acceptance criterion, and the independence
theorem is precisely what makes them differ. **Recommendation flowing upstream:
§7.5 conjunct (1) should be read as the product order of §7.3, or else declare
the trade-off it is smuggling.**

**5.4 The repository's own norm agrees with §7.3, not §7.5.**
`NON_SCALAR_KNOWLEDGE_CAPABILITY_SYSTEM` §1 installs exactly this discipline as
a design invariant: *"No canonical map `G → ℝ` is proposed. Truth, novelty,
utility, permission, verification cost, and pedagogical value are separate
coordinates."* And `CHANGING_TESTS_VERSUS_SHRINKING` §8 refuses to add "a metric,
a norm, a cardinality-based progress measure, an ordinal assignment", with
Theorem F as the reason and the explicit note that the scalar shadow `‖O‖` "is no
better: it is a function of `δ`, hence covered by Theorem F".

**Proposition 8 (Theorem F's argument, in §7's own coordinates).** Let
`Im(E) = { E(P) : P ⊆ 𝒪 }` (the `ν_𝒪`-closed relations). If `φ : Im(E) → L` is
any function into a poset such that `φ(E(P')) ≤ φ(E(P))` for **all** `P, P' ⊆ 𝒪`
— i.e. `φ` is monotone under unrestricted probe replacement, which is what §7.5
needs if "compresses a recurrent defect" is to be checkable without a comparison
datum — then `φ` is constant on `Im(E)`.
*Proof.* Apply the hypothesis to `(P, P')` and to `(P', P)`; antisymmetry gives
`φ(E(P)) = φ(E(P'))`. ∎
This is `CHANGING_TESTS_VERSUS_SHRINKING` Theorem F's argument, credited there,
transposed from `δ` to `E`; the realisability content of Theorem F (which
constructs the systems attaining arbitrary pairs) is stronger and is not
reproved. The consequence for §7.5: any scalar `Complexity` with content must
depend on the *transition*, not only on the defect tuple — i.e. must carry
`CHANGING_TESTS` Theorem E's comparison datum. That is the surplus
`D0026_COMPARISON_MAPS` §4.4 already flagged as flowing upstream; §7.5 is the
section that consumes it.

---

## 6. Prior art

**Owner provenance.** D0026 §7 in full is the repository owner's, owner-side
Deltas **37–38** per D0026 §15's source map, received
2026-08-16 (`collab/upstream/raw/D0026-owner-egb-core-transmission-v2-2026-08-16.md`,
lines 2456–2700). The objects `E(P)`, `A(R)`, `gter(P)`, `ρ_P`, `τ`, `⋏_Σ`,
`𝔤(P,Σ)`, `𝔡_t`, `GterStep` and the independence *claim* are the owner's. What is
mine: Theorems 1, 2, 4, 6, Propositions 3, 7, 8 and their proofs; Definitions
4.1–4.2; the witnesses; the §3 correction; the §5.3 disagreement. I amend nothing
upstream and mark nothing of the owner's alphabet.

**Repository prior art, cited not restated.** §7.1's Galois connection and its
closures: `CHANGING_TESTS_VERSUS_SHRINKING` (Thms A–F, Prop. 6.3) and its
predecessor `SHRINKING_TESTS_LOWER_CURVATURE`; the adjudication is
`D0026_COMPARISON_MAPS` §4 and **is not redone here**. `ρ_P ↔ d_Q`:
`ACTIVE_OBSERVER_DESIGN` §1 and `D0026_COMPARISON_MAPS` §4.2. Density:
`GENERABILITY_VERSUS_RECONSTRUCTIBILITY` §§1–3 and `OPERATIONAL_SITE_CRYSTAL` §4.
Two-judgment discipline: `OPERATIONAL_SITE_CRYSTAL` §2,
`OPERATIONAL_SITE_NEEDS_COVERAGE_LAWS`. Annihilator/tomography (§7.4):
`TESTER_OPERATIONAL_QUOTIENT` §2. Non-scalarization:
`NON_SCALAR_KNOWLEDGE_CAPABILITY_SYSTEM` §1. Anchor-collapse for admissibility
predicates of `GterStep`'s shape: `ADVANCE_CONJUNCTS_DEFINED` §7.

**Standard-literature neighbours, named from memory, all SEARCH-pending — no
source was opened for this note and none is quoted.**

- ρ_P / one-probe separating cost: *minimum test cover* / *minimum test set*
 (Garey–Johnson, problem SP6); separating and qualitatively independent
 families (Rényi; Katona); teaching dimension and specifying sets
 (Goldman–Kearns); Blackwell comparison of experiments. Adaptive counterpart
 (Cor. 1.2): distinguishing sequences for finite automata — Moore's
 "Gedanken-experiments on sequential machines" (1956) for the separating
 experiment, and Lee–Yannakakis (1994) for the adaptive/preset split.
- Density: Isbell's *adequacy* (1960), dense functors, codensity monads
 (Leinster). Already searched in `GENERABILITY_VERSUS_RECONSTRUCTIBILITY` §3;
 not re-searched.
- The coend `∫^{Σ_1} 𝔗_01 ⊗ 𝔗_12`: profunctor composition as a coend (Bénabou);
 the relational case is composition in `Rel`, and Prop. 7 is the observation
 that `Rel` is the `(-1)`-truncation of `Prof`.
- The tear: gluing/locality axioms in the Atiyah–Segal style (failure = gluing
 anomaly); Feshbach/Schur-complement self-energy for the operator-theoretic
 analogue — already in this corpus via D0026 §4.4 and
 `DELTA19_IS_THE_KERNEL_AGAIN`.
- Independence of "reduced/observable" from "decomposable/compositional":
 Krohn–Rhodes decomposition versus Myhill–Nerode minimization is the standing
 automata-theoretic instance of the same two coordinates. Whether Theorem 4 is
 a known folklore instance of that separation is **the one search I would run
 first**, and it is not run here.

---

## 7. Scope fence

1. **Nothing kernel-checked.** No agda/lean toolchain in this container. §4.7 is
  a shape, not a verdict; "refl-certificate material" is a forecast that the four
  Boolean identities normalize (`p ≈ 0.97` — they are closed Boolean terms on a
  two-element carrier; the residual risk is library naming, not mathematics).
2. **The model is declared, not derived.** Definition 4.1 fixes `⊖` as
  inequality of relations and `∫^{Σ_1}` as relational composition because D0026
  defines neither. Theorem 4 is a theorem about cut systems; it is *evidence
  about* §7.3's general claim, at the strength of the model, and Proposition 7
  shows the model's truncation level is itself load-bearing. I do **not** claim
  §7.3's general assertion is proved.
3. **No equivalence claimed** with the repository's re-derivations beyond what
  `D0026_COMPARISON_MAPS` §4 already establishes (verdict RESTRICTS-TO for
  §7.1–7.2). §3's correction is a presence claim about this repository, §4.3's
  Corollary 7.1 is a shape-similarity claim explicitly disclaimed as an
  identification, and §5's relations are disagreements located, not maps built.
4. **§7.4 is not ingested.** Its annihilator content is held
  (`TESTER_OPERATIONAL_QUOTIENT`); its `(v,T,∂)` incidence claim and the spectral
  measure `μ_v^T` are neither ingested nor adjudicated here.
5. **The adaptive quantity is named, not built.** Cor. 1.2 says what ρ_P cannot
  see; it does not define the sequential cost, and this note does not.
6. **No experiment, no fitted constant, no floating-point number, no Python, no
  commit.**

---

## 8. Declared consumers

- **Upstream, owner-side Δ37–38 ledger:** the §3 correction (density is held
 here, twice); the §5.3 disagreement between §7.3's product order and §7.5's
 scalar; §5.2's undefined `Cone_cert`; Prop. 7's demand that `⊖` declare its
 truncation; Cor. 1.1/2.1's finding that §7.2's two apparatus are one.
- **`notes/D0026_COMPARISON_MAPS.md` §4.3:** correction, to be applied there
 (its "no repo analogue" sentence for restricted-Yoneda density is false).
 **`notes/D0026_BUILD_QUEUE.md` §4b Q9:** same correction; item (c) of that row
 is discharged by §4, items (a)/(b) are reclassified as already-held.
- **`formal/cubical/` lane (PROVE, one sitting):** `GterTwoCoordinate.agda` per
 §4.7, plus its `Everything.agda` entry (Q8 latch).
- **`notes/OPERATIONAL_SITE_CRYSTAL.md` §8's open tension** (extend Thm 4.1
 beyond truth-valued powerset probes): Prop. 3 supplies the minimal
 separation-without-density witness that tension needs, and §4's cut systems are
 a candidate next carrier.
- **`notes/ACTIVE_OBSERVER_DESIGN.md` §9 successor 3** (translation morphism
 between two observers' probe contexts): Cor. 1.2 sharpens what such a morphism
 must preserve, and Theorem 4 says preserving `E` alone preserves nothing about
 composability.
- **D0026 §14.5 acceptance** ("a tear maps to a specified object"): §4.1 names
 the object in the finite model, and Cor. 7.1 says it is two objects, not one.

---

*Owner's framework and all of §7's objects: D0026 §7 (Deltas 37–38), 2026-08-16.
Theorems 1, 2, 4, 6, Propositions 3, 7, 8, Definitions 4.1–4.2, the witnesses and
the corrections: this note. No experiment was run.*

---

*Appended 2026-08-19.* Scope-fence item 5 ("**The adaptive quantity is named,
not built**") is now built, in this note's own register:
`formal/cubical/NaturalMachine/AdaptiveProbeCollapse.agda` (`--cubical --safe`,
checked on the pin) proves for a bare pool `out : O → X → Y` — no dynamics, no
finiteness, arbitrary outcome type — that the kernel of every finite adaptive
strategy EQUALS `E(𝒪)`, hence that no adaptive observer recovers a charged
functional. Corollary 1.2 is thereby vindicated rather than patched: `ρ_P`
cannot see adaptivity **because adaptivity does not move the quotient**; it is
a gain on the budget coordinate only, and the same module carries a checked
four-state three-probe witness of that gain. Write-up:
`notes/ADAPTIVE_OBSERVERS_ARE_ALREADY_FENCED.md`.
