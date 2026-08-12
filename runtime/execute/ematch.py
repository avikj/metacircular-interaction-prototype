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

TWO ENGINES, ONE ANSWER
-----------------------
``ematch(..., engine=...)`` selects the search:

``"automaton"``  (the default) compiles each pattern **once** into a flat
                 instruction sequence over registers holding e-classes and runs
                 it -- the Simplify / egg e-matching abstract machine.  See THE
                 AUTOMATON below for the instruction set and for the one
                 structural difference that matters: its candidates are e-node
                 *signatures*, so a class of *n* members with the same child
                 classes is one candidate, not *n*.
``"recursive"``  the memoised backtracking matcher the automaton replaced.
                 Retained, not deleted: it is the reference the differential
                 test in ``runtime/tests/test_execute.py`` holds the automaton
                 against, match for match **and in the same order**.

They are required to agree.  What they do *not* share is the meaning of
``visits``: the recursive matcher charges nothing for a memo hit, the automaton
nothing for an entry-cache hit, so ``max_visits`` is a per-engine budget and
never a cross-engine metric.  ``runtime/SCALE.md`` §4 measures both and says so
in those words.

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
    "Program",
    "canonical_member",
    "class_members",
    "compile_pattern",
    "ematch",
    "ematch_rule",
    "ematch_ac",
    "AC_HEADS",
]

COUNTERS = T.Counters()

# Which engine ``ematch`` uses by default.  ``"automaton"`` compiles each
# pattern once into an instruction sequence (see THE AUTOMATON below);
# ``"recursive"`` is the memoised backtracking matcher it replaced.  Both are
# kept, and ``runtime/tests/test_execute.py`` runs a differential test that
# asserts they agree, match for match, on every pattern in the suite.
DEFAULT_ENGINE = "automaton"


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
    __slots__ = ("visits", "budget", "exhausted", "reason", "memo", "sigs")

    def __init__(self, budget: EMatchBudget) -> None:
        self.visits = 0
        self.budget = budget
        self.exhausted = False
        self.reason = ""
        self.memo: Dict[Tuple, Tuple[Tuple[Tuple[str, str], ...], ...]] = {}
        # automaton: (class root, bucket key, sort) -> distinct child-class
        # tuples.  Valid only for the duration of one ``ematch`` call, which is
        # one e-graph snapshot -- exactly the lifetime rule ``memo`` follows.
        self.sigs: Dict[Tuple, Tuple] = {}

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


# --------------------------------------------------------------------------
# THE AUTOMATON
# --------------------------------------------------------------------------
#
# The recursive matcher above is a backtracking search *re-derived per query*:
# every call re-walks the pattern, re-computes bucket keys, re-copies the
# substitution dict at every variable binding, and pays for a generator frame
# per pattern node per candidate.  Saturation calls it once per rule per
# direction per iteration, so all of that is paid again on every pass.
#
# The standard fix (Simplify's e-matching abstract machine; egg's ``Program``)
# is to **compile the pattern once** into a flat instruction sequence over
# registers holding e-classes, and then *run* it.  Three things change, and the
# third is the one that matters:
#
#   1. The pattern walk, the bucket keys and the register layout are computed
#      at compile time, once per (pattern, variable set), and cached.
#   2. The search becomes an explicit index-and-candidate loop over an array of
#      instructions.  No generator frames, no per-binding dict copy: a register
#      file is written in place, because each register is written by exactly one
#      instruction and read only after that instruction has written it.
#   3. **Candidates are e-node *signatures*, not e-nodes.**  A ``bind`` step
#      only ever exposes the *classes* of a node's children, so two nodes of the
#      same class with the same child classes are one candidate.  In a curried
#      IR that collapse is enormous: the partial application ``mul a`` has one
#      node per term equal to ``a``, all with identical child classes, so a
#      class of *n* members contributes **one** candidate instead of *n*.
#      That is the same blow-up the recursive matcher needed its memo table to
#      survive -- here it is removed structurally, before the search sees it.
#
# Instruction set (registers hold class roots; the pattern's own root is
# matched against a *node*, since ``ematch`` reports which node it matched):
#
#   ("app",   src, sort, bucket_key, r_fn, r_arg)   branch: app nodes of class
#   ("lam",   src, sort, dom_addr,   r_body)        branch: lam nodes of class
#   ("const", src, sort, symbol)                    filter: class has that atom
#   ("var",   src, sort, index)                     filter: class has that atom
#   ("vbind", src, sort)                            filter: class sort agrees
#   ("vcmp",  src, other)                           filter: same class
#
# Compilation is in pattern preorder (children[0]'s subtree, then children[1]'s)
# and a repeated variable becomes ``vcmp`` at exactly the position the recursive
# matcher would have compared it.  So the two engines explore in the same order
# and enumerate the same substitutions in the same sequence -- which is what
# lets the differential test in the suite be an equality, not a set comparison.


@dataclass(frozen=True)
class Program:
    """A compiled pattern: the root node test plus the instruction sequence."""

    root: Tuple
    root_key: Tuple
    instrs: Tuple[Tuple, ...]
    nregs: int
    var_regs: Tuple[Tuple[str, int], ...]
    pattern: str

    def render(self) -> str:
        return ("Program(%s: %d instr, %d reg, vars %s)"
                % (self.pattern[:8], len(self.instrs), self.nregs,
                   ",".join(v for v, _ in self.var_regs) or "-"))


_PROGRAM_CACHE: Dict[Tuple[str, frozenset], Program] = {}


def compile_pattern(pat: T.Term, variables: frozenset) -> Program:
    """Compile ``pat`` to an instruction sequence.  Memoised on the pattern."""
    variables = frozenset(variables)
    key = (pat.addr, variables)
    got = _PROGRAM_CACHE.get(key)
    if got is not None:
        COUNTERS.bump("ematch.program_hit")
        return got
    if pat.head == T.CONST and pat.symbol in variables:
        raise ValueError("a bare variable pattern matches everything; refused")

    instrs: List[Tuple] = []
    var_regs: Dict[str, int] = {}
    counter = [0]

    def newreg() -> int:
        r = counter[0]
        counter[0] += 1
        return r

    def walk(p: T.Term, reg: int) -> None:
        """Emit the instructions matching ``p`` against the class in ``reg``."""
        if p.head == T.CONST and p.symbol in variables:
            prev = var_regs.get(p.symbol)
            if prev is None:
                var_regs[p.symbol] = reg
                instrs.append(("vbind", reg, p.sort))
            else:
                instrs.append(("vcmp", reg, prev))
            return
        if p.head == T.APP:
            r0, r1 = newreg(), newreg()
            instrs.append(("app", reg, p.sort, _pattern_key(p, variables), r0, r1))
            walk(p.children[0], r0)
            walk(p.children[1], r1)
            return
        if p.head == T.LAM:
            rb = newreg()
            instrs.append(("lam", reg, p.sort, p.dom.addr, rb))
            walk(p.children[0], rb)
            return
        if p.head == T.CONST:
            instrs.append(("const", reg, p.sort, p.symbol))
            return
        instrs.append(("var", reg, p.sort, p.index))

    if pat.head == T.APP:
        r0, r1 = newreg(), newreg()
        root: Tuple = ("app", pat.sort, r0, r1)
        walk(pat.children[0], r0)
        walk(pat.children[1], r1)
    elif pat.head == T.LAM:
        rb = newreg()
        root = ("lam", pat.sort, pat.dom.addr, rb)
        walk(pat.children[0], rb)
    elif pat.head == T.CONST:
        root = ("const", pat.sort, pat.symbol)
    else:
        root = ("var", pat.sort, pat.index)

    prog = Program(root=root, root_key=_pattern_key(pat, variables),
                   instrs=tuple(instrs), nregs=counter[0],
                   var_regs=tuple(sorted(var_regs.items())), pattern=pat.addr)
    _PROGRAM_CACHE[key] = prog
    COUNTERS.bump("ematch.program_compile")
    return prog


def _signatures(g: EGraph, st: _State, root: str, key: Tuple, sort,
                arity: int) -> Tuple[Tuple[str, ...], ...]:
    """Distinct child-class tuples of the class's nodes in one bucket.

    This is the automaton's whole advantage over node-by-node backtracking, and
    it loses nothing: an instruction downstream of a bind can only observe the
    *classes* of the children, so two nodes agreeing on those are the same
    choice.  Cached per ``ematch`` call, i.e. per e-graph snapshot.
    """
    ck = (root, key, sort, arity)
    got = st.sigs.get(ck)
    if got is not None:
        COUNTERS.bump("ematch.sig_hit")
        return got
    seen: Dict[Tuple[str, ...], None] = {}
    for m in class_index(g, root).get(key, ()):
        if m.sort is not sort:
            continue
        sig = tuple(g.find(c.addr) for c in m.children[:arity])
        if sig not in seen:
            seen[sig] = None
    out = tuple(seen)
    st.sigs[ck] = out
    COUNTERS.bump("ematch.sig_build")
    return out


def _has_atom(g: EGraph, root: str, key: Tuple, sort) -> bool:
    for m in class_index(g, root).get(key, ()):
        if m.sort is sort:
            return True
    return False


_YES: Tuple = ((),)
_NO: Tuple = ()


def _candidates(g: EGraph, ins: Tuple, regs: List[str], st: _State) -> Tuple:
    op = ins[0]
    if op == "app":
        return _signatures(g, st, regs[ins[1]], ins[3], ins[2], 2)
    if op == "vcmp":
        return _YES if regs[ins[1]] == regs[ins[2]] else _NO
    if op == "vbind":
        return _YES if _class_sort(g, regs[ins[1]]) is ins[2] else _NO
    if op == "const":
        return _YES if _has_atom(g, regs[ins[1]], ("const", ins[3]), ins[2]) else _NO
    if op == "var":
        return _YES if _has_atom(g, regs[ins[1]], ("var", ins[3]), ins[2]) else _NO
    if op == "lam":
        return _signatures(g, st, regs[ins[1]], ("lam", ins[3]), ins[2], 1)
    raise AssertionError("unknown instruction %r" % (op,))


def _write(ins: Tuple, cand: Tuple, regs: List[str]) -> None:
    op = ins[0]
    if op == "app":
        regs[ins[4]] = cand[0]
        regs[ins[5]] = cand[1]
    elif op == "lam":
        regs[ins[4]] = cand[0]


def _root_sig(g: EGraph, prog: Program, node: T.Term) -> Optional[Tuple]:
    """The node's *entry signature*, or ``None`` if it cannot start this pattern.

    Two nodes with the same entry signature drive identical runs of the program,
    so ``ematch`` runs the machine once per distinct signature and replays the
    answer for every node carrying it.  This is where the automaton recovers the
    cross-node reuse the recursive matcher bought with its memo table -- at a
    tuple lookup, with no substitution in the key.
    """
    root = prog.root
    if node.sort is not root[1]:
        return None
    kind = root[0]
    if kind == "app":
        if node.head != T.APP:
            return None
        return (g.find(node.children[0].addr), g.find(node.children[1].addr))
    if kind == "lam":
        if node.head != T.LAM or node.dom.addr != root[2]:
            return None
        return (g.find(node.children[0].addr),)
    if kind == "const":
        return () if (node.head == T.CONST and node.symbol == root[2]) else None
    return () if (node.head == T.VAR and node.index == root[2]) else None


def _run_program(g: EGraph, prog: Program, sig: Tuple, st: _State
                 ) -> Iterator[Dict[str, str]]:
    """Run a compiled pattern from an entry signature.  Yields class substs."""
    regs: List[str] = [""] * prog.nregs
    root = prog.root
    if root[0] == "app":
        regs[root[2]], regs[root[3]] = sig
    elif root[0] == "lam":
        regs[root[3]] = sig[0]

    instrs = prog.instrs
    n = len(instrs)
    var_regs = prog.var_regs
    if n == 0:
        yield {v: regs[r] for v, r in var_regs}
        return

    cands: List[Optional[Tuple]] = [None] * n
    idx = [0] * n
    pc = 0
    while pc >= 0:
        c = cands[pc]
        if c is None:
            c = cands[pc] = _candidates(g, instrs[pc], regs, st)
            idx[pc] = 0
        i = idx[pc]
        if i >= len(c):
            cands[pc] = None
            pc -= 1
            continue
        idx[pc] = i + 1
        if not st.visit():
            return
        _write(instrs[pc], c[i], regs)
        if pc == n - 1:
            yield {v: regs[r] for v, r in var_regs}
        else:
            pc += 1


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
           roots: Optional[Sequence[str]] = None,
           engine: Optional[str] = None) -> EMatchResult:
    """All substitutions matching ``pattern`` against the e-graph, bounded.

    Returns an ``EMatchResult``; check ``.complete`` before treating
    ``.matches`` as exhaustive.

    ``engine`` selects the search: ``"automaton"`` (compiled instruction
    sequence, the default) or ``"recursive"`` (the memoised backtracking
    matcher).  They are required to agree; the parameter exists so the suite
    can hold them against each other and so a regression can be bisected
    without editing this file.
    """
    variables = frozenset(variables)
    if pattern.head == T.CONST and pattern.symbol in variables:
        raise ValueError("a bare variable pattern matches everything; refused")
    engine = engine or DEFAULT_ENGINE
    if engine not in ("automaton", "recursive"):
        raise ValueError("unknown e-match engine %r" % (engine,))
    prog = compile_pattern(pattern, variables) if engine == "automaton" else None
    nvars = len(vars_of(pattern, variables))
    exhaustive = nvars <= budget.max_exhaustive_vars
    st = _State(budget)
    found: Dict[Tuple, EMatch] = {}
    if roots is None:
        root_list = sorted({g.find(a) for a in g.terms()})
    else:
        root_list = sorted({g.find(r) for r in roots})
    for root in root_list:
        entry: Dict[Tuple, Tuple[Dict[str, str], ...]] = {}
        # The compiled program knows which bucket of the class can possibly
        # start it, so the automaton scans that bucket instead of every member.
        # The recursive matcher pays a visit per member and rejects each inside
        # ``_match_node``; this rejects them by not looking at them.
        candidates = (class_index(g, root).get(prog.root_key, ())
                      if prog is not None else class_members(g, root))
        for member in candidates:
            seen_classes: Dict[Tuple, None] = {}
            if prog is not None:
                if not st.visit():
                    break
                sig = _root_sig(g, prog, member)
                if sig is None:
                    continue
                source = entry.get(sig)
                if source is None:
                    acc = list(_run_program(g, prog, sig, st))
                    # never cache an abandoned search (same rule as the memo)
                    source = tuple(acc)
                    if not st.exhausted:
                        entry[sig] = source
                else:
                    COUNTERS.bump("ematch.entry_hit")
            else:
                source = _match_node(g, pattern, member, {}, st, variables)
            for csigma in source:
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


# --------------------------------------------------------------------------
# the AC route -- additive, default off (see ``execute/AC.md``)
# --------------------------------------------------------------------------
#
# Nothing above this line changed when ``acmatch.py`` landed.  ``AC_HEADS`` is
# empty by default and ``ematch_ac`` with no AC heads *is* ``ematch``, so every
# number published against this module is reproduced unchanged.  Only the
# residue-free (permutation) case is exposed here: ``EMatch`` has nowhere to
# put a residue, and a residue with no home is precisely the AC rewriting bug
# ``acmatch`` exists to avoid.  The residue-carrying matcher lives in
# ``acmatch.ac_match`` over the flat n-ary ring substrate, where reassembly is
# defined.

AC_HEADS: Tuple[str, ...] = ()


def ematch_ac(g: EGraph, pattern: T.Term, variables,
              budget: EMatchBudget = EMatchBudget(),
              roots: Optional[Sequence[str]] = None,
              engine: Optional[str] = None,
              ac_heads: Optional[Sequence[str]] = None) -> EMatchResult:
    """``ematch`` plus the matches that only exist modulo AC of ``ac_heads``.

    ``ac_heads`` names curried binary constants declared associative *and*
    commutative.  With none named this returns exactly ``ematch``'s result --
    same matches, same order, same visit count.
    """
    base = ematch(g, pattern, variables, budget, roots, engine)
    heads = tuple(ac_heads) if ac_heads is not None else AC_HEADS
    if not heads:
        return base
    from . import acmatch as _ac
    vs = frozenset(variables)
    found: Dict[Tuple, EMatch] = {m.key(): m for m in base.matches}
    extra = 0
    root_list = (sorted({g.find(a) for a in g.terms()}) if roots is None
                 else sorted({g.find(r) for r in roots}))
    for root in root_list:
        for member in class_members(g, root):
            for sym in heads:
                for sigma in _ac.ac_permutation_matches(pattern, member, vs, sym):
                    m = EMatch(root=root, matched=member.addr,
                               subst=tuple(sorted(sigma.items(),
                                                  key=lambda kv: kv[0])))
                    if m.key() not in found:
                        found[m.key()] = m
                        extra += 1
    COUNTERS.bump("ematch.ac_extra", extra)
    return EMatchResult(matches=tuple(found.values()), visits=base.visits,
                        budget=budget, exhausted=base.exhausted,
                        reason=base.reason)
