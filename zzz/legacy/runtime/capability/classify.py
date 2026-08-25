"""Executable-content classification: what kind of capability a proof yields.

Not every theorem yields the same capability, and a runtime that treats them
alike is lying about at least one of them.  Before a proved statement is
packaged, this module answers seven questions about it -- **computed by
running the package's own parts** wherever a computation can settle the
question, and declared-with-justification (never declared bare) otherwise:

    constructs                is an object produced?
    decides                   does a decision procedure exist?
    existence_only            is it known only by existence -- no object?
    compilable                which part becomes a reusable transformation?
    requires_kernel_recheck    which part must go back to the kernel on every use?
    cacheable                 what is a pure function of content-addressed input?
    must_regenerate           what must be produced afresh for every instance?

Six classes, each with a *distinct executable consequence*:

    Equality             -> a rewrite                (runtime/execute)
    FiniteClassification -> a decision procedure by table lookup
    Quotient             -> a state compression      (the shape runtime/distinguish
                            compiles; wired conceptually, not imported)
    UniversalProperty    -> a synthesis procedure: given the data of the
                            property, produce the unique map
    Obstruction          -> a search prune: a predicate that kills branches
                            before the search enters them
    ExistenceOnly        -> **nothing**.  A classical existence proof is not a
                            program, and the runtime says so rather than
                            pretending.

``require_consistent`` is what stops the pretending: an ``ExistenceOnly``
statement declared to be a ``FiniteClassification`` raises ``ClassMismatch``,
because the computed profile says nothing was decided.
"""

from __future__ import annotations

import hashlib
from dataclasses import dataclass
from typing import Any, Callable, Dict, Optional, Sequence, Tuple

from ..kernel import check as C
from ..kernel import term as T
from .package import (ApplicationBoundary, CapabilityError, CheckerDisagreement,
                      Instance, Ledger, NO_OBJECT, Recognizer, SealedContext,
                      Transformer, Witness, WitnessChecker, WitnessProducer,
                      kernel_verdict, trust_guard)

__all__ = [
    "CONSTRUCTS", "DECIDES", "EXISTENCE_ONLY", "COMPILABLE",
    "KERNEL_RECHECK", "CACHEABLE", "REGENERATE", "QUESTIONS",
    "EQUALITY", "FINITE_CLASSIFICATION", "QUOTIENT", "UNIVERSAL_PROPERTY",
    "OBSTRUCTION", "EXISTENCE_ONLY_CLASS", "CLASSES", "CONSEQUENCE",
    "NO_CONSEQUENCE",
    "Answer", "ContentProfile", "Classification", "ClassMismatch",
    "classify", "require_consistent", "digest_of",
]


# -- the seven questions ----------------------------------------------------

CONSTRUCTS = "constructs"
DECIDES = "decides"
EXISTENCE_ONLY = "existence_only"
COMPILABLE = "compilable"
KERNEL_RECHECK = "requires_kernel_recheck"
CACHEABLE = "cacheable"
REGENERATE = "must_regenerate"

QUESTIONS = (CONSTRUCTS, DECIDES, EXISTENCE_ONLY, COMPILABLE,
             KERNEL_RECHECK, CACHEABLE, REGENERATE)


# -- the six classes --------------------------------------------------------

EQUALITY = "Equality"
FINITE_CLASSIFICATION = "FiniteClassification"
QUOTIENT = "Quotient"
UNIVERSAL_PROPERTY = "UniversalProperty"
OBSTRUCTION = "Obstruction"
EXISTENCE_ONLY_CLASS = "ExistenceOnly"

CLASSES = (EQUALITY, FINITE_CLASSIFICATION, QUOTIENT, UNIVERSAL_PROPERTY,
           OBSTRUCTION, EXISTENCE_ONLY_CLASS)

NO_CONSEQUENCE = "none"

CONSEQUENCE = {
    EQUALITY: "rewrite",
    FINITE_CLASSIFICATION: "decision procedure by table lookup",
    QUOTIENT: "state compression",
    UNIVERSAL_PROPERTY: "synthesis procedure",
    OBSTRUCTION: "search prune",
    EXISTENCE_ONLY_CLASS: NO_CONSEQUENCE,
}


class ClassMismatch(CapabilityError):
    """A statement was claimed to be a class its computed content contradicts."""


# -- answers ----------------------------------------------------------------

@dataclass(frozen=True)
class Answer:
    """One question, one exact answer, and where the answer came from.

    ``basis`` is ``"computed"`` (a run of the package's own parts settled it,
    and ``evidence`` records what was run) or ``"declared"`` (a human asserted
    it, and ``justification`` must say why -- an unjustified declaration is
    refused at construction).
    """

    question: str
    value: bool
    basis: str
    justification: str = ""
    evidence: Tuple[Tuple[str, Any], ...] = ()

    def __post_init__(self) -> None:
        if self.question not in QUESTIONS:
            raise CapabilityError("unknown classification question %r" % (self.question,))
        if self.basis not in ("computed", "declared"):
            raise CapabilityError("answer basis must be 'computed' or 'declared'")
        if not isinstance(self.value, bool):
            raise CapabilityError("a classification answer must be a bool")
        if self.basis == "declared" and not self.justification.strip():
            raise CapabilityError(
                "question %r was declared without a justification" % (self.question,))
        if self.basis == "computed" and not self.evidence:
            raise CapabilityError(
                "question %r claims to be computed but records no evidence"
                % (self.question,))

    def render(self) -> str:
        ev = " ".join("%s=%s" % kv for kv in self.evidence)
        return "%-24s %-5s [%s] %s" % (self.question, str(self.value).lower(),
                                       self.basis[0], ev or self.justification)


@dataclass(frozen=True)
class ContentProfile:
    answers: Tuple[Answer, ...]

    def __post_init__(self) -> None:
        got = tuple(a.question for a in self.answers)
        if got != QUESTIONS:
            raise CapabilityError(
                "a content profile must answer exactly %s, in order; got %s"
                % (list(QUESTIONS), list(got)))

    def answer(self, question: str) -> Answer:
        for a in self.answers:
            if a.question == question:
                return a
        raise CapabilityError("no answer for %r" % (question,))

    def value(self, question: str) -> bool:
        return self.answer(question).value

    def computed_count(self) -> int:
        return sum(1 for a in self.answers if a.basis == "computed")

    def render(self) -> str:
        return "\n".join("  " + a.render() for a in self.answers)


@dataclass(frozen=True)
class Classification:
    capability_class: str
    consequence: str
    profile: ContentProfile
    probes: int = 0
    domain: int = 0
    note: str = ""

    @property
    def yields_executable_capability(self) -> bool:
        return self.consequence != NO_CONSEQUENCE

    def render(self) -> str:
        head = "%s -> %s" % (self.capability_class, self.consequence)
        if not self.yields_executable_capability:
            head += "   (NO executable capability: this is correct, not a failure)"
        return head + "\n" + self.profile.render()


# -- digests ----------------------------------------------------------------

def digest_of(obj: Any) -> str:
    """A deterministic content digest for any value a package can produce."""
    h = hashlib.blake2b(digest_size=16)

    def go(x: Any) -> None:
        if isinstance(x, T.Term):
            h.update(b"term:")
            h.update(x.recompute_addr().encode("ascii"))
        elif isinstance(x, Witness):
            h.update(b"witness:")
            h.update(x.digest().encode("ascii"))
        elif x is NO_OBJECT:
            h.update(b"NO_OBJECT")
        elif isinstance(x, (tuple, list)):
            h.update(b"seq[")
            for y in x:
                go(y)
                h.update(b",")
            h.update(b"]")
        elif isinstance(x, dict):
            h.update(b"map{")
            for k in sorted(x, key=repr):
                go(k)
                h.update(b":")
                go(x[k])
                h.update(b";")
            h.update(b"}")
        elif isinstance(x, float):
            raise CapabilityError("no floats in this runtime")
        else:
            h.update(repr(x).encode("utf-8"))
        h.update(b"|")

    go(obj)
    return h.hexdigest()


# -- the classifier ---------------------------------------------------------

@dataclass(frozen=True)
class _Run:
    subject: Any
    task: Any
    instance: Instance
    output: Any
    witness: Optional[Witness]
    accepted: bool


def _run_parts(recognizer: Recognizer, transformer: Transformer,
               producer: WitnessProducer, checker: WitnessChecker,
               boundary: ApplicationBoundary, sealed: SealedContext,
               subject: Any, task: Any) -> _Run:
    led = Ledger()
    verdict = boundary.evaluate(subject, task, sealed)
    if not verdict.ok:
        return _Run(subject, task, Instance(False, note="outside boundary"),
                    NO_OBJECT, None, False)
    inst = recognizer.recognize(subject, task, sealed, led)
    if not inst.matched:
        return _Run(subject, task, inst, NO_OBJECT, None, False)
    output = transformer.apply(inst, sealed, led)
    witness = producer.produce(inst, output, sealed, led)
    accepted = checker.check(witness, sealed, led)
    return _Run(subject, task, inst, output, witness, accepted)


def classify(capability_class: str,
             recognizer: Recognizer,
             transformer: Transformer,
             producer: WitnessProducer,
             checker: WitnessChecker,
             boundary: ApplicationBoundary,
             ctx: C.CheckContext,
             probes: Sequence[Tuple[Any, Any]],
             decision_domain: Sequence[Tuple[Any, Any]] = (),
             content_key: Optional[Callable[[Any, Any], str]] = None,
             declared: Optional[Dict[str, Tuple[bool, str]]] = None,
             note: str = "") -> Classification:
    """Answer the seven questions by running the package's own parts.

    Nothing here trusts a label.  ``constructs`` is settled by looking at what
    the transformer returned; ``decides`` by exhausting the declared finite
    domain; ``requires_kernel_recheck`` by feeding the checker deliberately
    corrupted witnesses and requiring it to reject every one.

    Classification runs inside ``trust_guard``: a package that widens the trust
    boundary cannot even be classified, let alone installed.
    """
    if capability_class not in CLASSES:
        raise ClassMismatch("unknown capability class %r" % (capability_class,))
    declared = dict(declared or {})
    probes = tuple(probes)
    decision_domain = tuple(decision_domain)
    if not probes:
        raise CapabilityError("classification needs at least one probe")

    sealed = SealedContext(ctx)
    with trust_guard(ctx, "classifying %s" % capability_class):
        runs = tuple(_run_parts(recognizer, transformer, producer, checker,
                                boundary, sealed, s, t) for s, t in probes)
        again = tuple(_run_parts(recognizer, transformer, producer, checker,
                                 boundary, sealed, s, t) for s, t in probes)
        domain_runs = tuple(_run_parts(recognizer, transformer, producer, checker,
                                       boundary, sealed, s, t)
                            for s, t in decision_domain)

        recognized = tuple(r for r in runs if r.instance.matched)

        # -- constructs -------------------------------------------------
        produced = tuple(r for r in recognized
                         if r.output is not NO_OBJECT and r.output is not None)
        constructs = bool(recognized) and len(produced) == len(recognized)
        a_constructs = Answer(
            CONSTRUCTS, constructs, "computed",
            evidence=(("probes", len(runs)), ("recognized", len(recognized)),
                      ("objects", len(produced))))

        # -- decides ----------------------------------------------------
        if decision_domain:
            settled = tuple(r for r in domain_runs
                            if r.instance.matched and r.output is not NO_OBJECT)
            decides = len(settled) == len(domain_runs) and bool(domain_runs)
            a_decides = Answer(
                DECIDES, decides, "computed",
                evidence=(("domain", len(domain_runs)), ("settled", len(settled)),
                          ("total", decides)))
        else:
            a_decides = Answer(
                DECIDES, False, "computed",
                evidence=(("domain", 0),
                          ("exhausted", 0)))

        # -- existence only ---------------------------------------------
        a_existence = Answer(
            EXISTENCE_ONLY, (not constructs) and (not a_decides.value), "computed",
            evidence=(("objects", len(produced)),
                      ("decided", int(a_decides.value))))

        # -- compilable --------------------------------------------------
        stable = all(digest_of(x.output) == digest_of(y.output)
                     and x.instance.matched == y.instance.matched
                     for x, y in zip(runs, again))
        total = len(recognized) == len(produced)
        a_compilable = Answer(
            COMPILABLE, bool(stable and total and recognized), "computed",
            evidence=(("rerun_identical", int(stable)),
                      ("total_on_recognized", int(total))))

        # -- requires kernel recheck --------------------------------------
        mutants = 0
        rejected = 0
        genuine_ok = True
        for r in recognized:
            if r.witness is None:
                continue
            if not checker.check(r.witness, sealed, Ledger()):
                genuine_ok = False
            for m in r.witness.mutants():
                mutants += 1
                if not checker.check(m, sealed, Ledger()):
                    rejected += 1
        if mutants and rejected != mutants:
            raise CheckerDisagreement(
                "witness checker %r accepted %d of %d corrupted witnesses -- it "
                "is trusting its producer, not re-checking with the kernel"
                % (checker.name, mutants - rejected, mutants))
        a_recheck = Answer(
            KERNEL_RECHECK, bool(genuine_ok and mutants and rejected == mutants),
            "computed",
            evidence=(("mutants", mutants), ("rejected", rejected),
                      ("genuine_accepted", int(genuine_ok))))

        # -- cacheable ---------------------------------------------------
        if content_key is None:
            if CACHEABLE not in declared:
                raise CapabilityError(
                    "cacheability cannot be computed without a content_key, and "
                    "was not declared with a justification")
            a_cacheable = Answer(CACHEABLE, declared[CACHEABLE][0], "declared",
                                 declared[CACHEABLE][1])
        else:
            table: Dict[str, str] = {}
            consistent = True
            for r in recognized:
                k = content_key(r.subject, r.task)
                d = digest_of(r.output)
                if table.setdefault(k, d) != d:
                    consistent = False
            a_cacheable = Answer(
                CACHEABLE, bool(consistent and stable and recognized), "computed",
                evidence=(("keys", len(table)), ("runs", len(recognized)),
                          ("collisions_consistent", int(consistent)),
                          ("rerun_identical", int(stable))))

        # -- must regenerate ----------------------------------------------
        wdigests = sorted({r.witness.digest() for r in recognized
                           if r.witness is not None})
        a_regen = Answer(
            REGENERATE, len(wdigests) > 1, "computed",
            evidence=(("distinct_witnesses", len(wdigests)),
                      ("instances", len(recognized))))

    answers = {a.question: a for a in (a_constructs, a_decides, a_existence,
                                       a_compilable, a_recheck, a_cacheable,
                                       a_regen)}
    for q, (val, why) in declared.items():
        if q not in QUESTIONS:
            raise CapabilityError("unknown declared question %r" % (q,))
        if q == CACHEABLE and content_key is None:
            continue
        computed = answers[q]
        if computed.value != val:
            raise ClassMismatch(
                "question %r was declared %r but computing it gave %r (%s)"
                % (q, val, computed.value,
                   " ".join("%s=%s" % kv for kv in computed.evidence)))
        answers[q] = Answer(q, val, "declared", why)

    profile = ContentProfile(tuple(answers[q] for q in QUESTIONS))
    cls = Classification(capability_class, CONSEQUENCE[capability_class],
                         profile, len(probes), len(decision_domain), note)
    require_consistent(cls)
    return cls


def require_consistent(cls: Classification) -> None:
    """Refuse a class whose computed content contradicts the claim.

    This is where "an ExistenceOnly theorem claimed to yield a decision
    procedure" dies.  The claim is not compared against another claim; it is
    compared against what happened when the package's own parts were run.
    """
    p = cls.profile
    k = cls.capability_class

    if not p.value(KERNEL_RECHECK):
        raise ClassMismatch(
            "%s: the witness checker does not re-check with the kernel on every "
            "use, so no class may be claimed" % (k,))

    if k == EXISTENCE_ONLY_CLASS:
        if p.value(CONSTRUCTS):
            raise ClassMismatch(
                "ExistenceOnly claimed, but the transformer produced an object: "
                "that statement has constructive content and must be classified "
                "as such")
        if p.value(DECIDES):
            raise ClassMismatch(
                "ExistenceOnly claimed, but a total decision procedure was "
                "exhibited over the declared domain")
        if not p.value(EXISTENCE_ONLY):
            raise ClassMismatch("ExistenceOnly claimed but not computed")
        return

    if p.value(EXISTENCE_ONLY):
        raise ClassMismatch(
            "%s claimed, but the computed profile is existence-only: no object "
            "was produced and nothing was decided.  A classical existence proof "
            "is not a %s." % (k, CONSEQUENCE[k]))

    if k in (FINITE_CLASSIFICATION, OBSTRUCTION):
        if not p.value(DECIDES):
            raise ClassMismatch(
                "%s claimed, but no total decision procedure was exhibited over "
                "the declared finite domain (%d elements exhausted)"
                % (k, cls.domain))
    if k in (EQUALITY, QUOTIENT, UNIVERSAL_PROPERTY):
        if not p.value(CONSTRUCTS):
            raise ClassMismatch(
                "%s claimed, but the transformer produced no object" % (k,))
    if not p.value(COMPILABLE):
        raise ClassMismatch(
            "%s claimed, but the recognizer/transformer pair is not a stable "
            "total function on the recognized probes, so nothing compiles" % (k,))
