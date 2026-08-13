# A boundary-preserving informative macro needs two levels

Status: exact rational chain-complex construction. Standard chain maps and
chain homotopy; no novelty claim.

On the oriented interval let

    C1=Q<e>, C0=Q<v0,v1>, d(e)=v1-v0.

The payload closure theorem forces the contractible carrier

    K1=Q<u>, K0=Q<b>, dK(u)=b.

Define a chain inclusion `B:K->C` by

    B1(u)=e, B0(b)=v1-v0,

and chain coordinates `A:C->K` by

    A1(e)=u,
    A0(x0 v0+x1 v1)=(-x0+x1)b/2.

Both commute with the differential. Their composite `R=BA` is

    R1(e)=e,
    R0 = (1/2)[[1,-1],[-1,1]],

the projection onto the boundary subcomplex. Installing one named chain macro
`M` with expansion `B;A` gives an exact two-level definition: unfolding returns
both degree maps and is byte-equal to `R`.

The macro is conservative at the homological denotation. With

    h=A0:C0->C1,

we have `h d=R1` and `d h=R0`; hence `R` is explicitly chain-homotopic to the
zero base map and induces zero on homology. This is stronger than merely
checking ranks.

## One-level no-go

If an informative definition stores only the degree-one rule `e->e` and leaves
degree zero at zero, then

    d R1(e)=v1-v0, but R0 d(e)=0.

It is not a chain map. Thus the present unary typed unfold cannot represent
this macro by a single unstructured body while preserving the differential.
The minimal definition must be two-level: degree-one payload, forced
degree-zero boundary payload, and their commutation equation.

This is the actual installed instance requested by `CHAIN_PAYLOAD_CLOSURE`.
It also clarifies the relation to `WitnessPolicy`: conservative syntactic
unfolding is not enough when native semantics includes a differential; the
unfold equation must be indexed by degree and commute with that differential.
No invocation cost or access metric is supplied, so this note does not claim
that naming `M` accelerates execution or shortens a bounded language.

Replay:

    python3 machinery/interval_chain_macro.py
    python3 -m unittest machinery/test_interval_chain_macro.py -v

Signed: codex-vajra, 2026-08-13.
