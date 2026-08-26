{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheCardinalFormOfTheFoolingBoundNeedsAnInjectionOfFinIntoFinAndDoesNotFollowByInstantiation
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Fooling sets and rectangle covers are communication-complexity
-- objects with no Indian source I can establish, and fabricating a
-- Sanskrit label would assert a provenance nobody checked — the mirror
-- image of the scrubbing the naming rule corrects.  Checked before
-- naming: `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; no row applies, and the frame
-- check's scope requires Indian material, which this module has none
--
-- ────────────────────────────────────────────────────────────────────
-- THE LINE, AND WHAT IT DECLARED IT WAS NOT DOING
--
--   AFoolingPairForcesTwoRectangles       one sound rectangle cannot
--                                         hold two fooling cells
--   AFoolingSetForcesDistinctRectangles   a sound cover is INJECTIVE on
--                                         a fooling family
--   NRectanglesCannotCoverSucNFoolingCells
--                                         and therefore `n` rectangles
--                                         cannot serve `suc n` cells
--
-- The second said, in its own words: *"INJECTIVITY IS NOT '≥ k'.
-- Turning 'distinct cells get distinct rectangles' into 'at least k
-- rectangles' is a COUNTING step."*  The third supplied the counting
-- step **in contrapositive form**, and justified that choice:
--
--   "'At least k rectangles' is a statement about a cardinal, and a
--    cardinal needs the cover's index to be finite and to be COUNTED.
--    … **That is the whole content of the numeric claim and it is
--    stated without a cardinality.**"
--
-- The first half is exactly right.  **The last sentence is the corpus's
-- recurring split, one more time: `the whole content` reads identically
-- in a strong and a weak sense.**
--
--   WEAK, and true.  For a cover indexed by `Fin n` against `suc n`
--   cells, the contrapositive carries everything the inequality would.
--
--   STRONG, and false.  The cardinal statement quantifies over covers
--   of ARBITRARY size `m` and concludes `suc n ≤ m`.  **That does not
--   follow from the third module by instantiation**, and §2 below says
--   precisely why: its `rects` is indexed by `Fin n`, so a cover of `m`
--   rectangles with `m ≤ n` cannot be handed to it at all — extending
--   `rects` to `Fin n` would require inventing rectangles and proving
--   them sound.  What is needed instead is an INJECTION `Fin m ↪ Fin n`,
--   and that injection is the arithmetic the module was avoiding.
--
-- WHAT IS PROVED
--
--   finIncl / finInclInjective
--                    `m ≤ n` gives an injection `Fin m → Fin n`.  In
--                    v0.5 `Fin n = Σ[ k ∈ ℕ ] k < n`, so this is
--                    `<≤-trans` on the proof component and injectivity
--                    is `toℕ-injective` — the underlying ℕ is untouched,
--                    which is why `cong toℕ` suffices.
--   atLeastSucNRectangles
--                    **the cardinal form**: a fooling family of `suc n`
--                    cells, covered soundly by ANY `Fin m`-indexed
--                    family under ANY assignment, forces `suc n ≤ m`.
--
-- HOW THE THREE CASES ARE PAID FOR, since this is where the counting
-- actually lives.  On `suc n ≟ m` (`Trichotomy`, kernel-decidable):
--   lt   `suc n < m`   → `<-weaken`, free
--   eq   `suc n ≡ m`   → `subst` on `≤-refl`, free
--   gt   `m < suc n`   → `pred-≤-pred` gives `m ≤ n`, then the
--                        injection, then `pigeonhole-special`, then the
--                        line's own injectivity theorem.  **Only this
--                        branch does any work, and it is the branch the
--                        contrapositive form already covered.**
-- So the cardinal form is the contrapositive form PLUS a trichotomy
-- PLUS an injection.  Two of the three branches are bookkeeping; naming
-- them is the point, because "it is just the contrapositive" hides that
-- the third branch changed shape.
--
-- WHAT IS NOT CLAIMED.  No UPPER bound, and nothing about "minimum
-- cover size = maximum fooling set" — that equality is false in general
-- for rectangle covers and nothing here bears on it.  No cover is
-- constructed.  Nothing about r_e, d_e, raw width, or
-- `DSOCutCalibration`'s matrix.  **The three modules above are NOT
-- amended and NOT retracted**: each is true as stated, and §1's quarrel
-- is with one sentence of a header, not with a theorem.  `Rect` here is
-- `Type₁`, inherited unchanged; no h-level is assumed of it.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheCardinalFormOfTheFoolingBoundNeedsAnInjectionOfFinIntoFinAndDoesNotFollowByInstantiation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; <-weaken ; pred-≤-pred ; <≤-trans
        ; _≟_ ; lt ; eq ; gt)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Fin using (Fin ; toℕ ; toℕ-injective)
open import Cubical.Data.Fin.Properties using (pigeonhole-special)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import AFoolingPairForcesTwoRectangles
  using (Rect ; Sound ; Covers)
open import AFoolingSetForcesDistinctRectangles
  using (Fooling ; foolingSetForcesDistinctRectangles)

------------------------------------------------------------------------
-- 1.  m ≤ n gives an injection Fin m → Fin n
--
-- Nothing about fooling sets here; this is the missing ingredient, and
-- it is stated separately so that its cost is visible.
------------------------------------------------------------------------

finIncl : {m n : ℕ} → m ≤ n → Fin m → Fin n
finIncl m≤n (k , k<m) = (k , <≤-trans k<m m≤n)

finInclInjective :
  {m n : ℕ} (m≤n : m ≤ n) (x y : Fin m)
  → finIncl m≤n x ≡ finIncl m≤n y → x ≡ y
finInclInjective m≤n x y p = toℕ-injective (cong toℕ p)

------------------------------------------------------------------------
-- 2.  The cardinal form
------------------------------------------------------------------------

module _ (Row Col : Type) (M : Row → Col → Bool) where

  atLeastSucNRectangles :
    (n m : ℕ)
    (r : Fin (suc n) → Row) (c : Fin (suc n) → Col)
    → Fooling Row Col M (Fin (suc n)) r c
    → (rects : Fin m → Rect Row Col M)
    → (pick : Fin (suc n) → Fin m)
    → ((i : Fin (suc n)) → Sound Row Col M (rects (pick i)))
    → ((i : Fin (suc n)) → Covers Row Col M (rects (pick i)) (r i) (c i))
    → suc n ≤ m
  atLeastSucNRectangles n m r c fool rects pick sound covers with suc n ≟ m
  ... | lt sucn<m = <-weaken sucn<m
  ... | eq sucn≡m = subst (λ z → suc n ≤ z) sucn≡m ≤-refl
  ... | gt m<sucn = ⊥.rec tooFew
    where
      m≤n : m ≤ n
      m≤n = pred-≤-pred m<sucn

      squash : Fin (suc n) → Fin n
      squash i = finIncl m≤n (pick i)

      collision : Σ[ i ∈ Fin (suc n) ] Σ[ j ∈ Fin (suc n) ]
                    (¬ i ≡ j) × (squash i ≡ squash j)
      collision = pigeonhole-special squash

      i    = collision .fst
      j    = collision .snd .fst
      i≢j  = collision .snd .snd .fst
      same = collision .snd .snd .snd

      pickEq : pick i ≡ pick j
      pickEq = finInclInjective m≤n (pick i) (pick j) same

      tooFew : ⊥
      tooFew =
        foolingSetForcesDistinctRectangles Row Col M
          (Fin (suc n)) r c fool
          (λ k → rects (pick k)) sound covers
          i j i≢j (cong rects pickEq)

------------------------------------------------------------------------
-- 3.  What changed, stated as a difference and not as a completion
--
-- `NRectanglesCannotCoverSucNFoolingCells` is the `m ≡ n` diagonal of
-- §2 read contrapositively, and §2 is not a strengthening OF it — the
-- two have different hypotheses and neither is an instance of the
-- other:
--
--   that module   fixes the cover's index at `Fin n` and concludes `⊥`
--   §2            leaves the index at `Fin m` and concludes an
--                 inequality in ℕ
--
-- Going from the first to the second is not weakening a hypothesis; it
-- is supplying `finIncl`, which did not exist on this line.  A reader
-- who took "that is the whole content of the numeric claim" at strength
-- would have believed §2 was already available and would have been
-- wrong by exactly one lemma.
--
-- STILL OPEN on this line, and unchanged by §2: any upper bound, and
-- any construction of a cover.  Both are different theorems, not gaps.
------------------------------------------------------------------------
