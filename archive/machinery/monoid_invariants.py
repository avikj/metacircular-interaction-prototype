r"""The witness can need a maximal-rank map, so kernel invariants are blind.

`AFFINE_EMERGENCE` seed 1, my own and the last genuinely open mathematical
question I was carrying: last turn I proved no criterion for hitting can be
phrased on the generators one coordinate at a time, and suggested the real
criterion might live in the **structure of the generated monoid** — "an
idempotent, a kernel, a minimal ideal".

It does not. Both invariants I named fail, and the reason is one sentence.

**The mechanism.**  The minimal ideal (kernel) of a finite transformation
monoid consists of its **minimal-rank** elements.  Reaching the witness may
require a map of **maximal** rank.  Nothing computed from the kernel can see
such a map.

**The worked example.**  `p = 2`, `e = 1`, mod `4`, from `s = 2`, with moves
`A : y -> 1` and `B : y -> 3y + 2`.  The generated monoid is

```text
(1,0)  identity     image {0,1,2,3}  rank 4   s -> 2
(0,1)  constant 1   image {1}        rank 1   s -> 1
(3,2)  y -> 3y+2    image {0,1,2,3}  rank 4   s -> 0    <- hits
```

The kernel is `{(0,1)}`, the constant map, whose only image is `1`.  The map
that reaches `0` is `(3,2)`, a **bijection** — the furthest thing from the
kernel.  So `0` is reachable while the kernel-image criterion says no.

**Census.**  Over all affine pairs at `(p,e) = (2,1), (3,1), (2,2)` — 5376
pairs — the kernel-image criterion gives the wrong verdict on **479**, and the
idempotent-image criterion on **2378**.

So after two turns the situation is: reachability of the witness is decidable
(`HITTING_DECIDABLE` §1, `AFFINE_EMERGENCE` §1) and **not** captured by
generator-wise conditions (last turn) or by the standard finite-monoid
invariants of eventual behaviour (this note).  The orbit of `s` is the answer,
and I no longer expect a coarser one.
"""

from __future__ import annotations

import itertools
from typing import FrozenSet, List, Sequence, Set, Tuple

from affine_emergence import compose, generated_monoid

Affine = Tuple[int, int]


def image(m: Affine, mod: int) -> Set[int]:
    return {(m[0] * y + m[1]) % mod for y in range(mod)}


def rank(m: Affine, mod: int) -> int:
    return len(image(m, mod))


def kernel(monoid: Set[Affine], mod: int) -> FrozenSet[Affine]:
    """The minimal two-sided ideal of a finite monoid: `min_m M m M`.

    For a transformation monoid this is exactly the set of minimal-rank
    elements, which is why it describes eventual behaviour and misses
    transient reachability.
    """
    ideals = [
        frozenset(
            compose(compose(a, m, mod), b, mod) for a in monoid for b in monoid
        )
        for m in monoid
    ]
    return min(ideals, key=len)


def idempotents(monoid: Set[Affine], mod: int) -> Set[Affine]:
    return {m for m in monoid if compose(m, m, mod) == m}


def orbit(monoid: Set[Affine], s: int, mod: int) -> Set[int]:
    return {(g * s + c) % mod for g, c in monoid}


def hits_by_orbit(moves: Sequence[Affine], p: int, e: int) -> bool:
    mod = p ** (e + 1)
    return 0 in orbit(generated_monoid(list(moves), mod), p**e, mod)


def kernel_image_says_hits(moves: Sequence[Affine], p: int, e: int) -> bool:
    """The criterion I proposed. **Wrong** — see the census."""
    mod = p ** (e + 1)
    M = generated_monoid(list(moves), mod)
    return 0 in orbit(set(kernel(M, mod)), p**e, mod)


def idempotent_image_says_hits(moves: Sequence[Affine], p: int, e: int) -> bool:
    """The other criterion I proposed. **Also wrong.**"""
    mod = p ** (e + 1)
    M = generated_monoid(list(moves), mod)
    return 0 in orbit(idempotents(M, mod), p**e, mod)


def census(p: int, e: int, limit: int | None = None) -> dict:
    """How often do the two proposed invariants misreport?

    `limit` caps the number of pairs examined (deterministically, by
    enumeration order) — the full sweep at mod 9 is slow.
    """
    mod = p ** (e + 1)
    pool = [(g, c) for g in range(mod) for c in range(mod)]
    bad_k = bad_i = total = 0
    pairs = itertools.combinations(pool, 2)
    if limit is not None:
        pairs = itertools.islice(pairs, limit)
    for pr in pairs:
        truth = hits_by_orbit(pr, p, e)
        total += 1
        if truth != kernel_image_says_hits(pr, p, e):
            bad_k += 1
        if truth != idempotent_image_says_hits(pr, p, e):
            bad_i += 1
    return {"pairs": total, "kernel_wrong": bad_k, "idempotent_wrong": bad_i}


WORKED: Tuple[Affine, Affine] = ((0, 1), (3, 2))
"""`A : y -> 1` and `B : y -> 3y+2` mod 4.  Kernel is the constant map; the
map that reaches `0` from `2` is the bijection `B`."""


if __name__ == "__main__":
    mod, s = 4, 2
    A, B = WORKED
    M = generated_monoid([A, B], mod)
    print("== the worked example: monoid, ranks, and what each does to s=2")
    for m in sorted(M):
        print(f"   {m}: image {sorted(image(m, mod))} rank {rank(m, mod)}"
              f"   s -> {(m[0]*s + m[1]) % mod}")
    K = kernel(M, mod)
    print(f"   kernel {sorted(K)}  (rank "
          f"{ {rank(m, mod) for m in K} })  images of s: "
          f"{sorted(orbit(set(K), s, mod))}")
    hitters = [m for m in M if (m[0] * s + m[1]) % mod == 0]
    print(f"   maps that hit: {hitters}, of rank "
          f"{[rank(m, mod) for m in hitters]} — MAXIMAL, not minimal")

    print("\n== census: both proposed invariants misreport")
    print("   mod 4 is the full sweep; the others are capped for speed")
    for p, e, lim in ((2, 1, None), (2, 2, 400), (3, 1, 400)):
        c = census(p, e, lim)
        print(f"   mod {p**(e+1)}: of {c['pairs']} pairs, kernel-image wrong "
              f"{c['kernel_wrong']}, idempotent-image wrong "
              f"{c['idempotent_wrong']}")
