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
import Pairfield.BoundedPrimePair

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
  have residues : p % 3 = 0 ∨ p % 3 = 1 ∨ p % 3 = 2 := by omega
  rcases residues with h0 | h1 | h2
  · have hdvd : 3 ∣ p := Nat.dvd_iff_mod_eq_zero.mpr h0
    exact ((Nat.prime_dvd_prime_iff_eq hprime3 hp).mp hdvd).symm
  · have hmod : (p + 2) % 3 = 0 := by omega
    have hdvd : 3 ∣ p + 2 := Nat.dvd_iff_mod_eq_zero.mpr hmod
    have heq : 3 = p + 2 := (Nat.prime_dvd_prime_iff_eq hprime3 hp2).mp hdvd
    have hp_ne_one : p ≠ 1 := hp.ne_one
    omega
  · have hmod : (p + 4) % 3 = 0 := by omega
    have hdvd : 3 ∣ p + 4 := Nat.dvd_iff_mod_eq_zero.mpr hmod
    have heq : 3 = p + 4 := (Nat.prime_dvd_prime_iff_eq hprime3 hp4).mp hdvd
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

/-- The same actual witness installed in the common finite pair carrier. -/
def endpoint04SevenPair : BoundedPrimePair 11 :=
  mkBoundedPrimePair (X := 11) (p := 7) (q := 11)
    (by decide) (by decide) (by decide) (by decide)

@[simp] theorem endpoint04SevenPair_center :
    pairCenter endpoint04SevenPair = 18 := rfl

@[simp] theorem endpoint04SevenPair_gap :
    pairGap endpoint04SevenPair = 4 := rfl

/-- Goldbach/centre and gap views retain the identical pair witness. -/
def endpoint04SevenCenterFiber : PrimeCenterFiber 11 18 :=
  ⟨endpoint04SevenPair, endpoint04SevenPair_center⟩

def endpoint04SevenGapFiber : PrimeGapFiber 11 4 :=
  ⟨endpoint04SevenPair, endpoint04SevenPair_gap⟩

end Pairfield
