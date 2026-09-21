{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà•-ààà•àà°à®à â” eka-sakramaa, "the unique transport."  ààà•àà°à®à is this
-- corpus's word for transport (subst / translation of a datum along a
-- path â” DravyaParyaya_â¦, Âààà•àà°à®àà®à p P = subst P pÂ»); àà• = one.  The
-- COMPOUND is this corpus's, declared here: there is
-- no classical  term for a torsor, and none is invented for the
-- structure â” only for its defining property, that the element carrying
-- one point to another is exactly one.
--
-- WHAT IT PROVES, and why it is here.  runtime/atlas/residual.py's
-- Torsor checks a group action FREE and TRANSITIVE by exhaustion, and
-- Torsor.translate(p, q) returns Âthe unique g with gÂp = qÂ» â” RAISING
-- if the number of such g is not exactly one.  That raise is a
-- per-instance regularity guard.  This module proves it can never fire:
--
--   Â§1  àà•-ààà•àà°à®à (regular): in a FREE + TRANSITIVE action, for all
--       p, q the g with act g p â‰¡ q is UNIQUE.  Transitivity gives
--       existence, freeness gives uniqueness; general in P, no h-level.
--   Â§2  the fibre reading (the seam's point): the orbit map
--       g â¦ act g p has a CONTRACTIBLE fibre over every q â” so a torsor
--       IS an equivalence Carrier â‰ P (with P a set).  translate is the
--       inverse; its "exactly one" is contractibility of the fibre
--       (àà¦ààààŸà àà¨àààà àà•à®à â” the fibre is a singleton), not a runtime
--       check.  free + transitive âŸº the orbit map's fibres are singletons.
--
-- So residual.py's exhaustive regularity check is provably redundant
-- given the free + transitive it already checks â” the general form of
-- Torsor.translate's uniqueness, for EVERY (group, action).
--
-- Sources for the mathematics: runtime/atlas/residual.py (Torsor,
-- FiniteGroup).
------------------------------------------------------------------------

module EkaSankramana_AFreeTransitiveActionsTranslationIsUniqueSoTheTorsorIsAnEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv; equiv-proof; fiber)
open import Cubical.Data.Sigma

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- a group, by its full law set.
------------------------------------------------------------------------

record Group (â„“ : Level) : Type (â„“-suc â„“) where
  field
    Carrier : Type â„“
    e       : Carrier
    _Â·_     : Carrier â†’ Carrier â†’ Carrier
    inv     : Carrier â†’ Carrier
    idl     : (g : Carrier) â†’ e Â· g â‰¡ g
    idr     : (g : Carrier) â†’ g Â· e â‰¡ g
    assoc   : (a b c : Carrier) â†’ (a Â· b) Â· c â‰¡ a Â· (b Â· c)
    invl    : (g : Carrier) â†’ inv g Â· g â‰¡ e
    invr    : (g : Carrier) â†’ g Â· inv g â‰¡ e

------------------------------------------------------------------------
-- an action of a group on a set of points.
------------------------------------------------------------------------

module _ (Grp : Group â„“) (P : Type â„“') where
  open Group Grp

  record Action : Type (â„“-max â„“ â„“') where
    field
      act   : Carrier â†’ P â†’ P
      act-e : (p : P) â†’ act e p â‰¡ p
      act-Â· : (a b : Carrier) (p : P) â†’ act (a Â· b) p â‰¡ act a (act b p)

  Free : Action â†’ Type (â„“-max â„“ â„“')
  Free A = (g : Carrier) (p : P) â†’ Action.act A g p â‰¡ p â†’ g â‰¡ e

  Transitive : Action â†’ Type (â„“-max â„“ â„“')
  Transitive A = (p q : P) â†’ Î£[ g âˆˆ Carrier ] Action.act A g p â‰¡ q

  ----------------------------------------------------------------------
  -- Â§1  àà•-ààà•àà°à®à â” the translating element is unique.
  ----------------------------------------------------------------------

  regular : (A : Action) â†’ Free A
          â†’ (p q : P) (g h : Carrier)
          â†’ Action.act A g p â‰¡ q â†’ Action.act A h p â‰¡ q â†’ g â‰¡ h
  regular A fr p q g h gp hq = uniq
    where
    open Action A
    -- inv h Â g fixes p, so it is the identity.
    fixes : act (inv h Â· g) p â‰¡ p
    fixes =
      act (inv h Â· g) p        â‰¡âŸ¨ act-Â· (inv h) g p âŸ©
      act (inv h) (act g p)    â‰¡âŸ¨ cong (act (inv h)) (gp âˆ™ sym hq) âŸ©
      act (inv h) (act h p)    â‰¡âŸ¨ sym (act-Â· (inv h) h p) âŸ©
      act (inv h Â· h) p        â‰¡âŸ¨ cong (Î» z â†’ act z p) (invl h) âŸ©
      act e p                  â‰¡âŸ¨ act-e p âŸ©
      p âˆŽ
    ihgâ‰¡e : inv h Â· g â‰¡ e
    ihgâ‰¡e = fr (inv h Â· g) p fixes
    uniq : g â‰¡ h
    uniq =
      g                  â‰¡âŸ¨ sym (idl g) âŸ©
      e Â· g              â‰¡âŸ¨ cong (_Â· g) (sym (invr h)) âŸ©
      (h Â· inv h) Â· g    â‰¡âŸ¨ assoc h (inv h) g âŸ©
      h Â· (inv h Â· g)    â‰¡âŸ¨ cong (h Â·_) ihgâ‰¡e âŸ©
      h Â· e              â‰¡âŸ¨ idr h âŸ©
      h âˆŽ

  ----------------------------------------------------------------------
  -- Â§2  the torsor IS an equivalence: the orbit map's fibres are singletons.
  ----------------------------------------------------------------------

  torsorIsEquiv : isSet P â†’ (A : Action) â†’ Free A â†’ Transitive A
                â†’ (p : P) â†’ isEquiv (Î» g â†’ Action.act A g p)
  torsorIsEquiv setP A fr tr p .equiv-proof q = ctr , contraction
    where
    open Action A
    ctr : fiber (Î» g â†’ act g p) q
    ctr = tr p q
    contraction : (y : fiber (Î» g â†’ act g p) q) â†’ ctr â‰¡ y
    contraction (g , gp) =
      Î£â‰¡Prop (Î» g' â†’ setP (act g' p) q)
             (regular A fr p q (fst ctr) g (snd ctr) gp)
