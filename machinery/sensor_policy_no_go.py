#!/usr/bin/env python3
"""The residue certificate leaves a sensor policy no freedom.

`arithmetic_life` certifies "n is prime" by finding no installed modulus below
the frontier that divides n.  The audit note ARITHMETIC_LIFE_ADVERSARIAL_AUDIT
observed (B3) that its sensor set is a function of the frontier alone and
called that a planted curriculum.  Theorem T5 below says the planting is not a
design accident: *no* selection policy can retain fewer senses and stay sound,
and the falsifier is always a prime square.

Nothing here is measured.  `falsify_policy` returns an exact counterexample or
a proof obligation discharged by T5, never a statistic.
"""

from __future__ import annotations

from math import isqrt
from typing import Callable, Iterable

Policy = Callable[[int], Iterable[int]]


def primes_through(bound: int) -> list[int]:
    """Irreducible moduli through ``bound``, by the machine's own skip test."""
    kept: list[int] = []
    for candidate in range(2, bound + 1):
        if not any(candidate % p == 0 for p in kept if p <= isqrt(candidate)):
            kept.append(candidate)
    return kept


def certifies_prime(active: Iterable[int], n: int) -> bool:
    """The residue certificate: no installed sense below the frontier divides n."""
    bound = isqrt(n)
    return all(n % m != 0 for m in active if m <= bound)


def falsify_policy(policy: Policy, frontier: int) -> tuple[int, int] | None:
    """Exhibit a false primality certificate, or ``None`` if the policy is complete.

    Returns ``(n, q)`` where the policy certifies the composite ``n = q*q`` as
    prime, ``q`` being an irreducible modulus the policy declined to install.

    Theorem T5.  Let ``A = policy(B)`` be the moduli active at frontier ``B``.
    The residue certificate is sound for every ``n`` with ``isqrt(n) <= B``
    exactly when ``A`` contains every prime ``<= B``.

    Proof.  (<=) If every prime ``q <= B`` is active, then a composite ``n``
    with ``isqrt(n) <= B`` has a prime factor ``q <= isqrt(n) <= B``, which is
    active and divides ``n``; the certificate is withheld.  (=>) Suppose a
    prime ``q <= B`` is not active and put ``n = q*q``, so ``isqrt(n) = q <= B``.
    Any active ``m <= q`` dividing ``q*q`` satisfies ``m in {1, q}``, and
    ``m >= 2``, ``m != q``; so no active sense divides ``n`` and the composite
    ``n`` is certified prime.  []

    The policy therefore has no degrees of freedom: the certificate form fixes
    the anatomy.  Sensor formation here is forced, not selected, so no policy
    -- however encounter-driven -- can be credited with discovering it.
    """
    active = sorted(policy(frontier))
    for q in primes_through(frontier):
        if q not in active:
            n = q * q
            assert certifies_prime(active, n), "T5 (=>) must produce a certificate"
            return n, q
    return None


def complete_policy(frontier: int) -> list[int]:
    """What `arithmetic_life` does: retain every irreducible sense below the frontier."""
    return primes_through(frontier)


def thrifty_policy(frontier: int) -> list[int]:
    """A plausible frugal alternative: keep only senses that ever found a factor.

    On the encounters 91, 97, 143 of the first-execution note, mod 2, 3 and 5
    never divided anything; a policy that retains only the senses which earned
    their keep would drop them.  T5 says the moment it does, it lies.
    """
    return [p for p in primes_through(frontier) if p in (7, 11, 13)]


def main() -> None:
    for name, policy in (("complete", complete_policy), ("thrifty", thrifty_policy)):
        witness = falsify_policy(policy, 20)
        if witness is None:
            print(f"{name:9} policy: no counterexample through frontier 20 (T5 <=)")
        else:
            n, q = witness
            print(f"{name:9} policy: certifies {n} = {q}*{q} as prime "
                  f"(mod {q} declined) (T5 =>)")


if __name__ == "__main__":
    main()
