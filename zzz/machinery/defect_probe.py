#!/usr/bin/env python3
"""Exact binary observer compiled from a same-resultant Smith defect.

This module constructs the two decic multiplication maps over F_2, derives a
one-query separating input, and interprets a measured output as an action-table
selection.  It does not claim that external hardware realizes either map.
"""

from __future__ import annotations

from dataclasses import asdict, dataclass
from fractions import Fraction
import hashlib
import json
from math import comb
from pathlib import Path
from typing import Iterable, Sequence


QA = (1, -1, -1, 1, 0, 1, 1, -1, -1, 0, 1)
QB = (1, -1, 0, -1, 1, -1, 1, 0, 1, 0, 1)
N = 10


def trim(poly: Sequence[int]) -> tuple[int, ...]:
    values = list(poly)
    while len(values) > 1 and values[-1] == 0:
        values.pop()
    return tuple(values)


def reduce_mod2(poly: Sequence[int], modulus: Sequence[int]) -> tuple[int, ...]:
    """Return the degree-<N remainder over F_2 for a monic modulus."""
    mod = tuple(value & 1 for value in modulus)
    if len(mod) != N + 1 or mod[-1] != 1:
        raise ValueError("modulus must be monic of degree 10")
    out = list(value & 1 for value in poly)
    while len(out) > N:
        if out[-1]:
            shift = len(out) - len(mod)
            for index, value in enumerate(mod):
                out[shift + index] ^= value
        out.pop()
    out += [0] * (N - len(out))
    return tuple(out)


def multiplication_matrix(
    modulus: Sequence[int], multiplier: Sequence[int]
) -> tuple[tuple[int, ...], ...]:
    """Matrix of multiplication in F_2[x]/(modulus), column convention."""
    columns = []
    for column in range(N):
        columns.append(reduce_mod2((0,) * column + tuple(multiplier), modulus))
    return tuple(tuple(columns[column][row] for column in range(N))
                 for row in range(N))


def matvec(matrix: Sequence[Sequence[int]], vector: Sequence[int]) -> tuple[int, ...]:
    if len(matrix) != N or any(len(row) != N for row in matrix) or len(vector) != N:
        raise ValueError("expected a 10 by 10 matrix and 10-bit vector")
    if any(value not in (0, 1) for value in vector):
        raise ValueError("vector entries must be bits")
    return tuple(sum(entry * value for entry, value in zip(row, vector)) & 1
                 for row in matrix)


def bit_vectors() -> Iterable[tuple[int, ...]]:
    """Nonzero vectors in deterministic integer order, low bit first."""
    for word in range(1, 1 << N):
        yield tuple((word >> bit) & 1 for bit in range(N))


def derive_separator(
    left: Sequence[Sequence[int]], right: Sequence[Sequence[int]]
) -> tuple[int, ...]:
    """Return the first vector killed by exactly one candidate map."""
    for vector in bit_vectors():
        left_zero = not any(matvec(left, vector))
        right_zero = not any(matvec(right, vector))
        if left_zero != right_zero:
            return vector
    raise ValueError("candidate maps have no zero/nonzero separating input")


def hamming_distance(left: Sequence[int], right: Sequence[int]) -> int:
    if len(left) != len(right):
        raise ValueError("words must have equal length")
    return sum(a != b for a, b in zip(left, right))


def derive_max_hamming_probe(
    left: Sequence[Sequence[int]], right: Sequence[Sequence[int]]
) -> tuple[tuple[int, ...], int, int]:
    """Return first optimum, maximum distance, and number of maximizers."""
    best_distance = -1
    best_vectors: list[tuple[int, ...]] = []
    for vector in bit_vectors():
        distance = hamming_distance(matvec(left, vector), matvec(right, vector))
        if distance > best_distance:
            best_distance, best_vectors = distance, [vector]
        elif distance == best_distance:
            best_vectors.append(vector)
    if not best_vectors:
        raise AssertionError("nonzero vector enumeration was empty")
    return best_vectors[0], best_distance, len(best_vectors)


def ml_error_probability(
    distance: int, epsilon: Fraction, repetitions: int = 1
) -> Fraction:
    """Equal-prior ML error for repeated codewords through an exact BSC."""
    epsilon = Fraction(epsilon)
    if distance <= 0 or repetitions <= 0:
        raise ValueError("distance and repetitions must be positive")
    if not 0 <= epsilon < Fraction(1, 2):
        raise ValueError("epsilon must satisfy 0 <= epsilon < 1/2")
    trials = distance * repetitions
    answer = Fraction()
    for flips in range(trials // 2 + 1, trials + 1):
        answer += comb(trials, flips) * epsilon**flips * (1-epsilon)**(trials-flips)
    if trials % 2 == 0:
        flips = trials // 2
        answer += Fraction(1, 2) * comb(trials, flips) * epsilon**flips * (1-epsilon)**flips
    return answer


def minimum_repetitions(
    distance: int, epsilon: Fraction, target_error: Fraction, max_repetitions: int
) -> int:
    target_error = Fraction(target_error)
    if not 0 <= target_error < Fraction(1, 2):
        raise ValueError("target_error must satisfy 0 <= target_error < 1/2")
    if max_repetitions <= 0:
        raise ValueError("max_repetitions must be positive")
    for repetitions in range(1, max_repetitions + 1):
        if ml_error_probability(distance, epsilon, repetitions) <= target_error:
            return repetitions
    raise ValueError("target error not reached within max_repetitions")


def canonical_json(value: object) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def sha256_json(value: object) -> str:
    return hashlib.sha256(canonical_json(value).encode()).hexdigest()


@dataclass(frozen=True)
class CompiledProbe:
    schema: str
    candidates: tuple[str, str]
    matrices_sha256: str
    input_bits_low_degree_first: tuple[int, ...]
    predicted_outputs: dict[str, tuple[int, ...]]
    action_table: dict[str, str]
    robust_bsc_probe: dict[str, object]
    missing_external_record: dict[str, object]
    trust_boundary: str


def compile_probe() -> CompiledProbe:
    matrices = {
        "qA": multiplication_matrix(QA, tuple(reversed(QA))),
        "qB": multiplication_matrix(QB, tuple(reversed(QB))),
    }
    vector = derive_separator(matrices["qA"], matrices["qB"])
    outputs = {name: matvec(matrix, vector) for name, matrix in matrices.items()}
    if outputs["qA"] == outputs["qB"] or all(outputs["qA"]) and all(outputs["qB"]):
        raise AssertionError("derived probe does not separate candidate outputs")
    if any(outputs["qA"]) and any(outputs["qB"]):
        raise AssertionError("separator must classify through a zero output")
    output_actions = {
        canonical_json(list(output)): f"select-{name}-decoder"
        for name, output in outputs.items()
    }
    if len(output_actions) != 2:
        raise AssertionError("action table is not separating")
    robust_vector, robust_distance, robust_multiplicity = derive_max_hamming_probe(
        matrices["qA"], matrices["qB"]
    )
    robust_outputs = {
        name: matvec(matrix, robust_vector) for name, matrix in matrices.items()
    }
    return CompiledProbe(
        schema="finite-defect-probe/v1",
        candidates=("qA", "qB"),
        matrices_sha256=sha256_json(matrices),
        input_bits_low_degree_first=vector,
        predicted_outputs=outputs,
        action_table=output_actions,
        robust_bsc_probe={
            "objective": "maximize Hamming distance under equal-prior independent BSC noise",
            "input_bits_low_degree_first": robust_vector,
            "predicted_outputs": robust_outputs,
            "hamming_distance": robust_distance,
            "maximizer_count_over_nonzero_inputs": robust_multiplicity,
            "semantic_kernel_probe_hamming_distance": hamming_distance(
                outputs["qA"], outputs["qB"]
            ),
        },
        missing_external_record={
            "status": "NOT_MEASURED",
            "required_fields": [
                "device_id",
                "netlist_sha256",
                "probe_input_bits_low_degree_first",
                "raw_output_samples",
                "sample_units",
                "sample_times",
                "threshold_calibration",
                "decoded_output_bits_low_degree_first",
                "selected_action",
                "selected_action_artifact_sha256",
                "post_action_observation",
                "environment_and_error_model",
            ],
        },
        trust_boundary=(
            "Exact for the declared F_2 polynomial maps and ideal bit response. "
            "No external device has been measured; this is not evidence that "
            "either candidate divides a prime-prefix polynomial."
        ),
    )


def select_action(compiled: CompiledProbe, measured_bits: Sequence[int]) -> str:
    bits = tuple(measured_bits)
    if len(bits) != N or any(value not in (0, 1) for value in bits):
        raise ValueError("measurement must be exactly ten bits")
    key = canonical_json(list(bits))
    try:
        return compiled.action_table[key]
    except KeyError as exc:
        raise ValueError("measurement matches neither declared candidate") from exc


def main() -> int:
    compiled = compile_probe()
    print(json.dumps(asdict(compiled), sort_keys=True, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
