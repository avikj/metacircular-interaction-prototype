{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Nirjara_SheddingAPrimitiveCostsLaghava
--
-- निर्जरा at the level of the vocabulary, and what it costs.
--
-- Tattvārthasūtra 10.1: कevala-jñāna arises from the DESTRUCTION of the
-- obscuring karmas.  Omniscience is not acquired; it is what remains when
-- obscuration is removed.  And 9.19-9.20: nirjarā is brought about by
-- tapas.  Shedding that happens on its own as karma ripens — savipāka —
-- happens to everyone and gains nothing; only avipāka, deliberate and
-- before its time, is a path.
--
-- Taken as given rather than as a model, that says something exact about
-- this repository's engine, which ANEKANTA.md §13 states and does not
-- prove: every organ the engine has ADDS.  `bestOf` names a frequent
-- subterm; concept invention adds a symbol.  Nothing removes one, and the
-- primitives are therefore treated as having svabhāva — the question of
-- whether they carve anything cannot be posed.
--
-- Here is why that will not fix itself, and it is not an oversight in the
-- implementation.  Shedding an INERT primitive — one whose every use is
-- eval-equal to a use-free term — loses no meaning (§2) and does remove
-- the symbol (§3).  But it strictly INCREASES the presentation (§4).  So
-- an engine steered by लाघव can never take the step: brevity opposes
-- nirjarā, always, and savipāka never arrives.  Only tapas removes a
-- primitive, and tapas is by definition the operation you do against the
-- gradient.
--
-- `Laghava.agda` proves cost lives on the presentation and no function of
-- the denotation computes it.  This is that boundary with a direction:
-- the presentation is exactly what nirjarā has to pay.
--
-- CHECKED: exit code quoted in the commit message.  Agda 2.6.3 + cubical
-- v0.5 in this container, which is NOT the repository pin.
------------------------------------------------------------------------

module NaturalMachine.Nirjara_SheddingAPrimitiveCostsLaghava where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; injSuc ; snotz ; znots)
open import Cubical.Data.Nat.Properties using (+-zero)
open import Cubical.Foundations.Prelude using (funExt⁻)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (Σ ; _,_ ; _×_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)

------------------------------------------------------------------------
-- 1.  A vocabulary with one candidate primitive.
--     `dvi` is the invented symbol: doubling.  It is inert — everything
--     it says, `yoga` already says.
------------------------------------------------------------------------

data Pada : Type₀ where
  cara : Pada                    -- the variable
  mita : ℕ → Pada                -- a literal
  yoga : Pada → Pada → Pada      -- addition
  dvi  : Pada → Pada             -- the candidate primitive

Artha : Type₀
Artha = ℕ → ℕ

artha : Pada → Artha
artha cara       n = n
artha (mita k)   _ = k
artha (yoga a b) n = artha a n + artha b n
artha (dvi a)    n = artha a n + artha a n

------------------------------------------------------------------------
-- 2.  निर्जरा — the shedding.  Rewrite every use of the primitive away.
--     Meaning is untouched: this is what "inert" means, proved.
------------------------------------------------------------------------

nirjara : Pada → Pada
nirjara cara       = cara
nirjara (mita k)   = mita k
nirjara (yoga a b) = yoga (nirjara a) (nirjara b)
nirjara (dvi a)    = yoga (nirjara a) (nirjara a)

nirjara-artha-aviruddha : (e : Pada) → artha (nirjara e) ≡ artha e
nirjara-artha-aviruddha cara       = refl
nirjara-artha-aviruddha (mita k)   = refl
nirjara-artha-aviruddha (yoga a b) i n =
  nirjara-artha-aviruddha a i n + nirjara-artha-aviruddha b i n
nirjara-artha-aviruddha (dvi a)    i n =
  nirjara-artha-aviruddha a i n + nirjara-artha-aviruddha a i n

------------------------------------------------------------------------
-- 3.  And the symbol is gone.  Not "used less": absent.
------------------------------------------------------------------------

dviYukta : Pada → Bool
dviYukta cara       = false
dviYukta (mita _)   = false
dviYukta (yoga a b) with dviYukta a
... | true  = true
... | false = dviYukta b
dviYukta (dvi _)    = true

nirjara-shuddha : (e : Pada) → dviYukta (nirjara e) ≡ false
nirjara-shuddha cara     = refl
nirjara-shuddha (mita k) = refl
nirjara-shuddha (dvi a)  with dviYukta (nirjara a) | nirjara-shuddha a
... | false | p = nirjara-shuddha a
... | true  | p = p
nirjara-shuddha (yoga a b) with dviYukta (nirjara a) | nirjara-shuddha a
... | false | _ = nirjara-shuddha b
... | true  | p = p

------------------------------------------------------------------------
-- 4.  लाघव — and this is the whole point.  The shedding is not free.
--     The presentation strictly grows.
------------------------------------------------------------------------

laghava : Pada → ℕ
laghava cara       = 1
laghava (mita _)   = 1
laghava (yoga a b) = suc (laghava a + laghava b)
laghava (dvi a)    = suc (laghava a)

private
  2≢3 : ¬ (2 ≡ 3)
  2≢3 p = snotz (sym (injSuc (injSuc p)))

-- The witness, and it is the smallest one there is.
sakshin : Pada
sakshin = dvi cara

nirjara-laghavam-vardhayati : ¬ (laghava (nirjara sakshin) ≡ laghava sakshin)
nirjara-laghavam-vardhayati p = 2≢3 (sym p)

------------------------------------------------------------------------
-- 5.  तपस् — the three facts as one statement.
--
-- Shedding an inert primitive: preserves the meaning, removes the symbol,
-- and costs brevity.  An engine that grows by adding and is steered by
-- लाघव will therefore never shed one — not because it was built badly,
-- but because the step is against its gradient at every instance.
--
-- सविपाक निर्जरा — shedding that happens on its own — cannot occur here.
-- There is no ripening that removes a symbol; the vocabulary only ever
-- grows.  Only अविपाक, deliberate and against the gradient, does it, and
-- Tattvārthasūtra 9.19-9.20 names that तपस्.
------------------------------------------------------------------------
tapas : (e : Pada)
      → Σ (artha (nirjara e) ≡ artha e)
          (λ _ → dviYukta (nirjara e) ≡ false)
tapas e = nirjara-artha-aviruddha e , nirjara-shuddha e

------------------------------------------------------------------------
-- 6.  The second obstruction, and it is independent of the first.
--
-- §4 says an engine steered by लाघव will never CHOOSE to shed.  This says
-- it could not FIND what to shed either, and for a different reason.
--
-- The engine inspects what it has proved — equations, i.e. denotations.
-- But an inert primitive leaves no trace there: every meaning reachable
-- with it is reachable without it (§2, §3), so the two presentations sit
-- in the same fibre of `artha` and no function of the meaning can report
-- which one was used.
--
-- This is `Laghava.agda`'s shape a second time.  There, size was invisible
-- to the denotation.  Here, USE OF A SYMBOL is invisible to the
-- denotation — which is worse for the engine, because size at least is
-- something it never needed, while the symbol list is the thing §13 of
-- ANEKANTA.md says it cannot interrogate.
------------------------------------------------------------------------

-- the same meaning, said with the primitive and without it
tulya-artha : artha (dvi cara) ≡ artha (yoga cara cara)
tulya-artha = refl

-- and the two are distinguished by the symbol they use
dvi-yukta-bheda : ¬ (dviYukta (dvi cara) ≡ dviYukta (yoga cara cara))
dvi-yukta-bheda p = true≢false p

-- so nothing computed from the meaning reports the use
prayoga-na-arthasya : ¬ (Σ (Artha → Bool) (λ f → (e : Pada) → f (artha e) ≡ dviYukta e))
prayoga-na-arthasya (f , spec) =
  dvi-yukta-bheda ( sym (spec (dvi cara))
                  ∙ cong f tulya-artha
                  ∙ spec (yoga cara cara) )

------------------------------------------------------------------------
-- 7.  The two obstructions together.
--
-- An engine that wanted to shed a primitive would have to (a) choose a
-- step that strictly increases the quantity it minimises, and (b) locate
-- the symbol to shed, from evidence in which the symbol leaves no trace.
--
-- Neither follows from the other.  (a) is about the gradient and would
-- survive perfect detection; (b) is about the evidence and would survive
-- any objective.  Both hold here, and this is a vocabulary with a single
-- redundant symbol — the easiest case there is.
--
-- What the tradition prescribes at exactly this point is not a better
-- objective and not a better sensor.  It is तपस्: the deliberate act
-- against the gradient, undertaken because the obscuration is known to be
-- there and not because anything reported it.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  Widening the verdict does not help, and this is the general form.
--
-- §6 refuted a BOOLEAN test of the meaning.  The natural repair in this
-- corpus — the one `Saptabhangi.agda` exists for, and the one
-- ANEKANTA.md §1 argues at length — is to replace the boolean by more
-- positions.  It does not touch this obstruction, and the reason is one
-- line: the failure is the FACTORING, not the arity of the verdict.
--
-- Every function of the meaning whatsoever, into any type at all, agrees
-- on the two presentations.  Seven positions agree; seventy do; a type of
-- proofs does.
------------------------------------------------------------------------

sarva-artha-samam :
  {ℓ : Level} {X : Type ℓ} (g : Artha → X)
  → g (artha (dvi cara)) ≡ g (artha (yoga cara cara))
sarva-artha-samam g = cong g tulya-artha

------------------------------------------------------------------------
-- 9.  What DOES license the shedding, and it is of a different kind.
--
-- Not a function of the meaning — §8 closes that off for every target.
-- The licence is `nirjara-artha-aviruddha`: a statement quantified over
-- ALL terms, proved about the syntax, which no evaluation of any
-- particular meaning yields.
--
-- In the inventory of ANEKANTA.md §4 that is not प्रत्यक्ष and not
-- अनुमान.  Both of those, in this engine, run on the accepted set —
-- evaluation of candidates, and inference from equations already held —
-- and both therefore factor through `artha`.  §8 says everything that
-- factors through `artha` is blind here.
--
-- What remains is शब्द: the naya arrives as testimony, and what is
-- transmitted is not a verdict but the ground of one.  `MathMachine.hs`
-- reached the same place for a different reason and recorded it as
-- śabda — a theorem this engine kernel-checked and wrote down is
-- testimony from an āpta, and what that testimony conveys is the NAYA,
-- not the truth value.
--
-- NOT CLAIMED: that śabda is the only route in general.  What is proved
-- is narrower and sufficient for the point — nothing factoring through
-- the denotation can see it, and the thing that does see it is a proof
-- about the syntax rather than a reading of any meaning.
------------------------------------------------------------------------

shabda-eva : (e : Pada) → artha (nirjara e) ≡ artha e
shabda-eva = nirjara-artha-aviruddha

------------------------------------------------------------------------
-- 10.  लाघव is stable under the removal, so §4 measured the right thing.
--
-- §4 compared `laghava (nirjara e)` with `laghava e`, both computed in the
-- syntax that still HAS `dvi`.  That invites an objection: after shedding,
-- the honest home of the term is the smaller signature, where लाघव is a
-- different function, and a cost measured in the larger one might be an
-- artefact of the measuring.
--
-- It is not.  The small syntax embeds, the measure agrees on the image,
-- and shedding lands in the image — so the number is the same whichever
-- signature computes it.
--
-- This is thread (3) at the one place it can be settled exactly: लाघव is
-- stable under अपवाद-style vocabulary change, and therefore the price in
-- §4 is a fact about the presentation rather than about the frame it was
-- weighed in.
------------------------------------------------------------------------

data Laghu : Type₀ where
  cara'  : Laghu
  mita'  : ℕ → Laghu
  yoga'  : Laghu → Laghu → Laghu

nyasa : Laghu → Pada
nyasa cara'        = cara
nyasa (mita' k)    = mita k
nyasa (yoga' a b)  = yoga (nyasa a) (nyasa b)

matra : Laghu → ℕ
matra cara'       = 1
matra (mita' _)   = 1
matra (yoga' a b) = suc (matra a + matra b)

-- the measure does not notice which signature it is computed in
laghava-nyasa-samam : (t : Laghu) → laghava (nyasa t) ≡ matra t
laghava-nyasa-samam cara'       = refl
laghava-nyasa-samam (mita' k)   = refl
laghava-nyasa-samam (yoga' a b) i =
  suc (laghava-nyasa-samam a i + laghava-nyasa-samam b i)

-- shedding, done directly into the smaller signature
apavada : Pada → Laghu
apavada cara       = cara'
apavada (mita k)   = mita' k
apavada (yoga a b) = yoga' (apavada a) (apavada b)
apavada (dvi a)    = yoga' (apavada a) (apavada a)

-- and the two routes agree: shed-then-embed is shed-in-place
nyasa-apavada : (e : Pada) → nyasa (apavada e) ≡ nirjara e
nyasa-apavada cara       = refl
nyasa-apavada (mita k)   = refl
nyasa-apavada (yoga a b) i = yoga (nyasa-apavada a i) (nyasa-apavada b i)
nyasa-apavada (dvi a)    i = yoga (nyasa-apavada a i) (nyasa-apavada a i)

-- so the cost of §4 is signature-independent
laghava-sthiram : (e : Pada) → matra (apavada e) ≡ laghava (nirjara e)
laghava-sthiram e =
  sym (laghava-nyasa-samam (apavada e)) ∙ cong laghava (nyasa-apavada e)

------------------------------------------------------------------------
-- 11.  उपमान — the other direction, and it is free.
--
-- §2-§10 run one way: remove a primitive, pay लाघव.  The converse move is
-- the organ ANEKANTA.md §4 names as missing and bets on — उपमान, the
-- transfer of a proved shape into an unmet vocabulary, licensed by
-- STATED similarity rather than by re-derivation.  The engine's measured
-- defect is exactly its absence: every vocabulary starts at zero, and
-- more than half of every proof it has ever performed was a
-- re-derivation of something it already held.
--
-- Here the licence is `nyasa` and the stated similarity is that it
-- preserves meaning.  Given that, an equation established in the smaller
-- vocabulary holds in the larger one with no further work.
--
-- And by §10 the transfer is free in the other coordinate too: `nyasa`
-- preserves लाघव exactly.  So along this embedding उपमान costs nothing in
-- either currency — meaning or presentation — which is what makes its
-- absence from the engine a defect rather than a design choice.
------------------------------------------------------------------------

artha' : Laghu → Artha
artha' cara'       n = n
artha' (mita' k)   _ = k
artha' (yoga' a b) n = artha' a n + artha' b n

-- the stated similarity: the embedding preserves meaning
nyasa-artha : (t : Laghu) → artha (nyasa t) ≡ artha' t
nyasa-artha cara'       = refl
nyasa-artha (mita' k)   = refl
nyasa-artha (yoga' a b) i n = nyasa-artha a i n + nyasa-artha b i n

-- so a theorem of the small vocabulary is a theorem of the large one
upamana : (s t : Laghu) → artha' s ≡ artha' t → artha (nyasa s) ≡ artha (nyasa t)
upamana s t p = nyasa-artha s ∙ p ∙ sym (nyasa-artha t)

-- and it costs nothing in the other currency either
upamana-laghavam-na-vardhayati : (t : Laghu) → laghava (nyasa t) ≡ matra t
upamana-laghavam-na-vardhayati = laghava-nyasa-samam

------------------------------------------------------------------------
-- 12.  उपाधि — the condition under which §11 fails, so the hypothesis is
--      shown load-bearing rather than decorative.
--
-- §11 could be read as "transfer into a larger vocabulary is free."  It
-- is not.  It is free GIVEN the stated similarity, and the tradition's
-- whole difficulty is there: a व्याप्ति holds only where no उपाधि defeats
-- it, and Gaṅgeśa's apparatus exists to hunt the defeating condition.
-- ANEKANTA.md §12 records the engine failing exactly here — it asserts a
-- pervasion from forty sampled assignments and has no उपाधि search at all.
--
-- So: a translation that does NOT preserve meaning, and upamāna fails for
-- it.  The failure is not subtle and not asymptotic; one pair defeats it.
------------------------------------------------------------------------

-- a translation that reads yoga as doubling of its first part
bhrama : Laghu → Pada
bhrama cara'       = cara
bhrama (mita' k)   = mita k
bhrama (yoga' a b) = dvi (bhrama a)

private
  -- the two small terms whose meanings agree
  vama dakshina : Laghu
  vama     = yoga' cara' (mita' 0)
  dakshina = cara'

  artha'-samam : artha' vama ≡ artha' dakshina
  artha'-samam i n = +-zero n i

  -- and whose images do not
  bhrama-bheda : ¬ (artha (bhrama vama) ≡ artha (bhrama dakshina))
  bhrama-bheda p = snotz (injSuc (funExt⁻ p 1))

upamana-upadhi-apeksate :
  ¬ ((s t : Laghu) → artha' s ≡ artha' t → artha (bhrama s) ≡ artha (bhrama t))
upamana-upadhi-apeksate f = bhrama-bheda (f vama dakshina artha'-samam)

------------------------------------------------------------------------
-- 13.  What §11 and §12 say together.
--
-- The transfer is free and the licence is not.  `nyasa-artha` is a
-- theorem someone had to prove; without it §11 is false, and §12 exhibits
-- a translation for which it is false.  So उपमान is not "similarity is
-- cheap" — it is: state the similarity, prove it, and then the carrying
-- costs nothing.
--
-- That is also the exact form of the engine's defect in ANEKANTA.md §12.
-- Sampling as REFUTATION is sound — one disagreeing assignment is a proof
-- of falsity, and `bhrama-bheda` above is one, at n = 1.  Sampling as
-- LICENCE is the voting machine.  The two halves must not be collapsed in
-- either direction.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 14.  The उपाधि lives in the TRANSLATION, not in the instances — so the
--      engine is sampling the wrong space.
--
-- ANEKANTA.md §12 records the engine establishing a व्यापति by evaluating
-- both sides on forty pseudo-random assignments and grouping terms whose
-- value vectors match.  Nyāya's objection is that a pervasion is not
-- established by polling instances; you must actively seek the condition
-- that defeats it.
--
-- §12 above sharpens that objection into something exact, and the point
-- is not that forty is too few.  It is that no number is enough, because
-- the defeating condition is not in the instances at all.
--
-- `vama` and `dakshina` agree at EVERY assignment — the equality is total,
-- not sampled.  An engine drawing a million points from the source side
-- gets agreement a million times, correctly, and learns nothing, because
-- what defeats the transfer is a property of `bhrama` and only shows
-- after translation.
------------------------------------------------------------------------

-- sampling the source agrees everywhere, at every point, forever
sarvatra-samam : (n : ℕ) → artha' vama n ≡ artha' dakshina n
sarvatra-samam n = +-zero n

-- and the transfer is defeated anyway
upadhi-anuvade-vasati :
  ((n : ℕ) → artha' vama n ≡ artha' dakshina n)
  × (¬ (artha (bhrama vama) ≡ artha (bhrama dakshina)))
upadhi-anuvade-vasati = sarvatra-samam , bhrama-bheda

------------------------------------------------------------------------
-- 15.  What that costs the engine, stated as the repair it implies.
--
-- The forty assignments are drawn from the space of ASSIGNMENTS.  The
-- upādhi hunted by the Naiyāyikas is in the space of TRANSLATIONS — the
-- maps under which a shape is carried into an unmet vocabulary.  Those
-- are different spaces, and no sampling density in the first reaches the
-- second.
--
-- So `MathMachine`'s value-vector grouping is not an underpowered version
-- of upamāna's licence.  It is a test of a different thing, and the
-- honest form of the repair is not more draws: it is that a transfer
-- must carry a PROOF of its similarity, as `nyasa-artha` does, and a
-- translation that cannot produce one is refused.
--
-- Sampling keeps its sound half exactly as §13 said: one disagreeing
-- assignment after translation is a proof of falsity, and `bhrama-bheda`
-- is one.  Refutation by instance, licence by proof.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 16.  सादृश्य — the licence made structural, so a translation without a
--      proof cannot be applied at all.
--
-- §15 said the repair is that a transfer must carry a proof of its
-- similarity and a translation that cannot produce one is refused.  Said
-- that way it is a rule someone has to remember to enforce, and
-- `Anekanta.agda` §18's lesson is that a rule of that shape drifts back:
-- an enum still permits a contentless verdict, and a check still permits
-- being skipped.
--
-- So the licence is not a check here.  It is the carrier.  उपमान takes a
-- सादृश्य — a map bundled with its preservation proof — and there is
-- nowhere in the type a bare translation can sit.
------------------------------------------------------------------------

record Sadrsya : Type₀ where
  constructor sadrsyam
  field
    anuvada : Laghu → Pada
    pramana : (t : Laghu) → artha (anuvada t) ≡ artha' t

open Sadrsya public

-- the transfer, now total: no hypothesis beyond the carrier itself
upamana-sadrsyat :
  (S : Sadrsya) (s t : Laghu)
  → artha' s ≡ artha' t
  → artha (anuvada S s) ≡ artha (anuvada S t)
upamana-sadrsyat S s t p = pramana S s ∙ p ∙ sym (pramana S t)

-- नयास is one
nyasa-sadrsyam : Sadrsya
nyasa-sadrsyam = sadrsyam nyasa nyasa-artha

-- and भ्रम cannot be: the type has no inhabitant carrying it
bhrama-na-sadrsyam : ¬ (Σ Sadrsya (λ S → anuvada S ≡ bhrama))
bhrama-na-sadrsyam (S , e) =
  bhrama-bheda ( cong (λ f → artha (f vama)) (sym e)
               ∙ upamana-sadrsyat S vama dakshina artha'-samam
               ∙ cong (λ f → artha (f dakshina)) e )

------------------------------------------------------------------------
-- 17.  What changed between §11 and §16.
--
-- §11's `upamana` took the similarity as a loose hypothesis, which is
-- exactly the shape §12 then defeated: the hypothesis can be omitted at
-- the call site because nothing in the type demands it.  §16 removes the
-- possibility rather than guarding against it — the same move
-- `Anekanta.agda` makes when it replaces a truth-value by a verdict that
-- carries its witness, and the same one `machine/Obstruction.hs` made
-- when `Aviruddha` was given the domain it searched.
--
-- The engine's version of this is concrete: a remembered theorem
-- re-admitted under a naya it was not proved in is a transfer applied
-- without its licence, and `MathMachine`'s repair was to make the record
-- carry the naya rather than to check harder at the gate.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 18.  मूल्य — the price of a सादृश्य, and where it is invisible.
--
-- §16 made the licence structural: a `Sadrsya` cannot exist without its
-- certificate, so every translation that inhabits the record is
-- meaning-preserving and the comparison is free.  That settles whether a
-- transport between two standpoints is POSSIBLE.  It says nothing about
-- what one COSTS, and the two questions come apart completely here.
------------------------------------------------------------------------

-- the price of routing t through S is the लाघव of what comes out
mulya : Sadrsya → Laghu → ℕ
mulya S t = laghava (anuvada S t)

-- न्यास charges nothing above the मात्रा already there
nyasa-nirmulyam : (t : Laghu) → mulya nyasa-sadrsyam t ≡ matra t
nyasa-nirmulyam = laghava-nyasa-samam

-- a second सादृश्य: same meaning, more presentation.  It appends a
-- summand that contributes zero — the आगम that changes nothing said.
sthula : Laghu → Pada
sthula t = yoga (nyasa t) (mita 0)

sthula-artha : (t : Laghu) → artha (sthula t) ≡ artha' t
sthula-artha t =
  funExt (λ n → +-zero (artha (nyasa t) n)) ∙ nyasa-artha t

sthula-sadrsyam : Sadrsya
sthula-sadrsyam = sadrsyam sthula sthula-artha

-- ANY two सादृश्यs agree on meaning everywhere, by their own certificates.
-- Nothing is assumed here: the record's field is the proof.
mulya-artha-samam : (S T : Sadrsya) (t : Laghu)
                  → artha (anuvada S t) ≡ artha (anuvada T t)
mulya-artha-samam S T t = pramana S t ∙ sym (pramana T t)

-- hence every invariant of the meaning identifies them, whatever it is
sarvam-arthasya-samam :
  {ℓ : Level} {X : Type ℓ} (g : Artha → X) (S T : Sadrsya) (t : Laghu)
  → g (artha (anuvada S t)) ≡ g (artha (anuvada T t))
sarvam-arthasya-samam g S T t = cong g (mulya-artha-samam S T t)

-- and the price does not identify them
mulya-bheda : ¬ (mulya nyasa-sadrsyam cara' ≡ mulya sthula-sadrsyam cara')
mulya-bheda p = znots (injSuc p)

-- so no function of the meaning is the price
mulya-na-arthasya :
  ¬ (Σ (Artha → ℕ)
       (λ c → (S : Sadrsya) (t : Laghu) → c (artha (anuvada S t)) ≡ mulya S t))
mulya-na-arthasya (c , h) =
  mulya-bheda ( sym (h nyasa-sadrsyam cara')
              ∙ cong c (mulya-artha-samam nyasa-sadrsyam sthula-sadrsyam cara')
              ∙ h sthula-sadrsyam cara' )

------------------------------------------------------------------------
-- 19.  Possibility is free; the price is real and univalence cannot see it.
--
-- Put §16 and §18 together.  Between any two सादृश्यs the transport is
-- total, canonical and costs nothing in meaning — `mulya-artha-samam`
-- needs no hypothesis, because both records carry their own certificate
-- and the certificates compose.  So "can this standpoint's result be
-- moved to that one?" is not a question with content here.  It is always
-- yes.
--
-- `mulya-na-arthasya` says the other question has content and cannot be
-- answered in the same currency.  A univalent invariant is by
-- construction a function of the denotation, and `sarvam-arthasya-samam`
-- shows every such function assigns न्यास and स्थूल the same value, at
-- every argument, for every codomain.  The लाघव separates them.  So the
-- price is not merely uncomputed by univalence — there is no invariant
-- of the identified object that it could be.
--
-- This is what the लाघव note asserted and did not prove: cost lives on
-- the presentation, and univalence discards the presentation.  Here it is
-- a theorem about two concrete inhabitants of one record type rather than
-- an argument about what univalence is.
--
-- The Pāṇinian reading is direct.  Two derivations of the same form are
-- the same form; the grammar still prefers one, and `vipratiṣedhe paraṁ
-- kāryam` is a rule about which DERIVATION wins, never about which output
-- is correct — both outputs are the same string.  A criterion that could
-- be recovered from the output would not need to be stated.  स्थूल is the
-- आगम that adds a zero: nothing said changes, and the derivation is
-- longer, which is exactly the situation लाघव was invented to adjudicate.
--
-- What is NOT shown: that लाघव is the right price, or that any price
-- exists that is stable under अनुवृत्ति and प्रत्याहार.  §18 exhibits one
-- measure that separates two सादृश्यs; a measure and a metric are not the
-- same thing, and nothing here compares two prices for the same transport
-- computed in two signatures.  §5 did that for one shedding (`laghava-
-- sthiram`) and it does not generalise for free.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 20.  सन्दर्भ — contexts, and the saturation that still is not enough.
--
-- The backward reading stream's D0026 entry states the mature law as four
-- INDEPENDENT coordinates —
--
--     lawful compression = task sufficiency
--                        + future descent
--                        + path coherence
--                        + source/proof trace
--
-- — with the operative criterion that "a distinction may be discarded
-- only after proving every supported insertion context is insensitive to
-- it", and its dynamical form N_obs = ⋂_n ker(P T^n): discardable iff no
-- supported future can ever make it matter again.  The projection
-- curvature (PUP)(PVP) − PUVP = −PUQVP names the failure mode: the defect
-- is the history that leaves the visible sector and returns.
--
-- §18 is a witness that the fourth coordinate is not a limit of the
-- first.  Here the saturation is carried out in full and it changes
-- nothing.
------------------------------------------------------------------------

-- a पद with one hole, which is every insertion context this language has
data Sandarbha : Type₀ where
  chidra         : Sandarbha
  yoga-vama      : Sandarbha → Pada → Sandarbha
  yoga-dakshina  : Pada → Sandarbha → Sandarbha
  dvi-antar      : Sandarbha → Sandarbha

sthapana : Sandarbha → Pada → Pada
sthapana chidra              e = e
sthapana (yoga-vama C b)     e = yoga (sthapana C e) b
sthapana (yoga-dakshina a C) e = yoga a (sthapana C e)
sthapana (dvi-antar C)       e = dvi (sthapana C e)

-- every context acts on MEANINGS.  Nothing that has left the visible
-- sector can come back: the curvature of this projection is zero.
sandarbha-arthe-vartate :
  (C : Sandarbha) (a b : Pada) → artha a ≡ artha b
  → artha (sthapana C a) ≡ artha (sthapana C b)
sandarbha-arthe-vartate chidra a b p = p
sandarbha-arthe-vartate (yoga-vama C d) a b p =
  funExt (λ n → cong (_+ artha d n)
                     (funExt⁻ (sandarbha-arthe-vartate C a b p) n))
sandarbha-arthe-vartate (yoga-dakshina d C) a b p =
  funExt (λ n → cong (artha d n +_)
                     (funExt⁻ (sandarbha-arthe-vartate C a b p) n))
sandarbha-arthe-vartate (dvi-antar C) a b p =
  funExt (λ n → cong₂ _+_ (funExt⁻ (sandarbha-arthe-vartate C a b p) n)
                          (funExt⁻ (sandarbha-arthe-vartate C a b p) n))

-- अविशेष: indistinguishable in every context the language admits.
-- This is the contextual-equivalence-as-अहिंसा condition, in full.
Avishesha : Pada → Pada → Type₀
Avishesha a b = (C : Sandarbha) → artha (sthapana C a) ≡ artha (sthapana C b)

-- ANY two सादृश्यs are अविशेष.  Saturating over contexts adds nothing to
-- §18, because §18 already had the whole of it.
sadrsya-avishesha : (S T : Sadrsya) (t : Laghu)
                  → Avishesha (anuvada S t) (anuvada T t)
sadrsya-avishesha S T t C =
  sandarbha-arthe-vartate C (anuvada S t) (anuvada T t) (mulya-artha-samam S T t)

nyasa-sthula-avishesha : (t : Laghu) → Avishesha (nyasa t) (sthula t)
nyasa-sthula-avishesha t =
  sadrsya-avishesha nyasa-sadrsyam sthula-sadrsyam t

-- and लाघव is still not determined by it
avishesha-laghavam-na-niyacchati :
  ¬ ((a b : Pada) → Avishesha a b → laghava a ≡ laghava b)
avishesha-laghavam-na-niyacchati h =
  mulya-bheda (h (nyasa cara') (sthula cara') (nyasa-sthula-avishesha cara'))

------------------------------------------------------------------------
-- 21.  Zero curvature does not license forgetting.
--
-- N_obs and the curvature identity both measure ONE thing: whether a
-- discarded distinction can re-enter the observable channel later.  They
-- are the right criterion for what they measure, and in this language
-- they are satisfied outright — `sandarbha-arthe-vartate` says every
-- context factors through the meaning, so there is no U, V, Q with
-- (PUP)(PVP) ≠ PUVP.  The defect term is identically absent.
--
-- लाघव is separated anyway.  So the fourth coordinate is not the limit of
-- the first: provenance is not a distinction that fails to be observed
-- YET, it is one that no supported future observes and that matters
-- regardless.  A criterion of the form "discard what no future will need"
-- cannot reach it, at any depth, because the quantifier runs over
-- observations and लाघव is not an observation.  That is the same sentence
-- §18 proved semantically (`sarvam-arthasya-samam`) arriving from the
-- dynamical side, and it is why the stream's four coordinates have to be
-- independent rather than nested.
--
-- The direction of the finding matters.  This does not weaken contextual
-- saturation — it confirms that stating it as a SEPARATE axis was the
-- load-bearing move.  Had provenance been recoverable from N_obs, the
-- fourth coordinate would be decoration; here is a language in which the
-- first three are exactly and trivially satisfied and the fourth is
-- violated by two terms of the smallest possible size.
--
-- What this does NOT show: that लाघव is the provenance coordinate, or
-- that every provenance obligation behaves like it.  स्थूल is one आगम that
-- adds a zero.  A general statement would need the शब्द-side notion of
-- what a derivation records, and §19 already lists that as absent.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 22.  अनुवृत्ति — a word written once carries forward, and that is a
--      measure on DERIVATIONS which the measure on trees cannot be.
--
-- §6 of the लाघव note names the missing object: a measure on presentations
-- stable under the moves the roots licence — अनुवृत्ति, प्रत्याहार, अपवाद —
-- and unstable under everything else, and says it does not know one.
--
-- Here is the अनुवृत्ति coordinate of it, and the reason `laghava` is not
-- it.  In the Aṣṭādhyāyī a word supplied in one sūtra persists into the
-- following ones: it is written ONCE and used many times.  A tree does not
-- have that.  A tree has occurrences, and `laghava` counts occurrences, so
-- it charges the second use at full price.  A प्रक्रिया — an ordered list of
-- sūtras, each free to refer back to what earlier ones produced — has
-- exactly the missing structure, and its मात्रा is its length.
------------------------------------------------------------------------

data Sutra : Type₀ where
  cara-s : Sutra
  mita-s : ℕ → Sutra
  yoga-s : ℕ → ℕ → Sutra      -- अनुवृत्ति: two back-references
  dvi-s  : ℕ → Sutra

-- head is the LAST sūtra written, so continuing a derivation is `_∷_`
Prakriya : Type₀
Prakriya = List Sutra

-- look back i steps into what has already been derived
anu : List Pada → ℕ → Pada
anu []       _       = cara
anu (p ∷ _)  zero    = p
anu (_ ∷ ps) (suc i) = anu ps i

pada-of : Sutra → List Pada → Pada
pada-of cara-s       _  = cara
pada-of (mita-s m)   _  = mita m
pada-of (yoga-s i j) ps = yoga (anu ps i) (anu ps j)
pada-of (dvi-s i)    ps = dvi (anu ps i)

sadhana : Prakriya → List Pada
sadhana []       = []
sadhana (s ∷ ss) = pada-of s (sadhana ss) ∷ sadhana ss

phala : Prakriya → Pada
phala []       = cara
phala (s ∷ ss) = pada-of s (sadhana ss)

matra-p : Prakriya → ℕ
matra-p = length

anu-zero : (P : Prakriya) → anu (sadhana P) zero ≡ phala P
anu-zero []       = refl
anu-zero (s ∷ ss) = refl

-- the move itself: use what was just derived, twice, without rewriting it
anuvrtti : Prakriya → Prakriya
anuvrtti P = yoga-s zero zero ∷ P

anuvrtti-phala : (P : Prakriya) → phala (anuvrtti P) ≡ yoga (phala P) (phala P)
anuvrtti-phala P i = yoga (anu-zero P i) (anu-zero P i)

-- and it costs ONE सूत्र, whatever it was applied to
anuvrtti-matra : (P : Prakriya) → matra-p (anuvrtti P) ≡ suc (matra-p P)
anuvrtti-matra P = refl

-- the meaning of the anuvṛtti-derived पद, with no reference to how it was
-- written: the same शब्द as §5's, arrived at from the derivational side
anuvrtti-artha : (P : Prakriya) (n : ℕ)
  → artha (phala (anuvrtti P)) n ≡ artha (phala P) n + artha (phala P) n
anuvrtti-artha P n i = funExt⁻ (cong artha (anuvrtti-phala P)) n i

------------------------------------------------------------------------
-- 23.  `laghava` fails the अनुवृत्ति requirement, and `matra-p` meets it.
--
-- The requirement in §6 of the note is stability: the move is licensed by
-- the roots, so a measure that is the right one must not charge for it
-- beyond the single सूत्र it occupies.  `matra-p` does exactly that
-- (`anuvrtti-matra`, definitionally, for every P).  `laghava` does not,
-- and one पद of size two refutes it.
------------------------------------------------------------------------

laghava-anuvrttau-na-sthiram :
  ¬ ((P : Prakriya) → laghava (phala (anuvrtti P)) ≡ suc (laghava (phala P)))
laghava-anuvrttau-na-sthiram h =
  snotz (injSuc (injSuc (h (cara-s ∷ []))))

-- the gap, written out at its smallest.  The same पद: three occurrences
-- counted by the tree, two सूत्रs written by the derivation, and the
-- difference is precisely the shared occurrence अनुवृत्ति does not rewrite.
dvitva : Prakriya
dvitva = anuvrtti (cara-s ∷ [])

dvitva-phala : phala dvitva ≡ yoga cara cara
dvitva-phala = anuvrtti-phala (cara-s ∷ [])

dvitva-matra : matra-p dvitva ≡ 2
dvitva-matra = refl

dvitva-laghava : laghava (yoga cara cara) ≡ 3
dvitva-laghava = refl

------------------------------------------------------------------------
-- What this settles and what it does not.
--
-- Settled: `laghava` is not the object §6 asks for, and the failure is at
-- the first of the three moves rather than at some subtle one.  Settled
-- too: the object is not exotic — मात्रा on प्रक्रियाs meets the अनुवृत्ति
-- requirement outright, and the shift is only from counting a term to
-- counting the sūtras that write it.
--
-- NOT settled, and each is a separate obligation:
--   • प्रत्याहार.  A named abbreviation standing for a list is a further
--     device; `Sutra` has no naming form and cannot express it.
--   • अपवाद.  §12 has `apavada` on पदs, not on प्रक्रियाs, and the
--     interaction of an exception with a back-reference is untouched.
--   • Instability under everything ELSE.  §6 asks for a measure that is
--     free on these three and pays on the rest.  Only the freeness is
--     shown here.  In particular nothing above establishes that
--     `matra-p` still separates न्यास from स्थूल: that would need a lower
--     bound on the length of every प्रक्रिया producing yoga cara (mita 0),
--     and Sutra's ℕ arguments make that not a finite check.
--
-- So this is one coordinate of the object, and the note's §6 stays open
-- with its remaining two named.
------------------------------------------------------------------------
