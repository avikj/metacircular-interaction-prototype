#!/usr/bin/env python3
"""Order derivation, the choice metric, and the guards on what may be claimed.

Three things live here, and only the first is mathematics.

1. **The derived order.**  Sort concepts by ``(choices_required, depth, cid)``.
   The first key is `ATLAS_OF_N.md` Theorem 4.2's parameter count; the second
   is longest-path depth in the dependency graph; the third is an **arbitrary
   alphabetical tie-break with no mathematical content**, and
   ``unordered_pairs`` reports exactly which adjacencies rest on it.
   ``derive_order`` is proved (``prove_topological``) to produce a topological
   order, so its violation count is zero *because of a proof*, not because it
   was tuned.

2. **The comparison.**  ``violations`` counts edges an ordering breaks;
   ``choice_debt`` counts choices introduced before the structure that
   motivates them.  Both are exact integer counts over the whole edge/closure
   set -- nothing sampled.

3. **The guard.**  ``certify_curriculum_claim`` plays the role
   ``runtime/render``'s ``certify_claim`` plays for channels.  There, a channel
   claiming INFORMATION_GAIN is rejected because a channel is a function of
   state.  Here, a curriculum claiming LEARNING_OUTCOME is rejected because a
   dependency graph contains no learner: the graph's states are theorems, the
   rejection is a statement about what the object *is*, and it is not a matter
   of taste.  `ATLAS_OF_N.md` Corollary 4.3 already draws this line and this
   module does not weaken it.

No floats.  Exact integer arithmetic only.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Optional, Sequence, Tuple

from .depgraph import BASE, CARRY, ENDIANNESS, CurriculumError, DependencyGraph, Edge

# --------------------------------------------------------------------------
# 0. orderings
# --------------------------------------------------------------------------


@dataclass(frozen=True)
class Ordering:
    """A teaching sequence: concept ids, first to last."""

    name: str
    sequence: Tuple[str, ...]
    description: str = ""
    provenance: str = ""

    def position(self, cid: str) -> int:
        """1-based position.  Raises if the concept is not in the sequence."""
        return self.sequence.index(cid) + 1

    def __len__(self) -> int:
        return len(self.sequence)


def _check_covers(graph: DependencyGraph, ordering: Ordering) -> None:
    missing = set(graph.ids) - set(ordering.sequence)
    extra = set(ordering.sequence) - set(graph.ids)
    if missing:
        raise CurriculumError("ordering %r omits %s" % (ordering.name, sorted(missing)))
    if extra:
        raise CurriculumError("ordering %r mentions unknown %s" % (ordering.name, sorted(extra)))
    if len(set(ordering.sequence)) != len(ordering.sequence):
        raise CurriculumError("ordering %r repeats a concept" % (ordering.name,))


# --------------------------------------------------------------------------
# 1. the derived order
# --------------------------------------------------------------------------


def sort_key(graph: DependencyGraph, cid: str) -> Tuple[int, int, str]:
    """``(choices required, dependency depth, id)``.

    The third component is a declared arbitrary convention.  It is in the key
    only so that the output is deterministic; ``unordered_pairs`` republishes
    every place it decided anything.
    """
    return (graph.choices_required(cid), graph.depth(cid), cid)


def derive_order(graph: DependencyGraph) -> Ordering:
    graph.assert_acyclic()
    sequence = tuple(sorted(graph.ids, key=lambda cid: sort_key(graph, cid)))
    return Ordering(
        name="derived",
        sequence=sequence,
        description="sorted by (choices required, dependency depth, id)",
        provenance="ATLAS_OF_N.md Theorem 4.2 (the choice count) + longest-path depth in the graph",
    )


def prove_topological(graph: DependencyGraph) -> Tuple[str, ...]:
    """Prove the sort key can never invert an edge, and return the argument.

    For an edge ``u -> v``: ``ancestors(u) | {u}`` is a subset of
    ``ancestors(v)``, so ``choices_required(u) <= choices_required(v)``; and
    ``depth(u) < depth(v)`` because depth is longest-path.  So the key is
    non-decreasing along every edge and *strictly* increasing whenever the
    first components tie.  The third key component is therefore never consulted
    on an edge, and no tie-break can invert a dependency.

    The returned strings are the per-edge verification of that argument --
    computed, not asserted.  An empty tuple means some edge failed it.
    """
    graph.assert_acyclic()
    lines = []
    for edge in graph.edges:
        cu = graph.choices_required(edge.prerequisite)
        cv = graph.choices_required(edge.concept)
        du = graph.depth(edge.prerequisite)
        dv = graph.depth(edge.concept)
        if not (cu <= cv and du < dv):
            return ()
        lines.append(
            "%s -> %s: choices %d <= %d, depth %d < %d"
            % (edge.prerequisite, edge.concept, cu, cv, du, dv)
        )
    return tuple(lines)


def levels(graph: DependencyGraph) -> Tuple[Tuple[Tuple[int, int], Tuple[str, ...]], ...]:
    """Group concepts by ``(choices, depth)``.

    This is the honest shape of the derived order: it is a chain of
    **antichains**, not a total order.  Concepts inside one level are ordered
    only by the alphabetical tie-break and the mathematics does not separate
    them.
    """
    buckets: Dict[Tuple[int, int], list] = {}
    for cid in graph.ids:
        buckets.setdefault((graph.choices_required(cid), graph.depth(cid)), []).append(cid)
    return tuple((key, tuple(sorted(buckets[key]))) for key in sorted(buckets))


def unordered_pairs(graph: DependencyGraph, ordering: Ordering) -> Tuple[Tuple[str, str], ...]:
    """Adjacent pairs in ``ordering`` separated only by the tie-break."""
    _check_covers(graph, ordering)
    out = []
    for index in range(len(ordering.sequence) - 1):
        left = ordering.sequence[index]
        right = ordering.sequence[index + 1]
        if sort_key(graph, left)[:2] == sort_key(graph, right)[:2]:
            out.append((left, right))
    return tuple(out)


# --------------------------------------------------------------------------
# 2. the conventional order
# --------------------------------------------------------------------------

#: The school sequence, encoded as an ordering over the same concepts.  This is
#: a **model** of the conventional curriculum, written by hand, and its
#: provenance is exactly that -- no curriculum document is cited, because none
#: was read.  Anyone who thinks the encoding is unfair should edit this tuple
#: and re-run: every number in the report is a function of it.
CONVENTIONAL_SEQUENCE = (
    "successor",           # counting, the number-word sequence
    "cardinality",         # "how many": counting to answer a cardinality question
    "order",               # comparing and ordering numbers, ordinal position
    "finite_quotient",     # grouping in tens; base-ten blocks
    "torsor_endianness",   # "the tens place is to the left": reading places in order
    "positional",          # place-value notation, multi-digit numerals
    "cocycle_carry",       # carrying / regrouping in the standard algorithms
    "iteration",           # skip counting, multiplication as repeated addition
    "factorization",       # prime factorization, GCD/LCM
    "free_monoid",         # formal strings, sequences, words (secondary algebra)
    "quotient",            # equivalence classes, modular arithmetic
    "orbit",               # orbits of a group action (tertiary)
    "symmetry",            # group theory (tertiary)
)

CONVENTIONAL_NOTES = {
    "successor": "counting, the number-word sequence",
    "cardinality": "'how many': counting used to answer a cardinality question",
    "order": "comparing and ordering numbers; ordinal position",
    "finite_quotient": "grouping in tens; base-ten blocks",
    "torsor_endianness": "'the tens place is to the left': places read in a fixed direction",
    "positional": "place-value notation, multi-digit numerals",
    "cocycle_carry": "carrying / regrouping in the standard written algorithms",
    "iteration": "skip counting; multiplication as repeated addition",
    "factorization": "prime factorization, GCD and LCM",
    "free_monoid": "formal strings, sequences and words (secondary algebra)",
    "quotient": "equivalence classes, modular arithmetic",
    "orbit": "orbits of a group action (tertiary)",
    "symmetry": "group theory (tertiary)",
}


def conventional_order() -> Ordering:
    return Ordering(
        name="conventional",
        sequence=CONVENTIONAL_SEQUENCE,
        description="the school sequence: counting, place value, algorithms, ... groups very late",
        provenance=(
            "hand-encoded in runtime/curriculum/order.py; NO curriculum document was read or "
            "cited, so this is a model of the conventional order and not a measurement of one"
        ),
    )


# --------------------------------------------------------------------------
# 3. the comparison
# --------------------------------------------------------------------------


@dataclass(frozen=True)
class Violation:
    """An edge an ordering breaks: the concept is taught before its prerequisite."""

    prerequisite: str
    concept: str
    prerequisite_position: int
    concept_position: int
    citation: str

    def render(self) -> str:
        return "%s (%d) taught AFTER %s (%d) which depends on it — %s" % (
            self.prerequisite,
            self.prerequisite_position,
            self.concept,
            self.concept_position,
            self.citation,
        )


def violations(graph: DependencyGraph, ordering: Ordering) -> Tuple[Violation, ...]:
    """Every edge ``u -> v`` with ``pos(v) < pos(u)``, in graph edge order."""
    _check_covers(graph, ordering)
    out = []
    for edge in graph.edges:
        pu = ordering.position(edge.prerequisite)
        pv = ordering.position(edge.concept)
        if pv < pu:
            out.append(
                Violation(
                    prerequisite=edge.prerequisite,
                    concept=edge.concept,
                    prerequisite_position=pu,
                    concept_position=pv,
                    citation=edge.justification.cite(),
                )
            )
    return tuple(out)


@dataclass(frozen=True)
class DebtItem:
    concept: str
    own_choices: int
    unmotivated_prerequisites: Tuple[str, ...]
    debt: int


@dataclass(frozen=True)
class DebtReport:
    """Unjustified choice debt: choices made before the structure motivating them.

    ``total`` is ``sum(own_choices(c) * |{u in ancestors(c) : pos(u) > pos(c)}|)``
    over choice-carrying concepts ``c``.  In words: every parameter introduced
    at ``c`` is charged once for each piece of structure that forces it to be a
    parameter at all but which the reader has not met yet.

    ``deferred_choice_free`` is the supplementary count: choice-free concepts
    taught after the first choice has been introduced.  A reader in that region
    is carrying a parameter they do not need for the concept in front of them.
    """

    ordering: str
    total: int
    items: Tuple[DebtItem, ...]
    first_choice_position: Optional[int]
    deferred_choice_free: int
    deferred_names: Tuple[str, ...]

    def render(self) -> str:
        return "%s: debt %d; first choice at position %s; %d choice-free concepts deferred behind it" % (
            self.ordering,
            self.total,
            "none" if self.first_choice_position is None else str(self.first_choice_position),
            self.deferred_choice_free,
        )


def choice_debt(graph: DependencyGraph, ordering: Ordering) -> DebtReport:
    _check_covers(graph, ordering)
    items = []
    total = 0
    first = None
    for cid in ordering.sequence:
        own = graph.own_choices(cid)
        if own > 0:
            position = ordering.position(cid)
            if first is None:
                first = position
            late = tuple(
                sorted(item for item in graph.ancestors(cid) if ordering.position(item) > position)
            )
            debt = own * len(late)
            total += debt
            items.append(DebtItem(cid, own, late, debt))
    deferred = tuple(
        cid
        for cid in ordering.sequence
        if first is not None and ordering.position(cid) > first and graph.choices_required(cid) == 0
    )
    return DebtReport(
        ordering=ordering.name,
        total=total,
        items=tuple(items),
        first_choice_position=first,
        deferred_choice_free=len(deferred),
        deferred_names=deferred,
    )


@dataclass(frozen=True)
class ComparisonRow:
    ordering: str
    violated_edges: int
    total_edges: int
    debt: int
    first_choice_position: Optional[int]
    deferred_choice_free: int
    positional_position: int
    symmetry_position: int


def compare(graph: DependencyGraph, orderings: Sequence[Ordering]) -> Tuple[ComparisonRow, ...]:
    rows = []
    for ordering in orderings:
        broken = violations(graph, ordering)
        debt = choice_debt(graph, ordering)
        rows.append(
            ComparisonRow(
                ordering=ordering.name,
                violated_edges=len(broken),
                total_edges=len(graph.edges),
                debt=debt.total,
                first_choice_position=debt.first_choice_position,
                deferred_choice_free=debt.deferred_choice_free,
                positional_position=ordering.position("positional"),
                symmetry_position=ordering.position("symmetry"),
            )
        )
    return tuple(rows)


# --------------------------------------------------------------------------
# 4. agreement with the theorem the whole thing rests on
# --------------------------------------------------------------------------

#: What `ATLAS_OF_N.md` Theorem 4.2 actually asserts, transcribed as data so a
#: graph that quietly disagrees with it is caught rather than believed.
ATLAS_CHOICE_TABLE = {
    "positional": 3,
    "successor": 0,
    "iteration": 0,
    "symmetry": 0,
    "cardinality": 0,
    "order": 0,
    "orbit": 0,
    "quotient": 0,
    "free_monoid": 0,
    "factorization": 0,
}

#: Theorem 4.2(2) names the three parameters and no others.
ATLAS_CHOICE_NAMES = (BASE, ENDIANNESS, CARRY)


@dataclass(frozen=True)
class AtlasAgreement:
    checked: int
    failures: Tuple[str, ...]

    @property
    def ok(self) -> bool:
        return not self.failures


def verify_against_atlas(graph: DependencyGraph) -> AtlasAgreement:
    """Check the graph's choice arithmetic against Theorem 4.2, item by item.

    Four independent checks, because a single one is easy to satisfy by
    accident:

    1. every entry of ``ATLAS_CHOICE_TABLE`` matches ``choices_required``;
    2. the multiset of choices in the whole graph is exactly the three
       parameters Theorem 4.2(2) names;
    3. positional notation inherits all three and introduces none of its own
       (they are its prerequisites, which is what "on top of" means);
    4. every choice-carrying concept cites a *nonredundancy* proof, since
       Theorem 4.2's force comes from each parameter being nonredundant by a
       separate mechanism.
    """
    failures = []
    checked = 0
    for cid, expected in sorted(ATLAS_CHOICE_TABLE.items()):
        checked += 1
        actual = graph.choices_required(cid)
        if actual != expected:
            failures.append(
                "Theorem 4.2 gives %s %d choice(s); the graph derives %d" % (cid, expected, actual)
            )
    checked += 1
    names = tuple(sorted(name for concept in graph.concepts for name in concept.choice_names))
    if names != tuple(sorted(ATLAS_CHOICE_NAMES)):
        failures.append("the graph's choices are %s, not Theorem 4.2(2)'s three parameters" % (list(names),))
    checked += 1
    inherited = tuple(sorted(name for _, name in graph.choice_sources("positional")))
    if inherited != tuple(sorted(ATLAS_CHOICE_NAMES)):
        failures.append("positional inherits %s, not the three parameters" % (list(inherited),))
    checked += 1
    if graph.own_choices("positional") != 0:
        failures.append("positional introduces its own choices; Theorem 4.2 puts all three upstream")
    for concept in graph.concepts:
        if concept.own_choices > 0:
            checked += 1
            if concept.nonredundancy is None:
                failures.append("%s introduces a choice with no nonredundancy citation" % (concept.cid,))
    return AtlasAgreement(checked=checked, failures=tuple(failures))


# --------------------------------------------------------------------------
# 5. the guard on claims -- the analogue of render.certify_claim
# --------------------------------------------------------------------------

DEPENDENCY_ORDER = "dependency-order"
LEARNING_OUTCOME = "learning-outcome"
CLAIM_KINDS = (DEPENDENCY_ORDER, LEARNING_OUTCOME)


@dataclass(frozen=True)
class CurriculumClaimCertificate:
    ordering: str
    kind: str
    accepted: bool
    reason: str

    def render(self) -> str:
        return "%s / %s: %s\n    %s" % (
            self.ordering,
            self.kind,
            "ACCEPTED" if self.accepted else "REJECTED",
            self.reason,
        )


#: The guardrail, quoted from the note so that weakening it here would be a
#: visible edit to a quotation rather than a change of tone.
ATLAS_GUARDRAIL = (
    "This corollary is a claim about dependency order and nothing else. It is *not* an "
    "empirical claim about how humans learn, in what order they should be taught, what is "
    "pedagogically effective, or what any curriculum ought to do."
)


def certify_curriculum_claim(
    ordering: Ordering, kind: str, graph: Optional[DependencyGraph] = None
) -> CurriculumClaimCertificate:
    """Accept a dependency-order claim; reject a learning-outcome claim.

    The rejection is structural, exactly as ``render.certify_claim``'s is.
    There: a channel is a function of state, so it cannot gain information.
    Here: the graph's vertices are mathematical constructions and its edges are
    theorems; **there is no learner in the domain**, no learner was observed,
    and no outcome was measured.  An ordering derived from it therefore cannot
    carry an empirical claim, whatever anyone would like it to say.
    """
    if kind not in CLAIM_KINDS:
        raise CurriculumError("unknown claim kind %r" % (kind,))
    if kind == LEARNING_OUTCOME:
        return CurriculumClaimCertificate(
            ordering=ordering.name,
            kind=kind,
            accepted=False,
            reason=(
                "rejected: the domain of this computation is %d mathematical constructions and "
                "%d theorems, and contains no learner, no trial, no outcome and no measurement; "
                "an order derived from prerequisite structure is a fact about definitions. "
                "ATLAS_OF_N.md Corollary 4.3: “%s”"
                % (
                    0 if graph is None else len(graph.ids),
                    0 if graph is None else len(graph.edges),
                    ATLAS_GUARDRAIL,
                )
            ),
        )
    return CurriculumClaimCertificate(
        ordering=ordering.name,
        kind=kind,
        accepted=True,
        reason=(
            "dependency order only: every edge is a cited theorem, every choice count is "
            "ATLAS_OF_N.md Theorem 4.2's, and the conclusion is that one construction is "
            "definable from another plus n parameters. Nothing about learners is asserted."
        ),
    )


__all__ = [
    "ATLAS_CHOICE_NAMES",
    "ATLAS_CHOICE_TABLE",
    "ATLAS_GUARDRAIL",
    "AtlasAgreement",
    "CLAIM_KINDS",
    "CONVENTIONAL_NOTES",
    "CONVENTIONAL_SEQUENCE",
    "ComparisonRow",
    "CurriculumClaimCertificate",
    "DEPENDENCY_ORDER",
    "DebtItem",
    "DebtReport",
    "LEARNING_OUTCOME",
    "Ordering",
    "Violation",
    "certify_curriculum_claim",
    "choice_debt",
    "compare",
    "conventional_order",
    "derive_order",
    "levels",
    "prove_topological",
    "sort_key",
    "unordered_pairs",
    "verify_against_atlas",
    "violations",
]
