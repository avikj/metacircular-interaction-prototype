"""The trusted core of a mathematical runtime.

Native state is not files. It is a set of content-addressed typed terms and
a set of *checked transformations* between them. Mathematics entering this
module changes what the module can execute, and how cheaply.

Nothing here is probabilistic and nothing here calls a model. Every
operation is exact: hash-consing, matching, unification, a reduction order,
critical-pair generation, and completion. This is the layer that owns
identity, semantics and verification; proposal layers sit above it and may
be replaced without touching it.

Attribution, stated up front because the algorithms are classical and the
composition is the only thing here that is not:
  * Knuth & Bendix, "Simple word problems in universal algebras" (1970) --
    completion, critical pairs, and the fact that a completed system
    decides the word problem by normalisation.
  * Kamin & Levy (1980) / Dershowitz -- the lexicographic path order.
  * Robinson (1965) -- unification.
  * Hash-consing and content addressing as identity: Ershov (1958);
    the modern content-addressed-code reading is Unison's.

What this module adds is none of those. It is the wiring: every derived
rule carries its derivation back to axioms, every term has an exact
address, and the runtime keeps a ledger of what a given body of accepted
mathematics costs to use. That ledger is the only claim being made -- that
proving something here measurably lowers the cost of an independent later
problem -- and `demo.py` either shows it or does not.
"""

from __future__ import annotations

import hashlib
import itertools
from dataclasses import dataclass, field
from typing import Iterator, Optional


# --------------------------------------------------------------------------
# 1. Terms: content-addressed, hash-consed. Names are views; the address is
#    the identity. Two structurally equal terms are the same Python object.
# --------------------------------------------------------------------------

_INTERN: dict[tuple, "Term"] = {}


@dataclass(frozen=True, eq=False)
class Term:
    head: str
    args: tuple["Term", ...]
    addr: str

    @property
    def is_var(self) -> bool:
        return self.head.startswith("?")

    @property
    def size(self) -> int:
        return 1 + sum(a.size for a in self.args)

    def __repr__(self) -> str:
        if not self.args:
            return self.head
        return f"{self.head}({','.join(map(repr, self.args))})"

    def __hash__(self) -> int:
        return hash(self.addr)


def mk(head: str, *args: Term) -> Term:
    """Intern a term. The address is a pure function of structure."""
    key = (head, tuple(a.addr for a in args))
    hit = _INTERN.get(key)
    if hit is not None:
        return hit
    payload = head + "(" + ",".join(a.addr for a in args) + ")"
    addr = hashlib.sha256(payload.encode()).hexdigest()[:16]
    t = Term(head, tuple(args), addr)
    _INTERN[key] = t
    return t


def var(name: str) -> Term:
    return mk("?" + name)


def variables(t: Term) -> set[str]:
    if t.is_var:
        return {t.head}
    out: set[str] = set()
    for a in t.args:
        out |= variables(a)
    return out


def subst(t: Term, s: dict[str, Term]) -> Term:
    if t.is_var:
        return s.get(t.head, t)
    if not t.args:
        return t
    return mk(t.head, *(subst(a, s) for a in t.args))


def rename(t: Term, tag: str) -> Term:
    """Rename apart, so two rules can be overlapped without capture."""
    if t.is_var:
        return var(t.head[1:] + tag)
    if not t.args:
        return t
    return mk(t.head, *(rename(a, tag) for a in t.args))


# --------------------------------------------------------------------------
# 2. Matching and unification.
# --------------------------------------------------------------------------


def match(pattern: Term, t: Term, s: Optional[dict] = None) -> Optional[dict]:
    """One-way match: find sigma with subst(pattern, sigma) == t."""
    if s is None:
        s = {}
    if pattern.is_var:
        bound = s.get(pattern.head)
        if bound is None:
            s[pattern.head] = t
            return s
        return s if bound is t else None
    if pattern.head != t.head or len(pattern.args) != len(t.args):
        return None
    for p, a in zip(pattern.args, t.args):
        if match(p, a, s) is None:
            return None
    return s


def _occurs(v: str, t: Term, s: dict) -> bool:
    if t.is_var:
        if t.head == v:
            return True
        b = s.get(t.head)
        return b is not None and _occurs(v, b, s)
    return any(_occurs(v, a, s) for a in t.args)


def unify(a: Term, b: Term, s: Optional[dict] = None) -> Optional[dict]:
    """Robinson unification with the occurs check."""
    if s is None:
        s = {}
    a = _walk(a, s)
    b = _walk(b, s)
    if a is b:
        return s
    if a.is_var:
        if _occurs(a.head, b, s):
            return None
        s[a.head] = b
        return s
    if b.is_var:
        return unify(b, a, s)
    if a.head != b.head or len(a.args) != len(b.args):
        return None
    for x, y in zip(a.args, b.args):
        if unify(x, y, s) is None:
            return None
    return s


def _walk(t: Term, s: dict) -> Term:
    while t.is_var and t.head in s:
        t = s[t.head]
    return t


def resolve(t: Term, s: dict) -> Term:
    """Fully apply a (possibly chained) substitution."""
    t = _walk(t, s)
    if t.is_var or not t.args:
        return t
    return mk(t.head, *(resolve(a, s) for a in t.args))


# --------------------------------------------------------------------------
# 3. A reduction order. Orientation is what makes an equation executable:
#    an equation is knowledge, an oriented rule is a transformation.
# --------------------------------------------------------------------------


class LPO:
    """Lexicographic path order over a total precedence on function symbols."""

    def __init__(self, precedence: list[str]):
        # earlier in the list == greater
        self.rank = {sym: -i for i, sym in enumerate(precedence)}

    def _prec(self, f: str) -> tuple:
        """Total, deterministic, and defined on every symbol.

        Declared symbols rank above undeclared ones; undeclared symbols --
        the constants a goal happens to mention -- are ordered among
        themselves by name. Extending the precedence rather than refusing
        unknown symbols is what lets a compiled theory be applied to terms
        the theory itself never mentioned."""
        if f in self.rank:
            return (1, self.rank[f])
        return (0, f)

    def gt(self, s: Term, t: Term) -> bool:
        if s is t:
            return False
        if t.is_var:
            return (not s.is_var) and t.head in variables(s)
        if s.is_var:
            return False
        # (a) some direct subterm of s already dominates t
        if any(si is t or self.gt(si, t) for si in s.args):
            return True
        ps, pt = self._prec(s.head), self._prec(t.head)
        if ps > pt:
            return all(self.gt(s, tj) for tj in t.args)
        if ps == pt:
            if not all(self.gt(s, tj) for tj in t.args):
                return False
            for si, ti in zip(s.args, t.args):
                if si is ti:
                    continue
                return self.gt(si, ti)
            return len(s.args) > len(t.args)
        return False


# --------------------------------------------------------------------------
# 4. Rules: oriented, addressed, and carrying their own derivation.
# --------------------------------------------------------------------------


@dataclass
class Rule:
    lhs: Term
    rhs: Term
    rid: int
    origin: tuple
    """Why this rule exists. ('axiom', name) or
    ('critical-pair', rid1, position, rid2) -- a replayable derivation back
    to the axioms, which is what makes the rule set proof-carrying rather
    than merely believed."""

    @property
    def addr(self) -> str:
        return hashlib.sha256(
            (self.lhs.addr + "->" + self.rhs.addr).encode()
        ).hexdigest()[:16]

    def __repr__(self) -> str:
        return f"[{self.rid}] {self.lhs!r} -> {self.rhs!r}"


# --------------------------------------------------------------------------
# 5. Rewriting, with a step ledger. Cost is counted, never estimated.
# --------------------------------------------------------------------------


def positions(t: Term) -> Iterator[tuple[int, ...]]:
    yield ()
    for i, a in enumerate(t.args):
        for p in positions(a):
            yield (i,) + p


def at(t: Term, p: tuple[int, ...]) -> Term:
    for i in p:
        t = t.args[i]
    return t


def replace(t: Term, p: tuple[int, ...], new: Term) -> Term:
    if not p:
        return new
    i, rest = p[0], p[1:]
    args = list(t.args)
    args[i] = replace(args[i], rest, new)
    return mk(t.head, *args)


def rewrite_once(t: Term, rules: list[Rule]) -> Optional[tuple[Term, Rule]]:
    for p in positions(t):
        sub = at(t, p)
        for r in rules:
            s = match(r.lhs, sub)
            if s is not None:
                return replace(t, p, subst(r.rhs, s)), r
    return None


def normalize(t: Term, rules: list[Rule], budget: int = 10_000) -> tuple[Term, int]:
    """Reduce to normal form. Returns (normal form, rewrite steps used)."""
    steps = 0
    while steps < budget:
        step = rewrite_once(t, rules)
        if step is None:
            return t, steps
        t = step[0]
        steps += 1
    raise RuntimeError("normalisation budget exhausted -- system not terminating?")


# --------------------------------------------------------------------------
# 6. Critical pairs: where a new structural relationship is discovered.
# --------------------------------------------------------------------------


def critical_pairs(r1: Rule, r2: Rule) -> Iterator[tuple[Term, Term, tuple]]:
    """Overlaps of r2's lhs into r1's lhs. Each overlap is a place where two
    accepted transformations disagree about a term; the pair is the residual
    that must be reconciled for the system to be confluent."""
    a = Rule(rename(r1.lhs, "_1"), rename(r1.rhs, "_1"), r1.rid, r1.origin)
    b = Rule(rename(r2.lhs, "_2"), rename(r2.rhs, "_2"), r2.rid, r2.origin)
    for p in positions(a.lhs):
        sub = at(a.lhs, p)
        if sub.is_var:
            continue
        if r1.rid == r2.rid and p == ():
            continue  # a rule trivially overlaps itself at the root
        s = unify(sub, b.lhs, {})
        if s is None:
            continue
        left = resolve(a.rhs, s)
        right = resolve(replace(a.lhs, p, b.rhs), s)
        if left is not right:
            yield left, right, ("critical-pair", r1.rid, p, r2.rid)


# --------------------------------------------------------------------------
# 7. Completion: the compile step. Equations in, executable rewrite system
#    out, every derived rule carrying its origin.
# --------------------------------------------------------------------------


@dataclass
class Ledger:
    """Every cost in this runtime is measured, not modelled."""

    orientations: int = 0
    critical_pairs_examined: int = 0
    rules_derived: int = 0
    rewrite_steps: int = 0
    events: list = field(default_factory=list)
    unorientable_pairs: list = field(default_factory=list)
    """Equations no reduction order can orient, kept as terms rather than as
    log strings. An unorientable equation is not a nuisance -- it is the
    residual of a failed compilation, and `obstruction.py` reads it."""

    def log(self, kind: str, detail: str) -> None:
        self.events.append((kind, detail))


class Completion:
    def __init__(self, order: LPO, ledger: Optional[Ledger] = None):
        self.order = order
        self.rules: list[Rule] = []
        self.ledger = ledger or Ledger()
        self.exhausted = False
        self._next = 0

    def _orient(self, l: Term, r: Term, origin: tuple) -> Optional[Rule]:
        self.ledger.orientations += 1
        if self.order.gt(l, r):
            lhs, rhs = l, r
        elif self.order.gt(r, l):
            lhs, rhs = r, l
        else:
            return None  # unorientable: the order cannot compile this equation
        self._next += 1
        rule = Rule(lhs, rhs, self._next, origin)
        return rule

    exhausted: bool = False
    """True when `run` stopped with work still pending. A completed theory
    and an abandoned one are different objects and must never be read the
    same way."""

    def run(self, axioms: list[tuple[str, Term, Term]], max_rules: int = 200,
            max_rounds: int = 2000) -> list[Rule]:
        pending: list[tuple[Term, Term, tuple]] = [
            (l, r, ("axiom", name)) for name, l, r in axioms
        ]
        rounds = 0
        while pending and rounds < max_rounds and len(self.rules) < max_rules:
            rounds += 1
            # Fairness: always take the smallest outstanding equation. With
            # FIFO the loop chases ever-larger instances of relationships it
            # has not yet stated in general, and never reaches the general
            # form. Smallest-first is what makes completion converge.
            k = min(range(len(pending)),
                    key=lambda i: (pending[i][0].size + pending[i][1].size,
                                   pending[i][0].addr))
            l, r, origin = pending.pop(k)
            ln, s1 = normalize(l, self.rules)
            rn, s2 = normalize(r, self.rules)
            self.ledger.rewrite_steps += s1 + s2
            if ln is rn:
                continue  # already a consequence: no new structure here
            rule = self._orient(ln, rn, origin)
            if rule is None:
                self.ledger.log("unorientable", f"{ln!r} = {rn!r}")
                self.ledger.unorientable_pairs.append((ln, rn, origin))
                continue
            self.rules.append(rule)
            self.ledger.rules_derived += 1
            self.ledger.log("derived", f"{rule!r}  from {origin}")
            # Interreduce: a new transformation can make older ones redundant.
            # This is the interior compressing as the frontier advances.
            kept: list[Rule] = []
            for old in self.rules[:-1]:
                others = [x for x in self.rules if x is not old]
                if rewrite_once(old.lhs, [rule]) is not None:
                    nl, _ = normalize(old.lhs, others)
                    nr, _ = normalize(old.rhs, others)
                    if nl is not nr:
                        pending.append((nl, nr, ("interreduce", old.rid)))
                    self.ledger.log("retired", repr(old))
                    continue
                new_rhs, _ = normalize(old.rhs, self.rules)
                if new_rhs is not old.rhs:
                    old = Rule(old.lhs, new_rhs, old.rid, old.origin)
                kept.append(old)
            kept.append(rule)
            self.rules = kept
            # New overlaps against everything accepted so far.
            for other in self.rules:
                for x, y in ((rule, other), (other, rule)):
                    for cl, cr, org in critical_pairs(x, y):
                        self.ledger.critical_pairs_examined += 1
                        cln, sa = normalize(cl, self.rules)
                        crn, sb = normalize(cr, self.rules)
                        self.ledger.rewrite_steps += sa + sb
                        if cln is not crn:
                            pending.append((cln, crn, org))
        self.exhausted = bool(pending)
        return self.rules

    def decides(self, l: Term, r: Term) -> tuple[bool, int]:
        """Decide an equation by normalisation. Returns (equal, steps)."""
        ln, s1 = normalize(l, self.rules)
        rn, s2 = normalize(r, self.rules)
        return (ln is rn), s1 + s2


# --------------------------------------------------------------------------
# 8. The "before" picture: deciding the same equations without the compiled
#    system, by blind bidirectional search over the raw axioms. This exists
#    only to make the improvement measurable rather than asserted.
# --------------------------------------------------------------------------


def search_equal(l: Term, r: Term, axioms: list[tuple[str, Term, Term]],
                 max_nodes: int = 200_000, max_size: int = 14) -> tuple[bool, int]:
    """Bidirectional breadth-first search over equational steps.

    Returns (proved, nodes expanded). This is what an uncompiled theory
    costs: every problem re-derives everything from scratch."""
    eqs: list[tuple[Term, Term]] = []
    for _, a, b in axioms:
        eqs.append((a, b))
        eqs.append((b, a))

    def neighbours(t: Term) -> Iterator[Term]:
        for p in positions(t):
            sub = at(t, p)
            for a, b in eqs:
                s = match(a, sub)
                if s is None:
                    continue
                if variables(b) - variables(a):
                    continue  # would introduce an unbound variable
                cand = replace(t, p, subst(b, s))
                if cand.size <= max_size:
                    yield cand

    if l is r:
        return True, 0
    front_l, front_r = {l}, {r}
    seen_l, seen_r = {l}, {r}
    nodes = 0
    while front_l and front_r and nodes < max_nodes:
        # expand the smaller frontier
        if len(front_l) <= len(front_r):
            nxt = set()
            for t in front_l:
                for u in neighbours(t):
                    nodes += 1
                    if u in seen_r:
                        return True, nodes
                    if u not in seen_l:
                        seen_l.add(u)
                        nxt.add(u)
                    if nodes >= max_nodes:
                        return False, nodes
            front_l = nxt
        else:
            nxt = set()
            for t in front_r:
                for u in neighbours(t):
                    nodes += 1
                    if u in seen_l:
                        return True, nodes
                    if u not in seen_r:
                        seen_r.add(u)
                        nxt.add(u)
                    if nodes >= max_nodes:
                        return False, nodes
            front_r = nxt
    return False, nodes
