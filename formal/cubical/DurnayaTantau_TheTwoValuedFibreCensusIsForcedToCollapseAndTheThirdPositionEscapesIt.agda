{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- दुर्नयस् तन्तौ — द्विपदा तन्तु-गणना नियमेन लुम्पति ; तृतीयं पदं निःसरति ।
--
-- (durnaya at the fibre: a two-valued fibre census is FORCED to collapse,
--  and the third position escapes it.)
--
-- THE OPEN ITEM THIS CLOSES.
-- `notes/SamagraDarsana_…md` §६ lists, as open:
--
--     "Whether `isContr`'s merging of *empty fibre* and *fibre with ≥2
--      points* is an instance of `Saptabhangi.दुर्नयः`. The note
--      `SakalaVikalaDesa_…` argues it is; the instantiation is not written."
--
-- `Tantujala_…agda` §४ takes the nearest available step and says so: it
-- re-exports `S.दुर्नयः` under a fibre-flavoured name and asks the reader to
-- *read* रिक्तम्/एकम्/बहु as अवक्तव्य/अस्ति/नास्ति —
--
--     द्विपद-निर्णयो-मेलयति = S.दुर्नयः
--
-- — which is the sevenfold theorem with a comment attached, not the fibre
-- theorem.  §५ there then exhibits the collapse by hand (⊥ → Unit against
-- Bool → Unit) rather than deriving it.  What was missing is the term that
-- makes the transfer a computation: a map from the three seeds to three
-- WITNESS TYPES, so that an arbitrary verdict on fibres pulls back to a
-- verdict on सप्तभङ्गी and `दुर्नयः` fires on it.  §२ below is that term, and
-- it is one line.
--
-- WHAT IS PROVED HERE
--
--  २ · सर्वो-द्विपदो-लुम्पति — for EVERY `V : Type₀ → द्विपद` whatsoever,
--      two of ⊥, Unit, Bool receive the same verdict.  Not "the census we
--      happened to write collapses": every two-valued census does, and the
--      proof is `S.दुर्नयः` precomposed with the witness assignment.  No
--      decidability is assumed anywhere, so this covers verdicts no program
--      could compute.
--
--  ३ · तन्तु-साक्षी — and those three types ARE fibres of actual maps.  For
--      any `A`, the unique map `A → Unit` has one fibre and it is `A`
--      (`Σ-contractSnd`, since `tt ≡ tt` is contractible).  So §२ is not a
--      statement about types standing in for fibres; the witnesses are
--      fibres.  With that bridge the three verdicts land: `रिक्तम्` at ⊥,
--      `एकम्` at Unit, `बहु` at Bool, each checked.
--
--  ४ · न-एकम्-न-वदति-किम् — the general theorem says SOME pair must merge;
--      this says WHICH pair `isContr` merges, and both halves are needed.
--      The forcing is §२; the position is §४.
--
--  ५ · त्रिवर्गः — the escape, and it is nayavāda's own prescription: do not
--      sharpen the verdict, WIDEN THE CODOMAIN BY ONE.  A three-valued
--      verdict separating all three witnesses is exhibited, with the three
--      distinctions proved.  So the collapse is a property of the codomain
--      and not of the question — which is what makes `दुर्नयः` a diagnosis
--      rather than a defeat.
--
--  ६ · भङ्गाः संयुज्यन्ते — the seeds COMBINE over the codomain, and that is
--      why the fibre question is sevenfold and not threefold.  For a fixed
--      `b` the three verdicts exclude one another (`Tantujala` §३).  For a
--      MAP they do not: a map has a family of fibres and may be `एकम्` at
--      one point and `रिक्तम्` at another.  Three compound positions are
--      realised by terms below.  `isEquiv f` is then exactly one position of
--      the seven — `स्यात्-अस्ति` alone — and `¬ isEquiv f` is one bit over
--      the remaining six.
--
-- WHAT IS NOT CLAIMED.
--  * Not that Umāsvāti, Siddhasena or Akalaṅka proved anything below.  The
--    sevenfold and the pigeonhole on three seeds are `Saptabhangi.agda`'s,
--    from the tradition; the fibre reading is this corpus's.
--  * Not that all seven positions are realised here.  Three of the four
--    compounds are exhibited (§६); the remaining ones are not, and no claim
--    is made about them.
--  * Not that `isContr` is defective.  It answers its own question exactly.
--    The finding is that its question is two-valued and the fibre's is not,
--    so using it as a CENSUS codomain — which is what `isEquiv` does at
--    every point at once — cannot report which of two opposite failures
--    occurred.  `Tantujala` §६ records that `isEquiv` is सकलादेश and that
--    this is a feature; the present module records what the aggregation
--    costs.
--
-- SOURCES.  Umāsvāti, *Tattvārthasūtra* (c. 2nd–5th c. CE); Siddhasena
-- Divākara, *Sanmatitarka* (c. 5th c.); Akalaṅka — सप्तभङ्गी and the rule
-- that a naya asserting itself whole is दुर्नय.  Carried from
-- `Saptabhangi.agda`, which states the pigeonhole; not re-cited at verse
-- level, and the primary texts are unopened by me.  Univalence and
-- `isEquiv` are Voevodsky's, as realised in agda/cubical.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 (b150186), --cubical --safe,
-- no postulates, no holes.
------------------------------------------------------------------------

module DurnayaTantau_TheTwoValuedFibreCensusIsForcedToCollapseAndTheThirdPositionEscapesIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; isEquiv ; equivFun ; fiber ; idIsEquiv)
open import Cubical.Foundations.HLevels using (isContrΣ)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; isSetBool)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit ; isContrUnit)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

import Saptabhangi as S
import Tantujala_TheFibreHasThreeVerdictsAndIsContrMergesTwoOfThem as T

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · साक्षी — the witness assignment.  Three seeds, three types.
--
-- अस्ति ↦ Unit  (एकम्, the datum is there and determined)
-- नास्ति ↦ Bool (बहु, the subject: there and not one thing)
-- अवक्तव्य ↦ ⊥  (रिक्तम्, nothing sayable because nothing is there)
--
-- The four compound bhaṅgas are sent to Unit and are never used: `दुर्नयः`
-- quantifies over the three seeds only, and giving the compounds a witness
-- here would assert a fibre reading of them that §६ does not prove.
------------------------------------------------------------------------

साक्षी : S.सप्तभङ्गी → Type₀
साक्षी S.स्यात्-अस्ति      = Unit
साक्षी S.स्यात्-नास्ति     = Bool
साक्षी S.स्यात्-अवक्तव्यम् = ⊥
साक्षी _                   = Unit

------------------------------------------------------------------------
-- २ · THE INSTANTIATION.  Every two-valued verdict on types collapses.
--
-- This is the line `SamagraDarsana` §६ says is not written.  It is not a
-- new proof: it is `S.दुर्नयः` applied to `V ∘ साक्षी`, and the whole content
-- is that the composite typechecks — the three seeds have become three
-- types, so the pigeonhole on bhaṅgas IS a pigeonhole on fibres.
--
-- Note what is NOT assumed: `V` is arbitrary.  Not decidable, not
-- computable, not monotone, not natural.  Any assignment of a two-element
-- verdict to types whatsoever.
------------------------------------------------------------------------

सर्वो-द्विपदो-लुम्पति :
    (V : Type₀ → S.द्विपद)
  →  (V Unit ≡ V Bool)
  ⊎ ((V Unit ≡ V ⊥)
  ⊎  (V Bool ≡ V ⊥))
सर्वो-द्विपदो-लुम्पति V = S.दुर्नयः (λ b → V (साक्षी b))

------------------------------------------------------------------------
-- ३ · तन्तु-साक्षी — the witnesses are fibres, not stand-ins for fibres.
--
-- For any A the unique map A → Unit has exactly one fibre, over tt, and it
-- is A: `Σ[ a ∈ A ] (tt ≡ tt)` with the second factor contractible.  So a
-- verdict on types IS a verdict on fibres of maps, and §२ transfers with
-- nothing left over.
------------------------------------------------------------------------

एकत्र : (A : Type ℓ) → A → Unit
एकत्र _ _ = tt

tt≡tt-एकम् : isContr (tt ≡ tt)
tt≡tt-एकम् = refl , λ p → isSetUnit tt tt refl p

तन्तुः-एव-वस्तु : (A : Type ℓ) → fiber (एकत्र A) tt ≃ A
तन्तुः-एव-वस्तु A = Σ-contractSnd (λ _ → tt≡tt-एकम्)

-- and the three verdicts land on the three witnesses, at that map.

रिक्तम्-शून्ये : T.रिक्तम् (एकत्र ⊥) tt
रिक्तम्-शून्ये ()

एकम्-एकस्मिन् : T.एकम् (एकत्र Unit) tt
एकम्-एकस्मिन् = isContrΣ isContrUnit (λ _ → tt≡tt-एकम्)

बहु-द्विपदे : T.बहु (एकत्र Bool) tt
बहु-द्विपदे = (true , refl) , (false , refl) , λ p → true≢false (cong fst p)

------------------------------------------------------------------------
-- ४ · WHICH pair `isContr` merges.
--
-- §२ forces some pair to merge and does not say which; a verdict could in
-- principle merge अस्ति with नास्ति.  `isContr` merges the OUTER two — the
-- empty fibre and the subject — and keeps the middle one alone.  That is
-- the worst of the three possible collapses for this corpus's purposes,
-- because नष्टि and the subject are the two verdicts whose consequences are
-- opposite: one says stop, the other says compute.
--
-- Both halves matter and neither implies the other.  §२ is the forcing;
-- this is the position.
------------------------------------------------------------------------

न-एकम्-शून्ये : ¬ T.एकम् (एकत्र ⊥) tt
न-एकम्-शून्ये e = रिक्तम्-शून्ये (e .fst)

न-एकम्-द्विपदे : ¬ T.एकम् (एकत्र Bool) tt
न-एकम्-द्विपदे e = T.एक-बहु-विरोधः (एकत्र Bool) tt e बहु-द्विपदे

-- the merge, named: `¬ एकम्` says the same thing about ⊥ and about Bool,
-- and says the other thing about Unit.  Three types, two answers.
न-एकम्-लुम्पति :
    (¬ T.एकम् (एकत्र ⊥) tt)
  × (¬ T.एकम् (एकत्र Bool) tt)
  × T.एकम् (एकत्र Unit) tt
न-एकम्-लुम्पति = न-एकम्-शून्ये , न-एकम्-द्विपदे , एकम्-एकस्मिन्

------------------------------------------------------------------------
-- ५ · त्रिवर्गः — the escape.  Widen the codomain by one and it separates.
--
-- The Jaina prescription for a दुर्नय is never a sharper verdict; it is
-- another नय.  Here that is literal: the collapse in §२ is forced by the
-- codomain having two elements, and a codomain with three does not force
-- it.  Exhibited, with the three distinctions proved, so "three suffices"
-- is a term rather than an observation.
------------------------------------------------------------------------

data त्रिवर्ग : Type₀ where
  शून्यम् एकम्' बहुत् : त्रिवर्ग

private
  कोड : त्रिवर्ग → त्रिवर्ग → Type₀
  कोड शून्यम् शून्यम् = Unit
  कोड एकम्'  एकम्'  = Unit
  कोड बहुत्   बहुत्   = Unit
  कोड _      _      = ⊥

  कोड-refl : (x : त्रिवर्ग) → कोड x x
  कोड-refl शून्यम् = tt
  कोड-refl एकम्'  = tt
  कोड-refl बहुत्   = tt

  भेदः : (x y : त्रिवर्ग) → कोड x y → ¬ (x ≡ y) → ⊥
  भेदः x y c n = n (सिद्धिः x y c)
    where
    सिद्धिः : (x y : त्रिवर्ग) → कोड x y → x ≡ y
    सिद्धिः शून्यम् शून्यम् _ = refl
    सिद्धिः एकम्'  एकम्'  _ = refl
    सिद्धिः बहुत्   बहुत्   _ = refl

  न-कोड→न-पथः : (x y : त्रिवर्ग) → ¬ (कोड x y) → ¬ (x ≡ y)
  न-कोड→न-पथः x y nc p = nc (subst (कोड x) p (कोड-refl x))

-- The separation, stated of the CODOMAIN, which is where it belongs: no
-- decision procedure on arbitrary types is claimed or possible, and none is
-- needed.  §२ says the collapse is forced by द्विपद having two elements.
-- This says a three-element codomain does not force it.
त्रिवर्गो-विवेचयति :
    (¬ (शून्यम् ≡ एकम्')) × (¬ (शून्यम् ≡ बहुत्)) × (¬ (एकम्' ≡ बहुत्))
त्रिवर्गो-विवेचयति =
    न-कोड→न-पथः शून्यम् एकम्' (λ z → z)
  , न-कोड→न-पथः शून्यम् बहुत्  (λ z → z)
  , न-कोड→न-पथः एकम्'  बहुत्  (λ z → z)

-- the contrast with §२, as one statement: a three-element codomain admits
-- an injection FROM the three seeds, which is exactly what द्विपद refuses.
साक्षि-त्रिवर्गः : S.सप्तभङ्गी → त्रिवर्ग
साक्षि-त्रिवर्गः S.स्यात्-अस्ति      = एकम्'
साक्षि-त्रिवर्गः S.स्यात्-नास्ति     = बहुत्
साक्षि-त्रिवर्गः S.स्यात्-अवक्तव्यम् = शून्यम्
साक्षि-त्रिवर्गः _                   = एकम्'

त्रिवर्गे-न-मेलनम् :
    (¬ (साक्षि-त्रिवर्गः S.स्यात्-अस्ति ≡ साक्षि-त्रिवर्गः S.स्यात्-नास्ति))
  × (¬ (साक्षि-त्रिवर्गः S.स्यात्-अस्ति ≡ साक्षि-त्रिवर्गः S.स्यात्-अवक्तव्यम्))
  × (¬ (साक्षि-त्रिवर्गः S.स्यात्-नास्ति ≡ साक्षि-त्रिवर्गः S.स्यात्-अवक्तव्यम्))
त्रिवर्गे-न-मेलनम् =
    न-कोड→न-पथः एकम्' बहुत्   (λ z → z)
  , न-कोड→न-पथः एकम्' शून्यम् (λ z → z)
  , न-कोड→न-पथः बहुत्  शून्यम् (λ z → z)

------------------------------------------------------------------------
-- ६ · भङ्गाः संयुज्यन्ते — why the map-level question is sevenfold.
--
-- At a FIXED b the three verdicts are mutually exclusive (`Tantujala` §३).
-- Over a MAP they are not: a map carries a family of fibres and can be
-- एकम् at one point and रिक्तम् at another.  That is precisely how the
-- सप्तभङ्गी's seeds combine — क्रमेण, one standpoint after another, where
-- "standpoint" is a point of the codomain — and it is why the census of a
-- MAP has seven positions where the census of a FIBRE has three.
--
-- Occurrence predicates, then three positions realised by terms.
------------------------------------------------------------------------

module _ {A : Type ℓ} {B : Type ℓ'} (f : A → B) where

  अस्ति? : Type (ℓ-max ℓ ℓ')
  अस्ति? = Σ[ b ∈ B ] T.एकम् f b

  नास्ति? : Type (ℓ-max ℓ ℓ')
  नास्ति? = Σ[ b ∈ B ] T.बहु f b

  अवक्तव्य? : Type (ℓ-max ℓ ℓ')
  अवक्तव्य? = Σ[ b ∈ B ] T.रिक्तम् f b

-- स्यात्-अस्ति alone: the identity.  Every fibre एकम्, and by §५ of
-- Tantujala's विरोध lemmas neither of the other two can occur.
समता-मार्गः : Bool → Bool
समता-मार्गः b = b

समता-सर्वत्र-एकम् : (b : Bool) → T.एकम् समता-मार्गः b
समता-सर्वत्र-एकम् = isEquiv.equiv-proof (idIsEquiv Bool)

-- स्यात्-नास्ति-अवक्तव्यम्: one map, बहु at one point and रिक्तम् at another.
-- The two verdicts a two-valued census cannot tell apart, occurring in the
-- SAME map, at different points of its codomain.
मिश्र-मार्गः : Bool → Bool
मिश्र-मार्गः _ = true

मिश्र-बहु : T.बहु मिश्र-मार्गः true
मिश्र-बहु = (true , refl) , (false , refl) , λ p → true≢false (cong fst p)

मिश्र-रिक्तम् : T.रिक्तम् मिश्र-मार्गः false
मिश्र-रिक्तम् (_ , p) = true≢false p

मिश्रे-द्वे-पदे : नास्ति? मिश्र-मार्गः × अवक्तव्य? मिश्र-मार्गः
मिश्रे-द्वे-पदे = (true , मिश्र-बहु) , (false , मिश्र-रिक्तम्)

-- स्यात्-अस्ति-अवक्तव्यम्: एकम् at one point, रिक्तम् at another.
एक-रिक्त-मार्गः : Unit → Bool
एक-रिक्त-मार्गः _ = true

एक-रिक्त-एकम् : T.एकम् एक-रिक्त-मार्गः true
एक-रिक्त-एकम् =
  isContrΣ isContrUnit (λ _ → refl , λ p → isSetBool true true refl p)

एक-रिक्त-रिक्तम् : T.रिक्तम् एक-रिक्त-मार्गः false
एक-रिक्त-रिक्तम् (_ , p) = true≢false p

एक-रिक्ते-द्वे-पदे : अस्ति? एक-रिक्त-मार्गः × अवक्तव्य? एक-रिक्त-मार्गः
एक-रिक्ते-द्वे-पदे = (true , एक-रिक्त-एकम्) , (false , एक-रिक्त-रिक्तम्)

------------------------------------------------------------------------
-- ७ · समता एकं पदम् — `isEquiv` is one position of the seven.
--
-- `isEquiv f` is `एकम्` at every b at once (`Tantujala.सकलादेशः`), so it
-- forbids both other occurrences.  Hence `isEquiv` names exactly the
-- position स्यात्-अस्ति, and `¬ isEquiv f` is ONE BIT over the remaining
-- six.  By §२ that bit merges at least two of them; §६'s two compound maps
-- are witnesses that the merged positions are inhabited and distinct.
------------------------------------------------------------------------

समता→न-नास्ति : {A : Type ℓ} {B : Type ℓ'} (f : A → B)
              → isEquiv f → ¬ नास्ति? f
समता→न-नास्ति f e (b , m) = T.एक-बहु-विरोधः f b (isEquiv.equiv-proof e b) m

समता→न-अवक्तव्य : {A : Type ℓ} {B : Type ℓ'} (f : A → B)
                → isEquiv f → ¬ अवक्तव्य? f
समता→न-अवक्तव्य f e (b , r) = T.रिक्त-एक-विरोधः f b r (isEquiv.equiv-proof e b)

-- and the two failures `¬ isEquiv` cannot separate, both realised:
-- मिश्र-मार्गः fails by नास्ति AND अवक्तव्य; एक-रिक्त-मार्गः fails by अवक्तव्य
-- alone while still being एकम् where it is defined.  A one-bit verdict
-- reports the same thing about both.
द्वौ-भङ्गौ-एकं-वचनम् :
    (¬ isEquiv मिश्र-मार्गः) × (¬ isEquiv एक-रिक्त-मार्गः)
द्वौ-भङ्गौ-एकं-वचनम् =
    (λ e → समता→न-नास्ति मिश्र-मार्गः e (true , मिश्र-बहु))
  , (λ e → समता→न-अवक्तव्य एक-रिक्त-मार्गः e (false , एक-रिक्त-रिक्तम्))

------------------------------------------------------------------------
-- अलोपः ।  यत् त्रिविधं तत् द्विपदे न वर्तते ; नयं वर्धय, न निर्णयम् ।
-- (what is threefold does not fit in two positions; widen the standpoint,
--  not the verdict.)
------------------------------------------------------------------------
