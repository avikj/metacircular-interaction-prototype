"""The closed cycle (CRYSTAL.md sec 7), with no human and no model in it.

    GENERATE -> DISTINGUISH -> PROVE -> CRYSTALLIZE -> COMPRESS -> ROUTE
             -> REFLECT ------------------------------------------^

Every arrow below is either an already-BUILT module or code in this package.
Where an arrow is **not** wired, it says so in ``ARROWS`` and the loop runs
without it rather than faking it.

| arrow       | implementation                                                |
|-------------|---------------------------------------------------------------|
| GENERATE    | ``generate.multiway.generate`` -- typed, proof-carrying        |
| DISTINGUISH | ``generate.propose.collisions`` over an exact integer channel  |
| PROVE       | ``generate.propose.triage`` = crystallize's normaliser (route  |
|             | A) and ``execute.saturate`` + ``execute.rule_from_edge``       |
|             | (route B); every accepted edge kernel-checked                  |
| CRYSTALLIZE | ``crystallize.mine`` + ``crystallize.Book.install`` (7 gates), |
|             | queried through ``crystallize.LemmaIndex`` so SCALE.md's       |
|             | 22-lemma crossover does not bite                               |
| COMPRESS    | drop never-firing lemmas; drop probes that separate nothing    |
|             | (CRYSTAL.md sec 3.2's converse step)                           |
| ROUTE       | ``execute.dominates`` over an exact 4-component cost vector    |
| REFLECT     | residuals -> next round's seeds and next round's channel       |
| REALIZE     | **NOT WIRED.** ``render/`` produces perceptual surfaces from a |
|             | channel spec and nothing in this loop consumes one, so no      |
|             | REALIZE arrow is claimed.  See ``ARROWS``.                     |

THE MEASUREMENT
---------------
A **held-out benchmark** is fixed before round 1.  It is never a seed, never a
generation target, never a mining input, never a compression input and never a
routing input.  ``leakage_report`` is the machine check of that, and it is a
test, not a promise.  Each round reports the benchmark's exact cost.  The
question the loop exists to answer is whether that cost falls.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List, Optional, Sequence, Tuple

from ..crystallize.derivation import (I, LemmaIndex, P, PV, S, Sub, Term, V,
                                      Counter, Divergence, check_derivation,
                                      mk, match as ring_match, normalize,
                                      render, VAR)
from ..crystallize.install import Book
from ..crystallize.mine import mine
from ..execute.extract import CostVector, dominates
from ..generate import propose as PR
from ..generate.multiway import (AxiomVault, GenerationBudget, MultiwayGraph,
                                 causal_report, generate)

__all__ = [
    "ARROWS", "BENCHMARK", "BENCHMARK_NAME", "BENCHMARK2", "BENCHMARK2_NAME",
    "BENCHMARKS", "Config", "RoundReport", "Organism", "constructions",
    "leakage_report", "LeakageReport", "benchmark_cost",
]

ARROWS: Tuple[Tuple[str, str], ...] = (
    ("GENERATE", "generate.multiway.generate (typed multiway, kernel-checked)"),
    ("DISTINGUISH", "generate.propose.collisions (exact integer channel)"),
    ("PROVE", "generate.propose.triage (crystallize normaliser + execute.saturate)"),
    ("CRYSTALLIZE", "crystallize.mine + Book.install (7 gates) + LemmaIndex"),
    ("COMPRESS", "never-firing lemmas dropped; non-separating probes dropped"),
    ("ROUTE", "execute.dominates over an exact 4-component cost vector"),
    ("REALIZE", "NOT WIRED -- no consumer for a perceptual surface in this loop"),
    ("REFLECT", "residuals -> next round's seeds and channel"),
)


# ==========================================================================
# the held-out benchmark, fixed here, before any round runs
# ==========================================================================
#
# (x^2 + 3y)(x^2 - 3y) + 9y^2, whose answer is x^4.  Chosen before round 1 and
# never touched by the loop's own choices.  Its difference-of-squares arguments
# are *compound* (x*x and 3*y), which is what makes it independent of anything
# a construction schema over bare atoms can produce.

_X, _Y = V("x"), V("y")
_XX, _3Y, _2Y = P(_X, _X), P(I(3), _Y), P(I(2), _Y)
BENCHMARK: Term = S(P(S(_XX, _3Y), Sub(_XX, _3Y)), P(I(9), _Y, _Y))
BENCHMARK_NAME = "B1  (x^2+3y)(x^2-3y) + 9y^2"

# A second held-out problem, fixed at the same moment as the first and for the
# same reason: with one benchmark a loop that improves once is indistinguishable
# from a loop that improves once *and then stops*.  B2 needs a different lemma
# from B1, so the pair can show whether learning recurs or fires once.
BENCHMARK2: Term = S(P(S(_XX, _2Y), S(_XX, _2Y)), P(I(-4), _Y, _Y))
BENCHMARK2_NAME = "B2  (x^2+2y)^2 - 4y^2"

BENCHMARKS: Tuple[Tuple[str, Term], ...] = (
    (BENCHMARK_NAME, BENCHMARK),
    (BENCHMARK2_NAME, BENCHMARK2),
)


def benchmark_cost(book: Optional[Book], index: Optional[LemmaIndex] = None,
                   target: Term = BENCHMARK) -> Tuple[int, int, Term]:
    """Exact ``(steps, work, answer)`` for the benchmark under ``book``.

    The derivation is kernel-checked here, every round, so a cheaper number is
    never a less-checked number.
    """
    ctr = Counter()
    lemmas = tuple(book.lemmas) if book is not None else ()
    d, _ = normalize(target, lemmas=lemmas, ctr=ctr, name="benchmark",
                     index=index)
    check_derivation(d, book.table() if book is not None else {}, ctr)
    return (ctr.steps, ctr.work, d.result)


# ==========================================================================
# the construction schema -- what GENERATE is allowed to build from
# ==========================================================================

_VARS: Tuple[Term, ...] = tuple(V(n) for n in PR.ALPHABET)
_CONSTS: Tuple[Term, ...] = (I(2), I(3), I(5), I(7))
ATOMS: Tuple[Term, ...] = _VARS + _CONSTS + (I(-1),)

# The constructor families.  Each is a closed term function of two atoms, built
# from S and P alone.  This list, the pair enumeration and the embeddings are
# the *entire* generative freedom of the loop -- nothing downstream chooses.
_FAMILIES: Tuple[Tuple[str, object], ...] = (
    ("dsq", lambda a, b: P(S(a, b), Sub(a, b))),
    ("sq", lambda a, b: P(S(a, b), S(a, b))),
    ("mix", lambda a, b: P(S(a, b), S(b, a))),
    ("tri", lambda a, b: P(S(a, b), S(a, Sub(b, a)))),
)

# Embeddings put the same sub-derivation at *different positions* of the whole
# term, which is what makes the mined sub-DAG's position vary and therefore
# what makes the mining non-trivial.  The tail embedding reuses ``a`` rather
# than a fresh variable, exactly as the crystallize demo's P3 does: with a
# fresh variable there the benchmark would become an instance of the seed, and
# ``leakage_report``'s L4 would (correctly) fire.
_EMBED: Tuple[object, ...] = (
    lambda sh, a, c: sh,
    lambda sh, a, c: S(c, sh),
    lambda sh, a, c: S(sh, a),
)


def _pairs() -> List[Tuple[Term, Term]]:
    out: List[Tuple[Term, Term]] = []
    n = len(_VARS)
    for gap in range(1, n):
        for i in range(n):
            out.append((_VARS[i], _VARS[(i + gap) % n]))
    return out


PAIRS: Tuple[Tuple[Term, Term], ...] = tuple(_pairs())


def constructions(round_index: int, width: int = 3) -> List[Term]:
    """A deterministic slice of the construction enumeration.

    Round ``r`` takes one constructor family and ``width`` consecutive variable
    pairs, each embedded differently.  Same shape, different data, different
    position -- which is the situation ``crystallize.mine`` needs and the
    situation a single-pair schema silently fails to produce (it mines *ground*
    lemmas that generalise to nothing).  The slice is a pure function of
    ``round_index``; nothing that has seen the benchmark chooses it.
    """
    name, fam = _FAMILIES[round_index % len(_FAMILIES)]
    block = round_index // len(_FAMILIES)
    out: List[Term] = []
    for i in range(width):
        a, b = PAIRS[(block * width + i) % len(PAIRS)]
        sh = fam(a, b)
        emb = _EMBED[i % len(_EMBED)]
        out.append(emb(sh, a, _CONSTS[(block + i) % len(_CONSTS)]))
    return out


# ==========================================================================
# configuration and reporting
# ==========================================================================

@dataclass
class Config:
    rounds: int = 10
    width: int = 3
    gen: GenerationBudget = field(default_factory=lambda: GenerationBudget(
        max_states=90, max_edges=260, max_depth=4, max_size=22))
    max_conjectures: int = 18
    closure_limit: int = 6
    prove_steps: int = 3000
    use_saturation: bool = True
    crystallize: bool = True          # the null trajectory turns this off
    compress: bool = True
    max_installs_per_round: int = 2
    lemma_grace: int = 4              # rounds a never-firing lemma survives
    pool_cap: int = 420               # cumulative state pool DISTINGUISH sees
    mine_window: int = 24
    mine_min_support: int = 2
    use_index: bool = True            # SCALE.md sec 3: amortised discrimination net
    verbose: bool = False


@dataclass
class RoundReport:
    rnd: int
    seeds: int
    states: int
    edges: int
    refusals: int
    causal: str
    colls_found: int
    surviving: int
    proposed: int
    discharged: int
    refuted: int
    open_: int
    exhausted: int
    cones: int
    cone_facts: int
    mined: int
    installed: int
    rejected: int
    book: int
    dropped_lemmas: int
    channel: int
    dropped_probes: int
    frontier: int
    bench_steps: int
    bench_work: int
    bench2_steps: int
    bench2_work: int
    bench_answer: str
    residuals: int
    gen_status: str

    def row(self) -> str:
        return ("%2d | %4d %5d %4d | %4d %4d %4d %4d | %3d %3d | %3d %5d | %3d %5d"
                % (self.rnd, self.states, self.edges, self.refusals,
                   self.proposed, self.discharged, self.refuted,
                   self.open_ + self.exhausted, self.installed, self.book,
                   self.channel, self.frontier,
                   self.bench_steps, self.bench_work))


ROUND_HEADER = (
    "  r |  sts  edges refu |  cnj disc  ref  res |  +L book | ch  front | "
    "bench work\n"
    " ---+---------------------+---------------------+----------+-----------+"
    "-----------")


# ==========================================================================
# leakage
# ==========================================================================

@dataclass(frozen=True)
class LeakageReport:
    """Did the benchmark, or any part of it, reach the loop's own choices?"""

    clean: bool
    findings: Tuple[str, ...]
    seeds_checked: int
    states_checked: int
    mining_inputs_checked: int

    def render(self) -> str:
        head = "LEAKAGE: CLEAN" if self.clean else "LEAKAGE: DETECTED"
        body = "".join("\n    - " + f for f in self.findings)
        return ("%s  (%d seeds, %d generated states, %d mining inputs checked)%s"
                % (head, self.seeds_checked, self.states_checked,
                   self.mining_inputs_checked, body))


def _as_pattern(t: Term) -> Term:
    """Every ordinary variable becomes a pattern variable (demo's convention)."""
    seen: Dict[str, Term] = {}
    order: List[str] = []

    def walk(n: Term) -> Term:
        if n.kind == VAR:
            if n.val not in seen:
                seen[n.val] = PV(len(order))
                order.append(n.val)
            return seen[n.val]
        if not n.args:
            return n
        return mk(n.kind, n.val, [walk(a) for a in n.args])

    return walk(t)


def _subterm_addrs(t: Term) -> set:
    out = set()
    stack = [t]
    while stack:
        n = stack.pop()
        out.add(n.addr)
        stack.extend(n.args)
    return out


def leakage_report(org: "Organism",
                   targets: Sequence[Tuple[str, Term]] = BENCHMARKS
                   ) -> LeakageReport:
    """Four independent ways the benchmark could have leaked, all checked.

    L1  the benchmark itself was handed to GENERATE as a seed;
    L2  the benchmark was *reached* as a generated state (so its derivation
        could have been mined);
    L3  the benchmark was a mining input, i.e. one of the derivations
        CRYSTALLIZE generalised from;
    L4  the benchmark is an instance of a seed -- the subtle one, because a
        seed that the benchmark instantiates makes the "independent problem"
        an instance of a training problem, which is the failure the crystallize
        lane guards against by hand and this function guards against
        mechanically.

    L2 is checked against every *subterm* address of the benchmark, not just
    its root, so generating a piece of it counts as leakage too.
    """
    findings: List[str] = []
    for label, target in targets:
        tgt = target.addr
        sub = _subterm_addrs(target) - {a.addr for a in ATOMS}
        for s in org.all_seeds:
            if s.addr == tgt:
                findings.append("L1 %s used as a generation seed" % label)
                break
        hit = sub & org.all_state_addrs
        if hit:
            findings.append("L2 %d subterm address(es) of %s appear among the "
                            "%d generated states"
                            % (len(hit), label, len(org.all_state_addrs)))
        for name, t in org.mining_inputs:
            if t.addr == tgt:
                findings.append("L3 %s was a mining input (%s)" % (label, name))
                break
        for s in org.all_seeds:
            if ring_match(_as_pattern(s), target) is not None:
                findings.append("L4 %s is an instance of seed %s"
                                % (label, render(s)))
                break
    return LeakageReport(not findings, tuple(findings), len(org.all_seeds),
                         len(org.all_state_addrs), len(org.mining_inputs))


# ==========================================================================
# the organism
# ==========================================================================

class Organism:
    """One closed loop.  Deterministic, exactly counted, no model anywhere."""

    def __init__(self, cfg: Optional[Config] = None) -> None:
        self.cfg = cfg or Config()
        self.vault = AxiomVault()
        self.book = Book()
        self.index: Optional[LemmaIndex] = None
        self.pg = PR.ProposalGraph(self.vault)
        self.channel: List[PR.Probe] = list(PR.DEFAULT_CHANNEL)
        self.reports: List[RoundReport] = []
        self.residual_seeds: List[Term] = []
        self.pool: List[Term] = []
        self.sources: Dict[str, int] = {}
        self.all_seeds: List[Term] = []
        self.all_state_addrs: set = set()
        self.mining_inputs: List[Tuple[str, Term]] = []
        self.lemma_fires: Dict[str, int] = {}
        self.dropped_lemmas: List[str] = []
        self.graphs: List[MultiwayGraph] = []
        self.install_log: List[Tuple[int, str, str]] = []
        self.reject_log: List[Tuple[int, str]] = []
        self.frontiers: List[Tuple[CostVector, ...]] = []
        self._lid = 0

    # -- helpers -----------------------------------------------------------
    def _rebuild_index(self) -> None:
        self.index = (LemmaIndex(self.book.lemmas)
                      if (self.cfg.use_index and self.book.lemmas) else None)

    def bench(self) -> Tuple[int, int, Term]:
        return benchmark_cost(self.book, self.index)

    # -- one round ---------------------------------------------------------
    def round(self, r: int) -> RoundReport:
        cfg = self.cfg

        # ---------------------------------------------------------- GENERATE
        seeds = constructions(r, cfg.width) + self.residual_seeds[:cfg.width]
        deduped: List[Term] = []
        seen = set()
        for s in seeds:
            if s.addr not in seen:
                seen.add(s.addr)
                deduped.append(s)
        seeds = deduped
        self.all_seeds.extend(seeds)
        g = generate(seeds, cfg.gen, vault=self.vault,
                     lemmas=tuple(self.book.lemmas))
        self.graphs.append(g)
        self.all_state_addrs |= set(g.order)
        cr = causal_report(g)

        # ------------------------------------------------------- DISTINGUISH
        # The pool matters.  Collisions computed only inside one round's graph
        # are almost all *true*: every state of one construction's rewrite orbit
        # really does equal every other, so an amnesiac DISTINGUISH proposes
        # only theorems and the loop never meets a counterexample.  Falsehood
        # lives *between* constructions, so the channel is applied to this
        # round's states together with a bounded, deterministic tail of every
        # earlier round's states.
        terms = [g.states[a] for a in g.order]
        pool = [t for t in self.pool if t.addr not in g.states]
        for a in g.order:
            self.sources.setdefault(a, r * 1000 + g.origin.get(a, -1))
        colls = PR.collisions(terms + pool, self.channel,
                              limit=cfg.max_conjectures * 3,
                              sources=self.sources)
        self.pool = (self.pool + terms)[-cfg.pool_cap:]
        proposed_now: List[str] = []
        unproposed: List[Term] = []
        for a, b in colls:
            if len(proposed_now) >= cfg.max_conjectures:
                unproposed.extend((a, b))
                continue
            cj = self.pg.propose(a, b, r)
            if cj is not None:
                proposed_now.append(cj.cid)
        for cj in self.pg.close_transitively(r, cfg.closure_limit):
            proposed_now.append(cj.cid)

        # ------------------------------------------------------------- PROVE
        # Carried-over residuals are retried first: a conjecture the previous
        # round could not settle may fall to this round's larger book.
        todo = list(self.pg.open_ids())
        before_cones = len(self.pg.invalidations)
        verdicts = PR.triage(self.pg, todo, tuple(self.book.lemmas), mg=g,
                             index=self.index, max_steps=cfg.prove_steps,
                             use_saturation=cfg.use_saturation)
        disch = sum(1 for v in verdicts if v.status == PR.DISCHARGED)
        refut = sum(1 for v in verdicts if v.status == PR.REFUTED)
        exh = sum(1 for v in verdicts if v.status == PR.EXHAUSTED)
        cones = self.pg.invalidations[before_cones:]
        cone_facts = sum(c.cone.size for c in cones)

        # ------------------------------------------------------- CRYSTALLIZE
        derivs = []
        for i, s in enumerate(seeds):
            ctr = Counter()
            try:
                d, _ = normalize(s, lemmas=tuple(self.book.lemmas), ctr=ctr,
                                 name="r%d-t%d" % (r, i), index=self.index,
                                 max_steps=cfg.prove_steps)
            except Divergence:
                continue
            check_derivation(d, self.book.table(), ctr)
            derivs.append(d)
            self.mining_inputs.append((d.name, s))
            for st in d.steps:
                if st.lemma_id is not None:
                    self.lemma_fires[st.lemma_id] = \
                        self.lemma_fires.get(st.lemma_id, 0) + 1

        mined = installed = rejected = 0
        if cfg.crystallize and len(derivs) >= cfg.mine_min_support:
            cands = mine(derivs, window=cfg.mine_window,
                         min_support=cfg.mine_min_support)
            mined = len(cands)
            for c in cands:
                if installed >= cfg.max_installs_per_round:
                    break
                if c.saved_steps < 2:
                    continue
                if any(l.lhs.addr == c.lhs.addr for l in self.book.lemmas):
                    continue
                self._lid += 1
                lid = "L%d" % self._lid
                v = self.book.install_candidate(lid, c)
                if v.ok:
                    installed += 1
                    self.lemma_fires.setdefault(lid, 0)
                    self.install_log.append((r, lid, repr(v.lemma)))
                else:
                    rejected += 1
                    self.reject_log.append((r, "%s %s" % (lid, v.reasons[:1])))
            self._rebuild_index()

        # ------------------------------- post-install firing measurement -----
        # A lemma installed this round cannot have fired in the derivations it
        # was mined from -- they predate it.  Re-solving the round's targets
        # under the new book is what actually measures whether it fires, and
        # omitting this step is how COMPRESS below would otherwise delete the
        # single most valuable lemma in the book (observed, then fixed).
        if installed:
            for i, s in enumerate(seeds):
                ctr = Counter()
                try:
                    d, _ = normalize(s, lemmas=tuple(self.book.lemmas), ctr=ctr,
                                     name="r%d-p%d" % (r, i), index=self.index,
                                     max_steps=cfg.prove_steps)
                except Divergence:
                    continue
                for st in d.steps:
                    if st.lemma_id is not None:
                        self.lemma_fires[st.lemma_id] = \
                            self.lemma_fires.get(st.lemma_id, 0) + 1

        # ---------------------------------------------------------- COMPRESS
        dropped_l = dropped_p = 0
        if cfg.compress:
            # 1. A lemma that has never fired, in any round, on any generated
            #    target, and has been resident for the whole grace period, is
            #    dead weight and is dropped.  Firing counts come only from
            #    generated targets -- the benchmark is never consulted, which
            #    is why this arrow cannot launder benchmark information into
            #    the book.  The grace period is not politeness: a lemma is
            #    mined from family F in round r and the targets of round r+1
            #    are family F', so a zero-grace rule deletes every lemma one
            #    round after installing it.
            born = {lid: rr for rr, lid, _ in self.install_log}
            keep = [l for l in self.book.lemmas
                    if self.lemma_fires.get(l.lid, 0) > 0
                    or r - born.get(l.lid, r) < cfg.lemma_grace]
            if len(keep) < len(self.book.lemmas):
                dropped_l = len(self.book.lemmas) - len(keep)
                kept = {l.lid for l in keep}
                self.dropped_lemmas.extend(
                    l.lid for l in self.book.lemmas if l.lid not in kept)
                self.book.lemmas = keep
                self._rebuild_index()
            # 2. CRYSTAL.md sec 3.2's converse: drop a probe that separates
            #    nothing the rest of the channel does not already separate.
            if len(self.channel) > 1:
                base = self._partition(terms, self.channel)
                for p in list(self.channel):
                    if len(self.channel) == 1:
                        break
                    trial = [q for q in self.channel if q != p]
                    if self._partition(terms, trial) == base:
                        self.channel = trial
                        dropped_p += 1

        # ------------------------------------------------------------- ROUTE
        frontier = self._route(seeds)
        self.frontiers.append(frontier)

        # ----------------------------------------------------------- REFLECT
        # Three residual streams, all real, and their sizes are reported so a
        # dead one is visible rather than implied:
        #   (a) conjectures the PROVE budget could not settle -- in this
        #       substrate almost always empty, because normalisation is a
        #       decision procedure here and the audit grid decides the rest;
        #   (b) collisions the proposal budget truncated away -- surviving
        #       collisions in CRYSTAL.md sec 3.2's exact sense, and the stream
        #       that actually carries load in this configuration;
        #   (c) separating points from refutations, which widen the channel.
        residual_terms: List[Term] = []
        for v in verdicts:
            if v.status in (PR.OPEN, PR.EXHAUSTED):
                cj = self.pg.conjectures[v.cid]
                residual_terms.extend([cj.lhs, cj.rhs])
        residual_terms.extend(unproposed)
        for cid, sep, a, b in self.pg.counterexamples:
            if sep not in self.channel:
                self.channel.append(sep)
        self.channel = sorted(set(self.channel))
        self.residual_seeds = residual_terms[:cfg.width * 2]

        # ------------------------------------------------------- MEASUREMENT
        bs, bw, ans = self.bench()
        b2s, b2w, _ = benchmark_cost(self.book, self.index, BENCHMARK2)

        rep = RoundReport(
            rnd=r, seeds=len(seeds), states=len(g.states), edges=len(g.edges),
            refusals=len(g.refusals), causal=cr.render(),
            colls_found=len(colls), surviving=len(unproposed) // 2,
            proposed=len(proposed_now), discharged=disch, refuted=refut,
            open_=sum(1 for v in verdicts if v.status == PR.OPEN),
            exhausted=exh, cones=len(cones), cone_facts=cone_facts,
            mined=mined, installed=installed, rejected=rejected,
            book=len(self.book.lemmas), dropped_lemmas=dropped_l,
            channel=len(self.channel), dropped_probes=dropped_p,
            frontier=len(frontier), bench_steps=bs, bench_work=bw,
            bench2_steps=b2s, bench2_work=b2w,
            bench_answer=render(ans), residuals=len(self.residual_seeds),
            gen_status=g.status)
        self.reports.append(rep)
        return rep

    # -- ROUTE -------------------------------------------------------------
    def _route(self, targets: Sequence[Term]) -> Tuple[CostVector, ...]:
        """Nondominated (steps, size, book, work) routes for the round's targets.

        Four *named* variants per target -- book/no-book crossed with
        index/scan -- measured exactly and filtered with ``execute.dominates``.
        No scalar fitness: equal-cost routes are all kept, per CRYSTAL.md L3.
        """
        vs: List[CostVector] = []
        for t in targets:
            for use_book in (False, True):
                for use_idx in (False, True):
                    lemmas = tuple(self.book.lemmas) if use_book else ()
                    idx = self.index if (use_book and use_idx) else None
                    if use_idx and idx is None and use_book:
                        continue
                    ctr = Counter()
                    try:
                        d, _ = normalize(t, lemmas=lemmas, ctr=ctr,
                                         name="route", index=idx,
                                         max_steps=self.cfg.prove_steps)
                    except Divergence:
                        continue
                    vs.append(CostVector(steps=ctr.steps, size=d.result.size,
                                         width=len(lemmas), verify=ctr.work))
        out = [v for v in vs if not any(dominates(w, v) for w in vs)]
        seen = []
        for v in sorted(out, key=lambda c: c.as_tuple()):
            if v.as_tuple() not in [s.as_tuple() for s in seen]:
                seen.append(v)
        return tuple(seen)

    @staticmethod
    def _partition(terms: Sequence[Term],
                   channel: Sequence[PR.Probe]) -> Tuple[Tuple[str, ...], ...]:
        buckets: Dict[Tuple, List[str]] = {}
        order: List[Tuple] = []
        for t in terms:
            sig = PR.signature(t, channel)
            if sig is None:
                continue
            if sig not in buckets:
                buckets[sig] = []
                order.append(sig)
            buckets[sig].append(t.addr)
        return tuple(tuple(buckets[k]) for k in order)

    # -- the whole run -----------------------------------------------------
    def run(self, rounds: Optional[int] = None) -> List[RoundReport]:
        n = rounds if rounds is not None else self.cfg.rounds
        for r in range(n):
            self.round(r)
            if self.cfg.verbose:
                print(self.reports[-1].row())
        return self.reports

    # -- audits ------------------------------------------------------------
    def audit(self) -> List[Tuple[str, bool, str]]:
        out: List[Tuple[str, bool, str]] = []
        for i, g in enumerate(self.graphs):
            ok, why = g.audit()
            out.append(("multiway round %d" % i, ok, why))
            if not ok:
                break
        ok, why = self.pg.audit()
        out.append(("proposal/accepted separation", ok, why))
        return out

    def trajectory(self, which: int = 1) -> Tuple[Tuple[int, int], ...]:
        if which == 1:
            return tuple((r.bench_steps, r.bench_work) for r in self.reports)
        return tuple((r.bench2_steps, r.bench2_work) for r in self.reports)
