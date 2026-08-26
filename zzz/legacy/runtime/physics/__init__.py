"""The physics / light layer: dimensions, exact optics, and the geodesic bridge.

CRYSTAL.md Sec.1 asks for physical dimensions in the native IR; Sec.2 L3 asks
for route selection under a cost vector.  This package supplies the first and
then tests, rather than asserts, the claim that the second is *the same
machinery* that finds a light ray:

    dimension   exact rational exponent vectors; ill-dimensioned quantities
                cannot be constructed, and the dimension is inside the address
    optics      exact geometric optics over rational indices and rational
                coordinates; optical path lengths compared exactly as sums of
                rational multiples of square roots, never numerically
    geodesic    the bridge: one Dijkstra, one Pareto frontier, two physics --
                plus the exact statement of where the identification breaks

Pure Python 3 stdlib, CPU only, exact arithmetic only.  No float is constructed
anywhere in this package and no ``/`` operator appears in its source; both are
asserted by an AST walk in ``runtime/tests/test_physics.py``.

Imports run strictly downward into ``runtime/kernel`` (BUILT) and
``runtime/execute`` (BUILT).  Neither is modified from here, and nothing here is
trusted by the checker.
"""

from __future__ import annotations

# Import the submodules FIRST and keep them bound: `runtime.physics.dimension`
# and `runtime.physics.geodesic` are the *modules*.  The free functions
# `dimension.dimension()` and `geodesic.geodesic()` would shadow them if
# re-exported under their own names, so at package level they are
# `make_dimension` and `find_geodesic`.  Inside the submodules the natural
# names are unchanged: `from runtime.physics.geodesic import geodesic`.
from . import dimension, geodesic, optics  # noqa: F401

from .dimension import (  # noqa: F401
    AREA,
    ACCELERATION,
    AMOUNT,
    BASE_DIMENSIONS,
    CURRENT,
    DIMENSIONLESS,
    Dimension,
    DimensionError,
    FREQUENCY,
    LENGTH,
    LUMINOUS,
    MASS,
    Quantity,
    SPEED,
    TEMPERATURE,
    TIME,
    VOLUME,
    add_terms,
    exact,
    plus_of,
    quantity,
    sort_of,
    term_of,
)
from .dimension import dimension as make_dimension  # noqa: F401
from .optics import (  # noqa: F401
    Critical,
    InterfaceStack,
    Medium,
    MirrorArc,
    OpticsError,
    Ray,
    Surd,
    Vec,
    compare_scaled_sqrt,
    critical_points,
    integer_sqrt,
    is_perfect_square,
    lattice,
    optical_path_length,
    reflection_residual,
    circle_tangent,
    sine_to_normal,
    snell_invariant,
    snell_residual,
    squarefree_part,
)
from .geodesic import geodesic as find_geodesic  # noqa: F401
from .geodesic import (  # noqa: F401
    Arc,
    ConvexityCertificate,
    GeodesicError,
    GeodesicResult,
    MirrorRouteProblem,
    NOT_SHARED,
    OpticalCost,
    OpticsRouteProblem,
    ProofRouteProblem,
    Realization,
    RouteProblem,
    SHARED_CODE,
    SnellBracket,
    TrustBoundaryError,
    certify_optical_length,
    convexity_certificate,
    mirror_routes,
    optical_frontier,
    optical_routes,
    realize,
    snell_bracket,
)

__all__ = [
    # dimension
    "BASE_DIMENSIONS", "DimensionError", "Dimension", "make_dimension", "Quantity",
    "quantity", "exact", "sort_of", "term_of", "plus_of", "add_terms",
    "DIMENSIONLESS", "LENGTH", "MASS", "TIME", "CURRENT", "TEMPERATURE",
    "AMOUNT", "LUMINOUS", "AREA", "VOLUME", "SPEED", "ACCELERATION", "FREQUENCY",
    # optics
    "OpticsError", "Surd", "Vec", "Medium", "Ray", "InterfaceStack", "MirrorArc",
    "Critical", "critical_points", "optical_path_length", "snell_residual",
    "snell_invariant", "sine_to_normal", "compare_scaled_sqrt", "integer_sqrt",
    "reflection_residual", "circle_tangent",
    "is_perfect_square", "squarefree_part", "lattice",
    # geodesic
    "Arc", "RouteProblem", "GeodesicResult", "find_geodesic", "GeodesicError",
    "ProofRouteProblem", "OpticsRouteProblem", "MirrorRouteProblem",
    "OpticalCost", "optical_routes", "optical_frontier",
    "certify_optical_length", "ConvexityCertificate", "convexity_certificate",
    "SnellBracket", "snell_bracket", "Realization", "realize", "mirror_routes",
    "TrustBoundaryError", "SHARED_CODE", "NOT_SHARED",
]
