"""Mining repeated sub-DAGs *across different derivations*.

WHAT IS MINED
-------------
A **segment** of a derivation is a contiguous run of steps ``[i..j]`` all of
whose rewrite positions lie under one common position ``p``.  Because nothing
outside ``p`` is touched, the segment is itself a complete derivation of the
subterm at ``p``::

    u  =  before_i | p        --steps i..j-->        v  =  after_j | p

Its **shape key** is the sequence of ``(rule name, position relative to p)``
pairs.  Two segments with the same shape key are the same sub-DAG applied to
different data: same rules, same order, same relative geometry.  That is the
"repeated sub-DAG" of CRYSTAL.md sec 3.1 step 2, and the key is what makes the
search a hash-join instead of a subgraph-isomorphism problem.

HONEST COMPLEXITY
-----------------
Enumerating *all* sub-DAGs of a derivation DAG is exponential -- there are
``2^L`` subsets of steps and even restricting to connected ones does not
help.  Exact-but-exponential is unacceptable here, so the search is bounded
by a stated heuristic:

  **Bounding heuristic: contiguity + a window.**  Only contiguous runs of at
  most ``window`` steps are considered.

  *Cost.*  A derivation of ``L`` steps yields at most ``L * window``
  segments.  Each segment's key extends the previous one's by one pair, so
  keys are built incrementally in ``O(1)`` amortised, but the common-position
  recomputation and the key tuple cost ``O(window)``, giving
  ``O(L * window^2)`` per derivation and ``O(D * L * window^2)`` overall for
  ``D`` derivations, plus ``O(total segments)`` hashing.  With the demo's
  ``D=3, L<=19, window=24`` that is a few thousand operations -- and it is
  polynomial for any input, which is the point.

  *What the heuristic gives up.*  Sub-DAGs whose steps are interleaved with
  unrelated steps are invisible, as are repetitions longer than ``window``.
  Both are real losses.  They are the price of a polynomial bound, and the
  demo reports the mining cost so the price is visible.  A normalising
  strategy that keeps related work contiguous (ours is innermost-leftmost,
  which does) makes the loss small in practice; that is a property of the
  strategy, not a theorem about the miner.

Counting: every segment considered and every key comparison is charged to
``Counter.work``, so the mining cost cannot hide.
"""

from __future__ import annotations

from typing import Dict, List, Optional, Sequence, Tuple

from .antiunify import Generalizer, antiunify_tuples, recover
from .derivation import (Counter, Derivation, Position, Term, at,
                         common_prefix, render)

DEFAULT_WINDOW = 24
DEFAULT_MIN_LEN = 3
DEFAULT_MIN_SUPPORT = 2

ShapeKey = Tuple[Tuple[str, Tuple[int, ...]], ...]


class Segment:
    """A contiguous, position-confined sub-derivation ``u --> v``."""

    __slots__ = ("deriv", "i", "j", "pos", "u", "v", "key")

    def __init__(self, deriv: Derivation, i: int, j: int, pos: Position,
                 u: Term, v: Term, key: ShapeKey):
        self.deriv = deriv
        self.i = i
        self.j = j
        self.pos = pos
        self.u = u
        self.v = v
        self.key = key

    @property
    def length(self) -> int:
        return self.j - self.i + 1

    def __repr__(self):
        return "Segment(%s[%d..%d]@%s: %s -> %s)" % (
            self.deriv.name, self.i, self.j, list(self.pos),
            render(self.u), render(self.v))


def segments(d: Derivation, window: int = DEFAULT_WINDOW,
             min_len: int = DEFAULT_MIN_LEN,
             ctr: Optional[Counter] = None) -> List[Segment]:
    """All contiguous position-confined segments of ``d`` up to ``window``."""
    out: List[Segment] = []
    n = len(d)
    for i in range(n):
        for j in range(i, min(n, i + window)):
            if ctr is not None:
                ctr.effort()
            span = [d.steps[k].pos for k in range(i, j + 1)]
            p = common_prefix(span)
            if j - i + 1 < min_len:
                continue
            key: ShapeKey = tuple(
                (d.steps[k].rule, d.steps[k].pos[len(p):])
                for k in range(i, j + 1))
            u = at(d.steps[i].before, p)
            v = at(d.steps[j].after, p)
            if u.addr == v.addr:
                continue
            out.append(Segment(d, i, j, p, u, v, key))
    return out


class Candidate:
    """A repeated sub-DAG plus its least general generalisation.

    ``lhs``/``rhs`` are *proposed* -- nothing here is checked.  Checking is
    :mod:`install`'s job, and it rejects candidates routinely (see the
    over-general control in the tests).
    """

    __slots__ = ("key", "instances", "lhs", "rhs", "gen", "support")

    def __init__(self, key: ShapeKey, instances: List[Segment], lhs: Term,
                 rhs: Term, gen: Generalizer):
        self.key = key
        self.instances = instances
        self.lhs = lhs
        self.rhs = rhs
        self.gen = gen
        self.support = len({s.deriv.name for s in instances})

    @property
    def saved_steps(self) -> int:
        """Steps a single application replaces: the segment length minus one."""
        return self.instances[0].length - 1

    @property
    def rule_names(self) -> Tuple[str, ...]:
        return tuple(r for r, _ in self.key)

    def __repr__(self):
        return "Candidate(support=%d, len=%d, %s ==> %s)" % (
            self.support, self.instances[0].length, render(self.lhs),
            render(self.rhs))


def mine(derivations: Sequence[Derivation], window: int = DEFAULT_WINDOW,
         min_len: int = DEFAULT_MIN_LEN,
         min_support: int = DEFAULT_MIN_SUPPORT,
         ctr: Optional[Counter] = None) -> List[Candidate]:
    """Find sub-DAGs repeated across **distinct** derivations and generalise them.

    Support is counted in *derivations*, never in occurrences: a pattern that
    repeats ten times inside one derivation has support 1 and is not mined.
    CRYSTAL.md sec 3.1 says "across different derivations" and that is a
    substantive restriction -- self-repetition inside one problem is a loop,
    not a lemma.
    """
    buckets: Dict[ShapeKey, List[Segment]] = {}
    for d in derivations:
        for seg in segments(d, window=window, min_len=min_len, ctr=ctr):
            buckets.setdefault(seg.key, []).append(seg)

    cands: List[Candidate] = []
    for key, segs in buckets.items():
        # one representative instance per derivation, first occurrence wins
        by_deriv: Dict[str, Segment] = {}
        for s in segs:
            by_deriv.setdefault(s.deriv.name, s)
        if len(by_deriv) < min_support:
            continue
        insts = [by_deriv[k] for k in sorted(by_deriv)]
        if ctr is not None:
            ctr.effort(len(insts))
        rows = [(s.u, s.v) for s in insts]
        (lhs, rhs), g = antiunify_tuples(rows)
        cands.append(Candidate(key, insts, lhs, rhs, g))

    # Deterministic ranking: most steps saved, then widest support, then a
    # stable syntactic tiebreak.  No scores, no floats.
    cands.sort(key=lambda c: (-c.saved_steps, -c.support, c.lhs.ckey,
                              c.rhs.ckey))
    return cands


def reconstruction_ok(c: Candidate) -> bool:
    """Every mined instance must be recoverable from the generalisation.

    This is the cheap necessary condition (it catches a mis-aligned variable
    map); it is *not* sufficient, and is not the lemma check.
    """
    for idx, seg in enumerate(c.instances):
        if recover(c.lhs, idx, c.gen).addr != seg.u.addr:
            return False
        if recover(c.rhs, idx, c.gen).addr != seg.v.addr:
            return False
    return True


__all__ = ["Segment", "Candidate", "segments", "mine", "reconstruction_ok",
           "DEFAULT_WINDOW", "DEFAULT_MIN_LEN", "DEFAULT_MIN_SUPPORT"]
