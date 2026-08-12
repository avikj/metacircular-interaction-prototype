import unittest

from observation_crystal import binary_closure, build_crystal


class ObservationCrystalTests(unittest.TestCase):
    def test_biextensional_collapse_retains_defect_fibers(self):
        points = ("a", "a2", "b")
        probes = ("red", "red-copy", "round")
        values = {
            ("a", "red"): 1, ("a", "red-copy"): 1, ("a", "round"): 0,
            ("a2", "red"): 1, ("a2", "red-copy"): 1, ("a2", "round"): 0,
            ("b", "red"): 0, ("b", "red-copy"): 0, ("b", "round"): 1,
        }
        crystal = build_crystal(points, probes, values)
        self.assertIn(("a", "a2"), crystal.point_fibers)
        self.assertIn(("red", "red-copy"), crystal.probe_fibers)
        self.assertEqual(len(crystal.matrix), 2)
        self.assertEqual(len(crystal.matrix[0]), 2)

    def test_minimum_probe_family_can_be_three(self):
        points = tuple(range(8))
        probes = (0, 1, 2)
        values = {(point, bit): (point >> bit) & 1
                  for point in points for bit in probes}
        crystal = build_crystal(points, probes, values)
        self.assertEqual(len(crystal.separating_probes), 3)
        self.assertFalse(crystal.unresolved_point_pairs)

    def test_transpose_exchanges_points_and_probes(self):
        points, probes = ("x", "y"), ("p", "q", "r")
        values = {(x, p): int((i + j) % 2 == 0)
                  for i, x in enumerate(points) for j, p in enumerate(probes)}
        crystal = build_crystal(points, probes, values)
        dual = crystal.transpose()
        self.assertEqual(dual.matrix,
                         tuple(zip(*crystal.matrix)))

    def test_binary_double_prime_closure(self):
        points, probes = ("sparrow", "eagle", "stone"), ("flies", "living")
        values = {
            ("sparrow", "flies"): True, ("sparrow", "living"): True,
            ("eagle", "flies"): True, ("eagle", "living"): True,
            ("stone", "flies"): False, ("stone", "living"): False,
        }
        extent, intent = binary_closure(points, probes, values, ("sparrow",))
        self.assertEqual(extent, ("sparrow", "eagle"))
        self.assertEqual(intent, ("flies", "living"))


if __name__ == "__main__":
    unittest.main()
