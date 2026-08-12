#!/usr/bin/env python3
"""Exact central-projector traces for Pauli sign and Ramanujan sectors."""

from fractions import Fraction
from math import gcd


def divisors(n):
    return tuple(d for d in range(1, n + 1) if n % d == 0)


def mobius(n):
    primes = 0
    p = 2
    while p * p <= n:
        if n % p == 0:
            n //= p
            primes += 1
            if n % p == 0:
                return 0
            while n % p == 0:
                n //= p
        p += 1
    return -1 if (primes + (n > 1)) % 2 else 1


def ramanujan(q, n):
    return sum(d * mobius(q // d) for d in divisors(gcd(q, n)))


def mm(a, b):
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(len(b)))
                       for j in range(len(b[0]))) for i in range(len(a)))


def trace(a):
    return sum(a[i][i] for i in range(len(a)))


def translation(q, n):
    return tuple(tuple(Fraction(int(i == (j + n) % q)) for j in range(q))
                 for i in range(q))


def primitive_projector(q):
    # Fourier kernel of the sum of primitive additive-character idempotents.
    return tuple(tuple(Fraction(ramanujan(q, i - j), q) for j in range(q))
                 for i in range(q))


def identity(n):
    return tuple(tuple(Fraction(int(i == j)) for j in range(n)) for i in range(n))


def main():
    q = 6
    P = primitive_projector(q)
    assert mm(P, P) == P
    assert trace(P) == 2  # phi(6)
    for n in range(q):
        assert trace(mm(P, translation(q, n))) == ramanujan(q, n)

    # Full regular representation is a hostile control: without the primitive
    # projector, nonidentity translations have trace zero, not c_q(n).
    assert trace(mm(identity(q), translation(q, 1))) == 0
    assert ramanujan(q, 1) == 1

    # Pauli central C2: rho(z)=-I_4.  e_-=(I-rho(z))/2=I and
    # e_+=(I+rho(z))/2=0 in this representation.
    Iz = tuple(tuple(Fraction(int(i == j)) for j in range(4)) for i in range(4))
    z = tuple(tuple(-x for x in row) for row in Iz)
    e_minus = tuple(tuple((Iz[i][j] - z[i][j]) / 2 for j in range(4)) for i in range(4))
    e_plus = tuple(tuple((Iz[i][j] + z[i][j]) / 2 for j in range(4)) for i in range(4))
    assert e_minus == Iz and e_plus == tuple(tuple(Fraction(0) for _ in range(4)) for _ in range(4))
    assert trace(mm(e_minus, z)) == -4
    assert trace(mm(e_plus, z)) == 0

    print({"ramanujan_q6": tuple(ramanujan(q, n) for n in range(q)),
           "primitive_rank": trace(P), "pauli_sign_trace": -4,
           "pauli_trivial_control": 0})
    print("ALL EXACT CHARACTER-PROJECTOR CHECKS PASS")


if __name__ == "__main__":
    main()
