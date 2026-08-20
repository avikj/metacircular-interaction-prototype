{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Vipratisedha_UnderCollisionFreedomEveryResolutionPolicy
--                            IsOneFunctionAndTheirAgreementDoesNotRecoverIt
--
-- विप्रतिषेध — rule conflict, and the metarule that settles it.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES, WITH THE GRADE OF EACH.
--
-- PĀṆINĪYA — the grammarians' own school, and the one whose term names
-- this file.  Pāṇini, *Aṣṭādhyāyī* (c. 500 BCE), sūtra 1.4.2
-- `vipratiṣedhe paraṁ kāryam`: a *paribhāṣā*, a metarule, saying what
-- happens when two rules of equal strength are both applicable.
--
-- THE READING OF 1.4.2 IS CONTESTED AND THIS MODULE PICKS NEITHER SIDE.
-- The commentarial and standard modern reading takes `para` in serial
-- order — the later sūtra prevails.  Rajpopat (*In Pāṇini We Trust*,
-- Cambridge, 2022) argues `para` means the rule applicable to the
-- right-hand operand and that the serial reading is a misreading.
-- `notes/INDIC_FORMAL_TRADITIONS_MAP.md`, row `vipratiṣedha`, records
-- the dispute and instructs that the serial reading not be cited as
-- settled.  Everything proved below is indifferent to which reading is
-- right: §3 quantifies over resolution policies, so no reading is
-- assumed anywhere, and the two concrete walks of §5 are labelled by
-- what they compute and not by a claim about what Pāṇini meant.
--
-- BAUDDHA — a different school, named before its terms are used.
-- Dignāga, *Pramāṇasamuccaya* (c. 480–540), *apoha* chapter: the content
-- of a general term is *anyāpoha*, exclusion of what the term is not,
-- and not a shared positive universal.  Dharmakīrti,
-- *Pramāṇavārttika* (7th c.), answers the charge that a purely negative
-- account is empty.  Śāntarakṣita, *Tattvasaṃgraha* (8th c.), with
-- Kamalaśīla's *Pañjikā*, carries the *śabdārtha* examination.
--
-- NAIYĀYIKA — the rival, kept as a rival.  Every *abhāva* carries a
-- *pratiyogin*, a counterpositive, and the counterpositive is a positive
-- entity; Uddyotakara (*Nyāyavārttika*, c. 6th–7th c.) and Jayanta
-- Bhaṭṭa (*Nyāyamañjarī*, 9th c.) press against *apoha* the charge that
-- excluding non-cows presupposes cow.  §8 keeps the two voices apart
-- rather than merging them into one register.
--
-- GRADE.  Author, work, approximate date, and the doctrine each work is
-- known for.  No chapter-and-verse beyond `Aṣṭādhyāyī` 1.4.2, which this
-- repository's own map already cites; this container has no route to an
-- edition and nothing is quoted that I cannot state.  Sa skya Paṇḍita's
-- *Tshad ma rigs gter* (c. 1219), the Tibetan transmission of the apoha
-- material, is NOT used: it occurs in zero files of this repository and
-- I have no text for it.  That zero is reported, not filled.
--
-- WHAT IS CLAIMED OF THE SOURCES: that 1.4.2 is a metarule about rule
-- conflict and that its reading is disputed; that the exclusion account
-- of a term is Dignāga's; that the circularity charge is the
-- Naiyāyika's.  Nothing further.  The theorems are this corpus's; no
-- school stated them and none would recognise the type theory.  The
-- modelling step — reading the drawn decoder's `no` branches as a
-- sequence of exclusions and asking whether the SEQUENCE is content —
-- is mine, and §8 says what each school would say back to it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE DRAWN OBJECT.
--
-- `NaturalMachine.LocatingIsEnough` decodes an observation by walking a
-- list of located points:
--
--     table (x ∷ xs) (d , ds) y with d y
--     ... | yes _ = t x
--     ... | no  _ = table xs ds y
--
-- Read as a machine, the walk HAS a conflict-resolution policy and the
-- policy is first-match-wins: where two listed points carry the same
-- observation, the earlier supplies the answer, and that is simply what
-- happens when it runs.  Read as a rule system, the list is the rules
-- and first-match-wins is a *paribhāṣā* — declared data added to the
-- rule set, not derived from its joint invariants.
-- `notes/VERIFIER_BLIND_FIBER_REWARD.md` already types it that way, in
-- those words.
--
-- Those two readings give different answers about what the policy IS.
-- §3 decides between them, and §6–§7 bound the decision.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Resolution ys f       f answers each observation with the task value
--                         of SOME rule of ys that matches it, or with
--                         the fallback when none matches.  A policy-free
--                         specification: no order occurs in it.
--
--   resolutions-agree     under `CollisionFree`, ANY two Resolutions of
--                         one rule list are the same function.  The
--                         metarule is idle — no reading of 1.4.2 is
--                         visible in any output, under exactly the
--                         hypothesis the drawn theorem is stated with.
--
--   table-is-resolution        the drawn walk is a Resolution;
--   tablePara-is-resolution    so is the opposite convention (§5);
--   policy-is-idle             hence the two walks compute one function.
--
--   tablePara-correct     and therefore the *para* walk also satisfies
--   paraWitness           the factoring law and independently witnesses
--                         `¬ Refutes`.  The ceiling theorem's decoder is
--                         not unique, and its uniqueness was never used.
--
--   REFUTATION 1 (§7)     `policy-is-observable-without-cf` — the
--                         hypothesis cannot be dropped.  Two rules, one
--                         observation, values false / true: the two
--                         walks differ, at `Unit`.
--
--   REFUTATION 2 (§7)     `agreement-does-not-recover-collisionFree` —
--                         and the converse fails.  THREE rules, one
--                         observation, values false / true / false: the
--                         two walks agree everywhere and the rule set is
--                         NOT collision-free.  Comparing two
--                         conflict-resolution conventions is therefore
--                         not a test for the presence of conflict.
--
-- WHAT IS NOT CLAIMED.  Not that `Resolution` is the weakest
-- specification a decoder can satisfy — it is the one these proofs
-- consume, which is a different and weaker thing (the drawn module's own
-- formula about `Locates`, reused deliberately).  Not that the two walks
-- of §5 are the two readings of 1.4.2: the right-operand reading is not
-- a list-order policy at all and is not modelled here.  Nothing about
-- apoha for terms whose exclusion range differs from their own domain.
--
-- PRIOR ART IN THIS REPOSITORY, cited rather than re-landed.
--   `NaturalMachine.LocatingIsEnough` — the drawn walk: `Locates`,
--     `table`, `table-correct`, `locatingFree→notRefuting`.  Imported,
--     not restated.
--   `NaturalMachine.Anyapoha_TheExclusionSetCarriesTheTermOnlyWhen…`
--     — whether an exclusion SET fixes a term, and the answer that it
--     does only once a decision is supplied.  A different question from
--     this one: that module asks what exclusion determines, this asks
--     whether the ORDER of exclusion is part of the content.
--   `Swarm.S04Apoha`, `Swarm.S04ApohaFiniteCompletion` — exclusion over
--     an indexed observable family; the gap there is Markov's Principle.
--   `NaturalMachine.Abhava` — *abhāva* carrying its *pratiyogin*, and
--     the 2026-08-18 correction that the absence tower is two-tall with
--     no hypothesis and that decidability is about the counterpositive.
--     Used in §8's reading of `Locates`; not re-proved.
--   `NaturalMachine.Apavada`, `NaturalMachine.Asiddha` — *utsarga /
--     apavāda* and *asiddhatva*, the other two Pāṇinian conflict
--     devices, already built here.  1.4.2 is the third and was unbuilt:
--     before this file `vipratiṣedha` occurred in exactly two files of
--     this repository — `notes/INDIC_FORMAL_TRADITIONS_MAP.md` and
--     `notes/VERIFIER_BLIND_FIBER_REWARD.md` — both notes, neither
--     formal, while `Pāṇini` occurred in 104 and `Aṣṭādhyāyī` in 48.
--     That is the author-against-work gap the cheap check is for.
--   `NaturalMachine.Durnaya_CollapseIffEveryNayaAgrees` (887641a7) —
--     collapse iff every pair of standpoints agrees, with the `Mixed`
--     witness that denial-versus-agreement is not exhaustive.  §7's
--     second refutation is that same error committed again at a
--     different site by me, and killed the same way: by a witness, not
--     by a rephrasing.
--
-- CHECKED on the CONTAINER: Agda 2.6.3, cubical v0.5 — NOT the declared
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes.
------------------------------------------------------------------------

module NaturalMachine.Vipratisedha_UnderCollisionFreedomEveryResolutionPolicyIsOneFunctionAndTheirAgreementDoesNotRecoverIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Bool using (Bool ; false ; true ; false≢true)
open import Cubical.Data.Maybe using (Maybe ; just ; nothing)
open import Cubical.Data.Unit using (Unit ; tt ; Unit* ; tt* ; isPropUnit)
open import Cubical.Data.Empty as Empty using (⊥ ; ⊥*)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Functions.Image using (Image)

open import NaturalMachine.WitnessNumberIsTwo
  using (AllHold ; Refutes ; factorLaw)
open import NaturalMachine.WhyTheSitesAreTwo using (Mem ; CollisionFree)
open import NaturalMachine.LocatingIsEnough
  using (Locates ; table ; table-correct)

private
  variable
    ℓx ℓy ℓt : Level

module _ {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
         (q : X → Y) (t : X → T) (fb : T) where

------------------------------------------------------------------------
-- 1.  A resolution, specified with no order in it.
--
-- `Hits ys y` — some rule of ys is applicable at y.  This is the
-- *pratiyogin* of the fallback branch: the thing whose absence the
-- decoder asserts when it answers `fb`.  Naming it is `Abhava.agda`'s
-- discipline, applied here rather than restated.
--
-- `Resolution ys f` — at every observation, f answers with the task
-- value of SOME applicable rule, or the applicability of every rule is
-- denied and f answers with the fallback.  Which applicable rule is
-- never mentioned.  That silence is the point: the *paribhāṣā* is the
-- thing being measured, so it must not be smuggled into the yardstick.
------------------------------------------------------------------------

  Hits : List X → Y → Type (ℓ-max ℓx ℓy)
  Hits ys y = Σ[ x ∈ X ] (Mem x ys × (q x ≡ y))

  Resolution : List X → (Y → T) → Type (ℓ-max ℓx (ℓ-max ℓy ℓt))
  Resolution ys f =
    (y : Y) →
        (Σ[ x ∈ X ] (Mem x ys × (q x ≡ y) × (f y ≡ t x)))
      ⊎ ((¬ Hits ys y) × (f y ≡ fb))

------------------------------------------------------------------------
-- 2.  What collision-freedom says as a statement about rules.
--
--     CollisionFree q t ys
--       = (a b : X) → Mem a ys → Mem b ys → q a ≡ q b → t a ≡ t b
--
-- Any two rules whose conditions are met by the same input prescribe the
-- same output.  That is: विप्रतिषेध never arises.  §3 turns "then the
-- metarule has nothing to do" from a gloss into a theorem.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 3.  THE THEOREM.  Under collision-freedom, every resolution policy is
--     one and the same function.
------------------------------------------------------------------------

  resolutions-agree :
    (ys : List X) → CollisionFree q t ys
    → (f g : Y → T) → Resolution ys f → Resolution ys g
    → (y : Y) → f y ≡ g y
  resolutions-agree ys cf f g rf rg y with rf y | rg y
  ... | inl (a , ma , qa , fa) | inl (b , mb , qb , gb) =
          fa ∙ cf a b ma mb (qa ∙ sym qb) ∙ sym gb
  ... | inl (a , ma , qa , _)  | inr (¬h , _) =
          Empty.rec (¬h (a , ma , qa))
  ... | inr (¬h , _)           | inl (b , mb , qb , _) =
          Empty.rec (¬h (b , mb , qb))
  ... | inr (_ , fnb)          | inr (_ , gnb) = fnb ∙ sym gnb

------------------------------------------------------------------------
-- 4.  The drawn walk is a resolution.
------------------------------------------------------------------------

  table-is-resolution :
    (ys : List X) (loc : Locates q ys) → Resolution ys (table q t fb ys loc)
  table-is-resolution []       loc      y =
    inr ((λ { (z , m , _) → Empty.rec* m }) , refl)
  table-is-resolution (x ∷ xs) (d , ds) y with d y
  ... | yes e  = inl (x , inl refl , e , refl)
  ... | no  ¬e with table-is-resolution xs ds y
  ...   | inl (z , mz , qz , ez) = inl (z , inr mz , qz , ez)
  ...   | inr (¬h , ez) =
            inr ((λ { (z , inl z≡x , qz) → ¬e (cong q (sym z≡x) ∙ qz)
                    ; (z , inr m   , qz) → ¬h (z , m , qz) }) , ez)

------------------------------------------------------------------------
-- 5.  The opposite convention, built as an actual walk.
--
-- `lookupPara` prefers a match found LATER in the list; the drawn
-- `table` prefers the earlier one.  Both are policies.  Neither is
-- asserted to be the meaning of 1.4.2 — see the header on Rajpopat.
-- What is needed below is only that they are two different algorithms.
------------------------------------------------------------------------

  orElse : Maybe T → T
  orElse nothing  = fb
  orElse (just v) = v

  hitVal : (x : X) (y : Y) → Dec (q x ≡ y) → Maybe T
  hitVal x y (yes _) = just (t x)
  hitVal x y (no  _) = nothing

  push : (x : X) (y : Y) → Dec (q x ≡ y) → Maybe T → Maybe T
  push x y dc (just v) = just v
  push x y dc nothing  = hitVal x y dc

  lookupPara : (ys : List X) → Locates q ys → Y → Maybe T
  lookupPara []       _        y = nothing
  lookupPara (x ∷ xs) (d , ds) y = push x y (d y) (lookupPara xs ds y)

  tablePara : (ys : List X) → Locates q ys → Y → T
  tablePara ys loc y = orElse (lookupPara ys loc y)

  ResolutionM : List X → (Y → Maybe T) → Type (ℓ-max ℓx (ℓ-max ℓy ℓt))
  ResolutionM ys f =
    (y : Y) →
        (Σ[ x ∈ X ] (Mem x ys × (q x ≡ y) × (f y ≡ just (t x))))
      ⊎ ((¬ Hits ys y) × (f y ≡ nothing))

  lookupPara-resM :
    (ys : List X) (loc : Locates q ys) → ResolutionM ys (lookupPara ys loc)
  lookupPara-resM []       loc      y =
    inr ((λ { (z , m , _) → Empty.rec* m }) , refl)
  lookupPara-resM (x ∷ xs) (d , ds) y with lookupPara-resM xs ds y
  ... | inl (z , mz , qz , ez) =
          inl (z , inr mz , qz , cong (push x y (d y)) ez)
  ... | inr (¬h , ez) with d y
  ...   | yes e =
            inl (x , inl refl , e , cong (push x y (yes e)) ez)
  ...   | no ¬e =
            inr ((λ { (z , inl z≡x , qz) → ¬e (cong q (sym z≡x) ∙ qz)
                    ; (z , inr m   , qz) → ¬h (z , m , qz) })
                , cong (push x y (no ¬e)) ez)

  tablePara-is-resolution :
    (ys : List X) (loc : Locates q ys) → Resolution ys (tablePara ys loc)
  tablePara-is-resolution ys loc y with lookupPara-resM ys loc y
  ... | inl (z , mz , qz , ez) = inl (z , mz , qz , cong orElse ez)
  ... | inr (¬h , ez)          = inr (¬h , cong orElse ez)

------------------------------------------------------------------------
-- 6.  Consequence: the two walks are one function, and the drawn
--     theorem's decoder is not unique.
------------------------------------------------------------------------

  policy-is-idle :
    (ys : List X) → CollisionFree q t ys → (loc : Locates q ys)
    → (y : Y) → table q t fb ys loc y ≡ tablePara ys loc y
  policy-is-idle ys cf loc =
    resolutions-agree ys cf (table q t fb ys loc) (tablePara ys loc)
      (table-is-resolution ys loc) (tablePara-is-resolution ys loc)

  tablePara-correct :
    (ys : List X) (loc : Locates q ys) → CollisionFree q t ys
    → (x : X) → Mem x ys → tablePara ys loc (q x) ≡ t x
  tablePara-correct ys loc cf x m =
      sym (policy-is-idle ys cf loc (q x))
    ∙ table-correct q t fb ys loc cf x m

  -- The ceiling theorem, witnessed by the other policy.  Same statement
  -- as `LocatingIsEnough.locatingFree→notRefuting`, different decoder —
  -- which is what "the metarule is idle" buys: the witness was never a
  -- function of the convention.
  paraWitness :
    (x₀ : X) (xs : List X)
    → (loc : Locates q (x₀ ∷ xs))
    → CollisionFree q t (x₀ ∷ xs)
    → ¬ Refutes (factorLaw q t) (x₀ ∷ xs)
  paraWitness x₀ xs loc cf ref = ref decode (holds (x₀ ∷ xs) (λ _ m → m))
    where
    decode : Image q → T
    decode p = tablePara (x₀ ∷ xs) loc (fst p)

    holds : (ys : List X) → ((x : X) → Mem x ys → Mem x (x₀ ∷ xs))
          → AllHold (factorLaw q t) decode ys
    holds []       _   = tt*
    holds (y ∷ ys) inc =
        tablePara-correct (x₀ ∷ xs) loc cf y (inc y (inl refl))
      , holds ys (λ z m → inc z (inr m))

------------------------------------------------------------------------
-- 7.  TWO REFUTATIONS OF MY OWN CLAIMS, on one carrier.
--
-- Rules are natural numbers; every rule is applicable to the single
-- observation `tt`; the task value is `true` at rule 1 and `false`
-- elsewhere.  So every list below is a maximal विप्रतिषेध: every rule
-- fires on every input.
------------------------------------------------------------------------

q3 : ℕ → Unit
q3 _ = tt

t3 : ℕ → Bool
t3 (suc zero) = true
t3 _          = false

dec3 : (n : ℕ) → (y : Unit) → Dec (q3 n ≡ y)
dec3 n y = yes (isPropUnit tt y)

ys2 : List ℕ
ys2 = 0 ∷ 1 ∷ []

ys3 : List ℕ
ys3 = 0 ∷ 1 ∷ 2 ∷ []

loc2 : Locates q3 ys2
loc2 = dec3 0 , dec3 1 , tt*

loc3 : Locates q3 ys3
loc3 = dec3 0 , dec3 1 , dec3 2 , tt*

-- Neither list is collision-free: rules 0 and 1 fire together and
-- prescribe different values.
cf2-fails : ¬ CollisionFree q3 t3 ys2
cf2-fails cf = false≢true (cf 0 1 (inl refl) (inr (inl refl)) refl)

cf3-fails : ¬ CollisionFree q3 t3 ys3
cf3-fails cf = false≢true (cf 0 1 (inl refl) (inr (inl refl)) refl)

------------------------------------------------------------------------
-- REFUTATION 1.
--
-- CLAIM A, as I first stated it, before checking: the walk's
-- first-match-wins is not a policy at all but an artefact of how the
-- recursion was written, so the two conventions agree — full stop, no
-- hypothesis.  That is the Pāṇinian lens taken past what it licenses:
-- 1.4.2 is conditioned on `vipratiṣedhe`, in conflict, and Claim A drops
-- the condition.
--
-- CLAIM A IS FALSE.  On `ys2` the earlier rule gives `false` and the
-- later gives `true`, at the only observation there is.
------------------------------------------------------------------------

first2 : (y : Unit) → table q3 t3 false ys2 loc2 y ≡ false
first2 y = refl

para2 : (y : Unit) → tablePara q3 t3 false ys2 loc2 y ≡ true
para2 y = refl

policy-is-observable-without-cf :
  ¬ ((y : Unit) → table q3 t3 false ys2 loc2 y ≡ tablePara q3 t3 false ys2 loc2 y)
policy-is-observable-without-cf h = false≢true (h tt)

------------------------------------------------------------------------
-- REFUTATION 2, the one that cost more.
--
-- CLAIM B, as I stated it after proving §6: collision-freedom is
-- EXACTLY the condition under which the two conventions agree — so
-- running both walks and comparing them is a test for rule conflict.
--
-- CLAIM B IS FALSE, in the direction that would have made it useful.
-- On `ys3` the first applicable rule is 0 with value `false` and the
-- last is 2 with value `false`.  The two conventions agree at every
-- observation.  The rule set is not collision-free — rules 0 and 1 are
-- in conflict — and the conflict is invisible to the comparison because
-- it sits between the endpoints the two conventions select.
--
-- This is `Durnaya_CollapseIffEveryNayaAgrees` again: I asserted a
-- two-way characterisation where I had proved one implication, and the
-- gap was closed by an explicit witness rather than by a rephrasing.
-- The `Mixed` witness there and `ys3` here are the same lesson at
-- different sites, and I did not import the lesson — I repeated the
-- error and then found the witness.
--
-- What survives of Claim B: agreement of ALL resolutions (§3's
-- quantifier, not two named ones) is a different statement, and `ys3`
-- says nothing about it.  A resolution selecting rule 1 exists on `ys3`
-- and differs from both walks.  Two policies are not a quantifier.
------------------------------------------------------------------------

first3 : (y : Unit) → table q3 t3 false ys3 loc3 y ≡ false
first3 y = refl

para3 : (y : Unit) → tablePara q3 t3 false ys3 loc3 y ≡ false
para3 y = refl

policies-agree-on-ys3 :
  (y : Unit) → table q3 t3 false ys3 loc3 y ≡ tablePara q3 t3 false ys3 loc3 y
policies-agree-on-ys3 y = refl

agreement-does-not-recover-collisionFree :
  ((y : Unit) → table q3 t3 false ys3 loc3 y ≡ tablePara q3 t3 false ys3 loc3 y)
  × (¬ CollisionFree q3 t3 ys3)
agreement-does-not-recover-collisionFree = policies-agree-on-ys3 , cf3-fails

-- and the third resolution that the two walks miss: it answers with
-- rule 1, and it is a Resolution of `ys3` in the sense of §1.
middle : Unit → Bool
middle _ = true

middle-is-resolution : Resolution q3 t3 false ys3 middle
middle-is-resolution y = inl (1 , inr (inl refl) , isPropUnit tt y , refl)

middle-differs :
  ¬ ((y : Unit) → table q3 t3 false ys3 loc3 y ≡ middle y)
middle-differs h = false≢true (h tt)

------------------------------------------------------------------------
-- 8.  WHICH LENS WINS, AND WHAT THE SCHOOLS SAY BACK.
--
-- THE SPLIT.  A machine's behaviour is what happens when it runs, so on
-- that reading `table`'s conflict-resolution policy is first-match-wins
-- and that is a fact about the object.  A rule system's ordering is
-- declared: a *paribhāṣā* is data added to the rule set, and asking what
-- it is means asking what was declared, not what happened.
--
-- §3 says the declared reading is right AT THIS SITE, and says it
-- exactly.  Under `CollisionFree` — the hypothesis under which the drawn
-- module's theorem is stated at all — the policy is not an observable of
-- the machine: no run distinguishes it, `paraWitness` witnesses the same
-- theorem without it, and `policy-is-idle` says the two walks are one
-- function.  The behavioural reading therefore attributes to the walk a
-- property that no behaviour of the walk exhibits.
--
-- §7 gives the behavioural reading its half back, and it is not small.
-- Off the hypothesis, the policy is observable in one step: `ys2`,
-- `false` against `true`.  So the metarule is not idle in general; it is
-- idle exactly where the drawn theorem lives, and 1.4.2 says as much in
-- its first word — `vipratiṣedhe`, IN CONFLICT.  A metarule conditioned
-- on conflict is silent when there is none.  That the condition is in
-- the sūtra and had to be rediscovered as a hypothesis here is the
-- finding, not a flourish.
--
-- THE BAUDDHA READING OF THE WALK, and it is a reading, not a result.
-- Each step of `table` is a decided exclusion: `no ¬e` is `¬ (q x ≡ y)`,
-- and the answer is reached by excluding, excluding, and landing.  Read
-- as Dignāgan *anyāpoha*, the decoder's content at y is the exclusions
-- it performs there.  §3 then says something about apoha that a Bauddha
-- would want: the ORDER of the exclusions is not part of the content
-- when the rules do not conflict.  Dignāga's *apoha* is not a procedure
-- and has no order; Dharmakīrti's is a cognitive act, and acts occur in
-- sequence.  `policy-is-idle` is the exact extent to which those two
-- descriptions coincide.
--
-- THE NAIYĀYIKA READS `Locates` AND SEES NO EXCLUSION AT ALL.  What the
-- drawn module hands the walk is, per listed point, `(y : Y) → Dec
-- (q x ≡ y)` — a decision about a positive statement.  On his account
-- that is the *pratiyogin* fully specified and delimited by x, which is
-- what `Abhava.agda` already forces every absence to carry.  So the
-- walk is not excluding; it is testing positive entities and reporting.
-- He adds: this is the circularity charge in its executable form.  You
-- cannot write `no ¬e` without having `q x ≡ y` in hand first.
--
-- WHAT EACH SAYS TO THE OTHER, kept as two voices because the dispute is
-- the content.  The Naiyāyika says a *pratiyogin* is an entity and
-- entities have no order, so any order-independence result is his and
-- costs nothing.  The Bauddha says the theorem was not free — it has a
-- hypothesis, `CollisionFree`, and §7 exhibits its failure — so the
-- order-independence is a fact about the rule set and not about the
-- ontology of the counterpositive.  The check does not adjudicate.  It
-- locates the disagreement at whether the hypothesis is a fact about
-- what there is or about what was written down, and that is a different
-- question from the one either was arguing.
--
-- OPEN, named and not estimated.
--   (a) Whether the right-operand reading of 1.4.2 is expressible as a
--       `Resolution` at all.  It selects by the shape of the input, not
--       by list position, and nothing here models the input's shape.
--   (b) Whether some weaker hypothesis than `CollisionFree` still makes
--       every Resolution agree.  `ys3` shows agreement of TWO policies
--       is strictly weaker than collision-freedom; it says nothing about
--       agreement of all of them, and I did not settle that.
--   (c) The Tibetan transmission (*Tshad ma rigs gter*, c. 1219) is
--       absent from this repository and from this module.  Reported as
--       a gap in coverage, not as a result.
------------------------------------------------------------------------
