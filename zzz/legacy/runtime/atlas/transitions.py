"""Transition maps of the atlas, as **typed kernel edges with residuals**.

For every adjacent pair of charts in `notes/ATLAS_OF_N.md` Sec.2.6 this module:

1. implements the map;
2. verifies it is well defined and injective/surjective by **exhaustive check on
   a stated finite range** -- the range is a field of the transition, printed in
   every report, and nothing is claimed outside it;
3. installs it as a typed kernel edge of the *right kind* -- ``Iso`` only where
   the exhaustive check says bijection, ``Quotient`` where it is surjective and
   not injective, ``Embed`` where it is injective and not surjective, ``Implies``
   where only truth transfers;
4. attaches the residual as a **computed object** (``residual.py``): a group with
   its order and Cayley digest, a torsor with its freeness/transitivity report, a
   2-cocycle with its coboundary search, an invariant, or an obstruction.

Kind discipline (this is what makes the controls bite)
------------------------------------------------------
``install`` refuses -- returns ``installed=False`` with a reason, and puts
nothing in the e-graph -- when

* the claimed kind disagrees with the exhaustive bijection report
  (an ``Iso`` for a map that is only an embedding is rejected here **and** by the
  kernel, which cannot normalise ``n`` and ``2n`` to the same Church numeral);
* a residual's declared triviality disagrees with its recomputed triviality;
* any kernel edge fails ``check.check_edge``.

Trust boundary, restated so no caller has to guess
--------------------------------------------------
Per `runtime/STATUS.md`: only ``Eq``, ``Iso`` and beta are machine-checked.  The
``Iso`` edges here *are* machine-checked -- the kernel normalises the Horner
term and the Church product and compares -- and ``InstallReport.machine_verified``
is True only for those.  ``Quotient``/``Implies`` edges carry declared
certificates: the kernel confirms a certificate exists, not that the mathematics
holds.  Constructing a report that claims otherwise raises ``TrustBoundaryError``.
"""

from __future__ import annotations

import itertools
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List, Optional, Sequence, Tuple

from ..kernel import check as C
from ..kernel import edges as E
from ..kernel import term as T
from ..kernel.egraph import EGraph
from ..kernel.term import Counters
from . import charts as CH
from .charts import (
    ATOMS,
    CardinalChart,
    DigitChart,
    OrdinalChart,
    PeanoChart,
    PrimeChart,
    TallyChart,
)
from .residual import (
    COCYCLE,
    GROUP,
    INVARIANT,
    OBSTRUCTION,
    TORSOR,
    Residual,
    ResidualReport,
    carry_cocycle,
    symmetric_group,
    trivial_group,
)

__all__ = [
    "TransitionError",
    "TrustBoundaryError",
    "BijectionReport",
    "Transition",
    "InstallReport",
    "AtlasReport",
    "TRANSITIONS",
    "transition",
    "build_atlas",
    "contractibility_report",
    "CONTRACTIBILITY_SCOPE",
    "KIND_REQUIREMENTS",
]


class TransitionError(Exception):
    pass


class TrustBoundaryError(Exception):
    """A report tried to claim machine verification the runtime cannot supply."""


#: what the exhaustive bijection report must say for each kernel edge kind
KIND_REQUIREMENTS: Dict[str, str] = {
    "Iso": "well defined, injective and surjective on the stated range",
    "Embed": "well defined and injective, and NOT surjective",
    "Quotient": "well defined and surjective, and NOT injective",
    "Implies": "well defined (truth transfers; no structure is claimed)",
}

CONTRACTIBILITY_SCOPE = (
    "What the finite check establishes: on the truncation [0,N] with the true "
    "successor, the set of maps h with h(0)=0 and h(n+1)=s(h n) has EXACTLY ONE "
    "element, found by enumerating all (N+1)^(N+1) functions -- so the comparison "
    "type is inhabited and has no second inhabitant at this level, and a planted "
    "wrong successor is caught (it yields 0 or >1). "
    "What it does NOT establish: the infinite statement. Uniqueness for all n is "
    "exactly initiality (ATLAS_OF_N Prop. 1.2), which is an induction; no finite "
    "enumeration proves an induction. The finite check is refutable, not "
    "confirmatory: it can kill the claim and cannot prove it. The machine-checked "
    "form of the infinite statement lives in formal/cubical/NaturalMachine/, not here."
)


def _counters(c: Optional[Counters]) -> Counters:
    return c if c is not None else Counters()


# ---------------------------------------------------------------------------
# exhaustive verification of a map on a stated finite range
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class BijectionReport:
    key: str
    range_note: str
    domain_size: int
    codomain_size: int
    image_size: int
    well_defined: bool
    injective: bool
    surjective: bool
    defect: Optional[str]
    steps: int

    @property
    def is_bijection(self) -> bool:
        return self.well_defined and self.injective and self.surjective

    def satisfies(self, kind: str) -> Tuple[bool, str]:
        if kind == "Iso":
            ok = self.is_bijection
            return ok, ("" if ok else "Iso claimed but the exhaustive check says "
                        "well_defined=%s injective=%s surjective=%s (%s)"
                        % (self.well_defined, self.injective, self.surjective, self.defect))
        if kind == "Embed":
            ok = self.well_defined and self.injective and not self.surjective
            return ok, ("" if ok else "Embed claimed but well_defined=%s injective=%s "
                        "surjective=%s (%s)" % (self.well_defined, self.injective,
                                                self.surjective, self.defect))
        if kind == "Quotient":
            ok = self.well_defined and self.surjective and not self.injective
            return ok, ("" if ok else "Quotient claimed but well_defined=%s injective=%s "
                        "surjective=%s (%s)" % (self.well_defined, self.injective,
                                                self.surjective, self.defect))
        if kind == "Implies":
            ok = self.well_defined
            return ok, ("" if ok else "Implies claimed but the map is not well defined")
        return False, "unsupported edge kind %r for a chart transition" % (kind,)

    def render(self) -> str:
        return ("map %-14s |dom|=%-5d |cod|=%-5d |im|=%-5d wd=%-5s inj=%-5s surj=%-5s "
                "steps=%-6d  range: %s"
                % (self.key, self.domain_size, self.codomain_size, self.image_size,
                   self.well_defined, self.injective, self.surjective, self.steps,
                   self.range_note))


def _short(x: Any, width: int = 44) -> str:
    r = repr(x)
    return r if len(r) <= width else r[:width - 3] + "..."


def exhaustive_map_report(key: str, range_note: str, domain: Sequence[Any],
                          codomain: Sequence[Any], f: Callable[[Any], Any],
                          counters: Optional[Counters] = None) -> BijectionReport:
    """Check ``f : domain -> codomain`` completely, element by element."""
    c = _counters(counters)
    start = c.get("atlas.map.probe")
    cod = tuple(codomain)
    codset = set(map(repr, cod))
    seen: Dict[str, Any] = {}
    well = True
    inj = True
    defect: Optional[str] = None
    image: List[str] = []
    for d in domain:
        c.bump("atlas.map.probe")
        y = f(d)
        r = repr(y)
        if r not in codset:
            well = False
            if defect is None:
                defect = ("f(%s) = %s is outside the declared codomain"
                          % (_short(d), _short(y)))
        if r in seen:
            inj = False
            if defect is None:
                defect = ("f(%s) = f(%s) = %s"
                          % (_short(seen[r]), _short(d), _short(y)))
        else:
            seen[r] = d
            image.append(r)
    surj = len(set(image) & codset) == len(codset)
    if not surj and defect is None:
        missing = sorted(codset - set(image))[:1]
        defect = "not hit: %s" % (_short(missing[0], 44) if missing else "?")
    return BijectionReport(key, range_note, len(tuple(domain)), len(cod), len(set(image)),
                           well, inj, surj, defect, c.get("atlas.map.probe") - start)


# ---------------------------------------------------------------------------
# a transition
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class InstallReport:
    key: str
    kind: str
    installed: bool
    reason: str
    bijection: BijectionReport
    residuals: Tuple[ResidualReport, ...]
    edges_offered: int
    edges_checked: int
    machine_verified: bool
    steps: int

    def __post_init__(self) -> None:
        if self.machine_verified and self.kind not in ("Eq", "Iso"):
            raise TrustBoundaryError(
                "runtime/STATUS.md: only Eq, Iso and beta are machine-checked, so a "
                "%s edge cannot be reported as machine_verified. It is DECLARED."
                % self.kind)

    def trust_note(self) -> str:
        if self.machine_verified:
            return ("MACHINE-CHECKED: the kernel normalised both chart terms and "
                    "compared normal forms, and round-tripped the transport on fresh "
                    "probes, for all %d edges." % self.edges_checked)
        return ("DECLARED, NOT VERIFIED: kind=%s. The kernel confirms a matching "
                "certificate exists; the mathematics behind it is the exhaustive "
                "check in this module, not a kernel proof." % self.kind)

    def render(self) -> str:
        head = ("install %-10s %-9s %s edges=%d/%d %s"
                % (self.key, self.kind, "OK     " if self.installed else "REFUSED",
                   self.edges_checked, self.edges_offered,
                   "machine-checked" if self.machine_verified else "declared"))
        if not self.installed:
            head += "\n    reason: %s" % self.reason
        return head


@dataclass(frozen=True)
class Transition:
    """One arrow of the atlas: a map, a range, a kernel edge kind, residuals."""

    key: str
    src: str
    dst: str
    kind: str
    range_note: str
    domain: Callable[[], Sequence[Any]]
    codomain: Callable[[], Sequence[Any]]
    forward: Callable[[Any], Any]
    residuals: Tuple[Residual, ...]
    note: str
    term_pairs: Callable[[], Sequence[Tuple[T.Term, T.Term]]] = field(
        default_factory=lambda: (lambda: ()))
    certificate_name: str = ""

    # -- verification ------------------------------------------------------
    def bijection_report(self, counters: Optional[Counters] = None) -> BijectionReport:
        return exhaustive_map_report(self.key, self.range_note, self.domain(),
                                     self.codomain(), self.forward, counters)

    def residual_reports(self, counters: Optional[Counters] = None
                         ) -> Tuple[ResidualReport, ...]:
        return tuple(r.verify(counters) for r in self.residuals)

    def kernel_edges(self, ctx: C.CheckContext, counters: Optional[Counters] = None
                     ) -> Tuple[Tuple[E.Edge, bool], ...]:
        c = _counters(counters)
        out: List[Tuple[E.Edge, bool]] = []
        pairs = tuple(self.term_pairs())
        for i, (a, b) in enumerate(pairs):
            c.bump("atlas.edge.build")
            if self.kind == "Iso":
                e = E.Edge("Iso", a.addr, b.addr,
                           witness=C.IsoWitness(CH.ID_CH, CH.ID_CH),
                           label="atlas/%s#%d" % (self.key, i),
                           provenance=(self.src, self.dst))
            else:
                name = "%s#%d" % (self.certificate_name or ("cert:" + self.key), i)
                ctx.declare_certificate(name, self.kind, a.addr, b.addr)
                e = E.Edge(self.kind, a.addr, b.addr, witness=C.Certificate(name),
                           label="atlas/%s#%d" % (self.key, i),
                           provenance=(self.src, self.dst))
            c.bump("atlas.edge.check")
            out.append((e, C.check_edge(e, ctx)))
        return tuple(out)

    # -- installation ------------------------------------------------------
    def install(self, graph: Optional[EGraph], ctx: C.CheckContext,
                counters: Optional[Counters] = None) -> InstallReport:
        c = _counters(counters)
        start = c.get("atlas.map.probe") + c.get("atlas.edge.check")
        bij = self.bijection_report(c)
        rres = self.residual_reports(c)

        ok, reason = bij.satisfies(self.kind)
        if ok:
            for rep in rres:
                if not rep.agrees:
                    ok, reason = False, ("residual %s declared trivial=%s but computes "
                                         "trivial=%s" % (rep.key, rep.declared_trivial,
                                                         rep.computed_trivial))
                    break
                if not rep.ok:
                    ok, reason = False, "residual %s failed its own structure check" % rep.key
                    break

        edges = self.kernel_edges(ctx, c) if ok else ()
        checked = sum(1 for _e, good in edges if good)
        if ok and edges and checked != len(edges):
            ok, reason = False, ("kernel rejected %d of %d %s edges"
                                 % (len(edges) - checked, len(edges), self.kind))
        if ok and graph is not None:
            for e, _good in edges:
                for addr in (e.src, e.dst):
                    t = T.lookup(addr)
                    if t is not None:
                        graph.add(t)
                graph.add_directed(e)
        steps = (c.get("atlas.map.probe") + c.get("atlas.edge.check")) - start
        return InstallReport(self.key, self.kind, ok, reason if not ok else "",
                             bij, rres, len(edges), checked,
                             bool(ok and self.kind == "Iso"), steps)

    def render(self) -> str:
        return ("%-10s %-9s -> %-9s [%s]  %s" %
                (self.key, self.src, self.dst, self.kind, self.note))


# ---------------------------------------------------------------------------
# the residuals, built once
# ---------------------------------------------------------------------------

PEANO = PeanoChart()
TALLY = TallyChart()
CARD = CardinalChart()
ORD = OrdinalChart()
DIG10 = DigitChart(10, "little")
DIG2 = DigitChart(2, "little")
PRIME = PrimeChart()

#: the finite level at which the S_n / torsor residuals are computed in full
RESIDUAL_LEVEL = 4

#: the range on which kernel Iso edges are built and checked
TERM_RANGE = tuple(range(0, 17))


def _trivial_residual(key: str, statement: str) -> Residual:
    return Residual(key, GROUP, trivial_group("1"), True, statement)


def _sym_residual(n: int) -> Residual:
    """S_n, with its triviality *declared honestly*: trivial exactly for n < 2.

    ATLAS_OF_N Thm 2.3(2): pi_0 is not faithful **for n >= 2**.  Declaring
    S_0 and S_1 nontrivial would be caught by ``Residual.verify`` -- the same
    machinery that catches a residual claimed trivial when it is not.
    """
    g = symmetric_group(n)
    return Residual("S_%d (decategorification)" % n, GROUP, g, n < 2,
                    "Aut of an n-element set; pi_1(BS_n); order %d = %d!" % (g.order, n))


def _order_torsor_residual(n: int) -> Residual:
    tor = ORD.order_torsor(n)
    return Residual("LinOrd torsor n=%d" % n, TORSOR, tor, False,
                    "the S_%d-torsor of linear orders; free, transitive, size %d! = %d"
                    % (n, n, tor.group.order))


def _base_residual(a: DigitChart, b: DigitChart) -> Residual:
    return Residual("base rad(b)", INVARIANT,
                    (("rad(%d)" % a.b, a.radical()), ("rad(%d)" % b.b, b.radical())),
                    False,
                    "the chart invariant of the base is rad(b); charts with different "
                    "radicals have no continuous intertranslation (Prop. 2.8)")


def _endian_residual(d: DigitChart) -> Residual:
    return Residual("endian Z/2", TORSOR, d.endian_torsor(), False,
                    "the two truncation systems {pi, sigma} form a Z/2-torsor; "
                    "reversal is the generator (DIGIT_CRYSTAL Thm 4.2)")


def _carry_residual(b: int, n: int) -> Residual:
    return Residual("carry [c_%d] in H^2" % n, COCYCLE, carry_cocycle(b, n), False,
                    "the digit section's coboundary; a normalized 2-cocycle whose "
                    "class in H^2(Z/b^n; Z/b) is nonzero, so no digit set is "
                    "carry-free (Prop. 2.11, Cor. 2.11.1)")


def _addition_residual() -> Residual:
    def obstruction() -> Tuple[bool, Any]:
        holds, wit = PRIME.successor_not_definable()
        return holds, wit

    return Residual("addition (Sym(P))", OBSTRUCTION, obstruction, False,
                    "Aut(N_{>0},x) = Sym(P) has size 2^aleph_0 while Aut(N,+,x) is "
                    "trivial: the successor is not Sym(P)-equivariant, so it is not "
                    "definable from the multiplicative structure alone (Thm 2.13)")


def _shared_locus_residual(d: DigitChart) -> Residual:
    return Residual("shared locus {p|b}", INVARIANT,
                    (("primes dividing b=%d" % d.b, d.shared_locus_with_primes()),),
                    False,
                    "charts (e) and (f) overlap exactly at the primes dividing b "
                    "(Prop. 2.9); every 'divisibility trick' is that statement",
                    trivial_test=lambda pairs: len(pairs[0][1]) == 0)


# ---------------------------------------------------------------------------
# the transitions
# ---------------------------------------------------------------------------

_N = 12                      # the exhaustive range for element-level maps
_SET_N = 4                   # the exhaustive range for set/order-level maps
_ATOM_N = len(ATOMS)         # charts (c),(d) cannot name a set bigger than this


def _peano_tally() -> Transition:
    return Transition(
        key="a<->b", src="peano", dst="tally", kind="Iso",
        range_note="all n in [0,%d] (data), kernel edges for n in [0,%d]"
                   % (_N, TERM_RANGE[-1]),
        domain=lambda: [PEANO.datum(n) for n in range(_N + 1)],
        codomain=lambda: [TALLY.datum(n) for n in range(_N + 1)],
        forward=lambda d: TALLY.datum(PEANO.value(d)),
        residuals=(_trivial_residual(
            "trivial (a<->b)",
            "the comparison is unique: both objects are initial, so the type of "
            "identifications is contractible (ATLAS_OF_N Residual 2.1)"),),
        note="successor <-> concatenation of one tick; PLUS_T and CONCAT_T are the "
             "SAME kernel address, which is Residual 2.1(2) at L0",
        term_pairs=lambda: [(PEANO.term(n), TALLY.term(n)) for n in TERM_RANGE],
    )


def _cardinal_peano() -> Transition:
    def dom() -> Sequence[Any]:
        out = []
        for n in range(_SET_N + 1):
            out.extend(CARD.decategorification_fiber(n, 6))
        return out

    return Transition(
        key="c->a", src="cardinal", dst="peano", kind="Quotient",
        range_note="every subset of a 6-atom universe of size <= %d (%d objects)"
                   % (_SET_N, sum(1 for n in range(_SET_N + 1)
                                  for _ in itertools.combinations(range(6), n))),
        domain=dom,
        codomain=lambda: [PEANO.datum(n) for n in range(_SET_N + 1)],
        forward=lambda X: PEANO.datum(len(X)),
        residuals=tuple(_sym_residual(n) for n in range(RESIDUAL_LEVEL + 1)) +
                  (Residual("Iso(X,[n]) torsor n=%d" % RESIDUAL_LEVEL, TORSOR,
                            CARD.iso_torsor(RESIDUAL_LEVEL), False,
                            "the fiber of the comparison is an S_n-torsor of size n!"),),
        note="pi_0: bijective on iso-classes, NOT faithful; the fiber of Aut(X) -> "
             "Aut(n) = 1 is S_n",
        term_pairs=lambda: [(CARD.term(n), PEANO.term(n)) for n in range(_SET_N + 1)],
        certificate_name="cert:atlas/pi0",
    )


def _ordinal_cardinal() -> Transition:
    def dom() -> Sequence[Any]:
        out = []
        for n in range(_SET_N + 1):
            out.extend(ORD.orders(ORD.datum(n)))
        return out

    return Transition(
        key="d->c", src="ordinal", dst="cardinal", kind="Quotient",
        range_note="every linear order on [n] for n in [0,%d] (sum n! = %d objects)"
                   % (_SET_N, sum(len(ORD.orders(ORD.datum(n)))
                                  for n in range(_SET_N + 1))),
        domain=dom,
        codomain=lambda: [tuple(sorted(CARD.datum(n))) for n in range(_SET_N + 1)],
        forward=lambda o: tuple(sorted(o)),
        residuals=tuple(_order_torsor_residual(n) for n in range(2, RESIDUAL_LEVEL + 1)),
        note="forget the order: the fiber is the S_n-torsor of linear orders, and the "
             "total space is contractible (Thm 3.2) -- checked as 'exactly one order "
             "isomorphism between any two objects'",
        term_pairs=lambda: [(ORD.term(n), CARD.term(n)) for n in range(_SET_N + 1)],
        certificate_name="cert:atlas/forget-order",
    )


def _ordinal_peano() -> Transition:
    return Transition(
        key="d->a", src="ordinal", dst="peano", kind="Iso",
        range_note="order types of linear orders on [n], n in [0,%d] (the ordinal "
                   "chart's atom universe stops there); kernel edges for n in [0,%d]"
                   % (_ATOM_N, TERM_RANGE[-1]),
        domain=lambda: [ORD.datum(n) for n in range(_ATOM_N + 1)],
        codomain=lambda: [PEANO.datum(n) for n in range(_ATOM_N + 1)],
        forward=lambda o: PEANO.datum(len(o)),
        residuals=(_trivial_residual(
            "trivial below omega",
            "finite linear orders are rigid (Prop. 2.4): any two of equal size are "
            "UNIQUELY isomorphic, so the residual is inert on N -- and switches on at "
            "omega, where 1+omega = omega != omega+1"),),
        note="order type; the divergence is exactly at omega (Thm 2.6)",
        term_pairs=lambda: [(ORD.term(n), PEANO.term(n)) for n in TERM_RANGE],
    )


def _peano_digit(d: DigitChart) -> Transition:
    return Transition(
        key="a->e(b=%d)" % d.b, src="peano", dst=d.key, kind="Iso",
        range_note="all n in [0,%d]; kernel Horner edges for n in [0,%d]"
                   % (_N * 8, TERM_RANGE[-1]),
        domain=lambda: [PEANO.datum(n) for n in range(_N * 8 + 1)],
        codomain=lambda: [d.datum(n) for n in range(_N * 8 + 1)],
        forward=lambda p: d.datum(PEANO.value(p)),
        residuals=(_base_residual(d, DigitChart(2 if d.b != 2 else 3, "little")),
                   _endian_residual(d),
                   _carry_residual(d.b, 1)),
        note="L(c) = sum c_i b^i (Thm 2.7); three residuals: base rad(b), endian Z/2, "
             "carry class != 0. The kernel edge is checked by *running* Horner in "
             "Church arithmetic.",
        term_pairs=lambda: [(PEANO.term(n), d.term(n)) for n in TERM_RANGE],
    )


def _peano_prime() -> Transition:
    rng = tuple(range(1, _N * 4 + 1))
    return Transition(
        key="a->f", src="peano", dst="prime", kind="Iso",
        range_note="all n in [1,%d]; kernel product edges for n in [1,%d]"
                   % (rng[-1], TERM_RANGE[-1]),
        domain=lambda: [PEANO.datum(n) for n in rng],
        codomain=lambda: [PRIME.datum(n) for n in rng],
        forward=lambda p: PRIME.datum(PEANO.value(p)),
        residuals=(_addition_residual(),),
        note="FTA: e is an isomorphism, i.e. this monoid is FREE. The residual is "
             "addition itself.",
        term_pairs=lambda: [(PEANO.term(n), PRIME.term(n))
                            for n in TERM_RANGE if n >= 1],
    )


def _digit_prime(d: DigitChart) -> Transition:
    ks = tuple(range(0, 4))
    ds = tuple(range(1, 21))

    def dom() -> Sequence[Any]:
        return [(dd, k) for dd in ds for k in ks]

    def fwd(pair: Tuple[int, int]) -> Tuple[int, int, bool]:
        dd, k = pair
        return (dd, k, d.residue_is_local(dd, k))

    return Transition(
        key="e->f", src=d.key, dst="prime", kind="Implies",
        range_note="d in [1,20], k in [0,3], base %d: 'n mod d is a function of the "
                   "last k digits' checked exhaustively over a full period" % d.b,
        domain=dom,
        codomain=lambda: [(dd, k, (d.b ** k) % dd == 0) for dd in ds for k in ks],
        forward=fwd,
        residuals=(_shared_locus_residual(d),),
        note="Prop. 2.9: the residue mod d is local in the digits iff d | b^k; the two "
             "charts share exactly the primes dividing b",
        term_pairs=lambda: [(d.term(n), PRIME.term(n)) for n in (2, 5, 10)],
        certificate_name="cert:atlas/locality",
    )


TRANSITIONS: Tuple[Transition, ...] = (
    _peano_tally(),
    _cardinal_peano(),
    _ordinal_cardinal(),
    _ordinal_peano(),
    _peano_digit(DIG10),
    _peano_digit(DIG2),
    _peano_prime(),
    _digit_prime(DIG10),
)


def transition(key: str) -> Transition:
    for t in TRANSITIONS:
        if t.key == key:
            return t
    raise TransitionError("no transition %r; have %s"
                          % (key, ", ".join(t.key for t in TRANSITIONS)))


# ---------------------------------------------------------------------------
# the contractibility check for (a) <-> (b)
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class ContractibilityReport:
    bound: int
    functions_enumerated: int
    comparison_maps: int
    automorphisms: int
    unique: bool
    scope: str
    steps: int

    def render(self) -> str:
        return ("contractibility bound=%d enumerated=%d comparison_maps=%d "
                "automorphisms=%d unique=%s steps=%d"
                % (self.bound, self.functions_enumerated, self.comparison_maps,
                   self.automorphisms, self.unique, self.steps))


def contractibility_report(bound: int = 5, counters: Optional[Counters] = None,
                           target_succ: Optional[Callable[[int], Optional[int]]] = None
                           ) -> ContractibilityReport:
    """ATLAS_OF_N Residual 2.1, at the strongest finite level available.

    Enumerates *every* function on the truncation and keeps those commuting with
    the constructors.  Exactly one survives; and it is the identity, so
    ``Aut(N,0,s)`` is trivial at this level too.

    ``target_succ`` exists so a *planted wrong successor* can be run through the
    same code: with a shifted successor exactly one map still survives but it is
    not the identity (``unique`` is False), and with a successor that has a hole
    none survives at all.  Both are controls in ``tests/test_atlas.py``.
    """
    c = _counters(counters)
    start = c.get("atlas.peano.compare")

    def succ(x: int) -> Optional[int]:
        return x + 1 if x < bound else None

    maps = PEANO.comparison_maps(bound, target_succ or succ, c)
    autos = tuple(h for h in maps if sorted(h) == list(range(bound + 1)))
    return ContractibilityReport(
        bound, (bound + 1) ** (bound + 1), len(maps), len(autos),
        len(maps) == 1 and maps == (tuple(range(bound + 1)),),
        CONTRACTIBILITY_SCOPE, c.get("atlas.peano.compare") - start)


# ---------------------------------------------------------------------------
# building the whole atlas
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class AtlasReport:
    charts: Tuple[Any, ...]
    installs: Tuple[InstallReport, ...]
    contractibility: ContractibilityReport
    completions: Tuple[Any, ...]
    no_map_witness: Dict[str, Any]
    graph_edges: int
    counters: Counters

    @property
    def all_installed(self) -> bool:
        return all(r.installed for r in self.installs)

    def render(self) -> str:
        lines = ["charts (CRYSTAL.md Sec.4 declarations checked):"]
        lines += ["  " + r.render() for r in self.charts]
        lines += ["", "transitions:"]
        lines += ["  " + r.render() for r in self.installs]
        lines += ["", "residuals:"]
        for r in self.installs:
            for rr in r.residuals:
                lines.append("  " + rr.render())
        lines += ["", "  " + self.contractibility.render()]
        lines += ["", "completions (two incomparable ones):"]
        lines += ["  " + v.render() for v in self.completions]
        lines += ["  no continuous map either way: %s"
                  % self.no_map_witness["obstruction_Zb_to_R"]]
        lines += ["", "directed kernel edges installed: %d" % self.graph_edges]
        return "\n".join(lines)


def build_atlas(counters: Optional[Counters] = None,
                ctx: Optional[C.CheckContext] = None,
                graph: Optional[EGraph] = None) -> AtlasReport:
    """Verify every chart, install every transition, compute every residual."""
    c = _counters(counters)
    ctx = ctx if ctx is not None else C.CheckContext(fuel=400000)
    graph = graph if graph is not None else EGraph()

    chart_reports = []
    for ch in (PEANO, TALLY, CARD, ORD, DIG10, PRIME):
        bound = 3 if isinstance(ch, DigitChart) else 6
        chart_reports.append(ch.reachability_report(bound, c))

    installs = tuple(t.install(graph, ctx, c) for t in TRANSITIONS)
    contract = contractibility_report(5, c)
    verdicts, nomap = CH.two_completions_report(10, c)
    return AtlasReport(tuple(chart_reports), installs, contract, verdicts, nomap,
                       graph.steps.get("directed_edges"), c)
