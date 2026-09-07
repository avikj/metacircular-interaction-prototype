#!/usr/bin/env python3
"""Central-character trace of the Peres--Mermin relator product."""

import importlib.util
from pathlib import Path

_source = Path(__file__).with_name("peres_mermin_transgression.py")
_spec = importlib.util.spec_from_file_location("peres_mermin_transgression", _source)
assert _spec is not None and _spec.loader is not None
_pm = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_pm)
CONTEXTS, I4, NEG_I4, SQUARE, mm = (
    _pm.CONTEXTS, _pm.I4, _pm.NEG_I4, _pm.SQUARE, _pm.mm,
)


def trace(a):
    return sum(a[i][i] for i in range(len(a)))


def context_products():
    flat = sum(SQUARE, ())
    return tuple(mm(mm(flat[i], flat[j]), flat[k])
                 for i, j, k in CONTEXTS)


def main():
    products = context_products()
    total = I4
    for p in products:
        total = mm(total, p)
    assert products == (I4, I4, I4, I4, I4, NEG_I4)
    assert total == NEG_I4

    chi_plus, chi_minus = trace(I4), trace(NEG_I4)
    assert (chi_plus, chi_minus) == (4, -4)
    assert chi_plus + chi_minus == 0       # trivial central Fourier mode
    assert chi_plus - chi_minus == 8       # sign-twisted central mode
    assert trace(total) / 4 == -1

    # Control: character data do not determine a contextual cover.  The same
    # representation and central Fourier coefficients remain after replacing
    # the selected relator 2-cycle by the empty chain, whose product is +I.
    empty_chain_product = I4
    assert trace(empty_chain_product) / 4 == 1
    assert (chi_plus + chi_minus, chi_plus - chi_minus) == (0, 8)
    print({"relator_product_normalized_trace": -1,
           "central_fourier_trivial": 0,
           "central_fourier_sign": 8,
           "empty_chain_normalized_trace": 1})
    print("ALL EXACT TWISTED-TRACE CHECKS PASS")


if __name__ == "__main__":
    main()
