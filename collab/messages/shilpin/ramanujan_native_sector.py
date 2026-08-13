#!/usr/bin/env python3
"""Derive the primitive sector from the Ramanujan observable and shifts."""

import importlib.util
from fractions import Fraction
from pathlib import Path

_source = Path(__file__).with_name("minimal_complementary_channel.py")
_spec = importlib.util.spec_from_file_location("minimal_complementary_channel", _source)
assert _spec is not None and _spec.loader is not None
_mc = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_mc)
identity, mm, primitive_projector, ramanujan, rank, translation = (
    _mc.identity, _mc.mm, _mc.primitive_projector,
    _mc._pl._cp.ramanujan, _mc.rank, _mc._pl.translation,
)


def column(v):
    return tuple((Fraction(x),) for x in v)


def orbit_matrix(q, observable):
    f = column(observable)
    shifted = [mm(translation(q, n), f) for n in range(q)]
    return tuple(tuple(shifted[j][i][0] for j in range(q)) for i in range(q))


def derive_ramanujan_sector(q):
    observable = tuple(ramanujan(q, n) for n in range(q))
    orbit = orbit_matrix(q, observable)
    # For c_q, convolution orthogonality makes the orbit matrix q times the
    # primitive-character projector (up to the harmless inversion convention;
    # c_q is even).
    projector = tuple(tuple(x / q for x in row) for row in orbit)
    assert mm(projector, projector) == projector
    assert mm(projector, column(observable)) == column(observable)
    assert all(mm(projector, translation(q, n)) == mm(translation(q, n), projector)
               for n in range(q))
    return observable, orbit, projector


def main():
    q = 6
    observable, orbit, derived = derive_ramanujan_sector(q)
    assert observable == (2, 1, -1, -2, -1, 1)
    assert derived == primitive_projector(q)
    assert rank(orbit) == rank(derived) == 2

    # Minimality control: every invariant subspace containing the observable
    # contains every orbit column, hence contains this rank-two image.  In
    # particular no rank-one sector can suffice.
    assert rank(orbit) > 1

    # Wrong-sector control: the primitive projector rejects the constant
    # observable, whose native cyclic span is instead one-dimensional.
    constant = column((1,) * q)
    assert mm(derived, constant) != constant
    assert rank(orbit_matrix(q, (1,) * q)) == 1

    # Delta observable requires the entire regular representation.
    assert rank(orbit_matrix(q, (1,) + (0,) * (q - 1))) == q
    print({"q": q, "native_observable": observable,
           "derived_sector_rank": rank(derived),
           "constant_control_rank": 1, "delta_control_rank": q})
    print("ALL EXACT NATIVE-SECTOR CHECKS PASS")


if __name__ == "__main__":
    main()
