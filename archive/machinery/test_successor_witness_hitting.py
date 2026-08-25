import unittest


def vp(n, p):
    e = 0
    while n and n % p == 0:
        n //= p
        e += 1
    return e


def valuation_hitting_time(x, p):
    return max(x, p ** (vp(x, p) + 1))


def brute_first_valuation_witness(x, p):
    e = vp(x, p)
    return next(y for y in range(1, p ** (e + 1) + 1)
                if y % p**e == x % p**e and vp(y, p) != e)


def addition_hitting_time(a, b, p):
    v = vp(a + b, p)
    modulus = p ** (v + 1)
    residue = (-a) % modulus
    witness = residue if residue else modulus
    return max(a, b, witness), witness


class SuccessorWitnessHittingTests(unittest.TestCase):
    def test_valuation_formula_and_witness(self):
        for p in (2, 3, 5, 7):
            for x in range(1, 300):
                e = vp(x, p)
                witness = brute_first_valuation_witness(x, p)
                self.assertEqual(witness, p ** (e + 1))
                self.assertEqual(valuation_hitting_time(x, p), max(x, witness))

    def test_witness_can_precede_the_question(self):
        x, p = 40, 2
        self.assertEqual(vp(x, p), 3)
        self.assertEqual(brute_first_valuation_witness(x, p), 16)
        self.assertEqual(valuation_hitting_time(x, p), 40)

    def test_addition_first_positive_witness(self):
        for p in (2, 3, 5):
            for a in range(1, 30):
                for b in range(1, 30):
                    time, witness = addition_hitting_time(a, b, p)
                    v = vp(a + b, p)
                    modulus = p ** (v + 1)
                    brute = next(y for y in range(1, modulus + 1)
                                 if (a + y) % modulus == 0)
                    self.assertEqual(witness, brute)
                    self.assertEqual(time, max(a, b, brute))
                    self.assertLessEqual(witness, modulus)


if __name__ == "__main__":
    unittest.main()
