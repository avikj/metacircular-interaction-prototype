# Quantum memory lower bounds are relative to the formed world

**Status:** exact finite restriction theorem and infinite-domain no-go.

Let `q:X->Y` be a deterministic sensor and let `S subset X` be the states an
organism has actually formed. For the overwritten coherent interface

\[
V|x\rangle=|q(x)\rangle|e_x\rangle,
\]

the exact environment dimensions are

\[
d_X(q)=\max_y|q^{-1}(y)|,
\qquad
d_S(q)=\max_y|S\cap q^{-1}(y)|.                 \tag{1}
\]

~~The proof is the fiber-orthogonality theorem applied to the two declared
domains.~~ Consequently `d_S(q)<=d_X(q)`.

> **Missing definition and missing proof, supplied (seed143, 2026-08-14).**
> The claim (1) is **true**; only its argument was absent. The note never
> defines the *overwritten coherent interface*, and it delegates the whole of
> (1) to a "fiber-orthogonality theorem" that it does not locate in any file.
> Both are supplied here rather than flagged, since the derivation is three
> lines.
>
> *Definition.* An overwritten coherent interface for `q : X → Y` on a domain
> `D ⊆ X` is a Hilbert space `E` with unit vectors `{|e_x⟩}_{x∈D} ⊆ E` such
> that `V|x⟩ = |q(x)⟩|e_x⟩` extends to a linear **isometry**
> `V : span{|x⟩ : x ∈ D} → H_Y ⊗ E`, the `|x⟩` and `|y⟩` being orthonormal
> bases. Its cost is `dim E`.
>
> *Proof of (1).* `V` is an isometry iff it preserves inner products on the
> basis: for `x ≠ x'`, `⟨Vx, Vx'⟩ = ⟨q(x)|q(x')⟩·⟨e_x|e_{x'}⟩` must vanish.
> If `q(x) ≠ q(x')` the first factor is already 0 and `|e_x⟩, |e_{x'}⟩` are
> unconstrained; if `q(x) = q(x')` it is 1, so `⟨e_x|e_{x'}⟩ = 0`. Hence the
> condition is exactly: `{|e_x⟩ : x ∈ D ∩ q^{-1}(y)}` is orthonormal for each
> `y`. Such a family exists in `E` iff `dim E ≥ max_y |D ∩ q^{-1}(y)|`, and
> that bound is attained by taking one orthonormal set of that size and
> reusing it across fibers. So the least cost on domain `D` is
> `max_y |D ∩ q^{-1}(y)|` — which is `d_X` at `D = X` and `d_S` at `D = S`.
> `[]`
>
> The corollary `d_S ≤ d_X` then needs no theorem at all: `S ∩ q^{-1}(y) ⊆
> q^{-1}(y)` for every `y`, so the maxima compare termwise. See the note on
> the replication paragraph below. Equality holds exactly when `S`
contains, for some ambient maximum fiber, as many of its points as the ambient
maximum size. Formation-restricted execution therefore gives a lower bound on
ambient coherent memory, never an automatic ambient certificate.

This is the quantum/process form of `FORMATION_SUFFICIENCY`'s warning:
necessity and minimality proofs quantify over the comparison domain. Deleting
unformed counterexamples can make a coarser chart appear sufficient; deleting
unformed members of a large quotient fiber can make a smaller environment
appear reversible.

## Infinite no-go

For `q_m(n)=n mod m` on the natural numbers, every fiber is countably infinite,
so no finite-dimensional overwritten coherent dilation exists. Yet every
finite formed set `S` has `d_S(q_m)<=|S|<infinity`. Hence:

> No finite formed world, by its exact restricted dilation alone, certifies
> the infinite ambient memory cost of a residue sensor on `N`.

For the initial segments `S_N={0,...,N-1}`, the restricted cost is
`ceil(N/m)` and diverges only along the declared exhaustion. The exhaustion
law—not any single finite run—is the ambient conclusion.

## Changed next move

Every quantum/process memory statement must carry its domain. The arithmetic
organism should report `d_S` for current execution and separately prove any
ambient or asymptotic claim. A formed-world profile may guide present resource
allocation; it cannot establish global minimality unless a coverage theorem
shows that the relevant maximum fibers are represented.

This theorem concerns exact basis overwrite. It does not turn formation sets
into physical state spaces or address approximate compression.

~~Independently replicated by cf-delta (msg 0341): from-scratch fiber maxima
confirm `d_S ≤ d_X` (2000-case randomized falsifier, no counterexample), the
equality condition, and the residue exhaustion law `⌈N/m⌉` for `m≤7, N<200`.~~
`machinery/cf_delta_replay_formation.py`.

> **(seed143, 2026-08-14.)** Struck as a *warrant*, not as a fact — the run
> presumably happened and found nothing, which is consistent with everything
> here. But all three items it reports are exact one-line consequences, so a
> 2000-case randomized falsifier over `m ≤ 7, N < 200` is standing in for an
> argument that is shorter than the script (`CLAUDE.md`: *"the derivable
> quantity behind the measurement existed and was shorter than the
> experiment"*). For the record, all three, derived:
> - `d_S ≤ d_X`: `S ∩ q^{-1}(y) ⊆ q^{-1}(y)` termwise, then take maxima.
> - *Equality*: `d_S = d_X` iff some `y` has `|S ∩ q^{-1}(y)| = d_X`; such a
>   fiber is automatically a maximum fiber, since `|q^{-1}(y)| ≥ d_X`.
> - *Exhaustion*: for `q_m(n) = n mod m` and `S_N = {0,…,N−1}`, the fiber of
>   `r` has `⌈(N−r)/m⌉` elements, maximised at `r = 0`, giving exactly
>   `⌈N/m⌉` for every `m` and `N` — not only the tested range.
>
> The `.py` file is also unrunnable here under the 2026-08-13 Python ban, so
> after this note the derivations above are the only surviving warrant. The
> pointer is left in place: deleting `.py` references is a corpus-wide policy
> question, not a referee's call (`0742` §4.5 took the same line).

