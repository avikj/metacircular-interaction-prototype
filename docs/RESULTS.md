# Results

*For researchers: what is actually proven, measured, or demonstrated —
with module paths — and what is open. The repository's discipline
applies to this document: a claim of absence names the command that
tested it; "checked" means the kernel exited 0 under `--safe`.*

## 1. Checked mathematics (selection, by load-bearing weight)

- **The carrier law** (`punaragamana/src/Punaragamana/Carrier.agda`):
  for any `f : A → B`, the fiber `Σ[b] (f a ≡ b) = singl (f a)` is
  contractible, so `A ≃ Carrier f` — data carries its image and witness
  at zero informational cost; and by computing univalence the equality
  *acts* (`uaβ`). The converse is the working part: a non-contractible
  fiber blocks the equivalence — contractibility is a consumed
  hypothesis, not a formality.
- **Transport owes its residual**
  (`formal/cubical/NaturalMachine/SankramanaSesa_….agda`): loss-free is
  exactly "every residual contractible" (= `isEquiv`); truncation has
  no section at `Bool`, so "copy the unknown" is impossible as a
  theorem, not a policy; and where standpoints disagree, no single
  object summarizes the loss (plurality-blocks-collapse, applied).
- **The sevenfold verdict** (`formal/cubical/Saptabhangi.agda`):
  simultaneous assertion is proven distinct from sequential
  both-assertion; therefore a two-valued verdict erases a genuinely
  irreducible position. Boolean-on-the-wire is a theorem-grade error.
- **The licence of lawful growth**
  (`…/Nirjara_SheddingAPrimitiveCostsLaghava.agda`): the `Anujna`
  record (meaning-preservation + cost-non-increase carried inside the
  change) composes; a conflict-resolved licensed rule list is licensed
  (`para-anujna`); the inadmissible move inhabits no licence
  (`sthula-na-anujnata`). Cost is proven **not** a univalent invariant
  (`mulya-bheda`: two meaning-identical translations, every function of
  the denotation agrees, the cost differs) — the measure that works is
  Pāṇinian (count writing rules, not occurrences), proven stable under
  anuvṛtti/pratyāhāra/apavāda.
- **Born weights from the vows**
  (`formal/cubical/EkatvaMatra_….agda`, `EkatvaMatraDvaya_….agda`): the
  support layer of the Born weights is forced by normalization +
  non-absolutization; the symmetric two-outcome **value** ½ is forced
  over any carrier where 1 halves uniquely. The general interior is a
  stated *type* (`BornInteriorConjecture`) awaiting a term — the honest
  wall is Gleason's theorem territory (fails at dim 2; the named next
  target is dim 4).
- **Observability as charge**
  (`GaugeOrbitClasses` / `ChargeCriterion`, cubical lane): what an
  observer restricted to a query set can learn is exactly which coset
  of the annihilator its world lies in; a charged holder can answer
  with a constructed separator and a neutral holder provably cannot —
  honest-cannot is distinguishable from will-not. (This doubles as the
  routing theorem of the decentralized design.)
- **The classifier soundness chain**
  (`formal/cubical/PrastavaSatya_….agda`, over the shared spelling in
  `formal/executable/PrastavaHrdaya_….agda`): the executable AC
  classifier's verdict is a path (`cmpTm-eq`), its refusals name true
  equations end-to-end (`acShuffle-sound`), and its normalizer is sound
  (`nf-sound`) — the proposer's claims about itself are theorems about
  the literally-extracted clauses (one spelling, `--cubical-compatible`,
  shared by the compiler and the theorem).

Scale: ~1,400 checked modules in the cubical lane; 131 modules in a
Lean lane under a no-`sorry`/no-`axiom` discipline.

## 2. The autonomous loop: measured behavior (August 23–24, 2026)

- Frontier: 403 non-joining critical pairs derived by the machine's own
  rewriter from its rule library.
- Crystal: 200+ theorems landed autonomously (refl / citation /
  structural induction), each in scope for all later proofs; the whole
  store re-rendered and kernel-checked at every landing.
- **Return edge**: 198 crystal theorems + 175 theorems from a parallel
  lane installed as rewrite rules — the rule library grew 201 → 574
  from the machine's own output, and the next sense pass derives new
  critical pairs from it (the frontier is now partially
  machine-generated).
- **Residual edge** (first firing, in the log): goal stalls → kernel
  residual `+(x,0) = x` parsed, triaged, entered as a goal → landed by
  induction → parent closed on retry. The machine derived, scheduled,
  and completed its own prerequisite.
- **Exchange** (first firing): a fresh node adopted a 200-row crystal
  by re-judging every row through its own kernel; citations remapped in
  one ordered pass; zero sender trust.

## 3. The runtime seed criterion: MET (from `legacy/runtime/STATUS.md`)

The falsifiable thesis — *a fact enters the runtime; an independent
problem thereafter solves in strictly fewer kernel steps; measured by
exact counters; with a null control* — passed:

- Crystallization (§3.1, anti-unification): independent problem
  **29 → 12 steps**; null-control theorem's entry left the count
  **bit-identical at 29**.
- Distinction compilation (§3.2): 46,656 states → 216 blocks;
  independent queries **91,551 → 28,672 steps**; null channel added
  cost (+616) and was removed by the algorithm.
- Execution layer: a theorem the runtime proved itself shortened 4 of
  its own geodesics (24→15 on one target); null control bit-identical
  with 0 applications.
- All layers L0–L4 implemented with test suites (33/33, 30/30, 51/51,
  59/59, 32/32, 68/68 across components; mutation-tested where noted).

## 4. Open problems, honestly named

1. **The Born interior at dimension 4** — the conjecture is a type;
   the wall is Gleason (1957). The support layer and the symmetric
   two-outcome value are done; the general interior is not.
2. **The shape gap on the current frontier**: ~200 open pairs need a
   solver/normalizer proof shape (the class is measured: AC
   rearrangements + erasure); three lanes each hold a piece; one shared
   checked normalizer closes most of it.
3. **Signal-domain residuals**: the loss-ledger law instantiated over
   lossy/noisy/analog codecs (spike trains included) — the BCI-grade
   step. Laws exist (`FutureBehavior`, `FactorsThrough ≃ FiberConstant`,
   priced cuts); the instantiation does not.
4. **Licence wiring**: `Anujna` on the live loop's growth moves —
   self-modification that carries its own admissibility.
5. **Re-landing the runtime** from `legacy/` as checked terms with
   extracted executables (the standing Dahana rule).
