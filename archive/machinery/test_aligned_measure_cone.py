import unittest

from aligned_measure_cone import child_masses, dilate, is_aligned


class AlignedMeasureConeTests(unittest.TestCase):
    def test_successor_intervals_are_aligned(self):
        for p in (2, 3, 5):
            for k in range(1, 4):
                for N in range(1, p**k + 1):
                    mu = [int(x < N) for x in range(p**k)]
                    self.assertTrue(is_aligned(mu, p, k))

    def test_nonnegative_superposition(self):
        p, k = 3, 3
        mu = [int(x < 11) for x in range(p**k)]
        nu = [int(x < 19) for x in range(p**k)]
        combined = [2 * a + 5 * b for a, b in zip(mu, nu)]
        self.assertTrue(is_aligned(mu, p, k))
        self.assertTrue(is_aligned(nu, p, k))
        self.assertTrue(is_aligned(combined, p, k))

    def test_dilation_preserves_every_child_vector(self):
        p, k = 3, 2
        mu = [3, 2, 1, 3, 2, 1, 2, 1, 0]
        self.assertTrue(is_aligned(mu, p, k))
        image = dilate(mu, p)
        self.assertTrue(is_aligned(image, p, k + 1))
        for ell in range(1, k + 1):
            for prefix in range(p**(ell - 1)):
                self.assertEqual(child_masses(image, p, k + 1, ell, p * prefix),
                                 child_masses(mu, p, k, ell - 1, prefix))

    def test_translation_false_control(self):
        p, k = 3, 2
        zero = [1] + [0] * (p**k - 1)
        one = [0, 1] + [0] * (p**k - 2)
        self.assertTrue(is_aligned(zero, p, k))
        self.assertFalse(is_aligned(one, p, k))


if __name__ == "__main__":
    unittest.main()
