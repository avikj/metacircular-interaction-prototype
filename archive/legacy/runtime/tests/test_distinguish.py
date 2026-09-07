#!/usr/bin/env python3
"""Adversarial tests for `runtime/distinguish/`, with planted-false controls.

Run:  python3 runtime/tests/test_distinguish.py
      (or: python3 -m unittest discover -s runtime/tests)

The design principle of this file: a checker that only ever sees correct input
has not been tested.  Every claim the package makes is paired here with a
deliberately WRONG artifact that the checker MUST reject.  Those are the tests
named ``test_planted_*``; if the package ever stops rejecting them, the package
is broken even if everything else passes.

Planted-false controls, minimum set required by the design:

1. ``test_planted_false_sufficiency_merge``  -- a claimed "sufficient" quotient
   that merges two states a declared task distinguishes.  Must be caught, and
   must be caught with a witness, for every pair of adjacent blocks.
2. ``test_planted_false_minimal_channel_set`` -- a claimed "minimal" channel
   set with a removable member.  Must be caught.
3. ``test_moore_hand_computed_*`` -- refinement must terminate at exactly the
   block count computed by hand on four systems.

Plus: congruence violations, non-refining observations, budget exhaustion,
greedy-vs-exact ordering, determinism across processes, and a scan of the
package source for floating point.
"""

from __future__ import annotations

import ast
import hashlib
import os
import subprocess
import sys
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
RUNTIME = os.path.dirname(HERE)
REPO = os.path.dirname(RUNTIME)
sys.path.insert(0, RUNTIME)

from distinguish import (  # noqa: E402
    DigitWordSystem,
    Observation,
    PairRequirement,
    PartitionRequirement,
    SearchBudgetExceeded,
    SignatureOracle,
    StepCounter,
    Task,
    build_compiled_representation,
    build_digit_system,
    build_quotient,
    channel_values,
    check_coarsest,
    check_sufficient,
    compile_distinctions,
    digit_channel,
    distinguishing_word,
    find_collisions,
    greedy_set,
    harmonic_ceiling,
    horner_mod,
    inclusion_minimal_set,
    is_inclusion_minimal,
    merge_blocks,
    minimum_cardinality_set,
    moore_refine,
    observation_blocks,
    prime_powers_dividing,
    refines,
    residue_channel,
    reversed_residue_channel,
    standard_library,
    truncation_length,
)
from distinguish.refine import RawEngine  # noqa: E402


# --------------------------------------------------------------------------
# shared fixtures
# --------------------------------------------------------------------------


def threshold_task(base: int, length: int, modulus: int, cut: int) -> Task:
    top = truncation_length(base, modulus, length)

    def fn(digits, counter) -> int:
        return 1 if horner_mod(digits, base, modulus, top, counter) < cut else 0

    return Task("tau[%d<%d]" % (modulus, cut), top, fn)


def digit_zero_task(index: int) -> Task:
    def fn(digits, counter) -> int:
        counter.tick("digit-read")
        return 1 if digits[index] == 0 else 0

    return Task("tauC[c%d=0]" % index, 1, fn)


def small_fixture(base: int = 6, length: int = 4):
    """The demo's system one size down: 1296 states, same mathematics."""
    digit_system = DigitWordSystem(base, length)
    tasks = (threshold_task(base, length, 8, 4), threshold_task(base, length, 27, 14))
    counter = StepCounter()
    system = build_digit_system(digit_system, tasks, counter)
    return digit_system, tasks, system


# --------------------------------------------------------------------------
# 1. Moore refinement terminates at the hand-computed block count
# --------------------------------------------------------------------------


class TestMooreHandComputed(unittest.TestCase):
    """Four systems whose Myhill-Nerode quotient is computable by hand."""

    def refine_blocks(self, digit_system, tasks):
        counter = StepCounter()
        system = build_digit_system(digit_system, tasks, counter)
        result = moore_refine(system, system.output_partition(counter), counter)
        return system, result

    def test_moore_hand_computed_crt(self):
        # b=6, n=4: 1296 states.  tau[8<4] recovers v mod 8 along the odometer
        # orbit (the 8-periodic word 11110000 has all 8 rotations distinct);
        # tau[27<14] recovers v mod 27 likewise; lcm(8,27) = 216 divides 6^4,
        # so mod-216 is a congruence for T and for E(v) = 1295 - v.
        # Hand answer: exactly 216 blocks.
        digit_system, tasks, _ = small_fixture(6, 4)
        _, result = self.refine_blocks(digit_system, tasks)
        self.assertEqual(result.n_blocks, 216)

    def test_moore_hand_computed_single_modulus(self):
        # Only tau[8<4]: the quotient must be exactly Z/8.
        digit_system = DigitWordSystem(6, 4)
        _, result = self.refine_blocks(digit_system, (threshold_task(6, 4, 8, 4),))
        self.assertEqual(result.n_blocks, 8)

    def test_moore_hand_computed_carry_window(self):
        # tauC[c1=0] on b=6: the pair (c_0, c_1) is an odometer on Z/36 and
        # the indicator has all 36 rotations distinct, so exactly 36 blocks --
        # "the second digit is 0" needs the low TWO digits, no more.
        digit_system = DigitWordSystem(6, 4)
        _, result = self.refine_blocks(digit_system, (digit_zero_task(1),))
        self.assertEqual(result.n_blocks, 36)

    def test_moore_hand_computed_lowest_digit(self):
        # tauC[c0=0]: the lowest digit is itself an odometer on Z/6.
        digit_system = DigitWordSystem(6, 4)
        _, result = self.refine_blocks(digit_system, (digit_zero_task(0),))
        self.assertEqual(result.n_blocks, 6)

    def test_moore_terminates_at_identity_for_reversal_task(self):
        # A task read through the reversal D collapses the quotient to the
        # identity: no compression exists.  b=6, n=3 -> 216 of 216.
        digit_system = DigitWordSystem(6, 3)

        def rev(digits, counter):
            acc = 0
            for index in range(3):
                counter.tick("digit-read")
                acc = (acc * 6 + digits[index]) % 8
            return 1 if acc < 4 else 0

        _, result = self.refine_blocks(digit_system, (Task("tauD", 3, rev),))
        self.assertEqual(result.n_blocks, digit_system.size)

    def test_moore_is_idempotent(self):
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        first = moore_refine(system, system.output_partition(counter), counter)
        second = moore_refine(system, first.classes, counter)
        self.assertEqual(second.n_blocks, first.n_blocks)
        self.assertEqual(second.rounds, 0)


# --------------------------------------------------------------------------
# 2. PLANTED FALSE: an insufficient quotient claimed as sufficient
# --------------------------------------------------------------------------


class TestPlantedFalseSufficiency(unittest.TestCase):

    def test_planted_false_sufficiency_merge(self):
        """Merge two Myhill-Nerode blocks and demand rejection, every time."""
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        truth = moore_refine(system, system.output_partition(counter), counter)
        self.assertTrue(check_sufficient(system, truth.classes, counter).ok)

        caught = 0
        for i in range(truth.n_blocks - 1):
            planted = merge_blocks(truth.classes, i, i + 1)
            report = check_sufficient(system, planted, counter)
            self.assertFalse(report.ok, "merge of blocks %d,%d slipped through" % (i, i + 1))
            self.assertIsNotNone(report.witness)
            caught += 1
        self.assertEqual(caught, truth.n_blocks - 1)

    def test_planted_false_sufficiency_random_merges(self):
        """Merges of non-adjacent blocks must be rejected too."""
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        truth = moore_refine(system, system.output_partition(counter), counter)
        for i in range(0, truth.n_blocks, 7):
            j = (i * 5 + 11) % truth.n_blocks
            if i == j:
                continue
            planted = merge_blocks(truth.classes, i, j)
            self.assertFalse(check_sufficient(system, planted, counter).ok)

    def test_planted_false_quotient_construction_refuses(self):
        """``build_quotient`` must refuse an insufficient partition outright."""
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        truth = moore_refine(system, system.output_partition(counter), counter)
        planted = merge_blocks(truth.classes, 0, 1)
        with self.assertRaises(ValueError):
            build_quotient(system, planted, counter)

    def test_planted_false_congruence_only(self):
        """A partition that is output-constant but NOT a congruence is caught.

        Take the true quotient and merge two blocks with equal task outputs.
        Output-constancy still holds, so only the congruence half of the proof
        can reject it -- which is exactly the half a naive checker omits.
        """
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        truth = moore_refine(system, system.output_partition(counter), counter)
        quotient = build_quotient(system, truth.classes, counter)
        pair = None
        for i in range(quotient.n_blocks):
            for j in range(i + 1, quotient.n_blocks):
                if quotient.outputs[i] == quotient.outputs[j]:
                    pair = (i, j)
                    break
            if pair:
                break
        self.assertIsNotNone(pair, "fixture must contain two blocks with equal outputs")
        planted = merge_blocks(truth.classes, pair[0], pair[1])
        report = check_sufficient(system, planted, counter)
        self.assertFalse(report.ok)
        self.assertIn("congruence", report.reason)

    def test_planted_false_partition_wrong_length(self):
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        self.assertFalse(check_sufficient(system, [0, 0, 0], counter).ok)


# --------------------------------------------------------------------------
# 3. coarseness
# --------------------------------------------------------------------------


class TestCoarsest(unittest.TestCase):

    def test_every_block_pair_is_separable(self):
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        truth = moore_refine(system, system.output_partition(counter), counter)
        quotient = build_quotient(system, truth.classes, counter)
        report = check_coarsest(quotient, counter)
        self.assertTrue(report.ok)
        self.assertEqual(report.n_pairs, 216 * 215 // 2)
        self.assertEqual(len(report.unresolved), 0)

    def test_distinguishing_words_actually_distinguish(self):
        """Replay each certificate through the RAW engine, not the quotient."""
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        truth = moore_refine(system, system.output_partition(counter), counter)
        quotient = build_quotient(system, truth.classes, counter)
        report = check_coarsest(quotient, counter)
        raw = RawEngine(digit_system, tasks)
        checked = 0
        for i in range(0, quotient.n_blocks, 11):
            for j in range(i + 1, min(i + 4, quotient.n_blocks)):
                word, task_name = distinguishing_word(quotient, report.depths, i, j, counter)
                x = quotient.representative[i]
                y = quotient.representative[j]
                out_x = raw.answer(digit_system.digits(x), word, counter)
                out_y = raw.answer(digit_system.digits(y), word, counter)
                self.assertNotEqual(out_x, out_y, "certificate for blocks %d,%d is empty" % (i, j))
                checked += 1
        self.assertGreater(checked, 20)

    def test_coarsest_detects_a_non_coarsest_quotient(self):
        """Split a block artificially; the two halves must be inseparable."""
        digit_system = DigitWordSystem(6, 3)
        counter = StepCounter()
        system = build_digit_system(digit_system, (threshold_task(6, 3, 8, 4),), counter)
        truth = moore_refine(system, system.output_partition(counter), counter)
        # Refine by an irrelevant but still action-congruent channel: v mod 3.
        # 3 divides 6^3, so (v mod 8, v mod 3) IS a congruence and IS
        # sufficient -- it is simply not coarsest, and only check_coarsest can
        # say so.
        values = channel_values(digit_system, standard_library(digit_system), counter)
        joint = list(zip(truth.classes, values["res_3"]))
        finer = observation_blocks(tuple(joint), counter)
        self.assertGreater(max(finer) + 1, truth.n_blocks)
        quotient = build_quotient(system, finer, counter)
        report = check_coarsest(quotient, counter)
        self.assertFalse(report.ok, "an over-refined quotient must not pass the coarseness test")
        self.assertGreater(len(report.unresolved), 0)


# --------------------------------------------------------------------------
# 4. PLANTED FALSE: a "minimal" channel set with a removable member
# --------------------------------------------------------------------------


class TestPlantedFalseMinimality(unittest.TestCase):

    def setUp(self):
        self.digit_system, self.tasks, self.system = small_fixture()
        self.counter = StepCounter()
        self.library = standard_library(self.digit_system) + (
            reversed_residue_channel(6, 4, 8),
        )
        self.values = channel_values(self.digit_system, self.library, self.counter)
        truth = moore_refine(self.system, self.system.output_partition(self.counter), self.counter)
        self.truth = truth
        self.requirement = PartitionRequirement(truth.classes)

    def test_exact_minimum_is_two_channels(self):
        result = minimum_cardinality_set(self.library, self.values, self.requirement, self.counter, max_size=3)
        self.assertEqual(result.claim, "exact-minimum-cardinality")
        self.assertEqual(len(result.names), 2)
        self.assertEqual(result.names, ("res_8", "res_27"))
        self.assertEqual(result.n_classes, 216)

    def test_no_single_channel_suffices(self):
        """The exactness claim is only as good as this exhaustive negative."""
        for channel in self.library:
            self.assertFalse(
                self.requirement.satisfied_by([self.values[channel.name]], self.counter),
                "channel %s alone should not suffice" % channel.name,
            )

    def test_planted_false_minimal_channel_set(self):
        """A set with a removable member must NOT pass the minimality check."""
        planted = ("res_8", "res_27", "is_palindrome")
        ok, removable = is_inclusion_minimal(planted, self.values, self.requirement, self.counter)
        self.assertFalse(ok, "a set with a redundant member was accepted as minimal")
        self.assertIn("is_palindrome", removable)

    def test_planted_false_minimal_channel_set_many(self):
        """Every single-channel padding of the true minimum must be caught."""
        base = ("res_8", "res_27")
        caught = 0
        for channel in self.library:
            if channel.name in base:
                continue
            planted = base + (channel.name,)
            ok, removable = is_inclusion_minimal(planted, self.values, self.requirement, self.counter)
            self.assertFalse(ok, "%s was not detected as removable" % channel.name)
            self.assertIn(channel.name, removable)
            caught += 1
        self.assertEqual(caught, len(self.library) - 2)

    def test_true_minimum_passes_the_minimality_check(self):
        ok, removable = is_inclusion_minimal(("res_8", "res_27"), self.values, self.requirement, self.counter)
        self.assertTrue(ok)
        self.assertEqual(removable, ())

    def test_redundant_removal_restores_the_minimum(self):
        reads = {channel.name: channel.reads for channel in self.library}
        kept, dropped = inclusion_minimal_set(
            ("res_8", "res_27", "is_palindrome", "zero_count", "valuation"),
            self.values,
            self.requirement,
            self.counter,
            reads,
        )
        self.assertEqual(kept, ("res_8", "res_27"))
        self.assertEqual(sorted(dropped), ["is_palindrome", "valuation", "zero_count"])

    def test_greedy_is_never_better_than_the_exact_minimum(self):
        pairs = []
        classes = self.truth.classes
        representative = {}
        for state, block in enumerate(classes):
            if block not in representative:
                representative[block] = state
        keys = sorted(representative)
        for index in range(len(keys) - 1):
            pairs.append((representative[keys[index]], representative[keys[index + 1]]))
        requirement = PairRequirement(tuple(pairs))
        exact = minimum_cardinality_set(self.library, self.values, requirement, self.counter, max_size=3)
        greedy = greedy_set(self.library, self.values, requirement, self.counter)
        self.assertEqual(exact.claim, "exact-minimum-cardinality")
        self.assertEqual(greedy.claim, "greedy")
        self.assertGreaterEqual(len(greedy.names), len(exact.names))
        self.assertIn("OPT", greedy.detail)

    def test_greedy_bound_is_exact_and_integral(self):
        self.assertEqual(harmonic_ceiling(1), 1)
        self.assertEqual(harmonic_ceiling(4), 3)  # 25/12
        self.assertEqual(harmonic_ceiling(6), 3)  # 49/20
        self.assertGreaterEqual(harmonic_ceiling(480), 7)

    def test_search_budget_is_enforced_not_silently_degraded(self):
        with self.assertRaises(SearchBudgetExceeded):
            minimum_cardinality_set(self.library, self.values, self.requirement, self.counter, budget=5, max_size=3)


# --------------------------------------------------------------------------
# 5. collisions
# --------------------------------------------------------------------------


class TestCollisions(unittest.TestCase):

    def test_collision_witness_replays_on_the_raw_engine(self):
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        oracle = SignatureOracle(system, counter)
        blocks = [0] * system.n_states  # the coarsest observation
        collisions = find_collisions(oracle, blocks, 4, 5, counter)
        self.assertGreater(len(collisions), 0)
        raw = RawEngine(digit_system, tasks)
        for collision in collisions:
            out_x = raw.answer(digit_system.digits(collision.x), collision.word, counter)
            out_y = raw.answer(digit_system.digits(collision.y), collision.word, counter)
            self.assertNotEqual(out_x, out_y, "collision %s does not replay" % collision.render())
            index = system.task_names.index(collision.task)
            self.assertEqual(out_x[index], collision.out_x)
            self.assertEqual(out_y[index], collision.out_y)

    def test_collision_witnesses_are_shortest(self):
        """No shorter word may distinguish the pair the finder reported."""
        digit_system = DigitWordSystem(6, 3)
        counter = StepCounter()
        system = build_digit_system(digit_system, (digit_zero_task(1),), counter)
        oracle = SignatureOracle(system, counter)
        values = channel_values(digit_system, standard_library(digit_system), counter)
        blocks = observation_blocks(tuple(zip(values["digit_1"])), counter)
        collisions = find_collisions(oracle, blocks, 3, 4, counter)
        self.assertGreater(len(collisions), 0)
        self.assertTrue(any(collision.depth > 0 for collision in collisions))
        raw = RawEngine(digit_system, (digit_zero_task(1),))
        for collision in collisions:
            for length in range(collision.depth):
                for word in self._words(length):
                    out_x = raw.answer(digit_system.digits(collision.x), word, counter)
                    out_y = raw.answer(digit_system.digits(collision.y), word, counter)
                    self.assertEqual(
                        out_x,
                        out_y,
                        "a shorter word %r distinguishes a pair reported at depth %d"
                        % (word, collision.depth),
                    )

    @staticmethod
    def _words(length):
        if length == 0:
            return [()]
        out = [()]
        for _ in range(length):
            out = [word + (action,) for word in out for action in ("T", "E")]
        return out

    def test_no_collision_survives_a_sufficient_observation(self):
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        values = channel_values(digit_system, standard_library(digit_system), counter)
        blocks = observation_blocks(tuple(zip(values["res_8"], values["res_27"])), counter)
        oracle = SignatureOracle(system, counter)
        self.assertEqual(find_collisions(oracle, blocks, 12, 5, counter), ())

    def test_new_task_collides_against_an_installed_quotient(self):
        """The falsification control, as a test: a later task must be caught."""
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        values = channel_values(digit_system, standard_library(digit_system), counter)
        installed = observation_blocks(tuple(zip(values["res_8"], values["res_27"])), counter)
        extended = build_digit_system(digit_system, list(tasks) + [threshold_task(6, 4, 16, 8)], counter)
        oracle = SignatureOracle(extended, counter)
        collisions = find_collisions(oracle, installed, 2, 3, counter)
        self.assertGreater(len(collisions), 0)
        raw = RawEngine(digit_system, tuple(tasks) + (threshold_task(6, 4, 16, 8),))
        collision = collisions[0]
        self.assertNotEqual(
            raw.answer(digit_system.digits(collision.x), collision.word, counter),
            raw.answer(digit_system.digits(collision.y), collision.word, counter),
        )

    def test_planted_wrong_answer_is_not_produced_silently(self):
        """The compiled engine must REFUSE to install on a coarser quotient.

        This is the failure mode that matters: answering a new task from an
        old quotient.  Building the representation against a partition the
        observation does not refine has to raise, not return.
        """
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        values = channel_values(digit_system, standard_library(digit_system), counter)
        truth = moore_refine(system, system.output_partition(counter), counter)
        quotient = build_quotient(system, truth.classes, counter)
        library = {channel.name: channel for channel in standard_library(digit_system)}
        weak = Observation([library["res_8"]])
        with self.assertRaises(ValueError):
            build_compiled_representation(digit_system, weak, quotient, counter)


# --------------------------------------------------------------------------
# 6. end to end: compiled answers equal raw answers, and cost strictly drops
# --------------------------------------------------------------------------


class TestCompiledEqualsRaw(unittest.TestCase):

    def test_compiled_matches_raw_on_every_state_short_words(self):
        digit_system = DigitWordSystem(6, 3)
        tasks = (threshold_task(6, 3, 8, 4), threshold_task(6, 3, 27, 14))
        counter = StepCounter()
        system = build_digit_system(digit_system, tasks, counter)
        library = standard_library(digit_system)
        values = channel_values(digit_system, library, counter)
        report = compile_distinctions(digit_system, system, library, values, counter)
        raw = RawEngine(digit_system, tasks)
        words = TestCollisions._words(3)
        for state in range(0, digit_system.size, 7):
            digits = digit_system.digits(state)
            for word in words:
                self.assertEqual(
                    raw.answer(digits, word, counter),
                    report.compiled.answer(digits, word, counter),
                )

    def test_cost_strictly_drops_on_long_words(self):
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        library = standard_library(digit_system)
        values = channel_values(digit_system, library, counter)
        report = compile_distinctions(digit_system, system, library, values, counter)
        raw = RawEngine(digit_system, tasks)
        word = tuple(("T", "E")[index % 2] for index in range(40))
        raw_counter = StepCounter()
        compiled_counter = StepCounter()
        for state in range(0, digit_system.size, 13):
            digits = digit_system.digits(state)
            self.assertEqual(
                raw.answer(digits, word, raw_counter),
                report.compiled.answer(digits, word, compiled_counter),
            )
        self.assertLess(compiled_counter.total(), raw_counter.total())

    def test_null_channel_does_not_reduce_cost(self):
        """NULL CONTROL as a test: a valid but irrelevant channel must not help."""
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        library = standard_library(digit_system)
        values = channel_values(digit_system, library, counter)
        report = compile_distinctions(digit_system, system, library, values, counter)
        by_name = {channel.name: channel for channel in library}
        with_null = Observation(list(report.observation.channels) + [by_name["is_palindrome"]])
        null_compiled = build_compiled_representation(digit_system, with_null, report.quotient, counter)
        word = tuple("T" for _ in range(20))
        plain = StepCounter()
        padded = StepCounter()
        for state in range(0, digit_system.size, 29):
            digits = digit_system.digits(state)
            self.assertEqual(
                report.compiled.answer(digits, word, plain),
                null_compiled.answer(digits, word, padded),
            )
        self.assertGreater(padded.total(), plain.total())
        self.assertGreater(len(null_compiled.key_to_block), len(report.compiled.key_to_block))

    def test_compile_reaches_the_hand_computed_answer(self):
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        library = standard_library(digit_system) + (reversed_residue_channel(6, 4, 8),)
        values = channel_values(digit_system, library, counter)
        report = compile_distinctions(digit_system, system, library, values, counter)
        self.assertEqual(report.mn_blocks, 216)
        self.assertEqual(report.observation.names, ("res_8", "res_27"))
        self.assertTrue(report.sufficiency.ok)
        self.assertTrue(report.coarseness.ok)
        self.assertEqual(report.global_minimum.names, ("res_8", "res_27"))

    def test_drive_states_are_few_and_recorded(self):
        digit_system, tasks, system = small_fixture()
        counter = StepCounter()
        library = standard_library(digit_system)
        values = channel_values(digit_system, library, counter)
        report = compile_distinctions(digit_system, system, library, values, counter)
        self.assertGreater(len(report.drive_states), 0)
        self.assertLess(len(report.drive_states), digit_system.size // 4)
        for x, y in report.cumulative_pairs:
            self.assertIn(x, report.drive_states)
            self.assertIn(y, report.drive_states)


# --------------------------------------------------------------------------
# 7. channels and the digit system itself
# --------------------------------------------------------------------------


class TestChannelsAndSystem(unittest.TestCase):

    def test_digits_and_value_are_inverse(self):
        digit_system = DigitWordSystem(6, 4)
        for value in range(digit_system.size):
            self.assertEqual(digit_system.value(digit_system.digits(value)), value)

    def test_actions_match_their_closed_forms(self):
        digit_system = DigitWordSystem(6, 4)
        counter = StepCounter()
        size = digit_system.size
        for value in range(size):
            digits = digit_system.digits(value)
            self.assertEqual(digit_system.value(digit_system.act("T", digits, counter)), (value + 1) % size)
            self.assertEqual(digit_system.value(digit_system.act("E", digits, counter)), size - 1 - value)

    def test_E_T_E_is_T_inverse(self):
        """DIGIT_CRYSTAL Thm 3.2: E T E^-1 = T^-1, checked on every state."""
        digit_system = DigitWordSystem(6, 4)
        counter = StepCounter()
        size = digit_system.size
        for value in range(size):
            digits = digit_system.digits(value)
            out = digit_system.act("E", digit_system.act("T", digit_system.act("E", digits, counter), counter), counter)
            self.assertEqual(digit_system.value(out), (value - 1) % size)

    def test_D_and_E_commute_and_are_involutions(self):
        """DIGIT_CRYSTAL Thm 3.1: <D,E> is Klein four on W_n for n >= 2."""
        digit_system = DigitWordSystem(6, 4)
        counter = StepCounter()
        for value in range(0, digit_system.size, 5):
            digits = digit_system.digits(value)
            de = digit_system.act("D", digit_system.act("E", digits, counter), counter)
            ed = digit_system.act("E", digit_system.act("D", digits, counter), counter)
            self.assertEqual(de, ed)
            self.assertEqual(digit_system.act("D", digit_system.act("D", digits, counter), counter), digits)
            self.assertEqual(digit_system.act("E", digit_system.act("E", digits, counter), counter), digits)

    def test_residue_channel_agrees_with_direct_arithmetic(self):
        digit_system = DigitWordSystem(6, 5)
        counter = StepCounter()
        for modulus in (2, 4, 8, 3, 9, 27, 5, 7, 216):
            channel = residue_channel(6, 5, modulus)
            for value in range(0, digit_system.size, 37):
                self.assertEqual(
                    channel.eval_word(digit_system.digits(value), counter),
                    value % modulus,
                    "res_%d disagrees at %d" % (modulus, value),
                )

    def test_residue_channel_truncation_is_exactly_right(self):
        # 6^3 = 216 = 8*27, so mod 8 and mod 27 need exactly 3 digits.
        self.assertEqual(truncation_length(6, 8, 6), 3)
        self.assertEqual(truncation_length(6, 27, 6), 3)
        self.assertEqual(truncation_length(6, 16, 6), 4)
        self.assertEqual(truncation_length(6, 5, 6), 6)  # 5 never divides 6^k
        self.assertEqual(residue_channel(6, 6, 8).reads, 3)
        self.assertEqual(residue_channel(6, 6, 5).reads, 6)

    def test_channel_declared_cost_is_never_exceeded(self):
        digit_system = DigitWordSystem(6, 5)
        for channel in standard_library(digit_system):
            for value in range(0, digit_system.size, 53):
                counter = StepCounter()
                channel.eval_word(digit_system.digits(value), counter)
                self.assertLessEqual(
                    counter.total(),
                    channel.reads,
                    "%s charged more than it declared" % channel.name,
                )

    def test_prime_powers_dividing(self):
        self.assertEqual(prime_powers_dividing(46656, 6), (2, 4, 8, 16, 32, 64, 3, 9, 27, 81, 243, 729))
        self.assertEqual(prime_powers_dividing(8, 3), (2, 4, 8))

    def test_library_has_no_duplicate_names(self):
        names = [channel.name for channel in standard_library(DigitWordSystem(6, 6))]
        self.assertEqual(len(names), len(set(names)))

    def test_refines_helper(self):
        self.assertTrue(refines([0, 1, 2, 3], [0, 0, 1, 1]))
        self.assertFalse(refines([0, 0, 1, 1], [0, 1, 2, 3]))


# --------------------------------------------------------------------------
# 8. discipline: determinism, no floating point, exact counters
# --------------------------------------------------------------------------


class TestDiscipline(unittest.TestCase):

    SOURCES = [
        os.path.join(RUNTIME, "distinguish", "__init__.py"),
        os.path.join(RUNTIME, "distinguish", "observe.py"),
        os.path.join(RUNTIME, "distinguish", "refine.py"),
        os.path.join(RUNTIME, "distinguish", "channels.py"),
        os.path.join(RUNTIME, "demo", "distinguish_demo.py"),
    ]

    def test_no_floating_point_in_the_package(self):
        """No float literal and no true division anywhere in the executed code.

        Checked on the parsed syntax tree, not by grepping text, so prose in
        docstrings cannot mask a real ``/`` and cannot cause a false alarm.
        """
        for path in self.SOURCES:
            with open(path, "r", encoding="utf-8") as handle:
                tree = ast.parse(handle.read(), filename=path)
            name = os.path.basename(path)
            for node in ast.walk(tree):
                if isinstance(node, ast.Constant) and isinstance(node.value, (float, complex)):
                    self.fail("%s:%d has a float literal %r" % (name, node.lineno, node.value))
                if isinstance(node, ast.BinOp) and isinstance(node.op, ast.Div):
                    self.fail("%s:%d uses true division" % (name, node.lineno))
                if isinstance(node, ast.AugAssign) and isinstance(node.op, ast.Div):
                    self.fail("%s:%d uses true division" % (name, node.lineno))

    def test_imports_are_stdlib_only_and_package_local(self):
        """Independence: no numpy, no randomness, no sibling runtime modules."""
        banned_roots = {"numpy", "scipy", "random", "kernel", "crystallize", "torch", "sympy"}
        for path in self.SOURCES:
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
                    root = module.split(".")[0]
                    self.assertNotIn(root, banned_roots, "%s imports %s" % (name, module))

    def test_step_counter_rejects_negative_amounts(self):
        counter = StepCounter()
        with self.assertRaises(ValueError):
            counter.tick("x", -1)

    def test_step_counter_report_is_sorted_and_total_is_exact(self):
        counter = StepCounter()
        counter.tick("b", 2)
        counter.tick("a", 3)
        counter.tick("b")
        self.assertEqual(counter.report(), (("a", 3), ("b", 3)))
        self.assertEqual(counter.total(), 6)
        self.assertIsInstance(counter.total(), int)

    def test_compile_is_deterministic_in_process(self):
        digit_system, tasks, system = small_fixture()
        results = []
        for _ in range(2):
            counter = StepCounter()
            local_system = build_digit_system(digit_system, tasks, counter)
            library = standard_library(digit_system)
            values = channel_values(digit_system, library, counter)
            report = compile_distinctions(digit_system, local_system, library, values, counter)
            results.append(
                (
                    report.observation.names,
                    report.mn_blocks,
                    report.mn_partition,
                    tuple(item.collisions[0].as_tuple() for item in report.rounds),
                    counter.report(),
                )
            )
        self.assertEqual(results[0], results[1])

    def test_demo_is_byte_identical_across_processes(self):
        """Two separate interpreters, different hash seeds, same bytes."""
        demo = os.path.join(RUNTIME, "demo", "distinguish_demo.py")
        digests = []
        for seed in ("0", "1"):
            env = dict(os.environ)
            env["PYTHONHASHSEED"] = seed
            proc = subprocess.run(
                [sys.executable, demo], capture_output=True, env=env, cwd=REPO, timeout=900
            )
            self.assertEqual(proc.returncode, 0, proc.stderr.decode("utf-8")[-2000:])
            digests.append(hashlib.sha256(proc.stdout).hexdigest())
        self.assertEqual(digests[0], digests[1])

    def test_demo_reports_its_own_digest_correctly(self):
        demo = os.path.join(RUNTIME, "demo", "distinguish_demo.py")
        proc = subprocess.run([sys.executable, demo], capture_output=True, cwd=REPO, timeout=900)
        self.assertEqual(proc.returncode, 0)
        raw = proc.stdout
        marker = b"report-sha256"
        cut = raw.rindex(marker)
        body = raw[:cut]
        last = raw[cut:].decode("utf-8").strip()
        self.assertTrue(last.startswith("report-sha256"))
        # the demo digests the report text without its final newline
        self.assertEqual(hashlib.sha256(body[:-1]).hexdigest(), last.split()[1])

    def test_demo_verdict_line_is_present_and_positive(self):
        demo = os.path.join(RUNTIME, "demo", "distinguish_demo.py")
        proc = subprocess.run([sys.executable, demo], capture_output=True, cwd=REPO, timeout=900)
        text = proc.stdout.decode("utf-8")
        self.assertIn("VERDICT: SEED CRITERION MET", text)
        self.assertIn("strictly fewer steps than raw?", text)
        self.assertIn("NULL CONTROL", text)
        self.assertIn("collision detected?", text)


if __name__ == "__main__":
    unittest.main(verbosity=2)
