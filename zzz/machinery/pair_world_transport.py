"""Minimality transport on a non-product world of encountered pairs.

Companion to `notes/PAIR_WORLD_ORBIT_INCIDENCE.md`.

Answers the hostile question closing
`collab/messages/0147-codex-ananta-cyclic-world-converse-result.md`:

    in a non-product encountered pair-world E subset S^2, replace the unit
    group by the action groupoid of actually available moves.  Is witness
    transport exactly orbit incidence with the critical affine fiber, and can
    that criterion be made effective without silently completing E to S^2?

Yes, and yes.  Everything earlier in this thread -- the coset fiber lemma of
`FORMED_UNIT_FILTRATION_DEPTH.md`, the one-parameter collapse, the level
criterion -- assumed `E = S x S`.  None of that is available here.  What
survives is weaker and sufficient:

  * fiber valuations only go UP (Lemma 1), so transport at `(a,b)` is exactly
    the existence of one encountered pair in the same depth-`v` fiber whose sum
    is divisible by `p^{v+1}`;
  * that condition depends on `E` only through its image in `(Z/p^{v+1})^2`,
    which for a finitely generated move monoid is computable by breadth-first
    search in a finite set -- `E` is never completed.

The resource is then the richness of the move monoid's reduction, not the size
of `E`.  Euclid's two anthyphairetic moves reduce onto all of `SL_2(Z/p^k)`;
a single multiplicative move reduces onto a cyclic subgroup.

All arithmetic is exact.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Callable, Iterable, Sequence

Pair = tuple[int, int]
Move = Callable[[int, int], Pair]


def valuation(n: int, p: int) -> int:
    """Exact p-adic valuation of a nonzero integer."""
    if n == 0:
        raise ValueError("valuation of zero is not finite")
    n = abs(n)
    k = 0
    while n % p == 0:
        n //= p
        k += 1
    return k


# ---------------------------------------------------------------- the moves

def euclid_left(a: int, b: int) -> Pair:
    """Anthyphairesis run backwards: undo 'subtract b from a'."""
    return a + b, b


def euclid_right(a: int, b: int) -> Pair:
    """Anthyphairesis run backwards: undo 'subtract a from b'."""
    return a, a + b


EUCLID_MOVES: tuple[Move, Move] = (euclid_left, euclid_right)


def successor_move(a: int, b: int) -> Pair:
    """The counting organism's only move: step both coordinates."""
    return a + 1, b + 1


def multiplicative_moves(generators: Sequence[int]) -> list[Move]:
    """Scale either coordinate by a formed number -- the product world."""
    moves: list[Move] = []
    for g in generators:
        moves.append(lambda a, b, g=g: (a * g, b))
        moves.append(lambda a, b, g=g: (a, b * g))
    return moves


# ------------------------------------------------- the finite residue image

def residue_image(seed: Pair, moves: Sequence[Move], modulus: int
                  ) -> frozenset[Pair]:
    """The image of the orbit of `seed` under `moves` in (Z/modulus)^2.

    Exact and finite: the moves descend to the quotient, so breadth-first
    search in `(Z/modulus)^2` computes the image of the whole infinite orbit
    without enumerating it, and without completing E to a product.
    """
    if modulus < 1:
        raise ValueError("modulus must be positive")
    start = (seed[0] % modulus, seed[1] % modulus)
    seen = {start}
    frontier = [start]
    while frontier:
        a, b = frontier.pop()
        for move in moves:
            x, y = move(a, b)
            nxt = (x % modulus, y % modulus)
            if nxt not in seen:
                seen.add(nxt)
                frontier.append(nxt)
    return frozenset(seen)


def integer_orbit(seed: Pair, moves: Sequence[Move], bound: int
                  ) -> frozenset[Pair]:
    """The actual orbit, truncated to entries <= bound.  For cross-checking."""
    seen = {seed}
    frontier = [seed]
    while frontier:
        a, b = frontier.pop()
        for move in moves:
            nxt = move(a, b)
            if max(nxt) <= bound and nxt not in seen:
                seen.add(nxt)
                frontier.append(nxt)
    return frozenset(seen)


# ------------------------------------------------------------- the criterion

@dataclass(frozen=True)
class TransportVerdict:
    """Whether ambient minimality transports at one encountered pair.

    `depth_upper_bound` is `v+1` when transport holds (then it is exactly the
    minimum) and `v` when it fails (then depth `v` is known to suffice, but the
    true minimum may be smaller -- deciding it needs the depth search, not the
    incidence test).
    """

    pair: Pair
    prime: int
    valuation: int          # v_p(a+b)
    ambient_depth: int      # v+1, the all-integer minimum
    depth_upper_bound: int  # a depth known to suffice on E; NOT claimed minimal
    transports: bool        # is the ambient depth v+1 actually needed on E
    witness: Pair | None    # an encountered residue in the same fiber, sum p^{v+1} | .
    reason: str


def transports_at(seed: Pair, moves: Sequence[Move], a: int, b: int, p: int
                  ) -> TransportVerdict:
    """Decide transport at `(a,b)` by orbit incidence with the critical fiber.

    Lemma 1: every pair in the depth-`v` fiber has sum valuation `>= v`, so the
    only way to break the depth-`v` chart is a fiber pair whose sum valuation is
    strictly larger -- i.e. divisible by `p^{v+1}`.
    """
    v = valuation(a + b, p)
    modulus = p ** (v + 1)
    image = residue_image(seed, moves, modulus)
    lower = p ** v
    witness = None
    for x, y in sorted(image):
        if x % lower == a % lower and y % lower == b % lower and (x + y) % modulus == 0:
            witness = (x, y)
            break
    transports = witness is not None
    return TransportVerdict(
        pair=(a, b),
        prime=p,
        valuation=v,
        ambient_depth=v + 1,
        depth_upper_bound=v + 1 if transports else v,
        transports=transports,
        witness=witness,
        reason=(
            f"the orbit meets the critical fiber at {witness}, so depth {v} "
            f"is defeated and the ambient depth {v+1} is needed"
            if transports else
            f"the orbit misses the critical fiber mod {modulus}: no encountered "
            f"pair congruent to ({a % lower},{b % lower}) mod {lower} has sum "
            f"divisible by {modulus}, so depth {v} already decides"
        ),
    )


def brute_force_depth(pairs: Iterable[Pair], a: int, b: int, p: int,
                      max_depth: int = 24) -> int:
    """Independent replay: least k with v_p(x+y) constant on the depth-k fiber.

    Takes an explicit finite list of encountered pairs and never uses Lemma 1,
    so it is a genuine second route rather than a restatement of the criterion.
    """
    pairs = list(pairs)
    target = valuation(a + b, p)
    for k in range(0, max_depth):
        m = p ** k
        ra, rb = a % m, b % m
        if all(valuation(x + y, p) == target
               for x, y in pairs if x % m == ra and y % m == rb):
            return k
    raise ValueError("no sufficient depth below max_depth")


def unimodular_residues(p: int, k: int) -> frozenset[Pair]:
    """{(x,y) mod p^k : not both x and y divisible by p}."""
    m = p ** k
    return frozenset((x, y) for x in range(m) for y in range(m)
                     if not (x % p == 0 and y % p == 0))


if __name__ == "__main__":
    from math import gcd

    print("Euclid's pair-world: orbit of (1,1) under the two undo-moves")
    orbit = integer_orbit((1, 1), EUCLID_MOVES, 40)
    coprime = {(a, b) for a in range(1, 41) for b in range(1, 41)
               if gcd(a, b) == 1}
    print(f"  orbit (entries <= 40) == coprime pairs : {orbit == coprime}"
          f"   ({len(orbit)} pairs)")
    for p, k in ((2, 3), (3, 2), (5, 2), (7, 2)):
        img = residue_image((1, 1), EUCLID_MOVES, p ** k)
        print(f"  image mod {p}^{k} == unimodular vectors : "
              f"{img == unimodular_residues(p, k)}   ({len(img)})")

    print()
    print("transport verdicts")
    for label, seed, moves, cases in (
        ("Euclid    ", (1, 1), EUCLID_MOVES,
         [(1, 1, 2), (1, 3, 2), (3, 5, 2), (1, 1, 3), (1, 2, 3)]),
        ("counting  ", (1, 2), [successor_move],
         [(1, 2, 2), (3, 4, 2), (1, 2, 3), (4, 5, 3), (2, 3, 5)]),
        ("multiplic.", (1, 1), multiplicative_moves([3]),
         [(1, 3, 2), (3, 9, 2), (1, 3, 3), (3, 9, 3)]),
    ):
        for a, b, p in cases:
            verdict = transports_at(seed, moves, a, b, p)
            mark = "transports" if verdict.transports else "FAILS     "
            print(f"  {label} p={p} ({a},{b}) v={verdict.valuation} "
                  f"{mark} depth <= {verdict.depth_upper_bound} vs ambient "
                  f"{verdict.ambient_depth}")
