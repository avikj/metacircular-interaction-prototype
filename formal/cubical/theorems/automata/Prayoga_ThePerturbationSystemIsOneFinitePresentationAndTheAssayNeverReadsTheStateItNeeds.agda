{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रयोग — the experiment.
--
-- THE CLAIM (2026-09-14): the 2026 Virtual Cell Challenge object is one
-- ORDINARY evaluation of the interaction calculus — the first biological
-- finite presentation fed to the corpus unchanged.  Nothing in this file
-- is a new construction.  It is AdiBija (receiver, fold, uniqueness),
-- Vivarana (one object, its complete reading across a lens family),
-- Krama (commutation kept, its failure retained), the Myhill–Nerode
-- minimal machine (Meaning = X / future-behaviour, imported and
-- instantiated, not re-proved) and erasure-by-descent (the set
-- quotient's recursor and its resp obligation), each run at a
-- perturbation system instead of the rewrite kernel.  The Agda
-- counterpart of collab/bend2-cubical/port/Perturbation.bend, one
-- declaration for one declaration.
--
-- THE FINITE PRESENTATION.  A cell is its measured levels on a gene
-- panel; an intervention is the knockdown of one gene or a passage
-- (time); the perturbational continuation algebra `step` is the
-- generator action.  The panel here is three genes with one regulatory
-- edge — tf activates tgt at passage; hk is regulated by nothing — the
-- SHAPE of the challenge object, not its data.  The real panel and
-- generators enter by a front-end that emits this file's `Cell`,
-- `Perturb` and `step` from the released control populations; the
-- theorems are stated for this panel and hold for any finite panel with
-- the same generator signature.
--
--   §1  generators, steps, derivations: a Step is an intervention with
--       its endpoint equation, a Derivation is a history of them.
--   §2  Receiver = (Motion, ε, ◂); the fold exists; the fold is unique
--       (AdiBija, at Cell instead of Tm).
--   §3  four readings of one history — length, "was gene g hit",
--       endpoint, word — as four receivers of one recursor.  The
--       endpoint reading IS the endpoint (endpoint-is-endpoint); the
--       word reading replays to it (word-replays): the answer is a
--       projection of the route.
--   §4  Vivarana: two histories of the same interventions in a
--       different order (knock tf then passage / passage then knock tf)
--       are IDENTIFIED by the length and targeted-gene lenses (refl)
--       and SEPARATED by the endpoint lens (tgt reads 0 in one and 1 in
--       the other).  Krama: knockdowns commute (the certificate is
--       refl) and knockdown does not commute with passage (a computed
--       refutation) — the order is data exactly where the endpoint
--       lens read it.
--   §5  THE ASSAY READS tgt ONLY.  Nerode = agreement under every
--       future word, imported.  (a) tf is never read and is NECESSARY
--       STATE: the one future [passage] separates two cells the assay
--       cannot tell apart now (tf-is-necessary).  (b) hk is never read
--       and is ERASABLE: cells agreeing on (tf, tgt) agree on (tf, tgt)
--       after every future (agree-run, by induction on the word; also
--       an instance of the imported "every behavioural congruence is
--       contained in Nerode"), so their meanings are one point of the
--       quotient (hk-same-meaning, by eq/).  Effectivity is inherited
--       from the generic quotient (meaning-is-future), so the two
--       necessary cells have DIFFERENT meanings (tf-separates-meanings).
--   §6  ERASURE = DESCENT.  Forgetting hk is the set quotient of Cell
--       by agreement on (tf, tgt).  A receiver runs after the erasure
--       iff it factors through it, and the recursor's resp obligation
--       is that factorisation: visibleLoad and the assay descend, and
--       R = R̄ ∘ q on the nose (refl); every generator descends too, so
--       the erased object is again a machine.  The receiver that reads
--       hk does NOT descend, and here that is a theorem rather than a
--       must-fail file: its resp obligation is uninhabited
--       (hk-does-not-descend).
--   §7  THE CHALLENGE SHAPE.  A context is a control population, the
--       submission for p is the population under p, a protocol is a
--       receiver over populations.  Pseudobulk of tgt descends through
--       the erasure cellwise, so it may be scored on the erased object;
--       the numbers of a three-cell context are computed by refl.
--
-- What is decided here and not modelled: which state the assay never
-- reads is nevertheless needed is not a modelling choice but a theorem
-- of the generator family — one future word refuses the erasure of tf
-- and no future word ever refuses the erasure of hk.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Prayoga_ThePerturbationSystemIsOneFinitePresentationAndTheAssayNeverReadsTheStateItNeeds where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; znots ; snotz ; isSetℕ)
open import Cubical.Data.Bool using (Bool ; true ; false ; _or_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; squash/)

import MyhillNerodeMinimalMachine as FB
open import Fibre.Krama_CommutationIsTheProofThatTheOrderWasNeverThereAndItsFailureIsRetained
  using (Commutes)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · The finite presentation.
------------------------------------------------------------------------

data Gene : Type where
  TF TGT HK : Gene

-- a cell = its levels on the panel
record Cell : Type where
  constructor cell
  field
    tf tgt hk : ℕ
open Cell

-- the interventions available at the boundary
data Perturb : Type where
  kd      : Gene → Perturb
  passage : Perturb

-- the generator actions: a knockdown zeroes its gene; a passage lets the
-- one regulatory edge act (tgt follows tf); hk is regulated by nothing
knock : Gene → Cell → Cell
knock TF  c = cell 0 (tgt c) (hk c)
knock TGT c = cell (tf c) 0 (hk c)
knock HK  c = cell (tf c) (tgt c) 0

step : Cell → Perturb → Cell
step c (kd g)  = knock g c
step c passage = cell (tf c) (tf c) (hk c)

-- a step is an intervention with its endpoint equation …
data Step : Cell → Cell → Type where
  act : (c : Cell) (p : Perturb) → Step c (step c p)

-- … and a derivation is a history of interventions from one cell state
-- to another
data Derivation : Cell → Cell → Type where
  done      : (c : Cell) → Derivation c c
  then-step : {a b c : Cell} → Step a b → Derivation b c → Derivation a c

stepPerturb : {a b : Cell} → Step a b → Perturb
stepPerturb (act _ p) = p

------------------------------------------------------------------------
-- २ · A receiver of the system's motion, and the fold (AdiBija).
------------------------------------------------------------------------

record Receiver (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Motion : Cell → Cell → Type ℓ           -- a carrier for each source/target
    ε      : (c : Cell) → Motion c c         -- how it reads a rest
    _◂_    : {a b c : Cell} → Step a b → Motion b c → Motion a c
                                             -- how it reads one step then the rest
open Receiver

-- THE FOLD EXISTS: every receiver is built upon the presentation.
fold : (R : Receiver ℓ) {a z : Cell} → Derivation a z → Motion R a z
fold R (done c)        = ε R c
fold R (then-step s d) = (R ◂ s) (fold R d)

-- THE FOLD IS UNIQUE: anything with its two computation rules is it.
module _ (R : Receiver ℓ) (g : {a z : Cell} → Derivation a z → Motion R a z)
         (g-done : {c : Cell} → g (done c) ≡ ε R c)
         (g-step : {a b c : Cell} (s : Step a b) (d : Derivation b c)
                   → g (then-step s d) ≡ (R ◂ s) (g d))
  where

  fold-unique : {a z : Cell} (d : Derivation a z) → g d ≡ fold R d
  fold-unique (done c)        = g-done
  fold-unique (then-step s d) = g-step s d ∙ cong (R ◂ s) (fold-unique d)

------------------------------------------------------------------------
-- ३ · Four readings of one history.
------------------------------------------------------------------------

sameGene : Gene → Gene → Bool
sameGene TF  TF  = true
sameGene TGT TGT = true
sameGene HK  HK  = true
sameGene _   _   = false

targets : Gene → Perturb → Bool
targets g (kd g') = sameGene g g'
targets g passage = false

-- (a) LENGTH: how many interventions
lenR : Receiver ℓ-zero
Motion lenR _ _ = ℕ
ε lenR _        = zero
_◂_ lenR _ n    = suc n

steps : {a z : Cell} → Derivation a z → ℕ
steps = fold lenR

-- (b) TARGETED: was gene g directly intervened on (a DEG-by-target
--     protocol)
hitR : Gene → Receiver ℓ-zero
Motion (hitR g) _ _ = Bool
ε (hitR g) _        = false
_◂_ (hitR g) s m    = targets g (stepPerturb s) or m

targeted : Gene → {a z : Cell} → Derivation a z → Bool
targeted g = fold (hitR g)

-- (c) ENDPOINT: the terminal state (the pseudobulk of one cell)
endR : Receiver ℓ-zero
Motion endR _ _ = Cell
ε endR c        = c
_◂_ endR _ m    = m

endpoint : {a z : Cell} → Derivation a z → Cell
endpoint = fold endR

-- the endpoint reading is the endpoint: the answer is a projection of
-- the route
endpoint-is-endpoint : {a z : Cell} (d : Derivation a z) → endpoint d ≡ z
endpoint-is-endpoint (done c)        = refl
endpoint-is-endpoint (then-step s d) = endpoint-is-endpoint d

-- (d) WORD: the interventions in order (the retrieval protocol; loses
--     nothing)
wordR : Receiver ℓ-zero
Motion wordR _ _ = List Perturb
ε wordR _        = []
_◂_ wordR s w    = stepPerturb s ∷ w

word : {a z : Cell} → Derivation a z → List Perturb
word = fold wordR

-- running the machine on the word replays the history to its endpoint
runC : Cell → List Perturb → Cell
runC = FB.run step

word-replays : {a z : Cell} (d : Derivation a z) → runC a (word d) ≡ z
word-replays (done c)                = refl
word-replays (then-step (act _ p) d) = word-replays d

------------------------------------------------------------------------
-- ४ · Vivarana: one object, its complete reading across the lens
--     family; two histories of the same interventions in a different
--     order.
------------------------------------------------------------------------

record Vivarana {a z : Cell} (d : Derivation a z) : Type where
  field
    count        : ℕ                -- the length lens
    tf-targeted  : Bool             -- the targeted-gene lens, at tf
    tgt-targeted : Bool             -- the targeted-gene lens, at tgt
    final        : Cell             -- the endpoint lens
    trace        : List Perturb     -- the word lens
open Vivarana

-- THE ELUCIDATOR.  One object in, its full reading out — each field a
-- fold, so the record is generated by the recursor, not assembled.
elucidate : {a z : Cell} (d : Derivation a z) → Vivarana d
count        (elucidate d) = steps d
tf-targeted  (elucidate d) = targeted TF d
tgt-targeted (elucidate d) = targeted TGT d
final        (elucidate d) = endpoint d
trace        (elucidate d) = word d

-- the control cell, and two histories: knock tf then passage / passage
-- then knock tf
control : Cell
control = cell 1 1 1

kd-then-pass : Derivation control (cell 0 0 1)
kd-then-pass =
  then-step (act control (kd TF))
    (then-step (act (cell 0 1 1) passage)
      (done (cell 0 0 1)))

pass-then-kd : Derivation control (cell 0 1 1)
pass-then-kd =
  then-step (act control passage)
    (then-step (act (cell 1 1 1) (kd TF))
      (done (cell 0 1 1)))

-- identified by the length lens …
same-length : count (elucidate kd-then-pass) ≡ count (elucidate pass-then-kd)
same-length = refl

-- … and by the targeted-gene lens (both histories intervene on tf,
-- neither on tgt) …
same-tf-targeted : tf-targeted (elucidate kd-then-pass) ≡ tf-targeted (elucidate pass-then-kd)
same-tf-targeted = refl

same-tgt-targeted : tgt-targeted (elucidate kd-then-pass) ≡ tgt-targeted (elucidate pass-then-kd)
same-tgt-targeted = refl

-- … and separated by the endpoint lens: tgt reads 0 in one and 1 in the
-- other.  A protocol that scores "which genes were targeted" cannot see
-- this; the endpoint protocol can; one object carries both facts.
endpoints-differ : ¬ (final (elucidate kd-then-pass) ≡ final (elucidate pass-then-kd))
endpoints-differ p = znots (cong tgt p)

-- KRAMA.  Two knockdowns commute — the certificate is refl, so their
-- serialisation is an artefact and either order is the same object …
kd-kd-commute : Commutes (λ c → step c (kd HK)) (λ c → step c (kd TF))
kd-kd-commute c = refl

-- … and knockdown against passage does not: the order is data, and it
-- is exactly the data the endpoint lens read above.
kd-pass-dont-commute :
  ¬ (step (step control (kd TF)) passage ≡ step (step control passage) (kd TF))
kd-pass-dont-commute p = znots (cong tgt p)

------------------------------------------------------------------------
-- ५ · The assay reads tgt only.  Meaning = Cell / future-behaviour.
------------------------------------------------------------------------

assayTgt : Cell → ℕ
assayTgt = tgt

-- agreement under every future word, from the generic machine
NerodeTgt : Cell → Cell → Type
NerodeTgt = FB.NerodeCongruence step assayTgt

module MeaningTgt = FB.MinimalMachine step isSetℕ assayTgt

-- (a) tf is never read by the assay, and it is NECESSARY: the future
--     [passage] separates two cells the assay cannot tell apart now.
tf-is-necessary : ¬ NerodeTgt (cell 1 0 0) (cell 0 0 0)
tf-is-necessary h = snotz (h (passage ∷ []))

-- (b) hk is never read, and it is ERASABLE: cells agreeing on (tf, tgt)
--     agree on (tf, tgt) after every future — by induction on the word.
AgreeVis : Cell → Cell → Type
AgreeVis x y = (tf x ≡ tf y) × (tgt x ≡ tgt y)

agree-step : (x y : Cell) → AgreeVis x y → (p : Perturb) → AgreeVis (step x p) (step y p)
agree-step x y (pa , pb) (kd TF)  = refl , pb
agree-step x y (pa , pb) (kd TGT) = pa , refl
agree-step x y (pa , pb) (kd HK)  = pa , pb
agree-step x y (pa , pb) passage  = pa , pa

agree-run : (x y : Cell) → AgreeVis x y → (w : List Perturb) → AgreeVis (runC x w) (runC y w)
agree-run x y r []      = r
agree-run x y r (p ∷ w) = agree-run (step x p) (step y p) (agree-step x y r p) w

visTgt : (x y : Cell) → AgreeVis x y → tgt x ≡ tgt y
visTgt x y r = snd r

hk-is-invisible : (a b h h' : ℕ) → NerodeTgt (cell a b h) (cell a b h')
hk-is-invisible a b h h' w =
  visTgt _ _ (agree-run (cell a b h) (cell a b h') (refl , refl) w)

-- the same fact from the imported side: agreement on (tf, tgt) is a
-- behavioural congruence, hence contained in Nerode (the greatest one)
agreeVis-isCongruence : FB.isBehavioralCongruence step assayTgt AgreeVis
agreeVis-isCongruence = record
  { respects-observe = λ r → snd r
  ; respects-step    = λ p r → agree-step _ _ r p
  }

agreeVis⊆Nerode : {x y : Cell} → AgreeVis x y → NerodeTgt x y
agreeVis⊆Nerode = FB.congruence→nerodeCongruence agreeVis-isCongruence

-- so two cells differing only in hk have the same meaning …
hk-same-meaning : (a b h h' : ℕ)
  → Path MeaningTgt.Meaning [ cell a b h ] [ cell a b h' ]
hk-same-meaning a b h h' = eq/ _ _ (hk-is-invisible a b h h')

-- … and, by effectivity (generic, inherited), equal meaning is the same
-- future
meaning-is-future : (x y : Cell)
  → Path MeaningTgt.Meaning [ x ] [ y ] → NerodeTgt x y
meaning-is-future = MeaningTgt.nerodeCongruence-effective

-- the two necessary cells have different meanings: a path would be a
-- future-agreement, and one future refuses it
tf-separates-meanings : ¬ (Path MeaningTgt.Meaning [ cell 1 0 0 ] [ cell 0 0 0 ])
tf-separates-meanings p = tf-is-necessary (meaning-is-future _ _ p)

------------------------------------------------------------------------
-- ६ · Erasure = descent.  Forgetting hk is the quotient by AgreeVis; a
--     receiver runs after the erasure iff it factors through it, and
--     the recursor's resp obligation is that factorisation.
------------------------------------------------------------------------

Erased : Type
Erased = Cell / AgreeVis

erase : Cell → Erased
erase c = [ c ]

-- a receiver that reads through (tf, tgt) descends: the obligation is
-- inhabited
visibleLoad : Cell → ℕ
visibleLoad c = tf c + tgt c

visibleLoad-descends : (x y : Cell) → AgreeVis x y → visibleLoad x ≡ visibleLoad y
visibleLoad-descends x y (pa , pb) i = pa i + pb i

visibleLoad-erased : Erased → ℕ
visibleLoad-erased = SQ.rec isSetℕ visibleLoad visibleLoad-descends

-- and it computes on representatives: R = R̄ ∘ q, on the nose
visibleLoad-factors : (c : Cell) → visibleLoad-erased (erase c) ≡ visibleLoad c
visibleLoad-factors c = refl

-- the assay itself descends (it is the second projection of the
-- agreement)
assay-erased : Erased → ℕ
assay-erased = SQ.rec isSetℕ assayTgt visTgt

assay-factors : (c : Cell) → assay-erased (erase c) ≡ assayTgt c
assay-factors c = refl

-- the erasure is compatible with every generator: the machine descends
-- too
step-descends : (x y : Cell) → AgreeVis x y → (p : Perturb)
  → Path Erased [ step x p ] [ step y p ]
step-descends x y r p = eq/ _ _ (agree-step x y r p)

step-erased : Erased → Perturb → Erased
step-erased m p = SQ.rec squash/ (λ c → [ step c p ]) (λ x y r → step-descends x y r p) m

step-erased-factors : (c : Cell) (p : Perturb) → step-erased (erase c) p ≡ erase (step c p)
step-erased-factors c p = refl

-- THE RECEIVER THAT READS hk DOES NOT DESCEND.  In the Bend port this
-- is a must-fail file — the substrate rejects the collapse.  Here the
-- negative is a theorem: the resp obligation the recursor would demand
-- of hk is uninhabited, witnessed by two cells that agree on everything
-- visible and differ on hk.
hk-does-not-descend : ¬ ((x y : Cell) → AgreeVis x y → hk x ≡ hk y)
hk-does-not-descend resp = znots (resp (cell 0 0 0) (cell 0 0 1) (refl , refl))

------------------------------------------------------------------------
-- ७ · The challenge shape.  A context is its control population; the
--     submission for intervention p is the population under p; a
--     protocol is a receiver over populations.  Pseudobulk of tgt
--     descends through the erasure cellwise, so it may be scored on the
--     erased object.
------------------------------------------------------------------------

Context : Type
Context = List Cell

predict : Context → Perturb → Context
predict x p = map (λ c → step c p) x

pseudobulkTgt : Context → ℕ
pseudobulkTgt []       = 0
pseudobulkTgt (c ∷ cs) = tgt c + pseudobulkTgt cs

pseudobulkTgt-erased : List Erased → ℕ
pseudobulkTgt-erased []       = 0
pseudobulkTgt-erased (m ∷ ms) = assay-erased m + pseudobulkTgt-erased ms

pseudobulk-descends : (x : Context)
  → pseudobulkTgt-erased (map erase x) ≡ pseudobulkTgt x
pseudobulk-descends []       = refl
pseudobulk-descends (c ∷ cs) = cong (tgt c +_) (pseudobulk-descends cs)

-- context A: three control cells; the submission for kd(tf) after one
-- passage
contextA : Context
contextA = cell 2 1 5 ∷ cell 1 1 3 ∷ cell 0 1 7 ∷ []

submissionA : Context
submissionA = predict (predict contextA (kd TF)) passage

submissionA-pseudobulk : pseudobulkTgt submissionA ≡ 0
submissionA-pseudobulk = refl

controlA-pseudobulk : pseudobulkTgt (predict contextA passage) ≡ 3
controlA-pseudobulk = refl

-- The point, stated: the assay (tgt), the erasure (forget hk), the
-- necessity of tf, the scoring protocol (pseudobulk) and the challenge
-- object (context ↦ submission) are not five modelling decisions — they
-- are one finite presentation read through receivers, and which state
-- may be erased is decided by whether the requested receivers descend.
