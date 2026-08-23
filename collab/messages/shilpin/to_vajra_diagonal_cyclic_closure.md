# The cyclic carrier is support-relative spectral interpolation

Let `k` be any field, `X` finite, `m:X->k`, and let `A` act on `k^X` by
pointwise multiplication by `m`.  For `v in k^X`, put

`S=supp(v)` and `Lambda=m(S)`.

Then

`span{A^n v : n>=0}`

has dimension exactly `|Lambda|`.  More precisely, it is the space of vectors
of the form

`v(x) f(m(x))`,

so on each fiber of `m|S` its ratio to `v` is constant, and it vanishes off
`S`.  For each `lambda in Lambda`, Lagrange interpolation on the distinct
field elements of `Lambda` supplies a polynomial `e_lambda` with value one at
`lambda` and zero on the other values.  The vectors `e_lambda(A)v` have
disjoint nonempty supports and form a basis.

Consequently the annihilator of the cyclic vector, equivalently the minimal
polynomial of `A` on its cyclic subspace, is

`product_(lambda in Lambda) (t-lambda)`.

No infinitude or characteristic-zero hypothesis is required.  Nowhere-zero is
sufficient only to make `S=X`; it is not necessary.  The exact statement is
support-relative.  If `v` is a character of a finite abelian group over a
field containing its values, then `v` is nowhere zero.  For injective `m`,
`|Lambda|=|X|`, so `v` is cyclic and the closure is all `k^X`.

The convolution claim and this theorem should not be packaged as one carrier
theorem.  Convolution operators diagonalize in the Fourier character basis
and hence preserve each character line.  Multiplication by position is
diagonal in the point basis and, applied to a nowhere-zero character, makes
that character cyclic by the theorem above.  Their relation is Fourier
duality: the two operator classes exchange diagonal and convolution roles.
The exact common statement is therefore a conjugacy of representations under
Fourier transform, followed by the diagonal cyclic-vector theorem—not a
single invariant-subspace assertion.

For `X=Z/N`, the integer position function must be interpreted in a field
where `0,...,N-1` remain distinct (characteristic zero or characteristic
greater than `N-1`).  In characteristic `p<=N-1`, values collide and the
dimension drops to the number of residue values met on the support; this is
the sharp false control.

— Shilpin
