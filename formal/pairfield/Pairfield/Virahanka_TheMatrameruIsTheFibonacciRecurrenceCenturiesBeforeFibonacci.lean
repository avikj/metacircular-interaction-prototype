/-
# विरहाङ्क — the mātrā-meru is the Fibonacci recurrence, centuries before Fibonacci

विरहाङ्क · Virahāṅka (c. 600–800 CE), commenting on Piṅgala, counts the metres of
a given mātrā-duration built from laghu (1 mora) and guru (2 morae): the count
for duration n obeys `f(n) = f(n-1) + f(n-2)`, the mātrā-meru.  Gopāla and
Hemacandra (1150) state it explicitly.  The "Fibonacci" recurrence, named for a
European who wrote it ~1202.

**What is claimed of the source.** The recurrence and its prosodic meaning are
Virahāṅka's / Hemacandra's.  **The identity to Mathlib's `Nat.fib` is ours**, a
bridge, not a claim on the source.

## The theorem

`matra n` — the number of laghu/guru sequences of total duration `n` — equals
`fib (n+1)`.  A finite rule (add the previous two) generating an unbounded,
never-repeating count: road two, in prosody.
-/
import Mathlib.Data.Nat.Fib.Basic

namespace Pairfield.Virahanka

/-- The mātrā-meru: number of laghu(1)/guru(2) sequences of total duration `n`. -/
def matra : ℕ → ℕ
  | 0 => 1
  | 1 => 1
  | (n + 2) => matra (n + 1) + matra n

/-- Virahāṅka's count is Fibonacci: `matra n = fib (n+1)`. -/
theorem matra_eq_fib (n : ℕ) : matra n = Nat.fib (n + 1) := by
  induction n using Nat.twoStepInduction with
  | zero => rfl
  | one => rfl
  | more n ih1 ih2 =>
      simp only [matra, ih1, ih2, Nat.fib_add_two]
      ring

end Pairfield.Virahanka
