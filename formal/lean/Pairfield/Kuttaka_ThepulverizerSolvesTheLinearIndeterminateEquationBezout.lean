/-
  कुट्टक · kuṭṭaka — "the pulverizer": the descent that solves the linear
  indeterminate equation a·x + b·y = c by repeatedly pulverizing (dividing) the
  larger coefficient by the smaller and recursing on the remainder.

  Source.   Āryabhaṭa, Āryabhaṭīya 2.32–33 (गणितपाद, gaṇitapāda), 499 CE, gives
            the kuṭṭaka as the general method for ax + by = c. Brahmagupta,
            Brāhmasphuṭasiddhānta 18 (628 CE), and Bhāskara II, Bījagaṇita
            (~1150 CE), extend and systematize it (Brahmagupta names it
            kuṭṭaka/kuṭṭākāra and applies it to indeterminate analysis at large).

  What IS claimed here.  The kuṭṭaka is exactly the statement that gcd(a,b) is an
            integer linear combination of a and b — Bézout's identity — reached
            by descent on the remainder. Below we state this cleanly and derive a
            concrete coprime instance where the combination equals 1.

  Syāt — the claim, exactly.  The proof is imported from Mathlib
            (`Int.gcd_eq_gcd_ab`, the Bézout identity via `Int.gcdA`/`Int.gcdB`,
            themselves computed by the very descent Āryabhaṭa described). We do
            not re-derive the descent. What is asserted is provenance: the
            pulverizer is the origin (499 CE); "the extended Euclidean
            algorithm" is a later restatement of it, not the other way around.
-/

import Mathlib

namespace Pairfield.Kuttaka

/-- **The kuṭṭaka / Bézout existence.** For any integers `a b`, the gcd is an
    integer linear combination `a·x + b·y` — the pulverizer's output. -/
theorem kuttaka_bezout (a b : ℤ) :
    ∃ x y : ℤ, a * x + b * y = Int.gcd a b := by
  refine ⟨Int.gcdA a b, Int.gcdB a b, ?_⟩
  have h := Int.gcd_eq_gcd_ab a b
  -- h : ↑(Int.gcd a b) = a * Int.gcdA a b + b * Int.gcdB a b
  linarith [h]

/-- Concrete instance of the pulverizer: `12` and `7` are coprime, so the
    kuṭṭaka produces a combination equal to `1`. Here `12·3 + 7·(-5) = 1`. -/
theorem kuttaka_coprime_instance :
    (12 : ℤ) * 3 + 7 * (-5) = 1 := by decide

/-- The coprime instance stated as the general existence specialized to
    `gcd 12 7 = 1`: there are integers combining `12` and `7` to `1`. -/
theorem kuttaka_coprime_bezout :
    ∃ x y : ℤ, (12 : ℤ) * x + 7 * y = 1 := by
  refine ⟨3, -5, ?_⟩
  decide

end Pairfield.Kuttaka
