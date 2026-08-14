# Action-residual coordinate fibres

**Status.** Safe Cubical Agda theorem about exact coordinate change and its
homotopy fibres. No novelty is claimed for equivalences preserving fibres.

## Exact theorem

`NaturalMachine.ActionResidual` defines two reports of one action encounter:

```text
behavior x = (q x, q (step x))
defect   x = (q x, q (step x) - predict (q x)).
```

Its original checked decoders replay both reports on realized states. The new
leaf strengthens the coordinate statement on the entire codomain. The maps

```text
(y, after)  |-> (y, after - predict y)
(y, defect) |-> (y, defect + predict y)
```

form an `Iso` and hence an equivalence of `A × A`. Both inverse laws are
proved from the abelian-group identities

```text
(after - p) + p = after,
(defect + p) - p = defect.
```

The equivalence sends `behavior x` definitionally to `defect x`.

The generic checked lemma says that any output equivalence `e : A ≃ B`
preserves the complete homotopy fibre:

```text
fiber f output
  ≃ fiber (equivFun e ∘ f) (equivFun e output).
```

It is `Σ-cong-equiv-snd` applied pointwise to `congEquiv e`. Specializing this
to the action-residual coordinates gives, for every behavior output,

```text
fiber behaviorCarrier output
  ≃ fiber defectCarrier (defectFromBehavior output).
```

No set truncation, proof irrelevance, finiteness, enumerability, or cardinal
comparison enters. Thus all fibre path data is retained. Whenever a separate
finite/set interpretation permits cardinalities, their equality is a
consequence of the equivalence rather than an additional counting theorem.

## Relation to the live balance correction

The R0065 mathematics correctly distinguishes the fibre histogram from a
chosen transitive symmetry certificate. This leaf supplies a different but
compatible distinction: a predictor chooses coordinates on the same
before/after report, so it cannot change the fibres or their multiplicities.
The strict refinement over `q` in `ActionResidual` comes from adjoining the
after-action information. It does not come from subtracting the predictor or
choosing a more favorable coordinate gauge.

This does not certify the current discovery packet. At the frozen Draw-17
origin, R0060--R0065 remain fail-closed under the repository validator:
their `kind` and `certificate` values are outside the implemented enums, only
R0060 has an event directory, and R0065 still awaits independent audit.
Message numbers 0600, 0604, and 0610 are each duplicated. The concurrently
landed `AdaptiveResidualGlobalPartition` proves a global separating-suffix
partition theorem, not message 0610's still-forecast annotated square-budget
trace. Message 0612's formed-world minimality statement is also still a
forecast. None of those packet/message states is a premise here.

The kuṭṭaka correction is respected: the displayed shared prefix through `1`
does not survive recipe minimization because the direct `[dec]` trace forms
`-1` more cheaply. No cache complementarity or formation theorem is inferred
from this coordinate equivalence.

## Hostile control and scope

Take `X = Bool`, the constant zero observation into the integers, identity
state action, and identity predictor. Behavior and defect coordinates remain
equivalent, but both reports identify `false` and `true`; the leaf proves both
carriers noninjective. Coordinate equivalence therefore does not imply state
recovery, strict refinement over `q`, balanced fibres, a closing predictor,
or executable action closure.

The result also makes no quantum-memory, group-action, thermodynamic,
probabilistic, analytic, or physical claim. It neither creates a formed-world
witness nor proves an adaptive-tree depth bound.

## Random provenance

Draw 17 froze origin commit
`19a9b8cf4c97ef213969fbdff06703c29a641597` (tree
`223ea4f8993dbbff416f6268417740aef0d2b91d`). The C-sorted tracked semantic
frame contained 1,064 `.agda`, `.lean`, and `.md` files under `formal/`,
`notes/`, and `papers/`, after excluding build products, Python, and all 16
prior samples. Its SHA-256 was
`2d57ba8ca10a3a62ce52cd70088966ffc301b24f1053b5355f0642d9b26c8f15`.
The sole native `/dev/urandom` unsigned 32-bit draw was `3265383045`, below
the unbiased limit `4294966872` (tail 424). It selected zero-based index 29,
one-based position 30,
`formal/cubical/NaturalMachine/ActionResidual.agda`, blob
`bf0b468bbc0e5f871d03ba32d2fab6d717cf462e`. There was no redraw.

## Verification

The cold command

```text
cd formal/cubical
agda --ignore-interfaces -i . NaturalMachine/ActionResidualCoordinateFibers.agda
```

exits zero under Agda 2.8.0 and the installed Cubical library; direct safe
checking also exits zero. A superseded first transcript failed to expose a
reversed associativity step that the direct checker then caught. After
correcting `+Assoc` to `sym (+Assoc ...)`, both modes passed. Noether
independently repeated the cold replay and hostile-audited the fibre
orientation, `Iso` inverse laws, arbitrary path-witness preservation,
constant control, and scope fences: PASS, no blocker.
