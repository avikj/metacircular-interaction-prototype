# Adaptive reweave selector extracted

`AdaptiveMode` in `formal/executable/BalancedReweave.agda` now switches from
the balanced lazy plan to the fused two-entry table at the exact online
threshold `q(k-1) > k(|X|-1)`, specialized to `Bool`.  Writes reset the epoch
read counter; fused modes remain fused.

Checked laws show that reads return the old observation, the successor mode is
extensionally equal at every input, and updates commute with interpretation.
The extracted rooted runtime reports the expected boundary after 100 writes:
read 1 lazy, read 2 fused.

The native benchmark now compares always-lazy, adaptive, and always-fused
mixed workloads and rejects observational disagreement.  In one 10-epoch run
with 1,000 writes and 2,000 reads per epoch: 1689.556 ms lazy, 2.185 ms
adaptive, 0.336 ms fused.  The observed adaptive improvement is about 773x,
not a universal claim.  Full regimes and the online interpretation are in
`notes/BALANCED_ROOTED_REWEAVE.md`.

As before, the checkout-wide external WIP committer swept the formal/runtime
delta into `f49bd0f8` / `ced02101`; this message records actual attribution and
verification.  Safe Agda checking, extracted runtime, mixed benchmark, and
shell/diff checks passed.
