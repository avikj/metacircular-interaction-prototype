"""Exact replay for notes/BIJECTIVE_SMITH_ASSEMBLY.md (fleet-bijective-assembly).

Successor seed 2 of R0038: the bijective (structural) proof of R0034's
assembly identity.  Column-lattice convention of
machinery/hecke_coset_smith_assembly.py throughout: L = M Z^2, Hermite
basis ((a,0),(b,d)) means columns (a,b),(0,d), ad = index, 0 <= b < d;
e1(L) = gcd(a,b,d) is the first Smith invariant (the stratum label).

The bijection (proofs in the note; all classical):

    Phi : {index-m sublattices}
          --> DisjointUnion_{c^2 | m} {cyclic index-(m/c^2) sublattices},
    Phi(L) = (e1(L), (1/e1(L)) L),      Phi^{-1}(c, L') = c L'.

In Hermite coordinates Phi is literal coordinatewise division:
((a,0),(b,d)) |-> (c, ((a/c,0),(b/c,d/c))), c = gcd(a,b,d), and the
corner b/c is PROVABLY already reduced mod d/c — the mod-reduction is
the identity (note, Lemma 2) — because c | b, c | d and 0 <= b < d
force b <= d - c, i.e. 0 <= b/c <= d/c - 1.

Corollaries replayed here:

* Counting (R0034's assembly identity): sigma_1(m) = sum_{c^2|m}
  psi(m/c^2), now as the cardinality of an explicit bijection, fiber by
  fiber (each label-c stratum maps ONTO the cyclic index-(m/c^2) space).

* Second moment: S(m) := sum_{[Z^2:L]=m} e1(L) = sum_{c^2|m} c psi(m/c^2)
  = sum_{c^2|m} euler_phi(c) sigma_1(m/c^2), multiplicative, with
  prime-power closed form
      S(p^k) = (p^{k+1} + p^k - p^{ceil(k/2)} - p^{floor(k/2)}) / (p-1)
  and Dirichlet series zeta(s) zeta(s-1) zeta(2s-1) / zeta(2s).  S is
  NOT a standard sigma variant: S(4) = 8 while sigma_1(4) = 7,
  psi(4) = 6, sigma_2(4) = 21.

* Equivariance: e1(gamma L) = e1(L) and (1/c)(gamma L) = gamma((1/c)L)
  for gamma in SL_2(Z), so Phi descends to orbits and each stratum
  {e1 = c} is one orbit with base point c.(Z + (m/c^2)Z) and stabilizer
  Gamma_0(m/c^2).

All computations are exact integers.
"""

from math import gcd, isqrt

from hecke_coset_smith_assembly import (
    hnf_bases,
    mat_mul,
    psi,
    sigma1,
    transitivity_witness,
)
from hecke_composition_smith_labels import hermite_reduce

__all__ = [
    "label",
    "square_divisors",
    "phi",
    "phi_inverse",
    "assembly_fibers",
    "second_moment",
    "second_moment_bijective",
    "second_moment_totient",
    "second_moment_prime_power",
    "second_moment_closed",
    "euler_phi",
    "factorize",
    "gamma_dot",
    "unimodular_window",
    "stratum_base_point",
    "stratum_orbit_witness",
]


def label(basis):
    """The stratum label c = e1(L) = gcd(a,b,d), first Smith invariant."""
    (a, _), (b, d) = basis
    return gcd(gcd(a, b), d)


def square_divisors(m):
    """All c >= 1 with c^2 | m."""
    return [c for c in range(1, isqrt(m) + 1) if m % (c * c) == 0]


def phi(basis):
    """Phi(L) = (c, (1/c) L), c = e1(L), in exact Hermite coordinates:

        ((a,0),(b,d))  |->  (c, ((a/c, 0), (b/c, d/c))).

    The corner b/c needs NO mod-(d/c) reduction: c | b, c | d and
    0 <= b < d force b <= d - c, so 0 <= b/c <= d/c - 1 (note, Lemma 2).
    The assert replays that lemma on every call."""
    (a, z), (b, d) = basis
    if z != 0 or a < 1 or d < 1 or not 0 <= b < d:
        raise ValueError("phi needs a Hermite basis ((a,0),(b,d))")
    c = gcd(gcd(a, b), d)
    a1, b1, d1 = a // c, b // c, d // c
    assert b1 % d1 == b1, basis  # mod-reduction is the identity (Lemma 2)
    return c, ((a1, 0), (b1, d1))


def phi_inverse(c, basis):
    """Phi^{-1}(c, L') = c L': ((a',0),(b',d')) |-> ((ca',0),(cb',cd')),
    again already in Hermite form since 0 <= cb' < cd'."""
    (a, z), (b, d) = basis
    if z != 0 or c < 1 or a < 1 or d < 1 or not 0 <= b < d:
        raise ValueError("phi_inverse needs c >= 1 and a Hermite basis")
    return ((c * a, 0), (c * b, c * d))


def assembly_fibers(m):
    """dict c -> list of Phi-images (cyclic index-(m/c^2) Hermite bases)
    of the label-c stratum of the index-m sublattice space.  The note
    proves each list enumerates {cyclic index-(m/c^2) bases} without
    repetition and that the keys are exactly {c : c^2 | m}."""
    fibers = {}
    for basis in hnf_bases(m):
        c, image = phi(basis)
        fibers.setdefault(c, []).append(image)
    return fibers


def second_moment(m):
    """S(m) = sum of e1(L) over index-m sublattices, direct enumeration."""
    return sum(label(basis) for basis in hnf_bases(m))


def second_moment_bijective(m):
    """S(m) = sum_{c^2|m} c psi(m/c^2): transport of e1 along Phi."""
    return sum(c * psi(m // (c * c)) for c in square_divisors(m))


def euler_phi(n):
    """Euler's totient, exactly."""
    result, x, p = n, n, 2
    while p * p <= x:
        if x % p == 0:
            result -= result // p
            while x % p == 0:
                x //= p
        p += 1
    if x > 1:
        result -= result // x
    return result


def second_moment_totient(m):
    """S(m) = sum_{c^2|m} euler_phi(c) sigma_1(m/c^2): the layer-cake
    form via e1 = sum_{c | e1} euler_phi(c) and the homothety strata."""
    return sum(euler_phi(c) * sigma1(m // (c * c)) for c in square_divisors(m))


def factorize(m):
    """Prime factorization [(p, k), ...] of m >= 1, exactly."""
    out, p = [], 2
    while p * p <= m:
        if m % p == 0:
            k = 0
            while m % p == 0:
                m //= p
                k += 1
            out.append((p, k))
        p += 1
    if m > 1:
        out.append((m, 1))
    return out


def second_moment_prime_power(p, k):
    """S(p^k) = (p^{k+1} + p^k - p^{ceil(k/2)} - p^{floor(k/2)})/(p-1),
    an exact integer (numerator divisible by p-1)."""
    num = p ** (k + 1) + p ** k - p ** ((k + 1) // 2) - p ** (k // 2)
    assert num % (p - 1) == 0
    return num // (p - 1)


def second_moment_closed(m):
    """S(m) by multiplicativity and the prime-power closed form."""
    out = 1
    for p, k in factorize(m):
        out *= second_moment_prime_power(p, k)
    return out


def gamma_dot(gamma, basis):
    """Hermite basis of gamma . L = (gamma M) Z^2 (ambient left action)."""
    return hermite_reduce(mat_mul(gamma, basis))


def unimodular_window(bound):
    """All gamma in SL_2(Z) with entries in [-bound, bound]."""
    rng = range(-bound, bound + 1)
    return [
        ((a, b), (c, d))
        for a in rng
        for b in rng
        for c in rng
        for d in rng
        if a * d - b * c == 1
    ]


def stratum_base_point(m, c):
    """Hermite basis of c . (Z + (m/c^2) Z), the base point of the
    label-c stratum: ((c, 0), (0, c * m/c^2)).  Requires c^2 | m."""
    if m % (c * c) != 0:
        raise ValueError("stratum_base_point needs c^2 | m")
    return ((c, 0), (0, c * (m // (c * c))))


def stratum_orbit_witness(basis):
    """A determinant-one gamma with gamma . base_point = L, where
    base_point = stratum_base_point(index, label): R0034's transitivity
    witness for (1/c)L on the cyclic stratum also works for L, since
    gamma . (c L0') = c (gamma . L0') (scaling commutes with gamma)."""
    _, image = phi(basis)
    return transitivity_witness(image)
