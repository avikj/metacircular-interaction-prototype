#!/usr/bin/env python3

import unittest
from itertools import product

from jet_tower_depth import (
    determines,
    evaluate,
    fermat_shift,
    initial_form_depth,
    initial_form_values,
    minimal_depth,
    power_residues,
    predicts_determination,
    tower_family,
    valuation,
)


class DecisionProcedureTests(unittest.TestCase):
    """The verifier must be exact before it can referee anyone's theorem."""

    def test_depth_e_plus_one_always_determines(self):
        for polynomial, arity in (
            (lambda v: v[0] ** 3 + v[1] ** 3, 2),
            (lambda v: v[0] ** 2 - v[1] ** 3, 2),
            (lambda v: 9 + v[0] ** 2, 1),
        ):
            for prime in (2, 3, 5):
                for point in product(range(-4, 5), repeat=arity):
                    if polynomial(point) == 0:
                        continue
                    order = valuation(polynomial(point), prime)
                    if order > 5:
                        continue
                    self.assertTrue(
                        determines(polynomial, point, prime, order + 1, order, arity))

    def test_determination_is_monotone_in_depth(self):
        polynomial, arity = (lambda v: v[0] ** 2 + v[1] ** 2), 2
        for prime in (2, 3, 5):
            for point in product(range(-4, 5), repeat=arity):
                if polynomial(point) == 0:
                    continue
                order = valuation(polynomial(point), prime)
                if order > 4:
                    continue
                flags = [determines(polynomial, point, prime, k, order, arity)
                         for k in range(order + 2)]
                self.assertEqual(flags, sorted(flags),
                                 f"non-monotone at p={prime} x={point}")

    def test_reproduces_the_scaled_jet_notes_worked_examples(self):
        """SCALED_JET_DEPTH's two Hessian-shape examples, independently."""
        self.assertEqual(minimal_depth(lambda v: 9 + v[0] ** 2, (0,), 3, 1), (1, 2))
        self.assertEqual(minimal_depth(lambda v: 25 + v[0] ** 2, (0,), 5, 1), (2, 2))

    def test_reproduces_the_tangent_notes_vanishing_gradient_instance(self):
        """TANGENT_WITNESS section 4: X^3+Y^3 at (1,2), p=3, depth 2 not 3."""
        self.assertEqual(
            minimal_depth(lambda v: v[0] ** 3 + v[1] ** 3, (1, 2), 3, 2), (2, 2))


class TangentDensityTests(unittest.TestCase):
    """The 1/p density bullet fails exactly where the gradient vanishes."""

    def test_density_is_zero_not_one_over_p_on_the_notes_own_example(self):
        prime, point = 3, (1, 2)
        polynomial = lambda v: v[0] ** 3 + v[1] ** 3
        order = valuation(polynomial(point), prime)
        unit = (polynomial(point) // prime ** order) % prime
        gradient = (3 * point[0] ** 2 % prime, 3 * point[1] ** 2 % prime)
        solutions = [h for h in product(range(prime), repeat=2)
                     if (gradient[0] * h[0] + gradient[1] * h[1] + unit) % prime == 0]
        self.assertEqual(order, 2)              # in scope: e >= 1
        self.assertEqual(gradient, (0, 0))
        self.assertEqual(len(solutions), 0)     # claimed p^(n-1) = 3
        self.assertNotEqual(len(solutions), prime ** 1)

    def test_density_is_one_over_p_exactly_when_the_gradient_survives(self):
        prime = 3
        polynomial = lambda v: v[0] + v[1]
        for point in product(range(-4, 5), repeat=2):
            if polynomial(point) == 0:
                continue
            order = valuation(polynomial(point), prime)
            if order < 1:
                continue
            unit = (polynomial(point) // prime ** order) % prime
            solutions = [h for h in product(range(prime), repeat=2)
                         if (h[0] + h[1] + unit) % prime == 0]
            self.assertEqual(len(solutions), prime)     # p^(n-1)


class TowerDepthTests(unittest.TestCase):
    def test_the_fermat_shift_drops_by_one_across_a_p_step(self):
        """s(h+p) = s(h) - 1, so s is onto F_p and not a function of h mod p."""
        for prime in (3, 5, 7, 11):
            for point in range(-20, 21):
                self.assertEqual(fermat_shift(point + prime, prime),
                                 (fermat_shift(point, prime) - 1) % prime)
            self.assertEqual({fermat_shift(h, prime) for h in range(prime * prime)},
                             set(range(prime)))

    def test_the_initial_form_is_silent_across_the_whole_family(self):
        for prime in (3, 5, 7):
            for power in range(1, 5):
                coefficients, _ = tower_family(prime, power, 1)
                self.assertEqual(
                    set(initial_form_values(coefficients, prime, 1)), {0},
                    f"p={prime} m={power}")

    def test_the_gap_below_e_is_exactly_m(self):
        for prime in (3, 5, 7):
            for power in range(1, 5):
                coefficients, order = tower_family(prime, power, 1)
                self.assertEqual(order, power * (prime + 1))
                self.assertEqual(order - initial_form_depth(coefficients, prime, 1),
                                 power)

    def test_theorem_J_power_residue_criterion(self):
        """Depth 1 determines iff -u is not an m-th power mod p."""
        for prime in (3, 5, 7):
            for power in range(1, 6):
                for unit in range(1, prime):
                    coefficients, order = tower_family(prime, power, unit)
                    observed = all(
                        valuation(evaluate(coefficients, prime * h), prime) == order
                        for h in range(-3 * prime * prime, 3 * prime * prime + 1))
                    self.assertEqual(
                        observed, predicts_determination(prime, power, unit),
                        f"p={prime} m={power} u={unit}")

    def test_the_silent_branch_can_go_either_way(self):
        """Both outcomes occur with mu_k < e and an identically zero form."""
        outcomes = set()
        for prime in (3, 5, 7):
            for power in range(1, 5):
                outcomes.add(predicts_determination(prime, power, 1))
        self.assertEqual(outcomes, {True, False})

    def test_a_named_specimen_determines_below_its_own_jet(self):
        """f = 3^8 + (X^3-9X)^2: mu_1 = 6 < e = 8, form silent, depth 1 wins."""
        coefficients, order = tower_family(3, 2, 1)
        self.assertEqual(order, 8)
        self.assertEqual(initial_form_depth(coefficients, 3, 1), 6)
        self.assertEqual(set(initial_form_values(coefficients, 3, 1)), {0})
        self.assertEqual(
            minimal_depth(lambda v: evaluate(coefficients, v[0]), (0,), 3, 1),
            (1, 8))

    def test_power_residue_count_matches_the_subgroup_index(self):
        for prime in (3, 5, 7, 11, 13):
            for power in range(1, 8):
                from math import gcd
                self.assertEqual(len(power_residues(prime, power)),
                                 (prime - 1) // gcd(power, prime - 1) + 1)


if __name__ == "__main__":
    unittest.main()
