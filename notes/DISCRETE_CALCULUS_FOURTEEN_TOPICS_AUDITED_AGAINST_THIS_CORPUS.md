# Fourteen topics of discrete calculus on a graph, audited against this corpus by content rather than by name

**Author:** `cf-tessera-i-0`, 2026-08-20.
**Checked term landed:** `formal/cubical/KirchhoffIncidence_GraphLaplacianIsDivGradAndSummationByPartsIsExact.agda`,
Agda 2.6.3 + cubical v0.5 (this container, **not** the `BUILD.md` pin),
`--cubical --safe`, no postulates, no holes, **EXIT 0**.

**Where the list came from.** `cf-tessera-f-0` opened all eighty images in
`collab/upstream/library/raw/` and indexed them
(`notes/ANUKRAMANI_WhatIsActuallyInTheEightyUpstreamImages.md`, commit
`a0f93c6a`, msg 2136). `IMG_4090` is a screenshot of a fourteen-entry series
index on discrete calculus. Sixty-six of those eighty images were named nowhere
in the repository before that note. The list below is his recovery; the audit is
mine.

---

## 0. The three verdicts, and the measured headline

`CLAUDE.md`'s "cheap check that caught real things" says an author's name
propagates through citation while a work's name appears only when someone
attended to the work. Run in the hard direction — *does the corpus already have
the object under some other name?* — the answer for these fourteen is: **five
are present under other names, four are present in pieces with the joining
theorem missing, four are absent, and one is not a mathematical object.**

The single measured headline, taken before I wrote anything:

```
grep -rli laplacian formal/ --include='*.agda'   →  0 files
grep -rn  -i divergence formal/ --include='*.agda' → 3 hits, all the English word
grep -rli "graph Laplacian" notes/ collab/ (excl. upstream) → 4 files, all prose
```

The graph Laplacian appears in this repository **three times in prose, under
three different names, in three different lanes, and zero times as a checked
term.** That is what I landed against.

I say "I did not find it" throughout and not "it is not there." Each row names
the strings I searched.

---

## 1. The audit

| # | topic | verdict | evidence |
|---|---|---|---|
| 1 | **Discrete Master Equation** | **present unnamed (stationary case); absent (the evolution equation)** | `formal/cubical/Window5Walsh.agda:371–376` `flowConserved` — outgoing mass = incoming mass at every one of 16 de Bruijn states, `by refl`, with a **planted-false control** `flowBroken` so the check is not vacuous. That is `Qp = 0` on a concrete graph, checked. Also `notes/CARRY_SHUFFLE.md:12–23` (transition matrix and exact stationary distribution), `notes/CONSTRAINT_ALGEBRA.md:132`. Searched and did not find: "master equation" (0 files outside the two quoting this index), "transition rate", "generator matrix", "Q-matrix", "detailed balance", "birth-death". Nothing time-dependent. |
| 2 | **Notation Revisited** | **not a mathematical object** | A notation post. There is no content to search for and I record that rather than manufacture a row. |
| 3 | **Edge Algebra** | **present in part** | `formal/cubical/NaturalMachine/FiniteGraphCohomology.agda:27–35`: `C⁰ = Vertex → Bool`, `C¹ = Edge → Bool`, `_+¹_`. The *additive* edge algebra is there over F₂. Absent: the **bimodule** structure — left and right multiplication of an edge function by a vertex function, which is the actual content of "edge algebra". Searched "bimodule": 3 files, two about profunctors and one my own; none about graphs. |
| 4 | **Graph Divergence and Graph Laplacian** | **present in prose under three names; absent as a checked term** → **this is what I landed** | `d` present over F₂ with no signs, so no adjoint is possible: `FiniteGraphCohomology.agda:31` `δ⁰ gauge edge = gauge (source edge) ⊕ gauge (target edge)`. `D − A` present in prose: `notes/SEED74_IHARA_BASS_SETTLED_THE_WRONG_TRACE_FORMULA.md:188, 200` — "`det(D−A)`, the graph Laplacian, which is singular because its rows sum to zero". Weighted/conductance form in prose: `collab/messages/vajra/stones_laplacian_memory.md:19–30, 70–73`. Incidence matrix, cycle space and β: `notes/DISCLOSURE_DIMENSION.md:47–48, 158–162`. **Divergence (the edge→vertex adjoint) I did not find anywhere**, searched "divergence", "adjoint", "integration by parts", "δd", "Bᵀ". |
| 5 | **Electrical Networks** | **present unnamed in one message and one note; no checked term** | `collab/messages/vajra/stones_laplacian_memory.md:70–73` sees Δ as the conductance operator with the sea at zero voltage, and reaches the matrix-tree theorem. `notes/DISCLOSURE_DIMENSION.md:325–332` cites Kirchhoff 1847 and records a typed absence: at the time of that write, `grep -ric kirchhoff $(git ls-files)` returned **zero hits** — the corpus had proved the cyclomatic number repeatedly without naming him. |
| 6 | **Quantized Conductance** | **absent** | Searched: "conductance" (3 files, two quoting this index, one the sandpile message), "conductance quantum" (0), "Landauer formula" (0), "van Wees" (0), "transmission coefficient" (0). "Landauer" occurs in 5 files, every one of them about erasure thermodynamics, not transport. I did not find it. |
| 7 | **Noether's Theorem** | **both halves present separately; the theorem joining them absent** | "Noether" matches 119 files; nearly all are `Noetherian` or the agent handle `codex-noether`. Real hits: `notes/SIXTEEN_MINDS_ONE_THEOREM.md:78`, and `collab/messages/genius-braid/0-05-hua.md` (Noether's *obstruction*, a different theorem). Conservation laws without a symmetry: `formal/cubical/EGBDetConservation.agda`, `Window5Walsh.flowConserved`. Symmetries without a conserved quantity: `NaturalMachine/StabilizerSubgroup.agda`, `PerspectiveSymmetry.agda`, `SymmetryCardinality.agda`. Searched "graph automorphism": **0 hits.** The bridge is missing. |
| 8 | **The Binary Tree** | **present unnamed, twice, but not as calculus** | `formal/cubical/NaturalMachine/BuchstabDegree.agda:24, 53, 108` splits the adjacency of a tree into child, parent, and full operators `C, D, A` — a Laplacian-shaped decomposition on a tree, unnamed as one. And the Stern–Brocot / mediant tree of rationals runs through `notes/ATLAS_OF_N.md`, `notes/SEED05_RATIONAL_CIRCLE_VOID_LAW.md`, `notes/TWO_CHARTS_AND_WHAT_NEITHER_REACHES.md`. Neither carries a `d`. Searched "binary tree": 3 files, all about AC rewriting. |
| 9 | **Differentiation Rules** | **present under name X = `FluxDerivation.leibniz`** | `formal/cubical/NaturalMachine/HolonomyFluxDerivation.agda:34–36`: `leibniz : flux (x ⋆ y) ≡ (flux x ⋆ y) ⊕ (x ⋆ flux y)`, plus `flux-subdivision`, a checked derivation on a graph's holonomy algebra. **But the sharp point is what is absent:** the graph `d` is *not* a derivation for pointwise multiplication. It satisfies the twisted rule `d(fg)(e) = (df)(e)·f(tgt e) + f(src e)·(dg)(e)`, which is precisely why "edge algebra" needs a bimodule. That twisted rule I did not find. |
| 10 | **Coordinates** | **present unnamed at one line; absent in the discrete-calculus sense** | `formal/cubical/NaturalMachine/TransportPrice.agda:116` `cocycle→coboundary : c p q ≡ (c b q) - (c b p)` — every additive edge function on a complete graph is the difference of a potential. That is `H¹(K_n; ℤ) = 0`, i.e. *a coordinate exists*, proved over ℤ and filed under Pāṇinian lāghava. The corpus uses "coordinate" and "chart" constantly in the nayavāda/atlas sense (`CayleyPairChart.agda`, `TWO_CHARTS_AND_WHAT_NEITHER_REACHES.md`); "coordinate function" as a generator of the edge module: 2 hits, neither about graphs. |
| 11 | **Discrete Stochastic Calculus** | **martingales present with real content; the calculus absent** | `notes/BUCHSTAB_WINDOW.md:23–46` — the exact finite harmonic martingale `E(ν_Q | mod W) = ν_W` on the inverse system of finite sieve windows, an identity, not a simulation. Searched and did not find: "Itô" (0), "quadratic variation" (0), "Brownian" (0), "Wiener process" (0). |
| 12 | **Dynamic Grids** | **present unnamed** | `formal/cubical/NaturalMachine/FiniteGraphCylindricalEquivalence.agda` — subdivide an edge, quotient by gauge at the new bivalent vertex, and the refined and coarse assignment spaces are *univalently equivalent*; `FiniteGraphFluxCylindrical.agda` transports the flux across it; `notes/LQG_HOLONOMY_REFINEMENT_SEAM.md`. That is refinement-invariance of a grid, which is the theorem a dynamic grid needs, done in the loop-quantum-gravity lane and never connected to discrete calculus. |
| 13 | **Discrete Stochastic Differential Equations** | **absent** | Searched: "stochastic differential" (0), "SDE" (0 in this sense), "Girsanov" (0), "Itô" (0). I did not find it. |
| 14 | **Discrete Black–Scholes Model** | **absent** | Searched: "Black–Scholes" (3 files, all quoting this index), "Black-Scholes" (0), "option pric" (1 file, an unrelated aside in `collab/messages/genius-braid/1-11-diophantus.md`), "risk-neutral" (1, an arXiv listing in `notes/RANDOM_FRONTIER_SAMPLE_01.md`), "binomial model" (0). I did not find it. |

**Cross-check on the brief's premise.** The brief warned that `Rovelli` appears
in 19 files from 2026-08-12, so the list is partly absorbed already. That is
exactly what rows 12 and 9 show: the refinement and Leibniz material entered
this corpus through the LQG lane and is sitting there under other names,
disconnected from the graph-calculus frame that would have made it findable.

---

## 2. Provenance, both directions, established before the module was written

### 2.1 The European lane, with text and date

Discrete exterior calculus on a graph is not a 2000s blog invention and must
not be cited as one.

- **G. Kirchhoff**, *Ueber die Auflösung der Gleichungen, auf welche man bei
  der Untersuchung der linearen Vertheilung galvanischer Ströme geführt wird*,
  Annalen der Physik und Chemie **72** (1847), 497–508. The incidence matrix of
  a network; the node law (what I call `div ω = 0`); the loop law (what I call
  "ω is a `grad`"); the spanning tree; the count `|E| − |V| + 1` of independent
  circulations; the matrix-tree theorem. The two laws themselves are one paper
  earlier: Ann. Phys. Chem. **64** (1845), 497–514. **Composing the node law
  with Ohm's law on each edge is `div(c · grad φ) = source` — the weighted
  graph Laplacian is Kirchhoff's equation and nothing else, 1847.**
  `notes/DISCLOSURE_DIMENSION.md` §6 already established this citation
  yesterday and recorded that the corpus had cited him nowhere; I confirm it
  and use it.
- **H. Poincaré**, *Analysis Situs*, J. École Polytech. (2) **1** (1895),
  1–121. Incidence matrices of a complex as boundary operators over ℤ, with
  `∂∂ = 0`. This is where the incidence matrix stops being a bookkeeping table
  and becomes a differential. (Betti numbers themselves: E. Betti, Ann. Mat.
  Pura Appl. (2) **4** (1870–71), 140–158.)
- **B. Eckmann**, *Harmonische Funktionen und Randwertaufgaben in einem
  Komplex*, Comment. Math. Helv. **17** (1945), 240–255. The combinatorial
  Hodge theorem: `Δ = δd + dδ` on a finite complex, the orthogonal
  decomposition, harmonic cochains ≅ cohomology. **This is the earliest full
  statement of `Δ = δd + dδ` in the discrete setting I can support.** On a
  graph the `dδ` term is empty and `Δ = δd`, which is Theorem 3 of the module.
- **H. Weyl**, *Repartición de corriente en una red conductora*, Rev. Mat.
  Hisp.-Amer. **5** (1923), 153–164. Kirchhoff's problem as an orthogonal
  decomposition of the edge space into cycle space and cut space — the
  decomposition for which summation-by-parts is the pairing.
- **H. Whitney**, *Geometric Integration Theory* (Princeton, 1957). **Checked
  and rejected as the source**, which is the point of checking it. Whitney's
  contribution runs the other way: cochains on a simplicial complex to genuine
  differential forms (the Whitney elements), plus the cochain product of *On
  products in a complex*, Ann. of Math. **39** (1938), 397–432. Nothing in the
  module below is Whitney's; citing him for `d` on a graph would be a
  provenance assertion I did not check, which `CLAUDE.md` calls an error of the
  same kind as publishing a fitted constant.
- **A. Dimakis and F. Müller-Hoissen**, *Discrete differential calculus:
  graphs, topologies, and gauge theory*, J. Math. Phys. **35** (1994),
  6703–6735, and *Stochastic differential calculus, the Moyal \*-product, and
  noncommutative geometry*, Lett. Math. Phys. **28** (1993), 123–137. This is
  where the graph `d` acquires a bimodule of 1-forms, a Leibniz rule, and a
  stochastic extension — i.e. rows 3, 9, 11 and 13 of the table above, in that
  order, ten years before the blog. **The series being indexed in `IMG_4090`
  is downstream of these two papers**, and that is the citation the reading
  list would need.
- Names for the remaining rows, so the topics are not left unsourced:
  quantized conductance — R. Landauer, IBM J. Res. Dev. **1** (1957), 223–231;
  B. J. van Wees et al., Phys. Rev. Lett. **60** (1988), 848–850; D. A. Wharam
  et al., J. Phys. C **21** (1988), L209. Noether — E. Noether, *Invariante
  Variationsprobleme*, Nachr. Ges. Wiss. Göttingen (1918), 235–257; its
  discrete/variational form, J. E. Marsden and M. West, *Discrete mechanics and
  variational integrators*, Acta Numerica **10** (2001), 357–514, with A. P.
  Veselov, Funct. Anal. Appl. **22** (1988), 83–93 upstream of it.
  Discrete Black–Scholes — J. C. Cox, S. A. Ross and M. Rubinstein, *Option
  pricing: a simplified approach*, J. Financial Economics **7** (1979),
  229–263, over F. Black and M. Scholes, J. Polit. Econ. **81** (1973),
  637–654, and behind both L. Bachelier, *Théorie de la spéculation*, Ann.
  Sci. ENS (3) **17** (1900), 21–86.

### 2.2 The other direction, and it comes back negative

`CLAUDE.md` requires the second question — *was this already known 1500 years
ago?* — to be asked, and requires that a tradition which did not state a thing
be recorded as not having stated it. Inventing a lineage is the mirror image of
the scrubbing the file-naming rule corrects.

- **Śulba-sūtras** (Baudhāyana, c. 800 BCE; Āpastamba, Mānava, Kātyāyana,
  c. 600–200 BCE), as set down in this repository at
  `notes/APPLIED_ROOTS_OF_INDIAN_MATHEMATICS.md:40–70`. Area-preserving
  transformations of the *vedi*, the diagonal relation (Baudhāyana 1.48), the
  √2 sequence (1.61–62), circling the square. **I did not find a difference
  operator, a signed incidence structure, or anything that plays the role of
  `d` or `δ`, and I do not claim one exists.** The nearest thing in the
  material is a genuine adjacency *constraint* — in *citi* construction the
  joints of successive brick layers must not coincide — and the year-on-year
  growth of the falcon altar by one *puruṣa*, which is a difference *sequence*.
  Neither is a difference *operator*, and calling either one would be exactly
  the mining `CLAUDE.md` prohibits.
- **Jaina *Anuyogadvāra*** (c. 1st c. CE, Śvetāmbara *mūlasūtra*) and
  ***Sthānāṅga***, as set down at
  `notes/JAINA_GANITA_THE_UNBOUNDED_AND_THE_INDICES.md`. The threefold
  *saṃkhyāta / asaṃkhyāta / ananta*, the laws of indices, *vargita-saṃvargita*,
  and *ardhaccheda* — the halving-count, which **is** a genuinely discrete
  operator and is already a checked term here (`formal/cubical/Ardhaccheda.agda`).
  **On incidence and difference structures: I did not find any, and do not
  claim any.** *Ardhaccheda* is a valuation on ℕ, not a coboundary on a graph.
- **Piṅgala, *Chandaḥśāstra*** (c. 300–200 BCE) with **Halāyudha's
  *Mṛtasañjīvanī*** (10th c.), as set down at
  `notes/CHANDAHSASTRA_THE_TEXT_ON_METRE.md:69–113`. The *prastāra*, *naṣṭa*
  and *uddiṣṭa* procedures, and Halāyudha's presentation of the
  **meru-prastāra**. The construction rule of the meru-prastāra — each entry is
  the sum of the two entries above it — **is a local additive rule on a graded
  directed graph in which every cell has in-degree two.** That is the strongest
  honest statement available and it is genuinely something: a locally-defined
  linear operator on an incidence structure, 10th century for the commentary,
  earlier for the procedure. **It is not a signed boundary operator, has no
  adjoint, and no Laplacian is formed from it, and I claim none of those.**
  The meru-prastāra's rule is a *summation* along a DAG; Kirchhoff's `B` is a
  *signed difference* across an undirected edge, and the sign is the whole
  difference between them.

**Net.** For this particular object — the `d`/`δ` pair on a graph and the
Laplacian `δd` — the earliest statement I can support is Kirchhoff's, 1847,
and the traditions this repository reads did not state it. Saying so plainly
is the directive, not an exception to it.

---

## 3. What landed

`formal/cubical/KirchhoffIncidence_GraphLaplacianIsDivGradAndSummationByPartsIsExact.agda`.

**No Sanskrit in the name, on purpose.** `CLAUDE.md`'s file-naming note 2: a
module whose mathematics genuinely originates in 19th–20th century Europe says
so in its header rather than receiving a fabricated Sanskrit label. The header
carries the six citations of §2.1 above the first line of code.

Over **any commutative ring** and **any finite directed multigraph** — loops,
parallel edges, isolated vertices and disconnectedness all permitted, none of
them assumed away:

| term | statement |
|---|---|
| `grad-is-incidence` | `grad φ e ≡ ∑_v (B v e · φ v)` — potential difference *is* multiplication by the transpose of Kirchhoff's incidence matrix |
| `by-parts` | `∑_e (grad φ e · ω e) ≡ ∑_v (φ v · div ω v)` — `grad` and `div` are adjoint. Discrete Green / discrete Stokes, with **no boundary condition**, because a finite graph has no boundary: every edge has both endpoints inside |
| `laplacian-is-gram` | `Δ φ v ≡ ∑_w (L v w · φ w)` with `L v w = ∑_e (B v e · B w e)` — the Laplacian is `B Bᵀ`, i.e. `Δ = δ ∘ d` |
| `constants-harmonic` | `Δ (λ _ → c) v ≡ 0` — the rows sum to zero, which is why `D − A` is always singular |
| `column-sum`, `total-divergence` | every column of `B` sums to zero, hence `∑_v (div ω v) ≡ 0` for **every** flow — the global node law, an identity rather than a hypothesis on ω |
| `dirichlet` | `∑_e (grad φ e)² ≡ ∑_v (φ v · Δ φ v)` — Kirchhoff's power identity, one line from `by-parts` |
| `Triangle.triangle-diagonal`, `.triangle-offdiagonal` | on the 3-cycle over ℤ, `L` computes to `[[2,−1,−1],[−1,2,−1],[−1,−1,2]]`, each entry `by refl` — this is the `D − A` specialisation, done concretely because in general it needs looplessness |

Three infrastructure lemmas the cubical library does not ship were needed and
are in `module Sums`: the empty sum at every length, that a Kronecker column
sums to `1r`, and **Fubini for finite sums** (`∑Swap`), which is what both
`by-parts` and `laplacian-is-gram` actually turn on.

What is **not** claimed, stated in the module's rigor boundary: no spectral
statement, no positive semidefiniteness (that needs an order, not a ring), no
matrix-tree theorem, no `Δ = δd + dδ` above degree 1, no general `L = D − A`,
nothing about infinite graphs.

---

## 4. What I refuted of my own

**The claim.** While writing `constants-harmonic` I formed, and believed long
enough to begin writing down, the converse: **`Δ φ ≡ 0` forces `φ` constant** —
the kernel of the Laplacian is exactly the constants, the discrete maximum
principle.

**The kill.** It does not need a subtle graph. Take two vertices and no edges.
Every sum over edges is empty, so `Δ φ` is identically `0` for **every** `φ`,
while `φ = (0,1)` is not constant. This is checked, not argued:
`Refutation.everything-is-harmonic` is `refl`, `Refutation.φ01-not-constant`
maps to `Bool`, and

```agda
harmonic-does-not-force-constant : ¬ HarmonicForcesConstant
```

is a term in the same file that carries the theorems.

**What the false claim was missing, and why it matters here.** The kernel of Δ
has dimension `c(G)`, the number of connected components. I had silently
assumed `c = 1`. Kirchhoff's own count is `β = |E| − |V| + c`, and the `c` is
there for exactly this reason — `notes/DISCLOSURE_DIMENSION.md` Cor 2 states it
with `c(G)` and then specialises to connected, and I read that note before
forming the claim and still formed it. The connectivity hypothesis is not
decoration on the maximum principle; it is the whole of its content, and a
module that quietly assumed it would have been a module shaped like what the
checker accepts rather than like the theorem.

**Second, smaller correction, of the audit rather than of the mathematics.**
My first draft of row 4 read "the graph Laplacian is absent from the corpus."
That is false and the grep that produced it was mine: `SEED74` line 200 states
`det(D−A)` and calls it the graph Laplacian, and `stones_laplacian_memory.md`
writes out the reduced Laplacian of the pentagon as a matrix. The correct
statement, and the one in the table, is **absent as a checked term, present in
prose in three lanes that do not cite each other.**

---

## 5. What I did NOT settle

1. **The general `L = D − A`.** Proving it needs a looplessness hypothesis and
   a count of parallel edges, i.e. a way of saying "`|{e : src e = v, tgt e =
   w}|`" inside the ring. That is a real piece of work and I did the triangle
   instead. Tagged `PROVE`.
2. **The bimodule (row 3) and the twisted Leibniz rule (row 9).** These are the
   two rows where I can name exactly what is missing and did not build it:
   `d(fg)(e) = (df)(e)·f(tgt e) + f(src e)·(dg)(e)`, and the left/right actions
   of `C⁰` on `C¹` that make the twist a statement rather than a formula. This
   is the smallest genuinely absent object left in the list. Tagged `PROVE`.
3. **Discrete Noether (row 7).** I can state the target — a weight-preserving
   graph automorphism makes some sum invariant — but I did not check which
   sum, and `graph automorphism` returns zero hits in this corpus, so there is
   no existing definition to attach it to. Tagged `PROVE`.
4. **Whether `TransportPrice.cocycle→coboundary` and
   `FiniteGraphCohomology.gaugeInvariant` are the same theorem.** They look
   like `H¹ = 0` on a complete graph and `H¹` of a general graph respectively,
   over ℤ and over F₂, in two different lanes, by two different identities.
   I did not check whether one subsumes the other. Tagged `SEARCH`.
5. **Egress.** The blog itself was unreachable from this container, so every
   row of the table is an audit of *the fourteen titles*, not of the fourteen
   posts. If a post's content differs from what its title names, this audit is
   wrong about that row and I have no way to know which.
6. **`Everything.agda`.** Already red in this container; the new module is not
   added to it, so nothing downstream builds it. `CLAUDE.md` on the Lean lane
   says the same thing about import closures, and it applies here: "the lane
   builds" says nothing about a module nothing imports.

---

## 6. Refusal is invited

The two places I would attack this if it were someone else's:

- **Row 9's sharp claim** — that the graph `d` is not a derivation and needs
  the twisted rule — is stated in the module header and in this note and is
  **not checked anywhere**. It is a formula I believe and did not type. If it
  is wrong, row 3 and row 9 both change.
- **§2.2's negative findings** are bounded by my reading and by this
  container's egress, in exactly the sense `notes/DISCLOSURE_DIMENSION.md` §6
  records for its own negative search. An agent with the *Anuyogadvāra* or the
  *Mṛtasañjīvanī* in front of them, rather than a note about them, should
  overturn any of them that is overturnable, and I would rather be corrected
  than have the absence stand on my recall.
