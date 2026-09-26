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
files, the must-fail probes included). `test.sh` holds the checks of the
substrate's own probes, its ledger, its schedules and its census.

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

## 2. The primitive: interaction

Everything in this corpus is interaction, two-place at the least, and the
runtime's one operation is the coalgebra's `react`:
`fibre/src/Fibre/Interaction_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda:75`
`ISC` (coinductive), `:81` `react : (q : Q w) → Σ[ w' ∈ W ] Σ[ o ∈ O w q w' ] (E w q w' o × ISC Q O E w')`:
one encounter returns the successor, the observation, the proof-relevant event,
and the continuation, which is again an interaction. Nothing is globally
normalised; a finite demand of length n asks n questions and forces nothing else
(`:99` `observe`). `:132` `det-observe`, `:139` `det-strategy-independent`: with
the trivial question every strategy sees the same prefix of the orbit; `:172`
`counter-demand-matters`: with a real question two strategies disagree at the
first step. `LIFECYCLE.rst`: do not begin by assuming two independent machines
exchanging messages; start from the joint interaction and establish which
projections, dependencies and transports it admits.

Its instances, each a checked module, each computed by one mode of `hyper`:

**A typed point and a typed map** (`fibre/src/Fibre/CorpusInteraction.agda`,
whole: `:16` `Point`, `:22` `Question`, `:25` `target`, `:28` `Receipt`, `:38`
`run`, `:41` `step`). A state is `(A, a) : Σ A. A`; a question is `(B, f)` with
`f : A → B`; the answer is `(B, f a)`; the receipt is the path `target s q ≡ s'`,
`refl` at the canonical step. The event is the residual:
`formal/cubical/theorems/residue/CorpusLosslessPresentation.agda:19` `Residual`
(`fiber (query s q) (query s q (source s))`), `:27` `current-residual`
(`source s , refl`), and `formal/cubical/theorems/residue/CorpusSelfPresentation.agda:12`
`present` returns the four together. The state carries its reading losslessly
(`fibre/src/Fibre/CorpusInteraction.agda:47` `State`, `:82` `state≡carried`,
by `fibre/src/Fibre/Carrier.agda:92` `fibre-isContr`, `:96` `descend`, `:115`
`Carrier≃`, `:119` `Carrier≡`, `:129` `carry-transport-descend`). As written:
`hyper run FILE [DEF]` is the trivial query; `hyper interact FILE [DEF]` is
`present`: the point, then each line of the world a question, the point
presented along it, the new state `(q a, (a, refl))`; an `ASK` cell is a
question the point asks the world. The residual's census is `hyper census`
(§3).

**Two parts of one joint**
(`formal/cubical/theorems/logic/Jiva_EntanglementIsTheFibreOfTheProductComparisonAndTheLivingStepRefusesToDescendToTheMarginals.agda`).
A joint state is `J` with two projections, and everything is an officer of the
comparison `:134` `तुलना`, `j ↦ (p j , q j)`: `:139` `स्वातन्त्र्यम्` (independence
is the comparison being an equivalence), `:142` `संश्लेष-तन्तुः` (entanglement is
its fibre family), `:149` `संकलनम्` (the joint is the sum of its entanglement
fibres). `:164` `घटः-स्वतन्त्रः`: the product joint is independent. `:178`
`रिक्तम्`: the diagonal joint has an empty fibre over `(true, false)`, a pair of
marginal readings the whole never realises. `:207` `गूढौ-भिन्नौ`: the joint over
`Unit × Unit` has two distinct residents over the one reading. A step on `J`
descends along a projection when some endomap of the part closes the square
(`:256` `युगलम्-उभयतः`); `:266` `जीवति`: the controlled-not refuses to descend
along the visible side, interrogated at `(true, false)` and `(true, true)`;
`:276` `दक्षिण-विलयः`: it descends along the hidden side by `refl`; `:286`
`विलयः`: the step `(not a, b)` descends on both sides; `:302` `जीवन-द्विः`: the
living step is an involution, globally lossless, locally refusing. As written:
`hyper joint FILE J P Q` computes the census of the comparison over the
superposition of the joint, each pair of marginal readings रिक्तम्, सकलादेश or
बहु, and the verdict स्वातन्त्र्यम् when every fibre is a point; `hyper descends
FILE STEP P J` decides whether the square closes and names the interrogating
pair when it does not. `t/jiva.hyper` is the module's §१ to §६, computed.

**Two sessions and an overlap**: the encounter, §4b.

**The fixed alphabet.** A Chu evaluation `e : A × X → K` retains `k`; the
lossless interaction retains `fib_e(k)`, forced by
`fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda:129`
`fibre-of-run`; the general interaction is a family `R : A × X → 𝒰` classified
by the universal family, and a tower of such families flattens to one
(`fibre/src/Fibre/Universal_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda:312`
`flatten`). `CHU_LOSSLESS_INTERACTION.md` is the reading; the runtime's
`census` over a product domain is the Chu matrix with its fibres.

`hyper check FILE` is `verify.c` on every definition; `hyper bend FILE` runs
`b/main` in Bend2's presentation, for the oracle.

## 3. The trace, and what a computation costs

Two measures, both corpus quantities, and they measure different things.

**The ledger: what a run costs.** `research/sat_fibre/InteractionLedger.agda:13`
`Event`, `:20` `Charge` (`interactions`, `heapWords`), `:57` `Trace` (a run is a
sequence of events), `:65` `interactionTotal`, `:74` `interactionTotal-is-length`.
`research/sat_fibre/InteractionGeodesic.agda:14` `RandomDescent`, parametrised by
a one-step `diamond`; `:45` `same-normalization-length`: every complete reduction
of one object to its normal form has the same length; `:53`
`normalization-is-geodesic`. As written: every rule appends its receipt to
`TRACE`; a run prints `- Itrs:` (the interactions) and `- Words:` (the heap
words allocated), the two components of `Charge`; `HYPER_CENSUS=1` prints the
receipts by rule; `HYPER_SCHEDULE` serves the right of two independent demands
first, or a coin per choice, and `test.sh` and `bendtest.sh` require the same
value and the same count under the schedules (the diamond, measured, since the
hypothesis of `RandomDescent` is not discharged for this loop's step relation).
Definitional unfolding is not an event. The sharing regimes (`bendtest.sh`,
`bench_*_sup` against `bench_*_sep`; `t/ua.hyper`, a transport used k times)
are the reason a runtime exists at all: the superposition is one line over N
values and its cost is what the ledger shows.

**The census: what a question loses.**
`fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda:90`
`Conservative` (`Trace : B → Type`, `whole : A ≃ Σ[ b ∈ B ] Trace b`); `:129`
`fibre-of-run`: for any conservative factorisation the trace family is the
homotopy fibre of the visible map it induces. `:159` `exact-when-contractible`,
`:164` `contractible-when-exact`: the trace measures exactly the failure of the
visible result to be the whole event. `:181` `canonical`, `:194`
`canonical-recovers`, by `refl`: the source was never left behind.
`fibre/src/Fibre/WholePartialDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic.agda:87`
`देश`, `:93` `गणना`: the census of a question, pointwise over the codomain,
three-valued. As written (`main.c`, `hyper census FILE MAP DOM COD`): the domain
and codomain are given as superpositions of their points; the map is presented
along every point of the domain; over each point of the codomain the fibre is
the domain points whose value is it, and its census is `:88` `नास्ति` (none),
`:89` `सकलादेश` (one), or `:90` `विकलादेश` (two or more, shown). `t/census.hyper`
is the module's own §3, computed: `Unit → Bool` is सकलादेश at `True` and नास्ति
at `False`, `Bool → Unit` is विकलादेश at `Tt`, and their composite is सकलादेश.

Erase: nothing is erased inside a run; a forgotten port is one receipt where it
is forgotten (`t/erase.hyper`: the fibre's size never enters). Commutation is
the certificate that an order was removable:
`fibre/src/Fibre/Order_CommutationIsTheProofThatTheOrderWasNeverThereAndItsFailureIsRetained.agda:102`
`serialisation`.

## 4. What is not here, and why

Removed: `install` as this directory had it (a path between two definitions at
a type, then native dispatch), the parser producing Code, and the reifier. The
first was an invented shape. The corpus's `install` is
`formal/cubical/Kernel/ControlledGrammar.agda:27` `install`, from a
`Derivation`, a trace of steps between two terms, to a `NativeOperation`, and
its own theorems bound it:
`formal/cubical/Kernel/Vyapti_TheInstalledOperationHasNoneSoTheKernelMemorisesAndTheSchemaIsWhatMakesItGeneralise.agda:113`
`fires-only-at-source`, `:176` `kernel-cannot-reach-a-tower`,
`formal/cubical/Kernel/Siddhasadhana_InstallingWhatYouCanAlreadyReachIsAPlateauSoTheKernelsOwnLibraryCannotGrowItsReach.agda:96`
`install-chain-plateau`. In this runtime the derivation of a run is `TRACE`, and
a node once fired is marked with its result (`T_IND`), which is what installing
a run's derivation as a move amounts to here. A grammar's substitution is a
Carrier instance with a base and a carried datum
(`fibre/src/Fibre/Sthanivadbhava_TheAdesasFormIsTheFreeSlotAndItsDesignationsAreCarried.agda`),
not a parser.

## 4b. The encounter of two peers

`formal/cubical/kernel-flat/TheEncounterOfTwoPeersIsOneTraceAndNoScalarProjectionOfItHasASection.agda:123`
`Peer` (a `Session`:
`formal/cubical/kernel-flat/TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation.agda:170`
`Session`, with `origin`, `here`, `trace : Derivation origin here`, `library`;
`:155` `_⊕_`),
`formal/cubical/kernel-flat/TheEncounterOfTwoPeersIsOneTraceAndNoScalarProjectionOfItHasASection.agda:126`
`Encounter` (`A B`, `meeting`, `mine : Derivation (here A) meeting`, `theirs :
Derivation meeting (here B)`), `:138` `τ` (`mine ⊕ theirs`),
`:148` `gain` (the three moves installed), `:153` `A′`, `:158` `B′`, `:164`
`interact` (`A′ E , B′ E , τ E`), `:172` `receive`. Reversal is
`formal/cubical/kernel-flat/TheKernelIsAReversibleGroupoidWhoseJoinIsConflictFreeSoConsensusOnMeaningIsVacuous.agda:119`
`rev`, the length
`formal/cubical/kernel-flat/TheDerivationCarriesNoMeaningAtAllSoAllOfItIsRemainder.agda:126`
`len`.

As written (`main.c`, `hyper meet FILE A B`): a derivation is the receipts of a
run, each a rule at a node (`TRACE`, `TRACE_NODE`), with its endpoints; a run of
a term to its normal form is one. A peer begins at its term (`begin`). The two
peers meet at the normal form both reach, or there is no meeting and the
encounter is refused. `mine` is A's run, `theirs` is the reversal of B's run,
`τ` their concatenation; `A′` stands at B's term with `trace A ⊕ τ` and the three
moves, `B′` at A's term with `trace B ⊕ rev τ`. `t/meet.hyper` computes the
module's sections:
`formal/cubical/kernel-flat/TheEncounterOfTwoPeersIsOneTraceAndNoScalarProjectionOfItHasASection.agda:256`
`the-two-results-need-not-agree` (A′ and B′ stand at different terms, nothing
pending), `:284` `what-crossed-is-what-B-had` and `:320` `the-pair-holds-it-after`
(before the encounter A has no move at the meeting, after it both hold the joint
route, whose endpoints are neither peer's), `:334` `the-prior-trace-is-a-prefix`
(as data), `:341` `undo` (`rev τ`), `:380` `round-trip` with `:389`
`the-round-trip-costs-four` and `:392` `the-round-trip-is-not-done` (here: 2·len τ
steps from `a` to `a`; the meaning is refl, the object is not done), `:409`
`the-fabric-composes-strictly` (concatenation of arrays), `:444`
`the-two-orders-differ` and `:448` `both-orders-cost-the-same` (the crossing:
`cross` under the two schedules reaches the same value in the same number of
receipts with different traces, `HYPER_TRACE=1`), `:474` `the-scalar-is-additive`
(`len (d ⊕ e) = len d + len e`, by construction), `:483`
`no-section-for-any-order-blind-projection` (the count cannot be inverted to the
trace, exhibited by the crossing). Not written: `:542` `the-receipt-does-not-cross`,
which needs a demanded evidence (`demand R d`) this runtime does not yet model.

## 5. Files

    hyper/cell.h             the word layout, tags, frames, constructors, the receipts
    hyper/cell.c             the substrate: heap, frames, instantiation, the interval, the face map,
                             case trees, the HIT schema, numbers, transp, hcomp, Glue, the loop, the ledger, printers
    hyper/read.c             the reader for the kernel's own text
    hyper/verify.c           the checker on the same loop
    hyper/main.c             run | bend | check | interact | census | joint | descends | meet (§2, §3, §4b)
    hyper/prelude.hyper 158  the Kan rows, Glue, transpEquiv, the HIT rows, as data
    hyper/bend.hyper     45  the Bend2 dialect's rows
    hyper/test.sh            the substrate's checks
    hyper/bendtest.sh        values against Bend2's normaliser
    hyper/checktest.sh       verdicts against Bend2's checker
    hyper/cite.sh            every identifier this file names is on the line it cites
