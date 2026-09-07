"""PROPOSE -- conjecture from generated states, then discharge, refute or wait.

CRYSTAL.md sec 3.2 says a **collision** -- two states one observation cannot
tell apart -- is not a failure but a specification.  This module reads that
sentence in the generative direction: a collision between two *distinct
constructions* is a specification of a candidate theorem.

    OBSERVE     cheap channel: exact integer evaluation at a fixed, ordered
                set of probe points.  Two distinct terms with one signature
                are a collision.
    PROPOSE     each collision becomes a ``Conjecture`` edge in a graph that
                is **separate** from the accepted one and can never merge with
                it (``ProposalGraph.accepted_edges`` is asserted Conjecture-free
                and ``kernel.check.check_edge`` rejects the kind outright).
    DISCHARGE   route A: oriented rewriting to normal form under the current
                book.  route B: equality saturation over the kernel e-graph
                (``execute.saturate``) with the multiway graph's accepted Eq
                edges installed as rules by ``execute.rule_from_edge``.
                Success builds a real ``Eq`` edge whose path the kernel checks.
    REFUTE      an exact evaluation at any integer point that separates the two
                sides *decides* they are different polynomials.  A refuted
                conjecture is a counterexample, and its speculative dependency
                cone is invalidated through ``propagate.invalidate`` /
                ``propagate.recompute.apply`` -- not marked, computed.
    WAIT        neither discharged nor refuted inside the budget.  It stays a
                conjecture, is reported as a residual, and is never used.

Why a conjecture can have dependents at all
-------------------------------------------
A ``Conjecture`` composes with nothing, so it can never appear in an accepted
derivation.  But conjectures can be chained *speculatively*: from candidates
``a ~ b`` and ``b ~ c`` this module proposes ``a ~ c`` and records the
dependency in a ``propagate.DependencyGraph``.  That closure graph lives
entirely inside the proposal side, and it is what gives a counterexample a
real cone to invalidate.  A runtime that only *marked* the refuted conjecture
would leave the speculative consequences it had already spawned standing.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, Iterable, List, Optional, Sequence, Tuple

from ..crystallize.derivation import (Counter, Derivation, Divergence, Term,
                                      VAR, check_derivation, evaluate,
                                      normalize, poly_equal, render)
from ..execute.rewrite import (RewriteError, expand_path, reverse_path,
                               rule_from_edge)
from ..execute.saturate import Budget as SatBudget
from ..execute.saturate import saturate
from ..kernel import check as C
from ..kernel.edges import Edge
from ..kernel.egraph import EGraph
from ..propagate.cone import DependencyGraph
from ..propagate.cone import Derivation as PDerivation
from ..propagate.cone import Fact
from ..propagate.invalidate import Invalidation, invalidate
from ..propagate.recompute import RecomputeReport, apply as recompute_apply
from .multiway import AxiomVault, MultiwayGraph, encode, kernel_dirs, lift_path

__all__ = [
    "Probe", "probe", "uniform", "probe_render", "ALPHABET", "signature",
    "variables_of",
    "collisions",
    "Conjecture", "OPEN", "DISCHARGED", "REFUTED", "EXHAUSTED",
    "Discharge", "ProposalGraph", "eq_edge_from_derivations",
    "discharge_by_rewriting", "discharge_by_saturation", "triage",
    "AUDIT_GRID", "DEFAULT_CHANNEL",
]

ALPHABET: Tuple[str, ...] = ("a", "b", "u", "v", "w", "x", "y", "z")

# A probe is an integer point together with a modulus.  ``mod == 0`` means the
# exact value; ``mod == m`` means the residue mod m, i.e. observation through
# the ring homomorphism ``Z -> Z/m``.  Both are exact -- no float, no
# tolerance -- and the modular one is *coarser*, which is where CRYSTAL.md
# sec 3.2 step 2 says to start ("start from the coarsest observation").  A
# channel that already separates everything is a channel with nothing to learn.
Probe = Tuple[Tuple[Tuple[str, int], ...], int]


def probe(mod: int = 0, **env: int) -> Probe:
    """A named integer point.  Sorted, so the channel order is deterministic."""
    full = {v: 0 for v in ALPHABET}
    full.update(env)
    return (tuple(sorted(full.items())), mod)


def uniform(k: int, mod: int = 0) -> Probe:
    """The diagonal point ``a = b = ... = z = k``, read mod ``mod``."""
    return (tuple(sorted({v: k for v in ALPHABET}.items())), mod)


def probe_render(p: Probe) -> str:
    env, mod = p
    body = ",".join("%s=%d" % kv for kv in env if kv[1] != 0) or "all=0"
    return body + (" (mod %d)" % mod if mod else "")


# The coarsest channel a round ever starts from: two diagonal points.  It is
# *meant* to be too coarse -- a channel that separates everything proposes
# nothing, and a loop that never proposes a falsehood has nothing to refute and
# nothing to learn from.  On the diagonal, terms differing only in *which*
# variables they use are indistinguishable, so cross-construction collisions
# (the interesting, frequently false ones) are exactly what this channel sees.
# REFLECT widens it with the points that actually separated a refuted pair.
DEFAULT_CHANNEL: Tuple[Probe, ...] = (uniform(1, mod=3), uniform(2, mod=4))

# The audit grid is the *refutation* library: an ordered, fixed set of exact
# points that assigns every variable of the alphabet a value, with the values
# rotated so no two variables are pinned together.  It is deliberately not part
# of the proposal channel -- if it were, no collision would survive to be
# conjectured.  Evaluation at any one of these points *decides* "different
# polynomials", so a separation here is a proof, not evidence.
_AUDIT_ROWS: Tuple[Tuple[int, ...], ...] = (
    (0, 1, 2, -1, 3),
    (1, -2, 0, 2, -1),
    (2, 3, -1, 1, 0),
    (-3, 1, 2, 0, 4),
    (5, -2, 3, 1, -4),
    (1, 0, 0, 1, 0),
)

AUDIT_GRID: Tuple[Probe, ...] = tuple(
    (tuple(sorted({ALPHABET[i]: row[(i + shift) % len(row)]
                   for i in range(len(ALPHABET))}.items())), 0)
    for row in _AUDIT_ROWS
    for shift in range(len(row))
)


def variables_of(t: Term) -> Tuple[str, ...]:
    out: List[str] = []
    seen = set()
    stack = [t]
    while stack:
        n = stack.pop()
        if n.kind == VAR and n.val not in seen:
            seen.add(n.val)
            out.append(n.val)
        for a in reversed(n.args):
            stack.append(a)
    return tuple(sorted(out))


def signature(t: Term, channel: Sequence[Probe],
              ctr: Optional[Counter] = None) -> Optional[Tuple[int, ...]]:
    """Exact observation of ``t`` through ``channel``.

    ``None`` when the term uses a variable outside ``ALPHABET`` -- an
    unobservable state, which is reported rather than guessed at.
    """
    vs = variables_of(t)
    if any(v not in ALPHABET for v in vs):
        return None
    out: List[int] = []
    for env, mod in channel:
        if ctr is not None:
            ctr.effort()
        val = evaluate(t, dict(env))
        out.append(val % mod if mod else val)
    return tuple(out)


def collisions(terms: Sequence[Term], channel: Sequence[Probe],
               ctr: Optional[Counter] = None,
               limit: int = 0,
               sources: Optional[Dict[str, int]] = None
               ) -> List[Tuple[Term, Term]]:
    """Distinct constructions that ``channel`` cannot tell apart.

    Deterministic: buckets are keyed by the exact signature and read out in
    first-appearance order; inside a bucket the terms keep the order they were
    handed in.  ``limit`` truncates and the truncation is reported by the
    caller, never silently.

    Enumeration is **breadth-first across buckets**, not depth-first inside
    them: one pair from every bucket, then a second from every bucket, and so
    on.  Depth-first is what a naive implementation does and it is a trap under
    a budget -- the first bucket is usually one construction's own rewrite
    orbit, whose pairs are all *true*, so a depth-first budget spends itself
    entirely on conjectures that cannot fail and the loop never sees a
    counterexample.  Breadth-first costs nothing and is neutral: it prefers no
    pair over any other, it only stops starving the later buckets.

    ``sources`` maps a term address to the construction it was generated from.
    When it is supplied, **cross-source pairs are enumerated before same-source
    pairs inside each bucket**.  This is not a thumb on the scale toward
    falsehood: two states of one construction's rewrite orbit are already
    joined by an accepted path in the multiway graph, so a conjecture between
    them is one the runtime can discharge by construction and it teaches
    nothing.  The pairs worth a proof budget are the ones spanning two
    independent constructions, and they are also -- unavoidably -- the ones
    that can be false.
    """
    buckets: Dict[Tuple[int, ...], List[Term]] = {}
    order: List[Tuple[int, ...]] = []
    seen: set = set()
    for t in terms:
        if t.addr in seen:
            continue
        seen.add(t.addr)
        sig = signature(t, channel, ctr)
        if sig is None:
            continue
        if sig not in buckets:
            buckets[sig] = []
            order.append(sig)
        buckets[sig].append(t)
    lanes: List[List[Tuple[Term, Term]]] = []
    for sig in order:
        group = buckets[sig]
        cross: List[Tuple[Term, Term]] = []
        same: List[Tuple[Term, Term]] = []
        for i in range(len(group)):
            for j in range(i + 1, len(group)):
                a, b = group[i], group[j]
                pair = (a, b) if a.ckey < b.ckey else (b, a)
                if sources is not None and \
                        sources.get(a.addr, -1) != sources.get(b.addr, -2):
                    cross.append(pair)
                else:
                    same.append(pair)
        lane = cross + same
        if lane:
            lanes.append(lane)
    out: List[Tuple[Term, Term]] = []
    depth = 0
    while lanes:
        progressed = False
        for lane in lanes:
            if depth < len(lane):
                progressed = True
                out.append(lane[depth])
                if limit and len(out) >= limit:
                    return out
        if not progressed:
            break
        depth += 1
    return out


# ==========================================================================
# conjectures
# ==========================================================================

OPEN = "open"
DISCHARGED = "discharged"
REFUTED = "refuted"
EXHAUSTED = "exhausted"


def _cid(a: Term, b: Term) -> str:
    lo, hi = (a, b) if a.ckey < b.ckey else (b, a)
    return "c|%s|%s" % (lo.addr[:12], hi.addr[:12])


@dataclass(frozen=True)
class Conjecture:
    """A proposed equality.  Carries a ``Conjecture`` edge and no authority."""

    cid: str
    lhs: Term
    rhs: Term
    edge: Edge
    round: int
    origin: str                       # "collision" | "closure"
    premises: Tuple[str, ...] = ()

    def render(self) -> str:
        return "%s  %s  ~?~  %s" % (self.cid, render(self.lhs), render(self.rhs))


@dataclass
class Discharge:
    """The verdict on one conjecture, in one round."""

    cid: str
    status: str
    route: str = ""
    steps: int = 0
    work: int = 0
    edge: Optional[Edge] = None
    separator: Optional[Probe] = None
    reason: str = ""

    def render(self) -> str:
        tail = self.reason if self.reason else self.route
        return "%-30s %-11s %s" % (self.cid, self.status, tail)


# ==========================================================================
# building an accepted Eq edge out of ring derivations
# ==========================================================================

def _path_of(vault: AxiomVault, d: Derivation,
             lemmas: Optional[Dict[str, object]] = None
             ) -> Optional[Tuple[C.Step, ...]]:
    """Lift a ring derivation into a kernel proof path, gate by gate.

    Every step goes through ``AxiomVault.declare``, so every step is re-run
    against its schema (A1) and decided by ``poly_equal`` (A2) before the
    kernel is even asked.  A single refusal aborts the whole path -- there is
    no partial proof.
    """
    lemmas = lemmas or {}
    path: List[C.Step] = []
    for st in d.steps:
        lem = lemmas.get(st.lemma_id) if st.lemma_id is not None else None
        if st.lemma_id is not None and lem is None:
            return None
        name = vault.declare(st.rule, st.redex, st.contractum, lemma=lem)
        if name is None:
            return None
        base = (C.Step(src=encode(st.redex).addr,
                       dst=encode(st.contractum).addr,
                       kind="assumption", witness=C.Axiom(name)),)
        path.extend(lift_path(encode(st.before), kernel_dirs(st.before, st.pos),
                              base))
    return tuple(path)


def eq_edge_from_derivations(vault: AxiomVault, lhs: Term, rhs: Term,
                             dl: Derivation, dr: Derivation,
                             lemmas: Optional[Dict[str, object]] = None,
                             label: str = "") -> Optional[Edge]:
    """``lhs -->* nf <--* rhs`` becomes one checked ``Eq`` edge, or nothing."""
    if dl.result.addr != dr.result.addr:
        return None
    pl = _path_of(vault, dl, lemmas)
    pr = _path_of(vault, dr, lemmas)
    if pl is None or pr is None:
        return None
    path = tuple(pl) + reverse_path(pr)
    edge = Edge(kind="Eq", src=encode(lhs).addr, dst=encode(rhs).addr,
                witness=path, label=label or "discharge")
    if not C.check_edge(edge, vault.ctx):
        return None
    return edge


# ==========================================================================
# the proposal graph
# ==========================================================================

class ProposalGraph:
    """Conjectures, their speculative closure, and their verdicts.

    Two graphs, deliberately not one:

    * ``self.conjectures`` / ``self.dg`` -- the proposal side.  Holds
      ``Conjecture`` edges and a ``propagate.DependencyGraph`` recording which
      conjecture was proposed *from* which.  Nothing here is usable.
    * ``self.accepted_edges`` -- the accepted side.  ``Eq`` only, each one
      kernel-checked at the moment it was added.  ``audit()`` re-checks the lot
      and fails loudly on any ``Conjecture``.
    """

    __slots__ = ("vault", "conjectures", "order", "status", "verdicts", "dg",
                 "accepted_edges", "counterexamples", "invalidations",
                 "closure_edges", "_facts")

    def __init__(self, vault: AxiomVault) -> None:
        self.vault = vault
        self.conjectures: Dict[str, Conjecture] = {}
        self.order: List[str] = []
        self.status: Dict[str, str] = {}
        self.verdicts: Dict[str, Discharge] = {}
        self.dg = DependencyGraph()
        self.accepted_edges: List[Edge] = []
        self.counterexamples: List[Tuple[str, Probe, int, int]] = []
        self.invalidations: List[Invalidation] = []
        self.closure_edges = 0
        self._facts: set = set()

    # -- proposal ----------------------------------------------------------
    def propose(self, lhs: Term, rhs: Term, rnd: int, origin: str = "collision",
                premises: Sequence[str] = ()) -> Optional[Conjecture]:
        if lhs.addr == rhs.addr:
            return None
        cid = _cid(lhs, rhs)
        if cid in self.conjectures:
            return None
        lo, hi = (lhs, rhs) if lhs.ckey < rhs.ckey else (rhs, lhs)
        edge = Edge(kind="Conjecture", src=encode(lo).addr, dst=encode(hi).addr,
                    witness=C.Conjectural(label=cid), label=cid)
        cj = Conjecture(cid, lo, hi, edge, rnd, origin, tuple(premises))
        self.conjectures[cid] = cj
        self.order.append(cid)
        self.status[cid] = OPEN
        if cid not in self._facts:
            self.dg.add_fact(Fact(cid, statement=cj.render(), value=None))
            self._facts.add(cid)
        if premises:
            self.dg.add_derivation(PDerivation(
                did="d|" + cid, conclusion=cid, premises=tuple(premises),
                cost=1, rule="speculative-transitivity",
                compute=lambda env: tuple(sorted(env))))
            self.closure_edges += 1
        return cj

    def close_transitively(self, rnd: int, limit: int = 12) -> List[Conjecture]:
        """``a ~ b`` and ``b ~ c`` speculatively give ``a ~ c``.

        Only over conjectures that are still ``OPEN``: a refuted premise may
        not spawn new speculation, and a discharged one is not speculation at
        all (it is an accepted ``Eq`` and transitivity there is the e-graph's
        job, not this function's).
        """
        by_end: Dict[str, List[str]] = {}
        for cid in self.order:
            if self.status[cid] != OPEN:
                continue
            cj = self.conjectures[cid]
            by_end.setdefault(cj.lhs.addr, []).append(cid)
            by_end.setdefault(cj.rhs.addr, []).append(cid)
        made: List[Conjecture] = []
        for cid in list(self.order):
            if self.status.get(cid) != OPEN:
                continue
            c1 = self.conjectures[cid]
            for shared, other_side in ((c1.rhs, c1.lhs), (c1.lhs, c1.rhs)):
                for cid2 in by_end.get(shared.addr, ()):
                    if cid2 == cid or self.status.get(cid2) != OPEN:
                        continue
                    c2 = self.conjectures[cid2]
                    far = c2.rhs if c2.lhs.addr == shared.addr else c2.lhs
                    if far.addr == other_side.addr:
                        continue
                    got = self.propose(other_side, far, rnd, "closure",
                                       (cid, cid2))
                    if got is not None:
                        made.append(got)
                        if len(made) >= limit:
                            return made
        return made

    # -- refutation --------------------------------------------------------
    def refute(self, cid: str, grid: Sequence[Probe] = AUDIT_GRID
               ) -> Optional[Tuple[Probe, int, int]]:
        """An exact integer point separating the two sides, or ``None``.

        Sound as a *decision*: two polynomials agreeing everywhere agree here,
        so a disagreement here proves they are different polynomials.
        """
        cj = self.conjectures[cid]
        vs = set(variables_of(cj.lhs)) | set(variables_of(cj.rhs))
        if any(v not in ALPHABET for v in vs):
            return None
        for p in grid:
            env, mod = p
            a, b = evaluate(cj.lhs, dict(env)), evaluate(cj.rhs, dict(env))
            if mod:
                a, b = a % mod, b % mod
            if a != b:
                return (p, a, b)
        return None

    def record_refutation(self, cid: str, sep: Tuple[Probe, int, int]
                          ) -> Tuple[Invalidation, RecomputeReport]:
        """Mark refuted **and compute the consequences** through ``propagate``.

        The cone is not asserted, it is derived: every speculative conjecture
        that rests on ``cid`` dies with it, and ``recompute.apply`` performs the
        mutation the plan describes.
        """
        self.status[cid] = REFUTED
        self.counterexamples.append((cid, sep[0], sep[1], sep[2]))
        plan = invalidate(self.dg, cid)
        report = recompute_apply(self.dg, plan)
        self.invalidations.append(plan)
        for f in plan.dies:
            if f in self.status and self.status[f] != REFUTED:
                self.status[f] = REFUTED
        return (plan, report)

    # -- acceptance --------------------------------------------------------
    def accept(self, cid: str, edge: Edge) -> None:
        if edge.kind != "Eq":
            raise ValueError("only an Eq edge may be accepted (got %s)"
                             % edge.kind)
        self.status[cid] = DISCHARGED
        self.accepted_edges.append(edge)

    def audit(self) -> Tuple[bool, str]:
        ctx = C.CheckContext(axioms=dict(self.vault.ctx.axioms))
        for e in self.accepted_edges:
            if e.kind != "Eq":
                return (False, "a %s edge reached the accepted set" % e.kind)
            if not C.check_edge(e, ctx):
                return (False, "accepted edge %s failed re-check" % e.edge_id[:8])
        for cid in self.order:
            cj = self.conjectures[cid]
            if cj.edge.kind != "Conjecture":
                return (False, "proposal %s is not a Conjecture edge" % cid)
            if C.check_edge(cj.edge, ctx):
                return (False, "the checker accepted a Conjecture edge")
        return (True, "%d accepted Eq edges, %d conjectures, no crossover"
                % (len(self.accepted_edges), len(self.order)))

    def open_ids(self) -> Tuple[str, ...]:
        return tuple(c for c in self.order if self.status[c] == OPEN)

    def count(self, st: str) -> int:
        return sum(1 for c in self.order if self.status[c] == st)


# ==========================================================================
# discharge
# ==========================================================================

def discharge_by_rewriting(pg: ProposalGraph, cid: str, lemmas: Sequence,
                           index=None, max_steps: int = 4000) -> Discharge:
    """Route A: normalise both sides under the current book and compare."""
    cj = pg.conjectures[cid]
    ctr = Counter()
    try:
        dl, _ = normalize(cj.lhs, lemmas=tuple(lemmas), ctr=ctr,
                          name="disch-l", max_steps=max_steps, index=index)
        dr, _ = normalize(cj.rhs, lemmas=tuple(lemmas), ctr=ctr,
                          name="disch-r", max_steps=max_steps, index=index)
    except Divergence as exc:
        return Discharge(cid, EXHAUSTED, "normalize", ctr.steps, ctr.work,
                         reason="budget: %s" % exc)
    if dl.result.addr != dr.result.addr:
        return Discharge(cid, OPEN, "normalize", ctr.steps, ctr.work,
                         reason="normal forms differ")
    table = {l.lid: l for l in lemmas}
    check_derivation(dl, table, ctr)
    check_derivation(dr, table, ctr)
    edge = eq_edge_from_derivations(pg.vault, cj.lhs, cj.rhs, dl, dr, table,
                                    label="norm:" + cid)
    if edge is None:
        return Discharge(cid, OPEN, "normalize", ctr.steps, ctr.work,
                         reason="lifted path did not check")
    return Discharge(cid, DISCHARGED, "normalize", ctr.steps, ctr.work,
                     edge=edge)


def discharge_by_saturation(pg: ProposalGraph, cid: str, mg: MultiwayGraph,
                            max_rules: int = 120,
                            budget: Optional[SatBudget] = None) -> Discharge:
    """Route B: equality saturation over the kernel e-graph (``execute/``).

    The multiway graph's accepted ``Eq`` edges become rewrite rules through
    ``execute.rule_from_edge`` -- which re-checks each edge before installing
    it as a theorem -- and ``execute.saturate`` runs congruence closure over
    them.  If the two sides land in one class, the e-graph's ``explain`` path
    is **expanded back to primitives** (``execute.expand_path``) and re-checked
    in a context where no theorem is declared, so the accepted edge rests on
    the vault's axioms alone.
    """
    cj = pg.conjectures[cid]
    ctx = C.CheckContext(axioms=dict(pg.vault.ctx.axioms))
    rules = []
    for i, me in enumerate(mg.edges[:max_rules]):
        try:
            rules.append(rule_from_edge(me.edge, ctx, "th|%s|%d" % (cid, i)))
        except RewriteError:
            continue
    if not rules:
        return Discharge(cid, OPEN, "saturate", reason="no usable rules")
    g = EGraph()
    a, b = encode(cj.lhs), encode(cj.rhs)
    g.add(a)
    g.add(b)
    res = saturate(g, rules, ctx, budget or SatBudget(max_iterations=4,
                                                     max_applications=400))
    if g.find(a) != g.find(b):
        return Discharge(cid, OPEN, "saturate",
                         reason="not joined (%s, %d unions)"
                                % (res.status, res.unions))
    path = g.explain(a, b)
    if path is None:
        return Discharge(cid, OPEN, "saturate", reason="no explanation")
    try:
        prim = expand_path(path, rules)
    except RewriteError as exc:
        return Discharge(cid, OPEN, "saturate", reason="expansion failed: %s" % exc)
    bare = C.CheckContext(axioms=dict(pg.vault.ctx.axioms))
    edge = Edge(kind="Eq", src=a.addr, dst=b.addr, witness=tuple(prim),
                label="sat:" + cid)
    if not C.check_edge(edge, bare):
        return Discharge(cid, OPEN, "saturate",
                         reason="expanded path did not re-check")
    return Discharge(cid, DISCHARGED, "saturate", steps=len(prim),
                     work=res.applications, edge=edge)


def triage(pg: ProposalGraph, cids: Sequence[str], lemmas: Sequence,
           mg: Optional[MultiwayGraph] = None, index=None,
           max_steps: int = 4000, use_saturation: bool = True,
           grid: Sequence[Probe] = AUDIT_GRID) -> List[Discharge]:
    """Try to prove each conjecture; failing that, try to refute it.

    Order is fixed by ``cids``.  Three outcomes and no fourth: DISCHARGED (an
    ``Eq`` edge the kernel accepted), REFUTED (an exact separating point, with
    its cone invalidated), or still OPEN / EXHAUSTED, which is a residual and
    is never used for anything.
    """
    out: List[Discharge] = []
    for cid in cids:
        if pg.status.get(cid) != OPEN:
            continue
        v = discharge_by_rewriting(pg, cid, lemmas, index, max_steps)
        if v.status == DISCHARGED:
            pg.accept(cid, v.edge)
            out.append(v)
            pg.verdicts[cid] = v
            continue
        sep = pg.refute(cid, grid)
        if sep is not None:
            pg.record_refutation(cid, sep)
            v = Discharge(cid, REFUTED, v.route, v.steps, v.work,
                          separator=sep[0],
                          reason="separated %d != %d at %s"
                                 % (sep[1], sep[2], probe_render(sep[0])))
            out.append(v)
            pg.verdicts[cid] = v
            continue
        if use_saturation and mg is not None:
            v2 = discharge_by_saturation(pg, cid, mg)
            if v2.status == DISCHARGED:
                pg.accept(cid, v2.edge)
                out.append(v2)
                pg.verdicts[cid] = v2
                continue
            v = Discharge(cid, v.status if v.status == EXHAUSTED else OPEN,
                          "normalize+saturate", v.steps, v.work,
                          reason="%s; %s" % (v.reason, v2.reason))
        out.append(v)
        pg.verdicts[cid] = v
    return out
