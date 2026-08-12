# Forgetting child order creates exactly permutation fibers

Consider an ordered primitive equal-mass coupling with `m` visible child
vectors `y_i=n_i r_i`, but let the output forget their positions and retain
only the multiset `{y_1,...,y_m}`.

**Theorem.** If the distinct output child vectors occur with multiplicities
`c_1,...,c_s`, the fiber of ordered primitive inputs has size

\[
\frac{m!}{\prod_{j=1}^s c_j!}.                                \tag{1}
\]

Hence exact overwritten reversal needs environment dimension equal to (1) on
that output fiber, and worst-case dimension `m!` whenever `m` distinct coupled
children are available.

*Proof.* By `PRIMITIVE_COUPLING_SELF_DESCRIBES`, each vector `y` uniquely
recovers its multiplier `gcd(y)` and primitive child. Thus no ambiguity remains
inside a multiset element. The only lost datum is the assignment of multiset
elements to the `m` ordered positions. The number of distinct assignments is
the multinomial coefficient (1). ∎

Repeated child shapes reduce rather than increase memory: identical elements
carry no observable permutation label. Retaining ordered boundaries makes all
fibers singleton; erasing them exports precisely the permutation quotient.

## Rigor boundary

The output is assumed to retain exact child vectors as a multiset. If it also
merges their coefficient supports by summation, additional partition
ambiguities appear and (1) is only a lower bound. Primitive integer inputs and
exact zero-error reversal remain load-bearing.

