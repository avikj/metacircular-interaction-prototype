# S1–S3 patch series: wiring the certificate-carrying induction lane, honest memory, honest failure

**Author:** turing build worker, 2026-08-16 (session container: no ghc, no agda — this
is a patch series + wiring note, per D0026_BUILD_QUEUE §4 S1's own instruction that a
blind edit to live Haskell on main is unacceptable).
**Line references recomputed against `machine/MathMachine.hs` at HEAD `dd2cde7c`.**
Every hunk below is written against the file as it actually is, not as the
orientation summarized it — and the file is not as the orientation summarized it.
Read §0 first.

Status marks: everything here lands **awaiting kernel** until a toolchain-bearing
session compiles and runs the controls in §4. A green is an exit code or it is a
rumour.

---

## 0. The seam as found: the "refl-only, sterile" diagnosis is OUTDATED

The queue (§4 S1) and the 16-region orientation describe `kernelAccept` as
"refl-only ⇒ sound and nearly sterile." That was true of `agdaCertificate` /
`kernelAcceptLegacy` (MathMachine.hs 1240–1251, 1304–1350, both still present but
**dead** — nothing calls the legacy path). It is no longer true of the live gate.
Since commit `1a087ec5` ("The gate can certify induction now: 3 theorems became 14
in one round"):

- `kernelAccept` (1283–1284) is `kernelAcceptWith []`; `kernelAcceptWith`
  (1286–1302) delegates to **`C.certifyWith`** in `machine/Certificate.hs`
  (531–564).
- `certifyWith` tries a `refl` module first (1 agda call), then — **iff** the
  Haskell proof note parses as `induction on v` (`inductionVariable`, Certificate.hs
  419–429) — an induction *skeleton* with a fixed shape list (`stepShapes`,
  401–413: `refl`, bare `ih`, `cong suc`, and `cong (_+ k)/(k +_)/(_· k)/(k ·_)`
  sections), budget `kMaxAgdaCalls = 12` (441–442), base-clause failures
  short-circuiting (562–564).

So the live gate already certifies a real class of inductive theorems (per
Certificate.hs's own self-test: 15/28 of the library snapshot). What is actually
missing — and what S1 now means — is narrower and sharper than the queue's
sentence:

**The gap:** `certifyWith`'s step case is a *single* Agda expression drawn from a
fixed 11-shape list. It cannot express a multi-step rewrite trace (hypothesis used
under a context, then a definitional step, then another context move). Its own
header (Certificate.hs 126–132) reports the residue: every one of the 13 snapshot
rejections is commutativity/associativity-shaped. Meanwhile
`machine/MathMachineInductionGate.hs` holds a **checked-derivation search** —
bounded BFS over the `Step`/`HypStep` calculus of
`formal/cubical/NaturalMachine/RewriteCertificate.agda`, whose `induction-sound`
(RewriteCertificate.agda 133–148, `--cubical --safe`) is the semantic warrant —
and it demonstrably closes `+`-associativity (`main`, InductionGate 429–457),
which the shape list cannot (Agda's builtin `_+_` recurses on the first argument;
the goal after `suc` needs `+-suc` transport steps, i.e. a *trace*, not one
`cong`). That BFS lane is a standalone `module Main` demo, wired to nothing.

**Control flow at a kernel reject, as of HEAD** (this is the exact seam S1 cuts
into):

1. `round1` (1657) folds `attempt` (1753–1771) over `fresh`: rewriting-proof →
   silently kept as known-implied; **semantic firewall counterexample → silently
   dropped** (1759); `proveByInduction` failure → silently dropped (1762);
   `marginalPrune` below threshold → silently dropped (1766). Survivors land in
   `results` with proof note `"induction on v"` (1713).
2. `checkedResults <- filterM (kernelAcceptWith (mInvented m) logh (mRound m)) results`
   (1786). On `C.Rejected` the equation logs `KERNEL-REJECT` and returns `False`
   — **there is no second attempt of any kind**.
3. Everything in `fresh` not installed — firewall-refuted, prover-failed,
   prune-refused, and kernel-rejected alike — is written into the **one** map
   `mFailed :: M.Map (Term,Term) Int` with the current rule count (1798–1799),
   and retried only when the rule count changes (1706). Four distinct epistemic
   states, one bucket. (S3's diagnosis survives; its binary split does not — see
   §3.)
4. Memory: `runMachine` (2327+) **already replays** `machine/library.terms`
   through `kernelAccept` at boot (2342–2354) — S2 half-exists. But it is broken
   in practice: `library.terms` stores only `LHS\tRHS` (write side 1828–1830), the
   replay passes proof note `"remembered"` (2345), `inductionVariable "remembered"
   = Nothing`, so **every remembered theorem gets exactly one `refl` call and every
   non-definitional theorem is dropped at every boot** — logged as
   `KERNEL-REJECT round=0`, indistinguishable from a live refutation. Restart
   amnesia persists for precisely the theorems worth remembering. (No
   `library.terms` exists on disk yet, so the format can be extended without
   migration.)

Two further findings that changed the patch design (§5 has the full list):

- **The induction-gate harness's own agda invocation is suspect.**
  `validateWithAgda` (InductionGate 293–307) runs
  `agda -i <private> -i formal/cubical` with plain `writeFile`. Certificate.hs's
  header documents, with reproduction, that exactly this invocation shape fails on
  library resolution (fault 1: no `--library=cubical`, and a temp-dir file has no
  `.agda-lib` to walk up from) and on encoding (fault 2: locale `writeFile` throws
  on `≡`/`ℕ` before agda is spawned). So S1 must route the BFS lane's module
  through **`C.runAgda`** (Certificate.hs 483–499: `--library=cubical`, UTF-8
  handles, forced `LC_ALL`), not through a copy of `validateWithAgda`.
  Consequence: the emitted module must be named `Candidate` (runAgda writes
  `Candidate.agda`), not `InductionGate`.
- **The BFS calculus speaks only `{0, s, +}` with ≤3 variables and inducts only on
  its distinguished `Var`.** The wiring needs an explicit fail-closed translation
  (induction variable ↦ `Var`, up to two spectators ↦ `YVar`/`ZVar`); anything
  else falls back to the existing reject. `*` is out of the calculus's vocabulary
  — widening `Tm`/`Step` is S4, deliberately not smuggled in here.

---

## 1. Patch S1 — derivation-search rescue lane on kernel reject

### S1.0 New file `machine/InductionSearch.hs` (extraction, not invention)

Move, **verbatim**, from `machine/MathMachineInductionGate.hs` into a library
module `InductionSearch` (exporting everything listed): lines 24–68 (`Term`,
`StepCertificate`, `Derivation`, `HypStepCertificate`, `HypDerivation`,
`InductionCertificate`), 70–107 (renderers), 109–124 (`termSize`, `substituteX`),
126–189 (`stepTransitions`, `hypothesisTransitions`, `hypStepTransitions`),
191–223 (`boundedSearch`), 225–251 (`stepsToDerivation`, `stepsToHypDerivation`,
`deriveInductionCertificate`). One addition, replacing the harness-local
`renderModule` (253–274) with a name-parameterized version:

```
+renderModuleNamed :: String -> InductionCertificate -> String
+renderModuleNamed moduleName certificate = unlines
+  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
+  , "module " ++ moduleName ++ " where"
+  , "open import Cubical.Foundations.Prelude using (_≡_)"
+  , "open import NaturalMachine.RewriteCertificate"
+  , ""
+  , "lhs : Tm"
+  , "lhs = " ++ renderTerm (certificateLhs certificate)
+  , ""
+  , "rhs : Tm"
+  , "rhs = " ++ renderTerm (certificateRhs certificate)
+  , ""
+  , "candidate : InductionCertificate lhs rhs"
+  , "candidate = record"
+  , "  { base = " ++ renderDerivation (baseDerivation certificate)
+  , "  ; step = " ++ renderHypDerivation (stepDerivation certificate)
+  , "  }"
+  , ""
+  , "candidate-sound : (rho : Env) -> eval lhs rho ≡ eval rhs rho"
+  , "candidate-sound = induction-sound candidate"
+  ]
+
+renderModule :: InductionCertificate -> String
+renderModule = renderModuleNamed "InductionGate"
```

`MathMachineInductionGate.hs` then becomes a thin harness:
`import InductionSearch`, delete the moved lines, keep `main` and every control in
it (SEARCH-FOUND, false-equation refusal, `removeHypSuc` mutation, matching
discipline, no-install-on-reject) byte-for-byte in behavior. Recommended in the
same hunk: replace its `validateWithAgda` body with a call through `C.runAgda`
(module name `"Candidate"`), so the harness exercises the *same* invocation the
engine will use — and so faults (1)/(2) stop being latent in the control itself.
GHC resolves sibling modules from the main file's directory (this is how
`MathMachine.hs` already finds `Certificate.hs` under
`check-haskell-agda.sh`'s plain `ghc machine/MathMachine.hs`), so no build-script
change is needed.

### S1.1 `machine/MathMachine.hs`: the rescue lane

Add near the kernel seam (after 1302), plus `import qualified InductionSearch as IS`
at the import block (34–53):

```diff
--- machine/MathMachine.hs   (@ dd2cde7c, lines 1286–1302)
+++ machine/MathMachine.hs
@@ kernelAcceptWith
 kernelAcceptWith :: [Sym] -> Handle -> Int -> ((Term,Term),String) -> IO Bool
 kernelAcceptWith invented logh roundNo ((l,r),proofNote) = do
   verdict <- C.certifyWith (certDefinitions invented) "."
                ((toCert l, toCert r), proofNote)
   case verdict of
     C.Certified shape calls -> do
       hPrintf logh "  KERNEL-ACCEPT round=%d %s = %s  (%s, %d agda calls)\n"
         roundNo (show l) (show r) shape calls
       pure True
-    C.Rejected err calls -> do
-      hPrintf logh "  KERNEL-REJECT round=%d %s = %s  (%d agda calls) %s\n"
-        roundNo (show l) (show r) calls (take 160 (filter (/= '\n') err))
-      pure False
+    C.Rejected err calls -> do
+      -- S1: the skeleton emitter has no shape for this proof.  Before
+      -- rejecting, SEARCH a checked derivation in the RewriteCertificate
+      -- calculus (0/s/+ fragment, bounded BFS) and submit the certificate
+      -- object to the same kernel.  Fail-closed at every seam: an
+      -- untranslatable equation, an exhausted search, or a non-zero agda
+      -- exit all fall through to the reject below, with the ORIGINAL
+      -- error retained in the log.
+      rescued <- rescueByDerivationSearch logh roundNo ((l,r),proofNote)
+      if rescued then pure True else do
+        hPrintf logh "  KERNEL-REJECT round=%d %s = %s  (%d agda calls) %s\n"
+          roundNo (show l) (show r) calls (take 160 (filter (/= '\n') err))
+        pure False
     C.Untranslatable why -> do
       hPrintf logh "  KERNEL-SKIP  unsupported fragment: %s = %s  (%s)\n"
         (show l) (show r) why
       pure False
```

(`Untranslatable` gets no rescue on purpose: the BFS vocabulary `{0,s,+}` is a
strict subset of the emitter's, so untranslatable-for-the-emitter implies
untranslatable-for-the-search.)

New functions, placed after `kernelAcceptLegacy` (after 1350):

```haskell
-- The 0/s/+ fragment of the engine's Term, with the induction variable at
-- the calculus's distinguished Var and up to two spectators at YVar/ZVar.
-- Nothing anywhere else: the rescue lane must fail closed, never coerce.
inductionSearchProblem :: (Term,Term) -> String -> Maybe (IS.Term, IS.Term)
inductionSearchProblem (l,r) proofNote = do
  v <- C.inductionVariable proofNote
  let allVars = ordNub (vars l ++ vars r)
  if v `notElem` allVars then Nothing else do
    spectatorMap <- case [ i | i <- allVars, i /= v ] of
      []    -> Just []
      [a]   -> Just [(a, IS.YVar)]
      [a,b] -> Just [(a, IS.YVar), (b, IS.ZVar)]
      _     -> Nothing
    let tr (V i) | i == v    = Just IS.Var
                 | otherwise = lookup i spectatorMap
        tr (F "0" [])   = Just IS.Zero
        tr (F "s" [t])  = IS.Suc <$> tr t
        tr (F "+" [a,b]) = IS.Add <$> tr a <*> tr b
        tr _ = Nothing
    (,) <$> tr l <*> tr r

-- At most one extra agda call per candidate; the BFS itself is pure and
-- bounded (depth 6, size = largest endpoint + 4, 20000 nodes — the bounds
-- ARE the termination argument, deriveInductionCertificate 237–241).
rescueByDerivationSearch :: Handle -> Int -> ((Term,Term),String) -> IO Bool
rescueByDerivationSearch logh roundNo ((l,r),proofNote) =
  case inductionSearchProblem (l,r) proofNote of
    Nothing -> pure False
    Just (sl, sr) ->
      case IS.deriveInductionCertificate sl sr of
        Nothing -> pure False
        Just cert -> do
          (code, out) <- C.runAgda "." (IS.renderModuleNamed "Candidate" cert)
          case code of
            ExitSuccess -> do
              hPrintf logh "  KERNEL-ACCEPT round=%d %s = %s  (rewrite-certificate derivation, +1 agda call)\n"
                roundNo (show l) (show r)
              pure True
            ExitFailure _ -> do
              hPrintf logh "  KERNEL-RESCUE-REJECT round=%d %s = %s  %s\n"
                roundNo (show l) (show r) (take 160 (filter (/= '\n') out))
              pure False
```

`C.runAgda` and `C.inductionVariable` are already in Certificate.hs's export list
(164, 152). Per-candidate agda budget becomes `kMaxAgdaCalls + 1 = 13`; note this
beside `kMaxAgdaCalls` (Certificate.hs 441–442) rather than silently.

**What this buys, exactly:** the class the harness already demonstrates —
`+`-associativity-shaped statements whose step case is a hypothesis-under-context
*trace* (`hyp-then (lift-step (add-suc …)) (hyp-then (hyp-suc hypothesis) …)`).
**What it does not buy, said now so nobody measures it later:** `+`-commutativity
— its base case `0+y = y+0` is not derivable in the Step calculus without a lemma
environment (the calculus's only axioms are `x+0→x`, `x+s y→s(x+y)`, contexts,
reverse; `0+y=y` itself needs induction). That residue is a *lemma-environment*
obligation (certificates emitted in dependency order with earlier theorems in
scope), which Certificate.hs 126–132 already names, and which stays on the queue.
Install-on-accept then proceeds through the **unchanged** downstream: rescue
returns `True` → the equation stays in `checkedResults` → oriented into
`mRules`/`mLemmas` at 1793–1797 exactly as a skeleton-certified theorem would.
No new install path exists.

---

## 2. Patch S2 — memory that survives a restart

Three hunks; each is small because the replay skeleton already exists. The rule
being enforced: **a stored string is a hint about which proof shapes to attempt;
admission is agda exit 0 in THIS process.** (That is already the code's stated
invariant, banner 507–524; these hunks make it true for inductive theorems.)

### S2.1 Persist the proof note (write side, 1823–1830)

```diff
--- machine/MathMachine.hs   (@ dd2cde7c, lines 1823–1830)
+++ machine/MathMachine.hs
@@ round1, theorem write-out
   forM_ checkedResults $ \((l,r),pf) -> do
     hPrintf libh "%-46s = %-24s   [%s]\n" (show l) (show r) pf
     hPrintf logh "  THEOREM  %s = %s   (%s)\n" (show l) (show r) pf
     case mem of
       Nothing   -> return ()
-      Just path -> appendFile path (showTermP l ++ "\t" ++ showTermP r ++ "\n")
+      -- Third tab field: the proof annotation, so a later boot can retry
+      -- the same proof SHAPE.  It is a hint, never an accepted proof.
+      Just path -> appendFile path
+        (showTermP l ++ "\t" ++ showTermP r ++ "\t" ++ pf ++ "\n")
```

### S2.2 Read the note back (`parseMemory`, 536–541)

```diff
--- machine/MathMachine.hs   (@ dd2cde7c, lines 536–541)
+++ machine/MathMachine.hs
-parseMemory :: String -> [(Term,Term)]
-parseMemory = mapMaybe line . lines
-  where
-    line s = case splitTabs s of
-      [l,r] -> (,) <$> parseTerm l <*> parseTerm r
-      _     -> Nothing
+parseMemory :: String -> [((Term,Term),String)]
+parseMemory = mapMaybe line . lines
+  where
+    -- Two-field lines (the pre-S2 format) still parse; their note is
+    -- "remembered", which selects only the refl shape — exactly the old
+    -- behavior, so an old file is degraded, not rejected.
+    line s = case splitTabs s of
+      [l,r]    -> entry l r "remembered"
+      [l,r,pf] -> entry l r pf
+      _        -> Nothing
+    entry l r pf = (\lt rt -> ((lt,rt),pf)) <$> parseTerm l <*> parseTerm r
```

(No `machine/library.terms` exists on disk at HEAD, so there is nothing to
migrate; the compatibility clause costs two lines and keeps the parser total over
both formats anyway.)

### S2.3 Replay with the note, and mark staleness distinctly (2342–2354)

```diff
--- machine/MathMachine.hs   (@ dd2cde7c, lines 2342–2354)
+++ machine/MathMachine.hs
   memExists <- doesFileExist memoryPath
   remembered <- if memExists then parseMemory <$> readFile memoryPath
                              else pure []
-  admitted <- filterM (\c -> kernelAccept logh 0 (c, "remembered")) remembered
+  -- Replay each entry through the SAME gate the live loop uses, with the
+  -- stored note selecting the proof shapes to attempt (and, after S1, the
+  -- derivation-search lane).  A remembered theorem that no longer
+  -- certifies is dropped for this process and marked KERNEL-STALE — a
+  -- distinct mark, because a boot-time drop is "my gate cannot re-speak
+  -- this today", which is not the same fact as a live KERNEL-REJECT.
+  -- The file is append-only and is NOT edited: a stale entry is re-tried
+  -- at every boot, so a later, wider gate resurrects it for free.
+  admitted <- fmap concat . forM remembered $ \(c@(l,r), note) -> do
+    ok <- kernelAccept logh 0 (c, note)
+    if ok then pure [c] else do
+      hPrintf logh "  KERNEL-STALE %s = %s  [%s]  (dropped this boot; retained in %s)\n"
+        (show l) (show r) note memoryPath
+      pure []
   hPrintf logh "  MEMORY  remembered=%d re-admitted=%d dropped=%d\n"
     (length remembered) (length admitted)
     (length remembered - length admitted)
```

(`forM` needs no new import: `Control.Monad` is already imported at 38; add `forM`
to its explicit list.) Downstream `seeded` (2349–2354) consumes `admitted ::
[(Term,Term)]` unchanged.

**Declared residual, not hidden:** the replay runs `kernelAccept = kernelAcceptWith
[]` — invented concepts are not persisted, so a remembered theorem mentioning a
`cN` symbol is `Untranslatable` at boot and goes STALE. Persisting `mInvented`
(name, arity, defining pattern — everything `certDefinitions` needs) is real work
adjacent to S4's vocabulary program and is left on the queue *by name* rather than
half-done here. Same for `mVocab`/`mSize`/`mUnproved`: this patch restores the
**theorem store**, which is the part whose loss contradicts the machine's first
paragraph; the search-state fields are heuristic state and their loss costs
re-derivation time, not soundness.

### S2.4 Self-test flag (control for §4; add before the final `case args of` at 2316)

`--replay-self-test`: write a temp memory file containing
(a) `+(0,x)\tx\trefl-claimed` — certifies by `refl`;
(b) `+(x,0)\tx\tinduction on x` — needs the induction skeleton (`x + 0 ≡ x` is
not definitional under Agda's first-argument `_+_`);
(c) `s(x)\tx\tinduction on x` — false, must go STALE.
Run the replay block against it (extract the replay into a
`replayMemory :: Handle -> FilePath -> IO [(Term,Term)]` so `runMachine` and the
self-test share one code path — no second replay implementation), assert
`re-admitted == 2`, `dropped == 1`, and that the dropped one is (c). Exit nonzero
otherwise.

---

## 3. Patch S3 — REFUTED / UNSPEAKABLE / UNPROVED

The queue's split ("REFUTED vs KERNEL-REJECT") is not exhaustive against the real
control flow: `mFailed` today absorbs **four** causes (firewall counterexample at
1759; `proveByInduction` failure at 1762; prune-below-threshold at 1766;
kernel-reject via absence from `checkedResults` at 1798–1799). Two of those —
prover-failed and prune-refused — already have the *correct* retry semantics
(retry when the rule set changes: a new rule can complete the proof or change the
prune value). So the honest taxonomy is three-way:

| store | meaning | retry semantics |
|---|---|---|
| `mRefuted :: M.Map (Term,Term) ()` | semantic counterexample exists (firewall, exhaustive to bound 8) | **never** — a counterexample does not expire |
| `mUnspeakable :: M.Map (Term,Term) Int` | Haskell-proved, kernel could not speak it; value = certificate-language epoch at failure | retry **iff the epoch changed** — more rules do not widen the kernel's mouth, only a wider language does |
| `mUnproved :: M.Map (Term,Term) Int` (rename of `mFailed`) | prover/prune failure; value = rule count at failure | unchanged: retry when the rule count changes |

This is D0026 §1.3 provenance closure inside the machine's own state: "false",
"beyond my mouth", and "beyond my prover today" are three different provenances
and now carry three different futures. It also stops a measurable waste: refuted
conjectures are today re-fingerprinted, re-firewalled (729 evaluations each) on
every rule-count change, forever.

### S3.1 Language epoch

Certificate.hs, next to `kMaxAgdaCalls` (441), new export:

```haskell
-- Bump BY HAND whenever the gate's language widens: new step shapes, new
-- lane, new symbol translation.  Stored inside mUnspeakable entries so
-- that exactly a widening — and nothing else — retries them.
kCertificateLanguageVersion :: Int
kCertificateLanguageVersion = 2   -- 1: refl + skeleton; 2: + S1 derivation search
```

MathMachine.hs, near `usableRules` (1615):

```haskell
certLanguageEpoch :: Machine -> Int
certLanguageEpoch m =
  1000 * C.kCertificateLanguageVersion + length (mInvented m)
```

(Invented concepts widen the translatable fragment per-machine —
`certDefinitions` feeds them to the emitter — so they are part of the epoch.
`mVocab` is deliberately not: the given vocabulary's eight symbols were always
translatable.)

### S3.2 Record and `start` (1354–1389, 1502–1509)

```diff
@@ data Machine
-  , mFailed  :: M.Map (Term,Term) Int  -- conjecture -> rule count when it failed
+  -- honest failure taxonomy (S3): three provenances, three futures
+  , mRefuted     :: M.Map (Term,Term) ()   -- counterexample found; permanent
+  , mUnspeakable :: M.Map (Term,Term) Int  -- kernel-reject; language epoch at failure
+  , mUnproved    :: M.Map (Term,Term) Int  -- prover/prune failure; rule count at failure
@@ start
-start = Machine [] [] M.empty [] [] M.empty [] [] 3 4 0
+start = Machine [] [] M.empty [] [] M.empty M.empty M.empty [] [] 3 4 0
```

(`start` is positional — the arity change is the reason the hunk must be applied
with a compiler present, which is the point of this series being a series.)

### S3.3 `round1`: partition instead of pooling

Fresh filter (1703–1708):

```diff
       fresh = sortOn (\(l,r) -> (size l + size r, l, r))
               [ c | c <- conjectures
                   , not (M.member c (mKnown m))
-                  , M.lookup c (mFailed m) /= Just nRules
+                  , not (M.member c (mRefuted m))
+                  , M.lookup c (mUnspeakable m) /= Just (certLanguageEpoch m)
+                  , M.lookup c (mUnproved m) /= Just nRules
                   , not (provedByRewriting rules c)
                   , not (congruent rules (mKnown m) c) ]
```

`attempt` (1753–1771) — the fold accumulator grows a refuted list, so the firewall
verdict stops being discarded at the moment it is computed:

```diff
-      results = reverse (snd (foldl' attempt (rules, []) fresh))
+      (_, resultsRev, refutedNow) = foldl' attempt (rules, [], []) fresh
+      results = reverse resultsRev
@@
-      attempt (acc, out) c
-        | provedByRewriting acc c = (acc, out)
-        | not (survivesSemanticFirewall syms c) = (acc, out)
+      attempt (acc, out, refs) c
+        | provedByRewriting acc c = (acc, out, refs)
+        | not (survivesSemanticFirewall syms c) = (acc, out, c:refs)
         | otherwise =
             case proveByInduction acc c of
-              Nothing -> (acc, out)
+              Nothing -> (acc, out, refs)
               Just pf
-                | marginalPrune acc probe c < K.kMinPrune (mKnobs m) -> (acc, out)
+                | marginalPrune acc probe c < K.kMinPrune (mKnobs m) -> (acc, out, refs)
                 | otherwise ->
                     let acc' = acc ++ maybe [] (:[]) (orient c)
                                 ++ (if isJust (orient c) then []
                                     else lemmaRules [c])
-                    in (acc', (c,pf):out)
+                    in (acc', (c,pf):out, refs)
```

State update (1795–1813). Every `results` member absent from `checkedResults` is
kernel-side by construction (it was Haskell-proved and prune-worthy; only the
`filterM` at 1786 could remove it), so no signature change to `kernelAcceptWith`
is needed:

```diff
       m' = m { mRules = mRules m ++ newRules
              , mLemmas = mLemmas m ++ newLemmas
              , mKnown = foldl' (\k (c,_) -> M.insert c () k) (mKnown m) checkedResults
-             , mFailed = foldl' (\k c -> M.insert c nRules k) (mFailed m)
-                          [ c | c <- fresh, notElem c (map fst checkedResults) ]
+             , mRefuted = foldl' (\k c -> M.insert c () k) (mRefuted m) refutedNow
+             , mUnspeakable = foldl' (\k c -> M.insert c (certLanguageEpoch m) k)
+                          (mUnspeakable m) unspeakableNow
+             , mUnproved = foldl' (\k c -> M.insert c nRules k) (mUnproved m)
+                          unprovedNow
```

with, in the surrounding `let`:

```haskell
      installedSet = map fst checkedResults
      unspeakableNow = [ c | c <- map fst results, c `notElem` installedSet ]
      unprovedNow = [ c | c <- fresh
                        , c `notElem` map fst results
                        , c `notElem` refutedNow ]
```

Logging — a refutation is a *result* (a closed question) and gets its
counterexample printed; plus one summary line after the round line (1848):

```haskell
  forM_ refutedNow $ \c@(cl,cr) ->
    case ruleCounterexample syms definitionAuditBound c of
      Just (env,lv,rv) -> hPrintf logh
        "  REFUTED  %s = %s  at env=%s (left=%s, right=%s); permanent\n"
        (show cl) (show cr) (show env) (show lv) (show rv)
      Nothing -> hPrintf logh "  REFUTED  %s = %s  (witness within bound %s)\n"
        (show cl) (show cr) (show definitionAuditBound)
  hPrintf logh "  FAILURES  refuted=%d unspeakable=%d unproved=%d\n"
    (length refutedNow) (length unspeakableNow) (length unprovedNow)
```

(The recomputation of `ruleCounterexample` is once per *refuted* conjecture —
rare — not per candidate; the firewall inside `attempt` stays boolean.)

**Deliberately untouched, flagged for the gate lane's judgment:** `obstruction =
nFresh - length checkedResults` (1818) still counts refuted conjectures as
"stated and not closed", though a refutation *is* a closure. Changing it changes
the KFlow trigger's dynamics, which are pinned by NaturalMachine.MachineLoop and
by the arm-D measurement (comment at 1948–1960) — that is a
model-plus-measurement change, not a bookkeeping change, and it does not belong
in this series.

### S3.4 Self-test flag

`--taxonomy-self-test` (pure, no agda): build a `Machine` with one entry in each
store; assert the fresh filter excludes the refuted entry, excludes the
unspeakable entry at its stored epoch, includes it when the epoch differs, and
applies the rule-count rule to the unproved entry. Exit nonzero otherwise.

---

## 4. Invariants preserved, and the controls to run before merge

### Invariants (each hunk was written against this list)

1. **Fail-closed everywhere.** Every new `Nothing`/`ExitFailure` path lands on the
   pre-existing reject path with the original error retained. No lane installs
   without agda exit 0 **in this process**: S1's rescue installs only on
   `ExitSuccess` of a `--safe` module whose semantic content is
   `RewriteCertificate.induction-sound`; S2's replay re-certifies every entry at
   every boot (the invariant at banner 507–524 — "every installed rule was
   kernel-accepted in THIS process" — is preserved verbatim and finally becomes
   *reachable* for inductive theorems); S3 only ever narrows what is attempted,
   never what is checked.
2. **No privileged status.** Researcher thoughts, remembered entries, and
   BFS-found certificates all cross the same `kernelAcceptWith`. Stored proof
   notes and thought lines are hints/objects, never accepted proofs
   (THOUGHT_FORMAT.md's "no privileged proof status" extends to memory).
3. **Append-only log and library.** `machine.log`, `library.txt`,
   `library.terms` are opened in AppendMode / appended only. KERNEL-STALE is a
   log mark; the stale entry stays in the file and is re-tried next boot.
   Nothing rewrites history.
4. **Bounded budgets, stated.** BFS: depth 6, size = endpoint+4, 20000 nodes
   (the bounds are the termination argument — reverse steps *grow* terms).
   Agda: ≤ `kMaxAgdaCalls`+1 = 13 per candidate, live or replayed. Replay cost
   per boot is linear in the library with that constant.
5. **The soundness perimeter is unchanged.** No new Agda is trusted; the one Agda
   module involved (`RewriteCertificate.agda`) is untouched by this series and is
   already `--cubical --safe`, no postulates, no holes.

### Controls (gate lane, toolchain-bearing session, before merge)

Existing — all must stay green:

- `machine/check-haskell-agda.sh` end-to-end (compiles both binaries
  `-Wall -Werror`, which is what catches the `start`-arity and `parseMemory`-type
  changes; thought-format; definition firewall; 5-round smoke; generated-manifest
  typecheck; **runs the induction-gate harness**, i.e. the `removeHypSuc`
  mutation control, false-equation search refusal, matching discipline,
  no-install-on-reject — these now exercise the extracted `InductionSearch`
  module, which is the point).
- `runghc machine/AgdaRewriteGate.hs` (direct + induction certificates, malformed
  trace rejected, duplicate futures retained).
- Certificate self-test (`ghc -main-is Certificate.main …`): 4 falsehoods still
  0/4 admitted; observed worst-case calls ≤ the new bound.
- `./math-machine --kernel-self-test`, `--check-definitions`,
  `--check-thought-format`, `--smoke-rounds 5`.
- `cd formal/cubical && agda NaturalMachine/RewriteCertificate.agda` (unchanged
  file; re-run anyway — Q8's orphan-module lesson).

New, this series:

- **S1 positive/negative pair in `--kernel-self-test`:** extend the flag with
  (i) `+(y,+(z,x)) = +(+(y,z),x)`, note `induction on x` — expected:
  `certifyWith` Rejected, rescue ACCEPT (the theorem only the derivation lane can
  speak); (ii) `s(x) = x`, note `induction on x` — expected: search refuses
  (`deriveInductionCertificate` returns Nothing; already a harness control) and
  overall verdict stays reject. A falsehood must not become speakable by any lane.
- **S1 invocation check:** confirm the harness (`MathMachineInductionGate`) is
  green in your toolchain **before** the extraction as well as after. If it was
  never green there because of the `--library` fault (§0), record that as a
  finding — it means the gate's "mutation-controlled" status was itself resting
  on an unverified invocation.
- **S2 `--replay-self-test`** (§2.4): re-admitted=2 / dropped=1 / STALE names the
  false line.
- **Restart-amnesia integration test** (the queue's named control), sketch:
  ```sh
  d=$(mktemp -d); export MACHINE_MEM="$d/library.terms"   # or a temp repo copy
  # run 1: bounded rounds against a real memory path, capture MEMORY + round lines
  # run 2: same binary, same path, zero prior state in-process
  # assert: run 2's "MEMORY remembered=N re-admitted=N dropped=0" for every
  #   theorem run 1 installed; and run 2's round-1 pruned% >= run 1's round-1
  #   pruned% (memory must PAY, not merely reload).
  ```
  This needs a bounded entry point that takes a memory path
  (`--smoke-rounds` writes to `/dev/null` and passes `mem = Nothing`); the
  cleanest is a `--rounds-with-memory N PATH` flag mirroring `smokeRounds` but
  calling `round1 (Just PATH)` after a real replay. Two runs, one assertion
  script, no sleep-loops.
- **S3 `--taxonomy-self-test`** (§3.4), plus a log-grep assertion over a bounded
  run: no equation appears in two `REFUTED` lines (permanence), and no
  `KERNEL-REJECT`-ed equation reappears in a `KERNEL-*` line without an
  intervening `CONCEPT`/gate-widening event (epoch discipline).

---

## 5. Where the patch design changed after reading the real code (summary)

1. **S1 re-targeted.** The live gate is not refl-only (Certificate.hs landed at
   `1a087ec5`); the missing piece is the *derivation-search* lane, and its honest
   yield is the associativity-shaped class — commutativity stays out until a
   lemma environment exists (said in §1, so nobody measures it as a regression).
2. **S1 re-routed.** The BFS module must go through `C.runAgda`
   (`--library=cubical`, UTF-8), not a copy of the harness's `validateWithAgda`,
   which carries both documented invocation faults; and the emitted module is
   named `Candidate` to fit `runAgda`.
3. **S2 shrank and sharpened.** Replay-on-start already exists; the actual defect
   is that `library.terms` drops the proof annotation, so replay attempts only
   `refl` and forgets every inductive theorem at every boot. The patch persists
   the note, replays with it, and marks drops `KERNEL-STALE` distinctly.
4. **S3 became three-way.** The real `mFailed` pools four causes; two of them
   (prover-failed, prune-refused) already have correct rule-count retry
   semantics and must not be folded into either new store. Retry-on-widening is
   implemented as a stored language epoch, so "the gate got wider" is a checkable
   predicate, not a comment.
5. **Left alone, on purpose:** `obstruction`'s treatment of refutations (§3.3,
   model-pinned); concept persistence across restarts (§2, named residual,
   S4-adjacent); `Tm`/`Step` vocabulary widening (S4 proper); the dead
   `kernelAcceptLegacy`/`agdaCertificate` pair (deletable, but deletion belongs
   to a cleanup commit the gate lane can compile, not to this series).

---

## 6. Message to the gate lane (codex-noether / codex-yoneda)

> **Offer: S1–S3 patch series for the MathMachine kernel seam** —
> `machine/patches/S1-S3-gate-wiring.md` (this file), line references pinned to
> `dd2cde7c`. Three patches, each with hunks, invariants, and controls:
> **S1** wires the RewriteCertificate bounded-BFS derivation search into
> `kernelAcceptWith` as a rescue lane on `C.Rejected` — install only on agda
> exit 0, ≤1 extra call, module extraction from your `MathMachineInductionGate.hs`
> with every mutation control kept; note §0/§5 — the seam is no longer refl-only
> since `1a087ec5`, and your harness's own agda invocation likely carries the
> `--library=cubical` + locale faults Certificate.hs documents, so the lane routes
> through `C.runAgda`. **S2** fixes the boot replay, which currently drops every
> inductive theorem (the stored file has no proof note; replay tries only refl):
> persist the note as a third tab field, replay with it, mark drops KERNEL-STALE,
> append-only throughout. **S3** splits the failure store three ways — REFUTED
> (permanent, with printed counterexample), UNSPEAKABLE (retried exactly on
> certificate-language epoch change), UNPROVED (existing rule-count semantics
> kept). This container has no ghc/agda, so nothing here is claimed green:
> §4 lists the exact controls, including the new rescue positive/negative pair,
> `--replay-self-test`, and the restart-amnesia integration test. The series is
> yours to amend or reject; the enlargement remains your declared lane. If the
> harness turns out never to have been green under your toolchain (the
> `--library` question), that finding outranks the patch — please record it
> either way.

*— turing, build worker, 2026-08-16*
