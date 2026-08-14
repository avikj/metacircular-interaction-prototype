# The first exact boundary beyond set-level descent

**Status.** Checked finite consequence of the existing Smith holonomy replay,
and a cross-reference to already checked Cubical mathematics. No novelty claim.

The set coequalizer of a group action is its orbit set. This is sufficient for
every set-valued task invariant under the action. It is not the action
groupoid: it forgets the arrows, and in particular every stabilizer.

The smallest exact witness already in the repository is the two-element finite
set. `NaturalMachine.Decategorification` checks

\[
  (\mathsf{FinSet}_2=\mathsf{FinSet}_2)\simeq
  (\mathsf{Fin}\,2\simeq\mathsf{Fin}\,2)=S_2,
\]

while cardinality sends the entire connected component to the numeral `2`.
Thus the component's set truncation retains one point and forgets its
nonidentity transposition loop. This is minimal: `Fin 0` and `Fin 1` have
trivial automorphism groups.

## The Smith example already suffices

Let `H` be the order-three automorphism of

\[
F=\operatorname{coker}(\operatorname{diag}(1,2,6))
\]

from `SMITH_PATH_HOLONOMY.md`. The action groupoid `C_3 // F` has three fixed
objects `(0,0,0)`, `(0,0,2)`, and `(0,0,4)`. At each fixed object `z`,

\[
\operatorname{Aut}_{C_3//F}(z)=C_3.
\]

Restrict to one of them. The resulting one-object groupoid is `B C_3`; its
set-level coequalizer is a singleton. The quotient functor sends both the
identity loop and the nonidentity generator `H_z` to the sole identity arrow
of that singleton. Therefore

\[
\mathrm{id}_{BC_3}:BC_3\longrightarrow BC_3
\]

cannot factor through the discrete groupoid on the orbit set: any such
factorization would send every loop to the identity, while `H_z` is not the
identity. This is the smallest proof-relevant consumer of the Smith example.

The distinction is exact:

- object-level invariant tasks still descend through the orbit set;
- additive invariant tasks descend through coinvariants;
- a consumer of the actual schedule-loop witness does not descend through
  `pi_0`, but does exist on the action groupoid.

A numerical stabilizer order is not by itself a counterexample: it is constant
on orbits and hence can be attached as a set-valued function on the orbit set.
The counterexample must consume the loop itself (or a nontrivial representation,
local system, or cocycle of it).

The free three-point Smith orbits provide the hostile control. Their
stabilizers are trivial, so their action groupoids are equivalent to discrete
one-point orbit groupoids. Merely having multiple histories is insufficient;
nontrivial isotropy is the exact boundary in this finite action case.

Replay:

```bash
python3 machinery/higher_coequalizer_boundary.py
python3 -m unittest machinery/test_higher_coequalizer_boundary.py -v
```

The replay checks the `C_3` loop law at the fixed point and the trivial
stabilizer on a free orbit. The underlying order-three Smith action remains
certified by `machinery/smith_path_holonomy.py`.

---

<!-- POINTER ADDED BY cf-oresme, 2026-08-14. Nothing above this line was
     altered. This is a pointer, not a correction: every mathematical
     sentence above that I checked is correct. -->

## Pointer (cf-oresme, 2026-08-14): the replay above is now a theorem

The two `python3` commands above are the note's stated evidence, and
`CLAUDE.md` (owner, 2026-08-13) rules that out as evidence. Per its standing
rule — *write down the theorem the computation would replace, then prove it* —
that theorem is proved and machine-checked in
**`formal/cubical/SetTruncationDescentBoundary.agda`** (`agda` exit 0 from a
cold tree, `--safe`, no postulates, no holes), and discussed in
**`notes/DESCENT_BOUNDARY_TWO_LENSES.md`** §1:

> For every type `A`, the type of set-level descent data for `id_A` —
> `Σ (f : ∥A∥₂ → A). (a : A) → f ∣a∣₂ ≡ a` — **is equivalent to the
> proposition `isSet A`.**

Three consequences for this note, offered rather than imposed:

1. The `C_3` apparatus is **inessential**. No group, no finiteness, no Smith
   normal form and no fixed point is needed; the boundary is hlevel, and
   `B C_3` is one point of the empty side of an equivalence. The note's own
   smaller witness (`FinSet_2`) already suffices, and so would any non-set.
2. "The counterexample must consume the loop itself" is not a caveat but a
   **corollary**: set-valued invariants always descend (`descend-unique`), and
   descent of the *identity* implies descent of every `A`-valued task from
   every domain (`idDescends→allDescend`). The identity is the universal test.
3. The strengthening the equivalence adds over "does not factor": there is not
   merely *no canonical* descent, the **type of descents is empty**; and when
   `A` is a set the descent is unique, so nothing is ever chosen.

The section "The distinction is exact" is exact, and remains so. What changes
is only where the exactness lives: in `isSet`, not in nontrivial isotropy.
Nontrivial isotropy is the correct criterion *for finite group action
groupoids specifically*, which is the case this note treats.
