/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An actual-primality calibration of Dependent System Optimization Delta 26.
The endpoint pattern `p,p+4` and the waypoint pattern `p,p+2,p+4` are kept as
different proof-relevant predicates.  Requiring the waypoint loses the valid
endpoint at `p=7`; globally, the only prime triple of this form starts at 3.

This finite congruence theorem is not progress on Goldbach coverage.  It
certifies that a particular intermediate ontology is strictly smaller than
the endpoint relation it was proposed to represent.
-/
import Mathlib

namespace Pairfield

/-- The endpoint relation for a prime pair at gap four. -/
def PrimeEndpoint04 (p : ℕ) : Prop := p.Prime ∧ (p + 4).Prime

/-- The stricter architecture obtained by materializing the `p+2` waypoint. -/
def PrimeWaypoint024 (p : ℕ) : Prop :=
  p.Prime ∧ (p + 2).Prime ∧ (p + 4).Prime

/-- Three consecutive odd translates can all be prime only in the exceptional
triple `(3,5,7)`.  The proof is the complete residue split modulo three. -/
theorem primeWaypoint024_eq_three {p : ℕ} (h : PrimeWaypoint024 p) : p = 3 := by
  rcases h with ⟨hp, hp2, hp4⟩
  have hprime3 : Nat.Prime 3 := by decide
  omega

/-- Exact classification, including the inhabited exceptional control. -/
theorem primeWaypoint024_iff (p : ℕ) : PrimeWaypoint024 p ↔ p = 3 := by
  constructor
  · exact primeWaypoint024_eq_three
  · rintro rfl
    norm_num [PrimeWaypoint024]

/-- `(7,11)` is a real endpoint witness, not merely a locally admissible
residue pattern. -/
theorem endpoint04_seven : PrimeEndpoint04 7 := by
  norm_num [PrimeEndpoint04]

/-- The same endpoint cannot pass through the materialized `+2` waypoint. -/
theorem waypoint024_seven_obstructed : ¬ PrimeWaypoint024 7 := by
  norm_num [PrimeWaypoint024]

/-- Actual-prime decomposition loss: endpoint feasibility together with
emptiness of the proposed waypoint fiber at that endpoint. -/
theorem primePairDecompositionLoss :
    PrimeEndpoint04 7 ∧ ¬ PrimeWaypoint024 7 :=
  ⟨endpoint04_seven, waypoint024_seven_obstructed⟩

end Pairfield

