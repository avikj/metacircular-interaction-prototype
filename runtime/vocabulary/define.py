"""Definitional extension: how a new constructor is *defined*, never postulated.

THE ONE RULE
------------
A new symbol ``c`` of arity ``k`` enters the vocabulary only as

    c(#0, ..., #k-1)  :=  body

where ``body`` is a term of the language **already in place** (base ring terms,
plus constructors installed strictly earlier).  The left-hand side is the new
head applied to ``k`` *distinct* pattern variables and nothing else.  That
shape is what makes the extension eliminable and conservative, and
:mod:`runtime.vocabulary.conservativity` is the module that refuses everything
which is not of that shape.

WHY IT IS NOT A NEW AXIOM
-------------------------
The defining equation *is* declared to the kernel as an axiom -- there is no
way around that, an equation has to be assumed somewhere -- but it is an axiom
about a symbol that occurs nowhere else in the world.  Any proof that cites it
can be rewritten to a proof that does not, by replacing every ``c(t1..tk)`` by
``body[t1..tk]``.  That rewriting is :func:`unfold`, and running it on a
theorem and re-checking the result in the base vocabulary is the operational
content of "conservative".  We do not merely argue it; every theorem the
extended loop proves is unfolded and re-checked.

HOW A DEFINED SYMBOL LIVES IN THE SUBSTRATE
-------------------------------------------
``crystallize.derivation`` hash-conses terms with ``mk(kind, val, args)`` and
addresses them by an encoding of *head and children addresses*.  A defined
symbol is a term whose ``kind`` is ``"def:<name>"``.  Two consequences, both
deliberate:

* the address encoding for a non-``int``/``var`` head is ``"<kind>|<child
  addrs>"``, so putting the constructor name **inside the kind** keeps
  hash-consing injective.  Putting it in ``val`` would not: ``val`` is not part
  of the encoding for compound heads, and ``sqr(x)`` and ``cube(x)`` would
  collide.  This is checked by ``test_vocabulary.py``.
* every primitive ring rule guards on ``kind == PROD`` / ``kind == SUM``, so
  **no primitive rule fires on a defined node**.  A defined term is inert to
  the base engine, which is exactly right: the base engine must never see one.

Which is the other half of the discipline: ``evaluate``, ``degree_bounds``,
``poly_equal`` and ``normalize`` all treat an unknown compound head as a
product, so handing them a defined term would silently compute nonsense.
:func:`require_base` raises instead, and every crossing back into the base
vocabulary in this package goes through it.

Exact, deterministic, stdlib-only.  No float is constructed here; no set is
iterated where its order could be observed.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Optional, Sequence, Tuple

from ..crystallize.derivation import (INT, PROD, SUM, VAR, Counter, PV, Term,
                                      at, match, mk, positions_postorder,
                                      render, replace_at, subst)
from ..generate.multiway import R_SORT, arrow_n, kernel_dirs, lift_path
from ..kernel import check as C
from ..kernel import term as T
from ..kernel.edges import Edge

__all__ = [
    "DEF_PREFIX", "VocabularyError", "def_kind", "def_app", "is_def", "def_name",
    "def_symbols", "is_base", "require_base", "Definition", "Vocabulary",
    "kencode", "vrender", "unfold_once", "unfold", "unfold_derivation_terms",
    "fold", "MAX_UNFOLD", "defining_edge", "unfold_edge", "instance_axiom_name",
]

DEF_PREFIX = "def:"
MAX_UNFOLD = 100000


class VocabularyError(Exception):
    """Raised when a defined term is used where a base term is required, or a
    vocabulary is internally inconsistent.  Never swallowed."""


# --------------------------------------------------------------------------
# defined heads
# --------------------------------------------------------------------------

def def_kind(name: str) -> str:
    if not name or any(ch in name for ch in "|,:"):
        raise VocabularyError("illegal constructor name %r" % (name,))
    return DEF_PREFIX + name


def def_app(name: str, args: Sequence[Term]) -> Term:
    """A defined head applied to arguments, without needing the ``Definition``.

    Needed to *state* things the guard must refuse -- a recursive body mentions
    its own head before the head exists.
    """
    return mk(def_kind(name), None, tuple(args))


def is_def(t: Term) -> bool:
    return t.kind.startswith(DEF_PREFIX)


def def_name(t: Term) -> str:
    if not is_def(t):
        raise VocabularyError("not a defined node: %s" % render(t))
    return t.kind[len(DEF_PREFIX):]


def def_symbols(t: Term) -> Tuple[str, ...]:
    """Defined symbols occurring in ``t``, in first-occurrence order."""
    out: List[str] = []
    seen = set()
    stack: List[Term] = [t]
    while stack:
        n = stack.pop()
        if is_def(n) and n.kind not in seen:
            seen.add(n.kind)
            out.append(def_name(n))
        for a in reversed(n.args):
            stack.append(a)
    return tuple(out)


def is_base(t: Term) -> bool:
    """True iff ``t`` mentions no defined symbol -- i.e. lives in the base
    vocabulary the kernel, the normaliser and ``poly_equal`` understand."""
    stack = [t]
    while stack:
        n = stack.pop()
        if n.kind not in (INT, VAR, SUM, PROD):
            return False
        stack.extend(n.args)
    return True


def require_base(t: Term, where: str) -> Term:
    """The guarded crossing back into the base vocabulary.

    ``evaluate`` and the primitive rules treat every unknown compound head as
    a product.  A defined term reaching them would produce a confident wrong
    answer, which is the single most dangerous failure this package can have.
    So it raises.
    """
    if not is_base(t):
        raise VocabularyError(
            "%s requires a base-vocabulary term; %s still mentions %s"
            % (where, vrender(t), ", ".join(def_symbols(t))))
    return t


def vrender(t: Term) -> str:
    """``render`` with defined heads printed as applications rather than as
    products (``render`` would silently show ``sqr(x)`` as ``(x)``)."""
    if is_def(t):
        return "%s(%s)" % (def_name(t), ", ".join(vrender(a) for a in t.args))
    if t.kind == INT:
        return str(t.val)
    if t.kind == VAR:
        return t.val
    if t.kind == SUM:
        return "0" if not t.args else "(" + " + ".join(vrender(a) for a in t.args) + ")"
    if t.kind == PROD:
        return "1" if not t.args else "(" + "*".join(vrender(a) for a in t.args) + ")"
    raise VocabularyError("unknown head %r" % (t.kind,))


# --------------------------------------------------------------------------
# a definition
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class Definition:
    """``name(#0..#k-1) := body``, plus where it came from.

    ``raw_lhs`` exists only so that an attacker can *offer* a left-hand side
    that is not the canonical head-of-distinct-parameters, and be refused by
    name.  A well-formed definition leaves it ``None``.

    ``extra_axioms`` likewise exists to be refused: a "definition" that also
    asserts side equations is not a definition.
    """

    name: str
    arity: int
    body: Term
    provenance: str = "unspecified"
    witnesses: Tuple[str, ...] = ()      # concrete subterm addresses generalised
    sources: Tuple[str, ...] = ()        # derivation names it was observed in
    freq: int = 0
    spread: int = 0
    score: int = 0
    raw_lhs: Optional[Term] = None
    extra_axioms: Tuple[Tuple[Term, Term], ...] = ()

    # -- the two sides of the defining equation ---------------------------
    @property
    def params(self) -> Tuple[Term, ...]:
        return tuple(PV(i) for i in range(self.arity))

    def head(self, *args: Term) -> Term:
        if len(args) != self.arity:
            raise VocabularyError("%s takes %d argument(s), given %d"
                                  % (self.name, self.arity, len(args)))
        return mk(def_kind(self.name), None, args)

    @property
    def lhs(self) -> Term:
        return self.raw_lhs if self.raw_lhs is not None else self.head(*self.params)

    def render(self) -> str:
        return "%s := %s" % (vrender(self.lhs), vrender(self.body))

    def key(self) -> str:
        """Deterministic identity of the *statement*, independent of provenance."""
        return "%s/%d|%s" % (self.name, self.arity, self.body.addr)


class Vocabulary:
    """An ordered list of installed definitions.

    Order is installation order and it is load-bearing: a body may mention
    only strictly earlier definitions, which is what makes :func:`unfold`
    terminate without a search.

    ``install`` is deliberately *not* the public door.  Use
    ``conservativity.admit``, which runs the guard first.  Installing here
    without a guard is possible (a test needs it, to plant a bad definition
    and watch the unfolding check catch it downstream) and says so.
    """

    __slots__ = ("definitions", "by_name", "ctx", "edges", "install_log")

    def __init__(self, ctx: Optional[C.CheckContext] = None) -> None:
        self.definitions: List[Definition] = []
        self.by_name: Dict[str, Definition] = {}
        self.ctx = ctx if ctx is not None else C.CheckContext()
        self.edges: List[Edge] = []
        self.install_log: List[Tuple[int, str]] = []

    # -- reading ----------------------------------------------------------
    def get(self, name: str) -> Optional[Definition]:
        return self.by_name.get(name)

    def index_of(self, name: str) -> int:
        for i, d in enumerate(self.definitions):
            if d.name == name:
                return i
        return -1

    def __len__(self) -> int:
        return len(self.definitions)

    def names(self) -> Tuple[str, ...]:
        return tuple(d.name for d in self.definitions)

    def fingerprint(self) -> str:
        """A deterministic string identifying exactly this vocabulary."""
        return ";".join("%s:%d:%s" % (d.name, d.arity, d.body.addr)
                        for d in self.definitions)

    # -- writing (guarded elsewhere) --------------------------------------
    def install_unchecked(self, defn: Definition, rnd: int = -1) -> Edge:
        """Install without the conservativity guard.  See class docstring."""
        if defn.name in self.by_name:
            raise VocabularyError("redefinition of %s" % defn.name)
        self.definitions.append(defn)
        self.by_name[defn.name] = defn
        edge = defining_edge(defn, self.ctx)
        self.edges.append(edge)
        self.install_log.append((rnd, defn.name))
        return edge


# --------------------------------------------------------------------------
# kernel encoding, extended to defined heads
# --------------------------------------------------------------------------

_KENC: Dict[str, T.Term] = {}


def kencode(t: Term) -> T.Term:
    """Ring-or-defined term -> kernel term.

    Agrees with ``multiway.encode`` on base terms (same constant names, same
    sorts, so the same interned addresses).  A defined head ``c`` of arity
    ``k`` becomes ``Const("d:c" : R -> ... -> R)`` applied to its arguments,
    which cannot collide with ``sum_k``/``prod_k``/``z:``/``v:``.
    """
    got = _KENC.get(t.addr)
    if got is not None:
        return got
    if t.kind == INT:
        out = T.Const("z:%d" % t.val, R_SORT)
    elif t.kind == VAR:
        out = T.Const("v:%s" % t.val, R_SORT)
    else:
        k = len(t.args)
        if t.kind == SUM:
            sym = "sum%d" % k
        elif t.kind == PROD:
            sym = "prod%d" % k
        elif is_def(t):
            sym = "d:%s/%d" % (def_name(t), k)
        else:
            raise VocabularyError("cannot encode head %r" % (t.kind,))
        out = T.Const(sym, arrow_n(k))
        for a in t.args:
            out = T.App(out, kencode(a))
    _KENC[t.addr] = out
    return out


# --------------------------------------------------------------------------
# unfolding -- the elimination procedure
# --------------------------------------------------------------------------

def unfold_once(t: Term, vocab: Vocabulary
                ) -> Optional[Tuple[Tuple[int, ...], Term, Term, Definition]]:
    """Innermost-leftmost defined redex, or ``None``.

    Returns ``(position, redex, contractum, definition)``.
    """
    for p in positions_postorder(t):
        n = at(t, p)
        if not is_def(n):
            continue
        d = vocab.get(def_name(n))
        if d is None:
            raise VocabularyError("undefined constructor %r in %s"
                                  % (def_name(n), vrender(t)))
        if len(n.args) != d.arity:
            raise VocabularyError("%s applied to %d argument(s), arity %d"
                                  % (d.name, len(n.args), d.arity))
        sigma = {PV(i).val: n.args[i] for i in range(d.arity)}
        return (p, n, subst(d.body, sigma), d)
    return None


def unfold(t: Term, vocab: Vocabulary, ctr: Optional[Counter] = None) -> Term:
    """Eliminate every defined symbol.  Terminates; the result is base.

    Termination: a body may mention only strictly earlier definitions (gate
    D4), so the multiset of definition indices occurring in the term strictly
    decreases in the well-founded order on multisets at every step.  The hard
    cap is a second, cruder guard -- it raises rather than returning a
    half-unfolded term.
    """
    cur = t
    n = 0
    while True:
        hit = unfold_once(cur, vocab)
        if hit is None:
            break
        p, _redex, contractum, _d = hit
        cur = replace_at(cur, p, contractum)
        n += 1
        if ctr is not None:
            ctr.tick()
        if n > MAX_UNFOLD:
            raise VocabularyError("unfolding did not terminate on %s" % vrender(t))
    return require_base(cur, "unfold")


def unfold_derivation_terms(terms: Sequence[Term], vocab: Vocabulary,
                            ctr: Optional[Counter] = None) -> Tuple[Term, ...]:
    return tuple(unfold(t, vocab, ctr) for t in terms)


# --------------------------------------------------------------------------
# folding -- the direction that makes a name useful
# --------------------------------------------------------------------------

def fold(t: Term, vocab: Vocabulary, ctr: Optional[Counter] = None,
         limit: int = 4096) -> Term:
    """Replace instances of definition bodies by their constructor heads.

    Innermost-leftmost, definitions tried in installation order, to a
    fixpoint.  ``fold`` is only ever used to *state* something in the extended
    vocabulary; nothing downstream trusts it, because whatever it produces is
    unfolded and re-checked in the base before it counts.
    """
    cur = t
    for _ in range(limit):
        changed = False
        for p in positions_postorder(cur):
            node = at(cur, p)
            for d in vocab.definitions:
                sigma = match(d.body, node)
                if sigma is None:
                    continue
                args = []
                ok = True
                for i in range(d.arity):
                    got = sigma.get(PV(i).val)
                    if got is None:
                        ok = False
                        break
                    args.append(got)
                if not ok:
                    continue
                new = d.head(*args)
                if new.addr == node.addr:
                    continue
                cur = replace_at(cur, p, new)
                if ctr is not None:
                    ctr.tick()
                changed = True
                break
            if changed:
                break
        if not changed:
            return cur
    raise VocabularyError("folding did not reach a fixpoint")


# --------------------------------------------------------------------------
# the defining equation as a kernel-checked Eq edge
# --------------------------------------------------------------------------

def definition_axiom_name(defn: Definition) -> str:
    return "def|%s/%d|%s" % (defn.name, defn.arity, defn.body.addr)


def instance_axiom_name(defn: Definition, redex: Term, contractum: Term) -> str:
    return "unf|%s|%s|%s" % (defn.name, redex.addr, contractum.addr)


def defining_edge(defn: Definition, ctx: C.CheckContext) -> Edge:
    """Declare ``c(#0..#k-1) = body`` and return the checked ``Eq`` edge.

    The declaration is the *only* axiom a definition contributes, and it names
    a symbol that occurs nowhere else.  Raises if the kernel refuses the edge,
    which would mean the encoding is broken.
    """
    lhs, rhs = defn.lhs, defn.body
    name = definition_axiom_name(defn)
    kl, kr = kencode(lhs), kencode(rhs)
    ctx.declare_axiom(name, kl, kr)
    step = C.Step(src=kl.addr, dst=kr.addr, kind="assumption",
                  witness=C.Axiom(name))
    edge = Edge(kind="Eq", src=kl.addr, dst=kr.addr, witness=(step,),
                label="def:%s" % defn.name)
    if not C.check_edge(edge, ctx):
        raise VocabularyError("kernel refused the defining equation of %s: %s"
                              % (defn.name, ctx.errors[-1:]))
    return edge


def unfold_edge(t: Term, vocab: Vocabulary,
                ctx: Optional[C.CheckContext] = None) -> Edge:
    """A checked ``Eq`` edge for one whole unfolding ``t = unfold(t)``.

    Each unfolding step is re-run against its definition (schema re-run, the
    analogue of ``multiway``'s gate A1) before its instance axiom is declared,
    then lifted to the root by genuine congruence steps.  So the edge is a
    proof, not a claim.
    """
    ctx = vocab.ctx if ctx is None else ctx
    path: List[C.Step] = []
    cur = t
    while True:
        hit = unfold_once(cur, vocab)
        if hit is None:
            break
        p, redex, contractum, d = hit
        # schema re-run: do not trust the contractum handed back
        sigma = {PV(i).val: redex.args[i] for i in range(d.arity)}
        if subst(d.body, sigma).addr != contractum.addr:
            raise VocabularyError("unfolding of %s does not re-run" % d.name)
        name = instance_axiom_name(d, redex, contractum)
        if name not in ctx.axioms:
            ctx.declare_axiom(name, kencode(redex), kencode(contractum))
        base = (C.Step(src=kencode(redex).addr, dst=kencode(contractum).addr,
                       kind="assumption", witness=C.Axiom(name)),)
        path.extend(lift_path(kencode(cur), kernel_dirs(cur, p), base))
        cur = replace_at(cur, p, contractum)
    edge = Edge(kind="Eq", src=kencode(t).addr, dst=kencode(cur).addr,
                witness=tuple(path), label="unfold")
    if not C.check_edge(edge, ctx):
        raise VocabularyError("kernel refused an unfolding edge: %s"
                              % (ctx.errors[-1:],))
    return edge
