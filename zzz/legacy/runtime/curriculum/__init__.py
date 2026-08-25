"""The education layer: a curriculum order derived from mathematical dependency.

`notes/ATLAS_OF_N.md` Theorem 4.2 proves an exact statement about the natural
numbers:

    Positional notation is a chart of pi_0 requiring three choices -- a finite
    quotient (the base), a trivialization of a Z/2-torsor (the endianness), and
    a 2-cocycle representative whose class is never zero (the carry) -- on top
    of a generator/successor which it does not supply and which charts (a)-(d)
    do.  Symmetry and generation require zero choices.

This package makes that executable.  It builds the dependency graph of the
atlas's concepts with every edge carrying the theorem that forces it, counts the
parameters each concept requires, derives an order from those counts, and
compares that order against a hand-encoded model of the conventional school
sequence -- reporting, for both, the exact number of dependency edges violated
and the exact "choice debt" incurred.

```
runtime/curriculum/depgraph.py  concepts, justified edges, verbatim quote checking
runtime/curriculum/order.py     the choice metric, both orderings, the claim guard
runtime/curriculum/render.py    SVG + HTML artifacts, built on runtime/render
runtime/demo/curriculum_demo.py the artifacts and the exact report
runtime/tests/test_curriculum.py adversarial tests with planted-false controls
```

Run:

```
python3 runtime/demo/curriculum_demo.py   # writes runtime/demo/out_curriculum/
python3 runtime/tests/test_curriculum.py
```

**The standing limitation, which this package must not be read past.** What is
derived here is a *dependency order*: a fact about which constructions are
definable from which others.  It is **not** an empirical claim about how humans
learn.  Nothing here measures a learning outcome, and
``order.certify_curriculum_claim`` rejects a learning-outcome claim structurally
-- there is no learner in the domain -- exactly as ``runtime/render``'s
``certify_claim`` rejects an information-gain claim.  `ATLAS_OF_N.md`
Corollary 4.3 draws that line first and this package does not weaken it.

CPU-only, pure Python 3 standard library, exact integer arithmetic, no float in
any semantic path, no ML, no network, deterministic.
"""

from __future__ import annotations

from .depgraph import (
    ALLOWED_SOURCES,
    BASE,
    CARRY,
    ENDIANNESS,
    Concept,
    CurriculumError,
    DependencyGraph,
    Edge,
    Justification,
    build_graph,
    normalise_text,
    verify_quotes,
)
from .order import (
    ATLAS_CHOICE_NAMES,
    ATLAS_CHOICE_TABLE,
    ATLAS_GUARDRAIL,
    CLAIM_KINDS,
    CONVENTIONAL_NOTES,
    CONVENTIONAL_SEQUENCE,
    DEPENDENCY_ORDER,
    LEARNING_OUTCOME,
    AtlasAgreement,
    ComparisonRow,
    CurriculumClaimCertificate,
    DebtItem,
    DebtReport,
    Ordering,
    Violation,
    certify_curriculum_claim,
    choice_debt,
    compare,
    conventional_order,
    derive_order,
    levels,
    prove_topological,
    sort_key,
    unordered_pairs,
    verify_against_atlas,
    violations,
)

__all__ = [
    "ALLOWED_SOURCES",
    "ATLAS_CHOICE_NAMES",
    "ATLAS_CHOICE_TABLE",
    "ATLAS_GUARDRAIL",
    "AtlasAgreement",
    "BASE",
    "CARRY",
    "CLAIM_KINDS",
    "CONVENTIONAL_NOTES",
    "CONVENTIONAL_SEQUENCE",
    "ComparisonRow",
    "Concept",
    "CurriculumClaimCertificate",
    "CurriculumError",
    "DEPENDENCY_ORDER",
    "DebtItem",
    "DebtReport",
    "DependencyGraph",
    "ENDIANNESS",
    "Edge",
    "Justification",
    "LEARNING_OUTCOME",
    "Ordering",
    "Violation",
    "build_graph",
    "certify_curriculum_claim",
    "choice_debt",
    "compare",
    "conventional_order",
    "derive_order",
    "levels",
    "normalise_text",
    "prove_topological",
    "sort_key",
    "unordered_pairs",
    "verify_against_atlas",
    "verify_quotes",
    "violations",
]
