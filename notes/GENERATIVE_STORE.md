# A naming rule is a store only together with its access semantics

Define finite sets recursively by

\[
L_0=\{0\},\qquad L_{r+1}=2L_r\cup(2L_r+1).             \tag{1}
\]

**Theorem 1.** `L_r={0,1,…,2^r-1}`.

*Proof.* The claim is true at `r=0`.  If `L_r=[0,2^r)`, its doubled image is
the even integers in `[0,2^{r+1})` and its doubled-plus-one image is the odd
integers there.  They are disjoint and exhaustive. □

Thus the recursive schema plus depth `r` names `2^r` objects without storing a
table of `2^r` entries.  A word `b_1…b_r` in `{0,1}^r` acts by the affine fold

\[
x\longmapsto2x+b_i
\]

from `0`, producing exactly one member of `L_r`; binary expansion gives the
inverse address, padded to length `r`.

This separates three costs which an extensional held-set model conflates:

1. **description:** the recursive rule (1) and the parameter `r`;
2. **access:** `r` affine digit steps to construct or decode one named object;
3. **materialization:** `2^r` outputs if every named object is explicitly
   enumerated.

No exponential collection has become physically free.  The grammar compresses
the persistent description and supplies indexed access; exhaustive traversal
still has one output per element.

## Hybrid generative memory

Let `P_s={p^0,…,p^s}` be a multiplicative tower.  The union

\[
H_{r,s}=L_r\cup P_s                                      \tag{2}
\]

has a short two-constructor description, contains every base-`2^r` digit, and
reaches `p^s`.  This is the intensional repair of the hybrid-store construction:
the interval portion need not be charged one persistent record per digit when
the naming rule and its affine decoder are retained.  Query-time construction
and enumeration costs remain explicit.

The same distinction occurs elsewhere in the repository.  A witness forest is
an intensional store for many distinguishing words; a syntactic monoid is an
extensional quotient of all action words; a numeral grammar is an intensional
store for a finite interval.  None should be identified merely because each
can denote the same outputs.

## Rigor boundary

Theorems here are elementary exact set identities and step counts in the
declared affine-fold model.  No claim is made about optimal compression,
Kolmogorov complexity, bit-level runtime, human notation cost, or historical
intent.  The historical observation that positional and recursive naming
systems avoid tables is a source question separate from these proofs.
