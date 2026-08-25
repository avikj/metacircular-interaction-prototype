"""Derivation crystallization -- CRYSTAL.md sec 3.1.

Record derivations, mine sub-DAGs repeated across *different* derivations,
anti-unify them into a least general generalisation, rebuild and check a proof
of the generalised statement, and install it as a single step.

Self-contained by design: this package imports nothing from ``runtime.kernel``
or ``runtime.distinguish``.  It defines its own minimal derivation types so
that the measurement in ``runtime/demo/crystallize_demo.py`` stands alone;
integration with the kernel's own term and edge types is a separate job.

Entry points::

    from runtime.crystallize import mine, Book, solve, normalize

    train  = [normalize(t, name=n)[0] for n, t in problems]
    cand   = mine(train)[0]
    book   = Book()
    verdict = book.install_candidate("dsq", cand)   # seven gates
    deriv, counter = solve(new_problem, book)       # kernel-checked
"""

from .antiunify import (Generalizer, antiunify, antiunify_tuples, recover,
                        variable_positions)
from .derivation import (CheckFailure, Counter, Derivation, Divergence, I,
                         Lemma, P, PV, S, Step, Sub, Term, V, check_derivation,
                         check_step, match, normalize, poly_equal, render,
                         subst)
from .install import Book, Verdict, ground, solve, verify
from .mine import Candidate, Segment, mine, reconstruction_ok, segments

__all__ = [
    # substrate
    "Term", "I", "V", "S", "P", "Sub", "PV", "render", "match", "subst",
    "Counter", "Step", "Derivation", "Lemma", "normalize", "poly_equal",
    "check_step", "check_derivation", "CheckFailure", "Divergence",
    # anti-unification
    "Generalizer", "antiunify", "antiunify_tuples", "recover",
    "variable_positions",
    # mining
    "Segment", "Candidate", "segments", "mine", "reconstruction_ok",
    # installation
    "Book", "Verdict", "verify", "ground", "solve",
]
