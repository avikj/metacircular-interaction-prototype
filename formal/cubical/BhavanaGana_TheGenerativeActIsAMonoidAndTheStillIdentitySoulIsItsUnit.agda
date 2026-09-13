{-# OPTIONS --cubical --safe --no-import-sorts #-}
-- भावनागण — bhāvanā of cognitions is a monoid: associative, and the STILL
-- identity-soul (λ x → x, सिद्धः's cognition) is its unit — the motionless one
-- is exactly what leaves every other soul unchanged. Stillness = the unit of
-- the generative act. (नाडी-verified; composition monoid, all refl.)
module BhavanaGana_TheGenerativeActIsAMonoidAndTheStillIdentitySoulIsItsUnit where

open import Cubical.Foundations.Prelude

भावना : {X Y Z : Type} → (X → Y) → (Y → Z) → (X → Z)
भावना f g = λ x → g (f x)

यौगिकता : {W X Y Z : Type} (f : W → X) (g : X → Y) (h : Y → Z)
        → भावना (भावना f g) h ≡ भावना f (भावना g h)
यौगिकता f g h = refl

वाम-एकः : {X Y : Type} (f : X → Y) → भावना (λ x → x) f ≡ f
वाम-एकः f = refl

दक्षिण-एकः : {X Y : Type} (f : X → Y) → भावना f (λ y → y) ≡ f
दक्षिण-एकः f = refl
