# bio/ — three finite biological presentations of one machine

The claim under test (research/BIOLOGY_FRONTIER_20260914.md): the 2026 biology
frontier does not need new domain architecture. Its fields already expose finite
presentations — perturbation tables, molecule fields with segmentations, haplotype
paths with reference projections — and each is an instance of constructions the
corpus already checks: AdiBija's receiver/fold/uniqueness, Vivarana's one-object
many-readings, the Myhill–Nerode minimal machine, and erasure = descent with the
fibre law as the residue. This directory instantiates those constructions on three
such presentations, in cubical Bend, checked and run on the full HVM4 runtime.

Every file checks with zero rejections and its `main` runs on `--to-hvm4-full`
(`bio/suite.sh`; verified 2026-09-14 on the patched compiler built with GHC 9.4.7):

| file | checks | main on HVM4 | itrs |
|---|---|---|---|
| `Descent.bend` | 75 | 0 | 0 |
| `Perturbation.bend` | 194 | 12 (pseudobulk reporter of a predicted double knockdown) | 1256 |
| `Segmentation.bend` | 114 | 1 (a cell-by-gene entry under segmentation 1) | 1216 |
| `Pangenome.bend` | 112 | 2 (insertion copy number of haplotype H3) | 813 |

Run: `bio/suite.sh [bend] [hvm]` (imports resolve against `port/`, so the checker is
invoked from there). Benchmark: `bio/bench/run.sh` (see `bench/README.md`).

## Honest scope, first

- The presentations are **toys**: four gene coordinates and three knockdowns; six
  transcripts and two band segmentations; a six-node graph and four haplotypes. The
  regulatory rules, the field and the graph are **declared**, not learned from
  Tahoe, Perturb-seq, Xenium or HPRC. No external dataset was touched in this
  session (the container has no access to them).
- What is established is therefore about the **machine**: that the corpus's
  constructions apply unchanged to these presentations, that the descent checker
  classifies readings exactly, and what the runtime does with a shared program over
  many states. No biological conclusion is claimed.
- The Nerode definitions used in `Perturbation.bend` are copied verbatim from
  `port/MyhillNerodeMinimalMachine.bend` rather than imported, because that port
  takes tens of minutes to re-check (see PORT.md).

## `Descent.bend` — erasure = descent, as a definition

`erasure.bend` at the top level is a must-fail probe (a fake descent witness is
rejected). This file makes the criterion a *type*: `Descends(A, R, V, t)` is the
recursor's `resp` obligation, `erase` is the erased computation and exists exactly
when `Descends` is inhabited, `erase_cl` says the erased reading agrees with the
unerased one on points, and `refuse` turns a single separated R-related pair into
a proof that **no** descent witness exists. The fibre law is `totalEquiv :
A ≃ Σ (b : B). fiber f b` for every `f`, its `ua` path, and `present`, transport
along it, which computes to the constructor (ua β) — the residue as a runtime
value. Nothing biological is in the file; the three presentations import it
unchanged.

## `Perturbation.bend` — the virtual-cell task

A cell is `@cell{tf, tg, rp, hd}`; the generators are `kdTF`, `kdTG`, `kdHD`;
`step` is the declared response; an experiment is a word; `perturb` is the port's
`run`. Then, in order:

1. **AdiBija instantiated.** `Receiver` (a `Motion` carrier plus `eps`/`cons`
   actions), `fold`, and `fold_unique`: any function with the two computation
   rules *is* the fold, pointwise.
2. **The receiver family as folds.** `lenR` (cost; `steps_is_length` exhibits list
   length as the fold by uniqueness), `degR` (differential expression as an
   evaluator integral ∫ω, ω = coordinates changed per step), `massR` (the visible
   transcript mass is conserved by every generator, so a derivation certifies an
   endpoint equation; `massSound_is_fold` exhibits the hand-written soundness as
   the fold).
3. **Vivarana.** `elucidate` reads one experiment through all three lenses at
   once; `elucidation_is_canonical` forces the semantic component. On `x0` the
   histories `direct = [kdTF, kdTG]` and `detour = [kdTG, kdTF, kdTG]` are
   coterminal (`coterminal`, by refl); cost 2 vs 3 and DE 4 vs 6 keep them apart
   (`costs_differ`, `de_differ`), the meaning lens identifies them
   (`meanings_agree`, by `isSetNat`).
4. **Commutation is structure.** `hd_commutes` (for every cell, by refl);
   `order_matters` (TF then TG ≠ TG then TF on `x1`, a proof of `Empty`);
   `kdHD_fibre_not_contractible` (a knockdown is not invertible: its fibre over
   the result holds two distinct preimages — what it erased).
5. **Behavioural state.** `hidden_nerode`: two cells differing only in `hd` are
   Nerode-equivalent under **every** experiment (a proof for all words, through
   `visRun`: the visible projection commutes with every experiment);
   `same_state` puts them in one class of `Meaning = Cell / Nerode`.
   `blind_now/TF/TG/HD` + `separated`: a TF difference is invisible to every
   experiment of length ≤ 1 and separated by the continuation `[kdTF, kdTG]` —
   state is what the future can tell.
6. **The behavioural compression curve.** Two rungs of a quotient chain, each
   receiver classified by the descent checker:

   | rung | reporter | visible mass | total (incl. hd) | reporter after `[kdTF,kdTG]` |
   |---|---|---|---|---|
   | q1 = erase `hd` (`R1`, `Z1`) | ✓ `reporter_q1` | ✓ `mass_q1` | ✗ `total_q1` | ✓ `future_q1` |
   | q2 = also erase `tf` (`R2`, `Z2`) | ✓ `reporter_q2` | ✗ `mass_q2` | ✗ `total_q2` | ✗ `future_q2` |

   A ✓ is an inhabitant of `Descends` (and `erase` then runs, e.g.
   `reporter_on_Z1`); a ✗ is a proof of `Empty` from any putative witness. The
   distinction q2 destroys is exactly the one the separating experiment needs.
   `q1_residue_is_hd` exhibits the fibre over one class holding two distinct
   cells; `cell_is_class_plus_residue` is the fibre law at q1.
7. **Naturality across context.** A transport `T12` (a hidden-gene shift) and
   `T13` (regulator roles exchanged). `square_TF_T12`: the TF mechanism commutes
   on the nose. `square_HD_T12_fails` / `square_HD_T12_Z1`: the HD knockdown does
   not commute as cells but does after the quotient q1 — conserved at one
   reading, not another. `square_TG_T13_obstructed`: obstructed even at the
   reporter reading. The three outcomes are three distinct checked shapes.
8. **The VCC-shaped artefact.** `predict` maps a knockdown over a control
   population; `pseudobulk` and `de_count` are readings of the prediction.
   `main` runs the double knockdown on the full runtime (12, in 1256 itrs).

## `Segmentation.bend` — the spatial molecule field

Transcripts `@mol{gene, x, y}`; two segmentations `s1` (bands in x), `s2` (bands in
y). `field_by_s1`, `field_by_s2`: `P ≃ Σ (c : C_i). fib(c)` twice. `reseg` moves a
(cell, residue) presentation from `s1` to `s2` by transport back along one law and
forward along the other, and `reseg_computes` says it computes on the nose (ua β
both ways). Readings: the gene of a transcript is refused by both segmentations
(`gene_not_through_s1/s2`) — cell-level expression is a *count of the fibre*, never
a reading of the class; a region coarser than `s1` descends through `s1`
(`region1_through_s1`, `region1_on_C1`) and is refused by `s2`
(`region1_not_through_s2`). `fibre_holds_two` exhibits the residue. On one concrete
field, `cellByGene` gives per-cell entries that depend on the segmentation
(`per_cell_depends_on_segmentation`) while the tissue total is invariant
(`tissue_total_invariant`).

## `Pangenome.bend` — reference projections

Haplotypes are node lists; `proj38` and `projT2T` keep the nodes of each backbone.
GRCh38 identifies the reference-like `H1` with the insertion carrier `H2`, the
duplicated carrier `H3` and the novel-node `H4` (`h1_h2_38`, `h2_h3_38`); T2T
identifies only `H1` with `H4` (`h1_h4_T2T`, `h1_h2_not_T2T`) — two references
discard different structure. `hap_by_38`, `hap_by_T2T`: the fibre law twice;
`liftover` is transport between the two presentations with the residue carried,
computing on the nose (`liftover_computes`). Readings: haplotype length is refused
by GRCh38 (`length_not_through_38`); insertion copy number descends through T2T
(`copies_through_T2T`, `copies_on_VT2T`) and is refused by GRCh38
(`copies_not_through_38`) — reference bias as a missing descent witness; a
reference allele descends through both (`allele_through_38`). `fibre38_holds_two`
exhibits the residue.

## What the same machine is, across the three

| | Perturbation | Segmentation | Pangenome |
|---|---|---|---|
| rich object A | cells | transcripts | haplotype paths |
| presentation q | erase hidden / TF coordinates | a segmentation | a linear reference |
| descends | reporter, visible mass | region coarser than s | reference allele; copy number through T2T |
| refused | total, future reporter at q2 | gene identity, region across s | length; copy number through GRCh38 |
| residue exhibited | `q1_residue_is_hd` | `fibre_holds_two` | `fibre38_holds_two` |
| fibre law | `cell_is_class_plus_residue` | `field_by_s1/2`, `reseg` | `hap_by_38/T2T`, `liftover` |

Every row uses `Descends`, `erase`, `refuse`, `totalEquiv`, `totalPath` from
`Descent.bend`, and nothing else was added to the machine between the three files.
