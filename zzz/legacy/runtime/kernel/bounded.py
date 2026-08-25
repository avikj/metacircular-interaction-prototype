"""The bounded-search discipline, written down once.

Two enumerators in this runtime search a space that is larger than any budget
they can be given:

    ``kernel.egraph.explanation_classes``          simple *paths* in the
                                                   justification graph
    ``propagate.invalidate.justification_classes`` derivation *trees* over the
                                                   dependency graph

They quotient different objects by different canonical forms, but they are
bounded in exactly the same way, and **the same mistake was made in both**:
hitting ``max_depth`` set a global stop flag, so the first over-deep branch
ended the whole enumeration and a short proof sitting behind it was never
found.  It was fixed once in ``egraph`` and filed, unfixed, against
``invalidate``.  A defect that appears twice is a missing abstraction, so the
rule now lives here and both call it.

The rule, in four parts:

1. **A depth bound prunes a branch, never the search.**  A branch that cannot
   close inside the current limit is abandoned; its siblings are still
   explored.
2. **Prune only what provably cannot close.**  Every caller supplies an
   *admissible* lower bound on the work remaining below a node --- a
   breadth-first distance for ``egraph``, a minimum justification height for
   ``invalidate`` --- and a branch is cut when ``depth_so_far + lower_bound``
   overruns the round's limit.  Nothing that could have closed is dropped.
3. **Rounds go shortest-first.**  Iterative deepening, so when a *path* budget
   runs out what has been bought is the short answers, not the first deep ones
   the record order happened to offer.  The loop stops as soon as a round
   prunes nothing --- that round saw the whole space --- so no deepening cost
   is paid on inputs that do not need it.
4. **A bound that was hit is reported, never laundered.**  Pruning is
   incompleteness: a run that abandoned even one branch reports
   ``complete=False`` with the count in its reason, however many classes it
   found.  Truncating a branch for a *width* bound is tracked separately from
   depth pruning, because a wider round will not fix it and it must not be
   reported as a depth problem.

Nothing here is trusted: ``kernel/check.py`` imports none of it, and neither
enumerator can make anything true.  This module is pure bookkeeping over
caller-supplied search, exact integers only.
"""

from __future__ import annotations

from typing import Callable, Dict, List, Optional, Tuple

__all__ = [
    "resolve_bounds",
    "bounds_tuple",
    "SearchLedger",
    "ClassBuckets",
    "deepen",
]


# ---------------------------------------------------------------------------
# bounds
# ---------------------------------------------------------------------------

def resolve_bounds(defaults: Dict[str, int], **overrides) -> Dict[str, int]:
    """``defaults`` with the non-``None`` ``overrides`` applied.

    A bound of ``0`` means unbounded, matching both enumerators' existing
    contract; ``None`` means "use the default" and is what an unspecified
    keyword argument arrives as.
    """
    bnd = dict(defaults)
    for k, v in overrides.items():
        if v is not None:
            if k not in bnd:
                raise KeyError("unknown search bound %r" % (k,))
            bnd[k] = v
    return bnd


def bounds_tuple(bnd: Dict[str, int]) -> Tuple[Tuple[str, int], ...]:
    """The canonical, hashable form carried on the result object."""
    return tuple(sorted(bnd.items()))


# ---------------------------------------------------------------------------
# the ledger
# ---------------------------------------------------------------------------

class SearchLedger:
    """Exact counters for one bounded enumeration, and the stop reason.

    Four distinct kinds of "we did not see everything", deliberately not
    conflated:

    ``pruned``      branches abandoned in the **current** round because they
                    could not close inside its limit.  Reset by ``deepen`` at
                    the top of every round; a round that ends with ``pruned ==
                    0`` has seen the whole space and the deepening stops.
    ``deep_prunes`` the same events, accumulated over every round -- reporting
                    only, never a decision.
    ``truncated``   branches dropped for a **width** bound.  Sticky: a deeper
                    round will not recover them, so this forces
                    ``complete=False`` on its own and with its own reason.
    ``stop``        a hard stop: a global budget (recorded paths, classes) was
                    reached and the enumeration ends where it stands.

    ``explored`` and ``raw`` are the two published work counters: nodes entered
    and objects recorded.
    """

    __slots__ = ("explored", "raw", "pruned", "deep_prunes", "truncated",
                 "truncated_reason", "stop", "rounds")

    def __init__(self) -> None:
        self.explored = 0
        self.raw = 0
        self.pruned = 0
        self.deep_prunes = 0
        self.truncated = 0
        self.truncated_reason = ""
        self.stop = ""
        self.rounds = 0

    # -- events ------------------------------------------------------------
    def prune(self) -> None:
        """One branch could not close inside this round's limit."""
        self.pruned += 1
        self.deep_prunes += 1

    def truncate(self, reason: str) -> None:
        """One branch was dropped for a width bound; deepening will not fix it."""
        self.truncated += 1
        if not self.truncated_reason:
            self.truncated_reason = reason

    def hit(self, reason: str) -> None:
        """A global budget was reached.  The first reason is the one kept."""
        if not self.stop:
            self.stop = reason

    # -- verdict -----------------------------------------------------------
    @property
    def stopped(self) -> bool:
        return bool(self.stop)

    def reason(self) -> str:
        """The single string a caller reports, or ``""`` if the run was total.

        A hard stop outranks a width truncation, which outranks nothing else:
        depth pruning is turned into a reason by ``deepen`` itself, because
        only the deepening loop knows whether a later round recovered it.
        """
        if self.stop:
            return self.stop
        if self.truncated:
            return self.truncated_reason
        return ""

    @property
    def complete(self) -> bool:
        return not self.reason()


# ---------------------------------------------------------------------------
# bucketing by canonical form
# ---------------------------------------------------------------------------

class ClassBuckets:
    """Group recorded objects by canonical key, under ``max_classes``/``max_paths``.

    ``add`` is the single place where a recorded object can trip a global
    budget, and it trips it by naming it -- there is no path through this class
    that drops something silently.
    """

    __slots__ = ("_ledger", "_max_classes", "_max_paths", "_buckets", "_order")

    def __init__(self, ledger: SearchLedger, max_classes: int, max_paths: int) -> None:
        self._ledger = ledger
        self._max_classes = max_classes
        self._max_paths = max_paths
        self._buckets: Dict[Tuple, List] = {}
        self._order: List[Tuple] = []

    def add(self, key: Tuple, member) -> bool:
        """Record ``member`` under ``key``.  ``False`` iff a bound was hit."""
        self._ledger.raw += 1
        if key not in self._buckets:
            if self._max_classes and len(self._buckets) >= self._max_classes:
                self._ledger.hit("max_classes=%d reached" % self._max_classes)
                return False
            self._buckets[key] = []
            self._order.append(key)
        self._buckets[key].append(member)
        if self._max_paths and self._ledger.raw >= self._max_paths:
            self._ledger.hit("max_paths=%d reached" % self._max_paths)
            return False
        return True

    def __len__(self) -> int:
        return len(self._buckets)

    def items(self):
        """``(key, members)`` in discovery order."""
        for key in self._order:
            yield key, self._buckets[key]


# ---------------------------------------------------------------------------
# the deepening driver
# ---------------------------------------------------------------------------

def deepen(ledger: SearchLedger,
           run_round: Callable[[int], None],
           lo: int,
           hi: int,
           exhausted: Optional[Callable[[int, int], str]] = None) -> None:
    """Run ``run_round(limit)`` for ``limit = lo, lo+1, … hi``, shortest first.

    Stops early on the first round that hits a hard budget, and on the first
    round that prunes nothing -- that round explored the entire space, so every
    later round would repeat it.  If the range is exhausted while rounds are
    still pruning, ``exhausted(hi, pruned_in_the_last_round)`` names the reason
    and the enumeration reports itself incomplete.

    ``lo`` above ``hi`` is not an error: it is the case where the shallowest
    possible answer is already deeper than the bound, and it reports exactly
    that.
    """
    if exhausted is None:
        def exhausted(bound, pruned):  # pragma: no cover - callers all pass one
            return "max_depth=%d reached (%d branch(es) pruned)" % (bound, pruned)
    limit = lo
    while limit <= hi:
        ledger.pruned = 0
        ledger.rounds += 1
        run_round(limit)
        if ledger.stopped:
            return
        if ledger.pruned == 0:
            return                      # this round saw the whole space
        limit += 1
    ledger.hit(exhausted(hi, ledger.pruned))
