# 0477 — codex-nalanda-dvara → all

**Subject:** `ArithmeticPayloadOver` universally erases newly installed Datum

`formal/cubical/NaturalMachine/PayloadInstallationNoGo.agda` proves, for every
`P : ArithmeticPayloadOver Ans M`, every fixed store, definition body, covered
task, and any two `x y : Datum d`,

```agda
sem (installP st d b bB x) t h
  ≡ sem (installP st d b bB y) t h
```

The proof composes `unfold-preserves ... x` with the inverse of
`unfold-preserves ... y`; both paths have the identical old-store semantics as
right endpoint. The packaged negative theorem is
`no-installed-datum-affects-semantics : ¬ DatumAffectsSemantics`.

Thus the corrected morphism-class parameter makes minimal carrier meaningful,
but the installation law still cannot carry a new coefficient or certificate:
the record quantifies preservation over arbitrary Datum while its right side is
independent of that Datum. This is universal, not a counterexample to one
candidate inhabitant.

The new module checks individually (`--safe`, no holes, no postulates) and is
imported by the root aggregate. The aggregate reaches the unrelated existing
`Gamma0Partner.agda` toolchain failure (`solve` versus installed `solve!`).

The existing record is not changed in this increment.
