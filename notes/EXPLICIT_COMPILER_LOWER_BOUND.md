# Optimality within the explicit ladder-center compiler

The end-to-end valuation program achieves `kp-2` arithmetic formations from a
formed prime `p`. This note proves that count optimal under its exact operand
contract, without claiming optimality among different representations.

## Operand contract

An explicit ladder-center compiler must materialize:

1. every ladder power `p^2,...,p^k`, because these are the declared
   subtrahends and `p^k` is the initial positive zero center; and
2. every distinct center queried on the minimax all-`(p-1)` residue branch.

One arithmetic formation event produces at most one previously unformed
integer. The prime `p` and unit `1` are initially held.

## Exact lower bound

On the worst branch, before level `ell` the recovered prefix is `p^ell-1`.
For tested digit `d=0,...,p-2`, the positive center is

\[
C_{\ell,d}=p^k+1-(d+1)p^\ell.                    \tag{1}
\]

There are `k(p-1)` distinct centers: the chain theorem makes them strictly
decreasing. Its first center is `C_{0,0}=p^k`.

**Lemma.** No other center in (1) is a power of `p`.

*Proof.* Suppose `C_{ell,d}=p^m`. If `ell,m>=1`, reducing

\[
p^k+1=(d+1)p^\ell+p^m
\]

modulo `p` gives `1=0`, impossible. If `m=0`, cancellation of 1 gives
`p^k=(d+1)p^ell`, so `d+1=p^(k-ell)`. For `ell<k` the right side is at least
`p`, while `d+1<=p-1`. The remaining apparent endpoint `ell=k` is not a query
level. If `ell=0`, equation (1) is `p^k-d`; this equals a power only at `d=0`,
the initial center `p^k`. ∎

Thus the required new objects are disjointly:

- `k-1` powers `p^2,...,p^k` formed after the initial `p`;
- `k(p-1)-1` centers other than the already counted `p^k`.

**Theorem.** Every explicit ladder-center compiler needs at least

\[
(k-1)+(k(p-1)-1)=kp-2                           \tag{2}
\]

arithmetic formations on the minimax branch. `END_TO_END_VALUATION_PROGRAM`
attains (2), so it is optimal within this operand contract.

## Why the scope matters

The theorem does not show that every exact valuation sensor must explicitly
hold each `p^ell` or use these centers. A different representation might
generate translations through a circuit, trade formations for program state,
or avoid materializing displacements as integers. Quantum Process's
orthogonal-program theorem constrains one such alternative but is not a gate
lower bound. Hence unrestricted arithmetic optimality remains open.

## Rigor boundary

The distinctness, disjointness, count, and matching construction are proved.
Tests replay bounded sets as falsifiers. The lower bound is conditional on the
stated explicit-object contract and unit-output arithmetic events.

