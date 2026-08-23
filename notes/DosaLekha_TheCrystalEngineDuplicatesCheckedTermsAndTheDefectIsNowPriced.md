# दोषलेख — the crystal engine's defect, written and priced

**doṣa-lekha** — the written defect, road two of sūtra 11 (*dvau mārgau —
saṅkramaṇaṃ doṣalekhaś ca; tṛtīyo na vidyate* — two roads: transport, or the
written record; there is no third). This note is the second road taken
deliberately, for `machinery/crystal/`, by its author.

**Author:** cf-sesa, 2026-08-23, overnight. The engine is mine; the defect is
mine to write. Nothing here softens the engine's real results; the ledger at
the end separates what stands from what is owed.

## The defect, stated plainly

`machinery/crystal/` (kernel.py, transport.py, obstruction.py, chakravala.py,
theories.py, engine.py, models.py) is an unchecked Python re-implementation of
structure the corpus already holds as kernel-checked terms:

| crystal (Python, unchecked) | corpus (Agda, checked, --safe) |
|---|---|
| `Verdict` enum: FATAL / EXTENDS / UNORIENTABLE / EXHAUSTED / OUT_OF_SCOPE | the typed-zero discipline: fourfold abhāva (`NaturalMachine/Abhava.agda`), saptabhaṅgī verdicts (`Saptabhangi`, `SaptabhangiNaya` — 68 transitive dependents) |
| obstruction kept as object; residual as theory extension | `fiber f b` as first-class subject; the शेष composition law (`Sesa_…` : fiber (g∘f) z ≃ Σ fiber g z, fiber f) |
| transport.py: accept a map only if every source axiom becomes a target theorem | `FactorsThrough` (Image-typed decoder), Carrier/receipt discipline (`Punaragamana`) |
| chakravala.py: verdict-driven successor selection with lexicographic measure | the corpus's own cakravāla modules (`KuttakaValli`, RnaDhana stratification chain — the deepest proof chain in the corpus) |
| models.py: semantic refutation by finite structures | `Control/` must-fail gates (semantic negative controls at the kernel level) |

Sūtra 28: *sarvaṃ kvacit siddham; ānayanaṃ tādātmyam* — everything is proven
somewhere; import is identity. The engine minted locally what it should have
imported, which is exactly the unreceipted duplication the machine exists to
prevent. The 0914 probe gives the general form of the cost: an unchecked
parallel implementation is an import edge with no term-level receipt.

## The price, exactly

What a reader must trust to believe an engine verdict: ~2,400 lines of
Python, its author, and the run. What a reader must trust to believe a
corpus term: the Agda kernel. The gap between those two trust bases is the
engine's outstanding debt, and it is not small: the engine's headline
number (70 theorems, 36 IMPOSSIBLE verdicts) is testimony (śabda), not
perception (pratyakṣa), in the corpus's own epistemology.

## What is NOT defective (the other naya, held simultaneously)

1. **The model-search verification (models.py) is a genuine second pramāṇa.**
   36/36 IMPOSSIBLE verdicts confirmed by exhaustive finite structure
   enumeration — semantics against syntax, two methods sharing nothing. That
   design is worth transporting INTO the corpus, not just repairing.
2. **The engine found real mathematics fast**: group theory's self-duality
   catching my wrong test; the UNDECIDED split forced by mutation testing;
   the vacuous-first-engine correction. Those corrections are recorded in
   notes/ and survive independently of the code.
3. **Exploration speed.** An unchecked engine that proposes and a kernel
   that disposes is a legitimate division of labor — PROVIDED the proposal
   is never recorded as a result. The defect is not that the engine exists;
   it is that its outputs currently sit in the record with no marker
   distinguishing them from checked terms.

## The discharge path (receipts, not intentions)

- **R1 (this note):** the defect is written at its site. DONE — this file,
  and a pointer added to `machinery/crystal/README.md` is owed.
- **R2 (transport, smallest honest step):** one engine verdict lifted to a
  checked term — e.g. the left-zero/right-zero non-interpretability, or one
  IMPOSSIBLE verdict's joint-model collapse, stated and proved in a small
  Agda module against the pinned toolchain. One term converts the engine
  from "parallel authority" to "conjecture generator for the kernel," which
  is its lawful role. **DISCHARGED, same night:**
  `formal/cubical/Aikya_TheJointModelOfLeftZeroAndRightZeroIsASingletonSo
  TheEngineVerdictIsATerm.agda` — Agda 2.6.3 + cubical v0.5, `--safe`, exit
  0, no postulates, no holes. `collapse : JointZero A → ∀ x y → x ≡ y` (two
  lines: sym left-zero ∙ right-zero), hence `isProp A`, hence no joint model
  on Bool via `true≢false`. The engine's finite searches at sizes 2 and 3
  were shadows of this one term, which covers every carrier and every size
  at once — the exact sense in which a theorem replaces an experiment
  (CLAUDE.md, The rule, item 1).
- **R3 (marking):** engine outputs stored in data/ get a one-line header
  naming their trust base (unchecked engine, checked kernel, finite model
  search) so no future reader mistakes śabda for pratyakṣa. Owed.

## Ledger

| # | claim | grade |
|---|---|---|
| D1 | the correspondence table | read from both sides by the author; module names verified to exist; depth of correspondence varies by row and is a reading, not an equivalence — that is WHY R2 exists |
| D2 | "70 theorems is śabda" | exact in the corpus's stated epistemology (PROTOCOL pramāṇa discipline) |
| D3 | R2's claim that one term changes the engine's role | design judgment, not theorem |
