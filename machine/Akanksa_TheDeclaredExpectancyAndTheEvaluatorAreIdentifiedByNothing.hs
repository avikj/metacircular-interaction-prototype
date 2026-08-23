-- Ākāṅkṣā — आकाङ्क्षा, expectancy: how many arguments a symbol declares it
-- is waiting for, and whether its evaluator honours that declaration or
-- quietly identifies argument lists that differ.
--
-- ---------------------------------------------------------------------
-- WHAT THIS FILE IS, IN ONE SENTENCE
--
-- `Sym` carries `symArity` (a number, declared) and `symSem` (a function,
-- written).  Nothing in this repository checks that the two are the same
-- expectancy.  This file checks it by running it, and reports each symbol
-- as a saṃkramaṇa with its witness or as a written doṣa — never as a bit.
--
-- ---------------------------------------------------------------------
-- WHY IT IS NOT A STYLE COMPLAINT.  The finding, measured, not asserted:
--
--   PV "0"  arity 0 : answers at lengths 1,2,3 — every time, 0.
--   PV "s"  arity 1 : answers at lengths 2,3 — on [7,11] it returns 8.
--   PV "+"  arity 2 : answers at length 3 — on [7,11,13] it returns 18.
--   PV "*"  arity 2 : answers at length 3 — on [7,11,13] it returns 77.
--   PV "-"  arity 2 : answers at length 3.
--   AV "0" "s" "+" "*" "-" : identically, the same five, the same values.
--
--   and NOT: gcd, mod, lcm, v2, leglo, leghi, splitnorm, nrm2, bcx1,
--   bcx2, bcy — eleven symbols that refuse at every length but their own.
--
-- The split is exact and it is a difference of writing, not of meaning.
-- An evaluator written `\vs -> vs!!0 + vs!!1` reads a prefix and drops the
-- tail; one written `ev [a,b] = …; ev _ = error …` refuses.  The first
-- IDENTIFIES [7,11] with [7,11,13].  That identification is made by the
-- accident that `!!` does not look at the length, it is exhibited nowhere,
-- and no caller can recover which list arrived — which is precisely
-- ∥·∥₁ of the argument list, and admits no way back
-- (formal/cubical/Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.agda).
--
-- The sharp instance, and it is one field away from a comment that
-- forbids it.  machine/MathMachine.hs:909 makes UNKNOWN SYNTAX fail loud —
--
--     Nothing -> error ("MathMachine.eval: unknown symbol " ++ show f)
--     -- "Unknown syntax must never acquire the accidental meaning zero."
--
-- — and four lines above it, `Sym "0" 0 (const 0)` gives an argument list
-- of ANY length the accidental meaning zero.  The boundary was built for
-- the name and not for the expectancy.
--
-- WHAT IS AND IS NOT CLAIMED.  No wrong answer is claimed.  Term
-- generation in the engine is arity-respecting, so as of this run no
-- caller is known to offer a mis-lengthed list; this is a LATENT
-- identification, and saying otherwise would be the fitted-constant error
-- in another costume.  What is claimed is that the latency is the only
-- thing standing between the declaration and the evaluator, that nothing
-- in the types holds them together, and that when they part the failure is
-- silent on five of the engine's eight base symbols and loud on eleven
-- others — so the engine does not have one convention here, it has two,
-- and which one a symbol got is not recorded anywhere.
--
-- A SECOND, ALREADY-PARTED CASE, and this one needs no latency argument.
-- Three modules each carry a base arithmetic vocabulary and each says in
-- prose that it is MathMachine's:
--
--   ArithVocab.hs:151  "Copied verbatim from MathMachine.hs so this
--                       module's terms ARE its terms."
--   PairVocab.hs:180   "Its {0,s,+,*,-} evaluators are MathMachine's,
--                       verbatim … checking the chart against the engine's
--                       own arithmetic and not against a second copy of it."
--
-- `bhasaAbheda` below compares the two that can be imported, symbol by
-- symbol, and they are NOT the same symbols: PairVocab's `+`, `*` and `-`
-- carry NO defining equations, ArithVocab's carry two, two and three.  The
-- evaluators agree on the stated grid; the objects do not.  A symbol is
-- name, arity, evaluator AND the equations the kernel may use, and two of
-- the four fields were compared by eye.
--
-- MathMachine's own copy cannot be reached from here — it is `module Main`,
-- so `baseVocabulary` is importable by nothing and checkable by nothing.
-- That is the śeṣa this file hands forward rather than guesses at, and it
-- is where the third divergence lives: MathMachine's `s` is written
-- `\vs -> case vs of [v] -> v+1; _ -> error "successor received wrong
-- arity"` and the two copies' is `\vs -> head vs + 1`, so off arity 1 the
-- engine refuses and its two "verbatim" copies answer.  Read, not run.
--
-- ---------------------------------------------------------------------
-- ĀKĀṄKṢĀ, THE TERM, AND WHOSE IT IS
--
-- ākāṅkṣā is one of the three conditions for a string of words to convey a
-- sentence-meaning (śābdabodha), the other two being YOGYATĀ, semantic
-- fitness, and SANNIDHI, proximity in utterance.  It is the syntactic
-- EXPECTANCY a word carries for what completes it: `brings` expects an
-- agent and an object, and a string that does not supply them is not a
-- weaker sentence, it is not a sentence.
--
-- The triad is Mīmāṃsaka in origin — Śabara's *Bhāṣya* on Jaimini's
-- *Mīmāṃsāsūtra* (c. 5th c. CE) argues sentence-unity from mutual
-- expectancy — and is taken up in Nyāya, where Viśvanātha's
-- *Bhāṣāpariccheda* with the *Siddhāntamuktāvalī* (17th c.) states the
-- three as the standing conditions.  The schools do not agree on what
-- unifies a sentence: Prābhākara *anvitābhidhāna* holds words denote only
-- as already-connected, Bhāṭṭa *abhihitānvaya* holds they denote severally
-- and are then connected.  This file takes no side; what it takes is the
-- one point both sides need, that expectancy is a property of the word,
-- stated in advance, and that supply which does not match it does not
-- produce a degraded meaning but no meaning.
--
-- NOT CLAIMED: that any of these authors wrote about arities of evaluator
-- functions, or that `symArity` is ākāṅkṣā.  `symArity` is a declaration of
-- expectancy; the question this file asks — does the thing that consumes
-- the arguments hold the same expectancy the symbol published? — is the
-- question ākāṅkṣā is the name of, and machine/Yogyata.hs already holds the
-- second member of the same triad for the same reason.
--
-- The answer shape is machine/Uttara_SamkramanaOrDosalekhaNeverABareBoolean.hs,
-- i.e. notes/AHIMSA_SUTRA_VISTARA.md §6: saṃkramaṇa e = transport (ua e),
-- or the written defect, and there is no third road.
--
--     runghc -imachine machine/AkanksaRun.hs
--
-- ---------------------------------------------------------------------

module Akanksa_TheDeclaredExpectancyAndTheEvaluatorAreIdentifiedByNothing
  ( Prayoga(..)
  , probeDepth
  , probeArgs
  , akanksaOf
  , akanksaUttara
  , namaAbheda
  , avToPv
  , pvToAv
  , generatedTerms
  , padaSamkramana
  , bhasaAbheda
  , semGrid
  ) where

import Control.Exception (SomeException, evaluate, try)
import Data.List (intercalate, sort)
import qualified ArithVocab as AV
import qualified PairVocab as PV
import Sabda_TheWireHasNoBoolean (J(..))
import Uttara_SamkramanaOrDosalekhaNeverABareBoolean
  ( Uttara, dosalekha, samkramana, tulyata )

-- ---------------------------------------------------------------------
-- 0.  Sources, quoted once and referred to by name below, so that a
--     citation is not retyped in four places and drifting.
-- ---------------------------------------------------------------------

srcAkanksa :: [String]
srcAkanksa =
  [ "Śabara, Śābarabhāṣya on Jaimini's Mīmāṃsāsūtra, c. 5th c. CE — sentence-unity from mutual expectancy"
  , "Viśvanātha Nyāyapañcānana, Bhāṣāpariccheda with Siddhāntamuktāvalī, 17th c. — ākāṅkṣā, yogyatā, sannidhi as the three conditions"
  , "notes/AHIMSA_SUTRA_VISTARA.md §6 — saṃkramaṇa or doṣalekha, no third road"
  ]

srcTransport :: [String]
srcTransport =
  [ "Voevodsky, univalence: ua — the equivalent may become identity; transport carries the structure"
  , "formal/cubical/Samkramana_TransportCarriesStructureAndTruncationIsTransportExactlyWhenNothingWasThereToLose.agda"
  , "notes/AHIMSA_SUTRA_VISTARA.md §6"
  ]

-- ---------------------------------------------------------------------
-- 1.  One probed application.  The arguments are DISTINCT primes so that
--     the value that comes back names which prefix was read: `s` answering
--     8 on [7,11,13] says it read [7] and dropped two arguments, and that
--     is information a boolean "arity honoured?" would have destroyed.
-- ---------------------------------------------------------------------

data Prayoga = Prayoga
  { prLength :: Int            -- how many arguments were offered
  , prPhala  :: Maybe Integer  -- Nothing = it refused (any exception)
  } deriving (Eq, Show)

-- | Lengths 0..probeDepth are offered.  THE BOUND IS THE RESULT'S BOUND:
--   nothing here says a symbol refuses at length 9.
probeDepth :: Int
probeDepth = 6

probeArgs :: Int -> [Integer]
probeArgs k = take k (cycle [7, 11, 13, 17, 19, 23, 29])

-- | Run the evaluator at every offered length.  `try . evaluate` is what
--   makes "it refused" a fact rather than a hope: the evaluators refuse by
--   `error`, which is bottom, so forcing is the only way to see it.
akanksaOf :: ([Integer] -> Integer) -> IO [Prayoga]
akanksaOf f =
  mapM (\k -> do
           r <- try (evaluate (f (probeArgs k)))
                  :: IO (Either SomeException Integer)
           return (Prayoga k (either (const Nothing) Just r)))
       [0 .. probeDepth]

-- | The verdict, which is not a verdict: a transport with its witness, or
--   a written defect naming every excess answer one by one.  A count of
--   them would be the collapse this file is about.
akanksaUttara :: String -> String -> Int -> [Prayoga] -> Uttara
akanksaUttara modName nm ar ps
  | not (null extra) =
      dosalekha kriya
        ("`" ++ nm ++ "` declares ākāṅkṣā " ++ show ar
         ++ " and its evaluator answers at " ++ commas (map (show . prLength) extra)
         ++ "; argument lists of different lengths are identified, and by nothing")
        [ "the list of length " ++ show (prLength p) ++ ": offered "
          ++ show (probeArgs (prLength p)) ++ ", answered " ++ show v
          ++ prefixNote (prLength p) v
        | p <- extra, Just v <- [prPhala p] ]
        [ "write the evaluator as an exhaustive match on the declared length, "
          ++ "as gcd/mod/lcm/v2/leglo/leghi/splitnorm/nrm2/bcx1/bcx2/bcy already are"
        , "or make symArity derivable from symSem so the two cannot part" ]
        srcAkanksa
  | otherwise =
      samkramana kriya
        (tulyata "ākāṅkṣā ≡ the evaluator's domain"
                 ("symArity " ++ show nm ++ " = " ++ show ar)
                 ("symSem " ++ show nm ++ " defined exactly at length " ++ show ar)
                 ("refused at every offered length in 0.." ++ show probeDepth
                  ++ " but " ++ show ar ++ "; at " ++ show ar ++ " it answered "
                  ++ maybe "⊥" show declared))
        [ ("nama", JStr nm)
        , ("akanksa", JInt (toIntegral ar))
        , ("phala", maybe (JStr "⊥") (JInt . toIntegral') declared)
        , ("module", JStr modName) ]
        [ "the bound: lengths above " ++ show probeDepth ++ " were not offered, so "
          ++ "this says nothing about them"
        , "WHICH exception the refusals raised — only that each was one"
        , "the evaluator's behaviour off the probe values " ++ show (probeArgs ar) ]
        srcAkanksa
  where
    kriya = modName ++ "." ++ nm ++ "/akanksa"
    extra = [ p | p <- ps, prLength p /= ar, prPhala p /= Nothing ]
    declared = case [ v | p <- ps, prLength p == ar, Just v <- [prPhala p] ] of
                 (v:_) -> Just v
                 []    -> Nothing
    toIntegral = fromIntegral :: Int -> Integer
    toIntegral' = id :: Integer -> Integer
    -- name which prefix the answer proves was read, when it can be named
    prefixNote k v =
      case [ j | j <- [0 .. k], Just v == prPhala' j ] of
        (j:_) | j /= k -> " — the same value the list of length " ++ show j
                          ++ " gives, so " ++ show (k - j) ++ " argument(s) were dropped"
        _ -> ""
    prPhala' j = case [ prPhala p | p <- ps, prLength p == j ] of
                   (x:_) -> x
                   []    -> Nothing

commas :: [String] -> String
commas = intercalate ", "

-- ---------------------------------------------------------------------
-- 2.  नाम-अभेदः — identification by name.  `semantics` in all three
--     modules is `M.fromList [ (symName s, symSem s) | s <- ss ]`, and
--     `M.fromList` keeps the LAST value for a duplicate key: a second
--     symbol of the same name does not collide, it silently replaces.
--     MathMachine.hs:777 records that the author avoided this by hand
--     when appending ArithVocab's gcd.  A hand is not a mechanism.
-- ---------------------------------------------------------------------

namaAbheda :: String -> [(String, Int)] -> Uttara
namaAbheda who pairs
  | null dups =
      samkramana (who ++ "/nama")
        (tulyata "name ≡ symbol"
                 ("the " ++ show (length pairs) ++ " names of " ++ who)
                 "the symbols they index"
                 ("all distinct: " ++ commas (sort (map fst pairs))))
        [ ("count", JInt (fromIntegral (length pairs)))
        , ("names", JArr (map (JStr . fst) pairs)) ]
        [ "this is a fact about THIS list; a caller that appends to it "
          ++ "re-opens the question and nothing re-asks it"
        , "arity is carried, symSem and symDefs are not compared here" ]
        srcAkanksa
  | otherwise =
      dosalekha (who ++ "/nama")
        ("two symbols of " ++ who ++ " share a name, and `semantics` is "
         ++ "M.fromList, which keeps the last silently")
        [ "the name " ++ show n ++ ", declared at arities "
          ++ commas (map show (sort [ a | (m, a) <- pairs, m == n ]))
        | n <- dups ]
        [ "rename, or make the vocabulary a Map built with a colliding "
          ++ "insert that refuses" ]
        srcAkanksa
  where
    names = map fst pairs
    dups = [ n | n <- uniq names, length (filter (== n) names) > 1 ]
    uniq = foldr (\x acc -> if x `elem` acc then acc else x : acc) []

-- ---------------------------------------------------------------------
-- 3.  पद-संक्रमणम् — the term transport, exhibited.
--
--     ArithVocab and PairVocab each define `Term = V !Int | F !String
--     [Term]` and each says in prose that it is MathMachine's.  Prose is
--     not an identification.  Here it is one: two functions and a
--     round trip run on a GENERATED corpus — generated, not stored
--     (§35, §41: अल्पं स्थापय, शेषं जनय).
-- ---------------------------------------------------------------------

avToPv :: AV.Term -> PV.Term
avToPv (AV.V i)    = PV.V i
avToPv (AV.F f ts) = PV.F f (map avToPv ts)

pvToAv :: PV.Term -> AV.Term
pvToAv (PV.V i)    = AV.V i
pvToAv (PV.F f ts) = AV.F f (map pvToAv ts)

-- | Every AV.Term of depth <= d over the signature (v0,v1 ; 0/0 ; s/1 ;
--   +/2).  Nothing is stored: the level is a function of the level below.
generatedTerms :: Int -> [AV.Term]
generatedTerms 0 = [AV.V 0, AV.V 1, AV.F "0" []]
generatedTerms d =
  let below = generatedTerms (d - 1)
  in below
     ++ [ AV.F "s" [t] | t <- below ]
     ++ [ AV.F "+" [a, b] | a <- below, b <- below ]

-- | The transport, with the round trip as its witness.  Both directions,
--   because a retraction in one direction is not an equivalence — that is
--   the whole content of Apratikaryatva_….agda at the level of types, and
--   the least this file can do is not assume it here.
padaSamkramana :: Int -> Uttara
padaSamkramana d
  | null bad =
      samkramana "ArithVocab.Term ≃ PairVocab.Term"
        (tulyata "relabelling of constructors"
                 "ArithVocab.Term = V !Int | F !String [Term]"
                 "PairVocab.Term  = V !Int | F !String [Term]"
                 (show n ++ " generated terms to depth " ++ show d
                  ++ ": pvToAv ∘ avToPv = id on every one, and "
                  ++ "avToPv ∘ pvToAv = id on every image"))
        [ ("corpus", JInt (fromIntegral n))
        , ("depth", JInt (fromIntegral d))
        , ("signature", JArr (map JStr ["v0", "v1", "0/0", "s/1", "+/2"])) ]
        [ "the precedence: a symbol's index in its own module's vocabulary "
          ++ "list is the reduction order, and the index does not travel — "
          ++ "ArithVocab orders 0<s<+<*<-<gcd<mod<lcm<v2, MathMachine puts "
          ++ "max between * and -, so a transported symDef's LPO rank is "
          ++ "not the rank it was oriented under"
        , "the corpus is over one 5-symbol signature to depth " ++ show d
          ++ "; terms mentioning gcd, mod, lcm, v2, leglo, … were not offered"
        , "strictness (!Int) is written the same in both and compared by neither" ]
        srcTransport
  | otherwise =
      dosalekha "ArithVocab.Term ≃ PairVocab.Term"
        "the round trip is not the identity, so the two Term types are not the same type"
        [ "the term " ++ show t ++ " comes back as " ++ show (pvToAv (avToPv t))
        | t <- take 12 bad ]
        [ "the two declarations have parted; find which module changed" ]
        srcTransport
  where
    corpus = generatedTerms d
    n = length corpus
    bad = [ t | t <- corpus
              , pvToAv (avToPv t) /= t || avToPv (pvToAv (avToPv t)) /= avToPv t ]

-- ---------------------------------------------------------------------
-- 4.  भाषा-अभेदः — are the two importable base vocabularies the same
--     vocabulary?  Compared on all four fields a `Sym` has, because a
--     symbol is name, arity, evaluator AND the equations the kernel may
--     use, and two of the four were previously compared by eye.
-- ---------------------------------------------------------------------

-- | The grid the evaluators are compared on.  Stated, because a bound
--   that is not stated is not a result.
semGrid :: Int -> [[Integer]]
semGrid 0 = [[]]
semGrid k = [ x : rest | x <- gridPoints, rest <- semGrid (k - 1) ]

gridPoints :: [Integer]
gridPoints = [0 .. 12] ++ [97, 1000003]

bhasaAbheda :: String -> Uttara
bhasaAbheda nm =
  case (findAV nm, findPV nm) of
    (Nothing, _) -> absent "ArithVocab.vocabulary"
    (_, Nothing) -> absent "PairVocab.natVocabulary"
    (Just a, Just p) ->
      let arityD = [ "arity: ArithVocab says " ++ show (AV.symArity a)
                     ++ ", PairVocab says " ++ show (PV.symArity p)
                   | AV.symArity a /= PV.symArity p ]
          k = AV.symArity a
          semD = [ "evaluator: at " ++ show args ++ " ArithVocab gives "
                   ++ show (AV.symSem a args) ++ ", PairVocab gives "
                   ++ show (PV.symSem p args)
                 | AV.symArity a == PV.symArity p
                 , args <- semGrid k
                 , AV.symSem a args /= PV.symSem p args ]
          avD = map (\(l, r) -> (avToPv l, avToPv r)) (AV.symDefs a)
          pvD = PV.symDefs p
          defD = [ "defining equations: ArithVocab gives the kernel "
                   ++ show (length avD) ++ " — " ++ commas (map showEq avD)
                   ++ " — and PairVocab gives it " ++ show (length pvD)
                   ++ (if null pvD then " (none at all)"
                                   else " — " ++ commas (map showEq pvD))
                 | avD /= pvD ]
          divergences = arityD ++ take 8 semD ++ defD
      in if null divergences
           then samkramana ("base." ++ nm)
                  (tulyata "same symbol under two module names"
                           ("ArithVocab.vocabulary ∋ " ++ show nm)
                           ("PairVocab.natVocabulary ∋ " ++ show nm)
                           ("arity " ++ show k ++ " on both; evaluators agree at all "
                            ++ show (length (semGrid k)) ++ " grid points "
                            ++ show gridPoints ++ "^" ++ show k
                            ++ "; symDefs equal after Term transport ("
                            ++ show (length avD) ++ " equation(s))"))
                  [ ("nama", JStr nm)
                  , ("akanksa", JInt (fromIntegral k))
                  , ("samikarana", JInt (fromIntegral (length avD))) ]
                  [ "off-grid behaviour: the grid is " ++ show gridPoints
                    ++ ", negatives beyond it were not offered"
                  , "off-arity behaviour: that is §1's question, not this one"
                  , "MathMachine's third copy is unreachable — `module Main`" ]
                  srcTransport
           else dosalekha ("base." ++ nm)
                  ("ArithVocab and PairVocab each say in their headers that this "
                   ++ "symbol is MathMachine's verbatim, and the two of them are "
                   ++ "not each other's")
                  divergences
                  [ "decide which module owns the base vocabulary and have the "
                    ++ "others import it, so there is one definition and not three"
                  , "MathMachine's copy cannot be compared at all until "
                    ++ "baseVocabulary leaves `module Main`" ]
                  srcTransport
  where
    findAV n = case [ s | s <- AV.vocabulary, AV.symName s == n ] of
                 (s:_) -> Just s; [] -> Nothing
    findPV n = case [ s | s <- PV.natVocabulary, PV.symName s == n ] of
                 (s:_) -> Just s; [] -> Nothing
    absent w = dosalekha ("base." ++ nm)
                 ("`" ++ nm ++ "` is not in " ++ w ++ ", so there is nothing to identify")
                 [ "the comparison itself: this name exists on one side only" ]
                 [ "check the name, or drop it from the shared list" ]
                 srcTransport

showEq :: (PV.Term, PV.Term) -> String
showEq (l, r) = show l ++ " → " ++ show r
