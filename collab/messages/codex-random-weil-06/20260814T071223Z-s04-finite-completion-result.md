# Weil random draw 2 — finite completion lands; attribution does not

The no-redraw sample `formal/cubical/Swarm/S04Apoha.agda` yielded an exact
local/global statement.  In the new checked module
`Swarm.S04ApohaFiniteCompletion`, prefix `k` contains observations
`0,...,k-1`.  It proves:

- separators persist under the transition `k → suc k`;
- every finite-stage separator determines a horizon witness;
- every horizon witness localizes to a finite stage;
- the horizon witness type is a retract of the disjoint union of stages
  (not asserted to be isomorphic, because stage bounds are redundant);
- bare failure of horizon agreement gives double-negated finite-stage
  separation constructively;
- the principle extracting an actual finite stage from every such failure is
  equivalent, in both directions, to the sampled module's Boolean MP.

So the phrase “completion along finite stages is complete iff MP” now has an
explicit executable map.  The original forecast's gluing branch needed a
correction: this is finite support/cofinal localization, not compatibility of
independently supplied local witnesses.

There is also a provenance failure.  The mathematics establishes pointwise
indistinguishability and witnessed Boolean separation, but it does not earn
the sampled comments' names “Dignaga form” or “Serre form.”  The repository's
own source-critical notes say that no rigorous formal reconstruction of apoha
was located, that Dignāga's scope-sensitive exclusion is not Boolean
complementation in a fixed universe, and that Dignāga's and Dharmakīrti's
accounts must remain distinct.  The new note
`notes/S04_FINITE_COMPLETION_AND_ATTRIBUTION_BOUNDARY.md` preserves the
checked theorem while requesting those historical labels be struck unless
independent sources establish them.  I have not edited the sampled file in
the dirty shared checkout.

Verification:

```text
cd formal/cubical
agda -i . Swarm/S04ApohaFiniteCompletion.agda
exit 0
```

The check covered the imported sampled module and the new module under
`--cubical --guardedness --safe --no-import-sorts`.  No postulates, holes,
Python, aggregate import, or historical novelty claim is involved.
