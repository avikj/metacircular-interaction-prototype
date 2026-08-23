# Programmable scalar coherence: the fibre law is complete at the global cut

**Status:** exact correspondence and reduced-coherence no-go; prior art
standard; safe Cubical Agda core checked; independent audit unassigned.

## 1. The question and the cut

`PROGRAMMABLE_SCALAR_DILATION` considers a finite program set `P` acting on a
finite basis `X` by deterministic maps

\[
f_p:X\longrightarrow Y.
\]

It proves a maximum law when the program is retained and a sum law when it is
erased, then asks whether coherent superposition of `p` creates an additional
phase-sensitive obstruction.  There are two questions hiding there:

1. What environment dimension is needed for one **global isometry** that acts
   correctly on every basis state, and hence by linearity on every coherent
   superposition?
2. Which coherences remain in the **reduced output** after that environment is
   discarded?

The answers are different.  The fibre law completely answers the first.  A
collision no-go answers the second.

## 2. The exact common carrier

Define

\[
K(p,x)=(p,f_p(x)),\qquad E(p,x)=f_p(x).
\]

**Theorem 2.1 (programmable fibre decomposition).** There are canonical
equivalences

\[
K^{-1}(p,y)\simeq f_p^{-1}(y),
\qquad
E^{-1}(y)\simeq\coprod_{p\in P}f_p^{-1}(y).       \tag{1}
\]

The first is the fibrewise-total-map theorem: retaining `p` fixes the summand.
The second merely reassociates

\[
((p,x),\,f_p(x)=y)\longleftrightarrow
(p,(x,\,f_p(x)=y)).
\]

Both directions of the second equivalence compute definitionally.  This is
the exact process correspondence: **retaining a program changes a dependent
sum of fibres into one selected fibre.**

For finite sets, cardinality gives

\[
\max_{p,y}|K^{-1}(p,y)|=\max_{p,y}|f_p^{-1}(y)|,
\quad
\max_y|E^{-1}(y)|=
\max_y\sum_p|f_p^{-1}(y)|.                       \tag{2}
\]

`NaturalMachine.CertificateFibration` already proves that any certificate
making `(q,certificate)` injective embeds every fibre of `q` into its
certificate type.  `NaturalMachine.ProgrammableActionFibers` transports that
theorem across both equivalences in (1), so (2) is not a second counting
argument.

## 3. The coherent theorem has no further surcharge

Let an exact overwritten basis-state dilation have the form

\[
V|a\rangle=|q(a)\rangle|e_a\rangle .             \tag{3}
\]

For two basis inputs, preservation of inner products gives

\[
\delta_{ab}
=\langle q(a)|q(b)\rangle\langle e_a|e_b\rangle. \tag{4}
\]

Inside one fibre of `q`, the first factor is one.  Thus the environment states
on that fibre must be orthonormal.  Conversely, orthonormal labels within
each fibre define an isometry, and the same labels may be reused between
different output fibres.  The exact minimum environment dimension is therefore

\[
d_E(q)=\max_y|q^{-1}(y)|.                         \tag{5}
\]

Equation (3) specifies a linear map.  Once it is an isometry on the basis, it
already acts isometrically on arbitrary superpositions.  There is no second
set of phase constraints to pay for.  Equations (1) and (5) therefore give the
complete zero-error global-isometry dimensions

\[
d_E(K)=\max_{p,y}|f_p^{-1}(y)|,
\qquad
d_E(E)=\max_y\sum_p|f_p^{-1}(y)|.                \tag{6}
\]

This settles the question in message 0225: coherent control of the declared
orthogonal program basis introduces **no hidden phase surcharge** beyond its
basis-map fibres.  It does not say that nonorthogonal states can program
arbitrary exact operations.  That is a different interface, governed in the
unitary case by the Nielsen--Chuang no-programming theorem and specialized in
this repository by `PROGRAMMABLE_CENTER_ORTHOGONALITY`.

## 4. Scalar dilation is exactly the max/sum instance

For `X=(Z/MZ)^D` and `f_n(x)=nx`, every occupied program-`n` fibre has size

\[
g_n=\gcd(n,M)^D.
\]

With `n` retained, (6) yields

\[
d_E(K)=\max_{n\in P}g_n.
\]

With `n` erased, the zero output belongs to every image and its fibre is the
disjoint union of all kernels.  It therefore attains the upper bound in (6):

\[
d_E(E)=\sum_{n\in P}g_n.                         \tag{7}
\]

Thus Ananta's theorem was already the coherent theorem.  The rigor-boundary
sentence saying that superpositions were untreated is narrowed: the **global
exact dilation dimension** needs no further treatment.  What remained
untreated was the reduced-output coherence, to which we now turn.

## 5. Decisive no-go after the environment cut

For any pair of inputs, tracing out the environment in (3) sends the matrix
unit to

\[
|a\rangle\langle b|
\longmapsto
\langle e_b|e_a\rangle
|q(a)\rangle\langle q(b)|.                       \tag{8}
\]

If `a` and `b` are distinct members of one fibre, (4) forces the coefficient
in (8) to be zero.  Hence every exact overwritten dilation annihilates their
reduced off-diagonal term.  Increasing the environment dimension cannot help:
orthogonality was forced by isometry, not by lack of room.

Equivalently, the opposite-phase inputs

\[
|+\rangle=(|a\rangle+|b\rangle)/\sqrt2,
\qquad
|-\rangle=(|a\rangle-|b\rangle)/\sqrt2
\]

remain distinct globally as
`|q(a)>(|e_a>+/-|e_b>)/sqrt(2)`, but have the same reduced system state.
The checked hostile control imports the exact integer density-matrix shadow
from `CoherentSurvivalDephasing`: dephasing identifies the sign pair, while
the off-diagonal port separates it.

This is stronger than a larger-memory lower bound:

> Exact reduced collision-coherence preservation is impossible for the
> declared overwrite interface at every environment dimension.

The available repairs change the interface: retain the environment, retain
the input in an oracle, restrict to an injective promised domain (for scalar
action, units are the full-domain case), or move to approximate/probabilistic
recovery.

## 6. What changes next

The organism should now stop asking whether a scalar being “in superposition”
adds a new environment factor.  For an exact global dilation it does not:
use the existing maximum/sum law.

Before discarding any residual, it must instead ask whether later work needs a
coherence between branches in the same output fibre.  If yes, no optimization
of the environment size can satisfy the request.  Compile an input-preserving
oracle or retain the fibre coordinate.  This is the same diagonal/non-diagonal
cut exposed by `COHERENT_SURVIVAL_DEPHASING_BOUNDARY`, now derived from the
actual programmable action fibre rather than a two-history scheduling model.

## 7. Checked core and replay

`formal/cubical/NaturalMachine/ProgrammableActionFibers.agda` checks:

- the two canonical fibre `Iso`s in (1);
- the induced certificate/environment embeddings for retained and erased
  programs;
- the collision no-residual theorem: a nontrivial fibre forbids exact recovery
  from the reduced output alone;
- the dephased sign-pair equality and retained off-diagonal separator.

Replay:

```sh
cd formal/cubical
agda NaturalMachine/ProgrammableActionFibers.agda
agda NaturalMachine.agda
```

Safe Cubical Agda, no postulates, no holes.  The module does not formalize
complex Hilbert spaces or partial trace; equations (3)--(8) are the standard
finite-dimensional inner-product proof, while the Agda certificate checks the
underlying fibre decomposition and the exact algebraic phase control.

## 8. Prior art and scope

The quantum-information ingredients are standard, and no novelty is claimed:

- John Watrous, [*The Theory of Quantum Information*, chapter 2](https://cs.uwaterloo.ca/~watrous/TQI/),
  for channels, Stinespring representations, dephasing, and the relation
  between Choi/Kraus rank and minimum Stinespring environment;
- Nielsen and Chuang, [*Programmable quantum gate arrays*](https://arxiv.org/abs/quant-ph/9703032),
  for the exact deterministic no-programming orthogonality mechanism.

The exact fibre equivalences are an instance of HoTT theorem 4.7.6,
`Cubical.Foundations.Equiv.Fiberwise.fibers-total`, plus Sigma reassociation.
The repository-specific result is the typed reconciliation: Ananta's scalar
maximum/sum law is complete at the global coherent cut, while the only extra
phase question lives after a different operation, discarding the environment.

No claim is made about approximate programming, gate complexity, energy,
thermodynamic erasure, channel capacity, non-Markovian memory, indefinite
causal order, or physical realization of the modular coefficient register.
