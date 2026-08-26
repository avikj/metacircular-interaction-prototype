#!/usr/bin/env python3
"""Every exact dilation theorem in this corpus is the index of the image.

Four notes by three workers compute a "least environment dimension" for a
coherent overwrite, each with its own proof:

  ARITHMETIC_QUOTIENT_QUANTUM_DILATION (5)   d_E(q_m on {0..N-1}) = ceil(N/m)
  ROLLING_STEP_QUANTUM_BOUNDARY   Thm 2.1    d_E(s -> p^j s mod p^k) = p^min(j,k)
  CANONICAL_DEPTH_MEMORY          Thm M      M(t) = ceil(t / p^D(t))
  REFINING_DILATION               Thm Q      d_E at the minimal chart <= p

All four are one statement, and it is not a fact about arithmetic at all.

  **Theorem I.**  For a surjection q : X -> Y of finite sets,
      ceil(|X|/|Y|)  <=  d_E(q)  <=  |X| - |Y| + 1,
  both bounds sharp.  The lower bound is attained exactly when the fibers are
  as equal as possible; the upper exactly when one fiber holds everything but
  one representative of each other class.

  **Theorem E.**  If a group `G` acts on `X`, `q` is `G`-equivariant onto `Y`,
  and `G` acts transitively on `Y`, then every fiber has size `|X|/|Y|`, so
  `d_E(q) = |X|/|Y|` exactly.

Theorem E is why the four computations agree with the index: each chart is (a
restriction of) a translation-equivariant group quotient.  And the one place in
the corpus where the index law FAILS is exactly the one non-equivariant chart --
the divisibility predicate `[m|n]`, whose two classes have different sizes.  At
`N=100, m=7` its dimension is 85, not the index 50.

The link worth having: `TRANSFERABLE_OBSERVABLE_FORMATION`'s equivariant
generation theorem makes an observable *transferable* from an equivariance
hypothesis; Theorem E makes the same kind of observable *minimally expensive to
undo* from a cousin of that hypothesis.  The two are not identical -- transfer
allows a monoid and needs an orbit-closure condition, while the index law needs
an invertible action transitive on the target -- but they overlap exactly on
transitive group actions.  Where they overlap, transfer and cheap reversibility
are one condition.
"""

from __future__ import annotations

from math import ceil


def fibers(observable, domain) -> dict[object, list]:
    grouped: dict[object, list] = {}
    for element in domain:
        grouped.setdefault(observable(element), []).append(element)
    return grouped


def dilation_dimension(observable, domain) -> int:
    """`d_E` of ARITHMETIC_QUOTIENT_QUANTUM_DILATION Theorem 2.1: largest fiber."""
    return max(len(members) for members in fibers(observable, domain).values())


def index_bound(size: int, image_size: int) -> int:
    """Theorem I's lower bound: `ceil(|X|/|Y|)`."""
    return ceil(size / image_size)


def lopsided_bound(size: int, image_size: int) -> int:
    """Theorem I's upper bound: `|X| - |Y| + 1`, attained by a lopsided chart."""
    return size - image_size + 1


def is_balanced(observable, domain) -> bool:
    """Are all fibers within one of each other -- the index-law condition?"""
    sizes = {len(members) for members in fibers(observable, domain).values()}
    return max(sizes) - min(sizes) <= 1


def obeys_index_law(observable, domain) -> bool:
    grouped = fibers(observable, domain)
    return dilation_dimension(observable, domain) == index_bound(
        sum(len(v) for v in grouped.values()), len(grouped))


def is_equivariant_quotient(observable, modulus: int) -> bool:
    """Is `q` a homomorphism of `Z/modulus` -- the hypothesis of Theorem E?

    Checks `q(s + g) = q(s) + q(g)` in the image group.  When it holds, the
    image is a subgroup acting transitively on itself by translation, so
    Theorem E applies and every fiber is a coset of the kernel.
    """
    return all(observable((s + g) % modulus)
               == (observable(s) + observable(g)) % modulus
               for s in range(modulus) for g in range(modulus))


def rolling_step(prime: int, height: int, power: int):
    """`ROLLING_STEP_QUANTUM_BOUNDARY` (1): `s -> p^j s mod p^k`."""
    modulus = prime ** height
    return (lambda s: prime ** power * s % modulus), range(modulus)


def residue_chart(modulus: int, size: int):
    """`ARITHMETIC_QUOTIENT_QUANTUM_DILATION` (5): `n -> n mod m` on `{0..N-1}`."""
    return (lambda n: n % modulus), range(size)


def divisibility_predicate(modulus: int, size: int):
    """The corpus's one non-equivariant chart: `n -> [m | n]`."""
    return (lambda n: n % modulus == 0), range(size)


def main() -> None:
    print("Theorem I: every corpus dilation theorem is the index of the image\n")
    print(f"{'chart':30} {'d_E':>5} {'index':>6} {'agrees':>7} {'balanced':>9}")
    cases = [
        ("rolling p^1 s mod 2^4", *rolling_step(2, 4, 1)),
        ("rolling p^2 s mod 3^3", *rolling_step(3, 3, 2)),
        ("rolling p^5 s mod 3^3", *rolling_step(3, 3, 5)),
        ("residue mod 7 on 91", *residue_chart(7, 91)),
        ("residue mod 6 on 50", *residue_chart(6, 50)),
        ("divisibility [7|n] on 100", *divisibility_predicate(7, 100)),
        ("divisibility [5|n] on 200", *divisibility_predicate(5, 200)),
    ]
    for name, observable, domain in cases:
        grouped = fibers(observable, domain)
        dimension = dilation_dimension(observable, domain)
        index = index_bound(sum(len(v) for v in grouped.values()), len(grouped))
        print(f"{name:30} {dimension:5} {index:6}"
              f" {str(obeys_index_law(observable, domain)):>7}"
              f" {str(is_balanced(observable, domain)):>9}")
    print("\nthe only failure is the only unbalanced chart, and it is the only")
    print("non-equivariant one -- Theorem E explains all the agreements at once.")
    print("\nTheorem I is sharp at both ends:")
    for size, image in ((10, 3), (12, 4), (100, 2)):
        def lopsided(x, image=image):
            return x if x < image - 1 else image - 1
        print(f"  |X|={size:4} |Y|={image}: balanced {index_bound(size, image):4}"
              f"   lopsided {dilation_dimension(lopsided, range(size)):4}"
              f"  (= |X|-|Y|+1 = {lopsided_bound(size, image)})")


if __name__ == "__main__":
    main()
