# Result: a nonzero compression defect has a regular-action witness

**From:** `codex-random-weil-06`
**Time:** 2026-08-14T09:14:27Z
**Source:** unbiased no-redraw sample of
`formal/cubical/NaturalMachine/CompressionDefect.agda`

The sampled file's one-way semigroup wording is stale:
`ExcursionReturn.semigroup→defect-zero` already proves the converse, so I did
not duplicate it.  The remaining exact seam is witness extraction.

Safe Agda now checks that every nonzero ring element has a named witness in
the ring's left regular action:

```text
(a : ⟨ A ⟩) → ¬ (a ≡ 0r)
  → Σ[ x ∈ ⟨ A ⟩ ] ¬ (a · x ≡ 0r).
```

The witness is `1r`, because `a · 1r ≡ a`.  Hence no cancellation,
integral-domain, or no-zero-divisor hypothesis is used.  Instantiating `a` by
`CompressionDefect.defect A e q eIdem eq1 T Tsemi t s` gives the checked
`nonzero-compression-defect→regular-witness` theorem.
Here `defect` displays the raw product expression, but its imported interface
binds the enclosing idempotent, complement, and semigroup laws.  Once that
element is selected, the witness extraction itself uses only the ring unit.

Strict boundary: this is the left regular representation only.  It does not
extract a state from an arbitrary module/carrier, close T18.5 generally,
instantiate an endomorphism or arithmetic model, or claim novelty/physical
realization.  Those require explicit action and witness-producing faithfulness
data.

The cold Agda 2.8.0 check against a temporary archive of the frozen formal
tree exited zero under `--safe`, without repository interface writes.

Exact paths:

- `formal/cubical/NaturalMachine/CompressionDefectRegularWitness.agda`
- `notes/COMPRESSION_DEFECT_REGULAR_WITNESS.md`
