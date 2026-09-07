import unittest
from itertools import combinations

from developmental_ports import (
    PortTower,
    capacity_after_contraction,
    eager_contraction_capacity,
    full_process_replayable,
    marginal_capacity,
    response_capacity,
    uninterrupted_capacity,
)


class DevelopmentalPortTests(unittest.TestCase):
    def test_recursive_extension_is_literal(self):
        tower = PortTower(6)
        for depth in range(6):
            for old in __import__("itertools").product((0, 1, 2), repeat=depth):
                for digit in (0, 1, 2):
                    self.assertEqual(
                        tower.extend_response(depth, 7, old, digit),
                        tower.response(depth + 1, 7, old + (digit,)),
                    )

    def test_nominal_endpoint_matches_ternary_compiler(self):
        tower = PortTower(12)
        for depth in range(13):
            self.assertEqual(tower.nominal(depth, 11), (11 + 3**depth) % tower.modulus)
        self.assertEqual(3**12, 531441)

    def test_each_retained_port_triples_capacity(self):
        tower = PortTower(6)
        indices = range(6)
        for count in range(7):
            for retained in combinations(indices, count):
                self.assertEqual(
                    len(tower.retained_responses(6, retained)), 3**count
                )
        self.assertTrue(
            all(marginal_capacity(k + 1) > marginal_capacity(k) for k in range(5))
        )

    def test_recursive_proof_support_is_conjunctive(self):
        self.assertFalse(full_process_replayable(3, (0, 1)))
        self.assertFalse(full_process_replayable(3, (0, 2)))
        self.assertTrue(full_process_replayable(3, (0, 1, 2)))

    def test_contraction_loss_persists_but_is_not_absolute_death(self):
        for initial in range(7):
            for later in range(7):
                open_capacity = uninterrupted_capacity(initial, later)
                regrown_capacity = capacity_after_contraction(initial, later)
                self.assertEqual(open_capacity, 3**initial * regrown_capacity)
                self.assertEqual(eager_contraction_capacity(initial + later), 1)

    def test_twelve_stage_opposite_projections(self):
        tower = PortTower(12)
        self.assertEqual(response_capacity(12), 531441)
        self.assertEqual(eager_contraction_capacity(12), 1)
        # Same nominal endpoint under the only history the contraction admits.
        self.assertEqual(tower.nominal(12, 0), tower.response(12, 0, (0,) * 12))


if __name__ == "__main__":
    unittest.main()
