{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पत्र-लेख — the working tree, constructed.
--
-- RESOLUTION TOWARD ABSTRACT 14.  That abstract proved reordering from
-- pairwise commutation and located conflict off the image of the
-- observation, and scoped away the version-control vocabulary: no
-- working tree, no file, no blame.  This file constructs them:
--
--   §1  A FILE is a line-indexed content function ℕ → ℕ; a PATCH is a
--       single-line write.  Both total, no partiality discipline.
--
--   §2  DISTINCT-LINE PATCHES COMMUTE — the hypothesis abstract 14's
--       reordering theorem consumes, discharged on the model rather
--       than assumed: writes to different lines produce equal files in
--       either order, by decision analysis on the line comparison.
--
--   §3  BLAME BEYOND THE LAST WRITER IS NOT A FUNCTION OF THE WORKING
--       TREE.  Two histories that both end by writing line 0 — one
--       having first written 1 there, the other 2 — are distinct as
--       histories and produce IDENTICAL files, so every function of
--       the final tree agrees on them: no blame computation reading
--       the tree recovers the overwritten author.  Blame is carried by
--       the history or it is nowhere — abstract 06's law, landed on
--       the working tree, with the last-writer boundary exact: the
--       final write is in the tree; everything before it is not.
--
-- SYĀT — THE CLAIM, EXACTLY.  Lines hold single naturals; no diff
-- algorithm and no merge UI appear.  Those are constructions, not
-- readings; the file, the patch, the commutation and the blame
-- theorem are no longer among the absences.
------------------------------------------------------------------------

module PatraLekha_DistinctLinePatchesCommuteAndBlameBeyondTheLastWriterIsNotAFunctionOfTheWorkingTree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ ; injSuc ; snotz)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty using (⊥ ; rec)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)

------------------------------------------------------------------------
-- १ · Files and patches.
------------------------------------------------------------------------

Patra : Type₀
Patra = ℕ → ℕ

vikalpa : {A : Type₀} → Dec A → ℕ → ℕ → ℕ
vikalpa (yes _) v w = v
vikalpa (no _)  v w = w

-- Write value v at line i.
likh : ℕ → ℕ → Patra → Patra
likh i v f j = vikalpa (discreteℕ i j) v (f j)

------------------------------------------------------------------------
-- २ · Distinct-line writes commute.
------------------------------------------------------------------------

likh-vinimaya : (i j : ℕ) → (i ≡ j → ⊥) → (v w : ℕ) (f : Patra)
              → likh i v (likh j w f) ≡ likh j w (likh i v f)
likh-vinimaya i j i≢j v w f = funExt pt
  where
    pt : (l : ℕ) → likh i v (likh j w f) l ≡ likh j w (likh i v f) l
    pt l with discreteℕ i l | discreteℕ j l
    ... | yes p | yes q = rec (i≢j (p ∙ sym q))
    ... | yes p | no ¬q = refl
    ... | no ¬p | yes q = refl
    ... | no ¬p | no ¬q = refl

------------------------------------------------------------------------
-- ३ · Blame.  Histories as write lists, applied in order.
------------------------------------------------------------------------

Itihāsa : Type₀
Itihāsa = List (ℕ × ℕ)

kriyā : Itihāsa → Patra → Patra
kriyā []              f = f
kriyā ((i , v) ∷ h) f = kriyā h (likh i v f)

-- The two histories: first write 1 (resp. 2) at line 0, then w.
itihāsa₁ itihāsa₂ : ℕ → Itihāsa
itihāsa₁ w = (zero , 1) ∷ (zero , w) ∷ []
itihāsa₂ w = (zero , 2) ∷ (zero , w) ∷ []

-- They are distinct as histories…
ādya : Itihāsa → ℕ
ādya []            = zero
ādya ((_ , v) ∷ _) = v

bhinna-itihāsa : (w : ℕ) → itihāsa₁ w ≡ itihāsa₂ w → ⊥
bhinna-itihāsa w p = snotz (sym (injSuc (cong ādya p)))

-- …and produce identical working trees: the last writer shadows.
samāna-patra : (w : ℕ) (f : Patra) → kriyā (itihāsa₁ w) f ≡ kriyā (itihāsa₂ w) f
samāna-patra w f = funExt pt
  where
    pt : (l : ℕ) → kriyā (itihāsa₁ w) f l ≡ kriyā (itihāsa₂ w) f l
    pt l with discreteℕ zero l
    ... | yes _ = refl
    ... | no _  = refl

-- Hence no reading of the tree — into any type — separates them:
-- blame beyond the last writer is not a function of the working tree.
andha-doṣārpaṇa : {A : Type₀} (blame : Patra → A) (w : ℕ) (f : Patra)
                → blame (kriyā (itihāsa₁ w) f) ≡ blame (kriyā (itihāsa₂ w) f)
andha-doṣārpaṇa blame w f = cong blame (samāna-patra w f)
