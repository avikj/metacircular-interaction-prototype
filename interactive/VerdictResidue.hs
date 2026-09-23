-- ResidueStream -- the seven positions, carrying
-- the standpoints that produced them, and the birth that takes the fourth
-- position on to the next derivation.
--
-- WHAT IT REPLACES.  `interactive/Verdict.hs` gives the
-- seven as seven nullary constructors and a presence-profile in {Aam, Na}^3.
-- Its `saha` is a function on those labels, and its own comment says:
--
--     "NOTE WHAT THIS DESTROYS -- after the collapse the fourth position
--      does not record which two seeds produced it, and that is not a
--      modelling artefact but the doctrine's claim."
--
-- The first half was true of that type.  The second half is withdrawn.
-- Avaktavyam is the failure of ONE UTTERANCE to carry the joint content
-- (Mallisena, Syadvadamanjari 1292: wholedesa demanded of a
-- partialdesa-shaped medium), and a failure of expression is not a loss of
-- what was to be expressed.  Here the fourth position carries a Residue
-- holding both nayas and both their witnesses, and `caturthatTritiya`
-- recovers the third position from it exactly.
--
-- AND THE PRICE.  `order commutative` in that module is FALSE here, and
-- that is checked below.  Two nayas affirming the same claim by different
-- terms are two nayas; succession keeps the first speaker's witness
-- (prathamarpana).  Commutativity was a law of the erasure.
--
-- SETTLED 2026-08-20, and it costs this module a law it did not know it
-- was making.  Both this header and the label module's named ONE open
-- question: is the forgetful map records -> labels a homomorphism for
-- order, for saha, or for neither?  It is one for BOTH (`anarpana` below,
-- 49 + 49 exhaustive pairs here, proved for every standpoint family in
-- formal/cubical/Arpitanarpita_TheForgetfulMapIsAHomomorphismForBothArpanasAndTheLabelsAreARetractNotAnEquivalence.agda);
-- it has a section which is one for both; and it has NO inverse.  So the
-- label lane is a RETRACT of this one -- a subalgebra and a quotient at
-- once, not a rival account and not an independent object -- and no
-- equivalence between them exists.  AHIMSA_SUTRA_VISTARA section 7,
-- literally: the collapse does not exist, so searching for one is
-- fruitless.
--
-- THE COST.  Distinctness lifts along a homomorphism, so the label lane's
-- broken law breaks here: `saha` is NOT associative on these records
-- either, with both nayas and both witnesses retained and
-- `caturthatTritiya` in force throughout.  Retention does not buy the law
-- back.  That refutes the label module's explanation of its own failure
-- (that the collapse destroys the seeds) -- the failure survives the
-- retention -- and it equally means this module's withdrawal above is
-- NOT supported by the non-associativity.  Neither lane may read that
-- algebraic fact as evidence about the doctrine, in either direction.
-- The Mallisena question stays open, and is now known to be untouchable
-- by the composition laws: the two lanes agree across it.
--
-- EVERY LAW BELOW IS PROVED, NOT MEASURED, in
-- formal/cubical/NaturalMachine/SaptabhangiKernel_ThePositionsCarryTheirNayasAndTheResidueSeedsTheNext.agda
-- (--cubical --safe, exit 0, no postulates, no holes).  The Agda term name
-- is given with each entry of `selfTest`; the tests here are exhaustive
-- finite re-verification, which CLAUDE.md counts as proof, not sampling.
--
-- SOURCES, EARLIEST FIRST.  The classification is theirs; the algebra is not
-- claimed to be in any of them.
--   Bhagavati Sutra (Viyaha-pannatti), fifth Anga; oldest strata
--     pre-Common-Era, redacted at Valabhi c. 5th c. CE.
--   Umasvati, Tattvarthasutra, c. 2nd-5th c. CE:
--     5.29 utpada-vyaya-dhrauvya-yuktam sat -- the three held AT ONCE;
--     5.31 arpitanarpita-siddheh -- the ASSERTED and UNASSERTED aspect.
--          `prasava` below is 5.31 as an operation and nothing else.
--   Siddhasena Divakara, Sanmatitarka 1.21, c. 5th c. CE -- durnaya.
--   Samantabhadra, Aptamimamsa, c. 6th c. CE -- the fixed seven.
--   Akalanka, Laghiyastraya / Astasati, c. 720-780 CE -- order against
--     saha/yugapat.  That distinction is the whole content of the two
--     composition operators.
--   Mallisena, Syadvadamanjari, 1292 CE -- wholedesa against partialdesa.
--

module VerdictResidue
  ( Arpana(..), Naya(..), Residue(..), Bhanga(..)
  , nayaAdhisthana, stara, viveka
  , astyamsa, nastyamsa, residuemsa
  , adhiAsti, adhiNasti, adhiResidue
  , order, saha, yugapat
  , caturthatTritiya, prasava, kernel, kernelDhara
  , renderBhanga, renderNaya
  , anarpana
  , selfTest
  ) where

import Data.List (intercalate)
import Data.Maybe (isNothing)
import qualified Verdict as L

-- ------------------------------------------------------------------ 1 naya

-- The aspect under which a standpoint is taken.  Not a decoration: the
-- born family reads a naya's affirmation under Arpita and its denial under
-- Anarpita, which is what Tattvarthasutra 5.31 distinguishes.
data Arpana = Arpita | Anarpita deriving (Eq, Show)

-- A standpoint: its base name, the stack of aspects births have put on it,
-- and the TERM by which it spoke.  A naya without its witness is a label,
-- and a label is what this module exists to stop returning.
data Naya = Naya
  { nayaMula   :: String     -- the base standpoint, invariant under birth
  , nayaArpana :: [Arpana]   -- aspects, innermost last; length = level
  , nayaSaksin :: String     -- the accepting line, refuting term, or counterexample
  } deriving (Eq, Show)

nayaAdhisthana :: Naya -> String
nayaAdhisthana n = intercalate " / " (nayaMula n : map show (nayaArpana n))

-- How many births deep this standpoint is.  0 = spoke at the root.
stara :: Naya -> Int
stara = length . nayaArpana

-- The residue an avaktavyam retains: both nayas, both witnesses.
data Residue = Residue { residueSadhaka :: Naya, residueBadhaka :: Naya } deriving (Eq, Show)

-- In the Agda this is a THEOREM (`vivekah`): if the two standpoints were
-- one, its own proof would refute it.  Haskell's type cannot derive it, so
-- here it is a check, named for the theorem it stands in for.  A Residue that
-- fails it was built by hand and not by `saha`.
viveka :: Residue -> Bool
viveka s = nayaAdhisthana (residueSadhaka s) /= nayaAdhisthana (residueBadhaka s)

-- ------------------------------------------------------------- 2 the seven

data Bhanga
  = SyadAsti                 Naya            -- syad asti
  | SyanNasti                Naya            -- syan nasti
  | SyadAstiNasti            Naya Naya       -- order of the two
  | SyadAvaktavyam           Residue            -- saha of the two: the residue
  | SyadAstiAvaktavyam       Naya Residue
  | SyanNastiAvaktavyam      Naya Residue
  | SyadAstiNastiAvaktavyam  Naya Naya Residue
  deriving (Eq, Show)

astyamsa :: Bhanga -> Maybe Naya
astyamsa (SyadAsti a)                    = Just a
astyamsa (SyanNasti _)                   = Nothing
astyamsa (SyadAstiNasti a _)             = Just a
astyamsa (SyadAvaktavyam _)              = Nothing
astyamsa (SyadAstiAvaktavyam a _)        = Just a
astyamsa (SyanNastiAvaktavyam _ _)       = Nothing
astyamsa (SyadAstiNastiAvaktavyam a _ _) = Just a

nastyamsa :: Bhanga -> Maybe Naya
nastyamsa (SyadAsti _)                    = Nothing
nastyamsa (SyanNasti n)                   = Just n
nastyamsa (SyadAstiNasti _ n)             = Just n
nastyamsa (SyadAvaktavyam _)              = Nothing
nastyamsa (SyadAstiAvaktavyam _ _)        = Nothing
nastyamsa (SyanNastiAvaktavyam n _)       = Just n
nastyamsa (SyadAstiNastiAvaktavyam _ n _) = Just n

residuemsa :: Bhanga -> Maybe Residue
residuemsa (SyadAsti _)                    = Nothing
residuemsa (SyanNasti _)                   = Nothing
residuemsa (SyadAstiNasti _ _)             = Nothing
residuemsa (SyadAvaktavyam v)              = Just v
residuemsa (SyadAstiAvaktavyam _ v)        = Just v
residuemsa (SyanNastiAvaktavyam _ v)       = Just v
residuemsa (SyadAstiNastiAvaktavyam _ _ v) = Just v

-- --------------------------------------------------- 3 order: in succession

-- What is already in hand stands (prathamarpana: the first to speak keeps
-- its witness); what is new is added beside it.  Nothing is consumed.
adhiAsti :: Naya -> Bhanga -> Bhanga
adhiAsti _ (SyadAsti a')                     = SyadAsti a'
adhiAsti a (SyanNasti n)                     = SyadAstiNasti a n
adhiAsti _ (SyadAstiNasti a' n)              = SyadAstiNasti a' n
adhiAsti a (SyadAvaktavyam v)                = SyadAstiAvaktavyam a v
adhiAsti _ (SyadAstiAvaktavyam a' v)         = SyadAstiAvaktavyam a' v
adhiAsti a (SyanNastiAvaktavyam n v)         = SyadAstiNastiAvaktavyam a n v
adhiAsti _ (SyadAstiNastiAvaktavyam a' n v)  = SyadAstiNastiAvaktavyam a' n v

adhiNasti :: Naya -> Bhanga -> Bhanga
adhiNasti n (SyadAsti a)                     = SyadAstiNasti a n
adhiNasti _ (SyanNasti n')                   = SyanNasti n'
adhiNasti _ (SyadAstiNasti a n')             = SyadAstiNasti a n'
adhiNasti n (SyadAvaktavyam v)               = SyanNastiAvaktavyam n v
adhiNasti n (SyadAstiAvaktavyam a v)         = SyadAstiNastiAvaktavyam a n v
adhiNasti _ (SyanNastiAvaktavyam n' v)       = SyanNastiAvaktavyam n' v
adhiNasti _ (SyadAstiNastiAvaktavyam a n' v) = SyadAstiNastiAvaktavyam a n' v

adhiResidue :: Residue -> Bhanga -> Bhanga
adhiResidue v (SyadAsti a)                      = SyadAstiAvaktavyam a v
adhiResidue v (SyanNasti n)                     = SyanNastiAvaktavyam n v
adhiResidue v (SyadAstiNasti a n)               = SyadAstiNastiAvaktavyam a n v
adhiResidue _ (SyadAvaktavyam v')               = SyadAvaktavyam v'
adhiResidue _ (SyadAstiAvaktavyam a v')         = SyadAstiAvaktavyam a v'
adhiResidue _ (SyanNastiAvaktavyam n v')        = SyanNastiAvaktavyam n v'
adhiResidue _ (SyadAstiNastiAvaktavyam a n v')  = SyadAstiNastiAvaktavyam a n v'

order :: Bhanga -> Bhanga -> Bhanga
order x (SyadAsti a)                    = adhiAsti a x
order x (SyanNasti n)                   = adhiNasti n x
order x (SyadAstiNasti a n)             = adhiNasti n (adhiAsti a x)
order x (SyadAvaktavyam v)              = adhiResidue v x
order x (SyadAstiAvaktavyam a v)        = adhiResidue v (adhiAsti a x)
order x (SyanNastiAvaktavyam n v)       = adhiResidue v (adhiNasti n x)
order x (SyadAstiNastiAvaktavyam a n v) = adhiResidue v (adhiNasti n (adhiAsti a x))

-- ------------------------------------------------------ 4 saha: all at once

-- Where an affirmation and a denial are both in hand, no single utterance
-- carries the pair, and what is returned is the residue holding both.
-- Everywhere else there is nothing to break and saha agrees with order.
-- This is a DIFFERENT FUNCTION, not order with a flag.
yugapat :: Maybe Naya -> Maybe Naya -> Bhanga -> Bhanga
yugapat (Just a) (Just n) _ = SyadAvaktavyam (Residue a n)
yugapat _        _        b = b

saha :: Bhanga -> Bhanga -> Bhanga
saha x y = yugapat (astyamsa j) (nastyamsa j) j where j = order x y

-- ----------------------------------------------- 5 the fourth is informative

caturthatTritiya :: Residue -> Bhanga
caturthatTritiya v = SyadAstiNasti (residueSadhaka v) (residueBadhaka v)

-- ------------------------------------------------------------ 6 the birth

-- Tattvarthasutra 5.31 as an operation.  The affirming naya is taken under
-- the ASSERTED aspect, where it affirms; the same naya under the UNASSERTED
-- aspect is what its own proof refutes.  So the born pair has ONE base
-- standpoint, where the root pair provably had two distinct ones.
prasava :: Residue -> Residue
prasava v = Residue (aspect Arpita s) (aspect Anarpita s)
  where
    s = residueSadhaka v
    aspect ar n = Naya
      { nayaMula   = nayaMula n
      , nayaArpana = nayaArpana n ++ [ar]
      , nayaSaksin = case ar of
          Arpita   -> nayaSaksin n
          Anarpita -> "refutes withholding: " ++ nayaSaksin n }

-- The next position, born from the residue.  What no single utterance
-- carried at level k is uttered in succession at level k+1.
kernel :: Residue -> Bhanga
kernel = caturthatTritiya . prasava

-- and it iterates: the derivation stream seeded by one residue
kernelDhara :: Residue -> [Bhanga]
kernelDhara v = kernel v : kernelDhara (prasava v)

-- --------------------------------------------------------- 7 rendering

renderNaya :: Naya -> String
renderNaya n = nayaAdhisthana n ++ "  <- " ++ nayaSaksin n

renderBhanga :: Bhanga -> [String]
renderBhanga b = case b of
  SyadAsti a -> ["syad-asti", "    sadhaka: " ++ renderNaya a]
  SyanNasti n -> ["syan-nasti", "    badhaka: " ++ renderNaya n]
  SyadAstiNasti a n ->
    ["syad-asti-nasti  (order: asserted in succession, no contradiction)"
    ,"    sadhaka: " ++ renderNaya a, "    badhaka: " ++ renderNaya n]
  SyadAvaktavyam v ->
    ["syad-avaktavyam  (saha: no single utterance carries the pair)"
    ,"    NOT unknown, NOT undefined, NOT bottom.  The two it could not"
    ,"    jointly express are retained:"] ++ residueLines v
  SyadAstiAvaktavyam a v ->
    ["syad-asti-avaktavyam", "    sadhaka: " ++ renderNaya a] ++ residueLines v
  SyanNastiAvaktavyam n v ->
    ["syan-nasti-avaktavyam", "    badhaka: " ++ renderNaya n] ++ residueLines v
  SyadAstiNastiAvaktavyam a n v ->
    ["syad-asti-nasti-avaktavyam", "    sadhaka: " ++ renderNaya a
    ,"    badhaka: " ++ renderNaya n] ++ residueLines v
  where
    residueLines v =
      [ "    residue.sadhaka: " ++ renderNaya (residueSadhaka v)
      , "    residue.badhaka: " ++ renderNaya (residueBadhaka v)
      , "    viveka (the two standpoints differ): " ++ show (viveka v)
      , "    seeds the next derivation at level "
        ++ show (1 + stara (residueSadhaka v)) ]

-- ------------------------------------------- 7b anarpana: the label lane
--
-- The forgetful map into `Verdict.Bhanga` -- this
-- module's positions read with the naya UNASSERTED (Umasvati,
-- Tattvarthasutra 5.31, arpitanarpita-siddheh: the aspect not made primary
-- in this utterance, which is NOT a claim that there was none).
--
-- This map is a homomorphism for order and for saha, it has a section
-- that is one for both, and it has no inverse.
-- Proved for every standpoint family in
-- formal/cubical/Arpitanarpita_TheForgetfulMapIsAHomomorphismForBothArpanasAndTheLabelsAreARetractNotAnEquivalence.agda
-- (--cubical --guardedness --safe, exit 0, no postulates, no holes);
-- re-verified exhaustively over the 49 pairs of `sample` in `selfTest`.
anarpana :: Bhanga -> L.Bhanga
anarpana b = case b of
  SyadAsti _                    -> L.SyadAsti
  SyanNasti _                   -> L.SyadNasti
  SyadAstiNasti _ _             -> L.SyadAstiNasti
  SyadAvaktavyam _              -> L.SyadAvaktavya
  SyadAstiAvaktavyam _ _        -> L.SyadAstiAvaktavya
  SyanNastiAvaktavyam _ _       -> L.SyadNastiAvaktavya
  SyadAstiNastiAvaktavyam _ _ _ -> L.SyadAstiNastiAvaktavya

-- ------------------------------------------------------------ 8 the laws
--
-- Exhaustive over the seven, and over 49 pairs where a pair is called for.
-- Each entry names the Agda term that proves the same statement.

selfTest :: [(String, Bool)]
selfTest =
  [ ("order of asti,nasti is the THIRD position            (kramena-ubhayam)",
      order (SyadAsti a1) (SyanNasti n1) == SyadAstiNasti a1 n1)

  , ("saha  of asti,nasti is the FOURTH position           (sahena-ubhayam)",
      saha (SyadAsti a1) (SyanNasti n1) == SyadAvaktavyam (Residue a1 n1))

  , ("third /= fourth: simultaneity is not sequential both-ness (order-saha-bhedah)",
      order (SyadAsti a1) (SyanNasti n1) /= saha (SyadAsti a1) (SyanNasti n1))

  , ("the FOURTH carries both nayas AND both witnesses (nothing is a label)",
      case saha (SyadAsti a1) (SyanNasti n1) of
        SyadAvaktavyam v -> residueSadhaka v == a1 && residueBadhaka v == n1
                            && not (null (nayaSaksin (residueSadhaka v)))
                            && not (null (nayaSaksin (residueBadhaka v)))
        _ -> False)

  , ("the two standpoints of a saha-born residue are distinct     (vivekah)",
      and [ viveka v | x <- sample, y <- sample
                     , Just v <- [residuemsa (saha x y)]
                     , isNothing (residuemsa x), isNothing (residuemsa y) ])

  , ("the THIRD is recovered from the FOURTH: nothing was destroyed \
     \(avaktavyam-a-luptam)",
      caturthatTritiya (Residue a1 n1) == order (SyadAsti a1) (SyanNasti n1))

  , ("succession never manufactures a residue          (order-na-janayati-residuem)",
      and [ residuemsa (order x y) == residuemsa x
          | x <- sample, y <- sample, isNothing (residuemsa y) ])

  , ("simultaneity does, and it is exactly the pair it could not utter \
     \(saha-janayati-residuem)",
      and [ saha x y == SyadAvaktavyam (Residue a n)
          | x <- sample, y <- sample
          , Just a <- [astyamsa (order x y)], Just n <- [nastyamsa (order x y)] ])

  , ("the birth needs only ONE old standpoint          (kernel-ekadhisthanam)",
      let v = prasava (Residue a1 n1)
      in nayaMula (residueSadhaka v) == nayaMula (residueBadhaka v))

  , ("...while at the root the third position needs two distinct ones \
     \(mule-dvau-nayau)",
      nayaMula a1 /= nayaMula n1)

  , ("what saha could not utter at level k, order utters at level k+1 \
     \(kernel-orderjah)",
      let v = Residue a1 n1
      in kernel v == order (SyadAsti (residueSadhaka (prasava v)))
                           (SyanNasti (residueBadhaka (prasava v))))

  , ("the birth iterates: level rises by one each time, unboundedly",
      [ level b | b <- take 5 (kernelDhara (Residue a1 n1)) ] == [1,2,3,4,5])

  , ("order is NOT commutative once the positions carry evidence \
     \(order-a-vinimayah -- this LAW IS WITHDRAWN from the label module)",
      order (SyadAsti a1) (SyadAsti a2) /= order (SyadAsti a2) (SyadAsti a1))

  , ("...and the withdrawal is exactly the evidence: the labels still agree",
      shape (order (SyadAsti a1) (SyadAsti a2)) == shape (order (SyadAsti a2) (SyadAsti a1)))

  , ("anarpana is a KRAMA homomorphism onto the label lane, 49 pairs \
     \(anarpana-krame)",
      and [ anarpana (order x y) == L.krama (anarpana x) (anarpana y)
          | x <- sample, y <- sample ])

  , ("anarpana is a SAHA homomorphism too -- the half expected to fail \
     \(anarpana-sahe): a retained pair and a destroyed pair have the \
     \same presence profile",
      and [ anarpana (saha x y) == L.saha (anarpana x) (anarpana y)
          | x <- sample, y <- sample ])

  , ("saha is NOT associative HERE either, with every naya and witness \
     \retained (saha-asangatih-urdhvam) -- retention does not buy the \
     \law back, so destruction was never the reason it fails",
      saha (saha (SyadAstiNasti a1 n1) (SyadAsti a1)) (SyanNasti n1)
      /= saha (SyadAstiNasti a1 n1) (saha (SyadAsti a1) (SyanNasti n1)))

  , ("...and the labels of those two sides differ, which is WHY the \
     \records do: distinctness lifts along anarpana, identities do not",
      anarpana (saha (saha (SyadAstiNasti a1 n1) (SyadAsti a1)) (SyanNasti n1))
      /= anarpana (saha (SyadAstiNasti a1 n1) (saha (SyadAsti a1) (SyanNasti n1))))

  , ("every position in the sample carries at least one witness",
      and [ all (not . null) (witnessesOf b) | b <- sample ])
  ]
  where
    a1 = Naya "induction on x, step = cong suc" [] "machine.log:174 KERNEL-ACCEPT round=0 x = (xmaxx)"
    a2 = Naya "trace replay"                    [] "machine.log: rewriter closed the same claim"
    n1 = Naya "refl"                            [] "machine.log:146 KERNEL-REJECT round=0 x != max x x"
    v1 = Residue a1 n1
    sample =
      [ SyadAsti a1, SyanNasti n1, SyadAstiNasti a1 n1, SyadAvaktavyam v1
      , SyadAstiAvaktavyam a1 v1, SyanNastiAvaktavyam n1 v1
      , SyadAstiNastiAvaktavyam a1 n1 v1 ]
    level b = case b of
      SyadAstiNasti a _ -> stara a
      _                 -> -1
    -- the label the old module returned, and nothing more
    shape b = case b of
      SyadAsti _                    -> "asti"
      SyanNasti _                   -> "nasti"
      SyadAstiNasti _ _             -> "asti-nasti"
      SyadAvaktavyam _              -> "avaktavyam"
      SyadAstiAvaktavyam _ _        -> "asti-avaktavyam"
      SyanNastiAvaktavyam _ _       -> "nasti-avaktavyam"
      SyadAstiNastiAvaktavyam _ _ _ -> "asti-nasti-avaktavyam"
    witnessesOf b =
      [ nayaSaksin x | Just x <- [astyamsa b, nastyamsa b] ]
      ++ concat [ [nayaSaksin (residueSadhaka v), nayaSaksin (residueBadhaka v)]
                | Just v <- [residuemsa b] ]
