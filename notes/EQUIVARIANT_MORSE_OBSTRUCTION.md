# The reflected-interval equivariant Morse obstruction

## Scope

This note proves one finite obstruction and one positive control.  It does not
claim that equivariant algebraic Morse theory generally fails, that every
symmetry obstruction is integral, or that the example supplies a complete
theory of context-monoid actions on chain complexes.

## 1. The smallest cell

Let (C) be the integral cellular chain complex of an interval:

\[
C_1=\mathbb Z e,
\qquad
C_0=\mathbb Z v_0\oplus\mathbb Z v_1,
\qquad
\partial e=v_1-v_0.
\]

Let (C_2=\{1,s\}) act by reflection:

\[
s(v_0)=v_1,
\qquad
s(v_1)=v_0,
\qquad
s(e)=-e.
\]

The sign on the oriented edge is necessary, and direct substitution gives

\[
\partial(se)=\partial(-e)=v_0-v_1=s(\partial e).
\]

Thus reflection is a chain action.

This same two-element action occurs as the effective context transformation
monoid of \(\mathbb Z/4\mathbb Z\) under addition with parity observation: the
contextual quotient has two points, and its effective translations are the
identity and parity flip.  The interval is the simplex on those two quotient
states.  This realizes a precise bridge; it does not identify every context
monoid with a cellular symmetry group.

## 2. Ordinary reduction exists

Both incidences ((e,v_0)) and ((e,v_1)) have unit coefficient.  Matching the
edge with either endpoint is an acyclic algebraic Morse matching.  It cancels
two of the three based cells and leaves one critical vertex, as expected for a
contractible interval.

## 3. No nonempty invariant matching exists

Suppose an invariant matching contains ((e,v_0)).  Applying reflection forces
it to contain ((e,v_1)).  The edge (e) would then occur in two matched pairs,
contrary to the definition of a matching.  Starting with ((e,v_1)) gives the
same contradiction.  Hence the empty matching is the only (C_2)-stable
matching.

Therefore, for this based cell structure,

\[
\text{best ordinary Morse size}=1,
\qquad
\text{best invariant Morse size}=3.
\]

The obstruction belongs jointly to the action and the chosen presentation.
Subdividing the interval at its fixed midpoint changes the cellular basis and
permits an equivariant collapse.

## 4. The integral obstruction is stronger than matching failure

Let

\[
\varepsilon:\mathbb Z\{v_0,v_1\}\longrightarrow\mathbb Z,
\qquad
\varepsilon(v_0)=\varepsilon(v_1)=1
\]

be augmentation.  An equivariant section from the trivial rank-one module
would have to send (1) to an invariant vector.  The invariant lattice is

\[
\mathbb Z\{v_0,v_1\}^{C_2}
=\mathbb Z(v_0+v_1),
\]

and augmentation maps it onto (2\mathbb Z).  It cannot contain (1).
Consequently augmentation has no integral (C_2)-equivariant section, so
there is no integral equivariant deformation retract of this cellular complex
onto a rank-one trivial complex.

Over \(\mathbb Q\), the obstruction disappears:

\[
1\longmapsto\frac12(v_0+v_1)
\]

is invariant and splits augmentation.  Coefficient extension has introduced
the division by the orbit size that integral cellular cancellation lacked.

## 5. Orbitwise sufficient condition and control

Let a finite group act on a based chain complex by signed permutations of its
basis.  Suppose a unit acyclic matching is a union of group orbits of matched
incidence pairs and no two pairs in those orbits share a cell.  Then the group
permutes the matched pairs, so simultaneous orbitwise cancellation is
equivariant.  The resulting Morse complex inherits the action.

This is a sufficient condition for this ordinary based-cell construction, not
a classification of equivariant Morse reductions.

For an exact positive control, take two disjoint intervals exchanged by
(C_2):

\[
\partial e=v_1-v_0,
\qquad
\partial f=w_1-w_0,
\]

with (s(e)=f), (s(v_i)=w_i), and conversely.  The orbit

\[
\{(e,v_0),(f,w_0)\}
\]

is a stable acyclic matching of disjoint pairs.  It reduces six cells to the
two critical vertices (v_1,w_1), which are exchanged by the inherited
action.

## 6. Executable certificate

`machinery/equivariant_morse.py` checks, using exact dependency-free finite
computation:

1. boundary/action commutation for both examples;
2. exhaustive enumeration of integral unit acyclic matchings;
3. the ordinary-versus-stable critical-cell counts;
4. the image (2\mathbb Z) of augmentation on the invariant lattice;
5. the rational half-section;
6. stability, acyclicity, and cell-disjointness of the positive orbitwise
   control.

Run:

```sh
python3 machinery/equivariant_morse.py
python3 -m unittest machinery.test_equivariant_morse
```

## 7. Consequence for the natural machine

A symmetry-blind contraction may preserve ordinary homology while deleting
the action through which contexts or observers distinguish states.  Before a
Morse reduction is compiled beneath a finite context monoid, the matching must
be tested for equivariance.  Failure does not say “do not reduce”; it returns
three exact alternatives whose costs differ:

- retain the unreduced integral action;
- refine the presentation, for example by equivariant subdivision;
- extend coefficients and record the denominators introduced by averaging.

The choice is task-relative and must not be made by silently forgetting the
action.
