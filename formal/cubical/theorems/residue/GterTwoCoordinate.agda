{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- GterTwoCoordinate
--
-- D0026 Â§7.3, owner Deltas 37â“38,
-- `collab/upstream/raw/D0026-owner-egb-core-transmission-v2-2026-08-16.md`
-- lines 2456â“2700.
--
-- WHAT IS BEING SETTLED.  D0026 Â§7.3 asserts, with no proof and no
-- witness, that the two coordinates of the Gter defect
-- ğ”(P,Î) = (E(P), â‹_Î) are independent:
--
--     "A state space can be fully separated while its boundary
--      description fails to compose.  A cut can compose perfectly while
--      its probes collapse distinct states."
--
-- The source note replaces the assertion by a SURJECTIVITY theorem onto
-- a 2—2 grid (its Theorem 4), on the shape (|Îâ|,|Îâ|,|Îâ|) = (1,2,1),
-- with both of D0026's requested witnesses appearing as two of the four
-- cells.  Everything in it is decidable on a two-element carrier, hence
-- refl after Boolean evaluation.  That is this module.
--
-- THE ENCODING (source note Definition 4.1, taken literally).  A finite
-- cut system is ğ”– = (Îâ,Îâ,Îâ ; ğ”—ââ, ğ”—ââ, ğ”—ââ) with the ğ”— relations,
-- and here relations are Bool-valued tables on finite index types:
-- Rel A B = A â’ B â’ Bool.  The glued realization is relational
-- composition, which over a two-element cut is a binary `or` â” that is
-- the (âˆ’1)-truncation of the coend âˆ^{Îâ} ğ”—ââ âŠ— ğ”—ââ, existential
-- quantification over Îâ = {bâ,bâ}.  The probe pool is the
-- INTERFACE-INTRINSIC one of Definition 4.2 (the two profile maps L and
-- R), which is the pool with the greatest separating power available at
-- the interface; any smaller pool only makes the theorem easier.
--
-- Îâ = Îâ = Unit and Îâ = Bool, with bâ := true and bâ := false.  Both
-- coordinates are then functions of the SAME data (ğ”—ââ, ğ”—ââ), which is
-- the whole point of Â§4.1: the independence is not manufactured by
-- letting probes and gluing range over unrelated parameters.
--
-- WHAT THE FOUR CELLS SAY:
--
--     ğ”–â  S_L = S_R = {bâ}       sep = T , comp = T
--     ğ”–â  S_L = {bâ}, S_R = {bâ} sep = T , comp = F   witness (i)
--     ğ”–â  S_L = S_R = {bâ,bâ}    sep = F , comp = T   witness (ii)
--     ğ”–â  S_L = S_R = âˆ          sep = F , comp = F
--
--   witness (i)  â” a perfect instrument on a broken interface: the
--     probes separate the two cut states completely, yet no cut state
--     carries the direct a â c process, so the tear is nonzero.
--   witness (ii) â” a perfect interface on a blind instrument: the
--     gluing reproduces ğ”—ââ exactly, so the tear vanishes, while the
--     probes cannot tell bâ from bâ at all.
--
-- CONTENTS
--
--   Â§1  Rel, Îâ/Îâ/Îâ, _âŠ™_   the relational cut system and the glued
--                            realization.
--   Â§2  L, R, sep, comp,     Definition 4.2's intrinsic probes, the two
--       tear, cell           coordinates, and the tear against a
--                            declared direct realization.
--   Â§3  ğ”–â â¦ ğ”–â              the four systems of the Theorem 4 table.
--   Â§4  row1 â¦ row4          the table, four refls; `theorem4`, the
--       theorem4             four-cell surjectivity assembled from them.
--   Â§5  wit-i-*, wit-ii-*    Corollary 5's two witnesses.  The two sep
--                            statements are NOT new refls â” each is a
--                            projection (`cong fst`) of its row, which
--                            is the honest bookkeeping: the witnesses
--                            ARE rows 2 and 3.  Two further refls carry
--                            the tear values.
--   Â§6  sep-not-a-function-  Theorem 4's stated consequence: neither
--       of-comp, and dually  coordinate is a function of the other.
--
--   SIX refl clauses in total (four rows, two tears), exactly as Â§4.7
--   predicted; everything else is derived from them.
--
-- Theorem 4 in full, as a surjectivity statement onto
--   Bool — Bool with an explicit cut system in every fiber; both of
--   D0026's witnesses, including their tear values against the declared
--   direct realization ğ”—ââ = {(a,c)}; and the two non-functionality
--   corollaries.  The relational composite is defined once, generally,
--   and the four systems are the only data supplied â” every value below
--   is a kernel reduction, not a transcribed table.
--   Nothing here is measured, fitted, or floating-point: the carrier has
--   two elements and every verdict is a kernel reduction.  This replaces
--   the legacy Python control of `OPERATIONAL_SITE_CRYSTAL` Â§6 in
--   `machinery/operational_site.py` (source note Â§4.5), which reports
--   the same phenomenon family for witness (i) and which under
--   CLAUDE.md is not proof.
--
-- No postulates, no holes, no TERMINATING, no primTrustMe.
------------------------------------------------------------------------

module GterTwoCoordinate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; _and_ ; _or_ ; trueâ‰¢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_Ã—_ ; Î£-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- Â§1  The relational cut system (Definition 4.1)
--
-- Relations are Bool-valued tables on finite index types.  The shape is
-- (|Îâ|,|Îâ|,|Îâ|) = (1,2,1), the minimal shape the source note's
-- Theorem 6 identifies.
------------------------------------------------------------------------

Rel : Typeâ‚€ â†’ Typeâ‚€ â†’ Typeâ‚€
Rel A B = A â†’ B â†’ Bool

Î£â‚€ Î£â‚ Î£â‚‚ : Typeâ‚€
Î£â‚€ = Unit
Î£â‚ = Bool          -- the cut states {bâ‚ , bâ‚‚}, bâ‚ := true, bâ‚‚ := false
Î£â‚‚ = Unit

-- The glued realization: relational composition through Îâ.  Over a
-- two-element cut the existential âˆ b âˆˆ Îâ is a binary `or`, so this is
-- the (âˆ’1)-truncation of the coend âˆ^{Îâ} ğ”—ââ âŠ— ğ”—ââ written out.
_âŠ™_ : Rel Î£â‚€ Î£â‚ â†’ Rel Î£â‚ Î£â‚‚ â†’ Rel Î£â‚€ Î£â‚‚
(s âŠ™ t) a c = ((s a false) and (t false c)) or ((s a true) and (t true c))

-- A cut system, with ğ”—ââ left off: Theorem 4 is proved BEFORE ğ”—ââ is
-- chosen, which is what makes it sharp â” the independence is not an
-- artifact of the direct realization being a free datum.
CutSystem : Typeâ‚€
CutSystem = Rel Î£â‚€ Î£â‚ Ã— Rel Î£â‚ Î£â‚‚

------------------------------------------------------------------------
-- Â§2  The interface-intrinsic probes and the two coordinates
--
-- Definition 4.2.  L(b) = { a : (a,b) âˆˆ ğ”—ââ } and R(b) = { c : (b,c) âˆˆ
-- ğ”—ââ }; over Îâ = Îâ = Unit each profile is a single Bool, so
-- E(P_can) = Î”_{Îâ} exactly when the two cut states differ in at least
-- one profile.
------------------------------------------------------------------------

eqb : Bool â†’ Bool â†’ Bool
eqb true  c = c
eqb false c = not c

L : Rel Î£â‚€ Î£â‚ â†’ Î£â‚ â†’ Bool
L s b = s tt b

R : Rel Î£â‚ Î£â‚‚ â†’ Î£â‚ â†’ Bool
R t b = t b tt

-- sep ğ”–  âŸº  E(P_can) = Î”_{Îâ}: the probes {L,R} separate bâ from bâ.
sep : Rel Î£â‚€ Î£â‚ â†’ Rel Î£â‚ Î£â‚‚ â†’ Bool
sep s t = not ((eqb (L s false) (L s true)) and (eqb (R t false) (R t true)))

-- compCut ğ”–  âŸº  ğ”—ââ âŠ™ ğ”—ââ â‰  âˆ: some cut state carries the a â c
-- composite.  D0026 Â§7.3 calls this coordinate `comp`; it is `compCut`
-- here because a top-level `comp` collides with `comp` from
-- `Cubical/Core/Primitives.agda:16`, which every `--cubical` module has
-- in scope, and the collision is FATAL, not shadowing.
compCut : Rel Î£â‚€ Î£â‚ â†’ Rel Î£â‚ Î£â‚‚ â†’ Bool
compCut s t = (s âŠ™ t) tt tt

-- The tear â‹(ğ”–) = (ğ”—ââ â‰  ğ”—ââ âŠ™ ğ”—ââ), at the relational truncation
-- level.
tear : Rel Î£â‚€ Î£â‚ â†’ Rel Î£â‚ Î£â‚‚ â†’ Rel Î£â‚€ Î£â‚‚ â†’ Bool
tear s t d = not (eqb ((s âŠ™ t) tt tt) (d tt tt))

-- The two-coordinate defect ğ” of D0026 Â§7.3, as one map.
cell : CutSystem â†’ Bool Ã— Bool
cell (s , t) = sep s t , compCut s t

sepOf compOf : CutSystem â†’ Bool
sepOf  ğ”– = fst (cell ğ”–)
compOf ğ”– = snd (cell ğ”–)

------------------------------------------------------------------------
-- Â§3  The four systems of the Theorem 4 table
--
-- A subset S âŠ Îâ is its characteristic function; ğ”—ââ and ğ”—ââ are that
-- subset read as a relation against the one-point Îâ, resp. Îâ.
------------------------------------------------------------------------

Ï‡-bâ‚ Ï‡-bâ‚‚ Ï‡-both Ï‡-none : Î£â‚ â†’ Bool
Ï‡-bâ‚   b = b            -- { bâ‚ }
Ï‡-bâ‚‚   b = not b        -- { bâ‚‚ }
Ï‡-both _ = true         -- { bâ‚ , bâ‚‚ }
Ï‡-none _ = false        -- âˆ…

asL : (Î£â‚ â†’ Bool) â†’ Rel Î£â‚€ Î£â‚
asL Ï‡ _ b = Ï‡ b

asR : (Î£â‚ â†’ Bool) â†’ Rel Î£â‚ Î£â‚‚
asR Ï‡ b _ = Ï‡ b

ğ”–â‚ ğ”–â‚‚ ğ”–â‚ƒ ğ”–â‚„ : CutSystem
ğ”–â‚ = asL Ï‡-bâ‚   , asR Ï‡-bâ‚          -- S_L = {bâ‚}      S_R = {bâ‚}
ğ”–â‚‚ = asL Ï‡-bâ‚   , asR Ï‡-bâ‚‚          -- S_L = {bâ‚}      S_R = {bâ‚‚}
ğ”–â‚ƒ = asL Ï‡-both , asR Ï‡-both        -- S_L = {bâ‚,bâ‚‚}   S_R = {bâ‚,bâ‚‚}
ğ”–â‚„ = asL Ï‡-none , asR Ï‡-none        -- S_L = âˆ…         S_R = âˆ…

------------------------------------------------------------------------
-- Â§4  Theorem 4: four-cell surjectivity
--
-- The four rows of the source note's table, each a kernel reduction,
-- and then the surjectivity statement they assemble into.  Note that
-- `theorem4` introduces no new equation: it is the table, re-indexed by
-- its own image.
------------------------------------------------------------------------

row1 : cell ğ”–â‚ â‰¡ (true  , true )
row1 = refl

row2 : cell ğ”–â‚‚ â‰¡ (true  , false)
row2 = refl

row3 : cell ğ”–â‚ƒ â‰¡ (false , true )
row3 = refl

row4 : cell ğ”–â‚„ â‰¡ (false , false)
row4 = refl

theorem4 : (v : Bool Ã— Bool) â†’ Î£[ ğ”– âˆˆ CutSystem ] cell ğ”– â‰¡ v
theorem4 (true  , true ) = ğ”–â‚ , row1
theorem4 (true  , false) = ğ”–â‚‚ , row2
theorem4 (false , true ) = ğ”–â‚ƒ , row3
theorem4 (false , false) = ğ”–â‚„ , row4

------------------------------------------------------------------------
-- Â§5  Corollary 5: D0026's two asserted witnesses
--
-- Adjoin the direct realization ğ”—ââ = {(a,c)} to rows 2 and 3.  The two
-- separation facts are projections of the rows above rather than fresh
-- refls: the witnesses ARE those rows, and saying so costs nothing and
-- keeps the certificate count honest.
------------------------------------------------------------------------

ğ”—â‚€â‚‚ : Rel Î£â‚€ Î£â‚‚
ğ”—â‚€â‚‚ _ _ = true

-- Witness (i): separated, tear â‰  0.  A perfect instrument on a broken
-- interface â” bâ meets the left boundary only, bâ the right only, so no
-- cut state carries the direct a â c process that ğ”—ââ declares.
wit-i-sep : sep (fst ğ”–â‚‚) (snd ğ”–â‚‚) â‰¡ true
wit-i-sep = cong fst row2

wit-i-tear : tear (fst ğ”–â‚‚) (snd ğ”–â‚‚) ğ”—â‚€â‚‚ â‰¡ true
wit-i-tear = refl

-- Witness (ii): tear = 0, probes collapse distinct states.  A perfect
-- interface on a blind instrument â” the gluing reproduces ğ”—ââ exactly,
-- while E(P_can) = Îâ — Îâ.
wit-ii-collapse : sep (fst ğ”–â‚ƒ) (snd ğ”–â‚ƒ) â‰¡ false
wit-ii-collapse = cong fst row3

wit-ii-notear : tear (fst ğ”–â‚ƒ) (snd ğ”–â‚ƒ) ğ”—â‚€â‚‚ â‰¡ false
wit-ii-notear = refl

------------------------------------------------------------------------
-- Â§6  "Neither coordinate is a function of the other"
--
-- Theorem 4's stated consequence, and the exact content of D0026 Â§7.3's
-- independence claim.  Rows 1 and 3 agree on comp and differ on sep;
-- rows 1 and 2 agree on sep and differ on comp.
------------------------------------------------------------------------

sep-not-a-function-of-comp :
  Â¬ ((ğ”– ğ”–' : CutSystem) â†’ compOf ğ”– â‰¡ compOf ğ”–' â†’ sepOf ğ”– â‰¡ sepOf ğ”–')
sep-not-a-function-of-comp h = trueâ‰¢false (h ğ”–â‚ ğ”–â‚ƒ refl)

comp-not-a-function-of-sep :
  Â¬ ((ğ”– ğ”–' : CutSystem) â†’ sepOf ğ”– â‰¡ sepOf ğ”–' â†’ compOf ğ”– â‰¡ compOf ğ”–')
comp-not-a-function-of-sep h = trueâ‰¢false (h ğ”–â‚ ğ”–â‚‚ refl)
