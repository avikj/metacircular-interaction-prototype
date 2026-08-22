# 0800 — `PolarityClosure.agda` is green under the pin; the open edge was already closed

2026-08-15, Claude (Grothendieck lineage).

## 1. The repair

`formal/cubical/PolarityClosure.agda` defined `Sub`, which collides with
Agda 2.8.0's builtin `Agda/Builtin/Cubical/Sub.agda`. Renamed to `Pow`
(it is the powerset-of operator, `Pow T = T → Type ℓ`). That was the whole
of it — §6.3 of `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` predicted the
diagnosis correctly and there were **no further errors behind the first**,
contrary to the reasonable expectation that there would be.

```
LC_ALL=C.UTF-8 <pin>/agda --library-file=<v0.9 libraries> PolarityClosure.agda
  EXIT=0        # Agda 2.8.0 + cubical v0.9  (the BUILD.md pin)
LC_ALL=C.UTF-8 agda PolarityClosure.agda
  EXIT=0        # Agda 2.6.3 + cubical v0.5  (the container accident)
```

Green under **both**. Unlike `Sl2TensorProduct`'s `·Rid`/`·IdR` (§6.4), this
rename forces no choice between toolchains, so the row is simply repaired.
The pinned 2.8.0 binary built by the release-engineering pass was still in
this session's scratchpad and was reused; nothing was rebuilt.

Added `import PolarityClosure` to `Everything.agda`, meeting that file's
stated bar (verified exit 0 individually first — here, under both
toolchains). `Everything.agda` remains red under the pin for §6.4's
unrelated `Sl2TensorProduct` reason.

## 2. The mathematics still says what it was written to say

Read `notes/APOHA_AND_POLARITY.md` in full and checked the module against it
line by line. Everything the note is owed is present and now machine-checked,
`--cubical --safe`, no postulates, no holes:

- **§1** `perp⁺-anti`, `perp⁻-anti` (both maps antitone — this is the check
  that the ANTITONE closure of `CHANGING_TESTS_VERSUS_SHRINKING.md`
  Prop. 6.3 is in hand, not Theorem B's monotone `C_σ`; the note's §3
  correction of D0020 §J3's pointer is thereby respected in the formalism);
  `galois-→`/`galois-←` (Galois connection, antitone form); `cl-ext`,
  `cl-mono`, `cl-idem` — **unconditionally in ε**, no hypothesis on ε, A, B
  or the subsets. That is the note's §2 "yes, unconditionally", and D0020
  §J3's question, as terms. The mirror `cl'` on the χ⁺ side is there too.
- **§2, the sharp finding, intact and if anything stronger than the note.**
  `perp-is-complement`, `cl-is-¬¬`, `cl-identity-on-Dec`,
  `boolean-gloss-vacuous`. The vacuity of D0020 §5's boxed display under its
  own Boolean gloss is proved, and the module is honest about a point the
  note glosses: constructively `cl α = ¬¬α` always, and `= α` exactly on
  decidable α. The note's "α^⊥⊥ = X \ (X \ α) = α" quietly uses excluded
  middle; the Bool-valued corollary is the honest form. **Nothing weakened,
  nothing missing — no restoration was needed.**

## 3. The contrast case, added

The module already had a one-point witness (`Contrast`: `Unit` with the
total relation, `cl-not-identity`). I added `Contrast2` on a **two-point**
universe, because the one-point case is open to the reply that the only
alternative to the identity is the constant full map. It is not. Take
X = Bool (= Fin 2) and ε(x,y) := (x ≡ true), a legitimate two-sided
evaluation:

- `cl-T : cl {true} ≐ {true}` — so `cl` is **not** the constant map;
- `cl-F-not-identity : ¬ (cl {false} ⊑ {false})` — witnessed by
  `cl-F-true : cl {false} true`, since the polar of `{false}` is empty —
  so `cl` is **not** the identity.

A genuine, non-degenerate closure at |X| = 2. Vacuity is therefore a
property of the Boolean gloss (ε = inequality), not of the universe's size
and not of the construction. That is exactly the note's §4.1 claim,
now with a checked non-example on both sides.

## 4. The open edge — settled, and it was already settled in the file

The prompt flagged the flattening α^⊥̂⊥̂ = ⋂_ι α^⊥_ι⊥_ι against Def. B.3's
own remark that idempotence of an intersection of closures is not automatic.
This is the mathematical prize and I want to be exact about who earned it:
**the proof was already written in `module Indexed` and had simply never
typechecked, because the file never got past line 103.** It now does. What I
verified rather than authored:

- `flatten : clHat α ≐ ⋂cl α`, both inclusions. The two terms are pure
  quantifier reassociation — currying `(i , b)` — which is the honest reason
  the identity holds and why no hypothesis on the index type I is needed
  (I may be empty, in which case both sides are the full subset).
- `intersection-idem : ⋂cl (⋂cl α) ≐ ⋂cl α`, obtained by transporting §1's
  unconditional `cl-idem` across `flatten`.

So Def. B.3's remark is correct in general and **inapplicable here**: this
intersection is idempotent not because intersections of closure operators
are (they are not), but because this particular intersection *is itself a
double polar* — of the disjoint-union context A × (I × B). The note calls
that an explanation; it is now a proof. `intersection-ext` and
`intersection-mono` complete it to a closure operator outright.

The general frame is the one that makes it trivial, which is the point: an
indexed family of contexts on a fixed A is a single context on A with
attribute set I × B, and everything about the family is a statement about
that one context.

## 5. Scope limits

- The rename is the only change to the mathematics of the module; §§1, 2, 4
  are byte-identical modulo `Sub` → `Pow`. §3b (`Contrast2`) is new.
- I did **not** edit `notes/APOHA_AND_POLARITY.md`. Its status line ("No
  Agda or Lean was authored or typechecked") is a true statement about that
  note's own pass and I am not rewriting someone else's honesty ledger; this
  message is the pointer that the module discharging it is now green.
- I did **not** run any other module against the pin. §6.5's scope limits
  stand; in particular the pinned binary lives in a scratchpad and dies
  with the session.
- **Concurrent work observed and not touched:** `Sl2TensorProduct.agda` has
  uncommitted edits in this working tree (the `·Rid` → `·IdR` fix and a
  `Bn` header/`Rk2≡Bn2` addition) and there is an untracked
  `formal/cubical/check.sh`. Neither is mine. I staged **only** my own
  files rather than `git add -A`, so that in-flight work is neither
  committed under my name nor destroyed (PROTOCOL §5).
- Exit 0 is a statement about typechecking. The claim that the terms mean
  what §§1–4 say they mean rests on my reading of the types, reported above.
- No measurement, no fitted constant, no floating point, no Python.
