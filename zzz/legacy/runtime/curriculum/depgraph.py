#!/usr/bin/env python3
"""The concept dependency graph of `notes/ATLAS_OF_N.md`, with justifications.

Every edge of this graph is a claim: *this prerequisite is forced*.  A claim
ships with the theorem that forces it or it is not a claim
(`collab/messages/0073-weaver-prasanga-norms.md` Sec.2), so an ``Edge`` carries a
``Justification`` -- a source file, a locator, and a **verbatim quote** -- and
``DependencyGraph.add_edge`` refuses an edge without one.  ``verify_quotes``
then goes further and checks that every quote actually occurs in the file it
cites, after whitespace normalisation.  A fabricated citation is therefore a
detectable defect and not a matter of good faith.

Exactness discipline, inherited from the rest of the runtime: pure Python 3
standard library, integers only, **no float anywhere in this package** (asserted
by an AST walk in ``runtime/tests/test_curriculum.py``), no ML, no network, no
randomness.  Deterministic: every iteration order below is either insertion
order or an explicit sort.

The choice bookkeeping is the point of the module.  ``Concept.own_choices``
counts the parameters *introduced at that concept*, in the exact sense of
`ATLAS_OF_N.md` Definition 4.1 and Theorem 4.2: a presentation is choice-free
when its parameter class is a point.  ``DependencyGraph.choices_required``
sums ``own_choices`` over the transitive prerequisite closure, so positional
notation inherits three choices it does not itself introduce -- which is
exactly the content of Theorem 4.2(3).
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from typing import Dict, Optional, Tuple

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

#: Only these files may be cited.  A citation to anything else is refused at
#: construction, so the graph cannot quietly acquire a dependency on prose that
#: nobody in this repo audited.
ALLOWED_SOURCES = (
    "notes/ATLAS_OF_N.md",
    "notes/DIGIT_CRYSTAL.md",
    "notes/CROSS_LENS.md",
)


class CurriculumError(Exception):
    """Raised on an unjustified edge, a bad citation, or a cyclic graph."""


# --------------------------------------------------------------------------
# 0. quotes, and how they are checked
# --------------------------------------------------------------------------


def normalise_text(text: str) -> str:
    """Collapse a Markdown fragment to a single whitespace-normalised line.

    Line-leading blockquote markers (``>``) are stripped because a quote taken
    from a blockquote is still that file's text; nothing else is stripped, so a
    quote that differs from the source in any *word* still fails.
    """
    pieces = []
    for line in text.split("\n"):
        stripped = line.strip()
        while stripped.startswith(">"):
            stripped = stripped[1:].strip()
        pieces.append(stripped)
    return " ".join(" ".join(pieces).split())


@dataclass(frozen=True)
class Justification:
    """Why a prerequisite is forced: a source, a locator, and the text itself.

    ``quote`` must be verbatim.  ``verify_quotes`` reads ``source`` and checks
    that ``normalise_text(quote)`` is a substring of the normalised file.
    """

    source: str
    locator: str
    quote: str

    def __post_init__(self) -> None:
        if not self.source.strip():
            raise CurriculumError("justification with no source")
        if self.source not in ALLOWED_SOURCES:
            raise CurriculumError("justification cites %r, not one of %s" % (self.source, list(ALLOWED_SOURCES)))
        if not self.locator.strip():
            raise CurriculumError("justification of %s with no locator" % (self.source,))
        if not self.quote.strip():
            raise CurriculumError("justification %s %s with an empty quote" % (self.source, self.locator))

    def cite(self) -> str:
        return "%s %s" % (self.source, self.locator)

    def render(self) -> str:
        return "%s: \u201c%s\u201d" % (self.cite(), normalise_text(self.quote))


def _read_source(source: str, root: Optional[str] = None) -> str:
    path = os.path.join(root if root is not None else REPO_ROOT, source)
    with open(path, "r", encoding="utf-8") as handle:
        return handle.read()


def verify_quotes(graph: "DependencyGraph", root: Optional[str] = None) -> Tuple:
    """Check every quote in the graph against the file it cites.

    Returns a tuple of failure strings; empty means every citation is verbatim.
    This is the control that makes a citation an assertion rather than a
    decoration -- see ``test_planted_fabricated_quote``.
    """
    cache: Dict[str, str] = {}
    failures = []
    for label, just in graph.all_justifications():
        if just.source not in cache:
            cache[just.source] = normalise_text(_read_source(just.source, root))
        if normalise_text(just.quote) not in cache[just.source]:
            failures.append("%s: quote not found in %s (%s)" % (label, just.source, just.locator))
    return tuple(failures)


# --------------------------------------------------------------------------
# 1. concepts and edges
# --------------------------------------------------------------------------


@dataclass(frozen=True)
class Concept:
    """One teachable concept, with the parameters it introduces.

    ``own_choices`` is the number of parameters this concept *introduces*, in
    the sense of `ATLAS_OF_N.md` Definition 4.1 ("choice-free if the parameter
    class is a point").  ``choice_names`` names them.  Both the presence and
    the absence of a choice must be justified: a concept with
    ``own_choices > 0`` needs ``choice_justification``, and one with
    ``own_choices == 0`` needs ``freedom_justification``.
    """

    cid: str
    label: str
    chart: str
    own_choices: int
    choice_names: Tuple[str, ...]
    gloss: str
    freedom_justification: Optional[Justification] = None
    choice_justification: Optional[Justification] = None
    nonredundancy: Optional[Justification] = None

    def __post_init__(self) -> None:
        if self.own_choices < 0:
            raise CurriculumError("%s: negative choice count" % (self.cid,))
        if self.own_choices != len(self.choice_names):
            raise CurriculumError(
                "%s: own_choices=%d but %d choice names" % (self.cid, self.own_choices, len(self.choice_names))
            )
        if self.own_choices == 0 and self.freedom_justification is None:
            raise CurriculumError("%s: claims to be choice-free with no justification" % (self.cid,))
        if self.own_choices > 0 and self.choice_justification is None:
            raise CurriculumError("%s: introduces %d choice(s) with no justification" % (self.cid, self.own_choices))
        if self.own_choices > 0 and self.nonredundancy is None:
            raise CurriculumError("%s: introduces a choice with no nonredundancy proof cited" % (self.cid,))


@dataclass(frozen=True)
class Edge:
    """``prerequisite`` must be understood before ``concept``, and here is why.

    ``symmetric`` marks the one situation the atlas explicitly creates: a pair
    of charts whose comparison type is *contractible*, so that each is
    definable from the other and the orientation drawn here is a presentation
    convention rather than a forced dependency (`ATLAS_OF_N.md` Sec.2.1,
    Residual 2.1).  It is recorded rather than hidden because an ordering that
    rests on such an edge rests on a convention, and the report says how many.
    """

    prerequisite: str
    concept: str
    justification: Justification
    symmetric: bool = False
    note: str = ""

    @property
    def key(self) -> Tuple[str, str]:
        return (self.prerequisite, self.concept)

    def render(self) -> str:
        mark = " [orientation conventional]" if self.symmetric else ""
        return "%s -> %s%s\n      %s" % (self.prerequisite, self.concept, mark, self.justification.render())


# --------------------------------------------------------------------------
# 2. the graph
# --------------------------------------------------------------------------


class DependencyGraph:
    """A DAG of concepts.  Every edge carries its justification or is refused."""

    def __init__(self, name: str = "atlas-of-N") -> None:
        self.name = name
        self._concepts: Dict[str, Concept] = {}
        self._edges: list = []
        self._parents: Dict[str, list] = {}
        self._children: Dict[str, list] = {}
        self._depth_cache: Dict[str, int] = {}
        self._ancestor_cache: Dict[str, frozenset] = {}

    # -- construction -----------------------------------------------------

    def add_concept(self, concept: Concept) -> str:
        if concept.cid in self._concepts:
            raise CurriculumError("duplicate concept %r" % (concept.cid,))
        self._concepts[concept.cid] = concept
        self._parents[concept.cid] = []
        self._children[concept.cid] = []
        self._invalidate()
        return concept.cid

    def add_edge(self, edge: Edge) -> Tuple[str, str]:
        """Install a justified prerequisite edge.

        Refuses, in this order: an edge with no ``Justification`` at all; an
        edge naming an unknown concept; a self-loop; a duplicate.  The first is
        the planted-false control the brief asks for.
        """
        if not isinstance(edge, Edge):
            raise CurriculumError("add_edge expects an Edge, got %r" % (type(edge).__name__,))
        if edge.justification is None:
            raise CurriculumError("edge %s -> %s has no justification" % (edge.prerequisite, edge.concept))
        if not isinstance(edge.justification, Justification):
            raise CurriculumError(
                "edge %s -> %s: justification is %r, not a Justification"
                % (edge.prerequisite, edge.concept, type(edge.justification).__name__)
            )
        if not normalise_text(edge.justification.quote):
            raise CurriculumError("edge %s -> %s: empty quote" % (edge.prerequisite, edge.concept))
        for cid in (edge.prerequisite, edge.concept):
            if cid not in self._concepts:
                raise CurriculumError("edge mentions unknown concept %r" % (cid,))
        if edge.prerequisite == edge.concept:
            raise CurriculumError("self-loop on %r" % (edge.prerequisite,))
        if edge.key in tuple(item.key for item in self._edges):
            raise CurriculumError("duplicate edge %s -> %s" % edge.key)
        self._edges.append(edge)
        self._parents[edge.concept].append(edge.prerequisite)
        self._children[edge.prerequisite].append(edge.concept)
        self._invalidate()
        return edge.key

    def _invalidate(self) -> None:
        self._depth_cache = {}
        self._ancestor_cache = {}

    # -- access -----------------------------------------------------------

    @property
    def concepts(self) -> Tuple[Concept, ...]:
        """Insertion order -- deterministic, and never the driver of an order."""
        return tuple(self._concepts[cid] for cid in self._concepts)

    @property
    def ids(self) -> Tuple[str, ...]:
        return tuple(self._concepts)

    @property
    def edges(self) -> Tuple[Edge, ...]:
        return tuple(self._edges)

    def concept(self, cid: str) -> Concept:
        if cid not in self._concepts:
            raise CurriculumError("unknown concept %r" % (cid,))
        return self._concepts[cid]

    def parents(self, cid: str) -> Tuple[str, ...]:
        self.concept(cid)
        return tuple(self._parents[cid])

    def children(self, cid: str) -> Tuple[str, ...]:
        self.concept(cid)
        return tuple(self._children[cid])

    def roots(self) -> Tuple[str, ...]:
        return tuple(cid for cid in self._concepts if not self._parents[cid])

    def edge(self, prerequisite: str, concept: str) -> Edge:
        for item in self._edges:
            if item.key == (prerequisite, concept):
                return item
        raise CurriculumError("no edge %s -> %s" % (prerequisite, concept))

    def all_justifications(self) -> Tuple:
        """Every ``(label, Justification)`` in the graph, in a fixed order."""
        out = []
        for cid in self._concepts:
            concept = self._concepts[cid]
            for slot in ("freedom_justification", "choice_justification", "nonredundancy"):
                just = getattr(concept, slot)
                if just is not None:
                    out.append(("%s.%s" % (cid, slot), just))
        for item in self._edges:
            out.append(("%s->%s" % item.key, item.justification))
        return tuple(out)

    # -- structure --------------------------------------------------------

    def cycles(self) -> Tuple[Tuple[str, ...], ...]:
        """Every cycle reachable by a deterministic DFS, as vertex tuples.

        Returned rather than raised so that a caller can *test* for a cycle;
        ``assert_acyclic`` is the raising form.  Detection is the planted-false
        control ``test_planted_cycle_is_detected``.
        """
        colour: Dict[str, int] = {cid: 0 for cid in self._concepts}
        stack: list = []
        found: list = []
        seen: set = set()

        def visit(cid: str) -> None:
            colour[cid] = 1
            stack.append(cid)
            for child in self._children[cid]:
                if colour[child] == 0:
                    visit(child)
                elif colour[child] == 1:
                    start = stack.index(child)
                    cycle = tuple(stack[start:])
                    rotation = min(range(len(cycle)), key=lambda i: cycle[i])
                    canonical = cycle[rotation:] + cycle[:rotation]
                    if canonical not in seen:
                        seen.add(canonical)
                        found.append(canonical)
            stack.pop()
            colour[cid] = 2

        for cid in self._concepts:
            if colour[cid] == 0:
                visit(cid)
        return tuple(found)

    def assert_acyclic(self) -> None:
        cycles = self.cycles()
        if cycles:
            raise CurriculumError("dependency cycle: %s" % (" -> ".join(cycles[0] + (cycles[0][0],)),))

    def ancestors(self, cid: str) -> frozenset:
        """Transitive prerequisites of ``cid``, excluding ``cid`` itself."""
        if cid in self._ancestor_cache:
            return self._ancestor_cache[cid]
        self.concept(cid)
        self.assert_acyclic()
        out: set = set()
        frontier = list(self._parents[cid])
        while frontier:
            item = frontier.pop()
            if item in out:
                continue
            out.add(item)
            frontier.extend(self._parents[item])
        result = frozenset(out)
        self._ancestor_cache[cid] = result
        return result

    def descendants(self, cid: str) -> frozenset:
        self.concept(cid)
        self.assert_acyclic()
        out: set = set()
        frontier = list(self._children[cid])
        while frontier:
            item = frontier.pop()
            if item in out:
                continue
            out.add(item)
            frontier.extend(self._children[item])
        return frozenset(out)

    def depth(self, cid: str) -> int:
        """Longest path from any root.  Roots have depth 0."""
        if cid in self._depth_cache:
            return self._depth_cache[cid]
        self.concept(cid)
        self.assert_acyclic()
        parents = self._parents[cid]
        value = 0 if not parents else 1 + max(self.depth(p) for p in parents)
        self._depth_cache[cid] = value
        return value

    # -- the choice metric ------------------------------------------------

    def own_choices(self, cid: str) -> int:
        return self.concept(cid).own_choices

    def choices_required(self, cid: str) -> int:
        """Total parameters standing between the reader and this concept.

        ``sum(own_choices)`` over ``{cid} | ancestors(cid)``.  This is the
        quantity `ATLAS_OF_N.md` Theorem 4.2(3) computes for chart (e) and gets
        **3**; the graph must reproduce it, and ``order.verify_against_atlas``
        checks that it does.
        """
        total = self.concept(cid).own_choices
        for item in self.ancestors(cid):
            total += self._concepts[item].own_choices
        return total

    def choice_sources(self, cid: str) -> Tuple[Tuple[str, str], ...]:
        """``(concept_id, choice_name)`` for every choice ``cid`` inherits."""
        out = []
        for item in sorted(self.ancestors(cid) | {cid}):
            for name in self._concepts[item].choice_names:
                out.append((item, name))
        return tuple(out)

    def total_choices(self) -> int:
        return sum(concept.own_choices for concept in self.concepts)

    def conventional_orientation_edges(self) -> Tuple[Edge, ...]:
        return tuple(item for item in self._edges if item.symmetric)

    # -- reporting --------------------------------------------------------

    def report(self) -> str:
        return "%s: %d concepts, %d justified edges, %d choices, %d conventional orientations" % (
            self.name,
            len(self._concepts),
            len(self._edges),
            self.total_choices(),
            len(self.conventional_orientation_edges()),
        )


# --------------------------------------------------------------------------
# 3. the quotes -- every one verbatim from the cited note
# --------------------------------------------------------------------------

A = "notes/ATLAS_OF_N.md"
D = "notes/DIGIT_CRYSTAL.md"

# choice-freedom, per Theorem 4.2(1)
J_SUCCESSOR_FREE = Justification(
    A,
    "Theorem 4.2(1), chart (a)",
    '(a) is "the initial $(1+X)$-algebra": initial objects are unique up to unique\n'
    "isomorphism, and by Theorem 3.1's framing the type of such identifications is\n"
    "contractible. No parameter.",
)
J_ITERATION_FREE = Justification(
    A,
    "Theorem 4.2(1), chart (b)",
    '(b) is "the free monoid on the terminal object": the terminal object $1$ is itself\n'
    'unique up to unique isomorphism, so "one generator" is not a choice. No parameter.',
)
J_SYMMETRY_FREE = Justification(
    A,
    "Theorem 4.2(3)",
    "Symmetry and generation require zero choices, because they live one level up, before\n"
    "truncation: chart (c) presents the *type* whose $\\pi_0$ is $\\mathbb{N}$, and its\n"
    "universal property is parameter-free.",
)
J_QUOTIENT_FREE = Justification(
    A,
    "Theorem 4.2(1), chart (c)",
    '(c) is "the free symmetric monoidal category on one object", then $\\pi_0$. Same\n'
    "argument. No parameter.",
)
J_ORDER_FREE = Justification(
    A,
    "Theorem 4.2(1), chart (d)",
    '(d) is "the least infinite ordinal". No parameter.',
)

# the three choices, per Theorem 4.2(2)
J_BASE_CHOICE = Justification(
    A,
    "Theorem 4.2(2)(i)",
    "**(i) a base** $b \\ge 2$ \u2014 equivalently a finite quotient $\\mathbb{N} \\twoheadrightarrow\n"
    "\\mathbb{Z}/b$, equivalently the multiplicative submonoid $\\{b^n\\}$.",
)
J_BASE_NONREDUNDANT = Justification(
    A,
    "Corollary 2.8.1",
    "Up to continuous intertranslation the family of positional charts is indexed by the\n"
    "nonempty finite sets of primes, an infinite index set, and *no* universal property of\n"
    "$\\mathbb{N}$ distinguishes a member of it.",
)
J_ENDIAN_CHOICE = Justification(
    A,
    "Theorem 4.2(2)(ii)",
    "**(ii) an endianness** $\\varepsilon\\in\\mathbb{Z}/2$ \u2014 a trivialization of the torsor\n"
    "$\\mathcal{T}$ of Proposition 2.10.",
)
J_ENDIAN_NONREDUNDANT = Justification(
    A,
    "Theorem 4.2(2)(ii), nonredundancy clause",
    "Nonredundant: only one sheet admits a group-valued limit (`DIGIT_CRYSTAL.md` Lemma 4.1),\n"
    "and the chart symmetry group drops from\n"
    "$(\\mathbb{Z}/2)^2$ to $\\mathbb{Z}/2$ on the completion with kernel exactly the\n"
    "endian generator (Corollary 4.5).",
)
J_CARRY_CHOICE = Justification(
    A,
    "Theorem 4.2(2)(iii)",
    "**(iii) a digit section** $s$ (a transversal for $\\mathbb{Z}/b$ in $\\mathbb{Z}$), whose\n"
    "coboundary is the carry.",
)
J_CARRY_NONREDUNDANT = Justification(
    A,
    "Theorem 4.2(2)(iii) / Proposition 2.11",
    "by Proposition 2.11 the\n"
    "class $[c_n]$ is nonzero for *every* choice, so no section makes the chart carry-free\n"
    "(Corollary 2.11.1).",
)

# structural choice-freedom for the remaining nodes
J_ORBIT_FREE = Justification(
    A,
    "Theorem 4.2(3)",
    "Symmetry and generation require zero choices, because they live one level up, before\n"
    "truncation",
)
J_FREE_MONOID_FREE = Justification(
    D,
    "Sec.0",
    "The digit alphabet is $A=A_b=\\{0,1,\\dots,b-1\\}$; $A^{*}$ is the\n"
    "free monoid on $A$; $W_n=A^{n}$ is the set of words of length $n$",
)
J_CARDINALITY_FREE = Justification(
    A,
    "Theorem 4.2(1), chart (c)",
    '(c) is "the free symmetric monoidal category on one object", then $\\pi_0$. Same\n'
    "argument. No parameter.",
)
J_POSITIONAL_FREE = Justification(
    A,
    "Theorem 4.2(2)",
    "Chart (e) is the value of a construction $\\mathrm{Dig}(b,\\varepsilon,s)$ on three\n"
    "parameters, none of them supplied by $\\mathbb{N}$, and it presupposes chart (a) besides.",
)
J_FACTORIZATION_FREE = Justification(
    A,
    "Sec.1(f)",
    "**Unique factorization is a chart-defining statement, not a theorem about numbers**: it\n"
    "says exactly that $e$ is an isomorphism, i.e. that this monoid is *free*.",
)

# edge justifications
J_SUCC_TO_ITER = Justification(
    A,
    "Residual 2.1(2)",
    "The two signatures are **definitional expansions of each other**: $s(n) := n+1$ and\n"
    "$n+m := s^m(n)$, each definable from the other by the primitive recursion the other\n"
    "supplies.",
)
J_ITER_TO_FREE_MONOID = Justification(
    D,
    "Lemma 0.1, proof",
    "Homomorphism: for $u\\in W_m,v\\in W_k$,\n"
    "$\\Phi(u)\\circ\\Phi(v)=[b^{m},L(u)]\\circ[b^{k},L(v)]=[b^{m+k},\\,b^{m}L(v)+L(u)]\n"
    "=[b^{m+k},L(uv)]=\\Phi(uv)$.",
)
J_SYM_TO_ORBIT = Justification(
    A,
    "Theorem 2.5, proof",
    "$S_n$ acts on linear orders by transport; transitively (any two orders on a\n"
    "finite set differ by a unique relabelling) and freely (a permutation preserving a linear\n"
    "order is the identity).",
)
J_SYM_TO_CARDINALITY = Justification(
    A,
    "Sec.1(c)",
    "Let $\\mathbb{F} := \\operatorname{core}(\\mathbf{FinSet})$, the groupoid of finite sets and\n"
    "bijections, with $\\sqcup$ (unit $\\varnothing$) and $\\times$ (unit $[1]$).",
)
J_QUOT_TO_CARDINALITY = Justification(
    A,
    "Sec.0",
    "**Post-truncation.** A set, obtained by $\\pi_0$ (in HoTT: the set-truncation\n"
    "$\\lVert-\\rVert_0$). This is $\\mathbb{N}$.",
)
J_ORBIT_TO_CARDINALITY = Justification(
    A,
    "Theorem 2.2, proof",
    "the objects of $\\mathbb{F}$ fall into connected components indexed by $\\mathbb{N}$.",
)
J_CARDINALITY_TO_ORDER = Justification(
    A,
    "Theorem 2.5",
    "For an\n"
    "$n$-element set $X$, the fibre $U^{-1}(X) = \\{\\text{linear orders on } X\\}$ is a torsor\n"
    "under $\\operatorname{Aut}(X) = S_n$, of cardinality $n!$.",
)
J_SYM_TO_ORDER = Justification(
    A,
    "Theorem 2.5",
    "chart (d) reaches $\\mathbb{N}$ from (c) by **rigidifying** \u2014\n"
    "killing $\\operatorname{Aut}$ by adding a trivializing datum.",
)
J_ORBIT_TO_ORDER = Justification(
    A,
    "Theorem 3.2, proof",
    "A linear order on an $n$-element type $X$ is the same datum as an equivalence\n"
    "$X \\simeq \\mathrm{Fin}\\,n$",
)
J_QUOT_TO_FINITE_QUOT = Justification(
    A,
    "Theorem 4.2(2)(i)",
    "equivalently a finite quotient $\\mathbb{N} \\twoheadrightarrow\n\\mathbb{Z}/b$",
)
J_SUCC_TO_FINITE_QUOT = Justification(
    A,
    "Theorem 4.2(2), presupposition",
    "The alphabet\n  $\\{0,\\dots,b-1\\}$ is an initial segment produced by iterating the successor",
)
J_FINITE_QUOT_TO_TORSOR = Justification(
    A,
    "Proposition 2.10",
    "Let $\\mathcal{T} := \\{\\pi,\\varsigma\\}$ be the\n"
    "two truncation systems on the family $(\\mathbb{Z}/b^n)_n$ ($\\pi_n$ deletes the *most*\n"
    "significant digit; $\\varsigma_n$ deletes the *least*).",
)
J_ORBIT_TO_TORSOR = Justification(
    A,
    "Proposition 2.10(1)",
    "the action of\n"
    "$\\mathbb{Z}/2 = \\langle R\\rangle$ on $\\mathcal{T}$ is free and transitive:\n"
    "**$\\mathcal{T}$ is a $\\mathbb{Z}/2$-torsor.**",
)
J_FINITE_QUOT_TO_COCYCLE = Justification(
    A,
    "Proposition 2.11",
    "It is a normalized\n"
    "$2$-cocycle, and its class in $H^2(\\mathbb{Z}/b^n;\\mathbb{Z}/b) \\cong \\mathbb{Z}/b$ is\n"
    "**nonzero**.",
)
J_TORSOR_TO_COCYCLE = Justification(
    D,
    "after Lemma 4.1",
    "So $\\mathbb Z_b$ is a topological *group* (it carries $+$, hence the odometer, hence the\n"
    "carry cocycle (2.1)); $\\Sigma_b$ is only a profinite *set*.",
)
J_SUCC_TO_POSITIONAL = Justification(
    A,
    "Theorem 4.2(2), presupposition",
    "the\n"
    "  evaluation $\\sum c_i b^i$ uses $+$ and $\\times$, which are defined by primitive\n"
    "  recursion (Theorem 2.1); the existence-and-uniqueness proof (Theorem 2.7) is an\n"
    "  induction.",
)
J_FREE_MONOID_TO_POSITIONAL = Justification(
    A,
    "Sec.1(e)",
    "Its *native* operation is **not** addition: it is\n"
    "concatenation, which by `DIGIT_CRYSTAL.md` Lemma 0.1 is the composition of the free\n"
    "affine monoid $M_b = \\Phi(A_b^*) \\subset \\operatorname{Aff}(\\mathbb{Z})$ generated by\n"
    "$\\gamma_d : x \\mapsto bx+d$",
)
J_ORBIT_TO_POSITIONAL = Justification(
    A,
    "Sec.1(e)",
    "with positional evaluation being the orbit of $0$.",
)
J_THREE_CHOICES = Justification(
    A,
    "Theorem 4.2(3)",
    "Positional notation is a chart of $\\pi_0$ requiring three choices \u2014 a finite quotient\n"
    "(the base), a trivialization of a $\\mathbb{Z}/2$-torsor (the endianness), and a\n"
    "$2$-cocycle representative whose class is never zero (the carry) \u2014 on top of a\n"
    "generator/successor which it does not supply and which charts (a)\u2013(d) do.",
)
J_SUCC_TO_FACTORIZATION = Justification(
    A,
    "Theorem 2.12, sketch",
    "**Every step is an instance of induction, i.e. of chart (a).** Chart (f)\n"
    "is proved *from* chart (a) and not conversely; this is used in \u00a74.",
)
J_ITER_TO_FACTORIZATION = Justification(
    A,
    "Sec.1(f)",
    "$(\\mathbb{N}_{>0},\\times,1)$ with the map $e : \\bigoplus_{p\\in P}\\mathbb{N} \\to\n"
    "\\mathbb{N}_{>0}$, $e((a_p)) = \\prod_p p^{a_p}$.",
)


# --------------------------------------------------------------------------
# 4. the graph itself
# --------------------------------------------------------------------------

#: The choices, exactly as Theorem 4.2(2) names them.
BASE = "base (a finite quotient N -> Z/b)"
ENDIANNESS = "endianness (a trivialization of the Z/2-torsor of truncation systems)"
CARRY = "carry (a digit section, whose coboundary is a nonzero class in H^2)"


def build_graph() -> DependencyGraph:
    """The dependency graph of `ATLAS_OF_N.md`'s charts.  Built, then checked.

    Concepts are added in a fixed order and edges likewise, so the object is
    identical across processes.  ``assert_acyclic`` runs before return: a graph
    this module cannot certify acyclic is not returned at all.
    """
    g = DependencyGraph("ATLAS_OF_N charts")

    g.add_concept(Concept(
        "successor", "successor / generation", "(a)", 0, (),
        "The initial $(1+X)$-algebra: 0 and s, with induction as initiality, not as an axiom.",
        freedom_justification=J_SUCCESSOR_FREE,
    ))
    g.add_concept(Concept(
        "symmetry", "symmetry / group action", "(c) pre-truncation", 0, (),
        "Bijections of a set, Aut(X) = S_n, and a group acting on a set. One level up from N.",
        freedom_justification=J_SYMMETRY_FREE,
    ))
    g.add_concept(Concept(
        "quotient", "quotient / truncation", "(c) -> (a)", 0, (),
        "Pi_0: the set of connected components; the set-truncation. A universal construction "
        "with no parameter.",
        freedom_justification=J_QUOTIENT_FREE,
    ))
    g.add_concept(Concept(
        "iteration", "iteration / free monoid on one generator", "(b)", 0, (),
        "(N,+,0) free on {1}: an N-action on X is an endomorphism of X. The shape of "
        "'do a thing repeatedly'.",
        freedom_justification=J_ITERATION_FREE,
    ))
    g.add_concept(Concept(
        "orbit", "orbit of a group action", "(c) pre-truncation", 0, (),
        "The orbit of a point; free and transitive actions (torsors); connected components "
        "of a groupoid.",
        freedom_justification=J_ORBIT_FREE,
    ))
    g.add_concept(Concept(
        "cardinality", "cardinality / finite sets", "(c)", 0, (),
        "N := pi_0(F), F = core(FinSet). The number is a connected component; the numeral is "
        "its truncation.",
        freedom_justification=J_CARDINALITY_FREE,
    ))
    g.add_concept(Concept(
        "free_monoid", "free monoid on an alphabet", "(b) generalised", 0, (),
        "A^* : words and concatenation, graded by length in N. The carrier of any digit chart.",
        freedom_justification=J_FREE_MONOID_FREE,
    ))
    g.add_concept(Concept(
        "order", "order / ordinals below omega", "(d)", 0, (),
        "Finite well-orders. Rigidifies what cardinality truncates: the fibre is the "
        "S_n-torsor of linear orders.",
        freedom_justification=J_ORDER_FREE,
    ))
    g.add_concept(Concept(
        "factorization", "factorization / free commutative monoid on the primes", "(f)", 0, (),
        "(N_{>0}, x, 1) free on P. Unique factorization is the statement that this monoid is free.",
        freedom_justification=J_FACTORIZATION_FREE,
    ))
    g.add_concept(Concept(
        "finite_quotient", "finite quotient (mod b) \u2014 THE BASE", "(e) parameter (i)", 1, (BASE,),
        "N ->> Z/b. Choosing b is choosing a member of an infinite family of "
        "mutually untranslatable charts.",
        choice_justification=J_BASE_CHOICE,
        nonredundancy=J_BASE_NONREDUNDANT,
    ))
    g.add_concept(Concept(
        "torsor_endianness", "torsor / endianness \u2014 THE ORIENTATION", "(e) parameter (ii)", 1, (ENDIANNESS,),
        "The two truncation systems on (Z/b^n)_n form a Z/2-torsor; picking one is picking "
        "which end of the word is significant.",
        choice_justification=J_ENDIAN_CHOICE,
        nonredundancy=J_ENDIAN_NONREDUNDANT,
    ))
    g.add_concept(Concept(
        "cocycle_carry", "cocycle / carry \u2014 THE EXTENSION CLASS", "(e) parameter (iii)", 1, (CARRY,),
        "The coboundary of the digit section. Its class in H^2(Z/b^n; Z/b) is nonzero for "
        "every section, so carrying cannot be designed away.",
        choice_justification=J_CARRY_CHOICE,
        nonredundancy=J_CARRY_NONREDUNDANT,
    ))
    g.add_concept(Concept(
        "positional", "positional notation (place value)", "(e)", 0, (),
        "Base-b digit words with carrying: a coordinate system on the truncation, assembled "
        "from three parameters none of which N supplies.",
        freedom_justification=J_POSITIONAL_FREE,
    ))

    edges = (
        Edge("successor", "iteration", J_SUCC_TO_ITER, symmetric=True,
             note="Residual 2.1: the comparison type is contractible, so the orientation is a "
                  "presentation convention, not a forced dependency. Recorded, not hidden."),
        Edge("iteration", "free_monoid", J_ITER_TO_FREE_MONOID,
             note="Concatenation is graded by word length in (N,+): the free monoid's grading "
                  "is iteration."),
        Edge("symmetry", "orbit", J_SYM_TO_ORBIT,
             note="An orbit is an orbit of a group acting; free+transitive is a torsor."),
        Edge("symmetry", "cardinality", J_SYM_TO_CARDINALITY,
             note="The morphisms of F are bijections; without them F is not the object whose "
                  "pi_0 is N."),
        Edge("quotient", "cardinality", J_QUOT_TO_CARDINALITY),
        Edge("orbit", "cardinality", J_ORBIT_TO_CARDINALITY,
             note="A connected component is an isomorphism orbit."),
        Edge("cardinality", "order", J_CARDINALITY_TO_ORDER),
        Edge("symmetry", "order", J_SYM_TO_ORDER),
        Edge("orbit", "order", J_ORBIT_TO_ORDER),
        Edge("quotient", "finite_quotient", J_QUOT_TO_FINITE_QUOT),
        Edge("successor", "finite_quotient", J_SUCC_TO_FINITE_QUOT),
        Edge("finite_quotient", "torsor_endianness", J_FINITE_QUOT_TO_TORSOR,
             note="The torsor is a torsor of truncation systems on (Z/b^n)_n: no base, no torsor."),
        Edge("orbit", "torsor_endianness", J_ORBIT_TO_TORSOR),
        Edge("finite_quotient", "cocycle_carry", J_FINITE_QUOT_TO_COCYCLE),
        Edge("torsor_endianness", "cocycle_carry", J_TORSOR_TO_COCYCLE,
             note="Only the pi-sheet carries a group law, hence a carry cocycle at all."),
        Edge("successor", "positional", J_SUCC_TO_POSITIONAL),
        Edge("free_monoid", "positional", J_FREE_MONOID_TO_POSITIONAL),
        Edge("orbit", "positional", J_ORBIT_TO_POSITIONAL),
        Edge("finite_quotient", "positional", J_THREE_CHOICES),
        Edge("torsor_endianness", "positional", J_THREE_CHOICES),
        Edge("cocycle_carry", "positional", J_THREE_CHOICES),
        Edge("successor", "factorization", J_SUCC_TO_FACTORIZATION),
        Edge("iteration", "factorization", J_ITER_TO_FACTORIZATION),
    )
    for item in edges:
        g.add_edge(item)
    g.assert_acyclic()
    return g


__all__ = [
    "ALLOWED_SOURCES",
    "BASE",
    "CARRY",
    "Concept",
    "CurriculumError",
    "DependencyGraph",
    "ENDIANNESS",
    "Edge",
    "Justification",
    "REPO_ROOT",
    "build_graph",
    "normalise_text",
    "verify_quotes",
]
