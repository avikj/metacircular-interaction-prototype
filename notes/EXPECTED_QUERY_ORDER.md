# Distribution-optimal order for adaptive valuation queries

Let `R` be a random residue in `Z/p^kZ`, with an arbitrary declared
distribution. Write its base-`p` digits from low to high as

\[
R=\sum_{\ell=0}^{k-1}D_\ell p^\ell.
\]

At a prefix `u=(d_0,...,d_{ell-1})`, a schedule orders `p-1` children for
testing and infers the remaining child if every test fails. Schedules may
depend on the already learned prefix.

## Exact expected-cost theorem

For a permutation `sigma_u` of the `p` children, interpret its first `p-1`
entries as the test order and its last entry as omitted. Define

\[
c_{\sigma_u}(d)=\min(\sigma_u^{-1}(d)+1,p-1).                 \tag{1}
\]

Thus the local cost multiset is

\[
1,2,\ldots,p-2,p-1,p-1.                                     \tag{2}
\]

**Theorem.** Among every prefix-adaptive schedule, expected forward-query
cost is minimized independently at each positive-mass prefix by assigning
the conditional digit probabilities in decreasing order to the costs in
increasing order. Equivalently, if

\[
\pi_{u,(1)}\ge\pi_{u,(2)}\ge\cdots\ge\pi_{u,(p)}
\]

are the sorted probabilities of `D_ell` conditional on prefix `u`, the
optimal contribution at that node is

\[
P(u)\left(\sum_{i=1}^{p-2}i\pi_{u,(i)}
 +(p-1)(\pi_{u,(p-1)}+\pi_{u,(p)})\right).                   \tag{3}
\]

Summing (3) over all prefixes of lengths `0,...,k-1` gives the exact minimum
expected query count. The two least probable children occupy the tied longest
slots; either one may be omitted.

*Proof.* Linearity of expectation writes total query count as the sum of
local query counts over reached prefixes. The probability of reaching `u`
and the conditional law at `u` depend only on `R`, not on the schedule that
reveals its digits. Hence each node can be optimized separately, even when
the digits are dependent. At one node, if probabilities `a>b` are assigned
costs `x>y`, swapping them changes expected cost by

\[
ay+bx-(ax+by)=-(a-b)(x-y)<0.
\]

Repeated exchanges give decreasing probability against increasing cost.
The duplicate cost `p-1` proves the omission statement. ∎

Every schedule on the full residue domain still has worst-case cost
`k(p-1)`: at each reached prefix there are two children of local cost `p-1`,
so recursively choosing one produces a residue attaining the bound. Thus a
declared distribution changes expectation but not minimax query complexity.

## Formation does not disappear into coding

The theorem optimizes sensing only. In the canonical center geometry

\[
C_{\ell,d}=M+1-(a+(d+1)p^\ell),                               \tag{4}
\]

one subtraction of the held scale moves from `d` to `d+1`. Therefore the
one-scale monotone chain requires increasing digit order.

Already at `p=3,k=1`, take

\[
P(D=0)=1/10,\quad P(D=1)=2/10,\quad P(D=2)=7/10.
\]

Canonical order has expected query cost `19/10`. Every optimum tests digit
`2` first and has cost `13/10`. Its next possible test is digit `0` or `1`,
which moves upward from `C_2` and cannot be performed by the canonical
subtract-`p^ell` transition. Query-optimal coding and monotone cached-center
motion therefore need not coincide. Their joint optimization requires a
typed price for forming or reversing center transitions.

## Rigor boundary

The theorem is exact for forward valuation-query counts under a declared
finite distribution, arbitrary digit dependence, and prefix-adaptive child
orders. Clean oracle cost is twice this count under per-query uncomputation.
No expected subtraction optimum, joint exchange rate, distribution-learning
procedure, or claim of novelty is made. The executable checks replay the
formula against exhaustive local schedules and a brute-force policy search.

