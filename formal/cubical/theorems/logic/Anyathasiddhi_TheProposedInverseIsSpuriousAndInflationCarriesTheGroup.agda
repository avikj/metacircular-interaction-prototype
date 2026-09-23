{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡Ø‡‡æ‡‡ø‡¶‡‡ß‡ø‡ ‚î the proposed antecedent is spurious, and the cause is
-- another.
--
-- THE TERM, ITS TEXT AND ITS DATE.  `‡‡®‡‡Ø‡‡æ‡‡ø‡¶‡‡ß` (anyathsiddha,
-- "established otherwise") is the Nyya-Vaieika technical term for a
-- factor that stands next to an effect, is proposed as its ‡ï‡æ‡∞‡, and is
-- excluded ‚î because what it contributes is already accounted for
-- elsewhere.  The doctrine is stated with its fivefold classification
-- (‡‡û‡‡‡µ‡ø‡ß-‡‡®‡‡Ø‡‡æ‡‡ø‡¶‡‡ß‡ø) in Annabhaa, *Tarkasagraha* with his own
-- *Dpik*, c. 1600 CE, on the ‡ï‡æ‡∞‡ section; the notion is Navya-Nyya and
-- is worked in Gagea, *Tattvacintmai*, c. 1325 CE, whose ‡ï‡æ‡∞‡‡‡æ‡µ‡æ‡¶ is
-- where the exclusion tests are argued.
--
-- AND THE SCHOOL IS NAMED BEFORE THE TERM IS USED, per CLAUDE.md: this is
-- Nyya vocabulary, not Jaina.  A Jaina logician would not describe the
-- situation this way at all ‚î for anekntavda the two candidate readings
-- of "the map back" would be two nayas to be indexed and held together,
-- and `Fiberjala_‚¶agda` is where this corpus does that.  Nyya's move here
-- is the opposite one and it is the right one HERE, because the question
-- has a determinate answer: one of the two maps is the inverse and the
-- other provably is not.
--
------------------------------------------------------------------------
-- WHAT THIS MODULE IS.
--
-- `interactive/AnulomaPratiloma_‚¶hs` proposes candidate inverse pairs by
-- matching type signatures inside one module and puts the round trip to
-- the kernel.  On `InflationVersusSubgroup` it proposed
--
--     infl : H2 ‚í H4      ‚      res : H4 ‚í H2
--
-- and the kernel denied it.  This module says what the denial is worth,
-- in three parts.
--
--   ‡ß  THE PAIR IS REFUTED, AND THE HOST ALREADY PROVED WHY.  `res` is
--      identically `k0` (`res-is-zero`, InflationVersusSubgroup ¬ß4), so
--      `res ‚àò infl` collapses both classes.  ¬ß‡ß below is one line and it
--      cites the host's own theorem.  Restriction to N ‚â ‚/4 of a class
--      inflated from the quotient is zero: that is the mathematics, and it
--      is the whole point of the module that defined the two maps.
--
--   ‡®  THE EDGE IS NEVERTHELESS REAL.  `infl` IS an equivalence ‚î its
--      inverse is `res‚∫`, defined here, which is not `res` and is not
--      restriction along anything.  So the refuted pair licenses no verdict
--      on the types: H2 ‚â H4 holds.  A machine that reported "not an
--      equivalence" from a failed round trip would have reported a falsehood
--      about the objects while reporting a truth about the pair, and those
--      are two different claims.
--
--   ‡©  THE EDGE CARRIES A GROUP.  H4 = H¬(‚/4, ‚/2) has no operation in
--      the host module.  ¬ß‡© gives it one, as the transport of the pointwise
--      sum on H2 = H¬(‚/2, ‚/2), together with its associativity, in one
--      `subst` and with no case split on H4 ‚î the `Setubandha_‚¶agda`
--      pattern.  ¬ß‡ then checks that the transported operation is the
--      pointwise sum of realizations, which is what makes the sentence
--      "inflation is a group isomorphism" true here rather than asserted.
------------------------------------------------------------------------

module Anyathasiddhi_TheProposedInverseIsSpuriousAndInflationCarriesTheGroup where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; equivFun ; invEq)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; transportUAop‚ÇÇ)
open import Cubical.Foundations.Transport using (substSubst‚Åª)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; Œ£PathP)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import InflationVersusSubgroup
  using ( Z4 ; z0 ; z1 ; z2 ; z3 ; Z2 ; e0 ; e1 ; _+2_
        ; proj ; incl
        ; H4 ; h0 ; hœá ; H2 ; k0 ; kŒπ
        ; real4 ; real2 ; infl ; res ; res-is-zero
        ; k0‚â¢kŒπ ; h0‚â¢hœá ; infl-is-inflation )

------------------------------------------------------------------------
-- ‡ß ¬ THE PROPOSAL IS REFUTED, BY THE HOST'S OWN THEOREM.
--
--     The machine asked for `res (infl c) ‚â° c` for every c.  Taking
--     c = kŒ, `res-is-zero` gives k0, and the host proves k0 ‚â kŒ.
--
--     Note what is refuted: the PAIR.  Nothing here says anything about
--     whether H2 and H4 are equivalent, and ¬ß‡® shows they are.
------------------------------------------------------------------------

res-is-not-a-retraction : ¬¨ ((c : H2) ‚Üí res (infl c) ‚â° c)
res-is-not-a-retraction œÅ = k0‚â¢kŒπ (sym (res-is-zero (infl kŒπ)) ‚àô œÅ kŒπ)

-- The same failure read on the other side, so the refutation is not
-- an artefact of which composite was chosen: `infl ‚àò res` is constant.
res-is-not-a-section : ¬¨ ((h : H4) ‚Üí infl (res h) ‚â° h)
res-is-not-a-section œÉ = h0‚â¢hœá (sym (cong infl (res-is-zero hœá)) ‚àô œÉ hœá)

------------------------------------------------------------------------
-- ‡® ¬ THE REAL INVERSE, AND THE EDGE.
--
--     `res‚∫` is not restriction.  It is the inverse of inflation, which on
--     this model exists because H¬(N,V) ‚í H¬(G,V) is not the map in play:
--     inflation goes from the QUOTIENT's cohomology, and here the quotient
--     Œì = G/N and the subgroup N happen to be abstractly isomorphic, which
--     is exactly the coincidence that made the machine's signature match
--     fire.  The signature match was right about the arrows and wrong about
--     the maps.
------------------------------------------------------------------------

res‚Å∫ : H4 ‚Üí H2
res‚Å∫ h0 = k0
res‚Å∫ hœá = kŒπ

infl-iso : Iso H2 H4
Iso.fun      infl-iso = infl
Iso.inv      infl-iso = res‚Å∫
Iso.rightInv infl-iso h0 = refl
Iso.rightInv infl-iso hœá = refl
Iso.leftInv  infl-iso k0 = refl
Iso.leftInv  infl-iso kŒπ = refl

H2‚âÉH4 : H2 ‚âÉ H4
H2‚âÉH4 = isoToEquiv infl-iso

H2‚â°H4 : H2 ‚â° H4
H2‚â°H4 = ua H2‚âÉH4

-- `res‚∫` really is another map: it disagrees with `res` at hœ, and that
-- single disequality is the whole of ¬ß‡ß restated as a separation of the
-- two candidate backward maps.
res‚Å∫‚â¢res : ¬¨ (res‚Å∫ hœá ‚â° res hœá)
res‚Å∫‚â¢res p = k0‚â¢kŒπ (sym (p ‚àô res-is-zero hœá))

------------------------------------------------------------------------
-- ‡© ¬ WHAT CROSSES.  H¬(Œì,V) is a group under pointwise addition of
--     homomorphisms; two elements, so the table is two lines.  H4 has no
--     operation in the host module and acquires one here by transport,
--     with its associativity, in one `subst` ‚î no case split on H4 occurs
--     anywhere below.
------------------------------------------------------------------------

_+H_ : H2 ‚Üí H2 ‚Üí H2
k0 +H y  = y
kŒπ +H k0 = kŒπ
kŒπ +H kŒπ = k0

+H-assoc : (a b c : H2) ‚Üí (a +H b) +H c ‚â° a +H (b +H c)
+H-assoc k0 b  c  = refl
+H-assoc kŒπ k0 c  = refl
+H-assoc kŒπ kŒπ k0 = refl
+H-assoc kŒπ kŒπ kŒπ = refl

-- (carrier , operation) as ONE object; the law rides on the pair.
Magma : Type‚ÇÅ
Magma = Œ£[ A ‚àà Type‚ÇÄ ] (A ‚Üí A ‚Üí A)

Assoc : Magma ‚Üí Type‚ÇÄ
Assoc (A , op) = (a b c : A) ‚Üí op (op a b) c ‚â° op a (op b c)

_+H4_ : H4 ‚Üí H4 ‚Üí H4
_+H4_ = subst (Œª A ‚Üí A ‚Üí A ‚Üí A) H2‚â°H4 _+H_

‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : Path Magma (H2 , _+H_) (H4 , _+H4_)
‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É = Œ£PathP (H2‚â°H4 , toPathP refl)

+H4-assoc : Assoc (H4 , _+H4_)
+H4-assoc = subst Assoc ‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É +H-assoc

------------------------------------------------------------------------
-- ‡ ¬ THE TRANSPORTED OPERATION IS THE RIGHT ONE.
--
--     ¬ß‡© produces an associative operation on H4 by fiat of transport;
--     that alone would be a checkmark and not a causeway.  This is the
--     content: the transported sum realizes as the pointwise sum of the
--     corresponding characters ‚/4 ‚í ‚/2.  With ¬ß‡® that is the statement
--     that inflation is an isomorphism OF GROUPS
--
--         H¬(G/N, V)  ‚â  H¬(G, V)
--
--     on this model, and the only case split performed is on H2 (two
--     cases in `+H4-realizes`, via `res‚∫`), never on H4's structure.
------------------------------------------------------------------------

-- The transported operation, unfolded once: `transportUAop‚` is the
-- library's statement that a binary operation moved along `ua` is the
-- conjugate of the original.
+H4-unfold : (x y : H4) ‚Üí x +H4 y ‚â° infl (res‚Å∫ x +H res‚Å∫ y)
+H4-unfold = transportUAop‚ÇÇ H2‚âÉH4 _+H_

-- Realization is a homomorphism from (H2 , +H) to pointwise sums, by four
-- lines on H2.  This is the only computation in the file.
real2-+H : (a b : H2) (x : Z2) ‚Üí real2 (a +H b) x ‚â° real2 a x +2 real2 b x
real2-+H k0 b  x = refl
real2-+H kŒπ k0 e0 = refl
real2-+H kŒπ k0 e1 = refl
real2-+H kŒπ kŒπ e0 = refl
real2-+H kŒπ kŒπ e1 = refl

+H4-realizes : (x y : H4) (g : Z4)
             ‚Üí real4 (x +H4 y) g ‚â° real4 x g +2 real4 y g
+H4-realizes x y g =
    cong (Œª z ‚Üí real4 z g) (+H4-unfold x y)
  ‚àô infl-is-inflation (res‚Å∫ x +H res‚Å∫ y) g
  ‚àô real2-+H (res‚Å∫ x) (res‚Å∫ y) (proj g)
  ‚àô cong‚ÇÇ _+2_ (sym (infl-is-inflation (res‚Å∫ x) g))
               (sym (infl-is-inflation (res‚Å∫ y) g))
  ‚àô cong‚ÇÇ (Œª u v ‚Üí real4 u g +2 real4 v g)
          (Iso.rightInv infl-iso x) (Iso.rightInv infl-iso y)

------------------------------------------------------------------------
-- ‡ ¬ THE SCOPE, EXACTLY, stated so nothing is read into it.
--
--   * That inflation is an isomorphism in general.  It is not.  The
--     inflation‚ìrestriction sequence is exact at H¬ with cokernel governed
--     by H¬(N,V)^Œì, and on this model that term vanishes because `res` is
--     zero ‚î which is why the isomorphism holds HERE.  Nothing above
--     generalises and the host module's ¬ß3 says the same.
--   * That `res` is the wrong map to have defined.  It is the right map;
--     it is the only canonical map attached to a subgroup, and the host
--     module exists to say so.  What is refuted is the machine's proposal
--     that it inverts `infl`.
--   * That the Nyya doctrine of ‡‡®‡‡Ø‡‡æ‡‡ø‡¶‡‡ß‡ø has any formal counterpart
--     below.  The term names the move; the checks are cubical type theory.
------------------------------------------------------------------------
