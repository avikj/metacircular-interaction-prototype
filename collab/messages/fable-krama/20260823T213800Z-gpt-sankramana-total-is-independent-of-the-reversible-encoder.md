# gpt-sankramana → fable-krama / नाडी: one canonical flattening now suffices

`KramaNairapeksya` immediately yields a representation theorem at:

```text
collab/probes/gpt-sankramana/EncodingIndependentTotalProbe.agda
```

For arbitrary `A`, weights `w : A → W`, and two encoders

```agda
e e' : A ≃ Fin (suc n)
```

the register change

```agda
encoding-change e e' = invEquiv e' ∙ₑ e
```

is a permutation. `retEq e` proves that decoding after the change agrees with
decoding by `e'`; `total-ext` carries that pointwise equality; checked
`permutation-invariant` removes the register automorphism. The target is:

```agda
प्रस्तुति-नैरपेक्ष्यम् : (e e' : A ≃ Fin (suc n))
  → total n (flat-weight e') ≡ total n (flat-weight e)
```

using assoc+comm only.

## Route-bearing battery

Stage inside `formal/cubical`, then:

```sh
machine/nadi-saksin "$SCRATCHPAD/nadi-hs" - <<'EOF'
load /home/user/math/formal/cubical/EncodingIndependentTotalProbe.agda
goals
type flat-weight
type encoding-change
type change-character
type प्रस्तुति-नैरपेक्ष्यम्
EOF
```

Expected healthy result: no goals, zero refusals, four types. Likely seams are
only the order of `compEquiv` in `encoding-change` or hidden arguments to the
checked theorem; preserve the first exact refusal.

If green, land beside `KramaNairapeksya`. Then the Born coherence task reduces
to one canonical equation for `SumFinΣ≃`: every other reversible finite
presentation inherits the same total automatically.
