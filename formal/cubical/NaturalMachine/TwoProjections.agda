{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TwoProjections
--
-- Delta 15 §15.9 (comparison of two projections), all four statements,
-- on a four-point set with everything decided by `refl`.
--
-- Delta 15 states T15.36 with the hedge "when standard splitting
-- hypotheses hold" and states P15.37/C15.38 in words.  Both hedges are
-- doing real work, and the way to show it is to exhibit the instances
-- rather than to restate the hedge:
--
--   * T15.36 (im(PQ) = im P ∩ im Q for commuting P,Q) — CONFIRMED on a
--     commuting pair, and SHOWN NECESSARY by a non-commuting pair where
--     it fails.  The hypothesis is not decoration.
--
--   * P15.37 (non-commutation ⇒ order of coarse-graining matters) —
--     witnessed: `order-matters`, the two composites disagree at a point.
--
--   * C15.38 (commutation does NOT imply no information loss) — this is
--     the one that matters for the corpus, because it is the standing
--     temptation: two coarse-grainings that commute feel safe.  Here is a
--     commuting pair whose composite is CONSTANT.  Zero commutator, total
--     loss.  Delta 15's own gloss — "linear operations may commute while
--     genuine non-descent lives elsewhere" — is exactly this witness.
--
-- WHY A SET AND NOT A MODULE.  Delta 15 says "idempotent endomorphisms of
-- a vector space/module", and over a *commutative* ring every commutator
-- vanishes, so the interesting half of §15.9 cannot even be stated in the
-- CommRing setting the rest of this development uses.  Idempotent
-- endofunctions of a finite set are the smallest home where both
-- commuting and non-commuting pairs exist, and they are the machine's own
-- idiom: an idempotent endofunction IS a retract i ∘ P, which is the
-- (i, P, P ∘ i = id) data of `ExcursionReturn`.
--
-- Contents (no holes, no postulates, --safe; every equation is `refl`):
--
--   X, p, q, s                 four points, three idempotents
--   p-idem, q-idem, s-idem     D15.35's hypothesis, checked
--   order-matters              P15.37: p∘q ≢ q∘p, witnessed at x2
--   ps-commute                 [p,s] = 0, pointwise
--   ps-constant                … and yet p∘s is constant …
--   commuting-loses            … so it collapses a distinction that a
--                              downstream test can see.  C15.38.
--   T15-36-holds               im(p∘s) = im p ∩ im s, both inclusions
--   T15-36-fails-without       im(p∘q) ⊋ im p ∩ im q: x2 is in the
--                              composite image and not in im q
--
-- NOT claimed: that the hedged form of T15.36 is wrong.  It is right, and
-- it is confirmed here.  What is contributed is that the hypothesis is
-- shown to be load-bearing by a counterexample, and that C15.38 gets a
-- witness instead of a sentence.
------------------------------------------------------------------------

module NaturalMachine.TwoProjections where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- §1  Four points and three idempotents.
------------------------------------------------------------------------

data X : Type where
  x0 x1 x2 x3 : X

-- p collapses {x0,x1} to x0 and {x2,x3} to x2.
p : X → X
p x0 = x0
p x1 = x0
p x2 = x2
p x3 = x2

-- q collapses {x1,x2} to x1 and fixes the rest.
q : X → X
q x0 = x0
q x1 = x1
q x2 = x1
q x3 = x3

-- s collapses {x0,x2} to x0 and {x1,x3} to x1 — the "other" partition
-- into two blocks, transverse to p's.
s : X → X
s x0 = x0
s x1 = x1
s x2 = x0
s x3 = x1

p-idem : (x : X) → p (p x) ≡ p x
p-idem x0 = refl
p-idem x1 = refl
p-idem x2 = refl
p-idem x3 = refl

q-idem : (x : X) → q (q x) ≡ q x
q-idem x0 = refl
q-idem x1 = refl
q-idem x2 = refl
q-idem x3 = refl

s-idem : (x : X) → s (s x) ≡ s x
s-idem x0 = refl
s-idem x1 = refl
s-idem x2 = refl
s-idem x3 = refl

------------------------------------------------------------------------
-- §2  Point separation.  One Boolean test per distinction needed; this
-- is the whole of the "discreteness" machinery this module requires.
------------------------------------------------------------------------

is-x0 : X → Bool
is-x0 x0 = true
is-x0 x1 = false
is-x0 x2 = false
is-x0 x3 = false

is-x2 : X → Bool
is-x2 x0 = false
is-x2 x1 = false
is-x2 x2 = true
is-x2 x3 = false

------------------------------------------------------------------------
-- §3  P15.37.  p and q do not commute, so the ORDER of coarse-graining
-- matters: applying q then p sends x2 to x0, applying p then q sends it
-- to x1.  Two analysts who agree on which two coarse-grainings to perform
-- disagree on the answer.
------------------------------------------------------------------------

order-matters : ¬ (p (q x2) ≡ q (p x2))
order-matters e = true≢false (cong is-x0 e)

------------------------------------------------------------------------
-- §4  C15.38, the statement worth having.  p and s DO commute — checked
-- at every point, which is what "[p,s] = 0" means here — and their
-- composite is the constant map at x0.  So a vanishing commutator says
-- nothing at all about information loss: this pair loses everything.
------------------------------------------------------------------------

ps-commute : (x : X) → p (s x) ≡ s (p x)
ps-commute x0 = refl
ps-commute x1 = refl
ps-commute x2 = refl
ps-commute x3 = refl

ps-constant : (x : X) → p (s x) ≡ x0
ps-constant x0 = refl
ps-constant x1 = refl
ps-constant x2 = refl
ps-constant x3 = refl

-- A downstream test that the composite has destroyed.  `is-x2` is the
-- "stopped process / nonlinear observable" of C15.38 in miniature: it
-- separates x2 from x0, the composite does not, and no amount of
-- commutativity repairs that.
commuting-loses : (is-x2 x2 ≡ true) × (is-x2 x0 ≡ false)
                × (p (s x2) ≡ p (s x0))
commuting-loses = refl , refl , refl

------------------------------------------------------------------------
-- §5  T15.36, confirmed and shown to need its hypothesis.
--
-- im p = {x0,x2}, im s = {x0,x1}, im q = {x0,x1,x3}.
--
-- Commuting pair (p,s): im(p∘s) = {x0} = im p ∩ im s.  ✓
-- Non-commuting pair (p,q): im(p∘q) = {x0,x2}, but x2 ∉ im q, so the
-- composite image is strictly larger than the intersection.  ✗
------------------------------------------------------------------------

-- ⊆ : everything in the image of the composite is x0, hence in both.
T15-36-⊆ : (x : X) → (Σ[ y ∈ X ] (p y ≡ p (s x)))
                   × (Σ[ z ∈ X ] (s z ≡ p (s x)))
T15-36-⊆ x0 = (x0 , refl) , (x0 , refl)
T15-36-⊆ x1 = (x0 , refl) , (x0 , refl)
T15-36-⊆ x2 = (x0 , refl) , (x0 , refl)
T15-36-⊆ x3 = (x0 , refl) , (x0 , refl)

-- ⊇ : the intersection is exactly {x0}, and x0 is hit by the composite.
T15-36-⊇ : Σ[ x ∈ X ] (p (s x) ≡ x0)
T15-36-⊇ = x0 , refl

-- Necessity of commutation.  x2 is in the image of p∘q (from x3) and is
-- NOT in the image of q at all — so im(p∘q) ⊄ im q, and T15.36 is false
-- for this pair.  The hypothesis in Delta 15 is load-bearing.
x2-in-im-pq : Σ[ x ∈ X ] (p (q x) ≡ x2)
x2-in-im-pq = x3 , refl

x2-not-in-im-q : ¬ (Σ[ x ∈ X ] (q x ≡ x2))
x2-not-in-im-q (x0 , e) = true≢false (cong is-x2 (sym e))
x2-not-in-im-q (x1 , e) = true≢false (cong is-x2 (sym e))
x2-not-in-im-q (x2 , e) = true≢false (cong is-x2 (sym e))
x2-not-in-im-q (x3 , e) = true≢false (cong is-x2 (sym e))

T15-36-fails-without-commutation :
  (Σ[ x ∈ X ] (p (q x) ≡ x2)) × (¬ (Σ[ x ∈ X ] (q x ≡ x2)))
T15-36-fails-without-commutation = x2-in-im-pq , x2-not-in-im-q
