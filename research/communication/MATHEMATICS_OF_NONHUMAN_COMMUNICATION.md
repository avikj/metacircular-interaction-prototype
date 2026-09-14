# Mathematical and computational analysis of non-human communication — survey by construct (2026-09-14)

*Compiled by web survey for `research/NONHUMAN_COMMUNICATION_20260914.md`. Verification marks are the surveyor's: **[v]** confirmed via search this session, **[r]** recalled (re-check the DOI before citing), **[?]** unconfirmed. Publisher domains were egress-blocked from the compiling container, so verification relied on search-index metadata. Section 9 (what the mathematics licenses) is the part the corpus mapping in the parent document leans on.*

Below is the survey. Web-search budget was exhausted and most publisher domains were egress-blocked for direct fetching, so verification status is marked per entry: **[v]** = bibliographic details confirmed via search this session; **[r]** = recalled from training knowledge (details believed correct, but re-check DOI before citing); **[?]** = existence/attribution could not be confirmed.

---

# Mathematical and computational analysis of non-human communication: a survey organised by mathematical construct

## 0. Scope and reading guide

The literature splits into eight mathematical "constructs": (1) information-theoretic statistics of symbol sequences; (2) formal-language / syntactic descriptions; (3) probabilistic sequence models and learned representations; (4) alignment/translation mathematics imported from NLP; (5) compression, algorithmic information, and the grounding problem; (6) geometric/topological/categorical descriptions of signal spaces; (7) symbolic dynamics and computational mechanics; (8) statistical learning and unsupervised segmentation. A final section states, per method, what the mathematics does and does not license.

Almost everything below is animal (birds, cetaceans, primates, bats, hyraxes, rodents). Plant/fungal work exists only at the edge of scope (e.g. Adamatzky's Lempel–Ziv/entropy analyses of fungal electrical spiking, §7), and is noted where it exists; there is no plant/fungal literature using Zipf, formal-language, or embedding-alignment methods.

---

## 1. Information theory: Zipf, Zipf–Mandelbrot, Menzerath–Altmann, brevity, entropy rate, mutual-information decay

### 1.1 Mathematical objects
- **Zipf rank–frequency law**: f(r) ∝ r^(−α); **Zipf–Mandelbrot**: f(r) ∝ (r + β)^(−α). Fitted on log–log rank plots (early work) or by maximum likelihood with model comparison (later work).
- **Zipf's law of abbreviation (brevity)**: negative correlation between token frequency and token duration/length (Spearman/Kendall τ, or regression with phylogenetic/individual random effects).
- **Menzerath–Altmann law**: y = a x^b e^(−cx), or in animal work simply a negative correlation between construct size (number of constituents) and mean constituent size (duration).
- **Shannon entropy hierarchy**: zeroth-order H₀ = log|A|, first-order H₁ = −Σp log p, conditional entropies H_n = H(X_t | X_{t−n+1..t−1}); the **entropy rate** h = lim H_n and its estimators (Lempel–Ziv, Nemenman–Shafee–Bialek, block-entropy extrapolation).
- **Mutual information as a function of lag**: I(d) = I(X_t; X_{t+d}), with model comparison between exponential decay (Markov), power-law decay (hierarchical/context-free-like), and composite.

### 1.2 Papers

| Ref | Mathematical object | Data / claim | Venue / ID |
|---|---|---|---|
| McCowan, Hanser & Doyle 1999 | Zipf slope on log rank vs log frequency of whistle types; Shannon entropy orders H₀–H₃ | Bottlenose dolphin whistles; adult slope ≈ −0.95 "like human language"; infants' slope flattens then steepens with development | *Animal Behaviour* 57:409–419, doi:10.1006/anbe.1998.1000 [r] |
| McCowan, Doyle & Hanser 2002 | Entropic orders as a "repertoire complexity" index | Compares dolphins, squirrel monkeys, humans | *J. Comp. Psychol.* 116:166–172, doi:10.1037/0735-7036.116.2.166 [r] |
| McCowan, Doyle, Jenkins & Hanser 2005 | Defence of Zipf slope as *screening* statistic, not proof of language | Reply to Suzuki et al. | *Animal Behaviour* 69:F1–F7, doi:10.1016/j.anbehav.2004.09.002 [r] |
| Suzuki, Buck & Tyack 2005 | Shows Zipf slope ≈ −1 is produced by many non-linguistic processes (e.g. random-typing "monkey" models, finite-sample artefacts); slope is not diagnostic | Critique of McCowan | *Animal Behaviour* 69:F9–F17, doi:10.1016/j.anbehav.2004.08.004 [r] |
| Suzuki, Buck & Tyack 2006 | Entropy-rate estimation (Lempel–Ziv-style and block-entropy estimators) plus autocorrelation on symbolised humpback song; first-order Markov vs hierarchical models | Humpback song (Hawaii); ~0.6 bits/unit; evidence of hierarchical structure beyond first-order Markov; average information rate is low compared with human language | *JASA* 119:1849–1866, doi:10.1121/1.2161827 [v] |
| Miksis-Olds, Buck, Noad, Cato & Stokes 2008 | Same entropy estimators across 48 song sessions | Australian humpbacks; entropy stable across weeks, structure comparable to Hawaiian population | *JASA* 124:2385–2393, doi:10.1121/1.2967863 [v] |
| Doyle, McCowan, Hanser, Chyba, Bucci & Blue 2008 | Zipf slopes and conditional entropies as indices of noise response | Alaskan humpbacks under vessel noise | *Entropy* 10:33–46, doi:10.3390/entropy-e10020033 [r] |
| Doyle, McCowan, Johnston & Hanser 2011 | Program statement: Zipf + entropic "information complexity" as a species-independent yardstick, proposed for SETI signal triage | Argues these measures order dolphin/squirrel-monkey/human repertoires | *Acta Astronautica* 68:406–417, doi:10.1016/j.actaastro.2009.11.018 [r] |
| Ferrer-i-Cancho & McCowan 2009 | Correlation between whistle-type frequency and the number of behavioural contexts significantly associated with it (a "meaning–frequency" law analogue) | Dolphin whistles; frequency grows with number of contexts | *Entropy* 11:688–701, doi:10.3390/e11040688 [v] |
| Ferrer-i-Cancho & McCowan 2012 | Span of correlations (mutual-information vs lag; comparison with random shuffles) | Dolphin whistle sequences show correlations beyond adjacent pairs | *J. Stat. Mech.* P06002; arXiv:1205.0321 [v] |
| Ferrer-i-Cancho & Lusseau 2009 | Law of brevity applied to behavioural (non-vocal) units | Dolphin surface behaviour patterns follow brevity | *Complexity* 14(5):23–25, doi:10.1002/cplx.20266 [r] |
| Ferrer-i-Cancho, Hernández-Fernández, Lusseau, Agoramoorthy, Hsu & Semple 2013 | Brevity as consequence of minimising mean code length ("compression principle"); mathematical framework with expected length L = Σ p_i l_i | Argues brevity is a universal of behaviour under compression pressure, not language-specific | *Cognitive Science* 37:1565–1578, doi:10.1111/cogs.12061; arXiv:1303.6175 [v] |
| Ferrer-i-Cancho & Hernández-Fernández 2013 | Statistical caveats for brevity tests (unit of analysis, mean vs raw durations) | Failure of brevity in two New World primates when raw durations used | *Glottotheory* 4:45–55 [r] |
| Corral, Boleda & Ferrer-i-Cancho 2015 | ML fitting of Zipf and Zipf–Mandelbrot to word forms vs lemmas; shows exponent depends on unit choice | Human text, but the methodological point (unit choice changes the law) is the one imported into animal debates | *PLoS ONE* 10:e0129031, doi:10.1371/journal.pone.0129031 [r] |
| Semple, Hsu & Agoramoorthy 2010 | Brevity: rank correlation between call-type duration and utterance rate | Formosan macaque repertoire follows brevity | *Biology Letters* 6:469–471, doi:10.1098/rsbl.2009.1062 [v pages / r DOI] |
| Semple, Hsu, Agoramoorthy & Ferrer-i-Cancho 2013 | Brevity robust to using raw (not mean) durations | Macaques | *J. Quant. Linguistics* 20:209–217; arXiv:1207.3169 [v] |
| Gustison, Semple, Ferrer-i-Cancho & Bergman 2016 | Menzerath: negative correlation of sequence length (calls) with mean call duration, with individual random effects | Wild gelada male sequences; first non-human Menzerath report | *PNAS* 113:E2750–E2758, doi:10.1073/pnas.1522072113 [v] |
| Heesen, Hobaiter, Ferrer-i-Cancho & Semple 2019 | Menzerath + brevity on gesture sequences (duration as length) | Chimpanzee play gestures obey Menzerath; brevity fails (a rare documented failure) | *Proc. R. Soc. B* 286:20182900, doi:10.1098/rspb.2018.2900 [v] |
| Heesen et al. 2022 | Same laws in sexual-solicitation gestures; mixed results | "Variable expression of linguistic laws in ape gesture" | bioRxiv 2021.05.19.444810; PMC9653249 [v] |
| Huang, Ma, Ma, Garber & Fan 2020 | Brevity + Menzerath in gibbon loud calls | Both laws hold in male morning calls | *Animal Behaviour* 160:145–155 [v title / r details] |
| Clink, Ahmad & Klinck 2020 | Menzerath tested at multiple units; largely fails | "Adherence to Menzerath's law is the exception (not the rule)" in three duetting primates | *R. Soc. Open Sci.* 7:201557, doi:10.1098/rsos.201557 [v] |
| Clink & Lau 2020 | Brevity depends on unit of analysis (note vs phrase) in gibbons | "Brevity is not a universal" | *R. Soc. Open Sci.* 7:200151, doi:10.1098/rsos.200151 [v] |
| Demartsev et al. 2019 | Brevity with amplitude rather than duration as cost | Rock hyrax: males follow brevity, females not; cost is amplitude | *Evolution Letters* 3:623–634 [v title / r venue] |
| Favaro et al. 2020 | Brevity + Menzerath in penguin display songs | African penguins conform | *Biology Letters* 16:20190589 [r] |
| Kershenbaum et al. 2021 | Shannon entropy of the type distribution as a *robust estimator* of Zipf-like skew, avoiding rank-plot regression artefacts | Methods paper for repertoires | *Methods Ecol. Evol.* 12:553–564, doi:10.1111/2041-210X.13536 [v] |
| Youngblood 2024 | Brevity + Menzerath + sequential "small-world" network metrics in house finch song | Language-like efficiency in house finch | *Proc. R. Soc. B* 291:20240250 [v] |
| Youngblood 2025 | Bayesian mixed models of Menzerath and brevity across 16 cetacean species vs 51 human languages (>610,000 elements, 24 studies) | 11/16 species show Menzerath (some larger effects than speech); 2/5 with typed elements show brevity | *Science Advances* 11:eads6014, doi:10.1126/sciadv.ads6014 [v] |
| Lewis et al. 2023–24 | Menzerath yes, brevity no, in Java sparrow song | — | bioRxiv 2023.12.13.571437 [v] |
| Arnon, Kirby, Allen, Garrigue, Carroll & Garland 2025 | Transitional-probability (TP) dips to segment continuous song into "subsequences"; then rank–frequency of segmented units fits Zipf (α ≈ −1) and units show brevity | 8 years of New Caledonian humpback song; argues Zipfian distribution emerges from cultural transmission + learnability, not from language per se | *Science* 387:649–653, doi:10.1126/science.adq7055 [v] |
| Kershenbaum et al. 2016 (tutorial) | Full menu: Markov chains, HMMs, entropy rate, Zipf, network measures, edit distances; explicit guidance on Markov-order estimation and sample-size bias | Consensus tutorial from a NIMBioS working group | *Biological Reviews* 91:13–52, doi:10.1111/brv.12160 [r] |
| Kershenbaum 2014 | Entropy rate as vocal-complexity measure, with bias correction | — | *Animal Behaviour* [v title / r venue] |
| Sainburg, Theilman, Thielk & Gentner 2019 | I(d) between elements at lag d; fits exponential (Markov), power-law (hierarchical), and combined models with AIC | Bengalese finch, starling, Cassin's vireo, California thrasher + speech corpora: composite exponential + power-law fits best in both, i.e. Markov at short range, hierarchical at long range | *Nature Communications* 10:3636, doi:10.1038/s41467-019-11605-y [v] |
| Lin & Tegmark 2017 | Theorem: Markov processes give exponentially decaying I(d); probabilistic context-free grammars give power-law decay | Theoretical basis used by Sainburg 2019 | *Entropy* 19:299, doi:10.3390/e19070299 [r] |
| Allen, Garland, Dunlop & Noad 2019 | Directed network of unit transitions; entropy, clustering, small-world metrics | Humpback song networks show non-random syntactic structure and change across song revolutions | *Proc. R. Soc. B* 286:20192014, doi:10.1098/rspb.2019.2014 [v] |
| Sasahara, Cody, Cohen & Taylor 2012 | Song as directed network; small-world statistics, motif analysis | California thrasher; "structural design principles" | *PLoS ONE* 7:e44436 [v] |
| Coen 2005 / 2007 | Cross-modal clustering (self-supervised co-clustering across modalities); self-supervised acquisition of zebra-finch song via articulatory synthesiser | AAAI papers; methodological precursor to self-supervised unit discovery | AAAI 2005 "Cross-modal clustering"; AAAI 2007 "Learning to sing like a bird" [v] |

Related: Ferrer-i-Cancho & Hernández-Fernández 2018 *JASIST* 69:1369 ("The origins of Zipf's meaning-frequency law") [v]; Ferrer-i-Cancho 2005 *Eur. Phys. J. B* 47:449 ("Zipf's law from a communicative phase transition") [r]; Kirby, Cornish & Smith 2008 *PNAS* 105:10681 (iterated learning produces compressible, structured languages — the mechanism Arnon 2025 invokes) [r].

---

## 2. Formal language theory and syntax

### 2.1 Mathematical objects
- Chomsky hierarchy: regular (finite-state) vs context-free (e.g. AⁿBⁿ) vs mildly context-sensitive.
- Sub-regular hierarchy (strictly local, strictly piecewise, locally testable) — the level at which most "grammar" results actually sit (Jäger & Rogers 2012).
- **k-reversible finite automata** (Angluin 1982, *JACM* 29:741): a class learnable in the limit from positive data only; Berwick et al. 2011 argue birdsong grammars fall in this class.
- **Partially observable Markov model (POMM)** / HMM with many-to-one state→syllable map.
- Compositionality tests: (i) meaning(AB) ≠ meaning(A) ∪ meaning(B) trivially? (ii) "trivial" (conjunction/union) vs "non-trivial" (one element modifies the other) compositionality; (iii) ordering effects (AB ≠ BA); (iv) playback with artificial reversed/novel sequences.

### 2.2 Artificial grammar learning (AGL) experiments

| Ref | Object | Claim | Venue / ID |
|---|---|---|---|
| Fitch & Hauser 2004 | (AB)ⁿ (finite-state) vs AⁿBⁿ (context-free) | Cotton-top tamarins discriminate violations of (AB)ⁿ but not AⁿBⁿ | *Science* 303:377–380, doi:10.1126/science.1089401 [r] |
| Gentner, Fenn, Margoliash & Nusbaum 2006 | AⁿBⁿ, n≤4, operant go/no-go | European starlings learn AⁿBⁿ; interpreted as recursive/context-free competence | *Nature* 440:1204–1207, doi:10.1038/nature04675 [r] |
| van Heijningen, de Visser, Zuidema & ten Cate 2009 | Same paradigm, zebra finches; individual strategy analysis | Birds solve it via simpler local (bigram/positional) cues — "simple rules can explain discrimination" | *PNAS* 106:20538–20543, doi:10.1073/pnas.0908113106 [r] |
| Abe & Watanabe 2011 | Centre-embedded strings, Bengalese finches; lesions of NCM | Claims syntactic-rule learning | *Nature Neuroscience* 14:1067–1074, doi:10.1038/nn.2869 [r] |
| Beckers, Bolhuis, Okanoya & Berwick 2012 | Reanalysis of Abe & Watanabe: strings discriminable by phonetic/bigram cues | "Songbird context-free grammar claim is premature" | *NeuroReport* 23:139–145 [r] |
| Beckers, Berwick, Okanoya & Bolhuis 2017 | Review: for every published AGL result there is a sub-regular (bigram/positional/counting) account | "What do animals learn in artificial grammar studies?" | *Neurosci. Biobehav. Rev.* 81:238–246, doi:10.1016/j.neubiorev.2016.12.021 [r] |
| Jäger & Rogers 2012 | Sub-regular hierarchy formalised (SL, SP, LT, LTT…) | Recommends AGL be designed against the sub-regular hierarchy, not the Chomsky hierarchy | *Phil. Trans. R. Soc. B* 367:1956–1970, doi:10.1098/rstb.2012.0077 [r] |
| ten Cate & Okanoya 2012 | Review of natural song syntax and AGL | Birdsong = finite-state; AGL evidence for anything beyond is weak | *Phil. Trans. R. Soc. B* 367:1984–1994 [r] |
| Rohrmeier, Zuidema, Wiggins & Scharff 2015 | Compares structure-building in music, language, animal song using formal grammars | — | *Phil. Trans. R. Soc. B* 370:20140097 [r] |

### 2.3 Natural song syntax

| Ref | Object | Claim | Venue / ID |
|---|---|---|---|
| Okanoya 2004 | Finite-state automaton over "chunks" (note clusters) | Bengalese finch song = finite-state syntax; compared with zebra finch linear song | *Ann. N.Y. Acad. Sci.* 1016:724–735 [r] |
| Berwick, Okanoya, Beckers & Bolhuis 2011 | k-reversible automata; argues song grammars are regular and learnable from positive data; "phonological" not "syntactic" (no semantics, no compositional meaning) | "Songs to syntax" — birdsong resembles human *phonology* more than syntax | *Trends Cogn. Sci.* 15:113–121, doi:10.1016/j.tics.2011.01.002 [r] |
| Jin & Kozhevnikov 2011 | POMM: hidden states with many-to-one syllable emission; state-splitting inferred from repeat and branch statistics; compared with first-order Markov by sequence likelihood | Bengalese finch syntax needs hidden (non-observable) states: many-to-one mapping between neural states and syllables | *PLoS Comput. Biol.* 7:e1001108, doi:10.1371/journal.pcbi.1001108 [r] |
| Katahira, Suzuki, Okanoya & Okada 2011 | HMM with explicit higher-order context; shows "complex" rules reduce to simple hidden Markov processes | Bengalese finch | *PLoS ONE* 6:e24516, doi:10.1371/journal.pone.0024516 [v] |
| Kakishita, Sasahara, Nishino, Takahasi & Okanoya 2009 | Automata induction (state-merging) from behavioural symbol strings | "Ethological data mining" | *Data Min. Knowl. Disc.* 18:446–471 [v authors / r venue] |
| Bolhuis, Beckers, Huybregts, Berwick & Everaert 2018 | Critique of "compositional syntax" claims in birds: alternative that combinations are unanalysed wholes or additive | — | *PLoS Biol.* 16:e2005157 [r] |

### 2.4 Compositionality / call combinations

| Ref | Object / statistical test | Claim | Venue / ID |
|---|---|---|---|
| Zuberbühler 2002 | Prefixed "boom" before alarm changes receiver response (playback) | Campbell's monkeys: "syntactic rule" | *Animal Behaviour* 63:293–299 [r] |
| Arnold & Zuberbühler 2006 | Pyow–hack sequences elicit travel; individual calls don't | Putty-nosed monkeys: "semantic combinations" | *Nature* 441:303 [r] |
| Ouattara, Lemasson & Zuberbühler 2009 | "-oo" affixation changes call context; context-specific concatenation | Campbell's monkeys | *PNAS* 106:22026–22031 [r] |
| Suzuki, Wheatcroft & Griesser 2016 | Playback of natural ABC–D vs reversed D–ABC; behavioural response measured | Japanese great tits: "compositional syntax" — ordering rule | *Nature Communications* 7:10986, doi:10.1038/ncomms10986 [r] |
| Suzuki, Wheatcroft & Griesser 2017 | Novel artificial sequence: tit ABC + willow-tit "tää" in both orders | Tits decode novel combinations using an ordering rule | *Current Biology* 27:2331–2336 [r] |
| Suzuki, Wheatcroft & Griesser 2018 | Framework paper defining tests for compositional syntax in birds | — | *PLoS Biol.* 16:e2006532 [r] |
| Engesser, Ridley & Townsend 2016 | Alert + recruitment → "mobbing" sequence; playback | Southern pied babblers: compositional processing | *PNAS* 113:5976–5981 [r] |
| Engesser, Crane, Savage, Russell & Townsend 2015 | Same elements A,B in AB vs BAB; playback + acoustic analysis | Chestnut-crowned babblers: "phonemic contrasts" (duality-of-patterning candidate) | *PLoS Biol.* 13:e1002171, doi:10.1371/journal.pbio.1002171 [v] |
| Engesser, Holub, O'Neill, Russell & Townsend 2019 | Habituation–dishabituation shows shared elements are meaningless | Babbler calls composed of "meaningless shared building blocks" | *PNAS* 116:19579–19584, doi:10.1073/pnas.1819513116 [v] |
| Townsend et al. 2018 | Definitions: trivial vs non-trivial compositionality | "Compositionality in animals and humans" | *PLoS Biol.* 16:e2006425 [r] |
| Girard-Buttoz et al. 2022 | Sequence statistics: ordering, recombination, "bigram/trigram" positional regularities across 12 call types | Chimpanzees produce hundreds of ordered, recombinatorial sequences | *Communications Biology* 5:410 [r] |
| Leroux et al. 2023 | Natural observation + playback: alarm-huu + waa-bark to snakes; response strength compared | Chimpanzee "compositional-like" combination; more individuals recruited | *Nature Communications* 14:2225, doi:10.1038/s41467-023-37816-y [v] |
| Berthet, Surbeck & Townsend 2025 | Multiple Correspondence Analysis (MCA) on utterance × contextual-feature binary matrix (~700 utterances, ~300 features, 7 single + 19 two-call types); each utterance a point in a low-dimensional MCA "semantic space"; call types compared via distances between their point clouds; four criteria: combination's meaning differs from each part; relates to both parts; classification as trivial (combination lies at/near union of parts) vs nontrivial (combination sits near one part but shifted, i.e. one call modifies the other) using linear models on distances | Claims 4 compositional combinations, 3 nontrivial | *Science* 388:104–108, doi:10.1126/science.adv1170 [v] |
| Wartel, Lind, Kleberg, Tennie, Jonsson, Jon-And & Ekström 2026 | Reruns Berthet pipeline on randomised data: 34.5–84.3% false positives depending on implementation; MCA geometry reflects sampling frequency and repeated-measures dependence; a label-permutation test recomputing MCA gives Monte-Carlo p = 0.26 | "Structure without semantics: no evidence for bonobo compositionality" | *PeerJ* 14:e21651, doi:10.7717/peerj.21651 [v] |
| Schlenker, Chemla, Arnold, Lemasson, Ouattara, Keenan, Stephan, Ryder & Zuberbühler 2014 | Truth-conditional lexical semantics for krak/hok/-oo; pragmatic **Informativity Principle** (choose the most informative true call) yields dialectal differences via competition | Two "dialects" of Campbell's alarm calls | *Linguistics & Philosophy* 37:439–501 [r] |
| Schlenker et al. 2016 (target article + replies) | "Formal monkey linguistics": call semantics as sets of situations; **Urgency Principle** (calls carrying urgency info come first); competition/implicature; formal analyses of Campbell's, Titi, putty-nosed, Colobus systems | Argues methods of formal semantics/pragmatics apply, with meanings far poorer than words | *Theoretical Linguistics* 42:1–90, doi:10.1515/tl-2016-0001 [r] |
| Schlenker, Chemla & Zuberbühler 2016 | Review of the above for cognitive scientists | "What do monkey calls mean?" | *Trends Cogn. Sci.* 20:894–904 [r] |
| Schlenker, Chemla, Arnold & Zuberbühler 2016 | Two analyses of pyow-hack: lexical vs "sequence-level" semantics with Urgency | — | *Lingua* 171:1–23 [r] |
| Hersh et al. 2022 | Spatial statistics: between-clan identity-coda similarity decreases with spatial overlap (character displacement) | Sperm whale identity codas as symbolic ethnic markers | *PNAS* 119:e2201692119 [v] |
| "Rhythm of the Deep" (anon./2026) | Duality-of-patterning test: consensus of frozen audio encoders → acoustic unit induction; held-out structural tests; NSB-estimated 2nd-order transfer entropy lift 0.132 bits at bout level; per-statistic nulls | Sperm whale codas: lower tier is rhythmic (which clicks present + ICI) not segmental; upper tier shows sequential dependence | arXiv:2606.16084 [v] |
| Wolverton et al. 2024 | Review of syntax across taxa | — | *J. Avian Biol.* doi:10.1111/jav.03258 [v] |

---

## 3. Sequence modelling and machine learning

### 3.1 Objects
HMMs (incl. POMM, hierarchical HMM, HDP-HMM/infinite HMM), n-gram/variable-length Markov chains (VLMC), CNN/RNN/TCN segmenters, VAEs, UMAP, self-supervised transformers (HuBERT/wav2vec/data2vec-style), contrastive audio–text (CLAP-style), audio-LLMs, transformer LMs over discretised codas.

### 3.2 Papers

| Ref | Object | Claim / finding | Venue / ID |
|---|---|---|---|
| Bartcus, Chamroukhi & Glotin 2015 | HDP-HMM (sticky), MCMC on MFCC frames; infers number of hidden units | Unsupervised humpback song-unit discovery; also multi-species bird soundscapes | IEEE MLSP 2015 (Xplore 7280741) [v]; chapter Chamroukhi et al. 2018 doi:10.1007/978-3-319-76445-0_7 [v] |
| Kohlsdorf, Mason, Herzing & Starner 2014 | Probabilistic unit discovery (HMM/DTW-style) for dolphin whistles | Unsupervised "fundamental units" | ICASSP 2014 [r] |
| Cohen, Nicholson, Sanchioni, Mallaber, Skidanova & Gardner 2022 | TweetyNet: CNN+bidirectional LSTM frame-labeller; syllable-level annotation from spectrograms | Enables million-syllable datasets; Bengalese finch, canary; shows long-range syntax analysis | *eLife* 11:e63853, doi:10.7554/eLife.63853 [r] |
| Steinfath, Palacios-Muñoz, Rottschäfer, Yuezak & Clemens 2021 | DAS: temporal convolutional network on raw audio for song segmentation | Flies, mice, birds; fast and few-shot | *eLife* 10:e68837, doi:10.7554/eLife.68837 [r] |
| Goffinet, Brudner, Mooney & Pearson 2021 | VAE on spectrogram snippets → 32-d latent; MMD tests; latent interpolation | Mouse USV and zebra-finch repertoires; latent space captures individual/group differences better than hand-crafted features | *eLife* 10:e67855, doi:10.7554/eLife.67855 [r] |
| Sainburg, Thielk & Gentner 2020 | UMAP on spectrograms; HDBSCAN clustering; "silhouette" comparison to hand labels; continuous vs discrete repertoires | 19 datasets, 29 species; latent structure across taxa | *PLoS Comput. Biol.* 16:e1008228 [v] |
| Hagiwara 2023 | AVES: HuBERT-style masked-prediction self-supervised transformer pretrained on animal audio | SOTA on 8/10 BEANS tasks | ICASSP 2023; arXiv:2210.14493 [r]; BEANS arXiv:2210.12300 [r] |
| ESP 2024 | BirdAVES (bird-focused AVES) | — | earthspecies.org blog, June 2024 [v] |
| Robinson, Robinson & Akrami 2024 | BioLingual: CLAP-style contrastive language–audio pretraining on AnimalSpeak (>1M captioned clips, >25k species) | Zero-shot species classification | ICASSP 2024; arXiv:2308.04978 [v] |
| Robinson, Miron, Hagiwara & Pietquin 2025 | NatureLM-audio: audio encoder + LLM; instruction-tuned on bioacoustic tasks | First bioacoustic audio-language foundation model | ICLR 2025; arXiv:2411.07186 [v] |
| Ghani, Denton, Kahl & Klinck 2023 | Perch: supervised EfficientNet embeddings on Xeno-Canto | Bird embeddings transfer to other taxa | *Sci. Rep.* 13:22876 [r] |
| Chen et al. 2022 | BEATs: self-distilled tokeniser + audio transformer | General audio SSL, used as bioacoustic backbone | ICML 2023; arXiv:2212.09058 [r] |
| Schäfer-Zimmermann et al. 2024 | animal2vec: data2vec-style self-supervised transformer on raw audio with sparse-event losses; MeerKAT dataset (ms-resolution meerkat labels) | Few-shot; outperforms on MeerKAT and NIPS4Bplus | arXiv:2406.01253 [v] |
| Miron et al. 2025 | "What matters for bioacoustic encoding" — ablation study | — | arXiv (verify) [v title only] |
| FinchGPT 2025 | Transformer LM on syllable tokens of Bengalese finch | Attention captures long-range dependencies | arXiv:2502.00344 [v] |
| TweetyBERT 2025 | Self-supervised masked prediction on spectrograms | Automated song parsing | bioRxiv 2025.04.09.648029 [v] |
| Dolph2Vec 2026 | Self-supervised dolphin representations | — | arXiv:2606.12503 [v] |
| Google/Georgia Tech/WDP 2025 | DolphinGemma: Gemma LM on SoundStream tokens of dolphin audio; next-token prediction | Open model; paired with CHAT | Google blog, Apr 2025 [v] |
| Bermant, Bronstein, Wood, Gero & Gruber 2019 | CNN on click/coda spectrogram; coda type, clan, individual classification | High accuracy on Dominica dataset | *Sci. Rep.* 9:12588 [r] |
| Andreas, Beguš, Bronstein, Diamant, Delaney, Gero, Goldwasser, Gruber, de Haas, Malkin, Pavlov, Payne, Petri, Rus, Sharma, Tchernov, Tønnesen, Torralba, Vogt & Wood 2022 | CETI roadmap: (1) data collection (tags, arrays); (2) detection/denoising/source separation; (3) unit discovery (unsupervised "phoneme/word" discovery); (4) language modelling over discretised units incl. grammar induction; (5) behavioural/contextual grounding; (6) playback hypothesis testing. Frames goal as *understanding/deciphering* structure and its correlates, and treats "translation" as contingent on discovering referential structure | — | *iScience* 25:104393, doi:10.1016/j.isci.2022.104393; arXiv:2104.08614 [r] |
| Sharma, Gero, Payne, Gruber, Rus, Torralba & Andreas 2024 | Factorisation of coda into 4 features: **rhythm** = vector of inter-click intervals normalised by total duration (clusters into 18 types); **tempo** = total duration (5 modal types); **rubato** = smooth, gradual modulation of duration across consecutive codas of the same rhythm type within an exchange (context-sensitive); **ornamentation** = an extra click appended (≈ 4% of codas, at exchange boundaries). Product of independent features yields a much larger inventory than the ~21 classic coda types | 8,719 codas, EC1 clan, Dominica; "phonetic alphabet" | *Nature Communications* 15:3617, doi:10.1038/s41467-024-47221-8 [v] |
| Leitão et al. 2023–2025 | Vocal-style encoding of intra-coda ICI micro-variation; codas as variable-length Markov chains (context trees); similarity vs sympatry | Style similarity increases with sympatry for non-identity codas: social learning across clan boundaries | arXiv:2307.05304; eLife reviewed preprint 96362 [v] |
| Sharma, Gero, Rus, Torralba & Andreas 2024 (WhaleLM) | Transformer sequence model over coda tokens + behaviour; probes dependence up to 8 codas; predicts behaviour context (72%) and future action (86%) | Order dependence, long-range dependence, turn-taking | bioRxiv 10.1101/2024.10.31.621071 [v] |
| Paradise et al. 2025 | WhAM: "translative" generative model of coda audio | — | arXiv:2512.02206 [v] |
| Beguš, Leban & Gero 2023 | CDEV: train GAN/ciwGAN on coda audio; push individual latent variables to extreme values and measure causal effect on generated outputs (interventional, not correlational) | Latent dimensions map to click count, ICI, spectral properties; some correspond to known coda categories | arXiv:2303.10931 [v] |
| Beguš, Sprouse, Leban, Silva & Gero 2025 | Spectral analysis of click trains: formant-like recurring spectral peaks; two "vowel-like" categories (a-, i-) and diphthong-like sweeps; dialogic exchange | Claims vowel/diphthong analogues in codas | *Open Mind*, doi:10.1162/OPMI.a.252 [v] |
| Beguš et al. 2026 | Phonological patterning of the two vowel types (timing rules, coarticulation, individual variation) | — | *Proc. R. Soc. B* 293:20252994, doi:10.1098/rspb.2025.2994 [v] |
| Gruber lab 2025 | Automatic detection/annotation of EC codas | — | *Sci. Rep.* s41598-025-97009-z [v] |
| Kershenbaum & Garland 2015 | Comparison of sequence-similarity metrics (edit distance, n-gram, Markov divergence) | — | *Methods Ecol. Evol.* doi:10.1111/2041-210X.12433 [v] |
| Higher-order networks 2023 | Hypergraph/higher-order network models of multi-party communication | — | arXiv:2309.03783 [v] |

---

## 4. Translation / alignment mathematics

### 4.1 Objects
- **Orthogonal Procrustes** (Schönemann 1966): W* = argmin_{W∈O(d)} ‖WX − Y‖_F, solved by SVD of YXᵀ.
- **Adversarial + Procrustes refinement + CSLS** (Conneau et al. 2018).
- **Self-learning with structural initialisation** (Artetxe et al. 2018): initialise dictionary from similarity-of-similarity matrices (intra-lingual Gram matrices), iterate Procrustes.
- **Gromov–Wasserstein** (Mémoli 2011; Alvarez-Melis & Jaakkola 2018): min over couplings Γ of Σ |C_X(i,k) − C_Y(j,l)|² Γ_ij Γ_kl — matches *intra*-space distance structures, needs no shared coordinate system.
- **Isomorphism assumption**: the two embedding spaces are approximately related by an isometry; measured via eigenvector similarity / Gromov–Hausdorff / relational similarity.

| Ref | Object | Claim | Venue / ID |
|---|---|---|---|
| Mikolov, Le & Sutskever 2013 | Linear map between monolingual embeddings, supervised seed lexicon | Cross-lingual geometry roughly linear | arXiv:1309.4168 [r] |
| Conneau, Lample, Ranzato, Denoyer & Jégou 2018 | Adversarial alignment + Procrustes + CSLS retrieval; no parallel data | "Word translation without parallel data" | ICLR 2018; arXiv:1710.04087 [r] |
| Lample, Conneau, Denoyer & Ranzato 2018 | Unsupervised NMT from monolingual corpora (denoising + back-translation) | — | ICLR 2018; arXiv:1711.00043 [r] |
| Artetxe, Labaka & Agirre 2018 | Robust self-learning; structural-similarity initialisation | Works on distant pairs where adversarial fails | ACL 2018; arXiv:1805.06297 [r] |
| Alvarez-Melis & Jaakkola 2018 | Gromov–Wasserstein OT alignment of embedding spaces | Competitive unsupervised BLI using only intra-space metric structure | EMNLP 2018; arXiv:1809.00013 [r] |
| Søgaard, Ruder & Vulić 2018 | Eigenvector-similarity test of isomorphism; shows failure for distant languages, different domains, different algorithms | "On the limitations of unsupervised bilingual dictionary induction" | ACL 2018; arXiv:1805.03620 [r] |
| Vulić, Ruder & Søgaard 2020 | Isomorphism degraded by under-training and data size, not only typology | "Are all good word vector spaces isomorphic?" | EMNLP 2020; arXiv:2004.04070 [r] |
| Patra, Moniz, Garrett, Gormley & Neubig 2019 | Semi-supervised BLI in non-isometric spaces | — | ACL 2019 [r] |
| Huh, Cheung, Wang & Isola 2024 | "Platonic representation hypothesis": representations across modalities converge to a shared statistical model of reality | The strong-form premise behind cross-species alignment proposals | ICML 2024; arXiv:2405.07987 [r] |
| Abdou et al. 2021; Patel & Pavlick 2022 | Tests whether LM colour/space representations are isomorphic to perceptual spaces | Partial isomorphism recoverable from text alone | CoNLL 2021 (arXiv:2109.06129); ICLR 2022 [r] |
| Earth Species Project (Raskin, Selvitelle et al.) | Programme: self-supervised representation learning across species, then alignment/decoding; publications: AVES, BEANS, BirdAVES, BioLingual, NatureLM-audio, Voxaboxen; public framing of a "universal translator"/"decoding" | Publications page lists no paper actually performing cross-species embedding alignment | earthspecies.org/what-we-do/publications [v] |
| Rutz, Bronstein, Raskin, Vernes, Zacarian & Blasi 2023 | Policy/perspective: ML to decode animal communication; cautions | — | *Science* 381:152–155 [r] |
| Andreas et al. 2022 (CETI) | Explicitly frames goal as understanding structure + contextual correlates + playback validation; translation contingent on meaning | See §3 | *iScience* [r] |
| Yovel & Rechavi 2023 | "Doctor Dolittle challenge": criteria — machine communicates using the species' signals in many contexts; animals respond as to conspecifics; generative models can synthesise but context cannot be verified; human Umwelt bias | — | *Current Biology* 33:R783–R790, doi:10.1016/j.cub.2023.06.063 [v venue / r DOI] |
| Casey & Reichmuth 2024 | Human elements in AI comparative cognition | — | *Comp. Cogn. Behav. Rev.* 19 [v] |
| Rendall, Owren & Ryan 2009 | "Influence not information": signals evolved to manipulate receivers; informational/encoding metaphor is misleading | — | *Animal Behaviour* 78:233–240 [r] |
| Seyfarth, Cheney, Bergman, Fischer, Zuberbühler & Hammerschmidt 2010 | Reply: information (receiver-side reduction of uncertainty) is central | — | *Animal Behaviour* 80:3–8 [r] |
| Scott-Phillips 2008; 2015 | Definitional: communication = signal + response both adapted; ostensive-inferential vs code model | — | *J. Evol. Biol.* 21:387; *Speaking Our Minds* (Palgrave 2015) [r] |
| Bradbury & Vehrencamp 2011 | Textbook: information as reduction of receiver uncertainty; separates information from meaning; game-theoretic honesty | — | *Principles of Animal Communication* 2nd ed. [r] |
| Kershenbaum 2024 | Book: argues most animal signals are not word-like; "translation" ill-posed | *Why Animals Talk* (Viking) [r] |
| Mustill 2022 | Popular account of CETI/ESP | *How to Speak Whale* [r] |
| Herzing 2016; Kohlsdorf et al. 2013 | CHAT: wearable underwater keyboard with real-time whistle matching; model/rival paradigm | Dolphin mimicry of artificial whistles | *Anim. Behav. Cogn.* 3:243–254; ISWC 2013 doi:10.1145/2493988.2494346 [v] |
| Interspecies Internet (Gershenfeld, Goodall, Reiss, Cerf) | Programme, no formal methods paper | TED 2013 / interspecies.io [r] |
| AI & Ethics 2025 | Ethical implications of AI-mediated interspecies communication | — | doi:10.1007/s43681-025-00828-z [v] |

---

## 5. Compression, algorithmic information, MDL, and the grounding problem

| Ref | Object | Claim | Venue / ID |
|---|---|---|---|
| Li, Chen, Li, Ma & Vitányi 2004; Cilibrasi & Vitányi 2005 | Normalised information distance / NCD = [C(xy) − min(C(x),C(y))]/max(C(x),C(y)) | Universal similarity; used for music/genomes; **no primary bioacoustic application found** in this session | *IEEE Trans. Inf. Theory* 50:3250; 51:1523 [r] |
| Lempel & Ziv 1976 | LZ76 complexity | Used as entropy-rate proxy in Suzuki 2006, Kershenbaum 2016; in fungal spiking (Adamatzky 2022, *R. Soc. Open Sci.* 9:211926 [r]) | *IEEE Trans. Inf. Theory* 22:75 [r] |
| IPSJ Trans. 2011 (Japanese group) | Information-theoretic analysis of Bengalese finch song learning | — | J-STAGE ipsjtrans 4:183 [v] |
| Gauvrit, Zenil et al. 2014; Zenil et al. 2015 | Coding-theorem-method approximations of Kolmogorov complexity for short strings, applied to behaviour | Cognitive/behavioural validation | *Behav. Res. Methods* 46:732; arXiv:1509.06338 [v/r] |
| Solan, Horn, Ruppin & Edelman 2005 | ADIOS: unsupervised grammar induction via significant-path motifs on a graph of sentences | Proposed generically for animal sequences (Andreas 2022 mentions grammar induction); **no verified direct ADIOS-on-birdsong paper** | *PNAS* 102:11629 [r] |
| Ferrer-i-Cancho et al. 2013 | Compression (min Σ p_i l_i) as universal principle | See §1 | [v] |
| Harnad 1990 | Symbol grounding problem: symbols manipulated by shape alone acquire no intrinsic meaning | — | *Physica D* 42:335–346 [r] |
| Quine 1960; Putnam 1980 | Indeterminacy of translation; model-theoretic argument: any relational structure admits reinterpretation under permutation — distributional structure fixes meaning at most up to automorphism | Formal basis of the "Rosetta problem" | *Word and Object*; *J. Symb. Logic* 45:464 [r] |
| Piantadosi & Hill 2022 | Conceptual-role semantics: meaning = relations among internal states; hence recoverable from distribution without reference | Pro-decoding-from-structure position | arXiv:2208.02957 [v] |
| Mollo & Millière 2023 | Five grounding notions (referential, sensorimotor, relational, communicative, epistemic); referential grounding needs causal-informational + selectional history | Contra "structure suffices" | arXiv:2304.01481 [v] |
| Bender & Koller 2020 | Form alone cannot yield meaning ("octopus test") | — | ACL 2020 [r] |
| Merrill, Warstadt & Linzen 2022 | Theorem: entailment relations are extractable from an ideal LM's distribution under Gricean assumptions | What *is* recoverable from distribution | CoNLL 2022; arXiv:2209.12407 [r] |
| Categorical analysis of LLMs 2025 | Category-theoretic take on grounding | — | arXiv:2512.09117 [v] |

---

## 6. Topological / geometric / categorical, and transposition invariance

| Ref | Object | Claim | Venue / ID |
|---|---|---|---|
| Sainburg 2020; Goffinet 2021 | UMAP / VAE manifolds of repertoires (see §3) | "Song space" as learned low-dim manifold | [v]/[r] |
| Perl, Arneodo, Amador, Goller & Mindlin 2011; Amador, Perl, Mindlin & Margoliash 2013 | Song as trajectory in a 2-parameter (pressure, tension) dynamical-system space; "gestures" | Zebra finch song reduces to low-dim physical gesture trajectories | *Phys. Rev. E* 84:051909; *Nature* 495:59–64 [r] |
| TDA of human vowels 2023 | Persistent homology on spectrogram surfaces and Takens embeddings | Human only; methodology directly transferable | arXiv:2310.06508 [v] |
| DP mixture on topologically augmented representation 2024 | Infant vocalisations | — | arXiv:2407.05760 [v] |
| **TDA on animal vocal repertoires**: no peer-reviewed primary paper found; only tutorial/blog-level material [v absence] |
| Hulse, Cynx & Humpal 1984; Hulse & Cynx 1985 | Serial pitch pattern discrimination; transfer to transposed patterns | Starlings use absolute pitch; relative-pitch transfer constrained by frequency range | *J. Exp. Psychol. Gen.* 113:38; *J. Comp. Psychol.* 99:176 [r] |
| Weisman, Njegovan, Williams, Cohen & Sturdy 2004; Weisman et al. 2006 | Frequency-range discrimination; species comparison | Songbirds show far superior absolute-pitch ability to humans | *Behav. Processes* 66:289; chapter in *Comparative Cognition* (OUP 2006) [r] |
| Bregman, Patel & Gentner 2012 | Pitch processing flexibility depends on stimulus | — | *Cognition* 122:51 [r] |
| Bregman, Patel & Gentner 2016 | Operant recognition of transposed vs spectral-shape-preserved melodies | Starlings generalise on spectral shape, not pitch: invariance is to timbral envelope, not pitch transposition | *PNAS* 113:1666–1671, doi:10.1073/pnas.1515380113 [r] |
| Barbieri 2015 | Code biology: meaning via adaptor-mediated codes, no interpreter | — | *Code Biology* (Springer) [r] |
| Vega 2018 | Reconciles Barbieri with Rosen's (M,R)-systems (category-theoretic relational biology) and Peircean biosemiotics | Only explicit category-theoretic treatment located near biosemiotics | *Biological Theory* 13:261 [v] |
| Rosen 1991; Ehresmann & Vanbremeersch 2007 | Category theory in relational biology / Memory Evolutive Systems | Not applied to communication per se | *Life Itself*; *Memory Evolutive Systems* (Elsevier) [r] |
| Kull (Tartu school) | Umwelt/sign-relation modelling | Non-mathematical | e.g. Kull 2010 *Biosemiotics* [r] |
| Gentner 1983; Hofstadter & Sander 2013 | Structure-mapping theory of analogy — the cognitive-science counterpart of "align relational structures" | — | *Cognitive Science* 7:155; *Surfaces and Essences* [r] |

---

## 7. Symbolic dynamics and computational mechanics

| Ref | Object | Claim | Venue / ID |
|---|---|---|---|
| Crutchfield & Young 1989; Shalizi & Crutchfield 2001; Crutchfield 2012 | ε-machine: minimal unifilar HMM over causal states; statistical complexity C_μ; excess entropy E | Theory | *Phys. Rev. Lett.* 63:105; *J. Stat. Phys.* 104:817; *Nature Physics* 8:17 [r] |
| Muñoz et al. 2020 | ε-machine statistical complexity of Drosophila neural time series under anaesthesia | Complexity drops under anaesthesia | *Phys. Rev. Research* 2:023219 [v] |
| Berman, Bialek & Shaevitz 2016 | Predictive information I_pred(T); hierarchy of behavioural states | Drosophila behaviour: long timescale predictability, hierarchical | *PNAS* 113:11943 [r] |
| **ε-machines on birdsong/vocal sequences**: no primary application located [v absence] |
| Kershenbaum, Bowles, Freeberg, Jin, Lameira & Bohn 2014 | Renewal process (repeat-length distributions) vs 1st-order Markov, model comparison by likelihood | 7 taxa (Bengalese finch, chickadee, free-tailed bat, hyrax, pilot & killer whales, orangutan) fit non-Markovian renewal better | *Proc. R. Soc. B* 281:20141370, doi:10.1098/rspb.2014.1370 [v] |
| Bühlmann & Wyner 1999; Willems, Shtarkov & Tjalkens 1995 | VLMC / context-tree weighting | Used in Leitão 2023 for codas; CTW as entropy-rate estimator recommended in Kershenbaum 2016 | *Ann. Stat.* 27:480; *IEEE TIT* 41:653 [r] |
| Demartsev et al. 2023 | Isochrony metrics (nPVI, rhythm ratio) | Hyrax males with isochronous songs reproduce more | *J. Anim. Ecol.* doi:10.1111/1365-2656.13801 [v] |
| Ravignani & Norton 2017 | Rhythm-complexity metrics | — | *J. Lang. Evol.* 2:4 [r] |
| Adamatzky 2022 | LZ complexity and entropy of fungal electrical spike trains ("fungal words") | Fungal | *R. Soc. Open Sci.* 9:211926 [r] |

---

## 8. Statistical learning and unsupervised segmentation

| Ref | Object | Claim | Venue / ID |
|---|---|---|---|
| Saffran, Aslin & Newport 1996 | TP(x→y) = f(xy)/f(x); infants segment at TP dips | Human infants | *Science* 274:1926 [r] |
| Arnon et al. 2025 | TP-dip segmentation of humpback song → Zipf & brevity (see §1) | — | [v] |
| Goldwater, Griffiths & Johnson 2009 | Bayesian (DP/HDP) word segmentation | Human; template for unit discovery | *Cognition* 112:21 [r] |
| Bartcus et al. 2015 | HDP-HMM unit discovery on whale/bird audio (see §3) | — | [v] |
| Kohlsdorf et al. 2014 | Unit discovery in dolphin whistles | — | [r] |
| Sainburg 2020 | UMAP + HDBSCAN unsupervised units | — | [v] |
| Rhythm of the Deep 2026 | Acoustic unit induction with null gates | — | [v] |
| Dunbar et al. 2017–2021 (ZeroSpeech) | Unsupervised unit discovery benchmarks (ABX) | Not yet applied to animals in a published benchmark; animal2vec/AVES are the closest analogues | Interspeech [r] |
| Lipkind et al. 2013 | Stepwise combinatorial acquisition | Zebra finches and infants | *Nature* 498:104 [r] |
| Chen & ten Cate 2015 | Zebra finches use positional and transitional cues in AGL | — | *Behav. Processes* [r] |
| Kirby, Cornish & Smith 2008 | Iterated learning → compressible structure | — | *PNAS* 105:10681 [r] |

---

## 9. What the mathematics actually licenses

**Zipf / Zipf–Mandelbrot fit.** A rank–frequency exponent near −1 is produced by random-typing models, finite-sample effects, preferential attachment, and many non-communicative processes (Suzuki et al. 2005; Ferrer-i-Cancho's work); the exponent is also sensitive to the unit of analysis (Corral et al. 2015) and to segmentation choices (Arnon 2025 — the Zipfian distribution is over units *defined* by the TP algorithm). Licensed conclusion: the repertoire is skewed in a way consistent with a compression/learnability pressure. Not licensed: language-likeness, referential meaning, or "information content" in the semantic sense. Kershenbaum 2021's entropy-based estimator is preferable to rank-plot regression.

**Brevity and Menzerath.** These are (partial) correlations that follow from cost minimisation under almost any cost model (Ferrer-i-Cancho 2013). Effects flip or vanish with unit choice (Clink & Lau 2020; Clink et al. 2020) and require mixed models for repeated measures (Youngblood 2025). Licensed: evidence of efficiency pressure. Not licensed: syntax or semantics.

**Entropy rate and Markov order.** Entropy-rate estimates are heavily biased downward at small n and depend on symbolisation (Suzuki 2006; Kershenbaum 2016). Failure of a first-order Markov model (Kershenbaum 2014; Jin & Kozhevnikov 2011) licenses "not first-order Markov"; it does not license "hierarchical", since renewal processes and higher-order/hidden-state Markov models are alternatives. Power-law MI decay (Sainburg 2019) is consistent with hierarchical generation (Lin & Tegmark) but also with mixtures of Markov processes with heterogeneous timescales; the inference is model-comparative, not diagnostic.

**Formal-language claims.** AGL results place animals at most in the sub-regular/regular classes once bigram, positional, and counting strategies are controlled (van Heijningen 2009; Beckers 2012, 2017; Jäger & Rogers 2012). Natural song syntax is finite-state (k-reversible), and Berwick 2011's point stands: this is phonological, not syntactic, structure — there is no evidence of compositional semantics in song. Any grammar inferred from a finite corpus is under-determined (Gold); positive-data learnability arguments only justify regular subclasses.

**Compositionality tests.** Playback designs (Suzuki, Engesser, Leroux) license: receivers respond differently to combinations than to parts, and (with ordering manipulations) that order matters. They do not license that the combination's meaning is a *function* of part meanings, because the combination may be a holistic third signal (Bolhuis et al. 2018). Distributional/embedding approaches (Berthet 2025) inherit every problem of exploratory multivariate analysis: MCA geometry is driven by sampling design and repeated measures, and without a permutation null that recomputes the embedding the false-positive rate is uncontrolled (Wartel et al. 2026: 35–84% false positives; permutation p = 0.26). A valid test needs (a) pre-registered criteria, (b) nulls that preserve the dependence structure, (c) held-out data.

**Neural sequence models (WhaleLM, DolphinGemma, FinchGPT).** Predictive accuracy of next-unit or behaviour licenses "the sequence carries information predictive of X" (mutual information between codas and behaviour). It does not license that the whales *use* that information, nor meaning; and prediction from context can exploit caller identity, clan, and temporal autocorrelation confounds unless these are held out.

**Latent-space methods (VAE/UMAP/CDEV).** They license repertoire *description* (continuity vs discreteness, individual/group separation) with quantitative tests (MMD, silhouette). CDEV's interventional framing licenses causal statements about the *generator*, not about the whales. Factorisations like Sharma 2024's rhythm × tempo × rubato × ornamentation are descriptive parametrisations; the claim that they are "freely combinable" is a statement about observed independence in the corpus, and the size of the implied inventory is a count of distinguishable, not demonstrably distinctive (perceptually or functionally), codas — playback is needed.

**Embedding alignment / "universal translator".** Unsupervised alignment (Procrustes, adversarial, GW) is sound only under approximate isometry of the two spaces, which fails even across human languages when domains, algorithms, or data sizes differ (Søgaard 2018; Vulić 2020). For cross-species signals there is no shared referential domain to guarantee isometry; GW gives *some* coupling for any pair of metric spaces, so a low GW distance is not evidence of shared semantics without a null model. Mathematically, distributional structure fixes an interpretation at most up to automorphism of the relational structure (Putnam); any alignment is one of the (possibly many) structure-preserving maps, and only grounding (behaviour, playback, environment) selects among them (Harnad; Mollo & Millière; Yovel & Rechavi). The strongest positive claim licensable is Piantadosi & Hill's: relational (conceptual-role) content may be recoverable, but that is not reference.

**Compression / NCD.** Compressibility measures structure, not meaning; NCD is a valid universal similarity for clustering recordings but no published bioacoustic result rests on it. ADIOS-style grammar induction on animal sequences remains a proposal.

**Topology/geometry.** Transposition invariance is not a safe assumption for birds: they weight absolute pitch and spectral shape (Hulse & Cynx; Bregman 2016), so "shape" factorisations must be validated against the receiver's invariances, not the analyst's. No TDA results exist on animal repertoires; category theory enters only through biosemiotic philosophy, not through any computation.

**Statistical-learning segmentation.** TP-dip segmentation is a human-infant heuristic; applying it to song yields units by construction and then testing Zipf on those units is a joint hypothesis (segmentation + distribution). Licensed: song is segmentable by low-TP boundaries into units with a skewed distribution; not licensed: that whales segment it that way.

---

### Gaps found (useful for the caller)
- No verified peer-reviewed application of ε-machines, TDA/persistent homology, or NCD to animal vocal repertoires.
- No verified ADIOS-on-birdsong paper.
- No ESP or CETI paper performing an actual cross-species embedding alignment; the "translation" framing appears in programme statements, not methods papers.
- DOIs marked [r] should be checked; publisher sites (Nature, Science, Elsevier, PMC, PeerJ, arXiv, doi.org) were egress-blocked in this session, so verification relied on search-result metadata.