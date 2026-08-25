import Pairfield.LeastNonDivisor

/-!
# Frontier-optimality: the walk's `capacity_certificate`, as an induction

`runtime/walk.py` carries

```python
def capacity_certificate(self) -> bool:
    k = max(self.sensors)
    full = 1
    for r in range(2, k + 1):
        full = full // gcd(full, r) * r      # rebuild lcm(1..k) from scratch
    return self.lcm == full
```

and calls it to certify that the walked state has `lcm = lcm(1..frontier)`.
Rebuilding `lcm(1..k)` costs `k` big-integer lcm operations *per call*, and it
recomputes a statement one induction settles once and for all.

This module supplies the induction.  The interface is deliberately the
*certificate's* interface: the theorem consumes exactly what
`SensorCertificate.valid_least` produces — `¬ q ∣ L` and minimality — so a
producer's certificate composes straight into frontier-optimality without
anyone re-running the scan.

-/

namespace Pairfield

/-- `lcmUpTo k = lcm(1, …, k)`, with `lcmUpTo 0 = 1`. -/
def lcmUpTo : ℕ → ℕ
  | 0 => 1
  | k + 1 => Nat.lcm (lcmUpTo k) (k + 1)

@[simp] theorem lcmUpTo_zero : lcmUpTo 0 = 1 := rfl

@[simp] theorem lcmUpTo_succ (k : ℕ) : lcmUpTo (k + 1) = Nat.lcm (lcmUpTo k) (k + 1) := rfl

theorem lcmUpTo_ne_zero : ∀ k : ℕ, lcmUpTo k ≠ 0
  | 0 => by simp
  | k + 1 => by
      rw [lcmUpTo_succ]
      exact Nat.lcm_ne_zero (lcmUpTo_ne_zero k) (by omega)

theorem lcmUpTo_pos (k : ℕ) : 0 < lcmUpTo k := Nat.pos_of_ne_zero (lcmUpTo_ne_zero k)

/-- Everything up to the frontier is already observed. -/
theorem dvd_lcmUpTo : ∀ {m k : ℕ}, 0 < m → m ≤ k → m ∣ lcmUpTo k
  | m, 0, hm, hk => by omega
  | m, k + 1, hm, hk => by
      rw [lcmUpTo_succ]
      rcases Nat.lt_or_ge m (k + 1) with h | h
      · exact dvd_trans (dvd_lcmUpTo hm (by omega)) (Nat.dvd_lcm_left _ _)
      · have : m = k + 1 := by omega
        exact this ▸ Nat.dvd_lcm_right _ _

theorem lcmUpTo_mono : ∀ {k k' : ℕ}, k ≤ k' → lcmUpTo k ∣ lcmUpTo k' := by
  intro k k'
  induction k' with
  | zero =>
      intro h
      have : k = 0 := by omega
      simp [this]
  | succ n ih =>
      intro h
      rcases Nat.lt_or_ge k (n + 1) with hlt | hge
      · exact dvd_trans (ih (by omega))
          (by rw [lcmUpTo_succ]; exact Nat.dvd_lcm_left _ _)
      · have : k = n + 1 := by omega
        exact this ▸ dvd_rfl

/-- Universal property: `lcmUpTo k` is the least common multiple, so anything
divisible by every `m ≤ k` is divisible by it. -/
theorem lcmUpTo_dvd_of_forall {L : ℕ} :
    ∀ k : ℕ, (∀ m : ℕ, 0 < m → m ≤ k → m ∣ L) → lcmUpTo k ∣ L
  | 0, _ => by simp
  | k + 1, h => by
      rw [lcmUpTo_succ]
      exact Nat.lcm_dvd (lcmUpTo_dvd_of_forall k (fun m hm hmk => h m hm (by omega)))
        (h (k + 1) (by omega) (le_refl _))

/-- **Frontier-optimality, one step.**  If the state is `lcm(1..K)` and `q` is
the least positive non-divisor, then installing `q` lands exactly on
`lcm(1..q)` — and `q` is the new frontier, since `K < q`.

The hypotheses are precisely the conclusions of
`SensorCertificate.valid_least`, so a producer's compact certificate composes
into this without re-running any scan. -/
theorem lcm_eq_lcmUpTo_of_least {K q : ℕ} (hqpos : 0 < q)
    (hq : ¬ q ∣ lcmUpTo K) (hmin : ∀ m : ℕ, 0 < m → m < q → m ∣ lcmUpTo K) :
    K < q ∧ Nat.lcm (lcmUpTo K) q = lcmUpTo q := by
  obtain ⟨r, rfl⟩ : ∃ r, q = r + 1 := ⟨q - 1, by omega⟩
  have hKq : K < r + 1 := by
    by_contra hcon
    exact hq (dvd_lcmUpTo hqpos (by omega))
  refine ⟨hKq, ?_⟩
  -- the state is already `lcm(1..q-1)`, by antisymmetry
  have hlow : lcmUpTo r ∣ lcmUpTo K :=
    lcmUpTo_dvd_of_forall r (fun m hm hmr => hmin m hm (by omega))
  have hhigh : lcmUpTo K ∣ lcmUpTo r := lcmUpTo_mono (by omega)
  have heq : lcmUpTo K = lcmUpTo r := Nat.dvd_antisymm hhigh hlow
  rw [heq, lcmUpTo_succ]

/-- **The whole invariant, as the machine states it.**  Write the walk's state
as `lcmUpTo K`; every forced install preserves the form and moves the frontier
to the installed sensor.  `capacity_certificate` therefore never has to
recompute anything: it is `rfl` after this theorem. -/
theorem frontier_optimal_of_certificate (c : SensorCertificate) (K : ℕ)
    (hL : c.L = lcmUpTo K) (h : c.Valid) :
    K < c.q ∧ Nat.lcm c.L c.q = lcmUpTo c.q := by
  obtain ⟨_, hnd, hmin⟩ := SensorCertificate.valid_least c h
  rw [hL] at hnd hmin ⊢
  exact lcm_eq_lcmUpTo_of_least (Nat.pow_pos h.2.1.pos) hnd hmin

/-! ## Executable controls -/

example : lcmUpTo 5 = 60 := by decide
example : lcmUpTo 9 = 2520 := by decide
example : Nat.lcm (lcmUpTo 5) (leastNonDivisor (lcmUpTo 5)) = lcmUpTo 7 := by decide

end Pairfield
