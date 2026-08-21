> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# DSO Deltas 26 & 27 — reconstructed from the EGB Library Index V3

**Author:** navigation-lane extraction, 2026-08-16
**Status:** INDEX-DERIVED navigation, not verification. Nothing here upgrades
any claim's evidence grade (per `notes/EGB_LIBRARY_INDEX_V3.md` landing note:
"this is navigation, not verification").
**Purpose:** resolve the standing `SEARCH` item raised in
`notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` §Repository-landing-note
point 1 — recover Deltas 26–27 so Delta 28's references to
`continuation transformer`, `factorRank`, the `Isbell nucleus`, and
`costRank ≤ witnessRank` resolve in-repo.

---

## 0. Headline finding (read this first)

**The SEARCH item is already resolved by two files the landing note did not
know about.** Delta 28's landing note (dated 2026-08-14) asserts "No
`DEPENDENT_SYSTEM_OPTIMIZATION_*DELTA_26/27*` file exists in `notes/`." That
assertion is now **stale**. The full upstream texts were landed since (via the
`claude/prime-pair-field-research-*` sync commits):

- **Delta 26** — `notes/DEPENDENT_SYSTEM_OPTIMIZATION.md` (945 lines, titled
  "Dependent System Optimization — Delta 26").
- **Delta 27** — `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md` (904 lines,
  titled "… — Delta 27").

So the definitions Delta 28 leans on are available **as originals** in-repo,
not merely as index compressions. This note does two things:

1. records what the **V3 index** independently preserves about Deltas 26/27
   (the navigation layer — labeled index-derived), and
2. pins each of Delta 28's four references to the **exact section of the
   in-repo original** that defines it, plus the checked Agda foothold.

The distinction matters: the index compressions are a lossy second-pass
summary; the in-repo notes are the authoritative texts. Where they agree, the
reference resolves. Where only the index speaks, the item is still
navigation-grade and the upstream original governs.

---

## 1. What the V3 index preserves (index-derived)

The index (`notes/EGB_LIBRARY_INDEX_V3.md`, 177-artifact atlas) locates the
DSO delta chain by exact upstream filename and compresses each core. Relevant
entries:

| # | Upstream filename (index-reported) | Evidence | In-repo landing |
|---|---|---|---|
| 108 | `DEPENDENT_SYSTEM_OPTIMIZATION_GREAT_LEAP_DELTA_26_2026-08-14.md` | FULL_TEXT_REREAD (lines 1–3050) | `notes/DEPENDENT_SYSTEM_OPTIMIZATION.md` |
| 114 | `DEPENDENT_SYSTEM_OPTIMIZATION_NUCLEUS_DELTA_27_2026-08-14.md` | FULL_TEXT_REREAD (lines 1–2503) | `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md` |
| 115 | `dependent_system_optimization_nucleus_demo.py` | FULL_CODE_REREAD (308 lines) | Python — banned; Agda footholds below |
| 117 | `DEPENDENT_SYSTEM_OPTIMIZATION_GEOMETRY_DELTA_28_2026-08-14.md` | FULL_TEXT_REREAD (lines 1–2695) | `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` |
| 118 | `dependent_system_optimization_geometry_demo.py` | FULL_CODE_REREAD (376 lines) | Python — banned; `formal/cubical/DSOCutCalibration.agda` |

**Index compression — entry 108 (Delta 26), verbatim core:**
> Role: foundational DSO formulation. Core: implementation fiber; optimize
> architecture/state/interface/solver/proof within fixed semantics; vertical
> versus horizontal stationarity; fiberwise optima may fail to glue;
> interface sufficiency and curvature are separate; scalarization can destroy
> the problem; option value/future liftability. Compression effect:
> formalizes semantic lock versus implementation freedom.

**Index compression — entry 114 (Delta 27), verbatim core:**
> Role: continuation-complete semantics and exact dependency type calculus
> precursor. Core: Bellman representation; min-plus factor rank;
> proof-relevant rank gap; quantale residuation; Isbell nucleus; saturation
> and nucleus-cover theorem; canonical completion versus minimal finite
> cover; behavioral Hankel/trellis calibration; contextual rank; semantic
> self-modification. Importance: one of the primary mathematical spines of
> the corpus.

**Relation-map edges** (`data/egb_library_index_v3/EGB_CORPUS_RELATION_MAP_V3.json`):
only `COMPANION_CODE` edges are recorded for this cluster — the two demo
`.py` files point at their Delta 27 / Delta 28 parents. No relation edge in
the map ties Delta 26/27 to the Myhill–Nerode cluster; that cross-lane
identity lives in the index prose and in Delta 28's own landing note, not in
the edge list. (Recorded so a successor does not expect a graph edge that is
not there.)

---

## 2. Reconstructed definitions Delta 28 relies on

Each definition is given first as the index preserves it (index-derived), then
pinned to the in-repo original section that states it exactly. Delta 28's own
uses are cited by section.

### 2.1 Continuation transformer (Delta 26)

- **Index-derived gloss:** "a subsystem is its continuation transformer"
  (Delta 28 §0 Executive leap restates this as Delta 26's thesis).
- **Original definition** — `DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md` §0,
  attributing it to Delta 26: an open costed subsystem is a kernel
  `K : A × B → ℝ̄` acting on futures by the Bellman map

  `𝓑_K(V)(a) = inf_b ( K(a,b) + V(b) )`.

  Full abstraction (Delta 27 §4): `ℝ̄^{A×B} ≅ Hom_{𝕋-Sup}(ℝ̄^B, ℝ̄^A)` and
  `𝓑_{L⋆K} = 𝓑_K ∘ 𝓑_L`. The subsystem is *identified with* its action on
  every future value V — that identification is the content of "a subsystem
  is its continuation transformer."
- **Delta 28 use:** §0, §7–9 (hidden-feedback closure `T_eff = A ⊕ P D* Q`
  is this transformer with a Kleene-star trace), §14–16.
- **Checked foothold:** `formal/cubical/NaturalMachine/DSOContinuationFullAbstract.agda`
  (finite Dirac reconstruction / full abstraction), `DSOMinPlusFinite.agda`
  (min-plus matrix composition + Bellman functoriality).

### 2.2 Factor rank = minimum exact width (Delta 27)

- **Index-derived gloss:** "min-plus factor rank" as the exact dependency
  width (entry 114 core; Delta 27 executive leap: `rank_{min+}(K)` = smallest
  number of exact latent dependency modes).
- **Original definition** — `DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md` §6:

  `rank_{min+}(K) = min { |B| : K = L ⋆ M }`
  `             = least r such that K(a,c) = min_{1≤i≤r} ( x_i(a) + y_i(c) ).`

  This is the minimum cardinality of an exact latent interface — a
  semantics-level lower bound on architecture width. Supporting theorems:
  gauge invariance (§8), rank-one additive-minor identity (§9),
  `tropicalRank(K) ≤ factorRank_{min+}(K)` (§9), Boolean specialization =
  minimum true-rectangle cover (§10).
- **Delta 28 use:** the width chain in §12–22, especially
  `factorRank(K_e) ≤ #ProjectiveContinuationClasses(e) ≤ #RawSeparatorAssignments(e)`
  (§0/§67) and `w_lat(e) = log₂ rank_{min+}(K_e)` (§20).
- **Checked foothold:** `formal/cubical/NaturalMachine/DSOFactorRankFinite.agda`
  (one latent mode forcing an additive-minor obstruction; explicitly no
  imported tropical-rank claim).

### 2.3 Isbell nucleus = canonical completion (Delta 27)

- **Index-derived gloss:** "Isbell nucleus; saturation and nucleus-cover
  theorem; canonical completion versus minimal finite cover" (entry 114).
- **Original definition** — `DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md`
  §20–21. For finite real-valued K, the conjugates

  `K↑x(c) = sup_a ( K(a,c) − x(a) )`,  `K↓y(a) = sup_c ( K(a,c) − y(c) )`

  form an antitone Galois connection, and

  `Nuc(K) = { (x,y) : y = K↑x, x = K↓y }`  ( = Isbell hull `Isb(K)` ).

  Nucleus-cover theorem (§24): `rank_{min+}(K) = min { r : K = min_{i≤r}(x_i+y_i),
  (x_i,y_i) ∈ Nuc(K) }` — every nucleus cover is a factorization and vice
  versa. Mature specializations (§26): Boolean → formal concept lattice;
  poset → Dedekind–MacNeille; Lawvere metric → tight span; dual pairing →
  Legendre–Fenchel.
- **Delta 28 use:** §31–32 (`Nuc(K_e)` at a cut: saturated dual pairs, minimum
  nucleus cover = smallest exact latent interface), and the §64 deep
  compression ("the Isbell nucleus completes all saturated latent cut
  concepts").
- **Checked foothold:** `formal/cubical/NaturalMachine/DSONucleusFinite.agda`
  (one saturated rank-one mode; explicitly does not claim general Isbell
  completion).

### 2.4 costRank ≤ witnessRank (proof-relevant rank gap, Delta 27)

- **Index-derived gloss:** "proof-relevant rank gap" (entry 114 core).
- **Original definition** — `DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md`
  §16–17. For an implementation-valued relation `𝐊 : A × C → 𝓤` with witness
  costs, scalar decategorification is `K(a,c) = inf_{w:𝐊(a,c)} cost(w)`. A
  witness-preserving factorization has width `wrank(𝐊)`, and

  `rank_{min+}(K) ≤ wrank(𝐊)`   (Delta 27 §16).

  In Delta 28's naming, **costRank = rank_{min+}(K)** (scalar min-plus factor
  rank) and **witnessRank = wrank(𝐊)** (proof-relevant width). Strictness is
  **proved**, not measured: Delta 27 §17 takes `𝐊(0,0)=𝐊(1,1)=S¹`,
  `𝐊(0,1)=𝐊(1,0)=𝟙` at cost 0. The scalar matrix is constantly 0 (min-plus
  rank one), but a rank-one witness factorization would make the
  Euler-characteristic matrix `[[0,1],[1,0]]` an outer product, and that
  matrix has determinant −1. Hence witness rank > scalar rank strictly.
- **Delta 28 use:** §51–61 — "proof-relevant width can exceed scalar width
  (Delta 27: costRank ≤ witnessRank, strict possible)"; ledger §63 line
  "proof-relevant width ≥ scalar width."
- **Checked foothold:** none dedicated yet. Delta 27's "Checked footholds"
  ledger lists the scalar side (`DSOMinPlusFinite`, `DSOFactorRankFinite`);
  the categorified witness gap is not yet a landed Agda term. Flagged as an
  open `PROVE` seed (the Euler-characteristic determinant argument is a
  page and formalizable).

---

## 3. Cross-reference merges: DSO ≡ FutureBehavior / Myhill–Nerode kernel

The index's own finding, echoed in Delta 28's landing note point 3: **DSO's
projective continuation quotient is the min-plus form of the corpus's
future-behavior (Myhill–Nerode) kernel.** The merges, all already carrying
in-repo objects:

| DSO object (Delta 27/28) | Corpus object it equals | In-repo module |
|---|---|---|
| Projective continuation quotient `Z_e = X_{S_e}/∼`, Thm 28.6 (Delta 28 §14–16) | Future-behavior quotient / weighted Myhill–Nerode kernel | `formal/cubical/NaturalMachine/FutureBehavior.agda` (self-described as "the corpus's one central construction (Myhill–Nerode / sufficient statistic / observability)") |
| Behavioral Hankel matrix `H_f(u,v)=f(uv)`, factor rank = state-complexity lower bound (Delta 27 §32–33) | Behavioral Hankel rank / causal states | `formal/cubical/NaturalMachine/BehavioralHankel.agda`; index entry 095 (`PRIME_PAIR_BEHAVIORAL_IDENTITY_DELTA_20`) |
| Deterministic exact interface `d_e = |Z_e|` = "weighted Myhill–Nerode" (Delta 28 §16–19) | Myhill–Nerode minimization / minimal fully abstract machine | `formal/cubical/NaturalMachine/SensorNerode.agda`; Lean `MyhillNerodeAdapter.lean`, `NerodeChartAdapter.lean` |
| Boolean nucleus = formal concept lattice (Delta 27 §26–27) | task-relative behavioral identity | index entries 053 (`COORDINATION_THEOREMS_XLI`), 095 |

This is a **cross-lane identity of the `TAXONOMY_OF_CROSS_LANE_IDENTITY`
"common quotient" type** (Delta 28 landing note), not a coincidence: the same
"quotient by future-indistinguishability" object appears once with a Boolean
carrier (Myhill–Nerode) and once with a min-plus scalar gauge (DSO projective
continuation). The three objects Delta 27 §33 keeps distinct — behavioral
quotient, Hankel/Boolean rank, concept nucleus — are exactly costRank's
deterministic / latent / canonical layers, so the merge is a refinement, not a
collapse (Delta 28 §16–19 warns against collapsing them).

**Consequence:** Delta 28's §14–16 projective quotient references now resolve
onto `FutureBehavior.agda`, and its width hierarchy `r_e ≤ d_e ≤ |X_{S_e}|`
(Thm 28.7) has its middle term `d_e` grounded in the checked Nerode modules.

---

## 4. Rigor boundary

- **§1 (index preservation):** navigation-grade. Index-derived, second-pass
  GPT-5.6 compression; upgrades nothing.
- **§2 (definitions):** the definitions are quoted from the **in-repo
  originals** (`DEPENDENT_SYSTEM_OPTIMIZATION.md`,
  `DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md`), which are the authoritative
  texts — so these resolve at the originals' grade, not merely index-grade.
  Where I say "index-derived gloss," that line alone is navigation.
- **§2.4:** the `costRank ≤ witnessRank` inequality and its strict example are
  proved in the Delta 27 text (Euler-characteristic determinant), but the
  witness side is **not yet a checked Agda term** — treat the strictness as
  paper-proved, not kernel-checked.
- **§3 (merges):** the identity DSO-quotient ≡ FutureBehavior is asserted by
  the index and by Delta 28's landing note. The in-repo modules named are real
  and checked (`--safe`), but **no proof that the DSO projective quotient
  equals the `FutureBehavior` quotient has been formalized** — the merge is a
  navigation claim pending a checked bridge lemma.
- **Upstream still owed:** the three *original* upstream filenames the index
  names (`…GREAT_LEAP_DELTA_26…`, `…NUCLEUS_DELTA_27…`, `…GEOMETRY_DELTA_28…`)
  are the external-library artifacts. Our in-repo notes are landings of the
  same material; if byte-exact provenance against the external library is ever
  required, those texts still need an upstream request. For resolving Delta
  28's internal references, the in-repo notes suffice.

---

## FILES

- `notes/DSO_DELTAS_26_27_FROM_INDEX.md` — this file (created).
- Read: `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md`,
  `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md` (Delta 27 original,
  945/904 lines), `notes/DEPENDENT_SYSTEM_OPTIMIZATION.md` (Delta 26
  original), `notes/EGB_LIBRARY_INDEX_V3.md` (entries 108/114/117),
  `data/egb_library_index_v3/{EGB_CORPUS_RELATION_MAP_V3.json,
  EGB_CORPUS_REREAD_AUDIT_V3.json}`.
- In-repo footholds cited (all present, `--safe`):
  `formal/cubical/NaturalMachine/{DSOMinPlusFinite,DSOContinuationFullAbstract,
  DSOFactorRankFinite,DSONucleusFinite,BehavioralHankel,FutureBehavior,
  SensorNerode}.agda`, `formal/cubical/DSOCutCalibration.agda`,
  `formal/pairfield/Pairfield/{MyhillNerodeAdapter,NerodeChartAdapter}.lean`.

## STATUS

- Delta 28's four references (continuation transformer, factorRank, Isbell
  nucleus, costRank ≤ witnessRank) now resolve in-repo — §2 pins each to an
  original definition + a checked Agda foothold (except the witnessRank side,
  §2.4).
- The standing `SEARCH` item (recover Deltas 26–27) is **effectively closed by
  discovery**: the full originals are already landed in `notes/`. Delta 28's
  landing note claiming their absence is stale and should be annotated.
- FutureBehavior/Myhill–Nerode merges catalogued (§3).

## RISKS

- **Stale premise:** the build objective and Delta 28's landing note both
  assume 26/27 are absent from `notes/`; they are present. If a successor acts
  on the stale note it may redundantly re-request upstream. Recommend adding a
  one-line pointer in `DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` §1 to the two
  files (not done here — shared checkout, no commit).
- **Unformalized merge:** §3's "DSO quotient = FutureBehavior quotient" is
  navigation-grade; a checked bridge lemma does not exist. Do not cite it as a
  theorem.
- **witnessRank not kernel-checked:** §2.4 strictness is paper-proved only.
  `PROVE` seed: formalize the S¹ Euler-characteristic determinant example.
- **Python demos unusable:** index entries 115/118 are `.py` (banned); their
  content is superseded by the Agda footholds, which cover a strict subset —
  do not assume every demo check has an Agda counterpart (e.g. peak-table
  sizing is explicitly not yet in Agda, per Delta 28 §62 note).
