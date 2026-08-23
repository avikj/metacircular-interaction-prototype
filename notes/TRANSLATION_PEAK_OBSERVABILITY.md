# Translation observability from a singleton peak

## Checked abstract kernel

[`TranslationPeakObservability.agda`](../formal/cubical/NaturalMachine/TranslationPeakObservability.agda)
isolates the exact structure used by the sampled one-shot residue argument.
A `CancellationTranslations` record supplies:

- a set-valued state carrier;
- a state-indexed translation operation;
- self-cancellation to one declared origin; and
- reflection of cancellation: if translating `left` by `right` reaches the
  origin, then `left = right`.

Given a set-valued observation with a distinguished peak whose fibre is
exactly the origin, the response to all one-step translations is faithful.
To distinguish `left` from `right`, use `left` itself as the action. The left
state reaches the origin and hence the peak. Equality of one-step profiles
forces the right state to hit the same peak; singleton-peak detection and
cancellation reflection then give `right = left`.

The leaf proves three exact consequences:

```text
oneStepProfile is injective

(left = right) ≃ FutureEq translate observe left right

all one-step responses factor through q  ->  q is injective.
```

The middle equivalence has explicit maps and round trips. The inverse laws use
exactly the declared sethood of the state and observation carriers: state
paths are propositions, and complete future equality is a product of
observation paths. The last result reuses `NaturalMachine.Descent.Factors`;
it does not introduce another quotient or factorization notion.

## Killer control

Boolean xor has the required cancellation structure: `x xor x = false`, and
`left xor right = false` implies `left = right`. But the constant Unit
observation makes `false` and `true` future-equivalent under every word. Its
putative peak fibre is not singleton. Thus cancellation or a transitive action
alone cannot support the reconstruction theorem; the observation's
singleton-peak hypothesis is load-bearing.

## Relation to the sampled valuation note

For truncated valuation on `Z/p^k Z`, the top response occurs exactly at the
zero residue, while translation by the current residue cancels it. Those are
precisely the two facts abstracted here. The repository does not yet contain
a checked carrier joining `ZMod (p^k)` to the sampled truncated-valuation
function, so this leaf deliberately does not claim that arithmetic
instantiation.

In particular, it does not prove the restricted-subgroup `H_s` staircase,
the class count `s + p^(k-s)`, the one-generator refinement between adjacent
levels, or the present subset-valuation noncongruence controls. Those remain
prose mathematics in `VALUATION_FUTURE_FORMS_RESIDUE.md` and
`SUBGROUP_TRANSLATION_QUOTIENT.md`.

No adaptive-query bound, addition-chain acquisition cost, Hilbert-dimension
claim, coherent/quantum readout, inverse-limit statement, or physical
formation event follows. The checked theorem is a generic exact
observability/minimality seam, not a formalization of p-adic arithmetic.
