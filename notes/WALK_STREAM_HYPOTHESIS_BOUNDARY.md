# WalkStream equivalence under the covered-frontier hypotheses

`NaturalMachine.WalkStream.installStream` maps one universal-property proof
to another: under its stated walk hypotheses, every LCM of the newly installed
state `q ∷ S` is an LCM of the full frontier `[1..q]`.

The new safe leaf
`formal/cubical/NaturalMachine/WalkStreamHypothesisBoundary.agda` checks the
missing reverse map and the sharp boundary of both side conditions.

## Exact equivalence

Fix:

- an LCM `L` of the previously installed sensors `S`;
- a least non-divisor `q` of `L`;
- the search bound `2 ≤ q`; and
- a proof that every old sensor lies in `[1,q)`.

Then for every proposed value `M`, Agda constructs an equivalence

```text
IsLCM (q ∷ S) M ≃ IsLCM (range1 q) M.
```

The forward function is the existing `installStream`. For the reverse
function, frontier commonness covers `q` and every member of `S`. To prove
leastness, take any common multiple of `q ∷ S`. The old LCM `L` divides it;
minimality of `q` makes every `2 ≤ r < q` divide `L`; and the cases `r=1`
and `r=q` are direct. Hence that candidate is a common multiple of the whole
frontier, so the frontier LCM divides it.

Cubical divisibility is propositionally truncated. Recursive
`CommonMultiple` and `IsLCM` are therefore propositions, which upgrades the
two maps to a genuine equivalence without identifying or choosing quotient
witnesses.

## Both side conditions are load-bearing

The source comments stated two failure modes. They are now checked objects.

### The lower search bound

Remove only `2 ≤ q` and take

```text
S = []      L = 1      q = 0      M = 0.
```

The empty list has LCM `1`; `0` is a least non-divisor of `1` because
`0 ∤ 1` and its below-2 clause is vacuous; the installed state `[0]` has LCM
`0`; and the old-sensor range premise is vacuous. But `range1 0=[]`, whose
LCM cannot be `0` because an empty-list LCM must divide `1`. Thus all other
premises hold while the conclusion fails.

### Coverage of the installed state

Remove only the requirement that old sensors lie below `q`, and take

```text
S = [3]      L = 3      q = 2      M = 6.
```

Here `2 ≤ q`, `L` is the LCM of `S`, `2` is the least non-divisor of `3`,
and `6` is the LCM of `[2,3]`. But `3` is outside `[1,2)`, and `6` is not an
LCM of `range1 2=[2,1]`: leastness would force `6 ∣ 2`. This is the promised
large-sensor failure in its smallest concrete form.

The two controls are independent. The first satisfies the old-sensor range
condition but violates the lower bound; the second satisfies the lower bound
but violates the range condition. Thus neither premise can simply be deleted
from this uniform theorem. This is not an if-and-only-if classification of
every individual numerical instance.

## Scope

This result compares two LCM **universal properties**. It constructs no LCM
algorithm, sensor search, or executable walk. It does not prove that the
successive installs are prime powers or strictly ordered, identify the full
stream, derive Chebyshev `ψ`, establish an asymptotic, price runtime/storage,
or give any physical meaning to “capacity.” Those later statements require
the separate `WalkInduction`, `WalkJumps`, and analytic layers.

The equivalence is local to one supplied install step. It does not weaken or
replace either of `WalkStream`'s hypotheses.

## Draw 22 provenance

The encounter froze origin commit
`82f462103e4c86a8b45123b8a17cc2b9216f7196`, tree
`70eb945edb67cac4faa4f5d1500c68e3cf37b116`. Full immutable random provenance,
verification, and hostile review will be recorded in the result message after
the leaf is cold-checked.

No aggregate or sampled-source edit belongs to this workset.
