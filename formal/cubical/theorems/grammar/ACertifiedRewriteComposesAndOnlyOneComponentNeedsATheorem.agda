{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem
--
--
--   "A certified rewrite carries: boundary-semantics preservation,
--    complexity improvement (peak semantic width / Pareto), state
--    migration, provenance."
--
-- Four components, listed.  A compiler applies rewrites in sequence, so
-- the question the list does not answer is whether the certificate
-- COMPOSES — and if it does, which component costs anything.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Certified d e     the four components as one Σ: the boundary
--                     semantics agree, the cost vector strictly
--                     improves, the state migrates, provenance is
--                     carried
--   composeCertified  certified rewrites compose
--   noSelfRewrite     and no system is a certified rewrite of itself,
--                     so a rewrite sequence never marks time
--
-- **THREE OF THE FOUR COMPOSE FOR FREE.**  Boundary preservation is a
-- path and paths compose; migration is a function and functions
-- compose; provenance is a list and lists append.  Only COMPLEXITY
-- IMPROVEMENT needs a theorem — transitivity of strict Pareto
-- domination — and that theorem already exists in this corpus, proved
-- on the DARWIN §5.2 stratum line for an unrelated purpose
-- (`⊏-trans` in `ANonEmptyArchiveHasANonEmptyStratum`, where it was
-- needed because a maximal element of the tail might be beaten by the
-- head).  `noSelfRewrite` is likewise `⊏-irrefl` from that module.
--
-- So the two notes are joined by a lemma neither asked for: §5.2's
-- parent selection and §39–47's compiler need the SAME fact about the
-- Pareto order, and it was proved once.
--
-- ────────────────────────────────────────────────────────────────────
-- ON THE COST CONVENTION, because it is a live hazard on this line.
-- The cost vector is compared with `StrictlyDominates`, which is the
-- BENEFIT reading — higher is better.  §39–47's "complexity" is a cost,
-- lower is better, so applying this to it requires the flip, and the
-- flip is SOUND BUT NOT FAITHFUL: it needs a cap above every cost ever
-- compared, and identifies costs above that cap
-- (`FlippingACostCoordinateIsSoundButNotFaithful`).  That obligation is
-- inherited here and not discharged.
--
-- NO NOVELTY.  Composing certificates componentwise is what
-- certificates are for; the content is only the count — three free,
-- one earned.
--
-- SYĀT — THE CLAIM, EXACTLY.  "Peak semantic width" is NOT modelled: the cost
-- is an abstract vector, and nothing says it is a width, a Pareto
-- stratum index, or anything computed from a cut.  MIGRATION is a bare
-- function with no law — nothing says it preserves the boundary
-- semantics, and a compiler would need exactly that, so the composite's
-- migration is only as meaningful as its components'.  PROVENANCE is an
-- opaque list; append is not claimed to be the right combination, and
-- nothing checks that a provenance entry corresponds to a step.
-- Nothing here is a compiler: there is no rewrite SEARCH, no strategy,
-- no meta-Bellman `V(D) = min_a (K(D,a,D′) + V(D′))` — §39–47's
-- self-referential planner is untouched and would need a fixpoint.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates)
open import ANonEmptyArchiveHasANonEmptyStratum
  using (⊏-irrefl ; ⊏-trans)

module _ {Sys B Prov : Type}
         (sem  : Sys → B)
         (cost : Sys → List ℕ)
         (M    : Sys → Type)
  where

  ------------------------------------------------------------------
  -- 1.  The four components
  ------------------------------------------------------------------

  Certified : Sys → Sys → Type
  Certified d e =
      (sem e ≡ sem d)                              -- boundary preserved
    × (StrictlyDominates (cost d) (cost e))        -- strictly improved
    × (M d → M e)                                  -- state migration
    × List Prov                                    -- provenance

  ------------------------------------------------------------------
  -- 2.  They compose — three for free, one by ⊏-trans
  ------------------------------------------------------------------

  composeCertified :
    (d e f : Sys) → Certified d e → Certified e f → Certified d f
  composeCertified d e f (sde , imp₁ , mig₁ , prov₁)
                         (sef , imp₂ , mig₂ , prov₂) =
      sef ∙ sde
    , ⊏-trans (cost d) (cost e) (cost f) imp₁ imp₂
    , (λ m → mig₂ (mig₁ m))
    , prov₁ ++ prov₂

  ------------------------------------------------------------------
  -- 3.  And a rewrite never marks time
  ------------------------------------------------------------------

  noSelfRewrite : (d : Sys) → ¬ Certified d d
  noSelfRewrite d (_ , imp , _ , _) = ⊏-irrefl (cost d) imp

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  §"SYĀT — THE CLAIM, EXACTLY" says:
--
--   "MIGRATION is a bare function with no law — nothing says it
--    preserves the boundary semantics, and a compiler would need
--    exactly that, so the composite's migration is only as meaningful
--    as its components'."
--
-- The law is stated and tested in
-- `MigrationNeedsALawAndTheLawIsNotFree`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   Lawful obs mig   `obs e (mig m) ≡ obs d m`
--   composeLawful    lawful migrations compose — as free as the three
--                    components that were already free
--   lawTransportsEveryInvariant
--                    ANY function of the observation is preserved, by
--                    one `cong` — so a lawful migration moves no
--                    derived quantity, which is what state migration
--                    must mean for provenance and caches to survive it
--   unlawfulMigrationExists
--                    `not` on `Bool` under the identity observation is
--                    a migration and is NOT lawful
--
-- **THE LAST ONE IS WHY THE COUNT CHANGES.**  Everything else here
-- composed for free and it would be easy to read migration the same
-- way.  A bare function is exactly a migration with no guarantee, and
-- the witness is one line.  So §39–47's four components are better
-- counted as THREE FREE, ONE EARNED (complexity, by `⊏-trans`), AND
-- ONE UNDER-SPECIFIED — migration, which needs the law added before it
-- means anything.
--
-- THIS MODULE IS NOT AMENDED.  The four-component Σ above is unchanged
-- and `composeCertified` still composes a bare function; adding the law
-- to the record is this module's own next step and is deliberately not
-- taken in the same cycle that discovered the gap.  Also unstated
-- there: any relation between `obs` and `sem`, and the reachable-states
-- version of the law that a real compiler would use.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The next step named in the block above — "adding the law
-- to the record is this module's own next step" — is taken in
-- `TheLawBelongsInTheRecordAndTheCertificateComposesAlongAChain`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
-- The Σ above is STILL unchanged: the five-component `LCertified` is a
-- separate definition there, and this record continues to admit
-- certificates with a lawless migration.
--
-- That module also settles the question this one could not ask, since
-- it had no `obs`: the law is INDEPENDENT of the other four components.
-- `anUnlawfulFourComponentCertificate` is an element of THIS `Certified`
-- — `refl` semantics, strictly improving cost, a migration, provenance —
-- whose migration is `not` and therefore destroys every observation.
-- So requiring the law removes certificates; it does not merely name
-- what four components already forced.
--
-- Still not done anywhere on this line: any relation between `obs` and
-- `sem`, the reachable-states version of the law, associativity of
-- composition (certified rewrites are a semicategory — strict cost
-- improvement removes the identities), and any relation between the
-- length of a chain and the length of its provenance.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  **Short on purpose: this file's appends have outgrown
-- its code (≈40 lines of Agda, ≈55 of record before this), and the
-- standing rule is that the next substantial thing goes in a NEW
-- module.  It did — 28e9a0a4.  This is a pointer, not a fourth essay.**
-- Skipping it entirely was the alternative and was rejected: a reader
-- here would otherwise see the count above with two appends that never
-- mention what is wrong with it, which is the incomplete-propagation
-- failure recorded at 3aa3c78c/94054b52.
--
-- **`FREE`, IN THE COUNT ABOVE, MEANS TWO INCOMPARABLE THINGS.**
-- DERIVABLE-FREE: boundary preservation composes by `∙`, migration by
-- function composition — a real obligation with a one-symbol proof.
-- VACUOUSLY FREE: provenance has NO condition anywhere, so `++`
-- composes it because nothing constrains it.  At 28e9a0a4,
-- `provenanceMayBeDiscarded` proves the sharp form — `(s , i , m , _)`
-- ↦ `(s , i , m , [])` is a certificate for the SAME pair — so no
-- downstream theorem can recover a step from provenance.
--
-- So "three free, one earned" is better read as: two discharged, one
-- earned (`⊏-trans`), one under-specified (migration), one inert
-- (provenance) — four components, four verdicts.  The first append
-- above says "three free, one earned, AND ONE UNDER-SPECIFIED", which
-- is five slots for four components; that arithmetic not closing is
-- what exposed the conflated word.
------------------------------------------------------------------------
