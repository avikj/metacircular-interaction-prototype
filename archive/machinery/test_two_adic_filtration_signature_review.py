#!/usr/bin/env python3
"""Independent checks for the two-adic filtration signature."""

import unittest


def closure(gens, k):
    m = 1 << k
    out, todo = {1}, [1]
    while todo:
        x = todo.pop()
        for g in gens:
            y = x * (g % m) % m
            if y not in out:
                out.add(y)
                todo.append(y)
    return out


def v2(n):
    if n == 0:
        raise ValueError
    n = abs(n)
    e = 0
    while n % 2 == 0:
        e += 1
        n //= 2
    return e


def signature(U, k):
    principal = [x for x in U if x % 4 == 1 and x != 1]
    ell = min((v2(x - 1) for x in principal), default=k)
    return ell, int(any(x % 4 == 3 for x in U))


def direct_depth(U, u, w, k):
    target = v2((u + w) % (1 << k))
    for d in range(1, k):
        Ud = [x for x in U if x % (1 << d) == 1]
        vals = {v2((u * x + w) % (1 << k)) for x in Ud
                if (u * x + w) % (1 << k)}
        if vals == {target}:
            return d
    raise AssertionError("precision too small")


class FiltrationSignatureReview(unittest.TestCase):
    def test_confinement_formula_exhaustively(self):
        for k in range(3, 10):
            for a in range(1, 1 << k, 2):
                for b in (1, 3, 5, 7, 9, 15):
                    U = closure((a, b), k)
                    ell, sigma = signature(U, k)
                    self.assertEqual((1 << (k - 1)) // len(U),
                                     1 << (ell - 1 - sigma))

    def test_equal_level_kills_level_only_predictions(self):
        U0, U1 = closure((5,), 8), closure((3, 5), 8)
        self.assertEqual(signature(U0, 8), (2, 0))
        self.assertEqual(signature(U1, 8), (2, 1))
        self.assertEqual(128 // len(U0), 2)
        self.assertEqual(128 // len(U1), 1)
        self.assertEqual(direct_depth(U0, 1, 1, 8), 1)
        self.assertEqual(direct_depth(U1, 1, 1, 8), 2)

    def test_chart_formula(self):
        for k in range(5, 9):
            for gens in ((5,), (3,), (7,), (17,), (3, 5), (3, 7)):
                U = closure(gens, k)
                ell, sigma = signature(U, k)
                for u in U:
                    for w in U:
                        s = (u + w) % (1 << k)
                        if not s or v2(s) + 2 >= k:
                            continue
                        delta = v2(s)
                        predicted = (delta + 1 if ell <= delta else
                                     1 if sigma == 0 else 2)
                        self.assertEqual(direct_depth(U, u, w, k), predicted)

    def test_depth_two_erases_the_sign_bit(self):
        U0, U1 = closure((5,), 8), closure((3, 5), 8)
        self.assertEqual({x for x in U0 if x % 4 == 1},
                         {x for x in U1 if x % 4 == 1})
        self.assertNotEqual(signature(U0, 8)[1], signature(U1, 8)[1])


if __name__ == "__main__":
    unittest.main()
