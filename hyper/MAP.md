# Hyperactive

Read these before writing anything here, in this order: `fibre/src/Everything.agda`,
`fibre/src/Fibre/CorpusInteraction.agda`, `fibre/src/Fibre/Carrier.agda`,
`fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`,
`fibre/src/Fibre/Interaction_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda`,
and §0 of `formal/cubical/Kernel/DescentNote_WhatThisIsAndHowToDescendIntoTheMetacircularKernel.agda`.
Its test applies to every sentence of this file: a sentence that could have been
written without reading the checked term it is about is narration from prior.
Every identifier named below is cited as `file:line`, and `cite.sh` fails when
the identifier is not on that line of that file.

## The name

In an interaction net the only event is an active pair: two cells whose principal
ports face each other. Everything this program does happens at an active pair, and
a question from the world is one too (§2). The files are `.hyper`, the binary is
`hyper`, this directory is `hyper/`.

## 1. The substrate

A cubical type theory in which ua's β-rule reduces, with demanded (weak head)
reduction. `formal/cubical/Kernel/DescentNote_WhatThisIsAndHowToDescendIntoTheMetacircularKernel.agda:304`
`univalence-acts` is that fact as one term, and the descent note names it as the
whole reason the rest is possible.

The substrate is `cell.c`, `cell.h`, `read.c`, `verify.c` and the two rule files.
It reduces Bend2's dialect: every `.bend` under `collab/bend2-interactive-cubical`
is checked and emitted by Bend2 (`bend F --to-hyper`, `src/Target/Hyper.hs` in
`cubical-paths.patch`), run by `hyper bend`, and its value compared with Bend2's
own normaliser (`bendtest.sh`: 124 programs agree, 12 skipped because the oracle
itself does not run them). `verify.c` checks the same books and agrees with
Bend2's checker verdict by verdict (`checktest.sh`: 3862 definitions over 150
files, the must-fail probes included). `test.sh` holds 40 checks of the
substrate's own probes.

What the substrate provides: cells over bound dimension names, frames with
descent, the face map (a dimension's endpoint, a choice name's side, a
coordinate's substitution), the interval as the free De Morgan algebra in
canonical form, transp and hcomp with regularity as an occurs check, Glue and
ua, higher inductive types by a schema (constructor boundaries read from their
types), fixed points, four numeric kinds, superpositions at bound names, and a
reader for its own text. Nothing is erased inside a run: a demanded node is
marked with its result once reduced (`T_IND`) and every holder sees the value.
The checker is bidirectional over static code with coordinates and rewrites via
the face map. The corpus's machine runs on cubical Agda; this evaluator exists
so that the machine can run without Agda or HVM, and it is the part of this
directory that is not itself the corpus.

Deviations from the mathematics, recorded: a non-variable scrutinee rewrites the
goal but not the context; a definition unfolds under conversion by its head
first; the branch-wise comparison of two stuck eliminators is bounded; a face
map passes through an application of a closed name into its arguments before
the name unfolds, the one rule that fires on a node that is not a value.

## 2. The machine

`fibre/src/Fibre/CorpusInteraction.agda`, whole:

```
Point ℓ    = Σ[ A ∈ Type ℓ ] A                                    :16
Question s = Σ[ B ∈ Type ℓ ] (fst s → B)                           :22
target s (B , f) = B , f (snd s)                                    :25
Receipt s q s' = target s q ≡ s'                                    :28
Event _ _ _ r = r ≡ r                                               :31
Corpus = S.ISC Question Receipt Event                               :35
run : (s : Point ℓ) → Corpus s                                      :38
S.react (run s) q = target s q , refl , refl , run (target s q)
step a f : fst (S.react (run (point a)) (B , f)) ≡ point (f a) = refl    :41
```

with the coalgebra
`fibre/src/Fibre/Interaction_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda:75`
`ISC` (coinductive), `:81` `react : (q : Q w) → Σ[ w' ∈ W ] Σ[ o ∈ O w q w' ] (E w q w' o × ISC Q O E w')`.
A state is a typed point. A question is a typed map out of the current type. The
answer is the point carried along it. The receipt is the path from the target to
the new state, `refl` at the canonical step. The process continues at the new
point, guarded: nothing is globally normalised, a finite demand of length n asks n
questions and forces nothing else. `:132` `det-observe` and `:139`
`det-strategy-independent`: with the trivial question every strategy observes
the same prefix of the orbit. `:172` `counter-demand-matters`: with a real
question two strategies computably disagree at the first step.

The state carries its reading losslessly: `fibre/src/Fibre/CorpusInteraction.agda:47`
`State`, `:82` `state≡carried`, by `fibre/src/Fibre/Carrier.agda:92`
`fibre-isContr` (the fibre `singl (f a)` is contractible), `:96` `descend`,
`:115` `Carrier≃`, `:119` `Carrier≡`, and `:129` `carry-transport-descend`
(transport along ua computes to descend, by uaβ).

As written (`main.c`):

- `hyper run FILE [DEF]` is the trivial-query case: the point reduced to its
  normal form, no question asked.
- `hyper interact FILE [DEF]` is `react`: the point is printed, then each line
  of the world is a question, a term of the kernel's text, and the point is
  presented along it; the new state is `(q a, (a, refl))`, the source never left
  behind. A reduction that stalls at an `ASK` cell prints the question and
  resumes on the world's line.
- `hyper check FILE` is `verify.c` on every definition.
- `hyper bend FILE` runs `b/main` in Bend2's presentation, for the oracle.

## 3. The trace, and what a computation costs

`fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda:90`
`Conservative` (`Trace : B → Type`, `whole : A ≃ Σ[ b ∈ B ] Trace b`); `:129`
`fibre-of-run`: for any conservative factorisation the trace family is the
homotopy fibre of the visible map it induces, so the residue of a computation is
not a design choice. `:159` `exact-when-contractible` and `:164`
`contractible-when-exact`: the trace measures exactly the failure of the visible
result to be the whole event. `:181` `canonical` is the factorisation every map
has, and `:194` `canonical-recovers`, by `refl`: the source was never left behind.

So the trace of a run is the retained point, and what a computation costs is the
census of the fibres of its visible map:
`fibre/src/Fibre/WholePartialDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic.agda:87`
`देश`, `:93` `गणना`, a diagnosis pointwise over the codomain, three-valued (empty,
one, crowded), never a Boolean verdict. There is no interaction count in this
machine; a count of rule firings was HVM's measure and is not a corpus quantity.
Commutation is the certificate that an order was removable:
`fibre/src/Fibre/Order_CommutationIsTheProofThatTheOrderWasNeverThereAndItsFailureIsRetained.agda:102`
`serialisation`.

As written (`main.c`, `hyper census FILE MAP DOM COD`): the domain and codomain
are given as superpositions of their points; the map is presented along every
point of the domain; over each point of the codomain the fibre is the domain
points whose value is it, and its census is
`fibre/src/Fibre/WholePartialDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic.agda:88`
`नास्ति` (none), `:89` `सकलादेश` (one), or `:90` `विकलादेश` (two or more, shown). `t/census.hyper` is the
module's own §3, computed: `Unit → Bool` is सकलादेश at `True` and नास्ति at
`False`, `Bool → Unit` is विकलादेश at `Tt`, and their composite is सकलादेश, so
the loss at the second step does not appear in the composite.

## 4. What is not here, and why

`install`, a rule table, receipts, an interaction count, a census of rule
firings, erase counting, schedules, a parser producing Code, and a reifier were
removed. They came from `formal/cubical/Kernel/`, the term-rewriting kernel,
which the fibre library's interaction module names as a different object, a
term-rewriting kernel whose caller disposes of the offered futures, and whose
own theorems diagnose it:
`formal/cubical/Kernel/Vyapti_TheInstalledOperationHasNoneSoTheKernelMemorisesAndTheSchemaIsWhatMakesItGeneralise.agda:113`
`fires-only-at-source` (an installed operation fires at exactly one term),
`:176` `kernel-cannot-reach-a-tower`,
`formal/cubical/Kernel/Siddhasadhana_InstallingWhatYouCanAlreadyReachIsAPlateauSoTheKernelsOwnLibraryCannotGrowItsReach.agda:96`
`install-chain-plateau` (installing what is already reachable leaves the reach
equal). The fibre library's mechanism for a new way to compute is univalence: a
proved equivalence is transported (`Carrier≡`, `carry-transport-descend`), and a
grammar's substitution is a Carrier instance with a base and a carried datum
(`fibre/src/Fibre/Sthanivadbhava_TheAdesasFormIsTheFreeSlotAndItsDesignationsAreCarried.agda`),
not a parser. `formal/cubical/Kernel/ControlledGrammar.agda:27` `install` stays
where it is, as the object it is.

## 5. Files

    hyper/cell.h        186  the word layout, tags, frames, constructors
    hyper/cell.c       1273  the substrate: heap, frames, instantiation, the interval, the face map,
                             case trees, the HIT schema, numbers, transp, hcomp, Glue, the loop, printers
    hyper/read.c        282  the reader for the kernel's own text
    hyper/verify.c      795  the checker on the same loop
    hyper/main.c        100  run | bend | check | interact | census (§2, §3)
    hyper/prelude.hyper 158  the Kan rows, Glue, transpEquiv, the HIT rows, as data
    hyper/bend.hyper     45  the Bend2 dialect's rows
    hyper/test.sh            the substrate's checks
    hyper/bendtest.sh        values against Bend2's normaliser
    hyper/checktest.sh       verdicts against Bend2's checker
    hyper/cite.sh            every identifier this file names is on the line it cites
