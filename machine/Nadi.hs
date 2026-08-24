-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

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
import Data.List (isPrefixOf, isInfixOf, stripPrefix, intercalate)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text.Encoding as TE
import qualified Data.Aeson as A
import Data.Aeson (Value(..), (.:), (.:?))
import qualified Data.Aeson.Types as AT
import qualified Data.Aeson.KeyMap as KM
import qualified Data.Text as T
import qualified Data.Vector as V
import qualified Astadhyayi as P   -- the completed six-kāraka layer, imported (not reinvented)
import qualified Yantra_TheOrgansAreOneMachineOnOneWire as Y  -- the organ bus
import qualified Sabda_TheWireHasNoBoolean as SB              -- render Yantra's answers
import qualified Uttara_SamkramanaOrDosalekhaNeverABareBoolean as U
  -- the answer type itself, so `uVahita` — "what was carried across, in full"
  -- — is read from the structure instead of scraped back out of its rendering

-- ── the spell stream: a raw line → an action ──────────────────────────────
-- Kind Load/Query go to the kernel; Push reads the machine's own frontier
-- (the coprocessing back-channel — the machine posting what it is stuck on).
-- Fill is separated from Query because a PROPOSAL and a READING end on
-- different messages.  Reading a goal ends on the goal display; proposing a
-- term ends on acceptance (GiveAction / MakeCase / SolveAll) or on the
-- kernel's stated reason for refusing.  Agda emits the goal list BEFORE that
-- reason, so while `give` was a Query the reader stopped at the goal list,
-- the ✗ and its message stayed in the buffer, and — this is the part that
-- was doing damage — the leftover then answered the NEXT question.  One
-- refusal desynchronised the whole conversation by one turn.
data Kind = Load | Query | Fill | Push | Organ deriving Eq

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
               (Just f, (n:_)) -> pure (Just (Fill, wrap f
                 ("Cmd_give WithoutForce " ++ n ++ " noRange \"" ++ esc arg2 ++ "\"")))
               _ -> pure Nothing
      else if v == "refine"  -- refine <id> <term> : partial fill, new holes
        then case (ctx, rest) of
               (Just f, (n:_)) -> pure (Just (Fill, wrap f
                 ("Cmd_refine_or_intro False " ++ n ++ " noRange \"" ++ esc arg2 ++ "\"")))
               _ -> pure Nothing
      else if v == "split"   -- split <id> <var> : case-split; kernel writes clauses
        then case (ctx, rest) of
               (Just f, (n:_)) -> pure (Just (Fill, wrap f
                 ("Cmd_make_case " ++ n ++ " noRange \"" ++ esc arg2 ++ "\"")))
               _ -> pure Nothing
      else if v == "solve"   -- solveAll: the kernel fills every hole it can
        then case ctx of
               Just f  -> pure (Just (Fill, wrap f "Cmd_solveAll Simplified"))
               Nothing -> pure Nothing
      else if v == "auto"    -- auto <id> [hints] : the kernel SEARCHES for a
                             -- term (Agsy/Mimer) and AUTHORS it — the machine
                             -- proving by itself, not merely verifying a term
                             -- handed to it.  This is the generative organ:
                             -- give/refine check a proposal, auto MAKES one.
        then case (ctx, rest) of
               (Just f, (n:_)) -> pure (Just (Fill, wrap f
                 ("Cmd_autoOne " ++ n ++ " noRange \"" ++ esc arg2 ++ "\"")))
               _ -> pure Nothing
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
                      (Just n, Just t) -> pure (Just (Fill, wrap f
                        ("Cmd_give WithoutForce " ++ n ++ " noRange \"" ++ esc t ++ "\"")))
                      _ -> pure Nothing
      -- the push back-channel: the machine's frontier / live event stream,
      -- not kernel calls.  frontier = snapshot; watch = new events since last.
      else if v == "frontier"
        then pure (Just (Push, "frontier"))
      else if v == "watch"
        then pure (Just (Push, "watch"))
      -- an ORGAN call on the Yantra wire: any actual Yantra kriyā name
      -- (naya.suchi, dosa.suchi, saptabhangi.*, sadhana, kuttaka,
      -- vargaprakrti, pratyahara, …) reaches the store, the defect log, the
      -- verdicts, the Certificate-gated prover — one channel, kernel AND
      -- organs.  Membership is checked against the live roster, so every
      -- kriyā Yantra defines is reachable and nothing else is mistaken for one.
      else if v `elem` map Y.kName Y.kriyah
        then pure (Just (Organ, line))   -- pass the whole spell; args parsed in `organ`
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

-- split a token stream into marker→filler pairs.  A marker token opens a
-- new argument; following non-marker tokens accumulate as its filler
-- (spaces preserved), so word order is free and multi-word values need no
-- quoting.  Generic over the marker vocabulary: kāraka roles for a kernel
-- scene, an organ's own kParams for an organ scene — one grammar, two
-- vocabularies, nothing invented in either.
sceneBy :: Eq k => (String -> Maybe k) -> [String] -> [(k, String)]
sceneBy marker = go Nothing []
  where
    go cur acc [] = flush cur acc
    go cur acc (w:ws) = case marker w of
      Just k  -> go (Just (k, [])) (flush cur acc) ws
      Nothing -> case cur of
        Just (k, fs) -> go (Just (k, fs ++ [w])) acc ws
        Nothing      -> go Nothing acc ws            -- tokens before any marker: ignored
    flush Nothing       acc = acc
    flush (Just (k,fs)) acc = acc ++ [(k, unwords fs)]

parseScene :: [String] -> [(P.Karaka, String)]
parseScene = sceneBy roleWord

-- ── is this agda output line the terminal message for the pending kind? ───
-- `acc` is what has already arrived this turn, newest first.  A turn's end
-- cannot be read off one message: agda answers a PROPOSAL with two, in the
-- opposite order depending on the verdict —
--
--     accepted : GiveAction, then the new goal list
--     refused  : the goal list, then the reason
--
-- so whichever of the two you call terminal, the other is left in the pipe
-- and answers the NEXT question.  That is what was happening: one give and
-- the whole conversation ran a turn behind, with each answer attached to the
-- wrong question.  The rule that closes it: a proposal's turn ends on a
-- DisplayInfo, and it is the reason itself when refused, or the goal list
-- that follows the acceptance when accepted.
terminal :: Kind -> [Value] -> Value -> Bool
terminal k acc (Object o) = case KM.lookup "kind" o of
  Just (String "DisplayInfo")       -> k == Query || isErr
                                       || (k == Fill && accepted)
                                       || (k == Fill && isAuto)
                                       || (k == Load && seenPoints)
  Just (String "GiveAction")        -> k == Query
  Just (String "MakeCase")          -> k == Query
  Just (String "SolveAll")          -> k == Query
  -- A LOAD is two messages too, and in the same varying order: the goal list
  -- and the interaction-point list.  Which arrives first depends on whether
  -- the file has holes, so the same leftover appears, and it is why a load of
  -- a sealed module answered with the PREVIOUS module's goal list.  End on
  -- whichever of the two arrives second.
  Just (String "InteractionPoints") -> k == Load && seenGoals
  _ -> False
  where isErr = case KM.lookup "info" o of
                  Just (Object i) -> KM.lookup "kind" i == Just (String "Error")
                  _ -> False
        isAuto = case KM.lookup "info" o of
                  Just (Object i) -> KM.lookup "kind" i == Just (String "Auto")
                  _ -> False
        -- has the acceptance already arrived this turn?
        accepted   = any isAccept acc
        seenPoints = any (isKind "InteractionPoints") acc
        seenGoals  = any (isKind "DisplayInfo") acc
        isKind nm (Object a) = KM.lookup "kind" a == Just (String nm)
        isKind _  _          = False
        isAccept (Object a) = case KM.lookup "kind" a of
          Just (String "GiveAction") -> True
          Just (String "MakeCase")   -> True
          Just (String "SolveAll")   -> True
          _                          -> False
        isAccept _ = False
terminal _ _ _ = False

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
      -- the kernel's own proof SEARCH speaking: a found term, or its honest
      -- "No solution found".  Without this the generative organ was mute.
      Just (String "Auto") -> ["✦ auto: " ++ str (KM.lookup "info" i)]
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
             -- BL.pack is Char8: it beheads every Char to its low 8 bits, so a
             -- Devanagari answer became invalid JSON and was dropped SILENTLY
             -- — the conduit could pronounce ASCII and went mute in the
             -- corpus's own script (found 2026-08-23, asking the warm kernel
             -- to norm मूल-अस्ति: 0 bytes back, 20s timeout).  Encode real UTF-8.
             else case A.decode (BL.fromStrict (TE.encodeUtf8 (T.pack clean))) of
                    Just v | terminal k acc v -> pure (reverse (v : acc))
                           | otherwise        -> go (v : acc)
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
      yRef <- newIORef (Y.emptyYantra "." Nothing)
      let loop = do
            eof <- isEOF
            if eof then pure () else do
              line <- getLine
              resp <- respond ain aout ctxRef watchRef yRef line
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
      yRef <- newIORef (Y.emptyYantra "." Nothing)
      hPutStrLn stderr "नाडी warm; waiting on the request pipe"
      forever $ do
        line <- readOne reqF
        resp <- respond ain aout ctxRef watchRef yRef line
        writeOne respF resp

    -- one shared responder for both transports: parse the spell, then drive
    -- the kernel (Load/Query), read the push channel (Push), or reach an
    -- organ on the Yantra wire (Organ).
    respond ain aout ctxRef watchRef yRef line = do
      mcmd <- parseSpell ctxRef line
      case mcmd of
        Nothing                 -> pure "✗ unknown or contextless command\n"
        Just (Push, "watch")    -> watchNew watchRef
        Just (Push, _)          -> frontier
        Just (Organ, kriya)     -> organ yRef kriya
        Just (k, iotcm)         -> do
          hPutStr ain iotcm; hFlush ain
          vs <- collect aout k
          pure (condense vs)

    -- route an organ call to the Yantra bus and render the answer.  The
    -- spell is `<kriya> <param> <value> <param> <value> …` in the ORGAN'S
    -- OWN declared vocabulary (kParams — adi/it for pratyahara, a/b/c for
    -- kuttaka, vama/daksina for sadhana): a scene, split on the kriyā's
    -- own parameter names, ANY order, multi-word values, no quoting.  नाडी
    -- builds the wire JSON internally so the agent's channel stays
    -- JSON-free; Yantra's state carries across calls.
    organ yRef line = do
      y <- readIORef yRef
      let (kriya:rest) = words line
          params = case [ kr | kr <- Y.kriyah, Y.kName kr == kriya ] of
                     (kr:_) -> map fst (Y.kParams kr)
                     _      -> []
          pairs  = sceneBy (\w -> if w `elem` params then Just w else Nothing) rest
          jesc   = concatMap (\c -> case c of '\\'->"\\\\"; '"'->"\\\""; _->[c])
          -- integer-looking values go on the wire as JSON numbers (kuttaka's
          -- a/b/c), everything else as strings (pratyahara's adi/it) — the
          -- organ declares the type; नाडी reads the shape.
          digits = "0123456789" :: String
          isInt s = case s of ('-':d) -> d /= "" && all (`elem` digits) d
                              _        -> s /= "" && all (`elem` digits) s
          -- a filler that is already structured (starts [ or {) passes
          -- through as JSON; an integer as a number; else a string.  So a
          -- scene can carry a nested witness (naya.sthapana's saksin)
          -- without leaving the one grammar.
          structured s = case dropWhile (== ' ') s of ('[':_) -> True; ('{':_) -> True; _ -> False
          jval val | isInt val     = val
                   | structured val = val
                   | otherwise      = "\"" ++ jesc val ++ "\""
          angani = if null pairs then ""
                   else ",\"angani\":{" ++ intercalate ","
                          [ "\"" ++ k ++ "\":" ++ jval val | (k,val) <- pairs ] ++ "}"
      (y', m, u) <- Y.answer y "2026-08-23T00:00:00Z"
                      ("{\"kriya\":\"" ++ kriya ++ "\"" ++ angani ++ "}")
      writeIORef yRef y'
      let raw = SB.render (Y.mudritaJ m u)
          fld k = case breakOn ("\"" ++ k ++ "\":\"") raw of
                    Just r  -> Just (takeWhile (/= '"') r); Nothing -> Nothing
          breakOn key s | key `isPrefixOf` s = Just (drop (length key) s)
                        | null s = Nothing | otherwise = breakOn key (tail s)
          part = case (fld "sthana", fld "artha") of
                   (Just st, Just ar) -> " · " ++ st ++ " — " ++ ar
                   (Just st, _)       -> " · " ++ st
                   _                  -> ""
          -- the computed result rides in the tulyata: vama (the input)
          -- identified with daksina (the answer) — the sounds, the Bézout,
          -- the census.  Surface it so the machine's reply is actually heard.
          payload = case (fld "vama", fld "daksina") of
                      (Just vv, Just dk) -> "\n    " ++ vv ++ "  ≡  " ++ dk
                      _ -> case fld "hetu" of Just h -> "\n    hetu: " ++ h; _ -> ""
          -- वहितम् — `uVahita` is the organ's own words for "what was carried
          -- across, IN FULL", and until now नाडी delivered only whatever of it
          -- happened to survive as a flat string in the wire text.  So
          -- `garbha.dhara`'s born stream, `pratyahara`'s sounds and
          -- `frontier`'s census all rode the wire and none of them arrived:
          -- the renderer was a windowed observer and the structure lived in
          -- its fibre.  The tulyata above is the identification; this is the
          -- thing identified.
          vahita = case u of
                     U.Samkramana{} -> concat (concatMap carriedLines (U.uVahita u))
                     _              -> ""   -- a refusal carries nothing across
          carriedLines (k, SB.JArr items@(SB.JArr _ : _)) =
            let shown = take vahitaCap items
                rest  = length items - length shown
            in ("\n    " ++ k ++ " ▸")
               : [ "\n      " ++ show i ++ ". " ++ shortJ it
                 | (i, it) <- zip [1 :: Int ..] shown ]
               ++ [ "\n      … " ++ show rest ++ " more carried and not shown here"
                  | rest > 0 ]
          carriedLines (k, v) = ["\n    " ++ k ++ " ▸ " ++ shortJ v]
          -- a cap, said out loud rather than applied silently.
          vahitaCap = 12 :: Int
          shortJ (SB.JStr s)  = s
          shortJ (SB.JInt n)  = show n
          shortJ (SB.JArr xs) = intercalate " · " (map shortJ xs)
          shortJ (SB.JObj kv) = intercalate " · " [ kk ++ "=" ++ shortJ vv | (kk, vv) <- kv ]
      pure ("« " ++ kriya ++ part ++ payload ++ vahita ++ "\n")

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
