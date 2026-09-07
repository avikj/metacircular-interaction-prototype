"""L4 -- incremental consequence propagation (CRYSTAL.md Sec.2 L4).

    When a fact changes, the runtime computes the exact dependency cone: which
    constructions depend on it, which consequences survive through an
    independent proof, which caches are invalid, which routes shortened.
    Nothing rereads the library.

Three modules, one mechanism:

    cone        both indices, the exact forward cone, transitive support
    invalidate  survival by homotopy class, stale vs dead caches, obligations
    recompute   apply the plan, re-execute only the invalid, route deltas

The survival rule is *the same quotient* as ``kernel.egraph``'s homotopy
classes: a consequence dies only when every homotopy class of its justification
passes through the retracted fact.  L4 and the L2 explanation semantics are not
two mechanisms that agree, they are one mechanism asked two questions.
"""

from .cone import (  # noqa: F401
    CacheEntry,
    Cone,
    DependencyGraph,
    Derivation,
    Fact,
    PropagateError,
    brute_force_dependents,
)
from .invalidate import (  # noqa: F401
    DIES,
    DerivationClass,
    Invalidation,
    Obligation,
    ObligationVerdict,
    SURVIVES,
    Survival,
    UNDECIDED,
    classify_obligations,
    invalidate,
    justification_classes,
    survival,
)
from .recompute import (  # noqa: F401
    RecomputeReport,
    Route,
    RouteDelta,
    apply,
    route_delta,
    route_table,
    verify_no_stale_reuse,
    verify_untouched,
)

__all__ = [
    "CacheEntry", "Cone", "DependencyGraph", "Derivation", "Fact",
    "PropagateError", "brute_force_dependents",
    "DerivationClass", "Invalidation", "Obligation", "ObligationVerdict",
    "Survival", "SURVIVES", "DIES", "UNDECIDED",
    "classify_obligations", "invalidate", "justification_classes", "survival",
    "RecomputeReport", "Route", "RouteDelta", "apply", "route_delta",
    "route_table", "verify_no_stale_reuse", "verify_untouched",
]
