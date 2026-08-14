# The complete future-view fibre of a productive Net

**Status:** checked bounded analogue.  The leaf module is
`formal/cubical/NaturalMachine/ProductiveObservationFiber.agda`.

## Random provenance

This theorem came from a literal no-redraw sample of the tracked semantic
corpus at tree `b3260d63494040ba40667701b9a242ce40c326f1`.  The stable frame
contained 949 bytewise-sorted tracked `.agda`, `.lean`, and `.md` paths under
`formal/`, `notes/`, and `papers/`, after build paths and five prior samples
were excluded.  Its newline-frame SHA-256 was
`d89432fdd52754ec824b009b7bd3b06b6fb117f6f7051e3d7051307af1ab65d4`.
The sole native-`uint32` draw was `3777681093`, giving zero-based index 589
(position 590): `notes/INFORMATION_LENS.md`, blob
`2c0dcdff87b74e62b0957c38c52a6df7114e7193`.

The sampled note says that an information claim should name its encoder and
compute its fibres.  For the linear `ProductiveIndraNet.Net`, the encoder is
therefore the complete stream of rooted views

```text
futureView : Net Root Jewel → (ℕ → TotalView Root Jewel).
```

It observes `Net.view` after every finite iteration of `Net.next`.

## Exact checked result

The previously checked bridge gives an equivalence between coinductive
bisimulation and pointwise equality at every future depth.  Function
extensionality turns that family into equality of the two complete codes:

```text
bisim≃futureViewPath :
  Bisim left right ≃ (futureView left ≡ futureView right).
```

Lifting this equivalence over all candidates identifies the actual encoder
fibre over a chosen centre:

```text
bisimClass≃futureViewFiber : (center : Net Root Jewel) →
  (Σ candidate , Bisim candidate center)
    ≃ fiber futureView (futureView center).
```

Thus the complete-observation fibre retains both the candidate Net and its
proof of observational agreement; no quotient or proof truncation is taken.
This is the precise fibre-level addition beyond
`ProductiveObservabilityBridge.bisim≃forever`.

Concurrent `SingletonActionObservability` reindexes the same depthwise law as
wordwise `FutureBehavior.FutureEq` and derives bounded-horizon implications.
It does not form equality of the complete depth-code function or its actual
homotopy fibre.  The present theorem is that smaller, complementary lift.

## Scope and non-reduction boundary

Huayan/Indra's Net is not reduced to category theory or to this stream model.
The theorem is an exact analogue for the single-successor, linear
`NaturalMachine.ProductiveIndraNet.Net` only.  It does not transfer to the
index-changing, all-branch `IndraNet.Coinductive.Net`; construct a final
coalgebra; supply Delta 25's `Image_xy`; or provide an explicit later
modality, clocks, entropy, cardinality, capacity, or a categorical
Grothendieck construction.  In particular, “fibre” here is the homotopy
fibre of the declared encoder, not a quantitative assertion about missing
bits.

## Verification

The current `origin/main` formal tree was extracted to a fresh temporary
directory, the new leaf copied into it, and Agda 2.8.0 ran:

```text
agda --ignore-interfaces -i <temp>/formal/cubical \
  <temp>/formal/cubical/NaturalMachine/ProductiveObservationFiber.agda
```

It exited zero under `--cubical --guardedness --safe --no-import-sorts`.
No interface was written into the shared repository.
