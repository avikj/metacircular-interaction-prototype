# Finite history totalization and endpoint forgetting

**Status.** A bounded exact response to Delta 25 task T25.G, Lean-checked in
`formal/pairfield/Pairfield/FiniteHistoryTotalization.lean`. The full higher
theory-history construction requested by Delta 25 remains open.

## Provenance and non-reduction fence

The authoritative source is catalog record `UP-D0025`,
`collab/upstream/raw/D0025-eternal-golden-braid-indras-net.txt`, direct user
injection with recorded SHA-256
`6252491ededa435379b7d7b06ec96265cac3d901f42adb1c809c6d9289bb7b04`.
Section 11 proposes a higher Grothendieck totalization of rooted stage views
over Braid histories; T25.G asks for a finite category case and a comparison
with ordinary-colimit forgetting.

The concurrent Delta 25 landing at `f5314e9` checks T25.A/B/D/F in
`formal/cubical/IndraNet.agda`: the Yoneda jewel theorem, rooted projection
fibres, discovery propagation, and a guarded coinductive net. It explicitly
leaves T25.G queued. The present module is disjoint: it supplies the finite
history/category-of-elements and endpoint-loss calculation, and does not
alter or subsume those four results.

The source's discipline is binding here: Huayan and Indra's Net are not
reduced to category theory. The formal result below is elementary finite type
theory and the category of elements. It does not implement Huayan mutual
identity or containment, and it does not attribute this construction to the
Huayan tradition. The encounter changes which information the finite theorem
is asked to preserve.

## The bounded Grothendieck object

For a state type `S` and `n` past positions, define

```text
History(S,n) = Fin (n+1) → S.
```

The last coordinate is the endpoint. For any type-valued rooted family

```text
Root : History(S,n) → Type,
```

Lean forms the functor from the discrete category of finite histories to
`Type` and defines

```text
GrothendieckTotal(Root) = (Discrete.functor Root).Elements.
```

Mathlib's `Functor.Elements` is the category of elements, a standard special
case of the Grothendieck construction. Its objects are pairs `(history, root)`.
When `S` is finite, the base discrete category is finite. The checked
construction permits arbitrary rooted fibres but supplies no nonidentity
history transitions; this is the exact one-categorical bounded case, not the
source's higher category `Hist_EGB`.

## Exact information balance

`Fin.lastCases` gives the checked equivalence

```text
History(S,n) ≃ (Fin n → S) × S.
```

The left side is the complete finite history. The two right coordinates are
its past and endpoint. The totalized report therefore has an exact left
decoder.

Endpoint projection keeps only `S`. For every endpoint `s`, Lean constructs

```text
{h : History(S,n) // endpoint(h) = s} ≃ (Fin n → S).
```

Therefore, for finite `S`, every endpoint fibre has exactly

```text
|S| ^ n
```

histories. The same equivalence and cardinality are checked for the actual
category-of-elements carrier when every rooted fibre is `Unit`. Thus the loss
is already present before adding local rooted payloads: the endpoint erases
the history index itself.

With at least two states and at least one past position, endpoint projection
has no left decoder. The internal collision is two different constant pasts
followed by the same endpoint. The Boolean two-step control has exactly four
histories over either endpoint.

## What “ordinary colimit forgets” requires

An unspecified colimit does not automatically equal endpoint projection.
T25.G's higher history category, arrows, stage functor, rooted reflections,
tears, and coherence have not yet been supplied as one formal diagram, so
asserting that its colimit has a particular quotient would outrun the data.

The checked theorem states the sharp reusable implication instead. If a
proposed colimit observation `q` is proved endpoint-only,

```text
q = postprocess ∘ endpoint,
```

then `q` has no exact history decoder under the same nontrivial conditions.
Its fibres can only be as coarse as the endpoint fibres. The factorization
premise is load-bearing and must be established for each future categorical
diagram.

Consequently:

- totalization retains the history coordinate and reconstructs exactly;
- endpoint quotient erases exactly `|S|^n` histories per endpoint;
- any ordinary-colimit observer shown to factor through that endpoint quotient
  inherits the no-decoder result;
- a derived (co)limit that retains more path or coherence data is outside this
  no-go and must be compared by an explicit map.

## Verification and remaining obligation

```text
cd formal/pairfield
lake env lean Pairfield/FiniteHistoryTotalization.lean
lake build Pairfield.FiniteHistoryTotalization
```

Both pass without warnings; the named build completes 1021 jobs. No Python or
numerical census was used.

Still open from T25.G: replace the discrete history category by a genuinely
nontrivial finite Braid-history category, define the stage/root functor on its
morphisms, construct its category of elements, and prove the specific ordinary
colimit comparison factors through the declared endpoint quotient. Higher
coherence and the source's full persistent woven object remain beyond that
finite successor.
