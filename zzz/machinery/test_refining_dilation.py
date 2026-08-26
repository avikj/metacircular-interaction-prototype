#!/usr/bin/env python3

import unittest
from math import ceil

from canonical_depth_memory import canonical_memory, global_depth
from refining_dilation import (
    divisibility_predicate_dimension,
    environment_dimension,
    fixed_sensor_dimension,
    minimal_sufficient_depth,
    qubits,
    refining_dimension,
    refining_qubits,
    valuation,
)


class TheirTheoremsTests(unittest.TestCase):
    """Attacked and upheld: the dilation dimension is the largest fiber."""

    def test_least_environment_dimension_is_the_largest_fiber(self):
        for modulus in (2, 3, 5, 7, 11):
            for size in (10, 50, 91, 200):
                self.assertEqual(
                    environment_dimension(lambda n, m=modulus: n % m, range(size)),
                    ceil(size / modulus),
                    f"m={modulus} N={size}")

    def test_their_formula_five(self):
        self.assertEqual(fixed_sensor_dimension(7, 91), 13)
        self.assertEqual(qubits(13), 4)

    def test_a_fixed_sensor_really_does_diverge(self):
        """Their §5 is correct for a fixed chart."""
        previous = 0
        for size in (10 ** k for k in range(2, 7)):
            current = fixed_sensor_dimension(7, size)
            self.assertGreater(current, previous)
            previous = current


class TheoremQTests(unittest.TestCase):
    def test_the_minimal_chart_agrees_with_the_literal_definition(self):
        for prime in (2, 3, 5, 7):
            for time in range(1, 400):
                self.assertEqual(minimal_sufficient_depth(prime, time),
                                 global_depth(range(1, time + 1), prime),
                                 f"p={prime} t={time}")

    def test_the_dilation_dimension_is_the_memory_I_already_named(self):
        """d_E of codex-quantum-process == M(t) of CANONICAL_DEPTH_MEMORY."""
        for prime in (2, 3, 5, 7):
            for time in range(1, 1000):
                self.assertEqual(refining_dimension(prime, time),
                                 canonical_memory(prime, time),
                                 f"p={prime} t={time}")

    def test_dilation_is_bounded_by_p_uniformly(self):
        for prime in (2, 3, 5, 7, 11):
            for time in range(1, 5000):
                self.assertTrue(1 <= refining_dimension(prime, time) <= prime,
                                f"p={prime} t={time}")

    def test_the_bound_is_attained_hence_sharp(self):
        for prime in (2, 3, 5, 7):
            for power in range(1, 4):
                self.assertEqual(refining_dimension(prime, prime ** (power + 1) - 1),
                                 prime)

    def test_constant_qubits_forever(self):
        self.assertEqual(refining_qubits(2), 1)
        self.assertEqual(refining_qubits(3), 2)
        self.assertEqual(refining_qubits(5), 3)
        for prime in (2, 3, 5):
            for time in range(1, 3000):
                self.assertLessEqual(qubits(refining_dimension(prime, time)),
                                     refining_qubits(prime))

    def test_the_section_four_example_costs_one_qubit_not_four(self):
        self.assertEqual(fixed_sensor_dimension(7, 91), 13)
        self.assertEqual(qubits(13), 4)
        self.assertEqual(minimal_sufficient_depth(7, 91), 2)
        self.assertEqual(refining_dimension(7, 91), 2)
        self.assertEqual(qubits(2), 1)


class WhichObservableTests(unittest.TestCase):
    """The cheap memory belongs to the valuation, not to any coarsening."""

    def test_the_divisibility_predicate_is_more_expensive_not_less(self):
        for modulus in (3, 5, 7):
            for size in (200, 1000):
                coarse = divisibility_predicate_dimension(modulus, size)
                fine = fixed_sensor_dimension(modulus, size)
                self.assertGreater(coarse, fine, f"m={modulus} N={size}")

    def test_the_valuation_chart_is_the_one_that_stays_cheap(self):
        prime, time = 5, 3000
        depth = minimal_sufficient_depth(prime, time)
        self.assertLessEqual(refining_dimension(prime, time), prime)
        self.assertGreater(divisibility_predicate_dimension(prime ** depth, time),
                           prime)
        seen = {valuation(n, prime) for n in range(1, time + 1)
                if (n - prime ** depth) % prime ** depth == 0}
        self.assertTrue(seen)


if __name__ == "__main__":
    unittest.main()
