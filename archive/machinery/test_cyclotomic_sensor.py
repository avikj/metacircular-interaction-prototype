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
    acquisition_horizon,
    growth_rate,
    yield_bound,
    actual_yield,
    partial_bracket,
    certify_with_effort,
    least_deciding_effort,
    quote_resolution,
    resolve_contested,
    beats_certainly,
    widen_crossover,
    interleaving_weight,
    exponent_redundancy_witness,
    interface_report,
    perfect_power,
    base_refusal,
    target,
    fresh_yield,
    held_at,
    order_composition_witness,
    TOTIENT_DENSITY,
    next_budget_step,
    scan_cost,
    affordable,
    certainly_unaffordable,
    has_primitive_divisor,
    refusal,
    totient,
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

    def test_cyclotomic_lower_bound_lemma(self) -> None:
        """Falsifier for the lemma behind Theorem 8: Phi_n(a) > a^phi(n) / 8."""
        for base in range(2, 12):
            for index in range(1, 60):
                self.assertGreater(8 * abs(cyclotomic_value(index, base)),
                                   base ** totient(index),
                                   f"a={base} n={index}")

    def test_affordability_is_a_guarantee_not_a_prediction(self) -> None:
        """Every affordable encounter completes; that is the whole point."""
        for index in range(1, 60):
            if not affordable(2, index, 20_000):
                continue
            result = factor_cyclotomic(index, 2, budget=20_000, compare=False)
            self.assertTrue(result.complete,
                            f"n={index} was called affordable and did not finish")

    def test_the_broken_promise_is_now_a_stated_refusal(self) -> None:
        """Exponent 61 used to be proposed, cost the whole budget, and earn
        nothing.  Now it is declined, and the decline cites its theorem."""
        self.assertTrue(has_primitive_divisor(2, 61))      # one still EXISTS
        self.assertFalse(affordable(2, 61))                # but is unreachable
        why = refusal(2, 61)
        self.assertIsNotNone(why)
        self.assertIn("Theorem 8", why)
        # and the two refusals are distinguished, not merged
        self.assertIn("Theorem 7", refusal(2, 6))
        self.assertIsNone(refusal(2, 210))

    def test_horizon_is_finite_and_shaped_by_the_totient(self) -> None:
        """The reachable world is not an interval in n.  It is a sublevel set
        of phi: exponent 210 is affordable, exponent 61 is not."""
        budget = 200_000
        bound = acquisition_horizon(2, budget)
        reachable = [n for n in range(1, bound + 1)
                     if affordable(2, n, budget)]
        self.assertEqual(len(reachable), 101)
        self.assertEqual(max(reachable), 210)
        self.assertNotIn(61, reachable)
        self.assertIn(210, reachable)
        self.assertLess(totient(210), totient(61))
        # nothing past the proved bound can be affordable
        for n in (bound + 1, bound + 17, 2 * bound):
            self.assertTrue(certainly_unaffordable(2, n, budget))

    def test_every_proposal_now_delivers(self) -> None:
        """With affordability folded in, the promise is operational: each
        proposed encounter completes AND earns a primitive prime."""
        organ = CyclotomicOrgan(ArithmeticLife())
        for _ in range(20):
            index = organ.propose_encounter(2, budget=20_000)
            self.assertIsNotNone(index)
            held = set(organ.life.moduli)
            result = organ.route(2, index, budget=20_000)
            self.assertTrue(result.complete, f"proposed n={index}, incomplete")
            fresh = set(organ.life.moduli) - held
            self.assertTrue(any(multiplicative_order(2, p) == index
                                for p in fresh),
                            f"proposed n={index} earned no primitive prime")

    def test_growth_rate_is_derived_and_survives_eight_decades(self) -> None:
        """Theorem 9 falsifier.  The slope 2A/log a is DERIVED from the totient
        density; the sweep can only refute it.  Nothing here is fitted."""
        from math import log
        counts = {}
        for exponent in (3, 11):
            budget = 10 ** exponent
            bound = acquisition_horizon(2, budget)
            counts[exponent] = sum(1 for n in range(1, bound + 1)
                                   if affordable(2, n, budget))
        observed = (counts[11] - counts[3]) / 8.0
        derived = growth_rate(2) * log(10)
        # 10% over eight decades: wide enough that the staircase and the
        # O(log log B) correction fit, tight enough to reject a wrong constant
        # (A versus 2A would be a factor of two).
        self.assertAlmostEqual(observed, derived, delta=0.10 * derived)
        # the count itself is monotone in the budget
        self.assertGreater(counts[11], counts[3])

    def test_the_staircase_is_exact(self) -> None:
        """The rate is smooth; the organ's experience is a staircase.  This is
        the height of the next stair, and it is a fact, not an estimate."""
        for budget in (200_000, 600_000, 2_000_000):
            step = next_budget_step(2, budget)
            self.assertIsNotNone(step)
            cost, index = step
            self.assertGreater(cost, budget)
            self.assertFalse(affordable(2, index, budget))
            self.assertTrue(affordable(2, index, cost))
            # nothing cheaper is unlocked first
            bound = acquisition_horizon(2, cost)
            for other in range(1, bound + 1):
                if affordable(2, other, budget):
                    continue
                if certainly_unaffordable(2, other, cost):
                    continue          # cheaply excluded, no Phi evaluation
                self.assertGreaterEqual(scan_cost(2, other), cost)

    def test_doubling_the_budget_can_buy_nothing(self) -> None:
        """The flat tread that motivated the whole increment."""
        bound = acquisition_horizon(2, 400_000)
        before = sum(1 for n in range(1, bound + 1) if affordable(2, n, 200_000))
        after = sum(1 for n in range(1, bound + 1) if affordable(2, n, 400_000))
        self.assertEqual(before, after)
        cost, index = next_budget_step(2, 200_000)
        self.assertEqual((cost, index), (516_928, 106))
        self.assertGreater(cost, 400_000)          # which is why doubling failed

    def test_the_cheapest_stair_is_the_reflected_index(self) -> None:
        """Phi_{2m}(x) = Phi_m(-x) for odd m > 1, so Phi_106(2) = Phi_53(2)/3
        and index 106 is cheaper than index 53 by exactly sqrt(3)."""
        # Phi_106(2) = Phi_53(-2) = (2^53 + 1)/3, while Phi_53(2) = 2^53 - 1:
        # the two differ by 2 as well as by the factor 3.
        self.assertEqual(3 * cyclotomic_value(106, 2), 2 ** 53 + 1)
        self.assertEqual(cyclotomic_value(53, 2), 2 ** 53 - 1)
        ratio = scan_cost(2, 53) / scan_cost(2, 106)
        self.assertAlmostEqual(ratio, 3 ** 0.5, delta=0.01)

    def test_totient_density_constant_is_what_it_claims(self) -> None:
        """The one hard-coded float in the module, checked against its
        definition rather than trusted: A = zeta(2) zeta(3) / zeta(6)."""
        def zeta(s: int, terms: int = 200_000) -> float:
            # partial sum plus the integral tail int_N^inf x^-s dx = N^(1-s)/(s-1);
            # without it the s=2 truncation is short by about 1/N and the
            # comparison silently fails at the fifth decimal.
            head = sum(k ** (-s) for k in range(1, terms + 1))
            return head + terms ** (1 - s) / (s - 1)
        self.assertAlmostEqual(TOTIENT_DENSITY,
                               zeta(2) * zeta(3) / zeta(6), places=9)

    def test_sensors_do_not_compose_in_the_base(self) -> None:
        """Theorem 10, the no-go five successor lists pointed at.  The sensor
        at p for base a*b is NOT a function of the sensors for a and b."""
        for prime in (7, 11, 13, 17, 19):
            witness = order_composition_witness(prime)
            self.assertIsNotNone(witness, f"p={prime} had no witness")
            left, right, other_left, other_right = witness
            self.assertEqual(multiplicative_order(left, prime),
                             multiplicative_order(other_left, prime))
            self.assertEqual(multiplicative_order(right, prime),
                             multiplicative_order(other_right, prime))
            self.assertNotEqual(
                multiplicative_order(left * right % prime, prime),
                multiplicative_order(other_left * other_right % prime, prime))

    def test_holdings_transport_into_the_new_base(self) -> None:
        """A held prime is re-delivered by exactly one exponent of the new
        base, namely its order there — computed without factoring anything."""
        organ = CyclotomicOrgan(ArithmeticLife())
        for _ in range(8):
            organ.route(2, organ.propose_encounter(2))
        for prime in organ.life.moduli:
            if 3 % prime == 0:
                continue
            index = multiplicative_order(3, prime)
            self.assertIn(prime, held_at(organ, 3, index))
            for other in range(1, 20):
                if other != index:
                    self.assertNotIn(prime, held_at(organ, 3, other))

    def test_fresh_yield_catches_the_cross_base_collision(self) -> None:
        """The exact case the organ walked into blind: Phi_4(3) = 10 = 2*5,
        and 5 was already held from base 2 where ord_5(2) = 4."""
        organ = CyclotomicOrgan(ArithmeticLife())
        for _ in range(8):
            organ.route(2, organ.propose_encounter(2))
        self.assertIn(5, organ.life.moduli)
        self.assertEqual(multiplicative_order(3, 5), 4)
        is_fresh, residual, held = fresh_yield(organ, 3, 4)
        self.assertEqual(held, (5,))
        self.assertEqual(residual, 1)       # 10 / 5, then strip exceptional 2
        self.assertFalse(is_fresh)
        # exponents 5, 6, 12 are pure re-deliveries too
        for index in (5, 6, 12):
            self.assertFalse(fresh_yield(organ, 3, index)[0])
        # but 16 holds 17 and is still fresh
        is_fresh, residual, held = fresh_yield(organ, 3, 16)
        self.assertEqual(held, (17,))
        self.assertTrue(is_fresh)
        # The power divided out must be EXACT, not a lower bound: too large and
        # a fresh encounter is reported stale, which is the silent direction.
        for index in range(1, 25):
            for prime in held_at(organ, 3, index):
                sensor = organ.form(prime, 3)
                self.assertEqual(
                    cyclotomic_valuation(sensor, index),
                    valuation(abs(cyclotomic_value(index, 3)), prime),
                    f"p={prime} m={index}")

    def test_cross_base_proposal_always_earns_something_new(self) -> None:
        """The per-base guarantee, finally closed across bases."""
        organ = CyclotomicOrgan(ArithmeticLife())
        for _ in range(8):
            organ.route(2, organ.propose_encounter(2))
        for _ in range(6):
            index = organ.propose_fresh_encounter(3)
            self.assertIsNotNone(index)
            held = set(organ.life.moduli)
            organ.route(3, index)
            self.assertTrue(set(organ.life.moduli) - held,
                            f"fresh proposal n={index} earned nothing new")

    def test_targeting_finds_the_base_that_makes_a_prime_cheap(self) -> None:
        """The base is a free parameter and it swings the cost enormously:
        ord_1093(2) = 364 puts 1093 out of reach, ord_1093(3) = 7 earns it."""
        bases = tuple(range(2, 12))
        route = target(1093, bases)
        self.assertIsNotNone(route)
        self.assertEqual((route.base, route.index), (3, 7))
        self.assertTrue(route.primitive)
        self.assertLess(route.cost, 10)
        self.assertEqual(multiplicative_order(2, 1093), 364)
        # and the route actually delivers
        organ = CyclotomicOrgan(ArithmeticLife())
        organ.route(route.base, route.index)
        self.assertIn(1093, organ.life.moduli)

    def test_targeting_equals_exhaustive_reach(self) -> None:
        """Theorem 12: targeting reorders acquisitions, it does not extend
        them.  The targetable set and the exhaustively reachable set agree."""
        bases, budget = (2, 3, 5), 3_000
        reached: set[int] = set()
        for base in bases:
            bound = acquisition_horizon(base, budget)
            for index in range(1, bound + 1):
                if not affordable(base, index, budget):
                    continue
                result = factor_cyclotomic(index, base, budget=budget,
                                           compare=False)
                self.assertTrue(result.complete)
                reached.update(prime for prime, _power in result.factors)
        self.assertGreater(len(reached), 15)
        pool = [n for n in range(2, 400)
                if all(n % d for d in range(2, isqrt(n) + 1))]
        for prime in pool:
            targetable = target(prime, bases, budget) is not None
            self.assertEqual(targetable, prime in reached,
                             f"p={prime} targetable={targetable} "
                             f"reached={prime in reached}")

    def test_unbounded_repertoire_makes_targeting_vacuous(self) -> None:
        """The theorem has content only because the repertoire is fixed.  With
        the base free, Phi_1(p+1) = p earns any prime in one division."""
        for prime in (1093, 3511, 65537, 2147483647):
            self.assertEqual(cyclotomic_value(1, prime + 1), prime)
            route = target(prime, (prime + 1,))
            self.assertIsNotNone(route)
            self.assertEqual((route.base, route.index), (prime + 1, 1))
            # ...while the fixed small repertoire genuinely cannot reach 3511
            self.assertIsNone(target(3511, tuple(range(2, 12))))

    def test_perfect_power_bases_are_redundant(self) -> None:
        """Theorem 13(i): (c^k)^n - 1 = c^(kn) - 1, exactly."""
        for root in range(2, 8):
            for power in range(2, 5):
                base = root ** power
                self.assertEqual(perfect_power(base)[0] ** perfect_power(base)[1],
                                 base)
                for index in range(1, 12):
                    self.assertEqual(base ** index - 1,
                                     root ** (power * index) - 1)

    def test_redundant_base_earns_nothing_the_root_cannot(self) -> None:
        """Theorem 13(ii): a prime primitive for (c^k, n) has ord_p(c) = d with
        n = d/gcd(d,k), and phi(d) <= k phi(n) — the root's route is no larger
        in degree, so the redundancy is a real saving and not a formality."""
        for root, power in ((2, 2), (2, 3), (3, 2), (5, 2)):
            base = root ** power
            for index in range(1, 14):
                result = factor_cyclotomic(index, base, compare=False)
                if not result.complete:
                    continue
                for prime, _mult in result.factors:
                    if root % prime == 0:
                        continue
                    order = multiplicative_order(root, prime)
                    self.assertEqual(order // gcd(order, power),
                                     multiplicative_order(base, prime))
                    self.assertLessEqual(
                        totient(order),
                        power * totient(multiplicative_order(base, prime)),
                        f"c={root} k={power} p={prime}")

    def test_organ_chooses_its_own_bases(self) -> None:
        """Eight increments of bases handed in from outside, now chosen."""
        organ = CyclotomicOrgan(ArithmeticLife())
        picks = []
        for _ in range(12):
            base = organ.propose_base()
            picks.append(base)
            organ.routed.setdefault(base, set()).add(1)
        self.assertEqual(picks, [2, 3, 5, 6, 7, 10, 11, 12, 13, 14, 15, 17])
        declined = [b for b in range(2, 40) if base_refusal(b) is not None]
        self.assertEqual(declined, [4, 8, 9, 16, 25, 27, 32, 36])
        self.assertIn("2^3", base_refusal(8))
        self.assertIn("Theorem 13", base_refusal(8))
        self.assertIsNone(base_refusal(6))

    def test_exponents_are_never_redundant(self) -> None:
        """Theorem 14: the redundancy pattern has exactly two instances and its
        boundary is Zsigmondy.  A witness exists for every exponent outside the
        classical exception list, so no exponent can be pruned."""
        exceptions = []
        for base in range(2, 12):
            for index in range(1, 16):
                witness = exponent_redundancy_witness(base, index)
                if witness is None:
                    if has_primitive_divisor(base, index):
                        continue          # affordability, not redundancy
                    exceptions.append((base, index))
                    continue
                # the witness divides Phi_index(base) and no smaller family term
                self.assertEqual(cyclotomic_value(index, base) % witness, 0)
                self.assertEqual(multiplicative_order(base, witness), index)
                for smaller in range(1, index):
                    self.assertNotEqual((base ** smaller - 1) % witness, 0)
        # exactly the R0029 list, reached from the other side
        self.assertEqual(sorted(exceptions),
                         [(2, 1), (2, 6), (3, 2), (7, 2)])

    def test_every_input_slot_is_accounted_for(self) -> None:
        """The arc closes: each slot is either chosen by the organ or proved
        unprunable.  Nothing is handed in without a rule or a theorem."""
        report = interface_report()
        self.assertEqual([row[0] for row in report],
                         ["modulus", "base", "exponent"])
        self.assertEqual([row[3] for row in report], [True, True, False])
        for _slot, _op, _retained, _prunable, reason in report:
            self.assertTrue(reason.strip())
        # the two prunable slots really do have working selection rules
        organ = CyclotomicOrgan(ArithmeticLife())
        self.assertEqual(organ.propose_base(), 2)
        self.assertIsNone(base_refusal(2))
        self.assertIsNotNone(base_refusal(4))
        self.assertEqual(organ.propose_encounter(2), 2)

    def test_deepen_widen_crossover_is_derived(self) -> None:
        """Theorem 15.  Raising phi by 2 multiplies cost by b; raising the base
        by 1 multiplies it by ((b+1)/b)^(phi/2).  They cross at
        phi = 2 log b / log(1+1/b), about 3.42 at base 2 — so past the smallest
        totients an organ should deepen, not widen."""
        from math import log
        for base in (2, 3, 5, 10):
            crossover = widen_crossover(base)
            self.assertAlmostEqual(crossover,
                                   2 * log(base) / log(1 + 1 / base), places=9)
            # below the crossover widening is cheaper, above it deepening is
            for phi in (crossover * 0.5, crossover * 2.0):
                widen = (phi / 2) * log((base + 1) / base)
                deepen = log(base)
                self.assertEqual(widen < deepen, phi < crossover)
        self.assertLess(widen_crossover(2), 3.5)
        self.assertGreater(widen_crossover(2), 3.4)

    def test_global_proposal_goes_deep_before_it_goes_wide(self) -> None:
        """The organ used to work each base once and abandon it.  Ordering by
        cost over both slots keeps it in base 2 far past the first exponent."""
        organ = CyclotomicOrgan(ArithmeticLife())
        picks = []
        for _ in range(14):
            choice = organ.propose_next(budget=20_000, base_limit=12)
            self.assertIsNotNone(choice)
            base, index = choice
            held = set(organ.life.moduli)
            organ.route(base, index, budget=20_000)
            self.assertTrue(set(organ.life.moduli) - held,
                            f"({base},{index}) earned nothing new")
            picks.append((base, index))
        # every one of the first fourteen is base 2, spanning many exponents
        self.assertEqual({base for base, _ in picks}, {2})
        self.assertGreater(max(index for _, index in picks), 20)
        # and the costs are non-decreasing: it really is cheapest-first
        costs = [scan_cost(base, index) for base, index in picks]
        self.assertEqual(costs, sorted(costs))

    def test_routing_covers_the_divisors_it_actually_factored(self) -> None:
        """`factor_power_minus_one` routes every Phi_m with m | n, so the
        bookkeeping must mark those exponents covered, not only n."""
        organ = CyclotomicOrgan(ArithmeticLife())
        organ.route(2, 12)
        self.assertEqual(organ.routed[2], {1, 2, 3, 4, 6, 12})
        self.assertIsNone(organ.propose_next(budget=1, base_limit=3))

    def test_both_coverage_readings_agree(self) -> None:
        """`propose_encounter` reads `routed` through a divisibility test while
        `propose_next` reads it by membership.  After the divisor-covering fix
        the two must agree, and this asserts it rather than assuming it."""
        organ = CyclotomicOrgan(ArithmeticLife())
        for base, index in ((2, 12), (2, 20), (3, 6)):
            organ.route(base, index, budget=20_000)
        for base in (2, 3):
            covered = organ.routed.get(base, set())
            for index in range(1, 40):
                by_membership = index in covered
                by_divisibility = any(done % index == 0 for done in covered)
                self.assertEqual(by_membership, by_divisibility,
                                 f"base {base} index {index}")

    def test_yield_bound_is_never_violated(self) -> None:
        """Theorem 16: every primitive prime is = 1 mod n so is at least n+1,
        and Phi_n(b) <= (b+1)^phi(n); so k primitive primes force
        (n+1)^k <= (b+1)^phi(n).  Falsifier sweep against real factorizations."""
        tight = 0
        for base in range(2, 8):
            for index in range(1, 26):
                result = factor_cyclotomic(index, base, compare=False)
                if not result.complete:
                    continue
                actual = sum(1 for prime, _power in result.factors
                             if base % prime
                             and multiplicative_order(base, prime) == index)
                bound = yield_bound(base, index)
                self.assertLessEqual(actual, bound,
                                     f"b={base} n={index}: {actual} > {bound}")
                if actual == bound:
                    tight += 1
        self.assertGreater(tight, 0, "bound never attained; suspiciously loose")

    def test_certificate_is_sound_for_every_admissible_yield(self) -> None:
        """When `beats_certainly` says yes, cheapest-first wins for EVERY yield
        assignment the bounds allow — checked exhaustively, not argued."""
        cases = ((2, 3, 2, 20), (2, 5, 3, 12), (2, 7, 5, 10), (3, 4, 2, 24))
        checked = 0
        for cheap_base, cheap_index, rival_base, rival_index in cases:
            cheap_cost = scan_cost(cheap_base, cheap_index)
            rival_cost = scan_cost(rival_base, rival_index)
            if not beats_certainly(cheap_cost, rival_cost,
                                   rival_base, rival_index):
                continue
            for cheap_yield in range(1, yield_bound(cheap_base,
                                                    cheap_index) + 1):
                for rival_yield in range(1, yield_bound(rival_base,
                                                        rival_index) + 1):
                    self.assertLessEqual(cheap_cost / cheap_yield,
                                         rival_cost / rival_yield)
                    checked += 1
        self.assertGreater(checked, 0)

    def test_organ_reports_the_size_of_its_own_uncertainty(self) -> None:
        """The certificate splits the grid into provably-beaten and contested,
        and the contested set is never empty — near-ties always exist, and
        reporting that is the point."""
        organ = CyclotomicOrgan(ArithmeticLife())
        for _ in range(6):
            choice, certified, contested = organ.optimality_certificate(
                budget=20_000, base_limit=8)
            self.assertIsNotNone(choice)
            self.assertGreater(certified, 0)
            self.assertGreater(contested, 0)
            # every contested rival really is inside the yield window
            cheap = scan_cost(*choice)
            for base in range(2, 9):
                if base_refusal(base) is not None:
                    continue
                for index in range(1, 40):
                    if (base, index) == choice:
                        continue
                    if index in organ.routed.get(base, set()):
                        continue
                    if refusal(base, index, 20_000) is not None:
                        continue
                    rival = scan_cost(base, index)
                    if not beats_certainly(cheap, rival, base, index):
                        self.assertLess(rival,
                                        yield_bound(base, index) * cheap)
            organ.route(*choice, budget=20_000)

    def test_sharper_floor_would_convert_five_verdicts(self) -> None:
        """R0027 gives p >= 2n+1 for odd n>1 where Theorem 16 uses p >= n+1.
        The uniform bound is weaker on purpose (one formula, not two); this
        measures exactly what that costs rather than leaving it to a breaker."""
        from math import log

        def sharp(base: int, index: int) -> int:
            floor_prime = 2 * index + 1 if (index > 1 and index % 2) else index + 1
            return max(int(totient(index) * log(base + 1)
                           / log(floor_prime)), 1)

        organ = CyclotomicOrgan(ArithmeticLife())
        choice = organ.propose_next(budget=20_000, base_limit=8)
        cheap = scan_cost(*choice)
        weak = strong = 0
        for base in range(2, 9):
            if base_refusal(base) is not None:
                continue
            for index in range(1, acquisition_horizon(base, 20_000) + 1):
                if (base, index) == choice:
                    continue
                if certainly_unaffordable(base, index, 20_000):
                    continue
                if refusal(base, index, 20_000) is not None:
                    continue
                cost = scan_cost(base, index)
                weak += cost < yield_bound(base, index) * cheap
                strong += cost < sharp(base, index) * cheap
                # the sharper floor never loosens the bound
                self.assertLessEqual(sharp(base, index),
                                     yield_bound(base, index))
        self.assertEqual((weak, strong), (52, 47))

    def test_yield_lower_bound_is_sharp(self) -> None:
        """Theorem 17: Zsigmondy's Y >= 1 cannot be improved.  Whenever the
        primitive part is a single prime the yield is exactly one, however
        large the upper bound is — so no argument from (b,n) alone can narrow
        the contested window."""
        witnesses = 0
        for base, index in ((2, 7), (2, 13), (2, 17), (2, 19), (2, 27)):
            self.assertEqual(actual_yield(base, index), 1)
            self.assertGreaterEqual(yield_bound(base, index), 3)
            witnesses += 1
        self.assertGreater(witnesses, 0)
        # Phi_17(2) is prime, so the gap between bound and truth is 6 to 1
        self.assertEqual(cyclotomic_value(17, 2), 131071)
        self.assertEqual(yield_bound(2, 17), 6)

    def test_contested_pairs_are_purchasable_at_a_quoted_price(self) -> None:
        """What cannot be derived can be bought, and the price is quoted first."""
        organ = CyclotomicOrgan(ArithmeticLife())
        choice = organ.propose_next(budget=20_000, base_limit=8)
        cheap = scan_cost(*choice)
        bought = 0
        for base in range(2, 9):
            if base_refusal(base) is not None:
                continue
            for index in range(1, 30):
                rival = (base, index)
                if rival == choice:
                    continue
                if refusal(base, index, 20_000) is not None:
                    continue
                if beats_certainly(cheap, scan_cost(base, index), base, index):
                    continue
                quote = quote_resolution(choice, rival)
                verdict = resolve_contested(choice, rival, budget=20_000)
                self.assertIsNotNone(verdict)
                self.assertEqual(verdict.price, quote)
                # the verdict is exactly the cost-per-prime comparison
                mine = cheap / verdict.winner_yield if verdict.winner == choice \
                    else scan_cost(*rival) / verdict.winner_yield
                theirs = scan_cost(*verdict.loser) / verdict.loser_yield
                self.assertLessEqual(mine, theirs)
                bought += 1
        self.assertGreater(bought, 10)

    def test_resolution_declines_when_it_cannot_pay(self) -> None:
        """The refusal is about affordability, not about existence."""
        expensive = (2, 53)
        quote = quote_resolution((2, 3), expensive)
        self.assertGreater(quote, 100_000)
        self.assertIsNone(resolve_contested((2, 3), expensive, budget=1_000))
        self.assertIsNotNone(resolve_contested((2, 3), (2, 5), budget=1_000))

    def test_contested_pairs_are_always_affordable(self) -> None:
        """Theorem 18: contested means cost_2 < Y * cost_1, so the resolution
        price is under (1+Y) times the encounter itself.  R0038's third
        position — undecided because unaffordable — is empty for real
        contested pairs."""
        organ = CyclotomicOrgan(ArithmeticLife())
        for budget in (20_000, 200_000):
            choice = organ.propose_next(budget=budget, base_limit=8)
            cheap = scan_cost(*choice)
            worst, seen = 0.0, 0
            for base in range(2, 9):
                if base_refusal(base) is not None:
                    continue
                for index in range(1, acquisition_horizon(base, budget) + 1):
                    if (base, index) == choice:
                        continue
                    if certainly_unaffordable(base, index, budget):
                        continue
                    if refusal(base, index, budget) is not None:
                        continue
                    if beats_certainly(cheap, scan_cost(base, index),
                                       base, index):
                        continue
                    seen += 1
                    price = quote_resolution(choice, (base, index))
                    self.assertLessEqual(price, budget)
                    self.assertLess(price,
                                    (1 + yield_bound(base, index)) * cheap)
                    worst = max(worst, price / cheap)
            self.assertGreater(seen, 10)
            self.assertLess(worst, 10.0)

    def test_the_illustration_was_not_a_contested_pair(self) -> None:
        """Correction: (2,53) was used to show an unaffordable resolution, but
        it is certified, not contested — its cost exceeds Y times the choice."""
        cheap = scan_cost(2, 3)
        self.assertTrue(beats_certainly(cheap, scan_cost(2, 53), 2, 53))
        self.assertLessEqual(yield_bound(2, 53), 15)
        self.assertGreater(scan_cost(2, 53), yield_bound(2, 53) * cheap)

    def test_resolution_keeps_what_it_pays_for(self) -> None:
        """The organ used to buy a verdict and discard the primes."""
        pure = CyclotomicOrgan(ArithmeticLife())
        resolve_contested((2, 3), (2, 11), budget=20_000)
        self.assertEqual(pure.life.moduli, [])        # nothing kept
        keeping = CyclotomicOrgan(ArithmeticLife())
        verdict = keeping.resolve_and_keep((2, 3), (2, 11), budget=20_000)
        self.assertIsNotNone(verdict)
        self.assertEqual(sorted(keeping.life.moduli), [7, 23, 89])
        self.assertEqual(keeping.routed[2], {1, 3, 11})
        # and the verdict is the same one the pure function gives
        self.assertEqual(verdict.winner,
                         resolve_contested((2, 3), (2, 11),
                                           budget=20_000).winner)

    def test_partial_bracket_always_contains_the_truth(self) -> None:
        """Theorem 19 falsifier: the bracket is a bound, so the true yield must
        lie inside it at every effort, and the bracket must never widen."""
        for base, index in ((2, 29), (2, 37), (2, 41), (5, 19), (3, 22)):
            truth = actual_yield(base, index)
            self.assertIsNotNone(truth)
            previous = None
            for effort in (0, 1, 2, 5, 10, 30, 60, 200, 500):
                bracket = partial_bracket(base, index, effort=effort)
                self.assertLessEqual(bracket.low, truth,
                                     f"b={base} n={index} e={effort}")
                self.assertLessEqual(truth, bracket.high,
                                     f"b={base} n={index} e={effort}")
                if previous is not None:
                    self.assertGreaterEqual(bracket.low, previous.low)
                    self.assertLessEqual(bracket.high, previous.high)
                previous = bracket

    def test_zero_effort_reports_no_knowledge(self) -> None:
        """With nothing scanned the bracket must fall back to the R0027 floor
        of index+1, not to the untested candidate — which would report a
        spurious exact answer."""
        for base, index in ((2, 29), (5, 19), (2, 41)):
            bracket = partial_bracket(base, index, effort=0)
            self.assertEqual(bracket.low, 1)
            self.assertGreater(bracket.high, 1)
            self.assertLessEqual(bracket.high, yield_bound(base, index))

    def test_bracket_reaches_exactness_far_below_the_full_price(self) -> None:
        """The point of the loophole: certainty at a fraction of the cost."""
        for base, index, ceiling in ((2, 29, 60), (5, 19, 400), (2, 41, 400)):
            bracket = partial_bracket(base, index, effort=ceiling)
            self.assertTrue(bracket.exact, f"b={base} n={index}")
            self.assertEqual(bracket.low, actual_yield(base, index))
            self.assertLess(bracket.spent, scan_cost(base, index) // 3)

    def test_effort_can_certify_what_the_a_priori_bound_cannot(self) -> None:
        """R0038's no-go covers bounds on (b,n) alone; a partial scan is not
        such a bound, and it decides pairs the a priori test leaves contested."""
        left, right = (2, 3), (2, 11)
        self.assertFalse(beats_certainly(scan_cost(*left), scan_cost(*right),
                                         *right))          # contested a priori
        self.assertTrue(certify_with_effort(left, right, effort=20))
        # and the verdict agrees with paying in full
        verdict = resolve_contested(left, right, budget=20_000)
        self.assertEqual(verdict.winner, left)

    def test_exactness_coincides_with_scan_termination(self) -> None:
        """Sharp form of last sitting's measurement, which was wrong twice: it
        used the WORST-CASE bound as baseline, and the bracket was loose
        because its primality test looked at the last tested candidate rather
        than the loop's own exit condition.  Corrected, the ratio is not a
        distribution at all — exactness arrives at exactly the effort at which
        the scan terminates, because both are the test `candidate^2 > R`."""
        ratios = []
        for base in (2, 3, 5, 7):
            for index in range(10, 46):
                worst = scan_cost(base, index)
                if worst < 50 or worst > 300_000:
                    continue
                real = factor_cyclotomic(index, base,
                                         compare=False).candidates_tried
                low, high = 0, worst
                while low < high:
                    middle = (low + high) // 2
                    if partial_bracket(base, index, effort=middle).exact:
                        high = middle
                    else:
                        low = middle + 1
                ratios.append(low / max(real, 1))
        self.assertGreater(len(ratios), 50)
        self.assertEqual(min(ratios), 1.0)
        self.assertEqual(max(ratios), 1.0)

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
