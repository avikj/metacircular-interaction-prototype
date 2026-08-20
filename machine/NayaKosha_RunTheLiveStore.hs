-- Run the standpoint store live, against a journal that survives the session.
--
--     runghc -imachine machine/NayaKosha_RunTheLiveStore.hs [journal] [--reset]
--
-- Default journal: machine/naya.kosha
--
-- WHAT HAPPENS.  The journal is read and replayed into a store.  If it is
-- empty the store is seeded with standpoints drawn from this repository,
-- each witness carrying the file it came from, so every line of the seed
-- is checkable by opening the file named.  Questions are then put to the
-- store and the answers appended to the same journal, because the
-- transcript IS the artifact: a verdict without the question and the
-- store state that produced it is not replayable, and an unreplayable
-- verdict is a claim about a run nobody can repeat.
--
-- Running it twice does not rewrite history.  Entries are appended once
-- and never again; questions accumulate.  The last thing `main` does is
-- read the file back off disk, replay it, and check that the replayed
-- store is equal to the one in memory -- so the persistence claim is
-- verified on every run rather than asserted in a comment.
import NayaKosha_TheStandpointStore
import Obstruction (Sthana(..))
import System.Environment (getArgs)
import System.Directory (doesFileExist)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import Data.List (isPrefixOf, intercalate, sort, nub, sortOn, groupBy)
import Data.Function (on)

-- ─────────────────────────────────────────────────────────────── the seed
--
-- Every witness names the file it is read from.  Two entries below hold
-- the SAME content label from DIFFERENT files: that is the case this
-- store exists for and it is not contrived, it is what the repository
-- actually contains.

recordedBy :: String
recordedBy = "naya-kosha, machine/NayaKosha_RunTheLiveStore.hs"

seedEntry :: String -> Yogyata -> [(String, String)] -> Entry
seedEntry n y ws = Entry 0 n y recordedBy "2026-08-20"
                         [ Sakshin a b | (a, b) <- ws ]

theSameClaim :: String
theSameClaim =
  "machine.log carries one claim both affirmed and denied, so a verdict is \
  \a property of the (claim, standpoint) pair and not of the claim"

seed :: [Entry]
seed =
  -- 1 & 2: ONE content label, TWO independent records.  Neither is a copy
  -- of the other's sentence; they were written into different languages by
  -- different hands and say the same thing.
  [ seedEntry "log-carries-both-verdicts"
      (Yogya "read machine/Obstruction.hs, section THE SEVENFOLD POSITIONS")
      [ (theSameClaim, "machine/Obstruction.hs") ]
  , seedEntry "log-carries-both-verdicts"
      (Yogya "read formal/cubical/SaptabhangiNaya.agda, header")
      [ (theSameClaim, "formal/cubical/SaptabhangiNaya.agda") ]

  -- 3: a FIT denial.  Both files above cite machine.log lines 146 and 174
  -- verbatim.  The log has since been regenerated: line 146 today is
  -- `KERNEL-SKIP  unsupported fragment: s(0) = le(x,x)`.  The looking was
  -- fit -- the file was opened at those lines -- and it found nothing, so
  -- this is nāsti and not silence.
  , seedEntry "the-cited-line-numbers-still-resolve"
      (Yogya "opened machine/machine.log at lines 146 and 174 on 2026-08-20")
      []

  -- 4: SILENCE, not denial.  Nobody has looked.
  , seedEntry "the-log-is-content-addressed"
      (Ayogya "no search for a hash, a length or a commit pin on machine.log")
      []

  -- 5 & 6: the checked Unit/Bool witness, as data.  Both inhabited --
  -- equal in truth value -- and inequivalent.
  , seedEntry "Mixed-at-true"
      (Yogya "the fibre is Unit; its inhabitants enumerated exhaustively")
      [ ("tt", "formal/cubical/NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda") ]
  , seedEntry "Mixed-at-false"
      (Yogya "the fibre is Bool; its inhabitants enumerated exhaustively")
      [ ("true",  "formal/cubical/NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda")
      , ("false", "formal/cubical/NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda") ]

  -- 7: containment, so the one-sided case is exercised on real material.
  , seedEntry "python-is-banned"
      (Yogya "read CLAUDE.md, section The substrate: Agda, not Python")
      [ ("Python is banned in this repository", "CLAUDE.md") ]
  , seedEntry "python-is-banned-and-mechanised"
      (Yogya "read CLAUDE.md and the hook and workflow files it names")
      [ ("Python is banned in this repository", "CLAUDE.md")
      , ("the ban is enforced by a hook, a pre-commit and CI, because prose failed",
         "CLAUDE.md") ]
  ]

-- ────────────────────────────────────────────────────────────── questions

data Prccha = Prccha { qTitle :: String, qSaha :: Bool, qNames :: [String] }

questions :: [Prccha]
questions =
  [ Prccha "one content, two records -- asserted at once (saha)" True
      ["log-carries-both-verdicts", "log-carries-both-verdicts"]
  , Prccha "the same two, in succession (krama)" False
      ["log-carries-both-verdicts", "log-carries-both-verdicts"]
  , Prccha "truth-equal and content-distinct: the Unit/Bool case" False
      ["Mixed-at-true", "Mixed-at-false"]
  , Prccha "three at once: two agree, one does not" False
      ["log-carries-both-verdicts", "log-carries-both-verdicts", "Mixed-at-true"]
  , Prccha "one affirms, one denies, and the denial's looking WAS fit" True
      ["log-carries-both-verdicts", "the-cited-line-numbers-still-resolve"]
  , Prccha "the same shape, but the second one nobody looked for" True
      ["log-carries-both-verdicts", "the-log-is-content-addressed"]
  , Prccha "containment: one standpoint's content inside another's" False
      ["python-is-banned", "python-is-banned-and-mechanised"]
  ]

-- A question names standpoints BY NAME, and a name is not an index, so
-- resolution returns every entry with that name and the duplicate names
-- in the query pick out successive ones.  Resolving a name to one entry
-- would be the collapse, committed by the query layer.
resolve :: Kosha -> [String] -> [Entry]
resolve k = go []
  where
    go _ [] = []
    go used (n:ns) =
      case [ e | e <- byName k n, entId e `notElem` used ] of
        (e:_) -> e : go (entId e : used) ns
        []    -> case byName k n of
                   (e:_) -> e : go used ns
                   []    -> go used ns

-- ─────────────────────────────────────────────────────────── index report

indexReport :: Kosha -> [String]
indexReport k =
  [ "-- the store, at three indices --------------------------------------"
  , "  entries held: " ++ show (length es)
  , ""
  , "  by NAME (a name is not an index; lookup returns a list):"
  ] ++
  [ "      " ++ n ++ " -> " ++ intercalate ", " (map (('#':) . show . entId) g)
    ++ (if length g > 1 then "   <- namasankara, both kept" else "")
  | (n, g) <- byKey entName ] ++
  [ "", "  by ARTHA (content: the witness labels):" ] ++
  [ "      { " ++ intercalate ", " (map (('#':) . show . entId) g) ++ " }"
    ++ note a g
  | (a, g) <- byKey artha ] ++
  [ "", "  by SATYA (truth value only -- the coarsest, and never sufficient):" ] ++
  [ "      " ++ showSatya s ++ " -> "
    ++ intercalate ", " (map (('#':) . show . entId) g)
  | (s, g) <- byKey satya ]
  where
    es = koshaEntries k
    byKey :: Ord a => (Entry -> a) -> [(a, [Entry])]
    byKey f = map (\g -> (f (head g), g))
            . groupBy ((==) `on` f) . sortOn f $ es
    -- Empty content is ABSENCE of content, not agreement in it.  Grouping
    -- by the empty set is what the grouping function does; calling that
    -- grouping "collapsible" would be a YES made out of nothing, which is
    -- defect D4 and is refused here as it is refused in `decide`.
    note a g
      | null a && length g > 1 = "   <- grouped by ABSENCE of content; NOT agreement (D4)"
      | length g > 1           = "   <- collapsible AS CONTENT"
      | otherwise              = ""
    showSatya (Just True)  = "asti      "
    showSatya (Just False) = "nasti     "
    showSatya Nothing      = "silence   "

-- ───────────────────────────────────────────────────────────────── main

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  args <- getArgs
  let path  = case [ a | a <- args, not ("--" `isPrefixOf` a) ] of
                (p:_) -> p
                []    -> "machine/naya.kosha"
      reset = "--reset" `elem` args

  existing <- do
    ok <- doesFileExist path
    if ok && not reset then lines <$> readFile2 path else pure []
  if reset then writeFile path "" else pure ()

  k0 <- case replay existing of
          Left err -> ioError (userError err)
          Right k  -> pure k

  putStrLn "=== NAYAKOSA: a store that holds many standpoints and refuses to merge them ==="
  putStrLn ("journal: " ++ path ++ "  (" ++ show (length (koshaEntries k0))
            ++ " entries replayed off disk)")

  -- Seed only if the store is empty.  Re-running never re-seeds, which is
  -- why the journal is a history and not a scratch file.
  (k1, newLines) <-
    if null (koshaEntries k0)
      then do
        putStrLn "\n-- seeding: every insertion reports every relation it finds ----------"
        let step (k, ls) e =
              let (i, rels, k') = insert e k
              in ( (k', ls ++ [lineOf (head [ x | x <- koshaEntries k', entId x == i ])])
                 , (i, entName e, rels) )
            (kv, reports) = mapAccumL' step (k0, []) seed
        mapM_ (\(i, nm, rels) -> do
                 putStrLn ("  #" ++ show i ++ "  " ++ nm)
                 mapM_ (\r -> putStrLn ("        " ++ sambandhaGloss r)) rels)
              reports
        pure (fst kv, snd kv)
      else pure (k0, [])

  putStrLn ""
  mapM_ putStrLn (indexReport k1)

  -- The questions.  Each one is written to the journal with its answer.
  let seqStart = length [ l | l <- existing, "PRCCHA\t" `isPrefixOf` l ]
  qLines <- mapM (ask k1) (zip [seqStart ..] questions)

  appendFile path (unlines (newLines ++ concat qLines))

  -- The persistence claim, checked rather than asserted.
  back <- lines <$> readFile2 path
  case replay back of
    Left err -> putStrLn ("\nREPLAY FAILED: " ++ err)
    Right k2 -> do
      putStrLn ""
      putStrLn ("-- replay check: store read back off disk is "
                ++ (if k2 == k1 then "IDENTICAL" else "DIFFERENT -- DEFECT")
                ++ " ------")
      putStrLn ("   round trip through the journal: "
                ++ (if prop_roundtrip k2 then "holds" else "FAILS"))

  putStrLn ""
  putStrLn "-- self-test ---------------------------------------------------------"
  mapM_ (\(n, b) -> putStrLn ((if b then "  ok    " else "  FAIL  ") ++ n)) selfTest
  putStrLn ("  " ++ show (length (filter snd selfTest)) ++ " / "
            ++ show (length selfTest) ++ " pass")

ask :: Kosha -> (Int, Prccha) -> IO [String]
ask k (n, q) = do
  let es = resolve k (qNames q)
      v  = decide (qSaha q) es
      hdr = "== Q" ++ show n ++ ". " ++ qTitle q
  putStrLn ""
  putStrLn (hdr ++ " " ++ replicate (max 0 (70 - length hdr)) '=')
  putStrLn ("  standpoints: "
            ++ intercalate ", " [ "#" ++ show (entId e) ++ " " ++ entName e | e <- es ])
  putStrLn ("  arpana: " ++ (if qSaha q then "SAHA (at once)" else "KRAMA (in succession)"))
  putStrLn ""
  mapM_ putStrLn (render v)
  pure ( [ "PRCCHA\t" ++ show n ++ "\t" ++ (if qSaha q then "saha" else "krama")
           ++ "\t" ++ intercalate "," (map (show . entId) es)
           ++ "\t" ++ esc (qTitle q)
         , "UTTARA\t" ++ show n ++ "\t" ++ esc (summary v) ]
         ++ [ "VAKYA\t" ++ show n ++ "\t" ++ esc l | l <- render v ] )

summary :: Nirnaya -> String
summary (Abhinna m) = "abhinna: " ++ m
summary v = show (nirSthana v) ++ " at "
            ++ maybe "no shared index" samataName (nirSamata v)

-- Local, so the module has no dependency outside base + directory.
mapAccumL' :: (a -> b -> (a, c)) -> a -> [b] -> (a, [c])
mapAccumL' f z0 xs0 = go z0 xs0
  where go z []     = (z, [])
        go z (x:xs) = let (z', y) = f z x
                          (z'', ys) = go z' xs
                      in (z'', y : ys)

readFile2 :: FilePath -> IO String
readFile2 p = do
  h <- openFile p ReadMode
  hSetEncoding h utf8
  s <- hGetContents h
  length s `seq` pure s
