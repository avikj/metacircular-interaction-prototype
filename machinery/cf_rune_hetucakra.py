"""Dignaga's hetucakra as exact finite mathematics — executed.

The Hetucakradamaru (c. 500 CE, Nalanda lineage) classifies a reason
(hetu) H offered for a thesis "the subject s has property P" by H's
incidence on two comparison classes:

    sapaksa  Sp = individuals other than s known to have P
    vipaksa  Vp = individuals other than s known to lack P

Presence of H in each class is graded all / none / some: nine cells.
Dignaga's classification: cells (all,none) and (some,none) are valid
(sadhaka); (none,all) and (none,some) are contradictory (viruddha —
they validly establish the NEGATION); the remaining five are
inconclusive (anaikantika), including the degenerate (none,none)
asadharana cell where the reason holds of the subject alone.

This script proves, by exhaustion over every finite world with
|W| <= 6, every subject, every P, and every H containing the subject
(paksadharmata, the first of the trairupya conditions):

  T1  The two valid cells are EXACTLY the configurations where
      vyapti holds on all observed cases (H\\{s} subset of P) and is
      non-vacuously instantiated (H meets Sp). The two contradictory
      cells are exactly the same condition for the negated thesis.
      Dignaga's trichotomy is sound and complete for closed finite
      worlds: no tenth cell, no misfiled configuration.

  T2  Duality: exchanging P with its complement (thesis with
      antithesis) transposes the wheel (cell (i,j) -> (j,i)), maps
      valid cells onto contradictory cells and back, and fixes the
      inconclusive set. The classification is exactly symmetric under
      negation — viruddha is not error but validity pointed the other
      way, which is how the tradition itself used it.

  T3  The asadharana cell (none,none — reason unique to the subject)
      is a fixed point of the duality. Its evidence is invariant under
      swapping the thesis with its negation, so no asymmetric
      conclusion is licensed: Dignaga's filing of it as inconclusive
      is forced by symmetry, not convention.

  T4  Empty-comparison-class boundary: when Sp is empty the wheel's
      row grades collapse (all = none, vacuously), so the instrument
      presupposes inhabited comparison classes. The tradition found
      this edge itself — theses like "all things are momentary" leave
      the sapaksa empty, and the later antarvyapti move (pervasion
      established within the subject class) is the repair. The script
      counts and quarantines these cases rather than misclassifying.

  T5  Apoha bridge (Dignaga's theory of concept formation by
      exclusion, anyapoha) — on the repo's own divisibility world:
      the class of a state under the future-behavior quotient
      (README; formal/pairfield FutureBehavior.lean) equals the class
      computed purely negatively, as what survives every witnessed
      exclusion. Concept-as-exclusion-boundary and
      concept-as-behavioral-equivalence are computed by two
      independent algorithms and agree on every state.

All checks are exhaustive and exact. Run: python3 <this file>.
"""

from itertools import product

# ---------------- the wheel ----------------
ALL, NONE, SOME = "all", "none", "some"

def grade(H, cls):
    """Incidence of H on a nonempty class: all / none / some."""
    inter = H & cls
    if inter == cls:
        return ALL
    if not inter:
        return NONE
    return SOME

# Dignaga's cells, (sapaksa grade, vipaksa grade) -> verdict.
VALID = {(ALL, NONE), (SOME, NONE)}            # cells 2 and 8
CONTRA = {(NONE, ALL), (NONE, SOME)}           # cells 4 and 6
CELLS = [(r, c) for r in (ALL, NONE, SOME) for c in (ALL, NONE, SOME)]

def classify(H, Sp, Vp):
    return grade(H, Sp), grade(H, Vp)

# ---------------- T1, T2, T3, T4: exhaustion ----------------
checked = boundary = 0
cell_counts = {c: 0 for c in CELLS}
for n in range(2, 7):
    W = frozenset(range(n))
    s = 0                                  # symmetry: subject WLOG fixed
    rest = W - {s}
    for P_bits in product((0, 1), repeat=n - 1):
        P = frozenset(x for x, b in zip(sorted(rest), P_bits) if b)
        Sp, Vp = P, rest - P
        for H_bits in product((0, 1), repeat=n - 1):
            H = frozenset({s} | {x for x, b in zip(sorted(rest), H_bits) if b})
            if not Sp or not Vp:
                # T4: the wheel needs inhabited comparison classes.
                boundary += 1
                continue
            checked += 1
            cell = classify(H, Sp, Vp)
            cell_counts[cell] += 1

            # T1: valid <=> vyapti on observed cases + instantiation
            vyapti = (H - {s}) <= Sp
            instantiated = bool(H & Sp)
            assert (cell in VALID) == (vyapti and instantiated), (H, Sp, Vp)
            anti_vyapti = (H - {s}) <= Vp
            anti_inst = bool(H & Vp)
            assert (cell in CONTRA) == (anti_vyapti and anti_inst)

            # T2: negating the thesis transposes the wheel
            dual = classify(H, Vp, Sp)
            assert dual == (cell[1], cell[0])
            assert (cell in VALID) == (dual in CONTRA)

            # T3: asadharana is a duality fixed point
            if cell == (NONE, NONE):
                assert dual == cell

print("T1 wheel sound+complete on %d configurations (|W| <= 6): OK" % checked)
print("T2 negation-duality transposes the wheel everywhere: OK")
print("T3 asadharana (reason unique to subject) is duality-fixed,")
print("   so its 'inconclusive' verdict is forced by symmetry: OK")
print("T4 %d empty-comparison-class cases quarantined (antarvyapti" % boundary)
print("   boundary — the tradition's own edge case, kept visible): OK")
assert all(v > 0 for v in cell_counts.values())
print("   every one of the nine cells is inhabited — no dead cell")

# ---------------- T5: apoha = behavioral quotient ----------------
# World: remainders mod m under digit actions r -> (2r+d) mod m,
# observation: divisibility (r == 0). The README's arithmetic world.
def apoha_vs_quotient(m):
    states = list(range(m))
    step = lambda r, d: (2 * r + d) % m
    obs = lambda r: r == 0

    # (i) POSITIVE construction: partition refinement to a fixed point
    # (future-behavior quotient, Myhill-Nerode style).
    part = {}
    for r in states:
        part[r] = obs(r)
    while True:
        sig = {r: (part[r], part[step(r, 0)], part[step(r, 1)])
               for r in states}
        relabel = {v: i for i, v in enumerate(sorted(set(sig.values()),
                                                     key=repr))}
        new = {r: relabel[sig[r]] for r in states}
        if len(set(new.values())) == len(set(part.values())):
            break
        part = new
    quotient_class = {r: frozenset(x for x in states if part[x] == part[r])
                      for r in states}

    # (ii) NEGATIVE construction (anyapoha): a state's concept is what
    # remains after every witnessed exclusion. Two states exclude each
    # other iff some digit word separates their observations; that
    # relation is the least fixed point of "observably different now,
    # or some action leads to an excluded pair" on the product world —
    # each separated pair carries a concrete finite witness word, so
    # this is still exclusion-by-witness, computed without
    # enumerating the exponential word space.
    sep = {(r, x) for r in states for x in states if obs(r) != obs(x)}
    changed = True
    while changed:
        changed = False
        for r in states:
            for x in states:
                if (r, x) not in sep and any(
                        (step(r, d), step(x, d)) in sep for d in (0, 1)):
                    sep.add((r, x))
                    changed = True
    excluded = {r: {x for x in states if (r, x) in sep} for r in states}
    apoha_class = {r: frozenset(x for x in states if x not in excluded[r])
                   for r in states}

    return quotient_class == apoha_class

for m in range(1, 25):
    assert apoha_vs_quotient(m), m
print("T5 apoha class == future-behavior class for every state,")
print("   all moduli 1..24, two independent algorithms: OK")

print("ALL CHECKS PASSED — the wheel is a theorem and apoha is the quotient")
