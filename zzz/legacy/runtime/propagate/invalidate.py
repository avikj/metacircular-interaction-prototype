"""L4 -- what dies, what survives, what is merely stale.

This is the sharp part of the layer, and it is *the same mechanism as Part A*.

A consequence usually has more than one derivation.  Retracting a fact must not
kill a theorem that has an independent proof, and must not spare one whose every
proof runs through the retracted fact.  The decision procedure is exactly the
homotopy quotient of ``kernel.egraph``:

    * a justification tree's canonical form is the **multiset of primitive
      facts at its leaves** -- intermediate derived facts are reassociation, in
      the same way that congruence/transitivity are reassociation in the
      e-graph;
    * two trees with the same leaf multiset are one *class*: one proof in two
      presentations;
    * the consequence **survives** the retraction of ``f`` iff some class's
      multiset omits ``f``.  It **dies** iff every class contains ``f``.

That is the definition CRYSTAL Sec.2 L4 asks for ("which consequences survive
through an independent proof"), and it is not a heuristic: it is a completeness
statement about the class enumeration.  Which is why the enumeration must be
*complete*, and why an incomplete one yields ``UNDECIDED`` rather than a guess.
An L4 that guessed here would be exactly failure mode #1 wearing a new hat.

Three separate questions, never conflated:

    survival     does the consequence still hold?          (homotopy classes)
    validity     is its cached value still meaningful?     (transitive support)
    obligations  what is still owed, and is it still owed? (classes n owes)

A consequence can survive and still have an invalid cache: the value was
computed along the dead route.  Serving that value because "the theorem is still
true" is the stale-cache bug this module is built to make impossible.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, FrozenSet, List, Optional, Sequence, Set, Tuple

from ..kernel import bounded as B
from ..kernel.egraph import (
    ClassEnumeration,
    IncompleteEnumeration,
    merge_multisets,
    multiset_key,
)
from .cone import Cone, DependencyGraph, PropagateError

__all__ = [
    "DerivationClass",
    "justification_classes",
    "Survival",
    "Invalidation",
    "Obligation",
    "ObligationVerdict",
    "survival",
    "invalidate",
    "classify_obligations",
    "DEFAULT_TREE_BOUNDS",
]

DEFAULT_TREE_BOUNDS: Dict[str, int] = {
    "max_paths": 4096,    # justification trees inspected (named to match L2)
    "max_depth": 32,      # derivation depth
    "max_classes": 0,     # 0 = unbounded
}


# ---------------------------------------------------------------------------
# homotopy classes of justification trees
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class DerivationClass:
    """One homotopy class of justifications of a consequence.

    Duck-identical to ``kernel.egraph.ProofClass`` so that both live inside the
    same guarded ``ClassEnumeration``: the L2 and L4 answers are the same kind
    of object because they are the same quotient.
    """

    key: Tuple
    src: str
    dst: str
    multiset: Tuple[Tuple[Tuple, int], ...]
    axioms: FrozenSet
    size: int
    representative: Tuple[str, ...]      # derivation ids, root last
    raw_paths: int
    members: Tuple[Tuple[str, ...], ...]  # every tree in the class

    def uses(self, atom: Tuple) -> bool:
        return atom in self.axioms

    def leaves(self) -> Tuple[str, ...]:
        return tuple(sorted(a[1] for a in self.axioms))

    def render(self) -> str:
        return "{%s}" % ", ".join("%s x%d" % (a[1], n) for a, n in self.multiset)


def justification_classes(graph: DependencyGraph, fid: str,
                          max_paths: Optional[int] = None,
                          max_depth: Optional[int] = None,
                          max_classes: Optional[int] = None,
                          ) -> ClassEnumeration:
    """Every homotopy class of justification of ``fid``, as a guarded result.

    Enumeration is a depth-first product over derivations: a tree picks one
    live derivation per derived fact, recursively.  Trees are grouped by leaf
    multiset.  The bounds are bounds, not caps -- hitting one produces an
    ``INCOMPLETE`` result that refuses to be counted.

    The search obeys ``kernel.bounded``'s discipline, which is the same one
    ``egraph.explanation_classes`` obeys and for the same reason -- both got it
    wrong in the same way first:

    * ``max_depth`` **prunes one derivation branch and backtracks**.  It used to
      set a global stop flag, so a single justification chain deeper than the
      bound ended the entire enumeration and a *surviving* class sitting behind
      it was never found -- turning a `SURVIVES` verdict into `UNDECIDED`, which
      ``recompute.apply`` then refuses to act on.  Sibling derivations are now
      explored regardless.
    * Rounds go **shortest-first** (iterative deepening over tree height), with
      an admissible lower bound: ``min_height`` is the height of the shallowest
      justification tree of a fact, so a branch is cut only when
      ``depth + min_height`` provably overruns the round.  Nothing that could
      have closed is dropped, and a spent tree budget has bought the *small*
      justifications.
    * Honesty is unchanged.  Any pruning at all, and any derivation whose
      premise product overran ``max_paths``, leaves ``complete=False`` with the
      count in ``reason``.  Width truncation is reported as width, not as
      depth, because a deeper round would not recover it.
    """
    bnd = B.resolve_bounds(DEFAULT_TREE_BOUNDS, max_paths=max_paths,
                           max_depth=max_depth, max_classes=max_classes)
    bounds = B.bounds_tuple(bnd)
    graph.steps.bump("class.enum")

    ledger = B.SearchLedger()
    buckets = B.ClassBuckets(ledger, max_classes=bnd["max_classes"],
                             max_paths=bnd["max_paths"])

    # -- the live-derivation view, read once per fact ----------------------
    live_memo: Dict[str, Tuple[Tuple[str, ...], bool]] = {}

    def live_ders(node: str) -> Tuple[Tuple[str, ...], bool]:
        got = live_memo.get(node)
        if got is None:
            all_ders = graph.produced_by(node)
            got = (tuple(sorted(d for d in all_ders
                                if graph.is_live_derivation(d))), bool(all_ders))
            live_memo[node] = got
        return got

    # -- the admissible lower bound ----------------------------------------
    # ``min_height(n)`` is the height of the shallowest justification tree of
    # ``n``, or ``None`` when ``n`` has no justification tree at all.  A subtree
    # rooted at depth ``d`` therefore forces total height ``>= d + min_height``,
    # so cutting a branch whose ``d + min_height`` overruns the round removes
    # only branches that provably cannot close -- admissible pruning, exactly as
    # the breadth-first distance is in ``egraph``.  It is computed lazily over
    # the support of ``fid`` alone, never over the library: L4's O(cone) promise
    # would not survive a global fixpoint here.
    height_memo: Dict[str, Optional[int]] = {}

    def min_height(node: str, stack: Tuple[str, ...] = ()) -> Optional[int]:
        if node in height_memo:
            return height_memo[node]
        if node in stack:
            raise PropagateError("cyclic justification at %r" % (node,))
        live, had = live_ders(node)
        if not live:
            # a retracted primitive, or a derived fact all of whose derivations
            # died: no justification tree at all.  Otherwise a live primitive,
            # which is a tree of height 0.
            best: Optional[int] = None if (graph.is_retracted(node) or had) else 0
        else:
            best = None
            for did in live:
                sub = 0
                reachable = True
                for p in graph.derivation(did).premises:
                    ph = min_height(p, stack + (node,))
                    if ph is None:
                        reachable = False
                        break
                    if ph > sub:
                        sub = ph
                if reachable and (best is None or sub + 1 < best):
                    best = sub + 1
        height_memo[node] = best
        return best

    # -- one round of the deepening ----------------------------------------
    def expand(node: str, depth: int, limit: int, stack: Tuple[str, ...]
               ) -> List[Tuple[Dict[Tuple, int], Tuple[str, ...], int]]:
        """Every (leaf multiset, derivation ids, height) tree for ``node`` that
        fits under ``limit``.  An empty list means *this branch* yields nothing
        this round -- never that the enumeration is over."""
        if ledger.stopped:
            return []
        if node in stack:
            raise PropagateError("cyclic justification at %r" % (node,))
        floor = min_height(node)
        if floor is None:
            return []                       # no justification: nothing is lost
        if depth + floor > limit:
            ledger.prune()
            graph.steps.bump("class.prune")
            return []                       # too deep for this round: backtrack
        ledger.explored += 1
        graph.steps.bump("class.expand")
        live, _had = live_ders(node)
        if not live:
            return [({graph.fact(node).atom(): 1}, (), 0)]
        out: List[Tuple[Dict[Tuple, int], Tuple[str, ...], int]] = []
        for did in live:
            der = graph.derivation(did)
            combos: List[Tuple[Dict[Tuple, int], Tuple[str, ...], int]] = [({}, (), 0)]
            dropped = False
            for p in der.premises:
                sub = expand(p, depth + 1, limit, stack + (node,))
                if ledger.stopped:
                    return []
                if not sub:
                    dropped = True          # this derivation, not the search
                    break
                nxt: List[Tuple[Dict[Tuple, int], Tuple[str, ...], int]] = []
                for ms, ids, h in combos:
                    for sms, sids, sh in sub:
                        nxt.append((merge_multisets(ms, sms), ids + sids,
                                    h if h > sh else sh))
                combos = nxt
                if len(combos) > bnd["max_paths"]:
                    ledger.truncate(
                        "max_paths=%d reached (premise product of derivation %s "
                        "exceeded it; that derivation's trees are missing, "
                        "its siblings are not)" % (bnd["max_paths"], did))
                    graph.steps.bump("class.truncate")
                    dropped = True
                    break
            if dropped:
                continue                    # prune the branch, keep the siblings
            for ms, ids, h in combos:
                out.append((ms, ids + (did,), h + 1))
        return out

    def round_(limit: int) -> None:
        for ms, ids, h in expand(fid, 0, limit, ()):
            if h != limit:
                continue                    # shorter trees were recorded already
            if not buckets.add((fid, fid, multiset_key(ms)), (ids, ms)):
                return

    floor0 = min_height(fid)
    if floor0 is not None:
        B.deepen(ledger, round_, floor0, bnd["max_depth"],
                 exhausted=lambda bound, pruned:
                 "max_depth=%d reached (%d branch(es) pruned; every class at or "
                 "below the bound was still enumerated)" % (bound, pruned))

    classes: List[DerivationClass] = []
    for key, members in buckets.items():
        entries = sorted(members, key=lambda z: z[0])
        ms = key[2]
        classes.append(DerivationClass(
            key=key, src=fid, dst=fid, multiset=ms,
            axioms=frozenset(a for a, _ in ms),
            size=sum(n for _, n in ms),
            # the class's *smallest* realisation is its representative
            representative=min(entries, key=lambda z: (len(z[0]), z[0]))[0],
            raw_paths=len(entries),
            members=tuple(ids for ids, _ in entries),
        ))
    classes.sort(key=lambda c: (c.size, c.multiset))
    reason = ledger.reason()
    if reason:
        graph.steps.bump("class.incomplete")
    return ClassEnumeration(src=fid, dst=fid, complete=not reason,
                            reason=reason, bounds=bounds,
                            raw_paths=ledger.raw, explored=ledger.explored,
                            _classes=tuple(classes))


# ---------------------------------------------------------------------------
# survival
# ---------------------------------------------------------------------------

SURVIVES = "SURVIVES"
DIES = "DIES"
UNDECIDED = "UNDECIDED"


@dataclass(frozen=True)
class Survival:
    """Why a consequence lives or dies, with the classes that decided it."""

    fid: str
    retracted: str
    status: str
    surviving: Tuple[DerivationClass, ...]
    killed: Tuple[DerivationClass, ...]
    reason: str = ""

    @property
    def alive(self) -> bool:
        if self.status == UNDECIDED:
            raise IncompleteEnumeration(
                "survival of %r under retraction of %r is UNDECIDED: %s"
                % (self.fid, self.retracted, self.reason))
        return self.status == SURVIVES

    def render(self) -> str:
        return "%-10s %-9s surviving=%d killed=%d %s" % (
            self.fid, self.status, len(self.surviving), len(self.killed),
            " | ".join(c.render() for c in self.surviving) or "-")


def survival(graph: DependencyGraph, fid: str, retracted: str,
             **bounds) -> Survival:
    """Decide whether ``fid`` survives the retraction of primitive ``retracted``.

    Computed against the graph *before* the retraction is applied: the classes
    are the complete inventory of proofs, and the retraction simply deletes
    those whose multiset contains the fact.  No rebuild is needed to answer.
    """
    enum = justification_classes(graph, fid, **bounds)
    atom = graph.fact(retracted).atom()
    found = enum.partial()
    surviving = tuple(c for c in found if atom not in c.axioms)
    killed = tuple(c for c in found if atom in c.axioms)
    if surviving:
        # One surviving class is a *witness*; incompleteness cannot take it away.
        return Survival(fid, retracted, SURVIVES, surviving, killed)
    if not enum.complete:
        return Survival(fid, retracted, UNDECIDED, (), killed,
                        reason=enum.reason)
    return Survival(fid, retracted, DIES, (), killed)


# ---------------------------------------------------------------------------
# obligations
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Obligation:
    """Something still owed: ``target`` is not finished until ``owes`` are proved."""

    oid: str
    target: str
    owes: FrozenSet[str]
    note: str = ""


DISCHARGED = "discharged"
SHARPER = "sharper"
IRRELEVANT = "irrelevant"
UNCHANGED = "unchanged"


@dataclass(frozen=True)
class ObligationVerdict:
    oid: str
    target: str
    status: str
    owes_before: Tuple[str, ...]
    owes_after: Tuple[str, ...]
    why: str

    def render(self) -> str:
        return "%-8s %-11s %-10s %s -> %s  (%s)" % (
            self.oid, self.status, self.target,
            "{%s}" % ",".join(self.owes_before),
            "{%s}" % ",".join(self.owes_after), self.why)


def classify_obligations(graph: DependencyGraph,
                         obligations: Sequence[Obligation],
                         survivals: Dict[str, Survival]) -> Tuple[ObligationVerdict, ...]:
    """Sort obligations into discharged / sharper / irrelevant / unchanged.

    ``discharged``  the target holds via a surviving class that needs nothing
                    the obligation owed -- the work is no longer required for it.
    ``sharper``     the target survives and the surviving routes need a strict,
                    non-empty subset of what was owed.
    ``irrelevant``  the target itself died: there is no goal left to serve.
    ``unchanged``   everything owed is still on every surviving route.
    """
    out: List[ObligationVerdict] = []
    for ob in sorted(obligations, key=lambda o: o.oid):
        before = tuple(sorted(ob.owes))
        surv = survivals.get(ob.target)
        if surv is None or surv.status == UNDECIDED:
            out.append(ObligationVerdict(ob.oid, ob.target, UNCHANGED, before,
                                         before, "target survival undecided"))
            continue
        if surv.status == DIES:
            out.append(ObligationVerdict(ob.oid, ob.target, IRRELEVANT, before, (),
                                         "target died; nothing left to owe"))
            continue
        still: Set[str] = set()
        for c in surv.surviving:
            still |= (set(c.leaves()) & ob.owes)
        after = tuple(sorted(still))
        if not still:
            status, why = DISCHARGED, "no surviving route needs any of them"
        elif still < set(ob.owes):
            status, why = SHARPER, "surviving routes need only a subset"
        else:
            status, why = UNCHANGED, "every owed fact is still load-bearing"
        out.append(ObligationVerdict(ob.oid, ob.target, status, before, after, why))
    return tuple(out)


# ---------------------------------------------------------------------------
# the whole verdict
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Invalidation:
    """The complete answer to "one fact changed; what now?"."""

    retracted: str
    cone: Cone
    survives: Tuple[str, ...]
    dies: Tuple[str, ...]
    undecided: Tuple[str, ...]
    stale_caches: Tuple[str, ...]      # survive, but their cached value is garbage
    dead_caches: Tuple[str, ...]       # the fact is gone; drop the entry
    dead_derivations: Tuple[str, ...]
    survivals: Dict[str, Survival]
    obligations: Tuple[ObligationVerdict, ...]
    steps: int

    def render(self) -> str:
        return ("retract %s: cone %d/%d facts | survive %d, die %d, undecided %d "
                "| caches stale %d dead %d, %d untouched by construction "
                "| %d L4 steps"
                % (self.retracted, self.cone.size, self.cone.total_facts,
                   len(self.survives), len(self.dies), len(self.undecided),
                   len(self.stale_caches), len(self.dead_caches),
                   self.cone.total_facts - self.cone.size, self.steps))


def invalidate(graph: DependencyGraph, fid: str,
               obligations: Sequence[Obligation] = (),
               **bounds) -> Invalidation:
    """Compute the full consequence of retracting primitive fact ``fid``.

    Pure: it decides, it does not mutate.  ``recompute.apply`` performs the
    mutation, and takes this object as its plan.
    """
    if not graph.is_primitive(fid):
        raise PropagateError("only primitive facts are retractable; %r is derived"
                             % (fid,))
    before = graph.steps.snapshot()
    cone = graph.forward_cone(fid)

    survives: List[str] = []
    dies: List[str] = []
    undecided: List[str] = []
    survs: Dict[str, Survival] = {}
    for f in cone.facts:
        if f == fid:
            survs[f] = Survival(f, fid, DIES, (), ())
            dies.append(f)
            continue
        s = survival(graph, f, fid, **bounds)
        survs[f] = s
        (survives if s.status == SURVIVES else
         dies if s.status == DIES else undecided).append(f)

    # Cache classification is O(cone), never O(library).  Everything outside the
    # cone is intact *by construction* -- it is not enumerated here, because
    # enumerating it would be exactly the "reread the library" this layer
    # forbids.  ``recompute.intact_cache_ids`` is the O(total) verification
    # helper, and it is only ever called by tests and demos.
    stale: List[str] = []
    dead: List[str] = []
    for f in cone.facts:
        if graph.cache_entry(f) is None:
            continue
        if survs[f].status == DIES:
            dead.append(f)
        else:
            stale.append(f)

    dead_ders = tuple(d for d in cone.derivations
                      if fid in graph.derivation(d).premises
                      or fid in graph.derivation_support(d))
    verdicts = classify_obligations(graph, obligations, survs)
    steps = sum(n for _, n in graph.steps.delta(before))
    return Invalidation(retracted=fid, cone=cone, survives=tuple(survives),
                        dies=tuple(dies), undecided=tuple(undecided),
                        stale_caches=tuple(stale), dead_caches=tuple(dead),
                        dead_derivations=dead_ders,
                        survivals=survs, obligations=verdicts, steps=steps)
