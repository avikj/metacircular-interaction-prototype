#!/usr/bin/env python3
"""Exact tests for the cyclotomic sensor organ.

The sweep in `test_agrees_with_direct_valuation` is a falsifier, not a
measurement: it can only refute the theorem in `notes/CYCLOTOMIC_SENSOR.md`.
Every other test checks an exact structural claim.
"""

from __future__ import annotations

import unittest
from math import gcd, isqrt

from arithmetic_life import ArithmeticLife
from cyclotomic_sensor import (
    CyclotomicOrgan,
    _factor_small,
    chain_head,
    cyclotomic_valuation,
    cyclotomic_value,
    factor_cyclotomic,
    factor_power_minus_one,
    has_primitive_divisor,
    largest_prime_factor,
    naive_trial_division,
    permits,
    search_progression,
    head_length,
    shifts_by_one,
    minimality_witness,
    multiplicative_order,
    valuation,
)


def organ_with(primes) -> CyclotomicOrgan:
    life = ArithmeticLife()
    for prime in primes:
        life.install_residue_sensor(prime, (0,))
    return CyclotomicOrgan(life)


class TestCyclotomicSensor(unittest.TestCase):
    def test_agrees_with_direct_valuation(self) -> None:
        """Falsifier sweep: sensor answer versus the formed integer."""
        organ = organ_with([2, 3, 5, 7, 11, 13, 17, 19, 23])
        checked = 0
        for prime in (2, 3, 5, 7, 11, 13, 17, 19, 23):
            for base in range(2, 30):
                if gcd(base, prime) != 1:
                    continue
                sensor = organ.form(prime, base)
                for exponent in range(1, 61):
                    self.assertEqual(
                        sensor.valuation(exponent),
                        valuation(base ** exponent - 1, prime),
                        f"p={prime} a={base} n={exponent}",
                    )
                    checked += 1
        self.assertGreater(checked, 10000)

    def test_one_encounter_answers_an_unformed_integer(self) -> None:
        """The sensor formed at n=10 answers n=1210 with no new observation."""
        organ = organ_with([11])
        sensor = organ.form(11, 2)
        self.assertEqual((sensor.order, sensor.depth), (10, 1))
        formations = organ.formations
        self.assertEqual(organ.valuation(11, 2, 1210), 3)
        self.assertEqual(organ.formations, formations)
        self.assertEqual(organ.reuses, 1)

    def test_bounded_chart_unbounded_valuation(self) -> None:
        """Chart depth is fixed at 2 while the answered valuation is unbounded."""
        organ = organ_with([11])
        sensor = organ.form(11, 2)
        self.assertEqual(sensor.base_chart_depth, 2)
        for power in range(1, 40):
            exponent = sensor.least_exponent_reaching(power)
            self.assertGreaterEqual(sensor.valuation(exponent), power)
            # The solution set is closed under multiples, so the least element
            # divides every element.  Minimality therefore follows from the
            # maximal proper divisors alone.
            for factor, _ in _factor_small(exponent):
                self.assertLess(sensor.valuation(exponent // factor), power)

    def test_minimality_witness_defeats_the_coarser_chart(self) -> None:
        """One digit less of the base does not determine the family."""
        organ = organ_with([2, 3, 5, 7, 11, 13])
        for prime, base in ((11, 2), (5, 2), (7, 3), (13, 4), (3, 2),
                            (2, 3), (2, 5), (2, 7), (2, 17)):
            sensor = organ.form(prime, base)
            other, exponent, other_valuation = minimality_witness(sensor)
            coarse = prime ** (sensor.base_chart_depth - 1)
            self.assertEqual(other % coarse, base % coarse)
            self.assertNotEqual(other_valuation, sensor.valuation(exponent))
            self.assertEqual(other_valuation, valuation(other ** exponent - 1, prime))

    def test_base_chart_depth_suffices(self) -> None:
        """Two bases agreeing at the chart depth induce the same whole family."""
        organ = organ_with([11, 7, 5])
        for prime, base in ((11, 2), (7, 3), (5, 7)):
            sensor = organ.form(prime, base)
            step = prime ** sensor.base_chart_depth
            for shift in (1, 2, 5):
                other = base + shift * step
                twin = organ.form(prime, other)
                self.assertEqual((twin.order, twin.depth), (sensor.order, sensor.depth))
                for exponent in range(1, 25):
                    self.assertEqual(sensor.valuation(exponent),
                                     twin.valuation(exponent))

    def test_two_is_exceptional(self) -> None:
        """The odd-prime law fails at 2 and the two-depth sensor repairs it."""
        organ = organ_with([2])
        sensor = organ.form(2, 3)
        self.assertEqual((sensor.depth, sensor.plus_depth), (1, 2))
        self.assertEqual(sensor.valuation(2), 3)
        self.assertNotEqual(sensor.valuation(2), sensor.depth + valuation(2, 2))
        self.assertEqual(sensor.valuation(2026), 3)
        self.assertEqual(min(sensor.depth, sensor.plus_depth), 1)

    def test_wieferich_deep_sensor(self) -> None:
        """A deep sensor is still one encounter: 1093 is a Wieferich prime."""
        organ = organ_with([1093])
        sensor = organ.form(1093, 2)
        self.assertEqual(sensor.order, 364)
        self.assertEqual(sensor.depth, 2)
        self.assertEqual(sensor.base_chart_depth, 3)
        self.assertEqual(sensor.valuation(364 * 1093), 3)
        self.assertEqual(sensor.valuation(363), 0)

    def test_causal_gate_and_unit_refusal(self) -> None:
        organ = CyclotomicOrgan(ArithmeticLife())
        with self.assertRaises(ValueError):
            organ.form(11, 2)
        gated = organ_with([3])
        with self.assertRaises(ValueError):
            gated.form(3, 6)
        with self.assertRaises(ValueError):
            gated.form(3, 2).valuation(0)

    def test_chain_law_against_exact_cyclotomic_values(self) -> None:
        """Falsifier sweep: chain reading versus exact integer Phi_m(a)."""
        organ = organ_with([2, 3, 5, 7, 11, 13])
        for prime in (2, 3, 5, 7, 11, 13):
            for base in range(2, 20):
                if base % prime == 0:
                    continue
                sensor = organ.form(prime, base)
                for index in range(1, 50):
                    self.assertEqual(
                        cyclotomic_valuation(sensor, index),
                        valuation(abs(cyclotomic_value(index, base)), prime)
                        if cyclotomic_value(index, base) != 0 else 0,
                        f"p={prime} a={base} m={index}",
                    )

    def test_chain_reassembles_theorem_one(self) -> None:
        """Summing the chain over divisors of n returns the sensor's answer."""
        organ = organ_with([2, 3, 5, 7, 11])
        for prime, base in ((11, 2), (7, 3), (5, 2), (3, 5), (2, 3), (2, 7)):
            sensor = organ.form(prime, base)
            for exponent in range(1, 90):
                total = sum(cyclotomic_valuation(sensor, m)
                            for m in range(1, exponent + 1) if exponent % m == 0)
                self.assertEqual(total, sensor.valuation(exponent),
                                 f"p={prime} a={base} n={exponent}")

    def test_head_length_is_the_whole_exception(self) -> None:
        """The p=2 case is not exceptional in the chart: its head is longer."""
        organ = organ_with([2, 3, 5, 7, 11, 13])
        for prime, base in ((11, 2), (7, 3), (5, 2), (13, 4), (3, 2)):
            self.assertEqual(len(chain_head(organ.form(prime, base))), 1)
        for base in (3, 5, 7, 9, 17):
            head = chain_head(organ.form(2, base))
            self.assertEqual(len(head), 2)
            self.assertEqual(min(head), 1)
        # Off the head the chain is constantly 1, at every prime alike.
        for prime, base in ((11, 2), (2, 3), (7, 3)):
            sensor = organ.form(prime, base)
            chain = 1 if prime == 2 else sensor.order
            for step in range(len(chain_head(sensor)), 6):
                self.assertEqual(
                    cyclotomic_valuation(sensor, chain * prime ** step), 1)

    def test_head_length_is_the_filtration_torsion_threshold(self) -> None:
        """Theorem 4: the head length is a function of p alone, and it is
        exactly the depth at which the unit filtration starts shifting by one."""
        organ = organ_with([2, 3, 5, 7, 11, 13, 17])
        for prime in (3, 5, 7, 11, 13, 17):
            self.assertEqual(head_length(prime), 1)
        self.assertEqual(head_length(2), 2)
        # The head length predicted from p alone matches every formed sensor.
        for prime in (2, 3, 5, 7, 11, 13, 17):
            for base in range(2, 30):
                if base % prime == 0:
                    continue
                self.assertEqual(len(chain_head(organ.form(prime, base))),
                                 head_length(prime))
        # The shift lemma holds at and above the threshold, and only there.
        for prime in (2, 3, 5, 7, 11):
            for depth in range(1, 5):
                for step in range(1, 6):
                    unit = 1 + step * prime ** depth
                    if valuation(unit - 1, prime) != depth:
                        continue
                    self.assertEqual(shifts_by_one(prime, unit, depth),
                                     depth >= head_length(prime),
                                     f"p={prime} x={unit} k={depth}")

    def test_minus_one_is_the_obstruction(self) -> None:
        """The p=2 failure at depth 1 is caused by an element of finite order."""
        self.assertEqual(valuation(-1 - 1, 2), 1)      # -1 lies in U_1
        self.assertEqual((-1) ** 2, 1)                  # and has order 2
        with self.assertRaises(ValueError):
            valuation((-1) ** 2 - 1, 2)                 # so its square exits
        # Every odd prime: -1 is not in U_1 at all, which is why odd p is clean.
        for prime in (3, 5, 7, 11, 13):
            self.assertEqual(valuation(-1 - 1, prime), 0)

    def test_every_prime_divisor_obeys_the_naming_law(self) -> None:
        """Theorem 5: a prime dividing Phi_m(a) is primitive or is the largest
        prime factor of m.  This is the exact statement, not a count."""
        for index in range(1, 34):
            for base in (2, 3, 5, 7, 10):
                step, exceptional = search_progression(index)
                result = factor_cyclotomic(index, base, compare=False)
                if not result.complete:
                    continue
                for prime, power in result.factors:
                    self.assertTrue(
                        permits(index, prime),
                        f"m={index} a={base} p={prime} escaped the naming law",
                    )
                    if multiplicative_order(base, prime) == index:
                        # primitive: the order is m exactly, so m divides p-1
                        self.assertEqual((prime - 1) % index, 0)
                    else:
                        # otherwise it is the exceptional prime, to power one,
                        # and (2,2) is the single carve-out of Theorem 5
                        self.assertEqual(prime, exceptional)
                        if (prime, index) != (2, 2):
                            self.assertEqual(power, 1,
                                             f"m={index} a={base} p={prime}")

    def test_odd_index_sharpening(self) -> None:
        """For odd m>1 the progression is 2m, not m: primitive primes are odd."""
        for index in (3, 5, 7, 9, 11, 15, 21, 25, 27, 33):
            step, _ = search_progression(index)
            self.assertEqual(step, 2 * index)
            for base in (2, 3, 5, 7):
                for prime, _power in factor_cyclotomic(
                        index, base, compare=False).factors:
                    if multiplicative_order(base, prime) == index:
                        self.assertEqual((prime - 1) % (2 * index), 0)

    def test_guided_search_agrees_and_costs_less(self) -> None:
        """The guided and unguided factorizations agree; the guided one is
        never more expensive, and at large index the ratio is the progression."""
        for index, base in ((11, 2), (23, 2), (29, 2), (37, 2), (41, 2)):
            result = factor_cyclotomic(index, base)
            naive_factors, naive_count, _cofactor, done = (
                naive_trial_division(abs(result.value)))
            self.assertTrue(done)
            self.assertEqual(result.factors, naive_factors)
            self.assertEqual(result.naive_candidates, naive_count)
            self.assertLessEqual(result.candidates_tried, result.naive_candidates)
            self.assertEqual(result.reconstruct(), abs(result.value))
        # The derivable claim: at a common bound the counts differ by step/2.
        # Checked where the bound is large enough that integer flooring is
        # negligible; the small-index deviation is flooring, not a constant.
        deep = factor_cyclotomic(37, 2)
        self.assertAlmostEqual(deep.naive_candidates / deep.candidates_tried,
                               deep.progression / 2, delta=1.0)

    def test_equal_budget_reaches_further(self) -> None:
        """The saving is reach, not luck: at the SAME budget the guided search
        finds a factor the unguided one cannot get to."""
        budget = 150_000
        guided = factor_cyclotomic(31, 10, budget=budget, compare=False)
        naive_factors, _tried, _cofactor, done = naive_trial_division(
            abs(cyclotomic_value(31, 10)), budget)
        self.assertFalse(done)
        self.assertFalse(guided.complete)
        self.assertIn((2791, 1), naive_factors)          # both reach this one
        self.assertIn((6943319, 1), guided.factors)      # only the chart does
        self.assertNotIn((6943319, 1), naive_factors)
        # ...and the reason is arithmetic, not heuristic: the progression is
        # 62, so at equal budget the guided scan ends 31 times further out.
        self.assertEqual(guided.progression // 2, 31)

    def test_incomplete_answer_is_typed_never_truncated(self) -> None:
        """An exhausted budget yields a cofactor, not a wrong factorization."""
        result = factor_cyclotomic(31, 10, budget=2000, compare=False)
        self.assertFalse(result.complete)
        self.assertGreater(result.cofactor, 1)
        self.assertEqual(result.reconstruct(), abs(result.value))
        for prime, _power in result.factors:
            self.assertTrue(permits(31, prime))

    def test_naming_law_is_vacuous_at_small_index(self) -> None:
        """m <= 2 carries no congruence information, and the code says so."""
        for index, expected in ((1, (1, None)), (2, (1, 2))):
            self.assertEqual(search_progression(index), expected)

    def test_routed_factorization_is_exact(self) -> None:
        """Routing through Phi_m for m | n returns the true factorization."""
        for base, exponent in ((2, 35), (2, 36), (2, 60), (2, 23), (10, 12),
                               (3, 24), (5, 12), (2, 1), (2, 2), (7, 6)):
            result = factor_power_minus_one(base, exponent)
            self.assertTrue(result.complete)
            self.assertEqual(result.reconstruct(), base ** exponent - 1)
            naive, _tried, _cofactor, done = naive_trial_division(
                base ** exponent - 1)
            if done:
                self.assertEqual(result.factors, naive)

    def test_degree_gain_is_sandwiched_by_the_totient(self) -> None:
        """Theorem 6(i).  The routed scan bound is a^(phi(n)/2) up to the
        factor (1 +- 1/a), because (a-1)^phi(m) <= Phi_m(a) <= (a+1)^phi(m).
        Both sides are asserted: an upper bound alone would not show the
        exponent is phi(n) rather than something smaller."""
        for base, exponent in ((2, 35), (2, 36), (2, 60), (10, 12), (3, 24),
                               (2, 23), (7, 6), (5, 20)):
            result = factor_power_minus_one(base, exponent)
            totient = sum(1 for k in range(1, exponent + 1)
                          if gcd(k, exponent) == 1)
            self.assertLessEqual(result.routed_scan_bound,
                                 isqrt((base + 1) ** totient),
                                 f"a={base} n={exponent} upper")
            self.assertGreaterEqual(result.routed_scan_bound,
                                    isqrt((base - 1) ** totient),
                                    f"a={base} n={exponent} lower")

    def test_prime_exponent_gets_no_degree_gain(self) -> None:
        """The theorem's own control.  For prime n, phi(n) = n-1, so the
        sandwich puts the routed bound within a factor a of the blind one:
        the route helps exactly when the exponent is composite."""
        for base, exponent in ((2, 23), (2, 17), (3, 11), (5, 7), (7, 5)):
            result = factor_power_minus_one(base, exponent)
            self.assertLessEqual(result.blind_scan_bound,
                                 (result.routed_scan_bound + 1) * base,
                                 f"a={base} n={exponent} claimed an unearned gain")
        # A composite exponent gains by exactly the totient deficit: the
        # predicted ratio is a^((n - phi(n))/2), computed, not chosen.
        for base, exponent in ((2, 24), (2, 36), (2, 60), (3, 24)):
            result = factor_power_minus_one(base, exponent)
            totient = sum(1 for k in range(1, exponent + 1)
                          if gcd(k, exponent) == 1)
            predicted = base ** ((exponent - totient) // 2)
            ratio = result.blind_scan_bound / result.routed_scan_bound
            self.assertGreaterEqual(ratio, predicted / base)
            self.assertLessEqual(ratio, predicted * base)

    def test_routing_earns_sensors_that_were_refused(self) -> None:
        """The loop closes: factoring earns the sensor, the sensor answers the
        infinite family.  A moment earlier the organ refused the question."""
        organ = CyclotomicOrgan(ArithmeticLife())
        with self.assertRaises(ValueError):
            organ.form(1321, 2)
        organ.route(2, 60)
        self.assertIn(1321, organ.life.moduli)
        sensor = organ.form(1321, 2)
        self.assertEqual(sensor.order, 60)
        self.assertEqual(sensor.valuation(59), 0)
        self.assertEqual(sensor.valuation(60), 1)
        self.assertEqual(sensor.valuation(60 * 1321), 2)
        self.assertIn("route-factor", [e.kind for e in organ.life.events])

    def test_route_reaches_where_the_blind_organ_grinds(self) -> None:
        """Exact ledger on one integer, not a claim about factoring in general."""
        blind = ArithmeticLife()
        blind.factor(2 ** 25 - 1)
        routed = CyclotomicOrgan(ArithmeticLife()).route(2, 25)
        self.assertEqual(len(blind.moduli), 760)        # sensors ground out
        self.assertEqual(max(blind.moduli), 5791)
        self.assertEqual(routed.candidates_tried, 14)   # trial divisions used
        self.assertEqual(routed.factors, ((31, 1), (601, 1), (1801, 1)))
        self.assertTrue(routed.complete)

    def test_proposal_earns_a_new_prime_every_time(self) -> None:
        """Theorem 7 as agency: each proposed encounter is guaranteed to yield
        a prime of order exactly the proposed exponent, hence one dividing no
        earlier base^k - 1."""
        organ = CyclotomicOrgan(ArithmeticLife())
        proposed = []
        for _ in range(9):
            index = organ.propose_encounter(2)
            self.assertIsNotNone(index)
            before = set(organ.life.moduli)
            organ.route(2, index)
            fresh = set(organ.life.moduli) - before
            self.assertTrue(fresh, f"proposed n={index} earned nothing")
            self.assertTrue(
                any(multiplicative_order(2, p) == index for p in fresh),
                f"proposed n={index} earned no PRIMITIVE prime",
            )
            proposed.append(index)
        # It declined 1 and 6, and no others below the last proposal.
        self.assertEqual(proposed, [2, 3, 4, 5, 7, 8, 9, 10, 11])

    def test_the_declined_encounter_is_declined_for_the_proved_reason(self) -> None:
        """Phi_6(2) equals the largest prime factor of 6, which by Theorem 7
        is exactly the condition for having no primitive divisor."""
        self.assertFalse(has_primitive_divisor(2, 6))
        self.assertEqual(cyclotomic_value(6, 2), largest_prime_factor(6))
        self.assertFalse(has_primitive_divisor(2, 1))
        self.assertEqual(cyclotomic_value(1, 2), 1)
        # base+1 a power of two is the index-2 carve-out
        for base in (3, 7, 15, 31):
            self.assertFalse(has_primitive_divisor(base, 2))
            self.assertEqual(cyclotomic_value(2, base), base + 1)
        for base in (2, 4, 5, 6, 8, 9):
            self.assertTrue(has_primitive_divisor(base, 2))

    def test_primitive_divisor_criterion_against_direct_search(self) -> None:
        """Falsifier sweep: the no-factoring decision versus actually looking."""
        checked, exceptions = 0, []
        for base in range(2, 20):
            for index in range(1, 19):
                found = factor_cyclotomic(index, base, budget=60_000,
                                          compare=False)
                if not found.complete:
                    continue
                checked += 1
                actual = any(base % prime and
                             multiplicative_order(base, prime) == index
                             for prime, _power in found.factors)
                self.assertEqual(has_primitive_divisor(base, index), actual,
                                 f"a={base} n={index}")
                if not actual:
                    exceptions.append((base, index))
        self.assertGreater(checked, 300)
        # The exceptions found are exactly the classical Zsigmondy list.
        self.assertEqual(sorted(exceptions), [(2, 1), (2, 6), (3, 2), (7, 2),
                                              (15, 2)])

    def test_order_is_exact(self) -> None:
        for prime in (2, 3, 5, 7, 11, 13, 101, 1093):
            for base in range(2, 15):
                if base % prime == 0:
                    continue
                order = multiplicative_order(base, prime)
                self.assertEqual(pow(base, order, prime), 1)
                self.assertTrue(all(pow(base, k, prime) != 1 for k in range(1, order)))


if __name__ == "__main__":
    unittest.main(verbosity=2)
