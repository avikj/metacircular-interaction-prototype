"""L3 -- e-matching: patterns against **e-classes**, not against terms.

This is where the e-graph earns its keep.  A syntactic matcher (``rewrite.match``)
sees one term at a time.  An e-matcher sees an *equivalence class* at every
position, so it fires on shapes that are not syntactically present in any single
stored term but are present modulo the equalities already proved.

The demonstration in ``runtime/demo/geodesic_demo.py`` turns on exactly that.
The pattern ``mul(mul(mul(?u,?u),?u),?u)`` -- "a fourth power" -- matches the
class of ``3^8`` 44 times.  Five of those have a stored realisation; **39 do
not**, including the one that matters, ``?u`` = the class of ``3^2``, whose
instantiated left side ``mul(mul(mul(#9,#9),#9),#9)`` is not a node of the
e-graph at all.  A syntactic matcher over every position of every stored term
finds only the five.

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

from dataclasses import dataclass
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
    __slots__ = ("visits", "budget", "exhausted", "reason", "memo")

    def __init__(self, budget: EMatchBudget) -> None:
        self.visits = 0
        self.budget = budget
        self.exhausted = False
        self.reason = ""
        self.memo: Dict[Tuple, Tuple[Tuple[Tuple[str, str], ...], ...]] = {}

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

#
# Two phases, deliberately.
#
# PHASE 1 binds each pattern variable to an **e-class**, not to a term.  That is
# the semantically right object -- "matching modulo the equalities proved" means
# the variable stands for a class -- and it is also what keeps the search cheap:
# a repeated variable is discharged by one class comparison instead of by
# enumerating candidate terms and rejecting them one at a time.
#
# PHASE 2 turns each class substitution into term substitutions, because the
# kernel's ``Instantiate`` witness needs terms.  All representative enumeration
# happens here, outside the search, so the search cost does not multiply by it.
#

def _class_sort(g: EGraph, root: str):
    ms = class_members(g, root)
    return ms[0].sort if ms else None


def _match_class(g: EGraph, pat: T.Term, root: str, csigma: Dict[str, str],
                 st: _State, variables: frozenset) -> Iterator[Dict[str, str]]:
    """Memoised wrapper over ``_match_class_raw``.

    Curried application means one syntactic ``mul a b`` is ``App(App(mul,a),b)``,
    so the partial application ``mul a`` has an e-class of its own containing one
    node per term equal to ``a``.  Without memoisation the matcher re-enumerates
    the entire subpattern once per member of that class, and the cost multiplies
    by it at every spine level -- on the demo's graph that is the difference
    between thirty thousand visits and fifty million.  The memo is keyed on
    ``(pattern node address, class root, substitution so far)``, which is
    exactly the state the subsearch depends on, so it can only remove repeated
    work, never a result.  It lives on the per-call ``_State``, so it never
    outlives the e-graph snapshot it was computed against.
    """
    key = (pat.addr, root, tuple(sorted(csigma.items())))
    got = st.memo.get(key)
    if got is not None:
        COUNTERS.bump("ematch.memo_hit")
        for rec in got:
            yield dict(rec)
        return
    acc: List[Tuple[Tuple[str, str], ...]] = []
    seen: Dict[Tuple, None] = {}
    for out in _match_class_raw(g, pat, root, csigma, st, variables):
        k = tuple(sorted(out.items()))
        if k in seen:
            continue
        seen[k] = None
        acc.append(k)
        yield out
    # Only reached when the generator is drained, so an abandoned search never
    # memoises a partial answer.
    if not st.exhausted:
        st.memo[key] = tuple(acc)


def _match_class_raw(g: EGraph, pat: T.Term, root: str, csigma: Dict[str, str],
                     st: _State, variables: frozenset) -> Iterator[Dict[str, str]]:
    if not st.visit():
        return
    if pat.head == T.CONST and pat.symbol in variables:
        bound = csigma.get(pat.symbol)
        if bound is not None:
            # matching modulo the equalities that were actually merged, and
            # only those: a class comparison, never a syntactic one.
            if bound == root:
                yield csigma
            return
        if _class_sort(g, root) is not pat.sort:
            return
        nxt = dict(csigma)
        nxt[pat.symbol] = root
        yield nxt
        return
    bucket = class_index(g, root).get(_pattern_key(pat, variables), ())
    for member in bucket:
        yield from _match_node(g, pat, member, csigma, st, variables)


def _match_node(g: EGraph, pat: T.Term, node: T.Term, csigma: Dict[str, str],
                st: _State, variables: frozenset) -> Iterator[Dict[str, str]]:
    if not st.visit():
        return
    if pat.sort is not node.sort:
        return
    if pat.head == T.CONST and pat.symbol in variables:
        yield from _match_class(g, pat, g.find(node.addr), csigma, st, variables)
        return
    if pat.head != node.head:
        return
    if pat.head == T.CONST:
        if pat.symbol == node.symbol:
            yield csigma
        return
    if pat.head == T.VAR:
        if pat.index == node.index:
            yield csigma
        return
    if pat.head == T.LAM:
        if pat.dom is not node.dom:
            return
        yield from _match_class(g, pat.children[0],
                                g.find(node.children[0].addr), csigma, st,
                                variables)
        return
    for s1 in _match_class(g, pat.children[0], g.find(node.children[0].addr),
                           csigma, st, variables):
        yield from _match_class(g, pat.children[1],
                                g.find(node.children[1].addr), s1, st, variables)


def _representatives(g: EGraph, root: str, st: _State,
                     exhaustive: bool) -> Tuple[T.Term, ...]:
    cands = tuple(t for t in class_members(g, root) if t.is_closed)
    if not exhaustive:
        return cands[:1]
    if len(cands) > st.budget.max_representatives:
        st.blow("max_representatives")
        return cands[: st.budget.max_representatives]
    return cands


def _expand(g: EGraph, csigma: Dict[str, str], st: _State,
            exhaustive: bool) -> Iterator[Tuple[Tuple[str, T.Term], ...]]:
    """Phase 2: class substitution -> term substitutions, deterministically."""
    syms = sorted(csigma)
    if not syms:
        yield ()
        return
    choices = [_representatives(g, csigma[s], st, exhaustive) for s in syms]
    total = 1
    for c in choices:
        total *= len(c)
    if total == 0:
        return
    idx = [0] * len(syms)
    while True:
        yield tuple((syms[i], choices[i][idx[i]]) for i in range(len(syms)))
        k = len(syms) - 1
        while k >= 0:
            idx[k] += 1
            if idx[k] < len(choices[k]):
                break
            idx[k] = 0
            k -= 1
        if k < 0:
            return


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
            seen_classes: Dict[Tuple, None] = {}
            for csigma in _match_node(g, pattern, member, {}, st, variables):
                ck = tuple(sorted(csigma.items()))
                if ck in seen_classes:
                    continue
                seen_classes[ck] = None
                for subst in _expand(g, csigma, st, exhaustive):
                    m = EMatch(root=root, matched=member.addr, subst=subst)
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
