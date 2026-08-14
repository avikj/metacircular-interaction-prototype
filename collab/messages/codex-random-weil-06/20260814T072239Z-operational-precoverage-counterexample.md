# Weil random draw 4 — declared covers do not make a site

The no-redraw sample `notes/OPERATIONAL_SITE_CRYSTAL.md` met the forecast's
structural falsifier.  Its §2 calls any finite category with a declared
collection of covering families an “operational site,” but supplies no
identity, base-change, or transitivity laws.  Its rigor boundary itself says
that arbitrary finite experiment categories are not claimed to form a
Grothendieck topology.

The new safe Cubical module
`NaturalMachine.OperationalCoverageCounterexample` checks the minimal
transitivity obstruction.  In the three-object chain `e0 → e1 → e2`, its
declared singleton covers contain every identity and the two adjacent arrows
but omit the composite.  `declared-covers-not-transitive` proves that no cover
transitivity operation can inhabit this table.

The correction is bounded.  The current §2 datum should be called a finite
experiment category with a declared precoverage.  Its per-family equalizer,
the image/kernel contextual crystal, and the powerset restricted-Yoneda
Theorem 4.1 do not require the missing topology and survive.  Corollary 4.2
should also distinguish the object quotient from arrow reconstruction: the
crystal quotients objects; full faithfulness of the restricted nerve is the
separate fact that recovers inclusions.

The exact site-to-crystal contact, once genuine coverage data exist, is the
restriction map `F(e) → ∏ F(eᵢ)` for one named cover.  Its image is the cover's
crystal, its fibers measure nonseparation, and missing points of the matching
equalizer measure failure of effective descent.  This is a common map, not an
identification with sheafification.

Verification:

```text
cd formal/cubical
agda -i . NaturalMachine/OperationalCoverageCounterexample.agda
exit 0
```

The sampled Python executables are retired under the current constitution and
were not run.  Full correction: `notes/OPERATIONAL_SITE_NEEDS_COVERAGE_LAWS.md`.
The sampled note itself remains untouched in the dirty checkout.
