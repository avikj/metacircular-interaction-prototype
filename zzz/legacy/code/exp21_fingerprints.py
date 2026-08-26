"""Experiment 21: FINITE-PLACE FINGERPRINTS OF THE FAMILY — three visibility
classes, and the first nontrivial Galois/BC lever.

ADELIC.md S1 ("Galois remark") noted that the BC symmetry group fixes every
sieve projection used so far, so class-field theory had no leverage.  The
family provides the missing object.  Measure, for each dressing a and each
level a/q, the spectral atoms  m_a(a/q) = |lim (1/X) sum a(n) e(an/q)|  and
the Galois-invariant (Ramanujan) projections (1/X) sum a(n) c_q(n):

    Lambda:      atoms mu(q)/phi(q) at every primitive a/q — visible to the
                 GALOIS-INVARIANT algebra (Ramanujan projections = mu(q));
    Lambda*chi3: Ramanujan projections ALL VANISH, but the individual atoms
                 at q=3 are nonzero (modulus sin(2pi/3) = 0.866) and are
                 PERMUTED by the Galois action a -> a*u — the character
                 sector is visible only to the non-invariant part of the BC
                 diagonal.  This is the first projection in this program
                 that the class-field action moves nontrivially;
    lambda, mu:  every atom vanishes (Davenport) — invisible at all levels.

So the protection/exposure duality (LIOUVILLE.md) refines to a three-level
finite-place hierarchy:  full visibility (Lambda) > Galois-twisted-only
(Lambda chi) > none (lambda, mu) — while at the archimedean place all four
display their zero spectra at full strength (exp6b/15/16/20).
"""
import numpy as np
from math import gcd
from pathlib import Path
from pairfield import sieve_lambda
from exp15_liouville import sieve_liouville
from exp16_mobius import sieve_mobius

NMAX = 2_000_000


def main():
    lam = sieve_lambda(NMAX)
    lio = sieve_liouville(NMAX)
    mob = sieve_mobius(NMAX)
    n = np.arange(NMAX + 1)
    chi = np.zeros(NMAX + 1)
    chi[n % 3 == 1] = 1.0
    chi[n % 3 == 2] = -1.0
    lamchi = lam * chi

    fields = [("Lambda", lam), ("Lambda*chi3", lamchi),
              ("lambda", lio), ("mu", mob)]
    mu_q = {1: 1, 2: -1, 3: -1, 4: 0, 5: -1, 6: 1, 7: -1, 8: 0, 9: 0, 10: 1}

    print("individual atoms |mean a(n) e(an/q)| (max over primitive a), and")
    print("Ramanujan projections mean a(n) c_q(n):\n")
    hdr = f"{'q':>3} " + "".join(f"{nm:>14} {'c_q proj':>9} " for nm, _ in fields)
    print(f"{'':>3} " + "".join(f"{nm:>14} {'(cq)':>9} " for nm, _ in fields))
    for q in [1, 2, 3, 4, 5, 6, 9]:
        row = f"{q:>3} "
        for nm, a in fields:
            atoms = []
            proj = 0.0
            for aa in range(q) if q == 1 else range(1, q):
                if gcd(aa, q) != 1 and q > 1:
                    continue
                z = np.mean(a[1:] * np.exp(2j * np.pi * aa * n[1:] / q))
                atoms.append(abs(z))
                proj += z.real
            if q == 1:
                z = np.mean(a[1:])
                atoms, proj = [abs(z)], z.real
            row += f"{max(atoms):>14.4f} {proj:>9.4f} "
        print(row)
    print(f"\npredictions:  Lambda atoms = 1/phi(q) *|mu(q)|, c_q proj = mu(q);")
    print("  Lambda*chi3: q=3 atom = sin(2pi/3) = 0.8660, c_q projections = 0;")
    print("  lambda, mu: everything 0.")

    # the Galois action moving the chi-atoms: u in (Z/3)^* = {1,2} sends the
    # atom at 1/3 to the atom at 2/3; for Lambda these are equal (invariant),
    # for Lambda*chi3 they differ by chi(2) = -1: measure both.
    print("\nGalois orbit at level 3 (atom values, complex):")
    for nm, a in [("Lambda", lam), ("Lambda*chi3", lamchi)]:
        z1 = np.mean(a[1:] * np.exp(2j * np.pi * 1 * n[1:] / 3))
        z2 = np.mean(a[1:] * np.exp(2j * np.pi * 2 * n[1:] / 3))
        print(f"  {nm:>12}:  atom(1/3) = {z1:+.4f},  atom(2/3) = {z2:+.4f}"
              f"   ratio = {z2/z1 if abs(z1)>1e-6 else float('nan'):+.3f}")
    print("\nLambda: Galois-fixed (ratio +1).  Lambda*chi3: Galois moves the atom")
    print("by chi(2) = -1 — the class-field action acts nontrivially on the")
    print("character sector's BC projection: the lever ADELIC.md S1 said was missing.")


if __name__ == "__main__":
    main()
