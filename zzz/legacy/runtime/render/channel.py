#!/usr/bin/env python3
"""The channel abstraction: CRYSTAL.md §7 REALIZE, the perceptual half.

A **channel** is a map from mathematical state to a perceptual code.  It is a
*projection of one object*, never an independent semantic copy and never a
truth authority.  This module makes that discipline mechanical rather than
aspirational.  Every channel built here must be able to state, and prove:

* **what it preserves** -- which declared distinctions survive the projection.
  Proved by exhaustive check over the declared state set, and reported with the
  three separate populations that matter: required separations that hold,
  permitted collisions (the task does not care), and over-separations (the
  channel spent code on a distinction no declared task uses).
* **what it loses** -- an explicit *collision witness*: two distinct states
  carrying the same code.  A channel that cannot produce one either is
  injective on the declared language (and must say so, and be checked) or is
  lying.
* **whether the round trip is exact** -- if the channel declares injectivity on
  a sublanguage, an inverse must be *implemented* and checked against the
  independently recomputed fiber.  If it is lossy, ``decode`` returns the
  **fiber** -- the whole set of preimages -- and structurally cannot return a
  single guess.

This mirrors the corpus's own homometry result (`notes/CROSS_LENS.md` §2):
one projection can identify distinct objects, so no single view is
authoritative.  A channel disagreeing with the state is a channel bug; a
channel *agreeing but coarser* is the normal case and is what must be
quantified.

### The one proposition that bounds every claim in this package

    Proposition (no channel gains information).  A channel is a function
    ``encode`` on the declared language L.  Hence |image(encode)| <= |L|, and
    the partition of L induced by ``encode`` is a coarsening of equality.  So
    no channel can separate two states that the raw representation does not
    separate, and no channel can answer a query the raw state cannot answer.

Therefore the *only* value a channel here may claim is **recognition-cost
reduction** -- fewer operations to reach an answer already implied by the
state.  ``certify_claim`` enforces this: a channel declaring
``INFORMATION_GAIN`` is rejected, and the rejection is a theorem, not a
policy.  The package must know the difference and be able to say which it is
claiming; this is where it says it.

Exact and CPU-only: integers and ``fractions.Fraction`` only, no float
anywhere, no randomness, no network, no imports outside the standard library.
Determinism: every iteration is over ``sorted()`` or an insertion-ordered
tuple, so two runs are byte-identical under any ``PYTHONHASHSEED``.

Vocabulary is deliberately shared with `runtime/distinguish/` (task-relative
sufficiency, collisions as data, exhaustive proof rather than sampling).
Nothing is imported from it: this package stands alone.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Callable, Optional, Sequence

RECOGNITION_COST = "recognition-cost"
INFORMATION_GAIN = "information-gain"
CLAIM_KINDS = (RECOGNITION_COST, INFORMATION_GAIN)


class ChannelError(Exception):
    """Raised when a channel violates the discipline this module enforces."""


# --------------------------------------------------------------------------
# exact step counting
# --------------------------------------------------------------------------


class StepCounter:
    """An exact, integer-valued operation counter.

    Counts logical operations.  Never measures wall-clock time, never
    estimates, never divides.  ``report()`` is name-sorted so two runs of the
    same computation compare byte for byte.

    Reimplemented here rather than imported from `runtime/distinguish/`: this
    package imports nothing from its siblings (asserted in the test suite on
    the parsed import graph).
    """

    __slots__ = ("_counts",)

    def __init__(self) -> None:
        self._counts: dict[str, int] = {}

    def tick(self, kind: str, amount: int = 1) -> None:
        if not isinstance(amount, int) or isinstance(amount, bool) or amount < 0:
            raise ValueError("step amounts must be non-negative integers")
        self._counts[kind] = self._counts.get(kind, 0) + amount

    def get(self, kind: str) -> int:
        return self._counts.get(kind, 0)

    def total(self) -> int:
        return sum(self._counts.values())

    def report(self) -> tuple[tuple[str, int], ...]:
        return tuple(sorted(self._counts.items()))

    def absorb(self, other: "StepCounter", prefix: str = "") -> None:
        for kind, amount in other.report():
            self.tick(prefix + kind, amount)

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "StepCounter(total=%d)" % (self.total(),)


class NullCounter(StepCounter):
    """Used where a cost is deliberately not charged to a measured path."""

    __slots__ = ()

    def tick(self, kind: str, amount: int = 1) -> None:  # noqa: D102
        return None


_NULL = NullCounter()


def _counter(counter: Optional[StepCounter]) -> StepCounter:
    return _NULL if counter is None else counter


# --------------------------------------------------------------------------
# languages and tasks
# --------------------------------------------------------------------------


class Language:
    """A declared, finite, ordered set of states.

    "Declared" is load-bearing.  Every proof in this module is exhaustive over
    a ``Language``; a claim about a channel is a claim *about that language*
    and about nothing else.  The same channel is injective on one language and
    lossy on a larger one, and this package is built so that saying which is
    unavoidable.
    """

    __slots__ = ("name", "states", "_index")

    def __init__(self, name: str, states: Sequence) -> None:
        self.name = name
        self.states = tuple(states)
        index: dict = {}
        for position, state in enumerate(self.states):
            try:
                hash(state)
            except TypeError:
                raise ChannelError("language %r: state %r is not hashable" % (name, state))
            if state in index:
                raise ChannelError("language %r: duplicate state %r" % (name, state))
            index[state] = position
        self._index = index

    def __len__(self) -> int:
        return len(self.states)

    def __contains__(self, state) -> bool:
        try:
            return state in self._index
        except TypeError:
            return False

    def position(self, state) -> int:
        return self._index[state]

    def sublanguage(self, name: str, predicate: Callable) -> "Language":
        return Language(name, tuple(s for s in self.states if predicate(s)))

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "Language(%r, %d states)" % (self.name, len(self.states))


@dataclass(frozen=True)
class Task:
    """A declared query: which states must receive different answers.

    Same notion as `runtime/distinguish/`: distinguishability is task-relative,
    and a channel is never "good" in the abstract.
    """

    name: str
    fn: Callable
    description: str = ""

    def __call__(self, state, counter: Optional[StepCounter] = None):
        return self.fn(state, _counter(counter))


# --------------------------------------------------------------------------
# certificates -- every one of them is produced by an exhaustive check
# --------------------------------------------------------------------------


@dataclass(frozen=True)
class CollisionWitness:
    """Two distinct states carrying the same code.  Loss, as data."""

    left: object
    right: object
    code: object

    def render(self) -> str:
        return "%s ~ %s  both -> %s" % (self.left, self.right, self.code)


@dataclass(frozen=True)
class InjectivityCertificate:
    language: str
    declared: bool
    injective: bool
    pairs_checked: int
    witness: Optional[CollisionWitness]

    @property
    def honest(self) -> bool:
        """The declaration matches the exhaustive fact."""
        return (not self.declared) or self.injective


@dataclass(frozen=True)
class LossCertificate:
    """What the projection destroys, counted exactly."""

    language: str
    domain_size: int
    image_size: int
    fiber_sizes: tuple  # ((size, how_many), ...) ascending by size
    max_fiber: int
    witness: Optional[CollisionWitness]

    @property
    def lossy(self) -> bool:
        return self.image_size < self.domain_size

    def render(self) -> str:
        sizes = " ".join("%dx%d" % (count, size) for size, count in self.fiber_sizes)
        return "%d states -> %d codes; fibers %s; max fiber %d" % (
            self.domain_size,
            self.image_size,
            sizes,
            self.max_fiber,
        )


@dataclass(frozen=True)
class RoundTripCertificate:
    """``decode`` discipline plus, when injective, an implemented inverse.

    ``fiber_exact`` is checked against *independently recomputed* preimages,
    never against the channel's own cache.
    """

    language: str
    fiber_exact: bool
    inverse_implemented: bool
    inverse_exact: bool
    states_checked: int
    failure: Optional[str]


@dataclass(frozen=True)
class PreservationCertificate:
    """The task-distinguishability proof (exhaustive over unordered pairs).

    Three populations, kept separate because they mean three different things:

    * ``required_separations`` -- pairs the task distinguishes, that the code
      also distinguishes.  These are what the channel *preserves*.
    * ``violations`` -- pairs the task distinguishes that the code identifies.
      One is enough to refute the claim, and the first in deterministic order
      is retained as a witness.
    * ``permitted_collisions`` -- pairs the task does not distinguish and the
      code identifies.  Not failures: this is the compression working.
    * ``over_separations`` -- pairs the task does not distinguish but the code
      does.  Not failures either, but they are code spent on nothing, and a
      channel with many of them is paying recognition cost for no declared
      query (`runtime/distinguish/` step 6 deletes such channels).
    """

    language: str
    task: str
    preserved: bool
    pairs_checked: int
    required_separations: int
    violations: int
    violation_witness: Optional[CollisionWitness]
    permitted_collisions: int
    over_separations: int


@dataclass(frozen=True)
class ClaimCertificate:
    channel: str
    kind: str
    accepted: bool
    domain_size: int
    image_size: int
    reason: str


@dataclass(frozen=True)
class ValidationReport:
    """The structural discipline checks.  All must pass or the channel is not
    a channel in the sense of this module."""

    channel: str
    language: str
    decode_returns_fiber: bool
    fibers_partition: bool
    fibers_deterministic: bool
    failures: tuple

    @property
    def ok(self) -> bool:
        return not self.failures


# --------------------------------------------------------------------------
# the channel itself
# --------------------------------------------------------------------------


class Channel:
    """A projection of mathematical state onto a perceptual code.

    ``decode`` is defined here, on the base class, as *the fiber*: the tuple of
    every state in the declared language mapping to that code.  It is not a
    hook subclasses are invited to reinterpret.  A lossy channel therefore
    cannot return a single guess without overriding a method whose contract
    forbids it -- and ``validate_channel`` catches exactly that override
    (planted-false control ``test_planted_lossy_decode_returns_single_value``).

    ``decode_exact`` -- the single-value inverse -- exists only for a channel
    that *declares* injectivity, and refuses to run until an exhaustive
    injectivity check has passed on the declared language.
    """

    def __init__(
        self,
        name: str,
        language: Language,
        encoder: Callable,
        description: str = "",
        declares_injective: bool = False,
        claim: str = RECOGNITION_COST,
        claim_justification: str = "",
        inverse: Optional[Callable] = None,
        encode_cost: int = 1,
    ) -> None:
        if claim not in CLAIM_KINDS:
            raise ChannelError("unknown claim kind %r" % (claim,))
        if inverse is not None and not declares_injective:
            raise ChannelError("%s: an inverse without an injectivity declaration" % (name,))
        self.name = name
        self.language = language
        self.description = description
        self.declares_injective = bool(declares_injective)
        self.claim = claim
        self.claim_justification = claim_justification
        self.encode_cost = int(encode_cost)
        self._encoder = encoder
        self._inverse = inverse
        self._fibers: Optional[dict] = None
        self._image: Optional[tuple] = None
        self._injective_checked = False

    # -- encoding ---------------------------------------------------------

    def encode(self, state, counter: Optional[StepCounter] = None):
        if state not in self.language:
            raise ChannelError("%s: %r is outside language %r" % (self.name, state, self.language.name))
        _counter(counter).tick("channel.encode", self.encode_cost)
        return self._encoder(state)

    # -- fibers -----------------------------------------------------------

    def _build(self, counter: Optional[StepCounter] = None) -> dict:
        if self._fibers is None:
            local = _counter(counter)
            groups: dict = {}
            for state in self.language.states:
                code = self.encode(state, local)
                groups.setdefault(code, []).append(state)
                local.tick("channel.fiber_insert")
            self._fibers = {code: tuple(states) for code, states in groups.items()}
            self._image = tuple(sorted(self._fibers))
        return self._fibers

    def image(self, counter: Optional[StepCounter] = None) -> tuple:
        self._build(counter)
        return self._image

    def decode(self, code, counter: Optional[StepCounter] = None) -> tuple:
        """Return the FIBER of ``code``: every preimage, in language order.

        Never a single state, never a guess, never a "best" preimage.  An
        empty tuple means the code is not in the image.
        """
        fibers = self._build(counter)
        _counter(counter).tick("channel.decode")
        return fibers.get(code, ())

    def decode_exact(self, code, counter: Optional[StepCounter] = None):
        """The single-value inverse.  Legal only on a *checked* injective channel."""
        if not self.declares_injective:
            raise ChannelError("%s: decode_exact on a channel that does not declare injectivity" % (self.name,))
        if not self._injective_checked:
            cert = certify_injectivity(self, counter)
            if not cert.injective:
                raise ChannelError(
                    "%s: declared injective but collides: %s" % (self.name, cert.witness.render())
                )
        if self._inverse is None:
            fiber = self.decode(code, counter)
            if len(fiber) != 1:
                raise ChannelError("%s: code %r has fiber of size %d" % (self.name, code, len(fiber)))
            return fiber[0]
        _counter(counter).tick("channel.decode_exact")
        return self._inverse(code)

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "Channel(%r on %r)" % (self.name, self.language.name)


# --------------------------------------------------------------------------
# certification -- exhaustive, never sampled
# --------------------------------------------------------------------------


def certify_injectivity(channel: Channel, counter: Optional[StepCounter] = None) -> InjectivityCertificate:
    """Exhaustive injectivity check on the declared language.

    The witness is the lexicographically first colliding pair in language
    order, so it is reproducible.  This is the check that catches a channel
    claiming injectivity that has a collision.
    """
    local = _counter(counter)
    seen: dict = {}
    witness = None
    states = channel.language.states
    for state in states:
        code = channel.encode(state, local)
        local.tick("certify.injectivity")
        if code in seen and witness is None:
            witness = CollisionWitness(seen[code], state, code)
        seen.setdefault(code, state)
    size = len(states)
    pairs = size * (size - 1) // 2
    injective = witness is None
    if injective:
        channel._injective_checked = True
    return InjectivityCertificate(
        language=channel.language.name,
        declared=channel.declares_injective,
        injective=injective,
        pairs_checked=pairs,
        witness=witness,
    )


def certify_loss(channel: Channel, counter: Optional[StepCounter] = None) -> LossCertificate:
    """What the projection destroys: image size, fiber histogram, a witness."""
    local = _counter(counter)
    fibers = channel._build(local)
    histogram: dict = {}
    witness = None
    for code in channel.image(local):
        fiber = fibers[code]
        local.tick("certify.loss")
        histogram[len(fiber)] = histogram.get(len(fiber), 0) + 1
        if len(fiber) > 1 and witness is None:
            witness = CollisionWitness(fiber[0], fiber[1], code)
    return LossCertificate(
        language=channel.language.name,
        domain_size=len(channel.language),
        image_size=len(fibers),
        fiber_sizes=tuple(sorted(histogram.items())),
        max_fiber=max(histogram) if histogram else 0,
        witness=witness,
    )


def certify_round_trip(channel: Channel, counter: Optional[StepCounter] = None) -> RoundTripCertificate:
    """Round-trip discipline, checked against independently recomputed fibers.

    ``fiber_exact``  -- for every state x, ``decode(encode(x))`` is exactly the
    set of states with the same code, recomputed here from scratch rather than
    read out of the channel's cache.
    ``inverse_exact`` -- if the channel declares injectivity, the implemented
    inverse returns the unique preimage for every code in the image.  If it
    declares injectivity and has no inverse, that is reported, not excused.
    """
    local = _counter(counter)
    recomputed: dict = {}
    for state in channel.language.states:
        recomputed.setdefault(channel.encode(state, local), []).append(state)
        local.tick("certify.roundtrip")

    fiber_exact = True
    failure = None
    for state in channel.language.states:
        code = channel.encode(state, local)
        fiber = channel.decode(code, local)
        expected = tuple(recomputed[code])
        if fiber != expected:
            fiber_exact = False
            failure = "fiber of %s is %r, recomputed %r" % (state, fiber, expected)
            break

    inverse_implemented = channel._inverse is not None
    inverse_exact = False
    if channel.declares_injective:
        cert = certify_injectivity(channel, local)
        if not cert.injective:
            failure = failure or ("declared injective but collides: %s" % (cert.witness.render(),))
        elif inverse_implemented:
            inverse_exact = True
            for state in channel.language.states:
                code = channel.encode(state, local)
                back = channel.decode_exact(code, local)
                local.tick("certify.inverse")
                if back != state:
                    inverse_exact = False
                    failure = failure or ("inverse(%r) = %r, expected %r" % (code, back, state))
                    break
        else:
            failure = failure or "declares injectivity but implements no inverse"
    return RoundTripCertificate(
        language=channel.language.name,
        fiber_exact=fiber_exact,
        inverse_implemented=inverse_implemented,
        inverse_exact=inverse_exact,
        states_checked=len(channel.language),
        failure=failure,
    )


def certify_preservation(
    channel: Channel, task: Task, counter: Optional[StepCounter] = None
) -> PreservationCertificate:
    """Prove, over every unordered pair of declared states, that the code
    separates everything the task separates -- and count what it does not.

    Exhaustive.  ``runtime/distinguish/`` calls the same thing sufficiency; the
    word here is *preservation*, and it is the only sense in which this package
    ever says a channel "preserves" something.
    """
    local = _counter(counter)
    states = channel.language.states
    codes = [channel.encode(s, local) for s in states]
    answers = [task(s, local) for s in states]
    required = 0
    violations = 0
    permitted = 0
    over = 0
    witness = None
    size = len(states)
    for i in range(size):
        for j in range(i + 1, size):
            local.tick("certify.preservation")
            same_answer = answers[i] == answers[j]
            same_code = codes[i] == codes[j]
            if not same_answer:
                if same_code:
                    violations += 1
                    if witness is None:
                        witness = CollisionWitness(states[i], states[j], codes[i])
                else:
                    required += 1
            else:
                if same_code:
                    permitted += 1
                else:
                    over += 1
    return PreservationCertificate(
        language=channel.language.name,
        task=task.name,
        preserved=violations == 0,
        pairs_checked=size * (size - 1) // 2,
        required_separations=required,
        violations=violations,
        violation_witness=witness,
        permitted_collisions=permitted,
        over_separations=over,
    )


def certify_claim(channel: Channel, counter: Optional[StepCounter] = None) -> ClaimCertificate:
    """Enforce the proposition in the module docstring.

    A channel is a function of state, so ``|image| <= |domain|`` always.  A
    channel declaring ``INFORMATION_GAIN`` is therefore rejected: the rejection
    is a theorem about functions, not a house style.  The only admissible claim
    is recognition-cost reduction, and the certificate records the exact
    compression so the size of that claim is visible.
    """
    local = _counter(counter)
    domain = len(channel.language)
    image = len(channel.image(local))
    if image > domain:  # pragma: no cover - impossible for a function
        raise ChannelError("%s: image larger than domain -- encode is not a function" % (channel.name,))
    if channel.claim == INFORMATION_GAIN:
        return ClaimCertificate(
            channel=channel.name,
            kind=channel.claim,
            accepted=False,
            domain_size=domain,
            image_size=image,
            reason=(
                "rejected: a channel is a function of state, so |image| = %d <= |domain| = %d; "
                "no channel can separate what the state does not separate" % (image, domain)
            ),
        )
    return ClaimCertificate(
        channel=channel.name,
        kind=channel.claim,
        accepted=True,
        domain_size=domain,
        image_size=image,
        reason=(
            "recognition-cost only: %d states projected onto %d codes; the channel answers a "
            "declared query in fewer operations and answers no query the state cannot" % (domain, image)
        ),
    )


def validate_channel(channel: Channel, counter: Optional[StepCounter] = None) -> ValidationReport:
    """Structural discipline: does this object behave like a channel at all?

    1. ``decode`` returns a tuple of *states of the declared language*.
    2. The fibers partition the language exactly: every state appears in
       exactly one fiber, and each fiber is duplicate-free.
    3. Fiber order is deterministic (language order), so reports are stable.

    A ``decode`` that returns a single state fails (1) and (2) at once.
    """
    local = _counter(counter)
    failures: list = []
    fibers = channel._build(local)
    covered: dict = {}
    decode_ok = True
    partition_ok = True
    order_ok = True
    for code in channel.image(local):
        fiber = channel.decode(code, local)
        if not isinstance(fiber, tuple):
            decode_ok = False
            failures.append("decode(%r) returned %s, not a tuple of states" % (code, type(fiber).__name__))
            continue
        for state in fiber:
            if state not in channel.language:
                decode_ok = False
                failures.append("decode(%r) yielded %r, which is not a state of %r" % (code, state, channel.language.name))
                continue
            if state in covered:
                partition_ok = False
                failures.append("state %r appears in two fibers" % (state,))
            covered[state] = code
        if len(set(fiber)) != len(fiber):
            partition_ok = False
            failures.append("fiber of %r has a duplicate" % (code,))
        expected = tuple(s for s in channel.language.states if s in set(fiber))
        if fiber != expected:
            order_ok = False
            failures.append("fiber of %r is not in language order" % (code,))
        recomputed = tuple(s for s in channel.language.states if channel.encode(s, local) == code)
        if fiber != recomputed:
            partition_ok = False
            failures.append("fiber of %r disagrees with the recomputed preimage" % (code,))
    if len(covered) != len(channel.language):
        partition_ok = False
        failures.append(
            "fibers cover %d of %d states -- decode is not returning fibers"
            % (len(covered), len(channel.language))
        )
    return ValidationReport(
        channel=channel.name,
        language=channel.language.name,
        decode_returns_fiber=decode_ok,
        fibers_partition=partition_ok,
        fibers_deterministic=order_ok,
        failures=tuple(failures),
    )


# --------------------------------------------------------------------------
# combinators
# --------------------------------------------------------------------------


def restrict(channel: Channel, language: Language, name: Optional[str] = None, **overrides) -> Channel:
    """The same projection, a different declared language.

    This is the operation that makes "injective on a declared sublanguage,
    lossy on the ambient one" a single object seen twice rather than two
    channels telling different stories.
    """
    for state in language.states:
        if state not in channel.language:
            raise ChannelError("restrict: %r is outside %r" % (state, channel.language.name))
    settings = dict(
        description=channel.description,
        declares_injective=channel.declares_injective,
        claim=channel.claim,
        claim_justification=channel.claim_justification,
        inverse=channel._inverse,
        encode_cost=channel.encode_cost,
    )
    settings.update(overrides)
    return Channel(
        name=name or ("%s|%s" % (channel.name, language.name)),
        language=language,
        encoder=channel._encoder,
        **settings,
    )


def product_channel(left: Channel, right: Channel, name: Optional[str] = None) -> Channel:
    """Two channels read side by side.  Fibers are intersections.

    `runtime/distinguish/` step 4 installs a *set* of channels; this is that
    set, as one object, so that all the certificates apply to it unchanged.
    """
    if left.language is not right.language:
        raise ChannelError("product_channel: channels must share a declared language")
    encoder = lambda state: (left._encoder(state), right._encoder(state))  # noqa: E731
    return Channel(
        name=name or ("%s*%s" % (left.name, right.name)),
        language=left.language,
        encoder=encoder,
        description="product of %s and %s" % (left.name, right.name),
        encode_cost=left.encode_cost + right.encode_cost,
    )


def refines(finer: Channel, coarser: Channel, counter: Optional[StepCounter] = None) -> bool:
    """Does ``finer`` separate everything ``coarser`` separates?

    A class-count identity, so it is O(|L|) rather than O(|L|^2): the product
    of the two codes induces the same partition as ``finer`` alone exactly when
    ``finer`` refines ``coarser``.
    """
    if finer.language is not coarser.language:
        raise ChannelError("refines: channels must share a declared language")
    local = _counter(counter)
    fine = set()
    both = set()
    for state in finer.language.states:
        local.tick("refines")
        a = finer.encode(state, local)
        fine.add(a)
        both.add((a, coarser.encode(state, local)))
    return len(fine) == len(both)


__all__ = [
    "CLAIM_KINDS",
    "Channel",
    "ChannelError",
    "ClaimCertificate",
    "CollisionWitness",
    "INFORMATION_GAIN",
    "InjectivityCertificate",
    "Language",
    "LossCertificate",
    "NullCounter",
    "PreservationCertificate",
    "RECOGNITION_COST",
    "RoundTripCertificate",
    "StepCounter",
    "Task",
    "ValidationReport",
    "certify_claim",
    "certify_injectivity",
    "certify_loss",
    "certify_preservation",
    "certify_round_trip",
    "product_channel",
    "refines",
    "restrict",
    "validate_channel",
]
