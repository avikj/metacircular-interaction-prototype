-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Upamana — knowledge by LIKENESS, as an organ of the natural machine.
--
-- ===========================================================================
-- §0  THE DOCTRINE, WITH ITS SOURCES AND DATES (CLAUDE.md "Where to look
--     first": name the earliest statement, with text and date, or the
--     provenance is asserted rather than checked).
--
-- UPAMĀNA is the third pramāṇa of the Nyāya school.  Its list is given at
--
--     Gautama (Akṣapāda), *Nyāyasūtra* 1.1.3:
--         प्रत्यक्षानुमानोपमानशब्दाः प्रमाणानि
--         pratyakṣa-anumāna-upamāna-śabdāḥ pramāṇāni
--     "perception, inference, comparison, testimony are the means of
--      knowledge."
--
-- and its definition, which is the whole design brief for this module, at
--
--     *Nyāyasūtra* 1.1.6:
--         प्रसिद्धसाधर्म्यात् साध्यसाधनम् उपमानम्
--         prasiddha-sādharmyāt sādhya-sādhanam upamānam
--     "upamāna is the establishing of what is to be established (sādhya)
--      from the SIMILARITY (sādharmya) to what is already well known
--      (prasiddha)."
--
-- Date: the sūtra collection reached its extant form c. 2nd century CE; the
-- material is older.  The standard commentary is
--
--     Vātsyāyana (Pakṣilasvāmin), *Nyāyabhāṣya* on 1.1.6, c. 400–450 CE,
--
-- which supplies the example this module is named after.  A forest-dweller
-- tells a townsman *gosadṛśo gavayaḥ* — "the gavaya (गवय, the gayal, *Bos
-- frontalis*) is like the cow."  The townsman later meets the animal and
-- knows it.  The knowledge is not perception (he had never seen a gavaya) and
-- not inference (he had no vyāpti, no pervasion, to run); it is a THIRD thing.
--
-- THE POINT THAT DECIDES THIS MODULE'S DESIGN, and it is Vātsyāyana's, not a
-- modern gloss: the PHALA (result) of upamāna is
--
--     saṃjñā-saṃjñi-sambandha-pratipatti
--     — apprehension of the relation between a NAME and its BEARER.
--
-- Upamāna does not tell you the gavaya's weight, diet, or lifespan.  It tells
-- you that the word "gavaya" denotes THIS.  Everything else about the animal
-- remains to be found out by perception and inference.  That is exactly the
-- status of what this module emits: a transported theorem is a NAMING — "the
-- shape called commutativity is stateable in the pair chart as *this*
-- equation" — and it is handed to the engine as a CONJECTURE, to be refuted,
-- proved, and kernel-checked by the ordinary organs.  Upamāna here produces
-- candidates and provenance, never belief.
--
-- THE DISPUTE, because the brief demands it be read and because it decides
-- whether this module is a new organ or a disguise on an old one.
--
--   * NYĀYA (Vātsyāyana; sharpened by Gaṅgeśa, *Tattvacintāmaṇi*,
--     upamāna-khaṇḍa, c. 1325 CE): upamāna is irreducible because its
--     karaṇa (special instrument) is SĀDṚŚYA-JÑĀNA, cognition of similarity,
--     and no inference can have that instrument.  To infer "this is a gavaya"
--     you would need the pervasion "whatever resembles a cow thus is denoted
--     by 'gavaya'" — which is *precisely what you are trying to learn*.  The
--     pervasion is the conclusion; it cannot also be the premise.
--
--   * MĪMĀṂSĀ (Śabara, *Śābarabhāṣya*; Kumārila Bhaṭṭa, *Ślokavārttika*,
--     upamāna-pariccheda, c. 650 CE) accepts upamāna but REVERSES it: for
--     Kumārila the new cognition is of the REMEMBERED cow ("the cow at home
--     is like this gavaya"), needs no verbal instruction, and is new because
--     its object is absent and so beyond perception.
--
--   * BUDDHIST (Dignāga, *Pramāṇasamuccaya* 1.2, c. 500 CE: *pratyakṣam
--     anumānaṃ ca pramāṇe dve* — two pramāṇas only, because there are two
--     kinds of object, svalakṣaṇa and sāmānyalakṣaṇa; and Dharmakīrti,
--     *Pramāṇavārttika*, 7th c.) DENIES that upamāna is separate.  It is
--     analysed away into testimony + memory + perception + inference.  The
--     Vaiśeṣikas and Sāṃkhyas reduce it too, to anumāna.
--
-- THE OPERATIVE TEST, which is the Nyāya argument turned into something this
-- repository can measure.  Upamāna is a distinct organ here IFF the
-- similarity is STATED and not DERIVED.  If the map from one vocabulary to
-- another were computed from the engine's own theory ("both are associative,
-- therefore …"), then a pervasion was available and the Buddhist is right:
-- it is inference wearing a costume.  So:
--
--   §4 holds the STATED similarities.  They are input.  Someone said them,
--      and the citation says who.  This is the forester's sentence.
--   §5 holds the DERIVED candidate similarities, computed from arity and
--      algebraic role.  They are kept in a separate list, separately
--      labelled, and separately measured, because they are anumāna and this
--      module must not be allowed to launder them as upamāna.
--
-- AND THE HONEST CONTROL (§6).  The engine already reaches statements by
-- enumerating its term space up to a size bound.  If everything upamāna
-- transports is inside that space, upamāna bought nothing and the Buddhist
-- position is vindicated EMPIRICALLY, which is a real result and must be
-- reported as one.  §6 computes, exactly and without enumerating anything,
-- whether each transported statement lies in the generated space and how
-- large that space is.  No estimate, no sample, no fitted anything.
--
-- WHAT WOULD REFUTE THIS MODULE.  (i) If every transported statement is
-- inside the engine's enumeration reach at its own knobs — then this is
-- inference and should be deleted.  (ii) If the similarities have to be
-- retuned per target theorem until the wanted statement falls out — then it
-- is an oracle, not an organ, and the pins of §2 are how one would cheat.
-- The defence against (ii) is that each stated similarity is written ONCE and
-- transports the WHOLE source library; the count of what it emits, including
-- what it emits that is FALSE, is reported in §9 and not filtered.
--
-- ===========================================================================
-- §0b  WHAT THIS MODULE IS, MECHANICALLY.
--
-- MathMachine.hs conjectures by enumerating terms of its current vocabulary
-- to a size bound and testing them.  Everything it can state is therefore a
-- recombination of symbols someone typed, and every vocabulary starts from
-- zero: it cannot see that `+(x,y) = +(y,x)`, which it proved, and
-- `bcy(x,y,z,u) = bcy(z,u,x,y)`, which it has never stated, are the SAME
-- SHAPE over different carriers.  This module is the missing transfer.
--
-- It is `module Upamana`, not `module Main`.  machine/Certify.hs was written
-- as `module Main` and is consequently wired to nothing; this is imported by
-- MathMachine.hs and reachable from the engine's own dispatch (`--upamana`).
--
-- NO POSTULATES, NO HOLES, NO GATE WEAKENED.  This module emits CANDIDATES in
-- the researcher-input format of machine/THOUGHT_FORMAT.md.  A transported
-- candidate "receives no privileged proof status": it must still agree on
-- every fingerprint, still be proved by the engine's own prover, and still be
-- accepted by the Agda kernel in-process before any rule is installed.
--
-- LAYOUT.  §1 term algebra (mirrored from MathMachine, as ArithVocab and
-- PairVocab mirror it, so these terms ARE its terms) · §2 the Similarity, the
-- forester's sentence as data · §3 transport · §4 the STATED similarities ·
-- §5 the DERIVED ones, labelled · §6 the enumeration control, exact · §7 the
-- forester audited: exact refutation over a stated box · §8 emission · §9 the
-- report.
-- ===========================================================================

module Upamana
  ( -- §1
    Term(..)
  , size, vars, symbolsIn, ordNub
  , showTermP, parseTerm, applySub
    -- §2
  , OpImage(..), Similarity(..)
  , slot, simFaults, simDroppedSlots
    -- §3
  , transportTerm, transportEq, transportLibrary, Transported(..)
    -- §4 stated similarities
  , bhavanaSimilarity, pairRingSimilarity, w3Similarity
  , statedSimilarities
    -- §5 derived
  , derivedSimilarities, roleOf, AlgRole(..)
    -- §6 the control
  , Reach(..), reachOf, inGeneratedSpace, spaceSize
    -- §7
  , Verdict(..), adjudicate
    -- §8
  , renderCandidate, thoughtFileFor
    -- §9
  , upamanaReport
  ) where

import qualified Data.Map.Strict as M
import Data.Char (isAlphaNum, isSpace)
import Data.List (intercalate, sort, nub)
import Data.Maybe (mapMaybe, fromMaybe)
import Control.Monad (forM_, unless)
import Text.ParserCombinators.ReadP
  (ReadP, readP_to_S, munch1, between, char, sepBy, option, eof)
import Text.Printf (printf)
import System.Directory (doesFileExist)

-- ============================================================ §1 term algebra
-- Copied from MathMachine.hs (as ArithVocab and PairVocab copy it) so the
-- terms below are the same objects the engine manipulates.  The ONE extension
-- is the meaning given to NEGATIVE variable indices, which §2 explains: they
-- are argument SLOTS inside a similarity's image scheme and can never occur in
-- a term the engine sees.

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show = showTermP

size :: Term -> Int
size (V _) = 1
size (F _ ts) = 1 + sum (map size ts)

vars :: Term -> [Int]
vars (V i) = [i]
vars (F _ ts) = concatMap vars ts

symbolsIn :: Term -> [String]
symbolsIn (V _) = []
symbolsIn (F f ts) = f : concatMap symbolsIn ts

-- arity of every application occurring in a term, for the well-formedness audit
appArities :: Term -> [(String,Int)]
appArities (V _) = []
appArities (F f ts) = (f, length ts) : concatMap appArities ts

ordNub :: Ord a => [a] -> [a]
ordNub = go M.empty
  where
    go _ [] = []
    go seen (x:xs) | M.member x seen = go seen xs
                   | otherwise = x : go (M.insert x () seen) xs

-- The engine's own prefix spelling (MathMachine.showTermP), which is also
-- exactly what MathMachine.parseTerm reads back.  Slots print as `@k` and are
-- deliberately NOT parseable: a slot must never leave this module inside a
-- candidate.
showTermP :: Term -> String
showTermP (V i)
  | i >= 0 && i < 6 = ["xyzuvw" !! i]
  | i < 0           = "@" ++ show (negate i - 1)
  | otherwise       = "v" ++ show i
showTermP (F n [])  = n
showTermP (F n ts)  = n ++ "(" ++ intercalate "," (map showTermP ts) ++ ")"

-- MathMachine.identifier / termP / parseTerm, verbatim, so a library line this
-- module reads is the term the engine wrote.
identifier :: ReadP String
identifier = munch1 (\c -> isAlphaNum c || c `elem` "+*-^#_")

termP :: ReadP Term
termP = do
  name <- identifier
  args <- option Nothing (Just <$> between (char '(') (char ')')
                    (sepBy termP (char ',')))
  case (name, args) of
    ([v], Nothing) | Just i <- lookup v (zip "xyzuvw" [0..]) -> pure (V i)
    (_, Nothing) -> pure (F name [])
    (_, Just ts) -> pure (F name ts)

parseTerm :: String -> Maybe Term
parseTerm s = case [ t | (t, rest) <- readP_to_S (termP <* eof) s, null rest ] of
  [t] -> Just t
  _   -> Nothing

applySub :: M.Map Int Term -> Term -> Term
applySub m (V i) = fromMaybe (V i) (M.lookup i m)
applySub m (F f ts) = F f (map (applySub m) ts)

-- =================================================== §2 the stated similarity
--
-- "गोसदृशो गवयः" — the forester's sentence, as data.
--
-- A similarity is not a bijection of symbols.  It cannot be, because the
-- carriers differ: a source ELEMENT (a natural number) becomes a target BLOCK
-- (a pair (x,y) in the Pell chart).  So a similarity carries a WIDTH w, and
--
--   * a source variable becomes a block of w target terms (`simVars`);
--   * a source n-ary symbol becomes a scheme of w target terms over n·w
--     argument SLOTS plus a declared set of CONTEXT variables (`simOps`).
--
-- SLOTS are negative variable indices, `slot w j k = V (-(1 + j*w + k))`, so
-- they cannot collide with the target's own variables (which are 0..5, the
-- ceiling `Certificate.agdaVar` spells).  A slot leaving this module inside a
-- candidate is a bug that would print as `@k` and fail to parse; §8 checks for
-- it rather than trusting it.
--
-- PINS are the *respect* in which the resemblance is asserted.  Classical
-- sādharmya is never bare: it is always similarity IN SOME RESPECT, and the
-- forester's useful sentence is not "a gavaya is like a cow" but "…like a cow,
-- in the forest".  A pin `(j, blk)` says the image is defined only when
-- argument j transports to exactly `blk`; otherwise the source term does not
-- transport at all.  This is what makes a similarity PARTIAL in a way that is
-- stated rather than accidental, and §9 reports how often each pin refuses.
--
-- A pin is also the one place a dishonest author could hide an answer.  The
-- defence is that a similarity is written once, transports the whole source
-- library, and is scored on everything it emits including its own garbage.

data OpImage = OpImage
  { opiArity :: Int              -- ^ arity in the SOURCE vocabulary
  , opiPins  :: [(Int,[Term])]   -- ^ argument j must transport to exactly this block
  , opiBlock :: [Term]           -- ^ w target terms over slots and context vars
  } deriving (Eq, Show)

data Similarity = Similarity
  { simName  :: String
  , simCite  :: String              -- ^ who stated it, and where.  Not decoration.
  , simWidth :: Int                 -- ^ w: one source element = w target terms
  , simCtx   :: [Int]               -- ^ target variables usable as context in images
  , simVars  :: [[Term]]            -- ^ image of source variables 0,1,2,… (in order)
  , simOps   :: [(String,OpImage)]  -- ^ image of source symbols; PARTIAL by design
  , simGloss :: String              -- ^ the sentence in words
  } deriving (Eq, Show)

slot :: Int -> Int -> Int -> Term
slot w j k = V (negate (1 + j*w + k))

-- The audit of a stated similarity, run before anything is transported.  A
-- similarity is input, and unchecked input is how a "transport" becomes a
-- source of nonsense that the fingerprint filter then has to mop up.
simFaults :: [(String,Int)] -> Similarity -> [String]
simFaults targetSig sim =
  [ "width must be >= 1, is " ++ show w | w < 1 ]
  ++ concat
     [ [ "variable image " ++ show i ++ " has " ++ show (length blk)
         ++ " components, width is " ++ show w | length blk /= w ]
       ++ [ "variable image " ++ show i ++ " mentions slot " ++ showTermP (V v)
          | t <- blk, v <- vars t, v < 0 ]
       ++ [ "variable image " ++ show i ++ " mentions target variable "
            ++ showTermP (V v) ++ " beyond the certificate ceiling (0..5)"
          | t <- blk, v <- vars t, v > 5 ]
       ++ concatMap (sigFaults ("variable image " ++ show i)) blk
     | (i,blk) <- zip [(0::Int)..] (simVars sim) ]
  ++ concat
     [ [ "image of " ++ f ++ " has " ++ show (length (opiBlock im))
         ++ " components, width is " ++ show w | length (opiBlock im) /= w ]
       ++ [ "image of " ++ f ++ " uses slot @" ++ show (negate v - 1)
            ++ " but arity*width is " ++ show (opiArity im * w)
          | t <- opiBlock im, v <- vars t, v < 0, negate v - 1 >= opiArity im * w ]
       ++ [ "image of " ++ f ++ " uses undeclared context variable "
            ++ showTermP (V v)
          | t <- opiBlock im, v <- vars t, v >= 0, v `notElem` simCtx sim ]
       ++ [ "pin on " ++ f ++ " names argument " ++ show j
            ++ " outside arity " ++ show (opiArity im)
          | (j,_) <- opiPins im, j < 0 || j >= opiArity im ]
       ++ [ "pin block on " ++ f ++ " argument " ++ show j ++ " has width "
            ++ show (length blk) ++ ", width is " ++ show w
          | (j,blk) <- opiPins im, length blk /= w ]
       ++ concatMap (sigFaults ("image of " ++ f)) (opiBlock im)
     | (f,im) <- simOps sim ]
  where
    w = simWidth sim
    sigFaults site t =
      [ site ++ ": target has no symbol " ++ g ++ " of arity " ++ show n
      | (g,n) <- appArities t, (g,n) `notElem` targetSig ]

-- Slots an image never uses.  A dropped slot means the image FORGETS an
-- argument — legal (it is a projection composed with the map) but it is the
-- one shape that can turn a true source theorem into target nonsense, so it is
-- reported rather than silently allowed.
simDroppedSlots :: Similarity -> [(String,[Int])]
simDroppedSlots sim =
  [ (f, dropped)
  | (f,im) <- simOps sim
  , let used = ordNub [ negate v - 1 | t <- opiBlock im, v <- vars t, v < 0 ]
  , let pinned = [ j*w + k | (j,_) <- opiPins im, k <- [0 .. w-1] ]
  , let dropped = [ s | s <- [0 .. opiArity im * w - 1]
                      , s `notElem` used, s `notElem` pinned ]
  , not (null dropped) ]
  where w = simWidth sim

-- ==================================================== §3 transport
--
-- The gavaya met in the forest.  A source term is carried across the stated
-- similarity; where the similarity is silent, the transport REFUSES, and the
-- refusal is returned with its reason so that §9 can count what a similarity
-- cannot see as well as what it can.

transportTerm :: Similarity -> Term -> Either String [Term]
transportTerm sim = go
  where
    w = simWidth sim
    go (V i)
      | i >= 0, i < length (simVars sim) = Right (simVars sim !! i)
      | otherwise = Left ("no image for source variable " ++ showTermP (V i))
    go (F f as) = case lookup f (simOps sim) of
      Nothing -> Left ("no image for source symbol " ++ f)
      Just im
        | opiArity im /= length as ->
            Left ("arity mismatch: " ++ f ++ " applied to " ++ show (length as)
                  ++ ", image declares " ++ show (opiArity im))
        | otherwise -> do
            blocks <- mapM go as
            let pinFault (j,expected)
                  | j < length blocks, blocks !! j == expected = Nothing
                  | j < length blocks =
                      Just ("pin unmet: " ++ f ++ " argument " ++ show j
                            ++ " transports to "
                            ++ intercalate "," (map showTermP (blocks !! j))
                            ++ ", pinned to "
                            ++ intercalate "," (map showTermP expected))
                  | otherwise = Just ("pin index out of range on " ++ f)
            case mapMaybe pinFault (opiPins im) of
              (e:_) -> Left e
              []    ->
                let sub = M.fromList
                            [ (negate (1 + j*w + k), t)
                            | (j,blk) <- zip [(0::Int)..] blocks
                            , (k,t)   <- zip [(0::Int)..] blk ]
                in Right (map (applySub sub) (opiBlock im))

-- An equation between source elements becomes w equations between the
-- components of the target block.  That is not a convention: an equation of
-- pairs IS a pair of equations, and it is the reason `+(x,y) = +(y,x)`
-- transports to TWO statements about the Pell chart and not one.
transportEq :: Similarity -> (Term,Term) -> Either String [(Term,Term)]
transportEq sim (l,r) = do
  bl <- transportTerm sim l
  br <- transportTerm sim r
  if length bl /= length br
    then Left "block width mismatch between the two sides"
    else Right (zip bl br)

data Transported = Transported
  { trSource   :: (Term,Term)      -- ^ the source theorem
  , trSim      :: String           -- ^ which similarity carried it
  , trResult   :: [(Term,Term)]    -- ^ the w component equations that survived
  , trRefusals :: [String]         -- ^ why the similarity refused, if it did
  } deriving (Eq, Show)

-- Transport a whole library.  Trivial components (l == r) are dropped: they
-- are true, and they are not knowledge.  Components over more variables than
-- `Certificate.agdaVar` can spell are dropped here rather than crashing the
-- engine's `fingerprint` later — the same failure MathMachine's
-- `variableHorizon` note records.
transportLibrary :: Similarity -> [(Term,Term)] -> [Transported]
transportLibrary sim lib =
  [ case transportEq sim eq of
      Left why -> Transported eq (simName sim) [] [why]
      Right cs -> Transported eq (simName sim) (filter keep cs) []
  | eq <- lib ]
  where
    keep (l,r) = l /= r && all (\v -> v >= 0 && v <= 5) (vars l ++ vars r)

-- ======================================== §4 THE STATED SIMILARITIES
--
-- These are INPUT.  Each carries the sentence that states it and the citation
-- for the mathematics it names.  Nothing below is computed from the engine's
-- theory; §5 is where that happens, and it is kept apart on purpose.

x0, y0, z0, u0, v0, w0 :: Term
[x0,y0,z0,u0,v0,w0] = map V [0..5]

zeroT :: Term
zeroT = F "0" []

-- ---- (a) BHĀVANA: the multiplicative monoid of ℕ resembles the Pell chart.
--
-- BRAHMAGUPTA, *Brāhmasphuṭasiddhānta*, 628 CE, ch. 18, the rule called
-- bhāvanā ("production", "composition"):
--
--     (x₁² − D y₁²)(x₂² − D y₂²) = (x₁x₂ + D y₁y₂)² − D (x₁y₂ + x₂y₁)²
--
-- i.e. the norm form N(x,y) = x² − Dy² is MULTIPLICATIVE, and the composition
-- of (x₁,y₁) with (x₂,y₂) is (x₁x₂ + Dy₁y₂, x₁y₂ + x₂y₁).  At D = 1 those two
-- components are the machine's `bcx1` and `bcy` (PairVocab §3d, wired into
-- MathMachine's `pairVocabulary` at commit f57b64ab; the identity itself is
-- checked in formal/cubical/Bhavana.agda).  A thousand years before
-- Brouncker, Wallis, Euler or Lagrange, and not a special case of any of them.
--
-- THE SENTENCE: "the composition of pairs resembles multiplication of
-- numbers; a number resembles a PAIR."  Width 2.  `s` has no image — the
-- successor of a pair is not in the chart — so every source theorem naming a
-- numeral refuses, and that refusal is the partiality upamāna is supposed to
-- have.
bhavanaSimilarity :: Similarity
bhavanaSimilarity = Similarity
  { simName  = "bhavana"
  , simCite  = "Brahmagupta, Brahmasphutasiddhanta 628 CE, ch.18 (bhavana); \
                \D=1 chart = PairVocab.natBcx1Sym/natBcySym; \
                \formal/cubical/Bhavana.agda"
  , simWidth = 2
  , simCtx   = [0,1,2,3,4,5]
  , simVars  = [ [x0,y0], [z0,u0], [v0,w0] ]
  , simOps   =
      [ ( "*", OpImage 2 []
                 [ F "bcx1" [slot 2 0 0, slot 2 0 1, slot 2 1 0, slot 2 1 1]
                 , F "bcy"  [slot 2 0 0, slot 2 0 1, slot 2 1 0, slot 2 1 1] ] )
      , ( "0", OpImage 0 [] [ zeroT, zeroT ] )
      ]
  , simGloss = "a natural number resembles a PAIR (x,y); multiplication of \
               \numbers resembles Brahmagupta's composition of pairs at D=1, \
               \(x,y)*(z,u) = (bcx1(x,y,z,u), bcy(x,y,z,u)); zero resembles \
               \the pair (0,0); the successor has NO image."
  }

-- ---- (b) THE PAIR RING: all of ℕ-arithmetic resembles ℕ[√1] in coordinates.
--
-- The same sentence with one more clause: addition of numbers resembles
-- COMPONENTWISE addition of pairs.  Then a source theorem in {0,+,*} becomes a
-- statement about the split-complex ring ℤ[t]/(t²−1) restricted to ℕ
-- coordinates.  Both images are SUBTRACTION-FREE, which is why the transported
-- statements survive the passage to ℕ that PairVocab §11 shows bhāvana itself
-- does NOT survive when monus is in play.
pairRingSimilarity :: Similarity
pairRingSimilarity = Similarity
  { simName  = "pair-ring"
  , simCite  = "Brahmagupta 628 CE (composition) + componentwise addition; \
                \carrier = N[t]/(t^2-1) in (x,y) coordinates, D=1"
  , simWidth = 2
  , simCtx   = [0,1,2,3,4,5]
  , simVars  = [ [x0,y0], [z0,u0], [v0,w0] ]
  , simOps   =
      [ ( "+", OpImage 2 []
                 [ F "+" [slot 2 0 0, slot 2 1 0]
                 , F "+" [slot 2 0 1, slot 2 1 1] ] )
      , ( "*", OpImage 2 []
                 [ F "bcx1" [slot 2 0 0, slot 2 0 1, slot 2 1 0, slot 2 1 1]
                 , F "bcy"  [slot 2 0 0, slot 2 0 1, slot 2 1 0, slot 2 1 1] ] )
      , ( "0", OpImage 0 [] [ zeroT, zeroT ] )
      ]
  , simGloss = "as bhavana, and additionally: addition of numbers resembles \
               \COMPONENTWISE addition of pairs.  Still no image for the \
               \successor, for monus, for max, for le or for gcd."
  }

-- ---- (c) W3: comparison in ℕ resembles Fermat-blindness at a fixed base.
--
-- The head-depth lane.  machine/HeadDepthVocab.hs (never run by anything
-- before this module) carries Thm W3 of notes/HEAD_DEPTH_BLINDNESS.md,
-- certified over 1048 triples in formal/cubical/HeadDepthMerge.agda:
--
--     b is Fermat-blind on q^a   ⟺   a ≤ e_b(q),
--     e_b(q) = v_q(b^{ord_q(b)} − 1)     — INDEPENDENT of a.
--
-- In the machine's own term language that is `fb(q,a,b) = le(a, eb(q,b))`.
--
-- THE SENTENCE: "blindness of b on q^a resembles the comparison a ≤ ·, WHERE
-- THE THING COMPARED WITH IS the head depth."  The clause after WHERE is a
-- PIN (§2): the image of `le(A,B)` is defined only when B transports to
-- exactly `eb(q,b)`.  Width 1; the source variable x is the head depth
-- itself, so `le(x,x)` and `le(s(x),x)` — both of them theorems the engine
-- proved about ℕ, in machine/library.terms — land on the two statements that
-- ARE the content of W3: the threshold is attained, and it is sharp.
--
-- Everything whose le-second-argument is not the head depth REFUSES.  That is
-- the pin working, not a limitation being hidden.
w3Similarity :: Similarity
w3Similarity = Similarity
  { simName  = "w3-blindness"
  , simCite  = "notes/HEAD_DEPTH_BLINDNESS.md Thm W3; \
                \formal/cubical/HeadDepthMerge.agda (1048 triples); \
                \machine/HeadDepthVocab.hs w3Rule"
  , simWidth = 1
  , simCtx   = [0,1]
  , simVars  = [ [ F "eb" [x0, y0] ] ]
  , simOps   =
      [ ( "le", OpImage 2 [(1, [F "eb" [x0,y0]])]
                  [ F "fb" [x0, slot 1 0 0, y0] ] )
      , ( "s",  OpImage 1 [] [ F "s" [slot 1 0 0] ] )
      , ( "0",  OpImage 0 [] [ zeroT ] )
      , ( "+",  OpImage 2 [] [ F "+" [slot 1 0 0, slot 1 1 0] ] )
      , ( "*",  OpImage 2 [] [ F "*" [slot 1 0 0, slot 1 1 0] ] )
      , ( "max",OpImage 2 [] [ F "max" [slot 1 0 0, slot 1 1 0] ] )
      , ( "-",  OpImage 2 [] [ F "-" [slot 1 0 0, slot 1 1 0] ] )
      ]
  , simGloss = "the natural number the engine reasons about resembles the \
               \HEAD DEPTH e_b(q); and the comparison le(A, e_b(q)) resembles \
               \the blindness query fb(q, A, b).  The second argument of le is \
               \PINNED to the head depth: a comparison against anything else \
               \is not a blindness query and does not transport."
  }

statedSimilarities :: [Similarity]
statedSimilarities = [ bhavanaSimilarity, pairRingSimilarity, w3Similarity ]

-- ============================================ §5 DERIVED similarities (ANUMĀNA)
--
-- KEPT SEPARATE ON PURPOSE.  What follows is computed from the engine's own
-- theory: it looks at which binary symbols the source has proved commutative
-- and/or associative, does the same on the target side, and pairs them up by
-- ROLE.  That is a pervasion — "whatever is an associative binary operation
-- satisfies the associativity shape" — and having the pervasion is exactly
-- what makes a cognition ANUMĀNA rather than UPAMĀNA (Nyāyasūtra 1.1.5 vs
-- 1.1.6; Gaṅgeśa's argument, §0).  Dignāga would say this is the whole of what
-- §4 does too.  §9 measures whether he is right by reporting what §4 emits
-- that §5 cannot.
--
-- These are candidate similarities, offered to a human to STATE or reject.
-- Nothing in §9's headline counts is derived from them.

data AlgRole = Comm | Assoc | CommAssoc | Plain deriving (Eq, Ord, Show)

-- The role a binary symbol plays in a given library of proved equations.
-- Purely syntactic recognition of the two shapes, over that library only.
roleOf :: [(Term,Term)] -> String -> AlgRole
roleOf lib f = case (isComm, isAssoc) of
    (True,True)  -> CommAssoc
    (True,False) -> Comm
    (False,True) -> Assoc
    _            -> Plain
  where
    norm (l,r) = (min l r, max l r)
    lib' = map norm lib
    isComm  = norm (F f [V 0,V 1], F f [V 1,V 0]) `elem` lib'
    isAssoc = norm ( F f [F f [V 0,V 1], V 2]
                   , F f [V 0, F f [V 1, V 2]] ) `elem` lib'

-- Candidate maps: a source binary symbol may resemble a target binary symbol
-- of the same role.  Width 1 only — role inference says nothing about carriers,
-- which is precisely the information §4's stated sentences add.
derivedSimilarities :: [(Term,Term)] -> [(String,Int)] -> [(Term,Term)]
                    -> [Similarity]
derivedSimilarities srcLib tgtSig tgtLib =
  [ Similarity
      { simName  = "derived:" ++ f ++ "~" ++ g
      , simCite  = "DERIVED (anumana), not stated: role " ++ show role
                   ++ " matched between source " ++ f ++ " and target " ++ g
      , simWidth = 1
      , simCtx   = [0,1,2,3,4,5]
      , simVars  = [ [x0], [y0], [z0] ]
      , simOps   = [ (f, OpImage 2 [] [ F g [slot 1 0 0, slot 1 1 0] ]) ]
      , simGloss = "computed from the libraries by matching algebraic role; \
                   \this is inference, and it is listed apart from the stated \
                   \similarities for that reason."
      }
  | f <- srcBinaries, g <- tgtBinaries, f /= g
  , let role = roleOf srcLib f
  , role /= Plain
  , roleOf tgtLib g == role
  ]
  where
    srcBinaries = ordNub [ h | (l,r) <- srcLib, (h,2) <- appArities l ++ appArities r ]
    tgtBinaries = ordNub [ h | (h,2) <- tgtSig ]

-- ================================================ §6 THE HONEST CONTROL
--
-- The question the brief puts, and the one that decides whether this module is
-- worth keeping: how many of these statements would MathMachine's ordinary
-- size-bounded enumeration have reached anyway, at the same bound?
--
-- THE THEOREM THAT MAKES THIS EXACT RATHER THAN MEASURED (CLAUDE.md: write the
-- theorem the computation would replace).  MathMachine's generator is
--
--     genTermsModulo comm assoc sig nv maxSize
--
-- and with comm = assoc = [] its `canonical` guard is constantly True, so
-- `build n` produces every `F f args` with f of arity a > 0 in sig and args a
-- list of a terms of total size n-1, and `build 1` produces every variable
-- below nv and every nullary symbol.  By induction on n, the union over
-- n ≤ maxSize is EXACTLY
--
--     { t : size t ≤ maxSize, vars t ⊆ [0..nv-1],
--           every application in t is a symbol of sig at its declared arity }.
--
-- So membership is decidable by inspection — `inGeneratedSpace` — and the
-- SIZE of that set satisfies the counting recurrence below, which is computed
-- in exact Integer arithmetic and never enumerated.  No sample, no estimate.
--
-- (With comm/assoc non-empty the generator produces a quotient of this set, so
-- the count below is an UPPER bound on the space and the membership test is
-- unchanged for terms that are already canonical.  Reported as such.)

inGeneratedSpace :: [(String,Int)] -> Int -> Int -> Term -> Bool
inGeneratedSpace sig nv maxSize t =
  size t <= maxSize
  && all (\i -> i >= 0 && i < nv) (vars t)
  && all (`elem` sig) (appArities t)

data Reach
  = Reached
  | NeedsSize Int          -- ^ the larger side has this size
  | NeedsVars Int          -- ^ this many distinct variables are needed
  | NeedsSymbol String     -- ^ not in the target signature at all
  deriving (Eq, Ord, Show)

reachOf :: [(String,Int)] -> Int -> Int -> (Term,Term) -> [Reach]
reachOf sig nv maxSize (l,r) = ordNub $
  [ NeedsSymbol (g ++ "/" ++ show n)
  | (g,n) <- appArities l ++ appArities r, (g,n) `notElem` sig ]
  ++ [ NeedsVars needed | needed > nv ]
  ++ [ NeedsSize biggest | biggest > maxSize ]
  ++ [ Reached | inGeneratedSpace sig nv maxSize l
               , inGeneratedSpace sig nv maxSize r ]
  where
    needed = 1 + maximum (0 : filter (>= 0) (vars l ++ vars r))
    biggest = max (size l) (size r)

-- |Number of terms of size EXACTLY n over the signature, and the running
-- total up to n.  Exact, by the recurrence the generator itself obeys.
-- FIXED 2026-08-19, ON THE FIRST RUN THIS MODULE EVER HAD.  The memo table
-- was `Data.Map.Strict.fromList [ (k, compute k) | ... ]`, and `compute k`
-- reads the table.  Data.Map.STRICT forces its values as it builds, so the
-- table's construction demanded the table, and GHC's runtime reported
-- `<<loop>>` -- a thunk depending on itself.  The recurrence is genuinely
-- well-founded (a term of size n has arguments of total size n-1, strictly
-- smaller), so the defect was entirely in the memo's strictness, not in the
-- mathematics.  A lazy list self-reference is the right memo here and needs
-- no import.
spaceSize :: [(String,Int)] -> Int -> Int -> Integer
spaceSize sig nv maxSize = sum sizes
  where
    sizes = [ compute k | k <- [1 .. maxSize] ]
    atSize k | k >= 1 && k <= maxSize = sizes !! (k - 1)
             | otherwise              = 0
    compute 1 = fromIntegral nv + fromIntegral (length [ () | (_,0) <- sig ])
    compute n = sum [ argCount a (n-1) | (_,a) <- sig, a > 0 ]
    -- number of argument lists of length a with total size k
    argCount 0 k = if k == 0 then 1 else 0
    argCount a k = sum [ atSize i * argCount (a-1) (k-i) | i <- [1 .. k-a+1] ]

-- =========================================== §7 THE FORESTER, AUDITED
--
-- Vātsyāyana's upamāna works because the forester is āpta — reliable.  Nothing
-- guarantees that here, and a stated similarity that is wrong will happily
-- transport a true theorem to a false one.  So every transported statement is
-- adjudicated by EXACT integer evaluation over an explicitly stated box before
-- it is offered to the engine.  A disagreement is a certificate (a concrete
-- counterexample); agreement over a finite box is a statement about that box
-- and nothing more, and is labelled `Survives box`, never "true".
--
-- This is the ordinary discipline of PairVocab §4 and §11, applied to the
-- output of an organ rather than to a hand-written list.

-- TUṢṆĪM, ADDED 2026-08-19 AFTER THE FIRST RUN OF THIS MODULE.
--
-- This module had been imported by nothing since it was written.  The first
-- time it was actually run — machine/UpamanaRun.hs — it crashed here, on
-- `error "unknown symbol"`, after its OWN audit had already printed
--
--     AUDIT FAULT: image of *: target has no symbol bcx1 of arity 4
--
-- The audit was right and the evaluator ignored it.  A verdict function that
-- dies on a symbol it does not know is asserting, by crashing, something it
-- has no ground for; and a report that prints a fault and then proceeds as
-- if it had not is worse than one that never checked.
--
-- The third state is not invented here.  `machine/Obstruction.hs` reached
-- the same place independently and named it: `Tusnim String` — SILENT,
-- carrying the alien symbol.  Nyāya has the vocabulary too: an inference
-- whose reason is `asiddha`, unestablished, yields no verdict rather than a
-- negative one, and the fallacy is a fallacy OF THE REASON, not of the
-- thesis.  So: silence, carrying what it was silent about.
data Verdict
  = Refuted [Integer] Integer Integer   -- ^ environment, lhs value, rhs value
  | Survives Int                        -- ^ agreed everywhere on [0..box]^k
  | Tusnim String                       -- ^ silent: this symbol has no semantics
  deriving (Eq, Show)

adjudicate :: M.Map String ([Integer] -> Integer) -> Int -> (Term,Term) -> Verdict
adjudicate sem box (l,r) =
  case [ f | f <- symbolsIn l ++ symbolsIn r, not (M.member f sem) ] of
    (f : _) -> Tusnim f
    [] ->
      case [ (env, a, b)
           | env <- envs
           , Just a <- [ev env l]
           , Just b <- [ev env r]
           , a /= b ] of
        ((env,a,b):_) -> Refuted env a b
        []            -> Survives box
  where
    k = 1 + maximum (0 : filter (>= 0) (vars l ++ vars r))
    envs = sequence (replicate k [0 .. fromIntegral box])
    ev env t = evalT sem env t

-- Total.  `Nothing` where the term mentions a symbol the target vocabulary
-- does not have, or a variable the environment does not reach.
evalT :: M.Map String ([Integer] -> Integer) -> [Integer] -> Term -> Maybe Integer
evalT _ env (V i)
  | i >= 0 && i < length env = Just (env !! i)
  | otherwise                = Nothing
evalT sem env (F f ts) = case M.lookup f sem of
  Just g  -> fmap g (mapM (evalT sem env) ts)
  Nothing -> Nothing

-- ================================================== §8 EMISSION
--
-- The researcher-input path of machine/THOUGHT_FORMAT.md.  A candidate line is
-- `candidate<TAB>TERM<TAB>TERM` in the engine's prefix syntax, and it "enters
-- conjecture search only after all of its symbols have semantics in the active
-- vocabulary and its deterministic evaluations agree; it receives no
-- privileged proof status".  That is precisely the status upamāna's phala has
-- in Vātsyāyana: a name-bearer relation, not a property of the bearer.

renderCandidate :: (Term,Term) -> Either String String
renderCandidate (l,r)
  | any (< 0) (vars l ++ vars r) =
      Left ("slot escaped into a candidate: " ++ showTermP l ++ " = " ++ showTermP r)
  | otherwise = Right ("candidate\t" ++ showTermP l ++ "\t" ++ showTermP r)

thoughtFileFor :: String -> [String] -> [(Term,Term)] -> Either String String
thoughtFileFor header notes eqs = do
  ls <- mapM renderCandidate eqs
  pure (unlines (["# " ++ header]
                 ++ map ("# " ++) notes
                 ++ ls))

-- ================================================== §9 THE REPORT
--
-- Everything above is data and pure functions; this is the only IO, and it is
-- reachable from the engine's own dispatch as `--upamana`.  It prints the
-- audit of every stated similarity, the transport of the engine's own recorded
-- library, the exact enumeration control, and the exact refutation verdicts,
-- and it writes the two thought files the engine then reads back.

-- The engine's own recorded memory, machine/library.terms: `lhs TAB rhs` in
-- prefix syntax, optionally with a third justification field (Pramana).  This
-- is the machine's proved library, written by the machine; nothing here is
-- hand-entered.
readLibraryFile :: FilePath -> IO [(Term,Term)]
readLibraryFile fp = do
  ok <- doesFileExist fp
  if not ok then pure [] else do
    raw <- readFile fp
    pure (ordNub (mapMaybe line (lines raw)))
  where
    line s = case splitTabs s of
      (a:b:_) | Just l <- parseTerm (trim a), Just r <- parseTerm (trim b)
              -> Just (l,r)
      _ -> Nothing
    trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse
    splitTabs s = case break (== '\t') s of
      (a, [])     -> [a]
      (a, _:rest) -> a : splitTabs rest

upamanaReport :: [(String,Int)]                                -- ^ pair-chart signature
              -> M.Map String ([Integer] -> Integer)           -- ^ pair-chart semantics
              -> [(String,Int)]                                -- ^ head-depth signature
              -> M.Map String ([Integer] -> Integer)           -- ^ head-depth semantics
              -> Int -> Int                                    -- ^ kVars, kSizeCap
              -> IO ()
upamanaReport pairSig pairSem hdSig hdSem kvars kcap = do
  putStrLn "=== UPAMANA ==="
  putStrLn "Nyayasutra 1.1.6, prasiddha-sadharmyat sadhya-sadhanam upamanam;"
  putStrLn "Vatsyayana, Nyayabhasya ad loc. (c. 400-450 CE), the gavaya."
  putStrLn ""

  lib <- readLibraryFile "machine/library.terms"
  printf "SOURCE LIBRARY  machine/library.terms  distinct proved equations: %d\n"
         (length lib)
  forM_ lib $ \(l,r) -> printf "  src  %s = %s\n" (showTermP l) (showTermP r)
  putStrLn ""

  -- --------------------------------------------------- the stated similarities
  forM_ [ (bhavanaSimilarity, pairSig, pairSem)
        , (pairRingSimilarity, pairSig, pairSem)
        , (w3Similarity, hdSig, hdSem) ] $ \(sim, sig, sem) -> do
    printf "--- SIMILARITY %s (STATED)\n" (simName sim)
    printf "    cite : %s\n" (simCite sim)
    printf "    says : %s\n" (simGloss sim)
    printf "    width: %d   source symbols with an image: %s\n"
           (simWidth sim) (intercalate " " (map fst (simOps sim)))
    let faults = simFaults sig sim
    if null faults
      then putStrLn "    AUDIT ok: every image is well-formed over the target signature"
      else forM_ faults (printf "    AUDIT FAULT: %s\n")
    forM_ (simDroppedSlots sim) $ \(f,ds) ->
      printf "    NOTE: image of %s forgets slot(s) %s (a projection; \
             \pinned slots excluded)\n" f (show ds)
    let ts = transportLibrary sim lib
        carried = [ t | t <- ts, not (null (trResult t)) ]
        refusedReasons = M.toList (M.fromListWith (+)
                           [ (reasonHead why, 1::Int)
                           | t <- ts, why <- trRefusals t ])
        out = ordNub (concatMap trResult carried)
    printf "    TRANSPORTED: %d of %d source theorems carried, \
           \yielding %d distinct component equations\n"
           (length carried) (length lib) (length out)
    forM_ refusedReasons $ \(why,n) ->
      printf "    refused (%d): %s\n" n why
    forM_ out $ \eq@(l,r) -> do
      let verdict = adjudicate sem (boxFor sem) eq
          reach   = reachOf sig kvars kcap eq
      printf "      out  %-46s = %-30s  %s  %s\n"
             (showTermP l) (showTermP r) (showVerdict verdict) (showReach reach)
    -- the control, in one line, exact
    printf "    ENUMERATION CONTROL  signature=%d symbols  kVars=%d  kSizeCap=%d\n"
           (length sig) kvars kcap
    printf "      terms in the generated space at that bound: %d\n"
           (spaceSize sig kvars kcap)
    let reachedN = length [ () | eq <- out, Reached `elem` reachOf sig kvars kcap eq ]
    printf "      of the %d transported equations, %d lie inside it, %d do not\n"
           (length out) reachedN (length out - reachedN)
    putStrLn ""

  -- --------------------------------------------------- the derived ones
  putStrLn "--- DERIVED SIMILARITIES (ANUMANA, listed apart; see section 5)"
  let derived = derivedSimilarities lib pairSig []
  if null derived
    then putStrLn "    none: no target symbol has a proved algebraic role to match"
    else forM_ derived $ \s -> printf "    %s : %s\n" (simName s) (simCite s)
  putStrLn ""

  -- --------------------------------------------------- write the thought files
  writeThoughts "machine/thoughts.upamana.pair.math"
    [bhavanaSimilarity, pairRingSimilarity] lib pairSem
    "machine/thoughts.upamana.pair.math -- GENERATED by machine/Upamana.hs."
    [ "Every line below is TRANSPORTED, not typed: it is the image of a"
    , "theorem in machine/library.terms under a STATED similarity (Upamana"
    , "section 4).  Regenerate with:"
    , "  runghc -imachine machine/MathMachine.hs --upamana"
    , "Read with:"
    , "  runghc -imachine machine/MathMachine.hs --pair \\"
    , "    --thoughts machine/thoughts.upamana.pair.math --rounds N"
    , "A transported candidate receives NO privileged proof status."
    ]
  writeThoughts "machine/thoughts.upamana.headdepth.math"
    [w3Similarity] lib hdSem
    "machine/thoughts.upamana.headdepth.math -- GENERATED by machine/Upamana.hs."
    [ "The head-depth chart (machine/HeadDepthVocab.hs) had never been run by"
    , "anything before this file existed.  Read with:"
    , "  runghc -imachine machine/MathMachine.hs --headdepth \\"
    , "    --thoughts machine/thoughts.upamana.headdepth.math --rounds N"
    ]
  where
    reasonHead = takeWhile (/= ':')
    boxFor sem = if M.member "eb" sem then 6 else 4
    showVerdict (Survives b) = printf "survives [0..%d]^k" b
    showVerdict (Refuted env a b) =
      "REFUTED at " ++ show env ++ " (" ++ show a ++ " /= " ++ show b ++ ")"
    showReach rs
      | Reached `elem` rs = "[enumerable]"
      | otherwise = "[beyond enumeration: " ++ intercalate "," (map short rs) ++ "]"
      where short (NeedsSize n) = "size " ++ show n
            short (NeedsVars n) = "vars " ++ show n
            short (NeedsSymbol s) = "symbol " ++ s
            short Reached = "reached"

writeThoughts :: FilePath -> [Similarity] -> [(Term,Term)]
              -> M.Map String ([Integer] -> Integer)
              -> String -> [String] -> IO ()
writeThoughts fp sims lib sem header notes = do
  let box = if M.member "eb" sem then 6 else 4
      eqs = ordNub [ eq
                   | sim <- sims
                   , t <- transportLibrary sim lib
                   , eq <- trResult t ]
      kept = [ eq | eq <- eqs
                  , case adjudicate sem box eq of
                      Survives _ -> True
                      Refuted{}  -> False ]
      dropped = length eqs - length kept
      notes' = notes ++
        [ "Similarities used: " ++ intercalate ", " (map simName sims)
        , "Transported equations: " ++ show (length eqs)
          ++ "; refuted by exact evaluation over [0.." ++ show box
          ++ "]^k and NOT written: " ++ show dropped
          ++ "; written: " ++ show (length kept) ]
  case thoughtFileFor header notes' kept of
    Left err -> putStrLn ("  EMISSION REFUSED: " ++ err)
    Right txt -> do
      writeFile fp txt
      printf "WROTE %s  (%d candidates, %d transported equations refuted and withheld)\n"
             fp (length kept) dropped

-- Kept so `nub`/`sort`/`unless` imports stay honest if a future edit needs them.
_unusedGuard :: ([Int] -> [Int], [Int] -> [Int], Bool -> IO () -> IO ())
_unusedGuard = (nub, sort, unless)

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module.
--
-- The core of §0's operative test is now a checked theorem, in
-- `formal/cubical/NaturalMachine/NamingIsNotAFunctionOfResemblance.agda`
-- (--safe, no postulates, no holes; container green, Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin):
--
--   namingDoesNotFactorThroughResemblance : not (FactorsThrough
--                                                  resembles named)
--
-- Two situations with the SAME resemblance predicate and DIFFERENT
-- naming predicates, so no invariant of the resemblance computes the
-- naming.  Routed through TranscriptDescent.collisionObstructsDecoder,
-- the corpus's standing lemma.
--
-- WHY THAT IS THE QUARANTINE'S REASON.  This module separates STATED
-- similarities (input, cited) from DERIVED ones (computed, quarantined)
-- and says the separation is what stops anumana being laundered as
-- upamana.  The theorem says the separation is not bookkeeping: a naming
-- is not recoverable from resemblance data by ANY function, so a derived
-- similarity cannot become a naming unless something else supplies it.
--
-- AND IT DOES NOT ADJUDICATE THE DISPUTE §0 SETS OUT.  It says only that
-- the naming comes from OUTSIDE the resemblance.  The Naiyayika reads
-- that as a distinct instrument (sadrsya-jnana); Dignaga reads it as the
-- forester's sentence -- sabda plus memory, no new pramana.  Both agree
-- on the theorem and disagree on what the outside is, so the verdict is
-- shared and the grounds are not, and the theorem is neutral by
-- construction rather than by omission.
--
-- NOT touched: §6's empirical control (whether what this module
-- transports already lies inside the engine's enumeration reach at its
-- own knobs).  That is a question about a particular engine and remains
-- entirely this module's.  Nor is the gavaya example modelled -- a
-- two-point carrier is not a forest.
--
-- Sourcing: the Nyayasutra, Nyayabhasya, Tattvacintamani,
-- Pramanasamuccaya and Slokavarttika were NOT opened by that reader;
-- every attribution there is carried from THIS module's §0.
-- ---------------------------------------------------------------------
