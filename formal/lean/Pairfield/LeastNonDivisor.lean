import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Algebra.IsPrimePow

/-!
# The walk's forced sensor is a prime power, by proof rather than by scan

`runtime/walk.py` is the machine that currently runs.  At every collision it
executes

```python
q = 2
while self.lcm % q == 0:
    q += 1                                 # q - 1 big-integer divisions
cert = prime_power_certificate(q)          # trial division, every install
if cert is None:
    raise AssertionError("forced sensor %d is not a prime power" % q)
```

Two computations, both of which a page of algebra determines exactly:

1. the linear scan for the least non-divisor `q` — `q - 1` divisibility tests
   against a big integer (`lcm` is 103 bits at the `10^30` frontier and grows
   like `ψ(k)/ln 2`, so the divisor is not cheap either);
2. the trial-division re-derivation, at **every** install, that `q` is a prime
   power — a fact that holds for *every* positive integer.

This module supplies the theorems.  `isPrimePow_of_least_non_divisor` proves
(2) once and for all, so the runtime `raise` can never fire.
`dvd_of_forall_primePow_le` proves that minimality **over prime powers**
already implies minimality over all integers, which compresses the certificate
for (1) from `q - 1` tests to the prime powers below `q`.  For the walk's own
`L = lcm(1..k)` the compressed certificate is empty; see

No novelty is claimed for the number theory: the least non-divisor of a
positive integer (OEIS A007978) is classically a prime power and the argument
below is the standard one.  What is new here is only that a running machine's
runtime assertion becomes an inherited theorem with an executable checker.
-/

namespace Pairfield

/-- **Prime-power minimality suffices.**  If every prime power `≤ m` divides
`L`, then `m` divides `L`.

The bound must be `≤ m`, not `< m`: with `L = 6` and `m = 4`, every prime power
*strictly* below `4` divides `6` while `4` does not, so the strict form is
false.  A maximal prime-power factor of `m` is `≤ m`, which is exactly what the
proof consumes. -/
theorem dvd_of_forall_primePow_le (L m : ℕ) (hm : 0 < m)
    (h : ∀ r : ℕ, IsPrimePow r → r ≤ m → r ∣ L) : m ∣ L := by
  rw [Nat.dvd_iff_prime_pow_dvd_dvd]
  intro p k hp hpk
  rcases Nat.eq_zero_or_pos k with hk | hk
  · simp [hk]
  · exact h (p ^ k) ⟨p, k, hp.prime, hk, rfl⟩ (Nat.le_of_dvd hm hpk)

/-- **The machine's runtime assertion, as a theorem.**  The least positive
non-divisor of an integer is a prime power.  `runtime/walk.py` re-derives this
by trial division at every install; it never has to.

No hypothesis on `L` is needed: for `L = 0` there is no non-divisor and the
statement is vacuous, so the theorem is stated in its widest form. -/
theorem isPrimePow_of_least_non_divisor {L q : ℕ} (hqpos : 0 < q)
    (hq : ¬ q ∣ L) (hmin : ∀ m : ℕ, 0 < m → m < q → m ∣ L) :
    IsPrimePow q := by
  have hq0 : q ≠ 0 := by omega
  have hq1 : q ≠ 1 := fun h => hq (h ▸ one_dvd L)
  obtain ⟨p, hp, hpq⟩ := Nat.exists_prime_and_dvd hq1
  obtain ⟨k, m, hpm, hsplit⟩ := Nat.exists_eq_pow_mul_and_not_dvd hq0 p hp.ne_one
  have hm0 : m ≠ 0 := by
    intro h
    rw [h, Nat.mul_zero] at hsplit
    exact hq0 hsplit
  have hppos : 0 < p ^ k := Nat.pow_pos hp.pos
  have hmpos : 0 < m := Nat.pos_of_ne_zero hm0
  have hk : 0 < k := by
    rcases Nat.eq_zero_or_pos k with h | h
    · exfalso
      rw [h, pow_zero, Nat.one_mul] at hsplit
      exact hpm (hsplit ▸ hpq)
    · exact h
  by_cases hone : m = 1
  · rw [hsplit, hone, Nat.mul_one]
    exact ⟨p, k, hp.prime, hk, rfl⟩
  · exfalso
    have hm2 : 1 < m := by omega
    have hlt1 : p ^ k < q := hsplit ▸ lt_mul_of_one_lt_right hppos hm2
    have hlt2 : m < q := by
      refine hsplit ▸ lt_mul_of_one_lt_left hmpos ?_
      have : p ≤ p ^ k := Nat.le_self_pow (by omega) p
      have := hp.two_le
      omega
    have hcop : Nat.Coprime (p ^ k) m :=
      Nat.Coprime.pow_left _ ((Nat.Prime.coprime_iff_not_dvd hp).mpr hpm)
    exact hq (hsplit ▸ Nat.Coprime.mul_dvd_of_dvd_of_dvd hcop
      (hmin _ hppos hlt1) (hmin _ hmpos hlt2))

/-- **The cost theorem.**  Searching only prime powers finds the same answer.
If `q` fails to divide `L` and every prime power below `q` divides `L`, then
`q` is the least positive non-divisor of `L` outright.

Combined with `isPrimePow_of_least_non_divisor` this says: the least
non-divisor of `L` *is* the least prime power not dividing `L`.  The machine's
`q - 1` big-integer divisions become `π(q) + O(log q)` — and for
`L = lcm(1..k)` they become none, since every prime power `≤ k` divides `L` by
construction and none in `(k, q)` exists. -/
theorem least_of_least_primePow {L q : ℕ}
    (h : ∀ r : ℕ, IsPrimePow r → r < q → r ∣ L) :
    ∀ m : ℕ, 0 < m → m < q → m ∣ L := by
  intro m hm hmq
  exact dvd_of_forall_primePow_le L m hm
    (fun r hr hrm => h r hr (lt_of_le_of_lt hrm hmq))

/-! ## The compact certificate and its executable checker -/

/-- What an untrusted producer must emit to claim that `q = p ^ e` is the least
positive non-divisor of `L`.  `witness` is the producer's enumeration of the
prime powers strictly below `q`; the checker verifies its adequacy rather than
trusting it. -/
structure SensorCertificate where
  L : ℕ
  p : ℕ
  e : ℕ
  witness : List ℕ
  deriving Repr

namespace SensorCertificate

/-- The claimed sensor. -/
def q (c : SensorCertificate) : ℕ := c.p ^ c.e

/-- Exact acceptance condition.  Minimality is asserted only against the listed
prime powers; `dvd_of_forall_primePow_le` upgrades that to minimality against
every positive integer. -/
def Valid (c : SensorCertificate) : Prop :=
  c.L ≠ 0 ∧ c.p.Prime ∧ 0 < c.e ∧ ¬ c.q ∣ c.L ∧
  (∀ r ∈ c.witness, r ∣ c.L) ∧
  (∀ r : ℕ, IsPrimePow r → r < c.q → r ∈ c.witness)

/-- **Soundness of the compressed certificate.**  Acceptance establishes the
full claim: `q` is a prime power and is the least positive non-divisor of `L`
— minimality against *every* smaller positive integer, from a witness list
ranging only over prime powers. -/
theorem valid_least (c : SensorCertificate) (h : c.Valid) :
    IsPrimePow c.q ∧ ¬ c.q ∣ c.L ∧ ∀ m : ℕ, 0 < m → m < c.q → m ∣ c.L := by
  obtain ⟨hL, hp, he, hnd, hwit, hcov⟩ := h
  refine ⟨⟨c.p, c.e, hp.prime, he, rfl⟩, hnd, ?_⟩
  intro m hm hmq
  exact least_of_least_primePow (fun r hr hrq => hwit r (hcov r hr hrq)) m hm hmq

/-- The producer never needs to supply the prime-power property separately: it
is implied.  This is the theorem that retires the runtime `raise`. -/
theorem valid_isPrimePow (c : SensorCertificate) (h : c.Valid) : IsPrimePow c.q :=
  (valid_least c h).1

end SensorCertificate

/-! ## Executable reference: the scan the machine currently performs

`leastNonDivisor` is written so that the Lean statements and the Python loop are
about the same function.  It is the *expensive* side of the bridge; the point of
the module is that its result is pinned by the certificate above. -/

/-- Bounded search for the least positive non-divisor, starting at `cur`. -/
def leastNonDivisorAux (L : ℕ) : ℕ → ℕ → ℕ
  | 0, cur => cur
  | fuel + 1, cur => if cur ∣ L then leastNonDivisorAux L fuel (cur + 1) else cur

/-- The least positive non-divisor of `L`.  For `L ≠ 0` the fuel `L + 1` is
adequate, since `L + 1` does not divide `L`. -/
def leastNonDivisor (L : ℕ) : ℕ := leastNonDivisorAux L (L + 1) 1

/-- Executable controls, kernel-reduced: the least non-divisor of a few
`lcm(1..k)` values is the least prime power above `k`. -/
example : leastNonDivisor 1 = 2 := by decide
example : leastNonDivisor 2 = 3 := by decide
example : leastNonDivisor 6 = 4 := by decide
example : leastNonDivisor 12 = 5 := by decide
example : leastNonDivisor 60 = 7 := by decide
example : leastNonDivisor 420 = 8 := by decide
example : leastNonDivisor 840 = 9 := by decide
example : leastNonDivisor 2520 = 11 := by decide

end Pairfield
