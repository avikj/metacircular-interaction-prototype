# The 2026 biology frontier as finite presentations of one machine

**Analysis, 2026-09-14.** Tags as in HLEVEL_OF_INTERACTION: **[T]** a checked
term, named; **[R]** a reading of checked terms; **[S]** syāt — a shape, a
plan, or a claim about the external world, under its standpoint only. Two
directives were received this session (the "frontier" essay and the "highest
leverage" follow-up); this document records what was executed against them,
what the execution showed, and what remains [S].

## 0. The directive, restated as a single operation

Both essays reduce to one boxed pattern: a rich object `X`, a chosen
presentation `q : X → Y`, a requested reading `R`; ask whether `R = R̄ ∘ q`
and, if not, retain the fibre. The corpus already has the operation in three
checked forms:

- the receiver/fold/uniqueness of `AdiBija` (every reading of a derivation is
  the unique fold of its step-actions) [T];
- the elucidator of `Vivarana` (one object, its readings at once; two
  coterminal histories separated by length, identified by meaning) [T];
- erasure = descent in `collab/bend2-cubical/erasure.bend` (a fake witness is
  rejected) and the set-quotient/effectivity/Myhill–Nerode ports [T]; the
  fibre law in `fibre/src/Fibre/Carrier.agda` and `fibrelaw.bend` [T].

The claim to test was not "build a virtual cell" but: **the field's finite
presentations instantiate these constructions unchanged.** That is a claim
about the machine, so it can be tested without the external datasets, and
was.

## 1. What was executed [T]

Toolchain: the patched Bend2 compiler was rebuilt from
`collab/bend2-cubical/cubical-paths.patch` (GHC 9.4.7, cabal 3.8, the HANDOFF
recipe; HVM3 needed the two `ref.c` includes and the GCC-15 patch) and
verified against recorded results (`port/SetQuotient.bend` 61 ✓,
`port/Carrier.bend` 65 ✓ and its main on HVM4). HVM4 head built from source.

Four Bend files in `collab/bend2-cubical/bio/`, every one checked with zero
rejections and its `main` run on the full cubical runtime (`bio/suite.sh`,
`bad=0`):

| file | what it instantiates | checks | main / itrs |
|---|---|---|---|
| `Descent.bend` | `Descends`, `erase`, `refuse`; the fibre law `totalEquiv`/`totalPath`/`present` (ua β) — generic | 75 | 0 / 0 |
| `Perturbation.bend` | AdiBija + Vivarana + Nerode + descent on a perturbation table | 194 | 12 / 1256 |
| `Segmentation.bend` | the same `Descent` on a molecule field with two segmentations | 114 | 1 / 1216 |
| `Pangenome.bend` | the same `Descent` on haplotype paths with two references | 112 | 2 / 813 |

`bio/README.md` names every theorem. The ones that carry the argument:

**Perturbation.** `fold`/`fold_unique` on the knockdown generators;
`steps_is_length` and `massSound_is_fold` exhibit two analysers as folds by
uniqueness; `elucidate` reads one experiment through cost, DE-integral and
conservation at once and `elucidation_is_canonical` forces the semantic
component; `coterminal`/`costs_differ`/`de_differ`/`meanings_agree` are
Vivarana's separated-and-identified pair on two experimental histories;
`hd_commutes` and `order_matters` are commutation and its exact failure;
`kdHD_fibre_not_contractible` is a knockdown's irreversibility as a fibre;
`hidden_nerode` proves, for **all** words, that a hidden coordinate is
behaviourally invisible, and `same_state` puts the two cells in one class of
the port's `Meaning = X / Nerode`; `blind_now/TF/TG/HD` + `separated` show a
distinction invisible at depth ≤ 1 and separated by a continuation.

**The behavioural compression curve** (the follow-up's §4), two rungs:

| rung | reporter | visible mass | total | reporter after `[kdTF,kdTG]` |
|---|---|---|---|---|
| q1 erase `hd` | ✓ | ✓ | ✗ | ✓ |
| q2 erase `hd`,`tf` | ✓ | ✗ | ✗ | ✗ |

Each ✓ is an inhabitant of `Descends` and the erased reading then runs
(`reporter_on_Z1`); each ✗ is `Empty` from any putative witness (`refuse`).
The residue is exhibited (`q1_residue_is_hd`) and the fibre law instantiated
(`cell_is_class_plus_residue`). This is the curve's *shape* with two points;
the curve on a real corpus is [S] (§4 below).

**Naturality across context** (§5): `square_TF_T12` commutes on the nose;
`square_HD_T12_fails` but `square_HD_T12_Z1` commutes after the quotient;
`square_TG_T13_obstructed` fails at the coarsest reading. The three outcomes
the essay names are three distinct checked shapes.

**Segmentation and pangenome** reuse `Descent.bend` with no additions:
gene identity refused by every segmentation, a coarse region accepted by one
and refused by the other, per-cell counts segmentation-dependent while the
tissue total is invariant (`per_cell_depends_on_segmentation`,
`tissue_total_invariant`); `reseg` and `liftover` are transport between two
presentations of one object, computing to the constructor; haplotype length
and insertion copy number refused by a GRCh38-like projection, copy number
accepted by a T2T-like one — reference bias as a missing descent witness.

## 2. What the execution showed that the essays did not say [R]

1. **The descent checker is a classifier, not a heuristic, and it is
   cheap.** Every ✓/✗ above is a few lines; the substrate does the work. The
   two-rung table is the essay's "compiler criterion for biological state"
   running.
2. **Nothing was added to the machine between the three presentations.**
   The same five definitions (`Descends`, `erase`, `refuse`, `totalEquiv`,
   `totalPath`) carry the perturbation, spatial and pangenome cases. That is
   the strongest thing this session establishes: the "four more finite
   presentations of the same machine" sentence is a fact about the code, not a
   hope.
3. **The generator family is a monoid, not the kernel's groupoid.** Knockdowns
   have no `reverse`; their irreversibility is the non-contractible fibre of
   `step(·, a)` (`kdHD_fibre_not_contractible`). The kernel's derivations are
   invertible; experiments are not. This is a difference from
   `RewriteCertificate`, and it is where the fibre law does biological work.
4. **Behavioural state is *future*-determined, and the descent checker sees
   it.** `future_q2` refuses to erase `tf` for the reading "reporter after the
   separating experiment" while `reporter_q2` accepts it for the immediate
   reporter. The essay's "state = minimal sufficient machine for the declared
   experimental capability" is exactly this dependence of the accepted
   quotient on the receiver family, and it is checkable per receiver.

## 3. The runtime measurement: a premium that was the implementation, not the calculus [T][R]

`bio/bench/` measures one program (eight knockdowns) over N cell states in
four representations on the full runtime. The first pass (2026-09-14) found
superposed inputs sharing the program exactly as call-by-need hoisting does
(heavy regime: both pay the 825k-itr program once, a naive per-cell map pays
it N times) but costing **≈1.45× per cell** on the stepping, and read that
premium as the calculus's own commutation cost. The second pass (2026-09-15)
asked whether that matched theoretical expectation — it did not: the shared
part paid once plus per-branch work equal to standalone plus one commutation
per match predicts `supin` at or below the list. Three hypotheses were tested
(tables in `bio/bench/README.md`):

- *collapse cost* — none: `-C` adds no interactions;
- *label collision with HVM4's auto-dup labels* — none: `list` and collapsed
  `supin` results agree for every N;
- *the emitter's data encoding* — **this is it.** The `--to-hvm4-full` emitter
  encodes a four-field record as a six-deep chain of `#Pair` constructors with
  a tag, and a nullary constructor as a pair, so one step on a superposed cell
  performs ~7 matches that each commute over the superposition and duplicate
  a continuation containing all the deeper ones. The same program hand-written
  in HVM4 with flat constructors and native numbers gives **0.91** at every
  N ≥ 2 — superposed inputs beat the list, as theory predicts — and the
  absolute per-cell cost falls from ≈550 to ≈160 interactions. With flat
  constructors but Peano naturals the premium is 1.36 (unary arithmetic then
  runs in superposition, commuting at every `#Suc`); with the emitter's pair
  chains but native `I64` numbers it rises to 1.63 (cheap arithmetic leaves the
  record matching as almost all of the per-cell work).

On the way a second bug: both HVM4 emitters compiled every `I64`/`F64` literal
to `0` through a silent catch-all (`Val _ -> "0"`). Fixed in
`cubical-paths.patch`; `elucidator.bend`'s I64 main now runs correctly on the
runtime. HVM4 numbers are unsigned 32-bit, so signed values outside that
range wrap — a visible limitation now, not a zero.

So the corrected statement of §14–16 of the follow-up: `shared generator ⊗
superposed residual states` does win on the net — modestly on a program whose
shared part is small (9%), and by the whole shared cost when that part is
large — provided the residual states are encoded flat and their arithmetic is
cheap. The fix is in `Target/HVM4Full.hs` (native n-ary constructors instead
of tagged pair chains), not in the calculus. Wall clock, memory and any GPU
baseline were not measured.

## 4. The frontier table, row by row, with tags

| frontier | presentation instantiated here | construction | status |
|---|---|---|---|
| Perturb-seq / VCC | toy table, 3 generators, reporter observation | fold, Vivarana, Nerode, descent, fibre | machine [T]; VCC artefact [S] |
| GRN inference | the Nerode quotient IS the behavioural machine; `same_state`, `separated` | Myhill–Nerode port | machine [T]; CausalBench comparison [S] |
| spatial omics | molecule field, two segmentations | fibre law, descent, transport between presentations | machine [T]; SpatialData/Xenium [S] |
| pangenomics | node paths, two reference projections | fibre law, descent, `liftover` | machine [T]; HPRC/GIAB [S] |
| reaction networks | not built this session; `massR` (conservation as a receiver) and `hd_commutes`/`order_matters` are the shape | fold, commutation | [S], shape [T] |
| lineage / development | not built; `coinduction.bend`, `Samvada`, `Upayoga` are the constructions | coinduction, assimilation fold | [S] |
| molecular dynamics / MLIP | not built; the "adaptive theory selection" of the follow-up's §10 is `Descends` per physical receiver | descent | [S] |
| protein / ligand state | not built; the "keep the fibre" statement is `totalEquiv` | fibre law | [S] |
| reliability as a type (follow-up §3) | not built; `hit_trunc.bend` has propositional truncation on the runtime | ∥A∥ | [S], primitive [T] |
| experiment design (§18) | not built; "which fibre distinction blocks the requested descent" is the ✗ rows of the curve | refuse | [S], shape [T] |

## 5. What is not done, stated exactly

- **No external data.** The Virtual Cell Challenge boundary (18,400 control
  cells per context, withheld knockdowns), scPertEval, Tahoe, Xenium, HPRC:
  none touched. Every generator here is declared. The falsification surface
  the essays want is real and untouched; this session built the object that
  would meet it and proved it is one object.
- **The VCC artefact** requires: a finite presentation of the actual control
  population (a `Cell[]` of the exposed states), generators installed from
  public perturbational knowledge (the essay's "install" step — the corpus's
  `install : Derivation → NativeOperation` is the type, a learned response
  the content), scPertEval protocols as `Receiver`s with `Nat`/list-valued
  motions, and the descent classification of candidate state reductions
  against that family. Each is the shape checked here at scale, not a new
  primitive; the Nat-valued toy readouts would have to become integer or
  rational carriers, which Bend2 has (`I64`, see `elucidator.bend`).
- **Reaction networks** are the closest untouched row: SBML reactions are
  generators, `massR` is already the stoichiometric receiver, and the
  commutation witnesses are the concurrency algebra. Nothing in `bio/` would
  change; the file would be a fourth presentation.
- **The Nerode port re-checks slowly** (`port/MyhillNerodeMinimalMachine.bend`
  had not finished after 30 minutes when this was written; PORT.md recorded
  it as "(checking)"). The bio files therefore repeat its five definitions
  verbatim rather than importing them. Making that port fast is a checker
  task, not a mathematics task.
- **Runtime claims are itrs only.** No wall-clock, memory or energy numbers;
  no comparison to a tensor system; the sequential HVM4 C runtime.
- **The emitter's constructor encoding** is the identified bottleneck for
  superposed populations (§3); changing `Target/HVM4Full.hs` to emit native
  n-ary constructors is the next runtime task, with `bio/bench/flat/` as the
  target output.

## 6. The one-line result

The essays' program is executable now, at toy scale, with nothing added to
the machine: three biological presentations, one `Descent`, every reading
classified, every residue exhibited, every main on the net — and one runtime
finding: the measured premium of superposing states over a shared program
was the emitter's nested-pair encoding of records, not the calculus; with flat
constructors the superposed population beats the list, as the theory says.
