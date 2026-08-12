"""Pāṇinian rule-conflict resolution, made executable over a rewrite system.

`runtime/execute/README.md` states the gap this module addresses: the L3
rewriting layer has **no principled theory of which rule wins** when several
apply.  It relies on saturation (apply everything, keep every consequence) plus
Pareto extraction.  That is sound, and it is silent about *strategy*.

The Aṣṭādhyāyī has a developed metatheory of exactly this.  Four principles,
which the commentarial tradition ranks in increasing strength (Kiparsky 2009,
example (152); see `notes/IMPORTED_MACHINERY.md` for the fetched citation):

    (a) para       — rule A supersedes B if A follows B in the grammar
    (b) nitya      — A supersedes B if A is applicable whether or not B applies
    (c) antaraṅga  — A supersedes B if A is conditioned internally to B
    (d) apavāda    — A supersedes B if A's inputs are a proper subset of B's

with (d) strongest and (a) weakest.  This module implements all four as exact
predicates over candidate rewrite applications, ranks them in that order, and
puts the resulting policy in a measured contest against ordinary strategies.

Scope and honesty about the mapping
-----------------------------------
This is a **first-order term rewriting system**, not Pāṇini's grammar.  Three
places where the analogy is imperfect are enforced in the code rather than
argued in prose:

* `apavada` is restricted to candidates at the *same position*.  Pāṇinian
  blocking is a relation between rules competing over one operand; Rajpopat
  (2022) makes the same-operand / different-operand split explicit.  A rule
  whose domain is narrower but which fires somewhere else is not blocking
  anything.

* `antaranga` decides only when one redex position is a *proper prefix* of the
  other, i.e. only for genuinely nested candidates.  Two disjoint redexes are
  neither internal nor external to each other and the principle abstains.

* `nitya` is evaluated as Kiparsky states it — "applicable whether or not the
  other applies" — by actually firing the other candidate and re-testing
  applicability **anywhere in the term**.  It is dynamic: it is a property of
  the pair *and the term*, not of the rule pair alone.

No claim is made that these are Pāṇini's principles.  They are the closest
exact predicates a first-order TRS admits, and the measurement in
`runtime/demo/panini_demo.py` is a measurement of *those* predicates.

Pure Python 3 stdlib.  Exact integers only (in fact no arithmetic beyond
indices and counters).  Deterministic: no dicts are iterated for ordering, no
sets are iterated for output, no randomness.
"""

from __future__ import annotations

# ---------------------------------------------------------------------------
# Terms
# ---------------------------------------------------------------------------
#
# A term is a tuple.  ('?', name) is a pattern variable; (sym, *args) is a node
# with head symbol `sym` (a str never equal to '?') and zero or more children.

VAR = "?"


def V(name):
    """A pattern variable."""
    return (VAR, name)


def T(sym, *args):
    """A node with head `sym` and the given children."""
    if sym == VAR:
        raise ValueError("'?' is reserved for variables")
    return (sym,) + tuple(args)


def is_var(t):
    return t[0] == VAR


def show(t):
    """Deterministic printable form."""
    if is_var(t):
        return "?" + t[1]
    if len(t) == 1:
        return t[0]
    return t[0] + "(" + ", ".join(show(c) for c in t[1:]) + ")"


def size(t):
    """Node count.  Iterative: the rule books here can build terms deeper than
    the interpreter's recursion limit, and a size guard that overflows before
    it can guard is not a guard."""
    n = 0
    stack = [t]
    while stack:
        u = stack.pop()
        n += 1
        if not is_var(u):
            stack.extend(u[1:])
    return n


def ground_nodes(t):
    """Number of non-variable nodes.  Used only by the *naive* priority
    baseline, as a stand-in for 'how specific does this rule look'."""
    if is_var(t):
        return 0
    return 1 + sum(ground_nodes(c) for c in t[1:])


def positions(t, prefix=()):
    """All positions, pre-order (leftmost-outermost first)."""
    out = [prefix]
    if not is_var(t):
        for i, c in enumerate(t[1:]):
            out.extend(positions(c, prefix + (i,)))
    return out


def at(t, pos):
    for i in pos:
        t = t[1 + i]
    return t


def replace(t, pos, new):
    if not pos:
        return new
    i = pos[0]
    child = replace(t[1 + i], pos[1:], new)
    return t[: 1 + i] + (child,) + t[2 + i :]


def is_proper_prefix(p, q):
    """True iff position p is a strict ancestor of position q."""
    return len(p) < len(q) and q[: len(p)] == p


# ---------------------------------------------------------------------------
# Matching and subsumption
# ---------------------------------------------------------------------------


def match(pattern, term, subst=None):
    """First-order matching.  Returns a substitution dict or None.

    Non-linear patterns are supported: a repeated variable must bind to
    structurally identical subterms.
    """
    if subst is None:
        subst = {}
    else:
        subst = dict(subst)
    stack = [(pattern, term)]
    while stack:
        p, t = stack.pop()
        if is_var(p):
            name = p[1]
            if name in subst:
                if subst[name] != t:
                    return None
            else:
                subst[name] = t
            continue
        if is_var(t):
            return None
        if p[0] != t[0] or len(p) != len(t):
            return None
        for i in range(1, len(p)):
            stack.append((p[i], t[i]))
    return subst


def instantiate(pattern, subst):
    if is_var(pattern):
        name = pattern[1]
        if name not in subst:
            raise KeyError("unbound pattern variable ?" + name)
        return subst[name]
    return (pattern[0],) + tuple(instantiate(c, subst) for c in pattern[1:])


def subsumes(general, special):
    """True iff `general` matches `special`, i.e. every instance of `special`
    is an instance of `general`.  This is the subsumption (specificity) order
    used by modern term rewriting; see the note for why apavāda coincides with
    it here."""
    return match(general, special) is not None


def strictly_more_specific(a_lhs, b_lhs):
    """a_lhs's domain is a *proper* subset of b_lhs's domain."""
    return subsumes(b_lhs, a_lhs) and not subsumes(a_lhs, b_lhs)


# ---------------------------------------------------------------------------
# Rules and candidates
# ---------------------------------------------------------------------------


class Rule:
    """A rewrite rule `lhs -> rhs`.

    `index` is the rule's place in the book: the *para* order.  A rule with a
    higher index comes later in the grammar.
    """

    __slots__ = ("name", "lhs", "rhs", "index")

    def __init__(self, name, lhs, rhs, index):
        if is_var(lhs):
            raise ValueError("a bare-variable left side matches everything")
        missing = _vars(rhs) - _vars(lhs)
        if missing:
            raise ValueError(
                "rule %s: right side has unbound variables %s"
                % (name, sorted(missing))
            )
        self.name = name
        self.lhs = lhs
        self.rhs = rhs
        self.index = index

    def __repr__(self):
        return "Rule(%s: %s -> %s)" % (self.name, show(self.lhs), show(self.rhs))


def _vars(t):
    if is_var(t):
        return {t[1]}
    out = set()
    for c in t[1:]:
        out |= _vars(c)
    return out


class Candidate:
    """One applicable (rule, position) pair, with its result precomputed."""

    __slots__ = ("rule", "pos", "subst", "result")

    def __init__(self, rule, pos, subst, result):
        self.rule = rule
        self.pos = pos
        self.subst = subst
        self.result = result

    @property
    def depth(self):
        return len(self.pos)

    def __repr__(self):
        return "Candidate(%s@%s)" % (self.rule.name, list(self.pos))


def candidates(term, rules, counter=None):
    """Every applicable (rule, position), in a fixed order: positions
    leftmost-outermost, then rules by book index."""
    out = []
    for pos in positions(term):
        sub = at(term, pos)
        for rule in rules:
            if counter is not None:
                counter["match_attempts"] += 1
            s = match(rule.lhs, sub)
            if s is not None:
                out.append(Candidate(rule, pos, s, replace(term, pos, instantiate(rule.rhs, s))))
    return out


# ---------------------------------------------------------------------------
# The four principles
# ---------------------------------------------------------------------------
#
# Each returns 'a', 'b' or None ("this principle does not decide this pair").


def apavada(a, b, term, rules):
    """utsarga / apavāda — a special rule blocks the general rule it is an
    exception to.  Restricted to Same-Operand Interaction (same position)."""
    if a.pos != b.pos:
        return None
    if a.rule is b.rule:
        return None
    if strictly_more_specific(a.rule.lhs, b.rule.lhs):
        return "a"
    if strictly_more_specific(b.rule.lhs, a.rule.lhs):
        return "b"
    return None


def apavada_global(a, b, term, rules):
    """apavāda without the same-operand restriction: a strictly more specific
    rule blocks its general rule *wherever* the two compete.

    This is the Different-Operand reading.  It is not obviously Pāṇini's — the
    tradition's blocking is stated over a rule's domain, and whether that
    licenses overriding a redex at another position is exactly the point
    Rajpopat's SOI/DOI split turns on.  It is implemented and measured
    separately rather than folded into `apavada`, because on `book_q` the two
    readings give different answers and the difference is the whole result.
    """
    if a.rule is b.rule:
        return None
    if strictly_more_specific(a.rule.lhs, b.rule.lhs):
        return "a"
    if strictly_more_specific(b.rule.lhs, a.rule.lhs):
        return "b"
    return None


def antaranga(a, b, term, rules):
    """antaraṅga / bahiraṅga — the more internally conditioned rule first.
    Operationalised as redex-position internality, and only for nested
    positions."""
    if is_proper_prefix(b.pos, a.pos):
        return "a"
    if is_proper_prefix(a.pos, b.pos):
        return "b"
    return None


def nitya(a, b, term, rules):
    """nitya / anitya — a rule applicable whether or not the other applies
    takes precedence.  Dynamic: fire each and re-test applicability of the
    other **anywhere** in the resulting term."""
    if a.rule is b.rule and a.pos == b.pos:
        return None
    a_survives_b = _applicable_somewhere(a.rule, b.result)
    b_survives_a = _applicable_somewhere(b.rule, a.result)
    if a_survives_b and not b_survives_a:
        return "a"
    if b_survives_a and not a_survives_b:
        return "b"
    return None


def _applicable_somewhere(rule, term):
    for pos in positions(term):
        if match(rule.lhs, at(term, pos)) is not None:
            return True
    return False


def para(a, b, term, rules):
    """vipratiṣedhe paraṁ kāryam (A 1.4.2) — on conflict, the later rule.

    Kiparsky records that modern scholarship generally restricts this metarule
    to the saṃjñā section, and Rajpopat (2022) rejects the 'later in the
    grammar' reading outright in favour of 'rightmost in the word'.  We
    implement the traditional textbook reading and say so; the alternative
    reading is available as `para_rightmost`."""
    if a.rule.index == b.rule.index:
        return None
    return "a" if a.rule.index > b.rule.index else "b"


def para_rightmost(a, b, term, rules):
    """Rajpopat's (2022) reading: the operation applicable to the *right-hand
    side* of the form wins.  Here: the lexicographically greater position."""
    if a.pos == b.pos:
        return None
    return "a" if a.pos > b.pos else "b"


PANINIAN_HIERARCHY = (apavada, antaranga, nitya, para)
"""Kiparsky (2009) ex. (152): increasing strength para < nitya < antaraṅga <
apavāda.  Consulted strongest first."""

PANINIAN_HIERARCHY_DOI = (apavada_global, antaranga, nitya, para)
"""The same ranking with apavāda read across operands."""


# ---------------------------------------------------------------------------
# The policy
# ---------------------------------------------------------------------------


class Decision:
    __slots__ = ("winner", "status", "undefeated", "by")

    def __init__(self, winner, status, undefeated, by):
        self.winner = winner          # index into candidates
        self.status = status          # 'unique' | 'ambiguous' | 'cyclic'
        self.undefeated = undefeated  # tuple of indices
        self.by = by                  # name of the deciding principle, or None

    def __repr__(self):
        return "Decision(%r, %s, by=%s)" % (self.winner, self.status, self.by)


def compare(a, b, term, rules, hierarchy=PANINIAN_HIERARCHY):
    """Return ('a'|'b'|None, principle-name-or-None)."""
    for principle in hierarchy:
        r = principle(a, b, term, rules)
        if r is not None:
            return r, principle.__name__
    return None, None


def resolve(cands, term, rules, hierarchy=PANINIAN_HIERARCHY):
    """Build the pairwise defeat digraph and look for an undefeated candidate.

    A pairwise-defeat relation assembled from a hierarchy of partial relations
    is **not guaranteed transitive**, so the digraph can have a cycle and no
    undefeated node.  That is reported, not hidden: `status='cyclic'`.
    """
    n = len(cands)
    if n == 0:
        return Decision(None, "unique", (), None)
    beaten = [False] * n
    reason = [None] * n
    for i in range(n):
        for j in range(i + 1, n):
            r, why = compare(cands[i], cands[j], term, rules, hierarchy)
            if r == "a":
                beaten[j] = True
                if reason[i] is None:
                    reason[i] = why
            elif r == "b":
                beaten[i] = True
                if reason[j] is None:
                    reason[j] = why
    undefeated = tuple(i for i in range(n) if not beaten[i])
    if len(undefeated) == 1:
        w = undefeated[0]
        return Decision(w, "unique", undefeated, reason[w])
    if len(undefeated) == 0:
        # a defeat cycle: every candidate is beaten by some other.
        return Decision(_tiebreak(cands), "cyclic", undefeated, None)
    return Decision(
        _tiebreak([cands[i] for i in undefeated], undefeated),
        "ambiguous",
        undefeated,
        None,
    )


def _tiebreak(cands, index_map=None):
    """Deterministic last resort: leftmost-outermost position, then lowest
    book index.  Recorded separately from the principles so that a run which
    needed it cannot be reported as 'the policy decided'."""
    best = 0
    for i in range(1, len(cands)):
        key_i = (cands[i].pos, cands[i].rule.index)
        key_b = (cands[best].pos, cands[best].rule.index)
        if key_i < key_b:
            best = i
    return best if index_map is None else index_map[best]


# ---------------------------------------------------------------------------
# Strategies under test
# ---------------------------------------------------------------------------
#
# Every strategy has the signature (cands, term, rules) -> (index, note) where
# `note` is 'unique' / 'ambiguous' / 'cyclic' / '' for bookkeeping.


def strat_outermost_book(cands, term, rules):
    """(i) insertion order: leftmost-outermost redex, first applicable rule in
    book order.  `candidates` already emits exactly that order."""
    return 0, ""


def strat_outermost_book_reversed(cands, term, rules):
    """(i') the same engine with the book read back to front — the control
    that shows how much of (i) is the rule list's accident."""
    best = 0
    for i in range(1, len(cands)):
        if (cands[i].pos, -cands[i].rule.index) < (cands[best].pos, -cands[best].rule.index):
            best = i
    return best, ""


def strat_para_only(cands, term, rules):
    """Pure vipratiṣedhe paraṁ kāryam: leftmost-outermost redex, *last*
    applicable rule in book order."""
    return strat_outermost_book_reversed(cands, term, rules)


def strat_naive_specificity(cands, term, rules):
    """(ii-a) a naive priority scheme: prefer the rule with the most
    non-variable left-side nodes ('looks more specific'), then
    leftmost-outermost, then book order.

    Worth stating as a small lemma, because it bounds what this baseline can
    do: **if A's left side is a strict instance of B's, then A has strictly
    more ground nodes than B.**  (A = Bσ for a σ replacing at least one
    variable by a non-variable, and instantiation never removes ground nodes.)
    So this counter never *contradicts* apavāda — it is a sound relaxation of
    it.  Where it differs from the Pāṇinian policy is on subsumption-*incompar-
    able* pairs, where it is deciding by an accident of how many constants the
    two left sides happen to contain.  `book_p2` is the re-encoding that shows
    that accident changing the answer.
    """
    best = 0
    for i in range(1, len(cands)):
        ki = (-ground_nodes(cands[i].rule.lhs), cands[i].pos, cands[i].rule.index)
        kb = (-ground_nodes(cands[best].rule.lhs), cands[best].pos, cands[best].rule.index)
        if ki < kb:
            best = i
    return best, ""


def strat_greedy_smallest(cands, term, rules):
    """(ii-b) the other naive scheme a working engineer reaches for: fire the
    rewrite whose *result* is smallest, ties by leftmost-outermost then book
    order.  Greedy size reduction."""
    best = 0
    for i in range(1, len(cands)):
        ki = (size(cands[i].result), cands[i].pos, cands[i].rule.index)
        kb = (size(cands[best].result), cands[best].pos, cands[best].rule.index)
        if ki < kb:
            best = i
    return best, ""


def strat_innermost_book(cands, term, rules):
    """The standard modern eager strategy: leftmost-*innermost*, book order.
    Included because it is what antaraṅga reduces to on a first-order TRS, and
    the note must not claim antaraṅga is exotic when it is not."""
    best = 0
    for i in range(1, len(cands)):
        ki = (-len(cands[i].pos), cands[i].pos, cands[i].rule.index)
        kb = (-len(cands[best].pos), cands[best].pos, cands[best].rule.index)
        if ki < kb:
            best = i
    return best, ""


def strat_apavada_only(cands, term, rules):
    """Specificity ordering alone — the modern term-rewriting practice
    (priority rewrite systems).  Isolates how much of the Pāṇinian policy is
    just apavāda."""
    d = resolve(cands, term, rules, hierarchy=(apavada,))
    return d.winner, d.status


def strat_panini(cands, term, rules):
    """(iii) the full four-level hierarchy."""
    d = resolve(cands, term, rules, hierarchy=PANINIAN_HIERARCHY)
    return d.winner, d.status


def strat_panini_doi(cands, term, rules):
    """(iii') the four-level hierarchy with apavāda read across operands."""
    d = resolve(cands, term, rules, hierarchy=PANINIAN_HIERARCHY_DOI)
    return d.winner, d.status


STRATEGIES = (
    ("outermost-book", strat_outermost_book),
    ("outermost-book-reversed", strat_outermost_book_reversed),
    ("para-only", strat_para_only),
    ("naive-specificity", strat_naive_specificity),
    ("greedy-smallest", strat_greedy_smallest),
    ("innermost-book", strat_innermost_book),
    ("apavada-only", strat_apavada_only),
    ("panini", strat_panini),
    ("panini-doi", strat_panini_doi),
)


# ---------------------------------------------------------------------------
# Running to a normal form
# ---------------------------------------------------------------------------


class Trace:
    __slots__ = ("start", "final", "steps", "status", "ambiguous", "cyclic",
                 "match_attempts", "history")

    def __init__(self, start, final, steps, status, ambiguous, cyclic,
                 match_attempts, history):
        self.start = start
        self.final = final
        self.steps = steps
        self.status = status  # 'normal-form' | 'budget'
        self.ambiguous = ambiguous
        self.cyclic = cyclic
        self.match_attempts = match_attempts
        self.history = history

    @property
    def normalised(self):
        return self.status == "normal-form"

    def __repr__(self):
        return "Trace(%s -> %s, %d steps, %s)" % (
            show(self.start), show(self.final), self.steps, self.status)


def run(term, rules, strategy, budget=200, record=False):
    """Rewrite until no rule applies, or the step budget is spent.

    The budget is a *budget*, never silently a result: `status` is
    'normal-form' only when the candidate set was actually empty.
    """
    counter = {"match_attempts": 0}
    steps = 0
    ambiguous = 0
    cyclic = 0
    history = [term] if record else []
    cur = term
    while steps < budget:
        cands = candidates(cur, rules, counter)
        if not cands:
            return Trace(term, cur, steps, "normal-form", ambiguous, cyclic,
                         counter["match_attempts"], history)
        idx, note = strategy(cands, cur, rules)
        if note == "ambiguous":
            ambiguous += 1
        elif note == "cyclic":
            cyclic += 1
        cur = cands[idx].result
        steps += 1
        if record:
            history.append(cur)
    return Trace(term, cur, steps, "budget", ambiguous, cyclic,
                 counter["match_attempts"], history)


def normal_forms(term, rules, node_budget=20000, max_size=60):
    """Every normal form reachable by *any* rewrite sequence, as ground truth
    for confluence.  Returns (sorted tuple of normal forms, complete flag).

    `complete=False` means the search hit a budget — the node budget or the
    term-size cap — and then the result is a **subset**.  A divergent rule set
    has no finite reachable set, so `max_size` is not optional and its being
    hit is exactly the signal that the caller may not say 'confluent'.
    """
    seen = set()
    stack = [term]
    out = set()
    visited = 0
    complete = True
    while stack:
        t = stack.pop()
        if t in seen:
            continue
        seen.add(t)
        visited += 1
        if visited > node_budget:
            complete = False
            break
        if size(t) > max_size:
            complete = False
            continue
        cands = candidates(t, rules)
        if not cands:
            out.add(t)
            continue
        for c in cands:
            if c.result not in seen:
                stack.append(c.result)
    return tuple(sorted(out)), complete


class ConfluenceReport:
    __slots__ = ("term", "forms", "complete")

    def __init__(self, term, forms, complete):
        self.term = term
        self.forms = forms
        self.complete = complete

    @property
    def confluent(self):
        """Only claimable when the exploration finished."""
        if not self.complete:
            raise IncompleteExploration(
                "normal-form exploration hit its budget on %s; confluence "
                "cannot be claimed either way" % show(self.term))
        return len(self.forms) <= 1

    def __repr__(self):
        return "ConfluenceReport(%s, %d forms, complete=%s)" % (
            show(self.term), len(self.forms), self.complete)


class IncompleteExploration(Exception):
    pass


def confluence(term, rules, node_budget=20000, max_size=60):
    forms, complete = normal_forms(term, rules, node_budget, max_size)
    return ConfluenceReport(term, forms, complete)


# ---------------------------------------------------------------------------
# The rule books under test
# ---------------------------------------------------------------------------
#
# Book P is the main exhibit.  It is a small symbolic-exponentiation
# normaliser, chosen because the repo's own L3 demo (geodesic_demo) works on
# exactly this shape: mul / sqr / powers.  Every conflict in it is genuine —
# each is a pair of rules that both apply and disagree about the answer or
# about termination.


def book_p():
    """Symbolic power normalisation with two exceptions and one non-confluence.

    Conflicts, by construction:

    C1  `unfold` vs `pow_zero` on pow(x, e0).  Wrong choice: **divergence**.
    C2  `unfold` vs `pow_one`  on pow(x, e1).  Wrong choice: 3 steps not 1.
    C3  `unfold` at an outer position vs `dec_*` inside it.  Wrong choice:
        **divergence** (unfold's second argument is a bare variable, so it
        re-fires on its own output for ever).
    C4  `norm_mul` vs `norm_square` on norm(mul(x,x)).  Wrong choice: a
        **different normal form** — the system is genuinely non-confluent here.

    `norm_mul` is placed *after* `norm_square` in the book on purpose, so that
    "the later rule wins" gets C4 wrong.  That is the point of including para.
    """
    x, y, n = V("x"), V("y"), V("n")
    rules = [
        # 0: utsarga — the general unfolding rule.
        Rule("unfold", T("pow", x, n), T("mul", x, T("pow", x, T("dec", n))), 0),
        # 1,2: apavāda — the two exceptions to it.
        Rule("pow_zero", T("pow", x, T("e0")), T("one"), 1),
        Rule("pow_one", T("pow", x, T("e1")), x, 2),
        # 3,4,5: the exponent predecessor table.
        Rule("dec3", T("dec", T("e3")), T("e2"), 3),
        Rule("dec2", T("dec", T("e2")), T("e1"), 4),
        Rule("dec1", T("dec", T("e1")), T("e0"), 5),
        # 6: unit law.
        Rule("mul_one", T("mul", x, T("one")), x, 6),
        # 7: apavāda — the special case of a product of equals.
        Rule("norm_square", T("norm", T("mul", x, x)), T("sqr", T("norm", x)), 7),
        # 8: utsarga — deliberately placed AFTER its own exception.
        Rule("norm_mul", T("norm", T("mul", x, y)),
             T("mul", T("norm", x), T("norm", y)), 8),
        # 9,10: atoms and the sqr commuting law.
        Rule("norm_a", T("norm", T("a")), T("a"), 9),
        Rule("norm_sqr", T("norm", T("sqr", x)), T("sqr", T("norm", x)), 10),
    ]
    return rules


BOOK_P_TASKS = (
    # (name, start term, intended normal form, which conflict it exercises)
    ("C1 pow(a,e0)", T("pow", T("a"), T("e0")), T("one"), "apavāda vs utsarga"),
    ("C2 pow(a,e1)", T("pow", T("a"), T("e1")), T("a"), "apavāda vs utsarga"),
    ("C3 pow(a,e3)", T("pow", T("a"), T("e3")),
     T("mul", T("a"), T("mul", T("a"), T("a")))
     , "antaraṅga vs bahiraṅga"),
    ("C4 norm(mul(a,a))", T("norm", T("mul", T("a"), T("a"))),
     T("sqr", T("a")), "apavāda vs para"),
)


def book_p2():
    """Book P's third conflict (C3), **re-encoded** so that the two competing
    rules have the *same* ground-node count.

    The mathematics is unchanged: a general unfolding rule whose second
    argument is a bare variable, and an exponent-predecessor table inside it.
    The only change is that the base carries a constructor `mk`, which lifts
    `unfold`'s left side from 1 ground node to 2 — exactly the count the table
    rules already had.

    This is the control for the naive-specificity baseline.  That baseline
    solved C3, but not by specificity (the two rules are subsumption-
    incomparable); it solved it because `dec(e2)` happened to contain one more
    constant than `pow(?x,?n)`.  Re-encoding removes the accident.  antaraṅga
    is a statement about *positions* and is untouched by it.
    """
    x, n = V("x"), V("n")
    return [
        Rule("unfold", T("pow", T("mk", x), n),
             T("mul", T("mk", x), T("pow", T("mk", x), T("dec", n))), 0),
        Rule("dec2", T("dec", T("e2")), T("e1"), 1),
        Rule("dec1", T("dec", T("e1")), T("e0"), 2),
        Rule("pow_zero", T("pow", T("mk", x), T("e0")), T("one"), 3),
        Rule("mul_one", T("mul", x, T("one")), x, 4),
    ]


BOOK_P2_TASKS = (
    ("C3' pow(mk(a),e2)", T("pow", T("mk", T("a")), T("e2")),
     T("mul", T("mk", T("a")), T("mk", T("a"))),
     "antaraṅga vs bahiraṅga, ground-node counts tied"),
)


def book_q():
    """The crystallised-lemma exhibit, and the one place the Pāṇinian *ranking*
    is measurably worse than one of its own components.

    `runtime/crystallize/` installs fused lemmas: one edge where the primitive
    book took k steps.  Book Q is the smallest instance —

        sqr_expand : sqr(?x)      -> mul(?x, ?x)                    (utsarga)
        pow4       : sqr(sqr(?x)) -> mul(mul(mul(?x,?x),?x),?x)     (apavāda)

    — where `pow4` is a genuine fused lemma over the same operators the L3
    demo uses.  On `sqr(sqr(a))` the fused rule's immediate result is *larger*
    (7 nodes) than the general rule's (5), so a greedy-size strategy refuses
    the lemma; and the general rule also applies at the inner position, so
    antaraṅga — which outranks nothing but is outranked only by apavāda, and
    apavāda abstains across positions — pulls the Pāṇinian policy away from
    the lemma too.  Both reach a normal form; they reach *different* ones.
    """
    x = V("x")
    return [
        Rule("sqr_expand", T("sqr", x), T("mul", x, x), 0),
        Rule("pow4", T("sqr", T("sqr", x)),
             T("mul", T("mul", T("mul", x, x), x), x), 1),
    ]


BOOK_Q_TASKS = (
    ("Q1 sqr(sqr(a))", T("sqr", T("sqr", T("a"))),
     T("mul", T("mul", T("mul", T("a"), T("a")), T("a")), T("a")),
     "apavāda vs antaraṅga (fused lemma at the outer position)"),
)


def book_n():
    """The nitya isolation exhibit.

    In a first-order TRS, two redexes that overlap are necessarily at nested
    positions, and antaraṅga (ranked above nitya) has already decided them.
    So nitya can only be the deciding principle when two *different* rules
    compete at the *same* position with incomparable left sides.  This book
    manufactures exactly that, minimally:

        sel_l : f(p, ?y) -> gl(?y)
        sel_r : f(?x, q) -> gr(?x)

    Neither left side subsumes the other, so apavāda abstains; the positions
    are equal, so antaraṅga abstains.  On `k(f(p,q), f(p,r))` both compete at
    position (0), and `sel_l` is still applicable after `sel_r` fires (it
    matches f(p,r) at position (1)) while `sel_r` is not applicable after
    `sel_l` fires.  So `sel_l` is nitya and wins.
    """
    x, y = V("x"), V("y")
    return [
        Rule("sel_l", T("f", T("p"), y), T("gl", y), 0),
        Rule("sel_r", T("f", x, T("q")), T("gr", x), 1),
    ]


def book_cycle():
    """A rule set on which the Pāṇinian hierarchy leaves **no undefeated
    candidate**.

    The four principles are partial relations of different shapes: apavāda
    relates same-position pairs, antaraṅga relates nested pairs, para relates
    everything by book index.  Assembling them lexicographically gives a
    pairwise-defeat digraph with no transitivity guarantee, and here it has a
    3-cycle:

        u@(0,0)  ≻ v@(0)    by antaraṅga  (u is inside v's redex)
        v@(0)    ≻ w@(1)    by para       (v is later in the book)
        w@(1)    ≻ u@(0,0)  by para       (w is later than u)

    nitya abstains on both disjoint pairs — each rule is still applicable after
    the other fires.  So every candidate is beaten and `resolve` returns
    `status='cyclic'`.  This is not a bug in the implementation; it is the
    exact sense in which the metatheory does not by itself determine an order,
    and it is why the Aṣṭādhyāyī needs its paribhāṣā literature.
    """
    x = V("x")
    return [
        Rule("u", T("a0"), T("b0"), 0),
        Rule("w", T("c0"), T("d0"), 1),
        Rule("v", T("outer", x), T("inner", x), 2),
    ]


BOOK_CYCLE_TASKS = (
    ("Z1 pair(outer(a0), c0)",
     T("pair", T("outer", T("a0")), T("c0")),
     T("pair", T("inner", T("b0")), T("d0")),
     "no undefeated candidate: a 3-cycle in the defeat digraph"),
)


BOOK_N_TASKS = (
    ("N1 k(f(p,q), f(p,r))",
     T("k", T("f", T("p"), T("q")), T("f", T("p"), T("r"))),
     T("k", T("gl", T("q")), T("gl", T("r"))),
     "nitya vs anitya"),
)


# ---------------------------------------------------------------------------
# The measurement
# ---------------------------------------------------------------------------


class Row:
    __slots__ = ("task", "strategy", "steps", "status", "final", "correct",
                 "ambiguous", "cyclic", "match_attempts")

    def __init__(self, task, strategy, trace, intended):
        self.task = task
        self.strategy = strategy
        self.steps = trace.steps
        self.status = trace.status
        self.final = trace.final
        self.correct = trace.normalised and trace.final == intended
        self.ambiguous = trace.ambiguous
        self.cyclic = trace.cyclic
        self.match_attempts = trace.match_attempts


def measure(rules, tasks, budget=200, strategies=STRATEGIES):
    """Run every strategy on every task.  Returns a flat, ordered list of Rows."""
    rows = []
    for tname, start, intended, _kind in tasks:
        for sname, strat in strategies:
            rows.append(Row(tname, sname, run(start, rules, strat, budget), intended))
    return rows


def summarise(rows, strategies=STRATEGIES):
    """Per-strategy totals.  A task that did not reach a normal form
    contributes its *budget* to the step total and is counted as a failure;
    the two are reported separately so neither can hide the other."""
    out = []
    for sname, _ in strategies:
        sel = [r for r in rows if r.strategy == sname]
        out.append({
            "strategy": sname,
            "tasks": len(sel),
            "normalised": sum(1 for r in sel if r.status == "normal-form"),
            "correct": sum(1 for r in sel if r.correct),
            "steps": sum(r.steps for r in sel),
            "match_attempts": sum(r.match_attempts for r in sel),
            "ambiguous": sum(r.ambiguous for r in sel),
            "cyclic": sum(r.cyclic for r in sel),
        })
    return out
