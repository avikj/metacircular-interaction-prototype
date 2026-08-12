#!/usr/bin/env python3
"""Compile recursive multiplicative origins into prime-exponent coordinates."""

from __future__ import annotations

from dataclasses import dataclass
from math import prod

from arithmetic_life import ArithmeticLife
from kuttaka_update import CongruenceState, Incompatibility, add_constraint


@dataclass(frozen=True)
class FactorNode:
    value: int
    left: int | None
    right: int | None


@dataclass(frozen=True)
class ExponentForm:
    value: int
    powers: tuple[tuple[int, int], ...]
    derivation: tuple[FactorNode, ...]

    def reconstruct(self) -> int:
        return prod(prime ** exponent for prime, exponent in self.powers)


@dataclass(frozen=True)
class BezoutInverse:
    value: int
    modulus: int
    coefficient: int
    modulus_coefficient: int
    inverse: int

    def solve(self, target: int) -> int:
        """Solve value*z = target modulo modulus in the formed prime field."""
        return (self.inverse * target) % self.modulus


@dataclass(frozen=True)
class InverseLiftStep:
    prime: int
    from_exponent: int
    to_exponent: int
    modulus: int
    inverse: int


@dataclass(frozen=True)
class CompositeInverse:
    value: int
    modulus: int
    local_inverses: tuple[tuple[int, int], ...]
    lift_steps: tuple[InverseLiftStep, ...]
    inverse: int

    def solve(self, target: int) -> int:
        return (self.inverse * target) % self.modulus


@dataclass(frozen=True)
class LinearCongruenceSolution:
    coefficient: int
    target: int
    modulus: int
    overlap: int
    reduced_equation: tuple[int, int, int]
    residue: int
    solution_modulus: int
    lifts: tuple[int, ...]


@dataclass(frozen=True)
class LinearCongruenceObstruction:
    coefficient: int
    target: int
    modulus: int
    overlap: int


@dataclass(frozen=True)
class AffineSystemSolution:
    equations: tuple[LinearCongruenceSolution, ...]
    residue: int
    modulus: int


@dataclass(frozen=True)
class AffineSystemObstruction:
    accepted: tuple[LinearCongruenceSolution, ...]
    rejected: LinearCongruenceSolution
    state_residue: int
    state_modulus: int
    gcd: int
    difference: int


@dataclass(frozen=True)
class BinaryProjection:
    equation: tuple[int, int, int, int]
    eliminated_image_step: int
    projected: LinearCongruenceSolution


@dataclass(frozen=True)
class BinaryFiber:
    projection: BinaryProjection
    chosen_x: int
    reconstructed: LinearCongruenceSolution


@dataclass(frozen=True)
class UnitDeterminantSystemSolution:
    matrix: tuple[tuple[int, int], tuple[int, int]]
    target: tuple[int, int]
    modulus: int
    determinant: int
    determinant_inverse: int
    adjugate: tuple[tuple[int, int], tuple[int, int]]
    solution: tuple[int, int]


@dataclass(frozen=True)
class DiagonalSmithSolution:
    diagonal: tuple[int, int]
    target: tuple[int, int]
    modulus: int
    coordinates: tuple[LinearCongruenceSolution, LinearCongruenceSolution]
    kernel_size: int


@dataclass(frozen=True)
class DiagonalSmithObstruction:
    diagonal: tuple[int, int]
    target: tuple[int, int]
    modulus: int
    coordinate: int
    obstruction: LinearCongruenceObstruction


@dataclass(frozen=True)
class WitnessedSmithSolution:
    matrix: tuple[tuple[int, int], tuple[int, int]]
    target: tuple[int, int]
    modulus: int
    left: tuple[tuple[int, int], tuple[int, int]]
    diagonal: tuple[int, int]
    right: tuple[tuple[int, int], tuple[int, int]]
    transformed_target: tuple[int, int]
    diagonal_solution: DiagonalSmithSolution
    representative: tuple[int, int]
    kernel_generators: tuple[tuple[int, int], tuple[int, int]]
    generator_orders: tuple[int, int]


@dataclass(frozen=True)
class SmithStep:
    side: str
    kind: str
    target: int
    source: int | None = None
    multiple: int = 0

    def inverse(self) -> "SmithStep":
        if self.kind == "add":
            return SmithStep(self.side, self.kind, self.target, self.source, -self.multiple)
        if self.kind == "negate":
            return self
        raise ValueError("unknown elementary Smith step")


@dataclass(frozen=True)
class SmithPath:
    start: tuple[tuple[int, int], tuple[int, int]]
    finish: tuple[tuple[int, int], tuple[int, int]]
    steps: tuple[SmithStep, ...]
    left: tuple[tuple[int, int], tuple[int, int]]
    right: tuple[tuple[int, int], tuple[int, int]]


@dataclass(frozen=True)
class EuclideanColumnStep:
    before: tuple[int, int]
    quotient: int
    remainder: int
    operation: tuple[tuple[int, int], tuple[int, int]]
    after: tuple[int, int]


@dataclass(frozen=True)
class EuclideanColumnReduction:
    start: tuple[int, int]
    finish: tuple[int, int]
    steps: tuple[EuclideanColumnStep, ...]
    left: tuple[tuple[int, int], tuple[int, int]]


class ExponentWorld:
    """A persistent arithmetic coordinate chart formed by recursive factoring."""

    def __init__(self, life: ArithmeticLife | None = None) -> None:
        self.life = life or ArithmeticLife()
        self.forms: dict[int, ExponentForm] = {
            1: ExponentForm(1, (), (FactorNode(1, None, None),))
        }

    def form(self, n: int) -> ExponentForm:
        if n < 1:
            raise ValueError("exponent coordinates require a positive integer")
        if n in self.forms:
            return self.forms[n]
        split = self.life.factor(n)
        if split is None:
            result = ExponentForm(n, ((n, 1),), (FactorNode(n, None, None),))
        else:
            left, right = split
            left_form, right_form = self.form(left), self.form(right)
            counts = dict(left_form.powers)
            for prime, exponent in right_form.powers:
                counts[prime] = counts.get(prime, 0) + exponent
            powers = tuple(sorted(counts.items()))
            derivation = (
                FactorNode(n, left, right),
                *left_form.derivation,
                *right_form.derivation,
            )
            result = ExponentForm(n, powers, derivation)
        if result.reconstruct() != n:
            raise AssertionError("formed exponent chart failed reconstruction")
        self.forms[n] = result
        return result

    def multiply(self, left: int, right: int) -> ExponentForm:
        a, b = self.form(left), self.form(right)
        counts = dict(a.powers)
        for prime, exponent in b.powers:
            counts[prime] = counts.get(prime, 0) + exponent
        value = left * right
        result = ExponentForm(
            value,
            tuple(sorted(counts.items())),
            (FactorNode(value, left, right), *a.derivation, *b.derivation),
        )
        self.forms[value] = result
        return result

    def gcd(self, left: int, right: int) -> ExponentForm:
        a, b = dict(self.form(left).powers), dict(self.form(right).powers)
        powers = tuple(
            (prime, min(a[prime], b[prime]))
            for prime in sorted(a.keys() & b.keys())
            if min(a[prime], b[prime])
        )
        value = prod(prime ** exponent for prime, exponent in powers)
        return self.form(value)

    def lcm(self, left: int, right: int) -> ExponentForm:
        a, b = dict(self.form(left).powers), dict(self.form(right).powers)
        powers = tuple(
            (prime, max(a.get(prime, 0), b.get(prime, 0)))
            for prime in sorted(a.keys() | b.keys())
        )
        value = prod(prime ** exponent for prime, exponent in powers)
        if value not in self.forms:
            self.forms[value] = ExponentForm(
                value, powers,
                (FactorNode(value, left, right),
                 *self.form(left).derivation, *self.form(right).derivation),
            )
        return self.forms[value]

    def divisor_count(self, n: int) -> int:
        return prod(exponent + 1 for _prime, exponent in self.form(n).powers)

    def form_inverse(self, value: int, modulus: int) -> BezoutInverse:
        """Let earned multiplicative and residue memories form division.

        Both integers must already have exponent forms, and the modulus must
        already be an installed prime residue sensor. This is a causal gate,
        not a mathematical requirement of the extended Euclidean algorithm.
        """
        if value not in self.forms or modulus not in self.forms:
            raise ValueError("value and modulus need earned exponent forms")
        if modulus not in self.life.moduli:
            raise ValueError("modulus needs an earned residue sensor")
        if self.forms[modulus].powers != ((modulus, 1),):
            raise ValueError("division is installed only at a formed prime generator")
        common, coefficient, modulus_coefficient = _extended_gcd(value, modulus)
        if common != 1:
            raise ValueError("value is not invertible modulo the sensor")
        inverse = coefficient % modulus
        if value * inverse % modulus != 1:
            raise AssertionError("Bezout certificate failed to form an inverse")
        self.life._record(
            "form-operation",
            (value, modulus, coefficient, modulus_coefficient, inverse),
            "Bezout descent turns earned mod-prime observation into division; "
            "solve value*z=target by z=inverse*target",
        )
        return BezoutInverse(
            value, modulus, coefficient, modulus_coefficient, inverse
        )

    def form_composite_inverse(self, value: int, modulus: int) -> CompositeInverse:
        """Lift earned prime inverses and glue them over a formed modulus."""
        if value not in self.forms or modulus not in self.forms:
            raise ValueError("value and modulus need earned exponent forms")
        value_primes = {prime for prime, _ in self.forms[value].powers}
        modulus_powers = self.forms[modulus].powers
        shared = tuple(prime for prime, _ in modulus_powers if prime in value_primes)
        if shared:
            raise ValueError(f"nonunit obstruction: shared prime {shared[0]}")
        if not modulus_powers:
            raise ValueError("modulus must exceed one")

        local: list[tuple[int, int]] = []
        lifts: list[InverseLiftStep] = []
        for prime, target_exponent in modulus_powers:
            if prime not in self.life.moduli:
                raise ValueError(f"mod-{prime} sensor has not been earned")
            base = self.form_inverse(value, prime)
            inverse, exponent = base.inverse, 1
            while exponent < target_exponent:
                next_exponent = min(2 * exponent, target_exponent)
                prime_power = prime ** next_exponent
                inverse = (inverse * (2 - value * inverse)) % prime_power
                if value * inverse % prime_power != 1:
                    raise AssertionError("prime-power inverse lift failed")
                lifts.append(InverseLiftStep(
                    prime, exponent, next_exponent, prime_power, inverse
                ))
                exponent = next_exponent
            local.append((inverse, prime ** target_exponent))

        state = CongruenceState(0, 1)
        for residue, prime_power in local:
            update = add_constraint(state, residue, prime_power)
            if isinstance(update, Incompatibility):
                raise AssertionError("coprime prime-power inverse charts failed to glue")
            state = update.after
        if state.modulus != modulus or value * state.residue % modulus != 1:
            raise AssertionError("glued inverse certificate failed")
        self.life._record(
            "form-operation",
            (value, modulus, state.residue),
            "prime inverses lift to formed prime powers and kuttaka glues them; "
            "future unit equations use one composite inverse",
        )
        return CompositeInverse(
            value, modulus, tuple(local), tuple(lifts), state.residue
        )

    def solve_linear_congruence(
        self, coefficient: int, target: int, modulus: int
    ) -> LinearCongruenceSolution | LinearCongruenceObstruction:
        """Descend a*z=target (mod modulus) through its exact gcd obstruction."""
        if min(coefficient, target, modulus) < 1:
            raise ValueError("formed linear congruences use positive integers")
        if any(n not in self.forms for n in (coefficient, target, modulus)):
            raise ValueError("coefficient, target, and modulus need earned forms")
        overlap_form = self.gcd(coefficient, modulus)
        overlap = overlap_form.value
        target_powers = dict(self.forms[target].powers)
        if any(target_powers.get(p, 0) < e for p, e in overlap_form.powers):
            self.life._record(
                "obstruction", (coefficient, target, modulus, overlap),
                "gcd(coefficient,modulus) does not divide target",
            )
            return LinearCongruenceObstruction(
                coefficient, target, modulus, overlap
            )

        reduced_coefficient = coefficient // overlap
        reduced_target = target // overlap
        reduced_modulus = modulus // overlap
        for value in (reduced_coefficient, reduced_target, reduced_modulus):
            if value not in self.forms:
                self.form(value)
        if reduced_modulus == 1:
            residue = 0
        else:
            inverse = self.form_composite_inverse(
                reduced_coefficient, reduced_modulus
            )
            residue = inverse.solve(reduced_target)
        lifts = tuple(
            residue + step * reduced_modulus for step in range(overlap)
        )
        if any((coefficient * z - target) % modulus for z in lifts):
            raise AssertionError("linear-congruence lift certificate failed")
        self.life._record(
            "form-operation",
            (coefficient, target, modulus, overlap, residue, reduced_modulus),
            "gcd obstruction descends a nonunit equation to a unit equation; "
            "the residue class lifts through the overlap",
        )
        return LinearCongruenceSolution(
            coefficient, target, modulus, overlap,
            (reduced_coefficient, reduced_target, reduced_modulus),
            residue, reduced_modulus, lifts,
        )

    def solve_affine_system(
        self, equations: tuple[tuple[int, int, int], ...]
    ) -> AffineSystemSolution | LinearCongruenceObstruction | AffineSystemObstruction:
        """Solve equations a*z=b (mod m), then intersect their exact cosets."""
        if not equations:
            raise ValueError("an affine system needs at least one equation")
        solved: list[LinearCongruenceSolution] = []
        state = CongruenceState(0, 1)
        for equation in equations:
            result = self.solve_linear_congruence(*equation)
            if isinstance(result, LinearCongruenceObstruction):
                return result
            update = add_constraint(state, result.residue, result.solution_modulus)
            if isinstance(update, Incompatibility):
                obstruction = AffineSystemObstruction(
                    tuple(solved), result,
                    state.residue, state.modulus,
                    update.gcd, update.difference,
                )
                self.life._record(
                    "obstruction",
                    (state.residue, state.modulus, result.residue,
                     result.solution_modulus, update.gcd, update.difference),
                    "solution cosets fail the generalized-CRT alignment condition",
                )
                return obstruction
            solved.append(result)
            state = update.after
        self.life._record(
            "form-operation",
            (state.residue, state.modulus, len(solved)),
            "aligned solution cosets intersect to one reusable affine state",
        )
        return AffineSystemSolution(tuple(solved), state.residue, state.modulus)

    def project_binary_congruence(
        self, a: int, b: int, c: int, modulus: int
    ) -> BinaryProjection | LinearCongruenceObstruction:
        """Project a*x+b*y=c (mod modulus) existentially along y."""
        if min(a, b, c, modulus) < 1:
            raise ValueError("binary projection currently uses positive integers")
        for value in (a, b, c, modulus):
            if value not in self.forms:
                raise ValueError("all coefficients and the modulus need earned forms")
        image_step = self.gcd(b, modulus).value
        if image_step not in self.forms:
            self.form(image_step)
        projected = self.solve_linear_congruence(a, c, image_step)
        if isinstance(projected, LinearCongruenceObstruction):
            return projected
        result = BinaryProjection((a, b, c, modulus), image_step, projected)
        self.life._record(
            "form-operation",
            (a, b, c, modulus, image_step,
             projected.residue, projected.solution_modulus),
            "existential projection retains the image subgroup gcd(b,m)Z/mZ",
        )
        return result

    def reconstruct_binary_fiber(
        self, projection: BinaryProjection, chosen_x: int
    ) -> BinaryFiber:
        """Reconstruct all y extending one x admitted by the projection."""
        a, b, c, modulus = projection.equation
        if chosen_x % projection.projected.solution_modulus != projection.projected.residue:
            raise ValueError("chosen x is outside the projected solution coset")
        target = (c - a * chosen_x) % modulus
        if target == 0:
            # The positive-state chart represents the zero target by the modulus.
            target = modulus
        if target not in self.forms:
            self.form(target)
        reconstructed = self.solve_linear_congruence(b, target, modulus)
        if isinstance(reconstructed, LinearCongruenceObstruction):
            raise AssertionError("an admitted projected point failed reconstruction")
        if (a * chosen_x + b * reconstructed.residue - c) % modulus:
            raise AssertionError("binary reconstruction certificate failed")
        self.life._record(
            "form-operation",
            (chosen_x, reconstructed.residue, reconstructed.solution_modulus),
            "a projected point reconstructs an exact eliminated-variable fiber coset",
        )
        return BinaryFiber(projection, chosen_x, reconstructed)

    def solve_unit_determinant_system(
        self,
        matrix: tuple[tuple[int, int], tuple[int, int]],
        target: tuple[int, int],
        modulus: int,
    ) -> UnitDeterminantSystemSolution:
        """Solve a 2x2 modular system when its determinant is a formed unit."""
        (a, b), (c, d) = matrix
        if modulus < 2 or min(a, b, c, d, *target) < 1:
            raise ValueError("matrix system currently uses positive entries")
        for value in (a, b, c, d, *target, modulus):
            if value not in self.forms:
                raise ValueError("matrix entries, target, and modulus need earned forms")
        determinant = a * d - b * c
        determinant_residue = determinant % modulus
        if determinant_residue == 0:
            raise ValueError("nonunit determinant: Smith analysis required")
        if determinant_residue not in self.forms:
            self.form(determinant_residue)
        determinant_form = self.gcd(determinant_residue, modulus)
        if determinant_form.value != 1:
            raise ValueError(
                f"nonunit determinant obstruction: gcd={determinant_form.value}"
            )
        inverse = self.form_composite_inverse(determinant_residue, modulus)
        adjugate = ((d, -b), (-c, a))
        u, v = target
        solution = (
            inverse.inverse * (d * u - b * v) % modulus,
            inverse.inverse * (-c * u + a * v) % modulus,
        )
        x, y = solution
        if ((a*x + b*y - u) % modulus or (c*x + d*y - v) % modulus):
            raise AssertionError("adjugate solution certificate failed")
        self.life._record(
            "form-operation",
            (a, b, c, d, u, v, modulus, determinant, *solution),
            "unit determinant plus adjugate forms a unique two-variable solution",
        )
        return UnitDeterminantSystemSolution(
            matrix, target, modulus, determinant, inverse.inverse,
            adjugate, solution,
        )

    def solve_diagonal_smith_system(
        self, diagonal: tuple[int, int], target: tuple[int, int], modulus: int
    ) -> DiagonalSmithSolution | DiagonalSmithObstruction:
        """Solve a diagonal 2x2 modular system as image and kernel coordinates."""
        if modulus < 2 or min(*diagonal, *target) < 1:
            raise ValueError("diagonal system currently uses positive integers")
        for value in (*diagonal, *target, modulus):
            if value not in self.forms:
                raise ValueError("diagonal, target, and modulus need earned forms")
        solved: list[LinearCongruenceSolution] = []
        for coordinate, (coefficient, rhs) in enumerate(zip(diagonal, target)):
            result = self.solve_linear_congruence(coefficient, rhs, modulus)
            if isinstance(result, LinearCongruenceObstruction):
                return DiagonalSmithObstruction(
                    diagonal, target, modulus, coordinate, result
                )
            solved.append(result)
        first, second = solved
        kernel_size = first.overlap * second.overlap
        if len(first.lifts) * len(second.lifts) != kernel_size:
            raise AssertionError("Smith kernel-size certificate failed")
        self.life._record(
            "form-operation",
            (*diagonal, *target, modulus, kernel_size),
            "diagonal Smith coordinates expose image obstructions and kernel size",
        )
        return DiagonalSmithSolution(
            diagonal, target, modulus, (first, second), kernel_size
        )

    def solve_witnessed_smith_system(
        self,
        matrix: tuple[tuple[int, int], tuple[int, int]],
        target: tuple[int, int],
        modulus: int,
        left: tuple[tuple[int, int], tuple[int, int]],
        diagonal: tuple[int, int],
        right: tuple[tuple[int, int], tuple[int, int]],
    ) -> WitnessedSmithSolution | DiagonalSmithObstruction:
        """Consume an explicit integer certificate U*A*V=diag(d1,d2)."""
        if _det2(left) not in (-1, 1) or _det2(right) not in (-1, 1):
            raise ValueError("Smith transport matrices must be integer unimodular")
        diagonal_matrix = ((diagonal[0], 0), (0, diagonal[1]))
        if _matmul2(_matmul2(left, matrix), right) != diagonal_matrix:
            raise ValueError("invalid Smith certificate: U*A*V is not diagonal")
        transformed_target = _matvec2(left, target)
        normalized_target = tuple(value % modulus or modulus for value in transformed_target)
        for value in (*diagonal, *normalized_target, modulus):
            if value not in self.forms:
                self.form(value)
        solved = self.solve_diagonal_smith_system(
            diagonal, normalized_target, modulus
        )
        if isinstance(solved, DiagonalSmithObstruction):
            return solved
        w = tuple(coordinate.residue for coordinate in solved.coordinates)
        representative = tuple(value % modulus for value in _matvec2(right, w))
        generator_orders = tuple(
            coordinate.overlap for coordinate in solved.coordinates
        )
        diagonal_generators = (
            (solved.coordinates[0].solution_modulus, 0),
            (0, solved.coordinates[1].solution_modulus),
        )
        kernel_generators = tuple(
            tuple(value % modulus for value in _matvec2(right, generator))
            for generator in diagonal_generators
        )
        for generator, order in zip(kernel_generators, generator_orders):
            if tuple(value % modulus for value in _matvec2(matrix, generator)) != (0, 0):
                raise AssertionError("transported Smith generator left the kernel")
            if tuple((order * value) % modulus for value in generator) != (0, 0):
                raise AssertionError("declared Smith generator order is too small")
        if tuple(value % modulus for value in _matvec2(matrix, representative)) != tuple(
            value % modulus for value in target
        ):
            raise AssertionError("Smith reconstruction failed in original coordinates")
        self.life._record(
            "form-operation",
            (*matrix[0], *matrix[1], *target, modulus, *diagonal, *representative),
            "verified U*A*V=D, solved transformed diagonal system, reconstructed z=Vw",
        )
        return WitnessedSmithSolution(
            matrix, target, modulus, left, diagonal, right,
            transformed_target, solved, representative,
            kernel_generators, generator_orders,
        )

    def replay_smith_path(
        self,
        matrix: tuple[tuple[int, int], tuple[int, int]],
        steps: tuple[SmithStep, ...],
        expected_finish: tuple[tuple[int, int], tuple[int, int]],
    ) -> SmithPath:
        """Replay elementary unimodular steps and their inverses exactly."""
        current = matrix
        left = ((1, 0), (0, 1))
        right = ((1, 0), (0, 1))
        states = [current]
        for step in steps:
            elementary = _elementary_matrix(step)
            if step.side == "row":
                current = _matmul2(elementary, current)
                left = _matmul2(elementary, left)
            elif step.side == "column":
                current = _matmul2(current, elementary)
                right = _matmul2(right, elementary)
            else:
                raise ValueError("Smith step side must be row or column")
            states.append(current)
        if current != expected_finish:
            raise ValueError("elementary Smith path missed its declared finish")
        restored = current
        for step in reversed(steps):
            inverse = _elementary_matrix(step.inverse())
            restored = (_matmul2(inverse, restored) if step.side == "row"
                        else _matmul2(restored, inverse))
        if restored != matrix:
            raise AssertionError("inverse Smith path failed to restore its source")
        if _matmul2(_matmul2(left, matrix), right) != expected_finish:
            raise AssertionError("accumulated Smith matrices disagree with replay")
        self.life._record(
            "form-operation",
            (*matrix[0], *matrix[1], len(steps), *expected_finish[0], *expected_finish[1]),
            "elementary unimodular steps and inverse replay earn U*A*V=D",
        )
        return SmithPath(matrix, current, steps, left, right)

    def reduce_positive_column(
        self, top: int, bottom: int
    ) -> EuclideanColumnReduction:
        """Use quotient-selected unimodular row steps to form (gcd,0)."""
        if top <= 0 or bottom <= 0:
            raise ValueError("Euclidean column reduction needs positive entries")
        start = (top, bottom)
        current = start
        left = ((1, 0), (0, 1))
        steps: list[EuclideanColumnStep] = []
        while current[1] != 0:
            a, b = current
            quotient, remainder = divmod(a, b)
            operation = ((0, 1), (1, -quotient))
            after = _matvec2(operation, current)
            if after != (b, remainder) or not 0 <= remainder < b:
                raise AssertionError("Euclidean row step failed strict descent")
            if _det2(operation) not in (-1, 1):
                raise AssertionError("Euclidean row step is not unimodular")
            steps.append(EuclideanColumnStep(
                current, quotient, remainder, operation, after
            ))
            left = _matmul2(operation, left)
            current = after
        if current[0] != self.gcd(top, bottom).value:
            raise AssertionError("Euclidean column endpoint disagrees with exponent meet")
        if _matvec2(left, start) != current:
            raise AssertionError("accumulated Euclidean witness failed")
        restored = current
        for step in reversed(steps):
            inverse = ((step.quotient, 1), (1, 0))
            restored = _matvec2(inverse, restored)
        if restored != start:
            raise AssertionError("inverse Euclidean path failed")
        self.life._record(
            "form-operation", (*start, current[0], len(steps)),
            "division remainders choose a strictly descending unimodular row path",
        )
        return EuclideanColumnReduction(start, current, tuple(steps), left)


def _det2(matrix: tuple[tuple[int, int], tuple[int, int]]) -> int:
    return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]


def _matmul2(left, right):
    return tuple(tuple(sum(left[i][k] * right[k][j] for k in range(2))
                       for j in range(2)) for i in range(2))


def _matvec2(matrix, vector):
    return tuple(sum(matrix[i][j] * vector[j] for j in range(2)) for i in range(2))


def _elementary_matrix(step: SmithStep):
    if step.target not in (0, 1):
        raise ValueError("Smith step target must be 0 or 1")
    if step.kind == "negate":
        entries = [[1, 0], [0, 1]]
        entries[step.target][step.target] = -1
        return tuple(tuple(row) for row in entries)
    if step.kind == "add":
        if step.source not in (0, 1) or step.source == step.target:
            raise ValueError("Smith shear needs distinct source and target")
        entries = [[1, 0], [0, 1]]
        # Left multiplication adds source row to target; right multiplication
        # adds source column to target, so the off-diagonal indices transpose.
        if step.side == "row":
            entries[step.target][step.source] = step.multiple
        elif step.side == "column":
            entries[step.source][step.target] = step.multiple
        else:
            raise ValueError("Smith step side must be row or column")
        return tuple(tuple(row) for row in entries)
    raise ValueError("Smith step kind must be add or negate")


def _extended_gcd(a: int, b: int) -> tuple[int, int, int]:
    """Return positive gcd g and coefficients x,y with ax+by=g."""
    old_r, r = a, b
    old_s, s = 1, 0
    old_t, t = 0, 1
    while r:
        quotient = old_r // r
        old_r, r = r, old_r - quotient * r
        old_s, s = s, old_s - quotient * s
        old_t, t = t, old_t - quotient * t
    if old_r < 0:
        return -old_r, -old_s, -old_t
    return old_r, old_s, old_t


def main() -> None:
    world = ExponentWorld()
    for n in (72, 90):
        form = world.form(n)
        print(f"{n} -> {form.powers}; reconstruction={form.reconstruct()}")
    print(f"gcd -> {world.gcd(72, 90).powers}")
    print(f"lcm -> {world.lcm(72, 90).powers}")
    print(f"divisors(72) -> {world.divisor_count(72)}")
    print(f"formed worlds cached -> {tuple(sorted(world.forms))}")


if __name__ == "__main__":
    main()
