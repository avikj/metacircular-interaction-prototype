-- No compiler trust in this module.  The five sites that formerly used
-- `native_decide` now use `decide +kernel`.
--
-- Isolated 2026-08-15 (skolem lineage): the blocker is `Nat.xgcdAux`, which
-- mathlib defines by well-founded recursion (`Nat.strongRec`).  Lean marks
-- well-founded definitions irreducible *for the elaborator*, so plain `decide`
-- gets stuck unfolding the `Decidable` instance; the KERNEL unfolds it without
-- complaint.  `decide +kernel` skips the elaborator's evaluation and hands the
-- term straight to the kernel, which closes all five goals in ~1 s.
-- Minimal witness (bare mathlib, `import Mathlib.Data.Int.GCD`):
--   example : Nat.xgcdAux 3 1 0 5 0 1 = (1, 2, -1) := by decide          -- FAILS
--   example : Nat.xgcdAux 3 1 0 5 0 1 = (1, 2, -1) := by decide +kernel  -- OK
import Pairfield.GeneralSmith2x2
import Pairfield.ComputableSmith2x2Adapter

/-!
# Positive diagonal Smith routing

The condition `a ∤ b` does not determine one next action for a positive
diagonal matrix.  If `b ∣ a`, paired row and column swaps already put the
diagonal into Smith order.  Only mutual nondivisibility rules out both the
identity ordering and its swap.

This file turns that distinction into an executable dispatcher.  The ordered
branch emits the identity certificate, the reverse-ordered branch emits the
paired-swap certificate, and the incomparable branch factors out the gcd and
invokes the closed-form kuttaka join.  Thus a diagonal input never enters the
general matrix descent: extended Euclid forms one Bezout witness, then the
two change-of-basis matrices are written down directly.
-/

namespace Pairfield

/-- The three exact action classes for a positive diagonal endpoint. -/
inductive PositiveDiagonalRoute
  | alreadySmith
  | swapToSmith
  | nontrivialJoin
  deriving DecidableEq, Repr

/-- Divisibility, reverse divisibility, and mutual nondivisibility select the
next checked action in that order. -/
def positiveDiagonalRoute (a b : Nat) : PositiveDiagonalRoute :=
  if a ∣ b then .alreadySmith
  else if b ∣ a then .swapToSmith
  else .nontrivialJoin

@[simp] theorem positiveDiagonalRoute_alreadySmith_iff (a b : Nat) :
    positiveDiagonalRoute a b = .alreadySmith ↔ a ∣ b := by
  by_cases hab : a ∣ b <;> by_cases hba : b ∣ a <;>
    simp [positiveDiagonalRoute, hab, hba]

@[simp] theorem positiveDiagonalRoute_swapToSmith_iff (a b : Nat) :
    positiveDiagonalRoute a b = .swapToSmith ↔ ¬ a ∣ b ∧ b ∣ a := by
  by_cases hab : a ∣ b <;> by_cases hba : b ∣ a <;>
    simp [positiveDiagonalRoute, hab, hba]

@[simp] theorem positiveDiagonalRoute_nontrivialJoin_iff (a b : Nat) :
    positiveDiagonalRoute a b = .nontrivialJoin ↔ ¬ a ∣ b ∧ ¬ b ∣ a := by
  by_cases hab : a ∣ b <;> by_cases hba : b ∣ a <;>
    simp [positiveDiagonalRoute, hab, hba]

def positiveDiagonal (a b : Nat) : IntMat2 :=
  IntMat2.diagonal (a : Int) (b : Int)

/-- Paired row and column swaps reverse a diagonal exactly. -/
theorem IntMat2.swap_diagonal (a b : Int) :
    swap * diagonal a b * swap = diagonal b a := by
  apply IntMat2.ext <;>
    simp [IntMat2.mul_def, IntMat2.mul, swap, diagonal]

/-- The identity action, packaged in the common independently checkable
certificate language. -/
def positiveDiagonalIdentityCertificate (a b : Nat) : SmithCertificate2 :=
  ⟨positiveDiagonal a b, .one, a, b, .one⟩

/-- The reverse-divisibility action: conjugate by the swap matrix. -/
def positiveDiagonalSwapCertificate (a b : Nat) : SmithCertificate2 :=
  ⟨positiveDiagonal a b, .swap, b, a, .swap⟩

theorem positiveDiagonalIdentityCertificate_valid {a b : Nat}
    (ha : 0 < a) (hab : a ∣ b) :
    (positiveDiagonalIdentityCertificate a b).Valid := by
  unfold SmithCertificate2.Valid SmithCertificate2.diagonal
  dsimp [positiveDiagonalIdentityCertificate, positiveDiagonal]
  refine ⟨?_, by decide, by decide, by omega, by omega, ?_,
    Int.natCast_dvd_natCast.mpr hab⟩
  · apply IntMat2.ext <;>
      simp [IntMat2.mul, IntMat2.one, IntMat2.diagonal]
  · omega

theorem positiveDiagonalSwapCertificate_valid {a b : Nat}
    (hb : 0 < b) (hba : b ∣ a) :
    (positiveDiagonalSwapCertificate a b).Valid := by
  unfold SmithCertificate2.Valid SmithCertificate2.diagonal
  dsimp [positiveDiagonalSwapCertificate, positiveDiagonal]
  refine ⟨?_, IntMat2.swap_unimodular, IntMat2.swap_unimodular,
    by omega, by omega, ?_, Int.natCast_dvd_natCast.mpr hba⟩
  · exact (IntMat2.swap_diagonal (a : Int) (b : Int)).symm
  · omega

theorem positiveDiagonalIdentityCertificate_valid_iff {a b : Nat}
    (ha : 0 < a) :
    (positiveDiagonalIdentityCertificate a b).Valid ↔ a ∣ b := by
  constructor
  · rintro ⟨_, _, _, _, _, _, hdiv⟩
    exact Int.natCast_dvd_natCast.mp hdiv
  · exact positiveDiagonalIdentityCertificate_valid ha

theorem positiveDiagonalSwapCertificate_valid_iff {a b : Nat}
    (hb : 0 < b) :
    (positiveDiagonalSwapCertificate a b).Valid ↔ b ∣ a := by
  constructor
  · rintro ⟨_, _, _, _, _, _, hdiv⟩
    exact Int.natCast_dvd_natCast.mp hdiv
  · exact positiveDiagonalSwapCertificate_valid hb

/-- The incomparable route is exactly the failure of both closed-form
diagonal orderings.  This is the proved boundary; no claim is made about an
unspecified larger class of “weak” operations. -/
theorem positiveDiagonalRoute_nontrivialJoin_iff_two_simple_fail {a b : Nat}
    (ha : 0 < a) (hb : 0 < b) :
    positiveDiagonalRoute a b = .nontrivialJoin ↔
      ¬ (positiveDiagonalIdentityCertificate a b).Valid ∧
      ¬ (positiveDiagonalSwapCertificate a b).Valid := by
  rw [positiveDiagonalRoute_nontrivialJoin_iff,
    not_congr (positiveDiagonalIdentityCertificate_valid_iff ha),
    not_congr (positiveDiagonalSwapCertificate_valid_iff hb)]

/-! ## The direct kuttaka join

For `g = gcd a b`, write `a = gp` and `b = gq`.  The normalized factors are
coprime, so executable extended Euclid supplies `xp + yq = 1`.  The existing
closed formula then sends `diag (gp) (gq)` to `diag g (gpq)` in one
presentation arrow.  No general matrix descent is needed.
-/

/-- Normalize a positive diagonal pair to a common factor and a coprime pair.
The positivity hypothesis is exactly what excludes the undefined `(0,0)`
normalization. -/
def positiveDiagonalCoprimeFactors (a b : Nat) (hg : 0 < a.gcd b) :
    ComputableSmith2x2.CoprimeFactors :=
  ComputableSmith2x2.fromNatGcdOne (a.gcd b : Int)
    (a / a.gcd b) (b / a.gcd b)
    ((Nat.coprime_div_gcd_div_gcd hg).gcd_eq_one)

theorem positiveDiagonal_factor_left (a b : Nat) :
    (a.gcd b : Int) * (a / a.gcd b : Nat) = (a : Int) := by
  exact_mod_cast Nat.mul_div_cancel' (Nat.gcd_dvd_left a b)

theorem positiveDiagonal_factor_right (a b : Nat) :
    (a.gcd b : Int) * (b / a.gcd b : Nat) = (b : Int) := by
  exact_mod_cast Nat.mul_div_cancel' (Nat.gcd_dvd_right a b)

/-- The kuttaka join transported onto the repository's common matrix type. -/
def positiveDiagonalJoinPresentation (a b : Nat) (hg : 0 < a.gcd b) :
    SmithPresentation (positiveDiagonal a b)
      (IntMat2.diagonal (a.gcd b : Int)
        ((a.gcd b : Int) * (a / a.gcd b : Nat) *
          (b / a.gcd b : Nat))) := by
  let f := positiveDiagonalCoprimeFactors a b hg
  have p := ComputableSmith2x2.toPresentation f
  dsimp [f, positiveDiagonalCoprimeFactors] at p
  simp only [ComputableSmith2x2.fromNatGcdOne] at p
  have hsource :
      IntMat2.diagonal
          ((a.gcd b : Int) * (a / a.gcd b : Nat))
          ((a.gcd b : Int) * (b / a.gcd b : Nat)) =
        positiveDiagonal a b := by
    rw [positiveDiagonal_factor_left a b, positiveDiagonal_factor_right a b]
    rfl
  rw [hsource] at p
  exact p

/-- Promote the direct diagonal join to the common independently checkable
certificate language. -/
def positiveDiagonalJoinCertificateOfGcdPos (a b : Nat)
    (hg : 0 < a.gcd b) : SmithCertificate2 :=
  SmithPresentation.toCertificate (a.gcd b : Int)
    ((a.gcd b : Int) * (a / a.gcd b : Nat) * (b / a.gcd b : Nat))
    (positiveDiagonalJoinPresentation a b hg)

theorem positiveDiagonalJoinCertificateOfGcdPos_valid (a b : Nat)
    (hg : 0 < a.gcd b) :
    (positiveDiagonalJoinCertificateOfGcdPos a b hg).Valid := by
  apply SmithPresentation.toCertificate_valid
  · positivity
  · positivity
  · intro hzero
    omega
  · exact ⟨((a / a.gcd b : Nat) : Int) * (b / a.gcd b : Nat), by ring⟩

/-- Total wrapper.  The zero-gcd stratum is outside the positive-diagonal
organism and retains the general producer as a safe fallback. -/
def positiveDiagonalJoinCertificate (a b : Nat) : SmithCertificate2 :=
  if hg : 0 < a.gcd b then
    positiveDiagonalJoinCertificateOfGcdPos a b hg
  else
    smithCertificate (positiveDiagonal a b)

theorem positiveDiagonalJoinCertificate_valid {a b : Nat}
    (ha : 0 < a) : (positiveDiagonalJoinCertificate a b).Valid := by
  have hg : 0 < a.gcd b := Nat.gcd_pos_of_pos_left b ha
  simp only [positiveDiagonalJoinCertificate, dif_pos hg]
  exact positiveDiagonalJoinCertificateOfGcdPos_valid a b hg

/-- Execute the action selected by `positiveDiagonalRoute`.  Every diagonal
branch is now closed-form after the executable gcd/Bezout normalization. -/
def positiveDiagonalCertificate (a b : Nat) : SmithCertificate2 :=
  if a ∣ b then positiveDiagonalIdentityCertificate a b
  else if b ∣ a then positiveDiagonalSwapCertificate a b
  else positiveDiagonalJoinCertificate a b

theorem positiveDiagonalCertificate_valid {a b : Nat}
    (ha : 0 < a) (hb : 0 < b) :
    (positiveDiagonalCertificate a b).Valid := by
  unfold positiveDiagonalCertificate
  split
  · exact positiveDiagonalIdentityCertificate_valid ha ‹a ∣ b›
  · split
    · exact positiveDiagonalSwapCertificate_valid hb ‹b ∣ a›
    · exact positiveDiagonalJoinCertificate_valid ha

theorem positiveDiagonalCertificate_check {a b : Nat}
    (ha : 0 < a) (hb : 0 < b) :
    (positiveDiagonalCertificate a b).check = true :=
  SmithCertificate2.check_complete _
    (positiveDiagonalCertificate_valid ha hb)

theorem positiveDiagonalCertificate_of_swapRoute {a b : Nat}
    (h : positiveDiagonalRoute a b = .swapToSmith) :
    positiveDiagonalCertificate a b = positiveDiagonalSwapCertificate a b := by
  rw [positiveDiagonalRoute_swapToSmith_iff] at h
  simp [positiveDiagonalCertificate, h.1, h.2]

theorem positiveDiagonalCertificate_of_joinRoute {a b : Nat}
    (h : positiveDiagonalRoute a b = .nontrivialJoin) :
    positiveDiagonalCertificate a b = positiveDiagonalJoinCertificate a b := by
  rw [positiveDiagonalRoute_nontrivialJoin_iff] at h
  simp [positiveDiagonalCertificate, h.1, h.2]

/-! ## Expanding a compact join into elementary Euclidean actions

The certificate stores only its accumulated left and right matrices.  To
price a particular formation, first declare an action alphabet.  Here one
action is `IntMat2.euclidStep q` on one side.  Temporal left actions accumulate
in reverse matrix order, while temporal right actions accumulate in forward
matrix order.

This transcript is proof-relevant data.  The endpoint matrices do not recover
its historical length: inserting two swaps (`euclidStep 0`) changes the
length while their product is the identity.  This does not say that *minimal*
word length is ill-defined; minimal length is a different function, relative
to this declared alphabet.
-/

/-- A replayable word in the one-sided Euclidean action alphabet. -/
structure DiagonalEuclidTranscript where
  leftSteps : List Int
  rightSteps : List Int
  deriving DecidableEq, Repr

namespace DiagonalEuclidTranscript

/-- Accumulated left action.  The head of the list acts first. -/
def leftWord : List Int → IntMat2
  | [] => .one
  | q :: qs => leftWord qs * .euclidStep q

/-- Accumulated right action.  The head of the list acts first. -/
def rightWord : List Int → IntMat2
  | [] => .one
  | q :: qs => .euclidStep q * rightWord qs

def leftMatrix (t : DiagonalEuclidTranscript) : IntMat2 :=
  leftWord t.leftSteps

def rightMatrix (t : DiagonalEuclidTranscript) : IntMat2 :=
  rightWord t.rightSteps

/-- Historical action count in this alphabet, not an endpoint invariant. -/
def actionCost (t : DiagonalEuclidTranscript) : Nat :=
  t.leftSteps.length + t.rightSteps.length

end DiagonalEuclidTranscript

/-- The direct `diag(6,10)` kuṭṭaka certificate as six elementary actions.
The left quotients are the Euclidean run `3,5 → 5,3 → 3,2 → 2,1 → 1,0`;
the two right actions complete the diagonalization. -/
def kuttaka610Transcript : DiagonalEuclidTranscript :=
  ⟨[0, 1, 1, 2], [-1, -5]⟩

/-- The same accumulated actions with a causally real but endpoint-invisible
`swap²` prefix. -/
def paddedKuttaka610Transcript : DiagonalEuclidTranscript :=
  ⟨[0, 0, 0, 1, 1, 2], [-1, -5]⟩

theorem kuttaka610Transcript_replays_compact_certificate :
    kuttaka610Transcript.leftMatrix =
        (positiveDiagonalJoinCertificate 6 10).left ∧
      kuttaka610Transcript.rightMatrix =
        (positiveDiagonalJoinCertificate 6 10).right ∧
      kuttaka610Transcript.actionCost = 6 := by
  decide +kernel

theorem paddedKuttaka610_same_endpoint_different_cost :
    paddedKuttaka610Transcript.leftMatrix =
        kuttaka610Transcript.leftMatrix ∧
      paddedKuttaka610Transcript.rightMatrix =
        kuttaka610Transcript.rightMatrix ∧
      paddedKuttaka610Transcript.actionCost = 8 ∧
      kuttaka610Transcript.actionCost = 6 := by
  decide

/-- Actual formation length cannot be decoded from the two accumulated
matrices.  A decoder for minimal word length is not ruled out.

**The `+2` in the witness above is forced, and this theorem is tight at the
parity quotient.**  `IntMat2.euclidStep q = ⟨0, 1, 1, -q⟩` has determinant
`-1` for every `q`, and `det` is multiplicative, so an `n`-letter word has
determinant `(-1)^n`: the endpoint matrices are a *partial* decoder that
recovers the word length modulo two and nothing further.  A padding of odd
length is therefore impossible as a counterexample — the determinant separates
the two words on the spot — so `paddedKuttaka610Transcript` could not have
padded by one, and `8` against `6` is the least gap any witness can exhibit.

Proved in `Pairfield/YugmaPurana_TheEvenPaddingIsForcedAndTheDeterminantSaysWhy.lean`:
`DiagonalEuclidTranscript.det_leftWord`, `leftWord_cons_ne`, and
`endpoints_force_even_actionCost_gap`.  The same statement about Āryabhaṭa's
वल्ली is `formal/cubical/YugmaPurana_TheValliRecoversItsLengthModuloTwoAndNoFurther.agda`
(Agda; independent proof, nothing is transported). -/
theorem no_historical_actionCost_decoder :
    ¬ ∃ decode : IntMat2 → IntMat2 → Nat,
        ∀ t : DiagonalEuclidTranscript,
          decode t.leftMatrix t.rightMatrix = t.actionCost := by
  rintro ⟨decode, hdecode⟩
  have hshort := hdecode kuttaka610Transcript
  have hpadded := hdecode paddedKuttaka610Transcript
  obtain ⟨hleft, hright, hpaddedCost, hshortCost⟩ :=
    paddedKuttaka610_same_endpoint_different_cost
  rw [hleft, hright] at hpadded
  omega

/-! The shortest word is a different, endpoint-relative quantity.  For the
fixed `diag(6,10)` certificate it can be determined symbolically without a
word census. -/

/-- No word of at most three left Euclidean actions accumulates to the exact
left kuṭṭaka matrix. -/
theorem kuttaka610_leftWord_length_ge_four {qs : List Int}
    (h : DiagonalEuclidTranscript.leftWord qs = ⟨2, -1, -5, 3⟩) :
    4 ≤ qs.length := by
  cases qs with
  | nil =>
      have h01 := congrArg IntMat2.a01 h
      norm_num [DiagonalEuclidTranscript.leftWord, IntMat2.one] at h01
  | cons a qs =>
      cases qs with
      | nil =>
          have h00 := congrArg IntMat2.a00 h
          norm_num [DiagonalEuclidTranscript.leftWord, IntMat2.euclidStep,
            IntMat2.mul, IntMat2.one] at h00
      | cons b qs =>
          cases qs with
          | nil =>
              have h00 := congrArg IntMat2.a00 h
              norm_num [DiagonalEuclidTranscript.leftWord,
                IntMat2.euclidStep, IntMat2.mul, IntMat2.one] at h00
          | cons c qs =>
              cases qs with
              | nil =>
                  have h00 := congrArg IntMat2.a00 h
                  have h01 := congrArg IntMat2.a01 h
                  have h10 := congrArg IntMat2.a10 h
                  have h11 := congrArg IntMat2.a11 h
                  norm_num [DiagonalEuclidTranscript.leftWord,
                    IntMat2.euclidStep, IntMat2.mul, IntMat2.one]
                    at h00 h01 h10 h11
                  have hb : b = -2 := by omega
                  subst b
                  have ha : a = 1 := by omega
                  subst a
                  have hc : c = 3 := by omega
                  subst c
                  norm_num at h11
              | cons d qs =>
                  simp

/-- No word of at most one right Euclidean action accumulates to the exact
right kuṭṭaka matrix. -/
theorem kuttaka610_rightWord_length_ge_two {qs : List Int}
    (h : DiagonalEuclidTranscript.rightWord qs = ⟨1, 5, 1, 6⟩) :
    2 ≤ qs.length := by
  cases qs with
  | nil =>
      have h01 := congrArg IntMat2.a01 h
      norm_num [DiagonalEuclidTranscript.rightWord, IntMat2.one] at h01
  | cons a qs =>
      cases qs with
      | nil =>
          have h00 := congrArg IntMat2.a00 h
          norm_num [DiagonalEuclidTranscript.rightWord,
            IntMat2.euclidStep, IntMat2.mul, IntMat2.one] at h00
      | cons b qs =>
          simp

/-- The displayed six-action transcript is shortest among every transcript
with the same accumulated left and right matrices in the declared `E(q)`
alphabet.  This is minimal word length, not recovered historical cost. -/
theorem kuttaka610Transcript_actionCost_minimal
    (t : DiagonalEuclidTranscript)
    (hleft : t.leftMatrix = (positiveDiagonalJoinCertificate 6 10).left)
    (hright : t.rightMatrix = (positiveDiagonalJoinCertificate 6 10).right) :
    kuttaka610Transcript.actionCost ≤ t.actionCost := by
  have hleftExact :
      DiagonalEuclidTranscript.leftWord t.leftSteps = ⟨2, -1, -5, 3⟩ := by
    calc
      DiagonalEuclidTranscript.leftWord t.leftSteps = t.leftMatrix := rfl
      _ = (positiveDiagonalJoinCertificate 6 10).left := hleft
      _ = ⟨2, -1, -5, 3⟩ := by decide +kernel
  have hrightExact :
      DiagonalEuclidTranscript.rightWord t.rightSteps = ⟨1, 5, 1, 6⟩ := by
    calc
      DiagonalEuclidTranscript.rightWord t.rightSteps = t.rightMatrix := rfl
      _ = (positiveDiagonalJoinCertificate 6 10).right := hright
      _ = ⟨1, 5, 1, 6⟩ := by decide +kernel
  have hleftLength := kuttaka610_leftWord_length_ge_four hleftExact
  have hrightLength := kuttaka610_rightWord_length_ge_two hrightExact
  have hcost : kuttaka610Transcript.actionCost = 6 :=
    kuttaka610Transcript_replays_compact_certificate.2.2
  simp only [DiagonalEuclidTranscript.actionCost] at hcost ⊢
  omega

/-! ## Cache-relative coefficient acquisition

The action count above assumes that every integer parameter of `E(q)` is
already available.  The following deliberately small formation model adds a
retained coefficient cache.  Applying a step costs one; the first acquisition
of its coefficient costs one more.  This is not a bit-complexity model.  Its
purpose is to type the missing state coordinate and its composition law.
-/

namespace QuotientCache

/-- Retain a coefficient after its first use.  Existing entries are not
duplicated by the transition. -/
def acquire (cache : List Int) (q : Int) : List Int :=
  if q ∈ cache then cache else q :: cache

/-- Unit price for acquiring a coefficient that is not yet retained. -/
def missCost (cache : List Int) (q : Int) : Nat :=
  if q ∈ cache then 0 else 1

/-- State reached after replaying a quotient word from an initial cache. -/
def finalCache : List Int → List Int → List Int
  | cache, [] => cache
  | cache, q :: qs => finalCache (acquire cache q) qs

/-- One unit for each `E(q)` application plus one unit for every first
coefficient acquisition. -/
def wordCost : List Int → List Int → Nat
  | _, [] => 0
  | cache, q :: qs =>
      1 + missCost cache q + wordCost (acquire cache q) qs

/-- Cache evolution composes by threading the intermediate state. -/
theorem finalCache_append (cache qs rs : List Int) :
    finalCache cache (qs ++ rs) = finalCache (finalCache cache qs) rs := by
  induction qs generalizing cache with
  | nil => simp [finalCache]
  | cons q qs ih =>
      simp [finalCache, ih]

/-- Formation cost is an exact additive cocycle over word concatenation once
the intermediate cache is retained. -/
theorem wordCost_append (cache qs rs : List Int) :
    wordCost cache (qs ++ rs) =
      wordCost cache qs + wordCost (finalCache cache qs) rs := by
  induction qs generalizing cache with
  | nil => simp [wordCost, finalCache]
  | cons q qs ih =>
      simp [wordCost, finalCache, ih, Nat.add_assoc]

end QuotientCache

namespace DiagonalEuclidTranscript

/-- A declared serialization of coefficient use: left word first, then right
word.  This is a pricing convention, not a claim that the stored transcript
already contained an interleaving timestamp. -/
def coefficientWord (t : DiagonalEuclidTranscript) : List Int :=
  t.leftSteps ++ t.rightSteps

/-- Cache-relative price of the serialized quotient word. -/
def cachedActionCost (cache : List Int) (t : DiagonalEuclidTranscript) : Nat :=
  QuotientCache.wordCost cache t.coefficientWord

end DiagonalEuclidTranscript

/-- The six applications use five distinct coefficients.  They therefore
cost eleven from the empty cache and six from the fully retained cache. -/
theorem kuttaka610Transcript_cache_costs :
    kuttaka610Transcript.cachedActionCost [] = 11 ∧
      kuttaka610Transcript.cachedActionCost [0, 1, 2, -1, -5] = 6 := by
  decide

/-- Even after the action transcript is retained, its marginal formation cost
cannot be assigned without the initial coefficient cache. -/
theorem no_cache_independent_actionCost :
    ¬ ∃ price : DiagonalEuclidTranscript → Nat,
        ∀ (cache : List Int) (t : DiagonalEuclidTranscript),
          price t = t.cachedActionCost cache := by
  rintro ⟨price, hprice⟩
  have hempty := hprice [] kuttaka610Transcript
  have hfull := hprice [0, 1, 2, -1, -5] kuttaka610Transcript
  rw [kuttaka610Transcript_cache_costs.1] at hempty
  rw [kuttaka610Transcript_cache_costs.2] at hfull
  omega

/-! Exact controls.  The first is the killed blanket criterion; the second is
the surviving mutually nondividing branch. -/

example : ¬ (6 : Nat) ∣ 2 := by decide
example : positiveDiagonalRoute 6 2 = .swapToSmith := by decide
example : positiveDiagonalCertificate 6 2 =
    positiveDiagonalSwapCertificate 6 2 :=
  positiveDiagonalCertificate_of_swapRoute (by decide)
example : (positiveDiagonalCertificate 6 2).check = true :=
  positiveDiagonalCertificate_check (by decide) (by decide)

example : positiveDiagonalRoute 6 10 = .nontrivialJoin := by decide
example : positiveDiagonalCertificate 6 10 =
    positiveDiagonalJoinCertificate 6 10 :=
  positiveDiagonalCertificate_of_joinRoute (by decide)
example : (positiveDiagonalJoinCertificate 6 10).source = positiveDiagonal 6 10 := by
  decide
example : (positiveDiagonalJoinCertificate 6 10).left = ⟨2, -1, -5, 3⟩ := by
  decide +kernel
example : (positiveDiagonalJoinCertificate 6 10).right = ⟨1, 5, 1, 6⟩ := by
  decide +kernel
example : (positiveDiagonalJoinCertificate 6 10).d₁ = 2 := by
  decide
example : (positiveDiagonalJoinCertificate 6 10).d₂ = 30 := by
  decide
example : (positiveDiagonalCertificate 6 10).check = true :=
  positiveDiagonalCertificate_check (by decide) (by decide)

end Pairfield
