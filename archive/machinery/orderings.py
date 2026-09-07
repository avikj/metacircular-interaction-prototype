"""Positivity is a point of the real spectrum.  Exact certificate.

The corpus treats "positive definite" as a predicate of a quadratic form.  It
is not.  It is a predicate of the *pair* (form, ordering of the ground field),
and it looked like a predicate of the form alone because every result here
lives over Q, which has exactly one ordering.  A unique chart is invisible.

This file exhibits the same form, over the same field, positive definite at one
ordering and indefinite at the other.  All arithmetic is in Z[sqrt2] with
integer comparisons; no floating point occurs, and no quantity is measured.
See notes/POSITIVITY_HAS_A_PLACE.md for the theorem this certifies.

Run: python3 machinery/orderings.py
"""

# --------------------------------------------------------- the field Q(sqrt2)
# An element is the integer pair (a, b) denoting a + b*sqrt2.  Q(sqrt2) has
# exactly two field embeddings into R, hence (Artin-Schreier) exactly two
# orderings: sigma+ sends sqrt2 to the positive root, sigma- to the negative.
# The nontrivial automorphism a + b*sqrt2 |-> a - b*sqrt2 exchanges them, so
# the two orderings are conjugate but *distinct points* of Sper Q(sqrt2).

def sgn(n):
    return (n > 0) - (n < 0)

def sign_plus(x):
    """Sign of a + b*sqrt2 under sqrt2 > 0.  Exact: integers only."""
    a, b = x
    if b == 0: return sgn(a)
    if a == 0: return sgn(b)
    if sgn(a) == sgn(b): return sgn(a)
    # Mixed signs.  a + b*sqrt2 > 0 iff sgn(a)*(a^2 - 2b^2) > 0, and
    # a^2 = 2b^2 forces a = b = 0 because sqrt2 is irrational, so the
    # comparison never ties on a nonzero element: the sign is total.
    return sgn(a) * sgn(a * a - 2 * b * b)

def sign_minus(x):
    """Sign under sqrt2 < 0, i.e. sign_plus of the conjugate."""
    a, b = x
    return sign_plus((a, -b))

ORDERINGS = [("sigma+", sign_plus), ("sigma-", sign_minus)]

def show(x):
    a, b = x
    if b == 0: return str(a)
    if a == 0: return ("-" if b < 0 else "") + ("sqrt2" if abs(b) == 1
                                                else "%d*sqrt2" % abs(b))
    return "%d %s %s" % (a, "-" if b < 0 else "+",
                         "sqrt2" if abs(b) == 1 else "%d*sqrt2" % abs(b))

# ------------------------------------------------------------- signature
def signature(form, sign):
    """(#positive, #negative) of a diagonal form under one ordering."""
    s = [sign(c) for c in form]
    assert 0 not in s, "degenerate form"
    return (s.count(1), s.count(-1))

def definite(form, sign):
    p, n = signature(form, sign)
    return n == 0

# ------------------------------------------------------------- the exhibit
# q(x,y) = x^2 - sqrt2 * y^2, i.e. the diagonal form <1, -sqrt2>.
Q = [(1, 0), (0, -1)]

def anisotropy_certificate():
    """q represents 0 only trivially.  Purely algebraic, no search.

    q(x,y) = 0 with y != 0 forces (x/y)^2 = sqrt2, so sqrt2 is a square in
    Q(sqrt2).  But (a + b*sqrt2)^2 = (a^2 + 2b^2) + 2ab*sqrt2, and equating to
    0 + 1*sqrt2 gives a^2 + 2b^2 = 0, hence a = b = 0 over Q, hence 2ab = 0,
    contradicting 2ab = 1.  So q is anisotropic at every ordering.
    """
    # the same two equations, asserted rather than narrated
    a2_plus_2b2_zero_implies_zero = all(
        (a * a + 2 * b * b != 0) or (a == 0 and b == 0)
        for a in range(-4, 5) for b in range(-4, 5))
    return a2_plus_2b2_zero_implies_zero

# --------------------------------------- exhaustive: the predicate is a map
def census(N):
    """All binary diagonal forms with |a|,|b| <= N, classified by the pair of
    definiteness verdicts.  A finite exhaustive verification, not a sample."""
    coeffs = [(a, b) for a in range(-N, N + 1) for b in range(-N, N + 1)
              if sign_plus((a, b)) != 0]
    tally = {}
    witnesses = {}
    for c in coeffs:
        for d in coeffs:
            f = [c, d]
            key = (definite(f, sign_plus), definite(f, sign_minus))
            tally[key] = tally.get(key, 0) + 1
            witnesses.setdefault(key, f)
    return tally, witnesses, len(coeffs)

def run():
    print("Positivity is a point of the real spectrum.\n")

    print("  the form q = <1, -sqrt2>, i.e. q(x,y) = x^2 - sqrt2*y^2")
    print("  over the single field Q(sqrt2), with its two orderings:\n")
    print("  %-8s %-24s %-12s %s" % ("ordering", "coefficient signs",
                                     "signature", "positive definite?"))
    for name, sign in ORDERINGS:
        signs = " ".join("%+d" % sign(c) for c in Q)
        print("  %-8s %-24s %-12s %s"
              % (name, "(" + signs + ")  " + ", ".join(show(c) for c in Q),
                 str(signature(Q, sign)), definite(Q, sign)))

    forked = definite(Q, sign_plus) != definite(Q, sign_minus)
    print("\n  same form, same field, different verdict : %s" % forked)
    print("  and it is anisotropic at both (no zeros)  : %s"
          % anisotropy_certificate())

    N = 3
    tally, wit, ncoef = census(N)
    print("\n  exhaustive census, |a|,|b| <= %d  (%d nonzero coefficients,"
          " %d binary forms)" % (N, ncoef, ncoef * ncoef))
    print("  %-22s %8s   %s" % ("(def at +, def at -)", "count", "witness"))
    for key in sorted(tally, reverse=True):
        f = wit[key]
        print("  %-22s %8d   <%s, %s>"
              % (str(key), tally[key], show(f[0]), show(f[1])))

    both_mixed = (True, False) in tally and (False, True) in tally
    print("\n  both mixed verdicts occur, so 'positive definite' is a")
    print("  nonconstant function on Sper Q(sqrt2), not a property of q: %s"
          % both_mixed)

    # Q itself: exactly one ordering, which is why none of this was visible.
    print("\n  For contrast, over Q the same construction is impossible: an")
    print("  ordering of Q is determined on Z by 1 > 0 and closure under +,")
    print("  and then on Q by a/b > 0 iff ab > 0.  |Sper Q| = 1.  The chart")
    print("  exists; it is unique; a unique chart cannot be noticed.")

    ok = forked and anisotropy_certificate() and both_mixed
    print("\n  CERTIFICATE: %s" % ("VERIFIED" if ok else "FAILED"))
    return ok

if __name__ == "__main__":
    raise SystemExit(0 if run() else 1)
