# RESULT — zero-pivot relocation preserves the orbit invariants, not raw-pivot descent

Literal no-redraw Draw 9 selected
`notes/ARITHMETIC_LIFE_ZERO_PIVOT_CLASSIFICATION.md`.  The note's total Smith
producer and termination claim are already subsumed by the checked
`GeneralSmith2x2.smith`; this result extracts a smaller nonduplicate seam in
`formal/pairfield/Pairfield/ZeroPivotRelocationInvariant.lean`.

The checked row-first route is classified exactly:

```text
row      iff a10 != 0
column   iff a10 = 0 and a01 != 0
endpoint iff a10 = 0 and a01 = 0.
```

`relocate` packages the corresponding left swap, right swap, or identity as a
`Reduction`.  Under `a00 = 0`, the endpoint is exactly `diag(0,a11)`.  Two
generic theorems prove that every `Reduction` preserves determinant magnitude
and matrix content; the relocation specializations follow immediately.

The visible pivot is not itself a global descent measure.  Every nonendpoint
relocation from pivot zero strictly increases its absolute value.  The control
`[[0,7],[3,11]]` exercises row precedence, selects pivot `3`, and refutes a
universal strict-decrease claim.  The leaf does not supply a new Smith
normalizer, termination argument, operation optimum, higher-dimensional
classification, or physical conservation law.

Focused `lake env lean Pairfield/ZeroPivotRelocationInvariant.lean` exits zero
without output.  The first replay required only proof-surface repairs: explicit
decision-tree cases for the three iff theorems, record extensionality for the
endpoint, correct namespace placement for the generic invariants, and the
available `Int.natAbs_pos` interface.  Shannon independently replayed and
hostile-reviewed the final bytes: PASS, including route precedence, swap
orientations, determinant/content replay, strict pivot rise, and all scope
fences.

Draw provenance: origin
`1abc7a207b2d44f3f88320031ad9c251692574dd`, tree
`88b76e555fd274002daa03dab5c27068174fada1`; 1,081-path C-sorted semantic
frame excluding build products and eight prior samples; frame SHA-256
`0c4c9d6f5c5d044f629edc2f88a9dbe8d4e35d7c8da086f3a87d2a6675601d32`;
rejection limit `4294966502`; sole `/dev/urandom` uint32 `3919316207`, zero
rejections, index 448 (position 449); selected blob
`7b07e27c814a38c8b1781930f2454cb952fbe6a3`.  No redraw.
