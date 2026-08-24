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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheExchangeLemmaIsTheWholeOfPermTransitivitySoTheConverseContainmentIsNowATheorem
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's attribution for permutation work — Nārāyaṇa Paṇḍita,
-- *Gaṇitakaumudī* (1356) — belongs to the ENUMERATION line, which is
-- another identity's, and this is not that problem: nothing here counts
-- or generates arrangements.  Claiming that source for the transitivity
-- of an inductively defined relation would assert a provenance nobody
-- checked.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/`
-- and `notes/` grepped first.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ITEM, NOW CLOSED.  At 47c200bf I proved `Perm ⊆ ≈`.  At dbbd4be6
-- I reduced the converse to one hypothesis, `PermTransitivity`, and
-- said it *"needs an exchange lemma moving an `Insert` past a `Perm`,
-- which is NOT written here and is NOT assumed to be hard."*  It is
-- written here, and the containment is now a theorem in both
-- directions.
--
-- WHAT IS PROVED
--
--   insertSwap    two insertions commute: `Insert x ds us` and
--                 `Insert y us cs` give a `ws` with `Insert y ds ws`
--                 and `Insert x ws cs`.  **This is the whole content.**
--                 Induction on the SECOND insertion, casing the first;
--                 three clauses, and the middle one is where the two
--                 insertions cross — `here` against `there k` returns
--                 `k` itself with `here`, i.e. the crossing is what
--                 makes the pair swap rather than nest.
--   insertPerm    an insertion moves past a permutation:
--                 `Insert x as bs → Perm bs cs`
--                 → `Σ ds (Perm as ds × Insert x ds cs)`.
--                 Inverting `Perm` is free — `pcons` is its only
--                 non-nil constructor — so this is `insertSwap` plus
--                 bookkeeping.
--   permTransitivity
--                 hence transitivity, by induction on the first
--                 derivation alone.
--   theConverseContainment
--                 `xs ≈ ys → Perm xs ys`, by discharging dbbd4be6's
--                 hypothesis.
--   permutationAndAdjacencyAgree
--                 both directions in one statement, with 47c200bf's
--                 `permIsAnAdjacentChain` as the other half.
--
-- **WHAT THE PROOF SAYS ABOUT THE TWO REPRESENTATIONS.**  dbbd4be6
-- recorded that `≈` has transitivity as a CONSTRUCTOR while `Perm`
-- builds it into the shape of `pcons`, and that the containment was
-- therefore blocked at exactly the constructor they disagree about.
-- That reading survives the proof and is sharpened by it: the cost of
-- `Perm`'s choice is **precisely `insertSwap`** — a commutation of two
-- insertions, three clauses, no arithmetic, no decidable equality, and
-- no assumption whatever on the element type.  Nothing about
-- permutations was at stake; the price of composing was.
--
-- WHAT IS NOT CLAIMED.  **Nothing is amended or retracted** —
-- `PairwiseCommutationGivesEveryOrder`, 47c200bf and dbbd4be6 stand
-- unchanged, and `Insert`, `Perm`, `_≈_`, `permIsAnAdjacentChain` and
-- `permTransitivityGivesTheConverse` are imported, not redefined.
-- **"Same multiset" is still open and untouched**: that direction must
-- LOCATE an element and so needs decidable equality on the element
-- type, which is assumed nowhere here.  This says nothing about
-- `permInvariant`'s GLOBAL commutation hypothesis — (u′), a different
-- flag on a different module, unaddressed, and no rest lifted.  No
-- h-level is assumed of `A`, and neither relation is shown to be a
-- proposition.
--
-- **THIS MODULE IS NOT WARNING-FREE, AND THE WARNING IS THE SAME PRICE
-- AGAIN.**  Agda emits TEN clause warnings (counted by
-- `grep -c "pattern-matching features"`), on `insertSwap`, `insertPerm`
-- and `permTransitivity`:
--
--   "This clause uses pattern-matching features that are not yet
--    supported by Cubical Agda, the function to which it belongs will
--    not compute when applied to transports.
--    Reason: It relies on injectivity of the data constructor _∷_"
--
-- `Perm` and `Insert` are INDEXED BY LISTS, so inverting them unifies
-- `x ∷ xs` patterns, and cubical Agda does not yet support constructor
-- injectivity in that position.  **The propositions below are proved —
-- `--safe`, no postulates, no holes — and the functions simply do not
-- COMPUTE on transports.**  That is a real qualification and it is
-- stated here rather than left to a reader to discover, in the same
-- spirit as the Lean lane's rule about `native_decide`.  It is also the
-- third appearance of one price: `Perm`'s formulation costs
-- `insertSwap` mathematically, and costs transport-computability
-- mechanically.  This corpus's own trap list already says "never match
-- a constructor in an INDEX position"; here the match is unavoidable
-- without redefining someone else's relation, so the cost is paid and
-- disclosed.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheExchangeLemmaIsTheWholeOfPermTransitivitySoTheConverseContainmentIsNowATheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)

open import NaturalMachine.TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using ( Insert ; here ; there ; Perm ; pnil ; pcons ; _≈_
        ; permIsAnAdjacentChain )
open import NaturalMachine.TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree
  using ( PermTransitivity ; permTransitivityGivesTheConverse )

module _ {A : Type} where

  ------------------------------------------------------------------
  -- 1.  Two insertions commute — the whole content
  ------------------------------------------------------------------

  insertSwap :
    {x y : A} {ds us cs : List A}
    → Insert x ds us → Insert y us cs
    → Σ[ ws ∈ List A ] (Insert y ds ws × Insert x ws cs)
  insertSwap {y = y} {ds = ds} j here      = (y ∷ ds) , here , there j
  insertSwap here            (there k)     = _ , k , here
  insertSwap (there j)       (there k)     with insertSwap j k
  ... | ws , iy , ix                       = _ , there iy , there ix

  ------------------------------------------------------------------
  -- 2.  …so an insertion moves past a permutation
  ------------------------------------------------------------------

  insertPerm :
    {x : A} {as bs cs : List A}
    → Insert x as bs → Perm bs cs
    → Σ[ ds ∈ List A ] (Perm as ds × Insert x ds cs)
  insertPerm here      (pcons q ins) = _ , q , ins
  insertPerm (there i) (pcons q ins) with insertPerm i q
  ... | ds , pas , ix with insertSwap ix ins
  ...   | ws , iy , ixc = ws , pcons pas iy , ixc

  ------------------------------------------------------------------
  -- 3.  …and transitivity follows by induction on the first alone
  ------------------------------------------------------------------

  permTransitivity : PermTransitivity {A = A}
  permTransitivity pnil        pnil = pnil
  permTransitivity (pcons p i) q with insertPerm i q
  ... | ds , pys , ix = pcons (permTransitivity p pys) ix

  ------------------------------------------------------------------
  -- 4.  The converse containment, and the two directions together
  ------------------------------------------------------------------

  theConverseContainment : {xs ys : List A} → xs ≈ ys → Perm xs ys
  theConverseContainment = permTransitivityGivesTheConverse permTransitivity

  permutationAndAdjacencyAgree :
    {xs ys : List A} → (Perm xs ys → xs ≈ ys) × (xs ≈ ys → Perm xs ys)
  permutationAndAdjacencyAgree =
    permIsAnAdjacentChain , theConverseContainment
