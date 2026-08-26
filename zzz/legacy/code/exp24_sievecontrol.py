"""Experiment 24: SIEVE-CIRCUIT CONTROL RUN ON THE FAMILY — closing INDEX
join #3, and refining the visibility hierarchy.

Sibling LENS_CIRCUIT.md formalizes SIEVE_d(S,Q): by CRT normal form
(their Lemma 1.3) every depth-2 sieve circuit is a union of residue classes
mod its lcm L.  So the BEST correlation any sieve circuit of lcm L can
achieve against a dressing a is computable exactly:

    adv_a(L) = max_{C in SIEVE_2(*, L)} [ mean(a * 1_C) - mean(a) mean(1_C) ]
             = sum_c max( d_a(L,c), 0 ),
    d_a(L,c) = (1/X) sum_{n<=X, n=c (L)} a(n)  -  (1/L) mean(a)

(the optimal circuit takes exactly the positively-biased classes).

Predictions:
    Lambda:       adv = 1 - phi(L)/L      (fully sieve-visible; SW densities)
    Lambda*chi3:  adv = 1/2 if 3 | L, else ~0
                  — sieve LITERALS see the character sector that the
                  Galois-invariant (Ramanujan) probes of exp21 miss:
                  the sieve-visible boundary is finer than the
                  Galois-invariant boundary;
    lambda, mu:   adv ~ 0 for every L — the protected (atomless) class,
                  the objects of the sibling's lambda-orthogonality
                  theorems (their Theorems 1/1''), here measured as a
                  uniform noise floor.

So the three-level hierarchy of exp21 refines to FOUR probe algebras:
Ramanujan (Galois-invariant) < sieve literals < all additive characters,
with Lambda visible to all, Lambda*chi visible from literals up, lambda/mu
visible to none.  The pure fields are exactly the fixed points of the
sibling's SIEVE calculus — their control objects, as promised.
"""
import numpy as np
from math import gcd
from pathlib import Path
from pairfield import sieve_lambda
from exp15_liouville import sieve_liouville
from exp16_mobius import sieve_mobius

NMAX = 2_000_000


def phi(L):
    return sum(1 for c in range(1, L + 1) if gcd(c, L) == 1)


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

    print("best depth-2 sieve-circuit correlation adv_a(L) (exact over the class,")
    print("via CRT normal form), measured vs predicted:\n")
    print(f"{'L':>3} | {'Lambda':>8} {'pred':>7} | {'L*chi3':>8} {'pred':>6} | "
          f"{'lambda':>8} | {'mu':>8}")
    for L in [2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 30]:
        row = f"{L:>3} |"
        preds = {"Lambda": 1 - phi(L) / L,
                 "Lambda*chi3": 0.5 if L % 3 == 0 else 0.0}
        for nm, a in fields:
            am = a[1:].mean()
            d = np.array([a[1:][n[1:] % L == c].sum() / NMAX - am / L
                          for c in range(L)])
            adv = d[d > 0].sum()
            if nm in preds:
                row += f" {adv:8.4f} {preds[nm]:>6.3f} |"
            else:
                row += f" {adv:8.4f}"
                row += " |" if nm == "lambda" else ""
        print(row)

    print("\nfloor check: lambda/mu advantages are noise at the (XL)^{-1/2}-per-class "
          "scale summed over positive classes (audit-corrected from X^{-1/2}).")
    print("Lambda*chi3 at 3|L: constant 1/2 independent of L — the character")
    print("sector is one literal deep; at 3∤L it drops to the noise floor.")


if __name__ == "__main__":
    main()
