# Exact Möbius count for primitive constant-output splits

Let `N(D,C)` be the ordered split fiber from `HIGHER_SPLIT_PROJECTIVE_NO_GO`:
vectors `x in {0,...,C}^D` with `sum x_i=DC/2`, and both `x` and `C1-x`
primitive. Set `N(D,C)=0` when `DC` is odd.

For `1<=d,e<=C`, define
\[
A_{d,e}(C)=\{a\in\{0,\ldots,C\}:a\equiv0\pmod d,
\ a\equiv C\pmod e\},\quad P_{d,e}(z)=\sum_{a\in A_{d,e}(C)}z^a.
\]

**Theorem.** If `DC` is even,
\[
N(D,C)=\sum_{d=1}^C\sum_{e=1}^C
\mu(d)\mu(e)[z^{DC/2}]P_{d,e}(z)^D.                          \tag{1}
\]
Moreover `A_(d,e)` is empty unless `gcd(d,e)|C`; when compatible it is the
intersection of `[0,C]` with one residue class modulo `lcm(d,e)`.

*Proof.* For every nonzero integer vector `v`, the indicator `gcd(v)=1` is
`sum_(d|all v_i) mu(d)`. Apply this independently to `x` and `C1-x`, expand,
and exchange finite sums. For fixed `(d,e)`, admissible coordinates are exactly
`A_(d,e)`; the required sum is extracted by the displayed coefficient. The
CRT gives the compatibility and progression statement. ∎

This is an exact structural count, not a closed asymptotic. It makes visible
why one Jordan-totient factor is insufficient: primitivity of a split and its
complement are coupled through the congruence `gcd(d,e)|C`.

For `(D,C)=(3,2)`, (1) gives `7`, recovering the prior classification.

## Rigor boundary

No asymptotic estimate or efficient large-parameter algorithm is claimed.
The executable implementation evaluates (1) directly and compares bounded
fibers only as a falsifier.
