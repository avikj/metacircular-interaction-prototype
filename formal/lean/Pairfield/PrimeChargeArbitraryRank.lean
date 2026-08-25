import Pairfield.PrimeChargeFourTensorRank

/-!
# Indexed tensor rank for squarefree prime-charge cubes

This module develops the dimension-independent finite algebra behind the
checked `W₃` and `W₄` controls.  A tensor on `n` Boolean modes is represented
by a function `(Fin n → Bool) → ℚ`; a pure summand is a product of one local
factor at each mode.

The main reusable result is substitution: from an `(r+1)`-term expression for
an `(n+1)`-mode tensor with a nonzero final slice, one can cancel a nonzero
summand and obtain an `r`-term expression for a linear combination of the two
`n`-mode slices.  The proof uses `Fin.succAbove` to delete the chosen channel,
so it does not assume that the nonzero channel occurs in a privileged slot.
-/

namespace Pairfield.PrimeChargeArbitraryRank

open scoped BigOperators

/-- A rational tensor on `n` Boolean local modes. -/
abbrev Cube (n : ℕ) := (Fin n → Bool) → ℚ

/-- One pure tensor, including its scalar coefficient.  Keeping the coefficient
explicit makes the definition correct also in tensor order zero. -/
@[ext] structure PureTerm (n : ℕ) where
  coefficient : ℚ
  factor : Fin n → Bool → ℚ

/-- Evaluation of one pure local product. -/
def pureEval {n : ℕ} (term : PureTerm n) (x : Fin n → Bool) : ℚ :=
  term.coefficient * ∏ i, term.factor i (x i)

/-- Indexed CP-rank bound: at most `r` pure local products. -/
def RankAtMost {n : ℕ} (r : ℕ) (weight : Cube n) : Prop :=
  ∃ term : Fin r → PureTerm n,
    ∀ x, weight x = ∑ channel, pureEval (term channel) x

/-- Append one final Boolean coordinate. -/
def appendBit {n : ℕ} (x : Fin n → Bool) (last : Bool) : Fin (n + 1) → Bool :=
  Fin.lastCases last x

/-- The two slices in the final local mode. -/
def finalSlice {n : ℕ} (weight : Cube (n + 1)) (last : Bool) : Cube n :=
  fun x ↦ weight (appendBit x last)

/-- A pure product on `n+1` modes splits into its prefix product and final
local coefficient. -/
theorem pureEval_appendBit {n : ℕ}
    (term : PureTerm (n + 1)) (x : Fin n → Bool) (last : Bool) :
    pureEval term (appendBit x last) =
      term.coefficient * (∏ i, term.factor i.castSucc (x i)) *
        term.factor (Fin.last n) last := by
  simp only [pureEval, appendBit]
  rw [Fin.prod_univ_castSucc]
  simp [Fin.lastCases_castSucc, Fin.lastCases_last]
  ring

/-- General substitution lemma.  A nonzero final slice chooses some channel
whose final local coefficient is nonzero.  Subtracting the corresponding
scalar multiple of the `true` slice cancels that channel, and `Fin.succAbove`
indexes precisely the remaining `r` channels. -/
theorem rankAtMost_succ_substitution {n r : ℕ} {weight : Cube (n + 1)}
    (rankSucc : RankAtMost (r + 1) weight)
    (nonzeroTrueSlice : ∃ x, finalSlice weight true x ≠ 0) :
    ∃ lambda : ℚ,
      RankAtMost r
        (fun x ↦ finalSlice weight false x -
          lambda * finalSlice weight true x) := by
  rcases rankSucc with ⟨term, realizes⟩
  rcases nonzeroTrueSlice with ⟨x₀, slice_ne⟩
  have sum_ne :
      (∑ channel, pureEval (term channel) (appendBit x₀ true)) ≠ 0 := by
    rw [← realizes]
    exact slice_ne
  obtain ⟨chosen, _, chosen_ne⟩ :=
    Finset.exists_ne_zero_of_sum_ne_zero sum_ne
  have last_ne : (term chosen).factor (Fin.last n) true ≠ 0 := by
    intro last_zero
    apply chosen_ne
    rw [pureEval_appendBit]
    simp [last_zero]
  let lambda : ℚ :=
    (term chosen).factor (Fin.last n) false /
      (term chosen).factor (Fin.last n) true
  let remaining : Fin r → PureTerm (n + 1) :=
    fun channel ↦ term (chosen.succAbove channel)
  let substituted : Fin r → PureTerm n := fun channel ↦
    { coefficient :=
        (remaining channel).coefficient *
          ((remaining channel).factor (Fin.last n) false -
            lambda * (remaining channel).factor (Fin.last n) true)
      factor := fun i ↦ (remaining channel).factor i.castSucc }
  refine ⟨lambda, substituted, ?_⟩
  intro x
  change weight (appendBit x false) - lambda * weight (appendBit x true) = _
  rw [realizes (appendBit x false), realizes (appendBit x true)]
  simp_rw [pureEval_appendBit]
  rw [Fin.sum_univ_succAbove _ chosen, Fin.sum_univ_succAbove _ chosen]
  have cancel :
      (term chosen).factor (Fin.last n) false -
        lambda * (term chosen).factor (Fin.last n) true = 0 := by
    dsimp only [lambda]
    field_simp [last_ne]
    ring
  have remaining_identity :
      (∑ channel : Fin r,
          (remaining channel).coefficient *
            (∏ i, (remaining channel).factor i.castSucc (x i)) *
            (remaining channel).factor (Fin.last n) false) -
        lambda *
          (∑ channel : Fin r,
            (remaining channel).coefficient *
              (∏ i, (remaining channel).factor i.castSucc (x i)) *
              (remaining channel).factor (Fin.last n) true) =
        ∑ channel : Fin r, pureEval (substituted channel) x := by
    rw [Finset.mul_sum, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro channel _
    simp only [pureEval, substituted]
    ring
  change
    (term chosen).coefficient *
          (∏ i, (term chosen).factor i.castSucc (x i)) *
          (term chosen).factor (Fin.last n) false +
        (∑ channel : Fin r,
          (term (chosen.succAbove channel)).coefficient *
            (∏ i, (term (chosen.succAbove channel)).factor i.castSucc (x i)) *
            (term (chosen.succAbove channel)).factor (Fin.last n) false) -
      lambda *
        ((term chosen).coefficient *
            (∏ i, (term chosen).factor i.castSucc (x i)) *
            (term chosen).factor (Fin.last n) true +
          ∑ channel : Fin r,
            (term (chosen.succAbove channel)).coefficient *
              (∏ i, (term (chosen.succAbove channel)).factor i.castSucc (x i)) *
              (term (chosen.succAbove channel)).factor (Fin.last n) true) = _
  dsimp only [remaining] at remaining_identity
  rw [← remaining_identity]
  calc
    _ = (term chosen).coefficient *
          (∏ i, (term chosen).factor i.castSucc (x i)) *
          ((term chosen).factor (Fin.last n) false -
            lambda * (term chosen).factor (Fin.last n) true) +
        ((∑ channel : Fin r,
            (term (chosen.succAbove channel)).coefficient *
              (∏ i, (term (chosen.succAbove channel)).factor i.castSucc (x i)) *
              (term (chosen.succAbove channel)).factor (Fin.last n) false) -
          lambda *
            (∑ channel : Fin r,
              (term (chosen.succAbove channel)).coefficient *
                (∏ i, (term (chosen.succAbove channel)).factor i.castSucc (x i)) *
                (term (chosen.succAbove channel)).factor (Fin.last n) true)) := by
          ring
    _ = _ := by rw [cancel]; ring

/-! ## The arbitrary-dimensional `W` tensor -/

/-- Remove the final coordinate. -/
def dropLast {n : ℕ} (x : Fin (n + 1) → Bool) : Fin n → Bool :=
  fun i ↦ x i.castSucc

@[simp] theorem dropLast_appendBit {n : ℕ} (x : Fin n → Bool) (last : Bool) :
    dropLast (appendBit x last) = x := by
  funext i
  simp [dropLast, appendBit, Fin.lastCases_castSucc]

@[simp] theorem appendBit_apply_last {n : ℕ} (x : Fin n → Bool) (last : Bool) :
    appendBit x last (Fin.last n) = last := by
  simp [appendBit, Fin.lastCases_last]

theorem appendBit_dropLast {n : ℕ} (x : Fin (n + 1) → Bool) :
    appendBit (dropLast x) (x (Fin.last n)) = x := by
  funext i
  refine Fin.lastCases ?_ (fun j ↦ ?_) i
  · simp [appendBit_apply_last]
  · simp [appendBit, dropLast, Fin.lastCases_castSucc]

/-- The all-inactive vacuum tensor. -/
def vacuumCube (n : ℕ) : Cube n := fun x ↦
  ∏ i, if x i then (0 : ℚ) else 1

/-- Recursive `W_n`: exactly one active Boolean coordinate. -/
def wCube : (n : ℕ) → Cube n
  | 0 => fun _ ↦ 0
  | n + 1 => fun x ↦
      if x (Fin.last n) then vacuumCube n (dropLast x)
      else wCube n (dropLast x)

/-- `W_n` with an arbitrary vacuum coefficient. -/
def shiftedWCube (n : ℕ) (lambda : ℚ) : Cube n := fun x ↦
  wCube n x - lambda * vacuumCube n x

theorem vacuumCube_appendBit {n : ℕ} (x : Fin n → Bool) (last : Bool) :
    vacuumCube (n + 1) (appendBit x last) =
      vacuumCube n x * (if last then 0 else 1) := by
  simp only [vacuumCube]
  rw [Fin.prod_univ_castSucc]
  simp [appendBit, Fin.lastCases_castSucc, Fin.lastCases_last]

@[simp] theorem finalSlice_wCube_false (n : ℕ) :
    finalSlice (wCube (n + 1)) false = wCube n := by
  funext x
  simp [finalSlice, wCube, appendBit_apply_last, dropLast_appendBit]

@[simp] theorem finalSlice_wCube_true (n : ℕ) :
    finalSlice (wCube (n + 1)) true = vacuumCube n := by
  funext x
  simp [finalSlice, wCube, appendBit_apply_last, dropLast_appendBit]

@[simp] theorem finalSlice_vacuumCube_false (n : ℕ) :
    finalSlice (vacuumCube (n + 1)) false = vacuumCube n := by
  funext x
  simp [finalSlice, vacuumCube_appendBit]

@[simp] theorem finalSlice_vacuumCube_true (n : ℕ) :
    finalSlice (vacuumCube (n + 1)) true = 0 := by
  funext x
  simp [finalSlice, vacuumCube_appendBit]

@[simp] theorem finalSlice_shiftedWCube_false (n : ℕ) (lambda : ℚ) :
    finalSlice (shiftedWCube (n + 1) lambda) false =
      shiftedWCube n lambda := by
  funext x
  change finalSlice (wCube (n + 1)) false x -
    lambda * finalSlice (vacuumCube (n + 1)) false x = _
  rw [finalSlice_wCube_false, finalSlice_vacuumCube_false]
  rfl

@[simp] theorem finalSlice_shiftedWCube_true (n : ℕ) (lambda : ℚ) :
    finalSlice (shiftedWCube (n + 1) lambda) true = vacuumCube n := by
  funext x
  change finalSlice (wCube (n + 1)) true x -
    lambda * finalSlice (vacuumCube (n + 1)) true x = _
  rw [finalSlice_wCube_true, finalSlice_vacuumCube_true]
  simp

/-- The vacuum is nonzero at the all-inactive point. -/
theorem vacuumCube_allFalse (n : ℕ) :
    vacuumCube n (fun _ ↦ false) = 1 := by
  simp [vacuumCube]

/-- Substitution induction, strengthened uniformly over a vacuum shift:
`W_(n+1) - lambda * vacuum` cannot be written with `n` pure summands. -/
theorem shiftedWCube_not_rankAtMost (n : ℕ) :
    ∀ lambda : ℚ, ¬ RankAtMost n (shiftedWCube (n + 1) lambda) := by
  induction n with
  | zero =>
      intro lambda rankZero
      rcases rankZero with ⟨term, realizes⟩
      have h := realizes (fun _ ↦ true)
      simp [shiftedWCube, wCube, vacuumCube] at h
  | succ n ih =>
      intro lambda rankSucc
      have nonzeroTrueSlice :
          ∃ x, finalSlice (shiftedWCube ((n + 1) + 1) lambda) true x ≠ 0 := by
        refine ⟨(fun _ ↦ false), ?_⟩
        rw [finalSlice_shiftedWCube_true]
        rw [vacuumCube_allFalse]
        norm_num
      rcases rankAtMost_succ_substitution rankSucc nonzeroTrueSlice with
        ⟨mu, reduced⟩
      have identifies :
          (fun x ↦
            finalSlice (shiftedWCube ((n + 1) + 1) lambda) false x -
              mu * finalSlice (shiftedWCube ((n + 1) + 1) lambda) true x) =
            shiftedWCube (n + 1) (lambda + mu) := by
        funext x
        simp [shiftedWCube]
        ring
      rw [identifies] at reduced
      exact ih (lambda + mu) reduced

/-- In particular, `W_n` has rank at least `n`. -/
theorem wCube_not_rankAtMost_pred (n : ℕ) :
    ¬ RankAtMost n (wCube (n + 1)) := by
  have identifies : shiftedWCube (n + 1) 0 = wCube (n + 1) := by
    funext x
    simp [shiftedWCube]
  rw [← identifies]
  exact shiftedWCube_not_rankAtMost n 0

/-! ## The matching `n`-term upper bound -/

def inactiveFactor (b : Bool) : ℚ := if b then 0 else 1
def activeFactor (b : Bool) : ℚ := if b then 1 else 0

def vacuumTerm (n : ℕ) : PureTerm n where
  coefficient := 1
  factor := fun _ ↦ inactiveFactor

theorem pureEval_vacuumTerm (n : ℕ) (x : Fin n → Bool) :
    pureEval (vacuumTerm n) x = vacuumCube n x := by
  simp [pureEval, vacuumTerm, vacuumCube, inactiveFactor]

/-- Extend a pure term by one new final local factor. -/
def extendTerm {n : ℕ} (term : PureTerm n) (lastFactor : Bool → ℚ) :
    PureTerm (n + 1) where
  coefficient := term.coefficient
  factor := Fin.lastCases lastFactor term.factor

theorem pureEval_extendTerm {n : ℕ} (term : PureTerm n)
    (lastFactor : Bool → ℚ) (x : Fin n → Bool) (last : Bool) :
    pureEval (extendTerm term lastFactor) (appendBit x last) =
      pureEval term x * lastFactor last := by
  rw [pureEval_appendBit]
  simp [pureEval, extendTerm, Fin.lastCases_castSucc, Fin.lastCases_last]

/-- The recursive `W_n` has its evident `n`-term marked-coordinate
decomposition. -/
theorem wCube_rankAtMost (n : ℕ) : RankAtMost n (wCube n) := by
  induction n with
  | zero =>
      refine ⟨fun channel ↦ Fin.elim0 channel, ?_⟩
      intro x
      simp [wCube]
  | succ n ih =>
      rcases ih with ⟨term, realizes⟩
      let extended : Fin (n + 1) → PureTerm (n + 1) :=
        Fin.cases (extendTerm (vacuumTerm n) activeFactor)
          (fun channel ↦ extendTerm (term channel) inactiveFactor)
      refine ⟨extended, ?_⟩
      intro y
      have evalExtend (t : PureTerm n) (lastFactor : Bool → ℚ) :
          pureEval (extendTerm t lastFactor) y =
            pureEval t (dropLast y) * lastFactor (y (Fin.last n)) := by
        calc
          _ = pureEval (extendTerm t lastFactor)
                (appendBit (dropLast y) (y (Fin.last n))) := by
              rw [appendBit_dropLast]
          _ = _ := pureEval_extendTerm t lastFactor
            (dropLast y) (y (Fin.last n))
      rw [Fin.sum_univ_succ]
      simp only [extended, Fin.cases_zero, Fin.cases_succ,
        evalExtend]
      by_cases hlast : y (Fin.last n) = true
      · simp [wCube, hlast, activeFactor, inactiveFactor,
          pureEval_vacuumTerm]
      · have hfalse : y (Fin.last n) = false := Bool.eq_false_of_not_eq_true hlast
        simp [wCube, hlast, activeFactor, inactiveFactor,
          pureEval_vacuumTerm, realizes]

/-- Exact arbitrary-dimensional theorem: `W_n` has CP tensor rank `n` over
`ℚ` in the indexed pure-term model. -/
theorem wCube_rankExactly (n : ℕ) :
    RankAtMost n (wCube n) ∧
      (n = 0 ∨ ¬ RankAtMost (n - 1) (wCube n)) := by
  refine ⟨wCube_rankAtMost n, ?_⟩
  cases n with
  | zero => exact Or.inl rfl
  | succ n =>
      exact Or.inr (by simpa using wCube_not_rankAtMost_pred n)

/-! ## Local Boolean zeta transform and the squarefree `q₁` tensor -/

def zetaKernel (output input : Bool) : ℚ :=
  if output then 1 else if input then 0 else 1

def zetaFactor (factor : Bool → ℚ) (output : Bool) : ℚ :=
  if output then factor false + factor true else factor false

/-- Apply the Boolean zeta matrix independently at every local mode. -/
def localZetaCube {n : ℕ} (weight : Cube n) : Cube n := fun output ↦
  ∑ input : Fin n → Bool,
    weight input * ∏ i, zetaKernel (output i) (input i)

def zetaTerm {n : ℕ} (term : PureTerm n) : PureTerm n where
  coefficient := term.coefficient
  factor := fun i ↦ zetaFactor (term.factor i)

/-- The local zeta transform of a pure tensor is the pure tensor obtained by
zeta-transforming every local factor. -/
theorem localZetaCube_pureEval {n : ℕ} (term : PureTerm n) :
    localZetaCube (pureEval term) = pureEval (zetaTerm term) := by
  funext output
  simp only [localZetaCube, pureEval, zetaTerm]
  calc
    (∑ input : Fin n → Bool,
        term.coefficient * (∏ i, term.factor i (input i)) *
          ∏ i, zetaKernel (output i) (input i)) =
      term.coefficient *
        ∑ input : Fin n → Bool,
          ∏ i, term.factor i (input i) *
            zetaKernel (output i) (input i) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro input _
        rw [mul_assoc, ← Finset.prod_mul_distrib]
    _ = term.coefficient *
        ∏ i, ∑ input : Bool,
          term.factor i input * zetaKernel (output i) input := by
        rw [Fintype.prod_sum]
    _ = term.coefficient * ∏ i, zetaFactor (term.factor i) (output i) := by
        congr 1
        apply Finset.prod_congr rfl
        intro i _
        cases output i
        · simp [zetaFactor, zetaKernel]
        · simp [zetaFactor, zetaKernel]
          ring

/-- Modewise Boolean zeta transform preserves every indexed rank bound. -/
theorem localZetaCube_preserves_rankAtMost {n r : ℕ} {weight : Cube n}
    (rankBound : RankAtMost r weight) :
    RankAtMost r (localZetaCube weight) := by
  rcases rankBound with ⟨term, realizes⟩
  refine ⟨fun channel ↦ zetaTerm (term channel), ?_⟩
  intro output
  simp only [localZetaCube]
  simp_rw [realizes]
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro channel _
  rw [← localZetaCube_pureEval]
  rfl

def signFactor (b : Bool) : ℚ := if b then -1 else 1

/-- The marked-prime pure term at one squarefree local place. -/
def chargeTerm {n : ℕ} (marked : Fin n) : PureTerm n where
  coefficient := 1
  factor := fun i ↦ if i = marked then activeFactor else signFactor

/-- The actual squarefree `q₁` tensor: choose one marked prime and put the
Möbius sign on every other active prime place. -/
def squarefreeChargeCube (n : ℕ) : Cube n := fun x ↦
  ∑ marked : Fin n, pureEval (chargeTerm marked) x

/-- Its marked-prime formula gives the immediate `n`-term upper bound. -/
theorem squarefreeChargeCube_rankAtMost (n : ℕ) :
    RankAtMost n (squarefreeChargeCube n) :=
  ⟨chargeTerm, fun _ ↦ rfl⟩

def canonicalWTerm {n : ℕ} (marked : Fin n) : PureTerm n where
  coefficient := 1
  factor := fun i ↦ if i = marked then activeFactor else inactiveFactor

def canonicalWCube (n : ℕ) : Cube n := fun x ↦
  ∑ marked : Fin n, pureEval (canonicalWTerm marked) x

theorem pureEval_canonicalWTerm_last {n : ℕ} (x : Fin n → Bool) (last : Bool) :
    pureEval (canonicalWTerm (Fin.last n)) (appendBit x last) =
      vacuumCube n x * activeFactor last := by
  rw [pureEval_appendBit]
  simp [canonicalWTerm, vacuumCube, activeFactor, inactiveFactor,
    Fin.castSucc_ne_last]

theorem pureEval_canonicalWTerm_castSucc {n : ℕ} (marked : Fin n)
    (x : Fin n → Bool) (last : Bool) :
    pureEval (canonicalWTerm marked.castSucc) (appendBit x last) =
      pureEval (canonicalWTerm marked) x * inactiveFactor last := by
  rw [pureEval_appendBit]
  simp [canonicalWTerm, pureEval, inactiveFactor,
    Fin.castSucc_inj,
    show Fin.last n ≠ marked.castSucc by exact (Fin.castSucc_ne_last marked).symm]

/-- The canonical marked-coordinate sum obeys the same final-slice recursion
as the recursive `W` tensor. -/
theorem canonicalWCube_appendBit {n : ℕ} (x : Fin n → Bool) (last : Bool) :
    canonicalWCube (n + 1) (appendBit x last) =
      if last then vacuumCube n x else canonicalWCube n x := by
  simp only [canonicalWCube]
  rw [Fin.sum_univ_succAbove _ (Fin.last n)]
  simp_rw [Fin.succAbove_last_apply, pureEval_canonicalWTerm_last,
    pureEval_canonicalWTerm_castSucc]
  cases last <;> simp [activeFactor, inactiveFactor]

theorem canonicalWCube_eq_wCube (n : ℕ) : canonicalWCube n = wCube n := by
  induction n with
  | zero =>
      funext x
      simp [canonicalWCube, wCube]
  | succ n ih =>
      funext y
      rw [← appendBit_dropLast y, canonicalWCube_appendBit]
      simp only [wCube, appendBit_apply_last, dropLast_appendBit]
      rw [ih]

theorem zetaTerm_chargeTerm {n : ℕ} (marked : Fin n) :
    zetaTerm (chargeTerm marked) = canonicalWTerm marked := by
  apply PureTerm.ext
  · rfl
  · funext i b
    by_cases h : i = marked
    · simp [chargeTerm, canonicalWTerm, zetaTerm, h, zetaFactor,
        activeFactor]
    · cases b <;>
        simp [chargeTerm, canonicalWTerm, zetaTerm, h, zetaFactor,
          signFactor, inactiveFactor]

theorem localZetaCube_squarefreeChargeCube (n : ℕ) :
    localZetaCube (squarefreeChargeCube n) = canonicalWCube n := by
  funext output
  change
    (∑ input : Fin n → Bool,
      (∑ marked : Fin n, pureEval (chargeTerm marked) input) *
        ∏ i, zetaKernel (output i) (input i)) =
      ∑ marked : Fin n, pureEval (canonicalWTerm marked) output
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro marked _
  change localZetaCube (pureEval (chargeTerm marked)) output = _
  rw [localZetaCube_pureEval, zetaTerm_chargeTerm]

theorem localZetaCube_squarefreeChargeCube_eq_wCube (n : ℕ) :
    localZetaCube (squarefreeChargeCube n) = wCube n := by
  rw [localZetaCube_squarefreeChargeCube, canonicalWCube_eq_wCube]

/-- The squarefree marked-prime tensor cannot use fewer than `n` pure local
products. -/
theorem squarefreeChargeCube_not_rankAtMost_pred (n : ℕ) :
    ¬ RankAtMost n (squarefreeChargeCube (n + 1)) := by
  intro rankBound
  have transformed := localZetaCube_preserves_rankAtMost rankBound
  rw [localZetaCube_squarefreeChargeCube_eq_wCube] at transformed
  exact wCube_not_rankAtMost_pred n transformed

/-- Exact arbitrary-dimensional charge theorem: the `n`-place squarefree
restriction of `q₁ = μ * 1_P` has CP tensor rank `n` over `ℚ`. -/
theorem squarefreeChargeCube_rankExactly (n : ℕ) :
    RankAtMost n (squarefreeChargeCube n) ∧
      (n = 0 ∨ ¬ RankAtMost (n - 1) (squarefreeChargeCube n)) := by
  refine ⟨squarefreeChargeCube_rankAtMost n, ?_⟩
  cases n with
  | zero => exact Or.inl rfl
  | succ n =>
      exact Or.inr (by simpa using squarefreeChargeCube_not_rankAtMost_pred n)

/-- Concrete specializations at the two previously checked thresholds.  These
exercise both the base and successor seams of the arbitrary-rank induction. -/
theorem wCube_checked_three_four_seam :
    (RankAtMost 3 (wCube 3) ∧ ¬ RankAtMost 2 (wCube 3)) ∧
      (RankAtMost 4 (wCube 4) ∧ ¬ RankAtMost 3 (wCube 4)) := by
  constructor
  · simpa using wCube_rankExactly 3
  · simpa using wCube_rankExactly 4

theorem squarefreeChargeCube_checked_three_four_seam :
    (RankAtMost 3 (squarefreeChargeCube 3) ∧
      ¬ RankAtMost 2 (squarefreeChargeCube 3)) ∧
    (RankAtMost 4 (squarefreeChargeCube 4) ∧
      ¬ RankAtMost 3 (squarefreeChargeCube 4)) := by
  constructor
  · simpa using squarefreeChargeCube_rankExactly 3
  · simpa using squarefreeChargeCube_rankExactly 4


end Pairfield.PrimeChargeArbitraryRank
