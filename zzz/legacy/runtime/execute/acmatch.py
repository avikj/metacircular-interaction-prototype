"""L3 -- matching modulo associativity and commutativity.

THE CEILING THIS FILE ATTACKS
-----------------------------
``runtime/vocabulary/README.md`` sec.7 located it exactly:

    B3, flat 3-ary product                     base  80  ->  book  80    fired: none
    B3, the SAME polynomial, binary grouping   base  54  ->  book  37    fired: L1

``L1`` is the mined difference-of-squares lemma, whose left side is a **binary**
product.  B3's root is a **3-ary** product.  ``crystallize.derivation`` has flat
n-ary ``Sum``/``Prod`` nodes and its only associativity rule (``flat_prod``)
splices nested products *upward*; nothing ever introduces a grouping.  So the
redex is there, the lemma is there, and ``derivation.match`` -- a positional,
one-way syntactic matcher -- cannot see one from the other.

This module lets it.  For an operator declared associative and commutative, a
pattern matches a **sub-multiset** of the arguments and the unmatched arguments
are the **residue**, which the rewrite must carry through untouched::

    pattern   mul ?a ?a
    subject   mul x y x z
    match     ?a := x        residue  y z
    rewrite   mul (rhs[?a:=x]) y z

THE SEMANTICS, STATED BEFORE THE CODE
-------------------------------------
Two AC operators only: ``PROD`` and ``SUM`` of ``crystallize.derivation``
(``AC_KINDS``).  Both are genuinely associative and commutative there -- the
argument *multiset* determines the value, which ``poly_equal`` decides.

* **At the root of the pattern** the pattern's arguments match a sub-multiset of
  the subject's arguments; the rest is the residue.
* **At every inner AC node** the match is a *bijection*: same arity, any
  permutation, no residue.  This is not a budget, it is the semantics -- an
  inner residue would make the instantiated left side a *different term* from
  the subject (``(#0+#1)`` matched against ``a+b+c`` with residue ``c`` claims
  the subject is ``a+b``, which it is not), so an inner residue is unsound for a
  rewrite, not merely expensive.
* **A pattern variable never absorbs several arguments.**  Full AC matching
  admits ``mul ?a ?b`` against ``mul x y z`` with ``?b := mul y z``; that is the
  "extension variable" case and it is **not implemented**.  See ``AC.md`` sec.5.

THE BOUND, STATED
-----------------
The core is a backtracking search for an injective assignment of ``p`` pattern
arguments to ``n`` subject arguments, with a recursive sub-match at each pair.
There are ``n!/(n-p)!`` such assignments -- at most ``n**p``, and ``n!`` when
``p = n`` -- and each is multiplied by the number of substitutions the *inner*
AC nodes yield (a binary sum matched against a binary sum yields two, the two
orders).  So AC matching is **exponential in the arity of the AC node**, on top
of e-matching's existing exponential in pattern size.  ``ACResult.top`` reports
the root candidate pairs actually examined and ``ACResult.work`` every pair at
every depth, so the bound is measured rather than asserted (``ac_demo.py``
sec.1: exactly ``n(2n-1)`` root pairs for the difference-of-squares pattern at
arities 2..8).  Four prunings, all of which remove only assignments that could
not have succeeded:

1. **arity bail** -- ``p > n`` fails before any search;
2. **head-key sub-multiset prefilter** -- every non-variable pattern argument
   demands a subject argument with the same ``(kind, val, arity)``; if those
   keys are not a sub-multiset of the subject's, no assignment exists;
3. **constants first** -- ground pattern arguments (no pattern variables) are
   assigned first, by address, so they branch not at all beyond multiplicity;
4. **repeated variables next, free variables last** -- an argument mentioning a
   variable that occurs elsewhere in the pattern is assigned before one that
   does not, so a repeated variable rejects a whole subtree instead of being
   discovered at the last position.

Ordering (3)/(4) is a *cost* decision and provably not a semantic one: the
enumeration is over all injective assignments regardless of the order they are
tried in, and the returned matches are sorted into a canonical order before
anything looks at them.

BUDGET IS NOT SEMANTICS
-----------------------
``ACResult.matches`` **raises** ``ACIncomplete`` when the search hit its bound,
exactly as ``kernel.egraph.ClassEnumeration`` does.  A partial answer is
available through ``.partial()``, in writing, and never by accident.
``ac_normalize`` refuses to *use* a partial match set: a rewrite chosen from a
subset would not be reproducible, so the step is not taken and the run's status
becomes ``ac_budget:...`` rather than ``fixpoint``.

WHAT MAKES AN AC REWRITE CHECKABLE
----------------------------------
An AC step is not an instance of any rule the substrate's checker knows, so it
cannot be recorded as one.  What this module records instead is a **derived
lemma**: the n-ary, permuted, residue-carrying instance of the base lemma.

    base      L1 :  (#0+#1)*(#0+(-1*#1))      ==>  (#0*#0) + (-1*#1*#1)
    derived   ac|L1|... :
              (#0+#1)*(#0+(-1*#1))*#2         ==>  ((#0*#0)+(-1*#1*#1))*#2

The derived lemma's left side matches the subject **syntactically**, so
``derivation.check_step`` re-derives the step with the matcher it already has --
no new checking code, and the AC search is not in the trusted path at all.  The
derived lemma itself passes five gates (:func:`derive_ac_lemma`), of which the
load-bearing two are:

* **G3** ``ac_canonical(lhs') == ac_canonical(base_lhs extended by the residue
  variables)`` -- the derived left side is an AC *rearrangement* of the base
  pattern, not an arbitrary term that happens to be true;
* **G4** ``poly_equal(lhs', rhs')`` -- the substrate's own **complete** decision
  procedure, run on the derived lemma as a statement about its variables.

and :func:`kernel_edge_for` turns any AC step into an ``Eq`` edge that
``kernel/check.py`` accepts, through ``generate.multiway.AxiomVault`` (gates A1
schema re-run + A2 ``poly_equal``) and ``check.check_edge``.  A bogus AC match
is refused there; ``runtime/tests/test_acmatch.py`` plants three of them.

Pure Python 3 stdlib, exact integers, no float, no randomness, no I/O, no
network.  Deterministic and byte-identical across ``PYTHONHASHSEED``.
"""

from __future__ import annotations

import sys
from dataclasses import dataclass, field
from typing import Dict, Iterator, List, Optional, Sequence, Tuple

from ..crystallize import derivation as D
from ..crystallize.derivation import (PROD, SUM, Counter, Derivation,
                                      Divergence, Lemma, Subst, Term,
                                      at, is_pvar, match, mk, poly_equal,
                                      positions_postorder, pvars_of, render,
                                      replace_at, subst)

__all__ = [
    "AC_KINDS",
    "ACIncomplete",
    "ACError",
    "ACBudget",
    "ACMatch",
    "ACResult",
    "ac_canonical",
    "ac_match",
    "derive_ac_lemma",
    "ACStats",
    "ac_normalize",
    "ACRun",
    "ac_enabled",
    "kernel_edge_for",
    "ac_permutation_matches",
]

# The two heads declared associative *and* commutative in this substrate.
AC_KINDS: Tuple[str, ...] = (PROD, SUM)


class ACError(Exception):
    """A malformed AC match, derived lemma, or reassembly.  Never swallowed."""


class ACIncomplete(Exception):
    """Raised when a bounded AC search's result is read as if it were total."""


# ==========================================================================
# 1.  budget, match, result
# ==========================================================================

@dataclass(frozen=True)
class ACBudget:
    """Explicit bounds.  Every one of them is reported when it bites."""

    max_assignments: int = 4096      # injective assignments tried, per call
    max_matches: int = 64            # distinct matches retained, per call
    max_grid: int = 30000            # poly_equal grid for the derived lemma

    def render(self) -> str:
        return ("assignments<=%d matches<=%d grid<=%d"
                % (self.max_assignments, self.max_matches, self.max_grid))


@dataclass(frozen=True)
class ACMatch:
    """One AC match: a substitution, a skeleton, and the residue.

    ``skeleton`` is a *pattern* over the base pattern's variables plus fresh
    ones for the residue positions, built so that ``derivation.match(skeleton,
    subject)`` returns exactly ``sigma`` extended by the residue bindings.  It
    is what makes the step checkable by the existing checker.
    """

    sigma: Tuple[Tuple[str, Term], ...]
    skeleton: Term
    residue: Tuple[Term, ...]
    residue_vars: Tuple[Term, ...]

    def key(self) -> Tuple:
        return (self.skeleton.ckey,
                tuple((k, v.ckey) for k, v in self.sigma),
                tuple(t.ckey for t in self.residue))

    def subst_map(self) -> Subst:
        out: Subst = {k: v for k, v in self.sigma}
        for var, tm in zip(self.residue_vars, self.residue):
            out[var.val] = tm
        return out


@dataclass(frozen=True)
class ACResult:
    """Matches plus exact cost and whether the answer is total.

    ``matches`` raises when the search was cut short.  ``partial()`` is the
    written-down way to look at an incomplete answer.  A cap is not a
    semantics.
    """

    _matches: Tuple[ACMatch, ...]
    work: int
    budget: ACBudget
    exhausted: bool
    reason: str = ""
    top: int = 0            # candidate pairs tried at the ROOT AC node only

    @property
    def complete(self) -> bool:
        return not self.exhausted

    @property
    def matches(self) -> Tuple[ACMatch, ...]:
        if self.exhausted:
            raise ACIncomplete(
                "AC enumeration hit %s; use .partial() if a subset will do"
                % (self.reason or "a bound",))
        return self._matches

    def partial(self) -> Tuple[ACMatch, ...]:
        """The matches found, whether or not the search was total."""
        return self._matches

    def __len__(self) -> int:
        if self.exhausted:
            raise ACIncomplete("len() of an incomplete AC enumeration")
        return len(self._matches)

    def render(self) -> str:
        return ("%d AC match(es), %d work (%d at the root), %s"
                % (len(self._matches), self.work, self.top,
                   "COMPLETE" if self.complete else "PARTIAL (%s)" % self.reason))


class _Search:
    """Mutable search state: the budget counter and its verdict."""

    __slots__ = ("work", "top", "budget", "exhausted", "reason")

    def __init__(self, budget: ACBudget) -> None:
        self.work = 0
        # ``top`` counts only the root AC node's candidate (pattern arg,
        # subject arg) pairs, so it is directly comparable to the n!/(n-p)!
        # bound; ``work`` charges every pair at every nesting depth.
        self.top = 0
        self.budget = budget
        self.exhausted = False
        self.reason = ""

    def charge(self) -> bool:
        self.work += 1
        if self.work > self.budget.max_assignments:
            self.exhausted = True
            self.reason = "max_assignments"
            return False
        return True


# ==========================================================================
# 2.  AC-canonical form -- used only as a *check*, never to rewrite
# ==========================================================================

_ACCANON: Dict[str, Term] = {}


def ac_canonical(t: Term) -> Term:
    """Sort every AC node's arguments by canonical key, recursively.

    Two terms have the same AC canonical form iff they are equal modulo
    associativity (of the already-flat nodes) and commutativity.  This is a
    *verification* device: gate G3 of :func:`derive_ac_lemma` uses it to check
    that a derived left side is an AC rearrangement of the base pattern.  No
    rewrite in this module ever returns a canonicalised term -- the substrate's
    own ``sort_prod``/``sort_sum`` steps do that, one counted step at a time.
    """
    got = _ACCANON.get(t.addr)
    if got is not None:
        return got
    if not t.args:
        out = t
    else:
        kids = [ac_canonical(a) for a in t.args]
        if t.kind in AC_KINDS:
            kids.sort(key=lambda u: u.ckey)
        out = mk(t.kind, t.val, kids)
    _ACCANON[t.addr] = out
    return out


# ==========================================================================
# 3.  the matcher
# ==========================================================================

def _head_key(t: Term) -> Optional[Tuple]:
    """What a syntactic match demands at a non-variable node.

    ``None`` for a pattern variable: it constrains nothing.
    """
    if is_pvar(t):
        return None
    return (t.kind, t.val, len(t.args))


_PATKEYS: Dict[str, Tuple[Tuple, ...]] = {}


def _required_keys(pargs: Sequence[Term]) -> Tuple[Tuple, ...]:
    """The non-wildcard head keys the pattern's arguments demand, sorted."""
    return tuple(sorted(k for k in (_head_key(p) for p in pargs)
                        if k is not None))


def _prefilter(pargs: Sequence[Term], targs: Sequence[Term]) -> bool:
    """Necessary condition for an injective assignment to exist.

    Every non-variable pattern argument needs a subject argument with the same
    head key, and no two pattern arguments may share one.  So the multiset of
    required keys must be a sub-multiset of the available keys.  Cheap, and it
    removes only assignments that could not have succeeded.
    """
    need: Dict[Tuple, int] = {}
    for p in pargs:
        k = _head_key(p)
        if k is not None:
            need[k] = need.get(k, 0) + 1
    if not need:
        return True
    have: Dict[Tuple, int] = {}
    for t in targs:
        k = _head_key(t)
        have[k] = have.get(k, 0) + 1
    for k, n in need.items():
        if have.get(k, 0) < n:
            return False
    return True


def _priority(pargs: Sequence[Term]) -> Tuple[int, ...]:
    """The order the pattern's arguments are assigned in.

    Constants (ground) first, then arguments mentioning a variable that occurs
    more than once in the whole argument list, then the rest.  Ties break on
    the original index, so the order is a pure function of the pattern.
    """
    counts: Dict[str, int] = {}
    per: List[Tuple[str, ...]] = []
    for p in pargs:
        vs = tuple(v.val for v in pvars_of(p))
        per.append(vs)
        for v in vs:
            counts[v] = counts.get(v, 0) + 1
    ranked: List[Tuple[int, int, int]] = []
    for i, vs in enumerate(per):
        if not vs:
            band = 0                                  # ground
        elif any(counts[v] > 1 for v in vs):
            band = 1                                  # repeated variable
        else:
            band = 2                                  # free variables only
        ranked.append((band, -len(pargs[i].args), i))
    ranked.sort()
    return tuple(i for _, _, i in ranked)


def _sub_match(p: Term, t: Term, sigma: Subst, st: _Search
               ) -> Iterator[Tuple[Subst, Term]]:
    """Match ``p`` against the *whole* of ``t`` -- no residue at this level.

    Yields ``(sigma, skeleton)`` pairs.  ``skeleton`` is a pattern for which the
    substrate's own positional ``match`` reproduces exactly these bindings, so
    it is the object the checker will re-run.
    """
    if is_pvar(p):
        bound = sigma.get(p.val)
        if bound is None:
            nxt = dict(sigma)
            nxt[p.val] = t
            yield (nxt, p)
        elif bound.addr == t.addr:
            yield (sigma, p)
        return
    if p.kind != t.kind or p.val != t.val or len(p.args) != len(t.args):
        return
    if not p.args:
        yield (sigma, p)
        return
    if p.kind in AC_KINDS:
        if not _prefilter(p.args, t.args):
            return
        for sig, assign, skels in _assign(p.args, t.args, sigma, st,
                                          residue=False):
            kids: List[Term] = [t.args[0]] * len(t.args)
            for pi, ti in enumerate(assign):
                kids[ti] = skels[pi]
            yield (sig, mk(p.kind, p.val, kids))
        return
    # non-AC compound: positional, left to right
    frontier: List[Tuple[Subst, Tuple[Term, ...]]] = [(sigma, ())]
    for i in range(len(p.args)):
        nxt: List[Tuple[Subst, Tuple[Term, ...]]] = []
        for sig, skels in frontier:
            for sig2, sk in _sub_match(p.args[i], t.args[i], sig, st):
                nxt.append((sig2, skels + (sk,)))
        frontier = nxt
        if not frontier:
            return
    for sig, skels in frontier:
        yield (sig, mk(p.kind, p.val, skels))


def _assign(pargs: Sequence[Term], targs: Sequence[Term], sigma: Subst,
            st: _Search, residue: bool, count_top: bool = False
            ) -> Iterator[Tuple[Subst, Tuple[int, ...], Tuple[Term, ...]]]:
    """Injective assignments of pattern arguments to subject argument indices.

    ``residue=False`` demands a bijection (equal arities).  Yields
    ``(sigma, assign, skeletons)`` where ``assign[i]`` is the subject index
    taken by ``pargs[i]`` and ``skeletons[i]`` is the pattern that reproduces
    that sub-match syntactically.  Both are snapshots, so a consumer may hold
    them while the search continues.
    """
    n, p = len(targs), len(pargs)
    if p > n:
        return
    if not residue and p != n:
        return
    order = _priority(pargs)
    slot: List[int] = [-1] * p
    skel: List[Optional[Term]] = [None] * p
    used = [False] * n

    def go(k: int, sig: Subst):
        if k == len(order):
            yield (sig, tuple(slot), tuple(skel))  # type: ignore[arg-type]
            return
        pi = order[k]
        for ti in range(n):
            if used[ti]:
                continue
            if count_top:
                st.top += 1
            if not st.charge():
                return
            for sig2, sk in _sub_match(pargs[pi], targs[ti], sig, st):
                used[ti] = True
                slot[pi] = ti
                skel[pi] = sk
                for out in go(k + 1, sig2):
                    yield out
                used[ti] = False
                slot[pi] = -1
                skel[pi] = None
                if st.exhausted:
                    return
            if st.exhausted:
                return

    for out in go(0, sigma):
        yield out


def _next_free_index(*terms: Term) -> int:
    top = -1
    for t in terms:
        for v in pvars_of(t):
            top = max(top, int(v.val[len(D.PVAR_PREFIX):]))
    return top + 1


def ac_match(pattern: Term, subject: Term, budget: ACBudget = ACBudget(),
             rhs: Optional[Term] = None) -> ACResult:
    """All AC matches of ``pattern`` against ``subject``, bounded and sorted.

    ``rhs`` is only used to choose fresh residue-variable indices that cannot
    collide with the lemma's own; pass the lemma's right side when there is one.
    """
    st = _Search(budget)
    if pattern.kind not in AC_KINDS or subject.kind != pattern.kind:
        # No AC head at the root: the ordinary matcher is already complete.
        sig = match(pattern, subject)
        st.work += 1
        found = () if sig is None else (
            ACMatch(sigma=tuple(sorted(sig.items())), skeleton=pattern,
                    residue=(), residue_vars=()),)
        return ACResult(_matches=found, work=st.work, budget=budget,
                        exhausted=False, top=0)

    pargs, targs = pattern.args, subject.args
    if len(pargs) > len(targs) or not _prefilter(pargs, targs):
        return ACResult(_matches=(), work=1, budget=budget, exhausted=False,
                        top=0)

    base = _next_free_index(pattern, rhs if rhs is not None else pattern)
    out: Dict[Tuple, ACMatch] = {}
    for sig, assign, sub_skels in _assign(pargs, targs, {}, st, residue=True,
                                          count_top=True):
        skels: List[Term] = [targs[0]] * len(targs)
        for pi, ti in enumerate(assign):
            skels[ti] = sub_skels[pi]
        taken = set(assign)
        residue_idx = tuple(i for i in range(len(targs)) if i not in taken)
        rvars = tuple(D.PV(base + j) for j in range(len(residue_idx)))
        for j, i in enumerate(residue_idx):
            skels[i] = rvars[j]
        m = ACMatch(sigma=tuple(sorted(sig.items())),
                    skeleton=mk(pattern.kind, pattern.val, skels),
                    residue=tuple(targs[i] for i in residue_idx),
                    residue_vars=rvars)
        k = m.key()
        if k not in out:
            out[k] = m
            if len(out) > budget.max_matches:
                st.exhausted = True
                st.reason = "max_matches"
                break
        if st.exhausted:
            break
    ordered = tuple(sorted(out.values(), key=lambda m: m.key()))
    if st.exhausted and st.reason == "max_matches":
        ordered = ordered[:budget.max_matches]
    return ACResult(_matches=ordered, work=st.work, budget=budget,
                    exhausted=st.exhausted, reason=st.reason, top=st.top)


# ==========================================================================
# 4.  the derived lemma -- what makes an AC step checkable
# ==========================================================================

_DERIVED: Dict[Tuple[str, str], Lemma] = {}
_DERIVED_REFUSED: List[str] = []


def derive_ac_lemma(base: Lemma, m: ACMatch,
                    budget: ACBudget = ACBudget()) -> Lemma:
    """The n-ary, permuted, residue-carrying instance of ``base``, gated.

    Five gates, all-or-nothing.  A refusal raises; there is no partial
    installation and no unchecked path.

    G1  the skeleton is a term of the AC head, of the subject's arity;
    G2  the residue variables are fresh and occur exactly once each;
    G3  ``ac_canonical(lhs') == ac_canonical(base.lhs extended by the residue
        variables)`` -- the derived left side is an AC **rearrangement** of the
        base pattern, not an arbitrary true statement;
    G4  ``poly_equal(lhs', rhs')`` -- the substrate's complete decision
        procedure, applied to the derived lemma as a statement about its
        variables;
    G5  every residue variable of the left side occurs in the right side --
        the check that a residue cannot be dropped during reassembly.
    """
    key = (base.lid, m.skeleton.addr)
    got = _DERIVED.get(key)
    if got is not None:
        return got

    lhs = m.skeleton
    rvars = m.residue_vars
    if lhs.kind not in AC_KINDS:
        raise ACError("G1: derived left side is not an AC head: %s" % render(lhs))
    if len(lhs.args) < len(base.lhs.args):
        raise ACError("G1: derived left side has fewer arguments than the base")
    # G2
    seen = {v.val for v in pvars_of(base.lhs)} | {v.val for v in pvars_of(base.rhs)}
    for v in rvars:
        if v.val in seen:
            raise ACError("G2: residue variable %s collides with the lemma's own"
                          % v.val)
        if sum(1 for u in lhs.args if u.addr == v.addr) != 1:
            raise ACError("G2: residue variable %s does not occur exactly once"
                          % v.val)
    rhs = base.rhs if not rvars else mk(lhs.kind, None, (base.rhs,) + rvars)
    # G3
    extended = mk(base.lhs.kind, base.lhs.val, tuple(base.lhs.args) + rvars)
    if ac_canonical(lhs).addr != ac_canonical(extended).addr:
        _DERIVED_REFUSED.append("G3 %s" % render(lhs))
        raise ACError("G3: %s is not an AC rearrangement of %s"
                      % (render(lhs), render(extended)))
    # G4
    try:
        same = poly_equal(lhs, rhs, max_grid=budget.max_grid)
    except ValueError as exc:
        _DERIVED_REFUSED.append("G4 grid %s" % render(lhs))
        raise ACError("G4: semantic decision unavailable: %s" % exc)
    if not same:
        _DERIVED_REFUSED.append("G4 %s" % render(lhs))
        raise ACError("G4: %s and %s are different polynomials"
                      % (render(lhs), render(rhs)))
    # G5
    rhs_vars = {v.val for v in pvars_of(rhs)}
    for v in rvars:
        if v.val not in rhs_vars:
            raise ACError("G5: residue variable %s is dropped by the right side"
                          % v.val)
    lid = "ac|%s|%s" % (base.lid, lhs.addr[:12])
    lem = Lemma(lid, lhs, rhs, proof_rules=base.proof_rules,
                provenance="AC instance of %s (%d-ary, %d residue)"
                           % (base.lid, len(lhs.args), len(rvars)))
    _DERIVED[key] = lem
    return lem


def derived_lemmas() -> Dict[str, Lemma]:
    """Every AC-derived lemma built so far, by id.  Deterministic order."""
    return {lem.lid: lem for _, lem in sorted(_DERIVED.items())}


# ==========================================================================
# 5.  AC normalisation -- the same engine, with AC lemma matching
# ==========================================================================

@dataclass
class ACStats:
    """Exact counters for what AC matching did and what it cost."""

    ac_attempts: int = 0          # (position, lemma) pairs AC was tried on
    ac_prefiltered: int = 0       # rejected by the head-key prefilter
    ac_hits: int = 0              # AC matches that produced a step
    ac_residue_hits: int = 0      # ...of which carried a non-empty residue
    ac_work: int = 0              # assignments charged inside the matcher
    ac_exhausted: int = 0         # searches that hit a bound
    derive_refused: int = 0       # AC matches whose derived lemma failed a gate
    memo_hits: int = 0
    fired: Dict[str, int] = field(default_factory=dict)

    def bump(self, lid: str) -> None:
        self.fired[lid] = self.fired.get(lid, 0) + 1

    def merge(self, other: "ACStats") -> None:
        self.ac_attempts += other.ac_attempts
        self.ac_prefiltered += other.ac_prefiltered
        self.ac_hits += other.ac_hits
        self.ac_residue_hits += other.ac_residue_hits
        self.ac_work += other.ac_work
        self.ac_exhausted += other.ac_exhausted
        self.derive_refused += other.derive_refused
        self.memo_hits += other.memo_hits
        for k, v in sorted(other.fired.items()):
            self.fired[k] = self.fired.get(k, 0) + v

    def render(self) -> str:
        return ("attempts=%d prefiltered=%d hits=%d (residue %d) work=%d "
                "exhausted=%d refused=%d memo=%d"
                % (self.ac_attempts, self.ac_prefiltered, self.ac_hits,
                   self.ac_residue_hits, self.ac_work, self.ac_exhausted,
                   self.derive_refused, self.memo_hits))


class ACRun:
    """The AC substrate's live state: budget, registry, counters, verdict.

    One of these is active at a time (``ac_enabled``).  It owns the derived
    lemma registry that ``check_derivation`` must be given, and it records
    every budget exhaustion so that a run which gave up cannot be reported as
    a fixpoint.
    """

    __slots__ = ("budget", "stats", "lemmas", "exhaustions", "memo")

    def __init__(self, budget: ACBudget = ACBudget()) -> None:
        self.budget = budget
        self.stats = ACStats()
        self.lemmas: Dict[str, Lemma] = {}
        self.exhaustions: List[str] = []
        self.memo: Dict[Tuple[str, str], Optional[Tuple[ACMatch, Lemma]]] = {}

    @property
    def complete(self) -> bool:
        """False as soon as any AC search anywhere gave up."""
        return not self.exhaustions

    def status(self) -> str:
        return "fixpoint" if self.complete else ("ac_budget:%s"
                                                 % self.exhaustions[0])

    def table(self) -> Dict[str, Lemma]:
        return dict(self.lemmas)


_RUN: Optional[ACRun] = None


def current_run() -> Optional[ACRun]:
    return _RUN


def _ac_try(node: Term, lem: Lemma, run: ACRun, ctr: Counter
            ) -> Optional[Tuple[ACMatch, Lemma]]:
    """One AC attempt of ``lem`` at ``node``.  ``None`` if it does not fire.

    Memoised on ``(lemma id, node address)``.  Terms are hash-consed and the
    lemma is immutable, so this is a pure-function cache: it can change the
    cost, never the result.  A memo hit still costs one counted work unit, so
    the cache does not hide from the ``work`` column.
    """
    mk_key = (lem.lid, node.addr)
    if mk_key in run.memo:
        run.stats.memo_hits += 1
        ctr.effort()
        return run.memo[mk_key]
    run.stats.ac_attempts += 1
    ctr.effort()
    if (lem.lhs.kind not in AC_KINDS or node.kind != lem.lhs.kind
            or len(lem.lhs.args) > len(node.args)
            or not _prefilter(lem.lhs.args, node.args)):
        run.stats.ac_prefiltered += 1
        run.memo[mk_key] = None
        return None
    res = ac_match(lem.lhs, node, run.budget, rhs=lem.rhs)
    run.stats.ac_work += res.work
    ctr.effort(res.work)
    if res.exhausted:
        run.stats.ac_exhausted += 1
        run.exhaustions.append("%s at %s (%s)" % (lem.lid, node.addr[:8],
                                                  res.reason))
        # A partial match set is not a semantics: do not rewrite from it.
        run.memo[mk_key] = None
        return None
    got = res.matches
    out: Optional[Tuple[ACMatch, Lemma]] = None
    for m in got:                      # already in canonical order
        if not m.residue and m.skeleton.addr == lem.lhs.addr:
            out = (m, lem)             # the ordinary syntactic match
            break
        try:
            out = (m, derive_ac_lemma(lem, m, run.budget))
        except ACError:
            run.stats.derive_refused += 1
            continue
        run.stats.ac_hits += 1
        if m.residue:
            run.stats.ac_residue_hits += 1
        break
    run.memo[mk_key] = out
    return out


def _try_lemmas_ac(t: Term, lemmas: Sequence[Lemma], run: ACRun, ctr: Counter):
    """``derivation._try_lemmas`` with an AC attempt behind each failed match.

    Same traversal (innermost-leftmost), same lemma priority, same first hit.
    The syntactic matcher is tried first at every pair, so wherever the base
    engine fires the AC engine fires identically and with the same lemma; AC
    only ever *adds* a firing where the base engine found none.
    """
    for p in positions_postorder(t):
        node = at(t, p)
        for lem in lemmas:
            ctr.effort()
            sigma = match(lem.lhs, node)
            if sigma is not None:
                return (p, node, subst(lem.rhs, sigma), lem)
            got = _ac_try(node, lem, run, ctr)
            if got is not None:
                m, derived = got
                sig = m.subst_map()
                return (p, node, subst(derived.rhs, sig), derived)
    return None


MAX_STEPS = D.MAX_STEPS


def ac_normalize(start: Term, lemmas: Sequence[Lemma] = (),
                 ctr: Optional[Counter] = None, name: str = "derivation",
                 max_steps: int = MAX_STEPS,
                 use_index: bool = False,
                 index: Optional[object] = None,
                 run: Optional[ACRun] = None) -> Tuple[Derivation, Counter]:
    """``derivation.normalize`` with AC lemma matching.

    Identical in every other respect: same rule priority, same
    innermost-leftmost redex selection, lemmas before primitives, same cycle
    guard, same step cap.  With ``lemmas=()`` it *is* ``normalize`` -- AC
    matching touches only the lemma search, never a primitive rule.

    ``index`` is accepted and ignored: the discrimination net's probes are
    positional and a positional filter is unsound modulo AC (it would drop a
    lemma whose redex is present at a permuted position).  Refusing to use it
    is the sound choice and the cost of it is in ``AC.md`` sec.4.
    """
    if ctr is None:
        ctr = Counter()
    if run is None:
        run = _RUN if _RUN is not None else ACRun()
    d = Derivation(name, start)
    cur = start
    seen = {start.addr}
    while True:
        if len(d) >= max_steps:
            raise Divergence("step cap %d exceeded on %s" % (max_steps, name))
        hit = _try_lemmas_ac(cur, lemmas, run, ctr) if lemmas else None
        if hit is not None:
            p, redex, contractum, lem = hit
            rule, lid = "lemma:" + lem.lid, lem.lid
            if lid not in run.lemmas:
                run.lemmas[lid] = lem
            run.stats.bump(lid)
        else:
            hit = D._try_primitive(cur, ctr)
            if hit is None:
                break
            p, redex, contractum, rule = hit
            lid = None
        nxt = replace_at(cur, p, contractum)
        if nxt.addr in seen:
            raise Divergence(
                "cycle at step %d of %s (rule %s)" % (len(d), name, rule))
        seen.add(nxt.addr)
        d.record(rule, p, redex, contractum, cur, nxt, lid)
        ctr.tick()
        cur = nxt
    return d, ctr


# ==========================================================================
# 6.  enabling AC across the lanes that call ``normalize``
# ==========================================================================
#
# ``crystallize.derivation.normalize`` and ``check_derivation`` are imported by
# name into five other modules, so switching substrate means rebinding the name
# wherever it was bound.  ``vocabulary/README.md`` sec.4 does the same thing to
# ``generate.loop.constructions`` and states it as a rebinding rather than a
# supported extension point; this is that, one layer down, and it is restored
# in a ``finally``.
#
# ``check_derivation`` is rebound only to *supply the lemma book*: the wrapper
# hands the unmodified checker the caller's lemmas **plus** the AC-derived
# lemmas the run built, each of which passed the five gates of
# ``derive_ac_lemma`` and can be re-checked independently by
# ``kernel_edge_for``.  Nothing about the checking is weakened -- a derived
# lemma whose left side does not match the recorded redex is refused by
# ``check_step`` exactly as any other lemma is, and the suite plants that.

_TARGET_NAMES = ("normalize", "check_derivation")


def _modules_binding(name: str, value) -> List[str]:
    out = []
    for mod_name in sorted(sys.modules):
        if not mod_name.startswith("runtime."):
            continue
        mod = sys.modules.get(mod_name)
        if mod is None:
            continue
        if getattr(mod, name, None) is value:
            out.append(mod_name)
    return out


class _ACEnabled:
    def __init__(self, budget: ACBudget, run: Optional[ACRun]) -> None:
        self.run = run if run is not None else ACRun(budget)
        self._saved: List[Tuple[str, str, object]] = []

    def __enter__(self) -> ACRun:
        global _RUN
        if _RUN is not None:
            raise ACError("AC is already enabled; nesting is refused")
        run = self.run
        orig_norm = D.normalize
        orig_check = D.check_derivation

        def ac_norm(start, lemmas=(), ctr=None, name="derivation",
                    max_steps=D.MAX_STEPS, use_index=False, index=None):
            return ac_normalize(start, lemmas, ctr, name, max_steps,
                                use_index, index, run)

        def ac_check(d, lemmas=None, ctr=None):
            table = dict(lemmas or {})
            table.update(run.lemmas)
            return orig_check(d, table, ctr)

        for name, repl, orig in (("normalize", ac_norm, orig_norm),
                                 ("check_derivation", ac_check, orig_check)):
            for mod_name in _modules_binding(name, orig):
                self._saved.append((mod_name, name, orig))
                setattr(sys.modules[mod_name], name, repl)
        _RUN = run
        return run

    def __exit__(self, *exc) -> bool:
        global _RUN
        for mod_name, name, orig in reversed(self._saved):
            setattr(sys.modules[mod_name], name, orig)
        self._saved = []
        _RUN = None
        return False


def ac_enabled(budget: ACBudget = ACBudget(),
               run: Optional[ACRun] = None) -> _ACEnabled:
    """Context manager: run the ring lanes on the AC substrate.

    Default is *off*.  Nothing in the runtime enters this context on its own,
    so every number published against the non-AC substrate is reproduced
    unchanged by every existing demo and suite.
    """
    return _ACEnabled(budget, run)


# ==========================================================================
# 7.  the kernel justification -- an Eq edge check.py accepts
# ==========================================================================

def kernel_edge_for(redex: Term, contractum: Term, derived: Lemma,
                    vault=None):
    """Turn one AC rewrite into an ``Eq`` edge the kernel checker accepts.

    Routed through ``generate.multiway.AxiomVault``, which is the only door
    into ``CheckContext.axioms`` in this lane and which applies its own two
    gates before declaring anything:

      A1  re-run the schema -- ``derivation.match(derived.lhs, redex)`` must
          succeed and ``subst(derived.rhs, sigma)`` must be the recorded
          contractum;
      A2  ``poly_equal(redex, contractum)`` -- an independent, complete
          semantic decision.

    Returns ``(edge, vault)`` on success.  Returns ``(None, vault)`` after
    recording a refusal -- there is no path here that returns an unchecked
    edge, which is what the planted-false controls in the suite exercise.
    """
    from ..generate.multiway import AxiomVault, encode
    from ..kernel import check as C
    from ..kernel.edges import Edge

    if vault is None:
        vault = AxiomVault()
    name = vault.declare("ac:" + derived.lid, redex, contractum, lemma=derived)
    if name is None:
        return (None, vault)
    base = (C.Step(src=encode(redex).addr, dst=encode(contractum).addr,
                   kind="assumption", witness=C.Axiom(name)),)
    edge = Edge(kind="Eq", src=encode(redex).addr, dst=encode(contractum).addr,
                witness=base, label="ac:%s" % derived.lid)
    if not C.check_edge(edge, vault.ctx):
        return (None, vault)
    return (edge, vault)


def kernel_check_derivation(d: Derivation, run: ACRun, vault=None):
    """Every AC step of ``d`` as a kernel-checked ``Eq`` edge.

    Returns ``(edges, refused, vault)``.  ``refused`` is a list of step indices
    the kernel would not accept -- it must be empty for the derivation to
    count.
    """
    edges = []
    refused: List[int] = []
    for st in d.steps:
        if st.lemma_id is None or not st.lemma_id.startswith("ac|"):
            continue
        lem = run.lemmas.get(st.lemma_id)
        if lem is None:
            refused.append(st.index)
            continue
        edge, vault = kernel_edge_for(st.redex, st.contractum, lem, vault)
        if edge is None:
            refused.append(st.index)
        else:
            edges.append((st.index, edge))
    return (edges, refused, vault)


# ==========================================================================
# 8.  the additive hook for ``execute/ematch.py`` (kernel terms)
# ==========================================================================
#
# The kernel IR has no flat n-ary product: ``mul a b`` is ``App(App(mul,a),b)``,
# so an AC head there is a *binary curried constant* and "the arguments" means
# the leaves of a maximal spine of that constant.  Only the residue-free case is
# exposed through this hook -- ``EMatch`` has nowhere to put a residue, and a
# match whose residue has no home is exactly the AC rewriting bug this module
# exists to avoid.  See ``AC.md`` sec.6.

def _flatten_kernel(t, symbol: str) -> Tuple:
    """Leaves of the maximal ``symbol`` spine of ``t``, left to right."""
    from ..kernel import term as T
    if t.head != T.APP:
        return (t,)
    fn, arg = t.children
    if fn.head == T.APP:
        g, a0 = fn.children
        if g.head == T.CONST and g.symbol == symbol:
            return _flatten_kernel(a0, symbol) + _flatten_kernel(arg, symbol)
    return (t,)


def ac_permutation_matches(pattern, subject, variables, symbol: str,
                           budget: ACBudget = ACBudget()) -> Tuple[Dict, ...]:
    """Substitutions matching ``pattern`` against ``subject`` modulo AC of
    ``symbol``, **bijectively** (no residue), over kernel terms.

    Returns a deterministic tuple of substitutions (symbol -> kernel term).
    Empty when the arities differ -- that is the residue case, which this hook
    does not represent.
    """
    from ..kernel import term as T
    vs = frozenset(variables)
    pargs = _flatten_kernel(pattern, symbol)
    targs = _flatten_kernel(subject, symbol)
    if len(pargs) < 2 or len(pargs) != len(targs):
        return ()
    from .rewrite import match as krmatch
    n = len(pargs)
    out: Dict[Tuple, Dict] = {}
    used = [False] * n
    st = _Search(budget)

    def go(i: int, sigma: Dict) -> None:
        if st.exhausted:
            return
        if i == n:
            key = tuple(sorted((k, v.addr) for k, v in sigma.items()))
            out.setdefault(key, dict(sigma))
            return
        for j in range(n):
            if used[j] or st.exhausted:
                continue
            if not st.charge():
                return
            got = krmatch(pargs[i], targs[j], vs, sigma)
            if got is None:
                continue
            used[j] = True
            go(i + 1, got)
            used[j] = False

    go(0, {})
    return tuple(out[k] for k in sorted(out))
