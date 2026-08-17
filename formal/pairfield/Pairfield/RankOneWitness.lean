import Mathlib
import Pairfield.RankOneSmith2x2
import Mathlib.Data.Int.GCD
import Mathlib.Tactic.LinearCombination

/-!
# A total producer of rank-one Smith witnesses

`Pairfield.RankOneSmith2x2.Witness` consumes an outer-product factorization
and two Bezout equations.  This file closes the remaining producer gap: from
a bare hypothesis `A.det = 0` it *computes* that data, with no `sorry`, no
`native_decide`, and no appeal to an external oracle.

The construction is two independent normalizations.

* A nonzero row `(u,v)` of `A` normalizes to a primitive direction `(p,q)`
  by dividing out `gcd(u,v)`; extended Euclid supplies the row Bezout pair.
* Vanishing determinant then forces the *other* row to be a multiple of the
  same `(p,q)`, and the multiplier is recovered by the projection
  `k = c·x + d·y` — no second gcd is needed for it.
* The resulting column `(g,k)` is normalized the same way, which produces the
  Smith invariant `h = gcd(g,k)` and the column Bezout pair.

The zero matrix has no nonzero row and is handled by the identity witness.
-/

namespace Pairfield.RankOneSmith2x2

open Pairfield

/-- Primitive normalization of an integer pair: the pair is its gcd times a
primitive direction, and the direction carries an explicit Bezout witness. -/
structure Primitive (u v : Int) where
  d : Int
  p : Int
  q : Int
  u_factor : u = d * p
  v_factor : v = d * q
  x : Int
  y : Int
  bezout : x * p + y * q = 1
  d_pos : 0 < d

/-- The gcd of a pair that is not `(0,0)` is positive. -/
theorem gcd_pos_nat_of_ne {u v : Int} (h : u ≠ 0 ∨ v ≠ 0) : 0 < Int.gcd u v := by
  refine Nat.pos_of_ne_zero ?_
  intro hz
  rcases h with h | h
  · exact h (Int.eq_zero_of_gcd_eq_zero_left hz)
  · exact h (Int.eq_zero_of_gcd_eq_zero_right hz)

theorem gcd_pos_of_ne {u v : Int} (h : u ≠ 0 ∨ v ≠ 0) : 0 < (Int.gcd u v : Int) := by
  exact_mod_cast gcd_pos_nat_of_ne h

/-! ### A kernel-executable extended Euclid

`Int.gcdA` and `Int.gcdB` are defined by well-founded recursion through
`Nat.xgcdAux`, so the kernel cannot evaluate them: `decide` gets stuck on
`Int.gcdA 2 3`.  A producer whose outputs cannot be reduced in the kernel is
only executable by the compiler, which is exactly the trust boundary this
repository refuses.  The recursion below is structural in an explicit fuel
argument, so it reduces, and its Bezout identity is proved outright. -/

/-- Extended Euclid with explicit fuel.  `xgcd fuel a b = (x, y)` satisfies
`x * a + y * b = gcd a b` as soon as `fuel` bounds `b.natAbs`. -/
def xgcd : Nat → Int → Int → Int × Int
  | 0, a, _ => (a.sign, 0)
  | fuel + 1, a, b =>
      if b = 0 then (a.sign, 0)
      else
        let r := xgcd fuel b (a % b)
        (r.2, r.1 - (a / b) * r.2)

theorem gcd_emod (a b : Int) : Int.gcd b (a % b) = Int.gcd a b := by
  have hmod : a % b = a - b * (a / b) := Int.emod_def a b
  refine Nat.dvd_antisymm ?_ ?_
  · have h1 : ((Int.gcd b (a % b) : Nat) : Int) ∣ b := Int.gcd_dvd_left b (a % b)
    have h2 : ((Int.gcd b (a % b) : Nat) : Int) ∣ a % b := Int.gcd_dvd_right b (a % b)
    have h3 : ((Int.gcd b (a % b) : Nat) : Int) ∣ a := by
      have h4 : ((Int.gcd b (a % b) : Nat) : Int) ∣ a % b + b * (a / b) :=
        dvd_add h2 (Dvd.dvd.mul_right h1 _)
      rwa [Int.emod_add_mul_ediv] at h4
    exact Int.dvd_gcd h3 h1
  · have h1 : ((Int.gcd a b : Nat) : Int) ∣ a := Int.gcd_dvd_left a b
    have h2 : ((Int.gcd a b : Nat) : Int) ∣ b := Int.gcd_dvd_right a b
    have h3 : ((Int.gcd a b : Nat) : Int) ∣ a % b := by
      rw [hmod]
      exact dvd_sub h1 (Dvd.dvd.mul_right h2 _)
    exact Int.dvd_gcd h2 h3

theorem natAbs_emod_lt {a b : Int} (hb : b ≠ 0) : (a % b).natAbs < b.natAbs := by
  have h0 : 0 ≤ a % b := Int.emod_nonneg a hb
  have h1 : a % b < |b| := Int.emod_lt_abs a hb
  have h2 : |b| = (b.natAbs : Int) := Int.abs_eq_natAbs b
  have h3 : ((a % b).natAbs : Int) = a % b := Int.natAbs_of_nonneg h0
  omega

/-- Correctness of the fuel-driven algorithm. -/
theorem xgcd_spec : ∀ (fuel : Nat) (a b : Int), b.natAbs ≤ fuel →
    (xgcd fuel a b).1 * a + (xgcd fuel a b).2 * b = (Int.gcd a b : Int)
  | 0, a, b, hfuel => by
      have hb : b = 0 := Int.natAbs_eq_zero.mp (Nat.le_zero.mp hfuel)
      subst hb
      show a.sign * a + 0 * 0 = (Int.gcd a 0 : Int)
      rw [Int.sign_mul_self a, Int.gcd_zero_right]
      ring
  | fuel + 1, a, b, hfuel => by
      by_cases hb : b = 0
      · subst hb
        show (if (0 : Int) = 0 then (a.sign, 0)
              else ((xgcd fuel 0 (a % 0)).2,
                (xgcd fuel 0 (a % 0)).1 - a / 0 * (xgcd fuel 0 (a % 0)).2)).1 * a +
            (if (0 : Int) = 0 then (a.sign, 0)
              else ((xgcd fuel 0 (a % 0)).2,
                (xgcd fuel 0 (a % 0)).1 - a / 0 * (xgcd fuel 0 (a % 0)).2)).2 * 0
              = (Int.gcd a 0 : Int)
        rw [if_pos rfl, Int.sign_mul_self a, Int.gcd_zero_right]
        ring
      · have hstep : (a % b).natAbs ≤ fuel := by
          have := natAbs_emod_lt (a := a) hb
          omega
        have ih := xgcd_spec fuel b (a % b) hstep
        have hmod : a % b = a - b * (a / b) := Int.emod_def a b
        rw [gcd_emod a b] at ih
        simp only [xgcd, if_neg hb]
        linear_combination ih - (xgcd fuel b (a % b)).2 * hmod

/-- Bezout coefficients of a primitive pair, in the orientation `Witness`
expects, computed by a recursion the kernel can unfold. -/
def bezoutPair (p q : Int) : Int × Int :=
  xgcd (q.natAbs + 1) p q

theorem bezout_of_gcd_one {p q : Int} (h : Int.gcd p q = 1) :
    (bezoutPair p q).1 * p + (bezoutPair p q).2 * q = 1 := by
  have := xgcd_spec (q.natAbs + 1) p q (Nat.le_succ _)
  rw [h] at this
  exact_mod_cast this

/-- The total normalizer.  Everything is an explicit term, so this computes. -/
def normalize (u v : Int) (hne : u ≠ 0 ∨ v ≠ 0) : Primitive u v :=
  let g : Int := Int.gcd u v
  have hg : 0 < g := gcd_pos_of_ne hne
  have hgnat : 0 < Int.gcd u v := gcd_pos_nat_of_ne hne
  have hcop : Int.gcd (u / g) (v / g) = 1 := Int.gcd_div_gcd_div_gcd hgnat
  { d := g
    p := u / g
    q := v / g
    u_factor := (Int.ediv_mul_cancel (Int.gcd_dvd_left ..)).symm.trans (mul_comm _ _)
    v_factor := (Int.ediv_mul_cancel (Int.gcd_dvd_right ..)).symm.trans (mul_comm _ _)
    x := (bezoutPair (u / g) (v / g)).1
    y := (bezoutPair (u / g) (v / g)).2
    bezout := bezout_of_gcd_one hcop
    d_pos := hg }

/-- Assemble a witness from a primitive row direction shared by both rows.
The column multipliers `g` and `k` are given; the caller supplies the four
entry equations.  Only the column normalization happens here. -/
def ofFactors (A : IntMat2) (g k p q x y : Int)
    (hrow : x * p + y * q = 1)
    (hA : A = outer g k p q) : Witness :=
  if hgk : g = 0 ∧ k = 0 then
    { source := A, g := g, k := k, p := p, q := q, x := x, y := y
      row_bezout := hrow
      h := 0, gp := 1, kp := 0
      g_factor := by simp [hgk.1]
      k_factor := by simp [hgk.2]
      s := 1, t := 0
      column_bezout := by ring
      h_nonnegative := le_rfl
      source_eq := hA }
  else
    let c := normalize g k (by
      rcases not_and_or.mp hgk with h | h
      · exact Or.inl h
      · exact Or.inr h)
    { source := A, g := g, k := k, p := p, q := q, x := x, y := y
      row_bezout := hrow
      h := c.d, gp := c.p, kp := c.q
      g_factor := c.u_factor
      k_factor := c.v_factor
      s := c.x, t := c.y
      column_bezout := c.bezout
      h_nonnegative := le_of_lt c.d_pos
      source_eq := hA }

/-- The identity witness of the zero matrix. -/
def zeroWitness : Witness where
  source := ⟨0, 0, 0, 0⟩
  g := 0
  k := 0
  p := 1
  q := 0
  x := 1
  y := 0
  row_bezout := by ring
  h := 0
  gp := 1
  kp := 0
  g_factor := by ring
  k_factor := by ring
  s := 1
  t := 0
  column_bezout := by ring
  h_nonnegative := le_rfl
  source_eq := by decide

/-- **Total producer.**  Every determinant-zero `2×2` integer matrix carries a
computable rank-one Smith witness. -/
def produce (A : IntMat2) (hdet : A.det = 0) : Witness :=
  if hrow : A.a00 ≠ 0 ∨ A.a01 ≠ 0 then
    let c := normalize A.a00 A.a01 hrow
    ofFactors A c.d (A.a10 * c.x + A.a11 * c.y) c.p c.q c.x c.y c.bezout (by
      have hd : c.d ≠ 0 := ne_of_gt c.d_pos
      have hdet' : A.a00 * A.a11 - A.a01 * A.a10 = 0 := hdet
      -- `det A = 0` and `(a00,a01) = d·(p,q)` force `a11·p - a10·q = 0`.
      have hcross : c.d * (A.a11 * c.p - A.a10 * c.q) = 0 := by
        linear_combination (-A.a11) * c.u_factor + A.a10 * c.v_factor + hdet'
      have hcross' : A.a11 * c.p - A.a10 * c.q = 0 :=
        (mul_eq_zero.mp hcross).resolve_left hd
      apply IntMat2.ext <;> simp only [outer]
      · exact c.u_factor
      · exact c.v_factor
      · linear_combination (-A.a10) * c.bezout - c.y * hcross'
      · linear_combination (-A.a11) * c.bezout + c.x * hcross')
  else if hrow2 : A.a10 ≠ 0 ∨ A.a11 ≠ 0 then
    let c := normalize A.a10 A.a11 hrow2
    ofFactors A 0 c.d c.p c.q c.x c.y c.bezout (by
      have h00 : A.a00 = 0 := by
        by_contra h
        exact hrow (Or.inl h)
      have h01 : A.a01 = 0 := by
        by_contra h
        exact hrow (Or.inr h)
      apply IntMat2.ext <;> simp only [outer]
      · simpa using h00
      · simpa using h01
      · exact c.u_factor
      · exact c.v_factor)
  else
    ofFactors A 0 0 1 0 1 0 (by ring) (by
      have h00 : A.a00 = 0 := by by_contra h; exact hrow (Or.inl h)
      have h01 : A.a01 = 0 := by by_contra h; exact hrow (Or.inr h)
      have h10 : A.a10 = 0 := by by_contra h; exact hrow2 (Or.inl h)
      have h11 : A.a11 = 0 := by by_contra h; exact hrow2 (Or.inr h)
      apply IntMat2.ext <;> simp only [outer] <;> simp [h00, h01, h10, h11])

theorem ofFactors_source (A : IntMat2) (g k p q x y : Int)
    (hrow : x * p + y * q = 1) (hA : A = outer g k p q) :
    (ofFactors A g k p q x y hrow hA).source = A := by
  unfold ofFactors
  split <;> rfl

/-- The producer never rewrites its input: the witness presents `A` itself. -/
theorem produce_source (A : IntMat2) (hdet : A.det = 0) :
    (produce A hdet).source = A := by
  unfold produce
  split_ifs <;> exact ofFactors_source ..

/-- The produced certificate is accepted by the shared executable gate. -/
theorem produce_check (A : IntMat2) (hdet : A.det = 0) :
    (produce A hdet).certificate.check = true :=
  Witness.certificate_check _


/-! ## Executable controls

These evaluate the producer in the kernel, so they test the computation and
not only the proofs.  The Smith invariant `h` is `gcd` of the column factor,
and it is recovered without the caller supplying any witness. -/

/-- Both rows nonzero, column gcd one. -/
example : (produce ⟨6, 9, 10, 15⟩ (by decide)).h = 1 := by decide

/-- Both rows nonzero, column gcd two: the invariant is not always one. -/
example : (produce ⟨2, 4, 4, 8⟩ (by decide)).h = 2 := by decide

/-- Negative entries normalize to a nonnegative invariant. -/
example : (produce ⟨-6, -9, 10, 15⟩ (by decide)).h = 1 := by decide

/-- A vanishing first row falls through to the second-row branch. -/
example : (produce ⟨0, 0, 3, 6⟩ (by decide)).h = 3 := by decide

/-- The zero matrix is the rank-zero boundary. -/
example : (produce ⟨0, 0, 0, 0⟩ (by decide)).h = 0 := by decide

example : (produce ⟨2, 4, 4, 8⟩ (by decide)).certificate.diagonal
    = IntMat2.diagonal 2 0 := by decide

/-- The full certificate — both transformations included — reduces in the
kernel, so the shared Boolean gate accepts the produced witness by
computation and not only by the general theorem above. -/
example : (produce ⟨6, 9, 10, 15⟩ (by decide)).certificate.check = true := by decide

end Pairfield.RankOneSmith2x2
