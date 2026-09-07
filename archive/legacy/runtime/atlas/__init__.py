"""`runtime/atlas` -- the six charts of N, executable.

`notes/ATLAS_OF_N.md` proves six charts of N with their transition maps and
residuals; `formal/cubical/NaturalMachine/` type-checks two of them.  This
package makes the rest executable in the runtime: each chart is a construction
with operations, each transition is a typed kernel edge verified exhaustively on
a stated finite range, and each residual is a computed object -- a group with an
order, a torsor with a freeness report, a cocycle with a coboundary search -- and
never a string.

    charts.py       the six charts, plus the two incomparable completions
    transitions.py  the transition maps as typed kernel edges
    residual.py     the groups / torsors / cocycles attached to each transition

CPU-only, pure stdlib, exact, deterministic, counted.  No float is constructed.
"""

from .charts import (  # noqa: F401
    CH,
    CHARTS,
    ArchimedeanWindow,
    BAdicWindow,
    CardinalChart,
    Chart,
    ChartError,
    ClaimVerdict,
    CompletionClaim,
    DigitChart,
    OMEGA,
    Ordinal,
    OrdinalChart,
    PeanoChart,
    PrimeChart,
    Reachability,
    ReachabilityReport,
    TallyChart,
    badic_gauge,
    badic_valuation,
    chart,
    church,
    normal_value,
    primes_up_to,
    two_completions_report,
)
from .residual import (  # noqa: F401
    COCYCLE,
    GROUP,
    INVARIANT,
    OBSTRUCTION,
    TORSOR,
    Cocycle,
    FiniteGroup,
    Residual,
    ResidualError,
    ResidualReport,
    Torsor,
    carry_cocycle,
    cyclic_group,
    exhaustive_section_search,
    splitting_exponent_argument,
    symmetric_group,
    trivial_group,
)
from .transitions import (  # noqa: F401
    CONTRACTIBILITY_SCOPE,
    KIND_REQUIREMENTS,
    TRANSITIONS,
    AtlasReport,
    BijectionReport,
    InstallReport,
    Transition,
    TransitionError,
    TrustBoundaryError,
    build_atlas,
    contractibility_report,
    exhaustive_map_report,
    transition,
)

__all__ = [
    "CH", "CHARTS", "ArchimedeanWindow", "BAdicWindow", "CardinalChart", "Chart",
    "ChartError", "ClaimVerdict", "CompletionClaim", "DigitChart", "OMEGA",
    "Ordinal", "OrdinalChart", "PeanoChart", "PrimeChart", "Reachability",
    "ReachabilityReport", "TallyChart", "badic_gauge", "badic_valuation", "chart",
    "church", "normal_value", "primes_up_to", "two_completions_report",
    "COCYCLE", "GROUP", "INVARIANT", "OBSTRUCTION", "TORSOR", "Cocycle",
    "FiniteGroup", "Residual", "ResidualError", "ResidualReport", "Torsor",
    "carry_cocycle", "cyclic_group", "exhaustive_section_search",
    "splitting_exponent_argument", "symmetric_group", "trivial_group",
    "CONTRACTIBILITY_SCOPE", "KIND_REQUIREMENTS", "TRANSITIONS", "AtlasReport",
    "BijectionReport", "InstallReport", "Transition", "TransitionError",
    "TrustBoundaryError", "build_atlas", "contractibility_report",
    "exhaustive_map_report", "transition",
]
