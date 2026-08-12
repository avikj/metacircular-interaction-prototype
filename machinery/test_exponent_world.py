#!/usr/bin/env python3

import unittest

from exponent_world import (
    AffineSystemObstruction,
    AffineSystemSolution,
    BinaryProjection,
    DiagonalSmithObstruction,
    DiagonalSmithSolution,
    ExponentWorld,
    LinearCongruenceObstruction,
    LinearCongruenceSolution,
    UnitDeterminantSystemSolution,
    WitnessedSmithSolution,
    SmithStep,
    EuclideanColumnReduction,
    PivotDiagonalization,
    PivotDivisibilityResidual,
    PivotResidualColumnAdvance,
    ResidualCycleClosure,
    ResidualCycleObstruction,
    LowerResidualRowAdvance,
    SignedActiveNormalization,
    ZeroPivotClassification,
    RankOneDiagonalNormalization,
)


class ExponentWorldTests(unittest.TestCase):
    def test_recursive_origins_form_exponent_coordinates(self):
        world = ExponentWorld()
        form = world.form(72)
        self.assertEqual(form.powers, ((2, 3), (3, 2)))
        self.assertEqual(form.reconstruct(), 72)

    def test_multiplication_becomes_coordinate_addition(self):
        world = ExponentWorld()
        self.assertEqual(
            world.multiply(12, 18).powers,
            ((2, 3), (3, 3)),
        )

    def test_gcd_lcm_become_min_max(self):
        world = ExponentWorld()
        self.assertEqual(world.gcd(72, 90).powers, ((2, 1), (3, 2)))
        self.assertEqual(world.lcm(72, 90).powers, ((2, 3), (3, 2), (5, 1)))

    def test_divisor_count_compiles_from_independent_choices(self):
        world = ExponentWorld()
        self.assertEqual(world.divisor_count(72), 12)

    def test_formed_world_is_reused(self):
        world = ExponentWorld()
        first = world.form(72)
        event_count = len(world.life.events)
        second = world.form(72)
        self.assertIs(first, second)
        self.assertEqual(len(world.life.events), event_count)

    def test_earned_prime_sensor_and_origins_form_inverse(self):
        world = ExponentWorld()
        world.life.factor(91)  # earns and certifies residue sensors through 7
        world.form(3)
        world.form(7)
        formed = world.form_inverse(3, 7)
        self.assertEqual(3 * formed.coefficient + 7 * formed.modulus_coefficient, 1)
        self.assertEqual(formed.inverse, 5)
        self.assertEqual(formed.solve(1), 5)
        self.assertEqual(formed.solve(4), 6)
        self.assertEqual(world.life.events[-1].kind, "form-operation")

    def test_inverse_fails_without_earned_memories(self):
        world = ExponentWorld()
        world.form(3)
        world.form(7)
        with self.assertRaises(ValueError):
            world.form_inverse(3, 7)  # no installed mod-7 sensor
        world.life.factor(91)
        with self.assertRaises(ValueError):
            world.form_inverse(2, 7)  # 2 has no cached exponent form

    def test_composite_sensor_does_not_form_field_division(self):
        world = ExponentWorld()
        world.life.install_residue_sensor(6, (6,))
        world.form(5)
        world.form(6)
        with self.assertRaises(ValueError):
            world.form_inverse(5, 6)

    def test_prime_power_lifts_glue_to_composite_inverse(self):
        world = ExponentWorld()
        world.life.factor(91)  # earns prime sensors 2, 3, 5, 7
        world.form(5)
        world.form(72)
        formed = world.form_composite_inverse(5, 72)
        self.assertEqual(formed.local_inverses, ((5, 8), (2, 9)))
        self.assertEqual(formed.inverse, 29)
        self.assertEqual(formed.solve(17), 61)
        self.assertEqual(5 * formed.inverse % 72, 1)
        self.assertEqual(
            tuple((s.prime, s.from_exponent, s.to_exponent) for s in formed.lift_steps),
            ((2, 1, 2), (2, 2, 3), (3, 1, 2)),
        )

    def test_composite_inverse_fails_for_nonunit(self):
        world = ExponentWorld()
        world.life.factor(91)
        world.form(6)
        world.form(72)
        with self.assertRaisesRegex(ValueError, "shared prime 2"):
            world.form_composite_inverse(6, 72)

    def test_composite_inverse_requires_earned_prime_sensors(self):
        world = ExponentWorld()
        world.form(5)
        world.form(77)  # factoring earns mod 7, but the prime cofactor 11 is only formed
        with self.assertRaisesRegex(ValueError, "sensor has not been earned"):
            world.form_composite_inverse(5, 77)

    def test_nonunit_congruence_descends_to_unit_equation(self):
        world = ExponentWorld()
        for value in (12, 18, 30):
            world.form(value)
        result = world.solve_linear_congruence(12, 18, 30)
        self.assertIsInstance(result, LinearCongruenceSolution)
        self.assertEqual(result.overlap, 6)
        self.assertEqual(result.reduced_equation, (2, 3, 5))
        self.assertEqual((result.residue, result.solution_modulus), (4, 5))
        self.assertEqual(result.lifts, (4, 9, 14, 19, 24, 29))

    def test_incompatible_congruence_emits_overlap_obstruction(self):
        world = ExponentWorld()
        for value in (5, 12, 30):
            world.form(value)
        result = world.solve_linear_congruence(12, 5, 30)
        self.assertEqual(result, LinearCongruenceObstruction(12, 5, 30, 6))

    def test_zero_reduced_modulus_means_every_residue_solves(self):
        world = ExponentWorld()
        for value in (10, 20, 30):
            world.form(value)
        result = world.solve_linear_congruence(30, 20, 10)
        self.assertIsInstance(result, LinearCongruenceSolution)
        self.assertEqual(result.reduced_equation, (3, 2, 1))
        self.assertEqual(result.lifts, tuple(range(10)))

    def test_nonunit_equations_intersect_as_solution_cosets(self):
        world = ExponentWorld()
        world.life.factor(91)  # earns prime residue sensors through 7
        for value in (12, 18, 30, 42):
            world.form(value)
        result = world.solve_affine_system(((12, 18, 30), (18, 12, 42)))
        self.assertIsInstance(result, AffineSystemSolution)
        self.assertEqual((result.residue, result.modulus), (24, 35))
        self.assertEqual(
            tuple((s.residue, s.solution_modulus) for s in result.equations),
            ((4, 5), (3, 7)),
        )
        self.assertEqual(12 * result.residue % 30, 18)
        self.assertEqual(18 * result.residue % 42, 12)

    def test_incompatible_solution_cosets_retain_alignment_defect(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (1, 3, 4, 6, 8):
            world.form(value)
        result = world.solve_affine_system(((1, 4, 6), (1, 3, 8)))
        self.assertIsInstance(result, AffineSystemObstruction)
        self.assertEqual((result.state_residue, result.state_modulus), (4, 6))
        self.assertEqual((result.rejected.residue, result.rejected.solution_modulus), (3, 8))
        self.assertEqual((result.gcd, result.difference), (2, -1))

    def test_modulus_one_equation_is_neutral_in_system(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (2, 4, 5, 10):
            world.form(value)
        result = world.solve_affine_system(((10, 4, 2), (1, 4, 5)))
        self.assertIsInstance(result, AffineSystemSolution)
        self.assertEqual((result.residue, result.modulus), (4, 5))

    def test_binary_projection_retains_eliminated_image_subgroup(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (6, 10, 14, 30):
            world.form(value)
        projected = world.project_binary_congruence(6, 10, 14, 30)
        self.assertIsInstance(projected, BinaryProjection)
        self.assertEqual(projected.eliminated_image_step, 10)
        self.assertEqual(
            (projected.projected.residue, projected.projected.solution_modulus),
            (4, 5),
        )
        fiber = world.reconstruct_binary_fiber(projected, 4)
        self.assertEqual(
            (fiber.reconstructed.residue, fiber.reconstructed.solution_modulus),
            (2, 3),
        )
        self.assertEqual((6 * 4 + 10 * 2 - 14) % 30, 0)

    def test_naive_term_deletion_is_a_false_projection(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (6, 10, 14, 30):
            world.form(value)
        naive = world.solve_linear_congruence(6, 14, 30)
        self.assertIsInstance(naive, LinearCongruenceObstruction)
        exact = world.project_binary_congruence(6, 10, 14, 30)
        self.assertIsInstance(exact, BinaryProjection)

    def test_reconstruction_rejects_x_outside_projection(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (6, 10, 14, 30):
            world.form(value)
        projected = world.project_binary_congruence(6, 10, 14, 30)
        self.assertIsInstance(projected, BinaryProjection)
        with self.assertRaisesRegex(ValueError, "outside the projected"):
            world.reconstruct_binary_fiber(projected, 3)

    def test_unit_determinant_system_forms_unique_pair(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (4, 5, 6, 9, 14, 30):
            world.form(value)
        result = world.solve_unit_determinant_system(
            ((6, 5), (5, 4)), (14, 9), 30
        )
        self.assertIsInstance(result, UnitDeterminantSystemSolution)
        self.assertEqual(result.determinant, -1)
        self.assertEqual(result.determinant_inverse, 29)
        self.assertEqual(result.solution, (19, 16))

    def test_nonunit_determinant_is_fenced_for_smith_analysis(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (2, 4, 6, 8, 10, 30):
            world.form(value)
        with self.assertRaisesRegex(ValueError, "nonunit determinant obstruction: gcd=2"):
            world.solve_unit_determinant_system(
                ((2, 4), (6, 8)), (10, 10), 30
            )

    def test_diagonal_smith_system_forms_product_solution_module(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (6, 10, 18, 20, 30):
            world.form(value)
        result = world.solve_diagonal_smith_system((6, 10), (18, 20), 30)
        self.assertIsInstance(result, DiagonalSmithSolution)
        self.assertEqual(
            tuple((c.residue, c.solution_modulus) for c in result.coordinates),
            ((3, 5), (2, 3)),
        )
        self.assertEqual(result.kernel_size, 60)
        self.assertEqual(
            len(result.coordinates[0].lifts) * len(result.coordinates[1].lifts),
            60,
        )

    def test_diagonal_smith_obstruction_is_coordinate_local(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (6, 10, 14, 18, 30):
            world.form(value)
        result = world.solve_diagonal_smith_system((6, 10), (18, 14), 30)
        self.assertEqual(
            result,
            DiagonalSmithObstruction(
                (6, 10), (18, 14), 30, 1,
                LinearCongruenceObstruction(10, 14, 30, 10),
            ),
        )

    def test_explicit_smith_witness_transports_target_and_solution(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (2, 4, 6, 8, 10, 14, 18, 30):
            world.form(value)
        # U*A*V = diag(2,4) for A=[[2,4],[6,8]].
        result = world.solve_witnessed_smith_system(
            ((2, 4), (6, 8)), (14, 18), 30,
            ((1, 0), (3, -1)), (2, 4), ((1, -2), (0, 1)),
        )
        self.assertIsInstance(result, WitnessedSmithSolution)
        self.assertEqual(result.transformed_target, (14, 24))
        self.assertEqual(result.representative, (25, 6))
        self.assertEqual(result.diagonal_solution.kernel_size, 4)
        self.assertEqual(result.kernel_generators, ((15, 0), (0, 15)))
        self.assertEqual(result.generator_orders, (2, 2))
        self.assertEqual(
            result.generator_orders[0] * result.generator_orders[1],
            result.diagonal_solution.kernel_size,
        )
        self.assertEqual((2*25 + 4*6) % 30, 14)
        self.assertEqual((6*25 + 8*6) % 30, 18)

    def test_invalid_smith_witness_fails_before_solving(self):
        world = ExponentWorld()
        with self.assertRaisesRegex(ValueError, "not diagonal"):
            world.solve_witnessed_smith_system(
                ((2, 4), (6, 8)), (14, 18), 30,
                ((1, 0), (-2, 1)), (2, 4), ((1, -2), (0, 1)),
            )

    def test_transported_kernel_generators_preserve_every_solution(self):
        world = ExponentWorld()
        world.life.factor(91)
        for value in (2, 4, 6, 8, 14, 18, 30):
            world.form(value)
        result = world.solve_witnessed_smith_system(
            ((2, 4), (6, 8)), (14, 18), 30,
            ((1, 0), (3, -1)), (2, 4), ((1, -2), (0, 1)),
        )
        for generator in result.kernel_generators:
            self.assertEqual(
                tuple(value % 30 for value in _matvec_for_test(result.matrix, generator)),
                (0, 0),
            )


def _matvec_for_test(matrix, vector):
    return tuple(sum(matrix[i][j] * vector[j] for j in range(2)) for i in range(2))


class SmithPathTests(unittest.TestCase):
    def test_elementary_steps_earn_existing_smith_certificate(self):
        world = ExponentWorld()
        steps = (
            SmithStep("row", "negate", 1),
            SmithStep("row", "add", 1, 0, 3),
            SmithStep("column", "add", 1, 0, -2),
        )
        path = world.replay_smith_path(
            ((2, 4), (6, 8)), steps, ((2, 0), (0, 4))
        )
        self.assertEqual(path.left, ((1, 0), (3, -1)))
        self.assertEqual(path.right, ((1, -2), (0, 1)))
        self.assertEqual(path.finish, ((2, 0), (0, 4)))

    def test_corrupted_path_fails_before_certificate(self):
        world = ExponentWorld()
        bad = (
            SmithStep("row", "negate", 1),
            SmithStep("row", "add", 1, 0, 2),
            SmithStep("column", "add", 1, 0, -2),
        )
        with self.assertRaisesRegex(ValueError, "missed its declared finish"):
            world.replay_smith_path(
                ((2, 4), (6, 8)), bad, ((2, 0), (0, 4))
            )

    def test_euclidean_remainders_choose_descending_row_path(self):
        world = ExponentWorld()
        world.form(84)
        world.form(30)
        reduction = world.reduce_positive_column(84, 30)
        self.assertIsInstance(reduction, EuclideanColumnReduction)
        self.assertEqual(reduction.finish, (6, 0))
        self.assertEqual(
            tuple((s.before, s.quotient, s.after) for s in reduction.steps),
            (((84, 30), 2, (30, 24)),
             ((30, 24), 1, (24, 6)),
             ((24, 6), 4, (6, 0))),
        )
        self.assertEqual(_matvec_for_test(reduction.left, (84, 30)), (6, 0))

    def test_wrong_quotient_is_invertible_but_not_euclidean(self):
        a, b, wrong_q = 84, 30, 1
        operation = ((0, 1), (1, -wrong_q))
        self.assertEqual(abs(operation[0][0]*operation[1][1]
                             - operation[0][1]*operation[1][0]), 1)
        after = _matvec_for_test(operation, (a, b))
        self.assertEqual(after, (30, 54))
        self.assertFalse(0 <= after[1] < b)

    def test_pivot_divisibility_completes_diagonalization(self):
        world = ExponentWorld()
        for value in (84, 30):
            world.form(value)
        result = world.complete_diagonal_if_pivot_divides(((84, 42), (30, 18)))
        self.assertIsInstance(result, PivotDiagonalization)
        self.assertEqual(result.diagonal, (6, 42))
        self.assertEqual(result.quotient, 2)
        self.assertEqual(
            _matmul_for_test(_matmul_for_test(result.left, result.matrix), result.right),
            ((6, 0), (0, 42)),
        )

    def test_nondivisible_upper_entry_emits_residual(self):
        world = ExponentWorld()
        for value in (84, 30):
            world.form(value)
        result = world.complete_diagonal_if_pivot_divides(((84, 14), (30, 10)))
        self.assertIsInstance(result, PivotDivisibilityResidual)
        self.assertEqual(result.triangular, ((6, 16), (0, -70)))
        self.assertEqual((result.pivot, result.upper_right, result.residual), (6, 16, 4))

    def test_pivot_residual_transposes_euclidean_path_and_strictly_descends(self):
        world = ExponentWorld()
        for value in (84, 30):
            world.form(value)
        obstruction = world.complete_diagonal_if_pivot_divides(
            ((84, 14), (30, 10))
        )
        self.assertIsInstance(obstruction, PivotDivisibilityResidual)
        advance = world.advance_positive_pivot_residual(obstruction)
        self.assertIsInstance(advance, PivotResidualColumnAdvance)
        self.assertEqual((advance.old_pivot, advance.new_pivot), (6, 2))
        self.assertEqual(advance.right, ((3, -8), (-1, 3)))
        self.assertEqual(advance.advanced, ((2, 0), (70, -210)))
        self.assertEqual(
            _matmul_for_test(
                _matmul_for_test(advance.left, advance.matrix), advance.right
            ),
            advance.advanced,
        )

    def test_divisible_branch_cannot_masquerade_as_residual_advance(self):
        world = ExponentWorld()
        false_obstruction = PivotDivisibilityResidual(
            ((6, 12), (0, 42)), ((6, 12), (0, 42)),
            ((1, 0), (0, 1)), 6, 12, 0,
        )
        with self.assertRaisesRegex(ValueError, "failed pivot divisibility"):
            world.advance_positive_pivot_residual(false_obstruction)

    def test_residual_cycle_closes_when_new_pivot_divides_lower_left(self):
        world = ExponentWorld()
        for value in (84, 30):
            world.form(value)
        obstruction = world.complete_diagonal_if_pivot_divides(
            ((84, 14), (30, 10))
        )
        advance = world.advance_positive_pivot_residual(obstruction)
        closure = world.close_residual_cycle_if_pivot_divides(advance)
        self.assertIsInstance(closure, ResidualCycleClosure)
        self.assertEqual((closure.quotient, closure.diagonal), (35, (2, 210)))
        self.assertEqual(
            _matmul_for_test(
                _matmul_for_test(closure.left, closure.matrix), closure.right
            ),
            ((2, 0), (0, 210)),
        )
        self.assertEqual(abs(_det_for_test(closure.matrix)), 2 * 210)

    def test_nondivisible_lower_left_remains_a_cycle_obstruction(self):
        world = ExponentWorld()
        advance = PivotResidualColumnAdvance(
            ((2, 0), (5, 7)), ((2, 0), (5, 7)), ((2, 0), (5, 7)),
            ((1, 0), (0, 1)), ((1, 0), (0, 1)), 4, 2,
            EuclideanColumnReduction((4, 2), (2, 0), (), ((1, 0), (0, 1))),
        )
        result = world.close_residual_cycle_if_pivot_divides(advance)
        self.assertEqual(result, ResidualCycleObstruction(((2, 0), (5, 7)), 2, 5, 1))

    def test_lower_residual_executes_as_oriented_strict_row_descent(self):
        world = ExponentWorld()
        obstruction = ResidualCycleObstruction(((2, 0), (5, 7)), 2, 5, 1)
        result = world.advance_positive_lower_residual(obstruction)
        self.assertIsInstance(result, LowerResidualRowAdvance)
        self.assertEqual((result.old_pivot, result.new_pivot), (2, 1))
        self.assertEqual(result.left, ((-2, 1), (5, -2)))
        self.assertEqual(result.advanced, ((1, 7), (0, -14)))
        self.assertEqual(_matmul_for_test(result.left, result.matrix), result.advanced)

    def test_divisible_lower_entry_cannot_enter_residual_row_descent(self):
        world = ExponentWorld()
        false_obstruction = ResidualCycleObstruction(((2, 0), (6, 7)), 2, 6, 0)
        with self.assertRaisesRegex(ValueError, "failed row divisibility"):
            world.advance_positive_lower_residual(false_obstruction)

    def test_signed_upper_active_pair_normalizes_in_all_four_sign_cells(self):
        world = ExponentWorld()
        for pivot_sign in (-1, 1):
            for companion_sign in (-1, 1):
                matrix = ((pivot_sign * 6, companion_sign * 16), (0, -70))
                result = world.normalize_signed_active_pair(matrix, "upper")
                self.assertIsInstance(result, SignedActiveNormalization)
                self.assertEqual(result.normalized[0], (6, 16))
                self.assertEqual(result.normalized[1][0], 0)
                self.assertEqual(result.pivot_magnitude, 6)
                self.assertEqual(
                    _matmul_for_test(
                        _matmul_for_test(result.left, matrix), result.right
                    ), result.normalized
                )

    def test_signed_lower_active_pair_normalizes_in_all_four_sign_cells(self):
        world = ExponentWorld()
        for pivot_sign in (-1, 1):
            for companion_sign in (-1, 1):
                matrix = ((pivot_sign * 2, 0), (companion_sign * 5, 7))
                result = world.normalize_signed_active_pair(matrix, "lower")
                self.assertEqual(
                    (result.normalized[0][0], result.normalized[1][0]), (2, 5)
                )
                self.assertEqual(result.normalized[0][1], 0)
                self.assertEqual(result.pivot_magnitude, 2)

    def test_zero_active_entry_is_endpoint_not_signed_normalization(self):
        world = ExponentWorld()
        with self.assertRaisesRegex(ValueError, "cannot make a zero"):
            world.normalize_signed_active_pair(((2, 0), (0, 7)), "upper")

    def test_zero_pivot_row_swap_has_canonical_priority(self):
        world = ExponentWorld()
        result = world.classify_zero_pivot(((0, 6), (-4, 9)))
        self.assertIsInstance(result, ZeroPivotClassification)
        self.assertEqual((result.kind, result.relocated_pivot), ("row-swap", 4))
        self.assertEqual(result.transformed, ((-4, 9), (0, 6)))
        self.assertEqual(result.left, ((0, 1), (1, 0)))
        self.assertEqual(abs(_det_for_test(result.transformed)), 24)

    def test_zero_pivot_uses_column_swap_when_first_column_is_zero(self):
        world = ExponentWorld()
        result = world.classify_zero_pivot(((0, -6), (0, 9)))
        self.assertEqual((result.kind, result.relocated_pivot), ("column-swap", 6))
        self.assertEqual(result.transformed, ((-6, 0), (9, 0)))
        self.assertEqual(result.right, ((0, 1), (1, 0)))

    def test_zero_pivot_distinguishes_diagonal_and_zero_endpoints(self):
        world = ExponentWorld()
        diagonal = world.classify_zero_pivot(((0, 0), (0, -7)))
        zero = world.classify_zero_pivot(((0, 0), (0, 0)))
        self.assertEqual((diagonal.kind, diagonal.relocated_pivot),
                         ("already-diagonal", None))
        self.assertEqual((zero.kind, zero.relocated_pivot), ("zero-matrix", None))

    def test_nonzero_pivot_cannot_enter_zero_classifier(self):
        with self.assertRaisesRegex(ValueError, "zero leading"):
            ExponentWorld().classify_zero_pivot(((2, 0), (0, 7)))

    def test_rank_one_trailing_entry_moves_to_positive_leading_position(self):
        world = ExponentWorld()
        result = world.normalize_rank_one_diagonal(((0, 0), (0, -7)))
        self.assertIsInstance(result, RankOneDiagonalNormalization)
        self.assertEqual(result.diagonal, (7, 0))
        self.assertEqual(
            _matmul_for_test(
                _matmul_for_test(result.left, result.matrix), result.right
            ), ((7, 0), (0, 0))
        )
        self.assertEqual(abs(_det_for_test(result.left)), 1)
        self.assertEqual(abs(_det_for_test(result.right)), 1)

    def test_rank_one_leading_entry_only_needs_sign_normalization(self):
        result = ExponentWorld().normalize_rank_one_diagonal(((-5, 0), (0, 0)))
        self.assertEqual(result.diagonal, (5, 0))
        self.assertEqual(result.right, ((1, 0), (0, 1)))

    def test_zero_and_full_rank_diagonals_are_not_rank_one(self):
        world = ExponentWorld()
        for matrix in (((0, 0), (0, 0)), ((2, 0), (0, 7))):
            with self.assertRaisesRegex(ValueError, "exactly one"):
                world.normalize_rank_one_diagonal(matrix)


def _matmul_for_test(left, right):
    return tuple(tuple(sum(left[i][k] * right[k][j] for k in range(2))
                       for j in range(2)) for i in range(2))


def _det_for_test(matrix):
    return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]


if __name__ == "__main__":
    unittest.main()
