#!/usr/bin/env python3
"""The smallest arithmetic body where a new sense unlocks a new operation.

Binary digits act on remainders modulo three by r |-> 2r+d.  Admitting the
observation ``r == 0`` refines a formerly blind observer.  Reverse BFS on
synchronous pairs gives shortest distinguishing words, and the refined state
supports a shortest suffix that completes any binary integer to a multiple of
three.
"""

from __future__ import annotations

from collections import deque
from dataclasses import dataclass


STATES = (0, 1, 2)
DIGITS = ("0", "1")


def append_digit(remainder: int, digit: str) -> int:
    """Append one binary digit while retaining only the remainder modulo 3."""
    if remainder not in STATES or digit not in DIGITS:
        raise ValueError("expected a residue modulo 3 and a binary digit")
    return (2 * remainder + int(digit)) % 3


def divisible_by_three(remainder: int) -> bool:
    return remainder == 0


def pair(left: int, right: int) -> tuple[int, int]:
    if left == right:
        raise ValueError("a witness pair must contain distinct states")
    return tuple(sorted((left, right)))


@dataclass(frozen=True)
class Witness:
    start: tuple[int, int]
    word: str
    terminal: tuple[int, int]
    responses: tuple[bool, bool]

    def replay(self) -> tuple[int, int]:
        left, right = self.start
        for digit in self.word:
            left = append_digit(left, digit)
            right = append_digit(right, digit)
        return pair(left, right)


def witness_forest() -> dict[tuple[int, int], Witness]:
    """Return shortest new witnesses via reverse BFS from immediate splits."""
    pairs = [pair(x, y) for x in STATES for y in STATES if x < y]
    predecessors: dict[tuple[int, int], list[tuple[tuple[int, int], str]]] = {
        state_pair: [] for state_pair in pairs
    }
    for source in pairs:
        for digit in DIGITS:
            target_values = tuple(append_digit(x, digit) for x in source)
            if target_values[0] != target_values[1]:
                predecessors[pair(*target_values)].append((source, digit))

    witnesses: dict[tuple[int, int], Witness] = {}
    queue: deque[tuple[int, int]] = deque()
    for state_pair in pairs:
        responses = tuple(divisible_by_three(x) for x in state_pair)
        if responses[0] != responses[1]:
            witnesses[state_pair] = Witness(state_pair, "", state_pair, responses)
            queue.append(state_pair)

    while queue:
        target = queue.popleft()
        suffix = witnesses[target]
        for source, digit in predecessors[target]:
            if source not in witnesses:
                witnesses[source] = Witness(
                    source,
                    digit + suffix.word,
                    suffix.terminal,
                    suffix.responses,
                )
                queue.append(source)
    return witnesses


def shortest_completion_suffix(remainder: int) -> str:
    """Shortest binary suffix making the resulting integer divisible by 3."""
    if remainder not in STATES:
        raise ValueError("expected a residue modulo 3")
    queue: deque[tuple[int, str]] = deque([(remainder, "")])
    seen = {remainder}
    while queue:
        state, word = queue.popleft()
        if divisible_by_three(state):
            return word
        for digit in DIGITS:
            nxt = append_digit(state, digit)
            if nxt not in seen:
                seen.add(nxt)
                queue.append((nxt, word + digit))
    raise AssertionError("finite remainder graph should reach zero")


def complete_to_multiple_of_three(n: int) -> tuple[int, str]:
    """Execute the operation licensed by the refined predictive state."""
    if n < 0:
        raise ValueError("expected a natural number")
    suffix = shortest_completion_suffix(n % 3)
    completed = n * (2 ** len(suffix)) + (int(suffix, 2) if suffix else 0)
    assert completed % 3 == 0
    return completed, suffix


def main() -> None:
    print("old observer: all residues look the same")
    print("earned observation: divisible by 3?")
    for state_pair, witness in sorted(witness_forest().items()):
        shown = witness.word or "(look now)"
        print(f"  {state_pair}: {shown} -> {witness.terminal} -> {witness.responses}")
    print("new operation: append a shortest suffix to reach a multiple of 3")
    for n in (6, 7, 8):
        completed, suffix = complete_to_multiple_of_three(n)
        print(f"  {n:b}_2: append {suffix or '(nothing)'} -> {completed:b}_2 = {completed}")


if __name__ == "__main__":
    main()
