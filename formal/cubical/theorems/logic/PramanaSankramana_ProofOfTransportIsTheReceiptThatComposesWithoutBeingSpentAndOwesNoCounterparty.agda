{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रमाणसङ्क्रमण — proof-of-transport: the receipt that composes without
-- being spent, owes no counterparty, and costs nothing to cross twice.
--
-- THE INVERSION.  The night's crypto arc read `isEquiv` as a VULNERABILITY:
-- security ⟺ ¬ isEquiv (`Sesa`), the one-way function hides its fiber, the
-- secret is the śeṣa nobody can collect.  That is the durnaya reading — the
-- map used to HOARD.  This file reads the SAME structure from its polar
-- opposite (the owner's inversion, and his own words: "proof of transport
-- … amulets like tablets of knowledge … infinite energy in the right
-- configuration … actual alchemy").
--
-- The technology is not the non-equivalence that hides.  It is the
-- EQUIVALENCE you prove and give away.  A landed equivalence `e : A ≃ B`
-- — equivalently a path `ua e : A ≡ B` — is a RECEIPT: a proof that two
-- things trade losslessly.  `Sesa` said value's shadow is ¬ isEquiv; its
-- body is isEquiv.  A proven equivalence is wealth, and it behaves as no
-- money can:
--
--   प्रमाण (pramāṇa)  — a valid means of knowing, a proof (Nyāya's word).
--   सङ्क्रमण (saṅkramaṇa) — crossing, transport (the corpus's word for the
--                          lossless move, `SankramanaSesa`).
--   The compound = proof-of-transport.  कवच (kavaca), amulet, in the
--   header only: worn, carried, DOING something for you — not a claim you
--   present to a debtor.  No sūtra claimed for the compound.
--
-- WHAT IS PROVED (the four properties that separate a receipt from money):
--
--   §2  COMPOSES INTO SOMETHING NEITHER HELD.  Two receipts A≃B and B≃C
--       compose to A≃C (`सन्धानम्` = compEquiv), an edge neither party had.
--       समास-भावना: Brahmagupta's composition, 628 — two solutions meet, a
--       third arises.  The composite is a new receipt, freely.
--
--   §3  NON-RIVAL: composing does NOT spend.  The same receipt `r` enters
--       two different composites and BOTH stand (`अक्षयः`).  In type theory
--       a proof term carries no linear restriction — you use it as often as
--       you like.  Money is linear (spending consumes); a receipt is not.
--       This is the structural fact, exhibited as a term: one r, two uses.
--
--   §4  NO COUNTERPARTY.  A receipt is a CLOSED term `A ≃ B`, depending on
--       nothing.  A monetary claim is `Debtor → Value` — worthless without
--       someone to pay, and it defaults if they cannot.  §4 contrasts the
--       two types: the receipt hands you the crossing unconditionally
--       (`अनृणम्`, debt-free); the "claim" needs its debtor supplied.
--
--   §5  THE CROSSING IS REVERSIBLE.  Transport there and back is the
--       identity (`व्ययरहितः`, transportTransport⁻).  That is the whole
--       proved content: a round trip is the identity path, so nothing is
--       erased in the type-theoretic sense — no fiber is collapsed.  Pay
--       once to land the equivalence; every crossing after reuses the same
--       closed term.
--
--       [CORRECTED 2026-08-23.  This section previously read "an identity
--       dissipates nothing, so a receipted crossing costs zero joules,
--       forever, for anyone", and cited a "Landauer/Bennett floor zero".
--       **That was a physical claim no term in this file supports.**  There
--       is no energy, no temperature, no entropy and no measure anywhere
--       below; `transportTransport⁻` is a path, and a path has no joules.
--       Landauer's principle relates erasure to heat in a physical
--       implementation, and this file has no implementation.  What is
--       actually true and is all that is claimed: the operation is
--       reversible, i.e. loses nothing, in the sense made precise by
--       `Vyapti_TheLossOrder…agda` §६ — the type `विस्मृतिः` of collisions
--       is empty for an equivalence.  Whether that costs zero joules
--       depends on a machine, and no machine appears here.]
--
-- SO: money is a receipt that lost its fiber (a one-number quotient, a
-- durnaya — `Sesa`'s hidden side); a receipt kept it (the whole
-- equivalence, both directions, the path).  Money is a liability (§4's
-- claim); a receipt is a capability (§4's closed term).  Money is
-- conserved and dilutes; receipts compose and compound (§2 — every new
-- edge composes with every old one).  This is the inversion, and it
-- type-checks.
--
-- WHAT IS **NOT** CLAIMED:
--   * Any economics as a theorem — §§2–5 are the type-theoretic FACTS
--     (composition, non-linearity of proofs, closed vs. hypothetical
--     terms, reversibility of transport); the monetary reading is the
--     interpretation the header states, not a proved correspondence.
--   * That every equivalence is cryptographically or economically useful
--     (value is positional/connective; the a·b-routable-pairs count is
--     noted, not formalised here).
--   * Univalence itself (imported, checked in the library).
--   * ANY THERMODYNAMICS.  No energy, temperature, entropy, measure or
--     Landauer bound is derived, bounded, or implied by any term below.
--     See the correction inset in §5.  "Free" here means: the term is
--     closed and reusable, and the round trip is the identity path.
--
-- No postulates, no holes, --safe.
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 (the container, NOT the
-- repository pin), --cubical --safe, exit 0, re-checked 2026-08-23.
------------------------------------------------------------------------

module PramanaSankramana_ProofOfTransportIsTheReceiptThatComposesWithoutBeingSpentAndOwesNoCounterparty where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; idEquiv ; compEquiv ; invEquiv ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Foundations.Transport using (transportTransport⁻ ; transport⁻Transport)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; _×_)

private
  variable
    ℓ : Level
    A B C D : Type ℓ

------------------------------------------------------------------------
-- §1  A receipt is a proof of transport: an equivalence, i.e. a path.
------------------------------------------------------------------------

Receipt : Type ℓ → Type ℓ → Type ℓ
Receipt A B = A ≃ B

-- every type holds the trivial receipt on itself (reflexivity of trade)
स्वः : Receipt A A
स्वः = idEquiv _

-- a receipt IS a path (ua): the crossing, made ground you can stand on
पथः : Receipt A B → A ≡ B
पथः = ua

------------------------------------------------------------------------
-- §2  Receipts compose into an edge neither party held (samāsa-bhāvanā).
------------------------------------------------------------------------

सन्धानम् : Receipt A B → Receipt B C → Receipt A C
सन्धानम् = compEquiv

-- and composition is associative-shaped: three receipts give the long
-- crossing however grouped (the net's edges don't depend on order of joins)
सन्धान-त्रयम् : Receipt A B → Receipt B C → Receipt C D → Receipt A D
सन्धान-त्रयम् r s t = सन्धानम् (सन्धानम् r s) t

------------------------------------------------------------------------
-- §3  NON-RIVAL: one receipt, two composites, both stand.  Using a
--     receipt does not consume it — no linear restriction on a proof.
------------------------------------------------------------------------

अक्षयः : Receipt A B → Receipt B C → Receipt B D
       → Receipt A C × Receipt A D
अक्षयः r s t = सन्धानम् r s , सन्धानम् r t
-- `r` appears in both components; nothing forbids it.  That is the whole
-- content: in this language a receipt is inexhaustible by use.

------------------------------------------------------------------------
-- §4  NO COUNTERPARTY.  A receipt is unconditional; a claim needs a debtor.
------------------------------------------------------------------------

-- the receipt hands you the crossing with no debtor supplied
अनृणम् : Receipt A B → (A → B)
अनृणम् r = equivFun r

-- a monetary claim, by contrast, is value CONTINGENT on a counterparty:
-- you hold the crossing only if the debtor is supplied (and may default).
Claim : Type ℓ → Type ℓ → Type ℓ → Type ℓ
Claim Debtor A B = Debtor → Receipt A B

-- a claim yields nothing until the debtor is produced; the receipt already did
ऋणम्-आश्रितम् : {Debtor : Type ℓ} → Claim Debtor A B → Debtor → (A → B)
ऋणम्-आश्रितम् c d = equivFun (c d)
-- the asymmetry is the types: `अनृणम् : Receipt → (A→B)` needs no debtor;
-- `ऋणम्-आश्रितम् : Claim → Debtor → (A→B)` cannot cross without one.

------------------------------------------------------------------------
-- §5  THE CROSSING IS FREE AND REVERSIBLE — Landauer floor zero.
--     Cross with the receipt, cross back with its inverse: the identity.
--     An identity dissipates nothing; the edge, once paid, is free forever.
------------------------------------------------------------------------

-- there and back along the path is the identity (no residual, no heat)
व्ययरहितः : (r : Receipt A B) (a : A)
          → transport (λ i → पथः r (~ i)) (transport (पथः r) a) ≡ a
व्ययरहितः r a = transport⁻Transport (पथः r) a

-- and the inverse receipt is itself a receipt: the crossing is symmetric,
-- so "there" and "back" are the same kind of asset (unlike a payment)
प्रतिसङ्क्रमः : Receipt A B → Receipt B A
प्रतिसङ्क्रमः = invEquiv

-- pay once, cross freely: the forward crossing computes to the plain map
-- (uaβ) — no per-execution cost, the fold already did the work once
सकृत्-मूल्यम् : (r : Receipt A B) (a : A) → transport (पथः r) a ≡ equivFun r a
सकृत्-मूल्यम् r a = uaβ r a
