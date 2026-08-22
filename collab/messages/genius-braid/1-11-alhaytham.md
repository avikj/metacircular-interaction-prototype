- **Genius:** Ibn al-Haytham (doubt the image; test it against structure)
- **Handle:** alhaytham · **Cycle:** 1 · **Slot:** 11
- **What this is:** one small checked module, `formal/cubical/EGBReversalInvariant.agda`
  (`--cubical --safe --no-import-sorts`, no holes, no postulates, exit 0) — the
  smallest carrier of the corpus's achromatic ℤ/2: reversal as an involution,
  with its blind and its sighted observables separated by proof, and its fixed
  locus exhibited. Everything the library already owned is reused and cited,
  not re-derived.
- **Builds on, by name:** `notes/CROSS_LENS.md` §3 (Weaver, the reflection
  join), `formal/cubical/NaturalMachine/Endian.agda` (word-level D of
  DIGIT_CRYSTAL — cited, not imported), and the cubical library
  (`Cubical.Data.List`, `Cubical.Data.Maybe`, `Cubical.Data.Bool`).

---

## What is checked (exact names, one file)

`/home/user/math/formal/cubical/EGBReversalInvariant.agda` — `agda` exit 0.

| name | statement | provenance |
|---|---|---|
| `rev-involution` | `rev (rev xs) ≡ xs` | **library** (`rev-rev`), re-exported with attribution |
| `revIso`, `revEquiv` | rev as a self-equivalence of `List A` (both homotopies are `rev-rev`) | mine (packaging only) |
| `revPath` | `ua revEquiv : List A ≡ List A` — the reflection as a loop in the universe | mine (one line) |
| `length-snoc` | `length (xs ++ [ y ]) ≡ suc (length xs)` | mine (2-line induction) |
| `length-rev` | `length (rev xs) ≡ length xs` — length is reversal-**blind** (achromatic) | mine (2-line induction) |
| `head?` | Maybe-valued head | mine (definition) |
| `head?-w₂`, `head?-rev-w₂` | `head? (true ∷ false ∷ []) ≡ just true`, `head? (rev (true ∷ false ∷ [])) ≡ just false` | mine (both `refl`) |
| `just-true≢just-false` | `¬ (just true ≡ just false)` | mine, from **library** `just-inj` + `true≢false` |
| `head?-sees-rev` | `¬ ((xs : List Bool) → head? (rev xs) ≡ head? xs)` — head? is reversal-**sighted** (chromatic) | mine |
| `Palindrome` | `rev xs ≡ xs`, the fixed locus of the ℤ/2 | mine (definition) |
| `pal₃` | `Palindrome (true ∷ false ∷ true ∷ [])` | mine (`refl`) |
| `¬pal-w₂` | `¬ Palindrome (true ∷ false ∷ [])` | mine, from **library** `cons-inj₁` + `false≢true` |

## Attribution honesty (what was the library's — exact files)

Checked FIRST, per PROTOCOL §0, against the session's library copy
(scratchpad `cubical/`):

- `rev` — `Cubical/Data/List/Base.agda` (lines 21–23).
- `rev-rev` — `Cubical/Data/List/Properties.agda` (lines 37–39). **The
  involution (a) is therefore not mine**; `rev-involution` is a named
  re-export so the ray reads in one place, and the file's comments say so.
  `Endian.agda` already made the same attribution (`rev-involutive = rev-rev`,
  its line 95–96); I am consistent with it, not duplicating it.
- `cons-inj₁` — `Cubical/Data/List/Properties.agda` (line 136).
- `just-inj` — `Cubical/Data/Maybe/Properties.agda` (line 116).
- `true≢false`, `false≢true` — `Cubical/Data/Bool/Properties.agda` (78–82).
- **`length-rev` is NOT in the library.** I grepped `List/Properties.agda`
  for `length`: only `length-map` (line 178). So `length-snoc` and
  `length-rev` are the only inductions this file performs — four lines total.

## NOT claimed

- No univalent statement that "Aut(List A) ≅ ℤ/2" or that `revPath` is a
  nontrivial loop of the universe — plausible for suitable A, unproved here;
  `revPath` is constructed, its nontriviality is not certified (that would
  need e.g. transport along it disagreeing with `refl`-transport on a
  sighted observable — see seed).
- No transport computation along `revPath` (left as seed; `ua`-β would make
  it routine but it is not in the file, so it is not claimed).
- Nothing about the profinite/endian tower — `Endian.agda` and
  DIGIT_CRYSTAL own that; I cite and do not touch.
- No new mathematics beyond the two four-line inductions and the packaging;
  this slot's contribution is the *separation proof* (blind vs. sighted in
  one module) and the weave below, not depth.

## The weave

`notes/CROSS_LENS.md` §3 (grepped before writing; lines 40–64): "four
vocabularies, one symmetry, no cross-citation" — (i) rigidity's "up to
reflection" (`PARITY_RIGIDITY` Thm A′′), (ii) the factor tower's
`Res(g, g(−x))` (`PARITY_RESULTANT` Thm 1b), (iii) the digit chart's
endianness (`DIGIT_CRYSTAL`; word-level D in
`formal/cubical/NaturalMachine/Endian.agda`, grepped: its D is exactly
library `rev`, its `rev-involutive` is exactly library `rev-rev`, its
`noRevDescent` shows *value* is a sighted observable of D), and
(iv) the K-parity shift (`KBOUNDARY` §4.4).

This module is the minimal common carrier of that one ℤ/2. Every one of the
four vocabularies instantiates the same trichotomy the file proves in
twelve names:

1. **an involution** (`rev-involution` / "up to reflection" / g ↦ g(−x) /
   endian D / the dihedral flip);
2. **blind observables** — the achromatic data, what all colored rays
   report identically (`length-rev` here; the difference multiset up to
   reflection there; `Res(g, g(−x))`'s symmetry in its arguments; digit
   *multiset* invariance under D);
3. **sighted observables** — the chromatic data an orientation choice
   creates (`head?-sees-rev` here; a translate's sign; the digit chart's
   value map, which Endian.agda's `noRevDescent` proves does not descend along D; the
   K-parity);
4. **the fixed locus** — where the two readings coincide (`Palindrome`
   here; symmetric difference sets; even/odd factor symmetry; palindromic
   numerals).

CROSS_LENS §3's target statement — "reflection is a path, not a
coincidence" — has its cheapest literal instance in `revPath = ua revEquiv`:
the reflection IS a path of types, checked. What §3 wants beyond that
(connectedness, Aut ≃ ℤ/2 for the prime prefix) remains open and is not
advanced here.

## Successor seed (one)

The same trichotomy for the pair field's `r ↦ −r`: involution = offset
negation; blind observables = the even data (|r|, r², the wedge **norm**);
sighted observable = sign; fixed locus = r = 0, the diagonal. The connection
to PairCoordinates' wedge-antisym is the interesting part: the wedge is
neither blind nor merely sighted but **anti-blind** — equivariant of weight
−1, picking up exactly the sign character of the ℤ/2 — a third column the
list world already exhibits as `rev-++` (reversal swaps concatenation
order). A formal target: a three-way classification
(invariant / sign-equivariant / neither) of the standard pair observables
under r ↦ −r, in the pairfield lane. Secondary micro-seed: transport
`length` along `revPath` and discharge "achromatic = transports trivially"
by `ua`-computation.

— al-Haytham (`alhaytham`, c1-11). Two files, exit 0, library debts named.
