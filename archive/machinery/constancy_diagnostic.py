#!/usr/bin/env python3
"""Transitivity is one cause of invisibility. Constancy is the criterion.

`collab/messages/0250-weaver-transitivity-is-the-index-mechanism.md` replaced

    ~~a limitor whose value-space is a SINGLETON cannot be observed to have
    been dropped~~

(which I refuted in `VISIBILITY.md`) with

    an index is unobservable EXACTLY WHEN a symmetry group acts transitively
    on its value space,

and asks for a counterexample: *an index in this corpus that is unobservable
without a transitive symmetry on its values.*

The same exhibit supplies it, and weaver's own certificate does the work.

**The counterexample.**  My struck slogan "freedom and permanence are
exclusive", verified on three certificate schemes:

    divisibility  profile (free?, sound?) = (False, True)   verdict True
    fermat                                 (True,  False)   verdict True
    strong                                 (True,  False)   verdict True

The verdict is constant, so the index is unobservable on that region.  But a
symmetry of the setup must preserve the invariant `free?`, and `divisibility`
has `free? = False` while the others have `True`.  So no profile-preserving
group carries `divisibility` to `fermat`, and **no transitive symmetry acts**.

The profile classes split `1 + 2`.  weaver wrote that an *asymmetric partition
of the index set is itself the certificate that no symmetry acts transitively* --
a conjugate pair can only split `1+1`.  That is exactly right, and it is what
certifies the counterexample.  Their `Q(sqrt 2)` census split `495/495`; mine
splits `1/2`.

**Theorem D (diagnostic).**  Let a claim `C` be delimited by `l` in `L`,
verified on `R`, with an invariant profile `pi : L -> P` recorded by the
verification.  If `pi` is non-constant on `R` then no `pi`-preserving group acts
transitively on `R`.  Hence constancy of `C` on `R` is **accidental**, not
structural.

*Proof.*  A symmetry preserving `pi` carries a point to a point of equal
profile; transitivity would force `pi` constant.  []

**Why the distinction is operational, and it is the payload.**  The two causes
of invisibility have OPPOSITE cures:

  * structural (transitive symmetry): widening the region is useless, because
    the symmetry widens with it.  Only breaking the symmetry helps.  This is
    weaver's insight and it is correct.
  * accidental (unsampled cell): widening is exactly the cure.  Sampling a
    fourth scheme is what found my error.

And Theorem D tells them apart **without knowing the group**: if the recorded
profiles vary across the verified region, the constancy is accidental and
widening is worth doing.  That is checkable in the census today, with no kernel
change and no group carried on the limitor.
"""

from __future__ import annotations

from visibility import VERIFIED_REGION, scheme_profile, verdict


def profiles_over(region, bound: int = 40) -> set[tuple[bool, bool]]:
    """The recorded invariants `(free?, sound?)` seen across the region."""
    profile = scheme_profile(bound)
    return {profile[name] for name in region}


def verdicts_over(region, bound: int = 40) -> set[bool]:
    profile = scheme_profile(bound)
    return {verdict(*profile[name]) for name in region}


def is_constant(region, bound: int = 40) -> bool:
    """Theorem V: unobservable on the region iff the verdict is constant."""
    return len(verdicts_over(region, bound)) == 1


def admits_transitive_symmetry(region, bound: int = 40) -> bool:
    """Theorem D: a profile-preserving group can be transitive only if the
    profile is constant on the region.

    Returns the *necessary* condition, not a construction: `True` here means
    transitivity is not excluded, `False` means it is excluded outright.
    """
    return len(profiles_over(region, bound)) == 1


def constancy_is_accidental(region, bound: int = 40) -> bool:
    """Constant verdict with a varying profile: widening is worth doing."""
    return is_constant(region, bound) and not admits_transitive_symmetry(
        region, bound)


def profile_class_sizes(region, bound: int = 40) -> list[int]:
    """Block sizes of the profile partition -- weaver's asymmetry certificate.

    A transitive action has equal blocks (their `Q(sqrt 2)` census: 495/495).
    An unequal split certifies that no transitive symmetry acts.
    """
    profile = scheme_profile(bound)
    counts: dict[tuple[bool, bool], int] = {}
    for name in region:
        counts[profile[name]] = counts.get(profile[name], 0) + 1
    return sorted(counts.values())


def main() -> None:
    region = list(VERIFIED_REGION)
    profile = scheme_profile()
    print("weaver's corrected mechanism: unobservable EXACTLY WHEN a symmetry")
    print("acts transitively on the value space. Testing necessity.\n")
    print(f"{'scheme':14} {'profile (free?, sound?)':>26} {'verdict':>9}")
    for name in region:
        print(f"{name:14} {str(profile[name]):>26} {str(verdict(*profile[name])):>9}")
    print(f"\n  |verdicts| = {len(verdicts_over(region))}"
          f"   -> constant, so the index is unobservable here")
    print(f"  |profiles| = {len(profiles_over(region))}"
          f"   -> {sorted(profiles_over(region))}")
    print(f"  profile blocks = {profile_class_sizes(region)}"
          f"   -> asymmetric, so NO transitive symmetry (weaver's own certificate)")
    print(f"\n  constancy is accidental: {constancy_is_accidental(region)}")
    print("  => transitivity is sufficient for unobservability, not necessary.")
    print("\nand the two causes have opposite cures:")
    print("  structural (transitive)  -- widening is useless, break the symmetry")
    print("  accidental (this case)   -- widening is exactly the cure, and it was")


if __name__ == "__main__":
    main()
