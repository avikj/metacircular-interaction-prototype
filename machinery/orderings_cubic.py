"""Where a form CAN have three different verdicts, and why zeta objects cannot.

Answers the closing question of collab/messages/0112-cf-retraction: which
fields with r1 > 1 could carry a genuine multi-cone phenomenon?  cf's stated
obstruction was that zeta_K = zeta * L splits quadratic K into Q-objects.  The
real obstruction is stronger and has nothing to do with splitting:

    If K/Q is GALOIS, Gal(K/Q) acts transitively on the real embeddings, so
    all r1 orderings are conjugate.  Any object canonically built from K -- in
    particular anything built from zeta_K, which does not see a choice of
    embedding -- is Gal-invariant, hence has the SAME verdict at every
    ordering.  On Galois-invariant objects, positive and totally positive
    coincide, and the multi-cone phenomenon is invisible by symmetry.

So the quadratic case was never going to work, and neither is any Galois one.
The obstruction vanishes exactly when Aut(K/Q) is too small to permute the
embeddings: the smallest such field is a totally real NON-Galois cubic.

This file exhibits one, exactly, with Sturm sequences over Q -- no floats, no
root approximation, every sign decided by an integer comparison.

Run: python3 machinery/orderings_cubic.py
Companion to machinery/orderings.py and notes/POSITIVITY_HAS_A_PLACE.md.
"""
from fractions import Fraction as F

# ---------------------------------------------------------------- polynomials
# A polynomial is a list of Fraction coefficients, lowest degree first.

def trim(p):
    while p and p[-1] == 0: p.pop()
    return p

def peval(p, x):
    v = F(0)
    for c in reversed(p): v = v * x + c
    return v

def pderiv(p):
    return [p[i] * i for i in range(1, len(p))]

def prem(a, b):
    """Remainder of a by b, exactly, over Q."""
    a = list(a)
    db = len(b) - 1
    while len(a) - 1 >= db and trim(a):
        s = a[-1] / b[-1]
        shift = len(a) - 1 - db
        for i, c in enumerate(b):
            a[i + shift] -= s * c
        trim(a)
    return a

def sturm_chain(p):
    """Standard Sturm sequence: p, p', then negated remainders."""
    chain = [list(p), pderiv(p)]
    while len(chain[-1]) > 1:
        r = prem(chain[-2], chain[-1])
        if not r: break
        chain.append([-c for c in r])
    return chain

def sign_changes(chain, x):
    s = [peval(q, x) for q in chain]
    s = [1 if v > 0 else (-1 if v < 0 else 0) for v in s]
    s = [v for v in s if v != 0]
    return sum(1 for i in range(len(s) - 1) if s[i] != s[i + 1])

def count_roots(chain, a, b):
    """Number of distinct real roots in (a, b].  Sturm's theorem, exact."""
    return sign_changes(chain, a) - sign_changes(chain, b)

def isolate(p, lo, hi, want):
    """Bisect until each root of p in (lo,hi] sits alone in a rational
    interval.  Returns `want` disjoint intervals with exact Fraction ends."""
    chain = sturm_chain(p)
    todo = [(F(lo), F(hi))]
    done = []
    while todo:
        a, b = todo.pop()
        n = count_roots(chain, a, b)
        if n == 0: continue
        if n == 1:
            done.append((a, b)); continue
        m = (a + b) / 2
        todo.append((a, m)); todo.append((m, b))
    assert len(done) == want, "expected %d real roots, isolated %d" % (want, len(done))
    return sorted(done)

def refine_off_zero(p, iv):
    """Shrink an isolating interval until both endpoints have the same sign,
    which decides the sign of the root it contains -- exactly."""
    chain = sturm_chain(p)
    a, b = iv
    while not (a > 0 or b < 0):
        m = (a + b) / 2
        if peval(p, m) == 0:
            raise ValueError("rational root: the field is not a cubic field")
        a, b = (a, m) if count_roots(chain, a, m) == 1 else (m, b)
    return (a, b), (1 if a > 0 else -1)

# ----------------------------------------------------------------- the field
# f = x^3 - 4x - 1.  Discriminant of x^3 + px + q is -4p^3 - 27q^2.
P, Q = F(-4), F(-1)
F_POLY = [Q, P, F(0), F(1)]
DISC = -4 * P**3 - 27 * Q**2                      # = 229

def certificates():
    out = {}
    # irreducible over Q: a cubic with no rational root.  By the rational root
    # theorem the only candidates are the divisors of the constant term.
    out["no rational root"] = all(peval(F_POLY, F(r)) != 0 for r in (1, -1))
    # disc > 0 => three real roots => r1 = 3, totally real.
    out["disc > 0 (totally real)"] = DISC > 0
    # disc not a square => Galois group S3 => K is NOT Galois => Aut(K/Q) = 1,
    # so no automorphism permutes the three orderings.  This is the whole point.
    r = int(DISC**0.5)
    out["disc not a perfect square (Gal = S3, Aut(K/Q) = 1)"] = \
        all(k * k != DISC for k in (r - 1, r, r + 1))
    return out

def run():
    print("Three orderings, three verdicts, no automorphism relating them.\n")
    print("  K = Q[x]/(x^3 - 4x - 1),   disc = %d" % DISC)
    for k, v in certificates().items():
        print("    %-48s %s" % (k, v))

    ivs = isolate(F_POLY, -10, 10, want=3)
    print("\n  the three real embeddings, isolated exactly (Sturm):")
    rows = []
    for i, iv in enumerate(ivs, 1):
        (a, b), s = refine_off_zero(F_POLY, iv)
        rows.append((i, (a, b), s))
        print("    sigma_%d :  alpha in (%s, %s)   sign(alpha) = %+d"
              % (i, a, b, s))

    # The form <1, -alpha>.  Its signature at sigma_i is decided by the sign of
    # -alpha there, which the isolating intervals give exactly.
    print("\n  the form q = <1, -alpha>,  i.e. q(x,y) = x^2 - alpha*y^2")
    print("    %-10s %-14s %-12s %s" % ("ordering", "sign(-alpha)", "signature",
                                        "positive definite?"))
    verdicts = []
    for i, iv, s in rows:
        neg = -s
        sig = (2, 0) if neg > 0 else (1, 1)
        verdicts.append(neg > 0)
        print("    %-10s %-14s %-12s %s"
              % ("sigma_%d" % i, "%+d" % neg, str(sig), neg > 0))

    n_def = sum(verdicts)
    print("\n  definite at %d of 3 orderings, indefinite at %d."
          % (n_def, 3 - n_def))
    print("  So the verdict is a nonconstant function on a THREE-point")
    print("  Sper, and -- unlike Q(sqrt2) -- no field automorphism permutes")
    print("  the points, because Aut(K/Q) = 1.  The two definite orderings")
    print("  are not conjugate to the indefinite one by anything.")

    ok = (0 < n_def < 3) and all(certificates().values())
    print("\n  Consequence for the zeta route (cf, msg 0112 SS4): any object")
    print("  built from zeta_K is insensitive to the choice of embedding, so")
    print("  over a GALOIS K it is fixed by a group acting transitively on")
    print("  the orderings and its verdict is forced to be constant. That is")
    print("  the general obstruction; zeta_K = zeta*L was one instance of it.")
    print("  A non-Galois K removes the symmetry -- but a zeta object is")
    print("  still built from the ideal norm, which is totally positive by")
    print("  construction, so it lands in the intersection of all the cones.")
    print("  The multi-cone phenomenon needs an object carrying an embedding,")
    print("  not one built from norms.")

    print("\n  CERTIFICATE: %s" % ("VERIFIED" if ok else "FAILED"))
    return ok

if __name__ == "__main__":
    raise SystemExit(0 if run() else 1)
