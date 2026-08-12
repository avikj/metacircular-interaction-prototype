"""The runtime's first originated index, and it has to be non-Galois.

`runtime/kernel/limitor_audit.py` reported that across 71 source files this
runtime originates **zero** limitors: three kinds declare an index and nothing
ever supplies one.  This module supplies one, with a checked witness, and it is
the first.

Why the field is not a choice
-----------------------------
The obvious exhibit is `Q(sqrt2)`, which has two orderings.  It would be
**vacuous**, and the reason is a theorem proved in this repository in a
different domain on the same day.

  Theorem E (notes/INDEX_LAW.md, claude_arithmetic_breaker): a group acting
  transitively on the target of an equivariant map forces every fibre to have
  the same size.  Proof: given y, y' pick g with gy = y'; then x -> gx is a
  bijection of fibres.

Applied to orderings: if K/Q is Galois, Gal(K/Q) acts transitively on the real
embeddings, so all r1 orderings are conjugate, so any Gal-invariant claim has
the same verdict at every one.  An index the symmetry can permute carries no
free information, however many values it has.  `Q(sqrt2)`'s census came out
495/495 for exactly this reason.

So the first genuine index must live where the symmetry BREAKS:

  K = Q[x]/(x^3 - 4x - 1),  disc = 229 prime, hence not a square, hence
  Gal = S3, hence K is NOT Galois and Aut(K/Q) = 1.  229 > 0, so K is totally
  real: r1 = 3, and the three orderings are permuted by nothing.

The form <1, -alpha> is definite at two of them and indefinite at the third.
A 2+1 partition is itself the certificate that no automorphism relates them,
since a conjugate pair can only split 1+1.

What this module does
---------------------
Originates three `Order` edges, one per ordering, each with a `Certificate`
whose limitor is that ordering -- so the kernel checks that a certificate for
sigma_1 cannot be offered for a sigma_3 edge.  Then:

  * `limitor_census` reports the `ordering` sort at cardinality 3, not 1;
  * two edges at DIFFERENT orderings refuse to compose, because sign does not
    transport between orderings that disagree;
  * two edges at the SAME ordering still compose -- the null control, without
    which "refuses to compose" would just mean "composition is broken".

All arithmetic is exact: `machinery/orderings_cubic.py` decides every sign by
integer comparison via Sturm sequences over Q.  No floats, no approximation of
a root, nothing measured.

Run: python3 runtime/order/witness.py
"""
from __future__ import annotations

import os
import sys

_HERE = os.path.dirname(os.path.abspath(__file__))
_REPO = os.path.dirname(os.path.dirname(_HERE))
for _p in (_REPO, os.path.join(_REPO, "machinery")):
    if _p not in sys.path:
        sys.path.insert(0, _p)

from runtime.kernel import check as C            # noqa: E402
from runtime.kernel import edges as E            # noqa: E402
from runtime.kernel import term as T             # noqa: E402

import orderings_cubic as OC                     # noqa: E402


SORT = T.base_sort("verdict")

def _addr(name: str) -> str:
    return T.Const(name, SORT).addr


def orderings():
    """The three orderings of K, exactly isolated, with the sign of alpha."""
    out = []
    for i, iv in enumerate(OC.isolate(OC.F_POLY, -10, 10, want=3), 1):
        (lo, hi), s = OC.refine_off_zero(OC.F_POLY, iv)
        out.append(("sigma_%d" % i, (lo, hi), s))
    return out


def build():
    """Originate one checked Order edge per ordering.  Returns (edges, ctx)."""
    ctx = C.CheckContext()
    src = _addr("form<1,-alpha>")
    built = []
    for name, (lo, hi), sign_alpha in orderings():
        definite = (-sign_alpha) > 0
        dst = _addr("definite" if definite else "indefinite")
        cert = "sturm/%s" % name
        # The certificate names the ordering it is for.  The kernel refuses it
        # on an edge carrying a different one.
        ctx.declare_certificate(cert, "Order", src, dst, limitor=name)
        e = E.Edge("Order", src, dst, ordering=name,
                   witness=C.Certificate(cert),
                   label="sign(-alpha)@%s" % name)
        if not C.check_edge(e, ctx):
            raise AssertionError("witness rejected: %s" % ctx.errors[-1])
        built.append((e, (lo, hi), sign_alpha, definite))
    return built, ctx


def run():
    print("The runtime's first originated index.\n")
    print("  K = Q[x]/(x^3 - 4x - 1), disc = %d (prime, non-square)" % OC.DISC)
    print("  => Gal = S3, K not Galois, Aut(K/Q) = 1, r1 = 3\n")

    built, ctx = build()
    print("  %-9s %-22s %-9s %-12s %s"
          % ("ordering", "alpha isolated", "sign(-a)", "verdict", "witness checked"))
    for e, (lo, hi), s, definite in built:
        print("  %-9s %-22s %-9s %-12s %s"
              % (e.ordering, "(%s, %s)" % (lo, hi), "%+d" % (-s),
                 "definite" if definite else "indefinite", True))

    edges = [e for e, _, _, _ in built]
    cen = E.limitor_census(edges)["ordering"]
    print("\n  limitor_census -> ordering sort: cardinality %d, values %s"
          % (cen["cardinality"], cen["values"]))

    # The two composition facts.  Both edges leave the same source, so to test
    # composition we need one that meets the other's head; build the transport
    # edge at a named ordering and try it against each.
    mid = edges[0].dst
    same = E.Edge("Order", mid, _addr("cone"), ordering=edges[0].ordering,
                  label="transport@%s" % edges[0].ordering)
    diff = E.Edge("Order", mid, _addr("cone"), ordering=edges[2].ordering,
                  label="transport@%s" % edges[2].ordering)
    ok_same = E.compose(edges[0], same)
    ok_diff = E.compose(edges[0], diff)

    print("\n  compose at the SAME ordering (%s ; %s) : %s   <- null control"
          % (edges[0].ordering, same.ordering,
             "licensed" if ok_same else "REFUSED"))
    print("  compose at DIFFERENT orderings (%s ; %s): %s"
          % (edges[0].ordering, diff.ordering,
             "licensed" if ok_diff else "refused"))

    # A certificate for one ordering must not be accepted for another.
    forged = E.Edge("Order", edges[0].src, edges[0].dst,
                    ordering=edges[2].ordering,
                    witness=C.Certificate("sturm/%s" % edges[0].ordering))
    forged_ok = C.check_edge(forged, ctx)
    print("  certificate for %s offered on a %s edge: %s"
          % (edges[0].ordering, edges[2].ordering,
             "ACCEPTED (bad)" if forged_ok else "rejected"))

    verdicts = [d for _, _, _, d in built]
    split = (sum(verdicts), len(verdicts) - sum(verdicts))
    print("\n  verdict partition of the three orderings: %d + %d" % split)
    print("  A conjugate pair can only split 1+1, so an asymmetric partition")
    print("  certifies that no automorphism relates these orderings -- which")
    print("  is why the index here is free and would be vacuous over a Galois")
    print("  field, by Theorem E of notes/INDEX_LAW.md.")

    ok = (cen["cardinality"] == 3 and ok_same is not None and ok_diff is None
          and not forged_ok and 0 < sum(verdicts) < 3)
    print("\n  FIRST ORIGINATED INDEX: %s" % ("VERIFIED" if ok else "FAILED"))
    return ok


if __name__ == "__main__":
    raise SystemExit(0 if run() else 1)
