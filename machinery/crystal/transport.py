"""The second edge type: checked interpretations between theories.

An equality edge says two terms of one theory are the same. An
interpretation edge says a whole theory *is* another theory seen through a
translation -- and once it is checked, every theorem already compiled about
the target becomes executable about the source, with no further compilation.

This is the first point at which the graph being *typed* does work. An
interpretation is not a relabelling: it may reverse the order of arguments,
and whether it does is part of its type. Groups map to groups by an
anti-isomorphism that sends x*y to phi(y)*phi(x); silently treating that as
an isomorphism gives wrong answers on the first non-commutative example.
The kernel therefore never infers the map -- it is declared and then
checked against the source theory's own axioms.

Attribution: interpretations between equational theories, and the fact that
a faithful interpretation transports decidability, are standard universal
algebra / model theory (theory morphisms in the sense of institutions;
Enderton for relative interpretability). Nothing here is new mathematics.
What the module supplies is the check and the ledger.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Callable, Optional

from machinery.crystal.kernel import Completion, Term, mk


@dataclass
class Interpretation:
    """A signature map from a source theory into a target theory.

    `clauses` maps a source symbol, by arity, to a term of the target
    signature written in the formal variables ?0, ?1, ... . The map is
    extended to all terms homomorphically.
    """

    name: str
    clauses: dict[tuple[str, int], Term]
    source_axioms: list[tuple[str, Term, Term]]
    target: Completion
    checked: bool = False
    failures: list = None
    cost_to_check: int = 0

    def apply(self, t: Term) -> Term:
        """Translate a source term into the target signature."""
        if t.is_var:
            return t
        img = self.clauses.get((t.head, len(t.args)))
        if img is None:
            # symbols with no clause are carried across unchanged, after
            # their arguments are translated
            return mk(t.head, *(self.apply(a) for a in t.args))
        sub = {f"?{i}": self.apply(a) for i, a in enumerate(t.args)}
        return _plug(img, sub)

    def check(self) -> bool:
        """The kernel step. An interpretation is accepted only if every
        source axiom becomes a theorem of the target. Failure is reported
        with the offending axiom, never rounded off."""
        self.failures = []
        steps = 0
        for name, l, r in self.source_axioms:
            ok, s = self.target.decides(self.apply(l), self.apply(r))
            steps += s
            if not ok:
                self.failures.append((name, l, r))
        self.cost_to_check = steps
        self.checked = not self.failures
        return self.checked

    def decides(self, l: Term, r: Term) -> tuple[bool, int]:
        """Decide a SOURCE equation using the TARGET's compiled system.

        This is the transport. The source theory was never compiled."""
        if not self.checked:
            raise RuntimeError(
                f"interpretation {self.name!r} is unchecked or rejected; "
                "it may not be used to decide anything"
            )
        return self.target.decides(self.apply(l), self.apply(r))


def _plug(template: Term, sub: dict[str, Term]) -> Term:
    if template.is_var:
        return sub.get(template.head, template)
    if not template.args:
        return template
    return mk(template.head, *(_plug(a, sub) for a in template.args))


def arg(i: int) -> Term:
    """The i-th formal argument slot in an interpretation clause."""
    return mk(f"?{i}")
