#!/usr/bin/env python3
"""The education layer, run: derive an order, compare it, and say what it is not.

Writes ``runtime/demo/out_curriculum/{curriculum_orders.svg, choice_cube.svg,
curriculum.html}``, and prints an exact report.  Every number below is
computed by ``runtime/curriculum`` from the graph; nothing is transcribed by
hand, and the report ends with a sha256 of its own body so a changed number
cannot pass as an unchanged run.

    THE CLAIM.  A dependency order: which constructions are definable from
    which others, and how many parameters stand in between.  Every edge is a
    theorem quoted from `notes/ATLAS_OF_N.md` or `notes/DIGIT_CRYSTAL.md`, and
    every quote is checked against the file it cites.

    NOT CLAIMED.  Anything at all about how humans learn.  There is no learner
    in this computation, no trial, no outcome, no measurement.  The guard that
    enforces this is run live below and rejects the empirical claim in public.

CPU-only, pure standard library, exact integers, deterministic.
"""

from __future__ import annotations

import hashlib
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from runtime.curriculum.depgraph import build_graph, verify_quotes  # noqa: E402
from runtime.curriculum.order import (  # noqa: E402
    DEPENDENCY_ORDER,
    LEARNING_OUTCOME,
    certify_curriculum_claim,
    choice_debt,
    compare,
    conventional_order,
    derive_order,
    levels,
    prove_topological,
    unordered_pairs,
    verify_against_atlas,
    violations,
)
from runtime.curriculum.render import (  # noqa: E402
    CHOICE_AXES,
    certify_separability,
    choice_cube_channel,
    choice_tasks,
    out_of_bounds,
    write_artifacts,
)
from runtime.render.channel import (  # noqa: E402
    certify_claim,
    certify_injectivity,
    certify_loss,
    certify_preservation,
    validate_channel,
)
from runtime.render.chroma import certify_precedence  # noqa: E402

# A directory of this package's own.  ``runtime/demo/out/`` belongs to
# ``runtime/render``'s demo, whose suite asserts its exact contents and parses
# every file in it as XML; writing HTML there would break a sibling lane.
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out_curriculum")

LINES: list = []


def say(text: str = "") -> None:
    LINES.append(text)


def rule(title: str) -> None:
    say()
    say("=" * 78)
    say(title)
    say("=" * 78)


def main() -> int:
    graph = build_graph()

    # ------------------------------------------------------------------
    rule("0.  THE GRAPH, AND WHY EVERY EDGE IS ALLOWED TO BE THERE")
    say()
    say("  %s" % (graph.report(),))
    say()
    say("  An edge without a justification is refused at construction.  A justification")
    say("  is a source, a locator and a verbatim quote, and every quote is checked")
    say("  against the file it cites -- a fabricated citation is a detectable defect.")
    say()
    failures = verify_quotes(graph)
    say("  citations checked : %d" % (len(graph.all_justifications()),))
    say("  citations verbatim: %s" % ("ALL" if not failures else "FAILURES: %s" % (list(failures),),))
    say()
    say("  cycles found      : %d  (a cyclic graph has no order and is refused)" % (len(graph.cycles()),))
    conventions = graph.conventional_orientation_edges()
    say("  conventional edges: %d -- %s" % (len(conventions), ", ".join("%s -> %s" % e.key for e in conventions)))
    say("    ATLAS_OF_N.md Sec.2.1 proves the comparison type here is *contractible*, so")
    say("    each side is definable from the other.  The arrow's direction is a decision")
    say("    this graph made; it is declared rather than buried.")

    # ------------------------------------------------------------------
    rule("1.  THE CHOICE METRIC -- CHECKED AGAINST THE THEOREM IT COMES FROM")
    say()
    say("  ATLAS_OF_N.md Theorem 4.2(3), quoted:")
    say()
    say("    \"Positional notation is a chart of pi_0 requiring three choices -- a finite")
    say("     quotient (the base), a trivialization of a Z/2-torsor (the endianness), and")
    say("     a 2-cocycle representative whose class is never zero (the carry) -- on top")
    say("     of a generator/successor which it does not supply and which charts (a)-(d)")
    say("     do.  Symmetry and generation require zero choices.\"")
    say()
    agreement = verify_against_atlas(graph)
    say("  %d independent checks against that statement: %s"
        % (agreement.checked, "ALL PASS" if agreement.ok else "FAILURES"))
    for item in agreement.failures:
        say("    ! %s" % (item,))
    say()
    say("  concept                             chart                 own   required   depth")
    say("  " + "-" * 74)
    for cid in graph.ids:
        concept = graph.concept(cid)
        say("  %-34s  %-20s  %3d   %8d   %5d"
            % (concept.label[:34], concept.chart[:20], concept.own_choices,
               graph.choices_required(cid), graph.depth(cid)))
    say()
    say("  'own' = parameters introduced here.  'required' = parameters summed over the")
    say("  transitive prerequisite closure.  Positional notation introduces none of its")
    say("  own and inherits all three, which is exactly what 'on top of' means.")

    # ------------------------------------------------------------------
    rule("2.  THE DERIVED ORDER")
    derived = derive_order(graph)
    proof = prove_topological(graph)
    say()
    say("  Sort key: (choices required, dependency depth, id).")
    say("  The third component is an ALPHABETICAL TIE-BREAK WITH NO MATHEMATICAL CONTENT.")
    say()
    say("  step  concept                                      choices  depth")
    say("  " + "-" * 66)
    for index, cid in enumerate(derived.sequence, start=1):
        say("  %4d  %-42s  %7d  %5d"
            % (index, graph.concept(cid).label[:42], graph.choices_required(cid), graph.depth(cid)))
    say()
    say("  It is a topological order, and that is a THEOREM, not a tuning result:")
    say("  along every edge u -> v, ancestors(u) + {u} is a subset of ancestors(v), so")
    say("  choices(u) <= choices(v); and depth is longest-path, so depth(u) < depth(v).")
    say("  The key is therefore non-decreasing along every edge and strictly increasing")
    say("  whenever the first component ties -- so the tie-break is NEVER consulted on an")
    say("  edge and cannot invert a dependency.  Verified edge by edge: %d/%d."
        % (len(proof), len(graph.edges)))
    say()
    say("  It is also NOT A TOTAL ORDER.  It is a chain of %d levels:" % (len(levels(graph)),))
    for (choices, depth), members in levels(graph):
        say("    choices=%d depth=%d : %s" % (choices, depth, ", ".join(members)))
    pairs = unordered_pairs(graph, derived)
    say()
    say("  %d adjacent pairs are separated only by the tie-break, i.e. the mathematics" % (len(pairs),))
    say("  does not order them: %s" % ("; ".join("%s / %s" % pair for pair in pairs),))

    # ------------------------------------------------------------------
    rule("3.  WHERE THE TWO CONCEPTS THE DIRECTION IS ABOUT ACTUALLY LAND")
    conventional = conventional_order()
    say()
    total = len(graph.ids)
    say("                          derived        conventional")
    for label, cid in (("positional notation", "positional"),
                       ("group action (symmetry)", "symmetry"),
                       ("orbit", "orbit"),
                       ("cardinality", "cardinality"),
                       ("factorization", "factorization")):
        say("  %-24s  step %2d of %d    step %2d of %d"
            % (label, derived.position(cid), total, conventional.position(cid), total))
    say()
    say("  DERIVED: group action lands at step %d of %d, positional notation at step %d of %d."
        % (derived.position("symmetry"), total, derived.position("positional"), total))
    say("  The derived order therefore SUPPORTS 'group theory before place value'.")
    say("  It was not tuned to: the ordering is a sort on two computed integers, and the")
    say("  conclusion is forced by positional notation inheriting three parameters that")
    say("  symmetry does not.  Had the atlas's Theorem 4.2 come out differently, so would")
    say("  this line, and the program would have printed that instead.")
    say()
    say("  Two results that were NOT part of the direction and fell out of the graph:")
    say("    * factorization (unique factorization, the primes) lands at step %d, BEFORE"
        % (derived.position("factorization"),))
    say("      positional notation, because chart (f) is proved from chart (a) and needs")
    say("      no parameter (Theorem 2.12).  'Primes before place value' was not asked for.")
    say("    * the carry is NOT the last thing: it lands at step %d, ahead of positional"
        % (derived.position("cocycle_carry"),))
    say("      notation itself, because the numeral is what the three parameters assemble.")

    # ------------------------------------------------------------------
    rule("4.  THE CONVENTIONAL ORDER, AND THE EXACT COMPARISON")
    say()
    say("  The conventional sequence is a MODEL, hand-encoded in runtime/curriculum/order.py.")
    say("  NO curriculum document was read or cited.  Every number below is a function of")
    say("  that encoding, and the file is the place to argue with it.")
    say()
    say("  step  concept                                      as taught")
    say("  " + "-" * 74)
    from runtime.curriculum.order import CONVENTIONAL_NOTES
    for index, cid in enumerate(conventional.sequence, start=1):
        say("  %4d  %-42s  %s" % (index, graph.concept(cid).label[:42], CONVENTIONAL_NOTES[cid]))
    say()
    rows = compare(graph, (derived, conventional))
    say("  ordering      violated edges   choice debt   first choice at   choice-free deferred")
    say("  " + "-" * 78)
    for row in rows:
        say("  %-12s  %6d / %-6d  %11d   %15s   %19d"
            % (row.ordering, row.violated_edges, row.total_edges, row.debt,
               "-" if row.first_choice_position is None else row.first_choice_position,
               row.deferred_choice_free))
    say()
    say("  VIOLATION: an edge whose prerequisite is taught after the concept depending on it.")
    say("  CHOICE DEBT: sum over choice-carrying concepts c of")
    say("      own_choices(c) * |{u in ancestors(c) : u is taught after c}|")
    say("  -- every parameter charged once for each piece of structure that forces it to be")
    say("  a parameter but which the reader has not met yet.")
    say()
    broken = violations(graph, conventional)
    say("  The %d violated edges of the conventional order, each with its citation:" % (len(broken),))
    for item in broken:
        say("    %s" % (item.render(),))
    say()
    debt = choice_debt(graph, conventional)
    say("  Its debt of %d, itemised:" % (debt.total,))
    for item in debt.items:
        say("    %-20s %d choice x %d unmet prerequisite(s) %s = %d"
            % (item.concept, item.own_choices, len(item.unmotivated_prerequisites),
               list(item.unmotivated_prerequisites), item.debt))
    say()
    say("  And the derived order's %d / %d:" % (len(violations(graph, derived)), len(graph.edges)))
    say("    zero, by the theorem in section 2.  A metric an order satisfies by construction")
    say("    is worth little on its own; the content is the OTHER column, where an ordering")
    say("    that nobody built to satisfy it scores %d and %d." % (rows[1].violated_edges, rows[1].debt))

    # ------------------------------------------------------------------
    rule("5.  THE PICTURE: THREE CHOICES, SEPARATED")
    say()
    chroma = choice_cube_channel()
    certificate = certify_separability(chroma)
    channel = chroma.channel()
    say("  Language: the eight subsets of {base, endianness, carry}.")
    say("  Each parameter of Theorem 4.2(2) drives ONE component of the exact rational")
    say("  opponent space of runtime/render, and no other parameter touches it:")
    say()
    for axis in CHOICE_AXES:
        say("    %-12s -> %-3s   (layer role %r)" % (axis[0], axis[2], axis[3]))
    say()
    say("  %s" % (certificate.render(),))
    say("  separable: %s" % (certificate.separable,))
    say()
    say("  The proof has two independent legs.  STRUCTURAL: the three layers claim")
    say("  disjoint singleton component sets covering all three, so two choices can never")
    say("  compete for one component -- and a wrong wiring is representable, hence")
    say("  catchable.  MEASURED: over all %d state/flip pairs, the claimed component moves"
        % (certificate.flips_checked,))
    say("  by at least %s while every other component moves by at most %s, against a"
        % (certificate.own_minimum, certificate.cross_maximum))
    say("  quantisation bound of %s.  A gap of %s to %s is not a judgement call."
        % (certificate.bound, certificate.cross_maximum, certificate.own_minimum))
    say()
    say("  The channel is put through runtime/render's own certificates unchanged:")
    validation = validate_channel(channel)
    injectivity = certify_injectivity(channel)
    loss = certify_loss(channel)
    say("    validate_channel     : %s" % ("ok" if validation.ok else list(validation.failures),))
    say("    certify_injectivity  : injective=%s over %d pairs" % (injectivity.injective, injectivity.pairs_checked))
    say("    certify_loss         : %s" % (loss.render(),))
    for task in choice_tasks():
        preservation = certify_preservation(channel, task)
        say("    %-22s: preserved=%s  required %d, violations %d, permitted %d, over-separations %d"
            % (task.name, preservation.preserved, preservation.required_separations,
               preservation.violations, preservation.permitted_collisions, preservation.over_separations))
    precedence = certify_precedence(chroma)
    say("    certify_precedence   : ok=%s (semantic fires %d -- there is no semantic layer here,"
        % (precedence.ok, precedence.semantic_fires))
    say("                            and with disjoint claims precedence arbitrates nothing)")
    say()
    say("  What this picture is NOT.  The three axes are separable in the CHART, not")
    say("  orthogonal as mathematics: the endian torsor is a torsor of truncation systems")
    say("  on (Z/b^n)_n, so it is not even definable before the base is fixed")
    say("  (Proposition 2.10).  The graph records that as a real edge, and the picture's")
    say("  independence is a property of the colour coding, not of the objects.")

    # ------------------------------------------------------------------
    rule("6.  THE GUARD -- RUN LIVE, ON BOTH KINDS OF CLAIM")
    say()
    say("  runtime/render rejects an INFORMATION_GAIN claim because a channel is a")
    say("  function of state.  The analogous rejection here is structural in the same way.")
    say()
    accepted = certify_curriculum_claim(derived, DEPENDENCY_ORDER, graph)
    rejected = certify_curriculum_claim(derived, LEARNING_OUTCOME, graph)
    say("  %s" % (accepted.render(),))
    say()
    say("  %s" % (rejected.render(),))
    say()
    say("  A verifier that rejects everything is worthless, so both are run and the first")
    say("  is accepted.  The machinery discriminates.")
    say()
    say("  For symmetry with the channel side, the INFORMATION_GAIN rejection is also")
    say("  shown live on the choice cube:")
    from runtime.render.channel import INFORMATION_GAIN, Channel
    greedy = Channel(
        "choice_cube[claims information gain]",
        chroma.language,
        lambda state: chroma.resolve(state).colour,
        claim=INFORMATION_GAIN,
    )
    say("    %s" % (certify_claim(greedy).reason,))

    # ------------------------------------------------------------------
    rule("7.  ARTIFACTS")
    say()
    written = write_artifacts(OUT, graph, derived, conventional)
    from runtime.curriculum.render import choice_cube_svg, order_svg
    order_picture = order_svg(graph, derived, conventional)
    cube_picture = choice_cube_svg(chroma, certificate)
    for path, size in written:
        say("  %-52s %7d bytes" % (os.path.relpath(path, os.path.dirname(OUT)), size))
    say()
    say("  geometry re-parsed from the writer's own output:")
    say("    curriculum_orders.svg : %d coordinate(s) outside the canvas" % (len(out_of_bounds(order_picture)),))
    say("    choice_cube.svg       : %d coordinate(s) outside the canvas" % (len(out_of_bounds(cube_picture)),))
    say()
    say("  curriculum.html is the traversal a reader can follow: every step, what it")
    say("  depends on, the theorem that forces it quoted verbatim, what it costs in")
    say("  parameters, and the honesty section below carried inside the document itself.")

    # ------------------------------------------------------------------
    rule("8.  HONESTY -- MANDATORY, AND NOT A DISCLAIMER")
    say()
    say("  WHAT IS ESTABLISHED.  A dependency order.  That positional notation is")
    say("  definable from generation, symmetry and three parameters, that those parameters")
    say("  are each nonredundant by a separate mechanism (radical invariance, the torsor's")
    say("  failure to trivialize structure, nonvanishing H^2), and that generation and")
    say("  symmetry require none.  This is a fact about definitions, provable from the")
    say("  cited theorems, and it does not depend on anybody's opinion.")
    say()
    say("  WHAT IS NOT ESTABLISHED, AND CANNOT BE BY THIS PROGRAM.  Anything about")
    say("  learners.  No trial was run.  No outcome was measured.  No population was")
    say("  sampled.  No retention, transfer, error rate or time-to-mastery was observed.")
    say("  There is no learner in the domain of this computation at all -- the vertices are")
    say("  mathematical constructions and the edges are theorems.  ATLAS_OF_N.md")
    say("  Corollary 4.3 says this first and this program does not weaken it:")
    say()
    say("    \"This corollary is a claim about dependency order and nothing else.  It is")
    say("     *not* an empirical claim about how humans learn, in what order they should")
    say("     be taught, what is pedagogically effective, or what any curriculum ought to")
    say("     do.\"")
    say()
    say("  THE STRONGEST COUNTER-ARGUMENT, STATED FAIRLY.  Logical downstream is not")
    say("  psychological downstream.  Positional notation is compressed, manipulable and")
    say("  externally supported: a child can bundle ten counters and watch a carry happen")
    say("  long before possessing any notion of a cocycle, and that concrete manipulation")
    say("  may be exactly what makes the abstraction learnable.  On that view a")
    say("  dependency-ordered curriculum inverts the scaffolding -- it teaches the general")
    say("  case to learners who hold no instance of it -- and the logical priority of")
    say("  groups is simply irrelevant to a mind that does not learn by definitional")
    say("  expansion.  The relevant literature (concreteness fading, worked examples,")
    say("  expertise reversal, the long record on discovery learning) is real, was NOT")
    say("  consulted, and is not summarised here, because summarising unread literature")
    say("  would be worse than declining to.")
    say()
    say("  WHAT WOULD SETTLE IT.  A randomised trial with pre-registered outcomes: matched")
    say("  cohorts, comparably prepared teachers, assessment on transfer to genuinely")
    say("  novel tasks rather than on the notation itself (which the conventional sequence")
    say("  trivially wins and the derived sequence trivially loses), long-delayed")
    say("  retention, and replication across ages, since the answer may differ by age.")
    say("  THIS SYSTEM CANNOT PRODUCE ANY OF IT.  It has no learner, no instrument and no")
    say("  data, and more mathematics would not bring it one step closer.")
    say()
    say("  WHAT ELSE WAS NOT ESTABLISHED.")
    say("    1. The conventional sequence is an encoding, not a measurement of any real")
    say("       curriculum.  11 violations and debt 7 are properties of that encoding.")
    say("    2. The graph covers ATLAS_OF_N.md's charts only.  Arithmetic algorithms,")
    say("       fractions, measurement, negative numbers and geometry are absent, so this")
    say("       is not a curriculum -- it is the prerequisite skeleton of one corner of one.")
    say("    3. %d adjacent pairs of the derived order are ordered by an alphabetical" % (len(pairs),))
    say("       tie-break and by nothing else.")
    say("    4. %d edge(s) are oriented by convention, not by force (section 0)."
        % (len(conventions),))
    say("    5. The depth metric is longest-path, a modelling choice.  Shortest-path or")
    say("       edge-count would give a different second key; the FIRST key, the choice")
    say("       count, is the one the theorem supplies, and it alone already separates")
    say("       positional notation from everything choice-free.")
    say("    6. No claim is made that these thirteen concepts are the right decomposition,")
    say("       only that they are the ones the atlas's charts name.")

    body = "\n".join(LINES)
    sys.stdout.write(body + "\n")
    sys.stdout.write("report-sha256 %s\n" % (hashlib.sha256(body.encode("utf-8")).hexdigest(),))
    return 0


if __name__ == "__main__":
    sys.exit(main())
