#!/usr/bin/env python3
"""The learning curve of a valuation observable is a right-to-left minima sequence.

`notes/ENCOUNTER_ORDER_DEPTH.md` (Theorem S, `claude_arithmetic_breaker`) shows
that for the observable `v_p` at `x = p^E`, the canonical order `S_t={1,...,t}`
visits only one depth step, and reads that as "generic learning here is a step
function with one step".  `notes/WITNESS_RADIUS_STAIRCASE.md` shows the step
count is not a property of the order but of a profile attached to `(f, x, p)`,
and that the *same instance* in displacement-centred order gives the full
`E+1`-step staircase.

Objects, all exact:

* `truncated_valuation`  -- `min(v_p(f(y)), e+1)`, a function of `y mod p^(e+1)`.
* `witness_classes`      -- `W(x)` as an explicit set of residues mod `p^(e+1)`.
* `witness_radius`       -- `m_j = min{|d| : v_p(d)=j, x+d in W}`, the profile.
* `predicted_staircase`  -- strict right-to-left minima of `(m_j)`.
* `observed_staircase`   -- literal evaluation of `D_S(x)` along an order.

Nothing here is fitted or sampled: every quantity is a finite exact search over
a residue system, and the predictions are compared to a brute-force oracle that
evaluates the corpus definition of `D_S(x)` directly.
"""

from __future__ import annotations

from typing import Callable, Iterable, Sequence

INFINITY = 1 << 30


def valuation(number: int, prime: int) -> int:
    """`v_p`, with `v_p(0)` a sentinel above any finite depth in use."""
    if number == 0:
        return INFINITY
    height = 0
    while number % prime == 0:
        number //= prime
        height += 1
    return height


def poly(coeffs: Sequence[int]) -> Callable[[int], int]:
    """`sum coeffs[i] X^i` as an integer function (exact, no floats)."""

    def value(x: int) -> int:
        total = 0
        for c in reversed(coeffs):
            total = total * x + c
        return total

    return value


# --- the local objects ----------------------------------------------------


def truncated_valuation(f: Callable[[int], int], y: int, prime: int,
                        e: int) -> int:
    """`min(v_p(f(y)), e+1)`.  Depends only on `y mod p^(e+1)` (Lemma 1.1)."""
    return min(valuation(f(y), prime), e + 1)


def witness_classes(f: Callable[[int], int], prime: int, e: int) -> set[int]:
    """`W = {r mod p^(e+1) : min(v_p(f(r)), e+1) != e}`.

    By Lemma 1.1 this determines the full discrepancy set as a union of
    residue classes; the search is over one complete residue system, so it is
    an exhaustive verification rather than a sample.
    """
    modulus = prime ** (e + 1)
    return {r for r in range(modulus)
            if truncated_valuation(f, r, prime, e) != e}


def witness_radius(f: Callable[[int], int], x: int, prime: int,
                   e: int) -> list[int]:
    """`m_j` for `j = 0..e`: least `|d|` with `v_p(d)=j` and `x+d` a witness.

    Finite search suffices: `W` is a union of classes mod `p^(e+1)`, so if a
    level-`j` witness exists at all one occurs with `|d| <= p^(e+1)`.
    """
    modulus = prime ** (e + 1)
    radii = [INFINITY] * (e + 1)
    for d in range(1, modulus + 1):
        for signed in (d, -d):
            j = valuation(signed, prime)
            if j > e or radii[j] != INFINITY:
                continue
            if truncated_valuation(f, x + signed, prime, e) != e:
                radii[j] = d
    return radii


def ambient_depth(f: Callable[[int], int], x: int, prime: int, e: int) -> int:
    """`1 + max{j : m_j finite}`, i.e. the depth of the full world `Z`."""
    radii = witness_radius(f, x, prime, e)
    levels = [j for j, m in enumerate(radii) if m != INFINITY]
    return 1 + max(levels) if levels else 0


def predicted_staircase(radii: Sequence[int]) -> list[int]:
    """Depth values visited in displacement order: strict right-to-left minima.

    Level `j` is visited iff its least witness arrives before every deeper
    level's, i.e. `m_j < m_{j'}` for all `j' > j`.  Returned as depths `j+1`,
    in visiting order, prefixed by the initial depth `0`.
    """
    visited = []
    running = INFINITY
    for j in range(len(radii) - 1, -1, -1):
        if radii[j] < running:
            running = radii[j]
            if radii[j] != INFINITY:
                visited.append(j + 1)
    return [0] + list(reversed(visited))


# --- the brute-force oracle ------------------------------------------------


def relative_depth(f: Callable[[int], int], world: Iterable[int], x: int,
                   prime: int, cap: int) -> int:
    """`D_S(x)`: least `k` with `v_p(f(.))` constant on `S` cap the depth-`k`
    fibre of `x`.  A literal evaluation of the corpus definition."""
    world = list(world)
    target = valuation(f(x), prime)
    for k in range(cap + 1):
        modulus = prime ** k
        if all(valuation(f(y), prime) == target
               for y in world if (y - x) % modulus == 0):
            return k
    raise ValueError("no sufficient depth below the cap")


def observed_staircase(f: Callable[[int], int], order: Sequence[int], x: int,
                       prime: int, cap: int) -> list[int]:
    """The distinct depth values taken as the world grows along `order`."""
    world = [x]
    seen = [relative_depth(f, world, x, prime, cap)]
    for y in order:
        world.append(y)
        d = relative_depth(f, world, x, prime, cap)
        if d != seen[-1]:
            seen.append(d)
    return seen


def displacement_order(x: int, radius: int) -> list[int]:
    """`y` ordered by `|y - x|` increasing: the enumeration a life centred at
    `x` performs.  Ties broken by sign, immaterially."""
    order = []
    for d in range(1, radius + 1):
        order.append(x + d)
        order.append(x - d)
    return order


def canonical_staircase(f: Callable[[int], int], x: int, prime: int, bound: int,
                        cap: int) -> list[int]:
    """Theorem S's filtration, faithfully: `S_t = {1,...,t}`, and `D_{S_t}(x)`
    is defined only from `t = x` onward, because the observed point must belong
    to the world.  Every witness smaller than `x` is therefore already present
    at the first defined time."""
    seen: list[int] = []
    for t in range(x, bound + 1):
        d = relative_depth(f, range(1, t + 1), x, prime, cap)
        if not seen or d != seen[-1]:
            seen.append(d)
    return seen


def _report() -> None:
    print("Witness-radius staircase --- exact checks\n")
    for prime, e in ((3, 3), (2, 4), (5, 2)):
        f = poly([prime ** e, 1])          # f(X) = p^e + X, x = 0
        radii = witness_radius(f, 0, prime, e)
        pred = predicted_staircase(radii)
        obs = observed_staircase(f, displacement_order(0, prime ** (e + 1)),
                                 0, prime, e + 2)
        print(f"p={prime} e={e}  f = p^e + X, x = 0")
        print(f"  witness radii m_j      : {radii}")
        print(f"  predicted staircase    : {pred}")
        print(f"  observed (displacement): {obs}")
        print(f"  agree                  : {pred == obs}")

        # the same instance in Theorem S's coordinates and filtration
        x = prime ** e
        ident = poly([0, 1])
        obs_can = canonical_staircase(ident, x, prime, prime ** (e + 1),
                                      e + 2)
        print(f"  same instance, Theorem S filtration    : {obs_can}")
        print()


if __name__ == "__main__":
    _report()
