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
ever repair the second part.  And a **singleton block is governed entirely by
the first**:

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

    print("\n== consequence for V(f): a singleton block, hence weight-rigid")
    print("   charging the zero locus cannot flip any verdict, so the")
    print("   null-blindness of VALUATION_LENS is combinatorial, not measure-theoretic.")
