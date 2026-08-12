#!/usr/bin/env python3
"""The chromatic channel: colour as an exact, layered, reversible projection.

Standing direction: *"chromatic topological symbolic synthetic synesthesia"*,
and *"colour is not decorative if it carries a stable, reversible semantic
projection"*.  This module is the second half of that sentence made
mechanical.

### 1. Colour is exact

No float touches a semantic path.  A colour is a triple of integers in
``0..255``.  Where a perceptual notion is needed -- "are these two colours far
enough apart to be told apart" -- the computation happens in an **exact
rational opponent space**:

    Y  = (299 R + 587 G + 114 B) / 1000      (Rec.601 luma, exact rationals)
    Co = (R - B) / 2
    Cg = (2G - R - B) / 4

and the inverse is exact:

    S  = 2Y - (37/100) Co - (587/250) Cg     (= R + B)
    R  = S/2 + Co,   B = S/2 - Co,   G = 2Cg + S/2

**What is approximated, and how.**  This is *not* CIELAB.  CIELAB's
lightness step is a cube root, which has no exact rational form, so it is not
approximated here -- it is **replaced** by a linear surrogate that is exactly
computable in Q.  The consequences, stated rather than buried:

* the surrogate is a *linear* transform of gamma-encoded sRGB, so it inherits
  sRGB's own nonlinearity and is not perceptually uniform;
* distances are comparable to each other in the surrogate, and the ordering of
  two colour pairs under the surrogate is **not guaranteed** to match their
  ordering under CIELAB;
* every distinguishability *proof* in this package rests on exact code
  inequality (integers being different), never on the surrogate.  The surrogate
  supplies a *measured* minimum separation, reported as a measurement, and the
  two are never conflated.

The weighted squared distance uses declared integer weights
``OPPONENT_WEIGHTS = (4, 1, 1)`` on ``(Y, Co, Cg)``: luma differences are
weighted four times chroma differences, which is a stated modelling choice,
not a derived fact.

### 2. Colour is layered, with an explicit precedence

A term may receive colour from several independent layers.  In ascending
precedence:

| # | layer | what it reads |
|---|---|---|
| 0 | ``ancestry`` | position in the term DAG -- the **lexical/syntactic** layer |
| 1 | ``sort``     | the sort/type of the node |
| 2 | ``family``   | the dependency family the object belongs to |
| 3 | ``symmetry`` | which automorphism orbit (symmetry sector) it lies in |
| 4 | ``semantic`` | an explicit override attached to the object's meaning |

Composition is **component-wise, in ascending precedence**: every layer
proposes a whole colour but contributes only the opponent components it
*claims*, and a higher-precedence layer overwrites the components it claims.
A layer may decline (return ``None``) for a given state, in which case lower
layers show through -- so precedence is visible in the rendered artifact, not
just in the code.

**Semantic beats lexical.**  The direction's own example is the test: the
lexical layer maps the letter ``b`` to yellow, so the token ``beta`` renders
yellow; the token ``blue`` renders *blue*, because the semantic layer claims
all three components and sits above the lexical one.  ``certify_precedence``
recomputes every resolution by an independent descending-precedence walk and
also checks each layer's declared precedence against the canonical table, so a
channel wired with lexical above semantic is caught twice.

### 3. Distinguishability is proved, not hoped

``certify_distinguishability`` runs the exhaustive pair check of
`channel.certify_preservation` over the declared state set -- codes assigned to
states a declared task must distinguish are pairwise distinct, and codes for
task-equivalent states are *allowed* to collide -- and then measures the exact
minimum surrogate separation between codes of different task classes.  This
makes the chromatic channel **task-relative**, the same discipline
`runtime/distinguish/` uses.  Nothing is imported from that package.

### 4. The mathematics rendered

The state model is `notes/DIGIT_CRYSTAL.md` §0-§1: little-endian base-``b``
digit words, with the odometer ``T`` (v -> v+1), the digit complement
``E`` (c_i -> b-1-c_i, i.e. v -> b^n-1-v, Props 1.2/1.3) and word reversal
``D`` (§1.1, deliberately *not* an odometer action).  The layers are built
from that mathematics: the family layer reads the carry cocycle's carry count,
the symmetry layer reads the Klein-four orbit of Thm 3.1/3.4, and the semantic
layer marks the loci those theorems single out.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from typing import Callable, Optional, Sequence

from .channel import (
    Channel,
    Language,
    PreservationCertificate,
    StepCounter,
    Task,
    certify_preservation,
)

# --------------------------------------------------------------------------
# 1. exact colour
# --------------------------------------------------------------------------

CHANNEL_MAX = 255
LUMA_R, LUMA_G, LUMA_B, LUMA_DEN = 299, 587, 114, 1000
COMPONENTS = ("Y", "Co", "Cg")
OPPONENT_WEIGHTS = (4, 1, 1)


class ChromaError(Exception):
    """Raised on an ill-formed colour, layer stack or precedence."""


@dataclass(frozen=True, order=True)
class RGB:
    """An exact 8-bit colour.  Three integers, nothing else."""

    r: int
    g: int
    b: int

    def __post_init__(self) -> None:
        for name in ("r", "g", "b"):
            value = getattr(self, name)
            if not isinstance(value, int) or isinstance(value, bool):
                raise ChromaError("colour component %s = %r is not an int" % (name, value))
            if value < 0 or value > CHANNEL_MAX:
                raise ChromaError("colour component %s = %d out of range" % (name, value))

    def hex(self) -> str:
        return "#%02x%02x%02x" % (self.r, self.g, self.b)

    def as_tuple(self) -> tuple:
        return (self.r, self.g, self.b)


def to_opponent(colour: RGB) -> tuple:
    """Exact (Y, Co, Cg) as ``Fraction``s."""
    y = Fraction(LUMA_R * colour.r + LUMA_G * colour.g + LUMA_B * colour.b, LUMA_DEN)
    co = Fraction(colour.r - colour.b, 2)
    cg = Fraction(2 * colour.g - colour.r - colour.b, 4)
    return (y, co, cg)


def round_half_even(value: Fraction) -> int:
    """Exact round-half-to-even.  Integer arithmetic only; no division."""
    num, den = value.numerator, value.denominator
    quotient, remainder = divmod(num, den)
    twice = 2 * remainder
    if twice > den:
        quotient += 1
    elif twice == den and quotient % 2 == 1:
        quotient += 1
    return quotient


def _clamp(value: int) -> tuple:
    if value < 0:
        return (0, True)
    if value > CHANNEL_MAX:
        return (CHANNEL_MAX, True)
    return (value, False)


def from_opponent(y: Fraction, co: Fraction, cg: Fraction) -> tuple:
    """Exact inverse, then a *documented* quantisation.

    Returns ``(RGB, clamped)``.  Two losses happen here and both are reported
    rather than hidden: rounding a rational to 8 bits (round-half-even), and
    clamping a component that the layer composition pushed outside the sRGB
    cube.  A composition that never clamps is stated as such; one that clamps
    has its clamp count printed.
    """
    s = 2 * y - Fraction(37, 100) * co - Fraction(587, 250) * cg
    half = Fraction(1, 2) * s
    raw = (half + co, 2 * cg + half, half - co)
    clamped = False
    parts = []
    for component in raw:
        value, hit = _clamp(round_half_even(component))
        clamped = clamped or hit
        parts.append(value)
    return (RGB(parts[0], parts[1], parts[2]), clamped)


CHROMA_WEIGHTS = (0, 1, 1)


def separation(left: RGB, right: RGB, weights: Sequence = OPPONENT_WEIGHTS) -> Fraction:
    """Weighted squared distance in the exact opponent surrogate.

    A *measurement*, never a proof.  Proofs use code inequality.  ``weights``
    is declared, not derived: ``OPPONENT_WEIGHTS`` weights luma four times
    chroma, ``CHROMA_WEIGHTS`` ignores luma entirely and is used to build
    palettes that survive a layer which overwrites Y.
    """
    a = to_opponent(left)
    b = to_opponent(right)
    total = Fraction(0)
    for weight, x, y in zip(weights, a, b):
        difference = x - y
        total += weight * difference * difference
    return total


def luma(colour: RGB) -> Fraction:
    return to_opponent(colour)[0]


def text_on(colour: RGB) -> RGB:
    """Black or white, whichever has the larger exact luma gap.  Exact."""
    return RGB(0, 0, 0) if luma(colour) >= Fraction(CHANNEL_MAX, 2) else RGB(255, 255, 255)


# --------------------------------------------------------------------------
# 2. palettes -- deterministic, exact, no randomness
# --------------------------------------------------------------------------

LATTICE = (0, 51, 102, 153, 204, 255)


def lattice_colours() -> tuple:
    """The 216 colours of the web-safe lattice, in a fixed order."""
    return tuple(RGB(r, g, b) for r in LATTICE for g in LATTICE for b in LATTICE)


def categorical_palette(
    size: int,
    seed: Optional[RGB] = None,
    counter: Optional[StepCounter] = None,
    weights: Sequence = OPPONENT_WEIGHTS,
) -> tuple:
    """Greedy farthest-point selection on the lattice, in the exact surrogate.

    Deterministic: the pool is enumerated in a fixed lexicographic order and
    the first candidate attaining the maximum minimum-distance wins, so ties
    resolve to the lexicographically least colour.  Categorical, so the palette
    carries *no* implied order -- use it only for unordered sectors.
    """
    if size < 1:
        raise ChromaError("palette size must be positive")
    pool = lattice_colours()
    if size > len(pool):
        raise ChromaError("palette of %d exceeds the %d-colour lattice" % (size, len(pool)))
    chosen = [seed if seed is not None else RGB(0, 0, 0)]
    if chosen[0] not in pool:
        raise ChromaError("palette seed %r is off the lattice" % (chosen[0],))
    while len(chosen) < size:
        best = None
        best_distance = Fraction(-1)
        for candidate in pool:
            if candidate in chosen:
                continue
            nearest = None
            for picked in chosen:
                if counter is not None:
                    counter.tick("chroma.palette_distance")
                distance = separation(candidate, picked, weights)
                if nearest is None or distance < nearest:
                    nearest = distance
            if nearest > best_distance:
                best_distance = nearest
                best = candidate
        chosen.append(best)
    return tuple(chosen)


def hue_palette(size: int, counter: Optional[StepCounter] = None) -> tuple:
    """A palette chosen for chroma separation alone (``CHROMA_WEIGHTS``).

    Used where a higher-precedence layer claims ``Y``: a palette selected for
    total distance can contain two colours differing only in luma, and such a
    pair is *identified* the moment a sort layer overwrites Y.  That is a real
    loss introduced by layering rather than by the mathematics, and choosing
    the palette in the chroma plane is how this package avoids it.  Whether it
    succeeded is not assumed -- ``certify_preservation`` against the ancestry
    task decides.
    """
    return categorical_palette(size, RGB(0, 0, 0), counter, CHROMA_WEIGHTS)


def sequential_ramp(size: int, low: RGB, high: RGB) -> tuple:
    """An ordered ramp: exact rational interpolation in the opponent space.

    An ordered quantity gets an ordered palette, so the picture encodes
    magnitude order.  **A reader may misread it**: equal colour steps do not
    mean equal magnitude steps, because the surrogate is linear in opponent
    coordinates and not perceptually uniform.  Stated here and again in the
    rendered artifact's caption.
    """
    if size < 2:
        raise ChromaError("a ramp needs at least two stops")
    a = to_opponent(low)
    b = to_opponent(high)
    stops = []
    for index in range(size):
        t = Fraction(index, size - 1)
        parts = tuple(a[k] + t * (b[k] - a[k]) for k in range(3))
        colour, _ = from_opponent(parts[0], parts[1], parts[2])
        stops.append(colour)
    if len(set(stops)) != len(stops):
        raise ChromaError("ramp of %d stops is not injective after quantisation" % (size,))
    return tuple(stops)


# --------------------------------------------------------------------------
# 3. layers and precedence
# --------------------------------------------------------------------------

CANONICAL_PRECEDENCE = {
    "ancestry": 0,
    "sort": 1,
    "family": 2,
    "symmetry": 3,
    "semantic": 4,
}
LAYER_ROLES = tuple(sorted(CANONICAL_PRECEDENCE, key=lambda name: CANONICAL_PRECEDENCE[name]))


@dataclass(frozen=True)
class Layer:
    """One independent source of colour.

    ``role`` is one of ``LAYER_ROLES``.  ``precedence`` is stored explicitly so
    that a *wrong* precedence is representable -- and therefore catchable by
    ``certify_precedence`` rather than made impossible by construction.  A
    discipline nothing can violate is a discipline nothing tests.

    ``claims`` is the set of opponent components this layer contributes.  A
    layer that claims a proper subset is a genuine partial layer: it tints
    without repainting.
    """

    role: str
    fn: Callable
    claims: frozenset
    precedence: int
    label: str = ""

    def __post_init__(self) -> None:
        if self.role not in CANONICAL_PRECEDENCE:
            raise ChromaError("unknown layer role %r" % (self.role,))
        if not self.claims or not self.claims <= frozenset(COMPONENTS):
            raise ChromaError("layer %r claims %r" % (self.role, sorted(self.claims)))

    def propose(self, state) -> Optional[RGB]:
        return self.fn(state)


def layer(role: str, fn: Callable, claims: Sequence = COMPONENTS, label: str = "", precedence: Optional[int] = None) -> Layer:
    return Layer(
        role=role,
        fn=fn,
        claims=frozenset(claims),
        precedence=CANONICAL_PRECEDENCE[role] if precedence is None else precedence,
        label=label,
    )


@dataclass(frozen=True)
class Resolution:
    """One state's colour, plus the full audit of how it got there."""

    colour: RGB
    winners: tuple  # (("Y", role), ("Co", role), ("Cg", role)) in COMPONENTS order
    proposals: tuple  # ((role, RGB|None), ...) in ascending precedence
    clamped: bool

    def winner(self, component: str) -> str:
        for name, role in self.winners:
            if name == component:
                return role
        raise ChromaError("no winner recorded for %r" % (component,))

    def dominant(self) -> str:
        """The highest-precedence role that contributed anything."""
        best = None
        for _, role in self.winners:
            if best is None or CANONICAL_PRECEDENCE[role] > CANONICAL_PRECEDENCE[best]:
                best = role
        return best


@dataclass(frozen=True)
class PrecedenceCertificate:
    channel: str
    states_checked: int
    canonical_order: bool
    independent_agreement: bool
    semantic_fires: int
    semantic_dominates: int
    violations: tuple

    @property
    def ok(self) -> bool:
        return self.canonical_order and self.independent_agreement and not self.violations


class ChromaticChannel:
    """A layered chromatic projection of a declared language."""

    def __init__(self, name: str, language: Language, layers: Sequence[Layer], description: str = "") -> None:
        if not layers:
            raise ChromaError("%s: a chromatic channel needs at least one layer" % (name,))
        ordered = tuple(sorted(layers, key=lambda item: (item.precedence, item.role)))
        roles = [item.role for item in ordered]
        if len(set(roles)) != len(roles):
            raise ChromaError("%s: duplicate layer role" % (name,))
        self.name = name
        self.language = language
        self.layers = ordered
        self.description = description
        # Coverage, checked at construction over the whole declared language:
        # every state must end up with all three opponent components claimed by
        # *some* layer that did not decline.  A stack that leaves a component
        # unset is not a channel and must not exist, so it is refused here
        # rather than raising a KeyError at render time.
        for state in language.states:
            covered = set()
            for item in ordered:
                if item.propose(state) is not None:
                    covered |= item.claims
            missing = frozenset(COMPONENTS) - covered
            if missing:
                raise ChromaError(
                    "%s: no layer supplies %s for state %r"
                    % (name, ",".join(sorted(missing)), state)
                )

    # -- resolution -------------------------------------------------------

    def resolve(self, state, counter: Optional[StepCounter] = None) -> Resolution:
        parts: dict = {}
        winners: dict = {}
        proposals = []
        for item in self.layers:
            if counter is not None:
                counter.tick("chroma.layer")
            proposal = item.propose(state)
            proposals.append((item.role, proposal))
            if proposal is None:
                continue
            components = to_opponent(proposal)
            for index, name in enumerate(COMPONENTS):
                if name in item.claims:
                    parts[name] = components[index]
                    winners[name] = item.role
        colour, clamped = from_opponent(parts["Y"], parts["Co"], parts["Cg"])
        return Resolution(
            colour=colour,
            winners=tuple((name, winners[name]) for name in COMPONENTS),
            proposals=tuple(proposals),
            clamped=clamped,
        )

    def colour(self, state, counter: Optional[StepCounter] = None) -> RGB:
        return self.resolve(state, counter).colour

    # -- as a channel -----------------------------------------------------

    def channel(self, **overrides) -> Channel:
        """Wrap as a `channel.Channel`, so every certificate applies unchanged."""
        settings = dict(
            name=self.name,
            language=self.language,
            encoder=lambda state: self.resolve(state).colour,
            description=self.description,
            encode_cost=len(self.layers),
        )
        settings.update(overrides)
        return Channel(**settings)


def certify_precedence(
    chroma: ChromaticChannel, counter: Optional[StepCounter] = None
) -> PrecedenceCertificate:
    """Two independent checks that precedence is what it says it is.

    1. **Canonical order** -- each layer's declared precedence equals the
       canonical precedence for its role.  A stack wired with ``semantic``
       below ``ancestry`` fails here.
    2. **Independent agreement** -- every resolution is recomputed by a
       *descending*-precedence walk (first claimant of each component wins) and
       must agree with ``resolve``'s ascending walk, colour for colour.
    3. **Semantic dominance** -- wherever the semantic layer proposes, it wins
       every component and the resolved colour is exactly its proposal.

    Recorded as counts and witnesses, never raised: a violation is data.
    """
    violations = []
    canonical = True
    for item in chroma.layers:
        if item.precedence != CANONICAL_PRECEDENCE[item.role]:
            canonical = False
            violations.append(
                "layer %r declares precedence %d, canonical is %d"
                % (item.role, item.precedence, CANONICAL_PRECEDENCE[item.role])
            )
    descending = tuple(reversed(chroma.layers))
    agreement = True
    fires = 0
    dominates = 0
    for state in chroma.language.states:
        if counter is not None:
            counter.tick("chroma.precedence")
        resolution = chroma.resolve(state, counter)
        parts: dict = {}
        for item in descending:
            proposal = item.propose(state)
            if proposal is None:
                continue
            components = to_opponent(proposal)
            for index, name in enumerate(COMPONENTS):
                if name in item.claims and name not in parts:
                    parts[name] = components[index]
        independent, _ = from_opponent(parts["Y"], parts["Co"], parts["Cg"])
        if independent != resolution.colour:
            agreement = False
            violations.append(
                "state %r: ascending walk gives %s, descending walk gives %s"
                % (state, resolution.colour.hex(), independent.hex())
            )
        semantic = None
        for item in chroma.layers:
            if item.role == "semantic":
                semantic = item.propose(state)
        if semantic is not None:
            fires += 1
            if resolution.colour == semantic and all(role == "semantic" for _, role in resolution.winners):
                dominates += 1
            else:
                violations.append(
                    "state %r: semantic proposes %s but resolves to %s (winners %r)"
                    % (state, semantic.hex(), resolution.colour.hex(), resolution.winners)
                )
    return PrecedenceCertificate(
        channel=chroma.name,
        states_checked=len(chroma.language),
        canonical_order=canonical,
        independent_agreement=agreement,
        semantic_fires=fires,
        semantic_dominates=dominates,
        violations=tuple(violations),
    )


# --------------------------------------------------------------------------
# 4. distinguishability, proved and measured
# --------------------------------------------------------------------------


@dataclass(frozen=True)
class DistinguishabilityCertificate:
    channel: str
    task: str
    distinguishable: bool
    task_classes: int
    codes: int
    min_separation: Fraction
    threshold: Fraction
    separation_ok: bool
    preservation: PreservationCertificate

    def render(self) -> str:
        return (
            "%s / %s: separations required %d, violations %d, permitted collisions %d, "
            "over-separations %d; min surrogate separation %s (threshold %s)"
            % (
                self.channel,
                self.task,
                self.preservation.required_separations,
                self.preservation.violations,
                self.preservation.permitted_collisions,
                self.preservation.over_separations,
                self.min_separation,
                self.threshold,
            )
        )


def certify_distinguishability(
    channel: Channel,
    task: Task,
    threshold: Fraction = Fraction(0),
    counter: Optional[StepCounter] = None,
) -> DistinguishabilityCertificate:
    """Exhaustive proof + exact surrogate measurement.

    The *proof* is code inequality over every unordered pair the task
    distinguishes.  The *measurement* is the minimum weighted opponent
    distance between codes of different task classes.  They are reported
    separately because they are different kinds of statement: one is a fact
    about integers, the other is a number in a surrogate space that is not
    CIELAB and does not license a claim about human vision.
    """
    preservation = certify_preservation(channel, task, counter)
    classes: dict = {}
    for state in channel.language.states:
        answer = task(state, counter)
        classes.setdefault(answer, set()).add(channel.encode(state, counter))
    keys = sorted(classes)
    minimum = None
    for i in range(len(keys)):
        for j in range(i + 1, len(keys)):
            for left in sorted(classes[keys[i]]):
                for right in sorted(classes[keys[j]]):
                    if counter is not None:
                        counter.tick("chroma.separation")
                    distance = separation(left, right)
                    if minimum is None or distance < minimum:
                        minimum = distance
    if minimum is None:
        minimum = Fraction(0)
    codes = len(set().union(*classes.values())) if classes else 0
    return DistinguishabilityCertificate(
        channel=channel.name,
        task=task.name,
        distinguishable=preservation.preserved,
        task_classes=len(keys),
        codes=codes,
        min_separation=minimum,
        threshold=threshold,
        separation_ok=minimum >= threshold,
        preservation=preservation,
    )


# --------------------------------------------------------------------------
# 5. the state model: base-b digit words (notes/DIGIT_CRYSTAL.md §0-§1)
# --------------------------------------------------------------------------


def digit_words(base: int, length: int) -> tuple:
    """Every little-endian word of length ``length``, ordered by value L(w)."""
    if base < 2 or length < 1:
        raise ChromaError("base >= 2 and length >= 1 required")
    words = []
    for value in range(base ** length):
        words.append(word_of(value, base, length))
    return tuple(words)


def word_of(value: int, base: int, length: int) -> tuple:
    digits = []
    rest = value
    for _ in range(length):
        digits.append(rest % base)
        rest = rest // base
    return tuple(digits)


def value_of(word: Sequence, base: int) -> int:
    """L(w) = sum c_i b^i (DIGIT_CRYSTAL §0, little-endian, fixed once)."""
    total = 0
    for digit in reversed(word):
        total = total * base + digit
    return total


def carry_count(word: Sequence, base: int) -> int:
    """c_n(w): trailing (b-1) digits = the number of carries produced by T.

    DIGIT_CRYSTAL (2.1): s(x+1) - s(x) = 1 - (b-1) c_n(x) for x < b^n - 1.
    Equivalently c_n(x) = v_b(x+1), the b-adic valuation of the successor.
    """
    count = 0
    for digit in word:
        if digit != base - 1:
            break
        count += 1
    return count


def borrow_count(word: Sequence, base: int) -> int:
    """z_n(w): trailing zero digits = the borrows produced by T^-1 = v_b(x)."""
    count = 0
    for digit in word:
        if digit != 0:
            break
        count += 1
    return count


def complement_word(word: Sequence, base: int) -> tuple:
    """E: c_i -> b-1-c_i, i.e. v -> b^n-1-v (DIGIT_CRYSTAL Props 1.2/1.3)."""
    return tuple(base - 1 - digit for digit in word)


def reverse_word(word: Sequence) -> tuple:
    """D: word reversal (DIGIT_CRYSTAL §1.1).  Not an odometer action."""
    return tuple(reversed(tuple(word)))


def is_palindrome(word: Sequence) -> bool:
    return tuple(word) == reverse_word(word)


def is_antipalindrome(word: Sequence, base: int) -> bool:
    return tuple(word) == reverse_word(complement_word(word, base))


def is_constant_word(word: Sequence) -> bool:
    """The agreement locus of DIGIT_CRYSTAL Thm 4.2(2): pi R = R pi exactly here."""
    return len(set(word)) == 1


def klein_orbit(word: Sequence, base: int) -> tuple:
    """The <D,E> orbit (Klein four for n >= 2, DIGIT_CRYSTAL Thm 3.1)."""
    word = tuple(word)
    members = {word, reverse_word(word), complement_word(word, base), reverse_word(complement_word(word, base))}
    return tuple(sorted(members))


def orbit_size(word: Sequence, base: int) -> int:
    return len(klein_orbit(word, base))


def sector_name(word: Sequence, base: int) -> str:
    """Which symmetry sector: the stabiliser type in <D,E>."""
    palindrome = is_palindrome(word)
    antipalindrome = is_antipalindrome(word, base)
    if palindrome and antipalindrome:
        return "fix-both"
    if palindrome:
        return "palindrome"
    if antipalindrome:
        return "antipalindrome"
    return "generic"


SECTORS = ("antipalindrome", "fix-both", "generic", "palindrome")


# --------------------------------------------------------------------------
# 6. the concrete layers over digit words
# --------------------------------------------------------------------------

EXCEPTION_COLOUR = RGB(255, 0, 102)
AGREEMENT_COLOUR = RGB(0, 255, 255)


def digit_language(base: int, length: int) -> Language:
    return Language("W_%d^%d" % (base, length), digit_words(base, length))


def ancestry_layer(base: int, palette: Optional[Sequence] = None) -> Layer:
    """Position in the term DAG -- the lexical layer, and the lowest one.

    DIGIT_CRYSTAL Lemma 0.1: Phi(w) = gamma_{c_0} o ... o gamma_{c_{n-1}}, so
    the *outermost* constructor of the construction is gamma_{c_0}.  The
    ancestry colour is the palette entry of that root label: which subtree of
    the term DAG the word lies in at depth 0.  Purely syntactic -- exactly the
    kind of colour a semantic override is entitled to beat.
    """
    colours = tuple(palette) if palette is not None else hue_palette(base)
    if len(colours) < base:
        raise ChromaError("ancestry palette too small")
    return layer("ancestry", lambda word: colours[word[0]], COMPONENTS, "root constructor gamma_{c_0}")


def sort_layer(sort_of: Callable, table: dict, claims: Sequence = ("Y",)) -> Layer:
    """The sort/type layer.  Partial by design: it declines on unknown sorts."""
    return layer("sort", lambda state: table.get(sort_of(state)), claims, "sort")


def family_layer(count_of: Callable, ramp: Sequence, label: str, claims: Sequence = COMPONENTS) -> Layer:
    """Dependency family: the ordered count the object belongs to."""
    stops = tuple(ramp)
    return layer("family", lambda state: stops[count_of(state)], claims, label)


def symmetry_layer(base: int, table: dict) -> Layer:
    """Symmetry sector -- partial: it declines on generic orbits, so the
    ancestry layer shows through and the layering is visible in the picture."""
    return layer("symmetry", lambda word: table.get(sector_name(word, base)), COMPONENTS, "<D,E> sector")


def semantic_layer(table: dict, label: str = "semantic override") -> Layer:
    """The explicit override, top of the stack."""
    return layer("semantic", lambda state: table.get(state), COMPONENTS, label)


def carry_ramp(length: int) -> tuple:
    return sequential_ramp(length + 1, RGB(0, 51, 102), RGB(255, 255, 204))


def carry_chroma(base: int, length: int, language: Optional[Language] = None) -> ChromaticChannel:
    """Colour = the carry count of the odometer, with the exceptional state
    of cocycle (2.1) marked by the semantic layer."""
    language = language or digit_language(base, length)
    ramp = carry_ramp(length)
    top = tuple([base - 1] * length)
    return ChromaticChannel(
        name="chroma_carry",
        language=language,
        layers=(
            ancestry_layer(base),
            sort_layer(lambda word: "Word", {"Word": RGB(128, 128, 128)}),
            family_layer(lambda word: carry_count(word, base), ramp, "carry count c_n"),
            semantic_layer({top: EXCEPTION_COLOUR}, "cocycle (2.1) exceptional state"),
        ),
        description="carry count c_n(w) = v_b(L(w)+1), DIGIT_CRYSTAL (2.1)",
    )


def borrow_chroma(base: int, length: int, language: Optional[Language] = None) -> ChromaticChannel:
    """The same construction reading z_n instead of c_n.  Identical palette,
    identical layer stack, so any difference between the two pictures is
    mathematics and not styling."""
    language = language or digit_language(base, length)
    ramp = carry_ramp(length)
    bottom = tuple([0] * length)
    return ChromaticChannel(
        name="chroma_borrow",
        language=language,
        layers=(
            ancestry_layer(base),
            sort_layer(lambda word: "Word", {"Word": RGB(128, 128, 128)}),
            family_layer(lambda word: borrow_count(word, base), ramp, "borrow count z_n"),
            semantic_layer({bottom: EXCEPTION_COLOUR}, "borrow exceptional state"),
        ),
        description="borrow count z_n(w) = v_b(L(w)), DIGIT_CRYSTAL (2.2)",
    )


def sector_palette() -> dict:
    return {
        "palindrome": RGB(255, 153, 0),
        "antipalindrome": RGB(153, 0, 255),
        "fix-both": RGB(255, 255, 255),
    }


def orbit_chroma(base: int, length: int, language: Optional[Language] = None) -> ChromaticChannel:
    """Colour = the symmetry sector, with the reversal-defect agreement locus
    (DIGIT_CRYSTAL Thm 4.2(2)) marked by the semantic layer."""
    language = language or digit_language(base, length)
    constants = {word: AGREEMENT_COLOUR for word in language.states if is_constant_word(word)}
    return ChromaticChannel(
        name="chroma_orbit",
        language=language,
        layers=(
            ancestry_layer(base),
            sort_layer(lambda word: "Word", {"Word": RGB(102, 102, 102)}),
            symmetry_layer(base, sector_palette()),
            semantic_layer(constants, "Thm 4.2(2) agreement locus"),
        ),
        description="<D,E> symmetry sectors, DIGIT_CRYSTAL Thm 3.1/3.4",
    )


def low_sublanguage(base: int, length: int, language: Optional[Language] = None) -> Language:
    """The declared sublanguage on which the low-word channel is injective:
    words whose digits above position 1 all vanish, i.e. L(w) < b^2."""
    language = language or digit_language(base, length)
    return language.sublanguage(
        "W_%d^%d[low2]" % (base, length),
        lambda word: all(digit == 0 for digit in word[2:]),
    )


def low_word_palette(base: int) -> tuple:
    return categorical_palette(base * base)


def low_word_chroma(base: int, length: int, language: Optional[Language] = None) -> ChromaticChannel:
    """Ancestry at DAG depth 2: the two outermost constructors of Phi(w).

    A single total layer, so the code is exactly ``palette[c_0 + b c_1]``.  On
    the sublanguage ``low_sublanguage`` this is a bijection and the round trip
    is exact; on the full word language it is b^(n-2)-to-one, and the collision
    witness is produced by exhaustive check rather than asserted.
    """
    if length < 2:
        raise ChromaError("the low-word channel needs length >= 2")
    language = language or digit_language(base, length)
    colours = low_word_palette(base)
    return ChromaticChannel(
        name="chroma_low2",
        language=language,
        layers=(
            layer(
                "ancestry",
                lambda word: colours[word[0] + base * word[1]],
                COMPONENTS,
                "gamma_{c_0} o gamma_{c_1}",
            ),
        ),
        description="syntactic ancestry at depth 2 of the term DAG",
    )


def low_word_inverse(base: int, length: int) -> Callable:
    """The implemented inverse.  Its correctness is *checked*, not declared."""
    colours = low_word_palette(base)
    table = {colour: index for index, colour in enumerate(colours)}
    if len(table) != len(colours):
        raise ChromaError("low-word palette is not injective")

    def inverse(colour: RGB) -> tuple:
        index = table[colour]
        return tuple([index % base, index // base] + [0] * (length - 2))

    return inverse


# --------------------------------------------------------------------------
# 7. the lexical-vs-semantic exhibit (the direction's own example)
# --------------------------------------------------------------------------

YELLOW = RGB(255, 204, 0)
LEXICAL_TABLE = {
    "b": YELLOW,
    "r": RGB(0, 204, 204),
    "g": RGB(204, 0, 204),
    "d": RGB(255, 102, 0),
}
LEXICAL_DEFAULT = RGB(153, 153, 153)
COLOUR_WORDS = {
    "blue": RGB(0, 0, 255),
    "red": RGB(255, 0, 0),
    "green": RGB(0, 153, 0),
}


@dataclass(frozen=True, order=True)
class Token:
    """A named node: a name (a *view*, per kernel L0) plus a sort."""

    name: str
    sort: str


def token_language(tokens: Sequence) -> Language:
    return Language("tokens", tuple(tokens))


def token_chroma(tokens: Sequence) -> ChromaticChannel:
    """Lexical ancestry vs. semantic override, with a partial sort layer.

    * ancestry (lexical): first letter of the name.  ``b`` -> yellow.
    * sort: declines on ``Word``; tints only ``Digit`` nodes, and claims Y
      alone, so it darkens without repainting.
    * semantic: colour words.  Claims all three components, so ``blue``
      renders blue even though ``b`` is yellow.
    """
    language = token_language(tokens)
    semantic = {token: COLOUR_WORDS[token.name] for token in language.states if token.name in COLOUR_WORDS}
    return ChromaticChannel(
        name="chroma_token",
        language=language,
        layers=(
            layer(
                "ancestry",
                lambda token: LEXICAL_TABLE.get(token.name[0], LEXICAL_DEFAULT),
                COMPONENTS,
                "first letter of the name",
            ),
            sort_layer(lambda token: token.sort, {"Digit": RGB(64, 64, 64)}, ("Y",)),
            semantic_layer(semantic, "colour words"),
        ),
        description="the direction's example: semantic override beats lexical",
    )


DEMO_TOKENS = (
    Token("beta", "Word"),
    Token("blue", "Word"),
    Token("delta", "Word"),
    Token("gamma_3", "Digit"),
    Token("green", "Word"),
    Token("red", "Word"),
)


__all__ = [
    "AGREEMENT_COLOUR",
    "CANONICAL_PRECEDENCE",
    "COLOUR_WORDS",
    "COMPONENTS",
    "DEMO_TOKENS",
    "DistinguishabilityCertificate",
    "EXCEPTION_COLOUR",
    "LATTICE",
    "LAYER_ROLES",
    "LEXICAL_TABLE",
    "OPPONENT_WEIGHTS",
    "PrecedenceCertificate",
    "RGB",
    "Resolution",
    "CHROMA_WEIGHTS",
    "SECTORS",
    "ChromaError",
    "ChromaticChannel",
    "Layer",
    "Token",
    "YELLOW",
    "ancestry_layer",
    "borrow_chroma",
    "borrow_count",
    "carry_chroma",
    "carry_count",
    "carry_ramp",
    "categorical_palette",
    "certify_distinguishability",
    "certify_precedence",
    "complement_word",
    "digit_language",
    "digit_words",
    "family_layer",
    "from_opponent",
    "hue_palette",
    "is_antipalindrome",
    "is_constant_word",
    "is_palindrome",
    "klein_orbit",
    "lattice_colours",
    "layer",
    "low_sublanguage",
    "low_word_chroma",
    "low_word_inverse",
    "low_word_palette",
    "luma",
    "orbit_chroma",
    "orbit_size",
    "reverse_word",
    "round_half_even",
    "sector_name",
    "sector_palette",
    "semantic_layer",
    "separation",
    "sequential_ramp",
    "sort_layer",
    "symmetry_layer",
    "text_on",
    "to_opponent",
    "token_chroma",
    "token_language",
    "value_of",
    "word_of",
]
