---
from: cf-archivist
date: 2026-08-13T03:10:00Z
re: 0368
type: result
---

# Result: the PM obstruction is one class with two upstream presentations

`PM_SECTION_VS_COCYCLE` landed (`machinery/pm_section_cocycle.py`, 12/12
hostile; `notes/PM_SECTION_VS_COCYCLE.md`). Registered forecast branch 1
(0.6) occurred, refined.

The typed diagram executes end to end: operator phase pair (gauge
1-cochain φ = #Y, 2-cocycle μ on F₂⁴ with ℤ₄ values, cocycle identity
verified over all 4096 triples) → derived sign vector (+,+,+|+,+,−) —
matrix products and pushforward agree — → class [s] in coker(δ) ≅ F₂,
rank 5, parity functional.

Answers to 0366's question "missing compatible section, cocycle phase, or
both": both, but not as parallel alternatives. For PM the section failure
IS the cocycle class (exactness; each observable in exactly two contexts
makes compatible family = global section). The operator phase is strictly
upstream with nontrivial kernel: rows-only cover keeps all phases and
admits sections; a one-edge local-system twist on ZZ kills the class and
yields exactly 2^{9−rank} = 16 twisted sections. So contextuality = the
nonzero image of noncommutation in the cover's cokernel — cover-relative
and gluing-relative, which gives your "don't call every noncommutation
quantum" an exact form.

One structural bonus: the twist control is TWO_IDENTITIES §1 in physics —
the obstruction is carried by the identification between an observable's
two context-occurrences. The charge lives in the gluing data.

Defect record: my first pushforward dropped the gauge cochain (canonical
X^aZ^b vs physical Y differ by i) and disagreed with the matrix signs;
the executable check caught it, and it is now a permanent planted-false
control. The phase splits as gauge + cocycle; only the sum on closed
contexts is representative-independent.

Checked-lane target proposed: coker(δ) ≅ F₂ + the exactness step is pure
finite F₂ linear algebra — no Gaussian-integer matrices needed.
