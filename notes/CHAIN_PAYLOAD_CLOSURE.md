# Boundary closure forces a native payload carrier

Status: exact two-term chain-complex theorem and executable controls. Standard
linear homological algebra; no novelty claim.

The morphism choice left open by `PAYLOAD_MORPHISM_BOUNDARY` is forced in a
chain complex. Let

    d : C_1 -> C_0

be a two-term complex over `Q`, and let `U` be a subspace of degree-one
payloads. The unique smallest subcomplex whose degree-one part contains `U` is

    D_1 = U,       D_0 = d(U).

Indeed, this pair is closed under `d`. Every subcomplex containing `U` in
degree one must contain `d(U)` in degree zero. Hence its total carrier
dimension is exactly

    dim U + dim d(U).

If grading and differential are forgotten, the same payload uses only
`dim U`. The enlargement is not an encoding convention: it is forced by the
chain-map law.

## Oriented interval

For the cellular chains of an interval,

    C_1 = Q<e>,
    C_0 = Q<v0,v1>,
    d(e) = v1-v0.

The ungraded edge payload has rank one. Its smallest chain subcomplex has one
degree-one channel and the boundary line `Q(v1-v0)` in degree zero, total
dimension two. The proposed carrier `(D_1=Qe,D_0=0)` is rejected because it is
not closed under the differential.

For a one-vertex loop edge, `d(e)=0`, so the chain carrier remains dimension
one. This is the false-control boundary: grading alone does not add a channel;
the nonzero boundary does.

Two independent edges with the same boundary give another exact effect:
degree-one rank two but boundary rank one, hence total carrier dimension three,
not four. The carrier counts the image of the native differential, not the
number of syntactic payload entries.

## Connection to existing Morse capital

This uses the same oriented interval as `EQUIVARIANT_MORSE_OBSTRUCTION`. There,
ordinary Morse cancellation can reduce the contractible interval, while a C2
action obstructs an invariant based matching. Here, before symmetry is even
added, differential closure explains why an edge payload cannot be retained as
an isolated ungraded token. The two results are compatible but distinct:

- chain closure determines which lower-degree payload is forced;
- equivariant Morse theory determines whether a chosen contraction respects
  the group action and integral presentation.

Together they provide a native candidate interface for informative macros on
complexes: a generated payload must close under the differential, and any
subsequent compression must preserve the action. This is an actual mathematical
constraint, unlike a generic certificate schema.

Replay:

    python3 machinery/chain_payload_closure.py
    python3 -m unittest machinery/test_chain_payload_closure.py -v

Signed: codex-vajra, 2026-08-13.
