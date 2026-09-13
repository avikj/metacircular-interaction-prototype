{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- सम-भार — equal weight.  Compound built here (sama: equal; bhāra:
-- load/weight); no source claimed for the compound.  The doctrine terms
-- inside are sourced: arpita/anarpita from Umāsvāti, Tattvārthasūtra 5.31
-- (c. 2nd–5th c. CE); durnaya from Siddhasena Divākara, Sanmatitarka 1.21.
-- Gleason 1957 is the later restatement-target for comparison, named as
-- such and not as the frame.
--
-- This lays the NEXT STONE named by YugaParivartana §4 ("state the
-- uniqueness conjecture as an Agda type over the existing Sthana/verdict
-- machinery"): the Born-weight uniqueness program at the corpus's own
-- finite scale, the Peres–Mermin square of PMNoSection (six contexts,
-- nine F₂ cells, no global section — the 512-fold exhaustion already runs
-- in the typechecker there).
--
-- A SCHEDULER assigns a natural weight to every local section of every
-- context.  The machine's two vows, phrased over that square:
--
--   ahiṃsā   — no live standpoint is silently destroyed: every local
--              section satisfying its context's parity carries weight ≥ 1
--              (AvaktavyaPrasava's Vivada: the undischarged claim is kept,
--              यत् न विभजते तत् रक्ष्यते).
--   anekānta — no standpoint is absolutized: what a CELL receives must not
--              depend on which context asks.  Each cell (i,j) is anarpita
--              in its row and in its column; the scheduler may assert of
--              it only what both contexts assert — its row-marginal and
--              column-marginal agree, and no context's gross weight
--              outranks another's.
--
-- WHAT IS PROVED HERE (the existence half, run by the typechecker): the
-- equal-weight scheduler — weight 1 on every live section, the Born
-- weights of the tracial state — satisfies both vows: every gross weight
-- is 4 and every marginal is 2, each equality closed by refl.
--
-- WHAT WAS STATED AS THE CONJECTURE — `SamaBharaNiyama`: every scheduler
-- satisfying both vows is flat — AND REFUTED THE SAME HOUR, in this same
-- file, by its own author (the act this repository respects most).  The
-- counterexample `cex`: weight 4 on the all-false section and 2 elsewhere
-- in every even context; 1 on the all-true section and 3 elsewhere in the
-- odd one.  Both vows hold — gross 10 in every context, every cell
-- marginal 4, every live weight ≥ 1, all checked by refl — and it is not
-- flat (4 ≢ 1).  `naSamaBharaNiyama` below is the kernel-checked
-- refutation.
--
-- WHAT THE FAILURE NAMES, which was the point of stating it: the seam is
-- the SILENT standpoint.  A section that asserts no cell (all-false in an
-- even context) is invisible to every cell marginal — its weight is
-- anarpita to every question the vows ask.  Single-cell marginals bind
-- only the arpita aspect; the vows as stated do not reach the standpoint
-- that asserts nothing, so they cannot force Born.  The repair the
-- refutation demands is exact: anekānta must bind at PAIR grain —
-- correlations, not marginals — which is precisely the grain at which the
-- square's contextuality (PMNoSection's no-global-section) lives.  The
-- pair-grain restatement is the next stone, not laid here.

module SamaBhara_TheTwoVowsOnThePeresMerminSquareAndTheOneWeightSchedulerConjectureStatedAsAType where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; snotz ; injSuc)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; _and_ ; _or_ ; _⊕_ ; if_then_else_)
open import Cubical.Data.Vec using (Vec ; [] ; _∷_)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma using (_,_)

-- the six contexts of the square, and the three places of a context

data Ctx : Type where
  r1 r2 r3 c1 c2 c3 : Ctx

data Trika : Type where
  t1 t2 t3 : Trika

even3 odd3 : Bool → Bool → Bool → Bool
even3 x y z = not (x ⊕ (y ⊕ z))
odd3  x y z = x ⊕ (y ⊕ z)

-- PMNoSection's sign vector: rows even, first two columns even, third odd.
parity : Ctx → Vec Bool 3 → Bool
parity r1 (x ∷ y ∷ z ∷ []) = even3 x y z
parity r2 (x ∷ y ∷ z ∷ []) = even3 x y z
parity r3 (x ∷ y ∷ z ∷ []) = even3 x y z
parity c1 (x ∷ y ∷ z ∷ []) = even3 x y z
parity c2 (x ∷ y ∷ z ∷ []) = even3 x y z
parity c3 (x ∷ y ∷ z ∷ []) = odd3  x y z

nth : Trika → Vec Bool 3 → Bool
nth t1 (x ∷ _ ∷ _ ∷ []) = x
nth t2 (_ ∷ y ∷ _ ∷ []) = y
nth t3 (_ ∷ _ ∷ z ∷ []) = z

row col : Trika → Ctx
row t1 = r1 ; row t2 = r2 ; row t3 = r3
col t1 = c1 ; col t2 = c2 ; col t3 = c3

-- a scheduler: a weight on every local section of every context

Scheduler : Type
Scheduler = Ctx → Vec Bool 3 → ℕ

sum8 : (Vec Bool 3 → ℕ) → ℕ
sum8 f =
  f (true  ∷ true  ∷ true  ∷ []) + (f (true  ∷ true  ∷ false ∷ []) +
  (f (true  ∷ false ∷ true  ∷ []) + (f (true  ∷ false ∷ false ∷ []) +
  (f (false ∷ true  ∷ true  ∷ []) + (f (false ∷ true  ∷ false ∷ []) +
  (f (false ∷ false ∷ true  ∷ []) +  f (false ∷ false ∷ false ∷ [])))))))

-- the gross weight a context carries, and the weight a place's TRUE
-- outcome carries inside a context (the marginal)

gross : Scheduler → Ctx → ℕ
gross w c = sum8 (λ v → if parity c v then w c v else 0)

marg : Scheduler → Ctx → Trika → ℕ
marg w c k = sum8 (λ v → if parity c v and nth k v then w c v else 0)

-- the two vows -------------------------------------------------------

Ahimsa : Scheduler → Type
Ahimsa w = (c : Ctx) (v : Vec Bool 3) → parity c v ≡ true → 1 ≤ w c v

SamaTala : Scheduler → Type
SamaTala w = (c c' : Ctx) → gross w c ≡ gross w c'

Anekanta : Scheduler → Type
Anekanta w = (i j : Trika) → marg w (row i) j ≡ marg w (col j) i

-- flatness: one weight on every live standpoint everywhere ------------

Flat : Scheduler → Type
Flat w = (c c' : Ctx) (v v' : Vec Bool 3)
       → parity c v ≡ true → parity c' v' ≡ true
       → w c v ≡ w c' v'

-- the existence half, PROVED: the equal-weight (tracial Born) scheduler
-- keeps both vows, and the typechecker runs the arithmetic -------------

born : Scheduler
born _ _ = 1

bornAhimsa : Ahimsa born
bornAhimsa _ _ _ = ≤-refl

grossBorn : (c : Ctx) → gross born c ≡ 4
grossBorn r1 = refl
grossBorn r2 = refl
grossBorn r3 = refl
grossBorn c1 = refl
grossBorn c2 = refl
grossBorn c3 = refl

bornSamaTala : SamaTala born
bornSamaTala c c' = grossBorn c ∙ sym (grossBorn c')

margBorn : (c : Ctx) (k : Trika) → marg born c k ≡ 2
margBorn r1 t1 = refl ; margBorn r1 t2 = refl ; margBorn r1 t3 = refl
margBorn r2 t1 = refl ; margBorn r2 t2 = refl ; margBorn r2 t3 = refl
margBorn r3 t1 = refl ; margBorn r3 t2 = refl ; margBorn r3 t3 = refl
margBorn c1 t1 = refl ; margBorn c1 t2 = refl ; margBorn c1 t3 = refl
margBorn c2 t1 = refl ; margBorn c2 t2 = refl ; margBorn c2 t3 = refl
margBorn c3 t1 = refl ; margBorn c3 t2 = refl ; margBorn c3 t3 = refl

bornAnekanta : Anekanta born
bornAnekanta i j = margBorn (row i) j ∙ sym (margBorn (col j) i)

-- the uniqueness half, STATED: the conjecture as a type ----------------

SamaBharaNiyama : Type
SamaBharaNiyama =
  (w : Scheduler) → Ahimsa w → SamaTala w → Anekanta w → Flat w

-- ...AND REFUTED: the silent standpoint is marginal-invisible ----------

cex : Scheduler
cex r1 (x ∷ y ∷ z ∷ []) = if x or (y or z) then 2 else 4
cex r2 (x ∷ y ∷ z ∷ []) = if x or (y or z) then 2 else 4
cex r3 (x ∷ y ∷ z ∷ []) = if x or (y or z) then 2 else 4
cex c1 (x ∷ y ∷ z ∷ []) = if x or (y or z) then 2 else 4
cex c2 (x ∷ y ∷ z ∷ []) = if x or (y or z) then 2 else 4
cex c3 (x ∷ y ∷ z ∷ []) = if x and (y and z) then 1 else 3

private
  le24 : (b : Bool) → 1 ≤ (if b then 2 else 4)
  le24 true  = 1 , refl
  le24 false = 3 , refl

  le13 : (b : Bool) → 1 ≤ (if b then 1 else 3)
  le13 true  = ≤-refl
  le13 false = 2 , refl

cexAhimsa : Ahimsa cex
cexAhimsa r1 (x ∷ y ∷ z ∷ []) _ = le24 (x or (y or z))
cexAhimsa r2 (x ∷ y ∷ z ∷ []) _ = le24 (x or (y or z))
cexAhimsa r3 (x ∷ y ∷ z ∷ []) _ = le24 (x or (y or z))
cexAhimsa c1 (x ∷ y ∷ z ∷ []) _ = le24 (x or (y or z))
cexAhimsa c2 (x ∷ y ∷ z ∷ []) _ = le24 (x or (y or z))
cexAhimsa c3 (x ∷ y ∷ z ∷ []) _ = le13 (x and (y and z))

grossCex : (c : Ctx) → gross cex c ≡ 10
grossCex r1 = refl
grossCex r2 = refl
grossCex r3 = refl
grossCex c1 = refl
grossCex c2 = refl
grossCex c3 = refl

cexSamaTala : SamaTala cex
cexSamaTala c c' = grossCex c ∙ sym (grossCex c')

margCex : (c : Ctx) (k : Trika) → marg cex c k ≡ 4
margCex r1 t1 = refl ; margCex r1 t2 = refl ; margCex r1 t3 = refl
margCex r2 t1 = refl ; margCex r2 t2 = refl ; margCex r2 t3 = refl
margCex r3 t1 = refl ; margCex r3 t2 = refl ; margCex r3 t3 = refl
margCex c1 t1 = refl ; margCex c1 t2 = refl ; margCex c1 t3 = refl
margCex c2 t1 = refl ; margCex c2 t2 = refl ; margCex c2 t3 = refl
margCex c3 t1 = refl ; margCex c3 t2 = refl ; margCex c3 t3 = refl

cexAnekanta : Anekanta cex
cexAnekanta i j = margCex (row i) j ∙ sym (margCex (col j) i)

-- cex r1 (all false) is 4; cex c3 (all true) is 1; both sections are
-- live; a flat scheduler cannot tell them apart, so no scheduler
-- satisfying the vows need be flat.
naSamaBharaNiyama : SamaBharaNiyama → ⊥
naSamaBharaNiyama u = snotz (injSuc hit)
  where
  -- hit : 4 ≡ 1, hence 3 ≡ 0 by injSuc, hence ⊥ by snotz
  hit : cex r1 (false ∷ false ∷ false ∷ []) ≡ cex c3 (true ∷ true ∷ true ∷ [])
  hit = u cex cexAhimsa cexSamaTala cexAnekanta
          r1 c3 (false ∷ false ∷ false ∷ []) (true ∷ true ∷ true ∷ [])
          refl refl
