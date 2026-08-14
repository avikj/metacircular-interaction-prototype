# Reachable-image action refinement

Status: **checked constructive boundary**. This note compares the two descent
interfaces already used by the Natural Machine and transports the sampled
action-product repair to the weaker, reachable-image interface.

## Two decoder domains

`NaturalMachine.ActionRefinement` inherits

```text
StructuredDefect.Descends q t
  = Σ decode : Y → T, ∀ x, decode (q x) = t x.
```

The decoder is total on the declared codomain `Y`, including values never
observed from a state. `NaturalMachine.FiniteInformation` instead defines

```text
FactorsThrough q t
  = Σ decode : Image q → T,
      ∀ x, decode (restrictToImage q x) = t x.
```

Only reachable observations need values. Neither definition is wrong; they
retain different data.

## Checked comparison

[`ReachableActionRefinement.agda`](../formal/cubical/NaturalMachine/ReachableActionRefinement.agda)
proves two exact maps.

Every total decoder restricts to the image:

```text
totalDescends→reachableFactors :
  Descends q t → FactorsThrough q t.
```

Conversely, an explicitly split observation extends every image decoder:

```text
reachableFactors→totalDescends-with-section :
  (section : Y → X)
  → ((y : Y) → q (section y) = y)
  → FactorsThrough q t
  → Descends q t.
```

The extension is `y ↦ t (section y)`. Its replay proof uses only the fibre
constancy already implied by `FactorsThrough`. It chooses no representative
from a propositional truncation and invents no default for an unreachable
value.

The section is a sufficient coverage certificate, not a claimed necessary
condition for some particular total decoder to exist.

## Exact converse obstruction

The converse without coverage is false constructively. Take

```text
X = Empty,    Y = Unit,    T = Empty.
```

The image of the unique observation `Empty → Unit` is empty. Therefore the
unique empty eliminator gives

```text
empty-reachable-factors : FactorsThrough emptyObservation emptyTarget.
```

But total descent would contain a function `Unit → Empty`; evaluating it at
`tt` gives a contradiction:

```text
empty-no-total-descent : ¬ Descends emptyObservation emptyTarget.
```

The same control proves there is no section of the observation. This is not a
cardinality computation or a classical non-emptiness argument: the truncated
image witness is eliminated only into the proposition `Empty`.

## The product theorem survives

Define reachable refinement by

```text
ReachableRefines fine coarse = FactorsThrough fine coarse.
```

For `joint x = (q x, action x)`, the checked image-level statements parallel
the sampled total-decoder theorem:

- `joint` factors to each coordinate by projection;
- any reachable observer determining both coordinates determines `joint`;
- an `ActionCollision q action` refutes image factorization of `action`
  through `q`;
- projecting a hypothetical factorization of `joint` gives the forbidden
  action factorization;
- hence the collision makes `joint` a strict reachable refinement of `q`.

Thus changing the decoder domain corrects the treatment of unreachable
values without weakening the least-common-product repair or its collision
obstruction.

## Scope

This leaf does not claim:

- that split surjectivity is necessary for a particular total decoder;
- a selected representative for an arbitrary merely inhabited fibre;
- a default target value on unreachable observations;
- that the sampled retired Python runtime mutation was correct;
- that an action coordinate is the only useful sensor, cost-minimal, or
  physically realizable;
- finiteness, decidable image membership, probability, or an information
  quantity.

The universal product property is standard. The local contribution is the
checked interface comparison and its constructive counterexample.

## Live-ledger correction consumed before proof

The requested R0060/R0061/R0062 packet was read before this encounter.
Shannon's audit at commit `95eeb178` corrected the R0060/R0061 and message-0600
status:

- R0060's unconditional `M′ ≤ M+k−1` is false when depth does not increase.
  The valid unconditional bound is `M′ ≤ M+k`; the stronger `k−1` bound needs
  `D′ > D`. The checked depth-rising finite witness survives.
- The R0060 and R0061 packets use registry enum values outside the current
  schema; R0061 also lacked its event directory at the audited tree.
- The two distinct top-level files numbered `0600` remain a message-number
  collision under the first-push rule.

R0062 postdates that audit and was inspected independently at Draw-15 intake.
It was then only a forecast, likewise carrying invalid enum/event state; its
CRT theorem was not consumed as established mathematics.

No claim from those fail-closed packets is an input to this formal leaf.

## Random encounter provenance

Draw 15 froze freshly fetched `origin/main`
`383781274f62817a113ddf7ba37167ac0466d138`, tree
`89504ae9cc75320e12ec7a9cbefddceb0dbeff95`. The frame was the C-sorted
tracked semantic corpus under `formal/`, `notes/`, and `papers/` with
extensions `.agda`, `.lean`, or `.md`; build-product path segments and Python
were excluded, as were all fourteen prior sampled paths.

- frame count: `1057`;
- frame SHA-256:
  `9569978096e59e0854174464343dc8dbe968253bdb0fb9277efe0052385faf12`;
- rejection threshold: accept uint32 values below `4294967292`;
- sole native `/dev/urandom` uint32: `2083045784` (accepted);
- zero-based index: `29` (one-based position `30`);
- selected path: `formal/cubical/NaturalMachine/ActionRefinement.agda`;
- sampled blob: `1835cc45f02b1ce20e23d5ac6423a15d65532fe4`;
- introducing commit: `3f0640ade15de7d6940553ecb5cade2719fb2628`;
- last-touch commit: `5ce99f3e2bc4bce187745c4c8596a0770a5c07e8`.

There was no redraw after inspecting the selected object.
