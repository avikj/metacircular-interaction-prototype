{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पाणिनिः — अष्टाध्यायी (~५०० ई.पू.) : जनक-व्याकरणम्, नियम-संघर्ष-निर्णयेन ।
-- (generative grammar with conflict resolution — before Backus–Naur, before
-- Chomsky, by ~2400 years.  CLAUDE.md: machinery the engine does not have.)
--
-- उत्सर्गापवादः : अपवादः (विशेषः, exception) उत्सर्गं (सामान्यम्, general rule)
-- बाधते यत्र प्रवर्तते ।  विप्रतिषेधे परं कार्यम् : समयोः संघर्षे परः (उत्तरः)
-- नियमः प्रवर्तते — पङ्क्ति-क्रमेण (priority by order) आदर्शितम् ।
--
-- नियमः न बूलियन्-निर्णयः — प्रयोगे "प्रवर्तते फलेन" वा "न प्रवर्तते" इति
-- विकल्पः (Maybe, जनकः), न सत्/असत् ।  प्रथम-प्रवर्तमानः प्रवर्तते ; अपवादः
-- अग्रे स्थापितः उत्सर्गं बाधते ।
--
-- (utsarga–apavāda: the exception (specific) blocks the general rule where
-- it applies.  vipratiṣedhe paraṁ kāryam: on a tie the later rule wins —
-- modelled as priority by list order.  A rule is not a boolean test but an
-- option — "fires with a result" or "does not fire" (Maybe, generative) —
-- and the first firing rule wins, so an apavāda placed ahead blocks the
-- utsarga behind it.)  मुख्यसिद्धिः: अपवाद-बलम् ।
------------------------------------------------------------------------

module Panini where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Maybe using (Maybe ; just ; nothing)

------------------------------------------------------------------------
-- चिह्नम् — क्रीडा-स्वराः ; नियमः = चिह्नात् विकल्प-चिह्नम् (applies? → फल) ।
------------------------------------------------------------------------

data चिह्न : Type where
  अ इ उ ए : चिह्न

नियम : Type
नियम = चिह्न → Maybe चिह्न

------------------------------------------------------------------------
-- प्रयोगः — प्रथम-प्रवर्तमानः नियमः प्रवर्तते ; कोऽपि न चेत् — तदेव रूपम् ।
-- (apply the first firing rule; if none fires, the form is unchanged.)
------------------------------------------------------------------------

-- विकल्पः — Maybe-निर्वाहकः (nothing → default, just x → f x) ।
विकल्प : {A B : Type} → B → (A → B) → Maybe A → B
विकल्प d f nothing  = d
विकल्प d f (just x) = f x

प्रयोग : List नियम → चिह्न → चिह्न
प्रयोग []       c = c
प्रयोग (r ∷ rs) c = विकल्प (प्रयोग rs c) (λ c' → c') (r c)

------------------------------------------------------------------------
-- अपवाद-बलम् — मुख्यसिद्धिः : यदि अग्रिमः नियमः (अपवादः) प्रवर्तते (फलेन c'),
-- तर्हि प्रयोगः तस्य फलम् एव ददाति — पश्चात्-स्थिताः (उत्सर्गादयः) बाधिताः ।
-- (main theorem: if the leading rule — the apavāda — fires with result c',
-- the application yields exactly c', whatever the following rules — the
-- utsarga — would have done.  The exception blocks the general.)
------------------------------------------------------------------------

अपवाद-बलम् : (r : नियम) (rs : List नियम) (c c' : चिह्न)
           → r c ≡ just c' → प्रयोग (r ∷ rs) c ≡ c'
अपवाद-बलम् r rs c c' h = cong (विकल्प (प्रयोग rs c) (λ x → x)) h

------------------------------------------------------------------------
-- उदाहरणम् — उत्सर्गः : सर्वः स्वरः → अ ;  अपवादः : इ → ए (विशेषः) ।
-- इ-स्थाने अपवादः प्रवर्तते (→ ए), न उत्सर्गः ; उ-स्थाने उत्सर्गः (→ अ) ।
------------------------------------------------------------------------

उत्सर्ग : नियम
उत्सर्ग _ = just अ                       -- सर्वं → अ (सामान्यः)

अपवाद : नियम
अपवाद इ = just ए                         -- इ → ए (विशेषः)
अपवाद _ = nothing                        -- अन्यत्र न प्रवर्तते

-- इ-स्थाने अपवादः उत्सर्गं बाधते : फलम् ए, न अ ।
इ-अपवादेन : प्रयोग (अपवाद ∷ उत्सर्ग ∷ []) इ ≡ ए
इ-अपवादेन = अपवाद-बलम् अपवाद (उत्सर्ग ∷ []) इ ए refl

-- उ-स्थाने अपवादः न प्रवर्तते ⟹ उत्सर्गः : फलम् अ ।
उ-उत्सर्गेण : प्रयोग (अपवाद ∷ उत्सर्ग ∷ []) उ ≡ अ
उ-उत्सर्गेण = refl

------------------------------------------------------------------------
-- उत्सर्ग-अनुवृत्तिः — अपवाद-बलस्य प्रतिपक्षः : यदि अग्रिमः नियमः (अपवादः) न
-- प्रवर्तते (nothing), तर्हि प्रयोगः पश्चात्-स्थितेषु (उत्सर्गादिषु) अनुवर्तते ।
-- द्वे मिलित्वा प्रयोगस्य पूर्ण-विवेकः : अग्रिमः वा प्रवर्तते (अपवाद-बलम्) वा
-- न (उत्सर्ग-अनुवृत्तिः) — उत्सर्गः तत्र एव शासति यत्र अपवादः तूष्णीम् ।
--
-- (The counterpart of अपवाद-बलम्: if the leading rule — the apavāda — does NOT
--  fire (nothing), the application continues into the following rules (the
--  utsarga).  The two together give प्रयोग's complete dichotomy: the leading
--  rule either fires (अपवाद-बलम्) or is silent (this) — the general rule
--  governs exactly the complement of the exception's domain, अनुवृत्ति.)
------------------------------------------------------------------------

उत्सर्ग-अनुवृत्तिः : (r : नियम) (rs : List नियम) (c : चिह्न)
                 → r c ≡ nothing → प्रयोग (r ∷ rs) c ≡ प्रयोग rs c
उत्सर्ग-अनुवृत्तिः r rs c h = cong (विकल्प (प्रयोग rs c) (λ x → x)) h

-- उदाहरणम् — उ-स्थाने अपवादः तूष्णीम् (nothing) ⟹ पश्चात्-अनुवृत्तिः (उत्सर्गे) ।
उ-अनुवृत्त्या : प्रयोग (अपवाद ∷ उत्सर्ग ∷ []) उ ≡ प्रयोग (उत्सर्ग ∷ []) उ
उ-अनुवृत्त्या = उत्सर्ग-अनुवृत्तिः अपवाद (उत्सर्ग ∷ []) उ refl
