import unittest

from exact_predictive_quantum_memory import (
    addition_distance,
    distance_profile,
    exact_quantum_memory_dimension,
    exact_quantum_memory_qubits,
)


class ExactPredictiveQuantumMemoryTests(unittest.TestCase):
    def setUp(self):
        self.via_three = {1, 2, 3, 6}
        self.via_four = {1, 2, 4, 6}

    def test_critical_witness_continuation_costs(self):
        self.assertEqual(addition_distance(self.via_three, 9), 1)
        self.assertEqual(addition_distance(self.via_four, 9), 2)

    def test_distinct_profiles_require_dimension_two(self):
        caches = (self.via_three, self.via_four)
        self.assertEqual(
            tuple(distance_profile(cache, (9,)) for cache in caches), ((1,), (2,))
        )
        self.assertEqual(exact_quantum_memory_dimension(caches, (9,)), 2)
        self.assertEqual(exact_quantum_memory_qubits(caches, (9,)), 1)

    def test_probe_restriction_can_collapse_profiles(self):
        caches = (self.via_three, self.via_four)
        self.assertEqual(exact_quantum_memory_dimension(caches, (6,)), 1)

    def test_duplicate_profiles_do_not_cost_dimension(self):
        caches = ({1, 2}, {1, 2, 4}, {1, 2, 8})
        self.assertEqual(
            tuple(distance_profile(cache, (3,)) for cache in caches),
            ((1,), (1,), (1,)),
        )
        self.assertEqual(exact_quantum_memory_dimension(caches, (3,)), 1)

    def test_empty_cache_family_rejected(self):
        with self.assertRaises(ValueError):
            exact_quantum_memory_dimension((), (9,))


if __name__ == "__main__":
    unittest.main()
