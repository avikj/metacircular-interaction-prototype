# All p-ary aligned extreme rays are equal-mass initial blocks

Write `C_k=A_(p,k)` and `L(mu)=|mu|`. The recursive cone identity is

\[
C_k=\{(\mu_0,\ldots,\mu_{p-1})\in C_{k-1}^p:
L(\mu_0)\ge\cdots\ge L(\mu_{p-1})\}.                         \tag{1}

## Face dimension at the parent interface

Suppose exactly the first `m` children are nonzero. Partition their ordered
totals into `b` maximal constant blocks. If `f_i` is the dimension of the
minimal child face containing `mu_i`, then the parent minimal-face dimension
is

\[
f(\mu)=\sum_{i=0}^{m-1}f_i-(m-b).                             \tag{2}

*Proof.* Strict inequalities between constant blocks are locally inactive.
Within a block of length `q`, the `q-1` active equations
`L(v_i)-L(v_(i+1))=0` are independent on the product of the child-face spans.
Indeed, on every nonzero child face the total functional is nonzero, so choose
one vector of nonzero total in each coordinate. Restriction to their span
gives the usual incidence matrix of a path, of rank `q-1`. Summing over blocks
gives `m-b` independent equations. Zero tail coordinates have zero face
dimension. ∎

## Extreme-ray theorem

**Theorem.** Every extreme ray of `C_k` is uniquely specified by:

- a length `m` with `1<=m<=p`;
- an ordered `m`-tuple of extreme rays `r_0,...,r_(m-1)` of `C_(k-1)`;
- normalization so all `L(r_i)` are equal;

followed by `p-m` zero children.

*Proof.* Since every positive child has `f_i>=1`, (2) gives

\[
f(\mu)\ge m-(m-b)=b.                                         \tag{3}

For an extreme ray `f(mu)=1`; hence `b=1`, so all positive totals are equal,
and equality in (3) forces every `f_i=1`. Conversely an equal-total initial
block of extreme child rays has dimension `m-(m-1)=1`. Ordered totals force
all zero children to follow the positive block. ∎

Let `R_(p,k)` be the number of extreme rays. At depth one the rays are the
initial blocks of `1`s, hence `R_(p,1)=p`. The theorem gives

\[
R_{p,k}=\sum_{m=1}^{p}R_{p,k-1}^{,m}.                        \tag{4}

For `p=2` this recovers `R_k=R_(k-1)+R_(k-1)^2`. For `p=3`, the first counts
are

\[
R_{3,1}=3,qquad R_{3,2}=3+9+27=39.                           \tag{5}

## Mathematical motion

An indecomposable scheduler-compatible law is therefore a finite ordered
chorus: choose several prior indecomposable laws, equalize their total masses,
place them in the first child positions, and leave the remaining positions
silent. Conditioning selects one voice and returns an indecomposable law of
the same kind one depth lower.

## Rigor boundary

The theorem classifies extreme rays of the aligned measure cone for every
finite `p,k`. It does not classify integer primitive generators, Hilbert
bases, or formation costs for mass equalization. Ray counts may grow rapidly;
the recurrence is structural, not an instruction to enumerate them.

