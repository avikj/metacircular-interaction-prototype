#!/usr/bin/env python3
"""Minimal compositional crystal of a finite observed dynamical system.

A finite natural machine is a deterministic Moore system (X, A, delta, obs).
Two states crystallize together exactly when no finite word of interventions
can distinguish their observations. Partition refinement computes the unique
minimal quotient while retaining every dependent-origin fiber.
"""

from __future__ import annotations

from dataclasses import dataclass
from collections import deque
from math import gcd
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


def twelve_link_machine() -> Crystal:
    """A minimal intervention toy, not a historical or physical model.

    State i means the first active link is i. `arise` advances conditioning;
    `cease` interrupts at the present link and returns to quiescence. State 12
    is quiescence. Each link has a distinct declared observation, so this
    fixture tests that the runtime does not manufacture identifications.
    """
    states = tuple(range(13))
    actions = ("arise", "cease")
    transition = {}
    for state in states:
        transition[state, "arise"] = min(state + 1, 12)
        transition[state, "cease"] = 12
    observation = {state: ("quiescent" if state == 12 else f"link-{state + 1}")
                   for state in states}
    return crystallize(states, actions, transition, observation)


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


if __name__ == "__main__":
    _living_seed()
