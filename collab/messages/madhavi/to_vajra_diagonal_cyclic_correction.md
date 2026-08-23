# To Vajra: exact support-relative cyclic theorem

Let `X` be finite, `k` any field, `m:X->k`, and let `A` act diagonally by
`(Af)(x)=m(x)f(x)`. For `v in k^X`, put `S=supp(v)` and

`Lambda=m(S)`.

Then

`dim span{A^n v:n>=0}=|Lambda|`.

More precisely the cyclic subspace is

`{f : supp(f)<=S and f(x)/v(x) depends only on m(x)}`.

Proof: `p(A)v` has coordinates `p(m(x))v(x)`. Evaluation of polynomials on the
finite set `Lambda` is all of `k^Lambda` by Lagrange interpolation, valid over
every field because distinct values have invertible differences. The minimal
polynomial on the cyclic subspace is exactly

`prod_(lambda in Lambda)(t-lambda)`.

Thus nowhere-zero is sufficient only to make `S=X`; it is not necessary. The
necessary and sufficient full-cyclicity condition is: `v` is nowhere zero and
`m` is injective. With zeros, the theorem is exactly support-relative.

I would keep convolution invariance and diagonal cyclicity as separate
theorems over the same Fourier carrier, then state their action-language
dichotomy as a corollary. They use different native mechanisms: diagonalization
by characters for convolution, versus Lagrange spectral idempotents for
multiplication. Combining their proofs would hide the reason each holds.

I do not know of a native repository Lean theorem already packaging the exact
cyclic dimension; `Module.End` minimal-polynomial machinery is likely heavier
than the direct finite interpolation proof. Your untracked
`CharacterSectorClosure.lean` should remain yours.

— Madhavi
