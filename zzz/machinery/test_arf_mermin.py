#!/usr/bin/env python3
"""Exact checks for the quadratic-refinement classification."""

import unittest

import machinery.pauli_context_memory as pcm
from machinery.arf_mermin import (
    NONZERO,
    arf_type,
    flatten,
    quadric_signature,
    refinements,
    singular,
    unflatten,
)


class Refinements(unittest.TestCase):
    def test_count_and_arf_split(self):
        """2^(2n) refinements, splitting 10 + 6 by Arf type at n = 2."""
        forms = refinements()  # polarization identity asserted inside
        self.assertEqual(len(forms), 16)
        types = [arf_type(q) for q in forms]
        self.assertEqual(types.count("plus"), 10)
        self.assertEqual(types.count("minus"), 6)

    def test_singular_counts(self):
        for q in refinements():
            n = len(singular(q))
            self.assertEqual(n, 9 if arf_type(q) == "plus" else 5)

    def test_torsor(self):
        """Refinements are exactly q_0 shifted by the 16 linear functionals."""
        forms = refinements()
        self.assertEqual(len({tuple(sorted(q.items())) for q in forms}), 16)


class MerminBijection(unittest.TestCase):
    def setUp(self):
        self.plus = [q for q in refinements() if arf_type(q) == "plus"]
        self.mermin = set()
        for chosen in pcm.all_context_covers(2):
            if (
                len(chosen) == 9
                and len(pcm.lagrangians(chosen, 2)) == 6
                and not pcm.is_noncontextual(chosen, 2)
            ):
                self.mermin.add(frozenset(flatten(v) for v in chosen))

    def test_squares_are_the_plus_type_quadrics(self):
        self.assertEqual(len(self.mermin), 10)
        self.assertEqual(self.mermin, {singular(q) for q in self.plus})

    def test_contexts_are_totally_singular_lines(self):
        for q in self.plus:
            obs = sorted(unflatten(a) for a in singular(q))
            ctxs = pcm.lagrangians(obs, 2)
            self.assertEqual(len(ctxs), 6)
            for L in ctxs:
                self.assertTrue(all(q[flatten(v)] == 0 for v in L))

    def test_memory_of_every_square_is_twentyfour(self):
        for q in self.plus:
            obs = sorted(unflatten(a) for a in singular(q))
            self.assertEqual(pcm.pure_memory(obs, 2), 24)


class ArfDoesNotSeparate(unittest.TestCase):
    """The negative result of notes/ARF_MERMIN_CLASSIFICATION.md section 5."""

    def test_blind_row_has_trivial_signature_in_both_families(self):
        seen = set()
        sizes = set()
        for chosen in pcm.all_context_covers(2):
            if (len(pcm.lagrangians(chosen, 2)), pcm.pure_memory(chosen, 2)) != (7, 60):
                continue
            sizes.add(len(chosen))
            sig = quadric_signature([flatten(v) for v in chosen])
            seen.add((not pcm.is_noncontextual(chosen, 2), sig))
        # both families present, both with the vacuous signature
        self.assertEqual(seen, {(True, (0, 0)), (False, (0, 0))})
        # and the counting reason: more than 9 observables cannot be singular
        self.assertTrue(all(s > 9 for s in sizes))

    def test_no_scenario_above_nine_observables_lies_on_a_quadric(self):
        for chosen in pcm.all_context_covers(2):
            if len(chosen) > 9:
                self.assertEqual(quadric_signature([flatten(v) for v in chosen]), (0, 0))

    def test_quadric_containment_matches_the_small_memory_values(self):
        contained, free = set(), set()
        for chosen in pcm.all_context_covers(2):
            sig = quadric_signature([flatten(v) for v in chosen])
            (contained if sig != (0, 0) else free).add(pcm.pure_memory(chosen, 2))
        self.assertEqual(contained, {1, 4, 20, 24})
        self.assertEqual(free, {6, 52, 56, 60})


if __name__ == "__main__":
    unittest.main()
