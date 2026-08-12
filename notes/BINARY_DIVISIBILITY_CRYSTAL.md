# The binary divisibility crystal

**Prior-art correction.** This state count is the base-two case of Boris
Alexeev, *Minimal DFAs for Testing Divisibility*, JCSS 69 (2004), 235--243,
Corollary 5 ([arXiv:cs/0309052](https://arxiv.org/abs/cs/0309052)). The proof
below was independently generated inside this repository and remains an exact
replay/presentation; it is not a new theorem.

Let words of binary digits act on remainders modulo `m` by

\[
 r\xrightarrow{d}2r+d\pmod m,
\]

and observe only whether the current remainder is zero.  Two remainders are
the same state for this task when every future binary word gives the same
divisibility answer.

Write

\[
 m=2^a q,
\]

with `q` odd.  The minimal machine has exactly

\[
 q+a
\]

states.

## The classes

They are:

1. the singleton `{0}`;
2. one class for each nonzero residue modulo `q`;
3. for each `v=0,...,a-1`, one class of nonzero multiples `r=q t` with
   `v_2(t)=v`.

When `m` is odd this gives all `m` ordinary remainder states.  When
`m=2^a`, it gives only `a+1`: zero and the `a` possible finite two-adic
depths.

## Proof

Append a word of length `k` and value `n`, where `0 <= n < 2^k`.  The final
integer is congruent to

\[
 2^k r+n\pmod m.
\]

If `k<a`, divisibility by `2^a` first forces `2^k | n`.  The range of `n`
then forces `n=0`.  Acceptance is therefore

\[
 q\mid r
 \quad\text{and}\quad
 v_2(r/q)+k\ge a.
\]

Every short future sees exactly the finite two-adic depth recorded above.

If `k>=a`, divisibility first forces `n=2^a l`.  The remaining condition is

\[
 2^{k-a}r+l=0\pmod q,
\]

which depends only on `r mod q`.  Thus the displayed classes have identical
answers to every future word.

They are also distinct.  Different residues modulo `q` are separated by a
sufficiently long word choosing `l` to cancel one residue but not the other.
Different two-adic depths are separated by an all-zero word at the first
length where the deeper state becomes divisible.  Zero is already separated
from every nonzero multiple of `q` by the empty word.

So the classes are exactly the future-indistinguishability classes.

## Execution

`binary_divisibility_classes` in `machinery/natural_crystal.py` computes the
closed form directly.  The regression independently runs partition refinement
for every modulus from `1` through `100` and compares the two partitions.

This is the seed's first complete assimilation cycle:

```text
finite generation
-> observed pattern
-> elementary theorem
-> closed-form instruction
-> independent replay against the original computation.
```

The theorem does not add a fact beside the machine.  It replaces repeated
search by the reason the search had that answer.
