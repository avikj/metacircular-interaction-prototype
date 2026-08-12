#!/usr/bin/env python3
"""Exact tests for non-product encountered worlds.

Answers codex-ananta's question in message 0147.
"""

import random
import unittest

from encountered_worlds import (
    SUM,
    completion_lies_at,
    diagonal_world,
    line_world,
    maximal_valuation_points,
    product_world,
    tangent_directions,
    transport_profile,
)
from tangent_witness import (
    CUBE_SUM,
    MIXED,
    QUAD,
    evaluate,
    hyperplane,
    nonzero_locus,
    transports_by_search,
    transports_by_tangent,
    v_p,
)

BIG = list(range(1, 400))


class DiagonalTests(unittest.TestCase):
    """`E = {(a,a)}` under `f = X+Y`: the sharpest split between an encountered
    world and its product completion."""

    def test_diagonal_transports_nowhere_at_p_two(self):
        """Proof: `f(a,a) = 2a`, so `u` is odd, while every realized direction
        is `(t,t)` and `(1,1).(t,t) = 2t = 0 (mod 2)`.  The hyperplane target
        is `1`.  No incidence, at any point."""
        rep = transport_profile(diagonal_world(BIG), SUM, 2)
        self.assertGreater(rep["considered"], 300)
        self.assertEqual(len(rep["transport"]), 0)
        self.assertEqual(len(rep["fail"]), rep["considered"])

    def test_the_arithmetic_behind_it(self):
        for a in range(1, 40):
            x = (a, a)
            e = v_p(evaluate(SUM, x), 2)
            normal, target = hyperplane(SUM, x, 2)
            self.assertEqual(normal, [1, 1])
            self.assertEqual(target, 1)  # u = 2a/2^e is odd
            for h in tangent_directions(diagonal_world(BIG), SUM, x, 2):
                self.assertEqual(h[0], h[1])  # only the line (t,t) is realized
                self.assertEqual((h[0] + h[1]) % 2, 0)  # never meets target 1

    def test_diagonal_meets_the_hyperplane_at_odd_primes(self):
        """The theorem, stated where it lives: for odd `p`, `2` is invertible,
        so `(1,1).(t,t) = 2t = -u (mod p)` HAS a solution `t`.  An unbounded
        diagonal realizes every direction `(t,t)`, hence transports.

        This is asserted directly rather than by truncated search: a bounded
        diagonal can lack the witness merely because the witness is larger than
        the truncation, which is a fact about the truncation, not the world."""
        for p in (3, 5, 7, 11):
            for a in range(1, 60):
                x = (a, a)
                e = v_p(evaluate(SUM, x), p)
                if e < 1:
                    continue
                _normal, target = hyperplane(SUM, x, p)
                solutions = [t for t in range(p) if (2 * t) % p == target]
                self.assertEqual(len(solutions), 1, (p, x))

    def test_diagonal_transport_confirmed_where_the_witness_fits(self):
        """Search-confirmed at the points whose witness provably lies inside
        the truncation: the full class mod `p^(e+1)` must be representable."""
        for p in (3, 5, 7):
            world = diagonal_world(BIG)
            live = nonzero_locus(world, SUM)
            hi = max(BIG)
            checked = 0
            for x in live:
                e = v_p(evaluate(SUM, x), p)
                if e < 1 or x[0] + p ** (e + 1) > hi:
                    continue
                checked += 1
                self.assertTrue(transports_by_search(live, SUM, x, p), (p, x))
            self.assertGreater(checked, 10)

    def test_completing_the_diagonal_misreports_everywhere(self):
        S = list(range(1, 60))
        E = nonzero_locus(diagonal_world(S), SUM)
        P = nonzero_locus(product_world(S), SUM)
        lies = completion_lies_at(diagonal_world(S), S, SUM, 2)
        prof = transport_profile(diagonal_world(S), SUM, 2)
        # every diagonal point fails; the completion "lies" at each one EXCEPT
        # where the truncated completion itself fails by the finite no-go
        also_fails = [
            x
            for x in prof["fail"]
            if not transports_by_tangent(P, SUM, x, 2)
        ]
        self.assertEqual(len(lies) + len(also_fails), prof["considered"])
        self.assertGreater(len(lies), 50)
        self.assertLessEqual(len(also_fails), 2)


class GroupoidIsUnnecessaryTests(unittest.TestCase):
    """The criterion reads realized directions, not the moves producing them."""

    def test_worlds_with_equal_tangent_sets_get_equal_verdicts(self):
        p = 3
        x = (1, 2)
        e = v_p(evaluate(SUM, x), p)
        step = p**e
        # same direction (1,0) mod p, reached by two very different "moves"
        near = [x, (x[0] + step, x[1])]
        far = [x, (x[0] + step + p * step * 5, x[1] + p * step * 7)]
        self.assertEqual(
            tangent_directions(near, SUM, x, p), tangent_directions(far, SUM, x, p)
        )
        self.assertEqual(
            transports_by_tangent(near, SUM, x, p),
            transports_by_tangent(far, SUM, x, p),
        )

    def test_criterion_never_mentions_moves_only_points(self):
        """Two line-worlds of the same slope through different offsets realize
        the same direction line and agree pointwise where both are defined."""
        p = 5
        for slope in (1, 2, 3):
            w1 = line_world(BIG, slope, 0)
            w2 = line_world(BIG, slope, 5 * 7)
            for x in [y for y in w1 if v_p(evaluate(SUM, y), p) == 1][:6]:
                d1 = tangent_directions(w1, SUM, x, p)
                self.assertTrue(all(h[1] % p == (slope * h[0]) % p for h in d1))


class SubspaceCriterionTests(unittest.TestCase):
    """§3.5: for a subspace tangent set, transport iff `grad f|_L != 0`."""

    def test_line_worlds_fail_exactly_at_slope_minus_one(self):
        big = list(range(1, 600))
        checked = 0
        for p in (2, 3, 5, 7):
            for slope in range(0, p + 2):
                live = nonzero_locus(line_world(big, slope, 0), SUM)
                pts = [
                    x
                    for x in live
                    if v_p(evaluate(SUM, x), p) >= 1
                    and x[0] + p ** (v_p(evaluate(SUM, x), p) + 1) <= max(big)
                ]
                if len(pts) < 5:
                    continue
                checked += 1
                predicted = (1 + slope) % p != 0
                observed = all(transports_by_search(live, SUM, x, p) for x in pts)
                self.assertEqual(observed, predicted, (p, slope))
        self.assertGreaterEqual(checked, 20)

    def test_tangent_directions_of_a_line_world_lie_in_the_line(self):
        """Containment only — the trivial half.  See the next test for the
        equality that §3.5's hypothesis actually needs."""
        big = list(range(1, 400))
        for p in (2, 3, 5):
            for slope in (0, 1, 2):
                w = line_world(big, slope, 0)
                live = nonzero_locus(w, SUM)
                for x in [y for y in live if v_p(evaluate(SUM, y), p) == 1][:5]:
                    for h in tangent_directions(w, SUM, x, p):
                        self.assertEqual(h[1] % p, (slope * h[0]) % p)

    def test_the_line_world_tangent_set_is_the_WHOLE_line(self):
        """§3.5's hypothesis is that `T_E(x)` IS a subspace, not merely sits
        inside one.  For the unbounded line world that is provable (take
        `a' = a + t p^e`); in truncations it FAILS at high-valuation points, so
        the check is restricted to points whose witness provably fits.
        See notes/FINITE_MODEL_AUDIT.md §3."""
        hi = 20000
        checked = 0
        for p in (3, 5, 7):
            for slope in (1, 2, 3):
                w = line_world(range(1, hi), slope, 0)
                live = nonzero_locus(w, SUM)
                for x in live[:60]:
                    e = v_p(evaluate(SUM, x), p)
                    if e < 1 or x[0] + (p - 1) * p**e >= hi:
                        continue
                    checked += 1
                    full = {(t, (slope * t) % p) for t in range(p)}
                    self.assertEqual(tangent_directions(w, SUM, x, p), full)
        self.assertGreater(checked, 100)

    def test_truncation_really_does_break_the_hypothesis(self):
        """The audit finding, pinned: in a short truncation the tangent set is
        a proper subset of the line, so a finite computation cannot establish
        §3.5's hypothesis."""
        p, slope = 3, 2
        w = line_world(range(1, 60), slope, 0)
        x = (27, 54)
        e = v_p(evaluate(SUM, x), p)
        T = tangent_directions(w, SUM, x, p)
        full = {(t, (slope * t) % p) for t in range(p)}
        self.assertLess(len(T), len(full))
        self.assertTrue(T.issubset(full))


class GeneralFiniteNoGoTests(unittest.TestCase):
    """`FORMATION_SUFFICIENCY` §2.5 generalizes from `X+Y` to every polynomial:
    a witness has strictly larger valuation, so a maximum can never have one."""

    def test_max_valuation_points_never_transport_for_any_polynomial(self):
        rng = random.Random(23)
        for p in (2, 3, 5):
            for f in (SUM, QUAD, MIXED, CUBE_SUM):
                for _ in range(12):
                    pts = [
                        (rng.randrange(-30, 31), rng.randrange(-30, 31))
                        for _ in range(rng.randrange(4, 20))
                    ]
                    live = nonzero_locus(pts, f)
                    live = [y for y in live if v_p(evaluate(f, y), p) >= 1]
                    if not live:
                        continue
                    for m in maximal_valuation_points(live, f, p):
                        if v_p(evaluate(f, m), p) < 1:
                            continue
                        self.assertFalse(
                            transports_by_search(live, f, m, p), (p, m)
                        )

    def test_congruence_forces_witnesses_upward(self):
        """The mechanism: `y = x (mod p^e)` gives `f(y) = f(x) (mod p^e)`, so
        `p^e | f(y)` and any different valuation must be strictly larger."""
        for p in (2, 3):
            for f in (SUM, QUAD, MIXED, CUBE_SUM):
                for a in range(1, 12):
                    for b in range(1, 12):
                        x = (a, b)
                        val = evaluate(f, x)
                        if val == 0 or v_p(val, p) < 1:
                            continue
                        e = v_p(val, p)
                        for t1 in range(-3, 4):
                            for t2 in range(-3, 4):
                                y = (a + t1 * p**e, b + t2 * p**e)
                                fy = evaluate(f, y)
                                if fy == 0:
                                    continue
                                self.assertGreaterEqual(v_p(fy, p), e)


class CriterionOnNonProductWorldsTests(unittest.TestCase):
    def test_criterion_matches_search_on_many_non_product_worlds(self):
        rng = random.Random(101)
        for _ in range(120):
            p = rng.choice([2, 3, 5])
            f = rng.choice([SUM, QUAD, MIXED, CUBE_SUM])
            kind = rng.randrange(3)
            if kind == 0:
                w = diagonal_world(range(1, rng.randrange(10, 60)))
            elif kind == 1:
                w = line_world(range(1, 40), rng.randrange(1, 4), rng.randrange(0, 6))
            else:
                w = [
                    (rng.randrange(-20, 21), rng.randrange(-20, 21))
                    for _ in range(rng.randrange(4, 30))
                ]
            live = nonzero_locus(w, f)
            for x in live:
                if v_p(evaluate(f, x), p) < 1:
                    continue
                self.assertEqual(
                    transports_by_tangent(live, f, x, p),
                    transports_by_search(live, f, x, p),
                    (p, x),
                )

    def test_encountered_world_is_never_easier_than_its_completion(self):
        """Monotonicity: `T_E(x) subset T_{SxS}(x)`, so `E` transporting
        implies the completion does.  The converse fails (diagonal, p=2)."""
        S = list(range(1, 45))
        P = nonzero_locus(product_world(S), SUM)
        for p in (2, 3):
            E = nonzero_locus(diagonal_world(S), SUM)
            for x in E:
                if v_p(evaluate(SUM, x), p) < 1:
                    continue
                if transports_by_tangent(E, SUM, x, p):
                    self.assertTrue(transports_by_tangent(P, SUM, x, p), (p, x))


if __name__ == "__main__":
    unittest.main()
