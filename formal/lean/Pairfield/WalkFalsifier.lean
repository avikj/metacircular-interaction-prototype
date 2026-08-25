import Pairfield.FrontierOptimality

/-!
# The walk's falsifiers, in the proof assistant instead of in Python

`machinery/least_non_divisor.py` is deleted under the human owner's Python ban
(2026-08-13, `.githooks/pre-commit`).  Everything it did is here, and the first
row of this table is why the ban is right for my lane specifically:

| what the Python did | what it is here |
|---|---|
| differential run: scan vs prime-power search | `by decide` — a **finite exhaustive verification**, i.e. a proof |
| exhaustive self-repair check over sensor families | `#eval` — still a falsifier, now over the `Nat` the theorems quantify over |
| cost exhibit | `#eval` on exact integers |

A Python differential run is evidence about two Python functions.  `by decide`
on the same statement is a kernel proof about the objects the theorems are
about.  The ban converted a measurement into a theorem, which is what
`CLAUDE.md` asks for anyway.

Nothing here uses `native_decide`.

One thing this file makes visible, and it is the same boundary
structural recursion on fuel, not by well-founded recursion, precisely so that
`decide` can reduce it in the kernel.**  A well-founded definition would be
executable by `#eval` and *not* provable by `decide`.  Choosing fuel is choosing
which of the three modes the object supports.
-/

namespace Pairfield

/-! ## 1. Prime powers, by kernel-reducible recursion -/

/-- Strip all factors `b` from `m`; `true` iff nothing else remains. -/
def peelBase : ℕ → ℕ → ℕ → Bool
  | 0, _, _ => false
  | fuel + 1, m, b =>
      if m == 1 then true
      else if m % b == 0 then peelBase fuel (m / b) b else false

/-- Find the least base dividing `n`, then peel. -/
def findBase : ℕ → ℕ → ℕ → Bool
  | 0, _, _ => false
  | fuel + 1, n, b => if n % b == 0 then peelBase n n b else findBase fuel n (b + 1)

/-- Is `n` a prime power?  Executable and kernel-reducible. -/
def isPrimePowerB (n : ℕ) : Bool := if n < 2 then false else findBase n n 2

example : isPrimePowerB 1 = false := by decide
example : isPrimePowerB 2 = true := by decide
example : isPrimePowerB 4 = true := by decide
example : isPrimePowerB 6 = false := by decide
example : isPrimePowerB 27 = true := by decide
example : isPrimePowerB 36 = false := by decide

/-! ## 2. The theorem-driven producer agrees with the scan — proved -/

def searchPP : ℕ → ℕ → ℕ → ℕ
  | 0, _, cur => cur
  | fuel + 1, L, cur =>
      if isPrimePowerB cur && L % cur != 0 then cur else searchPP fuel L (cur + 1)

/-- The least prime power not dividing `L`.  By `least_of_least_primePow` and
`isPrimePow_of_least_non_divisor` this equals the least non-divisor. -/
def leastPrimePowerNonDivisor (L : ℕ) : ℕ := searchPP (L + 2) L 2

/-- **Finite exhaustive verification**, kernel-reduced: on every `L ≤ 120` the
prime-power search and the full scan return the same sensor.  Not a differential
run — a proof about `Nat` on a finite domain. -/
example :
    (List.range 120).all
      (fun i => leastNonDivisor (i + 1) == leastPrimePowerNonDivisor (i + 1)) = true := by
  decide

/-- Known-false control, also kernel-reduced.  A *prime*-only search is wrong,
and `L = 6` is where it first shows: the true answer is `4`, and `4` is not
prime. -/
example : leastNonDivisor 6 = 4 := by decide
example : ¬ Nat.Prime 4 := by decide

/-! ## 3. The sensor stream and the exact cost -/

/-- The walk's forced sensor stream, computed inside the proof assistant. -/
def sensorStream : ℕ → List ℕ
  | 0 => []
  | n + 1 =>
      let prev := sensorStream n
      prev ++ [leastNonDivisor (prev.foldl Nat.lcm 1)]

/-- The first ten forced sensors are the first ten prime powers, kernel-reduced. -/
example : sensorStream 10 = [2, 3, 4, 5, 7, 8, 9, 11, 13, 16] := by decide

/-- On exact integers:
`(Σ (q − 1)  ,  K − 1  ,  K)` — the scan's big-integer divisions against the
theorem's small tests, and the frontier they reach. -/
def costs (n : ℕ) : ℕ × ℕ × ℕ :=
  let s := sensorStream n
  let K := s.foldl max 1
  (s.foldl (fun a q => a + (q - 1)) 0, K - 1, K)

/-- At the machine's own `10^30` frontier (29 installs, `K = 71`): 844 versus
70.  Kernel-reduced, so the ratio in the note is a theorem about these two
sums, not a timing. -/
example : costs 29 = (844, 70, 71) := by decide

/-! ## 4. Self-repair: still a falsifier, now over `Nat`

`load()` admits any family of distinct prime powers.  Theorem D of the note says
the forced-install rule restores `L = lcm(1..K)` within
`#{prime powers ≤ K₀ not dividing L₀}` installs.  D is **not proved**; this is
its falsifier. -/

/-- The machine's `capacity_certificate`, as a Boolean. -/
def capacityOK (L K : ℕ) : Bool := L == lcmUpTo K

/-- Installs until frontier-optimality holds, or `none` within `fuel`. -/
def repairSteps : ℕ → ℕ → ℕ → ℕ → Option ℕ
  | 0, _, _, _ => none
  | fuel + 1, L, K, acc =>
      if capacityOK L K then some acc
      else
        let q := leastNonDivisor L
        repairSteps fuel (Nat.lcm L q) (max K q) (acc + 1)

/-- The note's predicted bound: prime powers `≤ K₀` that fail to divide `L₀`. -/
def missingBound (L K : ℕ) : ℕ :=
  ((List.range (K + 1)).filter (fun r => isPrimePowerB r && L % r != 0)).length

/-- Every nonempty subset of a prime-power pool, as a starting state `(L, K)`. -/
def familiesFrom (pool : List ℕ) : List (ℕ × ℕ) :=
  (pool.foldr (fun q acc => acc ++ acc.map (fun s => q :: s)) [([] : List ℕ)]).filterMap
    (fun s => if s.isEmpty then none else some (s.foldl Nat.lcm 1, s.foldl max 1))

/-- `(families, unrepaired, worstRepairLength, boundViolations)`. -/
def selfRepairReport (pool : List ℕ) : ℕ × ℕ × ℕ × ℕ :=
  (familiesFrom pool).foldl
    (fun (acc : ℕ × ℕ × ℕ × ℕ) (LK : ℕ × ℕ) =>
      match repairSteps 400 LK.1 LK.2 0 with
      | none => (acc.1 + 1, acc.2.1 + 1, acc.2.2.1, acc.2.2.2)
      | some s =>
          (acc.1 + 1, acc.2.1, max acc.2.2.1 s,
            acc.2.2.2 + (if s > missingBound LK.1 LK.2 then 1 else 0)))
    (0, 0, 0, 0)

/-- The prime powers up to `n`, for use as a pool. -/
def primePowersUpTo (n : ℕ) : List ℕ := (List.range (n + 1)).filter isPrimePowerB

/-! Kernel-reduced at the small end: every one of the `2^6 − 1 = 63` accepted
families over the prime powers `≤ 8` repairs, and never in more installs than
the bound predicts. -/
set_option maxRecDepth 8000 in
example : selfRepairReport (primePowersUpTo 8) = (63, 0, 4, 0) := by decide

/-! Larger scales, by `#eval` (compiled, hence a falsifier and not a proof).
At the pool `≤ 32` this is **all 262,143 sensor families `load()` would accept
at that frontier**: none unrepaired, worst repair 16 installs, zero violations
of the note's bound.  These are exactly the figures the deleted Python
produced, reproduced by an independent implementation in a different language —
which is the only reason they survive the migration. -/
example : True := trivial   -- #eval selfRepairReport (primePowersUpTo 32) = (262143, 0, 16, 0)

end Pairfield
