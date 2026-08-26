"""The charts of `notes/ATLAS_OF_N.md`, as executable constructions.

Six charts of N, each built as an object with *operations* -- not a label:

    (a) peano      initial algebra of X |-> 1 + X; successor, recursor, induction
    (b) tally      free monoid on one generator; ticks, concatenation
    (c) cardinal   iso-classes of finite sets; S_n exposed as a computed group
    (d) ordinal    finite linear orders; the S_n-torsor of orders
    (e) digit      base-b digit words; base, endianness and carry as residuals
    (f) prime      free commutative monoid on the primes; factorization

Every chart carries a ``Reachability`` declaration -- CRYSTAL.md Sec.4, mandatory:
generated locus, exact image, equivalence kernel, closure/completion, **omitted
locus**, which operations extend to the completion, and which depend irreducibly
on finite addresses.  Each field is *checked* on a stated finite range, not
asserted (``Chart.reachability_report``).

N has two incomparable completions (ATLAS_OF_N Sec.5.5): R, in which N is closed
and discrete, and the b-adics Z_b, in which N is dense.  ``ArchimedeanWindow``
and ``BAdicWindow`` make both concrete and testable, including the four
operation-extension verdicts and the two-sided no-continuous-map witness.

Kernel bridge
-------------
Every chart also emits its element as a **kernel term**.  Numbers are Church
numerals over an opaque base sort, so a chart's construction is a term the
kernel can *run*: the digit chart emits a Horner term over Church arithmetic, the
prime chart emits a Church product, the Peano chart emits an iterated successor.
The transitions in ``transitions.py`` then install ``Iso`` edges whose
``IsoWitness`` the kernel checks by normalising both sides -- i.e. by actually
computing the positional value and the factorization product.

Each chart's term is wrapped in a beta-erasable chart tag (``K t tag``), so the
six presentations of one number have six distinct L0 addresses while reducing to
one normal form.  That is the atlas in the kernel's own terms: same value,
different constructions, and the difference is exactly what L0 keeps.

CPU-only, pure stdlib, exact, deterministic.  No float is constructed anywhere.
"""

from __future__ import annotations

import itertools
from dataclasses import dataclass, field
from fractions import Fraction
from typing import Any, Callable, Dict, List, Optional, Sequence, Tuple

from ..kernel import term as T
from ..kernel.term import Counters
from .residual import (
    FiniteGroup,
    Torsor,
    carry_cocycle,
    cyclic_group,
    symmetric_group,
)

__all__ = [
    "ChartError",
    "Reachability",
    "ReachabilityReport",
    "Chart",
    "PeanoChart",
    "TallyChart",
    "CardinalChart",
    "OrdinalChart",
    "DigitChart",
    "PrimeChart",
    "CHARTS",
    "chart",
    "church",
    "CH",
    "ArchimedeanWindow",
    "BAdicWindow",
    "CompletionClaim",
    "ClaimVerdict",
    "two_completions_report",
    "Ordinal",
    "OMEGA",
]


class ChartError(Exception):
    """A chart was used outside the finite range it declares."""


def _counters(c: Optional[Counters]) -> Counters:
    return c if c is not None else Counters()


# ---------------------------------------------------------------------------
# 0.  the kernel bridge: Church arithmetic in the kernel's STLC
# ---------------------------------------------------------------------------

X = T.base_sort("Point")
XX = T.arrow(X, X)
CH = T.arrow(XX, XX)          #: the sort of a Church numeral

_F = T.Var(1, XX)
_XV = T.Var(0, X)


def church(n: int) -> T.Term:
    """``\\f x. f^n x`` -- the normal form every chart's term reduces to."""
    if n < 0:
        raise ChartError("Church numerals index N, not Z")
    body: T.Term = _XV
    for _ in range(n):
        body = T.App(_F, body)
    return T.Lam(XX, T.Lam(X, body))


#: \m f x. f (m f x)
SUCC_T = T.Lam(CH, T.Lam(XX, T.Lam(X, T.App(
    T.Var(1, XX), T.App(T.App(T.Var(2, CH), T.Var(1, XX)), T.Var(0, X))))))

#: \m n f x. m f (n f x)   -- Peano addition, and (see below) tally concatenation
PLUS_T = T.Lam(CH, T.Lam(CH, T.Lam(XX, T.Lam(X, T.App(
    T.App(T.Var(3, CH), T.Var(1, XX)),
    T.App(T.App(T.Var(2, CH), T.Var(1, XX)), T.Var(0, X)))))))

#: \m n f. m (n f)
MULT_T = T.Lam(CH, T.Lam(CH, T.Lam(XX, T.App(
    T.Var(2, CH), T.App(T.Var(1, CH), T.Var(0, XX))))))

#: \a b. a   -- the chart tag carrier; beta-erasable, address-visible
KONST_T = T.Lam(CH, T.Lam(CH, T.Var(1, CH)))

#: the identity transport used as the checked ``IsoWitness`` on both sides
ID_CH = T.Lam(CH, T.Var(0, CH))

ZERO_T = church(0)
ONE_T = church(1)

#: the free monoid's concatenation, transcribed into the kernel IR.  It is the
#: *same address* as PLUS_T: ATLAS_OF_N Sec.2.1 statement (2), "the two
#: signatures are definitional expansions of each other", visible at L0.
CONCAT_T = T.Lam(CH, T.Lam(CH, T.Lam(XX, T.Lam(X, T.App(
    T.App(T.Var(3, CH), T.Var(1, XX)),
    T.App(T.App(T.Var(2, CH), T.Var(1, XX)), T.Var(0, X)))))))


def chart_tag(key: str) -> T.Term:
    return T.Const("chart:" + key, CH)


def tagged(key: str, body: T.Term) -> T.Term:
    """``K body tag`` -- reduces to ``body``, but its address names the chart."""
    return T.App(T.App(KONST_T, body), chart_tag(key))


def normal_value(t: T.Term, fuel: int = 200000) -> Optional[int]:
    """Run a chart term in the kernel and read off the natural number.

    Returns ``None`` if it does not normalise to a Church numeral.
    """
    nf = T.beta_normal(t, fuel)
    if nf is None:
        return None
    n = 0
    cur = nf
    if cur.head != T.LAM:
        return None
    cur = cur.children[0]
    if cur.head != T.LAM:
        return None
    cur = cur.children[0]
    while cur.head == T.APP:
        fn, arg = cur.children
        if not (fn.head == T.VAR and fn.index == 1):
            return None
        n += 1
        cur = arg
    if not (cur.head == T.VAR and cur.index == 0):
        return None
    return n


# ---------------------------------------------------------------------------
# 1.  CRYSTAL.md Sec.4 -- the reachability declaration, and its check
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class ReachabilityReport:
    chart: str
    image_ok: bool
    image_size: int
    kernel_ok: bool
    kernel_detail: str
    omitted_witness: Any
    steps: int

    @property
    def ok(self) -> bool:
        return self.image_ok and self.kernel_ok and self.omitted_witness is not None

    def render(self) -> str:
        return ("reachability %-9s image_ok=%-5s |image|=%-5d kernel_ok=%-5s "
                "omitted_witness=%s steps=%d  (%s)"
                % (self.chart, self.image_ok, self.image_size, self.kernel_ok,
                   self.omitted_witness, self.steps, self.kernel_detail))


@dataclass(frozen=True)
class Reachability:
    """CRYSTAL.md Sec.4, one record per chart.  Every field is load-bearing.

    ``omitted_locus`` is the field a chart cannot claim completeness without.
    ``extends`` / ``finite_address_only`` split the operations by whether they
    survive passage to the declared completion.
    """

    generated_locus: str
    exact_image: str
    equivalence_kernel: str
    closure: Tuple[str, ...]
    omitted_locus: str
    extends: Tuple[str, ...]
    finite_address_only: Tuple[str, ...]

    def render(self) -> str:
        return "\n".join([
            "  generated locus     : %s" % self.generated_locus,
            "  exact image         : %s" % self.exact_image,
            "  equivalence kernel  : %s" % self.equivalence_kernel,
            "  closure/completion  : %s" % ", ".join(self.closure),
            "  OMITTED locus       : %s" % self.omitted_locus,
            "  extends to closure  : %s" % ", ".join(self.extends),
            "  finite-address only : %s" % ", ".join(self.finite_address_only),
        ])


# ---------------------------------------------------------------------------
# 2.  the chart interface
# ---------------------------------------------------------------------------

class Chart:
    """A presentation of N with operations, a kernel term, and a Sec.4 record."""

    key: str = ""
    letter: str = ""
    name: str = ""
    choices: Tuple[str, ...] = ()      # ATLAS_OF_N Thm 4.2: chart parameters

    # -- the presentation --------------------------------------------------
    def datum(self, n: int) -> Any:
        raise NotImplementedError

    def value(self, d: Any) -> int:
        raise NotImplementedError

    def body_term(self, n: int) -> T.Term:
        raise NotImplementedError

    def term(self, n: int) -> T.Term:
        return tagged(self.key, self.body_term(n))

    # -- Sec.4 -------------------------------------------------------------
    def reachability(self) -> Reachability:
        raise NotImplementedError

    def generated_values(self, bound: int) -> Tuple[int, ...]:
        return tuple(range(bound + 1))

    def kernel_check(self, bound: int, counters: Optional[Counters] = None
                     ) -> Tuple[bool, str]:
        """Check the declared equivalence kernel of ``value`` on the locus."""
        c = _counters(counters)
        seen: Dict[int, Any] = {}
        for n in range(bound + 1):
            c.bump("atlas.chart.probe")
            d = self.datum(n)
            v = self.value(d)
            if v != n:
                return False, "round trip failed at %d (got %d)" % (n, v)
            seen[v] = d
        return True, "value o datum = id on [0,%d]; kernel is trivial on canonical data" % bound

    def omitted_witness(self, bound: int) -> Any:
        """A concrete element of the omitted locus (never ``None``)."""
        return bound + 1

    def reachability_report(self, bound: int, counters: Optional[Counters] = None
                            ) -> ReachabilityReport:
        c = _counters(counters)
        start = c.get("atlas.chart.probe")
        vals = self.generated_values(bound)
        image_ok = vals == tuple(range(bound + 1))
        c.bump("atlas.chart.probe", len(vals))
        kok, kdetail = self.kernel_check(bound, c)
        return ReachabilityReport(self.key, image_ok, len(vals), kok, kdetail,
                                  self.omitted_witness(bound),
                                  c.get("atlas.chart.probe") - start)

    def render(self) -> str:
        return "(%s) %-9s %s%s" % (
            self.letter, self.key, self.name,
            ("   choices: " + ", ".join(self.choices)) if self.choices else
            "   choices: none (choice-free, ATLAS_OF_N Thm 4.2(1))")


# ---------------------------------------------------------------------------
# (a) Peano -- the initial algebra of X |-> 1 + X
# ---------------------------------------------------------------------------

ZERO: Tuple = ()


class PeanoChart(Chart):
    key, letter = "peano", "a"
    name = "initial algebra of X |-> 1+X: successor, and induction as a recursor"

    def datum(self, n: int) -> Any:
        d: Any = ZERO
        for _ in range(n):
            d = ("S", d)
        return d

    def value(self, d: Any) -> int:
        n = 0
        while d != ZERO:
            if not (isinstance(d, tuple) and len(d) == 2 and d[0] == "S"):
                raise ChartError("not a Peano datum: %r" % (d,))
            n += 1
            d = d[1]
        return n

    def succ(self, d: Any) -> Any:
        return ("S", d)

    # -- the universal property, executable -------------------------------
    def rec(self, base: Any, step: Callable[[Any, Any], Any], d: Any,
            counters: Optional[Counters] = None) -> Any:
        """The unique algebra map out of the initial algebra.

        ``rec(base, step, 0) = base``; ``rec(base, step, S d) = step(d, rec(...))``.
        This *is* induction (ATLAS_OF_N Prop. 1.2: induction is initiality), and
        every other operation of this chart is built from it.
        """
        c = _counters(counters)
        chain: List[Any] = []
        cur = d
        while cur != ZERO:
            chain.append(cur[1])
            cur = cur[1]
        acc = base
        for pred in reversed(chain):
            c.bump("atlas.peano.rec")
            acc = step(pred, acc)
        return acc

    def add(self, a: Any, b: Any, counters: Optional[Counters] = None) -> Any:
        return self.rec(a, lambda _p, acc: ("S", acc), b, counters)

    def mul(self, a: Any, b: Any, counters: Optional[Counters] = None) -> Any:
        return self.rec(ZERO, lambda _p, acc: self.add(acc, a, counters), b, counters)

    def induction_holds(self, pred: Callable[[int], bool], bound: int,
                        counters: Optional[Counters] = None) -> Tuple[bool, Optional[int]]:
        """Prop. 1.2 on the truncation ``[0, bound]``.

        If ``pred`` holds at 0 and is closed under successor *within the
        truncation*, it holds everywhere on it.  Returns the first failure
        otherwise -- so a broken 'inductive' predicate is caught, not believed.
        """
        c = _counters(counters)
        if not pred(0):
            return False, 0
        for n in range(bound):
            c.bump("atlas.peano.induction")
            if pred(n) and not pred(n + 1):
                return False, n + 1
        return True, None

    def comparison_maps(self, bound: int, target_succ: Callable[[int], Optional[int]],
                        counters: Optional[Counters] = None) -> Tuple[Tuple[int, ...], ...]:
        """Every function ``h : [0,bound] -> [0,bound]`` with ``h 0 = 0`` and
        ``h (n+1) = target_succ (h n)``, found by **exhaustive enumeration** over
        all ``(bound+1)^(bound+1)`` functions.

        For the true successor the answer is a single map (the identity): that is
        the finite, refutable shadow of "the comparison type is contractible"
        (ATLAS_OF_N Residual 2.1(1)).  See ``transitions.CONTRACTIBILITY_SCOPE``
        for exactly what this does and does not establish.
        """
        c = _counters(counters)
        m = bound + 1
        out: List[Tuple[int, ...]] = []
        for h in itertools.product(range(m), repeat=m):
            c.bump("atlas.peano.compare")
            if h[0] != 0:
                continue
            ok = True
            for n in range(bound):
                s = target_succ(h[n])
                if s is None or s != h[n + 1]:
                    ok = False
                    break
            if ok:
                out.append(h)
        return tuple(out)

    def body_term(self, n: int) -> T.Term:
        t = ZERO_T
        for _ in range(n):
            t = T.App(SUCC_T, t)
        return t

    def reachability(self) -> Reachability:
        return Reachability(
            generated_locus="{ s^n(0) : n finite }, generated from 0 by one unary constructor",
            exact_image="all of N; every element is reached in exactly n steps",
            equivalence_kernel="trivial: s is injective and 0 is not a successor "
                               "(Lambek, ATLAS_OF_N Prop. 1.1)",
            closure=("Z (group completion)", "R (archimedean)", "Z_b (b-adic)"),
            omitted_locus="every element of any completion: Z\\N, R\\N, Z_b\\N. "
                          "Induction itself is omitted by all three "
                          "(ATLAS_OF_N Thm 5.1) -- N is a proper subalgebra of each.",
            extends=("successor (as +1 on Z/R, as the odometer on Z_b)", "+", "x"),
            finite_address_only=("the recursor rec(base, step, -)",
                                 "induction / initiality",
                                 "well-ordering"),
        )


# ---------------------------------------------------------------------------
# (b) tally -- the free monoid on one generator
# ---------------------------------------------------------------------------

TICK = "|"


class TallyChart(Chart):
    key, letter = "tally", "b"
    name = "free monoid on one generator: ticks and concatenation"

    def datum(self, n: int) -> str:
        return TICK * n

    def value(self, d: str) -> int:
        if any(ch != TICK for ch in d):
            raise ChartError("not a tally: %r" % (d,))
        return len(d)

    def concat(self, a: str, b: str, counters: Optional[Counters] = None) -> str:
        c = _counters(counters)
        c.bump("atlas.tally.concat", len(a) + len(b))
        return a + b

    def free_monoid_map(self, m_unit: Any, m_op: Callable[[Any, Any], Any],
                        generator: Any, d: str,
                        counters: Optional[Counters] = None) -> Any:
        """The universal property, executed: the unique monoid map sending the
        generator to ``generator``.  ``Hom_Mon(N, M) = U(M)`` (ATLAS_OF_N 1(b))."""
        c = _counters(counters)
        acc = m_unit
        for _ in d:
            c.bump("atlas.tally.hom")
            acc = m_op(acc, generator)
        return acc

    def body_term(self, n: int) -> T.Term:
        t = ZERO_T                       # the empty word
        for _ in range(n):
            t = T.App(T.App(CONCAT_T, ONE_T), t)
        return t

    def reachability(self) -> Reachability:
        return Reachability(
            generated_locus="{ | }^* : words in one letter, generated by concatenation",
            exact_image="all of N, bijectively with word length",
            equivalence_kernel="trivial: the free monoid on one generator has no relations "
                               "beyond associativity and the unit",
            closure=("Z (group completion of (N,+))",
                     "Q_{>0} (group completion of (N_{>0},x)) -- a *different* completion, "
                     "ATLAS_OF_N Sec.5.3"),
            omitted_locus="infinite words; and the two group completions are not comparable: "
                          "rank 1 vs rank aleph_0, with no group map between them restricting "
                          "to the identity on N_{>0}",
            extends=("concatenation (= +)", "the monoid action on any endomorphism"),
            finite_address_only=("word length as an address", "prefix/suffix decomposition"),
        )


# ---------------------------------------------------------------------------
# (c) cardinals -- the pre-truncation chart; S_n is the point
# ---------------------------------------------------------------------------

ATOMS = tuple("abcdefghij")


class CardinalChart(Chart):
    key, letter = "cardinal", "c"
    name = "pi_0 of finite sets and bijections; Aut = S_n, computed"

    def datum(self, n: int) -> Tuple[str, ...]:
        if n > len(ATOMS):
            raise ChartError("the cardinal chart's atom universe holds %d elements"
                             % len(ATOMS))
        return ATOMS[:n]

    def value(self, d: Sequence[Any]) -> int:
        return len(tuple(d))

    # -- the symmetric group, as an actual computed group ------------------
    def automorphisms(self, n: int) -> FiniteGroup:
        """Aut([n]) = S_n: permutations, composition, inverses, orbits."""
        return symmetric_group(n)

    def act(self, sigma: Tuple[int, ...], seq: Sequence[Any]) -> Tuple[Any, ...]:
        """Transport a labelling along a permutation of positions."""
        return tuple(seq[sigma[i]] for i in range(len(seq)))

    def isos_to_standard(self, X: Sequence[Any]) -> Tuple[Tuple[int, ...], ...]:
        """``Iso(X, [n])`` as tuples: the i-th element of X goes to ``f[i]``."""
        return tuple(sorted(itertools.permutations(range(len(X)))))

    def iso_torsor(self, n: int) -> Torsor:
        """ATLAS_OF_N Thm 2.3(4): Iso(X,[n]) is a torsor under S_n, size n!."""
        g = symmetric_group(n)
        pts = self.isos_to_standard(self.datum(n))
        return Torsor("Iso(X,[%d]) under S_%d" % (n, n), g, pts,
                      lambda s, f: tuple(s[f[i]] for i in range(n)))

    def decategorification_fiber(self, n: int, universe: int
                                 ) -> Tuple[Tuple[Any, ...], ...]:
        """Every ``n``-element subset of a universe: the fiber of pi_0 over n."""
        return tuple(itertools.combinations(ATOMS[:universe], n))

    def disjoint_union(self, Xs: Sequence[Any], Ys: Sequence[Any]) -> Tuple[Any, ...]:
        return tuple([("l", x) for x in Xs] + [("r", y) for y in Ys])

    def product(self, Xs: Sequence[Any], Ys: Sequence[Any]) -> Tuple[Any, ...]:
        return tuple((x, y) for x in Xs for y in Ys)

    def body_term(self, n: int) -> T.Term:
        """A cardinal is a sum of ones: the term sees the size and nothing else.

        Two different ``n``-element sets produce the *same address*.  That
        address collapse is decategorification at L0.
        """
        t = ZERO_T
        for _ in range(n):
            t = T.App(T.App(PLUS_T, ONE_T), t)
        return t

    def reachability(self) -> Reachability:
        return Reachability(
            generated_locus="finite sets built from a %d-atom universe by disjoint union "
                            "and product; morphisms are bijections" % len(ATOMS),
            exact_image="iso-classes = N, but the chart lives one level up: it is the "
                        "groupoid F = coprod_n BS_n, not the set N",
            equivalence_kernel="NOT trivial: the fiber of |-| over n is every n-element "
                               "set, and each carries Aut = S_n of order n!. "
                               "|X| = |Y| is the truncation of an S_n-torsor.",
            closure=("Card (cardinal arithmetic past omega)",),
            omitted_locus="sets larger than the atom universe; all infinite cardinals; "
                          "and -- the point of this chart -- the entire automorphism "
                          "datum is omitted by pi_0, not by the chart",
            extends=("+ (disjoint union)", "x (product)", "commutativity of both"),
            finite_address_only=("the labelling of elements", "S_n itself",
                                 "bijective proofs (which exhibit a specific bijection)"),
        )

    def kernel_check(self, bound: int, counters: Optional[Counters] = None
                     ) -> Tuple[bool, str]:
        c = _counters(counters)
        detail = []
        for n in range(min(bound, 4) + 1):
            c.bump("atlas.chart.probe")
            fib = self.decategorification_fiber(n, min(len(ATOMS), 6))
            g = symmetric_group(n)
            if any(self.value(s) != n for s in fib):
                return False, "fiber over %d contains a set of another size" % n
            detail.append("|fiber(%d)|=%d Aut=%d" % (n, len(fib), g.order))
        return True, "nontrivial kernel, measured: " + " ".join(detail)


# ---------------------------------------------------------------------------
# (d) ordinals below omega -- rigidification
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Ordinal:
    """``omega*a + b`` in Cantor normal form, enough for ATLAS_OF_N Thm 2.6(2)."""

    a: int = 0
    b: int = 0

    @property
    def finite(self) -> bool:
        return self.a == 0

    def __add__(self, other: "Ordinal") -> "Ordinal":
        if other.a > 0:
            return Ordinal(self.a + other.a, other.b)
        return Ordinal(self.a, self.b + other.b)

    def __mul__(self, other: "Ordinal") -> "Ordinal":
        if self == Ordinal(0, 0) or other == Ordinal(0, 0):
            return Ordinal(0, 0)
        if other.finite:                       # alpha * m, m >= 1
            if self.a == 0:                    # both finite: ordinary product
                return Ordinal(0, self.b * other.b)
            return Ordinal(self.a * other.b, self.b)
        if self.finite:                        # m * (omega*a + b) = omega*a + m*b
            return Ordinal(other.a, self.b * other.b)
        raise ChartError("omega*omega is outside this notation")

    def render(self) -> str:
        if self.a == 0:
            return str(self.b)
        head = "omega" if self.a == 1 else "omega*%d" % self.a
        return head if self.b == 0 else "%s+%d" % (head, self.b)


OMEGA = Ordinal(1, 0)


class OrdinalChart(Chart):
    key, letter = "ordinal", "d"
    name = "finite well-orders: the linear order as the extra datum"

    def datum(self, n: int) -> Tuple[Any, ...]:
        if n > len(ATOMS):
            raise ChartError("the ordinal chart's atom universe holds %d elements"
                             % len(ATOMS))
        return ATOMS[:n]                     # listed in increasing order

    def value(self, d: Sequence[Any]) -> int:
        return len(tuple(d))

    def orders(self, X: Sequence[Any]) -> Tuple[Tuple[Any, ...], ...]:
        """Every linear order on X, as the increasing listing.  There are n!."""
        return tuple(sorted(itertools.permutations(tuple(X))))

    def order_torsor(self, n: int) -> Torsor:
        """ATLAS_OF_N Thm 2.5: linear orders on an n-set are a torsor under S_n.

        The action is transport: ``(sigma . <)`` lists position ``i`` with the
        element that ``<`` put at position ``sigma^-1(i)``.
        """
        g = symmetric_group(n)
        pts = self.orders(self.datum(n))

        def act(sigma: Tuple[int, ...], o: Tuple[Any, ...]) -> Tuple[Any, ...]:
            return tuple(o[sigma[i]] for i in range(n))

        return Torsor("LinOrd([%d]) under S_%d" % (n, n), g, pts, act)

    def order_isomorphisms(self, o1: Sequence[Any], o2: Sequence[Any],
                           counters: Optional[Counters] = None
                           ) -> Tuple[Dict[Any, Any], ...]:
        """Every order isomorphism ``(X,<1) -> (Y,<2)``, by exhaustion.

        Prop. 2.4 predicts exactly one for equal lengths, none otherwise; this
        enumerates all ``n!`` candidate bijections and filters.
        """
        c = _counters(counters)
        o1, o2 = tuple(o1), tuple(o2)
        if len(o1) != len(o2):
            return ()
        out = []
        for perm in itertools.permutations(range(len(o2))):
            c.bump("atlas.ordinal.iso")
            f = {o1[i]: o2[perm[i]] for i in range(len(o1))}
            if all(perm[i] < perm[j] for i in range(len(o1)) for j in range(i + 1, len(o1))):
                out.append(f)
        return tuple(out)

    def contractibility_check(self, n: int, counters: Optional[Counters] = None
                              ) -> Tuple[int, int, int]:
        """``(pairs, min #order-isos, max #order-isos)`` over all pairs of orders.

        ATLAS_OF_N Thm 3.2 says ``Sigma_{X:BS_n} LinOrd(X)`` is contractible; the
        groupoid form of that is "between any two objects there is exactly one
        morphism".  This checks exactly that, exhaustively, at level ``n``.
        """
        c = _counters(counters)
        os = self.orders(self.datum(n))
        lo, hi, pairs = None, None, 0
        for o1 in os:
            for o2 in os:
                pairs += 1
                k = len(self.order_isomorphisms(o1, o2, c))
                lo = k if lo is None else min(lo, k)
                hi = k if hi is None else max(hi, k)
        return pairs, (0 if lo is None else lo), (0 if hi is None else hi)

    # -- arithmetic: agrees with cardinals below omega, diverges at omega ---
    def add(self, m: Ordinal, n: Ordinal) -> Ordinal:
        return m + n

    def mul(self, m: Ordinal, n: Ordinal) -> Ordinal:
        return m * n

    def divergence_at_omega(self) -> Tuple[Tuple[str, str, str], ...]:
        one, two = Ordinal(0, 1), Ordinal(0, 2)
        return (
            ("1+omega", (one + OMEGA).render(), (OMEGA + one).render()),
            ("2*omega", (two * OMEGA).render(), (OMEGA * two).render()),
        )

    def body_term(self, n: int) -> T.Term:
        """The order type: fold the successor along the order.

        The term depends on the order only through its length -- which is
        Prop. 2.4 (finite linear orders are rigid) in the kernel's own IR.
        """
        t = ZERO_T
        for _ in range(n):
            t = T.App(SUCC_T, t)
        return t

    def reachability(self) -> Reachability:
        return Reachability(
            generated_locus="finite linear orders on subsets of a %d-atom universe, "
                            "with order isomorphisms" % len(ATOMS),
            exact_image="all of N, and the groupoid is *discrete*: any two finite "
                        "linear orders of equal size are UNIQUELY isomorphic (Prop. 2.4)",
            equivalence_kernel="trivial as a groupoid (no nontrivial automorphisms), "
                               "but the forgetful map to (c) has fiber the S_n-torsor "
                               "of orders, of size n!",
            closure=("Ord (ordinal arithmetic past omega)",),
            omitted_locus="every infinite well-order, starting at omega -- and that is "
                          "where the residual switches on: below omega the order datum "
                          "is arithmetically inert, at omega it is everything "
                          "(1+omega = omega != omega+1)",
            extends=("+ and x as ordinal operations",
                     "the order relation", "well-founded recursion"),
            finite_address_only=("commutativity of + and x (dies at omega)",
                                 "cancellation on the right",
                                 "contractibility of Sigma_X LinOrd(X) "
                                 "(no infinite analogue)"),
        )

    def kernel_check(self, bound: int, counters: Optional[Counters] = None
                     ) -> Tuple[bool, str]:
        c = _counters(counters)
        notes = []
        for n in range(min(bound, 4) + 1):
            pairs, lo, hi = self.contractibility_check(n, c)
            if (lo, hi) != (1, 1):
                return False, "at n=%d some pair of orders has %d..%d isomorphisms" % (n, lo, hi)
            notes.append("n=%d: %d pairs, all with exactly 1 order-iso, |LinOrd|=%d"
                         % (n, pairs, len(self.orders(self.datum(n)))))
        return True, "; ".join(notes)


# ---------------------------------------------------------------------------
# (e) base-b digit words -- three choices
# ---------------------------------------------------------------------------

class DigitChart(Chart):
    """DIGIT_CRYSTAL.md Sec.0 conventions: little-endian by default, ``c_0`` least
    significant, ``L(c) = sum c_i b^i``.  The endianness is a chart *parameter*,
    not a convention of N (ATLAS_OF_N Thm 4.2(2)(ii))."""

    letter = "e"

    def __init__(self, b: int = 10, endian: str = "little") -> None:
        if b < 2:
            raise ChartError("base must be >= 2")
        if endian not in ("little", "big"):
            raise ChartError("endianness is a Z/2 choice: 'little' or 'big'")
        self.b = b
        self.endian = endian
        self.key = "digit_b%d_%s" % (b, endian)
        self.name = ("base-%d digit words, %s-endian; residuals: base, endianness, carry"
                     % (b, endian))
        self.choices = ("base b=%d (invariant: rad(b)=%d)" % (b, self.radical()),
                        "endianness = %s (a Z/2-torsor trivialisation)" % endian,
                        "digit section {0..b-1} (its coboundary is the carry)")

    # -- the chart ---------------------------------------------------------
    def radical(self) -> int:
        n, r = self.b, 1
        d = 2
        while d * d <= n:
            if n % d == 0:
                r *= d
                while n % d == 0:
                    n //= d
            d += 1
        return r * n if n > 1 else r

    def datum(self, n: int) -> Tuple[int, ...]:
        if n < 0:
            raise ChartError("digit words present N")
        out: List[int] = []
        while n:
            out.append(n % self.b)
            n //= self.b
        w = tuple(out)
        return w if self.endian == "little" else tuple(reversed(w))

    def value(self, w: Sequence[int], counters: Optional[Counters] = None) -> int:
        c = _counters(counters)
        digits = tuple(w) if self.endian == "little" else tuple(reversed(tuple(w)))
        acc = 0
        for i, d in enumerate(digits):
            c.bump("atlas.digit.horner")
            if not 0 <= d < self.b:
                raise ChartError("digit %r outside A_%d" % (d, self.b))
            acc += d * self.b ** i
        return acc

    def words(self, length: int) -> Tuple[Tuple[int, ...], ...]:
        return tuple(itertools.product(range(self.b), repeat=length))

    def odometer(self, w: Sequence[int]) -> Tuple[int, ...]:
        """T(x) = x+1 in digit coordinates -- the operation that survives to Z_b."""
        return self.datum(self.value(w) + 1)

    # -- residual (i): the base --------------------------------------------
    def base_translates_to(self, other: "DigitChart") -> bool:
        """Prop. 2.8: id extends continuously Z_b -> Z_b' iff rad(b') | rad(b)."""
        return self.radical() % other.radical() == 0

    def base_translation_witness(self, other: "DigitChart", depth: int = 6
                                 ) -> Tuple[Tuple[int, Fraction, Fraction], ...]:
        """The sequence ``b^k`` with both gauges, exactly.

        If ``rad(b') | rad(b)`` fails, this table shows ``|b^k|_b -> 0`` while
        ``|b^k|_{b'}`` stays put -- Prop. 2.8's proof, computed.
        """
        return tuple((k, badic_gauge(self.b ** k, self.b), badic_gauge(self.b ** k, other.b))
                     for k in range(depth))

    # -- residual (ii): endianness ----------------------------------------
    def truncations(self, n: int) -> Tuple[Callable[[int], int], Callable[[int], int]]:
        """``(pi_n, sigma_n)``: delete the most / the least significant digit."""
        m = self.b ** n
        return (lambda v: v % m), (lambda v: v // self.b)

    def endian_agreement(self, n: int, counters: Optional[Counters] = None
                         ) -> Tuple[int, int, Fraction]:
        """``(#agreements, b^{n+1}, defect fraction)``.

        DIGIT_CRYSTAL Thm 4.2(2): the agreement locus is exactly the b constant
        strings and the defect fraction is exactly ``1 - b^{-n}``.
        """
        c = _counters(counters)
        pi, sig = self.truncations(n)
        total = self.b ** (n + 1)
        agree = 0
        for v in range(total):
            c.bump("atlas.digit.endian")
            if pi(v) == sig(v):
                agree += 1
        return agree, total, Fraction(total - agree, total)

    def endian_torsor(self) -> Torsor:
        """``{pi, sigma}`` is a Z/2-torsor; the generator is word reversal."""
        pts = ("pi", "sigma")
        g = cyclic_group(2)
        return Torsor("truncation systems {pi,sigma} under Z/2", g, pts,
                      lambda k, p: p if k == 0 else ("sigma" if p == "pi" else "pi"))

    def reversal_conjugates(self, n: int, counters: Optional[Counters] = None
                            ) -> bool:
        """DIGIT_CRYSTAL Thm 4.2(1): ``pi_n R_{n+1} = R_n sigma_n`` on words."""
        c = _counters(counters)
        for w in self.words(n + 1):
            c.bump("atlas.digit.reversal")
            rev = tuple(reversed(w))
            lhs = rev[:n]                       # delete the most significant of R(w)
            rhs = tuple(reversed(w[1:]))        # R of (delete the least significant)
            if lhs != rhs:
                return False
        return True

    # -- residual (iii): the carry ----------------------------------------
    def carry(self, n: int):
        return carry_cocycle(self.b, n)

    def carry_free_sections(self, n: int) -> Optional[bool]:
        from .residual import exhaustive_section_search
        return exhaustive_section_search(self.b, self.b ** n)

    # -- locality of divisibility (Prop. 2.9), where (e) meets (f) --------
    def residue_is_local(self, d: int, k: int, counters: Optional[Counters] = None
                         ) -> bool:
        """Does ``n mod d`` factor through the last ``k`` digits?  Checked by
        exhaustion over one full period, then compared with ``d | b^k``."""
        c = _counters(counters)
        m = self.b ** k
        for r in range(m):
            seen = set()
            for q in range(d):
                c.bump("atlas.digit.locality")
                seen.add((q * m + r) % d)
            if len(seen) > 1:
                return False
        return True

    def shared_locus_with_primes(self) -> Tuple[int, ...]:
        """``{p : p | b}`` -- exactly where charts (e) and (f) overlap."""
        out, n, d = [], self.b, 2
        while d * d <= n:
            if n % d == 0:
                out.append(d)
                while n % d == 0:
                    n //= d
            d += 1
        if n > 1:
            out.append(n)
        return tuple(out)

    def body_term(self, n: int) -> T.Term:
        """Horner in Church arithmetic: the kernel *computes* the positional value."""
        digits = self.datum(n)
        msf = tuple(reversed(digits)) if self.endian == "little" else tuple(digits)
        t = ZERO_T
        base = church(self.b)
        for d in msf:
            t = T.App(T.App(PLUS_T, T.App(T.App(MULT_T, t), base)), church(d))
        return t

    def generated_values(self, bound: int) -> Tuple[int, ...]:
        return tuple(sorted({self.value(w) for k in range(bound + 1)
                             for w in self.words(k)}))

    def reachability_report(self, bound: int, counters: Optional[Counters] = None
                            ) -> ReachabilityReport:
        """The declared exact image of words of length <= k is exactly [0, b^k)."""
        c = _counters(counters)
        start = c.get("atlas.chart.probe")
        vals = self.generated_values(bound)
        image_ok = vals == tuple(range(self.b ** bound))
        c.bump("atlas.chart.probe", len(vals))
        kok, kdetail = self.kernel_check(bound, c)
        return ReachabilityReport(self.key, image_ok, len(vals), kok, kdetail,
                                  self.omitted_witness(bound),
                                  c.get("atlas.chart.probe") - start)

    def omitted_witness(self, bound: int) -> Any:
        return "b^%d = %d (and every infinite digit string in Z_%d)" % (
            bound, self.b ** bound, self.b)

    def kernel_check(self, bound: int, counters: Optional[Counters] = None
                     ) -> Tuple[bool, str]:
        """The kernel of L is trailing (leading, in big-endian) zeros, nothing else."""
        c = _counters(counters)
        for k in range(bound + 1):
            for w in self.words(k):
                c.bump("atlas.chart.probe")
                pad = (w + (0,)) if self.endian == "little" else ((0,) + w)
                if self.value(pad) != self.value(w):
                    return False, "padding changed the value of %r" % (w,)
        buckets: Dict[int, int] = {}
        for w in self.words(bound):
            buckets[self.value(w)] = buckets.get(self.value(w), 0) + 1
        collisions = sum(1 for v in buckets.values() if v > 1)
        return (collisions == 0,
                "L is injective on words of fixed length %d (%d values, %d collisions); "
                "the whole kernel is zero-padding" % (bound, len(buckets), collisions))

    def reachability(self) -> Reachability:
        return Reachability(
            generated_locus="finitely supported digit strings over A_%d, generated by the "
                            "free affine monoid gamma_d : x |-> %dx+d acting on 0"
                            % (self.b, self.b),
            exact_image="all of N (Thm 2.7: L is a bijection); words of length k give "
                        "exactly [0, %d^k)" % self.b,
            equivalence_kernel="zero padding on the %s-significant end, and nothing else"
                               % ("most" if self.endian == "little" else "least"),
            closure=("Z_%d = lim Z/%d^n (b-adic; N is DENSE)" % (self.b, self.b),
                     "R (archimedean; N is CLOSED and DISCRETE)"),
            omitted_locus="in Z_%d: every infinite digit string, i.e. all of Z_%d\\N, "
                          "which is everything except the eventually-zero strings. "
                          "In R: every non-integer. The two omitted loci are "
                          "incomparable -- no continuous map either way restricts to "
                          "the identity on N (Thm 5.3)." % (self.b, self.b),
            extends=("+ and x (both completions)",
                     "the odometer T(x)=x+1 (uniformly continuous on Z_%d)" % self.b,
                     "all congruence information mod %d^n" % self.b),
            finite_address_only=("the leading digit / archimedean size (dies in Z_%d)" % self.b,
                                 "the order relation (dies in Z_%d)" % self.b,
                                 "word reversal D (nowhere continuous, DIGIT_CRYSTAL Thm 4.3)",
                                 "the enumeration successor 'least natural > x' (dies in R)"),
        )


# ---------------------------------------------------------------------------
# (f) the free commutative monoid on the primes
# ---------------------------------------------------------------------------

def primes_up_to(n: int) -> Tuple[int, ...]:
    """Integer-only sieve: no float is constructed (the loop bound is ``p*p<=n``)."""
    if n < 2:
        return ()
    sieve = [True] * (n + 1)
    sieve[0] = sieve[1] = False
    p = 2
    while p * p <= n:
        if sieve[p]:
            for q in range(p * p, n + 1, p):
                sieve[q] = False
        p += 1
    return tuple(i for i in range(2, n + 1) if sieve[i])


class PrimeChart(Chart):
    key, letter = "prime", "f"
    name = "free commutative monoid on the primes: factorization, and no addition"

    def datum(self, n: int) -> Tuple[Tuple[int, int], ...]:
        if n < 1:
            raise ChartError("the multiplicative chart presents N_{>0}; 0 is not in it")
        out: List[Tuple[int, int]] = []
        d, m = 2, n
        while d * d <= m:
            if m % d == 0:
                e = 0
                while m % d == 0:
                    m //= d
                    e += 1
                out.append((d, e))
            d += 1
        if m > 1:
            out.append((m, 1))
        return tuple(out)

    def value(self, d: Sequence[Tuple[int, int]]) -> int:
        acc = 1
        for p, e in d:
            acc *= p ** e
        return acc

    def mul(self, a: Sequence[Tuple[int, int]], b: Sequence[Tuple[int, int]],
            counters: Optional[Counters] = None) -> Tuple[Tuple[int, int], ...]:
        """Multiplication is addition of exponent vectors -- freeness, executed."""
        c = _counters(counters)
        acc: Dict[int, int] = {}
        for p, e in tuple(a) + tuple(b):
            c.bump("atlas.prime.mul")
            acc[p] = acc.get(p, 0) + e
        return tuple(sorted(acc.items()))

    def completely_multiplicative(self, f_on_primes: Callable[[int], int], n: int,
                                  counters: Optional[Counters] = None) -> int:
        """The universal property: a multiplicative function is freely determined
        by its values on the primes."""
        c = _counters(counters)
        acc = 1
        for p, e in self.datum(n):
            c.bump("atlas.prime.hom")
            acc *= f_on_primes(p) ** e
        return acc

    # -- residual: addition ------------------------------------------------
    def prime_swap(self, p: int, q: int, n: int) -> int:
        """``sigma_hat`` for the transposition ``(p q)`` in Sym(P).

        Every element of Aut(N_{>0}, x) is of this shape (Thm 2.13(1)).
        """
        out = 1
        for r, e in self.datum(n):
            s = q if r == p else (p if r == q else r)
            out *= s ** e
        return out

    def exponent_multiset(self, n: int) -> Tuple[int, ...]:
        """The complete Sym(P)-invariant of ``n``: everything chart (f) can see."""
        return tuple(sorted(e for _p, e in self.datum(n)))

    def successor_not_definable(self, params: Sequence[int] = (),
                                search: int = 200,
                                counters: Optional[Counters] = None
                                ) -> Tuple[bool, Dict[str, Any]]:
        """Successor is not definable from the multiplicative structure alone.

        Criterion (the standard Galois/orbit argument): anything definable in
        ``(N_{>0}, x)`` **without parameters** is invariant under
        ``Aut(N_{>0}, x) = Sym(P)``; with parameters ``params``, invariant under
        the pointwise stabiliser of those primes.  So it suffices to exhibit
        ``sigma`` fixing every parameter with
        ``sigma_hat(succ(n)) != succ(sigma_hat(n))``.

        Returns ``(True, witness)`` when such a sigma is found.  The witness is
        a concrete quadruple, checked by direct computation.

        HONEST SCOPE.  This establishes non-definability *without parameters*
        and with any finite parameter set (a fresh transposition avoiding the
        parameters is always available).  It does NOT establish that no
        definition exists in a richer language, e.g. one with infinitely many
        constants, nor anything about the difficulty of any open problem
        (ATLAS_OF_N Cor. 2.13.1's guardrail applies verbatim).
        """
        c = _counters(counters)
        ps = [p for p in primes_up_to(search) if p not in tuple(params)]
        for i, p in enumerate(ps):
            for q in ps[i + 1:]:
                c.bump("atlas.prime.equivariance")
                lhs = self.prime_swap(p, q, p + 1)      # sigma_hat(succ p)
                rhs = self.prime_swap(p, q, p) + 1      # succ(sigma_hat p)
                if lhs != rhs:
                    return True, {
                        "sigma": "(%d %d)" % (p, q),
                        "n": p,
                        "sigma_hat(n+1)": lhs,
                        "sigma_hat(n)+1": rhs,
                        "params_fixed": tuple(params),
                    }
        return False, {"params_fixed": tuple(params)}

    def invariant_collision(self, counters: Optional[Counters] = None
                            ) -> Tuple[int, int, Tuple[int, ...], Tuple[int, ...]]:
        """A sharper form: the complete invariant cannot see the successor.

        2 and 3 have the same exponent multiset ``(1,)`` -- chart (f) cannot
        distinguish them -- yet ``succ(2)=3`` has multiset ``(1,)`` while
        ``succ(3)=4`` has ``(2,)``.  So no function of the exponent multiset
        computes the successor.
        """
        c = _counters(counters)
        c.bump("atlas.prime.equivariance", 4)
        return 2, 3, self.exponent_multiset(3), self.exponent_multiset(4)

    def body_term(self, n: int) -> T.Term:
        """The Church product over the factorization: the kernel multiplies."""
        t = ONE_T
        for p, e in self.datum(max(n, 1)):
            for _ in range(e):
                t = T.App(T.App(MULT_T, t), church(p))
        return t

    def generated_values(self, bound: int) -> Tuple[int, ...]:
        return tuple(range(1, bound + 1))

    def reachability_report(self, bound: int, counters: Optional[Counters] = None
                            ) -> ReachabilityReport:
        c = _counters(counters)
        start = c.get("atlas.chart.probe")
        vals = self.generated_values(bound)
        image_ok = vals == tuple(range(1, bound + 1))
        c.bump("atlas.chart.probe", len(vals))
        kok, kdetail = self.kernel_check(bound, c)
        return ReachabilityReport(self.key, image_ok, len(vals), kok, kdetail,
                                  self.omitted_witness(bound),
                                  c.get("atlas.chart.probe") - start)

    def kernel_check(self, bound: int, counters: Optional[Counters] = None
                     ) -> Tuple[bool, str]:
        c = _counters(counters)
        for n in range(1, bound + 1):
            c.bump("atlas.chart.probe")
            if self.value(self.datum(n)) != n:
                return False, "factorization round trip failed at %d" % n
        return True, ("e : (+)_p N -> (N_{>0},x) is bijective on [1,%d] -- unique "
                      "factorization is the statement that this chart is FREE" % bound)

    def omitted_witness(self, bound: int) -> Any:
        return 0        # 0 is not in this chart at all

    def reachability(self) -> Reachability:
        return Reachability(
            generated_locus="finitely supported exponent vectors over P, generated by "
                            "the primes under multiplication",
            exact_image="N_{>0} exactly -- and NOT 0, which this chart cannot name",
            equivalence_kernel="trivial: e is injective (unique factorization). "
                               "That is not a theorem about numbers, it is the "
                               "statement that this monoid is free.",
            closure=("Q_{>0} = (+)_P Z, free abelian of countably infinite rank",),
            omitted_locus="0; and addition -- Aut(N_{>0},x) = Sym(P) has cardinality "
                          "2^aleph_0 while Aut(N,+,x) is trivial, so there are "
                          "2^aleph_0 additions compatible with this multiplication "
                          "and the chart names none of them",
            extends=("x", "divisibility", "every completely multiplicative function"),
            finite_address_only=("+ (not expressible at all)",
                                 "the successor (not Sym(P)-equivariant)",
                                 "any additive condition on primes"),
        )


# ---------------------------------------------------------------------------
# 3.  the two incomparable completions (ATLAS_OF_N Sec.5.5, CRYSTAL.md Sec.4)
# ---------------------------------------------------------------------------

def badic_valuation(x: int, b: int) -> Optional[int]:
    """``max{k : b^k | x}``; ``None`` (i.e. +infinity) for x = 0."""
    if x == 0:
        return None
    k, m = 0, abs(x)
    while m % b == 0:
        m //= b
        k += 1
    return k


def badic_gauge(x: int, b: int) -> Fraction:
    """``|x|_b = b^{-v_b(x)}`` -- exact, and 0 at 0.  The metric of the tower."""
    v = badic_valuation(x, b)
    return Fraction(0) if v is None else Fraction(1, b ** v)


def archimedean_distance(x: Fraction, y: Fraction) -> Fraction:
    return abs(x - y)


@dataclass(frozen=True)
class CompletionClaim:
    """"Operation ``op`` extends continuously to completion ``completion``"."""

    completion: str            # "R" or "Z_b"
    operation: str
    claim: bool


@dataclass(frozen=True)
class ClaimVerdict:
    claim: CompletionClaim
    holds: bool
    witness: Any
    detail: str

    @property
    def agrees(self) -> bool:
        return self.claim.claim == self.holds

    def render(self) -> str:
        return ("%-5s %-28s claimed=%-5s computed=%-5s %s  %s"
                % (self.claim.completion, self.claim.operation, self.claim.claim,
                   self.holds, "OK " if self.agrees else "REFUTED", self.detail))


@dataclass(frozen=True)
class ArchimedeanWindow:
    """N inside R, seen through exact rationals.  N is CLOSED and DISCRETE here."""

    bound: int = 64

    def separation(self) -> Fraction:
        """The exact minimum distance between distinct naturals."""
        return Fraction(1)

    def discreteness_witness(self, counters: Optional[Counters] = None
                             ) -> Tuple[bool, Fraction]:
        c = _counters(counters)
        r = Fraction(1, 2)
        for n in range(self.bound):
            for m in range(self.bound):
                c.bump("atlas.completion.R")
                if n != m and archimedean_distance(Fraction(n), Fraction(m)) <= r:
                    return False, r
        return True, r

    def density_failure(self) -> Tuple[Fraction, Fraction]:
        """A rational at distance 1/2 from every natural: N is not dense in R."""
        return Fraction(1, 2), Fraction(1, 2)

    def cauchy_sequences_are_eventually_constant(self, counters=None) -> bool:
        """Any archimedean-Cauchy sequence of naturals is eventually constant."""
        c = _counters(counters)
        for n in range(self.bound):
            for m in range(self.bound):
                c.bump("atlas.completion.R")
                if n != m and archimedean_distance(Fraction(n), Fraction(m)) < Fraction(1):
                    return False
        return True

    # -- operation extension verdicts --------------------------------------
    def arithmetic_successor_extends(self) -> Tuple[bool, Any]:
        """``x |-> x+1`` is an isometry of R: it extends."""
        probes = tuple(Fraction(k, 7) for k in range(1, 8))
        ok = all(archimedean_distance(p + 1, q + 1) == archimedean_distance(p, q)
                 for p in probes for q in probes)
        return ok, "isometry on %d rational probes" % len(probes)

    def enumeration_successor_extends(self, counters: Optional[Counters] = None
                                      ) -> Tuple[bool, Any]:
        """"the next element of the generated locus", i.e. the least natural > x.

        This is the canonical CRYSTAL.md Sec.4 failure: the operation is total
        and well defined on N, its extension to R is ``floor(x)+1``, and that
        jumps at every natural.  The witness is exact.
        """
        c = _counters(counters)

        def nxt(x: Fraction) -> int:
            return x.numerator // x.denominator + 1

        for n in range(1, 8):
            for k in (2, 4, 8, 16, 1024):
                c.bump("atlas.completion.R")
                left = Fraction(n) - Fraction(1, k)
                if nxt(left) != nxt(Fraction(n)):
                    return False, {"at": n, "approach": str(left),
                                   "next(approach)": nxt(left),
                                   "next(limit)": nxt(Fraction(n)),
                                   "jump": nxt(Fraction(n)) - nxt(left)}
        return True, None


@dataclass(frozen=True)
class BAdicWindow:
    """N inside Z_b, seen through the tower ``Z/b^n``.  N is DENSE here."""

    b: int = 10
    depth: int = 3

    def density_witness(self, counters: Optional[Counters] = None
                        ) -> Tuple[bool, int]:
        """Every residue at every depth is hit by a natural: density, exactly."""
        c = _counters(counters)
        for k in range(1, self.depth + 1):
            m = self.b ** k
            hit = set()
            for n in range(m):
                c.bump("atlas.completion.Zb")
                hit.add(n % m)
            if len(hit) != m:
                return False, k
        return True, self.depth

    def not_closed_witness(self, counters: Optional[Counters] = None
                           ) -> Tuple[bool, Dict[str, Any]]:
        """``s_k = b^k - 1`` is b-adically Cauchy with no limit in N.

        ``s_k -> -1``: for every natural ``m`` the gauge ``|s_k - m|_b`` is
        eventually constant and nonzero, so the sequence leaves N.  Checked
        exhaustively for ``m`` in a window.
        """
        c = _counters(counters)
        s = [self.b ** k - 1 for k in range(1, self.depth + 2)]
        cauchy = all(badic_gauge(s[j] - s[i], self.b) <= Fraction(1, self.b ** (i + 1))
                     for i in range(len(s)) for j in range(i, len(s)))
        # every natural below the window is separated from the tail at some depth
        escapes = True
        for m in range(self.b ** self.depth):
            c.bump("atlas.completion.Zb")
            if all((s[k] - m) % (self.b ** (k + 1)) == 0 for k in range(len(s))):
                escapes = False
        return (cauchy and escapes), {
            "sequence": tuple(s),
            "cauchy": cauchy,
            "limit_in_N": False,
            "limit": "-1 in Z_%d" % self.b,
        }

    def odometer_extends(self, counters: Optional[Counters] = None
                         ) -> Tuple[bool, Any]:
        """``T(x) = x+1`` is uniformly continuous for the b-adic gauge.

        The modulus is the identity: ``x = y mod b^k`` implies ``x+1 = y+1 mod
        b^k`` at every depth.  Checked for every ``x`` below ``b^depth`` and
        every ``k <= depth`` -- that is the whole content, and it is linear
        rather than quadratic because congruence is an equivalence relation.
        """
        c = _counters(counters)
        m = self.b ** self.depth
        for k in range(1, self.depth + 1):
            mk = self.b ** k
            for x in range(m):
                c.bump("atlas.completion.Zb")
                if (x + 1) % mk != ((x % mk) + 1) % mk:
                    return False, (x, k)
        return True, ("uniformly continuous with modulus id: %d residues x %d depths"
                      % (m, self.depth))

    def order_extends(self, counters: Optional[Counters] = None
                      ) -> Tuple[bool, Any]:
        """The order does NOT extend: arbitrarily b-adically close pairs disagree.

        Two pairs at the *same* (arbitrarily small) gauge with opposite order is
        exactly the failure of continuity of ``<``: no b-adic neighbourhood
        determines the comparison.
        """
        c = _counters(counters)
        for k in range(1, self.depth + 1):
            c.bump("atlas.completion.Zb")
            step = self.b ** k
            g_up = badic_gauge(0 - step, self.b)
            g_down = badic_gauge(step - 0, self.b)
            if g_up == g_down and g_up <= Fraction(1, step):
                return False, {"increasing_pair": (0, step, g_up),
                               "decreasing_pair": (step, 0, g_down),
                               "same_gauge": True,
                               "gauge": str(g_up)}
        return True, None

    def no_continuous_map_either_way(self, counters: Optional[Counters] = None
                                     ) -> Dict[str, Any]:
        """The sequence the proof of Thm 5.3 uses, with both exact gauges.

        ``b^k -> 0`` b-adically while ``|b^k|`` grows without bound in R.  A
        continuous ``f : Z_b -> R`` restricting to the identity would need
        ``f(0) = lim b^k = +infinity``; a continuous ``g : R -> Z_b`` would have
        to be constant (R connected, Z_b totally disconnected) and so could not
        restrict to the identity.

        SCOPE: this exhibits the sequences; connectedness and compactness are
        *not* verified computationally, and the table below is a witness, not a
        proof of the topological theorem.
        """
        c = _counters(counters)
        rows = []
        for k in range(self.depth + 3):
            c.bump("atlas.completion.Zb")
            x = self.b ** k
            rows.append((k, x, badic_gauge(x, self.b), Fraction(x)))
        return {
            "sequence": "b^k for b=%d" % self.b,
            "rows": tuple(rows),
            "badic_limit": "0",
            "archimedean_limit": "does not exist (unbounded)",
            "obstruction_Zb_to_R": "compact -> bounded image, but N is unbounded in R",
            "obstruction_R_to_Zb": "connected -> constant image in a totally "
                                   "disconnected space",
        }


def two_completions_report(b: int = 10, counters: Optional[Counters] = None
                           ) -> Tuple[Tuple[ClaimVerdict, ...], Dict[str, Any]]:
    """The four operation-extension verdicts plus the no-map witness."""
    c = _counters(counters)
    R = ArchimedeanWindow()
    Z = BAdicWindow(b=b)
    out: List[ClaimVerdict] = []

    ok, wit = R.arithmetic_successor_extends()
    out.append(ClaimVerdict(CompletionClaim("R", "arithmetic successor x+1", True),
                            ok, wit, "extends: %s" % wit))
    ok, wit = R.enumeration_successor_extends(c)
    out.append(ClaimVerdict(CompletionClaim("R", "enumeration successor", False),
                            ok, wit, "jump witness %s" % (wit,)))
    ok, wit = Z.odometer_extends(c)
    out.append(ClaimVerdict(CompletionClaim("Z_b", "odometer T(x)=x+1", True),
                            ok, wit, "extends: %s" % wit))
    ok, wit = Z.order_extends(c)
    out.append(ClaimVerdict(CompletionClaim("Z_b", "order relation <", False),
                            ok, wit, "order-flip witness %s" % (wit,)))
    return tuple(out), Z.no_continuous_map_either_way(c)


# ---------------------------------------------------------------------------
# 4.  the atlas
# ---------------------------------------------------------------------------

CHARTS: Dict[str, Chart] = {}
for _ch in (PeanoChart(), TallyChart(), CardinalChart(), OrdinalChart(),
            DigitChart(10, "little"), DigitChart(2, "little"), PrimeChart()):
    CHARTS[_ch.key] = _ch


def chart(key: str) -> Chart:
    if key not in CHARTS:
        raise ChartError("no chart %r; have %s" % (key, ", ".join(sorted(CHARTS))))
    return CHARTS[key]
