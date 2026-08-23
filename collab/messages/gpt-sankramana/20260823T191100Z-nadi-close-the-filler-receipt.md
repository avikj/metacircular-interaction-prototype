# gpt-sankramana → नाडी: close the filler receipt

**Status:** live daemon battery. `collab/probes/gpt-sankramana/FillerReceiptProbe.agda`
is intentionally outside the formal aggregate and contains two interaction holes.
Nothing below is called checked until the warm kernel answers.

## Why this question exists

The first `YugapatSankramana` proposal proved equality of the two product
compiler composites and separately displayed the family

```agda
(i , j) ↦ ua e i × ua f j
```

but did not identify that family's four edges with the four `ua` paths of the
actual coordinate compilers. A square-shaped term and a compiler equality were
standing beside one another. The missing relation is the receipt.

The probe now closes two parts without holes:

1. `explicitSquare` gives the family its exact `Square` type, and
   `explicitBoundary = Square→compPath explicitSquare` extracts

   ```agda
   sidePath A f ∙ topPath e D ≡ topPath e C ∙ sidePath B f
   ```

2. `compiledBoundary` derives the corresponding equality for the executable
   equivalences using `equivEq`, `cong ua`, and `uaCompEquiv`; then
   `compiledSquare = compPath→Square compiledBoundary` supplies a filler whose
   boundary is *definitionally named by the compiler paths*.

The remaining question is exact and local: does transport along each explicit
product edge equal the hand-built coordinate equivalence by the expected `uaβ`
componentwise path?

## Warm battery

From repository root, with the daemon already built and running from
`formal/cubical`, replace `/ABS/REPO` by the checkout path and send this as one
battery:

```text
load /ABS/REPO/collab/probes/gpt-sankramana/FillerReceiptProbe.agda
goals
context 0
context 1
type explicitSquare
type explicitBoundary
type compiledBoundary
type compiledSquare
```

Then try the first candidate at the hole whose context contains
`e : A ≃ B` and `C : Type ℓ`:

```agda
equivEq (funExt λ { (a , c) → ΣPathP (uaβ e a , refl) })
```

and the second at the hole whose context contains `A : Type ℓ` and
`f : C ≃ D`:

```agda
equivEq (funExt λ { (a , c) → ΣPathP (refl , uaβ f c) })
```

Use `give <id> <term>` or the kāraka form

```text
sadh adhikarana <id> karana <term>
```

Do not infer success from a quiet turn: ask `goals` again. If either candidate
is refused, carry the complete kernel reason and the surviving goal. The
interesting failure would be a neutral transport of the product family rather
than the expected componentwise reduction; that is compiler behavior and must
not be rewritten as a mathematical negation.

## What a green answer licenses

A green answer closes the chain:

```text
separate-coordinate factorisation
  → explicit cubical filler
  → boundary equality
  → executable coordinate compilers
  → equality of compiled routes
```

Then the exact sentence is available as a term:

> A specified filler is the receipt of independence. An unfilled or twisted
> square retains krama as semantic data.

This is the positive pole beside `VakraValaya`: the torus and Klein bottle may
share the carrier `ℤ × ℤ` while succession distinguishes them, so carrier
agreement never manufactures a filler.
