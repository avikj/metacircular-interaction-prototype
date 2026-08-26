"""The coherence layer: the four views as a cover, and its Cech cohomology.

    Pairwise consistency between local views does not imply global coherence;
    where three agree the fourth may not glue; there the obstruction lives, and
    the obstruction is the result.

Three modules, one mechanism:

    views      the four local sections -- truth, action, cost, residual --
               each a real computation over runtime objects, each with a
               stated blind spot, each *structurally* unable to read another's
               data (``assert_independent`` proves it)
    cech       the nerve of the four-cover (4 vertices, 6 overlaps, 4 triples,
               1 quadruple), the presheaf of readings, the coboundary with
               exact integer coefficients, ``delta.delta = 0``, and H^0..H^3 by
               Smith normal form over Z
    holonomy   transport of a description around truth -> action -> cost ->
               residual -> truth, and the exact group element measuring the
               composite's failure to be the identity

Nothing here is retrofitted into another lane.  ``coherence_gate`` is optional
and is imported by whoever wants it; a claim whose views do not glue is
**marked with its obstruction class, never rejected**, because the obstruction
is information.

CPU-only, pure Python 3 standard library, exact integers, deterministic across
``PYTHONHASHSEED``.
"""

from .views import (  # noqa: F401
    ALL_VIEWS,
    CANNOT_SEE,
    Claim,
    IndependenceReport,
    LocalSection,
    NerveError,
    Poison,
    READERS,
    SOURCE_SCHEMA,
    VIEW_NAMES,
    VOCABULARY,
    View,
    assert_independent,
    read_action,
    read_all,
    read_cost,
    read_residual,
    read_truth,
    read_view,
    require_four_views,
    view_by_name,
    view_name,
)
from .cech import (  # noqa: F401
    ADMIT,
    COHERENT,
    DIM_COUNTS,
    DISCORD,
    MAX_DIM,
    OBSTRUCTED,
    SIMPLICES,
    SNF,
    UNASSESSABLE,
    Channel,
    Cochain,
    CochainClass,
    Cohomology,
    Disagreement,
    FourFoldCertificate,
    Presheaf,
    build_presheaf,
    classify,
    coboundary,
    coherence_gate,
    convexity_violations,
    coordinates_in_kernel,
    dim,
    disagreements,
    discord_cochain,
    faces,
    from_vector,
    glues_on,
    is_face,
    kernel_basis,
    matvec,
    section_cochain,
    simplex_name,
    simplices_of_dim,
    site_support,
    smith,
    solve_exact,
    triple_failures,
    verify_delta_squared,
)
from .holonomy import (  # noqa: F401
    LOOP,
    ClassCocycle,
    Holonomy,
    HolonomyRecord,
    Transport,
    attach_holonomy,
    class_cocycle,
    compose,
    holonomy,
    loop_edges,
    loop_simplices,
    prove_translation_holonomy_is_trivial,
    translation_transports,
)

__all__ = [
    # views
    "NerveError", "View", "ALL_VIEWS", "VIEW_NAMES", "view_name",
    "view_by_name", "CANNOT_SEE", "SOURCE_SCHEMA", "VOCABULARY", "Poison",
    "Claim", "LocalSection", "READERS", "read_truth", "read_action",
    "read_cost", "read_residual", "read_view", "read_all",
    "IndependenceReport", "assert_independent", "require_four_views",
    # cech
    "SIMPLICES", "DIM_COUNTS", "MAX_DIM", "dim", "simplices_of_dim", "faces",
    "simplex_name", "is_face", "SNF", "smith", "kernel_basis", "solve_exact",
    "coordinates_in_kernel", "matvec", "Cohomology", "Channel",
    "convexity_violations", "Presheaf", "Cochain", "from_vector", "coboundary",
    "verify_delta_squared", "CochainClass", "classify", "ADMIT", "DISCORD",
    "site_support", "build_presheaf", "section_cochain", "discord_cochain",
    "Disagreement", "disagreements", "triple_failures", "glues_on",
    "COHERENT", "OBSTRUCTED", "UNASSESSABLE", "FourFoldCertificate",
    "coherence_gate",
    # holonomy
    "LOOP", "loop_edges", "loop_simplices", "Transport",
    "translation_transports", "compose", "Holonomy", "holonomy",
    "prove_translation_holonomy_is_trivial", "ClassCocycle", "class_cocycle",
    "HolonomyRecord", "attach_holonomy",
]
