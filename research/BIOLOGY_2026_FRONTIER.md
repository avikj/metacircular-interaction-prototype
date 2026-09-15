# The 2026 biology frontier as finite presentations of one machine

**Analysis, 2026-09-14.** Tags: **[T]** a checked term, named, present in the
repository at its pin; **[R]** a true statement about checked terms; **[S]**
syāt — a shape, under its standpoint only; **[ext]** a fact about the external
field taken from the brief that motivated this note, not verified in this
session; **[open]** not yet built, obstruction named.

The brief's thesis, stated exactly: the biology frontier of 2026 does not ask
for a new modelling framework. Each field has already standardised a finite
object — perturbation tables, reaction generators, molecule point clouds with
coordinate transforms, pangenome paths, lineage trees, measurement maps — and
each of those objects is a presentation of a construction the corpus already
checks. The work is to *feed* them to the calculus, not to extend it. This
note records (§1) which construction each frontier instantiates, with the file
that carries it; (§2) the first executable slice, built this session; (§3) the
exact scope of what the calculus does and does not do for the flagship
benchmark; (§4) the order of execution.

---

## 1. The map: field object → existing construction

The correspondence is not an API proposal. Each row names the checked
construction the external finite object instantiates, and the file in which
the construction is a term.

| Frontier | Field's finite object [ext] | Construction | Where it is a term | What is native | Status |
|---|---|---|---|---|---|
| Perturb-seq / virtual cells (VCC 2026, scPertEval, Tahoe) | contexts × interventions × measured distributions; many incompatible evaluation protocols | `Receiver = (Motion, ε, ◂)`, `fold`, `fold-unique`; `Vivarana` (one object, a lens family); `Meaning = X / Nerode`; erasure = descent | `formal/cubical/kernel/AdiBija_…agda` [T], `…/Vivarana_…agda` [T], `collab/bend2-cubical/port/MyhillNerodeMinimalMachine.bend`, `…/erasure.bend` (registered must-fail) [T] | every protocol is one fold of one history; the behavioural quotient is the minimal sufficient state; a proposed reduction is admitted iff every requested receiver descends | **built this session** as `port/Perturbation.bend` (§2) |
| GRN inference (CausalBench, PSGRN) | intervention generators + response relations; incomplete edge ground truth | Nerode congruence: `x ~ y ⟺ ∀ w. O(x·w) = O(y·w)`; the quotient is the *greatest* behavioural congruence; effectivity `[x] = [y] ⟹ x ~ y` | `formal/cubical/theorems/automata/MyhillNerodeMinimalMachine.agda` [T]; `collab/bend2-cubical/nerode_effective.bend`, `hit_effective_suite.bend` (23 ✓, checker and HVM4 agreeing per `STATUS.md`) [T] | a graph is a *reading* of the minimal machine; two graphs that disagree on an edge no experiment can separate are the same object; incomplete edge lists are not the ontology | **built**: `port/GRN.bend` (193 ✓: the tf → hk edge is invisible to the tgt assay under every word, so the Nerode relations of the two families coincide both ways; the tf → tgt edge is separated by the one word `[passage]`, and the two minimal machines differ); [open]: the finite presentation from a CausalBench dataset (front-end) |
| Spatial omics (SpatialData, Xenium) | points, images, labels, shapes, each in a coordinate system with explicit transforms; segmentation `s : P → C` | the fibre law `A ≃ Σ_{b:B} fiber f b` for every `f`; `Carrier` is its contractible case; `ua` makes a faithful change of presentation an equality; transport computes | `fibre/src/Fibre/Trace_…agda` [T], `fibre/src/Fibre/Carrier.agda` [T], `collab/bend2-cubical/fibrelaw.bend` (35 ✓, `present`/`retrieve` run on HVM4/HVM3) [T] | the cell-by-gene matrix is visibly the projection that forgets the fibre of `s`; a downstream statistic is segmentation-invariant iff it descends through both segmentations; raster↔vector is a path where it is an equivalence and has a fibre where it is not | **built**: `port/Spatial.bend` (147 ✓; probe rejects the cell-by-gene entry as non-descending); [open]: `P`, `s₁`, `s₂` from one SpatialData object |
| Pangenomics (HPRC v2.1, GA4GH VRS) | graph + embedded haplotype paths; several graph constructions; two linear references | derivations as paths; projection to a reference coordinate is a map with a fibre; transport between presentations along `ua` of an equivalence, residue where there is none | `port/RewriteCertificate.bend` (Derivation as an indexed family) [T]; `fibrelaw.bend` [T]; `chain.bend` (transport across chains of equivalences on the net, per `STATUS.md`) [T] | `H ≃ Σ_{v:V₃₈} fib(v)`: reference bias is the fibre of the projection, computed, not a heuristic | **built**: `port/Pangenome.bend` (114 ✓: the GRCh38 fibre over one call has two points, `ref_not_equiv`; the panel ≃ its variation definition by `ua`); [open]: GFA/GBZ → path family (front-end) |
| Reaction / metabolic networks (SBML L3, PEtab 2.0, GEMs) | species + reaction generators + conditions + measurement maps | initiality: one generator family, every readout a unique fold; `Krama`: commutation certificate, its failure retained; erasure = descent for model reduction | `AdiBija_…agda` [T]; `fibre/src/Fibre/Krama_…agda` [T]; `erasure.bend` [T] | stoichiometry, mass, charge, flux, label tracing, observables are folds of one reaction history; independent reactions commute by a certificate, dependent ones keep their order as data; a reduced model is admitted iff the requested semantics descends | **built**: `port/Reaction.bend` (111 ✓; probe rejects exactly the enzyme-forgetting reduction); [open]: SBML → generator family (front-end) |
| Lineage / development | branching history + multimodal state; reconstruction after the fact | the interactive coalgebra (question, successor, observation, receipt, continuation); productive runs; `Upayoga`: the store is folded through encounters, order changes the body | `fibre/src/Fibre/Samvada_…agda` [T]; `formal/cubical/NaturalMachine/Samvada_…agda` [T]; `…/Upayoga_…agda` [T]; `collab/bend2-cubical/interaction.bend` (36 ✓), `coinduction.bend` (13 ✓), `silence.bend` (25 ✓) [T]; `research/HLEVEL_OF_INTERACTION_20260913.md` [R] | a measured lineage is a finite observation of a coinductive object; the non-contractible realisation space is the unresolved history, not noise; determinism ⟺ the receipt is a proposition | **built**: `port/Lineage.bend` (98 ✓; the terminal-readout fibre has two points, `unresolved_not_contractible`); [open]: lineage tree → depth-indexed `IExec` |
| Molecular dynamics (OpenMM, MLIP benchmarks) | force law, integrator, trajectory | `LawfulStep`: a visible successor with a typed residue; residue ≃ fibre of the step; contractible residue ⟺ invertible | `fibre/src/Fibre/LawfulStep_…agda` [T] | trajectory plus exact receipts; several observables as folds sharing one trajectory; wall-clock / memory / interactions / sharing measured separately | **built**: `port/Dynamics.bend` (107 ✓: contractible residue for the reversible step, crowded and empty residues for the thermostat, `dissipate_not_equiv`); the cost claim is measured in §3 |
| Protein / ligand state (FoldBench, multi-state) | sequence or complex → sampled structures; collapse to one PDB-dominant state [ext] | map + fibre, not argmax: keep `fiber f y`, the compatible realisation space | `fibrelaw.bend` [T]; `Trace_…agda` [T] | the point prediction is the projection; the fibre is where MD evolves and experiment constrains | **built** (in `Dynamics.bend` §4: `ensemble_is_fibre`, `ensemble_not_a_point`) |
| Whole cell | interacting subsystems over continuing state | composition of the above: derivations compose, quotients compose, folds compose, coinduction continues | `port/GenerativeKernel.bend`, `port/ControlledGrammar.bend` (parallel advance, no premature collapse) [T] | no separate "multiscale integration" primitive: the composition laws are the integration | [S] |

Two corrections to the brief, against the repository:

- "SetQuotient / Myhill–Nerode run on the full HVM runtime." What runs on the
  net, per `STATUS.md`, is the declared set quotient with its effectivity
  (`hit_effective_suite.bend`, checker and HVM4 agreeing). The minimal-machine
  port `port/MyhillNerodeMinimalMachine.bend` is listed in `PORT.md` as
  "(checking)" with no HVM4 `main`. The quotient and its effectivity are
  runtime objects; the full minimal-machine module is a checked module.
- "Fibre.Carrier" is the contractible case. The general fibre law — the one
  spatial, pangenome and protein rows need — is `Fibre.Trace` in Agda and
  `fibrelaw.bend` on the net; `Carrier` is what it reduces to when the output
  is bound.

---

## 2. The first executable slice: `collab/bend2-cubical/port/Perturbation.bend`

One file, in the port's own conventions (`import`, indexed families with
endpoint equations, records as `type`, the set quotient from
`SetQuotient.bend`, effectivity from `Effective.bend`, the machine from
`MyhillNerodeMinimalMachine.bend`). Nothing in it is a new construction. It
is AdiBija, Vivarana, Krama, the minimal machine and erasure-by-descent
instantiated at a perturbation system instead of the rewrite kernel.

**The finite presentation.** A cell is its levels on a gene panel; an
intervention is a knockdown of one gene or a passage; the generator action
`step` is the perturbational continuation algebra. The panel in the file is
three genes with one regulatory edge (tf activates tgt at passage; hk is
unregulated). That is the *shape* of the challenge object, not its data: the
real panel and generators enter by a front-end that emits `Cell`/`Perturb`/
`step` from released control populations, and every theorem in the file is
stated for the panel's generator signature.

What the file states, section by section, and what each says biologically:

| § | Term | Content | Biological reading |
|---|---|---|---|
| 1 | `Step`, `Derivation` | an intervention with its endpoint equation; a history of interventions | the history is the object; the final state is one of its projections |
| 2 | `Receiver`, `fold`, `fold_unique` | a receiver is `(Motion, ε, ◂)`; the fold exists; anything with its two computation rules is it | an evaluation protocol is a receiver; its reading of every history is forced, not designed |
| 3 | `steps`, `targeted g`, `endpoint`, `word` | four receivers: length, "was g directly hit", terminal state, the intervention word | cost, DEG-by-target, pseudobulk, retrieval — one recursor, four lenses |
| 3 | `endpoint_is_endpoint`, `word_replays` | the endpoint reading is the endpoint; running the machine on the word reaches it | the answer is a projection of the route (the PvsNP-gap shape) |
| 4 | `Vivarana`, `elucidate`; `kd_then_pass`, `pass_then_kd` | one record of all readings; two histories with the same interventions in a different order | |
| 4 | `same_length`, `same_tf_targeted`, `same_tgt_targeted` (refl) vs `endpoints_differ` (⊥) | identified by three lenses, separated by the fourth | a "which genes were targeted" protocol cannot see what the endpoint protocol sees; one object carries both facts (Vivarana §3, exactly) |
| 4 | `kd_kd_commute` (refl), `kd_pass_dont_commute` (⊥) | two knockdowns commute by a certificate; knockdown against passage does not | order is an artefact where the certificate exists and data where it fails (Krama) |
| 5 | `NerodeTgt`, `MeaningTgt` | the assay reads tgt only; Meaning = Cell / future-behaviour | the behavioural quotient under the requested receiver family |
| 5 | `tf_is_necessary` (⊥) | two cells the assay cannot tell apart are separated by the future `[passage]` | **state the assay never reads is necessary state** — the erasure the assay suggests is refused by one experiment |
| 5 | `hk_is_invisible`, `hk_same_meaning` | cells differing only in hk agree under every future; their meanings are equal by `eq/` | state the assay never reads and no future reaches is erasable |
| 5 | `meaning_is_future`, `tf_separates_meanings` | effectivity, inherited from the generic quotient; the necessary cells have distinct meanings | equality of meaning ⟺ same future, on this object |
| 6 | `Erased`, `visibleLoad_erased`, `visibleLoad_factors` (refl), `assay_erased`, `step_erased` | the projection forgetting hk is the quotient by agreement on (tf, tgt); receivers reading through (tf, tgt) descend, and so does every generator | `R = R̄ ∘ q` on the nose; the erased object is again a machine |
| 6 | `Perturbation_mustfail.bend` | the receiver reading hk does not descend: its resp obligation is uninhabited and the substrate rejects the collapse | the compiler criterion for biological state: erase iff the requested computation coherently descends |
| 7 | `Context`, `predict`, `pseudobulkTgt`, `pseudobulk_descends` | a context is its control population; the submission is the population under the intervention; pseudobulk descends cellwise | the challenge object, literally: opaque context = supplied unperturbed population; a protocol = a receiver over it |

**Check status.** The file was written against the port's conventions and the
checked files it imports. Whether it is **[T]** is decided by the patched
binary (`cubical-paths.patch` on DKormann/Bend2 @ f026483), not by this note;
the line below is updated by whoever runs it:

    checked: YES — `cubical-paths.patch` on DKormann/Bend2 @ f026483, built
    here on GHC 9.4.7 (HVM3's cabal relabelled GHC2024 → GHC2021 + its
    extensions; base bound relaxed), `LC_ALL=C.utf8`.
      Perturbation.bend           175 ✓  0 ✗   main ⇒ 4
      Perturbation_mustfail.bend  176 ✓  1 ✗   the 1 is `hkResp_WRONG`, as intended
      PerturbationEmitted.bend    145 ✓  0 ✗   main ⇒ 0
      Nerode.bend (import)         99 ✓  0 ✗   0.5 s
    On the full cubical runtime (`--to-hvm4-full`, HVM4 @ 6defdfc, `gcc -O2`),
    each main reduces to the checker's value; interactions / heap nodes:
      Perturbation          4   497 itrs   14305 nodes
      PerturbationEmitted   0   513 itrs   13053 nodes
      Spatial               1   714 itrs   11625 nodes
      Lineage               7   347 itrs    7845 nodes
      Dynamics              6   576 itrs    8684 nodes
    `--total`: Lineage, Dynamics, Spatial, Nerode pass. Perturbation (and the
    emitted file) are refused for `foldM`, `endpoint_is_endpoint`,
    `word_replays` — recursion through a nested `{==}` match, which the
    classifier does not see as descent; the kernel port's own
    `derivation_sound`/`eval` (RewriteCertificate.bend) are flagged the same
    way, so this is the classifier's limitation, not a non-total definition.
    A Bend ✓ is a check by the patched Bend2 checker, which has `Set : Set`
    (`AUDIT.md`): strong evidence of well-typedness, not an Agda `--safe`
    `[T]`. The biological lane lives on the Bend side by decision; the
    distinction is stated so that neither is quoted as the other.

---

### 2b. The other presentations, same machine, all checked and run

Every file below is in `collab/bend2-cubical/port/`, checked by the same
binary, and its `main` reduces to the same value on HVM4 (`--to-hvm4-full`).
Probes contain exactly one definition that must be rejected, and are.

| File | ✓ | main / HVM4 itrs | What it proves |
|---|---|---|---|
| `Reaction.bend` (+ probe 114 ✓, 1 ✗) | 111 | 2 / 272 | conservation is the fold of per-reaction certificates and is unique; `r2`,`r3` commute by refl, `r1`,`r2` do not; forgetting the enzyme's level but not its presence is a reduction through which mass and the generator descend; forgetting it entirely is refused |
| `Spatial.bend` (+ probe 148 ✓, 1 ✗) | 147 | 1 / 714 | the fibre law at a segmentation; the cell-by-gene entry does not descend through the coordinate-forgetting quotient; the gene total does; a coordinate swap is a `ua` path |
| `Pangenome.bend` | 114 | 7 / 842 | the GRCh38 projection's fibre over one call has two haplotypes, so the projection is not an equivalence (reference bias, computed); the second reference separates them; the panel ≃ its variation definition by `ua`, transport computes both ways |
| `Lineage.bend` | 98 | 7 / 347 | a lineage record is the answer stream of the interactive machine; order is in the body; the terminal-readout fibre is not contractible; determinism is silence |
| `Dynamics.bend` | 107 | 6 / 576 | contractible residue for the reversible step; crowded and empty residues for the thermostat; two observables as folds over one trajectory; the ensemble is the fibre of the top-1 projection |

| `GRN.bend` | 193 | 2 / 480 | the tf → hk edge is invisible to the tgt assay (Nerode relations coincide both ways); the tf → tgt edge is separated by one experiment and the machines differ: an inferred edge is a claim exactly when an experiment can test it |

`--total` passes on Lineage, Dynamics, Spatial; Reaction and Pangenome are
refused only for their fold (the same nested-`{==}` pattern the kernel port's
`derivation_sound` is refused for).

One checker fact learned on the way, recorded for the next file: inside a
`match` on a natural number the branch is elaborated in inference mode, so a
bare HIT path constructor (`@eq{…}`) there is `CantInfer`; wrapping it in a
typed helper (`eqR`) makes the branch a Ref application and it checks.

## 3. What the calculus does and does not do for VCC 2026

The brief's central operation is right and is already a term:

> compute the behavioural quotient induced by the available perturbational
> continuation algebra, and admit a state reduction iff every requested
> receiver descends through it.

Three scopes have to be stated with it, or the claim is larger than the
mathematics.

1. **The generator family is an input, not an output.** The quotient says
   which distinctions are *necessary given* `step`. It does not supply `step`
   for a context the challenge withholds. Zero-shot across contexts D/E/F
   [ext] therefore means: the generator family carried from public
   Perturb-seq/Tahoe knowledge is *transported* to the new context, and the
   transport is honest only where there is an equivalence to transport along.
   Where there is none, the honest object is the fibre of the
   context-projection — the space of generator families compatible with the
   supplied control population — and a prediction is a section of it, stated
   as such. The calculus makes the assumption explicit instead of hiding it in
   a latent; it does not remove it.

2. **The front-end is the new work, and the data did not reach this
   session.** Bend2 in this fork reads no `.h5ad`. The finite presentation
   (panel, control cells, intervention identities, the receiver actions for
   each protocol) is emitted by `scripts/emit-perturbation.py`, and the
   emitted file is checked and run. The protocol family is now in it,
   transcribed from cell-eval 0.8.2 (the challenge's own scorer, fetched from
   PyPI, the one host that answered): `mae` (L1 of pseudobulk profiles),
   `deOverlap` (top-k DE genes called on both), `rankOf` (the
   discrimination score's rank of the true perturbation by L1 distance),
   stated on integer pseudobulk sums; cell-count normalisation and the
   signed delta are one line each when real profiles are present. The
   data hosts were tested from here and all refused the connection:
   virtualcellchallenge.org, arcinstitute.org, huggingface.co (VCC and
   Tahoe), zenodo.org, figshare, NCBI GEO, api.github.com. So step 1 of
   the plan (real control populations) and step 9 (a scored submission)
   cannot be done from this session; they need a session whose egress
   policy admits one of those hosts, after which the emitter runs
   unchanged on the real panel.

3. **Cost.** Interaction counts on HVM are not thermodynamic cost, and the
   analysis-layer "cost" is a syntactic count; the established coincidence is
   the narrow one (`CONVERGENCE.md`, Part VI, "honest boundary"). Superposed
   execution has two regimes (`STATUS.md`, `bench_*.bend`): a shared line
   over N values wins and improves with N; different lines lose by a constant
   ~1.4×. The brief reads biology's pattern — one history, many readouts —
   as that shared-line regime. **Measured, it is not, as stated**
   (`port/PerturbationBench.bend`, `--to-hvm4-full`, HVM4 @ 6defdfc): three
   receivers over one history of N passages, the history bound once
   (`shared`) or rebuilt per receiver (`separate`):

       N     shared   separate
       8       2436       2432
       32     16956      17000
       128   190236     190472

   The counts coincide because on the net a `dup` of a cheap structure costs
   about what constructing it costs; the transport benchmark's advantage came
   from sharing a *computation* (the `ua` dispatch), not a value. The
   condition is therefore that the generator action be expensive and that
   the receivers read what it computes — and that was measured too
   (`port/PerturbationBenchSlow.bend`: a passage does 64 units of work on
   the whole cell; the receivers are the length and the tgt and tf integrals
   along the history, which force every state):

       N     shared   separate   ratio
       8      32417      57853   1.78
       32    151169     258301   1.71

   Bound once, the generator's work is paid once; rebuilt per receiver it is
   paid once per receiver that forces it. So the receiver family IS the
   shared regime exactly when the generators are real computations whose
   results the protocols read — the situation of a real perturbational
   model, not of the stand-in's constructor rewrites. (An intermediate run,
   with receivers that never forced the intermediate states, showed no
   difference; the sharing is of forced work, not of structure.) Measure
   wall-clock, memory, interactions and sharing separately, never as one
   number.

---

4. **Scale, and the representation bound.** A 12-gene × 40-cell panel with
   3 edges and 4 interventions (`scripts/examples/scale_12x40.json`) emits
   560 lines, checks in 0.8 s (185 ✓) and runs its pseudobulk protocol on
   HVM4 in 14528 interactions. The port's numbers are unary `Nat`
   (`1n + p`), so a count of k costs k nodes and every profile comparison
   is linear in the counts themselves: adequate for the shape and for
   panels of tens of genes, not for 18 000 genes × 18 400 cells. The step
   from here to a real VCC context is a binary numeral type on the Bend
   side (or the runtime's native words) under the same receivers; the
   receivers do not change. [open], with the bound measured rather than
   guessed.

5. **Protocol disagreement.** The emitter searches the candidates it emits
   for two protocols that order two submissions oppositely (mae vs DE
   overlap) and states both orderings as `refl` theorems when found — the
   scPertEval observation that there is no single notion of a correct
   prediction, as an executable fact about one object under two receivers.
   On the toy spec no such pair exists; the search is in place for real
   candidates.

## 4. Order of execution

1. **Get the binary at the pin and check §2.** Record the verdict in
   `PORT.md` (row) and in §2 above. Register `Perturbation_mustfail.bend`
   wherever the port's probes are registered.
2. **The front-end.** `scripts/emit-perturbation.py` (written this session):
   from a JSON spec or per-context CSVs — panel, regulatory edges, control
   populations, interventions, assay genes — it emits `Cell`/`Perturb`/`step`,
   the receiver machinery of §2–§3, the assay's Nerode quotient with
   effectivity, and the challenge shape (`context_A`, `submission_A_kd_TF1`,
   per-gene pseudobulk) in the file shape of §2, for the real panel.
   `scripts/examples/vcc_shape.json` → `port/PerturbationEmitted.bend` is
   the worked example. Panel-specific theorems (which unread state is
   necessary, which is erasable) are not emitted: they are what the
   quotient is *for*, and they are proved against the emitted generators.
   Still to add there: one `Receiver` per scPertEval protocol beyond
   pseudobulk (DEG, distributional distance, retrieval).
3. **The quotient on the real object.** Run `Meaning` under the protocol
   family; for every proposed feature reduction run the descent obligation;
   keep the fibre where it fails. Run under `--to-hvm4-full`; measure.
4. **The submission.** `predict` per context, scored publicly.
5. **The other presentations, unchanged machine** — done (§2b), and their
   front-ends too: `scripts/emit-reaction.py` (SBML + PEtab-shaped JSON),
   `scripts/emit-pangenome.py` (GFA1, run on the GFA specification's own
   example as well as a two-bubble graph), `scripts/emit-lineage.py`
   (Newick), `scripts/emit-spatial.py` (a points table + segmentation
   rules). Every emitted file checks and runs on HVM4 (`PORT.md`), and
   every one states the emitter's own evaluations as `refl` theorems, so
   the checker certifies that the front-end and the emitted generator agree
   — the front-end cannot silently disagree with the calculus about the
   data. What each emits that the field's file did not say is explicit in
   its docstring (discrete amounts and no rate laws for SBML; overlaps
   trimmed M-only for GFA; branch lengths ignored for Newick; threshold
   segmentations for points). Real inputs from the blocked hosts (§3.2)
   run through these unchanged.
