import unittest


def vp(n, p):
    e = 0
    while n and n % p == 0:
        n //= p
        e += 1
    return e


class UnitDerivativeDepthTests(unittest.TestCase):
    def test_cubic_simple_zero_witness(self):
        # f=x+x^3, p=3; derivative is 1 mod 3 at every x divisible by 3.
        for x in (3, 9, 18, 27):
            f = lambda z: z + z**3
            e = vp(f(x), 3)
            u = f(x) // 3**e
            derivative = 1 + 3 * x * x
            c = (-u * pow(derivative, -1, 3)) % 3
            y = x + c * 3**e
            self.assertEqual(x % 3**e, y % 3**e)
            self.assertGreater(vp(f(y), 3), e)

    def test_zero_depth_boundary_control(self):
        for p in (2, 3, 5, 7):
            for x in range(-20, 21):
                self.assertEqual(vp(x**p - x + 1, p), 0)


if __name__ == "__main__":
    unittest.main()
