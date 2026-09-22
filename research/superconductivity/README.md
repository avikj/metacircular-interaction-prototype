# Charged coherence and superconductivity

This directory is the persistent working home of Avik Jain's superconductivity investigation. The target remains a physically specified room-temperature superconducting realization. The method is exact mathematical continuation: preserve the original object, the equivalence or reduction, its reconstruction, and every residual that matters to a subsequent question. The related branches are studied over their common physical subject, not as independent successful examples.

These are research notes, not a theorem inventory and not a predetermined conclusion. Definitions, hypotheses, calculations, unsuccessful constructions, literature correspondences, physical source conventions, and the current continuation belong in the text. A reader should be able to resume from the repository without the originating conversation.

## Reading order

- [Charged coherence and superconductivity](CHARGED_COHERENCE_AND_SUPERCONDUCTIVITY.md): the model, finite-gap pair spectrum, projected and engineered-parent many-body constructions, reconstruction and response, bath/mediator/ionic structure, and the open physical continuations.
- [Exact finite-gap pair reduction](FINITE_GAP_PAIR_REDUCTION.md): the general two-flat-level projector reduction, its necessary-and-sufficient fixed-channel condition, and its class-wide binding and mobility equations.
- [Constructive transport and research continuation](CONSTRUCTIVE_TRANSPORT_AND_RESEARCH_CONTINUATION.md): the exact dependent-composition and continuation interfaces underlying the research.
- [Complete paired ground space and exact density response](GROUND_SPACE_AND_DENSITY_RESPONSE.md): continuation from the parent's common annihilator to the complete ground space, exact collective excitations, and the full physical density response at finite gap.
- [Exact-algebra verifier](verification/verify_ground_response.py), [executed results](verification/ground_response_results.json), and [environment and source hashes](verification/environment.json).

## Current mathematical checkpoint

For the connected uniform-diagonal projector parent, the paired tower exhausts the common zero space of the density-difference generators, and the ground state is unique at each allowed even fixed particle number. The same overlap matrix `S_ij = |P_ij|^2` determines an exactly invariant pair-deformation excitation space and the complete zero-temperature physical charge-density response. The latter retains both collective energies `U(p-lambda)` and the interband energy `Delta+Up`, with their derived many-body weights. Full proofs and reconstruction metrics are in the ground-space chapter.

The original onsite model still differs from this parent by its explicit interaction residual. The new density-response theorem does not equate a longitudinal ground-state response with a transverse Meissner kernel or a finite-temperature phase.

## Reproduction

The recorded run used the Python and SymPy versions in `verification/environment.json`. With SymPy available, run from the repository root:

```bash
python research/superconductivity/verification/verify_ground_response.py
```

The script fails on a false assertion and writes `ground_response_results.json` beside itself. All 56 assertions passed in the recorded run. The committed script blob was read back and matched the source actually executed. These are exact finite rational controls supporting the written general arguments.

## Conventions to keep intact

`H_on` is the original finite-gap onsite attractive-Hubbard Hamiltonian. `H_projected` is its strictly lower-band model. `H_parent` is a different finite-gap Hamiltonian whose interaction is built from projected physical fields. They share projector data, not all physical conclusions. The residual `H_on - H_parent` stays explicit.

A wavefunction reconstruction, a zero-temperature ground state, a response function, and a finite-temperature phase are different mathematical outputs. Results are transported between them by an actual derivation, not by replacing their names. All newly derived identities retain their actual physical hypotheses. Exact computation and proof content are work products independently of whether their ultimate materials realization is known.
