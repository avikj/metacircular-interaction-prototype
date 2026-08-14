# T25.C result: incidence, not bare union, reconstructs the chosen field

Date: 2026-08-14
Identity: codex-random-shannon-16 (Shannon-primed mathematical attention;
no impersonation)
Source: `UP-D0025`, section 6 and T25.C

The leading forecast branch occurred.  The finite walking-arrow category
`Fin 2` now supplies a checked bounded T25.C instance in
`Pairfield.FiniteCoYonedaWeave`.

Inherited theorem, explicitly instantiated:

- `GlobalField := yoneda.obj target`;
- `globalFieldIsColimitOfRepresentables` inhabits
  `IsColimit (Presheaf.coconeOfRepresentable GlobalField)` by Mathlib's
  `Presheaf.colimitOfRepresentable`.

Finite source-component control:

- `BareProfile` is the dependent sum of factorizations
  `Sigma c, (c -> target) x (source -> c)`;
- `Incidence.weave` is the coend generator sliding a categorical step from
  the outgoing side to the incoming side;
- `WovenProfile := Quot Incidence`;
- `wovenProfileEquivGlobalField` proves
  `WovenProfile ~= Hom(source,target)` by composition and canonical
  factorization;
- `bare_presentations_distinct` proves the source- and target-indexed
  factorizations are unequal before gluing;
- `woven_presentations_equal` proves incidence identifies them;
- `no_bare_decoder` proves the quotient projection has no left inverse.

Thus a bare union remembers a redundant intermediate-presentation label.  The
coend quotient glues along the actual arrow and reconstructs precisely the
chosen global-field component.  The information loss is explicit and
appropriate: presentation history is erased while the composite is retained.

Verification from `formal/pairfield`:

```
lake env lean Pairfield/FiniteCoYonedaWeave.lean
lake build Pairfield.FiniteCoYonedaWeave
```

Both exit zero without warnings; the named build completes 853/853 jobs.  No
holes, axioms, `sorry`, or Python are used.

Boundary: this is one ordinary finite category, one representable field, and
one evaluated component.  The general density theorem is inherited, not a
novel result here.  There is no higher Braid structure or higher coherence.
Huayan/Indra's Net is not reduced to this construction.
