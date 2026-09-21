{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ ‚î ‡‡‡-‡®‡ø‡Ø‡Æ‡ ‡‡®‡‡‡‡, ‡‡∞‡‡‡æ‡‡ ‡‡‡∞‡‡Æ‡ ‡‡‡û‡æ‡‡ ‡¶‡‡µ‡ø‡‡‡Ø‡‡‡Ø ‡Æ‡‡≤‡‡Ø‡Æ‡ ‡
--
-- (the fiber over a PARTIAL specification: what the second count still
-- costs once the first is known.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ SOURCE OF THE TERM, with text and date.
--
--   The ‡‡‡∞‡‡‡Ø‡Ø of Pigala, *Chandastra*, ch. 8 (~300 BCE) are listed
--   in the commentarial tradition as six: ‡‡‡∞‡‡‡‡æ‡∞ (lay the forms out),
--   ‡®‡‡‡ü (index ‚í form), ‡â‡¶‡‡¶‡ø‡‡‡ü (form ‚í index), ‡‡ô‡‡ñ‡‡Ø‡æ (how many),
--   ‡‡ß‡‡µ‡Ø‡ã‡ó (the space the table occupies), and ‚î the one this module is
--   about ‚î **‡‡ï‡¶‡‡µ‡‡Ø‡æ‡¶‡ø-‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ**, "the operation for [the forms
--   having] one, two, and so on ‡≤‡ó", ‡≤‡ó being the ‡radition's word for
--   the heavy syllable (‡ó‡‡∞‡).  It is the count of the forms carrying a
--   GIVEN NUMBER of gurus, and it is answered by the ‡Æ‡‡∞‡‡‡‡∞‡‡‡‡æ‡∞ of
--   ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ‡Æ.‡©‡‚ì‡©‡, whose construction rule ‚î ‡‡ó‡‡∞‡ø‡Æ-‡‡ô‡‡ï‡‡‡ø‡
--   ‡‡‡∞‡‡µ-‡‡ô‡‡ï‡‡‡‡ ‡‡æ‡∞‡‡‡‡µ-‡Ø‡ã‡ó‡à‡, the next row from the adjacent sums of the
--   previous ‚î is stated by ‡‡≤‡æ‡Ø‡‡ß, *‡Æ‡‡‡‡û‡‡‡‡µ‡®‡*, 10th c. CE.
--
--   ‡Æ.‡©‡‚ì‡©‡ is cited for the ARRAY, which is what is used
--   below; the name is the commentarial tradition's name for the fourth
--   pratyaya and is used here in that sense.
--
--   The later European statement of the array is Pascal, *Trait© du
--   triangle arithm©tique*, 1654 ‚î a restatement, named after the source
--   and as one, and never transliterated into Devanagari, which would
--   be worse than the Latin.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED, for `f : A ‚í B` and `g : A ‚í C`.
--
--   ¬ß‡ß  ‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ  fiber ‚ü®f,g‚ü© (b , c) ‚â fiber (g ‚àò fst) c, where the
--       `fst` is off `fiber f b`.  THE JOINT FIBER IS THE FIBER OF g
--       RESTRICTED TO THE FIBER OF f ‚î the conditional receipt: once f
--       is known to be b, what g still costs is one fiber, taken inside
--       the answer f already gave.
--
--       The passage is not definitional and the gap is the content: a
--       PAIR OF EQUATIONS is not an EQUATION OF PAIRS.  They meet only
--       through `ŒPath‚âPathŒ`, and measuring two observables jointly is
--       not the act of measuring each.
--
--   ¬ß‡®  ‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ-‡µ‡ø‡‡æ‡ó‡  fiber f b ‚â Œ[ c ‚àà C ] fiber ‚ü®f,g‚ü© (b , c).
--       The fiber of f partitions over the values of g.  This is the
--       sum rule ‚î the total is the sum of the conditionals ‚î and it is
--       an equivalence of types, with no finiteness anywhere.
--
--   ¬ß‡©  ‡Æ‡‡ï‡‡-‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ  if f's fiber at b is contractible, the joint
--       fiber collapses to a single path `g a‚ ‚â° c`.  When f is already
--       an answer (‡®‡‡‡ü‡ã‡¶‡‡¶‡ø‡‡‡ü-‡‡∞‡‡ï‡‡‡æ ¬ß‡: ‡‡ï‡Æ‡ at b), g costs nothing
--       beyond identifying its value.
--
--   ¬ß‡  ‡‡ø‡ô‡‡ó‡≤‡  Vak n ‚â Œ[ k ‚àà ‚ï ] Chosen n k.  Pigala's own case:
--       the syllable-metre decomposes over the guru-count.  ¬ß‡®
--       instantiated at (‡µ‡∞‡‡, ‡ó‡‡∞‡), joined to
--       `Chandomudra_‚¶.‡Ø‡‡ó‡‡Æ-‡‡®‡‡‡‡` which prices the joint fiber.
--
--   ¬ß‡  ‡‡ô‡‡ï‡‡‡ø-‡Ø‡ã‡ó‡  ‡Ø‡ã‡ó‡‡≤ (‡‡ô‡‡ï‡‡‡ø n) ‚â° count n.  The same statement
--       at the level of NUMBERS: the n-th row of the ‡Æ‡‡∞‡‡‡‡∞‡‡‡‡æ‡∞ sums to
--       the ‡‡ô‡‡ñ‡‡Ø‡æ 2‚ø, proved from ‡‡≤‡æ‡Ø‡‡ß's adjacent-sums rule as it is
--       written in `NastaUddista_‚¶.‡‡ô‡‡ï‡‡‡ø` ‚î one row held in memory, no
--       triangle stored.
--
--   ¬ß‡  ‡≤‡ó-‡ó‡‡®‡æ  Œ[ k ‚àà ‚ï ] Chosen n k ‚â Fin (‡Ø‡ã‡ó‡‡≤ (‡‡ô‡‡ï‡‡‡ø n)).  ¬ß‡ and
--       ¬ß‡ joined, by way of Pigala's OWN ‡®‡‡‡ü/‡â‡¶‡‡¶‡ø‡‡‡ü count
--       (`PingalaPrastara.uddistaIso`).  Summing the ‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ over every
--       guru-count returns the ‡‡ô‡‡ñ‡‡Ø‡æ, and no summand is ever examined.
--
-- RELATION TO WHAT IS ALREADY HERE.  `Residue_‚¶.‡‡‡` gives the COMPOSITION
-- half ‚î fiber (g ‚àò f) z ‚â Œ[ p ‚àà fiber g z ] fiber f (fst p) ‚î for two
-- maps run in series.  ¬ß‡ß is the PAIRING half, for two maps run on the
-- same source.  They are different fibrations of a fibration and neither
-- follows from the other; ¬ß‡ß's hypothesis is a common domain, ¬ß‡‡‡'s is
-- a shared middle.
--
------------------------------------------------------------------------

module Lagakriya_TheConditionalFiberIsWhatTheSecondCountStillCostsOnceTheFirstIsKnown where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (fiber ; _‚âÉ_ ; invEquiv ; compEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Sigma
  using ( Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd
        ; Œ£Path‚âÉPathŒ£ ; Œ£-assoc-‚âÉ
        ; Œ£-cong-equiv-snd ; Œ£-contractFst ; Œ£-contractSnd )
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Tactics.NatSolver.Reflection using (solve‚Ñï!)

open import PingalaPrastara
  using (Pattern ; varna ; guruOf ; Vak ; Chosen ; count ; uddistaIso)
open import NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn
  using (‡§®‡§Ø‡§® ; ‡§Ø‡•Å‡§ó‡•ç‡§Æ ; ‡§Ö‡§ó‡•ç‡§∞‡§ø‡§Æ ; ‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø)
import Chandomudra_ThePratyayasFibersWereWrittenInProseAndTheCensusCalledThemUndecided as CM

private
  variable
    ‚Ñì ‚Ñì' ‚Ñì'' ‚Ñì''' : Level

-- A swap of two independent Œ-bases, needed below and not in the library
-- in this generality (`Cubical.Data.Sigma.Œ-swap-‚â` is the plain product
-- only, and here the last family depends on BOTH bases).  Both round
-- trips are `refl`.
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-Iso : {D : Type ‚Ñì} {E : Type ‚Ñì'} {F : D ‚Üí E ‚Üí Type ‚Ñì''}
            ‚Üí Iso (Œ£[ d ‚àà D ] Œ£[ e ‚àà E ] F d e)
                  (Œ£[ e ‚àà E ] Œ£[ d ‚àà D ] F d e)
Iso.fun      ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-Iso (d , e , x) = (e , d , x)
Iso.inv      ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-Iso (e , d , x) = (d , e , x)
Iso.rightInv ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-Iso _ = refl
Iso.leftInv  ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-Iso _ = refl

------------------------------------------------------------------------
-- ‡ß ¬ THE CONDITIONAL RECEIPT.
--
-- Two observables on one source.  The JOINT specification names both;
-- the PARTIAL specification names only the first, and what remains to be
-- paid is a fiber taken INSIDE the first answer.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} {B : Type ‚Ñì'} {C : Type ‚Ñì''} (f : A ‚Üí B) (g : A ‚Üí C) where

  -- ‚ü®f,g‚ü© ‚î the joint measurement, made in one act.
  ‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Æ‡§æ‡§™‡§É : A ‚Üí B √ó C
  ‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Æ‡§æ‡§™‡§É a = f a , g a

  -- the conditional fiber: g read off the fiber of f, at the value c.
  ‡§∏‡§æ‡§™‡•á‡§ï‡•ç‡§∑-‡§§‡§®‡•ç‡§§‡•Å‡§É : B ‚Üí C ‚Üí Type (‚Ñì-max (‚Ñì-max ‚Ñì ‚Ñì') ‚Ñì'')
  ‡§∏‡§æ‡§™‡•á‡§ï‡•ç‡§∑-‡§§‡§®‡•ç‡§§‡•Å‡§É b c = fiber (Œª (x : fiber f b) ‚Üí g (fst x)) c

  -- ¬ß‡ß  the joint fiber IS the conditional fiber.
  --
  -- Left to right the two coordinates of the pair-equation are split
  -- (`ŒPath‚âPathŒ`, and this is the step that is not definitional);
  -- then the Œ is reassociated so that "the part f already answered"
  -- becomes the base and "what g still costs" becomes the fiber.
  ‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ : (b : B) (c : C)
           ‚Üí fiber ‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Æ‡§æ‡§™‡§É (b , c) ‚âÉ ‡§∏‡§æ‡§™‡•á‡§ï‡•ç‡§∑-‡§§‡§®‡•ç‡§§‡•Å‡§É b c
  ‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ b c =
    compEquiv (Œ£-cong-equiv-snd (Œª _ ‚Üí invEquiv Œ£Path‚âÉPathŒ£))
              (invEquiv Œ£-assoc-‚âÉ)

  -- ¬ß‡®  the sum rule.  The fiber of f is the sum, over the values of g,
  -- of the joint fibers.  Nothing is lost by refining a specification:
  -- the refinements reassemble to exactly what was there.
  ‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ-‡§µ‡§ø‡§≠‡§æ‡§ó‡§É : (b : B)
                  ‚Üí fiber f b ‚âÉ (Œ£[ c ‚àà C ] fiber ‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Æ‡§æ‡§™‡§É (b , c))
  ‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ-‡§µ‡§ø‡§≠‡§æ‡§ó‡§É b =
    invEquiv
      (compEquiv (Œ£-cong-equiv-snd (Œª c ‚Üí ‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ b c))
      (compEquiv (isoToEquiv ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-Iso)
                 (Œ£-contractSnd (Œª x ‚Üí isContrSingl (g (fst x))))))

  -- ¬ß‡©  when the first answer is already ‡‡ï‡Æ‡, the conditional receipt
  -- is a single path and nothing more.
  ‡§Æ‡•Å‡§ï‡•ç‡§§-‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ : (b : B) (h : isContr (fiber f b)) (c : C)
                ‚Üí fiber ‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Æ‡§æ‡§™‡§É (b , c) ‚âÉ (g (fst (h .fst)) ‚â° c)
  ‡§Æ‡•Å‡§ï‡•ç‡§§-‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ b h c = compEquiv (‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ b c) (Œ£-contractFst h)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡ø‡ô‡‡ó‡≤‡ ‚î the instance the pratyaya was stated for.
--
-- f = ‡µ‡∞‡‡ (syllable count), g = ‡ó‡‡∞‡ (heavy-syllable count).  ¬ß‡® says
-- the ‡µ‡∞‡‡‡µ‡‡‡‡ of n syllables decomposes over the guru-count, and
-- `Chandomudra_‚¶.‡Ø‡‡ó‡‡Æ-‡‡®‡‡‡‡` says each joint fiber is `Chosen n k`,
-- which is what the ‡Æ‡‡∞‡‡‡‡∞‡‡‡‡æ‡∞ tabulates.
--
-- `fiber varna n` and `Vak n` are the same type on the nose, so no step
-- is spent on that (‡‡®‡‡¶‡ã‡Æ‡‡¶‡‡∞‡æ ¬ß‡®).
------------------------------------------------------------------------

‡§≤‡§ó-‡§µ‡§ø‡§≠‡§æ‡§ó‡§É : (n : ‚Ñï) ‚Üí Vak n ‚âÉ (Œ£[ k ‚àà ‚Ñï ] Chosen n k)
‡§≤‡§ó-‡§µ‡§ø‡§≠‡§æ‡§ó‡§É n =
  compEquiv (‡§≤‡§ó‡§ï‡•ç‡§∞‡§ø‡§Ø‡§æ-‡§µ‡§ø‡§≠‡§æ‡§ó‡§É varna guruOf n)
            (Œ£-cong-equiv-snd (Œª k ‚Üí CM.‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§§‡§®‡•ç‡§§‡•Å‡§É n k))

------------------------------------------------------------------------
-- ‡ ¬ THE SAME STATEMENT AT THE LEVEL OF NUMBERS.
--
-- ¬ß‡ is an equivalence of types and stops there: passing to a count
-- needs a finiteness ¬ß‡ does not assume, and `Œ[ k ‚àà ‚ï ]` ranges over
-- all of ‚ï with all but finitely many summands empty.  The numerical
-- form is proved separately, from ‡‡≤‡æ‡Ø‡‡ß's rule as it is actually
-- written in `NastaUddista_‚¶.‡‡ô‡‡ï‡‡‡ø` ‚î one row generated from the
-- previous by adjacent sums, one row held, no triangle stored.
------------------------------------------------------------------------

‡§Ø‡•ã‡§ó‡§´‡§≤ : List ‚Ñï ‚Üí ‚Ñï
‡§Ø‡•ã‡§ó‡§´‡§≤ []       = 0
‡§Ø‡•ã‡§ó‡§´‡§≤ (x ‚à∑ xs) = x + ‡§Ø‡•ã‡§ó‡§´‡§≤ xs

-- two pure rearrangements in the semiring, so the induction below shows
-- only its own step.
‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‚ÇÅ : (x a t : ‚Ñï) ‚Üí x + ((a + x) + t) ‚â° (x + x) + (a + t)
‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‚ÇÅ x a t = solve‚Ñï!

‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‚ÇÇ : (x s : ‚Ñï) ‚Üí (x + x) + (s + s) ‚â° (x + s) + (x + s)
‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‚ÇÇ x s = solve‚Ñï!

-- the adjacent-sum row doubles the total, less its own head ‚î stated
-- without subtraction, which ‚ï does not have.
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Ø‡•ã‡§ó‡§É : (xs : List ‚Ñï)
           ‚Üí ‡§®‡§Ø‡§® xs 0 + ‡§Ø‡•ã‡§ó‡§´‡§≤ (‡§Ø‡•Å‡§ó‡•ç‡§Æ xs) ‚â° ‡§Ø‡•ã‡§ó‡§´‡§≤ xs + ‡§Ø‡•ã‡§ó‡§´‡§≤ xs
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Ø‡•ã‡§ó‡§É []       = refl
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Ø‡•ã‡§ó‡§É (x ‚à∑ xs) =
    ‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‚ÇÅ x (‡§®‡§Ø‡§® xs 0) (‡§Ø‡•ã‡§ó‡§´‡§≤ (‡§Ø‡•Å‡§ó‡•ç‡§Æ xs))
  ‚àô cong ((x + x) +_) (‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Ø‡•ã‡§ó‡§É xs)
  ‚àô ‡§µ‡§ø‡§®‡•ç‡§Ø‡§æ‡§∏‚ÇÇ x (‡§Ø‡•ã‡§ó‡§´‡§≤ xs)

-- every row of the ‡Æ‡‡∞‡ begins with 1 ‚î by the construction, not by a
-- separate argument.
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç : (n : ‚Ñï) ‚Üí ‡§®‡§Ø‡§® (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n) 0 ‚â° 1
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç zero    = refl
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç (suc n) = refl

-- THE THEOREM.  The n-th row of the ‡Æ‡‡∞‡‡‡‡∞‡‡‡‡æ‡∞ sums to Pigala's
-- ‡‡ô‡‡ñ‡‡Ø‡æ.  Read backwards: summing the ‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ over every possible
-- guru-count returns the whole ‡‡‡∞‡‡‡‡æ‡∞, so the conditional receipts
-- account for the total exactly.
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Ø‡•ã‡§ó‡§É : (n : ‚Ñï) ‚Üí ‡§Ø‡•ã‡§ó‡§´‡§≤ (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n) ‚â° count n
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Ø‡•ã‡§ó‡§É zero    = refl
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Ø‡•ã‡§ó‡§É (suc n) =
    cong (_+ ‡§Ø‡•ã‡§ó‡§´‡§≤ (‡§Ø‡•Å‡§ó‡•ç‡§Æ (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n))) (sym (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Æ‡•Å‡§ñ‡§Æ‡•ç n))
  ‚àô ‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Ø‡•ã‡§ó‡§É (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n)
  ‚àô cong‚ÇÇ _+_ (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Ø‡•ã‡§ó‡§É n) (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Ø‡•ã‡§ó‡§É n)

------------------------------------------------------------------------
-- ‡ ¬ ¬ß‡ AND ¬ß‡ JOINED BY A TERM, not by a paragraph.
--
-- The route runs the other way round: ¬ß‡ says the
-- sum of the conditional fibers IS the ‡µ‡∞‡‡‡µ‡‡‡‡, and Pigala's own
-- ‡®‡‡‡ü/‡â‡¶‡‡¶‡ø‡‡‡ü pair already counts THAT (`PingalaPrastara.uddistaIso`,
-- Vak n ‚â Fin (count n)).  ¬ß‡ then rewrites the count as the row sum.
--
-- So: the ‡‡ô‡‡ñ‡‡Ø‡æ is recovered by summing the ‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ over every guru
-- count, as an equivalence, with no summand ever examined.
------------------------------------------------------------------------

‡§≤‡§ó-‡§ó‡§£‡§®‡§æ : (n : ‚Ñï) ‚Üí (Œ£[ k ‚àà ‚Ñï ] Chosen n k) ‚âÉ Fin (‡§Ø‡•ã‡§ó‡§´‡§≤ (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n))
‡§≤‡§ó-‡§ó‡§£‡§®‡§æ n =
  compEquiv (invEquiv (‡§≤‡§ó-‡§µ‡§ø‡§≠‡§æ‡§ó‡§É n))
  (compEquiv (isoToEquiv (uddistaIso n))
             (pathToEquiv (cong Fin (sym (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡§Ø‡•ã‡§ó‡§É n)))))

------------------------------------------------------------------------
-- ‡ ¬ ‡â‡¶‡æ‡‡∞‡‡æ‡®‡ø ‚î ‡ï‡∞‡‡‡‡® ‡ó‡‡ø‡‡æ‡®‡ø (refl), ‡® ‡Æ‡æ‡‡ø‡‡æ‡®‡ø ‡
------------------------------------------------------------------------

-- ‡‡≤‡æ‡Ø‡‡ß‡‡‡Ø ‡‡‡‡∞‡‡‡ ‡‡ô‡‡ï‡‡‡ø‡ : 1 4 6 4 1, ‡Ø‡ã‡ó‡ ‡ß‡ = ‡®‚¥ ‡
_ : ‡§Ø‡•ã‡§ó‡§´‡§≤ (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø 4) ‚â° 16
_ = refl

_ : ‡§Ø‡•ã‡§ó‡§´‡§≤ (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø 4) ‚â° count 4
_ = refl

-- ‡¶‡‡Æ‡ ‡‡ô‡‡ï‡‡‡ø‡ : ‡ß‡¶‡®‡ ‡
_ : ‡§Ø‡•ã‡§ó‡§´‡§≤ (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø 10) ‚â° 1024
_ = refl

-- ‡‡ï‡æ ‡≤‡ó‡ï‡‡∞‡ø‡Ø‡æ : ‡‡‡‡∞‡ï‡‡‡∞‡ ‡¶‡‡µ‡ø-‡ó‡‡∞‡‡‡ø ‡‡ü‡ ‡∞‡‡‡æ‡‡ø ‡
_ : ‡§®‡§Ø‡§® (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø 4) 2 ‚â° 6
_ = refl

