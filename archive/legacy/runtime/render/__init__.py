"""Perceptual compilation: CRYSTAL.md §7 REALIZE, the perceptual surface.

`CRYSTAL.md` §2 L3 says every accepted fact may become an execution; §7 adds
that the runtime compiles to *plural* surfaces -- symbolic, executable and
**perceptual**.  This package is the perceptual one, built to the discipline
the rest of the runtime uses for everything else:

    A channel is a projection of one object, with explicit information loss
    and stated round-trip guarantees.  Never an independent semantic copy.
    Never a truth authority.

Concretely, every channel here must produce, by exhaustive check over a
declared state set:

* a **preservation** certificate -- which declared distinctions survive;
* a **loss** certificate with a concrete **collision witness** -- two states
  carrying the same code;
* a **round-trip** certificate -- exact single-valued inverse on a declared
  sublanguage where injectivity is proved, and otherwise ``decode`` returning
  the whole **fibre**, never a guess;
* a **claim** certificate saying whether the channel claims *information gain*
  (always rejected: a channel is a function of state) or *recognition-cost
  reduction* (the only admissible claim, and measured as a machine-side proxy
  that establishes nothing about human vision).

```
runtime/render/channel.py   the abstraction: languages, tasks, fibres, certificates
runtime/render/chroma.py    the chromatic channel: exact colour, five layers, precedence
runtime/render/svg.py       a minimal exact SVG writer, integer geometry, hand written
runtime/demo/render_demo.py the artifacts and the measured report
runtime/tests/test_render.py adversarial tests with planted-false controls
```

Run:

```
python3 runtime/demo/render_demo.py     # writes runtime/demo/out/*.svg
python3 runtime/tests/test_render.py
```

Exact and CPU-only: integers and ``fractions.Fraction``, no float in any
semantic path (asserted by an AST walk in the test suite), no ML, no network,
no randomness.  Imports nothing outside the standard library and nothing from
`runtime/kernel/`, `runtime/crystallize/` or `runtime/distinguish/` -- the
vocabulary of the last is shared on purpose, the code is not.
"""

from __future__ import annotations

from .channel import (
    CLAIM_KINDS,
    INFORMATION_GAIN,
    RECOGNITION_COST,
    Channel,
    ChannelError,
    ClaimCertificate,
    CollisionWitness,
    InjectivityCertificate,
    Language,
    LossCertificate,
    NullCounter,
    PreservationCertificate,
    RoundTripCertificate,
    StepCounter,
    Task,
    ValidationReport,
    certify_claim,
    certify_injectivity,
    certify_loss,
    certify_preservation,
    certify_round_trip,
    product_channel,
    refines,
    restrict,
    validate_channel,
)
from .chroma import (
    AGREEMENT_COLOUR,
    CANONICAL_PRECEDENCE,
    COLOUR_WORDS,
    COMPONENTS,
    DEMO_TOKENS,
    EXCEPTION_COLOUR,
    LAYER_ROLES,
    LEXICAL_TABLE,
    OPPONENT_WEIGHTS,
    SECTORS,
    YELLOW,
    ChromaError,
    ChromaticChannel,
    CHROMA_WEIGHTS,
    DistinguishabilityCertificate,
    Layer,
    PrecedenceCertificate,
    RGB,
    Resolution,
    Token,
    ancestry_layer,
    borrow_chroma,
    borrow_count,
    carry_chroma,
    carry_count,
    carry_ramp,
    categorical_palette,
    certify_distinguishability,
    certify_precedence,
    complement_word,
    digit_language,
    digit_words,
    family_layer,
    from_opponent,
    is_antipalindrome,
    is_constant_word,
    is_palindrome,
    hue_palette,
    klein_orbit,
    lattice_colours,
    layer,
    low_sublanguage,
    low_word_chroma,
    low_word_inverse,
    low_word_palette,
    luma,
    orbit_chroma,
    orbit_size,
    reverse_word,
    round_half_even,
    sector_name,
    sector_palette,
    semantic_layer,
    separation,
    sequential_ramp,
    sort_layer,
    symmetry_layer,
    text_on,
    to_opponent,
    token_chroma,
    token_language,
    value_of,
    word_of,
)
from .svg import SVG, SVGError, escape

__all__ = [
    "AGREEMENT_COLOUR",
    "CANONICAL_PRECEDENCE",
    "CLAIM_KINDS",
    "COLOUR_WORDS",
    "COMPONENTS",
    "CHROMA_WEIGHTS",
    "DEMO_TOKENS",
    "DistinguishabilityCertificate",
    "EXCEPTION_COLOUR",
    "INFORMATION_GAIN",
    "LAYER_ROLES",
    "LEXICAL_TABLE",
    "OPPONENT_WEIGHTS",
    "PrecedenceCertificate",
    "RECOGNITION_COST",
    "RGB",
    "SECTORS",
    "SVG",
    "SVGError",
    "Channel",
    "ChannelError",
    "ChromaError",
    "ChromaticChannel",
    "ClaimCertificate",
    "CollisionWitness",
    "InjectivityCertificate",
    "Language",
    "Layer",
    "LossCertificate",
    "NullCounter",
    "PreservationCertificate",
    "Resolution",
    "RoundTripCertificate",
    "StepCounter",
    "Task",
    "Token",
    "ValidationReport",
    "YELLOW",
    "ancestry_layer",
    "borrow_chroma",
    "borrow_count",
    "carry_chroma",
    "carry_count",
    "carry_ramp",
    "categorical_palette",
    "certify_claim",
    "certify_distinguishability",
    "certify_injectivity",
    "certify_loss",
    "certify_precedence",
    "certify_preservation",
    "certify_round_trip",
    "complement_word",
    "digit_language",
    "digit_words",
    "escape",
    "family_layer",
    "from_opponent",
    "is_antipalindrome",
    "is_constant_word",
    "is_palindrome",
    "hue_palette",
    "klein_orbit",
    "lattice_colours",
    "layer",
    "low_sublanguage",
    "low_word_chroma",
    "low_word_inverse",
    "low_word_palette",
    "luma",
    "orbit_chroma",
    "orbit_size",
    "product_channel",
    "refines",
    "restrict",
    "reverse_word",
    "round_half_even",
    "sector_name",
    "sector_palette",
    "semantic_layer",
    "separation",
    "sequential_ramp",
    "sort_layer",
    "symmetry_layer",
    "text_on",
    "to_opponent",
    "token_chroma",
    "token_language",
    "validate_channel",
    "value_of",
    "word_of",
]
