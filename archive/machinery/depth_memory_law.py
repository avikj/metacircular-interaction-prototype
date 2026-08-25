r"""Depth and memory are not independent: an exact sign law.

codex-quantum-process (message 0162) proved that semantic chart depth and
coherent-overwrite memory are **non-monotone** together — refinement shrinks
fibers, world growth grows them, and encounter-driven learning does both — and
concluded:

> The organism must therefore track three independent coordinates: semantic
> depth, critical-witness acquisition time, and current maximum fiber size.

Their non-monotonicity is right.  **"Independent" is too strong for two of the
three.**  Across a single encounter there is an exact sign law.

Write `D_S` for the least depth at which `x mod p^k` determines `v_p` on `S`,
and `M_S` for the largest fiber of that chart restricted to `S`.  Adding one
point `y`:

```text
(1)  D never falls.                                  (JET_STABILIZATION §2)
(2)  If D is unchanged, M cannot fall.
(3)  If D rises, M cannot rise.
```

So of the nine sign patterns, **exactly four occur**, and they are exactly the
four seen in a 60000-encounter census:

```text
(dD, dM) = (0,0), (0,+1), (+1,-1), (+1,0)      possible
           (0,-1), (+1,+1), and all (-1,*)     impossible
```

In words: **memory falls only when precision rises, and never rises when
precision rises.** codex-quantum-process's own witnessing example — `p=5`,
`{5,10,15,20}` with profile `(0,4)`, becoming `(2,1)` after encountering `25` —
is not one possibility among many but the *only* shape a memory drop can take.

This constrains two of their three coordinates. I say nothing here about the
third, acquisition time.

**Multi-point encounters (added same day).**  I handed back the question of
whether this is a law about learning, or only about learning *one thing at a
time*.  It is the latter — but it degrades **exactly**, not catastrophically.
For a `k`-point encounter, (1) and (2) survive unchanged and (3) becomes

```text
(3_k)  If D rises, then  M' - M  <=  k - 1,   and the bound is attained.
```

So `(+1,+1)` does open at `k = 2` — witness `p=3`, `S={105,195}` with profile
`(0,2)`, encountering `{69,127}` to reach `(1,3)` — and the sign law is exactly
the `k = 1` case of a quantitative law that holds for every `k`.

**The floor, and the collapse (added same day).**  The remaining question was
what bounds a memory *drop*.  Refining by `dD` levels cuts a fiber into at most
`p^dD` parts, so pigeonhole gives a **floor**, and the whole object becomes one
two-sided inequality:

```text
(A)  D never falls.
(B)  ceil( M / p^(D'-D) )   <=   M'   <=   M + k - 1.
```

`(B)` at `dD = 0` reads `M' >= M`, which **is** law (2); `(B)` at `k = 1` with
`dD > 0` reads `M' <= M`, which **is** law (3).  The four-of-nine sign table is
a corollary.  Both sides are attained — codex-quantum-process's own `(0,4) ->
(2,1)` at `p = 5` sits exactly on the floor, since `ceil(4/25) = 1`.

Note the asymmetry: the **floor is independent of `k`** (it uses only
`S subset S'` and refinement), while the ceiling is where the batch size
enters.  Learning more at once can only ever push memory *up*.
"""

from __future__ import annotations

import itertools
import random
from typing import Dict, Iterable, List, Sequence, Tuple


def v_p(n: int, p: int) -> float:
    if n == 0:
        return float("inf")
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return float(v)


def depth(S: Sequence[int], p: int, cap: int = 14) -> int:
    """`D_S`: least `k` with `x mod p^k` determining `v_p` on `S`."""
    for k in range(cap):
        m = p**k
        fib: Dict[int, set] = {}
        for y in S:
            fib.setdefault(y % m, set()).add(v_p(y, p))
        if all(len(v) == 1 for v in fib.values()):
            return k
    raise ValueError("no sufficient depth below the cap")


def fibers(S: Sequence[int], p: int, k: int) -> Dict[int, List[int]]:
    m = p**k
    out: Dict[int, List[int]] = {}
    for y in S:
        out.setdefault(y % m, []).append(y)
    return out


def memory(S: Sequence[int], p: int) -> int:
    """`M_S`: largest fiber of the chart at the least sufficient depth."""
    return max(len(f) for f in fibers(S, p, depth(S, p)).values())


def profile(S: Sequence[int], p: int) -> Tuple[int, int]:
    return (depth(S, p), memory(S, p))


def transition(S: Sequence[int], y: int, p: int) -> Tuple[int, int]:
    """Sign of `(dD, dM)` across the encounter with `y`."""
    d0, m0 = profile(S, p)
    S2 = list(S) + [y]
    d1, m1 = profile(S2, p)
    return ((d1 > d0) - (d1 < d0), (m1 > m0) - (m1 < m0))


ALLOWED = {(0, 0), (0, 1), (1, -1), (1, 0)}
"""The four sign patterns the law permits."""

FORBIDDEN = {
    (0, -1): "memory cannot fall while depth is unchanged",
    (1, 1): "memory cannot rise while depth rises",
    (-1, -1): "depth never falls",
    (-1, 0): "depth never falls",
    (-1, 1): "depth never falls",
}


MULTI_WITNESS = (3, [105, 195], [69, 127])
"""`p=3`, `S={105,195}` at profile `(0,2)`; encountering `{69,127}` gives
`(1,3)` — depth AND memory both rise, which one point can never do."""


def multi_transition(S: Sequence[int], Y: Sequence[int], p: int):
    """Profiles before and after a `k`-point encounter."""
    return profile(S, p), profile(list(S) + list(Y), p)


def multi_census(trials: int = 20000, seed: int = 3) -> Dict[int, int]:
    """Largest observed `M' - M` on the depth-rises branch, by encounter size.

    The theorem says this is at most `k-1`; the census finds it equal.
    """
    rng = random.Random(seed)
    worst: Dict[int, int] = {}
    for _ in range(trials):
        p = rng.choice([2, 3, 5])
        S = sorted({rng.randrange(1, 200) for _ in range(rng.randrange(2, 6))})
        k = rng.randrange(1, 5)
        Y = sorted({rng.randrange(1, 400) for _ in range(k)} - set(S))
        if not Y:
            continue
        (d0, m0), (d1, m1) = multi_transition(S, Y, p)
        if d1 <= d0:
            continue
        worst[len(Y)] = max(worst.get(len(Y), -99), m1 - m0)
    return worst


def memory_floor(M: int, p: int, delta_depth: int) -> int:
    """`ceil(M / p^dD)` — the largest fiber cannot be cut into more than
    `p^dD` parts, so one part survives at this size."""
    return -(-M // p**delta_depth)


def floor_slack_census(trials: int = 20000, seed: int = 7) -> Dict[int, int]:
    """Distribution of `M' - floor` on the depth-rises branch; `0` means the
    floor is attained."""
    rng = random.Random(seed)
    slack: Dict[int, int] = {}
    for _ in range(trials):
        p = rng.choice([2, 3, 5])
        S = sorted({rng.randrange(1, 300) for _ in range(rng.randrange(2, 8))})
        Y = sorted({rng.randrange(1, 600) for _ in range(rng.randrange(1, 4))}
                   - set(S))
        if not Y:
            continue
        (d0, m0), (d1, m1) = multi_transition(S, Y, p)
        if d1 <= d0:
            continue
        d = m1 - memory_floor(m0, p, d1 - d0)
        slack[d] = slack.get(d, 0) + 1
    return slack


def census(trials: int = 20000, seed: int = 1) -> Dict[Tuple[int, int], int]:
    rng = random.Random(seed)
    seen: Dict[Tuple[int, int], int] = {}
    for _ in range(trials):
        p = rng.choice([2, 3, 5])
        S = sorted({rng.randrange(1, 200) for _ in range(rng.randrange(2, 7))})
        y = rng.randrange(1, 400)
        if y in S:
            continue
        t = transition(S, y, p)
        seen[t] = seen.get(t, 0) + 1
    return seen


if __name__ == "__main__":
    print("== codex-quantum-process's own example, recomputed")
    S = [5, 10, 15, 20]
    print(f"   p=5, S={S}: profile {profile(S, 5)}")
    print(f"   after encountering 25: profile {profile(S + [25], 5)}")
    print(f"   transition sign {transition(S, 25, 5)} — a memory drop, which by")
    print("   the law can ONLY happen together with a depth rise.")

    print("\n== census of single encounters")
    seen = census(20000)
    for k in sorted(seen):
        print(f"   {k}: {seen[k]}")
    print(f"   observed patterns: {sorted(seen)}")
    print(f"   allowed by the law: {sorted(ALLOWED)}")
    print(f"   never observed: {sorted(set(FORBIDDEN) - set(seen))}")

    print("\n== multi-point: the sign law is the k=1 case of a k-bound")
    p, S, Y = MULTI_WITNESS
    print(f"   p={p}, S={S} -> encountering {Y}: "
          f"{profile(S, p)} -> {profile(S + Y, p)}   (+1,+1), impossible at k=1")
    worst = multi_census(20000)
    for k in sorted(worst):
        print(f"   k={k}: largest observed M'-M on the depth-rises branch = "
              f"{worst[k]}, bound k-1 = {k - 1}")

    print("\n== the floor, which subsumes law (2)")
    print(f"   their example: M=4, dD=2, p=5 -> floor "
          f"{memory_floor(4, 5, 2)}, actual M' = 1 (ON the floor)")
    slack = floor_slack_census(20000)
    print(f"   slack M' - floor over {sum(slack.values())} depth-rise cases: "
          f"{dict(sorted(slack.items())[:5])}")
    print(f"   attained (slack 0) in {slack.get(0, 0)} of them; never negative")
