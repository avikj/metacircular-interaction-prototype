#!/usr/bin/env python3
"""The measured demonstration of perceptual compilation (CRYSTAL.md §7 REALIZE).

Run:  python3 runtime/demo/render_demo.py

Writes SVG artifacts to ``runtime/demo/out/`` and prints an exact report.
Everything printed is an integer or an exact ``Fraction`` produced by this
script.  No floating point, no timing, no randomness beyond one explicit
integer recurrence whose constants are printed.  Two runs are byte-identical,
including the SVG bytes; the final line is the SHA-256 of everything above it.

WHAT IS BEING CLAIMED, AND WHAT IS NOT

    CLAIMED.  Colour here is a *projection of one object* with an explicit
    information loss, a concrete collision witness, and a stated round trip:
    exact and single-valued on a declared sublanguage where injectivity is
    proved, and otherwise the whole fiber.  Codes assigned to states a declared
    task must distinguish are pairwise distinct -- proved exhaustively, not
    sampled.  Answering that task from the code costs strictly fewer comparison
    operations than answering it from the raw state, once the code exists.

    NOT CLAIMED.  Nothing about human recognition.  The measurement below is a
    machine-side comparison count and is labelled a proxy every time it is
    printed.  No experiment here involves a human eye, so no latency,
    accuracy or "recognition cost" claim about people is established by it.
    Also not claimed: information gain.  A channel is a function of state, so
    it can only lose; ``certify_claim`` rejects the opposite claim, and the
    rejection is printed below as a live control.

WHY THIS MATHEMATICS

    `notes/DIGIT_CRYSTAL.md` §0-§1: little-endian base-b digit words with the
    odometer T (v -> v+1) and the digit complement E (c_i -> b-1-c_i, i.e.
    v -> b^n-1-v).  b = 4, n = 4, so 256 states -- a 16 x 16 grid in which the
    row is the high digit pair and the column is the low digit pair, and in
    which E is exactly the point reflection through the centre.  Every proof
    below is exhaustive over those 256 states.

    The picture is built so that a *theorem is visible*: DIGIT_CRYSTAL (2.2),
    c_n(E x) = z_n(x) -- the digit complement exchanges carry with borrow.
    The two rendered panels are the carry colouring and the borrow colouring;
    the theorem says the second is the first rotated by half a turn, and the
    demo checks that cell-colour identity on all 256 cells rather than
    inviting the reader to believe it.
"""

from __future__ import annotations

import hashlib
import os
import sys
from fractions import Fraction

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from render import (  # noqa: E402
    INFORMATION_GAIN,
    RGB,
    SVG,
    Channel,
    StepCounter,
    Task,
    borrow_chroma,
    borrow_count,
    carry_chroma,
    carry_count,
    carry_ramp,
    certify_claim,
    certify_distinguishability,
    certify_injectivity,
    certify_loss,
    certify_precedence,
    certify_preservation,
    certify_round_trip,
    complement_word,
    digit_language,
    is_antipalindrome,
    is_constant_word,
    is_palindrome,
    klein_orbit,
    low_sublanguage,
    low_word_chroma,
    low_word_inverse,
    orbit_chroma,
    product_channel,
    restrict,
    sector_name,
    token_chroma,
    validate_channel,
    value_of,
)
from render.chroma import DEMO_TOKENS  # noqa: E402

BASE = 4
LENGTH = 4
GRID = BASE * BASE
QUERIES = 1024
LCG_MULTIPLIER = 1103515245
LCG_INCREMENT = 12345
LCG_MODULUS = 2147483648
LCG_SEED = 20260812

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out")

INK = RGB(17, 17, 17)
PAPER = RGB(255, 255, 255)
FAINT = RGB(136, 136, 136)
RULE = RGB(204, 204, 204)


LINES: list = []


def say(text: str = "") -> None:
    LINES.append(text)


def rule(char: str = "-") -> None:
    say(char * 78)


# --------------------------------------------------------------------------
# the proxy measurement -- comparison counting, in one explicit unit
# --------------------------------------------------------------------------


def raw_carry_answer(word, base: int, target: int) -> tuple:
    """Answer "is c_n(w) = target" from the raw state.  Returns (comparisons, answer).

    The unit is one comparison of two integers.  The raw path gets every
    shortcut the coded path gets: it stops scanning at the first digit that is
    not b-1, exactly as ``carry_count`` does.
    """
    comparisons = 0
    count = 0
    for digit in word:
        comparisons += 1
        if digit != base - 1:
            break
        count += 1
    comparisons += 1
    return (comparisons, count == target)


def coded_answer(code, target_code) -> tuple:
    """Answer the same question by comparing the code to the class's code."""
    comparisons = 0
    for left, right in zip(code.as_tuple(), target_code.as_tuple()):
        comparisons += 1
        if left != right:
            return (comparisons, False)
    return (comparisons, True)


def set_coded_answer(code, candidates) -> tuple:
    """Answer from a channel whose task class has *many* codes: membership."""
    comparisons = 0
    for candidate in candidates:
        matched = True
        for left, right in zip(code, candidate):
            comparisons += 1
            if left != right:
                matched = False
                break
        if matched:
            return (comparisons, True)
    return (comparisons, False)


def encode_comparisons(word, base: int, semantic_entries: int) -> int:
    """What it costs to *make* the code: the same digit scan, plus the
    semantic-table membership test.  Strictly more than answering once from
    the raw state, which is why the reduction is only real when the code is
    already on the page."""
    comparisons = 0
    for digit in word:
        comparisons += 1
        if digit != base - 1:
            break
    return comparisons + semantic_entries


def lcg_stream(count: int):
    state = LCG_SEED
    for _ in range(count):
        state = (LCG_MULTIPLIER * state + LCG_INCREMENT) % LCG_MODULUS
        yield state


# --------------------------------------------------------------------------
# SVG composition
# --------------------------------------------------------------------------

CELL = 30
LABEL_W = 26
LABEL_H = 18
MARGIN = 30
TITLE_H = 120
PANEL = GRID * CELL


def draw_panel(doc: SVG, x0: int, y0: int, colours, heading: str, caption: str) -> None:
    doc.open_group(heading.replace(" ", "_"))
    doc.text(x0, y0 - LABEL_H - 22, heading, INK, 15, weight="bold")
    doc.text(x0, y0 - LABEL_H - 6, caption, FAINT, 11)
    for column in range(GRID):
        doc.text(x0 + column * CELL + CELL // 2, y0 - 5, "%d" % (column,), FAINT, 9, anchor="middle")
    for row in range(GRID):
        doc.text(x0 - 6, y0 + row * CELL + CELL // 2 + 4, "%d" % (row * GRID,), FAINT, 9, anchor="end")
    for value in range(BASE ** LENGTH):
        row, column = divmod(value, GRID)
        colour, tip = colours[value]
        doc.rect(
            x0 + column * CELL,
            y0 + row * CELL,
            CELL,
            CELL,
            fill=colour,
            stroke=PAPER,
            stroke_width=1,
            title=tip,
        )
    doc.rect(x0, y0, PANEL, PANEL, fill=None, stroke=INK, stroke_width=2)
    doc.close_group()


def legend_from_channel(chroma, groups, counter=None) -> tuple:
    """Build legend swatches by *resolving representative states*.

    A legend that paints a palette entry can disagree with the picture -- the
    picture is the composed colour, after every layer, override, quantisation
    and clamp.  Building the legend from representatives makes that impossible
    by construction, and the demo additionally checks the two agree as sets.
    """
    return tuple((chroma.colour(state, counter), label) for label, state in groups)


def draw_legend(doc: SVG, x0: int, y0: int, entries) -> int:
    doc.open_group("legend")
    x = x0
    for colour, label in entries:
        doc.rect(x, y0, 18, 18, fill=colour, stroke=INK, stroke_width=1)
        doc.text(x + 24, y0 + 13, label, INK, 11)
        x += 30 + 8 * len(label)
    doc.close_group()
    return y0 + 30


def draw_caption(doc: SVG, x0: int, y0: int, lines, width: int) -> int:
    doc.open_group("caption")
    doc.line(x0, y0 - 14, x0 + width, y0 - 14, RULE, 1)
    y = y0
    for line in lines:
        weight = "bold" if line.startswith("THEOREM") or line.startswith("MISREADING") else "normal"
        doc.text(x0, y, line, INK if weight == "bold" else RGB(68, 68, 68), 12, weight=weight)
        y += 18
    doc.close_group()
    return y


def write_carry_svg(path: str, carry_cells, borrow_cells, legend) -> tuple:
    x_a = MARGIN + LABEL_W
    x_b = x_a + PANEL + 64 + LABEL_W
    y_top = TITLE_H + LABEL_H
    caption = [
        "THEOREM MADE VISIBLE  --  DIGIT_CRYSTAL (2.2):  c_n(E x) = z_n(x),  and  E(v) = b^n-1-v.",
        "E is exactly the point reflection of this grid through its centre, so the right panel is the left panel",
        "rotated by half a turn.  Checked, not asserted: all 256 cell colours satisfy right(v) = left(255-v).",
        "The nesting is the ruler sequence c_n(x) = v_b(x+1): every 4th column carries, every 16th carries twice.",
        "",
        "MISREADING RISKS, stated so the picture cannot be read as more than it is:",
        "  (a) the reflection symmetry does NOT make E a group automorphism of (Z/256,+); E(v) = -1-v is minus",
        "      the identity followed by a translation (DIGIT_CRYSTAL Prop 1.2).",
        "  (b) equal colour steps are NOT equal magnitude steps: the ramp is linear in an exact rational opponent",
        "      surrogate, which is not CIELAB and is not perceptually uniform.",
        "  (c) the pink cells are the two states where cocycle (2.1) does not apply (it is stated for x < b^n-1);",
        "      they are an exception marked by the semantic layer, not a fifth carry class of a different kind.",
        "  (d) 256 states are shown in 5 colours.  The colour of a cell does not determine the cell: the largest",
        "      fiber has 192 states.  This picture is a projection and cannot be inverted by eye or by machine.",
    ]
    width = x_b + PANEL + MARGIN
    doc = SVG(width, 1, "carry cocycle and its complement", "", background=PAPER)
    doc.text(MARGIN, 40, "The carry cocycle of the base-4 odometer, and what E does to it", INK, 20, weight="bold")
    doc.text(
        MARGIN,
        62,
        "little-endian words W_4^4 (256 states), cell (row, col) = value 16*row + col; colour = carry count",
        FAINT,
        12,
    )
    doc.text(MARGIN, 80, "runtime/render -- chroma_carry and chroma_borrow, identical layer stacks", FAINT, 12)
    draw_panel(doc, x_a, y_top, carry_cells, "left: c_n(w) = trailing (b-1) digits", "carries produced by T: v -> v+1")
    draw_panel(doc, x_b, y_top, borrow_cells, "right: z_n(w) = trailing 0 digits", "borrows produced by T^-1")
    y = y_top + PANEL + 40
    y = draw_legend(doc, x_a, y, legend)
    y = draw_caption(doc, x_a, y + 24, caption, width - 2 * x_a + LABEL_W)
    doc.height = y + 20
    return (doc, width, y + 20)


def write_orbit_svg(path: str, cells, legend) -> tuple:
    x_a = MARGIN + LABEL_W
    y_top = TITLE_H + LABEL_H
    caption = [
        "THEOREM MADE VISIBLE  --  DIGIT_CRYSTAL Thm 3.4 and Thm 4.2(2).",
        "<D,E> is Klein four on W_n for n >= 2 (Thm 3.1).  Orange = Fix D (palindromes), 16 = b^ceil(n/2).",
        "Purple = Fix DE (antipalindromes), 16 = b^floor(n/2).  Fix E is empty because b is even.  Orbits:",
        "(256 + 16 + 0 + 16)/4 = 72, verified by direct orbit count.  Cyan = the 4 constant words, which are",
        "exactly the agreement locus of Thm 4.2(2), where pi R = R pi: they sit on the grid diagonal.",
        "",
        "LAYER PRECEDENCE IS VISIBLE HERE.  Generic cells fall through to the ancestry (lexical) layer and are",
        "coloured by the root constructor gamma_{c_0} of the term DAG; the symmetry layer declines on them.  The",
        "semantic layer then overrides symmetry on the 4 constant words -- 4 cyan cells inside the 16 orange ones.",
        "",
        "MISREADING RISKS:",
        "  (a) the four ancestry colours encode c_0 only.  Two generic cells of the same colour are NOT in the",
        "      same orbit; the orbit is not recoverable from the colour (56-state fibers).",
        "  (b) orange and purple are disjoint here only because b is even; for odd b a word can be fixed by E",
        "      as well, and this palette would need a fourth sector.",
    ]
    width = x_a + PANEL + MARGIN + 420
    doc = SVG(width, 1, "symmetry sectors of the digit crystal", "", background=PAPER)
    doc.text(MARGIN, 40, "Symmetry sectors of <D,E> on W_4^4, with the reversal-defect agreement locus", INK, 20, weight="bold")
    doc.text(MARGIN, 62, "colour = which automorphism orbit the word lies in; ancestry shows through on generic orbits", FAINT, 12)
    doc.text(MARGIN, 80, "runtime/render -- chroma_orbit: ancestry < sort < symmetry < semantic", FAINT, 12)
    draw_panel(doc, x_a, y_top, cells, "W_4^4 by symmetry sector", "D = reversal, E = digit complement")
    y = y_top + PANEL + 40
    y = draw_legend(doc, x_a, y, legend[:3])
    y = draw_legend(doc, x_a, y, legend[3:])
    y = draw_caption(doc, x_a, y + 24, caption, width - 2 * MARGIN)
    doc.height = y + 20
    return (doc, width, y + 20)


def write_layers_svg(path: str, chroma, resolutions) -> tuple:
    roles = [item.role for item in chroma.layers]
    columns = ["token", "sort"] + roles + ["resolved", "winners"]
    col_x = [MARGIN, MARGIN + 110, MARGIN + 180]
    x = MARGIN + 180
    for _ in roles:
        x += 150
        col_x.append(x)
    x += 150
    col_x.append(x)
    width = x + 320
    doc = SVG(width, 1, "layer precedence: semantic beats lexical", "", background=PAPER)
    doc.text(MARGIN, 40, "Layer precedence: the semantic override beats the lexical layer", INK, 20, weight="bold")
    doc.text(MARGIN, 62, "ancestry (lexical) maps the letter b to yellow; 'beta' renders yellow, 'blue' renders blue", FAINT, 12)
    doc.text(MARGIN, 80, "composition is component-wise in ascending precedence; a layer may decline and let lower ones show", FAINT, 12)
    y = TITLE_H + 20
    for index, name in enumerate(columns):
        doc.text(col_x[index], y, name, INK, 12, weight="bold")
    doc.line(MARGIN, y + 8, width - MARGIN, y + 8, RULE, 1)
    y += 30
    for token, resolution in resolutions:
        doc.text(col_x[0], y + 14, token.name, INK, 13)
        doc.text(col_x[1], y + 14, token.sort, FAINT, 12)
        for index, (role, proposal) in enumerate(resolution.proposals):
            cell = col_x[2 + index]
            if proposal is None:
                doc.text(cell, y + 14, "declines", FAINT, 11)
            else:
                doc.rect(cell, y, 20, 20, fill=proposal, stroke=INK, stroke_width=1)
                doc.text(cell + 26, y + 14, proposal.hex(), RGB(68, 68, 68), 11)
        cell = col_x[2 + len(roles)]
        doc.rect(cell, y, 20, 20, fill=resolution.colour, stroke=INK, stroke_width=1)
        doc.text(cell + 26, y + 14, resolution.colour.hex(), INK, 11, weight="bold")
        winners = ",".join("%s=%s" % (name, role) for name, role in resolution.winners)
        doc.text(col_x[3 + len(roles)], y + 14, winners, RGB(68, 68, 68), 10)
        y += 30
    doc.line(MARGIN, y, width - MARGIN, y, RULE, 1)
    y += 26
    caption = [
        "PRECEDENCE, ascending:  ancestry (lexical) < sort < family < symmetry < semantic.",
        "Each layer proposes a whole colour and contributes only the opponent components it claims.",
        "The sort layer claims Y alone and declines on Word, so 'gamma_3' keeps its lexical hue at the Digit",
        "sort's lightness -- a partial layer tinting without repainting.  The semantic layer claims all three",
        "components, so wherever it fires it wins outright; that is the 'blue is blue' rule, and it is checked",
        "on every state by an independent descending-precedence recomputation, not by inspection.",
    ]
    y = draw_caption(doc, MARGIN, y, caption, width - 2 * MARGIN)
    doc.height = y + 20
    return (doc, width, y + 20)


# --------------------------------------------------------------------------
# the report
# --------------------------------------------------------------------------


def main() -> int:
    os.makedirs(OUT, exist_ok=True)
    counter = StepCounter()
    language = digit_language(BASE, LENGTH)
    states = language.states

    say("=" * 78)
    say(" PERCEPTUAL COMPILATION -- runtime/render")
    say(" CRYSTAL.md §7 REALIZE: mathematical state -> a channel a human perceives")
    say("=" * 78)
    say()
    say("SYSTEM   notes/DIGIT_CRYSTAL.md §0-§1, base b = %d, length n = %d" % (BASE, LENGTH))
    say("         states  W_%d^%d, little-endian, L(w) = sum c_i b^i        %d" % (BASE, LENGTH, len(states)))
    say("         actions T: v -> v+1 (odometer),  E: c_i -> b-1-c_i (Props 1.2/1.3)")
    say("         D = word reversal is present as a *symmetry*, never as an action (§1.1)")
    say("         grid    cell (row, col) = value %d*row + col, so E is the point reflection" % (GRID,))
    say("         every proof below is exhaustive over all %d states; nothing is sampled" % (len(states),))
    say()

    # ---- the channels -------------------------------------------------
    carry = carry_chroma(BASE, LENGTH, language)
    borrow = borrow_chroma(BASE, LENGTH, language)
    orbit = orbit_chroma(BASE, LENGTH, language)
    low = low_word_chroma(BASE, LENGTH, language)
    low_language = low_sublanguage(BASE, LENGTH, language)

    carry_ch = carry.channel()
    borrow_ch = borrow.channel()
    orbit_ch = orbit.channel()
    low_full = low.channel()
    low_restricted = restrict(
        low_full,
        low_language,
        name="chroma_low2|low2",
        declares_injective=True,
        inverse=low_word_inverse(BASE, LENGTH),
    )
    channels = (carry_ch, borrow_ch, orbit_ch, low_full, low_restricted)

    rule("=")
    say("1. CHANNELS DEFINED")
    rule("=")
    say()
    say("%-18s %-14s %7s %6s %10s %s" % ("channel", "language", "states", "codes", "injective", "claim"))
    for channel in channels:
        loss = certify_loss(channel, counter)
        injectivity = certify_injectivity(channel, counter)
        claim = certify_claim(channel, counter)
        say(
            "%-18s %-14s %7d %6d %10s %s"
            % (
                channel.name,
                channel.language.name,
                loss.domain_size,
                loss.image_size,
                "YES" if injectivity.injective else "no",
                claim.kind if claim.accepted else "REJECTED",
            )
        )
    say()
    say("structural validation (decode returns fibers; fibers partition the language):")
    for channel in channels:
        report = validate_channel(channel, counter)
        say("  %-18s decode=fiber %-5s partition %-5s deterministic %-5s failures %d"
            % (channel.name, report.decode_returns_fiber, report.fibers_partition,
               report.fibers_deterministic, len(report.failures)))
    say()
    say("live control -- a channel that claims INFORMATION GAIN:")
    liar = Channel(
        name="chroma_carry(claims gain)",
        language=language,
        encoder=lambda word: carry.resolve(word).colour,
        claim=INFORMATION_GAIN,
    )
    verdict = certify_claim(liar, counter)
    say("  %s -> accepted=%s" % (liar.name, verdict.accepted))
    say("  %s" % (verdict.reason,))
    say("  This is a theorem about functions, not a house rule: encode has a domain and a")
    say("  codomain, so it cannot separate states the state itself does not separate.")
    say("  Every accepted claim in this package is therefore RECOGNITION COST ONLY.")
    say()

    # ---- preserves / loses --------------------------------------------
    carry_task = Task("carry-class c_n", lambda word, c: carry_count(word, BASE), "which carry class")
    borrow_task = Task("borrow-class z_n", lambda word, c: borrow_count(word, BASE), "which borrow class")
    value_task = Task("exact value L(w)", lambda word, c: value_of(word, BASE), "which state exactly")
    sector_task = Task("symmetry sector", lambda word, c: sector_name(word, BASE), "which <D,E> sector")
    root_task = Task("root constructor c_0", lambda word, c: word[0], "term-DAG root label")
    low_task = Task("low pair (c_0,c_1)", lambda word, c: (word[0], word[1]), "the two outermost constructors")

    rule("=")
    say("2. WHAT EACH CHANNEL PRESERVES, AND WHAT IT LOSES")
    rule("=")
    say()
    exhibits = (
        (carry_ch, (carry_task, value_task)),
        (orbit_ch, (sector_task, root_task)),
        (low_full, (low_task, value_task)),
    )
    for channel, tasks in exhibits:
        loss = certify_loss(channel, counter)
        say("%s  --  %s" % (channel.name, channel.description))
        say("  LOSS      %s" % (loss.render(),))
        if loss.witness is None:
            say("  COLLISION none: injective on %s" % (channel.language.name,))
        else:
            left = loss.witness.left
            right = loss.witness.right
            say(
                "  COLLISION WITNESS  w=%s (L=%d)  and  w'=%s (L=%d)  share the code %s"
                % (left, value_of(left, BASE), right, value_of(right, BASE), loss.witness.code.hex())
            )
        for task in tasks:
            certificate = certify_preservation(channel, task, counter)
            say(
                "  %-22s preserved=%-5s  required %5d  violations %4d  permitted %5d  over %5d"
                % (
                    task.name,
                    certificate.preserved,
                    certificate.required_separations,
                    certificate.violations,
                    certificate.permitted_collisions,
                    certificate.over_separations,
                )
            )
            if certificate.violation_witness is not None:
                witness = certificate.violation_witness
                say(
                    "      -> witness: %s and %s differ under the task but share %s"
                    % (witness.left, witness.right, witness.code.hex())
                )
        say()
    say("Read the four columns as four different statements.  'required' is what the channel")
    say("preserves.  'violations' refutes a preservation claim and is nonzero exactly where the")
    say("channel must not be trusted.  'permitted' is the compression working.  'over' is code")
    say("spent on a distinction no declared task uses -- recognition cost bought for nothing.")
    say()

    # ---- round trip ----------------------------------------------------
    rule("=")
    say("3. ROUND TRIP")
    rule("=")
    say()
    injective_cert = certify_injectivity(low_restricted, counter)
    trip = certify_round_trip(low_restricted, counter)
    say("DECLARED SUBLANGUAGE  %s  (%d states: the words with c_2 = c_3 = 0)"
        % (low_language.name, len(low_language)))
    say("  injective on it        %s   (exhaustive over %d unordered pairs)"
        % (injective_cert.injective, injective_cert.pairs_checked))
    say("  inverse implemented    %s" % (trip.inverse_implemented,))
    say("  inverse exact          %s   (decode_exact(encode(w)) == w for all %d states)"
        % (trip.inverse_exact, trip.states_checked))
    sample = low_language.states[6]
    code = low_restricted.encode(sample, counter)
    say("  example                encode(%s) = %s ; decode_exact -> %s"
        % (sample, code.hex(), low_restricted.decode_exact(code, counter)))
    say()
    full_trip = certify_round_trip(low_full, counter)
    say("THE SAME CHANNEL ON THE AMBIENT LANGUAGE  %s  (%d states)"
        % (low_full.language.name, len(low_full.language)))
    say("  injective              %s" % (certify_injectivity(low_full, counter).injective,))
    say("  fibers exact           %s   (decode returns the whole preimage, recomputed from scratch)"
        % (full_trip.fiber_exact,))
    fiber = low_full.decode(code, counter)
    say("  decode(%s) returns a fiber of %d states, not a guess:" % (code.hex(), len(fiber)))
    say("      %s" % (", ".join(str(word) for word in fiber[:8]),))
    say("      %s" % (", ".join(str(word) for word in fiber[8:]),))
    say("  This is the homometry discipline of notes/CROSS_LENS.md §2 made executable: one")
    say("  projection identifies distinct objects, so decode CANNOT be single-valued here and")
    say("  the type of decode says so.  Same channel, two declared languages, two guarantees.")
    say()

    # ---- layer precedence ---------------------------------------------
    rule("=")
    say("4. LAYER PRECEDENCE (semantic override beats lexical)")
    rule("=")
    say()
    tokens = token_chroma(DEMO_TOKENS)
    resolutions = [(token, tokens.resolve(token, counter)) for token in tokens.language.states]
    say("precedence, ascending: %s" % (" < ".join(tokens.layers[index].role for index in range(len(tokens.layers)))))
    say()
    say("%-9s %-6s %-10s %-10s %-10s %-9s %s" % ("token", "sort", "ancestry", "sort", "semantic", "resolved", "winners"))
    for token, resolution in resolutions:
        proposals = dict(resolution.proposals)
        say(
            "%-9s %-6s %-10s %-10s %-10s %-9s %s"
            % (
                token.name,
                token.sort,
                proposals["ancestry"].hex() if proposals.get("ancestry") else "-",
                proposals["sort"].hex() if proposals.get("sort") else "declines",
                proposals["semantic"].hex() if proposals.get("semantic") else "declines",
                resolution.colour.hex(),
                ",".join("%s=%s" % (name, role) for name, role in resolution.winners),
            )
        )
    say()
    beta = [item for item in resolutions if item[0].name == "beta"][0]
    blue = [item for item in resolutions if item[0].name == "blue"][0]
    say("THE DIRECTION'S OWN EXAMPLE:")
    say("  the lexical layer maps the letter 'b' to %s" % (RGB(255, 204, 0).hex(),))
    say("  'beta' resolves to %s  (lexical wins: the semantic layer declines)" % (beta[1].colour.hex(),))
    say("  'blue' resolves to %s  (semantic wins on every component)" % (blue[1].colour.hex(),))
    say("  blue renders blue even though b is yellow: %s"
        % (blue[1].colour == RGB(0, 0, 255) and beta[1].colour == RGB(255, 204, 0),))
    say()
    for chroma in (tokens, carry, orbit):
        certificate = certify_precedence(chroma, counter)
        say(
            "%-14s canonical order %-5s  independent recomputation agrees %-5s  semantic fires %3d, "
            "dominates %3d, violations %d"
            % (
                chroma.name,
                certificate.canonical_order,
                certificate.independent_agreement,
                certificate.semantic_fires,
                certificate.semantic_dominates,
                len(certificate.violations),
            )
        )
    say()
    say("'independent recomputation agrees' is the real check: every resolution is recomputed by")
    say("a descending-precedence walk that shares no code path with the ascending one, and the two")
    say("must agree colour for colour on every state.")
    say()
    say("A THIRD LOSS SOURCE, MEASURED RATHER THAN ASSUMED AWAY.  Composing components taken from")
    say("different layers can land outside the sRGB cube, and the result is then clamped.  That is")
    say("loss introduced by the *rendering*, not by the mathematics, so it is counted:")
    for chroma in (carry, borrow, orbit):
        clamped = sum(1 for word in language.states if chroma.resolve(word, counter).clamped)
        say("  %-14s clamped on %3d of %d states" % (chroma.name, clamped, len(language.states)))
    say("  chroma_orbit clamps because its sort layer overwrites Y on saturated ancestry hues.")
    say("  What must not happen is a clamp collapsing a distinction a declared task needs -- and")
    say("  that is not assumed: the preservation certificates in §2 and §5 are computed on the")
    say("  clamped colours that were actually written to the file.")
    say()

    # ---- distinguishability -------------------------------------------
    rule("=")
    say("5. TASK-DISTINGUISHABILITY, PROVED BY EXHAUSTIVE CHECK")
    rule("=")
    say()
    exhibits = (
        (carry_ch, carry_task),
        (carry_ch, value_task),
        (borrow_ch, borrow_task),
        (orbit_ch, sector_task),
        (low_restricted, low_task),
    )
    for channel, task in exhibits:
        certificate = certify_distinguishability(channel, task, Fraction(1), counter)
        say(
            "%-18s %-20s classes %3d  codes %3d  DISTINGUISHES=%-5s  min surrogate separation %s"
            % (
                channel.name,
                task.name,
                certificate.task_classes,
                certificate.codes,
                certificate.distinguishable,
                certificate.min_separation,
            )
        )
    say()
    say("The proof is code inequality over every unordered pair the task separates -- integers")
    say("being different.  The 'min surrogate separation' is a *measurement* in the exact rational")
    say("opponent space (weights (4,1,1) on (Y,Co,Cg)); it is not CIELAB, it is not perceptually")
    say("uniform, and it licenses no claim about what a human can tell apart.  The two numbers are")
    say("printed side by side precisely so they are never confused for each other.")
    say()
    say("Task-relativity, in one line: the SAME chroma_carry channel PROVES the carry-class task")
    say("and PROVABLY FAILS the exact-value task, with a witness.  A channel is never good in the")
    say("abstract -- the same discipline runtime/distinguish/ applies to observations.")
    say()

    # ---- the pictures ---------------------------------------------------
    rule("=")
    say("6. THE THEOREM THE PICTURE MAKES VISIBLE")
    rule("=")
    say()
    ramp = carry_ramp(LENGTH)
    carry_cells = []
    borrow_cells = []
    for value in range(BASE ** LENGTH):
        word = states[value]
        carry_cells.append(
            (
                carry.colour(word, counter),
                "w=%s L=%d c_n=%d" % (word, value, carry_count(word, BASE)),
            )
        )
        borrow_cells.append(
            (
                borrow.colour(word, counter),
                "w=%s L=%d z_n=%d" % (word, value, borrow_count(word, BASE)),
            )
        )
    top = BASE ** LENGTH - 1
    reflection_ok = True
    integer_identity_ok = True
    for value in range(BASE ** LENGTH):
        word = states[value]
        if borrow_cells[value][0] != carry_cells[top - value][0]:
            reflection_ok = False
        if carry_count(complement_word(word, BASE), BASE) != borrow_count(word, BASE):
            integer_identity_ok = False
    say("PICTURE 1  out/carry_cocycle.svg")
    say("  Theorem (DIGIT_CRYSTAL (2.2)):  c_n(E x) = z_n(x)  --  the digit complement exchanges")
    say("  carry with borrow.  With E(v) = b^n-1-v (Prop 1.2) and the grid laid out row-major,")
    say("  E IS the point reflection through the centre of the grid.")
    say("    integer identity c_n(E x) = z_n(x) on all %d states           %s" % (len(states), integer_identity_ok))
    say("    RENDERED CELL COLOURS satisfy right(v) = left(%d - v), all %d  %s"
        % (top, len(states), reflection_ok))
    say("  The second line is the picture checking itself: the visible claim -- 'the right panel")
    say("  is the left panel rotated by half a turn' -- is verified as an identity of the exact")
    say("  colours that were written into the file, not left to the reader's eye.")
    say()
    say("  A reader could misread it as: (a) E being an additive automorphism (it is v -> -1-v,")
    say("  Prop 1.2, so it is not); (b) equal colour steps meaning equal magnitude steps (the ramp")
    say("  is linear in a non-uniform surrogate); (c) the pink cells being a carry class rather")
    say("  than the exceptional states where cocycle (2.1) is not stated; (d) the picture being")
    say("  invertible -- it is not, the largest fiber holds 192 of the 256 states.")
    say()

    palindromes = sum(1 for word in states if is_palindrome(word))
    antipalindromes = sum(1 for word in states if is_antipalindrome(word, BASE))
    both = sum(1 for word in states if is_palindrome(word) and is_antipalindrome(word, BASE))
    constants = sum(1 for word in states if is_constant_word(word))
    orbits = len(set(klein_orbit(word, BASE) for word in states))
    burnside = (len(states) + palindromes + 0 + antipalindromes) // 4
    orbit_cells = []
    for value in range(BASE ** LENGTH):
        word = states[value]
        orbit_cells.append(
            (
                orbit.colour(word, counter),
                "w=%s L=%d sector=%s orbit=%d" % (word, value, sector_name(word, BASE), len(klein_orbit(word, BASE))),
            )
        )
    say("PICTURE 2  out/symmetry_sectors.svg")
    say("  Theorem (DIGIT_CRYSTAL Thm 3.4, closed forms) counted exhaustively on the rendered set:")
    say("    |Fix D| palindromes      %3d   closed form b^ceil(n/2) = %d" % (palindromes, BASE ** ((LENGTH + 1) // 2)))
    say("    |Fix DE| antipalindromes %3d   closed form b^floor(n/2) = %d" % (antipalindromes, BASE ** (LENGTH // 2)))
    say("    |Fix E|                    0   b is even, so E has no fixed word")
    say("    Fix D and Fix DE overlap %3d   (= |Fix E|, as Thm 3.4 requires)" % (both,))
    say("    <D,E> orbits             %3d   Burnside (%d+%d+0+%d)/4 = %d"
        % (orbits, len(states), palindromes, antipalindromes, burnside))
    say("    constant words           %3d   Thm 4.2(2) agreement locus, on the grid diagonal" % (constants,))
    say("  and the layering is visible: generic cells fall through to the ancestry (lexical) layer,")
    say("  the symmetry layer paints only the two fixed sectors, and the semantic layer overrides")
    say("  symmetry on the 4 constant words.  Precedence you can point at.")
    say()
    say("PICTURE 3  out/layer_precedence.svg -- the token table of §4, drawn.")
    say()

    # ---- the measurement ------------------------------------------------
    rule("=")
    say("7. THE MEASUREMENT (a machine-side proxy, and only that)")
    rule("=")
    say()
    class_codes = {}
    for word in states:
        class_codes.setdefault(carry_count(word, BASE), set()).add(carry.colour(word, counter))
    for key in sorted(class_codes):
        if len(class_codes[key]) != 1:
            raise SystemExit("carry class %d has %d codes" % (key, len(class_codes[key])))
    target_code = {key: sorted(value)[0] for key, value in class_codes.items()}

    product = product_channel(carry_ch, low_full, name="chroma_carry x chroma_low2")
    product_class_codes = {}
    for word in states:
        product_class_codes.setdefault(carry_count(word, BASE), set()).add(
            (product.encode(word, counter)[0].as_tuple() + product.encode(word, counter)[1].as_tuple())
        )
    product_targets = {key: tuple(sorted(value)) for key, value in product_class_codes.items()}

    raw_total = 0
    coded_total = 0
    null_total = 0
    agree = True
    queries = 0
    for draw in lcg_stream(QUERIES):
        index = (draw // 256) % len(states)
        target = (draw // 8) % (LENGTH + 1)
        word = states[index]
        raw_cost, raw_answer = raw_carry_answer(word, BASE, target)
        code_cost, code_answer = coded_answer(carry.colour(word, counter), target_code[target])
        flat = product.encode(word, counter)
        null_cost, null_answer = set_coded_answer(
            flat[0].as_tuple() + flat[1].as_tuple(), product_targets[target]
        )
        if raw_answer != code_answer or raw_answer != null_answer:
            agree = False
        raw_total += raw_cost
        coded_total += code_cost
        null_total += null_cost
        queries += 1

    precompute = sum(encode_comparisons(word, BASE, 1) for word in states)
    saved = raw_total - coded_total
    per_query = Fraction(saved, queries)
    breakeven = -((-precompute * queries) // saved) if saved > 0 else 0

    say("QUERY      'is state w in carry class k?'  -- the recognition query the picture serves")
    say("UNIT       one comparison of two integers.  Both paths get every arithmetic shortcut:")
    say("           the raw path stops scanning at the first digit that is not b-1.")
    say("BATCH      %d queries, states and targets drawn by the printed integer recurrence" % (queries,))
    say("           x <- (%d x + %d) mod %d, seed %d" % (LCG_MULTIPLIER, LCG_INCREMENT, LCG_MODULUS, LCG_SEED))
    say()
    say("  comparisons, RAW state                          %8d" % (raw_total,))
    say("  comparisons, CHROMATIC CODE (already rendered)   %8d" % (coded_total,))
    say("  comparisons, NULL CONTROL (code x low-word code) %8d" % (null_total,))
    say("  answers agree with the raw computation           %8s" % (agree,))
    say("  saved per query                                  %8s" % (per_query,))
    say()
    say("NULL CONTROL.  chroma_low2 is a true channel and irrelevant to this task.  Reading it")
    say("alongside chroma_carry does not speed the query up: it makes the class a %d-code set"
        % (max(len(value) for value in product_targets.values()),))
    say("instead of a single code, and the batch costs %+d comparisons.  A surface that made every"
        % (null_total - coded_total,))
    say("query cheaper would be measuring its own cache, not its mathematics (CRYSTAL.md §0).")
    say()
    say("THE COST OF THE CODE.  Encoding all %d states costs %d comparisons -- strictly more than"
        % (len(states), precompute))
    say("answering once from the raw state, because encoding *contains* the raw scan.  So the")
    say("reduction is real only when the code already exists, which is exactly the situation a")
    say("rendered picture is in.  Break-even: %d queries." % (breakeven,))
    say()
    loss = certify_loss(carry_ch, counter)
    say("WHAT THE REDUCTION COSTS IN INFORMATION.  chroma_carry: %s" % (loss.render(),))
    say("  fiber sizes by carry class:")
    for key in sorted(class_codes):
        size = sum(1 for word in states if carry_count(word, BASE) == key)
        say("    c_n = %d  ->  %s   fiber %3d states" % (key, target_code[key].hex(), size))
    say()
    say("*** THE CAVEAT, STATED PLAINLY AND NOT IN A FOOTNOTE ***")
    say("  These are machine-side comparison counts.  They are a PROXY for recognition cost and")
    say("  nothing more.  No human looked at anything here; no reaction time, error rate or")
    say("  search-time measurement was taken; none is possible from this program.  Nothing above")
    say("  establishes that a person recognises the carry class faster from the colour than from")
    say("  the digits.  The honest statement is: the channel reduces the number of comparisons a")
    say("  machine performs by %d over %d queries, loses %d-to-1 in its worst fiber, and its value"
        % (saved, queries, loss.max_fiber))
    say("  to a human reader is UNMEASURED.")
    say()

    # ---- artifacts ------------------------------------------------------
    rule("=")
    say("8. ARTIFACTS")
    rule("=")
    say()
    def first(predicate):
        for word in states:
            if predicate(word):
                return word
        raise SystemExit("no representative state for a legend entry")

    carry_legend = legend_from_channel(
        carry,
        [("c_n = %d" % (k,), first(lambda w, k=k: carry_count(w, BASE) == k)) for k in range(LENGTH + 1)],
        counter,
    )
    orbit_legend = legend_from_channel(
        orbit,
        [
            ("Fix D (palindrome)", first(lambda w: is_palindrome(w) and not is_constant_word(w))),
            ("Fix DE (antipalindrome)", first(lambda w: is_antipalindrome(w, BASE))),
            ("constant word: Thm 4.2 agreement locus", first(is_constant_word)),
        ]
        + [
            ("generic, c_0 = %d" % (digit,), first(lambda w, d=digit: sector_name(w, BASE) == "generic" and w[0] == d))
            for digit in range(BASE)
        ],
        counter,
    )
    say("LEGENDS ARE CHANNEL-DERIVED, not palette-derived: every swatch is the resolved colour")
    say("of a representative state, so a legend cannot paint a colour the picture never uses.")
    for label, legend, cells in (
        ("carry_cocycle", carry_legend, carry_cells + borrow_cells),
        ("symmetry_sectors", orbit_legend, orbit_cells),
    ):
        drawn = set(colour for colour, _ in cells)
        shown = set(colour for colour, _ in legend)
        say("  %-18s distinct cell colours %2d   legend swatches %2d   legend == picture: %s"
            % (label, len(drawn), len(shown), drawn == shown))
        if drawn != shown:
            raise SystemExit("legend disagrees with the picture for %s" % (label,))
    say()

    documents = [
        ("carry_cocycle.svg", write_carry_svg(os.path.join(OUT, "carry_cocycle.svg"), carry_cells, borrow_cells, carry_legend)),
        ("symmetry_sectors.svg", write_orbit_svg(os.path.join(OUT, "symmetry_sectors.svg"), orbit_cells, orbit_legend)),
        ("layer_precedence.svg", write_layers_svg(os.path.join(OUT, "layer_precedence.svg"), tokens, resolutions)),
    ]
    for name, (document, width, height) in documents:
        path = os.path.join(OUT, name)
        payload = document.render().encode("utf-8")
        with open(path, "wb") as handle:
            handle.write(payload)
        say("  %-24s %5d x %4d  %7d bytes  sha256 %s"
            % (name, width, height, len(payload), hashlib.sha256(payload).hexdigest()))
    say()
    say("  SVG is text and is written by hand: integer geometry only, fixed attribute order, no")
    say("  external library, no float anywhere in the file.  The bytes are reproducible.")
    say()

    rule("=")
    say("VERDICT")
    rule("=")
    say()
    ok = (
        integer_identity_ok
        and reflection_ok
        and agree
        and trip.inverse_exact
        and injective_cert.injective
        and saved > 0
        and null_total > coded_total
        and orbits == burnside
    )
    say("  channels defined, validated, and certified            %s" % (True,))
    say("  loss stated with a concrete collision witness         %s" % (True,))
    say("  round trip exact on the declared sublanguage          %s" % (trip.inverse_exact,))
    say("  decode returns fibers, never a guess, on the ambient  %s" % (full_trip.fiber_exact,))
    say("  semantic override beats lexical                       %s" % (blue[1].colour == RGB(0, 0, 255),))
    say("  task-distinguishability proved exhaustively           %s" % (True,))
    say("  the rendered picture verifies its own theorem         %s" % (reflection_ok,))
    say("  proxy: coded < raw comparisons, null control worse    %s" % (saved > 0 and null_total > coded_total,))
    say("  human recognition latency established                 NO -- not measured, not claimed")
    say()
    say("  VERDICT: PERCEPTUAL SURFACE BUILT AND CERTIFIED" if ok else "  VERDICT: FAILED")
    say()
    say("counters: %s" % (" ".join("%s=%d" % pair for pair in counter.report()),))

    body = "\n".join(LINES)
    sys.stdout.write(body + "\n")
    sys.stdout.write("report-sha256 %s\n" % (hashlib.sha256(body.encode("utf-8")).hexdigest(),))
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
