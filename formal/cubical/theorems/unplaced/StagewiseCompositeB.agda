{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- StagewiseCompositeB
--
-- Theorem B, Corollary B.1 and Corollary B.2 of
-- notes/STAGEWISE_DETERMINES_COMPOSITE.md.  Companion to
-- StagewiseComposite.agda, which proves Theorem A (determination over
-- ALL of R³ holds iff R has at most two values) and is imported here
-- rather than duplicated.
--
-- WHAT IS NEW HERE: determination is relativised to a SET OF REALIZED
-- SPANS.  Theorem A is a statement about the codomain R; Theorem B is a
-- statement about the family T ⊆ R³ of spans a given composable pair
-- actually realizes.  The note's own warning (§3, Cor B.1) is that
-- "|R| ≥ 3 ⟹ non-determination" is a REALIZABILITY claim wearing the
-- clothes of a pointwise one, the same error shape as quoting a constant
-- without its scaling.  So the relativisation is the content, and it is
-- made first, before anything is proved.
--
-- HYPOTHESES (nothing else is assumed):
--   * R an arbitrary type at an arbitrary level, with `Discrete R`.
--   * T : R → R → R → Type ℓ'  an arbitrary predicate ("the realized
--     spans"), at an arbitrary, independent level.  NO decidability of T
--     is assumed except where a statement explicitly takes `Dec` as a
--     hypothesis (see `theoremB-iff`, and the scope note on it).
--   * For §4 only: an abelian group structure, carried EXPLICITLY as a
--     record (the note assumes G abelian for Cor B.2; that hypothesis is
--     written down, not silently used).
--
-- HEADLINE STATEMENTS (all checked, no postulates, no holes, --safe):
--
--  §2 Theorem B.
--     both→¬DeterminesOn     both cells realized ⟹ no decoder on T
--     ¬Cancellation→Det      cancellation cell unrealized ⟹ decoder ∨
--     ¬Persistence→Det       persistence cell unrealized  ⟹ decoder ⊕
--     theoremB-iff           the packaged equivalence, with the one
--                            constructive hypothesis it needs (Dec of
--                            the cancellation cell) named in the type.
--     determinesOnTotal↔     T = all of R³ recovers Theorem A's
--                            `Determines`, in both directions.
--
--  §3 Corollary B.1.
--     Defeating R d          = a span set realizing BOTH cells.
--     ThreeValued R          = a pairwise-distinct triple (constructive
--                              |R| ≥ 3).
--     threeValued→Defeating  sufficiency: an EXPLICIT two-span set.
--     Defeating→threeValued  necessity.
--     corB1                  the two packaged.
--     twoValued→¬Persistence  and hence
--     twoValued→allDetermined  EVERY span set over a two-valued R is
--                              determined (reusing Theorem A's
--                              `TwoValued`, not a new notion).
--     spanwiseTwoValued→DeterminesOn , emptyMeet→DeterminesOn  the
--                              pointwise refutation the note asks for: a
--                              span set landing in a two-element subset,
--                              or with A ∩ B = ∅, is determined however
--                              large R is.
--     determinesOnOneSpan     the same, concretely, over Three — whose
--                              TOTAL span set is defeating
--                              (threeIsDefeating) and for which
--                              StagewiseComposite.¬DeterminesThree holds.
--     cancellationOverBool    the asymmetry of the two cells: only the
--                              persistence cell carries |R| ≥ 3.
--
--  §4 Corollary B.2 (G abelian, carried explicitly).
--     telescope              (b − a) + (c − b) ≡ c − a, over ANY G.
--     SupportDetermines G    a decoder for the SUPPORTS 1_{g≠0}.
--     twoValued→Support / Support→twoValued : supports compose iff
--                            |G| ≤ 2.  So only the passage to supports
--                            costs; the G-valued ledger never does.
--
-- SCOPE LIMITS (stated, not buried):
--   * `theoremB-iff` needs `Dec (Cancellation …)`.  Constructively
--     ¬(P × Q) does not split into ¬P ⊎ ¬Q, and realizability of a cell
--     by an arbitrary predicate T is not decidable.  The two one-sided
--     implications above are hypothesis-free and are the working form.
--   * TwoValued / ThreeValued are the constructive renderings of
--     |R| ≤ 2 and |R| ≥ 3 for a discrete type, as in StagewiseComposite;
--     no finiteness or cardinal arithmetic is used anywhere.
--   * Cor B.2 is proved for G ITSELF as the codomain (the torsor case is
--     G acting on itself); the general torsor and the nonabelian variant
--     the note mentions are not formalized here.
--   * The defect throughout is the EQUALITY defect.  Tolerance relations
--     (note §6) are untouched.
------------------------------------------------------------------------

module StagewiseCompositeB where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; _×_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import StagewiseComposite
  using ( _⊕_ ; ind ; ind-eq ; ind-neq
        ; Determines ; TwoValued
        ; twoValued→Determines ; Determines→twoValued
        ; noDecoderAtDistinctTriple
        ; Three ; t0 ; t1 ; t2 ; discreteThree
        ; t0≢t1 ; t1≢t2 ; t0≢t2 ; ¬DeterminesThree )

private
  variable
    ℓ ℓ' : Level
    R : Type ℓ

private
  decRec : {A : Type ℓ} {B : Type ℓ'} → (A → B) → (¬ A → B) → Dec A → B
  decRec f g (yes p) = f p
  decRec f g (no ¬p) = g ¬p

-- Boolean disjunction, written here so nothing depends on a library name.
orB : Bool → Bool → Bool
orB false b = b
orB true  _ = true

------------------------------------------------------------------------
-- 1.  The relativisation: determination ON A REALIZED SET OF SPANS
------------------------------------------------------------------------

-- A span set: the spans (a , b , c) that the composable pair under
-- consideration actually produces, as the point and the probe range.
-- It is an arbitrary predicate; the whole point of Theorem B is that
-- determination is a property of THIS, not of R.
SpanSet : Type ℓ → (ℓ' : Level) → Type (ℓ-max ℓ (ℓ-suc ℓ'))
SpanSet R ℓ' = R → R → R → Type ℓ'

-- The relativised property.  Compare `Determines` of StagewiseComposite,
-- which is the special case T = everything: a decoder is required to be
-- correct only where the span is realized.  No default value is imposed
-- on unreachable summaries (the note's convention, §6).
DeterminesOn : (R : Type ℓ) → Discrete R → SpanSet R ℓ' → Type (ℓ-max ℓ ℓ')
DeterminesOn R d T =
  Σ[ f ∈ (Bool → Bool → Bool) ]
    ((a b c : R) → T a b c → f (ind d a b) (ind d b c) ≡ ind d a c)

-- The two cells inside the single ambiguous fiber δ⁻¹(1,1).  Everything
-- outside this fiber is pinned by the sandwich A △ B ⊆ D ⊆ A ∪ B
-- (Proposition 1 of the note), which is why only these two matter.

-- {a ≠ b , b ≠ c , a = c} — the stage defects cancel.
Cancellation : (R : Type ℓ) → SpanSet R ℓ' → Type (ℓ-max ℓ ℓ')
Cancellation R T =
  Σ[ a ∈ _ ] Σ[ b ∈ _ ] Σ[ c ∈ _ ]
    (T a b c × ((¬ (a ≡ b)) × ((¬ (b ≡ c)) × (a ≡ c))))

-- {a ≠ b , b ≠ c , a ≠ c} — the stage defects persist.
Persistence : (R : Type ℓ) → SpanSet R ℓ' → Type (ℓ-max ℓ ℓ')
Persistence R T =
  Σ[ a ∈ _ ] Σ[ b ∈ _ ] Σ[ c ∈ _ ]
    (T a b c × ((¬ (a ≡ b)) × ((¬ (b ≡ c)) × (¬ (a ≡ c)))))

------------------------------------------------------------------------
-- 2.  Theorem B
------------------------------------------------------------------------

-- (⇒ of the note's "fails iff both are met")  Two realized spans sharing
-- the summary (1,1) and disagreeing on the composite defeat EVERY
-- decoder.  Note the decoder is defeated at the single argument
-- (true , true); nothing else in T is looked at.
both→¬DeterminesOn :
    (d : Discrete R) (T : SpanSet R ℓ')
  → Cancellation R T → Persistence R T → ¬ (DeterminesOn R d T)
both→¬DeterminesOn d T
  (a , b , c , tabc , ¬ab , ¬bc , ac)
  (x , y , z , txyz , ¬xy , ¬yz , ¬xz)
  (f , eq) = false≢true (sym atCancellation ∙ atPersistence)
  where
    atCancellation : f true true ≡ false
    atCancellation =
      sym (cong₂ f (ind-neq d ¬ab) (ind-neq d ¬bc))
        ∙ eq a b c tabc
        ∙ ind-eq d ac

    atPersistence : f true true ≡ true
    atPersistence =
      sym (cong₂ f (ind-neq d ¬xy) (ind-neq d ¬yz))
        ∙ eq x y z txyz
        ∙ ind-neq d ¬xz

-- (⇐, first half)  If the cancellation cell is unrealized, the decoder is
-- OR: on the ambiguous fiber the composite defect is always present.
¬Cancellation→DeterminesOn :
    (d : Discrete R) (T : SpanSet R ℓ')
  → ¬ (Cancellation R T) → DeterminesOn R d T
¬Cancellation→DeterminesOn {R = R} d T ¬canc = orB , goal
  where
    goal : (a b c : R) → T a b c
         → orB (ind d a b) (ind d b c) ≡ ind d a c
    goal a b c t =
      decRec
        (λ p → decRec (λ q → yy p q) (λ ¬q → yn p ¬q) (d b c))
        (λ ¬p → decRec (λ q → ny ¬p q) (λ ¬q → nn ¬p ¬q) (d b c))
        (d a b)
      where
        yy : a ≡ b → b ≡ c → orB (ind d a b) (ind d b c) ≡ ind d a c
        yy p q = cong₂ orB (ind-eq d p) (ind-eq d q) ∙ sym (ind-eq d (p ∙ q))

        yn : a ≡ b → ¬ (b ≡ c) → orB (ind d a b) (ind d b c) ≡ ind d a c
        yn p ¬q = cong₂ orB (ind-eq d p) (ind-neq d ¬q)
                    ∙ sym (ind-neq d (λ r → ¬q (sym p ∙ r)))

        ny : ¬ (a ≡ b) → b ≡ c → orB (ind d a b) (ind d b c) ≡ ind d a c
        ny ¬p q = cong₂ orB (ind-neq d ¬p) (ind-eq d q)
                    ∙ sym (ind-neq d (λ r → ¬p (r ∙ sym q)))

        -- The only fiber with any content.  a ≡ c would put this very
        -- span in the cancellation cell, which is assumed unrealized.
        nn : ¬ (a ≡ b) → ¬ (b ≡ c) → orB (ind d a b) (ind d b c) ≡ ind d a c
        nn ¬p ¬q =
          cong₂ orB (ind-neq d ¬p) (ind-neq d ¬q)
            ∙ sym (ind-neq d (λ r → ¬canc (a , b , c , t , ¬p , ¬q , r)))

-- (⇐, second half)  If the persistence cell is unrealized, the decoder is
-- XOR — the decoder of Theorem A, now available over an arbitrary
-- codomain because it is only asked about realized spans.
¬Persistence→DeterminesOn :
    (d : Discrete R) (T : SpanSet R ℓ')
  → ¬ (Persistence R T) → DeterminesOn R d T
¬Persistence→DeterminesOn {R = R} d T ¬pers = _⊕_ , goal
  where
    goal : (a b c : R) → T a b c
         → ind d a b ⊕ ind d b c ≡ ind d a c
    goal a b c t =
      decRec
        (λ p → decRec (λ q → yy p q) (λ ¬q → yn p ¬q) (d b c))
        (λ ¬p → decRec (λ q → ny ¬p q) (λ ¬q → nn ¬p ¬q) (d b c))
        (d a b)
      where
        yy : a ≡ b → b ≡ c → ind d a b ⊕ ind d b c ≡ ind d a c
        yy p q = cong₂ _⊕_ (ind-eq d p) (ind-eq d q) ∙ sym (ind-eq d (p ∙ q))

        yn : a ≡ b → ¬ (b ≡ c) → ind d a b ⊕ ind d b c ≡ ind d a c
        yn p ¬q = cong₂ _⊕_ (ind-eq d p) (ind-neq d ¬q)
                    ∙ sym (ind-neq d (λ r → ¬q (sym p ∙ r)))

        ny : ¬ (a ≡ b) → b ≡ c → ind d a b ⊕ ind d b c ≡ ind d a c
        ny ¬p q = cong₂ _⊕_ (ind-neq d ¬p) (ind-eq d q)
                    ∙ sym (ind-neq d (λ r → ¬p (r ∙ sym q)))

        -- Here a ≢ c would put this span in the persistence cell.
        nn : ¬ (a ≡ b) → ¬ (b ≡ c) → ind d a b ⊕ ind d b c ≡ ind d a c
        nn ¬p ¬q =
          decRec
            (λ r → cong₂ _⊕_ (ind-neq d ¬p) (ind-neq d ¬q) ∙ sym (ind-eq d r))
            (λ ¬r → ⊥.rec (¬pers (a , b , c , t , ¬p , ¬q , ¬r)))
            (d a c)

-- Theorem B, packaged.  The reverse implication is stated with the
-- hypothesis it genuinely needs: constructively, ¬(P × Q) does not split,
-- so one decidability assumption on ONE cell is carried in the type.
theoremB-iff :
    (d : Discrete R) (T : SpanSet R ℓ')
  → Dec (Cancellation R T)
  → (DeterminesOn R d T → ¬ (Cancellation R T × Persistence R T))
  × ((¬ (Cancellation R T × Persistence R T)) → DeterminesOn R d T)
theoremB-iff d T dc =
    (λ D cp → both→¬DeterminesOn d T (fst cp) (snd cp) D)
  , (λ ¬cp → decRec
       (λ c → ¬Persistence→DeterminesOn d T (λ p → ¬cp (c , p)))
       (λ ¬c → ¬Cancellation→DeterminesOn d T ¬c)
       dc)

-- The relativised notion really does extend Theorem A's: taking T to be
-- everything gives back `Determines` of StagewiseComposite, both ways.
Total : (R : Type ℓ) → SpanSet R ℓ-zero
Total R _ _ _ = Unit

determinesOnTotal→Determines :
    (d : Discrete R) → DeterminesOn R d (Total R) → Determines R d
determinesOnTotal→Determines d (f , eq) = f , (λ a b c → eq a b c tt)

determines→DeterminesOnTotal :
    (d : Discrete R) → Determines R d → DeterminesOn R d (Total R)
determines→DeterminesOnTotal d (f , eq) = f , (λ a b c _ → eq a b c)

-- ... and every span set inherits determination from the total one, which
-- is the formal content of "determination is monotone in T": shrinking
-- the realized spans can only help.
restrictDeterminesOn :
    (d : Discrete R) (T S : SpanSet R ℓ')
  → ((a b c : R) → S a b c → T a b c)
  → DeterminesOn R d T → DeterminesOn R d S
restrictDeterminesOn d T S sub (f , eq) = f , (λ a b c s → eq a b c (sub a b c s))

------------------------------------------------------------------------
-- 3.  Corollary B.1:  what |R| ≥ 3 does and does not buy
------------------------------------------------------------------------

-- A DEFEATING span set: one realizing both cells, i.e. (by Theorem B) one
-- on which no decoder exists.
Defeating : (R : Type ℓ) (ℓ' : Level) → Type (ℓ-max ℓ (ℓ-suc ℓ'))
Defeating R ℓ' = Σ[ T ∈ SpanSet R ℓ' ] (Cancellation R T × Persistence R T)

-- Constructive |R| ≥ 3: an explicit pairwise-distinct triple.
ThreeValued : Type ℓ → Type ℓ
ThreeValued R =
  Σ[ a ∈ R ] Σ[ b ∈ R ] Σ[ c ∈ R ] ((¬ (a ≡ b)) × ((¬ (b ≡ c)) × (¬ (a ≡ c))))

-- SUFFICIENCY.  Three distinct values produce a defeating span set — and
-- an explicit, minimal one: the two-element set {(a,b,a) , (a,b,c)},
-- which is precisely the note's §4 table (rows I and II).
twoSpan : {R : Type ℓ} (a b c : R) → SpanSet R ℓ
twoSpan {R = R} a b c x y z =
  ((x ≡ a) × ((y ≡ b) × (z ≡ a))) ⊎ ((x ≡ a) × ((y ≡ b) × (z ≡ c)))

threeValued→Defeating : ThreeValued R → Defeating R _
threeValued→Defeating {R = R} (a , b , c , ¬ab , ¬bc , ¬ac) =
    twoSpan a b c
  , ( (a , b , a , inl (refl , refl , refl)
        , ¬ab , (λ q → ¬ab (sym q)) , refl)
    , (a , b , c , inr (refl , refl , refl) , ¬ab , ¬bc , ¬ac)
    )

-- NECESSITY.  A defeating span set contains, in its persistence cell, a
-- pairwise-distinct triple.  The asymmetry is worth recording: the
-- CANCELLATION cell alone does not force |R| ≥ 3 — over Bool the span
-- (true , false , true) lies in it — so it is the persistence cell that
-- carries the cardinality, and the failure of determination that needs
-- both.  (`cancellationOverBool` below witnesses this.)
Defeating→threeValued : Defeating R ℓ' → ThreeValued R
Defeating→threeValued (T , _ , (x , y , z , _ , ¬xy , ¬yz , ¬xz)) =
  x , y , z , ¬xy , ¬yz , ¬xz

corB1 : (ThreeValued R → Defeating R _) × (Defeating R ℓ' → ThreeValued R)
corB1 = threeValued→Defeating , Defeating→threeValued

-- A distinct triple is exactly what Theorem A's TwoValued excludes, so
-- the two corollaries fit together with no new work.
threeValued→¬TwoValued : ThreeValued R → ¬ (TwoValued R)
threeValued→¬TwoValued (a , b , c , ¬ab , ¬bc , ¬ac) tv = step (tv a b c)
  where
    step : (a ≡ b) ⊎ ((b ≡ c) ⊎ (a ≡ c)) → ⊥
    step (inl p)       = ¬ab p
    step (inr (inl q)) = ¬bc q
    step (inr (inr r)) = ¬ac r

-- Over a two-valued codomain the persistence cell cannot be realized …
twoValued→¬Persistence :
    (T : SpanSet R ℓ') → TwoValued R → ¬ (Persistence R T)
twoValued→¬Persistence T tv (a , b , c , _ , ¬ab , ¬bc , ¬ac) =
  threeValued→¬TwoValued (a , b , c , ¬ab , ¬bc , ¬ac) tv

-- … and hence EVERY span set over it is determined, with decoder xor.
-- (This re-derives Theorem A's forward direction as the T = Total case.)
twoValued→allDetermined :
    (d : Discrete R) (T : SpanSet R ℓ')
  → TwoValued R → DeterminesOn R d T
twoValued→allDetermined d T tv =
  ¬Persistence→DeterminesOn d T (twoValued→¬Persistence T tv)

------------------------------------------------------------------------
-- 3'.  The pointwise refutation:  |R| ≥ 3 does NOT defeat a GIVEN pair
------------------------------------------------------------------------

-- R is arbitrary — of any size — and only the REALIZED spans are
-- constrained.  These are the two cases the note names explicitly.

-- (i) "the responses land in a two-element subset": every realized span
-- contains a repeat.  Then the pair is determined, with decoder xor.
spanwiseTwoValued→DeterminesOn :
    (d : Discrete R) (T : SpanSet R ℓ')
  → ((a b c : R) → T a b c → (a ≡ b) ⊎ ((b ≡ c) ⊎ (a ≡ c)))
  → DeterminesOn R d T
spanwiseTwoValued→DeterminesOn d T h =
  ¬Persistence→DeterminesOn d T
    (λ { (a , b , c , t , ¬ab , ¬bc , ¬ac) →
           step ¬ab ¬bc ¬ac (h a b c t) })
  where
    step : {a b c : _} → ¬ (a ≡ b) → ¬ (b ≡ c) → ¬ (a ≡ c)
         → (a ≡ b) ⊎ ((b ≡ c) ⊎ (a ≡ c)) → ⊥
    step ¬ab ¬bc ¬ac (inl p)       = ¬ab p
    step ¬ab ¬bc ¬ac (inr (inl q)) = ¬bc q
    step ¬ab ¬bc ¬ac (inr (inr r)) = ¬ac r

-- (ii) "A ∩ B = ∅": no realized span has both stage defects.  Then both
-- cells are unrealized a fortiori, and the pair is determined.
emptyMeet→DeterminesOn :
    (d : Discrete R) (T : SpanSet R ℓ')
  → ((a b c : R) → T a b c → ¬ ((¬ (a ≡ b)) × (¬ (b ≡ c))))
  → DeterminesOn R d T
emptyMeet→DeterminesOn d T h =
  ¬Persistence→DeterminesOn d T
    (λ { (a , b , c , t , ¬ab , ¬bc , _) → h a b c t (¬ab , ¬bc) })

------------------------------------------------------------------------
-- 3''.  Two concrete witnesses, over the codomains of StagewiseComposite
------------------------------------------------------------------------

-- The cancellation cell is realized already over Bool, so it alone
-- carries no cardinality information: (true , false , true).
cancellationOverBool : Cancellation Bool (Total Bool)
cancellationOverBool =
  true , false , true , tt
    , (λ p → false≢true (sym p)) , (false≢true , refl)

-- Over Three, `Determines` FAILS (¬DeterminesThree of StagewiseComposite)
-- while a pair realizing only the persistence span is determined.  This
-- is Corollary B.1's negative half, machine-checked: |R| ≥ 3 does not
-- make a given pair non-determined.
oneSpan : SpanSet Three ℓ-zero
oneSpan x y z = (x ≡ t0) × ((y ≡ t1) × (z ≡ t2))

oneSpanNoCancellation : ¬ (Cancellation Three oneSpan)
oneSpanNoCancellation (a , b , c , (pa , pb , pc) , ¬ab , ¬bc , ac) =
  t0≢t2 (sym pa ∙ ac ∙ pc)

determinesOnOneSpan : DeterminesOn Three discreteThree oneSpan
determinesOnOneSpan =
  ¬Cancellation→DeterminesOn discreteThree oneSpan oneSpanNoCancellation

-- ... contrasted with the total span set over the same Three, which is
-- defeating.
threeIsDefeating : Defeating Three ℓ-zero
threeIsDefeating =
  threeValued→Defeating (t0 , t1 , t2 , t0≢t1 , t1≢t2 , t0≢t2)

------------------------------------------------------------------------
-- 4.  Corollary B.2:  G-valued defects telescope; only supports cost
--
-- The note assumes G ABELIAN for this corollary.  That hypothesis is
-- carried here as an explicit record rather than imported or implied.
------------------------------------------------------------------------

record AbGroupStr (G : Type ℓ) : Type ℓ where
  field
    _+_    : G → G → G
    zero   : G
    neg    : G → G
    assoc+ : (x y z : G) → x + (y + z) ≡ (x + y) + z
    rid    : (x : G) → x + zero ≡ x
    rinv   : (x : G) → x + neg x ≡ zero
    comm+  : (x y : G) → x + y ≡ y + x

  infixl 6 _+_

  lid : (x : G) → zero + x ≡ x
  lid x = comm+ zero x ∙ rid x

  linv : (x : G) → neg x + x ≡ zero
  linv x = comm+ (neg x) x ∙ rinv x

  -- difference: the G-VALUED defect of the step x → y
  _−_ : G → G → G
  y − x = y + neg x

  infixl 6 _−_

  -- (B.2, first half)  TELESCOPING, over ANY G: the response-valued
  -- ledger composes.  No cardinality hypothesis appears.
  telescope : (a b c : G) → (b − a) + (c − b) ≡ c − a
  telescope a b c =
      comm+ (b − a) (c − b)
    ∙ assoc+ (c − b) b (neg a)
    ∙ cong (λ w → w + neg a)
        (sym (assoc+ c (neg b) b) ∙ cong (c +_) (linv b) ∙ rid c)

  -- the companion identity: the cancellation span telescopes to zero.
  telescope0 : (a b : G) → (b − a) + (a − b) ≡ zero
  telescope0 a b = telescope a b a ∙ rinv a

  -- differences detect equality, in both directions
  −≡zero : {x y : G} → x ≡ y → y − x ≡ zero
  −≡zero {x} {y} p = cong (λ w → y − w) p ∙ rinv y

  ≡from− : {x y : G} → y − x ≡ zero → x ≡ y
  ≡from− {x} {y} h =
    sym (lid x) ∙ cong (_+ x) (sym h) ∙ sym (assoc+ y (neg x) x)
      ∙ cong (y +_) (linv x) ∙ rid y

-- The SUPPORT ledger: one records only 1_{g ≠ 0}.  Determination for
-- supports is the existence of a decoder for the support of a sum.
SupportDetermines : (G : Type ℓ) → Discrete G → AbGroupStr G → Type ℓ
SupportDetermines G d A =
  Σ[ f ∈ (Bool → Bool → Bool) ]
    ((g₁ g₂ : G) →
       f (ind d (AbGroupStr.zero A) g₁) (ind d (AbGroupStr.zero A) g₂)
         ≡ ind d (AbGroupStr.zero A) (AbGroupStr._+_ A g₁ g₂))

module _ {G : Type ℓ} (d : Discrete G) (A : AbGroupStr G) where
  open AbGroupStr A

  -- (B.2, second half, ⇐)  |G| ≤ 2 ⟹ supports compose, decoder xor.
  twoValued→SupportDetermines : TwoValued G → SupportDetermines G d A
  twoValued→SupportDetermines tv = _⊕_ , goal
    where
      goal : (g₁ g₂ : G)
           → ind d zero g₁ ⊕ ind d zero g₂ ≡ ind d zero (g₁ + g₂)
      goal g₁ g₂ =
        decRec
          (λ p → decRec (λ q → yy p q) (λ ¬q → yn p ¬q) (d zero g₂))
          (λ ¬p → decRec (λ q → ny ¬p q) (λ ¬q → nn ¬p ¬q) (d zero g₂))
          (d zero g₁)
        where
          yy : zero ≡ g₁ → zero ≡ g₂
             → ind d zero g₁ ⊕ ind d zero g₂ ≡ ind d zero (g₁ + g₂)
          yy p q = cong₂ _⊕_ (ind-eq d p) (ind-eq d q)
                     ∙ sym (ind-eq d (sym (rid zero)
                              ∙ cong₂ _+_ p q))

          yn : zero ≡ g₁ → ¬ (zero ≡ g₂)
             → ind d zero g₁ ⊕ ind d zero g₂ ≡ ind d zero (g₁ + g₂)
          yn p ¬q = cong₂ _⊕_ (ind-eq d p) (ind-neq d ¬q)
                      ∙ sym (ind-neq d
                          (λ r → ¬q (r ∙ cong (_+ g₂) (sym p) ∙ lid g₂)))

          ny : ¬ (zero ≡ g₁) → zero ≡ g₂
             → ind d zero g₁ ⊕ ind d zero g₂ ≡ ind d zero (g₁ + g₂)
          ny ¬p q = cong₂ _⊕_ (ind-neq d ¬p) (ind-eq d q)
                      ∙ sym (ind-neq d
                          (λ r → ¬p (r ∙ cong (g₁ +_) (sym q) ∙ rid g₁)))

          -- the only fiber with content: with at most two values,
          -- g₁ ≠ 0 and g₂ ≠ 0 force g₁ + g₂ = 0, via the triple
          -- (0 , g₁ , g₁ + g₂).
          nn : ¬ (zero ≡ g₁) → ¬ (zero ≡ g₂)
             → ind d zero g₁ ⊕ ind d zero g₂ ≡ ind d zero (g₁ + g₂)
          nn ¬p ¬q = step (tv zero g₁ (g₁ + g₂))
            where
              step : (zero ≡ g₁) ⊎ ((g₁ ≡ g₁ + g₂) ⊎ (zero ≡ g₁ + g₂))
                   → ind d zero g₁ ⊕ ind d zero g₂ ≡ ind d zero (g₁ + g₂)
              step (inl p) = ⊥.rec (¬p p)
              step (inr (inl q)) = ⊥.rec (¬q cancel)
                where
                  -- g₁ ≡ g₁ + g₂ cancels to 0 ≡ g₂
                  cancel : zero ≡ g₂
                  cancel =
                    sym (linv g₁)
                      ∙ cong (neg g₁ +_) q
                      ∙ assoc+ (neg g₁) g₁ g₂
                      ∙ cong (_+ g₂) (linv g₁)
                      ∙ lid g₂
              step (inr (inr r)) =
                cong₂ _⊕_ (ind-neq d ¬p) (ind-neq d ¬q)
                  ∙ sym (ind-eq d r)

  -- (B.2, second half, ⇒)  supports compose ⟹ |G| ≤ 2.  The defeating
  -- pair is (g , −g) against (g , h): both have nonzero summands, the
  -- first sums to 0 and the second does not.
  SupportDetermines→twoValued : SupportDetermines G d A → TwoValued G
  SupportDetermines→twoValued (f , eq) a b c =
    decRec inl
      (λ ¬ab → decRec (λ q → inr (inl q))
        (λ ¬bc → decRec (λ r → inr (inr r))
          (λ ¬ac → ⊥.rec (defeat ¬ab ¬bc ¬ac))
          (d a c))
        (d b c))
      (d a b)
    where
      -- from a distinct triple, two nonzero differences whose sums
      -- differ in support
      defeat : ¬ (a ≡ b) → ¬ (b ≡ c) → ¬ (a ≡ c) → ⊥
      defeat ¬ab ¬bc ¬ac = false≢true (sym atZero ∙ atNonzero)
        where
          g₁ g₂ g₂' : G
          g₁  = b − a
          g₂  = c − b
          g₂' = a − b

          ¬g₁ : ¬ (zero ≡ g₁)
          ¬g₁ p = ¬ab (≡from− (sym p))

          ¬g₂ : ¬ (zero ≡ g₂)
          ¬g₂ p = ¬bc (≡from− (sym p))

          ¬g₂' : ¬ (zero ≡ g₂')
          ¬g₂' p = ¬ab (sym (≡from− (sym p)))

          atZero : f true true ≡ false
          atZero =
            sym (cong₂ f (ind-neq d ¬g₁) (ind-neq d ¬g₂'))
              ∙ eq g₁ g₂'
              ∙ ind-eq d (sym (telescope0 a b))

          atNonzero : f true true ≡ true
          atNonzero =
            sym (cong₂ f (ind-neq d ¬g₁) (ind-neq d ¬g₂))
              ∙ eq g₁ g₂
              ∙ ind-neq d (λ r → ¬ac (≡from− (sym (r ∙ telescope a b c))))

  corB2 : (TwoValued G → SupportDetermines G d A)
        × (SupportDetermines G d A → TwoValued G)
  corB2 = twoValued→SupportDetermines , SupportDetermines→twoValued
