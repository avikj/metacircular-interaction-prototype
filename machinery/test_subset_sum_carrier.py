#!/usr/bin/env python3

import unittest
from itertools import combinations

from subset_sum_carrier import (
    compose_carriers,
    form_subset_sum_carrier,
    labeled_subset_sum,
)


def direct_distribution(inputs, modulus):
    counts = [0] * modulus
    for size in range(len(inputs) + 1):
        for indices in combinations(range(len(inputs)), size):
            counts[sum(inputs[index] for index in indices) % modulus] += 1
    return tuple(counts)


class SubsetSumCarrierTests(unittest.TestCase):
    def test_coefficients_are_exact_subset_sum_distribution(self):
        for inputs in ((), (1,), (1, 4, 7), (-2, 5, 11, 13)):
            carrier = form_subset_sum_carrier(inputs, 3, 2)
            self.assertEqual(carrier.coefficients, direct_distribution(inputs, 9))
            self.assertEqual(carrier.subset_count, 2 ** len(inputs))

    def test_disjoint_union_is_cyclic_convolution(self):
        left = form_subset_sum_carrier((1, 4), 3, 2)
        right = form_subset_sum_carrier((7, 8), 3, 2)
        self.assertEqual(
            compose_carriers(left, right),
            form_subset_sum_carrier((1, 4, 7, 8), 3, 2),
        )

    def test_permutation_collision_kills_labeled_sufficiency(self):
        self.assertEqual(
            form_subset_sum_carrier((1, 2), 3, 1),
            form_subset_sum_carrier((2, 1), 3, 1),
        )
        self.assertNotEqual(
            labeled_subset_sum((1, 2), (0,), 3, 1),
            labeled_subset_sum((2, 1), (0,), 3, 1),
        )

    def test_labeled_singletons_recover_terminal_tuple(self):
        inputs = (17, -4, 29, 8)
        recovered = tuple(labeled_subset_sum(inputs, (i,), 5, 2) for i in range(4))
        self.assertEqual(recovered, tuple(value % 25 for value in inputs))

    def test_chart_and_label_errors_fail_closed(self):
        left = form_subset_sum_carrier((1,), 3, 1)
        right = form_subset_sum_carrier((1,), 3, 2)
        with self.assertRaises(ValueError):
            compose_carriers(left, right)
        with self.assertRaises(ValueError):
            labeled_subset_sum((1, 2), (0, 0), 3, 1)
        with self.assertRaises(ValueError):
            form_subset_sum_carrier((1,), 9, 1)


if __name__ == "__main__":
    unittest.main()
