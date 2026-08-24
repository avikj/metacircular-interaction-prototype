{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module Sphatika where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)
max : ℕ → ℕ → ℕ
max a zero = a
max zero b = b
max (suc a) (suc b) = suc (max a b)
le : ℕ → ℕ → ℕ
le zero b = suc zero
le (suc a) zero = zero
le (suc a) (suc b) = le a b
maxZeroL : (n : ℕ) → max zero n ≡ n
maxZeroL zero = refl
maxZeroL (suc n) = refl
minusZeroL : (n : ℕ) → zero ∸ n ≡ zero
minusZeroL zero = refl
minusZeroL (suc n) = refl
sp001 : (x : ℕ) → x ≡ (max x zero)
sp001 x = refl
sp002 : (x : ℕ) → zero ≡ (le (suc x) zero)
sp002 x = refl
sp003 : (x : ℕ) → (suc zero) ≡ (le zero x)
sp003 x = refl
sp004 : (x : ℕ) → x ≡ (x · (suc zero))
sp004 zero = refl
sp004 (suc x) = (cong (λ y → (suc y)) (sp004 x))
sp005 : (x : ℕ) → (suc x) ≡ ((suc x) ∸ zero)
sp005 x = refl
sp006 : (x : ℕ) → zero ≡ (le (suc (suc x)) zero)
sp006 x = refl
sp007 : (x : ℕ) → (suc x) ≡ (max (suc x) zero)
sp007 x = refl
sp008 : (x : ℕ) → (suc zero) ≡ (le zero (suc x))
sp008 x = refl
sp009 : (x : ℕ) → x ≡ (x + (x · zero))
sp009 zero = refl
sp009 (suc x) = (cong (λ y → (suc y)) (sp009 x))
sp010 : (x : ℕ) → (le (suc zero) (suc x)) ≡ (suc zero)
sp010 x = refl
sp011 : (x : ℕ) → (max (suc x) (suc zero)) ≡ (suc x)
sp011 x = refl
sp012 : (x : ℕ) → (suc x) ≡ ((le zero zero) + x)
sp012 x = refl
sp013 : (x : ℕ) → zero ≡ ((suc zero) ∸ (suc (suc x)))
sp013 x = refl
sp014 : (x y : ℕ) → zero ≡ (x ∸ ((suc x) + y))
sp014 zero y = refl
sp014 (suc x) y = (sp014 x y)
sp015 : (x y : ℕ) → zero ≡ (x ∸ (x + (suc y)))
sp015 zero y = refl
sp015 (suc x) y = (sp015 x y)
sp016 : (x : ℕ) → zero ≡ (le (suc (suc (suc x))) zero)
sp016 x = refl
sp017 : (x y : ℕ) → zero ≡ (le ((suc x) + y) zero)
sp017 x y = refl
sp018 : (x y : ℕ) → zero ≡ (le (x + (suc y)) zero)
sp018 zero y = refl
sp018 (suc x) y = refl
sp019 : (x : ℕ) → zero ≡ (le (suc (suc x)) (suc zero))
sp019 x = refl
sp020 : (x y : ℕ) → zero ≡ (le ((suc x) + y) x)
sp020 zero y = refl
sp020 (suc x) y = (sp020 x y)
sp021 : (x y : ℕ) → zero ≡ (le (suc (x · y)) zero)
sp021 x y = refl
sp022 : (x : ℕ) → (suc zero) ≡ (le zero (suc (suc x)))
sp022 x = refl
sp023 : (x : ℕ) → (le zero (suc x)) ≡ (le zero x)
sp023 x = refl
sp024 : (x : ℕ) → x ≡ (x + ((suc zero) · zero))
sp024 zero = refl
sp024 (suc x) = (cong (λ y → (suc y)) (sp024 x))
sp025 : (x y : ℕ) → (x + y) ≡ ((zero + x) + y)
sp025 x y = refl
sp026 : (x : ℕ) → ((suc (suc zero)) + x) ≡ (suc (suc x))
sp026 x = refl
sp027 : (x y : ℕ) → ((suc x) + y) ≡ (x + (suc y))
sp027 zero y = refl
sp027 (suc x) y = (cong (λ z → (suc z)) (sp027 x y))
sp028 : (x : ℕ) → zero ≡ ((le x zero) · (x + x))
sp028 zero = refl
sp028 (suc x) = refl
sp029 : ((zero + zero) + (zero + zero)) ≡ zero
sp029 = refl
sp030 : (x y : ℕ) → ((x + zero) + y) ≡ (x + y)
sp030 zero y = refl
sp030 (suc x) y = (cong (λ z → (suc z)) (sp030 x y))
sp031 : (x y : ℕ) → zero ≡ (le (x + (suc (suc y))) zero)
sp031 zero y = refl
sp031 (suc x) y = refl
sp032 : (x : ℕ) → zero ≡ (le (suc (suc (suc (suc x)))) zero)
sp032 x = refl
sp033 : (x : ℕ) → (suc zero) ≡ (le (suc zero) (suc (suc x)))
sp033 x = refl
sp034 : (x y : ℕ) → (suc zero) ≡ (le x ((suc x) + y))
sp034 zero y = refl
sp034 (suc x) y = (sp034 x y)
sp035 : (x y : ℕ) → (suc zero) ≡ (le x (x + (suc y)))
sp035 zero y = refl
sp035 (suc x) y = (sp035 x y)
sp036 : (x : ℕ) → (le (x + (suc (suc zero))) zero) ≡ zero
sp036 zero = refl
sp036 (suc x) = refl
sp037 : (le (suc (suc (suc (suc zero)))) zero) ≡ zero
sp037 = refl
sp038 : (x : ℕ) → (le (x · x) zero) ≡ (le x zero)
sp038 zero = refl
sp038 (suc x) = refl
sp039 : (x : ℕ) → (le (suc zero) (suc x)) ≡ (le zero x)
sp039 x = refl
sp040 : (x : ℕ) → (x + (max zero (suc zero))) ≡ (suc x)
sp040 zero = refl
sp040 (suc x) = (cong (λ y → (suc y)) (sp040 x))
sp041 : (x : ℕ) → zero ≡ ((le x zero) · (le (suc zero) x))
sp041 zero = refl
sp041 (suc x) = refl
sp042 : (x : ℕ) → zero ≡ ((le (suc zero) x) · (le x zero))
sp042 zero = refl
sp042 (suc x) = refl
sp043 : (x : ℕ) → (le (suc zero) (suc x)) ≡ (le zero (suc x))
sp043 x = refl
sp044 : (x : ℕ) → (le (suc zero) (le x zero)) ≡ (le x zero)
sp044 zero = refl
sp044 (suc x) = refl
sp045 : (x y : ℕ) → (le (suc zero) (max x (suc y))) ≡ (suc zero)
sp045 zero y = refl
sp045 (suc x) y = refl
sp046 : (x y : ℕ) → (le (suc zero) (max (suc x) y)) ≡ (suc zero)
sp046 x zero = refl
sp046 x (suc y) = refl
sp047 : (x : ℕ) → zero ≡ ((le x zero) ∸ (x + (suc x)))
sp047 zero = refl
sp047 (suc x) = refl
sp048 : (x y z : ℕ) → zero ≡ (le (max x ((suc y) + z)) zero)
sp048 zero y z = refl
sp048 (suc x) y z = refl
sp049 : (x : ℕ) → zero ≡ (le (x + (max x (suc zero))) zero)
sp049 zero = refl
sp049 (suc x) = refl
sp050 : (x y z : ℕ) → zero ≡ (le (max ((suc x) + y) z) zero)
sp050 x y zero = refl
sp050 x y (suc z) = refl
sp051 : (x y : ℕ) → (suc x) ≡ (max (suc x) (le (suc zero) y))
sp051 x zero = refl
sp051 x (suc y) = refl
sp052 : (x y : ℕ) → (suc zero) ≡ (le zero (suc (max x (suc y))))
sp052 x y = refl
sp053 : (x y : ℕ) → (suc zero) ≡ (le zero (suc (max (suc x) y)))
sp053 x y = refl
sp054 : (x : ℕ) → (suc zero) ≡ (le zero ((suc (suc zero)) + x))
sp054 x = refl
sp055 : (suc zero) ≡ (le zero (suc (suc (suc (suc zero)))))
sp055 = refl
sp056 : (x y : ℕ) → (suc zero) ≡ (le (le (suc zero) x) (suc y))
sp056 zero y = refl
sp056 (suc x) y = refl
sp057 : (x : ℕ) → (le x zero) ≡ (le ((suc x) · x) zero)
sp057 zero = refl
sp057 (suc x) = refl
sp058 : (x : ℕ) → (suc (x · (suc zero))) ≡ ((suc x) · (suc zero))
sp058 x = refl
sp059 : (x : ℕ) → (x + x) ≡ ((x + x) ∸ (le x zero))
sp059 zero = refl
sp059 (suc x) = refl
sp060 : (x y : ℕ) → (max x (suc y)) ≡ ((max x (suc y)) ∸ zero)
sp060 x y = refl
sp061 : (x y : ℕ) → (max (suc x) y) ≡ ((max (suc x) y) ∸ zero)
sp061 x y = refl
sp062 : (x : ℕ) → zero ≡ ((le x zero) · (x + (x · x)))
sp062 zero = refl
sp062 (suc x) = refl
sp063 : (x y : ℕ) → zero ≡ ((le x zero) · (x + (x · y)))
sp063 zero y = refl
sp063 (suc x) y = refl
sp064 : ((le zero zero) + (le zero zero)) ≡ (suc (suc zero))
sp064 = refl
sp065 : (x : ℕ) → (le x zero) ≡ ((le x zero) ∸ (x + x))
sp065 zero = refl
sp065 (suc x) = refl
sp066 : (x : ℕ) → (le x zero) ≡ (le (x + x) (le x zero))
sp066 zero = refl
sp066 (suc x) = refl
sp067 : (x : ℕ) → ((suc (suc zero)) + x) ≡ (x + (suc (suc zero)))
sp067 zero = refl
sp067 (suc x) = (cong (λ y → (suc y)) (sp067 x))
sp068 : (x y : ℕ) → ((x + (suc zero)) + y) ≡ (x + (suc y))
sp068 zero y = refl
sp068 (suc x) y = (cong (λ z → (suc z)) (sp068 x y))
sp069 : (x : ℕ) → zero ≡ ((le (suc zero) x) ∸ (suc (le x zero)))
sp069 zero = refl
sp069 (suc x) = refl
sp070 : (x : ℕ) → zero ≡ ((le x zero) ∸ (suc (le (suc zero) x)))
sp070 zero = refl
sp070 (suc x) = refl
sp071 : (x y z : ℕ) → (suc zero) ≡ (le (le x zero) ((suc y) + z))
sp071 zero y z = refl
sp071 (suc x) y z = refl
sp072 : (x : ℕ) → (suc zero) ≡ (le (le (suc zero) x) (x · x))
sp072 zero = refl
sp072 (suc x) = refl
sp073 : (x : ℕ) → (suc zero) ≡ (le (le (suc zero) x) (x + x))
sp073 zero = refl
sp073 (suc x) = refl
sp074 : (x : ℕ) → zero ≡ (le ((suc (suc zero)) + (x + x)) zero)
sp074 x = refl
sp075 : (x : ℕ) → (le (suc (suc zero)) (suc x)) ≡ (le (suc zero) x)
sp075 x = refl
sp076 : (x : ℕ) → (x · ((zero + zero) + (zero + zero))) ≡ zero
sp076 zero = refl
sp076 (suc x) = (sp076 x)
sp077 : (x y : ℕ) → ((suc x) + (y · x)) ≡ (suc ((suc y) · x))
sp077 x y = refl
sp078 : (x : ℕ) → (le x zero) ≡ ((le x zero) ∸ (le (suc zero) x))
sp078 zero = refl
sp078 (suc x) = refl
sp079 : (x : ℕ) → (le x zero) ≡ (le (le (suc zero) x) (le x zero))
sp079 zero = refl
sp079 (suc x) = refl
sp080 : (x : ℕ) → (le (suc zero) x) ≡ (le (le x zero) (x + x))
sp080 zero = refl
sp080 (suc x) = refl
sp081 : (x : ℕ) → (le (suc zero) (le (suc zero) x)) ≡ (le (suc zero) x)
sp081 zero = refl
sp081 (suc x) = refl
sp082 : (x y : ℕ) → (max (max x (suc y)) (suc zero)) ≡ (max x (suc y))
sp082 zero y = refl
sp082 (suc x) y = refl
sp083 : (x y : ℕ) → (max (max (suc x) y) (suc zero)) ≡ (max (suc x) y)
sp083 x zero = refl
sp083 x (suc y) = refl
sp084 : (x : ℕ) → (x · x) ≡ (max (x · x) (le (suc zero) x))
sp084 zero = refl
sp084 (suc x) = refl
sp085 : (x : ℕ) → (x + x) ≡ (max (x + x) (le (suc zero) x))
sp085 zero = refl
sp085 (suc x) = refl
sp086 : (x : ℕ) → zero ≡ ((le x zero) ∸ ((x · x) + (suc x)))
sp086 zero = refl
sp086 (suc x) = refl
sp087 : (x : ℕ) → (suc zero) ≡ (le (le (suc zero) x) (suc (le x zero)))
sp087 zero = refl
sp087 (suc x) = refl
sp088 : (x : ℕ) → zero ≡ (le ((max x (suc zero)) + (x · x)) zero)
sp088 zero = refl
sp088 (suc x) = refl
sp089 : (x : ℕ) → (x + (suc (suc zero))) ≡ (max (suc zero) (suc (suc x)))
sp089 zero = refl
sp089 (suc x) = (cong (λ y → (suc y)) (sp089 x))
sp090 : (x : ℕ) → (x + (suc (suc zero))) ≡ (max (suc (suc x)) (suc zero))
sp090 zero = refl
sp090 (suc x) = (cong (λ y → (suc y)) (sp090 x))
sp091 : (x : ℕ) → (suc (max x (suc zero))) ≡ (max (suc x) (suc (suc zero)))
sp091 x = refl
sp092 : (x : ℕ) → x ≡ (((max zero (suc zero)) · x) + (zero · zero))
sp092 zero = refl
sp092 (suc x) = (cong (λ y → (suc y)) (sp092 x))
sp093 : zero ≡ ((zero · zero) + (zero · (suc (zero · zero))))
sp093 = refl
sp094 : zero ≡ ((zero · zero) + ((zero · zero) · (suc zero)))
sp094 = refl
sp095 : (x : ℕ) → zero ≡ ((x · zero) + (zero · (suc (x · zero))))
sp095 zero = refl
sp095 (suc x) = (sp095 x)
sp096 : (x : ℕ) → zero ≡ ((x · zero) + ((x · zero) · (suc zero)))
sp096 zero = refl
sp096 (suc x) = (sp096 x)
sp097 : (x : ℕ) → (le (suc zero) x) ≡ ((le (suc zero) x) ∸ (le x zero))
sp097 zero = refl
sp097 (suc x) = refl
sp098 : zero ≡ ((le (suc (suc zero)) zero) + (le (suc (suc zero)) zero))
sp098 = refl
sp099 : (x : ℕ) → (le x zero) ≡ ((le x zero) ∸ (x + (x · x)))
sp099 zero = refl
sp099 (suc x) = refl
sp100 : (x y : ℕ) → (le x zero) ≡ ((le x zero) ∸ (x + (x · y)))
sp100 zero y = refl
sp100 (suc x) y = refl
sp101 : (x : ℕ) → (le (suc zero) x) ≡ (le (le x zero) (le (suc zero) x))
sp101 zero = refl
sp101 (suc x) = refl
sp102 : (x : ℕ) → (le x zero) ≡ (le (x + (x · x)) (le x zero))
sp102 zero = refl
sp102 (suc x) = refl
sp103 : (x y : ℕ) → (le x zero) ≡ (le (x + (x · y)) (le x zero))
sp103 zero y = refl
sp103 (suc x) y = refl
sp104 : (x : ℕ) → (le x zero) ≡ (le (x + (x + (x + x))) zero)
sp104 zero = refl
sp104 (suc x) = refl
sp105 : (x : ℕ) → (le (suc zero) (x + (x · x))) ≡ (le (suc zero) x)
sp105 zero = refl
sp105 (suc x) = refl
sp106 : (x y : ℕ) → (le (suc zero) (x + (x · y))) ≡ (le (suc zero) x)
sp106 zero y = refl
sp106 (suc x) y = refl
sp107 : (x : ℕ) → ((suc (max x (suc zero))) · x) ≡ (x + (x · x))
sp107 zero = refl
sp107 (suc x) = refl
sp108 : (x y z : ℕ) → (x + (y + z)) ≡ (max ((x + y) + z) x)
sp108 zero y z = refl
sp108 (suc x) y z = (cong (λ u → (suc u)) (sp108 x y z))
sp109 : (x : ℕ) → (x + (suc x)) ≡ (max (le x zero) (x + (suc x)))
sp109 zero = refl
sp109 (suc x) = refl
sp110 : (x y : ℕ) → (suc (max x (suc y))) ≡ (max (suc (max x (suc y))) zero)
sp110 x y = refl
sp111 : (x y : ℕ) → (suc (max (suc x) y)) ≡ (max (suc (max (suc x) y)) zero)
sp111 x y = refl
sp112 : (x : ℕ) → ((suc (suc zero)) + x) ≡ (max ((suc (suc zero)) + x) zero)
sp112 x = refl
sp113 : (suc (suc (suc (suc zero)))) ≡ (max (suc (suc (suc (suc zero)))) zero)
sp113 = refl
sp114 : (x : ℕ) → (le (suc (suc (suc zero))) (suc x)) ≡ (le (suc (suc zero)) x)
sp114 x = refl
sp115 : (x : ℕ) → (x + (max x (suc zero))) ≡ ((max x (suc zero)) + x)
sp115 zero = refl
sp115 (suc x) = refl
sp116 : (x : ℕ) → ((x · zero) + (max (x · zero) (suc zero))) ≡ (suc zero)
sp116 zero = refl
sp116 (suc x) = (sp116 x)
sp117 : (x : ℕ) → (((x · zero) · (suc (x · zero))) + (x · zero)) ≡ zero
sp117 zero = refl
sp117 (suc x) = (sp117 x)
sp118 : (x y : ℕ) → (le (suc zero) (max x (suc y))) ≡ (le zero (max x (suc y)))
sp118 zero y = refl
sp118 (suc x) y = refl
sp119 : (x y : ℕ) → (le (suc zero) (max (suc x) y)) ≡ (le zero (max (suc x) y))
sp119 x zero = refl
sp119 x (suc y) = refl
sp120 : (x : ℕ) → ((max x (suc zero)) + x) ≡ (max (x + x) (le x zero))
sp120 zero = refl
sp120 (suc x) = refl
sp121 : (x y : ℕ) → (max (max x (suc y)) (suc zero)) ≡ (max (max x (suc y)) zero)
sp121 zero y = refl
sp121 (suc x) y = refl
sp122 : (x y : ℕ) → (max (max (suc x) y) (suc zero)) ≡ (max (max (suc x) y) zero)
sp122 x zero = refl
sp122 x (suc y) = refl
sp123 : (x : ℕ) → ((max x (suc zero)) + x) ≡ (max (le x zero) (x + x))
sp123 zero = refl
sp123 (suc x) = refl
sp124 : (x y z : ℕ) → ((x + y) + (z · y)) ≡ (x + ((suc z) · y))
sp124 zero y z = refl
sp124 (suc x) y z = (cong (λ u → (suc u)) (sp124 x y z))
sp125 : (x : ℕ) → ((x · zero) + ((x · zero) · (suc (x · zero)))) ≡ zero
sp125 zero = refl
sp125 (suc x) = (sp125 x)
sp126 : (x : ℕ) → (suc (le x zero)) ≡ (max (le (suc zero) x) (suc (le x zero)))
sp126 zero = refl
sp126 (suc x) = refl
sp127 : (x : ℕ) → (suc (le x zero)) ≡ (max (suc (le x zero)) (le (suc zero) x))
sp127 zero = refl
sp127 (suc x) = refl
sp128 : zero ≡ (((suc zero) · zero) + (zero · (suc ((suc zero) · zero))))
sp128 = refl
sp129 : zero ≡ (((suc zero) · zero) + (((suc zero) · zero) · (suc zero)))
sp129 = refl
sp130 : (x : ℕ) → (x + (x · x)) ≡ ((x + (x · x)) ∸ (le x zero))
sp130 zero = refl
sp130 (suc x) = refl
sp131 : (x y : ℕ) → (x + (x · y)) ≡ ((x + (x · y)) ∸ (le x zero))
sp131 zero y = refl
sp131 (suc x) y = refl
sp132 : (x : ℕ) → (le (suc zero) (le x zero)) ≡ (le (le (suc zero) x) (le x zero))
sp132 zero = refl
sp132 (suc x) = refl
sp133 : (x : ℕ) → (max (le x zero) (suc zero)) ≡ (max (le x zero) (le (suc zero) x))
sp133 zero = refl
sp133 (suc x) = refl
sp134 : (x : ℕ) → (max (le x zero) (suc zero)) ≡ (max (le (suc zero) x) (le x zero))
sp134 zero = refl
sp134 (suc x) = refl
sp135 : (x : ℕ) → (suc (le (suc zero) x)) ≡ (max (le x zero) (suc (le (suc zero) x)))
sp135 zero = refl
sp135 (suc x) = refl
sp136 : (x : ℕ) → ((x · x) ∸ (suc zero)) ≡ ((x · x) ∸ (le (suc zero) x))
sp136 zero = refl
sp136 (suc x) = refl
sp137 : (x : ℕ) → ((x + x) ∸ (suc zero)) ≡ ((x + x) ∸ (le (suc zero) x))
sp137 zero = refl
sp137 (suc x) = refl
sp138 : zero ≡ (le ((suc (suc zero)) + ((suc (suc zero)) + (suc (suc zero)))) zero)
sp138 = refl
sp139 : (x y : ℕ) → (le x zero) ≡ (le ((x + x) + (x · (y + y))) zero)
sp139 zero y = refl
sp139 (suc x) y = refl
sp140 : (x : ℕ) → (le (suc (suc (suc (suc zero)))) (suc x)) ≡ (le (suc (suc (suc zero))) x)
sp140 x = refl
sp141 : (x : ℕ) → (le (x · x) (suc zero)) ≡ (le (x · x) (le (suc zero) x))
sp141 zero = refl
sp141 (suc x) = refl
sp142 : (x : ℕ) → (le (x + x) (suc zero)) ≡ (le (x + x) (le (suc zero) x))
sp142 zero = refl
sp142 (suc x) = refl
sp143 : (x : ℕ) → (le (suc zero) x) ≡ (le (suc zero) (x + (x + (x + x))))
sp143 zero = refl
sp143 (suc x) = refl
sp144 : (x : ℕ) → ((suc (x · zero)) + ((x · zero) · (suc (x · zero)))) ≡ (suc zero)
sp144 zero = refl
sp144 (suc x) = (sp144 x)
sp145 : (x : ℕ) → (le (suc zero) (le (suc zero) x)) ≡ (le (le x zero) (le (suc zero) x))
sp145 zero = refl
sp145 (suc x) = refl
sp146 : (x : ℕ) → (max (le (suc zero) x) (suc zero)) ≡ (max (le (suc zero) x) (le x zero))
sp146 zero = refl
sp146 (suc x) = refl
sp147 : (x : ℕ) → (max (le (suc zero) x) (suc zero)) ≡ (max (le x zero) (le (suc zero) x))
sp147 zero = refl
sp147 (suc x) = refl
sp148 : (x : ℕ) → ((suc x) · (max x (suc zero))) ≡ ((max x (suc zero)) + (x · x))
sp148 zero = refl
sp148 (suc x) = refl
sp149 : (x : ℕ) → (((x · zero) · (suc (x · zero))) + (suc (x · zero))) ≡ (suc zero)
sp149 zero = refl
sp149 (suc x) = (sp149 x)
sp150 : zero ≡ (((le zero zero) · zero) + (zero · (suc ((le zero zero) · zero))))
sp150 = refl
sp151 : zero ≡ (((le zero zero) · zero) + (((le zero zero) · zero) · (suc zero)))
sp151 = refl
sp152 : (x : ℕ) → zero ≡ (((zero ∸ x) · zero) + (zero · (suc ((zero ∸ x) · zero))))
sp152 zero = refl
sp152 (suc x) = refl
sp153 : (x : ℕ) → zero ≡ (((zero ∸ x) · zero) + (((zero ∸ x) · zero) · (suc zero)))
sp153 zero = refl
sp153 (suc x) = refl
sp154 : (x : ℕ) → ((x · x) + (suc x)) ≡ (max (le x zero) ((x · x) + (suc x)))
sp154 zero = refl
sp154 (suc x) = refl
sp155 : (x : ℕ) → (le (suc zero) x) ≡ (le (suc zero) (x · ((x + x) + (x + x))))
sp155 zero = refl
sp155 (suc x) = refl
sp156 : (x y z : ℕ) → (x + (max (y + z) (suc zero))) ≡ (max ((x + y) + z) (suc x))
sp156 zero y z = refl
sp156 (suc x) y z = (cong (λ u → (suc u)) (sp156 x y z))
sp157 : (x : ℕ) → (le (suc zero) (x + (x · x))) ≡ (le (le x zero) (x + (x · x)))
sp157 zero = refl
sp157 (suc x) = refl
sp158 : (x y : ℕ) → (le (suc zero) (x + (x · y))) ≡ (le (le x zero) (x + (x · y)))
sp158 zero y = refl
sp158 (suc x) y = refl
sp159 : (x : ℕ) → (max (x + (x · x)) (suc zero)) ≡ (max (x + (x · x)) (le x zero))
sp159 zero = refl
sp159 (suc x) = refl
sp160 : (x y : ℕ) → (max (x + (x · y)) (suc zero)) ≡ (max (x + (x · y)) (le x zero))
sp160 zero y = refl
sp160 (suc x) y = refl
sp161 : (x : ℕ) → (max (x + (x · x)) (suc zero)) ≡ (max (le x zero) (x + (x · x)))
sp161 zero = refl
sp161 (suc x) = refl
sp162 : (x y : ℕ) → (max (x + (x · y)) (suc zero)) ≡ (max (le x zero) (x + (x · y)))
sp162 zero y = refl
sp162 (suc x) y = refl
sp163 : (x : ℕ) → ((x · zero) + (max ((x · zero) · (suc (x · zero))) (suc zero))) ≡ (suc zero)
sp163 zero = refl
sp163 (suc x) = (sp163 x)
sp164 : zero ≡ ((zero + zero) + (((suc (suc zero)) · zero) · (suc ((suc (suc zero)) · zero))))
sp164 = refl
sp165 : zero ≡ (((suc (suc zero)) · zero) + ((zero + zero) · (suc ((suc (suc zero)) · zero))))
sp165 = refl
sp166 : zero ≡ (((suc (suc zero)) · zero) + (((suc (suc zero)) · zero) · (suc (zero + zero))))
sp166 = refl
sp167 : (x : ℕ) → (le x zero) ≡ (le ((x + x) + (x · ((x + x) + (x + x)))) zero)
sp167 zero = refl
sp167 (suc x) = refl
sp168 : zero ≡ ((zero · zero) + (((max zero (suc zero)) · zero) · (suc ((max zero (suc zero)) · zero))))
sp168 = refl
sp169 : zero ≡ (((max zero (suc zero)) · zero) + ((zero · zero) · (suc ((max zero (suc zero)) · zero))))
sp169 = refl
sp170 : zero ≡ (((max zero (suc zero)) · zero) + (((max zero (suc zero)) · zero) · (suc (zero · zero))))
sp170 = refl
sp171 : ((max (suc (suc zero)) (suc zero)) + (max (suc (suc zero)) (suc zero))) ≡ ((suc (suc zero)) + (suc (suc zero)))
sp171 = refl
sp172 : (x : ℕ) → (x · ((x + x) + (x + x))) ≡ (x · ((x + (max x (suc zero))) + (x + (max x (suc zero)))))
sp172 zero = refl
sp172 (suc x) = refl
sp173 : (x : ℕ) → (x · ((x + x) + (x + x))) ≡ (x · ((max (x + x) (suc zero)) + (max (x + x) (suc zero))))
sp173 zero = refl
sp173 (suc x) = refl
