/-
# व्यास → परिधि — the alternating odd-denominator series for the circumference

## The source, with text and date

Mādhava of Saṅgamagrāma (c. 1340 – c. 1425), Kerala.  Mādhava's own works on
this are lost; the series survives because his successors quote him by name.
The verse is given in Nīlakaṇṭha Somayāji's *Tantrasaṅgraha* (1501) and in
Śaṅkara Vāriyar's commentary *Yuktidīpikā*, and it is **derived** — with the
rectification argument, not merely stated — in Jyeṣṭhadeva's *Yuktibhāṣā*
(Malayalam, c. 1530), which attributes it to Mādhava.

    व्यासाच्चतुर्घ्नाद् बहुशः पृथक्स्थात्
    त्रिपञ्चसप्ताद्ययुगाहृतेषु ।
    ऋणं स्वमन्त्याद् ... परिधिः

    "From the *vyāsa* multiplied by four, set down repeatedly and separately,
     divided by the odd numbers three, five, seven, …; *ṛṇa* (subtract) and
     *sva* (add) alternately — [the result is] the *paridhi*."

Two magnitudes and two signs, and the file uses the source's four words for
them: `vyasa` (diameter), `paridhi` (circumference), and the ṛṇa/sva
alternation carried by `(-1) ^ i`.  This repository already uses the same
ṛṇa/dhana pair for a sign coordinate elsewhere; the pairing is Brahmagupta's
(*Brāhmasphuṭasiddhānta*, 628) and Mādhava's verse inherits it.

Priority: Mādhava precedes James Gregory (1671) and Gottfried Leibniz (1673)
by roughly 250 years.  Mathlib carries the statement as
`Real.tendsto_sum_pi_div_four`, docstring "**Leibniz's series for `π`**".
That is the restatement.  This module states the source's form and derives it
from mathlib's; the ordering of the two is the point, and mathlib's name is
named second, as a restatement, per CLAUDE.md.

## What is and is not claimed of the source

CLAIMED: that the identity below is the content of the verse above, in the
verse's own variables — an arbitrary *vyāsa*, four times it, divided by the
successive odd numbers, alternately subtracted and added, converging to the
*paridhi*.

NOT CLAIMED: that Mādhava proved a `Filter.Tendsto` statement, or possessed
this notion of a limit.  The *Yuktibhāṣā*'s derivation is a rectification of
the arc by successive subdivision with an explicitly stated remainder; what
is formalised here is the series and its sum, not that argument.

NOT CLAIMED, and this is the larger omission: Mādhava's *saṃskāra* — the end
correction terms that make the slowly-convergent series usable, and which are
the sharper half of the achievement (*Tantrasaṅgraha* 2.271–274, three
successively better correctors, the third with error O(n⁻⁶)).  None of that
discipline: the *āsanna* — the source says in the verse itself that the value
is approximate, and the tradition that inherited it dropped the word.  A
module that formalises the series and omits the correctors should say so
rather than let the name stand for the whole.


## The other lane already declared this gap, and did not fill it falsely

`formal/cubical/Madhava.agda` (`--cubical --safe`) proves the finite
geometric-series identity over ℤ that the *Yuktibhāṣā*'s derivation is built
on — `(1 − r) · ∑_{k<n} rᵏ ≡ 1 − rⁿ`, a ring identity, no limit — and its
honesty section says, in Sanskrit, exactly what it is not doing:

    सत्यनिष्ठा (avaktavya) : यत् माधवः वस्तुतः साधितवान् — शेष-पदस्य
    (rⁿ/(1−r)) शून्याभिमुख-गमनम्, यतः अनन्त-योगः 1/(1−r) — तत् ℝ/ℚ-
    विश्लेषण-आधारं विना अत्र न साध्यम् । शेष-पदम् एव सारः ; तत् इह
    अनुक्तम्, न मिथ्या-सिद्धम् ।

*"What Mādhava actually established — that the remainder term rⁿ/(1−r) goes to
zero, whence the infinite sum is 1/(1−r) — is not provable here without an
ℝ/ℚ analytic base. The remainder term IS the substance; here it is left
unstated, not falsely proved."*

That is the fourth position, *avaktavyam*, used correctly: not "unknown", not
"undefined", a declared standpoint with the residue named. This module is the
other half. It has the ℝ analytic base (mathlib), so it can state the limit the
Agda module correctly refused to assert — and it does not have univalence, set
quotients or `--safe`, so it cannot do what that module does.

Neither subsumes the other and neither should. The two lanes meet **here**, in
a statement that completes a declared gap, and not by sharing a kernel; the
argument is §4 of
Left undone, and named rather than done: the join — Mādhava's *saṃskāra*
correctors, which are what turn the Agda module's remainder term into a usable
error bound, and which are formalised in neither lane.

## History of this file

Landed empty on 2026-08-18 in commit `e2772cca` ("Brahmagupta's bhavana and
Pingala's matrameru, both checked"), whose message does not mention it: three
`import` lines, no declaration.  A module carrying Mādhava's name and
containing no mathematics is the naming fault this repository's own file-name
rule exists to prevent, in its purest form — the name asserted, the content
absent, and the build green because an empty module typechecks.  The imports
were the intent; this is that intent discharged.
-/
import Mathlib.Analysis.Real.Pi.Leibniz
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.SpecificLimits.Normed

namespace Pairfield.Madhava

open Filter Finset
open scoped Topology

/-- The verse's summand: the *vyāsa* multiplied by four, divided by the
`i`-th odd number, taken *ṛṇa* or *sva* according to parity. -/
noncomputable def pada (vyasa : ℝ) (i : ℕ) : ℝ :=
  (-1 : ℝ) ^ i * (4 * vyasa) / (2 * i + 1)

/-- **Mādhava's series for the circumference**, in the source's variables.

For any *vyāsa* `d`, the partial sums of `4d/1 − 4d/3 + 4d/5 − 4d/7 + ⋯`
converge to the *paridhi* `π d`.

Derived from `Real.tendsto_sum_pi_div_four` (mathlib's statement of the same
series, under Leibniz's name), which is the restatement, not the source. -/
theorem tendsto_paridhi (vyasa : ℝ) :
    Tendsto (fun n => ∑ i ∈ range n, pada vyasa i) atTop (𝓝 (Real.pi * vyasa)) := by
  have hsum : ∀ n : ℕ,
      ∑ i ∈ range n, pada vyasa i
        = (4 * vyasa) * ∑ i ∈ range n, (-1 : ℝ) ^ i / (2 * i + 1) := by
    intro n
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl (fun i _ => ?_)
    unfold pada
    ring
  simp only [hsum]
  have := Real.tendsto_sum_pi_div_four.const_mul (4 * vyasa)
  have heq : (4 * vyasa) * (Real.pi / 4) = Real.pi * vyasa := by ring
  rwa [heq] at this

/-- The unit-*vyāsa* case, which is the number the series is usually quoted
for: the alternating sum of `4/(2i+1)` converges to `π`. -/
theorem tendsto_paridhi_one :
    Tendsto (fun n => ∑ i ∈ range n, pada 1 i) atTop (𝓝 Real.pi) := by
  have := tendsto_paridhi 1
  rwa [mul_one] at this

end Pairfield.Madhava
