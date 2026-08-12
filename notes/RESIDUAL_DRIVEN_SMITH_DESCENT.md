# Residual-driven Smith descent in dimension two

**Status:** exact elementary theorem and executable certificate generator.

The preceding arithmetic-life experiments found two alternating local moves:
an upper-right residual can be turned into a smaller pivot by a column
operation, and a lower-left residual can be turned into a smaller pivot by a
row operation.  This note closes that loop for every signed `2 x 2` integer
matrix, including singular matrices and zero entries.

## The machine

Let

\[
A=\begin{pmatrix}a&b\\c&d\end{pmatrix}.
\]

Every operation below is multiplication by an elementary unimodular matrix,
and the implementation accumulates matrices `L,R` rather than forgetting the
path.

1. If the active pivot is zero but the matrix is nonzero, row and column swaps
   move a nonzero entry to `(1,1)`.  Negate its row if necessary, so the pivot
   `p` is positive.
2. Divide the lower-left entry by `p`.  The row operation replacing it by its
   Euclidean remainder `r`, followed by a row swap when `r != 0`, makes `r`
   the new pivot.
3. If the lower-left entry cleared, do the symmetric division on the
   upper-right entry and column-swap a nonzero remainder into the pivot.
4. If both entries clear, the matrix is `diag(p,d)`.  Normalize the sign of
   `d`.  If `p|d`, stop.  Otherwise add the second row to the first.  This
   exposes `d` in the upper-right position; its residual `d mod p` then drives
   the column move in step 3.

Thus the observed residual determines the orientation, quotient, and
elementary transformation of the next act.

## Termination theorem

**Theorem.** For every `A in M_2(Z)`, the procedure terminates with

\[
LAR=\operatorname{diag}(d_1,d_2),\qquad
d_1,d_2\geq0,\qquad d_1\mid d_2,
\]

where `L,R` are unimodular.  Every nonterminal residual step strictly
decreases the positive active pivot.

**Proof.** Once a positive pivot `p` has been installed, division by `p`
returns a remainder `r` satisfying `0 <= r < p`.  A nonzero off-axis
remainder is swapped into the pivot, hence the next positive pivot is `r<p`.

If both off-axis remainders vanish, the matrix is diagonal.  Failure of
Smith divisibility means `r=d mod p` satisfies `0<r<p`.  Adding the second row
to the first exposes `d` off-axis; Euclidean column reduction replaces it by
exactly `r`, and the column swap again makes `r` the new pivot.  Therefore
every return to a nonterminal pivot state strictly decreases a positive
integer.  Between two such states only finitely many explicitly listed
elementary operations occur, so no orientation cycle is possible.

At termination the off-diagonal entries vanish and the two diagonal entries
are nonnegative with `d_1|d_2`.  The accumulated elementary matrices are
unimodular, so this is a Smith-form certificate.  The zero matrix terminates
before a pivot is installed; a nonzero singular matrix terminates with second
diagonal entry zero, which is divisible by its positive first entry. `square`

The number of strict descent events is at most the first positive pivot minus
one.  This deliberately coarse bound is sufficient for well-foundedness;
Euclidean behavior is normally much shorter.

## What has and has not been formed

This is a closed descent machine, not a fixed tower of preselected macros.
The next operation is not chosen by its stage number: it is computed from the
current exact residual, and the resulting state determines the next residual.
The causal certificate is the complete `L,A,R` identity plus the sequence of
oriented residuals.

The opposite statement is equally important.  The residual has not invented
an arbitrary new constructor language.  Row addition, column addition, swaps,
and sign changes are a fixed finite schema; the residual synthesizes the next
*instance* and its parameter.  Closure here comes from the conjunction

\[
\text{residual-directed action} + \text{well-founded measure}.
\]

A residual without such a measure can rotate forever; a decreasing measure
without a residual-sensitive action is only an externally scheduled
algorithm.  The proved object needs both.

## The residual is dependent data, not a number

The word *residual* can still erase the mechanism.  The bare remainder does
not determine the next constructor.  For example, the three states

\[
\begin{pmatrix}2&0\\1&7\end{pmatrix},\qquad
\begin{pmatrix}2&1\\0&7\end{pmatrix},\qquad
\begin{pmatrix}2&0\\0&3\end{pmatrix}
\]

all present the scalar remainder `1`.  The first requires a left row
operation, the second a right column operation, and the third first requires
the diagonal-to-axis row injection.  Therefore the next-action map does not
factor through the projection to the scalar remainder.

The sufficient observation has the dependent form

\[
(\text{kind},\ p,\ q,\ r,\ A),
\]

where `kind` records lower-left, upper-right, or diagonal-divisibility origin.
The current implementation retains this as `ResidualStep`; its three-way kind
is not commentary but causal input.  This is the same exact shape as a port
contraction obstruction: memory of the output value cannot repair erasure of
the still-operative orientation input.

Consequently “the residual generates the next constructor” is true only for
the typed residual over its originating state.  Quotienting that family down
to the integer `r` destroys action sufficiency even though it preserves the
usual Euclidean magnitude.

## Replay and independent falsifier

`machinery/smith_residual_machine.py` returns the full certificate and rejects
a fabricated diagonal.  The tests cover the arithmetic-life example, a pure
diagonal divisibility failure, signs, zeros, rank one, and the zero matrix.
They also exhaust every matrix with entries in `[-3,3]` as a falsifier of the
universal proof, comparing the output with the independently computed
determinantal divisors

\[
d_1=\gcd(a,b,c,d),\qquad d_1d_2=|\det A|.
\]

Run:

```bash
cd machinery
python3 -m unittest test_smith_residual_machine.py -v
```

## Rigor boundary

The termination and certificate statements above are proved for `2 x 2`
integer matrices.  The code is executable evidence and a falsifier, not the
proof.  Smith normal form in general dimension is standard prior art; no
novelty is claimed for the algorithm.  What is new to this local research
thread is the exact closure of its previously separate upper-right,
lower-left, and divisibility residual phases into one residual-directed
process.  No all-dimension termination measure or autonomous formation of the
elementary-operation schema is claimed.
