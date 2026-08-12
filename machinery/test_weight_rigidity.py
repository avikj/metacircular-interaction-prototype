#!/usr/bin/env python3
"""Exact tests for what reweighting can and cannot repair.

Answers my own question from message 0162, which I had flagged as possibly a
wish rather than a question.  It is a question, and the answer is no.
"""

import random
import unittest
from fractions import Fraction

from valuation_lens import (
    blocks_of,
    join,
    valuation_lens,
    weighted_commutes,
)
from weight_rigidity import (
    cell_matrices,
    codimension,
    commutes_by_rank,
    equalizing_weight,
    is_rank_one,
    permutable,
    weight_exists,
    singleton_rigidity_violations,
    weight_can_repair,
)


def _rand(rng, n, k):
    return [rng.randrange(k) for _ in range(n)]


class PermutabilityIsWeightIndependentTests(unittest.TestCase):
    def test_permutability_is_necessary_under_every_weight(self):
        """`(*)` demands `w(B cap D) w(E) = w(B) w(D) > 0`, so an empty overlap
        kills commutation whatever the weight."""
        rng = random.Random(3)
        tested = 0
        for _ in range(1500):
            n = rng.choice([4, 5, 6])
            pi, sg = _rand(rng, n, rng.choice([2, 3])), _rand(rng, n, rng.choice([2, 3]))
            if permutable(pi, sg):
                continue
            tested += 1
            for _ in range(6):
                w = [Fraction(rng.randrange(1, 9)) for _ in range(n)]
                self.assertFalse(weighted_commutes(pi, sg, w), (pi, sg, w))
        self.assertGreater(tested, 100)

    def test_permutability_itself_does_not_depend_on_weight(self):
        """Trivially true by definition, pinned so the split stays honest:
        the predicate takes no weight argument at all."""
        rng = random.Random(8)
        for _ in range(50):
            n = 5
            pi, sg = _rand(rng, n, 3), _rand(rng, n, 2)
            self.assertEqual(permutable(pi, sg), permutable(pi, sg))


class EquidistributionIsWeightDependentTests(unittest.TestCase):
    def test_verdicts_really_do_flip(self):
        """Reweighting is a genuine tool — otherwise the no-go below would be
        vacuous."""
        pi, sg = [0, 0, 0, 1, 1], [0, 1, 1, 0, 1]
        self.assertTrue(permutable(pi, sg))
        self.assertFalse(weighted_commutes(pi, sg, [Fraction(1)] * 5))
        self.assertTrue(
            weighted_commutes(pi, sg, [Fraction(t) for t in (1, 1, 1, 1, 2)])
        )

    def test_flips_only_happen_among_permutable_pairs(self):
        rng = random.Random(21)
        flips = 0
        for _ in range(1200):
            n = rng.choice([4, 5, 6])
            pi, sg = _rand(rng, n, rng.choice([2, 3])), _rand(rng, n, rng.choice([2, 3]))
            verdicts = {
                weighted_commutes(
                    pi, sg, [Fraction(rng.randrange(1, 9)) for _ in range(n)]
                )
                for _ in range(8)
            }
            if len(verdicts) > 1:
                flips += 1
                self.assertTrue(permutable(pi, sg), (pi, sg))
        self.assertGreater(flips, 5)


class CompletionTheoremTests(unittest.TestCase):
    """Permutability is not only necessary but SUFFICIENT once weights are
    free.  My stated expectation was that a counterexample existed; there is
    none, and the witness is explicit."""

    def test_equalizing_weight_repairs_every_permutable_pair(self):
        rng = random.Random(5)
        checked = 0
        for _ in range(3000):
            n = rng.choice([4, 5, 6, 7])
            pi = _rand(rng, n, rng.choice([2, 3, 4]))
            sg = _rand(rng, n, rng.choice([2, 3, 4]))
            if not permutable(pi, sg):
                continue
            checked += 1
            w = equalizing_weight(pi, sg)
            self.assertTrue(all(t > 0 for t in w))
            self.assertTrue(weighted_commutes(pi, sg, w), (pi, sg, w))
        self.assertGreater(checked, 300)

    def test_the_arithmetic_of_the_witness(self):
        """Inside a join block with `r` pi-blocks and `s` sigma-blocks, every
        cell has mass 1, so `w(B)=s`, `w(D)=r`, `w(E)=rs`, and
        `1*rs = s*r`."""
        pi, sg = [0, 0, 1, 1], [0, 1, 0, 1]
        w = equalizing_weight(pi, sg)
        pb, sb = blocks_of(pi), blocks_of(sg)
        j = join(pi, sg)
        E = blocks_of(j)[j[0]]
        r, s = len(pb), len(sb)
        self.assertEqual(sum(w[x] for x in E), Fraction(r * s))
        for B in pb.values():
            self.assertEqual(sum(w[x] for x in B), Fraction(s))
        for D in sb.values():
            self.assertEqual(sum(w[x] for x in D), Fraction(r))

    def test_weight_exists_is_exactly_permutability(self):
        rng = random.Random(19)
        for _ in range(600):
            n = rng.choice([4, 5, 6])
            pi = _rand(rng, n, rng.choice([2, 3]))
            sg = _rand(rng, n, rng.choice([2, 3]))
            self.assertEqual(weight_exists(pi, sg), permutable(pi, sg))
            if weight_exists(pi, sg):
                self.assertTrue(
                    weighted_commutes(pi, sg, equalizing_weight(pi, sg))
                )

    def test_singleton_rigidity_is_a_corollary(self):
        """A violating singleton fails permutability, so the completion
        theorem subsumes last turn's rigidity statement."""
        rng = random.Random(23)
        checked = 0
        for _ in range(2000):
            n = rng.choice([4, 5, 6])
            pi = _rand(rng, n, rng.choice([2, 3, 4]))
            sg = _rand(rng, n, rng.choice([2, 3]))
            if not singleton_rigidity_violations(pi, sg):
                continue
            checked += 1
            self.assertFalse(permutable(pi, sg), (pi, sg))
        self.assertGreater(checked, 100)


class SolutionVarietyTests(unittest.TestCase):
    """The commuting weights are exactly the rank-one cell matrices."""

    def test_rank_one_characterization_matches_the_criterion(self):
        rng = random.Random(2)
        seen = {True: 0, False: 0}
        for _ in range(2500):
            n = rng.choice([4, 5, 6])
            pi = _rand(rng, n, rng.choice([2, 3]))
            sg = _rand(rng, n, rng.choice([2, 3]))
            w = [Fraction(rng.randrange(1, 7)) for _ in range(n)]
            got = commutes_by_rank(pi, sg, w)
            seen[got] += 1
            self.assertEqual(got, weighted_commutes(pi, sg, w), (pi, sg, w))
        self.assertGreater(seen[True], 20)
        self.assertGreater(seen[False], 20)

    def test_every_outer_product_gives_a_commuting_weight(self):
        """Constructive converse: choose positive `u`, `v` per join block, set
        the cell mass to `u_i v_j`, split within cells arbitrarily."""
        rng = random.Random(9)
        built = 0
        for _ in range(2500):
            n = rng.choice([4, 5, 6, 7])
            pi = _rand(rng, n, rng.choice([2, 3]))
            sg = _rand(rng, n, rng.choice([2, 3]))
            if not permutable(pi, sg):
                continue
            j = join(pi, sg)
            w = [None] * n
            ok = True
            for E in blocks_of(j).values():
                Bs = sorted({pi[x] for x in E}, key=str)
                Ds = sorted({sg[x] for x in E}, key=str)
                u = [Fraction(rng.randrange(1, 9)) for _ in Bs]
                v = [Fraction(rng.randrange(1, 9)) for _ in Ds]
                for bi, b in enumerate(Bs):
                    for di, d in enumerate(Ds):
                        pts = [x for x in E if pi[x] == b and sg[x] == d]
                        if not pts:
                            ok = False
                            break
                        parts = [rng.randrange(1, 5) for _ in pts]
                        tot = sum(parts)
                        for x, pp in zip(pts, parts):
                            w[x] = u[bi] * v[di] * Fraction(pp, tot)
                if not ok:
                    break
            if not ok:
                continue
            built += 1
            self.assertTrue(weighted_commutes(pi, sg, w), (pi, sg, w))
        self.assertGreater(built, 200)

    def test_the_equalizing_weight_has_rank_one_cells(self):
        rng = random.Random(4)
        for _ in range(400):
            n = rng.choice([4, 5, 6])
            pi = _rand(rng, n, rng.choice([2, 3]))
            sg = _rand(rng, n, rng.choice([2, 3]))
            if not permutable(pi, sg):
                continue
            for M in cell_matrices(pi, sg, equalizing_weight(pi, sg)):
                self.assertTrue(is_rank_one(M))

    def test_codimension_counts_the_five_point_pair_correctly(self):
        """`pi = 00011`, `sigma = 01101`: one join block, two blocks each side,
        so codimension `(2-1)(2-1) = 1` — exactly the single equation
        `a e = d(b+c)` found by hand."""
        self.assertEqual(codimension([0, 0, 0, 1, 1], [0, 1, 1, 0, 1]), 1)

    def test_codimension_zero_means_every_weight_works(self):
        """A join block with a single block on one side constrains nothing."""
        rng = random.Random(6)
        checked = 0
        for _ in range(1500):
            n = rng.choice([4, 5, 6])
            pi = _rand(rng, n, rng.choice([2, 3]))
            sg = _rand(rng, n, rng.choice([2, 3]))
            if not permutable(pi, sg) or codimension(pi, sg) != 0:
                continue
            checked += 1
            for _ in range(4):
                w = [Fraction(rng.randrange(1, 9)) for _ in range(n)]
                self.assertTrue(weighted_commutes(pi, sg, w), (pi, sg, w))
        self.assertGreater(checked, 50)


class SingletonRigidityTests(unittest.TestCase):
    def test_a_violating_singleton_blocks_every_weight(self):
        """If a singleton `pi`-block's join block is not its `sigma`-block, no
        positive weight can make the pair commute."""
        rng = random.Random(11)
        tested = 0
        for _ in range(2500):
            n = rng.choice([4, 5, 6])
            pi, sg = _rand(rng, n, rng.choice([2, 3, 4])), _rand(rng, n, rng.choice([2, 3]))
            if not singleton_rigidity_violations(pi, sg):
                continue
            tested += 1
            for _ in range(5):
                w = [Fraction(rng.randrange(1, 9)) for _ in range(n)]
                self.assertFalse(weighted_commutes(pi, sg, w), (pi, sg, w))
        self.assertGreater(tested, 200)

    def test_the_mechanism(self):
        """A singleton `B = {b}` forces every `sigma`-block in `E` to contain
        `b`; blocks are disjoint, so there is exactly one and `E = D(b)`."""
        pi, sg = [0, 1, 1, 1], [0, 0, 1, 1]
        viol = singleton_rigidity_violations(pi, sg)
        self.assertEqual([v[0] for v in viol], [0])
        j = join(pi, sg)
        E = set(blocks_of(j)[j[0]])
        D = set(blocks_of(sg)[sg[0]])
        self.assertNotEqual(E, D)

    def test_weight_can_repair_is_sound(self):
        """`possible = False` must never be contradicted by an actual weight."""
        rng = random.Random(5)
        refuted = 0
        for _ in range(1500):
            n = rng.choice([4, 5])
            pi, sg = _rand(rng, n, rng.choice([2, 3])), _rand(rng, n, rng.choice([2, 3]))
            rep = weight_can_repair(pi, sg)
            if rep["possible"]:
                continue
            refuted += 1
            for _ in range(5):
                w = [Fraction(rng.randrange(1, 9)) for _ in range(n)]
                self.assertFalse(weighted_commutes(pi, sg, w), (pi, sg))
        self.assertGreater(refuted, 100)


class ZeroLocusIsWeightRigidTests(unittest.TestCase):
    def test_charging_the_zero_locus_never_flips_a_valuation_verdict(self):
        """`V(f)` is a singleton block of the valuation lens, so its
        contribution is weight-independent — confirming the search that found
        no flips, and showing the null-blindness is combinatorial."""
        rng = random.Random(7)
        for N, p, cap in ((8, 2, 3), (9, 3, 2), (16, 2, 4), (27, 3, 3)):
            pi = valuation_lens(N, p, cap)
            self.assertEqual(blocks_of(pi)[cap], [0])  # {0} is a singleton block
            sigmas = [[x % m for x in range(N)] for m in range(2, N)] + [
                [rng.randrange(3) for _ in range(N)] for _ in range(60)
            ]
            for sg in sigmas:
                uni = [Fraction(1)] * N
                charged = [Fraction(1)] * N
                charged[0] = Fraction(97)
                self.assertEqual(
                    weighted_commutes(pi, sg, uni),
                    weighted_commutes(pi, sg, charged),
                    (N, p, sg),
                )


if __name__ == "__main__":
    unittest.main()
