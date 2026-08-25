#!/usr/bin/env python3
"""Exact tests for the lens-order commutation criterion.

The decisive test is `test_criterion_matches_brute_force_on_random_partitions`:
it checks the combinatorial criterion against literal exact matrix
multiplication on many random partition pairs, in both directions.  Everything
else is a replication or a boundary case.
"""

import itertools
import math
import random
import unittest
from fractions import Fraction

from lens_commutation import (
    blocks_of,
    commutation_certificate,
    commutator_column,
    commutator_entry,
    compose_entry,
    crt_lenses,
    family_is_order_free,
    idempotent_lenses,
    join,
    integrality_obstruction,
    partition_from,
)


def _matrix(labels):
    """Literal projection matrix, exact rationals."""
    n = len(labels)
    M = [[Fraction(0) for _ in range(n)] for _ in range(n)]
    for B in blocks_of(labels).values():
        w = Fraction(1, len(B))
        for x in B:
            for y in B:
                M[x][y] = w
    return M


def _mul(A, B):
    n = len(A)
    return [
        [sum((A[i][k] * B[k][j] for k in range(n)), Fraction(0)) for j in range(n)]
        for i in range(n)
    ]


def _brute_commutes(pi, sigma):
    P, Q = _matrix(pi), _matrix(sigma)
    return _mul(P, Q) == _mul(Q, P)


class ClosedFormTests(unittest.TestCase):
    def test_closed_form_entries_match_literal_matrices(self):
        n = 12
        rng = random.Random(11)
        pi = partition_from(n, lambda x: rng.randrange(3))
        sigma = partition_from(n, lambda x: rng.randrange(4))
        PQ, QP = _mul(_matrix(pi), _matrix(sigma)), _mul(_matrix(sigma), _matrix(pi))
        for x in range(n):
            for z in range(n):
                self.assertEqual(compose_entry(pi, sigma, x, z), PQ[x][z])
                self.assertEqual(
                    commutator_entry(pi, sigma, x, z), PQ[x][z] - QP[x][z]
                )


class CriterionTests(unittest.TestCase):
    def test_criterion_matches_brute_force_on_random_partitions(self):
        rng = random.Random(2026)
        seen = {True: 0, False: 0}
        for _ in range(120):
            n = rng.choice([6, 8, 9, 12])
            a, b = rng.choice([(2, 3), (3, 4), (2, 2), (3, 3)])
            perm = list(range(n))
            rng.shuffle(perm)
            style = rng.randrange(3)
            if style == 0:
                pi = [perm[x] % a for x in range(n)]
                sigma = [perm[x] // a for x in range(n)]
            elif style == 1:
                pi = [rng.randrange(a) for _ in range(n)]
                sigma = [rng.randrange(b) for _ in range(n)]
            else:
                pi = [perm[x] % a for x in range(n)]
                sigma = [rng.randrange(b) for _ in range(n)]
            expected = _brute_commutes(pi, sigma)
            seen[expected] += 1
            self.assertEqual(
                commutation_certificate(pi, sigma)["commutes"], expected, (pi, sigma)
            )
        self.assertGreater(seen[True], 0)
        self.assertGreater(seen[False], 0)

    def test_integrality_obstruction_never_gives_a_false_alarm(self):
        rng = random.Random(7)
        fired = 0
        for _ in range(120):
            n = rng.choice([6, 9, 10, 12])
            pi = [rng.randrange(rng.choice([2, 3])) for _ in range(n)]
            sigma = [rng.randrange(rng.choice([2, 3, 4])) for _ in range(n)]
            if integrality_obstruction(pi, sigma) is not None:
                fired += 1
                self.assertFalse(_brute_commutes(pi, sigma), (pi, sigma))
        self.assertGreater(fired, 0)

    def test_permuting_but_not_equidistributed_still_fails(self):
        """Separates the two halves of the criterion: every overlap is
        nonempty (the congruences permute, in the universal-algebra sense) yet
        the counts are wrong, so the projections do not commute."""
        pi = [0, 0, 0, 1, 1]
        sigma = [0, 1, 1, 0, 1]
        for B in blocks_of(pi).values():
            for D in blocks_of(sigma).values():
                self.assertTrue(set(B) & set(D))
        self.assertFalse(_brute_commutes(pi, sigma))
        self.assertIs(commutation_certificate(pi, sigma)["commutes"], False)

    def test_trivial_and_discrete_lenses_commute_with_everything(self):
        n = 9
        rng = random.Random(3)
        pi = partition_from(n, lambda x: rng.randrange(3))
        for other in (partition_from(n, lambda x: 0), partition_from(n, lambda x: x)):
            self.assertTrue(commutation_certificate(pi, other)["commutes"])
            self.assertTrue(commutation_certificate(other, pi)["commutes"])


class CompositeIsJoinTests(unittest.TestCase):
    """§2.1: commuting lenses compose, in any order, to the join lens."""

    def test_commuting_pair_composes_to_the_join_lens(self):
        rng = random.Random(5)
        checked = 0
        for _ in range(400):
            n = rng.choice([4, 6, 8, 9])
            pi = [rng.randrange(rng.choice([2, 3])) for _ in range(n)]
            sigma = [rng.randrange(rng.choice([2, 3])) for _ in range(n)]
            if not commutation_certificate(pi, sigma)["commutes"]:
                continue
            checked += 1
            J = _matrix(join(pi, sigma))
            self.assertEqual(_mul(_matrix(pi), _matrix(sigma)), J)
            self.assertEqual(_mul(_matrix(sigma), _matrix(pi)), J)
        self.assertGreater(checked, 20)

    def test_pairwise_commuting_family_is_order_free(self):
        """Every ordering of a pairwise-commuting triple gives the same
        operator, and that operator is the projection onto the triple join."""
        rng = random.Random(17)
        checked = 0
        candidates = []
        # constructed: coordinate lenses of a product set always commute
        for a, b, c in ((2, 2, 2), (2, 3, 2), (3, 2, 2), (2, 2, 3), (3, 3, 2)):
            n = a * b * c
            candidates.append(
                [
                    [x % a for x in range(n)],
                    [(x // a) % b for x in range(n)],
                    [(x // (a * b)) % c for x in range(n)],
                ]
            )
        # constructed: residue lenses on Z/24Z (moduli dividing 24)
        for mods in ((2, 3, 4), (3, 4, 6), (2, 4, 8), (2, 3, 12)):
            n = 24
            candidates.append([[x % m for x in range(n)] for m in mods])
        # plus random draws, which commute pairwise only rarely
        for _ in range(6000):
            n = rng.choice([6, 8, 9, 12])
            candidates.append(
                [
                    [rng.randrange(rng.choice([2, 3])) for _ in range(n)]
                    for _ in range(3)
                ]
            )
        for ls in candidates:
            report = family_is_order_free(ls)
            if not report["order_free"]:
                continue
            checked += 1
            J = _matrix(report["net_lens"])
            for order in itertools.permutations(ls):
                M = _matrix(order[0])
                for other in order[1:]:
                    M = _mul(M, _matrix(other))
                self.assertEqual(M, J)
            if checked >= 40:
                break
        self.assertGreaterEqual(checked, 20)

    def test_family_report_names_the_offending_pair(self):
        pi, sigma = idempotent_lenses(1000)
        report = family_is_order_free([partition_from(1000, lambda x: 0), pi, sigma])
        self.assertFalse(report["order_free"])
        self.assertEqual(report["offending_pair"], (1, 2))


class ArithmeticLensTests(unittest.TestCase):
    def test_crt_lenses_commute_even_when_not_coprime(self):
        """Reconstruction needs coprimality; commutation of the two
        compressions does not.  The join has exactly `gcd(m, n)` blocks."""
        for m, n in ((3, 5), (4, 6), (6, 10), (12, 18), (8, 12)):
            pi, sigma = crt_lenses(m, n)
            self.assertIsNone(integrality_obstruction(pi, sigma))
            cert = commutation_certificate(pi, sigma)
            self.assertTrue(cert["commutes"], (m, n, cert))
            self.assertEqual(cert["join_blocks"], math.gcd(m, n))

    def test_replicates_shilpin_order_sensitive_transfer(self):
        """Independent replication of
        `collab/messages/shilpin/order_sensitive_transfer.md` from the closed
        form, with no matrix multiplication anywhere."""
        pi, sigma = idempotent_lenses(1000)
        self.assertEqual(compose_entry(pi, sigma, 5, 0), Fraction(1, 400))
        self.assertEqual(compose_entry(sigma, pi, 5, 0), Fraction(1, 1025))
        col = commutator_column(pi, sigma, 0)
        self.assertEqual(col[5], Fraction(1, 656))
        self.assertEqual(col[2], Fraction(-1, 1025))
        self.assertEqual(sum(1 for v in col if v != 0), 984)

    def test_shilpin_pair_fails_by_pure_divisibility(self):
        """The observed noncommutation is forced, not incidental: the solution
        set has 4 elements, each decimal fiber has 100, and the join is
        everything, so the required overlap is 400/1000 = 2/5."""
        pi, sigma = idempotent_lenses(1000)
        obs = integrality_obstruction(pi, sigma)
        self.assertIsNotNone(obs)
        self.assertEqual(obs["join_block_size"], 1000)
        self.assertEqual(obs["required_overlap"], Fraction(2, 5))
        cert = commutation_certificate(pi, sigma)
        self.assertIs(cert["commutes"], False)
        x, z, v = cert["witness_entry"]
        self.assertNotEqual(v, 0)
        self.assertEqual(v, commutator_entry(pi, sigma, x, z))

    def test_balanced_lenses_need_block_counts_to_divide_the_size(self):
        """Corollary: balanced lenses with `a` and `b` blocks over a trivial
        join can only commute when `a*b | n`."""
        pi = partition_from(12, lambda x: x % 3)
        sigma = partition_from(12, lambda x: x % 4)
        self.assertTrue(commutation_certificate(pi, sigma)["commutes"])
        pi = partition_from(6, lambda x: x % 3)
        sigma = partition_from(6, lambda x: [0, 1, 2, 3, 0, 1][x])
        self.assertIsNotNone(integrality_obstruction(pi, sigma))
        self.assertFalse(_brute_commutes(pi, sigma))

    def test_refinement_kills_the_defect(self):
        """Śilpin's proposed repair, made exact: the common refinement
        `(L, C)` commutes with each lens, so a learner retaining the joint
        statistic has zero order defect."""
        pi, sigma = idempotent_lenses(1000)
        meet = list(zip(pi, sigma))
        self.assertTrue(commutation_certificate(pi, meet)["commutes"])
        self.assertTrue(commutation_certificate(sigma, meet)["commutes"])
        self.assertTrue(all(v == 0 for v in commutator_column(pi, meet, 0)))


if __name__ == "__main__":
    unittest.main()
