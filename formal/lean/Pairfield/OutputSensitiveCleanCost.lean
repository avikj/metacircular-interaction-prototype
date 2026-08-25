import Mathlib

/-!
# Output-sensitive clean rolling cost

This file checks the finite arithmetic kernel of
`notes/OUTPUT_SENSITIVE_CLEAN_COST.md`.  A digit trace is a list of bounded
base-`p` digits.  The declared early-stopping query count determines the
within-level subtraction count, while occurrences of the maximal digit before
the final position contribute one boundary subtraction.

The result concerns the supplied trace and cost definitions only.  It does not
construct a scheduler or reversible circuit, choose a digit order, or prove an
average-case or Pareto-optimality statement.
-/

namespace Pairfield.OutputSensitiveCleanCost

/-- Early-stopping queries for one bounded base-`p` digit.  The maximal digit
is inferred after the first `p-1` candidates fail. -/
def queryCost {p : ℕ} (digit : Fin p) : ℕ :=
  if digit.1 = p - 1 then p - 1 else digit.1 + 1

/-- Forward valuation-query count along a supplied digit trace. -/
def forwardQueries {p : ℕ} (trace : List (Fin p)) : ℕ :=
  (trace.map queryCost).sum

/-- Clean oracle use computes and uncomputes every forward response. -/
def oracleInvocations {p : ℕ} (trace : List (Fin p)) : ℕ :=
  2 * forwardQueries trace

/-- Maximal digits before the last position require one extra rolling-center
subtraction.  The final digit creates no following boundary. -/
def omittedBoundaries {p : ℕ} (trace : List (Fin p)) : ℕ :=
  (trace.dropLast.filter fun digit ↦ digit.1 = p - 1).length

/-- New center-forming subtractions: `q(d)-1` within each level, plus the
nonterminal omitted-digit boundaries. -/
def centerSubtractions {p : ℕ} (trace : List (Fin p)) : ℕ :=
  (trace.map fun digit ↦ queryCost digit - 1).sum + omittedBoundaries trace

theorem one_le_queryCost {p : ℕ} (hp : 2 ≤ p) (digit : Fin p) :
    1 ≤ queryCost digit := by
  simp only [queryCost]
  split <;> omega

/-- Subtracting one query at every level and then restoring the number of
levels recovers the total forward-query count. -/
theorem withinSubtractions_add_length {p : ℕ} (hp : 2 ≤ p)
    (trace : List (Fin p)) :
    (trace.map fun digit ↦ queryCost digit - 1).sum + trace.length =
      forwardQueries trace := by
  induction trace with
  | nil => simp [forwardQueries]
  | cons digit tail ih =>
      simp only [List.map_cons, List.sum_cons, List.length_cons, forwardQueries]
      have hquery := one_le_queryCost hp digit
      simp only [forwardQueries] at ih
      omega

/-- Exact per-trace conservation law.  It is subtraction-free, including at
the empty trace: `S + k = Q + omitted`. -/
theorem centerSubtractions_add_length {p : ℕ} (hp : 2 ≤ p)
    (trace : List (Fin p)) :
    centerSubtractions trace + trace.length =
      forwardQueries trace + omittedBoundaries trace := by
  have hwithin := withinSubtractions_add_length hp trace
  simp only [centerSubtractions]
  omega

/-! ## Endpoint controls -/

def zeroDigit {p : ℕ} (hp : 1 ≤ p) : Fin p := ⟨0, by omega⟩

def maxDigit {p : ℕ} (hp : 1 ≤ p) : Fin p := ⟨p - 1, by omega⟩

def zeroTrace (p k : ℕ) (hp : 1 ≤ p) : List (Fin p) :=
  List.replicate k (zeroDigit hp)

def omittedTrace (p k : ℕ) (hp : 1 ≤ p) : List (Fin p) :=
  List.replicate k (maxDigit hp)

/-- At the all-zero endpoint each level uses one forward query, two clean
oracle invocations, and no new center-forming subtraction. -/
theorem zeroTrace_costs (p k : ℕ) (hp : 2 ≤ p) :
    forwardQueries (zeroTrace p k (by omega)) = k ∧
    oracleInvocations (zeroTrace p k (by omega)) = 2 * k ∧
    centerSubtractions (zeroTrace p k (by omega)) = 0 := by
  have hpositive : 1 ≤ p := by omega
  have hzero : 0 ≠ p - 1 := by omega
  simp [zeroTrace, forwardQueries, oracleInvocations, centerSubtractions,
    omittedBoundaries, queryCost, zeroDigit, hzero]

/-- At the all-omitted endpoint the terminal position contributes no boundary
subtraction, giving `k(p-1)-1` rather than `k(p-1)`. -/
theorem omittedTrace_costs (p k : ℕ) (hp : 2 ≤ p) (hk : 0 < k) :
    forwardQueries (omittedTrace p k (by omega)) = k * (p - 1) ∧
    oracleInvocations (omittedTrace p k (by omega)) = 2 * (k * (p - 1)) ∧
    omittedBoundaries (omittedTrace p k (by omega)) = k - 1 ∧
    centerSubtractions (omittedTrace p k (by omega)) = k * (p - 1) - 1 := by
  have hpositive : 1 ≤ p := by omega
  have hforward : forwardQueries (omittedTrace p k hpositive) = k * (p - 1) := by
    simp [omittedTrace, forwardQueries, queryCost, maxDigit]
  have homitted : omittedBoundaries (omittedTrace p k hpositive) = k - 1 := by
    simp [omittedTrace, omittedBoundaries, maxDigit]
  have hbalance := centerSubtractions_add_length hp (omittedTrace p k hpositive)
  have hlength : (omittedTrace p k hpositive).length = k := by
    simp [omittedTrace]
  refine ⟨hforward, ?_, homitted, ?_⟩
  · simp [oracleInvocations, hforward]
  · rw [hlength, hforward, homitted] at hbalance
    omega

/-! ## Finite-population conservation -/

/-- Summing the per-trace conservation law over any declared finite
population.  Equal trace length is the only population hypothesis; no
distribution or digit-count formula is inferred. -/
theorem finitePopulation_balance {α : Type*} {p k : ℕ} (hp : 2 ≤ p)
    (population : Finset α) (trace : α → List (Fin p))
    (length_eq : ∀ state ∈ population, (trace state).length = k) :
    (∑ state ∈ population, centerSubtractions (trace state)) +
        population.card * k =
      (∑ state ∈ population, forwardQueries (trace state)) +
        ∑ state ∈ population, omittedBoundaries (trace state) := by
  calc
    (∑ state ∈ population, centerSubtractions (trace state)) +
          population.card * k =
        ∑ state ∈ population, (centerSubtractions (trace state) + k) := by
          simp [Finset.sum_add_distrib]
    _ = ∑ state ∈ population,
          (forwardQueries (trace state) + omittedBoundaries (trace state)) := by
          apply Finset.sum_congr rfl
          intro state hstate
          rw [← length_eq state hstate]
          exact centerSubtractions_add_length hp (trace state)
    _ = (∑ state ∈ population, forwardQueries (trace state)) +
          ∑ state ∈ population, omittedBoundaries (trace state) := by
          simp [Finset.sum_add_distrib]

/-! ## A one-digit separation from signed geodesic motion -/

/-- The signed-geodesic statistic used in a different cost model: sum the
actual digit values.  It is defined here only to state the separating control. -/
def signedGeodesicMotion {p : ℕ} (trace : List (Fin p)) : ℕ :=
  (trace.map Fin.val).sum

def p3MaxTrace : List (Fin 3) := [⟨2, by decide⟩]

/-- At `p=3`, `k=1`, digit `2`, signed-geodesic motion is two but the rolling
center uses one subtraction.  Thus the two notions cannot be silently
identified even on a single trace. -/
theorem p3_k1_max_geodesic_ne_rolling :
    signedGeodesicMotion p3MaxTrace = 2 ∧
    forwardQueries p3MaxTrace = 2 ∧
    omittedBoundaries p3MaxTrace = 0 ∧
    centerSubtractions p3MaxTrace = 1 ∧
    signedGeodesicMotion p3MaxTrace ≠ centerSubtractions p3MaxTrace := by
  norm_num [p3MaxTrace, signedGeodesicMotion, forwardQueries, omittedBoundaries,
    centerSubtractions, queryCost]

end Pairfield.OutputSensitiveCleanCost
