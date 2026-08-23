# Physical learning core: behavioral-kernel audit

## Checked surface before this audit

`NaturalMachine.PhysicalLearningCore` is a safe finite model with:

- a Boolean `Phase` and two reversible actions, `stay` and `flip`;
- population and coherent ports with responses `Unit` and `Bool`;
- port-indexed observation and a manually declared compiled carrier;
- exact `compile-step` and `compile-read` commuting laws;
- a population collision and coherent separator for `true` and `false`;
- imported equal-dephasing and separating off-diagonal facts about two integer
  matrices.

Commit `d1379962` repaired the actual Agda name `true≢false`; a cold safe replay
then checks.  It did not change the mathematical surface.

## Exact refinement added

The core's `Meaning` asks for responses after one `Action`.  The new module
`NaturalMachine.PhysicalLearningQuotient` instead instantiates the repository's
established `FutureBehavior` object, which quantifies over every finite action
word.  It proves both directions

```text
compile p s = compile p t
    <->
FutureEq physicalStep (observe p) s t
```

for both ports.  `compiled-kernel≃future-kernel` packages these maps as an
equivalence; its two inverse laws are discharged explicitly from propositionhood
of the exact Unit/Bool equality families.  Thus `Compiled p` has exactly the
complete behavioral kernel for this declared system.  No quotient HIT or
equivalence between a quotient type and `Compiled p` is constructed.

The second result is strictness of the port refinement: coherent future
equality implies population future equality, while `true` and `false` collide
under every population experiment and are separated already by the empty-word
coherent observation.

## Evidence-grade limits

The theorem certifies the deliberately chosen two-state/two-port compiler; it
does not show that a physical subsystem learns that compiler.  There is no
history-dependent learner update, port-adjoining operation, memory dynamics,
noise, cost, language formation, or generation of new representation.  The
`Reopening` record stores one old collision and one new separator, but no event
which changes the admitted interaction family.  Accordingly, this is an exact
finite analogue of task-relative representation, not the Physical Knowledge
Process of `UP-D0025` section 21.

The matrix language also outruns the checked interface if read literally.
`Matrix₂ ℤ` carries no typed Hermiticity, positivity, trace normalization, Born
rule, or quantum instrument.  The imported matrix facts and the abstract
Bool/Unit port facts exhibit the same collision/separation pattern, but no map
from matrices to `Phase`, no translation from the integer off-diagonal result
to the Boolean coherent response, and no commuting realization square is
defined.  “Physically realized” therefore means a parallel exact witness in
this module, not a checked implementation relation.

The newly landed adjacent modules do not fill this gap or duplicate the new
kernel theorem.  `RelationalProcessCore` checks dependent transport and a
global-section obstruction; `UnivalentPhysicalProcess` checks a universe-path
phase flip and evaluator covariance; `UnivalentTensorInteraction` checks a
two-local-population collision, non-reconstruction, and joint phase reopening;
`RelationalHolonomyRefinement` checks a group-valued subdivision quotient and
endpoint gauge laws.  They add genuine interaction-relative structure
elsewhere, but none connects this compiler to matrix ports or proves its
complete future kernel.  In particular, `UnivalentTensorInteraction` has a
single exchange action and a commuting compiler, but no finite-word behavior
object or proof that compiled equality is its exact kernel.

The licensed sentence is therefore narrow: *for the declared Boolean phase
system, the chosen port-indexed compiler is an exact sufficient presentation
of all finite-word response behavior, and admitting the coherent port strictly
refines the population behavioral kernel.*
