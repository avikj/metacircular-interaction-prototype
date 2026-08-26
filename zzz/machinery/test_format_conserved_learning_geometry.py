import unittest
from fractions import Fraction
from itertools import product

from format_conserved_learning_geometry import (
    assemble,
    class_reward,
    conditionals,
    factorize,
    kernel_basis_dimension,
    marginals,
    mwu,
    partition_from_format,
    uniform_policy,
)
from hecke_coset_smith_assembly import det2, mat_mul
from total_smith_replay_payload import payload, section
from verifier_blind_fiber_reward import bezout_format, det_format

BETA = Fraction(3, 2)


def event_window_payloads(mat, bound=8):
    """Payloads of all window events of mat (reusing the R0041 pattern)."""
    from test_verifier_blind_fiber_reward import window_events
    u0, v0, d = section(mat)
    return [payload(u, u0) for u, v in window_events(mat, d)]


class ConservationTest(unittest.TestCase):
    def test_measurable_rewards_conserve_conditionals_multistep(self):
        mat = ((4, 6), (2, 8))
        carrier = event_window_payloads(mat)
        self.assertGreater(len(carrier), 4)
        for fmt in (lambda h: 0, det_format, bezout_format):
            partition = partition_from_format(carrier, fmt)
            reward = {w: 5 if fmt(w) == fmt(carrier[0]) else 1
                      for w in carrier}
            pi = {w: Fraction(i + 1) for i, w in enumerate(carrier)}
            z = sum(pi.values())
            pi = {w: p / z for w, p in pi.items()}
            conds0 = conditionals(pi, partition)
            for _ in range(6):
                pi = mwu(pi, reward, BETA)
                self.assertEqual(conditionals(pi, partition), conds0)

    def test_converse_nonmeasurable_reward_moves_a_conditional(self):
        mat = ((4, 6), (2, 8))
        carrier = event_window_payloads(mat)
        partition = {0: list(carrier)}  # outcome format: one class
        reward = {w: (1 if i == 0 else 0) for i, w in enumerate(carrier)}
        pi = uniform_policy(carrier)
        conds0 = conditionals(pi, partition)
        pi2 = mwu(pi, reward, BETA)
        self.assertNotEqual(conditionals(pi2, partition), conds0)


class FrozenOutcomeTest(unittest.TestCase):
    def test_outcome_supervision_is_identity(self):
        mat = ((2, 0), (1, 7))
        carrier = event_window_payloads(mat)
        reward = {w: 7 for w in carrier}  # any verifier reward: constant
        pi = {w: Fraction(i + 2) for i, w in enumerate(carrier)}
        z = sum(pi.values())
        pi = {w: p / z for w, p in pi.items()}
        self.assertEqual(mwu(pi, reward, BETA), pi)


class SignFormatDynamicsTest(unittest.TestCase):
    def test_two_state_replicator_with_strict_marginal_growth(self):
        mat = ((2, 0), (0, -3))
        carrier = event_window_payloads(mat)
        partition = partition_from_format(carrier, det_format)
        self.assertEqual(set(partition), {1, -1})
        reward = {w: (3 if det_format(w) == 1 else 1) for w in carrier}
        pi = uniform_policy(carrier)
        conds0 = conditionals(pi, partition)
        prev = marginals(pi, partition)[1]
        for _ in range(5):
            pi = mwu(pi, reward, BETA)
            cur = marginals(pi, partition)[1]
            self.assertGreater(cur, prev)  # strict, exact rationals
            prev = cur
            self.assertEqual(conditionals(pi, partition), conds0)
        # induced dynamics on marginals equals MWU of the class reward
        margs = marginals(uniform_policy(carrier), partition)
        induced = class_reward(reward, partition)
        one_step = mwu(margs, induced, BETA)
        direct = marginals(
            mwu(uniform_policy(carrier), reward, BETA), partition
        )
        self.assertEqual(one_step, direct)


class FactorizationTest(unittest.TestCase):
    def test_product_structure_round_trip(self):
        mat = ((3, 5), (7, 2))
        carrier = event_window_payloads(mat)
        partition = partition_from_format(carrier, bezout_format)
        pi = {w: Fraction(2 * i + 1) for i, w in enumerate(carrier)}
        z = sum(pi.values())
        pi = {w: p / z for w, p in pi.items()}
        margs, conds = factorize(pi, partition)
        self.assertEqual(assemble(margs, conds, partition), pi)
        self.assertEqual(sum(margs.values()), 1)

    def test_kernel_dimension_count(self):
        mat = ((4, 6), (2, 8))
        carrier = event_window_payloads(mat)
        for fmt, expect_classes in ((lambda h: 0, 1), (det_format, 2)):
            partition = partition_from_format(carrier, fmt)
            self.assertEqual(len(partition), expect_classes)
            self.assertEqual(
                kernel_basis_dimension(partition),
                len(carrier) - len(partition),
            )


if __name__ == "__main__":
    unittest.main()
