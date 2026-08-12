# Arithmetic life forms exponent space

Recursive factor origins do not merely produce a longer tree.  Commutativity
and associativity quotient the tree by order and bracketing, leaving the finite
support function

\[
v(n):p\longmapsto v_p(n),\qquad n=\prod_p p^{v_p(n)}. \tag{1}
\]

Unique factorization makes (1) a lossless coordinate chart.  The executable
process forms it from factor events and checks reconstruction before caching it.
More strongly,

\[
(\mathbb N_{>0},\times)\cong\mathbb N^{(\mathcal P)}
\]

is the free commutative monoid on the primes. Every assignment of prime
generators into any commutative monoid therefore extends uniquely to a
multiplicative observable. This universal property—not stored factor answers—
is the representation's transfer certificate; see
`VALUATION_FORMATION_UNIVERSALITY.md`.

This immediately compiles four operations:

\[
v(ab)=v(a)+v(b),\quad
v(\gcd(a,b))=\min(v(a),v(b)),\quad
v(\operatorname{lcm}(a,b))=\max(v(a),v(b)),          \tag{2}
\]

and

\[
\tau(n)=\prod_p(v_p(n)+1).                           \tag{3}
\]

For (72), the process forms `((2,3),(3,2))`; for (90),
`((2,1),(3,2),(5,1))`.  Equations (2) return gcd coordinates
`((2,1),(3,2))` and lcm coordinates `((2,3),(3,2),(5,1))`; (3) returns
12 divisors of 72. Re-encountering a formed integer performs no factor search.

This is the first larger reorganization: the successor-line view of an integer
has been supplemented by a sparse multiplicative geometry.  Multiplication is
translation, divisibility is coordinatewise order, gcd/lcm are meet/join, and
divisor enumeration is a finite box.  The next questions are induced by this
geometry rather than selected from a syllabus.

The new chart does not replace the additive residue organs. For every prime
(p) and (k\ge1), both (1) and (p^k-1) have (p)-valuation zero, while
their sum has valuation (k). Addition is therefore not coordinate-local on
separate valuation vectors. Residues and valuations must coexist; the failure
of their actions to commute is the next joint rather than an implementation
defect.

Run `cd machinery && python3 exponent_world.py`. Five exact tests cover
formation, reconstruction, coordinate addition, meet/join, divisor counting,
and reuse.

Rigor boundary: unique factorization is consumed as an established arithmetic
theorem, not rediscovered by the finite execution. The implementation forms
and compiles its consequences exactly; it does not yet prove unique
factorization from the constructors.
