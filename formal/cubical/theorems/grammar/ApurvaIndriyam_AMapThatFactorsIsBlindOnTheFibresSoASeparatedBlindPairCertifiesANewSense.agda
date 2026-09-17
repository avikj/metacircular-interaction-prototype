{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡∞‡‡µ-‡‡®‡‡¶‡‡∞‡ø‡Ø‡Æ‡ ‚î ‡Ø‡‡ ‡‡‡∞‡µ‡‡‡ø ‡‡‡ ‡‡®‡‡‡ ‡‡®‡‡ß‡Æ‡ ; ‡‡‡ ‡‡ø‡®‡‡®‡ ‡Ø‡‡ó‡‡Æ‡ ‡‡‡∞‡Æ‡æ‡‡Æ‡ ‡
--
-- (a map that FACTORS is blind on the fibres of what it factors through;
-- so a blind pair it separates is the certificate that it is a new sense.)
--
-- ‡‡‡‡‡∞ ‡ ‡‡‡‡∞, ‡‡‡®‡ : ‡ï‡ ‡‡ï‡‡‡ã ‡‡¶‡‡ß ‡‡‡ø ‡  ‡‡‡∞‡µ‡‡‡ (factoring) ‡‡ß‡‡®‡æ‡‡ø
-- **O**-‡‡ï‡‡‡Æ‡ ; ‡‡‡‡Ø ‡‡®‡‡‡µ‡ ‡‡®‡‡ß‡æ‡ ‡  ‡‡‡¶‡ ‡‡®‡‡‡ = ‡® ‡‡‡∞‡µ‡‡‡Æ‡ ‡
--
-- WHAT THIS IS.  The owner's sensorium reading gives the criterion for when
-- a proposed organ is a SENSE rather than a DASHBOARD:
--
--     q : X ‚í Q is genuinely new only when it separates something inside a
--     fibre of the present sensorium S : X ‚í O ‚î  S x ‚â° S y  but  q x ‚â q y.
--     If instead q = h ‚àò S, it is another reading computed from the same
--     transcript; useful compression, but it perceives nothing new.
--
-- That is a theorem, not a policy, and it is two rewrites.  Written as a term
-- so the rule "no new sense without a blind pair it demonstrably separates"
-- can be DISCHARGED rather than asserted.
--
-- AND IT IS THE SAME LAW AS `SamacaranaNityam`.  That module proves a
-- transitive symmetry flattens every invariant observable, and reads an
-- unequal split as the certificate that no transitive symmetry acts.  ¬ß‡ below
-- exhibits flattening as factoring THROUGH A POINT, so both certificates are
-- one statement seen at two codomains:
--
--     factoring through S      ‚í blind on S's fibres ‚í dashboard
--     factoring through Unit   ‚í blind everywhere    ‚í flattened
--
-- The organ criterion and the index criterion were never two criteria.
--
------------------------------------------------------------------------

module ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•)

private
  variable
    ‚Ñì ‚Ñì' ‚Ñì'' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡∞‡µ‡‡‡Æ‡ ‚î what it is for one reading to be computed from another
--
-- No propositional truncation: the factoring map is DATA.  An organ that
-- claims to be derived must hand over the h that derives it, which is the
-- honest form of the claim and is what makes ¬ß‡© usable as an admission gate.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø : {X : Type ‚Ñì} {O : Type ‚Ñì'} {Q : Type ‚Ñì''}
        ‚Üí (X ‚Üí O) ‚Üí (X ‚Üí Q) ‚Üí Type (‚Ñì-max (‚Ñì-max ‚Ñì ‚Ñì') ‚Ñì'')
‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø {X = X} S q = Œ£[ h ‚àà (_ ‚Üí _) ] ((x : X) ‚Üí q x ‚â° h (S x))

------------------------------------------------------------------------
-- ‡® ¬ ‡‡®‡‡‡-‡‡®‡‡ß‡‡‡µ‡Æ‡ ‚î a derived reading is blind inside its source's fibres
--
-- The whole content, and it is `cong` twice.  This is the repository's
-- quotient/fibre law at the level of instruments: no post-processing of the
-- present observation manufactures what that observation discarded.
------------------------------------------------------------------------

‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É : {X : Type ‚Ñì} {O : Type ‚Ñì'} {Q : Type ‚Ñì''}
              (S : X ‚Üí O) (q : X ‚Üí Q)
            ‚Üí ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø S q
            ‚Üí (x y : X) ‚Üí S x ‚â° S y ‚Üí q x ‚â° q y
‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É S q (h , fac) x y p = fac x ‚àô cong h p ‚àô sym (fac y)

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡‡∞‡‡µ-‡‡‡∞‡Æ‡æ‡‡Æ‡ ‚î THE ADMISSION CERTIFICATE
--
-- A blind pair of the present sensorium, separated by the proposal, proves
-- no derivation exists.  This is what an organ must carry to be admitted as a
-- sense: not an argument that it is new, a WITNESS that it is.
--
-- Note what it does NOT need: no decidability, no finiteness, no h-level
-- hypothesis on X, O or Q, and no enumeration of candidate h.  One blind pair
-- refutes every possible derivation at once.
------------------------------------------------------------------------

‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç : {X : Type ‚Ñì} {O : Type ‚Ñì'} {Q : Type ‚Ñì''}
           (S : X ‚Üí O) (q : X ‚Üí Q) (x y : X)
         ‚Üí S x ‚â° S y            -- the pair the present sensorium cannot split
         ‚Üí (q x ‚â° q y ‚Üí ‚ä•)      -- the proposal splits it
         ‚Üí ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø S q ‚Üí ‚ä•      -- hence it is no reading of the present one
‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç S q x y blind sep fac = sep (‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É S q fac x y blind)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡ï‡à‡µ ‡µ‡ø‡ß‡ø‡ ‚î flattening IS factoring through a point
--
-- `SamacaranaNityam` proves: a symmetry carrying every index to every other
-- makes an invariant observable constant.  Constant is exactly "factors
-- through Unit" ‚î every index is one orbit, so the orbit space is a point and
-- the observable is a reading OF THAT POINT.
--
-- So the two certificates this corpus now holds are one law at two codomains,
-- and each is the contrapositive of the same two rewrites:
--
--   blind pair separated   ‚ü no factoring through S      (a real sense)
--   unequal split          ‚ü no factoring through Unit   (a real index)
------------------------------------------------------------------------

-- Factoring through a point is constancy.  The point of X is a HYPOTHESIS,
-- not an oversight: `h : Unit ‚í Q` must produce a Q, and with X empty there is
-- no q x to produce it from.  A constant map on the empty type factors through
-- Unit only if Q is inhabited, and saying so costs one argument.
‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§™‡•ç‡§∞‡§µ‡§π‡§£‡§Æ‡•ç : {X : Type ‚Ñì} {Q : Type ‚Ñì'} (q : X ‚Üí Q) (x‚ÇÄ : X)
               ‚Üí ((x y : X) ‚Üí q x ‚â° q y)
               ‚Üí ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø (Œª (_ : X) ‚Üí tt) q
‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§™‡•ç‡§∞‡§µ‡§π‡§£‡§Æ‡•ç q x‚ÇÄ const = (Œª _ ‚Üí q x‚ÇÄ) , (Œª x ‚Üí const x x‚ÇÄ)

-- ‡î‡∞ the direction the certificate actually uses, which needs no point at
-- all: anything factoring through a point is constant.  This is ¬ß‡® at O = Unit,
-- so `SamacaranaNityam`'s flattening and ¬ß‡©'s dashboard are the same rewrite.
‡§¨‡§ø‡§®‡•ç‡§¶‡•ã‡§É-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç : {X : Type ‚Ñì} {Q : Type ‚Ñì'} (q : X ‚Üí Q)
               ‚Üí ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø (Œª (_ : X) ‚Üí tt) q
               ‚Üí (x y : X) ‚Üí q x ‚â° q y
‡§¨‡§ø‡§®‡•ç‡§¶‡•ã‡§É-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç q fac x y = ‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É _ q fac x y refl

------------------------------------------------------------------------
-- ‡ ¬ ‡Æ‡∞‡‡Ø‡æ‡¶‡æ ‚î stated at the site
--
-- * ¬ß‡ splits into an asymmetric pair and the asymmetry is real, not a
--   defect.  `‡‡ø‡®‡‡¶‡ã‡-‡®‡ø‡‡‡Ø‡Æ‡` (factors through a point ‚ü constant) needs
--   NOTHING ‚î it is ¬ß‡® at O = Unit, where every fibre is the whole type, so
--   the blindness is total.  `‡‡ø‡®‡‡¶‡-‡‡‡∞‡µ‡‡‡Æ‡` (constant ‚ü factors through a
--   point) needs a point of X, because `h : Unit ‚í Q` must produce a Q and an
--   empty X supplies no q x to produce it from.  The certificate direction is
--   the free one; the representation direction is the one that costs an
--   argument.  This was written into the ‡Æ‡∞‡‡Ø‡æ‡¶‡æ before the kernel was asked,
--   and the first attempt came back from the kernel owing exactly this point.
-- * `‡‡‡∞‡µ‡‡‡ø` is DATA, not a truncated existence.  An organ that cannot hand
--   over its h has not shown it is derived, and ¬ß‡© refutes derivability
--   outright rather than refuting a particular h.
-- * No organ is admitted or built here.  This is the certificate's type.
--   The rule the owner states ‚î no new sense without a blind pair it
--   demonstrably separates ‚î becomes: an organ ships an `‡‡‡‡∞‡‡µ‡Æ‡` term or it
--   ships as a dashboard, and both are honest.
------------------------------------------------------------------------
