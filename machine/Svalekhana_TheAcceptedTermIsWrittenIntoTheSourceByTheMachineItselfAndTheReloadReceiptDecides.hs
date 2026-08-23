-- स्वलेखन — sva-lekhana, "self-writing" (compound built here, 2026-08-23,
-- at the owner's direction: "the organism itself should edit itself — I
-- want this to be a self-rewriting program. that was always the vision").
-- Ordinary Sanskrit components; no source is claimed for the compound.
--
-- WHAT THIS ORGAN IS.  नाडी drives and verifies but does not mint: a term
-- the kernel ACCEPTS at a hole (`give`) lives only in the warm session,
-- and until now a hand carried it into the file.  This organ closes that
-- loop: the machine writes the accepted term into its own source, reloads
-- itself, and keeps the edit exactly when the reload receipt says the
-- module is whole.  The self-rewrite is licensed twice, both times by the
-- kernel and never by this program:
--
--   1. ACCEPTANCE  — `give <hole> <term>` on the warm conduit; a ✗ here
--                    ends the act with the refusal printed, file untouched.
--   2. RE-ELABORATION — after the textual write, `load` of the edited
--                    file; anything but a clean elaboration with fewer
--                    holes restores the file BYTE-IDENTICAL from the
--                    backup taken first, and prints the kernel's reason.
--
-- द्वौ मार्गौ, तृतीयो न विद्यते: the outcome is either the installed term
-- with its reload receipt, or the refusal with its reason — never a bare
-- success bit, never a silently half-edited file.
--
-- WHAT IT DOES NOT DO.  It proposes nothing (the term arrives from the
-- caller — an agent, a search organ, Tapas's emitter); it does not touch
-- Certificate's store (a source file is not the append-only library; a
-- checked module still enters the corpus by the existing controls); and
-- its hole-matching is v0-textual: the N-th standalone `?` in the file,
-- which is exactly Agda's own numbering of interaction points in a file
-- whose only interaction points are `?`.  Files using `{! ... !}` are
-- refused with that named, not mangled.
--
-- Usage:  Svalekhana REQ RESP FILE HOLE-INDEX TERM...
--   e.g.  Svalekhana /run/req /run/resp Foo.agda 1 cong suc (vama n)

module Main (main) where

import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO
import Data.List (isInfixOf, isPrefixOf)
import GHC.IO.Encoding (setLocaleEncoding, utf8)
import Control.Concurrent (threadDelay)
import Control.Exception (try, IOException)
import System.Process (readCreateProcessWithExitCode, proc, CreateProcess(..))
import System.Environment (getEnvironment)
import System.Exit (ExitCode(..))

-- one exchange on the conduit: write a spell line, read the whole answer.
-- GHC opens FIFOs O_NONBLOCK: a write finding no reader throws ENXIO, and
-- a read finding no writer sees instant EOF — both are "the daemon is not
-- at this end YET", so both retry on a short cadence instead of failing.
ask :: FilePath -> FilePath -> String -> IO String
ask req resp spell = do
  retryWrite (4000 :: Int)
  retryRead (4800 :: Int)
  where
    retryWrite 0 = ioError (userError "conduit: no reader on the request pipe")
    retryWrite k = do
      r <- try (writeFile req (spell ++ "\n")) :: IO (Either IOException ())
      case r of
        Right () -> pure ()
        Left _   -> threadDelay 50000 >> retryWrite (k - 1)
    retryRead 0 = ioError (userError "conduit: no answer on the response pipe")
    retryRead k = do
      h <- openFile resp ReadMode
      a <- hGetContents h
      length a `seq` hClose h
      if null a then threadDelay 50000 >> retryRead (k - 1) else pure a

-- the N-th standalone `?` (token-delimited), replaced; Nothing if absent
replaceHole :: Int -> String -> String -> Maybe String
replaceHole n term src = go n src
  where
    boundary c = c `elem` " \t\n()={};.," -- Agda token delimiters for `?`
    go k ('?':rest)
      | nextOk rest = if k == 0 then Just ("(" ++ term ++ ")" ++ rest)
                      else ('?' :) <$> go (k - 1) rest
    go k (c:rest) = (c :) <$> go k rest
    go _ []       = Nothing
    nextOk []      = True
    nextOk (c:_)   = boundary c

holeCount :: String -> Int
holeCount s = length [ () | l <- lines s, w <- words (map soften l), w == "?" ]
  where soften c = if c `elem` "()={};.," then ' ' else c

main :: IO ()
main = do
  setLocaleEncoding utf8  -- the sources and the conduit both speak UTF-8;
                          -- the container's C locale must not decide that
  args <- getArgs
  case args of
    (req : resp : file : ix : termWords@(_:_)) -> do
      let term = unwords termWords
          n    = read ix :: Int
      src <- readFile file
      length src `seq` pure ()
      if "{!" `isInfixOf` src
        then do putStrLn "अस्वीकृतम्: the file uses {! !} holes; v0 rewrites only bare ? holes"
                exitFailure
        else pure ()
      -- 1. acceptance on the warm conduit, against the CURRENT file state
      _ <- ask req resp ("load " ++ file)
      verdict <- ask req resp ("give " ++ show n ++ " " ++ term)
      if not ("✓" `isPrefixOf` dropWhile (== '\n') verdict || "✓" `isInfixOf` verdict)
        then do putStrLn ("अस्वीकृतम् (the kernel refused the term; file untouched):\n" ++ verdict)
                exitFailure
        else pure ()
      -- 2. the self-write, then re-elaboration as the installing judge
      case replaceHole n term src of
        Nothing -> do
          putStrLn ("अस्वीकृतम्: hole " ++ show n ++ " not found textually; file untouched")
          exitFailure
        Just src' -> do
          writeFile file src'
          receipt <- ask req resp ("load " ++ file)
          let whole  = "छिद्रं नास्ति" `isInfixOf` receipt
              closed = holeCount src' < holeCount src
          if not ((whole || not ("✗" `isInfixOf` receipt)) && closed)
            then do
              writeFile file src
              putStrLn ("प्रत्यावृत्तम् (reload refused the edit; file restored byte-identical):\n"
                        ++ receipt)
              exitFailure
            else if holeCount src' > 0
              -- Intermediate write: later holes remain, so batch cannot yet
              -- judge (a file with interaction holes exits 42 by definition).
              -- The edit stands on the warm receipt alone and SAYS SO.
              then putStrLn
                ("स्वलिखितम् अर्धम् (partial self-write; " ++ show (holeCount src')
                 ++ " hole(s) remain — batch judgment deferred to the last write):\n"
                 ++ receipt)
              else do
                -- Final write: the installing judge is BATCH agda, not the
                -- warm reload — Cmd_load does not surface unsolved implicit
                -- metas, so a conduit-whole file can still exit 42 (the Mauna
                -- incident).  स्वलिखितम् is only pronounced over batch exit 0.
                envs <- getEnvironment
                (code, _, err) <- readCreateProcessWithExitCode
                  (proc "agda" [file]) { env = Just (("LC_ALL", "C.UTF-8") : envs) } ""
                case code of
                  ExitSuccess -> putStrLn
                    ("स्वलिखितम् (the machine wrote itself; warm receipt + batch exit 0):\n"
                     ++ receipt)
                  ExitFailure n -> do
                    writeFile file src
                    putStrLn ("प्रत्यावृत्तम् (warm reload accepted but BATCH refused — exit "
                              ++ show n ++ "; file restored byte-identical):\n"
                              ++ unlines (take 12 (lines err)))
                    exitFailure
    _ -> do
      hPutStrLn stderr "usage: Svalekhana REQ RESP FILE HOLE-INDEX TERM..."
      exitFailure
