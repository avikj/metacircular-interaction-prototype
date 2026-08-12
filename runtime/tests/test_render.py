#!/usr/bin/env python3
"""Adversarial tests for `runtime/render/`, with planted-false controls.

Run:  python3 runtime/tests/test_render.py
      (or: python3 -m unittest discover -s runtime/tests)

The design principle, per `collab/PROTOCOL.md` §7 and the sibling suites: a
checker that only ever sees correct input has not been tested.  Every claim the
package makes is paired here with a deliberately WRONG artifact that the
package MUST reject.  Those are the ``test_planted_*`` tests; if the package
ever stops rejecting them it is broken even if everything else passes.

The planted-false controls the design requires, and where they are:

1. ``test_planted_injective_channel_with_a_collision`` -- a channel that
   *declares* injectivity and has a collision.  The exhaustive check must catch
   it, must return the lexicographically first witness, and ``decode_exact``
   must refuse to run.
2. ``test_planted_lossy_decode_returns_a_single_value`` -- a subclass whose
   ``decode`` returns one state instead of the fibre.  ``validate_channel``
   must catch it on both the type and the partition test.
3. ``test_planted_precedence_violation_lexical_over_semantic`` -- a chromatic
   channel wired with the lexical layer above the semantic one, so that "blue"
   renders yellow.  ``certify_precedence`` must catch it twice: on the
   canonical-order check and on the semantic-dominance check.
4. ``test_planted_float_is_caught_by_the_scanner`` -- the AST float scanner is
   itself checked against a file containing a float, so that
   ``test_no_floating_point_in_the_package`` passing means something.
5. ``test_planted_information_gain_claim_is_rejected`` -- a channel claiming to
   add information.  Rejected as a theorem about functions.
6. ``test_planted_wrong_inverse`` -- an implemented inverse that returns the
   wrong preimage.  The round-trip certificate must fail.
7. ``test_planted_distinguishability_claim_on_a_colliding_task`` -- a task the
   channel cannot separate; the certificate must report violations with a
   witness rather than declaring success.
"""

from __future__ import annotations

import ast
import hashlib
import os
import subprocess
import sys
import tempfile
import unittest
import xml.etree.ElementTree as ElementTree
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
RUNTIME = os.path.dirname(HERE)
REPO = os.path.dirname(RUNTIME)
sys.path.insert(0, RUNTIME)

from render import (  # noqa: E402
    INFORMATION_GAIN,
    RECOGNITION_COST,
    RGB,
    SVG,
    Channel,
    ChannelError,
    ChromaError,
    ChromaticChannel,
    Language,
    SVGError,
    StepCounter,
    Task,
    borrow_chroma,
    borrow_count,
    carry_chroma,
    carry_count,
    categorical_palette,
    certify_claim,
    certify_distinguishability,
    certify_injectivity,
    certify_loss,
    certify_precedence,
    certify_preservation,
    certify_round_trip,
    complement_word,
    digit_language,
    digit_words,
    from_opponent,
    hue_palette,
    is_antipalindrome,
    is_constant_word,
    is_palindrome,
    klein_orbit,
    layer,
    low_sublanguage,
    low_word_chroma,
    low_word_inverse,
    orbit_chroma,
    product_channel,
    refines,
    restrict,
    reverse_word,
    round_half_even,
    sector_name,
    separation,
    sequential_ramp,
    text_on,
    to_opponent,
    token_chroma,
    validate_channel,
    value_of,
    word_of,
)
from render.chroma import COLOUR_WORDS, DEMO_TOKENS, LEXICAL_TABLE, Token, YELLOW  # noqa: E402

BASE = 4
LENGTH = 4


def digit_fixture(base: int = BASE, length: int = LENGTH):
    language = digit_language(base, length)
    return language, carry_chroma(base, length, language)


# --------------------------------------------------------------------------
# 1. exact colour: the opponent space is a bijection on integer colours
# --------------------------------------------------------------------------


class TestExactColour(unittest.TestCase):

    def test_opponent_round_trip_is_exact_on_the_whole_cube_sample(self):
        """Forward then inverse is the identity on every lattice colour, exactly."""
        for colour in [RGB(r, g, b) for r in (0, 51, 102, 153, 204, 255)
                       for g in (0, 51, 102, 153, 204, 255)
                       for b in (0, 51, 102, 153, 204, 255)]:
            y, co, cg = to_opponent(colour)
            back, clamped = from_opponent(y, co, cg)
            self.assertEqual(back, colour)
            self.assertFalse(clamped)

    def test_opponent_round_trip_is_exact_on_every_grey_and_primary(self):
        for value in range(256):
            for colour in (RGB(value, value, value), RGB(value, 0, 0), RGB(0, value, 0), RGB(0, 0, value)):
                y, co, cg = to_opponent(colour)
                back, _ = from_opponent(y, co, cg)
                self.assertEqual(back, colour)

    def test_opponent_coordinates_are_fractions_never_floats(self):
        for part in to_opponent(RGB(17, 200, 3)):
            self.assertIsInstance(part, Fraction)

    def test_round_half_even_matches_the_definition(self):
        cases = (
            (Fraction(1, 2), 0),
            (Fraction(3, 2), 2),
            (Fraction(5, 2), 2),
            (Fraction(-1, 2), 0),
            (Fraction(-3, 2), -2),
            (Fraction(7, 3), 2),
            (Fraction(-7, 3), -2),
            (Fraction(4), 4),
        )
        for value, expected in cases:
            self.assertEqual(round_half_even(value), expected, value)

    def test_out_of_gamut_composition_clamps_and_says_so(self):
        colour, clamped = from_opponent(Fraction(300), Fraction(200), Fraction(0))
        self.assertTrue(clamped)
        self.assertLessEqual(max(colour.as_tuple()), 255)

    def test_rgb_rejects_non_integers_and_out_of_range(self):
        with self.assertRaises(ChromaError):
            RGB(0, 0, 256)
        with self.assertRaises(ChromaError):
            RGB(-1, 0, 0)
        with self.assertRaises(ChromaError):
            RGB(True, 0, 0)

    def test_separation_is_exact_symmetric_and_zero_only_on_equality(self):
        a, b = RGB(10, 20, 30), RGB(200, 5, 90)
        self.assertIsInstance(separation(a, b), Fraction)
        self.assertEqual(separation(a, b), separation(b, a))
        self.assertEqual(separation(a, a), Fraction(0))
        self.assertGreater(separation(a, b), Fraction(0))

    def test_text_on_picks_the_readable_ink(self):
        self.assertEqual(text_on(RGB(255, 255, 255)), RGB(0, 0, 0))
        self.assertEqual(text_on(RGB(0, 0, 0)), RGB(255, 255, 255))

    def test_palettes_are_deterministic_and_injective(self):
        for _ in range(2):
            self.assertEqual(categorical_palette(8), categorical_palette(8))
        for size in (2, 4, 8, 16):
            palette = categorical_palette(size)
            self.assertEqual(len(set(palette)), size)
            hues = hue_palette(size)
            self.assertEqual(len(set(hues)), size)
            chroma_keys = set((to_opponent(c)[1], to_opponent(c)[2]) for c in hues)
            self.assertEqual(len(chroma_keys), size, "hue palette must survive a layer claiming Y")

    def test_sequential_ramp_is_injective_and_ordered_in_luma(self):
        ramp = sequential_ramp(5, RGB(0, 51, 102), RGB(255, 255, 204))
        self.assertEqual(len(set(ramp)), 5)
        lumas = [to_opponent(colour)[0] for colour in ramp]
        self.assertEqual(lumas, sorted(lumas))


# --------------------------------------------------------------------------
# 2. the channel abstraction and its certificates
# --------------------------------------------------------------------------


class TestChannelDiscipline(unittest.TestCase):

    def test_decode_returns_the_fibre_and_the_fibres_partition_the_language(self):
        language, chroma = digit_fixture()
        channel = chroma.channel()
        report = validate_channel(channel)
        self.assertTrue(report.ok, report.failures)
        covered = []
        for code in channel.image():
            fibre = channel.decode(code)
            self.assertIsInstance(fibre, tuple)
            covered.extend(fibre)
        self.assertEqual(sorted(covered), sorted(language.states))

    def test_decode_of_an_unseen_code_is_empty_not_a_guess(self):
        _, chroma = digit_fixture()
        channel = chroma.channel()
        self.assertEqual(channel.decode(RGB(1, 2, 3)), ())

    def test_loss_certificate_carries_a_replayable_collision_witness(self):
        _, chroma = digit_fixture()
        channel = chroma.channel()
        certificate = certify_loss(channel)
        self.assertTrue(certificate.lossy)
        witness = certificate.witness
        self.assertIsNotNone(witness)
        self.assertNotEqual(witness.left, witness.right)
        self.assertEqual(channel.encode(witness.left), channel.encode(witness.right))
        self.assertEqual(channel.encode(witness.left), witness.code)

    def test_fibre_sizes_match_the_closed_form_for_the_carry_channel(self):
        """#{w : c_n(w) = k} = (b-1) b^(n-1-k) for k < n, and 1 for k = n."""
        language, chroma = digit_fixture()
        channel = chroma.channel()
        counts = {}
        for word in language.states:
            counts[carry_count(word, BASE)] = counts.get(carry_count(word, BASE), 0) + 1
        for k in range(LENGTH):
            self.assertEqual(counts[k], (BASE - 1) * BASE ** (LENGTH - 1 - k))
        self.assertEqual(counts[LENGTH], 1)
        self.assertEqual(sum(counts.values()), BASE ** LENGTH)
        self.assertEqual(certify_loss(channel).image_size, LENGTH + 1)

    def test_injective_channel_round_trips_exactly_on_the_declared_sublanguage(self):
        language = digit_language(BASE, LENGTH)
        chroma = low_word_chroma(BASE, LENGTH, language)
        low = low_sublanguage(BASE, LENGTH, language)
        channel = restrict(
            chroma.channel(), low, name="low", declares_injective=True, inverse=low_word_inverse(BASE, LENGTH)
        )
        certificate = certify_injectivity(channel)
        self.assertTrue(certificate.injective)
        self.assertTrue(certificate.honest)
        trip = certify_round_trip(channel)
        self.assertTrue(trip.inverse_implemented)
        self.assertTrue(trip.inverse_exact)
        self.assertIsNone(trip.failure)
        for word in low.states:
            self.assertEqual(channel.decode_exact(channel.encode(word)), word)
            self.assertEqual(channel.decode(channel.encode(word)), (word,))

    def test_the_same_channel_is_lossy_on_the_ambient_language(self):
        """One object seen twice, not two channels telling different stories."""
        language = digit_language(BASE, LENGTH)
        chroma = low_word_chroma(BASE, LENGTH, language)
        channel = chroma.channel()
        self.assertFalse(certify_injectivity(channel).injective)
        certificate = certify_loss(channel)
        self.assertEqual(certificate.image_size, BASE * BASE)
        self.assertEqual(certificate.max_fiber, BASE ** (LENGTH - 2))
        witness = certificate.witness
        self.assertEqual(witness.left[:2], witness.right[:2])
        self.assertNotEqual(witness.left, witness.right)

    def test_preservation_counts_the_four_populations_and_they_sum(self):
        language, chroma = digit_fixture()
        channel = chroma.channel()
        task = Task("carry", lambda word, c: carry_count(word, BASE))
        certificate = certify_preservation(channel, task)
        total = (
            certificate.required_separations
            + certificate.violations
            + certificate.permitted_collisions
            + certificate.over_separations
        )
        self.assertEqual(total, certificate.pairs_checked)
        self.assertEqual(certificate.pairs_checked, 256 * 255 // 2)
        self.assertTrue(certificate.preserved)
        self.assertEqual(certificate.violations, 0)
        self.assertEqual(certificate.over_separations, 0)

    def test_task_relativity_the_same_channel_fails_a_finer_task_with_a_witness(self):
        language, chroma = digit_fixture()
        channel = chroma.channel()
        finer = Task("value", lambda word, c: value_of(word, BASE))
        certificate = certify_preservation(channel, finer)
        self.assertFalse(certificate.preserved)
        self.assertGreater(certificate.violations, 0)
        witness = certificate.violation_witness
        self.assertNotEqual(value_of(witness.left, BASE), value_of(witness.right, BASE))
        self.assertEqual(channel.encode(witness.left), channel.encode(witness.right))

    def test_product_channel_refines_both_factors(self):
        language = digit_language(BASE, LENGTH)
        left = carry_chroma(BASE, LENGTH, language).channel()
        right = low_word_chroma(BASE, LENGTH, language).channel()
        product = product_channel(left, right)
        self.assertTrue(refines(product, left))
        self.assertTrue(refines(product, right))
        self.assertFalse(refines(left, product))

    def test_restrict_refuses_states_outside_the_parent_language(self):
        language = digit_language(BASE, LENGTH)
        channel = carry_chroma(BASE, LENGTH, language).channel()
        alien = Language("alien", ((9, 9, 9, 9),))
        with self.assertRaises(ChannelError):
            restrict(channel, alien)

    def test_encoding_a_state_outside_the_language_is_refused(self):
        language = digit_language(BASE, LENGTH)
        channel = carry_chroma(BASE, LENGTH, language).channel()
        with self.assertRaises(ChannelError):
            channel.encode((9, 9, 9, 9))

    def test_language_rejects_duplicate_states(self):
        with self.assertRaises(ChannelError):
            Language("dup", ((0,), (0,)))


# --------------------------------------------------------------------------
# 3. planted-false controls -- these MUST be caught
# --------------------------------------------------------------------------


class TestPlantedFalseControls(unittest.TestCase):

    def test_planted_injective_channel_with_a_collision(self):
        """A channel DECLARING injectivity that collides.  Caught exhaustively."""
        language = digit_language(BASE, LENGTH)
        liar = Channel(
            name="planted_injective",
            language=language,
            encoder=lambda word: RGB(word[0] * 60, 0, 0),  # ignores c_1..c_3
            declares_injective=True,
            inverse=lambda code: (code.r // 60, 0, 0, 0),
        )
        certificate = certify_injectivity(liar)
        self.assertTrue(certificate.declared)
        self.assertFalse(certificate.injective)
        self.assertFalse(certificate.honest, "an injectivity declaration with a collision must be dishonest")
        witness = certificate.witness
        self.assertIsNotNone(witness)
        self.assertEqual(liar._encoder(witness.left), liar._encoder(witness.right))
        self.assertNotEqual(witness.left, witness.right)
        # the witness is the FIRST collision in language order, so it is reproducible
        self.assertEqual((witness.left, witness.right), ((0, 0, 0, 0), (0, 1, 0, 0)))
        trip = certify_round_trip(liar)
        self.assertIsNotNone(trip.failure)
        self.assertFalse(trip.inverse_exact)
        with self.assertRaises(ChannelError):
            liar.decode_exact(RGB(0, 0, 0))

    def test_planted_lossy_decode_returns_a_single_value(self):
        """``decode`` must return the fibre.  A single guess must be caught."""

        class SingleGuessChannel(Channel):
            def decode(self, code, counter=None):  # noqa: D102 - deliberately wrong
                fibre = super().decode(code, counter)
                return fibre[0] if fibre else ()

        language = digit_language(BASE, LENGTH)
        cheat = SingleGuessChannel(
            name="planted_single_decode",
            language=language,
            encoder=lambda word: RGB(carry_count(word, BASE) * 60, 0, 0),
        )
        report = validate_channel(cheat)
        self.assertFalse(report.ok)
        self.assertFalse(report.fibers_partition)
        text = " ".join(report.failures)
        self.assertIn("not a state", text)
        self.assertIn("fibres cover", text)
        # and the honest base class does return the fibre for the same encoder
        honest = Channel(
            name="honest",
            language=language,
            encoder=lambda word: RGB(carry_count(word, BASE) * 60, 0, 0),
        )
        self.assertTrue(validate_channel(honest).ok)

    def test_planted_precedence_violation_lexical_over_semantic(self):
        """Lexical wired ABOVE semantic: 'blue' renders yellow.  Caught twice."""
        tokens = (Token("beta", "Word"), Token("blue", "Word"))
        language = Language("planted-tokens", tokens)
        semantic = {token: COLOUR_WORDS[token.name] for token in tokens if token.name in COLOUR_WORDS}
        inverted = ChromaticChannel(
            name="planted_precedence",
            language=language,
            layers=(
                # semantic pushed to the BOTTOM, lexical ancestry to the TOP
                layer("semantic", lambda token: semantic.get(token), ("Y", "Co", "Cg"), precedence=0),
                layer(
                    "ancestry",
                    lambda token: LEXICAL_TABLE.get(token.name[0]),
                    ("Y", "Co", "Cg"),
                    precedence=4,
                ),
            ),
            description="planted-false: lexical beats semantic",
        )
        blue = [token for token in tokens if token.name == "blue"][0]
        self.assertEqual(inverted.colour(blue), YELLOW, "the planted channel really does render blue as yellow")
        certificate = certify_precedence(inverted)
        self.assertFalse(certificate.ok)
        self.assertFalse(certificate.canonical_order, "the declared precedences must be rejected")
        self.assertEqual(certificate.semantic_fires, 1)
        self.assertEqual(certificate.semantic_dominates, 0, "semantic must be reported as NOT dominating")
        text = " ".join(certificate.violations)
        self.assertIn("semantic", text)
        # the honest channel, same tokens, must pass
        honest = token_chroma(tokens)
        self.assertEqual(honest.colour(blue), RGB(0, 0, 255))
        self.assertTrue(certify_precedence(honest).ok)

    def test_planted_information_gain_claim_is_rejected(self):
        language = digit_language(BASE, LENGTH)
        liar = Channel(
            name="planted_gain",
            language=language,
            encoder=lambda word: RGB(carry_count(word, BASE) * 60, 0, 0),
            claim=INFORMATION_GAIN,
        )
        certificate = certify_claim(liar)
        self.assertFalse(certificate.accepted)
        self.assertIn("function of state", certificate.reason)
        honest = Channel(
            name="honest",
            language=language,
            encoder=lambda word: RGB(carry_count(word, BASE) * 60, 0, 0),
            claim=RECOGNITION_COST,
        )
        self.assertTrue(certify_claim(honest).accepted)

    def test_planted_wrong_inverse(self):
        """An implemented inverse that returns the wrong preimage must fail."""
        language = digit_language(BASE, LENGTH)
        chroma = low_word_chroma(BASE, LENGTH, language)
        low = low_sublanguage(BASE, LENGTH, language)
        good = low_word_inverse(BASE, LENGTH)
        channel = restrict(
            chroma.channel(),
            low,
            name="planted_inverse",
            declares_injective=True,
            inverse=lambda code: tuple(reversed(good(code))),  # transposes the digits
        )
        trip = certify_round_trip(channel)
        self.assertTrue(certify_injectivity(channel).injective)
        self.assertFalse(trip.inverse_exact)
        self.assertIsNotNone(trip.failure)
        self.assertIn("inverse", trip.failure)

    def test_planted_declared_injective_without_an_inverse_is_reported(self):
        language = digit_language(BASE, LENGTH)
        chroma = low_word_chroma(BASE, LENGTH, language)
        low = low_sublanguage(BASE, LENGTH, language)
        channel = restrict(chroma.channel(), low, name="no_inverse", declares_injective=True, inverse=None)
        trip = certify_round_trip(channel)
        self.assertFalse(trip.inverse_implemented)
        self.assertEqual(trip.failure, "declares injectivity but implements no inverse")

    def test_planted_distinguishability_claim_on_a_colliding_task(self):
        language, chroma = digit_fixture()
        channel = chroma.channel()
        task = Task("borrow-class", lambda word, c: borrow_count(word, BASE))
        certificate = certify_distinguishability(channel, task)
        self.assertFalse(certificate.distinguishable)
        self.assertGreater(certificate.preservation.violations, 0)
        witness = certificate.preservation.violation_witness
        self.assertNotEqual(borrow_count(witness.left, BASE), borrow_count(witness.right, BASE))
        self.assertEqual(channel.encode(witness.left), channel.encode(witness.right))
        self.assertEqual(certificate.min_separation, Fraction(0), "colliding classes have zero separation")

    def test_planted_inverse_without_an_injectivity_declaration_is_refused(self):
        language = digit_language(BASE, LENGTH)
        with self.assertRaises(ChannelError):
            Channel("bad", language, lambda word: RGB(0, 0, 0), inverse=lambda code: language.states[0])

    def test_planted_base_layer_that_is_not_total_is_refused(self):
        language = digit_language(BASE, LENGTH)
        with self.assertRaises(ChromaError):
            ChromaticChannel(
                "partial-base",
                language,
                (layer("ancestry", lambda word: None if word[0] == 0 else RGB(0, 0, 0)),),
            )

    def test_planted_base_layer_claiming_a_subset_is_refused(self):
        language = digit_language(BASE, LENGTH)
        with self.assertRaises(ChromaError):
            ChromaticChannel(
                "thin-base",
                language,
                (layer("ancestry", lambda word: RGB(0, 0, 0), ("Y",)),),
            )

    def test_planted_float_is_caught_by_the_scanner(self):
        """The scanner is itself tested, so a green scan means something."""
        with tempfile.TemporaryDirectory() as folder:
            path = os.path.join(folder, "planted.py")
            with open(path, "w", encoding="utf-8") as handle:
                handle.write("BAD = 0.5\n")
            self.assertEqual(scan_for_floats(path), ["planted.py:1 float literal 0.5"])
            path = os.path.join(folder, "planted_div.py")
            with open(path, "w", encoding="utf-8") as handle:
                handle.write("def f(a, b):\n    return a / b\n")
            self.assertEqual(scan_for_floats(path), ["planted_div.py:2 true division"])
            path = os.path.join(folder, "clean.py")
            with open(path, "w", encoding="utf-8") as handle:
                handle.write("from fractions import Fraction\nGOOD = Fraction(1, 2)\nH = 7 // 2\n")
            self.assertEqual(scan_for_floats(path), [])


# --------------------------------------------------------------------------
# 4. the chromatic channel: layers, precedence, the direction's example
# --------------------------------------------------------------------------


class TestChromaticLayers(unittest.TestCase):

    def test_semantic_override_beats_lexical_exactly(self):
        chroma = token_chroma(DEMO_TOKENS)
        by_name = {token.name: chroma.resolve(token) for token in chroma.language.states}
        self.assertEqual(LEXICAL_TABLE["b"], YELLOW)
        self.assertEqual(by_name["beta"].colour, YELLOW)
        self.assertEqual(by_name["blue"].colour, RGB(0, 0, 255))
        self.assertEqual(by_name["red"].colour, RGB(255, 0, 0))
        for component, role in by_name["blue"].winners:
            self.assertEqual(role, "semantic", component)
        for component, role in by_name["beta"].winners:
            self.assertEqual(role, "ancestry", component)
        self.assertEqual(by_name["blue"].dominant(), "semantic")
        self.assertEqual(by_name["beta"].dominant(), "ancestry")

    def test_a_partial_layer_tints_without_repainting(self):
        chroma = token_chroma(DEMO_TOKENS)
        gamma = [t for t in chroma.language.states if t.name == "gamma_3"][0]
        resolution = chroma.resolve(gamma)
        self.assertEqual(resolution.winner("Y"), "sort")
        self.assertEqual(resolution.winner("Co"), "ancestry")
        self.assertEqual(resolution.winner("Cg"), "ancestry")
        lexical = LEXICAL_TABLE["g"]
        self.assertNotEqual(resolution.colour, lexical)
        self.assertEqual(to_opponent(resolution.colour)[1], to_opponent(lexical)[1])

    def test_precedence_certificate_agrees_with_an_independent_walk(self):
        language = digit_language(BASE, LENGTH)
        for chroma in (
            token_chroma(DEMO_TOKENS),
            carry_chroma(BASE, LENGTH, language),
            borrow_chroma(BASE, LENGTH, language),
            orbit_chroma(BASE, LENGTH, language),
        ):
            certificate = certify_precedence(chroma)
            self.assertTrue(certificate.ok, (chroma.name, certificate.violations))
            self.assertTrue(certificate.canonical_order)
            self.assertTrue(certificate.independent_agreement)
            self.assertEqual(certificate.semantic_fires, certificate.semantic_dominates)

    def test_semantic_layer_fires_exactly_on_the_declared_locus(self):
        language = digit_language(BASE, LENGTH)
        carry = carry_chroma(BASE, LENGTH, language)
        top = tuple([BASE - 1] * LENGTH)
        fired = [word for word in language.states if dict(carry.resolve(word).proposals)["semantic"] is not None]
        self.assertEqual(fired, [top])
        orbit = orbit_chroma(BASE, LENGTH, language)
        fired = [word for word in language.states if dict(orbit.resolve(word).proposals)["semantic"] is not None]
        self.assertEqual(fired, [word for word in language.states if is_constant_word(word)])
        self.assertEqual(len(fired), BASE)

    def test_gamut_clamping_is_counted_and_harmless_to_the_declared_task(self):
        """Layering can push a composed colour out of the sRGB cube.

        That is a third loss source, on top of fibres and 8-bit quantisation,
        and it is *measured* rather than assumed away.  chroma_carry and
        chroma_borrow never clamp; chroma_orbit clamps on 168 of 256 states,
        because its sort layer overwrites Y on saturated ancestry hues.  The
        thing that must not happen is a clamp collapsing a distinction the
        declared task needs -- so that is asserted separately.
        """
        language = digit_language(BASE, LENGTH)
        expected = {"chroma_carry": 0, "chroma_borrow": 0, "chroma_orbit": 168}
        for chroma in (
            carry_chroma(BASE, LENGTH, language),
            borrow_chroma(BASE, LENGTH, language),
            orbit_chroma(BASE, LENGTH, language),
        ):
            clamped = [word for word in language.states if chroma.resolve(word).clamped]
            self.assertEqual(len(clamped), expected[chroma.name], chroma.name)
        orbit = orbit_chroma(BASE, LENGTH, language).channel()
        sector = Task("sector", lambda word, c: sector_name(word, BASE))
        self.assertTrue(certify_preservation(orbit, sector).preserved)
        generic = language.sublanguage("generic", lambda word: sector_name(word, BASE) == "generic")
        root = Task("root", lambda word, c: word[0])
        self.assertTrue(certify_preservation(restrict(orbit, generic), root).preserved)

    def test_duplicate_layer_roles_are_refused(self):
        language = digit_language(BASE, LENGTH)
        with self.assertRaises(ChromaError):
            ChromaticChannel(
                "dup",
                language,
                (
                    layer("ancestry", lambda word: RGB(0, 0, 0)),
                    layer("ancestry", lambda word: RGB(1, 1, 1)),
                ),
            )


# --------------------------------------------------------------------------
# 5. the mathematics the pictures claim (DIGIT_CRYSTAL)
# --------------------------------------------------------------------------


class TestRenderedMathematics(unittest.TestCase):

    def test_carry_and_borrow_counts_match_the_valuation_identities(self):
        """c_n(x) = v_b(x+1) and z_n(x) = v_b(x), on every state."""
        language = digit_language(BASE, LENGTH)
        for value, word in enumerate(language.states):
            expected_carry = 0
            probe = value + 1
            while probe % BASE == 0 and expected_carry < LENGTH:
                expected_carry += 1
                probe = probe // BASE
            self.assertEqual(carry_count(word, BASE), expected_carry, word)
            expected_borrow = 0
            probe = value
            while probe % BASE == 0 and expected_borrow < LENGTH and value != 0:
                expected_borrow += 1
                probe = probe // BASE
            if value == 0:
                expected_borrow = LENGTH
            self.assertEqual(borrow_count(word, BASE), expected_borrow, word)

    def test_the_carry_cocycle_holds_where_it_is_stated(self):
        """s(x+1) - s(x) = 1 - (b-1) c_n(x) for x < b^n - 1  (DIGIT_CRYSTAL 2.1)."""
        language = digit_language(BASE, LENGTH)
        top = BASE ** LENGTH - 1
        for value in range(top):
            word = language.states[value]
            successor = language.states[value + 1]
            delta = sum(successor) - sum(word)
            self.assertEqual(delta, 1 - (BASE - 1) * carry_count(word, BASE), value)

    def test_E_exchanges_carry_with_borrow(self):
        """c_n(E x) = z_n(x)  --  DIGIT_CRYSTAL (2.2), the rendered theorem."""
        language = digit_language(BASE, LENGTH)
        for word in language.states:
            self.assertEqual(carry_count(complement_word(word, BASE), BASE), borrow_count(word, BASE))
            self.assertEqual(borrow_count(complement_word(word, BASE), BASE), carry_count(word, BASE))

    def test_E_is_the_point_reflection_of_the_grid(self):
        language = digit_language(BASE, LENGTH)
        top = BASE ** LENGTH - 1
        for value, word in enumerate(language.states):
            self.assertEqual(value_of(complement_word(word, BASE), BASE), top - value)

    def test_the_two_panels_are_each_other_rotated_by_half_a_turn(self):
        """The visible claim of picture 1, checked on the exact rendered colours."""
        language = digit_language(BASE, LENGTH)
        carry = carry_chroma(BASE, LENGTH, language)
        borrow = borrow_chroma(BASE, LENGTH, language)
        top = BASE ** LENGTH - 1
        for value, word in enumerate(language.states):
            self.assertEqual(borrow.colour(word), carry.colour(language.states[top - value]), value)

    def test_the_panels_are_not_identical_so_the_check_has_content(self):
        """A planted-false control on the picture: if the two colourings were the
        same map, 'rotated by half a turn' would be vacuous."""
        language = digit_language(BASE, LENGTH)
        carry = carry_chroma(BASE, LENGTH, language)
        borrow = borrow_chroma(BASE, LENGTH, language)
        differing = [w for w in language.states if carry.colour(w) != borrow.colour(w)]
        self.assertGreater(len(differing), 0)
        # exactly the words whose least significant digit is 0 or b-1: those have
        # c_n and z_n differing, every other word has c_n = z_n = 0.
        self.assertEqual(len(differing), 2 * BASE ** (LENGTH - 1))
        for word in differing:
            self.assertIn(word[0], (0, BASE - 1))

    def test_fixed_point_counts_match_the_closed_forms_of_theorem_3_4(self):
        language = digit_language(BASE, LENGTH)
        palindromes = sum(1 for word in language.states if is_palindrome(word))
        antipalindromes = sum(1 for word in language.states if is_antipalindrome(word, BASE))
        both = sum(1 for word in language.states if is_palindrome(word) and is_antipalindrome(word, BASE))
        self.assertEqual(palindromes, BASE ** ((LENGTH + 1) // 2))
        self.assertEqual(antipalindromes, BASE ** (LENGTH // 2))
        self.assertEqual(both, 0)  # |Fix E| = 0 because b is even
        orbits = len(set(klein_orbit(word, BASE) for word in language.states))
        self.assertEqual(orbits, (BASE ** LENGTH + palindromes + 0 + antipalindromes) // 4)

    def test_D_and_E_commute_elementwise(self):
        """DIGIT_CRYSTAL Thm 3.1: the commutator is trivial at every level."""
        language = digit_language(BASE, LENGTH)
        for word in language.states:
            self.assertEqual(
                reverse_word(complement_word(word, BASE)),
                complement_word(reverse_word(word), BASE),
            )

    def test_the_agreement_locus_is_the_constant_words_and_sits_on_the_diagonal(self):
        language = digit_language(BASE, LENGTH)
        constants = [word for word in language.states if is_constant_word(word)]
        self.assertEqual(len(constants), BASE)
        for word in constants:
            value = value_of(word, BASE)
            row, column = divmod(value, BASE * BASE)
            self.assertEqual(row, column, word)

    def test_sectors_partition_the_state_space(self):
        language = digit_language(BASE, LENGTH)
        counts = {}
        for word in language.states:
            name = sector_name(word, BASE)
            counts[name] = counts.get(name, 0) + 1
        self.assertEqual(sum(counts.values()), BASE ** LENGTH)
        self.assertEqual(counts.get("fix-both", 0), 0)
        self.assertEqual(counts["palindrome"], 16)
        self.assertEqual(counts["antipalindrome"], 16)
        self.assertEqual(counts["generic"], 224)

    def test_word_value_round_trip(self):
        for value in range(BASE ** LENGTH):
            self.assertEqual(value_of(word_of(value, BASE, LENGTH), BASE), value)
        self.assertEqual(digit_words(BASE, LENGTH)[5], word_of(5, BASE, LENGTH))


# --------------------------------------------------------------------------
# 6. the SVG writer
# --------------------------------------------------------------------------


class TestSVG(unittest.TestCase):

    def test_non_integer_geometry_is_refused(self):
        doc = SVG(10, 10, "t")
        for bad in (Fraction(1, 2), "3", None, True):
            with self.assertRaises(SVGError):
                doc.rect(bad, 0, 1, 1, fill=RGB(0, 0, 0))

    def test_output_is_well_formed_and_escaped(self):
        doc = SVG(20, 20, "a <title> & \"quotes\"")
        doc.rect(0, 0, 10, 10, fill=RGB(1, 2, 3), title="w=<0,1> & more")
        doc.text(1, 2, "5 < 6 & 7 > 4", RGB(0, 0, 0))
        markup = doc.render()
        root = ElementTree.fromstring(markup)
        self.assertEqual(root.tag, "{http://www.w3.org/2000/svg}svg")
        self.assertNotIn("<0,1>", markup)
        self.assertIn("&lt;0,1&gt;", markup)

    def test_unclosed_group_is_refused(self):
        doc = SVG(10, 10, "t")
        doc.open_group("g")
        with self.assertRaises(SVGError):
            doc.render()
        doc.close_group()
        self.assertIn("</g>", doc.render())

    def test_bad_text_anchor_is_refused(self):
        doc = SVG(10, 10, "t")
        with self.assertRaises(SVGError):
            doc.text(0, 0, "x", RGB(0, 0, 0), anchor="centre")

    def test_render_is_byte_stable(self):
        def build():
            doc = SVG(50, 50, "stable", background=RGB(255, 255, 255))
            for index in range(10):
                doc.rect(index, index, 2, 2, fill=RGB(index, index, index))
            return doc.render()

        self.assertEqual(build(), build())

    def test_every_geometric_attribute_is_an_integer_string(self):
        doc = SVG(40, 40, "t", background=RGB(0, 0, 0))
        doc.rect(0, 0, 4, 4, fill=RGB(9, 9, 9), stroke=RGB(1, 1, 1), stroke_width=1)
        doc.circle(2, 2, 1, fill=RGB(3, 3, 3))
        doc.line(0, 0, 4, 4, RGB(0, 0, 0), 1)
        doc.text(1, 1, "x", RGB(0, 0, 0), 11)
        geometry = ("x", "y", "width", "height", "x1", "y1", "x2", "y2", "cx", "cy", "r",
                    "stroke-width", "font-size")
        root = ElementTree.fromstring(doc.render())
        seen = 0
        for element in root.iter():
            for key in geometry:
                value = element.get(key)
                if value is None:
                    continue
                seen += 1
                self.assertEqual(str(int(value)), value, "%s=%s" % (key, value))
        self.assertGreater(seen, 10)


# --------------------------------------------------------------------------
# 7. discipline: no floats, no forbidden imports, determinism
# --------------------------------------------------------------------------

SOURCES = [
    os.path.join(RUNTIME, "render", "__init__.py"),
    os.path.join(RUNTIME, "render", "channel.py"),
    os.path.join(RUNTIME, "render", "chroma.py"),
    os.path.join(RUNTIME, "render", "svg.py"),
    os.path.join(RUNTIME, "demo", "render_demo.py"),
]


def scan_for_floats(path: str) -> list:
    """AST walk: float/complex literals and true division are both rejected.

    Parsed, not grepped, so prose in a docstring cannot mask a real ``/`` and
    cannot raise a false alarm either.
    """
    with open(path, "r", encoding="utf-8") as handle:
        tree = ast.parse(handle.read(), filename=path)
    name = os.path.basename(path)
    findings = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Constant) and isinstance(node.value, (float, complex)):
            findings.append("%s:%d float literal %r" % (name, node.lineno, node.value))
        elif isinstance(node, ast.BinOp) and isinstance(node.op, ast.Div):
            findings.append("%s:%d true division" % (name, node.lineno))
        elif isinstance(node, ast.AugAssign) and isinstance(node.op, ast.Div):
            findings.append("%s:%d true division" % (name, node.lineno))
    return findings


class TestDiscipline(unittest.TestCase):

    def test_no_floating_point_in_the_package(self):
        for path in SOURCES:
            self.assertEqual(scan_for_floats(path), [], path)

    def test_no_float_call_anywhere_in_the_package(self):
        for path in SOURCES:
            with open(path, "r", encoding="utf-8") as handle:
                tree = ast.parse(handle.read(), filename=path)
            for node in ast.walk(tree):
                if isinstance(node, ast.Call) and isinstance(node.func, ast.Name):
                    self.assertNotIn(node.func.id, ("float", "complex", "round"), path)

    def test_imports_are_stdlib_only_and_package_local(self):
        """Independence: nothing from numpy, randomness or the sibling runtimes."""
        banned = {"numpy", "scipy", "random", "torch", "sympy", "kernel", "crystallize", "distinguish", "math"}
        for path in SOURCES:
            with open(path, "r", encoding="utf-8") as handle:
                tree = ast.parse(handle.read(), filename=path)
            name = os.path.basename(path)
            for node in ast.walk(tree):
                modules = []
                if isinstance(node, ast.Import):
                    modules = [alias.name for alias in node.names]
                elif isinstance(node, ast.ImportFrom):
                    modules = [node.module or ""]
                for module in modules:
                    self.assertNotIn(module.split(".")[0], banned, "%s imports %s" % (name, module))

    def test_svg_module_imports_nothing_from_the_package(self):
        with open(os.path.join(RUNTIME, "render", "svg.py"), "r", encoding="utf-8") as handle:
            tree = ast.parse(handle.read())
        for node in ast.walk(tree):
            if isinstance(node, ast.ImportFrom):
                self.assertNotEqual(node.level, 1, "svg.py must not import from its own package")

    def test_step_counter_rejects_negative_amounts(self):
        counter = StepCounter()
        with self.assertRaises(ValueError):
            counter.tick("x", -1)

    def test_step_counter_report_is_sorted_and_exact(self):
        counter = StepCounter()
        counter.tick("b", 2)
        counter.tick("a", 3)
        counter.tick("b")
        self.assertEqual(counter.report(), (("a", 3), ("b", 3)))
        self.assertEqual(counter.total(), 6)
        self.assertIsInstance(counter.total(), int)

    def test_resolution_is_deterministic_in_process(self):
        language = digit_language(BASE, LENGTH)
        first = [carry_chroma(BASE, LENGTH, language).colour(word) for word in language.states]
        second = [carry_chroma(BASE, LENGTH, language).colour(word) for word in language.states]
        self.assertEqual(first, second)


class TestDemo(unittest.TestCase):
    """The demo is part of the claim, so it is tested as part of the claim."""

    DEMO = os.path.join(RUNTIME, "demo", "render_demo.py")
    OUT = os.path.join(RUNTIME, "demo", "out")

    def run_demo(self, seed: str = "0"):
        environment = dict(os.environ)
        environment["PYTHONHASHSEED"] = seed
        process = subprocess.run(
            [sys.executable, self.DEMO], capture_output=True, env=environment, cwd=REPO, timeout=900
        )
        self.assertEqual(process.returncode, 0, process.stderr.decode("utf-8")[-2000:])
        return process.stdout

    def test_demo_is_byte_identical_across_processes_and_hash_seeds(self):
        digests = [hashlib.sha256(self.run_demo(seed)).hexdigest() for seed in ("0", "1")]
        self.assertEqual(digests[0], digests[1])

    def test_demo_reports_its_own_digest_correctly(self):
        raw = self.run_demo()
        marker = b"report-sha256"
        cut = raw.rindex(marker)
        body = raw[:cut]
        last = raw[cut:].decode("utf-8").strip()
        self.assertEqual(hashlib.sha256(body[:-1]).hexdigest(), last.split()[1])

    def test_demo_verdict_and_caveat_are_present(self):
        text = self.run_demo().decode("utf-8")
        self.assertIn("VERDICT: PERCEPTUAL SURFACE BUILT AND CERTIFIED", text)
        self.assertIn("COLLISION WITNESS", text)
        self.assertIn("NULL CONTROL", text)
        self.assertIn("THE CAVEAT, STATED PLAINLY", text)
        self.assertIn("human recognition latency established                 NO", text)
        self.assertIn("blue renders blue even though b is yellow: True", text)

    def test_demo_artifacts_are_well_formed_and_reproducible(self):
        self.run_demo()
        first = {}
        for name in sorted(os.listdir(self.OUT)):
            path = os.path.join(self.OUT, name)
            with open(path, "rb") as handle:
                payload = handle.read()
            ElementTree.fromstring(payload.decode("utf-8"))
            first[name] = hashlib.sha256(payload).hexdigest()
        self.assertEqual(sorted(first), ["carry_cocycle.svg", "layer_precedence.svg", "symmetry_sectors.svg"])
        self.run_demo("7")
        for name, digest in first.items():
            with open(os.path.join(self.OUT, name), "rb") as handle:
                self.assertEqual(hashlib.sha256(handle.read()).hexdigest(), digest, name)

    def test_rendered_cells_agree_with_the_channels(self):
        """The file is not allowed to say something the channel did not compute."""
        self.run_demo()
        path = os.path.join(self.OUT, "carry_cocycle.svg")
        root = ElementTree.parse(path).getroot()
        namespace = "{http://www.w3.org/2000/svg}"
        panels = {}
        for group in root.iter(namespace + "g"):
            identifier = group.get("id") or ""
            if not identifier.startswith("left") and not identifier.startswith("right"):
                continue
            fills = []
            for rect in group.iter(namespace + "rect"):
                title = rect.find(namespace + "title")
                if title is not None:
                    fills.append(rect.get("fill"))
            panels[identifier.split(":")[0]] = fills
        self.assertEqual(len(panels), 2)
        language = digit_language(BASE, LENGTH)
        carry = carry_chroma(BASE, LENGTH, language)
        borrow = borrow_chroma(BASE, LENGTH, language)
        left = panels["left"]
        right = panels["right"]
        self.assertEqual(len(left), BASE ** LENGTH)
        for value, word in enumerate(language.states):
            self.assertEqual(left[value], carry.colour(word).hex(), value)
            self.assertEqual(right[value], borrow.colour(word).hex(), value)
        top = BASE ** LENGTH - 1
        for value in range(BASE ** LENGTH):
            self.assertEqual(right[value], left[top - value], value)


if __name__ == "__main__":
    unittest.main(verbosity=2)
