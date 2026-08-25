#!/usr/bin/env python3

import unittest

from pinning import (
    divisibility_refutes,
    droppable,
    frontier_domain,
    hybrid_refutes,
    is_prime,
    is_sound,
    pinned,
    primes_through,
    refuters,
    sensors_never_refute_a_prime,
    strong_refutes,
)


class SoundnessOfTheSensorsTests(unittest.TestCase):
    """Nothing below matters unless no sensor ever refutes a prime."""

    def test_no_sensor_refutes_a_prime(self):
        for bound in (20, 40, 60):
            self.assertTrue(sensors_never_refute_a_prime(bound, hybrid_refutes))
            self.assertTrue(sensors_never_refute_a_prime(bound, divisibility_refutes))


class TheoremPTests(unittest.TestCase):
    def test_clause_i_pinned_sensors_are_in_every_sound_anatomy(self):
        bound = 30
        sensors, domain = primes_through(bound), frontier_domain(bound)
        for number in pinned(domain, sensors, divisibility_refutes):
            forced = refuters(number, sensors, divisibility_refutes)
            self.assertEqual(len(forced), 1)
            survivor = [s for s in sensors if s not in forced]
            self.assertFalse(is_sound(survivor, [number], divisibility_refutes))

    def test_clause_ii_divisibility_forces_every_prime(self):
        """T5, recovered as an instance of pinning."""
        for bound in (20, 30, 40, 60):
            sensors, domain = primes_through(bound), frontier_domain(bound)
            self.assertEqual(droppable(sensors, domain, divisibility_refutes), [])

    def test_the_prime_square_is_what_pins(self):
        for prime in (2, 3, 5, 7, 11):
            sensors = primes_through(prime)
            self.assertEqual(refuters(prime * prime, sensors, divisibility_refutes),
                             {prime})

    def test_clause_iii_no_pinning_means_everything_is_droppable(self):
        for bound in (20, 30, 40, 50, 60):
            sensors, domain = primes_through(bound), frontier_domain(bound)
            self.assertEqual(pinned(domain, sensors, hybrid_refutes), [])
            self.assertEqual(droppable(sensors, domain, hybrid_refutes), sensors)


class FreedomWithPermanenceTests(unittest.TestCase):
    """The refutation of my own registered prior."""

    def test_the_hybrid_anatomy_is_sound_at_every_tested_frontier(self):
        for bound in (20, 30, 40, 50, 60, 80):
            sensors, domain = primes_through(bound), frontier_domain(bound)
            self.assertTrue(is_sound(sensors, domain, hybrid_refutes))

    def test_and_stays_sound_after_dropping_any_single_sensor(self):
        for bound in (20, 40, 60, 80):
            sensors, domain = primes_through(bound), frontier_domain(bound)
            for q in sensors:
                self.assertTrue(
                    is_sound([s for s in sensors if s != q], domain, hybrid_refutes),
                    f"B={bound} q={q}")

    def test_the_two_schemes_disagree_maximally(self):
        bound = 60
        sensors, domain = primes_through(bound), frontier_domain(bound)
        self.assertEqual(len(droppable(sensors, domain, divisibility_refutes)), 0)
        self.assertEqual(len(droppable(sensors, domain, hybrid_refutes)),
                         len(sensors))

    def test_the_second_mode_is_what_removes_the_pinning(self):
        """q^2 gains a refuter other than q exactly through the strong test."""
        for prime in (5, 7, 11, 13):
            sensors = primes_through(prime + 20)
            extra = {s for s in sensors
                     if s != prime and hybrid_refutes(s, prime * prime)}
            self.assertTrue(extra)
            for sensor in extra:
                self.assertFalse(divisibility_refutes(sensor, prime * prime))
                self.assertTrue(strong_refutes(sensor, prime * prime))


class ScopeTests(unittest.TestCase):
    """State the limit in the suite, so it cannot be quietly forgotten."""

    def test_the_verification_is_exhaustive_only_below_the_stated_frontier(self):
        bound = 60
        domain = frontier_domain(bound)
        self.assertEqual(min(domain), 4)
        self.assertEqual(max(domain), bound * bound)
        composites = [n for n in domain if not is_prime(n)]
        self.assertEqual(len(composites), sum(1 for n in range(4, bound * bound + 1)
                                              if not is_prime(n)))


if __name__ == "__main__":
    unittest.main()
