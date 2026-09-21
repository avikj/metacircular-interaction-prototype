{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡¶‡ã‡Æ‡‡¶‡‡∞‡æ ‚î ‡‡®‡‡¶‡ã ‡Æ‡æ‡‡‡∞‡æ‡Æ‡æ‡®‡‡‡Ø ‡‡®‡‡‡‡ ‡‡µ ‡
--
-- (a metre is nothing but the fibre of the mtr-count.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- HOW THIS WAS FOUND, because the method is the point.
--
-- `machine/Lopa_‚¶hs` grades every irreversible edge in this corpus and
-- reports 1045 of them UNDECIDED ‚î no syntactic rule names a fibre.
-- Three of those undecided edges are
--
--     PingalaPrastara.Pattern ‚ü ‚ï    ¬ matraOf
--     PingalaPrastara.Pattern ‚ü ‚ï    ¬ varna
--     PingalaPrastara.Pattern ‚ü ‚ï    ¬ guruOf
--
-- and their fibres are DEFINED FIFTEEN LINES BELOW THEM, in the same
-- file, by name.  `PingalaPrastara.agda:55` says so in prose: *"`Vak n`,
-- `Metre n` and `Chosen n k` are its fibres over ‚¶"*.  No term said it,
-- so the census could not see it, so it reported the corpus barren at
-- exactly the place the corpus had already answered.
--
-- That is this repository's oldest failure mode arriving in its newest
-- instrument, and it is the same one that let a European name stand over
-- an Indian result for four centuries: **an instrument that cannot see
-- reports that nothing is there.**  The repair is not a better census.
-- It is to LOOK UP the answer before proposing to construct one.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED.  Nothing is constructed; all three are `refl`.
--
--   `fiber f b` unfolds to `Œ[ a ] (f a ‚â° b)`, and
--   `Metre n`  is  `Œ[ p ‚àà Pattern ] (matraOf p ‚â° n)`.
--
-- They are the same type on the nose.  Writing it down costs one line
-- and turns a prose remark into something a machine can join on.
--
-- ¬ß‡© is the one that is not definitional and is the more interesting:
-- `Chosen n k` is the JOINT fibre of two observables at once, and it
-- equals `fiber ‚ü® varna , guruOf ‚ü© (n , k)` only after Œ-reassociation,
-- because a pair of equations is not an equation of pairs until you say
-- so.  That gap is exactly where a joint measurement differs from two
-- separate ones.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- AND THE PRICE HAS A CLOSED FORM ALREADY PROVED IN THE HOST.
--
-- `PingalaPrastara.matrameruIso : Metre (2+n) ‚â Metre (1+n) ‚ä Metre n`.
-- So the fibre of the mtr-count satisfies VIRAHKA'S RECURRENCE ‚î the
-- ‡Æ‡æ‡‡‡∞‡æ‡Æ‡‡∞‡ ‚î and the receipt for that cut is not a bound or an estimate
-- but a named type whose cardinality is a sequence the tradition
-- tabulated.  Virahka, *Vttajtisamuccaya*, c. 600‚ì800 CE (the range
-- is H. D. Velankar's, from his 1962 edition).  The
-- recurrence is usually cited under Fibonacci's name, 1202, which is a
-- restatement and is named here after the source and as one.
--
-- The array whose row sums these are is Pigala's, ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡
-- ‡Æ.‡©‡‚ì‡©‡, ~300 BCE, with the construction rule ‚î ‡‡ó‡‡∞‡ø‡Æ-‡‡ô‡‡ï‡‡‡ø‡
-- ‡‡‡∞‡‡µ-‡‡ô‡‡ï‡‡‡‡ ‡‡æ‡∞‡‡‡‡µ-‡Ø‡ã‡ó‡à‡, the next row from the ADJACENT SUMS of the
-- previous ‚î stated by ‡‡≤‡æ‡Ø‡‡ß in the ‡Æ‡‡‡‡û‡‡‡‡µ‡®‡, 10th c.
------------------------------------------------------------------------

module Chandomudra_ThePratyayasFibresWereWrittenInProseAndTheCensusCalledThemUndecided where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Sigma

open import PingalaPrastara
  using (Pattern ; matraOf ; varna ; guruOf ; Metre ; Vak ; Chosen)

------------------------------------------------------------------------
-- ‡ß ¬ ‡Æ‡æ‡‡‡∞‡æ‡µ‡‡‡‡‡Æ‡ ‚î a metre IS the fibre of the mtr-count.
------------------------------------------------------------------------

‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§§‡§®‡•ç‡§§‡•Å‡§É : (n : ‚Ñï) ‚Üí fiber matraOf n ‚â° Metre n
‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§§‡§®‡•ç‡§§‡•Å‡§É n = refl

------------------------------------------------------------------------
-- ‡® ¬ ‡µ‡∞‡‡‡µ‡‡‡‡‡Æ‡ ‚î and a syllable-metre is the fibre of the syllable count.
------------------------------------------------------------------------

‡§µ‡§∞‡•ç‡§£-‡§§‡§®‡•ç‡§§‡•Å‡§É : (n : ‚Ñï) ‚Üí fiber varna n ‚â° Vak n
‡§µ‡§∞‡•ç‡§£-‡§§‡§®‡•ç‡§§‡•Å‡§É n = refl

------------------------------------------------------------------------
-- ‡© ¬ The joint fibre, which is NOT definitional.
--
-- `Chosen n k = Œ[ p ] ((varna p ‚â° n) ó (guruOf p ‚â° k))` ‚î a PAIR OF
-- EQUATIONS.  The fibre of the paired map is `Œ[ p ] ((varna p , guruOf p)
-- ‚â° (n , k))` ‚î an EQUATION OF PAIRS.  Those agree only through
-- `ŒPathP`/`ŒPath‚â`, and the passage is exactly the content: measuring
-- two observables jointly is not the same act as measuring each.
------------------------------------------------------------------------

‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Æ‡§æ‡§®‡§Æ‡•ç : Pattern ‚Üí ‚Ñï √ó ‚Ñï
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Æ‡§æ‡§®‡§Æ‡•ç p = varna p , guruOf p

‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§§‡§®‡•ç‡§§‡•Å‡§É : (n k : ‚Ñï) ‚Üí fiber ‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§Æ‡§æ‡§®‡§Æ‡•ç (n , k) ‚âÉ Chosen n k
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§§‡§®‡•ç‡§§‡•Å‡§É n k =
  Œ£-cong-equiv-snd (Œª p ‚Üí invEquiv Œ£Path‚âÉPathŒ£)

