#!/usr/bin/env python3
"""Exact replay of the L/R word and its rational-circle projection."""

from collections import Counter
from itertools import product
from math import gcd


def encode(word: str) -> tuple[int, int]:
    a, b = 1, 1
    for letter in word:
        if letter == "L":
            b += a
        elif letter == "R":
            a += b
        else:
            raise ValueError(letter)
    return a, b


def decode(a: int, b: int) -> str:
    if a < 1 or b < 1 or gcd(a, b) != 1:
        raise ValueError("expected a coprime positive pair")
    reverse = []
    while (a, b) != (1, 1):
        if a < b:
            reverse.append("L")
            b -= a
        elif b < a:
            reverse.append("R")
            a -= b
        else:
            raise AssertionError("coprimality violated")
    return "".join(reversed(reverse))


def circle_shadow(a: int, b: int) -> tuple[int, int, int]:
    m, n = max(a, b), min(a, b)
    return m * m - n * n, 2 * m * n, m * m + n * n


def verify(depth: int = 12) -> None:
    seen = set()
    primitive_shadows = Counter()
    for length in range(depth + 1):
        for letters in product("LR", repeat=length):
            word = "".join(letters)
            pair = encode(word)
            assert gcd(*pair) == 1
            assert pair not in seen
            assert decode(*pair) == word
            seen.add(pair)
            x, y, z = circle_shadow(*pair)
            assert x * x + y * y == z * z
            primitive = gcd(gcd(x, y), z) == 1
            assert primitive == ((pair[0] - pair[1]) % 2 != 0)
            if primitive:
                primitive_shadows[(x, y, z)] += 1

    # max/min forgets pair orientation. Swapping L and R swaps the pair, so
    # every nondegenerate primitive shadow at a complete word depth occurs twice.
    assert primitive_shadows
    assert set(primitive_shadows.values()) == {2}

    for a in range(1, 100):
        for b in range(1, 100):
            if gcd(a, b) == 1:
                assert encode(decode(a, b)) == (a, b)


if __name__ == "__main__":
    verify()
    print("PASS: unique L/R decoding and exact rational-circle projection")
