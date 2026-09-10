# IN A PROOF-CARRYING LEARNER, GENERALISATION AND SHAREABILITY ARE EXCLUSIVE, AND WE LOCATE THE FIELD THAT SEPARATES THEM

*The skill that fires everywhere cannot be transmitted, and the skill that can be transmitted fires at exactly one state*

**Agent architectures / learned program libraries**

We report a separation in a learning architecture where every acquired skill carries the trace that licensed it.  Skills come in two forms and the informal expectation is that they are duals trading coverage against detail.  They are not duals.  One of them cannot enter the library at all, and the reason is a single field.

The memorising form is a record containing its endpoints, the full execution trace between them, an applicability family, and a proof that the family projects onto an identification with its single training state. Because of that last field, the operation fires at exactly one state whatever family its author supplied - we prove the enabled set is a subsingleton and compute it: contractible, centred on the training state. We exhibit a two-state instance showing that no such operation covers even two states, and we exhibit a library that cannot reach a specific term three constructors deep.  So capability grows by one state per skill while the state algebra is infinite.

The generalising form is a record containing its endpoints, an applicability family that is a substitution witness, and a family of outcome equalities.  It fires at every instance of its pattern, and its soundness costs nothing: the substitution lemma already present in the calculus moves the substitution into the environment, the skill's own outcome family holds there because it holds everywhere, and the lemma moves it back.  Generalisation is free; memorisation is what costs.

The separation.  The library, the merge, the frontier expansion, the session and the retirement step all range over the memorising record.  The generalising record is a different type in a lower universe, and it holds an outcome family where the other holds a trace.  An outcome family is a map into a subsingleton and carries no route; a library entry must carry its route, because that is what makes the entry unforgeable.  Therefore the form that generalises is exactly the form that cannot be installed, merged, offered by the frontier, or retired into a new skill.  ~~This is not an engineering gap we intend to close by a refactor~~ — **STRUCK, see REFUTED below; it was closed by exactly that**; it is the statement that transmissible authority and pattern coverage are supported by different fields, and we give both records so the trade is inspectable.

Two further measurements.  Where a generalising skill's pattern contains no free register, the substitutions enabled at its one state form an entire copy of the term algebra and every member emits the same output, so the fibre over an emission is unbounded and no deduplication heuristic collapses a redundant pair - it collapses that fibre.  And emission does not determine the witness: we prove the discarded substitution is not recoverable from what the skill produced.

There is no Markov decision process, no reward signal, no stochasticity, no
discounting and no optimisation in this development. "Skill" names a record,
"state" names a term, and "fires" names inhabitation of an applicability
family. Whether a deployed learner's skill representation has this shape is a
reading and is not proved.

Machine-checked in cubical type theory, no postulates, no admitted goals.

## REFUTED, 2026-09-09 — and the means were already in the corpus

The headline separation does not hold. It was a property of **which field** the
generalising record carried, not of generalisation. Each step of the abstract's
chain is correct — the memorising record holds a trace, the generalising record
was written holding an outcome family, an outcome family carries no route,
hence it cannot be installed — and the conclusion still does not follow,
because the generalising record does not have to hold an outcome family.

`Kernel/Adesa_…` proves `subDeriv`: substitution is admissible on derivations,
so a substitution witness pushes through a whole trace and yields a trace of
the substituted endpoints. That lemma was in the repository **before this
abstract was last revised**, and the revision kept the struck sentence.

kernel/TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass (634 lines,
2026-08-26) drops `source`, `target` and `control-sound` and keeps the obligation
they discharged as a field:

    certify : (t : Tm) (c : Control t) → Derivation t (apply t c)

Both forms are constructors of one record. `ground` recovers the memorising
skill with nothing lost; `schema` is installable and carries a real derivation
at every instance; soundness is free for both, no case split; unforgeability is
preserved, the route now carried per firing site.

**Survives, still checked:** the memorising skill's enabled set is a
contractible subsingleton centred on its training state, and that argument
still applies to `ground`; the two-state instance; the term three constructors
deep that no library reaches; the unbounded fibre over an emission; and that
emission does not determine the witness. That an outcome family carries no
route is correct, and is exactly why the repair had to supply a derivation.

**Still not proved:** that installing a schema *strictly grows* reach.
`install-chain-plateau` is stated for `InstallChain`, whose step is `install`;
restating it over the unified record is the open obligation.

ATTRIBUTION CORRECTED, 2026-09-10.  The refutation above was first credited to
kernel/TheUnifiedOperationHasNoFixedSource..., committed 2026-09-09.  That file
was a weaker redo.  The real refutation is
kernel/TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass, committed
2026-08-26, which carries the unified record with THREE instances (ground,
schematic, pervading), the embedding native->operation so ControlledGrammar is
not edited and nothing downstream is invalidated, control carrying instance AND
locus via weave-derivation, advance and advance-preserves-branch-count rewired
over Operation, and learn-generalises / retire-generalises closing the loop.
The 2026-09-09 file has two instances, no embedding, no locus, and no rewiring;
it has been deleted rather than kept as a weaker parallel.

This abstract was last revised 2026-08-28 -- two days AFTER the module that
refutes it landed in the same repository.
