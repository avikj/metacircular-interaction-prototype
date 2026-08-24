"""L5 -- the trusted checker.  Keep this file small; it is the only code that
must be right.

TRUST ASSUMPTIONS (exhaustive; nothing else may be assumed by anything here)
--------------------------------------------------------------------------
T1  ``hashlib.blake2b`` is collision resistant, and ``term._digest`` is an
    injective-enough encoding of (head symbol, sort address, child addresses).
    Every address this file compares is *recomputed* with
    ``Term.recompute_addr()``; the intern table is never believed.
T2  ``term.py``'s sort discipline, capture-avoiding substitution and
    normal-order beta reduction are correct.  CRYSTAL.md Sec.5 puts "exact term
    encoding, typechecking, content addressing" inside the trusted heart, so
    L0 is trusted *by construction of the spec*, not by convenience.
T3  The ``CheckContext`` supplied by the caller.  Its ``axioms`` and
    ``certificates`` are the only unproved inputs in the system.  The checker
    verifies that a step's endpoints are exactly the declared axiom's sides; it
    does **not** verify the mathematical content of an axiom or certificate.
    Widening that dict is the only way to widen what the kernel will believe.
T4  Python's exact integer / ``fractions.Fraction`` arithmetic.

EXPLICITLY NOT TRUSTED
    The e-graph, its union-find, its proof forest, its edge ids, its
    congruence bookkeeping, its class caches, any assertion that two addresses
    are equal, and any path handed to us by anyone.  ``check_path`` re-derives
    every step from the terms themselves.  A path produced by a broken e-graph
    and a path fabricated by an adversary are indistinguishable to this file,
    and both are rejected unless every step independently checks out.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from fractions import Fraction
from typing import Any, Dict, List, Optional, Sequence, Tuple

from . import term as T
from . import edges as E
from .edges import Edge, compose_path

__all__ = [
    "Refl", "Axiom", "Beta", "Instantiate", "Certificate", "IsoWitness", "Conjectural",
    "Step", "CheckContext", "check_step", "check_path", "check_edge", "check_composite",
]

MAX_DEPTH = 64


# -- witnesses --------------------------------------------------------------

@dataclass(frozen=True)
class Refl:
    """Both endpoints are the same address."""


@dataclass(frozen=True)
class Axiom:
    """A declared equation, valid only if ``name`` is in ``ctx.axioms``."""
    name: str


@dataclass(frozen=True)
class Beta:
    """The endpoints have the same beta normal form.  Checked, not believed."""


@dataclass(frozen=True)
class Instantiate:
    """``ctx.axioms[name]`` with opaque constants replaced per ``subst``."""
    name: str
    subst: Tuple[Tuple[str, Any], ...] = ()


@dataclass(frozen=True)
class Certificate:
    """A declared non-equational certificate (Quotient sufficiency, Implies, ...)."""
    name: str


@dataclass(frozen=True)
class IsoWitness:
    """An invertible witness: ``to : A -> B``, ``fro : B -> A``, both closed."""
    to: Any
    fro: Any


@dataclass(frozen=True)
class Conjectural:
    """Never accepted.  Present so search can carry it without laundering it."""
    label: str = ""


# -- proof steps ------------------------------------------------------------

@dataclass(frozen=True)
class Step:
    """One equality step ``src = dst``.

    ``kind`` is ``"assumption"`` (justified by ``witness``) or ``"congruence"``
    (justified by ``subproofs``, one path per argument position).
    ``edge_id`` is bookkeeping only; the checker ignores it.
    """
    src: str
    dst: str
    kind: str
    witness: Any = None
    edge_id: Optional[str] = None
    subproofs: Tuple[Tuple["Step", ...], ...] = ()

    def render(self) -> str:
        return "%s %s->%s [%s]" % (self.kind, self.src[:8], self.dst[:8],
                                   type(self.witness).__name__ if self.witness else "-")


@dataclass
class CheckContext:
    axioms: Dict[str, Tuple[Any, Any]] = field(default_factory=dict)
    certificates: Dict[str, Tuple[str, str, str, Optional[Fraction]]] = field(default_factory=dict)
    fuel: int = 100000
    errors: List[str] = field(default_factory=list)
    counters: T.Counters = field(default_factory=T.Counters)

    def declare_axiom(self, name: str, lhs: T.Term, rhs: T.Term) -> None:
        if lhs.sort is not rhs.sort:
            raise T.SortError("axiom %s relates terms of different sorts" % name)
        self.axioms[name] = (lhs, rhs)

    def declare_certificate(self, name, kind, src, dst, eps=None,
                            limitor=None) -> None:
        """Declare an unproved input.

        ``limitor`` pins the index the certificate is *for*.  A certificate
        that does not name its limitor is a certificate for an unindexed
        claim, and offering it for an indexed edge is exactly the error this
        kernel's own mathematics is about (notes/THE_INDEX_IS_THE_SUBJECT.md).
        For ``Approx`` the limitor is the epsilon, so ``eps`` is accepted as
        its spelling and the two must agree.
        """
        if isinstance(eps, float):
            raise T.KernelError("certificate epsilon must be exact")
        if eps is not None and limitor is not None and eps != limitor:
            raise T.KernelError("certificate names two different limitors")
        if limitor is None:
            limitor = eps
        spec = E.LIMITORS.get(kind)
        if spec is not None and spec.required and limitor is None:
            raise T.KernelError(
                "a %s certificate must name its limitor (%s): without it the "
                "certificate is for an unindexed claim" % (kind, spec.sort))
        self.certificates[name] = (kind, src, dst, limitor)


def _fail(ctx: CheckContext, msg: str) -> bool:
    ctx.counters.bump("check.reject")
    ctx.errors.append(msg)
    return False


def _term(ctx: CheckContext, addr: str) -> Optional[T.Term]:
    """Address -> term, with the address independently recomputed (T1)."""
    ctx.counters.bump("check.resolve")
    t = T.lookup(addr)
    if t is None:
        _fail(ctx, "unknown address %s" % addr[:8])
        return None
    if t.recompute_addr() != addr:
        _fail(ctx, "intern table lied about %s" % addr[:8])
        return None
    return t


def _sides(ctx, lhs: T.Term, rhs: T.Term, step: Step) -> bool:
    a, b = lhs.recompute_addr(), rhs.recompute_addr()
    if (step.src, step.dst) == (a, b) or (step.src, step.dst) == (b, a):
        return True
    return _fail(ctx, "step %s->%s does not match witness sides" % (step.src[:8], step.dst[:8]))


def check_step(step: Step, ctx: CheckContext, depth: int = 0) -> bool:
    """Validate one step from the terms alone."""
    ctx.counters.bump("check.step")
    if depth > MAX_DEPTH:
        return _fail(ctx, "proof nesting exceeded %d" % MAX_DEPTH)
    src, dst = _term(ctx, step.src), _term(ctx, step.dst)
    if src is None or dst is None:
        return False
    if src.sort is not dst.sort:
        return _fail(ctx, "step relates sorts %s and %s" % (src.sort.pretty(), dst.sort.pretty()))

    if step.kind == "congruence":
        if src.head != dst.head or src.head not in (T.APP, T.LAM):
            return _fail(ctx, "congruence on non-congruent heads")
        if src.head == T.LAM and src.dom is not dst.dom:
            return _fail(ctx, "congruence across different binder domains")
        kids = tuple(zip(src.children, dst.children))
        if len(step.subproofs) != len(kids):
            return _fail(ctx, "congruence arity mismatch")
        for (a, b), sub in zip(kids, step.subproofs):
            if not check_path(sub, a.recompute_addr(), b.recompute_addr(), ctx, depth + 1):
                return False
        ctx.counters.bump("check.congruence")
        return True

    if step.kind != "assumption":
        return _fail(ctx, "unknown step kind %r" % (step.kind,))

    w = step.witness
    if isinstance(w, Conjectural):
        ctx.counters.bump("check.conjecture_rejected")
        return _fail(ctx, "conjectural step may never enter an accepted derivation")
    if isinstance(w, Refl):
        return step.src == step.dst or _fail(ctx, "Refl between distinct addresses")
    if isinstance(w, Beta):
        n1 = T.beta_normal(src, ctx.fuel)
        n2 = T.beta_normal(dst, ctx.fuel)
        if n1 is None or n2 is None:
            return _fail(ctx, "beta witness ran out of fuel")
        ctx.counters.bump("check.beta")
        return n1 is n2 or _fail(ctx, "beta normal forms differ")
    if isinstance(w, Axiom):
        got = ctx.axioms.get(w.name)
        if got is None:
            return _fail(ctx, "undeclared axiom %r" % (w.name,))
        ctx.counters.bump("check.axiom")
        return _sides(ctx, got[0], got[1], step)
    if isinstance(w, Instantiate):
        got = ctx.axioms.get(w.name)
        if got is None:
            return _fail(ctx, "undeclared axiom %r" % (w.name,))
        mapping = dict(w.subst)
        try:
            lhs = T.subst_consts(got[0], mapping)
            rhs = T.subst_consts(got[1], mapping)
        except T.SortError as exc:
            return _fail(ctx, "instantiation ill-sorted: %s" % exc)
        ctx.counters.bump("check.instantiate")
        return _sides(ctx, lhs, rhs, step)
    return _fail(ctx, "unusable equality witness %r" % (type(w).__name__,))


def check_path(steps: Sequence[Step], src: str, dst: str, ctx: CheckContext,
               depth: int = 0) -> bool:
    """Validate that ``steps`` is a contiguous chain of valid steps ``src=dst``.

    This is the function that makes an ``explain`` output independent of the
    e-graph that produced it: nothing but ``steps`` and ``ctx`` is consulted.
    """
    ctx.counters.bump("check.path")
    steps = tuple(steps)
    if not steps:
        return src == dst or _fail(ctx, "empty path between distinct addresses")
    if steps[0].src != src or steps[-1].dst != dst:
        return _fail(ctx, "path endpoints do not match the claimed equality")
    for i in range(len(steps) - 1):
        if steps[i].dst != steps[i + 1].src:
            return _fail(ctx, "path is not contiguous at step %d" % i)
    for s in steps:
        if not check_step(s, ctx, depth):
            return False
    return True


def check_edge(edge: Edge, ctx: CheckContext) -> bool:
    """Validate that a proposed L1 edge's witness actually justifies it."""
    ctx.counters.bump("check.edge")
    if edge.kind == "Conjecture":
        ctx.counters.bump("check.conjecture_rejected")
        return _fail(ctx, "Conjecture edges are never accepted")
    if edge.kind == "Eq":
        if not isinstance(edge.witness, (tuple, list)):
            return _fail(ctx, "Eq edge needs a proof path witness")
        return check_path(tuple(edge.witness), edge.src, edge.dst, ctx)
    if edge.kind == "Iso":
        w = edge.witness
        if not isinstance(w, IsoWitness):
            return _fail(ctx, "Iso edge needs an IsoWitness")
        a, b = _term(ctx, edge.src), _term(ctx, edge.dst)
        if a is None or b is None:
            return False
        to, fro = w.to, w.fro
        if to.sort is not T.arrow(a.sort, b.sort) or fro.sort is not T.arrow(b.sort, a.sort):
            return _fail(ctx, "iso witness has the wrong sort")
        if not (to.is_closed and fro.is_closed):
            return _fail(ctx, "iso witness is not closed")
        # transport: to(a) = b and fro(b) = a
        for f, x, y in ((to, a, b), (fro, b, a)):
            n = T.beta_normal(T.App(f, x), ctx.fuel)
            if n is None:
                return _fail(ctx, "iso transport ran out of fuel")
            if n is not T.beta_normal(y, ctx.fuel):
                return _fail(ctx, "iso witness does not transport the endpoints")
        # invertibility: fro(to(p)) = p and to(fro(q)) = q on fresh probes
        for f, g, s in ((to, fro, a.sort), (fro, to, b.sort)):
            p = T.Const("%probe%" + s.addr, s)
            n = T.beta_normal(T.App(g, T.App(f, p)), ctx.fuel)
            if n is None or n is not p:
                return _fail(ctx, "iso witness is not invertible")
        ctx.counters.bump("check.iso")
        return True
    got = ctx.certificates.get(getattr(edge.witness, "name", None)) \
        if isinstance(edge.witness, Certificate) else None
    if got is None:
        return _fail(ctx, "%s edge needs a declared Certificate" % edge.kind)
    kind, src, dst, cert_limitor = got
    if (kind, src, dst) != (edge.kind, edge.src, edge.dst):
        return _fail(ctx, "certificate does not match the edge it is offered for")
    # The certificate must be for the SAME index as the edge.  Previously this
    # was checked for Approx alone, so a Dual certificate could be offered for
    # an edge naming a different pairing -- the kernel's own species of error.
    spec = E.LIMITORS.get(edge.kind)
    if spec is not None and cert_limitor != spec.get(edge):
        return _fail(ctx, "certificate limitor %r does not match edge %s %r"
                     % (cert_limitor, spec.sort, spec.get(edge)))
    ctx.counters.bump("check.certificate")
    return True


def check_composite(edges: Sequence[Edge], ctx: CheckContext) -> Optional[Edge]:
    """Check every edge, then compose.  ``None`` if anything fails or the
    composite is unlicensed.  A Conjecture anywhere kills the whole composite."""
    ctx.counters.bump("check.composite")
    edges = tuple(edges)
    if not edges:
        return None
    for e in edges:
        if not check_edge(e, ctx):
            return None
    out = compose_path(edges)
    if out is None:
        _fail(ctx, "composite is not licensed by the edge algebra")
    return out
