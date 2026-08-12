# Higher-dimensional merged splits are lattice slices, not generally projective

Let two primitive nonnegative integer children of equal total merge to the
constant vector `C 1_D`. Writing the first child as `x`, the fiber is exactly

\[
\mathcal F_{D,C}=\{x\in\{0,\ldots,C\}^D:
\sum_i x_i=DC/2,\ \gcd(x)=\gcd(C\mathbf1-x)=1\}.             \tag{1}
\]

It is empty unless `DC` is even. Ordered reversal needs and suffices to record
`x`; unordered reversal quotients by the complement involution
`x -> C1-x`.

**Smallest higher-dimensional counterexample.** For `D=3,C=2`,
\[
\mathcal F_{3,2}=\{(1,1,1)\}\cup\{\text{six permutations of }(0,1,2)\}. \tag{2}
\]
Thus the ordered fiber has size `7`, and the unordered fiber has size `4`:
three complementary permutation pairs plus the fixed point `(1,1,1)`.

*Proof.* Coordinates lie in `{0,1,2}` and sum to `3`. The only sorted
possibilities are `(0,1,2)` and `(1,1,1)`, both primitive together with their
complements. Permutation and involution counts give the claim. ∎

More generally, complement has a fixed primitive point iff `C=2`: a fixed
point must be `(C/2,...,C/2)`, primitive exactly when `C/2=1`. Hence if
`N=|F_(D,C)|`, the unordered fiber size is `(N+1)/2` for `C=2` and `N/2`
otherwise.

This kills the expectation that higher-coordinate split records are generally
projective residue spaces. The two-coordinate totient family is special: its
simplex slice is one-dimensional and primitivity reduces to a unit condition.

## Rigor boundary

No closed formula for `|F_(D,C)|` is claimed. It is a bounded primitive lattice
slice; computation only replays the exact `D=3,C=2` classification.
