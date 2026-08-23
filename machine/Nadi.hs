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
-- quotes, minimal overhead.  One line: an action then the raw Agda term:
--
--   load /abs/Module.agda        elaborate warm (Cmd_load)
--   type <expr>                  infer the type   (Cmd_infer_toplevel)
--   norm <expr>                  normal form      (Cmd_compute_toplevel)
--   goals                        open goals       (Cmd_metas)
--   goal <id>                    one goal's type  (Cmd_goal_type)
--   raw  IOTCM …                 the full interaction protocol, verbatim
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
import Data.List (isPrefixOf, stripPrefix)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Aeson as A
import Data.Aeson (Value(..), (.:), (.:?))
import qualified Data.Aeson.Types as AT
import qualified Data.Aeson.KeyMap as KM
import qualified Data.Text as T
import qualified Data.Vector as V

-- ── the spell stream: a raw line → IOTCM string ───────────────────────────
data Kind = Load | Query deriving Eq

parseSpell :: IORef (Maybe String) -> String -> IO (Maybe (Kind, String))
parseSpell ctxRef line = do
  ctx <- readIORef ctxRef
  let esc = concatMap (\c -> case c of '\\' -> "\\\\"; '"' -> "\\\""; _ -> [c])
      wrap f cmd = "IOTCM \"" ++ f ++ "\" None Indirect (" ++ cmd ++ ")\n"
      ws = words line
  case ws of
    [] -> pure Nothing
    (v : rest) ->
      let arg = unwords rest in
      if      v == "load"
        then case rest of
               (f:_) -> writeIORef ctxRef (Just f)
                        >> pure (Just (Load, wrap f ("Cmd_load \"" ++ esc f ++ "\" []")))
               _     -> pure Nothing
      else if v == "type"
        then ctxQ ctx (\f -> wrap f ("Cmd_infer_toplevel Simplified \"" ++ esc arg ++ "\""))
      else if v == "norm"
        then ctxQ ctx (\f -> wrap f ("Cmd_compute_toplevel DefaultCompute \"" ++ esc arg ++ "\""))
      else if v == "goals"
        then ctxQ ctx (\f -> wrap f "Cmd_metas Simplified")
      else if v == "goal"
        then case (ctx, rest) of
               (Just f, (n:_)) -> pure (Just (Query, wrap f ("Cmd_goal_type Simplified " ++ n ++ " noRange \"\"")))
               _ -> pure Nothing
      else if v == "raw"
        then pure (Just (Query, arg ++ "\n"))
      else pure Nothing
  where
    ctxQ Nothing  _  = pure Nothing
    ctxQ (Just f) mk = pure (Just (Query, mk f))

-- ── is this agda output line the terminal message for the pending kind? ───
terminal :: Kind -> Value -> Bool
terminal k (Object o) = case KM.lookup "kind" o of
  Just (String "DisplayInfo")      -> k == Query || isErr
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
      let loop = do
            eof <- isEOF
            if eof then pure () else do
              line <- getLine
              mcmd <- parseSpell ctxRef line
              case mcmd of
                Nothing -> putStrLn "✗ unknown or contextless command"
                Just (k, iotcm) -> do
                  hPutStr ain iotcm; hFlush ain
                  vs <- collect aout k
                  putStr (condense vs); hFlush stdout
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
      hPutStrLn stderr "नाडी warm; waiting on the request pipe"
      forever $ do
        line <- readOne reqF
        mcmd <- parseSpell ctxRef line
        resp <- case mcmd of
          Nothing -> pure "✗ bad command\n"
          Just (k, iotcm) -> do
            hPutStr ain iotcm; hFlush ain
            vs <- collect aout k
            pure (condense vs)
        writeOne respF resp

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
