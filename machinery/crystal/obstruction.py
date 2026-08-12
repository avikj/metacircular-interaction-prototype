"""Failed transports, kept as objects.

A defect is not a bad word; it is the seed of new mathematics. An
obstruction is a map of what could not be seen.

`transport.py` checks an interpretation and, when it fails, raises. That is
the discipline violation this module repairs: the machine was accumulating
only successful relations, discarding the shape of every failed one. But the
residual of a failed transport is not noise. It is a *presented theory
extension* — precisely the set of equations the target would have to satisfy
for the map to have been an interpretation — and asking whether that
extension is consistent is asking a real mathematical question with real
answers.

Given a map φ from source theory S into target theory T that fails on some
subset of S's axioms, the **obstruction** is

    Obs(φ) = { φ(l) = φ(r)  :  (l = r) an axiom of S that φ did not carry }

read as a presentation on top of T. Completing T ∪ Obs(φ) trichotomises:

  FATAL     the extension is inconsistent — it derives ?x = ?y for distinct
            variables, i.e. it forces every element equal. The two theories
            share only the trivial model, and the derived equation is the
            witness. This is a theorem, obtained from a failure.

  EXTENDS   the extension completes without collapse. φ is not an
            interpretation into T, but it *is* one into T ∪ Obs(φ), and the
            newly derived rules are exactly what was missing. The failed
            transport has named a larger theory.

and otherwise one of three TYPED failures to answer -- see `Verdict`. They
are kept apart because they license different next actions.

Five things are carried explicitly on every record, because a distinction
lacking any of them is incomplete: which map and which axiom (why this
record exists), which target theory (the context), the residual pair of
normal forms (what could not be separated), the verdict (what action this
licenses), and the witness (what makes the verdict checkable rather than
asserted).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import Optional

from machinery.crystal.kernel import (
    LPO, Completion, Ledger, Term, mk, normalize, variables,
)


class Verdict(Enum):
    """Two answers, and a *typed* absence of answer.

    Zero holds a place. These must not be thrown into one null.

    A single `UNDECIDED` was the first version of this enum and it was
    wrong, in a way mutation testing detected before it was understood: the
    mutant that deleted the budget check survived, because a budget failure
    and a representation failure were the same value. They are not the same
    fact and they do not license the same next action. Merging them makes
    the machine unable to route its own ignorance.
    """

    #: the extension is inconsistent; the theories share only the trivial model
    FATAL = "FATAL"
    #: the extension completes; the map is an interpretation into a larger theory
    EXTENDS = "EXTENDS"

    # ---- the typed zero: three ways of not knowing, never merged ----

    #: INVISIBLE TO THIS REPRESENTATION -- a residual equation that THIS
    #: reduction order cannot orient. Not a fact about the mathematics; a
    #: fact about the order. Licensed next action: ordered/unfailing
    #: completion, or completion modulo AC. Retrying with a bigger budget is
    #: guaranteed to waste it.
    UNORIENTABLE = "UNORIENTABLE"

    #: BEYOND THE MEANS WE SPENT -- the budget was spent with work still pending and no
    #: unorientable residual. Licensed next action: spend more, or read the
    #: growth diagnosis. Says nothing about whether an answer exists.
    EXHAUSTED = "EXHAUSTED"

    #: OUTSIDE JURISDICTION -- the question was never in this target's jurisdiction:
    #: the source signature contains a symbol the interpretation does not
    #: map and the target does not have. Not an obstruction at all. Licensed
    #: next action: complete the signature map. Reporting this as a
    #: mathematical obstruction would be a category error.
    OUT_OF_SCOPE = "OUT_OF_SCOPE"


@dataclass
class Residual:
    """One axiom the transport failed to carry, with its shape."""

    axiom: str
    source_lhs: Term
    source_rhs: Term
    image_lhs_nf: Term
    """φ(lhs), normalised in the target. Where the image actually landed."""
    image_rhs_nf: Term
    """φ(rhs), normalised in the target. Where it needed to land."""

    def as_equation(self) -> tuple[Term, Term]:
        return (self.image_lhs_nf, self.image_rhs_nf)

    def __repr__(self) -> str:
        return (f"{self.axiom}: {self.source_lhs!r} = {self.source_rhs!r}"
                f"  ↦  {self.image_lhs_nf!r} ≠ {self.image_rhs_nf!r}")


@dataclass
class Obstruction:
    """The map of what a transport could not see."""

    # why this record exists
    interpretation: str
    # the context it is an obstruction *in*
    target_axioms: list
    order: LPO
    # what could not be separated
    residuals: list[Residual] = field(default_factory=list)
    # what action the obstruction licenses
    verdict: Optional[Verdict] = None
    # the witness that makes the verdict checkable
    collapse_witness: Optional[tuple] = None
    derived_rules: list = field(default_factory=list)
    surviving_residual: Optional[tuple] = None
    unmapped: list = field(default_factory=list)
    budget: Optional[tuple] = None
    growth: list = field(default_factory=list)
    cost: int = 0

    def presentation(self) -> list:
        """T ∪ Obs(φ): the theory the transport would have needed."""
        return list(self.target_axioms) + [
            (f"obstruction:{r.axiom}", *r.as_equation()) for r in self.residuals
        ]

    def classify(self, max_rules: int = 60, max_rounds: int = 400) -> Verdict:
        """Complete T ∪ Obs(φ) and read the answer off the completion.

        This is the step that makes a failure fruitful: the same machinery
        that compiles a theory is asked what the *missing* theory would be.
        """
        # Every field this method can set is cleared first. A record that
        # reported EXTENDS and is then re-classified under a smaller budget
        # must not keep the old rules alongside the new verdict: a verdict
        # contaminated by a previous run is a lie told with true data.
        self.verdict = None
        self.collapse_witness = None
        self.derived_rules = []
        self.surviving_residual = None
        self.budget = None
        self.growth = []

        led = Ledger()
        comp = Completion(self.order, led)
        comp.run(self.presentation(), max_rules=max_rules, max_rounds=max_rounds)
        self.cost = led.rewrite_steps

        # FATAL: the extension derives an equation with a bare variable on one
        # side that does not occur on the other. Such an equation is
        # universally quantified, so instantiating the remaining variables
        # collapses the carrier: every element is equal to every other. Note
        # that ?x = ?y is the special case b = a variable, and is *subsumed*
        # here rather than tested separately — a separate var-vs-var branch
        # was written first and mutation testing exposed it as unreachable
        # dead code, since distinct variables always satisfy this condition.
        #
        # Such an equation necessarily lands in the unorientable residue: no
        # reduction order can orient a bare variable against anything, because
        # orienting it either way rewrites forever.
        #
        # `a.head not in variables(b)` is DEFENSIVE and cannot currently be
        # mutation-killed, which is worth saying rather than hiding. Under
        # LPO the complementary case is unreachable: if the variable does
        # occur in the other side, the subterm property orients the equation,
        # so it never reaches the unorientable residue at all. The guard is
        # kept because that is a property of the *order*, not of this logic —
        # swap in a non-simplification order and the case goes live.
        collapses = [
            (a, b, origin)
            for l, r, origin in led.unorientable_pairs
            for a, b in ((l, r), (r, l))
            if a.is_var and a.head not in variables(b)
        ]
        if collapses:
            self.verdict = Verdict.FATAL
            self.collapse_witness = collapses[0]
            return self.verdict

        # Invisible to THIS ORDER.
        if led.unorientable_pairs:
            self.verdict = Verdict.UNORIENTABLE
            self.surviving_residual = led.unorientable_pairs[0]
            return self.verdict

        # The budget ran out, which is a fact about us, not the mathematics.
        if comp.exhausted or len(comp.rules) >= max_rules:
            self.verdict = Verdict.EXHAUSTED
            self.budget = (max_rules, max_rounds)
            # A diagnosis, deliberately NOT a verdict: whether the loop was
            # merely slow or genuinely divergent is undecidable, so the sizes
            # are reported and the caller is not told which.
            sizes = [r.lhs.size for r in comp.rules]
            self.growth = sizes[-5:]
            return self.verdict

        # EXTENDS: what the target was missing, as executable rules.
        target_lhs = {l for _, l, _ in self.target_axioms}
        self.derived_rules = [
            r for r in comp.rules
            if r.origin[0] != "axiom" or r.lhs not in target_lhs
        ]
        self.verdict = Verdict.EXTENDS
        return self.verdict

    def report(self) -> str:
        out = [f"obstruction of {self.interpretation!r} — {self.verdict.value}"]
        for r in self.residuals:
            out.append(f"    residual  {r!r}")
        if self.verdict is Verdict.FATAL:
            l, r, origin = self.collapse_witness
            out.append(f"    collapse  {l!r} = {r!r}   [{origin[0]}]")
            out.append("    meaning   the two theories share only the trivial "
                       "model; this is a theorem, obtained from the failure")
        elif self.verdict is Verdict.EXTENDS:
            out.append(f"    consistent: the map IS an interpretation into "
                       f"T ∪ Obs, which needs {len(self.derived_rules)} rule(s):")
            for rr in self.derived_rules:
                out.append(f"        {rr.lhs!r} -> {rr.rhs!r}")
        elif self.verdict is Verdict.UNORIENTABLE:
            l, r, _ = self.surviving_residual
            out.append(f"    residue   {l!r} = {r!r}")
            out.append("    meaning   this ORDER cannot see it. A fact about "
                       "the representation, not the mathematics.")
            out.append("    next      ordered/unfailing completion, or modulo "
                       "AC. A larger budget is guaranteed waste.")
        elif self.verdict is Verdict.EXHAUSTED:
            out.append(f"    budget    {self.budget[0]} rules / "
                       f"{self.budget[1]} rounds, spent with work pending")
            out.append(f"    growth    last lhs sizes {self.growth}")
            out.append("    meaning   a fact about what we spent, not about "
                       "whether an answer exists.")
            out.append("    next      spend more, or read the growth. Whether "
                       "this diverges is undecidable and is NOT claimed.")
        elif self.verdict is Verdict.OUT_OF_SCOPE:
            out.append(f"    unmapped  {self.unmapped}")
            out.append("    meaning   asked outside the target's jurisdiction; "
                       "the map has a gap, so there is no obstruction here.")
            out.append("    next      complete the signature map. Reporting "
                       "this as mathematics would be a category error.")
        out.append(f"    cost      {self.cost} rewrite steps")
        return "\n".join(out)


def _symbols(t: Term) -> set:
    """Every (head, arity) occurring in a term, variables excluded."""
    if t.is_var:
        return set()
    out = {(t.head, len(t.args))}
    for a in t.args:
        out |= _symbols(a)
    return out


def jurisdiction_gap(interp, target_axioms: list,
                     target_signature: Optional[set] = None) -> list:
    """Outside jurisdiction: source symbols that neither the map nor the target
    accounts for.

    `Interpretation.apply` carries an unmapped symbol through unchanged.
    That is right when the two theories genuinely share the symbol and
    silently wrong otherwise: the "image" then lives in a signature the
    target never had, and checking it against the target's rules is
    meaningless rather than false. This is not an obstruction; it is a
    question asked outside the target's jurisdiction, and the two must not
    be reported the same way.
    """
    if target_signature is None:
        # Inferred from the axioms, which is a GUESS: a theory may declare a
        # symbol its axioms never constrain (a pointed semigroup has `e` and
        # says nothing about it). Pass the signature explicitly whenever the
        # theory has one, rather than letting the inference decide.
        target_syms = set()
        for _, l, r in target_axioms:
            target_syms |= _symbols(l) | _symbols(r)
    else:
        target_syms = set(target_signature)
    source_syms = set()
    for _, l, r in interp.source_axioms:
        source_syms |= _symbols(l) | _symbols(r)
    return sorted(s for s in source_syms
                  if s not in interp.clauses and s not in target_syms)


def obstruction_of(interp, target_axioms: list, order: LPO,
                   target_signature: Optional[set] = None,
                   max_rules: int = 60,
                   max_rounds: int = 400) -> Optional[Obstruction]:
    """Build the obstruction of a *failed* interpretation.

    Returns None when the interpretation checks — there is nothing invisible
    to map. Otherwise the returned record is classified and ready to store.
    """
    obs = Obstruction(interpretation=interp.name, target_axioms=list(target_axioms),
                      order=order)

    # Jurisdiction is checked BEFORE the mathematics, because a map with a
    # gap does not produce a meaningful failure to classify.
    gap = jurisdiction_gap(interp, target_axioms, target_signature)
    if gap:
        obs.unmapped = gap
        obs.verdict = Verdict.OUT_OF_SCOPE
        return obs

    if interp.failures is None:
        interp.check()
    if not interp.failures:
        return None
    for name, l, r in interp.failures:
        li, _ = normalize(interp.apply(l), interp.target.rules)
        ri, _ = normalize(interp.apply(r), interp.target.rules)
        obs.residuals.append(Residual(name, l, r, li, ri))
    obs.classify(max_rules=max_rules, max_rounds=max_rounds)
    return obs
