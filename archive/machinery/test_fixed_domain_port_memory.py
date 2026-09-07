import unittest

from fixed_domain_port_memory import (
    fixed_domain_memory_dimension,
    memoryless_nominal_equivalent,
    restricted_nominal_memory_dimension,
)


class FixedDomainPortMemoryTests(unittest.TestCase):
    def test_each_ternary_history_has_distinct_future_law(self):
        for depth in range(5):
            self.assertEqual(fixed_domain_memory_dimension(depth), 3**depth)

    def test_twelve_stage_exact_dimension(self):
        self.assertEqual(fixed_domain_memory_dimension(12), 531441)

    def test_memoryless_contraction_fails_on_fixed_nontrivial_domain(self):
        self.assertFalse(memoryless_nominal_equivalent(1))
        self.assertFalse(memoryless_nominal_equivalent(12))

    def test_domain_restriction_changes_answer_to_one(self):
        self.assertEqual(restricted_nominal_memory_dimension(12), 1)
        self.assertTrue(memoryless_nominal_equivalent(0))


if __name__ == "__main__":
    unittest.main()
