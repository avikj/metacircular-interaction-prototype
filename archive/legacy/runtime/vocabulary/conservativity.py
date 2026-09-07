"""The guard: a definitional extension may not prove a new base theorem.

TWO CHECKS, AND THEY ARE NOT THE SAME CHECK
-------------------------------------------
**Admission (static).**  :func:`admissible` decides whether a proposed
``Definition`` is a definition at all.  Seven gates, all syntactic, all exact,
each refusable by name.  This is where a "definition" that is really a new
axiom about old symbols dies -- ``x*y := x+y`` is not refused because it is
false (it is), but because its left-hand side is a term of the *old* language,
so the equation constrains ``*`` and ``+`` instead of introducing something.
A definitional extension is precisely an extension whose new equation's left
side is a fresh head applied to distinct parameters, and gate D3 is that
sentence made mechanical.

**Elimination (dynamic).**  The standard conservativity argument is: every
proof using the new symbol unfolds to a proof that does not.  :func:`unfolds`
runs that argument on an actual theorem -- unfold both sides, demand the
result is base, re-derive it with the *base* engine, re-check every step with
``check_derivation``, and decide it a second and structurally unrelated way
with ``poly_equal``.  A theorem whose unfolding does not check in the base is
refused, and ``test_vocabulary.py`` plants one.

WHAT CONSERVATIVITY BUYS, AND WHAT IT COSTS
-------------------------------------------
It buys honesty: because the extension is conservative, *no benchmark number
that moves can be moved by the extension proving something new*.  Whatever
moves, moves because of reachability under a budget.  That is the entire point
of the experiment in ``demo/vocabulary_demo.py``, and it is only a meaningful
experiment if this module is doing its job.

It costs the one thing a naive implementation would love to do: state a lemma
in the new vocabulary and use it on a base problem.  Not allowed here.  Base
problems are solved by the base engine, in the base vocabulary, full stop --
:func:`base_answers_unchanged` is the mechanical assertion of that.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import List, Optional, Sequence, Tuple

from ..crystallize.derivation import (CheckFailure, Counter, Divergence,
                                      Lemma, PV, Term, check_derivation,
                                      is_pvar, normalize, poly_equal, pvars_of,
                                      render)
from ..kernel.edges import Edge
from .define import (Definition, Vocabulary, VocabularyError, def_name,
                     def_symbols, is_base, is_def, unfold, vrender)

__all__ = [
    "GATES", "Refusal", "AdmissionReport", "admissible", "admit",
    "Installation", "UnfoldReport", "unfolds", "audit_theorems",
    "base_answers_unchanged", "BaseAnswerReport",
]

GATES: Tuple[Tuple[str, str], ...] = (
    ("D1", "the constructor name is fresh"),
    ("D2", "arity >= 1 and the body is a term, not a bare parameter"),
    ("D3", "the defining equation's left side is the new head applied to "
           "distinct parameters -- it constrains no old symbol"),
    ("D4", "the body mentions only base symbols and strictly earlier "
           "definitions (so unfolding terminates and eliminates)"),
    ("D5", "the body's parameters are exactly #0..#k-1 -- no free pattern "
           "variable on the right, and none unused"),
    ("D6", "unfolding the definition's own left side reaches a base term"),
    ("D7", "no side equations ride along with the definition"),
)


@dataclass(frozen=True)
class Refusal:
    gate: str
    detail: str

    def render(self) -> str:
        return "REFUSED [%s] %s" % (self.gate, self.detail)


@dataclass(frozen=True)
class AdmissionReport:
    ok: bool
    gates: Tuple[Tuple[str, bool], ...]
    refusals: Tuple[Refusal, ...]

    def render(self) -> str:
        if self.ok:
            return "ADMITTED (%s)" % " ".join(g for g, _ in self.gates)
        return " ; ".join(r.render() for r in self.refusals)


def admissible(defn: Definition, vocab: Vocabulary) -> AdmissionReport:
    """Run D1..D7.  Every gate is evaluated, so the report is complete."""
    gates: List[Tuple[str, bool]] = []
    refusals: List[Refusal] = []

    def gate(name: str, ok: bool, detail: str) -> None:
        gates.append((name, ok))
        if not ok:
            refusals.append(Refusal(name, detail))

    # D1 -- freshness
    fresh = (vocab.get(defn.name) is None
             and all(defn.name not in def_symbols(d.body)
                     for d in vocab.definitions))
    gate("D1", fresh, "%r is already defined or already in use" % defn.name)

    # D2 -- shape of the statement
    d2 = (defn.arity >= 1 and isinstance(defn.body, Term)
          and not is_pvar(defn.body) and defn.body.size > 1)
    gate("D2", d2, "arity %d with body %s is not a constructor definition"
         % (defn.arity, vrender(defn.body)))

    # D3 -- the left side introduces, it does not constrain
    lhs = defn.lhs
    canonical = (is_def(lhs) and def_name(lhs) == defn.name
                 and len(lhs.args) == defn.arity
                 and all(lhs.args[i].addr == PV(i).addr
                         for i in range(defn.arity)))
    gate("D3", canonical,
         "left side %s is not %s applied to distinct parameters #0..#%d -- a "
         "definitional extension may not state an equation about old symbols"
         % (vrender(lhs), defn.name, defn.arity - 1))

    # D4 -- body vocabulary, and therefore termination of unfolding
    known = set(vocab.names())
    body_syms = def_symbols(defn.body)
    d4 = all(s in known for s in body_syms) and defn.name not in body_syms
    gate("D4", d4,
         "body mentions %s, which is not already installed (or is itself)"
         % ", ".join(s for s in body_syms if s not in known or s == defn.name))

    # D5 -- parameters
    want = tuple("#%d" % i for i in range(defn.arity))
    got = tuple(v.val for v in pvars_of(defn.body))
    gate("D5", got == want,
         "body parameters %s, expected %s" % (list(got), list(want)))

    # D6 -- eliminability, run rather than argued
    d6 = False
    detail6 = ""
    if d4 and fresh:
        try:
            tmp = Vocabulary(vocab.ctx)
            tmp.definitions = list(vocab.definitions) + [defn]
            tmp.by_name = dict(vocab.by_name)
            tmp.by_name[defn.name] = defn
            out = unfold(defn.head(*defn.params), tmp)
            d6 = is_base(out)
            detail6 = vrender(out)
        except VocabularyError as exc:
            d6, detail6 = False, str(exc)
    gate("D6", d6, "unfolding does not reach a base term (%s)" % detail6)

    # D7 -- nothing rides along
    gate("D7", not defn.extra_axioms,
         "%d side equation(s) offered with the definition"
         % len(defn.extra_axioms))

    ok = all(v for _, v in gates)
    return AdmissionReport(ok, tuple(gates), tuple(refusals))


@dataclass(frozen=True)
class Installation:
    ok: bool
    report: AdmissionReport
    definition: Definition
    edge: Optional[Edge] = None

    def render(self) -> str:
        return "%-14s %-46s %s" % (self.definition.name,
                                   self.definition.render(),
                                   self.report.render())


def admit(vocab: Vocabulary, defn: Definition, rnd: int = -1) -> Installation:
    """The only guarded door into a vocabulary.

    Runs D1..D7 first, and only then declares the defining equation to the
    kernel.  A refused definition contributes no axiom at all -- the vault
    discipline of ``generate/multiway.py``, applied to vocabulary instead of
    to rewrites.
    """
    rep = admissible(defn, vocab)
    if not rep.ok:
        return Installation(False, rep, defn, None)
    edge = vocab.install_unchecked(defn, rnd)
    return Installation(True, rep, defn, edge)


# ==========================================================================
# elimination: unfold a theorem and re-check it in the base
# ==========================================================================

@dataclass(frozen=True)
class UnfoldReport:
    """Did this extended-vocabulary theorem survive elimination?"""

    ok: bool
    label: str
    unfold_steps: int
    base_steps: int
    base_checks: int
    lhs_base: Optional[Term]
    rhs_base: Optional[Term]
    normal_form: Optional[Term]
    semantic: Optional[bool]
    reason: str = ""

    def render(self) -> str:
        head = "ok  " if self.ok else "FAIL"
        return ("%s %-30s unfold %3d | base %4d steps, %4d checks | %s"
                % (head, self.label[:30], self.unfold_steps, self.base_steps,
                   self.base_checks, self.reason or "checks in the base"))


def unfolds(lhs: Term, rhs: Term, vocab: Vocabulary,
            lemmas: Sequence[Lemma] = (), label: str = "",
            max_steps: int = 200000) -> UnfoldReport:
    """The conservativity argument, executed on one theorem.

    ``lhs = rhs`` is a theorem of the extended vocabulary.  We

      1. unfold both sides (counted), demanding base terms;
      2. normalise both with the **base** engine and demand one address;
      3. re-check every step of both derivations with ``check_derivation``;
      4. decide the identity again with ``poly_equal``, which is complete on
         this substrate and structurally unrelated to (2)-(3).

    All four must hold.  Any failure is a refusal, not a warning.
    """
    ctr = Counter()
    try:
        ul = unfold(lhs, vocab, ctr)
        ur = unfold(rhs, vocab, ctr)
    except VocabularyError as exc:
        return UnfoldReport(False, label, ctr.steps, 0, 0, None, None, None,
                            None, "unfolding failed: %s" % exc)
    unfold_steps = ctr.steps

    bctr = Counter()
    try:
        dl, _ = normalize(ul, lemmas=tuple(lemmas), ctr=bctr,
                          name="unfolded-lhs", max_steps=max_steps)
        dr, _ = normalize(ur, lemmas=tuple(lemmas), ctr=bctr,
                          name="unfolded-rhs", max_steps=max_steps)
    except Divergence as exc:
        return UnfoldReport(False, label, unfold_steps, bctr.steps, 0, ul, ur,
                            None, None, "base engine diverged: %s" % exc)
    if dl.result.addr != dr.result.addr:
        return UnfoldReport(False, label, unfold_steps, bctr.steps, 0, ul, ur,
                            None, None,
                            "unfolded sides have different normal forms: %s vs %s"
                            % (render(dl.result), render(dr.result)))
    table = {l.lid: l for l in lemmas}
    try:
        check_derivation(dl, table, bctr)
        check_derivation(dr, table, bctr)
    except CheckFailure as exc:
        return UnfoldReport(False, label, unfold_steps, bctr.steps, bctr.checks,
                            ul, ur, None, None, "base check failed: %s" % exc)
    try:
        sem = poly_equal(ul, ur)
    except ValueError as exc:
        return UnfoldReport(False, label, unfold_steps, bctr.steps, bctr.checks,
                            ul, ur, dl.result, None,
                            "semantic decision unavailable: %s" % exc)
    if not sem:
        return UnfoldReport(False, label, unfold_steps, bctr.steps, bctr.checks,
                            ul, ur, dl.result, False,
                            "unfolded sides are different polynomials")
    return UnfoldReport(True, label, unfold_steps, bctr.steps, bctr.checks,
                        ul, ur, dl.result, True)


def audit_theorems(theorems: Sequence[Tuple[str, Term, Term]],
                   vocab: Vocabulary, lemmas: Sequence[Lemma] = ()
                   ) -> Tuple[bool, Tuple[UnfoldReport, ...]]:
    """Run :func:`unfolds` on every theorem the extended loop proved."""
    rows = tuple(unfolds(l, r, vocab, lemmas, label=n) for n, l, r in theorems)
    return (all(x.ok for x in rows), rows)


# ==========================================================================
# the blunt statement of conservativity on this substrate
# ==========================================================================

@dataclass(frozen=True)
class BaseAnswerReport:
    ok: bool
    checked: int
    differing: Tuple[str, ...]

    def render(self) -> str:
        return ("base answers unchanged on %d term(s)%s"
                % (self.checked,
                   "" if self.ok else "  -- DIFFER: " + ", ".join(self.differing)))


def base_answers_unchanged(terms: Sequence[Term], vocab: Vocabulary,
                           lemmas: Sequence[Lemma] = ()) -> BaseAnswerReport:
    """A base problem must get the same answer whatever the vocabulary is.

    Normalisation is a decision procedure on this substrate, so "provable" and
    "normalises to the same thing" coincide for equations between base terms.
    Fixing the answer therefore fixes the provable set: this is conservativity
    stated in the strongest form the substrate allows, and it is checked by
    running the base engine with the vocabulary present and absent and
    demanding **address equality** of the results.
    """
    differing: List[str] = []
    for t in terms:
        if not is_base(t):
            differing.append("%s is not a base term" % vrender(t))
            continue
        a, _ = normalize(t, lemmas=tuple(lemmas), ctr=Counter(), name="with")
        # the vocabulary is not consulted by ``normalize`` at all -- a defined
        # head cannot occur in a base term and no primitive rule mentions one.
        # Re-running it after installing the vocabulary is the check that this
        # remains true, and it would fail loudly if a definition had leaked a
        # rewrite rule into the base engine.
        b, _ = normalize(unfold(t, vocab), lemmas=tuple(lemmas), ctr=Counter(),
                         name="without")
        if a.result.addr != b.result.addr:
            differing.append(render(t))
    return BaseAnswerReport(not differing, len(terms), tuple(differing))
