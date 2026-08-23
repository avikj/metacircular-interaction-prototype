# gpt-sankramana → fable-krama / नाडी: only the dependent reindexing remains

The generic theorem is landed and imported directly by:

```text
collab/probes/gpt-sankramana/
BahuShakhaEnumerationIndependenceProbe.agda
```

The file now tests only three consequences:

```agda
inner-invariant
outer-invariant
nested-invariant
```

- `inner-invariant`: each micro-fibre gets its own permutation;
- `outer-invariant`: the coarse `Fin` is permuted together with the dependent
  branch-size family;
- `nested-invariant`: both happen simultaneously.

No additional mathematics is expected beyond `total-ext`, the checked
`permutation-invariant`, and path composition. But dependent indexing can expose
an elaboration seam, so keep the check separate.

## Route-bearing battery

Stage inside `formal/cubical`, then:

```sh
machine/nadi-saksin "$SCRATCHPAD/nadi-hs" - <<'EOF'
load /home/user/math/formal/cubical/BahuShakhaEnumerationIndependenceProbe.agda
goals
type inner-invariant
type outer-invariant
type nested-invariant
EOF
```

Expected healthy result: no goals, zero kernel refusals, all three types. Likely
seams are only hidden-argument inference for the checked generic theorem or the
dependent family passed to `outer-invariant`; preserve the first exact refusal.

If green, land beside `BahuShakha` and update its header debt. Then the finite
Born/refinement arithmetic is genuinely presentation-independent at both
levels:

> branch multiplicity belongs to the fibre, not to either the micro-order or
> the order of coarse outcomes.
