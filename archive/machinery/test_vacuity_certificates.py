"""Genuine-vs-vacuous certificates — test battery (exact integers only).

Covers, with exact expected verdicts and witnesses:

  L   the certificate law itself on synthetic universes: all four
      verdicts, canonical earliest witnesses, dedup, revisit honesty,
      the budget guard.
  A   R0036 window instance: mutant moduli table VACUOUS on the {-1,0,1}
      window at D = (1,2,4) with exhibited ambient pair (member,
      I + 2E_10); derived gcd-moduli description GENUINE on the same
      window with both fibers revisited by elementary certificates.
  B   nat-trace instance: mod-4 FORMS with the bridge's canonical pair
      (2, 8); mod-11 at n = 121 VACUOUS with 120 singleton fibers and
      ambient pair (2, 212); short-margin honesty (UNDECIDED, never
      GENUINE); mod-6 GENUINE with the explicit CRT interpolant; verdict
      alignment with nat_trace_descent_bridge.function_descent_verdict.
  C   living machine COMPLETE: bits=0 NOT-COMPLETE (payload-blind),
      bits=2 SHELL-LOCAL (epoch-1 shear k=4 is I mod 4; witness pair
      shares the matrix), bits=5 GENUINE-COMPLETE (injective on the full
      look-ahead), UNDECIDED on an empty look-ahead.

Run: cd machinery && python3 -m unittest test_vacuity_certificates -v
"""

import unittest

from vacuity_certificates import (
    FORMS, GENUINE, VACUOUS, UNDECIDED,
    NOT_COMPLETE, GENUINE_COMPLETE, SHELL_LOCAL,
    certify, certify_complete,
    instance_r0036_window, instance_nat_mod11, instance_nat_mod6,
    instance_nat_mod4_forms, instance_living_complete,
    nat_profile, living_universe, living_evaluator, LIVING_GENOME,
)


# ---------------------------------------------------------------- L: the law

class TestCertificateLaw(unittest.TestCase):
    """The four verdicts on synthetic universes, exactly."""

    def test_forms_with_earliest_witness(self):
        # parity carrier, f = x // 2: fiber {0,2} splits first at (0, 2)
        cert = certify([0, 1, 2, 3], lambda x: x % 2, lambda x: x // 2)
        self.assertEqual(cert["verdict"], FORMS)
        self.assertEqual(cert["witness"], (0, 2))
        self.assertEqual(cert["fiber"], 0)
        self.assertEqual(cert["values"], (0, 1))

    def test_genuine_with_explicit_interpolant(self):
        cert = certify(list(range(6)), lambda x: x % 3, lambda x: 10 * (x % 3),
                       margin=range(6, 12))
        self.assertEqual(cert["verdict"], GENUINE)
        self.assertEqual(cert["g"], {0: 0, 1: 10, 2: 20})
        self.assertEqual(cert["revisits"], 6)
        self.assertEqual(cert["revisited_fibers"], 3)
        self.assertEqual(cert["new_keys"], 0)

    def test_vacuous_with_exhibited_ambient_pair(self):
        # two singleton fibers on U; ambient state 2 rejoins fiber 0 and
        # splits it under F = identity-like observable
        cert = certify([0, 1], lambda x: x % 2, lambda x: x, margin=[2, 3])
        self.assertEqual(cert["verdict"], VACUOUS)
        self.assertEqual(cert["witness"], (0, 2))
        self.assertEqual(cert["values"], (0, 2))
        self.assertEqual(cert["witness_in_U"], (True, False))
        self.assertEqual(cert["singleton_fibers"], 2)

    def test_undecided_no_ambient(self):
        cert = certify([0, 1], lambda x: x, lambda x: 0)
        self.assertEqual(cert["verdict"], UNDECIDED)
        self.assertIn("no ambient world declared", cert["reason"])

    def test_undecided_empty_margin(self):
        # a margin entirely inside U is no margin at all
        cert = certify([0, 1], lambda x: x, lambda x: 0, margin=[0, 1])
        self.assertEqual(cert["verdict"], UNDECIDED)
        self.assertIn("never tested beyond U", cert["reason"])

    def test_undecided_no_revisit(self):
        # discrete carrier, margin opens only fresh fibers: constancy of
        # F on fibers is never exercised -> UNDECIDED, not GENUINE
        cert = certify([0, 1], lambda x: x, lambda x: 0, margin=[2, 3])
        self.assertEqual(cert["verdict"], UNDECIDED)
        self.assertIn("never revisited a fiber", cert["reason"])
        self.assertEqual(cert["new_keys"], 2)

    def test_margin_dedup_preserves_order_and_drops_U(self):
        # duplicates and U-states removed; first genuine margin state
        # decides the witness
        cert = certify([0, 1], lambda x: x % 2, lambda x: x,
                       margin=[0, 1, 3, 3, 2])
        self.assertEqual(cert["verdict"], VACUOUS)
        self.assertEqual(cert["witness"], (1, 3))
        self.assertEqual(cert["margin_size"], 2)

    def test_duplicate_universe_rejected(self):
        with self.assertRaises(ValueError):
            certify([0, 0, 1], lambda x: x, lambda x: x)

    def test_budget_guard(self):
        with self.assertRaises(ValueError):
            certify(range(90_000), lambda x: x, lambda x: x,
                    margin=range(90_000, 180_000))

    def test_forms_preempts_ambient(self):
        # a split inside U is FORMS regardless of any declared margin
        cert = certify([0, 1, 2, 3], lambda x: x % 2, lambda x: x // 2,
                       margin=range(4, 8))
        self.assertEqual(cert["verdict"], FORMS)


# ---------------------------------------------------------- A: R0036 window

class TestR0036WindowInstance(unittest.TestCase):
    """The {-1,0,1} window at D = (1,2,4): mutant table VACUOUS, derived
    gcd-moduli description GENUINE — the audit's J4 lesson certified."""

    @classmethod
    def setUpClass(cls):
        cls.vac, cls.gen = instance_r0036_window()

    def test_universe_is_the_full_window_group(self):
        self.assertEqual(self.vac["universe_size"], 6960)
        self.assertEqual(self.gen["universe_size"], 6960)
        # two fibers: member / non-member, both populated (216 members)
        self.assertEqual(self.vac["fibers"], 2)
        self.assertEqual(self.vac["singleton_fibers"], 0)

    def test_mutant_window_verdict_is_vacuous_with_the_pair(self):
        self.assertEqual(self.vac["verdict"], VACUOUS)
        a, w = self.vac["witness"]
        # ambient endpoint: the elementary certificate I + 2*E_10 —
        # a true member (2 | 2) the 997-mutant rejects
        self.assertEqual(w, ((1, 0, 0), (2, 1, 0), (0, 0, 1)))
        # U endpoint: a window member of the same (True) fiber
        self.assertEqual(self.vac["fiber"], True)
        self.assertEqual(self.vac["values"], (True, False))
        self.assertEqual(self.vac["witness_in_U"], (True, False))
        # and the U endpoint really is in the window
        self.assertTrue(all(abs(e) <= 1 for row in a for e in row))

    def test_derived_description_is_genuine_with_both_fibers_revisited(self):
        self.assertEqual(self.gen["verdict"], GENUINE)
        self.assertEqual(self.gen["g"], {True: True, False: False})
        self.assertEqual(self.gen["revisited_fibers"], 2)
        self.assertEqual(self.gen["new_keys"], 0)
        # all 42 elementary certificates revisit (6 positions x 8 values,
        # minus the 6 v=1 matrices already inside the window)
        self.assertEqual(self.gen["margin_size"], 42)
        self.assertEqual(self.gen["revisits"], 42)

    def test_same_universe_same_carrier_opposite_verdicts(self):
        # the whole lesson in one line: identical U and kappa, one
        # observable certified genuine, the other exposed as vacuous
        self.assertEqual(self.vac["universe_size"],
                         self.gen["universe_size"])
        self.assertNotEqual(self.vac["verdict"], self.gen["verdict"])


# ------------------------------------------------------------- B: nat trace

class TestNatTraceInstance(unittest.TestCase):
    """Span vacuity vs the CRT identity, with the bridge's witnesses."""

    def test_mod4_forms_with_bridge_witness(self):
        cert = instance_nat_mod4_forms()
        self.assertEqual(cert["verdict"], FORMS)
        self.assertEqual(cert["witness"], (2, 8))
        self.assertEqual(cert["fiber"], (0, 2))     # profile mod (2, 3)
        self.assertEqual(cert["values"], (2, 0))    # 2 mod 4 vs 8 mod 4

    def test_mod11_at_121_is_vacuous_with_ambient_pair_2_212(self):
        cert = instance_nat_mod11()
        self.assertEqual(cert["verdict"], VACUOUS)
        self.assertEqual(cert["witness"], (2, 212))
        self.assertEqual(cert["fiber"], (0, 2, 2, 2))
        self.assertEqual(cert["values"], (2, 3))
        self.assertEqual(cert["witness_in_U"], (True, False))
        # the mechanism: L = 210 > 119, profile injective on U
        self.assertEqual(cert["universe_size"], 120)
        self.assertEqual(cert["fibers"], 120)
        self.assertEqual(cert["singleton_fibers"], 120)

    def test_mod11_short_margin_is_undecided_never_genuine(self):
        # a margin below the period 210 never revisits a fiber: the
        # certificate refuses GENUINE instead of issuing it falsely
        cert = instance_nat_mod11(margin_hi=150)
        self.assertEqual(cert["verdict"], UNDECIDED)
        self.assertIn("never revisited", cert["reason"])
        self.assertEqual(cert["new_keys"], 28)

    def test_mod6_is_genuine_via_the_crt_interpolant(self):
        cert = instance_nat_mod6()
        self.assertEqual(cert["verdict"], GENUINE)
        g = cert["g"]
        self.assertEqual(len(g), 30)                # one key per residue mod 30
        # the interpolant IS the CRT identity: check it pointwise
        for k in range(2, 97):
            self.assertEqual(g[(k % 2, k % 3, k % 5)], k % 6, k)
        self.assertEqual(cert["revisits"], 60)      # two further periods
        self.assertEqual(cert["revisited_fibers"], 30)
        self.assertEqual(cert["new_keys"], 0)

    def test_alignment_with_bridge_trichotomy(self):
        # the bridge's derived verdicts and the certificate agree on all
        # three candidates, and the certificate adds the witnesses
        from nat_trace_descent_bridge import function_descent_verdict
        self.assertEqual(function_descent_verdict(4, [2, 3], 16),
                         ("forms", (2, 8)))
        self.assertEqual(function_descent_verdict(11, [2, 3, 5, 7], 121),
                         ("descends", "vacuous"))
        self.assertEqual(function_descent_verdict(6, [2, 3, 5], 36),
                         ("descends", "genuine"))


# ------------------------------------------------- C: living machine COMPLETE

class TestLivingMachineComplete(unittest.TestCase):
    """The COMPLETE verdict certified by look-ahead on the machine's own
    next world (deeper fiber family + bigger shell), with the machine's
    own evaluator and genome."""

    def test_bits0_not_complete(self):
        # hentries blind: payloads indistinguishable, carrier not
        # discrete — the COMPLETE precondition itself fails
        cert = instance_living_complete(bits=0)
        self.assertEqual(cert["verdict"], NOT_COMPLETE)
        (m1, h1), (m2, h2) = cert["witness"]
        self.assertEqual(m1, m2)                    # same matrix,
        self.assertNotEqual(h1, h2)                 # different payload
        self.assertEqual(cert["universe_size"], 400)
        self.assertEqual(cert["genome_size"], len(LIVING_GENOME))

    def test_bits2_complete_on_shell_but_shell_local(self):
        cert = instance_living_complete(bits=2)
        self.assertEqual(cert["verdict"], SHELL_LOCAL)
        # COMPLETE really held on the shell: carrier was discrete there
        self.assertEqual(cert["universe_size"], 400)
        self.assertEqual(cert["fibers"], 400)
        self.assertEqual(cert["singleton_fibers"], 400)
        # the exhibited collision: same matrix, identity payload vs the
        # epoch-1 shear k=4 — which IS the identity mod 2^2
        (m1, h1), (m2, h2) = cert["witness"]
        self.assertEqual(m1, m2)
        self.assertEqual(h1, ((1, 0), (0, 1)))
        self.assertEqual(h2, ((1, 4), (0, 1)))
        self.assertEqual(cert["witness_in_U"], (True, False))
        ev4 = living_evaluator(2)
        self.assertEqual([ev4(t, (m1, h1)) for t in LIVING_GENOME],
                         [ev4(t, (m2, h2)) for t in LIVING_GENOME])

    def test_bits5_genuine_complete_on_the_full_look_ahead(self):
        cert = instance_living_complete(bits=5)
        self.assertEqual(cert["verdict"], GENUINE_COMPLETE)
        self.assertEqual(cert["universe_size"], 400)
        # look-ahead: 160 deeper-fiber states on the same shell + 3808
        # states of the next shell, all with fresh genome keys
        self.assertEqual(cert["margin_size"], 160 + 3808)
        self.assertEqual(cert["new_keys"], 3968)
        self.assertEqual(cert["injective_on"], 4368)
        # for identity, a revisit-with-agreement is impossible: 0 is the
        # designed value, not a gap
        self.assertEqual(cert["revisits"], 0)

    def test_empty_look_ahead_is_undecided(self):
        U = living_universe(0, 1)
        cert = certify_complete(LIVING_GENOME, U, [], living_evaluator(2))
        self.assertEqual(cert["verdict"], UNDECIDED)
        self.assertIn("never tested beyond U", cert["reason"])

    def test_look_ahead_worlds_are_the_machines_own(self):
        # the sample is the machine's shell/h_family, not a re-derivation
        U = living_universe(0, 1)
        self.assertEqual(len(U), 400)               # 80 matrices x 5 payloads
        self.assertEqual(len(living_universe(1, 1)), 560)   # x 7 payloads
        self.assertEqual(len(living_universe(1, 2)), 3808)  # 544 x 7
        # discreteness never un-happens on subsets: every U state keeps
        # its key in the bits=5 GENUINE-COMPLETE run by construction
        # (keys are computed pointwise; no global renormalization exists)
        ev32 = living_evaluator(5)
        keys = {tuple(ev32(t, s) for t in LIVING_GENOME) for s in U}
        self.assertEqual(len(keys), 400)


if __name__ == "__main__":
    unittest.main()
