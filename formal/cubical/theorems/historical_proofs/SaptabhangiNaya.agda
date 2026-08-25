{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Saptabhangi — the sevenfold conditional predication, as a checked type
--
-- SOURCES, EARLIEST FIRST.  These are the origin of the doctrine, not a
-- gloss on it, and this file cites them because the structure below is
-- theirs and not mine.
--
--   Bhagavatī Sūtra (Viyāha-pannatti / Vyākhyāprajñapti), the fifth
--     Aṅga of the Śvetāmbara canon; oldest strata pre-Common-Era, redacted
--     at the Valabhī council c. 5th c. CE.  Contains the tri-padī —
--     `uppannei vā, vigamei vā, dhuvei vā` ("it arises, it perishes, it
--     endures") — and applies a sevenfold predication to the jīva.
--
--   Umāsvāti, Tattvārthasūtra, c. 2nd–5th c. CE.
--     1.6   pramāṇanayair adhigamaḥ
--             — the categories are known by pramāṇas AND by nayas.
--     1.33  naigama-saṃgraha-vyavahārarjusūtra-śabda-samabhirūḍhaivaṃbhūtā
--           nayāḥ
--             — the seven standpoints.  (Sarvārthasiddhi/Digambara
--               numbering; the Śvetāmbara Bhāṣya recension splits the same
--               list across 1.34–1.35.)
--     5.29  utpāda-vyaya-dhrauvya-yuktaṃ sat
--             — what exists is endowed with origination, cessation and
--               persistence, all three at once.
--     5.31  arpitānarpitasiddheḥ
--             — apparently contradictory attributes are established
--               through the distinction of the ASSERTED (arpita) and the
--               UNASSERTED (anarpita) aspect.  This sūtra is the standpoint
--               index, stated as such, in the 2nd–5th century.
--
--   Siddhasena Divākara, Sanmatitarka (Prakrit Sammai-suttaṃ), c. 5th c. CE.
--     1.21  a naya taken alone (nirapekṣa) is mithyā; taken with regard to
--           the others (sāpekṣa) it is samyak.  The DURNAYA is exactly the
--           naya that has forgotten it is one.
--     1.28  jāvaiyā vayaṇapahā tāvaiyā ceva hoṃti ṇayavāyā — there are as
--           many nayas as there are ways of speaking.
--
--   Samantabhadra, Āptamīmāṃsā, c. 6th c. CE — the saptabhaṅgī as a fixed
--     seven-membered scheme, each member prefixed `syāt`.
--   Akalaṅka, Laghīyastraya / Aṣṭaśatī, c. 720–780 CE — the argument that
--     the number is EXACTLY seven: three primary (mūla) predicates and
--     their combinations, 3 + 3 + 1.  That argument is `saptabhangi-iso`
--     below, and it is the only reason this file has an Iso in it.
--   Mallisena, Syādvādamañjarī, 1292 CE — sakalādeśa (the total statement,
--     which is pramāṇa) versus vikalādeśa (the partial statement, which is
--     naya).  Avaktavya is what happens when sakalādeśa is demanded of a
--     vikalādeśa-shaped medium.  That is the reading formalised in §5.
--
-- WHY IT IS IN THIS REPOSITORY.
--
-- `machine/Obstruction.hs` opens by observing that the kernel's verdict was
-- a Bool collapsing at least three distinct things, and replaces it with a
-- three-valued type.  The doctrine says the collapse goes further than
-- that, and says by how much.  Two facts from `machine/machine.log`, both
-- at round 0, QUOTED VERBATIM AND NOT POINTED AT — that file is gitignored
-- and is rewritten by every engine run, so no commit fixes its bytes and no
-- position in it names anything.  The quotations below ARE the object:
--
--   as quoted 2026-08-18:
--     KERNEL-REJECT  x = (xmaxx)  ... refl has type x ≡ max x x
--     KERNEL-ACCEPT  x = (xmaxx)  (induction on x, step = cong suc)
--
--   as the log stands 2026-08-20 — the same claim, still both ways:
--     KERNEL-ACCEPT round=0 x = (xmaxx)  (induction on x, step = cong suc, 4 agda calls)
--     KERNEL-REJECT round=0 x = (xmaxx)  (4 agda calls) [naya=induction on x] kernel gate environment fault
--
-- The SAME claim, in the SAME round, denied and affirmed.  Nothing about
-- the claim changed.  What changed is the standpoint: `refl` and
-- `induction on x` are two nayas, and the verdict was never a property of
-- the claim alone.  `syād asti`; `syād nāsti`; and the pair of them is the
-- third bhaṅga, taken KRAMA (successively) — which is why both lines can
-- stand in one log without contradiction.
--
-- §5 is the part that is not decoration.  It proves that the joint content
-- of those two lines is (i) perfectly well-defined, (ii) decidable, (iii)
-- realised, and (iv) NOT the denotation of any single standpointed
-- utterance.  That is avaktavyam: inexpressible, not unknown, not
-- undefined, not "neither".
------------------------------------------------------------------------

module SaptabhangiNaya where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_
                                    ; true≢false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Empty as ⊥ using ()

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  NAYA — the standpoints
--
-- Not the seven nayas of Tattvārthasūtra 1.33.  Those classify ways of
-- REFERRING; these are the three provers the machine actually runs, read
-- off `machine/machine.log`'s own tactic vocabulary.
--
-- AS OF 2026-08-18, at `wc -l machine/machine.log` = 10700 lines
-- (`grep -cF` on each tactic string, whole log, all rounds, on a snapshot
-- taken at that line count):
--
--     837  trace replay          (the machine's own rewriter, exported)
--     637  induction on x, step = refl
--     529  induction on x, step = ih
--     333  induction on x, step = cong suc
--      53  refl                  (`(refl, N agda calls)`)
--
-- READ THE AS-OF LINE, NOT THE NUMBERS — and prefer not to quote them at
-- all.  Three things make every figure above perishable, and all three
-- were observed, not assumed:
--
--   * `machine/machine.log` is gitignored (`.gitignore`:16).  It is absent
--     from a fresh clone, so NOTHING here is reproducible from one.
--   * It is append-only across runs — 61 `DISPATCH` blocks are in it at
--     this size — so `round=N` is not a unique event and every count is a
--     monotone function of a file that keeps growing.
--   * It is LIVE.  While this block was being re-measured on 2026-08-18
--     the log went from 10475 to 10700 lines, and the first four counts
--     moved 820→837, 626→637, 520→529, 327→333 in that interval.  The
--     numbers above were stale before this comment was saved.
--
-- That is the whole reason the earlier text rotted: until 2026-08-18 this
-- block read 663 / 480 / 420 / 255 / 43 in the present tense with no log
-- size attached, and `notes/INDIAN_LANE_CITATION_AUDIT.md` F2 read
-- 778 / 566 / 490 / 305 off the same named file at audit time — a third
-- set of figures for the same "fact".  Substituting today's would only
-- re-arm the trap, so what is recorded is the pair (count, log size), and
-- if you re-measure you must replace both or delete the block.
--
-- The numbers are ILLUSTRATIVE ONLY.  Nothing below depends on them:
-- §1's content is that the three standpoints are pairwise distinct
-- (`rewriter≢refl` and its two siblings, proved below), not that any one
-- of them is popular.  This file's own header quotes two individual log
-- LINES verbatim instead of an aggregate.
--
-- CORRECTED 2026-08-20.  This paragraph used to name the POSITIONS (146 and
-- 174) and argued that an append-only log makes a position durable.  It
-- does not, and the log is not append-only across runs — it is regenerated,
-- and it is gitignored, so nothing can pin it at all.  Both numbers have
-- since rotted: position 146 today is a KERNEL-SKIP of a different claim,
-- and the refl-typed refusal that was quoted is no longer anywhere in the
-- file.  Quoting the line was right; naming where the line sits was not.
--
--     A REPLAY MUST NAME A FIXED OBJECT: a commit hash, a text pattern, an
--     invariant.  Never a position, never a quantity the record is inside,
--     never a HEAD-relative query.
--
-- Registered as `uddhrta` in `machine/mula.pramana` and checked by
-- `machine/MulaPramana_ACitationNamesAFixedObjectOrItIsNotOne.hs`, which
-- does not export the constructors of its designation type, so a citation
-- naming a position cannot be built at any call site.
--
-- Collapsed to the three that disagree with each other in the log.
-- Siddhasena's 1.28 licenses this: as many nayas as ways of speaking.
------------------------------------------------------------------------

data Naya : Type₀ where
  rewriter    : Naya   -- the machine's rewriting/evaluation standpoint
  kernel-refl : Naya   -- Agda's definitional equality, `refl` alone
  kernel-ind  : Naya   -- Agda plus induction on a variable

-- The three are pairwise distinct.  Stated because everything below is
-- vacuous if the standpoints coincide.
nayaCode : Naya → Naya → Type₀
nayaCode rewriter    rewriter    = Unit
nayaCode kernel-refl kernel-refl = Unit
nayaCode kernel-ind  kernel-ind  = Unit
nayaCode _           _           = ⊥.⊥

nayaRefl : (n : Naya) → nayaCode n n
nayaRefl rewriter    = tt
nayaRefl kernel-refl = tt
nayaRefl kernel-ind  = tt

nayaEncode : {m n : Naya} → m ≡ n → nayaCode m n
nayaEncode {m} p = subst (nayaCode m) p (nayaRefl m)

rewriter≢refl : ¬ (rewriter ≡ kernel-refl)
rewriter≢refl p = nayaEncode p

rewriter≢ind : ¬ (rewriter ≡ kernel-ind)
rewriter≢ind p = nayaEncode p

refl≢ind : ¬ (kernel-refl ≡ kernel-ind)
refl≢ind p = nayaEncode p

------------------------------------------------------------------------
-- §2  KRAMA versus YUGAPAT, at the level of types
--
-- The third bhaṅga (`syād asti nāsti ca`) and the fourth (`syād
-- avaktavyam`) are built from the same two ingredients and differ ONLY in
-- the mode of assertion: krama, in succession, versus yugapat, at once.
-- The classical texts insist this is a real difference and not a verbal
-- one.  Here it is, as two types.
--
-- P n is the type of evidence that the claim holds FROM naya n.  `asti` is
-- inhabitation of P at some naya; `nāsti` is refutation of P at some naya.
-- Note that `nāsti` is denial relative to a standpoint (para-dravya,
-- para-kṣetra, para-kāla, para-bhāva — the classical fourfold ground), NOT
-- absolute falsity.  `x · 0 ≡ 0` is nāsti for kernel-refl and true.
------------------------------------------------------------------------

module Modes (P : Naya → Type ℓ) where

  Asti : Type ℓ
  Asti = Σ[ n ∈ Naya ] P n

  Nasti : Type ℓ
  Nasti = Σ[ n ∈ Naya ] (¬ P n)

  -- KRAMA.  Two assertions, each at its own standpoint, uttered in turn.
  Krama : Type ℓ
  Krama = Asti × Nasti

  -- YUGAPAT.  One standpoint asked to affirm and deny at the same time.
  Yugapat : Type ℓ
  Yugapat = Σ[ n ∈ Naya ] (P n × (¬ P n))

  -- The simultaneous demand is unsatisfiable.  This is NOT the definition
  -- of avaktavyam — see §5 — it is the reason avaktavyam is needed.
  yugapat-empty : ¬ Yugapat
  yugapat-empty (_ , p , ¬p) = ¬p p

  -- Simultaneity always implies succession.  The converse is refuted next.
  yugapat→krama : Yugapat → Krama
  yugapat→krama (n , p , ¬p) = (n , p) , (n , ¬p)

-- Given a genuine disagreement between two standpoints, the third bhaṅga
-- is inhabited and the fourth is not, so they are not the same type.
module _ (P : Naya → Type ℓ) (n m : Naya) (p : P n) (¬p : ¬ P m) where

  open Modes P

  krama-witness : Krama
  krama-witness = (n , p) , (m , ¬p)

  krama→yugapat-fails : ¬ (Krama → Yugapat)
  krama→yugapat-fails f = yugapat-empty (f krama-witness)

  -- Stronger, and the reason this file is cubical: the two types are not
  -- even PATH-equal, since a path would transport the witness across.
  krama≢yugapat : ¬ (Krama ≡ Yugapat)
  krama≢yugapat e = yugapat-empty (transport e krama-witness)

------------------------------------------------------------------------
-- §3  THE LANGUAGE OF STANDPOINTED PREDICATION
--
-- Mallisena's vikalādeśa: a single utterance carries ONE aspect asserted
-- (arpita) and leaves the rest unasserted (anarpita) — Tattvārthasūtra
-- 5.31.  So the atoms of the language are exactly (standpoint, polarity).
--
-- A PROFILE is what a claim actually is, prior to any utterance: the
-- verdict of every standpoint at once.  That is the pramāṇa-level object
-- (sakalādeśa).  An utterance is a partial view of it.
------------------------------------------------------------------------

Profile : Type₀
Profile = Naya → Bool

-- Build a profile from its three coordinates.
mk : Bool → Bool → Bool → Profile
mk a _ _ rewriter    = a
mk _ b _ kernel-refl = b
mk _ _ c kernel-ind  = c

data Vacana : Type₀ where
  asti-from  : Naya → Vacana   -- "syāt asti, from n"
  nasti-from : Naya → Vacana   -- "syāt nāsti, from n"

denotes : Vacana → Profile → Bool
denotes (asti-from  n) φ = φ n
denotes (nasti-from n) φ = not (φ n)

------------------------------------------------------------------------
-- §4  PRAMĀṆA IS NOT NAYA  (Tattvārthasūtra 1.6)
--
-- A naya is a projection of the profile.  No projection recovers the
-- profile, so a naya is never a pramāṇa — which is why 1.6 names both and
-- does not reduce either to the other.
------------------------------------------------------------------------

naya-not-pramana : (n : Naya)
  → Σ[ φ ∈ Profile ] Σ[ ψ ∈ Profile ] ((φ n ≡ ψ n) × (¬ (φ ≡ ψ)))
naya-not-pramana rewriter =
  mk true true true , mk true false true , refl
  , λ e → true≢false (cong (λ f → f kernel-refl) e)
naya-not-pramana kernel-refl =
  mk true true true , mk false true true , refl
  , λ e → true≢false (cong (λ f → f rewriter) e)
naya-not-pramana kernel-ind =
  mk true true true , mk false true true , refl
  , λ e → true≢false (cong (λ f → f rewriter) e)

------------------------------------------------------------------------
-- §5  AVAKTAVYAM — the load-bearing section
--
-- THE CLAIM BEING MODELLED is the one the log carries twice — affirmed by
-- the rewriter, denied by kernel-refl; both quotations are in the header.  Its joint content
-- — the thing both lines are jointly about — is this predicate on
-- profiles:
--
--       joint φ  =  φ affirms at rewriter  AND  φ denies at kernel-refl
--
-- Everything avaktavyam is NOT:
--
--   NOT UNDEFINED.  `joint` is a total function into Bool.
--   NOT UNKNOWN.    Both of its values are realised by explicit profiles
--                   (`joint-realised`, `joint-refuted`); nothing is
--                   awaiting information.
--   NOT "NEITHER".  At the profile that realises it, asti holds AND nāsti
--                   holds (`joint-is-both`).  It is the assertion of both,
--                   not the withholding of both.
--   NOT EMPTY.      It is inhabited.
--
-- What it IS: no single Vacana denotes it (`no-single-vacana`), while the
-- ordered PAIR of two Vacanas does (`krama-expresses`).  Inexpressible in
-- one utterance; expressible in two taken in succession.  That is exactly
-- the classical contrast between the fourth bhaṅga and the third, and it
-- is the sense in which `syād avaktavyam` is a POSITIVE predication: it
-- asserts of the object that its joint aspect outruns the one-aspect-at-a-
-- time medium in which alone predication happens.
------------------------------------------------------------------------

joint : Profile → Bool
joint φ = φ rewriter and not (φ kernel-refl)

-- The content is realised, and refutable: it is a genuine two-valued
-- predicate, not a truth-value gap.
joint-realised : Σ[ φ ∈ Profile ] (joint φ ≡ true)
joint-realised = mk true false true , refl

joint-refuted : Σ[ φ ∈ Profile ] (joint φ ≡ false)
joint-refuted = mk true true true , refl

-- Not "neither": where it holds, BOTH asti (at rewriter) and nāsti (at
-- kernel-refl) hold.
joint-is-both : (a b c : Bool) → joint (mk a b c) ≡ true
              → (a ≡ true) × (b ≡ false)
joint-is-both true  false _ _ = refl , refl
joint-is-both true  true  _ h = ⊥.rec (false≢true h)
joint-is-both false _     _ h = ⊥.rec (false≢true h)

-- KRAMA EXPRESSES IT.  Two utterances in succession denote the joint
-- content exactly, by definition — the point is that this holds and the
-- next theorem's does not.
krama-expresses : (φ : Profile)
  → joint φ ≡ (denotes (asti-from rewriter) φ and denotes (nasti-from kernel-refl) φ)
krama-expresses _ = refl

-- YUGAPAT DOES NOT.  For every single utterance there is a profile on
-- which it disagrees with the joint content.  Exhaustive over the six
-- atoms of the language; each case exhibits its separating profile.
no-single-vacana : (v : Vacana)
  → Σ[ φ ∈ Profile ] (¬ (denotes v φ ≡ joint φ))
no-single-vacana (asti-from rewriter) =
  mk true true true , true≢false
no-single-vacana (asti-from kernel-refl) =
  mk true false true , false≢true
no-single-vacana (asti-from kernel-ind) =
  mk true false false , false≢true
no-single-vacana (nasti-from rewriter) =
  mk true false true , false≢true
no-single-vacana (nasti-from kernel-refl) =
  mk false false true , true≢false
no-single-vacana (nasti-from kernel-ind) =
  mk false false false , true≢false

------------------------------------------------------------------------
-- §6  EXACTLY SEVEN
--
-- Akalaṅka's argument (Laghīyastraya, c. 720–780 CE) for why the scheme
-- has seven members and not six or eight: there are three primary (mūla)
-- predicates — asti, nāsti, avaktavya — and the bhaṅgas are their
-- non-empty combinations, 3 + 3 + 1 = 7.
--
-- That is a mathematical claim and this is its proof: an isomorphism
-- between the seven-constructor datatype and the non-empty subsets of a
-- three-element set.  Nothing here is a metaphor; the combinatorics is
-- the Jain combinatorics of the Bhagavatī Sūtra and the Sthānāṅga Sūtra,
-- applied to its own predicate scheme.
------------------------------------------------------------------------

data Bhanga : Type₀ where
  b1-asti                 : Bhanga   -- syād asti
  b2-nasti                : Bhanga   -- syād nāsti
  b3-asti-nasti           : Bhanga   -- syād asti nāsti ca      (krama)
  b4-avaktavya            : Bhanga   -- syād avaktavyam         (yugapat)
  b5-asti-avaktavya       : Bhanga   -- syād asti ca avaktavyaṃ ca
  b6-nasti-avaktavya      : Bhanga   -- syād nāsti ca avaktavyaṃ ca
  b7-asti-nasti-avaktavya : Bhanga   -- syād asti nāsti ca avaktavyaṃ ca

-- A subset of {asti, nāsti, avaktavya}.
Basis : Type₀
Basis = Bool × (Bool × Bool)

NonEmpty : Basis → Type₀
NonEmpty s = ¬ (s ≡ (false , false , false))

NEBasis : Type₀
NEBasis = Σ[ s ∈ Basis ] NonEmpty s

code : Bhanga → Basis
code b1-asti                 = true  , false , false
code b2-nasti                = false , true  , false
code b3-asti-nasti           = true  , true  , false
code b4-avaktavya            = false , false , true
code b5-asti-avaktavya       = true  , false , true
code b6-nasti-avaktavya      = false , true  , true
code b7-asti-nasti-avaktavya = true  , true  , true

code-ne : (b : Bhanga) → NonEmpty (code b)
code-ne b1-asti                 e = true≢false (cong fst e)
code-ne b2-nasti                e = true≢false (cong (λ s → fst (snd s)) e)
code-ne b3-asti-nasti           e = true≢false (cong fst e)
code-ne b4-avaktavya            e = true≢false (cong (λ s → snd (snd s)) e)
code-ne b5-asti-avaktavya       e = true≢false (cong fst e)
code-ne b6-nasti-avaktavya      e = true≢false (cong (λ s → fst (snd s)) e)
code-ne b7-asti-nasti-avaktavya e = true≢false (cong fst e)

code' : Bhanga → NEBasis
code' b = code b , code-ne b

decode : NEBasis → Bhanga
decode ((true  , false , false) , _)  = b1-asti
decode ((false , true  , false) , _)  = b2-nasti
decode ((true  , true  , false) , _)  = b3-asti-nasti
decode ((false , false , true)  , _)  = b4-avaktavya
decode ((true  , false , true)  , _)  = b5-asti-avaktavya
decode ((false , true  , true)  , _)  = b6-nasti-avaktavya
decode ((true  , true  , true)  , _)  = b7-asti-nasti-avaktavya
decode ((false , false , false) , ne) = ⊥.rec (ne refl)

decode-code : (b : Bhanga) → decode (code' b) ≡ b
decode-code b1-asti                 = refl
decode-code b2-nasti                = refl
decode-code b3-asti-nasti           = refl
decode-code b4-avaktavya            = refl
decode-code b5-asti-avaktavya       = refl
decode-code b6-nasti-avaktavya      = refl
decode-code b7-asti-nasti-avaktavya = refl

isPropNonEmpty : (s : Basis) → isProp (NonEmpty s)
isPropNonEmpty _ p q i x = ⊥.isProp⊥ (p x) (q x) i

code-decode : (s : NEBasis) → code' (decode s) ≡ s
code-decode ((true  , false , false) , _)  = Σ≡Prop isPropNonEmpty refl
code-decode ((false , true  , false) , _)  = Σ≡Prop isPropNonEmpty refl
code-decode ((true  , true  , false) , _)  = Σ≡Prop isPropNonEmpty refl
code-decode ((false , false , true)  , _)  = Σ≡Prop isPropNonEmpty refl
code-decode ((true  , false , true)  , _)  = Σ≡Prop isPropNonEmpty refl
code-decode ((false , true  , true)  , _)  = Σ≡Prop isPropNonEmpty refl
code-decode ((true  , true  , true)  , _)  = Σ≡Prop isPropNonEmpty refl
code-decode ((false , false , false) , ne) = ⊥.rec (ne refl)

-- Akalaṅka's count, checked.
saptabhangi-iso : Iso Bhanga NEBasis
Iso.fun      saptabhangi-iso = code'
Iso.inv      saptabhangi-iso = decode
Iso.rightInv saptabhangi-iso = code-decode
Iso.leftInv  saptabhangi-iso = decode-code

saptabhangi-equiv : Bhanga ≃ NEBasis
saptabhangi-equiv = isoToEquiv saptabhangi-iso

------------------------------------------------------------------------
-- §7  DURNAYA
--
-- Siddhasena, Sanmatitarka 1.21.  A naya is samyak when held sāpekṣa —
-- with regard to the others — and mithyā when held nirapekṣa.  The formal
-- marker is `syāt` versus `eva`: a durnaya is a naya that has dropped the
-- index and claims its own verdict is the verdict.
--
-- Formally: the durnaya at n asserts that every standpoint agrees with n.
-- Against the profile the machine actually exhibits, every durnaya is
-- false — including the one this repository most often takes, which is
-- kernel-refl's (`0 agda calls`, cached, and treated as the verdict).
--
-- `machine-profile` is `x = max x x` as the log has it: affirmed by the
-- rewriter, denied by refl, affirmed by induction on x — the two
-- quotations carried in this file's header.
------------------------------------------------------------------------

machine-profile : Profile
machine-profile = mk true false true

Durnaya : Naya → Profile → Type₀
Durnaya n φ = (m : Naya) → φ m ≡ φ n

durnaya-false : (n : Naya) → ¬ (Durnaya n machine-profile)
durnaya-false rewriter    d = false≢true (d kernel-refl)
durnaya-false kernel-refl d = true≢false (d rewriter)
durnaya-false kernel-ind  d = false≢true (d kernel-refl)

-- The corresponding sāpekṣa statement is simply the profile itself, which
-- is consistent: no standpoint is denied, each is indexed.  Anekāntavāda
-- is not the claim that the standpoints agree; it is the refusal to let
-- any one of them speak unindexed.
sapeksa : Σ[ φ ∈ Profile ] ((φ rewriter ≡ true) × (φ kernel-refl ≡ false))
sapeksa = machine-profile , refl , refl

------------------------------------------------------------------------
-- §8  WHAT THIS FILE DOES NOT MODEL — stated, not implied
--
-- 1. The seven NAYAS of Tattvārthasūtra 1.33 (naigama … evaṃbhūta) are not
--    formalised.  §1's `Naya` has three constructors taken from the
--    machine's tactic log; it is a different partition (of provers, not of
--    modes of reference) and no claim is made that they correspond.  The
--    śabda-nayas in particular — which turn on grammatical form and
--    etymology — have no analogue here.
--
-- 2. `syāt` has no independent formal content in this file.  It is carried
--    entirely by the standpoint index on `P`, `denotes`, and `Profile`.
--    Whether the particle does more than index is a question this file
--    does not answer.
--
-- 3. Bhaṅgas 5 and 7 are DEFINABLE (they are in `saptabhangi-iso`) but no
--    instance of either is constructed here, and none was found in the
--    machine's data — see the census in `machine/Obstruction.hs`.  They
--    would need a claim simultaneously affirmed, denied, and inexpressible.
--    Their emptiness in the data is reported there as a measured fact and
--    is not evidence that they are incoherent.
--
-- 4. Avaktavya is modelled as non-denotability by a single atom of a fixed
--    finite language (Mallisena's vikalādeśa reading).  The stronger
--    reading on which avaktavya is a distinct ONTOLOGICAL mode of the
--    object, independent of any language, is not modelled, and this file
--    should not be cited as formalising it.
--
-- 5. Utpāda-vyaya-dhrauvya (TS 5.29) is NOT formalised here.  A type-level
--    statement of it would be a function ℕ → Profile that is non-constant,
--    which is trivially inhabited and would prove nothing.  Its content in
--    this repository is empirical — some claims in `machine/machine.log`
--    appear in BOTH the accept and the reject stream — and it is recorded
--    where empirical facts belong, in the census and in
--    `notes/ANEKANTA_THE_MACHINE_HAS_THREE_STANDPOINTS.md`.
--
--    AS OF 2026-08-18, at `wc -l machine/machine.log` = 10700 lines, that
--    overlap is 40 claims, out of 98 distinct accepted and 432 distinct
--    rejected.  Extraction: the claim text between `round=N ` and the two
--    spaces before `(`, `sort -u` per stream, `comm -12`.  This need not
--    agree with `Obstruction.hs`'s `claimOfAcceptLine`, which is the
--    authority; it is quoted here only to say the overlap is non-empty.
--    Until 2026-08-18 this line said "35 claims" in the present tense with
--    no as-of and no log size; `notes/INDIAN_LANE_CITATION_AUDIT.md` F15
--    measured 40 by the same extraction at a smaller log.  The number is a
--    monotone reading of a gitignored (`.gitignore`:16), append-only, and
--    currently LIVE file — absent from a fresh clone, hence NOT
--    reproducible from one, and growing while it is read.  Re-measure the
--    line count together with the number, or quote neither.  The claim
--    §5 actually rests on is only that the overlap is NON-EMPTY: the same
--    claim is both accepted and rejected somewhere in the stream.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- PROVENANCE, added 2026-08-18 on restoration.
--
-- This is `formal/cubical/Saptabhangi.agda` as of commit 1e2b841b,
-- recovered verbatim except for the module name.  Commit 2c7908ed
-- replaced that file with a different development (आर्पण / द्विमूल /
-- सप्तभङ्गी, क्रम-सह-भेदः, दुर्नयः), which stands untouched.
--
-- Three modules depended on the API the rewrite removed —
-- `WitnessNumberIsTwo`, `AvaktavyaDoesNotFactor`, `TwoProfilesSuffice` —
-- so the removed definitions live here under a non-colliding name and
-- those three are repointed.  Same handling as `PingalaPrastara`, and
-- for the same reason: the norm is not to revert another identity's
-- visible work.
--
-- The two files are complementary rather than rival.  `Saptabhangi` now
-- proves क्रम ≠ सह directly on the seven भङ्ग and identifies the
-- boolean collapse as दुर्नय; this one carries the नय-profile semantics,
-- `denotes`, `joint`, and `no-single-vacana`, which the witness thread
-- prices at two profiles.  Merging them is a deliberate act and should
-- be one.
------------------------------------------------------------------------
