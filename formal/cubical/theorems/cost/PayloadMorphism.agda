{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PayloadMorphism
--
-- "MINIMAL CARRIER" IS NOT A PROPERTY OF A PAYLOAD.  It is a property of
-- a payload TOGETHER WITH a class of admissible transformations, and the
-- number changes when the class does.
--
-- WHY THIS MODULE EXISTS (the correction chain, in order):
--
--   1. `CompileBridge` §I `ArithmeticPayload` (this author) fixed the
--      DATA a native payload must carry — shape-indexed datum,
--      composition, semantics, `unfold`-preservation, separate cost —
--      and never fixed the transformations under which that data may be
--      re-presented.  So every carrier/rank notion it implies is
--      underdetermined.
--      is the no-go that names the omission: the k = 3 Möbius residual
--      r = -6 Z₂ + 12 Z₁ - 8 Z₀ has unrestricted carrier rank 1 (as the
--      single map 1 ↦ r) and graded carrier rank 3 (one channel per
--      residue depth) — the SAME payload, two carriers, purely from the
--      morphism class.
--      that once a DIFFERENTIAL is present the class is not free: a
--      subcomplex containing U in degree one must contain d(U) in degree
--      zero, so the carrier is dim U + dim d(U), forced by the chain-map
--      law rather than by an encoding convention.
--
-- This module answers all three inside the substrate: the class becomes
-- an explicit parameter (§B), the separation is PROVED rather than
-- transcribed (§E-§F), and the closure phenomenon is proved as a third
-- class in the same interface (§G).
--
--
-- WHAT IS CHECKED
--
-- B. `MorphismClass Tgt` (§B) — the parameter that was missing.  A class
--    declares its carriers `Obj`, their `rank`, their elements, the
--    admissible maps `Hom c` into the target, and TWO LAWS: an
--    admissible map sends the zero element to the target's zero, and a
--    rank-zero carrier has only the zero element.  `Factors`,
--    `FactorsAt` and `MinCarrier` are then defined once, for every
--    class.
--
--    B1 `min-unique`          WHAT FIXING THE CLASS BUYS, in general:
--                             for ANY class and ANY payload, a minimal
--                             carrier rank is unique when it exists.
--                             (`MinCarrier` is a partial function of the
--                             pair (class , payload) — before the class
--                             is fixed it is not even that.)
--    B2 `factorsAt0→null`     the laws' one use: in any class, only the
--                             target's zero factors through rank 0.
--
-- C-E. Two classes over the same graded target `Layer n = Fin n → ℤ`
--    (coordinate j is the coefficient of the depth-j layer, so the
--    object is literally a finite direct sum over residue depth).
--
--    D  `Uncls n`             UNRESTRICTED: a carrier is a bare ℤ^m, an
--                             admissible map is an arbitrary matrix
--                             ℤ^m → Layer n.  One channel may feed every
--                             degree.
--       `U-min-one`,          minimal carrier is 1 for every nonzero
--       `U-min-zero`          payload and 0 for the zero payload.
--    E  `Gcls n`              GRADING-PRESERVING: a graded carrier IS its
--                             dimension vector `Fin n → ℕ` (that is the
--                             classification of f.g. free graded
--                             modules), rank is the total dimension, and
--                             degree j of the output reads only degree j
--                             of the input.
--       `G-degreewise`        that condition, stated and checked.
--       `G-needs-channel`     a nonzero layer forces a channel at its
--                             own degree,
--       `G-rank-bound`        hence graded rank ≥ support size,
--       `G-factors-supp`      and the bound is attained,
--       `G-min`               so the minimal graded carrier IS the
--                             support size, for every payload.
--       `G-carrier-determined`,
--       `U-carrier-determined`
--                             WHAT FIXING THE CLASS BUYS, sharpened from
--                             uniqueness to a closed form: in these two
--                             classes any minimal rank EQUALS `supp r`
--                             resp. 1.
--
-- F. THE SEPARATION, at the note's own residual.
--
--    `r₃ = -6 Z₂ + 12 Z₁ - 8 Z₀`, `supp-r₃ : supp r₃ ≡ 3` (`refl`).
--    F1 `minimal-carrier-depends-on-class`
--                             one payload, two classes, minimal carriers
--                             1 and 3, with `¬ (1 ≡ 3)`.  Both numbers
--                             are minima, and by B1 neither is a choice.
--       `unrestricted-does-rank-1` / `graded-cannot-do-rank-1`
--                             the same fact in its sharpest form: a
--                             rank-1 factorization EXISTS unrestrictedly
--                             and PROVABLY DOES NOT EXIST gradedly.
--    F2 NEGATIVE CONTROL      the note's promotion table (1,3), (1,2),
--                             (1,1), (0,0) is checked in all four rows:
--                             `table-row-3/2/1/0`.  The last two rows
--                             are where the two classes AGREE — so the
--                             separation is a fact about r₃ and the
--                             classes, not an artefact of the framework,
--                             which does not report a difference where
--                             none is claimed.
--
-- G. A THIRD CLASS: grading AND differential (`Chaincls δ`), the content
--    carrier is a two-term complex (dimensions plus its own ∂), an
--    admissible map is a pair of maps satisfying the chain-map law
--    δ · (φ₁ x) ≡ φ₀ (∂ x).  THE EXTRA CHANNEL IS DERIVED, NOT IMPOSED:
--
--    G3 `chain-needs-boundary` if the payload is nonzero in degree one
--                             and the target differential is nonzero,
--                             then the chain law forces a degree-zero
--                             channel — the carrier cannot stop at the
--                             payload's own degree.
--    G4/G5 `chain-rank-bound`,
--       `chain-min-interval`  hence minimal carrier 2 = dim U + dim ∂U
--                             for the oriented-interval edge, attained
--                             by (D₁ = ⟨e⟩ , D₀ = ⟨∂e⟩).
--    G6 `chain-min-loop`      THE NOTE'S OWN FALSE CONTROL, checked: for
--                             a loop edge (∂ = 0) the chain carrier
--                             stays at rank 1.
--    G7 `carrier-depends-on-differential`
--                             the three-way comparison at ONE payload:
--                             unrestricted 1, graded 1, chain 2, chain
--                             with zero boundary 1.  The graded entry
--                             equalling the unrestricted one is what
--                             makes this a statement about the
--                             DIFFERENTIAL and not about grading.
--       `chain-carrier-determined`
--                             and in that class too the number is
--                             determined, not chosen.
--
--
-- WHAT IS DELIBERATELY NOT CLAIMED
--
--  * NO ARITHMETIC IS CLAIMED.  `r₃` is a vector of three integers
--    written down from the note; nothing here derives it from a Möbius
--    or Mellin computation, and nothing here checks that it IS the k = 3
--    residual.  The theorem proved is about carriers of that vector.
--  * The rows r₂, r₁, r₀ MODEL THE SUPPORT PATTERN of the note's
--    promotion table (supports 3, 2, 1, 0) by deleting one layer at a
--    time.  They are NOT claimed to be the actual residuals after
--    successive promotions; only the support sizes are used, and only
--    the support sizes are what the table's ranks depend on.
--  * "Carrier rank" here is A CHANNEL COUNT, not a ℤ-module rank proved
--    to be basis-independent.  For `Uncls`/`Gcls` a carrier is free with
--    a declared basis and `rank` counts basis elements; no Smith normal
--    form, no invariance-of-rank theorem, and no statement about
--    arbitrary submodules is used or proved.  In particular
--    `G-rank-bound` is a statement about the DECLARED dimension vector.
--  * MISMATCH WITH `CHAIN_PAYLOAD_CLOSURE.md`, stated rather than
--    papered over.  That note works over ℚ with an arbitrary subspace U
--    of degree-one payloads and concludes dim U + dim d(U).  §G proves
--    the instance where U is one channel and each target degree is one
--    dimensional, over ℤ, in the channel-counting model above: 1 + 1 = 2
--    for a nonzero boundary and 1 + 0 = 1 for a zero one.  The general
--    dim U + dim d(U) for arbitrary U is NOT proved here (it needs the
--    rank theory this module deliberately avoids), and the note's
--    "two independent edges with the same boundary give total 3, not 4"
--    is not formalised.
--  * The differential does NOT come from the arithmetic.  Neither note
--    supplies a differential on the Mellin/Möbius layers, so §G does not
--    apply to `r₃`, and no claim is made that it does: `Chaincls` is
--    over `Layer 2` with a STIPULATED δ.  Declaring a differential is
--    itself part of fixing the morphism class; §G therefore does not
--    dissolve the under-determination of §F, it exhibits a third class
--    in which the minimal carrier is again well-defined.
--  * `Gcls` models grading-preservation as "degree j of the output reads
--    only degree j of the input" (`G-degreewise`).  Transformations that
--    SHIFT degree by a fixed amount, or that mix arities/decay gradings
--    in the note's sense, are a different class again and are not
--    modelled.  Nothing here says which class the Mellin problem wants —
--    that is exactly the note's open question, and it stays open.
--  * No claim that these three classes are exhaustive, that `MinCarrier`
--    always exists (only that it is unique, and that it exists in the
--    three exhibited classes), or that minimal carrier rank is a
--    *deficit* in the sense of `GenerativeLoop`: nothing here decreases
--    along a chain, and nothing here is connected to termination.
--  * `CompileBridge.ArithmeticPayloadOver` takes a class from this
--    module as a parameter.  IT REMAINS UNINHABITED; this module does
--    not construct one and does not claim one exists.
------------------------------------------------------------------------

module PayloadMorphism where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; snotz ; znots ; injSuc ; m+n≡0→m≡0×n≡0)
open import Cubical.Data.Nat.Order
  using ( _<_ ; _≤_ ; zero-≤ ; suc-≤-suc ; ≤-refl ; ≤-+-≤ ; ≤0→≡0
        ; pred-≤-pred ; ¬m<m ; ¬-<-zero ; ≤<-trans ; Trichotomy ; lt ; eq ; gt ; _≟_ )
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; ·IdR ; injPos ; negsucNotpos)
  renaming (_+_ to _+ℤ_ ; _·_ to _·ℤ_)
open import Cubical.Data.FinData using (Fin) renaming (zero to fz ; suc to fs)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; if_then_else_ ; true≢false ; false≢true ; dichotomyBool)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- A.  Finite sums, and the two arithmetic facts about ℕ used below.
------------------------------------------------------------------------

sumℤ : {m : ℕ} → (Fin m → ℤ) → ℤ
sumℤ {zero}  f = pos 0
sumℤ {suc m} f = f fz +ℤ sumℤ (λ i → f (fs i))

sumℕ : {m : ℕ} → (Fin m → ℕ) → ℕ
sumℕ {zero}  f = 0
sumℕ {suc m} f = f fz + sumℕ (λ i → f (fs i))

-- the pairing that turns a carrier element and a transformation into a
-- target coordinate
dot : {m : ℕ} → (Fin m → ℤ) → (Fin m → ℤ) → ℤ
dot x φ = sumℤ (λ i → x i ·ℤ φ i)

sumℤ-dim0 : (m : ℕ) → m ≡ 0 → (f : Fin m → ℤ) → sumℤ f ≡ pos 0
sumℤ-dim0 zero    p f = refl
sumℤ-dim0 (suc m) p f = Empty.rec (snotz p)

sumℤ-dim1 : (m : ℕ) → m ≡ 1 → (f : Fin m → ℤ) (z : ℤ)
          → ((i : Fin m) → f i ≡ z) → sumℤ f ≡ z
sumℤ-dim1 zero          p f z h = Empty.rec (znots p)
sumℤ-dim1 (suc zero)    p f z h = h fz
sumℤ-dim1 (suc (suc m)) p f z h = Empty.rec (snotz (injSuc p))

sumℤ-const0 : (m : ℕ) (f : Fin m → ℤ) → ((i : Fin m) → f i ≡ pos 0)
            → sumℤ f ≡ pos 0
sumℤ-const0 zero    f h = refl
sumℤ-const0 (suc m) f h =
  cong₂ _+ℤ_ (h fz) (sumℤ-const0 m (λ i → f (fs i)) (λ i → h (fs i)))

sumℕ-mono : (n : ℕ) (a b : Fin n → ℕ) → ((j : Fin n) → a j ≤ b j)
          → sumℕ a ≤ sumℕ b
sumℕ-mono zero    a b h = ≤-refl
sumℕ-mono (suc n) a b h =
  ≤-+-≤ (h fz) (sumℕ-mono n (λ i → a (fs i)) (λ i → b (fs i)) (λ j → h (fs j)))

sum0→each0 : (n : ℕ) (d : Fin n → ℕ) → sumℕ d ≡ 0 → (j : Fin n) → d j ≡ 0
sum0→each0 zero    d p ()
sum0→each0 (suc n) d p fz     = fst (m+n≡0→m≡0×n≡0 p)
sum0→each0 (suc n) d p (fs j) =
  sum0→each0 n (λ i → d (fs i)) (snd (m+n≡0→m≡0×n≡0 p)) j

-- functions out of a dimension-zero index type are all equal
emptyFunEq : (m : ℕ) → m ≡ 0 → (f g : Fin m → ℤ) → f ≡ g
emptyFunEq zero    p f g = funExt (λ ())
emptyFunEq (suc m) p f g = Empty.rec (snotz p)

nz→1≤ : (k : ℕ) → ¬ (k ≡ 0) → 1 ≤ k
nz→1≤ zero    h = Empty.rec (h refl)
nz→1≤ (suc k) h = suc-≤-suc zero-≤

<1→≡0 : (m : ℕ) → m < 1 → m ≡ 0
<1→≡0 m p = ≤0→≡0 (pred-≤-pred p)

------------------------------------------------------------------------
-- B.  THE MORPHISM CLASS, as an explicit parameter.
--
-- A class of admissible transformations into a fixed target: which
-- carriers are allowed (`Obj`), how big each one is (`rank`), what its
-- elements are, which maps carrier → target are admissible (`Hom`), and
-- two LAWS without which "minimal carrier" is not a rank statement at
-- all: an admissible map kills the zero element, and a rank-zero carrier
-- has only that element.
------------------------------------------------------------------------

record MorphismClass (Tgt : Type₀) : Type₁ where
  field
    null   : Tgt                        -- the target's zero
    Obj    : Type₀                      -- admissible carriers
    rank   : Obj → ℕ                    -- their size
    El     : Obj → Type₀                -- elements of a carrier
    zeroEl : (c : Obj) → El c
    Hom    : Obj → Type₀                -- admissible transformations c → Tgt
    app    : {c : Obj} → Hom c → El c → Tgt
    -- LAWS
    app-null      : {c : Obj} (φ : Hom c) → app φ (zeroEl c) ≡ null
    rank0-trivial : (c : Obj) → rank c ≡ 0 → (x : El c) → x ≡ zeroEl c

module _ {Tgt : Type₀} (M : MorphismClass Tgt) where
  open MorphismClass M

  -- r factors through the carrier c
  Factors : Tgt → Obj → Type₀
  Factors r c = Σ[ φ ∈ Hom c ] Σ[ x ∈ El c ] (app φ x ≡ r)

  FactorsAt : Tgt → ℕ → Type₀
  FactorsAt r m = Σ[ c ∈ Obj ] ((rank c ≡ m) × Factors r c)

  -- the minimal carrier rank OF r IN THIS CLASS
  MinCarrier : Tgt → ℕ → Type₀
  MinCarrier r m = FactorsAt r m × ((m' : ℕ) → m' < m → ¬ FactorsAt r m')

  ----------------------------------------------------------------------
  -- B1.  WHAT FIXING THE CLASS BUYS (i): well-definedness.  Once the
  -- class is fixed, a payload has at most one minimal carrier rank.
  ----------------------------------------------------------------------

  min-unique : (r : Tgt) (m m' : ℕ) → MinCarrier r m → MinCarrier r m' → m ≡ m'
  min-unique r m m' (fm , nm) (fm' , nm') = decide (m ≟ m')
    where
    decide : Trichotomy m m' → m ≡ m'
    decide (lt p) = Empty.rec (nm' m p fm)
    decide (eq p) = p
    decide (gt p) = Empty.rec (nm m' p fm')

  ----------------------------------------------------------------------
  -- B2.  The one place the laws are used: nothing but the target's zero
  -- factors through a rank-zero carrier, in ANY class.
  ----------------------------------------------------------------------

  factorsAt0→null : (r : Tgt) → FactorsAt r 0 → r ≡ null
  factorsAt0→null r (c , rk , φ , x , p) =
    sym p ∙ cong (app φ) (rank0-trivial c rk x) ∙ app-null φ

  nonnull-not-rank0 : (r : Tgt) → ¬ (r ≡ null) → ¬ FactorsAt r 0
  nonnull-not-rank0 r nz f = nz (factorsAt0→null r f)

------------------------------------------------------------------------
-- C.  THE GRADED TARGET: a finite direct sum over residue depth.
--
-- `Layer n` is the space of formal sums  Σ_{j<n} c_j Z_j  with integer
-- coefficients: coordinate j IS the coefficient of the depth-j layer.
-- `supp` counts the nonzero layers.
------------------------------------------------------------------------

Layer : ℕ → Type₀
Layer n = Fin n → ℤ

zeroL : {n : ℕ} → Layer n
zeroL _ = pos 0

isZeroℤ : ℤ → Bool
isZeroℤ (pos zero)    = true
isZeroℤ (pos (suc _)) = false
isZeroℤ (negsuc _)    = false

isZero-true : (z : ℤ) → isZeroℤ z ≡ true → z ≡ pos 0
isZero-true (pos zero)    p = refl
isZero-true (pos (suc n)) p = Empty.rec (false≢true p)
isZero-true (negsuc n)    p = Empty.rec (false≢true p)

isZero-false : (z : ℤ) → isZeroℤ z ≡ false → ¬ (z ≡ pos 0)
isZero-false (pos zero)    p = Empty.rec (true≢false p)
isZero-false (pos (suc n)) p = λ q → snotz (injPos q)
isZero-false (negsuc n)    p = λ q → negsucNotpos n 0 q

-- the indicator of the support, degree by degree
chan : {n : ℕ} → Layer n → Fin n → ℕ
chan r j = if isZeroℤ (r j) then 0 else 1

supp : {n : ℕ} → Layer n → ℕ
supp r = sumℕ (chan r)

------------------------------------------------------------------------
-- D.  CLASS U: unrestricted (ungraded) transformations.
--
-- A carrier is a bare ℤ-module ℤ^m — no degrees — and an admissible
-- transformation is an arbitrary matrix ℤ^m → Layer n.  Nothing forbids
-- one channel from feeding every degree at once.
------------------------------------------------------------------------

Uncls : (n : ℕ) → MorphismClass (Layer n)
Uncls n = record
  { null   = zeroL
  ; Obj    = ℕ
  ; rank   = λ m → m
  ; El     = λ m → Fin m → ℤ
  ; zeroEl = λ m i → pos 0
  ; Hom    = λ m → Fin m → Layer n
  ; app    = λ φ x j → sumℤ (λ i → x i ·ℤ φ i j)
  ; app-null = λ {m} φ → funExt (λ j → sumℤ-const0 m _ (λ i → refl))
  ; rank0-trivial = λ m p x → emptyFunEq m p x _
  }

-- one channel suffices, for every payload: send it to r.
U-factors-1 : (n : ℕ) (r : Layer n) → FactorsAt (Uncls n) r 1
U-factors-1 n r = 1 , refl , (λ _ → r) , (λ _ → pos 1) , refl

U-min-one : (n : ℕ) (r : Layer n) → ¬ (r ≡ zeroL) → MinCarrier (Uncls n) r 1
U-min-one n r nz =
    U-factors-1 n r
  , λ m' p f → nonnull-not-rank0 (Uncls n) r nz
                 (subst (FactorsAt (Uncls n) r) (<1→≡0 m' p) f)

U-min-zero : (n : ℕ) → MinCarrier (Uncls n) (zeroL {n}) 0
U-min-zero n =
    (0 , refl , (λ ()) , (λ ()) , refl)
  , λ m' p _ → Empty.rec (¬-<-zero p)

------------------------------------------------------------------------
-- E.  CLASS G: grading-preserving transformations.
--
-- A graded carrier is exactly its dimension in each degree (a f.g. free
-- graded module is classified by that vector), so `Obj = Fin n → ℕ`; its
-- rank is the total dimension.  A graded transformation is a family of
-- maps, one per degree, and DEGREE j OF THE OUTPUT READS ONLY DEGREE j
-- OF THE INPUT — that is the checkable condition, and `G-degreewise`
-- below is its statement.
------------------------------------------------------------------------

Gcls : (n : ℕ) → MorphismClass (Layer n)
Gcls n = record
  { null   = zeroL
  ; Obj    = Fin n → ℕ
  ; rank   = sumℕ
  ; El     = λ d → (j : Fin n) → Fin (d j) → ℤ
  ; zeroEl = λ d j i → pos 0
  ; Hom    = λ d → (j : Fin n) → Fin (d j) → ℤ
  ; app    = λ φ x j → sumℤ (λ i → x j i ·ℤ φ j i)
  ; app-null = λ {d} φ → funExt (λ j → sumℤ-const0 (d j) _ (λ i → refl))
  ; rank0-trivial = λ d p x →
      funExt (λ j → emptyFunEq (d j) (sum0→each0 _ d p j) (x j) _)
  }

-- E0.  Grading preservation, as a checked statement about the class:
-- the output at degree j depends on the input at degree j only.
G-degreewise :
  (n : ℕ) (d : Fin n → ℕ)
  (φ : (j : Fin n) → Fin (d j) → ℤ)
  (x y : (j : Fin n) → Fin (d j) → ℤ) (j : Fin n)
  → x j ≡ y j
  → sumℤ (λ i → x j i ·ℤ φ j i) ≡ sumℤ (λ i → y j i ·ℤ φ j i)
G-degreewise n d φ x y j p = cong (λ w → sumℤ (λ i → w i ·ℤ φ j i)) p

-- E1.  A degree carrying a nonzero coefficient needs a channel there.
G-needs-channel :
  (n : ℕ) (r : Layer n) (d : Fin n → ℕ) → Factors (Gcls n) r d
  → (j : Fin n) → ¬ (r j ≡ pos 0) → 1 ≤ d j
G-needs-channel n r d (φ , x , p) j nzj = nz→1≤ (d j) contra
  where
  contra : ¬ (d j ≡ 0)
  contra e = nzj (sym (funExt⁻ p j) ∙ sumℤ-dim0 (d j) e _)

-- E2.  THE GRADED RANK BOUND: a graded carrier through which r factors
-- has at least one channel per nonzero layer.
G-rank-bound :
  (n : ℕ) (r : Layer n) (d : Fin n → ℕ) → Factors (Gcls n) r d
  → supp r ≤ sumℕ d
G-rank-bound n r d fac = sumℕ-mono n (chan r) d pointwise
  where
  pointwise : (j : Fin n) → chan r j ≤ d j
  pointwise j = branch (dichotomyBool (isZeroℤ (r j)))
    where
    branch : (isZeroℤ (r j) ≡ true) ⊎ (isZeroℤ (r j) ≡ false) → chan r j ≤ d j
    branch (inl e) =
      subst (λ k → k ≤ d j) (sym (cong (λ b → if b then 0 else 1) e)) zero-≤
    branch (inr e) =
      subst (λ k → k ≤ d j) (sym (cong (λ b → if b then 0 else 1) e))
            (G-needs-channel n r d fac j (isZero-false (r j) e))

-- E3.  ... and the bound is attained: one channel per nonzero layer.
G-factors-supp : (n : ℕ) (r : Layer n) → FactorsAt (Gcls n) r (supp r)
G-factors-supp n r =
  chan r , refl , (λ j i → r j) , (λ j i → pos 1) , funExt coord
  where
  coord : (j : Fin n) → sumℤ {chan r j} (λ i → pos 1 ·ℤ r j) ≡ r j
  coord j = branch (dichotomyBool (isZeroℤ (r j)))
    where
    dim≡ : {b : Bool} → isZeroℤ (r j) ≡ b → chan r j ≡ (if b then 0 else 1)
    dim≡ e = cong (λ c → if c then 0 else 1) e
    branch : (isZeroℤ (r j) ≡ true) ⊎ (isZeroℤ (r j) ≡ false)
           → sumℤ {chan r j} (λ i → pos 1 ·ℤ r j) ≡ r j
    branch (inl e) =
      sumℤ-dim0 (chan r j) (dim≡ e) _ ∙ sym (isZero-true (r j) e)
    branch (inr e) =
      sumℤ-dim1 (chan r j) (dim≡ e) _ (r j) (λ i → refl)

-- E4.  Hence the minimal graded carrier is the support size.
G-min : (n : ℕ) (r : Layer n) → MinCarrier (Gcls n) r (supp r)
G-min n r =
    G-factors-supp n r
  , λ m' p f → ¬m<m (≤<-trans (bound m' f) p)
  where
  bound : (m' : ℕ) → FactorsAt (Gcls n) r m' → supp r ≤ m'
  bound m' (d , rk , fac) = subst (supp r ≤_) rk (G-rank-bound n r d fac)

------------------------------------------------------------------------
-- E5.  WHAT FIXING THE CLASS BUYS (ii): in each of the two classes the
-- minimal carrier is not merely unique but COMPUTED.  These are the
-- statements that `MinCarrier` is a function of (class, payload).
------------------------------------------------------------------------

G-carrier-determined :
  (n : ℕ) (r : Layer n) (m : ℕ) → MinCarrier (Gcls n) r m → m ≡ supp r
G-carrier-determined n r m mc = min-unique (Gcls n) r m (supp r) mc (G-min n r)

U-carrier-determined :
  (n : ℕ) (r : Layer n) → ¬ (r ≡ zeroL)
  → (m : ℕ) → MinCarrier (Uncls n) r m → m ≡ 1
U-carrier-determined n r nz m mc =
  min-unique (Uncls n) r m 1 mc (U-min-one n r nz)

------------------------------------------------------------------------
-- F.  THE SEPARATION, at the k = 3 Möbius residual of
--
--     r₃ = -6 Z₂ + 12 Z₁ - 8 Z₀ .
--
-- Coordinate j is the coefficient of the depth-j layer.
------------------------------------------------------------------------

r₃ : Layer 3
r₃ fz             = negsuc 7    -- -8 Z₀
r₃ (fs fz)        = pos 12      -- 12 Z₁
r₃ (fs (fs fz))   = negsuc 5    -- -6 Z₂

-- the successive residuals of the note's promotion table, modelled by
-- deleting one layer at a time (SUPPORT PATTERN ONLY — see the header)
r₂ : Layer 3
r₂ fz             = pos 0
r₂ (fs fz)        = pos 12
r₂ (fs (fs fz))   = negsuc 5

r₁ : Layer 3
r₁ fz             = pos 0
r₁ (fs fz)        = pos 0
r₁ (fs (fs fz))   = negsuc 5

r₀ : Layer 3
r₀ = zeroL

supp-r₃ : supp r₃ ≡ 3
supp-r₃ = refl

supp-r₂ : supp r₂ ≡ 2
supp-r₂ = refl

supp-r₁ : supp r₁ ≡ 1
supp-r₁ = refl

supp-r₀ : supp r₀ ≡ 0
supp-r₀ = refl

r₃≢0 : ¬ (r₃ ≡ zeroL)
r₃≢0 q = negsucNotpos 7 0 (funExt⁻ q fz)

r₂≢0 : ¬ (r₂ ≡ zeroL)
r₂≢0 q = snotz (injPos (funExt⁻ q (fs fz)))

r₁≢0 : ¬ (r₁ ≡ zeroL)
r₁≢0 q = negsucNotpos 5 0 (funExt⁻ q (fs (fs fz)))

1≢3 : ¬ (1 ≡ 3)
1≢3 p = znots (injSuc p)

------------------------------------------------------------------------
-- F1.  THE STATEMENT THE NOTE ASKED FOR: one payload, two classes, two
-- different minimal carriers.  Neither number is a choice: each is the
-- unique minimum in its class (`min-unique`), and both are exhibited.
------------------------------------------------------------------------

minimal-carrier-depends-on-class :
  Σ[ a ∈ ℕ ] Σ[ b ∈ ℕ ]
    ( MinCarrier (Uncls 3) r₃ a
    × MinCarrier (Gcls 3)  r₃ b
    × (¬ (a ≡ b)) )
minimal-carrier-depends-on-class =
  1 , 3 , U-min-one 3 r₃ r₃≢0 , G-min 3 r₃ , 1≢3

-- the two halves of F1 in their sharpest form: ONE channel does it when
-- the transformations are unrestricted ...
unrestricted-does-rank-1 : FactorsAt (Uncls 3) r₃ 1
unrestricted-does-rank-1 = U-factors-1 3 r₃

-- ... and one channel provably does NOT when they must preserve the
-- grading.  Same payload, same target, different morphism class.
graded-cannot-do-rank-1 : ¬ FactorsAt (Gcls 3) r₃ 1
graded-cannot-do-rank-1 = snd (G-min 3 r₃) 1 (1 , refl)

------------------------------------------------------------------------
-- F2.  NEGATIVE CONTROL.  The same two classes on the same machinery
-- must AGREE where the note says they agree — otherwise F1 would be an
-- artefact of the definitions rather than a fact about r₃.  The note's
-- promotion table is (1,3), (1,2), (1,1), (0,0); the last two rows are
-- the control, and they check.
------------------------------------------------------------------------

table-row-3 : MinCarrier (Uncls 3) r₃ 1 × MinCarrier (Gcls 3) r₃ 3
table-row-3 = U-min-one 3 r₃ r₃≢0 , G-min 3 r₃

table-row-2 : MinCarrier (Uncls 3) r₂ 1 × MinCarrier (Gcls 3) r₂ 2
table-row-2 = U-min-one 3 r₂ r₂≢0 , G-min 3 r₂

-- CONTROL: classes agree at support one ...
table-row-1 : MinCarrier (Uncls 3) r₁ 1 × MinCarrier (Gcls 3) r₁ 1
table-row-1 = U-min-one 3 r₁ r₁≢0 , G-min 3 r₁

-- ... and at the zero payload.
table-row-0 : MinCarrier (Uncls 3) r₀ 0 × MinCarrier (Gcls 3) r₀ 0
table-row-0 = U-min-zero 3 , G-min 3 r₀

------------------------------------------------------------------------
-- G.  A THIRD CLASS: grading AND differential (chain maps).
--
-- two-term complex the carrier is not free to stop at the payload's own
-- degree: a subcomplex containing U in degree one must contain d(U) in
-- degree zero, so the carrier dimension is dim U + dim d(U).  That is
-- proved here INSIDE the same `MorphismClass` interface, and the extra
-- channel is DERIVED FROM THE CHAIN-MAP LAW, not imposed on carriers.
--
-- Target: `Layer 2`, coordinate `deg0` = degree zero, `deg1` = degree
-- one, with target differential multiplication by δ : ℤ.
-- Carrier: dimensions (dim1 , dim0) together with its own differential
-- ∂ given as a matrix.  A transformation is a pair of maps satisfying
--
--     δ · (φ₁ x)  ≡  φ₀ (∂ x)      for every x.
------------------------------------------------------------------------

deg0 deg1 : Fin 2
deg0 = fz
deg1 = fs fz

mk2 : ℤ → ℤ → Layer 2
mk2 a b fz      = a
mk2 a b (fs fz) = b

record ChainCarrier : Type₀ where
  constructor chainCarrier
  field
    dim1 dim0 : ℕ
    ∂ : Fin dim1 → Fin dim0 → ℤ

open ChainCarrier

∂app : (C : ChainCarrier) → (Fin (dim1 C) → ℤ) → Fin (dim0 C) → ℤ
∂app C x i = sumℤ (λ k → x k ·ℤ ∂ C k i)

record ChainHom (δ : ℤ) (C : ChainCarrier) : Type₀ where
  constructor chainHom
  field
    φ1 : Fin (dim1 C) → ℤ
    φ0 : Fin (dim0 C) → ℤ
    chain-law : (x : Fin (dim1 C) → ℤ) → δ ·ℤ dot x φ1 ≡ dot (∂app C x) φ0

open ChainHom

ChainEl : ChainCarrier → Type₀
ChainEl C = (Fin (dim1 C) → ℤ) × (Fin (dim0 C) → ℤ)

chainApp : {δ : ℤ} {C : ChainCarrier} → ChainHom δ C → ChainEl C → Layer 2
chainApp ψ (x1 , x0) = mk2 (dot x0 (φ0 ψ)) (dot x1 (φ1 ψ))

Chaincls : (δ : ℤ) → MorphismClass (Layer 2)
Chaincls δ = record
  { null   = zeroL
  ; Obj    = ChainCarrier
  ; rank   = λ C → dim1 C + dim0 C
  ; El     = ChainEl
  ; zeroEl = λ C → (λ _ → pos 0) , (λ _ → pos 0)
  ; Hom    = ChainHom δ
  ; app    = chainApp
  ; app-null = λ {C} ψ → funExt (nullCoord C ψ)
  ; rank0-trivial = λ C p x → trivial C p x
  }
  where
  nullCoord : (C : ChainCarrier) (ψ : ChainHom δ C) (j : Fin 2)
            → chainApp ψ ((λ _ → pos 0) , (λ _ → pos 0)) j ≡ pos 0
  nullCoord C ψ fz      = sumℤ-const0 (dim0 C) _ (λ i → refl)
  nullCoord C ψ (fs fz) = sumℤ-const0 (dim1 C) _ (λ i → refl)
  trivial : (C : ChainCarrier) → dim1 C + dim0 C ≡ 0 → (x : ChainEl C)
          → x ≡ ((λ _ → pos 0) , (λ _ → pos 0))
  trivial C p (x1 , x0) =
    ΣPathP ( emptyFunEq (dim1 C) (fst (m+n≡0→m≡0×n≡0 p)) x1 _
           , emptyFunEq (dim0 C) (snd (m+n≡0→m≡0×n≡0 p)) x0 _ )

------------------------------------------------------------------------
-- G1.  A payload concentrated in degree one: the oriented-interval edge
-- of the note.  `edge` is Z₁ with zero degree-zero part.
------------------------------------------------------------------------

edge : Layer 2
edge = mk2 (pos 0) (pos 1)

edge≢0 : ¬ (edge ≡ zeroL)
edge≢0 q = snotz (injPos (funExt⁻ q deg1))

supp-edge : supp edge ≡ 1
supp-edge = refl

------------------------------------------------------------------------
-- G2.  DEGREE ONE NEEDS A CHANNEL (the graded half), and
-- G3.  DEGREE ZERO NEEDS ONE TOO WHEN THE BOUNDARY IS NONZERO — derived
--      from `chain-law`, exactly the note's argument.
------------------------------------------------------------------------

chain-needs-top :
  (δ : ℤ) (r : Layer 2) (C : ChainCarrier) → Factors (Chaincls δ) r C
  → ¬ (r deg1 ≡ pos 0) → 1 ≤ dim1 C
chain-needs-top δ r C (ψ , (x1 , x0) , p) nz = nz→1≤ (dim1 C) contra
  where
  contra : ¬ (dim1 C ≡ 0)
  contra e = nz (sym (funExt⁻ p deg1) ∙ sumℤ-dim0 (dim1 C) e _)

chain-needs-boundary :
  (r : Layer 2) (C : ChainCarrier) → Factors (Chaincls (pos 1)) r C
  → ¬ (r deg1 ≡ pos 0) → 1 ≤ dim0 C
chain-needs-boundary r C (ψ , (x1 , x0) , p) nz = nz→1≤ (dim0 C) contra
  where
  contra : ¬ (dim0 C ≡ 0)
  contra e = nz ( sym (funExt⁻ p deg1)
                ∙ chain-law ψ x1
                ∙ sumℤ-dim0 (dim0 C) e _ )

-- G4.  Hence rank ≥ 2 for the interval differential.
chain-rank-bound :
  (r : Layer 2) (C : ChainCarrier) → Factors (Chaincls (pos 1)) r C
  → ¬ (r deg1 ≡ pos 0) → 2 ≤ dim1 C + dim0 C
chain-rank-bound r C fac nz =
  ≤-+-≤ (chain-needs-top (pos 1) r C fac nz) (chain-needs-boundary r C fac nz)

------------------------------------------------------------------------
-- G5.  The bound is attained: the smallest subcomplex of the interval
-- containing the edge is (D₁ = ⟨e⟩ , D₀ = ⟨∂e⟩), total rank 1 + 1 = 2.
------------------------------------------------------------------------

intervalCarrier : ChainCarrier
intervalCarrier = chainCarrier 1 1 (λ _ _ → pos 1)

intervalHom : ChainHom (pos 1) intervalCarrier
intervalHom = chainHom (λ _ → pos 1) (λ _ → pos 1) law
  where
  law : (x : Fin 1 → ℤ)
      → pos 1 ·ℤ dot x (λ _ → pos 1) ≡ dot (∂app intervalCarrier x) (λ _ → pos 1)
  law x = cong (λ w → w ·ℤ pos 1) (sym (·IdR (x fz)))

chain-min-interval : MinCarrier (Chaincls (pos 1)) edge 2
chain-min-interval =
    ( intervalCarrier , refl , intervalHom
    , ((λ _ → pos 1) , (λ _ → pos 0)) , funExt coord )
  , λ m' p f → ¬m<m (≤<-trans (bound m' f) p)
  where
  coord : (j : Fin 2) → chainApp intervalHom ((λ _ → pos 1) , (λ _ → pos 0)) j ≡ edge j
  coord fz      = refl
  coord (fs fz) = refl
  bound : (m' : ℕ) → FactorsAt (Chaincls (pos 1)) edge m' → 2 ≤ m'
  bound m' (C , rk , fac) =
    subst (2 ≤_) rk (chain-rank-bound edge C fac (λ q → snotz (injPos q)))

------------------------------------------------------------------------
-- G6.  THE NOTE'S OWN FALSE CONTROL, checked: for a loop edge the
-- boundary vanishes (δ = 0) and the chain carrier stays at rank one.
-- Grading alone does not add a channel; the nonzero boundary does.
------------------------------------------------------------------------

loopCarrier : ChainCarrier
loopCarrier = chainCarrier 1 0 (λ _ ())

loopHom : ChainHom (pos 0) loopCarrier
loopHom = chainHom (λ _ → pos 1) (λ ()) (λ x → refl)

chain-min-loop : MinCarrier (Chaincls (pos 0)) edge 1
chain-min-loop =
    ( loopCarrier , refl , loopHom , ((λ _ → pos 1) , (λ ())) , funExt coord )
  , λ m' p f → nonnull-not-rank0 (Chaincls (pos 0)) edge edge≢0
                 (subst (FactorsAt (Chaincls (pos 0)) edge) (<1→≡0 m' p) f)
  where
  coord : (j : Fin 2) → chainApp loopHom ((λ _ → pos 1) , (λ ())) j ≡ edge j
  coord fz      = refl
  coord (fs fz) = refl

------------------------------------------------------------------------
-- G7.  THE THREE-WAY COMPARISON, one payload, three classes.
--
--   unrestricted        1
--   graded              1     (= supp edge; the grading adds nothing)
--   graded + ∂ ≠ 0      2     (= dim U + dim ∂U, forced by the chain law)
--
-- The middle entry is what makes this a fact about the DIFFERENTIAL
-- rather than about grading: the graded class agrees with the
-- unrestricted one here, and only the chain class differs.
------------------------------------------------------------------------

carrier-depends-on-differential :
  ( MinCarrier (Uncls 2) edge 1
  × MinCarrier (Gcls 2)  edge 1
  × MinCarrier (Chaincls (pos 1)) edge 2
  × MinCarrier (Chaincls (pos 0)) edge 1 )
carrier-depends-on-differential =
    U-min-one 2 edge edge≢0
  , G-min 2 edge
  , chain-min-interval
  , chain-min-loop

-- ... and in the chain class too the number is determined, not chosen.
chain-carrier-determined :
  (m : ℕ) → MinCarrier (Chaincls (pos 1)) edge m → m ≡ 2
chain-carrier-determined m mc =
  min-unique (Chaincls (pos 1)) edge m 2 mc chain-min-interval
