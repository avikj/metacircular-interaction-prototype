{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- IdempotenceForbidsDescent
--
-- Why the walk's capacity is e^Ïˆ(k) and could never have been anything
-- else.  Two lines of monoid theory, and they close a question this
-- corpus has been treating as a tuning problem.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE OBSERVATION
--
-- The cakravla (Jayadeva ~950, Bhskara II 1150) does not merely
-- compose.  Each cycle composes the current triple with a trivial one by
-- bhvan and then **divides by k** â” the descent that keeps the numbers
-- bounded and is the entire reason the cyclic method terminates in a
-- handful of steps where brute search does not terminate at all.
--
-- The walk composes too: its step joins the current state with a new
-- prime power, which under `SumProductTorus.val` is pointwise max on
-- derivations.  But the walk never divides.  Its state is monotone in
-- the divisor lattice from the first step to the last.
--
-- That has been described here as a feature of this particular machine.
-- It is not.  It is forced, and the proof is `idem-invertible-is-unit`:
--
--     in any monoid, an IDEMPOTENT element with an inverse is the unit.
--
--         x = xÂe = xÂ(xÂy) = (xÂx)Ây = xÂy = e.
--
-- A join is idempotent at every element.  So in a join monoid **every**
-- invertible element is the unit.  Stated exactly, and this is the whole
-- claim: **no step of a join law can be undone by another step of that
-- law**, at any state, ever.  Not "the walk lacks a descent step" â” the
-- walk cannot have one built from its own state law, and by `Apavada` a
-- rule that agrees with it everywhere is a reformulation that changes
-- only price.  Getting descent means changing the law.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CONTRAST, IN THE SAME BREATH
--
-- `PythagoreanTransition` gives the other kind of state law: bhvan at
-- D = âˆ’1, which is a group on the norm-one part.  Over â the element
-- i = (0,1) is invertible and is NOT the unit â” checked by `refl` below
-- â” so that monoid is not idempotent, and a composition step CAN be
-- undone by another composition step (with the conjugate: antara-bhvan).
--
-- So the two machines differ by exactly one algebraic property, and it
-- is the property that decides whether state can ever come back down:
--
--     join monoid   idempotent  â’ only the unit inverts â’ irreversible
--     bhvan       i â‰  one      â’ non-unit inverses     â’ reversible
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS DOES AND DOES NOT SETTLE.
--
-- It settles that the walkâ™s irreversibility is structural, not a missing
-- optimisation, and that no reformulation of the walk in its own chart
-- (`Apavada`: agreement, hence only price changes) can fix it.  Fixing it
-- requires a different state law, not a better rule.
--
-- It does NOT give the growth rate.  cap(k) = e^Ïˆ(k) is proved elsewhere
-- in this lane; nothing here bears on Ïˆ, and irreversibility alone does
-- not imply any particular rate.  Nor is the cakravlaâ™s descent shown to
-- BE this inversion: the cyclic method divides by k, which is inversion in
-- the scaling action (`Bhavana.normScale`), a different structure from the
-- one inverted here.  That the two are the same move is a conjecture this
-- module does not prove.  What is proved is the reversibility dichotomy.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module IdempotenceForbidsDescent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc)
open import Cubical.Data.Int.Properties using (injPos)
open import Cubical.Relation.Nullary using (Â¬_)

open import SumProductTorus
  using (Exp ; zeroE ; _âŠ”_ ; _âŠ”â„•_ ; val ; primes4)

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- 1.  The theorem, over any monoid.  Unbundled on purpose: the two
--     instances below live in different libraries and neither is
--     packaged as a `Monoid` in this lane.
------------------------------------------------------------------------

module Mon {M : Type â„“} (_â‹†_ : M â†’ M â†’ M) (e : M)
           (idr    : (x : M) â†’ x â‹† e â‰¡ x)
           (assoc  : (x y z : M) â†’ (x â‹† y) â‹† z â‰¡ x â‹† (y â‹† z))
           where

  Invertible : M â†’ Type â„“
  Invertible x = Î£[ y âˆˆ M ] (x â‹† y â‰¡ e)

  Idempotent : M â†’ Type â„“
  Idempotent x = x â‹† x â‰¡ x

  -- x = xÂe = xÂ(xÂy) = (xÂx)Ây = xÂy = e
  idem-invertible-is-unit :
    (x : M) â†’ Idempotent x â†’ Invertible x â†’ x â‰¡ e
  idem-invertible-is-unit x idem (y , inv) =
      sym (idr x)
    âˆ™ cong (x â‹†_) (sym inv)
    âˆ™ sym (assoc x x y)
    âˆ™ cong (_â‹† y) idem
    âˆ™ inv

  -- contrapositive, which is the form the machines are read in:
  -- a non-unit that inverts witnesses that the law is not a join.
  invertible-non-unit-breaks-idempotence :
    (x : M) â†’ Invertible x â†’ Â¬ (x â‰¡ e) â†’ Â¬ (Idempotent x)
  invertible-non-unit-breaks-idempotence x invx xâ‰¢e idem =
    xâ‰¢e (idem-invertible-is-unit x idem invx)

------------------------------------------------------------------------
-- 2.  The walk's state law is a join, so every element is idempotent
------------------------------------------------------------------------

âŠ”â„•-idem : (x : â„•) â†’ x âŠ”â„• x â‰¡ x
âŠ”â„•-idem zero    = refl
âŠ”â„•-idem (suc x) = cong suc (âŠ”â„•-idem x)

âŠ”â„•-idr : (x : â„•) â†’ x âŠ”â„• 0 â‰¡ x
âŠ”â„•-idr zero    = refl
âŠ”â„•-idr (suc x) = refl

âŠ”â„•-assoc : (x y z : â„•) â†’ (x âŠ”â„• y) âŠ”â„• z â‰¡ x âŠ”â„• (y âŠ”â„• z)
âŠ”â„•-assoc zero    y       z       = refl
âŠ”â„•-assoc (suc x) zero    z       = refl
âŠ”â„•-assoc (suc x) (suc y) zero    = refl
âŠ”â„•-assoc (suc x) (suc y) (suc z) = cong suc (âŠ”â„•-assoc x y z)

âŠ”-idem : (bs : List â„•) (u : Exp bs) â†’ (u âŠ” u) â‰¡ u
âŠ”-idem []       _        = refl
âŠ”-idem (b âˆ· bs) (x , xs) i = âŠ”â„•-idem x i , âŠ”-idem bs xs i

âŠ”-idr : (bs : List â„•) (u : Exp bs) â†’ (u âŠ” zeroE bs) â‰¡ u
âŠ”-idr []       _        = refl
âŠ”-idr (b âˆ· bs) (x , xs) i = âŠ”â„•-idr x i , âŠ”-idr bs xs i

âŠ”-assoc : (bs : List â„•) (u v w : Exp bs) â†’ ((u âŠ” v) âŠ” w) â‰¡ (u âŠ” (v âŠ” w))
âŠ”-assoc []       _ _ _ = refl
âŠ”-assoc (b âˆ· bs) (x , xs) (y , ys) (z , zs) i =
  âŠ”â„•-assoc x y z i , âŠ”-assoc bs xs ys zs i

module WalkStates (bs : List â„•) =
  Mon {M = Exp bs} _âŠ”_ (zeroE bs) (âŠ”-idr bs) (âŠ”-assoc bs)

-- THE WALK IS IRREVERSIBLE.  Every state is idempotent, so the only state
-- with an inverse is the trivial one â” the derivation of 1.  The only
-- state a step of the walkâ™s own law can return to is capacity 1.
walk-only-unit-inverts :
  (bs : List â„•) (u : Exp bs) â†’ WalkStates.Invertible bs u â†’ u â‰¡ zeroE bs
walk-only-unit-inverts bs u inv =
  WalkStates.idem-invertible-is-unit bs u (âŠ”-idem bs u) inv

-- named in the multiplicative chart, that trivial state is the number 1:
-- the walk can undo itself only all the way back to the empty state.
walk-return-target-is-one : val primes4 (zeroE primes4) â‰¡ 1
walk-return-target-is-one = refl

------------------------------------------------------------------------
-- 3.  Bhvan is not a join: i = (0,1) inverts and is not the unit
------------------------------------------------------------------------

open import PythagoreanTransition using (module Circle)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)

open Circle â„¤CommRing using (Pair ; _âŠ—_ ; conj ; one ; N)

i : Pair
i = pos 0 , pos 1

i-norm-one : N i â‰¡ pos 1
i-norm-one = refl

i-inverts : i âŠ— conj i â‰¡ one
i-inverts = refl

i-is-not-one : Â¬ (i â‰¡ one)
i-is-not-one p = znots (injPos (cong snd (sym p)))

module Rot = Mon {M = Pair} _âŠ—_ one
                 (Circle.âŠ—-idÊ³ â„¤CommRing) (Circle.âŠ—-assoc â„¤CommRing)

-- so this monoid is NOT idempotent, and a step in it can be undone by
-- another step of the same law â” provably unlike the walkâ™s.
bhavana-is-not-a-join : Â¬ (Rot.Idempotent i)
bhavana-is-not-a-join =
  Rot.invertible-non-unit-breaks-idempotence i (conj i , i-inverts) i-is-not-one

------------------------------------------------------------------------
-- 4.  The sentence this module exists to make exact.
--
-- The walkâ™s state never comes back down because its law is a join,
-- joins are idempotent, and idempotence forbids every inverse but the
-- trivial one.  No rule change touches this: by `Apavada`, a rule that
-- agrees with the walk everywhere is a REFORMULATION and changes only
-- price.  Reversibility requires changing the state law, and the oldest
-- state law in this repository that has it is Brahmaguptaâ™s.
------------------------------------------------------------------------
