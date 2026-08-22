# Sequential quotient dilations and the alignment defect

## 1. The composite fiber, not the stage prices

Let finite surjections compose as

\[
X\mathop{\longrightarrow}^{q}Y\mathop{\longrightarrow}^{r}Z.
\]

Write `a_y=|q^{-1}(y)|`. Applying the coherent overwrite theorem directly to
`r q` gives the exact boundary-memory cost

\[
\boxed{D(rq)=\max_{z\in Z}\sum_{y\in r^{-1}(z)}a_y.}              \tag{1}
\]

By contrast, allocating independent minimum-size garbage registers to the two
stages uses

\[
D(q)D(r)=\left(\max_y a_y\right)
          \left(\max_z|r^{-1}(z)|\right).                         \tag{2}
\]

Every sum in (1) has at most the second factor's number of terms and every
term is at most the first factor, so

\[
D(rq)\le D(q)D(r).                                                \tag{3}
\]

Equality is not automatic. The gap is an **alignment defect**: (2) prices the
largest first-stage fiber as though it occurred at every intermediate label
inside the largest second-stage fiber. Formula (1) retains which sizes meet.

## 2. Scalar stage prices do not compose

Take four intermediate labels with first-stage fiber sizes `(2,2,1,1)`. Let
both second-stage fibers have two labels. Grouping the two size-2 fibers
together gives composite sizes `(4,2)` and `D(rq)=4`; splitting them gives
`(3,3)` and `D(rq)=3`. Both processes have

\[
(D(q),D(r))=(2,2),                                                   \tag{4}
\]

but different composite costs. Thus the pair of scalar dilation dimensions
cannot determine the memory of a composite process. The required datum is at
least the incidence of first-stage fiber weights with second-stage fibers.

This is the deterministic reversible counterpart of the cut-rank gluing
warning in `CAUSAL_MEMORY_SPACETIME`: component prices forget boundary
alignment. It is not an identification of maximum fiber size with matrix rank.

## 3. Exact coherent compression theorem

A standard sequential construction labels an input `x` by

\[
|r(q(x))\rangle\,|i_x,j_{q(x)}\rangle,                             \tag{5}
\]

where `i_x` is injective inside each `q`-fiber and `j_y` is injective inside
each `r`-fiber. For each fixed `z`, the occupied pairs in (5) are in bijection
with `(rq)^{-1}(z)`.

> **Both halves supplied in place (seed130, 2026-08-14; bijection sweep).** The
> sentence asserts the bijection and leaves its argument to the reader; since
> Theorem 3.1's unitary is built by counting the two sides, the argument is
> written out. Let `Λ_z(x) = (i_x, j_{q(x)})` for `x ∈ (rq)^{-1}(z)`.
> *Surjective onto the occupied pairs*: "occupied" means, by definition, that
> the pair is `Λ_z(x)` for some such `x`. *Injective*: suppose `Λ_z(x) =
> Λ_z(x')`. Both `q(x)` and `q(x')` lie in `r^{-1}(z)`, and `j` is injective
> inside that `r`-fiber, so `j_{q(x)} = j_{q(x')}` gives `q(x) = q(x')`; then
> `x, x'` lie in one common `q`-fiber, where `i` is injective, so `i_x = i_{x'}`
> gives `x = x'`. Both hypotheses are used, and in this order — `j` first, `i`
> second; neither alone suffices. Hence `|{occupied pairs}| = |(rq)^{-1}(z)|
> ≤ D(rq)`, which is the equal-cardinality fact Theorem 3.1's isometry needs.

**Theorem 3.1 (controlled garbage compression).** There is a unitary controlled
by the visible output `z` that sends every occupied sequential label to

\[
|k_x\rangle|0\rangle,                                               \tag{6}
\]

where the `k_x` are distinct within each composite fiber and use only
`D(rq)` values. Conversely no coherent overwrite of the composite can use
fewer than `D(rq)` values.

**Proof.** For each `z`, choose a bijection from the occupied orthonormal
labels in (5) to distinct labels `k=1,...,|(rq)^{-1}(z)|` with a fixed
redundant register. An isometry between two equal finite orthonormal sets
extends to a unitary on the ambient environment. Taking the direct sum of
these unitaries over the mutually orthogonal `z` sectors gives the controlled
unitary. The lower bound is Theorem 2.1 of
`ARITHMETIC_QUOTIENT_QUANTUM_DILATION`. `square`

The control is load-bearing. A single output-independent relabeling of the
environment need not work, because the same sequential label may be reused in
different `z` sectors and assigned different compact labels. Coherent
compression therefore needs access to the retained composite output or a
globally compatible labeling. Dimension alone guarantees neither circuit
locality nor a control-free uncomputation.

## 4. Nested residue sensors

If `d|m`, reduction modulo `m` followed by reduction modulo `d` equals direct
reduction modulo `d`. On the finite chart `X_N={0,...,N-1}`,

\[
D(q_m)=\lceil N/m\rceil,\qquad D(r)=m/d,
\]

while

\[
D(q_d)=\lceil N/d\rceil.                                           \tag{7}

Thus independent stage registers use
`ceil(N/m)(m/d)` levels, which can exceed the direct cost `ceil(N/d)` because
the boundary fibers of `q_m` are unbalanced. At `(N,m,d)=(10,6,2)` the costs
are 6 versus 5. At `N=12` they are both 6.

This changes the arithmetic organism's compilation rule. A chain of formed
residue sensors should not retain one independently maximal garbage register
per stage. It should compile the composite quotient, retain the fiber-incidence
certificate, and use output-controlled uncomputation when coherent overwrite
is actually required. For adaptive sensing, the branch history is part of the
interface and this fixed-map theorem does not apply without first representing
the decision tree as one global quotient/process.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_quantum_quotient_dilation.py
python3 quantum_quotient_dilation.py
```

The formulas and compression theorem are proved above. The executable checks
finite certificates and the scalar-cost no-go. No gate-count optimality,
thermodynamic erasure cost, process-tensor Markov property, indefinite causal
order, or physical realization is claimed.
