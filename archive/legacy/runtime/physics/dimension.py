"""Dimensioned quantities in the native IR -- CRYSTAL.md Sec.1's "physical
dimensions" made a *construction-time* property, not a checked-later annotation.

The design rule is copied, deliberately and literally, from
``runtime/kernel/term.py``:

    Ill-sorted terms do not exist.  Construction is the typecheck.  There is
    no separate "check this term" pass and no way to hold an ill-sorted Term.
                                                    -- kernel/README.md L0 (2)

Here: **ill-dimensioned quantities do not exist**.  ``metre + second`` raises
``DimensionError`` from the constructor of the sum, exactly as ``App`` raises
``SortError``.  There is no ``check_dimensions(expr)`` pass anywhere in this
package, because there is nothing for it to check: an ill-dimensioned value
was never built.

Two consequences that the tests pin down.

1.  **The dimension is part of the content address.**  ``addr`` is
    ``blake2b(magnitude || dimension address)``, so ``1 metre`` and
    ``1 second`` are different addresses, and there is no presentation of the
    runtime in which they collide.  That is L0 identity applied to physics:
    "identical addresses => identical construction, always".

2.  **The kernel enforces it too, without being modified.**  ``sort_of``
    injects a ``Dimension`` into a kernel ``Sort``, and ``term_of`` builds the
    magnitude as a ``Const`` *of that sort*.  Since a kernel address is
    ``H(head || sort address || children)``, the dimension is inside the kernel
    address as well; and since ``T.App`` sort-checks at build time, applying a
    length-typed ``plus`` to a time-typed argument raises ``T.SortError`` from
    the trusted heart.  We get the guarantee twice, by two independent
    mechanisms, and the test suite plants a false control against each.

Exactness
---------
Exponents are ``fractions.Fraction`` (so ``sqrt`` of an area is expressible);
magnitudes are ``Fraction``.  A ``float`` anywhere raises ``DimensionError`` at
construction.  There is no floating point in this module and there is no
division operator in its source -- see ``tests/test_physics.py``'s AST walk.
"""

from __future__ import annotations

import hashlib
from dataclasses import dataclass
from fractions import Fraction
from typing import Dict, Optional, Tuple

from ..kernel import term as T

__all__ = [
    "BASE_DIMENSIONS",
    "DimensionError",
    "Dimension",
    "dimension",
    "DIMENSIONLESS", "LENGTH", "MASS", "TIME", "CURRENT", "TEMPERATURE",
    "AMOUNT", "LUMINOUS",
    "AREA", "VOLUME", "SPEED", "ACCELERATION", "FREQUENCY",
    "Quantity",
    "quantity",
    "exact",
    "sort_of",
    "term_of",
    "plus_of",
    "COUNTERS",
]

COUNTERS = T.Counters()


class DimensionError(Exception):
    """Raised at construction.  There is no later stage at which to raise it."""


# --------------------------------------------------------------------------
# exactness gate
# --------------------------------------------------------------------------

def exact(x) -> Fraction:
    """Coerce to an exact ``Fraction``, or refuse.

    ``bool`` is rejected before ``int`` because ``isinstance(True, int)`` is
    true and ``True metres`` is not a quantity.  ``float`` is rejected outright
    -- this is the boundary the whole runtime is built to keep.
    """
    if isinstance(x, bool):
        raise DimensionError("a bool is not an exact magnitude: %r" % (x,))
    if isinstance(x, float):   # EXACT-CONTROL: the name `float` appears here
        raise DimensionError("floating point is not exact: %r" % (x,))
    if isinstance(x, Fraction):
        return x
    if isinstance(x, int):
        return Fraction(x)
    raise DimensionError("not an exact rational: %r (%s)" % (x, type(x).__name__))


# --------------------------------------------------------------------------
# dimensions: exact rational exponent vectors over the base dimensions
# --------------------------------------------------------------------------

BASE_DIMENSIONS: Tuple[str, ...] = ("L", "M", "T", "I", "K", "N", "J")
#  L length   M mass   T time   I current   K temperature   N amount
#  J luminous intensity                     (SI's seven, K written for Theta)

_DIMS: Dict[Tuple[Fraction, ...], "Dimension"] = {}
_SEP = b"\x1f"


def _dim_addr(exps: Tuple[Fraction, ...]) -> str:
    COUNTERS.bump("dimension.hash")
    h = hashlib.blake2b(digest_size=16)
    h.update(b"dimension")
    h.update(_SEP)
    for name, e in zip(BASE_DIMENSIONS, exps):
        h.update(name.encode("ascii"))
        h.update(b"^")
        h.update(("%d:%d" % (e.numerator, e.denominator)).encode("ascii"))
        h.update(_SEP)
    return h.hexdigest()


@dataclass(frozen=True)
class Dimension:
    """An exact rational exponent vector over ``BASE_DIMENSIONS``.

    Interned: ``dimension(L=1) is dimension(L=1)``.  Compare with ``is`` or by
    ``addr``; never by field-by-field equality.
    """

    exponents: Tuple[Fraction, ...]
    addr: str

    # -- construction ----------------------------------------------------
    def times(self, other: "Dimension") -> "Dimension":
        return _intern(tuple(a + b for a, b in zip(self.exponents, other.exponents)))

    def over(self, other: "Dimension") -> "Dimension":
        return _intern(tuple(a - b for a, b in zip(self.exponents, other.exponents)))

    def inverse(self) -> "Dimension":
        return _intern(tuple(-a for a in self.exponents))

    def power(self, r) -> "Dimension":
        r = exact(r)
        return _intern(tuple(a * r for a in self.exponents))

    # -- views -----------------------------------------------------------
    @property
    def is_dimensionless(self) -> bool:
        return all(e == 0 for e in self.exponents)

    def render(self) -> str:
        if self.is_dimensionless:
            return "1"
        parts = []
        for name, e in zip(BASE_DIMENSIONS, self.exponents):
            if e == 0:
                continue
            if e == 1:
                parts.append(name)
            elif e.denominator == 1:
                parts.append("%s^%d" % (name, e.numerator))
            else:
                parts.append("%s^(%d:%d)" % (name, e.numerator, e.denominator))
        return ".".join(parts)

    def __repr__(self) -> str:                       # pragma: no cover - view
        return "Dimension(%s)" % self.render()


def _intern(exps: Tuple[Fraction, ...]) -> Dimension:
    got = _DIMS.get(exps)
    if got is not None:
        COUNTERS.bump("dimension.intern_hit")
        return got
    COUNTERS.bump("dimension.intern_miss")
    d = Dimension(exponents=exps, addr=_dim_addr(exps))
    _DIMS[exps] = d
    return d


def dimension(**kw) -> Dimension:
    """``dimension(L=1, T=-1)`` -- a speed.  Unknown base names are refused."""
    for k in kw:
        if k not in BASE_DIMENSIONS:
            raise DimensionError("unknown base dimension %r; the base is %s"
                                 % (k, ", ".join(BASE_DIMENSIONS)))
    return _intern(tuple(exact(kw.get(name, 0)) for name in BASE_DIMENSIONS))


DIMENSIONLESS = dimension()
LENGTH = dimension(L=1)
MASS = dimension(M=1)
TIME = dimension(T=1)
CURRENT = dimension(I=1)
TEMPERATURE = dimension(K=1)
AMOUNT = dimension(N=1)
LUMINOUS = dimension(J=1)
AREA = dimension(L=2)
VOLUME = dimension(L=3)
SPEED = dimension(L=1, T=-1)
ACCELERATION = dimension(L=1, T=-2)
FREQUENCY = dimension(T=-1)


# --------------------------------------------------------------------------
# quantities
# --------------------------------------------------------------------------

_QUANTITIES: Dict[Tuple[Fraction, str], "Quantity"] = {}


def _qty_addr(value: Fraction, dim: Dimension) -> str:
    COUNTERS.bump("quantity.hash")
    h = hashlib.blake2b(digest_size=16)
    h.update(b"quantity")
    h.update(_SEP)
    h.update(("%d:%d" % (value.numerator, value.denominator)).encode("ascii"))
    h.update(_SEP)
    h.update(dim.addr.encode("ascii"))
    return h.hexdigest()


@dataclass(frozen=True)
class Quantity:
    """An exact rational magnitude carrying a dimension, content-addressed.

    ``addr`` covers *both* fields, so ``quantity(1, LENGTH).addr !=
    quantity(1, TIME).addr``.  Equal magnitude with a different dimension is a
    different construction and gets a different address -- there is no
    "same number, different unit" collision anywhere in the runtime.
    """

    value: Fraction
    dim: Dimension
    addr: str

    # -- dimension-checked arithmetic ------------------------------------
    def plus(self, other: "Quantity") -> "Quantity":
        """Raises if the dimensions differ.  Metres plus seconds does not exist."""
        _require_same(self, other, "+")
        COUNTERS.bump("quantity.add")
        return quantity(self.value + other.value, self.dim)

    def minus(self, other: "Quantity") -> "Quantity":
        _require_same(self, other, "-")
        COUNTERS.bump("quantity.sub")
        return quantity(self.value - other.value, self.dim)

    def times(self, other: "Quantity") -> "Quantity":
        COUNTERS.bump("quantity.mul")
        return quantity(self.value * other.value, self.dim.times(other.dim))

    def over(self, other: "Quantity") -> "Quantity":
        if other.value == 0:
            raise DimensionError("division by an exactly zero quantity")
        COUNTERS.bump("quantity.div")
        return quantity(Fraction(self.value, other.value), self.dim.over(other.dim))

    def power(self, n: int) -> "Quantity":
        if isinstance(n, bool) or not isinstance(n, int):
            raise DimensionError("only integer powers of a magnitude are exact")
        COUNTERS.bump("quantity.pow")
        return quantity(self.value ** n, self.dim.power(n))

    def scaled(self, k) -> "Quantity":
        """Multiply the magnitude by an exact dimensionless rational."""
        return quantity(self.value * exact(k), self.dim)

    # -- comparison, also dimension-checked --------------------------------
    def compare(self, other: "Quantity") -> int:
        _require_same(self, other, "<=>")
        COUNTERS.bump("quantity.compare")
        if self.value < other.value:
            return -1
        return 1 if self.value > other.value else 0

    # Operators are provided so that the *natural* way to write it is also the
    # checked way.  There is no unchecked path.
    __add__ = plus
    __sub__ = minus
    __mul__ = times

    def render(self) -> str:
        v = self.value
        mag = str(v.numerator) if v.denominator == 1 else "%d:%d" % (v.numerator,
                                                                    v.denominator)
        return "%s [%s]" % (mag, self.dim.render())

    def __repr__(self) -> str:                       # pragma: no cover - view
        return "Quantity(%s)" % self.render()


def _require_same(a: Quantity, b: Quantity, op: str) -> None:
    if not isinstance(b, Quantity):
        raise DimensionError("%s: not a Quantity: %r" % (op, b))
    if a.dim is not b.dim:
        COUNTERS.bump("quantity.refused")
        raise DimensionError(
            "cannot form %s %s %s: [%s] %s [%s] is not a construction"
            % (a.render(), op, b.render(), a.dim.render(), op, b.dim.render()))


def quantity(value, dim: Dimension) -> Quantity:
    """The only constructor.  Interned, exact, dimension-addressed."""
    if not isinstance(dim, Dimension):
        raise DimensionError("not a Dimension: %r" % (dim,))
    v = exact(value)
    key = (v, dim.addr)
    got = _QUANTITIES.get(key)
    if got is not None:
        COUNTERS.bump("quantity.intern_hit")
        return got
    COUNTERS.bump("quantity.intern_miss")
    q = Quantity(value=v, dim=dim, addr=_qty_addr(v, dim))
    _QUANTITIES[key] = q
    return q


# --------------------------------------------------------------------------
# the same guarantee, obtained a second time from the kernel itself
# --------------------------------------------------------------------------

def sort_of(dim: Dimension) -> T.Sort:
    """The kernel sort a quantity of this dimension inhabits.

    One base sort per dimension.  This is not decoration: ``T.App`` refuses an
    argument whose sort is not the function's domain, at build time, in the
    trusted file -- so once quantities are kernel terms, the kernel is the one
    refusing metres plus seconds, and this module is not trusted for it.
    """
    return T.base_sort("Q[%s]" % dim.render())


def term_of(q: Quantity) -> T.Term:
    """A kernel ``Const`` whose *symbol* is the magnitude and whose *sort* is
    the dimension.

    The kernel address is ``H(head || sort address || children)``, so the
    dimension is inside the kernel address by construction.  Two quantities of
    equal magnitude and different dimension therefore differ in the kernel's
    addressing as well as in this module's.
    """
    v = q.value
    sym = "#%d" % v.numerator if v.denominator == 1 else "#%d:%d" % (v.numerator,
                                                                    v.denominator)
    return T.Const(sym, sort_of(q.dim))


def plus_of(dim: Dimension) -> T.Term:
    """``plus : Q[d] -> Q[d] -> Q[d]`` -- addition *at one dimension*.

    There is no dimension-polymorphic ``plus`` in this module, because the
    kernel's sorts are simple and a polymorphic one could not be sort-checked.
    That restriction is the feature: ``T.App(T.App(plus_of(LENGTH), metre),
    second)`` raises ``T.SortError``.
    """
    s = sort_of(dim)
    return T.Const("plus", T.arrow(s, T.arrow(s, s)))


def add_terms(dim: Dimension, a: T.Term, b: T.Term) -> T.Term:
    """Build ``a + b`` as a kernel term.  Raises ``T.SortError`` on mismatch."""
    return T.App(T.App(plus_of(dim), a), b)


def dimension_of_sort(s: T.Sort) -> Optional[Dimension]:
    """Recover the dimension a sort was built from, for reporting only.

    Nothing in this package makes a decision from this: it parses a *view*.
    """
    name = getattr(s, "name", None)
    if not isinstance(name, str) or not name.startswith("Q[") or not name.endswith("]"):
        return None
    body = name[2:-1]
    if body == "1":
        return DIMENSIONLESS
    kw: Dict[str, Fraction] = {}
    for part in body.split("."):
        if "^" not in part:
            kw[part] = Fraction(1)
            continue
        base, e = part.split("^", 1)
        if e.startswith("(") and e.endswith(")"):
            num, den = e[1:-1].split(":", 1)
            kw[base] = Fraction(int(num), int(den))
        else:
            kw[base] = Fraction(int(e))
    try:
        return dimension(**kw)
    except DimensionError:
        return None
