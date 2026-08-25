#!/usr/bin/env python3
"""Tests for the nat-trace <-> descent-ladder bridge.

Everything asserted here is an exact finite verification of a derived
statement (proofs in notes/NAT_TRACE_DESCENT_BRIDGE.md).  Ground truth is
arithmetic_life's own machinery, imported and run — never reimplemented.
Total work is small: the walk stops at 300.
"""

import unittest
from math import isqrt

from nat_trace_descent_bridge import (
    DescentMachine,
    IncrementalDescentMachine,
    NatBridge,
    candidate_verdict_table,
    function_descent_verdict,
    life_ground_truth,
    pure_function_descent_walk,
    smallest_divergences,
)

N = 300


def primes_upto(n):
    """Independent certified ground truth: exhaustive trial division."""
    return [k for k in range(2, n + 1)
            if all(k % d for d in range(2, isqrt(k) + 1))]


def lpf(k):
    return next(d for d in range(2, k + 1) if k % d == 0)


class TestIncrementalMatchesBatch(unittest.TestCase):
    """The incremental machine is the batch DescentMachine, exactly, on
    any fixed arrival prefix: same descends/forms verdicts in the same
    order, same final carrier partition."""

    OFFERS = [("mod2", lambda k: k % 2), ("mod3", lambda k: k % 3),
              ("mod6", lambda k: k % 6),   # descends: 6 | lcm(2,3)
              ("mod4", lambda k: k % 4),   # forms: 4 does not
              ("mod12", lambda k: k % 12),  # descends after mod4
              ("mod5", lambda k: k % 5)]   # forms

    def partition(self, labels):
        out = {}
        for x, lab in labels.items():
            out.setdefault(lab, set()).add(x)
        return sorted(map(frozenset, out.values()), key=min)

    def test_same_verdicts_and_carrier(self):
        universe = list(range(2, 41))
        batch = DescentMachine(universe)
        inc = IncrementalDescentMachine()
        for x in universe:
            inc.arrive(x)
        for name, f in self.OFFERS:
            eb = batch.offer(name, f)
            ei = inc.offer(name, f)
            self.assertEqual(eb["kind"], ei["kind"], name)
            self.assertEqual(eb["fibers"], ei["fibers"], name)
        self.assertEqual(self.partition(batch.carrier),
                         self.partition(inc.key))
        kinds = [e["kind"] for e in inc.history]
        self.assertEqual(kinds, ["forms", "forms", "descends",
                                 "forms", "descends", "forms"])

    def test_arrivals_interleaved_with_offers(self):
        """The carrier extends by evaluating the genome at each arrival:
        offering, then arriving more states, agrees with a batch run on
        the final universe with the same surviving genome."""
        inc = IncrementalDescentMachine()
        for x in range(2, 21):
            inc.arrive(x)
        inc.offer("mod2", lambda k: k % 2)
        for x in range(21, 41):
            inc.arrive(x)
        inc.offer("mod3", lambda k: k % 3)
        batch = DescentMachine(list(range(2, 41)))
        batch.offer("mod2", lambda k: k % 2)
        batch.offer("mod3", lambda k: k % 3)
        self.assertEqual(self.partition(batch.carrier),
                         self.partition(inc.key))


class TestBridgeMatchesLife(unittest.TestCase):
    """The bridge's installation trace IS the life's, event for event."""

    @classmethod
    def setUpClass(cls):
        cls.events, cls.moduli, cls.life_cls = life_ground_truth(N)
        cls.bridge = NatBridge().walk_to(N)

    def test_same_sensor_sequence(self):
        self.assertEqual(self.bridge.sensors, self.moduli)
        self.assertEqual(self.moduli, [2, 3, 5, 7, 11, 13, 17])
        self.assertEqual(self.moduli, primes_upto(isqrt(N)))

    def test_same_interleaved_event_sequence(self):
        stripped = [ev[:3] if ev[0] == "install" else ev
                    for ev in self.bridge.events]
        self.assertEqual(stripped, self.events)

    def test_same_skip_set(self):
        skips = [(ev[1], ev[2]) for ev in self.events if ev[0] == "skip"]
        self.assertEqual(skips, [(4, 2), (6, 2), (8, 2), (9, 3), (10, 2),
                                 (12, 2), (14, 2), (15, 3), (16, 2)])
        for m, p in skips:
            self.assertEqual(p, lpf(m))          # divisor = least origin
        self.assertEqual([m for m, _ in skips],
                         [m for m in range(2, isqrt(N) + 1)
                          if lpf(m) < m])        # exactly the composites

    def test_triggers_are_squares(self):
        for ev in self.events:
            m, trigger = (ev[1], ev[2]) if ev[0] == "install" \
                else (ev[1], ev[3])
            self.assertEqual(trigger, m * m)

    def test_same_classifications(self):
        for n in range(2, N + 1):
            self.assertEqual(self.bridge.classifications[n],
                             self.life_cls[n], n)


class TestCollisionStructure(unittest.TestCase):
    """Formation is collision-forced, exactly."""

    @classmethod
    def setUpClass(cls):
        cls.bridge = NatBridge().walk_to(N)

    def test_install_collision_pairs(self):
        """Every install happens at n = q*q with canonical collision pair
        (2, q*q): both certified prime beforehand, and the q-extended
        classifier calls q*q composite."""
        installs = [ev for ev in self.bridge.events if ev[0] == "install"]
        self.assertEqual(len(installs), 7)
        for _k, q, n, pair in installs:
            self.assertEqual(n, q * q)
            self.assertEqual(pair, (2, q * q))

    def test_q_and_q_squared_collide(self):
        """(q, q*q) is itself a collision pair: both in fiber-0 when q*q
        arrives, and mod-q's prime-test content separates them — q stays
        certified prime (q > sqrt(q)) while q*q becomes witnessed."""
        b = NatBridge()
        for q in [2, 3, 5, 7, 11]:
            while b.position < q * q - 1:
                b.step()
            b.machine.arrive(q * q)   # arrive by hand, inspect, then undo
            self.assertFalse(any(b.machine.key[q]))       # q in fiber-0
            self.assertFalse(any(b.machine.key[q * q]))   # q*q in fiber-0
            self.assertEqual(b._verdict(q, extra=q), ("prime", None))
            self.assertEqual(b._verdict(q * q, extra=q), ("composite", q))
            b.machine.universe.remove(q * q)
            del b.machine.key[q * q]
            b.step()                  # the real arrival installs q
            self.assertIn(q, b.sensors)

    def test_first_composite_in_fiber_zero_is_the_trigger(self):
        """Before n = q*q, fiber-0 holds only primes (no collision); the
        arrival of q*q is the first that puts a composite there."""
        b = NatBridge().walk_to(120)     # just before 121 = 11^2
        fz = b.fiber_zero()
        self.assertEqual(fz, primes_upto(120))
        b.step()                          # 121 arrives, forces mod-11
        self.assertEqual(b.sensors[-1], 11)
        self.assertEqual(b.fiber_zero(), primes_upto(121))

    def test_skips_lose_no_prime_test(self):
        """For every skipped m the extended classifier equals the current
        one on the whole arrived universe (the ideal absorption
        mZ <= lpf(m)Z, verified pointwise)."""
        b = self.bridge
        for kind, m, p, _n in [e for e in b.events if e[0] == "skip"]:
            for k in b.machine.universe:
                if k % m == 0 and m * m <= k:
                    self.assertTrue(any(b.machine.key[k]), (m, k))
            self.assertEqual(p, lpf(m))


class TestExactDivergence(unittest.TestCase):
    """life-skip is ideal descent, NOT function descent — both directions
    of the divergence, with smallest witnesses."""

    def test_smallest_witnesses(self):
        d1, d2 = smallest_divergences(N)
        # direction 1: life skips, raw function-descent FORMS.
        self.assertEqual(d1, (4, 16, ("skip", 2), ("forms", (2, 8))))
        # direction 2: life installs, raw function-descent absorbs
        # (vacuously — the fine carrier is discrete on the short universe).
        self.assertEqual(d2, (11, 121, ("install",),
                              ("descends", "vacuous")))

    def test_mod4_witness_pair_exact(self):
        """2 and 8 share the joint (mod-2, mod-3) profile on {2..16} but
        differ mod 4 — so mod-4 does not factor through the installed
        joint, although the life rightly skips it (4Z <= 2Z: no new prime
        test).  The two absorption lattices genuinely differ."""
        self.assertEqual((2 % 2, 2 % 3), (8 % 2, 8 % 3))
        self.assertNotEqual(2 % 4, 8 % 4)
        self.assertEqual(function_descent_verdict(4, [2, 3], 16),
                         ("forms", (2, 8)))

    def test_mod11_vacuity_certificate(self):
        """At n = 121 the joint profile of {2,3,5,7} is injective on
        {2..121} (210 > 119): the fine carrier is discrete, so EVERY
        observable descends and pure function-descent freezes — exactly
        the engine's recorded 121-defect (frozen sensors {2,3,5,7})."""
        profiles = {tuple(k % p for p in (2, 3, 5, 7))
                    for k in range(2, 122)}
        self.assertEqual(len(profiles), 120)          # discrete carrier
        self.assertEqual(function_descent_verdict(11, [2, 3, 5, 7], 121),
                         ("descends", "vacuous"))
        # ...and 121 is then misclassified by the frozen sensor set:
        self.assertTrue(all(121 % p for p in (2, 3, 5, 7)))

    def test_verdict_table_characterization(self):
        """Derived law, checked on every candidate: with S = primes < m
        and L = prod(S), on the universe {2..m*m} the raw descent verdict
        is  forms iff (m does not divide L and L <= m*m - 2), genuine iff
        m | L, vacuous otherwise; the life installs iff m is prime."""
        for m, trig, life_v, fd_v in candidate_verdict_table(N):
            S = primes_upto(m - 1)
            L = 1
            for p in S:
                L *= p
            self.assertEqual(life_v[0] == "install", lpf(m) == m, m)
            if S and L % m == 0:
                expected = ("descends", "genuine")
            elif L <= m * m - 2:
                expected = ("forms", (2, 2 + L))     # earliest witness
            else:
                expected = ("descends", "vacuous")
            self.assertEqual(fd_v, expected, m)
            self.assertEqual(trig, m * m)

    def test_vacuous_agreements_flip_on_long_universe(self):
        """m = 8, 9 agree in outcome (skip vs descends) only vacuously:
        on a universe of span >= L = 210 the raw law FORMS them, with the
        derived earliest witness (2, 2 + L)."""
        for m in (8, 9):
            self.assertEqual(function_descent_verdict(m, [2, 3, 5, 7], 250),
                             ("forms", (2, 212)))

    def test_pure_function_descent_organism(self):
        """The replacement organism (install iff raw-forms) is a different
        life: to 300 it installs [2,3,4,5,8,13], forming the
        non-squarefree 4 and 8 and vacuously absorbing primes."""
        installed, events = pure_function_descent_walk(N)
        self.assertEqual(installed, [2, 3, 4, 5, 8, 13])
        verdicts = {m: (kind, extra) for kind, m, _n, extra in events}
        self.assertEqual(verdicts[4], ("forms", (2, 8)))
        self.assertEqual(verdicts[8], ("forms", (2, 62)))
        skipped_primes = {m for m, (k, e) in verdicts.items()
                          if k == "descends" and lpf(m) == m}
        self.assertEqual(skipped_primes, {7, 11, 17})
        self.assertEqual(verdicts[7], ("descends", "vacuous"))
        self.assertEqual(verdicts[11], ("descends", "vacuous"))


class TestCarrierCheckpoints(unittest.TestCase):
    """The bridge's carrier is exactly the life's implicit carrier: the
    least-origin partition, sound against independent trial division."""

    def check_at(self, n_max):
        b = NatBridge().walk_to(n_max)
        ps = set(primes_upto(n_max))
        for k in b.machine.universe:
            hits = [v for v in b.machine.key[k] if v]
            if k in ps:
                self.assertEqual(hits, [], k)          # fiber-0 = primes
            else:
                self.assertEqual(min(hits), lpf(k), k)  # least origin
        # fiber count: fiber-0 plus one fiber per distinct hit-pattern
        self.assertEqual(b.fiber_zero(), sorted(ps))

    def test_checkpoint_100(self):
        self.check_at(100)

    def test_checkpoint_300(self):
        self.check_at(300)


if __name__ == "__main__":
    unittest.main()
