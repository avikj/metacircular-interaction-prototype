# T25.F refined: propagation is indexed transport, not broadcast

**Status:** exact standard theorem, checked in safe Cubical Agda. This is a
refinement of the first landed T25.F implementation in
`formal/cubical/IndraNet.agda`, not an origin or priority claim.

## 1. Source boundary

The authoritative direct-user source is `UP-D0025`,
`collab/upstream/raw/D0025-eternal-golden-braid-indras-net.txt`. Section 16
states that a local equivalence or separator changes the reflection structure
wherever it is referenced, propagating by transport/naturality rather than by
broadcasting arbitrary copied state. T25.F asks for functorial profile changes
after adjoining an equivalence, separator, or higher coherence cell.

The same source is explicit that Huayan/Indra's Net is not reduced to category
theory. The checked object below is one exact analogue of the local propagation
sentence. It is not a formalization of Huayan metaphysics, a complete Indra
object, a category of jewels, or an infinite physical network.

`IndraNet.agda` already supplies the core path-profile version:

- a thread `x = y` updates every representable path profile;
- every dependent family transports along the thread; and
- a tear `not (x = y)` is visible from each root that reaches both sides.

The new result exposes a narrower operational condition that prose can hide:
which roots are declared to carry the relevant comparison.

## 2. The dependent rooted profile

Fix roots `Root`, states `State`, and a root-dependent observation family
`Observation : Root -> Type`. A rooted profile is

```text
P : (root : Root) -> State -> Observation root.
```

A local map `f : X -> Y` acts contravariantly by precomposition:

```text
reindex f P root x = P root (f x).
```

This action preserves identity and composition definitionally. If
`e : X ≃ Y`, reindexing is itself an equivalence between the two entire rooted
profile types; its inverse reindexes by `e^-1`, and the two pointwise inverse
laws are exactly `retEq` and `secEq`.

A higher cell `cell x : f x = g x` yields a path between the entire reindexed
profiles by two applications of function extensionality. Thus “all profiles
change” means that one law is quantified over every root and state. It does
not mean that their values become equal or receive a copied payload.

## 3. Adjoining data and retaining the old view

For a second root-dependent profile `added`, define

```text
adjoin P added root x = (P root x, added root x).
```

Reindexing commutes definitionally with this product, while projection recovers
the old root-specific observation exactly. A higher cell between two added
profiles changes only the second coordinate and induces a path between the
joint profiles. This is the smallest explicit form of functorial global
availability: the warranted coordinate is added everywhere it is defined;
the pre-existing view is conserved.

## 4. A separator keeps its root

`SeparatorAt P root` retains two states and a proof that `P root` distinguishes
them. A separator carried by the added coordinate separates the joint profile
at that same root. Along `e : X ≃ Y`, separators pull back by `e^-1` and push
forward by `e`; both constructions preserve the root index.

For an explicit predicate `Declared : Root -> Type`, define

```text
SeparatorFamily Declared P =
  (root : Root) -> Declared root -> SeparatorAt P root.
```

Such a whole declared family transports in both directions pointwise. The
input is load-bearing: no theorem constructs separators at roots not known to
carry the comparison. This refines `IndraNet.tearVisibleEverywhere`'s phrase
“every rooted view that reaches both sides” into an explicit family boundary.
The Bool instance's `northDeclaredSeparators` supplies the positive singleton
family by transporting the north witness along the declaration path.

## 5. Non-broadcast control

The checked Bool instance has two roots. The base observation is constant.
The adjoined coordinate distinguishes `false` from `true` at the north root
`false`, but is constant at the south root `true`. Consequently:

- the adjoined coordinate and joint profile have a north separator;
- the two joint south readings are definitionally equal; and
- an all-roots separator family is impossible.

So a warranted local event can update the profile object available at every
declared reference while preserving distinct root-relative responses. A local
tear does not license an arbitrary global state claim.

## 6. Checked surface and replay

`formal/cubical/NaturalMachine/DeclaredRootedProfiles.agda` checks:

- `reindex-id`, `reindex-comp`, and `profileReindexEquiv`;
- `stateCell→profilePath`, `adjoin-reindex`, and `adjoinProfileCell`;
- `pullSeparator`, `pushSeparator`, and both declared-family maps; and
- `local-separator-not-global`.

Replay from `formal/cubical/`:

```text
LC_ALL=C.UTF-8 LANG=C.UTF-8 \
  agda --ignore-interfaces NaturalMachine/DeclaredRootedProfiles.agda
```

Agda 2.8.0 exits successfully under `--cubical --guardedness --safe
--no-import-sorts`; no holes or postulates. The module is standalone, so no
aggregate-green claim is made. The mathematics is standard functorial
precomposition and transport of inequality witnesses; no novelty claim is
made.

**Verification correction (2026-08-14):** the first committed revision omitted
`isoToEquiv` from an explicit `using` import, and independent cold replay
correctly failed at that name. The import is now explicit; the exact
`agda -i . NaturalMachine/DeclaredRootedProfiles.agda` replay exits 0. No
theorem statement or proof body changed.
