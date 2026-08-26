// Exact discovery enumerator for possible irreducible nonic factors of the
// prime-prefix polynomials.  This is not yet a theorem certificate.
//
// A shard fixes (a,j) in
//
//   x^9+a*x^8+b*x^7+c*x^6+d*x^5+e*x^4+f*x^3+h*x^2+j*x+1.
//
// It applies only the proved coefficient box, the first-Graeffe coefficient
// inequalities, the proved window 309/500 < t < 79/125 for the modulus t of
// the unique negative root, and Res(E,O)=+-1.  Counts are printed to stderr;
// unit-resultant candidates are printed to stdout.

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <limits>

#include "exp37_nonic_bounds.hpp"

using i64 = std::int64_t;
using u64 = std::uint64_t;
using i128 = __int128_t;

static i64 floor_div(i128 x, i128 y) {
    if (y <= 0) std::abort();
    if (x >= 0) return static_cast<i64>(x / y);
    return static_cast<i64>(-((-x + y - 1) / y));
}

static i64 ceil_div(i128 x, i128 y) { return -floor_div(-x, y); }

static void intersect_linear(i64 A, i128 B, i64 K, i64 &lower, i64 &upper) {
    // Intersect the integer interval with |A*x+B| <= K.
    if (A == 0) {
        if (B < -K || B > K) {
            lower = 1;
            upper = 0;
        }
        return;
    }
    if (A < 0) {
        A = -A;
        B = -B;
    }
    lower = std::max(lower, ceil_div(-static_cast<i128>(K) - B, A));
    upper = std::min(upper, floor_div(static_cast<i128>(K) - B, A));
}

static i128 ipow(i128 x, int exponent) {
    i128 answer = 1;
    for (int i = 0; i < exponent; ++i) answer *= x;
    return answer;
}

static i128 negative_value_base(
    int a, int b, int c, int d, int f, int h, int j, i64 m, i64 n) {
    // n^9*g(-m/n), with the e*m^4*n^5 term omitted.
    const i128 M = m;
    const i128 N = n;
    return ipow(N, 9)
        - static_cast<i128>(j) * M * ipow(N, 8)
        + static_cast<i128>(h) * ipow(M, 2) * ipow(N, 7)
        - static_cast<i128>(f) * ipow(M, 3) * ipow(N, 6)
        - static_cast<i128>(d) * ipow(M, 5) * ipow(N, 4)
        + static_cast<i128>(c) * ipow(M, 6) * ipow(N, 3)
        - static_cast<i128>(b) * ipow(M, 7) * ipow(N, 2)
        + static_cast<i128>(a) * ipow(M, 8) * N
        - ipow(M, 9);
}

static i128 bareiss(std::array<std::array<i128, 8>, 8> matrix, int size) {
    if (size == 0) return 1;
    i128 previous = 1;
    int sign = 1;
    for (int k = 0; k < size - 1; ++k) {
        int pivot_row = k;
        while (pivot_row < size && matrix[pivot_row][k] == 0) ++pivot_row;
        if (pivot_row == size) return 0;
        if (pivot_row != k) {
            std::swap(matrix[pivot_row], matrix[k]);
            sign = -sign;
        }
        const i128 pivot = matrix[k][k];
        for (int row = k + 1; row < size; ++row) {
            for (int column = k + 1; column < size; ++column) {
                const i128 numerator =
                    matrix[row][column] * pivot
                    - matrix[row][k] * matrix[k][column];
                if (numerator % previous != 0) std::abort();
                matrix[row][column] = numerator / previous;
            }
        }
        for (int row = k + 1; row < size; ++row) matrix[row][k] = 0;
        previous = pivot;
    }
    return sign * matrix[size - 1][size - 1];
}

static i128 parity_resultant(
    int a, int b, int c, int d, int e, int f, int h, int j) {
    // Descending coefficient arrays for
    // E=a*y^4+c*y^3+e*y^2+h*y+1 and
    // O=y^4+b*y^3+d*y^2+f*y+j.
    const std::array<i128, 5> E_full = {a, c, e, h, 1};
    const std::array<i128, 5> O_full = {1, b, d, f, j};
    int e_start = 0;
    while (e_start < 4 && E_full[e_start] == 0) ++e_start;
    const int e_size = 5 - e_start;
    const int o_size = 5;  // O is always monic of degree four.
    const int e_degree = e_size - 1;
    const int o_degree = o_size - 1;
    const int size = e_degree + o_degree;
    std::array<std::array<i128, 8>, 8> sylvester{};
    for (int row = 0; row < o_degree; ++row) {
        for (int column = 0; column < e_size; ++column) {
            sylvester[row][row + column] = E_full[e_start + column];
        }
    }
    for (int row = 0; row < e_degree; ++row) {
        for (int column = 0; column < o_size; ++column) {
            sylvester[o_degree + row][row + column] = O_full[column];
        }
    }
    return bareiss(sylvester, size);
}

int main(int argc, char **argv) {
    if (argc != 3) {
        std::cerr << "usage: exp37_nonic_enumerator A J\n";
        return 2;
    }
    const int a = std::atoi(argv[1]);
    const int j = std::atoi(argv[2]);
    if (a < -10 || a > 10 || j < -10 || j > 10) return 2;

    const i64 lm = 309, ln = 500, um = 79, un = 125;
    const i128 lower_e_coefficient = ipow(lm, 4) * ipow(ln, 5);
    const i128 upper_e_coefficient = ipow(um, 4) * ipow(un, 5);

    u64 endpoint_count = 0;
    u64 cd_count = 0;
    u64 cdf_raw_count = 0;
    u64 eliminated_count = 0;
    u64 scalar_count = 0;
    u64 graeffe_count = 0;
    u64 unit_count = 0;

    for (int b = -46; b <= 46; ++b) {
        if (std::llabs(static_cast<i64>(a) * a - 2LL * b) > kGraeffeBounds[8]) continue;
        for (int h = -45; h <= 45; ++h) {
            if (std::llabs(2LL * h - static_cast<i64>(j) * j) > kGraeffeBounds[1]) continue;
            ++endpoint_count;
            for (int c = -116; c <= 116; ++c) {
                i64 d_lower = -181;
                i64 d_upper = 181;
                intersect_linear(-2, 2LL * c * a - 1LL * b * b,
                                 kGraeffeBounds[7], d_lower, d_upper);
                if (d_lower > d_upper) continue;
                cd_count += static_cast<u64>(d_upper - d_lower + 1);
                for (i64 d = d_lower; d <= d_upper; ++d) {
                    for (int f = -115; f <= 115; ++f) {
                        ++cdf_raw_count;

                        // Eliminate e between the y^2 inequality
                        //   u=2e+h^2-2jf, |u|<=85,
                        // and the y^3/y^6 inequalities.  These are necessary
                        // triangle inequalities, not heuristic local filters.
                        const i64 eliminated_g3 =
                            -1LL * f * f + 2LL * h * j * f + 2LL * c
                            - 2LL * j * d - 1LL * h * h * h;
                        if (std::llabs(eliminated_g3)
                            > kGraeffeBounds[3]
                                + kGraeffeBounds[2] * std::llabs(h)) {
                            continue;
                        }
                        const i64 eliminated_g6 =
                            2LL * a * j * f - 1LL * a * h * h
                            + 1LL * c * c - 2LL * f - 2LL * d * b;
                        if (std::llabs(eliminated_g6)
                            > kGraeffeBounds[6]
                                + kGraeffeBounds[2] * std::llabs(a)) {
                            continue;
                        }
                        ++eliminated_count;
                        i64 e_lower = -180;
                        i64 e_upper = 180;

                        // First-Graeffe coefficients y^2, y^3, and y^6.
                        intersect_linear(2, 1LL * h * h - 2LL * j * f,
                                         kGraeffeBounds[2], e_lower, e_upper);
                        intersect_linear(2LL * h,
                            2LL * c - 2LL * j * d - 1LL * f * f,
                            kGraeffeBounds[3], e_lower, e_upper);
                        intersect_linear(2LL * a,
                            1LL * c * c - 2LL * f - 2LL * d * b,
                            kGraeffeBounds[6], e_lower, e_upper);
                        if (e_lower > e_upper) continue;

                        // The unique real root -t lies strictly between the
                        // two rational endpoints, so g(-ell)>0>g(-u).
                        const i128 lower_base = negative_value_base(
                            a, b, c, static_cast<int>(d), f, h, j, lm, ln);
                        const i128 upper_base = negative_value_base(
                            a, b, c, static_cast<int>(d), f, h, j, um, un);
                        e_lower = std::max(e_lower,
                            floor_div(-lower_base, lower_e_coefficient) + 1);
                        e_upper = std::min(e_upper,
                            floor_div(-upper_base - 1, upper_e_coefficient));
                        if (e_lower > e_upper) continue;
                        scalar_count += static_cast<u64>(e_upper - e_lower + 1);

                        for (i64 e = e_lower; e <= e_upper; ++e) {
                            const i64 g4 = 2LL * a + 2LL * h * c + e * e
                                - 2LL * j * b - 2LL * f * d;
                            if (std::llabs(g4) > kGraeffeBounds[4]) continue;
                            const i64 g5 = 2LL * h * a + 2LL * e * c
                                - 2LL * j - 2LL * f * b - d * d;
                            if (std::llabs(g5) > kGraeffeBounds[5]) continue;
                            ++graeffe_count;
                            const i128 resultant = parity_resultant(
                                a, b, c, static_cast<int>(d),
                                static_cast<int>(e), f, h, j);
                            if (resultant != 1 && resultant != -1) continue;
                            ++unit_count;
                            std::cout << "{\"coefficients\":[\"" << a << "\",\""
                                      << b << "\",\"" << c << "\",\"" << d
                                      << "\",\"" << e << "\",\"" << f << "\",\""
                                      << h << "\",\"" << j << "\"]}\n";
                        }
                    }
                }
            }
        }
    }

    std::cerr << a << ' ' << j << ' ' << endpoint_count << ' ' << cd_count
              << ' ' << cdf_raw_count << ' ' << eliminated_count << ' '
              << scalar_count << ' '
              << graeffe_count << ' ' << unit_count << '\n';
}
