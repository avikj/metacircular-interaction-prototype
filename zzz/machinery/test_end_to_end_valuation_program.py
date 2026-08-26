import unittest

from end_to_end_valuation_program import compile_run, power_ladder


class EndToEndValuationProgramTests(unittest.TestCase):
    def test_ladder_dependencies(self):
        for p in (2, 3, 5):
            for k in range(1, 6):
                powers, deps = power_ladder(p, k)
                self.assertEqual(powers, [p**e for e in range(1, k + 1)])
                self.assertEqual(len(deps), k - 1)
                for left, right, target in deps:
                    self.assertEqual(left * right, target)

    def test_every_bounded_residue_reconstructs(self):
        for p in (2, 3, 5):
            for k in range(1, 5):
                for r in range(p**k):
                    run = compile_run(r, p, k)
                    self.assertEqual(run["recovered"], r)
                    self.assertEqual(len(run["multiplications"]), k - 1)
                    self.assertLessEqual(len(run["subtractions"]), run["queries"] - 1)

    def test_worst_branch_attains_typed_budget(self):
        for p in (2, 3, 5):
            for k in range(1, 6):
                run = compile_run(p**k - 1, p, k)
                self.assertEqual(run["queries"], k * (p - 1))
                self.assertEqual(len(run["subtractions"]), k * (p - 1) - 1)
                self.assertEqual(
                    len(run["multiplications"]) + len(run["subtractions"]),
                    k * p - 2,
                )


if __name__ == "__main__":
    unittest.main()

