"""L3 -- e-matching: patterns against **e-classes**, not against terms.

This is where the e-graph earns its keep.  A syntactic matcher (``rewrite.match``)
sees one term at a time.  An e-matcher sees an *equivalence class* at every
position, so it fires on shapes that are not syntactically present in any single
stored term but are present modulo the equalities already proved.

The demonstration in ``runtime/demo/geodesic_demo.py`` turns on exactly that:
the pattern ``mul(mul(mul(?u,?u),?u),?u)`` matches the class of ``3^8`` with
``?u`` bound to the class of ``3^2``, even though no stored term has that shape
-- the four-fold left-nested product of squares was never built.  A syntactic
matcher finds nothing there.

THE BOUND, STATED
-----------------
E-matching is a backtracking search over (pattern node x e-class member) pairs.
For a pattern with ``P`` nodes over classes of at most ``C`` members it has up
to ``C**P`` leaves, so it is **exponential in pattern size** and must be
bounded.  Three explicit bounds, all reported, none silent:

``max_visits``           hard cap on (pattern node, e-node) visits.  On
                         exhaustion ``EMatchResult.exhausted`` is ``True`` and
                         the result is declared **partial**.
``max_representatives``  cap on how many members of one class a variable may be
                         bound to.  Exceeding it sets ``exhausted``.
``max_exhaustive_vars``  patterns with at most this many distinct variables bind
                         each variable to **every** member of its class
                         (complete, materialises syntactic variants); patterns
                         with more bind to the class's **canonical
                         representative** only.

The last one deserves the honest statement, because it is the only place this
module gives something up:

    Canonical-representative binding loses **no equality**.  If the pattern
    matches a class with substitution ``sigma'``, then ``lhs[sigma']`` and
    ``lhs[sigma_canonical]`` lie in the same class (their corresponding
    arguments are equal), so congruence makes ``rhs[sigma']`` and
    ``rhs[sigma_canonical]`` equal too.  The class-level consequence is
    identical.  What is lost is *materialisation*: some syntactic members of the
    class are never built as nodes, so they cannot later be *extracted* as
    routes.  That is a loss of candidate routes, not of mathematics, and it is
    why the exhaustive mode exists for small-arity patterns.

Everything is deterministic: classes are iterated in sorted address order,
representatives in ``(size, address)`` order, results deduplicated by an
insertion-ordered dict.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, Iterator, List, Optional, Sequence, Tuple

from ..kernel import term as T
from ..kernel.egraph import EGraph
from .rewrite import Rule, term_size, vars_of

__all__ = [
    "EMatchBudget",
    "EMatch",
    "EMatchResult",
    "COUNTERS",
    "canonical_member",
    "class_members",
    "ematch",
    "ematch_rule",
]

COUNTERS = T.Counters()


@dataclass(frozen=True)
class EMatchBudget:
    """Explicit, reported bounds.  See the module docstring."""

    max_visits: int = 200000
    max_representatives: int = 64
    max_exhaustive_vars: int = 1

    def render(self) -> str:
        return ("visits<=%d reps<=%d exhaustive_if_vars<=%d"
                % (self.max_visits, self.max_representatives,
                   self.max_exhaustive_vars))


@dataclass(frozen=True)
class EMatch:
    """One match: a pattern found in an e-class, with its substitution."""

    root: str
    matched: str
    subst: Tuple[Tuple[str, T.Term], ...]

    def key(self) -> Tuple:
        return (self.root, self.matched,
                tuple((k, v.addr) for k, v in self.subst))


@dataclass(frozen=True)
class EMatchResult:
    """Matches plus the exact cost and whether the answer is complete.

    ``exhausted`` is the whole discipline: a bounded search that hits its bound
    says so.  Callers must not read ``matches`` as "all matches" unless
    ``complete`` is true.
    """

    matches: Tuple[EMatch, ...]
    visits: int
    budget: EMatchBudget
    exhausted: bool
    reason: str = ""

    @property
    def complete(self) -> bool:
        return not self.exhausted

    def render(self) -> str:
        return ("%d match(es), %d visits, %s"
                % (len(self.matches), self.visits,
                   "COMPLETE" if self.complete else "PARTIAL (%s)" % self.reason))


class _State:
    __slots__ = ("visits", "budget", "exhausted", "reason")

    def __init__(self, budget: EMatchBudget) -> None:
        self.visits = 0
        self.budget = budget
        self.exhausted = False
        self.reason = ""

    def visit(self) -> bool:
        """Charge one visit.  Returns False once the budget is spent."""
        if self.exhausted:
            return False
        self.visits += 1
        COUNTERS.bump("ematch.visit")
        if self.visits > self.budget.max_visits:
            self.exhausted = True
            self.reason = "max_visits"
            COUNTERS.bump("ematch.exhausted")
            return False
        return True

    def blow(self, reason: str) -> None:
        if not self.exhausted:
            self.exhausted = True
            self.reason = reason
            COUNTERS.bump("ematch.exhausted")


# --------------------------------------------------------------------------
# class helpers
# --------------------------------------------------------------------------

_MEMBERS_CACHE: Dict[Tuple[str, ...], Tuple[T.Term, ...]] = {}


def class_members(g: EGraph, root: str) -> Tuple[T.Term, ...]:
    """The class's members as terms, in ``(size, address)`` order.

    Memoised on the class tuple itself, which is a value, not a handle: the
    e-graph hands out a new tuple whenever a class changes, so the cache is a
    pure-function cache over immutable input.  It changes cost, never results.
    """
    key = g.class_of(root)
    got = _MEMBERS_CACHE.get(key)
    if got is not None:
        return got
    out = [T.lookup(a) for a in key]
    terms = [t for t in out if t is not None]
    terms.sort(key=lambda t: (term_size(t), t.addr))
    got = tuple(terms)
    _MEMBERS_CACHE[key] = got
    return got


def _spine(t: T.Term) -> Tuple:
    """The head descriptor at the end of an application spine."""
    while t.head == T.APP:
        t = t.children[0]
    if t.head == T.CONST:
        return ("const", t.symbol)
    if t.head == T.VAR:
        return ("var", t.index)
    return ("lam", t.dom.addr)


def _member_key(t: T.Term) -> Tuple:
    if t.head == T.APP:
        return ("app", _spine(t))
    if t.head == T.CONST:
        return ("const", t.symbol)
    if t.head == T.VAR:
        return ("var", t.index)
    return ("lam", t.dom.addr)


def _pattern_key(pat: T.Term, variables: frozenset) -> Optional[Tuple]:
    """The index bucket a pattern can match, or ``None`` for "every node".

    ``None`` is returned when the pattern's own spine head is a variable, since
    then any node at all could match.  Returning ``None`` rather than guessing
    is what keeps the index from ever *losing* a match.
    """
    if pat.head == T.APP:
        s = pat
        while s.head == T.APP:
            s = s.children[0]
        if s.head == T.CONST and s.symbol in variables:
            return ("app", None)
        return ("app", _spine(pat))
    if pat.head == T.CONST:
        return ("const", pat.symbol)
    if pat.head == T.VAR:
        return ("var", pat.index)
    return ("lam", pat.dom.addr)


_INDEX_CACHE: Dict[Tuple[str, ...], Dict[Tuple, Tuple[T.Term, ...]]] = {}


def class_index(g: EGraph, root: str) -> Dict[Tuple, Tuple[T.Term, ...]]:
    """Members of a class bucketed by head symbol (and application spine).

    A pure-function index over the class tuple.  It is a *filter*, never a
    truncation: a pattern whose bucket is absent has no match in this class at
    all, because head symbols must agree for any match to exist.  Without it,
    matching a nested pattern scans every node of every class at every level and
    the cost is the product of the class sizes.
    """
    key = g.class_of(root)
    got = _INDEX_CACHE.get(key)
    if got is not None:
        return got
    buckets: Dict[Tuple, List[T.Term]] = {}
    apps: List[T.Term] = []
    for t in class_members(g, root):
        buckets.setdefault(_member_key(t), []).append(t)
        if t.head == T.APP:
            apps.append(t)
    out: Dict[Tuple, Tuple[T.Term, ...]] = {k: tuple(v) for k, v in buckets.items()}
    out[("app", None)] = tuple(apps)
    _INDEX_CACHE[key] = out
    return out


def canonical_member(g: EGraph, root: str) -> T.Term:
    """The class's canonical representative: smallest, then smallest address."""
    ms = class_members(g, root)
    if not ms:
        raise KeyError("empty e-class %s" % root[:8])
    return ms[0]


# --------------------------------------------------------------------------
# the matcher
# --------------------------------------------------------------------------

def _match_class(g: EGraph, pat: T.Term, root: str, sigma: Dict[str, T.Term],
                 st: _State, variables: frozenset,
                 exhaustive: bool) -> Iterator[Dict[str, T.Term]]:
    if not st.visit():
        return
    if pat.head == T.CONST and pat.symbol in variables:
        bound = sigma.get(pat.symbol)
        if bound is not None:
            # matching modulo the equalities that were actually merged, and
            # only those: a class check, never a syntactic one.
            if g.find(bound.addr) == root:
                yield sigma
            return
        cands = class_members(g, root)
        if exhaustive:
            if len(cands) > st.budget.max_representatives:
                st.blow("max_representatives")
                cands = cands[: st.budget.max_representatives]
        else:
            cands = cands[:1]
        for u in cands:
            if u.sort is not pat.sort or not u.is_closed:
                continue
            if not st.visit():
                return
            nxt = dict(sigma)
            nxt[pat.symbol] = u
            yield nxt
        return
    bucket = class_index(g, root).get(_pattern_key(pat, variables), ())
    for member in bucket:
        yield from _match_node(g, pat, member, sigma, st, variables, exhaustive)


def _match_node(g: EGraph, pat: T.Term, node: T.Term, sigma: Dict[str, T.Term],
                st: _State, variables: frozenset,
                exhaustive: bool) -> Iterator[Dict[str, T.Term]]:
    if not st.visit():
        return
    if pat.sort is not node.sort:
        return
    if pat.head == T.CONST and pat.symbol in variables:
        yield from _match_class(g, pat, g.find(node.addr), sigma, st,
                                variables, exhaustive)
        return
    if pat.head != node.head:
        return
    if pat.head == T.CONST:
        if pat.symbol == node.symbol:
            yield sigma
        return
    if pat.head == T.VAR:
        if pat.index == node.index:
            yield sigma
        return
    if pat.head == T.LAM:
        if pat.dom is not node.dom:
            return
        yield from _match_class(g, pat.children[0],
                                g.find(node.children[0].addr), sigma, st,
                                variables, exhaustive)
        return
    # application
    for s1 in _match_class(g, pat.children[0], g.find(node.children[0].addr),
                           sigma, st, variables, exhaustive):
        yield from _match_class(g, pat.children[1],
                                g.find(node.children[1].addr), s1, st,
                                variables, exhaustive)


def ematch(g: EGraph, pattern: T.Term, variables, budget: EMatchBudget = EMatchBudget(),
           roots: Optional[Sequence[str]] = None) -> EMatchResult:
    """All substitutions matching ``pattern`` against the e-graph, bounded.

    Returns an ``EMatchResult``; check ``.complete`` before treating
    ``.matches`` as exhaustive.
    """
    variables = frozenset(variables)
    if pattern.head == T.CONST and pattern.symbol in variables:
        raise ValueError("a bare variable pattern matches everything; refused")
    nvars = len(vars_of(pattern, variables))
    exhaustive = nvars <= budget.max_exhaustive_vars
    st = _State(budget)
    found: Dict[Tuple, EMatch] = {}
    if roots is None:
        root_list = sorted({g.find(a) for a in g.terms()})
    else:
        root_list = sorted({g.find(r) for r in roots})
    for root in root_list:
        for member in class_members(g, root):
            for sigma in _match_node(g, pattern, member, {}, st, variables,
                                     exhaustive):
                m = EMatch(root=root, matched=member.addr,
                           subst=tuple(sorted(sigma.items(), key=lambda kv: kv[0])))
                k = m.key()
                if k not in found:
                    found[k] = m
                    COUNTERS.bump("ematch.match")
            if st.exhausted and st.reason == "max_visits":
                break
        if st.exhausted and st.reason == "max_visits":
            break
    COUNTERS.bump("ematch.calls")
    return EMatchResult(matches=tuple(found.values()), visits=st.visits,
                        budget=budget, exhausted=st.exhausted, reason=st.reason)


def ematch_rule(g: EGraph, rule: Rule, direction: str,
                budget: EMatchBudget = EMatchBudget()) -> EMatchResult:
    """E-match a rule's pattern side.  ``direction`` is ``"fwd"``/``"bwd"``."""
    pat, _ = rule.sides(direction)
    return ematch(g, pat, rule.variables, budget)
