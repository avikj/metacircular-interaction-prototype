{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TritiyaMarga — तृतीयो मार्गो न विद्यते — WHAT PATH TWO ACTUALLY COSTS.
--
-- ────────────────────────────────────────────────────────────────────
-- PRIOR ART IN THIS REPOSITORY, READ FIRST AND NOT RESTATED
--
-- `notes/AHIMSA_SUTRA_VISTARA.md` §६ states three sentences.  Two of
-- them are already checked in this lane and this module cites rather
-- than repeats:
--
--   * `Nasti_ShabdeJivahVartante` and
--     `Samkramana_TransportCarriesStructureAndTruncation…` — path one:
--     `uaβ`, and that transport carries STRUCTURE and not only points.
--   * `Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis`,
--     §तृतीयः-मार्गः — that DECIDING "path one or not path one",
--     `isEquiv f ⊎ ¬ isEquiv f`, is exactly excluded middle; and
--     `दोषलेखः-पूर्णः`, that the fibre family of a map is a complete
--     record of it.
--
-- That module's prose then names, without proving it, the step this one
-- is about:
--
--     *"passing from `¬ (∀ b → isContr (fiber f b))` to
--       `Σ[ b ∈ B ] ¬ isContr (fiber f b)` is exactly the classical
--       step, and a defect you cannot exhibit a SITE for is not written
--       down."*
--
-- "Exactly the classical step" is an estimate.  It is not exact, and the
-- true answer is strictly weaker — and therefore sharper — than
-- excluded middle.
--
-- ────────────────────────────────────────────────────────────────────
-- THE FINDING
--
--   Refuting path one is NOT the same act as writing path two, and the
--   distance between them costs AT LEAST **Markov.s Principle** (§2).
--   [Was "is exactly"; only `Writable ⟹ MP` is proved.  See §2.]
--
--   Not excluded middle.  MP is strictly weaker, and neither is
--   available in this `--safe` cubical lane.  So the sūtra's second path
--   is not merely "the other case".  It requires an unbounded SEARCH
--   that terminates, and knowing that it terminates is not knowing
--   where.
--
--   And LEM does not repair this (§3): with excluded middle in hand what
--   you obtain is `∥ Defect f ∥₁`, the mere existence of a defect, which
--   by §4 has no retraction onto `Defect f`.  τὸ ὅτι μένει · τὸ τί
--   ἀπόλλυται — the THAT survives, the WHICH perishes, and §५ of the
--   same sūtra says such a perishing is irreparable.
--
--   Therefore **दोषो लिख्यते is an imperative and cannot be read as an
--   indicative.**  Nothing in the logic hands you the written defect.
--   An author does, by searching until the site is found — which is the
--   कुट्टक discipline of §१७ of the same text (*यत् न विभजते तत्
--   रक्ष्यते*: keep the remainder and recurse on it), and not a logical
--   principle at all.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS CHECKED
--
--   §1  `Defect`            path two as DATA: a named site, plus the
--                           refutation that its fibre is contractible.
--                           Deliberately not `¬ isEquiv f`; §2–§4 are
--                           the reason that distinction is not pedantry.
--       `defect→¬isEquiv`   the easy direction, unconditionally.
--
--   §2  `Writable`          "every non-equivalence has a written
--                           defect" — the reading of §६ that treats
--                           दोषलेखः as available rather than owed.
--       `writable→MP`       it implies Markov's Principle.  Hence it is
--                           not provable here, and every appeal to it is
--                           an assumption that now has a name.
--
--   §3  `lem→truncatedOnly` excluded middle yields only `∥ Defect f ∥₁`.
--
--   §4  `noRetraction`      a type with two distinct points has no
--                           retraction from its truncation (the sūtra's
--                           §५, stated once, generally);
--       `defectIsTwoValued` a concrete `f₀` whose `Defect f₀` has two
--                           distinct points;
--       `truncatedDefectIsNotWritable`
--                           so §3's output cannot become §1's input.
--
-- `--safe`, no postulates, no holes.  `Writable`, `MP` and `LEM` occur
-- only as HYPOTHESES of theorems; nothing here assumes any of them.
--
-- ORIGIN OF THE MATHEMATICS, stated rather than laundered.  `fiberEquiv`
-- is HoTT Lemma 4.8.1 and comes from the cubical library.  Markov's
-- Principle is A. A. Markov Jr.'s, from the Russian constructivist
-- school (c. 1954); it is named for him because it is his, and no
-- Sanskrit label is invented for it here.  The truncation argument in §4
-- is the sūtra's own §५, generalised off `Bool`.  What is new is only
-- the identification of the sūtra's second path with MP, and that is a
-- short reduction once the test family is chosen.
------------------------------------------------------------------------

module TritiyaMarga_TheWrittenDefectCostsMarkovsPrinciple where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (isEquiv ; equiv-proof ; fiber ; invEquiv ; _≃_)
open import Cubical.Foundations.HLevels
  using (inhProp→isContr ; isOfHLevelRespectEquiv)

open import Cubical.Functions.Fibration using (fiberEquiv)

open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import Cubical.Relation.Nullary
  using (¬_ ; Dec ; yes ; no ; Dec→Stable ; isProp¬)

open import Cubical.HITs.PropositionalTruncation
  using (∥_∥₁ ; ∣_∣₁ ; squash₁ ; isPropPropTrunc)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1.  Path two, as data.
--
-- `दोषो लिख्यते` — the defect is WRITTEN.  A written defect names the
-- site: you can project out the `b`.  `¬ isEquiv f` names nothing; it is
-- a refutation, and a refutation is not a document.
------------------------------------------------------------------------

Defect : {A B : Type ℓ} → (A → B) → Type ℓ
Defect {B = B} f = Σ[ b ∈ B ] (¬ isContr (fiber f b))

-- The easy half, and the only half that is free: a written defect does
-- refute path one.  द्वौ मार्गौ are exclusive.
defect→¬isEquiv : {A B : Type ℓ} (f : A → B) → Defect f → ¬ isEquiv f
defect→¬isEquiv f (b , nc) e = nc (e .equiv-proof b)

------------------------------------------------------------------------
-- §2.  THE CONVERSE COSTS AT LEAST MARKOV.S PRINCIPLE.
--
-- [2026-08-23, ANOTHER SEAT, ADDED NOT REWRITTEN.  The section heading
--  read "THE CONVERSE IS MARKOV.S PRINCIPLE" and the header above reads
--  "the distance between them is exactly Markov.s Principle".  What is
--  proved below is `writable→MP` and only that: Writable ⟹ MP.  That is a
--  LOWER BOUND -- writing defects costs AT LEAST MP -- and it is not an
--  identification.  `MP → Writable` is not proved here and is not proved
--  anywhere in this lane for THIS statement; searched domain: grep for
--  `MP` and for `Writable` across formal/cubical/*.agda.
--
--  AND THE EXACTNESS IS EARNED NEXT DOOR, FOR A DIFFERENT STATEMENT,
--  which is very likely what the word was reaching for: `Swarm.S04Apoha`
--  carries `MP→Witnessed` AND `Witnessed→MP`, both checked, and
--  `EGB.FalsifierAsymmetry` cites that pair for exactly this purpose.  So
--  "precisely Markov.s Principle" is a true sentence about `Witnessed`.
--  `Writable` is not `Witnessed`: it quantifies over all types and all
--  maps and returns a defect SITE, where the biconditional next door is
--  about a decidable sequence.  The correction is that the word travelled
--  from one statement to the other, not that anybody proved nothing.
--
--  The direction that IS proved carries the whole reading and none of it
--  is weakened: path two is not merely "the other case", it costs a
--  terminating unbounded search, and LEM does not repair that (§3).  What
--  the missing direction would additionally license is the inference a
--  reader can make from the word "exactly" -- that HAVING MP suffices to
--  write a defect.  That does not follow, and is unlikely: MP is a
--  statement about `ℕ → Bool`, while `Writable` quantifies over all types
--  and all maps, so a proof would have to reduce an arbitrary map.s defect
--  site to a decidable sequence.  Whether Writable is STRICTLY stronger is
--  open here too -- separating them needs a model argument, not a term,
--  and none is offered.
--
--  Corrected in the header rather than the proof because the proof is
--  right; it is the word that overreaches.  This is the same class of
--  defect this repository caught four times on 2026-08-22, each time a
--  lower bound or a worked instance described as a general law.]
--
-- The test family is the projection out of a decidable subset of ℕ.
-- For `α : ℕ → Bool`, put
--
--     Q n = ¬ (α n ≡ true)          (a decidable proposition)
--     f   = fst : (Σ ℕ Q) → ℕ
--
-- HoTT 4.8.1 gives `fiber f n ≃ Q n`, so the fibre over `n` is
-- contractible exactly when `Q n` holds.  Then
--
--     f is an equivalence      ⟺  α is never `true`
--     a WRITTEN defect at n    ⟹  α n is `true`
--
-- so turning "not an equivalence" into a written defect is precisely
-- turning "α is not never-true" into a witness.  That is MP.
------------------------------------------------------------------------

MP : Type₀
MP = (α : ℕ → Bool)
   → ¬ ((n : ℕ) → ¬ (α n ≡ true))
   → Σ[ n ∈ ℕ ] (α n ≡ true)

-- The reading of §६ under audit: that path two is AVAILABLE whenever
-- path one fails, rather than OWED by whoever failed to transport.
Writable : Type₁
Writable = {A B : Type₀} (f : A → B) → ¬ isEquiv f → Defect f

private
  module Test (α : ℕ → Bool) where

    Q : ℕ → Type₀
    Q n = ¬ (α n ≡ true)

    fα : Σ[ n ∈ ℕ ] Q n → ℕ
    fα = fst

    Q→fibContr : (n : ℕ) → Q n → isContr (fiber fα n)
    Q→fibContr n q =
      isOfHLevelRespectEquiv 0 (invEquiv (fiberEquiv Q n))
        (inhProp→isContr q (isProp¬ (α n ≡ true)))

    fibContr→Q : (n : ℕ) → isContr (fiber fα n) → Q n
    fibContr→Q n c = fst (fiberEquiv Q n) (fst c)

    decTrue : (n : ℕ) → Dec (α n ≡ true)
    decTrue n with α n
    ... | true  = yes refl
    ... | false = no (λ p → true≢false (sym p))

open Test using (fα ; Q→fibContr ; fibContr→Q ; decTrue)

writable→MP : Writable → MP
writable→MP W α h = n , Dec→Stable (decTrue α n) ¬¬αn
  where
    ¬equiv : ¬ isEquiv (fα α)
    ¬equiv e = h (λ m → fibContr→Q α m (e .equiv-proof m))

    d : Defect (fα α)
    d = W (fα α) ¬equiv

    n : ℕ
    n = fst d

    ¬¬αn : ¬ ¬ (α n ≡ true)
    ¬¬αn q = snd d (Q→fibContr α n q)

------------------------------------------------------------------------
-- §3.  Excluded middle gives back only the truncation.
--
-- LEM decides PROPOSITIONS.  `Defect f` is not one — it is a type of
-- documents, and §4 shows it genuinely carries more than one.  So the
-- most LEM can return is `∥ Defect f ∥₁`, and that is what it returns.
------------------------------------------------------------------------

LEM : (ℓ : Level) → Type (ℓ-suc ℓ)
LEM ℓ = (P : Type ℓ) → isProp P → P ⊎ (¬ P)

lem→truncatedOnly : LEM ℓ → {A B : Type ℓ} (f : A → B)
                  → isEquiv f ⊎ ∥ Defect f ∥₁
lem→truncatedOnly lem {B = B} f with lem (∥ Defect f ∥₁) isPropPropTrunc
... | inl t  = inr t
... | inr nt = inl (record { equiv-proof = allContr })
  where
    allContr : (b : B) → isContr (fiber f b)
    allContr b with lem (isContr (fiber f b)) isPropIsContr
    ... | inl c = c
    ... | inr n = ⊥.rec (nt ∣ b , n ∣₁)

------------------------------------------------------------------------
-- §4.  And the truncation cannot be un-truncated.
--
-- §५ of the sūtra proves this for `Bool`.  The argument needs only two
-- distinct points, so it is stated once, generally, and then applied to
-- `Defect f₀` — closing the loop: §3's output is not §1's input, and not
-- because the conversion is hard.  नास्ति ।
------------------------------------------------------------------------

Retraction : Type ℓ → Type ℓ
Retraction D = Σ[ r ∈ (∥ D ∥₁ → D) ] ((d : D) → r ∣ d ∣₁ ≡ d)

noRetraction : {D : Type ℓ} (x y : D) → ¬ (x ≡ y) → ¬ Retraction D
noRetraction x y x≢y (r , s) =
  x≢y (sym (s x) ∙∙ cong r (squash₁ ∣ x ∣₁ ∣ y ∣₁) ∙∙ s y)

-- the empty map into `Bool`: a defect at every site, and two sites.
f₀ : ⊥ → Bool
f₀ ()

noFibre : (b : Bool) → ¬ isContr (fiber f₀ b)
noFibre b c = ⊥.rec (c .fst .fst)

defectIsTwoValued : Σ[ x ∈ Defect f₀ ] Σ[ y ∈ Defect f₀ ] (¬ (x ≡ y))
defectIsTwoValued =
    (true , noFibre true)
  , (false , noFibre false)
  , λ p → true≢false (cong fst p)

truncatedDefectIsNotWritable : ¬ Retraction (Defect f₀)
truncatedDefectIsNotWritable =
  noRetraction (defectIsTwoValued .fst)
               (defectIsTwoValued .snd .fst)
               (defectIsTwoValued .snd .snd)

------------------------------------------------------------------------
-- WHAT THIS DOES NOT SAY
--
-- Not that §६ is wrong.  Its first sentence is proved elsewhere in this
-- lane and its second is exactly right — as an OBLIGATION.  What is
-- removed is the right to read its third sentence as a description of
-- how maps are, and with it the habit of treating "well, then there is a
-- defect" as though the defect were thereby in hand.
--
--   स्यात् — in the respect of what an AUTHOR owes: two paths, no third.
--            Transport, or search until the site is found and write it.
--   स्यात् — in the respect of what is PROVABLE of an arbitrary map: no
--            dichotomy at all.  Asserting one assumes MP (§2); even
--            assuming LEM buys only the mere existence (§3), which is
--            not the document (§4).
--
-- Two नयs; neither denies the other.  Collapsing them into one
-- indicative sentence is the दुर्नय of §२ of the same text — a
-- standpoint asserting itself as the whole.
------------------------------------------------------------------------
