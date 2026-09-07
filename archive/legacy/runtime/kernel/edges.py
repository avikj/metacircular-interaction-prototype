"""L1 -- the typed edge algebra.  No universal semantic hash.

CRYSTAL.md Sec.2 L1 table, implemented as a small algebra.  Each kind knows

  (a) whether it is symmetric              -- ``is_symmetric``
  (b) what it composes with, and to what   -- ``compose_kind`` / ``compose``
  (c) what it preserves                    -- ``preserves``

``compose`` is a *total* function into ``Edge | None``.  ``None`` means "not
licensed": the kernel refuses to manufacture an edge it cannot name.  In
particular anything composed with ``Conjecture``, on either side, is ``None``.
Conjectural edges may guide search; they never enter an accepted derivation.

``Approx`` carries an exact ``fractions.Fraction`` epsilon.  Floats are rejected
at construction.  Composition adds epsilon exactly.
"""

from __future__ import annotations

import hashlib
from dataclasses import dataclass, field
from fractions import Fraction
from typing import Any, Dict, Optional, Tuple

from .term import COUNTERS, KernelError

__all__ = [
    "EdgeError",
    "KINDS",
    "SYMMETRIC",
    "PRESERVES",
    "ALL_PROPERTIES",
    "Edge",
    "compose_kind",
    "compose",
    "compose_path",
    "invert",
    "LimitorSpec",
    "LIMITORS",
    "limitor_of",
    "combine_limitors",
    "limitor_census",
    "is_symmetric",
    "preserves",
    "composition_table",
]


class EdgeError(KernelError):
    """An edge was built with an inadmissible payload."""


# --------------------------------------------------------------------------
# the ten kinds
# --------------------------------------------------------------------------

KINDS: Tuple[str, ...] = (
    "Eq",
    "Iso",
    "Embed",
    "Quotient",
    "Implies",
    "Approx",
    "Refine",
    "Interp",
    "Dual",
    "Order",
    "Conjecture",
)

SYMMETRIC = frozenset({"Eq", "Iso", "Dual"})

#: The universe of preservation tags.  A composite preserves the *intersection*
#: of what its parts preserve; this is the only lattice in the kernel.
ALL_PROPERTIES = frozenset(
    {
        "presentation",     # the exact elaborated form / L0 address
        "truth",            # the truth value of statements
        "structure",        # structure named in an invertible witness
        "injectivity",      # injectivity-stable properties
        "task_sufficiency", # sufficiency for a declared task family
        "bounded_error",    # properties stable under a bounded perturbation
        "extensional",      # extensional behaviour
        "semantics",        # theory-to-theory semantics
        "pairing",          # a stated duality pairing
        "sign",             # order data relative to a NAMED ordering; see Order
    }
)

PRESERVES: Dict[str, frozenset] = {
    "Eq": ALL_PROPERTIES,
    # An Iso preserves everything an Eq does except the presentation itself:
    # that is exactly the L0/L1 distinction the spec insists on.
    # An Iso preserves everything an Eq does except the presentation -- and
    # except ``sign``.  Galois conjugation a+b*sqrt2 |-> a-b*sqrt2 is a field
    # isomorphism of Q(sqrt2) that EXCHANGES its two orderings, so an
    # isomorphism does not carry order data.  See notes/POSITIVITY_HAS_A_PLACE.md
    # and machinery/orderings.py for the certificate.
    "Iso": ALL_PROPERTIES - {"presentation", "sign"},
    "Embed": frozenset({"injectivity", "truth"}),
    "Quotient": frozenset({"task_sufficiency"}),
    "Implies": frozenset({"truth"}),
    "Approx": frozenset({"bounded_error"}),
    "Refine": frozenset({"extensional"}),
    "Interp": frozenset({"semantics", "truth"}),
    "Dual": frozenset({"pairing"}),
    # Order is the only kind carrying ``sign``, and it carries it only
    # relative to the ordering named in its ``ordering`` payload.
    "Order": frozenset({"sign"}),
    "Conjecture": frozenset(),
}


def is_symmetric(kind: str) -> bool:
    _require_kind(kind)
    return kind in SYMMETRIC


def preserves(kind: str) -> frozenset:
    _require_kind(kind)
    return PRESERVES[kind]


def _require_kind(kind: str) -> None:
    if kind not in KINDS:
        raise EdgeError("unknown edge kind %r" % (kind,))


# --------------------------------------------------------------------------
# the composition table
# --------------------------------------------------------------------------
#
# Reading of the spec table's "composes with" column: `Eq` and `Iso` are the
# *neutral transports* of the algebra.  `Eq` is its two-sided identity; `Iso`
# is absorbed by every directed kind (transporting along an invertible witness
# neither creates nor destroys the directed content).  That reading is forced
# by the two examples the spec spells out elsewhere -- `Approx . Iso = Approx`
# with the same epsilon, and `Implies . Iso = Implies`.
#
# Every other cross-kind pair is *unlicensed* and composes to None: e.g. an
# Embed followed by a Quotient is not an Embed, not a Quotient, and the kernel
# has no name for it, so it refuses.

_NEUTRAL_ABSORBERS: Tuple[str, ...] = (
    "Embed",
    "Quotient",
    "Implies",
    "Approx",
    "Refine",
    "Interp",
)


# --------------------------------------------------------------------------
# limitors
# --------------------------------------------------------------------------
# Three kinds carry a payload that delimits what the edge claims: Approx an
# exact epsilon, Dual a pairing, Order an ordering.  They were written as three
# bespoke validations and three bespoke composition rules before anyone noticed
# they are one structure.
#
# A LIMITOR is the Navya-Nyaya *avacchedaka*: the mode under which a relation
# is taken.  Two edges between the same pair of objects under different
# limitors are DIFFERENT edges, not one edge with a label.  What varies between
# the three is only how limitors combine along a path, and each rule is a
# partial monoid operation:
#
#     Approx : epsilons ADD                      (total)
#     Dual   : pairings must MATCH               (partial)
#     Order  : orderings must MATCH              (partial)
#
# ``combine`` returns None for "not licensed", which is how a mismatch becomes
# an unlicensed composition rather than a silently transported property.
#
# Naming the structure buys one thing the three copies could not: the value
# space of a limitor becomes a first-class object, so its CARDINALITY can be
# measured.  See ``limitor_census``.


@dataclass(frozen=True)
class LimitorSpec:
    """How one edge kind's limitor is carried, checked and combined."""

    field: str          # the Edge field holding the value
    sort: str           # a name for the value space (the index sort)
    required: bool      # may the edge exist without it?
    why: str            # what is silently wrong if it is dropped

    def get(self, edge) -> Any:
        return getattr(edge, self.field)


def _check_eps(v: Any) -> None:
    if isinstance(v, float):
        raise EdgeError("epsilon must be an exact Fraction, never a float")
    if not isinstance(v, Fraction):
        raise EdgeError("Approx requires an exact Fraction epsilon")
    if v < 0:
        raise EdgeError("Approx epsilon must be >= 0")


def _check_name(v: Any) -> None:
    if not isinstance(v, str) or not v:
        raise EdgeError("limitor must be a non-empty name")


def _add(a, b):
    return (a if a is not None else Fraction(0)) + (b if b is not None else Fraction(0))


def _match(a, b):
    """Equal-or-unlicensed.  A None limitor never matches: an edge whose
    limitor was dropped cannot be composed, because there is nothing to check
    agreement against."""
    return a if (a is not None and a == b) else None


LIMITORS: Dict[str, LimitorSpec] = {
    "Approx": LimitorSpec("eps", "error-bound", True,
                          "an unbounded error would read as a bounded one"),
    "Dual": LimitorSpec("pairing", "pairing", False,
                        "two different dualities would compose to an identity"),
    "Order": LimitorSpec("ordering", "ordering", True,
                         "sign would transport between orderings that disagree"),
}

_CHECK = {"Approx": _check_eps, "Dual": _check_name, "Order": _check_name}
_COMBINE = {"Approx": _add, "Dual": _match, "Order": _match}


def limitor_of(kind: str) -> Optional[LimitorSpec]:
    _require_kind(kind)
    return LIMITORS.get(kind)


def combine_limitors(kind: str, a: Any, b: Any) -> Tuple[bool, Any]:
    """``(licensed, value)`` for composing two limitors of one kind."""
    if kind not in _COMBINE:
        return True, None
    v = _COMBINE[kind](a, b)
    if v is None and kind != "Approx":
        return False, None
    return True, v


def limitor_census(edges, verdict=None, profile=None) -> Dict[str, Dict[str, Any]]:
    """Distinct limitor values observed per sort, and the singleton verdict.

    An index that cannot be observed to have been dropped is one whose values
    are INDISTINGUISHABLE where the claim was checked: there the delimited and
    undelimited statements have the same extension, every check passes, and no
    correction is generated.

    Cardinality 1 is the crude test and it is NOT the criterion.  Theorem E of
    notes/INDEX_LAW.md (claude_arithmetic_breaker): if a group acts on the
    value space TRANSITIVELY, all fibres are carried onto one another by the
    action, so an invariant claim has the same verdict at every value however
    many there are.  Q(sqrt2) has two orderings, exchanged by conjugation, and
    the index is still unobservable for Galois-invariant objects.

    So ``latent_erratum`` below reports only the degenerate case.  A
    cardinality of 2 or more is NOT a clearance: it is a clearance only if no
    symmetry acts transitively on those values, which this function cannot see
    because the group is not carried on the edge.  Widening the value space
    does not help if the symmetry widens with it; only breaking it does.
    ``verdict(edge)`` is the claim's value at that index (default: the edge's
    target, which is what an Order edge records).  If it is NON-constant across
    the index values, the index is plainly OBSERVABLE and nothing further is
    needed.

    When the verdict IS constant the index is unobservable, and the useful
    question becomes WHY, because the two causes have opposite cures
    (notes/CONSTANCY_NOT_TRANSITIVITY.md, claude_arithmetic_breaker):

        structural (a transitive symmetry)  -> widening cannot help; the
                                               symmetry widens with the region.
                                               Break the symmetry.
        accidental (an unsampled cell)      -> widening is exactly the cure.

    Theorem D separates them WITHOUT knowing the group: if some other recorded
    invariant ``profile(edge)`` is non-constant across the index values, then no
    profile-preserving group acts transitively on them, so the verdict's
    constancy is accidental and widening is worth doing.  Passing ``profile``
    enables that test.  Without it this function cannot tell the two apart, and
    says so rather than guessing.

    Background: notes/THE_INDEX_IS_THE_SUBJECT.md, notes/INDEX_LAW.md
    Theorem E, notes/CONSTANCY_NOT_TRANSITIVITY.md Theorem D,
    notes/POSITIVITY_HAS_A_PLACE.md SS10.
    """
    if verdict is None:
        verdict = lambda e: e.dst
    seen: Dict[str, set] = {}
    verdicts: Dict[str, set] = {}
    profiles: Dict[str, set] = {}
    for e in edges:
        spec = LIMITORS.get(e.kind)
        if spec is None:
            continue
        v = spec.get(e)
        if v is None:
            continue
        seen.setdefault(spec.sort, set()).add(v)
        verdicts.setdefault(spec.sort, set()).add(verdict(e))
        if profile is not None:
            profiles.setdefault(spec.sort, set()).add(profile(e))
    out = {}
    for kind, spec in LIMITORS.items():
        vals = seen.get(spec.sort, set())
        out[spec.sort] = {
            "kind": kind,
            "values": sorted(vals, key=str),
            "cardinality": len(vals),
            # 0 = the sort never appeared; 1 = degenerate, a drop here is
            # certainly invisible.  >1 is NOT a clearance -- see the docstring:
            # a transitive symmetry makes any number of values act as one.
            "latent_erratum": len(vals) == 1,
            "observable": len(verdicts.get(spec.sort, set())) > 1,
            # Theorem D.  Only meaningful when the verdict is constant; None
            # means "cannot tell", which is the honest answer without a profile.
            "invisibility": (
                None if len(verdicts.get(spec.sort, set())) > 1
                else "accidental (widening helps)"
                if profile is not None and len(profiles.get(spec.sort, set())) > 1
                else "undetermined -- pass a profile, or no profile varies"
            ),
            "why": spec.why,
        }
    return out



_TABLE: Dict[Tuple[str, str], str] = {}


def _build_table() -> None:
    for k in KINDS:
        if k == "Conjecture":
            continue
        # Eq is the two-sided identity.
        _TABLE[("Eq", k)] = k
        _TABLE[(k, "Eq")] = k
    # idempotent same-kind composites
    for k in ("Iso", "Embed", "Quotient", "Implies", "Approx", "Refine", "Interp",
              "Order"):
        _TABLE[(k, k)] = k
    # Iso is absorbed by the directed kinds.
    for k in _NEUTRAL_ABSORBERS:
        _TABLE[("Iso", k)] = k
        _TABLE[(k, "Iso")] = k
    # Dual is symmetric and composes with Iso (staying a Dual) and with Dual.
    _TABLE[("Iso", "Dual")] = "Dual"
    _TABLE[("Dual", "Iso")] = "Dual"
    # Dual . Dual: only licensed when both edges name the SAME pairing, in
    # which case double dualisation is the identity up to iso.  Enforced in
    # compose(); the kind entry records the result.
    _TABLE[("Dual", "Dual")] = "Iso"


_build_table()


def composition_table() -> Tuple[Tuple[str, str, Optional[str]], ...]:
    """The full table as a sorted tuple of ``(left, right, result_or_None)``.

    All 100 ordered pairs appear.  Used by the tests to cover every ``None``.
    """
    out = []
    for l in KINDS:
        for r in KINDS:
            out.append((l, r, _TABLE.get((l, r))))
    return tuple(out)


def compose_kind(left: str, right: str) -> Optional[str]:
    """Kind-level composition.  ``None`` when the composite is not licensed."""
    _require_kind(left)
    _require_kind(right)
    COUNTERS.bump("edge.compose_kind")
    if left == "Conjecture" or right == "Conjecture":
        COUNTERS.bump("edge.conjecture_blocked")
        return None
    return _TABLE.get((left, right))


# --------------------------------------------------------------------------
# edges
# --------------------------------------------------------------------------


def _edge_id(kind, src, dst, eps, pairing, label, ordering=None) -> str:
    h = hashlib.blake2b(digest_size=12)
    for part in (kind, src, dst, "" if eps is None else "%d/%d" % (eps.numerator, eps.denominator),
                 pairing or "", label or "", ordering or ""):
        h.update(part.encode("utf-8"))
        h.update(b"\x1f")
    return "e" + h.hexdigest()


@dataclass(frozen=True)
class Edge:
    """A typed edge between two L0 addresses.

    ``eps`` is only meaningful for ``Approx`` and is an exact ``Fraction``.
    ``pairing`` is only meaningful for ``Dual``.
    ``witness`` is whatever ``check.check_edge`` needs; the edge algebra itself
    never inspects it.
    ``provenance`` records the edge_ids this edge was composed from (empty for
    a primitive edge), so a composite can be retracted with its parts.
    """

    kind: str
    src: str
    dst: str
    eps: Optional[Fraction] = None
    pairing: Optional[str] = None
    ordering: Optional[str] = None
    witness: Any = None
    label: str = ""
    provenance: Tuple[str, ...] = ()
    edge_id: str = field(default="", compare=True)

    def __post_init__(self) -> None:
        _require_kind(self.kind)
        # One loop replaces three hand-written payload blocks.  A required
        # limitor may not be defaulted: an edge whose index was dropped is
        # correct exactly while the index space is a singleton, and silently
        # wrong the moment it is not.
        if isinstance(self.eps, float):
            raise EdgeError("epsilon must be an exact Fraction, never a float")
        mine = LIMITORS.get(self.kind)
        for kind, spec in LIMITORS.items():
            v = getattr(self, spec.field)
            if kind == self.kind:
                if v is None:
                    if spec.required:
                        raise EdgeError(
                            "%s requires its limitor (%s): without it, %s"
                            % (kind, spec.sort, spec.why))
                else:
                    _CHECK[kind](v)
            elif v is not None:
                raise EdgeError("only %s carries a %s" % (kind, spec.sort))
        if not isinstance(self.src, str) or not isinstance(self.dst, str):
            raise EdgeError("edge endpoints are L0 addresses (str)")
        if not self.edge_id:
            object.__setattr__(
                self, "edge_id", _edge_id(self.kind, self.src, self.dst, self.eps,
                                          self.pairing, self.label, self.ordering)
            )
        COUNTERS.bump("edge.build")

    # -- faces -------------------------------------------------------------
    @property
    def symmetric(self) -> bool:
        return self.kind in SYMMETRIC

    @property
    def preserves(self) -> frozenset:
        return PRESERVES[self.kind]

    def render(self) -> str:
        tag = self.kind
        if self.kind == "Approx":
            tag = "Approx(%d/%d)" % (self.eps.numerator, self.eps.denominator)
        elif self.kind == "Dual" and self.pairing:
            tag = "Dual<%s>" % self.pairing
        elif self.kind == "Order":
            tag = "Order<%s>" % self.ordering
        return "%s: %s -> %s" % (tag, self.src[:8], self.dst[:8])


def invert(e: Edge) -> Optional[Edge]:
    """Reverse a symmetric edge; ``None`` for a directed one."""
    COUNTERS.bump("edge.invert")
    if not e.symmetric:
        return None
    return Edge(
        kind=e.kind,
        src=e.dst,
        dst=e.src,
        eps=e.eps,
        pairing=e.pairing,
        ordering=e.ordering,
        witness=e.witness,
        label=e.label,
        provenance=e.provenance or (e.edge_id,),
    )


def compose(e1: Edge, e2: Edge) -> Optional[Edge]:
    """Compose ``e1`` then ``e2``.  Total; ``None`` when not licensed.

    Licensing conditions, all of which must hold:
      * endpoints meet: ``e1.dst == e2.src``
      * the kind pair is in the table (this is where Conjecture dies)
      * ``Dual . Dual`` only when both name the same pairing
      * ``Order . Order`` only when both name the same ordering -- two order
        edges over *different* orderings do not compose, because sign is not
        transported between orderings (Q(sqrt2) has two, and conjugation swaps
        them).  This is the limitor as a binder rather than a label.
    Epsilon adds exactly; ``Approx . Iso`` and ``Iso . Approx`` keep epsilon.
    The composite preserves the intersection of the parts' preservation sets.
    """
    COUNTERS.bump("edge.compose")
    if e1.dst != e2.src:
        COUNTERS.bump("edge.compose_endpoint_mismatch")
        return None
    kind = compose_kind(e1.kind, e2.kind)
    if kind is None:
        COUNTERS.bump("edge.compose_unlicensed")
        return None
    # Limitor licensing, one rule for every kind that carries one.  Two edges
    # of the same limitor-bearing kind compose only if their limitors combine.
    if e1.kind == e2.kind and e1.kind in LIMITORS:
        spec = LIMITORS[e1.kind]
        ok, _ = combine_limitors(e1.kind, spec.get(e1), spec.get(e2))
        if not ok:
            COUNTERS.bump("edge.compose_limitor_mismatch")
            COUNTERS.bump("edge.compose_unlicensed")
            return None
    # The composite's limitor, from the same table.  When only one side bears
    # the kind (Iso;Approx, Iso;Dual) the limitor is carried through; when both
    # do, it is combined by that kind's rule.
    payload = {"eps": None, "pairing": None, "ordering": None}
    spec = LIMITORS.get(kind)
    if spec is not None:
        if e1.kind == kind and e2.kind == kind:
            _, payload[spec.field] = combine_limitors(kind, spec.get(e1), spec.get(e2))
        else:
            bearer = e1 if e1.kind == kind else e2
            payload[spec.field] = spec.get(bearer)
    eps, pairing, ordering = payload["eps"], payload["pairing"], payload["ordering"]
    label = "(%s;%s)" % (e1.label or e1.kind, e2.label or e2.kind)
    return Edge(
        kind=kind,
        src=e1.src,
        dst=e2.dst,
        eps=eps,
        pairing=pairing,
        ordering=ordering,
        witness=("compose", e1.witness, e2.witness),
        label=label,
        provenance=(e1.edge_id, e2.edge_id),
    )


def compose_path(edges) -> Optional[Edge]:
    """Left fold of ``compose`` over a non-empty sequence.  ``None`` if any
    step is unlicensed."""
    edges = tuple(edges)
    if not edges:
        return None
    acc = edges[0]
    for e in edges[1:]:
        acc = compose(acc, e)
        if acc is None:
            return None
    return acc
