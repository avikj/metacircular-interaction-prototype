# Charged coherence and superconductivity — research in progress

This directory is the persistent working home of Avik Jain's superconductivity investigation. The target remains a physically specified room-temperature superconducting realization. The method is exact mathematical continuation: preserve the original object, the equivalence or reduction, its reconstruction, and every residual that matters to a subsequent question. The related branches are studied over their common physical subject, not as independent successful examples.

These are research notes, not a theorem inventory and not a predetermined conclusion. Definitions, hypotheses, calculations, unsuccessful constructions, literature correspondences, physical source conventions, and the current continuation belong in the text. A reader should be able to resume from the repository without the originating conversation.

## Reading order

- `CHARGED_COHERENCE_AND_SUPERCONDUCTIVITY.md`: the model, finite-gap pair spectrum, projected and engineered-parent many-body constructions, reconstruction and response, bath/mediator/ionic structure, and the open physical continuations.
- `FINITE_GAP_PAIR_REDUCTION.md`: the general two-flat-level projector reduction, its necessary-and-sufficient fixed-channel condition, and its class-wide binding and mobility equations.
- `CONSTRUCTIVE_TRANSPORT_AND_RESEARCH_CONTINUATION.md`: the exact dependent-composition and continuation interfaces underlying the research.
- `GROUND_SPACE_AND_DENSITY_RESPONSE.md`: continuation from the parent's common annihilator to the complete ground space, exact collective excitations, and the full physical density response at finite gap.
- `verification/verify_ground_response.py`: reproducible finite exact-algebra controls for the ground-space and response continuation, with its written general proofs in the accompanying note.

## Conventions to keep intact

`H_on` is the original finite-gap onsite attractive-Hubbard Hamiltonian. `H_projected` is its strictly lower-band model. `H_parent` is a different finite-gap Hamiltonian whose interaction is built from projected physical fields. They share projector data, not all physical conclusions. The residual `H_on - H_parent` stays explicit.

A wavefunction reconstruction, a zero-temperature ground state, a response function, and a finite-temperature phase are different mathematical outputs. Results are transported between them by an actual derivation, not by replacing their names. All newly derived identities retain their actual physical hypotheses. Exact computation and proof content are work products independently of whether their ultimate materials realization is known.

## Provenance

The initial research notebook and continuations were produced in conversation on September 16, 2026, with repository mathematics anchored to `e0e4623c03a5a1a0afa17ca271bf6bbb3cacbf63`. The repository was read at `8b02225e1ca128e72f3509b51ff3bed0a2950ba9` before this import. The imported manuscript is developed into the descriptively named chapters above; no prior repository mathematical module is replaced.

User direction: superconductivity remains the exact central problem. Discussion of the general method must not displace the physical calculation. Continue all compatible mathematical branches, retain complete derivations rather than outcome-only summaries, and write the work here as it develops.
