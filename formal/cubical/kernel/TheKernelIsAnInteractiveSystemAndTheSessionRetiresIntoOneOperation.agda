{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation
--
-- TERM.  संवाद · saṃvāda -- dialogue; and, technically, the CONCORDANCE of a
-- cognition with what it is about, the corroboration by which a cognition is
-- held valid.  Both senses are load-bearing here: §1 is the interface across
-- which a caller and the machine must concord, §2 is the dialogue itself.
-- The technical epistemological use is developed in more than one school --
-- the Naiyāyikas on prāmāṇya, and Dharmakīrti's *Pramāṇavārttika* (~7th c.)
-- on saṃvāda and arthakriyā -- and I establish NO first use and give no
-- single attribution.  Cite the school you are actually working from.
-- Nothing below is anyone's theorem; what is borrowed is the word's double
-- sense, which happens to be exactly this record's double role.
--
------------------------------------------------------------------------
-- A CORRECTION FIRST, BECAUSE IT IS MINE AND IT IS LOAD-BEARING.
--
-- `TheInstalledOperationHasNoPervasion…`, `TheDerivationCarriesNoMeaning…` and `WhatThisIsAndHowToDescend…` §7 read this kernel as a static
-- artifact and reported its limits.  The theorems there are true and the
-- READING WAS BACKWARDS.  Three claims are struck here, in place:
--
--  ~~"the kernel memorises"~~  `Control : Tm → Type₀` is a FIELD.  The
--    caller supplies it, and may supply ANY type family whatsoever.
--    `install` is one instance -- the trivial one -- and until now the only
--    one anybody had ever constructed:
--        grep -rn 'NativeOperation.Control' formal/cubical
--        -> the record, install, and my own theorems.  Nothing else.
--    So `enabled-set-is-subsingleton` is not a diagnosis of a lookup table.
--    It is THE SAFETY THEOREM OF AN OPEN EXTENSION POINT: whatever evidence
--    type a caller invents, it cannot enable the operation anywhere the
--    operation does not hold.  §1 supplies the first non-trivial `Control`
--    in the corpus and shows the theorem covers it for free.
--
--  ~~"no scoring, ranking, sorting or sampling -- a real gap"~~  It is the
--    design.  `advance` does not dedupe, sort or quotient because RANKING IS
--    THE CALLER'S ACT.  The machine presents; the caller disposes.  That is
--    the same refusal as `Saptabhangi`'s (a boolean verdict is a
--    theorem-grade error) and `Uttara`'s (never a bare verdict).
--
--  ~~"no semantic criterion selects the short proof -- a no-go"~~  It is a
--    GUARANTEE OF NON-DISPLACEMENT.  `TheDerivationCarriesNoMeaning…` proves the machine can never
--    take the choice from you on semantic grounds.  The system is
--    interactive by theorem, not by omission.
--
-- The generative content of the correction is §2: the loop those readings
-- missed was never written down, and it closes in one line.
--
------------------------------------------------------------------------
-- WHAT THE KERNEL ACTUALLY IS.
--
--   state      a term `Tm` -- where the dialogue currently stands
--   offer      `advance` : every enabled future, multiplicity exactly
--              conserved, nothing filtered
--   choice     the caller's, and the caller supplies the CONTROL along with
--              it -- which is why no matcher exists and why none can: an
--              arbitrary user-supplied `Control` is not decidable by the
--              machine.  That is the price of the interface being open, not
--              a missing feature.
--   result     `execute` : `EnabledFuture` (Type₁) → `CheckedFuture` (Type₀).
--              THE UNIVERSE DESCENT IS THE POINT.  The result drops the
--              operation and drops the caller's evidence, keeping only the
--              new term and the derivation that reached it -- so it is small,
--              replayable, and free of who asked.
--   learning   `install : Derivation lhs rhs → NativeOperation` accepts
--              exactly what `CheckedFuture` carries.
--
--     learn = install ∘ CheckedFuture.derivation
--
--   THE OUTPUT OF AN INTERACTION IS AN INPUT TO THE LIBRARY.  That is the
--   metacircularity, and it is interactive: the transcript of a session
--   becomes the machine's stock of moves.  `CheckedFuture` appears in no
--   file but `ControlledGrammar.agda`; the loop had never been closed.
--
--   §1  demand, any-demand-is-safe -- the extension point exercised, and the
--       old theorem re-read as its safety property.
--   §2  learn, and that what it learns is exactly what was just done.
--   §3  Session: where it started, where it stands, the derivation between,
--       and the library.  `step` advances all four together.
--   §4  THE RETIREMENT.  A session's transcript IS a derivation, hence a
--       theorem (`session-sound`: one certified equation for the whole
--       dialogue), hence installable as ONE operation (`retire`).  A whole
--       conversation collapses to a single move the machine can thereafter
--       make in one step -- and `retire-is-sound` says that move means what
--       the conversation meant.
--   §5  everything-in-the-library-is-sound: no operation ever enters the
--       library without a checked derivation, so a session cannot teach the
--       machine anything false, no matter what the caller does.
--
-- NOT CLAIMED.  No matcher, no search, no decision procedure for `Control` --
-- §0 explains why there cannot be one for an open interface.  No policy over
-- the offered list; that is the caller's and `TheDerivationCarriesNoMeaning…` proves it must be.
-- `Session` records a library but nothing here consults it when stepping;
-- the caller supplies the `EnabledFuture`.  Nothing here is concurrent, and
-- `step` is a function, not a protocol.
--
-- Checked at the pin: Agda 2.8.0, agda/cubical v0.9 (b150186) -- EXIT 0.
------------------------------------------------------------------------

module TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; isSetℕ)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)

open import RewriteCertificate
open import ControlledGrammar
open import TheInstalledOperationHasNoPervasionSoTheKernelMemorises
  using (enabled-set-is-subsingleton)

------------------------------------------------------------------------
-- §1.  THE EXTENSION POINT, EXERCISED.
--
-- `demand R d` is the operation `install d` that additionally REQUIRES the
-- caller to hand over an R -- a receipt, an authority, a cost witness, an
-- oracle token, a session identity: anything at all.  It is a `Control` no
-- previous file in this corpus has: evidence that carries strictly more than
-- the identification it must imply.
------------------------------------------------------------------------

demand : {lhs rhs : Tm} (R : Type₀) → Derivation lhs rhs → NativeOperation
NativeOperation.source        (demand {lhs} R d)      = lhs
NativeOperation.target        (demand {rhs = rhs} R d) = rhs
NativeOperation.checked       (demand R d)            = d
NativeOperation.Control       (demand {lhs} R d) t    = (t ≡ lhs) × R
NativeOperation.control-sound (demand R d) c          = fst c

-- AND THE OLD THEOREM COVERS IT, UNCHANGED.  This is the correction made
-- executable: `enabled-set-is-subsingleton` is a theorem about the RECORD,
-- so it holds of every `Control` anyone will ever write, including ones that
-- do not exist yet.  An arbitrary demand can make an operation HARDER to
-- fire and can never make it fire anywhere new.
any-demand-is-safe :
  {lhs rhs : Tm} (R : Type₀) (d : Derivation lhs rhs) {s t : Tm}
  → NativeOperation.Control (demand R d) s
  → NativeOperation.Control (demand R d) t
  → s ≡ t
any-demand-is-safe R d = enabled-set-is-subsingleton (demand R d)

-- The receipt is genuinely carried and genuinely ignored by the result: the
-- caller must produce it, and what comes back does not mention it.  That
-- separation is what makes a result replayable by someone who was not there.
the-demand-is-real :
  {lhs rhs : Tm} {R : Type₀} (d : Derivation lhs rhs) (t : Tm)
  → NativeOperation.Control (demand R d) t → R
the-demand-is-real d t c = snd c

------------------------------------------------------------------------
-- §2.  THE LOOP, CLOSED.  One line, and nothing in the corpus had it.
------------------------------------------------------------------------

learn : {s : Tm} → CheckedFuture s → NativeOperation
learn f = install (CheckedFuture.derivation f)

-- What it learns is exactly what was just done -- endpoints on the nose.
learn-remembers-where-it-was :
  {s : Tm} (f : CheckedFuture s) → NativeOperation.source (learn f) ≡ s
learn-remembers-where-it-was f = refl

learn-remembers-where-it-went :
  {s : Tm} (f : CheckedFuture s) → NativeOperation.target (learn f) ≡ CheckedFuture.target f
learn-remembers-where-it-went f = refl

------------------------------------------------------------------------
-- §3.  THE SESSION.  Concatenation of transcripts, first.
------------------------------------------------------------------------

infixr 5 _⊕_
_⊕_ : {a b c : Tm} → Derivation a b → Derivation b c → Derivation a c
done _        ⊕ e = e
then-step p d ⊕ e = then-step p (d ⊕ e)

-- Concatenation means what it should: the composite's meaning is the
-- composite of the meanings, so a transcript is never re-verified when it is
-- extended.  THE PROOF IS `isSetℕ`, and that is `TheDerivationCarriesNoMeaning…` PAYING FOR ITSELF --
-- the meaning type is a proposition, so any two proofs of it agree and this
-- lemma costs nothing.  The same fact that makes the semantics blind to route
-- is what makes transcripts free to concatenate.  Read as a limitation it was
-- a no-go; read at the interface it is why a long session is cheap.
⊕-sound : {a b c : Tm} (d : Derivation a b) (e : Derivation b c) (ρ : Env)
  → derivation-sound (d ⊕ e) ρ ≡ derivation-sound d ρ ∙ derivation-sound e ρ
⊕-sound {a} {c = c} d e ρ = isSetℕ (eval a ρ) (eval c ρ) _ _

record Session : Type₁ where
  constructor session
  field
    origin  : Tm                      -- where the dialogue began
    here    : Tm                      -- where it stands
    trace   : Derivation origin here  -- the whole transcript, proof-relevant
    library : List NativeOperation    -- what it has learned on the way

open Session

begin : Tm → Session
begin t = session t t (done t) []

-- ONE TURN.  The caller supplies the future -- operation AND control -- and
-- the session advances its position, its transcript and its library
-- together.  Nothing is dropped and nothing is quotiented.
step : (S : Session) → EnabledFuture (here S) → Session
step S f = session (origin S) (EnabledFuture.target f)
                   (trace S ⊕ EnabledFuture.derivation f)
                   (learn (execute f) ∷ library S)

step-grows-the-library :
  (S : Session) (f : EnabledFuture (here S))
  → length (library (step S f)) ≡ ℕ.suc (length (library S))
step-grows-the-library S f = refl

step-keeps-the-origin :
  (S : Session) (f : EnabledFuture (here S)) → origin (step S f) ≡ origin S
step-keeps-the-origin S f = refl

------------------------------------------------------------------------
-- §4.  THE RETIREMENT.  A dialogue is a theorem, and a theorem is a move.
------------------------------------------------------------------------

-- The whole session, however long, is ONE certified equation.
session-sound : (S : Session) (ρ : Env) → eval (origin S) ρ ≡ eval (here S) ρ
session-sound S ρ = derivation-sound (trace S) ρ

-- And therefore ONE operation.  Everything the caller did across the whole
-- conversation becomes a single move the machine can thereafter make in one
-- step -- which is the metacircular close: the transcript is the library.
retire : Session → NativeOperation
retire S = install (trace S)

retire-spans-the-whole-session :
  (S : Session)
  → (NativeOperation.source (retire S) ≡ origin S)
  × (NativeOperation.target (retire S) ≡ here S)
retire-spans-the-whole-session S = refl , refl

-- and the retired move means what the conversation meant.
retire-is-sound :
  (S : Session) (ρ : Env)
  → eval (NativeOperation.source (retire S)) ρ ≡ eval (NativeOperation.target (retire S)) ρ
retire-is-sound S = session-sound S

------------------------------------------------------------------------
-- §5.  A SESSION CANNOT TEACH THE MACHINE ANYTHING FALSE.
--
-- Every route into the library goes through a `Derivation`, and every
-- `Derivation` is sound at every environment.  So no matter what the caller
-- supplies as `Control` -- §1 says that may be anything -- the library stays
-- true.  This is the interactive system's one guarantee, and it is the
-- reason the extension point can be left open.
------------------------------------------------------------------------

-- Stated without a membership predicate on purpose, because the guarantee is
-- stronger than membership: a `NativeOperation` CANNOT BE CONSTRUCTED at all
-- without a checked derivation between its declared endpoints.  There is no
-- route into the library that could carry something false, so there is
-- nothing for a session to be trusted about.
every-operation-that-exists-is-sound :
  (op : NativeOperation) (ρ : Env)
  → eval (NativeOperation.source op) ρ ≡ eval (NativeOperation.target op) ρ
every-operation-that-exists-is-sound op ρ =
  derivation-sound (NativeOperation.checked op) ρ

-- In particular the one a turn just added, whatever the caller's evidence was.
what-a-turn-teaches-is-sound :
  (S : Session) (f : EnabledFuture (here S)) (ρ : Env)
  → eval (here S) ρ ≡ eval (EnabledFuture.target f) ρ
what-a-turn-teaches-is-sound S f =
  every-operation-that-exists-is-sound (learn (execute f))
