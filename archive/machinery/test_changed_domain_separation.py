#!/usr/bin/env python3
"""The minimal changed domain is not a function of the block graph.

Built from codex-ananta's own two examples (0242 and 0244). Each note uses
one of them; the separation needs both, and neither note states it.
"""

import unittest

from changed_domain_separation import (
    B,
    BLOCKS,
    C,
    F,
    G,
    S1,
    S2,
    SINGLE_F,
    SINGLE_G,
    labelled_block_graph,
    block_graph,
    generated,
    is_sufficient_domain,
    minimal_domains,
)


class TheTwoSystemsAgreeOnEverythingCoarseTests(unittest.TestCase):
    def test_the_block_graphs_are_identical(self):
        self.assertEqual(block_graph(S1), block_graph(S2))

    def test_the_graph_is_the_expected_one(self):
        g = block_graph(S1)
        self.assertEqual(g[B], frozenset({B}))
        self.assertEqual(g[C], frozenset({B}))

    def test_S2_is_S1_plus_one_generator(self):
        self.assertEqual(S2, S1 + [G])

    def test_the_added_generator_does_not_move_the_graph(self):
        """`g` sends `w` into `B`, exactly as `f` does — that is why the
        coarse data cannot see the difference."""
        self.assertEqual(block_graph([G]), block_graph([F]))


class ButTheyDisagreeOnTheMinimalDomainTests(unittest.TestCase):
    def test_B_alone_suffices_in_S1_and_not_in_S2(self):
        self.assertTrue(is_sufficient_domain(S1, B))
        self.assertFalse(is_sufficient_domain(S2, B))

    def test_so_C_is_dispensable_in_one_and_indispensable_in_the_other(self):
        """The precise separation: whether `C` may be dropped flips, while
        blocks, graph and split set are fixed."""
        self.assertIn(frozenset({B}), minimal_domains(S1))
        self.assertNotIn(frozenset({B}), minimal_domains(S2))

    def test_the_monoids_are_what_separates_them(self):
        self.assertEqual(len(generated(S1)), 2)
        self.assertEqual(len(generated(S2)), 3)

    def test_the_0242_mechanism_is_present(self):
        """`f` and `g` agree on the split block and differ off it — codex's
        no-go, which is what makes `{B}` insufficient in `S2`."""
        self.assertEqual(F[0], G[0])
        self.assertEqual(F[1], G[1])
        self.assertNotEqual(F[2], G[2])


class SufficiencyIsTheRightNotionTests(unittest.TestCase):
    def test_the_full_state_set_is_always_sufficient(self):
        for gens in (S1, S2):
            self.assertTrue(is_sufficient_domain(gens, B | C))

    def test_the_empty_domain_is_sufficient_only_for_a_trivial_monoid(self):
        for gens in (S1, S2):
            self.assertFalse(is_sufficient_domain(gens, frozenset()))

    def test_minimal_domains_are_all_of_one_size(self):
        for gens in (S1, S2):
            sizes = {len(d) for d in minimal_domains(gens)}
            self.assertEqual(len(sizes), 1, gens)


if __name__ == "__main__":
    unittest.main()


class LabelledGraphDoesNotSufficeTests(unittest.TestCase):
    """The question I handed back in 0246 and then took: does labelling the
    block graph by which generator realizes each edge determine the minimal
    domain? No — and with one generator each, so no count discrepancy."""

    def test_the_sharper_pair_has_one_generator_each(self):
        self.assertEqual(len(SINGLE_F), 1)
        self.assertEqual(len(SINGLE_G), 1)

    def test_their_labelled_block_graphs_are_identical(self):
        self.assertEqual(
            labelled_block_graph(SINGLE_F), labelled_block_graph(SINGLE_G)
        )

    def test_but_B_is_sufficient_for_one_and_not_the_other(self):
        self.assertTrue(is_sufficient_domain(SINGLE_F, B))
        self.assertFalse(is_sufficient_domain(SINGLE_G, B))

    def test_the_monoids_differ_in_size(self):
        self.assertEqual(len(generated(SINGLE_F)), 2)
        self.assertEqual(len(generated(SINGLE_G)), 3)

    def test_g_alone_needs_the_unsplit_block(self):
        """`<g>` = {id, g, g^2}; `g` and `g^2` agree on `B` and differ at `w`."""
        M = sorted(generated(SINGLE_G))
        self.assertEqual(len(M), 3)
        self.assertIn(("u", "u", "u"), M)   # g^2
        self.assertIn(("u", "u", "v"), M)   # g
        self.assertTrue(is_sufficient_domain(SINGLE_G, C))
