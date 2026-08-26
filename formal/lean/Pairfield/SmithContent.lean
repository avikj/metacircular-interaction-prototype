import Pairfield.GeneralSmith2x2

/-!
# The first invariant factor is the content

`GeneralSmith2x2.lean` proves the producer correct but says nothing about
*which* diagonal it lands on beyond the normal-form side conditions.  The
missing identification is

  `(smith A).d₁ = gcd(a₀₀, a₀₁, a₁₀, a₁₁)`,

listed as open.  This module proves it.

The mechanism is not the descent at all: the content of a matrix is invariant
under multiplication by any unimodular matrix on either side, because a
unimodular matrix over `ℤ` has an *integral* inverse.  So the identity holds
for every valid Smith presentation, not only for the one this producer emits —
which is the more useful statement, and the reason it is proved here rather
than threaded through `clearColumn`/`clearRow` as another invariant field.
-/

namespace Pairfield

namespace IntMat2

/-- The content: the gcd of all four entries. -/
def content (A : IntMat2) : Nat :=
  Nat.gcd (Int.gcd A.a00 A.a01) (Int.gcd A.a10 A.a11)

theorem content_dvd_iff (A : IntMat2) (n : Nat) :
    n ∣ A.content ↔
      ((n : Int) ∣ A.a00 ∧ (n : Int) ∣ A.a01 ∧
       (n : Int) ∣ A.a10 ∧ (n : Int) ∣ A.a11) := by
  unfold content
  constructor
  · intro h
    have hl : n ∣ Int.gcd A.a00 A.a01 :=
      Nat.dvd_trans h (Nat.gcd_dvd_left _ _)
    have hr : n ∣ Int.gcd A.a10 A.a11 :=
      Nat.dvd_trans h (Nat.gcd_dvd_right _ _)
    exact ⟨(Int.dvd_gcd_iff.mp hl).1, (Int.dvd_gcd_iff.mp hl).2,
      (Int.dvd_gcd_iff.mp hr).1, (Int.dvd_gcd_iff.mp hr).2⟩
  · rintro ⟨h00, h01, h10, h11⟩
    exact Nat.dvd_gcd (Int.dvd_gcd h00 h01) (Int.dvd_gcd h10 h11)

theorem content_dvd_entries (A : IntMat2) :
    ((A.content : Int) ∣ A.a00 ∧ (A.content : Int) ∣ A.a01 ∧
     (A.content : Int) ∣ A.a10 ∧ (A.content : Int) ∣ A.a11) :=
  (content_dvd_iff A A.content).mp (Nat.dvd_refl _)

/-- The integral inverse of a unimodular matrix: `det U` is its own reciprocal,
so no division is needed. -/
def inv (U : IntMat2) : IntMat2 :=
  ⟨U.det * U.a11, -(U.det * U.a01), -(U.det * U.a10), U.det * U.a00⟩

theorem inv_mul (U : IntMat2) (h : U.unimodular) : U.inv * U = one := by
  have hd : U.det * U.det = 1 := by
    have : U.det = 1 ∨ U.det = -1 := by unfold IntMat2.unimodular at h; omega
    rcases this with hdet | hdet <;> rw [hdet] <;> decide
  apply IntMat2.ext
  · show U.det * U.a11 * U.a00 + -(U.det * U.a01) * U.a10 = (1 : Int)
    have key : U.det * U.a11 * U.a00 + -(U.det * U.a01) * U.a10
        = U.det * U.det := by simp only [det]; ring
    rw [key, hd]
  · show U.det * U.a11 * U.a01 + -(U.det * U.a01) * U.a11 = (0 : Int)
    ring
  · show -(U.det * U.a10) * U.a00 + U.det * U.a00 * U.a10 = (0 : Int)
    ring
  · show -(U.det * U.a10) * U.a01 + U.det * U.a00 * U.a11 = (1 : Int)
    have key : -(U.det * U.a10) * U.a01 + U.det * U.a00 * U.a11
        = U.det * U.det := by simp only [det]; ring
    rw [key, hd]

theorem mul_inv (U : IntMat2) (h : U.unimodular) : U * U.inv = one := by
  have hd : U.det * U.det = 1 := by
    have : U.det = 1 ∨ U.det = -1 := by unfold IntMat2.unimodular at h; omega
    rcases this with hdet | hdet <;> rw [hdet] <;> decide
  apply IntMat2.ext
  · show U.a00 * (U.det * U.a11) + U.a01 * -(U.det * U.a10) = (1 : Int)
    have key : U.a00 * (U.det * U.a11) + U.a01 * -(U.det * U.a10)
        = U.det * U.det := by simp only [det]; ring
    rw [key, hd]
  · show U.a00 * -(U.det * U.a01) + U.a01 * (U.det * U.a00) = (0 : Int)
    ring
  · show U.a10 * (U.det * U.a11) + U.a11 * -(U.det * U.a10) = (0 : Int)
    ring
  · show U.a10 * -(U.det * U.a01) + U.a11 * (U.det * U.a00) = (1 : Int)
    have key : U.a10 * -(U.det * U.a01) + U.a11 * (U.det * U.a00)
        = U.det * U.det := by simp only [det]; ring
    rw [key, hd]

/-- A `ℤ`-linear combination of two multiples of `n` is a multiple of `n`.
Proved by hand so this module needs no import beyond the producer. -/
theorem int_dvd_combo {n a b : Int} (ha : n ∣ a) (hb : n ∣ b) (x y : Int) :
    n ∣ x * a + y * b := by
  obtain ⟨p, hp⟩ := ha
  obtain ⟨q, hq⟩ := hb
  exact ⟨x * p + y * q, by rw [hp, hq]; ring⟩

theorem int_dvd_combo' {n a b : Int} (ha : n ∣ a) (hb : n ∣ b) (x y : Int) :
    n ∣ a * x + b * y := by
  obtain ⟨p, hp⟩ := ha
  obtain ⟨q, hq⟩ := hb
  exact ⟨p * x + q * y, by rw [hp, hq]; ring⟩

theorem content_dvd_mul_left (U A : IntMat2) : A.content ∣ (U * A).content := by
  obtain ⟨h00, h01, h10, h11⟩ := content_dvd_entries A
  refine (content_dvd_iff _ _).mpr ⟨?_, ?_, ?_, ?_⟩
  · show (A.content : Int) ∣ U.a00 * A.a00 + U.a01 * A.a10
    exact int_dvd_combo h00 h10 _ _
  · show (A.content : Int) ∣ U.a00 * A.a01 + U.a01 * A.a11
    exact int_dvd_combo h01 h11 _ _
  · show (A.content : Int) ∣ U.a10 * A.a00 + U.a11 * A.a10
    exact int_dvd_combo h00 h10 _ _
  · show (A.content : Int) ∣ U.a10 * A.a01 + U.a11 * A.a11
    exact int_dvd_combo h01 h11 _ _

theorem content_dvd_mul_right (A V : IntMat2) : A.content ∣ (A * V).content := by
  obtain ⟨h00, h01, h10, h11⟩ := content_dvd_entries A
  refine (content_dvd_iff _ _).mpr ⟨?_, ?_, ?_, ?_⟩
  · show (A.content : Int) ∣ A.a00 * V.a00 + A.a01 * V.a10
    exact int_dvd_combo' h00 h01 _ _
  · show (A.content : Int) ∣ A.a00 * V.a01 + A.a01 * V.a11
    exact int_dvd_combo' h00 h01 _ _
  · show (A.content : Int) ∣ A.a10 * V.a00 + A.a11 * V.a10
    exact int_dvd_combo' h10 h11 _ _
  · show (A.content : Int) ∣ A.a10 * V.a01 + A.a11 * V.a11
    exact int_dvd_combo' h10 h11 _ _

theorem content_mul_left (U A : IntMat2) (h : U.unimodular) :
    (U * A).content = A.content := by
  refine Nat.dvd_antisymm ?_ (content_dvd_mul_left U A)
  have hback := content_dvd_mul_left U.inv (U * A)
  rwa [← mul_assoc, inv_mul U h, one_mul] at hback

theorem content_mul_right (A V : IntMat2) (h : V.unimodular) :
    (A * V).content = A.content := by
  refine Nat.dvd_antisymm ?_ (content_dvd_mul_right A V)
  have hback := content_dvd_mul_right (A * V) V.inv
  rwa [mul_assoc, mul_inv V h, mul_one] at hback

theorem content_diagonal (d e : Int) (_hd : 0 ≤ d) (hdvd : d ∣ e) :
    (diagonal d e).content = d.natAbs := by
  unfold content diagonal
  simp only [Int.gcd_zero_right, Int.gcd_zero_left]
  exact Nat.gcd_eq_left (Int.natAbs_dvd_natAbs.mpr hdvd)

end IntMat2

/-- Content is a complete invariant of the *presentation*, not of the
algorithm: any valid Smith certificate has `d₁ = content(source)`. -/
theorem SmithCertificate2.d₁_eq_content (c : SmithCertificate2) (h : c.Valid) :
    c.d₁ = (c.source.content : Int) := by
  obtain ⟨hrep, hL, hR, hd₁, hd₂, _, hdvd⟩ := h
  have h1 : (IntMat2.diagonal c.d₁ c.d₂).content = c.source.content := by
    rw [show IntMat2.diagonal c.d₁ c.d₂ = c.left * c.source * c.right from hrep,
      IntMat2.content_mul_right _ _ hR, IntMat2.content_mul_left _ _ hL]
  rw [IntMat2.content_diagonal c.d₁ c.d₂ hd₁ hdvd] at h1
  omega

/-- **The first invariant factor is the content of the input.**  Together with
`smith_det` (`d₁d₂ = |det A|`) this pins the emitted diagonal completely. -/
theorem smith_d₁_eq_content (A : IntMat2) : (smith A).d₁ = (A.content : Int) := by
  have h := SmithCertificate2.d₁_eq_content (smithCertificate A)
    (smithCertificate_valid A)
  exact h

/-- Consequently the whole diagonal is determined: `d₂ = |det A| / content A`
whenever the content is nonzero. -/
theorem smith_d₂_mul_content (A : IntMat2) :
    ((A.content : Int) * (smith A).d₂).natAbs = A.det.natAbs := by
  rw [← smith_d₁_eq_content A]
  exact smith_det A

end Pairfield
