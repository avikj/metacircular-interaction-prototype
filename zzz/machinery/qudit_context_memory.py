#!/usr/bin/env python3
"""Weyl--Heisenberg memory over an odd prime, exactly.

The qubit case lives in ``machinery/pauli_context_memory.py``.  This module
runs the same construction over ``Z_d`` for odd prime ``d``, where ``2`` is
invertible and the multiplier behaves differently.  All arithmetic is in
``Z_d``: phases are *exponents* of a primitive ``d``-th root of unity, never
floating-point roots.

Convention.  With ``X|j> = |j+1>``, ``Z|j> = omega^j |j>``, and
``h = (d+1)/2 = 2^-1 mod d``, put

    D(x,z) = omega^(h x.z) X^x Z^z .

Then (Lemma, proved in ``notes/QUDIT_MEMORY_ODD_PRIME.md``)

    D(a) D(b) = omega^(-h <a,b>) D(a+b),   <a,b> = x_a.z_b - x_b.z_a ,

so on any isotropic subspace ``D`` is a *group homomorphism*: every context
product is the identity, with no phase at all.  That is the exact reason
Mermin-type parity proofs do not exist for odd ``d``.

A memory state is a pair ``(L, chi)``: a Lagrangian ``L <= Z_d^(2n)`` together
with a character ``chi : L -> Z_d`` recording the measured eigenvalue
exponents.  Compatibility is automatic by the Lemma, so the fiber over each
Lagrangian has exactly ``d^n`` elements.
"""

from __future__ import annotations

from itertools import product
from typing import Dict, FrozenSet, List, Sequence, Tuple

Vec = Tuple[int, ...]


def inv2(d: int) -> int:
    assert d % 2 == 1, "d must be odd"
    return (d + 1) // 2


def sform(a: Vec, b: Vec, n: int, d: int) -> int:
    """Symplectic form ``x_a . z_b - x_b . z_a`` in ``Z_d``."""
    xa, za, xb, zb = a[:n], a[n:], b[:n], b[n:]
    return (
        sum(p * q for p, q in zip(xa, zb)) - sum(p * q for p, q in zip(xb, za))
    ) % d


def add(a: Vec, b: Vec, d: int) -> Vec:
    return tuple((p + q) % d for p, q in zip(a, b))


def smul(k: int, a: Vec, d: int) -> Vec:
    return tuple((k * p) % d for p in a)


# --------------------------------------------------------------------------
# exact monomial-matrix control
# --------------------------------------------------------------------------


def weyl_monomial(a: Vec, n: int, d: int) -> Dict[Tuple[int, int], int]:
    """``D(a)`` as an exact monomial matrix: ``(row, col) -> exponent of omega``.

    Basis states are indexed by ``Z_d^n`` in lexicographic order.  Entries are
    integers mod ``d``; a missing key means a zero entry.
    """
    x, z = a[:n], a[n:]
    h = inv2(d)
    offset = (h * sum(p * q for p, q in zip(x, z))) % d
    basis = list(product(range(d), repeat=n))
    index = {b: i for i, b in enumerate(basis)}
    entries: Dict[Tuple[int, int], int] = {}
    for col, j in enumerate(basis):
        row = index[tuple((jk + xk) % d for jk, xk in zip(j, x))]
        phase = (offset + sum(zk * jk for zk, jk in zip(z, j))) % d
        entries[(row, col)] = phase
    return entries


def monomial_product(
    left: Dict[Tuple[int, int], int], right: Dict[Tuple[int, int], int], d: int
) -> Dict[Tuple[int, int], int]:
    by_row: Dict[int, Tuple[int, int]] = {}
    for (r, c), p in right.items():
        by_row[r] = (c, p)
    out: Dict[Tuple[int, int], int] = {}
    for (r, c), p in left.items():
        if c in by_row:
            c2, p2 = by_row[c]
            out[(r, c2)] = (p + p2) % d
    return out


def matrix_control(n: int, d: int) -> None:
    """Check ``D(a)D(b) = omega^(-h<a,b>) D(a+b)`` on explicit monomial matrices."""
    h = inv2(d)
    space = list(product(range(d), repeat=2 * n))
    for a in space:
        for b in space:
            lhs = monomial_product(weyl_monomial(a, n, d), weyl_monomial(b, n, d), d)
            shift = (-h * sform(a, b, n, d)) % d
            rhs = {k: (v + shift) % d for k, v in weyl_monomial(add(a, b, d), n, d).items()}
            assert lhs == rhs, (a, b, d)


# --------------------------------------------------------------------------
# Lagrangians and memory states
# --------------------------------------------------------------------------


def nonzero(n: int, d: int) -> List[Vec]:
    return [v for v in product(range(d), repeat=2 * n) if any(v)]


def lagrangians(observables: Sequence[Vec], n: int, d: int) -> List[FrozenSet[Vec]]:
    """Maximal isotropic subspaces whose nonzero vectors are all admitted."""
    admitted = set(observables)
    found = set()

    def grow(span: FrozenSet[Vec]) -> None:
        maximal = True
        for v in admitted:
            if v in span or any(sform(v, w, n, d) for w in span):
                continue
            new = set(span)
            for w in list(span) + [tuple([0] * 2 * n)]:
                for k in range(d):
                    u = add(w, smul(k, v, d), d)
                    if any(u):
                        new.add(u)
            if not new <= admitted:
                continue
            maximal = False
            grow(frozenset(new))
        if maximal and span:
            found.add(span)

    grow(frozenset())
    return sorted(found, key=sorted)


State = Tuple[FrozenSet[Vec], Tuple[Tuple[Vec, int], ...]]


def _state(L: FrozenSet[Vec], chi: Dict[Vec, int]) -> State:
    return (L, tuple(sorted(chi.items())))


def characters(L: FrozenSet[Vec], n: int, d: int) -> List[Dict[Vec, int]]:
    """All ``d^n`` characters ``L -> Z_d``, built from an independent basis."""
    basis: List[Vec] = []
    span = {tuple([0] * 2 * n)}
    for v in sorted(L):
        if v in span:
            continue
        basis.append(v)
        new = set()
        for w in span:
            for k in range(d):
                new.add(add(w, smul(k, v, d), d))
        span = new
    out = []
    for values in product(range(d), repeat=len(basis)):
        chi = {tuple([0] * 2 * n): 0}
        for v, val in zip(basis, values):
            update = {}
            for w, cw in chi.items():
                for k in range(d):
                    update[add(w, smul(k, v, d), d)] = (cw + k * val) % d
            chi = update
        out.append({v: c for v, c in chi.items() if any(v)})
    return out


def measure(state: State, a: Vec, n: int, d: int) -> List[State]:
    """Ideal measurement of ``D(a)``: the list of possible successor states.

    Probabilities are uniform (``1`` if deterministic, ``1/d`` otherwise) and
    are not carried, since only the reachable-state set is counted here.
    """
    L, items = state
    chi = dict(items)
    if a in L:
        return [state]
    kept = frozenset(v for v in L if sform(v, a, n, d) == 0)
    out = []
    for outcome in range(d):
        new_chi = {v: chi[v] for v in kept}
        span = dict(new_chi)
        span[tuple([0] * 2 * n)] = 0
        merged = {}
        for w, cw in span.items():
            for k in range(d):
                merged[add(w, smul(k, a, d), d)] = (cw + k * outcome) % d
        newL = frozenset(v for v in merged if any(v))
        out.append((newL, tuple(sorted((v, merged[v]) for v in newL))))
    return out


def reachable(start: State, observables: Sequence[Vec], n: int, d: int) -> List[State]:
    seen = {start}
    frontier = [start]
    while frontier:
        nxt = []
        for s in frontier:
            for a in observables:
                for succ in measure(s, a, n, d):
                    if succ not in seen:
                        seen.add(succ)
                        nxt.append(succ)
        frontier = nxt
    return sorted(seen)


def context_products_are_trivial(n: int, d: int) -> bool:
    """Every product around a context is the identity, with no phase."""
    obs = nonzero(n, d)
    for L in lagrangians(obs, n, d):
        for a in L:
            for b in L:
                if sform(a, b, n, d) != 0:
                    return False
                if (-inv2(d) * sform(a, b, n, d)) % d != 0:
                    return False
    return True


def analyse(n: int, d: int) -> dict:
    obs = nonzero(n, d)
    lags = lagrangians(obs, n, d)
    L0 = lags[0]
    start = _state(L0, {v: 0 for v in L0})
    states = reachable(start, obs, n, d)
    return {
        "qudits": n,
        "d": d,
        "observables": len(obs),
        "contexts": len(lags),
        "contexts_times_dn": len(lags) * d ** n,
        "memory": len(states),
        "context_products_trivial": context_products_are_trivial(n, d),
    }


def main() -> None:
    for d in (3, 5):
        matrix_control(1, d)
    matrix_control(2, 3)
    print("Weyl multiplier law verified on explicit monomial matrices:")
    print("    (n,d) = (1,3), (1,5), (2,3)")
    print()
    for n, d in ((1, 3), (1, 5), (1, 7), (2, 3)):
        r = analyse(n, d)
        print(f"n={n}, d={d}")
        for k in (
            "observables",
            "contexts",
            "contexts_times_dn",
            "memory",
            "context_products_trivial",
        ):
            print(f"    {k:26s} {r[k]}")
        print()


if __name__ == "__main__":
    main()
