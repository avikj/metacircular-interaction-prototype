{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡‡‡ ‚î ‡‡‡‡‡‡Ø ‡‡®‡‡‡‡ ‡‡‡∞‡‡‡ ‡‡µ ‡
--
-- (the remainder's fibre is nothing but the progression.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS EXISTS: A CLASS, NOT AN INSTANCE.
--
-- `machine/Lopa_‚¶hs` grades 1062 one-way edges in this corpus, and their
-- mass is concentrated: **237 have source ‚ï**, and their maps are
-- overwhelmingly decision procedures and arithmetic level sets ‚î
-- `eqb`, `chkPos`, `gtAll`, `res4`, `rangeB`, `hull`, `kron`.
--
-- The finite-source edges are enumerable, and a case-table emitter
-- sweeps them.  **An ‚ï-source edge is not enumerable and no table will
-- ever reach it.**  It has to be priced by an identification.
--
-- And a residue map has one, exactly: **the fibre of `_mod k` over `r`
-- is a copy of ‚ï**, and the identification is the arithmetic
-- progression `q ‚¶ r + k¬q`.  Not a bound, not a count ‚î a bijection
-- with a standard type, which is what ‡‡‡‡‡∞ ‡Æ demands of a receipt.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED.
--
-- ¬ß‡ß  `‡‡‡∞‡‡‡ k r : ‚ï ‚í ‚ï`, the progression, and that it lands in the
--     fibre: `(r + k¬q) mod k ‚â° r` whenever `r < k`.
-- ¬ß‡®  **`‡‡µ‡‡‡-‡‡®‡‡‡‡ : fiber (_mod (suc k)) r ‚â ‚ï`** for `r < suc k`.
--     Both round trips.  The receipt for every residue edge in the
--     corpus, in one term.
-- ¬ß‡©  the degenerate reading: at `r ‚â k` the fibre is EMPTY (‡∞‡ø‡ï‡‡‡Æ‡),
--     because `mod<` bounds every value.  So the three ‡‡ô‡‡ñ‡‡Ø‡æ are all
--     present in one family ‚î ‡∞‡ø‡ï‡‡‡Æ‡ above the modulus, and ‡‡‡ (a full
--     copy of ‚ï) below it, with ‡‡ï‡Æ‡ occurring nowhere.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM.  ‡‡‡ / ‡‡µ‡‡‡ ‚î remainder.  ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡ ‡ó‡‡ø‡‡‡æ‡¶‡ ‡©‡®‚ì‡©‡©
-- (499 CE), the kuaka: **‡‡‡‡ ‡∞‡ï‡‡** ‚î *keep the remainder* ‚î and
-- recurse on it.  The instruction that the discarded part is the object.
-- LIMIT: ryabhaa states a procedure for solving linear congruences and
-- proves nothing below; no source states a fibre, a type, or an
-- equivalence.  What is claimed is that the set his procedure's
-- remainder ranges over IS the fibre of the residue map, which is a fact
-- about `Cubical.Data.Nat.Mod`'s definitions.  The European name for the
-- procedure is the "extended Euclidean algorithm", a restatement, named
-- after the source and as one.
------------------------------------------------------------------------

module Avaresidue_TheResidueMapsFibreIsACopyOfTheNaturalsAndTheProgressionIsTheReceipt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Empty using (‚ä•)

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡∞‡‡‡ ‚î the progression, and that it lands in the fibre.
------------------------------------------------------------------------

‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä : (k r : ‚Ñï) ‚Üí ‚Ñï ‚Üí ‚Ñï
‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä k r q = r + k ¬∑ q

module _ (k r : ‚Ñï) (r<k : r < suc k) where

  private
    K : ‚Ñï
    K = suc k

  -- (r + K¬q) mod K ‚â° r.  The multiple dies by zero-charac-gen; what is
  -- left is r, which is already reduced because r < K.
  ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§Ö‡§µ‡§∂‡•á‡§∑‡§É : (q : ‚Ñï) ‚Üí (r + K ¬∑ q) mod K ‚â° r
  ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§Ö‡§µ‡§∂‡•á‡§∑‡§É q =
      cong (Œª z ‚Üí (r + z) mod K) (¬∑-comm K q)
    ‚àô mod-rCancel K r (q ¬∑ K)
    ‚àô cong (Œª z ‚Üí (r + z) mod K) (zero-charac-gen K q)
    ‚àô cong (_mod K) (+-zero r)
    ‚àô modIndBase k r r<k

------------------------------------------------------------------------
-- ‡® ¬ ‡‡µ‡‡‡-‡‡®‡‡‡‡ ‚î the receipt.
--
-- `fiber (_mod K) r ‚â ‚ï`.  Forward: take the quotient.  Backward: run
-- the progression.  The two round trips are `‚â°remainder+quotient` and
-- cancellation of `K ¬_`, and the fibre's proof component is carried for
-- free because ‚ï is a set.
------------------------------------------------------------------------

  ‡§Ö‡§µ‡§∂‡•á‡§∑-‡§§‡§®‡•ç‡§§‡•Å‡§É : fiber (_mod K) r ‚âÉ ‚Ñï
  ‡§Ö‡§µ‡§∂‡•á‡§∑-‡§§‡§®‡•ç‡§§‡•Å‡§É = isoToEquiv (iso ‡§≠‡§æ‡§ó‡§É ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§§‡§®‡•ç‡§§‡•å ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç)
    where
    ‡§≠‡§æ‡§ó‡§É : fiber (_mod K) r ‚Üí ‚Ñï
    ‡§≠‡§æ‡§ó‡§É (m , _) = quotient m / K

    ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§§‡§®‡•ç‡§§‡•å : ‚Ñï ‚Üí fiber (_mod K) r
    ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§§‡§®‡•ç‡§§‡•å q = (r + K ¬∑ q) , ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§Ö‡§µ‡§∂‡•á‡§∑‡§É q

    -- m ‚â° r + K¬(m/K), because the remainder IS r by the fibre's own witness
    ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É : (m : ‚Ñï) ‚Üí m mod K ‚â° r ‚Üí r + K ¬∑ (quotient m / K) ‚â° m
    ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É m p = cong (_+ K ¬∑ (quotient m / K)) (sym p) ‚àô ‚â°remainder+quotient K m

    ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç : (q : ‚Ñï) ‚Üí ‡§≠‡§æ‡§ó‡§É (‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§§‡§®‡•ç‡§§‡•å q) ‚â° q
    ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç q =
      inj-sm¬∑ {k} {quotient (r + K ¬∑ q) / K} {q}
        (inj-m+ {r} (‡§µ‡§ø‡§≠‡§æ‡§ó‡§É (r + K ¬∑ q) (‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§Ö‡§µ‡§∂‡•á‡§∑‡§É q)))

    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç : (x : fiber (_mod K) r) ‚Üí ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§§‡§®‡•ç‡§§‡•å (‡§≠‡§æ‡§ó‡§É x) ‚â° x
    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç (m , p) =
      Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) (‡§µ‡§ø‡§≠‡§æ‡§ó‡§É m p)

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡‡ ‚î the three counts in one family.
--
-- Above the modulus the fibre is EMPTY: `mod<` bounds every value by K,
-- so nothing maps to an r ‚â K.  Below it the fibre is a full copy of ‚ï.
-- **‡‡ï‡Æ‡ occurs nowhere in this family** ‚î a residue map is never
-- injective at any residue, and never partially so.  ‡∞‡ø‡ï‡‡‡Æ‡ and ‡‡‡,
-- with nothing between.
------------------------------------------------------------------------

  ‡§∞‡§ø‡§ï‡•ç‡§§-‡§Ö‡§µ‡§∂‡•á‡§∑‡§É : (s : ‚Ñï) ‚Üí suc k ‚â§ s ‚Üí fiber (_mod (suc k)) s ‚Üí ‚ä•
  ‡§∞‡§ø‡§ï‡•ç‡§§-‡§Ö‡§µ‡§∂‡•á‡§∑‡§É s k‚â§s (m , p) =
    ¬¨m<m (‚â§<-trans k‚â§s (subst (_< suc k) p (mod< k m)))
