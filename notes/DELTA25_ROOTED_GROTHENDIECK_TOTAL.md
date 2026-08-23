# Delta 25: the rooted whole is a dependent total space

## Authoritative distinction

Delta 25 requires a non-reduction boundary:

- the Eternal Golden Braid is a diachronic weaving process;
- Indra's Net is a synchronic rooted reflective whole.

The checked object here formalizes only the second side and one interface by
which a rootwise change acts on it.  It does not identify the present total
space with the history that produced it.

Authoritative source: upstream record `UP-D0025`,
`collab/upstream/raw/D0025-eternal-golden-braid-indras-net.txt`, body SHA-256
`6252491ededa435379b7d7b06ec96265cac3d901f42adb1c809c6d9289bb7b04`.
Its discipline says that Huayan/Indra's Net is not reduced to category theory;
§25.B asks for `U₂ = Σ (x : U) , Viewₓ(U)` and its projection/fiber equations.

## Prior T25.B landing and the present delta

T25.B was already checked before this extension.  Origin commit `f5314e9`
landed `formal/cubical/IndraNet.agda`; its `Rooted` module defines the same
dependent sum and projection and inherits the canonical fiber equivalence
from `Cubical.Functions.Fibration.fiberEquiv`.  That module was reported green
standalone under Agda 2.6.3 with cubical v0.5.  No first-formalization claim is
made here.

`NaturalMachine.RootedGrothendieck` is an Agda 2.8 standalone extension of
that exact core.  Its delta is explicit rather than architectural:

- aliases `U₂`, `π₂`, and `π₂-fiber-equation` matching the source notation;
- an `Iso` interface with named encode/decode maps and both round trips;
- recovery of the total space from the family of actual projection fibers;
- a projection-preserving rootwise update;
- constant- and varying-family controls separating root identity from fiber
  equivalence in both directions.

## Rooted totalization

Let `Root` be a type and let

```text
Jewel : Root → Type
```

be the type of data available at each root.  The rooted whole and its
type-theoretic Grothendieck projection are

```text
RootedTotal Root Jewel = Σ[ root ∈ Root ] Jewel root
projectRoot (root , jewel) = root.
```

This improves on a nondependent table when roots carry genuinely different
kinds of data: a jewel over `left` is not silently comparable to a jewel over
`right`.  Comparison requires a path of roots and the corresponding dependent
transport, or some additional externally supplied relation.

For every root, Cubical Agda checks the canonical fiber equation

```text
RootFiber Jewel root = fiber (projectRoot Jewel) root
RootFiber Jewel root ≃ Jewel root.
```

The module exposes this as both an equivalence and an isomorphism.  Its
`decodeFiber` and `encodeFiber` maps satisfy both round trips:

```text
decodeFiber (encodeFiber jewel) = jewel
encodeFiber (decodeFiber point) = point.
```

There is also a global recovery equation

```text
RootedTotal Root Jewel
  ≃ Σ[ root ∈ Root ] RootFiber Jewel root.
```

This is HoTT's standard total-space/fiber equivalence specialized to the
rooted family.  The word “Grothendieck” is used in this type-theoretic sense.
A categorical Grothendieck construction would additionally require a category
of roots and a functor or pseudofunctor; none is inferred here.

## Rootwise update without history collapse

A simultaneous rootwise update has type

```text
RootwiseUpdate Jewel = (root : Root) → Jewel root → Jewel root.
```

It lifts to an endomorphism of the total space by

```text
(root , jewel) ↦ (root , update root jewel),
```

and `update-preserves-root` is definitional equality.  This is a single
action on the synchronic whole.  It contains no trace, causal order,
composition schedule, braid relation, or proof-relevant history.  The landed
`IntrinsicRewrite` and persistent-rooted-reweave developments carry some of
that diachronic information in different types; this module does not erase
their distinction by repackaging their endpoints.

## Two-sided non-reduction controls

First, equality in the total space forces equality of roots:

```text
(left , x) = (right , y) → left = right.
```

Therefore a proof `left ≠ right` obstructs equality of total jewels and even
equality of the underlying total points carried by their projection fibers.
The dependent sum does not quotient roots.

Second, root identity and fiber equivalence are independent data.

- For the constant family `constantJewel root = Unit`, the projection fibers
  over Boolean roots `false` and `true` are equivalent, while
  `false ≠ true`.  Equivalent rooted perspectives do not identify their
  roots.
- For the varying family with `Unit` over `false` and `Bool` over `true`, the
  two projection fibers are not equivalent.  The proof reduces a hypothetical
  fiber equivalence to `Unit ≃ Bool` and then derives `false = true` from
  surjectivity/invertibility.  Different roots do not manufacture a common
  perspective type.

Together these controls forbid both reductions:

```text
fiber equivalence  ⇏  root equality
root difference   ⇏  fiber equivalence.
```

Additional reflection maps between roots must therefore be carried as
additional structure, not read out of the total space by metaphor.

## Relation to the live Delta 25 returns

`NaturalMachine.FiniteIndraWeave` uses a common `Jewel` type and audits a
finite `Root → Root → Jewel` table against an anchor, returning either nested
coherence witnesses or a typed tear.  The rooted total here answers a
different question: what is the carrier when the local type itself depends on
the root, and what is the exact projection fiber?

The persistent reweaving lane represents one shared transformation and delays
root traversal; the intrinsic rewrite lane preserves proof-relevant histories
under syntactic loci.  Those are diachronic/executable structures.  The
dependent total is their possible synchronic target carrier, not a replacement
for their histories or algorithms.

`NaturalMachine.ProductiveIndraNet` adds a guarded coinductive sequence of
finite total views and proves a bisimulation/finite-observation law.  It is a
temporal coalgebra over a common jewel type.  `U₂`, by contrast, is one
dependent present total.  Neither module subsumes the other: a productive
sequence needs a choice of temporal transition, while the dependent total
permits root-varying local types that the common-jewel table does not express.

## Rigor boundary

- Checked in safe Cubical Agda: the dependent total and projection, inclusion
  equation, fiber equivalence and both round trips, reconstruction by all
  fibers, projection-preserving rootwise update, root-separation lemmas, and
  both Bool controls.
- Reused prior art: `Cubical.Functions.Fibration.fiberEquiv` and `totalEquiv`
  (the standard HoTT fiber/total-space theorems).  No novelty is claimed for
  dependent sums or these equivalences.
- Repository prior: `formal/cubical/IndraNet.agda` at `f5314e9` already checks
  the requested T25.B dependent sum/projection/fiber equivalence under the
  pinned older toolchain.  The present module claims only the explicit
  equations and non-reduction controls listed above.
- Not formalized: a category of roots, functorial reindexing, an infinite or
  guarded reflective net, a braid group/action, a temporal trace, or an
  identification of the mathematical types with either historical tradition.
- Source consumed in full: private-repository upstream record `UP-D0025`,
  committed locally at `82099ea`.  Its category-theoretic proposals remain
  analogues/candidate formalizations by the source's own discipline; reading
  it does not raise them to proved claims.
