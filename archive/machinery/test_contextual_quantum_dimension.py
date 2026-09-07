import unittest

from contextual_quantum_dimension import (
    coordinate_crystal,
    exact_memory_dimension,
    profile,
    response_capacity_bound,
)


class ContextualQuantumDimensionTests(unittest.TestCase):
    def test_binary_family_is_sharp(self):
        for coordinate_count in range(1, 4):
            result = profile(2, coordinate_count)
            self.assertEqual(result["context_dimension"], coordinate_count)
            self.assertEqual(result["memory_dimension"], 2 ** coordinate_count)
            self.assertEqual(result["capacity_bound"], 2 ** coordinate_count)

    def test_ternary_family_is_sharp(self):
        result = profile(3, 2)
        self.assertEqual(result["context_dimension"], 2)
        self.assertEqual(result["memory_dimension"], 9)
        self.assertEqual(result["fiber_count"], 9)

    def test_every_state_is_predictively_distinct(self):
        crystal = coordinate_crystal(2, 3)
        self.assertEqual(exact_memory_dimension(crystal), 8)
        self.assertTrue(all(len(fiber) == 1 for fiber in crystal.fibers))

    def test_response_capacity_formula(self):
        self.assertEqual(response_capacity_bound(5, 0), 1)
        self.assertEqual(response_capacity_bound(5, 4), 625)
        with self.assertRaises(ValueError):
            response_capacity_bound(0, 2)


if __name__ == "__main__":
    unittest.main()
