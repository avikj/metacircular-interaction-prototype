import unittest


def vp(n, p):
    if n == 0:
        return float("inf")
    e = 0
    while n % p == 0:
        n //= p
        e += 1
    return e


def fiber_valuations(f, x, p, k, e):
    period = p ** max(0, e + 1 - k)
    return {vp(f(x + p**k * h), p) for h in range(period)}


class ScaledJetDepthTests(unittest.TestCase):
    def test_same_quadratic_shape_opposite_value_sets(self):
        f3 = lambda x: 9 + x * x
        self.assertEqual(fiber_valuations(f3, 0, 3, 1, 2), {2})
        self.assertNotEqual(fiber_valuations(f3, 0, 3, 0, 2), {2})
        f5 = lambda x: 25 + x * x
        self.assertIn(3, fiber_valuations(f5, 0, 5, 1, 2))
        self.assertEqual(fiber_valuations(f5, 0, 5, 2, 2), {2})

    def test_nonzero_polynomial_can_be_zero_function(self):
        for p in (2, 3, 5, 7):
            k, e = 1, p
            f = lambda x, p=p, e=e: p**e + x**p - p ** (p - 1) * x
            self.assertEqual(fiber_valuations(f, 0, p, k, e), {e})
            self.assertTrue(any((h**p - h) != 0 for h in range(p + 1)))
            self.assertTrue(all((h**p - h) % p == 0 for h in range(p)))

    def test_finite_jet_periodicity(self):
        f = lambda x: x**4 + 6 * x**2 + 81
        p, x, e, k = 3, 0, 4, 1
        period = p ** (e + 1 - k)
        modulus = p ** (e + 1)
        for h in range(2 * period):
            self.assertEqual(
                f(x + p**k * h) % modulus,
                f(x + p**k * (h + period)) % modulus,
            )


if __name__ == "__main__":
    unittest.main()
