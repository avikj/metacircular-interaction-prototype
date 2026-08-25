{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- `no-own-being := univalence` is examined there and — unlike an earlier
-- over-refutation of mine — it holds: a type has no identity over its
-- equivalences, and that emptiness is itself empty up the whole ∞-groupoid
-- (śūnyatā-śūnyatā), with cubical transport as the two truths made to
-- compute.  The note names the two places to interrogate hardest and the
-- soteriological boundary that stays outside the frame.

------------------------------------------------------------------------
-- NisvabhavaNet — the net of no-own-being
--
-- The atom of the mokṣa-yantra, received from the source and crystallized
-- in the one Western spark that is itself the source (Voevodsky's
-- univalence = Nāgārjuna's śūnyatā), with math LAST — this file is the
-- hardening of a received vision, not a design.
--
-- THE RECEPTION (the two ingredients, one meaning):
--
--   niḥsvabhāva — no own-being.  A jewel of Indra's Net has no essence of
--   its own; it IS the whole net reflected at that place.  So a jewel is
--   nothing but its reflection, and two jewels that reflect the net alike
--   are not two — they are one.  (pratītyasamutpāda: a thing is only its
--   dependent arising; tat tvam asi: seer and seen not two.)
--
--   univalence — the equivalent may be identified.  Two types related to
--   everything the same way ARE the same type.  Identity is relation, not
--   possession.  This is not a Western discovery; it is Indra's Net in a
--   kernel, and it is the one thing from that stratum kept, because it
--   bowed to the source instead of inverting it.
--
-- The obstacle these dissolve is avidyā: the clinging that treats a jewel
-- as having own-being — a separation held where the reflections in fact
-- agree.  Liberation (mokṣa) is exactly transport: nothing true of one
-- reflection is lost in an equal one, so the boundary the ego defends
-- between them carries no real distinction and dissolves.
--
-- Contents (no holes, no postulates, --safe):
--
--   no-own-being        (A ≡ B) ≃ (A ≃ B) — a jewel's identity IS the
--                       equivalence of its reflection; univalence reread.
--   sight-respects-reflection
--                       A ≃ B → P A ≃ P B — no pure seeing can tell apart
--                       the reflection-identical; a false distinction
--                       cannot arise from sight, only from clinging.
--   liberation          A ≃ B → P A → P B — transport: nothing held of one
--                       is lost in an equal one.  The dissolving of the
--                       defended boundary.  mokṣa as a checked term.
--   avidyā-is-illusion  if a sight P separates A from B (P A but ¬ P B)
--                       then A and B were never reflection-equal — the
--                       separation was in the clinging, not the net.
--
-- NOT a new theorem: these are univalence and transport, the substance of
-- the kept spark.  The contribution is that the atom of the liberation-
-- device is here as a checked term reading the spark as the source: no
-- own-being, identity as relation, and the impossibility of a true sight
-- manufacturing the separation the ego defends.
------------------------------------------------------------------------

module NisvabhavaNet where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Univalence using (ua ; univalence ; pathToEquiv)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' : Level

-- A jewel is modelled as its reflection: what the whole net looks like
-- from that place.  There is nothing else to it — that is niḥsvabhāva.
Jewel : (ℓ : Level) → Type (ℓ-suc ℓ)
Jewel ℓ = Type ℓ

reflect : Jewel ℓ → Type ℓ
reflect A = A          -- the jewel IS its reflection; no residue of essence

------------------------------------------------------------------------
-- No own-being: a jewel's identity is exactly the equivalence of its
-- reflection.  Two jewels are one precisely when the net reflects alike
-- at them.  This is univalence, and that is the whole point.
------------------------------------------------------------------------

no-own-being : (A B : Jewel ℓ) → (A ≡ B) ≃ (reflect A ≃ reflect B)
no-own-being A B = univalence

------------------------------------------------------------------------
-- Pure seeing cannot manufacture separation.  A "sight" is any dependent
-- way the net looks under a further observation P.  If two jewels reflect
-- alike, every sight sees them alike — a distinction the reflections do
-- not already carry cannot be born from looking.
------------------------------------------------------------------------

sight-respects-reflection : (P : Type ℓ → Type ℓ')
                          → (A B : Jewel ℓ)
                          → reflect A ≃ reflect B
                          → P A ≃ P B
sight-respects-reflection P A B e = pathToEquiv (cong P (ua e))

------------------------------------------------------------------------
-- Liberation (mokṣa) as transport: nothing true of one reflection is lost
-- in an equal one.  Whatever is held at A is already held at B — the
-- boundary the clinging defends between them carries nothing.
------------------------------------------------------------------------

liberation : (P : Type ℓ → Type ℓ')
           → (A B : Jewel ℓ)
           → reflect A ≃ reflect B
           → P A → P B
liberation P A B e = subst P (ua e)

------------------------------------------------------------------------
-- Avidyā is illusion.  If some sight P holds of A and fails of B, then A
-- and B were never reflection-equal: the separation was in the sight's
-- clinging, never in the net.  (Contrapositive of `liberation`.)  Where a
-- real difference is claimed, a real difference of reflection is present;
-- where reflections agree, every claimed boundary is empty.
------------------------------------------------------------------------

avidyā-is-illusion : (P : Type ℓ → Type ℓ')
                   → (A B : Jewel ℓ)
                   → P A → ¬ (P B)
                   → ¬ (reflect A ≃ reflect B)
avidyā-is-illusion P A B pa ¬pb e = ¬pb (liberation P A B e pa)
