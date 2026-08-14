import Pairfield.SmithPresentation
import Mathlib.Data.Int.Basic

/-!
# A total executable 2×2 integer Smith producer, proved correct in Lean

`SmithCertificate.lean` supplies the checker and proves it sound and complete;
`SmithPresentation.lean` supplies composable exact presentation arrows.  What
was missing (`notes/FORMAL_CAPABILITY_GRAPH.md`, first open typed joint) is the
**producer**: a total function taking an arbitrary integral `2×2` matrix to a
Smith presentation, together with a proof that its certificate is accepted.

This file closes that joint.  `smith A` runs an elementary-operation descent
whose termination is proved by a well-founded measure, and
`smithCertificate_valid` proves that every emitted certificate satisfies the
same `Valid` predicate the untrusted-producer gate checks.

Consequences.

* The certificate stays small and independently replayable: nothing about the
  descent leaks into the checked object.
* The checker no longer has to be *used*: `smithCertificate_valid` is a
  universally quantified theorem, so downstream capabilities may consume the
  producer directly.  The gate remains available for foreign producers.
* Native execution is `#eval smith A` through the Lean compiler; kernel
  verification of a single instance remains available through `decide` on the
  certificate.  The three modes — compute, check, prove — are now all
  executable on one object.
-/

namespace Pairfield

namespace IntMat2

/-- Used on the left, `euclidStep q` performs `R₁ ← R₁ - q R₂` and then swaps
the two rows.  Used on the right it performs `C₁ ← C₁ - q C₂` and then swaps
the two columns.  One matrix serves both because the composite is symmetric. -/
def euclidStep (q : Int) : IntMat2 := ⟨0, 1, 1, -q⟩

/-- Row swap (on the left) or column swap (on the right). -/
def swap : IntMat2 := ⟨0, 1, 1, 0⟩

/-- On the right, `shear q` performs `C₂ ← C₂ - q C₁`. -/
def shear (q : Int) : IntMat2 := ⟨1, -q, 0, 1⟩

/-- On the left, `addRows` performs `R₁ ← R₁ + R₂`. -/
def addRows : IntMat2 := ⟨1, 1, 0, 1⟩

/-- Diagonal sign normalization. -/
def signFix (d e : Int) : IntMat2 :=
  ⟨if d < 0 then -1 else 1, 0, 0, if e < 0 then -1 else 1⟩

theorem euclidStep_unimodular (q : Int) : (euclidStep q).unimodular := by
  simp [unimodular, det, euclidStep]

theorem swap_unimodular : swap.unimodular := by decide

theorem shear_unimodular (q : Int) : (shear q).unimodular := by
  simp [unimodular, det, shear]

theorem addRows_unimodular : addRows.unimodular := by decide

theorem signFix_unimodular (d e : Int) : (signFix d e).unimodular := by
  unfold unimodular det signFix
  split_ifs <;> decide

end IntMat2

/-! ## Reductions: an exact presentation arrow with its target carried -/

/-- `Reduction A` is `Σ B, SmithPresentation A B`: a target together with the
unimodular transformations realizing it.  Carrying the target as a field (not
as an index) is what makes well-founded recursion on matrices practical. -/
structure Reduction (A : IntMat2) where
  left : IntMat2
  right : IntMat2
  target : IntMat2
  replay : target = left * A * right
  left_unimodular : left.unimodular
  right_unimodular : right.unimodular

namespace Reduction

/-- Non-dependent replay composition; stating it separately avoids rewriting
underneath a type that mentions the intermediate matrix. -/
theorem replay_comp (A L₁ R₁ B L₂ R₂ D : IntMat2)
    (h₁ : B = L₁ * A * R₁) (h₂ : D = L₂ * B * R₂) :
    D = (L₂ * L₁) * A * (R₁ * R₂) := by
  subst h₁
  subst h₂
  simp only [IntMat2.mul_assoc]

def id (A : IntMat2) : Reduction A where
  left := .one
  right := .one
  target := A
  replay := by rw [IntMat2.one_mul, IntMat2.mul_one]
  left_unimodular := by decide
  right_unimodular := by decide

/-- One left-multiplication step. -/
def byLeft (A L : IntMat2) (hL : L.unimodular) : Reduction A where
  left := L
  right := .one
  target := L * A
  replay := by rw [IntMat2.mul_one]
  left_unimodular := hL
  right_unimodular := by decide

/-- One right-multiplication step. -/
def byRight (A R : IntMat2) (hR : R.unimodular) : Reduction A where
  left := .one
  right := R
  target := A * R
  replay := by rw [IntMat2.one_mul]
  left_unimodular := by decide
  right_unimodular := hR

/-- Temporal composition of two presentation arrows. -/
def trans {A : IntMat2} (r : Reduction A) (s : Reduction r.target) :
    Reduction A where
  left := s.left * r.left
  right := r.right * s.right
  target := s.target
  replay :=
    replay_comp A r.left r.right r.target s.left s.right s.target
      r.replay s.replay
  left_unimodular :=
    IntMat2.unimodular_mul s.left_unimodular r.left_unimodular
  right_unimodular :=
    IntMat2.unimodular_mul r.right_unimodular s.right_unimodular

@[simp] theorem trans_target {A : IntMat2} (r : Reduction A)
    (s : Reduction r.target) : (r.trans s).target = s.target := rfl

end Reduction

/-! ## Euclidean descent in one column, then in one row -/

/-- Output of the column descent: the lower-left entry is zero and the pivot's
absolute value is exactly the gcd of the original first column. -/
structure ColumnCleared (A : IntMat2) where
  red : Reduction A
  lower_zero : red.target.a10 = 0
  pivot : red.target.a00.natAbs = Int.gcd A.a00 A.a10

/-- Output of the row descent, dual to `ColumnCleared`. -/
structure RowCleared (A : IntMat2) where
  red : Reduction A
  upper_zero : red.target.a01 = 0
  pivot : red.target.a00.natAbs = Int.gcd A.a00 A.a01

theorem euclidStep_left_a00 (q : Int) (A : IntMat2) :
    (IntMat2.euclidStep q * A).a00 = A.a10 := by
  simp [IntMat2.mul_def, IntMat2.mul, IntMat2.euclidStep]

theorem euclidStep_left_a10 (q : Int) (A : IntMat2) :
    (IntMat2.euclidStep q * A).a10 = A.a00 - q * A.a10 := by
  simp [IntMat2.mul_def, IntMat2.mul, IntMat2.euclidStep]
  ring

theorem euclidStep_right_a00 (q : Int) (A : IntMat2) :
    (A * IntMat2.euclidStep q).a00 = A.a01 := by
  simp [IntMat2.mul_def, IntMat2.mul, IntMat2.euclidStep]

theorem euclidStep_right_a01 (q : Int) (A : IntMat2) :
    (A * IntMat2.euclidStep q).a01 = A.a00 - q * A.a01 := by
  simp [IntMat2.mul_def, IntMat2.mul, IntMat2.euclidStep]
  ring

theorem sub_ediv_mul (a b : Int) : a - a / b * b = a % b := by
  rw [Int.emod_def]; ring

theorem descent_measure {a b : Int} (h : b ≠ 0) : (a % b).natAbs < b.natAbs := by
  have h₁ : 0 ≤ a % b := Int.emod_nonneg a h
  have h₂ : a % b < (b.natAbs : Int) := Int.emod_lt a h
  omega

/-- Column Euclidean descent.  Terminates on `|a₁₀|`. -/
def clearColumn (A : IntMat2) : ColumnCleared A :=
  if h : A.a10 = 0 then
    { red := Reduction.id A
      lower_zero := h
      pivot := by
        show A.a00.natAbs = Int.gcd A.a00 A.a10
        rw [h, Int.gcd_zero_right] }
  else
    let q : Int := A.a00 / A.a10
    let step : Reduction A :=
      Reduction.byLeft A (IntMat2.euclidStep q) (IntMat2.euclidStep_unimodular q)
    have hentry : step.target.a10 = A.a00 % A.a10 := by
      show (IntMat2.euclidStep q * A).a10 = A.a00 % A.a10
      rw [euclidStep_left_a10]
      exact sub_ediv_mul A.a00 A.a10
    have hdec : step.target.a10.natAbs < A.a10.natAbs := by
      rw [hentry]; exact descent_measure h
    let rest := clearColumn step.target
    { red := step.trans rest.red
      lower_zero := rest.lower_zero
      pivot := by
        rw [Reduction.trans_target, rest.pivot]
        have h0 : step.target.a00 = A.a10 := euclidStep_left_a00 q A
        rw [h0, hentry, Int.gcd_comm, Int.gcd_emod] }
termination_by A.a10.natAbs
decreasing_by exact hdec

/-- Row Euclidean descent.  Terminates on `|a₀₁|`. -/
def clearRow (A : IntMat2) : RowCleared A :=
  if h : A.a01 = 0 then
    { red := Reduction.id A
      upper_zero := h
      pivot := by
        show A.a00.natAbs = Int.gcd A.a00 A.a01
        rw [h, Int.gcd_zero_right] }
  else
    let q : Int := A.a00 / A.a01
    let step : Reduction A :=
      Reduction.byRight A (IntMat2.euclidStep q) (IntMat2.euclidStep_unimodular q)
    have hentry : step.target.a01 = A.a00 % A.a01 := by
      show (A * IntMat2.euclidStep q).a01 = A.a00 % A.a01
      rw [euclidStep_right_a01]
      exact sub_ediv_mul A.a00 A.a01
    have hdec : step.target.a01.natAbs < A.a01.natAbs := by
      rw [hentry]; exact descent_measure h
    let rest := clearRow step.target
    { red := step.trans rest.red
      upper_zero := rest.upper_zero
      pivot := by
        rw [Reduction.trans_target, rest.pivot]
        have h0 : step.target.a00 = A.a01 := euclidStep_right_a00 q A
        rw [h0, hentry, Int.gcd_comm, Int.gcd_emod] }
termination_by A.a01.natAbs
decreasing_by exact hdec

/-! ## Arithmetic side conditions -/

theorem gcd_pos_of_left {a b : Int} (h : a ≠ 0) : 0 < Int.gcd a b :=
  Nat.pos_of_ne_zero fun hz => by
    have hdvd : Int.gcd a b ∣ a.natAbs := Int.gcd_dvd_natAbs_left a b
    rw [hz] at hdvd
    have := Nat.eq_zero_of_zero_dvd hdvd
    omega

theorem gcd_le_of_left {a b : Int} (h : a ≠ 0) : Int.gcd a b ≤ a.natAbs :=
  Int.gcd_le_natAbs_left b h

theorem gcd_lt_of_not_dvd {a b : Int} (h : a ≠ 0) (hnd : ¬ a ∣ b) :
    Int.gcd a b < a.natAbs := by
  rcases lt_or_eq_of_le (gcd_le_of_left (b := b) h) with hlt | heq
  · exact hlt
  · exfalso
    apply hnd
    have hd : Int.gcd a b ∣ b.natAbs := Int.gcd_dvd_natAbs_right a b
    rw [heq] at hd
    exact Int.natAbs_dvd_natAbs.mp hd

theorem signFix_entry (d : Int) :
    (if d < 0 then (-1 : Int) else 1) * d = (d.natAbs : Int) := by
  by_cases h : d < 0
  · rw [if_pos h]; omega
  · rw [if_neg h]; omega

/-- Kill the upper-right entry of a matrix whose lower-left entry is already
zero and whose pivot divides it. -/
theorem shear_kills (B : IntMat2) (hne : B.a00 ≠ 0) (hlow : B.a10 = 0)
    (hdvd : B.a00 ∣ B.a01) :
    B * IntMat2.shear (B.a01 / B.a00) = IntMat2.diagonal B.a00 B.a11 := by
  have hkill : B.a00 * -(B.a01 / B.a00) + B.a01 = 0 := by
    obtain ⟨k, hk⟩ := hdvd
    rw [hk, Int.mul_ediv_cancel_left _ hne]
    ring
  apply IntMat2.ext
  · show B.a00 * 1 + B.a01 * 0 = B.a00
    ring
  · show B.a00 * -(B.a01 / B.a00) + B.a01 * 1 = 0
    rw [mul_one]
    exact hkill
  · show B.a10 * 1 + B.a11 * 0 = 0
    rw [hlow]
    ring
  · show B.a10 * -(B.a01 / B.a00) + B.a11 * 1 = B.a11
    rw [hlow]
    ring

/-- `R₁ ← R₁ + R₂` on a diagonal matrix exposes the second invariant in the
upper-right slot, which is where the Euclidean descent can see it. -/
theorem addRows_diagonal (d e : Int) :
    IntMat2.addRows * IntMat2.diagonal d e = ⟨d, e, 0, e⟩ := by
  apply IntMat2.ext <;>
    simp [IntMat2.mul_def, IntMat2.mul, IntMat2.addRows, IntMat2.diagonal]

theorem signFix_diagonal (d e : Int) :
    IntMat2.signFix d e * IntMat2.diagonal d e
      = IntMat2.diagonal (d.natAbs : Int) (e.natAbs : Int) := by
  apply IntMat2.ext <;>
    simp [IntMat2.mul_def, IntMat2.mul, IntMat2.signFix, IntMat2.diagonal]
  · simpa using signFix_entry d
  · simpa using signFix_entry e

/-! ## The main descent -/

/-- A completed Smith presentation with the normal-form side conditions. -/
structure SmithResult (A : IntMat2) where
  red : Reduction A
  d₁ : Int
  d₂ : Int
  normal : red.target = IntMat2.diagonal d₁ d₂
  nonneg₁ : 0 ≤ d₁
  nonneg₂ : 0 ≤ d₂
  zero_zero : d₁ = 0 → d₂ = 0
  divides : d₁ ∣ d₂

/-- The nonzero-pivot stratum additionally certifies a positive first
invariant, which is what keeps the descent measure meaningful. -/
structure SmithCore (A : IntMat2) where
  res : SmithResult A
  pos : 0 < res.d₁

/-- The nonzero-pivot descent.  Measure: `|a₀₀|`. -/
def smithCore (A : IntMat2) (hA : A.a00 ≠ 0) : SmithCore A :=
  let c := clearColumn A
  let B := c.red.target
  have hBpivot : B.a00.natAbs = Int.gcd A.a00 A.a10 := c.pivot
  have hBne : B.a00 ≠ 0 := by
    have hp := gcd_pos_of_left (a := A.a00) (b := A.a10) hA
    omega
  have hBle : B.a00.natAbs ≤ A.a00.natAbs := by
    rw [hBpivot]; exact gcd_le_of_left hA
  if hdvd : B.a00 ∣ B.a01 then
    let sh := Reduction.byRight B (IntMat2.shear (B.a01 / B.a00))
      (IntMat2.shear_unimodular _)
    have hsh : sh.target = IntMat2.diagonal B.a00 B.a11 :=
      shear_kills B hBne c.lower_zero hdvd
    if hdvd2 : B.a00 ∣ B.a11 then
      let sg := Reduction.byLeft sh.target (IntMat2.signFix B.a00 B.a11)
        (IntMat2.signFix_unimodular _ _)
      { res :=
          { red := (c.red.trans sh).trans sg
            d₁ := (B.a00.natAbs : Int)
            d₂ := (B.a11.natAbs : Int)
            normal := by
              show IntMat2.signFix B.a00 B.a11 * sh.target
                = IntMat2.diagonal (B.a00.natAbs : Int) (B.a11.natAbs : Int)
              rw [hsh]
              exact signFix_diagonal B.a00 B.a11
            nonneg₁ := Int.natCast_nonneg _
            nonneg₂ := Int.natCast_nonneg _
            zero_zero := by omega
            divides := Int.natCast_dvd_natCast.mpr
              (Int.natAbs_dvd_natAbs.mpr hdvd2) }
        pos := by
          show (0 : Int) < (B.a00.natAbs : Int)
          omega }
    else
      let ad := Reduction.byLeft sh.target IntMat2.addRows
        IntMat2.addRows_unimodular
      have hadd : ad.target = ⟨B.a00, B.a11, 0, B.a11⟩ := by
        show IntMat2.addRows * sh.target = _
        rw [hsh]
        exact addRows_diagonal _ _
      let r := clearRow ad.target
      have hgcd : Int.gcd ad.target.a00 ad.target.a01 = Int.gcd B.a00 B.a11 := by
        rw [hadd]
      have hr : r.red.target.a00.natAbs = Int.gcd B.a00 B.a11 :=
        r.pivot.trans hgcd
      have hrne : r.red.target.a00 ≠ 0 := by
        have hp := gcd_pos_of_left (a := B.a00) (b := B.a11) hBne
        omega
      have hdec : r.red.target.a00.natAbs < A.a00.natAbs := by
        rw [hr]
        exact lt_of_lt_of_le (gcd_lt_of_not_dvd hBne hdvd2) hBle
      let s := smithCore r.red.target hrne
      { res :=
          { red := (((c.red.trans sh).trans ad).trans r.red).trans s.res.red
            d₁ := s.res.d₁
            d₂ := s.res.d₂
            normal := s.res.normal
            nonneg₁ := s.res.nonneg₁
            nonneg₂ := s.res.nonneg₂
            zero_zero := s.res.zero_zero
            divides := s.res.divides }
        pos := s.pos }
  else
    let r := clearRow B
    have hr : r.red.target.a00.natAbs = Int.gcd B.a00 B.a01 := r.pivot
    have hrne : r.red.target.a00 ≠ 0 := by
      have hp := gcd_pos_of_left (a := B.a00) (b := B.a01) hBne
      omega
    have hdec : r.red.target.a00.natAbs < A.a00.natAbs := by
      rw [hr]
      exact lt_of_lt_of_le (gcd_lt_of_not_dvd hBne hdvd) hBle
    let s := smithCore r.red.target hrne
    { res :=
        { red := (c.red.trans r.red).trans s.res.red
          d₁ := s.res.d₁
          d₂ := s.res.d₂
          normal := s.res.normal
          nonneg₁ := s.res.nonneg₁
          nonneg₂ := s.res.nonneg₂
          zero_zero := s.res.zero_zero
          divides := s.res.divides }
      pos := s.pos }
termination_by A.a00.natAbs
decreasing_by
  · exact hdec
  · exact hdec

/-- The total producer: pivot a nonzero entry into position, then descend. -/
def smith (A : IntMat2) : SmithResult A :=
  if h00 : A.a00 ≠ 0 then (smithCore A h00).res
  else if h10 : A.a10 ≠ 0 then
    let p := Reduction.byLeft A IntMat2.swap IntMat2.swap_unimodular
    have hp : p.target.a00 ≠ 0 := by
      show (IntMat2.swap * A).a00 ≠ 0
      simpa [IntMat2.mul_def, IntMat2.mul, IntMat2.swap] using h10
    let s := smithCore p.target hp
    { red := p.trans s.res.red
      d₁ := s.res.d₁
      d₂ := s.res.d₂
      normal := s.res.normal
      nonneg₁ := s.res.nonneg₁
      nonneg₂ := s.res.nonneg₂
      zero_zero := s.res.zero_zero
      divides := s.res.divides }
  else if h01 : A.a01 ≠ 0 then
    let p := Reduction.byRight A IntMat2.swap IntMat2.swap_unimodular
    have hp : p.target.a00 ≠ 0 := by
      show (A * IntMat2.swap).a00 ≠ 0
      simpa [IntMat2.mul_def, IntMat2.mul, IntMat2.swap] using h01
    let s := smithCore p.target hp
    { red := p.trans s.res.red
      d₁ := s.res.d₁
      d₂ := s.res.d₂
      normal := s.res.normal
      nonneg₁ := s.res.nonneg₁
      nonneg₂ := s.res.nonneg₂
      zero_zero := s.res.zero_zero
      divides := s.res.divides }
  else if h11 : A.a11 ≠ 0 then
    let p : Reduction A :=
      { left := IntMat2.swap
        right := IntMat2.swap
        target := IntMat2.swap * A * IntMat2.swap
        replay := rfl
        left_unimodular := IntMat2.swap_unimodular
        right_unimodular := IntMat2.swap_unimodular }
    have hp : p.target.a00 ≠ 0 := by
      show (IntMat2.swap * A * IntMat2.swap).a00 ≠ 0
      simpa [IntMat2.mul_def, IntMat2.mul, IntMat2.swap] using h11
    let s := smithCore p.target hp
    { red := p.trans s.res.red
      d₁ := s.res.d₁
      d₂ := s.res.d₂
      normal := s.res.normal
      nonneg₁ := s.res.nonneg₁
      nonneg₂ := s.res.nonneg₂
      zero_zero := s.res.zero_zero
      divides := s.res.divides }
  else
    { red := Reduction.id A
      d₁ := 0
      d₂ := 0
      normal := by
        have e00 : A.a00 = 0 := by omega
        have e01 : A.a01 = 0 := by omega
        have e10 : A.a10 = 0 := by omega
        have e11 : A.a11 = 0 := by omega
        show A = IntMat2.diagonal 0 0
        apply IntMat2.ext <;> simp [IntMat2.diagonal, e00, e01, e10, e11]
      nonneg₁ := le_rfl
      nonneg₂ := le_rfl
      zero_zero := fun _ => rfl
      divides := dvd_zero 0 }

/-- Forget the carried target: a `SmithResult` is a `SmithPresentation` onto a
declared diagonal, which is the shape the capability graph names. -/
def SmithResult.toPresentation {A : IntMat2} (s : SmithResult A) :
    SmithPresentation A (.diagonal s.d₁ s.d₂) where
  left := s.red.left
  right := s.red.right
  replay := s.normal.symm.trans s.red.replay
  left_unimodular := s.red.left_unimodular
  right_unimodular := s.red.right_unimodular

/-!
### The capability graph's open-joint type, and its repaired package

`Pairfield/CapabilityGraph.lean` names the open joint as

    def ArbitrarySmithPresentation :=
      (A : IntMat2) -> Sigma d1 d2 : Int,
          SmithPresentation A (.diagonal d1 d2) *
          (0 <= d1 /\ 0 <= d2 /\ (d1 = 0 -> d2 = 0) /\ d1 | d2)

That spelling does **not** elaborate on a source-clean pinned build: `Prod`
expects both factors in `Type`, while the side conditions inhabit `Prop`.
`CapabilityGraph.lean` now uses the subtype below, which preserves exactly a
presentation together with the four side conditions. See
`notes/GENERAL_SMITH_PRODUCER.md` section 11.
-/

/-- The intended open-joint type, repaired. -/
def ArbitrarySmithPresentation' :=
  (A : IntMat2) ->
    Σ d₁ d₂ : Int,
      { _p : SmithPresentation A (.diagonal d₁ d₂) //
        0 ≤ d₁ ∧ 0 ≤ d₂ ∧ (d₁ = 0 → d₂ = 0) ∧ d₁ ∣ d₂ }

/-- **The joint is closed.** -/
def arbitrarySmithPresentation' : ArbitrarySmithPresentation' := fun A =>
  ⟨(smith A).d₁, (smith A).d₂, (smith A).toPresentation,
    (smith A).nonneg₁, (smith A).nonneg₂, (smith A).zero_zero,
    (smith A).divides⟩

/-! ## The end-to-end capability -/

/-- The producer's small replayable output, in the same certificate language
the untrusted-producer gate consumes. -/
def smithCertificate (A : IntMat2) : SmithCertificate2 :=
  ⟨A, (smith A).red.left, (smith A).d₁, (smith A).d₂, (smith A).red.right⟩

/-- **Main theorem.**  Every certificate this producer emits is valid.  The
checker is therefore no longer needed to trust *this* producer, while remaining
available for foreign ones. -/
theorem smithCertificate_valid (A : IntMat2) : (smithCertificate A).Valid := by
  refine ⟨?_, (smith A).red.left_unimodular, (smith A).red.right_unimodular,
    (smith A).nonneg₁, (smith A).nonneg₂, (smith A).zero_zero,
    (smith A).divides⟩
  show IntMat2.diagonal (smith A).d₁ (smith A).d₂
      = (smith A).red.left * A * (smith A).red.right
  rw [← (smith A).normal]
  exact (smith A).red.replay

/-- The Boolean gate accepts every output, by the same decision procedure. -/
theorem smithCertificate_check (A : IntMat2) :
    (smithCertificate A).check = true :=
  SmithCertificate2.check_complete _ (smithCertificate_valid A)

/-- The two invariant factors multiply to `|det A|`.  This is the exact
statement that prices the certificate: the *last* elementary operation the
descent performs is a shear whose quotient is of order `d₂/d₁`, so certificate
entries are bounded by the determinant's bit-length, not by the input entries'.
See `notes/GENERAL_SMITH_PRODUCER.md` §4 for the exhibited instance where a
certificate entry exceeds every input entry by a factor of 9444. -/
theorem smith_det (A : IntMat2) :
    ((smith A).d₁ * (smith A).d₂).natAbs = A.det.natAbs := by
  have hrep : IntMat2.diagonal (smith A).d₁ (smith A).d₂
      = (smith A).red.left * A * (smith A).red.right :=
    ((smith A).normal).symm.trans ((smith A).red.replay)
  have h1 : (IntMat2.diagonal (smith A).d₁ (smith A).d₂).det
      = (smith A).d₁ * (smith A).d₂ := by
    simp [IntMat2.det, IntMat2.diagonal]
  have h2 := congrArg IntMat2.det hrep
  rw [h1, IntMat2.det_mul, IntMat2.det_mul] at h2
  rw [h2, Int.natAbs_mul, Int.natAbs_mul,
    (smith A).red.left_unimodular, (smith A).red.right_unimodular]
  simp

/-! ## Executable controls -/

example : (smithCertificate ⟨2, 4, 6, 8⟩).check = true := smithCertificate_check _
example : (smithCertificate ⟨0, 0, 0, 0⟩).check = true := smithCertificate_check _
example : (smithCertificate ⟨6, 0, 0, 4⟩).check = true := smithCertificate_check _

end Pairfield
