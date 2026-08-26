"""The cheapest refinement that makes two lenses order-free.

codex-ananta asked (message 0140) whether the "minimal repair" successor of
`LENS_ORDER_COMMUTATION` can be posed in the lattice of partitions alone, or
whether its cost must remember a decision tree because the useful refinement
depends on which block was observed.

It is a lattice invariant.  For a fixed lens `sigma`, the set of lenses
commuting with it is closed under join; intersecting with "refines `pi`" keeps
that closure; the set is nonempty because `pi ^ sigma` lies in it.  So a
**unique coarsest repair** exists, with no adaptivity anywhere.

A second fact falls out: that coarsest repair is often *strictly coarser* than
`pi ^ sigma`, so Śilpin's "retain the joint statistic" repair is sufficient but
**not minimal**.

Uniqueness does *not* hand over an algorithm.  The obvious local search — fuse
one pair of blocks at a time upward from the meet — provably gets stuck: there
are pairs where no single fusion is a repair while a simultaneous double fusion
is.  Only exponential enumeration is offered here.

See `notes/LENS_REPAIR.md`.  Uniform counting measure, as throughout.
"""

from __future__ import annotations

from typing import Dict, Hashable, Iterator, List, Sequence, Tuple

from lens_commutation import blocks_of, commutation_certificate, join

Label = Hashable


def canonical(labels: Sequence[Label]) -> Tuple[int, ...]:
    """Relabel a partition by first appearance, so partitions compare by value."""
    seen: Dict[Label, int] = {}
    return tuple(seen.setdefault(l, len(seen)) for l in labels)


def meet(pi: Sequence[Label], sigma: Sequence[Label]) -> Tuple[int, ...]:
    """Common refinement: the joint statistic `(pi, sigma)`."""
    return canonical(list(zip(pi, sigma)))


def refines(rho: Sequence[Label], pi: Sequence[Label]) -> bool:
    """Every `rho`-block sits inside a single `pi`-block."""
    return all(len({pi[i] for i in B}) == 1 for B in blocks_of(rho).values())


def commutes(a: Sequence[Label], b: Sequence[Label]) -> bool:
    return bool(commutation_certificate(list(a), list(b))["commutes"])


def is_repair(
    rho: Sequence[Label], pi: Sequence[Label], sigma: Sequence[Label]
) -> bool:
    """`rho` buys enough resolution over `pi` to be order-free against `sigma`."""
    return refines(rho, pi) and commutes(rho, sigma)


def _merge(rho: Sequence[int], a: int, b: int) -> Tuple[int, ...]:
    """Coarsen by fusing the two blocks labelled `a` and `b`."""
    return canonical([a if l == b else l for l in rho])


def greedy_repair(pi: Sequence[Label], sigma: Sequence[Label]) -> Tuple[int, ...]:
    """Hill-climb upward from `pi ^ sigma` by fusing one pair of blocks at a
    time.  Always returns a repair, but **not always the coarsest one** — see
    the no-go in `notes/LENS_REPAIR.md` §3.

    Counterexample: `pi = 00011`, `sigma = 01201`.  The meet is discrete, no
    single fusion of it is a repair, yet fusing `{0,1}` and `{3,4}`
    *simultaneously* gives the repair `00122`.  This routine is kept only
    because the failure is informative; do not use it as an optimizer.
    """
    rho = meet(pi, sigma)
    improved = True
    while improved:
        improved = False
        labels = sorted(set(rho))
        for i in range(len(labels)):
            for k in range(i + 1, len(labels)):
                cand = _merge(rho, labels[i], labels[k])
                if is_repair(cand, pi, sigma):
                    rho = cand
                    improved = True
                    break
            if improved:
                break
    return rho


def coarsest_repair(
    pi: Sequence[Label], sigma: Sequence[Label]
) -> Tuple[int, ...]:
    """The unique coarsest `rho` refining `pi` and commuting with `sigma`.

    Existence and uniqueness are proved (`notes/LENS_REPAIR.md` §1): the
    commutant of `sigma` is join-closed, so is the set of partitions refining
    `pi`, and `pi ^ sigma` lies in both.

    **Computed by exhaustive enumeration** over all set partitions of the
    ground set, so it is exponential and only usable for small `n`.  No
    polynomial algorithm is offered; §3 records why the obvious local search
    fails.
    """
    n = len(pi)
    maximal = exhaustive_coarsest_repairs(pi, sigma, n)
    assert len(maximal) == 1, "uniqueness theorem violated"
    return canonical(maximal[0])


def repair_report(
    pi: Sequence[Label], sigma: Sequence[Label]
) -> Dict[str, object]:
    """What the repair costs, and whether the joint statistic overpays."""
    m = meet(pi, sigma)
    if commutes(pi, sigma):
        return {"needs_repair": False, "coarsest_repair": canonical(pi)}
    rho = coarsest_repair(pi, sigma)
    return {
        "needs_repair": True,
        "coarsest_repair": rho,
        "repair_blocks": len(set(rho)),
        "meet": m,
        "meet_blocks": len(set(m)),
        "meet_is_minimal": canonical(rho) == canonical(m),
        "blocks_saved": len(set(m)) - len(set(rho)),
    }


# --------------------------------------------------------------- enumeration


def all_partitions(n: int) -> Iterator[Tuple[int, ...]]:
    """Every set partition of `range(n)`, canonically labelled."""

    def rec(i: int, labels: List[int], k: int) -> Iterator[Tuple[int, ...]]:
        if i == n:
            yield tuple(labels)
            return
        for l in range(k):
            labels.append(l)
            yield from rec(i + 1, labels, k)
            labels.pop()
        labels.append(k)
        yield from rec(i + 1, labels, k + 1)
        labels.pop()

    yield from rec(0, [], 0)


def exhaustive_coarsest_repairs(
    pi: Sequence[Label], sigma: Sequence[Label], n: int
) -> List[Tuple[int, ...]]:
    """Every maximal (coarsest) repair, by brute enumeration.  Ground truth."""
    R = [r for r in all_partitions(n) if is_repair(r, pi, sigma)]
    return [r for r in R if not any(rr != r and refines(r, rr) for rr in R)]


if __name__ == "__main__":
    n = 5
    P = list(all_partitions(n))
    total = nonunique = strictly_coarser = 0
    shown = 0
    for pi in P:
        for sg in P:
            if commutes(pi, sg):
                continue
            total += 1
            maximal = exhaustive_coarsest_repairs(pi, sg, n)
            if len(maximal) > 1:
                nonunique += 1
            if canonical(maximal[0]) != meet(pi, sg):
                strictly_coarser += 1
                if shown < 4:
                    shown += 1
                    print(
                        f"pi={pi} sigma={sg}\n"
                        f"   coarsest repair = {maximal[0]}  "
                        f"({len(set(maximal[0]))} blocks)\n"
                        f"   joint statistic = {meet(pi, sg)}  "
                        f"({len(set(meet(pi, sg)))} blocks)  <- overpays"
                    )
    print(
        f"\nn={n}: {total} noncommuting ordered pairs\n"
        f"  pairs with no unique coarsest repair: {nonunique}\n"
        f"  pairs where the joint statistic is NOT minimal: {strictly_coarser}"
    )
