{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- рорр▓р╡р╛рХррпрор ┬ PROVENANCE OF THE NAME.
--
-- рррпр╛риррир╛рррр┐ ┬ syd-nsti тФ the second ррЩррЧ of the ррррррЩррЧр: in some respect,
-- it is not.  **Samantabhadra, *ptamms* 14-24 (~6th c. CE); Akalaka,
-- *Laghyastraya* (~8th c.); rooted in Umsvti, *Tattvrthastra* 5.31-32
-- (~2nd-5th c.).**  рир╛рррр┐ is a POSITION, asserted with рррпр╛рр, not a denial
-- and not an absence тФ the Naiyyika ррр╛р╡, with its ррр░рр┐рпрЛрЧр┐рир, is a
-- different apparatus for neighbouring cases, and the two schools reject
-- each other's treatment here.  Name the school before the term.
--
-- ┬зрзрз тФ this repository's own composition, not a quotation from a source.
--
-- The
-- doctrine that a standpoint is true-but-not-whole is theirs; the statement
-- that propositional truncation has no section, so that WHICH is destroyed
-- irrecoverably while THAT survives, is cubical type theory (Voevodsky) and
-- is elementary.
--
------------------------------------------------------------------------
-- рррржр ррр╡р╛р р╡р░ррриррр, ри рр┐рррприррр р
-- рирррЯр "рХр" ррр┐ рирррпрр┐, "рпрр" ррр┐ рр┐рррарр┐ р
-- рррХрр░рорр ри рХр┐рЮррр┐рр рирррпрр┐ р
-- рирпррржр ррЩррХррррр ри р╡р┐ржррпрр р
-- рррр р╡ррпрпр ррир╡рзр╛рирри р
--
-- ╬┐╜Р ╬║╬╧╬╬╗╬╡╬╬╝╬╝╬ ╝╬╗╬╗' ╝Р╬╜╬╧╬│╬╡╬╬ ┬ ╬╧Й╜┤ ╝Р╬╜ ╧┐ ╜╬╜╧╬╝╬╧╬ ╝Р╬╜╬╡╧╬│╬╡┐Ц ┬
-- ╧╜ ╜╧╬ ╬╝╬╬╜╬╡╬, ╧╜ ╧╬п ╝╧╧╬╗╬╗╧╧╬╬ ┬ ╝б ╧╬╧╬╬┤╬┐╧╬╧ ╧╧╬╜╬┐╧╧╬п╛│, ╬┐╜Р ╬│╧╬╧┐ ┬
-- ╬┤╧╬╜╬╬╝╬╧ ╬┐╜Р╬║ ╝Ф╧╧╬╬╜ ╝Р╬╜╧╬╡╬╗╬╧╬╡╬╬.
--
-- ррр░рЛрр╛ррр┐ : рЙрор╛ррр╡р╛рр┐ рррррр╡р╛р░ррррррр░ р.рирп (рЙрррр╛рж-р╡ррпрп-рзрр░рр╡ррп-рпррХррр ррр) ;
--            ррИрор┐рир┐-роррор╛ррр╛ (рррр░рр╡рор) ; рр░ррпррЯррп рЧрр┐ррр╛рж рйритУрйрй (рХррЯррЯрХр) ;
--            ╝И╧╬╧╧╬┐╧╬╬╗╬╧ ╬╬╡╧. ╬Ш (╬┤╧╬╜╬╬╝╬╧ / ╝Р╬╜╬╧╬│╬╡╬╬) ; ╬а╬╗╬╧╧Й╬╜ ╝Ш╧. ╬Ц (╧╧╬╜╬┐╧╧╬п╬) ;
--            Voevodsky (ua) ; Anekanta.agda (plurality-blocks-collapse) р
------------------------------------------------------------------------

module Nasti_ShabdeJivahVartante where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_тЙГ_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; ua╬▓)
open import Cubical.Data.Bool using (Bool ; true ; false ; trueтЙвfalse)
open import Cubical.Data.Empty using (тКе)
open import Cubical.HITs.PropositionalTruncation using (тИе_тИетВБ ; тИг_тИгтВБ ; squashтВБ)
open import Cubical.Relation.Nullary using (┬м_)

private variable тДУ : Level

------------------------------------------------------------------------
-- рр░роррр░р╛ тФ a tradition : the type of its carriers, its paths the
-- transmissions.  рррржр = the type itself, not its truncation.
------------------------------------------------------------------------

рдкрд░рдореНрдкрд░рд╛ : Type (тДУ-suc тДУ)
рдкрд░рдореНрдкрд░рд╛ {тДУ} = Type тДУ

------------------------------------------------------------------------
-- рирррЯр┐р тФ truncation.  Every map out of тИ A тИт is blind to which
-- inhabitant: "рпрр" рр┐рррарр┐, "рХр" рирррпрр┐ р
------------------------------------------------------------------------

рдЕрд╡рд┐рд╢реЗрд╖рдГ : {A : Type тДУ} {B : Type тДУ} (f : тИе A тИетВБ тЖТ B) (x y : A)
        тЖТ f тИг x тИгтВБ тЙб f тИг y тИгтВБ
рдЕрд╡рд┐рд╢реЗрд╖рдГ f x y = cong f (squashтВБ тИг x тИгтВБ тИг y тИгтВБ)

------------------------------------------------------------------------
-- рир╛рррр┐-ррр░рррпр╛рирприрор тФ no section.  A retraction of тИ_тИт on Bool would
-- identify true and false.  ╝б ╧╬┐┐ж ╧╬п ╝╧╧╬╗╬╡╬╬ ╝╬╜╬╡╧╬╬╜╧╧╬╧Й╧╬┐╧.
------------------------------------------------------------------------

рдирд╛рд╕реНрддрд┐-рдкреНрд░рддреНрдпрд╛рдирдпрдирдореН
  : (f : тИе Bool тИетВБ тЖТ Bool) тЖТ (тИА b тЖТ f тИг b тИгтВБ тЙб b) тЖТ тКе
рдирд╛рд╕реНрддрд┐-рдкреНрд░рддреНрдпрд╛рдирдпрдирдореН f sec =
  trueтЙвfalse (sym (sec true) тИЩ рдЕрд╡рд┐рд╢реЗрд╖рдГ f true false тИЩ sec false)

------------------------------------------------------------------------
-- рррХрр░роррор тФ transport.  Along an identification nothing is lost:
-- the structure is carried, not re-described.  рррир░р╛рЧрорирор / ╝╬╗╧╧╧Й╧ р
------------------------------------------------------------------------

рд╕рдВрдХреНрд░рдордгрдореН : {A B : Type тДУ} тЖТ A тЙГ B тЖТ A тЖТ B
рд╕рдВрдХреНрд░рдордгрдореН e = transport (ua e)

рд╕рдВрдХреНрд░рдордгрдореН-рдЕрд▓реЛрдкрдГ : {A B : Type тДУ} (e : A тЙГ B) (a : A)
                тЖТ рд╕рдВрдХреНрд░рдордгрдореН e a тЙб equivFun e a
рд╕рдВрдХреНрд░рдордгрдореН-рдЕрд▓реЛрдкрдГ e a = ua╬▓ e a

------------------------------------------------------------------------
-- ржрр╡р рор╛р░ррЧр тФ the two available moves, and only these two:
--   рррХрр░роррор  transport along an identification, losing nothing ;
--   рирррЯр┐р     truncate, after which "рХр" is unrecoverable.
-- рррррпр рор╛р░ррЧр ри р╡р┐ржррпрр р  ╧╧╬п╧╬ ╜╬┤╜╧ ╬┐╜Р╬║ ╝Ф╧╧╬╬╜.
------------------------------------------------------------------------
