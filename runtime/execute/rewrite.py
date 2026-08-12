"""L3 -- checked rewriting from accepted equalities.

CRYSTAL.md Sec.2 L3:

    Every accepted equality may become a rewrite; every iso a transport; ...

This module implements the first clause and nothing else.  The discipline it
enforces is a single sentence:

    **Every rewrite application emits a proof path, that path is handed to
    ``kernel/check.py`` before the rewritten term is returned, and a rewrite
    whose justification the checker rejects is never applied.**

There is no unchecked application path in this file.  ``apply_rule`` returns
``None`` (and bumps ``rewrite.rejected``) rather than a term whose
justification failed.  ``runtime/tests/test_execute.py`` plants a false rule
and asserts exactly that.

How a rule is expressed in the kernel's IR
------------------------------------------
The kernel has no pattern variables.  It has something better for this
purpose: ``check.Instantiate(name, subst)``, which substitutes *opaque
constants* into a declared axiom's two sides and compares addresses.  So a
rewrite rule here is

    a declared equational axiom ``name : lhs = rhs``
    together with a set of ``Const`` **symbols of ``lhs``/``rhs`` designated as
    schematic** (the rule's variables).

Matching binds those symbols to terms; application is ``term.subst_consts``;
the justification is ``Instantiate(name, sigma)`` -- a witness the trusted
checker already knows how to verify, with no new trusted code.

Two consequences worth stating.

* ``Eq`` is symmetric, so a rule is usable in **both directions**.  The
  checker's ``_sides`` accepts a step in either order, so the backward
  application is checked by exactly the same witness.
* Bindings are required to be **closed** terms.  ``term.subst_consts`` does not
  shift de Bruijn indices, so substituting an open term underneath a binder
  would capture.  Refusing open bindings is the cheapest sound rule and it is
  enforced in ``match`` (counter ``rewrite.match_open_refused``), not
  documented and hoped for.

Theorems
--------
``install_theorem`` is how a *proved* equality becomes a rule.  It

1. checks the offered proof path with ``check.check_path`` under the axiom book
   **as it stands before the theorem exists** -- so a theorem can never be its
   own justification;
2. requires the theorem's schematic symbols to occur in **no** axiom of the
   book (the side condition that makes "prove it about an opaque constant, use
   it at every term" sound);
3. declares the axiom and returns a ``Rule`` carrying the checked proof as its
   ``expansion``.

Because the expansion is retained, every *use* of a theorem can be expanded
back into primitive steps and re-checked under a context in which the theorem
was never declared (``expand_path``).  That is what keeps the trusted heart
from growing when the library does: a theorem is a *route compression*, not a
new assumption.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Iterable, List, Optional, Sequence, Tuple

from ..kernel import check as C
from ..kernel import edges as E
from ..kernel import term as T

__all__ = [
    "RewriteError",
    "COUNTERS",
    "Rule",
    "Rewrite",
    "const_symbols",
    "vars_of",
    "rule_from_axiom",
    "rule_from_edge",
    "install_theorem",
    "positions",
    "subterm_at",
    "replace_at",
    "match",
    "apply_rule",
    "rewrite_all",
    "count_steps",
    "reverse_path",
    "substitute_path",
    "expand_path",
]


class RewriteError(T.KernelError):
    """A rewrite rule or application was malformed."""


COUNTERS = T.Counters()


# --------------------------------------------------------------------------
# term utilities (all deterministic, all exact)
# --------------------------------------------------------------------------

def const_symbols(t: T.Term) -> Tuple[str, ...]:
    """Every ``Const`` symbol occurring in ``t``, sorted, each once."""
    out = sorted({u.symbol for u in T.subterms(t) if u.head == T.CONST})
    return tuple(out)


def vars_of(t: T.Term, variables: Iterable[str]) -> frozenset:
    """The schematic symbols of ``variables`` that actually occur in ``t``."""
    vs = frozenset(variables)
    return frozenset(s for s in const_symbols(t) if s in vs)


_SIZE_CACHE: Dict[str, int] = {}


def term_size(t: T.Term) -> int:
    """Number of distinct nodes in the term DAG -- what the runtime stores.

    Memoised by address.  Addresses are permanent and a term's DAG never
    changes, so the cache is a pure-function cache: it cannot alter any result,
    only the cost of getting it.
    """
    got = _SIZE_CACHE.get(t.addr)
    if got is None:
        got = len(T.subterms(t))
        _SIZE_CACHE[t.addr] = got
    return got


def positions(t: T.Term) -> Tuple[Tuple[int, ...], ...]:
    """Every position in ``t``, outermost first, deterministic."""
    out: List[Tuple[int, ...]] = []

    def go(u: T.Term, p: Tuple[int, ...]) -> None:
        out.append(p)
        for i, c in enumerate(u.children):
            go(c, p + (i,))

    go(t, ())
    return tuple(out)


def subterm_at(t: T.Term, pos: Sequence[int]) -> T.Term:
    for i in pos:
        if i >= len(t.children):
            raise RewriteError("position runs off the term")
        t = t.children[i]
    return t


def replace_at(t: T.Term, pos: Sequence[int], new: T.Term) -> T.Term:
    """Rebuild ``t`` with the subterm at ``pos`` replaced by ``new``.

    Sort discipline is the kernel's: an ill-sorted replacement raises
    ``SortError`` from ``App``/``Lam``, it does not produce a bad term.
    """
    pos = tuple(pos)
    if not pos:
        if new.sort is not t.sort:
            raise T.SortError("replacement sort %s != %s"
                              % (new.sort.pretty(), t.sort.pretty()))
        return new
    i = pos[0]
    if i >= len(t.children):
        raise RewriteError("position runs off the term")
    kid = replace_at(t.children[i], pos[1:], new)
    if t.head == T.APP:
        kids = list(t.children)
        kids[i] = kid
        return T.App(kids[0], kids[1])
    if t.head == T.LAM:
        return T.Lam(t.dom, kid)
    raise RewriteError("no children at %s" % (t.head,))


# --------------------------------------------------------------------------
# rules
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class Rule:
    """An accepted equality, usable as a rewrite in either direction.

    ``name``       the axiom name; every emitted justification cites it.
    ``lhs``/``rhs`` the two sides, as kernel terms.
    ``variables``  the ``Const`` symbols treated as schematic.
    ``origin``     ``"axiom"`` (assumed) or ``"theorem"`` (proved and expandable).
    ``expansion``  for a theorem, the checked primitive proof of ``lhs = rhs``.
    """

    name: str
    lhs: T.Term
    rhs: T.Term
    variables: frozenset = frozenset()
    origin: str = "axiom"
    expansion: Tuple[C.Step, ...] = ()

    def __post_init__(self) -> None:
        if self.lhs.sort is not self.rhs.sort:
            raise RewriteError("rule %s relates different sorts" % self.name)
        if self.origin not in ("axiom", "theorem"):
            raise RewriteError("unknown rule origin %r" % (self.origin,))
        if self.origin == "theorem" and not self.expansion:
            raise RewriteError("a theorem rule must carry its proof")

    # -- orientation ------------------------------------------------------
    def sides(self, direction: str) -> Tuple[T.Term, T.Term]:
        if direction == "fwd":
            return (self.lhs, self.rhs)
        if direction == "bwd":
            return (self.rhs, self.lhs)
        raise RewriteError("direction must be 'fwd' or 'bwd'")

    def usable(self, direction: str) -> bool:
        """A direction is usable iff the pattern side binds every variable the
        built side needs, and the pattern side is not a bare variable."""
        pat, out = self.sides(direction)
        if pat.head == T.CONST and pat.symbol in self.variables:
            return False
        return vars_of(out, self.variables) <= vars_of(pat, self.variables)

    def directions(self) -> Tuple[str, ...]:
        return tuple(d for d in ("fwd", "bwd") if self.usable(d))

    def arity(self) -> int:
        return len(self.variables)

    def render(self) -> str:
        return "%s : %s = %s" % (self.name, self.lhs.pretty(), self.rhs.pretty())


def rule_from_axiom(ctx: C.CheckContext, name: str,
                    variables: Iterable[str] = ()) -> Rule:
    """Turn a *declared* axiom into a rewrite rule.

    Refuses an undeclared name: a rule may only come from something the axiom
    book already contains, because the justification it will emit cites that
    name and the checker will look it up.
    """
    got = ctx.axioms.get(name)
    if got is None:
        raise RewriteError("no declared axiom named %r" % (name,))
    lhs, rhs = got
    vs = frozenset(variables)
    known = frozenset(const_symbols(lhs)) | frozenset(const_symbols(rhs))
    unknown = sorted(vs - known)
    if unknown:
        raise RewriteError("declared variables %s do not occur in %s"
                           % (unknown, name))
    COUNTERS.bump("rewrite.rule_built")
    return Rule(name=name, lhs=lhs, rhs=rhs, variables=vs, origin="axiom")


def install_theorem(ctx: C.CheckContext, name: str, lhs: T.Term, rhs: T.Term,
                    proof: Sequence[C.Step],
                    variables: Iterable[str] = ()) -> Rule:
    """Check a proof of ``lhs = rhs`` and install it as a schematic rule.

    Three gates, all-or-nothing:

    G1  the name is fresh (a theorem may not silently redefine an axiom);
    G2  ``check_path`` accepts ``proof`` **under the current book**, so the
        theorem is derived from what was already accepted, never from itself;
    G3  every schematic symbol occurs in no axiom of the book.  This is the
        side condition that makes the schematic reading sound: the proof is a
        derivation about opaque constants, and substituting a term for an
        opaque constant that no axiom mentions maps every step of the proof to
        a valid step (``Instantiate`` composes with the substitution).  G3 is
        machine-checked here, and every *use* of the theorem is separately
        expandable back to primitives by ``expand_path``.
    """
    if name in ctx.axioms:
        raise RewriteError("axiom name %r is already taken" % (name,))
    if lhs.sort is not rhs.sort:
        raise RewriteError("theorem %s relates different sorts" % name)
    proof = tuple(proof)
    COUNTERS.bump("rewrite.theorem_check")
    if not C.check_path(proof, lhs.recompute_addr(), rhs.recompute_addr(), ctx):
        COUNTERS.bump("rewrite.theorem_rejected")
        raise RewriteError("the offered proof of %s does not check: %s"
                           % (name, ctx.errors[-1] if ctx.errors else "?"))
    vs = frozenset(variables)
    for axname in sorted(ctx.axioms):
        a, b = ctx.axioms[axname]
        clash = sorted(vs & (frozenset(const_symbols(a)) | frozenset(const_symbols(b))))
        if clash:
            COUNTERS.bump("rewrite.theorem_rejected")
            raise RewriteError(
                "schematic symbol(s) %s of theorem %s also occur in axiom %s; "
                "generalisation would be unsound" % (clash, name, axname))
    ctx.declare_axiom(name, lhs, rhs)
    COUNTERS.bump("rewrite.theorem_installed")
    return Rule(name=name, lhs=lhs, rhs=rhs, variables=vs,
                origin="theorem", expansion=proof)


def rule_from_edge(edge: E.Edge, ctx: C.CheckContext, name: str,
                   variables: Iterable[str] = ()) -> Rule:
    """An accepted ``Eq`` **edge** becomes a rewrite rule.

    The edge's witness must be a proof path and ``check.check_edge`` must
    accept it; only then is the statement installed as a theorem.  A
    ``Conjecture`` edge, or an ``Eq`` edge whose path does not check, raises.
    """
    if edge.kind != "Eq":
        raise RewriteError("only an Eq edge becomes a rewrite (got %s)" % edge.kind)
    COUNTERS.bump("rewrite.edge_check")
    if not C.check_edge(edge, ctx):
        COUNTERS.bump("rewrite.edge_rejected")
        raise RewriteError("edge %s was not accepted by the checker" % edge.edge_id[:8])
    lhs, rhs = T.lookup(edge.src), T.lookup(edge.dst)
    if lhs is None or rhs is None:
        raise RewriteError("edge endpoints are not interned terms")
    return install_theorem(ctx, name, lhs, rhs, tuple(edge.witness), variables)


# --------------------------------------------------------------------------
# syntactic matching
# --------------------------------------------------------------------------

def match(pattern: T.Term, target: T.Term, variables: Iterable[str],
          sigma: Optional[Dict[str, T.Term]] = None) -> Optional[Dict[str, T.Term]]:
    """First-order matching of ``pattern`` against ``target``.

    Returns the substitution (symbol -> closed term) or ``None``.  Refuses to
    bind an **open** term: ``subst_consts`` does not shift de Bruijn indices,
    so an open binding could be captured under a binder.  Refusing is sound and
    cheap; the cost is that a rewrite whose match would have to bind a bound
    variable simply does not fire.
    """
    vs = frozenset(variables)
    out: Dict[str, T.Term] = dict(sigma) if sigma else {}
    COUNTERS.bump("rewrite.match_attempt")

    def go(p: T.Term, t: T.Term) -> bool:
        if p.head == T.CONST and p.symbol in vs:
            if p.sort is not t.sort:
                return False
            if not t.is_closed:
                COUNTERS.bump("rewrite.match_open_refused")
                return False
            prev = out.get(p.symbol)
            if prev is not None:
                return prev is t
            out[p.symbol] = t
            return True
        if p.head != t.head or p.sort is not t.sort:
            return False
        if p.head == T.CONST:
            return p.symbol == t.symbol
        if p.head == T.VAR:
            return p.index == t.index
        if p.head == T.LAM:
            if p.dom is not t.dom:
                return False
            return go(p.children[0], t.children[0])
        return go(p.children[0], t.children[0]) and go(p.children[1], t.children[1])

    if not go(pattern, target):
        return None
    COUNTERS.bump("rewrite.match_hit")
    return out


def sigma_tuple(sigma: Dict[str, T.Term]) -> Tuple[Tuple[str, T.Term], ...]:
    """Canonical, deterministic encoding of a substitution."""
    return tuple(sorted(sigma.items(), key=lambda kv: kv[0]))


# --------------------------------------------------------------------------
# application
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class Rewrite:
    """One checked rewrite application."""

    rule: Rule
    direction: str
    position: Tuple[int, ...]
    src: T.Term
    dst: T.Term
    subst: Tuple[Tuple[str, T.Term], ...]
    path: Tuple[C.Step, ...]

    def render(self) -> str:
        return "%s/%s at %s : %s -> %s" % (
            self.rule.name, self.direction, list(self.position),
            self.src.pretty(), self.dst.pretty())


def _lift(src: T.Term, dst: T.Term, pos: Tuple[int, ...],
          inner: Tuple[C.Step, ...]) -> Tuple[C.Step, ...]:
    """Wrap a subterm proof in congruence steps out to the root.

    Untouched argument positions get the empty path, which ``check_path``
    accepts exactly when the two addresses are equal -- which they are, because
    only the position ``pos`` changed.
    """
    if not pos:
        return inner
    i = pos[0]
    sub = _lift(src.children[i], dst.children[i], pos[1:], inner)
    subproofs: List[Tuple[C.Step, ...]] = [() for _ in src.children]
    subproofs[i] = sub
    return (C.Step(src.recompute_addr(), dst.recompute_addr(), "congruence",
                   None, None, tuple(subproofs)),)


def apply_rule(t: T.Term, rule: Rule, direction: str, pos: Sequence[int],
               ctx: C.CheckContext) -> Optional[Rewrite]:
    """Apply ``rule`` at ``pos`` in ``t``; return ``None`` if it does not fire
    **or if the checker rejects the justification**.

    The second half of that sentence is the point of the module.  Nothing here
    returns a rewritten term without ``check_path`` having accepted the path
    that justifies it, so an ill-formed rule cannot contribute a term to any
    downstream e-graph, saturation or extraction.
    """
    pos = tuple(pos)
    if direction not in ("fwd", "bwd"):
        raise RewriteError("direction must be 'fwd' or 'bwd'")
    pat, out = rule.sides(direction)
    try:
        sub = subterm_at(t, pos)
    except RewriteError:
        return None
    if sub.sort is not pat.sort:
        return None
    sigma = match(pat, sub, rule.variables)
    if sigma is None:
        return None
    st = sigma_tuple(sigma)
    try:
        built = T.subst_consts(out, dict(sigma))
        dst = replace_at(t, pos, built)
    except T.SortError:
        COUNTERS.bump("rewrite.rejected")
        return None
    COUNTERS.bump("rewrite.apply")
    step = C.Step(sub.recompute_addr(), built.recompute_addr(), "assumption",
                  C.Instantiate(rule.name, st), None)
    path = _lift(t, dst, pos, (step,))
    COUNTERS.bump("rewrite.checked")
    if not C.check_path(path, t.recompute_addr(), dst.recompute_addr(), ctx):
        COUNTERS.bump("rewrite.rejected")
        return None
    return Rewrite(rule=rule, direction=direction, position=pos, src=t, dst=dst,
                   subst=st, path=path)


def rewrite_all(t: T.Term, rules: Sequence[Rule],
                ctx: C.CheckContext) -> Tuple[Rewrite, ...]:
    """Every checked one-step rewrite of ``t``, in a deterministic order.

    Cost: ``O(|rules| * |directions| * |positions(t)| * |pattern|)`` match
    attempts, each followed by one ``check_path`` on a hit.  Purely syntactic
    -- it does not consult any e-graph.  ``ematch.py`` is the version that
    matches modulo proved equalities.
    """
    out: List[Rewrite] = []
    for rule in rules:
        for direction in rule.directions():
            for pos in positions(t):
                got = apply_rule(t, rule, direction, pos, ctx)
                if got is not None:
                    out.append(got)
    return tuple(out)


# --------------------------------------------------------------------------
# proof-path arithmetic: counting, reversing, substituting, expanding
# --------------------------------------------------------------------------

def count_steps(path: Sequence[C.Step]) -> int:
    """Total number of proof steps, counting congruence subproofs.

    This is the exact number of ``check_step`` invocations the checker will
    make, so it is a *kernel step count*, not a summary of one.
    """
    n = 0
    for s in path:
        n += 1
        for sub in s.subproofs:
            n += count_steps(sub)
    return n


def reverse_path(path: Sequence[C.Step]) -> Tuple[C.Step, ...]:
    """Reverse a proof path.  Every witness the checker accepts for equalities
    is symmetric (``Refl``, ``Beta``, ``Axiom``/``Instantiate`` via ``_sides``),
    so reversal preserves checkability."""
    out: List[C.Step] = []
    for s in reversed(tuple(path)):
        out.append(C.Step(s.dst, s.src, s.kind, s.witness, s.edge_id,
                          tuple(reverse_path(sub) for sub in s.subproofs)))
    return tuple(out)


def substitute_path(path: Sequence[C.Step],
                    sigma: Dict[str, T.Term]) -> Tuple[C.Step, ...]:
    """Push a constant substitution through a whole proof path.

    Each step's endpoints are re-derived with ``term.subst_consts`` and each
    witness is transported:

    * ``Instantiate(name, s)`` -> ``Instantiate(name, s.sigma)`` (composition);
    * ``Axiom(name)``          -> ``Instantiate(name, sigma)`` (the axiom's own
      sides are what got substituted, which is precisely what ``Instantiate``
      re-derives);
    * ``Refl`` / ``Beta``      -> unchanged (both are stable under substitution
      of opaque constants).

    This is the operation that makes a schematic theorem *expandable*: the
    theorem's proof, instantiated at the arguments of an actual use.
    """
    out: List[C.Step] = []
    for s in path:
        src = T.lookup(s.src)
        dst = T.lookup(s.dst)
        if src is None or dst is None:
            raise RewriteError("cannot substitute through an unknown address")
        nsrc = T.subst_consts(src, sigma)
        ndst = T.subst_consts(dst, sigma)
        COUNTERS.bump("rewrite.subst_step")
        if s.kind == "congruence":
            subs = tuple(substitute_path(sub, sigma) for sub in s.subproofs)
            out.append(C.Step(nsrc.recompute_addr(), ndst.recompute_addr(),
                              "congruence", None, s.edge_id, subs))
            continue
        w = s.witness
        if isinstance(w, C.Instantiate):
            inner = tuple((k, T.subst_consts(v, sigma)) for k, v in w.subst)
            have = {k for k, _ in inner}
            extra = tuple((k, v) for k, v in sorted(sigma.items()) if k not in have)
            nw: object = C.Instantiate(w.name, tuple(sorted(inner + extra,
                                                            key=lambda kv: kv[0])))
        elif isinstance(w, C.Axiom):
            nw = C.Instantiate(w.name, tuple(sorted(sigma.items(),
                                                    key=lambda kv: kv[0])))
        elif isinstance(w, (C.Refl, C.Beta)):
            nw = w
        else:
            raise RewriteError("cannot substitute through witness %s"
                               % type(w).__name__)
        out.append(C.Step(nsrc.recompute_addr(), ndst.recompute_addr(),
                          "assumption", nw, s.edge_id))
    return tuple(out)


MAX_EXPANSION_DEPTH = 16


def expand_path(path: Sequence[C.Step], rules: Sequence[Rule],
                depth: int = 0) -> Tuple[C.Step, ...]:
    """Replace every theorem step by the theorem's own primitive proof.

    The result cites only the axioms the theorems were proved from, so it can
    be re-checked in a ``CheckContext`` where **no theorem is declared**.  That
    is the machine-checkable statement that installing a theorem did not widen
    the trusted base: it changed the route, not the assumptions.
    """
    if depth > MAX_EXPANSION_DEPTH:
        raise RewriteError("theorem expansion nested deeper than %d"
                           % MAX_EXPANSION_DEPTH)
    book = {r.name: r for r in rules if r.origin == "theorem"}
    out: List[C.Step] = []
    for s in path:
        if s.kind == "congruence":
            out.append(C.Step(s.src, s.dst, "congruence", None, s.edge_id,
                              tuple(expand_path(sub, rules, depth + 1)
                                    for sub in s.subproofs)))
            continue
        w = s.witness
        name = getattr(w, "name", None)
        rule = book.get(name) if isinstance(w, (C.Axiom, C.Instantiate)) else None
        if rule is None:
            out.append(s)
            continue
        sigma = dict(w.subst) if isinstance(w, C.Instantiate) else {}
        sub = substitute_path(rule.expansion, sigma)
        sub = expand_path(sub, rules, depth + 1)
        lhs = T.subst_consts(rule.lhs, sigma).recompute_addr()
        if s.src == lhs:
            out.extend(sub)
        else:
            out.extend(reverse_path(sub))
        COUNTERS.bump("rewrite.expand")
    return tuple(out)
