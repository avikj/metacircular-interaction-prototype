# The output digit is the minimal reversible stopping record

At one level of adaptive valuation sensing, the next digit is
`d in {0,...,p-1}`. Candidates `0,...,p-2` are tested in order; the schedule
stops on success, while `d=p-1` means every test failed.

Define the number of tested candidates

\[
q(d)=\begin{cases}d+1,&d\le p-2,\\p-1,&d=p-1.\end{cases}       \tag{1}
\]

## Sufficiency

**Theorem 1.** Retaining `d` suffices to reverse the variable-length clean
schedule with no response transcript.

*Proof.* Forward, each tested response is immediately copied into the digit
decision and unqueried before the center changes. Thus response scratch is
zero after every test. Equation (1) reconstructs exactly which candidate
centers occurred. In reverse, use the retained prefix to recover the prior
prefix by removing `d p^ell`, regenerate the same centers in reverse order,
and invert their clean compute/query/copy/unquery steps. No response value
needs to persist. ∎

An active flag is transient control inside the level; it is not persistent
after `d` has been written. Across levels, the digits are already the exact
residue output, so the logical branch record can be encoded in the output
prefix rather than in an additional history register.

## Necessity

**Theorem 2.** Any deterministic exact record from which the post-level state
can be reversed for all `p` digit outcomes has at least `p` distinguishable
values.

*Proof.* The `p` outcomes update the prefix to the `p` distinct residues
`a+d p^ell mod p^(ell+1)`. If two outcomes had the same retained record and
all scratch were cleared, the same post-level state would have two distinct
preimages distinguished only by the erased branch. A reversible map is
injective, contradiction. Hence the record separates all `p` outcomes. ∎

This is a logical alphabet lower bound, not necessarily an extra-register
lower bound: the output digit itself realizes it. In a coherent implementation
the corresponding outcome subspaces are orthogonal because they are distinct
computational-basis digits.

## Exact variable schedule

The number of forward valuation queries is `q(d)` and clean oracle invocations
are `2q(d)` at a digit. The worst case remains `2k(p-1)`. Unlike the fixed
schedule, early stopping preserves the monotone center chain. Its advantage is
branch-dependent and therefore cache-relative, consistent with
`CACHE_RELATIVE_FORMATION_COST`.

## Rigor boundary

The sufficiency and alphabet lower bound are proved for deterministic exact
early stopping with clean per-query uncomputation. Tests replay forward and
reverse schedules. No approximate compression, physical gate lower bound, or
minimum encoding in qubits beyond `ceil(log2 p)` is claimed.

