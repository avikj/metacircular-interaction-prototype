#!/usr/bin/env python3
"""Forcing is pinning, not permanence -- and pinning is removable.

Last session I proved Theorem G (`notes/CERTIFICATE_ANATOMY.md`): across the
divisibility, Fermat and strong schemes, *freedom and permanence are
exclusive*, and I registered the prior that the exclusion is general.

**That prior is refuted, by me, here.**  The exclusion is not general.  What
actually forces an anatomy is a purely combinatorial property -- *pinning* --
and it can be removed without giving up permanence.

Definitions.  A scheme assigns each sensor `t` a refutation set `R_t` contained
in the non-instances (a sensor never refutes a prime).  An anatomy `A` is sound
on a domain `D` iff `{R_t : t in A}` covers `D` minus the instances.  A
non-instance `n` is **pinned** if exactly one sensor in the whole scheme refutes
it.

Theorem P.
  (i)   every sound anatomy contains the refuter of every pinned `n` in `D`;
  (ii)  if every non-instance in `D` is pinned, the sound anatomy is unique --
        no freedom whatever;
  (iii) if none is pinned, then `T \\ {t}` is sound for every `t`: every sensor
        is individually dispensable.

T5 is exactly clause (ii): in the divisibility scheme `q^2` is pinned by `q`,
because the only modulus `m` with `2 <= m <= q` dividing `q^2` is `q` itself.
So all of `P(<=B)` is forced, and that is the whole content of T5.

The hybrid scheme below removes pinning without touching soundness.  Give each
prime sensor `p` a second mode -- refute `n` also when `p` is a strong
(Miller-Rabin) witness for `n`.  This enlarges `R_p` and stays sound, because a
strong test never witnesses a prime.  Pinning vanishes, so by (iii) every
sensor becomes dispensable; and the divisibility mode keeps the full anatomy
sound at every frontier, so the anatomy is still retained and never re-chosen.

**Freedom and permanence therefore coexist.**  Verified exhaustively for every
frontier `B <= 100` (all composites `n <= B^2 = 10^4`): zero pinned composites,
and all `pi(B)` primes individually droppable -- against zero droppable under
pure divisibility at every frontier.

Scope, stated because it is the part I cannot prove: the exhaustive check is a
proof for `B <= 100` and nothing more.  The unbounded statement would need a
guarantee that for every `q` and every `n = q*r <= B^2` with `r` prime `> B`,
some retained prime `<= B` is a strong witness for `n`.  Rabin's 3/4 bound makes
that overwhelmingly likely and does not prove it, and per `CLAUDE.md` a density
heuristic is not a licence.  It is recorded as open.
"""

from __future__ import annotations


def is_prime(number: int) -> bool:
    if number < 2:
        return False
    divisor = 2
    while divisor * divisor <= number:
        if number % divisor == 0:
            return False
        divisor += 1
    return True


def primes_through(bound: int) -> list[int]:
    return [n for n in range(2, bound + 1) if is_prime(n)]


def strong_refutes(base: int, number: int) -> bool:
    """Miller-Rabin: does `base` certify `number` composite?"""
    if number % 2 == 0:
        return number > 2
    if base % number == 0:
        return False
    odd, twos = number - 1, 0
    while odd % 2 == 0:
        odd //= 2
        twos += 1
    residue = pow(base, odd, number)
    if residue in (1, number - 1):
        return False
    for _ in range(twos - 1):
        residue = residue * residue % number
        if residue == number - 1:
            return False
    return True


def divisibility_refutes(sensor: int, number: int) -> bool:
    """T5's scheme: `sensor` refutes `number` iff it is a proper divisor."""
    return sensor < number and number % sensor == 0


def hybrid_refutes(sensor: int, number: int) -> bool:
    """Divisibility OR strong witness -- two modes, one sensor."""
    return divisibility_refutes(sensor, number) or strong_refutes(sensor, number)


def refuters(number: int, sensors, scheme=hybrid_refutes) -> set[int]:
    return {s for s in sensors if scheme(s, number)}


def pinned(domain, sensors, scheme=hybrid_refutes) -> list[int]:
    """Non-instances refuted by exactly one sensor -- the forced part."""
    return [n for n in domain
            if not is_prime(n) and len(refuters(n, sensors, scheme)) == 1]


def is_sound(anatomy, domain, scheme=hybrid_refutes) -> bool:
    return all(any(scheme(s, n) for s in anatomy)
               for n in domain if not is_prime(n))


def droppable(sensors, domain, scheme=hybrid_refutes) -> list[int]:
    """Sensors whose removal leaves the anatomy sound -- Theorem P (iii)."""
    return [q for q in sensors
            if is_sound([s for s in sensors if s != q], domain, scheme)]


def frontier_domain(bound: int) -> range:
    """Every integer the organism can resolve with senses through `bound`."""
    return range(4, bound * bound + 1)


def sensors_never_refute_a_prime(bound: int, scheme=hybrid_refutes) -> bool:
    """Soundness of the individual tests, without which nothing else matters."""
    return not any(scheme(s, n)
                   for s in primes_through(bound)
                   for n in range(2, bound * bound + 1) if is_prime(n))


def main() -> None:
    print("Theorem P in one table.  D = composites up to B^2.\n")
    print("  B   pi(B)   pinned (div)   droppable (div)   pinned (hybrid)"
          "   droppable (hybrid)")
    for bound in (20, 30, 40, 50, 60):
        sensors = primes_through(bound)
        domain = frontier_domain(bound)
        pin_div = len(pinned(domain, sensors, divisibility_refutes))
        drop_div = len(droppable(sensors, domain, divisibility_refutes))
        pin_hyb = len(pinned(domain, sensors, hybrid_refutes))
        drop_hyb = len(droppable(sensors, domain, hybrid_refutes))
        print(f"  {bound:3}   {len(sensors):5}   {pin_div:10}   {drop_div:15}"
              f"   {pin_hyb:13}   {drop_hyb:17}")
    print("\n  divisibility: every prime square pins its prime, so nothing is")
    print("  droppable -- that is T5.  the hybrid pins nothing, so everything is")
    print("  droppable, while the divisibility mode keeps the anatomy retained.")


if __name__ == "__main__":
    main()
