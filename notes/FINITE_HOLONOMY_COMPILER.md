# Finite task-facing holonomy compiler

Status: exact finite construction and replay; standard automata, orbit, and
finitely presented abelian-group mathematics. No novelty claim.

## Three quotients that must not be identified

Let a finite set `X` carry permutations `H_a`, and let `o_i : X -> O_i` be
admitted observations.

1. The **orbit quotient** identifies `x` and `y` when a word in the generators
   carries one to the other. It forgets position inside a holonomy orbit.
2. The **predictive quotient** identifies `x` and `y` exactly when
   `o_i(H_w x) = o_i(H_w y)` for every observation and every finite word `w`.
   Stable Moore-machine refinement computes it and breadth-first search on
   pairs returns a shortest separating word for every rejected equality.
3. For an additive carrier `F`, the **coinvariant group** is
   `F_G = F / <H_a z - z>`. It is the universal additive target on which every
   generator acts trivially.

These answer different questions. An orbit set has no automatic group law; a
predictive quotient depends on tasks; coinvariants preserve only additive
maps. One finite action-groupoid traversal supplies the generator closure used
by all three, but one untyped quotient algorithm cannot replace their distinct
universal properties.

## Explicit history erasure

The compiler accepts a proposed equivalence `Theta` as a block label for every
state. It returns two finite certificates:

- every triple `(x,y,a)` for which `x Theta y` but `H_a x` and `H_a y` lie in
  different blocks;
- every triple `(i,x,y)` for which observation `i` separates a `Theta`-pair.

Thus `Theta` supports induced dynamics precisely when the first list is empty,
and task `i` descends precisely when no triple bearing `i` occurs in the
second. This is the same finite factorization test as
`relativized_initiality.py`: there `factors_through` asks whether a canonical
map is constant on quotient fibers; here the observation itself must be
constant on `Theta` fibers. The present compiler additionally closes the test
under every future generator word by predictive refinement.

## Additive certificate

Write

    F = Z^r / D Z^r,    D = diag(d_1,...,d_r).

For integral unimodular matrices `H_a` preserving `D Z^r`, coinvariants have
the exact presentation

    Z^r / [ D | H_1-I | ... | H_k-I ] Z^(r+rk).

The executable certificate contains that relation matrix, all determinantal
divisors, and the resulting Smith invariant factors. Preservation is checked
as `d_i` dividing `(H_a)_{ij} d_j`; a non-preserving matrix is rejected before
any quotient is reported.

## Smith replay and correction

For the existing holonomy action on

    F = Z/1 + Z/2 + Z/6

there are 12 raw elements and six holonomy orbits. Element order has four
predictive values `{1,2,3,6}` and is already invariant under the action. A
coordinate observation is not orbit-invariant; for example `(0,0,0)` and
`(0,0,1)` agree in the second coordinate now and are separated after one `H`.
With both order and that coordinate admitted, predictive refinement retains
eight states (the identity observation is the control that retains all 12).

The additive coinvariant presentation has invariant factors `(1,1,3)`, hence
coinvariant group `Z/3`. The earlier forecast `Z/2` was false; exact minors
give determinantal divisors `(1,1,1,3)`. This also shows concretely that the
six-element orbit set, the four-valued order quotient, and the three-element
coinvariant group are not interchangeable.

## Replay

    python3 machinery/finite_holonomy_compiler.py
    python3 -m unittest machinery/test_finite_holonomy_compiler.py -v

Signed: codex-vajra, 2026-08-12.
