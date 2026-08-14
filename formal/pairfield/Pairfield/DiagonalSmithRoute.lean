import Pairfield.GeneralSmith2x2

/-!
# Positive diagonal Smith routing

The condition `a ∤ b` does not determine one next action for a positive
diagonal matrix.  If `b ∣ a`, paired row and column swaps already put the
diagonal into Smith order.  Only mutual nondivisibility rules out both the
identity ordering and its swap.

This file turns that distinction into an executable dispatcher.  The ordered
branch emits the identity certificate, the reverse-ordered branch emits the
paired-swap certificate, and the incomparable branch delegates to the existing
total Smith producer.  It therefore changes the next computation without
duplicating the Euclidean reducer.
-/

namespace Pairfield

/-- The three exact action classes for a positive diagonal endpoint. -/
inductive PositiveDiagonalRoute
  | alreadySmith
  | swapToSmith
  | nontrivialJoin
  deriving DecidableEq, Repr

/-- Divisibility, reverse divisibility, and mutual nondivisibility select the
next checked action in that order. -/
def positiveDiagonalRoute (a b : Nat) : PositiveDiagonalRoute :=
  if a ∣ b then .alreadySmith
  else if b ∣ a then .swapToSmith
  else .nontrivialJoin

@[simp] theorem positiveDiagonalRoute_alreadySmith_iff (a b : Nat) :
    positiveDiagonalRoute a b = .alreadySmith ↔ a ∣ b := by
  by_cases hab : a ∣ b <;> by_cases hba : b ∣ a <;>
    simp [positiveDiagonalRoute, hab, hba]

@[simp] theorem positiveDiagonalRoute_swapToSmith_iff (a b : Nat) :
    positiveDiagonalRoute a b = .swapToSmith ↔ ¬ a ∣ b ∧ b ∣ a := by
  by_cases hab : a ∣ b <;> by_cases hba : b ∣ a <;>
    simp [positiveDiagonalRoute, hab, hba]

@[simp] theorem positiveDiagonalRoute_nontrivialJoin_iff (a b : Nat) :
    positiveDiagonalRoute a b = .nontrivialJoin ↔ ¬ a ∣ b ∧ ¬ b ∣ a := by
  by_cases hab : a ∣ b <;> by_cases hba : b ∣ a <;>
    simp [positiveDiagonalRoute, hab, hba]

def positiveDiagonal (a b : Nat) : IntMat2 :=
  IntMat2.diagonal (a : Int) (b : Int)

/-- Paired row and column swaps reverse a diagonal exactly. -/
theorem IntMat2.swap_diagonal (a b : Int) :
    swap * diagonal a b * swap = diagonal b a := by
  apply IntMat2.ext <;>
    simp [IntMat2.mul_def, IntMat2.mul, swap, diagonal]

/-- The identity action, packaged in the common independently checkable
certificate language. -/
def positiveDiagonalIdentityCertificate (a b : Nat) : SmithCertificate2 :=
  ⟨positiveDiagonal a b, .one, a, b, .one⟩

/-- The reverse-divisibility action: conjugate by the swap matrix. -/
def positiveDiagonalSwapCertificate (a b : Nat) : SmithCertificate2 :=
  ⟨positiveDiagonal a b, .swap, b, a, .swap⟩

theorem positiveDiagonalIdentityCertificate_valid {a b : Nat}
    (ha : 0 < a) (hab : a ∣ b) :
    (positiveDiagonalIdentityCertificate a b).Valid := by
  unfold SmithCertificate2.Valid SmithCertificate2.diagonal
  dsimp [positiveDiagonalIdentityCertificate, positiveDiagonal]
  refine ⟨?_, by decide, by decide, by omega, by omega, ?_,
    Int.natCast_dvd_natCast.mpr hab⟩
  · rw [IntMat2.one_mul, IntMat2.mul_one]
  · omega

theorem positiveDiagonalSwapCertificate_valid {a b : Nat}
    (hb : 0 < b) (hba : b ∣ a) :
    (positiveDiagonalSwapCertificate a b).Valid := by
  unfold SmithCertificate2.Valid SmithCertificate2.diagonal
  dsimp [positiveDiagonalSwapCertificate, positiveDiagonal]
  refine ⟨?_, IntMat2.swap_unimodular, IntMat2.swap_unimodular,
    by omega, by omega, ?_, Int.natCast_dvd_natCast.mpr hba⟩
  · exact (IntMat2.swap_diagonal (a : Int) (b : Int)).symm
  · omega

/-- Execute the action selected by `positiveDiagonalRoute`.  The first two
branches are closed-form; only the mutually nondividing branch invokes the
general Euclidean producer. -/
def positiveDiagonalCertificate (a b : Nat) : SmithCertificate2 :=
  if a ∣ b then positiveDiagonalIdentityCertificate a b
  else if b ∣ a then positiveDiagonalSwapCertificate a b
  else smithCertificate (positiveDiagonal a b)

theorem positiveDiagonalCertificate_valid {a b : Nat}
    (ha : 0 < a) (hb : 0 < b) :
    (positiveDiagonalCertificate a b).Valid := by
  unfold positiveDiagonalCertificate
  split
  · exact positiveDiagonalIdentityCertificate_valid ha ‹a ∣ b›
  · split
    · exact positiveDiagonalSwapCertificate_valid hb ‹b ∣ a›
    · exact smithCertificate_valid _

theorem positiveDiagonalCertificate_check {a b : Nat}
    (ha : 0 < a) (hb : 0 < b) :
    (positiveDiagonalCertificate a b).check = true :=
  SmithCertificate2.check_complete _
    (positiveDiagonalCertificate_valid ha hb)

theorem positiveDiagonalCertificate_of_swapRoute {a b : Nat}
    (h : positiveDiagonalRoute a b = .swapToSmith) :
    positiveDiagonalCertificate a b = positiveDiagonalSwapCertificate a b := by
  rw [positiveDiagonalRoute_swapToSmith_iff] at h
  simp [positiveDiagonalCertificate, h.1, h.2]

theorem positiveDiagonalCertificate_of_joinRoute {a b : Nat}
    (h : positiveDiagonalRoute a b = .nontrivialJoin) :
    positiveDiagonalCertificate a b = smithCertificate (positiveDiagonal a b) := by
  rw [positiveDiagonalRoute_nontrivialJoin_iff] at h
  simp [positiveDiagonalCertificate, h.1, h.2]

/-! Exact controls.  The first is the killed blanket criterion; the second is
the surviving mutually nondividing branch. -/

example : ¬ (6 : Nat) ∣ 2 := by decide
example : positiveDiagonalRoute 6 2 = .swapToSmith := by decide
example : (positiveDiagonalCertificate 6 2).check = true :=
  positiveDiagonalCertificate_check (by decide) (by decide)

example : positiveDiagonalRoute 6 10 = .nontrivialJoin := by decide
example : (positiveDiagonalCertificate 6 10).check = true :=
  positiveDiagonalCertificate_check (by decide) (by decide)

end Pairfield
