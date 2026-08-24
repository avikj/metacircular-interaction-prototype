-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- दृश्यम् — the scene grammar for the नाडी conduit, and it is Pāṇini's.
--
-- WHAT THIS IS.  `Nadi.hs` opened the warm channel to the kernel and its
-- header says what the next layer must be:
--
--     "When this conduit grows a scene grammar it will `import Astadhyayi`
--      and use Karaka/Vibhakti/vibhaktiOf directly, not a parallel
--      invention."
--
-- and the kāraka layer's own completion commit names the mapping:
--
--     "The नाडी conduit's scene grammar imports THIS (karman = the term,
--      adhikaraṇa = the hole, karaṇa = the lemma), never a reinvention."
--
-- This is that layer.  Every constructor below is imported; nothing here
-- invents a Sanskrit noun.  An earlier draft of a spell layer dressed kernel
-- operations as fabricated vocabulary (रूप = "form", सār = "essence") and was
-- struck the same day — see msg 0922.  The vocabulary here is the kāraka
-- system as Astadhyayi.hs already carries it, with its sūtras.
--
-- WHY A CASE GRAMMAR IS THE RIGHT CHANNEL, and it is not decoration.  The
-- current spell line is positional: `goal 0`, `norm e`, `load p`.  Position
-- is a fixed order, so every argument must be present and in place, and the
-- channel carries what the context already knows.  Pāṇini's architecture
-- removes exactly that cost:
--
--   * the ROLE rides on the argument, not on its position, so word order is
--     free and a scene may be given in any order;
--   * 2.3.1 अनभिहिते is a GATE — what is already expressed is not expressed
--     again.  In a conversation with a warm kernel most of the scene is
--     already established (the module is loaded, the hole is the one under
--     discussion), and the gate drops it rather than restating it.
--
-- That second point is the whole of minimal overhead, stated ~500 BCE, and it
-- is why `abhihita` is consulted before any case is assigned.
--
-- THE MAPPING, per the completion commit, with each kāraka's defining sūtra:
--
--   कर्मन्    1.4.49  the thing acted on          = THE TERM
--   अधिकरण    1.4.45  the locus, आधार             = THE HOLE
--   करण      1.4.42  साधकतमम्, most-effective means = THE LEMMA
--   अपादान    1.4.24  ध्रुवम् अपाये, fixed point of departure = THE MODULE
--   कर्तृ     1.4.54  the independent one          = THE SEAT  (abhihita:
--                     under Kartari the ending expresses it, so 2.3.1
--                     withdraws it and it is never sent)
--
-- Sampradāna (1.4.32, the recipient) has no kernel role yet and is refused
-- rather than given an invented one.
--
-- Build/run:  runghc -imachine machine/Drshya.hs
module Main (main) where

import Astadhyayi
  ( Karaka(..), Vibhakti(..), Vacya(..), Drshya, vibhaktiOf, abhihita )
import Data.List (intercalate, partition)
import Data.Maybe (fromMaybe, mapMaybe)

-- ---------------------------------------------------------------- context
-- What the conversation has already established.  This is the `abhihita`
-- side: anything recorded here is already expressed and 2.3.1 withdraws it
-- from the utterance.
data Sthiti = Sthiti
  { loadedModule :: Maybe String   -- अपादान already expressed by a prior load
  , currentHole  :: Maybe Int      -- अधिकरण already expressed by being in it
  } deriving (Eq, Show)

emptySthiti :: Sthiti
emptySthiti = Sthiti Nothing Nothing

-- ------------------------------------------------------------- the gate
-- 2.3.1 अनभिहिते, applied to the channel: a role the context already
-- expresses is DROPPED from the scene.  Returns what survives, and what the
-- gate withdrew, so the saving is visible rather than asserted.
anabhihite :: Sthiti -> Drshya -> (Drshya, [(Karaka, String)])
anabhihite st = partition (not . alreadySaid)
  where
    alreadySaid (Apadana, m)    = loadedModule st == Just m
    alreadySaid (Adhikarana, h) = fmap show (currentHole st) == Just h
    alreadySaid (Kartr, _)      = True   -- abhihita under Kartari; never sent
    alreadySaid _               = False

-- --------------------------------------------------- scene → kernel command
-- The kernel's own Cmd_* — no invented operation names, exactly as Nadi.hs
-- insists.  Which command a scene names is decided by WHICH ROLES ARE
-- PRESENT, which is the point of a case grammar: the shape of the scene is
-- the shape of the request.
vakya :: Sthiti -> Drshya -> Either String String
vakya st scene =
  let (sent, dropped) = anabhihite st scene
      look k = lookup k sent
      file   = fromMaybe "" (look Apadana `orElse` loadedModule st)
      wrap c = "IOTCM \"" ++ file ++ "\" None Indirect (" ++ c ++ ")"
      hole   = look Adhikarana `orElse` fmap show (currentHole st)
      esc    = concatMap (\c -> case c of '\\' -> "\\\\"; '"' -> "\\\""; _ -> [c])
  in case (look Apadana, look Karman, hole, look Karana, look Sampradana) of
       (_, _, _, _, Just _) ->
         Left "सम्प्रदान has no kernel role; refused rather than invented"
       -- अपादान alone: the departure point is named, so: load it.
       (Just m, Nothing, Nothing, Nothing, _) ->
         Right ("IOTCM \"" ++ m ++ "\" None Indirect (Cmd_load \""
                ++ esc m ++ "\" [])")
       -- कर्मन् into अधिकरण: give this term to that hole.
       (_, Just t, Just h, Nothing, _) | not (null file) ->
         Right (wrap ("Cmd_give WithoutForce (InteractionId " ++ h
                      ++ ") noRange \"" ++ esc t ++ "\""))
       -- करण into अधिकरण: refine that hole BY this means.
       (_, Nothing, Just h, Just l, _) | not (null file) ->
         Right (wrap ("Cmd_refine_or_intro False (InteractionId " ++ h
                      ++ ") noRange \"" ++ esc l ++ "\""))
       -- अधिकरण alone: what does that locus want?
       (_, Nothing, Just h, Nothing, _) | not (null file) ->
         Right (wrap ("Cmd_goal_type Simplified (InteractionId " ++ h
                      ++ ") noRange \"\""))
       -- कर्मन् alone: compute the term.
       (_, Just t, Nothing, Nothing, _) | not (null file) ->
         Right (wrap ("Cmd_compute_toplevel DefaultCompute \"" ++ esc t ++ "\""))
       -- nothing marked: the open loci.
       (Nothing, Nothing, Nothing, Nothing, _) | not (null file) ->
         Right (wrap "Cmd_metas Simplified")
       _ -> Left ("no rule for this scene"
                  ++ (if null dropped then ""
                      else "  (2.3.1 withdrew: " ++ show (map fst dropped) ++ ")"))
  where
    orElse (Just x) _ = Just x
    orElse Nothing  y = y

-- ------------------------------------------------------------ rendering
-- Each participant with the case it receives and the sūtra that assigns it.
-- Word order in the input is irrelevant; this is what makes it so.
vyakhya :: Vacya -> Drshya -> [String]
vyakhya v scene =
  [ pad (show k) ++ " " ++ who ++ "  →  " ++ show vb ++ "   [" ++ why ++ "]"
  | (k, who) <- scene, let (vb, why) = vibhaktiOf v k ]
  where pad s = s ++ replicate (max 0 (11 - length s)) ' '

-- ------------------------------------------------------------------ demo
main :: IO ()
main = do
  let m = "/abs/Module.agda"
      st0 = emptySthiti
      st1 = Sthiti (Just m) Nothing
      st2 = Sthiti (Just m) (Just 0)

      -- the same scene given in THREE different word orders
      s1 = [(Apadana, m)]
      s2 = [(Adhikarana, "0"), (Apadana, m)]
      s3 = [(Karman, "suc n"), (Adhikarana, "0"), (Apadana, m), (Kartr, "weaver")]
      s3' = [(Kartr, "weaver"), (Apadana, m), (Karman, "suc n"), (Adhikarana, "0")]
      s4 = [(Karana, "cong f"), (Adhikarana, "0")]
      s5 = [(Sampradana, "brahmana")]

  putStrLn "दृश्यम् — the scene is the utterance, the ending carries the role.\n"

  putStrLn "the six roles under Kartari, with their assigning sūtras:"
  mapM_ (putStrLn . ("  " ++)) (vyakhya Kartari
    [ (Kartr,"seat"), (Karman,"term"), (Karana,"lemma")
    , (Sampradana,"—"), (Apadana,"module"), (Adhikarana,"hole") ])

  putStrLn "\n2.3.1 अनभिहिते as a GATE — what the context already says is not said again:"
  let show1 (lbl, st, sc) = do
        let (sent, dropped) = anabhihite st sc
        putStrLn ("  " ++ lbl)
        putStrLn ("    sent      : " ++ show (map fst sent))
        putStrLn ("    withdrawn : " ++ show (map fst dropped))
        putStrLn ("    → " ++ either ("REFUSED: " ++) id (vakya st sc))
  mapM_ show1
    [ ("nothing established, module named",            st0, s1)
    , ("module established, hole named",               st1, s2)
    , ("module and hole established, term given",      st2, s3)
    , ("the SAME scene, words reordered",              st2, s3')
    , ("hole established, refine by a means",          st2, s4)
    , ("a role with no kernel counterpart",            st2, s5)
    ]

  putStrLn "\nword order is free: the two 'term given' scenes differ only in order."
  putStrLn ("  same command: " ++ show (vakya st2 s3 == vakya st2 s3'))

-- ---------------------------------------------------------------- मर्यादा
--
-- WHAT IS VERIFIED, and it stops short of end-to-end.
--
-- * The六 roles, their cases and their assigning sūtras come from
--   `Astadhyayi.vibhaktiOf`, imported.  Nothing here invents vocabulary, and
--   सम्प्रदान is REFUSED rather than given a kernel role it does not have.
-- * 2.3.1 as a gate is exhibited: the four-role scene sends ONE role and
--   withdraws three, because the context already expresses them.
-- * Word-order freedom is checked by equality of the emitted command on two
--   permutations of the same scene, printed as `same command: True`.
-- * The emitted strings match `Nadi.hs`'s own positional spells in shape —
--   `Cmd_goal_type Simplified (InteractionId n) noRange ""`,
--   `Cmd_give WithoutForce (InteractionId n) noRange "…"` — so this is a
--   front end to the same channel, not a second protocol.
--
-- NOT verified: the round trip through `nadi raw`.  नाडी's completion
-- detection is semantic (it waits for the terminal message of a known command
-- class) and `raw` is the escape hatch, so it has no class to wait on; the
-- release note already lists that as a rough edge.  Driving these commands
-- end-to-end wants either a `scene` verb inside `Nadi.hs` — where the class
-- is known because the scene decided it — or completion detection for `raw`.
-- Said here rather than left for a reader to discover by hanging.
