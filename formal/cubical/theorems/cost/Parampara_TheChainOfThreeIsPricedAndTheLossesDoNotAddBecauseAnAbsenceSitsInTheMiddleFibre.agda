{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- परम्परा — एवं परम्पराप्राप्तमिमं राजर्षयो विदुः ।
--            स कालेनेह महता योगो नष्टः परन्तप ॥
--
-- ────────────────────────────────────────────────────────────────────
-- THE TERM, ITS TEXT AND ITS DATE.
--
-- **परम्परा** · paramparā — transmission through a SUCCESSION OF LINKS,
-- each receiving from the one before and handing on to the one after.
-- *Bhagavadgītā* **4.2** (in the *Bhīṣmaparvan* of the *Mahābhārata*;
-- the verse as it stands is conventionally placed c. 200 BCE – 200 CE,
-- and the date is contested, which is why it is stated as a range).
-- The verse is quoted above in full because BOTH of its halves are the
-- subject of this module and the second half is usually dropped when the
-- word is quoted: 4.2a says the thing was received *paramparā-prāptam*,
-- by succession, and 4.2b says *sa kāleneha mahatā yogo naṣṭaḥ* — by the
-- long lapse of time that yoga was LOST here.  A chain of links, and a
-- loss along the chain, in one verse.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  Nothing mathematical.  The
-- *Gītā* states no map, no fibre, no composition law, and no theorem
-- below is attributed to it.  Borrowed is the word in its exact sense —
-- a chain of successive transmissions, and the loss that accrues along
-- one — because that is what a composite of three maps and its fibres
-- are.  The mathematics is cubical type theory (Voevodsky's univalence
-- and the fibre of a map), this repository's one admitted non-Indian
-- substrate; the counting in §६ uses `Fin-inj` from `agda/cubical`.
--
-- A SECOND TERM, AND ITS SCHOOL, NAMED BEFORE IT IS USED.  §१ and §७
-- turn on an **अभाव** (abhāva) — an absence.  That is
-- **Nyāya–Vaiśeṣika**, not a neutral technical word: Kaṇāda,
-- *Vaiśeṣikasūtra* 9.1 (~2nd c. BCE – 2nd c. CE), systematised in
-- Praśastapāda's *Padārthadharmasaṃgraha* (~6th c.) and stated compactly
-- at Annaṃbhaṭṭa, *Tarkasaṅgraha* §§57, 80 (~1600).  The one feature of
-- on: an absence is a RELATION with named slots, never a bare negative
-- verdict — it is the absence OF something (its **pratiyogin**,
-- counterpositive) IN something (its **anuyogin**, locus).  §७ names both
-- slots, and that is the whole difference between this module's result
-- and a report that a number came out smaller than expected.
--
-- The Jaina logicians would not accept that treatment of negation, and
-- this module does not pretend otherwise; syād-nāsti grounds a negation
-- fourfold and would not read the missing point as one relational entity
-- with two slots.  Nothing here is a joint Nyāya–Jaina construction.  One
-- school's instrument is used, and it is named.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS MODULE EXISTS.
--
-- The corpus can price ONE cut.  `YugmaPurana_…` prices a replay that
-- recovers its length exactly mod 2.  `Lopa_…` prices addition: `fiber
-- योग n ≃ SumFin (suc n)`, defect exactly n+1, and no left inverse.  In
-- both, a lossy map is paid for by NAMING ITS FIBRE, never by bounding
-- it.
--
-- It has never priced a CHAIN, and the composition law
-- `Sesa_…शेष` — fibre (g ∘ f) z ≃ Σ[ p ∈ fibre g z ] fibre f (fst p) —
-- has never been instantiated at a chain whose every fibre is written
-- out by hand.  Until it is, nothing downstream is entitled to add
-- losses along a route, and there is a standing reason to think adding
-- is WRONG: `Unit → Bool → Unit` loses a bit in the middle and the
-- composite is the identity (§८ below, where it is derived from the same
-- mechanism as the main result rather than left as an anomaly).
--
-- ────────────────────────────────────────────────────────────────────
-- THE CHAIN, AND WHAT IS PROVED OF IT.
--
--     Bool ⊎ Unit  --प्रवेश-->  Bool × Bool  --प्रथमांश-->  Bool  --विस्मरण-->  Unit
--            (3)                    (4)                (2)             (1)
--
--   प्रवेश (inl b) = (b , false)      प्रथमांश = fst        विस्मरण _ = tt
--   प्रवेश (inr tt) = (true , true)
--
--  §१  the four fibres of प्रवेश, each named AS A TYPE, not as a count:
--         fibre प्रवेश (b , false) ≃ Unit   for both b
--         fibre प्रवेश (true , true) ≃ Unit
--         fibre प्रवेश (false , true) ≃ ⊥   ←— THE ABSENCE
--  §२  fibre प्रथमांश c ≃ Bool, UNIFORMLY in c.  One bit, everywhere.
--  §३  fibre विस्मरण tt ≃ Bool.  One bit.
--  §४  the middle composite मध्यम = प्रथमांश ∘ प्रवेश:
--         fibre मध्यम false ≃ Unit      (contractible — proved)
--         fibre मध्यम true  ≃ Bool      (NOT contractible — proved)
--      so the composite's fibre is NOT uniform, and §२'s uniformity has
--      been destroyed by composing with a map that loses nothing.
--  §५  शेष INSTANTIATED at (प्रथमांश , प्रवेश), the RHS computed by hand
--      independently of it, and the two shown to AGREE — pointwise, and
--      at `true` the agreement is `refl`, which is the sharpest form the
--      statement can take.  THE LAW SURVIVES THE CHAIN.
--  §६  the whole chain.  fibre पूर्ण tt ≃ Bool ⊎ Unit — THREE.  The
--      additive ledger predicts Unit × Bool × Bool ≃ Bool × Bool — FOUR.
--      And ¬ ((Bool ⊎ Unit) ≃ (Bool × Bool)), proved by `Fin-inj`.
--      **THE LEDGER IS NOT ADDITIVE.**
--  §७  and the defect is not a number.  There is no uniform Φ for प्रवेश
--      (proved), so §२ of `Sesa_…` — the one clause under which logs add
--      — has a FALSE HYPOTHESIS here, and the witness of its falsity is
--      the absence of §१: pratiyogin `(false , true)`, anuyogin
--      `image प्रवेश`.  The missing 1 = 4 − 3 is that absence, and it is
--      exhibited as a type.
--  §८  `Unit → Bool → Unit` — the cancelling chain — DERIVED from the
--      same mechanism.  Same shape, same absence, opposite-looking
--      arithmetic.  So "losses cancel" and "losses fail to add" are one
--      phenomenon, and §५ prices both.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.
--
-- No general theorem about chains is proved here; this is ONE chain,
-- every map explicit, every fibre written out.  Nothing here says the
-- ledger fails for every chain — §५'s agreement is exactly the statement
-- that `शेष` covers this case correctly, so the composition law is NOT
-- refuted and no repair to it is needed.  What is refuted is the weaker
-- and more tempting thing: that the per-step fibres determine the
-- composite's fibre.  They do not; the alignment term does, and §७ names
-- it.  Nothing here is about rank, dimension, entropy, area or
-- shadow of §५ and is not used.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.  Exit code reported in the session log.
------------------------------------------------------------------------

module Parampara_TheChainOfThreeIsPricedAndTheLossesDoNotAddBecauseAnAbsenceSitsInTheMiddleFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; fiber ; invEquiv ; compEquiv ; equivFun ; invEq)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; isSetBool ; true≢false ; false≢true)
open import Cubical.Data.Sigma
  using (_×_ ; _,_ ; fst ; snd ; Σ-syntax ; ΣPathP ; Σ≡Prop)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit ; isContr→≃Unit)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Data.Nat using (injSuc ; znots)
open import Cubical.Relation.Nullary using (¬_)

open import Cubical.Data.SumFin using () renaming (Fin to SFin)
open import Cubical.Data.SumFin.Properties using (SumFin≡Fin)
open import Cubical.Data.Fin using () renaming (Fin to FFin)
open import Cubical.Data.Fin.Properties using (Fin-inj)

open import Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd
  using (शेष)

private
  -- the empty type at every fibre position we need it, and the only
  -- equivalence into it that a hypothesis can produce.
  ⊥≃ : {A : Type₀} → ¬ A → A ≃ ⊥
  ⊥≃ na = isoToEquiv (iso (λ a → ⊥-rec (na a)) ⊥-rec (λ ()) (λ a → ⊥-rec (na a)))

  isSetBool² : isSet (Bool × Bool)
  isSetBool² (a , b) (a' , b') p q i j =
    ( isSetBool a a' (cong fst p) (cong fst q) i j
    , isSetBool b b' (cong snd p) (cong snd q) i j )

------------------------------------------------------------------------
-- ० · the chain.  Three maps, written out, nothing implicit.
------------------------------------------------------------------------

प्रवेश : Bool ⊎ Unit → Bool × Bool
प्रवेश (inl b)  = (b , false)
प्रवेश (inr tt) = (true , true)

प्रथमांश : Bool × Bool → Bool
प्रथमांश = fst

विस्मरण : Bool → Unit
विस्मरण _ = tt

-- the two composites, written in exactly the shape `शेष` composes in
-- (`λ x → g (f x)`), so the instantiation in §५ needs no coercion.
मध्यम : Bool ⊎ Unit → Bool
मध्यम x = प्रथमांश (प्रवेश x)

पूर्ण : Bool ⊎ Unit → Unit
पूर्ण x = विस्मरण (मध्यम x)

-- a separator for the sum, used wherever `inl _ ≡ inr _` must be refuted.
भेदः : Bool ⊎ Unit → Bool
भेदः (inl _) = false
भेदः (inr _) = true

------------------------------------------------------------------------
-- १ · the four fibres of प्रवेश.
--
-- प्रवेश is injective — three points into four — so every fibre is a
-- proposition, and each is EITHER Unit OR ⊥.  Which one, at which point,
-- is the entire content of §६ and §७, so all four are written out and
-- none is left to a general lemma.
--
-- The second component of a `fiber प्रवेश y` is a path in `Bool × Bool`,
-- which is a set, so `Σ≡Prop` reduces every uniqueness obligation below
-- to a statement about the FIRST components only.
------------------------------------------------------------------------

-- (b , false) is hit, by inl b, and by nothing else.
प्रवेश-असत्ये : (b : Bool) → isContr (fiber प्रवेश (b , false))
fst (प्रवेश-असत्ये b) = (inl b , refl)
snd (प्रवेश-असत्ये b) (inl b' , r) =
  Σ≡Prop (λ x → isSetBool² (प्रवेश x) (b , false))
         (cong inl (sym (cong fst r)))
snd (प्रवेश-असत्ये b) (inr tt , r) = ⊥-rec (true≢false (cong snd r))

-- (true , true) is hit, by inr tt, and by nothing else.
प्रवेश-सत्ये-सत्यम् : isContr (fiber प्रवेश (true , true))
fst प्रवेश-सत्ये-सत्यम् = (inr tt , refl)
snd प्रवेश-सत्ये-सत्यम् (inl b' , r) = ⊥-rec (false≢true (cong snd r))
snd प्रवेश-सत्ये-सत्यम् (inr tt , r) =
  Σ≡Prop (λ x → isSetBool² (प्रवेश x) (true , true)) refl

-- AND (false , true) IS NOT HIT AT ALL.  This is the module's hinge.
अभावः : ¬ fiber प्रवेश (false , true)
अभावः (inl b , r)  = false≢true (cong snd r)
अभावः (inr tt , r) = true≢false (cong fst r)

-- the four, as types.
प्रवेश-तन्तुः-असत्ये : (b : Bool) → fiber प्रवेश (b , false) ≃ Unit
प्रवेश-तन्तुः-असत्ये b = isContr→≃Unit (प्रवेश-असत्ये b)

प्रवेश-तन्तुः-सत्ये-सत्यम् : fiber प्रवेश (true , true) ≃ Unit
प्रवेश-तन्तुः-सत्ये-सत्यम् = isContr→≃Unit प्रवेश-सत्ये-सत्यम्

प्रवेश-तन्तुः-रिक्तः : fiber प्रवेश (false , true) ≃ ⊥
प्रवेश-तन्तुः-रिक्तः = ⊥≃ अभावः

------------------------------------------------------------------------
-- २ · the fibre of प्रथमांश, and it is UNIFORM.
--
-- fiber fst c = Σ[ y ∈ Bool × Bool ] (fst y ≡ c), and the second
-- coordinate of y is free.  One bit lost, at every c alike.  This is the
-- hypothesis of `Sesa_…शेषसमता` holding, for this map; §७ shows it
-- FAILING for प्रवेश, which is why the chain does not simply multiply.
------------------------------------------------------------------------

प्रथमांश-तन्तुः : (c : Bool) → fiber प्रथमांश c ≃ Bool
प्रथमांश-तन्तुः c = isoToEquiv (iso to from (λ _ → refl) li)
  where
  to : fiber प्रथमांश c → Bool
  to ((a , b) , q) = b

  from : Bool → fiber प्रथमांश c
  from b = ((c , b) , refl)

  li : (p : fiber प्रथमांश c) → from (to p) ≡ p
  li ((a , b) , q) =
    Σ≡Prop (λ y → isSetBool (प्रथमांश y) c) (ΣPathP (sym q , refl))

------------------------------------------------------------------------
-- ३ · the fibre of विस्मरण.  One bit, and the only point of the base.
------------------------------------------------------------------------

विस्मरण-तन्तुः : fiber विस्मरण tt ≃ Bool
विस्मरण-तन्तुः = isoToEquiv (iso fst (λ b → (b , refl)) (λ _ → refl)
  (λ p → Σ≡Prop (λ _ → isSetUnit tt tt) refl))

------------------------------------------------------------------------
-- ४ · the middle composite, and the loss it actually carries.
--
--   मध्यम (inl b)  = b        मध्यम (inr tt) = true
--
-- so `true` is hit twice and `false` once.  THE COMPOSITE'S FIBRE IS NOT
-- UNIFORM, although प्रवेश's failure of uniformity is a failure between
-- Unit and ⊥ and प्रथमांश's fibre is uniform.  Both halves proved: the
-- fibre over `false` is contractible, the fibre over `true` is not.
------------------------------------------------------------------------

मध्यम-असत्ये : isContr (fiber मध्यम false)
fst मध्यम-असत्ये = (inl false , refl)
snd मध्यम-असत्ये (inl b , p) =
  Σ≡Prop (λ x → isSetBool (मध्यम x) false) (cong inl (sym p))
snd मध्यम-असत्ये (inr tt , p) = ⊥-rec (true≢false p)

मध्यम-तन्तुः-असत्ये : fiber मध्यम false ≃ Unit
मध्यम-तन्तुः-असत्ये = isContr→≃Unit मध्यम-असत्ये

मध्यम-तन्तुः-सत्ये : fiber मध्यम true ≃ Bool
मध्यम-तन्तुः-सत्ये = isoToEquiv (iso to from ri li)
  where
  to : fiber मध्यम true → Bool
  to (inl _  , _) = false
  to (inr tt , _) = true

  from : Bool → fiber मध्यम true
  from false = (inl true , refl)
  from true  = (inr tt , refl)

  ri : (b : Bool) → to (from b) ≡ b
  ri false = refl
  ri true  = refl

  li : (w : fiber मध्यम true) → from (to w) ≡ w
  li (inl b , p) =
    Σ≡Prop (λ x → isSetBool (मध्यम x) true) (cong inl (sym p))
  li (inr tt , p) =
    Σ≡Prop (λ x → isSetBool (मध्यम x) true) refl

-- and the two are genuinely different: `true` has two distinct histories.
मध्यम-सत्ये-बहु : ¬ isContr (fiber मध्यम true)
मध्यम-सत्ये-बहु c =
  false≢true (cong (λ w → भेदः (fst w))
                   (isContr→isProp c (inl true , refl) (inr tt , refl)))

------------------------------------------------------------------------
-- ५ · शेष, INSTANTIATED, AND CHECKED AGAINST THE HAND COMPUTATION.
--
-- The general law, at this junction, with nothing supplied but the two
-- maps:
------------------------------------------------------------------------

शेष-मध्ये : (z : Bool)
          → fiber मध्यम z ≃ (Σ[ p ∈ fiber प्रथमांश z ] fiber प्रवेश (fst p))
शेष-मध्ये = शेष प्रथमांश प्रवेश

-- ── and now the right-hand side computed BY HAND, without शेष. ────────
--
-- Over `false` the base `fiber प्रथमांश false` has two points —
-- ((false , false) , refl) and ((false , true) , refl) — and §१ says the
-- प्रवेश-fibre over the first is Unit and over the SECOND IS ⊥.  So the
-- Σ has one inhabitant, not two: the second branch of the base
-- contributes nothing.  That is the alignment term, and it is here
-- PROVABLY NON-ZERO.
--
-- The uniqueness argument needs the only non-formal step in the module:
-- a point of `Bool × Bool` that is in the image of प्रवेश and has first
-- coordinate `false` IS `(false , false)`.  It is stated separately
-- because it is exactly the statement that the absence is where it is.

प्रतिबिम्बः : (y : Bool × Bool) → fiber प्रवेश y → प्रथमांश y ≡ false
            → y ≡ (false , false)
प्रतिबिम्बः y (inl b , r) q =
  sym r ∙ ΣPathP (cong fst r ∙ q , refl)
प्रतिबिम्बः y (inr tt , r) q = ⊥-rec (true≢false (cong fst r ∙ q))

हस्त-शेष-असत्ये : (Σ[ p ∈ fiber प्रथमांश false ] fiber प्रवेश (fst p)) ≃ Unit
हस्त-शेष-असत्ये = isContr→≃Unit (केन्द्रम् , एकत्वम्)
  where
  केन्द्रम् : Σ[ p ∈ fiber प्रथमांश false ] fiber प्रवेश (fst p)
  केन्द्रम् = (((false , false) , refl) , (inl false , refl))

  आधार-प्रोप् : (p : fiber प्रथमांश false) → isProp (fiber प्रवेश (fst p))
  आधार-प्रोप् ((a , b) , q) e e' =
    isContr→isProp
      (subst (λ y → isContr (fiber प्रवेश y))
             (sym (प्रतिबिम्बः (a , b) e q))
             (प्रवेश-असत्ये false))
      e e'

  एकत्वम् : (w : Σ[ p ∈ fiber प्रथमांश false ] fiber प्रवेश (fst p))
          → केन्द्रम् ≡ w
  एकत्वम् (p , e) =
    ΣPathP ( आधारः , isProp→PathP (λ i → आधार-प्रोप् (आधारः i)) _ e )
    where
    आधारः : ((false , false) , refl) ≡ p
    आधारः = Σ≡Prop (λ y → isSetBool (प्रथमांश y) false)
                   (sym (प्रतिबिम्बः (fst p) e (snd p)))

-- Over `true` the base again has two points — ((true , false) , refl)
-- and ((true , true) , refl) — and §१ says BOTH प्रवेश-fibres are Unit.
-- So the Σ has two inhabitants and the alignment term is zero here.  The
-- alignment defect is therefore a function of the base point, not a
-- constant of the pair of maps.

हस्त-शेष-सत्ये : (Σ[ p ∈ fiber प्रथमांश true ] fiber प्रवेश (fst p)) ≃ Bool
हस्त-शेष-सत्ये = isoToEquiv (iso to from ri li)
  where
  RHS = Σ[ p ∈ fiber प्रथमांश true ] fiber प्रवेश (fst p)

  to : RHS → Bool
  to (((a , b) , q) , e) = b

  from : Bool → RHS
  from false = (((true , false) , refl) , (inl true , refl))
  from true  = (((true , true) , refl) , (inr tt , refl))

  ri : (b : Bool) → to (from b) ≡ b
  ri false = refl
  ri true  = refl

  -- every प्रवेश-fibre over a point of this base is a proposition:
  -- over (true , false) it is Unit, over (true , true) it is Unit.
  आधार-प्रोप् : (p : fiber प्रथमांश true) → isProp (fiber प्रवेश (fst p))
  आधार-प्रोप् ((a , false) , q) =
    isContr→isProp (subst (λ a' → isContr (fiber प्रवेश (a' , false)))
                          (sym q) (प्रवेश-असत्ये true))
  आधार-प्रोप् ((a , true) , q) =
    isContr→isProp (subst (λ a' → isContr (fiber प्रवेश (a' , true)))
                          (sym q) प्रवेश-सत्ये-सत्यम्)

  -- `b` is split before the path is built, so that `from b` reduces and
  -- the base identification can be written down concretely at each of
  -- the two points of the base.
  li : (w : RHS) → from (to w) ≡ w
  li (((a , false) , q) , e) =
    ΣPathP ( आधारः , isProp→PathP (λ i → आधार-प्रोप् (आधारः i)) _ e )
    where
    आधारः : Path (fiber प्रथमांश true) ((true , false) , refl) ((a , false) , q)
    आधारः = Σ≡Prop (λ y → isSetBool (प्रथमांश y) true)
                   (ΣPathP (sym q , refl))
  li (((a , true) , q) , e) =
    ΣPathP ( आधारः , isProp→PathP (λ i → आधार-प्रोप् (आधारः i)) _ e )
    where
    आधारः : Path (fiber प्रथमांश true) ((true , true) , refl) ((a , true) , q)
    आधारः = Σ≡Prop (λ y → isSetBool (प्रथमांश y) true)
                   (ΣPathP (sym q , refl))

-- ── THE AGREEMENT. ───────────────────────────────────────────────────
--
-- §४ computed the left side by hand; the two paragraphs above computed
-- the right side by hand; `शेष-मध्ये` connects them without either.
-- Over `true` the composite of the general law with the hand-computed
-- right side is POINTWISE EQUAL to the hand-computed left side, and the
-- proof is `refl` at each of the two points: शेष sends `(x , q)` to
-- `((प्रवेश x , q) , (x , refl))`, and reading the second coordinate of
-- `प्रवेश x` returns `false` for `inl b` and `true` for `inr tt` — which
-- is what §४'s `to` returns, on the nose.
--
-- This is the check the whole module exists to make, and it PASSES.  The
-- composition law covers this chain.

संगतिः-सत्ये : (w : fiber मध्यम true)
             → equivFun मध्यम-तन्तुः-सत्ये w
             ≡ equivFun (compEquiv (शेष-मध्ये true) हस्त-शेष-सत्ये) w
संगतिः-सत्ये (inl b , p)  = refl
संगतिः-सत्ये (inr tt , p) = refl

-- Over `false` both sides land in Unit, so agreement is automatic; it is
-- stated anyway, because "automatic" is a claim about Unit and not about
-- this chain, and the module's business is to leave nothing implicit.
संगतिः-असत्ये : (w : fiber मध्यम false)
              → equivFun मध्यम-तन्तुः-असत्ये w
              ≡ equivFun (compEquiv (शेष-मध्ये false) हस्त-शेष-असत्ये) w
संगतिः-असत्ये w = refl

------------------------------------------------------------------------
-- ६ · THE WHOLE CHAIN, AND THE LEDGER FAILING.
--
-- The total fibre, by hand: पूर्ण is constant, so its fibre over the
-- single point of Unit is the whole source.
------------------------------------------------------------------------

पूर्ण-तन्तुः : fiber पूर्ण tt ≃ (Bool ⊎ Unit)
पूर्ण-तन्तुः = isoToEquiv (iso fst (λ x → (x , refl)) (λ _ → refl)
  (λ w → Σ≡Prop (λ _ → isSetUnit tt tt) refl))

-- THE ADDITIVE PREDICTION.  प्रवेश is injective, so the naive ledger
-- charges it nothing (Unit); प्रथमांश costs one bit (§२, uniformly);
-- विस्मरण costs one bit (§३).  Multiply the fibres — which is exactly
-- what `Sesa_…शेषसमता` licenses WHEN ITS HYPOTHESIS HOLDS — and the
-- prediction for the total fibre is:
--
--     Unit × Bool × Bool  ≃  Bool × Bool          (four)
--
-- The truth is `Bool ⊎ Unit` (three).  And three is not four:

त्रयो-न-चत्वारः : ¬ ((Bool ⊎ Unit) ≃ (Bool × Bool))
त्रयो-न-चत्वारः e = znots (injSuc (injSuc (injSuc (Fin-inj 3 4 मार्गः))))
  where
  त्रि : (Bool ⊎ Unit) ≃ SFin 3
  त्रि = isoToEquiv (iso to from ri li)
    where
    to : Bool ⊎ Unit → SFin 3
    to (inl false) = inl tt
    to (inl true)  = inr (inl tt)
    to (inr tt)    = inr (inr (inl tt))

    from : SFin 3 → Bool ⊎ Unit
    from (inl tt)                = inl false
    from (inr (inl tt))          = inl true
    from (inr (inr (inl tt)))    = inr tt
    from (inr (inr (inr ())))

    ri : (k : SFin 3) → to (from k) ≡ k
    ri (inl tt)             = refl
    ri (inr (inl tt))       = refl
    ri (inr (inr (inl tt))) = refl
    ri (inr (inr (inr ())))

    li : (x : Bool ⊎ Unit) → from (to x) ≡ x
    li (inl false) = refl
    li (inl true)  = refl
    li (inr tt)    = refl

  चतुर् : (Bool × Bool) ≃ SFin 4
  चतुर् = isoToEquiv (iso to from ri li)
    where
    to : Bool × Bool → SFin 4
    to (false , false) = inl tt
    to (false , true)  = inr (inl tt)
    to (true  , false) = inr (inr (inl tt))
    to (true  , true)  = inr (inr (inr (inl tt)))

    from : SFin 4 → Bool × Bool
    from (inl tt)                      = (false , false)
    from (inr (inl tt))                = (false , true)
    from (inr (inr (inl tt)))          = (true  , false)
    from (inr (inr (inr (inl tt))))    = (true  , true)
    from (inr (inr (inr (inr ()))))

    ri : (k : SFin 4) → to (from k) ≡ k
    ri (inl tt)                   = refl
    ri (inr (inl tt))             = refl
    ri (inr (inr (inl tt)))       = refl
    ri (inr (inr (inr (inl tt)))) = refl
    ri (inr (inr (inr (inr ()))))

    li : (y : Bool × Bool) → from (to y) ≡ y
    li (false , false) = refl
    li (false , true)  = refl
    li (true  , false) = refl
    li (true  , true)  = refl

  मार्गः : FFin 3 ≡ FFin 4
  मार्गः = sym (SumFin≡Fin 3)
         ∙ ua (compEquiv (invEquiv त्रि) (compEquiv e चतुर्))
         ∙ SumFin≡Fin 4

-- so the additive prediction is false OF THIS CHAIN, and not by a
-- rounding: the predicted fibre and the actual fibre are not equivalent
-- types at all.
लेखा-न-योज्या : ¬ (fiber पूर्ण tt ≃ (Bool × Bool))
लेखा-न-योज्या e = त्रयो-न-चत्वारः (compEquiv (invEquiv पूर्ण-तन्तुः) e)

------------------------------------------------------------------------
-- ७ · WHERE THE MISSING ONE WENT, AND WHY IT IS NOT A NUMBER.
--
-- `Sesa_…शेषसमता` — the clause under which the fibres multiply and the
-- logs add — has as its hypothesis that the first map has a UNIFORM
-- fibre: some Φ with fibre f y ≃ Φ for every y.  प्रवेश does not.  The
-- refutation needs both of §१'s ends at once and nothing else:
------------------------------------------------------------------------

न-समता : (Φ : Type₀) → ((y : Bool × Bool) → fiber प्रवेश y ≃ Φ) → ⊥
न-समता Φ u = अभावः (invEq (u (false , true))
                          (equivFun (u (true , true)) (inr tt , refl)))

-- THE ABSENCE, WITH BOTH ITS SLOTS FILLED (Nyāya–Vaiśeṣika; see header).
--
--   pratiyogin (counterpositive — what is absent):  (false , true)
--   anuyogin   (locus — where it is absent):        the image of प्रवेश
--
-- and the third slot, the avacchedaka (limitor), is what keeps this from
-- being the useless claim that something is missing somewhere: the
-- absence is limited to the fibre of प्रथमांश over `false`, and §५'s two
-- hand computations are exactly the statement that under the OTHER
-- limitor — the fibre over `true` — there is no absence at all.  A bare
-- "the count came out short by one" carries none of that.

प्रतियोगी : Bool × Bool
प्रतियोगी = (false , true)

अनुयोगी : ¬ fiber प्रवेश प्रतियोगी
अनुयोगी = अभावः

अवच्छेदकः : प्रथमांश प्रतियोगी ≡ false
अवच्छेदकः = refl

------------------------------------------------------------------------
-- ८ · THE CANCELLING CHAIN IS THE SAME PHENOMENON.
--
--     Unit --स्थापना--> Bool --विस्मरण--> Unit
--
-- The first map loses nothing, the second loses a bit, and the composite
-- is the identity: the losses CANCEL.  This counterexample already sits
-- in the corpus as an anomaly that refuted a sequential diagnostic.  It
-- is not an anomaly.  It is §५ again, with the same alignment term:
-- `fiber विस्मरण tt` has two points and स्थापना's fibre over one of them
-- is EMPTY, so the Σ collapses to one — exactly as it did over `false`
-- in §५.
------------------------------------------------------------------------

स्थापना : Unit → Bool
स्थापना _ = true

निवृत्तिः : (u : Unit) → विस्मरण (स्थापना u) ≡ u
निवृत्तिः tt = refl

स्थापना-तन्तुः-सत्ये : isContr (fiber स्थापना true)
fst स्थापना-तन्तुः-सत्ये = (tt , refl)
snd स्थापना-तन्तुः-सत्ये (tt , r) =
  Σ≡Prop (λ u → isSetBool (स्थापना u) true) refl

स्थापना-अभावः : ¬ fiber स्थापना false
स्थापना-अभावः (tt , r) = true≢false r

-- the composite loses nothing …
समष्टिः-रिक्ता : isContr (fiber (λ u → विस्मरण (स्थापना u)) tt)
fst समष्टिः-रिक्ता = (tt , refl)
snd समष्टिः-रिक्ता (tt , r) = Σ≡Prop (λ _ → isSetUnit tt tt) refl

-- … and शेष says where the bit went: into a base point whose fibre is
-- the absence.  Instantiated, not asserted.
शेष-निवृत्तौ : fiber (λ u → विस्मरण (स्थापना u)) tt
             ≃ (Σ[ p ∈ fiber विस्मरण tt ] fiber स्थापना (fst p))
शेष-निवृत्तौ = शेष विस्मरण स्थापना tt

------------------------------------------------------------------------
-- ९ · शेषः — what this leaves open.
--
-- (a) ONE chain is priced.  The result that generalises is §७'s, and it
--     is a NEGATIVE one: the per-step fibres do not determine the
--     composite's fibre unless the earlier map's fibre is uniform.  What
--     a general POSITIVE ledger would need is a way to carry the
--     alignment term — the family `λ p → fiber f (fst p)` over `fiber g
--     z` — as data, and no module in this corpus does that yet.
--
-- (b) Everything here is finite, decidable and a set.  `Lopa_…` prices an
--     edge with an unbounded fibre; nothing here says the composite of
--     two such edges behaves like §५, and the ℕ-indexed case is the next
--     honest step.  `YugmaPurana_…`'s ℤ/2 cut composed with `योग` is the
--     nearest chain in the corpus whose middle is not enumerable.
--
-- (c) The absence in §७ was FOUND, not derived: the chain was chosen so
--     that प्रवेश would miss a point of प्रथमांश's fibre over `false`.
--     Whether a route through the corpus's directed graph can be
--     SEARCHED for its alignment terms — which points of which fibre a
--     given edge misses — is open, and it is the question that decides
--     whether the ledger is computable or only checkable.
--
-- (d) Not attempted: any claim that the arithmetic 4 − 3 = 1 is the
--     "size" of the absence.  §६ proves a non-equivalence of types; the
--     subtraction is a reading, and the corpus has been burned before by
--     a number that looked like knowledge.
------------------------------------------------------------------------
