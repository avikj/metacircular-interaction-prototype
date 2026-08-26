#!/usr/bin/env python3
"""Exact tests for the memory / step-count power law.

Run: python3 -m unittest test_memory_step_tradeoff -v   (from machinery/)
"""

import unittest

from memory_step_tradeoff import (
    Tradeoff,
    horner_reconstruction,
    necessary_held,
    positional_base,
    reach_bound,
    tradeoff,
    worst_case_steps,
)


class MemoryStepTradeoffTests(unittest.TestCase):
    def test_positional_base_is_the_least_adequate_one(self):
        for modulus in (100, 6561, 15625, 2**20, 10**9):
            for digits in (2, 3, 4, 5):
                base = positional_base(modulus, digits)
                self.assertGreaterEqual(base**digits, modulus)
                self.assertLess((base - 1) ** digits, modulus)

    def test_reconstruction_is_exact_and_uses_only_held_operands(self):
        """Every operand is the accumulator, the base, or a digit -- all in F."""
        for modulus, digits in ((6561, 3), (15625, 3), (2**16, 4)):
            base = positional_base(modulus, digits)
            held = set(range(base + 1))
            for c in range(0, modulus, max(1, modulus // 400)):
                trace = horner_reconstruction(c, base, digits)
                acc = None
                for op, operand in trace:
                    self.assertIn(operand, held)
                    self.assertIn(op, "*+")
                # replay the trace from the leading digit
                limbs = []
                x = c
                for _ in range(digits):
                    limbs.append(x % base)
                    x //= base
                limbs.reverse()
                acc = limbs[0]
                self.assertIn(acc, held)
                for op, operand in trace:
                    acc = acc * operand if op == "*" else acc + operand
                self.assertEqual(acc, c)

    def test_sufficiency_bound_two_n_minus_two(self):
        """Theorem P: every class in at most 2n-2 operations."""
        for modulus in (6561, 15625, 2**20, 3**10):
            for digits in (2, 3, 4, 5):
                worst = worst_case_steps(modulus, digits)
                self.assertLessEqual(worst, 2 * digits - 2)
                self.assertEqual(worst, 2 * digits - 2)   # and it is attained

    def test_counting_necessity(self):
        """Theorem N: below `necessary_held`, classes are provably missed."""
        for modulus in (10**6, 10**12, 3**40):
            for steps in (1, 2, 4, 6):
                need = necessary_held(modulus, steps)
                self.assertGreaterEqual(reach_bound(need, steps), modulus)
                if need > 1:
                    self.assertLess(reach_bound(need - 1, steps), modulus)

    def test_the_power_law_brackets_the_held_set(self):
        """M^(1/2n) <~ |F| <~ M^(1/n), both sides proved."""
        for modulus in (10**12, 10**24):
            for n in (2, 3, 6):
                t = tradeoff(modulus, n, exact=False)
                self.assertLessEqual(t.necessary, t.sufficient)
                # sufficiency really is about M^(1/n)
                self.assertLessEqual(t.sufficient, 2 * modulus ** (1 / n) + 2)
                # necessity really is about M^(1/2n), within the slack
                self.assertLessEqual(t.necessary, modulus ** (1 / (2 * n)) * 2)

    def test_memory_polynomial_in_log_m_leaves_the_floor(self):
        """Holding poly(log M) numbers does not reach constant step count."""
        for modulus in (3**160, 3**640):
            for held in (2, 100, 10**4):
                n = 1
                while reach_bound(held, n) < modulus:
                    n += 1
                self.assertGreater(n, 5)        # still far from constant
        # 3^640 with 10^4 held still needs dozens of operations
        n = 1
        while reach_bound(10**4, n) < 3**640:
            n += 1
        self.assertGreater(n, 30)

    def test_constant_steps_force_a_table(self):
        """Two operations for every class needs |F| polynomial in M."""
        for modulus in (10**12, 10**18, 10**24):
            need = necessary_held(modulus, 2)
            self.assertGreater(need, modulus ** (1 / 5))

    def test_known_false_control_a_threshold_in_memory(self):
        """'there is a threshold where memory suddenly makes classes cheap'."""
        # if a threshold existed, the step count would drop sharply as held
        # grows; instead it decays smoothly.  Record the actual curve.
        modulus = 3**640
        curve = []
        for held in (2, 10, 100, 1000, 10**4, 10**5):
            n = 1
            while reach_bound(held, n) < modulus:
                n += 1
            curve.append(n)
        self.assertEqual(curve, sorted(curve, reverse=True))
        drops = [curve[i] - curve[i + 1] for i in range(len(curve) - 1)]
        self.assertTrue(all(d < curve[0] // 2 for d in drops))  # no cliff

    def test_shape_and_rejections(self):
        t = tradeoff(6561, 3)
        self.assertIsInstance(t, Tradeoff)
        with self.assertRaises(Exception):
            t.necessary = 0
        with self.assertRaises(ValueError):
            reach_bound(0, 2)
        with self.assertRaises(ValueError):
            positional_base(6561, 0)
        with self.assertRaises(ValueError):
            horner_reconstruction(10**9, 3, 2)      # too few digits
        with self.assertRaises(ValueError):
            horner_reconstruction(5, 1, 3)


if __name__ == "__main__":
    unittest.main()
