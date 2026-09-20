{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- LaghavaUnderdeterminesSoTheMetarulesAreNotOptional
--
-- `Laghava.laghava-is-not-semantic` proves the kernel of `eval` is not
-- empty, and stops there.  It never asks what the fibre looks like.  That
-- is Pini's question rather than a footnote to it: the Adhyy's
-- method is to choose among presentations of one meaning, and the
-- commentarial tradition celebrates the saving of half a mora â” a
-- difference *inside* a fibre â” like the birth of a son.
--
-- Two facts about the fibre.
--
--   * à²à¾à˜àµ ATTAINS its minimum.  For the meaning `n â¦ n + 1` the minimum
--     is 3, and `three-is-minimal` proves it: an expression of size 1 is
--     `var` or `lit k`, and neither denotes this meaning, while `plus`
--     and `times` are â‰ 3 by construction.
--
--   * **It does not attain it uniquely.**  `plus var (lit 1)` and
--     `plus (lit 1) var` are distinct presentations, both of size 3, with
--     EQUAL denotation â” equal, not merely equivalent, because addition
--     on â• commutes.
--
-- So brevity does not pick a presentation.  It picks a LEVEL SET, and
-- something else must choose inside it.  That is why the Adhyy
-- carries àà°à¿àà¾àà¾ â” metarules â” and an explicit conflict rule
-- (àµà¿ààà°àà¿ààà§à àà°à à•à¾à°àà¯à®à, "of two rules in conflict the later applies"):
-- not as ornament on a brevity criterion but because brevity alone is
-- underdetermined, and without a tie-break the grammar is not a function.
-- The metarules are structurally required, and the tradition supplies
-- them.
--
-- The tie does not go away by sharpening the measure.  Pini counts
-- morae and rule-slots, not nodes; but commutativity of `+` is a fact
-- about the MEANING, so it is invisible to `eval` and survives into every
-- presentation-measure whatsoever.  Any measure blind to a symmetry of
-- the denotation attains its minima non-uniquely, by that fact alone.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the pin.
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module LaghavaUnderdeterminesSoTheMetarulesAreNotOptional where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; +-comm ; znots ; injSuc)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; â‰¤-refl ; zero-â‰¤ ; suc-â‰¤-suc ; â‰¤-+-â‰¤)
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import Laghava
  using (Expr ; var ; lit ; plus ; times ; size ; eval)

------------------------------------------------------------------------
-- 1.  One meaning, two shortest presentations of it
------------------------------------------------------------------------

target : â„• â†’ â„•
target n = n + 1

left right : Expr
left  = plus var (lit 1)
right = plus (lit 1) var

left-means : eval left â‰¡ target
left-means = refl

right-means : eval right â‰¡ target
right-means i n = +-comm 1 n i

sizes-agree : size left â‰¡ size right
sizes-agree = refl

private
  firstIsVar : Expr â†’ Bool
  firstIsVar (plus var _) = true
  firstIsVar _            = false

leftâ‰¢right : Â¬ (left â‰¡ right)
leftâ‰¢right p = trueâ‰¢false (cong firstIsVar p)

------------------------------------------------------------------------
-- 2.  Three is the minimum
------------------------------------------------------------------------

sizeâ‰¥1 : (e : Expr) â†’ 1 â‰¤ size e
sizeâ‰¥1 var        = â‰¤-refl
sizeâ‰¥1 (lit _)    = â‰¤-refl
sizeâ‰¥1 (plus _ _) = suc-â‰¤-suc zero-â‰¤
sizeâ‰¥1 (times _ _) = suc-â‰¤-suc zero-â‰¤

private
  varFails : Â¬ (eval var â‰¡ target)
  varFails p = znots (cong (Î» f â†’ f 0) p)

  litFails : (k : â„•) â†’ Â¬ (eval (lit k) â‰¡ target)
  litFails k p = znots (injSuc (sym (cong (Î» f â†’ f 0) p) âˆ™ cong (Î» f â†’ f 1) p))

three-is-minimal : (e : Expr) â†’ eval e â‰¡ target â†’ 3 â‰¤ size e
three-is-minimal var         p = âŠ¥.rec (varFails p)
three-is-minimal (lit k)     p = âŠ¥.rec (litFails k p)
three-is-minimal (plus a b)  _ = suc-â‰¤-suc (â‰¤-+-â‰¤ (sizeâ‰¥1 a) (sizeâ‰¥1 b))
three-is-minimal (times a b) _ = suc-â‰¤-suc (â‰¤-+-â‰¤ (sizeâ‰¥1 a) (sizeâ‰¥1 b))

------------------------------------------------------------------------
-- 3.  So the minimum is attained twice, and brevity does not choose
------------------------------------------------------------------------

laghava-underdetermines :
  Î£[ p âˆˆ Expr ] Î£[ q âˆˆ Expr ]
    ( (eval p â‰¡ target) Ã— (eval q â‰¡ target)
    Ã— (size p â‰¡ size q)
    Ã— (Â¬ (p â‰¡ q)) )
laghava-underdetermines =
  left , right , left-means , right-means , sizes-agree , leftâ‰¢right
