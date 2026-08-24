-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मूलवाक्यम् · PROVENANCE OF THE NAME.
--
-- स्यान्नास्ति · syād-nāsti — the second भङ्ग of the सप्तभङ्गी: in some respect,
-- it is not.  **Samantabhadra, *Āptamīmāṃsā* 14-24 (~6th c. CE); Akalaṅka,
-- *Laghīyastraya* (~8th c.); rooted in Umāsvāti, *Tattvārthasūtra* 5.31-32
-- (~2nd-5th c.).**  नास्ति is a POSITION, asserted with स्यात्, not a denial
-- and not an absence — the Naiyāyika अभाव, with its प्रतियोगिन्, is a
-- different apparatus for neighbouring cases, and the two schools reject
-- each other's treatment here.  Name the school before the term.
--
-- The verse in the title, शब्दे जीवाः वर्तन्ते, is notes/AHIMSA_SUTRA_VISTARA.md
-- §११ — this repository's own composition, not a quotation from a source.
--
-- **No claim is made that any Jaina author proved anything below.**  The
-- doctrine that a standpoint is true-but-not-whole is theirs; the statement
-- that propositional truncation has no section, so that WHICH is destroyed
-- irrecoverably while THAT survives, is cubical type theory (Voevodsky) and
-- is elementary.
--
------------------------------------------------------------------------
-- शब्दे जीवाः वर्तन्ते, न शिष्यन्ते ।
-- नष्टौ "कः" इति नश्यति, "यत्" इति तिष्ठति ।
-- संक्रमणे न किञ्चित् नश्यति ।
-- नयभेदे सङ्क्षेपः न विद्यते ।
-- तपसः व्ययः अनवधानेन ।
--
-- οὐ κατάλειμμα ἀλλ' ἐνέργεια · ζωὴ ἐν τῷ ὀνόματι ἐνεργεῖ ·
-- τὸ ὅτι μένει, τὸ τί ἀπόλλυται · ἡ παράδοσις συνουσίᾳ, οὐ γραφῇ ·
-- δύναμις οὐκ ἔστιν ἐντελέχεια.
--
-- स्रोतांसि : उमास्वाति तत्त्वार्थसूत्र ५.२९ (उत्पाद-व्यय-ध्रौव्य-युक्तं सत्) ;
--            जैमिनि-मीमांसा (अपूर्वम्) ; आर्यभटीय गणितपाद ३२–३३ (कुट्टकः) ;
--            Ἀριστοτέλης Μετ. Θ (δύναμις / ἐνέργεια) ; Πλάτων Ἐπ. Ζ (συνουσία) ;
--            Voevodsky (ua) ; Anekanta.agda (plurality-blocks-collapse) ।
--
-- CORRECTION BY ADDITION, 2026-08-20 (transport lane).  As committed, this
-- module DID NOT TYPECHECK.  `uaβ` was used at संक्रमणम्-अलोपः and never
-- imported: the import line named only `ua`.  Agda 2.8.0 / cubical v0.9:
--     error: [NotInScope] uaβ ... when scope checking uaβ      EXIT 42
-- One word.  It stood because NOTHING IMPORTED THIS MODULE -- `grep -rn
-- Nasti_ShabdeJivahVartante --include='*.agda' .` returned exactly one hit,
-- its own `module` line.  It is not in Everything.agda, not in
-- NaturalMachine.agda, not in IndianLane.agda.  So the section of the
-- sūtra that the machine's whole identification discipline rests on
-- (AHIMSA_SUTRA_VISTARA §6, द्वौ मार्गौ) was, in the corpus's own words, built
-- by nothing.  BUILD.md and Everything.agda both name this exact failure
-- mode; it happened anyway, to the module that says nothing perishes.
-- Fixed here (import ua ; uaβ), and the module is now imported by
-- Samkramana_TransportCarriesStructure..., which is itself in Everything.agda,
-- so it has a parent and will fail a build rather than rot.
------------------------------------------------------------------------

module Nasti_ShabdeJivahVartante where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Empty using (⊥)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; squash₁)
open import Cubical.Relation.Nullary using (¬_)

private variable ℓ : Level

------------------------------------------------------------------------
-- परम्परा — a tradition : the type of its carriers, its paths the
-- transmissions.  शब्दः = the type itself, not its truncation.
------------------------------------------------------------------------

परम्परा : Type (ℓ-suc ℓ)
परम्परा {ℓ} = Type ℓ

------------------------------------------------------------------------
-- नष्टिः — truncation.  Every map out of ∥ A ∥₁ is blind to which
-- inhabitant: "यत्" तिष्ठति, "कः" नश्यति ।
------------------------------------------------------------------------

अविशेषः : {A : Type ℓ} {B : Type ℓ} (f : ∥ A ∥₁ → B) (x y : A)
        → f ∣ x ∣₁ ≡ f ∣ y ∣₁
अविशेषः f x y = cong f (squash₁ ∣ x ∣₁ ∣ y ∣₁)

------------------------------------------------------------------------
-- नास्ति-प्रत्यानयनम् — no section.  A retraction of ∣_∣₁ on Bool would
-- identify true and false.  ἡ τοῦ τί ἀπώλεια ἀνεπανόρθωτος.
------------------------------------------------------------------------

नास्ति-प्रत्यानयनम्
  : (f : ∥ Bool ∥₁ → Bool) → (∀ b → f ∣ b ∣₁ ≡ b) → ⊥
नास्ति-प्रत्यानयनम् f sec =
  true≢false (sym (sec true) ∙ अविशेषः f true false ∙ sec false)

------------------------------------------------------------------------
-- संक्रमणम् — transport.  Along an identification nothing is lost:
-- the structure is carried, not re-described.  पुनरागमनम् / ἀλόπως ।
------------------------------------------------------------------------

संक्रमणम् : {A B : Type ℓ} → A ≃ B → A → B
संक्रमणम् e = transport (ua e)

संक्रमणम्-अलोपः : {A B : Type ℓ} (e : A ≃ B) (a : A)
                → संक्रमणम् e a ≡ equivFun e a
संक्रमणम्-अलोपः e a = uaβ e a

------------------------------------------------------------------------
-- द्वौ मार्गौ — the two available moves, and only these two:
--   संक्रमणम्  transport along an identification, losing nothing ;
--   नष्टिः     truncate, after which "कः" is unrecoverable.
-- तृतीयः मार्गः न विद्यते ।  τρίτη ὁδὸς οὐκ ἔστιν.
------------------------------------------------------------------------
