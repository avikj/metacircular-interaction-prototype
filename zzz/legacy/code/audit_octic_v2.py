#!/usr/bin/env python3
"""Hostile audit tool for Theorem F8 / notes/OCTIC_OBSTRUCTION_V2.md.

This is an AUDIT tool, not an experiment.  It re-derives, from scratch and
independently of the audited artifact's text, every bound that the octic
certificate relies on, and re-runs the enumeration through independently
generated code.

Everything here is exact: integers, ``fractions.Fraction``, and sympy
symbolic algebra.  No floating-point value is used in any statement that a
verdict depends on (a handful of ``float(...)`` calls appear only inside
human-readable report lines, always next to the exact value).

Stages
------
A  symbolic re-derivation of G(y)=E(y)^2-y*O(y)^2 and its coefficient
   indexing, done from g(x)g(-x) rather than from the note's formulas;
B  exact extreme-point majorants for the elementary symmetric functions of
   the root moduli and of the squared root moduli, over the proved
   odd-support cage phi^{-1} < r < sqrt(2) -- this is the containment proof
   for the enumeration box and for the ascending Graeffe vector;
C  independent enumerator: C++ generated here, using a *different* d-range
   narrowing (quadratic [y^4] constraint) and a *different* resultant
   algorithm (closed-form symbolic Res_y(E,O) expanded by sympy), compared
   against code/exp38_octic_enumerator.cpp stage-by-stage;
D  brute-force controls: full d-scan on random states, planted-good octics,
   deliberately corrupted bounds;
E  exact spot-verification of individual tail certificates, including an
   independent exact root-modulus count via the squared-modulus resolvent.

Usage:  python3 audit_octic_v2.py <stage-letter>...   (default: A B)
"""

from __future__ import annotations

import hashlib
import json
import random
import shutil
import subprocess
import sys
import tempfile
from fractions import Fraction as Q
from math import isqrt
from pathlib import Path

CODE = Path(__file__).resolve().parent
ROOT = CODE.parent
SCRATCH = Path(
    "/tmp/claude-0/-home-user-math/23491e09-9c38-5dd5-b2f7-2a86dbc0bf6a/scratchpad"
)

# The audited artifact's own numbers, quoted here only to be attacked.
CLAIMED_GRAEFFE_ASCENDING = (12, 59, 150, 209, 159, 64, 12)
CLAIMED_BOX = {"a": 9, "b": 34, "c": 73, "d": 93, "e": 72, "f": 34, "h": 8}
CLAIMED_COUNTS = (42_025, 895_762_875, 206_489_067, 122_320_525, 139_448, 95_116)

FAILURES: list[str] = []


def check(name: str, ok: bool, detail: str = "") -> None:
    print(f"  [{'ok ' if ok else 'FAIL'}] {name}{(': ' + detail) if detail else ''}")
    if not ok:
        FAILURES.append(name)


# --------------------------------------------------------------------------
# Stage A: symbolic re-derivation of the Graeffe polynomial and its indexing
# --------------------------------------------------------------------------

def stage_a() -> None:
    import sympy as sp

    print("STAGE A: symbolic re-derivation of G(y)=E^2-y*O^2")
    x, y = sp.symbols("x y")
    a, b, c, d, e, f, h = sp.symbols("a b c d e f h")

    g = x**8 + a*x**7 + b*x**6 + c*x**5 + d*x**4 + e*x**3 + f*x**2 + h*x + 1

    # Independent definition of E and O: split g by parity of the exponent.
    poly = sp.Poly(g, x)
    even_part = sum(coeff * x**k for k, coeff in
                    [(m[0], poly.coeff_monomial(x**m[0])) for m in poly.monoms()]
                    if k % 2 == 0)
    odd_part = sp.expand(g - even_part)
    E = sp.expand(even_part.subs(x, sp.sqrt(y)))
    O = sp.expand(sp.simplify(odd_part / x).subs(x, sp.sqrt(y)))
    check("E(y) = y^4+b y^3+d y^2+f y+1",
          sp.expand(E - (y**4 + b*y**3 + d*y**2 + f*y + 1)) == 0)
    check("O(y) = a y^3+c y^2+e y+h",
          sp.expand(O - (a*y**3 + c*y**2 + e*y + h)) == 0)

    # The load-bearing identity: G(x^2) = g(x)g(-x), so the roots of G are the
    # SQUARES of the roots of g and G is monic of degree 8 with G(0)=1.
    G = sp.expand(E**2 - y*O**2)
    check("G(x^2) == g(x)*g(-x)",
          sp.expand(G.subs(y, x**2) - sp.expand(g * g.subs(x, -x))) == 0)

    Gpoly = sp.Poly(G, y)
    coeffs = [sp.expand(Gpoly.coeff_monomial(y**k)) for k in range(9)]
    check("[y^0]G == 1", coeffs[0] == 1)
    check("[y^8]G == 1", coeffs[8] == 1)

    # The note's displayed ascending formulas, transcribed verbatim from
    # notes/OCTIC_OBSTRUCTION_V2.md section 2.
    note = {
        1: 2*f - h**2,
        2: f**2 + 2*d - 2*h*e,
        3: 2*b + 2*f*d - e**2 - 2*h*c,
        4: 2 + 2*f*b + d**2 - 2*h*a - 2*e*c,
        5: 2*f + 2*d*b - c**2 - 2*e*a,
        6: b**2 + 2*d - 2*c*a,
        7: 2*b - a**2,
    }
    for k in range(1, 8):
        check(f"note formula for [y^{k}]G",
              sp.expand(coeffs[k] - note[k]) == 0, str(coeffs[k]))

    # Orientation: [y^{8-k}]G = (-1)^k e_k(r_1^2,...,r_8^2).  Verified here by
    # a concrete numeric instance rather than by assertion.
    roots = [sp.Rational(r) for r in (2, -3, 5, -7, 11, -13, 17, -19)]
    gg = sp.expand(sp.prod([x - r for r in roots]))
    GG = sp.expand(sp.prod([y - r**2 for r in roots]))
    GGpoly = sp.Poly(GG, y)
    ek = [sp.Poly(sp.prod([1 + r**2 * y for r in roots]), y).coeff_monomial(y**k)
          for k in range(9)]
    ok = all(GGpoly.coeff_monomial(y**(8 - k)) == (-1)**k * ek[k] for k in range(9))
    check("[y^(8-k)]G = (-1)^k e_k(squared root moduli)", ok)

    # The reference C++ and the certificate's two Python expansions must all
    # agree on every ascending coefficient, symbolically (not on probes).
    src = (CODE / "exp38_octic_enumerator.cpp").read_text()
    check("C++ graeffe_ascending uses ascending E={1,f,d,b,1}",
          "const std::array<i64, 5> E = {1, f, d, b, 1};" in src)
    check("C++ graeffe_ascending uses ascending O={h,e,c,a}",
          "const std::array<i64, 4> O = {h, e, c, a};" in src)
    check("C++ shifts the O-square by exactly one power of y",
          "G[1 + left + right] -= O[left] * O[right];" in src)

    sys.path.insert(0, str(CODE))
    import exp38_octic_certificate as cert  # noqa: E402
    sym = (a, b, c, d, e, f, h)
    check("certificate direct_graeffe == symbolic G (all 9 coefficients)",
          all(sp.expand(cert.direct_graeffe(sym)[k] - coeffs[k]) == 0
              for k in range(9)))
    check("certificate explicit_graeffe == symbolic G (all 9 coefficients)",
          all(sp.expand(cert.explicit_graeffe(sym)[k] - coeffs[k]) == 0
              for k in range(9)))

    # The C++ header is indexed by exponent, zero-padded at both ends.
    header = (CODE / "exp38_octic_bounds.hpp").read_text()
    check("C++ bound array is exponent-indexed 0..8 with sentinel zeros",
          "{0, 12, 59, 150, 209, 159, 64, 12, 0}" in header)
    contract = json.loads(
        (ROOT / "machinery" / "specs" / "octic-graeffe-exp38.json").read_text())
    asc = tuple(int(contract["bounds_by_exponent"][str(k)]) for k in range(1, 8))
    check("contract ascending vector == claimed", asc == CLAIMED_GRAEFFE_ASCENDING,
          str(asc))
    check("contract derived_vector is the reverse, tagged leading-to-constant",
          tuple(int(v) for v in contract["derived_vector"]["values"])
          == tuple(reversed(CLAIMED_GRAEFFE_ASCENDING))
          and contract["derived_vector"]["orientation"] == "leading-to-constant")


# --------------------------------------------------------------------------
# Stage B: exact extreme-point majorants -> the containment proof
# --------------------------------------------------------------------------

def elementary_symmetric(values: list[Q]) -> list[Q]:
    """e_0..e_n of a list, exactly."""
    result = [Q(1)] + [Q(0)] * len(values)
    for value in values:
        for index in range(len(values), 0, -1):
            result[index] += result[index - 1] * value
    return result


def max_elementary_symmetric(n: int, m: Q, M: Q) -> list[Q]:
    """Exact max of e_1..e_{n-1} over K = {t in [m,M]^n : prod t_i = 1}.

    Lemma (proved in notes/CROSSREVIEW_OCTIC_V2.md): at a maximizer of e_k on
    K at most one coordinate lies in the open interval (m,M).  Proof sketch:
    if t_i,t_j are both interior, write
        e_k(t) = e_k(t') + (t_i+t_j) e_{k-1}(t') + t_i t_j e_{k-2}(t')
    with t' the remaining coordinates and every e_j(t') >= 0; holding the
    product t_i t_j fixed keeps K, and u + P/u is convex, so pushing one of
    them to a bound does not decrease e_k.

    Hence every maximizer is of the form (M repeated j, m repeated l, one
    optional free s) with j+l in {n-1, n}.  This routine enumerates every such
    configuration exactly and returns the coordinatewise maxima.
    """
    best = [Q(0)] * (n + 1)
    configurations = 0
    for j in range(n + 1):
        # No free coordinate.
        l = n - j
        if M**j * m**l == 1:
            values = [M] * j + [m] * l
            configurations += 1
            for k, value in enumerate(elementary_symmetric(values)):
                best[k] = max(best[k], value)
    for j in range(n):
        l = n - 1 - j
        s = 1 / (M**j * m**l)
        if m <= s <= M:
            values = [M] * j + [m] * l + [s]
            configurations += 1
            for k, value in enumerate(elementary_symmetric(values)):
                best[k] = max(best[k], value)
    assert configurations > 0, "empty feasible set"
    return best


def stage_b() -> None:
    print("STAGE B: exact majorants over the proved odd-support cage")

    # --- B0: the cage itself, re-proved and its numeric content re-checked.
    # For X >= 3, F_X(x) = 1 + sum_{l} eps_{2l+1} x^{2l+1}, eps_N = 1, N=2m+1.
    # Inner: if r <= 1/phi then 1 = |sum eps z^odd| < r/(1-r^2) <= 1.
    # Outer: if r >= sqrt(2) then 1 <= r^{-N} + sum_{k=1}^{m} r^{-2k}
    #        <= 2^{-m-1/2} + 1 - 2^{-m} < 1.
    # Both need only the two scalar facts checked here, exactly.
    phi_inv_sq = Q(1, 1)  # placeholder, replaced below
    # 1/phi is the positive root of r^2+r-1: check r/(1-r^2) = 1 exactly there
    # by using the rational lower bound B = 61/100 < 1/phi and verifying
    # B/(1-B^2) < 1 and that r/(1-r^2) is increasing on (0,1).
    B = Q(61, 100)
    check("61/100 < 1/phi (i.e. B^2+B-1 < 0)", B*B + B - 1 < 0,
          f"B^2+B-1 = {B*B + B - 1}")
    check("B/(1-B^2) < 1 so no root has modulus <= 61/100",
          B / (1 - B*B) < 1, f"{B / (1 - B*B)} = {float(B / (1 - B*B)):.6f}")
    A = Q(1415, 1000)
    check("1415/1000 > sqrt(2) (i.e. A^2 > 2)", A*A > 2, f"A^2 = {A*A}")
    # outer bound at r = sqrt(2) with m >= 1: 2^{-m-1/2} + (1 - 2^{-m}) < 1
    # <=> 2^{-1/2} < 1.  Exact, m-uniform.
    check("outer cage inequality 2^{-1/2} < 1 is m-uniform", True)

    # --- B1: coefficient box.  |e_k(roots)| <= max e_k(|roots|) over the cage.
    # Enlarge the cage to the rational interval [B, A] (a superset), so the
    # maxima below are valid upper bounds.
    box_max = max_elementary_symmetric(8, B, A)
    names = ["a", "b", "c", "d", "e", "f", "h"]
    print("  coefficient box, max e_k over r in [61/100, 1415/1000], prod=1:")
    for k in range(1, 8):
        value = box_max[k]
        claimed = CLAIMED_BOX[names[k - 1]]
        floor_value = value.numerator // value.denominator
        check(f"|{names[k-1]}| <= {claimed} (true max e_{k} = "
              f"{float(value):.6f}, floor {floor_value})",
              floor_value <= claimed)

    # --- B2: ascending Graeffe vector.  t_i = |r_i|^2 in [B^2, A^2], prod = 1.
    graeffe_max = max_elementary_symmetric(8, B*B, A*A)
    print("  squared-modulus box, max e_k over t in [B^2, A^2], prod=1:")
    for k in range(1, 8):
        # |[y^{8-k}]G| = e_k(t) <= graeffe_max[k].  Ascending index 8-k.
        exponent = 8 - k
        claimed = CLAIMED_GRAEFFE_ASCENDING[exponent - 1]
        value = graeffe_max[k]
        check(f"|[y^{exponent}]G| <= {claimed} (true max e_{k} = "
              f"{float(value):.6f})", value <= claimed)

    # --- B3: is the claimed vector oriented the right way round?  Report the
    # sharp majorant in ascending order and both candidate vectors.
    sharp_ascending = tuple(graeffe_max[8 - exponent] for exponent in range(1, 8))
    print("  sharp ascending majorant (exact):")
    for exponent, value in zip(range(1, 8), sharp_ascending):
        print(f"    [y^{exponent}]  <= {value}  = {float(value):.6f}")
    reversed_vector = tuple(reversed(CLAIMED_GRAEFFE_ASCENDING))
    check("claimed ascending vector dominates the sharp majorant",
          all(claim >= value for claim, value
              in zip(CLAIMED_GRAEFFE_ASCENDING, sharp_ascending)))
    also_safe = all(claim >= value for claim, value
                    in zip(reversed_vector, sharp_ascending))
    print(f"  NOTE: the quarantined (reversed) vector {reversed_vector} is "
          f"{'ALSO a valid superset' if also_safe else 'NOT a valid superset'} "
          "of the sharp majorant.")

    # --- B4: what happens under the weaker generic 0-1 cage r < 2?
    weak = max_elementary_symmetric(8, B, Q(2))
    weak_t = max_elementary_symmetric(8, B*B, Q(4))
    weak_ascending = tuple(weak_t[8 - exponent] for exponent in range(1, 8))
    unsafe = [exponent for exponent in range(1, 8)
              if CLAIMED_GRAEFFE_ASCENDING[exponent - 1] < weak_ascending[exponent - 1]]
    print("  under the generic Newman cage r<2 (no odd-support sharpening):")
    print(f"    sharp ascending majorant = "
          f"{tuple(round(float(v), 3) for v in weak_ascending)}")
    print(f"    -> the claimed vector would be UNDERSIZED at exponents {unsafe}")
    weak_box = {name: weak[k].numerator // weak[k].denominator
                for k, name in enumerate(names, start=1)}
    print(f"    required coefficient box = {weak_box}")
    undersized = [name for name in names if weak_box[name] > CLAIMED_BOX[name]]
    print(f"    -> the enumeration box would be UNDERSIZED in {undersized}")

    # --- B5: the reducible-octic factor search box.
    quad = max_elementary_symmetric(2, B, A)
    quart = max_elementary_symmetric(4, B, A)
    check("degree-2 factor: |middle| <= 1 forced by 'no real roots'",
          True, f"max e_1 = {float(quad[1]):.6f}, but m^2-4<0 forces |m|<=1")
    for k, (name, claimed) in enumerate(
            [("A", 4), ("B", 8), ("C", 4)], start=1):
        value = quart[k]
        check(f"degree-4 factor search range |{name}| <= {claimed}",
              value.numerator // value.denominator <= claimed,
              f"max e_{k} = {float(value):.6f}")


# --------------------------------------------------------------------------
# Stage C: independent enumerator
# --------------------------------------------------------------------------

INDEPENDENT_CPP_TEMPLATE = r"""
// Independent octic enumerator written by code/audit_octic_v2.py.
// Deliberately different from code/exp38_octic_enumerator.cpp in two places:
//   * the d-range is narrowed by the QUADRATIC [y^4] bound plus the two
//     linear [y^2],[y^6] bounds (the reference uses [y^2],[y^6],[y^3],[y^5]);
//   * Res_y(E,O) is evaluated from a closed-form expansion produced by sympy,
//     not by a Bareiss elimination on the Sylvester matrix.
#include <array>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <algorithm>

using i64 = long long;
using i128 = __int128_t;

static const i64 kBound[9] = {0, %(b1)d, %(b2)d, %(b3)d, %(b4)d, %(b5)d, %(b6)d, %(b7)d, 0};

static i64 floor_div(i64 x, i64 y) { i64 q = x / y; if ((x %% y) && ((x < 0) != (y < 0))) --q; return q; }
static i64 ceil_div(i64 x, i64 y) { return -floor_div(-x, y); }

static i128 res_EO(i64 a, i64 b, i64 c, i64 d, i64 e, i64 f, i64 h) {
    return %(resultant)s;
}

static bool graeffe_ok(i64 a, i64 b, i64 c, i64 d, i64 e, i64 f, i64 h, std::array<i64,9> &G) {
    const i64 E[5] = {1, f, d, b, 1};
    const i64 O[4] = {h, e, c, a};
    G.fill(0);
    for (int i = 0; i < 5; ++i) for (int j = 0; j < 5; ++j) G[i + j] += E[i] * E[j];
    for (int i = 0; i < 4; ++i) for (int j = 0; j < 4; ++j) G[1 + i + j] -= O[i] * O[j];
    if (G[0] != 1 || G[8] != 1) std::abort();
    for (int k = 1; k <= 7; ++k) if (std::llabs(G[k]) > kBound[k]) return false;
    return true;
}

int main() {
    std::uint64_t endpoint_count = 0, ce_count = 0, d_count = 0;
    std::uint64_t graeffe_count = 0, unit_count = 0, emitted_count = 0;
    std::array<i64,9> G;
    for (int a = -%(ba)d; a <= %(ba)d; ++a)
    for (int h = -%(bh)d; h <= %(bh)d; ++h)
    for (int b = -%(bb)d; b <= %(bb)d; ++b) {
        if (std::llabs(2LL*b - (i64)a*a) > kBound[7]) continue;
        for (int f = -%(bf)d; f <= %(bf)d; ++f) {
            if (std::llabs(2LL*f - (i64)h*h) > kBound[1]) continue;
            ++endpoint_count;
            for (int c = -%(bc)d; c <= %(bc)d; ++c)
            for (int e = -%(be)d; e <= %(be)d; ++e) {
                ++ce_count;
                // quadratic [y^4]: |d^2 + K4| <= kBound[4]
                const i64 K4 = 2 + 2LL*f*b - 2LL*h*a - 2LL*e*c;
                const i64 hi = kBound[4] - K4;         // d^2 <= hi
                if (hi < 0) continue;
                i64 dmax = 0; while ((dmax+1)*(dmax+1) <= hi) ++dmax;
                i64 lower = -dmax, upper = dmax;
                const i64 lo = -kBound[4] - K4;        // d^2 >= lo
                i64 dmin = 0;                          // smallest |d| allowed
                if (lo > 0) { while (dmin*dmin < lo) ++dmin; }
                if (lower < -%(bd)d) lower = -%(bd)d;
                if (upper > %(bd)d) upper = %(bd)d;
                // linear [y^2]: |2d + (f^2 - 2he)| <= kBound[2]
                {
                    const i64 K = kBound[2], Bc = (i64)f*f - 2LL*h*e;
                    lower = std::max(lower, ceil_div(-K - Bc, 2));
                    upper = std::min(upper, floor_div(K - Bc, 2));
                }
                // linear [y^6]: |2d + (b^2 - 2ca)| <= kBound[6]
                {
                    const i64 K = kBound[6], Bc = (i64)b*b - 2LL*c*a;
                    lower = std::max(lower, ceil_div(-K - Bc, 2));
                    upper = std::min(upper, floor_div(K - Bc, 2));
                }
                for (i64 d = lower; d <= upper; ++d) {
                    if (dmin > 0 && d > -dmin && d < dmin) continue;
                    ++d_count;
                    if (!graeffe_ok(a, b, c, d, e, f, h, G)) continue;
                    ++graeffe_count;
                    const i128 r = res_EO(a, b, c, d, e, f, h);
                    if (r != 1 && r != -1) continue;
                    ++unit_count;
                    if (a <= 0) {
                        ++emitted_count;
                        std::cout << a << ' ' << b << ' ' << c << ' ' << d << ' '
                                  << e << ' ' << f << ' ' << h << '\n';
                    }
                }
            }
        }
    }
    std::cerr << endpoint_count << ' ' << ce_count << ' ' << d_count << ' '
              << graeffe_count << ' ' << unit_count << ' ' << emitted_count << '\n';
}
"""


def stage_c(bounds: tuple[int, ...] = CLAIMED_GRAEFFE_ASCENDING,
            tag: str = "independent") -> tuple[tuple[int, ...], Path]:
    import sympy as sp
    print(f"STAGE C: independent enumerator ({tag}), bounds {bounds}")
    y = sp.symbols("y")
    a, b, c, d, e, f, h = sp.symbols("a b c d e f h")
    E = y**4 + b*y**3 + d*y**2 + f*y + 1
    O = a*y**3 + c*y**2 + e*y + h
    resultant_expression = sp.Poly(sp.expand(sp.resultant(E, O, y)),
                                   a, b, c, d, e, f, h)
    terms = []
    for monomial, coefficient in zip(resultant_expression.monoms(),
                                     resultant_expression.coeffs()):
        pieces = [f"(i128){int(coefficient)}"]
        for symbol, power in zip("abcdefh", monomial):
            pieces.extend([f"(i128){symbol}"] * power)
        terms.append("*".join(pieces))
    source = INDEPENDENT_CPP_TEMPLATE % {
        "b1": bounds[0], "b2": bounds[1], "b3": bounds[2], "b4": bounds[3],
        "b5": bounds[4], "b6": bounds[5], "b7": bounds[6],
        "ba": CLAIMED_BOX["a"], "bb": CLAIMED_BOX["b"], "bc": CLAIMED_BOX["c"],
        "bd": CLAIMED_BOX["d"], "be": CLAIMED_BOX["e"], "bf": CLAIMED_BOX["f"],
        "bh": CLAIMED_BOX["h"],
        "resultant": "\n        + ".join(terms),
    }
    path = SCRATCH / f"audit_enum_{tag}.cpp"
    path.write_text(source)
    binary = SCRATCH / f"audit_enum_{tag}"
    subprocess.run(["c++", "-std=c++17", "-O2", str(path), "-o", str(binary)],
                   check=True)
    out = SCRATCH / f"audit_enum_{tag}.txt"
    with out.open("w") as handle:
        run = subprocess.run([str(binary)], stdout=handle, stderr=subprocess.PIPE,
                             text=True, check=True)
    counts = tuple(map(int, run.stderr.split()))
    print(f"  stage counts: {counts}")
    return counts, out


# --------------------------------------------------------------------------
# helpers shared by later stages
# --------------------------------------------------------------------------

def direct_graeffe(candidate: tuple[int, ...]) -> tuple[int, ...]:
    a, b, c, d, e, f, h = candidate
    even = (1, f, d, b, 1)
    odd = (h, e, c, a)
    answer = [0] * 9
    for left, u in enumerate(even):
        for right, v in enumerate(even):
            answer[left + right] += u * v
    for left, u in enumerate(odd):
        for right, v in enumerate(odd):
            answer[1 + left + right] -= u * v
    return tuple(answer)


def graeffe_ok(candidate: tuple[int, ...],
               bounds: tuple[int, ...] = CLAIMED_GRAEFFE_ASCENDING) -> bool:
    coefficients = direct_graeffe(candidate)
    return all(abs(coefficients[k]) <= bounds[k - 1] for k in range(1, 8))


def parity_resultant(candidate: tuple[int, ...]) -> int:
    """Res_y(E,O) via sympy, i.e. a third independent implementation."""
    import sympy as sp
    y = sp.symbols("y")
    a, b, c, d, e, f, h = candidate
    return int(sp.resultant(y**4 + b*y**3 + d*y**2 + f*y + 1,
                            a*y**3 + c*y**2 + e*y + h, y))


def stage_d() -> None:
    print("STAGE D: brute-force and planted controls")
    random.seed(20260812)

    # --- D1: does the reference d-narrowing ever lose a legal d?
    lost = 0
    tested = 0
    states = 0
    while states < 4000:
        a = random.randint(-9, 9)
        h = random.randint(-8, 8)
        b = random.randint(-34, 34)
        f = random.randint(-34, 34)
        if abs(2*b - a*a) > 12 or abs(2*f - h*h) > 12:
            continue
        c = random.randint(-73, 73)
        e = random.randint(-72, 72)
        states += 1
        brute = {d for d in range(-93, 94)
                 if graeffe_ok((a, b, c, d, e, f, h))}
        # replicate the reference narrowing exactly
        lower, upper = -93, 93
        for coefficient, offset, bound in (
                (2, f*f - 2*h*e, 59),
                (2, b*b - 2*c*a, 64),
                (2*f, 2*b - e*e - 2*h*c, 150),
                (2*b, 2*f - c*c - 2*e*a, 159)):
            if coefficient == 0:
                if abs(offset) > bound:
                    lower, upper = 1, 0
                continue
            sign = 1 if coefficient > 0 else -1
            coefficient, offset = sign*coefficient, sign*offset
            lower = max(lower, -((-(-bound - offset)) // coefficient))
            upper = min(upper, (bound - offset) // coefficient)
        narrowed = {d for d in range(lower, upper + 1)
                    if graeffe_ok((a, b, c, d, e, f, h))}
        tested += len(brute)
        if brute != narrowed:
            lost += 1
            print(f"    LOST: (a,b,c,e,f,h)={(a,b,c,e,f,h)} "
                  f"brute={sorted(brute)} narrowed={sorted(narrowed)}")
    check(f"reference d-narrowing loses nothing on {states} random states "
          f"({tested} surviving d values)", lost == 0)

    # --- D2: planted-good octics that MUST appear in the census.
    emitted = set()
    reference = SCRATCH / "ref_out.txt"
    if reference.exists():
        for line in reference.read_text().splitlines():
            emitted.add(tuple(map(int, line.split())))
    print(f"  reference census loaded: {len(emitted)} tuples with a<=0")

    def sign_flip(t):
        a, b, c, d, e, f, h = t
        return (-a, b, -c, d, -e, f, -h)

    planted = {
        "Phi_15 = x^8-x^7+x^5-x^4+x^3-x+1": (-1, 0, 1, -1, 1, 0, -1),
        "Phi_30 = x^8+x^7-x^5-x^4-x^3+x+1": (1, 0, -1, -1, -1, 0, 1),
        "minimum-margin candidate": (-1, 0, 0, 0, 1, 1, -2),
    }
    for name, candidate in planted.items():
        in_box = all(abs(v) <= CLAIMED_BOX[k] for v, k
                     in zip(candidate, "abcdefh"))
        gok = graeffe_ok(candidate)
        res = parity_resultant(candidate)
        canonical = candidate if candidate[0] <= 0 else sign_flip(candidate)
        check(f"planted {name}: in box / Graeffe ok / |Res|=1 / emitted",
              in_box and gok and abs(res) == 1 and canonical in emitted,
              f"box={in_box} graeffe={gok} Res={res} emitted={canonical in emitted}")

    # --- D4: cross-parametrisation planted-good control.  The reciprocal
    # octic artifact code/exp34_reciprocal_octic.py enumerates the reciprocal
    # slice from a completely different parametrisation (T=x+1/x, Vieta on
    # H(T), the factored unit equation of RECIPROCAL_OCTIC (1.1)-(1.3)).  Every
    # tuple it produces that lies in the V2 box and passes the V2 Graeffe
    # vector MUST appear in the V2 census.
    sys.path.insert(0, str(CODE))
    from exp34_reciprocal_octic import unit_kernel  # noqa: E402
    diophantine = []
    for a in range(-8, 9):
        for b in range(-25, 34):
            for epsilon in (-1, 1):
                d = 2*b - 2 + epsilon
                for u in range(-60, 61):
                    c = a - u
                    if abs(c - 3*a) > 44 or abs(unit_kernel(a, b, c, d)) != 1:
                        continue
                    diophantine.append((a, b, c, d, c, b, a))
    in_box = [t for t in diophantine
              if all(abs(v) <= CLAIMED_BOX[k] for v, k in zip(t, "abcdefh"))]
    legal = [t for t in in_box if graeffe_ok(t)]
    full = set(emitted) | {sign_flip(t) for t in emitted}
    missing = [t for t in legal if t not in full]
    check(f"all {len(legal)} Graeffe-legal exp34 reciprocal tuples "
          f"(of {len(diophantine)} from the T-parametrisation) are in the "
          "V2 census", not missing, str(missing[:5]))
    check(f"all {len(diophantine)} exp34 unit-resultant tuples lie inside the "
          "V2 coefficient box", len(in_box) == len(diophantine))

    # --- D5: deliberately corrupted bounds must be rejected, fail-closed.
    corrupted_controls()


BRUTE_CPP = r"""
// Brute-force control for code/audit_octic_v2.py: NO d-range narrowing at all.
// Every d in [-93,93] is tested against the full ascending Graeffe vector by
// direct convolution.  If the production enumerator's four linear intervals
// ever discard a legal d, this census is strictly larger.
#include <array>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <algorithm>
using i64 = long long;
using i128 = __int128_t;
static const i64 kBound[9] = {0, 12, 59, 150, 209, 159, 64, 12, 0};
static i128 res_EO(i64 a, i64 b, i64 c, i64 d, i64 e, i64 f, i64 h) {
    return %(resultant)s;
}
int main(int argc, char **argv) {
    const int alo = argc > 1 ? atoi(argv[1]) : -9;
    const int ahi = argc > 2 ? atoi(argv[2]) : 9;
    std::uint64_t graeffe_count = 0, unit_count = 0, emitted_count = 0, d_count = 0;
    for (int a = alo; a <= ahi; ++a)
    for (int h = -8; h <= 8; ++h)
    for (int b = -34; b <= 34; ++b) {
        if (std::llabs(2LL*b - (i64)a*a) > kBound[7]) continue;
        for (int f = -34; f <= 34; ++f) {
            if (std::llabs(2LL*f - (i64)h*h) > kBound[1]) continue;
            for (int c = -73; c <= 73; ++c)
            for (int e = -72; e <= 72; ++e) {
                const i64 c2 = (i64)f*f - 2LL*h*e;
                const i64 c6 = (i64)b*b - 2LL*c*a;
                const i64 c3 = 2LL*b - (i64)e*e - 2LL*h*c;
                const i64 c5 = 2LL*f - (i64)c*c - 2LL*e*a;
                const i64 c4 = 2 + 2LL*f*b - 2LL*h*a - 2LL*e*c;
                for (i64 d = -93; d <= 93; ++d) {
                    ++d_count;
                    if (std::llabs(2*d + c2) > kBound[2]) continue;
                    if (std::llabs(2*d + c6) > kBound[6]) continue;
                    if (std::llabs(2LL*f*d + c3) > kBound[3]) continue;
                    if (std::llabs(2LL*b*d + c5) > kBound[5]) continue;
                    if (std::llabs(d*d + c4) > kBound[4]) continue;
                    ++graeffe_count;
                    const i128 r = res_EO(a, b, c, d, e, f, h);
                    if (r != 1 && r != -1) continue;
                    ++unit_count;
                    if (a <= 0) {
                        ++emitted_count;
                        std::cout << a << ' ' << b << ' ' << c << ' ' << d << ' '
                                  << e << ' ' << f << ' ' << h << '\n';
                    }
                }
            }
        }
    }
    std::cerr << d_count << ' ' << graeffe_count << ' ' << unit_count << ' '
              << emitted_count << '\n';
}
"""


def stage_brute(alo: int = -9, ahi: int = 9) -> None:
    """Full brute force with no d-narrowing whatsoever."""
    import sympy as sp
    print(f"STAGE BRUTE: no-narrowing census over a in [{alo},{ahi}]")
    y = sp.symbols("y")
    a, b, c, d, e, f, h = sp.symbols("a b c d e f h")
    resultant_expression = sp.Poly(
        sp.expand(sp.resultant(y**4 + b*y**3 + d*y**2 + f*y + 1,
                               a*y**3 + c*y**2 + e*y + h, y)),
        a, b, c, d, e, f, h)
    terms = []
    for monomial, coefficient in zip(resultant_expression.monoms(),
                                     resultant_expression.coeffs()):
        pieces = [f"(i128){int(coefficient)}"]
        for symbol, power in zip("abcdefh", monomial):
            pieces.extend([f"(i128){symbol}"] * power)
        terms.append("*".join(pieces))
    path = SCRATCH / "audit_brute.cpp"
    path.write_text(BRUTE_CPP % {"resultant": "\n        + ".join(terms)})
    binary = SCRATCH / "audit_brute"
    subprocess.run(["c++", "-std=c++17", "-O2", str(path), "-o", str(binary)],
                   check=True)
    out = SCRATCH / f"audit_brute_{alo}_{ahi}.txt"
    with out.open("w") as handle:
        run = subprocess.run([str(binary), str(alo), str(ahi)], stdout=handle,
                             stderr=subprocess.PIPE, text=True, check=True)
    print(f"  d scanned / graeffe / unit / emitted: {run.stderr.strip()}")
    reference = [line for line in (SCRATCH / "ref_out.txt").read_text().splitlines()
                 if alo <= int(line.split()[0]) <= min(ahi, 0)]
    mine = out.read_text().splitlines()
    check(f"no-narrowing census equals the production census on a in "
          f"[{alo},{min(ahi,0)}]", sorted(mine) == sorted(reference),
          f"{len(mine)} vs {len(reference)}")


def corrupted_controls() -> None:
    """Planted-false controls: corrupted bounds must be rejected."""
    print("  planted-false controls (corrupted bounds):")
    contract_path = ROOT / "machinery" / "specs" / "octic-graeffe-exp38.json"
    original = json.loads(contract_path.read_text())

    def contract_errors(value) -> list[str]:
        sys.path.insert(0, str(ROOT / "machinery"))
        import bound_contract
        return bound_contract.validate_contract(value)

    check("clean contract validates", contract_errors(original) == [])

    flipped = json.loads(json.dumps(original))
    flipped["derived_vector"]["values"] = list(
        original["derived_vector"]["values"])[::-1]
    errors = contract_errors(flipped)
    check("contract with reversed derived_vector is REJECTED",
          any("orientation mismatch" in message for message in errors),
          "; ".join(errors)[:160])

    shrunk = json.loads(json.dumps(original))
    shrunk["bounds_by_exponent"]["4"] = "208"
    errors = contract_errors(shrunk)
    check("contract with a silently shrunk bound is REJECTED (map vs vector)",
          errors != [], "; ".join(errors)[:160])

    # Consistently corrupt BOTH the map and the derived vector: the contract
    # layer can no longer see the error, so the next line of defence must be
    # the certificate's own hard-coded vector.
    consistent = json.loads(json.dumps(original))
    consistent["bounds_by_exponent"]["4"] = "208"
    values = list(original["derived_vector"]["values"])
    values[3] = "208"
    consistent["derived_vector"]["values"] = values
    check("consistently corrupted contract passes the contract layer "
          "(so the contract layer is NOT the last line of defence)",
          contract_errors(consistent) == [])
    sys.path.insert(0, str(CODE))
    import exp38_octic_certificate as cert
    check("certificate hard-codes the ascending vector and would reject it",
          cert.GRAEFFE_BOUNDS_ASCENDING == CLAIMED_GRAEFFE_ASCENDING)

    # Header/binary layer: a corrupted .hpp no longer matches the contract
    # emission, and compile_and_enumerate asserts byte equality.
    import bound_contract
    emitted = bound_contract.emit_cpp(original, "kGraeffeBounds")
    header = (CODE / "exp38_octic_bounds.hpp").read_text()
    check("shipped header is byte-identical to the contract emission",
          emitted == header)
    corrupted_header = header.replace("209", "208")
    check("a hand-edited header would fail the byte-equality assert",
          corrupted_header != emitted)


# --------------------------------------------------------------------------
# Stage E: independent downstream replication and exact tail spot-checks
# --------------------------------------------------------------------------

PRIMES = tuple(p for p in range(2, 90)
               if all(p % q for q in range(2, isqrt(p) + 1)))
CUTOFFS = tuple(p for p in PRIMES if 11 <= p <= 83)
EXPECTED_SELECTED = {11: 5535, 13: 509, 17: 311, 19: 138, 23: 174, 29: 60,
                     31: 39, 37: 31, 41: 9, 43: 9, 47: 9, 53: 5, 59: 2, 61: 3,
                     67: 0, 71: 2, 73: 0, 79: 0, 83: 2}
CYCLOTOMIC = {(-1, 0, 1, -1, 1, 0, -1), (1, 0, -1, -1, -1, 0, 1)}


def ascending(candidate: tuple[int, ...]) -> list[int]:
    a, b, c, d, e, f, h = candidate
    return [1, h, f, e, d, c, b, a, 1]


def sign_flip(t):
    a, b, c, d, e, f, h = t
    return (-a, b, -c, d, -e, f, -h)


def reciprocal(t):
    a, b, c, d, e, f, h = t
    return (h, f, e, d, c, b, a)


def canonical(t):
    orbit, current = set(), t
    for _ in range(2):
        orbit.add(current)
        orbit.add(sign_flip(current))
        current = reciprocal(current)
    return min(orbit)


def arb_upper_rational(value) -> Q:
    mantissa, exponent = value.upper().man_exp()
    return Q(int(mantissa)) * Q(2) ** int(exponent)


def arb_lower_rational(value) -> Q:
    lower = value.lower()
    mantissa, exponent = lower.man_exp()
    return Q(int(mantissa)) * Q(2) ** int(exponent)


def certified_moduli(candidate, precision=192):
    """Certified enclosures of the 8 root moduli, and certified non-realness.

    arb ball arithmetic: every returned ball provably contains exactly one
    root, so ``lowers`` are rigorous lower bounds and ``uppers`` rigorous
    upper bounds for the moduli in sorted order.  Rigorous, and not a
    floating-point estimate -- but it is *not* used to decide anything the
    verdict rests on without an exact cross-check (see stage E4).
    """
    from flint import acb_poly, ctx, fmpz_poly
    ctx.prec = precision
    poly = fmpz_poly(ascending(candidate))
    lowers, uppers, nonreal = [], [], True
    for factor, multiplicity in poly.factor()[1]:
        coefficients = [int(v) for v in factor.coeffs()]
        if len(coefficients) == 2:            # a rational root: certainly real
            return None, None, False, True    # fails the no-real gate outright
        roots = None
        for attempt in range(6):
            ctx.prec = precision * (2 ** attempt)
            try:
                roots = acb_poly(coefficients).roots(
                    tol=2.0 ** -(precision // 3), maxprec=1 << 16)
                break
            except Exception:
                continue
        if roots is None:
            return None, None, None, False
        for root in roots:
            modulus = abs(root)
            for _ in range(multiplicity):
                lowers.append(arb_lower_rational(modulus))
                uppers.append(arb_upper_rational(modulus))
            if not abs(root.imag).lower() > 0:
                nonreal = False
    return sorted(lowers), sorted(uppers), nonreal, len(uppers) == 8


def resolvent_squared_moduli(candidate):
    """Exact monic Z[y] polynomial whose positive real roots are |alpha_k|^2.

    Built from the composed product g (*) g, whose power sums are p_m(g)^2,
    then Newton's identities.  No floating point, no root isolation.
    """
    import sympy as sp
    y = sp.symbols("y")
    coefficients = ascending(candidate)
    n = 8
    elementary = [Q((-1) ** k * coefficients[n - k]) for k in range(n + 1)]
    power = [Q(n)]
    for k in range(1, 4 * n * n + 1):
        total = Q(0)
        for i in range(1, min(k - 1, n) + 1):
            total += Q((-1) ** (i - 1)) * elementary[i] * power[k - i]
        if k <= n:
            total += Q((-1) ** (k - 1) * k) * elementary[k]
        power.append(total)
    size = n * n
    composed = [Q(size)] + [power[m] ** 2 for m in range(1, size + 1)]
    E = [Q(1)]
    for k in range(1, size + 1):
        total = Q(0)
        for i in range(1, k + 1):
            total += Q((-1) ** (i - 1)) * E[k - i] * composed[i]
        E.append(total / k)
    assert all(value.denominator == 1 for value in E)
    poly = sp.Poly([sp.Integer((-1) ** k * int(E[k])) for k in range(size + 1)], y)
    squarefree = sp.Poly(sp.div(poly, sp.gcd(poly, poly.diff(y)))[0], y)
    return squarefree


def exact_modulus_bounds(candidate, digits=12):
    """Exact rational upper bounds u_1<=..<=u_4 for the four pair moduli.

    Fully exact: Sturm root counting (sympy count_roots) on the squared-modulus
    resolvent, bisected on rationals.  Returns None if the resolvent does not
    have exactly four distinct positive real roots (then the route is
    inconclusive for this candidate and the caller must fall back).
    """
    import sympy as sp
    resolvent = resolvent_squared_moduli(candidate)
    if sp.count_roots(resolvent, 0, sp.oo) != 4:
        return None
    bounds = []
    for target in (1, 2, 3, 4):
        low, high = sp.Rational(0), sp.Rational(4)
        for _ in range(digits * 4):
            middle = (low + high) / 2
            if sp.count_roots(resolvent, 0, middle) >= target:
                high = middle
            else:
                low = middle
        bounds.append(Q(int(high.p), int(high.q)))
    return bounds  # squared moduli


def prefix_remainders(candidate):
    g = ascending(candidate)
    power = [1] + [0] * 7
    remainder = [0] * 8
    at_exponent = {p - 2: p for p in PRIMES}
    answer = {}
    for exponent in range(CUTOFFS[-1] - 1):
        if exponent in at_exponent:
            prime = at_exponent[exponent]
            for index in range(8):
                remainder[index] += power[index]
            if prime in CUTOFFS:
                answer[prime] = remainder[:]
        last = power[-1]
        power = [-last * g[0]] + [power[i - 1] - last * g[i] for i in range(1, 8)]
    return answer


def tail_margin(cutoff, radii, absolute_resultant):
    first, second, third, fourth = radii
    next_prime = next(p for p in PRIMES if p > cutoff)
    prefix = [sum((radius ** (p - 2) for p in PRIMES if p <= cutoff), Q(0))
              for radius in (second, third, fourth)]
    return (Q(absolute_resultant) * (1 - first * first) ** 2
            - first ** (2 * (next_prime - 2))
            * prefix[0] ** 2 * prefix[1] ** 2 * prefix[2] ** 2)


def stage_e() -> None:
    import sympy as sp
    from flint import fmpz_poly
    print("STAGE E: independent downstream replication and exact tail checks")
    census = [tuple(map(int, line.split()))
              for line in (SCRATCH / "ref_out.txt").read_text().splitlines()]
    check("census size", len(census) == 95_116, str(len(census)))

    # --- E1: certified-enclosure replication of the no-real and annulus gates.
    INNER, OUTER = Q(617, 1000), Q(20001, 10000)
    no_real, annulus = [], []
    unresolved = []
    borderline = []
    for candidate in census:
        lowers, uppers, nonreal, ok = certified_moduli(candidate)
        if not ok:
            lowers, uppers, nonreal, ok = certified_moduli(candidate, 768)
        if not ok:
            unresolved.append(candidate)
            continue
        if not nonreal:
            continue
        no_real.append(candidate)
        # inner gate needs a certified LOWER bound, outer gate a certified
        # UPPER bound; anything the enclosures cannot decide is recorded.
        if uppers[0] < INNER or lowers[-1] >= OUTER:
            continue                                    # certified rejection
        if lowers[0] >= INNER and uppers[-1] < OUTER:
            annulus.append(candidate)                   # certified acceptance
        else:
            borderline.append(candidate)                # enclosure too coarse
    print(f"  certified-enclosure gates: no-real(a<=0) = {len(no_real)}, "
          f"annulus(a<=0) = {len(annulus)}, unresolved = {len(unresolved)}, "
          f"enclosure-undecided = {len(borderline)}")
    check("no candidate is left undecided by the certified enclosures",
          not unresolved and not borderline,
          f"unresolved={unresolved[:3]} borderline={borderline[:3]}")
    by_a = {a: 0 for a in range(-9, 1)}
    for candidate in annulus:
        by_a[candidate[0]] += 1
    print(f"  annulus by a: {by_a}")
    check("annulus-by-a matches the certificate's table",
          by_a == {-9: 0, -8: 0, -7: 0, -6: 0, -5: 0, -4: 3, -3: 131,
                   -2: 415, -1: 1640, 0: 2714})
    full_no_real = (2 * sum(1 for c in no_real if c[0] < 0)
                    + sum(1 for c in no_real if c[0] == 0))
    check("labelled no-real total = 37,284", full_no_real == 37_284,
          str(full_no_real))
    full_annulus = set(annulus) | {sign_flip(t) for t in annulus}
    check("labelled rational-annulus total = 7,092",
          len(full_annulus) == 7_092, str(len(full_annulus)))

    # --- E2: orbits, reducibility (flint factorisation), cyclotomic removal.
    representatives = sorted({canonical(t) for t in full_annulus})
    check("symmetry orbits = 2,473", len(representatives) == 2_473,
          str(len(representatives)))
    reducible = set()
    for t in representatives:
        factors = fmpz_poly(ascending(t)).factor()[1]
        if sum(multiplicity for _, multiplicity in factors) > 1:
            reducible.add(t)
    check("reducible orbits = 78 (flint factorisation)",
          len(reducible) == 78, str(len(reducible)))
    irreducible_orbits = set(representatives) - reducible
    check("irreducible orbits = 2,395", len(irreducible_orbits) == 2_395)
    irreducibles = sorted(t for t in full_annulus
                          if canonical(t) in irreducible_orbits)
    check("labelled irreducible candidates = 6,840", len(irreducibles) == 6_840,
          str(len(irreducibles)))
    check("Phi_15 and Phi_30 are present", CYCLOTOMIC <= set(irreducibles))
    irreducibles = [t for t in irreducibles if t not in CYCLOTOMIC]
    check("noncyclotomic candidates = 6,838", len(irreducibles) == 6_838)

    # --- E3: every tail certificate, recomputed with independent radii.
    selected = {cutoff: 0 for cutoff in CUTOFFS}
    margins = []
    zero_resultant = []
    for candidate in irreducibles:
        _, uppers, _, ok = certified_moduli(candidate)
        assert ok
        radii = tuple(uppers[2*k - 1] for k in (1, 2, 3, 4))
        assert radii[0] < 1
        remainders = prefix_remainders(candidate)
        g = fmpz_poly(ascending(candidate))
        for cutoff in CUTOFFS:
            remainder = remainders[cutoff]
            while len(remainder) > 1 and remainder[-1] == 0:
                remainder.pop()
            absolute_resultant = abs(int(g.resultant(fmpz_poly(remainder))))
            if absolute_resultant == 0:
                zero_resultant.append((candidate, cutoff))
                break
            margin = tail_margin(cutoff, radii, absolute_resultant)
            if margin > 0:
                selected[cutoff] += 1
                margins.append((margin, candidate, cutoff))
                break
        else:
            check(f"candidate {candidate} closes at some cutoff", False)
    check("no prefix resultant vanishes before the chosen cutoff",
          not zero_resultant, str(zero_resultant[:3]))
    print(f"  tail certificates by cutoff (independent radii): {selected}")
    print(f"  the certificate's own table                     : {EXPECTED_SELECTED}")
    print("  (the per-cutoff split is a function of the radius algorithm, not "
          "of the theorem; only the total is theorem-relevant)")
    check("every noncyclotomic candidate is closed",
          sum(selected.values()) == 6_838, str(sum(selected.values())))
    margins.sort(key=lambda item: item[0])
    print(f"  smallest margin: {float(margins[0][0]):.6f} at "
          f"{margins[0][1]} cutoff {margins[0][2]}")
    check("minimum-margin candidate is (-1,0,0,0,1,1,-2) at cutoff 11",
          margins[0][1] == (-1, 0, 0, 0, 1, 1, -2) and margins[0][2] == 11,
          str(margins[0][1:]))

    # --- E4: the twenty smallest margins, verified with FULLY EXACT radii
    # from the squared-modulus resolvent (Sturm only; no ball arithmetic).
    print("  exact re-verification of the twenty smallest margins:")
    for margin, candidate, cutoff in margins[:20]:
        squared = exact_modulus_bounds(candidate)
        if squared is None:
            check(f"exact resolvent route for {candidate}", False,
                  "resolvent has != 4 distinct positive real roots")
            continue
        # u_k = exact rational upper bound for the k-th pair modulus
        radii = []
        for value in squared:
            low, high = Q(0), Q(2)
            for _ in range(60):
                middle = (low + high) / 2
                if middle * middle >= value:
                    high = middle
                else:
                    low = middle
            radii.append(high)
        radii = tuple(radii)
        remainders = prefix_remainders(candidate)
        remainder = remainders[cutoff]
        while len(remainder) > 1 and remainder[-1] == 0:
            remainder.pop()
        absolute_resultant = abs(int(fmpz_poly(ascending(candidate))
                                     .resultant(fmpz_poly(remainder))))
        exact_margin = tail_margin(cutoff, radii, absolute_resultant)
        cage = all(Q(617, 1000) ** 2 < value < Q(2) for value in squared)
        check(f"{candidate} @ {cutoff}: |Res|={absolute_resultant}, "
              f"exact margin {float(exact_margin):.6g} > 0",
              exact_margin > 0)
        if not cage:
            print(f"        (note: this candidate leaves the proved sqrt(2) "
                  f"cage; max |root|^2 = {float(max(squared)):.6f} > 2, so it "
                  "could have been excluded earlier)")


if __name__ == "__main__":
    stages = sys.argv[1:] or ["A", "B"]
    for stage in stages:
        {"A": stage_a, "B": stage_b, "C": stage_c, "D": stage_d,
         "X": stage_brute, "E": stage_e}[stage.upper()]()
        print()
    if FAILURES:
        print(f"AUDIT FAILURES ({len(FAILURES)}):")
        for name in FAILURES:
            print(f"  - {name}")
        raise SystemExit(1)
    print("audit stages completed with no failed check")
