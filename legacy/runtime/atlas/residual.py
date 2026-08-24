"""Residuals of the atlas transitions, as **computed objects**.

`notes/ATLAS_OF_N.md` Sec.8 tabulates one residual per transition map: a group,
a torsor, a cohomology class, an invariant, or an obstruction.  This module
builds each of them as an object with operations that are exhaustively checked
on a stated finite range -- never as a label, never as a string.

Everything here is CPU-only, pure stdlib, exact (`int` / `fractions.Fraction`),
deterministic (no set iteration, no clock, no `hash()`), and counted.

What is a residual, operationally
---------------------------------
A ``Residual`` carries a *declared* triviality flag and a ``verify`` method that
recomputes it.  A residual claimed trivial that is not trivial is therefore
caught by construction: ``verify`` returns a report whose ``agrees`` field is
False, and every caller in ``transitions.py`` refuses to install the edge.
That is the "residual claimed trivial that isn't" control of the test suite.

Contents
--------
``FiniteGroup``   closure / associativity / inverse checked, orbits, index
``symmetric_group(n)``, ``cyclic_group(n)``, ``trivial_group()``
``Torsor``        freeness + transitivity + regularity checked exhaustively
``Cocycle``       normalized 2-cocycle, cocycle identity checked, coboundary
                  search exhaustive on a stated bound, plus the exact
                  exponent argument valid for every (b, n)
``Residual``      the container attached to a transition
"""

from __future__ import annotations

import itertools
from dataclasses import dataclass, field
from fractions import Fraction
from typing import Any, Callable, Dict, Optional, Sequence, Tuple

from ..kernel.term import Counters

__all__ = [
    "ResidualError",
    "FiniteGroup",
    "GroupReport",
    "symmetric_group",
    "cyclic_group",
    "trivial_group",
    "Torsor",
    "TorsorReport",
    "Cocycle",
    "CocycleReport",
    "carry_cocycle",
    "exhaustive_section_search",
    "splitting_exponent_argument",
    "Residual",
    "ResidualReport",
    "GROUP",
    "TORSOR",
    "COCYCLE",
    "INVARIANT",
    "OBSTRUCTION",
]

GROUP = "group"
TORSOR = "torsor"
COCYCLE = "cocycle"
INVARIANT = "invariant"
OBSTRUCTION = "obstruction"

RESIDUAL_KINDS = (GROUP, TORSOR, COCYCLE, INVARIANT, OBSTRUCTION)

#: exhaustive associativity is O(|G|^3); above this the group's law is inherited
#: from function composition and the cubic check is *not* run (and says so).
ASSOC_LIMIT = 24

#: exhaustive coboundary search is O(coeff ** modulus); above this the search is
#: not run and the report says ``searched=False``.
COBOUNDARY_LIMIT = 4096


class ResidualError(Exception):
    """A residual was built or queried outside its stated finite range."""


def _counters(c: Optional[Counters]) -> Counters:
    return c if c is not None else Counters()


# ---------------------------------------------------------------------------
# finite groups
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class GroupReport:
    name: str
    order: int
    closed: bool
    associative: Optional[bool]      # None = not checked (order > ASSOC_LIMIT)
    has_identity: bool
    has_inverses: bool
    abelian: bool
    steps: int

    @property
    def is_group(self) -> bool:
        return (self.closed and self.has_identity and self.has_inverses
                and self.associative is not False)

    def render(self) -> str:
        assoc = {None: "assoc=inherited", True: "assoc=exhaustive",
                 False: "assoc=FAILED"}[self.associative]
        return ("%s order=%d closed=%s %s id=%s inv=%s abelian=%s steps=%d"
                % (self.name, self.order, self.closed, assoc, self.has_identity,
                   self.has_inverses, self.abelian, self.steps))


@dataclass(frozen=True)
class FiniteGroup:
    """A finite group given by its element list and its law.

    ``elements`` must be a deterministic tuple (sorted at construction), so two
    runs produce identical Cayley digests.
    """

    name: str
    elements: Tuple[Any, ...]
    op: Callable[[Any, Any], Any]
    inv: Callable[[Any], Any]
    identity: Any

    @property
    def order(self) -> int:
        return len(self.elements)

    def index_of(self, g: Any) -> int:
        try:
            return self.elements.index(g)
        except ValueError:
            raise ResidualError("%r is not an element of %s" % (g, self.name))

    def verify(self, counters: Optional[Counters] = None,
               assoc_limit: int = ASSOC_LIMIT) -> GroupReport:
        c = _counters(counters)
        start = c.get("atlas.group.op")
        members = set(self.elements)
        closed = True
        for a in self.elements:
            for b in self.elements:
                c.bump("atlas.group.op")
                if self.op(a, b) not in members:
                    closed = False
        has_id = all(self.op(self.identity, a) == a and self.op(a, self.identity) == a
                     for a in self.elements)
        c.bump("atlas.group.op", 2 * self.order)
        has_inv = all(self.op(a, self.inv(a)) == self.identity
                      and self.op(self.inv(a), a) == self.identity
                      for a in self.elements)
        c.bump("atlas.group.op", 2 * self.order)
        abelian = all(self.op(a, b) == self.op(b, a)
                      for a in self.elements for b in self.elements)
        c.bump("atlas.group.op", self.order * self.order)
        assoc: Optional[bool] = None
        if self.order <= assoc_limit:
            assoc = True
            for a in self.elements:
                for b in self.elements:
                    for d in self.elements:
                        c.bump("atlas.group.op", 2)
                        if self.op(self.op(a, b), d) != self.op(a, self.op(b, d)):
                            assoc = False
        return GroupReport(self.name, self.order, closed, assoc, has_id, has_inv,
                           abelian, c.get("atlas.group.op") - start)

    # -- actions ------------------------------------------------------------

    def orbit(self, point: Any, action: Callable[[Any, Any], Any],
              counters: Optional[Counters] = None) -> Tuple[Any, ...]:
        c = _counters(counters)
        seen = []
        for g in self.elements:
            c.bump("atlas.group.act")
            p = action(g, point)
            if p not in seen:
                seen.append(p)
        return tuple(sorted(seen, key=repr))

    def orbits(self, points: Sequence[Any], action: Callable[[Any, Any], Any],
               counters: Optional[Counters] = None) -> Tuple[Tuple[Any, ...], ...]:
        c = _counters(counters)
        out: list = []
        placed: set = set()
        for p in points:
            if p in placed:
                continue
            orb = self.orbit(p, action, c)
            for q in orb:
                placed.add(q)
            out.append(orb)
        return tuple(out)

    def stabilizer(self, point: Any, action: Callable[[Any, Any], Any],
                   counters: Optional[Counters] = None) -> Tuple[Any, ...]:
        c = _counters(counters)
        out = []
        for g in self.elements:
            c.bump("atlas.group.act")
            if action(g, point) == point:
                out.append(g)
        return tuple(out)

    def index_of_subgroup(self, sub: "FiniteGroup") -> int:
        if self.order % sub.order:
            raise ResidualError("Lagrange violated: %d does not divide %d"
                                % (sub.order, self.order))
        return self.order // sub.order

    def digest(self) -> str:
        """A deterministic fingerprint of the Cayley table (for reports)."""
        import hashlib
        h = hashlib.blake2b(digest_size=8)
        idx = {g: i for i, g in enumerate(self.elements)}
        for a in self.elements:
            for b in self.elements:
                h.update(b"%d," % idx[self.op(a, b)])
        return h.hexdigest()

    def render(self) -> str:
        return "%s(order=%d, cayley=%s)" % (self.name, self.order, self.digest())


def symmetric_group(n: int) -> FiniteGroup:
    """S_n as permutations of ``range(n)``, written as tuples.

    ``op(a, b)`` is composition ``a after b``: ``(a*b)(i) = a[b[i]]``.
    """
    if n < 0:
        raise ResidualError("S_n needs n >= 0")
    elems = tuple(sorted(itertools.permutations(range(n))))

    def op(a, b):
        return tuple(a[b[i]] for i in range(n))

    def inv(a):
        out = [0] * n
        for i, v in enumerate(a):
            out[v] = i
        return tuple(out)

    return FiniteGroup("S_%d" % n, elems, op, inv, tuple(range(n)))


def cyclic_group(n: int) -> FiniteGroup:
    if n < 1:
        raise ResidualError("Z/n needs n >= 1")
    elems = tuple(range(n))
    return FiniteGroup("Z/%d" % n, elems,
                       lambda a, b: (a + b) % n, lambda a: (-a) % n, 0)


def trivial_group(name: str = "1") -> FiniteGroup:
    return FiniteGroup(name, ((),), lambda a, b: (), lambda a: (), ())


# ---------------------------------------------------------------------------
# torsors
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class TorsorReport:
    name: str
    group_order: int
    point_count: int
    free: bool
    transitive: bool
    steps: int
    free_defect: Optional[Tuple[Any, Any]] = None       # (g != e, p) with g.p = p
    transitive_defect: Optional[Tuple[Any, Any]] = None  # (p, q) unreachable

    @property
    def is_torsor(self) -> bool:
        return self.free and self.transitive and self.group_order == self.point_count

    def render(self) -> str:
        return ("%s |G|=%d |P|=%d free=%s transitive=%s regular=%s steps=%d"
                % (self.name, self.group_order, self.point_count, self.free,
                   self.transitive, self.is_torsor, self.steps))


@dataclass(frozen=True)
class Torsor:
    """A set with a group action, checked free + transitive by exhaustion."""

    name: str
    group: FiniteGroup
    points: Tuple[Any, ...]
    act: Callable[[Any, Any], Any]

    def verify(self, counters: Optional[Counters] = None) -> TorsorReport:
        c = _counters(counters)
        start = c.get("atlas.torsor.act")
        free = True
        free_defect = None
        for p in self.points:
            for g in self.group.elements:
                c.bump("atlas.torsor.act")
                if g != self.group.identity and self.act(g, p) == p:
                    free = False
                    if free_defect is None:
                        free_defect = (g, p)
        transitive = True
        trans_defect = None
        pset = set(self.points)
        for p in self.points:
            reach = set()
            for g in self.group.elements:
                c.bump("atlas.torsor.act")
                reach.add(self.act(g, p))
            missing = pset - reach
            if missing:
                transitive = False
                if trans_defect is None:
                    trans_defect = (p, sorted(missing, key=repr)[0])
        return TorsorReport(self.name, self.group.order, len(self.points), free,
                            transitive, c.get("atlas.torsor.act") - start,
                            free_defect, trans_defect)

    def translate(self, p: Any, q: Any,
                  counters: Optional[Counters] = None) -> Any:
        """The unique ``g`` with ``g.p = q``.  Raises if it is not unique."""
        c = _counters(counters)
        found = []
        for g in self.group.elements:
            c.bump("atlas.torsor.act")
            if self.act(g, p) == q:
                found.append(g)
        if len(found) != 1:
            raise ResidualError("%s: %d group elements carry %r to %r (want exactly 1)"
                                % (self.name, len(found), p, q))
        return found[0]


# ---------------------------------------------------------------------------
# the carry cocycle
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class CocycleReport:
    name: str
    modulus: int
    coeff: int
    normalized: bool
    is_cocycle: bool
    coboundary_searched: bool
    is_coboundary: Optional[bool]
    homomorphic_section_exists: Optional[bool]
    section_search_size: int
    exponent_lhs: int          # exponent of Z/b^n (+) Z/b   = lcm(b^n, b)
    exponent_rhs: int          # exponent of Z/b^{n+1}       = b^{n+1}
    nonzero_values: int
    steps: int

    @property
    def class_is_nonzero(self) -> bool:
        """The class is nonzero iff the extension does not split.

        Two independent certificates, both exact: the exponent argument (valid
        for every b >= 2, n >= 1) and, when the search was affordable, the
        exhaustive absence of a coboundary / of a homomorphic section.
        """
        by_exponent = self.exponent_lhs < self.exponent_rhs
        by_search = (self.is_coboundary is False) if self.coboundary_searched else True
        return bool(self.is_cocycle and by_exponent and by_search)

    def render(self) -> str:
        return ("%s c_n on Z/%d -> Z/%d  cocycle=%s normalized=%s "
                "coboundary=%s(searched=%s over %d sections) exponent %d<%d "
                "nonzero_values=%d class!=0 -> %s"
                % (self.name, self.modulus, self.coeff, self.is_cocycle,
                   self.normalized, self.is_coboundary, self.coboundary_searched,
                   self.section_search_size, self.exponent_lhs, self.exponent_rhs,
                   self.nonzero_values, self.class_is_nonzero))


@dataclass(frozen=True)
class Cocycle:
    """A normalized 2-cocycle on Z/modulus with values in Z/coeff."""

    name: str
    modulus: int
    coeff: int
    values: Tuple[Tuple[int, ...], ...]      # values[u][v]

    def __call__(self, u: int, v: int) -> int:
        return self.values[u % self.modulus][v % self.modulus]

    def verify(self, counters: Optional[Counters] = None,
               coboundary_limit: int = COBOUNDARY_LIMIT) -> CocycleReport:
        c = _counters(counters)
        start = c.get("atlas.cocycle.step")
        m, b = self.modulus, self.coeff
        normalized = all(self(0, v) == 0 and self(u, 0) == 0 for u in range(m) for v in range(m))
        c.bump("atlas.cocycle.step", 2 * m * m)
        ok = True
        for u in range(m):
            for v in range(m):
                for w in range(m):
                    c.bump("atlas.cocycle.step")
                    lhs = (self(u, v) + self((u + v) % m, w)) % b
                    rhs = (self(v, w) + self(u, (v + w) % m)) % b
                    if lhs != rhs:
                        ok = False
        nonzero = sum(1 for u in range(m) for v in range(m) if self(u, v) % b)
        # exhaustive coboundary search: c = delta f for some f : Z/m -> Z/b?
        searched = b ** m <= coboundary_limit
        is_cob: Optional[bool] = None
        size = b ** m
        if searched:
            is_cob = False
            for f in itertools.product(range(b), repeat=m):
                c.bump("atlas.cocycle.step", m)
                if all((f[u] + f[v] - f[(u + v) % m]) % b == self(u, v) % b
                       for u in range(m) for v in range(m)):
                    is_cob = True
                    break
        hom_section = None
        if searched:
            hom_section = exhaustive_section_search(b, m, coboundary_limit, c)
        lhs_exp, rhs_exp = splitting_exponent_argument(b, m)
        return CocycleReport(self.name, m, b, normalized, ok, searched, is_cob,
                             hom_section, size, lhs_exp, rhs_exp, nonzero,
                             c.get("atlas.cocycle.step") - start)


def carry_cocycle(b: int, n: int) -> Cocycle:
    """The digit section's coboundary for 0 -> Z/b -> Z/b^{n+1} -> Z/b^n -> 0.

    ``c(u, v) = (s(u) + s(v) - s(u+v)) / b^n`` with ``s`` the least-nonnegative
    digit section; equivalently "1 iff the addition carries out of position
    n-1" (ATLAS_OF_N Prop. 2.11).
    """
    if b < 2 or n < 1:
        raise ResidualError("carry_cocycle needs b >= 2, n >= 1")
    m = b ** n
    values = tuple(tuple(((u + v) // m) % b for v in range(m)) for u in range(m))
    return Cocycle("carry(b=%d,n=%d)" % (b, n), m, b, values)


def exhaustive_section_search(b: int, m: int, limit: int = COBOUNDARY_LIMIT,
                              counters: Optional[Counters] = None) -> Optional[bool]:
    """Does *any* set-section ``s : Z/m -> Z/(m*b)`` happen to be additive?

    Enumerates every one of the ``b ** m`` sections (not merely those fixed by
    a generator).  Returns ``None`` when the enumeration exceeds ``limit``.
    """
    c = _counters(counters)
    if b ** m > limit:
        return None
    big = m * b
    for t in itertools.product(range(b), repeat=m):
        s = [u + m * t[u] for u in range(m)]
        c.bump("atlas.cocycle.section")
        if all((s[u] + s[v]) % big == s[(u + v) % m] for u in range(m) for v in range(m)):
            return True
    return False


def splitting_exponent_argument(b: int, m: int) -> Tuple[int, int]:
    """(exponent of Z/m (+) Z/b, exponent of Z/(m*b)) -- exact, every (b, m).

    ATLAS_OF_N Prop. 2.11: the class vanishes iff the extension splits, iff the
    two exponents agree.  ``lcm(m, b) < m*b`` whenever ``gcd(m, b) > 1``, which
    for ``m = b^n``, ``n >= 1``, ``b >= 2`` is always.
    """
    from math import lcm
    return lcm(m, b), m * b


# ---------------------------------------------------------------------------
# the residual container
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class ResidualReport:
    key: str
    kind: str
    declared_trivial: bool
    computed_trivial: bool
    order: Optional[int]
    detail: str
    ok: bool

    @property
    def agrees(self) -> bool:
        return self.declared_trivial == self.computed_trivial

    def render(self) -> str:
        return ("residual %-16s %-11s order=%-4s declared_trivial=%-5s "
                "computed_trivial=%-5s ok=%s  %s"
                % (self.key, self.kind, self.order, self.declared_trivial,
                   self.computed_trivial, self.ok and self.agrees, self.detail))


@dataclass(frozen=True)
class Residual:
    """The residual attached to one transition of the atlas.

    ``trivial`` is the *claim*.  ``verify`` recomputes it from ``obj`` and the
    caller compares.  Nothing here believes the claim.
    """

    key: str
    kind: str
    obj: Any
    trivial: bool
    statement: str
    extra: Tuple[Tuple[str, Any], ...] = ()
    #: for ``INVARIANT`` residuals: what "trivial" means for this invariant.
    #: Default: all recorded values agree (i.e. the charts do not differ).
    trivial_test: Optional[Callable[[Any], bool]] = None

    def __post_init__(self) -> None:
        if self.kind not in RESIDUAL_KINDS:
            raise ResidualError("unknown residual kind %r" % (self.kind,))

    @property
    def order(self) -> Optional[int]:
        if self.kind == GROUP:
            return self.obj.order
        if self.kind == TORSOR:
            return self.obj.group.order
        return None

    def verify(self, counters: Optional[Counters] = None) -> ResidualReport:
        c = _counters(counters)
        if self.kind == GROUP:
            rep = self.obj.verify(c)
            return ResidualReport(self.key, self.kind, self.trivial,
                                  self.obj.order == 1, self.obj.order,
                                  rep.render(), rep.is_group)
        if self.kind == TORSOR:
            rep = self.obj.verify(c)
            return ResidualReport(self.key, self.kind, self.trivial,
                                  self.obj.group.order == 1, self.obj.group.order,
                                  rep.render(), rep.is_torsor)
        if self.kind == COCYCLE:
            rep = self.obj.verify(c)
            return ResidualReport(self.key, self.kind, self.trivial,
                                  not rep.class_is_nonzero, None,
                                  rep.render(), rep.is_cocycle and rep.normalized)
        if self.kind == INVARIANT:
            # obj is a tuple of (label, value) pairs; by default trivial means
            # "all recorded values agree", but a residual may name its own test.
            if self.trivial_test is not None:
                same = bool(self.trivial_test(self.obj))
            else:
                vals = tuple(v for _, v in self.obj)
                same = len(set(map(repr, vals))) <= 1
            return ResidualReport(self.key, self.kind, self.trivial, same, None,
                                  "; ".join("%s=%s" % (k, v) for k, v in self.obj), True)
        # OBSTRUCTION: obj is a callable returning (holds, witness)
        holds, witness = self.obj()
        return ResidualReport(self.key, self.kind, self.trivial, not holds, None,
                              "obstruction holds=%s witness=%s" % (holds, witness), True)

    def render(self) -> str:
        return "%s [%s] %s" % (self.key, self.kind, self.statement)
