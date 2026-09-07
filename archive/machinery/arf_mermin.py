#!/usr/bin/env python3
"""Quadratic refinements of the two-qubit symplectic form, exactly.

Companion to ``machinery/pauli_context_memory.py``.  Everything is over
``F_2``; a scenario's symplectic vectors are flat 4-tuples ``(x1,x2,z1,z2)``.

The structure: ``q(x,z) = x.z`` satisfies the polarization identity
``q(a+b) = q(a) + q(b) + <a,b>``, so it is a quadratic refinement of the
symplectic form.  Refinements form a torsor under ``Hom(V, F_2)``, hence
``2^(2n)`` of them, split by Arf invariant into plus and minus type.  The
torsor theorem itself is machine-checked in
``formal/cubical/NaturalMachine/QuadraticRefinement.agda``.

See ``notes/ARF_MERMIN_CLASSIFICATION.md``.
"""

from __future__ import annotations

from itertools import product
from typing import Dict, FrozenSet, List, Sequence, Tuple

Flat = Tuple[int, int, int, int]

SPACE: List[Flat] = [v for v in product((0, 1), repeat=4)]
NONZERO: List[Flat] = [v for v in SPACE if any(v)]


def symplectic(a: Flat, b: Flat) -> int:
    """``<a,b> = x_a . z_b + x_b . z_a`` over ``F_2``."""
    return (a[0] * b[2] + a[1] * b[3] + b[0] * a[2] + b[1] * a[3]) % 2


def base_quadratic(a: Flat) -> int:
    """``q_0(x,z) = x.z``, from ``V(x,z)^2 = (-1)^(x.z) I``."""
    return (a[0] * a[2] + a[1] * a[3]) % 2


def refinements() -> List[Dict[Flat, int]]:
    """All ``2^4`` quadratic refinements of the symplectic form.

    Each is ``q_0 + l`` for a linear functional ``l``; the polarization
    identity is asserted for every pair, so the list is certified, not
    assumed.
    """
    out = []
    for lin in SPACE:
        q = {
            a: (base_quadratic(a) + sum(li * ai for li, ai in zip(lin, a))) % 2
            for a in SPACE
        }
        for a in SPACE:
            for b in SPACE:
                s = tuple((p + r) % 2 for p, r in zip(a, b))
                assert (q[s] + q[a] + q[b]) % 2 == symplectic(a, b)
        out.append(q)
    return out


def singular(q: Dict[Flat, int]) -> FrozenSet[Flat]:
    """Nonzero vectors with ``q = 0``."""
    return frozenset(a for a in NONZERO if q[a] == 0)


def arf_type(q: Dict[Flat, int]) -> str:
    """Plus type has 9 nonzero singular vectors, minus type 5."""
    n = len(singular(q))
    assert n in (9, 5)
    return "plus" if n == 9 else "minus"


def quadric_signature(observables: Sequence[Flat]) -> Tuple[int, int]:
    """(plus-type, minus-type) refinements making every observable singular."""
    plus = minus = 0
    for q in refinements():
        if all(q[a] == 0 for a in observables):
            if arf_type(q) == "plus":
                plus += 1
            else:
                minus += 1
    return (plus, minus)


def flatten(v) -> Flat:
    """Convert ``pauli_context_memory``'s ``((x1,x2),(z1,z2))`` to a flat tuple."""
    return (v[0][0], v[0][1], v[1][0], v[1][1])


def unflatten(a: Flat):
    return ((a[0], a[1]), (a[2], a[3]))


def main() -> None:
    forms = refinements()
    plus = [q for q in forms if arf_type(q) == "plus"]
    print(f"quadratic refinements of the two-qubit symplectic form: {len(forms)}")
    print(f"    plus type (Arf 0): {len(plus)}   minus type: {len(forms) - len(plus)}")
    print(f"    nonzero singular vectors: plus {len(singular(plus[0]))}, "
          f"minus {len(singular([q for q in forms if arf_type(q) == 'minus'][0]))}")
    print()

    import machinery.pauli_context_memory as pcm

    mermin = set()
    for chosen in pcm.all_context_covers(2):
        if (
            len(chosen) == 9
            and len(pcm.lagrangians(chosen, 2)) == 6
            and not pcm.is_noncontextual(chosen, 2)
        ):
            mermin.add(frozenset(flatten(v) for v in chosen))
    singular_sets = {singular(q) for q in plus}
    print(f"Mermin squares found by exhaustive sweep: {len(mermin)}")
    print(f"plus-type singular sets:                  {len(singular_sets)}")
    print(f"BIJECTION: {mermin == singular_sets}")

    ok = True
    for q in plus:
        obs = sorted(unflatten(a) for a in singular(q))
        ctxs = pcm.lagrangians(obs, 2)
        if len(ctxs) != 6 or not all(
            all(q[flatten(v)] == 0 for v in L) for L in ctxs
        ):
            ok = False
    print(f"every square's six contexts are totally singular: {ok}")


if __name__ == "__main__":
    main()
