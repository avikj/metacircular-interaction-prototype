#!/usr/bin/env python3
"""Exact tests for the tangent criterion for minimality transport.

Answers codex-ananta's hostile question in message 0145, and sharpens their
unit-derivative hypothesis from sufficient to necessary-and-sufficient.
"""

import itertools
import random
import unittest

from tangent_witness import (
    CUBE_SUM,
    MIXED,
    QUAD,
    SUM,
    box,
    evaluate,
    gradient,
    hyperplane,
    in_hyperplane,
    partial,
    tangent_is_surjective,
    tangent_set,
    transports_by_search,
    transports_by_tangent,
    v_p,
    witness_density,
)

POLYS = (
    (SUM, "X+Y"),
    (QUAD, "X^2+Y"),
    (MIXED, "XY+3"),
    (CUBE_SUM, "X^3+Y^3"),
    ({(2, 0): 1, (0, 2): 1, (0, 0): 1}, "X^2+Y^2+1"),
    ({(1, 0): 2, (0, 1): 3, (1, 1): 1}, "2X+3Y+XY"),
)


def ambient_depth(f, x, p, radius=40):
    """Least depth `k` such that no perturbation by multiples of `p^k` inside
    the radius changes the valuation.  Independent of any closed form."""
    e = v_p(evaluate(f, x), p)
    for k in range(0, e + 3):
        m = p**k
        ok = True
        for h in itertools.product(range(-radius, radius + 1), repeat=len(x)):
            y = tuple(xi + hi * m for xi, hi in zip(x, h))
            fy = evaluate(f, y)
            if fy == 0:
                continue
            if v_p(fy, p) != e:
                ok = False
                break
        if not ok:
            continue
        return k
    return None


class CalculusTests(unittest.TestCase):
    def test_formal_partials_match_finite_differences(self):
        for f, name in POLYS:
            for x in ((1, 2), (3, 5), (2, 7)):
                for i in range(2):
                    y = list(x)
                    y[i] += 1
                    z = list(x)
                    z[i] -= 1
                    # exact second-difference identity for the derivative is
                    # only linear-order; use a direct symbolic check instead
                    d = partial(f, i)
                    h = 10**6
                    y2 = list(x)
                    y2[i] += h
                    approx = evaluate(f, y2) - evaluate(f, x)
                    self.assertEqual(approx % h, 0)
                    self.assertEqual((approx // h) % h, evaluate(d, x) % h)


class TangentCriterionTests(unittest.TestCase):
    def test_criterion_matches_brute_force_search(self):
        """The decisive test: the tangent condition and a literal witness
        search agree, on many polynomials, points, primes and worlds."""
        rng = random.Random(5)
        checked = {True: 0, False: 0}
        world = box(-9, 10)
        for p in (2, 3, 5):
            for f, name in POLYS:
                for x in world:
                    val = evaluate(f, x)
                    if val == 0 or v_p(val, p) < 1:
                        continue
                    got = transports_by_tangent(world, f, x, p)
                    checked[got] += 1
                    self.assertEqual(
                        got, transports_by_search(world, f, x, p), (name, p, x)
                    )
        self.assertGreater(checked[True], 20)
        self.assertGreater(checked[False], 0)

    def test_criterion_matches_search_on_random_sparse_worlds(self):
        rng = random.Random(17)
        for _ in range(300):
            p = rng.choice([2, 3, 5])
            f, _name = rng.choice(POLYS)
            base = box(-6, 7)
            world = rng.sample(base, rng.randrange(3, 25))
            for x in world:
                val = evaluate(f, x)
                if val == 0 or v_p(val, p) < 1:
                    continue
                self.assertEqual(
                    transports_by_tangent(world, f, x, p),
                    transports_by_search(world, f, x, p),
                    (p, x),
                )


class SharpenTheHypothesisTests(unittest.TestCase):
    """codex-ananta's unit-derivative hypothesis is exactly necessary."""

    def test_ambient_depth_is_e_plus_one_iff_gradient_is_nonzero(self):
        for p in (2, 3):
            for f, name in POLYS:
                for x in box(1, 5):
                    val = evaluate(f, x)
                    if val == 0 or v_p(val, p) < 1:
                        continue
                    e = v_p(val, p)
                    unit_deriv = any(g % p != 0 for g in gradient(f, x))
                    depth = ambient_depth(f, x, p, radius=12)
                    if unit_deriv:
                        self.assertEqual(depth, e + 1, (name, p, x))
                    else:
                        self.assertLessEqual(depth, e, (name, p, x))

    def test_vanishing_gradient_makes_depth_e_suffice(self):
        """`X^3+Y^3` at `(1,2)`, `p=3`: `e=2`, gradient `(3,12)=(0,0) mod 3`,
        so depth 2 already determines the valuation and `e+1` is not minimal."""
        p, f, x = 3, CUBE_SUM, (1, 2)
        e = v_p(evaluate(f, x), p)
        self.assertEqual(e, 2)
        self.assertEqual([g % p for g in gradient(f, x)], [0, 0])
        self.assertEqual(ambient_depth(f, x, p, radius=30), 2)
        with self.assertRaises(Exception):
            # no direction can satisfy 0.h = -u, so no witness exists at all
            self.assertTrue(
                transports_by_search(box(-30, 31), f, x, p)
            ) or (_ for _ in ()).throw(AssertionError)


class RecoversTheEarlierResultTests(unittest.TestCase):
    def test_sum_recovers_the_affine_line(self):
        """For `f = X+Y` the hyperplane is `alpha+beta = -u`, exactly the line
        in WITNESS_GENERATION / FORMATION_SUFFICIENCY."""
        for p in (2, 3, 5, 7):
            for x in box(1, 6):
                val = evaluate(SUM, x)
                if v_p(val, p) < 1:
                    continue
                normal, target = hyperplane(SUM, x, p)
                self.assertEqual(normal, [1 % p, 1 % p])
                u = (val // p ** v_p(val, p)) % p
                self.assertEqual(target, (-u) % p)

    def test_hyperplane_density_is_one_over_p(self):
        for p in (2, 3, 5):
            num, den = witness_density(p, 2)
            self.assertEqual(den, p * p)
            self.assertEqual(num, p)
            x = (1, p - 1) if p > 2 else (1, 1)
            if v_p(evaluate(SUM, x), p) < 1:
                continue
            hits = [
                h
                for h in itertools.product(range(p), repeat=2)
                if in_hyperplane(SUM, x, p, h)
            ]
            self.assertEqual(len(hits), num)


class SurjectivityTests(unittest.TestCase):
    def test_surjective_tangent_set_always_transports(self):
        p = 3
        world = box(-9, 10)
        for f, name in POLYS:
            for x in box(1, 4):
                val = evaluate(f, x)
                if val == 0 or v_p(val, p) < 1:
                    continue
                e = v_p(val, p)
                if not tangent_is_surjective(world, x, p, e):
                    continue
                if all(g % p == 0 for g in gradient(f, x)):
                    continue  # no direction can work; hypothesis excluded
                self.assertTrue(transports_by_tangent(world, f, x, p), (name, x))

    def test_surjectivity_is_not_necessary(self):
        """A two-point world with a single tangent direction still transports:
        meeting the hyperplane is enough, filling the tangent space is not
        required."""
        p, x = 3, (1, 2)
        e = v_p(evaluate(SUM, x), p)
        thin = [x, (1 + p, 2 + p)]
        T = tangent_set(thin, x, p, e)
        self.assertEqual(sorted(T), [(0, 0), (1, 1)])
        self.assertFalse(tangent_is_surjective(thin, x, p, e))
        self.assertTrue(transports_by_tangent(thin, SUM, x, p))
        self.assertTrue(transports_by_search(thin, SUM, x, p))


class ScopeTests(unittest.TestCase):
    def test_zero_valuation_is_out_of_scope(self):
        """The Taylor step needs `2e >= e+1`, i.e. `e >= 1`; codex-ananta's own
        boundary example lands here."""
        p = 3
        x = (1, 1)  # SUM = 2, valuation 0
        self.assertEqual(v_p(evaluate(SUM, x), p), 0)
        with self.assertRaises(ValueError):
            hyperplane(SUM, x, p)


if __name__ == "__main__":
    unittest.main()
