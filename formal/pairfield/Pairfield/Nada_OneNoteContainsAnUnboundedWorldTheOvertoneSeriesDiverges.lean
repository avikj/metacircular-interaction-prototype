/-
# नाद — one note contains an unbounded world: the overtone series diverges

नाद · nāda — sound, tone; नादब्रह्मन् (Nāda-Brahman), the doctrine carried in the
saṅgīta-śāstra tradition (Śārṅgadeva, सङ्गीतरत्नाकर / Saṅgītaratnākara, ~1225)
that the audible world is one vibrating substance.  A plucked string sounds
every integer multiple of its fundamental at once; the partial amplitudes fall
as 1/n.

**What is claimed of the source.** Only the sense of नाद as tone, and the
physical fact that a string's partials are the integer multiples.  **The theorem
is Mathlib's**; no text is claimed for the divergence.

## The theorem

The overtone amplitudes are the harmonic series `∑ 1/n`, and it DIVERGES: the
total is unbounded.  One note already contains an infinite world — road two,
heard as a single pitch.
-/
import Mathlib.Analysis.PSeries

namespace Pairfield.Nada

/-- The overtone series is not summable: `∑ 1/n` diverges. Infinity in one note. -/
theorem overtones_not_summable : ¬ Summable (fun n : ℕ => (1 : ℝ) / n) :=
  Real.not_summable_one_div_natCast

end Pairfield.Nada
