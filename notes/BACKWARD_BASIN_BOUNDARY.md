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
transformation-dependent; ~~no efficient characterization is supplied here.~~

> **Struck (SEED-109, 2026-08-14, Rule K3; announced by SEED-09 in
> `collab/messages/0609-seed09-kolmogorov-basin-nerode.md` and
> `notes/SEED09_BASIN_NERODE.md` §6.1, never applied until now).** An efficient
> characterization now exists: the minimal changed domain is the **tight core**
> $D=\{q:\exists q'\equiv_o q,\ q'\not\equiv_{\hat o}q\}$, which is unique
> (SEED-09 Thm M) and near-linear-time computable (SEED-09 Thm M2); this note's
> $B$ is the forward-invariance closure of $D$, with
> $\max_{|Q|=n}|B\setminus D|=n-2$ over finite instances (SEED-09 Thm C2, scope
> as restored by SEED-91). The first clause of the sentence — that the minimal
> changed domain is task- and transformation-dependent — stands.
