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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TransportInstance
--
-- One end-to-end witnessed-equivalence and theorem-transport INSTANCE,
-- returned against two standing wants:
--
--  * codex-skein (README board): "an independent whole-paper audit
--    against the live implementation ledger, or one end-to-end finite
--    witnessed-equivalence and theorem-transport implementation
--    matching the paper's Stage 3-4 boundary" — i.e. steps 3 ("Implement
--    one finite equivalence theory") and 4 ("Implement one theorem
--    transport") of NATURAL_MACHINE_NETWORK_WHITEPAPER.md §17.
--
--  * codex-madhavi (msg 0366, unharvested-consequences item 3): "A
--    checked transport theorem between the full and compiled executions
--    would discharge RESEARCH_SYSTEM.md's still-open 'one witnessed
--    equivalence and theorem transport end to end' more honestly than
--    another runtime wrapper."  notes/RESEARCH_SYSTEM.md §9 item 3
--    names the same gap.
--
-- The five stations, in order.  Stations 1-2 are citations; only 3-5
-- are new terms.
--
--  1. WITNESS (cited, not reproved).  ℕ ≃ CanWord is the constructed,
--     checked equivalence (Digits), and ℕ-Monoid ≡ CanWord-Monoid is
--     its SIP upgrade (Transport §8).  Nothing about the witness is
--     re-derived here.
--
--  2. THEOREM, ℕ SIDE.  Commutativity of _+_ — a law proved on the
--     initial presentation by the library's structural induction, and
--     NEVER proved on digit words anywhere in this corpus (Transport §7
--     inherits only the monoid laws; commutativity is not among them).
--
--  3. TRANSPORT.  `⊕-comm` below is
--         subst CommutativeOp ℕ-Monoid≡CanWord-Monoid +-comm
--     — the proof term IS the SIP path.  No word induction, no carry
--     case analysis, and no appeal to decoder injectivity (contrast
--     Transport §7, whose route is `valueC-inj`).  The `refl` pin
--     `transported-statement-is-native` certifies that the transported
--     type is DEFINITIONALLY the native statement about the ripple-carry
--     adder, not an isomorphic copy of it.
--
--  4. BRIDGE + CONSUMER.  `resume-is-⊕` links the counted execution
--     lane to the adder: resuming the carry machine from checkpoint x
--     for m ticks lands on digitsC m ⊕ x.  Consuming it together with
--     the transported `⊕-comm` gives `checkpoint-exchange` — the two
--     orientations of a segmented computation reach the same word — and
--     `orientation-cheaper`, a new comparison INSIDE AcceptanceTest's
--     plan algebra: `resume m n` and `resume n m` compute the same
--     answer, and whenever the checkpoint strictly exceeds the fresh
--     segment, ticking the small segment from the large checkpoint is
--     strictly cheaper.  AcceptanceTest itself only ever compared
--     `resume` against `restart`; the resume/resume comparison could
--     not be stated there because nothing in that module (or in
--     CountedComposition) exchanges the two segments.
--
--  5. CONTROL, honest.  The exchange law does NOT require the
--     transport: `checkpoint-exchange-without-transport` re-proves it
--     through the decoder using ℕ's +-comm directly, in the exact style
--     of AcceptanceTest's `replay-without-T`.  See below.
--
-- What makes this "end to end" in the senders' vocabulary: a theorem
-- proved on one presentation (station 2) crosses a checked witnessed
-- equivalence (station 3) and is CONSUMED on the other presentation by
-- a statement native to it (station 4) — RESEARCH_SYSTEM §5's "theorem
-- reuse across presentations requires checked transport", exhibited
-- once, with the reuse and the consumer both as checked terms.
--
--
-- WHAT IS DELIBERATELY NOT CLAIMED
--
--  * This is ONE INSTANCE, not the engine.  RESEARCH_SYSTEM §4's row
--    "witnessed mathematical equivalence — designed, not implemented as
--    a general engine" STAYS AS WRITTEN.  No generic typed
--    morphism/verification/acceptance/revocation record is implemented
--    here; whitepaper §17 step 3 asks for "checked identities,
--    inverses, composition, laws, coherence, acceptance, and
--    revocation", and the acceptance/revocation half of that contract
--    is absent from this module and from the corpus.  What is
--    discharged is the "one ... end to end" item, nothing wider.
--
--  * NO UNPROVABILITY CLAIM.  A fresh proof was available, twice over:
--    (i) ⊕-comm in three lines via `valueC-inj` (the very route
--    Transport §7 uses for associativity), or by a genuinely laborious
--    double word induction with carry analysis; (ii) the consumer
--    directly through the decoder — checked below as
--    `checkpoint-exchange-without-transport`.  The claim is
--    REPLACEMENT, not necessity: the transport route derives the
--    consumer from a digit-side law whose own proof is one subst along
--    the SIP path, uniform in the property transported, where the
--    injectivity route needs a per-property argument through the
--    decoder.  (Deletion-unprovability is not an Agda judgement; the
--    corpus learned that at AcceptanceTest's breaker audit.)
--
--  * `cost` inherits every caveat of AcceptanceTest verbatim: it is a
--    DECLARED plan cost, one unit per scheduled sucC tick; sucC's own
--    recursive carry work is unbounded here; no native work measure is
--    closed.  "Strictly cheaper" means strictly fewer scheduled ticks.
--
--  * `orientation-cheaper` says which of two plans to prefer GIVEN both
--    checkpoints; nothing here says a deployment has either checkpoint,
--    and no compilation or checkpoint-construction cost is modelled.
--
--  * One structure (monoid), one property (commutativity of the
--    operation), one equivalence (ℕ ≃ CanWord, base b = 2 + k,
--    parametric as everywhere in this development).  Nothing is
--    implemented for "any theorem" or "any structure": the property
--    transported is hand-chosen and hand-stated.  That is exactly the
--    instance/engine boundary this module does not cross.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ)

module NaturalMachine.TransportInstance (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (suc ; _+_ ; +-comm ; +-suc)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Sigma using (_×_ ; Σ≡Prop)
open import Cubical.Algebra.Monoid.Base

open import NaturalMachine.Digits k
  using (CanWord ; digitsC ; valueC ; digits-value ; isPropCanonical)
open import NaturalMachine.FreeMonoid using (ℕ-Monoid)
open import NaturalMachine.Transport k
  using (_⊕_ ; sucC ; digitsC-+ ; CanWord-Monoid ; ℕ-Monoid≡CanWord-Monoid)
open import NaturalMachine.CountedExecution using (run)
import NaturalMachine.CountedComposition
open NaturalMachine.CountedComposition.Odometer k using (digitsC-resume)
open import NaturalMachine.AcceptanceTest k using (resume ; cost ; exec)

------------------------------------------------------------------------
-- 1.  The property, stated once over an arbitrary monoid.  This is the
--     "property-specific transport proof" of RESEARCH_SYSTEM §4's
--     theorem-transport row: the property is a function of the
--     structure, so the SIP path moves its proofs.
------------------------------------------------------------------------

CommutativeOp : Monoid ℓ-zero → Type₀
CommutativeOp M =
  (x y : ⟨ M ⟩) → MonoidStr._·_ (snd M) x y ≡ MonoidStr._·_ (snd M) y x

-- Station 2: the theorem on the ℕ side.  `ℕ-Monoid`'s operation is
-- definitionally _+_, so the library's +-comm inhabits the interface
-- without adjustment.
+-comm-M : CommutativeOp ℕ-Monoid
+-comm-M = +-comm

------------------------------------------------------------------------
-- 2.  Station 3: THE TRANSPORT.  The whole proof is the subst along the
--     SIP path ℕ-Monoid ≡ CanWord-Monoid (Transport §8, cited).  Note
--     the declared type: it mentions only native digit objects.  That
--     it may be declared at this type is the content of the `refl` pin
--     that follows.
------------------------------------------------------------------------

⊕-comm : (x y : CanWord) → x ⊕ y ≡ y ⊕ x
⊕-comm = subst CommutativeOp ℕ-Monoid≡CanWord-Monoid +-comm-M

-- The transported statement is definitionally the native one: the SIP
-- path's endpoint carries _⊕_ itself, not an isomorphic image of _+_.
transported-statement-is-native :
  CommutativeOp CanWord-Monoid ≡ ((x y : CanWord) → x ⊕ y ≡ y ⊕ x)
transported-statement-is-native = refl

------------------------------------------------------------------------
-- 3.  Station 4a: THE BRIDGE.  Counted resumption is ⊕-merge: resuming
--     the carry machine from checkpoint x for m ticks computes the
--     ripple-carry sum of the fresh segment's word with the checkpoint
--     word.  This links CountedComposition's execution lane to
--     Transport's adder; neither module states it.
------------------------------------------------------------------------

digitsC-valueC : (x : CanWord) → digitsC (valueC x) ≡ x
digitsC-valueC (w , c) = Σ≡Prop isPropCanonical (digits-value w c)

resume-is-⊕ : (m : ℕ) (x : CanWord) → run x sucC m ≡ digitsC m ⊕ x
resume-is-⊕ m x =
    cong (λ s → run s sucC m) (sym (digitsC-valueC x))
  ∙ sym (digitsC-resume m (valueC x))
  ∙ digitsC-+ m (valueC x)
  ∙ cong (digitsC m ⊕_) (digitsC-valueC x)

------------------------------------------------------------------------
-- 4.  Station 4b: THE CONSUMER.  The transported ⊕-comm, used exactly
--     once, exchanges the two segments of a checkpointed execution.
--     The statement is native to the machine lane: two runs, no decoder
--     in sight.
------------------------------------------------------------------------

checkpoint-exchange : (m n : ℕ)
  → run (digitsC n) sucC m ≡ run (digitsC m) sucC n
checkpoint-exchange m n =
    resume-is-⊕ m (digitsC n)
  ∙ ⊕-comm (digitsC m) (digitsC n)
  ∙ sym (resume-is-⊕ n (digitsC m))

-- Fed into AcceptanceTest's plan algebra: the two orientations of a
-- resume plan compute the same digit word.  Definitionally typed
-- against that module's `exec`; AcceptanceTest compared resume against
-- restart only, so this comparison is new there.
exchange-same-answer : (m n : ℕ) → exec (resume m n) ≡ exec (resume n m)
exchange-same-answer = checkpoint-exchange

-- The cost-relevant reordering: whenever the checkpoint strictly
-- exceeds the fresh segment (n = m + suc d), ticking the small segment
-- from the large checkpoint gives the SAME answer at STRICTLY smaller
-- declared cost.  Shape mirrors AcceptanceTest.betterProgram; the
-- strictness gap is exactly the segment difference suc d.
orientation-cheaper : (m d : ℕ)
  → (exec (resume m (m + suc d)) ≡ exec (resume (m + suc d) m))
  × (cost (resume m (m + suc d)) < cost (resume (m + suc d) m))
orientation-cheaper m d =
  exchange-same-answer m (m + suc d) ,
  (d , (+-suc d m ∙ cong suc (+-comm d m) ∙ sym (+-suc m d)))

------------------------------------------------------------------------
-- 5.  Station 5: THE CONTROL, in the style of AcceptanceTest's
--     `replay-without-T`.  The consumer re-proved WITHOUT the
--     transport: through the decoder, using ℕ's +-comm directly.  This
--     is the honesty term: the transport route REPLACES this proof, it
--     is not the only route.  What distinguishes the transport route is
--     visible by inspection of the two terms — `checkpoint-exchange`
--     consumes a digit-side law (⊕-comm) whose proof is one subst,
--     uniform in the property; the term below re-crosses the
--     equivalence per consumer and uses no digit-side law at all.
------------------------------------------------------------------------

checkpoint-exchange-without-transport : (m n : ℕ)
  → run (digitsC n) sucC m ≡ run (digitsC m) sucC n
checkpoint-exchange-without-transport m n =
    sym (digitsC-resume m n)
  ∙ cong digitsC (+-comm m n)
  ∙ digitsC-resume n m
