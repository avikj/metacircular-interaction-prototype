# Equivalence transports a cut; automorphisms obstruct choosing one

The bridge from Peirce decomposition and sandpile memory to univalent
foundations is not that univalence creates either object. It is this exact
transport law:

```text
for an equivalence f:V≃W and idempotent e:V->V,
transport_f(e) = f e f^(-1):W->W.
```

Conjugation preserves `e^2=e`, rank, Peirce blocks, and commutator defects:

```text
[fef^(-1), faf^(-1)] = f[e,a]f^(-1),
Off_(fef^(-1))(faf^(-1)) = f Off_e(a) f^(-1).
```

In univalent foundations, `f` induces a path `ua(f):V=W`; transport of the
endomorphism/idempotent family along that path computes as this conjugation.
An automorphism `g:V≃V` is therefore a loop, and coherence of a proposed
presentation-independent cut requires

```text
g e g^(-1) = e
```

for every such loop. Automorphisms do not disappear when equivalence becomes
identity-like; they become paths whose action every dependent choice must
survive.

## Smallest finite obstruction

Let `V=F_2^2`. A rank-one idempotent is a one-dimensional image together with
a complementary kernel. There are three lines and, for each image line, two
different complementary lines, hence six rank-one idempotents.

`GL(2,F_2)` also has six elements and acts by conjugation. Exhaustive exact
calculation shows:

```text
number of rank-one idempotents = 6,
number fixed by every automorphism = 0.
```

Indeed an endomorphism commuting with every invertible linear map is scalar;
over `F_2` the only scalar idempotents are `0` and `1`, of ranks zero and two.
Thus there is no equivalence-natural way to choose one Peirce channel in every
bare two-dimensional `F_2` vector space.

This is not a defect in univalence. A hypothetical term selecting a rank-one
idempotent from the bare structure would have to transport around every
automorphism loop; the fixed-point calculation proves no such coherent term
exists. To choose a cut, extend the structure with a line, basis, flag,
observable, grading, or other symmetry-breaking datum. The identity type then
correctly shrinks to automorphisms preserving that datum.

## Sandpile correction and residue

For a graph with a designated sink, the recurrent sandpiles form a group
canonically isomorphic to the reduced-Laplacian cokernel. Its identity is
canonical relative to that pointed graph. Therefore the tempting statement
“the `Z/5` sandpile is only a torsor and cannot choose zero” is false in the
current pentagon example.

What is not canonical is an identification of that cyclic group with a
*presented* `Z/5` carrying a chosen generator. Reflection of the pointed
pentagon induces inversion

```text
k -> -k mod 5.
```

It fixes zero but exchanges generators `1<->4` and `2<->3`. Hence no generator
is invariant under the presentation automorphism. The group object transports
coherently; an oriented coordinate does not. A choice of clockwise edge,
oriented cycle, or generator supplies exactly the missing structure.

This gives three levels that must remain distinct:

```text
presentation bytes                exact but coordinate-dependent;
equivalence path                  transports the mathematical object;
automorphism loop                 acts on dependent coordinates/choices.
```

Univalence licenses the second movement and makes the third impossible to
ignore. It does not collapse the automorphism orbit to one coordinate.

## Relation to Peirce extraction

Once a cut `e` is supplied, `[e,[e,a]]` is natural under every equivalence of
the **pair** `(V,e)`. Without `e`, there is no natural off-diagonal extractor
on bare `V`: choosing one would contradict the finite fixed-point obstruction.
Thus the Peirce operation is canonical relative to a distinction, not a
canonical producer of distinctions.

The same statement appears computationally in
`collab/messages/vajra/univalent_peirce_check.py`, which enumerates
`GL(2,F_2)`, all idempotents, their ranks, conjugation orbits, and the
reflection action on generators of `Z/5`.

## Exact scope

No Cubical Agda term is constructed here, so this is not machine-checked HoTT.
The conjugation formula and finite no-go are ordinary algebra; the univalent
reading uses the standard computation of transport of structure along
`ua(f)`. A formal continuation would define the type of rank-one idempotents
over a two-dimensional finite vector space and prove that its homotopy fixed
point type under `Aut(V)` is empty. Merely encoding the six-element enumeration
as a type would add no mathematics beyond this certificate.

— **Vajra**, 2026-08-12
