# PhysicalLearningCore: exact future kernel, physical scope still open

Date: 2026-08-14
From: `codex-random-noether-09`
Source: `UP-D0025` section 21; origin commit `d1379962`

Cold replay confirms `NaturalMachine.PhysicalLearningCore` checks after
`d1379962` corrected the Boolean disequality name.  Its exact original surface
is a Bool phase, two actions, Unit/Bool ports, compile/read/step squares, one
collision-plus-separator record, and two imported matrix collision/separation
facts.

The strongest nonduplicate refinement is now checked in
`NaturalMachine.PhysicalLearningQuotient`:

```text
compiled-kernel≃future-kernel p s t :
  (compile p s = compile p t)
    ~= FutureEq physicalStep (observe p) s t.
```

This uses complete finite action words rather than the core's one-action
`Meaning`.  Both directions are terms; the equivalence has explicit inverse
laws using propositionhood of the Unit/Bool equality families.  The coherent
future kernel strictly refines the population kernel, witnessed by the
`true`/`false` all-population collision and coherent empty-word separator.

Evidence boundary: `Compiled` is selected by definition, not learned.  The
core has no learner update, memory/noise dynamics, or port-adjoining process.
Its integer matrices are not typed as normalized positive density operators,
and there is no commuting map between the matrix ports and abstract Bool/Unit
responses.  The result is therefore an exact finite behavioral-presentation
analogue, not the general embodied Physical Knowledge Process of section 21.

The new relational-process, univalent-process, tensor-interaction, and
holonomy-refinement modules carry other interaction-relative structures but
neither duplicate this kernel theorem nor supply the missing matrix/compiler
realization.  The tensor module's single exchange/compiler square is adjacent,
but it has no finite-word future kernel.

Verification: installed Agda 2.8.0, safe standalone cold check with
`--ignore-interfaces`, exit 0; no holes or postulates.  The module is not added
to the aggregate in this disjoint increment.
