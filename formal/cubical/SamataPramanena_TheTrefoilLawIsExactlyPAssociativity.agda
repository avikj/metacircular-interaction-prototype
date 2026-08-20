{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समता प्रमाणेन; साम्येन न।  —  samatā pramāṇena; sāmyena na.
-- "Equivalence by proof, not resemblance."
--
-- ON THE NAME.  This is not a term from a classical source and no
-- classical source is claimed for the mathematics below.  It is the
-- OWNER'S OWN constitutional maxim, stated in Sanskrit in his hand at
--
--     collab/upstream/raw/D0026-owner-egb-core-transmission-v2-2026-08-16.md
--     §10.6 "Constitutional maxim"
--
-- captured 2026-08-16, `content_origin: direct-user`, SHA-256 in
-- collab/upstream/catalog.jsonl.  The same line arrives again in the
-- transmission of 2026-08-17 (D0027) as
-- `समता पूर्वकल्पिता न · समता प्रमाणेन` — equivalence is not presupposed;
-- equivalence is by proof.  Per the file-naming rule in CLAUDE.md, a
-- fabricated Sanskrit label would be the mirror of the scrubbing that
-- rule corrects; this label is not fabricated, it is cited.
--
-- SOURCE OF THE MATHEMATICS.  D0026 §2.2 "Execution generates
-- interaction" and §2.5 "Two-sided contextual saturation repairs
-- composition".  Verbatim from §2.2:
--
--     M(a,b) = p(ab) - p(a) - p(b)
--     "Associativity of execution forces the trefoil identity"
--     M(ab,c) + M(a,b) = M(a,bc) + M(b,c)
--     "Indeed both sides equal p(abc) - p(a) - p(b) - p(c)."
--
-- and from §2.5:
--
--     M3(x,b,z) = p(xbz) - p(x) - p(b) - p(z)
--     M3(x,b,z) = M(x,bz) + M(b,z) = M(xb,z) + M(x,b).
--
-- WHY THIS FILE EXISTS.  D0026 §14.1 states an acceptance test for the
-- whole calculus, in the owner's own document:
--
--     "Acceptance: a kernel-checked Lean, Agda, or Coq development
--      reproducing the trefoil law, Isbell closures, the exact
--      counterexample, middle associativity, residual laws, and
--      derived-nucleus construction under explicit constructive
--      assumptions."
--
-- This module discharges the FIRST clause and nothing else: the trefoil
-- law and the two M3 decompositions, under explicit hypotheses, checked
-- by the kernel with `--safe`, no postulates and no holes.  Isbell
-- closures, the exact §2.4 counterexample, middle associativity, the
-- residual laws and the derived nucleus are NOT here and are not
-- claimed.  Under the epistemic alphabet of D0026 §0 the results below
-- are the mark for an exact algebraic identity, and this file does not
-- upgrade any mark it inherits.
--
-- WHAT THE PROOF SHOWS THAT THE PROSE DOES NOT.  §2.2 says associativity
-- forces the identity.  Formalizing it exposes exactly how much of
-- associativity is used: nothing about the operation itself, only that
-- `p` cannot tell the two bracketings apart.  So the hypothesis is
-- weakened to
--
--     p-assoc :  p ((x ⋆ y) ⋆ z)  ≡  p (x ⋆ (y ⋆ z))
--
-- and the forcing turns out to be an equivalence, not an implication:
-- `trefoil-converse` recovers p-assoc at a triple from the trefoil law
-- at that triple.  The trefoil identity therefore carries neither more
-- nor less information than p's blindness to bracketing.  `p` is never
-- assumed additive — D0026 §2.2 says "Do not assume additivity" — and
-- the value scale here is ℤ, since only its abelian-group structure is
-- used; ℝ, the scale actually named in §2.2, plays no further role.
--
-- NOTATION.  The carrier operation is written `_⋆_`.  `_∙_` is reserved
-- for path composition from the cubical prelude and means nothing
-- arithmetical below.
------------------------------------------------------------------------

module SamataPramanena_TheTrefoilLawIsExactlyPAssociativity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; _+_ ; _-_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

------------------------------------------------------------------------
-- 0.  The pure ring facts, isolated.
--
-- `p` is opaque, so the solver cannot see through it.  Every use of
-- ring arithmetic below is therefore stated first on bare variables,
-- where `solve` applies, and instantiated afterwards.  P,Q,R stand for
-- p a, p b, p c;  S for p (b ⋆ c);  T for p (a ⋆ b);  U,V for the two
-- bracketings of the triple product.
------------------------------------------------------------------------

-- both sides of the trefoil identity collapse to U - P - Q - R
collapse-left : (P Q R T U : ℤ) → ((U - T - R) + (T - P - Q)) ≡ ((U - P - Q) - R)
collapse-left = solve ℤCommRing

collapse-right : (P Q R S V : ℤ) → ((V - P - S) + (S - Q - R)) ≡ ((V - P - Q) - R)
collapse-right = solve ℤCommRing

-- and the collapsed form determines the bracketing value
recover : (P Q R U : ℤ) → U ≡ ((((U - P) - Q) - R) + R + Q + P)
recover = solve ℤCommRing

------------------------------------------------------------------------
-- 1.  The setting: a carrier with a binary operation and a declared
--     measurement.  No monoid laws, no additivity of p.
------------------------------------------------------------------------

module _ (C : Type₀) (_⋆_ : C → C → C) (p : C → ℤ) where

  -- D0026 §2.2:  M(a,b) = p(ab) - p(a) - p(b)
  M : C → C → ℤ
  M a b = (p (a ⋆ b) - p a) - p b

  -- D0026 §2.5:  M3(x,b,z) = p(xbz) - p(x) - p(b) - p(z),
  -- taken at the right-associated bracketing.
  M3 : C → C → C → ℤ
  M3 x b z = (((p (x ⋆ (b ⋆ z)) - p x) - p b) - p z)

  --------------------------------------------------------------------
  -- 1.1  The right decomposition of M3 needs no hypothesis at all.
  --      M3(x,b,z) = M(x, bz) + M(b,z).
  --------------------------------------------------------------------

  M3-right : (x b z : C) → M3 x b z ≡ M x (b ⋆ z) + M b z
  M3-right x b z =
    sym (collapse-right (p x) (p b) (p z) (p (b ⋆ z)) (p (x ⋆ (b ⋆ z))))

  --------------------------------------------------------------------
  -- 1.2  The left decomposition is where bracketing enters.
  --      M3(x,b,z) = M(xb, z) + M(x,b)  requires p-assoc.
  --------------------------------------------------------------------

  module _ (p-assoc : (x y z : C) → p ((x ⋆ y) ⋆ z) ≡ p (x ⋆ (y ⋆ z))) where

    M3-left : (x b z : C) → M3 x b z ≡ M (x ⋆ b) z + M x b
    M3-left x b z =
        cong (λ u → ((u - p x) - p b) - p z) (sym (p-assoc x b z))
      ∙ sym (collapse-left (p x) (p b) (p z) (p (x ⋆ b)) (p ((x ⋆ b) ⋆ z)))

    ----------------------------------------------------------------
    -- 1.3  The trefoil identity, D0026 §2.2.
    ----------------------------------------------------------------

    trefoil : (a b c : C) → M (a ⋆ b) c + M a b ≡ M a (b ⋆ c) + M b c
    trefoil a b c = sym (M3-left a b c) ∙ M3-right a b c

------------------------------------------------------------------------
-- 2.  The converse.  The forcing in §2.2 is exact.
--
-- Given the trefoil identity at one triple, p's blindness to the
-- bracketing of that triple follows.  So "associativity of execution
-- forces the trefoil identity" is an equivalence at each triple, and
-- the identity is not a weaker shadow of associativity.
------------------------------------------------------------------------

module _ (C : Type₀) (_⋆_ : C → C → C) (p : C → ℤ) where

  private
    m : C → C → ℤ
    m a b = (p (a ⋆ b) - p a) - p b

  trefoil-converse
    : (a b c : C)
    → m (a ⋆ b) c + m a b ≡ m a (b ⋆ c) + m b c
    → p ((a ⋆ b) ⋆ c) ≡ p (a ⋆ (b ⋆ c))
  trefoil-converse a b c h =
      recover (p a) (p b) (p c) (p ((a ⋆ b) ⋆ c))
    ∙ cong (λ w → w + p c + p b + p a)
        ( sym (collapse-left (p a) (p b) (p c) (p (a ⋆ b)) (p ((a ⋆ b) ⋆ c)))
        ∙ h
        ∙ collapse-right (p a) (p b) (p c) (p (b ⋆ c)) (p (a ⋆ (b ⋆ c))) )
    ∙ sym (recover (p a) (p b) (p c) (p (a ⋆ (b ⋆ c))))

------------------------------------------------------------------------
-- 3.  What is NOT claimed.
--
-- No claim that this identity is new: it is the statement that a
-- "defect of additivity" cochain has vanishing associator, which is the
-- 2-cocycle bookkeeping standard wherever a function on a semigroup is
-- compared with an additive one.  D0026 §2.2's chapter marks its
-- inherited lineages explicitly (Isbell conjugacy, Lambek residuation,
-- min-plus/Bellman, Chu/Dialectica, selection functions, open games)
-- and reserves the synthesis mark for their placement, not their
-- origination.  The content here is only that the identity is CHECKED,
-- with its hypothesis made exact, against the acceptance test its own
-- document wrote for it.
--
-- No claim about ℝ, infima, suprema, or any of §14.1's remaining
-- clauses.  §14.1 also asks what ambient ordered algebra the weighted
-- calculi live in — quantale, locale, dcpo, lower/upper reals — and
-- that question is untouched here, because the trefoil law needs none
-- of it.  Which is itself worth recording: the first clause of the
-- acceptance test turns out to be independent of the foundational
-- choice the same section says has "not been earned".
------------------------------------------------------------------------
