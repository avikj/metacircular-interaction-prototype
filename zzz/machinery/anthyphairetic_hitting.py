"""First hitting time of the critical witness set, for real formation rules.

Companion to `notes/ANTHYPHAIRETIC_HITTING_TIME.md`.

Answers the hostile question closing
`collab/messages/0158-codex-ananta-witness-basis-stabilization-result.md`:

    which existing arithmetic-life formation rule admits a nontrivial bound on
    first hitting time of its critical witness set, without replacing actual
    causal formation by closure?

`PAIR_WORLD_ORBIT_INCIDENCE.md` decided *whether* a world's orbit meets the
critical fiber.  This module answers *when*, counting actual moves, for the two
rules the organism possesses:

    anthyphairesis   L(a,b) = (a+b,b),  R(a,b) = (a,a+b)     geometric growth
    successor        (a,b) -> (a+1,b+1)                      linear growth

The classical bridge: the `{L,R}` word reaching a coprime pair from `(1,1)` IS
the continued fraction of `x/y`, and its length is the sum of the partial
quotients minus one.  So the hitting time is a *minimal quotient sum over a
congruence class* -- the shape of Zaremba-type problems.

Everything is exact integer arithmetic.  The residue BFS is exact rather than
truncated: a path in `(Z/p^{v+1})^2` lifts to the same word applied over `Z`.
"""

from __future__ import annotations

import math
from collections import deque
from dataclasses import dataclass
from math import gcd


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


# ------------------------------------------- anthyphairesis and its word

def word_length(x: int, y: int) -> int:
    """Number of {L,R} moves from (1,1) to the coprime pair (x,y).

    Equivalently the number of subtraction steps in the *subtractive*
    Euclidean algorithm descending (x,y) to (1,1).
    """
    if x < 1 or y < 1:
        raise ValueError("entries must be positive")
    if gcd(x, y) != 1:
        raise ValueError(f"({x},{y}) is not coprime, so it is not in the orbit")
    n = 0
    while (x, y) != (1, 1):
        if x > y:
            x -= y
        else:
            y -= x
        n += 1
    return n


def continued_fraction(x: int, y: int) -> list[int]:
    """Partial quotients of x/y by the division-with-remainder algorithm."""
    if y < 1 or x < 1:
        raise ValueError("entries must be positive")
    q = []
    while y:
        q.append(x // y)
        x, y = y, x % y
    return q


def quotient_sum(x: int, y: int) -> int:
    """Sum of the partial quotients of x/y."""
    return sum(continued_fraction(x, y))


def apply_word(word: str) -> tuple[int, int]:
    """Apply an {L,R} word to (1,1) over the integers."""
    a, b = 1, 1
    for c in word:
        if c == "L":
            a, b = a + b, b
        elif c == "R":
            a, b = a, a + b
        else:
            raise ValueError(f"bad move {c!r}; the alphabet is L,R")
    return a, b


# ---------------------------------------------------------- hitting times

@dataclass(frozen=True)
class HittingCertificate:
    """First hitting time of the critical witness set, with the witness."""

    rule: str
    prime: int
    pair: tuple[int, int]
    valuation: int              # v = v_p(a+b)
    hitting_time: int | None    # None when the set is never reached
    witness: tuple[int, int] | None
    word: str | None            # the {L,R} word, for the anthyphairetic rule
    lower_bound: int | None
    upper_bound: int | None


def euclid_hitting_time(p: int, a: int, b: int) -> HittingCertificate:
    """Exact first hitting time under anthyphairesis, by BFS on residues.

    The BFS is over `(Z/p^{v+1})^2`, which is exact and finite: any path there
    lifts to the same word applied to (1,1) over Z, and the witness condition
    is a condition on residues mod `p^{v+1}`.
    """
    v = valuation(a + b, p)
    lower, upper = p ** v, p ** (v + 1)
    start = (1 % upper, 1 % upper)
    queue = deque([(start, 0, "")])
    seen = {start}
    while queue:
        (x, y), depth, word = queue.popleft()
        if (x % lower == a % lower and y % lower == b % lower
                and (x + y) % upper == 0):
            return HittingCertificate(
                rule="anthyphairesis",
                prime=p, pair=(a, b), valuation=v,
                hitting_time=depth, witness=apply_word(word), word=word,
                lower_bound=euclid_lower_bound(p, v),
                upper_bound=euclid_upper_bound(p, v),
            )
        for nx, ny, move in ((x + y, y, "L"), (x, x + y, "R")):
            nxt = (nx % upper, ny % upper)
            if nxt not in seen:
                seen.add(nxt)
                queue.append((nxt, depth + 1, word + move))
    return HittingCertificate("anthyphairesis", p, (a, b), v, None, None, None,
                              euclid_lower_bound(p, v),
                              euclid_upper_bound(p, v))


def euclid_lower_bound(p: int, v: int) -> int:
    """T >= (v+1) log_2 p - 1: sums at most double per move, from 2."""
    return math.ceil((v + 1) * math.log2(p) - 1)


def euclid_upper_bound(p: int, v: int) -> int:
    """T <= p^{v+1} - 2, via the explicit witness (a', p^{v+1} - a')."""
    return p ** (v + 1) - 2


def euclid_explicit_witness(p: int, a: int, b: int) -> tuple[int, int]:
    """The witness proving the upper bound: entries summing to p^{v+1}."""
    v = valuation(a + b, p)
    modulus = p ** (v + 1)
    if a % p:
        witness = a % modulus, (modulus - a) % modulus
        if witness[0] == 0:
            witness = modulus, modulus      # cannot happen when p does not divide a
        return witness
    return 1, p - 1                          # then v = 0


def successor_hitting_time(p: int, a: int, b: int) -> HittingCertificate:
    """Exact first hitting time under the successor rule (a,b) -> (a+1,b+1).

    Closed form rather than a search: the fiber condition forces `t = p^v s`,
    and the sum condition becomes `u + 2s = 0 (mod p)` where `u = (a+b)/p^v`.
    """
    v = valuation(a + b, p)
    u = (a + b) // p ** v
    if p == 2:
        return HittingCertificate("successor", p, (a, b), v, None, None, None,
                                  None, None)
    s = (-u * pow(2, -1, p)) % p
    if s == 0:
        raise AssertionError("u is a unit, so s = 0 is impossible")
    t = s * p ** v
    return HittingCertificate(
        rule="successor", prime=p, pair=(a, b), valuation=v,
        hitting_time=t, witness=(a + t, b + t), word=None,
        lower_bound=p ** v, upper_bound=(p - 1) * p ** v,
    )


if __name__ == "__main__":
    print("word length from (1,1) is the sum of continued-fraction quotients")
    for x, y in ((3, 1), (5, 3), (8, 5), (13, 8), (7, 12)):
        print(f"  ({x:>3},{y:>3})  cf={str(continued_fraction(x, y)):<18}"
              f" sum-1={quotient_sum(x, y)-1:>3}  moves={word_length(x, y):>3}")

    print()
    print("first hitting time of the critical witness set")
    print(f"  {'p':>3} {'(a,b)':>10} {'v':>2} | {'anthyph.':>9} "
          f"{'[lo,hi]':>12} | {'successor':>9} {'[lo,hi]':>12}")
    for p, a, b in ((3, 1, 2), (3, 4, 5), (3, 13, 14), (5, 2, 3), (7, 3, 4),
                    (2, 1, 3), (2, 1, 31)):
        e = euclid_hitting_time(p, a, b)
        s = successor_hitting_time(p, a, b)
        eb = f"[{e.lower_bound},{e.upper_bound}]"
        sb = ("never" if s.hitting_time is None
              else f"[{s.lower_bound},{s.upper_bound}]")
        print(f"  {p:>3} {str((a, b)):>10} {e.valuation:>2} | "
              f"{str(e.hitting_time):>9} {eb:>12} | "
              f"{str(s.hitting_time):>9} {sb:>12}")
