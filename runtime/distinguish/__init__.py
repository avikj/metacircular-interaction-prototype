"""Distinction compilation: CRYSTAL.md §3.2, exact and CPU-only.

Self-contained.  Imports nothing outside the Python standard library and
nothing from `runtime/kernel/` or `runtime/crystallize/`.

Entry points:

* ``DigitWordSystem``            -- the base-``b`` digit-word system of
                                   `notes/DIGIT_CRYSTAL.md` §0-§1
* ``SignatureOracle``            -- bounded-depth task equivalence
* ``find_collisions``            -- CRYSTAL.md §3.2 step 3
* ``minimum_cardinality_set``    -- step 4, exact minimum cardinality
* ``greedy_set``                 -- step 4, greedy with a stated bound
* ``moore_refine``               -- step 4/5, exact partition refinement
* ``check_sufficient``           -- step 5, sufficiency proof
* ``check_coarsest``             -- step 5, coarseness proof
* ``inclusion_minimal_set``      -- step 6, redundant-channel removal
* ``compile_distinctions``       -- the whole loop, with exact step counts
"""

from __future__ import annotations

from .channels import (
    ChannelSearchResult,
    PairRequirement,
    PartitionRequirement,
    SearchBudgetExceeded,
    alternating_sum_mod_channel,
    channel_values,
    digit_channel,
    digit_sum_mod_channel,
    greedy_set,
    harmonic_bound_numerator_denominator,
    harmonic_ceiling,
    inclusion_minimal_set,
    is_inclusion_minimal,
    minimum_cardinality_set,
    palindrome_channel,
    prime_powers_dividing,
    residue_channel,
    reversed_residue_channel,
    standard_library,
    valuation_channel,
    zero_count_channel,
)
from .observe import (
    Channel,
    Collision,
    DigitWordSystem,
    FiniteSystem,
    NullCounter,
    Observation,
    SignatureOracle,
    StepCounter,
    Task,
    build_digit_system,
    drive_states,
    find_collisions,
    horner_mod,
    observation_blocks,
    truncation_length,
)
from .refine import (
    CoarsenessReport,
    CompiledRepresentation,
    CompileReport,
    CompileRound,
    Quotient,
    RawEngine,
    RefinementResult,
    SufficiencyReport,
    build_compiled_representation,
    build_quotient,
    check_coarsest,
    check_sufficient,
    compile_distinctions,
    distinguishing_word,
    merge_blocks,
    moore_refine,
    refines,
    renumber,
)

__all__ = [
    "Channel",
    "ChannelSearchResult",
    "CoarsenessReport",
    "Collision",
    "CompileReport",
    "CompileRound",
    "CompiledRepresentation",
    "DigitWordSystem",
    "FiniteSystem",
    "NullCounter",
    "Observation",
    "PairRequirement",
    "PartitionRequirement",
    "Quotient",
    "RawEngine",
    "RefinementResult",
    "SearchBudgetExceeded",
    "SignatureOracle",
    "StepCounter",
    "SufficiencyReport",
    "Task",
    "alternating_sum_mod_channel",
    "build_compiled_representation",
    "build_digit_system",
    "build_quotient",
    "channel_values",
    "check_coarsest",
    "check_sufficient",
    "compile_distinctions",
    "digit_channel",
    "digit_sum_mod_channel",
    "distinguishing_word",
    "drive_states",
    "find_collisions",
    "greedy_set",
    "harmonic_bound_numerator_denominator",
    "harmonic_ceiling",
    "horner_mod",
    "inclusion_minimal_set",
    "is_inclusion_minimal",
    "merge_blocks",
    "minimum_cardinality_set",
    "moore_refine",
    "observation_blocks",
    "palindrome_channel",
    "prime_powers_dividing",
    "refines",
    "renumber",
    "residue_channel",
    "reversed_residue_channel",
    "standard_library",
    "truncation_length",
    "valuation_channel",
    "zero_count_channel",
]
