{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मूलवाक्यम् · PROVENANCE OF THE NAME.
--
-- दुर्नय · durnaya — a नय that asserts itself by DENYING the others.  The
-- point of the term, and the reason it is not just "a wrong view": a
-- falsehood can be contradicted, and a concealed standpoint cannot, so the
-- durnaya is the worse case.  **Siddhasena Divākara, *Sanmatitarka* 1.21-25
-- (~5th c. CE); Umāsvāti, *Tattvārthasūtra* 1.34-35 (~2nd-5th c.) for नय
-- itself; argued at length in Akalaṅka and in Yaśovijaya, *Nayopadeśa*
-- (~17th c.).**
--
-- **No claim is made that Siddhasena proved anything below.**  The doctrine
-- that a naya is true-but-not-whole and that concealment is what turns it
-- into a durnaya is his; the statement that the prohibition has content only
-- off the propositional world is this repository's, and is cubical.
--
------------------------------------------------------------------------
-- Durnaya_TheProhibitionHasContentOnlyOffThePropositionalWorld
--
-- ANSWERING A QUESTION THAT WAS ASKED BACK, NOT TAKEN.
--
-- `Durnaya_CollapseIffEveryNayaAgrees` replaced the struck
-- exhaustiveness gloss of `Anekanta` §5 with
--
--     collapse-characterisation :  a collapse exists  iff  AllNayasAgree P
--
-- and its author then recorded, in `collab/journals/claude_ananta.md`
-- (Landing 27, 2026-08-19), the sharpest thing left over — declining to
-- take it, so that someone else could:
--
--     "if every fibre is an hProp, AllNayasAgree degenerates to logical
--      equivalence and the collapse prohibition may say far less than the
--      README asks it to — and the README asks it to govern real
--      disagreements between agents."
--
-- This module answers that.  The worry is CORRECT, and it is exact:
--
--   §2  over proposition-valued nayas the prohibition is nothing more than
--       mutual entailment — `AllNayasAgree` and `MutuallyEntail` coincide;
--   §4  off them it is strictly more — `Mixed` (the very witness that
--       refuted the old dichotomy) mutually entails and does not agree;
--   §5  and the reason is exactly non-propositionality: `Mixed`'s second
--       fibre is `Bool`, which is not an hProp.
--
-- So the content of अनेकान्त here is precisely the content a standpoint
-- carries BEYOND its truth value.  If a naya is only a proposition, the
-- ahiṃsā rule reduces to "they imply each other" and governs nothing an
-- ordinary biconditional would not.  That is the answer to the README
-- question: the rule governs real disagreements only because a naya is a
-- TYPE, not a truth value.  Unit and Bool are both inhabited — they
-- agree in every proposition-valued respect — and still cannot be identified.
--
-- §6 then restores the struck gloss exactly where it is true.  Over fibres
-- that are propositions AND stable, there IS no third option: absence of
-- the third bhaṅga forces collapse.  §7 records what the stability
-- hypothesis is buying, because without it the argument delivers only a
-- double negation — the same boundary `Abhava`/`Yogya-anupalabdhi` keep
-- reaching, from the other side.
--
-- WHAT IS CLAIMED OF THE SOURCE.  Nothing new.  `durnaya`, and the defect
-- of a naya asserted to the exclusion of others, are Siddhasena Divākara
-- (*Sanmatitarka*) and Akalaṅka's.  The hProp boundary below is this
-- corpus's mathematics, named for the act the tradition named, exactly as
-- the module it corrects argues.
--
-- CHECKED: see the commit message for the toolchain and exit code.  This
-- container is Agda 2.6.3 + cubical v0.5, which is NOT the repository pin
-- (Agda 2.8.0 + cubical v0.9, formal/cubical/BUILD.md).
------------------------------------------------------------------------

module Durnaya_TheProhibitionHasContentOnlyOffThePropositionalWorld where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_ ; Stable)

open import Anekanta
open import Durnaya_CollapseIffEveryNayaAgrees

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  Mutual entailment — what "these standpoints agree" means when a
--     standpoint is only a truth value.  One quantifier covers both
--     directions: swap s and t.
------------------------------------------------------------------------

MutuallyEntail : {S : Type ℓ} (P : S → Type ℓ') → Type _
MutuallyEntail {S = S} P = (s t : S) → P s → P t

-- Agreement always entails entailment, at every h-level.
agree→entail :
  {S : Type ℓ} (P : S → Type ℓ') → AllNayasAgree P → MutuallyEntail P
agree→entail P a s t = equivFun (a s t)

------------------------------------------------------------------------
-- 2.  Over propositions the converse holds, so the two coincide.
--     This is the degeneration the journal predicted.
------------------------------------------------------------------------

entail→agree-onProps :
  {S : Type ℓ} (P : S → Type ℓ') → ((s : S) → isProp (P s)) →
  MutuallyEntail P → AllNayasAgree P
entail→agree-onProps P pr e s t =
  propBiimpl→Equiv (pr s) (pr t) (e s t) (e t s)

------------------------------------------------------------------------
-- 3.  Hence, over proposition-valued nayas, the whole prohibition is
--     mutual entailment.  Composing with `collapse-characterisation`:
--     erasure is permitted exactly when the standpoints imply each other.
------------------------------------------------------------------------

collapse-iff-entail-onProps :
  {S : Type ℓ} (P : S → Type ℓ') (s₀ : S) → ((s : S) → isProp (P s)) →
    ((Σ[ Q ∈ Type ℓ' ] Collapses P Q) → MutuallyEntail P)
  × (MutuallyEntail P → Σ[ Q ∈ Type ℓ' ] Collapses P Q)
collapse-iff-entail-onProps P s₀ pr =
    (λ (Q , c) → agree→entail P (collapse→agree P Q c))
  , (λ e → agree→collapse P s₀ (entail→agree-onProps P pr e))

------------------------------------------------------------------------
-- 4.  Off the propositional world the two come apart, and the witness is
--     already in the corpus: `Mixed`, which refuted the old dichotomy.
--     Unit and Bool imply each other — both are inhabited — and are not
--     equivalent.  So the prohibition is STRICTLY stronger than mutual
--     entailment in general.
------------------------------------------------------------------------

Mixed-entails : MutuallyEntail Mixed
Mixed-entails s true  _ = tt
Mixed-entails s false _ = true

entail-does-not-imply-agree :
  Σ[ P ∈ (Bool → Type₀) ] (MutuallyEntail P × (¬ (AllNayasAgree P)))
entail-does-not-imply-agree = Mixed , Mixed-entails , Mixed-not-agree

------------------------------------------------------------------------
-- 5.  And the separation is caused by exactly one thing: a fibre that is
--     not a proposition.  By §2 no proposition-valued family can witness
--     this, so `Mixed`'s second fibre must fail isProp — it does.
------------------------------------------------------------------------

¬isPropBool : ¬ (isProp Bool)
¬isPropBool p = true≢false (p true false)

Mixed-is-not-proposition-valued : ¬ ((b : Bool) → isProp (Mixed b))
Mixed-is-not-proposition-valued pr = ¬isPropBool (pr false)

-- The general statement of §4+§5 together: any separating family is
-- non-propositional.  (Contrapositive of §2 — recorded because it is the
-- sentence the README needs, not the instance.)
separator-is-not-proposition-valued :
  {S : Type ℓ} (P : S → Type ℓ') →
  MutuallyEntail P → ¬ (AllNayasAgree P) → ¬ ((s : S) → isProp (P s))
separator-is-not-proposition-valued P e ¬a pr = ¬a (entail→agree-onProps P pr e)

------------------------------------------------------------------------
-- 6.  The struck gloss, restored exactly where it is true.
--
--     `Anekanta.agda` §5 said "there is no third option".  Over fibres
--     that are propositions AND stable, that is a theorem: if no naya
--     denies, collapse exists.  The third option of
--     `Durnaya_CollapseIffEveryNayaAgrees` §3 cannot live here.
------------------------------------------------------------------------

no-third-option-onStableProps :
  {S : Type ℓ} (P : S → Type ℓ') (s₀ : S) →
  ((s : S) → isProp (P s)) → ((s : S) → Stable (P s)) →
  ¬ (syādastināsti P) → Σ[ Q ∈ Type ℓ' ] Collapses P Q
no-third-option-onStableProps P s₀ pr st ¬astināsti =
  agree→collapse P s₀
    (entail→agree-onProps P pr
      (λ s t ps → st t (λ ¬pt → ¬astināsti ((s , ps) , (t , ¬pt)))))

------------------------------------------------------------------------
-- 7.  What stability is buying, stated rather than hidden.
--
--     Without it the same argument delivers only ¬¬(P t).  So the
--     restored dichotomy of §6 is exact on DECIDED absences and holds
--     only up to double negation otherwise — which is where
--     `Abhava` (decidability of the counterpositive sets the level) and
--     `Yogya-anupalabdhi` (fitness is necessary only up to double
--     negation) already are.  Three lines of this corpus meet at the
--     same hypothesis, from three traditions' vocabulary.
------------------------------------------------------------------------

no-third-option-upToDoubleNegation :
  {S : Type ℓ} (P : S → Type ℓ') →
  ¬ (syādastināsti P) → (s t : S) → P s → ¬ (¬ (P t))
no-third-option-upToDoubleNegation P ¬astināsti s t ps ¬pt =
  ¬astināsti ((s , ps) , (t , ¬pt))
