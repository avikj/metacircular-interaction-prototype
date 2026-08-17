#!/usr/bin/env python3
"""A formed organ that answers `v_p(a^n - 1)` for every n after one encounter.

The exponent chart (`exponent_world.py`) makes multiplication local and leaves
addition non-local; `adaptive_valuation_addition.py` (codex-ananta) shows that
for a generic sum the least residue chart that determines `v_p(a+b)` has depth
`v_p(a+b)+1`, so the cost of an answer tracks the answer itself.

This module exhibits the exact family on which that coupling breaks.  For the
multiplicatively generated sums `a^n - 1` a *bounded* chart of the base alone
determines an *unbounded* family of valuations, with no further observation of
the summands.  The classical input is the lifting-the-exponent lemma; what is
formed here is the finite sensor, its minimal base-chart depth, and the
explicit witness that one digit less is not enough.

Run `python3 cyclotomic_sensor.py` for the encounter trace.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import gcd, isqrt, prod

from arithmetic_life import ArithmeticLife

# The organ reduces the search space by exactly the progression; it does not
# make factoring easy.  Past this many trial divisions the answer is typed
# `incomplete` with the surviving cofactor, never silently truncated.
DEFAULT_BUDGET = 200_000


def valuation(n: int, prime: int) -> int:
    """Exact p-adic valuation of a nonzero integer."""
    if n == 0:
        raise ValueError("zero has no finite valuation; see ADAPTIVE_VALUATION_ADDITION")
    count = 0
    while n % prime == 0:
        n //= prime
        count += 1
    return count


def multiplicative_order(base: int, prime: int) -> int:
    """Least d>0 with base^d = 1 mod prime, by descent through divisors of p-1."""
    if base % prime == 0:
        raise ValueError("order is defined only for a base coprime to the prime")
    order = prime - 1
    for factor, _ in _factor_small(prime - 1):
        while order % factor == 0 and pow(base, order // factor, prime) == 1:
            order //= factor
    return order


def _factor_small(n: int) -> tuple[tuple[int, int], ...]:
    """Exhaustive trial-division factorization; exact, used only on p-1."""
    factors: list[tuple[int, int]] = []
    candidate = 2
    while candidate * candidate <= n:
        if n % candidate == 0:
            power = 0
            while n % candidate == 0:
                n //= candidate
                power += 1
            factors.append((candidate, power))
        candidate += 1
    if n > 1:
        factors.append((n, 1))
    return tuple(factors)


@dataclass(frozen=True)
class CyclotomicSensor:
    """Finite state answering `v_p(a^n - 1)` for all n>=1.

    Odd `prime`:  `order` = ord_p(a), `depth` = v_p(a^order - 1), `plus_depth` unused.
    `prime == 2`: `order` = 1, `depth` = v_2(a-1), `plus_depth` = v_2(a+1).
    """

    prime: int
    base: int
    order: int
    depth: int
    plus_depth: int | None
    base_chart_depth: int

    def valuation(self, exponent: int) -> int:
        if exponent < 1:
            raise ValueError("the cyclotomic family is indexed by exponents n>=1")
        if self.prime == 2:
            if exponent % 2:
                return self.depth
            assert self.plus_depth is not None
            return self.depth + self.plus_depth + valuation(exponent, 2) - 1
        if exponent % self.order:
            return 0
        return self.depth + valuation(exponent, self.prime)

    def divides(self, power: int, exponent: int) -> bool:
        """Does p^power divide a^exponent - 1?  No large integer is formed."""
        return self.valuation(exponent) >= power

    def least_exponent_reaching(self, power: int) -> int:
        """Least n with p^power | a^n - 1.  Inverts the sensor exactly."""
        if power <= 0:
            return 1
        if self.prime == 2:
            if power <= self.depth:
                return 1
            assert self.plus_depth is not None
            deficit = power - self.depth - self.plus_depth + 1
            return 2 ** max(deficit, 1)
        deficit = max(power - self.depth, 0)
        return self.order * self.prime ** deficit


class CyclotomicOrgan:
    """Forms cyclotomic sensors on demand and reuses them without recomputation."""

    def __init__(self, life: ArithmeticLife | None = None) -> None:
        self.life = life or ArithmeticLife()
        self.sensors: dict[tuple[int, int], CyclotomicSensor] = {}
        self.routed: dict[int, set[int]] = {}
        self.formations = 0
        self.reuses = 0

    def form(self, prime: int, base: int) -> CyclotomicSensor:
        """Install the sensor for (prime, base), gated on an earned residue sense."""
        if prime not in self.life.moduli:
            raise ValueError("the cyclotomic sensor needs an earned mod-p residue sense")
        if gcd(base, prime) != 1:
            raise ValueError("a^n - 1 is a unit at primes dividing a; no sensor is formed")
        key = (prime, base)
        if key in self.sensors:
            self.reuses += 1
            return self.sensors[key]
        if prime == 2:
            minus, plus = valuation(base - 1, 2), valuation(base + 1, 2)
            sensor = CyclotomicSensor(
                prime=2, base=base, order=1, depth=minus, plus_depth=plus,
                base_chart_depth=minus + plus,
            )
            detail = (
                f"2-sensor for base {base}: v2(a-1)={minus}, v2(a+1)={plus}; "
                f"one of them is 1, base chart depth {minus + plus}"
            )
        else:
            order = multiplicative_order(base, prime)
            depth = valuation(pow(base, order) - 1, prime)
            sensor = CyclotomicSensor(
                prime=prime, base=base, order=order, depth=depth, plus_depth=None,
                base_chart_depth=depth + 1,
            )
            detail = (
                f"{prime}-sensor for base {base}: ord={order}, "
                f"v{prime}(a^ord-1)={depth}; base chart depth {depth + 1}"
            )
        self.sensors[key] = sensor
        self.formations += 1
        self.life._record("form-sensor", (prime, base, sensor.depth), detail)
        return sensor

    def valuation(self, prime: int, base: int, exponent: int) -> int:
        return self.form(prime, base).valuation(exponent)

    def propose_base(self, limit: int = 200) -> int | None:
        """The least base this organ has not worked that is worth working.

        The bases were handed in from outside for eight increments, exactly as
        the prime was before Theorem 5.  Theorem 13 gives the organ a reason to
        choose: perfect powers are redundant, since `(c^k)^n - 1 = c^(kn) - 1`.
        So it proposes 2, 3, 5, 6, 7, 10, ... and declines 4, 8, 9, 16, 25 with
        the identity that makes each one someone else's encounter.
        """
        for base in range(2, limit + 1):
            if base in self.routed:
                continue
            if base_refusal(base) is None:
                return base
        return None

    def propose_next(self, budget: int = DEFAULT_BUDGET,
                     base_limit: int = 30) -> tuple[int, int] | None:
        """The globally cheapest fresh encounter, over BOTH slots at once.

        `propose_base` and `propose_encounter` each choose within one slot, and
        an organ alternating them naively works each base once and abandons it —
        base 2 alone has about a hundred affordable exponents.  Theorem 15 gives
        the missing rule: order by cost over the whole grid, which is ordering
        by `phi(n) log b`, and the crossover between deepening and widening is
        `widen_crossover(b)`.

        Returns `(base, index)` or None when the grid within `base_limit` is
        exhausted.  The search prunes with Theorem 8's cheap test against the
        best cost so far, so it does not evaluate `Phi` on the whole grid.
        """
        best: tuple[int, int, int] | None = None
        for base in range(2, base_limit + 1):
            if base_refusal(base) is not None:
                continue
            covered = self.routed.get(base, set())
            ceiling = acquisition_horizon(base, budget)
            for index in range(1, ceiling + 1):
                if index in covered:
                    continue
                if certainly_unaffordable(base, index,
                                          budget if best is None else best[0]):
                    continue
                if refusal(base, index, budget) is not None:
                    continue
                cost = scan_cost(base, index)
                if best is not None and cost >= best[0]:
                    continue
                if not fresh_yield(self, base, index)[0]:
                    continue
                best = (cost, base, index)
        return None if best is None else (best[1], best[2])

    def optimality_certificate(self, budget: int = DEFAULT_BUDGET,
                               base_limit: int = 12
                               ) -> tuple[tuple[int, int] | None, int, int]:
        """The next choice, and how much of the grid it is PROVED to beat.

        Returns `(choice, certified, contested)`: the number of candidate
        encounters cheapest-first provably beats whatever their yields are, and
        the number inside the yield window where it might be wrong.  Theorem 16
        bounds the contested set; it never empties, because near-ties always
        exist, and saying so is the point — the organ reports the size of its
        own uncertainty rather than presenting a greedy pick as optimal.
        """
        choice = self.propose_next(budget=budget, base_limit=base_limit)
        if choice is None:
            return None, 0, 0
        cheap_cost = scan_cost(*choice)
        certified = contested = 0
        for base in range(2, base_limit + 1):
            if base_refusal(base) is not None:
                continue
            covered = self.routed.get(base, set())
            for index in range(1, acquisition_horizon(base, budget) + 1):
                if index in covered or (base, index) == choice:
                    continue
                if certainly_unaffordable(base, index, budget):
                    continue
                if refusal(base, index, budget) is not None:
                    continue
                if beats_certainly(cheap_cost, scan_cost(base, index),
                                   base, index):
                    certified += 1
                else:
                    contested += 1
        return choice, certified, contested

    def resolve_and_keep(self, left: tuple[int, int], right: tuple[int, int],
                         budget: int = DEFAULT_BUDGET
                         ) -> ContestedVerdict | None:
        """Decide a near-tie by ROUTING both encounters, keeping every prime.

        `resolve_contested` is a pure function: it factors both primitive parts,
        reads off the yields, and discards the factorizations.  That is paying
        for a factorization and throwing it away.  Theorem 18: a contested
        rival costs less than `Y` times the chosen encounter, so resolving a
        near-tie is within a bounded multiple of doing one encounter — and
        since both encounters are ones the organ wants anyway, the resolution
        is not overhead at all.  Buying the verdict and acquiring the primes
        are the same act, and this method makes them the same call.
        """
        if quote_resolution(left, right) > budget:
            return None
        verdict = resolve_contested(left, right, budget=budget)
        if verdict is None:
            return None
        for base, index in (left, right):
            self.route(base, index, budget=budget)
        return verdict

    def propose_encounter(self, base: int, budget: int = DEFAULT_BUDGET,
                          limit: int | None = None) -> int | None:
        """The least exponent this organ has not covered that is GUARANTEED
        to earn a prime it cannot already hold.

        This is the first operation in the organ that chooses rather than
        answers.  It declines an encounter it can prove worthless — for base 2
        it skips exponent 6, because Phi_6(2) = 3 is exactly the largest prime
        factor of 6, the one classical case where no primitive divisor exists.
        Declining is the point: an organ that cannot refuse cannot choose.

        Two refusals, not one.  Theorem 7 declines encounters where no
        primitive prime EXISTS; Theorem 8 declines those where one exists but
        this organ cannot REACH it inside its budget.  Conflating them is how
        the organ used to promise exponent 61 and deliver nothing.  Returning
        None means the horizon is exhausted, which Theorem 8 proves is a
        finite event.
        """
        covered = self.routed.get(base, set())
        ceiling = limit if limit is not None else acquisition_horizon(base, budget)
        for index in range(1, ceiling + 1):
            if any(done % index == 0 for done in covered):
                continue
            if refusal(base, index, budget) is None:
                return index
        return None

    def propose_fresh_encounter(self, base: int, budget: int = DEFAULT_BUDGET,
                                limit: int | None = None) -> int | None:
        """Like `propose_encounter`, but across ALL bases this organ has worked.

        `propose_encounter` guarantees a prime primitive for THIS base, which
        may still be one the organ already earned from another base — the
        acquisition guarantee was per base for six increments.  Theorem 11
        closes that: divide out the held primitive primes and the exceptional
        prime, and what survives is unheld primitive part.  Decided without
        factoring anything.
        """
        covered = self.routed.get(base, set())
        ceiling = limit if limit is not None else acquisition_horizon(base, budget)
        for index in range(1, ceiling + 1):
            if any(done % index == 0 for done in covered):
                continue
            if refusal(base, index, budget) is not None:
                continue
            if fresh_yield(self, base, index)[0]:
                return index
        return None

    def route(self, base: int, exponent: int,
              budget: int = DEFAULT_BUDGET) -> RoutedFactorization:
        """Factor `base^exponent - 1` through its cyclotomic pieces and keep
        every prime it names as an earned residue sensor.

        This closes the loop the two organs had left open.  `arithmetic_life`
        accumulates prime sensors by grinding upward through trial division;
        the cyclotomic route reaches primes far beyond that grind and installs
        them.  Since `form` is gated on an earned mod-p sense, a prime earned
        here immediately makes the whole infinite family `v_p(a^n - 1)`
        askable, where a moment earlier the organ refused the question.
        """
        result = factor_power_minus_one(base, exponent, budget=budget)
        covered = self.routed.setdefault(base, set())
        covered.update(d for d in range(1, exponent + 1) if exponent % d == 0)
        for prime, _power in result.factors:
            self.life.install_residue_sensor(prime, (base, exponent))
        self.life._record(
            "route-factor", (base, exponent, len(result.factors)),
            f"{base}^{exponent}-1 routed through Phi_m for m | {exponent}; "
            f"scan bound {result.blind_scan_bound} -> {result.routed_scan_bound} "
            f"in {result.candidates_tried} trial divisions; "
            "each named prime is now an earned sensor",
        )
        return result


def _divisors(n: int) -> tuple[int, ...]:
    return tuple(d for d in range(1, n + 1) if n % d == 0)


def _mobius(n: int) -> int:
    sign, remaining, candidate = 1, n, 2
    while candidate * candidate <= remaining:
        if remaining % candidate == 0:
            remaining //= candidate
            if remaining % candidate == 0:
                return 0
            sign = -sign
        candidate += 1
    return -sign if remaining > 1 else sign


def cyclotomic_value(index: int, base: int) -> int:
    """Exact integer Phi_index(base) by the Mobius product over divisors."""
    numerator, denominator = 1, 1
    for divisor in _divisors(index):
        sign = _mobius(index // divisor)
        if sign == 1:
            numerator *= base ** divisor - 1
        elif sign == -1:
            denominator *= base ** divisor - 1
    if numerator % denominator:
        raise AssertionError("the cyclotomic Mobius product failed to be integral")
    return numerator // denominator


def head_length(prime: int) -> int:
    """Least k with the unit filtration 1 + p^k Z_p torsion-free.

    Equal to the head length of every cyclotomic sensor at this prime; it
    depends on p alone.  Over Q_p the torsion threshold is k > 1/(p-1), so
    this is 1 at odd primes and 2 at p = 2, where -1 sits in U_1 with finite
    order.  See `notes/CYCLOTOMIC_SENSOR.md` Theorem 4.
    """
    return 1 // (prime - 1) + 1


def shifts_by_one(prime: int, unit: int, depth: int) -> bool:
    """Does v_p(x^p - 1) = v_p(x - 1) + 1 for this unit at this depth?

    True exactly when depth >= head_length(prime).  At p = 2, depth 1 the
    witness of failure is x = -1 itself, whose square leaves the filtration.
    """
    if valuation(unit - 1, prime) != depth:
        raise ValueError("unit is not at the stated filtration depth")
    return valuation(unit ** prime - 1, prime) == depth + 1


def chain_head(sensor: CyclotomicSensor) -> tuple[int, ...]:
    """The finite nonconstant prefix of the valuation along the p-chain.

    Length 1 at odd primes, length 2 at p=2.  Every later chain entry is 1.
    """
    if sensor.prime == 2:
        assert sensor.plus_depth is not None
        return (sensor.depth, sensor.plus_depth)
    return (sensor.depth,)


def cyclotomic_valuation(sensor: CyclotomicSensor, index: int) -> int:
    """v_p(Phi_index(a)) read off the chain, with no polynomial evaluated.

    The p-valuation is supported on the single chain d, dp, dp^2, ... where
    d = ord_p(a) (and d = 1 at p = 2).  Along that chain it is the head
    vector followed by the constant 1; everywhere else it is zero.
    """
    if index < 1:
        raise ValueError("cyclotomic index must be positive")
    chain_base = 1 if sensor.prime == 2 else sensor.order
    if index % chain_base:
        return 0
    quotient, steps = index // chain_base, 0
    while quotient % sensor.prime == 0:
        quotient //= sensor.prime
        steps += 1
    if quotient != 1:
        return 0
    head = chain_head(sensor)
    return head[steps] if steps < len(head) else 1


@dataclass(frozen=True)
class CyclotomicFactorization:
    index: int
    base: int
    value: int
    factors: tuple[tuple[int, int], ...]
    cofactor: int
    complete: bool
    exceptional: int | None
    progression: int
    candidates_tried: int
    naive_candidates: int | None

    def reconstruct(self) -> int:
        return self.cofactor * prod(p ** power for p, power in self.factors)


def search_progression(index: int) -> tuple[int, int | None]:
    """The candidate law for prime divisors of Phi_index(a), read off the chain.

    Returns `(step, exceptional)`: every prime divisor of `Phi_index(a)` is
    either congruent to 1 modulo `step`, or equal to `exceptional`, the largest
    prime factor of `index`.  See `notes/CYCLOTOMIC_SENSOR.md` Theorem 5.
    The law is vacuous for `index <= 2`, where `step` is 1.
    """
    if index < 1:
        raise ValueError("cyclotomic index must be positive")
    if index <= 2:
        return 1, (index if index == 2 else None)
    exceptional = max(prime for prime, _ in _factor_small(index))
    # A primitive prime has ord_p(a) = index, so index | p-1.  For odd index
    # the prime is odd too, so 2 | p-1 as well and the two are coprime.
    step = 2 * index if index % 2 else index
    return step, exceptional


def largest_prime_factor(n: int) -> int | None:
    """Largest prime factor of n, or None for n = 1."""
    if n < 1:
        raise ValueError("need n >= 1")
    return max(p for p, _ in _factor_small(n)) if n > 1 else None


def has_primitive_divisor(base: int, index: int) -> bool:
    """Will encountering Phi_index(base) earn a prime we cannot already have?

    A *primitive* prime divisor is one with ord_p(base) = index; it therefore
    divides no base^k - 1 for k < index, so it is new relative to every earlier
    encounter with this base.  Theorem 7 in `notes/CYCLOTOMIC_SENSOR.md`: by
    Theorem 5 every divisor is primitive or is the largest prime factor P of
    index, appearing to power one, so a primitive divisor is absent exactly
    when Phi_index(base) is 1 or P.  The carve-out is index = 2, where
    Phi_2(a) = a+1 may be any power of 2.

    This decides the question WITHOUT factoring Phi_index(base) — one
    comparison against a number no larger than `index`.
    """
    if base < 2 or index < 1:
        raise ValueError("need base >= 2 and index >= 1")
    value = abs(cyclotomic_value(index, base))
    if index == 1:
        return value > 1                      # fails only for base = 2
    if index == 2:
        return value & (value - 1) != 0       # fails iff base+1 is 2^k
    return value not in (1, largest_prime_factor(index))


def totient(n: int) -> int:
    """Euler's totient, from the exact factorization of n."""
    if n < 1:
        raise ValueError("need n >= 1")
    if n == 1:
        return 1
    result = n
    for prime, _power in _factor_small(n):
        result = result // prime * (prime - 1)
    return result


def scan_cost(base: int, index: int) -> int:
    """Candidates the guided scan needs in the WORST case for this encounter.

    The worst case is `Phi_index(base)` prime, when the scan must reach
    sqrt(Phi) inside the progression.  This is a guarantee, not a prediction:
    an encounter passing it always completes, while one failing it may still
    complete by luck if a small factor turns up early.
    """
    value = abs(cyclotomic_value(index, base))
    if value <= 1:
        return 1
    step, exceptional = search_progression(index)
    return isqrt(value) // max(step, 1) + (1 if exceptional else 0) + 1


def certainly_unaffordable(base: int, index: int,
                           budget: int = DEFAULT_BUDGET) -> bool:
    """Theorem 8's cheap necessary condition, decided from phi(index) alone.

    Affordability forces `a^(phi(n)/2)/sqrt(8) <= 2 n B`, i.e.
    `phi(n) log a <= 2 log(6 n B)`.  Checking this before evaluating
    `Phi_index(base)` keeps the horizon search from costing more than the
    encounters it is deciding about.
    """
    from math import log
    return (totient(index) * log(base)
            > 2.0 * log(6.0 * index * max(budget, 1)))


def affordable(base: int, index: int, budget: int = DEFAULT_BUDGET) -> bool:
    """Can this organ actually DELIVER on the encounter, not merely want it?"""
    if certainly_unaffordable(base, index, budget):
        return False
    return scan_cost(base, index) <= budget


def acquisition_horizon(base: int, budget: int = DEFAULT_BUDGET) -> int:
    """Least N beyond which NO encounter is affordable — the organ's horizon.

    Theorem 8 in `notes/CYCLOTOMIC_SENSOR.md`.  Affordability forces
    `a^(phi(n)/2) / sqrt(8) <= 2 n B`, i.e. `phi(n) log a <= 2 log(6 n B)`,
    and `phi(n) >= sqrt(n)` for `n > 6`, so `sqrt(n) log a <= 2 log(6 n B)`.
    The left side eventually dominates, so the affordable set is finite and
    this search terminates with a proof rather than at an arbitrary cutoff.
    """
    from math import log
    scale = log(base)
    turning = int((4.0 / scale) ** 2) + 1      # beyond here the gap increases
    index = max(turning, 7)
    while index * scale * scale <= 4.0 * log(6.0 * index * max(budget, 1)) ** 2:
        index += 1
    return index


# zeta(2) zeta(3) / zeta(6), the classical density of totient values:
# #{n : phi(n) <= x} ~ TOTIENT_DENSITY * x.  Consumed, not derived here.
TOTIENT_DENSITY = 1.9435964368


def growth_rate(base: int) -> float:
    """Reachable exponents gained per unit increase in log(budget).

    Theorem 9 in `notes/CYCLOTOMIC_SENSOR.md`: the affordable set is
    `{n : phi(n) <= x_B}` with `x_B ~ 2 log B / log a`, and totient values
    have density `zeta(2)zeta(3)/zeta(6)`, so the count grows like
    `2A log B / log a`.  Derived; the executable checks it, never fits it.
    """
    from math import log
    return 2.0 * TOTIENT_DENSITY / log(base)


def budget_factor_per_exponent(base: int) -> float:
    """Multiplicative budget cost of ONE more reachable exponent.

    Inverting Theorem 9: `B = a^(k / 2A)`, so each additional exponent costs a
    fixed factor `a^(1/2A)` — about 1.195 at base 2.  The organ's world grows
    logarithmically in what it can spend, which is the honest reading of the
    horizon: acquisitions are exponentially expensive in their count.
    """
    return base ** (1.0 / (2.0 * TOTIENT_DENSITY))


def next_budget_step(base: int,
                     budget: int = DEFAULT_BUDGET) -> tuple[int, int] | None:
    """The exact budget that buys one more encounter, and which one.

    Returns `(cost, index)` for the cheapest currently-unreachable encounter.
    Theorem 9's rate is asymptotic and smooth; a particular organ's experience
    is a staircase, and this is the height of the next stair.  At base 2 with
    B = 200000 the answer is 516928 for index 106 — so doubling the budget
    buys nothing, and the honest advice is "2.58x, and you get exponent 106".

    The search ceiling is justified rather than chosen: any encounter costing
    at most C has `phi(n) log a <= 2 log(6 n C)`, so it lies below
    `acquisition_horizon(base, C)`.  We search below the horizon for `B^2`,
    then check the answer's own horizon fits inside that.
    """
    ceiling = acquisition_horizon(base, max(budget, 2) ** 2)
    best: tuple[int, int] | None = None
    for index in range(1, ceiling + 1):
        if affordable(base, index, budget):
            continue
        # Theorem 8's cheap test also prunes the search: an index unaffordable
        # even at the best cost so far cannot beat it, and deciding that from
        # phi alone avoids evaluating Phi_index(base).
        if best is not None and certainly_unaffordable(base, index, best[0]):
            continue
        cost = scan_cost(base, index)
        if best is None or cost < best[0]:
            best = (cost, index)
    if best is None:
        return None
    if acquisition_horizon(base, best[0]) > ceiling:
        raise AssertionError("search ceiling did not contain its own answer")
    return best


def order_composition_witness(prime: int) -> tuple[int, int, int, int] | None:
    """Two base pairs with identical order pairs but different order of product.

    Theorem 10 in `notes/CYCLOTOMIC_SENSOR.md`: the sensor at `prime` for base
    `a*b` is NOT a function of the sensors for `a` and `b`.  Returns
    `(a, b, c, d)` with `ord(a) = ord(c)`, `ord(b) = ord(d)`, and
    `ord(a*b) != ord(c*d)`.  This is the obstruction five successor lists have
    pointed at, and it is a clean no-go rather than a gap.
    """
    residues = range(1, prime)
    orders = {r: multiplicative_order(r, prime) for r in residues}
    seen: dict[tuple[int, int], tuple[int, int, int]] = {}
    for left in residues:
        for right in residues:
            key = (orders[left], orders[right])
            product_order = orders[left * right % prime]
            if key in seen:
                other_left, other_right, other_order = seen[key]
                if other_order != product_order:
                    return (left, right, other_left, other_right)
            else:
                seen[key] = (left, right, product_order)
    return None


def held_at(organ: "CyclotomicOrgan", base: int,
            index: int) -> tuple[int, ...]:
    """Primes this organ already holds that encounter `(base, index)` re-delivers.

    A held prime `p` is a primitive divisor of `Phi_index(base)` exactly when
    `ord_p(base) = index`.  The organ holds `p`, so computing that order is
    cheap — no factorization of `Phi_index(base)` is involved.  This is the
    transport of the organ's history into a new base's exponent coordinates.
    """
    return tuple(sorted(
        prime for prime in organ.life.moduli
        if base % prime and multiplicative_order(base, prime) == index
    ))


def fresh_yield(organ: "CyclotomicOrgan", base: int,
                index: int) -> tuple[bool, int, tuple[int, ...]]:
    """Does `(base, index)` deliver a prime this organ does NOT already hold?

    Theorem 11.  Divide out the held primitive primes to their exact chain
    powers; by Theorem 5 every surviving prime is either primitive-and-unheld
    or the exceptional prime, so stripping the exceptional prime leaves exactly
    the unheld primitive part.  Returns `(is_fresh, residual, held_primes)`.

    Decided without factoring `Phi_index(base)`: the held primes are known and
    their exponents come from their own sensors.
    """
    value = abs(cyclotomic_value(index, base))
    held = held_at(organ, base, index)
    residual = value
    for prime in held:
        sensor = organ.form(prime, base)
        power = cyclotomic_valuation(sensor, index)
        residual //= prime ** power
    _step, exceptional = search_progression(index)
    if exceptional is not None:
        while residual % exceptional == 0:
            residual //= exceptional
    return residual > 1, residual, held


def perfect_power(base: int) -> tuple[int, int] | None:
    """Write `base = root ** power` with `power >= 2` maximal, or None.

    Exact: the root is found by integer bisection, never by floating point.
    A float guess with a three-point correction would be fast and would fail
    silently on large bases if the guess ever landed more than one away; the
    failure direction is a MISSED refusal, which is safe and invisible, so the
    search is done in integers instead.
    """
    if base < 2:
        return None
    best: tuple[int, int] | None = None
    exponent = 2
    while 2 ** exponent <= base:
        low, high = 2, base
        while low <= high:                      # integer bisection for the root
            middle = (low + high) // 2
            power = middle ** exponent
            if power == base:
                best = (middle, exponent)
                break
            if power < base:
                low = middle + 1
            else:
                high = middle - 1
        exponent += 1
    return best


def base_refusal(base: int) -> str | None:
    """Why an organ choosing its own repertoire declines this base.

    Theorem 13: `(c^k)^n - 1 = c^(kn) - 1`, so a perfect-power base generates
    no integer the root does not already generate.  This is the very first move
    of `ARITHMETIC_LIFE_FIRST_EXECUTION` — a composite modulus `d = ab` adds no
    test because `d | n` implies `a | n` — recurring one level up, on bases
    rather than moduli.
    """
    if base < 2:
        return "a base must be at least 2"
    power = perfect_power(base)
    if power is not None:
        root, exponent = power
        return (f"{base} = {root}^{exponent}, and ({root}^{exponent})^n - 1 = "
                f"{root}^({exponent}n) - 1: every encounter here is a base-"
                f"{root} encounter at {exponent} times the exponent "
                "(Theorem 13)")
    return None


def yield_bound(base: int, index: int) -> int:
    """Most primitive prime divisors `Phi_index(base)` can possibly have.

    Every primitive prime satisfies `ord_p(base) = index`, so `index | p - 1`
    and `p >= index + 1`; and `Phi_index(base) <= (base+1)^phi(index)`.  So
    `k` distinct primitive primes force `(index+1)^k <= (base+1)^phi(index)`.
    Theorem 16.  This is what makes the yield *polylogarithmic* in the cost
    while the cost itself is exponential — which is why cheapest-first can only
    be wrong locally.
    """
    from math import log
    if base < 2 or index < 1:
        raise ValueError("need base >= 2 and index >= 1")
    return max(int(totient(index) * log(base + 1) / log(index + 1)), 1)


def beats_certainly(cheap_cost: int, rival_cost: int, rival_base: int,
                    rival_index: int) -> bool:
    """Is the cheaper encounter optimal against this rival whatever the yields?

    A yield-aware ordering prefers the rival only if
    `yield(rival)/yield(cheap) > cost(rival)/cost(cheap)`.  Zsigmondy gives
    `yield(cheap) >= 1` and Theorem 16 gives `yield(rival) <= yield_bound`, so
    the rival can win only when `cost(rival) < yield_bound * cost(cheap)`.
    Outside that window cheapest-first is certified, with no knowledge of the
    actual yields and no factoring.
    """
    return rival_cost >= yield_bound(rival_base, rival_index) * cheap_cost


@dataclass(frozen=True)
class YieldBracket:
    """Bounds on the yield after a partial scan, with the effort spent."""

    low: int
    high: int
    spent: int
    reached: int
    found: tuple[int, ...]
    cofactor: int

    @property
    def exact(self) -> bool:
        return self.low == self.high


def partial_bracket(base: int, index: int, effort: int) -> YieldBracket:
    """Bracket the yield after scanning `effort` candidates of the progression.

    This is the loophole R0038's no-go leaves open, and closing it needs data
    that is not `(base, index)` alone.  After scanning the progression up to
    limit `L`, every surviving prime factor of the cofactor `R` is primitive
    (the exceptional prime having been stripped) and exceeds `L`.  Hence

        low  = k + [R > 1],
        high = k + max{ j : L^j < R },

    with `k` the primitive primes already found.  Both bounds tighten as the
    scan proceeds, and they meet when `R` is 1 or is known prime because
    `L^2 >= R`.  All integer arithmetic; no logarithm is trusted.
    """
    if effort < 0:
        raise ValueError("effort must be non-negative")
    value = abs(cyclotomic_value(index, base))
    step, exceptional = search_progression(index)
    remaining, found, spent = value, [], 0
    if exceptional is not None:
        spent += 1
        while remaining % exceptional == 0:
            remaining //= exceptional
    candidate = 1 + step if step > 1 else 2
    while spent < effort and candidate * candidate <= remaining:
        spent += 1
        if remaining % candidate == 0:
            found.append(candidate)
            while remaining % candidate == 0:
                remaining //= candidate
        candidate += step if step > 1 else 1
    reached = candidate - (step if step > 1 else 1)
    # The loop exits either because the effort ran out or because the next
    # candidate already exceeds sqrt(remaining).  In the second case every
    # progression candidate below that root was tested, so `remaining` has no
    # prime factor at or below its own square root and is therefore prime —
    # even when zero candidates were tested, which the earlier `reached`-based
    # test could not see.
    exhausted = candidate * candidate > remaining
    survivors = 0
    if remaining > 1:
        # Surviving primes exceed the last tested candidate, and in any case
        # are at least index+1 by R0027.  With no candidate tested the second
        # floor is the only one available, which is why `reached` alone would
        # report a spurious exact bracket at zero effort.
        floor_prime = max(reached, index)
        if exhausted:
            survivors = 1          # cofactor is prime: nothing below its root
        else:
            survivors = 1
            while floor_prime ** (survivors + 1) < remaining:
                survivors += 1
    low = len(found) + (1 if remaining > 1 else 0)
    return YieldBracket(low=low, high=len(found) + survivors, spent=spent,
                        reached=max(reached, 1), found=tuple(found),
                        cofactor=remaining)


def certify_with_effort(left: tuple[int, int], right: tuple[int, int],
                        effort: int) -> bool:
    """Does a partial scan of this size already decide the near-tie?

    The comparison `cost_1/Y_1 <= cost_2/Y_2` is settled for every admissible
    pair of yields as soon as `cost_1/low_1 <= cost_2/high_2`.  R0037 used the
    a priori pair `(1, yield_bound)`; the bracket improves both ends at a
    fraction of the full resolution price.
    """
    left_bracket = partial_bracket(*left, effort=effort)
    right_bracket = partial_bracket(*right, effort=effort)
    return (scan_cost(*left) / max(left_bracket.low, 1)
            <= scan_cost(*right) / max(right_bracket.high, 1))


def least_deciding_effort(left: tuple[int, int], right: tuple[int, int],
                          ceiling: int | None = None) -> int | None:
    """The smallest effort at which the comparison is settled, or None.

    Theorem 20.  Exactness of a single bracket is no cheaper than the scan
    itself — both need `max(L,n)^2 >= R` — so the bracket cannot tell the organ
    a yield cheaply.  But a *comparison* needs only that the ratio of bounds
    fall the right way, not that either bound be tight, and that happens far
    earlier.  Measured over contested pairs: 83% decided in under half the full
    resolution price, median effort zero.

    The organ never needs to know a yield.  It needs to decide an order, and
    deciding is the cheaper question.
    """
    limit = ceiling if ceiling is not None else quote_resolution(left, right)
    if not certify_with_effort(left, right, effort=limit):
        return None
    low, high = 0, limit
    while low < high:
        middle = (low + high) // 2
        if certify_with_effort(left, right, effort=middle):
            high = middle
        else:
            low = middle + 1
    return low


def actual_yield(base: int, index: int,
                 budget: int = DEFAULT_BUDGET) -> int | None:
    """The true number of primitive prime divisors, by paying for the scan.

    None when the scan does not complete inside `budget`.  This is the only way
    to learn the yield: Theorem 17 says no bound on `(base, index)` can give it,
    because Zsigmondy's lower bound of one is sharp — `Phi_17(2) = 131071` is
    prime, so its yield is exactly one while `yield_bound` allows six.
    """
    found = factor_cyclotomic(index, base, budget=budget, compare=False)
    if not found.complete:
        return None
    return sum(1 for prime, _power in found.factors
               if base % prime and multiplicative_order(base, prime) == index)


@dataclass(frozen=True)
class ContestedVerdict:
    """A near-tie decided by paying for it, with the price stated."""

    winner: tuple[int, int]
    loser: tuple[int, int]
    winner_yield: int
    loser_yield: int
    price: int

    def describe(self) -> str:
        return (f"{self.winner} beats {self.loser}: yields "
                f"{self.winner_yield} vs {self.loser_yield}, "
                f"price {self.price} trial divisions")


def quote_resolution(left: tuple[int, int], right: tuple[int, int]) -> int:
    """What deciding this near-tie would cost, quoted BEFORE paying."""
    return scan_cost(*left) + scan_cost(*right)


def resolve_contested(left: tuple[int, int], right: tuple[int, int],
                      budget: int = DEFAULT_BUDGET) -> ContestedVerdict | None:
    """Decide a contested pair by cost per prime obtained, or decline.

    Theorem 17: the contested window of Theorem 16 cannot be narrowed by any
    argument from `(base, index)` alone, because the yield lower bound is sharp.
    So the organ cannot *derive* the verdict — but it can *buy* it, and the
    price is quotable in advance.  Returns None when the quote exceeds the
    budget, which is a refusal about affordability and not about existence.
    """
    if quote_resolution(left, right) > budget:
        return None
    left_yield = actual_yield(*left, budget=budget)
    right_yield = actual_yield(*right, budget=budget)
    if left_yield is None or right_yield is None:
        return None
    left_rate = scan_cost(*left) / left_yield
    right_rate = scan_cost(*right) / right_yield
    winner, loser = ((left, right) if left_rate <= right_rate
                     else (right, left))
    return ContestedVerdict(
        winner=winner, loser=loser,
        winner_yield=left_yield if winner is left else right_yield,
        loser_yield=right_yield if winner is left else left_yield,
        price=quote_resolution(left, right),
    )


def interleaving_weight(base: int, index: int) -> float:
    """The single scalar that orders encounters across BOTH slots.

    From the R0030 lemma, `log cost(b,n) = (phi(n)/2) log b - log step(n) + O(1)`
    with the error an absolute constant, so cheapest-first over the whole grid
    is ordering by `phi(n) log b - 2 log step(n)`.  Theorem 15.
    """
    from math import log
    step, _exceptional = search_progression(index)
    return totient(index) * log(base) - 2.0 * log(max(step, 1) * 2)


def widen_crossover(base: int) -> float:
    """The totient past which going deeper beats moving to the next base.

    Two moves from `(b, n)`: raising `phi` by 2 multiplies the cost by `b`,
    while raising the base by 1 multiplies it by `((b+1)/b)^(phi/2)`.  They are
    equal at `phi = 2 log b / log(1 + 1/b)`, about 3.42 at base 2 and growing
    like `2 b log b`.  Below it, widen; above it, deepen.  An organ that works
    one encounter per base has the rule exactly backwards.
    """
    from math import log
    return 2.0 * log(base) / log(1.0 + 1.0 / base)


def exponent_redundancy_witness(base: int, index: int,
                                budget: int = DEFAULT_BUDGET) -> int | None:
    """A prime of `Phi_index(base)` dividing no `base^m - 1` with `m < index`.

    Such a prime is a *witness that the exponent is not redundant*: the
    encounter at `index` earns something no smaller exponent could.  Theorem 14
    in `notes/CYCLOTOMIC_SENSOR.md`.

    This is the constructive form of `has_primitive_divisor`, which decides the
    same question as a boolean without factoring.  Deciding is cheap; exhibiting
    costs a scan, so this returns None both when no witness exists and when the
    scan cannot afford to find one — the caller should consult
    `has_primitive_divisor` to tell those apart, and the two are kept separate
    for the same reason Theorems 7 and 8 are.
    """
    if not has_primitive_divisor(base, index):
        return None
    found = factor_cyclotomic(index, base, budget=budget, compare=False)
    for prime, _power in found.factors:
        if base % prime and multiplicative_order(base, prime) == index:
            return prime
    return None


def interface_report() -> tuple[tuple[str, str, str, bool, str], ...]:
    """What this organ takes in, and whether each slot can be pruned.

    Theorem 14.  The three slots differ exactly in whether the refinement
    quotient is trivial, and the exponent slot is where it stops being trivial —
    which is Zsigmondy, the deepest input this lane consumes.
    """
    return (
        ("modulus", "multiplication", "primes", True,
         "ARITHMETIC_LIFE_FIRST_EXECUTION eq (3): mod-ab factors through mod-a"),
        ("base", "exponentiation", "non-powers", True,
         "Theorem 13: (c^k)^n - 1 = c^(kn) - 1, a reindexing with no new objects"),
        ("exponent", "multiplication", "all of them", False,
         "Theorem 14: b^n - 1 = (b^m - 1) Q with Phi_n(b) | Q, and Phi_n(b) has "
         "a primitive prime outside the classical exception list"),
    )


@dataclass(frozen=True)
class TargetRoute:
    """The cheapest encounter over a fixed repertoire that yields a named prime."""

    prime: int
    base: int
    index: int
    cost: int
    primitive: bool

    def describe(self) -> str:
        kind = "primitive" if self.primitive else "exceptional"
        return (f"{self.prime} via base {self.base}, exponent {self.index} "
                f"({kind}), {self.cost} trial divisions")


def target(prime: int, bases: tuple[int, ...],
           budget: int = DEFAULT_BUDGET) -> TargetRoute | None:
    """The cheapest affordable encounter over `bases` that earns `prime`.

    Two routes exist and both are considered.  `prime` divides `Phi_n(b)`
    either primitively, forcing `n = ord_prime(b)`, or exceptionally, forcing
    `prime` to be the largest prime factor of `n`, so `n = ord_prime(b) *
    prime^s` with `s >= 1`.  Since `phi(d p^s)` is strictly increasing in `s`,
    the cheapest exceptional route is `s = 1`, and only that one is tried.

    Returns None when no route over this repertoire fits the budget — which by
    Theorem 12 is exactly when exhaustive routing would also miss it.  The base
    matters enormously: `ord_1093(2) = 364` puts 1093 out of reach forever,
    while `ord_1093(3) = 7` earns it in four trial divisions.
    """
    if prime < 2:
        raise ValueError("target needs a prime")
    best: TargetRoute | None = None
    for base in bases:
        if base < 2 or base % prime == 0:
            continue
        order = multiplicative_order(base, prime)
        index, primitive = order, True
        while not certainly_unaffordable(base, index, budget):
            cost = scan_cost(base, index)
            if cost <= budget and (best is None or cost < best.cost):
                best = TargetRoute(prime, base, index, cost, primitive)
            index, primitive = index * prime, False
    return best


def refusal(base: int, index: int,
            budget: int = DEFAULT_BUDGET) -> str | None:
    """Why this organ declines the encounter, or None if it accepts.

    A refusal an organ can state is worth more than one it merely performs:
    each of these is licensed by a theorem, not by a missing precondition.
    """
    if certainly_unaffordable(base, index, budget):
        return (f"phi({index}) = {totient(index)} is too large: Theorem 8's "
                f"bound phi(n) log a <= 2 log(6 n B) already fails, so no "
                f"scan of Phi_{index}({base}) fits in {budget}")
    if not has_primitive_divisor(base, index):
        value = abs(cyclotomic_value(index, base))
        largest = largest_prime_factor(index)
        if index == 1:
            return f"Phi_1({base}) = {value}: no prime at all (Theorem 7)"
        if index == 2:
            return (f"Phi_2({base}) = {value} is a power of 2, the only prime "
                    "available is the exceptional one (Theorem 7)")
        return (f"Phi_{index}({base}) = {value} = the largest prime factor of "
                f"{index}, which is {largest}: every prime here is the "
                "exceptional one, so nothing is primitive (Theorem 7)")
    cost = scan_cost(base, index)
    if cost > budget:
        return (f"a primitive prime exists but is not reachable: the guided "
                f"scan needs up to {cost} trial divisions, budget is {budget} "
                "(Theorem 8)")
    return None


def permits(index: int, prime: int) -> bool:
    """May `prime` divide Phi_index(a) for some base a?  Theorem 5.

    At `index <= 2` the progression degenerates to `step = 1`, which carries no
    congruence information, so every prime is permitted.  Keeping that reading
    here rather than in each caller is deliberate: `prime % 1 == 1` is never
    true, and a caller open-coding the test would silently exclude everything.
    """
    step, exceptional = search_progression(index)
    if prime == exceptional:
        return True
    return step == 1 or prime % step == 1


def naive_trial_division(
    n: int, budget: int = DEFAULT_BUDGET
) -> tuple[tuple[tuple[int, int], ...], int, int, bool]:
    """The same algorithm with no chart: 2, then every odd number ascending.

    Returned alongside the chart-guided count so the comparison is
    apples-to-apples — both divide out factors as they are found, so the
    difference between the two counts is the progression and nothing else.
    """
    remaining, factors, tried = n, [], 0
    tried += 1
    power = 0
    while remaining % 2 == 0:
        remaining //= 2
        power += 1
    if power:
        factors.append((2, power))
    candidate = 3
    while candidate * candidate <= remaining:
        if tried >= budget:
            return tuple(sorted(factors)), tried, remaining, False
        tried += 1
        if remaining % candidate == 0:
            power = 0
            while remaining % candidate == 0:
                remaining //= candidate
                power += 1
            factors.append((candidate, power))
        candidate += 2
    if remaining > 1:
        factors.append((remaining, 1))
    return tuple(sorted(factors)), tried, 1, True


def factor_cyclotomic(
    index: int, base: int, budget: int = DEFAULT_BUDGET, compare: bool = True
) -> CyclotomicFactorization:
    """Factor Phi_index(base) by searching only the primes the chart permits.

    Trial division restricted to the arithmetic progression `1 mod step`,
    preceded by the single exceptional prime.  Correct because after the
    exceptional prime is divided out, every surviving prime divisor is
    primitive, so the least divisor encountered in ascending order is prime.
    """
    value = cyclotomic_value(index, base)
    step, exceptional = search_progression(index)
    remaining, factors, tried, complete = abs(value), [], 0, True
    if exceptional is not None:
        tried += 1
        power = 0
        while remaining % exceptional == 0:
            remaining //= exceptional
            power += 1
        if power:
            factors.append((exceptional, power))
    candidate = 1 + step if step > 1 else 2
    while candidate * candidate <= remaining:
        if tried >= budget:
            complete = False
            break
        tried += 1
        if remaining % candidate == 0:
            power = 0
            while remaining % candidate == 0:
                remaining //= candidate
                power += 1
            factors.append((candidate, power))
        candidate += step if step > 1 else 1
    if complete and remaining > 1:
        factors.append((remaining, 1))
        remaining = 1
    naive_count: int | None = None
    if compare:
        naive_factors, naive_count, naive_cofactor, naive_done = (
            naive_trial_division(abs(value), budget)
        )
        if naive_done and complete and naive_factors != tuple(sorted(factors)):
            raise AssertionError("chart-guided and naive factorizations disagree")
        if not naive_done:
            naive_count = None
    result = CyclotomicFactorization(
        index=index, base=base, value=value,
        factors=tuple(sorted(factors)),
        cofactor=remaining if not complete else 1,
        complete=complete,
        exceptional=exceptional, progression=step,
        candidates_tried=tried, naive_candidates=naive_count,
    )
    if result.reconstruct() != abs(value):
        raise AssertionError("chart-guided factorization failed to reconstruct")
    return result


@dataclass(frozen=True)
class RoutedFactorization:
    """`a^n - 1` factored through its cyclotomic pieces rather than head-on."""

    base: int
    exponent: int
    value: int
    factors: tuple[tuple[int, int], ...]
    cofactor: int
    complete: bool
    pieces: tuple[CyclotomicFactorization, ...]
    candidates_tried: int
    blind_scan_bound: int
    routed_scan_bound: int

    def reconstruct(self) -> int:
        return self.cofactor * prod(p ** power for p, power in self.factors)


def factor_power_minus_one(
    base: int, exponent: int, budget: int = DEFAULT_BUDGET
) -> RoutedFactorization:
    """Factor `base^exponent - 1` by routing through Phi_m for each m | exponent.

    Two independent gains over scanning the integer head-on, both derivable and
    neither a heuristic (`notes/CYCLOTOMIC_SENSOR.md` Theorem 6):

    1. degree — each piece has size about `base^phi(m)`, and `phi(m) <= phi(n)`
       for every `m | n`, so the deepest candidate examined falls from
       `base^(n/2)` to about `base^(phi(n)/2)`;
    2. congruence — inside each piece Theorem 5 restricts the scan to one
       residue class, dividing the candidate count by a further `m`.

    The first gain is exponential in `n - phi(n)`, so the route helps exactly
    when the exponent is composite, and by an amount that is computed, not
    hoped for.
    """
    if base < 2 or exponent < 1:
        raise ValueError("need base >= 2 and exponent >= 1")
    value = base ** exponent - 1
    merged: dict[int, int] = {}
    pieces, tried, cofactor, complete = [], 0, 1, True
    for index in _divisors(exponent):
        piece = factor_cyclotomic(index, base, budget=budget, compare=False)
        pieces.append(piece)
        tried += piece.candidates_tried
        for prime, power in piece.factors:
            merged[prime] = merged.get(prime, 0) + power
        if not piece.complete:
            complete = False
            cofactor *= piece.cofactor
    result = RoutedFactorization(
        base=base, exponent=exponent, value=value,
        factors=tuple(sorted(merged.items())), cofactor=cofactor,
        complete=complete, pieces=tuple(pieces), candidates_tried=tried,
        blind_scan_bound=isqrt(value),
        routed_scan_bound=max(isqrt(abs(p.value)) for p in pieces),
    )
    if result.reconstruct() != value:
        raise AssertionError("routed factorization failed to reconstruct")
    return result


def minimality_witness(sensor: CyclotomicSensor) -> tuple[int, int, int]:
    """A base sharing every digit below the sensor's chart depth, but not the sensor.

    Returns `(other_base, exponent, other_valuation)` where `other_base` agrees
    with `sensor.base` modulo `p^(base_chart_depth - 1)` yet gives a different
    valuation at `exponent`.  This certifies that no coarser chart of the base
    determines the family.
    """
    p, a, k = sensor.prime, sensor.base, sensor.base_chart_depth
    coarse = p ** (k - 1)
    if p == 2:
        assert sensor.plus_depth is not None
        exponent = 2
        for step in range(1, 2 * p + 2):
            other = a + step * coarse
            if other % 2 == 0:
                continue
            other_valuation = (
                valuation(other - 1, 2) + valuation(other + 1, 2)
                + valuation(exponent, 2) - 1
            )
            if other_valuation != sensor.valuation(exponent):
                return other, exponent, other_valuation
        raise AssertionError("no 2-adic minimality witness found")
    exponent = sensor.order
    for step in range(1, p + 1):
        other = a + step * coarse
        if other % p == 0:
            continue
        if multiplicative_order(other, p) != sensor.order:
            continue
        other_valuation = valuation(pow(other, exponent) - 1, p)
        if other_valuation != sensor.valuation(exponent):
            return other, exponent, other_valuation
    raise AssertionError("no minimality witness found")


def main() -> None:
    life = ArithmeticLife()
    organ = CyclotomicOrgan(life)

    print("encounter 1: what is the largest power of 11 dividing 2^110 - 1?")
    life.install_residue_sensor(11, (110,))
    sensor = organ.form(11, 2)
    print(f"  formed once: ord_11(2)={sensor.order}, "
          f"v_11(2^{sensor.order}-1)={sensor.depth} "
          f"(2^10-1 = 1023 = 3*11*31)")
    print(f"  answer: v_11(2^110 - 1) = {sensor.valuation(110)}")

    print("\nencounter 2: the same question at exponent 1210 (a 365-digit integer)")
    print(f"  answer without forming the integer: {organ.valuation(11, 2, 1210)}")
    print(f"  formations so far: {organ.formations}, reuses: {organ.reuses}")

    print("\nencounter 3: the exceptional prime.  v_2(3^2026 - 1)?")
    life.install_residue_sensor(2, (2026,))
    two = organ.form(2, 3)
    print(f"  v2(3-1)={two.depth}, v2(3+1)={two.plus_depth}")
    print(f"  answer: {two.valuation(2026)}")

    print("\nthe sensor inverts: least n with 11^4 | 2^n - 1 is "
          f"{sensor.least_exponent_reaching(4)}")

    other, exponent, other_valuation = minimality_witness(sensor)
    print(f"\nminimality: base {other} agrees with 2 modulo "
          f"11^{sensor.base_chart_depth - 1}, yet v_11({other}^{exponent}-1) = "
          f"{other_valuation} != {sensor.valuation(exponent)}")

    print("\nencounter 4: handed 2^23 - 1, NOT told which prime to ask about.")
    naming = factor_cyclotomic(23, 2)
    print(f"  Phi_23(2) = {naming.value}")
    print(f"  the chart names its own candidates: p = 1 mod {naming.progression}"
          f", or p = {naming.exceptional}")
    print("  so I try 47, 93, 139, ... and never 3, 5, 7, 9, ...")
    print(f"  {naming.factors} in {naming.candidates_tried} trial divisions; "
          f"unguided the same algorithm needs {naming.naive_candidates}")

    print("\nencounter 5: the same move on Phi_31(10), a 31-digit integer.")
    budget = 150_000
    guided = factor_cyclotomic(31, 10, budget=budget, compare=False)
    blind, _t, _c, _d = naive_trial_division(abs(guided.value), budget)
    print(f"  with {budget} trial divisions each:")
    print(f"    guided by p = 1 mod {guided.progression}: {guided.factors}")
    print(f"    unguided:                              {blind}")
    print(f"  the chart reaches {guided.progression // 2}x further, so it gets "
          "a factor brute force cannot.")
    print(f"  what is left is typed, not hidden: cofactor {guided.cofactor} "
          f"(complete={guided.complete})")

    print("\nencounter 6: 'factor 2^60 - 1.'  No prime named, no index named.")
    fresh = CyclotomicOrgan(ArithmeticLife())
    try:
        fresh.form(1321, 2)
    except ValueError as gate_error:
        print(f"  first, v_1321 is refused: {gate_error}")
    routed = fresh.route(2, 60)
    print(f"  routed through Phi_m for m | 60:")
    print(f"    {routed.factors}")
    print(f"    scan bound {routed.blind_scan_bound} -> "
          f"{routed.routed_scan_bound}, in {routed.candidates_tried} "
          "trial divisions")
    print("  the blind organ needs 760 prime sensors just to crack 2^25 - 1.")
    earned = fresh.form(1321, 2)
    print(f"  and now v_1321 is answerable: ord=({earned.order}), so "
          f"v_1321(2^{60 * 1321} - 1) = {earned.valuation(60 * 1321)}")
    print("  the encounter earned the sensor; the sensor answers the family.")

    print("\nencounter 7: 'I want a new prime.  Which encounter should I ask "
          "for?'")
    chooser = CyclotomicOrgan(ArithmeticLife())
    for _ in range(6):
        index = chooser.propose_encounter(2)
        held = set(chooser.life.moduli)
        chooser.route(2, index)
        fresh = sorted(set(chooser.life.moduli) - held)
        print(f"    proposes n={index:2d} -> earns {fresh}")
    declined = [n for n in range(1, 13) if not has_primitive_divisor(2, n)]
    print(f"  it never proposes {declined}, and can say why: "
          f"Phi_6(2) = {cyclotomic_value(6, 2)} = "
          f"largest prime factor of 6.  No primitive divisor exists.")
    print("  declining is the choice; an organ that accepts everything is fed.")

    print("\nencounter 8: 'what can I NOT reach?'")
    budget = 200_000
    bound = acquisition_horizon(2, budget)
    reach = [n for n in range(1, bound + 1) if affordable(2, n, budget)]
    print(f"  with a budget of {budget} trial divisions at base 2:")
    print(f"    proved horizon {bound}; affordable exponents {len(reach)}, "
          f"largest {max(reach)}")
    for index in (53, 61, 210):
        print(f"    n={index:4d} phi={totient(index):3d} "
              f"cost={scan_cost(2, index):10d}  "
              f"{'REACHABLE' if affordable(2, index, budget) else 'refused'}")
    print("  the horizon is a sublevel set of phi, not an interval in n:")
    print("  2^210-1 has 64 digits and is reachable; 2^61-1 has 19 and is not.")
    print(f"  refusal(2,61): {refusal(2, 61)}")
    print(f"  refusal(2, 6): {refusal(2, 6)}")
    print("  two refusals, kept apart: nothing is there, versus I cannot get there.")

    print("\nencounter 9: 'if I double my budget, how much further do I see?'")
    for probe in (200_000, 400_000):
        edge = acquisition_horizon(2, probe)
        print(f"    B={probe:>8}  reachable={sum(1 for n in range(1, edge + 1) if affordable(2, n, probe)):4d}")
    print("  doubling buys NOTHING.  the rate is smooth, the experience is a stair.")
    print(f"    derived rate: {growth_rate(2):.3f} exponents per unit log B "
          f"= {growth_rate(2) * 2.302585:.2f} per decade")
    print(f"    derived cost of one more exponent: "
          f"{budget_factor_per_exponent(2):.4f}x budget")
    for probe in (200_000, 600_000, 2_000_000):
        cost, which = next_budget_step(2, probe)
        print(f"    at B={probe:>9}: next stair {cost:>9} "
              f"({cost / probe:.2f}x), buys n={which}")
    print("  and 106 beats 53 because Phi_2m(x) = Phi_m(-x):")
    print(f"    3*Phi_106(2) = {3 * cyclotomic_value(106, 2)} = 2^53 + 1")
    print(f"      Phi_53(2)  = {cyclotomic_value(53, 2)} = 2^53 - 1")
    print(f"    so the costs differ by exactly sqrt(3): "
          f"{scan_cost(2, 53) / scan_cost(2, 106):.4f}")

    print("\nencounter 10: 'I have worked base 2.  Is base 3 worth anything?'")
    twobase = CyclotomicOrgan(ArithmeticLife())
    for _ in range(8):
        twobase.route(2, twobase.propose_encounter(2))
    print(f"  holdings from base 2: {sorted(twobase.life.moduli)}")
    print("  the old per-base guarantee walks straight into a collision:")
    print(f"    Phi_4(3) = {cyclotomic_value(4, 3)} = 2 * 5, and 5 is already "
          f"held (ord_5(2) = 4)")
    print("  transported into base-3 coordinates, before spending anything:")
    for probe in (4, 5, 6, 12, 16):
        is_fresh, residual, owned = fresh_yield(twobase, 3, probe)
        print(f"    n={probe:3d}: re-delivers {str(owned):8s} residual "
              f"{residual:6d}  fresh={is_fresh}")
    print("  so the organ chooses across bases now:")
    for _ in range(4):
        pick = twobase.propose_fresh_encounter(3)
        owned = set(twobase.life.moduli)
        twobase.route(3, pick)
        print(f"    base 3, n={pick:3d} -> genuinely new "
              f"{sorted(set(twobase.life.moduli) - owned)}")
    print("  and composition is impossible, not merely unimplemented:")
    left, right, other_left, other_right = order_composition_witness(7)
    print(f"    p=7: ord({left})={multiplicative_order(left, 7)}, "
          f"ord({right})={multiplicative_order(right, 7)} -> "
          f"ord({left * right % 7})={multiplicative_order(left * right % 7, 7)}")
    print(f"         ord({other_left})={multiplicative_order(other_left, 7)}, "
          f"ord({other_right})={multiplicative_order(other_right, 7)} -> "
          f"ord({other_left * other_right % 7})="
          f"{multiplicative_order(other_left * other_right % 7, 7)}")

    print("\nencounter 11: 'I want the prime 1093.  Which encounter gets it?'")
    repertoire = tuple(range(2, 12))
    for candidate in (2, 3, 5, 11):
        order = multiplicative_order(candidate, 1093)
        print(f"    base {candidate:2d}: ord_1093 = {order:4d}, phi = "
              f"{totient(order):3d}")
    route = target(1093, repertoire)
    print(f"  cheapest over bases 2..11: {route.describe()}")
    for wanted in (41, 65537, 641, 2147483647, 3511):
        found = target(wanted, repertoire)
        print(f"    {wanted:>10}: "
              f"{found.describe() if found else 'no route in this repertoire'}")
    print("  but planning does not extend reach (Theorem 12): the targetable")
    print("  set EQUALS the exhaustively reachable set.  It reorders only.")
    print(f"  and with the base free it is vacuous: Phi_1(p+1) = p, so "
          f"Phi_1(3512) = {cyclotomic_value(1, 3512)}")

    print("\nencounter 12: 'which base?'  -- for eight increments, mine.")
    chooser = CyclotomicOrgan(ArithmeticLife())
    picks = []
    for _ in range(10):
        pick = chooser.propose_base()
        picks.append(pick)
        chooser.routed.setdefault(pick, set()).add(1)
    print(f"  the organ now proposes: {picks}")
    print(f"  and declines: "
          f"{[b for b in range(2, 40) if base_refusal(b) is not None]}")
    print(f"    {base_refusal(8)}")
    print(f"  witness: 4^3 - 1 = {4 ** 3 - 1} = 2^6 - 1 = {2 ** 6 - 1}")
    print("  this is ARITHMETIC_LIFE_FIRST_EXECUTION eq (3) one level up:")
    print("    composite modulus adds no test  ->  retained sensors are prime")
    print("    perfect-power base adds no family -> retained bases are non-powers")

    print("\nencounter 13: 'is there a THIRD redundancy?'  -- no, and that is")
    print("  better than yes.  A composite exponent n = m*k has b^m-1 | b^n-1,")
    print("  the same shape as the other two levels.  Is the extra part empty?")
    for probe_base, probe_index in ((2, 12), (2, 20), (3, 9), (2, 6), (2, 1)):
        seen = exponent_redundancy_witness(probe_base, probe_index)
        print(f"    b={probe_base}, n={probe_index:2d}: "
              f"Phi = {cyclotomic_value(probe_index, probe_base):>6}, "
              f"prime dividing no smaller term: "
              f"{seen if seen else 'NONE -- redundant'}")
    print("  the only failures are (2,6) and (2,1): the Zsigmondy exceptions.")
    print("  so the pattern has exactly two instances and its boundary is a")
    print("  theorem, not a gap.  the interface is now fully accounted for:")
    for slot, operation, retained, prunable, _why in interface_report():
        verdict = "chosen by the organ" if prunable else "PROVED unprunable"
        print(f"    {slot:9s} under {operation:15s} -> {retained:12s} "
              f"{verdict}")

    print("\nencounter 14: no input at all -- the organ picks base AND exponent.")
    print("  alternating the two proposals works each base once and leaves it:")
    print("    base 2 n=2 -> [3];  base 3 n=1 -> [2];  base 5 n=3 -> [31]; ...")
    print("  but base 2 alone has ~101 affordable exponents.  Theorem 15:")
    print("    log cost(b,n) = (phi(n)/2) log b - log step(n) + O(1),")
    print("    so raising phi by 2 costs xb, raising the base costs")
    print("    x((b+1)/b)^(phi/2); equal at phi = 2 log b / log(1+1/b).")
    for probe in (2, 3, 5, 10, 100):
        print(f"      base {probe:3d}: crossover phi = {widen_crossover(probe):8.2f}")
    print("  below it widen, above it DEEPEN.  ordering by cost across both:")
    driver = CyclotomicOrgan(ArithmeticLife())
    trail = []
    for _ in range(16):
        choice = driver.propose_next(budget=20_000, base_limit=12)
        if choice is None:
            break
        trail.append(choice)
        driver.route(choice[0], choice[1], budget=20_000)
    print(f"    {trail}")
    print(f"  fourteen straight encounters in base 2 out to exponent 30,")
    print(f"  then it widens -- matching the crossover, not my guess.")

    print("\nencounter 15: 'is cheapest-first actually optimal?'")
    print("  it minimises cost per GUARANTEED prime, and an encounter can")
    print("  yield several.  but the yield is boundable without factoring:")
    print("    every primitive prime is 1 mod n, so p >= n+1; and")
    print("    Phi_n(b) <= (b+1)^phi(n).  hence (n+1)^Y <= (b+1)^phi(n).")
    for probe_base, probe_index in ((2, 2), (2, 12), (5, 19), (7, 23)):
        print(f"      b={probe_base}, n={probe_index:2d}: at most "
              f"{yield_bound(probe_base, probe_index)} primitive primes")
    print("  cost is exponential in phi(n) log b; the yield bound is only")
    print("  polylogarithmic in it.  so yield can never overturn an")
    print("  exponential cost gap -- only reorder near-ties.")
    judge = CyclotomicOrgan(ArithmeticLife())
    for _ in range(4):
        verdict, sure, unsure = judge.optimality_certificate(budget=20_000,
                                                             base_limit=8)
        if verdict is None:
            break
        print(f"    pick {verdict}: provably beats {sure}, contested {unsure}")
        judge.route(verdict[0], verdict[1], budget=20_000)
    print("  the contested count never reaches zero, and that is the honest")
    print("  report: optimal against most of the grid, undecided on the ties.")

    print("\nthe chart behind the law: v_p on the cyclotomic factors")
    for label, formed in (("11, base 2", sensor), ("2, base 3", two)):
        chain = 1 if formed.prime == 2 else formed.order
        entries = [
            f"Phi_{chain * formed.prime ** s}:{cyclotomic_valuation(formed, chain * formed.prime ** s)}"
            for s in range(4)
        ]
        print(f"  p={label}: head {chain_head(formed)}, chain "
              + "  ".join(entries) + "  ...")
    print("  everything off the chain is zero; v_p(n) counts the chain steps")


if __name__ == "__main__":
    main()
