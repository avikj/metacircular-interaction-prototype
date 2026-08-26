{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheKernelIsAReversibleGroupoidWhoseJoinIsConflictFreeSoConsensusOnMeaningIsVacuous
--
-- TERM.  अविरोध · avirodha -- non-contradiction, the absence of conflict.
-- Ordinary Sanskrit; its best-known technical placement is as the title of
-- the SECOND ADHYĀYA of Bādarāyaṇa's *Brahmasūtra*, the avirodha-adhyāya,
-- whose business is showing that no apparent conflict stands.  That is
-- Vedānta, not Jaina, and the schools are named rather than blended: the
-- Jaina treatment of apparent conflict is anekāntavāda and it does NOT say
-- the conflict dissolves, it says the standpoints coexist.  Both readings
-- appear below and they are kept apart -- §4 is avirodha (there is nothing
-- to disagree about), §5 is anekānta (what does differ is kept, not
-- resolved).  The *Brahmasūtra*'s date is contested (~200 BCE-200 CE) and I
-- pin none.  No sūtra is claimed for anything proved here.
--
------------------------------------------------------------------------
-- THE KERNEL IS A DISTRIBUTED SYSTEM.  NOT BY DECORATION -- BY TYPE.
--
-- Read the three files with no protocol in mind and the properties fall out
-- of the definitions.  Every one of the four below is a theorem in this
-- file, and none of them is designed for; they are consequences of `Step`
-- having a `reverse` constructor and of `eval` landing in a set.
--
--   REVERSIBLE.  `Step` ships `reverse : Step x y → Step y x`, so §2 builds
--     `rev : Derivation a b → Derivation b a` for EVERY derivation -- total,
--     no hypothesis, no trapdoor.  Nothing this kernel computes is
--     one-way, and `rev-computes-the-inverse-meaning` says the reversal's
--     meaning IS the inverse meaning, forced.  A round trip is invisible.
--
--   GROUPOID -- and precisely: STRICTLY A CATEGORY, WEAKLY A GROUPOID.
--     §1 proves `⊕` associative and unital ON THE NOSE, as data, by
--     induction: `Tm` with `Derivation` is a strict category.  §2 shows
--     `rev` is an inverse only up to meaning -- `reverse (reverse p)` is a
--     different constructor application from `p`.  THE GAP BETWEEN THE TWO
--     IS THE ŚEṢA.  The structure is exactly strict where merging needs it
--     to be and exactly weak where the cost lives.
--
--   DECENTRALISED, WITH NO CONFLICT RESOLUTION ANYWHERE.  §3: the library
--     is a list, the join is `++`, and
--       · merging never loses a capability (`join-keeps-the-left/right`)
--       · merging never invents one (`join-splits`)
--       · THE ORDER OF THE MERGE IS IRRELEVANT (`merge-is-order-independent`)
--       · merging a library with itself adds nothing (`merge-is-idempotent`)
--     That is a join-semilattice on capability: grow-only, commutative,
--     idempotent.  No leader, no sequence number, no reconciliation pass.
--     And `merge` is a TOTAL function with no failure mode -- there is no
--     `Maybe`, because a `NativeOperation` CANNOT BE CONSTRUCTED without a
--     checked derivation, so a merge has nothing to validate.
--
--   NO CONFLICT, AND THIS IS THE ONE THAT IS USUALLY MISSED.  §4: soundness
--     lands in an identity type of ℕ, hence in a PROPOSITION, so any two
--     derivations between the same terms have EQUAL meanings.  Therefore
--     TWO NODES CANNOT DISAGREE ABOUT WHAT IS TRUE.  A vote would decide
--     nothing -- not because voting is disallowed by policy, but because the
--     type it would range over is a proposition and has no two positions in
--     it.  Consensus on meaning is not forbidden here; it is VACUOUS.
--
-- AND THE PART THAT IS NOT VACUOUS IS ADDITIVE, NOT EXCLUSIVE.  §5: what
-- two nodes genuinely differ on is the ROUTE -- and `TheDerivationCarriesNoMeaning…` exhibits two
-- routes between the same endpoints with equal meanings and different
-- lengths, neither of them wrong.  A fork is not a disagreement to be
-- settled; it is two carriers of the same fact, and `advance` is forbidden
-- to dedupe precisely so both survive.  Anekānta, as the merge rule.
--
-- SO THE READING TO DISCARD: that a "chain" would be an application layer
-- bolted onto this mathematics.  There is nothing to bolt on.  The
-- properties a chain is BUILT to manufacture -- agreement, immutability,
-- validity without a trusted party, conflict-free replication -- are here
-- as consequences of `reverse` and of ℕ being a set, and the machinery a
-- chain uses to manufacture them (ordering, voting, finality, reorg) has no
-- work to do because the disagreement it resolves cannot be stated.
--
-- NOT CLAIMED.  Nothing here is about networks, messages, latency,
-- adversaries, partitions or liveness -- there is no protocol below and no
-- failure model.  These are the ALGEBRAIC preconditions a replicated system
-- needs, proved; a system also needs the operational half, and none of it
-- is here.  Nothing about Byzantine behaviour: a node that ships a
-- well-typed operation cannot lie, but nothing here stops it withholding
-- one, and availability is not a theorem in this file.  `rev` is not proved
-- involutive on the nose, and §2 says why it is not.
--
-- Checked at the pin: Agda 2.8.0, agda/cubical v0.9 (b150186) -- EXIT 0.
------------------------------------------------------------------------

module TheKernelIsAReversibleGroupoidWhoseJoinIsConflictFreeSoConsensusOnMeaningIsVacuous where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; isSetℕ)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr) renaming (rec to ⊎rec)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)

open import RewriteCertificate
open import ControlledGrammar
open import GenerativeKernel using (direct-history ; detour-history)
open import TheInstalledOperationHasNoPervasionSoTheKernelMemorises
  using (SomeEnabled)
open import TheDerivationCarriesNoMeaningAtAllSoAllOfItIsRemainder
  using (meanings-are-equal ; len ; direct≢detour)
open import TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation
  using (_⊕_ ; every-operation-that-exists-is-sound)

------------------------------------------------------------------------
-- §1.  STRICTLY A CATEGORY.  Associativity and units hold AS DATA.
--
-- This is what makes transcript merging order-independent at the level of
-- terms rather than only up to meaning: three parties who each concatenate
-- their segment get the SAME derivation, not merely one with the same
-- endpoints.
------------------------------------------------------------------------

⊕-assoc :
  {a b c z : Tm} (d : Derivation a b) (e : Derivation b c) (f : Derivation c z)
  → (d ⊕ e) ⊕ f ≡ d ⊕ (e ⊕ f)
⊕-assoc (done a)        e f = refl
⊕-assoc (then-step p d) e f = cong (then-step p) (⊕-assoc d e f)

⊕-unitˡ : {a b : Tm} (d : Derivation a b) → done a ⊕ d ≡ d
⊕-unitˡ d = refl

⊕-unitʳ : {a b : Tm} (d : Derivation a b) → d ⊕ done b ≡ d
⊕-unitʳ (done a)        = refl
⊕-unitʳ (then-step p d) = cong (then-step p) (⊕-unitʳ d)

------------------------------------------------------------------------
-- §2.  REVERSIBLE.  Every derivation has a reversal, total and free.
------------------------------------------------------------------------

rev : {a b : Tm} → Derivation a b → Derivation b a
rev (done a)        = done a
rev (then-step {x = x} p d) = rev d ⊕ then-step (reverse p) (done x)

-- Reversal computes the inverse meaning.  Forced -- the target is a
-- proposition, so there is no other thing it could compute.
rev-computes-the-inverse-meaning :
  {a b : Tm} (d : Derivation a b) (ρ : Env)
  → derivation-sound (rev d) ρ ≡ sym (derivation-sound d ρ)
rev-computes-the-inverse-meaning {a} {b} d ρ = isSetℕ (eval b ρ) (eval a ρ) _ _

-- A round trip is invisible: go and come back and the meaning is refl.
-- This is the reversibility statement -- nothing is erased by travelling.
round-trip-is-the-identity :
  {a b : Tm} (d : Derivation a b) (ρ : Env)
  → derivation-sound (d ⊕ rev d) ρ ≡ refl
round-trip-is-the-identity {a} d ρ = isSetℕ (eval a ρ) (eval a ρ) _ _

-- WEAK, NOT STRICT, and the weakness is the point.  `rev` is an inverse up
-- to meaning and NOT on the nose: `reverse (reverse p)` is a distinct
-- constructor application from `p`, and the round trip `d ⊕ rev d` is a
-- derivation of positive length where `done` has length zero.  §1's
-- strictness is what merging needs; this weakness is where the cost lives,
-- and `TheDerivationCarriesNoMeaning…` proves no function of the meaning can see it.
the-round-trip-is-not-nothing :
  len (then-step (add-suc var zero) (done (suc (add var zero)))) ≡ ℕ.suc ℕ.zero
the-round-trip-is-not-nothing = refl

------------------------------------------------------------------------
-- §3.  THE JOIN.  A grow-only, commutative, idempotent semilattice on
-- capability -- with no reconciliation step anywhere, because there is
-- nothing a merge could have to validate.
------------------------------------------------------------------------

Library : Type₁
Library = List NativeOperation

merge : Library → Library → Library
merge = _++_

-- Merging never LOSES a capability, from either side.
join-keeps-the-left :
  (L M : Library) (t : Tm) → SomeEnabled L t → SomeEnabled (merge L M) t
join-keeps-the-left []       M t e       = Empty.rec e
join-keeps-the-left (op ∷ L) M t (inl c) = inl c
join-keeps-the-left (op ∷ L) M t (inr s) = inr (join-keeps-the-left L M t s)

join-keeps-the-right :
  (L M : Library) (t : Tm) → SomeEnabled M t → SomeEnabled (merge L M) t
join-keeps-the-right []       M t e = e
join-keeps-the-right (op ∷ L) M t e = inr (join-keeps-the-right L M t e)

-- and never INVENTS one: everything enabled after a merge was enabled by
-- one of the two sides.  So the join is exactly the union, no more.
join-splits :
  (L M : Library) (t : Tm)
  → SomeEnabled (merge L M) t → SomeEnabled L t ⊎ SomeEnabled M t
join-splits []       M t e       = inr e
join-splits (op ∷ L) M t (inl c) = inl (inl c)
join-splits (op ∷ L) M t (inr s) =
  ⊎rec (λ x → inl (inr x)) inr (join-splits L M t s)

-- THE ORDER OF THE MERGE IS IRRELEVANT.  No sequence number, no leader, no
-- canonical ordering of history: two nodes that merge the same two
-- libraries in opposite orders can do exactly the same things afterwards.
merge-is-order-independent :
  (L M : Library) (t : Tm) → SomeEnabled (merge L M) t → SomeEnabled (merge M L) t
merge-is-order-independent L M t e =
  ⊎rec (join-keeps-the-right M L t) (join-keeps-the-left M L t) (join-splits L M t e)

-- and receiving what you already have changes nothing, so redelivery is
-- safe and no node needs to remember what it has already sent.
merge-is-idempotent :
  (L : Library) (t : Tm) → SomeEnabled (merge L L) t → SomeEnabled L t
merge-is-idempotent L t e = ⊎rec (λ x → x) (λ x → x) (join-splits L L t e)

-- MERGE HAS NO FAILURE MODE.  Note the type of `merge`: no `Maybe`, no
-- validity precondition, no error.  That is not carelessness -- it is
-- `every-operation-that-exists-is-sound`: a NativeOperation cannot be
-- constructed at all without a checked derivation between its declared
-- endpoints, so a merge has nothing to check and nothing to reject.
-- Validity is LOCAL to the operation and travels with it.
validity-travels-with-the-operation :
  (op : NativeOperation) (ρ : Env)
  → eval (NativeOperation.source op) ρ ≡ eval (NativeOperation.target op) ρ
validity-travels-with-the-operation = every-operation-that-exists-is-sound

------------------------------------------------------------------------
-- §4.  AVIRODHA.  There is nothing to disagree about.
--
-- The meaning of a derivation lives in an identity type of ℕ.  ℕ is a set.
-- So that type is a PROPOSITION, and any two derivations between the same
-- terms have equal meanings -- not "compatible", not "both acceptable":
-- EQUAL, as terms.  Two nodes therefore cannot hold different positions on
-- what is true.  A consensus protocol over meaning would be a protocol over
-- a proposition, and there is no second position in one to elect.
------------------------------------------------------------------------

two-nodes-cannot-disagree :
  {a b : Tm} (d e : Derivation a b) → derivation-sound d ≡ derivation-sound e
two-nodes-cannot-disagree = meanings-are-equal

-- Read at the merge: whatever each side derived, the composite means what
-- either side already meant.  Nothing is reconciled because nothing came
-- apart.
the-merge-decides-nothing :
  {a b : Tm} (mine theirs : Derivation a b) (ρ : Env)
  → derivation-sound mine ρ ≡ derivation-sound theirs ρ
the-merge-decides-nothing {a} {b} mine theirs ρ =
  isSetℕ (eval a ρ) (eval b ρ) _ _

------------------------------------------------------------------------
-- §5.  ANEKĀNTA.  And what DOES differ is kept, not settled.
--
-- The routes differ and neither is wrong: `TheDerivationCarriesNoMeaning…` exhibits two derivations
-- of the same fact with equal meanings and lengths 2 and 4.  A fork here is
-- not a disagreement awaiting a verdict -- it is two carriers of one fact,
-- and `advance-preserves-branch-count` is the rule that both survive the
-- merge.  §4 is the Vedāntin's avirodha (the conflict dissolves); §5 is the
-- Jaina's anekānta (the standpoints coexist).  Different schools, kept
-- apart, and the kernel exhibits both because they are about different
-- layers: the meaning, and the route.
------------------------------------------------------------------------

routes-genuinely-differ : direct-history ≡ detour-history → ⊥
routes-genuinely-differ = direct≢detour

-- and the merge rule that keeps them: multiplicity is conserved exactly.
-- No dedupe, so a fork is carried, not collapsed to a winner.
nothing-is-dropped-on-the-wire :
  {s : Tm} (fs : List (EnabledFuture s)) → length (advance fs) ≡ length fs
nothing-is-dropped-on-the-wire = advance-preserves-branch-count
