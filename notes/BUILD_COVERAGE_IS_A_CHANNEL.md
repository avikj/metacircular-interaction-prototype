# Build coverage is an information channel

**Status.** Exact finite projection result, Lean-checked in
`formal/pairfield/Pairfield/BuildCoverageChannel.lean`. Standard mathematics;
no novelty claim.

The sampled `FORMAL_LANE_HEALTH_2026_08_13.md` is a time-pinned audit. Its two
uncovered failing modules were subsequently repaired and imported, and the
Agda coverage surface was widened again. The old module census is therefore
provenance, not a current defect report. What survives every such change is
the shape of the evidence map.

Let `I` be a finite set of modules, `C ⊆ I` the modules in a gate's checked
dependency closure, and a health state be a Boolean function `h : I → Bool`.
The gate observation is restriction:

```text
observe_C(h) = h restricted to C.
```

The checked module proves an explicit equivalence

```text
(I → Bool)  ≃  (C → Bool) × ((I \ C) → Bool).
```

Consequently, the fibre over every observed result is explicitly equivalent
to the assignments on omitted modules. For finite `I`, its size is therefore
`2 ^ |I \ C|`. This is not a probabilistic estimate: it is the exact ambiguity
of the projection channel.

The same adapter proves that `observe_C` has a left decoder reconstructing the
whole health vector exactly iff `C = I`. If even one module is omitted, changing
only that module yields two unequal health states with the same gate output.
The repository lesson is precise: a passing root build certifies its import
closure; it certifies a whole declared corpus only when coverage is itself
checked.

Coverage is not the only loss. The sampled audit also distinguishes a clean
pass from a pass carrying `UnsupportedIndexedMatch` warnings, although both
have exit code zero. The Lean control declares three terminal verdicts:
`failed`, `passedWithWarning`, and `passedClean`. Mapping them to the exit bit
is noninjective and has no left decoder. Adding a warning bit makes the report
injective for this declared three-verdict model. Thus two boundaries must not
be merged:

1. dependency coverage decides which modules are observed;
2. report granularity decides which facts about each check survive.

The theorem does not say that every warning invalidates a proof, that the
current Agda aggregate is broken, or that one warning bit captures warning
content. It says only that an evidence claim cannot reconstruct information
its declared observation map erased.

Verification:

```text
cd formal/pairfield
lake env lean Pairfield/BuildCoverageChannel.lean
```

The focused command exits zero without warnings. No Python and no numerical
census were used.
