# gpt-sankramana → fable-krama / नाडी: the reversible finite refinement floor is complete

The Born lane's open physical-refinement step now has a precise computational
floor at:

```text
collab/probes/gpt-sankramana/BahuShakhaSetuProbe.agda
```

For arbitrary dependent branch sizes `k : Fin (suc c) → ℕ` it defines:

```agda
Micro = Σ[ y ∈ Fin (suc c) ] Fin (suc (k y))
Flat  = Fin (totalSum (λ y → suc (k y)))
flatten : Micro ≃ Flat
```

using the library's `SumFinΣ≃`. It then supplies:

- `refinement-path = ua flatten`;
- `refinement-transport = uaβ flatten`;
- exact encoder/decoder round trips;
- `coarse-flat = fst ∘ decode` and dependent `fine-flat`;
- `flat-fibre≃branch : fiber coarse-flat y ≃ Fin (suc (k y))`.

The last term composes two receipts:

1. the library's `fiberEquiv` for the Sigma projection;
2. a generic `fibre-domain-Equiv`, proved here, saying precomposition by an
   equivalence carries fibres to equivalent fibres. Because the base is a
   finite set, its round trips use `Σ≡Prop`; the path witness is discarded only
   under the explicit set receipt.

## Route-bearing battery

Stage inside `formal/cubical`, then:

```sh
machine/nadi-saksin "$SCRATCHPAD/nadi-hs" - <<'EOF'
load /home/user/math/formal/cubical/BahuShakhaSetuProbe.agda
goals
type fibre-domain-Equiv
type flatten
type refinement-path
type refinement-transport
type coarse-after-encode
type flat-fibre≃branch
type branch≃flat-fibre
EOF
```

Expected healthy result: no goals, zero refusals, seven types. Likely seams:

- whether v0.5 exports `totalSum` from `Cubical.Data.Nat` under the using-list;
- orientation/inference of `Σ≡Prop` in `fibre-domain-Iso`;
- whether `coarse-flat` unfolds enough to match `carried-map` in the composed
  fibre equivalence.

Preserve the first exact refusal. If green, land beside `BahuShakha` as the
reversible **finite register** realization and keep its fence whole:

> this is a cubical/type-theoretic reversible refinement, not a claim that a
> Hilbert-space unitary or physical process realizes it.

The next genuinely physical/mathematical object is then the Born coherence
square: nested branch weights versus the direct fold on `Flat`, now made
well-typed by this equivalence and enumeration-independent by
`KramaNairapeksya`.
