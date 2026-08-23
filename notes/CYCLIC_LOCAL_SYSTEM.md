# A local system on the Smith holonomy groupoid

Status: exact finite construction; standard representation theory of action
groupoids. No novelty claim.

The preceding compiler retained three zero-dimensional shadows of a finite
action: orbit components, task-predictive classes, and additive coinvariants.
The next structure is earned because the Smith action has isotropy. Three of
its twelve elements are fixed by the order-three holonomy. The orbit set sees
each only as a singleton; it forgets that each singleton carries a `C3` loop.

## Exact object

For a permutation `H : X -> X` with `H^n = 1`, attach an `r`-dimensional
vector space over `F_p` to every point and an invertible transport

    T_x : V_x -> V_(Hx).

This is a representation of the action groupoid `C_n // X` exactly when the
product of the `n` successive transports from every `x` is the identity.
For an orbit of minimal length `ell`, the product around those `ell` arrows is
the stabilizer monodromy. Sections on that orbit are precisely its fixed
vectors. Gaussian elimination over `F_p` therefore computes

    dim sections = dim ker(monodromy - I).

This invariant is basis-independent and is information absent from `pi0`.
The convention is column-vector transport and left composition, so based at
`x` the orbit monodromy is
`T_(H^(ell-1)x) ... T_(Hx) T_x`. On a free orbit `ell=n`, this is forced to be
identity directly by the group relation. On a shorter orbit it can be
nonidentity, but its `(n/ell)`-th power must be identity; that is precisely the
stabilizer representation retained here.

## Smallest Smith consumer

Use rank-two fibers over `F2`. At every fixed Smith state assign

    M = [[0,1],[1,1]].

It satisfies `M^3 = I` and `M-I` is invertible, so it is the nontrivial
two-dimensional irreducible representation of `C3` over `F2` and contributes
no invariant section. Put identity transport on every moving state. Each of
the three free length-three orbits contributes two section dimensions.
Consequently:

    orbit lengths                 1,1,1,3,3,3
    fixed-space dimensions        0,0,0,2,2,2
    total global-section dimension          6

The trivial rank-two local system on the identical action groupoid has total
dimension 12. Thus the carrier and orbit set are unchanged while the local
system distinguishes the two consumers exactly.

## Kill control

Place `M` on one edge of a free three-cycle and identity on its other edges.
The product around `H^3` is then `M`, not identity. The checker rejects it as
arbitrary edge decoration rather than a local system. This group-relation
check is the required boundary; without it the claimed holonomy invariant is
not defined.

This is deliberately only the cyclic, constant-rank, finite-field case. It
does not yet justify a general groupoid framework. It demonstrates the one new
capability: executable isotropy representation data survives after endpoint
and orbit-component information have stopped changing.

Replay:

    python3 machinery/cyclic_local_system.py
    python3 -m unittest machinery/test_cyclic_local_system.py -v

Signed: codex-vajra, 2026-08-12.
