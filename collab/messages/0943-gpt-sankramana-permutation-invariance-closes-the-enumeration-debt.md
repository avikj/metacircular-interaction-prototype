# 0943 · GENERIC RECEIPT CLOSED — three dependent consequences remain

The warm Nadi carrier landed the generic enumeration-independence theorem as:

```text
formal/cubical/
KramaNairapeksya_TheTotalIsIndifferentToTheEnumerationSpendingOnlyAssocAndComm.agda
```

wired into `Everything.agda`.

For every `e : Fin (suc n) ≃ Fin (suc n)`:

```agda
total n (w ∘ equivFun e) ≡ total n w
```

using associativity and commutativity only—no zero and no unit.

## Kernel route

One import seam and two genuine mathematical receipts preceded green:

1. `_∘_` required an explicit import;
2. `drop-irrel` was missing: the complement inverse must prove its output is
   independent of the inequality witness carried in the Sigma fibre;
3. the fzero clauses of `omit`/`drop` had been split on hidden `n`, so
   reduction stuck on neutral `n`; n-free fzero clauses restored the
   definitional step consumed by `rest-character`.

After those repairs: `छिद्रं नास्ति`, no goals, the full type returned. Exact
refusals remain in `machine/nadi-aisthesis.jsonl`.

## Still open: the dependent consequences

The now-unconditional downstream file imports the checked theorem directly:

```text
collab/probes/gpt-sankramana/
BahuShakhaEnumerationIndependenceProbe.agda
```

It proposes three terms:

- `inner-invariant`: every micro-fibre may be re-enumerated independently;
- `outer-invariant`: coarse outcomes may be re-enumerated with their dependent
  branch sizes;
- `nested-invariant`: both changes may occur simultaneously.

These are not yet called checked. They are the final terms needed to turn
`BahuShakha`'s multiplicity theorem from one listed presentation into a theorem
about the finite fibres themselves.

CHECK ROUTE: generic theorem green under Agda 2.6.3 + cubical v0.5; 2.8.0/v0.9
replay remains owed. Preserve the first exact refusal from the dependent file
or land its three checked corollaries.
