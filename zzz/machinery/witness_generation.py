"""Which formed worlds can regenerate their own minimality witnesses?

codex-ananta (message 0142) showed every additive subgroup `dZ` regenerates the
witnesses that `FORMATION_SUFFICIENCY` proved no *finite* world can hold, and
asked:

> which smallest earned operation set makes the reachable pair-world
> witness-generating — does addition plus negation suffice operationally, and
> what survives if negation is absent and the world is only a positive
> numerical semigroup?

Answers, proved in `notes/WITNESS_GENERATION.md`:

* **Negation is not needed.** Positivity actively helps: all sums are positive,
  so the zero-sum boundary cannot arise at all.
* **Additive closure is not the resource either.** The exact requirement is
  that `S` meet the single residue class `-a mod p^{v+1}`.  Any **cofinite**
  `S` has this for free, and every numerical semigroup is cofinite.
* The witness is not merely existent but **reachable within an explicit
  budget**: `b' <= F(S) + p^{v+1}`, where `F` is the Frobenius number.
* Closure under *some* operation is not enough: the multiplicatively closed
  world `{2^k}` fails at `p = 2`, and for odd `p` its fate is decided by the
  multiplicative order of `2` — when `ord_p(2)` is odd (`p = 7, 23, 31, ...`)
  *no pair whatsoever* has a witness.

Uniform exact integer arithmetic throughout.
"""

from __future__ import annotations

from typing import Dict, Iterable, List, Sequence, Set, Tuple

from formation_sufficiency import v_p


# ------------------------------------------------------------- semigroups


def numerical_semigroup(generators: Sequence[int], bound: int) -> Set[int]:
    """All elements of `<generators>` up to `bound` (including 0)."""
    reach = {0}
    frontier = [0]
    while frontier:
        x = frontier.pop()
        for g in generators:
            y = x + g
            if y <= bound and y not in reach:
                reach.add(y)
                frontier.append(y)
    return reach


def frobenius_number(generators: Sequence[int], bound: int | None = None) -> int:
    """Largest integer NOT in `<generators>`; `-1` when the semigroup is all of
    `N`.  Requires `gcd(generators) == 1`.  Brute force, small inputs only."""
    from math import gcd
    from functools import reduce

    if reduce(gcd, generators) != 1:
        raise ValueError("Frobenius number needs coprime generators")
    if bound is None:
        bound = max(generators) ** 2 + max(generators)
    S = numerical_semigroup(generators, bound)
    gaps = [n for n in range(1, bound - max(generators)) if n not in S]
    return max(gaps) if gaps else -1


# ------------------------------------------------------------ the criterion


def witness_target(a: int, b: int, p: int) -> Tuple[int, int]:
    """The residue class a one-sided witness must occupy.

    With `v = v_p(a+b)`, keeping `a` fixed, a witness needs `b'` with
    `b' = -a (mod p^{v+1})`.  That congruence already forces
    `b' = b (mod p^v)`, since `p^v | a+b`.  Returns `(residue, modulus)`.
    """
    v = v_p(a + b, p)
    m = p ** (v + 1)
    return ((-a) % m, m)


def witness_in(
    S: Iterable[int], a: int, b: int, p: int
) -> Tuple[int, int] | None:
    """A witness pair inside `S x S`, or None.  Searches one-sided first
    (perturb `b`), then both sides."""
    Sl = sorted(S)
    r, m = witness_target(a, b, p)
    for bp in Sl:
        if bp % m == r and a + bp != 0:
            return (a, bp)
    v = v_p(a + b, p)
    pv = p**v
    for ap in Sl:
        if ap % pv != a % pv:
            continue
        for bp in Sl:
            if bp % pv != b % pv or ap + bp == 0:
                continue
            if v_p(ap + bp, p) != v:
                return (ap, bp)
    return None


def cofinite_witness(a: int, b: int, p: int, frobenius: int) -> int:
    """The explicit witness for a cofinite world, with its budget.

    Among the `p^(v+1)` consecutive integers `F+1, ..., F+p^(v+1)` exactly one
    lies in the required class, and all of them exceed `F`, hence lie in `S`.
    So a witness always exists with `b' <= F + p^(v+1)`.
    """
    r, m = witness_target(a, b, p)
    bp = frobenius + 1 + ((r - (frobenius + 1)) % m)
    assert bp > frobenius and bp % m == r
    return bp


def transports_everywhere(
    S: Iterable[int], p: int, limit: int | None = None
) -> Dict[str, object]:
    """Check witness regeneration for every pair drawn from `S`."""
    Sl = sorted(x for x in S if x > 0)
    pairs_from = Sl[:limit] if limit is not None else Sl
    failures = []
    for a in pairs_from:
        for b in pairs_from:
            # pairs are limited; the witness is searched in the WHOLE world
            if witness_in(Sl, a, b, p) is None:
                failures.append((a, b))
    return {
        "prime": p,
        "checked_pairs": len(pairs_from) ** 2,
        "search_set": len(Sl),
        "all_transport": not failures,
        "failures": failures[:5],
    }



# ------------------------------------- multiplicative worlds and 2's order


def multiplicative_order(a: int, m: int) -> int:
    """Order of `a` in `(Z/mZ)^*`; requires `gcd(a, m) == 1`."""
    from math import gcd

    if gcd(a, m) != 1:
        raise ValueError("not a unit")
    x, k = a % m, 1
    while x != 1:
        x = (x * a) % m
        k += 1
    return k


def minus_one_is_a_power(base: int, m: int) -> bool:
    """Is `-1` in the cyclic subgroup generated by `base` mod `m`?

    For odd prime powers `(Z/p^k)^*` is cyclic and `-1` is its unique element
    of order two, so this holds exactly when `ord(base)` is even.
    """
    if m <= 2:
        return True
    o = multiplicative_order(base, m)
    return o % 2 == 0 and pow(base, o // 2, m) == m - 1


def multiplicative_world_is_hopeless(base: int, p: int) -> bool:
    """No pair of the world `{base^k}` has a witness, at any depth.

    A witness needs `base^k + base^l = 0 (mod p^(v+1))`, i.e.
    `base^(k-l) = -1`.  If `ord_p(base)` is odd then, because
    `ord_{p^m}(base) = ord_p(base) * p^t` and `p` is odd, every level's order
    stays odd, so `-1` is never a power and no witness ever exists.
    """
    if p == 2:
        return False
    return multiplicative_order(base, p) % 2 == 1


def cyclic_world_witness(base: int, i: int, j: int, p: int) -> Tuple[int, int] | None:
    """Exact one-sided witness in ``{base^n}^2`` for odd ``p``.

    Returns ``(base^i, base^k)`` when ``ord_p(base)`` is even, and ``None``
    when it is odd.  In the even case the order modulo ``p^(v+1)`` remains
    even, so its halfway power is ``-1``.  Choosing ``k`` in that exponent
    class makes the new sum vanish one digit deeper; the original sum already
    vanishes through depth ``v``, so the second coordinates automatically
    agree modulo ``p^v``.
    """
    from math import gcd

    if p == 2 or gcd(base, p) != 1 or i < 0 or j < 0:
        raise ValueError("requires odd p, a unit base, and nonnegative exponents")
    if multiplicative_order(base, p) % 2:
        return None
    a, b = base**i, base**j
    v = v_p(a + b, p)
    modulus = p ** (v + 1)
    order = multiplicative_order(base, modulus)
    assert order % 2 == 0
    k = (i + order // 2) % order
    bp = base**k
    assert bp % p**v == b % p**v
    assert v_p(a + bp, p) > v
    return a, bp


# ------------------------------------------------------------ counterexample


def powers_of(base: int, count: int) -> List[int]:
    """`{base^0, ..., base^(count-1)}` — multiplicatively closed, additively not."""
    return [base**k for k in range(count)]


if __name__ == "__main__":
    p = 2
    print("== numerical semigroups regenerate every witness (negation absent)")
    for gens in ((3, 5), (2, 3), (5, 7, 9), (4, 6, 7)):
        F = frobenius_number(gens)
        S = sorted(x for x in numerical_semigroup(gens, 400) if x > 0)
        rep = transports_everywhere(S, p, limit=18)
        print(
            f"   <{gens}>  Frobenius F={F}  "
            f"all_transport={rep['all_transport']}  "
            f"({rep['checked_pairs']} pairs)"
        )

    print("\n== the witness is reachable within an explicit budget")
    F = frobenius_number((3, 5))
    for (a, b) in ((3, 5), (5, 5), (9, 15), (6, 10)):
        v = v_p(a + b, p)
        bp = cofinite_witness(a, b, p, F)
        print(
            f"   (a,b)=({a},{b}) v={v}: witness b'={bp} "
            f"<= F+p^(v+1) = {F + p**(v+1)}   "
            f"new valuation {v_p(a + bp, p)} > {v}"
        )

    print("\n== closure under SOME operation is not enough: {2^k} at p=2")
    S = powers_of(2, 24)
    print(f"   witness for (2,2): {witness_in(S, 2, 2, 2)}")
    print(f"   elements of S congruent to 2 mod 4: {[x for x in S if x % 4 == 2]}")
    rep = transports_everywhere(S, 2, limit=10)
    print(f"   all_transport={rep['all_transport']}  failures={rep['failures']}")
