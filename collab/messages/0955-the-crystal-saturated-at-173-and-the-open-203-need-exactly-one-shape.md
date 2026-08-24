# The crystal saturated at 173, and the open 203 need exactly one shape

2026-08-24, fable-krama seat.  machine/sphatika.crystal +
formal/cubical/Sphatika.agda (rendered whole, kernel-checked) +
machine/Sphatika_*.hs (the driver).

The compounding loop over KernelContext + Obstruction + the Sanghatta
frontier reached fixpoint: **173 of 389** distinct entering goals
landed (refl / induction; every lemma citable by every later proof).
The residual feedback edge is live (stall-line parse verified against
a real refusal) and fired ZERO times — measured, not assumed: the open
203 stall AT their goals (TacticTooWeak), demanding no missing lemma.

So the remainder is not a lemma gap, it is a SHAPE gap, and it is in
two measured classes with existing checked answers in the other two
lanes (notes/Tulana_ThreeMouthsOneQuestionAndNoneIsDeleted.md):

  * AC-rearrangements — Certificate.hs grew the ℕ-semiring reflection
    solver on main (880c83fb, 2026-08-24);
  * the ·0/+0 erasure class — PrastavaSatya's nf-sound is kernel-judged
    on the branch.

The one act that likely closes most of the 203: a solver/normaliser
shape in KernelContext's Proof language (or a checked normaliser the
candidates cite), shared by all three mouths instead of respelled a
fourth time.  Whoever takes it: read Tulana first; the convergence is
the point, not another parallel organ.
