#!/usr/bin/env python3
"""Minimal compositional crystal of a finite observed dynamical system.

A finite natural machine is a deterministic Moore system (X, A, delta, obs).
Two states crystallize together exactly when no finite word of interventions
can distinguish their observations. Partition refinement computes the unique
minimal quotient while retaining every dependent-origin fiber.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from collections import deque
from itertools import combinations, product
from math import gcd, lcm
from typing import Callable, Hashable, Mapping, Sequence

State = Hashable
Action = Hashable
Output = Hashable


@dataclass(frozen=True)
class Crystal:
    fibers: tuple[tuple[State, ...], ...]
    observations: tuple[Output, ...]
    transitions: tuple[tuple[int, ...], ...]
    actions: tuple[Action, ...]

    def validate(self) -> None:
        count = len(self.fibers)
        if len(self.observations) != count or len(self.transitions) != count:
            raise ValueError("quotient tables disagree")
        if any(len(row) != len(self.actions) for row in self.transitions):
            raise ValueError("transition row has wrong arity")
        if any(target < 0 or target >= count
               for row in self.transitions for target in row):
            raise ValueError("transition leaves quotient")


@dataclass(frozen=True)
class GeneratedWorld:
    states: tuple[State, ...]
    transition: Mapping[tuple[State, Action], State]
    frontier: tuple[tuple[State, Action, State], ...]

    @property
    def closed(self) -> bool:
        return not self.frontier


def generate_world(
    seeds: Sequence[State],
    actions: Sequence[Action],
    step: Callable[[State, Action], State],
    limit: int,
) -> GeneratedWorld:
    """Generate the reachable finite world, exposing rather than hiding a cutoff."""
    if limit <= 0:
        raise ValueError("generation limit must be positive")
    discovered = list(dict.fromkeys(seeds))
    if not discovered:
        raise ValueError("generation needs at least one seed")
    if len(discovered) > limit:
        raise ValueError("seed set already exceeds the generation limit")
    acts = tuple(actions)
    transition: dict[tuple[State, Action], State] = {}
    frontier = []
    cursor = 0
    known = set(discovered)
    while cursor < len(discovered):
        source = discovered[cursor]
        cursor += 1
        for action in acts:
            target = step(source, action)
            transition[source, action] = target
            if target in known:
                continue
            if len(discovered) == limit:
                frontier.append((source, action, target))
                continue
            known.add(target)
            discovered.append(target)
    return GeneratedWorld(tuple(discovered), transition, tuple(frontier))


def run_word(
    state: State,
    word: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
) -> State:
    """Apply a finite experiment to a state."""
    current = state
    for action in word:
        current = transition[current, action]
    return current


def shortest_distinguishing_word(
    left: State,
    right: State,
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> tuple[Action, ...] | None:
    """Return a shortest future experiment separating two states, if one exists.

    Breadth-first search occurs on pairs of states.  Returning ``None`` means
    no finite action word can distinguish the pair in the supplied finite
    total system.
    """
    if observation[left] != observation[right]:
        return ()
    start = (left, right)
    queue = deque([(start, ())])
    seen = {start}
    for_pair = tuple(actions)
    while queue:
        (x, y), word = queue.popleft()
        for action in for_pair:
            next_pair = (transition[x, action], transition[y, action])
            next_word = word + (action,)
            if observation[next_pair[0]] != observation[next_pair[1]]:
                return next_word
            if next_pair not in seen:
                seen.add(next_pair)
                queue.append((next_pair, next_word))
    return None


def explain_distinctions(
    states: Sequence[State],
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> dict[tuple[State, State], tuple[Action, ...] | None]:
    """Give every unordered state pair its shortest separating experiment."""
    xs = tuple(states)
    return {
        (left, right): shortest_distinguishing_word(
            left, right, actions, transition, observation
        )
        for index, left in enumerate(xs)
        for right in xs[index + 1:]
    }


def distinction_horizon(
    states: Sequence[State],
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> int:
    """Maximum length of a shortest separating word in a finite world."""
    words = explain_distinctions(states, actions, transition, observation).values()
    horizon = max((len(word) for word in words if word is not None), default=0)
    bound = max(len(tuple(states)) - 2, 0)
    if horizon > bound:
        raise AssertionError("finite future exceeded the sharp n-2 refinement bound")
    return horizon


def extend_observation(
    states: Sequence[State],
    observation: Mapping[State, Output],
    new_view: Mapping[State, Output],
) -> dict[State, tuple[Output, Output]]:
    """Add one exact view without erasing the observation that came before it."""
    xs = tuple(states)
    if any(state not in observation or state not in new_view for state in xs):
        raise ValueError("both observations must cover every state")
    return {state: (observation[state], new_view[state]) for state in xs}


def compile_experiment(
    states: Sequence[State],
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    name: Action,
    word: Sequence[Action],
) -> tuple[tuple[Action, ...], dict[tuple[State, Action], State]]:
    """Install a known composite experiment as one new primitive action.

    The new action changes access cost but cannot add a behavioral distinction:
    it is definitionally a word in the old actions.
    """
    xs, old_actions, expansion = tuple(states), tuple(actions), tuple(word)
    if name in old_actions:
        raise ValueError("compiled experiment name must be new")
    if not expansion:
        raise ValueError("compiled experiment must have a nonempty expansion")
    if any(action not in old_actions for action in expansion):
        raise ValueError("compiled experiment cites an unknown action")
    result = dict(transition)
    if any((state, action) not in result for state in xs for action in old_actions):
        raise ValueError("transition must be total before compilation")
    for state in xs:
        result[state, name] = run_word(state, expansion, transition)
    return old_actions + (name,), result


def _best_composite(
    states: Sequence[State],
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> tuple[tuple[Action, ...], int] | None:
    """Choose the current shortest witness saving most total separating steps."""
    before = explain_distinctions(states, actions, transition, observation)
    candidates = {word for word in before.values()
                  if word is not None and len(word) > 1}
    best: tuple[tuple[Action, ...], int] | None = None
    for word in sorted(candidates, key=repr):
        temporary_name = object()
        new_actions, new_transition = compile_experiment(
            states, actions, transition, temporary_name, word
        )
        after = explain_distinctions(
            states, new_actions, new_transition, observation
        )
        gain = sum(
            len(old) - len(after[pair])
            for pair, old in before.items()
            if old is not None and after[pair] is not None
        )
        candidate = (word, gain)
        if best is None or gain > best[1]:
            best = candidate
    return best


def learn_experiments(
    states: Sequence[State],
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> tuple[
    tuple[Action, ...],
    dict[tuple[State, Action], State],
    tuple[tuple[Action, tuple[Action, ...], int], ...],
]:
    """Compile useful composite experiments until every distinction costs <= 1.

    Each returned record is ``(new action, old expansion, saved steps)``.  The
    process terminates because every installation makes at least one previously
    longer distinguishable pair separable in one action, and there are only
    finitely many state pairs.
    """
    current_actions = tuple(actions)
    current_transition = dict(transition)
    primitive_expansion = {action: (action,) for action in current_actions}
    original_fibers = crystallize(
        states, current_actions, current_transition, observation
    ).fibers
    learned = []
    serial = 1
    while True:
        best = _best_composite(
            states, current_actions, current_transition, observation
        )
        if best is None:
            break
        word, gain = best
        flattened = tuple(
            primitive
            for action in word
            for primitive in primitive_expansion[action]
        )
        while (name := f"learned-{serial}") in current_actions:
            serial += 1
        current_actions, current_transition = compile_experiment(
            states, current_actions, current_transition, name, word
        )
        primitive_expansion[name] = flattened
        learned.append((name, flattened, gain))
        serial += 1
        if crystallize(
            states, current_actions, current_transition, observation
        ).fibers != original_fibers:
            raise AssertionError("derived action changed behavioral meaning")
    return current_actions, current_transition, tuple(learned)


def crystallize(
    states: Sequence[State],
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> Crystal:
    """Compute behavioral/contextual equivalence by stable refinement."""
    xs = tuple(states)
    acts = tuple(actions)
    if len(set(xs)) != len(xs) or len(set(acts)) != len(acts):
        raise ValueError("states and actions must be unique")
    if any((x, a) not in transition for x in xs for a in acts):
        raise ValueError("transition must be total")
    if any(x not in observation for x in xs):
        raise ValueError("observation must be total")
    if any(transition[x, a] not in set(xs) for x in xs for a in acts):
        raise ValueError("transition must be closed")

    block = {x: 0 for x in xs}
    while True:
        signatures = {
            x: (
                block[x],
                observation[x],
                tuple(block[transition[x, a]] for a in acts),
            )
            for x in xs
        }
        code = {}
        for state in xs:
            signature = signatures[state]
            if signature not in code:
                code[signature] = len(code)
        refined = {x: code[signatures[x]] for x in xs}
        if all(refined[x] == block[x] for x in xs):
            break
        block = refined

    fibers = tuple(
        tuple(x for x in xs if block[x] == index)
        for index in range(max(block.values(), default=-1) + 1)
    )
    observations = tuple(observation[fiber[0]] for fiber in fibers)
    transitions = tuple(
        tuple(block[transition[fiber[0], action]] for action in acts)
        for fiber in fibers
    )
    result = Crystal(fibers, observations, transitions, acts)
    result.validate()
    return result


def divisibility_world(
    base: int, modulus: int
) -> tuple[GeneratedWorld, dict[State, bool]]:
    """Generate the remainder dynamics of appending one base-``base`` digit."""
    if base < 2 or modulus < 1:
        raise ValueError("base must be at least two and modulus must be positive")
    digits = tuple(range(base))
    world = generate_world(
        (0,),
        digits,
        lambda remainder, digit: (base * remainder + digit) % modulus,
        limit=modulus,
    )
    if not world.closed or len(world.states) != modulus:
        raise AssertionError("complete digit alphabet did not generate every residue")
    return world, {remainder: remainder == 0 for remainder in world.states}


def divisibility_horizon(base: int, modulus: int) -> int:
    """First length covering a modulus after the gcd chain has stabilized."""
    if base < 2 or modulus < 1:
        raise ValueError("base must be at least two and modulus must be positive")
    length, power, old_gcd = 0, 1, gcd(modulus, 1)
    while True:
        new_gcd = gcd(modulus, power * base)
        if power >= modulus and new_gcd == old_gcd:
            return length
        length += 1
        power *= base
        old_gcd = new_gcd


def divisibility_classes(
    base: int, modulus: int
) -> tuple[tuple[int, ...], ...]:
    """Construct future-indistinguishability classes without refinement."""
    horizon = divisibility_horizon(base, modulus)
    signatures: dict[tuple[int | None, ...], list[int]] = {}
    for remainder in range(modulus):
        signature = []
        power = 1
        for _length in range(horizon + 1):
            least_suffix = (-power * remainder) % modulus
            signature.append(least_suffix if least_suffix < power else None)
            power *= base
        signatures.setdefault(tuple(signature), []).append(remainder)
    return tuple(tuple(fiber) for fiber in signatures.values())


def binary_divisibility_classes(modulus: int) -> tuple[tuple[int, ...], ...]:
    """Closed-form behavioral classes for binary divisibility modulo ``modulus``.

    If ``modulus = 2**a * q`` with ``q`` odd, the classes are zero, the
    nonzero residues modulo ``q``, and the ``a`` possible finite 2-adic depths
    among nonzero multiples of ``q``.  Hence there are exactly ``q + a``.
    """
    if modulus < 1:
        raise ValueError("modulus must be positive")
    q, exponent = modulus, 0
    while q % 2 == 0:
        q //= 2
        exponent += 1

    classes = [(0,)]
    for residue in range(1, q):
        classes.append(tuple(
            value for value in range(1, modulus) if value % q == residue
        ))
    for valuation in range(exponent):
        classes.append(tuple(
            value for value in range(1, modulus)
            if value % q == 0
            and (value // q) % (2 ** (valuation + 1)) == 2 ** valuation
        ))
    return tuple(classes)


def radix_divisibility_signature(base: int, modulus: int, remainder: int) -> tuple:
    """Exact finite right-language signature for base-``base`` divisibility.

    The entries before the final one record the unique accepting suffix of
    each length shorter than ``ceil(log_base(modulus))``, or ``None`` when no
    such suffix exists.  The final entry records the stabilized congruence
    seen by every longer suffix.
    """
    if base < 2 or modulus < 1:
        raise ValueError("base must be at least two and modulus must be positive")
    if not 0 <= remainder < modulus:
        raise ValueError("remainder must lie in range(modulus)")
    power, short = 1, []
    while power < modulus:
        target = (-power * remainder) % modulus
        short.append(target if target < power else None)
        power *= base
    from math import gcd
    return tuple(short) + (remainder % (modulus // gcd(modulus, power)),)


def radix_divisibility_classes(
    base: int, modulus: int
) -> tuple[tuple[int, ...], ...]:
    """Behavioral classes for divisibility after appending base-``base`` digits."""
    if base < 2 or modulus < 1:
        raise ValueError("base must be at least two and modulus must be positive")
    groups = {}
    for remainder in range(modulus):
        signature = radix_divisibility_signature(base, modulus, remainder)
        groups.setdefault(signature, []).append(remainder)
    return tuple(tuple(group) for group in groups.values())


def chinese_remainder_view(
    left_modulus: int, right_modulus: int
) -> tuple[tuple[tuple[tuple[int, int], tuple[int, ...]], ...], int, int]:
    """Joint residue view of Z/(mn), with its exact image and fiber size."""
    if left_modulus < 1 or right_modulus < 1:
        raise ValueError("moduli must be positive")
    product = left_modulus * right_modulus
    fibers: dict[tuple[int, int], list[int]] = {}
    for value in range(product):
        view = (value % left_modulus, value % right_modulus)
        fibers.setdefault(view, []).append(value)
    common = gcd(left_modulus, right_modulus)
    expected_image = {
        (left, right)
        for left in range(left_modulus)
        for right in range(right_modulus)
        if left % common == right % common
    }
    if set(fibers) != expected_image:
        raise AssertionError("joint residue image violated compatibility")
    if any(len(fiber) != common for fiber in fibers.values()):
        raise AssertionError("joint residue fibers violated gcd law")
    return tuple((view, tuple(fiber)) for view, fiber in fibers.items()), common, lcm(
        left_modulus, right_modulus
    )


def multiple_remainder_view(
    moduli: Sequence[int],
) -> tuple[tuple[tuple[tuple[int, ...], tuple[int, ...]], ...], int, int]:
    """Joint view through any finite family of moduli.

    The source is Z/(product moduli).  The image consists of the pairwise
    gcd-compatible tuples and every fiber has size product/lcm.
    """
    ms = tuple(moduli)
    if not ms or any(modulus < 1 for modulus in ms):
        raise ValueError("moduli must be a nonempty positive family")
    from math import prod
    product_modulus = prod(ms)
    combined = lcm(*ms)
    fibers: dict[tuple[int, ...], list[int]] = {}
    for value in range(product_modulus):
        view = tuple(value % modulus for modulus in ms)
        fibers.setdefault(view, []).append(value)
    compatible = {
        view for view in product(*(range(modulus) for modulus in ms))
        if all(view[i] % gcd(ms[i], ms[j]) == view[j] % gcd(ms[i], ms[j])
               for i in range(len(ms)) for j in range(i + 1, len(ms)))
    }
    if set(fibers) != compatible:
        raise AssertionError("multi-view image violated generalized CRT")
    residual = product_modulus // combined
    if any(len(fiber) != residual for fiber in fibers.values()):
        raise AssertionError("multi-view fibers violated product/lcm law")
    return tuple((view, tuple(fiber)) for view, fiber in fibers.items()), residual, combined


def pattern_world(
    pattern: str, alphabet: Sequence[str]
) -> tuple[GeneratedWorld, dict[State, bool]]:
    """Generate the exact suffix-memory machine for containing ``pattern``."""
    letters = tuple(alphabet)
    if not pattern or not letters or any(len(letter) != 1 for letter in letters):
        raise ValueError("pattern and one-character alphabet must be nonempty")
    if len(set(letters)) != len(letters) or any(letter not in letters for letter in pattern):
        raise ValueError("alphabet must be unique and contain the pattern")
    found = len(pattern)

    def step(state: int, letter: str) -> int:
        if state == found:
            return found
        text = pattern[:state] + letter
        if text.endswith(pattern):
            return found
        return max(
            length for length in range(len(pattern))
            if text.endswith(pattern[:length])
        )

    world = generate_world((0,), letters, step, limit=len(pattern) + 1)
    if not world.closed:
        raise AssertionError("prefix-suffix machine failed to close")
    return world, {state: state == found for state in world.states}


def _binary_dot(mask: int, vector: int) -> int:
    return (mask & vector).bit_count() & 1


def _binary_linear_map(rows: Sequence[int], vector: int) -> int:
    return sum(_binary_dot(row, vector) << index
               for index, row in enumerate(rows))


def _binary_rank(vectors: Sequence[int]) -> int:
    basis: dict[int, int] = {}
    for vector in vectors:
        value = vector
        while value:
            pivot = value.bit_length() - 1
            if pivot in basis:
                value ^= basis[pivot]
            else:
                basis[pivot] = value
                break
    return len(basis)


def linear_observation_world(
    dimension: int, rows: Sequence[int], sensor: int
) -> tuple[GeneratedWorld, dict[State, int]]:
    """All states of an autonomous binary linear system and one sensor."""
    if dimension < 0 or len(rows) != dimension:
        raise ValueError("matrix must have one row per nonnegative dimension")
    bound = 1 << dimension
    if any(row < 0 or row >= bound for row in rows) or sensor < 0 or sensor >= bound:
        raise ValueError("matrix and sensor must fit the declared binary dimension")
    states = tuple(range(bound))
    transition = {
        (state, "evolve"): _binary_linear_map(rows, state) for state in states
    }
    return GeneratedWorld(states, transition, ()), {
        state: _binary_dot(sensor, state) for state in states
    }


def linear_observation_classes(
    dimension: int, rows: Sequence[int], sensor: int
) -> tuple[tuple[tuple[int, ...], ...], int]:
    """Direct observable signatures and rank for a binary linear system."""
    world, observation = linear_observation_world(dimension, rows, sensor)
    signatures: dict[tuple[int, ...], list[int]] = {}
    for state in world.states:
        current = state
        signature = []
        for _ in range(dimension):
            signature.append(observation[current])
            current = world.transition[current, "evolve"]
        signatures.setdefault(tuple(signature), []).append(state)

    # Each signature coordinate is a linear functional.  Evaluate it on the
    # coordinate basis to recover its row vector and hence the observability rank.
    functional_rows = _observable_rows(dimension, rows, sensor)
    return tuple(tuple(fiber) for fiber in signatures.values()), _binary_rank(functional_rows)


def _observable_rows(
    dimension: int, rows: Sequence[int], sensor: int
) -> tuple[int, ...]:
    """Rows C, CA, ..., CA^(n-1), encoded as binary integers."""
    world, observation = linear_observation_world(dimension, rows, sensor)
    result = []
    for time in range(dimension):
        row = 0
        for coordinate in range(dimension):
            current = 1 << coordinate
            for _ in range(time):
                current = world.transition[current, "evolve"]
            row |= observation[current] << coordinate
        result.append(row)
    return tuple(result)


def minimal_sensor_sets(
    dimension: int, rows: Sequence[int], candidates: Sequence[int]
) -> tuple[tuple[int, ...], ...]:
    """Return every smallest candidate sensor family with full observability."""
    sensors = tuple(candidates)
    if len(set(sensors)) != len(sensors):
        raise ValueError("candidate sensors must be unique")
    # Validate the dynamics and every sensor before searching.
    for sensor in sensors:
        linear_observation_world(dimension, rows, sensor)
    for size in range(len(sensors) + 1):
        solutions = []
        for choice in combinations(sensors, size):
            joint_rows = tuple(
                row
                for sensor in choice
                for row in _observable_rows(dimension, rows, sensor)
            )
            if _binary_rank(joint_rows) == dimension:
                solutions.append(choice)
        if solutions:
            return tuple(solutions)
    return ()


def _living_seed() -> None:
    """Show the complete generate/distinguish/compile loop in one small world."""
    actions = ("next",)
    generated = generate_world(
        (0,), actions, lambda state, _action: min(state + 1, 4), limit=5
    )
    assert generated.closed
    states, transition = generated.states, generated.transition
    observation = {
        0: "dark", 1: "dark", 2: "dark", 3: "light", 4: "light"
    }
    before = crystallize(states, actions, transition, observation)
    word = shortest_distinguishing_word(0, 1, actions, transition, observation)
    assert word is not None
    new_actions, new_transition, learned = learn_experiments(
        states, actions, transition, observation
    )
    after = crystallize(states, new_actions, new_transition, observation)
    shorter = shortest_distinguishing_word(
        0, 1, new_actions, new_transition, observation
    )
    assert before.fibers == after.fibers
    print(f"worlds: {states}")
    print(f"observations: {tuple(observation[state] for state in states)}")
    print(f"meaning (indistinguishable fibers): {before.fibers}")
    print(f"discovery: 0 and 1 are separated by {word}")
    print(f"machine chose and installed: {learned}")
    print(f"same meaning, shorter path: {shorter}")
    weight = {0: 0, 1: 0, 2: 0, 3: 0, 4: 1}
    richer_observation = extend_observation(states, observation, weight)
    reopened = crystallize(
        states, new_actions, new_transition, richer_observation
    )
    print(f"new view separates the old fiber (3, 4): {reopened.fibers}")

    residues, divisible = divisibility_world(2, 5)
    residue_crystal = crystallize(
        residues.states, (0, 1), residues.transition, divisible
    )
    _, _, arithmetic_actions = learn_experiments(
        residues.states, (0, 1), residues.transition, divisible
    )
    print(f"binary divisibility by 5 needs these remainder states: "
          f"{residue_crystal.fibers}")
    print(f"digit blocks compiled from arithmetic: {arithmetic_actions}")


def _show_divisibility(base: int, modulus: int) -> None:
    world, observation = divisibility_world(base, modulus)
    digits = tuple(range(base))
    crystal = crystallize(world.states, digits, world.transition, observation)
    direct = divisibility_classes(base, modulus)
    if {frozenset(x) for x in crystal.fibers} != {frozenset(x) for x in direct}:
        raise AssertionError("direct horizon disagrees with refinement")
    actions, _transition, learned = learn_experiments(
        world.states, digits, world.transition, observation
    )
    print(f"base: {base}")
    print(f"modulus: {modulus}")
    print(f"finite future horizon: {divisibility_horizon(base, modulus)}")
    print(f"shortest distinguishing horizon: "
          f"{distinction_horizon(world.states, digits, world.transition, observation)}")
    print(f"minimal states ({len(direct)}): {direct}")
    print(f"learned digit blocks: {learned}")
    print(f"primitive action count: {len(digits)} -> {len(actions)}")


def _show_pattern(pattern: str, alphabet: str) -> None:
    world, observation = pattern_world(pattern, tuple(alphabet))
    letters = tuple(alphabet)
    crystal = crystallize(world.states, letters, world.transition, observation)
    actions, _transition, learned = learn_experiments(
        world.states, letters, world.transition, observation
    )
    print(f"pattern: {pattern!r}")
    print(f"alphabet: {alphabet!r}")
    print(f"reachable suffix memories: {world.states}")
    print(f"minimal future classes: {crystal.fibers}")
    print(f"learned letter blocks: {learned}")
    print(f"primitive action count: {len(letters)} -> {len(actions)}")


def _show_linear() -> None:
    # Three-bit cyclic motion; one sensor eventually sees every coordinate.
    rows, sensor = (2, 4, 1), 1
    world, observation = linear_observation_world(3, rows, sensor)
    crystal = crystallize(
        world.states, ("evolve",), world.transition, observation
    )
    direct, rank = linear_observation_classes(3, rows, sensor)
    print("binary linear system: cyclic shift of three coordinates")
    print("sensor: first coordinate")
    print(f"observability rank: {rank}")
    print(f"observable concepts: 2^{rank} = {len(direct)}")
    print(f"minimal future classes: {crystal.fibers}")
    print(f"smallest full-observation sensor sets: "
          f"{minimal_sensor_sets(3, rows, (1, 2, 4))}")


def _show_crt(left: int, right: int) -> None:
    fibers, common, combined = chinese_remainder_view(left, right)
    print(f"joint view: Z/{left * right} -> Z/{left} x Z/{right}")
    print(f"shared overlap gcd: {common}")
    print(f"compatible visible pairs: {len(fibers)} = lcm {combined}")
    print(f"hidden states behind each visible pair: {common}")
    print(f"exact reconstruction: {common == 1}")
    print(f"fibers: {fibers}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate, distinguish, and compile a finite natural machine"
    )
    subcommands = parser.add_subparsers(dest="command")
    divisibility = subcommands.add_parser(
        "divisibility", help="crystallize base-b divisibility modulo m"
    )
    divisibility.add_argument("base", type=int)
    divisibility.add_argument("modulus", type=int)
    pattern = subcommands.add_parser(
        "contains", help="crystallize recognition of a substring"
    )
    pattern.add_argument("pattern")
    pattern.add_argument("alphabet")
    subcommands.add_parser(
        "observe-linear", help="crystallize a three-bit linear sensor"
    )
    crt = subcommands.add_parser(
        "glue-remainders", help="combine two modular views"
    )
    crt.add_argument("left", type=int)
    crt.add_argument("right", type=int)
    args = parser.parse_args()
    if args.command == "divisibility":
        _show_divisibility(args.base, args.modulus)
    elif args.command == "contains":
        _show_pattern(args.pattern, args.alphabet)
    elif args.command == "observe-linear":
        _show_linear()
    elif args.command == "glue-remainders":
        _show_crt(args.left, args.right)
    else:
        _living_seed()


if __name__ == "__main__":
    main()
