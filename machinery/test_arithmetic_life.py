#!/usr/bin/env python3

import unittest

from arithmetic_life import ArithmeticLife, run


class ArithmeticLifeTests(unittest.TestCase):
    def test_collision_forms_least_lawful_residue_sensor(self):
        life = ArithmeticLife()
        self.assertEqual(life.form_sensor_for_collision(9, 11), 3)
        self.assertNotEqual(life.profile(9), life.profile(11))

    def test_formed_sensor_transfers_to_unseen_numbers(self):
        life = ArithmeticLife()
        life.form_sensor_for_collision(9, 11)
        self.assertEqual((life.profile(21), life.profile(22)), ((0,), (1,)))

    def test_factor_encounter_changes_future_capacity(self):
        life = ArithmeticLife()
        self.assertEqual(life.factor(91), (7, 13))
        self.assertEqual(life.moduli, [2, 3, 5, 7])
        before = len([event for event in life.events if event.kind == "form-sensor"])
        self.assertEqual(life.factor(77), (7, 11))
        after = len([event for event in life.events if event.kind == "form-sensor"])
        self.assertEqual(before, after)
        self.assertEqual(life.events[-2].kind, "act-batch")

    def test_euclidean_batch_compiles_once(self):
        life = ArithmeticLife()
        life.factor(91)
        life.factor(77)
        self.assertEqual(
            sum(event.kind == "compile-action" for event in life.events), 1
        )

    def test_prime_is_frontier_after_exact_bounded_division(self):
        life = ArithmeticLife()
        self.assertIsNone(life.factor(29))
        self.assertEqual(life.events[-1].kind, "frontier")

    def test_trace_retains_causal_parents(self):
        life = run((15,))
        self.assertTrue(all(event.parents == (i - 1,)
                            for i, event in enumerate(life.events) if i))

    def test_euclidean_overlap_and_origins_form_lcm_join(self):
        life = ArithmeticLife()
        self.assertEqual(life.factor(12), (2, 6))
        self.assertEqual(life.factor(18), (2, 9))
        join = life.join_origins(12, 18)
        self.assertEqual(join.remembered_origins, ((2, 6), (2, 9)))
        self.assertEqual(join.overlap, 6)
        self.assertEqual(join.least_common_multiple, 36)
        self.assertEqual(join.embeddings, (3, 2))
        self.assertEqual(life.events[-1].kind, "form-operation")

    def test_join_requires_actual_origin_memory(self):
        life = ArithmeticLife()
        life.factor(12)
        with self.assertRaises(ValueError):
            life.join_origins(12, 18)


if __name__ == "__main__":
    unittest.main()
