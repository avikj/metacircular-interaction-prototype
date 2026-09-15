# Full-runtime list transport

Apply the corrective patch **after** the existing cubical patch, from the
Bend2 checkout at `f026483`:

```sh
# Set CORPUS to an absolute path to this repository.
git apply "$CORPUS/collab/bend2-cubical/cubical-paths.patch"
git apply "$CORPUS/collab/bend2-cubical/list-transport.patch"
# Then build as described in HANDOFF.md.
```

For an already patched compiler checkout, apply only `list-transport.patch`.
This is an ordered follow-up patch to the same compiler source, not a second
whole-file implementation. No changes to universe rules or the checker are made.

## Bug and fix

The checker maps coercion over list constructors, but the full HVM emitter's
`@coeT` treated `#List` as rigid and returned its input unchanged. In particular,
transporting `[True]` along `i -> List(ua(not) @ i)` returned `[True]` instead of
`[False]`.

The runtime now mirrors the checker's constructor rule. An empty list stays
empty. A cons transports its head along the element-type line and its tail
using that same element type. A neutral spine remains an explicit
`#StuckListCoe` carrying the line, endpoints, element type, and spine; it is not
silently accepted as an identity transport. Equal-endpoint handling is unchanged.

The dispatch at `#IMark` has already selected an element type, including any
correlated branch choice. The helper retains that selected type and uses
`@coeT` for each head rather than resampling the entire list line at each
recursive call. A naive recursive `@coe` fix duplicates results on a correlated
line/value test; the regression counts multiplicities and catches that error.

The helper matches the spine before binding arguments for the individual arms.
Only the cons arm duplicates the line, endpoints, and selected element type.
Its binder names are unique to the helper, avoiding accidental collisions with
other prelude clone labels.

## Regression test

```sh
python3 collab/bend2-cubical/test_list_transport.py --hvm /path/to/hvm
```

The runner extracts **the actual literal prelude** from `Target/HVM4Full.hs` in
`cubical-paths.patch`, applies the follow-up patch in a temporary directory, and
executes the old and new preludes on HVM4. It does not replace transport with a
Python model, and it does not normalize the source with the checker first.
The old prelude must reproduce the unchanged singleton, not merely fail to run.
The patched prelude is checked on 26 cases, including both directions, nested
lists, function/pair elements, a non-involutive equivalence, changed element
representations, correlated/independent superpositions, sharing, and non-strictness
of empty lists and unrequested tails.

`--check-only` validates extraction and patch application without HVM; it is not
a native execution result. A new path-filtered CI workflow runs the native tests
against a pinned HVM4 source revision with read-only repository permissions.

This test targets the emitted runtime directly. It does not claim to rebuild or
verify the entire Bend checker, compiler, or Agda corpus.
