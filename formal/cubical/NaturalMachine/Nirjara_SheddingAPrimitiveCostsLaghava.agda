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
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; injSuc ; snotz)
open import Cubical.Data.Nat.Properties using (+-zero)
open import Cubical.Foundations.Prelude using (funExt⁻)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (Σ ; _,_ ; _×_)

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
