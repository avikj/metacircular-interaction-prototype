#!/usr/bin/env python3
"""Exact classification of irreducible septic prime-prefix factors.

For F_X(x)=sum_{p<=X} x^(p-2), this certificate proves that an irreducible
degree-seven factor occurs exactly for 11<=X<13, where it is

    x^7+x^6-x^4+x^2+2*x+1.

The large finite unit-resultant enumeration is performed by an embedded C++
helper using signed __int128 arithmetic.  Python then independently rechecks
every emitted resultant with Bareiss determinants and performs all Sturm,
Cayley--Routh, irreducibility, resultant, bisection, and tail assertions with
integers or Fraction.  Floating point is display-only.
"""

from __future__ import annotations

from collections import Counter
from fractions import Fraction as Q
from math import isqrt
from pathlib import Path
import shutil
import subprocess
import tempfile
from time import perf_counter

from exp30_quartic_certificate import (
    divmod_poly,
    evaluate,
    real_root_count,
    resultant,
    roots_between,
)


LOWER = Q(309, 500)
UPPER = Q(79, 125)
INNER_DISK = Q(617, 1000)
OUTER_DISK = Q(20001, 10000)
CUTOFFS = (11, 13, 17, 19, 23)
PRIMES = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
H7 = (1, 0, -1, 0, 1, 2)

EXPECTED_ANNULUS = {
    (-2, 1, 2, 2, -3, -1), (-2, 3, 0, 3, 2, 1),
    (-2, 3, 1, 2, 1, 1), (-1, -1, 2, 3, -3, -1),
    (-1, 0, 0, 3, -2, -1), (-1, 1, -1, 1, -1, 0),
    (-1, 2, -3, 1, 0, 0), (-1, 2, -1, 3, 2, 1),
    (-1, 2, 0, 2, 1, 1), (-1, 2, 1, 1, 0, 1),
    (-1, 2, 2, 0, -1, 1), (-1, 2, 3, -1, -2, 1),
    (-1, 4, -3, 1, -1, -1), (-1, 4, -3, 2, 1, 0),
    (-1, 4, -3, 3, 0, -1), (0, 0, 0, 4, 0, 0),
    (0, 1, -1, 2, 1, 1), (0, 1, 0, 1, 0, 1),
    (0, 1, 1, 0, -1, 1), (0, 1, 2, -1, -2, 1),
    (0, 2, -1, 1, -1, 0), (0, 2, 0, -2, 0, 2),
    (0, 3, 1, 4, 2, 1), (0, 4, -1, 1, -2, -1),
    (0, 4, 0, 4, 1, 0), (1, -1, -1, 2, 2, 2),
    (1, 0, -2, 2, 1, 1), H7, (1, 0, -1, 1, 0, 1),
    (1, 0, 0, 0, -1, 1), (1, 1, -1, 0, -2, 0),
    (1, 1, 0, -2, -2, 1), (1, 3, 2, 4, 3, 2),
    (1, 3, 3, 3, 2, 2), (2, -1, -3, 2, 1, 1),
    (2, -1, -2, 1, 0, 1), (2, 3, 1, 3, 1, 1),
}

EXPECTED_DECISIONS = {
    ("tail", 11): 27,
    ("tail", 13): 2,
    ("tail", 19): 1,
    ("negative", 11): 1,
    ("negative", 13): 4,
    ("negative", 23): 1,
    ("zero", 11): 1,
}


CPP_SOURCE = r'''
#include <algorithm>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <limits>
using i64 = long long;
using i128 = __int128_t;

static i64 floor_div(i128 x, i128 y) {
  if (x >= 0) return (i64)(x / y);
  return (i64)(-((-x + y - 1) / y));
}
static i128 hbase(int a,int b,int c,int d,int f,i64 m,i64 n) {
  i128 M=m,N=n, m2=M*M,m3=m2*M,m4=m3*M,m5=m4*M,m6=m5*M,m7=m6*M;
  i128 n2=N*N,n3=n2*N,n4=n3*N,n5=n4*N,n6=n5*N,n7=n6*N;
  return -m7+(i128)a*m6*N-(i128)b*m5*n2+(i128)c*m4*n3
         -(i128)d*m3*n4-(i128)f*M*n6+n7;
}
static i128 ecoef(i64 m,i64 n) {
  i128 M=m,N=n; return M*M*N*N*N*N*N;
}
static i64 det3(i64 a00,i64 a01,i64 a02,i64 a10,i64 a11,i64 a12,
                i64 a20,i64 a21,i64 a22) {
  i128 z=(i128)a00*((i128)a11*a22-(i128)a12*a21)
        -(i128)a01*((i128)a10*a22-(i128)a12*a20)
        +(i128)a02*((i128)a10*a21-(i128)a11*a20);
  if(z<std::numeric_limits<i64>::min()||z>std::numeric_limits<i64>::max())
    std::abort();
  return (i64)z;
}
static i64 delta(int a,int b,int c,int d,int e,int f) {
  i64 A=(i64)c-(i64)a*b, B=(i64)e-(i64)a*d, C=1-(i64)a*f;
  return det3(C,-A*f,f*(A*b-B), B,C-A*d,A*((i64)b*d-f)-B*d,
              A,B-A*b,C-B*b+A*((i64)b*b-d));
}
int main() {
  const i64 lm=309,ln=500,um=79,un=125;
  const i128 lK=ecoef(lm,ln),uK=ecoef(um,un);
  uint64_t five=0,signfull=0,unit=0;
  for(int a=-7;a<=7;a++) for(int b=-25;b<=25;b++)
  for(int c=-44;c<=44;c++) for(int d=-44;d<=44;d++)
  for(int f=-7;f<=7;f++) {
    five++;
    i128 lb=hbase(a,b,c,d,f,lm,ln),ub=hbase(a,b,c,d,f,um,un);
    i64 emin=floor_div(-lb,lK)+1,emax=floor_div(-ub-1,uK);
    emin=std::max<i64>(emin,-25); emax=std::min<i64>(emax,25);
    if(emin>emax) continue;
    signfull+=(uint64_t)(emax-emin+1);
    for(i64 e=emin;e<=emax;e++) {
      i64 D=delta(a,b,c,d,(int)e,f);
      if(D==1||D==-1) {
        unit++; std::cout<<a<<' '<<b<<' '<<c<<' '<<d<<' '<<e<<' '<<f<<'\n';
      }
    }
  }
  std::cerr<<five<<' '<<signfull<<' '<<unit<<'\n';
}
'''


def run_enumerator() -> list[tuple[int, ...]]:
    compiler = shutil.which("c++") or shutil.which("g++") or shutil.which("clang++")
    if compiler is None:
        raise RuntimeError("an ISO C++ compiler is required for the finite enumeration")
    with tempfile.TemporaryDirectory(prefix="septic-certificate-") as directory:
        source = Path(directory) / "enumerate.cpp"
        executable = Path(directory) / "enumerate"
        source.write_text(CPP_SOURCE)
        subprocess.run(
            [compiler, "-std=c++17", "-O3", str(source), "-o", str(executable)],
            check=True,
        )
        process = subprocess.run([str(executable)], check=True, text=True, capture_output=True)
    counts = tuple(map(int, process.stderr.split()))
    assert counts == (90_893_475, 21_647_831, 2_266)
    tuples = [tuple(map(int, line.split())) for line in process.stdout.splitlines()]
    assert len(tuples) == len(set(tuples)) == 2_266
    return tuples


def trim_descending(f: list[int]) -> list[int]:
    while len(f) > 1 and f[0] == 0:
        f.pop(0)
    return f


def check_unit_resultant(t: tuple[int, ...]) -> None:
    a, b, c, d, e, f = t
    even = trim_descending([a, c, e, 1])
    odd = [1, b, d, f]
    assert abs(resultant(odd, even)) == 1


def multiply(f: list[Q], g: list[Q]) -> list[Q]:
    answer = [Q(0)] * (len(f) + len(g) - 1)
    for i, x in enumerate(f):
        for j, y in enumerate(g):
            answer[i + j] += x * y
    return answer


def power(f: list[Q], exponent: int) -> list[Q]:
    answer = [Q(1)]
    for _ in range(exponent):
        answer = multiply(answer, f)
    return answer


def cayley_descending(t: tuple[int, ...], radius: Q) -> list[Q]:
    a, b, c, d, e, f = t
    g = list(map(Q, [1, f, e, d, c, b, a, 1]))
    answer = [Q(0)] * 8
    for exponent, coefficient in enumerate(g):
        term = multiply(power([Q(1), Q(-1)], exponent), power([Q(1), Q(1)], 7 - exponent))
        for index, value in enumerate(term):
            answer[index] += coefficient * radius**exponent * value
    return list(reversed(answer))


def routh_rhp(descending: list[Q]) -> int:
    degree = len(descending) - 1
    width = (degree + 2) // 2
    table = [[Q(0)] * width for _ in range(degree + 1)]
    table[0][: len(descending[0::2])] = descending[0::2]
    table[1][: len(descending[1::2])] = descending[1::2]
    assert table[0][0] and table[1][0]
    for row in range(2, degree + 1):
        assert table[row - 1][0] and any(table[row - 1])
        for column in range(width - 1):
            table[row][column] = (
                table[row - 1][0] * table[row - 2][column + 1]
                - table[row - 2][0] * table[row - 1][column + 1]
            ) / table[row - 1][0]
        assert any(table[row])
    signs = [(row[0] > 0) - (row[0] < 0) for row in table]
    assert 0 not in signs
    return sum(left != right for left, right in zip(signs, signs[1:]))


def h_polynomial(t: tuple[int, ...]) -> list[Q]:
    a, b, c, d, e, f = t
    return list(map(Q, [1, -f, e, -d, c, -b, a, -1]))


def isolate_negative_modulus(t: tuple[int, ...], steps: int = 50) -> tuple[Q, Q]:
    h = h_polynomial(t)
    lower, upper = LOWER, UPPER
    assert evaluate(h, lower) > 0 and evaluate(h, upper) < 0
    for _ in range(steps):
        middle = (lower + upper) / 2
        value = evaluate(h, middle)
        if value > 0:
            lower = middle
        elif value < 0:
            upper = middle
        else:
            return middle, middle
    return lower, upper


def prefix_at_negative(cutoff: int) -> list[Q]:
    answer = [Q(0)] * (cutoff - 1)
    answer[0] = Q(1)
    for prime in PRIMES:
        if 3 <= prime <= cutoff:
            answer[prime - 2] = Q(-1)
    return answer


def tail_polynomial(cutoff: int) -> list[Q]:
    prefix = prefix_at_negative(cutoff)
    answer = prefix + [Q(0), Q(0)]
    for index, value in enumerate(prefix):
        answer[index + 2] -= value
    next_prime = next(prime for prime in PRIMES if prime > cutoff)
    exponent = next_prime - 2
    if len(answer) <= exponent:
        answer.extend([Q(0)] * (exponent + 1 - len(answer)))
    answer[exponent] -= 1
    return answer


def assert_decreasing(polynomial: list[Q]) -> None:
    derivative = [Q(index) * polynomial[index] for index in range(1, len(polynomial))]
    assert evaluate(derivative, LOWER) < 0
    assert roots_between(derivative, LOWER, UPPER) == 0


def prefix_remainder(t: tuple[int, ...], cutoff: int) -> list[int]:
    a, b, c, d, e, f = t
    g = [1, f, e, d, c, b, a, 1]  # ascending
    prefix = [0] * (cutoff - 1)
    for prime in PRIMES:
        if prime <= cutoff:
            prefix[prime - 2] = 1
    for exponent in range(len(prefix) - 1, 6, -1):
        coefficient = prefix[exponent]
        if coefficient:
            for index in range(7):
                prefix[exponent - 7 + index] -= coefficient * g[index]
    return prefix[:7]


def prefix_resultant(t: tuple[int, ...], cutoff: int) -> int:
    remainder = prefix_remainder(t, cutoff)
    while len(remainder) > 1 and remainder[-1] == 0:
        remainder.pop()
    return resultant([1, *t, 1], list(reversed(remainder)))


def integer_divides(f_descending: list[int], g_descending: list[int]) -> bool:
    _, remainder = divmod_poly(
        [Q(value) for value in reversed(f_descending)],
        [Q(value) for value in reversed(g_descending)],
    )
    return remainder == [0]


def reducible_septic(g_descending: list[int]) -> bool:
    for constant in (-1, 1):
        if integer_divides(g_descending, [1, constant]):
            return True
        for linear in range(-3, 4):
            if integer_divides(g_descending, [1, linear, constant]):
                return True
        for quadratic in range(-5, 6):
            for linear in range(-11, 12):
                if integer_divides(g_descending, [1, quadratic, linear, constant]):
                    return True
    return False


def main() -> None:
    start = perf_counter()
    unit = run_enumerator()
    for candidate in unit:
        check_unit_resultant(candidate)

    one_real = []
    annulus = []
    for candidate in unit:
        a, b, c, d, e, f = candidate
        g_ascending = list(map(Q, [1, f, e, d, c, b, a, 1]))
        if real_root_count(g_ascending) != 1:
            continue
        one_real.append(candidate)
        if routh_rhp(cayley_descending(candidate, INNER_DISK)) != 0:
            continue
        if routh_rhp(cayley_descending(candidate, OUTER_DISK)) != 7:
            continue
        annulus.append(candidate)

    assert len(one_real) == 537
    assert set(annulus) == EXPECTED_ANNULUS
    assert len(annulus) == 37

    for cutoff in CUTOFFS:
        assert_decreasing(prefix_at_negative(cutoff))
        assert_decreasing(tail_polynomial(cutoff))

    decisions: dict[tuple[int, ...], tuple[str, int, Q]] = {}
    tail_margins = []
    negative_margins = []
    for candidate in annulus:
        lower, upper = isolate_negative_modulus(candidate)
        for cutoff in CUTOFFS:
            result = prefix_resultant(candidate, cutoff)
            if result == 0:
                assert prefix_remainder(candidate, cutoff) == [0] * 7
                decisions[candidate] = ("zero", cutoff, Q(0))
                break
            prefix = prefix_at_negative(cutoff)
            if evaluate(prefix, lower) < 0:
                margin = -evaluate(prefix, lower)
                decisions[candidate] = ("negative", cutoff, margin)
                negative_margins.append((margin, candidate, cutoff))
                break
            tail = tail_polynomial(cutoff)
            if evaluate(prefix, upper) > 0 and evaluate(tail, upper) > 0:
                margin = evaluate(tail, upper)
                decisions[candidate] = ("tail", cutoff, margin)
                tail_margins.append((margin, candidate, cutoff))
                break
        assert candidate in decisions

    counts = Counter((kind, cutoff) for kind, cutoff, _ in decisions.values())
    assert counts == EXPECTED_DECISIONS
    zeros = [candidate for candidate, decision in decisions.items() if decision[0] == "zero"]
    assert zeros == [H7]
    assert min(tail_margins)[1:] == ((-1, 2, 3, -1, -2, 1), 19)
    assert min(negative_margins)[1:] == ((1, -1, -1, 2, 2, 2), 23)

    h7_descending = [1, *H7, 1]
    assert not reducible_septic(h7_descending)
    phi6_descending = [1, -1, 1]
    f11_descending = [1 if exponent in {0, 1, 3, 5, 9} else 0 for exponent in range(9, -1, -1)]
    product = [Q(0)] * 10
    h7_ascending = list(reversed(h7_descending))
    phi6_ascending = list(reversed(phi6_descending))
    for i, x in enumerate(h7_ascending):
        for j, y in enumerate(phi6_ascending):
            product[i + j] += x * y
    assert list(reversed([int(value) for value in product])) == f11_descending
    h7_lower, _ = isolate_negative_modulus(H7)
    assert evaluate(prefix_at_negative(13), h7_lower) < 0

    minimum_tail = min(tail_margins)
    minimum_negative = min(negative_margins)
    print("septic certificate: PASS")
    print("five-tuples scanned: 90893475")
    print("scalar-window full tuples: 21647831")
    print(f"unit-resultant tuples: {len(unit)}")
    print(f"one-real tuples: {len(one_real)}")
    print(f"rational-annulus tuples: {len(annulus)}")
    print(f"decisions: {dict(sorted(counts.items()))}")
    print(f"unique zero: {H7} at q=11")
    print(f"minimum tail margin exact: {minimum_tail[0]}")
    print(f"minimum tail margin decimal: {float(minimum_tail[0]):.12f}")
    print(f"minimum negative margin exact: {minimum_negative[0]}")
    print(f"minimum negative margin decimal: {float(minimum_negative[0]):.12f}")
    print(f"elapsed seconds: {perf_counter() - start:.6f}")


if __name__ == "__main__":
    main()
