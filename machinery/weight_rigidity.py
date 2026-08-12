r"""What reweighting can and cannot repair.

In message 0162 I asked whether the null-blindness of the lens lane at `V(f)`
is repairable by changing the formalism, and flagged that I could not tell
whether that was a real question or a wish.  It is a real question with a
definite answer, and the answer is **no** — for a reason that closes the arc
back to my first note.

The commutation criterion `w(B cap D) w(E) = w(B) w(D)` splits into two parts:

* **permutability** — every `sigma`-block in a join block meets every
  `pi`-block there.  This is **weight-independent**: it is a statement about
  which overlaps are empty, and no positive reweighting changes emptiness.
  It is also *necessary*, since `w(B)w(D) > 0` always.
* **equidistribution** — the numeric identity among the nonzero overlaps.
  This is exactly what reweighting moves.

So reweighting is a genuine tool — verdicts really do flip — but it can only
ever repair the second part.  In fact it always repairs it:

**Completion theorem.**  A positive weight making `pi` and `sigma` commute
exists **iff** they are permutable.  So *across all weights* the criterion is
exactly permutability, and every numeric condition is a measure artifact.

**Solution-variety theorem.**  More: a weight commutes iff the cell-mass matrix
is **rank one** in every join block.  So the commuting weights are exactly the
outer products, with the within-cell distribution entirely free, and the
numeric constraints have codimension `sum_E (r_E-1)(s_E-1)`.

And a **singleton block is governed entirely by the rigid part**:

**Singleton rigidity.** If `B = {b}` is a singleton block of `pi` with join
block `E`, then for *every* positive weight, commutation requires
`E = D(b)`, the `sigma`-block of `b`.  When that fails, no weight commutes.

`V(f)` is a singleton (or finite) block of the valuation lens.  Hence charging
the zero locus cannot flip any verdict, and the null-blindness of
`VALUATION_LENS` §4 is not a defect of Haar measure that a different measure
repairs — it is combinatorial.

This is the permutability/equidistribution separation of
`LENS_ORDER_COMMUTATION` §2 reappearing as the boundary between what a
reweighting can and cannot fix.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Dict, Hashable, List, Sequence, Tuple

from valuation_lens import blocks_of, join, weighted_commutes, wsum

Label = Hashable


def _grouped(labels: Sequence[Label], j: Sequence[int]) -> Dict[int, List[List[int]]]:
    out: Dict[int, List[List[int]]] = {}
    for B in blocks_of(labels).values():
        out.setdefault(j[B[0]], []).append(B)
    return out


def permutable(pi: Sequence[Label], sigma: Sequence[Label]) -> bool:
    """Every `sigma`-block meets every `pi`-block inside each join block.

    Weight-independent, and necessary for commutation under any positive
    weight: `(*)` demands `w(B cap D) w(E) = w(B) w(D) > 0`.
    """
    j = join(pi, sigma)
    pin, sin = _grouped(pi, j), _grouped(sigma, j)
    for e in blocks_of(j):
        for B in pin.get(e, []):
            for D in sin.get(e, []):
                if not (set(B) & set(D)):
                    return False
    return True


def singleton_rigidity_violations(
    pi: Sequence[Label], sigma: Sequence[Label]
) -> List[Tuple[int, str]]:
    """Singleton `pi`-blocks whose join block is not their `sigma`-block.

    Each such point is a weight-independent obstruction: no positive weight
    can make the pair commute.
    """
    j = join(pi, sigma)
    jb, sb = blocks_of(j), blocks_of(sigma)
    out = []
    for B in blocks_of(pi).values():
        if len(B) != 1:
            continue
        b = B[0]
        if set(jb[j[b]]) != set(sb[sigma[b]]):
            out.append((b, "join block != sigma block"))
    return out


def weight_can_repair(
    pi: Sequence[Label], sigma: Sequence[Label]
) -> Dict[str, object]:
    """Is there any hope of a positive weight making these commute?

    Returns the weight-independent verdict.  `possible = False` is a proof of
    impossibility for every weight; `possible = True` means only that the
    combinatorial obstruction is absent, not that a weight exists.
    """
    perm = permutable(pi, sigma)
    viol = singleton_rigidity_violations(pi, sigma)
    return {
        "permutable": perm,
        "singleton_violations": viol,
        "possible": perm and not viol,
    }


def equalizing_weight(
    pi: Sequence[Label], sigma: Sequence[Label]
) -> List[Fraction]:
    r"""Give every nonempty cell `B cap D` total mass `1`.

    Each point of a cell of size `k` receives weight `1/k`.  This is the
    witness for the completion theorem: whenever `pi` and `sigma` are
    permutable, THIS weight makes them commute.
    """
    n = len(pi)
    cells: Dict[Tuple[Label, Label], List[int]] = {}
    for x in range(n):
        cells.setdefault((pi[x], sigma[x]), []).append(x)
    w: List[Fraction] = [Fraction(0)] * n
    for pts in cells.values():
        for x in pts:
            w[x] = Fraction(1, len(pts))
    return w


def weight_exists(pi: Sequence[Label], sigma: Sequence[Label]) -> bool:
    r"""**Completion theorem.**  A positive weight making `pi` and `sigma`
    commute exists **iff** they are permutable.

    Necessity is the proposition above.  Sufficiency: inside a join block `E`
    with `r` blocks of `pi` and `s` of `sigma`, permutability makes every cell
    nonempty, so `equalizing_weight` gives `w(B_i) = s`, `w(D_j) = r`,
    `w(E) = rs`, and

        w(B_i cap D_j) * w(E) = 1 * rs = s * r = w(B_i) * w(D_j).

    So across all weights the criterion is **exactly permutability** — a purely
    universal-algebraic condition.  Everything numeric in the fixed-measure
    criterion is an artifact of the measure.
    """
    return permutable(pi, sigma)


# ------------------------------------------- the full solution variety


def cell_matrices(
    pi: Sequence[Label], sigma: Sequence[Label], weight: Sequence[Fraction]
) -> List[List[List[Fraction]]]:
    """Per join block, the matrix of cell masses `w(B_i cap D_j)`."""
    j = join(pi, sigma)
    out = []
    for E in blocks_of(j).values():
        Bs = sorted({pi[x] for x in E}, key=str)
        Ds = sorted({sigma[x] for x in E}, key=str)
        out.append(
            [
                [
                    sum(
                        (weight[x] for x in E if pi[x] == b and sigma[x] == d),
                        Fraction(0),
                    )
                    for d in Ds
                ]
                for b in Bs
            ]
        )
    return out


def is_rank_one(M: Sequence[Sequence[Fraction]]) -> bool:
    """Exact: every `2x2` minor vanishes."""
    r, c = len(M), len(M[0])
    for i in range(r):
        for k in range(i + 1, r):
            for a in range(c):
                for b in range(a + 1, c):
                    if M[i][a] * M[k][b] - M[i][b] * M[k][a] != 0:
                        return False
    return True


def commutes_by_rank(
    pi: Sequence[Label], sigma: Sequence[Label], weight: Sequence[Fraction]
) -> bool:
    r"""**Solution-variety theorem.**  A positive weight makes `pi` and `sigma`
    commute iff they are permutable and, in every join block, the matrix of
    cell masses has **rank one**.

    *Proof.*  `(*)` says `c_ij = beta_i delta_j / T`, which is literally the
    outer product of `beta` with `delta/T`; conversely an outer product
    `c_ij = u_i v_j` gives `beta_i = u_i sum(v)`, `delta_j = v_j sum(u)`,
    `T = sum(u) sum(v)`, so `beta_i delta_j / T = u_i v_j = c_ij`. ∎

    So the commuting weights are exactly: choose a positive outer product of
    cell masses in each join block, then distribute each cell's mass among its
    points however you like.  The within-cell distribution is entirely free.

    **Codimension.**  Rank-one positive `r x s` matrices form an
    `(r+s-1)`-dimensional family inside `rs`, so the numeric constraints have
    codimension exactly `sum_E (r_E - 1)(s_E - 1)` in the weight space.  A join
    block with a single block on either side imposes nothing.
    """
    return permutable(pi, sigma) and all(
        is_rank_one(M) for M in cell_matrices(pi, sigma, weight)
    )


def codimension(pi: Sequence[Label], sigma: Sequence[Label]) -> int:
    """`sum_E (r_E - 1)(s_E - 1)` — how many independent numeric constraints
    the criterion imposes on the weight."""
    j = join(pi, sigma)
    total = 0
    for E in blocks_of(j).values():
        r = len({pi[x] for x in E})
        s = len({sigma[x] for x in E})
        total += (r - 1) * (s - 1)
    return total


if __name__ == "__main__":
    import random

    rng = random.Random(3)

    print("== permutability is necessary, for every weight")
    bad = 0
    for _ in range(2000):
        n = rng.choice([4, 5, 6])
        pi = [rng.randrange(rng.choice([2, 3])) for _ in range(n)]
        sg = [rng.randrange(rng.choice([2, 3])) for _ in range(n)]
        if permutable(pi, sg):
            continue
        for _ in range(6):
            w = [Fraction(rng.randrange(1, 9)) for _ in range(n)]
            if weighted_commutes(pi, sg, w):
                bad += 1
    print(f"   non-permutable pairs that commuted under some weight: {bad}")

    print("\n== but equidistribution is weight-dependent: verdicts flip")
    pi, sg = [0, 0, 0, 1, 1], [0, 1, 1, 0, 1]
    print(f"   pi={pi} sigma={sg}  permutable={permutable(pi, sg)}")
    for ws in ([1, 1, 1, 1, 1], [1, 1, 1, 1, 2]):
        w = [Fraction(t) for t in ws]
        print(f"   weights {ws}: commutes={weighted_commutes(pi, sg, w)}")

    print("\n== singleton rigidity: a lone block cannot be repaired by weight")
    pi = [0, 1, 1, 1]   # {0} is a singleton block
    sg = [0, 0, 1, 1]
    rep = weight_can_repair(pi, sg)
    print(f"   pi={pi} sigma={sg} -> {rep}")
    for _ in range(6):
        w = [Fraction(rng.randrange(1, 9)) for _ in range(4)]
        assert not weighted_commutes(pi, sg, w)
    print("   confirmed: no weight commutes")

    print("\n== completion theorem: permutable => a weight exists, constructively")
    pi, sg = [0, 0, 0, 1, 1], [0, 1, 1, 0, 1]
    w = equalizing_weight(pi, sg)
    print(f"   pi={pi} sigma={sg}  equalizing weight {w}")
    print(f"   commutes={weighted_commutes(pi, sg, w)}  (counting measure: False)")
    checked = repaired = 0
    for _ in range(3000):
        n = rng.choice([4, 5, 6, 7])
        a = [rng.randrange(rng.choice([2, 3, 4])) for _ in range(n)]
        b = [rng.randrange(rng.choice([2, 3, 4])) for _ in range(n)]
        if not permutable(a, b):
            continue
        checked += 1
        if weighted_commutes(a, b, equalizing_weight(a, b)):
            repaired += 1
    print(f"   permutable pairs {checked}, equalizing weight worked on {repaired}")

    print("\n== consequence for V(f): a singleton block, hence weight-rigid")
    print("   charging the zero locus cannot flip any verdict, so the")
    print("   null-blindness of VALUATION_LENS is combinatorial, not measure-theoretic.")
