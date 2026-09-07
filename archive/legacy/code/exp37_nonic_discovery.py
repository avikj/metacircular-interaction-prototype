#!/usr/bin/env python3
"""Exact first-stage discovery for possible nonic prime-prefix factors.

This is a workload experiment, not a factor-classification certificate.  It
uses only consequences already proved in the repository:

* the parity unit equation ``Res(E,O)=+-1``;
* the unique negative-root window ``309/500 < t < 79/125``;
* the general odd-support root annulus ``phi^-1 < |z| < 2``;
* coefficient and first-Graeffe boxes derived below from those facts.

The companion C++ program is sharded by the endpoint coefficients ``(a,j)``.
Python independently checks every emitted unit resultant.  Floating point is
used only for timing/display; all mathematical decisions are integral or
rational.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp37 uses load-bearing assertions and must not run under python -O")

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from fractions import Fraction as Q
import hashlib
import json
import os
from pathlib import Path
import random
import shutil
import subprocess
import sys
import tempfile
from time import perf_counter


LOWER = Q(309, 500)
UPPER = Q(79, 125)

# Strict rational upper bounds.  Their defining algebraic inequalities are
# checked in ``derive_boxes`` rather than trusted as decimal approximations.
LAMBDA_UPPER = Q(309_017, 500_000)
PHI_UPPER = Q(809_017, 500_000)
SQRT_PHI_UPPER = Q(63_601, 50_000)

# Bounds for (a,b,c,d,e,f,h,j).
COEFFICIENT_BOX = (10, 46, 116, 181, 180, 115, 45, 10)

# Bounds for coefficients y^1,...,y^8 of G=E^2-yO^2.  The majorant
# coefficient e_k bounds y^(9-k), so this tuple is intentionally the reverse
# of the majorant's degrees 1,...,8.
GRAEFFE_BOX = (14, 85, 270, 493, 516, 300, 95, 15)

ROOT = Path(__file__).resolve().parents[1]
SPEC = ROOT / "machinery" / "specs" / "nonic-prime-prefix.json"
BOUND_CONTRACT = ROOT / "machinery" / "specs" / "nonic-graeffe-exp37.json"
BOUND_HEADER = Path(__file__).with_name("exp37_nonic_bounds.hpp")
BOUND_TOOL = ROOT / "machinery" / "bound_contract.py"
CPU_LEDGER = ROOT / "machinery" / "cpu_ledger.py"


def multiply_scalar_polynomials(left: list[Q], right: list[Q]) -> list[Q]:
    answer = [Q(0)] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] += x * y
    return answer


def majorant(factors: tuple[tuple[Q, int], ...]) -> list[Q]:
    answer = [Q(1)]
    for radius, multiplicity in factors:
        for _ in range(multiplicity):
            answer = multiply_scalar_polynomials(answer, [Q(1), radius])
    return answer


def derive_boxes() -> tuple[tuple[int, ...], tuple[int, ...]]:
    """Verify rational majorants for the coefficient and Graeffe boxes.

    If the nonreal roots have pair radii r_1,...,r_4 and the negative root is
    -t, then t*(product r_i)^2=1.  At fixed t, each coefficient of

        (1+t*z) product_i (1+r_i*z)^2

    is a convex symmetric function of log(r_i), so a maximum on the box with
    fixed sum occurs at a vertex.  The only feasible vertex type is

        {2, lambda, lambda, phi^2/(2*sqrt(t))}.

    Grouping the t-dependent factors shows their first two coefficients are
    decreasing on lambda<t<79/125 and the third is constant.  Thus the strict
    supremum is at t=lambda, with radius multiset

        {lambda (five times), 2 (twice), phi^(5/2)/2 (twice)}.

    Squaring the radii gives the corresponding Graeffe majorant.  The proof of
    convexity/vertex reduction is mathematical documentation; the assertions
    below verify all rational relaxations and integer roundings exactly.
    """

    # The negative-root window is exact.  LOWER<lambda follows from
    # (2*LOWER+1)^2<5, while direct rational evaluation gives F_11(-UPPER)<0.
    lambda_lower_test = 2 * LOWER + 1
    assert lambda_lower_test > 0 and lambda_lower_test * lambda_lower_test < 5
    assert 1 - UPPER - UPPER**3 - UPPER**5 - UPPER**9 < 0

    # q > sqrt(5) is certified by q>0 and q^2>5.
    q_phi = 2 * PHI_UPPER - 1
    assert q_phi > 0 and q_phi * q_phi > 5
    q_lambda = 2 * LAMBDA_UPPER + 1
    assert q_lambda > 0 and q_lambda * q_lambda > 5
    q_sqrt_phi = 2 * SQRT_PHI_UPPER * SQRT_PHI_UPPER - 1
    assert q_sqrt_phi > 0 and q_sqrt_phi * q_sqrt_phi > 5

    # The monotonicity inequalities used in the t-dependent three-factor
    # block follow already from t<1, phi^2>2 and phi^4>4.
    assert UPPER < 1
    assert PHI_UPPER * PHI_UPPER > 2
    assert PHI_UPPER**4 > 4

    v_upper = PHI_UPPER**2 * SQRT_PHI_UPPER / 2
    coefficient_majorant = majorant((
        (Q(2), 2),
        (LAMBDA_UPPER, 5),
        (v_upper, 2),
    ))
    assert len(coefficient_majorant) == 10
    coefficient_box = tuple(value.numerator // value.denominator
                            for value in coefficient_majorant[1:9])
    assert coefficient_box == COEFFICIENT_BOX

    squared_v_upper = PHI_UPPER**5 / 4
    graeffe_majorant = majorant((
        (Q(4), 2),
        (LAMBDA_UPPER**2, 5),
        (squared_v_upper, 2),
    ))
    assert len(graeffe_majorant) == 10
    # G(y)=-product_i(y-alpha_i^2).  Thus [y^k]G is (up to sign)
    # e_(9-k)(alpha_i^2), not e_k.  This reversal is load-bearing.
    graeffe_box = tuple(reversed(tuple(
        value.numerator // value.denominator
        for value in graeffe_majorant[1:9]
    )))
    assert graeffe_box == GRAEFFE_BOX
    return coefficient_box, graeffe_box


# Sparse multivariate integer polynomials in variables a,b,c,d,e,f,h,j.
Monomial = tuple[int, int, int, int, int, int, int, int]
Expression = dict[Monomial, int]
ZERO_MONOMIAL: Monomial = (0,) * 8


def expression_constant(value: int) -> Expression:
    return {} if value == 0 else {ZERO_MONOMIAL: value}


def expression_variable(index: int) -> Expression:
    exponent = [0] * 8
    exponent[index] = 1
    return {tuple(exponent): 1}


def expression_add(left: Expression, right: Expression, scale: int = 1) -> Expression:
    answer = dict(left)
    for monomial, coefficient in right.items():
        answer[monomial] = answer.get(monomial, 0) + scale * coefficient
        if answer[monomial] == 0:
            del answer[monomial]
    return answer


def expression_multiply(left: Expression, right: Expression) -> Expression:
    answer: Expression = {}
    for left_monomial, left_coefficient in left.items():
        for right_monomial, right_coefficient in right.items():
            monomial = tuple(x + y for x, y in zip(left_monomial, right_monomial))
            answer[monomial] = answer.get(monomial, 0) + left_coefficient * right_coefficient
    return {monomial: coefficient for monomial, coefficient in answer.items() if coefficient}


def expression_scale(expression: Expression, scalar: int) -> Expression:
    return {monomial: scalar * coefficient for monomial, coefficient in expression.items()
            if scalar * coefficient}


def symbolic_convolution(left: list[Expression], right: list[Expression]) -> list[Expression]:
    answer = [expression_constant(0) for _ in range(len(left) + len(right) - 1)]
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] = expression_add(answer[i + j], expression_multiply(x, y))
    return answer


def monomial(*indices: int) -> Expression:
    answer = expression_constant(1)
    for index in indices:
        answer = expression_multiply(answer, expression_variable(index))
    return answer


def linear_combination(terms: tuple[tuple[int, Expression], ...]) -> Expression:
    answer = expression_constant(0)
    for coefficient, expression in terms:
        answer = expression_add(answer, expression_scale(expression, coefficient))
    return answer


def check_graeffe_identity() -> None:
    a, b, c, d, e, f, h, j = (expression_variable(index) for index in range(8))
    one = expression_constant(1)
    even = [one, h, e, c, a]
    odd = [j, f, d, b, one]
    actual = symbolic_convolution(even, even)
    odd_square = symbolic_convolution(odd, odd)
    actual += [expression_constant(0)]
    for exponent, coefficient in enumerate(odd_square, start=1):
        actual[exponent] = expression_add(actual[exponent], coefficient, scale=-1)

    expected = [
        one,
        linear_combination(((2, h), (-1, monomial(7, 7)))),
        linear_combination(((2, e), (1, monomial(6, 6)), (-2, monomial(7, 5)))),
        linear_combination(((2, c), (2, monomial(6, 4)),
                            (-2, monomial(7, 3)), (-1, monomial(5, 5)))),
        linear_combination(((2, a), (2, monomial(6, 2)),
                            (1, monomial(4, 4)), (-2, monomial(7, 1)),
                            (-2, monomial(5, 3)))),
        linear_combination(((2, monomial(6, 0)), (2, monomial(4, 2)),
                            (-2, j), (-2, monomial(5, 1)),
                            (-1, monomial(3, 3)))),
        linear_combination(((2, monomial(4, 0)), (1, monomial(2, 2)),
                            (-2, f), (-2, monomial(3, 1)))),
        linear_combination(((2, monomial(2, 0)), (-2, d),
                            (-1, monomial(1, 1)))),
        linear_combination(((1, monomial(0, 0)), (-2, b))),
        expression_constant(-1),
    ]
    assert actual == expected

    # The C++ prefilter eliminates e without strengthening either inequality:
    # |g_3-h*g_2| <= 270+85|h| and
    # |g_6-a*g_2| <= 300+85|a| are immediate triangle inequalities.
    eliminated_g3 = expression_add(
        expected[3], expression_multiply(h, expected[2]), scale=-1
    )
    expected_eliminated_g3 = linear_combination((
        (-1, monomial(5, 5)), (2, monomial(6, 7, 5)),
        (2, c), (-2, monomial(7, 3)), (-1, monomial(6, 6, 6)),
    ))
    assert eliminated_g3 == expected_eliminated_g3

    eliminated_g6 = expression_add(
        expected[6], expression_multiply(a, expected[2]), scale=-1
    )
    expected_eliminated_g6 = linear_combination((
        (2, monomial(0, 7, 5)), (-1, monomial(0, 6, 6)),
        (1, monomial(2, 2)), (-2, f), (-2, monomial(3, 1)),
    ))
    assert eliminated_g6 == expected_eliminated_g6


def trim_descending(polynomial: list[int]) -> list[int]:
    while len(polynomial) > 1 and polynomial[0] == 0:
        polynomial.pop(0)
    return polynomial


def bareiss_determinant(matrix: list[list[int]]) -> int:
    matrix = [row[:] for row in matrix]
    previous = 1
    sign = 1
    for pivot_column in range(len(matrix) - 1):
        pivot_row = next((row for row in range(pivot_column, len(matrix))
                          if matrix[row][pivot_column]), None)
        if pivot_row is None:
            return 0
        if pivot_row != pivot_column:
            matrix[pivot_column], matrix[pivot_row] = matrix[pivot_row], matrix[pivot_column]
            sign = -sign
        pivot = matrix[pivot_column][pivot_column]
        for row in range(pivot_column + 1, len(matrix)):
            for column in range(pivot_column + 1, len(matrix)):
                numerator = (matrix[row][column] * pivot
                             - matrix[row][pivot_column] * matrix[pivot_column][column])
                assert numerator % previous == 0
                matrix[row][column] = numerator // previous
        for row in range(pivot_column + 1, len(matrix)):
            matrix[row][pivot_column] = 0
        previous = pivot
    return sign * matrix[-1][-1]


def fraction_determinant(matrix: list[list[int]]) -> int:
    matrix_q = [[Q(value) for value in row] for row in matrix]
    sign = 1
    determinant = Q(1)
    for column in range(len(matrix_q)):
        pivot_row = next((row for row in range(column, len(matrix_q))
                          if matrix_q[row][column]), None)
        if pivot_row is None:
            return 0
        if pivot_row != column:
            matrix_q[column], matrix_q[pivot_row] = matrix_q[pivot_row], matrix_q[column]
            sign = -sign
        pivot = matrix_q[column][column]
        determinant *= pivot
        for entry in range(column, len(matrix_q)):
            matrix_q[column][entry] /= pivot
        for row in range(column + 1, len(matrix_q)):
            multiplier = matrix_q[row][column]
            for entry in range(column, len(matrix_q)):
                matrix_q[row][entry] -= multiplier * matrix_q[column][entry]
    answer = sign * determinant
    assert answer.denominator == 1
    return answer.numerator


def sylvester_matrix(left_descending: list[int], right_descending: list[int]) -> list[list[int]]:
    left_descending = trim_descending(left_descending[:])
    right_descending = trim_descending(right_descending[:])
    left_degree = len(left_descending) - 1
    right_degree = len(right_descending) - 1
    matrix = []
    for shift in range(right_degree):
        matrix.append([0] * shift + left_descending + [0] * (right_degree - 1 - shift))
    for shift in range(left_degree):
        matrix.append([0] * shift + right_descending + [0] * (left_degree - 1 - shift))
    return matrix


def resultant(left_descending: list[int], right_descending: list[int],
              independent: bool = False) -> int:
    matrix = sylvester_matrix(left_descending, right_descending)
    return fraction_determinant(matrix) if independent else bareiss_determinant(matrix)


def parity_parts(candidate: tuple[int, ...]) -> tuple[list[int], list[int]]:
    a, b, c, d, e, f, h, j = candidate
    return [a, c, e, h, 1], [1, b, d, f, j]


def parity_resultant(candidate: tuple[int, ...], independent: bool = False) -> int:
    even, odd = parity_parts(candidate)
    return resultant(even, odd, independent=independent)


def check_resultant_identities() -> None:
    generator = random.Random(37)
    for iteration in range(64):
        candidate = tuple(generator.randint(-4, 4) for _ in range(8))
        even, odd = parity_parts(candidate)
        direct = resultant(even, odd)
        assert direct == resultant(even, odd, independent=True)

        # This also catches the ascending/descending Sylvester orientation.
        if iteration < 12:
            a, b, c, d, e, f, h, j = candidate
            g = [1, a, b, c, d, e, f, h, j, 1]
            g_negative = [coefficient * (-1 if (9 - index) % 2 else 1)
                          for index, coefficient in enumerate(g)]
            assert resultant(g, g_negative) == 2**9 * direct * direct


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check_bound_contract(directory: Path) -> None:
    generated_header = directory / "exp37_nonic_bounds.generated.hpp"
    subprocess.run([
        sys.executable,
        str(BOUND_TOOL),
        str(BOUND_CONTRACT),
        "--emit-cpp",
        str(generated_header),
        "--symbol",
        "kGraeffeBounds",
    ], check=True, capture_output=True, text=True)
    assert generated_header.read_bytes() == BOUND_HEADER.read_bytes()

    contract = json.loads(BOUND_CONTRACT.read_text(encoding="utf-8"))
    bounds = contract["bounds_by_exponent"]
    assert tuple(int(bounds[str(exponent)]) for exponent in range(1, 9)) == GRAEFFE_BOX
    assert contract["derived_vector"]["orientation"] == "leading-to-constant"
    assert tuple(map(int, contract["derived_vector"]["values"])) \
        == tuple(reversed(GRAEFFE_BOX))

    spec = json.loads(SPEC.read_text(encoding="utf-8"))
    assert spec["bound_contract"]["path"] == "machinery/specs/nonic-graeffe-exp37.json"
    assert spec["bound_contract"]["sha256"] == file_sha256(BOUND_CONTRACT)


@dataclass(frozen=True)
class Shard:
    a: int
    j: int
    endpoint: int
    cd: int
    cdf_raw: int
    eliminated: int
    scalar: int
    graeffe: int
    unit: int
    candidates: tuple[tuple[int, ...], ...]


def compile_enumerator(directory: Path) -> Path:
    compiler = shutil.which("c++") or shutil.which("g++") or shutil.which("clang++")
    if compiler is None:
        raise RuntimeError("an ISO C++17 compiler is required")
    check_bound_contract(directory)
    source = Path(__file__).with_name("exp37_nonic_enumerator.cpp")
    binary = directory / "exp37_nonic_enumerator"
    subprocess.run([compiler, "-std=c++17", "-O3", str(source), "-o", str(binary)],
                   check=True)
    return binary


def parse_candidate_line(line: str) -> tuple[int, ...]:
    value = json.loads(line)
    assert isinstance(value, dict) and set(value) == {"coefficients"}
    coefficients = value["coefficients"]
    assert isinstance(coefficients, list) and len(coefficients) == 8
    candidate = tuple(int(coefficient) for coefficient in coefficients)
    assert [str(coefficient) for coefficient in candidate] == coefficients
    return candidate


def load_candidates(path: Path) -> tuple[tuple[int, ...], ...]:
    return tuple(parse_candidate_line(line) for line in path.read_text(encoding="utf-8").splitlines()
                 if line.strip())


def shard_index(a: int, j: int) -> int:
    return (a + 10) * 21 + (j + 10)


def load_checkpoint(a: int, j: int, directory: Path) -> Shard | None:
    index = shard_index(a, j)
    candidate_path = directory / f"shard-{index:03d}.jsonl"
    manifest_path = directory / f"shard-{index:03d}.manifest.json"
    if not manifest_path.exists():
        return None
    verification = subprocess.run(
        [sys.executable, str(CPU_LEDGER), "verify", str(manifest_path)],
        text=True, capture_output=True,
    )
    if verification.returncode != 0:
        raise RuntimeError(verification.stdout + verification.stderr)
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    domain = manifest["shard"]["domain"]
    assert domain["a"] == a and domain["j"] == j
    stages = {item["stage"]: item["count"] for item in manifest["stages"]}
    candidates = load_candidates(candidate_path)
    return Shard(
        a, j, domain["endpoint"], domain["cd"], stages["cdf_raw"],
        stages["eliminated"], stages["scalar"], stages["graeffe"],
        stages["unit"], candidates,
    )


def record_checkpoint(result: Shard, candidate_path: Path, directory: Path,
                      binary: Path) -> None:
    index = shard_index(result.a, result.j)
    manifest_path = directory / f"shard-{index:03d}.manifest.json"
    domain = json.dumps({
        "a": result.a,
        "j": result.j,
        "endpoint": result.endpoint,
        "cd": result.cd,
    }, sort_keys=True, separators=(",", ":"))
    stages = json.dumps([
        {"stage": "cdf_raw", "count": result.cdf_raw},
        {"stage": "eliminated", "count": result.eliminated},
        {"stage": "scalar", "count": result.scalar},
        {"stage": "graeffe", "count": result.graeffe},
        {"stage": "unit", "count": result.unit},
    ], separators=(",", ":"))
    subprocess.run([
        sys.executable,
        str(CPU_LEDGER),
        "record",
        "--spec", str(SPEC),
        "--kernel", str(Path(__file__).with_name("exp37_nonic_enumerator.cpp")),
        "--candidates", str(candidate_path),
        "--shard-index", str(index),
        "--shard-count", "441",
        "--domain", domain,
        "--stage-counts", stages,
        "--command", f"{binary} {result.a} {result.j}",
        "--output", str(manifest_path),
    ], check=True, capture_output=True, text=True)


def run_shard(binary: Path, a: int, j: int,
              checkpoint_directory: Path | None) -> Shard:
    if checkpoint_directory is not None:
        checkpoint = load_checkpoint(a, j, checkpoint_directory)
        if checkpoint is not None:
            return checkpoint
        index = shard_index(a, j)
        candidate_path = checkpoint_directory / f"shard-{index:03d}.jsonl"
        with candidate_path.open("w", encoding="utf-8") as output:
            process = subprocess.run([str(binary), str(a), str(j)], text=True,
                                     stdout=output, stderr=subprocess.PIPE, check=True)
        candidates = load_candidates(candidate_path)
    else:
        process = subprocess.run([str(binary), str(a), str(j)], text=True,
                                 capture_output=True, check=True)
        candidates = tuple(parse_candidate_line(line)
                           for line in process.stdout.splitlines() if line.strip())
    ledger = tuple(map(int, process.stderr.split()))
    assert len(ledger) == 9 and ledger[:2] == (a, j), ledger
    assert len(candidates) == ledger[-1]
    assert len(candidates) == len(set(candidates))
    for candidate in candidates:
        assert candidate[0] == a and candidate[-1] == j
        assert abs(parity_resultant(candidate)) == 1
    result = Shard(*ledger, candidates)
    if checkpoint_directory is not None:
        record_checkpoint(result, candidate_path, checkpoint_directory, binary)
    return result


def candidate_digest(candidates: list[tuple[int, ...]]) -> str:
    canonical = "".join(" ".join(map(str, candidate)) + "\n"
                        for candidate in sorted(candidates))
    return hashlib.sha256(canonical.encode("ascii")).hexdigest()


def discovery(shard: tuple[int, int] | None, workers: int,
              checkpoint_directory: Path | None) -> dict[str, object]:
    start = perf_counter()
    if checkpoint_directory is not None:
        checkpoint_directory.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="exp37-nonic-") as directory_name:
        binary = compile_enumerator(Path(directory_name))
        pairs = [shard] if shard is not None else [
            (a, j) for a in range(-10, 11) for j in range(-10, 11)
        ]
        results: list[Shard] = []
        with ThreadPoolExecutor(max_workers=workers) as pool:
            futures = {
                pool.submit(run_shard, binary, a, j, checkpoint_directory): (a, j)
                for a, j in pairs
            }
            for future in as_completed(futures):
                results.append(future.result())
                completed = len(results)
                print(f"exp37 checkpoint {completed}/{len(pairs)}", file=sys.stderr,
                      flush=True)

    results.sort(key=lambda item: (item.a, item.j))
    candidates = [candidate for result in results for candidate in result.candidates]
    assert len(candidates) == len(set(candidates))
    count_fields = ("endpoint", "cd", "cdf_raw", "eliminated", "scalar",
                    "graeffe", "unit")
    totals = {field: sum(getattr(result, field) for result in results)
              for field in count_fields}
    return {
        "experiment": "exp37-nonic-discovery",
        "status": "discovery-only",
        "proved_pruning_only": True,
        "coefficient_box": list(COEFFICIENT_BOX),
        "graeffe_box": list(GRAEFFE_BOX),
        "negative_root_window": [[LOWER.numerator, LOWER.denominator],
                                 [UPPER.numerator, UPPER.denominator]],
        "shard_count": len(results),
        "workers": workers,
        "totals": totals,
        "candidate_sha256": candidate_digest(candidates),
        "spec_sha256": file_sha256(SPEC),
        "kernel_sha256": file_sha256(Path(__file__).with_name("exp37_nonic_enumerator.cpp")),
        "bound_contract_sha256": file_sha256(BOUND_CONTRACT),
        "bounds_header_sha256": file_sha256(BOUND_HEADER),
        "elapsed_seconds_display_only": perf_counter() - start,
        "shards": [
            {field: getattr(result, field)
             for field in ("a", "j", *count_fields)}
            for result in results
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shard", nargs=2, type=int, metavar=("A", "J"))
    parser.add_argument("--all", action="store_true")
    parser.add_argument("--workers", type=int, default=max(1, min(8, os.cpu_count() or 1)))
    parser.add_argument("--symbolic-only", action="store_true")
    parser.add_argument("--checkpoint-dir", type=Path)
    parser.add_argument("--ledger-out", type=Path)
    args = parser.parse_args()
    if args.shard is not None and args.all:
        parser.error("choose --shard or --all, not both")
    assert args.workers > 0

    derive_boxes()
    check_graeffe_identity()
    check_resultant_identities()
    if args.symbolic_only:
        print("nonic symbolic discovery checks: PASS")
        print(f"coefficient box: {COEFFICIENT_BOX}")
        print(f"Graeffe box: {GRAEFFE_BOX}")
        return

    selected_shard = None if args.all else tuple(args.shard or (0, 0))
    if selected_shard is not None:
        assert all(-10 <= value <= 10 for value in selected_shard)
    ledger = discovery(selected_shard, args.workers, args.checkpoint_dir)
    rendered = json.dumps(ledger, sort_keys=True, indent=2)
    if args.ledger_out is not None:
        args.ledger_out.write_text(rendered + "\n", encoding="utf-8")
    print(rendered)


if __name__ == "__main__":
    main()
