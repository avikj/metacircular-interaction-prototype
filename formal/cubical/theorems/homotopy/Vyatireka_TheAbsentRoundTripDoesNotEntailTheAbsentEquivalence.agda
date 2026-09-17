{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡‡Ø‡‡ø‡∞‡‡ï‡ ‚î the negative concomitance, and the inference that is not
-- licensed by it.
--
-- THE TERM, ITS TEXT AND ITS DATE.  ‡µ‡‡Ø‡‡ø‡∞‡‡ï is the negative half of the
-- Nyya pervasion (‡µ‡‡Ø‡æ‡‡‡‡ø): ‡‡®‡‡µ‡Ø is "wherever the ‡‡‡‡, there the
-- ‡‡æ‡ß‡‡Ø", ‡µ‡‡Ø‡‡ø‡∞‡‡ï is its contrapositive, "wherever the ‡‡æ‡ß‡‡Ø is absent,
-- the ‡‡‡‡ is absent".  The ‡‡‡‡ and the members of the inference are set
-- out in Gautama, *Nyyastra* 1.1.5 and 1.1.32‚ì39 (the five-membered
-- ‡®‡‡Ø‡æ‡Ø‡µ‡æ‡ï‡‡Ø), c. 2nd c. CE; the ‡‡®‡‡µ‡Ø/‡µ‡‡Ø‡‡ø‡∞‡‡ï pair as the two supports
-- of ‡µ‡‡Ø‡æ‡‡‡‡ø is worked in Vtsyyana's *Nyyabhya*, c. 450 CE, and the
-- ‡ï‡‡µ‡≤‡æ‡®‡‡µ‡Ø‡ø‡®‡ / ‡ï‡‡µ‡≤‡µ‡‡Ø‡‡ø‡∞‡‡ï‡ø‡®‡ / ‡‡®‡‡µ‡Ø‡µ‡‡Ø‡‡ø‡∞‡‡ï‡ø‡®‡ classification of
-- ‡‡‡‡s is standard by Annabhaa, *Tarkasagraha*, c. 1600 CE.
--
------------------------------------------------------------------------
-- WHAT THIS MODULE IS.
--
-- `interactive/AnulomaPratiloma_‚¶hs` proposed 39 candidate inverse pairs and
-- reported 0 accepted at every rung of its ladder, concluding that "every
-- causeway costs a real proof".  Two things are wrong with the conclusion
-- and this module fixes the second; the first is recorded here because
-- it is the larger error and belongs next to it.
--
--   THE FIRST.  Sixteen of the 39 pairs name types the HOST MODULE HAS
--   ALREADY IDENTIFIED, by hand, in the same file the proposer read ‚î
--   `SaptabhangiNaya.saptabhangi-equiv`, `Digits.‚ï‚âCanWord`,
--   `FreeMonoid.‚ï‚âTally`, `TermFreeMonoid.Tm‚âList`, all four of
--   `PMTorus`, both of `S3IntegerRelativeCoordinates`,
--   `CenterRelative.Pair‚âCR`, `AchromaticToy.L‚‚`,
--   `ProjectionChargeAudit.localChargeEquiv`,
--   `WallCertificate.quotient‚âBool`.  The proposer read every top-level
--   arrow in the corpus and never read a top-level `_‚â_`.  "No cheap
--   harvest" was a measurement of the instrument.
--
--   THE SECOND, and it is what is proved below.  A refuted round trip
--   refutes THE PAIR.  It says nothing about the types.  Three verdicts
--   live under the machine's single "not accepted", and
--   `Tantujala_‚¶agda` already gives this repository the shape of that
--   complaint: a two-valued verdict on three positions identifies two of
--   them.  Here the three are
--
--     (‡)  the pair fails and the types ARE equivalent, by another map.
--          `Anyathasiddhi_‚¶agda` is the worked case: `res` does not invert
--          `infl`, and `infl` is nevertheless an equivalence.  ¬ß‡© below
--          adds a second: `Digits.value` is not injective on `Word`, and
--          the same file proves `‚ï ‚â CanWord`.
--     (‡)  the pair fails and the types are SEPARATED.  ¬ß‡ß‚ì‡®: `Syllable`
--          and `‚ï`; `Z2` and `Z4`.  Both are proved, from one lemma.
--     (‡)  the pair fails and nothing is known either way.  ¬ß‡: two pairs
--          left in exactly that state, said so rather than resolved.
--
-- ¬ß‡ then transports a separation along the causeway of
-- `Anyathasiddhi_‚¶agda` ‚î a non-equivalence crosses an equivalence with
-- one `subst` and no new case analysis, which is the point of having the
-- edge at all.
------------------------------------------------------------------------

module Vyatireka_TheAbsentRoundTripDoesNotEntailTheAbsentEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; equivFun ; invEq ; secEq
                                            ; invEquiv ; compEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Bool.Properties using (true‚â¢false)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots ; snotz)
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; length)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Relation.Nullary using (¬¨_)

open import PingalaPrastara using (Syllable ; laghu ; guru ; aksara ; parity)
open import InflationVersusSubgroup
  using (Z2 ; e0 ; e1 ; Z4 ; z0 ; z1 ; z2 ; z3 ; incl ; proj)
open import SieveScaleTower using (O‚ÇÅ ; O‚ÇÇ ; s‚ÇÇ‚ÇÅ ; œÄ‚ÇÇ‚ÇÅ)

-- Base two, so the arithmetic in ¬ß‡© reduces.  `Digits` is parameterized by
-- k with b = 2 + k; nothing below depends on the choice.
open import Digits 0
  using (Word ; Digit ; value ; digits ; CanWord ; ‚Ñï‚âÉCanWord)
open import Cubical.Data.Fin using (fzero)

open import Anyathasiddhi_TheProposedInverseIsSpuriousAndInflationCarriesTheGroup
  using (H2‚â°H4 ; res-is-not-a-retraction)
open import InflationVersusSubgroup using (H2 ; k0 ; kŒπ ; H4)

------------------------------------------------------------------------
-- ‡¶ ¬ THE ONE LEMMA.  Three pairwise-distinct points cannot be injected
--     into `Bool`.  Everything in ¬ß‡ß‚ì‡® is this, twice.
--
--     The Boolean pigeonhole is stated separately so that no `with` is
--     needed against the injectivity hypothesis: `pairOf` is six lines of
--     enumeration and carries no hypotheses at all.
------------------------------------------------------------------------

pairOf : (a b c : Bool) ‚Üí (a ‚â° b) ‚äé ((a ‚â° c) ‚äé (b ‚â° c))
pairOf false false _     = inl refl
pairOf true  true  _     = inl refl
pairOf false true  false = inr (inl refl)
pairOf false true  true  = inr (inr refl)
pairOf true  false false = inr (inr refl)
pairOf true  false true  = inr (inl refl)

noInj3 : {X : Type} (g : X ‚Üí Bool)
       ‚Üí ((p q : X) ‚Üí g p ‚â° g q ‚Üí p ‚â° q)
       ‚Üí (x y z : X) ‚Üí ¬¨ (x ‚â° y) ‚Üí ¬¨ (x ‚â° z) ‚Üí ¬¨ (y ‚â° z) ‚Üí ‚ä•
noInj3 g inj x y z x‚â¢y x‚â¢z y‚â¢z with pairOf (g x) (g y) (g z)
... | inl p       = x‚â¢y (inj x y p)
... | inr (inl p) = x‚â¢z (inj x z p)
... | inr (inr p) = y‚â¢z (inj y z p)

-- The inverse of an equivalence is injective.  One line, no h-levels.
invEq-inj : {A B : Type} (e : A ‚âÉ B) (p q : B) ‚Üí invEq e p ‚â° invEq e q ‚Üí p ‚â° q
invEq-inj e p q r = sym (secEq e p) ‚àô cong (equivFun e) r ‚àô secEq e q

------------------------------------------------------------------------
-- ‡ß ¬ `PingalaPrastara.aksara ‚ parity` ‚î the pair fails AND the types
--     are separated.
--
--     `aksara : Syllable ‚í ‚ï` sends ‡≤‡ò‡ to 0 and ‡ó‡‡∞‡ to 1; `parity : ‚ï ‚í
--     Syllable` reads the last bit.  `parity ‚àò aksara` is the identity ‚î
--     the proposer was right that there is a retraction ‚î and
--     `aksara ‚àò parity` is not, because `aksara (parity 2) = 0`.  Here the
--     ‡µ‡‡Ø‡‡ø‡∞‡‡ï does hold: no equivalence exists at all.
--
--     This is the ‡‡‡∞‡‡‡‡æ‡∞'s own arithmetic and it is the reason ‡â‡¶‡‡¶‡ø‡‡‡ü
--     is a positional sum rather than a lookup: one syllable carries one
--     bit, and ‚ï is not one bit.
------------------------------------------------------------------------

sylBool : Syllable ‚Üí Bool
sylBool laghu = false
sylBool guru  = true

sylBool-inj : (p q : Syllable) ‚Üí sylBool p ‚â° sylBool q ‚Üí p ‚â° q
sylBool-inj laghu laghu _ = refl
sylBool-inj guru  guru  _ = refl
sylBool-inj laghu guru  r = ‚ä•-rec (true‚â¢false (sym r))
sylBool-inj guru  laghu r = ‚ä•-rec (true‚â¢false r)

-- the pair itself
aksara-parity-fails : ¬¨ ((n : ‚Ñï) ‚Üí aksara (parity n) ‚â° n)
aksara-parity-fails h = znots (h 2)

-- and the separation, which does not follow from it and is proved
¬¨Syllable‚âÉ‚Ñï : ¬¨ (Syllable ‚âÉ ‚Ñï)
¬¨Syllable‚âÉ‚Ñï e =
  noInj3 (Œª n ‚Üí sylBool (invEq e n))
         (Œª p q r ‚Üí invEq-inj e p q (sylBool-inj _ _ r))
         0 1 2 znots znots (Œª r ‚Üí znots (cong pred1 r))
  where
    pred1 : ‚Ñï ‚Üí ‚Ñï
    pred1 zero    = zero
    pred1 (suc n) = n

------------------------------------------------------------------------
-- ‡® ¬ `InflationVersusSubgroup.incl ‚ proj` ‚î the pair fails AND the
--     types are separated.
--
--     N = {z0,z2} ‚ ‚/4 is the subgroup and ‚/4 ‚† ‚/2 the quotient; the
--     proposer matched their arrows because the quotient and the subgroup
--     are abstractly the same group, and that coincidence is the whole
--     subject of the host module.  `proj ‚àò incl` is the identity;
--     `incl ‚àò proj` sends z1 to z2.
------------------------------------------------------------------------

z4a : Z4 ‚Üí Bool          -- separates z0 from z1 and z2
z4a z0 = true ; z4a z1 = false ; z4a z2 = false ; z4a z3 = false

z4b : Z4 ‚Üí Bool          -- separates z1 from z2
z4b z0 = false ; z4b z1 = true ; z4b z2 = false ; z4b z3 = false

z2Bool : Z2 ‚Üí Bool
z2Bool e0 = false
z2Bool e1 = true

z2Bool-inj : (p q : Z2) ‚Üí z2Bool p ‚â° z2Bool q ‚Üí p ‚â° q
z2Bool-inj e0 e0 _ = refl
z2Bool-inj e1 e1 _ = refl
z2Bool-inj e0 e1 r = ‚ä•-rec (true‚â¢false (sym r))
z2Bool-inj e1 e0 r = ‚ä•-rec (true‚â¢false r)

incl-proj-fails : ¬¨ ((g : Z4) ‚Üí incl (proj g) ‚â° g)
incl-proj-fails h = true‚â¢false (cong z4b (sym (h z1)))

¬¨Z2‚âÉZ4 : ¬¨ (Z2 ‚âÉ Z4)
¬¨Z2‚âÉZ4 e =
  noInj3 (Œª g ‚Üí z2Bool (invEq e g))
         (Œª p q r ‚Üí invEq-inj e p q (z2Bool-inj _ _ r))
         z0 z1 z2
         (Œª r ‚Üí true‚â¢false (cong z4a r))
         (Œª r ‚Üí true‚â¢false (cong z4a r))
         (Œª r ‚Üí true‚â¢false (cong z4b r))

------------------------------------------------------------------------
-- ‡© ¬ `Digits.digits ‚ value` ‚î the pair fails and the
--     types are NOT separated, and the SAME FILE carries the repair.
--
--     `value` is not injective on raw words: `fzero ‚à []` and `[]` both
--     evaluate to 0, which is the leading-zero ambiguity of positional
--     notation and is why `Digits` defines `Canonical` at all.  The
--     proposer denied the pair and its line in the log reads exactly
--     like those of ¬ß‡ß‚ì‡®.  It is a different verdict: `Digits`
--     proves `‚ï ‚â CanWord` sixty lines further down, and that equivalence
--     is imported here so the two claims stand on the same page.
------------------------------------------------------------------------

digits-value-fails : ¬¨ ((w : Word) ‚Üí digits (value w) ‚â° w)
digits-value-fails h = znots (cong length (h (fzero ‚à∑ [])))

-- the edge that does exist, quoted from the host, not rebuilt
‚Ñï‚â°CanWord : ‚Ñï ‚â° CanWord
‚Ñï‚â°CanWord = ua ‚Ñï‚âÉCanWord

------------------------------------------------------------------------
-- ‡ ¬ `SieveScaleTower.s‚‚ ‚ œ‚‚` ‚î the pair fails and
--     THE TYPES ARE NOT SEPARATED HERE, and I do not know whether they
--     are.  Stated, not resolved.
--
--     O‚ = ‚ï and O‚ = ‚ï ó ‚ï.  `s‚‚ x = (x , 0)` is a section of the
--     projection, so `œ‚‚ ‚àò s‚‚` is the identity and `s‚‚ ‚àò œ‚‚` forgets
--     the second coordinate ‚î refuted below.  Whether ‚ï ‚â ‚ï ó ‚ï holds is
--     a separate question with a well-known affirmative answer by a
--     pairing function; the cubical library shipped with this repository
--     (agda/cubical v0.9) has no such equivalence under `Cubical.Data.Nat`,
--     nothing in this corpus proves one, and I am not asserting one.  The
--     honest verdict on this candidate is (‡).
------------------------------------------------------------------------

s‚ÇÇ‚ÇÅ-œÄ‚ÇÇ‚ÇÅ-fails : ¬¨ ((o : O‚ÇÇ) ‚Üí s‚ÇÇ‚ÇÅ (œÄ‚ÇÇ‚ÇÅ o) ‚â° o)
s‚ÇÇ‚ÇÅ-œÄ‚ÇÇ‚ÇÅ-fails h = znots (cong snd (h (0 , 1)))

------------------------------------------------------------------------
-- ‡ ¬ A SEPARATION CROSSES A CAUSEWAY.
--
--     `Anyathasiddhi_‚¶agda` built H2 ‚â° H4 out of the pair the machine
--     denied.  H2 = H¬(‚/2, ‚/2) is a two-element enumeration and so is
--     Z2; ¬ß‡® separated Z2 from Z4.  Composing, H4 = H¬(‚/4, ‚/2) is not
--     ‚/4 ‚î a non-equivalence obtained by ONE `subst` along a path, with
--     no case analysis on H4 anywhere.  That is what the edge was for.
------------------------------------------------------------------------

Z2‚âÉH2 : Z2 ‚âÉ H2
Z2‚âÉH2 = isoToEquiv (iso f g sec ret)
  where
    f : Z2 ‚Üí H2
    f e0 = k0
    f e1 = kŒπ
    g : H2 ‚Üí Z2
    g k0 = e0
    g kŒπ = e1
    sec : (h : H2) ‚Üí f (g h) ‚â° h
    sec k0 = refl
    sec kŒπ = refl
    ret : (x : Z2) ‚Üí g (f x) ‚â° x
    ret e0 = refl
    ret e1 = refl

Z2‚â°H4 : Z2 ‚â° H4
Z2‚â°H4 = ua Z2‚âÉH2 ‚àô H2‚â°H4

¬¨H4‚âÉZ4 : ¬¨ (H4 ‚âÉ Z4)
¬¨H4‚âÉZ4 = subst (Œª A ‚Üí ¬¨ (A ‚âÉ Z4)) Z2‚â°H4 ¬¨Z2‚âÉZ4

------------------------------------------------------------------------
-- ‡ ¬ THE SCOPE, EXACTLY.
--
--   * That the remaining candidates of the 39 are any particular verdict.
--     Twenty-three pairs are untouched by this file; the sixteen listed in
--     the header are already-proved edges, and the seven examined here are
--     named one by one.  No count is claimed for the rest.
--   * That `noInj3` generalises.  It separates a two-element type from
--     anything with three distinguishable points and nothing more; the
--     four-versus-eight separation the queue also contains
--     (`AdaptiveProbeCollapse`) needs a different argument and is not
--     attempted.
--   * That ‡µ‡‡Ø‡‡ø‡∞‡‡ï as Nyya uses it is the contrapositive of a material
--     implication.  It is a relation between properties in a substrate,
--     argued with ‡â‡‡æ‡ß‡ø and ‡‡∞‡‡ï, and the reduction of it to a truth-table
--     is not being asserted.
------------------------------------------------------------------------
