{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- рр╛рзррпрр╛ тФ рр░ррпррЯрррп рр░ррр рЙррпрр : р░ррЦр┐рХ-рррЧрор a┬X тЙб b┬Y + c рр╛рзррпр
-- рпржр┐ р рХрр╡р▓р рпржр┐ рЧрр░рррор g рррЦррпр╛р c р╡р┐рррр┐ р
--   рр░ррпр╛ррррр╛ (sufficiency) : Yuti.рпррр┐р (c тЙб g┬m тЯ рр╛рзрирор) р
--   рр╡рррпрХрр╛ (necessity, рррр░) : рпржр┐ рр╛рзрирор ррррр┐, рр░ррр┐ g тИ c р
-- (ryabhaa's solvability condition, both directions: the linear
-- congruence is solvable iff the gcd divides c.  Sufficiency is рпррр┐р;
-- necessity is proved here тФ if any solution exists, the gcd divides c.)
--
-- риррпр╛рпр : g рЙрр a b р╡р┐рррр┐ (рр┐ржррзр) тЯ g р┬X, b┬Y р р╡р┐рррр┐ ; a┬X = b┬Y + c
-- тЯ g рриррр░р c р╡р┐рррр┐ (тИ-рриррр░р) р  рр░ррпррЯрррп рриррр░-р╡р┐рпрЛррирор рр╡ р
-- (g divides both a and b, hence a┬X and b┬Y; and a┬X = b┬Y + c forces
-- g тИ c by the difference law тФ ryabhaa's own subtraction, once more.)
------------------------------------------------------------------------

module Sadhyata where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (тДХ ; _+_ ; _┬╖_ ; ┬╖-assoc ; ┬╖-comm)
open import Cubical.Data.Nat.Divisibility using (_тИг_ ; тИг-untrunc)
open import Cubical.Data.Sigma using (_├Ч_ ; _,_ ; fst ; snd)
open import Cubical.HITs.PropositionalTruncation using (тИг_тИгтВБ)
open import GurutamaSiddha using (тИг-рдЕрдиреНрддрд░ ; рд╕рд┐рджреНрдзрдГ)
open import Yuti using (рдпреБрддрд┐рд╕рд┐рджреНрдзрд┐ ; рд╡рд╛рдордпреБрддрд┐ ; рджрдХреНрд╖рд┐рдгрдпреБрддрд┐)
open import Gati using (рдЧреБрд░реБрдГ ; рдлрд▓ ; рдЧрддрд┐)

------------------------------------------------------------------------
-- тИ-рЧрр тФ р╡р┐рр╛ррХр рЧррр┐рр ррр┐ р╡р┐рррр┐ : g тИ n тТ g тИ (n ┬ k) р
------------------------------------------------------------------------

тИг-рдЧреБрдг : {g n : тДХ} тЖТ g тИг n тЖТ (k : тДХ) тЖТ g тИг (n ┬╖ k)
тИг-рдЧреБрдг {g} {n} p k =
  let (q , e) = тИг-untrunc p            -- q ┬╖ g тЙб n
  in тИг (q ┬╖ k)
     , ( sym (┬╖-assoc q k g)
       тИЩ cong (q ┬╖_) (┬╖-comm k g)
       тИЩ ┬╖-assoc q g k
       тИЩ cong (_┬╖ k) e )               -- (q ┬╖ k) ┬╖ g тЙб n ┬╖ k
     тИгтВБ

------------------------------------------------------------------------
-- рр╡рррпрХрр╛ тФ рпржр┐ рр╛рзрирор ррррр┐, рр░ррр┐ рЧрр░рррор c р╡р┐рррр┐ р
------------------------------------------------------------------------

рдЖрд╡рд╢реНрдпрдХрддрд╛ : (f a b g c : тДХ)
         тЖТ рдлрд▓ (рдЧрддрд┐ f a b) тЙб рдЧреБрд░реБрдГ g
         тЖТ рдпреБрддрд┐рд╕рд┐рджреНрдзрд┐ a b c
         тЖТ g тИг c
рдЖрд╡рд╢реНрдпрдХрддрд╛ f a b g c eq sol =
  let cd  = fst (рд╕рд┐рджреНрдзрдГ f a b g eq)     -- isCD a b g  =  (g тИг a) ├Ч (g тИг b)
      gтИгa = fst cd
      gтИгb = snd cd
  in рдЙрддреНрддрд░рдореН sol gтИгa gтИгb
  where
  рдЙрддреНрддрд░рдореН : рдпреБрддрд┐рд╕рд┐рджреНрдзрд┐ a b c тЖТ g тИг a тЖТ g тИг b тЖТ g тИг c
  рдЙрддреНрддрд░рдореН (рд╡рд╛рдордпреБрддрд┐ X Y pf) gтИгa gтИгb =
    -- a┬X тЙб b┬Y + c ; g тИ a┬X, g тИ b┬Y тЯ g тИ c
    тИг-рдЕрдиреНрддрд░ (subst (g тИг_) pf (тИг-рдЧреБрдг gтИгa X)) (тИг-рдЧреБрдг gтИгb Y)
  рдЙрддреНрддрд░рдореН (рджрдХреНрд╖рд┐рдгрдпреБрддрд┐ X Y pf) gтИгa gтИгb =
    -- b┬Y тЙб a┬X + c ; g тИ b┬Y, g тИ a┬X тЯ g тИ c
    тИг-рдЕрдиреНрддрд░ (subst (g тИг_) pf (тИг-рдЧреБрдг gтИгb Y)) (тИг-рдЧреБрдг gтИгa X)
