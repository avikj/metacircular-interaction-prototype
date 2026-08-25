#!/usr/bin/env python3
"""Exact vertex certificate for capped positive monomial systems.

For positive rational variables with disjoint product constraints and upper
caps, logarithmic deficits form a product of simplices.  A positive-
coefficient Laurent polynomial is convex in log coordinates, so its maximum
on the closed domain (or supremum on the strict domain) occurs at a closure
vertex.  This checker validates that finite reduction and evaluates every
vertex using ``Fraction`` arithmetic.

The checker proves only the stated rational optimization problem.  A caller
must separately prove that its mathematical roots, coefficients, or other
objects satisfy the supplied caps and product laws.
"""

from __future__ import annotations

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
import re
from pathlib import Path
from typing import Any


SCHEMA = "monomial-vertex-certificate/v1"
TOP_FIELDS = {"schema", "domain", "caps", "groups", "objectives"}
RATIONAL_FIELDS = {"num", "den"}
GROUP_FIELDS = {"vars", "product"}
OBJECTIVE_FIELDS = {"id", "terms"}
TERM_FIELDS = {"coefficient", "exponents"}
INTEGER_TEXT = re.compile(r"(?:0|-[1-9][0-9]*|[1-9][0-9]*)\Z")
POSITIVE_INTEGER_TEXT = re.compile(r"[1-9][0-9]*\Z")


def _unique_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"duplicate object key {key!r}")
        result[key] = value
    return result


def _reject_float(token: str) -> Any:
    raise ValueError(f"floating-point number {token!r} is forbidden")


def _reject_nonfinite(token: str) -> Any:
    raise ValueError(f"nonstandard numeric token {token!r} is forbidden")


def load_exact_json(path: Path) -> Any:
    try:
        return json.loads(
            path.read_text(encoding="utf-8"),
            object_pairs_hook=_unique_object,
            parse_float=_reject_float,
            parse_constant=_reject_nonfinite,
        )
    except (json.JSONDecodeError, UnicodeDecodeError, ValueError) as exc:
        raise ValueError(f"invalid exact JSON: {exc}") from exc


def _fraction(value: Any, path: str) -> Fraction:
    if not isinstance(value, dict) or set(value) != RATIONAL_FIELDS:
        raise ValueError(f"{path}: expected tagged rational with num/den")
    numerator = value["num"]
    denominator = value["den"]
    if not isinstance(numerator, str) or not INTEGER_TEXT.fullmatch(numerator):
        raise ValueError(f"{path}.num: expected canonical integer string")
    if not isinstance(denominator, str) or not POSITIVE_INTEGER_TEXT.fullmatch(denominator):
        raise ValueError(f"{path}.den: expected positive canonical integer string")
    result = Fraction(int(numerator), int(denominator))
    if str(result.numerator) != numerator or str(result.denominator) != denominator:
        raise ValueError(f"{path}: rational must be reduced and canonical")
    return result


def _tag(value: Fraction) -> dict[str, str]:
    return {"num": str(value.numerator), "den": str(value.denominator)}


def _canonical(value: Any) -> bytes:
    return json.dumps(
        value, sort_keys=True, separators=(",", ":"), ensure_ascii=False
    ).encode("utf-8")


def _text(value: Any, path: str) -> str:
    if not isinstance(value, str) or not value:
        raise ValueError(f"{path}: expected a nonempty string")
    if any(0xD800 <= ord(character) <= 0xDFFF for character in value):
        raise ValueError(f"{path}: lone UTF-16 surrogates are forbidden")
    return value


def _positive_rational(value: Any, path: str) -> Fraction:
    result = _fraction(value, path)
    if result <= 0:
        raise ValueError(f"{path}: value must be strictly positive")
    return result


def _validate(packet: Any) -> tuple[
    str,
    list[Fraction],
    list[tuple[tuple[int, ...], Fraction]],
    list[tuple[str, list[tuple[Fraction, tuple[int, ...]]]]],
]:
    if not isinstance(packet, dict) or set(packet) != TOP_FIELDS:
        raise ValueError(f"top-level fields must be exactly {sorted(TOP_FIELDS)}")
    if packet["schema"] != SCHEMA:
        raise ValueError(f"schema must be {SCHEMA!r}")
    domain = packet["domain"]
    if domain not in {"closed", "strict"}:
        raise ValueError("domain must be 'closed' or 'strict'")
    raw_caps = packet["caps"]
    if not isinstance(raw_caps, list) or not raw_caps:
        raise ValueError("caps must be a nonempty list")
    caps = [_positive_rational(value, f"caps[{index}]") for index, value in enumerate(raw_caps)]
    dimension = len(caps)

    raw_groups = packet["groups"]
    if not isinstance(raw_groups, list) or not raw_groups:
        raise ValueError("groups must be a nonempty list")
    groups: list[tuple[tuple[int, ...], Fraction]] = []
    covered: list[int] = []
    previous_first = -1
    for group_index, raw_group in enumerate(raw_groups):
        path = f"groups[{group_index}]"
        if not isinstance(raw_group, dict) or set(raw_group) != GROUP_FIELDS:
            raise ValueError(f"{path}: fields must be exactly {sorted(GROUP_FIELDS)}")
        variables = raw_group["vars"]
        if (
            not isinstance(variables, list)
            or not variables
            or any(isinstance(item, bool) or not isinstance(item, int) for item in variables)
        ):
            raise ValueError(f"{path}.vars: expected a nonempty integer list")
        if variables != sorted(set(variables)):
            raise ValueError(f"{path}.vars: indices must be unique and increasing")
        if variables[0] <= previous_first:
            raise ValueError("groups must be ordered by their first variable index")
        if variables[0] < 0 or variables[-1] >= dimension:
            raise ValueError(f"{path}.vars: index outside caps")
        previous_first = variables[0]
        product = _positive_rational(raw_group["product"], f"{path}.product")
        cap_product = Fraction(1)
        for variable in variables:
            cap_product *= caps[variable]
        if domain == "closed" and product > cap_product:
            raise ValueError(f"{path}: product exceeds cap product")
        if domain == "strict" and product >= cap_product:
            raise ValueError(f"{path}: strict domain requires product below cap product")
        groups.append((tuple(variables), product))
        covered.extend(variables)
    if sorted(covered) != list(range(dimension)) or len(covered) != dimension:
        raise ValueError("groups must be disjoint and partition all variables")

    raw_objectives = packet["objectives"]
    if not isinstance(raw_objectives, list) or not raw_objectives:
        raise ValueError("objectives must be a nonempty list")
    objectives: list[tuple[str, list[tuple[Fraction, tuple[int, ...]]]]] = []
    seen_ids: set[str] = set()
    for objective_index, raw_objective in enumerate(raw_objectives):
        path = f"objectives[{objective_index}]"
        if not isinstance(raw_objective, dict) or set(raw_objective) != OBJECTIVE_FIELDS:
            raise ValueError(f"{path}: fields must be exactly {sorted(OBJECTIVE_FIELDS)}")
        identifier = _text(raw_objective["id"], f"{path}.id")
        if identifier in seen_ids:
            raise ValueError(f"{path}.id: expected a distinct string")
        seen_ids.add(identifier)
        raw_terms = raw_objective["terms"]
        if not isinstance(raw_terms, list) or not raw_terms:
            raise ValueError(f"{path}.terms: expected a nonempty list")
        terms: list[tuple[Fraction, tuple[int, ...]]] = []
        for term_index, raw_term in enumerate(raw_terms):
            term_path = f"{path}.terms[{term_index}]"
            if not isinstance(raw_term, dict) or set(raw_term) != TERM_FIELDS:
                raise ValueError(f"{term_path}: fields must be exactly {sorted(TERM_FIELDS)}")
            coefficient = _positive_rational(raw_term["coefficient"], f"{term_path}.coefficient")
            raw_exponents = raw_term["exponents"]
            if not isinstance(raw_exponents, list) or len(raw_exponents) != dimension:
                raise ValueError(f"{term_path}.exponents: length must equal caps length")
            if any(not isinstance(value, str) or not INTEGER_TEXT.fullmatch(value) for value in raw_exponents):
                raise ValueError(f"{term_path}.exponents: expected canonical integer strings")
            terms.append((coefficient, tuple(map(int, raw_exponents))))
        objectives.append((identifier, terms))
    return domain, caps, groups, objectives


def _vertices(
    caps: list[Fraction], groups: list[tuple[tuple[int, ...], Fraction]]
) -> list[tuple[tuple[int | None, ...], tuple[Fraction, ...]]]:
    choices: list[tuple[int | None, ...]] = []
    ratios: list[Fraction] = []
    for variables, product in groups:
        cap_product = Fraction(1)
        for variable in variables:
            cap_product *= caps[variable]
        if product == cap_product:
            choices.append((None,))
            ratios.append(Fraction(1))
        else:
            choices.append(tuple(variables))
            ratios.append(product / cap_product)
    answer = []
    for slack_tuple in itertools.product(*choices):
        point = caps[:]
        for slack, ratio in zip(slack_tuple, ratios, strict=True):
            if slack is not None:
                point[slack] *= ratio
        answer.append((tuple(slack_tuple), tuple(point)))
    return answer


def _evaluate(terms: list[tuple[Fraction, tuple[int, ...]]], point: tuple[Fraction, ...]) -> Fraction:
    total = Fraction(0)
    for coefficient, exponents in terms:
        monomial = coefficient
        for value, exponent in zip(point, exponents, strict=True):
            monomial *= value ** exponent
        total += monomial
    return total


def check(packet: Any) -> dict[str, Any]:
    domain, caps, groups, objectives = _validate(packet)
    vertices = _vertices(caps, groups)
    results = []
    for identifier, terms in objectives:
        evaluated = [(_evaluate(terms, point), slack) for slack, point in vertices]
        extremum = max(value for value, _ in evaluated)
        maximizers = [list(slack) for value, slack in evaluated if value == extremum]
        results.append({
            "id": identifier,
            "extremum_kind": "maximum" if domain == "closed" else "supremum",
            "value": _tag(extremum),
            "closure_vertex_slack": maximizers,
            "strict_domain_attainment": "not_decided" if domain == "strict" else "attained",
        })
    return {
        "schema": "monomial-vertex-result/v1",
        "problem_sha256": hashlib.sha256(_canonical(packet)).hexdigest(),
        "domain": domain,
        "dimension": len(caps),
        "group_count": len(groups),
        "closure_vertex_count": len(vertices),
        "objectives": results,
        "trust_boundary": (
            "exact for the supplied rational caps, disjoint product laws, and "
            "positive Laurent objectives; external mathematics must prove those inputs"
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    args = parser.parse_args()
    try:
        result = check(load_exact_json(args.input))
    except (OSError, ValueError) as exc:
        parser.error(str(exc))
    print(json.dumps(result, sort_keys=True, indent=2))


if __name__ == "__main__":
    main()
