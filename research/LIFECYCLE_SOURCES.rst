====================================
Lifecycle: executable source anchors
====================================

Companion to `Lossless Interdependent Type Theory <../LIFECYCLE.rst>`_.

Source snapshot: ``6a215a121e08f710393f570abfac58513d53eecc``.
Recorded September 14, 2026, America/Los_Angeles.

This is a focused reading map, not a claim to inventory every ecological or
biological module. Each entry distinguishes what the definitions construct
from the larger interpretation they inform. The addition itself is
source-linked documentation; no new proof or native run is claimed.

1. The carrier and the whole orbit
=================================

`Fibre.Carrier <../fibre/src/Fibre/Carrier.agda>`_
    ``Carrier``, ``descend``, ``ascend``, ``Carrier‚â``, ``Carrier‚â°``,
    ``carry-transport-descend``, ``Œ¶-carrier``, ``Œ¶-square``.

    A source carries its image and its determining path. The presentation is
    equivalent to the source; the lifted endomorphism commutes with descent.
    Contractibility applies to the output-binding singleton, not to an
    arbitrary preimage fibre. This is presentation losslessness, not a theorem
    that every original state transition is injective.

`Fibre.Nucleus <../fibre/src/Fibre/Nucleus.agda>`_
    ``descend-orbit``, ``ascend-orbit``, ``transport-orbit``, ``orbit-lookup``.

    Corecursive bisimulations become paths of whole orbits. The transport
    version uses ``carry-transport-descend`` at the head. This is the explicit
    composition of the fibre-law presentation with coinductive evolution.

`Fibre.JivitaSmrti <../fibre/src/Fibre/JivitaSmrti.agda>`_
    ``‡‡‡µ‡ø‡‡æ-‡‡‡Æ‡‡‡ø`` (jivita-smrti, living memory).

    At depth ``n``, the carried reading of the ``Fibre.Viveka`` orbit is the
    reading of the corresponding iterated state. This is a concrete
    current-state coherence theorem, not a general theorem about caches or
    biological recall.

2. Interactive self-presentation
===============================

`Fibre.Samvada <../fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda>`_
    ``ISC``, ``react``, ``visit``, ``continue``, ``observe``.

    ``react`` returns a successor, a successor-indexed observation, its event
    content, and ``ISC`` at that successor. Finite observation consumes finite
    demand. The continuing process is not the resulting list of observations.

`Fibre.CorpusSamvada <../fibre/src/Fibre/CorpusSamvada.agda>`_
    ``Point``, ``Question``, ``target``, ``run``.

    ``Point = Sigma(A : Type). A``; a question contains a target type and a
    typed map from the current carrier. ``target`` applies that map. Thus the
    next state's type can change. A raw string is not automatically a value of
    this question type; its interpretation must be supplied by an actual
    construction rather than inferred from the notation.

`CorpusSelfPresentation <../formal/cubical/theorems/residue/CorpusSelfPresentation.agda>`_
    ``Event``, ``SelfPresentation``, ``present``.

    Its reaction retains ``LP.current-residual s q`` and recurs at
    ``C.target s q``. The source's universe lift is part of its actual type.
    Read with `CorpusLosslessPresentation
    <../formal/cubical/theorems/residue/CorpusLosslessPresentation.agda>`_,
    which supplies the residual of the actual query.

3. Two precise faces of interdependence
======================================

`Parasparasraya <../formal/cubical/theorems/logic/Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive.agda>`_
    ``Dhr``, the mutual ``jina``/``ajina`` definitions, ``dvicakram``;
    ``Parasparraya``, ``yugma``, ``dvitya-payati``,
    ``na-ekkin‚``, ``na-ekkin‚``.

    The mutual streams exhibit guarded production. Separately, the general
    observation record supplies individual blind pairs and joint faithfulness;
    its laws prohibit replacing either necessary observation with a constant.
    Productive recursive dependence and joint observational sufficiency are
    both present, but they are not asserted to be definitionally the same type.

`Jiva: joint dependence and the living step <../formal/cubical/theorems/logic/Jiva_EntanglementIsTheFibreOfTheProductComparisonAndTheLivingStepRefusesToDescendToTheMarginals.agda>`_
    ``‡‡‡≤‡®‡æ`` (comparison), ``‡‡‡ï‡≤‡®‡Æ‡`` (total-space reconstruction),
    ``‡‡‡µ‡®-‡‡¶‡Æ‡`` (living step), ``‡Ø‡‡ó‡≤‡Æ‡-‡â‡‡Ø‡‡`` (two-sided descent
    characterization), ``‡‡‡µ‡‡ø`` (visible non-descent),
    ``‡¶‡ï‡‡‡ø‡-‡µ‡ø‡≤‡Ø‡`` (environment-side descent), ``‡‡‡µ‡®-‡¶‡‡µ‡ø‡``
    (involution), ``‡‡‡‡®‡æ-‡‡Æ‡‡ï‡∞‡‡Æ‡`` (equivalence).

    The generic comparison ``J -> A ó B`` has an exact fibre completion.
    Its examples distinguish missing combinations from hidden distinctions.
    For the controlled-not update on ``Bool ó Bool``, the visible update
    cannot be computed from the visible input alone, while the environment
    projection descends and the complete update is an equivalence.

    The term ``living`` names that declared mathematical dependence criterion.
    It does not make classical Boolean correlation a quantum amplitude or
    assert a sufficient empirical criterion for biological life. The product
    state example also shows why coupled dynamics and a non-product state
    presentation must not be confused.

4. Development and retained organization
=======================================

`JivaSantana <../formal/cubical/theorems/physics/JivaSantana_IdentityThroughChangeIsASectionThroughAChangingFamilyNotEqualityOfSnapshots.agda>`_
    ``Jiva``, ``chase``, ``biography``, ``Fate``.

    For supplied ``W : Nat -> Type`` and transitions ``tau``, a coherent
    section is reconstructed from its origin along those transitions. The
    worlds need not have equal types, and ``tau`` need not be an equivalence.
    The theorem is about forward generation of the biography, not inversion
    of arbitrary transitions or prediction of unspecified future input.

    ``Fate`` has transported/restricted/refuted/split/unresolved constructors.
    ``Lossless Claims = Claims -> Fate`` is an accounting interface: it does
    not, by a tag alone, provide a decoder for every old claim or implement
    every transition span discussed in the header.

`SariraStara <../formal/cubical/theorems/physics/SariraStara_TheCountStratumOfTheHeartbeatIsProvablyBlindToTheBodysLawOfSuccession.agda>`_
    ``mismatch-NONE``, ``‡‡‡‡∞‡‡‡¶‡`` (law-stratum distinction),
    ``‡‡∞‡‡∞‡‡‡‡∞‡`` (nonfactorization), ``‡ó‡‡®‡æ‡‡æ‡Æ‡‡Ø‡-‡®-‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡``
    (count agreement is not identity).

    Two succession laws on the shared carrier have the same count-stratum
    observation and a separating law-sensitive observation. No post-processing
    of the former recovers the latter. The existing module states that the
    associated Haskell heartbeat extension is separate engineering; this map
    does not report that extension as executed.

5. Recombination, installation, and continued propagation
=======================================================

`SamasaSetu <../formal/cubical/theorems/walks/SamasaSetu_TheChildEdgeIsTheCompositionOfTwoParentFordsSexualNotAsexual.agda>`_
    ``‡‡Æ‡æ‡-‡‡‡‡‡`` (samasa-setu, the recombined connection).

    The term is ``compEquiv ‡µ‡ø‡µ‡‡ï‚â‡µ‡æ‡‡ï‡ ‡‡‡‡‡``: two existing equivalences
    share ``Carrier ‡Ø‡ã‡ó`` and compose into a connection between their outer
    endpoints. The biological vocabulary motivates recombination rather than
    cloning; the executable statement is the exhibited composition. This
    file does not implement genetic mutation or an autonomous mating policy.

`IntrinsicRewrite <../formal/cubical/kernel/IntrinsicRewrite.agda>`_
    ``Run``, ``result``, ``run-sound``, ``Weave``, ``view``, ``install``.

    Executable motions and lawful composition are constructors of the same
    indexed object. A retained run is reweaved through a locus; installation
    splices a delta into that run. Inspect the installation/view compatibility
    in the source rather than replacing it with a separately invented graph.

`Contextual installation <../formal/cubical/kernel/TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass.agda>`_
    ``sub-derivation``, ``weave-derivation``, ``Operation``,
    ``apply-checked``, ``pervading``, ``learn``, ``retire``,
    ``learn-generalises``, ``retire-generalises``.

    Applicability carries the substitution instance, locus, and identification
    with the source at that site. The derivation travels through those actions.
    ``learn`` and ``retire`` retain the executed/session derivation as a
    pervading operation. Generalization uses the schema already in that
    derivation; it is not induction of an unsupported universal law from an
    arbitrary ground observation.

`ProductiveIndraNet <../formal/cubical/theorems/unplaced/ProductiveIndraNet.agda>`_
    ``Net``, ``propagate``, ``Bisim``, ``propagate-bisim``, ``observe-bisim``.

    A net has its current ``TotalView`` and a coinductive next net. Local
    reweaving acts on each layer; propagation respects the given bisimulation.
    The current ``Net`` is a stream-shaped interface, not the general
    request-dependent branching ``ISC``. Its particular pulse is periodic;
    that example does not impose periodicity on every lifecycle.

`IntrinsicProductiveInstall <../formal/cubical/kernel/IntrinsicProductiveInstall.agda>`_
    ``installedRun``, ``installedRun-result``, ``installedNet``,
    ``installed-three``, ``installed-earliest``, ``installed-audit``.

    This is an actual import-level bridge: intrinsic delta installation is
    read at two supported loci and propagated into a productive net. It
    exhibits the earliest observer disagreement after that installation.
    The local action recognizes the two stated source forms; it is not a
    generic population or ecology simulator.

6. Ecological evaluation and representational trust
=================================================

`SelfImprovement <../formal/cubical/theorems/grammar/SelfImprovement.agda>`_
    ``Population``, ``Evaluation``, ``identityOf``, ``Edit``, ``apply``;
    the identity-preservation, transport, and evaluator-quarantine sections.

    Genotype identity, environment, evaluator, and score remain separate.
    Re-scoring cannot generate a new genotype; edits retain the relevant
    provenance of surviving subjects. Evaluation transport needs its stated
    invariance witness; observed agreement is insufficient.

    ``Genotype`` identity is a supplied decision procedure, not a content hash
    proved collision-free here. The edit grammar permits discard. Its header
    explicitly does not claim population turnover, selection, epochs, or
    coevolution. It references an earlier ``ECOLOGY.md``; this map uses the
    source-visible claims and does not invent the missing text of that note.

`EvaluatorTransport <../formal/cubical/theorems/physics/EvaluatorTransport.agda>`_
    ``transportEvaluator``, ``transportEvaluator-preserves``,
    ``transportEvaluator-unique``, ``EvaluationFrame``,
    ``transportEvaluation-invariant``, ``fixed-evaluator-killer``.

    Along ``e : A ‚â B``, the candidate moves by ``e`` and the evaluator by
    precomposition with ``inverse(e)``. All paired results are conserved, and
    that conservation determines the evaluator transport uniquely. Moving
    only the candidate need not conserve a fixed score. The result is about
    the exact supplied evaluation, not empirical fitness in an unspecified
    environment.

7. Native cubical coinduction and integrated execution
=====================================================

`Carrier.bend <../collab/bend2-interactive-cubical/port/Carrier.bend>`_
    ``Carrier``, ``descend``, ``ascend``, ``CarrierPath``,
    ``carry_transport``, and the lifted step laws.

`coinduction.bend <../collab/bend2-interactive-cubical/coinduction.bend>`_
    ``Answers``, ``IExec``, ``forgetStates``, ``replay``,
    ``forgetReplay``, ``replayForget``, ``stateAt``.

    Continuing records and corecursive paths are present in the Bend source.
    Read the associated `coinduction account
    <../collab/bend2-interactive-cubical/COINDUCTION.md>`_ for the declared productivity
    discipline; do not regress to a finite-depth encoding as the only object.

`supline.bend <../collab/bend2-interactive-cubical/supline.bend>`_
    ``supLine``, ``sup_transport``.

    The type line, transported value, and branch are correlated. Ordinary
    variables, cubical dimensions, and SUP labels have different roles.

`PUSC <../collab/bend2-interactive-cubical/PUSC.md>`_ and
`full runtime <../collab/bend2-interactive-cubical/RUNTIME_FULL.md>`_
    The integrated architecture and its source/runtime correspondence.
    Preserve the distinction between executable compatibility constructions,
    recorded native runs, and an independently established global metatheorem.
    This documentation update runs none of the native suite.

8. Prior biological orientation
================================

`Lossless Information Dynamics: biology-facing paper
<../papers/for_michael_levin_a_computable_platonic_foundation.tex>`_
    The sections on life, biography, regulatory regimes, organization,
    metacircular competence, and multiscale interaction are prior explicit
    context for the lifecycle reading. The paper's broader physical and
    empirical interpretations are not silently used as stronger conclusions
    of the terms above. Regulatory/therapy passages, for example, need their
    stated mathematical models and empirical grounding; this map makes no
    medical claim.

How to continue this work
=========================

The primary object is the productive lifecycle. Preserve its actual inputs,
residuals, dependent states, and generated operations together. Follow existing
imports and eliminators before introducing another representation. Record the
mathematical condition under which a proposed view, factorization, or evaluator
transport is valid. Do not replace the source constructions with a toy parser,
genetic algorithm, ecology simulation, or expected-answer demonstration.

Ecology and mathematical biology belong at the center of the computational
account because these sources already address consultation, development,
organization, recombination, evaluation context, and continued propagation.
Their exact equations and constructors, rather than a resemblance of pictures,
are what this reading map preserves.
