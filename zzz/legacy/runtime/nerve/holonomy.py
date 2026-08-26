"""Transport around a loop of views, and the group element that measures it.

A claim's four views are four descriptions of one object.  *Transport* is the
translation of a description out of one view's vocabulary and into the next
one's:

    truth ---> action ---> cost ---> residual ---> truth

Carry a description all the way round.  If you get back what you started with,
the four vocabularies are globally consistent.  If you do not, they are
consistent pairwise -- every single arrow is a licensed translation -- and
globally **twisted**, and the twist is a group element.

WHAT A TRANSPORT IS
-------------------
A description, at this level of resolution, is a subset of the claim's sites:
the set the description *admits*.  A transport is a map on subsets, supplied by
whoever knows what the two vocabularies have to do with each other.  It is not
required to be invertible and it is not required to be a translation.

THE DEFAULT TRANSPORT, AND THE THEOREM THAT MAKES IT USELESS
-------------------------------------------------------------
The canonical, claim-independent choice is **translation by the disagreement
locus**:

    T_{i->j}(S) = S  xor  D_ij,     D_ij = { s : r_i(s) != r_j(s) }

The subsets of a finite set form ``(Z/2)^sites`` under symmetric difference, and
``D_ij`` is precisely the transition element the overlap ``{i,j}`` licenses --
this is a Cech 1-cochain with values in that group.  But
``D_ij = r_i + r_j (mod 2)``, so ``D`` is the coboundary of the vertex readings
and its sum around **any** loop is zero:

    **THEOREM.  The default transport has trivial holonomy on every claim.**

which is ``cech.py``'s negative theorem again, in the transport picture: a
translation built out of vertex readings telescopes.  ``prove_translation_holonomy_is_trivial``
runs it on a claim and the suite asserts it.

So a non-trivial holonomy must come from an arrow that is **not** a translation
-- an operation that genuinely destroys or re-creates information.  There are
exactly two such operations in this runtime and both are in the Fermat case:

    argmin      the extractor opens the cheapest members of what it is handed
                and structurally cannot open a maximum
    complement  the residual is what the action leaves out, so its arrow is
                set complement inside the claim's extension

and their composite around the loop is the exchange of the two minima with the
two maxima: an element of order 2.  That is the reflection ``Z/2`` of
``notes/CROSS_LENS.md`` sec.2, arriving here as a holonomy rather than as an
analogy.

Exact and integral throughout: sets, symmetric differences, and one integer
period.  Nothing here is approximate and nothing is sampled.
"""

from __future__ import annotations

from typing import Callable, Dict, FrozenSet, Iterable, List, Mapping, Optional, Sequence, Tuple

from .cech import FourFoldCertificate, simplex_name
from .views import ALL_VIEWS, Claim, LocalSection, NerveError, View, view_name

#: The loop of the four views, in the order CRYSTAL.md sec.1 draws the cell:
#: construction (truth) -> action -> the two observational faces and back.
LOOP: Tuple[int, ...] = (View.TRUTH, View.ACTION, View.COST, View.RESIDUAL)


def loop_edges(loop: Sequence[int] = LOOP) -> Tuple[Tuple[int, int], ...]:
    """The ordered arrows of the loop, closing it."""
    n = len(loop)
    return tuple((loop[i], loop[(i + 1) % n]) for i in range(n))


def loop_simplices(loop: Sequence[int] = LOOP) -> Tuple[Tuple[int, ...], ...]:
    """The unordered nerve edges the loop runs along."""
    return tuple(tuple(sorted(e)) for e in loop_edges(loop))


class Transport:
    """One licensed arrow ``src -> dst`` acting on descriptions."""

    __slots__ = ("src", "dst", "name", "fn", "reason", "is_translation")

    def __init__(self, src: int, dst: int, name: str,
                 fn: Callable[[FrozenSet[str]], Iterable[str]],
                 reason: str = "", is_translation: bool = False) -> None:
        if src not in ALL_VIEWS or dst not in ALL_VIEWS:
            raise NerveError("a transport runs between views: %r -> %r"
                             % (src, dst))
        self.src, self.dst, self.name = src, dst, name
        self.fn = fn
        self.reason = reason
        self.is_translation = is_translation

    def apply(self, S: Iterable[str]) -> FrozenSet[str]:
        return frozenset(self.fn(frozenset(S)))

    def arrow(self) -> str:
        return "%s->%s" % (view_name(self.src), view_name(self.dst))

    def render(self) -> str:
        return "%-19s %-26s %s" % (self.arrow(), self.name, self.reason)

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "Transport(%s, %r)" % (self.arrow(), self.name)


def translation_transports(sections: Mapping[int, LocalSection],
                           loop: Sequence[int] = LOOP) -> Tuple[Transport, ...]:
    """The default: translate by the overlap's disagreement locus."""
    out = []
    for i, j in loop_edges(loop):
        ri, rj = sections[i].reading, sections[j].reading
        shared = tuple(sorted(set(ri) & set(rj)))
        D = frozenset(s for s in shared if ri[s] != rj[s])

        def fn(S, D=D):
            return S ^ D

        out.append(Transport(
            i, j, "xor D", fn,
            "translate by the %d site(s) the overlap disagrees on" % len(D),
            is_translation=True))
    return tuple(out)


def compose(transports: Sequence[Transport],
            loop: Sequence[int] = LOOP) -> Callable[[FrozenSet[str]], FrozenSet[str]]:
    """The loop map, with the arrows checked to actually form the loop."""
    want = loop_edges(loop)
    got = tuple((t.src, t.dst) for t in transports)
    if got != want:
        raise NerveError(
            "the transports do not form the loop %s: got %s"
            % (" -> ".join(view_name(v) for v in tuple(loop) + (loop[0],)),
               " ".join(t.arrow() for t in transports)))

    def phi(S):
        cur = frozenset(S)
        for t in transports:
            cur = t.apply(cur)
        return cur

    return phi


class Holonomy:
    """The composite of a view-loop, and the exact group element measuring it."""

    __slots__ = ("loop", "transports", "start", "trace", "image", "orbit",
                 "period", "is_identity", "displacement", "eventual",
                 "preperiod")

    def __init__(self, loop, transports, start, trace, image, orbit, period,
                 is_identity, displacement, eventual, preperiod):
        self.loop = tuple(loop)
        self.transports = tuple(transports)
        self.start = frozenset(start)
        self.trace = tuple(trace)
        self.image = frozenset(image)
        self.orbit = tuple(orbit)
        self.period = period
        self.is_identity = is_identity
        self.displacement = frozenset(displacement)
        self.eventual = tuple(eventual)
        self.preperiod = preperiod

    def group(self) -> str:
        """The cyclic group the loop map generates on the start's orbit."""
        return "Z/%d" % self.period if self.period > 1 else "trivial (Z/1)"

    def invariant(self) -> Tuple[int, Tuple[str, ...]]:
        """``(period, the sites the loop moves)`` -- the exact measurement."""
        return (self.period, tuple(sorted(self.displacement)))

    def render(self) -> str:
        lines = ["  loop           %s" % " -> ".join(
            [view_name(v) for v in self.loop] + [view_name(self.loop[0])])]
        for t, before, after in self.trace:
            lines.append("    %-19s {%s}  ->  {%s}"
                         % (t.arrow(), ",".join(sorted(before)),
                            ",".join(sorted(after))))
        lines.append("  start          {%s}" % ",".join(sorted(self.start)))
        lines.append("  after one lap  {%s}" % ",".join(sorted(self.image)))
        lines.append("  identity?      %s" % ("YES -- the four descriptions are "
                                              "globally consistent"
                                              if self.is_identity else
                                              "NO -- consistent pairwise, "
                                              "globally twisted"))
        lines.append("  moved sites    {%s}" % ",".join(sorted(self.displacement)))
        lines.append("  holonomy group %s   (orbit of length %d, pre-period %d)"
                     % (self.group(), self.period, self.preperiod))
        return "\n".join(lines)

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "Holonomy(period=%d, identity=%r)" % (self.period,
                                                     self.is_identity)


def holonomy(transports: Sequence[Transport], start: Iterable[str],
             loop: Sequence[int] = LOOP) -> Holonomy:
    """Carry ``start`` once round the loop, then find the orbit exactly.

    The orbit is found by iterating the loop map until a set repeats.  The set
    of sites is finite, so the iteration terminates; the *period* is the length
    of the eventual cycle and the *pre-period* is how far the start is from it.
    A loop map that is not injective can have a pre-period, and reporting it is
    the honest form -- ``Z/period`` describes the eventual behaviour, not
    necessarily the behaviour at the start.
    """
    phi = compose(transports, loop)
    S0 = frozenset(start)
    trace = []
    cur = S0
    for t in transports:
        nxt = t.apply(cur)
        trace.append((t, cur, nxt))
        cur = nxt
    image = cur

    seen: Dict[FrozenSet[str], int] = {S0: 0}
    orbit: List[FrozenSet[str]] = [S0]
    x = S0
    while True:
        x = phi(x)
        if x in seen:
            preperiod = seen[x]
            period = len(orbit) - preperiod
            break
        seen[x] = len(orbit)
        orbit.append(x)
    return Holonomy(loop, transports, S0, trace, image, orbit, period,
                    image == S0, image ^ S0, orbit[preperiod:], preperiod)


def prove_translation_holonomy_is_trivial(
        sections: Mapping[int, LocalSection], sites: Sequence[str],
        loop: Sequence[int] = LOOP) -> Tuple[bool, str]:
    """Run the theorem stated in this module's docstring, on a claim.

    Every subset of the sites is carried round by the default transport and
    must come back.  Exhaustive when there are few sites; otherwise the empty
    set, every singleton and the full set, which already generate
    ``(Z/2)^sites``, so a translation that fixes them fixes everything.
    """
    ts = translation_transports(sections, loop)
    phi = compose(ts, loop)
    if len(sites) <= 12:
        probes: List[FrozenSet[str]] = []
        for mask in range(1 << len(sites)):
            probes.append(frozenset(s for k, s in enumerate(sites)
                                    if mask & (1 << k)))
        how = "exhaustive over all %d subsets" % (1 << len(sites))
    else:
        probes = [frozenset()] + [frozenset((s,)) for s in sites] \
            + [frozenset(sites)]
        how = ("the empty set, the %d singletons and the full set -- a "
               "generating set for (Z/2)^sites" % len(sites))
    for S in probes:
        if phi(S) != S:
            return (False, "the default transport moved {%s}"
                    % ",".join(sorted(S)))
    return (True, "trivial holonomy, %s" % how)


# --------------------------------------------------------------------------
# the Z/2 shadow: which arrows exchange the declared classes
# --------------------------------------------------------------------------

class ClassCocycle:
    """The loop's action on a declared two-class partition of the sites.

    Each arrow either preserves the two classes or exchanges them; that is a
    ``Z/2``-valued 1-cochain on the loop's edges, and its sum around the loop is
    the holonomy.  Being a sum around a closed loop it is exactly the pairing of
    the cochain with the fundamental 1-cycle -- so a non-zero value is a
    cohomological statement and not a bookkeeping one.
    """

    __slots__ = ("classes", "edges", "values", "total", "unknown")

    def __init__(self, classes, edges, values, total, unknown):
        self.classes = tuple(classes)
        self.edges = tuple(edges)
        self.values = tuple(values)
        self.total = total
        self.unknown = tuple(unknown)

    def render(self) -> str:
        rows = ["  classes        %s" % " | ".join(
            "%s={%s}" % (n, ",".join(sorted(m))) for n, m in self.classes)]
        for (i, j), v in zip(self.edges, self.values):
            rows.append("    %-19s %s"
                        % ("%s->%s" % (view_name(i), view_name(j)),
                           "exchange (1)" if v else "preserve (0)"))
        rows.append("  loop sum       %d in Z/2  ->  %s"
                    % (self.total,
                       "NON-TRIVIAL: the generator of the residual Z/2"
                       if self.total else "trivial"))
        for u in self.unknown:
            rows.append("  undecided      %s" % u)
        return "\n".join(rows)

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "ClassCocycle(total=%d)" % self.total


def class_cocycle(transports: Sequence[Transport],
                  classes: Sequence[Tuple[str, Iterable[str]]],
                  loop: Sequence[int] = LOOP) -> ClassCocycle:
    """Compute, arrow by arrow, whether the two declared classes are exchanged."""
    if len(classes) != 2:
        raise NerveError("the Z/2 shadow needs exactly two classes; got %d"
                         % len(classes))
    (na, A), (nb, B) = classes
    A, B = frozenset(A), frozenset(B)
    if A & B:
        raise NerveError("the two classes must be disjoint")
    values, unknown = [], []
    for t in transports:
        ia, ib = t.apply(A), t.apply(B)
        if ia == A and ib == B:
            values.append(0)
        elif ia == B and ib == A:
            values.append(1)
        else:
            values.append(0)
            unknown.append(
                "%s does not permute the two classes: {%s} -> {%s}, {%s} -> {%s}"
                % (t.arrow(), ",".join(sorted(A)), ",".join(sorted(ia)),
                   ",".join(sorted(B)), ",".join(sorted(ib))))
    return ClassCocycle(((na, A), (nb, B)), loop_edges(loop), values,
                        sum(values) % 2, unknown)


# --------------------------------------------------------------------------
# attaching holonomy to a certificate
# --------------------------------------------------------------------------

class HolonomyRecord:
    """What a certificate carries once holonomy has been measured."""

    __slots__ = ("holonomy", "shadow", "translation_theorem", "note")

    def __init__(self, hol, shadow, translation_theorem, note=""):
        self.holonomy = hol
        self.shadow = shadow
        self.translation_theorem = translation_theorem
        self.note = note

    def nontrivial(self) -> bool:
        return (self.holonomy is not None and not self.holonomy.is_identity) or \
               (self.shadow is not None and self.shadow.total != 0)

    def render(self) -> str:
        lines = []
        if self.holonomy is not None:
            lines.append(self.holonomy.render())
        if self.shadow is not None:
            lines.append(self.shadow.render())
        ok, how = self.translation_theorem
        lines.append("  default arrows %s (%s)"
                     % ("trivial holonomy, as the theorem requires" if ok
                        else "TRANSLATION THEOREM VIOLATED", how))
        if self.note:
            lines.append("  note           %s" % self.note)
        return "\n".join(lines)

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "HolonomyRecord(nontrivial=%r)" % self.nontrivial()


def attach_holonomy(cert: FourFoldCertificate,
                    transports: Optional[Sequence[Transport]] = None,
                    start: Optional[Iterable[str]] = None,
                    classes: Optional[Sequence[Tuple[str, Iterable[str]]]] = None,
                    loop: Sequence[int] = LOOP,
                    note: str = "") -> FourFoldCertificate:
    """Measure holonomy for a certified claim and attach the record.

    With no transports supplied the default translation arrows are used, and
    the answer is the theorem: trivial.  A caller that knows what its views
    actually do to a description supplies the real arrows.
    """
    sections = cert.sections
    sites = cert.claim.sites
    theorem = prove_translation_holonomy_is_trivial(sections, sites, loop)
    ts = tuple(transports) if transports is not None \
        else translation_transports(sections, loop)
    if start is None:
        start = sections[loop[0]].admits()
    hol = holonomy(ts, start, loop)
    shadow = class_cocycle(ts, classes, loop) if classes else None
    cert.holonomy = HolonomyRecord(hol, shadow, theorem, note)
    return cert


__all__ = [
    "LOOP", "loop_edges", "loop_simplices", "Transport",
    "translation_transports", "compose", "Holonomy", "holonomy",
    "prove_translation_holonomy_is_trivial", "ClassCocycle", "class_cocycle",
    "HolonomyRecord", "attach_holonomy",
]
