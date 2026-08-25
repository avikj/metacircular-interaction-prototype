"""Independent falsifiers for R0025/R0026; imports no contributed machinery."""

import math
import unittest


def vp(n, p):
    if n == 0:
        return math.inf
    n = abs(n)
    e = 0
    while n % p == 0:
        n //= p
        e += 1
    return e


def order_mod_prime(a, p):
    x = 1
    for d in range(1, p):
        x = x * a % p
        if x == 1:
            return d
    raise AssertionError("unit modulo a prime has no order")


def divisors(n):
    return [d for d in range(1, n + 1) if n % d == 0]


def poly_div_exact(f, g):
    """Ascending coefficients; monic exact division over Z."""
    q = [0] * (len(f) - len(g) + 1)
    r = f[:]
    while len(r) >= len(g):
        c = r[-1]
        k = len(r) - len(g)
        q[k] = c
        for j, gj in enumerate(g):
            r[k + j] -= c * gj
        while r and r[-1] == 0:
            r.pop()
    assert not r
    return q


def cyclotomic_polynomials(limit):
    phis = {1: [-1, 1]}
    for n in range(2, limit + 1):
        f = [-1] + [0] * (n - 1) + [1]
        for d in divisors(n)[:-1]:
            f = poly_div_exact(f, phis[d])
        phis[n] = f
    return phis


def evaluate(poly, a):
    out = 0
    for c in reversed(poly):
        out = out * a + c
    return out


def predicted_phi_v(p, a, m):
    if p == 2:
        if m == 1:
            return vp(a - 1, 2)
        if m == 2:
            return vp(a + 1, 2)
        return 1 if m & (m - 1) == 0 else 0
    d = order_mod_prime(a, p)
    if m % d:
        return 0
    q = m // d
    while q % p == 0:
        q //= p
    if q != 1:
        return 0
    return vp(pow(a, d) - 1, p) if m == d else 1


class IndependentCyclotomicAudit(unittest.TestCase):
    def test_chain_law_from_fresh_polynomials(self):
        phis = cyclotomic_polynomials(36)
        for p in (2, 3, 5, 7, 11, 13):
            for a in range(2, 24):
                if math.gcd(a, p) != 1:
                    continue
                for m in range(1, 37):
                    self.assertEqual(
                        vp(evaluate(phis[m], a), p),
                        predicted_phi_v(p, a, m),
                        (p, a, m),
                    )

    def test_sensor_formula_directly(self):
        for p in (2, 3, 5, 7, 11, 13):
            for a in range(2, 30):
                if math.gcd(a, p) != 1:
                    continue
                for n in range(1, 55):
                    if p == 2:
                        pred = vp(a - 1, 2) if n % 2 else (
                            vp(a - 1, 2) + vp(a + 1, 2) + vp(n, 2) - 1
                        )
                    else:
                        d = order_mod_prime(a, p)
                        pred = 0 if n % d else vp(pow(a, d) - 1, p) + vp(n, p)
                    self.assertEqual(vp(pow(a, n) - 1, p), pred, (p, a, n))

    def test_one_digit_coarser_always_has_blocker(self):
        for p in (2, 3, 5, 7, 11, 13):
            for a in range(2, 35):
                if math.gcd(a, p) != 1:
                    continue
                if p == 2:
                    em, ep = vp(a - 1, 2), vp(a + 1, 2)
                    depth = max(em, ep)
                    b = a + 2**depth
                    self.assertEqual(a % 2**depth, b % 2**depth)
                    self.assertNotEqual((em, ep), (vp(b - 1, 2), vp(b + 1, 2)))
                else:
                    d = order_mod_prime(a, p)
                    e = vp(pow(a, d) - 1, p)
                    modulus = p**e
                    blocker = None
                    for c in range(p):
                        b = a + c * modulus
                        if vp(pow(b, d) - 1, p) > e:
                            blocker = b
                            break
                    self.assertIsNotNone(blocker, (p, a))
                    self.assertEqual(a % modulus, blocker % modulus)

    def test_false_control_rejects_constant_off_head_two(self):
        # The genuine tail is 1: Phi_4(3)=10 has v_2=1, not 2.
        phis = cyclotomic_polynomials(4)
        self.assertNotEqual(vp(evaluate(phis[4], 3), 2), 2)


if __name__ == "__main__":
    unittest.main()
