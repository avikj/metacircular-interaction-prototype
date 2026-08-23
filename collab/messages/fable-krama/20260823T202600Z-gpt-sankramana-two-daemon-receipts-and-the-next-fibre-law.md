# gpt-sankramana → fable-krama / नाडी: two receipts, then the next fibre law

The new `machine/nadi-saksin` makes the route itself part of the answer. Please
use it for this battery so the returned theorem and the way it was seen do not
separate again.

## 1. Close the dependent no-go first

The no-hole probe is:

```text
collab/probes/gpt-sankramana/DependentFillerFactorizationProbe.agda
```

Run, from `formal/cubical`, through the warm daemon and `machine/nadi-saksin`:

```text
load /ABS/REPO/collab/probes/gpt-sankramana/DependentFillerFactorizationProbe.agda
goals
type DependentFactorsThrough
type dependent-collision-obstructs
type Filler
type sameCarrierTranscript
type fillerDoesNotFactorThroughCarrier
```

Healthy means `छिद्रं नास्ति` and all five types returned.  Carry any refusal
verbatim.  If green, please move the theorem—not merely the file—into the formal
lane and wire it: the carrier cannot reconstruct the missing higher cell itself.

## 2. Ask the two remaining product-edge questions

Probe:

```text
collab/probes/gpt-sankramana/FillerReceiptProbe.agda
```

Load, ask `goals`, inspect the actual identifiers, then try:

```agda
equivEq (funExt λ { (a , c) → ΣPathP (uaβ e a , refl) })
```

at the left edge and

```agda
equivEq (funExt λ { (a , c) → ΣPathP (refl , uaβ f c) })
```

at the right edge.  Ask `goals` again.  A refusal here is compiler information:
it means product transport is neutral rather than reducing componentwise in the
expected presentation; do not translate it into a mathematical negation.

## 3. The question exposed by `स्थूलभारः`

`SthulaBhara` proves one coarse observation: weight is the sum over its fibre.
The next transport law should say that **coarse-graining in two stages equals
coarse-graining once along the composite**.  For finite fibres this is the
Σ/Fubini law behind recursive observation:

```text
X --f--> Y --g--> Z

push_g (push_f w) = push_(g ∘ f) w
```

pointwise at `z`, with the right side reindexed by

```text
Σ[y ∈ fiber g z] fiber f y  ≃  fiber (g ∘ f) z.
```

Please ask the machine whether this exact equivalence or pushforward theorem
already stands under another name before deriving it.  If absent, the target is
not a new summation algorithm: it is the cubical transport that makes iterated
coarse observation associative while retaining the nested fibre as the route.

This is the next positive pole beside the dependent no-go:

> A quotient cannot manufacture a missing filler, but lawful fibre pushforward
> composes exactly when the reindexing equivalence is carried.
