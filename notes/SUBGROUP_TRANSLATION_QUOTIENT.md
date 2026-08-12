# Restricted translation futures interpolate valuation and residue

Let `R=Z/p^k Z`, with truncated valuation

\[
\tau_k(r)=\min(v_p(r),k),\qquad \tau_k(0)=k.
\]

Fix `0<=j<=k` and admit only translations by the additive subgroup
`H=p^jR`. The future behavior of `r` is

\[
B_H(r)(h)=\tau_k(r+h),\qquad h\in H.
\]

## Classification theorem

**Theorem.** Two residues have equal restricted future behavior exactly in
the following cases:

1. they are the same residue in `H`; or
2. both lie outside `H` and have the same valuation, necessarily `<j`.

Consequently the behavioral quotient has

\[
|H|+j=p^{k-j}+j
\]

classes.

*Proof.* If `r` is outside `H`, write `e=tau_k(r)<j`. Every `h in H` has
valuation at least `j>e`, so the ultrametric equality gives
`tau_k(r+h)=e`. Thus its entire behavior is the constant `e`, proving both
indistinguishability within each outside valuation stratum and separation of
different strata.

If `r` lies in `H`, then the response reaches depth `k` exactly once, at
`h=-r`. Hence its behavior reconstructs `r` and distinct elements of `H` are
separated. Such a behavior is also nonconstant unless `H={0}`; at `j=k`, its
unique element is zero with constant response `k`, still distinct from every
outside stratum `0,...,k-1`. This proves the classification and count. ∎

At `j=0`, all translations are available and the quotient is the full residue
ring, with `p^k` singleton classes. At `j=k`, only zero translation is
available and the quotient is exactly truncated valuation, with `k+1`
classes. Intermediate `j` retains exact residues on the reachable ideal and
only valuation outside it.

## Predictive and quantum meaning

This is a positive restriction theorem complementary to the infinite-cache
no-go. The action language itself determines which distinctions survive:
forming a smaller translation step enlarges `H`, splits former valuation
classes, and moves the predictive quotient toward exact residue.

Codex Quantum Process's orthogonal-profile theorem applies immediately. Under
zero-error readout of every restricted future response, the least Hilbert
dimension is also `p^(k-j)+j`; nonorthogonal states do not compress it.

## Rigor boundary

The classification and endpoint cases are proved above. Finite enumeration is
only a falsifier. This concerns semantic response profiles on one finite
prime-power ring; it does not price how translations are located or formed,
nor approximate readout, coherent construction, or inverse-limit memory.

