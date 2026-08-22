-- Nigrahasthana -- the machine judged by what it REFUSES.
--
-- निग्रहस्थान, "ground of defeat": in the Nyayasutra (Gautama, ~2nd c. CE)
-- the point at which a debater LOSES, enumerated at 1.2.19 and again over
-- the whole of adhyaya 5.2.  What is borrowed here is exactly one thing --
-- that a position is assessed by where it is defeated, not by where it
-- speaks well -- and NOTHING else.  No sutra of the Nyayasutra is encoded
-- below and none is claimed to be; the twenty-two grounds Gautama lists are
-- grounds of DEBATE (evasion, self-contradiction, saying too little), and
-- the checks here are grounds of a GRAMMAR ENGINE.  The word names the
-- stance and is not a citation for the content.
--
-- WHY THIS FILE EXISTS.  `Astadhyayi.selfTest` is 90-odd checks and every
-- one of them is a success case: the pratyaharas resolve, deva+indra gives
-- devendra, the traditional value is the value.  A machine that only
-- succeeds has told you nothing.  The content of a derivation system is
-- what it REFUSES: which forms it will not produce, at which position it
-- stops, and which rule it declines to run even though the rule's stated
-- condition is met on the string in front of it.
--
-- FIVE THINGS ARE ASSERTED HERE AND ONE IS RECORDED AS ABSENT.
--
--   1. PRATISIDDHA -- forms that must not derive.  For each juncture, the
--      attested form AND the near-misses: the form the losing sutra would
--      have given, and the form a reader who had not read 1.4.2 would
--      write.  `dadhi + indra` must be `dadhindra` and must NOT be
--      `dadhyindra` -- and `dadhyindra` is not a typo, it is what 6.1.77
--      alone produces.
--
--   2. STALL -- ill-formed input.  Feed the engine sounds that are not in
--      the varnasamamnaya and assert that the derivation stops, that it
--      stops AT the first such sound, and that everything from there on is
--      returned untouched.  A machine that produces something plausible
--      for garbage input is the failure mode this repository was built
--      against, reproduced in a compiler.
--
--   3. PARATVA -- order witnesses.  For each juncture where two sutras
--      want the same position, the assertion is not that the answer is
--      right: it is that the answer is right BECAUSE the winner's number
--      is larger.  So each witness carries the loser's Ref, the loser's
--      output form, and the invariant that over the whole corpus no
--      earlier sutra ever beats a later one.  `machine/nigrahasthana-mutants.sh`
--      then breaks the resolver on a copy and checks these go red.  A test
--      that passes under a broken resolver is testing nothing.
--
--   3a. APAVADA -- the elsewhere condition, asserted by its REASON and
--       not by a form.  Deleting the apavada branch of `resolve` changes no
--       form this file can construct (dosha D3), because the one exception
--       declared is numerically later than its utsarga and 1.4.2 would pick
--       it anyway.  So the check is on why the rule won, and it is the only
--       check in either suite that can see the metarule at all.
--
--   4. ASIDDHA -- stratification witnesses.  For each form whose tripadi
--      output would re-trigger an earlier rule, the refused rules are
--      asserted BY REF, and the form that rule would have produced is
--      asserted to be one the machine does not produce.  For `vac` the
--      refused rule is 8.2.39 and the cycle it would enter is exhibited.
--
--   5. STHANIVADBHAVA (1.1.56 `sthanivad adeso 'nalvidhau`) is ABSENT
--      from the machine, and the absence is recorded rather than tested
--      around.  See `dosha` D4: the al-vidhi direction is assertable and
--      is asserted; the designation-inheritance direction is not
--      constructible, because `Item` carries no samjna and no encoded
--      sutra conditions on one.
--
-- THE DEFECT RECORD.  `dosha` is a list of properties that OUGHT to hold
-- and do not, each computed live against the engine, so it cannot go
-- stale: if a defect stops reproducing the runner says so and the entry
-- must be deleted.  A defect written down is a defect that can be
-- corrected; a defect not written down is the thing this repository keeps
-- calling himsa.
--
-- WHAT THIS FILE MAY AND MAY NOT DO.  It imports `Astadhyayi` and touches
-- nothing in it.  It uses only the stable exports -- `derive`,
-- `deriveTrace`, `asiddhaAudit`, `parseInput`, `render`, `phoneOf`,
-- `Step` -- and deliberately NOT `fires`, whose type was being changed in
-- the working tree while this was written.  A falsifier that breaks when
-- the thing it falsifies is edited is not a falsifier.

module Nigrahasthana_TheMachineIsJudgedByWhatItRefuses
  ( Pratisiddha(..)
  , pratisiddha
  , Paratva(..)
  , paratvaWitnesses
  , apavadaWitnesses
  , Asiddha(..)
  , asiddhaWitnesses
  , junk
  , mustNotFire
  , mustFire
  , nigraha
  , dosha
  , report
  ) where

import Astadhyayi
import Data.List (isInfixOf, nub)
import Data.Maybe (isNothing, listToMaybe)

-- quote without escaping: `show` would print Sanskrit as codepoints, and a
-- defect record nobody can read is a defect record nobody reads.
q :: String -> String
q s = "\"" ++ s ++ "\""

------------------------------------------------------------------------
-- 1.  PRATISIDDHA: what must not come out.
--
-- `pForbidden` is not a list of typos.  Each entry is a form some rule of
-- this very engine would produce if a metarule were switched off, or the
-- form the juncture has under a DIFFERENT boundary, so that the pair
-- discriminates.  The provenance of each is written beside it.
------------------------------------------------------------------------

data Pratisiddha = Pratisiddha
  { pInput     :: String
  , pAttested  :: String
  , pForbidden :: [(String, String)]   -- (form that must not appear, where it comes from)
  } deriving (Show)

pratisiddha :: [Pratisiddha]
pratisiddha =
  [ Pratisiddha "dadhi + indra" "dadhīndra"
      [ ("dadhyindra", "6.1.77 alone -- what the engine gives if 1.4.2 loses")
      , ("dadhiindra", "no rule at all")
      , ("dadhindra",  "6.1.101 without the dirgha") ]
  , Pratisiddha "su + ukta" "sūkta"
      [ ("svukta",  "6.1.77 alone")
      , ("suukta",  "no rule at all")
      , ("sukta",   "6.1.101 without the dirgha") ]
  , Pratisiddha "te + api" "te'pi"
      [ ("tayapi",  "6.1.78 alone -- what the engine gives if 1.4.2 loses")
      , ("teapi",   "no rule at all")
      , ("tepi",    "elision with no avagraha") ]
  , Pratisiddha "ne - ana" "nayana"
      [ ("ne'na",   "6.1.109 with its padantat condition dropped")
      , ("neana",   "no rule at all") ]
  , Pratisiddha "ne + ana" "ne'na"
      [ ("nayana",  "6.1.78 -- the SAME two vowels, and the answer for the"
                    ++ " other boundary; the pair is the discriminator") ]
  , Pratisiddha "tat + jalam" "tajjalam"
      [ ("tadjalam", "the tripadi run under 6.4.22's simultaneous regime")
      , ("tatjalam", "no rule at all") ]
  , Pratisiddha "tat + ca" "tacca"
      [ ("tadca", "8.2.39 with 8.4.40 and 8.4.55 not reached")
      , ("tatca", "no rule at all") ]
  , Pratisiddha "vāc" "vāk"
      [ ("vāg", "8.2.39 fired on the tripadi's own output -- what 8.2.1 refuses")
      , ("vāc", "no rule at all") ]
  , Pratisiddha "rāmas" "rāmaḥ"
      [ ("rāmar", "8.2.66 with 8.3.15 not reached")
      , ("rāmas", "no rule at all") ]
  , Pratisiddha "deva + indra" "devendra"
      [ ("devaindra", "no rule at all")
      , ("devindra",  "elision instead of guna")
      , ("devaiindra", "vrddhi where 6.1.87 gives guna") ]
  , Pratisiddha "deva + aiśvarya" "devaiśvarya"
      [ ("deveśvarya", "6.1.87 guna where 6.1.88 vrddhi is the apavada")
      , ("devaaiśvarya", "no rule at all") ]
  , Pratisiddha "mahā + ṛṣi" "maharṣi"
      [ ("mahārṣi", "6.1.101 across sounds that are not savarna")
      , ("mahaṛṣi", "guna without 1.1.51's rapara r") ]
  , Pratisiddha "madhu + ari" "madhvari"
      [ ("madhūari", "6.1.101 across sounds that are not savarna")
      , ("madhuari", "no rule at all") ]
  , Pratisiddha "gaṅgā + udaka" "gaṅgodaka"
      [ ("gaṅgāudaka", "no rule at all")
      , ("gaṅgādaka",  "elision instead of guna") ]
  , Pratisiddha "kavi + indra" "kavīndra"
      [ ("kavyindra", "6.1.77 alone")
      , ("kaviindra", "no rule at all") ]
  , Pratisiddha "sat + jana" "sajjana"
      [ ("sadjana", "8.4.40 not reached")
      , ("satjana", "no rule at all") ]
  ]

pratisiddhaTests :: [String]
pratisiddhaTests = concatMap one pratisiddha
  where
    one p =
      let got = derive (pInput p)
      in [ "pratisiddha " ++ show (pInput p) ++ ": got " ++ show got
             ++ ", attested " ++ show (pAttested p)
         | got /= pAttested p ]
      ++ [ "pratisiddha " ++ show (pInput p) ++ ": PRODUCED the forbidden "
             ++ show bad ++ " (" ++ why ++ ")"
         | (bad, why) <- pForbidden p, got == bad ]
      -- a forbidden form equal to the attested one is a broken test, not a
      -- passing one, and is reported as such.
      ++ [ "pratisiddha " ++ show (pInput p) ++ ": the forbidden list contains"
             ++ " the attested form " ++ show bad ++ " -- the test is vacuous"
         | (bad, _) <- pForbidden p, bad == pAttested p ]

------------------------------------------------------------------------
-- 2.  STALL: the derivation must stop at the first sound it does not have.
--
-- `phoneOf` is the machine's own alphabet.  `tokenize` does NOT consult
-- it: an unknown character is kept whole and handed to the rules, which
-- decline it because it is in no pratyahara.  So refusal here is by
-- accident of class membership rather than by a gate, and the assertions
-- below pin the consequence that matters: nothing is invented, nothing
-- past the offending sound is touched, and the count of steps is exactly
-- the count of steps available before it.
------------------------------------------------------------------------

firstUnknown :: [Item] -> Maybe Int
firstUnknown xs = listToMaybe [ i | (i, P s) <- zip [0 ..] xs, isNothing (phoneOf s) ]

-- everything from the first sound outside the alphabet onward
tail_ :: [Item] -> [Item]
tail_ xs = case firstUnknown xs of
             Nothing -> []
             Just i  -> drop i xs

-- (input, expected number of steps, expected index of the stall in the parse)
junk :: [(String, Int, Maybe Int)]
junk =
  [ ("xyz + qqq",           0, Just 0)
  , ("!!! + ???",           0, Just 0)
  , ("3 + 4",               0, Just 0)
  , ("देव + इन्द्र",           0, Just 0)   -- the script the text is written in
  , ("deva + xyz",          0, Just 5)
  , ("xyz + indra",         0, Just 0)
  , ("deva + indra + xyz",  1, Just 11)
  , ("",                    0, Nothing)
  , ("+",                   0, Nothing)
  , ("+ +",                 0, Nothing)
  , ("- -",                 0, Nothing)
  , ("deva+indra",          0, Just 4)     -- no spaces: the `+` is a sound
  ]

stallTests :: [String]
stallTests = concatMap one junk
  where
    one (input, wantSteps, wantStall) =
      let start          = parseInput input
          (steps, final) = deriveTrace start
      in [ "stall " ++ show input ++ ": first unknown at " ++ show (firstUnknown start)
             ++ ", expected " ++ show wantStall
         | firstUnknown start /= wantStall ]
      ++ [ "stall " ++ show input ++ ": " ++ show (length steps)
             ++ " steps, expected " ++ show wantSteps
         | length steps /= wantSteps ]
      ++ [ "stall " ++ show input ++ ": the derivation touched the tail from the"
             ++ " unknown sound: " ++ show (tail_ start) ++ " became "
             ++ show (tail_ final)
         | tail_ start /= tail_ final ]
      ++ [ "stall " ++ show input ++ ": a sound outside the alphabet was INVENTED: "
             ++ show (unknowns final)
         | not (null (unknowns final `without` unknowns start)) ]
      ++ [ "stall " ++ show input ++ ": nothing derives, yet the form changed: "
             ++ show (render final)
         | wantSteps == 0, final /= start ]
    unknowns xs = [ s | P s <- xs, isNothing (phoneOf s) ]
    without a b = [ x | x <- a, x `notElem` b ]

------------------------------------------------------------------------
-- 2a.  THE RULE THAT MUST NOT FIRE.
--
-- A `pratisiddha` entry pins the whole form, which is a blunt instrument:
-- it catches any change that reaches the surface and misses every change
-- that does not.  These pin ONE RULE at ONE JUNCTURE.  8.3.15 says
-- `kharavasanayor visarjaniyah` -- before khaR, or in pause -- so before
-- `n` it must decline, and the mutation that widens khaR to haL is caught
-- here and nowhere else.
--
-- A must-not-fire list alone is satisfied by deleting the rule, so every
-- Ref named below is required to appear in `mustFire` as well.  The two
-- lists together say: this rule is alive, and it is alive under exactly
-- this condition.
------------------------------------------------------------------------

mustNotFire :: [(String, Ref, String)]
mustNotFire =
  [ ("rāmas + naraḥ", (8,3,15), "n is not in khaR and this is not a pause")
  , ("rāmas + hi",    (8,3,15), "h is not in khaR (it is the last śivasūtra, not a khaR)")
  , ("deva + indra",  (6,1,101), "a and i are not savarṇa (1.1.9)")
  , ("mahā + ṛṣi",    (6,1,101), "ā and ṛ are not savarṇa (different sthāna)")
  , ("ne - ana",      (6,1,109), "the juncture is inside a pada, and 6.1.109 needs padāntāt")
  , ("tat + na",      (8,4,40), "n is in stu, not in ścu -- 8.4.40 needs a ścu in contact")
  , ("tat + na",      (8,4,55), "n is not in khaR")
  , ("deva + indra",  (6,1,88), "i is not in eC")
  , ("deva + aiśvarya", (6,1,87), "ai is not in iK -- 6.1.88 is the apavāda here")
  , ("madhu + ari",   (6,1,101), "u and a are not savarṇa")
  , ("vāc",           (8,4,55), "nothing follows -- 8.4.55 needs a khaR after")
  ]

mustFire :: [(String, Ref)]
mustFire =
  [ ("rāmas + ca",     (8,3,15))    -- c IS in khaR
  , ("rāmas",          (8,3,15))    -- and avasāna is the other half of the condition
  , ("dadhi + indra",  (6,1,101))
  , ("ne + ana",       (6,1,109))
  , ("tat + ca",       (8,4,40))
  , ("tat + ca",       (8,4,55))
  , ("deva + aiśvarya",(6,1,88))
  , ("deva + indra",   (6,1,87))
  ]

firedIn :: String -> [Ref]
firedIn input = map stSutra (fst (deriveTrace (parseInput input)))

fireTests :: [String]
fireTests =
  [ "must-not-fire " ++ show input ++ ": " ++ show r ++ " FIRED -- " ++ why
  | (input, r, why) <- mustNotFire, r `elem` firedIn input ]
  ++
  [ "must-fire " ++ show input ++ ": " ++ show r ++ " did not fire; the trace was "
      ++ show (firedIn input)
  | (input, r) <- mustFire, r `notElem` firedIn input ]
  ++
  -- the vacuity guard: a rule that never fires anywhere would satisfy every
  -- must-not-fire check above, so each of them must also be shown alive
  [ "must-not-fire " ++ show r ++ " is vacuous: the rule is not shown firing"
      ++ " anywhere, so deleting it outright would pass"
  | r <- nub [ r | (_, r, _) <- mustNotFire ], r `notElem` map snd mustFire ]

------------------------------------------------------------------------
-- 3.  PARATVA: the answer must be right BECAUSE 1.4.2 says later.
--
-- Each witness names the loser and what the loser alone would have given.
-- The counterfactual form is required to be in `pratisiddha`, so the two
-- halves of the suite cannot drift: if someone deletes the negative test,
-- the order witness fails.
------------------------------------------------------------------------

data Paratva = Paratva
  { vInput    :: String
  , vWinner   :: Ref
  , vLoser    :: Ref
  , vLoserGot :: String    -- what the loser alone produces; must be forbidden
  } deriving (Show)

paratvaWitnesses :: [Paratva]
paratvaWitnesses =
  [ Paratva "dadhi + indra" (6,1,101) (6,1,77) "dadhyindra"
  , Paratva "su + ukta"     (6,1,101) (6,1,77) "svukta"
  , Paratva "kavi + indra"  (6,1,101) (6,1,77) "kavyindra"
  , Paratva "te + api"      (6,1,109) (6,1,78) "tayapi"
  ]

paratvaReason :: String
paratvaReason = "1.4.2"

-- Utsarga/apavada, the OTHER resolution, asserted separately -- the reason
-- must be the elsewhere condition and not paratva.  Deleting the apavada
-- branch of `resolve` changes no form in this corpus (dosha D3), so this is
-- the only check that catches it, and it catches it by the reason.  A test
-- that can only see the surface cannot see this metarule at all.
apavadaWitnesses :: [(String, Ref, Ref)]      -- (input, apavada, utsarga)
apavadaWitnesses =
  [ ("deva + aiśvarya", (6,1,88), (6,1,87))
  , ("deva + eka",      (6,1,88), (6,1,87))
  , ("atra + eva",      (6,1,88), (6,1,87))
  , ("a + ai",          (6,1,88), (6,1,87))
  ]

apavadaTests :: [String]
apavadaTests = concatMap one apavadaWitnesses
  where
    one (input, ex, ut) =
      let steps = fst (deriveTrace (parseInput input))
          hits  = [ st | st <- steps, stSutra st == ex, ut `elem` stBeaten st ]
      in [ "apavāda " ++ show input ++ ": " ++ show ex ++ " never beat "
             ++ show ut ++ "; steps were "
             ++ show [ (stSutra st, stBeaten st) | st <- steps ]
         | null hits ]
      ++ [ "apavāda " ++ show input ++ ": the win was credited to "
             ++ show (stReason st) ++ ", not to the elsewhere condition"
         | st <- hits, not ("apavāda" `isInfixOf` stReason st) ]
      ++ [ "apavāda " ++ show input ++ ": " ++ show ex ++ " is not declared an"
             ++ " apavāda to " ++ show ut ++ " in the sūtra table"
         | ut `notElem` concat [ apavadaTo s | s <- sutras, num s == ex ] ]

paratvaTests :: [String]
paratvaTests = concatMap one paratvaWitnesses ++ invariant ++ vacuity
  where
    one w =
      let steps = fst (deriveTrace (parseInput (vInput w)))
          hits  = [ st | st <- steps, stSutra st == vWinner w
                       , vLoser w `elem` stBeaten st ]
      in [ "paratva " ++ show (vInput w) ++ ": " ++ show (vWinner w)
             ++ " never beat " ++ show (vLoser w) ++ "; steps were "
             ++ show [ (stSutra st, stBeaten st) | st <- steps ]
         | null hits ]
      ++ [ "paratva " ++ show (vInput w) ++ ": the win was not by 1.4.2 -- "
             ++ show (stReason st)
         | st <- hits, not (paratvaReason `isInfixOf` stReason st) ]
      ++ [ "paratva " ++ show (vInput w) ++ ": the winner " ++ show (vWinner w)
             ++ " is NOT later than the loser " ++ show (vLoser w)
             ++ " -- then 1.4.2 is not what decided it"
         | not (vWinner w > vLoser w) ]
      ++ [ "paratva " ++ show (vInput w) ++ ": the loser's form "
             ++ show (vLoserGot w) ++ " is not recorded as forbidden, so this"
             ++ " witness proves nothing about what is refused"
         | not (any (\p -> pInput p == vInput w
                        && vLoserGot w `elem` map fst (pForbidden p)) pratisiddha) ]

    -- The global invariant.  Over every derivation this file runs: a beaten
    -- sutra is EARLIER than the winner, unless the win was by apavada, in
    -- which case the reason must say so.  Break `resolve` and this fires on
    -- every conflict in the corpus at once.
    invariant =
      [ "paratva invariant " ++ show input ++ ": " ++ show (stSutra st)
          ++ " won over " ++ show l ++ " which is LATER, and the reason given"
          ++ " was " ++ show (stReason st)
      | input <- corpus
      , st <- fst (deriveTrace (parseInput input))
      , l <- stBeaten st
      , l > stSutra st
      , paratvaReason `isInfixOf` stReason st ]

    -- A conflict that never happens cannot be evidence.  If the corpus stops
    -- producing conflicts -- because a condition was tightened, say -- the
    -- order witnesses would all pass vacuously, so the count is asserted.
    vacuity =
      let conflicts = [ () | input <- corpus
                           , st <- fst (deriveTrace (parseInput input))
                           , not (null (stBeaten st)) ]
      in [ "paratva: only " ++ show (length conflicts) ++ " conflicts arise in the"
             ++ " whole corpus; the order witnesses are vacuous"
         | length conflicts < length paratvaWitnesses ]

------------------------------------------------------------------------
-- 4.  ASIDDHA: the rule whose condition is met and which is refused.
------------------------------------------------------------------------

data Asiddha = Asiddha
  { aInput   :: String
  , aRefused :: [Ref]     -- exactly these, in this order
  , aWouldBe :: String    -- the form the first refused rule would give
  } deriving (Show)

asiddhaWitnesses :: [Asiddha]
asiddhaWitnesses =
  [ Asiddha "vāc"        [(8,2,39)]            "vāg"
  , Asiddha "k"          [(8,2,39)]            "g"
  , Asiddha "k + k"      [(8,2,39),(8,4,55)]   "g"
  , Asiddha "sā + agacchat" [(8,2,39)]         "sāgacchad"
  ]

asiddhaTests :: [String]
asiddhaTests = concatMap one asiddhaWitnesses ++ negative ++ cycleWitness
  where
    one w =
      let got = map fst (asiddhaAudit (parseInput (aInput w)))
      in [ "asiddha " ++ show (aInput w) ++ ": refused " ++ show got
             ++ ", expected exactly " ++ show (aRefused w)
         | got /= aRefused w ]
      ++ [ "asiddha " ++ show (aInput w) ++ ": the refused rule's output "
             ++ show (aWouldBe w) ++ " WAS produced"
         | derive (aInput w) == aWouldBe w ]
      ++ [ "asiddha " ++ show (aInput w) ++ ": " ++ show r ++ " is refused but is"
             ++ " not earlier than the last rule that fired ("
             ++ show (lastFired (aInput w)) ++ ") -- then 8.2.1 is not what"
             ++ " refused it"
         | r <- aRefused w, Just lf <- [lastFired (aInput w)], not (r < lf) ]

    lastFired input = case map stSutra (fst (deriveTrace (parseInput input))) of
                        [] -> Nothing
                        rs -> Just (maximum rs)

    -- where nothing is refused the audit must be empty, or the audit is
    -- reporting noise and the witnesses above mean nothing
    negative =
      [ "asiddha " ++ show input ++ ": audit should be empty, got "
          ++ show (map fst (asiddhaAudit (parseInput input)))
      | input <- ["deva + indra", "dadhi + indra", "te + api", "ne - ana"
                 ,"tat + jalam", "rāmas", "xyz + qqq"]
      , not (null (asiddhaAudit (parseInput input))) ]

    -- 8.2.1 is what makes the grammar TERMINATE, and the cycle is exhibited
    -- rather than asserted: feed the tripadi its own output and 8.2.39 turns
    -- k back into g, 8.4.56 turns it back into k, forever.  The form is
    -- stable; the derivation is not.
    cycleWitness =
      let out    = derive "vāc"                     -- vak
          again  = fst (deriveTrace (parseInput out))
          forms  = nub (map stAfter again)
      in [ "asiddha cycle: re-deriving " ++ show out ++ " took no steps, so the"
             ++ " 2-cycle 8.2.39 / 8.4.56 is not exhibited and 8.2.1 is not"
             ++ " shown to be what terminates the grammar"
         | length again < 2 ]
      ++ [ "asiddha cycle: re-deriving " ++ show out ++ " did not pass through"
             ++ " the voiced form; it visited " ++ show forms
         | not (any ("ā" `isInfixOf`) forms) || not (any ("g" `isInfixOf`) forms) ]
      ++ [ "asiddha cycle: re-deriving " ++ show out ++ " left " ++ show out
             ++ " and arrived at " ++ show (derive out) ++ "; the form is not"
             ++ " stable under re-entry"
         | derive out /= out ]

------------------------------------------------------------------------
-- 5.  STHANIVADBHAVA, 1.1.56 `sthanivad adeso 'nalvidhau`: a substitute
--     behaves as its substituendum, EXCEPT for a rule that speaks of the
--     sound itself (al-vidhi).
--
-- The al-vidhi direction is assertable and is asserted: 8.2.30 replaces c
-- by k in `vac`, and 8.2.39 -- an al-vidhi, conditioned on the class jhaL
-- -- must see k and give g.  If the substitute were sthanivat for it, it
-- would still be c and 8.2.30's work would be undone.
--
-- The other direction is NOT constructible against this machine and that
-- is recorded in `dosha`, not tested around.  What 1.1.56 transmits is a
-- SAMJNA (dhatu, anga, pratyaya), `Item` has no field for one, and no
-- encoded sutra conditions on one.  The consequence is checked here in the
-- only form available: a derived `ay` and an underlying `ay` are the same
-- object, so nothing downstream could tell them apart even if it wanted to.
------------------------------------------------------------------------

sthanivatTests :: [String]
sthanivatTests = alvidhi ++ noMemory
  where
    -- al-vidhi: the substitute is read by its own form
    alvidhi =
      let steps = map stSutra (fst (deriveTrace (parseInput "vāc")))
      in [ "sthanivat/al-vidhi: 8.2.30 then 8.2.39 is not the order in "
             ++ show steps ++ "; the substitute k was not read as k"
         | take 2 steps /= [(8,2,30),(8,2,39)] ]
      ++ [ "sthanivat/al-vidhi: 8.2.39 fired on c rather than on the substitute k"
         | any (\st -> stSutra st == (8,2,39) && "c" `isInfixOf` stNote st)
               (fst (deriveTrace (parseInput "vāc"))) ]

    -- no memory of the sthanin: the derived form IS the underlying one
    noMemory =
      let derived   = snd (deriveTrace (parseInput "ne - ana"))
          underlying = parseInput "nayana"
      in [ "sthanivat/no-memory: the derived form " ++ show derived
             ++ " differs from the underlying " ++ show underlying
             ++ " -- a substitute now carries something, and dosha D4 is stale"
         | derived /= underlying ]

------------------------------------------------------------------------
-- 5a.  CLAIMS OF EQUIVALENCE, kept live.
--
-- `machine/nigrahasthana-mutants.sh` marks two mutants EQUIVALENT rather
-- than uncaught, and an equivalence claim that nobody rechecks is the same
-- object as an unmeasured constant.  So the ground of each claim is
-- recomputed here, and the suite goes red when it stops holding.
--
-- M10, deleting 1.1.10 `najjhalau`: inert, because in this phonetic table
-- no consonant is Vivrta and no vowel is anything else, so no vowel and
-- consonant ever agree on both sthana and prayatna.  1.1.10 is stated by
-- Panini as an override precisely because a table CAN put a vowel and a
-- consonant together; this one does not, so selfTest's najjhalau check
-- passes with the rule deleted.  Add a Vivrta consonant -- `h` is
-- described as such in some treatments -- and the rule becomes live and
-- this check fires.
------------------------------------------------------------------------

najjhalauCollisions :: [(String, String)]
najjhalauCollisions =
  [ (phName p, phName q)
  | p <- phones, q <- phones
  , phVowel p, not (phVowel q)
  , phSthana p == phSthana q, phPrayatna p == phPrayatna q ]

equivalenceClaims :: [String]
equivalenceClaims =
  [ "1.1.10 najjhalau has become LOAD-BEARING (" ++ show najjhalauCollisions
      ++ "): mutant M10 in nigrahasthana-mutants.sh is no longer equivalent"
      ++ " and must be reclassified, and dosha D8 is stale"
  | not (null najjhalauCollisions) ]

------------------------------------------------------------------------
-- 6.  THE SUITE
------------------------------------------------------------------------

corpus :: [String]
corpus =
  [ "dadhi + indra", "deva + indra", "mahā + indra", "su + ukta"
  , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
  , "te + api", "ne - ana", "ne + ana", "rāmas", "tat + ca", "tat + jalam"
  , "vāc", "kavi + indra", "gaṅgā + udaka", "sat + jana", "deva + eka"
  , "na + asti", "vidyā + arthī", "ko + api", "sā + agacchat", "k + k"
  , "rāmas + naraḥ", "rāmas + hi", "tat + na", "te + a", "vāk + iti"
  ]

-- [] on success, like `Astadhyayi.selfTest`.
nigraha :: [String]
nigraha = concat
  [ pratisiddhaTests
  , stallTests
  , fireTests
  , equivalenceClaims
  , paratvaTests
  , apavadaTests
  , asiddhaTests
  , sthanivatTests
  ]

------------------------------------------------------------------------
-- 7.  THE DEFECT RECORD.
--
-- Each entry: the property that ought to hold, the value that ought to
-- appear, and the value the engine actually produces -- COMPUTED, so that
-- an entry which stops reproducing announces itself and must be deleted.
------------------------------------------------------------------------

dosha :: [(String, String, String)]
dosha =
  [ ( "D1  render is not injective: a pada boundary renders as a space and"
      ++ "\n      parseInput concatenates words, so the engine's own output is"
      ++ "\n      not in its own input language and `derive` is not idempotent."
    , "derive (derive \"rāmas + ca\") == derive \"rāmas + ca\" == \"rāmaḥ ca\""
    , q (derive (derive "rāmas + ca")) ++ " /= " ++ q (derive "rāmas + ca") )

  , ( "D2  no alphabet gate: `tokenize` keeps an unknown character whole and"
      ++ "\n      the rules decline it only because it is in no pratyahara, so"
      ++ "\n      `not Sanskrit` and `no rule applies` are the same output.  The"
      ++ "\n      Devanagari the text is actually written in is `garbage` here."
    , "a form outside the varnasamamnaya is refused with a position"
    , "derive \"देव + इन्द्र\" = " ++ q (derive "देव + इन्द्र")
        ++ ", 0 steps, no diagnostic" )

  , ( "D3  utsarga/apavada is exercised and DECIDES NOTHING.  The grammar"
      ++ "\n      declares one exception, 6.1.88 apavada to 6.1.87, and 88 > 87 --"
      ++ "\n      so 1.4.2 paratva would pick the same rule at every juncture where"
      ++ "\n      they collide.  Deleting the apavada branch of `resolve` outright"
      ++ "\n      leaves every derived FORM in this corpus unchanged; only the"
      ++ "\n      reason string changes.  The elsewhere condition is a claim about"
      ++ "\n      the grammar with no observable consequence in it, and it will"
      ++ "\n      stay one until an apavada EARLIER than its utsarga is encoded --"
      ++ "\n      which is the case that separates the two metarules, and the case"
      ++ "\n      Panini needs the metarule for."
    , "at least one declared apavada is EARLIER than its utsarga"
    , show (length [ () | s <- sutras, u <- apavadaTo s, num s < u ])
        ++ " of " ++ show (length [ () | s <- sutras, _ <- apavadaTo s ])
        ++ " declared apavadas are earlier than their utsarga" )

  , ( "D4  no sthanivadbhava (1.1.56).  `Item` carries no samjna and no"
      ++ "\n      encoded sutra conditions on one, so the designation-inheritance"
      ++ "\n      direction of 1.1.56 has nothing to transmit and nothing to"
      ++ "\n      transmit it to.  A derived form and an underlying one are the"
      ++ "\n      same object."
    , "the derived nayana differs from an underlying nayana"
    , show (snd (deriveTrace (parseInput "ne - ana")))
        ++ " == " ++ show (parseInput "nayana") )

  , ( "D5  a form outside the encoded rules derives anyway, with a complete and"
      ++ "\n      confident sutra trace and no signal that a rule is missing."
      ++ "\n      `tat + siva` needs 8.4.63 `sas cho 'ti` (s -> ch after a stop);"
      ++ "\n      it is not encoded, and the engine emits a form Sanskrit does"
      ++ "\n      not have rather than declining."
    , "derive \"tat + śiva\" == \"tacchiva\", or a refusal"
    , q (derive "tat + śiva") ++ " via "
        ++ show (map stSutra (fst (deriveTrace (parseInput "tat + śiva")))) )

  , ( "D6  same shape as D5 at a different place: `idam + ca` needs 8.3.23"
      ++ "\n      `mo 'nusvarah` (pada-final m -> anusvara before a consonant)."
      ++ "\n      Not encoded, no anusvara in the inventory, no complaint."
    , "derive \"idam + ca\" == \"idaṃ ca\", or a refusal"
    , q (derive "idam + ca") ++ " with "
        ++ show (length (fst (deriveTrace (parseInput "idam + ca")))) ++ " steps" )

  , ( "D7  `stepA` builds the conflict set as everything overlapping the HEAD of"
      ++ "\n      the candidates at the leftmost position, and that list is ordered"
      ++ "\n      by the rule table.  Which rules are even considered for 1.4.2 is"
      ++ "\n      therefore a function of table order, not of the grammar.  Mutant"
      ++ "\n      M12 replaces head by last and no input constructed here"
      ++ "\n      distinguishes them -- an equivalence NOT proved, only unrefuted."
    , "the conflict set is order-independent by construction"
    , "it is `head` of a table-ordered list; no witness found, none excluded" )

  , ( "D8  1.1.10 `najjhalau` is inert in this table: no consonant is Vivrta, so"
      ++ "\n      no vowel and consonant can agree on sthana and prayatna, so the"
      ++ "\n      override is never consulted.  selfTest's `1.1.10: a and h are not"
      ++ "\n      savarna` passes with the rule deleted -- it checks the"
      ++ "\n      consequence, which the prayatna table already gives."
    , "at least one vowel/consonant pair needs the 1.1.10 override"
    , show (length najjhalauCollisions) ++ " such pairs exist" )

  , ( "D9  8.3.15 declines before a non-khaR consonant, correctly, and what it"
      ++ "\n      leaves is `ramar narah` -- the ru-form, bare.  6.1.113 `ato ror"
      ++ "\n      apludad aplute` (r -> u -> o, giving `ramo narah`) is not encoded,"
      ++ "\n      so a correct refusal here still ends in a form Sanskrit does not"
      ++ "\n      have.  The refusal is tested; the gap after it is recorded."
    , "derive \"rāmas + naraḥ\" == \"rāmo naraḥ\""
    , q (derive "rāmas + naraḥ") )
  ]

-- A defect that no longer reproduces is a lie in a file, so it is detected:
-- the two sides of an entry must differ.
doshaStale :: [String]
doshaStale =
  [ "dosha entry no longer reproduces (delete it): " ++ takeWhile (/= '\n') name
  | (name, want, got) <- dosha, want == got ]

report :: [String]
report =
  [ "NIGRAHASTHANA -- what the machine refuses" ]
  ++ [ "" ]
  ++ [ "  forms asserted NOT to derive: "
         ++ show (sum (map (length . pForbidden) pratisiddha))
         ++ " over " ++ show (length pratisiddha) ++ " junctures" ]
  ++ [ "  ill-formed inputs, stall position asserted: " ++ show (length junk) ]
  ++ [ "  order witnesses (1.4.2, loser named): " ++ show (length paratvaWitnesses) ]
  ++ [ "  elsewhere-condition witnesses (apavāda, reason asserted): "
         ++ show (length apavadaWitnesses) ]
  ++ [ "  asiddhatva witnesses (refused rule named by Ref): "
         ++ show (length asiddhaWitnesses) ]
  ++ [ "  rules asserted NOT to fire at a juncture: " ++ show (length mustNotFire) ]
  ++ [ "  and asserted alive elsewhere: " ++ show (length mustFire) ]
  ++ [ "  corpus derivations under the global order invariant: "
         ++ show (length corpus) ]
  ++ [ "" ]
  ++ [ "  checks failing: " ++ show (length nigraha) ]
  ++ [ "  defects on record: " ++ show (length dosha) ]
  ++ doshaStale
