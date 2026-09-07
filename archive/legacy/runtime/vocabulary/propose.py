"""Proposing constructors from the loop's own history -- the new capability.

WHAT IS BEING FIXED
-------------------
``generate/README.md`` sec.7 item 1, in the generate lane's own words:

    The construction schema is finite and human-written, and that -- not
    crystallization -- is why the trajectory plateaus.  Nothing inside the loop
    invents a new constructor family.

``crystallize/`` already mines recurring *rewrite patterns* and turns them into
lemmas.  This module mines recurring **objects** and turns them into
constructors.  Those are different things: a lemma is a new route between terms
the loop can already write down, a constructor is a new term the loop could not
write down before.  A loop with only the first can discover new theorems; only
the second lets it discover new things to talk about.

THREE LEGITIMATE SOURCES, AND NO FOURTH
---------------------------------------
Every constructor must come from something the loop proved or measured.
"Propose a random new symbol" is not implemented and is not an oversight.

1. **Recurring subterms** (:func:`propose_from_subterms`).  A subterm shape
   that keeps showing up across *independent* derivations is an object the
   loop's own activity has singled out.  Abstracting its ordinary variables to
   parameters turns one recurring object into a constructor family.

2. **Proved quotients** (:func:`propose_from_quotients`).  When the loop
   discharges a conjecture ``a ~ b`` it has proved an identification; the
   accepted ``Eq`` edges generate an equivalence on generated states, and the
   quotient's classes are objects the loop *proved* into existence.  The
   canonical representative of a class -- least in the substrate's total order
   on terms -- names that quotient object.

3. **The null pool** (:func:`null_pool_candidates`).  Not a source of
   mathematics: the control.  Same count of definitions, same admission gates,
   same installation path, provenance deliberately irrelevant.  It exists so
   that "more symbols" and "these symbols" can be told apart.

THE RANKING RULE, STATED
------------------------
For a candidate shape ``s``::

    score(s) = freq(s) * spread(s) * (size(s) - 1)

    freq    total occurrences of ``s`` (as a shape, after abstracting ordinary
            variables to parameters) anywhere in the recorded history
    spread  the number of *distinct derivation records* it occurs in
    size    the number of nodes of the shape

``freq`` alone rewards a shape that one runaway derivation repeated; ``spread``
is the factor that demands independence.  ``size - 1`` rather than ``size`` so
that a bare atom scores zero -- naming an atom is not an extension.  Ties break
on the substrate's canonical key, so the order is total and deterministic.
``min_spread`` is a hard floor, not a tiebreak: a shape seen in one derivation
is not recurring, and ``test_vocabulary.py`` plants exactly that claim.

WHERE A CONSTRUCTOR CHANGES ANYTHING
------------------------------------
Because the extension is conservative it proves nothing new (see
:mod:`runtime.vocabulary.conservativity`).  What it changes is what GENERATE
can *build*: an installed constructor becomes a construction family, its
instances become seeds, and constructors compose, so round ``r+1``'s reachable
set contains shapes no fixed four-family schema enumerates.  Everything
downstream -- mining, the book, the benchmark -- then moves or does not move on
its own.  That is the experiment, and ``demo/vocabulary_demo.py`` runs it.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Optional, Sequence, Set, Tuple

from ..crystallize.derivation import (I, P, PV, S, Sub, Term, VAR, Counter,
                                      is_pvar, match as ring_match, mk,
                                      positions_postorder, pvars_of, subst)
from ..generate import loop as L
from ..generate.loop import (BENCHMARKS, Config, Organism, PAIRS,
                             _subterm_addrs, constructions as base_constructions)
from ..generate.multiway import MultiwayGraph
from ..generate.propose import DISCHARGED, ProposalGraph
from .conservativity import (Installation, UnfoldReport, admit, audit_theorems,
                             unfolds)
from .define import (Definition, Vocabulary, VocabularyError, fold, unfold,
                     unfold_edge, vrender)

__all__ = [
    "History", "Candidate", "RANK_RULE", "abstract_variables",
    "propose_from_subterms", "propose_from_quotients", "null_pool_candidates",
    "to_definition", "VocabConfig", "VocabRound", "VocabularyOrganism",
    "VocabLeakageReport", "vocab_leakage_report", "NULL_POOL_SIZE",
    "WITNESS_CAP", "derivation_closure",
]

RANK_RULE = "score = freq * spread * (size - 1); ties on canonical key"

# How many concrete occurrences a candidate carries with it.  These are what
# ``vocab_leakage_report`` inspects, so truncating them would make the check
# partial; the cap is generous and its being hit is itself reported.
WITNESS_CAP = 64


# ==========================================================================
# the derivation record the loop already keeps
# ==========================================================================

class History:
    """Every object the loop built, tagged with which derivation built it.

    A *derivation record* here is one seed's orbit in one round's multiway
    graph -- ``"r3-s1"`` is the second seed of round 3.  Two shapes occurring
    in one record are not independent evidence; two occurring in different
    records are.  That distinction is the whole content of ``spread``.

    The benchmark never enters.  ``vocab_leakage_report`` checks it
    mechanically rather than trusting this sentence.
    """

    __slots__ = ("terms", "sources", "order", "quotients", "records",
                 "graph_records")

    def __init__(self) -> None:
        # source key -> list of terms observed in that derivation record
        self.terms: Dict[str, List[Term]] = {}
        self.order: List[str] = []
        self.sources: Dict[str, str] = {}          # term addr -> first source
        self.quotients: List[Tuple[int, Term, Term]] = []
        self.records = 0
        # records that came from a multiway graph the organism actually built.
        # A constructor may cite nothing else -- see ``vocab_leakage_report``
        # V5.  Anything added by hand (a test, or a cheat) is outside this set.
        self.graph_records: List[str] = []

    def add_terms(self, source: str, terms: Sequence[Term]) -> None:
        if source not in self.terms:
            self.terms[source] = []
            self.order.append(source)
            self.records += 1
        bucket = self.terms[source]
        for t in terms:
            bucket.append(t)
            self.sources.setdefault(t.addr, source)

    def add_graph(self, rnd: int, g: MultiwayGraph) -> None:
        """One multiway graph contributes one record per originating seed."""
        buckets: Dict[int, List[Term]] = {}
        order: List[int] = []
        for addr in g.order:
            o = g.origin.get(addr, -1)
            if o not in buckets:
                buckets[o] = []
                order.append(o)
            buckets[o].append(g.states[addr])
        for o in order:
            key = "r%d-s%d" % (rnd, o)
            self.add_terms(key, buckets[o])
            if key not in self.graph_records:
                self.graph_records.append(key)

    def add_quotients(self, rnd: int, pg: ProposalGraph) -> None:
        """Every conjecture the loop *discharged* is a proved identification."""
        known = {(a.addr, b.addr) for _, a, b in self.quotients}
        for cid in pg.order:
            if pg.status.get(cid) != DISCHARGED:
                continue
            cj = pg.conjectures[cid]
            if (cj.lhs.addr, cj.rhs.addr) in known:
                continue
            known.add((cj.lhs.addr, cj.rhs.addr))
            self.quotients.append((rnd, cj.lhs, cj.rhs))

    def all_addrs(self) -> Set[str]:
        return set(self.sources)

    def __len__(self) -> int:
        return sum(len(v) for v in self.terms.values())


# ==========================================================================
# shapes
# ==========================================================================

def abstract_variables(t: Term, ctr: Optional[Counter] = None
                       ) -> Tuple[Term, int]:
    """Ordinary variables -> parameters ``#0, #1, ...`` in first-occurrence order.

    Integers stay concrete: ``3*y`` and ``5*y`` are different objects and a
    constructor that conflated them would be generalising past what the loop
    observed.  Occurrences of one variable collapse onto one parameter, which
    is what makes the resulting family sound in the same sense
    ``crystallize.antiunify``'s consistent variable map is.
    """
    seen: Dict[str, Term] = {}
    order: List[str] = []

    def walk(n: Term) -> Term:
        if ctr is not None:
            ctr.effort()
        if n.kind == VAR:
            if is_pvar(n):
                return n
            if n.val not in seen:
                seen[n.val] = PV(len(order))
                order.append(n.val)
            return seen[n.val]
        if not n.args:
            return n
        return mk(n.kind, n.val, [walk(a) for a in n.args])

    return walk(t), len(order)


@dataclass(frozen=True)
class Candidate:
    """A proposed constructor, with the evidence that proposed it."""

    body: Term
    arity: int
    freq: int
    spread: int
    size: int
    score: int
    provenance: str
    witnesses: Tuple[str, ...]
    sources: Tuple[str, ...]

    def render(self) -> str:
        return ("%-34s ar%d  freq %3d  spread %2d  size %2d  score %5d  [%s]"
                % (vrender(self.body)[:34], self.arity, self.freq, self.spread,
                   self.size, self.score, self.provenance))


def _rank(cands: Sequence[Candidate]) -> Tuple[Candidate, ...]:
    return tuple(sorted(cands, key=lambda c: (-c.score, c.body.ckey)))


def _existing_syntax(max_arity: int = 6) -> Tuple[str, ...]:
    """The shapes the substrate already has a name for.

    ``crystallize.derivation`` gives the language flat n-ary ``Sum`` and
    ``Prod`` heads and exactly one abbreviation, ``Sub(a, b) = a + (-1)*b``.
    A "constructor" whose body is one of those is not naming an object the
    loop found -- it is renaming syntax that was there before round 0.

    This gate (**P1**) exists because the leakage check fired on a real run,
    not on a planted control.  The first constructor config (B) proposed was
    ``c1(#0,#1) := #0 + (-1*#1)`` -- subtraction.  Its instances are seeds, and
    a bare subtraction seed makes *every* term whose root is a subtraction an
    instance of a seed, so ``leakage_report``'s L4 and this module's V2 both
    fired on a held-out benchmark.  The generate lane changed its embedding
    when L4 fired at it (``generate/README.md`` sec.5); this is the same event
    and the same response, one layer up.
    """
    out: List[str] = []
    for k in range(2, max_arity + 1):
        params = tuple(PV(i) for i in range(k))
        out.append(S(*params).addr)
        out.append(P(*params).addr)
    out.append(Sub(PV(0), PV(1)).addr)          # the substrate's one sugar
    return tuple(out)


_EXISTING_SYNTAX: Tuple[str, ...] = _existing_syntax()


def _admissible_shape(shape: Term, arity: int, min_size: int, max_size: int,
                      max_arity: int) -> bool:
    if arity < 1 or arity > max_arity:
        return False
    if shape.size < min_size or shape.size > max_size:
        return False
    if is_pvar(shape) or not shape.args:
        return False
    if shape.addr in _EXISTING_SYNTAX:          # P1
        return False
    want = tuple("#%d" % i for i in range(arity))
    return tuple(v.val for v in pvars_of(shape)) == want


# ==========================================================================
# source 1 -- recurring subterms
# ==========================================================================

def propose_from_subterms(history: History, min_spread: int = 3,
                          min_size: int = 5, max_size: int = 14,
                          max_arity: int = 3, limit: int = 40,
                          ctr: Optional[Counter] = None
                          ) -> Tuple[Candidate, ...]:
    """Recurring **objects**, not recurring rewrites.

    Walks every subterm of every recorded term, abstracts its ordinary
    variables to parameters, and counts occurrences and spread.  A shape below
    ``min_spread`` distinct derivation records is not proposed at all -- see
    the module docstring.
    """
    freq: Dict[str, int] = {}
    spread: Dict[str, Set[str]] = {}
    shape_of: Dict[str, Term] = {}
    arity_of: Dict[str, int] = {}
    wit: Dict[str, List[str]] = {}
    order: List[str] = []
    for src in history.order:
        for t in history.terms[src]:
            for p in positions_postorder(t):
                node = t if not p else _at(t, p)
                if ctr is not None:
                    ctr.effort()
                if node.size < min_size or node.size > max_size:
                    continue
                shape, ar = abstract_variables(node, ctr)
                if not _admissible_shape(shape, ar, min_size, max_size,
                                         max_arity):
                    continue
                key = shape.addr
                if key not in freq:
                    freq[key] = 0
                    spread[key] = set()
                    shape_of[key] = shape
                    arity_of[key] = ar
                    wit[key] = []
                    order.append(key)
                freq[key] += 1
                spread[key].add(src)
                if node.addr not in wit[key]:
                    wit[key].append(node.addr)

    out: List[Candidate] = []
    for key in order:
        sp = len(spread[key])
        if sp < min_spread:
            continue
        shape = shape_of[key]
        out.append(Candidate(
            body=shape, arity=arity_of[key], freq=freq[key], spread=sp,
            size=shape.size, score=freq[key] * sp * (shape.size - 1),
            provenance="subterm", witnesses=tuple(sorted(wit[key])[:WITNESS_CAP]),
            sources=tuple(sorted(spread[key]))))
    return _rank(out)[:limit]


def _at(t: Term, p: Tuple[int, ...]) -> Term:
    for i in p:
        t = t.args[i]
    return t


# ==========================================================================
# source 2 -- proved quotients
# ==========================================================================

class _UF:
    """Union-find over term addresses.  Deterministic: no set iteration."""

    def __init__(self) -> None:
        self.parent: Dict[str, str] = {}
        self.order: List[str] = []

    def add(self, a: str) -> None:
        if a not in self.parent:
            self.parent[a] = a
            self.order.append(a)

    def find(self, a: str) -> str:
        r = a
        while self.parent[r] != r:
            r = self.parent[r]
        while self.parent[a] != r:
            self.parent[a], a = r, self.parent[a]
        return r

    def union(self, a: str, b: str) -> None:
        ra, rb = self.find(a), self.find(b)
        if ra == rb:
            return
        lo, hi = (ra, rb) if ra < rb else (rb, ra)
        self.parent[hi] = lo


def propose_from_quotients(history: History, min_class: int = 2,
                           min_size: int = 5, max_size: int = 14,
                           max_arity: int = 3, limit: int = 20,
                           ctr: Optional[Counter] = None
                           ) -> Tuple[Candidate, ...]:
    """A proved identification yields a constructor for the quotient object.

    The loop's discharged conjectures are kernel-checked ``Eq`` edges, so the
    equivalence they generate is proved, not assumed.  Its classes are the
    quotient's objects; the canonical representative of a class -- least in
    the substrate's total order ``ckey`` -- is the object's normal name, and
    abstracting its variables makes it a family.

    The provenance is a *proof*, which is what distinguishes this from naming
    an arbitrary term.
    """
    uf = _UF()
    reps: Dict[str, Term] = {}
    for _rnd, a, b in history.quotients:
        for t in (a, b):
            uf.add(t.addr)
            reps[t.addr] = t
        uf.union(a.addr, b.addr)
        if ctr is not None:
            ctr.effort()

    classes: Dict[str, List[str]] = {}
    corder: List[str] = []
    for addr in uf.order:
        r = uf.find(addr)
        if r not in classes:
            classes[r] = []
            corder.append(r)
        classes[r].append(addr)

    out: List[Candidate] = []
    for r in corder:
        members = classes[r]
        if len(members) < min_class:
            continue
        canon = min((reps[a] for a in members), key=lambda t: t.ckey)
        shape, ar = abstract_variables(canon, ctr)
        if not _admissible_shape(shape, ar, min_size, max_size, max_arity):
            continue
        srcs = tuple(sorted({history.sources.get(a, "?") for a in members}))
        out.append(Candidate(
            body=shape, arity=ar, freq=len(members), spread=len(srcs),
            size=shape.size,
            score=len(members) * len(srcs) * (shape.size - 1),
            provenance="quotient",
            witnesses=tuple(sorted(members)[:WITNESS_CAP]), sources=srcs))
    return _rank(out)[:limit]


# ==========================================================================
# source 3 -- the null pool (the control, and it is labelled as one)
# ==========================================================================

_NULL_CONSTS: Tuple[int, ...] = (11, 13, 17, 19, 23, 29)
_NULL_SHAPES: Tuple[object, ...] = (
    lambda c: S(P(PV(0), I(c)), P(PV(1), I(c + 2))),
    lambda c: P(S(PV(0), I(c)), S(PV(1), I(c))),
    lambda c: S(P(PV(0), PV(0), I(c)), I(c)),
    lambda c: P(S(PV(0), PV(1), I(c)), I(c + 4)),
    lambda c: S(P(I(c), PV(0)), P(I(c + 1), PV(1)), I(c + 3)),
)

NULL_POOL_SIZE = len(_NULL_CONSTS) * len(_NULL_SHAPES)


def null_pool_candidates(history: Optional[History] = None,
                         min_size: int = 5, max_size: int = 14,
                         max_arity: int = 3, limit: int = NULL_POOL_SIZE
                         ) -> Tuple[Candidate, ...]:
    """Definitions with matched count and deliberately irrelevant provenance.

    Built from a fixed catalogue over constants the loop's schema never uses.
    If ``history`` is given, every candidate whose shape actually occurs in the
    history is dropped -- the pool is required to be *disjoint*, and that is
    checked rather than asserted.
    """
    seen: Set[str] = set()
    if history is not None:
        for src in history.order:
            for t in history.terms[src]:
                for p in positions_postorder(t):
                    node = _at(t, p)
                    if node.size < min_size or node.size > max_size:
                        continue
                    sh, _ = abstract_variables(node)
                    seen.add(sh.addr)
    out: List[Candidate] = []
    for c in _NULL_CONSTS:
        for i, sh in enumerate(_NULL_SHAPES):
            body = sh(c)
            ar = len(pvars_of(body))
            if not _admissible_shape(body, ar, min_size, max_size, max_arity):
                continue
            if body.addr in seen:
                continue
            out.append(Candidate(
                body=body, arity=ar, freq=0, spread=0, size=body.size,
                score=0, provenance="null-pool",
                witnesses=(), sources=("null:%d/%d" % (c, i),)))
    return tuple(out)[:limit]


# ==========================================================================
# candidate -> definition
# ==========================================================================

def to_definition(name: str, c: Candidate) -> Definition:
    return Definition(name=name, arity=c.arity, body=c.body,
                      provenance=c.provenance, witnesses=c.witnesses,
                      sources=c.sources, freq=c.freq, spread=c.spread,
                      score=c.score)


# ==========================================================================
# the self-extending organism
# ==========================================================================

@dataclass
class VocabConfig:
    """Configuration of the vocabulary lane.  ``mode`` selects the experiment.

    ``fixed``  -- install nothing.  Config (A): the loop exactly as it is.
    ``self``   -- propose from history and install.  Config (B).
    ``null``   -- install the same number of definitions from the disjoint
                  pool.  Config (C): symbol count matched, provenance not.
    """

    mode: str = "self"
    installs_per_round: int = 1
    min_spread: int = 3
    min_size: int = 5
    max_size: int = 14
    max_arity: int = 3
    seeds_per_round: int = 2
    compose: bool = True
    max_seed_size: int = 22
    use_quotients: bool = True
    max_definitions: int = 24
    check_conservativity: bool = True


@dataclass
class VocabRound:
    rnd: int
    proposed: int
    installed: int
    refused: int
    vocab: int
    seeds_added: int
    vocab_work: int
    theorems_checked: int
    conservative: bool
    names: Tuple[str, ...] = ()

    def row(self) -> str:
        return ("%2d | %4d %3d %3d | %4d | %2d | %7d | %3d %s"
                % (self.rnd, self.proposed, self.installed, self.refused,
                   self.vocab, self.seeds_added, self.vocab_work,
                   self.theorems_checked,
                   "ok" if self.conservative else "NOT CONSERVATIVE"))


VOCAB_HEADER = (
    "  r | prop ins ref | voc | +s |  vwork | thm conservativity\n"
    " ---+---------------+-----+----+--------+-------------------")


class VocabularyOrganism(Organism):
    """``generate.loop.Organism`` that may extend its own generative vocabulary.

    Everything the base organism does is untouched -- this class adds one step
    at the end of each round and one term source at the start of the next.
    The construction schema is reached by rebinding ``generate.loop``'s
    module-level ``constructions`` for the duration of ``super().round``: the
    base loop looks that name up in its own module globals, and rebinding it
    is how a subclass changes the schema without copying two hundred lines of
    loop.  It is restored in a ``finally``, and ``mode="fixed"`` leaves the
    schema bit-identical to the unmodified loop (asserted by a test).
    """

    def __init__(self, cfg: Optional[Config] = None,
                 vcfg: Optional[VocabConfig] = None) -> None:
        super().__init__(cfg)
        self.vcfg = vcfg or VocabConfig()
        self.vocab = Vocabulary(self.vault.ctx)
        self.history = History()
        self.vreports: List[VocabRound] = []
        self.vctr = Counter()
        self.theorems: List[Tuple[str, Term, Term]] = []
        self.unfold_reports: List[UnfoldReport] = []
        self.installations: List[Installation] = []
        self.vocab_seed_log: List[Tuple[int, str]] = []
        self._vname = 0

    # -- the schema, extended -------------------------------------------
    def _constructions(self, round_index: int, width: int = 3) -> List[Term]:
        base = base_constructions(round_index, width)
        return base + self._vocab_seeds(round_index)

    def _vocab_seeds(self, r: int) -> List[Term]:
        """Instances of installed constructors, unfolded to base terms.

        A seed must be a *base* term: the multiway generator's rules are the
        ring axioms and a defined head is inert to all of them.  So what the
        vocabulary contributes to GENERATE is the unfolding of a constructor
        instance -- a shape the human schema does not enumerate, which is the
        whole point, arrived at by naming rather than by widening the schema
        by hand.

        With two or more constructors installed, arguments are themselves
        constructor instances.  Composition is where the combinatorial novelty
        is: a fixed schema of four families is four families for ever, while
        ``n`` constructors compose into ``O(n^2)`` shapes.
        """
        defs = self.vocab.definitions
        if not defs:
            return []
        cap = min(self.vcfg.max_seed_size, self.cfg.gen.max_size)
        out: List[Term] = []
        for i in range(self.vcfg.seeds_per_round):
            d = defs[(r + i) % len(defs)]
            args: List[Term] = []
            for j in range(d.arity):
                a, b = PAIRS[(r * 7 + i * 3 + j) % len(PAIRS)]
                args.append(a if (j % 2 == 0) else b)
            attempts: List[Term] = []
            if self.vcfg.compose and len(defs) >= 2:
                e = defs[(r + i + 1) % len(defs)]
                eargs = [PAIRS[(r * 5 + i + j) % len(PAIRS)][1]
                         for j in range(e.arity)]
                composed = list(args)
                composed[0] = e.head(*eargs)
                attempts.append(d.head(*composed))
            attempts.append(d.head(*args))       # the uncomposed fallback
            for term in attempts:
                # A composed instance is usually the interesting one and
                # usually the one that busts the generation budget's size cap.
                # Falling back to the plain instance rather than skipping is
                # what keeps the vocabulary from being a silent no-op: without
                # it, 2 seeds reached GENERATE in twelve rounds instead of 24.
                try:
                    base = unfold(term, self.vocab, self.vctr)
                except VocabularyError:
                    continue
                if base.size > cap:
                    continue
                out.append(base)
                self.vocab_seed_log.append((r, d.name))
                break
        return out

    # -- one round -------------------------------------------------------
    def round(self, r: int):
        saved = L.constructions
        L.constructions = self._constructions
        try:
            rep = super().round(r)
        finally:
            L.constructions = saved
        self.history.add_graph(r, self.graphs[-1])
        self.history.add_quotients(r, self.pg)
        self._extend_vocabulary(r)
        return rep

    # -- the new arrow ----------------------------------------------------
    def _extend_vocabulary(self, r: int) -> VocabRound:
        cfg = self.vcfg
        before = self.vctr.snapshot()
        cands: Tuple[Candidate, ...] = ()
        if cfg.mode == "self":
            subs = propose_from_subterms(
                self.history, min_spread=cfg.min_spread, min_size=cfg.min_size,
                max_size=cfg.max_size, max_arity=cfg.max_arity, ctr=self.vctr)
            quos = propose_from_quotients(
                self.history, min_size=cfg.min_size, max_size=cfg.max_size,
                max_arity=cfg.max_arity, ctr=self.vctr) if cfg.use_quotients else ()
            cands = _rank(tuple(subs) + tuple(quos))
        elif cfg.mode == "null":
            cands = null_pool_candidates(
                self.history, min_size=cfg.min_size, max_size=cfg.max_size,
                max_arity=cfg.max_arity)
        elif cfg.mode != "fixed":
            raise ValueError("unknown vocabulary mode %r" % (cfg.mode,))

        installed: List[Definition] = []
        refused = 0
        have = {d.body.addr for d in self.vocab.definitions}
        for c in cands:
            if len(installed) >= cfg.installs_per_round:
                break
            if len(self.vocab) >= cfg.max_definitions:
                break
            if c.body.addr in have:
                continue
            self._vname += 1
            defn = to_definition("c%d" % self._vname, c)
            inst = admit(self.vocab, defn, r)
            self.installations.append(inst)
            if inst.ok:
                installed.append(defn)
                have.add(c.body.addr)
            else:
                refused += 1
                self._vname -= 1

        # every installed constructor immediately yields an extended-vocabulary
        # theorem, and every one of those is unfolded and re-checked in the base
        checked = 0
        conservative = True
        if cfg.check_conservativity:
            for defn in installed:
                atoms = [PAIRS[(r + i) % len(PAIRS)][0] for i in range(defn.arity)]
                lhs = defn.head(*atoms)
                rhs = subst(defn.body, {PV(i).val: atoms[i]
                                        for i in range(defn.arity)})
                unfold_edge(lhs, self.vocab)      # kernel-checked Eq edge
                self.theorems.append(("%s@r%d" % (defn.name, r), lhs, rhs))
            # a proved base equation, restated in the extended vocabulary and
            # then eliminated again -- this is the round trip that would catch
            # a definition that changed the meaning of something old
            for _rnd, a, b in self.history.quotients[-2:]:
                fa, fb = fold(a, self.vocab), fold(b, self.vocab)
                if fa.addr != a.addr or fb.addr != b.addr:
                    self.theorems.append(("fold@r%d" % r, fa, fb))
            for name, lhs, rhs in self.theorems[len(self.unfold_reports):]:
                rep = unfolds(lhs, rhs, self.vocab,
                              lemmas=tuple(self.book.lemmas), label=name)
                self.unfold_reports.append(rep)
                checked += 1
                conservative = conservative and rep.ok

        after = self.vctr.snapshot()
        vr = VocabRound(
            rnd=r, proposed=len(cands), installed=len(installed),
            refused=refused, vocab=len(self.vocab),
            seeds_added=len([x for x in self.vocab_seed_log if x[0] == r]),
            vocab_work=after[1] - before[1] + after[0] - before[0],
            theorems_checked=checked, conservative=conservative,
            names=tuple(d.name for d in installed))
        self.vreports.append(vr)
        return vr

    # -- audits -----------------------------------------------------------
    def conservativity_audit(self) -> Tuple[bool, Tuple[UnfoldReport, ...]]:
        return audit_theorems(tuple(self.theorems), self.vocab,
                              tuple(self.book.lemmas))

    def vocab_trajectory(self) -> Tuple[Tuple[int, int, int], ...]:
        return tuple((v.rnd, v.vocab, v.vocab_work) for v in self.vreports)


# ==========================================================================
# leakage, extended to cover vocabulary
# ==========================================================================

@dataclass(frozen=True)
class VocabLeakageReport:
    """``loop.leakage_report``'s four routes, plus the four a vocabulary opens.

    V1  a constructor was generalised from a *witness* that is a subterm of the
        benchmark -- the benchmark's own structure entered the proposal;
    V2  the benchmark is an **instance** of a constructor body, i.e. the
        held-out problem became one of the loop's own constructions (the
        vocabulary analogue of ``leakage_report``'s L4, and the subtle cheat);
    V3  a constructor cites a derivation record whose name marks it as
        benchmark-derived;
    V4  a constructor body is literally a benchmark subterm address;
    V5  a constructor that *claims* loop provenance ("subterm", "quotient")
        cites a derivation record the organism did not build.  Every legitimate
        record is one seed's orbit in one multiway graph the loop generated and
        audited; anything else was put there by hand, and a constructor
        standing on it is standing on nothing the loop proved or measured.  A
        null-pool constructor is exempt because it claims nothing -- it is the
        declared control, and V5 catches false claims, not absent ones;
    V6  a constructor was generalised from a witness lying in the benchmark's
        own **derivation closure** -- every subterm of every term the base
        engine passes through while solving the benchmark.  V1 catches a
        constructor cut from the problem; V6 catches one cut from its
        solution, which is the form the cheat actually takes when someone
        feeds a benchmark derivation to the miner.

    V5 and V6 exist because the first version of this report, with V1-V4 only,
    did **not** catch the planted control in ``demo/vocabulary_demo.py`` sec.8:
    poisoning the history with the benchmark's normalisation trajectory leaves
    witnesses that are subterms of *intermediate* terms, not of the benchmark.
    The control was written first and the check was strengthened until it
    fired.
    """

    clean: bool
    findings: Tuple[str, ...]
    base_clean: bool
    base_findings: Tuple[str, ...]
    definitions_checked: int
    witnesses_checked: int

    def render(self) -> str:
        head = "VOCAB LEAKAGE: CLEAN" if self.clean else "VOCAB LEAKAGE: DETECTED"
        body = "".join("\n    - " + f for f in self.findings + self.base_findings)
        return ("%s  (%d definitions, %d witnesses checked; base check %s)%s"
                % (head, self.definitions_checked, self.witnesses_checked,
                   "clean" if self.base_clean else "DETECTED", body))


_BENCH_MARKERS = ("bench", "B1", "B2", "B3", "B4", "held-out")


def derivation_closure(t: Term, lemmas: Sequence = ()) -> Set[str]:
    """Every subterm address of every term the base engine passes through.

    This is what "the benchmark's own structure" means once you take the
    solution into account, and it is what V6 checks against.  Computing it
    requires looking at the benchmark -- which the *check* may do and the loop
    may not.  That asymmetry is the whole design of a leakage check.
    """
    from ..crystallize.derivation import Divergence, normalize
    out: Set[str] = set()
    try:
        d, _ = normalize(t, lemmas=tuple(lemmas), ctr=Counter(),
                         name="leak-closure")
        trail = [t] + [st.after for st in d.steps]
    except Divergence:
        trail = [t]
    for u in trail:
        stack = [u]
        while stack:
            n = stack.pop()
            if n.addr in out:
                continue
            out.add(n.addr)
            stack.extend(n.args)
    return out


def vocab_leakage_report(org: VocabularyOrganism,
                         targets: Sequence[Tuple[str, Term]] = BENCHMARKS
                         ) -> VocabLeakageReport:
    """The check that must catch a constructor which leaked the benchmark."""
    base = L.leakage_report(org, targets)
    findings: List[str] = []
    nwit = 0
    legit = set(org.history.graph_records)
    for d in org.vocab.definitions:
        # V5 checks a *claim*.  A null-pool definition claims no loop
        # provenance at all -- it is the declared control -- so there is
        # nothing for it to be lying about.  Anything claiming to come from
        # the loop's own history must actually come from it.
        if d.provenance not in ("subterm", "quotient"):
            continue
        alien = [s for s in d.sources if s not in legit]
        if alien:
            findings.append(
                "V5 constructor %s cites %d derivation record(s) the organism "
                "did not build: %s"
                % (d.name, len(alien), ", ".join(sorted(alien)[:4])))
    for label, target in targets:
        sub = _subterm_addrs(target)
        closure = derivation_closure(target)
        for d in org.vocab.definitions:
            nwit += len(d.witnesses)
            hit = [w for w in d.witnesses if w in sub]
            if hit:
                findings.append(
                    "V1 constructor %s was generalised from %d witness(es) that "
                    "are subterms of %s" % (d.name, len(hit), label))
            deep = [w for w in d.witnesses if w in closure and w not in sub]
            if deep:
                findings.append(
                    "V6 constructor %s was generalised from %d witness(es) in "
                    "%s's own derivation closure" % (d.name, len(deep), label))
            if ring_match(d.body, target) is not None:
                findings.append(
                    "V2 %s is an instance of constructor %s := %s"
                    % (label, d.name, vrender(d.body)))
            bad = [s for s in d.sources
                   if any(m.lower() in s.lower() for m in _BENCH_MARKERS)]
            if bad:
                findings.append("V3 constructor %s cites benchmark-derived "
                                "record(s) %s" % (d.name, ", ".join(bad)))
            if d.body.addr in sub:
                findings.append("V4 constructor %s's body is a subterm of %s"
                                % (d.name, label))
    return VocabLeakageReport(
        clean=(not findings) and base.clean, findings=tuple(findings),
        base_clean=base.clean, base_findings=base.findings,
        definitions_checked=len(org.vocab), witnesses_checked=nwit)
