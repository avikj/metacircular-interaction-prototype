"""GENERATE -- a typed, proof-carrying multiway system (CRYSTAL.md sec 7).

A raw Wolfram multiway system rewrites strings and keeps every history.  It
cannot tell a theorem-preserving step from a corruption, because its edges are
undifferentiated: "A became B" carries no guarantee.  This module keeps the
multiway idea (all rules, all positions, all histories, retained as a DAG, with
the causal structure extracted) and replaces the undifferentiated edge with a
**typed kernel edge** carrying a proof path that ``kernel/check.py`` validates.

    state       a term of the crystallize substrate (free commutative ring
                Z[x1,x2,...] with flat n-ary sums and products)
    edge        a single commutative-ring axiom instance applied at one
                position, encoded into the kernel IR and admitted only if
                ``kernel.check.check_edge`` accepts an ``Eq`` edge for it
    history     retained: every (rule, position) that reaches a state is an
                edge of the DAG, and none is collapsed
    causality   two composable edges are *causally dependent* when their
                positions are nested and *concurrent* when they are disjoint;
                a concurrent pair whose two orders meet again is a closed
                diamond, which is the local form of causal invariance

THE ADMISSION CHAIN (two independent gates, both exact)
-------------------------------------------------------
Nothing enters the accepted graph on assertion.  ``AxiomVault.declare`` is the
only way an axiom name reaches the ``CheckContext``, and it declares one only
after:

  A1  SCHEMA RE-RUN.  The named ring rule is re-run on the redex by this
      module and must return the recorded contractum, address for address.
      (This is ``crystallize.derivation``'s own checking discipline, applied
      before the kernel ever sees the step.)
  A2  INDEPENDENT SEMANTICS.  ``poly_equal`` decides redex = contractum by
      exact evaluation on an integer grid whose size is a complete degree
      bound.  Structurally unrelated to A1.

Only then is ``ctx.declare_axiom`` called, and only then can the lifted
congruence path cite it.  A corrupted contractum fails A1, so no axiom is
declared, so the forged edge's ``Axiom`` witness names nothing the checker
knows, so ``check_edge`` rejects it and ``MultiwayGraph.admit`` returns a
``Refusal`` instead of an edge.  ``runtime/tests/test_generate.py`` plants
exactly that and asserts the accepted graph never grows.

``Conjecture`` edges are not produced here at all.  They live in
``generate/propose.py``'s separate proposal graph, and the accepted graph in
this module holds ``Eq`` edges only -- asserted by ``MultiwayGraph.audit``.

Determinism: rule order, position order (postorder) and frontier order are all
lists.  No set is iterated anywhere its order could be observed.  Output is
byte-identical across ``PYTHONHASHSEED``.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List, Optional, Sequence, Tuple

from ..crystallize.derivation import (INT, PROD, RULE_TABLE, RULES, SUM, VAR,
                                      Counter, Term, at, poly_equal,
                                      positions_postorder, render, replace_at)
from ..kernel import check as C
from ..kernel import term as T
from ..kernel.edges import Edge

__all__ = [
    "R_SORT", "encode", "arrow_n", "kernel_dirs", "lift_path",
    "AxiomVault", "MEdge", "Refusal", "MultiwayGraph", "CausalReport",
    "GenerationBudget", "generate", "causal_report",
]


# ==========================================================================
# 1. The bridge: ring terms -> kernel IR
# ==========================================================================
#
# The crystallize substrate is a first-order n-ary IR; the kernel is a curried
# STLC.  The encoding is total, injective and deterministic:
#
#     I(n)            -> Const("z:n"      : R)
#     V(s)            -> Const("v:s"      : R)
#     Sum(a1..ak)     -> sum_k a1 ... ak    with  sum_k : R -> ... -> R
#     Prod(a1..ak)    -> prod_k a1 ... ak
#
# Injectivity matters: two different ring terms must never encode to one kernel
# address, or a corrupt step could be laundered into a true one.  It holds
# because the head symbol records both the node kind and its arity, and the
# leaf symbols are prefixed by kind.

R_SORT = T.base_sort("R")

_ARROW_CACHE: Dict[int, T.Sort] = {}


def arrow_n(n: int) -> T.Sort:
    """``R -> R -> ... -> R`` with ``n`` arguments (``n = 0`` is just ``R``)."""
    if n < 0:
        raise ValueError("arity must be non-negative")
    got = _ARROW_CACHE.get(n)
    if got is not None:
        return got
    s = R_SORT if n == 0 else T.arrow(R_SORT, arrow_n(n - 1))
    _ARROW_CACHE[n] = s
    return s


_ENC_CACHE: Dict[str, T.Term] = {}


def encode(t: Term) -> T.Term:
    """Ring term -> kernel term.  Memoised on the ring address."""
    got = _ENC_CACHE.get(t.addr)
    if got is not None:
        return got
    if t.kind == INT:
        out = T.Const("z:%d" % t.val, R_SORT)
    elif t.kind == VAR:
        out = T.Const("v:%s" % t.val, R_SORT)
    else:
        k = len(t.args)
        head = T.Const("%s%d" % ("sum" if t.kind == SUM else "prod", k),
                       arrow_n(k))
        out = head
        for a in t.args:
            out = T.App(out, encode(a))
    _ENC_CACHE[t.addr] = out
    return out


def kernel_dirs(t: Term, pos: Sequence[int]) -> Tuple[str, ...]:
    """Ring position -> the ``fn``/``arg`` descent through the curried spine."""
    dirs: List[str] = []
    node = t
    for i in pos:
        n = len(node.args)
        if not 0 <= i < n:
            raise IndexError("position %r escapes %s" % (list(pos), render(t)))
        dirs.extend(["fn"] * (n - 1 - i))
        dirs.append("arg")
        node = node.args[i]
    return tuple(dirs)


def lift_path(k: T.Term, dirs: Sequence[str],
              inner: Tuple[C.Step, ...]) -> Tuple[C.Step, ...]:
    """Wrap a proof of a subterm equality in congruence steps up to the root.

    ``k`` is the kernel term at the current depth, ``dirs`` the remaining
    descent, ``inner`` a checked path between the two versions of the subterm.
    The untouched sibling gets the empty path, which ``check_path`` accepts
    exactly when its endpoints are the same address -- which they are, because
    only one child changed.
    """
    if not dirs:
        return inner
    if not inner:
        return ()
    fn, arg = k.children
    d = dirs[0]
    if d == "fn":
        sub = lift_path(fn, dirs[1:], inner)
        if not sub:
            return ()
        new_fn = T.lookup(sub[-1].dst)
        if new_fn is None:
            raise C.T.KernelError("lifted subterm is not interned")
        new_k = T.App(new_fn, arg)
        subproofs = (sub, ())
    else:
        sub = lift_path(arg, dirs[1:], inner)
        if not sub:
            return ()
        new_arg = T.lookup(sub[-1].dst)
        if new_arg is None:
            raise C.T.KernelError("lifted subterm is not interned")
        new_k = T.App(fn, new_arg)
        subproofs = ((), sub)
    return (C.Step(src=k.addr, dst=new_k.addr, kind="congruence",
                   subproofs=subproofs),)


# ==========================================================================
# 2. The axiom vault -- the only door into the checker's axiom book
# ==========================================================================

@dataclass(frozen=True)
class Refusal:
    """Why a proposed edge was refused.  Never a partial success."""

    rule: str
    gate: str
    detail: str

    def render(self) -> str:
        return "REFUSED [%s] %s: %s" % (self.gate, self.rule, self.detail)


class AxiomVault:
    """Declares ring-rule instances as kernel axioms, behind two exact gates.

    The vault is the trust boundary made visible: ``CheckContext.axioms`` is
    T3, the checker's only unproved input, and this class is the only thing in
    the generate lane that writes to it.  Everything it declares has been
    re-run against its rule schema (A1) *and* decided by ``poly_equal`` (A2).
    """

    __slots__ = ("ctx", "declared", "refusals", "a1_failures", "a2_failures",
                 "lemmas")

    def __init__(self, ctx: Optional[C.CheckContext] = None) -> None:
        self.ctx = ctx if ctx is not None else C.CheckContext()
        self.declared: Dict[str, Tuple[str, str]] = {}
        self.refusals: List[Refusal] = []
        self.a1_failures = 0
        self.a2_failures = 0
        self.lemmas: Dict[str, object] = {}

    @staticmethod
    def axiom_name(rule: str, redex: Term, contractum: Term) -> str:
        return "rw|%s|%s|%s" % (rule, redex.addr, contractum.addr)

    def declare(self, rule: str, redex: Term, contractum: Term,
                lemma=None) -> Optional[str]:
        """Return the axiom name, or ``None`` after recording a refusal."""
        name = self.axiom_name(rule, redex, contractum)
        if name in self.declared:
            return name

        # ---- A1: re-run the schema.  The recorded contractum is not trusted.
        if lemma is not None:
            from ..crystallize.derivation import match as ring_match
            from ..crystallize.derivation import subst as ring_subst
            sigma = ring_match(lemma.lhs, redex)
            ok = sigma is not None and \
                ring_subst(lemma.rhs, sigma).addr == contractum.addr
            self.lemmas[lemma.lid] = lemma
        else:
            fn = RULE_TABLE.get(rule)
            ok = False
            if fn is not None:
                out = fn(redex)
                ok = out is not None and out.addr == contractum.addr
        if not ok:
            self.a1_failures += 1
            r = Refusal(rule, "A1",
                        "schema re-run does not produce %s from %s"
                        % (render(contractum), render(redex)))
            self.refusals.append(r)
            return None

        # ---- A2: independent semantic decision, structurally unrelated to A1.
        try:
            same = poly_equal(redex, contractum)
        except ValueError as exc:                     # grid too large
            same = False
            detail = "semantic decision unavailable: %s" % exc
        else:
            detail = "%s and %s are different polynomials" % (
                render(redex), render(contractum))
        if not same:
            self.a2_failures += 1
            self.refusals.append(Refusal(rule, "A2", detail))
            return None

        self.ctx.declare_axiom(name, encode(redex), encode(contractum))
        self.declared[name] = (redex.addr, contractum.addr)
        return name

    def __len__(self) -> int:
        return len(self.declared)


# ==========================================================================
# 3. The multiway graph
# ==========================================================================

@dataclass(frozen=True)
class MEdge:
    """One accepted rewrite edge of the multiway DAG."""

    eid: int
    rule: str
    pos: Tuple[int, ...]
    src: str                       # ring address
    dst: str                       # ring address
    edge: Edge                     # the typed kernel edge (kind == "Eq")
    depth: int

    def render(self) -> str:
        return "e%-4d %-11s @%-10s %s -> %s" % (
            self.eid, self.rule, str(list(self.pos)), self.src[:8], self.dst[:8])


@dataclass
class GenerationBudget:
    """Exact bounds.  Every one of them is reported when it bites."""

    max_states: int = 240
    max_edges: int = 900
    max_depth: int = 6
    max_size: int = 26

    def render(self) -> str:
        return ("states<=%d edges<=%d depth<=%d size<=%d"
                % (self.max_states, self.max_edges, self.max_depth,
                   self.max_size))


class MultiwayGraph:
    """States, all their histories, and the typed edges between them."""

    __slots__ = ("vault", "states", "order", "depth", "edges", "out", "inc",
                 "refusals", "checked", "rejected_edges", "status", "origin")

    def __init__(self, vault: AxiomVault) -> None:
        self.vault = vault
        self.states: Dict[str, Term] = {}
        self.order: List[str] = []
        self.depth: Dict[str, int] = {}
        # which seed a state was first reached from.  Two states of one orbit
        # are *already* connected by this graph, so a conjecture between them
        # is one the runtime can discharge by construction; the informative
        # collisions are the cross-origin ones.  Recording the origin costs one
        # dict write per state and is what lets DISTINGUISH tell them apart.
        self.origin: Dict[str, int] = {}
        self.edges: List[MEdge] = []
        self.out: Dict[str, List[int]] = {}
        self.inc: Dict[str, List[int]] = {}
        self.refusals: List[Refusal] = []
        self.checked = 0
        self.rejected_edges = 0
        self.status = "fixpoint"

    # -- states ------------------------------------------------------------
    def add_state(self, t: Term, depth: int, origin: int = -1) -> bool:
        if t.addr in self.states:
            if depth < self.depth[t.addr]:
                self.depth[t.addr] = depth
            return False
        self.states[t.addr] = t
        self.order.append(t.addr)
        self.depth[t.addr] = depth
        self.origin[t.addr] = origin
        self.out[t.addr] = []
        self.inc[t.addr] = []
        return True

    def state(self, addr: str) -> Term:
        return self.states[addr]

    # -- edges -------------------------------------------------------------
    def admit(self, before: Term, pos: Sequence[int], rule: str,
              contractum: Term, lemma=None, depth: int = 0, origin: int = -1):
        """Propose one rewrite.  Returns an ``MEdge`` or a ``Refusal``.

        Nothing is added to the graph on the refusal path -- that is the whole
        difference between this and an untyped multiway system.
        """
        pos = tuple(pos)
        redex = at(before, pos)
        after = replace_at(before, pos, contractum)

        name = self.vault.declare(rule, redex, contractum, lemma=lemma)
        if name is None:
            r = self.vault.refusals[-1]
            self.refusals.append(r)
            return r

        base = (C.Step(src=encode(redex).addr, dst=encode(contractum).addr,
                       kind="assumption", witness=C.Axiom(name)),)
        path = lift_path(encode(before), kernel_dirs(before, pos), base)
        edge = Edge(kind="Eq", src=encode(before).addr, dst=encode(after).addr,
                    witness=path, label="%s@%s" % (rule, ",".join(map(str, pos))))

        self.checked += 1
        if not C.check_edge(edge, self.vault.ctx):
            self.rejected_edges += 1
            r = Refusal(rule, "K",
                        "kernel refused the Eq edge: %s"
                        % (self.vault.ctx.errors[-1] if self.vault.ctx.errors
                           else "?"))
            self.refusals.append(r)
            return r

        self.add_state(before, depth, origin)
        self.add_state(after, depth + 1,
                       self.origin.get(before.addr, origin))
        me = MEdge(len(self.edges), rule, pos, before.addr, after.addr, edge,
                   depth)
        self.edges.append(me)
        self.out[before.addr].append(me.eid)
        self.inc[after.addr].append(me.eid)
        return me

    # -- audits ------------------------------------------------------------
    def audit(self) -> Tuple[bool, str]:
        """The accepted graph holds ``Eq`` edges only, every one re-checkable.

        Re-runs ``check_edge`` on every retained edge under a **fresh**
        ``CheckContext`` carrying the vault's axioms, so the audit does not
        reuse the context that admitted them.
        """
        ctx = C.CheckContext(axioms=dict(self.vault.ctx.axioms))
        for me in self.edges:
            if me.edge.kind != "Eq":
                return (False, "non-Eq edge %s in the accepted graph" % me.edge.kind)
            if not C.check_edge(me.edge, ctx):
                return (False, "edge e%d failed re-check: %s"
                        % (me.eid, ctx.errors[-1] if ctx.errors else "?"))
        return (True, "%d edges, all Eq, all re-checked" % len(self.edges))

    def __len__(self) -> int:
        return len(self.states)

    def report(self) -> str:
        return ("multiway: %d states, %d edges, %d axioms, %d refusals (%s)"
                % (len(self.states), len(self.edges), len(self.vault),
                   len(self.refusals), self.status))


# ==========================================================================
# 4. Generation
# ==========================================================================

def _redexes(t: Term) -> List[Tuple[Tuple[int, ...], str, Term]]:
    """Every (position, rule, contractum) applicable to ``t``.

    All rules at all positions -- this is the multiway branching, as against
    the innermost-leftmost single successor the normaliser takes.
    """
    out: List[Tuple[Tuple[int, ...], str, Term]] = []
    for p in positions_postorder(t):
        node = at(t, p)
        for name, fn in RULES:
            res = fn(node)
            if res is not None and res.addr != node.addr:
                out.append((tuple(p), name, res))
    return out


def generate(seeds: Sequence[Term], budget: Optional[GenerationBudget] = None,
             vault: Optional[AxiomVault] = None,
             lemmas: Sequence = ()) -> MultiwayGraph:
    """Breadth-first multiway expansion from ``seeds``, retaining all histories.

    Deterministic: seeds in the given order, frontier in insertion order,
    positions in postorder, rules in ``RULES`` priority order.  Installed
    ``lemmas`` participate as extra rules -- a lemma is a rewrite, so a book
    that grew in an earlier round changes what the next round can reach, which
    is exactly the feedback CRYSTAL.md sec 7 asks for.
    """
    if budget is None:
        budget = GenerationBudget()
    g = MultiwayGraph(vault if vault is not None else AxiomVault())
    from ..crystallize.derivation import match as ring_match
    from ..crystallize.derivation import subst as ring_subst

    frontier: List[str] = []
    for k, s in enumerate(seeds):
        if g.add_state(s, 0, k):
            frontier.append(s.addr)

    head = 0
    while head < len(frontier):
        addr = frontier[head]
        head += 1
        t = g.states[addr]
        d = g.depth[addr]
        if d >= budget.max_depth:
            continue
        if len(g.edges) >= budget.max_edges:
            g.status = "budget:edges"
            break

        proposals: List[Tuple[Tuple[int, ...], str, Term, object]] = []
        for p in positions_postorder(t):
            node = at(t, p)
            for lem in lemmas:
                sigma = ring_match(lem.lhs, node)
                if sigma is not None:
                    proposals.append((tuple(p), "lemma:" + lem.lid,
                                      ring_subst(lem.rhs, sigma), lem))
        for p, name, res in _redexes(t):
            proposals.append((p, name, res, None))

        for pos, rule, contractum, lem in proposals:
            if len(g.edges) >= budget.max_edges:
                g.status = "budget:edges"
                break
            after = replace_at(t, pos, contractum)
            if after.size > budget.max_size:
                continue
            fresh = after.addr not in g.states
            if fresh and len(g.states) >= budget.max_states:
                g.status = "budget:states"
                continue
            res = g.admit(t, pos, rule, contractum, lemma=lem, depth=d,
                          origin=g.origin.get(addr, -1))
            if isinstance(res, MEdge) and fresh:
                frontier.append(after.addr)
    if head < len(frontier) and g.status == "fixpoint":
        g.status = "budget:frontier"
    return g


# ==========================================================================
# 5. Causal structure
# ==========================================================================

def _nested(a: Sequence[int], b: Sequence[int]) -> bool:
    n = min(len(a), len(b))
    return tuple(a[:n]) == tuple(b[:n])


@dataclass(frozen=True)
class CausalReport:
    """The causal/dependency structure of a multiway graph.

    ``causal`` and ``concurrent`` count *composable* edge pairs (``e1.dst ==
    e2.src``): nested positions mean e2 could not have fired before e1 without
    seeing different data, disjoint positions mean the two commute.
    ``diamonds_closed`` counts branch pairs at disjoint positions whose two
    orders meet again inside the graph -- the local form of causal invariance.
    """

    causal: int
    concurrent: int
    diamonds_closed: int
    diamonds_open: int
    branch_states: int
    max_out_degree: int

    def render(self) -> str:
        tot = self.diamonds_closed + self.diamonds_open
        return ("causal pairs %d, concurrent %d | disjoint branch pairs %d, "
                "diamonds closed %d/%d | branching states %d, max out-degree %d"
                % (self.causal, self.concurrent, tot, self.diamonds_closed,
                   tot, self.branch_states, self.max_out_degree))


def causal_report(g: MultiwayGraph) -> CausalReport:
    causal = concurrent = closed = open_ = branch = 0
    max_out = 0
    for addr in g.order:
        outs = g.out[addr]
        if len(outs) > 1:
            branch += 1
        max_out = max(max_out, len(outs))
        for eid in outs:
            e1 = g.edges[eid]
            for fid in g.out[e1.dst]:
                e2 = g.edges[fid]
                if _nested(e1.pos, e2.pos):
                    causal += 1
                else:
                    concurrent += 1
        # diamonds: two disjoint rewrites out of one state
        for i in range(len(outs)):
            for j in range(i + 1, len(outs)):
                a, b = g.edges[outs[i]], g.edges[outs[j]]
                if _nested(a.pos, b.pos):
                    continue
                meet = {g.edges[k].dst for k in g.out.get(a.dst, ())} & \
                       {g.edges[k].dst for k in g.out.get(b.dst, ())}
                if meet:
                    closed += 1
                else:
                    open_ += 1
    return CausalReport(causal, concurrent, closed, open_, branch, max_out)
