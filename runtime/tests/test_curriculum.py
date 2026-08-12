#!/usr/bin/env python3
"""Adversarial test suite for runtime/curriculum (the education layer).

Repo norm (`collab/messages/0073-weaver-prasanga-norms.md` Sec.2, and the shape
of `runtime/tests/test_propagate.py`): a headline claim ships with its own
annihilation apparatus or it is not a claim.  Every capability below is paired
with a **planted-false control** that must be caught.  A control that passes
undetected is a failure of the suite and is reported as one.

The five controls the brief names explicitly are all here:

* ``control_edge_without_justification`` -- an edge with no justification;
* ``control_cycle_is_detected`` -- a cycle in the dependency graph;
* ``control_ordering_violates_a_valid_dependency`` -- an ordering breaking an
  edge that the graph says is real;
* ``control_choice_count_disagreeing_with_atlas`` -- a choice count that
  contradicts `ATLAS_OF_N.md` Theorem 4.2;
* ``control_learning_outcome_claim_is_rejected`` -- a claim of empirical
  learning benefit, rejected by the same kind of guard
  ``runtime/render``'s ``certify_claim`` uses.

Run:  python3 runtime/tests/test_curriculum.py
Exit: 0 iff every capability passed AND every control caught its falsehood.

Output is byte-identical across runs and across ``PYTHONHASHSEED``: no floats,
no clock, no set iteration in any reported value.
"""

from __future__ import annotations

import ast
import os
import subprocess
import sys
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, REPO)

from runtime.curriculum.depgraph import (  # noqa: E402
    ALLOWED_SOURCES,
    Concept,
    CurriculumError,
    DependencyGraph,
    Edge,
    Justification,
    build_graph,
    normalise_text,
    verify_quotes,
)
from runtime.curriculum.order import (  # noqa: E402
    ATLAS_CHOICE_NAMES,
    DEPENDENCY_ORDER,
    LEARNING_OUTCOME,
    Ordering,
    certify_curriculum_claim,
    choice_debt,
    compare,
    conventional_order,
    derive_order,
    levels,
    prove_topological,
    sort_key,
    unordered_pairs,
    verify_against_atlas,
    violations,
)
from runtime.curriculum.render import (  # noqa: E402
    CHOICE_AXES,
    QUANTISATION_BOUND,
    certify_separability,
    choice_cube_channel,
    choice_cube_svg,
    choice_language,
    choice_states,
    choice_tasks,
    order_svg,
    out_of_bounds,
    traversal_html,
    write_artifacts,
)
from runtime.render.channel import (  # noqa: E402
    INFORMATION_GAIN,
    Channel,
    certify_claim,
    certify_injectivity,
    certify_loss,
    certify_preservation,
    validate_channel,
)
from runtime.render.chroma import (  # noqa: E402
    COMPONENTS,
    RGB,
    ChromaticChannel,
    certify_precedence,
    layer,
)

# --------------------------------------------------------------------------
# harness
# --------------------------------------------------------------------------

CAPS: list = []
CONTROLS: list = []
LOG: list = []


def capability(name):
    def deco(fn):
        CAPS.append((name, fn))
        return fn
    return deco


def control(name):
    """A planted-false control.  The body returns True iff the runtime
    *rejected* or *detected* the planted falsehood."""
    def deco(fn):
        CONTROLS.append((name, fn))
        return fn
    return deco


GRAPH = build_graph()
DERIVED = derive_order(GRAPH)
CONVENTIONAL = conventional_order()

#: A justification known to be verbatim, for use in constructed test graphs.
GOOD = Justification(
    "notes/ATLAS_OF_N.md",
    "Theorem 4.2(1), chart (d)",
    '(d) is "the least infinite ordinal". No parameter.',
)


def _free(cid: str, own: int = 0, names=()) -> Concept:
    """A minimal well-formed concept, for building adversarial graphs."""
    if own:
        return Concept(cid, cid, "", own, tuple(names), "", choice_justification=GOOD, nonredundancy=GOOD)
    return Concept(cid, cid, "", 0, (), "", freedom_justification=GOOD)


# ==========================================================================
# 1. the graph
# ==========================================================================


@capability("graph builds, is acyclic, and has the declared shape")
def test_graph_shape():
    return (
        len(GRAPH.ids) == 13
        and len(GRAPH.edges) == 23
        and GRAPH.cycles() == ()
        and GRAPH.total_choices() == 3
        and set(GRAPH.roots()) == {"successor", "symmetry", "quotient"}
    )


@capability("every citation in the graph is verbatim in the file it cites")
def test_quotes_verbatim():
    failures = verify_quotes(GRAPH)
    if failures:
        LOG.append("    unverified quotes: %s" % (list(failures),))
    return failures == () and len(GRAPH.all_justifications()) == 39


@capability("every edge carries a Justification with a source, a locator and a quote")
def test_every_edge_justified():
    for edge in GRAPH.edges:
        just = edge.justification
        if not isinstance(just, Justification):
            return False
        if just.source not in ALLOWED_SOURCES or not just.locator.strip() or not just.quote.strip():
            return False
    return True


@capability("every concept justifies its choice count in both directions")
def test_choice_counts_justified():
    for concept in GRAPH.concepts:
        if concept.own_choices == 0 and concept.freedom_justification is None:
            return False
        if concept.own_choices > 0 and (concept.choice_justification is None or concept.nonredundancy is None):
            return False
    return True


@capability("ancestors and depth agree with a brute-force recomputation")
def test_closure_oracle():
    for cid in GRAPH.ids:
        # brute force: repeated relaxation, sharing no code path with the cached walk
        reachable = set()
        changed = True
        while changed:
            changed = False
            for edge in GRAPH.edges:
                if edge.concept == cid or edge.concept in reachable:
                    if edge.prerequisite not in reachable:
                        reachable.add(edge.prerequisite)
                        changed = True
        if reachable != set(GRAPH.ancestors(cid)):
            return False
        longest = 0
        for parent in GRAPH.parents(cid):
            longest = max(longest, 1 + GRAPH.depth(parent))
        if longest != GRAPH.depth(cid):
            return False
    return True


# ==========================================================================
# 2. the choice metric
# ==========================================================================


@capability("the derived choice counts agree with ATLAS_OF_N Theorem 4.2")
def test_atlas_agreement():
    agreement = verify_against_atlas(GRAPH)
    if not agreement.ok:
        LOG.append("    atlas disagreement: %s" % (list(agreement.failures),))
    return agreement.ok and agreement.checked == 16


@capability("positional notation requires exactly three choices, and introduces none")
def test_positional_three_choices():
    return (
        GRAPH.choices_required("positional") == 3
        and GRAPH.own_choices("positional") == 0
        and tuple(sorted(name for _, name in GRAPH.choice_sources("positional")))
        == tuple(sorted(ATLAS_CHOICE_NAMES))
    )


@capability("generation and symmetry require zero choices")
def test_generation_and_symmetry_are_free():
    return all(
        GRAPH.choices_required(cid) == 0
        for cid in ("successor", "iteration", "symmetry", "orbit", "cardinality", "order")
    )


@capability("the three choices are held by three distinct concepts, one each")
def test_three_distinct_choice_holders():
    holders = tuple(sorted(c.cid for c in GRAPH.concepts if c.own_choices))
    return holders == ("cocycle_carry", "finite_quotient", "torsor_endianness") and all(
        GRAPH.concept(cid).own_choices == 1 for cid in holders
    )


# ==========================================================================
# 3. the derived order
# ==========================================================================


@capability("the derived order is topological, and the proof covers every edge")
def test_derived_is_topological():
    proof = prove_topological(GRAPH)
    return len(proof) == len(GRAPH.edges) and violations(GRAPH, DERIVED) == ()


@capability("the tie-break is never consulted on an edge")
def test_tiebreak_never_decides_an_edge():
    for edge in GRAPH.edges:
        left = sort_key(GRAPH, edge.prerequisite)
        right = sort_key(GRAPH, edge.concept)
        if left[:2] >= right[:2]:
            return False
        if not (left[0] <= right[0] and left[1] < right[1]):
            return False
    return True


@capability("positional notation lands last and group action lands third")
def test_where_they_land():
    return (
        DERIVED.position("positional") == 13
        and DERIVED.position("symmetry") == 3
        and DERIVED.position("orbit") == 5
        and DERIVED.sequence[-4:] == ("finite_quotient", "torsor_endianness", "cocycle_carry", "positional")
    )


@capability("the derived order is a chain of antichains, and the unordered pairs are declared")
def test_levels_and_unordered_pairs():
    pairs = unordered_pairs(GRAPH, DERIVED)
    for left, right in pairs:
        if sort_key(GRAPH, left)[:2] != sort_key(GRAPH, right)[:2]:
            return False
        if (left, right) in {e.key for e in GRAPH.edges} or (right, left) in {e.key for e in GRAPH.edges}:
            return False
    return len(levels(GRAPH)) == 8 and len(pairs) == 5


@capability("every choice-free concept precedes every choice in the derived order")
def test_choices_come_last():
    first_choice = min(
        DERIVED.position(c.cid) for c in GRAPH.concepts if c.own_choices
    )
    return all(
        DERIVED.position(c.cid) < first_choice
        for c in GRAPH.concepts
        if GRAPH.choices_required(c.cid) == 0
    ) and first_choice == 10


# ==========================================================================
# 4. the comparison
# ==========================================================================


@capability("the conventional order violates 11 of 23 edges and carries a debt of 7")
def test_conventional_numbers():
    broken = violations(GRAPH, CONVENTIONAL)
    debt = choice_debt(GRAPH, CONVENTIONAL)
    return len(broken) == 11 and debt.total == 7 and debt.first_choice_position == 4 and debt.deferred_choice_free == 6


@capability("the derived order violates nothing and carries no debt")
def test_derived_numbers():
    debt = choice_debt(GRAPH, DERIVED)
    return violations(GRAPH, DERIVED) == () and debt.total == 0 and debt.deferred_choice_free == 0


@capability("each reported violation names an edge that really is in the graph")
def test_violations_are_real_edges():
    keys = {edge.key for edge in GRAPH.edges}
    for item in violations(GRAPH, CONVENTIONAL):
        if (item.prerequisite, item.concept) not in keys:
            return False
        if not (item.concept_position < item.prerequisite_position):
            return False
    return True


@capability("the comparison row reports where the two concepts of the direction land")
def test_comparison_rows():
    rows = compare(GRAPH, (DERIVED, CONVENTIONAL))
    return (
        rows[0].positional_position == 13
        and rows[0].symmetry_position == 3
        and rows[1].positional_position == 6
        and rows[1].symmetry_position == 13
        and rows[0].violated_edges == 0
        and rows[1].violated_edges == 11
    )


# ==========================================================================
# 5. the picture
# ==========================================================================


@capability("the three choices are separable: own component >= 60, others <= the bound")
def test_separability():
    cert = certify_separability(choice_cube_channel())
    if not cert.separable:
        LOG.append("    separability failures: %s" % (list(cert.failures),))
    return (
        cert.separable
        and cert.states == 8
        and cert.flips_checked == 24
        and cert.own_minimum >= 60
        and cert.cross_maximum <= QUANTISATION_BOUND
        and cert.clamped_states == 0
    )


@capability("the choice cube passes runtime/render's own channel certificates")
def test_cube_passes_render_certificates():
    chroma = choice_cube_channel()
    channel = chroma.channel()
    if not validate_channel(channel).ok:
        return False
    if not certify_injectivity(channel).injective:
        return False
    if certify_loss(channel).image_size != 8:
        return False
    if not certify_precedence(chroma).ok:
        return False
    for task in choice_tasks():
        preservation = certify_preservation(channel, task)
        if not preservation.preserved or preservation.violations:
            return False
    return True


@capability("the three layers claim disjoint single components covering all three")
def test_layer_claims_disjoint():
    chroma = choice_cube_channel()
    claimed = [tuple(item.claims) for item in chroma.layers]
    flat = sorted(name for entry in claimed for name in entry)
    return all(len(entry) == 1 for entry in claimed) and flat == sorted(COMPONENTS)


@capability("both pictures draw entirely inside their declared canvas")
def test_pictures_in_bounds():
    chroma = choice_cube_channel()
    cert = certify_separability(chroma)
    return out_of_bounds(order_svg(GRAPH, DERIVED, CONVENTIONAL)) == () and out_of_bounds(
        choice_cube_svg(chroma, cert)
    ) == ()


@capability("every colour in the choice-cube SVG is one the channel actually computed")
def test_svg_colours_come_from_the_channel():
    import re

    chroma = choice_cube_channel()
    cert = certify_separability(chroma)
    body = choice_cube_svg(chroma, cert).render()
    resolved = {chroma.resolve(state).colour.hex() for state in chroma.language.states}
    painted = set()
    for match in re.finditer(r'<rect[^>]*fill="(#[0-9a-f]{6})"[^>]*><title>base=', body):
        painted.add(match.group(1))
    return painted == resolved and len(painted) == 8


@capability("the traversal HTML quotes every step's justification verbatim")
def test_html_carries_the_quotes():
    chroma = choice_cube_channel()
    cert = certify_separability(chroma)
    html = traversal_html(
        GRAPH, DERIVED, CONVENTIONAL, order_svg(GRAPH, DERIVED, CONVENTIONAL), choice_cube_svg(chroma, cert), cert
    )
    from runtime.render.svg import escape

    flat = " ".join(html.split())
    for edge in GRAPH.edges:
        fragment = escape(" ".join(edge.justification.quote.split()))
        if fragment not in flat:
            LOG.append("    HTML is missing a quote: %s" % (edge.justification.cite(),))
            return False
    # the honesty section must survive into the artifact, not only into the console
    return (
        "an empirical claim about how humans learn" in flat
        and "There is no learner anywhere in this computation" in flat
        and "What would settle it" in flat
    )


# ==========================================================================
# 6. the guard
# ==========================================================================


@capability("a dependency-order claim is accepted, with its scope spelled out")
def test_dependency_claim_accepted():
    cert = certify_curriculum_claim(DERIVED, DEPENDENCY_ORDER, GRAPH)
    return cert.accepted and "Nothing about learners is asserted" in cert.reason


# ==========================================================================
# 7. discipline
# ==========================================================================

PACKAGE = os.path.join(REPO, "runtime", "curriculum")
PACKAGE_FILES = tuple(
    os.path.join(PACKAGE, name) for name in sorted(os.listdir(PACKAGE)) if name.endswith(".py")
)
DEMO = os.path.join(REPO, "runtime", "demo", "curriculum_demo.py")


def scan_for_floats(path: str) -> list:
    """AST walk: float/complex literals, true division, and float()/round()."""
    with open(path, "r", encoding="utf-8") as handle:
        tree = ast.parse(handle.read(), filename=path)
    name = os.path.basename(path)
    findings = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Constant) and isinstance(node.value, (float, complex)):
            findings.append("%s:%d float literal %r" % (name, node.lineno, node.value))
        elif isinstance(node, ast.BinOp) and isinstance(node.op, ast.Div):
            findings.append("%s:%d true division" % (name, node.lineno))
        elif isinstance(node, ast.AugAssign) and isinstance(node.op, ast.Div):
            findings.append("%s:%d true division" % (name, node.lineno))
        elif isinstance(node, ast.Call) and isinstance(node.func, ast.Name):
            if node.func.id in ("float", "complex", "round"):
                findings.append("%s:%d %s()" % (name, node.lineno, node.func.id))
    return findings


@capability("no floating point anywhere in the package or its demo")
def test_no_floats():
    for path in PACKAGE_FILES + (DEMO,):
        findings = scan_for_floats(path)
        if findings:
            LOG.append("    floats: %s" % (findings,))
            return False
    return True


@capability("the package imports only the standard library, runtime.render and itself")
def test_imports_are_bounded():
    allowed_roots = {"runtime"}
    stdlib_ok = True
    for path in PACKAGE_FILES:
        with open(path, "r", encoding="utf-8") as handle:
            tree = ast.parse(handle.read(), filename=path)
        for node in ast.walk(tree):
            names = []
            if isinstance(node, ast.Import):
                names = [alias.name for alias in node.names]
            elif isinstance(node, ast.ImportFrom):
                if node.level:  # relative import inside the package
                    continue
                names = [node.module or ""]
            for name in names:
                root = name.split(".")[0]
                if root in allowed_roots:
                    if not (name.startswith("runtime.render") or name.startswith("runtime.curriculum")):
                        LOG.append("    forbidden runtime import %s in %s" % (name, path))
                        stdlib_ok = False
                    continue
                if root not in ("os", "sys", "re", "ast", "dataclasses", "typing", "fractions", "__future__",
                                "hashlib", "subprocess", "tempfile"):
                    LOG.append("    non-stdlib import %s in %s" % (name, path))
                    stdlib_ok = False
    return stdlib_ok


@capability("the demo runs, exits 0, and is byte-identical under a changed PYTHONHASHSEED")
def test_demo_is_deterministic():
    outputs = []
    for seed in ("0", "12345"):
        environment = dict(os.environ)
        environment["PYTHONHASHSEED"] = seed
        result = subprocess.run(
            [sys.executable, DEMO], cwd=REPO, env=environment, capture_output=True
        )
        if result.returncode != 0:
            LOG.append("    demo exited %d: %s" % (result.returncode, result.stderr.decode()[-400:]))
            return False
        outputs.append(result.stdout)
    if outputs[0] != outputs[1]:
        LOG.append("    demo output differs across PYTHONHASHSEED")
        return False
    return b"report-sha256 " in outputs[0]


@capability("the artifacts are written and are byte-identical across two writes")
def test_artifacts_deterministic():
    with tempfile.TemporaryDirectory() as first, tempfile.TemporaryDirectory() as second:
        a = write_artifacts(first, GRAPH, DERIVED, CONVENTIONAL)
        b = write_artifacts(second, GRAPH, DERIVED, CONVENTIONAL)
        if len(a) != 3 or len(b) != 3:
            return False
        for (path_a, _), (path_b, _) in zip(a, b):
            with open(path_a, "rb") as handle:
                left = handle.read()
            with open(path_b, "rb") as handle:
                right = handle.read()
            if left != right or not left:
                return False
    return True


# ==========================================================================
# CONTROLS -- planted falsehoods that must be caught
# ==========================================================================


@control("an edge with no justification is refused")
def control_edge_without_justification():
    g = DependencyGraph("planted")
    g.add_concept(_free("a"))
    g.add_concept(_free("b"))
    try:
        g.add_edge(Edge("a", "b", None))
    except CurriculumError:
        return len(g.edges) == 0
    return False


@control("an edge whose 'justification' is a bare string is refused")
def control_justification_must_be_a_justification():
    g = DependencyGraph("planted")
    g.add_concept(_free("a"))
    g.add_concept(_free("b"))
    try:
        g.add_edge(Edge("a", "b", "because I said so"))
    except CurriculumError:
        return True
    return False


@control("a justification with an empty quote is refused")
def control_empty_quote():
    try:
        Justification("notes/ATLAS_OF_N.md", "Theorem 4.2", "   \n  ")
    except CurriculumError:
        return True
    return False


@control("a justification with no locator is refused")
def control_missing_locator():
    try:
        Justification("notes/ATLAS_OF_N.md", "", "No parameter.")
    except CurriculumError:
        return True
    return False


@control("a citation to a file outside ALLOWED_SOURCES is refused")
def control_unvetted_source():
    try:
        Justification("notes/INVENTED.md", "Theorem 1", "trust me")
    except CurriculumError:
        return True
    return False


@control("a fabricated quote -- plausible, but not in the cited file -- is detected")
def control_fabricated_quote():
    g = DependencyGraph("planted")
    g.add_concept(_free("a"))
    g.add_concept(_free("b"))
    fake = Justification(
        "notes/ATLAS_OF_N.md",
        "Theorem 4.2(4)",
        "Positional notation is a chart of pi_0 requiring four choices, the fourth being a "
        "choice of grouping symbol.",
    )
    g.add_edge(Edge("a", "b", fake))
    failures = verify_quotes(g)
    return len(failures) == 1 and "a->b" in failures[0]


@control("a quote altered by a single word is detected")
def control_altered_quote():
    g = DependencyGraph("planted")
    g.add_concept(_free("a"))
    g.add_concept(_free("b"))
    altered = Justification(
        "notes/ATLAS_OF_N.md",
        "Theorem 4.2(1), chart (d)",
        '(d) is "the least infinite cardinal". No parameter.',
    )
    g.add_edge(Edge("a", "b", altered))
    return len(verify_quotes(g)) == 1


@control("a cycle in the dependency graph is detected, and no order is produced")
def control_cycle_is_detected():
    g = DependencyGraph("planted")
    for cid in ("a", "b", "c"):
        g.add_concept(_free(cid))
    g.add_edge(Edge("a", "b", GOOD))
    g.add_edge(Edge("b", "c", GOOD))
    g.add_edge(Edge("c", "a", GOOD))
    cycles = g.cycles()
    if len(cycles) != 1 or set(cycles[0]) != {"a", "b", "c"}:
        return False
    try:
        derive_order(g)
    except CurriculumError:
        return True
    return False


@control("a self-loop is refused")
def control_self_loop():
    g = DependencyGraph("planted")
    g.add_concept(_free("a"))
    try:
        g.add_edge(Edge("a", "a", GOOD))
    except CurriculumError:
        return True
    return False


@control("a duplicate edge is refused")
def control_duplicate_edge():
    g = DependencyGraph("planted")
    g.add_concept(_free("a"))
    g.add_concept(_free("b"))
    g.add_edge(Edge("a", "b", GOOD))
    try:
        g.add_edge(Edge("a", "b", GOOD))
    except CurriculumError:
        return True
    return False


@control("an ordering that violates a dependency the graph claims valid is caught")
def control_ordering_violates_a_valid_dependency():
    # swap positional notation to the front of the derived order: it now precedes
    # all five of the things a cited theorem says it depends on.
    sequence = ("positional",) + tuple(cid for cid in DERIVED.sequence if cid != "positional")
    planted = Ordering("planted-positional-first", sequence)
    broken = violations(GRAPH, planted)
    concepts = {item.concept for item in broken}
    expected = set(GRAPH.parents("positional"))
    return (
        len(broken) == len(expected)
        and concepts == {"positional"}
        and {item.prerequisite for item in broken} == expected
    )


@control("an ordering that omits a concept is refused rather than scored")
def control_ordering_must_cover_the_graph():
    planted = Ordering("planted-partial", tuple(cid for cid in DERIVED.sequence if cid != "orbit"))
    try:
        violations(GRAPH, planted)
    except CurriculumError:
        return True
    return False


@control("a choice count that disagrees with ATLAS_OF_N Theorem 4.2 is caught")
def control_choice_count_disagreeing_with_atlas():
    # plant a graph in which positional notation needs only two choices: drop the
    # carry entirely, exactly the falsehood Corollary 2.11.1 forbids.
    g = DependencyGraph("planted-two-choices")
    g.add_concept(_free("successor"))
    g.add_concept(_free("symmetry"))
    g.add_concept(_free("quotient"))
    g.add_concept(_free("iteration"))
    g.add_concept(_free("orbit"))
    g.add_concept(_free("cardinality"))
    g.add_concept(_free("order"))
    g.add_concept(_free("free_monoid"))
    g.add_concept(_free("factorization"))
    from runtime.curriculum.depgraph import BASE, ENDIANNESS

    g.add_concept(_free("finite_quotient", 1, (BASE,)))
    g.add_concept(_free("torsor_endianness", 1, (ENDIANNESS,)))
    g.add_concept(_free("cocycle_carry"))          # <-- the plant: carrying is free
    g.add_concept(_free("positional"))
    for prerequisite, concept in (
        ("successor", "iteration"), ("iteration", "free_monoid"), ("symmetry", "orbit"),
        ("symmetry", "cardinality"), ("quotient", "cardinality"), ("orbit", "cardinality"),
        ("cardinality", "order"), ("quotient", "finite_quotient"), ("successor", "finite_quotient"),
        ("finite_quotient", "torsor_endianness"), ("finite_quotient", "cocycle_carry"),
        ("torsor_endianness", "cocycle_carry"), ("cocycle_carry", "positional"),
        ("successor", "factorization"), ("iteration", "factorization"),
    ):
        g.add_edge(Edge(prerequisite, concept, GOOD))
    agreement = verify_against_atlas(g)
    return (
        not agreement.ok
        and any("positional" in failure and "3" in failure for failure in agreement.failures)
    )


@control("a graph in which positional notation introduces its own choice is caught")
def control_positional_owning_a_choice():
    g = build_graph()
    # rebuild with positional carrying a parameter of its own -- Theorem 4.2 puts
    # all three upstream, so this must be rejected even though the total is still 3.
    planted = DependencyGraph("planted-owner")
    for concept in g.concepts:
        if concept.cid == "positional":
            planted.add_concept(_free("positional", 1, ("an extra parameter",)))
        else:
            planted.add_concept(concept)
    for edge in g.edges:
        planted.add_edge(edge)
    agreement = verify_against_atlas(planted)
    return not agreement.ok and any("introduces its own choices" in f for f in agreement.failures)


@control("a concept claiming choice-freedom with no justification is refused")
def control_unjustified_freedom():
    try:
        Concept("x", "x", "", 0, (), "")
    except CurriculumError:
        return True
    return False


@control("a choice-carrying concept with no nonredundancy citation is refused")
def control_choice_without_nonredundancy():
    try:
        Concept("x", "x", "", 1, ("a choice",), "", choice_justification=GOOD)
    except CurriculumError:
        return True
    return False


@control("a choice count that disagrees with its own list of choice names is refused")
def control_choice_count_mismatch():
    try:
        Concept("x", "x", "", 2, ("only one",), "", choice_justification=GOOD, nonredundancy=GOOD)
    except CurriculumError:
        return True
    return False


@control("a claim of empirical learning benefit is REJECTED")
def control_learning_outcome_claim_is_rejected():
    cert = certify_curriculum_claim(DERIVED, LEARNING_OUTCOME, GRAPH)
    return (
        not cert.accepted
        and "contains no learner" in cert.reason
        and "not* an empirical claim about how humans learn" in cert.reason
    )


@control("an unknown claim kind is refused rather than silently accepted")
def control_unknown_claim_kind():
    try:
        certify_curriculum_claim(DERIVED, "proven-to-work-in-classrooms", GRAPH)
    except CurriculumError:
        return True
    return False


@control("an INFORMATION_GAIN claim on the choice cube is rejected by runtime/render")
def control_information_gain_claim_is_rejected():
    chroma = choice_cube_channel()
    greedy = Channel(
        "choice_cube[planted information gain]",
        chroma.language,
        lambda state: chroma.resolve(state).colour,
        claim=INFORMATION_GAIN,
    )
    cert = certify_claim(greedy)
    return not cert.accepted and "function of state" in cert.reason


@control("a choice cube wired so two choices share a component is caught")
def control_choices_sharing_a_component():
    language = choice_language()
    planted = ChromaticChannel(
        "planted_shared_component",
        language,
        (
            # base and endianness both drive Co: the picture would show two
            # parameters as one, which is the whole failure mode.
            layer("ancestry", lambda s: RGB(0, 0, 80) if s[0] == 0 else RGB(80, 0, 0), ("Co",)),
            layer("family", lambda s: RGB(0, 0, 40) if s[1] == 0 else RGB(40, 0, 0), ("Co", "Cg")),
            layer("symmetry", lambda s: RGB(110, 110, 110) if s[2] == 0 else RGB(170, 170, 170), ("Y",)),
        ),
    )
    cert = certify_separability(planted)
    return not cert.separable and not cert.disjoint_claims


@control("a choice cube in which one layer paints everything is caught")
def control_one_layer_paints_everything():
    language = choice_language()
    planted = ChromaticChannel(
        "planted_monolithic",
        language,
        (
            layer("ancestry", lambda s: RGB(0, 0, 80) if s[0] == 0 else RGB(80, 0, 0), COMPONENTS),
            layer("family", lambda s: None if s[1] == 0 else RGB(40, 0, 0), ("Cg",)),
            layer("symmetry", lambda s: None if s[2] == 0 else RGB(170, 170, 170), ("Y",)),
        ),
    )
    cert = certify_separability(planted)
    return not cert.separable


@control("a choice cube whose eight states do not get eight colours is caught")
def control_colliding_choice_cube():
    language = choice_language()
    planted = ChromaticChannel(
        "planted_collision",
        language,
        (
            # the base is not painted at all: 8 states, 4 colours
            layer("ancestry", lambda s: RGB(0, 0, 80), ("Co",)),
            layer("family", lambda s: RGB(120, 0, 0) if s[1] == 0 else RGB(0, 60, 0), ("Cg",)),
            layer("symmetry", lambda s: RGB(110, 110, 110) if s[2] == 0 else RGB(170, 170, 170), ("Y",)),
        ),
    )
    cert = certify_separability(planted)
    return not cert.separable and not cert.injective


@control("the float scanner itself catches a planted float, so a green scan means something")
def control_float_scanner_works():
    with tempfile.TemporaryDirectory() as directory:
        literal = os.path.join(directory, "planted.py")
        with open(literal, "w", encoding="utf-8") as handle:
            handle.write("x = 0.5\n")
        division = os.path.join(directory, "planted_div.py")
        with open(division, "w", encoding="utf-8") as handle:
            handle.write("a = 1\nb = a / 2\n")
        clean = os.path.join(directory, "clean.py")
        with open(clean, "w", encoding="utf-8") as handle:
            handle.write("a = 1\nb = a // 2\n")
        return (
            scan_for_floats(literal) == ["planted.py:1 float literal 0.5"]
            and scan_for_floats(division) == ["planted_div.py:2 true division"]
            and scan_for_floats(clean) == []
        )


@control("a picture drawn off-canvas is caught by the bounds checker")
def control_off_canvas_is_caught():
    from runtime.render.svg import SVG

    doc = SVG(100, 100, "planted")
    doc.rect(10, 10, 20, 20, fill=RGB(0, 0, 0))
    doc.rect(90, 90, 40, 40, fill=RGB(0, 0, 0))   # spills off the right and bottom
    findings = out_of_bounds(doc)
    return len(findings) == 1 and "outside 100x100" in findings[0]


@control("an unknown concept in an edge is refused")
def control_unknown_concept():
    g = DependencyGraph("planted")
    g.add_concept(_free("a"))
    try:
        g.add_edge(Edge("a", "ghost", GOOD))
    except CurriculumError:
        return True
    return False


# ==========================================================================
# report
# ==========================================================================


def summary() -> str:
    rows = compare(GRAPH, (DERIVED, CONVENTIONAL))
    cert = certify_separability(choice_cube_channel())
    lines = [
        "the numbers this suite is asserting:",
        "  graph            : %s" % (GRAPH.report(),),
        "  citations        : %d checked, %d unverified" % (len(GRAPH.all_justifications()), len(verify_quotes(GRAPH))),
        "  derived order    : %s" % (" -> ".join(DERIVED.sequence),),
        "  positional lands : derived %d/13, conventional %d/13"
        % (DERIVED.position("positional"), CONVENTIONAL.position("positional")),
        "  group action lands: derived %d/13, conventional %d/13"
        % (DERIVED.position("symmetry"), CONVENTIONAL.position("symmetry")),
        "  violations       : derived %d/%d, conventional %d/%d"
        % (rows[0].violated_edges, rows[0].total_edges, rows[1].violated_edges, rows[1].total_edges),
        "  choice debt      : derived %d, conventional %d" % (rows[0].debt, rows[1].debt),
        "  separability     : %s" % (cert.render(),),
        "",
        "  and what is NOT asserted: anything about learners.  There is none in the domain.",
    ]
    return "\n".join(lines)


def main() -> int:
    passed = failed = 0
    for name, fn in CAPS:
        try:
            ok = bool(fn())
        except Exception as exc:  # noqa: BLE001
            ok = False
            LOG.append("    %s: %r" % (name, exc))
        if ok:
            passed += 1
            print("PASS  %s" % name)
        else:
            failed += 1
            print("FAIL  %s" % name)
    for name, fn in CONTROLS:
        try:
            ok = bool(fn())
        except Exception as exc:  # noqa: BLE001
            ok = False
            LOG.append("    %s: %r" % (name, exc))
        if ok:
            passed += 1
            print("PASS  %s (planted falsehood was rejected)" % name)
        else:
            failed += 1
            print("FAIL  %s (planted falsehood was ACCEPTED)" % name)
    print()
    print(summary())
    if LOG:
        print()
        print("diagnostics:")
        for line in LOG:
            print(line)
    print()
    print("SUMMARY capabilities=%d controls=%d passed=%d failed=%d"
          % (len(CAPS), len(CONTROLS), passed, failed))
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
