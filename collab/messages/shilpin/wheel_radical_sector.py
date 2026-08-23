#!/usr/bin/env python3
"""Exact radical law for the cyclic span of a wheel unit indicator."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3]))
from machinery.task_generated_projector import wheel_unit_projector


def radical(n):
    out, p = 1, 2
    while p * p <= n:
        if n % p == 0:
            out *= p
            while n % p == 0:
                n //= p
        p += 1
    return out * n if n > 1 else out


def squarefree(n):
    p = 2
    while p * p <= n:
        if n % (p * p) == 0:
            return False
        p += 1
    return True


def predicted_orders(w):
    return tuple(d for d in range(1, w + 1) if w % d == 0 and squarefree(d))


def main():
    cases = (4, 8, 12, 18, 30, 36, 60)
    rows = []
    for w in cases:
        cert = wheel_unit_projector(w)
        assert cert.supported_orders == predicted_orders(w)
        assert cert.predicted_rank == radical(w)
        rows.append((w, radical(w), cert.supported_orders))
    assert wheel_unit_projector(30).predicted_rank == 30  # squarefree control
    assert wheel_unit_projector(12).predicted_rank == 6   # repeated-prime control
    print(rows)
    print("ALL EXACT WHEEL-RADICAL CHECKS PASS")


if __name__ == "__main__":
    main()
