import Pairfield.EuclidCoefficientTrace

/-!
# युग्म-पूरणम् — the even padding is forced, and the determinant says why

## What this is

Two no-decoder theorems already stand in this lane, proved by two unrelated
arguments, and each of them is refuted by a witness pair whose lengths differ
by **exactly two**:

* `Pairfield.no_historical_actionCost_decoder` (`Pairfield/DiagonalSmithRoute.lean`)
  — `kuttaka610Transcript` `⟨[0,1,1,2], [-1,-5]⟩` against
  `paddedKuttaka610Transcript` `⟨[0,0,0,1,1,2], [-1,-5]⟩`, a padding of `+2`;
* `Pairfield.CoefficientWitness.no_value_cost_decoder`
  (`Pairfield/EuclidCoefficientTrace.lean`) — `one` `[inc]` against
  `paddedOne` `[inc, inc, dec]`, a padding of `+2` again.

Neither file says that the `+2` was **forced**.  It was.  A padding of odd
length is impossible as a counterexample in either theorem, so the two
theorems are not merely true: they are **tight at the parity quotient**, and
this module is the proof of that tightness, stated natively in Lean.

## The two arguments, and that they are one argument

* **Matrix side.**  `IntMat2.euclidStep q = ⟨0, 1, 1, -q⟩` has determinant
  `0 * (-q) - 1 * 1 = -1` for every `q`, uniformly.  `det` is multiplicative,
  so a word of `n` Euclidean steps has determinant `(-1)^n`.  Two steps leave
  it where it was; one step negates it, and `1 ≠ -1` in `Int`.
* **Coefficient side.**  `inc` adds one and `dec` subtracts one, so each step
  flips the parity of the running integer: `value ≡ length (mod 2)`.

They are the same statement about two different length-graded sign
homomorphisms — `(-1)^length` in the multiplicative group `{1, -1}` and
`length mod 2` in `ℤ/2`.  §3 records that identification as an equation
rather than as a remark.

## Relation to the Agda lane

`formal/cubical/YugmaPurana_TheValliRecoversItsLengthModuloTwoAndNoFurther.agda`
proves the same thing about Āryabhaṭa's वल्ली: `detReplay` gives
`det (replay v) ≡ (-1)^(length v)` for the step matrices `L q = (q 1 / 1 0)`,
and its §5 states the transfer to this lane as **owed, not done** — grade
three, "a real channel, to be constructed rather than asserted", because the
Lean statements live over a different matrix type in a system without
univalence.  This file is that construction.  It is **not** an import, a
translation, or a transport: nothing crosses the lane boundary.  It is the
same mathematics proved a second time against the objects that are actually
here, which is what a grade-three channel is.

Note the matrices are not literally the same: `L q = (q 1 / 1 0)` and
`euclidStep q = (0 1 / 1 -q)`.  Both are in the family `{M : det M = -1}`,
and the determinant argument needs nothing more of either than that.

## What is and is not claimed of the source

The वल्ली is Āryabhaṭa's — *Āryabhaṭīya*, Gaṇitapāda 32–33 (499 CE),
*"śeṣaṃ rakṣa"*, keep the remainder; the column worked out in Bhāskara I's
*Āryabhaṭīyabhāṣya* (629).  Āryabhaṭa proved nothing below and none of this is
attributed to him.  What is claimed is only that the object priced here is the
column of quotients his procedure produces.  युग्म ("pair, even") and पूरण
("filling, padding") are used in their plain senses; **no text is claimed for
the compound, which was built in this repository** (the same declaration the
Agda module makes).

## Discipline

No `sorry`, no `admit`, no `axiom`, and **no `native_decide`**: every decision
below is either a kernel `decide` or an ordinary proof term.  Verified under
`lake build`, Lean 4.33.0 with mathlib `v4.33.0`.
-/

namespace Pairfield

/-! ## 0 · चिह्नम् — the sign of a length, computed

`(-1)^n` in `Int` decided by `n % 2`, so the two lanes below can both hand
their length to one function and read a parity back. -/

theorem neg_one_pow_eq_ite (n : Nat) :
    (-1 : Int) ^ n = if n % 2 = 0 then 1 else -1 := by
  induction n with
  | zero => norm_num
  | succ k ih =>
      rcases Nat.mod_two_eq_zero_or_one k with h | h
      · have h1 : (k + 1) % 2 = 1 := by omega
        rw [pow_succ, ih, if_pos h, h1]
        norm_num
      · have h0 : ¬ k % 2 = 0 := by omega
        have h1 : (k + 1) % 2 = 0 := by omega
        rw [pow_succ, ih, if_neg h0, h1]
        norm_num

/-- The sign reads the length modulo two **and separates it**: equal signs
force equal parity.  This is the "no further" half — the determinant is not
merely invariant under even padding, it is a faithful function of the parity,
so odd padding is visible. -/
theorem parity_of_neg_one_pow_eq {n m : Nat}
    (h : (-1 : Int) ^ n = (-1 : Int) ^ m) : n % 2 = m % 2 := by
  rw [neg_one_pow_eq_ite n, neg_one_pow_eq_ite m] at h
  split_ifs at h with h1 h2 h2 <;> omega

/-! ## 1 · निर्धारकः गुणनीयः — the determinant is multiplicative

Multiplicativity is **not** restated here: `IntMat2.det_mul` already stands in
`Pairfield/SmithPresentation.lean`, where it was proved for the unimodularity
of products.  Only the two facts that file has no reason to carry are added. -/

namespace IntMat2

theorem det_one : IntMat2.one.det = 1 := by decide

/-- Every Euclidean step matrix has determinant `-1`, uniformly in `q`.  This
one line is the whole mechanism: the quotient does not appear in the answer,
so the determinant cannot see which quotients were used, only how many. -/
theorem det_euclidStep (q : Int) : (IntMat2.euclidStep q).det = -1 := by
  simp [IntMat2.det, IntMat2.euclidStep]

end IntMat2

/-! ## 2 · वल्ल्याः दैर्घ्यं द्वाभ्यां भागम् — the word's length, modulo two -/

namespace DiagonalEuclidTranscript

/-- The accumulated left action of an `n`-letter word has determinant
`(-1)^n`.  The Agda counterpart is `KuttakaValli.detReplay`. -/
theorem det_leftWord (qs : List Int) :
    (leftWord qs).det = (-1 : Int) ^ qs.length := by
  induction qs with
  | nil => simpa [leftWord] using IntMat2.det_one
  | cons q qs ih =>
      rw [leftWord, IntMat2.det_mul, ih, IntMat2.det_euclidStep,
        List.length_cons, pow_succ]

theorem det_rightWord (qs : List Int) :
    (rightWord qs).det = (-1 : Int) ^ qs.length := by
  induction qs with
  | nil => simpa [rightWord] using IntMat2.det_one
  | cons q qs ih =>
      rw [rightWord, IntMat2.det_mul, ih, IntMat2.det_euclidStep,
        List.length_cons, pow_succ, mul_comm]

/-! ### युग्म-पूरणम् अदृश्यम् — an even padding is invisible -/

/-- Two steps prepended leave the determinant exactly where it was, because
`(-1) * (-1) = 1`.  This is why both counterexamples in this lane pad by `+2`,
and `paddedKuttaka610Transcript` pads by `swap²` specifically. -/
theorem det_leftWord_cons_cons (q r : Int) (qs : List Int) :
    (leftWord (q :: r :: qs)).det = (leftWord qs).det := by
  rw [det_leftWord, det_leftWord, List.length_cons, List.length_cons,
    pow_succ, pow_succ]
  ring

theorem det_rightWord_cons_cons (q r : Int) (qs : List Int) :
    (rightWord (q :: r :: qs)).det = (rightWord qs).det := by
  rw [det_rightWord, det_rightWord, List.length_cons, List.length_cons,
    pow_succ, pow_succ]
  ring

/-! ### विषम-पूरणम् दृश्यम् — an odd padding is visible -/

/-- One step prepended **negates** the determinant. -/
theorem det_leftWord_cons (q : Int) (qs : List Int) :
    (leftWord (q :: qs)).det = -(leftWord qs).det := by
  rw [det_leftWord, det_leftWord, List.length_cons, pow_succ]
  ring

theorem det_rightWord_cons (q : Int) (qs : List Int) :
    (rightWord (q :: qs)).det = -(rightWord qs).det := by
  rw [det_rightWord, det_rightWord, List.length_cons, pow_succ]
  ring

/-- A determinant of a Euclidean word is never zero, so §"odd padding is
visible" really does separate: an odd padding cannot be endpoint-invisible. -/
theorem det_leftWord_ne_zero (qs : List Int) : (leftWord qs).det ≠ 0 := by
  rw [det_leftWord, neg_one_pow_eq_ite]
  split_ifs <;> decide

/-- A single step is always endpoint-**visible**: the two accumulated left
matrices differ.  This is the statement that closes the `+2`: no
counterexample to `no_historical_actionCost_decoder` can pad by one. -/
theorem leftWord_cons_ne (q : Int) (qs : List Int) :
    leftWord (q :: qs) ≠ leftWord qs := by
  intro h
  have hd : (leftWord (q :: qs)).det = (leftWord qs).det := by rw [h]
  rw [det_leftWord_cons] at hd
  exact det_leftWord_ne_zero qs (by omega)

/-- **The tightness of `no_historical_actionCost_decoder`.**  Equal endpoints
force equal length-parity on each side.  The endpoint matrices are a *partial*
decoder: they do not recover the word length, but they recover it exactly
modulo two. -/
theorem leftWord_eq_parity {qs rs : List Int} (h : leftWord qs = leftWord rs) :
    qs.length % 2 = rs.length % 2 := by
  apply parity_of_neg_one_pow_eq
  rw [← det_leftWord, ← det_leftWord, h]

theorem rightWord_eq_parity {qs rs : List Int}
    (h : rightWord qs = rightWord rs) : qs.length % 2 = rs.length % 2 := by
  apply parity_of_neg_one_pow_eq
  rw [← det_rightWord, ← det_rightWord, h]

end DiagonalEuclidTranscript

/-- **Every witness pair refuting `no_historical_actionCost_decoder` has an
even action-cost gap.**  Two transcripts with the same accumulated left and
right matrices have action costs of the same parity, so the difference the
counterexample exhibits is necessarily even, and `+2` is its least possible
nonzero value.  `paddedKuttaka610_same_endpoint_different_cost` (8 against 6)
is therefore optimal as a witness, not merely convenient. -/
theorem endpoints_force_even_actionCost_gap
    (t u : DiagonalEuclidTranscript)
    (hl : t.leftMatrix = u.leftMatrix)
    (hr : t.rightMatrix = u.rightMatrix) :
    t.actionCost % 2 = u.actionCost % 2 := by
  have hlp := DiagonalEuclidTranscript.leftWord_eq_parity hl
  have hrp := DiagonalEuclidTranscript.rightWord_eq_parity hr
  simp only [DiagonalEuclidTranscript.actionCost]
  omega

/-- The instance, checked: the witness pair actually in the lane obeys the
constraint the theorem above says it had to. -/
theorem kuttaka610_padding_is_even :
    paddedKuttaka610Transcript.actionCost % 2 =
      kuttaka610Transcript.actionCost % 2 ∧
    paddedKuttaka610Transcript.actionCost -
      kuttaka610Transcript.actionCost = 2 := by
  decide

/-! ## 3 · The coefficient lane, and that it is the same statement

`SignedUnitStep` carries no matrices at all.  Its no-decoder theorem is proved
by arithmetic on `Int`.  It is nevertheless the same obstruction: `inc` and
`dec` both flip the parity of the running value, exactly as `euclidStep q`
negates the determinant. -/

/-- One step changes the running integer by an odd amount, so replay advances
value-parity in lockstep with length. -/
theorem runCoefficientTrace_emod_two (z : Int) (t : List SignedUnitStep) :
    runCoefficientTrace z t % 2 = (z + (t.length : Int)) % 2 := by
  induction t generalizing z with
  | nil => simp [runCoefficientTrace]
  | cons step steps ih =>
      rw [runCoefficientTrace, ih]
      cases step <;> simp [SignedUnitStep.apply, List.length_cons] <;> omega

/-- **`value ≡ cost (mod 2)`, identically.**  A coefficient witness's integer
and its historical work agree modulo two, for every witness. -/
theorem CoefficientWitness.value_emod_two (w : CoefficientWitness) :
    w.value % 2 = (w.cost : Int) % 2 := by
  rw [← w.valid]
  rw [runCoefficientTrace_emod_two]
  simp [CoefficientWitness.cost]

/-- **The tightness of `no_value_cost_decoder`.**  Two witnesses of the same
integer have costs of the same parity, so the padding exhibited by any
counterexample is forced to be even, and `paddedOne` (3 against 1) is at the
least possible nonzero gap.  The `value` map is a *partial* decoder: it does
not recover the cost, but it recovers `cost mod 2` exactly. -/
theorem CoefficientWitness.value_forces_cost_parity
    (v w : CoefficientWitness) (h : v.value = w.value) :
    v.cost % 2 = w.cost % 2 := by
  have hv := CoefficientWitness.value_emod_two v
  have hw := CoefficientWitness.value_emod_two w
  rw [h] at hv
  omega

theorem one_paddedOne_padding_is_even :
    CoefficientWitness.paddedOne.cost % 2 =
      CoefficientWitness.one.cost % 2 ∧
    CoefficientWitness.paddedOne.cost - CoefficientWitness.one.cost = 2 := by
  decide

/-! ## 4 · शेषः — what this does not say

* It does not say the endpoint matrices determine the word up to parity.  They
  forget the quotients entirely; `det` sees only the length, and only its
  parity.  The claim is about the coordinate the two counterexamples were
  built to defeat, not about the fiber.
* It does not say a **minimal** word length is undecodable.  Both no-decoder
  theorems are about *historical* cost, and
  `kuttaka610_leftWord_length_ge_four` in `DiagonalSmithRoute.lean` is the
  living proof that the shortest-word question is a different and answerable
  one.
* It does not transport anything from the Agda lane.  See the header: the two
  proofs are independent, and their agreeing is the content.
-/

end Pairfield
