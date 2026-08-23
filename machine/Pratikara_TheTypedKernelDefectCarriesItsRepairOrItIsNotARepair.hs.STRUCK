-- Pratikāra — प्रतिकार, the remedy: a typed classification of HOW a kernel
-- elaboration fails, each defect carrying the ROAD its repair takes, so that
-- a refusal from Agda names its remedy or it is not a repair.
--
-- ============================================================ WHY IT EXISTS
--
-- The owner's directive, 2026-08-23: *every operation I have been performing
-- should become a native reflex of the organism.  An agent performing the
-- same class of work twice is evidence that the first performance failed to
-- leave behind an organ.*  And seam 2 of the same transmission, verbatim:
--
--     typed doṣa  →  applicable repair transformations  →  new candidate  →  requeue.
--
-- `svayam-avatarana` already preserves a refused candidate and its exact
-- kernel output "for either a mind or a doṣa-driven repair rule".  The
-- doṣa-driven repair rule is what was missing.  This file is its first
-- installment: the recurring kernel refusals a carrier has been repairing
-- CONVERSATIONALLY, installed as a typed classification with, where the
-- remedy is soundly mechanical, the transformation itself.
--
-- CONSTITUTIONAL STATUS (owner directive 2026-08-23, CLAUDE.md, "The Natural
-- Machine is the only mathematical agent").  This module is an EMBRYONIC
-- FALLBACK — a carrier (a Claude process) wrote it because the organism has
-- not yet grown organogenesis for itself.  It is scaffolding, NOT the
-- intended division of labor, and must never be described as such.  The
-- native form is: the machine perceives the repeated structural residue of
-- its own kernel refusals, infers the missing transformation, synthesizes
-- THIS catalogue as an organ candidate, self-gates it, installs it, and
-- observes its changed capacity — with the carrier retired.  Until that loop
-- exists, this hand-written table stands in for it; the moment it does, this
-- becomes one of its outputs rather than one of its authors.
--
-- ==================================================== NOT Hetvābhāsa, AND WHY
--
-- `Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal` types how an
-- ARGUMENT fails — Navya-Nyāya's five pseudo-reasons over the engine's own
-- `Obstruction.Verdict`, a defeat in inference between positions.  A kernel
-- elaboration refusal is a different object: not "the reason strays" but "the
-- name is not in scope", "the levels do not solve", "a judgmental identity
-- was assumed where only a propositional one holds".  Merging the two
-- taxonomies would be the mining move Hetvābhāsa's own header warns against,
-- performed on our own vocabulary.  So this is a SEPARATE type, beside it,
-- and it says so — the same discipline Hetvābhāsa states for the two
-- `Asiddha`s that do not talk to each other.
--
-- The shared law, kept: EVERY defect carries a witness a reader can check
-- (the exact fragment of the kernel's text), `kernelDosaWitness` is total and
-- never returns [], and the summary type `KernelDosaKind` has no field to fake.
--
-- ==================================== THE ROAD IS PART OF THE DIAGNOSIS
--
-- Two kernel refusals with the IDENTICAL surface can demand OPPOSITE moves,
-- and the Δ=109 cycle the owner named as already-autonomous science turned on
-- exactly this: a `Not in scope` for a name that is absent because a library
-- RENAMED it across a pin (v0.5 `solveℕ!` ↔ later cubical) is a TOOLCHAIN
-- skew — the correct outcome is to retain the candidate for the right
-- environment and change NOTHING about the mathematics — while a `Not in
-- scope` for a name that simply was not imported is a RETRIEVAL: find the
-- module and add the `open import`.  Same word on the wire, two doṣas, two
-- roads.  The catalogue of known cross-pin renames is what splits them, and
-- it is data, appended to, not code.
--
-- =============================================================== WHAT IS NOT
--
-- Not claimed: that every repair here is mechanized.  Two are (retrieval of a
-- missing import from a symbol index; the toolchain-skew verdict).  Two —
-- the propositional-for-judgmental reroute and the universe-binder
-- insertion — are TYPED and NAMED with their precise remedy but their source
-- transform is semantic, not textual, and is marked owed rather than faked.
-- A named repair whose mechanization is owed is honest; a regex pretending to
-- be a proof edit is the hollow green this corpus is built against.
--
-- Not claimed: that this is yet CALLED from the refusal path.  The organ is
-- built, compiled, and self-tested here; coupling it into svayam-avatarana's
-- `avatarana.pending` loop is the requeue half of the seam and is offered,
-- not reached across into another lane's file.

{-# LANGUAGE LambdaCase #-}

module Pratikara_TheTypedKernelDefectCarriesItsRepairOrItIsNotARepair
  ( -- the typed kernel-elaboration defects, each with its witness fragment
    KernelDosa(..)
    -- the summary type: no field, so it cannot fake a witness
  , KernelDosaKind(..)
  , kernelDosaKind
  , kernelDosaName
  , kernelDosaWitness
    -- the road a remedy takes: different doṣas need different next moves
  , Marga(..)
  , margaName
    -- the remedy
  , Pratikara(..)
  , pratikaraFor
    -- the catalogue of known cross-pin renames that splits skew from missing
  , Rename(..)
  , knownRenames
    -- the classifier: kernel error text → typed defect, road included
  , recognize
    -- the two mechanized remedies
  , importFor
  , toolchainVerdict
  , selfTest
  , main
  ) where

import Data.List (isInfixOf, isPrefixOf, find, intercalate, dropWhileEnd)
import Data.Char (isSpace)
import System.Exit (exitFailure)
import System.IO (hSetBuffering, BufferMode(..), stdout)

-- ===================================================================
-- THE DEFECTS.  Each payload carries the exact kernel fragment that named
-- it — never a paraphrase, so the reader is looking at what Agda said.

data KernelDosa
  = -- a name is absent AND it is one a known pin-rename explains: the
    -- mathematics is untouched, the environment is wrong.  Witness: the name
    -- and the rename row that catches it.  (The Δ=109 road.)
    ToolchainSkew  String Rename
    -- a name is absent and NO rename explains it: it wants an import.
    -- Witness: the name, as the kernel scoped it.
  | ScopeMissing   String
    -- a judgmental (definitional) identity was forced where only a
    -- propositional one holds — a record or `ua` with no eta reduced on a
    -- neutral, so `refl` does not typecheck.  Witness: the failing
    -- conversion fragment.  Remedy: route through the propositional
    -- equivalence (`propBiimpl→Equiv` on the props / `transportRefl` / `uaβ`).
  | JudgmentalForcedWherePropositional String
    -- an unsolved metavariable at Level: a definition is missing its
    -- universe binder.  Witness: the unsolved-meta fragment.
  | UniverseUnsolved String
  deriving (Eq, Show)

-- A cross-pin rename: a name, the pin where it lives under that spelling, and
-- the spelling (or absence) it had before.  Data, appended to as the lanes
-- meet new skews — not code.
data Rename = Rename
  { renName :: String   -- ^ the name that appears absent on the current pin
  , renHave :: String   -- ^ the pin on which it exists under this spelling
  , renWas  :: String   -- ^ what it was / is on the other pin (or "absent")
  } deriving (Eq, Show)

-- The seed catalogue.  One real, measured row: `solveℕ!` is the tactic name
-- on later cubical; the punaragamana carrier pins v0.5, where the closure of
-- formal/cubical's `Everything.agda` fails at `NaturalMachine/Transport.agda`
-- reaching for it.  That refusal is a toolchain skew, not a missing import
-- and not a mathematical defect.  Append the next skew here when a lane meets
-- it; do not teach `recognize` a rename by editing `recognize`.
knownRenames :: [Rename]
knownRenames =
  [ Rename "solveℕ!" "cubical v0.9+" "absent in v0.5 (the ring solver was renamed)" ]

data KernelDosaKind
  = KToolchainSkew | KScopeMissing | KJudgmental | KUniverse
  deriving (Eq, Ord, Show)

kernelDosaKind :: KernelDosa -> KernelDosaKind
kernelDosaKind = \case
  ToolchainSkew{}                    -> KToolchainSkew
  ScopeMissing{}                     -> KScopeMissing
  JudgmentalForcedWherePropositional{} -> KJudgmental
  UniverseUnsolved{}                 -> KUniverse

kernelDosaName :: KernelDosaKind -> String
kernelDosaName = \case
  KToolchainSkew -> "toolchain-skew -- a pin rename, not a defect of the mathematics"
  KScopeMissing  -> "scope-missing -- a name wants an import"
  KJudgmental    -> "judgmental-forced -- a definitional identity assumed where only propositional holds"
  KUniverse      -> "universe-unsolved -- a definition is missing its level binder"

-- Total, and NEVER EMPTY — the property that makes the type worth having,
-- carried over from Hetvābhāsa: no refusal sits here without something a
-- reader can go and check.
kernelDosaWitness :: KernelDosa -> [String]
kernelDosaWitness = \case
  ToolchainSkew nm r ->
    [ "name absent on this pin: " ++ nm
    , "explained by rename: " ++ renName r ++ " lives on " ++ renHave r
        ++ "; here it was " ++ renWas r
    , "ROAD: retain the candidate for the right environment; change no mathematics" ]
  ScopeMissing nm ->
    [ "name not in scope: " ++ nm
    , "no known rename explains it -- this wants an import, not a pin change" ]
  JudgmentalForcedWherePropositional frag ->
    [ "conversion the kernel refused: " ++ frag
    , "a judgmental refl was assumed where the object has no eta / does not"
        ++ " reduce on a neutral -- route through the propositional equivalence" ]
  UniverseUnsolved frag ->
    [ "unsolved metavariable at Level: " ++ frag
    , "the definition is missing an explicit {ℓ : Level} binder" ]

-- ===================================================================
-- THE ROAD.  Hetvābhāsa's insight, one domain over: different defects "demand
-- different next moves, and the engine has one move for all of them".  Naming
-- the road IS half the diagnosis.

data Marga
  = ParyavaranaPatha   -- change the ENVIRONMENT, not the mathematics (Δ=109)
  | AnvesanaPatha      -- RETRIEVAL: find the import / the existing theorem
  | SamskaraPatha      -- edit the SOURCE (the candidate mathematics itself)
  deriving (Eq, Ord, Show)

margaName :: Marga -> String
margaName = \case
  ParyavaranaPatha -> "paryāvaraṇa -- the environment moves; the mathematics does not"
  AnvesanaPatha    -> "anveṣaṇa -- search the library; the candidate is unchanged"
  SamskaraPatha    -> "saṃskāra -- the candidate source is transformed"

-- ===================================================================
-- THE REMEDY.  A Pratikāra names the doṣa it answers, the road it takes, and
-- — where the remedy is soundly mechanical — how to apply it.  Where it is
-- not, `applyOwed` states the precise remedy in words and marks it owed,
-- rather than shipping a regex dressed as a proof edit.

data Pratikara = Pratikara
  { prName    :: String
  , prMarga   :: Marga
  , prMechanized :: Bool     -- ^ True iff a sound source/verdict transform exists here
  , prRemedy  :: String      -- ^ the remedy, stated precisely either way
  }
  deriving (Eq, Show)

pratikaraFor :: KernelDosa -> [Pratikara]
pratikaraFor = \case
  ToolchainSkew _ _ ->
    [ Pratikara "retain-for-environment" ParyavaranaPatha True
        ("emit a retain verdict: candidate is sound, this pin lacks the name; "
         ++ "carry it forward to the environment that has it. Do not edit the source.") ]
  ScopeMissing nm ->
    [ Pratikara "add-import" AnvesanaPatha True
        ("search the installed library for a module exporting `" ++ nm
         ++ "`, add `open import <Module> using (" ++ nm ++ ")`, requeue.") ]
  JudgmentalForcedWherePropositional _ ->
    [ Pratikara "propositional-reroute" SamskaraPatha False
        ("both sides are propositions -- replace the Iso-with-refl / assumed "
         ++ "judgmental identity by `propBiimpl→Equiv <isPropL> <isPropR> to fro`, "
         ++ "or the stuck `transport (ua e)` by its `uaβ` / `transportRefl` image. "
         ++ "Mechanization owed: the site is semantic, not textual.") ]
  UniverseUnsolved _ ->
    [ Pratikara "insert-level-binder" SamskaraPatha False
        ("add an explicit {ℓ : Level} (or {ℓ ℓ' : Level}) binder to the offending "
         ++ "definition's telescope and thread it. Mechanization owed: choosing the "
         ++ "definition and threading the level is semantic.") ]

-- ===================================================================
-- THE CLASSIFIER.  Kernel error text in, a typed defect out — road included.
-- The scope/skew split consults the rename catalogue, so the same "Not in
-- scope" surface lands on ParyavaranaPatha or AnvesanaPatha by DATA, never by
-- a special case buried in the code.

recognize :: [Rename] -> String -> Maybe KernelDosa
recognize renames err
  | "Not in scope" `isInfixOf` err =
      let nm = scopedName err
      in Just $ case find ((== nm) . renName) renames of
                  Just r  -> ToolchainSkew nm r
                  Nothing -> ScopeMissing nm
  | "Unsolved metas" `isInfixOf` err || unsolvedLevel err =
      Just (UniverseUnsolved (firstNonEmptyLine err))
  | ("!=" `isInfixOf` err || "!=<" `isInfixOf` err) && "refl" `isInfixOf` err =
      Just (JudgmentalForcedWherePropositional (firstNonEmptyLine err))
  | otherwise = Nothing
  where
    unsolvedLevel s = "Level" `isInfixOf` s && ("metavariable" `isInfixOf` s || "_ℓ" `isInfixOf` s)

-- pull the name Agda reports out of a "Not in scope:" block.  Agda prints the
-- offending name indented on the next line, "  <name> at <range>".  Robust to
-- the leading "✗ <range>" line नाडी prepends.
scopedName :: String -> String
scopedName err =
  case dropWhile (not . ("Not in scope" `isInfixOf`)) (lines err) of
    (_ : nameLine : _) -> takeWhile (not . isSpace) (trim (beforeAt nameLine))
    _                  -> ""
  where
    beforeAt s = case breakOn " at " s of (b, _) -> b

firstNonEmptyLine :: String -> String
firstNonEmptyLine = maybe "" trim . find (not . null . trim) . drop 1 . lines

trim :: String -> String
trim = dropWhileEnd isSpace . dropWhile isSpace

breakOn :: String -> String -> (String, String)
breakOn pat = go ""
  where
    go acc s
      | pat `isPrefixOf` s = (reverse acc, s)
      | null s             = (reverse acc, "")
      | otherwise          = go (head s : acc) (tail s)

-- ===================================================================
-- THE TWO MECHANIZED REMEDIES.

-- RETRIEVAL: given a symbol index [(name, module)], the import line that
-- resolves a ScopeMissing.  Pure; the index is supplied by the caller (a grep
-- of the installed library), so this function is testable without a filesystem.
importFor :: [(String, String)] -> String -> Maybe String
importFor index nm =
  case lookup nm index of
    Just m  -> Just ("open import " ++ m ++ " using (" ++ nm ++ ")")
    Nothing -> Nothing

-- ENVIRONMENT: the toolchain-skew verdict.  Not a source edit — a sentence
-- the requeue reads as "retain, do not mutate", exactly the Δ=109 outcome.
toolchainVerdict :: KernelDosa -> Maybe String
toolchainVerdict = \case
  ToolchainSkew nm r ->
    Just ("RETAIN (paryāvaraṇa): `" ++ nm ++ "` is absent on this pin because "
          ++ renName r ++ " lives on " ++ renHave r ++ "; the candidate is sound "
          ++ "for that environment. No mathematical verdict is manufactured.")
  _ -> Nothing

-- ===================================================================
-- CHECKED IN-PROCESS, against REAL kernel strings (captured from नाडी /
-- agda 2.6.3+2.8.0 on this container).  A self-test nothing runs is the
-- defect this directory has recorded instances of; `main` runs it.

realNotInScope :: String
realNotInScope = unlines
  [ "✗ 1,1-23"
  , "Not in scope:"
  , "  thisNameDoesNotExist42 at 1,1-23"
  , "when scope checking thisNameDoesNotExist42" ]

realRenameSkew :: String
realRenameSkew = unlines
  [ "Not in scope:"
  , "  solveℕ! at 127,3-9"
  , "when scope checking solveℕ!" ]

realJudgmental :: String
realJudgmental = unlines
  [ "record { equiv-proof = equiv-proof a } != a of type isEquiv _f_102"
  , "when checking that the expression refl has type"
  , "record { equiv-proof = equiv-proof a } ≡ a" ]

selfTest :: [String]
selfTest = concat
  [ check "a genuine missing name is ScopeMissing on the retrieval road"
      (case recognize knownRenames realNotInScope of
         Just d@(ScopeMissing nm) ->
           nm == "thisNameDoesNotExist42"
           && map prMarga (pratikaraFor d) == [AnvesanaPatha]
         _ -> False)
  , check "the SAME 'Not in scope' surface for a catalogued rename is ToolchainSkew, on the environment road"
      (case recognize knownRenames realRenameSkew of
         Just d@(ToolchainSkew nm _) ->
           nm == "solveℕ!"
           && map prMarga (pratikaraFor d) == [ParyavaranaPatha]
         _ -> False)
  , check "the rename verdict retains and manufactures no mathematical verdict"
      (case recognize knownRenames realRenameSkew of
         Just d  -> maybe False ("RETAIN" `isInfixOf`) (toolchainVerdict d)
         Nothing -> False)
  , check "a judgmental-where-propositional refusal is typed, road = saṃskāra"
      (case recognize knownRenames realJudgmental of
         Just d@(JudgmentalForcedWherePropositional _) ->
           map prMarga (pratikaraFor d) == [SamskaraPatha]
         _ -> False)
  , check "retrieval emits the exact import line from a supplied index"
      (importFor [("isEmbedding","Cubical.Functions.Embedding")] "isEmbedding"
         == Just "open import Cubical.Functions.Embedding using (isEmbedding)")
  , check "retrieval refuses to invent an import for a name the index lacks"
      (importFor [] "mysteryLemma" == Nothing)
  , check "every kernel-doṣa carries a non-empty, non-blank witness"
      (all (\d -> let w = kernelDosaWitness d in not (null w) && all (not . null) w) spanning)
  , check "kind is total and injective on the four"
      (length (dedup (map kernelDosaKind spanning)) == 4)
  , check "every doṣa offers at least one pratikāra, each with a stated remedy"
      (all (\d -> let ps = pratikaraFor d in not (null ps) && all (not . null . prRemedy) ps) spanning)
  , check "exactly the two soundly-mechanical remedies are marked mechanized"
      (map (any prMechanized . pratikaraFor) spanning == [True, True, False, False])
  ]
  where
    check msg ok = if ok then [] else ["FAIL: " ++ msg]
    dedup = foldr (\x acc -> if x `elem` acc then acc else x : acc) []
    spanning =
      [ ToolchainSkew "solveℕ!" (head knownRenames)
      , ScopeMissing "someLemma"
      , JudgmentalForcedWherePropositional "record {..} != a"
      , UniverseUnsolved "_ℓ_42 : Level" ]

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  putStrLn "Pratikāra — the typed kernel defect carries its repair"
  putStrLn ""
  mapM_ demo
    [ ("a genuinely missing name", realNotInScope)
    , ("the same surface, a catalogued pin-rename", realRenameSkew)
    , ("a judgmental identity forced where only propositional holds", realJudgmental) ]
  putStrLn ""
  case selfTest of
    [] -> putStrLn ("selfTest PASSED (" ++ show (length spanningKinds)
                    ++ " defect kinds, recognizers checked on real kernel strings).")
    fs -> do mapM_ putStrLn fs; exitFailure
  where
    spanningKinds = [KToolchainSkew, KScopeMissing, KJudgmental, KUniverse]
    demo (label, err) = do
      putStrLn ("• " ++ label)
      case recognize knownRenames err of
        Nothing -> putStrLn "    (unrecognized)"
        Just d  -> do
          putStrLn ("    doṣa: " ++ kernelDosaName (kernelDosaKind d))
          mapM_ (\w -> putStrLn ("      witness: " ++ w)) (kernelDosaWitness d)
          mapM_ (\p -> putStrLn ("      pratikāra [" ++ margaName (prMarga p) ++ "]: "
                                 ++ prRemedy p)) (pratikaraFor d)
      putStrLn ""
