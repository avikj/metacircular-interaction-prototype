-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नष्ट · वितण्डा — naṣṭa / vitaṇḍā
--
-- TERMS, TEXTS, DATES.
--
--   नष्ट · naṣṭa, "the lost".  Piṅgala, *Chandaḥśāstra* 8.24-25
--   (~300 BCE), worked out in Halāyudha, *Mṛtasañjīvanī* (10th c.):
--   the procedure that recovers an unknown pattern ONE PLACE AT A TIME
--   by a rule applied to the index, consulting no table.
--
--   वितण्डा · vitaṇḍā.  Gautama, *Nyāyasūtra* 1.2.3 (~2nd c. CE): the
--   third kind of debate — bare refutation, the debater holding no
--   position of his own.
--
-- WHAT IS AND IS NOT CLAIMED OF THESE SOURCES.  Neither text states
-- this theorem, and neither worked over Z/p^k Z.  *naṣṭa* is named
-- because the upper-bound protocol below has exactly its shape:
-- resolve one place, descend, never consult a table.  *vitaṇḍā* is
-- named because the lower bound is literally a debater who answers
-- every query consistently while never naming a residue, and names one
-- only when cornered at the last place.  No priority is claimed for
-- either source, and no result here is attributed to them.
--
-- WHAT IS FORMALIZED.  The prose theorem, canonically stated in
-- notes/NastaVitanda_TheLostResidueIsRecoveredInKTimesPMinusOneQuestionsAndTheRefuterForcesEveryOne.md:
--
--     the least worst-case number of adaptive valuation queries that
--     identifies r in Z/p^k Z is exactly k(p-1).
--
-- By §1 of that note the oracle q_c(r) = min(v_p(r-c), k), read in
-- base p low digit first, IS the first-mismatch (longest common
-- prefix) oracle on strings of length k over an alphabet of size p.
-- That reduction is the content of the prose and is taken as the
-- definition here: `Word n` is a length-n string over `Fin (suc q)`,
-- and `resp` is the first-mismatch index.  Writing p = q+1 keeps every
-- count in N with no truncated subtraction, so `k(p-1)` is `k · q`.
--
-- BOTH HALVES ARE HERE, and that is the point of the file.  Four prose
-- write-ups of this theorem exist in notes/ and none of them was ever
-- checked; the upper bound alone is a short induction and shipping it
-- alone would reproduce ADAPTIVE_VALUATION_CENTERS.md's own honest
-- refusal wearing a green checkmark.  The theorem is carried by the
-- adversary.
--
--   upperBound : a tree that identifies every word, costing <= n · q
--   lowerBound : EVERY identifying tree has an input costing >= n · q
--
-- The lowerThm bound is stated as cost ON AN INPUT rather than as tree
-- depth: it is the stronger reading, and it avoids a maximum over the
-- branching, which is infinite here because responses are typed by N.
------------------------------------------------------------------------

module NastaVitanda_TheDigitProtocolAndTheRefuterMeetAtKTimesPMinusOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool; true; false; true≢false)
open import Cubical.Data.Sum using (_⊎_; inl; inr)
open import Cubical.Data.List using (List; []; _∷_; length; map)
open import Cubical.Data.FinData using (Fin; discreteFin) renaming (zero to fz; suc to fs)
open import Cubical.Relation.Nullary using (¬_; Dec; yes; no)
open import Cubical.Data.Empty as ⊥ using (⊥)

------------------------------------------------------------------------
-- 0. Generic scaffolding
------------------------------------------------------------------------

-- A Dec-eliminator, used instead of `with` in every recursive
-- definition below.  A `with` in a recursive definition makes every
-- downstream lemma fight the generated auxiliary function; `decRec`
-- reduces definitionally once the lemma's own `with` exposes the
-- constructor, so the proofs stay one line.
decRec : {A : Type₀} {P : Type₀} → Dec P → A → A → A
decRec (yes _) a b = a
decRec (no  _) a b = b

data _∈_ {A : Type₀} (d : A) : List A → Type₀ where
  here  : {e : A} {L : List A} → d ≡ e → d ∈ (e ∷ L)
  there : {e : A} {L : List A} → d ∈ L → d ∈ (e ∷ L)

∈[] : {A : Type₀} {d : A} → d ∈ [] → ⊥
∈[] ()

data Distinct {A : Type₀} : List A → Type₀ where
  dnil  : Distinct []
  dcons : {d : A} {L : List A} → (d ∈ L → ⊥) → Distinct L → Distinct (d ∷ L)

map∈ : {A B : Type₀} (f : A → B) {d : A} {L : List A} → d ∈ L → (f d) ∈ (map f L)
map∈ f (here p)  = here (cong f p)
map∈ f (there m) = there (map∈ f m)

lengthMap : {A B : Type₀} (f : A → B) (L : List A) → length (map f L) ≡ length L
lengthMap f []      = refl
lengthMap f (x ∷ L) = cong suc (lengthMap f L)

------------------------------------------------------------------------
-- 1. The alphabet, words, the oracle, and decision trees
------------------------------------------------------------------------

module Core (q : ℕ) where

  -- p = q + 1 digits.  The theorem's k(p-1) is n · q.
  Digit : Type₀
  Digit = Fin (suc q)

  data Word : ℕ → Type₀ where
    ⟨⟩  : Word 0
    _◂_ : {n : ℕ} → Digit → Word n → Word (suc n)

  hd : {n : ℕ} → Word (suc n) → Digit
  hd (d ◂ _) = d

  tl : {n : ℕ} → Word (suc n) → Word n
  tl (_ ◂ w) = w

  zeros : (n : ℕ) → Word n
  zeros zero    = ⟨⟩
  zeros (suc n) = fz ◂ zeros n

  -- The oracle: index of the first place where centre and hidden word
  -- disagree; n if they agree everywhere.  This is q_c(r) of the note.
  resp : {n : ℕ} → Word n → Word n → ℕ
  resp ⟨⟩       ⟨⟩       = 0
  resp (c ◂ cs) (x ◂ xs) = decRec (discreteFin c x) (suc (resp cs xs)) 0

  resp-same : {n : ℕ} (c : Digit) (cs xs : Word n)
            → resp (c ◂ cs) (c ◂ xs) ≡ suc (resp cs xs)
  resp-same c cs xs with discreteFin c c
  ... | yes _  = refl
  ... | no ¬p  = ⊥.rec (¬p refl)

  resp-diff : {n : ℕ} (c x : Digit) (cs xs : Word n)
            → (c ≡ x → ⊥) → resp (c ◂ cs) (x ◂ xs) ≡ 0
  resp-diff c x cs xs ¬p with discreteFin c x
  ... | yes p = ⊥.rec (¬p p)
  ... | no  _ = refl

  -- Adaptive decision trees.  Responses are typed by N; the tree is
  -- free to branch on any of them.
  data Tree : ℕ → Type₀ where
    leaf : {n : ℕ} → Word n → Tree n
    ask  : {n : ℕ} → Word n → (ℕ → Tree n) → Tree n

  run : {n : ℕ} → Tree n → Word n → Word n
  run (leaf w)  x = w
  run (ask c f) x = run (f (resp c x)) x

  cost : {n : ℕ} → Tree n → Word n → ℕ
  cost (leaf w)  x = 0
  cost (ask c f) x = suc (cost (f (resp c x)) x)

  Identifies : {n : ℕ} → Tree n → Type₀
  Identifies {n} T = (x : Word n) → run T x ≡ x

----------------------------------------------------------------------
-- 2. Restriction and lifting along a known first digit
----------------------------------------------------------------------

  -- Restrict a tree to inputs whose first digit is e.  A query whose
  -- centre starts elsewhere is answered 0 and carries no information;
  -- it is deleted, which only lowers the cost.
  restrict : {n : ℕ} → Digit → Tree (suc n) → Tree n
  restrict e (leaf w)  = leaf (tl w)
  restrict e (ask c f) =
    decRec (discreteFin (hd c) e)
      (ask (tl c) (λ j → restrict e (f (suc j))))
      (restrict e (f 0))

  run-restrict : {n : ℕ} (e : Digit) (T : Tree (suc n)) (y : Word n)
               → run (restrict e T) y ≡ tl (run T (e ◂ y))
  run-restrict e (leaf w) y = refl
  run-restrict e (ask (c ◂ cs) f) y with discreteFin c e
  ... | yes p = run-restrict e (f (suc (resp cs y))) y
  ... | no ¬p = run-restrict e (f 0) y

  cost-restrict : {n : ℕ} (e : Digit) (T : Tree (suc n)) (y : Word n)
                → cost (restrict e T) y ≤ cost T (e ◂ y)
  cost-restrict e (leaf w) y = ≤-refl
  cost-restrict e (ask (c ◂ cs) f) y with discreteFin c e
  ... | yes p = suc-≤-suc (cost-restrict e (f (suc (resp cs y))) y)
  ... | no ¬p = ≤-suc (cost-restrict e (f 0) y)

  -- Lift a tree on suffixes to a tree on words whose first digit is e.
  liftT : {n : ℕ} → Digit → Tree n → Tree (suc n)
  liftT e (leaf w)  = leaf (e ◂ w)
  liftT e (ask c g) = ask (e ◂ c) (λ j → liftT e (g (predℕ j)))

  run-lift : {n : ℕ} (e : Digit) (T : Tree n) (y : Word n)
           → run (liftT e T) (e ◂ y) ≡ e ◂ run T y
  run-lift e (leaf w)  y = refl
  run-lift e (ask c g) y =
      cong (λ m → run (liftT e (g (predℕ m))) (e ◂ y)) (resp-same e c y)
    ∙ run-lift e (g (resp c y)) y

  cost-lift : {n : ℕ} (e : Digit) (T : Tree n) (y : Word n)
            → cost (liftT e T) (e ◂ y) ≡ cost T y
  cost-lift e (leaf w)  y = refl
  cost-lift e (ask c g) y =
      cong (λ m → suc (cost (liftT e (g (predℕ m))) (e ◂ y))) (resp-same e c y)
    ∙ cong suc (cost-lift e (g (resp c y)) y)

----------------------------------------------------------------------
-- 3. Deleting a digit from the live set
----------------------------------------------------------------------

  -- Removes the FIRST occurrence only, so the length drops by at most
  -- one; on a Distinct list that is the same as removing h outright.
  del : Digit → List Digit → List Digit
  del h []      = []
  del h (e ∷ L) = decRec (discreteFin h e) L (e ∷ del h L)

  del-∈ : (h : Digit) (L : List Digit) {x : Digit} → x ∈ del h L → x ∈ L
  del-∈ h [] m = ⊥.rec (∈[] m)
  del-∈ h (e ∷ L) m with discreteFin h e
  del-∈ h (e ∷ L) m         | yes _ = there m
  del-∈ h (e ∷ L) (here p)  | no  _ = here p
  del-∈ h (e ∷ L) (there r) | no  _ = there (del-∈ h L r)

  del-≢ : (h : Digit) (L : List Digit) → Distinct L
        → {x : Digit} → x ∈ del h L → x ≡ h → ⊥
  del-≢ h [] dd m hyp = ∈[] m
  del-≢ h (e ∷ L) (dcons nf dd) m hyp with discreteFin h e
  del-≢ h (e ∷ L) (dcons nf dd) m         hyp | yes p =
    nf (subst (λ z → z ∈ L) (hyp ∙ p) m)
  del-≢ h (e ∷ L) (dcons nf dd) (here p)  hyp | no ¬p = ¬p (sym hyp ∙ p)
  del-≢ h (e ∷ L) (dcons nf dd) (there r) hyp | no ¬p = del-≢ h L dd r hyp

  del-len : (h : Digit) (L : List Digit) → length L ≤ suc (length (del h L))
  del-len h []      = zero-≤
  del-len h (e ∷ L) with discreteFin h e
  ... | yes _ = ≤-refl
  ... | no  _ = suc-≤-suc (del-len h L)

  del-fresh : (h : Digit) (L : List Digit) {e : Digit}
            → (e ∈ L → ⊥) → e ∈ del h L → ⊥
  del-fresh h L nf m = nf (del-∈ h L m)

  del-distinct : (h : Digit) (L : List Digit) → Distinct L → Distinct (del h L)
  del-distinct h [] d = dnil
  del-distinct h (e ∷ L) (dcons nf d) with discreteFin h e
  ... | yes _ = d
  ... | no  _ = dcons (del-fresh h L nf) (del-distinct h L d)

----------------------------------------------------------------------
-- 4. The lower bound — vitaṇḍā
--
-- The refuter holds no residue.  It holds a list `Live` of first
-- digits still consistent with everything it has said, answers 0 to
-- every query, and strikes at most one digit off `Live` per query.
-- It is cornered only when one digit remains, and then the whole
-- argument recurses on the shorter suffix.
----------------------------------------------------------------------

  IdOn : {n : ℕ} → List Digit → Tree (suc n) → Type₀
  IdOn {n} Live T = (x : Word (suc n)) → hd x ∈ Live → run T x ≡ x

  -- A leaf cannot separate two words with distinct first digits.
  leafClash : {n : ℕ} (w : Word (suc n)) (e₁ e₂ : Digit)
            → w ≡ e₁ ◂ zeros n → w ≡ e₂ ◂ zeros n → e₁ ≡ e₂
  leafClash w e₁ e₂ p₁ p₂ = cong hd (sym p₁ ∙ p₂)

  inner : (n : ℕ)
        → ((T : Tree n) → Identifies T → Σ[ y ∈ Word n ] (n · q ≤ cost T y))
        → (e : Digit) (L : List Digit)
        → (e ∈ L → ⊥) → Distinct L
        → (T : Tree (suc n)) → IdOn (e ∷ L) T
        → Σ[ x ∈ Word (suc n) ] ((hd x ∈ (e ∷ L)) × (length L + n · q ≤ cost T x))

  -- One digit left: the refuter is cornered.  Restrict and recurse on
  -- the suffix.
  inner n IH e [] nf d T idOn =
    let rT : Tree n
        rT = restrict e T

        rId : Identifies rT
        rId y = run-restrict e T y ∙ cong tl (idOn (e ◂ y) (here refl))

        w : Σ[ y ∈ Word n ] (n · q ≤ cost rT y)
        w = IH rT rId
    in (e ◂ fst w)
     , here refl
     , ≤-trans (snd w) (cost-restrict e T (fst w))

  -- Two or more digits left.  Induct on the tree.
  inner n IH e (e₂ ∷ L) nf (dcons nf₂ d) (leaf w) idOn =
    ⊥.rec (nf (here (leafClash w e e₂
                      (idOn (e ◂ zeros n) (here refl))
                      (idOn (e₂ ◂ zeros n) (there (here refl))))))

  inner n IH e (e₂ ∷ L) nf (dcons nf₂ d) (ask (a ◂ as) f) idOn
    with discreteFin a e
  -- The centre's first digit is the one digit we were keeping: strike
  -- it, and carry on with the rest of the live list.
  ... | yes p =
    let rec = inner n IH e₂ L nf₂ d (f 0)
                (λ x m → cong (λ j → run (f j) x) (sym (ans x m))
                         ∙ idOn x (there m))
    in fst rec
     , there (fst (snd rec))
     , subst (λ j → suc (length L + n · q) ≤ suc (cost (f j) (fst rec)))
             (sym (ans (fst rec) (fst (snd rec))))
             (suc-≤-suc (snd (snd rec)))
    where
      ans : (x : Word (suc n)) → hd x ∈ (e₂ ∷ L) → resp (a ◂ as) x ≡ 0
      ans (h ◂ y) m =
        resp-diff a h as y (λ ea → nf (subst (λ z → z ∈ (e₂ ∷ L)) (sym ea ∙ p) m))

  ... | no ¬p =
    let Ls  = e₂ ∷ L
        rec = inner n IH e (del a Ls) (del-fresh a Ls nf)
                (del-distinct a Ls (dcons nf₂ d)) (f 0)
                (λ x m → cong (λ j → run (f j) x) (sym (ans x m))
                         ∙ idOn x (widen x m))
    in fst rec
     , widen (fst rec) (fst (snd rec))
     , ≤-trans (≤-+k (del-len a (e₂ ∷ L)))
         (subst (λ j → suc (length (del a (e₂ ∷ L)) + n · q) ≤ suc (cost (f j) (fst rec)))
                (sym (ans (fst rec) (fst (snd rec))))
                (suc-≤-suc (snd (snd rec))))
    where
      widen : (x : Word (suc n)) → hd x ∈ (e ∷ del a (e₂ ∷ L)) → hd x ∈ (e ∷ e₂ ∷ L)
      widen x (here r)  = here r
      widen x (there r) = there (del-∈ a (e₂ ∷ L) r)

      ans : (x : Word (suc n)) → hd x ∈ (e ∷ del a (e₂ ∷ L)) → resp (a ◂ as) x ≡ 0
      ans (h ◂ y) (here r)  = resp-diff a h as y (λ ea → ¬p (ea ∙ r))
      ans (h ◂ y) (there r) =
        resp-diff a h as y (λ ea → del-≢ a (e₂ ∷ L) (dcons nf₂ d) r (sym ea))

----------------------------------------------------------------------
-- 5. Enumerating the alphabet
----------------------------------------------------------------------

  fsInj : {m : ℕ} {a b : Fin m} → fs a ≡ fs b → a ≡ b
  fsInj {m} {a} {b} hyp = cong (unsuc a) hyp
    where
      unsuc : Fin m → Fin (suc m) → Fin m
      unsuc dflt fz      = dflt
      unsuc dflt (fs z)  = z

  fz≢fs : {m : ℕ} {a : Fin m} → fz ≡ fs a → ⊥
  fz≢fs {m} hyp = true≢false (cong isz hyp)
    where
      isz : Fin (suc m) → Bool
      isz fz     = true
      isz (fs _) = false

  enum : (m : ℕ) → List (Fin m)
  enum zero    = []
  enum (suc m) = fz ∷ map fs (enum m)

  enum-len : (m : ℕ) → length (enum m) ≡ m
  enum-len zero    = refl
  enum-len (suc m) = cong suc (lengthMap fs (enum m) ∙ enum-len m)

  enum-∈ : {m : ℕ} (h : Fin m) → h ∈ enum m
  enum-∈ fz     = here refl
  enum-∈ (fs h) = there (map∈ fs (enum-∈ h))

  freshMapFs : {m : ℕ} (L : List (Fin m)) → fz ∈ map fs L → ⊥
  freshMapFs [] m = ∈[] m
  freshMapFs (x ∷ L) (here p)  = fz≢fs p
  freshMapFs (x ∷ L) (there r) = freshMapFs L r

  distinctMapFs : {m : ℕ} (L : List (Fin m)) → Distinct L → Distinct (map fs L)
  distinctMapFs [] d = dnil
  distinctMapFs (x ∷ L) (dcons nf d) = dcons (aux L nf) (distinctMapFs L d)
    where
      aux : {y : Fin _} (Lx : List (Fin _)) → (y ∈ Lx → ⊥)
          → (fs y) ∈ (map fs Lx) → ⊥
      aux [] nf' m = ∈[] m
      aux (z ∷ Lx') nf' (here p)  = nf' (here (fsInj p))
      aux (z ∷ L'') nf' (there r) = aux L'' (λ s → nf' (there s)) r

  enum-distinct : (m : ℕ) → Distinct (enum m)
  enum-distinct zero    = dnil
  enum-distinct (suc m) = dcons (freshMapFs (enum m)) (distinctMapFs (enum m) (enum-distinct m))

----------------------------------------------------------------------
-- 6. The upper bound — naṣṭa
----------------------------------------------------------------------

  branch : {n : ℕ} → Tree n → Tree n → ℕ → Tree n
  branch a b zero    = a
  branch a b (suc _) = b

  chain : {n : ℕ} → Tree n → Digit → List Digit → Tree (suc n)
  chain S last []       = liftT last S
  chain S last (d ∷ ds) = ask (d ◂ zeros _) (branch (chain S last ds) (liftT d S))

  chain-run : {n : ℕ} (S : Tree n) (Sid : Identifies S) (last : Digit)
              (ds : List Digit) (h : Digit) (y : Word n)
            → (h ∈ ds) ⊎ (h ≡ last)
            → run (chain S last ds) (h ◂ y) ≡ h ◂ y
  chain-run S Sid last [] h y (inl m) = ⊥.rec (∈[] m)
  chain-run S Sid last [] h y (inr p) =
      cong (λ z → run (liftT last S) (z ◂ y)) p
    ∙ run-lift last S y
    ∙ cong (λ z → z ◂ run S y) (sym p)
    ∙ cong (λ z → h ◂ z) (Sid y)
  chain-run S Sid last (d ∷ ds) h y w with discreteFin d h
  ... | yes p =
        cong (λ z → run (liftT d S) (z ◂ y)) (sym p)
      ∙ run-lift d S y
      ∙ cong (λ z → z ◂ run S y) p
      ∙ cong (λ z → h ◂ z) (Sid y)
  ... | no ¬p = chain-run S Sid last ds h y (shrink w)
    where
      shrink : (h ∈ (d ∷ ds)) ⊎ (h ≡ last) → (h ∈ ds) ⊎ (h ≡ last)
      shrink (inr p)         = inr p
      shrink (inl (here r))  = ⊥.rec (¬p (sym r))
      shrink (inl (there r)) = inl r

  chain-cost : {n : ℕ} (S : Tree n) (last : Digit)
               (ds : List Digit) (h : Digit) (y : Word n)
             → (h ∈ ds) ⊎ (h ≡ last)
             → cost (chain S last ds) (h ◂ y) ≤ length ds + cost S y
  chain-cost S last [] h y (inl m) = ⊥.rec (∈[] m)
  chain-cost S last [] h y (inr p) =
    subst (λ z → cost (liftT last S) (z ◂ y) ≤ cost S y) (sym p)
          (subst (λ z → z ≤ cost S y) (sym (cost-lift last S y)) ≤-refl)
  chain-cost S last (d ∷ ds) h y w with discreteFin d h
  ... | yes p =
    suc-≤-suc (subst (λ z → cost (liftT d S) (z ◂ y) ≤ length ds + cost S y) p
                (subst (λ z → z ≤ length ds + cost S y) (sym (cost-lift d S y))
                       ≤SumRight))
  ... | no ¬p = suc-≤-suc (chain-cost S last ds h y (shrink w))
    where
      shrink : (h ∈ (d ∷ ds)) ⊎ (h ≡ last) → (h ∈ ds) ⊎ (h ≡ last)
      shrink (inr p)         = inr p
      shrink (inl (here r))  = ⊥.rec (¬p (sym r))
      shrink (inl (there r)) = inl r

  cover : (h : Digit) → (h ∈ (map fs (enum q))) ⊎ (h ≡ fz)
  cover fz     = inr refl
  cover (fs h) = inl (map∈ fs (enum-∈ h))

  upper : (n : ℕ) → Σ[ T ∈ Tree n ] (Identifies T × ((x : Word n) → cost T x ≤ n · q))
  upper zero = leaf ⟨⟩ , idf , cst
    where
      idf : Identifies (leaf ⟨⟩)
      idf ⟨⟩ = refl
      cst : (x : Word 0) → cost (leaf ⟨⟩) x ≤ 0
      cst ⟨⟩ = ≤-refl
  upper (suc n) =
    let S    = fst (upper n)
        Sid  = fst (snd (upper n))
        Scst = snd (snd (upper n))
        ds   = map fs (enum q)
        T    = chain S fz ds
    in T
     , (λ { (h ◂ y) → chain-run S Sid fz ds h y (cover h) })
     , (λ { (h ◂ y) →
             subst (λ m → cost T (h ◂ y) ≤ m + cost S y)
                   (lengthMap fs (enum q) ∙ enum-len q)
                   (chain-cost S fz ds h y (cover h))
             ⟨then⟩ ≤-k+ (Scst y) })
    where
      _⟨then⟩_ : {a b c : ℕ} → a ≤ b → b ≤ c → a ≤ c
      _⟨then⟩_ p r = ≤-trans p r

----------------------------------------------------------------------
-- 7. The theorem
----------------------------------------------------------------------

  lowerThm : (n : ℕ) (T : Tree n) → Identifies T → Σ[ x ∈ Word n ] (n · q ≤ cost T x)
  lowerThm zero    T idf = (zeros 0) , zero-≤
  lowerThm (suc n) T idf =
    let r = inner n (lowerThm n) fz (map fs (enum q))
              (freshMapFs (enum q))
              (distinctMapFs (enum q) (enum-distinct q))
              T (λ x _ → idf x)
    in fst r
     , subst (λ m → m + n · q ≤ cost T (fst r))
             (lengthMap fs (enum q) ∙ enum-len q)
             (snd (snd r))

  -- upperBound : there is an identifying tree costing at most n · q on
  --              every input.
  upperBound : (n : ℕ) → Σ[ T ∈ Tree n ] (Identifies T × ((x : Word n) → cost T x ≤ n · q))
  upperBound = upper

  -- lowerBound : every identifying tree has an input costing at least
  --              n · q.
  lowerBound : (n : ℕ) (T : Tree n) → Identifies T → Σ[ x ∈ Word n ] (n · q ≤ cost T x)
  lowerBound = lowerThm

-- The exact law, both halves, for every alphabet size p = q+1 and
-- every length k = n.  Read k(p-1) = n · q.
exactLaw : (q n : ℕ)
         → (Σ[ T ∈ Core.Tree q n ] (Core.Identifies q T
              × ((x : Core.Word q n) → Core.cost q T x ≤ n · q)))
         × ((T : Core.Tree q n) → Core.Identifies q T
              → Σ[ x ∈ Core.Word q n ] (n · q ≤ Core.cost q T x))
exactLaw q n = Core.upperBound q n , Core.lowerBound q n
