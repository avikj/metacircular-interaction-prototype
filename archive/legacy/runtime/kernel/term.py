"""L0 -- exact identity: hash-consed typed terms with content addressing.

CRYSTAL.md Sec.2 L0:

    Hash-consed typed terms.  A construction's address is the hash of its
    elaborated form *and its dependency addresses*.  Names are views, mutable
    and non-authoritative.  Identical addresses => identical construction,
    always.

Everything here is exact.  No floating point is imported, constructed, or
accepted anywhere in this module.  Address computation uses ``hashlib.blake2b``
(stdlib, deterministic across processes and platforms) and never Python's
``hash()``, which is salted per-process and would break byte-identical reruns.

The IR is a simply-typed lambda calculus over opaque constants, with bound
variables represented by de Bruijn indices.  See ``README.md`` for why de
Bruijn (not names) is forced by the L0 identity requirement.

Step counters live in ``COUNTERS`` and are part of the contract: they are the
experiment, not decoration.
"""

from __future__ import annotations

import hashlib
from typing import Dict, Iterator, List, Optional, Tuple

__all__ = [
    "SortError",
    "KernelError",
    "Counters",
    "COUNTERS",
    "Sort",
    "base_sort",
    "arrow",
    "Term",
    "Var",
    "Const",
    "App",
    "Lam",
    "lookup",
    "is_registered",
    "subterms",
    "shift",
    "subst_top",
    "subst_consts",
    "beta_normal",
    "NameTable",
    "NAMES",
    "name_of",
    "names_of",
    "resolve",
    "bind",
    "intern_table_size",
    "reset_all",
]


# --------------------------------------------------------------------------
# errors
# --------------------------------------------------------------------------


class KernelError(Exception):
    """Any violation of a kernel invariant."""


class SortError(KernelError):
    """Ill-sorted construction rejected at build time."""


# --------------------------------------------------------------------------
# exact step counters
# --------------------------------------------------------------------------


class Counters:
    """Deterministic integer step counters.

    Insertion-ordered; ``snapshot()`` sorts by key so two runs of the same
    program emit byte-identical counter dumps.
    """

    __slots__ = ("_d",)

    def __init__(self) -> None:
        self._d: Dict[str, int] = {}

    def bump(self, key: str, n: int = 1) -> None:
        self._d[key] = self._d.get(key, 0) + n

    def get(self, key: str) -> int:
        return self._d.get(key, 0)

    def __getitem__(self, key: str) -> int:
        return self._d.get(key, 0)

    def __contains__(self, key: str) -> bool:
        return key in self._d

    def keys(self) -> Tuple[str, ...]:
        return tuple(sorted(self._d))

    def snapshot(self) -> Tuple[Tuple[str, int], ...]:
        return tuple(sorted(self._d.items()))

    def delta(self, before: Tuple[Tuple[str, int], ...]) -> Tuple[Tuple[str, int], ...]:
        prev = dict(before)
        out = []
        for k, v in sorted(self._d.items()):
            d = v - prev.get(k, 0)
            if d:
                out.append((k, d))
        return tuple(out)

    def reset(self) -> None:
        self._d.clear()

    def render(self) -> str:
        return " ".join("%s=%d" % (k, v) for k, v in self.snapshot())


COUNTERS = Counters()


# --------------------------------------------------------------------------
# content addressing
# --------------------------------------------------------------------------

_DIGEST_BYTES = 16
_SEP = b"\x1f"


def _digest(head: bytes, sort_addr: str, children: Tuple[str, ...]) -> str:
    """Address = H(head symbol || sort address || child addresses).

    The address embeds the *dependency structure* (child addresses), never a
    view name.  Two constructions with the same address are the same
    construction; two presentations of "the same" mathematics that elaborate
    differently get different addresses and stay that way.
    """
    COUNTERS.bump("term.hash")
    h = hashlib.blake2b(digest_size=_DIGEST_BYTES)
    h.update(head)
    h.update(_SEP)
    h.update(sort_addr.encode("utf-8"))
    h.update(_SEP)
    for c in children:
        h.update(c.encode("utf-8"))
        h.update(_SEP)
    return h.hexdigest()


# --------------------------------------------------------------------------
# sorts (types)
# --------------------------------------------------------------------------

_SORTS: Dict[str, "Sort"] = {}


class Sort:
    """A simple type.  Hash-consed and content addressed like terms.

    Either a base sort (``name`` set, ``dom``/``cod`` ``None``) or a function
    sort ``dom -> cod``.
    """

    __slots__ = ("addr", "name", "dom", "cod")

    def __init__(self, addr: str, name: Optional[str], dom, cod) -> None:
        self.addr = addr
        self.name = name
        self.dom = dom
        self.cod = cod

    # -- structure ---------------------------------------------------------
    @property
    def is_arrow(self) -> bool:
        return self.dom is not None

    def __repr__(self) -> str:  # pragma: no cover - display only
        return self.pretty()

    def pretty(self) -> str:
        if self.dom is None:
            return self.name or "?"
        d = self.dom.pretty()
        if self.dom.is_arrow:
            d = "(" + d + ")"
        return d + "->" + self.cod.pretty()

    def recompute_addr(self) -> str:
        """Independently recompute this sort's address (used by the checker)."""
        if self.dom is None:
            return _digest(b"sort.base:" + (self.name or "").encode("utf-8"), "", ())
        return _digest(b"sort.arrow", "", (self.dom.recompute_addr(), self.cod.recompute_addr()))


def _intern_sort(s: Sort) -> Sort:
    got = _SORTS.get(s.addr)
    if got is not None:
        COUNTERS.bump("sort.intern_hit")
        return got
    COUNTERS.bump("sort.intern_miss")
    _SORTS[s.addr] = s
    return s


def base_sort(name: str) -> Sort:
    """A base sort.  ``base_sort("Nat") is base_sort("Nat")``."""
    if not isinstance(name, str) or not name:
        raise SortError("base sort needs a non-empty str name")
    addr = _digest(b"sort.base:" + name.encode("utf-8"), "", ())
    return _intern_sort(Sort(addr, name, None, None))


def arrow(dom: Sort, cod: Sort) -> Sort:
    """The function sort ``dom -> cod``."""
    if not isinstance(dom, Sort) or not isinstance(cod, Sort):
        raise SortError("arrow() requires Sorts")
    addr = _digest(b"sort.arrow", "", (dom.addr, cod.addr))
    return _intern_sort(Sort(addr, None, dom, cod))


# --------------------------------------------------------------------------
# terms
# --------------------------------------------------------------------------

_TERMS: Dict[str, "Term"] = {}

VAR = "var"
CONST = "const"
APP = "app"
LAM = "lam"


class Term:
    """A hash-consed typed term.

    Structural identity is physical identity: for any two ``Term`` objects
    ``a`` and ``b`` produced by this module, ``a is b`` iff ``a.addr ==
    b.addr`` iff they are the same construction.  Use ``is``.

    Fields
    ------
    addr      content address (32 lowercase hex chars, 128 bit blake2b)
    head      one of ``"var"``, ``"const"``, ``"app"``, ``"lam"``
    sort      the term's ``Sort``
    children  tuple of direct subterms (``()``/``(fn, arg)``/``(body,)``)
    index     de Bruijn index, ``var`` only
    symbol    constant symbol, ``const`` only
    dom       binder's domain sort, ``lam`` only
    demands   sorts required of dangling de Bruijn indices, as a sorted tuple
              of ``(index, Sort)``.  Empty tuple <=> the term is closed.
    """

    __slots__ = ("addr", "head", "sort", "children", "index", "symbol", "dom", "demands")

    def __init__(self, addr, head, sort, children, index, symbol, dom, demands) -> None:
        self.addr = addr
        self.head = head
        self.sort = sort
        self.children = children
        self.index = index
        self.symbol = symbol
        self.dom = dom
        self.demands = demands

    # -- identity ----------------------------------------------------------
    @property
    def is_closed(self) -> bool:
        return not self.demands

    def head_symbol(self) -> bytes:
        """The exact head-symbol bytes fed to the address hash."""
        if self.head == VAR:
            return b"var:%d" % self.index
        if self.head == CONST:
            return b"const:" + self.symbol.encode("utf-8")
        if self.head == APP:
            return b"app"
        return b"lam"

    def recompute_addr(self) -> str:
        """Recompute the address from scratch, bottom up.

        The trusted checker calls this so it never has to believe the intern
        table.  Cost is linear in the term's tree size (not DAG size).
        """
        kids = tuple(c.recompute_addr() for c in self.children)
        if self.head == LAM:
            kids = (self.dom.recompute_addr(),) + kids
        return _digest(self.head_symbol(), self.sort.recompute_addr(), kids)

    def __repr__(self) -> str:  # pragma: no cover - display only
        return self.pretty()

    def pretty(self) -> str:
        if self.head == VAR:
            return "#%d" % self.index
        if self.head == CONST:
            return self.symbol
        if self.head == APP:
            f, a = self.children
            fs = f.pretty()
            if f.head == LAM:
                fs = "(" + fs + ")"
            as_ = a.pretty()
            if a.head in (APP, LAM):
                as_ = "(" + as_ + ")"
            return fs + " " + as_
        return "\\:%s. %s" % (self.dom.pretty(), self.children[0].pretty())

    # -- convenience -------------------------------------------------------
    def short(self) -> str:
        return self.addr[:8]


def _intern(t: Term) -> Term:
    got = _TERMS.get(t.addr)
    if got is not None:
        COUNTERS.bump("term.intern_hit")
        return got
    COUNTERS.bump("term.intern_miss")
    _TERMS[t.addr] = t
    return t


def lookup(addr: str) -> Optional[Term]:
    """Resolve an address to its term, or ``None`` if never constructed."""
    COUNTERS.bump("term.lookup")
    return _TERMS.get(addr)


def is_registered(addr: str) -> bool:
    return addr in _TERMS


def _merge_demands(a: Tuple, b: Tuple) -> Tuple:
    """Union two dangling-index sort demands; conflicting sorts are ill-sorted."""
    if not a:
        return b
    if not b:
        return a
    d = dict(a)
    for i, s in b:
        prev = d.get(i)
        if prev is None:
            d[i] = s
        elif prev is not s:
            raise SortError(
                "de Bruijn index %d used at both sort %s and %s" % (i, prev.pretty(), s.pretty())
            )
    return tuple(sorted(d.items(), key=lambda kv: kv[0]))


def Var(index: int, sort: Sort) -> Term:
    """A bound-variable occurrence, de Bruijn index ``index`` (0 = innermost)."""
    COUNTERS.bump("term.build")
    if not isinstance(index, int) or isinstance(index, bool) or index < 0:
        raise SortError("de Bruijn index must be a non-negative int, got %r" % (index,))
    if not isinstance(sort, Sort):
        raise SortError("Var needs a Sort")
    addr = _digest(b"var:%d" % index, sort.addr, ())
    return _intern(Term(addr, VAR, sort, (), index, None, None, ((index, sort),)))


def Const(symbol: str, sort: Sort) -> Term:
    """An opaque constant.  Its symbol *is* its identity (it has no definiens)."""
    COUNTERS.bump("term.build")
    if not isinstance(symbol, str) or not symbol:
        raise SortError("Const needs a non-empty str symbol")
    if not isinstance(sort, Sort):
        raise SortError("Const needs a Sort")
    addr = _digest(b"const:" + symbol.encode("utf-8"), sort.addr, ())
    return _intern(Term(addr, CONST, sort, (), None, symbol, None, ()))


def App(fn: Term, arg: Term) -> Term:
    """Application.  Rejected at build time unless ``fn : arg.sort -> b``."""
    COUNTERS.bump("term.build")
    if not isinstance(fn, Term) or not isinstance(arg, Term):
        raise SortError("App needs Terms")
    COUNTERS.bump("term.sortcheck")
    if not fn.sort.is_arrow:
        raise SortError("cannot apply non-function of sort %s" % fn.sort.pretty())
    if fn.sort.dom is not arg.sort:
        raise SortError(
            "argument sort %s does not match domain %s"
            % (arg.sort.pretty(), fn.sort.dom.pretty())
        )
    sort = fn.sort.cod
    demands = _merge_demands(fn.demands, arg.demands)
    addr = _digest(b"app", sort.addr, (fn.addr, arg.addr))
    return _intern(Term(addr, APP, sort, (fn, arg), None, None, None, demands))


def Lam(dom: Sort, body: Term) -> Term:
    """Abstraction binding de Bruijn index 0 in ``body`` at sort ``dom``."""
    COUNTERS.bump("term.build")
    if not isinstance(dom, Sort):
        raise SortError("Lam needs a Sort domain")
    if not isinstance(body, Term):
        raise SortError("Lam needs a Term body")
    COUNTERS.bump("term.sortcheck")
    d = dict(body.demands)
    got = d.get(0)
    if got is not None and got is not dom:
        raise SortError(
            "binder domain %s conflicts with bound occurrence at sort %s"
            % (dom.pretty(), got.pretty())
        )
    demands = tuple(sorted(((i - 1, s) for i, s in body.demands if i > 0), key=lambda kv: kv[0]))
    sort = arrow(dom, body.sort)
    addr = _digest(b"lam", sort.addr, (dom.addr, body.addr))
    return _intern(Term(addr, LAM, sort, (body,), None, None, dom, demands))


def subterms(t: Term) -> Tuple[Term, ...]:
    """All subterms, children before parents, each exactly once, deterministic."""
    seen: Dict[str, None] = {}
    out: List[Term] = []

    def go(u: Term) -> None:
        if u.addr in seen:
            return
        for c in u.children:
            go(c)
        seen[u.addr] = None
        out.append(u)

    go(t)
    return tuple(out)


# --------------------------------------------------------------------------
# substitution and beta normalisation (trusted; used by check.py)
# --------------------------------------------------------------------------


def shift(t: Term, d: int, cutoff: int = 0) -> Term:
    """Shift dangling de Bruijn indices >= ``cutoff`` by ``d``."""
    COUNTERS.bump("term.shift")
    if t.head == VAR:
        if t.index >= cutoff:
            return Var(t.index + d, t.sort)
        return t
    if t.head == CONST:
        return t
    if t.head == APP:
        return App(shift(t.children[0], d, cutoff), shift(t.children[1], d, cutoff))
    return Lam(t.dom, shift(t.children[0], d, cutoff + 1))


def _subst(t: Term, j: int, repl: Term) -> Term:
    COUNTERS.bump("term.subst")
    if t.head == VAR:
        return repl if t.index == j else t
    if t.head == CONST:
        return t
    if t.head == APP:
        return App(_subst(t.children[0], j, repl), _subst(t.children[1], j, repl))
    return Lam(t.dom, _subst(t.children[0], j + 1, shift(repl, 1, 0)))


def subst_top(body: Term, arg: Term) -> Term:
    """Capture-avoiding substitution of ``arg`` for de Bruijn 0 in ``body``."""
    return shift(_subst(body, 0, shift(arg, 1, 0)), -1, 0)


def subst_consts(t: Term, mapping: Dict[str, Term]) -> Term:
    """Replace opaque constants by terms.  ``mapping`` is symbol -> Term.

    Sort-preserving: a replacement of a different sort is rejected.
    """
    COUNTERS.bump("term.subst_const")
    if t.head == CONST:
        r = mapping.get(t.symbol)
        if r is None:
            return t
        if r.sort is not t.sort:
            raise SortError(
                "substitution for %s has sort %s, expected %s"
                % (t.symbol, r.sort.pretty(), t.sort.pretty())
            )
        return r
    if t.head == VAR:
        return t
    if t.head == APP:
        return App(subst_consts(t.children[0], mapping), subst_consts(t.children[1], mapping))
    return Lam(t.dom, subst_consts(t.children[0], mapping))


class FuelExhausted(KernelError):
    """Normalisation ran out of fuel.  The checker treats this as a rejection."""


class _Fuel:
    __slots__ = ("left", "beta")

    def __init__(self, n: int) -> None:
        self.left = n
        self.beta = 0

    def burn(self) -> None:
        self.left -= 1
        if self.left < 0:
            raise FuelExhausted("normalisation fuel exhausted")


def _whnf(t: Term, fuel: _Fuel) -> Term:
    while t.head == APP:
        fuel.burn()
        fn = _whnf(t.children[0], fuel)
        if fn.head == LAM:
            fuel.beta += 1
            COUNTERS.bump("term.beta")
            t = subst_top(fn.children[0], t.children[1])
            continue
        if fn is t.children[0]:
            return t
        return App(fn, t.children[1])
    return t


def _nf(t: Term, fuel: _Fuel) -> Term:
    fuel.burn()
    t = _whnf(t, fuel)
    if t.head == LAM:
        return Lam(t.dom, _nf(t.children[0], fuel))
    if t.head == APP:
        return App(_nf(t.children[0], fuel), _nf(t.children[1], fuel))
    return t


def beta_normal(t: Term, fuel: int = 100000) -> Optional[Term]:
    """Normal-order beta normal form, or ``None`` if ``fuel`` runs out.

    Deterministic: leftmost-outermost, no heuristics.  Returning ``None`` on
    exhaustion is what makes this usable inside a *trusted* checker -- the
    checker rejects rather than guesses.
    """
    COUNTERS.bump("term.normalise")
    f = _Fuel(fuel)
    try:
        return _nf(t, f)
    except FuelExhausted:
        COUNTERS.bump("term.normalise_fuel_out")
        return None


# --------------------------------------------------------------------------
# names: a mutable, non-authoritative view table
# --------------------------------------------------------------------------


class NameTable:
    """Names are views.  They are mutable and never authoritative.

    Many names may point at one address (aliasing); one name may be rebound to
    a different address over time (versioning).  Neither operation changes any
    address, and no address ever depends on a name.
    """

    __slots__ = ("_fwd", "_rev")

    def __init__(self) -> None:
        self._fwd: Dict[str, str] = {}
        self._rev: Dict[str, List[str]] = {}

    def bind(self, name: str, addr: str) -> None:
        COUNTERS.bump("name.bind")
        if not isinstance(name, str) or not name:
            raise KernelError("name must be a non-empty str")
        if not isinstance(addr, str) or len(addr) != _DIGEST_BYTES * 2:
            raise KernelError("addr must be a %d-hex-char address" % (_DIGEST_BYTES * 2))
        old = self._fwd.get(name)
        if old is not None and old != addr:
            holders = self._rev.get(old)
            if holders and name in holders:
                holders.remove(name)
                if not holders:
                    del self._rev[old]
        self._fwd[name] = addr
        holders = self._rev.setdefault(addr, [])
        if name not in holders:
            holders.append(name)
            holders.sort()

    def unbind(self, name: str) -> None:
        addr = self._fwd.pop(name, None)
        if addr is None:
            return
        holders = self._rev.get(addr)
        if holders and name in holders:
            holders.remove(name)
            if not holders:
                del self._rev[addr]

    def resolve(self, name: str) -> Optional[str]:
        """name -> address, or ``None``."""
        COUNTERS.bump("name.resolve")
        return self._fwd.get(name)

    def names_of(self, addr: str) -> Tuple[str, ...]:
        """address -> every name currently bound to it, sorted."""
        COUNTERS.bump("name.reverse")
        return tuple(self._rev.get(addr, ()))

    def name_of(self, addr: str) -> Optional[str]:
        """A single display name (the lexicographically first), or ``None``."""
        got = self.names_of(addr)
        return got[0] if got else None

    def reset(self) -> None:
        self._fwd.clear()
        self._rev.clear()


NAMES = NameTable()


def bind(name: str, addr_or_term) -> None:
    addr = addr_or_term.addr if isinstance(addr_or_term, Term) else addr_or_term
    NAMES.bind(name, addr)


def resolve(name: str) -> Optional[str]:
    return NAMES.resolve(name)


def name_of(addr: str) -> Optional[str]:
    return NAMES.name_of(addr)


def names_of(addr: str) -> Tuple[str, ...]:
    return NAMES.names_of(addr)


def intern_table_size() -> Tuple[int, int]:
    """(number of interned sorts, number of interned terms)."""
    return (len(_SORTS), len(_TERMS))


def reset_all() -> None:
    """Clear the name view and the counters.

    The intern tables are deliberately *not* cleared: addresses are global and
    permanent, which is the whole point of L0.
    """
    NAMES.reset()
    COUNTERS.reset()
