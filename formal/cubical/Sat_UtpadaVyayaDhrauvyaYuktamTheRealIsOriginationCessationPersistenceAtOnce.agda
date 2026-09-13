{-# OPTIONS --cubical --safe --no-import-sorts #-}
-- सत् — utpāda-vyaya-dhrauvya-yuktaṁ sat (Umāsvāti, Tattvārthasūtra 5.29–30):
-- the real is endowed with origination, cessation, and persistence — SAHA, at
-- once, not in sequence (AHIMSA §26: न क्रमेण, सह). A substance persists
-- (dhrauvya) while its modes arise (utpāda) and pass (vyaya). Pure persistence
-- (śāśvata) and pure flux (uccheda) are the two one-sided durnayas; a real
-- transition refutes both — it carries persistence AND change together.
module Sat_UtpadaVyayaDhrauvyaYuktamTheRealIsOriginationCessationPersistenceAtOnce where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)

-- a being: a persistent substance carrying a current mode
record सत् (द्रव्य पर्याय : Type) : Type where
  constructor धरति
  field
    आधारः : द्रव्य     -- dravya: the persistent substance
    वृत्तिः : पर्याय    -- paryāya: its current mode
open सत् public

-- a transition (pariṇāma): substance persists, mode really changes — both at once.
-- utpādaḥ = वृत्तिः उत्तरम् (the new mode), vyayaḥ = वृत्तिः पूर्वम् (the old, gone).
record परिणामः {D P : Type} (पूर्वम् उत्तरम् : सत् D P) : Type where
  field
    ध्रौव्यम् : आधारः पूर्वम् ≡ आधारः उत्तरम्         -- dhrauvya: substance unchanged
    परिवर्तः : ¬ (वृत्तिः पूर्वम् ≡ वृत्तिः उत्तरम्)   -- utpāda/vyaya: mode changes
open परिणामः public

-- neither one-sided view holds of a real transition:
न-उच्छेदः : {D P : Type} {a b : सत् D P} → परिणामः a b → आधारः a ≡ आधारः b
न-उच्छेदः p = ध्रौव्यम् p          -- not annihilation: the substance IS carried across

न-शाश्वतः : {D P : Type} {a b : सत् D P} → परिणामः a b → ¬ (वृत्तिः a ≡ वृत्तिः b)
न-शाश्वतः p = परिवर्तः p           -- not eternalism: the mode does change
