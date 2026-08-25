"""L3 -- execution: the geodesic engine.

CRYSTAL.md Sec.2 L3:

    Every accepted equality may become a rewrite; every iso a transport; every
    finite classification a decision procedure; every quotient a state
    compression; every obstruction a search prune.  The runtime chooses among
    implementations by declared task and a **cost vector**, keeping
    nondominated routes rather than collapsing to one scalar fitness.

Built here: the first clause (checked rewriting), e-matching modulo proved
equalities, task-bounded equality saturation, and cost-vector extraction with a
Pareto frontier.  Transports, decision procedures, state compressions and
search prunes are **not** built; see ``README.md``.

    rewrite   accepted equality -> checked rewrite rule; every application
              emits a justification that ``kernel/check.py`` accepts
    ematch    pattern -> substitutions, matched against e-classes rather than
              terms, with an explicit and reported bound
    saturate  rules -> fixpoint or a declared budget, and it says which
    extract   e-class -> the Pareto frontier of nondominated routes under a
              four-component exact cost vector

Imports run strictly downward into ``runtime/kernel``, which is BUILT and is
never modified from here.  Nothing in this package is trusted by the checker.
"""

from __future__ import annotations

from .ematch import (  # noqa: F401
    EMatch,
    EMatchBudget,
    EMatchResult,
    Program,
    canonical_member,
    class_members,
    compile_pattern,
    ematch,
    ematch_rule,
)
from .extract import (  # noqa: F401
    DEFAULT_DAG_BOUNDS,
    ClassExtractor,
    ClassOption,
    ClassSolution,
    RouteFinder,
    COST_NAMES,
    CostVector,
    ExtractionResult,
    FrontierDiff,
    Route,
    ScalarChoice,
    Scalarization,
    arith_width,
    dominates,
    extract_class_frontier,
    extract_routes,
    frontier_diff,
    is_nondominated,
    literal_value,
    measure_route,
    pareto,
    scalarize,
)
from .rewrite import (  # noqa: F401
    Rewrite,
    RewriteError,
    Rule,
    apply_rule,
    const_symbols,
    count_steps,
    expand_path,
    install_theorem,
    match,
    positions,
    replace_at,
    reverse_path,
    rewrite_all,
    rule_from_axiom,
    rule_from_edge,
    substitute_path,
    subterm_at,
    term_size,
    vars_of,
)
from .saturate import Application, Budget, SaturationResult, saturate  # noqa: F401

__all__ = [
    "Rule", "Rewrite", "RewriteError", "rule_from_axiom", "rule_from_edge",
    "install_theorem", "match", "apply_rule", "rewrite_all", "positions",
    "subterm_at", "replace_at", "const_symbols", "vars_of", "term_size",
    "count_steps", "reverse_path", "substitute_path", "expand_path",
    "EMatch", "EMatchBudget", "EMatchResult", "ematch", "ematch_rule",
    "class_members", "canonical_member",
    "Budget", "SaturationResult", "Application", "saturate",
    "COST_NAMES", "CostVector", "Route", "ExtractionResult", "Scalarization",
    "ScalarChoice", "FrontierDiff", "literal_value", "arith_width",
    "measure_route", "extract_routes", "dominates", "is_nondominated",
    "pareto", "scalarize", "frontier_diff", "RouteFinder",
    "ClassOption", "ClassSolution", "ClassExtractor",
    "extract_class_frontier", "DEFAULT_DAG_BOUNDS",
]
