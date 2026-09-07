#!/usr/bin/env python3

import unittest
from math import isqrt

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

    def test_join_needs_no_origin_memory(self):
        """Corrected 2026-08-12 (claude_arithmetic_breaker).

        The old assertion protected a decorative precondition: the join is
        Euclidean and never consulted the stored origins, so demanding them
        only refused legitimate arguments such as primes.
        """
        life = ArithmeticLife()
        life.factor(12)
        self.assertEqual(life.join_origins(12, 18).least_common_multiple, 36)
        self.assertEqual(life.join_origins(97, 143).least_common_multiple, 97 * 143)

    def test_regime_change_is_executed_not_narrated(self):
        life = ArithmeticLife()
        life.factor(91)
        separate = [e for e in life.events if e.kind == "act"]
        self.assertEqual([e.subject[1] for e in separate], [2, 3, 5, 7])
        self.assertEqual([e.kind for e in life.events if e.kind == "act-batch"], [])
        life.factor(77)
        batched = [e for e in life.events if e.kind == "act-batch"]
        self.assertEqual(len(batched), 1)
        self.assertEqual(len([e for e in life.events if e.kind == "act"]), 4)

    def test_injected_composite_sensors_cannot_corrupt_certificates(self):
        life = ArithmeticLife()
        for modulus in (4, 6, 8, 9, 25, 49):
            life.install_residue_sensor(modulus, (0,))
        self.assertEqual(life.factor(200), (2, 100))
        self.assertEqual(life.factor(211), None)
        certified = [e.subject[0] for e in life.events if e.kind == "certify-sensor"]
        for candidate in certified:
            self.assertFalse(
                any(candidate % d == 0 for d in range(2, isqrt(candidate) + 1)),
                f"certify-sensor named the composite {candidate}",
            )

    def test_origin_is_irreducible_under_contamination(self):
        clean, dirty = ArithmeticLife(), ArithmeticLife()
        for modulus in (4, 6, 9, 8, 25, 49, 121):
            dirty.install_residue_sensor(modulus, (0,))
        for n in (64, 91, 200, 143, 289):
            self.assertEqual(clean.factor(n), dirty.factor(n))
            origin = dirty.factor_origins.get(n)
            if origin is not None:
                p = origin[0]
                self.assertFalse(any(p % d == 0 for d in range(2, isqrt(p) + 1)))


if __name__ == "__main__":
    unittest.main()
