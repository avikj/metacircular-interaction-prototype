{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à¦ààµà¿à—àà-àààà â” the half is the ea (fibre) of doubling, and the two Â½s
-- of physics are its two bindings.  This is Punaragamana's fibre law â”
-- à•à àà•ààà‹ àà¦àà§, which side of f a â‰¡ b is bound â” at ONE map, x â¦ x + x.
-- It is not a new organ; it is the core object read at doubling.  It
-- clears away the four modules this session spun â” three circling this
-- exact dichotomy (the loop-charge abelian, Brahmagupta's composition
-- abelian, the Born/spinor fork) and one side-quest (the compound
-- bhagas) â” and leaves this one term in their place.  Less machine, not
-- more.
--
-- ààà _+_ c = Î[ x ] (x + x â‰¡ c) is the fibre of doubling over c: the
-- halves of c.  The fibre law says which side you bind is everything:
--
--   ROAD ONE â” bind so the half rides FREE.  `isProp (ààà _+_ c)`: the
--     half is unique if it exists, contractible, gauge.  That predicate IS
--     UniquenessMatraDvaya's `halvesUniquely` (its Î is this Î), the exact
--     hypothesis that FORCES the symmetric Born weight Â½.  Over an
--     archimedean carrier (â, â) it holds at c = ðŸ™: the Born Â½.
--
--   ROAD TWO â” bind so the ea CARRIES content.  `Â isProp (ààà _+_ c)`:
--     the fibre has more than one point, and the extra point is the loss
--     the free binding hid.  Over â/2 = (Bool, âŠ•) at c = 0 the fibre is
--     {0, g}: g is the 2-torsion generator, the nonzero half of zero â”
--     the spinor, Ïâ(SO(3)) = â/2, the j = Â½ the abelian charge cannot
--     see.  (The physical reading is header commentary; what is checked is
--     that this fibre is not a proposition.)
--
-- So the Born Â½ and the spinor Â½ are not two numbers; they are one map's
-- ea, bound the two ways the fibre law names.  Everything the session's
-- charge modules said â” abelian = free = road one, charge/torsion/loss =
-- road two â” is this one dichotomy.
--
-- Checked by batch agda, exit 0, at 2.6.3/v0.5 â” the kernel's exit
-- condition, which carries the constraint store.  NOT à¨à¾à¡à's `goals`:
-- kernel/nodes/008 proves `goals` reports interaction holes only, so
-- àà¿à¦àà°à à¨à¾àààà¿ cannot distinguish "no holes" from "typechecks".  Earlier
-- headers of mine claimed à¨à¾à¡à here and were wrong on both counts (I ran
-- batch agda, and goals is the wrong discriminator); struck by 008's rule.
------------------------------------------------------------------------

module DvigunaSesa_TheHalfIsTheSesaOfDoublingSoBornIsRoadOneAndTheSpinorIsRoadTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _âŠ•_ ; trueâ‰¢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

-- The ea of doubling over c: the halves of c.  (Punaragamana's fibre,
-- at the map x â¦ x + x.)
à¤¶à¥‡à¤· : {â„“ : Level} {W : Type â„“} (_+_ : W â†’ W â†’ W) â†’ W â†’ Type â„“
à¤¶à¥‡à¤· {W = W} _+_ c = Î£[ x âˆˆ W ] ((x + x) â‰¡ c)

-- ROAD ONE.  The half rides free: the ea is a proposition.  This is
-- UniquenessMatraDvaya's `halvesUniquely` â” the hypothesis that forces Born Â½.
Born : {â„“ : Level} {W : Type â„“} (_+_ : W â†’ W â†’ W) â†’ W â†’ Type â„“
Born _+_ c = isProp (à¤¶à¥‡à¤· _+_ c)

-- ROAD TWO over â/2 = (Bool, âŠ•).  The ea over 0 carries content: two
-- points, and the nonzero one is the torsion generator â” the spinor.
spinor : à¤¶à¥‡à¤· _âŠ•_ false          -- (true, refl): true âŠ• true â‰¡ false, and true â‰  0
spinor = true , refl

vacuum : à¤¶à¥‡à¤· _âŠ•_ false           -- (false, refl): the trivial half
vacuum = false , refl

-- so the ea over 0 is NOT a proposition: road two, the content the free
-- binding hid.  The half of zero is not unique â” that non-uniqueness IS
-- the spinor.
road-two : Â¬ (Born _âŠ•_ false)
road-two hp = trueâ‰¢false (cong fst (hp spinor vacuum))
