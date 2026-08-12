"""L4 -- the exact dependency cone.

CRYSTAL.md Sec.2 L4:

    When a fact changes, the runtime computes the exact dependency cone: which
    constructions depend on it, which consequences survive through an
    independent proof, which caches are invalid, which routes shortened.
    Nothing rereads the library.

"Nothing rereads the library" is the load-bearing clause, and it is what this
module is *for*.  Both directions are indexed at insertion time:

    forward   fact  -> derivations that consume it   (``_uses``)
    reverse   fact  -> derivations that conclude it  (``_by_conclusion``)

so ``forward_cone`` visits exactly the affected sub-DAG and never touches a
fact outside it.  The exact number of index lookups it performs is counted in
``DependencyGraph.steps``; the demo reports it against the graph total, which
is the locality claim in numbers rather than in adjectives.

There is a deliberate second, *slow* implementation here --
``brute_force_dependents`` -- which rereads the whole library.  It exists only
so the tests can catch a cone that omits a genuine dependent.  Nothing in the
fast path calls it.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Callable, Dict, FrozenSet, List, Optional, Set, Tuple

from ..kernel import term as T

__all__ = [
    "PropagateError",
    "Fact",
    "Derivation",
    "CacheEntry",
    "Cone",
    "DependencyGraph",
    "brute_force_dependents",
]


class PropagateError(T.KernelError):
    """An L4 invariant was violated, or an inadmissible request was made."""


# ---------------------------------------------------------------------------
# the graph of facts and consequences
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Fact:
    """A node.  A fact with no derivation concluding it is *primitive*: it is an
    input, and it is the only kind of thing that can be retracted."""

    fid: str
    statement: str = ""
    value: Any = None

    def atom(self) -> Tuple:
        """The axiom atom this fact contributes to a justification multiset.

        Deliberately the same shape as ``kernel.egraph.axiom_atom`` output, so
        the two enumerations quotient by the same kind of key.
        """
        return ("fact", self.fid)


@dataclass(frozen=True)
class Derivation:
    """One way to conclude ``conclusion`` from ``premises``.

    A fact with two derivations has two independent proofs; that is the whole
    subject of ``invalidate.survival``.  ``cost`` is an exact integer step
    count -- the price of running this derivation once.  ``compute`` maps
    ``{premise fid: value}`` to the conclusion's value; it must be a pure,
    deterministic function of its inputs (the tests check that by rerunning).
    """

    did: str
    conclusion: str
    premises: Tuple[str, ...]
    cost: int
    rule: str = ""
    compute: Optional[Callable[[Dict[str, Any]], Any]] = None

    def __post_init__(self) -> None:
        if not isinstance(self.cost, int) or isinstance(self.cost, bool):
            raise PropagateError("derivation cost must be an exact int")
        if self.cost < 0:
            raise PropagateError("derivation cost must be non-negative")


@dataclass
class CacheEntry:
    """A computed value plus the exact set of facts it rests on.

    ``support`` is *transitive*: every fact, primitive or derived, that the
    producing derivation reaches.  Cache invalidation is coarser than survival
    on purpose -- a consequence can survive a retraction (another proof carries
    it) while the cache built along the dead route is still garbage.  Conflating
    the two is how a runtime silently serves a stale answer for a true theorem.
    """

    fid: str
    did: Optional[str]
    value: Any
    support: FrozenSet[str]
    generation: int = 0


@dataclass(frozen=True)
class Cone:
    """The exact forward dependency cone of a seed fact."""

    seed: str
    facts: Tuple[str, ...]
    derivations: Tuple[str, ...]
    steps: int
    total_facts: int
    total_derivations: int

    @property
    def size(self) -> int:
        return len(self.facts)

    def render(self) -> str:
        return ("cone(%s): %d/%d facts, %d/%d derivations, %d index steps"
                % (self.seed, len(self.facts), self.total_facts,
                   len(self.derivations), self.total_derivations, self.steps))


class DependencyGraph:
    """Facts, their derivations, and both indices.

    Every mutation maintains the indices, so no query ever scans the library.
    """

    def __init__(self) -> None:
        self.steps = T.Counters()
        self._facts: Dict[str, Fact] = {}
        self._order: List[str] = []                    # insertion order, deterministic
        self._derivations: Dict[str, Derivation] = {}
        self._dorder: List[str] = []
        self._uses: Dict[str, List[str]] = {}          # fact -> derivations consuming it
        self._by_conclusion: Dict[str, List[str]] = {}  # fact -> derivations proving it
        self._cache: Dict[str, CacheEntry] = {}
        self._support_memo: Dict[str, FrozenSet[str]] = {}
        self._retracted: Set[str] = set()
        self._live_memo: Dict[str, bool] = {}
        self._generation = 0

    # -- construction ------------------------------------------------------
    def add_fact(self, fact: Fact) -> str:
        if not isinstance(fact, Fact):
            raise PropagateError("add_fact() takes a Fact")
        if fact.fid in self._facts:
            raise PropagateError("duplicate fact id %r" % (fact.fid,))
        self.steps.bump("fact.add")
        self._facts[fact.fid] = fact
        self._order.append(fact.fid)
        self._uses.setdefault(fact.fid, [])
        self._by_conclusion.setdefault(fact.fid, [])
        return fact.fid

    def add_derivation(self, der: Derivation) -> str:
        if not isinstance(der, Derivation):
            raise PropagateError("add_derivation() takes a Derivation")
        if der.did in self._derivations:
            raise PropagateError("duplicate derivation id %r" % (der.did,))
        if der.conclusion not in self._facts:
            raise PropagateError("unknown conclusion %r" % (der.conclusion,))
        for p in der.premises:
            if p not in self._facts:
                raise PropagateError("unknown premise %r" % (p,))
        self.steps.bump("derivation.add")
        self._derivations[der.did] = der
        self._dorder.append(der.did)
        self._by_conclusion[der.conclusion].append(der.did)
        for p in der.premises:
            if der.did not in self._uses[p]:
                self._uses[p].append(der.did)
        self._support_memo.clear()
        self._live_memo.clear()
        return der.did

    # -- accessors ---------------------------------------------------------
    def fact(self, fid: str) -> Fact:
        got = self._facts.get(fid)
        if got is None:
            raise PropagateError("unknown fact %r" % (fid,))
        return got

    def derivation(self, did: str) -> Derivation:
        got = self._derivations.get(did)
        if got is None:
            raise PropagateError("unknown derivation %r" % (did,))
        return got

    def facts(self) -> Tuple[str, ...]:
        return tuple(self._order)

    def derivations(self) -> Tuple[str, ...]:
        return tuple(self._dorder)

    def live_facts(self) -> Tuple[str, ...]:
        return tuple(f for f in self._order if f not in self._retracted)

    def retracted(self) -> Tuple[str, ...]:
        return tuple(sorted(self._retracted))

    def uses(self, fid: str) -> Tuple[str, ...]:
        """Forward index: derivations that consume ``fid``.  O(1) lookup."""
        self.steps.bump("index.forward")
        return tuple(self._uses.get(fid, ()))

    def produced_by(self, fid: str) -> Tuple[str, ...]:
        """Reverse index: derivations concluding ``fid``.  O(1) lookup."""
        self.steps.bump("index.reverse")
        return tuple(self._by_conclusion.get(fid, ()))

    def is_primitive(self, fid: str) -> bool:
        return not self._by_conclusion.get(fid)

    def total_cost(self) -> int:
        """The exact cost of rebuilding everything from the primitives."""
        return sum(self._derivations[d].cost for d in self._dorder
                   if self.is_live_derivation(d)
                   and d == self.chosen_derivation(self._derivations[d].conclusion))

    def is_live_fact(self, fid: str, _stack: Tuple[str, ...] = ()) -> bool:
        """A fact is live iff it is an unretracted primitive, or some derivation
        concluding it is live.  This is the fixpoint that the homotopy-class
        rule computes independently -- ``survival`` (before the mutation) and
        this (after it) must always agree, and the tests check that they do."""
        got = self._live_memo.get(fid)
        if got is not None:
            return got
        if fid in _stack:
            raise PropagateError("cyclic liveness at %r" % (fid,))
        if fid in self._retracted:
            self._live_memo[fid] = False
            return False
        ders = self._by_conclusion.get(fid, ())
        if not ders:
            self._live_memo[fid] = True
            return True
        alive = any(self.is_live_derivation(d, _stack + (fid,)) for d in ders)
        self._live_memo[fid] = alive
        return alive

    def is_live_derivation(self, did: str, _stack: Tuple[str, ...] = ()) -> bool:
        """A derivation is live iff its conclusion is not retracted and every
        premise is live."""
        d = self._derivations[did]
        if d.conclusion in self._retracted:
            return False
        return all(self.is_live_fact(p, _stack) for p in d.premises)

    _live_derivation = is_live_derivation

    def is_retracted(self, fid: str) -> bool:
        return fid in self._retracted

    # -- the cone ----------------------------------------------------------
    def forward_cone(self, fid: str) -> Cone:
        """Every fact whose justification *could* change if ``fid`` changes.

        Breadth-first over the forward index only.  A fact outside the returned
        set is never looked at, which is the property the demo measures.
        """
        if fid not in self._facts:
            raise PropagateError("unknown fact %r" % (fid,))
        before = self.steps.get("index.forward")
        seen_f: Set[str] = {fid}
        seen_d: Set[str] = set()
        order_f: List[str] = [fid]
        order_d: List[str] = []
        frontier: List[str] = [fid]
        local = 0
        while frontier:
            cur = frontier.pop(0)
            for did in self.uses(cur):
                local += 1
                if did in seen_d:
                    continue
                seen_d.add(did)
                order_d.append(did)
                concl = self._derivations[did].conclusion
                if concl not in seen_f:
                    seen_f.add(concl)
                    order_f.append(concl)
                    frontier.append(concl)
        steps = local + (self.steps.get("index.forward") - before)
        return Cone(seed=fid, facts=tuple(order_f), derivations=tuple(order_d),
                    steps=steps, total_facts=len(self._order),
                    total_derivations=len(self._dorder))

    def support(self, fid: str, _stack: Tuple[str, ...] = ()) -> FrozenSet[str]:
        """Every fact ``fid`` transitively rests on (itself excluded).

        Reverse direction, memoised.  This is the set that decides *cache*
        validity; it is not the set that decides survival.
        """
        got = self._support_memo.get(fid)
        if got is not None:
            return got
        if fid in _stack:
            raise PropagateError("cyclic support at %r" % (fid,))
        self.steps.bump("support.visit")
        out: Set[str] = set()
        for did in self.produced_by(fid):
            d = self._derivations[did]
            for p in d.premises:
                out.add(p)
                out |= self.support(p, _stack + (fid,))
        frozen = frozenset(out)
        self._support_memo[fid] = frozen
        return frozen

    def derivation_support(self, did: str) -> FrozenSet[str]:
        d = self.derivation(did)
        out: Set[str] = set()
        for p in d.premises:
            out.add(p)
            out |= self.support(p)
        return frozenset(out)

    # -- evaluation and caching -------------------------------------------
    def live_order(self) -> Tuple[str, ...]:
        """Live facts in dependency order, deterministic (insertion order breaks
        ties).  Dead facts -- retracted, or with no live derivation -- are not
        in the list at all: there is nothing left to evaluate."""
        ready: List[str] = []
        placed: Set[str] = set()
        pending = [f for f in self._order if self.is_live_fact(f)]
        progress = True
        while pending and progress:
            progress = False
            rest: List[str] = []
            for fid in pending:
                ders = [d for d in self.produced_by(fid) if self.is_live_derivation(d)]
                ok = all(all(p in placed for p in self._derivations[d].premises)
                         for d in ders)
                if ok:
                    ready.append(fid)
                    placed.add(fid)
                    progress = True
                else:
                    rest.append(fid)
            pending = rest
        if pending:
            raise PropagateError("dependency cycle among %s" % (sorted(pending),))
        return tuple(ready)

    def chosen_derivation(self, fid: str) -> Optional[str]:
        """The live derivation used to compute ``fid``: the cheapest, ties broken
        by insertion order.  Deterministic."""
        live = [d for d in self.produced_by(fid) if self.is_live_derivation(d)]
        if not live:
            return None
        best = min(live, key=lambda d: (self._derivations[d].cost,
                                        self._dorder.index(d)))
        return best

    def build(self) -> int:
        """Full evaluation from scratch.  Returns the exact cost."""
        cost = 0
        self._generation += 1
        for fid in self.live_order():
            cost += self._evaluate(fid, force=True)
        return cost

    def _evaluate(self, fid: str, force: bool = False) -> int:
        did = self.chosen_derivation(fid)
        if did is None:
            self._cache[fid] = CacheEntry(fid=fid, did=None,
                                          value=self.fact(fid).value,
                                          support=frozenset(),
                                          generation=self._generation)
            return 0
        d = self._derivations[did]
        inputs = {p: self.value(p) for p in d.premises}
        self.steps.bump("eval.derivation")
        value = d.compute(inputs) if d.compute is not None else tuple(
            sorted(inputs.items()))
        self._cache[fid] = CacheEntry(fid=fid, did=did, value=value,
                                      support=self.derivation_support(did),
                                      generation=self._generation)
        return d.cost

    def value(self, fid: str) -> Any:
        entry = self._cache.get(fid)
        if entry is None:
            raise PropagateError("fact %r has no cached value; build() first" % (fid,))
        self.steps.bump("cache.read")
        return entry.value

    def cache_entry(self, fid: str) -> Optional[CacheEntry]:
        return self._cache.get(fid)

    def cache_snapshot(self) -> Dict[str, CacheEntry]:
        """The cache entry *objects*, for identity comparison across a
        retraction.  ``is``, not ``==``: equal values would not prove locality."""
        return dict(self._cache)

    # -- retraction bookkeeping (the mutation itself lives in invalidate) --
    def mark_retracted(self, fid: str) -> None:
        if fid not in self._facts:
            raise PropagateError("unknown fact %r" % (fid,))
        if not self.is_primitive(fid):
            raise PropagateError(
                "%r is derived, not primitive; retract the primitive facts it "
                "rests on, or the derivation, instead" % (fid,))
        self._retracted.add(fid)
        self._support_memo.clear()
        self._live_memo.clear()

    def drop_cache(self, fid: str) -> None:
        self._cache.pop(fid, None)

    def report(self) -> str:
        return self.steps.render()


# ---------------------------------------------------------------------------
# the slow control
# ---------------------------------------------------------------------------

def brute_force_dependents(graph: DependencyGraph, fid: str) -> FrozenSet[str]:
    """Every fact depending on ``fid``, found by rereading the entire library.

    This is the thing L4 exists to avoid.  It is here only as an oracle: the
    test suite plants a truncated cone and requires this to expose it.
    """
    out: Set[str] = {fid}
    for other in graph.facts():
        if fid in graph.support(other):
            out.add(other)
    return frozenset(out)
