#!/usr/bin/env python3
"""Independent exact checks for smith_holonomy_audit_and_stabilizer.md."""

from itertools import product


def matmul(a, b):
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(len(b)))
                       for j in range(len(b[0]))) for i in range(len(a)))


def act(h, z, d):
    return tuple(sum(h[i][j] * z[j] for j in range(len(z))) % d[i]
                 for i in range(len(z)))


def main():
    d = (1, 2, 6)
    D = ((1, 0, 0), (0, 2, 0), (0, 0, 6))
    H = ((3, -4, 1), (4, -5, 1), (-6, 9, -2))
    K = ((3, -8, 6), (2, -5, 3), (-1, 3, -2))
    assert matmul(H, D) == matmul(D, K)

    carrier = tuple(product(*(range(n) for n in d)))
    assert any(act(H, z, d) != z for z in carrier)
    assert all(act(H, act(H, act(H, z, d), d), d) == z for z in carrier)
    fixed = tuple(z for z in carrier if act(H, z, d) == z)
    assert fixed == ((0, 0, 0), (0, 0, 2), (0, 0, 4))

    # Kernel criterion: H^3 acts identically exactly modulo each row modulus.
    H3 = matmul(matmul(H, H), H)
    assert all((H3[i][j] - int(i == j)) % d[i] == 0
               for i in range(3) for j in range(3))

    # Orbit equivalence under automorphisms need not be additive congruence.
    # On Z/5, inversion identifies 1 and 4, but translation by 1 produces
    # 2 and 0, which are in different inversion orbits.
    orbit = lambda x: frozenset((x % 5, (-x) % 5))
    assert orbit(1) == orbit(4)
    assert orbit(1 + 1) != orbit(4 + 1)

    # Unimodular D=I still has nontrivial two-sided stabilizer (S,S^-1).
    I = ((1, 0), (0, 1))
    S = ((1, 1), (0, 1))
    Sinv = ((1, -1), (0, 1))
    assert S != I and matmul(matmul(S, I), Sinv) == I
    print("ALL EXACT STABILIZER CHECKS PASS")


if __name__ == "__main__":
    main()
