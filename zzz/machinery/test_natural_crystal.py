import unittest
from contextlib import redirect_stdout
from io import StringIO
from itertools import product

from natural_crystal import (
    _show_crt,
    _show_divisibility,
    _show_linear,
    _show_pattern,
    binary_divisibility_classes,
    chinese_remainder_view,
    compile_experiment,
    crystallize,
    distinction_horizon,
    divisibility_classes,
    divisibility_horizon,
    divisibility_world,
    explain_distinctions,
    extend_observation,
    generate_world,
    learn_experiments,
    linear_observation_classes,
    linear_observation_world,
    minimal_sensor_sets,
    multiple_remainder_view,
    pattern_world,
    radix_divisibility_classes,
    radix_divisibility_signature,
    run_word,
    shortest_distinguishing_word,
)


class NaturalCrystalTests(unittest.TestCase):
    def test_exhaustive_tiny_worlds_match_witness_semantics(self):
        for state_count in (1, 2, 3):
            states = tuple(range(state_count))
            actions = (0, 1)
            keys = tuple(product(states, actions))
            for targets in product(states, repeat=len(keys)):
                transition = dict(zip(keys, targets))
                for outputs in product((0, 1), repeat=state_count):
                    observation = dict(zip(states, outputs))
                    crystal = crystallize(
                        states, actions, transition, observation
                    )
                    block = {
                        state: index
                        for index, fiber in enumerate(crystal.fibers)
                        for state in fiber
                    }
                    for left in states:
                        for right in states:
                            witness = shortest_distinguishing_word(
                                left, right, actions, transition, observation
                            )
                            self.assertEqual(
                                witness is None,
                                block[left] == block[right],
                                (state_count, transition, observation, left, right),
                            )
                    self.assertLessEqual(
                        distinction_horizon(
                            states, actions, transition, observation
                        ),
                        max(state_count - 2, 0),
                    )

    def test_generation_closes_from_one_seed(self):
        world = generate_world(
            (0,), ("next",), lambda state, _action: min(state + 1, 3), 4
        )
        self.assertTrue(world.closed)
        self.assertEqual(world.states, (0, 1, 2, 3))
        self.assertEqual(world.transition[3, "next"], 3)

    def test_infinite_generation_returns_its_first_omitted_edge(self):
        world = generate_world(
            (0,), ("next",), lambda state, _action: state + 1, 4
        )
        self.assertFalse(world.closed)
        self.assertEqual(world.states, (0, 1, 2, 3))
        self.assertEqual(world.frontier, ((3, "next", 4),))

    def test_generation_rejects_an_empty_beginning(self):
        with self.assertRaises(ValueError):
            generate_world((), ("next",), lambda state, _action: state, 1)

    def test_mod_five_binary_divisibility_refinement_terminates(self):
        world, observation = divisibility_world(2, 5)
        crystal = crystallize(world.states, (0, 1), world.transition, observation)
        self.assertEqual(len(crystal.fibers), 5)
        actions, transition, learned = learn_experiments(
            world.states, (0, 1), world.transition, observation
        )
        self.assertTrue(learned)
        self.assertEqual(
            crystallize(world.states, actions, transition, observation).fibers,
            crystal.fibers,
        )

    def test_divisibility_world_rejects_invalid_arithmetic(self):
        with self.assertRaises(ValueError):
            divisibility_world(1, 5)
        with self.assertRaises(ValueError):
            divisibility_world(2, 0)

    def test_closed_binary_theorem_matches_refinement(self):
        for modulus in range(1, 101):
            world, observation = divisibility_world(2, modulus)
            computed = crystallize(
                world.states, (0, 1), world.transition, observation
            )
            predicted = binary_divisibility_classes(modulus)
            self.assertEqual(
                {frozenset(fiber) for fiber in computed.fibers},
                {frozenset(fiber) for fiber in predicted},
                modulus,
            )
            q, exponent = modulus, 0
            while q % 2 == 0:
                q //= 2
                exponent += 1
            self.assertEqual(len(predicted), q + exponent)

    def test_general_base_horizon_matches_refinement(self):
        for base in range(2, 11):
            digits = tuple(range(base))
            for modulus in range(1, 101):
                world, observation = divisibility_world(base, modulus)
                computed = crystallize(
                    world.states, digits, world.transition, observation
                )
                predicted = divisibility_classes(base, modulus)
                self.assertEqual(
                    {frozenset(fiber) for fiber in computed.fibers},
                    {frozenset(fiber) for fiber in predicted},
                    (base, modulus, divisibility_horizon(base, modulus)),
                )

    def test_general_horizon_rejects_invalid_arithmetic(self):
        with self.assertRaises(ValueError):
            divisibility_horizon(1, 3)
        with self.assertRaises(ValueError):
            divisibility_horizon(2, 0)

    def test_divisibility_command_reports_the_direct_crystal(self):
        output = StringIO()
        with redirect_stdout(output):
            _show_divisibility(10, 12)
        rendered = output.getvalue()
        self.assertIn("base: 10", rendered)
        self.assertIn("modulus: 12", rendered)
        self.assertIn("minimal states (7)", rendered)

    def test_pattern_world_remembers_only_relevant_suffix(self):
        world, observation = pattern_world("aba", ("a", "b"))
        self.assertTrue(world.closed)
        self.assertEqual(set(world.states), {0, 1, 2, 3})
        crystal = crystallize(
            world.states, ("a", "b"), world.transition, observation
        )
        self.assertEqual(len(crystal.fibers), 4)
        self.assertEqual(world.transition[2, "a"], 3)
        self.assertEqual(world.transition[2, "b"], 0)

    def test_pattern_command_runs_the_same_learning_loop(self):
        output = StringIO()
        with redirect_stdout(output):
            _show_pattern("aba", "ab")
        rendered = output.getvalue()
        self.assertIn("pattern: 'aba'", rendered)
        self.assertIn("minimal future classes", rendered)
        self.assertIn("learned letter blocks", rendered)

    def test_pattern_world_rejects_malformed_language(self):
        with self.assertRaises(ValueError):
            pattern_world("", ("a",))
        with self.assertRaises(ValueError):
            pattern_world("ab", ("a",))

    def test_linear_sensor_classes_equal_future_quotient(self):
        systems = (
            (3, (2, 4, 1), 1),  # cyclic: full rank
            (3, (1, 2, 0), 1),  # only first coordinate is visible
            (4, (2, 4, 8, 1), 3),
        )
        for dimension, rows, sensor in systems:
            world, observation = linear_observation_world(
                dimension, rows, sensor
            )
            computed = crystallize(
                world.states, ("evolve",), world.transition, observation
            )
            direct, rank = linear_observation_classes(
                dimension, rows, sensor
            )
            self.assertEqual(
                {frozenset(fiber) for fiber in computed.fibers},
                {frozenset(fiber) for fiber in direct},
            )
            self.assertEqual(len(direct), 2 ** rank)

    def test_linear_sensor_rejects_dimension_mismatch(self):
        with self.assertRaises(ValueError):
            linear_observation_world(2, (1,), 1)

    def test_linear_sensor_command(self):
        output = StringIO()
        with redirect_stdout(output):
            _show_linear()
        self.assertIn("observable concepts: 2^3 = 8", output.getvalue())

    def test_time_can_make_one_sensor_sufficient(self):
        self.assertEqual(
            minimal_sensor_sets(3, (2, 4, 1), (1, 2, 4)),
            ((1,), (2,), (4,)),
        )

    def test_static_world_needs_all_coordinate_sensors(self):
        self.assertEqual(
            minimal_sensor_sets(3, (1, 2, 4), (1, 2, 4)),
            ((1, 2, 4),),
        )

    def test_sensor_search_returns_empty_when_grammar_is_insufficient(self):
        self.assertEqual(minimal_sensor_sets(3, (1, 2, 4), (1, 2)), ())

    def test_coprime_views_reconstruct_exactly(self):
        fibers, common, combined = chinese_remainder_view(3, 4)
        self.assertEqual((common, combined, len(fibers)), (1, 12, 12))
        self.assertTrue(all(len(fiber) == 1 for _view, fiber in fibers))

    def test_non_coprime_views_retain_overlap_and_residual(self):
        fibers, common, combined = chinese_remainder_view(4, 6)
        self.assertEqual((common, combined, len(fibers)), (2, 12, 12))
        self.assertTrue(all(len(fiber) == 2 for _view, fiber in fibers))
        self.assertTrue(all(
            left % common == right % common for (left, right), _fiber in fibers
        ))

    def test_crt_view_rejects_nonpositive_modulus(self):
        with self.assertRaises(ValueError):
            chinese_remainder_view(0, 3)

    def test_crt_command_exposes_failed_exact_reconstruction(self):
        output = StringIO()
        with redirect_stdout(output):
            _show_crt(4, 6)
        rendered = output.getvalue()
        self.assertIn("shared overlap gcd: 2", rendered)
        self.assertIn("exact reconstruction: False", rendered)

    def test_many_views_glue_pairwise_and_retain_uniform_residual(self):
        fibers, residual, combined = multiple_remainder_view((4, 6, 9))
        self.assertEqual((len(fibers), residual, combined), (36, 6, 36))
        self.assertTrue(all(len(fiber) == 6 for _view, fiber in fibers))

    def test_pairwise_coprime_many_views_reconstruct(self):
        fibers, residual, combined = multiple_remainder_view((3, 4, 5))
        self.assertEqual((len(fibers), residual, combined), (60, 1, 60))

    def test_many_view_rejects_empty_cover(self):
        with self.assertRaises(ValueError):
            multiple_remainder_view(())

    def test_binary_class_formula_rejects_nonpositive_modulus(self):
        with self.assertRaises(ValueError):
            binary_divisibility_classes(0)

    def test_general_radix_signature_matches_behavioral_refinement(self):
        for base in range(2, 11):
            for modulus in range(1, 61):
                world, observation = divisibility_world(base, modulus)
                computed = crystallize(
                    world.states, tuple(range(base)), world.transition, observation
                )
                predicted = radix_divisibility_classes(base, modulus)
                self.assertEqual(
                    {frozenset(fiber) for fiber in computed.fibers},
                    {frozenset(fiber) for fiber in predicted},
                    (base, modulus),
                )

    def test_binary_closed_form_is_the_general_signature_collapse(self):
        for modulus in range(1, 101):
            self.assertEqual(
                {frozenset(fiber) for fiber in binary_divisibility_classes(modulus)},
                {frozenset(fiber) for fiber in radix_divisibility_classes(2, modulus)},
            )

    def test_binary_count_does_not_generalize_naively(self):
        self.assertEqual(len(radix_divisibility_classes(10, 12)), 7)
        self.assertNotEqual(len(radix_divisibility_classes(10, 12)), 3 + 2)

    def test_radix_signature_rejects_invalid_input(self):
        with self.assertRaises(ValueError):
            radix_divisibility_signature(1, 5, 0)
        with self.assertRaises(ValueError):
            radix_divisibility_signature(2, 5, 5)

    def test_context_distinguishes_equal_present_outputs(self):
        states = ("p", "q", "bright", "dark")
        actions = ("probe",)
        transition = {
            ("p", "probe"): "bright",
            ("q", "probe"): "dark",
            ("bright", "probe"): "bright",
            ("dark", "probe"): "dark",
        }
        observation = {"p": 0, "q": 0, "bright": 1, "dark": 2}
        crystal = crystallize(states, actions, transition, observation)
        self.assertEqual(len(crystal.fibers), 4)
        word = shortest_distinguishing_word(
            "p", "q", actions, transition, observation
        )
        self.assertEqual(word, ("probe",))
        self.assertNotEqual(
            observation[run_word("p", word, transition)],
            observation[run_word("q", word, transition)],
        )

    def test_origins_survive_true_crystallization(self):
        states = ("a", "b", "end")
        actions = ("step",)
        transition = {
            ("a", "step"): "end",
            ("b", "step"): "end",
            ("end", "step"): "end",
        }
        observation = {"a": 0, "b": 0, "end": 1}
        crystal = crystallize(states, actions, transition, observation)
        self.assertIn(("a", "b"), crystal.fibers)
        self.assertIsNone(shortest_distinguishing_word(
            "a", "b", actions, transition, observation
        ))

    def test_every_crystal_fiber_is_exactly_the_none_witness_pairs(self):
        states = (0, 1, 2, 3)
        actions = ("next",)
        transition = {
            (0, "next"): 1,
            (1, "next"): 2,
            (2, "next"): 3,
            (3, "next"): 3,
        }
        observation = {0: 0, 1: 0, 2: 0, 3: 1}
        crystal = crystallize(states, actions, transition, observation)
        explanations = explain_distinctions(
            states, actions, transition, observation
        )
        same_fiber = {
            tuple(sorted((left, right)))
            for fiber in crystal.fibers
            for index, left in enumerate(fiber)
            for right in fiber[index + 1:]
        }
        no_witness = {
            tuple(sorted(pair)) for pair, word in explanations.items()
            if word is None
        }
        self.assertEqual(no_witness, same_fiber)
        self.assertEqual(explanations[(0, 1)], ("next", "next"))
        self.assertEqual(explanations[(1, 2)], ("next",))
        self.assertEqual(
            distinction_horizon(states, actions, transition, observation), 2
        )

    def test_discovered_experiment_becomes_one_action_without_new_meaning(self):
        states = (0, 1, 2, 3)
        actions = ("next",)
        transition = {
            (0, "next"): 1,
            (1, "next"): 2,
            (2, "next"): 3,
            (3, "next"): 3,
        }
        observation = {0: 0, 1: 0, 2: 0, 3: 1}
        before = crystallize(states, actions, transition, observation)
        old_word = shortest_distinguishing_word(
            0, 1, actions, transition, observation
        )
        self.assertEqual(old_word, ("next", "next"))

        new_actions, new_transition = compile_experiment(
            states, actions, transition, "look-two", old_word
        )
        after = crystallize(states, new_actions, new_transition, observation)
        self.assertEqual(after.fibers, before.fibers)
        self.assertEqual(shortest_distinguishing_word(
            0, 1, new_actions, new_transition, observation
        ), ("look-two",))

    def test_compilation_fails_closed(self):
        transition = {(0, "step"): 0}
        with self.assertRaises(ValueError):
            compile_experiment((0,), ("step",), transition, "step", ("step",))
        with self.assertRaises(ValueError):
            compile_experiment((0,), ("step",), transition, "new", ())
        with self.assertRaises(ValueError):
            compile_experiment((0,), ("step",), transition, "new", ("missing",))

    def test_machine_selects_and_installs_its_own_shortcuts(self):
        states = (0, 1, 2, 3)
        actions = ("next",)
        transition = {
            (0, "next"): 1,
            (1, "next"): 2,
            (2, "next"): 3,
            (3, "next"): 3,
        }
        observation = {0: 0, 1: 0, 2: 0, 3: 1}
        before = crystallize(states, actions, transition, observation)
        new_actions, new_transition, learned = learn_experiments(
            states, actions, transition, observation
        )
        after = crystallize(states, new_actions, new_transition, observation)
        self.assertEqual(after.fibers, before.fibers)
        self.assertEqual(learned, (("learned-1", ("next", "next"), 1),))
        explanations = explain_distinctions(
            states, new_actions, new_transition, observation
        )
        self.assertTrue(all(
            word is None or len(word) <= 1 for word in explanations.values()
        ))

    def test_learned_actions_unfold_to_original_actions(self):
        world, observation = divisibility_world(2, 5)
        actions, transition, learned = learn_experiments(
            world.states, (0, 1), world.transition, observation
        )
        self.assertEqual(
            learned,
            (("learned-1", (0, 1), 2),
             ("learned-2", (0, 0, 1), 1)),
        )
        for name, expansion, _gain in learned:
            for state in world.states:
                self.assertEqual(
                    transition[state, name],
                    run_word(state, expansion, world.transition),
                )

    def test_new_view_refines_meaning_without_erasing_old_view(self):
        states = (0, 1, 2)
        actions = ("stay",)
        transition = {(state, "stay"): state for state in states}
        observation = {0: "dark", 1: "light", 2: "light"}
        before = crystallize(states, actions, transition, observation)
        self.assertIn((1, 2), before.fibers)

        richer = extend_observation(
            states, observation, {0: "round", 1: "round", 2: "square"}
        )
        after = crystallize(states, actions, transition, richer)
        self.assertEqual(len(after.fibers), 3)
        self.assertEqual(richer[1], ("light", "round"))
        self.assertEqual(richer[2], ("light", "square"))

    def test_new_view_must_cover_the_world(self):
        with self.assertRaises(ValueError):
            extend_observation((0, 1), {0: 0, 1: 0}, {0: 1})

    def test_rejects_partial_dynamics(self):
        with self.assertRaises(ValueError):
            crystallize((0, 1), ("a",), {(0, "a"): 1}, {0: 0, 1: 1})


if __name__ == "__main__":
    unittest.main()
