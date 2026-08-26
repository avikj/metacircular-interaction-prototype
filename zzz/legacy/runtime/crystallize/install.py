"""Checking a mined generalisation and installing it as a single step.

THE CHECKING DISCIPLINE (CRYSTAL.md sec 3.1 steps 4-5)
------------------------------------------------------
A mined candidate is a *proposal*.  It becomes a lemma only after passing all
seven gates below.  Any one of them failing rejects the candidate outright --
there is no partial credit and no confidence score.

  G1  WELL-FORMED.  Every pattern variable of the right-hand side occurs in
      the left-hand side, the two sides differ, and the pattern is not a bare
      variable.  Otherwise "rewrite" is not even a function.

  G2  LGG SOUNDNESS.  Every mined instance is recovered from the
      generalisation by its witness substitution (``mine.reconstruction_ok``).
      Catches a mis-aligned variable map.

  G3  PROOF REBUILT.  The generalised statement is *re-derived from scratch*:
      instantiate the pattern variables with fresh ground indeterminates and
      run the primitive normaliser on the left-hand side.  This is the
      "rebuild a proof of the generalized statement from the original proof
      terms" step, done by construction rather than by assertion.

  G4  PROOF FIDELITY.  The rebuilt derivation's rule sequence must equal the
      mined sub-DAG's rule sequence.  This is what makes the lemma a
      *crystallisation of those steps* rather than a coincidence that happens
      to be true.  A candidate that is true but arrived at by other steps is
      rejected here, deliberately: it was not what the miner found.

  G5  ENDPOINT.  The rebuilt derivation's result is exactly the generalised
      right-hand side (address equality on hash-consed terms).

  G6  KERNEL CHECK.  Every step of the rebuilt derivation is re-validated
      against its rule schema by ``derivation.check_step``.  The checker
      re-runs the rule; it does not trust the recorded contractum.

  G7  INDEPENDENT SEMANTICS.  ``poly_equal`` decides the identity by exact
      evaluation on an integer grid whose size is a *complete* bound for the
      degree.  This is a second, structurally unrelated witness: G3-G6 are
      syntactic replay, G7 is denotational.  A lemma passing one but not the
      other is rejected and is worth investigating.

Why a fresh-indeterminate rebuild is enough for *all* instantiations: the
generalised statement is an identity between two polynomials in the free
commutative ring ``Z[#0, #1, ...]``, which is initial among commutative
Z-algebras.  An identity there maps to an identity under every substitution of
ring elements, so soundness of the installed rewrite at arbitrary compound
arguments follows -- and the demo exercises exactly that by firing the lemma
on compound arguments never seen during mining.

WHAT INSTALLATION IS NOT
------------------------
Installing a lemma may not change any answer.  The rewrite is derivable from
the primitives (that is G3-G6), so adding it changes only the *route*, never
the normal form.  The tests assert this over a battery of terms, and the demo
re-verifies P4's answer independently.
"""

from __future__ import annotations

from typing import Dict, List, Optional, Sequence, Tuple

from .derivation import (CheckFailure, Counter, Derivation, Divergence, Lemma,
                         Term, V, check_derivation, is_pvar, normalize,
                         poly_equal, pvars_of, render, subst)
from .mine import Candidate, reconstruction_ok

GROUND_PREFIX = "$g"


class Verdict:
    """The result of checking a candidate.  Printable, deterministic."""

    __slots__ = ("ok", "reasons", "gates", "rebuilt", "lemma")

    def __init__(self) -> None:
        self.ok = False
        self.reasons: List[str] = []
        self.gates: List[Tuple[str, bool]] = []
        self.rebuilt: Optional[Derivation] = None
        self.lemma: Optional[Lemma] = None

    def gate(self, name: str, passed: bool, why: str = "") -> bool:
        self.gates.append((name, passed))
        if not passed:
            self.reasons.append("%s: %s" % (name, why or "failed"))
        return passed

    def __repr__(self):
        tag = "ACCEPT" if self.ok else "REJECT"
        return "%s [%s]%s" % (
            tag, " ".join("%s=%s" % (n, "ok" if p else "FAIL")
                          for n, p in self.gates),
            "" if self.ok else " -- " + "; ".join(self.reasons))


def ground(t: Term) -> Term:
    """Replace pattern variables by fresh ground indeterminates, order-preserving.

    ``#k`` becomes ``$gk``.  Index order is preserved so that the canonical
    ordering the rewriter uses on the ground rebuild mirrors the ordering it
    used on the mined instances -- otherwise gate G4 would fail for a purely
    cosmetic reason.
    """
    sigma = {v.val: V("%s%d" % (GROUND_PREFIX, int(v.val[1:])))
             for v in pvars_of(t)}
    return subst(t, sigma)


def verify(lhs: Term, rhs: Term, expected_rules: Optional[Sequence[str]] = None,
           ctr: Optional[Counter] = None,
           reconstruct: Optional[bool] = None) -> Verdict:
    """Run the seven gates on a proposed lemma ``lhs ==> rhs``."""
    v = Verdict()
    if ctr is None:
        ctr = Counter()

    # G1 -- well-formedness
    lvars = {x.val for x in pvars_of(lhs)}
    rvars = {x.val for x in pvars_of(rhs)}
    if not v.gate("G1", (rvars <= lvars) and lhs.addr != rhs.addr
                  and not is_pvar(lhs),
                  "rhs variables %s not covered by lhs %s, or trivial"
                  % (sorted(rvars), sorted(lvars))):
        return v

    # G2 -- LGG soundness (only meaningful when mined)
    v.gate("G2", True if reconstruct is None else reconstruct,
           "mined instances not recoverable from the generalisation")
    if reconstruct is False:
        return v

    glhs, grhs = ground(lhs), ground(rhs)

    # G3 -- rebuild the proof of the generalised statement
    try:
        reb, _ = normalize(glhs, lemmas=(), ctr=ctr, name="rebuild")
    except Divergence as exc:
        v.gate("G3", False, "rebuild diverged: %s" % exc)
        return v
    v.gate("G3", True)
    v.rebuilt = reb

    # G4 -- proof fidelity to the mined sub-DAG
    if expected_rules is not None:
        v.gate("G4", tuple(reb.rule_seq()) == tuple(expected_rules),
               "rebuilt %s != mined %s"
               % (list(reb.rule_seq()), list(expected_rules)))
    else:
        v.gate("G4", True)

    # G5 -- endpoint.  The mined rhs need not already be normal, so compare
    # normal forms; both sides are then literally the same address.
    try:
        nrhs, _ = normalize(grhs, lemmas=(), ctr=ctr, name="rhs-nf")
    except Divergence as exc:
        v.gate("G5", False, "rhs normalisation diverged: %s" % exc)
        return v
    v.gate("G5", reb.result.addr == nrhs.result.addr,
           "rebuilt normal form %s != rhs normal form %s"
           % (render(reb.result), render(nrhs.result)))

    # G6 -- kernel check of every rebuilt step
    try:
        check_derivation(reb, {}, ctr)
        check_derivation(nrhs, {}, ctr)
        v.gate("G6", reb.chain_ok() and nrhs.chain_ok(), "chain integrity")
    except CheckFailure as exc:
        v.gate("G6", False, str(exc))

    # G7 -- independent semantic decision
    try:
        v.gate("G7", poly_equal(glhs, grhs),
               "%s and %s are different polynomials"
               % (render(glhs), render(grhs)))
    except ValueError as exc:
        v.gate("G7", False, "semantic check unavailable: %s" % exc)

    v.ok = all(p for _, p in v.gates)
    return v


class Book:
    """The installed-lemma library.  Not trusted: it holds only checked edges.

    Order of installation is the order of application priority, and it is
    preserved exactly, so two runs with the same installs behave identically.
    """

    __slots__ = ("lemmas", "verdicts")

    def __init__(self) -> None:
        self.lemmas: List[Lemma] = []
        self.verdicts: Dict[str, Verdict] = {}

    def table(self) -> Dict[str, Lemma]:
        return {lem.lid: lem for lem in self.lemmas}

    def install(self, lid: str, lhs: Term, rhs: Term,
                expected_rules: Optional[Sequence[str]] = None,
                ctr: Optional[Counter] = None,
                reconstruct: Optional[bool] = None,
                provenance: str = "") -> Verdict:
        v = verify(lhs, rhs, expected_rules, ctr, reconstruct)
        self.verdicts[lid] = v
        if v.ok:
            # Install the *normalised* rhs: the lemma should land as close to
            # normal form as the primitives would, or it buys fewer steps than
            # it should.  Re-generalising the normalised ground rhs is safe
            # because grounding is injective on pattern variables.
            back = {("%s%d" % (GROUND_PREFIX, int(x.val[1:]))): x
                    for x in pvars_of(lhs)}
            rhs_final = subst(v.rebuilt.result, back)
            v.lemma = Lemma(lid, lhs, rhs_final,
                            tuple(v.rebuilt.rule_seq()), provenance)
            self.lemmas.append(v.lemma)
        return v

    def install_candidate(self, lid: str, c: Candidate,
                          ctr: Optional[Counter] = None) -> Verdict:
        return self.install(
            lid, c.lhs, c.rhs, expected_rules=c.rule_names, ctr=ctr,
            reconstruct=reconstruction_ok(c),
            provenance="mined from %s (support %d, %d steps)"
                       % (",".join(s.deriv.name for s in c.instances),
                          c.support, c.instances[0].length))

    def __len__(self):
        return len(self.lemmas)

    def __repr__(self):
        return "Book(%s)" % ", ".join(l.lid for l in self.lemmas)


def solve(t: Term, book: Optional[Book] = None, name: str = "solve",
          ctr: Optional[Counter] = None) -> Tuple[Derivation, Counter]:
    """Normalise ``t``, optionally with an installed book, and kernel-check it."""
    if ctr is None:
        ctr = Counter()
    lemmas = tuple(book.lemmas) if book is not None else ()
    d, ctr = normalize(t, lemmas=lemmas, ctr=ctr, name=name)
    check_derivation(d, book.table() if book is not None else {}, ctr)
    return d, ctr


__all__ = ["Verdict", "Book", "verify", "ground", "solve", "GROUND_PREFIX"]
