# Cubical Agda coverage inventory

This is a source-level inventory made 2026-08-14. It is deliberately a
coverage report, not a claim that an unimported module is false or unusable.
The repository contains 229 local `.agda` modules under `formal/cubical/`.

## Aggregate build

`formal/check.sh` names five aggregate roots:

* `NaturalMachine`
* `ProjectionChargeAudit`
* `ProjectionChargeAudit2`
* `NaturalMachine/CapabilityGraph`
* `NaturalMachine/LawfulContinuationCore`

A shell-only transitive scan of local `open import`/`import` edges reaches
151 of the 229 local modules (66.0%). The remaining 78 modules are not in
that aggregate import closure. The scan does not count modules from the
installed Cubical library, and does not treat comments as imports.

## Standalone-checkable

The five roots above are the only modules guaranteed by the repository's
aggregate command. Individual modules may also be checked directly with:

```sh
agda -i formal/cubical formal/cubical/<Module>.agda
```

Source annotations are evidence of historical standalone checks, not a
current run record. In particular, modules containing `CHECKED` annotations
should be treated as candidates for a direct check; they are not silently
promoted into the aggregate build. `formal/check.sh` was running during this
inventory and emitted warnings but no failure before this report was written;
its final exit should be recorded separately if a CI-grade result is needed.

## Intentionally excluded

Exclusion is explicit where a module says `NOT imported`, `not part of the
checked build`, or identifies itself as a negative/control example. Examples
include:

* `NaturalMachine/Control/WrongEquivalence.agda`
* `NaturalMachine/Control/WrongFirstStep.agda`
* `TransporterPortReduction.agda`
* `SubsetSumChartDepth.agda`
* `TotientFibreSymmetry.agda`

These are not “missing” coverage: their exclusion is part of the mathematical
boundary (counterexamples, controls, or separate experiments).

## Untested / uncovered

The other 78 local modules are currently outside the five-root closure and do
not have enough machine-readable evidence here to call them aggregate-tested.
They should be labelled **untested by the aggregate build**, even when their
comments report a historical check. A future revision should add a manifest
with one of `aggregate`, `standalone`, `excluded-control`, or `untested`, and
replace this count with a checked manifest rather than inferring status from
prose.

Rigor boundary: this report certifies only the root list, file count, and
import-closure accounting. It does not certify theorem correctness, library
compatibility outside the invoked command, or the truth of historical
`CHECKED` annotations.
