#!/usr/bin/env python3
"""Native Z/1000 carrier refinement installs and removes lens interchange."""

import sys
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "machinery"))
from lens_repair import commutes, meet


def defect(x):
    return x * x - x


def labels():
    decimal = tuple(x % 10 for x in range(1000))
    crt = tuple((defect(x) % 8 == 0, defect(x) % 125 == 0)
                for x in range(1000))
    return decimal, crt, meet(decimal, crt)


def project(partition, signal):
    blocks = {}
    for i, label in enumerate(partition):
        blocks.setdefault(label, []).append(i)
    means = {label: sum(signal[i] for i in block) / len(block)
             for label, block in blocks.items()}
    return tuple(means[label] for label in partition)


def compose(first, second, signal):
    return project(first, project(second, signal))


def main():
    decimal, crt, joint = labels()
    assert len(set(decimal)) == 10
    assert len(set(crt)) == 4
    assert len(set(joint)) == 28
    assert not commutes(decimal, crt)
    assert commutes(joint, crt)
    assert commutes(joint, decimal)

    e0 = tuple(Fraction(int(x == 0)) for x in range(1000))
    low_lc = compose(decimal, crt, e0)
    low_cl = compose(crt, decimal, e0)
    assert low_lc[5] == Fraction(1, 400)
    assert low_cl[5] == Fraction(1, 1025)
    assert low_lc[5] - low_cl[5] == Fraction(1, 656)
    assert sum(a != b for a, b in zip(low_lc, low_cl)) == 984

    high_jc = compose(joint, crt, e0)
    high_cj = compose(crt, joint, e0)
    assert high_jc == high_cj

    # Shrinking the installed chart back to decimal reopens the same witness.
    shrink_lc = compose(decimal, crt, e0)
    shrink_cl = compose(crt, decimal, e0)
    assert shrink_lc != shrink_cl
    print({"carrier_blocks": (10, 28, 10),
           "commutes": (False, True, False),
           "low_order_defect_at_5": Fraction(1, 656),
           "nonzero_coordinates": 984})
    print("ALL EXACT ARITHMETIC-CARRIER CHECKS PASS")


if __name__ == "__main__":
    main()
