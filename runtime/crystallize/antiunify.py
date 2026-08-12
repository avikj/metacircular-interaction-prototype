"""First-order anti-unification (Plotkin / Reynolds least general generalisation).

The whole content of the algorithm is one discipline:

    a *consistent* map from tuples-of-mismatched-subterms to variables.

If two positions in the input carry the same tuple of disagreeing subterms,
they must receive the **same** variable; if they carry different tuples they
must receive **different** variables.  Drop that and you still get a
generalisation -- just not the least one, and in this runtime "not least"
means "false".  Concretely, generalising

    (x+y)*(x-y)      and      (u+v)*(u-v)

with a consistent map gives ``(#0+#1)*(#0-#1)``, whose normal form really is
``#0*#0 - #1*#1``.  Without the map you get ``(#0+#1)*(#2-#3)``, and the
claimed lemma ``(#0+#1)*(#2-#3) = #0*#0 - #1*#1`` is simply not true.  The
mined pattern looks identical in both cases; only the variable map separates
a theorem from a falsehood.  :mod:`runtime.crystallize.install` refuses the
second one, and ``test_crystallize.py`` plants it deliberately.

Complexity: ``generalize`` visits each position of the shape-intersection of
its inputs exactly once, so it is ``O(k * m)`` for ``k`` inputs whose common
shape has ``m`` positions -- linear, no search, no backtracking.
"""

from __future__ import annotations

from typing import Dict, List, Optional, Sequence, Tuple

from .derivation import (PV, Term, is_pvar, match, mk, pvars_of, render, subst)


class Generalizer:
    """Stateful LGG computation.  One instance = one shared variable map.

    Reuse the same instance across several generalisations (e.g. the input
    side and the output side of a mined lemma) so that a mismatch appearing on
    both sides gets one variable, which is what makes the lemma's right-hand
    side expressible in the left-hand side's parameters.
    """

    __slots__ = ("_table", "_order")

    def __init__(self) -> None:
        # key: tuple of addresses of the disagreeing subterms, in input order
        self._table: Dict[Tuple[str, ...], Term] = {}
        self._order: List[Tuple[Tuple[str, ...], Tuple[Term, ...]]] = []

    # -- the variable map ------------------------------------------------
    def var_for(self, terms: Sequence[Term]) -> Term:
        key = tuple(t.addr for t in terms)
        got = self._table.get(key)
        if got is not None:
            return got
        v = PV(len(self._table))
        self._table[key] = v
        self._order.append((key, tuple(terms)))
        return v

    @property
    def arity(self) -> int:
        return len(self._table)

    def witnesses(self) -> List[Tuple[Term, Tuple[Term, ...]]]:
        """``[(variable, (t_1, ..., t_k)), ...]`` in variable-index order.

        These are the substitutions that recover each original instance from
        the generalisation -- the proof obligation discharged by
        :func:`recover`.
        """
        return [(self._table[k], ts) for k, ts in self._order]

    # -- the algorithm ---------------------------------------------------
    def generalize(self, terms: Sequence[Term]) -> Term:
        if not terms:
            raise ValueError("nothing to generalize")
        head = terms[0]
        if all(t.addr == head.addr for t in terms[1:]):
            return head  # identical: no abstraction, keep it concrete
        if (all(t.kind == head.kind for t in terms)
                and all(t.val == head.val for t in terms)
                and all(len(t.args) == len(head.args) for t in terms)
                and head.args):
            return mk(head.kind, head.val,
                      [self.generalize([t.args[i] for t in terms])
                       for i in range(len(head.args))])
        return self.var_for(terms)


def antiunify(terms: Sequence[Term]) -> Tuple[Term, Generalizer]:
    """LGG of a list of terms."""
    g = Generalizer()
    return g.generalize(terms), g


def antiunify_tuples(rows: Sequence[Sequence[Term]]) -> Tuple[Tuple[Term, ...], Generalizer]:
    """LGG of several *aligned tuples* under one shared variable map.

    ``rows`` is instance-major: ``rows[i][c]`` is component ``c`` of instance
    ``i``.  All rows must have the same length.  Returns one generalised term
    per component.  This is how a lemma's LHS and RHS are generalised together.
    """
    if not rows:
        raise ValueError("nothing to generalize")
    width = len(rows[0])
    if any(len(r) != width for r in rows):
        raise ValueError("ragged rows")
    g = Generalizer()
    out = tuple(g.generalize([r[c] for r in rows]) for c in range(width))
    return out, g


def recover(generalized: Term, instance_index: int, g: Generalizer) -> Term:
    """Reconstruct instance ``instance_index`` from the generalisation.

    Soundness witness for the LGG: for every instance ``i`` there is a
    substitution ``sigma_i`` with ``generalized . sigma_i == original_i``.
    :mod:`install` calls this on every mined instance and refuses the lemma if
    any reconstruction misses, so an over-general or mis-indexed
    generalisation cannot be installed.
    """
    sigma = {v.val: ts[instance_index] for v, ts in g.witnesses()}
    return subst(generalized, sigma)


def is_strictly_more_general(a: Term, b: Term) -> bool:
    """``a`` subsumes ``b`` but not conversely (a proper generalisation)."""
    return match(a, b) is not None and match(b, a) is None


def variable_positions(t: Term) -> Dict[str, List[Tuple[int, ...]]]:
    """Where each pattern variable occurs -- used by tests to assert that a
    repeated mismatch really did collapse onto one variable."""
    out: Dict[str, List[Tuple[int, ...]]] = {}
    stack: List[Tuple[Term, Tuple[int, ...]]] = [(t, ())]
    while stack:
        n, p = stack.pop()
        if is_pvar(n):
            out.setdefault(n.val, []).append(p)
        for i in range(len(n.args) - 1, -1, -1):
            stack.append((n.args[i], p + (i,)))
    for k in out:
        out[k].sort()
    return out


def describe(t: Term) -> str:
    return render(t)


__all__ = [
    "Generalizer", "antiunify", "antiunify_tuples", "recover",
    "is_strictly_more_general", "variable_positions", "describe",
]
