{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheFixedSumFibreIsTheRadiusLineAndHalfBuysOnlyTheInvolution
--
-- DELTA 14 (owner transmission, session transcript 2026-08-14T04:09:27Z,
-- "Univalent Perspectival Mathematics — Delta 14, Theorem factory I";
-- preserved at `notes/reflection_ground--owner-messages-FULL-TRANSCRIPT-
-- 20260812-to-20260820.md`), §A, T14.4 AND T14.5.
--
-- The mathematics of §A is the owner's.  No Sanskrit label is invented
-- for it (CLAUDE.md file-naming note 2): the English name is the whole
-- name, and the provenance is the transmission and the theorem numbers.
--
-- HIS STATEMENTS, VERBATIM:
--
--   T14.4 (fixed-sum fiber).  "The fiber p+q=s is equivalent to R by
--   r↦(s/2-r,s/2+r)."
--
--   T14.5.  "Symmetric functions on a fixed-sum pair fiber correspond to
--   even functions of r; antisymmetric functions correspond to odd
--   functions."
--
-- Both were, at the snapshot taken 2026-08-20, named in NO file in this
-- repository.  §A's neighbours are checked:  T14.1 and T14.2 are
-- `NaturalMachine.CenterRelative` (`ΦEquiv`, `Pair≡Centre`, `Φ∘τ≡ρ∘Φ`),
-- T14.6 and C14.7 are `NaturalMachine.PerspectiveCore` (`restricts-suff`,
-- `sector-not-inv`) and `NaturalMachine.OrderedSectorBreak`.  T14.4 and
-- T14.5 were the hole in the middle of a finished section.
--
-- CONTAINER NOTE, so the reader is not misled.  `CenterRelative` is NOT
-- imported here.  It is written against the repository pin (Agda 2.8.0,
-- cubical v0.9) and uses `solve!`, which does not exist in this
-- container (Agda 2.6.3, cubical v0.5, where the macro is `solve`).  The
-- (R , half) setting is therefore RESTATED below, minimally, and
-- `CenterRelative` is cited rather than depended on.  Nothing here
-- re-proves T14.1 or T14.2.
--
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS CHECKED, AND THE ONE PLACE THIS FILE CONTRADICTS ITS SOURCE
--
--   §1  `fixedSumEquiv`      T14.4 exactly as stated, by his own map
--                            `r ↦ (s/2 − r , s/2 + r)`, over any
--                            commutative ring carrying `half` with
--                            `half + half ≡ 1r`.
--
--   §2  `fixedSumEquiv-noHalf`
--                            **T14.4 WITHOUT `half`.**  Over ANY
--                            commutative ring — no invertible 2, no
--                            hypothesis at all — the fibre `p+q=s` is
--                            already equivalent to `R`, by `q ↦ (s−q,q)`.
--
--       This refutes the reading of T14.4 that the file was started on,
--       and that its placement in §A invites: that the fixed-sum fibre
--       is a *consequence* of the centre-relative split and therefore
--       inherits its hypothesis.  It does not.  The equivalence is free.
--
--       `half` is not idle, and §3 says exactly what it buys.  Under the
--       free coordinate `q`, the exchange `τ(p,q) = (q,p)` becomes the
--       AFFINE involution `q ↦ s − q`, whose fixed point moves with `s`.
--       Under his centred coordinate `r`, it becomes `r ↦ −r`, LINEAR,
--       fixed point at 0, independent of `s`.  So the content of
--       `half + half ≡ 1r` at T14.4 is not the equivalence — it is that
--       the exchange can be put in linear normal form simultaneously in
--       every fibre.  That is precisely what T14.5 then needs, and it is
--       why T14.5 cannot be stated at all in the free coordinate:
--       "even function of r" has no meaning for `q ↦ s − q`.
--
--   §3  `toR-τ`, `fromR-neg`  the conjugacy at the fibre:  `τ` on the
--                            fibre is exactly `r ↦ −r` on `R`, in both
--                            directions.  This is T14.2 restricted, and
--                            it is the bridge §2 says is what `half`
--                            actually purchases.
--
--   §4  `symmetricIsoEven`   T14.5, first half, as an ISO of the two
--                            Σ-types (function together with its
--                            invariance), for any codomain that is a set.
--       `antisymIsoOdd`      T14.5, second half, codomain `R` itself,
--                            where the required negation lives.
--
--   §5  GUARDS.  Three, because a correspondence theorem and a negative
--       are both cheap to make vacuously true.
--
--       `fibre-two-points`   the fibre is not a point: a WITNESSED
--                            NON-IDENTITY, `fromR s 0r ≢ fromR s 1r`,
--                            under `¬ (0r ≡ 1r)` and nothing else.
--                            Without this §4 is an iso of function
--                            spaces on a singleton and says nothing.
--
--       `two≡zero→trivial`   in ANY ring carrying `half`, `1r + 1r ≡ 0r`
--                            forces `0r ≡ 1r`.  So characteristic 2 is
--                            not merely excluded by taste here.
--
--       `even-not-odd`       hence, in a nontrivial such ring, the
--                            constant `1r` is EVEN and NOT ODD.  The two
--                            halves of T14.5 classify genuinely
--                            different function classes; `antisymIsoOdd`
--                            is not `symmetricIsoEven` renamed.
--
--       §6  `ℚ-fibre-two-points`, `ℚ-even-not-odd` — §5's hypothesis
--           DISCHARGED, at ℚ.  `half = [1/2]`, `half + half ≡ 1` by
--           `eq/ _ _ refl`, and `¬ (0 ≡ 1)` by `eq/⁻¹` into `QuoInt` and
--           `abs` into ℕ.  So the guards are not conditionals waiting on
--           a ring nobody supplies.
--
-- HOW THIS COULD STILL BE TRUE AND IRRELEVANT.  §1–§4 are parameterised
-- by `(R , half)` and over the trivial ring they all hold and say
-- nothing; §5 and §6 are the answer to that and are the reason those
-- sections exist.  What remains genuinely open is USE: nothing
-- downstream in this repository consumes `fixedSumEquiv` or
-- `symmetricIsoEven` yet, so the honest description is "a section of
-- Delta 14 §A closed, with one instantiation", not "a tool in service".
-- The §2 finding is the part that carries content independently of use,
-- because it changes what T14.4 asserts.
--
-- PRIOR ART, searched before this was written and named here rather
-- than in a claim of novelty.  §2 is NOT new mathematics.  It is the
-- standard translation-equivalence: in any abelian group `+ x` is an
-- equivalence, so addition is a binary equivalence and each of its
-- fibres is contractible in each variable.  On this disk that is
--
--   `is-binary-equiv-add-Ring`,
--   /root/agda-libs/agda-unimath/src/ring-theory/rings.lagda.md:233
--   (with `is-equiv-add-Ring`, ibid. 185, and `is-equiv-mul-Group`,
--    src/group-theory/groups.lagda.md:277)
--
-- and it is not imported here only because agda-unimath is not on this
-- repository's include path.  What is new is not the fact but the
-- READING: T14.4 as transmitted attaches the fibre statement to `s/2`,
-- and §2 shows the `s/2` is not in the theorem.  A GitHub-wide code
-- search (`fixedSum fiber Iso CommRing`, `"fiber" "a + b ≡" Iso`,
-- language:Agda, 2026-08-20) returned nothing matching the §4 pair.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  `--cubical --safe`.  No postulates, no holes.  EXIT 0.
------------------------------------------------------------------------

module NaturalMachine.TheFixedSumFibreIsTheRadiusLineAndHalfBuysOnlyTheInvolution where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv ; iso)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.HLevels using (isPropΠ ; isSetΠ)
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; ≡-× ; Σ≡Prop)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §2 first, because it is the smaller hypothesis.
--
-- T14.4 WITHOUT `half`.  The fibre of addition over `s` is equivalent to
-- the ring, in any commutative ring, by the second coordinate.
--
-- Nothing in this section mentions `half`, `2`, or a characteristic.
------------------------------------------------------------------------

module NoHalf (R : CommRing ℓ) where
 open CommRingStr (snd R)

 Pair : Type ℓ
 Pair = ⟨ R ⟩ × ⟨ R ⟩

 -- The fibre `p + q ≡ s`, as a Σ-type and not as a set-shadow: the
 -- equation is carried, and it is a path in `⟨ R ⟩`.
 FixedSum : ⟨ R ⟩ → Type ℓ
 FixedSum s = Σ[ x ∈ Pair ] (fst x + snd x ≡ s)

 private
  -- `(s - q) + q ≡ s`.  Ring identity; the solver takes it in the
  -- ∀-form, which is the shape this container's macro has.
  lemFree : (s q : ⟨ R ⟩) → (s - q) + q ≡ s
  lemFree = solve R

 freeIso : (s : ⟨ R ⟩) → Iso (FixedSum s) ⟨ R ⟩
 Iso.fun (freeIso s) x = snd (fst x)
 Iso.inv (freeIso s) q = ((s - q , q) , lemFree s q)
 Iso.rightInv (freeIso s) q = refl
 Iso.leftInv  (freeIso s) ((p , q) , e) =
   Σ≡Prop (λ _ → is-set _ _)
          (≡-× (cong (_- q) (sym e) ∙ lemBack p q) refl)
   where
    lemBack : (p q : ⟨ R ⟩) → (p + q) - q ≡ p
    lemBack = solve R

 -- **T14.4, WITH NO HYPOTHESIS.**
 fixedSumEquiv-noHalf : (s : ⟨ R ⟩) → FixedSum s ≃ ⟨ R ⟩
 fixedSumEquiv-noHalf s = isoToEquiv (freeIso s)

 ----------------------------------------------------------------------
 -- And here is what is NOT free: in this coordinate the exchange is
 -- affine, not linear, and its fixed point depends on `s`.
 ----------------------------------------------------------------------

 τF : {s : ⟨ R ⟩} → FixedSum s → FixedSum s
 τF ((p , q) , e) = ((q , p) , (+Comm q p ∙ e))

 -- The exchange, read through the free coordinate, is `q ↦ s − q`.
 τF-free : (s : ⟨ R ⟩) (x : FixedSum s)
         → Iso.fun (freeIso s) (τF x) ≡ s - Iso.fun (freeIso s) x
 τF-free s ((p , q) , e) = sym (cong (_- q) (sym e) ∙ lemBack p q)
   where
    lemBack : (p q : ⟨ R ⟩) → (p + q) - q ≡ p
    lemBack = solve R

------------------------------------------------------------------------
-- §1, §3, §4, §5.  The centred setting: a commutative ring together with
-- an element `half` and a proof `half + half ≡ 1r`.  Exactly the setting
-- of `NaturalMachine.CenterRelative`, restated (see the container note).
------------------------------------------------------------------------

module _ (R : CommRing ℓ) where
 open CommRingStr (snd R)
 open NoHalf R using (Pair ; FixedSum ; τF)

 module _ (half : ⟨ R ⟩) (half+half : half + half ≡ 1r) where

  private
   unit : (x : ⟨ R ⟩) → (half + half) · x ≡ x
   unit x = cong (_· x) half+half ∙ ·IdL x

   lemSum : (h s r : ⟨ R ⟩) → (h · s - r) + (h · s + r) ≡ (h + h) · s
   lemSum = solve R

   lemRad : (h s r : ⟨ R ⟩) → h · ((h · s + r) - (h · s - r)) ≡ (h + h) · r
   lemRad = solve R

   lemP : (h p q : ⟨ R ⟩) → h · (p + q) - h · (q - p) ≡ (h + h) · p
   lemP = solve R

   lemQ : (h p q : ⟨ R ⟩) → h · (p + q) + h · (q - p) ≡ (h + h) · q
   lemQ = solve R

  --------------------------------------------------------------------
  -- §1.  T14.4 EXACTLY AS STATED.
  --
  --   forward   `((p,q),_) ↦ half · (q − p)`   — the radius; this is the
  --             second component of `CenterRelative.Φ`.
  --   backward  `r ↦ ((s/2 − r , s/2 + r) , _)` — his own map.
  --------------------------------------------------------------------

  toR : {s : ⟨ R ⟩} → FixedSum s → ⟨ R ⟩
  toR ((p , q) , _) = half · (q - p)

  fromR : (s : ⟨ R ⟩) → ⟨ R ⟩ → FixedSum s
  fromR s r = ((half · s - r , half · s + r) , lemSum half s r ∙ unit s)

  fixedSumIso : (s : ⟨ R ⟩) → Iso (FixedSum s) ⟨ R ⟩
  Iso.fun (fixedSumIso s) = toR
  Iso.inv (fixedSumIso s) = fromR s
  Iso.rightInv (fixedSumIso s) r = lemRad half s r ∙ unit r
  Iso.leftInv  (fixedSumIso s) ((p , q) , e) =
    Σ≡Prop (λ _ → is-set _ _)
           ( cong (λ s' → (half · s' - half · (q - p) , half · s' + half · (q - p)))
                  (sym e)
           ∙ ≡-× (lemP half p q ∙ unit p) (lemQ half p q ∙ unit q) )

  -- **T14.4.**
  fixedSumEquiv : (s : ⟨ R ⟩) → FixedSum s ≃ ⟨ R ⟩
  fixedSumEquiv s = isoToEquiv (fixedSumIso s)

  --------------------------------------------------------------------
  -- §3.  THE CONJUGACY AT THE FIBRE.
  --
  -- What `half` buys, and the only thing it buys here: through the
  -- centred coordinate the exchange is `r ↦ −r`, in both directions.
  -- Compare `NoHalf.τF-free`, where it is `q ↦ s − q`.
  --------------------------------------------------------------------

  toR-τ : {s : ⟨ R ⟩} (x : FixedSum s) → toR (τF x) ≡ - (toR x)
  toR-τ ((p , q) , e) = lemNeg half p q
    where
     lemNeg : (h p q : ⟨ R ⟩) → h · (p - q) ≡ - (h · (q - p))
     lemNeg = solve R

  fromR-neg : (s r : ⟨ R ⟩) → fromR s (- r) ≡ τF (fromR s r)
  fromR-neg s r =
    Σ≡Prop (λ _ → is-set _ _) (≡-× (lemA half s r) (lemB half s r))
    where
     lemA : (h s r : ⟨ R ⟩) → h · s - (- r) ≡ h · s + r
     lemA = solve R
     lemB : (h s r : ⟨ R ⟩) → h · s + (- r) ≡ h · s - r
     lemB = solve R

  --------------------------------------------------------------------
  -- §4.  T14.5.
  --
  -- "Symmetric" is invariance under the exchange restricted to the
  -- fibre; "even" is invariance under negation.  The theorem is that the
  -- two Σ-types — function TOGETHER WITH its invariance proof — are
  -- isomorphic, not merely that the underlying function spaces are.
  -- Carrying the proof is the point: dropping it would be Delta 14's own
  -- P14.70 (false-truncation danger).
  --------------------------------------------------------------------

  Symmetric : (s : ⟨ R ⟩) (X : Type ℓ') → (FixedSum s → X) → Type _
  Symmetric s X f = (x : FixedSum s) → f (τF x) ≡ f x

  Even : (X : Type ℓ') → (⟨ R ⟩ → X) → Type _
  Even X g = (r : ⟨ R ⟩) → g (- r) ≡ g r

  Antisym : (s : ⟨ R ⟩) → (FixedSum s → ⟨ R ⟩) → Type ℓ
  Antisym s f = (x : FixedSum s) → f (τF x) ≡ - (f x)

  Odd : (⟨ R ⟩ → ⟨ R ⟩) → Type ℓ
  Odd g = (r : ⟨ R ⟩) → g (- r) ≡ - (g r)

  -- T14.5, first half.  `X` is required to be a set, and that is where
  -- the requirement is load-bearing: it makes `Symmetric` and `Even`
  -- propositions, so the Σ-components match without further data.
  symmetricIsoEven :
    (s : ⟨ R ⟩) (X : Type ℓ') (setX : isSet X) →
    Iso (Σ[ f ∈ (FixedSum s → X) ] Symmetric s X f)
        (Σ[ g ∈ (⟨ R ⟩ → X) ] Even X g)
  Iso.fun (symmetricIsoEven s X setX) (f , sy) =
    ( f ∘ fromR s
    , λ r → cong f (fromR-neg s r) ∙ sy (fromR s r) )
  Iso.inv (symmetricIsoEven s X setX) (g , ev) =
    ( g ∘ toR
    , λ x → cong g (toR-τ x) ∙ ev (toR x) )
  Iso.rightInv (symmetricIsoEven s X setX) (g , ev) =
    Σ≡Prop (λ _ → isPropΠ (λ _ → setX _ _))
           (funExt (λ r → cong g (Iso.rightInv (fixedSumIso s) r)))
  Iso.leftInv (symmetricIsoEven s X setX) (f , sy) =
    Σ≡Prop (λ _ → isPropΠ (λ _ → setX _ _))
           (funExt (λ x → cong f (Iso.leftInv (fixedSumIso s) x)))

  -- T14.5, second half.  The codomain is `R`, because "odd" needs the
  -- negation and a bare set has none.
  antisymIsoOdd :
    (s : ⟨ R ⟩) →
    Iso (Σ[ f ∈ (FixedSum s → ⟨ R ⟩) ] Antisym s f)
        (Σ[ g ∈ (⟨ R ⟩ → ⟨ R ⟩) ] Odd g)
  Iso.fun (antisymIsoOdd s) (f , as) =
    ( f ∘ fromR s
    , λ r → cong f (fromR-neg s r) ∙ as (fromR s r) )
  Iso.inv (antisymIsoOdd s) (g , od) =
    ( g ∘ toR
    , λ x → cong g (toR-τ x) ∙ od (toR x) )
  Iso.rightInv (antisymIsoOdd s) (g , od) =
    Σ≡Prop (λ _ → isPropΠ (λ _ → is-set _ _))
           (funExt (λ r → cong g (Iso.rightInv (fixedSumIso s) r)))
  Iso.leftInv (antisymIsoOdd s) (f , as) =
    Σ≡Prop (λ _ → isPropΠ (λ _ → is-set _ _))
           (funExt (λ x → cong f (Iso.leftInv (fixedSumIso s) x)))

  --------------------------------------------------------------------
  -- §5.  GUARDS.
  --
  -- §4 is an isomorphism of function spaces over the fibre.  Over a
  -- one-point fibre it is green and empty.  Over a ring where `1r ≡ -1r`
  -- the two halves of T14.5 would classify the same functions and the
  -- second would be the first renamed.  Both are refuted below, under
  -- the single hypothesis that the ring is nontrivial.
  --------------------------------------------------------------------

  -- A WITNESSED NON-IDENTITY, not a cardinality count: two named points
  -- of the fibre and a proof they are not equal.
  fibre-two-points : ¬ (0r ≡ 1r) → (s : ⟨ R ⟩) → ¬ (fromR s 0r ≡ fromR s 1r)
  fibre-two-points nz s p =
    nz ( sym (Iso.rightInv (fixedSumIso s) 0r)
       ∙ cong toR p
       ∙ Iso.rightInv (fixedSumIso s) 1r )

  -- Characteristic two is not excluded by fiat: carrying `half` already
  -- excludes it, in the strong sense that `1r + 1r ≡ 0r` collapses the
  -- ring.  `1r = (half+half)·1r = half·(1r+1r) = half·0r = 0r`.
  two≡zero→trivial : 1r + 1r ≡ 0r → 0r ≡ 1r
  two≡zero→trivial two=0 =
    sym ( sym (unit 1r)
        ∙ distrib half
        ∙ cong (half ·_) two=0
        ∙ ann half )
    where
     distrib : (h : ⟨ R ⟩) → (h + h) · 1r ≡ h · (1r + 1r)
     distrib = solve R
     ann : (h : ⟨ R ⟩) → h · 0r ≡ 0r
     ann = solve R

  -- Hence the constant function `1r` is EVEN and is NOT ODD, so the two
  -- classes of T14.5 are genuinely different and `antisymIsoOdd` is not
  -- `symmetricIsoEven` under another name.  This is the control: a
  -- version of §4 in which "even" and "odd" coincided would still
  -- typecheck, and would be worthless.
  even-not-odd : ¬ (0r ≡ 1r) → Even ⟨ R ⟩ (λ _ → 1r) × (¬ Odd (λ _ → 1r))
  even-not-odd nz = (λ _ → refl) , λ od → nz (two≡zero→trivial (step (od 0r)))
    where
     step : 1r ≡ - 1r → 1r + 1r ≡ 0r
     step h = cong (1r +_) h ∙ inv 1r
      where
       inv : (x : ⟨ R ⟩) → x + (- x) ≡ 0r
       inv = solve R

------------------------------------------------------------------------
-- §6.  THE HYPOTHESIS OF §5, DISCHARGED.
--
-- `(R , half)` is not an empty setting.  ℚ carries it, and ℚ is
-- nontrivial, so §5's two guards hold outright and not conditionally.
--
-- `half + half ≡ 1r` is `eq/ _ _ refl`: in `Cubical.HITs.Rationals.QuoQ`
-- addition is `(a,b) + (c,d) = (a·d + c·b , b·d)`, so `[1/2] + [1/2]`
-- is `[4/4]`, and `[4/4] ∼ [1/1]` is `4 · 1 ≡ 1 · 4`, which computes.
--
-- `¬ (0r ≡ 1r)` goes through `eq/⁻¹` — effectiveness of the quotient,
-- which is available because `_∼_` is prop-valued and an equivalence
-- relation — landing in `QuoInt`, and then `abs` into ℕ where `znots`
-- finishes.  No decidability procedure is run.
------------------------------------------------------------------------

module AtTheRationals where

 open import Cubical.Data.NatPlusOne using (1+_)
 open import Cubical.Data.Nat as ℕ using (znots)
 open import Cubical.HITs.Rationals.QuoQ using ([_/_] ; eq/ ; eq/⁻¹)
 open import Cubical.Data.Int.MoreInts.QuoInt as QInt using (pos ; abs)
 open import Cubical.Algebra.CommRing.Instances.QuoQ using (ℚCommRing)

 open CommRingStr (snd ℚCommRing) using (0r ; 1r ; _+_)

 halfℚ : ⟨ ℚCommRing ⟩
 halfℚ = [ pos 1 / 1+ 1 ]

 halfℚ+halfℚ : halfℚ + halfℚ ≡ 1r
 halfℚ+halfℚ = eq/ _ _ refl

 ℚ-nontrivial : ¬ (0r ≡ 1r)
 ℚ-nontrivial p = znots (cong abs (eq/⁻¹ _ _ p))

 -- §5's guards, unconditionally, over a ring somebody can compute in.
 ℚ-fibre-two-points :
   (s : ⟨ ℚCommRing ⟩) →
   ¬ (fromR ℚCommRing halfℚ halfℚ+halfℚ s 0r
      ≡ fromR ℚCommRing halfℚ halfℚ+halfℚ s 1r)
 ℚ-fibre-two-points = fibre-two-points ℚCommRing halfℚ halfℚ+halfℚ ℚ-nontrivial

 ℚ-even-not-odd :
   Even ℚCommRing halfℚ halfℚ+halfℚ ⟨ ℚCommRing ⟩ (λ _ → 1r)
   × (¬ Odd ℚCommRing halfℚ halfℚ+halfℚ (λ _ → 1r))
 ℚ-even-not-odd = even-not-odd ℚCommRing halfℚ halfℚ+halfℚ ℚ-nontrivial
