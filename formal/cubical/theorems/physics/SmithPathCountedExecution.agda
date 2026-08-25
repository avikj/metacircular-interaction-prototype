{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module SmithPathCountedExecution where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import CountedExecution using (run)

-- Signed integer data used by the concrete 3 by 3 certificates below.
-- `neg n` denotes -n.  The tables in the first half of this file were
-- originally transcribed from notes/SMITH_PATH_HOLONOMY.md; the
-- certification section at the bottom of this file proves, over the cubical
-- library's own integer-matrix layer (Cubical.Algebra.IntegerMatrix.Smith),
-- that they really are Smith certificates for diag(2,3,2) — so nothing
-- below is trusted transcription any more.
data Z : Type₀ where
  zro : Z
  pos : ℕ → Z
  neg : ℕ → Z

record Mat3 : Type₀ where
  constructor mat3
  field
    a00 a01 a02 : Z
    a10 a11 a12 : Z
    a20 a21 a22 : Z

open Mat3

I3 : Mat3
I3 = mat3 (pos 1) zro zro zro (pos 1) zro zro zro (pos 1)

-- Cumulative left transformations for the two legal adjacent-pair schedules
-- on diag(2,3,2).  They are the exact certificates Up and Uq from
-- notes/SMITH_PATH_HOLONOMY.md.
Up : Mat3
Up = mat3 (neg 1) (pos 1) zro
          zro zro (pos 1)
          (pos 3) (neg 2) (pos 3)

Uq : Mat3
Uq = mat3 zro (pos 1) (neg 1)
          (neg 1) (pos 2) (neg 2)
          zro (neg 2) (pos 3)

data Diagonal : Type₀ where
  d232 d162 d216 d126 : Diagonal

-- The two target-cokernel classes used by the holonomy witness.  In the
-- coordinates coker(diag(1,2,6)), these are (0,0,1) and (0,1,4).
data FiberClass : Type₀ where
  c001 c014 : FiberClass

data SmithState : Type₀ where
  p0 p1 p2 q0 q1 q2 : SmithState

endpoint : SmithState → Diagonal
endpoint p0 = d232
endpoint p1 = d162
endpoint p2 = d126
endpoint q0 = d232
endpoint q1 = d216
endpoint q2 = d126

-- The path coordinate is retained as state.  At the common endpoint it is
-- the cumulative unimodular transformation, not the Smith diagonal.
leftAction : SmithState → Mat3
leftAction p0 = I3
leftAction p1 = mat3 (neg 1) (pos 1) zro
                     (neg 3) (pos 2) zro
                     zro zro (pos 1)
leftAction p2 = Up
leftAction q0 = I3
leftAction q1 = mat3 (pos 1) zro zro
                     zro (pos 1) (neg 1)
                     zro (neg 2) (pos 3)
leftAction q2 = Uq

transportedClass : SmithState → FiberClass
transportedClass p0 = c001
transportedClass p1 = c001
transportedClass p2 = c001
transportedClass q0 = c001
transportedClass q1 = c001
transportedClass q2 = c014

pStep : SmithState → SmithState
pStep p0 = p1
pStep p1 = p2
pStep x  = x

qStep : SmithState → SmithState
qStep q0 = q1
qStep q1 = q2
qStep x  = x

pExecution qExecution : ℕ → SmithState
pExecution = run p0 pStep
qExecution = run q0 qStep

-- CountedExecution computes both schedules to the same Smith endpoint.
same-endpoint-at-two : endpoint (pExecution 2) ≡ endpoint (qExecution 2)
same-endpoint-at-two = refl

-- It simultaneously retains the distinct presentation changes.
p-action-at-two : leftAction (pExecution 2) ≡ Up
p-action-at-two = refl

q-action-at-two : leftAction (qExecution 2) ≡ Uq
q-action-at-two = refl

classCode : FiberClass → ℕ
classCode c001 = 0
classCode c014 = 1

c001≠c014 : ¬ (c001 ≡ c014)
c001≠c014 path = znots (cong classCode path)

different-fiber-at-two : ¬ (transportedClass (pExecution 2)
                               ≡ transportedClass (qExecution 2))
different-fiber-at-two = c001≠c014

-- Therefore no endpoint-only observation can reproduce both transported
-- classes.  This is the precise boundary on compiling a Smith schedule to
-- its normal diagonal: the endpoint projection is sound only for observables
-- invariant under the schedule holonomy.
no-endpoint-only-readout
  : (read : Diagonal → FiberClass)
  → read (endpoint (pExecution 2)) ≡ transportedClass (pExecution 2)
  → read (endpoint (qExecution 2)) ≡ transportedClass (qExecution 2)
  → ⊥
no-endpoint-only-readout read rp rq =
  c001≠c014 (sym rp ∙ cong read same-endpoint-at-two ∙ rq)

------------------------------------------------------------------------
-- Certification against the library integer-matrix layer (audit gap G1).
--
-- Everything above this line is a finite state table.  Everything below
-- re-reads that table as matrices over the *library's* ℤ and proves, by
-- exact closed computation (every equality is `refl` after entrywise
-- decomposition — certified symbolic computation, no floating point):
--
--   1. for EVERY state s of the automaton, `leftAction s` is a genuine
--      unimodular transformation carrying diag(2,3,2) to the diagonal
--      matrix named by `endpoint s`, with an explicit unimodular right
--      transform: `stepCertificate s : SimRel matA0 (diagMat (endpoint s))`
--      in the sense of Cubical.Algebra.Matrix.CommRingCoefficient, and its
--      transMatL is DEFINITIONALLY `toMat (leftAction s)`;
--   2. the common endpoint diag(1,2,6) is Smith-normal in the library's
--      sense (`isSmithNormal`, i.e. consecutive divisibility 1 ∣ 2 ∣ 6);
--   3. hence both schedules package into inhabitants of the library type
--      `Smith matA0` — the very type produced by the library normalizer
--      `Cubical.Algebra.IntegerMatrix.Smith.smith` — whose left transforms
--      are definitionally the counted execution's
--      `leftAction (pExecution 2)` / `leftAction (qExecution 2)`;
--   4. the holonomy content is real: the relative transport H with
--      H ⋆ Up ≡ Uq is unimodular, it carries the class vector (0,0,1) to
--      (0,1,4) modulo the relation lattice diag(1,2,6)·ℤ³ (explicit lattice
--      correction), and (0,1,4) is NOT congruent to (0,0,1) modulo that
--      lattice (a parity obstruction, proved, not asserted).
--
-- Route note: deriving the table from `smith matA0` itself (route (a) of
-- the G1 fix) is blocked in practice: `smith matA0 .sim .result zero zero`
-- did not reduce within a 550-second budget on the pinned toolchain, and
-- cubical v0.5 leaves uniqueness of the normal form as a TODO
-- (Smith/Normalization.agda:280).  What is certified here is therefore the
-- full defining SPECIFICATION of a Smith normalization (SimRel +
-- isSmithNormal) instantiated by the transcribed data — the transcription
-- is checked against the source's mathematics, not against the source's
-- unnormalized syntax tree.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Sigma using (_×_)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.FinData using (Fin)
  renaming (zero to fzero ; suc to fsuc)
open import Cubical.Data.Int
  using (ℤ ; _+_ ; _·_ ; -_ ; pos0+ ; ·Comm ; injPos ; negsucNotpos)
  renaming (pos to ℤpos ; negsuc to ℤnegsuc)
open import Cubical.Data.Int.Divisibility using (_∣_ ; ∣→∣ℕ)
open import Cubical.Data.Nat.Divisibility using (m∣n→m≤n)
open import Cubical.Data.Nat.Order using (¬m<m)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient
open import Cubical.Algebra.IntegerMatrix.Smith
open import SmithCapability using (normalizeSmith)

open Coefficient ℤCommRing
open Sim
open SimRel
open isSmithNormal
open Smith

-- 3×3 and 3×1 matrices over the library's ℤ, entry by entry.

mk3 : (x00 x01 x02 x10 x11 x12 x20 x21 x22 : ℤ) → Mat 3 3
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 fzero fzero = x00
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 fzero (fsuc fzero) = x01
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 fzero (fsuc (fsuc fzero)) = x02
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc fzero) fzero = x10
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc fzero) (fsuc fzero) = x11
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc fzero) (fsuc (fsuc fzero)) = x12
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc (fsuc fzero)) fzero = x20
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc (fsuc fzero)) (fsuc fzero) = x21
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc (fsuc fzero)) (fsuc (fsuc fzero)) = x22
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 fzero (fsuc (fsuc (fsuc ())))
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc fzero) (fsuc (fsuc (fsuc ())))
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc (fsuc fzero)) (fsuc (fsuc (fsuc ())))
mk3 x00 x01 x02 x10 x11 x12 x20 x21 x22 (fsuc (fsuc (fsuc ()))) _

Col : Type₀
Col = Mat 3 1

mkCol : (a b c : ℤ) → Col
mkCol a b c fzero fzero = a
mkCol a b c (fsuc fzero) fzero = b
mkCol a b c (fsuc (fsuc fzero)) fzero = c
mkCol a b c _ (fsuc ())
mkCol a b c (fsuc (fsuc (fsuc ()))) fzero

-- Matrix equality by one refl on the tuple of entries.  Both sides of the
-- equalities below are closed, so `mat≡ refl` forces Agda to normalize the
-- full integer arithmetic — this is where the actual checking happens.

Row3 : Type₀
Row3 = ℤ × ℤ × ℤ

Nine : Type₀
Nine = Row3 × Row3 × Row3

entriesOf : Mat 3 3 → Nine
entriesOf M =
  (M fzero fzero , M fzero (fsuc fzero) , M fzero (fsuc (fsuc fzero))) ,
  (M (fsuc fzero) fzero , M (fsuc fzero) (fsuc fzero) , M (fsuc fzero) (fsuc (fsuc fzero))) ,
  (M (fsuc (fsuc fzero)) fzero , M (fsuc (fsuc fzero)) (fsuc fzero) , M (fsuc (fsuc fzero)) (fsuc (fsuc fzero)))

fromNine : Nine → Mat 3 3
fromNine v = mk3 (v .fst .fst) (v .fst .snd .fst) (v .fst .snd .snd)
                 (v .snd .fst .fst) (v .snd .fst .snd .fst) (v .snd .fst .snd .snd)
                 (v .snd .snd .fst) (v .snd .snd .snd .fst) (v .snd .snd .snd .snd)

fromNine-entries : (M : Mat 3 3) → fromNine (entriesOf M) ≡ M
fromNine-entries M t i j = entry i j t
  where
  entry : (i j : Fin 3) → fromNine (entriesOf M) i j ≡ M i j
  entry fzero fzero = refl
  entry fzero (fsuc fzero) = refl
  entry fzero (fsuc (fsuc fzero)) = refl
  entry fzero (fsuc (fsuc (fsuc ())))
  entry (fsuc fzero) fzero = refl
  entry (fsuc fzero) (fsuc fzero) = refl
  entry (fsuc fzero) (fsuc (fsuc fzero)) = refl
  entry (fsuc fzero) (fsuc (fsuc (fsuc ())))
  entry (fsuc (fsuc fzero)) fzero = refl
  entry (fsuc (fsuc fzero)) (fsuc fzero) = refl
  entry (fsuc (fsuc fzero)) (fsuc (fsuc fzero)) = refl
  entry (fsuc (fsuc fzero)) (fsuc (fsuc (fsuc ())))
  entry (fsuc (fsuc (fsuc ()))) _

mat≡ : {M N : Mat 3 3} → entriesOf M ≡ entriesOf N → M ≡ N
mat≡ {M} {N} p = sym (fromNine-entries M) ∙ cong fromNine p ∙ fromNine-entries N

colsOf : Col → ℤ × ℤ × ℤ
colsOf v = v fzero fzero , v (fsuc fzero) fzero , v (fsuc (fsuc fzero)) fzero

fromCols : ℤ × ℤ × ℤ → Col
fromCols v = mkCol (v .fst) (v .snd .fst) (v .snd .snd)

fromCols-entries : (v : Col) → fromCols (colsOf v) ≡ v
fromCols-entries v t i j = entry i j t
  where
  entry : (i : Fin 3) (j : Fin 1) → fromCols (colsOf v) i j ≡ v i j
  entry fzero fzero = refl
  entry (fsuc fzero) fzero = refl
  entry (fsuc (fsuc fzero)) fzero = refl
  entry _ (fsuc ())
  entry (fsuc (fsuc (fsuc ()))) fzero

col≡ : {u v : Col} → colsOf u ≡ colsOf v → u ≡ v
col≡ {u} {v} p = sym (fromCols-entries u) ∙ cong fromCols p ∙ fromCols-entries v

-- Decoding the transcription into library matrices.

toℤ : Z → ℤ
toℤ zro     = ℤpos 0
toℤ (pos n) = ℤpos n
toℤ (neg n) = - ℤpos n

toMat : Mat3 → Mat 3 3
toMat M = mk3 (toℤ (a00 M)) (toℤ (a01 M)) (toℤ (a02 M))
              (toℤ (a10 M)) (toℤ (a11 M)) (toℤ (a12 M))
              (toℤ (a20 M)) (toℤ (a21 M)) (toℤ (a22 M))

-- The concrete matrix being normalized, A₀ = diag(2,3,2), and the decoded
-- meaning of each `Diagonal` name.

matA0 : Mat 3 3
matA0 = mk3 (ℤpos 2) (ℤpos 0) (ℤpos 0)
            (ℤpos 0) (ℤpos 3) (ℤpos 0)
            (ℤpos 0) (ℤpos 0) (ℤpos 2)

matD126 : Mat 3 3
matD126 = mk3 (ℤpos 1) (ℤpos 0) (ℤpos 0)
              (ℤpos 0) (ℤpos 2) (ℤpos 0)
              (ℤpos 0) (ℤpos 0) (ℤpos 6)

diagMat : Diagonal → Mat 3 3
diagMat d232 = matA0
diagMat d162 = mk3 (ℤpos 1) (ℤpos 0) (ℤpos 0)
                   (ℤpos 0) (ℤpos 6) (ℤpos 0)
                   (ℤpos 0) (ℤpos 0) (ℤpos 2)
diagMat d216 = mk3 (ℤpos 2) (ℤpos 0) (ℤpos 0)
                   (ℤpos 0) (ℤpos 1) (ℤpos 0)
                   (ℤpos 0) (ℤpos 0) (ℤpos 6)
diagMat d126 = matD126

-- The right transforms and all inverse witnesses.  These are the data the
-- note kept off the page; they are now explicit terms, and every claimed
-- property of them is an equation checked by the type-checker.

rightAction : SmithState → Mat 3 3
rightAction p0 = toMat I3
rightAction p1 = mk3 (ℤpos 1) (ℤnegsuc 2) (ℤpos 0)
                     (ℤpos 1) (ℤnegsuc 1) (ℤpos 0)
                     (ℤpos 0) (ℤpos 0)    (ℤpos 1)
rightAction p2 = mk3 (ℤpos 1) (ℤnegsuc 2) (ℤpos 3)
                     (ℤpos 1) (ℤnegsuc 1) (ℤpos 2)
                     (ℤpos 0) (ℤpos 1)    (ℤpos 0)
rightAction q0 = toMat I3
rightAction q1 = mk3 (ℤpos 1) (ℤpos 0) (ℤpos 0)
                     (ℤpos 0) (ℤpos 1) (ℤpos 2)
                     (ℤpos 0) (ℤpos 1) (ℤpos 3)
rightAction q2 = mk3 (ℤpos 1) (ℤnegsuc 0) (ℤpos 0)
                     (ℤpos 1) (ℤpos 0)    (ℤpos 2)
                     (ℤpos 1) (ℤpos 0)    (ℤpos 3)

leftInverse : SmithState → Mat 3 3
leftInverse p0 = toMat I3
leftInverse p1 = mk3 (ℤpos 2) (ℤnegsuc 0) (ℤpos 0)
                     (ℤpos 3) (ℤnegsuc 0) (ℤpos 0)
                     (ℤpos 0) (ℤpos 0)    (ℤpos 1)
leftInverse p2 = mk3 (ℤpos 2) (ℤnegsuc 2) (ℤpos 1)
                     (ℤpos 3) (ℤnegsuc 2) (ℤpos 1)
                     (ℤpos 0) (ℤpos 1)    (ℤpos 0)
leftInverse q0 = toMat I3
leftInverse q1 = mk3 (ℤpos 1) (ℤpos 0) (ℤpos 0)
                     (ℤpos 0) (ℤpos 3) (ℤpos 1)
                     (ℤpos 0) (ℤpos 2) (ℤpos 1)
leftInverse q2 = mk3 (ℤpos 2) (ℤnegsuc 0) (ℤpos 0)
                     (ℤpos 3) (ℤpos 0)    (ℤpos 1)
                     (ℤpos 2) (ℤpos 0)    (ℤpos 1)

rightInverse : SmithState → Mat 3 3
rightInverse p0 = toMat I3
rightInverse p1 = mk3 (ℤnegsuc 1) (ℤpos 3)    (ℤpos 0)
                      (ℤnegsuc 0) (ℤpos 1)    (ℤpos 0)
                      (ℤpos 0)    (ℤpos 0)    (ℤpos 1)
rightInverse p2 = mk3 (ℤnegsuc 1) (ℤpos 3)    (ℤpos 0)
                      (ℤpos 0)    (ℤpos 0)    (ℤpos 1)
                      (ℤpos 1)    (ℤnegsuc 0) (ℤpos 1)
rightInverse q0 = toMat I3
rightInverse q1 = mk3 (ℤpos 1) (ℤpos 0)    (ℤpos 0)
                      (ℤpos 0) (ℤpos 3)    (ℤnegsuc 1)
                      (ℤpos 0) (ℤnegsuc 0) (ℤpos 1)
rightInverse q2 = mk3 (ℤpos 0)    (ℤpos 3)    (ℤnegsuc 1)
                      (ℤnegsuc 0) (ℤpos 3)    (ℤnegsuc 1)
                      (ℤpos 0)    (ℤnegsuc 0) (ℤpos 1)

-- The five closed-computation lemmas.  Each `mat≡ refl` is a 9-entry
-- integer-arithmetic identity checked by normalization.

certEq : (s : SmithState)
       → diagMat (endpoint s) ≡ toMat (leftAction s) ⋆ matA0 ⋆ rightAction s
certEq p0 = mat≡ refl
certEq p1 = mat≡ refl
certEq p2 = mat≡ refl
certEq q0 = mat≡ refl
certEq q1 = mat≡ refl
certEq q2 = mat≡ refl

certL : (s : SmithState) → toMat (leftAction s) ⋆ leftInverse s ≡ 𝟙
certL p0 = mat≡ refl
certL p1 = mat≡ refl
certL p2 = mat≡ refl
certL q0 = mat≡ refl
certL q1 = mat≡ refl
certL q2 = mat≡ refl

certL' : (s : SmithState) → leftInverse s ⋆ toMat (leftAction s) ≡ 𝟙
certL' p0 = mat≡ refl
certL' p1 = mat≡ refl
certL' p2 = mat≡ refl
certL' q0 = mat≡ refl
certL' q1 = mat≡ refl
certL' q2 = mat≡ refl

certR : (s : SmithState) → rightAction s ⋆ rightInverse s ≡ 𝟙
certR p0 = mat≡ refl
certR p1 = mat≡ refl
certR p2 = mat≡ refl
certR q0 = mat≡ refl
certR q1 = mat≡ refl
certR q2 = mat≡ refl

certR' : (s : SmithState) → rightInverse s ⋆ rightAction s ≡ 𝟙
certR' p0 = mat≡ refl
certR' p1 = mat≡ refl
certR' p2 = mat≡ refl
certR' q0 = mat≡ refl
certR' q1 = mat≡ refl
certR' q2 = mat≡ refl

-- (1) The per-state binding theorem: every row of the transcription is a
-- similarity certificate over ℤ in the library's sense, and its left
-- transform is DEFINITIONALLY the table entry `leftAction s`.

stepCertificate : (s : SmithState) → SimRel matA0 (diagMat (endpoint s))
stepCertificate s .transMatL = toMat (leftAction s)
stepCertificate s .transMatR = rightAction s
stepCertificate s .transEq = certEq s
stepCertificate s .isInvTransL = leftInverse s , certL s , certL' s
stepCertificate s .isInvTransR = rightInverse s , certR s , certR' s

stepCertificate-binds-table
  : (s : SmithState) → stepCertificate s .transMatL ≡ toMat (leftAction s)
stepCertificate-binds-table s = refl

-- (2) The endpoint diag(1,2,6) is Smith-normal in the library's sense:
-- nonzero consecutive divisibility 1 ∣ 2 ∣ 6, exhibited, not named.

private
  nonZeroPos : (n : ℕ) → ¬ ℤpos (suc n) ≡ ℤpos 0
  nonZeroPos n p = snotz (injPos p)

  one∣two : ℤpos 1 ∣ ℤpos 2
  one∣two = ∣ ℤpos 2 , refl ∣₁

  one∣six : ℤpos 1 ∣ ℤpos 6
  one∣six = ∣ ℤpos 6 , refl ∣₁

  two∣six : ℤpos 2 ∣ ℤpos 6
  two∣six = ∣ ℤpos 3 , refl ∣₁

matD126-isSmithNormal : isSmithNormal matD126
matD126-isSmithNormal .divs =
  (ℤpos 1 ∷ ℤpos 2 ∷ ℤpos 6 ∷ []) ,
  (one∣two , one∣six , nonZeroPos 0) ,
  (two∣six , nonZeroPos 1) ,
  (nonZeroPos 5 , tt)
matD126-isSmithNormal .rowNull = 0
matD126-isSmithNormal .colNull = 0
matD126-isSmithNormal .rowEq = refl
matD126-isSmithNormal .colEq = refl
matD126-isSmithNormal .matEq = mat≡ refl

-- (3) Both counted schedules package into the library's `Smith matA0` —
-- the type of `smith matA0` itself (`libraryProducer` below) — with the
-- executed table entries as their transforms, definitionally.

pScheduleSmith : Smith matA0
pScheduleSmith .sim .result = matD126
pScheduleSmith .sim .simrel = stepCertificate p2
pScheduleSmith .isnormal = matD126-isSmithNormal

qScheduleSmith : Smith matA0
qScheduleSmith .sim .result = matD126
qScheduleSmith .sim .simrel = stepCertificate q2
qScheduleSmith .isnormal = matD126-isSmithNormal

libraryProducer : Smith matA0
libraryProducer = normalizeSmith matA0

pSmith-binds-execution
  : pScheduleSmith .sim .simrel .transMatL ≡ toMat (leftAction (pExecution 2))
pSmith-binds-execution = refl

qSmith-binds-execution
  : qScheduleSmith .sim .simrel .transMatL ≡ toMat (leftAction (qExecution 2))
qSmith-binds-execution = refl

pSmith-binds-endpoint
  : pScheduleSmith .sim .result ≡ diagMat (endpoint (pExecution 2))
pSmith-binds-endpoint = refl

qSmith-binds-endpoint
  : qScheduleSmith .sim .result ≡ diagMat (endpoint (qExecution 2))
qSmith-binds-endpoint = refl

-- `same-endpoint-at-two`, upgraded from a table lookup to actual matrices.

same-endpoint-real : diagMat (endpoint (pExecution 2)) ≡ diagMat (endpoint (qExecution 2))
same-endpoint-real = refl

-- ... while the executed presentation changes differ as integer matrices
-- (entry (0,0) is -1 versus 0), so the holonomy is real, not nominal.

actions-differ-real
  : ¬ (toMat (leftAction (pExecution 2)) ≡ toMat (leftAction (qExecution 2)))
actions-differ-real p = negsucNotpos 0 0 (λ t → p t fzero fzero)

-- (4) The transported-class table certified.  H is the relative left
-- transport U_q · U_p⁻¹ of notes/SMITH_PATH_HOLONOMY.md (4); here it is
-- pinned down by the checked equation H ⋆ Up ≡ Uq plus unimodularity.

matH : Mat 3 3
matH = mk3 (ℤpos 3)    (ℤnegsuc 3) (ℤpos 1)
           (ℤpos 4)    (ℤnegsuc 4) (ℤpos 1)
           (ℤnegsuc 5) (ℤpos 9)    (ℤnegsuc 1)

holonomy-factors : matH ⋆ toMat (leftAction (pExecution 2)) ≡ toMat (leftAction (qExecution 2))
holonomy-factors = mat≡ refl

holonomy-unimodular : isInv matH
holonomy-unimodular =
  mk3 (ℤpos 1) (ℤpos 1)    (ℤpos 1)
      (ℤpos 2) (ℤpos 0)    (ℤpos 1)
      (ℤpos 6) (ℤnegsuc 2) (ℤpos 1)
  , mat≡ refl , mat≡ refl

-- The enum names c001 / c014 decoded as actual vectors, and the claimed
-- transport realized: H carries (0,0,1) to (0,1,4) up to an EXPLICIT
-- element of the relation lattice diag(1,2,6)·ℤ³.

classVector : FiberClass → Col
classVector c001 = mkCol (ℤpos 0) (ℤpos 0) (ℤpos 1)
classVector c014 = mkCol (ℤpos 0) (ℤpos 1) (ℤpos 4)

_+col_ : Col → Col → Col
(u +col v) i j = u i j + v i j

holonomy-transports-classes
  : matH ⋆ classVector (transportedClass (pExecution 2))
  ≡ classVector (transportedClass (qExecution 2))
     +col (matD126 ⋆ mkCol (ℤpos 1) (ℤpos 0) (ℤnegsuc 0))
holonomy-transports-classes = col≡ refl

-- ... and the two classes are genuinely distinct in coker(diag(1,2,6)):
-- their difference has odd second coordinate, but every element of the
-- relation lattice has second coordinate 2·k.  This replaces the fiat
-- distinctness of the two enum constructors with a parity obstruction.

private
  ¬two∣one : ¬ (ℤpos 2 ∣ ℤpos 1)
  ¬two∣one d = ¬m<m (m∣n→m≤n snotz (∣→∣ℕ d))

classes-differ-in-coker
  : ¬ (Σ Col (λ k → classVector (transportedClass (qExecution 2))
               ≡ classVector (transportedClass (pExecution 2)) +col (matD126 ⋆ k)))
classes-differ-in-coker (k , p) =
  ¬two∣one ∣ b , ·Comm b (ℤpos 2) ∙ sym oneEq ∣₁
  where
  b : ℤ
  b = k (fsuc fzero) fzero

  oneEq : ℤpos 1 ≡ b + b
  oneEq = (λ t → p t (fsuc fzero) fzero)
        ∙ sym (pos0+ (ℤpos 0 + (b + b)))
        ∙ sym (pos0+ (b + b))
