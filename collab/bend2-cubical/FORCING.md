# The fibre is forced — the last constitutive piece of the object, in Bend

`forcing.bend` (62/0, reproducible on pristine DKormann/Bend2 + cubical-paths.patch)
completes the Agda `Fibre.Trace` core on the interaction-net substrate. Together
with `fibrelaw.bend` (the fibre law A ≃ Σ B (fiber f), lossless transport) and
`roundtrip.bend` (univalence, both round trips), Bend now carries the WHOLE object.

## What is proved

A `Conservative` factorisation is `(T : B → Set, whole : A ≃ Σ[b] T b)`; it induces
the visible map `run a = fst (whole a)`. Then:

- `fibreOfRun`  : `fiber(run, b) ≃ T b`         — the trace family IS run's fibre family
- `traceIsForced` : `T b ≃ fiber(run, b)`       — so the fibre is the ONLY residue, up to
  equivalence: a factorisation cannot retain less than the fibre and remain a
  factorisation. The residue of a computation is not negotiable.
- `exactWhenContractible` : `(∀b. isContr(T b)) → isEquiv(run)`  — nothing forgotten ⇒
  the visible result is the whole event
- `contractibleWhenExact` : `isEquiv(run) → ∀b. isContr(T b)`    — and conversely

## How it was built

`fibreOfRun = compEquiv (fiberPrecomp whole) fiberFst`:

- `fiberFst : fiber(fst, b) ≃ T b` — the fibre of the first projection is the family
  (the mathematical heart). Its coherence square `ffRet` uses a coe-filler + De Morgan
  connections.
- `fiberPrecomp : fiber(g∘e, b) ≃ fiber(g, b)` — reindex the fibre base by an
  equivalence. Section via `compPath-filler'`; the retraction is the half-adjoint
  triangle coherence, read directly off the coherent fibre-contraction path (`cw`,
  `cwFst`, `cwSnd`) and closed with the left-unit law (`lUnit`) and a fiber-path
  composition.

## Checker features this required (all sound, additive, in cubical-paths.patch)

- `epNormCtx` recurses into `coe` (typed PathP endpoints under transport)
- interval idempotence `x∧x=x`, `x∨x=x` (connection fillers reduce)
- `verify` epNorm's both sides (typed endpoints reduce in type-formation)
- **definitional Σ-η**: `(a,b) ≡ n` iff `a≡fst n ∧ b≡snd n` — unblocks every
  neutral-pair projection; this is what let the coherent contraction be extracted.

## Status of the object in Bend

- univalence, both round trips ................. ✓ (roundtrip.bend)
- fibre law A ≃ Σ B (fiber f), lossless transport ✓ (fibrelaw.bend)
- **the fibre is forced (Trace core)** ......... ✓ (forcing.bend)

Every theorem in the Agda core that *constitutes* the object now has a green,
executable counterpart on the interaction-net runtime. The rest of the library
instantiates it.
