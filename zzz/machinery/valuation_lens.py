r"""The bridge: valuation partitions as lenses, and where it breaks.

Two lanes have run in parallel all session.  The **lens lane**
(`LENS_ORDER_COMMUTATION`) asks when two lossy views can be applied in either
order; the **arithmetic lane** (`INFINITE_VALUATION`) studies the depth
function of a valuation observable.  They have met only through vocabulary.

The valuation observable supplies an actual partition, so the bridge is
buildable.  Two things come out, one positive and one a no-go:

* **The criterion generalizes to arbitrary positive weights.**  With
  `w(B) = sum_{y in B} w(y)`, two lenses commute iff
  `w(B cap D) * w(E) = w(B) * w(D)` inside every join block.  The proof is the
  counting one with `w` in place of cardinality.  This discharges my oldest
  open debt (turn 1): the **integrality obstruction dies** under weights, and
  nothing replaces it — an explicit weighted pair commutes while its block
  sizes fail every divisibility test.
* **Valuation lenses at distinct primes always commute** on `Z/N`, by CRT.
  This is a genuine arithmetic instance of the lens criterion.
* **But the `infinity` block is invisible to the lens lane.**  For a nonzero
  one-variable `f`, `V(f)` is finite, hence Haar-null in `Z_p`; an `L^2`
  projection cannot see it.  Meanwhile `INFINITE_VALUATION` §4 proves
  `k_X = infinity` **exactly** on `V(f)`.  So the fiber carrying the sharpest
  arithmetic content is precisely the one the measure-theoretic lens formalism
  discards.  The bridge exists everywhere except where it mattered.

See `notes/VALUATION_LENS.md`.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Callable, Dict, Hashable, List, Sequence, Tuple

Label = Hashable


def blocks_of(labels: Sequence[Label]) -> Dict[Label, List[int]]:
    out: Dict[Label, List[int]] = {}
    for x, lab in enumerate(labels):
        out.setdefault(lab, []).append(x)
    return out


def join(pi: Sequence[Label], sigma: Sequence[Label]) -> List[int]:
    n = len(pi)
    parent = list(range(n))

    def find(a: int) -> int:
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    for labels in (pi, sigma):
        first: Dict[Label, int] = {}
        for x, lab in enumerate(labels):
            if lab in first:
                ra, rb = find(x), find(first[lab])
                if ra != rb:
                    parent[ra] = rb
            else:
                first[lab] = x
    return [find(x) for x in range(n)]


# ------------------------------------------------------- weighted machinery


def wsum(weight: Sequence[Fraction], idx: Sequence[int]) -> Fraction:
    return sum((weight[i] for i in idx), Fraction(0))


def weighted_commutes(
    pi: Sequence[Label], sigma: Sequence[Label], weight: Sequence[Fraction]
) -> bool:
    r"""`w(B cap D) * w(E) = w(B) * w(D)` for blocks inside each join block.

    Same statement as `LENS_ORDER_COMMUTATION` `(*)` with the weight of a block
    replacing its cardinality; the incidence-graph proof carries over verbatim
    because it uses only positivity.
    """
    j = join(pi, sigma)
    jb, pb, sb = blocks_of(j), blocks_of(pi), blocks_of(sigma)
    pi_in: Dict[Label, List[Label]] = {}
    for lab, B in pb.items():
        pi_in.setdefault(j[B[0]], []).append(lab)
    sg_in: Dict[Label, List[Label]] = {}
    for lab, D in sb.items():
        sg_in.setdefault(j[D[0]], []).append(lab)
    for e, E in jb.items():
        wE = wsum(weight, E)
        for bl in pi_in.get(e, []):
            B = pb[bl]
            wB = wsum(weight, B)
            for dl in sg_in.get(e, []):
                D = sb[dl]
                inter = [y for y in B if y in set(D)]
                if wsum(weight, inter) * wE != wB * wsum(weight, D):
                    return False
    return True


def weighted_projection(
    labels: Sequence[Label], weight: Sequence[Fraction]
) -> List[List[Fraction]]:
    """The `L^2(w)` orthogonal projection onto `labels`-measurable signals."""
    n = len(labels)
    M = [[Fraction(0)] * n for _ in range(n)]
    for B in blocks_of(labels).values():
        tot = wsum(weight, B)
        for x in B:
            for y in B:
                M[x][y] = weight[y] / tot
    return M


def matmul(A, B):
    n = len(A)
    return [
        [sum((A[i][k] * B[k][j] for k in range(n)), Fraction(0)) for j in range(n)]
        for i in range(n)
    ]


def brute_weighted_commutes(pi, sigma, weight) -> bool:
    P, Q = weighted_projection(pi, weight), weighted_projection(sigma, weight)
    return matmul(P, Q) == matmul(Q, P)


# ---------------------------------------------------- valuation lenses on Z/N


def v_p_capped(x: int, p: int, cap: int) -> int:
    """`min(v_p(x), cap)`; `x = 0` saturates at `cap`."""
    if x == 0:
        return cap
    v = 0
    while x % p == 0 and v < cap:
        x //= p
        v += 1
    return v


def valuation_lens(N: int, p: int, cap: int) -> List[int]:
    return [v_p_capped(x, p, cap) for x in range(N)]


def residue_lens(N: int, m: int) -> List[int]:
    return [x % m for x in range(N)]


if __name__ == "__main__":
    print("== valuation lenses at distinct primes commute (CRT)")
    for (p, a, q, b) in ((2, 3, 3, 2), (2, 2, 5, 2), (3, 2, 5, 1), (2, 4, 7, 1)):
        N = p**a * q**b
        pi, sg = valuation_lens(N, p, a), valuation_lens(N, q, b)
        w = [Fraction(1)] * N
        print(f"   N={p}^{a}*{q}^{b}={N}: commutes={weighted_commutes(pi, sg, w)}")

    print("\n== a valuation lens against a residue lens can fail")
    N = 24
    pi = valuation_lens(N, 2, 3)
    for m in (3, 5, 7):
        sg = residue_lens(N, m)
        w = [Fraction(1)] * N
        print(f"   N=24, v_2 vs (mod {m}): commutes={weighted_commutes(pi, sg, w)}")

    print("\n== the integrality obstruction dies under weights")
    # a pair whose block SIZES can never satisfy the counting criterion
    pi = [0, 0, 0, 1, 1]
    sg = [0, 1, 1, 0, 1]
    uni = [Fraction(1)] * 5
    print(f"   uniform: commutes={weighted_commutes(pi, sg, uni)}"
          f"  (block sizes 3,2 vs 2,3 in a 5-element join block:"
          f" 3*2/5 = 6/5 is not an integer)")
    # solving the criterion for this pair reduces to  a*e = d*(b+c)
    for ws in ([1, 1, 1, 1, 2], [2, 1, 1, 1, 1], [1, 2, 3, 1, 5], [3, 1, 1, 2, 4]):
        w = [Fraction(t) for t in ws]
        ok = weighted_commutes(pi, sg, w)
        print(f"   weights {ws}: commutes={ok}"
              f"  brute={brute_weighted_commutes(pi, sg, w)}"
              f"  a*e==d*(b+c): {ws[0]*ws[4] == ws[3]*(ws[1]+ws[2])}")
    print("   so the SAME partition pair commutes for suitable weights:")
    print("   no divisibility statement can survive reweighting.")

    print("\n== the infinity block is Haar-null, hence lens-invisible")
    for m in (1, 2, 3, 4, 8, 16):
        N = 2**m
        top = 1  # only x = 0 has v_2 capped at m
        print(f"   Z/2^{m}: relative weight of the top valuation block = "
              f"{Fraction(top, N)}")
