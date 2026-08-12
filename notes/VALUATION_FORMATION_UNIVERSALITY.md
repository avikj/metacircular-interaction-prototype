# Why recursive origins form valuation coordinates

Recursive factor origins become a representation, rather than a stored list
of factors, at the following universal property.

## Universal transfer theorem

Let `N+` be the positive integers under multiplication and let
`N^(P)` be the finitely supported prime-indexed exponent vectors under
coordinate addition. Then

\[
v:\mathbb N_{>0}\longrightarrow\mathbb N^{(\mathcal P)},\qquad
v(n)=(v_p(n))_p                                      \tag{1}
\]

is an isomorphism of commutative monoids. Consequently, for every commutative
monoid `A` and every assignment of values `a_p in A` to prime generators,
there is a unique homomorphism `F:N+ -> A`, namely

\[
F(n)=\sum_p v_p(n)a_p.                               \tag{2}
\]

(Write the operation multiplicatively when `A` is multiplicative.)

**Proof.** Recursive division terminates at irreducible leaves. Euclid's lemma
implies uniqueness of the multiset of prime leaves, independently of the
factorization tree. Leaf multiplicities therefore define (1), concatenating
origin trees proves `v(mn)=v(m)+v(n)`, and the prime-power product reconstructs
`n`. Any homomorphism must send that product to (2), proving existence and
uniqueness. `square`

This is the transfer statement the arithmetic process needs. The coordinates
are not retained answers for previously encountered integers: once values on
prime constructors are supplied, (2) determines every multiplicative
observable on every future integer. `machinery/valuation_representation.py`
forms the leaves recursively and executes this universal evaluation.

## Sharp limitation: addition is not coordinate-local

The representation linearizes multiplication, not addition. For any prime
`p` and any `k>=1`, take

\[
a=1,\qquad b=p^k-1.
\]

Then `v_p(a)=v_p(b)=0` but `v_p(a+b)=k`. Thus no function of the two local
coordinates `v_p(a),v_p(b)` can determine `v_p(a+b)`; the same input pair
`(0,0)` permits an arbitrarily large output. Additive cancellation necessarily
couples the prime coordinate to residue information not present locally.

The full exponent vector remains lossless because it reconstructs the integer.
The limitation is subtler and load-bearing: addition cannot be transported
coordinate by coordinate. Any machine combining multiplicative anatomy with
additive motion must add cross-coordinate reconstruction or residue sensors;
it cannot pretend the valuation chart makes both operations linear.

## Rigor boundary

The universal property is the fundamental theorem of arithmetic in free-
commutative-monoid form, not a novelty claim. The executable artifact checks
finite instances and the unbounded addition counterexample family; it is not
the proof. The current recursive implementation chooses least divisors for
determinism, while the theorem—not that choice—guarantees tree independence.
