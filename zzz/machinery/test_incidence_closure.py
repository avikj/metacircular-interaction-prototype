#!/usr/bin/env python3
"""Closure as triangle-freeness: the criterion, and where its hypothesis fails."""

import unittest
from itertools import combinations

import machinery.pauli_context_memory as pcm
from machinery.incidence_closure import (
    analyse,
    incidence,
    maximal_commuting,
    pentagram_contexts,
    pentagram_observables,
    pentagram_report,
)


class EdgeType(unittest.TestCase):
    def test_square_is_edge_type_with_bipartite_incidence(self):
        obs = [pcm.pauli(w) for w in pcm.PERES_MERMIN]
        r = analyse("square", obs, 2)
        self.assertTrue(r["edge_type"])
        self.assertEqual(r["contexts"], 6)
        self.assertEqual(r["triangles"], 0)  # K_{3,3} is bipartite
        self.assertEqual(r["stars"], 6)

    def test_pentagram_is_edge_type_with_k5_incidence(self):
        r = pentagram_report()
        self.assertTrue(r["edge_type"])
        self.assertEqual(r["contexts"], 5)
        self.assertEqual(r["stars"], 5)
        self.assertEqual(r["triangles"], 10)

    def test_full_pauli_set_is_not_edge_type(self):
        """The hypothesis is a real restriction, not decoration."""
        r = analyse("all two-qubit Paulis", pcm.all_paulis(2), 2)
        self.assertFalse(r["E1_each_observable_on_two_contexts"])
        self.assertFalse(r["edge_type"])


class StarsAndTriangles(unittest.TestCase):
    """Maximal pairwise-commuting sets are exactly stars and triangles."""

    def test_square(self):
        obs = [pcm.pauli(w) for w in pcm.PERES_MERMIN]
        maximal = maximal_commuting(obs, 2)
        self.assertEqual(len(maximal), 6)          # six stars, no triangles
        self.assertTrue(all(len(S) == 3 for S in maximal))

    def test_pentagram(self):
        obs = pentagram_observables()
        maximal = maximal_commuting(obs, 3)
        sizes = sorted(len(S) for S in maximal)
        self.assertEqual(sizes.count(4), 5)        # five stars
        self.assertEqual(sizes.count(3), 10)       # ten triangles
        self.assertEqual(len(maximal), 15)

    def test_commutation_is_edge_intersection(self):
        """(E2) on both scenarios: commute iff the K-edges share a vertex."""
        for obs, ctx, n in (
            ([pcm.pauli(w) for w in pcm.PERES_MERMIN], pcm.lagrangians([pcm.pauli(w) for w in pcm.PERES_MERMIN], 2), 2),
            (pentagram_observables(), pentagram_contexts(), 3),
        ):
            on = incidence(obs, ctx, n)["on"]
            for u, v in combinations(obs, 2):
                self.assertEqual(bool(on[u] & on[v]), pcm.commute(u, v))


class ClosureCriterion(unittest.TestCase):
    def test_triangle_free_predicts_closure(self):
        obs = [pcm.pauli(w) for w in pcm.PERES_MERMIN]
        r = analyse("square", obs, 2)
        self.assertTrue(r["triangle_free"])
        self.assertTrue(r["closure_predicted"])
        self.assertTrue(r["closure_observed"])
        self.assertEqual(pcm.pure_memory(obs, 2), 6 * 4)

    def test_triangles_predict_closure_failure(self):
        r = pentagram_report()
        self.assertFalse(r["triangle_free"])
        self.assertFalse(r["closure_predicted"])
        self.assertFalse(r["closure_observed"])
        self.assertEqual(r["memory"], 200)
        self.assertNotEqual(r["memory"], r["contexts"] * 8)

    def test_label_sizes_are_one_or_three(self):
        """The derived bound.

        The label of a commuting family is the set of vertices it covers at
        least twice: the centre for a star, all three vertices for a triangle.
        Classically those are the only maximal intersecting families of edges,
        so the label has size 1 or 3 -- which is the bound `|S| <= 3` that
        RANK_THREE_MEMORY section 7 could only verify.
        """
        obs = pentagram_observables()
        on = incidence(obs, pentagram_contexts(), 3)["on"]
        seen = set()
        for S in maximal_commuting(obs, 3):
            covered = [v for v in range(5) if sum(1 for w in S if v in on[w]) >= 2]
            self.assertIn(len(covered), (1, 3))
            seen.add(len(covered))
        self.assertEqual(seen, {1, 3})

    def test_square_labels_are_all_singletons(self):
        """Triangle-free incidence: every label is a single context."""
        obs = [pcm.pauli(w) for w in pcm.PERES_MERMIN]
        ctx = pcm.lagrangians(obs, 2)
        on = incidence(obs, ctx, 2)["on"]
        for S in maximal_commuting(obs, 2):
            covered = [v for v in range(len(ctx)) if sum(1 for w in S if v in on[w]) >= 2]
            self.assertEqual(len(covered), 1)




class Necessity(unittest.TestCase):
    """Triangle-freeness is necessary too, under a stated non-degeneracy."""

    def test_pentagram_triangles_are_all_nondegenerate(self):
        from machinery.incidence_closure import nondegenerate_triangles

        nd = nondegenerate_triangles(pentagram_observables(), pentagram_contexts(), 3)
        self.assertEqual(nd["triangles"], 10)
        self.assertEqual(nd["vertex_checks"], 30)
        self.assertEqual(nd["degenerate"], [])
        self.assertTrue(nd["all_nondegenerate"])

    def test_two_qubit_edge_type_scenarios_are_forced_triangle_free(self):
        """When contexts are Lagrangians, E1 itself forbids a triangle.

        Exhaustive over all 3263 two-qubit union-of-context scenarios: exactly
        ten are edge-type -- the Mermin squares -- and they carry zero
        triangles between them. So necessity cannot even be tested at n = 2;
        the hypothesis is vacuous there, for a provable reason.
        """
        from itertools import combinations as _c

        from machinery.incidence_closure import incidence as _inc

        count = triangles = 0
        for chosen in pcm.all_context_covers(2):
            ctx = pcm.lagrangians(chosen, 2)
            inc = _inc(chosen, ctx, 2)
            if not inc["edge_type"]:
                continue
            count += 1
            edges = set(inc["on"].values())
            triangles += sum(
                1
                for t in _c(range(len(ctx)), 3)
                if all(frozenset(p) in edges for p in _c(t, 2))
            )
        self.assertEqual(count, 10)
        self.assertEqual(triangles, 0)

    def test_no_edge_type_counterexample_to_necessity_at_n_two(self):
        """No two-qubit edge-type scenario has a triangle and still closes."""
        from machinery.incidence_closure import incidence as _inc
        from machinery.incidence_closure import stars_and_triangles as _st

        for chosen in pcm.all_context_covers(2):
            ctx = pcm.lagrangians(chosen, 2)
            inc = _inc(chosen, ctx, 2)
            if not inc["edge_type"]:
                continue
            st = _st(inc["on"], len(ctx))
            closed = pcm.pure_memory(chosen, 2) == len(ctx) * 4
            self.assertFalse(st["triangles"] > 0 and closed)


if __name__ == "__main__":
    unittest.main()
