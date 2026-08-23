# The Open-Problem Attack Queue — a ranked target list for this machine

**What this is.** A ranked, tagged catalogue of open mathematical problems, built
as a *work queue* for this repository's toolkit (exact/exhaustive computation,
SAT/SMT, formalization in Agda/Lean, bound-improvement, counterexample search),
not as an encyclopedia. The point is not RH — those are capstone, deferred by
plan — but the large body of **genuinely open problems people care about that a
real tool can move the needle on**, of the kind being resolved weekly (the Erdős
problems especially: 1217 catalogued, ~652 still open, actively falling to
automated methods).

**The honest boundary this repo enforces.** A "solution" here means a
kernel-checked proof or an exhaustive/certified computation — never a plausible
narrative. Capstone problems (RH, Goldbach, P vs NP) are held as honest holes
(`formal/cubical/AsiddhaCatustayam_…agda`) precisely because a kernel cannot be
flattered; we do not counterfeit them. This queue targets the tractable tier.

**Composition.** ~300 major named conjectures (hand-listed below, all fields) +
the Erdős open bloc (~652, referenced to the database by number) + other curated
collections → the ~1024 target. This file is a living queue: expand the Erdős and
"other" blocs by ingesting the databases named in §Sources.

---

## ATTACK-VECTOR LEGEND (the column that makes this a queue, not a list)

- **[EXH]** — finite/exhaustive verification or a bounded search settles a case
  or the whole thing (small parameters, extremal configs). Our `Pratyahara`/graded
  solver, Dedekind/Ramsey-style enumeration.
- **[SAT]** — encodable to SAT/SMT/constraint solving (colourings, packings,
  Ramsey/van der Waerden bounds, tilings). Certificate-producing.
- **[BND]** — improve an explicit constant/exponent by a computer-assisted or
  analytic argument (flag algebra, LP/SDP bounds, interval arithmetic).
- **[SRCH]** — hunt a counterexample / a new record instance (perfect cuboid,
  Barker sequence, Seifert-fibered exotica); disproving is winning.
- **[FORM]** — a *known* result not yet formalized; or an open problem whose
  reduction we can check. Erdős-problem formalization is an active lane.
- **[NEW]** — needs a genuinely new idea; capstone or structural. Deferred /
  study-only for now.

Sort the queue by vector to pick what to attack *this session*: [EXH],[SAT],[BND],
[SRCH],[FORM] are actionable now; [NEW] waits for the next stage of plan.

---

## TIER 0 — CAPSTONE (deferred by plan; held as honest holes)

1. Riemann hypothesis **[NEW]** · 2. P vs NP **[NEW]** · 3. Goldbach (strong &
weak-solved) **[NEW]** · 4. Twin primes / Polignac **[NEW]** · 5. Birch–Swinnerton-Dyer **[NEW]** ·
6. Hodge conjecture **[NEW]** · 7. Navier–Stokes existence & smoothness **[NEW]** ·
8. Yang–Mills mass gap **[NEW]** · 9. Collatz **[NEW/EXH-partial]** · 10. abc
(claimed, disputed) **[NEW]** · 11. Langlands program **[NEW]** ·
12–20. Hilbert's still-open (8=RH, 12, 16 second part) and Smale's problems (14
Lorenz-done; 6, 8, others open) **[NEW]**.

---

## TIER 1 — MAJOR NAMED CONJECTURES, by field (the "important, people-care" body)

### Number theory
- abc conjecture (effective forms) **[NEW]** · Szpiro **[NEW]** · Vojta **[NEW]**
- Landau's four (Goldbach, twin, Legendre n²<p<(n+1)², n²+1 primes) **[NEW]**
- Cramér, Firoozbakht (prime gaps) **[BND/SRCH]** · Grimm's conjecture **[EXH]**
- Bunyakovsky, Schinzel's Hypothesis H, Dickson **[NEW]**
- Bateman–Horn (density predictions) **[BND]**
- Lehmer's totient problem (φ(n)∣n−1 ⟹ prime?) **[EXH/SRCH]**
- Carmichael's totient conjecture **[SRCH]** · Sierpiński/Riesel numbers (smallest?) **[SRCH/SAT]**
- Perfect number: odd perfect number existence **[SRCH]** · quasiperfect, multiperfect **[SRCH]**
- Erdős–Straus (4/n = 1/x+1/y+1/z) **[EXH/SRCH]** · Erdős–Moser **[EXH]**
- Catalan–Dickson / aliquot sequences bounded? **[EXH/SRCH]**
- Singmaster's conjecture (multiplicity in Pascal) **[EXH/BND]**
- Brocard's problem (n!+1=m²) **[SRCH]** · Pillai's conjecture **[NEW]**
- Fermat quotient, Wall–Sun–Sun prime, Wieferich infinitude **[SRCH]**
- Mersenne: infinitely many? Are there infinitely many composite Mersenne? **[SRCH]**
- Fibonacci/Wolstenholme/Wilson prime infinitude **[SRCH]**
- Gilbreath's conjecture **[EXH]** · Feit–Thompson (2 primes) **[EXH]**
- Lonely runner (number-theoretic form) **[EXH/BND]** · Casas-Alvero **[EXH/NEW]**
- Uniform boundedness (rational points, genus ≥2) **[NEW]**
- Lehmer's conjecture (Mahler measure gap) **[BND/SRCH]**
- Sato–Tate refinements, Chowla, Elliott–Halberstam **[NEW]**
- Class number problems (Gauss, infinitely many real quadratic h=1) **[NEW]**
- Leopoldt's conjecture, Greenberg's conjectures (Iwasawa) **[NEW]**

### Combinatorics & extremal set theory
- Frankl union-closed sets (∃ element in ≥½) **[EXH/BND]** *(recently 38.2% proven)*
- Sunflower conjecture (Erdős–Ko–Rado family bounds) **[BND]**
- 1/3–2/3 conjecture (posets) **[EXH/BND]**
- Ramsey numbers R(5,5), R(6,6), diagonal growth **[SAT/BND]**
- Van der Waerden numbers W(r,k) **[SAT]** · Hales–Jewett bounds **[BND]**
- Dedekind numbers M(n), n≥10 **[EXH]** *(M(9) computed 2023)*
- Property B: smallest non-2-colourable n-uniform (n≥5) **[SAT]**
- Rudin's conjecture (squares in AP) **[EXH/BND]** · No-three-in-line **[EXH/SAT]**
- Cap sets / capset growth (three-term-AP-free in F_3^n) **[BND]**
- Kronecker coefficients (positive combinatorial rule) **[NEW]**
- Superpermutation minimal length **[EXH/SRCH]**
- Lonely runner conjecture (view distance) **[BND/EXH]**
- Sidon set / B_h[g] growth, perfect difference families **[SRCH/BND]**

### Graph theory
- Hadwiger conjecture (K_t minor ⟹ (t−1)-colourable) **[NEW/BND]**
- Erdős–Faber–Lovász (recently proven for large n) **[FORM]**
- Ryser–Brualdi–Stein (Latin square transversals) **[EXH/BND]**
- Reconstruction conjecture (Ulam) **[EXH]**
- Total colouring conjecture **[BND/SAT]** · List-colouring conjecture **[BND]**
- Cycle double cover **[NEW/EXH]** · Berge–Fulkerson **[NEW]**
- Tutte's 5-flow, 3-flow, Barnette's conjecture **[EXH/NEW]**
- Seymour's second neighbourhood **[EXH/BND]**
- Graceful tree / Ringel–Kotzig **[EXH/SAT]** · Harmonious labelling **[SAT]**
- Erdős–Gyárfás (2-power cycle) **[EXH]** · Caccetta–Häggkvist **[BND]**
- Crossing number of K_{m,n} (Zarankiewicz) **[BND/EXH]**
- Hedetniemi (disproven 2019 — model for how these fall) **[done]**
- Graham–Pollak, Gyárfás–Sumner (χ-boundedness) **[NEW/BND]**

### Discrete & combinatorial geometry
- Hadwiger–Nelson (chromatic number of the plane; 5≤χ≤7 after 2018) **[SAT/SRCH]**
- Borsuk's problem (partition into smaller-diameter pieces) **[SRCH/BND]**
- Kissing numbers in dims ∉{1,2,3,4,8,24} **[SDP/BND]**
- Sphere packing in dims ∉{1,2,3,8,24} **[BND/SDP]**
- Kobon triangles, orchard-planting, Heilbronn triangle **[EXH/SRCH]**
- Einstein/aperiodic monotile refinements (hat/spectre follow-ups) **[SRCH]**
- Happy ending (convex position ES(n)=2^{n−2}+1?) **[EXH/SAT]**
- Dirac–Motzkin (ordinary lines) **[BND]** · Unit-distance graph max edges **[BND]**
- Moser's worm, Bellman's lost-in-a-forest, Moving sofa (bound 2.2195… vs Gerver) **[BND/SRCH]**
- Reinhardt's smoothed octagon (worst packing) **[BND]** · Ulam packing **[NEW]**
- Inscribed square (Toeplitz) — open for general Jordan curves **[NEW]**
- Kakeya (finite-field solved; Euclidean dimension recently advanced) **[NEW]**

### Algebra, groups, representation theory
- Jacobson radical / Köthe conjecture **[NEW]** · Kaplansky (units, idempotents, zero-divisors — the last recently disproven) **[SRCH/NEW]**
- Andrews–Curtis (balanced presentations of trivial group) **[EXH/SAT]** *(prime AI-search target)*
- Burnside-type: finite? for finitely-presented periodic groups **[NEW]**
- Inverse Galois problem (every finite group over ℚ) **[EXH/NEW]**
- McKay, Alperin, Dade, Brauer height-zero (local–global counting) **[FORM/NEW]**
- Zauner (SIC-POVMs exist in all dims) **[EXH/SRCH/BND]** *(numeric to 100s of dims)*
- Hadamard matrix existence (all 4n) **[SRCH/SAT]** · Williamson, Barker (≤13?) **[EXH/SRCH]**
- Crouzeix's conjecture (‖p(A)‖≤2‖p‖) **[BND]** *(2 is the target constant)*
- Rota's basis conjecture **[EXH]** · Birkhoff–von Neumann variants **[EXH]**

### Analysis, operator theory, dynamics
- Invariant subspace problem (Hilbert space case) **[NEW]**
- Connes embedding (refuted 2020 via MIP*=RE — model for surprise) **[done]**
- Crouzeix (above), Brennan, Sendov (recently proven for large degree) **[BND]**
- Lehmer (Mahler measure), Schinzel–Zassenhaus (proven 2019) **[BND]**
- Collatz (and juggler, 3n+1 generalizations) **[EXH-partial]**
- Mandelbrot local connectivity (MLC), density of hyperbolicity (Fatou) **[NEW]**
- Arnold, Weinstein, Birkhoff billiards (integrable ⟹ elliptic) **[NEW]**
- Quantum unique ergodicity, Berry–Tabor **[NEW]**
- Palis conjecture, Furstenberg ×2×3 **[NEW]**

### Topology & geometric topology
- Smooth 4D Poincaré (SPC4) **[NEW]** · Slice–ribbon **[SRCH]**
- Unknotting/knot problems: is the (2, n) … ; Volume conjecture **[NEW]**
- Novikov, Borel, Farrell–Jones (assembly maps) **[NEW]**
- Zeeman collapsibility, Andrews–Curtis (topological form) **[EXH/SAT]**
- Section conjecture (anabelian) **[NEW]** · Hopf (curvature × Euler char) **[NEW]**

### Set theory, logic, model theory
- Definable / PD consequences; Woodin's Ultimate-L program **[NEW]**
- Whitehead problem in specific models, Vaught's conjecture **[NEW/FORM]**
- P=BPP, and derandomization; NEXP vs ACC (partial) **[NEW]**
- Singular cardinals / PCF open cases **[NEW]**

### Theoretical computer science
- P vs NP and the polynomial hierarchy **[NEW]**
- P vs BPP, P vs PSPACE, L vs P, NC vs P **[NEW]**
- Unique games conjecture **[NEW/SAT-adjacent]**
- Exponential-time hypothesis refinements **[NEW]**
- Graph isomorphism in P? (quasipoly known) **[NEW]**
- Matrix multiplication exponent ω→2? **[BND]** *(computer-searched tensor bounds)*
- Sunflower/lower-bound circuit problems **[BND]**
- AKS-style / deterministic primality-adjacent constants **[BND]**

### Probability & mathematical physics
- 2D/3D Ising, φ⁴, self-avoiding walk connective constant **[BND]**
- KPZ universality open cases, ABC/six-vertex exponents **[NEW/BND]**
- Percolation p_c exact values (e.g. 3D) **[BND/SRCH]**

---

## TIER 2 — THE ERDŐS OPEN BLOC (~652 open of 1217; the weekly-attackable body)

The canonical source is **erdosproblems.com** (Thomas Bloom, 2023), each problem
numbered with status, references, and often a monetary Erdős bounty. This is the
single richest vein of *tractable, cared-about, currently-open* problems, and the
one AI methods are actively resolving. **To populate the queue: ingest the
open-status entries (~652) by number.** Curated high-value / high-tractability
starters (Erdős-problem numbers vary by DB revision — verify at ingest):

- Unit-fraction / Egyptian-fraction density and covering problems **[EXH/SRCH]**
- Covering systems: minimum modulus (Hough 2015 bounded it), odd covering **[EXH/SAT]**
- Sidon sets, B_h[g] sets, additive-basis growth **[SRCH/BND]**
- Distinct distances refinements (Guth–Katz did the main one) **[BND]**
- Ramsey/van der Waerden small-case values and bounds **[SAT]**
- Multiplicative/additive energy extremal configs **[BND]**
- Discrepancy problems (Erdős discrepancy solved by Tao 2015 — the template) **[FORM/BND]**
- Combinatorial-geometry point-configuration extrema **[EXH/SAT]**
- Sum-product exponents (improve the current best) **[BND]**

*Formalization angle:* the Xena project is formalizing Erdős problems in Lean — a
ready-made **[FORM]** pipeline where stating + checking is itself progress.

---

## TIER 3 — OTHER CURATED COLLECTIONS (ingest to grow toward 1024)

- **Open Problem Garden** (openproblemgarden.org) — ~hundreds, tagged by field,
  with importance/difficulty ratings already attached. Direct ingest.
- **OEIS** "unsolved"/conjectural sequences (Dedekind, Ramsey, van der Waerden,
  Sidon) — each an [EXH]/[SAT] compute target with a definite next value.
- **Smale's 18 problems**, **DARPA 23 math challenges**, **Guy's *Unsolved
  Problems in Number Theory*** (hundreds), **Klee–Wagon** geometry, **Brass–Moser–
  Pach** discrete geometry — classic curated books, each an ingest source.
- **Polymath** open threads — collaboratively-vetted tractable targets.
- **Competition-origin conjectures** (Putnam/IMO shortlist generalizations that
  went open) — small, often [EXH].

---

## THE ATTACK-NOW SHORTLIST (sorted by our actual leverage)

The subset we can start on *without new ideas*, ranked by tractability × interest:

1. **[EXH/SAT] Ramsey / van der Waerden / Dedekind next values** — definite
   answers, certificate-producing, cared-about, OEIS-anchored.
2. **[SAT] Andrews–Curtis balanced-presentation search** — a famous group-theory
   target where automated search is the state of the art.
3. **[EXH] Frankl union-closed** — improve the fraction, or settle small families.
4. **[SRCH] Perfect cuboid / Barker>13 / odd perfect lower bounds** — record
   searches where a hit *is* a resolution.
5. **[SAT] Hadwiger–Nelson** — narrow 5≤χ(plane)≤7 with SAT on unit-distance graphs.
6. **[BND] Crouzeix (→2), moving sofa, sum-product exponents** — push an explicit
   constant with LP/SDP/interval methods.
7. **[FORM] Erdős-problem Lean formalizations** — stating + checking as progress,
   plugged into the Xena pipeline.
8. **[EXH] Graded/full pratyāhāra optimality** — our own solver, already started
   (`machine/PratyaharaSamskaraGraded_…hs` solved the non-tight family).

Pick from vectors [EXH],[SAT],[BND],[SRCH],[FORM]; leave [NEW] for the next stage.

---

## SOURCES
- Wikipedia, *List of unsolved problems in mathematics*
  (https://en.wikipedia.org/wiki/List_of_unsolved_problems_in_mathematics)
- *Erdős Problems* database, Thomas Bloom (https://www.erdosproblems.com/) — 1217
  problems, ~652 open.
- *Why the Legendary Erdős Problems Are Falling to AI*, Quanta, 2026-08-03
  (https://www.quantamagazine.org/why-the-legendary-erdos-problems-are-falling-to-ai-20260803/)
- *Semi-Autonomous Mathematics Discovery with Gemini: the Erdős Problems*
  (https://arxiv.org/html/2601.22401v3); *Early science acceleration with GPT-5*
  (https://arxiv.org/pdf/2511.16072).
- Xena Project, *Formalization of Erdős problems*, 2025-12-05.
- Open Problem Garden (openproblemgarden.org); OEIS; Smale's problems; Guy,
  *Unsolved Problems in Number Theory*.

*Living file: expand Tier 2/3 by ingesting the databases above; re-rank as
problems fall. Every claimed resolution goes through the kernel — checked proof or
certified computation — or it does not count.*
