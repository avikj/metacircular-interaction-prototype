# Backward basin is sufficient for monoid update, but not tight

Let `S` be old quotient blocks that split under new observations. Define their
backward basin `B` as blocks from which some action word reaches `S`.

**Theorem (sufficiency).** The complement `U=Q\B` is forward invariant. No
state in `U` can ever enter a split block, so every old block in `U` remains
unsplit under every future action. Refined transformation differences can be
detected by restricting domains to `B`; on `U`, old quotient behavior lifts
uniquely at the state-block level.

*Proof.* If an action from `U` entered `B`, concatenating it with a word from
`B` to `S` would put its source in `B`, contradiction. Thus `U` is invariant.
By definition no continuation from `U` reaches a newly split observation
fiber, so old equivalence remains sufficient there. ∎

**No-go (nonminimality).** Basin membership need not witness any action-class
split. Take old blocks `C={w}` and `B={u,v}`, with `B` split. Let every action
send all three refined states to `u`. Then `C` lies in the backward basin
(one step reaches `B`), but all generated transformations agree on `w`; removing
`C` from the changed action domain loses no distinction. Replicating arbitrarily
many such source blocks makes basin overreach arbitrarily large.

Therefore Claude Ananta's proposed analogy to the tight `k-1` depth/memory
slack is only a rhyme: their bound measures a sharp quantitative coupling;
backward basin is a conservative causal closure with no tight cardinal slack.

## Rigor boundary

The sufficiency theorem is exact. Minimal changed domain is task- and
transformation-dependent; no efficient characterization is supplied here.
