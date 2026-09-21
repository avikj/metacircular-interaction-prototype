{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡≤‡æ‡ï‡æ ‚î ‡‡‡¶‡®-‡ï‡‡∞‡Æ‡‡ ‡ï‡‡∞‡Æ-‡‡‡¶‡ ‡  ‡‡ï‡à‡ï‡ ‡‡‡¶‡ ‡‡ï‡Æ‡ ‡‡µ ‡‡‡Æ‡ø‡ï‡ ‡‡∞‡‡ø ‡
--
-- (the alk: orders are separated by how many cuts they outlast, and
--  each cut strips exactly one storey.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS EXISTS.  `JainCount.agda` carries the Jaina stratification
-- of magnitude ‚î ‡‡‡ñ‡‡Ø‡æ‡ / ‡‡‡‡ñ‡‡Ø‡æ‡ / ‡‡®‡®‡‡, each graded ‡‡ò‡®‡‡Ø / ‡Æ‡ß‡‡Ø‡Æ /
-- ‡â‡‡‡ï‡‡‡‡ü ‚î as a nine-element ordered set, and its own header names what
-- it does not do: "it does NOT encode the exact salk operations ‚¶
-- which need the primary text verse by verse and are OWED, not claimed."
-- `Ardhaccheda.agda` carries the operations themselves ‚î ‡‡∞‡‡ß‡‡‡‡‡¶, the
-- count of halvings, and ‡µ‡∞‡‡ó‡‡≤‡æ‡ï‡æ, the halving of THAT ‚î but as
-- logarithm laws, with no order-separating work asked of them.
--
-- The two files have never been in the same room.  This one puts the
-- instruments to the job the orders are for: a magnitude's order is HOW
-- MANY TIMES THE INSTRUMENT CAN CUT IT, and ¬ß‡® says each cut removes one
-- storey and no more, so the count is exact rather than a bound.
--
-- WHAT IS SETTLED HERE, in one line each:
--
--   ¬ß‡® ‡‡ï-‡‡‡¶‡      k cuts of a tower of height k+j leave a tower of
--                    height j ‚î exactly one storey per cut.
--   ¬ß‡© ‡Ø‡‡æ‡∞‡‡‡       hence k cuts return a height-k tower to its base;
--                    Ardhaccheda's ‡≤‡ò‡‡ó‡‡ï‡ and ‡¶‡‡µ‡ø‡ï-‡≤‡ò‡‡ó‡‡ï‡ are the k=1
--                    and k=2 cases, recovered here by refl, not restated.
--   ¬ß‡ ‡‡‡Æ‡æ‡‡‡‡ø‡     and k cuts do NOT reach the base of a height-(k+1)
--                    tower: the (k+1)-storey magnitude is still strictly
--                    above n after every one of the k cuts is spent.  THIS
--                    is what "the grades are separated by the instrument"
--                    means as a checked statement.
--   ¬ß‡ ‡‡ß‡ã‡ó‡æ‡Æ‡ø‡‡‡µ‡Æ‡  every cut in the tower ‚î ‡‡∞‡‡ß‡‡‡‡‡¶, ‡µ‡∞‡‡ó‡‡≤‡æ‡ï‡æ, and each
--                    ‡‡‡∞‡ø‡ï- and higher ‡‡≤‡æ‡ï‡æ ‚î is DESCENDING in the sense of
--                    `Vrddhiksaya_‚¶`.‡‡ß‡ã‡ó‡æ‡Æ‡, strictly below its argument
--                    at every positive input.  That file asserted this of
--                    ‡‡∞‡‡ß‡‡‡‡‡¶ in prose and proved only the abstract half.
--                    Here it is the theorem, uniformly in the height.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- MY CITATIONS ARE SECOND-HAND AND I SAY SO.  I have not read the ‡ß‡µ‡≤‡æ or
-- the ‡‡ø‡≤‡ã‡Ø‡‡‡‡‡‡‡‡; what reaches me is the secondary literature on Jaina
-- index arithmetic.  A verse-level reference is OWED and I give NONE
-- rather than a guessed one ‚î a fabricated stra number is the same error
-- as a fitted constant, and this repository has already paid for that once.
--
-- NO JAINA TEXT STATES ANY THEOREM BELOW.  What the sources supply is the
-- operations and the doctrine that magnitude is stratified into orders
-- that the operations move between; the arithmetic here is ordinary and is
-- mine.  In particular ¬ß‡ is NOT a claim that the Jaina ‡‡®‡®‡‡-grades are
-- towers of twos, and no grade of `JainCount.Magnitude` is identified
-- with any natural number here ‚î that file forbids the identification and
-- this file does not import it.
--
-- The material is Jaina throughout and no Nyya-Vaieika vocabulary is
-- used: the two schools reject each other's categories, and the orders of
-- the innumerable arise inside Jaina cosmology and karma theory, not
-- inside anyone's number theory.  Nothing below scores the tradition
-- against later mathematics; the operations are recorded as what they are.
------------------------------------------------------------------------

module Salaka_TheOrdersAreSeparatedByHowManyCutsTheyOutlastAndEachCutStripsExactlyOneStorey where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-zero ; +-comm)
open import Cubical.Data.Nat.Order
  using (_<_ ; _‚â§_ ; zero-‚â§ ; suc-‚â§-suc ; ‚â§-suc ; ‚â§-trans ; ‚â§<-trans ; <-weaken
        ; ‚â§SumRight)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Relation.Nullary using (¬¨_)

open import PanktiYoga using (‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§)
open import Ardhaccheda
  using (‡§Ö‡§∞‡•ç‡§ß ; ‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶ ; ‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶ ; ‡§µ‡§∞‡•ç‡§ó‡§∂‡§≤‡§æ‡§ï‡§æ ; ‡§≤‡§ò‡•Å‡§ó‡§£‡§ï‡§É ; ‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§-pos)
open import Vrddhiksaya_TheAscendingGeneratorNeverReturnsAndTheDescendingOneExhausts
  using (‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä ; ‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä ; ‡§®-‡§â‡§≠‡§Ø‡§Æ‡•ç)

------------------------------------------------------------------------
-- ‡ß ¬ ‡â‡®‡‡®‡‡ø and ‡‡‡¶‡® ‚î the tower, and the cut applied k times.
--
--     ‡â‡®‡‡®‡‡ø k n is the tower of k twos over n: ‡â‡®‡‡®‡‡ø 0 n = n and each
--     storey doubles the exponent.  ‡‡‡¶‡® k is ‡‡∞‡‡ß‡‡‡‡‡¶ applied k times.
--     ‡‡‡¶‡® 1 IS ‡‡∞‡‡ß‡‡‡‡‡¶ and ‡‡‡¶‡® 2 IS ‡µ‡∞‡‡ó‡‡≤‡æ‡ï‡æ, definitionally ‚î the
--     two examples below hold by refl, so this is not a new instrument
--     that happens to agree with Vrasena's, it is the same one indexed.
------------------------------------------------------------------------

‡§â‡§®‡•ç‡§®‡§§‡§ø : ‚Ñï ‚Üí ‚Ñï ‚Üí ‚Ñï
‡§â‡§®‡•ç‡§®‡§§‡§ø zero    n = n
‡§â‡§®‡•ç‡§®‡§§‡§ø (suc k) n = ‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ (‡§â‡§®‡•ç‡§®‡§§‡§ø k n)

‡§õ‡•á‡§¶‡§® : ‚Ñï ‚Üí ‚Ñï ‚Üí ‚Ñï
‡§õ‡•á‡§¶‡§® zero    m = m
‡§õ‡•á‡§¶‡§® (suc k) m = ‡§õ‡•á‡§¶‡§® k (‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶ m)

‡§õ‡•á‡§¶‡§®-‡§è‡§ï‡§É : (m : ‚Ñï) ‚Üí ‡§õ‡•á‡§¶‡§® 1 m ‚â° ‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶ m
‡§õ‡•á‡§¶‡§®-‡§è‡§ï‡§É m = refl

‡§õ‡•á‡§¶‡§®-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç : (m : ‚Ñï) ‚Üí ‡§õ‡•á‡§¶‡§® 2 m ‚â° ‡§µ‡§∞‡•ç‡§ó‡§∂‡§≤‡§æ‡§ï‡§æ m
‡§õ‡•á‡§¶‡§®-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç m = refl

------------------------------------------------------------------------
-- ‡® ¬ ‡‡ï-‡‡‡¶‡ ‚î EACH CUT STRIPS EXACTLY ONE STOREY.  k cuts of a tower of
--     height k+j leave the tower of height j standing.  The proof is the
--     one law Ardhaccheda already has ‚î ‡‡∞‡‡ß‡‡‡‡‡¶(2^y) ‚â° y ‚î applied once
--     per storey, and it is exact: not "at most one storey", not "at
--     least", one.
------------------------------------------------------------------------

‡§è‡§ï-‡§õ‡•á‡§¶‡§É : (k j n : ‚Ñï) ‚Üí ‡§õ‡•á‡§¶‡§® k (‡§â‡§®‡•ç‡§®‡§§‡§ø (k + j) n) ‚â° ‡§â‡§®‡•ç‡§®‡§§‡§ø j n
‡§è‡§ï-‡§õ‡•á‡§¶‡§É zero    j n = refl
‡§è‡§ï-‡§õ‡•á‡§¶‡§É (suc k) j n =
    cong (‡§õ‡•á‡§¶‡§® k) (‡§≤‡§ò‡•Å‡§ó‡§£‡§ï‡§É (‡§â‡§®‡•ç‡§®‡§§‡§ø (k + j) n))
  ‚àô ‡§è‡§ï-‡§õ‡•á‡§¶‡§É k j n

------------------------------------------------------------------------
-- ‡© ¬ ‡Ø‡‡æ‡∞‡‡‡ ‚î so k cuts return a height-k tower to its base exactly.
--     Ardhaccheda's ‡≤‡ò‡‡ó‡‡ï‡ is k = 1 and its ‡¶‡‡µ‡ø‡ï-‡≤‡ò‡‡ó‡‡ï‡ is k = 2; both
--     are recovered below from the single statement, which is what makes
--     the family an instrument rather than a list.
------------------------------------------------------------------------

‡§Ø‡§•‡§æ‡§∞‡•ç‡§•‡§É : (k n : ‚Ñï) ‚Üí ‡§õ‡•á‡§¶‡§® k (‡§â‡§®‡•ç‡§®‡§§‡§ø k n) ‚â° n
‡§Ø‡§•‡§æ‡§∞‡•ç‡§•‡§É k n =
    cong (Œª z ‚Üí ‡§õ‡•á‡§¶‡§® k (‡§â‡§®‡•ç‡§®‡§§‡§ø z n)) (sym (+-zero k))
  ‚àô ‡§è‡§ï-‡§õ‡•á‡§¶‡§É k 0 n

‡§Ø‡§•‡§æ‡§∞‡•ç‡§•-‡§è‡§ï‡§É : (n : ‚Ñï) ‚Üí ‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶ (‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ n) ‚â° n
‡§Ø‡§•‡§æ‡§∞‡•ç‡§•-‡§è‡§ï‡§É = ‡§Ø‡§•‡§æ‡§∞‡•ç‡§•‡§É 1

‡§Ø‡§•‡§æ‡§∞‡•ç‡§•-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç : (n : ‚Ñï) ‚Üí ‡§µ‡§∞‡•ç‡§ó‡§∂‡§≤‡§æ‡§ï‡§æ (‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ (‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ n)) ‚â° n
‡§Ø‡§•‡§æ‡§∞‡•ç‡§•-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç = ‡§Ø‡§•‡§æ‡§∞‡•ç‡§•‡§É 2

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡Æ‡æ‡‡‡‡ø‡ ‚î AND k CUTS DO NOT REACH THE BASE OF THE NEXT STOREY UP.
--     Spend every one of the k cuts on a tower of height k+1 and what is
--     left is ‡¶‡‡µ‡ø-‡ò‡æ‡ n, still strictly above n.  So the height index is
--     not a description of the tower, it is a separation of it: no fixed
--     number of alk collapses the order above.
--
--     ‡¶‡‡µ‡ø-‡ò‡æ‡-‡µ‡‡¶‡‡ß‡ø‡ (n < 2‚ø, strictly) is the whole content; Ardhaccheda
--     has only the non-strict n ‚â 2‚ø, which is not enough to separate
--     anything, and the strict version is what the orders need.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É : (n : ‚Ñï) ‚Üí n < ‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ n
‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É zero    = 0 , refl
‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É (suc n) = ‚â§-trans (suc-‚â§-suc (‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É n)) ‡§™‡§¶‡§É
  where
  ‡§™‡§¶‡§É : suc (‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ n) ‚â§ ‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ n + ‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ n
  ‡§™‡§¶‡§É = let (x , p) = ‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§-pos n
        in transport (Œª i ‚Üí suc (p (~ i)) ‚â§ p (~ i) + p (~ i))
                     (suc-‚â§-suc ‚â§SumRight)

‡§â‡§®‡•ç‡§®‡§§‡§ø-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É : (k n : ‚Ñï) ‚Üí ‡§â‡§®‡•ç‡§®‡§§‡§ø k n < ‡§â‡§®‡•ç‡§®‡§§‡§ø (suc k) n
‡§â‡§®‡•ç‡§®‡§§‡§ø-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É k n = ‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É (‡§â‡§®‡•ç‡§®‡§§‡§ø k n)

‡§Ö‡§µ‡§∂‡•á‡§∑‡§É : (k n : ‚Ñï) ‚Üí ‡§õ‡•á‡§¶‡§® k (‡§â‡§®‡•ç‡§®‡§§‡§ø (suc k) n) ‚â° ‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§ n
‡§Ö‡§µ‡§∂‡•á‡§∑‡§É k n =
    cong (Œª z ‚Üí ‡§õ‡•á‡§¶‡§® k (‡§â‡§®‡•ç‡§®‡§§‡§ø z n)) (sym (+-comm k 1))
  ‚àô ‡§è‡§ï-‡§õ‡•á‡§¶‡§É k 1 n

‡§Ö‡§∏‡§Æ‡§æ‡§™‡•ç‡§§‡§ø‡§É : (k n : ‚Ñï) ‚Üí n < ‡§õ‡•á‡§¶‡§® k (‡§â‡§®‡•ç‡§®‡§§‡§ø (suc k) n)
‡§Ö‡§∏‡§Æ‡§æ‡§™‡•ç‡§§‡§ø‡§É k n = subst (n <_) (sym (‡§Ö‡§µ‡§∂‡•á‡§∑‡§É k n)) (‡§¶‡•ç‡§µ‡§ø-‡§ò‡§æ‡§§-‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É n)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡ß‡ã‡ó‡æ‡Æ‡ø‡‡‡µ‡Æ‡ ‚î EVERY ALK IS OF THE DESCENDING KIND.
--
--     `Vrddhiksaya_‚¶` splits self-maps of ‚ï by direction and names
--     ‡‡∞‡‡ß‡‡‡‡‡¶ and ‡µ‡∞‡‡ó‡‡≤‡æ‡ï‡æ as the descending examples, but proves the
--     descending theorem only from the property, never that the Jaina
--     operations HAVE it.  They do, and the bound is elementary: the
--     halving-count of suc n is at most n, because each recursive step
--     spends one unit of the count against a halving of the argument.
------------------------------------------------------------------------

‡§Ö‡§∞‡•ç‡§ß-‚â§ : (m : ‚Ñï) ‚Üí ‡§Ö‡§∞‡•ç‡§ß m ‚â§ m
‡§Ö‡§∞‡•ç‡§ß-‚â§ zero          = zero-‚â§
‡§Ö‡§∞‡•ç‡§ß-‚â§ (suc zero)    = zero-‚â§
‡§Ö‡§∞‡•ç‡§ß-‚â§ (suc (suc m)) = ‚â§-suc (suc-‚â§-suc (‡§Ö‡§∞‡•ç‡§ß-‚â§ m))

‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶-‡§∏‡•Ä‡§Æ‡§æ : (f n : ‚Ñï) ‚Üí ‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶ f (suc n) ‚â§ n
‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶-‡§∏‡•Ä‡§Æ‡§æ zero    n       = zero-‚â§
‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶-‡§∏‡•Ä‡§Æ‡§æ (suc f) zero    = zero-‚â§
‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶-‡§∏‡•Ä‡§Æ‡§æ (suc f) (suc n) =
  ‚â§-trans (suc-‚â§-suc (‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶-‡§∏‡•Ä‡§Æ‡§æ f (‡§Ö‡§∞‡•ç‡§ß n)))
          (suc-‚â§-suc (‡§Ö‡§∞‡•ç‡§ß-‚â§ n))

‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä : ‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä ‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶
‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä n = suc-‚â§-suc (‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶-‡§∏‡•Ä‡§Æ‡§æ (suc n) n)

‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‚â§ : (m : ‚Ñï) ‚Üí ‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶ m ‚â§ m
‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‚â§ zero    = zero-‚â§
‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‚â§ (suc n) = <-weaken (‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä n)

‡§õ‡•á‡§¶‡§®-‚â§ : (k m : ‚Ñï) ‚Üí ‡§õ‡•á‡§¶‡§® k m ‚â§ m
‡§õ‡•á‡§¶‡§®-‚â§ zero    m = 0 , refl
‡§õ‡•á‡§¶‡§®-‚â§ (suc k) m = ‚â§-trans (‡§õ‡•á‡§¶‡§®-‚â§ k (‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶ m)) (‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‚â§ m)

-- the uniform statement: cut once or a thousand times, it descends.
‡§õ‡•á‡§¶‡§®-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä : (k : ‚Ñï) ‚Üí ‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä (‡§õ‡•á‡§¶‡§® (suc k))
‡§õ‡•á‡§¶‡§®-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä k n =
  ‚â§<-trans (‡§õ‡•á‡§¶‡§®-‚â§ k (‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶ (suc n))) (‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä n)

‡§µ‡§∞‡•ç‡§ó‡§∂‡§≤‡§æ‡§ï‡§æ-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä : ‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä ‡§µ‡§∞‡•ç‡§ó‡§∂‡§≤‡§æ‡§ï‡§æ
‡§µ‡§∞‡•ç‡§ó‡§∂‡§≤‡§æ‡§ï‡§æ-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä = ‡§õ‡•á‡§¶‡§®-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä 1

------------------------------------------------------------------------
-- ‡ ¬ ‡® ‡ä‡∞‡‡ß‡‡µ‡ó‡æ‡Æ‡ ‚î and therefore no alk ascends.  Read with ¬ß‡ this is
--     the shape of the whole thing: the INSTRUMENT descends and exhausts,
--     while the magnitudes it is pointed at ascend past every fixed number
--     of applications of it.  Which is why the orders are graded by the
--     instrument and not measured by it.
------------------------------------------------------------------------

‡§®-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä : (k : ‚Ñï) ‚Üí ¬¨ (‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä (‡§õ‡•á‡§¶‡§® (suc k)))
‡§®-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä k up = ‡§®-‡§â‡§≠‡§Ø‡§Æ‡•ç up (‡§õ‡•á‡§¶‡§®-‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä k)

‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‡§®-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä : ¬¨ (‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä ‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶)
‡§Ö‡§∞‡•ç‡§ß‡§ö‡•ç‡§õ‡•á‡§¶-‡§®-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä = ‡§®-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä 0
