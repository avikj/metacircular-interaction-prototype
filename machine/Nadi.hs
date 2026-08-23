-- नाडी — the warm conduit to the kernel, in the machine's own language.
--
-- Holds one `agda --interaction-json` process WARM (library loaded once)
-- and answers typed questions in milliseconds, where the batch interface
-- is a one-bit cut (exit code + first error, minutes of cold
-- re-elaboration).  Rewritten from the js prototype into Haskell so it
-- lives in the same substrate as the rest of machine/ and so the spell
-- layer (मन्त्र) can `import Astadhyayi` and share pratyāhāra/anuvṛtti as
-- the actual functions rather than a foreign reimplementation.
--
-- Transport is two FIFOs (pure base + unix; no socket dependency): the
-- daemon reads one JSON command line from the request pipe, feeds the
-- kernel, collects its JSON until the terminal message, and writes a
-- condensed answer to the response pipe.  Completion is SEMANTIC — a
-- load ends at its InteractionPoints, a query at its DisplayInfo — with a
-- per-read timeout only as a distant fallback.
--
-- Build:  (cd formal/cubical && ghc -O2 -i../../machine ../../machine/Nadi.hs -o /tmp/nadi)
-- Run:    from formal/cubical so the library resolves:  /tmp/nadi REQ RESP
-- Ask:    the `nadi` shell client writes a command line and cats the reply.
--
-- The channel is a RAW STREAM in the KERNEL'S OWN operations — no JSON, no
-- quotes, minimal overhead.  Coprocessing: the agent DRIVES the kernel and
-- the kernel verifies in ~60ms; the machine PUSHES its own frontier back.
-- One line: an action then the raw Agda term.
--
--   reading the kernel:
--     load /abs/Module.agda      elaborate warm (Cmd_load) — NaturalMachine
--     type <expr>                infer the type   (Cmd_infer_toplevel)
--     norm <expr>                normal form      (Cmd_compute_toplevel)
--     goals                      open goals       (Cmd_metas)
--     goal <id>                  one goal's type  (Cmd_goal_type)
--     context <id>               goal + its context (Cmd_goal_type_context)
--   DRIVING the kernel (agent proposes, kernel verifies):
--     give <id> <term>           does this term fill the hole? (Cmd_give)
--     refine <id> <term>         partial fill, new holes (Cmd_refine_or_intro)
--     split <id> <var>           case-split; kernel writes clauses (Cmd_make_case)
--     solve                      the kernel fills what it can (Cmd_solveAll)
--     raw  IOTCM …               the full interaction protocol, verbatim
--   the PUSH back-channel (the machine posts where it is stuck):
--     frontier                   engine's last round + the body's heartbeat
--
-- Boundary: `give` is a real kernel check but not Certificate-wrapped;
-- INSTALLING a given term into the library still goes through Certificate's
-- two controls.  नाडी drives and verifies; it does not mint receipts.
--
-- The actions are Agda's own Cmd_* under thin abbreviation — NOT invented
-- vocabulary.  An earlier draft dressed them as Sanskrit nouns (रूप, सार);
-- that was fabrication, struck.  The precise minimal-overhead SEMANTIC
-- grammar for richer, multi-argument scenes is not invented here either:
-- it is Pāṇini's kāraka layer, already in Astadhyayi.hs —
--
--     kāraka (role) → vibhakti (case) → sandhi,  input a Drshya =
--     [(Karaka, String)], word order free because the ending carries the
--     role, and 2.3.1 anabhihite the gate that drops what is already
--     expressed (the minimal-overhead principle, stated ~500 BCE).
--
-- When this conduit grows a scene grammar it will `import Astadhyayi`
-- and use Karaka/Vibhakti/vibhaktiOf directly, not a parallel invention.
-- Answers come back dense: ⊢ type, ↝ normal form, ? goal, ✗ error.
-- (Agda speaks JSON on --interaction-json; नाडी condenses it so the agent
-- never sees a brace.)

{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import System.Environment (getArgs)
import System.IO
import System.Process
import System.Posix.Files (createNamedPipe, fileExist, unionFileModes, ownerReadMode, ownerWriteMode)
import System.Posix.IO (openFd, fdToHandle, OpenMode(..), defaultFileFlags, OpenFileFlags(..))
import System.Timeout (timeout)
import Control.Exception (catch, SomeException, try)
import Control.Monad (unless, when, forever)
import Data.IORef
import Data.List (isPrefixOf, isInfixOf, stripPrefix)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Aeson as A
import Data.Aeson (Value(..), (.:), (.:?))
import qualified Data.Aeson.Types as AT
import qualified Data.Aeson.KeyMap as KM
import qualified Data.Text as T
import qualified Data.Vector as V
import qualified Astadhyayi as P   -- the completed six-kāraka layer, imported (not reinvented)

-- ── the spell stream: a raw line → an action ──────────────────────────────
-- Kind Load/Query go to the kernel; Push reads the machine's own frontier
-- (the coprocessing back-channel — the machine posting what it is stuck on).
data Kind = Load | Query | Push deriving Eq

parseSpell :: IORef (Maybe String) -> String -> IO (Maybe (Kind, String))
parseSpell ctxRef line = do
  ctx <- readIORef ctxRef
  let esc = concatMap (\c -> case c of '\\' -> "\\\\"; '"' -> "\\\""; _ -> [c])
      wrap f cmd = "IOTCM \"" ++ f ++ "\" None Indirect (" ++ cmd ++ ")\n"
      ws = words line
  case ws of
    [] -> pure Nothing
    (v : rest) ->
      let arg  = unwords rest
          arg2 = unwords (drop 1 rest) in
      if      v == "load"
        then case rest of
               (f:_) -> writeIORef ctxRef (Just f)
                        >> pure (Just (Load, wrap f ("Cmd_load \"" ++ esc f ++ "\" []")))
               _     -> pure Nothing
      -- reading the kernel
      else if v == "type"
        then ctxQ ctx (\f -> wrap f ("Cmd_infer_toplevel Simplified \"" ++ esc arg ++ "\""))
      else if v == "norm"
        then ctxQ ctx (\f -> wrap f ("Cmd_compute_toplevel DefaultCompute \"" ++ esc arg ++ "\""))
      else if v == "goals"
        then ctxQ ctx (\f -> wrap f "Cmd_metas Simplified")
      else if v == "goal"
        then withId ctx rest (\f n -> wrap f ("Cmd_goal_type Simplified " ++ n ++ " noRange \"\""))
      else if v == "context"
        then withId ctx rest (\f n -> wrap f ("Cmd_goal_type_context Simplified " ++ n ++ " noRange \"\""))
      -- DRIVING the kernel: the agent proposes, the kernel verifies in ~60ms
      else if v == "give"    -- give <id> <term> : does this term fill the hole?
        then case (ctx, rest) of
               (Just f, (n:_)) -> pure (Just (Query, wrap f
                 ("Cmd_give WithoutForce " ++ n ++ " noRange \"" ++ esc arg2 ++ "\"")))
               _ -> pure Nothing
      else if v == "refine"  -- refine <id> <term> : partial fill, new holes
        then case (ctx, rest) of
               (Just f, (n:_)) -> pure (Just (Query, wrap f
                 ("Cmd_refine_or_intro False " ++ n ++ " noRange \"" ++ esc arg2 ++ "\"")))
               _ -> pure Nothing
      else if v == "split"   -- split <id> <var> : case-split; kernel writes clauses
        then case (ctx, rest) of
               (Just f, (n:_)) -> pure (Just (Query, wrap f
                 ("Cmd_make_case " ++ n ++ " noRange \"" ++ esc arg2 ++ "\"")))
               _ -> pure Nothing
      else if v == "solve"   -- solveAll: the kernel fills every hole it can
        then ctxQ ctx (\f -> wrap f "Cmd_solveAll Simplified")
      else if v == "raw"
        then pure (Just (Query, arg ++ "\n"))
      -- a KĀRAKA SCENE (Pāṇini's minimal-overhead grammar): the action
      -- साधन (accomplish) with role-marked arguments, ANY order —
      --   sadh अधिकरण <hole> करण <proof-term>
      -- adhikaraṇa = the locus (the hole), karaṇa = the instrument (the
      -- term that proves it).  The case-mark carries the role, so order is
      -- free.  Roles from Astadhyayi's six; this maps the scene to Cmd_give.
      else if v == "sadh" || v == "साधन"
        then case ctx of
               Nothing -> pure Nothing
               Just f  ->
                 let scene = parseScene rest
                     hole  = lookup P.Adhikarana scene
                     term  = case lookup P.Karana scene of
                               Just t  -> Just t
                               Nothing -> lookup P.Karman scene
                 in case (hole, term) of
                      (Just n, Just t) -> pure (Just (Query, wrap f
                        ("Cmd_give WithoutForce " ++ n ++ " noRange \"" ++ esc t ++ "\"")))
                      _ -> pure Nothing
      -- the push back-channel: the machine's frontier / live event stream,
      -- not kernel calls.  frontier = snapshot; watch = new events since last.
      else if v == "frontier"
        then pure (Just (Push, "frontier"))
      else if v == "watch"
        then pure (Just (Push, "watch"))
      else pure Nothing
  where
    ctxQ Nothing  _  = pure Nothing
    ctxQ (Just f) mk = pure (Just (Query, mk f))
    withId Nothing  _ _        = pure Nothing
    withId (Just f) (n:_) mk   = pure (Just (Query, mk f n))
    withId _        []    _    = pure Nothing

-- a role-word (Sanskrit or latin) → a kāraka.  The vocabulary is Pāṇini's;
-- nothing invented.
roleWord :: String -> Maybe P.Karaka
roleWord w = case w of
  "कर्तृ"     -> Just P.Kartr      ; "kartr"      -> Just P.Kartr
  "कर्म"      -> Just P.Karman     ; "karman"     -> Just P.Karman
  "करण"      -> Just P.Karana     ; "karana"     -> Just P.Karana
  "सम्प्रदान"  -> Just P.Sampradana ; "sampradana" -> Just P.Sampradana
  "अपादान"    -> Just P.Apadana    ; "apadana"    -> Just P.Apadana
  "अधिकरण"    -> Just P.Adhikarana ; "adhikarana" -> Just P.Adhikarana
  _           -> Nothing

-- split a token stream into role→filler pairs.  A role-word opens a new
-- argument; following non-role tokens accumulate as its filler (spaces
-- preserved), so word order is free and multi-word terms need no quoting.
parseScene :: [String] -> [(P.Karaka, String)]
parseScene = go Nothing []
  where
    go cur acc [] = flush cur acc
    go cur acc (w:ws) = case roleWord w of
      Just k  -> go (Just (k, [])) (flush cur acc) ws
      Nothing -> case cur of
        Just (k, fs) -> go (Just (k, fs ++ [w])) acc ws
        Nothing      -> go Nothing acc ws            -- tokens before any role: ignored
    flush Nothing       acc = acc
    flush (Just (k,fs)) acc = acc ++ [(k, unwords fs)]

-- ── is this agda output line the terminal message for the pending kind? ───
terminal :: Kind -> Value -> Bool
terminal k (Object o) = case KM.lookup "kind" o of
  Just (String "DisplayInfo")       -> k == Query || isErr
  Just (String "GiveAction")        -> k == Query   -- give succeeded
  Just (String "MakeCase")          -> k == Query   -- split produced clauses
  Just (String "SolveAll")          -> k == Query
  Just (String "InteractionPoints") -> k == Load
  _ -> False
  where isErr = case KM.lookup "info" o of
                  Just (Object i) -> KM.lookup "kind" i == Just (String "Error")
                  _ -> False
terminal _ _ = False

-- ── condense agda's JSON into dense lines ─────────────────────────────────
condense :: [Value] -> String
condense vs = unlines (concatMap one vs)
  where
    one (Object o) = case KM.lookup "kind" o of
      Just (String "DisplayInfo") -> case KM.lookup "info" o of
        Just (Object i) -> info i
        _ -> []
      Just (String "GiveAction") -> case KM.lookup "giveResult" o of
        Just (Object g) -> ["✓ given: " ++ str (KM.lookup "str" g)]
        _ -> ["✓ given"]
      Just (String "MakeCase") -> case KM.lookup "clauses" o of
        Just (Array a) -> "⋔ clauses:" : [ "    " ++ str (Just c) | c <- V.toList a ]
        _ -> ["⋔ split"]
      Just (String "InteractionPoints") -> case KM.lookup "interactionPoints" o of
        Just (Array a) | not (V.null a) ->
          ["holes: " ++ unwords [ show (round n :: Int)
                                | Object p <- V.toList a, Just (Number n) <- [KM.lookup "id" p] ]]
        _ -> []
      _ -> []
    one _ = []
    info i = case KM.lookup "kind" i of
      Just (String "InferredType") -> ["⊢ " ++ str (KM.lookup "expr" i)]
      Just (String "NormalForm")   -> ["↝ " ++ str (KM.lookup "expr" i)]
      Just (String "GoalSpecific") -> case KM.lookup "goalInfo" i of
        Just (Object g) -> ["? " ++ str (KM.lookup "type" g)]
        _ -> []
      Just (String "AllGoalsWarnings") -> case KM.lookup "visibleGoals" i of
        Just (Array a) | not (V.null a) ->
          "छिद्राणि:" : [ "  ?" ++ gid p ++ " : " ++ str (KM.lookup "type" p) | Object p <- V.toList a ]
        _ -> ["छिद्रं नास्ति"]
      Just (String "Error") -> ["✗ " ++ errmsg (KM.lookup "error" i)]
      _ -> []
    gid p = case KM.lookup "constraintObj" p of
              Just (Object c) -> case KM.lookup "id" c of Just (Number n) -> show (round n :: Int); _ -> "?"
              _ -> "?"
    str (Just (String t)) = T.unpack t
    str _ = ""
    errmsg (Just (Object e)) = str (KM.lookup "message" e)
    errmsg _ = "(error)"

-- ── the collect loop: read agda stdout until the terminal message ─────────
collect :: Handle -> Kind -> IO [Value]
collect out k = go []
  where
    go acc = do
      ml <- timeout (20 * 1000000) (tryLine out)
      case ml of
        Nothing        -> pure (reverse acc)           -- fallback: kernel quiet
        Just Nothing   -> pure (reverse acc)           -- EOF
        Just (Just ln) ->
          let clean = maybe ln id (stripPrefix "JSON> " ln)
          in if null (dropWhile (== ' ') clean) then go acc
             else case A.decode (BL.pack clean) of
                    Just v | terminal k v -> pure (reverse (v : acc))
                           | otherwise    -> go (v : acc)
                    Nothing -> go acc

tryLine :: Handle -> IO (Maybe String)
tryLine h = do
  r <- try (hGetLine h) :: IO (Either SomeException String)
  pure (either (const Nothing) Just r)

-- ── the daemon ────────────────────────────────────────────────────────────
main :: IO ()
main = do
  args <- getArgs
  case args of
    [reqF, respF] -> run reqF respF
    ["-"]         -> runStdin
    _             -> runStdin   -- default: warm stream on stdin/stdout
  where
    -- stdin/stdout mode: one process, library warm, a script of spell
    -- lines answered in order against warm state.  This is the core the
    -- FIFO daemon wraps; it needs no plumbing and no cwd rendezvous.
    runStdin = do
      hSetEncoding stdout utf8; hSetEncoding stderr utf8; hSetEncoding stdin utf8
      hSetBuffering stdout LineBuffering
      (Just ain, Just aout, _, _) <- createProcess
        (proc "agda" ["--interaction-json"])
          { std_in = CreatePipe, std_out = CreatePipe, std_err = Inherit }
      hSetBuffering ain LineBuffering
      hSetEncoding ain utf8; hSetEncoding aout utf8
      ctxRef <- newIORef Nothing
      watchRef <- newIORef 0
      let loop = do
            eof <- isEOF
            if eof then pure () else do
              line <- getLine
              resp <- respond ain aout ctxRef watchRef line
              putStr resp; hFlush stdout
              loop
      loop
    run reqF respF = do
      hSetEncoding stdout utf8; hSetEncoding stderr utf8
      mkFifo reqF; mkFifo respF
      (Just ain, Just aout, _, _) <- createProcess
        (proc "agda" ["--interaction-json"])
          { std_in = CreatePipe, std_out = CreatePipe, std_err = Inherit }
      hSetBuffering ain LineBuffering
      hSetEncoding ain utf8; hSetEncoding aout utf8
      ctxRef <- newIORef Nothing
      watchRef <- newIORef 0
      hPutStrLn stderr "नाडी warm; waiting on the request pipe"
      forever $ do
        line <- readOne reqF
        resp <- respond ain aout ctxRef watchRef line
        writeOne respF resp

    -- one shared responder for both transports: parse the spell, drive the
    -- kernel (Load/Query) or read the machine's push channel (Push).
    respond ain aout ctxRef watchRef line = do
      mcmd <- parseSpell ctxRef line
      case mcmd of
        Nothing                 -> pure "✗ unknown or contextless command\n"
        Just (Push, "watch")    -> watchNew watchRef
        Just (Push, _)          -> frontier
        Just (k, iotcm)         -> do
          hPutStr ain iotcm; hFlush ain
          vs <- collect aout k
          pure (condense vs)

    -- live stream: the sensorium journal is the shared tape; return the
    -- events appended since the last watch, condensed to organ + gist.
    watchNew watchRef = do
      seen <- readIORef watchRef
      ls <- lines <$> readUtf8Safe2 ["machine/aisthesis.jsonl", "../../machine/aisthesis.jsonl"]
      let n = length ls
          fresh = drop seen ls
      writeIORef watchRef n
      if null fresh then pure "मौनम् (no new events)\n"
        else pure (unlines (map gist fresh))
      where
        gist l = "· " ++ field "indriya" l ++ " · " ++ field "kriya" l
        field k s = case breakOn ("\"" ++ k ++ "\":\"") s of
                      Just r  -> takeWhile (/= '"') r
                      Nothing -> "—"
        breakOn key s
          | key `isPrefixOf` s = Just (drop (length key) s)
          | null s             = Nothing
          | otherwise          = breakOn key (tail s)

    -- the push channel: the machine posts where it is stuck.  Fast (no jiva
    -- run): the last engine round from machine.log and the last heartbeat
    -- from the sensorium journal — the frontier as the organism last saw it.
    frontier = do
      lg <- lastMatching "machine.log" "round "
      hb <- lastMatching "aisthesis.jsonl" "heartbeat"
      pure ("अग्रसीमा (frontier):\n  engine: " ++ lg ++ "\n  body:   " ++ hb ++ "\n")

    -- नाडी runs from formal/cubical (for the library); the machine's own logs
    -- live at repo-root/machine.  Try both so the push channel resolves
    -- wherever the daemon was started.
    lastMatching name needle = go ["machine/" ++ name, "../../machine/" ++ name]
      where
        go [] = pure "(none)"
        go (p:ps) = do
          e <- fileExist p
          if not e then go ps else do
            s <- readUtf8Safe p
            let hits = [ l | l <- lines s, needle `isInfixOf` l ]
            pure (if null hits then "(none)" else last hits)

    readUtf8Safe p = catch
      (do h <- openFile p ReadMode; hSetEncoding h utf8; c <- hGetContents h
          length c `seq` hClose h; pure c)
      (\(_ :: SomeException) -> pure "")

    readUtf8Safe2 []     = pure ""
    readUtf8Safe2 (p:ps) = do
      e <- fileExist p
      if e then readUtf8Safe p else readUtf8Safe2 ps

    mkFifo f = do
      e <- fileExist f
      unless e $ createNamedPipe f (unionFileModes ownerReadMode ownerWriteMode)

    -- POSIX blocking open: ReadOnly on a FIFO blocks until a writer,
    -- WriteOnly until a reader — the rendezvous.  GHC's openFile forces
    -- O_NONBLOCK, which makes a write-open with no reader fail ENXIO; this
    -- opens with nonBlock=False and converts the fd to a handle.
    blockingHandle f mode = do
      fd <- openFd f mode Nothing defaultFileFlags { nonBlock = False }
      h  <- fdToHandle fd
      hSetEncoding h utf8
      pure h

    -- one request line: blocks until a client writes
    readOne f = do
      h <- blockingHandle f ReadOnly
      l <- catch (hGetLine h) (\(_ :: SomeException) -> pure "")
      hClose h
      pure l

    -- one response: blocks until the client opens for read
    writeOne f s = do
      h <- blockingHandle f WriteOnly
      hPutStr h s
      hClose h
