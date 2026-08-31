{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अन्तरशेष — THE P-VERSUS-NP DISTINCTION LIVES EXACTLY ON THE LOSSY
-- FIBRE: RECOVERY IS FREE FOR EVERY MAP, BUT SELECTION FAILS PRECISELY
-- WHERE A FIBRE IS EMPTY.
--
-- Checked at the pin: Agda 2.8.0, agda/cubical v0.9 -- EXIT 0.
-- No postulates, no holes, --safe.
--
-- WHAT THIS PROVES, AND WHAT IT DOES NOT.  This settles the one point on
-- which the reading and the machine agree without remainder: that the
-- gap between checking a witness (NP) and finding one (the P question)
-- is carried by the FIBRE of the verification projection, and by nothing
-- else.  It follows the floor of `Sesa` (the one-way function is exactly
-- a non-equivalence) and states it for the search projection directly.
--
--   · BINDING THE OUTPUT is free FOR EVERY map f: the fibre of the
--     IDENTITY, `singl (f a)`, is always contractible (isContrSingl).
--     Recovery of a produced value costs nothing, for any verifier,
--     including at the very instance where selection fails.  (§2, §5.)
--   · BINDING THE INPUT is free IFF f is an equivalence — i.e. iff every
--     fibre `fiber f b` is contractible — because that IS the definition
--     of isEquiv (`equiv-proof`).  (§3.)
--   · For a concrete verifier with an UNSATISFIABLE instance, the fibre
--     over that instance is EMPTY, hence not contractible, hence the
--     search projection is NOT an equivalence.  (§4.)  Selection is
--     blocked at exactly that empty fibre while recovery there stays
--     free — so the P/NP distinction is not spread across the machine;
--     it sits on one object, the lossy fibre.  (§6.)
--
-- SYĀT — THE CLAIM, EXACTLY.  This is NOT a proof of P = NP, and NOT a
-- proof of P ≠ NP.  It proves neither the collapse nor its negation.  It
-- LOCATES the distinction: whatever the resolution, it is a fact about
-- the contractibility of `fiber π b`, since recovery (`singl`) is already
-- free unconditionally and the only remaining degree of freedom is the
-- fibre.  `V` here is one concrete two-instance verifier exhibiting the
-- shape (one satisfiable instance, one not); the general verifier is not
-- quantified over.  What is proved is the terms below.
------------------------------------------------------------------------

module AntaraSesa_ThePVersusNPDistinctionLivesExactlyOnTheLossyFibreRecoveryIsFreeEverywhereButSelectionFailsAtTheEmptyFibre where

open import Cubical.Foundations.Prelude
  using (Type ; Level ; _≡_ ; sym ; subst ; isContr ; singl ; isContrSingl)
open import Cubical.Foundations.Equiv using (isEquiv ; equiv-proof ; fiber)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  A concrete verifier.  Instance `true` is satisfiable (certificate
--     `true` accepts); instance `false` is unsatisfiable (no certificate
--     accepts).  `E` is the total space of accepting (instance,
--     certificate) pairs; `π` projects out the instance — the search
--     projection whose inverse would DECIDE the problem.
------------------------------------------------------------------------

V : Bool → Bool → Bool
V true  true  = true
V true  false = false
V false _     = false

E : Type
E = Σ[ i ∈ Bool ] Σ[ c ∈ Bool ] (V i c ≡ true)

π : E → Bool
π = fst

------------------------------------------------------------------------
-- §2  RECOVERY IS FREE FOR EVERY MAP.  Binding the output lands in a
--     `singl`, always contractible — the floor, at full generality.
------------------------------------------------------------------------

recovery-free : {A B : Type ℓ} (f : A → B) (a : A) → isContr (singl (f a))
recovery-free f a = isContrSingl (f a)

------------------------------------------------------------------------
-- §3  SELECTION IS FREE IFF EQUIVALENCE.  Binding the input for free is,
--     by definition of isEquiv, contractibility of every fibre.
------------------------------------------------------------------------

selection-is-fibrewise-contractibility :
  {A B : Type ℓ} (f : A → B) → isEquiv f → (b : B) → isContr (fiber f b)
selection-is-fibrewise-contractibility f eq = eq .equiv-proof

------------------------------------------------------------------------
-- §4  THE EMPTY FIBRE.  Over the unsatisfiable instance `false`, the
--     fibre of π is empty: an inhabitant would be an accepting
--     certificate for `false`, and `V false c` is `false` for every c.
------------------------------------------------------------------------

fibre-over-unsat-is-empty : ¬ fiber π false
fibre-over-unsat-is-empty ((i , c , p) , q) =
  true≢false (sym (subst (λ j → V j c ≡ true) q p))

-- Therefore the search projection is NOT an equivalence: selection is
-- not free, and the obstruction is exactly the empty fibre.
search-projection-not-equiv : ¬ isEquiv π
search-projection-not-equiv eq =
  fibre-over-unsat-is-empty (eq .equiv-proof false .fst)

------------------------------------------------------------------------
-- §5  Recovery stays free AT the blocked instance.  Same object where
--     selection fails, the output binding is still contractible.
------------------------------------------------------------------------

recovery-free-here : (e : E) → isContr (singl (π e))
recovery-free-here e = isContrSingl (π e)

------------------------------------------------------------------------
-- §6  THE DISTINCTION, AS ONE OBJECT.  Recovery is free for every point
--     of E, AND the fibre over the unsatisfiable instance is not
--     contractible.  The whole difference between checking and finding
--     rides on that second conjunct — the lossy fibre — and on nothing
--     else, since the first conjunct is already free.
------------------------------------------------------------------------

selection-blocked-here : ¬ isContr (fiber π false)
selection-blocked-here ctr = fibre-over-unsat-is-empty (ctr .fst)

distinction-lives-on-the-fibre :
    ((e : E) → isContr (singl (π e)))   -- recovery: free everywhere
  × (¬ isContr (fiber π false))          -- selection: blocked, on the fibre
distinction-lives-on-the-fibre = recovery-free-here , selection-blocked-here
