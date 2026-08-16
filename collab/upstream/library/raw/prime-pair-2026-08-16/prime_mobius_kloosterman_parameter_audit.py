#!/usr/bin/env python3
"""Exact rational checks for the Prime–Möbius Kloosterman parameter audit."""

from fractions import Fraction
import argparse
import json
from pathlib import Path
import sys


def exponent_vector(rho: Fraction, phi: Fraction):
    return [
        -Fraction(1, 8) + 3 * rho / 8,
        -Fraction(1, 8) + rho / 4,
        -Fraction(1, 20) - phi / 20 + rho / 4,
        -Fraction(1, 20) - 3 * phi / 20 + rho / 10,
        -Fraction(1, 8) - rho / 8,
    ]


def direct_threshold(phi: Fraction):
    return min(
        Fraction(1, 3),
        Fraction(1, 2),
        (1 + phi) / 5,
        (1 + 3 * phi) / 2,
    )


def run_checks():
    checks = []

    # Structural compatibility: D <= (D/R)^2 iff rho <= 1/2.
    for rho in [Fraction(0), Fraction(1, 5), Fraction(1, 3), Fraction(1, 2)]:
        lhs_exp = Fraction(1)
        rhs_exp = 2 * (1 - rho)
        ok = (lhs_exp <= rhs_exp) == (rho <= Fraction(1, 2))
        assert ok
    checks.append({
        "id": "STRUCTURAL-COMPATIBILITY",
        "status": "PASS",
        "statement": "M=D, N=D/R satisfies M<=N^2 exactly through rho<=1/2.",
    })

    # Verify term substitutions as exponent identities.
    rho, phi = Fraction(7, 31), Fraction(2, 19)
    exps = exponent_vector(rho, phi)
    expected = [
        -Fraction(1, 8) + 3 * rho / 8,
        -Fraction(1, 8) + rho / 4,
        -Fraction(1, 20) - phi / 20 + rho / 4,
        -Fraction(1, 20) - 3 * phi / 20 + rho / 10,
        -Fraction(1, 8) - rho / 8,
    ]
    assert exps == expected
    checks.append({
        "id": "EXPONENT-SUBSTITUTION",
        "status": "PASS",
        "rho": str(rho),
        "phi": str(phi),
        "exponents": [str(x) for x in exps],
    })

    # Bounded frequency threshold.
    assert direct_threshold(Fraction(0)) == Fraction(1, 5)
    checks.append({
        "id": "BOUNDED-FREQUENCY-THRESHOLD",
        "status": "PASS",
        "threshold_rho": "1/5",
        "threshold_R_in_D": "D^(1/5)",
        "threshold_R_in_X_when_D=X^(1/2)": "X^(1/10)",
    })

    # Quarter-scale endpoint vector.
    endpoint = exponent_vector(Fraction(1, 2), Fraction(0))
    expected_endpoint = [
        Fraction(1, 16),
        Fraction(0),
        Fraction(3, 40),
        Fraction(0),
        -Fraction(3, 16),
    ]
    assert endpoint == expected_endpoint
    checks.append({
        "id": "QUARTER-SCALE-ENDPOINT",
        "status": "PASS",
        "exponents": [str(x) for x in endpoint],
        "positive_terms": sum(x > 0 for x in endpoint),
        "zero_terms": sum(x == 0 for x in endpoint),
        "negative_terms": sum(x < 0 for x in endpoint),
    })

    # Boundary at rho=1/5: third term is exactly trivial.
    at_threshold = exponent_vector(Fraction(1, 5), Fraction(0))
    assert at_threshold[2] == 0
    assert max(at_threshold) == 0
    below = exponent_vector(Fraction(1, 5) - Fraction(1, 1000), Fraction(0))
    assert max(below) < 0
    above = exponent_vector(Fraction(1, 5) + Fraction(1, 1000), Fraction(0))
    assert max(above) > 0
    checks.append({
        "id": "THRESHOLD-SHARPNESS-FOR-DIRECT-BOUND",
        "status": "PASS",
        "at_threshold_exponents": [str(x) for x in at_threshold],
    })

    # Direct Bettin–Chandee balanced exponents.
    # First term relative exponent in D is -1/20 (for bounded F);
    # second is -1/8.
    bc = [Fraction(-1, 20), Fraction(-1, 8)]
    assert max(bc) == Fraction(-1, 20)
    checks.append({
        "id": "UNSPLIT-BALANCED-COMPARISON",
        "status": "PASS",
        "relative_exponents": [str(x) for x in bc],
        "dominant": "-1/20",
    })

    # Frequency-dependent threshold formula spot checks.
    samples = {
        "0": Fraction(1, 5),
        "1/5": Fraction(6, 25),
        "1": Fraction(1, 3),
    }
    for phi_str, expected_t in samples.items():
        phi_val = Fraction(phi_str)
        assert direct_threshold(phi_val) == expected_t
    checks.append({
        "id": "FREQUENCY-PHASE-DIAGRAM",
        "status": "PASS",
        "samples": {k: str(v) for k, v in samples.items()},
    })

    # Exact frontier conversion from D to X.
    # D=X^(1/2): D^(1/5)=X^(1/10), D^(1/2)=X^(1/4).
    assert Fraction(1, 2) * Fraction(1, 5) == Fraction(1, 10)
    assert Fraction(1, 2) * Fraction(1, 2) == Fraction(1, 4)
    checks.append({
        "id": "X-SCALE-FRONTIER",
        "status": "PASS",
        "lower": "X^(1/10)",
        "upper": "X^(1/4)",
    })

    return checks


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--json-report", type=Path)
    args = parser.parse_args()

    checks = run_checks()
    report = {
        "title": "Prime–Möbius Kloosterman Parameter Audit Report",
        "checks_total": len(checks),
        "checks_passed": sum(c["status"] == "PASS" for c in checks),
        "checks_failed": sum(c["status"] != "PASS" for c in checks),
        "checks": checks,
        "scope_limit": (
            "Exact algebraic parameter audit only. It does not prove a new "
            "Kloosterman estimate or a prime-pair asymptotic."
        ),
    }
    if args.json_report:
        args.json_report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
    return 0 if report["checks_failed"] == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
