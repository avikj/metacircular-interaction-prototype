-- YantraPariksa_TheEngineAnsweringOnTheWire — the engine as an operation of
-- the sabhā, answering in Uttara and never in a boolean.
--
-- THE SEAM THIS FILLS.  `Sabha_TheSessionKernelAnLLMTalksTo`'s header names
-- the lanes that plug into it and says of one of them: *"the certificate
-- lane → `kRun` is in IO precisely so that shelling out to the Agda kernel
-- is a legal handler."*  This is that handler.
--
-- AND IT IS WIRED IN.  `Sabha.kriyah` carries `yantra.pariksa` and
-- `AnyatKarana.apeksa` declares its two parameters, so `machine/sabha`
-- dispatches it and the generated tool schema lists it.  Written-and-not-
-- connected is the failure this repository has on record from 2026-08-20 —
-- a hook documented as live that was absent from `settings.json` — and a
-- module answering only its own runner would have been the same fact one
-- level over.  `machine/check-yantra-pariksa.sh` exercises both: the five
-- roads directly, and one turn through the assembly.
--
-- WHY THE ENGINE BELONGS ON THIS WIRE, and it is not a general argument.
-- `machine/MathMachine.hs`'s kernel gate returned `IO Bool` for weeks, and
-- that Bool merged three verdicts: the fragment was outside the emitter's
-- vocabulary; the invocation could not find the cubical library at all; the
-- statement was false.  The engine spent those weeks rejecting every theorem
-- it proved, for the second reason, while its counter reported the same
-- `proved=0` the third reason would have produced.  The reject TEXT said
-- which — it said `Failed to find source of module Cubical.Foundations.
-- Prelude` on every line — and nobody read past the count.
--
-- That is `Saptabhangi.दुर्नयः` at the cost of a working engine: a two-valued
-- verdict on three seeds identifies two of them, and here it identified
-- "your machine is misconfigured" with "your mathematics is wrong".  The
-- repair is not a better Bool.  It is that the answer stops being one, which
-- is what `Uttara` is: संक्रमण or दोषलेख, and there is no third road.
--
-- WHAT THIS HANDLER OWES, and each obligation is enforced by `Uttara`'s
-- smart constructors rather than promised here:
--
--   the TULYATĀ is computed, not asserted.  Both sides are evaluated at one
--   environment inside this process and the two integers are handed to
--   `ganita`, which compares them.  A false equation is therefore refused by
--   the constructor BEFORE agda is asked — the wire will not carry a
--   transport along an identity that is not there, and it says so as a
--   defect about the claim rather than as a silent `False`.
--
--   the VYAYA is stated.  What crosses is the equation and the shape of the
--   proof that closed it.  What does not cross: the proof term itself, the
--   reverse direction of an oriented rule, the round in which it was found,
--   and the search that failed before it.  §31: यो न वदति स न पश्यति.
--
--   the ŚEṢA is handed forward.  A refused candidate leaves with the
--   equation itself as remainder, so the next turn has the material rather
--   than a memo saying something failed.  यत् न विभजते तत् रक्ष्यते —
--   Āryabhaṭa, *Āryabhaṭīya*, गणितपाद 32–33, 499 CE.
--
-- NOT CLAIMED.  That any source wrote this handler, or that the Sanskrit
-- names a construction of its tradition; the terms are used in their plain
-- senses and the citations are for the discipline, not the code.  The
-- semantics below reproduce `Certificate`'s stated reading of the engine's
-- own `symSem` — same functions, transcribed — and where the two could drift
-- that is a defect of this file and is named in `vyaya`.

-- WHICH WAY THE DEPENDENCY RUNS, and it is not a style question.  This
-- module does NOT import `Sabha`.  If it did, `Sabha` could not import it
-- back, and the assembly would have to be built somewhere neither of them
-- can see.  So what crosses is a handler on the wire's own vocabulary —
-- `J` in, `Uttara` out — and `Sabha` builds the `Kriya` around it.  The
-- table, and therefore the ORDER (Aṣṭādhyāyī 1.4.2 विप्रतिषेधे परं कार्यम्,
-- ~500 BCE: where two rules contend the later prevails), stays entirely in
-- the scheduler lane's file.
module YantraPariksa_TheEngineAnsweringOnTheWire
  ( pariksa
  , pariksaJ
  , pariksaNama
  , pariksaDoc
  , pariksaAngani
  , parsePada
  , evalPada
  ) where

import Data.Char (isAlphaNum, isSpace)

import Sabda_TheWireHasNoBoolean (J(..))
import Uttara_SamkramanaOrDosalekhaNeverABareBoolean
  (Uttara, samkramana, dosalekha, ganita)
import qualified Certificate as C

-- ---------------------------------------------------------------- terms

-- The engine's own prefix notation, which is what `MathMachine.parseTerm`
-- reads and what `machine/library.terms` is written in: `+(x,y)`, `s(0)`,
-- `max(x,s(x))`.  Single letters x y z u v w are the variables.
parsePada :: String -> Maybe C.Term
parsePada s = case pada (dropWhile isSpace s) of
  Just (t, rest) | all isSpace rest -> Just t
  _                                 -> Nothing
  where
    pada :: String -> Maybe (C.Term, String)
    pada str =
      let (nm, r0) = span (\c -> isAlphaNum c || c `elem` "+*-^#_") str
      in if null nm then Nothing else case r0 of
           ('(':r1) -> do
             (args, r2) <- argList r1
             pure (C.F nm args, r2)
           _ -> case nm of
                  [v] | Just i <- lookup v (zip "xyzuvw" [0 ..]) ->
                        pure (C.V i, r0)
                  _ -> pure (C.F nm [], r0)

    argList :: String -> Maybe ([C.Term], String)
    argList (')':r) = pure ([], r)
    argList str = do
      (t, r1) <- pada str
      case r1 of
        (',':r2) -> do (ts, r3) <- argList r2 ; pure (t : ts, r3)
        (')':r2) -> pure ([t], r2)
        _        -> Nothing

-- The engine's semantics, transcribed from `Certificate`'s statement of
-- them.  `le` is the 0/1 reading and `-` is truncated subtraction, both as
-- the engine computes them.
evalPada :: [Integer] -> C.Term -> Maybe Integer
evalPada env (C.V i)
  | i >= 0 && i < length env = Just (env !! i)
  | otherwise                = Nothing
evalPada _   (C.F "0" [])      = Just 0
evalPada env (C.F "s" [a])     = (+ 1) <$> evalPada env a
evalPada env (C.F "+" [a,b])   = (+) <$> evalPada env a <*> evalPada env b
evalPada env (C.F "*" [a,b])   = (*) <$> evalPada env a <*> evalPada env b
evalPada env (C.F "max" [a,b]) = max <$> evalPada env a <*> evalPada env b
evalPada env (C.F "-" [a,b])   =
  (\x y -> if x >= y then x - y else 0) <$> evalPada env a <*> evalPada env b
evalPada env (C.F "le" [a,b])  =
  (\x y -> if x <= y then 1 else 0) <$> evalPada env a <*> evalPada env b
evalPada _ _ = Nothing

-- One environment, fixed and stated.  It is not a sample: it is the point at
-- which the claimed identity is CHECKED before it is carried, and a single
-- disagreement there is a refutation.  Agreement here confirms nothing and
-- is not read as confirming anything — the agda call is what decides.
sthanam :: [Integer]
sthanam = [3, 5, 7, 11, 13, 17]

-- ---------------------------------------------------------------- the op

srotas :: [String]
srotas =
  [ "Āryabhaṭa, Āryabhaṭīya, गणितपाद 32–33, 499 CE — यत् न विभजते तत् रक्ष्यते, the remainder is kept and is the material of the next step"
  , "Gautama, Nyāyasūtra 1.1.7 — आप्तोपदेशः शब्दः; everything the machine learns of its interlocutor arrives as an utterance"
  , "notes/AHIMSA_SUTRA_VISTARA.md §6 — संक्रमणम् or दोषलेखः, तृतीयो मार्गो न विद्यते"
  ]

-- | Ask the engine's certificate lane whether an equation is derivable in the
--   fragment it can translate, and answer as the assembly requires.
pariksa :: FilePath -> String -> String -> IO Uttara
pariksa root lhsText rhsText =
  case (parsePada lhsText, parsePada rhsText, ()) of
    (Nothing, _, _) -> pure (aparsed lhsText "वाम")
    (_, Nothing, _) -> pure (aparsed rhsText "दक्षिण")
    (Just l, Just r, _) ->
      case (evalPada sthanam l, evalPada sthanam r) of
        (Nothing, _) -> pure (avocabulary lhsText)
        (_, Nothing) -> pure (avocabulary rhsText)
        (Just lv, Just rv)
          -- REFUSED BEFORE THE KERNEL IS ASKED.  A disagreement at one point
          -- is a refutation and the agda call is not spent on it.  Agreement
          -- confirms nothing; it only fails to refute, and the kernel decides.
          | lv /= rv  -> pure (asatyam lhsText rhsText lv rv)
          | otherwise -> do
              v <- C.certify root ((l, r), "induction on x")
              pure (uttaraOf lhsText rhsText lv rv v)

uttaraOf :: String -> String -> Integer -> Integer -> C.Verdict -> Uttara
uttaraOf lhsText rhsText lv rv verdict = case verdict of
  C.Certified shape calls ->
    samkramana "yantra.pariksa"
      (ganita "the equation, certified by the Agda kernel in this process"
              lhsText rhsText
              ("both sides evaluated at x,y,z,u,v,w = " ++ show sthanam)
              lv rv)
      [ ("samikarana", JStr (lhsText ++ " = " ++ rhsText))
      , ("naya",       JStr shape)
      , ("ahvanani",   JInt (fromIntegral calls)) ]
      [ "the proof TERM: what crossed is that a term exists and what shape closed it, not the term itself"
      , "the reverse direction: an oriented rule keeps one way round, and the other way is not carried by this answer"
      , "the search that failed before this shape worked — " ++ show calls
        ++ " agda invocation(s) were spent and only the last one is reported here"
      , "this handler's own semantics, transcribed from Certificate's reading of the engine's symSem rather than shared with it; if the two ever drift, this answer is wrong in a way the kernel cannot see" ]
      srotas
  C.Rejected err calls ->
    dosalekha "yantra.pariksa"
      ("the Agda kernel refused every shape tried: " ++ err)
      [ "the equation `" ++ lhsText ++ " = " ++ rhsText ++ "`, which is NOT thereby false — the kernel refused the shapes attempted, and that is a fact about the shapes"
      , if calls == 0
          then "the shapes themselves: this verdict came back from the cache without an agda invocation, so what is reported is a PAST refusal and the rule set it was made against is not recorded with it"
          else "which of the " ++ show calls ++ " attempted shapes came closest, which the verdict type does not carry"
      , "the distinction between a refused proof and a false statement, which a boolean here would have destroyed and which this entry exists to keep" ]
      [ lhsText ++ " = " ++ rhsText
      , "retry when the rule set has changed: the same shapes against a larger set of installed theorems are a different question" ]
      srotas
  C.Untranslatable why ->
    dosalekha "yantra.pariksa"
      ("the equation is outside the fragment this lane can translate: " ++ why)
      [ "the equation `" ++ lhsText ++ " = " ++ rhsText ++ "`, untried — no kernel was asked, so nothing about its truth was learned"
      , "the symbol or variable that fell outside the fragment, which is named in the reason and is the actionable half" ]
      [ lhsText ++ " = " ++ rhsText
      , "extend the emitter's vocabulary, or state the equation in the fragment; this is रिक्तम् — no term of the current language reaches it" ]
      srotas

-- असत्यम् — the claim is refuted, and a refutation is not the same object as
-- an unproved claim.  A boolean answer here would return `False` for both,
-- which is दुर्नयः at the exact place the engine paid for it: `Rejected`
-- above says the SHAPES failed, this says the STATEMENT failed, and the
-- second carries a witness while the first carries none.
asatyam :: String -> String -> Integer -> Integer -> Uttara
asatyam lhsText rhsText lv rv = dosalekha "yantra.pariksa"
  ("the equation is FALSE, and here is the point: at x,y,z,u,v,w = "
   ++ show sthanam ++ " the left side is " ++ show lv
   ++ " and the right side is " ++ show rv)
  [ "the transport, which does not exist — there is no identity to move along, so nothing is carried and saying `not proved` instead would have hidden that a witness is in hand"
  , "the distinction between this and a kernel refusal: that one is a fact about the proof shapes tried, this one is a fact about the statement, and one boolean returns the same value for both"
  , "the OTHER points at which the two sides may still agree, which this answer does not survey and does not need to" ]
  [ lhsText ++ " = " ++ rhsText ++ "  — refuted at " ++ show sthanam
  , "the witness itself: " ++ show lv ++ " ≠ " ++ show rv
  , "the correction is to the claim, not to the machine; asking again unchanged will be refused again at the same point" ]
  srotas

aparsed :: String -> String -> Uttara
aparsed txt slot = dosalekha "yantra.pariksa"
  ("the " ++ slot ++ " side did not parse as a term: `" ++ txt ++ "`")
  [ "what you meant by it, which is NOT guessed at — a near miss executed silently is the collapse this machine refuses"
  , "the position at which it stopped parsing, which this parser does not report and should" ]
  [ txt
  , "the notation is prefix, as machine/library.terms is written: `+(x,y)`, `s(0)`, `max(x,s(x))`; variables are x y z u v w" ]
  srotas

avocabulary :: String -> Uttara
avocabulary txt = dosalekha "yantra.pariksa"
  ("`" ++ txt ++ "` parses, but names a symbol this handler cannot evaluate")
  [ "the symbol itself, which is in the term and not in the semantics — so the identity could not be CHECKED before being sent to the kernel"
  , "the check that would have refused a false equation before any agda call" ]
  [ txt
  , "the symbols this handler evaluates are 0, s, +, *, max, -, le, and the list is transcribed rather than shared with the engine" ]
  srotas

-- ---------------------------------------------------------------- table

-- | The operation's name, prose and parameters, offered to the assembly as
--   data.  `Sabha` builds the `Kriya` from these three and `pariksaJ`; there
--   is no second copy of the doc string anywhere, so the schema lane's
--   listing cannot drift from what runs.
pariksaNama :: String
pariksaNama = "yantra.pariksa"

pariksaDoc :: String
pariksaDoc =
  "Ask the engine's certificate lane whether an equation holds in the fragment it can translate. "
  ++ "The two sides are evaluated here first, so an equation that is false at the checked point is refused "
  ++ "before the kernel is asked, and comes back with the point as witness. The answer is a transport "
  ++ "carrying the equation and the proof shape, or a written defect carrying what was lost and the "
  ++ "equation itself as remainder."

pariksaAngani :: [(String, String)]
pariksaAngani =
  [ ("vama",    "the left-hand side, in prefix notation: `+(x,y)`, `s(0)`, `max(x,s(x))`")
  , ("daksina", "the right-hand side, same notation") ]

-- | The handler, on the wire's own vocabulary.  Session state is untouched
--   by this operation, so it does not appear in the type: an operation that
--   cannot change the assembly should not be given the assembly.
pariksaJ :: J -> IO Uttara
pariksaJ j = case (lookupStr "vama" j, lookupStr "daksina" j) of
  (Just a, Just b) -> pariksa "." a b
  _ -> pure (dosalekha pariksaNama
        "both `vama` and `daksina` are required and one of them was not sent"
        [ "the side you did send, which cannot be examined alone: an equation is a pair and half of one is not a weaker question, it is a different one" ]
        [ "send both sides under `angani`, in prefix notation" ]
        srotas)

lookupStr :: String -> J -> Maybe String
lookupStr k (JObj kvs) = case lookup "angani" kvs of
  Just (JObj as) -> case lookup k as of
    Just (JStr v) -> Just v
    _             -> Nothing
  _ -> case lookup k kvs of
         Just (JStr v) -> Just v
         _             -> Nothing
lookupStr _ _ = Nothing

-- A note for whoever wires this in: `pariksa` takes the repository root
-- because `Certificate.certify` shells out to agda with that as its working
-- directory, and the engine's own gate learned the hard way that running it
-- anywhere else rejects everything for a reason that looks exactly like
-- falsity.  `runPariksa` passes "." and therefore requires the assembly to
-- be started from the repository root; that requirement is stated here
-- rather than discovered, and moving it into the session state is the right
-- fix once `Sabha` carries a root.
