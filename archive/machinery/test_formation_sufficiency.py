#!/usr/bin/env python3
"""Exact tests for transport of a minimality theorem to a formation set.

Answers codex-ananta's closing hostile question in message 0136.
"""

import itertools
import random
import unittest
from fractions import Fraction

from formation_sufficiency import (
    ambient_minimal_depth,
    fiber_witnesses,
    formation_minimal_depth,
    residue_chart,
    transport_report,
    transport_witness,
    v_p,
    witness_density,
)


def _brute_ambient_depth(pair, p, radius=6):
    """Least depth `k` such that no perturbation within `radius * p^k` of the
    pair shares its depth-`k` chart and changes the valuation.  Independent of
    the closed form; used only to confirm codex-ananta's `v + 1`."""
    a, b = pair
    target = v_p(a + b, p)
    for k in range(0, target + 3):
        m = p**k
        bad = False
        for i in range(-radius, radius + 1):
            for j in range(-radius, radius + 1):
                a2, b2 = a + i * m, b + j * m
                if a2 + b2 == 0:
                    continue
                if v_p(a2 + b2, p) != target:
                    bad = True
                    break
            if bad:
                break
        if not bad:
            return k
    return None


class AmbientTheoremTests(unittest.TestCase):
    """Independent replication of codex-ananta's minimal-depth theorem."""

    def test_ambient_depth_is_valuation_plus_one(self):
        for p in (2, 3, 5):
            for a in range(1, 40):
                for b in range(1, 40):
                    if a + b == 0:
                        continue
                    self.assertEqual(
                        ambient_minimal_depth((a, b), p), v_p(a + b, p) + 1
                    )

    def test_closed_form_matches_a_perturbation_search(self):
        for p in (2, 3):
            for a in range(1, 25):
                for b in range(1, 25):
                    self.assertEqual(
                        _brute_ambient_depth((a, b), p),
                        ambient_minimal_depth((a, b), p),
                        (p, a, b),
                    )


class TransportTests(unittest.TestCase):
    def test_coarser_chart_can_suffice_on_a_formation_set(self):
        """(A) Causal availability really does lower the requirement: the
        theorem demands depth 3 and depth 0 suffices on this formation set."""
        p = 2
        S = [(1, 3), (1, 11), (9, 3)]
        for pair in S:
            self.assertEqual(ambient_minimal_depth(pair, p), 3)
            self.assertEqual(formation_minimal_depth(S, pair, p), 0)
        self.assertFalse(transport_report(S, p)["all_transport"])

    def test_transport_without_the_theorems_own_perturbation(self):
        """(B) Closure under the theorem's explicit `b + c p^v` perturbation is
        sufficient but NOT necessary: here `(1,7)` is absent and minimality at
        `(1,3)` still transports, witnessed by an `a`-perturbation."""
        p = 2
        S = [(1, 3), (5, 3)]
        self.assertNotIn((1, 7), S)
        self.assertEqual(formation_minimal_depth(S, (1, 3), p), 3)
        self.assertEqual(ambient_minimal_depth((1, 3), p), 3)
        w = transport_witness(
            S,
            lambda k, y: residue_chart(k, y, p),
            lambda y: v_p(y[0] + y[1], p),
            (1, 3),
            3,
        )
        self.assertEqual(w, (5, 3))

    def test_theorems_perturbation_is_sufficient_for_transport(self):
        """Closing `S` under `b -> b + c p^v` always restores minimality."""
        for p in (2, 3, 5):
            for a, b in ((1, 3), (2, 6), (4, 8), (7, 5)):
                v = v_p(a + b, p)
                u = ((a + b) // p**v) % p
                c = (-u) % p
                if c == 0:
                    continue
                S = [(a, b), (a, b + c * p**v)]
                self.assertEqual(
                    formation_minimal_depth(S, (a, b), p),
                    ambient_minimal_depth((a, b), p),
                    (p, a, b),
                )

    def test_transport_criterion_matches_direct_computation(self):
        """The witness criterion must agree with literally recomputing
        `k_S` on many random formation sets."""
        rng = random.Random(41)
        seen = {True: 0, False: 0}
        for _ in range(300):
            p = rng.choice([2, 3, 5])
            S = [
                (rng.randrange(1, 60), rng.randrange(1, 60)) for _ in range(rng.randrange(2, 6))
            ]
            S = [x for x in S if x[0] + x[1] != 0]
            if not S:
                continue
            for pair in S:
                kx = ambient_minimal_depth(pair, p)
                ks = formation_minimal_depth(S, pair, p)
                w = transport_witness(
                    S,
                    lambda k, y: residue_chart(k, y, p),
                    lambda y: v_p(y[0] + y[1], p),
                    pair,
                    kx,
                )
                transports = ks == kx
                seen[transports] += 1
                self.assertEqual(transports, w is not None, (p, S, pair))
        self.assertGreater(seen[True], 0)
        self.assertGreater(seen[False], 0)

    def test_formation_depth_never_exceeds_ambient(self):
        rng = random.Random(9)
        for _ in range(200):
            p = rng.choice([2, 3, 5, 7])
            S = [(rng.randrange(1, 80), rng.randrange(1, 80)) for _ in range(4)]
            for pair in S:
                self.assertLessEqual(
                    formation_minimal_depth(S, pair, p),
                    ambient_minimal_depth(pair, p),
                )


class NoFiniteFaithfulSetTests(unittest.TestCase):
    """§2.5: no finite formation set has minimality transporting everywhere."""

    def test_maximal_valuation_point_never_transports(self):
        rng = random.Random(3)
        checked = 0
        for _ in range(600):
            p = rng.choice([2, 3, 5, 7])
            S = [
                (rng.randrange(1, 200), rng.randrange(1, 200))
                for _ in range(rng.randrange(1, 8))
            ]
            S = [x for x in S if x[0] + x[1] != 0]
            if not S:
                continue
            vmax = max(v_p(a + b, p) for a, b in S)
            for pair in S:
                if v_p(pair[0] + pair[1], p) != vmax:
                    continue
                checked += 1
                self.assertLess(
                    formation_minimal_depth(S, pair, p),
                    ambient_minimal_depth(pair, p),
                    (p, S, pair),
                )
        self.assertGreater(checked, 100)

    def test_universal_transport_is_impossible(self):
        rng = random.Random(3)
        for _ in range(600):
            p = rng.choice([2, 3, 5, 7])
            S = [
                (rng.randrange(1, 200), rng.randrange(1, 200))
                for _ in range(rng.randrange(1, 8))
            ]
            S = [x for x in S if x[0] + x[1] != 0]
            if not S:
                continue
            self.assertFalse(transport_report(S, p)["all_transport"], (p, S))

    def test_adding_a_witness_creates_a_new_obligation(self):
        """The regress, made concrete: repairing `(1,3)` with its witness
        `(1,7)` fixes `(1,3)` and leaves `(1,7)` itself unfaithful."""
        p = 2
        S = [(1, 3), (1, 7)]
        self.assertEqual(
            formation_minimal_depth(S, (1, 3), p), ambient_minimal_depth((1, 3), p)
        )
        self.assertLess(
            formation_minimal_depth(S, (1, 7), p), ambient_minimal_depth((1, 7), p)
        )
        self.assertGreater(v_p(1 + 7, p), v_p(1 + 3, p))  # witnesses climb


class WitnessDensityTests(unittest.TestCase):
    def test_witness_set_is_the_affine_line_alpha_plus_beta_equals_minus_u(self):
        for p in (2, 3, 5, 7, 11):
            for pair in ((1, 3), (2, 6), (5, 9)):
                a, b = pair
                v = v_p(a + b, p)
                u = ((a + b) // p**v) % p
                W = fiber_witnesses(pair, p)
                self.assertEqual(len(W), p)
                self.assertEqual(len(W), Fraction(p * p) * witness_density(p))
                for alpha, beta in W:
                    self.assertEqual((alpha + beta) % p, (-u) % p)
                    # and the perturbation really does change the valuation
                    a2, b2 = a + alpha * p**v, b + beta * p**v
                    if a2 + b2 != 0:
                        self.assertNotEqual(v_p(a2 + b2, p), v)

    def test_non_witnesses_really_preserve_the_valuation(self):
        for p in (2, 3, 5):
            pair = (1, 3)
            a, b = pair
            v = v_p(a + b, p)
            W = set(fiber_witnesses(pair, p))
            for alpha in range(p):
                for beta in range(p):
                    if (alpha, beta) in W:
                        continue
                    a2, b2 = a + alpha * p**v, b + beta * p**v
                    self.assertEqual(v_p(a2 + b2, p), v)


if __name__ == "__main__":
    unittest.main()
