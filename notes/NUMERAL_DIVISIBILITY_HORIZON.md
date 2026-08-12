# Every divisibility future has a finite horizon

Fix a base `b >= 2` and modulus `m >= 1`.  Digits act on remainders by

\[
 r\xrightarrow{d}br+d\pmod m,
\]

and the only observation is whether the remainder is zero.

A word of length `k` has a unique numerical value `n` with
`0 <= n < b^k`.  Appending it to a remainder `r` accepts exactly when

\[
 b^k r+n=0\pmod m.
\]

Let `a_k(r)` be the least nonnegative residue of `-b^k r` modulo `m`.  The
accepted words of length `k` are precisely the integers

\[
 a_k(r),\ a_k(r)+m,\ a_k(r)+2m,\ldots
\]

that lie below `b^k`.  Therefore two states give the same answer to every word
of length `k` exactly when either both least residues lie outside the range, or
their least residues are equal.

## Finite-horizon theorem

Choose `L` so that

\[
 b^L\ge m
\]

and the chain `gcd(m,b^k)` has stabilized at `k=L`.  Then two remainders are
future-indistinguishable if and only if they agree on all word lengths
`0,1,...,L`.

Only the forward direction needs proof.  At length `L`, the range contains a
representative of every residue modulo `m`.  Equality of the accepted suffix
sets therefore gives

\[
 b^L(r-s)=0\pmod m.
\]

Put `g=gcd(m,b^L)`.  This says `r=s mod m/g`.  Stabilization means `m/g` is
coprime to `b`; hence multiplication by every later power of `b` preserves the
congruence.  Thus `b^k r=b^k s mod m` for every `k>=L`, and all later accepted
suffix sets coincide.

So an apparently infinite observational question has a proved finite test.
`divisibility_classes` records the least accepted suffix (or its absence) at
each length through `L` and groups equal signatures.  No iterative partition
refinement is needed.

The binary formula in `BINARY_DIVISIBILITY_CRYSTAL.md` is the unusually simple
closed form of this theorem.  For other bases the short pre-stabilization
geometry can retain more distinctions: base six modulo eight has five states,
for example, even though a valuation-only guess predicts four.

The regression compares the finite-horizon constructor with independent exact
partition refinement for every base `2` through `10` and every modulus `1`
through `100`.
