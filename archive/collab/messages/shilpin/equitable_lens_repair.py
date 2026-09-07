#!/usr/bin/env python3
"""Polynomial equitable refinement and the exact Z/1000 repair."""

import sys
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "machinery"))
from lens_repair import canonical, commutes, exhaustive_coarsest_repairs, join


def blocks(labels):
    out = {}
    for i, label in enumerate(labels):
        out.setdefault(label, []).append(i)
    return out


def refine_once(rho, sigma):
    rho_blocks = sorted(blocks(rho))
    sigma_blocks = blocks(sigma)
    signatures = []
    for x in range(len(rho)):
        source = sigma_blocks[sigma[x]]
        counts = {label: 0 for label in rho_blocks}
        for y in source:
            counts[rho[y]] += 1
        signatures.append((rho[x], tuple(Fraction(counts[label], len(source))
                                         for label in rho_blocks)))
    return canonical(signatures)


def coarsest_equitable_repair(pi, sigma):
    rho = canonical(pi)
    while True:
        successor = refine_once(rho, sigma)
        if successor == rho:
            assert commutes(rho, sigma)
            return rho
        rho = successor


def main():
    defect = lambda x: x * x - x
    decimal = tuple(x % 10 for x in range(1000))
    crt = tuple((defect(x) % 8 == 0, defect(x) % 125 == 0)
                for x in range(1000))
    repair = coarsest_equitable_repair(decimal, crt)
    assert len(set(repair)) == 14
    assert sorted(map(len, blocks(repair).values())) == [4] * 4 + [96] * 4 + [100] * 6
    assert refine_once(repair, crt) == repair
    assert commutes(repair, crt)

    joined = join(repair, crt)
    target = canonical(tuple(defect(x) % 125 == 0 for x in range(1000)))
    assert canonical(joined) == target
    assert sorted(map(len, blocks(joined).values())) == [16, 984]

    # Independent finite hostile control against the old exhaustive ground truth.
    pi = (0, 0, 0, 0, 1)
    sigma = (0, 0, 1, 2, 0)
    exact = exhaustive_coarsest_repairs(pi, sigma, 5)
    repair5 = coarsest_equitable_repair(pi, sigma)
    assert len(exact) == 1 and canonical(exact[0]) == repair5 == (0, 0, 1, 1, 2)

    print({"decimal_blocks": 10, "global_minimum_repair_blocks": 14,
           "joint_overpayment_blocks": 28,
           "repair_block_sizes": sorted(map(len, blocks(repair).values())),
           "composite_sensor_sizes": (16, 984)})
    print("ALL EXACT EQUITABLE-REPAIR CHECKS PASS")


if __name__ == "__main__":
    main()
