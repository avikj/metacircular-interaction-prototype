#!/usr/bin/env python3
"""Exact checks for the signed-Pauli memory computation."""

import unittest

from machinery.pauli_context_memory import (
    PERES_MERMIN,
    PERES_MERMIN_CONTEXTS,
    all_context_covers,
    all_paulis,
    context_signs,
    generate,
    identity,
    is_noncontextual,
    lagrangians,
    multiply,
    matrix_control,
    pauli,
    predictive_quotient,
    pure_memory,
    reachable,
)


class SignedPauliArithmetic(unittest.TestCase):
    def test_agrees_with_explicit_matrices(self):
        matrix_control(1)
        matrix_control(2)

    def test_peres_mermin_sign_vector(self):
        signs = [context_signs(c) for c in PERES_MERMIN_CONTEXTS]
        self.assertEqual(signs, [1, 1, 1, 1, 1, -1])

    def test_square_is_contextual_and_its_control_is_not(self):
        obs = [pauli(w) for w in PERES_MERMIN]
        self.assertFalse(is_noncontextual(obs, 2))
        # dropping the anomalous context's third element removes the parity proof
        self.assertTrue(is_noncontextual([pauli(w) for w in PERES_MERMIN if w != "ZZ"], 2))


class LagrangianCover(unittest.TestCase):
    def test_counts(self):
        self.assertEqual(len(lagrangians(all_paulis(1), 1)), 3)
        self.assertEqual(len(lagrangians(all_paulis(2), 2)), 15)
        self.assertEqual(len(lagrangians([pauli(w) for w in PERES_MERMIN], 2)), 6)

    def test_sign_characters_per_context(self):
        """Each context carries exactly 2^n multiplier-compatible sign choices."""
        for L in lagrangians(all_paulis(2), 2):
            groups = set()
            basis = sorted(L)[:2]
            for s0 in (1, -1):
                for s1 in (1, -1):
                    groups.add(generate([(s0, basis[0]), (s1, basis[1])], 2))
            self.assertEqual(len(groups), 4)


class MemoryCounts(unittest.TestCase):
    def test_peres_mermin_is_twentyfour(self):
        obs = [pauli(w) for w in PERES_MERMIN]
        self.assertEqual(pure_memory(obs, 2), 24)

    def test_full_pauli_sets(self):
        self.assertEqual(pure_memory(all_paulis(1), 1), 6)
        self.assertEqual(pure_memory(all_paulis(2), 2), 60)

    def test_memory_states_are_pairwise_inequivalent(self):
        """No two reachable memory states share their future statistics."""
        for n, obs in ((1, all_paulis(1)), (2, [pauli(w) for w in PERES_MERMIN])):
            states = reachable(frozenset({identity(n)}), obs, n)
            self.assertEqual(len(predictive_quotient(states, obs, n)), len(states))

    def test_contextuality_blind_row_exists(self):
        """Some (|C|, memory) row carries both contextual and noncontextual
        scenarios: the memory count is not a contextuality witness."""
        rows = {}
        for chosen in all_context_covers(2):
            key = (len(lagrangians(chosen, 2)), pure_memory(chosen, 2))
            rows.setdefault(key, set()).add(not is_noncontextual(chosen, 2))
        blind = [k for k, v in rows.items() if v == {True, False}]
        self.assertIn((7, 60), blind)

    def test_contextual_memory_values(self):
        """Every contextual two-qubit context-cover scenario has memory 24 or 60,
        and 24 is attained exactly by the ten Mermin squares."""
        values, minimal = set(), 0
        for chosen in all_context_covers(2):
            if is_noncontextual(chosen, 2):
                continue
            mem = pure_memory(chosen, 2)
            values.add(mem)
            if mem == 24:
                minimal += 1
                self.assertEqual(len(chosen), 9)
                self.assertEqual(len(lagrangians(chosen, 2)), 6)
        self.assertEqual(values, {24, 60})
        self.assertEqual(minimal, 10)


class GroupLaw(unittest.TestCase):
    def test_anomalous_context_forces_a_sign(self):
        """XX * YY = -ZZ, so the anomalous context admits +XX,+YY only together
        with -ZZ; demanding all three positive produces -I and is rejected."""
        xx, yy, zz = (pauli(w) for w in ("XX", "YY", "ZZ"))
        self.assertEqual(multiply((1, xx), (1, yy)), (-1, zz))
        group = generate([(1, xx), (1, yy)], 2)
        self.assertIn((-1, zz), group)
        with self.assertRaises(ValueError):
            generate([(1, xx), (1, yy), (1, zz)], 2)

    def test_multiply_rejects_anticommuting(self):
        with self.assertRaises(ValueError):
            multiply((1, pauli("XI")), (1, pauli("ZI")))


if __name__ == "__main__":
    unittest.main()
