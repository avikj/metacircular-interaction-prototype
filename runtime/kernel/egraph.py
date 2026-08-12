"""L2 -- the proof-relevant e-graph.

CRYSTAL.md Sec.2 L2:

    Union-find over hash-consed terms, with congruence closure, **and a proof
    forest**: every union stores the justification, so any derived equality can
    emit a checkable path.  Distinct automorphisms survive as distinct paths
    between the same pair.  Directed edges (`Quotient`, `Refine`, `Approx`) are
    *not* unions and never merge classes.  Retracting an edge rebuilds the
    affected classes from retained justifications rather than rebuilding the
    world.

Four commitments this file makes good on, each of which the test suite attacks:

1.  **Proof forest, not a union log.**  Justifications live in a second parent
    array whose path is *reversed on union* (Nieuwenhuis-Oliveras).  ``explain``
    walks to the nearest common proof ancestor.  There is no flat list of all
    unions anywhere in the explanation path.
2.  **Distinct paths are kept.**  Every ``merge`` call is retained as a record,
    including the redundant ones that merge an already-equal pair ("chords").
    ``explain`` returns the cheap canonical path from the forest;
    ``explanations`` enumerates distinct simple paths through the retained
    justification graph.  Collapsing them would destroy exactly the
    automorphism information the corpus proved is the content.
3.  **Directed edges never merge.**  ``Quotient``/``Refine``/``Approx``/
    ``Implies``/``Embed``/``Interp``, and also the symmetric-but-not-equal
    ``Iso``/``Dual``, live in a separate labelled digraph with its own
    reachability query.  ``explain`` cannot see them.
4.  **Retraction is local.**  ``retract`` computes the dependency cone of the
    retracted assumption, resets only that, and replays the surviving records.
    Class objects outside the cone are not merely equal afterwards, they are
    the *same object*.

All counters live in ``EGraph.steps``.
"""

from __future__ import annotations

from collections import deque
from dataclasses import dataclass, field
from typing import Any, Dict, Iterable, List, Optional, Sequence, Set, Tuple

from . import term as T
from .check import Conjectural, Step
from .edges import Edge, compose, is_symmetric

__all__ = ["EGraphError", "MergeRecord", "EGraph"]

MAX_EXPLAIN_DEPTH = 64


class EGraphError(T.KernelError):
    """An e-graph invariant was violated, or an inadmissible request was made."""


@dataclass
class MergeRecord:
    """One retained justification for an equality.

    ``kind``      ``"assumption"`` (a caller-supplied witness) or ``"congruence"``.
    ``deps``      the set of *assumption* edge ids this record rests on.  For an
                  assumption that is ``{edge_id}``; for a congruence it is the
                  union of the deps along the proof paths of its argument pairs.
                  This is the dependency cone used by ``retract``.
    ``applied``   True iff this record is currently a spanning edge of the proof
                  forest.  A retained-but-not-spanning record is a *chord*: a
                  second, independent reason for an equality already known.
    """

    mid: int
    kind: str
    a: str
    b: str
    witness: Any = None
    edge_id: Optional[str] = None
    deps: frozenset = frozenset()
    applied: bool = False

    def label(self) -> str:
        return "%s#%d" % (self.kind, self.mid)


class EGraph:
    """Proof-relevant e-graph over hash-consed L0 terms.

    Addresses (``str``) are the node identifiers everywhere in the public API;
    every method that takes a node also accepts a ``Term`` and uses its address.
    """

    def __init__(self) -> None:
        self.steps = T.Counters()
        self._terms: Dict[str, T.Term] = {}
        # union-find
        self._uf: Dict[str, str] = {}
        self._size: Dict[str, int] = {}
        self._members: Dict[str, List[str]] = {}
        self._class_cache: Dict[str, Tuple[str, ...]] = {}
        # proof forest (separate parent pointers; reversed on union)
        self._pf: Dict[str, Optional[str]] = {}
        self._pf_rec: Dict[str, Optional[MergeRecord]] = {}
        # retained justifications, in creation order
        self._records: List[MergeRecord] = []
        self._next_mid = 0
        self._next_auto = 0
        # congruence
        self._sig: Dict[Tuple, str] = {}
        self._sig_of: Dict[str, Tuple] = {}
        self._parents: Dict[str, List[str]] = {}
        # directed edges: a separate graph that never merges classes
        self._directed: List[Edge] = []
        self._out: Dict[str, List[int]] = {}

    # ------------------------------------------------------------------
    # registration
    # ------------------------------------------------------------------
    @staticmethod
    def _addr(x) -> str:
        return x.addr if isinstance(x, T.Term) else x

    def add(self, t: T.Term) -> str:
        """Register a term and all its subterms.  Returns its address."""
        if not isinstance(t, T.Term):
            raise EGraphError("add() takes a Term")
        fresh: List[T.Term] = []
        for u in T.subterms(t):
            if u.addr in self._terms:
                continue
            self.steps.bump("add")
            self._terms[u.addr] = u
            self._uf[u.addr] = u.addr
            self._size[u.addr] = 1
            self._members[u.addr] = [u.addr]
            self._pf[u.addr] = None
            self._pf_rec[u.addr] = None
            for c in u.children:
                self._parents.setdefault(c.addr, [])
                if u.addr not in self._parents[c.addr]:
                    self._parents[c.addr].append(u.addr)
                    self._parents[c.addr].sort()
            fresh.append(u)
        if fresh:
            self._closure([u.addr for u in fresh])
        return t.addr

    def _require(self, x) -> str:
        a = self._addr(x)
        if a not in self._terms:
            if isinstance(x, T.Term):
                return self.add(x)
            raise EGraphError("address %s is not registered" % a[:8])
        return a

    def terms(self) -> Tuple[str, ...]:
        return tuple(sorted(self._terms))

    # ------------------------------------------------------------------
    # union-find
    # ------------------------------------------------------------------
    def find(self, x) -> str:
        a = self._require(x)
        self.steps.bump("find")
        root = a
        while self._uf[root] != root:
            root = self._uf[root]
            self.steps.bump("find_hop")
        while self._uf[a] != root:  # path compression (proofs live elsewhere)
            self._uf[a], a = root, self._uf[a]
        return root

    def equal(self, x, y) -> bool:
        return self.find(x) == self.find(y)

    def class_of(self, x) -> Tuple[str, ...]:
        """The e-class of ``x`` as a sorted tuple, cached by root.

        The *object identity* of the returned tuple is meaningful: it changes
        only when the class is rebuilt.  ``retract`` tests rely on this.
        """
        r = self.find(x)
        got = self._class_cache.get(r)
        if got is None:
            got = tuple(sorted(self._members[r]))
            self._class_cache[r] = got
        return got

    def classes(self) -> Tuple[Tuple[str, ...], ...]:
        roots = sorted({self.find(a) for a in sorted(self._terms)})
        return tuple(self.class_of(r) for r in roots)

    # ------------------------------------------------------------------
    # merging
    # ------------------------------------------------------------------
    def merge(self, x, y, justification, edge_id: Optional[str] = None) -> str:
        """Assert ``x = y`` with a justification.  Returns the edge id.

        ``justification`` is a ``check`` witness object (``Refl``, ``Axiom``,
        ``Beta``, ``Instantiate``).  A ``Conjectural`` witness is refused here,
        not later: a conjecture must never be able to merge a class.

        If ``x`` and ``y`` are already equal the call still creates and retains
        a record (a chord), so a second independent reason for an equality is
        never lost.
        """
        a, b = self._require(x), self._require(y)
        self.steps.bump("merge_calls")
        if isinstance(justification, Conjectural):
            self.steps.bump("conjecture_refused")
            raise EGraphError("a Conjecture may never merge e-classes")
        ta, tb = self._terms[a], self._terms[b]
        if ta.sort is not tb.sort:
            raise T.SortError(
                "cannot merge sorts %s and %s" % (ta.sort.pretty(), tb.sort.pretty())
            )
        if edge_id is None:
            edge_id = "u%04d" % self._next_auto
            self._next_auto += 1
        if any(r.edge_id == edge_id for r in self._records):
            raise EGraphError("duplicate edge id %r" % (edge_id,))
        rec = MergeRecord(
            mid=self._next_mid, kind="assumption", a=a, b=b,
            witness=justification, edge_id=edge_id, deps=frozenset({edge_id}),
        )
        self._next_mid += 1
        self._records.append(rec)
        if self.find(a) != self.find(b):
            moved = self._union(a, b, rec)
            self._closure(self._parents_of(moved))
        return edge_id

    def _union(self, a: str, b: str, rec: MergeRecord) -> List[str]:
        """Join two classes, recording ``rec`` in the proof forest.

        Returns the members whose root changed (the loser's members), which are
        exactly the nodes whose parents need re-canonicalisation.
        """
        self.steps.bump("unions")
        # --- proof forest: reroot a at itself, then hang it under b ---
        self._reroot(a)
        self._pf[a] = b
        self._pf_rec[a] = rec
        rec.applied = True
        # --- union-find: union by size ---
        ra, rb = self.find(a), self.find(b)
        if self._size[ra] > self._size[rb]:
            ra, rb = rb, ra
        self._uf[ra] = rb
        self._size[rb] += self._size[ra]
        moved = self._members[ra]
        self._members[rb] = self._members[rb] + moved
        del self._members[ra]
        self._class_cache.pop(ra, None)
        self._class_cache.pop(rb, None)
        return list(moved)

    def _reroot(self, x: str) -> None:
        """Reverse the proof-forest path from ``x`` to its root, so ``x`` becomes
        the root.  This is what makes explanations extractable."""
        prev: Optional[str] = None
        prev_rec: Optional[MergeRecord] = None
        cur: Optional[str] = x
        while cur is not None:
            self.steps.bump("reroot_hop")
            nxt = self._pf[cur]
            nxt_rec = self._pf_rec[cur]
            self._pf[cur] = prev
            self._pf_rec[cur] = prev_rec
            prev, prev_rec = cur, nxt_rec
            cur = nxt

    # ------------------------------------------------------------------
    # congruence closure
    # ------------------------------------------------------------------
    def _signature(self, a: str) -> Tuple:
        self.steps.bump("signature")
        t = self._terms[a]
        if t.head == T.APP:
            return ("app", self.find(t.children[0].addr), self.find(t.children[1].addr))
        if t.head == T.LAM:
            return ("lam", t.dom.addr, self.find(t.children[0].addr))
        return ("leaf", a)

    def _parents_of(self, nodes: Iterable[str]) -> List[str]:
        out: List[str] = []
        seen: Set[str] = set()
        for n in sorted(nodes):
            for p in self._parents.get(n, ()):
                if p not in seen:
                    seen.add(p)
                    out.append(p)
        return out

    def _recanonicalize(self, p: str) -> Optional[Tuple[str, str]]:
        old = self._sig_of.get(p)
        sig = self._signature(p)
        if old == sig and self._sig.get(sig) == p:
            return None
        if old is not None and self._sig.get(old) == p:
            del self._sig[old]
        self._sig_of[p] = sig
        other = self._sig.get(sig)
        if other is None or other == p:
            self._sig[sig] = p
            return None
        if self.find(other) == self.find(p):
            return None
        return (other, p)

    def _closure(self, seeds: Sequence[str]) -> None:
        work = deque(sorted(set(seeds)))
        while work:
            p = work.popleft()
            hit = self._recanonicalize(p)
            if hit is None:
                continue
            other, cur = hit
            rec = self._congruence_record(other, cur)
            self._records.append(rec)
            self.steps.bump("congruences")
            moved = self._union(other, cur, rec)
            for q in self._parents_of(moved):
                work.append(q)

    def _congruence_record(self, a: str, b: str) -> MergeRecord:
        ta, tb = self._terms[a], self._terms[b]
        deps: Set[str] = set()
        for ca, cb in zip(ta.children, tb.children):
            deps |= self._deps_between(ca.addr, cb.addr)
        rec = MergeRecord(
            mid=self._next_mid, kind="congruence", a=a, b=b,
            witness=None, edge_id="c%04d" % self._next_mid, deps=frozenset(deps),
        )
        self._next_mid += 1
        return rec

    # ------------------------------------------------------------------
    # explanations
    # ------------------------------------------------------------------
    def _chain(self, a: str, b: str) -> Optional[List[Tuple[str, str, MergeRecord]]]:
        """The canonical proof-forest chain from ``a`` to ``b``, or ``None``."""
        if a == b:
            return []
        if self.find(a) != self.find(b):
            return None
        order: List[str] = []
        index: Dict[str, int] = {}
        cur: Optional[str] = a
        while cur is not None:
            self.steps.bump("explain_steps")
            index[cur] = len(order)
            order.append(cur)
            cur = self._pf[cur]
        up: List[str] = []
        cur = b
        while cur is not None and cur not in index:
            self.steps.bump("explain_steps")
            up.append(cur)
            cur = self._pf[cur]
        if cur is None:
            raise EGraphError("proof forest is disconnected from the union-find")
        meet = cur
        chain: List[Tuple[str, str, MergeRecord]] = []
        for i in range(index[meet]):
            u, v = order[i], order[i + 1]
            rec = self._pf_rec[u]
            assert rec is not None
            chain.append((u, v, rec))
        for i in range(len(up) - 1, -1, -1):
            v = up[i]
            u = up[i + 1] if i + 1 < len(up) else meet
            rec = self._pf_rec[v]
            assert rec is not None
            chain.append((u, v, rec))
        return chain

    def _deps_between(self, a: str, b: str) -> Set[str]:
        chain = self._chain(a, b)
        if chain is None:
            raise EGraphError("congruence claimed on unequal children")
        out: Set[str] = set()
        for _, _, rec in chain:
            out |= rec.deps
        return out

    def _steps_from_chain(self, chain, depth: int) -> Tuple[Step, ...]:
        if depth > MAX_EXPLAIN_DEPTH:
            raise EGraphError("explanation nesting exceeded %d" % MAX_EXPLAIN_DEPTH)
        out: List[Step] = []
        for u, v, rec in chain:
            if rec.kind == "assumption":
                out.append(Step(u, v, "assumption", rec.witness, rec.edge_id))
            else:
                tu, tv = self._terms[u], self._terms[v]
                subs = []
                for cu, cv in zip(tu.children, tv.children):
                    sub = self._chain(cu.addr, cv.addr)
                    if sub is None:
                        raise EGraphError("congruence subproof vanished")
                    subs.append(self._steps_from_chain(sub, depth + 1))
                out.append(Step(u, v, "congruence", None, rec.edge_id, tuple(subs)))
        return tuple(out)

    def explain(self, x, y) -> Optional[Tuple[Step, ...]]:
        """A checkable proof path for ``x = y``, or ``None`` if not equal.

        Cost is proportional to the proof-forest distance, not to the number of
        unions ever performed.  The result is self-contained: every congruence
        step carries its own argument subproofs, so ``check.check_path`` can
        verify it without consulting this e-graph at all.
        """
        a, b = self._require(x), self._require(y)
        chain = self._chain(a, b)
        if chain is None:
            return None
        return self._steps_from_chain(chain, 0)

    def explanations(self, x, y, limit: int = 8) -> Tuple[Tuple[Step, ...], ...]:
        """*Distinct* proof paths for ``x = y``, up to ``limit``.

        How distinct paths are stored: every ``merge`` call appends a
        ``MergeRecord``, whether or not it changed the union-find.  Those
        records form an undirected *justification graph* on addresses.  A
        distinct explanation is a distinct simple path in that graph.  The
        proof forest is only a spanning structure over it -- the chords are the
        extra automorphisms, and they are never discarded.

        Enumeration is depth-first in ascending record id, so the output is
        deterministic.  It is capped by ``limit`` because simple-path
        enumeration is exponential in the worst case; ``explain`` remains the
        cheap query.
        """
        a, b = self._require(x), self._require(y)
        if self.find(a) != self.find(b):
            return ()
        adj: Dict[str, List[Tuple[int, str, MergeRecord]]] = {}
        for rec in self._records:
            adj.setdefault(rec.a, []).append((rec.mid, rec.b, rec))
            adj.setdefault(rec.b, []).append((rec.mid, rec.a, rec))
        for k in adj:
            adj[k].sort(key=lambda z: z[0])
        results: List[Tuple[Step, ...]] = []
        seen_sigs: Set[Tuple[int, ...]] = set()
        path: List[Tuple[str, str, MergeRecord]] = []
        visited: Set[str] = {a}

        def dfs(node: str) -> None:
            if len(results) >= limit:
                return
            if node == b and path:
                sig = tuple(r.mid for _, _, r in path)
                if sig not in seen_sigs:
                    seen_sigs.add(sig)
                    self.steps.bump("path_enum")
                    results.append(self._steps_from_chain(list(path), 0))
                return
            for _, nxt, rec in adj.get(node, ()):
                if nxt in visited:
                    continue
                visited.add(nxt)
                path.append((node, nxt, rec))
                dfs(nxt)
                path.pop()
                visited.discard(nxt)

        if a == b:
            return ((),)
        dfs(a)
        return tuple(results)

    def justifications(self, x, y) -> Tuple[MergeRecord, ...]:
        """Every retained record directly relating ``x`` and ``y`` (either order)."""
        a, b = self._require(x), self._require(y)
        return tuple(r for r in self._records if (r.a, r.b) in ((a, b), (b, a)))

    def records(self) -> Tuple[MergeRecord, ...]:
        return tuple(self._records)

    # ------------------------------------------------------------------
    # retraction
    # ------------------------------------------------------------------
    def retract(self, edge_id: str) -> bool:
        """Remove an assumption and rebuild only its dependency cone.

        Returns ``False`` if no live record depends on ``edge_id``.

        Everything outside the cone is untouched -- not recomputed to an equal
        value, *untouched*: its union-find entries, its proof-forest pointers
        and its cached class tuple objects are the same objects afterwards.
        """
        self.steps.bump("retract_calls")
        dead = [r for r in self._records if edge_id in r.deps]
        if not dead:
            return False
        self.steps.bump("rebuilds")

        cone_roots = sorted({self.find(x) for r in dead for x in (r.a, r.b)})
        cone: Set[str] = set()
        for root in cone_roots:
            cone.update(self._members[root])

        keep: List[MergeRecord] = []
        for r in self._records:
            if edge_id in r.deps:
                continue
            if r.kind == "congruence" and (r.a in cone or r.b in cone):
                continue  # re-derived by the closure pass below
            keep.append(r)
        self._records = keep

        for a in sorted(cone):
            self._uf[a] = a
            self._size[a] = 1
            self._members[a] = [a]
            self._pf[a] = None
            self._pf_rec[a] = None
            self._class_cache.pop(a, None)
        for root in cone_roots:
            self._class_cache.pop(root, None)

        for r in keep:
            if r.kind != "assumption":
                continue
            if r.a not in cone and r.b not in cone:
                continue
            r.applied = False
            if self.find(r.a) != self.find(r.b):
                self._union(r.a, r.b, r)

        dirty: Set[str] = set(cone)
        frontier = list(cone)
        while frontier:
            n = frontier.pop()
            for p in self._parents.get(n, ()):
                if p not in dirty:
                    dirty.add(p)
                    frontier.append(p)
        self._closure(sorted(dirty))
        return True

    # ------------------------------------------------------------------
    # directed edges: a separate graph, never a union
    # ------------------------------------------------------------------
    def add_directed(self, edge: Edge) -> int:
        """Record a directed (or merely non-equational) typed edge.

        ``Eq`` is refused here: equalities belong in the union-find, via
        ``merge``.  Everything else -- including the symmetric ``Iso`` and
        ``Dual``, which relate *different presentations* and so must not
        collapse L0 addresses -- lives here.  Symmetric kinds are stored in both
        directions.  Nothing in this method touches the union-find or the proof
        forest, which is why a ``Quotient`` can never produce an equality.
        """
        if not isinstance(edge, Edge):
            raise EGraphError("add_directed() takes an edges.Edge")
        if edge.kind == "Eq":
            raise EGraphError("Eq belongs in merge(), not in the directed graph")
        for a in (edge.src, edge.dst):
            if a not in self._terms:
                raise EGraphError("directed endpoint %s is not registered" % a[:8])
        self.steps.bump("directed_edges")
        idx = len(self._directed)
        self._directed.append(edge)
        self._out.setdefault(edge.src, []).append(idx)
        if is_symmetric(edge.kind):
            rev = Edge(kind=edge.kind, src=edge.dst, dst=edge.src, eps=edge.eps,
                       pairing=edge.pairing, witness=edge.witness,
                       label=edge.label, provenance=(edge.edge_id,))
            ridx = len(self._directed)
            self._directed.append(rev)
            self._out.setdefault(rev.src, []).append(ridx)
        return idx

    def directed_edges(self) -> Tuple[Edge, ...]:
        return tuple(self._directed)

    def reachable(self, x, y, max_depth: int = 8) -> Optional[Edge]:
        """The typed composite of some directed route ``x -> y``, or ``None``.

        Movement inside an e-class is free and typed ``Eq`` (the identity of the
        edge algebra), so directed edges compose across proved equalities.
        Search is breadth-first in ascending edge index, so the answer is
        deterministic.  It is a *reachability* answer: it never merges classes
        and never feeds ``explain``.
        """
        a, b = self._require(x), self._require(y)
        if self.find(a) == self.find(b):
            self.steps.bump("reach_steps")
            return Edge(kind="Eq", src=a, dst=b, label="class")
        start = Edge(kind="Eq", src=a, dst=a, label="class")
        queue = deque([(a, start, 0)])
        seen: Set[Tuple[str, str, Any]] = {(a, "Eq", None)}
        while queue:
            node, acc, d = queue.popleft()
            self.steps.bump("reach_steps")
            if d >= max_depth:
                continue
            outs: List[int] = []
            for m in self.class_of(node):
                outs.extend(self._out.get(m, ()))
            for idx in sorted(set(outs)):
                e = self._directed[idx]
                nxt = compose(Edge(kind=acc.kind, src=acc.src, dst=e.src, eps=acc.eps,
                                   pairing=acc.pairing, witness=acc.witness,
                                   label=acc.label, provenance=acc.provenance), e)
                if nxt is None:
                    continue
                if self.find(nxt.dst) == self.find(b):
                    return nxt
                key = (self.find(nxt.dst), nxt.kind, nxt.eps)
                if key in seen:
                    continue
                seen.add(key)
                queue.append((nxt.dst, nxt, d + 1))
        return None

    # ------------------------------------------------------------------
    # reporting
    # ------------------------------------------------------------------
    def report(self) -> str:
        return self.steps.render()
