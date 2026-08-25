import unittest
from fractions import Fraction

from trace_corpus_growth_density import (
    IDENT,
    alphabet,
    bezout_recordable_fraction,
    bfs_spheres,
    count_lower_unipotent,
    count_upper_unipotent,
    det2,
    gen_a,
    gen_b,
    growth_series_coeffs,
    in_gamma0,
    in_gamma_principal,
    inv_sl2,
    is_upper_unipotent,
    mat_mul,
    min_fixed_record_length,
    pigeonhole_conflates,
    sphere_size_free,
    strings_up_to,
)


class GeneratorMembershipTest(unittest.TestCase):
    def test_generators_are_sl2(self):
        for k in range(2, 13):
            for g in alphabet(k):
                self.assertEqual(det2(g), 1)
                self.assertEqual(mat_mul(g, inv_sl2(g)), IDENT)

    def test_generators_in_gamma0_k(self):
        # A_k upper triangular: in Gamma_0(m) for every m; B_k has
        # lower-left k: in Gamma_0(k).  So <A_k, B_k> <= Gamma_0(k).
        for k in range(2, 13):
            for m in range(2, 13):
                self.assertTrue(in_gamma0(gen_a(k), m))
            self.assertTrue(in_gamma0(gen_b(k), k))

    def test_sanov_generators_in_gamma0_2_and_gamma_2(self):
        for g in (gen_a(2), gen_b(2)):
            self.assertTrue(in_gamma0(g, 2))
            self.assertTrue(in_gamma_principal(g, 2))


class SphereGrowthTest(unittest.TestCase):
    def test_sanov_spheres_match_free_growth_up_to_8(self):
        # BFS on actual matrices: |S_n| = 4*3^(n-1) for n <= 8 certifies
        # both the counting theorem and freeness (no collision among
        # reduced words of length <= 8, hence no relation of length <= 16).
        spheres = bfs_spheres(2, 8)
        self.assertEqual(
            [len(s) for s in spheres],
            [sphere_size_free(n) for n in range(9)],
        )

    def test_k_3_and_5_spheres_match_free_growth_up_to_6(self):
        for k in (3, 5):
            spheres = bfs_spheres(k, 6)
            self.assertEqual(
                [len(s) for s in spheres],
                [sphere_size_free(n) for n in range(7)],
            )

    def test_spheres_lie_in_gamma0_k_and_gamma_k(self):
        for k in (2, 3, 5):
            for sphere in bfs_spheres(k, 4):
                for g in sphere:
                    self.assertTrue(in_gamma0(g, k))
                    self.assertTrue(in_gamma_principal(g, k))

    def test_k_1_is_not_free_negative_control(self):
        # A_1, B_1 generate SL_2(Z), which is NOT free: the sphere count
        # falls below 4*3^(n-1) already at n = 3 (30 < 36).  This shows
        # the k >= 2 hypothesis of the ping-pong theorem is load-bearing.
        spheres = bfs_spheres(1, 3)
        self.assertEqual(len(spheres[3]), 30)
        self.assertLess(len(spheres[3]), sphere_size_free(3))

    def test_growth_series_coefficients(self):
        # (1+x)/(1-3x) = 1 + 4x + 12x^2 + 36x^3 + ...
        coeffs = growth_series_coeffs(8)
        self.assertEqual(coeffs, [sphere_size_free(n) for n in range(9)])
        # sanity: the coefficients satisfy the recurrence of 1/(1-3x)
        # shifted by (1+x): c_n = 3*c_{n-1} for n >= 2, c_1 = 4.
        for n in range(2, 9):
            self.assertEqual(coeffs[n], 3 * coeffs[n - 1])


class UnipotentCountTest(unittest.TestCase):
    def test_exactly_two_upper_unipotents_per_sphere(self):
        # F_k intersect {[[1,t],[0,1]]} = <A_k>; at word length n >= 1
        # exactly A_k^n and A_k^(-n): two elements, no more.
        for k in (2, 3, 5):
            spheres = bfs_spheres(k, 6)
            a = gen_a(k)
            for n in range(1, 7):
                self.assertEqual(count_upper_unipotent(spheres[n]), 2)
                # and they are precisely the two n-th powers of A_k
                power = IDENT
                for _ in range(n):
                    power = mat_mul(power, a)
                self.assertIn(power, spheres[n])
                self.assertIn(inv_sl2(power), spheres[n])
                self.assertTrue(is_upper_unipotent(power))

    def test_exactly_two_lower_unipotents_per_sphere(self):
        for k in (2, 3, 5):
            spheres = bfs_spheres(k, 6)
            for n in range(1, 7):
                self.assertEqual(count_lower_unipotent(spheres[n]), 2)

    def test_bezout_recordable_fraction_exact(self):
        for n in range(1, 12):
            frac = bezout_recordable_fraction(n)
            self.assertEqual(frac, Fraction(2, 4 * 3 ** (n - 1)))
            self.assertEqual(frac, Fraction(1, 2 * 3 ** (n - 1)))
        self.assertEqual(bezout_recordable_fraction(1), Fraction(1, 2))
        self.assertEqual(bezout_recordable_fraction(5), Fraction(1, 162))


class PigeonholeTest(unittest.TestCase):
    def test_strings_up_to_exact(self):
        self.assertEqual(strings_up_to(2, 0), 1)
        self.assertEqual(strings_up_to(2, 3), 15)  # 1+2+4+8
        self.assertEqual(strings_up_to(10, 2), 111)  # 1+10+100

    def test_binary_records_conflate_exactly_when_counting_says_so(self):
        # 4*3^(n-1) > 2^(L+1) - 1 forces conflation of two distinct
        # length-n payloads by pigeonhole; otherwise no conflation is
        # forced by counting alone.
        for n in range(1, 15):
            for length in range(0, 25):
                self.assertEqual(
                    pigeonhole_conflates(n, 2, length),
                    4 * 3 ** (n - 1) > 2 ** (length + 1) - 1,
                )

    def test_specific_instances(self):
        # n = 8: 8748 payloads; binary records of length <= 12 give only
        # 2^13 - 1 = 8191 < 8748 strings: conflation forced.  Length 13
        # gives 16383 >= 8748: not forced.
        self.assertEqual(sphere_size_free(8), 8748)
        self.assertTrue(pigeonhole_conflates(8, 2, 12))
        self.assertFalse(pigeonhole_conflates(8, 2, 13))
        # decimal records: length <= 3 (1111 strings) conflates at n = 8.
        self.assertTrue(pigeonhole_conflates(8, 10, 3))
        self.assertFalse(pigeonhole_conflates(8, 10, 4))

    def test_min_fixed_record_length_tracks_log2_3_rate(self):
        # b = 2: L(n) = ceil(log2(4*3^(n-1))) grows like n*log2(3);
        # exact check of the defining inequalities, plus the derived
        # bounds (n-1)*log2(3) + 2 <= L(n) < (n-1)*log2(3) + 3 in the
        # integer form 3^(n-1) * 4 <= 2^L < 8 * 3^(n-1) ... kept exact:
        for n in range(1, 20):
            length = min_fixed_record_length(n, 2)
            self.assertGreaterEqual(2 ** length, 4 * 3 ** (n - 1))
            self.assertLess(2 ** (length - 1), 4 * 3 ** (n - 1))
        # rate check without floats: over 60 letters the record length
        # exceeds 1.58*n bits and stays below 1.59*n + 3 bits, bracketing
        # log2(3) = 1.5849...; stated as exact integer inequalities.
        length60 = min_fixed_record_length(61, 2)  # 60 letters past n=1
        self.assertGreaterEqual(100 * length60, 158 * 60)
        self.assertLessEqual(100 * length60, 159 * 60 + 300)

    def test_bezout_only_recording_conflates_all_but_powers_of_a(self):
        # A Bezout-only format records one integer, injectively on the
        # upper-unipotent subgroup and constant off it (R0033/R0041): on
        # the length-n sphere it discriminates the 2 powers of A_k and
        # conflates the remaining 4*3^(n-1) - 2 elements into one class.
        spheres = bfs_spheres(2, 5)
        for n in range(1, 6):
            classes = {}
            for g in spheres[n]:
                key = ("bezout", g[0][1]) if is_upper_unipotent(g) else "bot"
                classes.setdefault(key, []).append(g)
            bot = classes.pop("bot")
            self.assertEqual(len(classes), 2)  # A^n and A^-n, separated
            self.assertEqual(len(bot), sphere_size_free(n) - 2)


if __name__ == "__main__":
    unittest.main()
