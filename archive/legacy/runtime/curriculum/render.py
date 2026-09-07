#!/usr/bin/env python3
"""Compile an ordering into artifacts a human can actually follow.

Built on ``runtime/render``: the chromatic channel, its exact rational
opponent space, its layer/precedence machinery and its hand-written integer-only
SVG writer are reused unchanged, so every colour in every picture here is the
*resolved* colour of a state and no picture can paint something the code did not
compute.  ``runtime/render`` has no HTML writer -- it deliberately implements
SVG only -- so the traversal document is written as plain HTML by hand, with the
SVGs inlined; that is the one place this module writes markup itself, and it is
said here rather than left to be discovered.

The chromatic centrepiece is ``choice_cube_channel``.  Its language is the eight
subsets of the three parameters of `ATLAS_OF_N.md` Theorem 4.2(2), and its three
layers claim **disjoint single opponent components**:

    base (the finite quotient)   -> Co
    endianness (the torsor)      -> Cg
    carry (the cocycle)          -> Y

so the three choices of positional notation are separable in the picture the way
they are separable in the theorem: independent, and each removable without
touching the others.  ``certify_separability`` proves it exactly -- flipping one
choice moves its own component by at least 60 and each other component by at
most 1, the quantisation bound.

No floats.  Integer geometry, ``Fraction`` colour arithmetic.
"""

from __future__ import annotations

import os
import sys
from dataclasses import dataclass
from fractions import Fraction
from typing import Dict, Optional, Sequence, Tuple

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from runtime.render.channel import Language, Task  # noqa: E402
from runtime.render.chroma import (  # noqa: E402
    COMPONENTS,
    RGB,
    ChromaticChannel,
    layer,
    sequential_ramp,
    text_on,
    to_opponent,
)
from runtime.render.svg import SVG, escape  # noqa: E402

from .depgraph import DependencyGraph  # noqa: E402
from .order import (  # noqa: E402
    Ordering,
    choice_debt,
    compare,
    levels,
    unordered_pairs,
    violations,
)

# --------------------------------------------------------------------------
# 0. the choice cube: three parameters, three separable channels
# --------------------------------------------------------------------------

#: (choice id, human name, the opponent component that carries it, the layer
#: role borrowed from ``runtime/render``'s five fixed roles).  The roles are
#: used here purely as three independent precedence slots; because the three
#: layers claim *disjoint* components, precedence never arbitrates anything and
#: the picture is precedence-free by construction.  That is checked, not
#: assumed (``certify_separability`` and ``certify_precedence``).
CHOICE_AXES = (
    ("base", "base b (a finite quotient N -> Z/b)", "Co", "ancestry"),
    ("endianness", "endianness (a trivialization of the Z/2-torsor)", "Cg", "family"),
    ("carry", "carry (a digit section with nonzero class in H^2)", "Y", "symmetry"),
)

#: Layer proposals.  Each pair is chosen so the layer's *claimed* component
#: takes two well-separated values while the components it does not claim are
#: never read.  Every one of the eight composites is inside the sRGB cube, so
#: nothing is clamped -- ``certify_separability`` reports the clamp count.
_BASE_PROPOSAL = (RGB(0, 0, 80), RGB(80, 0, 0))            # Co = -40, +40
_ENDIAN_PROPOSAL = (RGB(120, 0, 0), RGB(0, 60, 0))         # Cg = -30, +30
_CARRY_PROPOSAL = (RGB(110, 110, 110), RGB(170, 170, 170))  # Y  = 110, 170

#: Half of a unit of quantisation on each of R, G and B propagates to at most
#: 1/2 on each opponent component (the weights of Y sum to 1, Co is (R-B)/2 and
#: Cg is (2G-R-B)/4), so two *different* states differ by at most 1 in a
#: component that neither layer moved.
QUANTISATION_BOUND = Fraction(1)


def choice_states() -> Tuple[Tuple[int, int, int], ...]:
    """The eight subsets of {base, endianness, carry}, in a fixed order."""
    return tuple(
        (base, endian, carry)
        for base in (0, 1)
        for endian in (0, 1)
        for carry in (0, 1)
    )


def choice_language() -> Language:
    return Language("Choices(base, endianness, carry)", choice_states())


def choice_cube_channel(language: Optional[Language] = None) -> ChromaticChannel:
    language = choice_language() if language is None else language
    return ChromaticChannel(
        "choice_cube",
        language,
        (
            layer("ancestry", lambda s: _BASE_PROPOSAL[s[0]], ("Co",), "base -> Co"),
            layer("family", lambda s: _ENDIAN_PROPOSAL[s[1]], ("Cg",), "endianness -> Cg"),
            layer("symmetry", lambda s: _CARRY_PROPOSAL[s[2]], ("Y",), "carry -> Y"),
        ),
        "the three parameters of ATLAS_OF_N Theorem 4.2(2), one per opponent component",
    )


@dataclass(frozen=True)
class SeparabilityCertificate:
    """The exact statement the picture makes.

    ``own_minimum`` is the smallest change, over every state and every choice,
    in the component that choice claims.  ``cross_maximum`` is the largest
    change in a component that choice does *not* claim.  The claim is separable
    exactly when the first strictly exceeds the second, and the gap is printed
    rather than summarised.
    """

    channel: str
    states: int
    flips_checked: int
    own_minimum: Fraction
    cross_maximum: Fraction
    bound: Fraction
    disjoint_claims: bool
    clamped_states: int
    injective: bool
    failures: Tuple[str, ...]

    @property
    def separable(self) -> bool:
        return (
            not self.failures
            and self.disjoint_claims
            and self.injective
            and self.own_minimum > self.cross_maximum
            and self.cross_maximum <= self.bound
        )

    def render(self) -> str:
        return (
            "%s: %d states, %d flips; own component moves by >= %s, other components by <= %s "
            "(bound %s); disjoint claims %s; clamped %d; injective %s"
            % (
                self.channel,
                self.states,
                self.flips_checked,
                self.own_minimum,
                self.cross_maximum,
                self.bound,
                self.disjoint_claims,
                self.clamped_states,
                self.injective,
            )
        )


def certify_separability(chroma: ChromaticChannel) -> SeparabilityCertificate:
    """Prove the three choices are independently readable off the colour.

    Exhaustive over all eight states and all three flips per state -- 24 flips,
    every one checked, none sampled.  Two independent grounds:

    1. **Structural.** The three layers claim disjoint singleton sets of
       opponent components covering all three, so no two choices can ever
       compete for the same component.  A wrong wiring is representable and is
       caught here.
    2. **Measured.** For each state and each choice, the exact rational change
       in every opponent component of the *quantised, resolved* colour.  The
       claimed component must move by more than the other two, and the other
       two may move only by the quantisation bound.
    """
    failures = []
    claims: Dict[str, str] = {}
    for item in chroma.layers:
        if len(item.claims) != 1:
            failures.append("layer %s claims %s, not a single component" % (item.role, sorted(item.claims)))
            continue
        component = tuple(item.claims)[0]
        if component in claims:
            failures.append("component %s claimed by both %s and %s" % (component, claims[component], item.role))
        claims[component] = item.role
    disjoint = not failures and set(claims) == set(COMPONENTS)
    if not disjoint and not failures:
        failures.append("layers cover %s, not %s" % (sorted(claims), sorted(COMPONENTS)))

    axis_component = {index: axis[2] for index, axis in enumerate(CHOICE_AXES)}
    states = chroma.language.states
    own_minimum = None
    cross_maximum = Fraction(0)
    flips = 0
    clamped = 0
    codes = {}
    for state in states:
        resolution = chroma.resolve(state)
        if resolution.clamped:
            clamped += 1
        codes.setdefault(resolution.colour, []).append(state)
        here = to_opponent(resolution.colour)
        for index in range(len(CHOICE_AXES)):
            flipped = tuple(1 - value if position == index else value for position, value in enumerate(state))
            there = to_opponent(chroma.resolve(flipped).colour)
            flips += 1
            for position, name in enumerate(COMPONENTS):
                delta = here[position] - there[position]
                if delta < 0:
                    delta = -delta
                if name == axis_component[index]:
                    if own_minimum is None or delta < own_minimum:
                        own_minimum = delta
                elif delta > cross_maximum:
                    cross_maximum = delta
    injective = len(codes) == len(states)
    if not injective:
        failures.append("the eight states do not receive eight distinct colours")
    return SeparabilityCertificate(
        channel=chroma.name,
        states=len(states),
        flips_checked=flips,
        own_minimum=Fraction(0) if own_minimum is None else own_minimum,
        cross_maximum=cross_maximum,
        bound=QUANTISATION_BOUND,
        disjoint_claims=disjoint,
        clamped_states=clamped,
        injective=injective,
        failures=tuple(failures),
    )


def choice_tasks() -> Tuple[Task, ...]:
    """One task per choice: "has this parameter been fixed?"."""
    return tuple(
        Task(
            "choice:%s" % (axis[0],),
            (lambda index: (lambda state, counter=None: state[index]))(index),
            "is the %s fixed?" % (axis[0],),
        )
        for index, axis in enumerate(CHOICE_AXES)
    )


# --------------------------------------------------------------------------
# 1. colour for the ordering pictures
# --------------------------------------------------------------------------

INK = RGB(17, 17, 17)
PAPER = RGB(255, 255, 255)
RULE = RGB(187, 187, 187)
BROKEN = RGB(204, 0, 51)
INTACT = RGB(153, 153, 153)


def choice_ramp(maximum: int) -> Tuple[RGB, ...]:
    """An ordered palette on ``0..maximum`` choices.

    An ordered quantity gets an ordered palette.  **A reader may misread it**:
    equal colour steps are not equal "amounts of choice"; the ramp is linear in
    the non-uniform surrogate of ``runtime/render`` Sec.3 and the underlying
    quantity is a count of parameters, which has no metric at all.
    """
    return sequential_ramp(maximum + 1, RGB(232, 240, 248), RGB(153, 51, 0))


# --------------------------------------------------------------------------
# 2. the two-order comparison picture
# --------------------------------------------------------------------------

ROW_H = 30
BOX_W = 216
BOX_H = 24
LANE_W = 7
HEADER = 96
FOOT = 108
MARGIN = 16


def _assign_lanes(spans: Sequence[Tuple[int, int, int]]) -> Dict[int, int]:
    """Greedy interval-graph colouring; deterministic, input order preserved."""
    lanes: Dict[int, int] = {}
    occupied: list = []
    for identifier, low, high in spans:
        placed = None
        for index, intervals in enumerate(occupied):
            if all(high < a or low > b for a, b in intervals):
                placed = index
                break
        if placed is None:
            occupied.append([])
            placed = len(occupied) - 1
        occupied[placed].append((low, high))
        lanes[identifier] = placed
    return lanes


def _lane_map(graph: DependencyGraph, ordering: Ordering, y0: int) -> Dict[int, int]:
    """Lane index per edge, from the vertical span the edge has to cross."""
    row_of = {cid: index for index, cid in enumerate(ordering.sequence)}
    spans = []
    for index, edge in enumerate(graph.edges):
        a = y0 + row_of[edge.prerequisite] * ROW_H + BOX_H // 2
        b = y0 + row_of[edge.concept] * ROW_H + BOX_H // 2
        spans.append((index, min(a, b), max(a, b)))
    return _assign_lanes(spans)


def _panel(
    doc: SVG,
    graph: DependencyGraph,
    ordering: Ordering,
    x0: int,
    y0: int,
    lanes: int,
    palette: Sequence[RGB],
    notes: Optional[Dict[str, str]] = None,
) -> None:
    broken = {(v.prerequisite, v.concept) for v in violations(graph, ordering)}
    row_of = {cid: index for index, cid in enumerate(ordering.sequence)}
    box_x = x0 + lanes * LANE_W + 10

    def centre(cid: str) -> int:
        return y0 + row_of[cid] * ROW_H + BOX_H // 2

    lane_of = _lane_map(graph, ordering, y0)

    doc.open_group("edges-%s" % (ordering.name,))
    for index, edge in enumerate(graph.edges):
        is_broken = (edge.prerequisite, edge.concept) in broken
        stroke = BROKEN if is_broken else INTACT
        width = 2 if is_broken else 1
        lane_x = box_x - 10 - lane_of[index] * LANE_W
        y1 = centre(edge.prerequisite)
        y2 = centre(edge.concept)
        doc.line(lane_x, y1, box_x, y1, stroke, width)
        doc.line(lane_x, y1, lane_x, y2, stroke, width)
        doc.line(lane_x, y2, box_x, y2, stroke, width)
        doc.circle(box_x - 3, y2, 3, fill=stroke)
    doc.close_group()

    doc.open_group("boxes-%s" % (ordering.name,))
    for index, cid in enumerate(ordering.sequence):
        concept = graph.concept(cid)
        required = graph.choices_required(cid)
        fill = palette[required]
        y = y0 + index * ROW_H
        doc.rect(box_x, y, BOX_W, BOX_H, fill=fill, stroke=RULE, stroke_width=1,
                 title="%s — %d choice(s) required, depth %d" % (concept.label, required, graph.depth(cid)))
        doc.text(box_x + 6, y + 16, "%2d %s" % (index + 1, concept.label[:30]), text_on(fill), 11)
        badge = "%d" % (required,)
        doc.text(box_x + BOX_W - 8, y + 16, badge, text_on(fill), 11, anchor="end")
        if notes is not None and cid in notes:
            doc.text(box_x + BOX_W + 8, y + 16, notes[cid][:44], RGB(102, 102, 102), 9)
    doc.close_group()


def order_svg(
    graph: DependencyGraph,
    derived: Ordering,
    conventional: Ordering,
) -> SVG:
    """Two panels, identical geometry and identical palette.

    Any difference between them is the ordering and nothing else.  Red edges are
    **violated** dependencies: a concept taught before something a cited theorem
    says it depends on.
    """
    maximum = max(graph.choices_required(cid) for cid in graph.ids)
    palette = choice_ramp(maximum)
    # Size the gutter from the lane assignment the panels will actually make,
    # not from a guess: a guess that is one lane short draws edges off-canvas.
    lanes_needed = 1 + max(
        max(_lane_map(graph, ordering, HEADER).values())
        for ordering in (derived, conventional)
    )
    panel_w = lanes_needed * LANE_W + 10 + BOX_W + 24
    width = MARGIN * 2 + panel_w * 2 + 40
    height = HEADER + len(graph.ids) * ROW_H + FOOT
    doc = SVG(
        width,
        height,
        "Two curricular orders over one dependency graph",
        "Derived order (choices, depth) vs. a hand-encoded conventional school order. "
        "Red edges are violated dependencies. Dependency order only; no empirical claim.",
        background=PAPER,
    )

    doc.text(MARGIN, 26, "Two orders over one dependency graph", INK, 16, weight="bold")
    doc.text(MARGIN, 44,
             "13 concepts, 23 justified edges (ATLAS_OF_N.md, DIGIT_CRYSTAL.md). "
             "Box shade = choices required. Red = violated dependency.", RGB(85, 85, 85), 10)
    doc.text(MARGIN, 58,
             "This is a dependency order. It is NOT a claim about how anyone learns.",
             RGB(153, 51, 0), 10, weight="bold")

    left = MARGIN
    right = MARGIN + panel_w + 40
    for x, ordering, caption in ((left, derived, "DERIVED — sorted by (choices, depth)"),
                                 (right, conventional, "CONVENTIONAL — hand-encoded school sequence")):
        rows = violations(graph, ordering)
        debt = choice_debt(graph, ordering)
        doc.text(x + lanes_needed * LANE_W + 10, HEADER - 26, caption, INK, 12, weight="bold")
        doc.text(x + lanes_needed * LANE_W + 10, HEADER - 12,
                 "violated edges %d/%d    choice debt %d    first choice at step %s"
                 % (len(rows), len(graph.edges), debt.total,
                    "-" if debt.first_choice_position is None else debt.first_choice_position),
                 RGB(85, 85, 85), 10)
        _panel(doc, graph, ordering, x, HEADER, lanes_needed, palette)

    legend_y = HEADER + len(graph.ids) * ROW_H + 24
    doc.text(MARGIN, legend_y, "choices required:", INK, 10)
    for index in range(maximum + 1):
        swatch_x = MARGIN + 110 + index * 46
        doc.rect(swatch_x, legend_y - 10, 30, 13, fill=palette[index], stroke=RULE, stroke_width=1)
        doc.text(swatch_x + 15, legend_y, str(index), text_on(palette[index]), 9, anchor="middle")
    doc.text(MARGIN, legend_y + 22,
             "Colour steps are equal steps in the exact rational surrogate of runtime/render Sec.3, which is not "
             "perceptually uniform; and 'number of parameters' has no metric anyway.", RGB(119, 119, 119), 9)
    doc.text(MARGIN, legend_y + 36,
             "The derived order's 0 violations is a theorem (curriculum/order.prove_topological), not a tuning result.",
             RGB(119, 119, 119), 9)
    doc.text(MARGIN, legend_y + 50,
             "The conventional sequence is a MODEL written by hand in order.py. No curriculum document was read.",
             RGB(119, 119, 119), 9)
    return doc


# --------------------------------------------------------------------------
# 3. the choice-cube picture
# --------------------------------------------------------------------------

CELL = 92
CELL_GAP = 8


def choice_cube_svg(chroma: ChromaticChannel, certificate: SeparabilityCertificate) -> SVG:
    """The one picture in which the three choices are visually separable.

    Layout: rows are the carry (Y), the four columns are (base, endianness)
    (Co, Cg).  Moving down changes lightness only, moving across the major
    division changes red/blue only, moving inside a pair changes green only.
    Each of the three parameters of Theorem 4.2(2) owns one axis of the colour
    and nothing else owns it.
    """
    states = chroma.language.states
    width = MARGIN * 2 + 4 * (CELL + CELL_GAP) + 300
    height = 128 + 2 * (CELL + CELL_GAP) + 250
    doc = SVG(
        width,
        height,
        "The three choices of positional notation, separated",
        "Eight states = the eight subsets of {base, endianness, carry}. Each parameter of "
        "ATLAS_OF_N Theorem 4.2(2) drives exactly one opponent component.",
        background=PAPER,
    )
    doc.text(MARGIN, 26, "Positional notation = three choices, and they are independent", INK, 16, weight="bold")
    doc.text(MARGIN, 44,
             "ATLAS_OF_N.md Theorem 4.2(2): a base (a finite quotient), an endianness (a trivialization of a "
             "Z/2-torsor), and a carry (a 2-cocycle whose class is never zero).", RGB(85, 85, 85), 10)
    doc.text(MARGIN, 58,
             "Each drives one component of the exact opponent space: base -> Co, endianness -> Cg, carry -> Y.",
             RGB(85, 85, 85), 10)

    top = 96
    doc.text(MARGIN, top - 10, "carry", RGB(85, 85, 85), 10)
    columns = ((0, 0), (0, 1), (1, 0), (1, 1))
    for column, (base, endian) in enumerate(columns):
        x = MARGIN + 42 + column * (CELL + CELL_GAP)
        doc.text(x + CELL // 2, top - 10, "b=%d e=%d" % (base, endian), RGB(85, 85, 85), 10, anchor="middle")
    for row, carry in enumerate((0, 1)):
        y = top + row * (CELL + CELL_GAP)
        doc.text(MARGIN, y + CELL // 2, "%d" % (carry,), RGB(85, 85, 85), 12)
        for column, (base, endian) in enumerate(columns):
            state = (base, endian, carry)
            resolution = chroma.resolve(state)
            colour = resolution.colour
            opponent = to_opponent(colour)
            x = MARGIN + 42 + column * (CELL + CELL_GAP)
            doc.rect(x, y, CELL, CELL, fill=colour, stroke=RULE, stroke_width=1,
                     title="base=%d endianness=%d carry=%d  %s  Y=%s Co=%s Cg=%s"
                           % (base, endian, carry, colour.hex(), opponent[0], opponent[1], opponent[2]))
            ink = text_on(colour)
            doc.text(x + 8, y + 18, "%d%d%d" % (base, endian, carry), ink, 13, weight="bold")
            doc.text(x + 8, y + 36, colour.hex(), ink, 10)
            doc.text(x + 8, y + 54, "Y  %s" % (_short(opponent[0]),), ink, 9)
            doc.text(x + 8, y + 66, "Co %s" % (_short(opponent[1]),), ink, 9)
            doc.text(x + 8, y + 78, "Cg %s" % (_short(opponent[2]),), ink, 9)
            if state == (1, 1, 1):
                doc.rect(x, y, CELL, CELL, fill=None, stroke=RGB(0, 0, 0), stroke_width=3)

    legend_x = MARGIN + 42 + 4 * (CELL + CELL_GAP) + 20
    doc.text(legend_x, top + 4, "the three axes", INK, 12, weight="bold")
    for index, axis in enumerate(CHOICE_AXES):
        doc.text(legend_x, top + 24 + index * 30, "%s  ->  %s" % (axis[0], axis[2]), INK, 11)
        doc.text(legend_x, top + 37 + index * 30, axis[1][:46], RGB(119, 119, 119), 9)
    doc.text(legend_x, top + 128, "heavy outline: all three fixed = a numeral", RGB(85, 85, 85), 10)

    foot = top + 2 * (CELL + CELL_GAP) + 30
    doc.text(MARGIN, foot, "Separability, proved exhaustively over all %d flips:" % (certificate.flips_checked,),
             INK, 11, weight="bold")
    doc.text(MARGIN, foot + 16,
             "flipping one choice moves its own component by at least %s and every other component by at most %s"
             % (certificate.own_minimum, certificate.cross_maximum), RGB(51, 51, 51), 10)
    doc.text(MARGIN, foot + 30,
             "quantisation bound %s; layers claim disjoint components (%s); eight distinct colours (%s); clamped %d"
             % (certificate.bound, certificate.disjoint_claims, certificate.injective, certificate.clamped_states),
             RGB(51, 51, 51), 10)
    doc.text(MARGIN, foot + 52,
             "What a reader could misread:", RGB(85, 85, 85), 10, weight="bold")
    doc.text(MARGIN, foot + 66,
             "(a) the three axes are separable in the CHART, not orthogonal as mathematics: the torsor of "
             "endianness is a torsor of truncation", RGB(119, 119, 119), 9)
    doc.text(MARGIN, foot + 78,
             "      systems on (Z/b^n)_n, so it is not even definable until the base is fixed "
             "(ATLAS_OF_N Proposition 2.10).", RGB(119, 119, 119), 9)
    doc.text(MARGIN, foot + 92,
             "(b) 'carry = 0' is not a carry-free numeral. No digit section makes the class vanish "
             "(Corollary 2.11.1); 0 here means", RGB(119, 119, 119), 9)
    doc.text(MARGIN, foot + 104,
             "      the parameter has not been chosen yet, not that it was chosen to be trivial.",
             RGB(119, 119, 119), 9)
    doc.text(MARGIN, foot + 118,
             "(c) the opponent surrogate is not CIELAB and is not perceptually uniform "
             "(runtime/render/README.md Sec.3).", RGB(119, 119, 119), 9)
    return doc


def out_of_bounds(doc: SVG) -> Tuple[str, ...]:
    """Every drawn coordinate that falls outside the declared canvas.

    A picture whose geometry leaves the viewBox is a picture that lies about
    what it shows, and the failure is silent in every SVG viewer.  So it is
    checked here by re-parsing the writer's own output rather than trusted --
    the same reflex as ``runtime/render``'s re-parse of ``<rect fill=…>``.
    Text is exempted in ``x`` only when right-anchored, since an anchored label
    extends leftwards from its coordinate.
    """
    import re

    body = doc.render()
    failures = []
    for match in re.finditer(r"<(rect|line|circle|text)\b([^>]*)>", body):
        tag = match.group(1)
        attributes = dict(re.findall(r'([a-zA-Z:-]+)="([^"]*)"', match.group(2)))

        def number(name: str) -> Optional[int]:
            value = attributes.get(name)
            if value is None:
                return None
            try:
                return int(value)
            except ValueError:
                return None

        points = []
        if tag == "rect":
            x, y = number("x"), number("y")
            w, h = number("width"), number("height")
            if None not in (x, y, w, h):
                points = [(x, y), (x + w, y + h)]
        elif tag == "line":
            points = [(number("x1"), number("y1")), (number("x2"), number("y2"))]
        elif tag == "circle":
            cx, cy, r = number("cx"), number("cy"), number("r")
            if None not in (cx, cy, r):
                points = [(cx - r, cy - r), (cx + r, cy + r)]
        elif tag == "text":
            points = [(number("x"), number("y"))]
        for px, py in points:
            if px is None or py is None:
                continue
            if px < 0 or py < 0 or px > doc.width or py > doc.height:
                failures.append("%s at (%d,%d) outside %dx%d" % (tag, px, py, doc.width, doc.height))
    return tuple(failures)


def _short(value: Fraction) -> str:
    """Exact rational, printed compactly.  Never a decimal approximation."""
    if value.denominator == 1:
        return str(value.numerator)
    return "%d/%d" % (value.numerator, value.denominator)


# --------------------------------------------------------------------------
# 4. the traversal document
# --------------------------------------------------------------------------

HONESTY = (
    "This program derives a <strong>dependency order</strong>: a fact about which "
    "mathematical constructions are definable from which others, and how many parameters "
    "stand in between. Every edge is a quoted theorem and every quote is checked against "
    "the file it cites. That is the whole of what is established."
)

NOT_ESTABLISHED = (
    "It is <strong>not</strong> an empirical claim about how humans learn. There is no "
    "learner anywhere in this computation. No trial was run, no outcome measured, no "
    "population sampled, no retention or transfer or error rate observed. "
    "<code>certify_curriculum_claim</code> rejects a learning-outcome claim outright, for the "
    "same structural reason <code>runtime/render</code>'s <code>certify_claim</code> rejects an "
    "information-gain claim: the object simply does not contain the thing being claimed about."
)

COUNTER_ARGUMENT = (
    "The strongest fair counter-argument is that <em>logical downstream is not "
    "psychological downstream</em>. Positional notation is a compressed, manipulable, "
    "externally-supported representation: a child can move ten counters into a bundle and "
    "see a carry happen before possessing any notion of a cocycle, and that concrete "
    "manipulation may be what makes the abstraction learnable at all. On this view a "
    "dependency-ordered curriculum inverts the scaffolding, teaching the general case to "
    "learners who have no instance of it, and the fact that groups are logically prior is "
    "simply irrelevant to a mind that does not learn by definitional expansion. The "
    "literature that would bear on this — concreteness fading, worked-example and "
    "expertise-reversal effects, the long record of 'discovery learning' results — is real, "
    "was not consulted here, and is not summarised here because summarising unread "
    "literature is worse than declining to."
)

SETTLING_EVIDENCE = (
    "What would settle it: a randomised trial, with pre-registered outcomes, in which "
    "matched cohorts are taught the two sequences by comparably prepared teachers, and are "
    "then assessed on transfer to genuinely novel tasks — not on the notation itself, which "
    "the conventional sequence trivially wins on and the derived sequence trivially loses — "
    "with long-delayed retention measured, and with the comparison repeated across ages, "
    "since the answer may well differ by age. <strong>This system cannot produce any of "
    "that.</strong> It has no learner, no instrument and no data, and adding more "
    "mathematics to it would not move it one step closer."
)


def _html_escape(text: str) -> str:
    return escape(text)


def traversal_html(
    graph: DependencyGraph,
    derived: Ordering,
    conventional: Ordering,
    order_picture: SVG,
    cube_picture: SVG,
    certificate: SeparabilityCertificate,
) -> str:
    """The human-facing traversal: every step, its prerequisites, its choices.

    Written as plain HTML because ``runtime/render`` implements SVG only and no
    HTML writer; the two SVGs are produced by ``runtime/render``'s writer and
    inlined here verbatim.
    """
    rows = compare(graph, (derived, conventional))
    parts = []
    parts.append("<!doctype html>")
    parts.append('<html lang="en"><head><meta charset="utf-8">')
    parts.append("<title>A curriculum derived from mathematical dependency</title>")
    parts.append("<style>")
    parts.append(
        "body{font:15px/1.55 Georgia,serif;max-width:60em;margin:2em auto;padding:0 1.4em;color:#1a1a1a;"
        "background:#fff}"
        "h1,h2,h3{font-family:system-ui,sans-serif;line-height:1.2}"
        "h1{font-size:1.7em;margin-bottom:.1em}h2{font-size:1.25em;margin-top:2em;border-bottom:1px solid #ddd;"
        "padding-bottom:.2em}h3{font-size:1.02em;margin-bottom:.2em}"
        "code,pre{font-family:ui-monospace,Menlo,monospace;font-size:.88em}"
        "table{border-collapse:collapse;margin:1em 0;font-size:.9em;width:100%}"
        "th,td{border:1px solid #ddd;padding:.35em .6em;text-align:left;vertical-align:top}"
        "th{background:#f4f6f8;font-family:system-ui,sans-serif}"
        ".step{border-left:4px solid #cfd8e0;padding:.2em 0 .2em 1em;margin:1.4em 0}"
        ".step.choice{border-left-color:#993300;background:#fdf6f2}"
        ".q{color:#444;font-style:italic}"
        ".cite{font-family:ui-monospace,Menlo,monospace;font-size:.8em;color:#666}"
        ".warn{background:#fdf6f2;border:1px solid #e5c7b7;padding:.9em 1.1em;margin:1.2em 0}"
        ".fig{margin:1.5em 0;overflow-x:auto}"
        ".meta{color:#666;font-size:.88em}"
        "ul{padding-left:1.3em}"
    )
    parts.append("</style></head><body>")

    parts.append("<h1>A curriculum derived from mathematical dependency</h1>")
    parts.append(
        '<p class="meta">Generated by <code>runtime/demo/curriculum_demo.py</code> from '
        "<code>notes/ATLAS_OF_N.md</code> and <code>notes/DIGIT_CRYSTAL.md</code>. "
        "%d concepts, %d edges, every edge carrying a verbatim quotation that was checked "
        "against the file it cites.</p>" % (len(graph.ids), len(graph.edges))
    )

    parts.append('<div class="warn"><strong>Read this first.</strong> %s %s</div>' % (HONESTY, NOT_ESTABLISHED))

    # -- the result -------------------------------------------------------
    parts.append("<h2>The result</h2>")
    parts.append("<table><tr><th>ordering</th><th>violated edges</th><th>choice debt</th>"
                 "<th>first choice at step</th><th>choice-free concepts deferred behind a choice</th>"
                 "<th>place value lands</th><th>group action lands</th></tr>")
    for row in rows:
        parts.append(
            "<tr><td><strong>%s</strong></td><td>%d / %d</td><td>%d</td><td>%s</td><td>%d</td>"
            "<td>%d of %d</td><td>%d of %d</td></tr>"
            % (row.ordering, row.violated_edges, row.total_edges, row.debt,
               "—" if row.first_choice_position is None else row.first_choice_position,
               row.deferred_choice_free,
               row.positional_position, len(graph.ids), row.symmetry_position, len(graph.ids))
        )
    parts.append("</table>")
    parts.append(
        "<p>A <em>violation</em> is an edge whose prerequisite is taught after the concept that "
        "depends on it. <em>Choice debt</em> charges each parameter once for every piece of "
        "structure that forces it to be a parameter but which the reader has not met yet. The "
        "derived order scores zero on both, and that is a theorem rather than a tuning result: "
        "<code>prove_topological</code> checks, edge by edge, that the sort key "
        "<code>(choices, depth)</code> is non-decreasing in the first component and strictly "
        "increasing in the second along every edge, so no tie-break can ever invert a "
        "dependency.</p>"
    )

    parts.append('<div class="fig">%s</div>' % (order_picture.render(),))

    # -- the traversal ----------------------------------------------------
    parts.append("<h2>The traversal</h2>")
    parts.append(
        "<p>Each step lists what it depends on and the theorem that forces the dependency, "
        "quoted. A step highlighted in rust introduces a parameter that the natural numbers "
        "do not supply.</p>"
    )
    for index, cid in enumerate(derived.sequence, start=1):
        concept = graph.concept(cid)
        classes = "step choice" if concept.own_choices else "step"
        parts.append('<div class="%s">' % (classes,))
        parts.append(
            "<h3>%d. %s <span class=\"meta\">— chart %s, %d choice(s) required, depth %d</span></h3>"
            % (index, _html_escape(concept.label), _html_escape(concept.chart),
               graph.choices_required(cid), graph.depth(cid))
        )
        parts.append("<p>%s</p>" % (_html_escape(concept.gloss),))
        parents = graph.parents(cid)
        if not parents:
            parts.append("<p><strong>Depends on nothing.</strong> Choice-free by "
                         '<span class="cite">%s</span>:<br><span class="q">&ldquo;%s&rdquo;</span></p>'
                         % (_html_escape(concept.freedom_justification.cite()),
                            _html_escape(_flat(concept.freedom_justification.quote))))
        else:
            parts.append("<p><strong>Depends on:</strong></p><ul>")
            for parent in parents:
                edge = graph.edge(parent, cid)
                mark = " <em>(orientation conventional — see below)</em>" if edge.symmetric else ""
                parts.append(
                    "<li><strong>%s</strong>%s<br><span class=\"cite\">%s</span><br>"
                    '<span class="q">&ldquo;%s&rdquo;</span>%s</li>'
                    % (_html_escape(graph.concept(parent).label), mark,
                       _html_escape(edge.justification.cite()),
                       _html_escape(_flat(edge.justification.quote)),
                       ("<br><span class=\"meta\">%s</span>" % (_html_escape(edge.note),)) if edge.note else "")
                )
            parts.append("</ul>")
        if concept.own_choices:
            parts.append(
                "<p><strong>Introduces a choice:</strong> %s<br>"
                '<span class="cite">%s</span><br><span class="q">&ldquo;%s&rdquo;</span></p>'
                % (_html_escape(", ".join(concept.choice_names)),
                   _html_escape(concept.choice_justification.cite()),
                   _html_escape(_flat(concept.choice_justification.quote)))
            )
            parts.append(
                "<p><strong>And the choice is nonredundant:</strong><br>"
                '<span class="cite">%s</span><br><span class="q">&ldquo;%s&rdquo;</span></p>'
                % (_html_escape(concept.nonredundancy.cite()),
                   _html_escape(_flat(concept.nonredundancy.quote)))
            )
        else:
            inherited = graph.choice_sources(cid)
            if inherited:
                parts.append("<p><strong>Inherits %d choice(s):</strong> %s</p>"
                             % (len(inherited), _html_escape(", ".join(name for _, name in inherited))))
            else:
                parts.append("<p><strong>Introduces no choice.</strong> "
                             '<span class="cite">%s</span></p>'
                             % (_html_escape(concept.freedom_justification.cite()),))
        parts.append("</div>")

    # -- the picture ------------------------------------------------------
    parts.append("<h2>The three choices, separated</h2>")
    parts.append(
        "<p>%s</p>" % (_html_escape(certificate.render()),)
    )
    parts.append('<div class="fig">%s</div>' % (cube_picture.render(),))

    # -- what the order does not settle ----------------------------------
    parts.append("<h2>What is and is not established</h2>")
    parts.append("<p>%s</p>" % (HONESTY,))
    parts.append("<p>%s</p>" % (NOT_ESTABLISHED,))
    parts.append("<h3>The strongest counter-argument, stated fairly</h3>")
    parts.append("<p>%s</p>" % (COUNTER_ARGUMENT,))
    parts.append("<h3>What would settle it</h3>")
    parts.append("<p>%s</p>" % (SETTLING_EVIDENCE,))
    parts.append("<h3>Further limits of this particular computation</h3>")
    parts.append("<ul>")
    parts.append(
        "<li>The conventional sequence is a <strong>hand-written model</strong> in "
        "<code>runtime/curriculum/order.py</code>. No curriculum document was read or cited. "
        "Its 11 violations and debt of 7 are properties of that encoding; a different "
        "encoding gives different numbers, and the file is the place to argue about it.</li>"
    )
    unordered = unordered_pairs(graph, derived)
    parts.append(
        "<li>The derived order is not a total order. It is a chain of %d levels; %d adjacent "
        "pairs are separated <strong>only by an alphabetical tie-break with no mathematical "
        "content</strong>: %s.</li>"
        % (len(levels(graph)), len(unordered),
           _html_escape("; ".join("%s / %s" % pair for pair in unordered)))
    )
    conventions = graph.conventional_orientation_edges()
    parts.append(
        "<li>%d edge(s) are oriented by convention rather than by force: %s. "
        "ATLAS_OF_N.md Sec.2.1 proves the comparison type here is <em>contractible</em>, so "
        "each side is definable from the other and the arrow's direction is a presentation "
        "decision this graph made and is declaring.</li>"
        % (len(conventions), _html_escape(", ".join("%s → %s" % e.key for e in conventions)))
    )
    parts.append(
        "<li>The graph covers the concepts of <code>ATLAS_OF_N.md</code>'s charts and nothing "
        "else. Arithmetic <em>algorithms</em>, fractions, measurement, negative numbers, "
        "geometry and everything else a curriculum contains are absent, so this is not a "
        "curriculum; it is the prerequisite skeleton of one corner of one.</li>"
    )
    parts.append(
        "<li>Chart (g) (Stern–Brocot) is not modelled, following the atlas's own Sec.10 item 5, "
        "and chart (e) is modelled only for integer bases b ≥ 2, following its item 6.</li>"
    )
    parts.append("</ul>")
    parts.append("</body></html>")
    return "\n".join(parts) + "\n"


def _flat(text: str) -> str:
    return " ".join(text.split())


def write_artifacts(
    out_dir: str,
    graph: DependencyGraph,
    derived: Ordering,
    conventional: Ordering,
) -> Tuple[Tuple[str, int], ...]:
    """Write the two SVGs and the HTML traversal.  Returns (path, bytes) pairs."""
    os.makedirs(out_dir, exist_ok=True)
    chroma = choice_cube_channel()
    certificate = certify_separability(chroma)
    order_picture = order_svg(graph, derived, conventional)
    cube_picture = choice_cube_svg(chroma, certificate)

    written = []
    path = os.path.join(out_dir, "curriculum_orders.svg")
    written.append((path, order_picture.write(path)))
    path = os.path.join(out_dir, "choice_cube.svg")
    written.append((path, cube_picture.write(path)))
    path = os.path.join(out_dir, "curriculum.html")
    payload = traversal_html(graph, derived, conventional, order_picture, cube_picture, certificate).encode("utf-8")
    with open(path, "wb") as handle:
        handle.write(payload)
    written.append((path, len(payload)))
    return tuple(written)


__all__ = [
    "CHOICE_AXES",
    "COUNTER_ARGUMENT",
    "HONESTY",
    "NOT_ESTABLISHED",
    "QUANTISATION_BOUND",
    "SETTLING_EVIDENCE",
    "SeparabilityCertificate",
    "certify_separability",
    "choice_cube_channel",
    "choice_cube_svg",
    "choice_language",
    "choice_ramp",
    "choice_states",
    "choice_tasks",
    "order_svg",
    "traversal_html",
    "write_artifacts",
]
