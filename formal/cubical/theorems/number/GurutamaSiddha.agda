{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ó‡‡∞‡‡‡Æ‡ ‡‡ø‡¶‡‡ß‡ ‚î ‡Ø‡¶‡ø ‡ó‡‡ø‡ a b ‡‡Æ‡æ‡‡‡‡æ (g ‡‡‡∞‡Ø‡‡‡‡‡ø), ‡‡∞‡‡‡ø g ‡‡Ø‡ã‡ ‡ó‡‡∞‡‡‡Æ‡
-- ‡‡æ‡ß‡æ‡∞‡‡ ‡µ‡ø‡‡æ‡‡ï‡ ‚î ‡‡‡∞‡Æ‡æ‡‡‡‡‡‡‡ï‡‡‡Ø (Cubical.Data.Nat.GCD) isGCD-‡¶‡‡µ‡æ‡∞‡æ
-- ‡‡‡∞‡Æ‡æ‡‡ø‡‡, ‡Ø‡‡‡∞ ‡‡®‡‡‡∞‡‡‡‡‡æ ‡‡ï‡‡‡µ‡Æ‡ ‡‡‡ø (isPropGCD) ‡
--
-- ‡¶‡‡µ‡ ‡‡∞‡ã‡‡ : (‡ß) ‡µ‡ø‡‡‡‡ø-‡≤‡‡ñ‡ ‚î g ‡â‡‡ ‡µ‡ø‡‡‡‡ø (‡‡æ‡ß‡æ‡∞‡‡) ; (‡®) ‡Æ‡‡‡-‡≤‡‡ñ‡ ‚î
-- ‡Ø‡ ‡ï‡ã‡Ω‡‡ø ‡‡æ‡ß‡æ‡∞‡‡ d' ‡‡ g ‡µ‡ø‡‡‡‡ø (‡ó‡‡∞‡‡‡Æ‡) ‡  ‡Æ‡‡≤‡Æ‡®‡‡‡‡∞‡Æ‡ : ‡‡∞‡‡Ø‡‡ü‡‡‡Ø
-- ‡‡®‡‡‡∞-‡µ‡ø‡Ø‡ã‡‡®‡ ‡‡æ‡ß‡æ‡∞‡-‡µ‡ø‡‡æ‡‡ï‡æ‡®‡ ‡â‡‡Ø‡‡ ‡∞‡ï‡‡‡‡ø ‚î ‚à-‡Ø‡ã‡ó‡ (‡‡ô‡‡ï‡≤‡®‡) ‡
-- ‚à-‡‡®‡‡‡∞‡ (‡µ‡ø‡Ø‡ã‡‡®‡) ; ‡â‡‡‡‡æ‡®‡‡® (‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡) ‡ä‡∞‡‡ß‡‡µ‡ ‡®‡‡Ø‡‡ ‡
--
-- (greatest common measure, PROVED: if ‡ó‡‡ø a b resolves to g, then g is the
-- greatest common divisor ‚î certified via the library's isGCD, which
-- carries uniqueness.  Two ascents: g divides both (common), and every
-- common d' divides g (greatest).  The engine is that ryabhaa's
-- subtraction preserves common divisors in BOTH directions ‚î ‚à-‡Ø‡ã‡ó on sums,
-- ‚à-‡‡®‡‡‡∞ on differences ‚î lifted up the spine by ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡.)
--
-- ‡‡®‡‡ï‡‡‡ (‡‡®‡‡¶‡æ‡®-‡ï‡‡‡Ø‡) ‡¶‡æ‡µ‡æ ‡®‡æ‡‡‡‡ø ‚î ‡ï‡‡‡‡‡‡∞‡‡ ‡‡‡Æ‡‡‡µ‡ ; ‡® ‡¶‡‡∞‡‡®‡Ø‡ ‡
-- (on the un-said/grant-exhausted branch nothing is claimed ‚î impossible by
-- ‡ï‡‡‡‡‡‡∞; no durnaya.)
------------------------------------------------------------------------

module GurutamaSiddha where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (‚Ñï ; zero ; suc ; _+_ ; _¬∑_ ; _‚à∏_ ; +-assoc ; ‚à∏-distrib ≥ ; ‚à∏+)
open import Cubical.Data.Nat.Divisibility
  using (_‚à£_ ; ‚à£-untrunc ; ‚à£-refl ; ‚à£-zero ≥)
open import Cubical.Data.Nat.GCD using (isCD ; isGCD)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.HITs.PropositionalTruncation as PT using (‚à£_‚à£‚ÇÅ)
open import LosslessReturn
  using (‡§µ‡§ø‡§µ‡•á‡§ï ; ‡§∏‡§Æ ; ‡§µ‡§æ‡§Æ ; ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ ; ‡§Ö‡§µ‡§§‡§∞‡§£ ; ‡§â‡§§‡•ç‡§•‡§æ‡§® ; ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç)
open import Gati
  using (‡§´‡§≤‡§Æ‡•ç ; ‡§ó‡•Å‡§∞‡•Å‡§É ; ‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§´‡§≤‡§Æ‡•ç ; ‡§´‡§≤ ; ‡§™‡§¶-‡§ó‡§§‡§ø ; ‡§ó‡§§‡§ø)
open import Gurutama using (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞ ; ‡§Æ‡§æ‡§®)

------------------------------------------------------------------------
-- ‡µ‡ø‡‡∞‡, ‚à-‡Ø‡ã‡ó, ‚à-‡‡®‡‡‡∞ ‚î ‡‡æ‡ß‡æ‡∞‡-‡µ‡ø‡‡æ‡‡ï‡æ‡®‡æ‡ ‡‡ô‡‡ï‡≤‡®‡ ‡µ‡ø‡Ø‡ã‡‡®‡ ‡ ‡∞‡ï‡‡‡æ ‡
------------------------------------------------------------------------

‡§µ‡§ø‡§§‡§∞‡§£ : (a b m : ‚Ñï) ‚Üí (a + b) ¬∑ m ‚â° (a ¬∑ m) + (b ¬∑ m)
‡§µ‡§ø‡§§‡§∞‡§£ zero    b m = refl
‡§µ‡§ø‡§§‡§∞‡§£ (suc a) b m = cong (m +_) (‡§µ‡§ø‡§§‡§∞‡§£ a b m) ‚àô +-assoc m (a ¬∑ m) (b ¬∑ m)

-- ‡‡ô‡‡ï‡≤‡®‡ : m ‚à x ‚í m ‚à y ‚í m ‚à (x + y)
‚à£-‡§Ø‡•ã‡§ó : {‡§Æ x y : ‚Ñï} ‚Üí ‡§Æ ‚à£ x ‚Üí ‡§Æ ‚à£ y ‚Üí ‡§Æ ‚à£ (x + y)
‚à£-‡§Ø‡•ã‡§ó {‡§Æ} {x} {y} = PT.map2 Œª (qx , px) (qy , py) ‚Üí
  (qx + qy) , ‡§µ‡§ø‡§§‡§∞‡§£ qx qy ‡§Æ ‚àô cong‚ÇÇ _+_ px py

-- ‡µ‡ø‡Ø‡ã‡‡®‡ : m ‚à (x + y) ‚í m ‚à x ‚í m ‚à y  (ryabhaa's difference law)
‚à£-‡§Ö‡§®‡•ç‡§§‡§∞ : {‡§Æ x y : ‚Ñï} ‚Üí ‡§Æ ‚à£ (x + y) ‚Üí ‡§Æ ‚à£ x ‚Üí ‡§Æ ‚à£ y
‚à£-‡§Ö‡§®‡•ç‡§§‡§∞ {‡§Æ} {x} {y} pxy px =
  let (c‚ÇÅ , e‚ÇÅ) = ‚à£-untrunc pxy          -- c‚ÇÅ ¬∑ ‡§Æ ‚â° x + y
      (c‚ÇÇ , e‚ÇÇ) = ‚à£-untrunc px           -- c‚ÇÇ ¬∑ ‡§Æ ‚â° x
  in ‚à£ (c‚ÇÅ ‚à∏ c‚ÇÇ)
     , ( ‚à∏-distrib ≥ c‚ÇÅ c‚ÇÇ ‡§Æ
       ‚àô cong‚ÇÇ _‚à∏_ e‚ÇÅ e‚ÇÇ
       ‚àô ‚à∏+ y x )                        -- (x + y) ‚à∏ x ‚â° y
     ‚à£‚ÇÅ

------------------------------------------------------------------------
-- ‡µ‡ø‡‡‡‡ø-‡≤‡‡ñ‡ ‚î g ‡‡‡‡Ø ‡≤‡‡ñ‡‡‡Ø ‡Ø‡‡ó‡‡Æ‡ ‡â‡‡Ø‡‡ ‡µ‡ø‡‡‡‡ø (‡‡æ‡ß‡æ‡∞‡‡) ‡
------------------------------------------------------------------------

‡§µ‡§ø‡§≠‡§ú‡§§‡§ø : (f : ‚Ñï) (v : ‡§µ‡§ø‡§µ‡•á‡§ï) (g : ‚Ñï)
       ‚Üí ‡§´‡§≤ (‡§™‡§¶-‡§ó‡§§‡§ø f v) ‚â° ‡§ó‡•Å‡§∞‡•Å‡§É g
       ‚Üí (g ‚à£ fst (‡§â‡§§‡•ç‡§•‡§æ‡§® v)) √ó (g ‚à£ snd (‡§â‡§§‡•ç‡§•‡§æ‡§® v))
‡§µ‡§ø‡§≠‡§ú‡§§‡§ø zero v g eq = ‚ä•-rec (subst ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞ (sym eq) tt)
‡§µ‡§ø‡§≠‡§ú‡§§‡§ø (suc f) (‡§∏‡§Æ d) g eq =
  ‚à£-refl g‚â°d , ‚à£-refl g‚â°d
  where g‚â°d = sym (cong ‡§Æ‡§æ‡§® eq)
‡§µ‡§ø‡§≠‡§ú‡§§‡§ø (suc f) (‡§µ‡§æ‡§Æ zero k) g eq =
  ‚à£-refl (sym (cong ‡§Æ‡§æ‡§® eq)) , ‚à£-zero ≥ g
‡§µ‡§ø‡§≠‡§ú‡§§‡§ø (suc f) (‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ zero k) g eq =
  ‚à£-zero ≥ g , ‚à£-refl (sym (cong ‡§Æ‡§æ‡§® eq))
‡§µ‡§ø‡§≠‡§ú‡§§‡§ø (suc f) (‡§µ‡§æ‡§Æ (suc d) k) g eq =
  let rec = ‡§µ‡§ø‡§≠‡§ú‡§§‡§ø f (‡§Ö‡§µ‡§§‡§∞‡§£ (suc k) (suc d)) g eq
      p   = ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç (suc k) (suc d)
      g‚à£k = subst (g ‚à£_) (cong fst p) (fst rec)
      g‚à£d = subst (g ‚à£_) (cong snd p) (snd rec)
  in ‚à£-‡§Ø‡•ã‡§ó g‚à£d g‚à£k , g‚à£d
‡§µ‡§ø‡§≠‡§ú‡§§‡§ø (suc f) (‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ (suc d) k) g eq =
  let rec = ‡§µ‡§ø‡§≠‡§ú‡§§‡§ø f (‡§Ö‡§µ‡§§‡§∞‡§£ (suc d) (suc k)) g eq
      p   = ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç (suc d) (suc k)
      g‚à£d = subst (g ‚à£_) (cong fst p) (fst rec)
      g‚à£k = subst (g ‚à£_) (cong snd p) (snd rec)
  in g‚à£d , ‚à£-‡§Ø‡•ã‡§ó g‚à£d g‚à£k

------------------------------------------------------------------------
-- ‡Æ‡‡‡-‡≤‡‡ñ‡ ‚î ‡Ø‡ ‡ï‡ã‡Ω‡‡ø ‡‡æ‡ß‡æ‡∞‡‡ d' ‡‡‡‡Ø ‡≤‡‡ñ‡‡‡Ø ‡Ø‡‡ó‡‡Æ‡‡‡Ø, ‡‡ g ‡µ‡ø‡‡‡‡ø ‡
------------------------------------------------------------------------

‡§Æ‡§π‡§§‡•ç : (f : ‚Ñï) (v : ‡§µ‡§ø‡§µ‡•á‡§ï) (g d' : ‚Ñï)
     ‚Üí ‡§´‡§≤ (‡§™‡§¶-‡§ó‡§§‡§ø f v) ‚â° ‡§ó‡•Å‡§∞‡•Å‡§É g
     ‚Üí d' ‚à£ fst (‡§â‡§§‡•ç‡§•‡§æ‡§® v) ‚Üí d' ‚à£ snd (‡§â‡§§‡•ç‡§•‡§æ‡§® v)
     ‚Üí d' ‚à£ g
‡§Æ‡§π‡§§‡•ç zero v g d' eq _ _ = ‚ä•-rec (subst ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞ (sym eq) tt)
‡§Æ‡§π‡§§‡•ç (suc f) (‡§∏‡§Æ d) g d' eq h‚ÇÅ _ =
  subst (d' ‚à£_) (cong ‡§Æ‡§æ‡§® eq) h‚ÇÅ
‡§Æ‡§π‡§§‡•ç (suc f) (‡§µ‡§æ‡§Æ zero k) g d' eq h‚ÇÅ _ =
  subst (d' ‚à£_) (cong ‡§Æ‡§æ‡§® eq) h‚ÇÅ
‡§Æ‡§π‡§§‡•ç (suc f) (‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ zero k) g d' eq _ h‚ÇÇ =
  subst (d' ‚à£_) (cong ‡§Æ‡§æ‡§® eq) h‚ÇÇ
‡§Æ‡§π‡§§‡•ç (suc f) (‡§µ‡§æ‡§Æ (suc d) k) g d' eq h‚ÇÅ h‚ÇÇ =
  let p    = ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç (suc k) (suc d)
      d'‚à£k = ‚à£-‡§Ö‡§®‡•ç‡§§‡§∞ h‚ÇÅ h‚ÇÇ          -- fst = suc d + suc k, snd = suc d ‚üπ d' ‚à£ suc k
  in ‡§Æ‡§π‡§§‡•ç f (‡§Ö‡§µ‡§§‡§∞‡§£ (suc k) (suc d)) g d' eq
          (subst (d' ‚à£_) (sym (cong fst p)) d'‚à£k)
          (subst (d' ‚à£_) (sym (cong snd p)) h‚ÇÇ)
‡§Æ‡§π‡§§‡•ç (suc f) (‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ (suc d) k) g d' eq h‚ÇÅ h‚ÇÇ =
  let p    = ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç (suc d) (suc k)
      d'‚à£k = ‚à£-‡§Ö‡§®‡•ç‡§§‡§∞ h‚ÇÇ h‚ÇÅ          -- snd = suc d + suc k, fst = suc d ‚üπ d' ‚à£ suc k
  in ‡§Æ‡§π‡§§‡•ç f (‡§Ö‡§µ‡§§‡§∞‡§£ (suc d) (suc k)) g d' eq
          (subst (d' ‚à£_) (sym (cong fst p)) h‚ÇÅ)
          (subst (d' ‚à£_) (sym (cong snd p)) d'‚à£k)

------------------------------------------------------------------------
-- ‡‡ø‡¶‡‡ß‡ ‚î ‡Æ‡‡ñ‡‡Ø‡‡ø‡¶‡‡ß‡æ‡®‡‡‡ : ‡ó‡‡ø‡ ‡Ø‡¶‡ø g ‡‡‡∞‡Ø‡‡‡‡‡ø, ‡‡∞‡‡‡ø isGCD a b g ‡
-- (main theorem: if the pulverizer resolves to g, then g is THE greatest
-- common divisor of a and b ‚î library-certified, uniqueness included.)
------------------------------------------------------------------------

‡§∏‡§ø‡§¶‡•ç‡§ß‡§É : (f a b g : ‚Ñï) ‚Üí ‡§´‡§≤ (‡§ó‡§§‡§ø f a b) ‚â° ‡§ó‡•Å‡§∞‡•Å‡§É g ‚Üí isGCD a b g
‡§∏‡§ø‡§¶‡•ç‡§ß‡§É f a b g eq = ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§É , ‡§ó‡•Å‡§∞‡•Å‡§§‡§Æ‡§É
  where
  p      = ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç a b
  rec-cd = ‡§µ‡§ø‡§≠‡§ú‡§§‡§ø f (‡§Ö‡§µ‡§§‡§∞‡§£ a b) g eq
  g‚à£a    = subst (g ‚à£_) (cong fst p) (fst rec-cd)
  g‚à£b    = subst (g ‚à£_) (cong snd p) (snd rec-cd)

  ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§É : isCD a b g
  ‡§∏‡§æ‡§ß‡§æ‡§∞‡§£‡§É = g‚à£a , g‚à£b

  ‡§ó‡•Å‡§∞‡•Å‡§§‡§Æ‡§É : (d' : ‚Ñï) ‚Üí isCD a b d' ‚Üí d' ‚à£ g
  ‡§ó‡•Å‡§∞‡•Å‡§§‡§Æ‡§É d' (d'‚à£a , d'‚à£b) =
    ‡§Æ‡§π‡§§‡•ç f (‡§Ö‡§µ‡§§‡§∞‡§£ a b) g d' eq
         (subst (d' ‚à£_) (sym (cong fst p)) d'‚à£a)
         (subst (d' ‚à£_) (sym (cong snd p)) d'‚à£b)
