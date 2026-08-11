// Corrected exact integer enumeration for exp38_octic_certificate.py.
//
// This supersedes, but deliberately does not overwrite, the quarantined exp36
// enumerator.  The Graeffe coefficient bounds below are indexed in ascending
// powers y^1,...,y^7 as (12,59,150,209,159,64,12).

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <utility>

#include "exp38_octic_bounds.hpp"

using i64 = long long;
using i128 = __int128_t;
using u128 = __uint128_t;

constexpr u128 power_u128(u128 base, int exponent) {
    u128 answer = 1;
    for (int index = 0; index < exponent; ++index) answer *= base;
    return answer;
}

// Every Sylvester row has squared Euclidean norm at most
// 1^2+34^2+93^2+34^2+1^2 = 10963 < 105^2 (the O rows are smaller).
// Bareiss stored entries are minors.  Before the final exact division the
// numerator is a difference of products of minors of order at most six, so
// its absolute value is below 2*105^12 < 2^82, far inside signed __int128.
constexpr i64 kMaxERowNormSquared = 1 + 34 * 34 + 93 * 93 + 34 * 34 + 1;
constexpr i64 kMaxORowNormSquared = 9 * 9 + 73 * 73 + 72 * 72 + 8 * 8;
static_assert(kMaxERowNormSquared < 105 * 105);
static_assert(kMaxORowNormSquared < 105 * 105);
static_assert(2 * power_u128(105, 12) < (u128(1) << 82));

static i64 floor_div(i64 x, i64 y) {
    if (x >= 0) return x / y;
    return -((-x + y - 1) / y);
}

static i64 ceil_div(i64 x, i64 y) { return -floor_div(-x, y); }

static void intersect_linear(i64 A, i64 B, i64 K, i64 &lower, i64 &upper) {
    // Intersect [lower,upper] with |A*d+B| <= K.
    if (A == 0) {
        if (std::llabs(B) > K) {
            lower = 1;
            upper = 0;
        }
        return;
    }
    if (A < 0) {
        A = -A;
        B = -B;
    }
    lower = std::max(lower, ceil_div(-K - B, A));
    upper = std::min(upper, floor_div(K - B, A));
}

static i128 bareiss(std::array<std::array<i128, 7>, 7> matrix) {
    i128 previous = 1;
    int sign = 1;
    for (int k = 0; k < 6; ++k) {
        int pivot_row = k;
        while (pivot_row < 7 && matrix[pivot_row][k] == 0) ++pivot_row;
        if (pivot_row == 7) return 0;
        if (pivot_row != k) {
            std::swap(matrix[pivot_row], matrix[k]);
            sign = -sign;
        }
        const i128 pivot = matrix[k][k];
        for (int i = k + 1; i < 7; ++i) {
            for (int j = k + 1; j < 7; ++j) {
                const i128 numerator =
                    matrix[i][j] * pivot - matrix[i][k] * matrix[k][j];
                // Bareiss exact division is load-bearing.  A failed division
                // aborts rather than silently truncating.
                if (numerator % previous != 0) std::abort();
                matrix[i][j] = numerator / previous;
            }
        }
        for (int i = k + 1; i < 7; ++i) matrix[i][k] = 0;
        previous = pivot;
    }
    return sign * matrix[6][6];
}

static i128 parity_resultant(int a, int b, int c, int d, int e, int f, int h) {
    // Descending coefficients of E=y^4+b*y^3+d*y^2+f*y+1 and
    // O=a*y^3+c*y^2+e*y+h.
    const std::array<i128, 5> E = {1, b, d, f, 1};
    const std::array<i128, 4> O = {a, c, e, h};
    std::array<std::array<i128, 7>, 7> sylvester{};
    for (int row = 0; row < 3; ++row) {
        for (int j = 0; j < 5; ++j) sylvester[row][row + j] = E[j];
    }
    for (int row = 0; row < 4; ++row) {
        for (int j = 0; j < 4; ++j) sylvester[3 + row][row + j] = O[j];
    }
    return bareiss(sylvester);
}

static std::array<i64, 9> graeffe_ascending(
    int a, int b, int c, int d, int e, int f, int h) {
    // Independently expand G=E^2-y*O^2 from ascending coefficient arrays.
    const std::array<i64, 5> E = {1, f, d, b, 1};
    const std::array<i64, 4> O = {h, e, c, a};
    std::array<i64, 9> G{};
    for (int left = 0; left < 5; ++left) {
        for (int right = 0; right < 5; ++right) {
            G[left + right] += E[left] * E[right];
        }
    }
    for (int left = 0; left < 4; ++left) {
        for (int right = 0; right < 4; ++right) {
            G[1 + left + right] -= O[left] * O[right];
        }
    }
    return G;
}

static bool graeffe_ok(int a, int b, int c, int d, int e, int f, int h) {
    const auto coefficients = graeffe_ascending(a, b, c, d, e, f, h);
    if (coefficients[0] != 1 || coefficients[8] != 1) std::abort();
    for (int exponent = 1; exponent <= 7; ++exponent) {
        if (std::llabs(coefficients[exponent]) > kGraeffeBounds[exponent]) return false;
    }
    return true;
}

int main() {
    std::uint64_t endpoint_count = 0;
    std::uint64_t ce_count = 0;
    std::uint64_t d_count = 0;
    std::uint64_t graeffe_count = 0;
    std::uint64_t unit_count = 0;
    std::uint64_t emitted_count = 0;

    for (int a = -9; a <= 9; ++a) {
        for (int h = -8; h <= 8; ++h) {
            for (int b = -34; b <= 34; ++b) {
                if (std::abs(2 * b - a * a) > 12) continue;  // [y^7]G
                for (int f = -34; f <= 34; ++f) {
                    if (std::abs(2 * f - h * h) > 12) continue;  // [y^1]G
                    ++endpoint_count;
                    for (int c = -73; c <= 73; ++c) {
                        for (int e = -72; e <= 72; ++e) {
                            ++ce_count;
                            i64 lower = -93;
                            i64 upper = 93;
                            // [y^2]G and [y^6]G.
                            intersect_linear(2, (i64)f * f - 2LL * h * e,
                                             59, lower, upper);
                            intersect_linear(2, (i64)b * b - 2LL * c * a,
                                             64, lower, upper);
                            // [y^3]G and [y^5]G.
                            intersect_linear(2LL * f,
                                             2LL * b - (i64)e * e - 2LL * h * c,
                                             150, lower, upper);
                            intersect_linear(2LL * b,
                                             2LL * f - (i64)c * c - 2LL * e * a,
                                             159, lower, upper);
                            if (lower > upper) continue;
                            for (i64 d = lower; d <= upper; ++d) {
                                ++d_count;
                                // Direct coefficient-index check guards every
                                // algebraically derived interval above.
                                if (!graeffe_ok(a, b, c, (int)d, e, f, h)) continue;
                                ++graeffe_count;
                                const i128 resultant = parity_resultant(
                                    a, b, c, (int)d, e, f, h);
                                if (resultant != 1 && resultant != -1) continue;
                                ++unit_count;
                                if (a <= 0) {
                                    ++emitted_count;
                                    std::cout << a << ' ' << b << ' ' << c << ' '
                                              << d << ' ' << e << ' ' << f << ' '
                                              << h << '\n';
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    std::cerr << endpoint_count << ' ' << ce_count << ' ' << d_count << ' '
              << graeffe_count << ' ' << unit_count << ' ' << emitted_count
              << '\n';
}
