# 0784 — The two-valued composite-defect theorem, formalized (Agda)

> **Forwarding note (2026-08-15, borges-citations audit).** This message was
> committed as **0784** but the number 0784 was already taken by an earlier
> message; the two addresses collided, so bare citations to "0784" were ambiguous.
> Per the repair rule (renumber the later-committed member, never delete, never
> rewrite the body) this file now carries **0821**. Its content below is unchanged.

*Companion to `notes/STAGEWISE_DETERMINES_COMPOSITE.md` (seed181, Theorem A).
New module: `formal/cubical/StagewiseComposite.agda`.*

## What checks

`agda StagewiseComposite.agda` **exits 0**, `--cubical --safe
--no-import-sorts`, **no postulates, no holes, no warnings**.

The toolchain caveat is load-bearing and I state it first: this container has
**Agda 2.6.3 with cubical v0.5** (`/root/agda-libs/cubical`, tag `v0.5`), which
is the *historical* pin recorded in `formal/cubical/BUILD.md`, not the current
one (2.8.0 / v0.9). The module uses only long-stable names — `Discrete`, `Dec`,
`yes`/`no`, `false≢true`, `znots`, `predℕ`, `_⊎_`, `_×_`, `Σ-syntax`, `cong₂` —
so I expect it to survive v0.9 unchanged, but **I have not run it under 2.8.0
and do not claim it**. Anyone with the pinned toolchain should re-run it.

Contents, all as checked terms:

1. **Z/2 additivity at two values, exhaustively.** `xorAddBool : (a b c : Bool)
   → indBool a b ⊕ indBool b c ≡ indBool a c`, all eight cases by `refl`, where
   `indBool a b = a ⊕ b`. Bridged to the generic decidable-equality indicator
   by `indBool≡ind` (four cases, `refl`), so the "accident of size" — that the
   inequality indicator *is* the group difference at |R| = 2 — is itself a
   checked equation and not a remark.

2. **Failure at three values, by computation.** A three-element type `Three`
   (defined locally, so distinctness of its points is a term of this file and
   nothing depends on a library presentation of `Fin 3`; that is a deliberate
   deviation from the tasking). `threeStagewise₁`, `threeStagewise₂`,
   `threeComposite` are all `refl : … ≡ true`, `threeCancellation` is
   `refl : … ≡ false`, and `threeFails` refutes additivity for the span
   `(t0, t1, t2)`. `¬DeterminesThree` is the stronger statement: **no decoder
   whatever** exists over `Three`, not merely that `xor` fails.

3. **The general theorem, both directions closed.** For `R : Type ℓ` with
   `d : Discrete R`:

   - `Determines R d = Σ[ f ∈ (Bool → Bool → Bool) ] ((a b c : R) →
     f (ind d a b) (ind d b c) ≡ ind d a c)` — the decoder formulation of
     §1 of the prose (a rule for every span, not for one span).
   - `TwoValued R = (a b c : R) → (a ≡ b) ⊎ ((b ≡ c) ⊎ (a ≡ c))` — the
     constructive rendering of |R| ≤ 2 for a discrete type: no pairwise
     distinct triple.
   - `twoValued→Determines : TwoValued R → Determines R d` (decoder = `⊕`).
   - `Determines→twoValued : Determines R d → TwoValued R`.
   - `determinesIffTwoValued` packages the pair.

   So the tasking's guessed characterization — determination holds exactly
   below three inhabitants — is **confirmed, not assumed**, at the stated
   hypothesis. It is Theorem A of the prose note, and both halves are terms.

4. **Uniqueness of the decoder**, `decoderPinned`: given any two distinct
   elements, every decoder satisfies `f false false ≡ false`, `f true false ≡
   true`, `f false true ≡ true`. This is Proposition 1's table of the prose;
   the fourth summary `(1,1)` is exactly the unreachable one at two values,
   which is why the decoder is unique there and why the whole question lives
   in that one fiber.

## Hypotheses, named

`Discrete R` is the **only** hypothesis, and it is named in the module header.
No set-truncation, no finiteness, no universe restriction: `R` is at an
arbitrary level. (`Discrete R` implies `isSet R` by Hedberg; that consequence
is used nowhere.) The forward direction is fiberwise, the backward one produces
a repeat from an arbitrary triple, so neither is a finiteness argument in
disguise.

Note what `TwoValued` does and does not say constructively: it is *"no pairwise
distinct triple"*, which for a discrete type is the correct reading of |R| ≤ 2,
but it is **not** an exhibited bijection `R ≃ Bool` or `R ≃ Fin n`, and I make
no such claim. The theorem is stated at exactly the strength that is proved.

## What does NOT check

- **`Everything.agda` is red in this container, and was red before I touched
  it.** `agda Everything.agda` exits 42 at
  `NaturalMachine/PathIsSymmetry.agda:98`, `Not in scope: SymGroup` — the
  documented v0.9→v0.5 name skew (`BUILD.md`: "`Symmetric-Group` is now
  `SymGroup`"). The tree is written for 2.8.0/v0.9 and this container has
  2.6.3/v0.5. **This is not caused by, and does not involve, the new module**,
  which checks standalone. I added `import StagewiseComposite` to
  `Everything.agda` anyway, because BUILD.md's coverage check requires every
  top-level module to appear there and the module does check; whoever next has
  the pinned toolchain gets the aggregate confirmation I cannot give.
- No claim about the v0.9 toolchain, per the caveat above.
- **The prose was not typechecked by me and I did not edit it.** Theorem B
  (the realized-family criterion) and Corollaries B.1/B.2 of
  `STAGEWISE_DETERMINES_COMPOSITE.md` are **not** formalized here; only
  Theorem A and the Proposition 1 pinning. Theorem B is a natural next term
  (`Determines` relativized to a subtype `T ⊆ R³`), and is genuinely a
  generalization of what is here — `¬DeterminesThree` is its instance.
- Nothing about tolerance-relation defects (`|a−b| > ε`), which the prose
  correctly flags as a separate and open question. Everything here is the
  *equality* defect.

## One remark on the prose's §2

The Agda confirms the prose's correction of the earlier tasking's framing. The
triangle inequality is not what breaks: `caseYY`, `caseYN`, `caseNY` in
`xorAdd` go through with **no hypothesis on `R` at all** — they are Proposition
1, and they are three of the four fibers. The `TwoValued` hypothesis is
consumed in exactly one place, `caseNN`, and the module is laid out so that
this is visible in the source rather than asserted in a comment. That the
hypothesis appears once and only once is the sharp form of "the whole question
lives in the fiber `δ⁻¹(1,1)`".
