{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àµààà°à¾ààà¯à¾àà â” the cross product of two consecutive turns is 1, and from that
-- alone the next turn's admissible multipliers are EXACTLY the class of âˆ’m.
--
-- SOURCE AND DATE.  àµààà°à¾ààà¯à¾à ("thunderbolt multiplication") is BHSKARA II's
-- own word for the crosswise product of two pairs; à²àà²à¾àµàà and àààà—àà¿àà®à, 1150
-- CE.  The àà•àà°àµà¾à²à®à is JAYADEVA's, ~950, surviving through Udayadivkara's
-- ààà¨àà¦à°à, 1073.  The à•ààŸààŸà• that the previous account of this step reached for
-- is RYABHAA's, àà°àà¯ààŸàà¯à®à à—àà¿ààà¾à¦à à©à¨â“à©à©, 499.  Nothing below claims any of
-- them stated the theorem in this file; what is claimed is that the quantity
-- this file turns on is the crosswise product they named, taken between a
-- turn of the wheel and its successor.  ààà°ààà¯à¾àµààààà¿à is this repository's
-- label, introduced by
-- `GunakaKsepa_TheWheelsStateIsBoundedAndSelfPropagating`, not a source term.
--
-- Â§4 names two things standing between the state box and determinism.  The
-- first, verbatim:
--
--     "The solution set must BE the class of âˆ’m.  ààà°ààà¯à¾àµààààà¿à gives that âˆ’m
--      is *a* solution.  That the solutions are exactly âˆ’m mod k' needs
--      gcd(b', k') = 1 â” the same coprimality
--      CakravalaDescent.oneCongruenceCoprime already consumes, and which
--      CakravalaDescent.runToCoprime produces from an actual kuaka run
--      rather than assuming.  Wiring that here is mechanical and is not
--      done."
--
-- It is closed here, and NOT by wiring in a kuaka run.  The run is not
-- needed: gcd(b', k') = 1 is a CONSEQUENCE of the step's own three exact
-- divisions, with both B©zout coefficients written out of a, b, a', b'.  So
-- the file is shorter than the wiring it replaces, and it removes a
-- dependency instead of adding one.
--
-- THE MECHANISM, in one line each.
--
--   àµààà°à¾ààà¯à¾àà  kÂ(aÂb' âˆ’ bÂa') = aÂ(kÂb') âˆ’ bÂ(kÂa') = a(a+bm) âˆ’ b(am+Db)
--              = aÂ² âˆ’ DÂbÂ² = k = kÂ1, and k cancels.  So consecutive turns
--              of the wheel have crosswise product exactly 1 â” an equality,
--              not a divisibility, and it needs no choice rule, no
--              minimality, no ordering.
--
--   àà-ààà°àà®àà¾   (aÂb' âˆ’ bÂa')Â² = 1 expands, with k' = a'Â² âˆ’ DÂb'Â² substituted
--              for a'Â², into
--                  (bÂb)Âk' + vÂb' â‰¡ 1,   v = aÂ²b' + DÂbÂ²Âb' âˆ’ 2ÂaÂbÂa',
--              in which the D-terms cancel identically.  That IS the B©zout
--              pair for (k', b').  No pulverizer, no gcd, no primality.
--
--   ààà°ààà      with that pair, `CakravalaDescent.coprimeCancel` turns
--              ààà°ààà¯à¾àµààààà¿à â” that âˆ’m solves the next congruence â” into the
--              two-way statement:
--                  k' âˆ (a' + b'Âm')   âŸº   k' âˆ (m + m').
--              The admissible multipliers of the next turn are exactly the
--              residue class of âˆ’m modulo k'.
--
-- WHAT THAT BUYS, EXACTLY.  The next turn's CLASS is a function of (m, k')
-- alone, and |k'| = |mÂ² âˆ’ D| / |k| is a function of (m, |k|, D).  So the
-- whole of the next state is determined by the current one AS SOON AS the
-- minimisation over that class picks a unique member.
--
-- WHAT IT DOES NOT BUY, and this is not a hedge â” it is a checked negative.
-- The minimisation does NOT always pick a unique member.
-- `Dvaidha_TheVaranaTiesExactlyWhenDIsASumOfTwoSquares` exhibits the tie, in
-- the kernel, at D = 58 turn 1 â” on a class that IS the âˆ’m mod k' this file
-- proves â” and characterises exactly when a tie can occur.  So after this
-- file the gap between the state box and determinism is one thing and not
-- two, that thing is not a missing lemma but a genuine branch in the rule,
-- and it has an instance.
--
-- WHAT IS PROVED.  --safe, no postulates, no holes, Agda 2.8.0 + cubical v0.9.
-- Stated over â rather than an arbitrary CommRing only because the ring
-- solver wants a concrete ring; nothing below uses more than commutativity
-- and the cancellation hypothesis that `CakravalaDescent.cakravalaStep`
-- already takes.
------------------------------------------------------------------------

module VajraAbhyasa_TheCrossProductIsOneAndTheNextClassIsExactlyMinusM where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing using (CommRingStr)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

open import Bhavana using (module Form)
open import CakravalaDescent using (module Descent)
open import GunakaKsepa_TheWheelsStateIsBoundedAndSelfPropagating
  using (à¤ªà¥à¤°à¤¤à¥à¤¯à¤¾à¤µà¥ƒà¤¤à¥à¤¤à¤¿à¤ƒ)

open CommRingStr (snd â„¤CommRing) using (_Â·_ ; _+_ ; _-_ ; -_ ; 1r ; Â·IdR)
open Form â„¤CommRing using (N)
open Descent â„¤CommRing using (_âˆ£_ ; Coprime ; coprimeCancel ; cakravalaStep)

------------------------------------------------------------------------
-- à§ Â àµààà°à¾ààà¯à¾àà â” THE CROSS PRODUCT OF TWO CONSECUTIVE TURNS IS ONE.
--
-- Given aÂ² âˆ’ DÂbÂ² = k and the two exact divisions kÂa' = aÂm + DÂb,
-- kÂb' = a + bÂm, the crosswise product aÂb' âˆ’ bÂa' is exactly 1.
--
-- Note what is NOT used: k' does not appear, the choice rule does not
-- appear, and no ordering or minimality is involved.  This is a fact about
-- Brahmagupta's composition with the trivial triple (m, 1, mÂ² âˆ’ D) and
-- nothing else â” the composite pair and the pair it came from are a
-- unimodular pair, always.
------------------------------------------------------------------------

à¤µà¤œà¥à¤°à¤¾à¤­à¥à¤¯à¤¾à¤¸à¤ƒ : (D a b m k a' b' : â„¤)
           â†’ ((x y : â„¤) â†’ k Â· x â‰¡ k Â· y â†’ x â‰¡ y)   -- k cancels
           â†’ N D a b â‰¡ k
           â†’ a Â· m + D Â· b â‰¡ k Â· a'
           â†’ a + b Â· m     â‰¡ k Â· b'
           â†’ a Â· b' - b Â· a' â‰¡ 1r
à¤µà¤œà¥à¤°à¤¾à¤­à¥à¤¯à¤¾à¤¸à¤ƒ D a b m k a' b' cancel nab ea eb =
  cancel (a Â· b' - b Â· a') 1r
    ( à¤µà¤¿à¤­à¤¾à¤—à¤ƒ
    âˆ™ congâ‚‚ _-_ (cong (a Â·_) (sym eb)) (cong (b Â·_) (sym ea))
    âˆ™ à¤¸à¤¾à¤°à¤ƒ
    âˆ™ nab
    âˆ™ sym (Â·IdR k) )
  where
  à¤µà¤¿à¤­à¤¾à¤—à¤ƒ : k Â· (a Â· b' - b Â· a') â‰¡ a Â· (k Â· b') - b Â· (k Â· a')
  à¤µà¤¿à¤­à¤¾à¤—à¤ƒ = solve! â„¤CommRing

  -- aÂ(a + bÂm) âˆ’ bÂ(aÂm + DÂb)  â‰¡  aÂa âˆ’ DÂ(bÂb),  which IS `N D a b`.
  à¤¸à¤¾à¤°à¤ƒ : a Â· (a + b Â· m) - b Â· (a Â· m + D Â· b) â‰¡ a Â· a - D Â· (b Â· b)
  à¤¸à¤¾à¤°à¤ƒ = solve! â„¤CommRing

------------------------------------------------------------------------
-- à¨ Â àà-ààà°àà®àà¾ â” THE NEXT PAIR'S COPRIMALITY, WITH BOTH COEFFICIENTS
-- WRITTEN OUT.
--
-- `Coprime` in `CakravalaDescent` is deliberately not "no common factor" â”
-- it is the two B©zout coefficients themselves, because that is what the
-- cancellation can compute with.  Here they are:
--
--     u = bÂb        v = aÂ²Âb' + DÂbÂ²Âb' âˆ’ 2ÂaÂbÂa'
--
-- and uÂk' + vÂb' â‰¡ 1 is the square of Â§1 with k' = a'Â² âˆ’ DÂb'Â² substituted
-- back in; the two D-terms cancel identically, which is why D does not have
-- to be anything in particular.
--
-- THIS IS WHERE THE KUAKA STOPS BEING NEEDED.  The previous account said
-- gcd(b', k') = 1 had to come from an actual pulverizer run on (b', k').  It
-- does not: the wheel's own previous coordinates are the certificate.
------------------------------------------------------------------------

à¤¸à¤¹-à¤ªà¥à¤°à¤¥à¤®à¤¤à¤¾ : (D a b a' b' k' : â„¤)
          â†’ a Â· b' - b Â· a' â‰¡ 1r
          â†’ N D a' b' â‰¡ k'
          â†’ Coprime k' b'
à¤¸à¤¹-à¤ªà¥à¤°à¤¥à¤®à¤¤à¤¾ D a b a' b' k' hvaj nab' = b Â· b , v , path
  where
  v : â„¤
  v = ((a Â· a) Â· b' + (D Â· (b Â· b)) Â· b') - ((a Â· b) Â· a' + (a Â· b) Â· a')

  -- the whole content, as one ring identity: with a'Â² âˆ’ DÂb'Â² in place of
  -- k', the left side IS (aÂb' âˆ’ bÂa')Â².
  à¤¤à¤¾à¤¦à¤¾à¤¤à¥à¤®à¥à¤¯à¤®à¥ : (b Â· b) Â· (a' Â· a' - D Â· (b' Â· b')) + v Â· b'
             â‰¡ (a Â· b' - b Â· a') Â· (a Â· b' - b Â· a')
  à¤¤à¤¾à¤¦à¤¾à¤¤à¥à¤®à¥à¤¯à¤®à¥ = solve! â„¤CommRing

  path : (b Â· b) Â· k' + v Â· b' â‰¡ 1r
  path = cong (Î» w â†’ (b Â· b) Â· w + v Â· b') (sym nab')
       âˆ™ à¤¤à¤¾à¤¦à¤¾à¤¤à¥à¤®à¥à¤¯à¤®à¥
       âˆ™ congâ‚‚ _Â·_ hvaj hvaj
       âˆ™ Â·IdR 1r

------------------------------------------------------------------------
-- à© Â ààà°ààà â” THE CLASS, BOTH WAYS.
--
-- Â§3a is free: if m' â‰¡ âˆ’m then m' solves the congruence, because âˆ’m does
-- (ààà°ààà¯à¾àµààààà¿à) and the difference is b'Â(m + m').
--
-- Â§3b is the direction that needs Â§2: from k' âˆ b'Â(m + m') and the B©zout
-- pair, k' âˆ (m + m').  Without Â§2 the class could a priori be larger â” the
-- solutions could be a class modulo a proper divisor of k' â” and then the
-- next multiplier would not be a function of the state even with ties ruled
-- out.
------------------------------------------------------------------------

à¤¶à¥à¤°à¥‡à¤£à¥€-à¤ªà¥à¤°à¤µà¥‡à¤¶à¤ƒ : (b' k' m m' a' b : â„¤)
             â†’ a' + b' Â· (- m) â‰¡ k' Â· (- b)
             â†’ k' âˆ£ (m + m')
             â†’ k' âˆ£ (a' + b' Â· m')
à¤¶à¥à¤°à¥‡à¤£à¥€-à¤ªà¥à¤°à¤µà¥‡à¤¶à¤ƒ b' k' m m' a' b hr (t , ht) =
  ((- b) + b' Â· t)
  , ( à¤ªà¥ƒà¤¥à¤•à¥à¤•à¤°à¤£à¤®à¥
    âˆ™ congâ‚‚ _+_ hr (cong (b' Â·_) ht)
    âˆ™ à¤¸à¤‚à¤¯à¥‹à¤—à¤ƒ )
  where
  à¤ªà¥ƒà¤¥à¤•à¥à¤•à¤°à¤£à¤®à¥ : a' + b' Â· m' â‰¡ (a' + b' Â· (- m)) + b' Â· (m + m')
  à¤ªà¥ƒà¤¥à¤•à¥à¤•à¤°à¤£à¤®à¥ = solve! â„¤CommRing

  à¤¸à¤‚à¤¯à¥‹à¤—à¤ƒ : k' Â· (- b) + b' Â· (k' Â· t) â‰¡ k' Â· ((- b) + b' Â· t)
  à¤¸à¤‚à¤¯à¥‹à¤—à¤ƒ = solve! â„¤CommRing

à¤¶à¥à¤°à¥‡à¤£à¥€-à¤¨à¤¿à¤°à¥à¤—à¤®à¤ƒ : (b' k' m m' a' b : â„¤)
             â†’ Coprime k' b'
             â†’ a' + b' Â· (- m) â‰¡ k' Â· (- b)
             â†’ k' âˆ£ (a' + b' Â· m')
             â†’ k' âˆ£ (m + m')
à¤¶à¥à¤°à¥‡à¤£à¥€-à¤¨à¤¿à¤°à¥à¤—à¤®à¤ƒ b' k' m m' a' b cop hr (c , hc) =
  coprimeCancel k' b' (m + m') cop
    ( (c + b)
    , ( à¤ªà¥ƒà¤¥à¤•à¥à¤•à¤°à¤£à¤®à¥
      âˆ™ congâ‚‚ _-_ hc hr
      âˆ™ à¤¸à¤‚à¤¯à¥‹à¤—à¤ƒ ) )
  where
  à¤ªà¥ƒà¤¥à¤•à¥à¤•à¤°à¤£à¤®à¥ : b' Â· (m + m') â‰¡ (a' + b' Â· m') - (a' + b' Â· (- m))
  à¤ªà¥ƒà¤¥à¤•à¥à¤•à¤°à¤£à¤®à¥ = solve! â„¤CommRing

  à¤¸à¤‚à¤¯à¥‹à¤—à¤ƒ : k' Â· c - k' Â· (- b) â‰¡ k' Â· (c + b)
  à¤¸à¤‚à¤¯à¥‹à¤—à¤ƒ = solve! â„¤CommRing

------------------------------------------------------------------------
-- à Â ààà°ààà-à¨à¿à°ààà¯à â” THE JOIN.
--
-- One theorem, taking exactly the hypotheses the algorithm's own situation
-- supplies â” the norm, the three exact divisions, and cancellation by k â”
-- and returning: the next turn's admissible multipliers are EXACTLY the
-- residue class of âˆ’m modulo k'.
--
-- that item is closed, and the à•ààŸààŸà• it asked for is not used.
------------------------------------------------------------------------

à¤¶à¥à¤°à¥‡à¤£à¥€-à¤¨à¤¿à¤°à¥à¤£à¤¯à¤ƒ : (D a b m k a' b' k' : â„¤)
            â†’ ((x y : â„¤) â†’ k Â· x â‰¡ k Â· y â†’ x â‰¡ y)   -- k cancels
            â†’ N D a b â‰¡ k
            â†’ a Â· m + D Â· b â‰¡ k Â· a'
            â†’ a + b Â· m     â‰¡ k Â· b'
            â†’ m Â· m - D     â‰¡ k Â· k'
            â†’ (m' : â„¤)
            â†’ (k' âˆ£ (m + m') â†’ k' âˆ£ (a' + b' Â· m'))
            Ã— (k' âˆ£ (a' + b' Â· m') â†’ k' âˆ£ (m + m'))
à¤¶à¥à¤°à¥‡à¤£à¥€-à¤¨à¤¿à¤°à¥à¤£à¤¯à¤ƒ D a b m k a' b' k' cancel nab ea eb ek m' =
    à¤¶à¥à¤°à¥‡à¤£à¥€-à¤ªà¥à¤°à¤µà¥‡à¤¶à¤ƒ b' k' m m' a' b hr
  , à¤¶à¥à¤°à¥‡à¤£à¥€-à¤¨à¤¿à¤°à¥à¤—à¤®à¤ƒ b' k' m m' a' b cop hr
  where
  hr : a' + b' Â· (- m) â‰¡ k' Â· (- b)
  hr = à¤ªà¥à¤°à¤¤à¥à¤¯à¤¾à¤µà¥ƒà¤¤à¥à¤¤à¤¿à¤ƒ D a b m k a' b' k' cancel ea eb ek

  nab' : N D a' b' â‰¡ k'
  nab' = cakravalaStep D a b m k a' b' k' cancel nab ea eb ek

  cop : Coprime k' b'
  cop = à¤¸à¤¹-à¤ªà¥à¤°à¤¥à¤®à¤¤à¤¾ D a b a' b' k'
          (à¤µà¤œà¥à¤°à¤¾à¤­à¥à¤¯à¤¾à¤¸à¤ƒ D a b m k a' b' cancel nab ea eb) nab'

------------------------------------------------------------------------
-- à Â ààà°à¯à‹à¦àà®à â” D = 13, BHSKARA'S OWN WORKED EXAMPLE, IN THE KERNEL.
--
-- The same turn `CakravalaDescent.StepAtThirteen` certifies: from the
-- trivial triple 3Â² âˆ’ 13Â1Â² = âˆ’4 with m = 1,
--
--     a' = (3Â1 + 13Â1)/(âˆ’4) = âˆ’4     b' = (3 + 1Â1)/(âˆ’4) = âˆ’1
--     k' = (1 âˆ’ 13)/(âˆ’4) = 3
--
-- and then, computed rather than asserted:
--
--   àµààà°à¾ààà¯à¾àà-à§à©   3Â(âˆ’1) âˆ’ 1Â(âˆ’4) = 1                       (Â§1)
--   àà-ààà°àà®àà¾-à§à©    1Â3 + 2Â(âˆ’1) = 1, i.e. u = bÂ² = 1, v = 2  (Â§2)
--   ààà°ààà-à§à©        the next multiplier the reactor takes is 2, and
--                   3 âˆ (1 + 2) â” it is in the class of âˆ’m, as Â§4 forces.
--
-- (Cubical's â product is unary, so these are stated at turn 0 where the
-- numbers are one digit.  `CakravalaNat.agda` records the same constraint
-- and the same reason.)
------------------------------------------------------------------------

module à¤¤à¥à¤°à¤¯à¥‹à¤¦à¤¶à¤®à¥ where

  à¤µà¤œà¥à¤°à¤¾à¤­à¥à¤¯à¤¾à¤¸à¤ƒ-à¥§à¥© : pos 3 Â· negsuc 0 - pos 1 Â· negsuc 3 â‰¡ pos 1
  à¤µà¤œà¥à¤°à¤¾à¤­à¥à¤¯à¤¾à¤¸à¤ƒ-à¥§à¥© = refl

  -- u = bÂb = 1 and v = aÂ²b' + DÂbÂ²Âb' âˆ’ 2ÂaÂbÂa' = âˆ’9 âˆ’ 13 + 24 = 2.
  à¤¸à¤¹-à¤ªà¥à¤°à¤¥à¤®à¤¤à¤¾-à¥§à¥© : pos 1 Â· pos 3 + pos 2 Â· negsuc 0 â‰¡ pos 1
  à¤¸à¤¹-à¤ªà¥à¤°à¤¥à¤®à¤¤à¤¾-à¥§à¥© = refl

  -- the class of âˆ’m mod k' at this turn is {m' : 3 âˆ (1 + m')}, and the
  -- reactor's next multiplier is 2.
  à¤¶à¥à¤°à¥‡à¤£à¥€-à¥§à¥© : pos 1 + pos 2 â‰¡ pos 3 Â· pos 1
  à¤¶à¥à¤°à¥‡à¤£à¥€-à¥§à¥© = refl

  -- and it does satisfy the congruence the next turn actually poses,
  -- a' + b'Âm' = âˆ’4 + (âˆ’1)Â2 = âˆ’6 = 3Â(âˆ’2).
  à¤¸à¤™à¥à¤—à¤¤à¤¿à¤ƒ-à¥§à¥© : negsuc 3 + negsuc 0 Â· pos 2 â‰¡ pos 3 Â· negsuc 1
  à¤¸à¤™à¥à¤—à¤¤à¤¿à¤ƒ-à¥§à¥© = refl
