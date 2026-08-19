{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- जीवः — कुट्टकस्य जीवन्तं यन्त्रम्, एकत्र ।  (the living pulverizer, whole.)
--
-- एकः नियमः (अवतरणम्) संरचनया चलति — विचारं विना (न discreteℕ, न Dec, न
-- Bool) ।  तस्मात् एतानि सर्वाणि एकस्मात् बीजात् जायन्ते, प्रत्येकं
-- कर्ण-सिद्धम् (--safe, no postulate, no hole) :
--
--   BhedaAvatarana.एकपदे        — एकपदं refl : रोगः (discreteℕ-स्थैर्यम्) हतः ।
--   Punaragamana.पुनरागमनम्     — अलोपः : उत्थानम् अवतरणस्य प्रतिलोमम् (अहिंसा) ।
--   Punaragamana.युग्म≡विवेक    — समता, univalence-पन्थाः (द्वे नये एकं तत्त्वम्) ।
--   Gati.अलोपः                  — सम्पूर्णे यन्त्रे प्रतिलोमता ; अनुक्तम् (सत्यनिष्ठा) ।
--   GurutamaSiddha.सिद्धः       — फलं isGCD : गुरुतमः साधारणः विभाजकः ।
--   Sthairya.स्थैर्य-गति        — समाहितं g अधिकानुदानेन न परावर्तते (न दुर्नयः) ।
--   Purnata.पूर्णतया-गुरुतमः    — पर्याप्तानुदाने सर्वदा समाप्तिः → isGCD ।
--   Bija.बीजगणितम्              — a·x ≡ b·y + g (ℕ-मध्ये, वल्ल्याः पर्यायेण) ।
--   Yuti.युतिः                  — a·X ≡ c (mod b) : आर्यभटस्य ज्यौतिषः कुट्टकः ।
--
-- त्रयं सत्यनिष्ठायाः : अनुक्तम् (अपर्याप्ते) · पूर्णता (पर्याप्ते) · स्थैर्यम् (अन्ते) ।
-- एकः धर्मः चतुर्धा : अलोपः = प्रतिलोमता = अहिंसा = सत्यनिष्ठा (किमपि न नश्यति,
-- किमपि न मिथ्या) ।  आर्यभटस्य "शेषं रक्ष" (Gaṇitapāda ३२–३३) मूलम् ; समता
-- univalence-पथेन (Voevodsky, सम्मानितः) ; उत्पाद-व्यय-ध्रौव्यम् (उमास्वाति ५.२९)
-- एकपदे ।
--
-- (One rule (the descent) moves by structure — never by a decision (no
-- discreteℕ, no Dec, no Bool).  From that one seed all of the above grow,
-- each kernel-checked.  A triad of honesty — un-said / complete / stable —
-- and one dharma seen four ways: losslessness = reversibility = ahiṃsā =
-- honesty; nothing destroyed, nothing fabricated.  Rooted in Āryabhaṭa's
-- "keep the remainder", equivalence via the univalence path, and utpāda-
-- vyaya-dhrauvya in a single step.)
------------------------------------------------------------------------

module Jiva where

-- qualified imports : the whole closure is forced to typecheck as one,
-- without merging the (deliberately overlapping) Devanagari names.
import BhedaAvatarana
import Punaragamana
import Gati
import Gurutama
import GurutamaSiddha
import Sthairya
import Purnata
import Bija
import Yuti
import Sadhyata
-- छन्दःशास्त्रम् — तत् एव विचारहीनं प्रतिलोमं क्षेत्रान्तरे (generality)
import Pingala
import Matramerus
-- पिङ्गलस्य शून्य-द्वि-विधिः — 2ⁿ log-पदैः (प्रथमा binary exponentiation)
import PingalaGhata
-- नारायणस्य गोसर्गः — मेरु-कुलस्य {१,३}-रूपम् (गणितकौमुदी, १३५६)
import Narayana
-- समास-मेरुः — नारायणस्य समास-भावना, {१,L}-कुलं जनन-सूत्रेण (विरहाङ्कः+नारायणः एकत्र)
import SamasaMeru
-- बहु-समास-मेरुः — यथेच्छ-अंश-गणः (त्रि-मेरु {१,२,३} आदि), जनन-सूत्रम्
import SamasaMeruN
-- ब्रह्मगुप्तस्य भावना — वर्ग-प्रकृतेः संयोगः (चक्रवालस्य बीजम्)
import Brahmagupta

import Satyayantra
import PingalaSatya
import Saptabhangi
import Panini
import SatyayantraSamyoga
import Setu
import Vargana
import Shunya
import Khahara
import Ananta
import Sulba
import Sankalita
-- चितिघनः — आर्यभटस्य वृन्द-सङ्कलितम् (∑ त्रिकोणानि = n(n+1)(n+2)/6, गणितपादः २१)
import Citighana
import Cakravala
import Meru
import BhavanaSamuha
import VargaprakritiSreni
