"""Derivation DAGs, exact step counters, and the ring-term substrate.

Self-contained: imports nothing from ``runtime.kernel`` (a sibling agent owns
that module).  Pure Python 3 stdlib, exact integer arithmetic only, no floats,
no randomness, no I/O.  Every structure here is deterministic: two runs of the
same program produce byte-identical output.

DOMAIN
------
Terms of the free commutative ring ``Z[x1,x2,...]`` written with *flat n-ary*
sum and product nodes::

    t ::= Int(n) | Var(s) | Sum([t,...]) | Prod([t,...])

Subtraction is sugar: ``a - b`` is ``Sum([a, Prod([Int(-1), b])])``.  There is
no division and no negation node, so the term language is closed under the
rewrite rules and every rule is an instance of a commutative-ring axiom.

Why this domain (see README.md for the long form): normalisation of ring
expressions is (a) exactly decidable with integer arithmetic, (b) genuinely
*expensive* the slow way -- expanding a product of sums is quadratic and
canonical sorting is quadratic again -- and (c) it hosts a real repeated
pattern, difference of squares, whose least general generalisation needs a
*consistent* variable map (the same subterm appears at two positions on the
left and two on the right).  A sloppy anti-unifier produces a plausible but
FALSE lemma there, which is exactly the failure mode we want to be able to
detect.

ADDRESSES
---------
Terms are hash-consed.  A term's address is the SHA-256 of an explicit
encoding of its head *and its children's addresses* (CRYSTAL.md L0).  We never
use Python's ``hash()`` for anything observable, so addresses are stable across
processes and across runs regardless of ``PYTHONHASHSEED``.
"""

from __future__ import annotations

import hashlib
from typing import Dict, List, Optional, Sequence, Tuple

# --------------------------------------------------------------------------
# Terms
# --------------------------------------------------------------------------

INT = "int"
VAR = "var"
SUM = "sum"
PROD = "prod"

_INTERN: Dict[str, "Term"] = {}


class Term:
    """An immutable, hash-consed ring term.

    Construct through :func:`mk` / the :func:`I`, :func:`V`, :func:`S`,
    :func:`P` helpers -- never directly -- so that interning holds.
    """

    __slots__ = ("kind", "val", "args", "addr", "_ckey", "_size")

    def __init__(self, kind: str, val, args: Tuple["Term", ...], addr: str):
        self.kind = kind
        self.val = val
        self.args = args
        self.addr = addr
        self._ckey: Optional[str] = None
        self._size: Optional[int] = None

    # -- identity ---------------------------------------------------------
    def __eq__(self, other):  # interned: identity is address equality
        return self is other or (
            isinstance(other, Term) and self.addr == other.addr
        )

    def __hash__(self):
        # Derived from our own deterministic address, not from object id.
        return int(self.addr[:8], 16)

    def __repr__(self):
        return render(self)

    # -- derived measures -------------------------------------------------
    @property
    def size(self) -> int:
        if self._size is None:
            self._size = 1 + sum(a.size for a in self.args)
        return self._size

    @property
    def ckey(self) -> str:
        """Canonical order key: a string, so comparison is a total order."""
        if self._ckey is None:
            self._ckey = _ckey(self)
        return self._ckey


def _encode_head(kind: str, val, args: Sequence[Term]) -> str:
    if kind == INT:
        return "I|%d" % val
    if kind == VAR:
        return "V|%s" % val
    return "%s|%s" % (kind, ",".join(a.addr for a in args))


def mk(kind: str, val=None, args: Sequence[Term] = ()) -> Term:
    args = tuple(args)
    enc = _encode_head(kind, val, args)
    got = _INTERN.get(enc)
    if got is not None:
        return got
    addr = hashlib.sha256(enc.encode("utf-8")).hexdigest()[:16]
    t = Term(kind, val, args, addr)
    _INTERN[enc] = t
    return t


def I(n: int) -> Term:  # noqa: E743 - short constructor by design
    if not isinstance(n, int) or isinstance(n, bool):
        raise TypeError("Int takes a Python int (exact); got %r" % (n,))
    return mk(INT, n, ())


def V(name: str) -> Term:
    return mk(VAR, name, ())


def S(*args: Term) -> Term:
    return mk(SUM, None, args)


def P(*args: Term) -> Term:
    return mk(PROD, None, args)


def Sub(a: Term, b: Term) -> Term:
    """Sugar: ``a - b``.  Not a primitive; expands to ``a + (-1)*b``."""
    return S(a, P(I(-1), b))


# Pattern variables live in the same term language as ordinary Vars but with a
# reserved prefix, so a pattern is just a term and matching is one-way.
PVAR_PREFIX = "#"


def PV(k: int) -> Term:
    return V("%s%d" % (PVAR_PREFIX, k))


def is_pvar(t: Term) -> bool:
    return t.kind == VAR and t.val.startswith(PVAR_PREFIX)


def pvars_of(t: Term) -> List[Term]:
    """Pattern variables of ``t`` in deterministic (first-occurrence) order."""
    out: List[Term] = []
    seen = set()
    stack = [t]
    # explicit pre-order walk, children left to right
    while stack:
        n = stack.pop()
        if is_pvar(n) and n.addr not in seen:
            seen.add(n.addr)
            out.append(n)
        for a in reversed(n.args):
            stack.append(a)
    out.sort(key=lambda v: int(v.val[len(PVAR_PREFIX):]))
    return out


# --------------------------------------------------------------------------
# Canonical order key (a total order on terms, exact and stable)
# --------------------------------------------------------------------------

_PAD = 24


def _int_key(n: int) -> str:
    # Sign-aware fixed-width encoding so string order == integer order.
    if n < 0:
        # complement so that more-negative sorts first
        return "-%0*d" % (_PAD, 10 ** _PAD - 1 + n)
    return "+%0*d" % (_PAD, n)


def _ckey(t: Term) -> str:
    if t.kind == INT:
        return "0:" + _int_key(t.val)
    if t.kind == VAR:
        return "1:" + t.val
    tag = "2" if t.kind == PROD else "3"
    return tag + ":(" + ",".join(a.ckey for a in t.args) + ")"


# --------------------------------------------------------------------------
# Rendering (deterministic, for the demo table and for error messages)
# --------------------------------------------------------------------------

def render(t: Term) -> str:
    if t.kind == INT:
        return str(t.val)
    if t.kind == VAR:
        return t.val
    if t.kind == SUM:
        if not t.args:
            return "0"
        return "(" + " + ".join(render(a) for a in t.args) + ")"
    if not t.args:
        return "1"
    return "(" + "*".join(render(a) for a in t.args) + ")"


# --------------------------------------------------------------------------
# Positions
# --------------------------------------------------------------------------

Position = Tuple[int, ...]
ROOT: Position = ()


def at(t: Term, p: Position) -> Term:
    for i in p:
        t = t.args[i]
    return t


def replace_at(t: Term, p: Position, new: Term) -> Term:
    if not p:
        return new
    i = p[0]
    kids = list(t.args)
    kids[i] = replace_at(kids[i], p[1:], new)
    return mk(t.kind, t.val, kids)


def positions_postorder(t: Term, prefix: Position = ROOT) -> List[Position]:
    """Innermost-leftmost enumeration: children before parents, left to right."""
    out: List[Position] = []
    for i, a in enumerate(t.args):
        out.extend(positions_postorder(a, prefix + (i,)))
    out.append(prefix)
    return out


def common_prefix(ps: Sequence[Position]) -> Position:
    if not ps:
        return ROOT
    out: List[int] = []
    for col in zip(*ps):
        if len(set(col)) == 1:
            out.append(col[0])
        else:
            break
    if not all(len(p) >= len(out) for p in ps):
        out = out[: min(len(p) for p in ps)]
    return tuple(out)


# --------------------------------------------------------------------------
# The step counter -- "the counters ARE the experiment" (CRYSTAL.md sec 7)
# --------------------------------------------------------------------------

class Counter:
    """Exact counters.  ``steps`` is the headline kernel-step count.

    ``steps``  -- rewrite steps that entered the derivation DAG.  This is the
                  number CRYSTAL.md sec 0 is about.
    ``work``   -- rule/lemma *match attempts*.  Search overhead, reported
                  separately so that a step reduction bought with an
                  unbounded search cost is visible rather than hidden.
    ``checks`` -- primitive step validations performed by the checker.
    """

    __slots__ = ("steps", "work", "checks")

    def __init__(self) -> None:
        self.steps = 0
        self.work = 0
        self.checks = 0

    def tick(self, n: int = 1) -> None:
        self.steps += n

    def effort(self, n: int = 1) -> None:
        self.work += n

    def checked(self, n: int = 1) -> None:
        self.checks += n

    def snapshot(self) -> Tuple[int, int, int]:
        return (self.steps, self.work, self.checks)

    def __repr__(self):
        return "Counter(steps=%d, work=%d, checks=%d)" % (
            self.steps, self.work, self.checks)


# --------------------------------------------------------------------------
# Derivation DAG
# --------------------------------------------------------------------------

class Step:
    """One typed rewrite step.

    A step is a node of the derivation DAG.  Its *input addresses* are the
    addresses of the whole term before the step and of the redex; its *output
    address* is the address of the whole term after.  Because terms are
    hash-consed, a step that produces an address another step consumes is the
    DAG edge -- we do not store edges separately, the addresses are the edges.
    """

    __slots__ = ("index", "rule", "pos", "redex", "contractum",
                 "before", "after", "lemma_id")

    def __init__(self, index: int, rule: str, pos: Position, redex: Term,
                 contractum: Term, before: Term, after: Term,
                 lemma_id: Optional[str] = None):
        self.index = index
        self.rule = rule
        self.pos = pos
        self.redex = redex
        self.contractum = contractum
        self.before = before
        self.after = after
        self.lemma_id = lemma_id

    @property
    def in_addrs(self) -> Tuple[str, str]:
        return (self.before.addr, self.redex.addr)

    @property
    def out_addr(self) -> str:
        return self.after.addr

    def __repr__(self):
        return "Step(%d, %s @%s)" % (self.index, self.rule, list(self.pos))


class Derivation:
    """A recorded, replayable derivation: ``start`` --steps--> ``result``."""

    __slots__ = ("name", "start", "steps")

    def __init__(self, name: str, start: Term):
        self.name = name
        self.start = start
        self.steps: List[Step] = []

    def record(self, rule: str, pos: Position, redex: Term, contractum: Term,
               before: Term, after: Term, lemma_id: Optional[str] = None) -> Step:
        st = Step(len(self.steps), rule, pos, redex, contractum, before, after,
                  lemma_id)
        self.steps.append(st)
        return st

    @property
    def result(self) -> Term:
        return self.steps[-1].after if self.steps else self.start

    def __len__(self) -> int:
        return len(self.steps)

    def rule_seq(self) -> Tuple[str, ...]:
        return tuple(s.rule for s in self.steps)

    def chain_ok(self) -> bool:
        """Structural integrity of the DAG: outputs feed inputs, in order."""
        cur = self.start
        for s in self.steps:
            if s.before.addr != cur.addr:
                return False
            if at(s.before, s.pos).addr != s.redex.addr:
                return False
            if replace_at(s.before, s.pos, s.contractum).addr != s.after.addr:
                return False
            cur = s.after
        return True


# ==========================================================================
# The rewrite system: commutative-ring axioms as oriented rules
# ==========================================================================
#
# Each rule below is a function ``Term -> Optional[Term]`` acting on a single
# node.  Every rule is an instance of a commutative-ring axiom:
#
#   zero_prod   0 * a           = 0            (annihilation)
#   empty_prod  ()              = 1            (empty product)
#   empty_sum   ()              = 0            (empty sum)
#   single_*    (a)             = a            (unary flattening)
#   flat_*      assoc           of + and *
#   fold_*      evaluation      in Z
#   unit_prod   1 * a           = a
#   unit_sum    0 + a           = a
#   distrib     a*(b+c)         = a*b + a*c
#   collect     c1*m + c2*m     = (c1+c2)*m    (distributivity, contracted)
#   sort_*      comm            of + and *
#
# Orientation: each rule either strictly decreases the term's size, or
# strictly decreases the number of Sum-nodes below a Prod-node (distrib), or
# strictly decreases the number of order inversions (sort_*), or strictly
# decreases the number of summands (collect).  The lexicographic combination
# is well founded, so the system terminates; the engine additionally carries a
# cycle guard and a hard step cap so a *badly installed lemma* cannot make it
# loop silently.


def _r_zero_prod(t: Term):
    if t.kind == PROD and any(a.kind == INT and a.val == 0 for a in t.args):
        z = I(0)
        return None if t is z else z
    return None


def _r_empty_prod(t: Term):
    return I(1) if t.kind == PROD and not t.args else None


def _r_empty_sum(t: Term):
    return I(0) if t.kind == SUM and not t.args else None


def _r_single_prod(t: Term):
    return t.args[0] if t.kind == PROD and len(t.args) == 1 else None


def _r_single_sum(t: Term):
    return t.args[0] if t.kind == SUM and len(t.args) == 1 else None


def _splice(t: Term, kind: str):
    for i, a in enumerate(t.args):
        if a.kind == kind:
            return mk(kind, None, t.args[:i] + a.args + t.args[i + 1:])
    return None


def _r_flat_prod(t: Term):
    return _splice(t, PROD) if t.kind == PROD else None


def _r_flat_sum(t: Term):
    return _splice(t, SUM) if t.kind == SUM else None


def _fold(t: Term, kind: str, combine):
    idx = [i for i, a in enumerate(t.args) if a.kind == INT]
    if len(idx) < 2:
        return None
    i, j = idx[0], idx[1]
    v = combine(t.args[i].val, t.args[j].val)
    rest = [a for k, a in enumerate(t.args) if k != i and k != j]
    return mk(kind, None, [I(v)] + rest)


def _r_fold_prod(t: Term):
    return _fold(t, PROD, lambda a, b: a * b) if t.kind == PROD else None


def _r_fold_sum(t: Term):
    return _fold(t, SUM, lambda a, b: a + b) if t.kind == SUM else None


def _drop_unit(t: Term, kind: str, unit: int):
    if len(t.args) <= 1:
        return None
    for i, a in enumerate(t.args):
        if a.kind == INT and a.val == unit:
            return mk(kind, None, t.args[:i] + t.args[i + 1:])
    return None


def _r_unit_prod(t: Term):
    return _drop_unit(t, PROD, 1) if t.kind == PROD else None


def _r_unit_sum(t: Term):
    return _drop_unit(t, SUM, 0) if t.kind == SUM else None


def _r_distrib(t: Term):
    if t.kind != PROD:
        return None
    for i, a in enumerate(t.args):
        if a.kind == SUM:
            head, tail = t.args[:i], t.args[i + 1:]
            return S(*[P(*(head + (s,) + tail)) for s in a.args])
    return None


def monomial(t: Term) -> Optional[Tuple[int, Tuple[Term, ...]]]:
    """Split ``t`` into an integer coefficient and the remaining factors.

    ``None`` for a bare integer -- those are handled by ``fold_sum``.  The
    remaining factors keep their original order: ``collect`` only fires on
    *identical* factor tuples, so commutativity must be discharged by explicit
    ``sort_prod`` steps first.  That keeps every step a single axiom instance.
    """
    if t.kind == INT:
        return None
    if t.kind == PROD:
        for i, a in enumerate(t.args):
            if a.kind == INT:
                return (a.val, t.args[:i] + t.args[i + 1:])
        return (1, t.args)
    return (1, (t,))


def _r_collect(t: Term):
    if t.kind != SUM or len(t.args) < 2:
        return None
    monos = [monomial(a) for a in t.args]
    for i in range(len(monos)):
        if monos[i] is None:
            continue
        ci, ri = monos[i]
        for j in range(i + 1, len(monos)):
            if monos[j] is None:
                continue
            cj, rj = monos[j]
            if len(ri) == len(rj) and all(
                    x.addr == y.addr for x, y in zip(ri, rj)):
                merged = I(ci + cj) if not ri else P(*((I(ci + cj),) + ri))
                rest = [a for k, a in enumerate(t.args) if k != i and k != j]
                return S(*([merged] + rest))
    return None


def _sort_swap(t: Term, kind: str):
    for i in range(len(t.args) - 1):
        if t.args[i].ckey > t.args[i + 1].ckey:
            a = list(t.args)
            a[i], a[i + 1] = a[i + 1], a[i]
            return mk(kind, None, a)
    return None


def _r_sort_prod(t: Term):
    return _sort_swap(t, PROD) if t.kind == PROD else None


def _r_sort_sum(t: Term):
    return _sort_swap(t, SUM) if t.kind == SUM else None


# Priority order is part of the strategy and therefore part of determinism.
RULES: List[Tuple[str, object]] = [
    ("zero_prod", _r_zero_prod),
    ("empty_prod", _r_empty_prod),
    ("empty_sum", _r_empty_sum),
    ("single_prod", _r_single_prod),
    ("single_sum", _r_single_sum),
    ("flat_prod", _r_flat_prod),
    ("flat_sum", _r_flat_sum),
    ("fold_prod", _r_fold_prod),
    ("fold_sum", _r_fold_sum),
    ("unit_prod", _r_unit_prod),
    ("unit_sum", _r_unit_sum),
    ("distrib", _r_distrib),
    ("collect", _r_collect),
    ("sort_prod", _r_sort_prod),
    ("sort_sum", _r_sort_sum),
]

RULE_TABLE = dict(RULES)


# ==========================================================================
# One-way matching and substitution (term-level primitives)
# ==========================================================================

Subst = Dict[str, Term]


def subst(t: Term, sigma: Subst) -> Term:
    if t.kind == VAR:
        return sigma.get(t.val, t)
    if not t.args:
        return t
    return mk(t.kind, t.val, [subst(a, sigma) for a in t.args])


def match(pattern: Term, t: Term, sigma: Optional[Subst] = None) -> Optional[Subst]:
    """One-way syntactic match.  Pattern variables (``#k``) bind; every other
    symbol must agree exactly.  A repeated pattern variable must bind to the
    *same address* at every occurrence -- this is what makes an installed
    least-general-generalisation sound rather than merely suggestive."""
    if sigma is None:
        sigma = {}
    if is_pvar(pattern):
        bound = sigma.get(pattern.val)
        if bound is None:
            sigma = dict(sigma)
            sigma[pattern.val] = t
            return sigma
        return sigma if bound.addr == t.addr else None
    if pattern.kind != t.kind or pattern.val != t.val:
        return None
    if len(pattern.args) != len(t.args):
        return None
    for p, a in zip(pattern.args, t.args):
        sigma = match(p, a, sigma)
        if sigma is None:
            return None
    return sigma


# ==========================================================================
# The engine
# ==========================================================================

MAX_STEPS = 200000


class Divergence(Exception):
    """Raised when the strategy fails to terminate -- e.g. a badly installed
    lemma creates a cycle.  Never swallowed: a runtime that hides divergence
    is not measuring anything."""


class Lemma:
    """A derived rewrite available as a single step.

    ``lhs``/``rhs`` are terms over pattern variables ``#0, #1, ...``.  A lemma
    is *installed* only after :mod:`install` has checked it; this class carries
    no authority of its own.
    """

    __slots__ = ("lid", "lhs", "rhs", "proof_rules", "provenance")

    def __init__(self, lid: str, lhs: Term, rhs: Term,
                 proof_rules: Tuple[str, ...] = (), provenance: str = ""):
        self.lid = lid
        self.lhs = lhs
        self.rhs = rhs
        self.proof_rules = tuple(proof_rules)
        self.provenance = provenance

    def __repr__(self):
        return "Lemma(%s: %s  ==>  %s)" % (self.lid, render(self.lhs),
                                           render(self.rhs))


# --------------------------------------------------------------------------
# the discrimination net (README sec.6 item 1: "this is the first thing that
# must change")
# --------------------------------------------------------------------------
#
# ``_try_lemmas`` below is a linear scan: every lemma is match-attempted at
# every position of every intermediate term, so the search is O(|book| *
# |term|) per step.  ``runtime/SCALE.md`` measures where that stops paying:
# on the demo's independent problem the mined lemma saves 17 kernel steps for
# ever, but the book's search work passes the no-lemma baseline at **22
# lemmas** -- an order of magnitude earlier than the README's "a few hundred"
# estimate.
#
# The fix the crystallize lane named is an index on lemma left-hand sides, and
# this is it.  ``match`` is one-way and purely structural: at a non-variable
# pattern node it demands the same ``(kind, val, arity)`` as the subject.  So
# for a fixed set of probe positions, a lemma whose left side carries a
# concrete key at a probe cannot possibly match a subject that carries a
# different key (or nothing) there.  Indexing on those keys therefore
# **removes only match attempts that were guaranteed to fail** -- the candidate
# list is a superset of the matches, and the derivation is identical, step for
# step.  That equality is asserted by the tests and by ``scale_lemmas.py``.
#
# The lookup is not free and is not free of charge either: every probe costs a
# counted work unit, as does every lemma inserted at build time, so the index's
# own cost appears in the same column as the scan it replaces.

PROBES: Tuple[Position, ...] = ((), (0,), (1,), (2,), (0, 0), (0, 1), (1, 0), (1, 1))


def _at_opt(t: Term, p: Position) -> Optional[Term]:
    for i in p:
        if i >= len(t.args):
            return None
        t = t.args[i]
    return t


def _node_key(t: Term) -> Tuple:
    """Exactly what ``match`` demands to agree at a non-variable pattern node."""
    return (t.kind, t.val, len(t.args))


class LemmaIndex:
    """A discrimination net over lemma left-hand sides.

    ``candidates(node)`` returns the lemmas whose left side agrees with ``node``
    at every probe position where the left side is not a pattern variable, in
    installation order.  It is a *filter*, never a truncation: a lemma it drops
    could not have matched.
    """

    __slots__ = ("lemmas", "masks", "wild", "full")

    def __init__(self, lemmas: Sequence[Lemma],
                 ctr: Optional[Counter] = None) -> None:
        self.lemmas = tuple(lemmas)
        self.masks: List[Dict[Tuple, int]] = [{} for _ in PROBES]
        self.wild: List[int] = [0] * len(PROBES)
        for i, lem in enumerate(self.lemmas):
            bit = 1 << i
            for j, p in enumerate(PROBES):
                if ctr is not None:
                    ctr.effort()
                node = _at_opt(lem.lhs, p)
                if node is None or is_pvar(node):
                    self.wild[j] |= bit
                else:
                    k = _node_key(node)
                    self.masks[j][k] = self.masks[j].get(k, 0) | bit
        self.full = (1 << len(self.lemmas)) - 1

    def candidates(self, t: Term, ctr: Optional[Counter] = None) -> List[Lemma]:
        m = self.full
        for j, p in enumerate(PROBES):
            if not m:
                break
            if ctr is not None:
                ctr.effort()
            node = _at_opt(t, p)
            if node is None:
                m &= self.wild[j]
            else:
                m &= self.masks[j].get(_node_key(node), 0) | self.wild[j]
        out: List[Lemma] = []
        while m:
            b = m & -m
            out.append(self.lemmas[b.bit_length() - 1])
            m ^= b
        return out


def _try_lemmas_indexed(t: Term, index: LemmaIndex, ctr: Counter):
    """``_try_lemmas`` with the scan replaced by an index lookup.

    Same traversal, same priority, same first hit -- the only difference is
    which lemmas are match-attempted at each node.
    """
    for p in positions_postorder(t):
        node = at(t, p)
        for lem in index.candidates(node, ctr):
            ctr.effort()
            sigma = match(lem.lhs, node)
            if sigma is not None:
                return (p, node, subst(lem.rhs, sigma), lem)
    return None


def _try_lemmas(t: Term, lemmas: Sequence[Lemma], ctr: Counter):
    """Innermost-leftmost search for a lemma redex over the whole term.

    Lemmas are tried over the *entire* term before any primitive rule fires in
    an iteration.  Reason: a primitive rule (canonical sorting, say) can
    destroy the syntactic shape a lemma is stated in, so giving primitives
    first refusal would make lemma applicability depend on accidents of the
    ordering.  Cost of the policy is counted in ``ctr.work``.
    """
    for p in positions_postorder(t):
        node = at(t, p)
        for lem in lemmas:
            ctr.effort()
            sigma = match(lem.lhs, node)
            if sigma is not None:
                return (p, node, subst(lem.rhs, sigma), lem)
    return None


def _try_primitive(t: Term, ctr: Counter):
    for p in positions_postorder(t):
        node = at(t, p)
        for name, fn in RULES:
            ctr.effort()
            out = fn(node)
            if out is not None and out.addr != node.addr:
                return (p, node, out, name)
    return None


def normalize(start: Term, lemmas: Sequence[Lemma] = (),
              ctr: Optional[Counter] = None, name: str = "derivation",
              max_steps: int = MAX_STEPS,
              use_index: bool = False,
              index: Optional["LemmaIndex"] = None) -> Tuple[Derivation, Counter]:
    """Normalise ``start``, recording every step in a :class:`Derivation`.

    Deterministic: fixed rule priority, innermost-leftmost redex selection,
    lemmas before primitives.  Terminating: a cycle guard on whole-term
    addresses plus a hard step cap, both of which raise rather than return a
    wrong answer.

    ``use_index`` selects the discrimination net (``LemmaIndex``) instead of the
    linear scan over the book, building the net here and charging its
    construction to ``ctr.work``.  ``index=`` takes a net built once for a book
    and reused across problems, which is how a real caller would pay for it.
    Either way the net is required to produce the *same derivation*, step for
    step -- it changes only the ``work`` counter.  The default is ``False`` so
    that every number already published against this module stays reproducible;
    ``runtime/SCALE.md`` measures both and says what flipping it would cost and
    buy.
    """
    if ctr is None:
        ctr = Counter()
    if index is None and use_index and lemmas:
        index = LemmaIndex(lemmas, ctr)
    d = Derivation(name, start)
    cur = start
    seen = {start.addr}
    while True:
        if len(d) >= max_steps:
            raise Divergence("step cap %d exceeded on %s" % (max_steps, name))
        if index is not None:
            hit = _try_lemmas_indexed(cur, index, ctr)
        else:
            hit = _try_lemmas(cur, lemmas, ctr) if lemmas else None
        if hit is not None:
            p, redex, contractum, lem = hit
            rule, lid = "lemma:" + lem.lid, lem.lid
        else:
            hit = _try_primitive(cur, ctr)
            if hit is None:
                break
            p, redex, contractum, rule = hit
            lid = None
        nxt = replace_at(cur, p, contractum)
        if nxt.addr in seen:
            raise Divergence(
                "cycle at step %d of %s (rule %s)" % (len(d), name, rule))
        seen.add(nxt.addr)
        d.record(rule, p, redex, contractum, cur, nxt, lid)
        ctr.tick()
        cur = nxt
    return d, ctr


# ==========================================================================
# The checking discipline
# ==========================================================================
#
# Two independent checks, both exact:
#
#   (A) SYNTACTIC.  Every step is re-derived from its named rule schema by the
#       trusted checker.  For a primitive step the checker re-runs the rule
#       function on the recorded redex and demands the recorded contractum
#       back, and demands that the whole-term before/after really are the
#       recorded redex/contractum plugged in at the recorded position.  For a
#       lemma step the checker re-matches the lemma's LHS and re-instantiates
#       its RHS.  Nothing is taken on assertion.
#
#   (B) SEMANTIC.  Exact evaluation on an integer grid, with a *complete*
#       bound: a polynomial over Z of degree <= d_i in variable x_i that
#       vanishes on a grid of (d_1+1) x ... x (d_k+1) integer points is
#       identically zero (induction on k; over an integral domain a univariate
#       polynomial of degree <= d with d+1 roots is zero).  So this is a
#       decision procedure, not a spot check.


def evaluate(t: Term, env: Dict[str, int]) -> int:
    if t.kind == INT:
        return t.val
    if t.kind == VAR:
        if t.val not in env:
            raise KeyError("unbound variable %r in evaluation" % t.val)
        return env[t.val]
    if t.kind == SUM:
        acc = 0
        for a in t.args:
            acc += evaluate(a, env)
        return acc
    acc = 1
    for a in t.args:
        acc *= evaluate(a, env)
    return acc


def degree_bounds(t: Term, acc: Optional[Dict[str, int]] = None) -> Dict[str, int]:
    if t.kind == INT:
        return {}
    if t.kind == VAR:
        return {t.val: 1}
    if t.kind == SUM:
        out: Dict[str, int] = {}
        for a in t.args:
            for k, v in degree_bounds(a).items():
                out[k] = max(out.get(k, 0), v)
        return out
    out = {}
    for a in t.args:
        for k, v in degree_bounds(a).items():
            out[k] = out.get(k, 0) + v
    return out


MAX_GRID = 300000


def poly_equal(a: Term, b: Term, max_grid: int = MAX_GRID) -> bool:
    """Exact, complete decision of ``a == b`` in ``Z[vars]``."""
    da, db = degree_bounds(a), degree_bounds(b)
    names = sorted(set(da) | set(db))
    dims = [max(da.get(n, 0), db.get(n, 0)) + 1 for n in names]
    total = 1
    for d in dims:
        total *= d
    if total > max_grid:
        raise ValueError("grid of %d points exceeds cap %d" % (total, max_grid))
    idx = [0] * len(names)
    for _ in range(total):
        env = {n: idx[i] for i, n in enumerate(names)}
        if evaluate(a, env) != evaluate(b, env):
            return False
        for i in range(len(names) - 1, -1, -1):
            idx[i] += 1
            if idx[i] < dims[i]:
                break
            idx[i] = 0
    return True


class CheckFailure(Exception):
    pass


def check_step(st: Step, lemmas: Dict[str, Lemma], ctr: Optional[Counter] = None) -> None:
    """Validate one step against its rule schema.  Raises on failure."""
    if ctr is not None:
        ctr.checked()
    if at(st.before, st.pos).addr != st.redex.addr:
        raise CheckFailure("step %d: redex not at recorded position" % st.index)
    if replace_at(st.before, st.pos, st.contractum).addr != st.after.addr:
        raise CheckFailure("step %d: contractum does not rebuild `after`" % st.index)
    if st.lemma_id is not None:
        lem = lemmas.get(st.lemma_id)
        if lem is None:
            raise CheckFailure("step %d: unknown lemma %r" % (st.index, st.lemma_id))
        sigma = match(lem.lhs, st.redex)
        if sigma is None:
            raise CheckFailure("step %d: lemma %s does not match redex"
                               % (st.index, lem.lid))
        if subst(lem.rhs, sigma).addr != st.contractum.addr:
            raise CheckFailure("step %d: lemma %s instantiates to a different term"
                               % (st.index, lem.lid))
        return
    fn = RULE_TABLE.get(st.rule)
    if fn is None:
        raise CheckFailure("step %d: unknown rule %r" % (st.index, st.rule))
    out = fn(st.redex)
    if out is None or out.addr != st.contractum.addr:
        raise CheckFailure("step %d: rule %s does not justify the contractum"
                           % (st.index, st.rule))


def check_derivation(d: Derivation, lemmas: Optional[Dict[str, Lemma]] = None,
                     ctr: Optional[Counter] = None) -> None:
    lemmas = lemmas or {}
    cur = d.start
    for st in d.steps:
        if st.before.addr != cur.addr:
            raise CheckFailure("step %d: broken chain" % st.index)
        check_step(st, lemmas, ctr)
        cur = st.after
    if cur.addr != d.result.addr:
        raise CheckFailure("derivation result does not match final step")
