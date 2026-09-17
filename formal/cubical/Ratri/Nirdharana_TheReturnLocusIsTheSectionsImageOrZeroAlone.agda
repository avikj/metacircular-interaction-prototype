{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à¨à¿àµààààà¿-à•àààààà°à®à â” the return locus.  Tonight's twelve queue
-- discharges were one theorem wearing five costumes.  This module
-- proves the theorem once, in general, and hangs the costumes on it.
--
-- Setting: a quotient q : A â’ B and a candidate return s : B â’ A.
-- The probes all asked "does s âˆ˜ q fix w?" â” ààà¨à°à¾à—à®à¨, pointwise.
--
-- THE LAW, two halves:
--
--   I.  If q âˆ˜ s â‰¡ id â” s is a true section, a zero-defect return â”
--       then the fixed points of s âˆ˜ q are EXACTLY the image of s:
--       the canonical representatives, Pigala's alphabet, the
--       residues that name themselves.  Return on the whole alphabet.
--
--   II. If instead the loop is positively priced â” the composite
--       multiplies by suc m â‰ 2, as hull's census does â” there is no
--       section, and the return locus collapses to zero alone
--       (proved in Nirdharana_Hull_PunaragamanaSunyeEva.noReturn).
--
-- Instances checked below: aksara/parity (alphabet {laghu, guru} â”
-- the retraction is definitional) and ones/sum (alphabet = the
-- all-ones words; sum âˆ˜ ones â‰¡ id by induction).  The hull instance
-- is the other half, priced, in its own module.  Together: an edge
-- returns on its zero-cost locus and nowhere else â” stra à§à stated
-- with both of its faces, as one two-line lemma each way.
------------------------------------------------------------------------

module Ratri.Nirdharana_TheReturnLocusIsTheSectionsImageOrZeroAlone where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•; zero; suc; _+_)
open import Cubical.Data.List using (List; []; _âˆ·_)
open import Cubical.Data.Sigma using (Î£; _,_; fst; snd)

private
  variable
    â„“ â„“' : Level
    A : Type â„“
    B : Type â„“'

------------------------------------------------------------------------
-- I Â the general law, both inclusions, four lines total.

module Return (q : A â†’ B) (s : B â†’ A) (sect : (b : B) â†’ q (s b) â‰¡ b) where

  -- every canonical representative returns â¦
  image-returns : (b : B) â†’ s (q (s b)) â‰¡ s b
  image-returns b = cong s (sect b)

  -- â¦ and everything that returns is canonical (trivially: it is s of
  -- its own summary).  So fix (s âˆ˜ q) = im s, on the nose.
  returns-are-image : (w : A) â†’ s (q w) â‰¡ w â†’ Î£ B (Î» b â†’ s b â‰¡ w)
  returns-are-image w p = q w , p

------------------------------------------------------------------------
-- II Â instance: Pigala.  parity âˆ˜ aksara â‰¡ id definitionally, so the
-- return locus of aksara âˆ˜ parity is the syllable alphabet â” the same
-- fact Nirdharana_PingalaPrastara_â¦ proved from the â• side.

open import PingalaPrastara using (Syllable; laghu; guru; aksara; parity)

parity-sections-aksara : (u : Syllable) â†’ parity (aksara u) â‰¡ u
parity-sections-aksara laghu = refl
parity-sections-aksara guru  = refl

module PingalaReturn = Return parity aksara parity-sections-aksara

------------------------------------------------------------------------
-- III Â instance: the swarm's summary.  sum âˆ˜ ones â‰¡ id by induction,
-- so the return locus of ones âˆ˜ sum is exactly the all-ones words â”
-- which is why [2] could not return (Anirdharita_S13OptionSpread_â¦).

open import Swarm.S13OptionSpread using (sum; ones)

sum-sections-ones : (n : â„•) â†’ sum (ones n) â‰¡ n
sum-sections-ones zero    = refl
sum-sections-ones (suc n) = cong suc (sum-sections-ones n)

module SwarmReturn = Return sum ones sum-sections-ones

-- The alphabet, exhibited: every n returns as its all-ones word.
allOnesReturn : (n : â„•) â†’ ones (sum (ones n)) â‰¡ ones n
allOnesReturn = SwarmReturn.image-returns
