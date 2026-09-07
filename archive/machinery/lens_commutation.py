"""When does the order of two lossy lenses not matter?

A *lens* on a finite set `X` is a partition `pi`.  Studying `X` through that
lens replaces a rational signal `f : X -> Q` by its fiberwise average

    (P_pi f)(x) = (1/|B(x)|) * sum_{y in B(x)} f(y),

the orthogonal projection of `l^2(X)` (uniform counting measure) onto the
`pi`-measurable signals.  Śilpin's `collab/messages/shilpin/order_sensitive_transfer.md`
observed that two such lenses on `Z/1000Z` fail to commute.  This module
supplies the exact criterion, the closed-form commutator, and a cheap
integrality obstruction that decides many instances without touching a matrix.

Everything is exact rational arithmetic.  Uniform counting measure only.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Callable, Dict, Hashable, List, Sequence, Tuple

Label = Hashable


# ---------------------------------------------------------------- partitions


def blocks_of(labels: Sequence[Label]) -> Dict[Label, List[int]]:
    """Group the index set `range(len(labels))` by its label."""
    out: Dict[Label, List[int]] = {}
    for x, lab in enumerate(labels):
        out.setdefault(lab, []).append(x)
    return out


def partition_from(n: int, f: Callable[[int], Label]) -> List[Label]:
    return [f(x) for x in range(n)]


def join(pi: Sequence[Label], sigma: Sequence[Label]) -> List[int]:
    """Finest partition coarser than both: connected components of the
    block-intersection graph.  (The *join* in the partition lattice ordered
    by refinement; NOT the common refinement.)"""
    n = len(pi)
    parent = list(range(n))

    def find(a: int) -> int:
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    def union(a: int, b: int) -> None:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb

    for labels in (pi, sigma):
        first: Dict[Label, int] = {}
        for x, lab in enumerate(labels):
            if lab in first:
                union(x, first[lab])
            else:
                first[lab] = x
    return [find(x) for x in range(n)]


# ------------------------------------------------------- closed-form entries


def compose_entry(
    pi: Sequence[Label], sigma: Sequence[Label], x: int, z: int
) -> Fraction:
    """Entry `(P_pi P_sigma)[x, z]` with no matrix multiplication.

    Derivation.  `P_pi[x,y] = [y ~pi x]/|B(x)|` and `P_sigma[y,z] =
    [z ~sigma y]/|D(z)|`, so summing over `y` counts `B(x) cap D(z)`:

        (P_pi P_sigma)[x, z] = |B(x) cap D(z)| / (|B(x)| * |D(z)|).
    """
    B = blocks_of(pi)[pi[x]]
    D = blocks_of(sigma)[sigma[z]]
    Dset = set(D)
    meet = sum(1 for y in B if y in Dset)
    return Fraction(meet, len(B) * len(D))


def commutator_entry(
    pi: Sequence[Label], sigma: Sequence[Label], x: int, z: int
) -> Fraction:
    """Entry `([P_pi, P_sigma])[x, z] = (P_pi P_sigma - P_sigma P_pi)[x, z]`."""
    return compose_entry(pi, sigma, x, z) - compose_entry(sigma, pi, x, z)


def commutator_column(
    pi: Sequence[Label], sigma: Sequence[Label], z: int
) -> List[Fraction]:
    """The full column `[P_pi, P_sigma] e_z`, exactly."""
    return [commutator_entry(pi, sigma, x, z) for x in range(len(pi))]


# ------------------------------------------------------------- the criterion


def _nonzero_entry(
    pi: Sequence[Label],
    sigma: Sequence[Label],
    B: Sequence[int],
    D: Sequence[int],
) -> Tuple[int, int, Fraction] | None:
    """A concrete `(x, z)` with `[P_pi, P_sigma][x, z] != 0`.

    Searched, not derived: the counting criterion already certifies
    noncommutation, and this only exhibits a visible entry.  Looks inside the
    offending blocks first, then everywhere.
    """
    n = len(pi)
    for xs, zs in ((B, D), (range(n), range(n))):
        for x in xs:
            for z in zs:
                v = commutator_entry(pi, sigma, x, z)
                if v != 0:
                    return (x, z, v)
    return None


def commutation_certificate(
    pi: Sequence[Label], sigma: Sequence[Label]
) -> Dict[str, object]:
    """Decide `P_pi P_sigma == P_sigma P_pi` and return a certificate.

    Theorem (see notes/LENS_ORDER_COMMUTATION.md).  The two averaging
    projections commute iff for every block `E` of the join `pi v sigma`,
    every `pi`-block `B subset E` and `sigma`-block `D subset E` satisfy

        |B cap D| * |E| == |B| * |D|.

    This is simultaneously (i) permutability of the two equivalence relations,
    since the right side is nonzero, and (ii) equidistribution of each block
    across the other lens inside its join block.
    """
    j = join(pi, sigma)
    jb = blocks_of(j)
    pb = blocks_of(pi)
    sb = blocks_of(sigma)

    # every pi/sigma block lies inside a single join block by construction
    pi_in: Dict[Label, List[Label]] = {}
    for lab, B in pb.items():
        pi_in.setdefault(j[B[0]], []).append(lab)
    sg_in: Dict[Label, List[Label]] = {}
    for lab, D in sb.items():
        sg_in.setdefault(j[D[0]], []).append(lab)

    for e, E in jb.items():
        nE = len(E)
        for blab in pi_in.get(e, []):
            B = pb[blab]
            for dlab in sg_in.get(e, []):
                D = sb[dlab]
                Dset = set(D)
                meet = sum(1 for y in B if y in Dset)
                if meet * nE != len(B) * len(D):
                    x, z = B[0], D[0]
                    return {
                        "commutes": False,
                        "reason": "empty overlap (congruences do not permute)"
                        if meet == 0
                        else "block sizes not equidistributed in the join block",
                        "witness_blocks": {
                            "join_block_size": nE,
                            "pi_block_size": len(B),
                            "sigma_block_size": len(D),
                            "overlap": meet,
                            "required_overlap": Fraction(len(B) * len(D), nE),
                        },
                        "witness_entry": _nonzero_entry(pi, sigma, B, D),
                    }
    return {"commutes": True, "join_blocks": len(jb)}


def integrality_obstruction(
    pi: Sequence[Label], sigma: Sequence[Label]
) -> Dict[str, object] | None:
    """Size-only no-go.  If `|B| * |D|` is not divisible by `|E|` for some
    `pi`-block `B` and `sigma`-block `D` inside the same join block `E`, the
    required overlap is not an integer, so the lenses provably do not commute.

    Costs only the block sizes: no overlap counting, no linear algebra.
    """
    j = join(pi, sigma)
    sizes_j = {lab: len(B) for lab, B in blocks_of(j).items()}
    pb, sb = blocks_of(pi), blocks_of(sigma)
    pi_in: Dict[Label, List[int]] = {}
    for B in pb.values():
        pi_in.setdefault(j[B[0]], []).append(len(B))
    sg_in: Dict[Label, List[int]] = {}
    for D in sb.values():
        sg_in.setdefault(j[D[0]], []).append(len(D))

    for e, nE in sizes_j.items():
        for b in pi_in.get(e, []):
            for d in sg_in.get(e, []):
                if (b * d) % nE != 0:
                    return {
                        "join_block_size": nE,
                        "pi_block_size": b,
                        "sigma_block_size": d,
                        "required_overlap": Fraction(b * d, nE),
                    }
    return None


def family_is_order_free(lenses: Sequence[Sequence[Label]]) -> Dict[str, object]:
    """Decide whether a whole family of lenses can be studied in any order.

    Theorem (notes/LENS_ORDER_COMMUTATION.md §2.1): if the lenses commute
    pairwise, then every product of their projections, in every order, equals
    the single projection onto their join.  So the family forgets exactly the
    join and order is free; otherwise the first offending pair is returned.
    """
    for i in range(len(lenses)):
        for k in range(i + 1, len(lenses)):
            cert = commutation_certificate(lenses[i], lenses[k])
            if not cert["commutes"]:
                return {"order_free": False, "offending_pair": (i, k), **cert}
    j: List[Label] = list(lenses[0]) if lenses else []
    for other in lenses[1:]:
        j = list(join(j, other))
    return {"order_free": True, "net_lens": j, "net_blocks": len(blocks_of(j))}


# ------------------------------------------------------------------ examples


def crt_lenses(m: int, n: int) -> Tuple[List[Label], List[Label]]:
    """The README's two residue views of `Z/(mn)Z`: `x mod m` and `x mod n`."""
    N = m * n
    return (
        partition_from(N, lambda x: x % m),
        partition_from(N, lambda x: x % n),
    )


def idempotent_lenses(N: int = 1000) -> Tuple[List[Label], List[Label]]:
    """Śilpin's pair on `Z/NZ` for `F(x) = x^2 - x`:
    the decimal lens `x mod 10` and the decomposition lens
    `(F(x) = 0 mod 8, F(x) = 0 mod 125)`."""
    def F(x: int) -> int:
        return (x * x - x) % N

    return (
        partition_from(N, lambda x: x % 10),
        partition_from(N, lambda x: (F(x) % 8 == 0, F(x) % 125 == 0)),
    )


def _report(title: str, pi: Sequence[Label], sigma: Sequence[Label]) -> None:
    print(f"== {title}")
    obs = integrality_obstruction(pi, sigma)
    cert = commutation_certificate(pi, sigma)
    print(f"   size-only obstruction: {obs}")
    print(f"   certificate:           {cert}")


if __name__ == "__main__":
    for m, n in ((3, 5), (4, 6), (6, 10), (12, 18)):
        pi, sigma = crt_lenses(m, n)
        _report(f"CRT lenses mod {m} and mod {n} on Z/{m*n}Z", pi, sigma)

    pi, sigma = idempotent_lenses(1000)
    _report("decimal vs 8/125-decomposition lens on Z/1000Z", pi, sigma)
    col = commutator_column(pi, sigma, 0)
    print(f"   (P_L P_C e_0)(5)   = {compose_entry(pi, sigma, 5, 0)}")
    print(f"   (P_C P_L e_0)(5)   = {compose_entry(sigma, pi, 5, 0)}")
    print(f"   [P_L,P_C]e_0 at 5  = {col[5]}")
    print(f"   [P_L,P_C]e_0 at 2  = {col[2]}")
    print(f"   nonzero entries    = {sum(1 for v in col if v != 0)} / {len(col)}")
