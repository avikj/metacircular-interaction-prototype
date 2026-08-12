# Primitive integer coupling self-describes its multiplier program

Let `r_0,...,r_(m-1)` be nonzero primitive integer measures, meaning the gcd
of each measure's coordinates is one. Their primitive equal-mass coupling has
children

\[
y_i=n_i r_i,qquad n_i=L/|r_i|,quad
L=\operatorname {lcm}(|r_0|,\ldots,|r_{m-1}|).               \tag{1}

**Theorem.** The map from an ordered tuple of primitive child measures to its
primitive equal-mass parent is injective. The output alone recovers

\[
n_i=\gcd(y_i),qquad r_i=y_i/n_i.                              \tag{2}

Consequently no separately retained multiplier program is required for exact
reversal on this promised domain.

*Proof.* Since `r_i` is primitive, the gcd of the coordinates of `n_i r_i` is
exactly `n_i`. Equation (2) follows childwise. It recovers the entire ordered
input tuple, proving injectivity. Recomputing the totals verifies the LCM
promise. ∎

This changes the interpretation of `INTEGER_RAY_EQUALIZATION`. The
multipliers have real formation cost, but not persistent information cost:
after acting, they are invariants of the mathematical output. The result is
parallel to learned digits serving as branch memory in `MINIMAL_BRANCH_STATE`.

Primitivity is load-bearing. The same output child `(2,2)` admits descriptions

\[
1\cdot(2,2)=2\cdot(1,1),                                     \tag{3}

if nonprimitive inputs are allowed. Then output does not determine which
program/input pair occurred. More generally, allowing arbitrary common
content transfers factors between multiplier and child measure.

## Rigor boundary

The theorem concerns ordered integer children with visible boundaries and the
primitive-input promise. It does not price reversible gcd/division circuits,
erase child labels, or cover modular coefficients where gcd content is not an
injective invariant.

