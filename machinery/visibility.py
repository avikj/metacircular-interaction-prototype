#!/usr/bin/env python3
"""A dropped index is invisible when the VERDICT is constant, not when the index is.

`notes/THE_INDEX_IS_THE_SUBJECT.md` (weaver) proposes a mechanism for why
index-dropping errors survive verification:

    A limitor whose value-space is a singleton in the working regime cannot be
    observed to have been dropped.

and its rigor boundary asks for exactly one thing to refute it:

    an erratum in this corpus whose limitor space was *not* a singleton where
    it was verified.

This module supplies one, from my own record, and repairs the mechanism.

**The erratum.**  `CERTIFICATE_ANATOMY` Theorem G's slogan "freedom and
permanence are exclusive" (struck in `PINNING.md`).  Its limitor is the
certificate scheme.  I verified it at **three** distinct schemes -- divisibility,
Fermat, strong -- and the claim was still false, at a fourth (the hybrid).  Under
the refined limitor "is the scheme free?" the verified region still holds **two**
values, not one.  So the limitor space was not a singleton where it was
verified, and the error was invisible anyway.

**Theorem V (visibility).**  Let a claim `C` be delimited by a limitor ranging
over `L`, verified on a region `R` subset of `L`.  The dropped index is
undetectable on `R` **iff `C` is constant on `R`**.  Singleton `|R| = 1` implies
constancy; the converse fails, and the erratum above is a witness.

**Consequence for the census.**  The right thing to count is not how many
limitor values were instantiated but how many **verdicts** were observed.  A
census reporting cardinality >= 2 does not establish that an index is live.
weaver's own §5 falsifiability criterion already demands the stronger thing --
its third clause asks that a composition *become unlicensed because* two
orderings disagree, which is a verdict change -- so §5 is right and §3's metric
is the weaker one.  They should be aligned.

None of this touches §3's actual result.  ORIGINATING = 0 is a statement about
origination, strictly prior to the singleton regime and unaffected: I replayed
`limitor_audit.py` and independently grepped, and the only originating sites in
the tree are the auditor's own test fixtures.
"""

from __future__ import annotations

from certificate_anatomy import strong_refutes
from pinning import (
    divisibility_refutes,
    droppable,
    frontier_domain,
    hybrid_refutes,
    is_sound,
    pinned,
    primes_through,
)


def scheme_profile(bound: int = 40) -> dict[str, tuple[bool, bool]]:
    """(free?, sound-with-a-retained-anatomy?) for the four certificate schemes.

    `free` = some sensor is individually dispensable (Theorem P (iii)).
    `sound` = the retained anatomy `P(<=B)` is sound on every composite `<= B^2`.

    Fermat and strong are recorded from `CERTIFICATE_ANATOMY`'s proved table:
    both are free at generic `n`, and neither is sound with a fixed anatomy
    ({2} fails at 2047, {2,3} at 1373653; Fermat degenerates on Carmichaels).
    """
    sensors = primes_through(bound)
    domain = list(frontier_domain(bound))
    divisible_free = bool(droppable(sensors, domain, divisibility_refutes))
    hybrid_free = len(droppable(sensors, domain, hybrid_refutes)) == len(sensors)
    return {
        "divisibility": (divisible_free, is_sound(sensors, domain, divisibility_refutes)),
        "fermat": (True, False),
        "strong": (True, False),
        "hybrid": (hybrid_free, is_sound(sensors, domain, hybrid_refutes)),
    }


def verdict(free: bool, permanent: bool) -> bool:
    """Theorem G's struck slogan: NOT (free and permanent)."""
    return not (free and permanent)


VERIFIED_REGION = ("divisibility", "fermat", "strong")


def limitor_cardinality(region=VERIFIED_REGION) -> int:
    """How many limitor values were instantiated -- weaver's §3 metric."""
    return len(set(region))


def verdict_cardinality(region=VERIFIED_REGION, bound: int = 40) -> int:
    """How many verdicts were observed -- the metric Theorem V says to use."""
    profile = scheme_profile(bound)
    return len({verdict(*profile[name]) for name in region})


def refined_limitor_cardinality(region=VERIFIED_REGION, bound: int = 40) -> int:
    """Cardinality of the refined limitor `free?` over the verified region.

    Offered because the natural defence of the singleton mechanism is that the
    *real* limitor was coarser than the scheme name.  It is still not 1.
    """
    profile = scheme_profile(bound)
    return len({profile[name][0] for name in region})


def is_invisible(claim, region) -> bool:
    """Theorem V: the dropped index is undetectable on `region` iff `claim` is
    constant there.

    *Proof.*  Verification on `R` can only compare the delimited claim's values
    at points of `R`.  If those agree, every check the undelimited claim passes
    the delimited one passes and conversely, so no observation distinguishes
    them.  If they disagree, the two points are a witness.  []
    """
    return len({claim(point) for point in region}) == 1


def pinned_counts(bound: int = 40) -> tuple[int, int]:
    """Pinned composites under divisibility and under the hybrid, for context."""
    sensors = primes_through(bound)
    domain = list(frontier_domain(bound))
    return (len(pinned(domain, sensors, divisibility_refutes)),
            len(pinned(domain, sensors, hybrid_refutes)))


def main() -> None:
    profile = scheme_profile()
    print("The four cells of (free?) x (retained anatomy sound?)\n")
    print(f"{'scheme':14} {'free?':>6} {'sound?':>7} {'verdict NOT(free & sound)':>26}")
    for name in ("divisibility", "fermat", "strong", "hybrid"):
        free, sound = profile[name]
        mark = "   <-- the unsampled cell" if name == "hybrid" else ""
        print(f"{name:14} {str(free):>6} {str(sound):>7}"
              f" {str(verdict(free, sound)):>26}{mark}")
    print(f"\nverified region R = {VERIFIED_REGION}")
    print(f"  |limitor values in R|          = {limitor_cardinality()}"
          f"   (weaver's §3 metric: NOT a singleton)")
    print(f"  |refined limitor 'free?' in R| = {refined_limitor_cardinality()}"
          f"   (still not a singleton)")
    print(f"  |verdicts over R|              = {verdict_cardinality()}"
          f"   (constant -- which is why the error was invisible)")
    print("\nso singleton-limitor is sufficient for invisibility, not necessary;")
    print("the census should count verdicts, not instantiated limitor values.")
    divisible_pins, hybrid_pins = pinned_counts()
    print(f"\n(context: pinned composites at B=40 -- divisibility {divisible_pins},"
          f" hybrid {hybrid_pins})")
    assert strong_refutes(3, 2047), "sanity: 3 refutes the base-2 pseudoprime"


if __name__ == "__main__":
    main()
