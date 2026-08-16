#!/usr/bin/env python3
"""Deterministic finite checks for cyclic charge projectors inside a sharp CRT split."""

from __future__ import annotations
import argparse, cmath, json, math, sys
from fractions import Fraction
from pathlib import Path


def factor(n: int):
    out = {}
    p = 2
    x = n
    while p * p <= x:
        while x % p == 0:
            out[p] = out.get(p, 0) + 1
            x //= p
        p += 1
    if x > 1:
        out[x] = out.get(x, 0) + 1
    return out


def omega_big(n: int) -> int:
    return sum(factor(n).values())


def omega_small(n: int) -> int:
    return len(factor(n))


def mobius(n: int) -> int:
    f = factor(n)
    if any(a > 1 for a in f.values()):
        return 0
    return -1 if len(f) % 2 else 1


def divisors(n: int):
    ds = [1]
    for p, a in factor(n).items():
        ds = [d * p**j for d in ds for j in range(a + 1)]
    return sorted(ds)


def binom(n: int, k: int) -> int:
    return math.comb(n, k) if 0 <= k <= n else 0


def kappa(r: int, n: int) -> int:
    rho = omega_big(n) - omega_small(n)
    j = omega_small(n)
    k = r - rho
    if not 0 <= k <= j:
        return 0
    return (-1) ** (j - k) * binom(j, k)


def a_phase(n: int, z: complex) -> complex:
    rho = omega_big(n) - omega_small(n)
    j = omega_small(n)
    return z**rho * (z - 1)**j


def direct_prime_kernel(n: int) -> int:
    return sum(mobius(n // p) for p in factor(n))


def q_charge(r: int, n: int) -> int:
    return int(omega_big(n) == r)


def reconstruct_q(r: int, n: int) -> int:
    return sum(kappa(r, d) for d in divisors(n))


def crt_count(start: int, stop: int, d: int, e: int, h: int) -> int:
    return sum(1 for n in range(start, stop + 1) if n % d == 0 and (n + h) % e == 0)


def lcm(a: int, b: int) -> int:
    return a // math.gcd(a, b) * b


def main_boundary(start: int, stop: int, r: int, t: int, h: int) -> Fraction:
    length = stop - start + 1
    total = Fraction(0)
    max_d = stop
    max_e = stop + abs(h)
    for d in range(1, max_d + 1):
        kd = kappa(r, d)
        if not kd:
            continue
        for e in range(1, max_e + 1):
            ke = kappa(t, e)
            if not ke or h % math.gcd(d, e):
                continue
            total += Fraction(length * kd * ke, lcm(d, e))
    return total


def direct_count(start: int, stop: int, r: int, t: int, h: int) -> int:
    return sum(
        1 for n in range(start, stop + 1)
        if omega_big(n) == r and omega_big(n + h) == t
    )


def grand_boundary(start: int, stop: int, z: complex, w: complex, h: int) -> complex:
    # Exact sharp finite split: direct grand count minus rational CRT equilibrium.
    direct = sum(z**omega_big(n) * w**omega_big(n + h) for n in range(start, stop + 1))
    length = stop - start + 1
    max_d = stop
    max_e = stop + abs(h)
    main = 0j
    for d in range(1, max_d + 1):
        ad = a_phase(d, z)
        if abs(ad) < 1e-14:
            continue
        for e in range(1, max_e + 1):
            ae = a_phase(e, w)
            if abs(ae) < 1e-14 or h % math.gcd(d, e):
                continue
            main += ad * ae * (length / lcm(d, e))
    return direct - main


def run_checks():
    checks = []

    # 1. Polynomial coefficients and incidence.
    for n in range(1, 1201):
        assert kappa(1, n) == direct_prime_kernel(n)
        for r in range(0, omega_big(n) + 1):
            assert reconstruct_q(r, n) == q_charge(r, n)
    checks.append({"id": "DIVISOR-POLYNOMIAL-AND-INCIDENCE", "status": "PASS", "range": 1200})

    # 2. Cyclic coefficient projector.
    max_err = 0.0
    for n in range(1, 701):
        R = omega_big(n)
        M = R + 1 if R + 1 >= 2 else 2
        zeta = cmath.exp(2j * math.pi / M)
        val = sum(zeta**(-nu) * a_phase(n, zeta**nu) for nu in range(M)) / M
        max_err = max(max_err, abs(val - kappa(1, n)))
    assert max_err < 1e-10
    checks.append({"id": "CYCLIC-CHARGE-PROJECTOR", "status": "PASS", "max_error": max_err})

    # 3. Parseval energy and parity counterexample.
    for n in range(2, 901):
        R = omega_big(n)
        coeff_energy = sum(kappa(r, n) ** 2 for r in range(R + 1))
        assert coeff_energy == math.comb(2 * omega_small(n), omega_small(n))
    d1, d2 = 6, 24  # pq and p^3 q
    assert abs(a_phase(d1, -1) - a_phase(d2, -1)) < 1e-12
    assert kappa(1, d1) == -2 and kappa(1, d2) == 0
    checks.append({
        "id": "PHASE-ENERGY-AND-PARITY-NO-GO",
        "status": "PASS",
        "parity_example": [d1, d2],
    })

    # 4. Endpoint diagonal total charge equals prime-pair count on positive interior.
    start, stop, h = 2, 300, 2
    direct_pp = direct_count(start, stop, 1, 1, h)
    diagonal_total = sum(
        1 for n in range(start, stop + 1)
        if omega_big(n) + omega_big(n + h) == 2
    )
    assert direct_pp == diagonal_total
    checks.append({
        "id": "DIAGONAL-ENDPOINT-SUFFICIENCY",
        "status": "PASS",
        "prime_pairs": direct_pp,
    })

    # 5. Main/boundary curvature for total charge two.
    start, stop, h = 2, 80, 2
    m02 = main_boundary(start, stop, 0, 2, h)
    m11 = main_boundary(start, stop, 1, 1, h)
    m20 = main_boundary(start, stop, 2, 0, h)
    c02 = direct_count(start, stop, 0, 2, h)
    c11 = direct_count(start, stop, 1, 1, h)
    c20 = direct_count(start, stop, 2, 0, h)
    assert c02 == 0 and c20 == 0
    d02 = Fraction(c02) - m02
    d11 = Fraction(c11) - m11
    d20 = Fraction(c20) - m20
    diagonal_boundary = d02 + d11 + d20
    assert d11 == diagonal_boundary + m02 + m20
    assert d02 + d20 != 0
    checks.append({
        "id": "DIAGONAL-BOUNDARY-CURVATURE",
        "status": "PASS",
        "delta_02_plus_20": str(d02 + d20),
    })

    # 6. Bivariate phase projector reconstructs sharp finite boundary numerically.
    start, stop, h = 2, 45, 2
    max_charge = max(
        max(omega_big(n), omega_big(n + h))
        for n in range(start, stop + 1)
    )
    M = max_charge + 1
    zeta = cmath.exp(2j * math.pi / M)
    phase_recon = 0j
    for nu in range(M):
        for eta in range(M):
            phase_recon += (
                zeta**(-nu - eta)
                * grand_boundary(start, stop, zeta**nu, zeta**eta, h)
            )
    phase_recon /= M * M
    exact_delta = float(Fraction(direct_count(start, stop, 1, 1, h)) -
                        main_boundary(start, stop, 1, 1, h))
    err = abs(phase_recon - exact_delta)
    assert err < 1e-8
    checks.append({
        "id": "BIVARIATE-PHASE-CRT-BOUNDARY",
        "status": "PASS",
        "phase_grid": M * M,
        "max_error": err,
    })

    # 7. Incidence and phase additive transforms agree.
    q, m, D = 17, 3, 100
    inc = 0j
    ph = 0j
    max_deg = max(omega_big(n) for n in range(1, D + 1))
    M = max_deg + 1
    zeta = cmath.exp(2j * math.pi / M)
    for n in range(1, D + 1):
        weight = cmath.exp(-2j * math.pi * m * n / q) / math.sqrt(n)
        inc += direct_prime_kernel(n) * weight
        phase_coeff = sum(zeta**(-nu) * a_phase(n, zeta**nu) for nu in range(M)) / M
        ph += phase_coeff * weight
    err = abs(inc - ph)
    assert err < 1e-9
    checks.append({"id": "INCIDENCE-PHASE-ADDITIVE-TRANSFORM", "status": "PASS", "max_error": err})

    # 8. Character phase anchor at -1 on a finite Euler product.
    # Quadratic character modulo 5.
    def chi5(n):
        r = n % 5
        if r == 0:
            return 0
        return 1 if r in (1, 4) else -1

    primes = [2, 3, 7, 11, 13, 17, 19, 23]
    s = 1.7
    Aminus = 1.0 + 0j
    Ls = 1.0 + 0j
    L2 = 1.0 + 0j
    for p in primes:
        x = chi5(p) * p**(-s)
        Aminus *= (1 - x) / (1 + x)
        Ls *= 1 / (1 - x)
        L2 *= 1 / (1 - (chi5(p) ** 2) * p**(-2 * s))
    rhs = L2 / (Ls * Ls)
    err = abs(Aminus - rhs)
    assert err < 1e-12
    checks.append({"id": "CHARACTER-PARITY-ANCHOR", "status": "PASS", "max_error": err})

    return checks


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--json-report", type=Path)
    args = parser.parse_args()
    checks = run_checks()
    report = {
        "title": "Prime-Pair Cyclic Charge CRT Boundary V2 Report",
        "checks_total": len(checks),
        "checks_passed": sum(c["status"] == "PASS" for c in checks),
        "checks_failed": sum(c["status"] != "PASS" for c in checks),
        "checks": checks,
        "scope_limit": "Finite deterministic identities only; no asymptotic prime-pair estimate.",
    }
    if args.json_report:
        args.json_report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
    return 0 if report["checks_failed"] == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
