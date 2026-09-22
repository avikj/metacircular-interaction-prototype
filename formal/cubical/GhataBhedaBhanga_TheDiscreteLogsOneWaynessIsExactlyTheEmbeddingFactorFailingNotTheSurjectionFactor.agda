{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡ò‡æ‡-‡‡‡¶-‡‡ô‡‡ó ‚î WHICH factor of ‡‡Æ‡‡æ-‡¶‡‡µ‡ø‡ß‡æ the discrete log breaks.
--
-- `Sesa_TheOneWayFunction‚¶` proves the discrete log `powg` is a
-- NON-equivalence (`‡ò‡æ‡‡-‡®-‡‡‡≤‡‡Ø‡‡æ : ¬ isEquiv powg`), via
-- `GhataTantu.‡‡®‡‡‡‡-‡¶‡‡µ‡ø‡‡¶‡ : ¬ isContr (fiber powg ŒµC)`.
--
-- `SamataDvidha‚¶InTheTransportLane` splits being an equivalence, on the
-- nose, into TWO orthogonal factors: ‡‡‡¶‡ (embedding ‚î every residual a
-- prop) and ‡‡æ‡¶‡®‡Æ‡ (split surjection ‚î every residual inhabited).  So the
-- natural question the split poses, that ¬ isEquiv alone cannot answer:
-- WHICH factor does `powg` fail?
--
-- ANSWER, proved here.  `powg` fails the embedding factor, and it fails it
-- in the CROWDED way (‡®‡‡‡ü‡ø), NOT the empty way (‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡):
--
--   ‡ò‡æ‡-Œµ-‡µ‡‡‡ø   : ‡‡‡ powg ŒµC          -- the residual over Œµ is INHABITED
--                                          (‡‡‡®‡‡Ø‡: exponent 0 lands on Œµ), so
--                                          this is not the empty arm.
--   ‡ò‡æ‡-‡‡‡¶‡-‡‡ô‡‡ó‡ : ¬ (‡‡‡¶‡ powg)         -- and it is CROWDED ‚î ‡‡‡®‡‡Ø‡ and
--                                          ‡‡‡∞‡Ø‡ are two DISTINCT points over
--                                          the same Œµ ‚î so powg is not an
--                                          embedding.
--
-- So the ea univalence cannot erase (the crypto residual) is precisely a
-- ‡®‡‡‡ü‡ø failure of the FIRST factor of ‡‡Æ‡‡æ-‡¶‡‡µ‡ø‡ß‡æ: the discrete log MERGES
-- distinct exponents onto one power.  One-wayness is a merge, not a gap ‚î
-- the fibre is full, not empty; two points sit where an equivalence would
-- allow one.
--
-- The COMPLEMENT is now proved too (‡ò‡æ‡-‡‡æ‡¶‡®‡Æ‡): powg IS surjective onto C‚,
-- because powg reduces on the nose (powg 0 = e‚, powg 1 = g, powg 2 = g¬≤), so
-- it fails the embedding factor ALONE.
------------------------------------------------------------------------

module GhataBhedaBhanga_TheDiscreteLogsOneWaynessIsExactlyTheEmbeddingFactorFailingNotTheSurjectionFactor where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (znots)
open import Cubical.Data.Sigma using (fst ; _,_)
open import Cubical.Relation.Nullary using (¬¨_)

open import Cubical.Foundations.Equiv using (isEquiv ; equivFun)
open import SamataDvidha_TheContractibleFibreSplitsAsEmbeddingTimesSurjectionInTheTransportLane
  using (‡§≠‡•á‡§¶‡§É ; ‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç ; ‡§∏‡§Æ‡§§‡§æ‚âÉ‡§≠‡•á‡§¶√ó‡§õ‡§æ‡§¶‡§®)
open import NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual using (‡§∂‡•á‡§∑)
open import GhataTantu_TheDiscreteLogIsTheFibreOfPingalasPowerAndShorsPeriodQueryIsWhatReadsIt
  using (powg ; ŒµC ; ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É ; ‡§§‡•ç‡§∞‡§Ø‡§É)
open import BijamulaKrida_AConcreteKeypairRunsInACyclicGroupWhereTheModThatExhaustsTheHeapIsNotNeeded
  using (C‚ÇÉ ; e‚ÇÄ ; g ; g¬≤)

-- The residual over Œµ is INHABITED: exponent 0 lands on Œµ.  So this is not
-- the empty (‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡) arm.
‡§ò‡§æ‡§§-Œµ-‡§µ‡§∏‡§§‡§ø : ‡§∂‡•á‡§∑ powg ŒµC
‡§ò‡§æ‡§§-Œµ-‡§µ‡§∏‡§§‡§ø = ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É

-- The embedding factor FAILS, and CROWDED-ly: two distinct exponents (0 and
-- 3) sit over Œµ, so the residual there is not a proposition.
‡§ò‡§æ‡§§-‡§≠‡•á‡§¶‡§É-‡§≠‡§ô‡•ç‡§ó‡§É : ¬¨ (‡§≠‡•á‡§¶‡§É powg)
‡§ò‡§æ‡§§-‡§≠‡•á‡§¶‡§É-‡§≠‡§ô‡•ç‡§ó‡§É pr = znots (cong fst (pr ŒµC ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É ‡§§‡•ç‡§∞‡§Ø‡§É))

-- ‚¶and the SURJECTION factor HOLDS: every element of C‚ has a preimage,
-- because powg reduces on the nose ‚î powg 0 = e‚, powg 1 = g, powg 2 = g¬≤ ‚î
-- so `refl` witnesses each.
-- So powg fails the embedding factor ALONE.
‡§ò‡§æ‡§§-‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç : ‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç powg
‡§ò‡§æ‡§§-‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç e‚ÇÄ = 0 , refl
‡§ò‡§æ‡§§-‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç g  = 1 , refl
‡§ò‡§æ‡§§-‡§õ‡§æ‡§¶‡§®‡§Æ‡•ç g¬≤ = 2 , refl

-- THE ORGAN REGENERATES THE CRYPTO THEOREM.  Sesa proved ¬ isEquiv powg the
-- hard way (GhataTantu's non-contractible fibre).  ‡‡Æ‡‡æ-‡¶‡‡µ‡ø‡ß‡æ makes it a
-- mode: isEquiv powg ‚â (‡‡‡¶‡ powg ó ‡‡æ‡¶‡®‡Æ‡ powg), so an equivalence would
-- hand back ‡‡‡¶‡ powg ‚î which ‡ò‡æ‡-‡‡‡¶‡-‡‡ô‡‡ó‡ refutes.  No re-derivation; the
-- non-equivalence is the embedding-failure carried across the split.
‡§ò‡§æ‡§§-‡§®-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ-‡§ú‡§®‡§ø‡§§‡§Æ‡•ç : ¬¨ isEquiv powg
‡§ò‡§æ‡§§-‡§®-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ-‡§ú‡§®‡§ø‡§§‡§Æ‡•ç eq = ‡§ò‡§æ‡§§-‡§≠‡•á‡§¶‡§É-‡§≠‡§ô‡•ç‡§ó‡§É (fst (equivFun (‡§∏‡§Æ‡§§‡§æ‚âÉ‡§≠‡•á‡§¶√ó‡§õ‡§æ‡§¶‡§® powg) eq))
