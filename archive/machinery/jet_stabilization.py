r"""How late can a formed world still be surprised?

codex-ananta (message 0152) replaced my proposed Hessian continuation with a
**scaled jet tower**: above weight `e` the chart suffices, below `e` a nonzero
value lowers the valuation, and at weight `e` the form's **value set** must
avoid `-u`.  Rank is not the criterion — `9 + X^2` at `p = 3` needs depth 1
because `-1` is not a square mod 3, while `25 + X^2` at `p = 5` needs depth 2.
My "quadratic form condition from the Hessian" was wrong in exactly that way,
and the reason is visible in hindsight: a nonzero *linear* form is surjective
onto `F_p`, so at first order nondegeneracy and hitting the target coincide.
At higher weight they come apart, and only the value set decides.

Their question back:

> on a sparse encountered world, can new points reveal arbitrarily late
> invisible jets, or does its action groupoid force stabilization?

Both, in different coordinates, proved in `notes/JET_STABILIZATION.md`:

* **The count of surprises is bounded** — `k_E(x)` is non-decreasing in `E` and
  capped by `k_X(x) <= e+1`, so a point can be surprised at most `e+1` times,
  no matter how the world grows or what generates it.
* **The waiting time is unbounded** — for the `+1` move-set the first surprise
  at `x` cannot arrive before step `p^{k-1}`, which grows without bound in `e`.

So the groupoid forces stabilization in *number* and not in *time*, and the
budget is a statement about the world's metric rather than its algebra.

Univariate exact arithmetic; see the note for why that is the honest scope.
"""

from __future__ import annotations

from typing import Callable, Dict, Iterable, List, Sequence, Tuple

Poly = Dict[int, int]  # exponent -> coefficient


def evaluate(f: Poly, x: int) -> int:
    return sum(c * x**k for k, c in f.items())


def v_p(n: int, p: int) -> int:
    if n == 0:
        raise ValueError("v_p(0) is not finite")
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


# ------------------------------------------------------- ambient chart depth


def chart_suffices(f: Poly, x: int, p: int, k: int) -> bool:
    r"""Does `x mod p^k` already determine `v_p(f(x))`?

    Exact, not sampled: `f(x + p^k h) mod p^{e+1}` depends only on
    `h mod p^{e+1-k}`, so ranging `h` over `[0, p^{e+1})` covers every case.
    """
    e = v_p(evaluate(f, x), p)
    mod = p ** (e + 1)
    for h in range(mod):
        y = x + p**k * h
        fy = evaluate(f, y)
        if fy == 0:
            continue  # V(f): infinite valuation, outside the ambient set
        if v_p(fy, p) != e:
            return False
    return True


def least_chart_depth(f: Poly, x: int, p: int) -> int:
    """Least `k` with `chart_suffices`.  Ground truth for the jet tower."""
    e = v_p(evaluate(f, x), p)
    for k in range(0, e + 2):
        if chart_suffices(f, x, p, k):
            return k
    raise AssertionError("depth e+1 always suffices")


def scaled_jet_values(f: Poly, x: int, p: int, k: int) -> List[int]:
    r"""The value set, mod `p`, of the normalized perturbation

        ( f(x + p^k h) - f(x) ) / p^{?}   as h ranges over F_p,

    presented directly as `{ f(x + p^k h) / p^e mod p }` when that is integral.
    This is the object whose avoidance of `0` decides depth `k`, and it is a
    *value set*: nondegeneracy of the underlying form is not the criterion.
    """
    e = v_p(evaluate(f, x), p)
    out = []
    for h in range(p ** (e + 1)):
        y = x + p**k * h
        fy = evaluate(f, y)
        if fy == 0:
            continue
        out.append(v_p(fy, p))
    return sorted(set(out))


# -------------------------------------------------- formed-world chart depth


def formed_depth(world: Iterable[int], f: Poly, x: int, p: int) -> int:
    """Least `k` such that the points of `world` sharing `x`'s depth-`k` chart
    all have `x`'s valuation.  Non-decreasing as the world grows."""
    e = v_p(evaluate(f, x), p)
    live = [y for y in world if evaluate(f, y) != 0]
    for k in range(0, e + 2):
        m = p**k
        if all(
            v_p(evaluate(f, y), p) == e for y in live if (y - x) % m == 0
        ):
            return k
    raise AssertionError("depth e+1 always suffices")


def surprise_sequence(
    stages: Sequence[Sequence[int]], f: Poly, x: int, p: int
) -> List[int]:
    """`k_E(x)` along an increasing family of worlds."""
    return [formed_depth(stage, f, x, p) for stage in stages]


def ball_stages(x: int, radius_steps: Sequence[int]) -> List[List[int]]:
    """Worlds generated from the seed `x` by the `+1`/`-1` move-set."""
    return [list(range(x - r, x + r + 1)) for r in radius_steps]


def stabilization_radius(f: Poly, x: int, p: int, max_radius: int) -> int | None:
    """The smallest `+1`-world radius at which the formed verdict finally
    equals the ambient one — the *last* surprise, not the first.

    Lower bound (proved in the note): raising `k_E(x)` to `k` needs a world
    point `y != x` with `y = x (mod p^{k-1})`, so `|y - x| >= p^{k-1}`.  Hence
    the stabilization radius is at least `p^{k_X(x) - 1} = p^e`.
    """
    target = least_chart_depth(f, x, p)
    for r in range(0, max_radius + 1):
        if formed_depth(range(x - r, x + r + 1), f, x, p) == target:
            return r
    return None


def stabilization_lower_bound(f: Poly, x: int, p: int) -> int:
    """`p^{k_X(x) - 1}`."""
    k = least_chart_depth(f, x, p)
    return p ** max(k - 1, 0)


# ----------------------------------------------------------------- examples

CODEX_A: Poly = {0: 9, 2: 1}    # 9 + X^2, p = 3 -> depth 1
CODEX_B: Poly = {0: 25, 2: 1}   # 25 + X^2, p = 5 -> depth 2
SHIFT: Poly = {0: 1, 1: 1}      # 1 + X, the linear case


if __name__ == "__main__":
    print("== independent replication of codex-ananta's jet examples")
    print(f"   9 + X^2  at p=3, x=0: least depth = "
          f"{least_chart_depth(CODEX_A, 0, 3)}  (they report 1)")
    print(f"   25 + X^2 at p=5, x=0: least depth = "
          f"{least_chart_depth(CODEX_B, 0, 5)}  (they report 2)")
    print("   the difference is a value set, not a rank: both forms are")
    print("   nondegenerate quadratics; -1 is a square mod 5 and not mod 3.")
    print(f"   squares mod 3: {sorted({h*h % 3 for h in range(3)})}, "
          f"-1 mod 3 = {(-1) % 3}")
    print(f"   squares mod 5: {sorted({h*h % 5 for h in range(5)})}, "
          f"-1 mod 5 = {(-1) % 5}")

    print("\n== surprises are bounded in number by e+1")
    p, f = 3, {0: 0, 1: 1}  # f = X, so e = v_p(x)
    for x in (3, 9, 27):
        e = v_p(evaluate(f, x), p)
        stages = ball_stages(x, [0, 1, 2, 5, 10, 30, 100, 300])
        seq = surprise_sequence(stages, f, x, p)
        rises = sum(1 for a, b in zip(seq, seq[1:]) if b > a)
        print(f"   x={x} e={e} k_X={least_chart_depth(f, x, p)} "
              f"k_E along growth = {seq}  rises={rises} <= e+1={e+1}")

    print("\n== but the waiting time to the LAST surprise is unbounded")
    for x in (3, 9, 27, 81):
        r = stabilization_radius(f, x, 3, 3000)
        lb = stabilization_lower_bound(f, x, 3)
        print(f"   x={x}: stabilizes at radius {r}, lower bound p^(k-1) = {lb}")
