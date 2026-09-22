{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- आयाम-अर्पण — offering by dimension.  StaraArpana proved the circle's
-- charge is withheld at stratum 2 and offered whole at stratum 3
-- (Ω(∥S 3)  ).  THE DIMENSIONAL QUESTION:
-- does the withholding deepen by
-- one stratum per dimension?
--
-- ANSWERED for the absent half, checked below: for S², EVERYTHING
-- through stratum 3 is silent — not merely the loop space: the whole
-- 3-truncation ∥S²∥ 3 is CONTRACTIBLE (sphereConnected 2), hence so is
-- its loop space (चक्रद्वय-त्रि-स्तरे-मौनम्).  Where S¹'s stratum 3
-- carried all of ℤ, S²'s stratum 3 carries nothing at all.
--
-- THE OFFERED HALF, Ω²(∥S²∥ 4) ≃ π₂(S²) ≃ ℤ, is proved in AnantaraArpana.
--
-- THE LAW: dimension grades the withholding —
-- the n-sphere's charge is anarpita through stratum n+1 and arpita at
-- n+2 (n=1 in StaraArpana; n=2 here on the silent side and in
-- AnantaraArpana on the offered side).
-- अर्पितानर्पितसिद्धेः (TS 5.31) as the reading; the grading is this
-- repository's statement.
------------------------------------------------------------------------

module AyamaArpana_TheSphereWithholdsOneStratumDeeperPerDimension where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isContr→isContrPath)
open import Cubical.HITs.Sn using (S₊ ; ptSn)
open import Cubical.HITs.Truncation using (∥_∥_ ; ∣_∣ₕ)
open import Cubical.Homotopy.Connected using (isConnected)
open import Cubical.HITs.Sn.Properties using (sphereConnected)

-- the whole 3-stratum of the 2-sphere is one point.
चक्रद्वय-त्रि-स्तरे-शून्यम् : isContr (∥ S₊ 2 ∥ 3)
चक्रद्वय-त्रि-स्तरे-शून्यम् = sphereConnected 2

-- hence its loop space is silent: no charge survives at stratum 3.
चक्रद्वय-त्रि-स्तरे-मौनम् :
  isContr (Path (∥ S₊ 2 ∥ 3) ∣ ptSn 2 ∣ₕ ∣ ptSn 2 ∣ₕ)
चक्रद्वय-त्रि-स्तरे-मौनम् =
  isContr→isContrPath चक्रद्वय-त्रि-स्तरे-शून्यम् _ _
