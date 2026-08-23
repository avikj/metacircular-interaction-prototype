# The Indra residue-pair net is exact finite Fourier inversion

## Checked outcome

[`IndraFourierNetAdapter.lean`](../formal/pairfield/Pairfield/IndraFourierNetAdapter.lean)
formalizes the exact part of `INDRA_CROSS.md` Proposition N.  For every
nonzero modulus `n`, put

\[
U_n=(\mathbb Z/n\mathbb Z)^\times
\]

and let `F : U_n × U_n → ℂ` be arbitrary.  Its character component is

\[
\widehat F(\chi_1,\chi_2)
=\sum_{a,b\in U_n}\chi_1(a)\chi_2(b)F(a,b).
\]

Mathlib's theorem
`DirichletCharacter.sum_char_inv_mul_char_eq` supplies the exact delta
kernel

\[
\sum_\chi \chi(a^{-1})\chi(b)
=\begin{cases}\varphi(n)&a=b,\\0&a\ne b.\end{cases}
\]

Applying it once on each coordinate proves, in Lean,

\[
F(a,b)=\varphi(n)^{-2}\sum_{\chi_1,\chi_2}
\overline{\chi_1(a)}\,\overline{\chi_2(b)}\,
\widehat F(\chi_1,\chi_2).
\]

The adapter separately checks that inverse evaluation equals complex
conjugation on a unit.  Thus the library theorem's convention and the source
note's displayed convention agree; this is not a normalization-by-analogy.
The proof is valid for the principal character and for `n=1`.

## Exact theorem surface

The load-bearing conclusions are:

- `inverse_eval_eq_conj`;
- `character_delta`;
- `characterComponent_eq_double_sum`;
- `fourierInverse_fourierForward`;
- `reconstruct_eq_conjugate_double_sum`;
- `reconstruct_characterComponent`.

The last theorem states equality of functions on the entire residue-pair
grid, not agreement at sampled cells or up to floating-point tolerance.

## What changed

The inverse-transform line in `INDRA_CROSS.md` §3 no longer depends on the
reported `1.1e-15` numerical replay.  That number remains a check of the old
implementation; the mathematical inverse square is now a checked theorem for
arbitrary complex cell data and every nonzero modulus.

## Scope fence

This adapter does **not** formalize or strengthen:

- Theorem I's double explicit formula;
- GRH or the simple-zero hypotheses;
- the claimed zero-pair frequency set or unit spectral weights;
- the completeness of any zero cache;
- the line correlations, amplitude ratios, or cross-talk magnitude;
- the lifted-versus-primitive Euler-factor boundary terms;
- any pointwise minor-arc estimate or Goldbach assertion;
- any reduction of Huayan or Indra's Net to finite Fourier analysis.

Finite Fourier inversion says that the character grid and the residue grid
contain the same finite data.  It does not say that a proposed analytic model
of one coordinate system is correct.

## Validation

- `lake build Pairfield.IndraFourierNetAdapter`: 3,336 jobs, exit 0;
- `lake build Pairfield`: 8,778 jobs, exit 0;
- Lean 4.33.0 / Mathlib v4.33.0.

The aggregate emitted only pre-existing linter warnings in unrelated modules.
