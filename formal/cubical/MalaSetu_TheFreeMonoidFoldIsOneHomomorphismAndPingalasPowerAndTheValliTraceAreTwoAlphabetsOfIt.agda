{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मालासेतु — the garland-fold is one homomorphism, and Piṅgala's घात and
-- the vallī's trace are two alphabets of it.
--
-- माला is a garland — the standard Sanskrit image for a list/sequence
-- (akṣara-mālā, the garland of syllables).  The free monoid on an
-- alphabet A is the garland of its letters, `List A`, with concatenation.
-- सेतु, the bridge, because this file earns a bridge-claim its author
-- offered in `collab/messages/0915…` and had NOT checked: that Piṅgala's
-- exponentiation and Āryabhaṭa's vallī-trace are the SAME map.  No sūtra
-- is claimed for the compound; both words are ordinary.
--
-- THE CLAIM, now built.  Over any monoid M and any alphabet map
-- f : A → M, the fold
--
--     foldMap f []       = ε
--     foldMap f (x ∷ xs) = f x ⋆ foldMap f xs
--
-- is a monoid homomorphism from (List A, ++, []) to (M, ⋆, ε):
--
--   §2  मालायोगः : foldMap f (xs ++ ys) ≡ foldMap f xs ⋆ foldMap f ys
--   §2  माला-रिक्ता : foldMap f [] ≡ ε
--
-- Commutativity is NOT assumed — deliberately, because one of the two
-- instances lives in a NON-commutative monoid (2×2 integer matrices).
--
-- THE TWO ALPHABETS, and this is the whole point:
--
--   (I) THE VALLĪ TRACE, alphabet A = R (the quotient digits).
--       `KuttakaValli.agda` (another identity's file, untouched) defines,
--       for its 2×2-matrix monoid (mul, idm) and its column map L : R → M,
--           replay []      = idm
--           replay (q ∷ v) = mul (L q) (replay v)
--       which is `foldMap L` clause-for-clause, and its
--           replayHom : replay (xs ++ ys) ≡ mul (replay xs) (replay ys)
--       is `मालायोगः` at f = L.  So Brahmagupta's/Āryabhaṭa's convergent
--       trace is the garland-fold on the digit alphabet.  (Checked there,
--       in its own monoid; subsumed here as the general law's R-instance.)
--
--   (II) PIṄGALA'S POWER, alphabet A = Unit (one letter).
--       घात x n = x ⋆ (x ⋆ (… ⋆ ε)) is the fold over the one-letter
--       garland `unlen n` (= `replicate n tt`), because `List Unit` IS ℕ
--       — proved as monoids in `NaturalMachine.FreeMonoid` (len/unlen,
--       unlen-+).  §3 checks घात x n ≡ foldMap (const x) (unlen n), and
--       §4 derives Piṅgala's law घात x (m+n) ≡ घात x m ⋆ घात x n as a
--       COROLLARY of मालायोगः + unlen-+ — the same घात-योगः that
--       `Bijamula` proved directly and that drives RSA.
--
-- READ TOGETHER: the exponentiation that decrypts RSA and the trace that
-- runs the cakravāla/kuṭṭaka are one homomorphism out of a free monoid,
-- differing only in the alphabet — Unit for Piṅgala, R for the vallī.
-- The corpus's scale-free design law, here as a checked term rather than
-- a resemblance.
--
-- WHAT IS **NOT** CLAIMED:
--   * That `replay` and this `foldMap L` are the SAME TERM across module
--     boundaries — `KuttakaValli` is parametrised by its own monoid and
--     is not imported here; the identity is clause-level and stated, and
--     replayHom is re-proved there in its own monoid.  §5 exhibits the
--     structure concretely on ONE small non-commutative monoid so the
--     R-alphabet instance is not only prose.
--   * Any new theorem about RSA or the vallī themselves.  This unifies
--     what each already proved; it does not extend either.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module MalaSetu_TheFreeMonoidFoldIsOneHomomorphismAndPingalasPowerAndTheValliTraceAreTwoAlphabetsOfIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1  A monoid (not necessarily commutative) and the garland-fold.
------------------------------------------------------------------------

record Monoid (M : Type ℓ) : Type ℓ where
  field
    ε      : M
    _⋆_    : M → M → M
    assoc⋆ : (x y z : M) → (x ⋆ y) ⋆ z ≡ x ⋆ (y ⋆ z)
    idL    : (x : M) → ε ⋆ x ≡ x
    idR    : (x : M) → x ⋆ ε ≡ x

module _ {A : Type ℓ'} {M : Type ℓ} (Mon : Monoid M) where
  open Monoid Mon

  foldMap : (A → M) → List A → M
  foldMap f []       = ε
  foldMap f (x ∷ xs) = f x ⋆ foldMap f xs

  ------------------------------------------------------------------------
  -- §2  The homomorphism.
  ------------------------------------------------------------------------

  माला-रिक्ता : (f : A → M) → foldMap f [] ≡ ε
  माला-रिक्ता f = refl

  मालायोगः : (f : A → M) (xs ys : List A)
           → foldMap f (xs ++ ys) ≡ foldMap f xs ⋆ foldMap f ys
  मालायोगः f []       ys = sym (idL (foldMap f ys))
  मालायोगः f (x ∷ xs) ys =
      cong (f x ⋆_) (मालायोगः f xs ys)
    ∙ sym (assoc⋆ (f x) (foldMap f xs) (foldMap f ys))

------------------------------------------------------------------------
-- §3  ALPHABET Unit — Piṅgala's घात is the fold over a one-letter garland.
------------------------------------------------------------------------

module _ {M : Type ℓ} (Mon : Monoid M) where
  open Monoid Mon

  घात : M → ℕ → M
  घात x zero    = ε
  घात x (suc n) = x ⋆ घात x n

  -- the one-letter garland of length n (= FreeMonoid.unlen n)
  unlen : ℕ → List Unit
  unlen zero    = []
  unlen (suc n) = tt ∷ unlen n

  unlen-+ : (m n : ℕ) → unlen (m + n) ≡ unlen m ++ unlen n
  unlen-+ zero    n = refl
  unlen-+ (suc m) n = cong (tt ∷_) (unlen-+ m n)

  -- Piṅgala's power IS the garland-fold with the constant alphabet map
  घात-मालया : (x : M) (n : ℕ) → घात x n ≡ foldMap Mon (λ _ → x) (unlen n)
  घात-मालया x zero    = refl
  घात-मालया x (suc n) = cong (x ⋆_) (घात-मालया x n)

  ------------------------------------------------------------------------
  -- §4  Piṅगala's exponent law, as a COROLLARY of §2 (not re-proved).
  --     This is Bijamula's घात-योगः, obtained through the free monoid.
  ------------------------------------------------------------------------

  घात-योगः-सेतुना : (x : M) (m n : ℕ) → घात x (m + n) ≡ घात x m ⋆ घात x n
  घात-योगः-सेतुना x m n =
      घात-मालया x (m + n)
    ∙ cong (foldMap Mon (λ _ → x)) (unlen-+ m n)      -- unlen(m+n)=unlen m ++ unlen n
    ∙ मालायोगः Mon (λ _ → x) (unlen m) (unlen n)       -- the ONE homomorphism law
    ∙ cong₂ _⋆_ (sym (घात-मालया x m)) (sym (घात-मालया x n))

------------------------------------------------------------------------
-- §5  ALPHABET R — the vallī trace, exhibited concretely on one small
--     NON-commutative monoid, so instance (I) is a checked term and not
--     only the clause-level remark in the header.  M = endomorphisms of a
--     2-state set under composition (the smallest non-commutative monoid
--     that carries a faithful "replay"); L sends two digits to two
--     non-commuting maps; foldMap L is a replay and मालायोगः is its
--     replayHom.
------------------------------------------------------------------------

-- the transformation monoid on {0,1}: functions Bool → Bool under ∘
data Two : Type where t0 t1 : Two

record End : Type where
  constructor end
  field ap : Two → Two
open End

_∙E_ : End → End → End
ap (f ∙E g) x = ap f (ap g x)

idE : End
ap idE x = x

-- End is a set-of-functions monoid; assoc/id hold by refl on ap via funext-free
-- pointwise equality is definitional here since composition is definitional
assocE : (f g h : End) → (f ∙E g) ∙E h ≡ f ∙E (g ∙E h)
assocE f g h = refl

idLE : (f : End) → idE ∙E f ≡ f
idLE f = refl

idRE : (f : End) → f ∙E idE ≡ f
idRE f = refl

End-Mon : Monoid End
End-Mon = record { ε = idE ; _⋆_ = _∙E_ ; assoc⋆ = assocE ; idL = idLE ; idR = idRE }

-- two non-commuting generators: a constant map and a swap
constT0 : End
ap constT0 _ = t0

swap : End
ap swap t0 = t1
ap swap t1 = t0

-- the digit alphabet R = Two, with L the column map
Lend : Two → End
Lend t0 = constT0
Lend t1 = swap

-- replay = foldMap Lend, clause-for-clause KuttakaValli's replay
replayE : List Two → End
replayE = foldMap End-Mon Lend

-- non-commutativity is real here: the two generators do not commute, so this
-- instance genuinely needs the assoc-only (non-commutative) form of §2.
अविनिमयः : constT0 ∙E swap ≡ swap ∙E constT0 → ⊥
अविनिमयः p = subst disc (cong (λ f → ap f t1) p) tt
  where
  disc : Two → Type
  disc t0 = Unit
  disc t1 = ⊥

-- replayHom for THIS instance is exactly मालायोगः at f = Lend
वल्ली-योगः : (xs ys : List Two)
           → replayE (xs ++ ys) ≡ replayE xs ∙E replayE ys
वल्ली-योगः = मालायोगः End-Mon Lend
