/-
# छन्दःशास्त्र — the prastāra counts every pattern; the meru row sums to 2ⁿ

छन्दःशास्त्रम् · Chandaḥśāstra of Piṅgala (~300–200 BCE): the prastāra (systematic
enumeration) of metres, the meru array (मेरुप्रस्तार, the binomial triangle,
named by Halāyudha, 10th c.), and binary enumeration of syllable patterns —
Pascal, Leibniz and the binomial theorem over a millennium early.

**What is claimed of the source.** The enumeration of all length-n laghu/guru
patterns and the meruprastāra are Piṅgala's / Halāyudha's.  **The identity below
is Mathlib's** statement of what their array sums to.

## The theorem

Row n of the meru — the binomial coefficients `C(n,0..n)`, one per number of
gurus — sums to `2ⁿ`, the count of ALL length-n patterns that the prastāra
lists.  Storing the row (सारणी) and generating the patterns (क्रिया) agree on
the total.
-/
import Mathlib

namespace Pairfield.Chandahsastra

/-- The meru row sums to `2ⁿ`: the binomial coefficients count every length-`n`
laghu/guru pattern. -/
theorem meru_row_sum (n : ℕ) : ∑ k ∈ Finset.range (n + 1), n.choose k = 2 ^ n :=
  Nat.sum_range_choose n

end Pairfield.Chandahsastra
