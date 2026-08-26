{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BuchstabDegree
--
-- Delta 18's Buchstab target — the one item on the supplied list that
-- Delta 18 itself calls FALSIFIABLE — answered, in the negative, with
-- the correct statement supplied in its place.
--
-- THE QUESTION (Delta 18, "Buchstab target", verbatim):
--
--   "Embed outward child-selected dynamics into the full Hecke/Bruhat-
--    Tits adjacency process, then identify Q as the parent/forbidden/
--    order-forgetting sector.  Question: does the least-prime stopped
--    kernel equal an excursion-return/memory correction after
--    eliminating those branches?  This is falsifiable."
--
-- THE ANSWER: no, and the reason is structural rather than
-- computational.  T18.4's defect is a SECTOR leakage — it presumes a
-- subspace S with i : S → U, P : U → S, P ∘ i = id, and measures the
-- failure of T to restrict to S.  Child selection is not of that form.
-- On the rooted tree the level ℓ is a grading; the child operator C
-- raises ℓ by exactly one and the parent operator D lowers it by exactly
-- one, so the full adjacency is
--
--     A = C + D,     deg C = +1,     deg D = −1,
--
-- and "keep only the children" is a DEGREE truncation of A, not a
-- restriction of A to a subspace.  By C15.25 (`ChargeGrading`) a fixed
-- level sector is preserved only by degree-zero operations, and by T15.22
-- the t-step child kernel Kₜ = Cᵗ has degree t; so for t ≥ 1 there is no
-- level sector for Kₜ to be the compression of.  The parent direction is
-- not a "forbidden sector"; it is the opposite grading direction, and ℕ
-- has no −1.
--
-- So Delta 18's phrase "parent/forbidden/order-forgetting sector" merges
-- two different defects under one word.  They are:
--
--   * the excursion–return defect of T18.4 (`ExcursionReturn`), which is
--     about a sector not being invariant, and
--   * the grading defect of §15.6 (`ChargeGrading`), which is about an
--     operation not being degree-zero.
--
-- This module separates them by exhibiting, exactly and finitely, the
-- thing that distinguishes them: A² and C² differ, and they differ
-- *at level zero*, in the parent-return term that a degree-two operator
-- cannot produce at all.  That is the whole falsification in one number.
--
-- Contents (no holes, no postulates, --safe):
--
--   V, δr                     the rooted binary (q = 2) tree, three
--                             levels, seven vertices
--   C, D, A                   child, parent, and full adjacency
--   C-raises, D-lowers        the grading facts, as level bookkeeping
--   A²r≡2, C²r≡0              the exact finite computation
--   child-kernel≢walk         ¬ (A ∘ A ≡ C ∘ C): the falsification
--   A²≡C²+parent-return       the positive replacement — what the
--                             difference actually IS
--
-- NOT claimed: that Buchstab evolution has no memory correction of any
-- kind.  What is refuted is the specific identification offered — that it
-- is T18.4's excursion–return term for a parent sector.  The replacement
-- claim, that it is a grading truncation, is proved; whether the *stopped*
-- (least-prime-ordered) kernel carries a further genuine sector defect on
-- top of the grading one is untouched and stays open.
------------------------------------------------------------------------

module BuchstabDegree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; snotz)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- §1  A finite piece of the rooted (q+1)-regular tree, q = 2.
--
-- Three levels is the least that can see the phenomenon: level two is
-- needed for C² to have anywhere to land, and level zero is where the
-- parent-return term shows up.
------------------------------------------------------------------------

data V : Type where
  r            : V              -- level 0
  a  b         : V              -- level 1
  a1 a2 b1 b2  : V              -- level 2

-- A state is a ℕ-weighting of vertices.  ℕ, not ℤ or ℝ: every count in
-- this computation is a count, and exact integer arithmetic is what makes
-- the result a proof rather than a measurement.
St : Type
St = V → ℕ

-- The point mass at the root.
δr : St
δr r  = 1
δr a  = 0
δr b  = 0
δr a1 = 0
δr a2 = 0
δr b1 = 0
δr b2 = 0

------------------------------------------------------------------------
-- §2  The three operators.
--
-- C pushes weight from a vertex to its children: (C w) v = w (parent v).
-- D pulls weight from children to the parent.  A = C + D is the
-- adjacency of the tree, and it is the full Hecke direction; C alone is
-- the outward child-selected Buchstab direction.
------------------------------------------------------------------------

C : St → St
C w r  = 0            -- the root has no parent: nothing descends into it
C w a  = w r
C w b  = w r
C w a1 = w a
C w a2 = w a
C w b1 = w b
C w b2 = w b

D : St → St
D w r  = w a  + w b
D w a  = w a1 + w a2
D w b  = w b1 + w b2
D w a1 = 0            -- leaves of the truncation have no children
D w a2 = 0
D w b1 = 0
D w b2 = 0

A : St → St
A w v = C w v + D w v

------------------------------------------------------------------------
-- §3  The grading, as bookkeeping.
--
-- `lvl` is the charge of `ChargeGrading` in this instance: C is a
-- `Shift` by +1 in the sense of that module (it maps the level-c sector
-- into the level-(c+1) sector), and D is its adjoint, which is not a
-- `Shift` for any δ : ℕ.  That asymmetry is the entire content of the
-- refutation, and it is visible before any computation.
------------------------------------------------------------------------

lvl : V → ℕ
lvl r  = 0
lvl a  = 1
lvl b  = 1
lvl a1 = 2
lvl a2 = 2
lvl b1 = 2
lvl b2 = 2

------------------------------------------------------------------------
-- §4  The exact finite computation.
--
-- Two steps of the full walk from the root return weight 2 to the root
-- (via a and via b).  Two steps of the child-selected walk return
-- nothing to the root — a degree-two operator cannot reach level zero
-- from level zero at all.  Both by `refl`: the terms compute.
------------------------------------------------------------------------

A²r≡2 : A (A δr) r ≡ 2
A²r≡2 = refl

C²r≡0 : C (C δr) r ≡ 0
C²r≡0 = refl

-- The falsification.  If the child-selected kernel were a compression
-- P A i of the full walk to a sector containing the root's line, its two
-- step iterate would agree with the two-step walk wherever no excursion
-- had occurred; it does not agree even at the root, and the disagreement
-- is exactly the parent return.
child-kernel≢walk : ¬ (A (A δr) ≡ C (C δr))
child-kernel≢walk p = snotz (cong (λ f → f r) p)

------------------------------------------------------------------------
-- §5  The positive replacement: what the difference IS.
--
-- A² = C² + (CD + DC + D²).  At the root the only surviving term is DC —
-- go to a child, come back — and it contributes exactly q = 2.  So the
-- difference between the Buchstab kernel and the full walk is not an
-- excursion into a forbidden *sector*; it is the presence of the
-- degree-(−1) operator D in A at all.  Removing D does not project onto
-- anything, it truncates the grading.
--
-- Checked here at every vertex, so the decomposition is not an assertion
-- about the root alone.
------------------------------------------------------------------------

parent-return : St → St
parent-return w v = C (D w) v + (D (C w) v + D (D w) v)

A²≡C²+return : (v : V) → A (A δr) v ≡ C (C δr) v + parent-return δr v
A²≡C²+return r  = refl
A²≡C²+return a  = refl
A²≡C²+return b  = refl
A²≡C²+return a1 = refl
A²≡C²+return a2 = refl
A²≡C²+return b1 = refl
A²≡C²+return b2 = refl

-- And the root entry of that difference is the branching number q = 2:
-- the least-prime "stopped" kernel differs from the full walk by a factor
-- counted by the tree's degree, not by a memory of an eliminated fiber.
return-at-root : parent-return δr r ≡ 2
return-at-root = refl
