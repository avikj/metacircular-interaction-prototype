import math
import unittest

from adaptive_center_chain import center_chain
from rolling_power_center import rolling_run


class RollingPowerCenterTests(unittest.TestCase):
    def test_same_trace_for_every_bounded_residue(self):
        for p in (2, 3, 5):
            for k in range(1, 5):
                for r in range(p**k):
                    run = rolling_run(r, p, k)
                    expected, _, recovered = center_chain(r, p, k)
                    self.assertEqual(run["centers"], expected)
                    self.assertEqual(run["recovered"], recovered)

    def test_exact_multiplication_trade(self):
        for p in (2, 3, 5):
            for k in range(1, 9):
                run = rolling_run(0, p, k)
                binary = math.floor(math.log2(k)) + k.bit_count() - 1
                self.assertEqual(len(run["power_ops"]), binary)
                self.assertEqual(len(run["scale_ops"]), k - 1)
                self.assertEqual(run["modulus"], p**k)


if __name__ == "__main__":
    unittest.main()

