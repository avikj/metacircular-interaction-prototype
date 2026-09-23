# The Fibre Law â” Losslessness Is Forced

For every map `f : A â’ B`, define `fib f b = Î a : A , f a = b`. The canonical map `a â¦ (f a , a , refl)` gives `A â‰ Î b , fib f b` over the same visible map `f`.

The important theorem is stronger. A conservative presentation consists of a family `T : B â’ U`, an equivalence `Î : A â‰ Î b , T b`, and agreement `Ïâ âˆ˜ Î ~ f`. The repository proves that `T b â‰ fib f b` pointwise. `Uniqueness` then proves the entire type of such lossless completions is contractible. The residual is not auxiliary provenance and is not a design decision: once the visible map and conservation requirement are fixed, the complete dependent presentation is forced.

This immediately separates three questions that are often conflated. **Visibility:** what coordinate `f` exposes. **Residual:** exactly which distinctions collide under that coordinate. **Cost:** how much interaction is required to compute or transport the result. Reversibility of the complete presentation does not imply zero interaction cost; exact cost is treated in [Action, Logic, and Optimal Inference](05-action-logic-optimal-inference.md) and [Interaction Geometry Becomes Physics](09-interaction-geometry-physics.md).

Composition is dependent rather than additive bookkeeping: the fibre of `g âˆ˜ f` over `c` decomposes through the actual intermediate fibre of `g`. This is the exact mathematical form of retaining the intermediate dependency needed by the composite.

Descent gives the corresponding sufficiency criterion. For an observation `q : X â’ Y` and target `h : X â’ Z`, `h` factors through `q` exactly when `h` is constant on every `q`-fibre (under the theorem's stated set-level hypotheses). Thus an observation is sufficient precisely when the result respects every identification that observation makes.

For Chu evaluation this theorem becomes the central result of [Chu Spaces Completed](03-chu-spaces-completed.md). For measurement it becomes the observation-kernel analysis of [State/Event â” Time/Information](06-state-event-time-information.md). For universal-machine finding/checking it yields the internal decide/verify equivalence discussed in [Action, Logic, and Optimal Inference](05-action-logic-optimal-inference.md).

## Canonical checked construction

[`Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`](../../fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda)

Global uniqueness: [`Uniqueness_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda`](../../formal/cubical/theorems/residue/Uniqueness_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda)

Related checked logic: [`ObsBridge.agda`](../../formal/cubical/theorems/logic/ObsBridge.agda).

## External coordinates

[Homotopy fibre](https://ncatlab.org/nlab/show/homotopy+fiber), [Grothendieck construction](https://ncatlab.org/nlab/show/Grothendieck+construction), [descent](https://ncatlab.org/nlab/show/descent).
