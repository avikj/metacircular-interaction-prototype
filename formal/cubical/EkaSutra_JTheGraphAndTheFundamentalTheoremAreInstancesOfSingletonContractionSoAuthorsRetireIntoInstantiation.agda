{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- एकसूत्र — one aphorism.  अल्पं स्थापय, शेषं जनय: hold one line, generate
-- the rest.  The line is the fibre law's positive half —
--
--     THE SINGLETON IS CONTRACTIBLE:  isContr (Σ[ y ] (x ≡ y))
--
-- — and this module makes it ABSORB the apparatus, so that results which
-- are hand-proved elsewhere become instantiations here:
--
--   §१  J — based path induction, THE eliminator of the identity type —
--       is derived from the law (with its β-rule).  The identity type's
--       own recursion principle is an instance, not a primitive act.
--   §२  निवृत्ति, the RETIREMENT OPERATOR: any property of any type
--       transports along any equivalence (subst ∘ ua).  Prove once at
--       the canonical presentation; every equivalent presentation
--       inherits it with no author present.
--   §३  The graph decomposition A ≃ Σ[ b ] fiber f b (HoTT Lemma 4.8.2)
--       — the whole boundary/memory reading of the corpus — in four
--       lines from one connection square, the same singleton fact read
--       at the total space.
--   §४  THE FUNDAMENTAL THEOREM OF IDENTITY TYPES (HoTT 5.8.4, one
--       direction): a pointed family with contractible total space IS
--       the path family — (a₀ ≡ x) ≃ R x.  This is the theorem that
--       "retires" encode–decode authors: to compute any identity type,
--       exhibit one contractible Σ and the equivalence is issued here.
--
-- WHAT "RETIRE" MEANS, operationally.  A library written against this
-- module does not prove transport lemmas, path inductions, graph
-- decompositions, or encode–decode equivalences; it EXHIBITS a
-- contractible singleton (or a contractible total space) and calls the
-- corresponding section.  The author's remaining act is choosing the
-- instance — which is the corpus's thesis about all knowledge work,
-- landed on its own foundations.
--
-- WHAT IS NOT CLAIMED.  Nothing here is new mathematics: J, 4.8.2 and
-- 5.8.4 are the univalent foundations' own results (The HoTT Book,
-- 2013; Voevodsky's library before it), and cubical primitives are
-- CCHM/ABCFHL.  What is contributed is the ABSORPTION — each derived
-- here from singleton contraction alone, in one file, so the
-- instantiation surface is one import.  The universe-level instance
-- (EquivContr/EquivJ — the same law one universe up, through ua) and
-- the converse of §४ are named as owed, not smuggled.
--
-- TERM.  एकसूत्र — "one thread / one aphorism"; ordinary Sanskrit,
-- compound built here, no text claimed (CLAUDE.md naming rule note 2).
--
-- CHECKED: Agda 2.6.3 + cubical v0.5 (container; corpus pin 2.8.0/v0.9).
-- --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module EkaSutra_JTheGraphAndTheFundamentalTheoremAreInstancesOfSingletonContractionSoAuthorsRetireIntoInstantiation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.GroupoidLaws using (lCancel)
open import Cubical.Data.Sigma

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §० · THE LINE.
------------------------------------------------------------------------

सूत्रम् : {A : Type ℓ} (x : A) → isContr (singl x)
सूत्रम् x = isContrSingl x

------------------------------------------------------------------------
-- §१ · J IS AN INSTANCE.  The eliminator of the identity type, with its
--      β-rule, from the line alone: transport the motive along the
--      contraction of the singleton.
------------------------------------------------------------------------

सूत्र-J : {A : Type ℓ} {x : A} (P : (y : A) → x ≡ y → Type ℓ')
        → P x refl → {y : A} (p : x ≡ y) → P y p
सूत्र-J {x = x} P d {y} p =
  subst (λ (s : singl x) → P (fst s) (snd s)) (सूत्रम् x .snd (y , p)) d

सूत्र-J-β : {A : Type ℓ} {x : A} (P : (y : A) → x ≡ y → Type ℓ')
          (d : P x refl) → सूत्र-J P d refl ≡ d
सूत्र-J-β {x = x} P d = substRefl {B = λ (s : singl x) → P (fst s) (snd s)} d
-- (the contraction of singl at its own centre is definitionally refl,
--  which is why the β-rule is one substRefl and not a coherence.)

------------------------------------------------------------------------
-- §२ · निवृत्ति — the retirement operator.  Any property, along any
--      equivalence, no author required.  This is transport-of-structure
--      in its smallest complete form: the SIP's working end.
------------------------------------------------------------------------

निवृत्तिः : {A B : Type ℓ} (P : Type ℓ → Type ℓ')
          → A ≃ B → P A → P B
निवृत्तिः P e = subst P (ua e)

------------------------------------------------------------------------
-- §३ · THE GRAPH DECOMPOSITION IS AN INSTANCE (HoTT 4.8.2).
--      A ≃ Σ[ b ] fiber f b — one connection square, the singleton fact
--      read at the total space.  The corpus's boundary/memory theorems
--      (Avaccheda, Sesa, SankramanaSesa §2) instantiate this.
------------------------------------------------------------------------

गुणसमष्टिः : {A : Type ℓ} {B : Type ℓ} (f : A → B)
           → A ≃ (Σ[ b ∈ B ] fiber f b)
गुणसमष्टिः f = isoToEquiv (iso अनु प्रति निवृत्ति λ _ → refl)
  where
  अनु : _
  अनु a = f a , a , refl
  प्रति : _
  प्रति (b , a , p) = a
  निवृत्ति : ∀ s → अनु (प्रति s) ≡ s
  निवृत्ति (b , a , p) i = p i , a , λ j → p (i ∧ j)

-- …and therefore every property of A holds of the graph, by §२, with no
-- further proof anywhere: the instantiation that retires the author.
गुण-निवृत्तिः : {A B : Type ℓ} (f : A → B) (P : Type ℓ → Type ℓ')
             → P A → P (Σ[ b ∈ B ] fiber f b)
गुण-निवृत्तिः f P = निवृत्तिः P (गुणसमष्टिः f)

------------------------------------------------------------------------
-- §४ · THE FUNDAMENTAL THEOREM OF IDENTITY TYPES IS AN INSTANCE
--      (HoTT 5.8.4, forward direction).  A pointed family R with
--      contractible total space IS the path family from the point:
--
--          (a₀ ≡ x) ≃ R x,   naturally in x.
--
--      To characterize ANY identity type, exhibit ONE contractible Σ;
--      the equivalence — the whole encode–decode ritual — is issued
--      below.  The proof is the line twice: singl for the path side,
--      the hypothesis for the R side, contraction against contraction.
------------------------------------------------------------------------

module मूलप्रमेयम्
  {A : Type ℓ} {R : A → Type ℓ} {a₀ : A} (r₀ : R a₀)
  (साकल्यम् : isContr (Σ A R))
  where

  private
    σ : (x : A) (r : R x) → Path (Σ A R) (a₀ , r₀) (x , r)
    σ x r = sym (साकल्यम् .snd (a₀ , r₀)) ∙ साकल्यम् .snd (x , r)

  अभिमुखम् : (x : A) → a₀ ≡ x → R x
  अभिमुखम् x p = subst R p r₀

  प्रतिमुखम् : (x : A) → R x → a₀ ≡ x
  प्रतिमुखम् x r = cong fst (σ x r)

  अनुलोमम् : (x : A) (r : R x) → अभिमुखम् x (प्रतिमुखम् x r) ≡ r
  अनुलोमम् x r = fromPathP (cong snd (σ x r))

  प्रतिलोमम् : (x : A) (p : a₀ ≡ x) → प्रतिमुखम् x (अभिमुखम् x p) ≡ p
  प्रतिलोमम् x p = सूत्र-J (λ y q → प्रतिमुखम् y (अभिमुखम् y q) ≡ q) आधारः p
    where
    आधारः : प्रतिमुखम् a₀ (अभिमुखम् a₀ refl) ≡ refl
    आधारः =
        cong (प्रतिमुखम् a₀) (substRefl {B = R} r₀)
      ∙ cong (cong fst) (lCancel (साकल्यम् .snd (a₀ , r₀)))

  प्रमेयम् : (x : A) → (a₀ ≡ x) ≃ R x
  प्रमेयम् x = isoToEquiv (iso (अभिमुखम् x) (प्रतिमुखम् x) (अनुलोमम् x) (प्रतिलोमम् x))
