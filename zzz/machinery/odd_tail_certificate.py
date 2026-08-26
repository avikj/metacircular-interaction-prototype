#!/usr/bin/env python3
"""Verify an exact odd-degree negative-root tail exclusion certificate.

For a monic factor candidate with one negative root ``-t`` and ``k`` complex
conjugate pairs of moduli ``r_i``, divisibility by a later odd-exponent tail
would force

    |Res(g,F_q)| (1-t^2)
      <= t^N product_i (sum_{e in prefix} r_i^e)^2.

The input supplies rational *upper* bounds for ``t`` and each ``r_i``.  This
checker proves exclusion when the corresponding lower bound on the left is
strictly larger than the upper bound on the right.  It does not prove the
polynomial topology/monicity, root enclosures, resultant, prefix identity, or
the asserted stride-two coefficient-one tail model; those remain separate
certificate obligations and are repeated in every output record.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path
from typing import Any


FIELDS = {
    "schema",
    "subject_id",
    "prefix_id",
    "resultant_abs",
    "negative_root_upper",
    "pair_radius_uppers",
    "prefix_exponents",
    "first_tail_exponent",
    "tail_model",
}

SCHEMA = "odd-negative-root-tail-v1"
TAIL_MODEL = {"exponent_stride": 2, "coefficient_abs_bound": 1}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def fraction(value: Any, label: str) -> Fraction:
    require(isinstance(value, dict) and set(value) == {"num", "den"},
            f"{label} must be a tagged rational object")
    numerator = value["num"]
    denominator = value["den"]
    require(isinstance(numerator, str) and isinstance(denominator, str),
            f"{label} numerator and denominator must be decimal strings")
    try:
        require(str(int(numerator)) == numerator,
                f"{label} numerator must be a canonical integer")
        require(str(int(denominator)) == denominator and int(denominator) > 0,
                f"{label} denominator must be a canonical positive integer")
        result = Fraction(int(numerator), int(denominator))
    except (ValueError, ZeroDivisionError) as exc:
        raise ValueError(f"{label} is not a rational number") from exc
    require(str(result.numerator) == numerator and str(result.denominator) == denominator,
            f"{label} must be in canonical reduced form")
    return result


def tagged(value: Fraction) -> dict[str, str]:
    return {"num": str(value.numerator), "den": str(value.denominator)}


def canonical_sha256(data: dict[str, Any]) -> str:
    payload = json.dumps(
        data, ensure_ascii=False, sort_keys=True, separators=(",", ":")
    ).encode("utf-8")
    return hashlib.sha256(payload).hexdigest()


def exact_power_sum(radius: Fraction, exponents: list[int]) -> Fraction:
    return sum((radius ** exponent for exponent in exponents), Fraction(0))


def verify(data: Any) -> dict[str, Any]:
    require(isinstance(data, dict), "certificate must be an object")
    require(set(data) == FIELDS, f"fields must be exactly {sorted(FIELDS)}")
    require(data["schema"] == SCHEMA, f"schema must be {SCHEMA!r}")
    for name in ("subject_id", "prefix_id"):
        require(isinstance(data[name], str) and 0 < len(data[name]) <= 256,
                f"{name} must be a nonempty string of at most 256 characters")
    require(data["tail_model"] == TAIL_MODEL,
            f"tail_model must be exactly {TAIL_MODEL}")

    resultant = data["resultant_abs"]
    require(isinstance(resultant, int) and not isinstance(resultant, bool),
            "resultant_abs must be an integer")
    require(resultant > 0, "resultant_abs must be positive")

    t = fraction(data["negative_root_upper"], "negative_root_upper")
    require(0 < t < 1, "negative_root_upper must lie strictly between 0 and 1")

    radii_raw = data["pair_radius_uppers"]
    require(isinstance(radii_raw, list), "pair_radius_uppers must be a list")
    radii = [fraction(value, f"pair_radius_uppers[{index}]")
             for index, value in enumerate(radii_raw)]
    require(all(radius > 0 for radius in radii), "pair radii must be positive")

    exponents = data["prefix_exponents"]
    require(isinstance(exponents, list) and exponents,
            "prefix_exponents must be a nonempty list")
    require(all(isinstance(value, int) and not isinstance(value, bool)
                and value >= 0 for value in exponents),
            "prefix exponents must be nonnegative integers")
    require(exponents == sorted(set(exponents)),
            "prefix exponents must be strictly increasing")

    tail_exponent = data["first_tail_exponent"]
    require(isinstance(tail_exponent, int) and not isinstance(tail_exponent, bool),
            "first_tail_exponent must be an integer")
    require(tail_exponent > exponents[-1],
            "first_tail_exponent must be after the prefix")
    require(tail_exponent % 2 == 1,
            "first_tail_exponent must be odd for the negative-root tail bound")

    left_lower = Fraction(resultant) * (1 - t * t)
    right_upper = t ** tail_exponent
    pair_sums: list[Fraction] = []
    for radius in radii:
        value = exact_power_sum(radius, exponents)
        pair_sums.append(value)
        right_upper *= value * value
    margin = left_lower - right_upper

    return {
        "schema": SCHEMA,
        "subject_id": data["subject_id"],
        "prefix_id": data["prefix_id"],
        "certificate_input_sha256": canonical_sha256(data),
        "complex_pair_count": len(radii),
        "degree": 2 * len(radii) + 1,
        "left_lower": tagged(left_lower),
        "right_upper": tagged(right_upper),
        "pair_prefix_upper_sums": [tagged(value) for value in pair_sums],
        "strict_margin": tagged(margin),
        "excluded": margin > 0,
        "trust_boundary": (
            "This checks only the exact rational inequality. Separate proofs "
            "must bind subject_id/prefix_id to a monic integral polynomial "
            "with exactly one negative root and the complete listed conjugate "
            "pairs; validate every root upper bound and the nonzero resultant; "
            "and prove that the same prefix has the listed +1 exponents while "
            "every later tail coefficient has absolute value at most 1 and "
            "support contained in N+2Z_{>=0}, starting no earlier than the "
            "declared first_tail_exponent N."
        ),
    }


def unique_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        require(key not in result, f"duplicate object key {key!r}")
        result[key] = value
    return result


def reject_float(token: str) -> Any:
    raise ValueError(f"floating token {token!r} is forbidden")


def reject_constant(token: str) -> Any:
    raise ValueError(f"nonfinite token {token!r} is forbidden")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", type=Path)
    args = parser.parse_args()
    try:
        data = json.loads(
            args.certificate.read_text(encoding="utf-8"),
            object_pairs_hook=unique_object,
            parse_float=reject_float,
            parse_constant=reject_constant,
        )
        result = verify(data)
    except (OSError, UnicodeDecodeError, json.JSONDecodeError, ValueError) as exc:
        parser.error(str(exc))
    print(json.dumps(result, sort_keys=True, indent=2))
    return 0 if result["excluded"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
