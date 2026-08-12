#!/usr/bin/env python3

import unittest

from symmetry_arithmetic_action import (
    compose,
    fixed_port_execution,
    permute_registers,
    two_port_witness,
)


class SymmetryArithmeticActionTests(unittest.TestCase):
    def test_same_factorial_count_different_fixed_port_behavior(self):
        self.assertEqual(
            two_port_witness(),
            {
                "symmetry_count": 2,
                "identity_fixed": 0,
                "swap_fixed": 4,
                "identity_covariant": 0,
                "swap_covariant": 0,
            },
        )

    def test_action_composition_not_just_cardinality(self):
        cycle = (1, 2, 0)
        swap = (1, 0, 2)
        registers = (2, 3, 4)
        self.assertEqual(
            permute_registers(compose(cycle, swap), registers),
            permute_registers(swap, permute_registers(cycle, registers)),
        )

    def test_identity_and_swap_share_carrier_size(self):
        registers, weights = (1, 2), (1, 2)
        outputs = {
            fixed_port_execution(permutation, registers, weights, 5)
            for permutation in ((0, 1), (1, 0))
        }
        self.assertEqual(outputs, {0, 4})

    def test_covariance_is_not_an_accidental_involution_identity(self):
        from symmetry_arithmetic_action import covariant_execution, evaluate

        cycle = (1, 2, 0)
        registers, weights = (1, 2, 4), (3, 1, 2)
        self.assertEqual(
            covariant_execution(cycle, registers, weights, 5),
            evaluate(registers, weights, 5),
        )


if __name__ == "__main__":
    unittest.main()
