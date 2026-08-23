"""The proved-capability record: what the runtime stores instead of a theorem.

CRYSTAL.md Sec.L3 says a proved fact *becomes* executable content.  A runtime
that honours that cannot store ``B`` when it proves ``A ==> B``; storing a
sentence is storing the shadow of the capability.  What it stores is a
**six-part package**, and every part is a real object that runs:

    recognizer          decides whether an incoming construction is an
                        instance of ``A``, and reports its exact matching cost
    transformer         produces the ``B``-instance from the ``A``-instance
    witness_producer    emits a proof object for *this* instance
    witness_checker     validates that object independently -- it must route
                        through ``kernel/check.py`` and must never consult the
                        producer's bookkeeping
    boundary            the exact hypotheses / side conditions outside which
                        the package refuses to fire
    cost                the cost-vector effect of firing it

A package missing any part is **unusable by construction**: the six fields have
no defaults, so omitting one is a ``TypeError`` from Python itself, and a part
that is present but is a label rather than a runnable object raises
``IncompletePackage``, which *is* a ``TypeError``.  There is no "incomplete but
flagged" state to install.

THE FORBIDDEN FOURTH (CRYSTAL.md Sec.5, "no candidate may rewrite the kernel
that judges it").  A package may extend what the runtime can **do**.  It may
never alter what the runtime **accepts as true**.  Three mechanisms enforce it,
in increasing order of paranoia:

  1. packages are handed a ``SealedContext``, whose ``declare_axiom`` and
     ``declare_certificate`` raise ``TrustViolation``;
  2. the axiom and certificate dictionaries are exposed only as
     ``MappingProxyType``, so item assignment raises;
  3. every install and every firing runs inside ``trust_guard``, which
     fingerprints the trust dictionaries **and the code objects of the
     checker's own functions** before and after.  Anything that gets past (1)
     and (2) -- reaching a private attribute, monkeypatching
     ``check.check_path`` -- moves the fingerprint and raises.

Pure Python 3 stdlib, CPU only, exact integers, no floats, no randomness, no
network.  Every observable iteration is over ``sorted()`` or an
insertion-ordered tuple, so output is byte-identical across ``PYTHONHASHSEED``.
"""

from __future__ import annotations

import hashlib
from dataclasses import dataclass, field
from types import MappingProxyType
from typing import Any, Callable, Dict, Optional, Sequence, Tuple

from ..kernel import check as C
from ..kernel import edges as E
from ..kernel import term as T

__all__ = [
    "CapabilityError", "IncompletePackage", "BoundaryViolation",
    "TrustViolation", "CheckerDisagreement",
    "NO_OBJECT", "NoObject",
    "CostVector", "CostEffect", "Ledger",
    "Obligation", "Witness",
    "Instance", "Recognizer", "Transformer", "WitnessProducer",
    "WitnessChecker", "Condition", "ApplicationBoundary", "BoundaryVerdict",
    "ProvedCapability", "PARTS",
    "SealedContext", "TrustFingerprint", "trust_guard",
    "kernel_verdict", "kernel_witness_checker",
    "Firing", "Refusal", "CapabilityRuntime",
]


# --------------------------------------------------------------------------
# errors
# --------------------------------------------------------------------------

class CapabilityError(Exception):
    """Base class for everything this layer refuses to do."""


class IncompletePackage(CapabilityError, TypeError):
    """A package is missing a part, or a part is a label rather than an object.

    Deliberately a ``TypeError``: installing an incomplete package is not a
    policy violation to be reported, it is a type error at construction.
    """


class BoundaryViolation(CapabilityError):
    """A capability was fired outside its declared application boundary."""


class TrustViolation(CapabilityError):
    """A capability tried to widen what the runtime accepts as true."""


class CheckerDisagreement(CapabilityError):
    """A package's witness checker disagreed with ``kernel/check.py``."""


# --------------------------------------------------------------------------
# the sentinel for "this theorem produces no object"
# --------------------------------------------------------------------------

class NoObject:
    """Returned by the transformer of a capability with no constructive content.

    A classical existence proof is not a program.  The runtime needs a value
    that says so *in the type of the answer*, so that a caller cannot mistake
    "no object" for "an object I have not looked at yet".
    """

    __slots__ = ()
    _instance: Optional["NoObject"] = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __repr__(self) -> str:
        return "NO_OBJECT"

    def __bool__(self) -> bool:
        return False


NO_OBJECT = NoObject()


# --------------------------------------------------------------------------
# cost
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class CostVector:
    """Four exact integer components.  No scalar fitness anywhere.

    ``steps``   kernel proof steps emitted (the CRYSTAL.md Sec.0 counter)
    ``checks``  ``check.step`` calls the trusted checker actually made
    ``search``  candidate / match / node-visit attempts
    ``store``   table entries built or consulted
    """

    steps: int = 0
    checks: int = 0
    search: int = 0
    store: int = 0

    def __post_init__(self) -> None:
        for f in ("steps", "checks", "search", "store"):
            v = getattr(self, f)
            if isinstance(v, bool) or not isinstance(v, int):
                raise CapabilityError("cost component %s must be an exact int" % f)

    def __add__(self, other: "CostVector") -> "CostVector":
        return CostVector(self.steps + other.steps, self.checks + other.checks,
                          self.search + other.search, self.store + other.store)

    def __sub__(self, other: "CostVector") -> "CostVector":
        return CostVector(self.steps - other.steps, self.checks - other.checks,
                          self.search - other.search, self.store - other.store)

    def components(self) -> Tuple[int, int, int, int]:
        return (self.steps, self.checks, self.search, self.store)

    def render(self) -> str:
        return "steps=%d checks=%d search=%d store=%d" % self.components()


@dataclass(frozen=True)
class CostEffect:
    """The cost-vector effect of firing the package, per use.

    ``delta`` is signed: negative components are savings.  ``basis`` says how
    the number was arrived at -- "measured" means a counter produced it,
    "declared" means a human asserted it and ``justification`` must say why.
    """

    delta: CostVector
    basis: str = "measured"
    justification: str = ""

    def __post_init__(self) -> None:
        if not isinstance(self.delta, CostVector):
            raise IncompletePackage("cost effect needs a CostVector, got %r"
                                    % (type(self.delta).__name__,))
        if self.basis not in ("measured", "declared"):
            raise CapabilityError("cost basis must be 'measured' or 'declared'")
        if self.basis == "declared" and not self.justification.strip():
            raise CapabilityError("a declared cost effect needs a justification")

    def render(self) -> str:
        return "%s [%s]" % (self.delta.render(), self.basis)


class Ledger:
    """A mutable exact counter handed to every part of a package.

    Parts bump it; the runtime reads it.  Nothing here is a float and nothing
    is sampled: two runs of the same firing produce the same ledger.
    """

    __slots__ = ("_c",)

    def __init__(self) -> None:
        self._c: Dict[str, int] = {}

    def bump(self, key: str, n: int = 1) -> None:
        if isinstance(n, bool) or not isinstance(n, int):
            raise CapabilityError("ledger increments must be exact ints")
        self._c[key] = self._c.get(key, 0) + n

    def get(self, key: str) -> int:
        return self._c.get(key, 0)

    def snapshot(self) -> Tuple[Tuple[str, int], ...]:
        return tuple(sorted(self._c.items()))

    def vector(self) -> CostVector:
        return CostVector(self.get("steps"), self.get("checks"),
                          self.get("search"), self.get("store"))

    def render(self) -> str:
        return " ".join("%s=%d" % kv for kv in self.snapshot())


# --------------------------------------------------------------------------
# witnesses
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class Obligation:
    """One equality the kernel must verify: ``src = dst`` along ``path``."""

    label: str
    src: str
    dst: str
    path: Tuple[C.Step, ...]

    def digest(self) -> str:
        h = hashlib.blake2b(digest_size=16)
        h.update(self.label.encode("utf-8"))
        h.update(self.src.encode("ascii"))
        h.update(self.dst.encode("ascii"))
        for s in self.path:
            h.update(("%s|%s|%s|%r;" % (s.kind, s.src, s.dst, s.witness)).encode("utf-8"))
        return h.hexdigest()


@dataclass(frozen=True)
class Witness:
    """The proof object a package emits for one firing.

    ``obligations``  equalities the trusted checker verifies, one by one.
    ``edges``        L1 edges the trusted checker verifies with ``check_edge``.
    ``outside``      claims decided *outside* the kernel, each paired with the
                     justification that makes that legitimate.  An unjustified
                     outside claim is refused at construction: this field is
                     where a runtime would otherwise launder an assumption.
    """

    obligations: Tuple[Obligation, ...] = ()
    edges: Tuple[E.Edge, ...] = ()
    outside: Tuple[Tuple[str, str], ...] = ()
    note: str = ""

    def __post_init__(self) -> None:
        for claim, why in self.outside:
            if not str(why).strip():
                raise CapabilityError(
                    "outside-kernel claim %r carries no justification" % (claim,))
        if not self.obligations and not self.edges:
            raise CapabilityError(
                "a witness with neither an obligation nor an edge gives the "
                "kernel nothing to check")

    def digest(self) -> str:
        h = hashlib.blake2b(digest_size=16)
        for o in self.obligations:
            h.update(o.digest().encode("ascii"))
        for e in self.edges:
            h.update(("%s|%s|%s|%s;" % (e.kind, e.src, e.dst, e.edge_id)).encode("utf-8"))
        for claim, why in self.outside:
            h.update(("%s=%s;" % (claim, why)).encode("utf-8"))
        return h.hexdigest()

    def mutants(self) -> Tuple["Witness", ...]:
        """Corruptions of this witness that any real checker must reject.

        Used by ``classify`` to *compute*, rather than assume, that a package's
        witness checker is actually consulting the kernel.  A checker that
        accepts one of these is trusting its producer.
        """
        out = []
        if self.obligations:
            first = self.obligations[0]
            if first.src != first.dst:
                out.append(Witness(
                    (Obligation(first.label + "/swapped-endpoint", first.src,
                                first.src, first.path),) + self.obligations[1:],
                    self.edges, self.outside, self.note + " [mutant: endpoint]"))
            out.append(Witness(
                (Obligation(first.label + "/emptied", first.src, first.dst, ()),)
                + self.obligations[1:],
                self.edges, self.outside, self.note + " [mutant: empty path]"))
        if self.edges:
            e = self.edges[0]
            forged = E.Edge(kind=e.kind, src=e.src, dst=e.dst, eps=e.eps,
                            pairing=e.pairing,
                            witness=C.Certificate("%no-such-certificate%"),
                            label=e.label, provenance=e.provenance)
            out.append(Witness(self.obligations, (forged,) + self.edges[1:],
                               self.outside, self.note + " [mutant: certificate]"))
        return tuple(out)


# --------------------------------------------------------------------------
# the six parts
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class Instance:
    """What a recognizer returns: matched or not, with the exact matching cost."""

    matched: bool
    data: Any = None
    cost: int = 0
    note: str = ""

    def __post_init__(self) -> None:
        if isinstance(self.cost, bool) or not isinstance(self.cost, int):
            raise CapabilityError("matching cost must be an exact int")
        if self.cost < 0:
            raise CapabilityError("matching cost may not be negative")


def _require_callable(part: str, obj: Any, arity: int) -> None:
    if not callable(obj):
        raise IncompletePackage(
            "%s is %r, which is a label rather than a runnable object"
            % (part, obj))
    code = getattr(obj, "__code__", None)
    if code is not None and not (code.co_flags & 0x04):     # no *args
        n = code.co_argcount
        if hasattr(obj, "__self__"):
            n -= 0
        if n != arity:
            raise IncompletePackage(
                "%s must take %d arguments, %r takes %d"
                % (part, arity, getattr(obj, "__name__", obj), n))


@dataclass(frozen=True)
class Recognizer:
    """Decides whether an incoming construction is an instance of ``A``.

    ``decide(subject, task, ctx, ledger) -> Instance``.  The instance carries
    the exact matching cost, so a recognizer that buys its hit rate with an
    expensive search cannot hide the bill.
    """

    name: str
    decide: Callable[[Any, Any, "SealedContext", Ledger], Instance]
    domain: str = ""

    def __post_init__(self) -> None:
        _require_callable("recognizer.decide", self.decide, 4)

    def recognize(self, subject: Any, task: Any, ctx: "SealedContext",
                  ledger: Ledger) -> Instance:
        inst = self.decide(subject, task, ctx, ledger)
        if not isinstance(inst, Instance):
            raise IncompletePackage("recognizer %s returned %r, not an Instance"
                                    % (self.name, type(inst).__name__))
        ledger.bump("search", inst.cost)
        return inst


@dataclass(frozen=True)
class Transformer:
    """Produces the ``B``-instance from the ``A``-instance.

    ``run(instance, ctx, ledger) -> object`` -- or ``NO_OBJECT`` when the
    theorem has no constructive content.
    """

    name: str
    run: Callable[[Instance, "SealedContext", Ledger], Any]
    produces: str = ""

    def __post_init__(self) -> None:
        _require_callable("transformer.run", self.run, 3)

    def apply(self, inst: Instance, ctx: "SealedContext", ledger: Ledger) -> Any:
        return self.run(inst, ctx, ledger)


@dataclass(frozen=True)
class WitnessProducer:
    """Emits a proof object for *this* instance.

    ``emit(instance, output, ctx, ledger) -> Witness``.
    """

    name: str
    emit: Callable[[Instance, Any, "SealedContext", Ledger], Witness]

    def __post_init__(self) -> None:
        _require_callable("witness_producer.emit", self.emit, 4)

    def produce(self, inst: Instance, output: Any, ctx: "SealedContext",
                ledger: Ledger) -> Witness:
        w = self.emit(inst, output, ctx, ledger)
        if not isinstance(w, Witness):
            raise IncompletePackage("witness producer %s returned %r, not a Witness"
                                    % (self.name, type(w).__name__))
        return w


@dataclass(frozen=True)
class WitnessChecker:
    """Validates the witness independently of the producer.

    ``verify(witness, ctx, ledger) -> bool``.  ``routes_through_kernel`` is a
    *claim*; it is not believed.  ``CapabilityRuntime.fire`` adjudicates every
    witness with ``kernel_verdict`` and raises ``CheckerDisagreement`` if the
    two verdicts differ, and ``classify`` separately feeds the checker
    deliberately corrupted witnesses.  Use ``kernel_witness_checker()`` unless
    you are writing the planted-false control.
    """

    name: str
    verify: Callable[[Witness, "SealedContext", Ledger], bool]
    routes_through_kernel: bool = True

    def __post_init__(self) -> None:
        _require_callable("witness_checker.verify", self.verify, 3)

    def check(self, w: Witness, ctx: "SealedContext", ledger: Ledger) -> bool:
        v = self.verify(w, ctx, ledger)
        if not isinstance(v, bool):
            raise IncompletePackage("witness checker %s returned %r, not a bool"
                                    % (self.name, type(v).__name__))
        return v


@dataclass(frozen=True)
class Condition:
    """One side condition.  ``test(subject, task, ctx) -> bool``."""

    name: str
    test: Callable[[Any, Any, "SealedContext"], bool]
    because: str

    def __post_init__(self) -> None:
        _require_callable("condition.test", self.test, 3)
        if not self.because.strip():
            raise IncompletePackage(
                "side condition %r does not say why it exists" % (self.name,))


@dataclass(frozen=True)
class BoundaryVerdict:
    ok: bool
    failed: Tuple[str, ...] = ()
    reason: str = ""
    cost: int = 0


@dataclass(frozen=True)
class ApplicationBoundary:
    """The exact hypotheses outside which the package must refuse to fire.

    An empty boundary is refused: a package that never refuses has not stated
    its hypotheses, it has hidden them.
    """

    name: str
    conditions: Tuple[Condition, ...]
    statement: str = ""

    def __post_init__(self) -> None:
        if not isinstance(self.conditions, tuple) or not self.conditions:
            raise IncompletePackage(
                "application boundary %r has no conditions; a package that "
                "cannot refuse has no boundary" % (self.name,))
        for c in self.conditions:
            if not isinstance(c, Condition):
                raise IncompletePackage(
                    "boundary condition %r is not a Condition" % (c,))

    def evaluate(self, subject: Any, task: Any,
                 ctx: "SealedContext") -> BoundaryVerdict:
        failed = []
        for c in self.conditions:
            if not c.test(subject, task, ctx):
                failed.append(c.name)
        if failed:
            why = "; ".join(c.because for c in self.conditions
                            if c.name in failed)
            return BoundaryVerdict(False, tuple(failed), why, len(self.conditions))
        return BoundaryVerdict(True, (), "", len(self.conditions))


PARTS = ("recognizer", "transformer", "witness_producer", "witness_checker",
         "boundary", "cost")

_PART_TYPES = {
    "recognizer": Recognizer,
    "transformer": Transformer,
    "witness_producer": WitnessProducer,
    "witness_checker": WitnessChecker,
    "boundary": ApplicationBoundary,
    "cost": CostEffect,
}


@dataclass(frozen=True)
class ProvedCapability:
    """What the runtime stores when ``A ==> B`` is proved.

    The six parts have **no defaults**.  Constructing one without them is a
    ``TypeError`` raised by Python before any of this code runs; constructing
    one with a label in a part's place is an ``IncompletePackage``, which is
    also a ``TypeError``.  There is no third state.
    """

    name: str
    statement: str
    capability_class: str
    recognizer: Recognizer
    transformer: Transformer
    witness_producer: WitnessProducer
    witness_checker: WitnessChecker
    boundary: ApplicationBoundary
    cost: CostEffect
    classification: Any = None
    provenance: str = ""

    def __post_init__(self) -> None:
        if not self.name.strip():
            raise IncompletePackage("a package must be named")
        for p in PARTS:
            got = getattr(self, p)
            if got is None:
                raise IncompletePackage("package %s has no %s" % (self.name, p))
            want = _PART_TYPES[p]
            if not isinstance(got, want):
                raise IncompletePackage(
                    "package %s: part %s is %r, expected %s -- a part must be "
                    "a real object, not a label"
                    % (self.name, p, type(got).__name__, want.__name__))

    def parts(self) -> Tuple[Tuple[str, Any], ...]:
        return tuple((p, getattr(self, p)) for p in PARTS)

    def render(self) -> str:
        return "%s [%s] %s" % (self.name, self.capability_class, self.statement)


# --------------------------------------------------------------------------
# the trust boundary
# --------------------------------------------------------------------------

_GUARDED_KERNEL_FUNCTIONS = (
    ("check", "check_step"),
    ("check", "check_path"),
    ("check", "check_edge"),
    ("check", "check_composite"),
    ("term", "beta_normal"),
    ("term", "subst_consts"),
)


def _fn_digest(fn: Any) -> str:
    code = getattr(fn, "__code__", None)
    h = hashlib.blake2b(digest_size=16)
    h.update(str(getattr(fn, "__module__", "?")).encode("utf-8"))
    h.update(b"\0")
    h.update(str(getattr(fn, "__qualname__", "?")).encode("utf-8"))
    h.update(b"\0")
    if code is None:
        h.update(b"<not-a-python-function>")
    else:
        h.update(code.co_code)
        h.update(repr(code.co_names).encode("utf-8"))
        h.update(repr(code.co_varnames).encode("utf-8"))
        h.update(repr(code.co_consts).encode("utf-8"))
    return h.hexdigest()


@dataclass(frozen=True)
class TrustFingerprint:
    """An exact digest of everything the runtime accepts as true.

    Two components, because there are exactly two ways to widen belief: change
    what the checker believes (the axiom / certificate dictionaries) or change
    the checker (its code).  Both are hashed.
    """

    axioms: str
    certificates: str
    kernel_code: str

    @staticmethod
    def capture(ctx: C.CheckContext) -> "TrustFingerprint":
        ha = hashlib.blake2b(digest_size=16)
        for name in sorted(ctx.axioms):
            lhs, rhs = ctx.axioms[name]
            ha.update(("%s|%s|%s;" % (name, lhs.recompute_addr(),
                                      rhs.recompute_addr())).encode("utf-8"))
        hc = hashlib.blake2b(digest_size=16)
        for name in sorted(ctx.certificates):
            hc.update(("%s|%r;" % (name, ctx.certificates[name])).encode("utf-8"))
        hk = hashlib.blake2b(digest_size=16)
        mods = {"check": C, "term": T, "edges": E}
        for mod, fn in _GUARDED_KERNEL_FUNCTIONS:
            hk.update(("%s.%s=" % (mod, fn)).encode("ascii"))
            hk.update(_fn_digest(getattr(mods[mod], fn)).encode("ascii"))
            hk.update(b";")
        return TrustFingerprint(ha.hexdigest(), hc.hexdigest(), hk.hexdigest())

    def differences(self, other: "TrustFingerprint") -> Tuple[str, ...]:
        out = []
        if self.axioms != other.axioms:
            out.append("axioms")
        if self.certificates != other.certificates:
            out.append("certificates")
        if self.kernel_code != other.kernel_code:
            out.append("kernel_code")
        return tuple(out)


class trust_guard:
    """Context manager: nothing inside may move the trust fingerprint.

    This is the mechanical form of CRYSTAL.md Sec.5.  It is not a policy, a
    lint, or a deprecation: leaving the block with a moved fingerprint raises.
    """

    __slots__ = ("_ctx", "_what", "before", "after")

    def __init__(self, ctx: C.CheckContext, what: str = "") -> None:
        self._ctx = ctx
        self._what = what
        self.before: Optional[TrustFingerprint] = None
        self.after: Optional[TrustFingerprint] = None

    def __enter__(self) -> "trust_guard":
        self.before = TrustFingerprint.capture(self._ctx)
        return self

    def __exit__(self, exc_type, exc, tb) -> bool:
        self.after = TrustFingerprint.capture(self._ctx)
        moved = self.before.differences(self.after)
        if moved:
            raise TrustViolation(
                "%s widened the trust boundary: %s changed"
                % (self._what or "a capability", ", ".join(moved)))
        return False


class SealedContext:
    """A read-only, checking-capable view of the kernel's ``CheckContext``.

    A package can *use* the checker and *read* the book.  It cannot declare an
    axiom, declare a certificate, or mutate either dictionary.  This is the
    difference between extending what the runtime can do and extending what it
    believes.
    """

    __slots__ = ("__ctx", "__frozen")

    def __init__(self, ctx: C.CheckContext) -> None:
        object.__setattr__(self, "_SealedContext__ctx", ctx)
        object.__setattr__(self, "_SealedContext__frozen", True)

    # -- reading ---------------------------------------------------------
    @property
    def axioms(self):
        return MappingProxyType(self.__ctx.axioms)

    @property
    def certificates(self):
        return MappingProxyType(self.__ctx.certificates)

    def counter(self, key: str) -> int:
        return self.__ctx.counters.get(key)

    def errors(self) -> Tuple[str, ...]:
        return tuple(self.__ctx.errors)

    # -- checking (the only thing a package may ask the kernel to do) ----
    def check_path(self, path: Sequence[C.Step], src: str, dst: str) -> bool:
        return C.check_path(tuple(path), src, dst, self.__ctx)

    def check_step(self, step: C.Step) -> bool:
        return C.check_step(step, self.__ctx)

    def check_edge(self, edge: E.Edge) -> bool:
        return C.check_edge(edge, self.__ctx)

    # -- refusals --------------------------------------------------------
    def declare_axiom(self, *a, **k):
        raise TrustViolation(
            "a capability may not declare an axiom: that would widen what the "
            "runtime accepts as true, not what it can do")

    def declare_certificate(self, *a, **k):
        raise TrustViolation(
            "a capability may not declare a certificate: that would widen the "
            "trust dictionary")

    def __setattr__(self, key, value):
        raise TrustViolation("the sealed context is immutable (%s)" % key)

    def __delattr__(self, key):
        raise TrustViolation("the sealed context is immutable (%s)" % key)

    def __repr__(self) -> str:
        return "SealedContext(axioms=%d, certificates=%d)" % (
            len(self.__ctx.axioms), len(self.__ctx.certificates))


# --------------------------------------------------------------------------
# the kernel's own verdict -- the adjudicator
# --------------------------------------------------------------------------

def kernel_verdict(w: Witness, ctx: SealedContext,
                   ledger: Optional[Ledger] = None) -> bool:
    """Adjudicate a witness by running ``kernel/check.py`` and nothing else.

    This function reads no field a producer could set to influence it: it takes
    the obligations' endpoints and paths, and the edges, and hands them to the
    trusted checker.  It is what ``CapabilityRuntime.fire`` compares every
    package's own checker against.
    """
    ok = True
    for o in w.obligations:
        if ledger is not None:
            ledger.bump("steps", len(o.path))
        if not ctx.check_path(o.path, o.src, o.dst):
            ok = False
    for e in w.edges:
        if not ctx.check_edge(e):
            ok = False
    return ok


def kernel_witness_checker(name: str = "kernel") -> WitnessChecker:
    """The canonical witness checker: it *is* a call into ``kernel/check.py``."""

    def verify(w: Witness, ctx: SealedContext, ledger: Ledger) -> bool:
        return kernel_verdict(w, ctx, ledger)

    return WitnessChecker(name=name, verify=verify, routes_through_kernel=True)


# --------------------------------------------------------------------------
# firing
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class Firing:
    package: str
    output: Any
    witness: Witness
    checked: bool
    cost: CostVector
    instance: Instance
    ledger: Tuple[Tuple[str, int], ...] = ()

    @property
    def produced_object(self) -> bool:
        return self.output is not NO_OBJECT

    def render(self) -> str:
        return "%s fired: %s [%s]" % (
            self.package, "object" if self.produced_object else "NO OBJECT",
            self.cost.render())


@dataclass(frozen=True)
class Refusal:
    package: str
    reason: str
    failed: Tuple[str, ...] = ()
    cost: CostVector = field(default_factory=CostVector)

    @property
    def produced_object(self) -> bool:
        return False

    def render(self) -> str:
        return "%s refused: %s" % (self.package, self.reason)


class CapabilityRuntime:
    """The installed capabilities, and the only door they fire through.

    Installation and firing both run inside ``trust_guard``.  A package that
    moves the trust fingerprint is quarantined and the exception propagates:
    the runtime does not "log and continue" on a trust violation.
    """

    __slots__ = ("_ctx", "_sealed", "_packages", "_order", "quarantine",
                 "audit_log")

    def __init__(self, ctx: C.CheckContext) -> None:
        if not isinstance(ctx, C.CheckContext):
            raise CapabilityError("the runtime needs a kernel CheckContext")
        self._ctx = ctx
        self._sealed = SealedContext(ctx)
        self._packages: Dict[str, ProvedCapability] = {}
        self._order: list = []
        self.quarantine: Dict[str, str] = {}
        self.audit_log: list = []

    # -- installation ----------------------------------------------------
    def install(self, pkg: Any) -> ProvedCapability:
        """Install a package.  Anything that is not a complete
        ``ProvedCapability`` is a ``TypeError``, not a warning."""
        if not isinstance(pkg, ProvedCapability):
            raise IncompletePackage(
                "only a complete ProvedCapability can be installed; got %r"
                % (type(pkg).__name__,))
        if pkg.name in self._packages:
            raise CapabilityError("capability %r is already installed" % (pkg.name,))
        with trust_guard(self._ctx, "installing %s" % pkg.name):
            pass
        self._packages[pkg.name] = pkg
        self._order.append(pkg.name)
        self.audit_log.append(("install", pkg.name, pkg.capability_class))
        return pkg

    def installed(self) -> Tuple[str, ...]:
        return tuple(self._order)

    def get(self, name: str) -> ProvedCapability:
        got = self._packages.get(name)
        if got is None:
            raise CapabilityError("no capability named %r" % (name,))
        return got

    @property
    def sealed(self) -> SealedContext:
        return self._sealed

    def fingerprint(self) -> TrustFingerprint:
        return TrustFingerprint.capture(self._ctx)

    # -- firing ----------------------------------------------------------
    def fire(self, name: str, subject: Any, task: Any = None,
             ledger: Optional[Ledger] = None) -> Any:
        pkg = self.get(name)
        if name in self.quarantine:
            return Refusal(name, "quarantined: %s" % self.quarantine[name])
        led = ledger if ledger is not None else Ledger()
        guard = trust_guard(self._ctx, "capability %s" % name)
        try:
            guard.__enter__()
            out = self._fire_inner(pkg, subject, task, led)
        except TrustViolation as exc:
            self.quarantine[name] = str(exc)
            self.audit_log.append(("trust-violation", name, str(exc)))
            try:
                guard.__exit__(None, None, None)
            except TrustViolation:
                pass
            raise
        except BaseException:
            try:
                guard.__exit__(None, None, None)
            except TrustViolation as exc2:
                self.quarantine[name] = str(exc2)
                self.audit_log.append(("trust-violation", name, str(exc2)))
                raise
            raise
        guard.__exit__(None, None, None)
        return out

    def _fire_inner(self, pkg: ProvedCapability, subject: Any, task: Any,
                    led: Ledger) -> Any:
        sealed = self._sealed
        verdict = pkg.boundary.evaluate(subject, task, sealed)
        led.bump("search", verdict.cost)
        if not verdict.ok:
            self.audit_log.append(("refuse-boundary", pkg.name, verdict.failed))
            return Refusal(pkg.name,
                           "outside the application boundary: %s" % verdict.reason,
                           verdict.failed, led.vector())
        inst = pkg.recognizer.recognize(subject, task, sealed, led)
        if not inst.matched:
            self.audit_log.append(("refuse-recognizer", pkg.name, inst.note))
            return Refusal(pkg.name, "not an instance: %s" % inst.note,
                           ("recognizer",), led.vector())

        before = sealed.counter("check.step")
        output = pkg.transformer.apply(inst, sealed, led)
        witness = pkg.witness_producer.produce(inst, output, sealed, led)

        own = pkg.witness_checker.check(witness, sealed, led)
        mid = sealed.counter("check.step")
        adjudicated = kernel_verdict(witness, sealed, None)
        led.bump("audit", sealed.counter("check.step") - mid)
        if own != adjudicated:
            self.quarantine[pkg.name] = (
                "witness checker said %r where kernel/check.py said %r"
                % (own, adjudicated))
            self.audit_log.append(("checker-disagreement", pkg.name, (own, adjudicated)))
            raise CheckerDisagreement(
                "package %s: its witness checker returned %r but "
                "kernel/check.py returned %r -- a checker that trusts its "
                "producer is not a checker" % (pkg.name, own, adjudicated))
        led.bump("checks", mid - before)
        if not adjudicated:
            self.audit_log.append(("refuse-witness", pkg.name, witness.note))
            return Refusal(pkg.name, "the kernel rejected the witness",
                           ("witness",), led.vector())
        self.audit_log.append(("fire", pkg.name, witness.digest()))
        return Firing(pkg.name, output, witness, True, led.vector(), inst,
                      led.snapshot())
