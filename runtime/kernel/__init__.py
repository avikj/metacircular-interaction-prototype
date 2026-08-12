"""The trusted heart of the crystal runtime (CRYSTAL.md Sec.2 L0-L2, Sec.5).

Layering, strictly one-directional -- nothing later is imported by anything
earlier, so the trusted core cannot be rewritten by what it judges:

    term   (L0)  exact identity: hash-consed typed terms, content addressing
      |
    edges  (L1)  the typed edge algebra: composition, preservation, epsilon
      |
    check  (L5)  the small trusted checker: witnesses, paths, composites
      |
    egraph (L2)  proof-relevant e-graph: congruence closure, proof forest,
                 retained distinct justifications, retraction, directed graph

``egraph`` depends on ``check`` (it emits ``check.Step`` objects) and never the
other way round: the checker can validate a path without importing, consulting
or trusting the e-graph that produced it.

CPU-only, pure stdlib, exact.  No float is constructed anywhere in this
package; ``Approx`` epsilons are ``fractions.Fraction``.  Every algorithm
exposes exact integer step counters (``term.COUNTERS``, ``EGraph.steps``,
``CheckContext.counters``).
"""

from .term import (  # noqa: F401
    COUNTERS,
    Counters,
    KernelError,
    SortError,
    Sort,
    Term,
    App,
    Const,
    Lam,
    Var,
    arrow,
    base_sort,
    beta_normal,
    bind,
    lookup,
    name_of,
    names_of,
    resolve,
    subst_consts,
    subterms,
    NAMES,
    NameTable,
)
from .edges import (  # noqa: F401
    ALL_PROPERTIES,
    Edge,
    EdgeError,
    KINDS,
    PRESERVES,
    SYMMETRIC,
    compose,
    compose_kind,
    compose_path,
    composition_table,
    invert,
    is_symmetric,
    preserves,
)
from .check import (  # noqa: F401
    Axiom,
    Beta,
    Certificate,
    CheckContext,
    Conjectural,
    Instantiate,
    IsoWitness,
    Refl,
    Step,
    check_composite,
    check_edge,
    check_path,
    check_step,
)
from .egraph import EGraph, EGraphError, MergeRecord  # noqa: F401

__all__ = [
    "COUNTERS", "Counters", "KernelError", "SortError", "Sort", "Term",
    "App", "Const", "Lam", "Var", "arrow", "base_sort", "beta_normal", "bind",
    "lookup", "name_of", "names_of", "resolve", "subst_consts", "subterms",
    "NAMES", "NameTable",
    "ALL_PROPERTIES", "Edge", "EdgeError", "KINDS", "PRESERVES", "SYMMETRIC",
    "compose", "compose_kind", "compose_path", "composition_table", "invert",
    "is_symmetric", "preserves",
    "Axiom", "Beta", "Certificate", "CheckContext", "Conjectural", "Instantiate",
    "IsoWitness", "Refl", "Step", "check_composite", "check_edge", "check_path",
    "check_step",
    "EGraph", "EGraphError", "MergeRecord",
]
