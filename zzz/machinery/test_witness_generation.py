#!/usr/bin/env python3
"""Exact tests for witness regeneration in formed worlds.

Answers codex-ananta's question in message 0142.
"""

import unittest

from formation_sufficiency import (
    ambient_minimal_depth,
    formation_minimal_depth,
    v_p,
)
from witness_generation import (
    cofinite_witness,
    cyclic_world_witness,
    minus_one_is_a_power,
    multiplicative_order,
    multiplicative_world_is_hopeless,
    frobenius_number,
    numerical_semigroup,
    powers_of,
    transports_everywhere,
    witness_in,
    witness_target,
)

SEMIGROUPS = ((3, 5), (2, 3), (5, 7, 9), (4, 6, 7), (7, 11))


class SemigroupTests(unittest.TestCase):
    def test_frobenius_numbers(self):
        """Sanity anchors, including the classical `ab-a-b` for two coprime
        generators (Sylvester)."""
        self.assertEqual(frobenius_number((3, 5)), 7)  # 3*5-3-5
        self.assertEqual(frobenius_number((2, 3)), 1)
        self.assertEqual(frobenius_number((7, 11)), 59)  # 7*11-7-11
        for a, b in ((3, 5), (2, 3), (7, 11), (4, 9)):
            self.assertEqual(frobenius_number((a, b)), a * b - a - b)

    def test_numerical_semigroups_regenerate_every_witness(self):
        """Negation absent, positivity only: every pair still has a witness."""
        for p in (2, 3):
            for gens in SEMIGROUPS:
                S = sorted(x for x in numerical_semigroup(gens, 3000) if x > 0)
                rep = transports_everywhere(S, p, limit=14)
                self.assertTrue(rep["all_transport"], (p, gens, rep["failures"]))

    def test_minimality_actually_transports_on_a_semigroup(self):
        """The end-to-end statement, via FORMATION_SUFFICIENCY's own metric:
        `k_S = k_X` for pairs drawn from a numerical semigroup."""
        p = 2
        # the formation world is the set of PAIRS drawn from the semigroup;
        # bounded at 256, which comfortably exceeds F + p^(v+1) for these pairs
        S = sorted(x for x in numerical_semigroup((3, 5), 256) if x > 0)
        world = [(a, b) for a in S for b in S]
        for a in S[:6]:
            for b in S[:6]:
                self.assertEqual(
                    formation_minimal_depth(world, (a, b), p),
                    ambient_minimal_depth((a, b), p),
                    (a, b),
                )


class BudgetTests(unittest.TestCase):
    def test_witness_is_reachable_within_the_frobenius_budget(self):
        """Not merely existent: `b' <= F + p^(v+1)`, and it works."""
        for p in (2, 3, 5):
            for gens in SEMIGROUPS:
                F = frobenius_number(gens)
                S = numerical_semigroup(gens, 20000)
                for a in sorted(x for x in S if x > 0)[:8]:
                    for b in sorted(x for x in S if x > 0)[:8]:
                        v = v_p(a + b, p)
                        bp = cofinite_witness(a, b, p, F)
                        self.assertLessEqual(bp, F + p ** (v + 1))
                        self.assertIn(bp, S)  # cofiniteness delivers it
                        self.assertGreater(v_p(a + bp, p), v)

    def test_witness_target_congruence_subsumes_the_depth_v_chart(self):
        for p in (2, 3):
            for a in range(1, 30):
                for b in range(1, 30):
                    v = v_p(a + b, p)
                    r, m = witness_target(a, b, p)
                    self.assertEqual(m, p ** (v + 1))
                    # any b' in the target class already matches b mod p^v
                    self.assertEqual(r % p**v, b % p**v)


class NoClosureIsNotEnoughTests(unittest.TestCase):
    """`{2^k}` is multiplicatively closed and fails anyway."""

    def test_diagonal_pairs_have_no_witness(self):
        S = powers_of(2, 30)
        for i in range(6):
            a = 2**i
            self.assertIsNone(witness_in(S, a, a, 2), i)

    def test_off_diagonal_pairs_do_have_a_witness(self):
        """Exactly the diagonal fails.  For `i < j`, `v = i` and `(2^i, 2^i)`
        is itself the witness."""
        S = powers_of(2, 30)
        for i in range(6):
            for j in range(6):
                if i == j:
                    continue
                w = witness_in(S, 2**i, 2**j, 2)
                self.assertIsNotNone(w, (i, j))

    def test_the_proof_of_the_diagonal_failure(self):
        """`(2^i, 2^i)` has `v = i+1`, and `2^i` is the ONLY power of two in the
        class `2^i mod 2^(i+1)` — so no perturbation exists at all."""
        S = powers_of(2, 40)
        for i in range(8):
            m = 2 ** (i + 1)
            self.assertEqual(v_p(2**i + 2**i, 2), i + 1)
            self.assertEqual([x for x in S if x % m == 2**i % m], [2**i])

    def test_formation_depth_is_strictly_smaller_on_the_diagonal(self):
        """Concretely `k_S((2,2)) = 2 < 3 = k_X((2,2))`."""
        S = powers_of(2, 20)
        world = [(x, y) for x in S for y in S]
        self.assertEqual(ambient_minimal_depth((2, 2), 2), 3)
        self.assertEqual(formation_minimal_depth(world, (2, 2), 2), 2)


class MultiplicativeOrderTests(unittest.TestCase):
    """For odd `p`, the fate of `{2^k}` is an order condition."""

    def test_odd_order_means_no_witness_ever(self):
        """PROVED direction: `ord_p(2)` odd => `-1` is never a power of 2 at
        any level, so no pair has a witness at any depth."""
        for p in (7, 23, 31, 47, 71):
            self.assertTrue(multiplicative_world_is_hopeless(2, p))
            for m in range(1, 5):
                self.assertEqual(multiplicative_order(2, p**m) % 2, 1)
                self.assertFalse(minus_one_is_a_power(2, p**m))
            S = powers_of(2, 60)
            rep = transports_everywhere(S, p, limit=8)
            self.assertFalse(rep["all_transport"])

    def test_even_order_primes_do_regenerate(self):
        """Proved direction replayed for several bases, pairs, and depths."""
        for p in (3, 5, 7, 11, 13, 17, 19):
            for base in range(2, 13):
                if base % p == 0 or multiplicative_order(base, p) % 2:
                    continue
                for i in range(7):
                    for j in range(7):
                        a, bp = cyclic_world_witness(base, i, j, p)
                        b = base**j
                        v = v_p(a + b, p)
                        self.assertEqual(bp % p**v, b % p**v)
                        self.assertGreater(v_p(a + bp, p), v)

    def test_odd_order_is_exactly_the_failure_branch(self):
        for p in (3, 5, 7, 11, 13, 17, 19, 23):
            for base in range(2, 12):
                if base % p == 0:
                    continue
                witness = cyclic_world_witness(base, 2, 5, p)
                self.assertEqual(
                    witness is not None,
                    multiplicative_order(base, p) % 2 == 0,
                    (p, base),
                )

    def test_order_lifts_keep_parity_for_odd_p(self):
        """The mechanism: `ord_{p^m}(2) = ord_p(2) * p^t` with `p` odd, so
        parity cannot change as the level rises."""
        for p in (3, 5, 7, 11, 23):
            base = multiplicative_order(2, p)
            for m in range(1, 5):
                o = multiplicative_order(2, p**m)
                self.assertEqual(o % base, 0)
                self.assertEqual((o // base) % p if o // base > 1 else 0,
                                 0 if o // base in (1, p, p * p, p**3) else -1)
                self.assertEqual(o % 2, base % 2)


class NegationIsNotNeededTests(unittest.TestCase):
    def test_positive_world_matches_its_signed_closure(self):
        """Adding negatives changes nothing: the positive semigroup already
        transports everywhere, so negation buys no witnesses."""
        p = 2
        S_pos = sorted(x for x in numerical_semigroup((3, 5), 3000) if x > 0)
        S_signed = sorted(set(S_pos) | {-x for x in S_pos})
        for a in S_pos[:10]:
            for b in S_pos[:10]:
                self.assertIsNotNone(witness_in(S_pos, a, b, p), (a, b))
                self.assertIsNotNone(witness_in(S_signed, a, b, p), (a, b))

    def test_positivity_removes_the_zero_boundary(self):
        """codex-ananta's zero-sum boundary cannot arise in a positive world."""
        S = sorted(x for x in numerical_semigroup((3, 5), 500) if x > 0)
        for a in S[:20]:
            for b in S[:20]:
                self.assertNotEqual(a + b, 0)


if __name__ == "__main__":
    unittest.main()
