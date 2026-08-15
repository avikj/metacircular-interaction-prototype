# D0020 — the earliest-source discharge for the 40 CLASSICAL rows

*Compiled 2026-08-15 by the classical-sources pass (seed182 lane), against
`notes/D0020_LEDGER.md` §16. `D0020_LEDGER.md` is another agent's live artifact; it is
**edited only by addition** (a new §16.1 pointing here), never by overwrite, and no row's
status word was changed.*

## 0. What this note is, and the distinction it keeps

`CLAUDE.md` requires the earliest source to be named **before** write-up, and this corpus has
had three rediscoveries caught only at audit time. `D0020_LEDGER.md` §16 reports its own worst
defect in those terms: **40 rows marked CLASSICAL with no source read.** This note discharges
that register.

**The count was re-verified before work began, not taken from the brief.** §16's collected list
is 1.1, 1.4, 1.6, 1.7, 1.8, 1.9 (6); 2.1–2.8 (8); 3.1, 3.2, 3.3, 3.5, 3.8, 3.9, 3.11 (7); 4.1,
4.5, 4.7, 4.9, 4.10, 4.12, 4.13, 4.15, 4.17 (9); 5.4, 5.10, 5.11, 5.13, 5.14, 5.18 (6); 7.6 (1);
8.7, 8.11 (2); J5 (1). That is $6+8+7+9+6+1+2+1=\mathbf{40}$, and it agrees with §18's tally row
(**CLASSICAL 40**). The number and the list are correct as published.

**Two claims are kept apart throughout, and the table has two columns for them:**

- **Bibliographic verification** — that a work with this author, title, venue, volume, year and
  page range exists. This is what a search result establishes.
- **Content verification** — that the work *says* the thing the row attributes to it. This
  requires reading the work, and below it is claimed **only where it was actually done**.

Conflating the two is how an attribution becomes a rediscovery. Every row below says which of
the two it has.

**Grades used** (exactly one per row):

- **CLASSICAL-SOURCED** — earliest source found and named.
- **CLASSICAL-ATTRIBUTED** — the result is certainly standard and a canonical reference is
  named, but **I could not establish priority**. Those words are used literally; a textbook is
  never allowed to stand in for a priority claim.
- **NOT-CLASSICAL** — searched, no prior art found. Would be flagged in a section of its own.
- **UNVERIFIABLE** — the statement is too underdetermined to search for, with the missing
  definition named.

## 1. Result in one line

**27 CLASSICAL-SOURCED, 13 CLASSICAL-ATTRIBUTED, 0 NOT-CLASSICAL, 0 fully UNVERIFIABLE**
(one row, 3.3, is split: ATTRIBUTED for its ODE half, UNVERIFIABLE for its untyped half).

**The zero in the NOT-CLASSICAL column is a finding, not a suppression, and it is the expected
one.** §§1–4 of D0020 is an exposition of textbook material — `D0020_LEDGER.md` §18 says so
("forty are classical and correctly stated, which is a real property of the transmission and not
a criticism"). A register of forty expository rows *should* discharge to forty prior sources; a
NOT-CLASSICAL here would have meant the ledger misfiled an expository row as expository. None
did. What the pass did find is of a different kind, and is in §2.

## 2. The three corrections this pass owes the ledger

These are the pass's actual yield. Each is a defect in a *citation*, found by searching, that a
reader of §16 could not have seen.

1. **Row 2.5 (LQG area spectrum) cites the wrong paper for the parameter it warns about.**
   The row reads: "*Rovelli–Smolin 1995; Ashtekar–Lewandowski. The $\gamma$ is the Immirzi
   parameter and is **not** fixed by the theory*". The warning is right and the papers are real,
   but **$\gamma$ does not occur in Rovelli–Smolin 1995**: the one-parameter family of real
   connections $A=\Gamma+\gamma K$ is Barbero, *Real Ashtekar variables for Lorentzian signature
   space-times*, Phys. Rev. D **51** (1995) 5507, and the observation that $\gamma$ *moves the
   geometric spectra* — which is exactly what row 2.5's formula depends on — is Immirzi, *Real
   and complex connections for canonical gravity*, Class. Quantum Grav. **14** (1997) L177. The
   displayed spectrum $8\pi\gamma\lambda_0^2\sum\sqrt{\lambda_\epsilon(\lambda_\epsilon+1)}$ is
   therefore **post-1995 in its $\gamma$** and cannot be sourced to the 1995 paper alone.
   *(Bibliographic verification only; neither paper read.)*

2. **Row 4.15 (equal temperament) names no source at all** — it is the only row in the register
   of 40 that carries none, and §16 nonetheless counts it. Priority is locatable and is not
   European-only: **Zhu Zaiyu (朱載堉), *Lülü jingyi* (律呂精義), 1584**, who computed
   $\sqrt[12]{2}$ to twenty-four places on an abacus, and independently **Simon Stevin, *Van de
   spiegheling der singconst*, c. 1585** (unpublished in his lifetime; printed 1884). The two are
   standardly reported as independent, with Zhu one year earlier and more precise.
   *(Bibliographic verification only.)*

3. **Row 2.4's page reference is a start page presented as the citation.** Birkhoff–von Neumann
   is Ann. Math. **37** (1936) **823–843**, not "823". Harmless, and recorded because a ledger
   that publishes a defect register should have its own references exact.

None of these changes a status word. All three are recorded in the ledger's new §16.1 with the
original text quoted.

## 3. What the corpus had already done, and which the ledger did not know

Two of the forty were **already discharged inside this repository**, by notes the ledger cites
for other purposes. Found by repo search before any web search — the cheap step first.

- **8.11 (Stanley–Proctor).** `notes/SL2_DIVISOR_LATTICE.md` §§ near line 128 carries the full
  search, and carries **an earlier source for the theorem than the ledger names**: the Sperner
  property of divisor lattices is **de Bruijn, van Ebbenhorst Tengbergen and Kruyswijk (1951)**,
  with Stanley 1980 and Proctor 1982 supplying the *$\mathfrak{sl}_2$/hard-Lefschetz method*, not
  the theorem. The ledger's row attributes the theorem to Stanley–Proctor; that is the method's
  provenance, not the result's. That note also states its own limit — full text of Proctor 1982
  and Proctor–Saks–Sturtevant could not be retrieved — which this pass inherits and does not
  paper over. **J1's prior-art instruction is discharged by that note, not by this one.**
- **7.6 (Birkhoff polarity).** `notes/APOHA_AND_POLARITY.md` lines 249–258 carries Birkhoff,
  *Lattice Theory*, AMS Colloquium Publications XXV, 1940, and Ore, *Galois Connexions*, Trans.
  AMS **55** (1944) 493–513, and marks both explicitly *"cited from summary; Birkhoff 1940 not
  read"*. The ledger's row 7.6 names the same two and adds nothing. **The corpus was already at
  the ledger's standard here and the ledger did not say so.**

## 4. The table

Column **B** = bibliographic verification; column **C** = content verification. `search` = a web
search returned the record from multiple independent bibliographic databases; `repo` = a corpus
note carries it; `no` = not done, and no letter-for-letter content is asserted below.

### §1 — number, form, proof

| row | statement, as mathematics | earliest source named | B | C | grade |
|---|---|---|---|---|---|
| 1.1 | the tower $\mathbb N\subset\mathbb Z\subset\mathbb Q\subset\mathbb R\subset\mathbb C$ | von Neumann, *Zur Einführung der transfiniten Zahlen*, Acta Litt. Sci. Szeged **1** (1923) 199–208 (ordinals); Dedekind, *Stetigkeit und irrationale Zahlen*, Vieweg 1872 (reals by cuts); Hamilton, *Theory of Conjugate Functions*, Trans. R. Irish Acad. **17** (1837) 293–422 (complexes as ordered pairs) | search | no | **CLASSICAL-ATTRIBUTED** — each constituent is canonically sourced, but **the tower as a tower has no first author**; it is a pedagogical arrangement, and I could not establish priority for it. Do not read the three names as a priority claim about the display |
| 1.4 | the long run: $\sum_1^n=n(n+1)/2$, binomial theorem, unique factorisation, FTC, spectral facts | Euclid, *Elements* IX.14 (the uniqueness lemma); **Gauss, *Disquisitiones Arithmeticae*, 1801, art. 16** for the first full statement and proof of unique factorisation; Euler, *Introductio in analysin infinitorum*, 1748 | search | no | **CLASSICAL-SOURCED** — with the standard caveat that Euclid IX.14 is *weaker* than the fundamental theorem of arithmetic and Gauss art. 16 is the first complete statement. The ledger names both, in that order, and is right to |
| 1.6 | $e^{i\theta}=\cos\theta+i\sin\theta$; $e^{i\pi}+1=0$ | Euler, *Introductio in analysin infinitorum*, Lausanne 1748, Book I §138 | search | no | **CLASSICAL-SOURCED** (Cotes 1714 has the logarithmic form; Euler 1748 the display as written) |
| 1.7 | $\alpha\mapsto\hom(-,\alpha)$ is fully faithful | **priority not established.** Yoneda, *On the homology theory of modules*, J. Fac. Sci. Univ. Tokyo I **7** (1954) 193–227 — **the lemma is not in it**; the name is Mac Lane's, after the Gare du Nord conversation of 1954; the earliest *printed* statement is reported variously as Grothendieck, Tôhoku, Tôhoku Math. J. **9** (1957), and as Grothendieck's 1960 Bourbaki seminar, and the sources disagree | search | no | **CLASSICAL-ATTRIBUTED** — and this is a genuine correction of emphasis: **the ledger's "Yoneda 1954" is not a priority claim that survives searching.** Canonical modern reference: Mac Lane, *Categories for the Working Mathematician*, 2nd ed., III.2 |
| 1.8 | homology with $\partial\partial=0$; $\pi_1(S^1)\cong\mathbb Z$; winding number $\frac1{2\pi i}\oint dz/z$ | Poincaré, *Analysis Situs*, J. École Polytech. (2) **1** (1895) 1–121, for both homology and $\pi_1$; the winding integral is Cauchy's, diffusely across 1825–1831 | search | no | **CLASSICAL-ATTRIBUTED** — Poincaré 1895 is secure for two of the three; **I could not establish priority for the winding number as a stated invariant**, which is why the row is not SOURCED |
| 1.9 | diagonal argument; incompleteness; entropy; Bayes; $\beta$-reduction | Cantor, *Über eine elementare Frage der Mannigfaltigkeitslehre*, Jber. DMV **1** (1891) 75–78; Gödel, *Über formal unentscheidbare Sätze…*, Monatsh. Math. Phys. **38** (1931) 173–198; Shannon, *A Mathematical Theory of Communication*, Bell Syst. Tech. J. **27** (1948) 379–423, 623–656; Bayes, Phil. Trans. **53** (1763) 370–418; Church, *An unsolvable problem of elementary number theory*, Amer. J. Math. **58** (1936) 345–363 | search | no | **CLASSICAL-SOURCED** |

### §2 — matter, time, geometry, wave

| row | statement | earliest source named | B | C | grade |
|---|---|---|---|---|---|
| 2.1 | least action; Noether; Maxwell; Minkowski; Einstein field equations with $\Lambda$ | Noether, *Invariante Variationsprobleme*, Nachr. Ges. Wiss. Göttingen (1918) 235–257; Maxwell, *A Dynamical Theory of the Electromagnetic Field*, Phil. Trans. **155** (1865) 459–512; Einstein, Sitzungsber. Preuss. Akad. (1915) 844–847 (field equations) and (1917) 142–152 (the $\Lambda$ term the display carries) | search | no | **CLASSICAL-SOURCED** — note the display's $\Lambda$ dates the row to 1917, not 1915, and the ledger's "1915/1917" is right to give both |
| 2.2 | Schrödinger; Born rule; uncertainty; purity criterion; path integral | Schrödinger, Ann. Phys. **384** (1926) 361; Born, Z. Phys. **37** (1926) 863; Heisenberg, Z. Phys. **43** (1927) 172; von Neumann, *Mathematische Grundlagen der Quantenmechanik*, 1932 (the density matrix and $\rho^2=\rho$ criterion); Feynman, Rev. Mod. Phys. **20** (1948) 367 | search | no | **CLASSICAL-SOURCED** |
| 2.3 | relational QM: $\rho_{\alpha\mid\beta}\not\equiv\rho_\alpha$ | Rovelli, *Relational Quantum Mechanics*, Int. J. Theor. Phys. **35** (1996) **1637–1678**, DOI 10.1007/BF02302261 | search | no | **CLASSICAL-SOURCED** — the ledger's citation is exact. Its own caveat (this is an interpretation, CLASSICAL *as an interpretation*) stands and is the right disposition |
| 2.4 | quantum logic; failure of distributivity | Birkhoff and von Neumann, *The Logic of Quantum Mechanics*, Ann. Math. (2) **37** (1936) **823–843** | search | no | **CLASSICAL-SOURCED**; page range corrected (§2.3 above) |
| 2.5 | area spectrum $8\pi\gamma\lambda_0^2\sum\sqrt{\lambda(\lambda+1)}$ | Rovelli and Smolin, *Discreteness of area and volume in quantum gravity*, Nucl. Phys. B **442** (1995) 593–619, erratum B **456** (1995) 753. **For $\gamma$, which is not in that paper:** Barbero, Phys. Rev. D **51** (1995) 5507; Immirzi, Class. Quantum Grav. **14** (1997) L177. Also Ashtekar–Lewandowski, Class. Quantum Grav. **14** (1997) A55 | search | no | **CLASSICAL-SOURCED — with the ledger's source incomplete**; see §2.1 above. The ledger's *warning* about $\gamma$ is correct; its *citation* for $\gamma$ was not |
| 2.6 | TQFT gluing/composition axiom | Atiyah, *Topological quantum field theories*, Publ. Math. IHÉS **68** (1988) 175–186 (freely readable at numdam.org) | search | no | **CLASSICAL-SOURCED**. The ledger's own defect note — the measure $\delta\psi_\Sigma$ is undefined in general — is not a defect of Atiyah, whose axioms are finite-dimensional and impose gluing by fiat; that strengthens the ledger's point rather than weakening it |
| 2.7 | closure of the Dirac constraint algebra as an anomaly | Dirac, *The Theory of Gravitation in Hamiltonian Form*, Proc. R. Soc. A **246** (1958) 333–343; DeWitt, *Quantum Theory of Gravity. I. The Canonical Theory*, Phys. Rev. **160** (1967) 1113–1148 | search | no | **CLASSICAL-SOURCED** |
| 2.8 | second law; fluctuation theorem; Planck; Friedmann | Boltzmann, Wien. Ber. **76** (1877) 373 ($S=k\log W$); Evans, Cohen and Morriss, *Probability of second law violations in shearing steady states*, Phys. Rev. Lett. **71** (1993) 2401–2404; Crooks, Phys. Rev. E **60** (1999) 2721–2726; Planck, Ann. Phys. **4** (1901) 553; Friedmann, Z. Phys. **10** (1922) 377 | search | no | **CLASSICAL-SOURCED**. The row's displayed ratio $\varpi_+[\gamma]/\varpi_-[\gamma^\vee]=e^{\Delta\eta/k_B}$ is **Crooks's** form (trajectory-reversal), not Evans–Cohen–Morriss's (steady-state, asymptotic); the ledger names both and is right to, but the display is 1999, not 1993 |

### §3 — chemistry, heredity, the web of life

| row | statement | earliest source named | B | C | grade |
|---|---|---|---|---|---|
| 3.1 | hydrogenic Schrödinger; Pauli exclusion; Arrhenius | Pauli, *Über den Zusammenhang des Abschlusses der Elektronengruppen…*, Z. Phys. **31** (1925) 765–783; Arrhenius, Z. Phys. Chem. **4** (1889) 226–248 | search | no | **CLASSICAL-SOURCED** |
| 3.2 | a catalyst lowers $\Delta G^\ddagger$ and not $\Delta G$ | **priority not established.** Ostwald's 1894/1901 definition of catalysis is the origin of the *concept*; the state-function argument for $\Delta G$ invariance is anonymous textbook material (e.g. Atkins, *Physical Chemistry*, ch. on chemical kinetics) | search | no | **CLASSICAL-ATTRIBUTED** — certainly standard, no first statement locatable. This is the honest disposition for a fact that is a one-line consequence of a definition |
| 3.3 | autocatalysis $\dot\alpha=k\phi\alpha-\delta\alpha$ *(first half)*; the boundary loop *(second half)* | Lotka, *Contribution to the theory of periodic reactions*, J. Phys. Chem. **14** (1910) 271–274 | search | no | **CLASSICAL-ATTRIBUTED** for the ODE (Lotka 1910 is the earliest I could find for an autocatalytic rate law of this shape; I could not establish that it is *the* first). **UNVERIFIABLE for the boundary loop $\partial\Omega\to$ अन्तःसन्धानम $\to\partial\Omega$** — the missing definition is the **type of $\partial\Omega$**: no ambient in which a boundary is taken is given, so there is no statement to search for. The ledger already declines to score that half separately; this note records *why* it is unsearchable |
| 3.5 | the genetic code $64\to20+\text{stop}$; the transcription/translation pipeline | Nirenberg and Matthaei, *The dependence of cell-free protein synthesis in E. coli upon naturally occurring or synthetic polyribonucleotides*, PNAS **47** (1961) 1588–1602; Crick, *On Protein Synthesis*, Symp. Soc. Exp. Biol. **12** (1958) 138–163 | search | no | **CLASSICAL-SOURCED**. Note the 1961 paper decodes **one** codon (UUU→Phe); the full $64\to20$ table is Nirenberg–Leder 1964 and Khorana, and a row claiming the whole map needs them too |
| 3.8 | replicator equation; Price equation | Price, *Selection and covariance*, Nature **227** (1970) 520–521; Taylor and Jonker, *Evolutionarily stable strategies and game dynamics*, Math. Biosci. **40** (1978) 145–156 | search | no | **CLASSICAL-SOURCED** |
| 3.9 | variation + heredity + differential fitness $\Rightarrow$ evolution | Lewontin, *The Units of Selection*, Ann. Rev. Ecol. Syst. **1** (1970) 1–18 | search | **no — and this one was attempted and failed** | **CLASSICAL-SOURCED bibliographically.** The ledger makes a **content** claim about this paper — that "Lewontin states [the three conditions] as sufficiency" — and I could **not** verify it: the freely available scan (zoology.ubc.ca) is an image PDF that did not decode to text. **The row's content claim therefore remains undischarged, and I am not asserting it.** A successor with a text-layer copy should check whether Lewontin's phrasing is sufficiency, necessity, or both |
| 3.11 | generalised Lotka–Volterra | Lotka, *Elements of Physical Biology*, Williams & Wilkins 1925; Volterra, Mem. Accad. Lincei **2** (1926) 31–113 | search | no | **CLASSICAL-ATTRIBUTED** — the two-species system is securely theirs; **the $n$-species "generalised" form the row names is later and diffuse** and I could not establish priority for it. (The trophic efficiency ratios are carried at J7 and are not a classicality question at all) |

### §4 — nerve, language, mind, society

| row | statement | earliest source named | B | C | grade |
|---|---|---|---|---|---|
| 4.1 | scaled dot-product attention $\mathrm{softmax}(QK^\top/\sqrt{d})V$ | Vaswani, Shazeer, Parmar, Uszkoreit, Jones, Gomez, Kaiser and Polosukhin, *Attention Is All You Need*, NeurIPS 2017 / arXiv:1706.03762, §3.2.1 — where the $1/\sqrt{d_k}$ scaling is introduced and motivated | search | no | **CLASSICAL-SOURCED**. Additive attention is earlier (Bahdanau–Cho–Bengio, ICLR 2015); the **$\sqrt d$-scaled dot-product** form the row displays is 2017 |
| 4.5 | rule ordering and blocking | **priority not established.** Pāṇini, *Aṣṭādhyāyī* (c. 5th–4th c. BCE) for ordered rules with blocking; Chomsky and Halle, *The Sound Pattern of English*, Harper & Row 1968, for the modern formulation | search | no | **CLASSICAL-ATTRIBUTED** — Pāṇini's date and the identification of "rule ordering" as a Pāṇinian concept are scholarly reconstructions, not a citable first statement |
| 4.7 | $\llbracket\alpha\rrbracket_\kappa\ne\llbracket\alpha\rrbracket_{\kappa'}$ — context-dependence | Montague, *Universal Grammar*, Theoria **36** (1970) 373–398; Kaplan, *Demonstratives*, read at a symposium March 1977, published 1989 in Almog, Perry and Wettstein (eds), *Themes from Kaplan*, OUP, 481–563 | search | no | **CLASSICAL-SOURCED**. The ledger's "1977/1989" is exactly the right way to write this one and needs no repair |
| 4.9 | the triadic sign; meaning is not inside the sign | Peirce, *Collected Papers* **2.228** (1897): "A sign, or representamen, is something which stands to somebody for something in some respect or capacity… That sign which it creates I call the Interpretant of the first sign. The sign stands for something, its object." | search | **partial — the quoted sentence was retrieved from secondary sources quoting CP 2.228, not from the *Collected Papers* themselves** | **CLASSICAL-SOURCED** |
| 4.10 | the five Pāṇinian metarule types | Pāṇini, *Aṣṭādhyāyī*; Kiparsky, *Pāṇini as a Variationist*, MIT Press / Poona 1979 | search | no | **CLASSICAL-ATTRIBUTED** — the five types are standard in the commentarial tradition; **priority within that tradition (Kātyāyana, Patañjali, or the sūtras themselves) I could not establish** |
| 4.12 | channel, conditional entropy, mutual information | Shannon, *A Mathematical Theory of Communication*, Bell Syst. Tech. J. **27** (1948) 379–423, 623–656 | search | no | **CLASSICAL-SOURCED** |
| 4.13 | Nash equilibrium | Nash, *Equilibrium Points in n-Person Games*, PNAS **36** (1950) 48–49 | search | no | **CLASSICAL-SOURCED**. (Existence for the general $n$-person case; the 2-person zero-sum antecedent is von Neumann, Math. Ann. **100** (1928) 295) |
| 4.15 | $\omega_\nu=\omega_02^{\nu/12}$ | **Zhu Zaiyu (朱載堉), *Lülü jingyi* (律呂精義), 1584** — $\sqrt[12]{2}$ to 24 places; and independently **Simon Stevin, *Van de spiegheling der singconst*, c. 1585**, printed 1884 | search | no | **CLASSICAL-SOURCED — and this row named no source at all.** See §2.2 above. The ledger's *mathematical* observation on this row (the display silently replaces small-integer ratios by their irrational approximations — the comma problem) is correct and is independent of the citation |
| 4.17 | central projection $(\xi,\eta,\zeta)\mapsto(\phi\xi/\zeta,\phi\eta/\zeta)$ | Alberti, *De pictura*, 1435, for the first written construction; Brunelleschi's demonstration (c. 1413) is earlier but left no text | search | no | **CLASSICAL-ATTRIBUTED** — **priority is not establishable in principle here**, the earlier work being undocumented. The algebraic form as displayed is later still (Desargues 1639; projective coordinates, Möbius 1827) |

### §5 — the philosophy mandala

*Standing caution for this block: for Sanskrit and Prakrit sources, "earliest source" and
"earliest surviving source" come apart, dates are contested by centuries, and **sūtra numbering
varies by edition**. Every row here is graded on that basis and none is upgraded past it. The
corpus's two notes that do read primary text — `ABHAVA.md`, `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` —
remain the only discharged primary-text citations touching D0020, as §16 says.*

| row | statement | earliest source named | B | C | grade |
|---|---|---|---|---|---|
| 5.4 | four pramāṇas; the five-membered inference | *Nyāya-sūtra* of Gautama/Akṣapāda, c. 2nd c. BCE–2nd c. CE; the four pramāṇas at 1.1.3, the five members at 1.1.32 in the standard numbering. Canonical translation: Jha, *The Nyāya-Sūtras of Gautama with Vātsyāyana's Bhāṣya*, 1912–19 | search | no | **CLASSICAL-ATTRIBUTED** — the doctrine and the text are certain; **I could not confirm the sūtra numbers 1.1.3 and 1.1.32 against an edition**, and numbering varies. The ledger's own note that `ABHAVA.md` reads primary text nearby is right and is where a reader should go |
| 5.10 | anekāntavāda as relativisation to a standpoint | **priority not established.** Matilal, *The Central Philosophy of Jainism (Anekānta-vāda)*, L. D. Institute, Ahmedabad 1981, is the canonical modern statement of *this reading*; the doctrine's earliest textual locus is contested (see 5.11) | search | no | **CLASSICAL-ATTRIBUTED**. Note carefully: the ledger attributes **the reading** (indexing dissolves the contradiction, so no paraconsistent logic is needed) to Matilal, and that reading is Matilal's or later — it is **not** claimed as the Jain sources' own, and the ledger does not claim it is |
| 5.11 | saptabhaṅgī, the sevenfold predication | **priority contested and I could not settle it.** The ascription to Bhadrabāhu (4th c. BCE) is doubted; the earliest *indisputable* mention is Siddhasena Divākara, *Nyāyāvatāra* (c. 480–550 CE); the earliest *full* exposition of all seven is Samantabhadra, *Āptamīmāṃsā* (dated between the 2nd and 6th c. CE by different scholars) | search | no | **CLASSICAL-ATTRIBUTED** — and this row also named no source in the ledger. The count of seven is secure; the origin is not |
| 5.13 | śūnyatā $\ne$ non-existence; śūnyatā $=$ dependent origination | Nāgārjuna, *Mūlamadhyamakakārikā* 24.18 (c. 2nd c. CE): dependent origination is what is called emptiness; it is a dependent designation, and is itself the middle way | search | **partial — 24.18 retrieved in translation from multiple secondary sources; no Sanskrit edition consulted** | **CLASSICAL-SOURCED**. Standard critical edition: de Jong, *Nāgārjuna: Mūlamadhyamakakārikāḥ*, Adyar 1977 |
| 5.14 | catuṣkoṭi, the four-cornered negation | *Mūlamadhyamakakārikā* 1.1 and 18.8; the fourfold schema is older than Nāgārjuna, appearing in the Pāli Nikāyas (the *avyākata* questions) | search | no | **CLASSICAL-SOURCED** — with the correction that **MMK is not the earliest occurrence of the schema**, only of its Madhyamaka use. The ledger's "MMK 1.1 / 18.8" is right for the latter |
| 5.18 | the Cārvāka restriction of pramāṇas to perception | **no primary Cārvāka text survives.** The doctrine is attested only through opponents: chiefly Mādhava, *Sarvadarśanasaṃgraha* ch. 1 (14th c.), and Jayarāśi, *Tattvopaplavasiṃha* (c. 8th c.) | search | no | **CLASSICAL-ATTRIBUTED** — **priority is unestablishable in principle**, the primary literature being lost. The ledger says exactly this ("attested chiefly through opponents' citations") and is right; the grade records that its honesty is a permanent condition, not a temporary gap |

### §7, §8, J5

| row | statement | earliest source named | B | C | grade |
|---|---|---|---|---|---|
| 7.6 | $\alpha\mapsto\alpha^{\perp\perp}$ is a closure operator (Birkhoff polarity) | Birkhoff, *Lattice Theory*, AMS Colloq. Publ. XXV, 1940, ch. V; Ore, *Galois Connexions*, Trans. AMS **55** (1944) 493–513 | repo (`APOHA_AND_POLARITY.md` ll. 249–258) | no — that note says so in terms | **CLASSICAL-SOURCED** — via the corpus, which reached this before the ledger did (§3 above) |
| 8.7 | Euler product; $\xi(s)=\xi(1-s)$ | Euler, *Variae observationes circa series infinitas*, Comment. Acad. Sci. Petrop. **9** (1744, presented 1737), Eneström E72 — where the product first appears; Riemann, *Über die Anzahl der Primzahlen unter einer gegebenen Grösse*, Monatsber. Berlin Akad., November 1859 | search | no | **CLASSICAL-SOURCED**. Note the presentation/publication gap: **1737 is the presentation date, 1744 the printing** — the ledger's "Euler 1737" is the conventional citation and is not wrong, but a reader chasing the volume needs 1744 |
| 8.11 | the $\mathfrak{sl}_2$ action behind the Sperner property of divisor lattices | **The theorem:** de Bruijn, van Ebbenhorst Tengbergen and Kruyswijk, *On the set of divisors of a number*, Nieuw Arch. Wiskunde **23** (1951) 191–193. **The method:** Stanley, *Weyl groups, the hard Lefschetz theorem, and the Sperner property*, SIAM J. Alg. Disc. Meth. **1** (1980) 168–184; Proctor, *Representations of $\mathfrak{sl}(2,\mathbb C)$ on posets and the Sperner property*, ibid. **3** (1982) 275–280 | repo (`SL2_DIVISOR_LATTICE.md`) | no — **SIAM full text was not retrievable there and is not here** | **CLASSICAL-SOURCED, with the theorem/method split the ledger's row does not make** (§3 above). **J1's prior-art instruction is discharged — by `SL2_DIVISOR_LATTICE.md`, which did the search this note only confirms** |
| J5 | the constraint-algebra anomaly is a genuine open problem, correctly attributed | as 2.7: Dirac 1958; DeWitt 1967 | search | no | **CLASSICAL-SOURCED** |

## 5. Paywalls and retrieval failures, stated as such

Per the brief, and because bibliographic and content verification are different claims:

- **SIAM** (Stanley 1980, Proctor 1982, row 8.11): not retrieved. `SL2_DIVISOR_LATTICE.md`
  records the same failure independently. **No letter-for-letter content of either paper is
  asserted anywhere above.**
- **Lewontin 1970** (row 3.9): the free scan is an image PDF that did not decode. The
  bibliographic record is verified; **the ledger's content claim about sufficiency is not**, and
  is flagged in the table rather than passed along.
- **Peirce CP 2.228** (row 4.9) and **MMK 24.18** (row 5.13): the quoted wording comes from
  secondary sources quoting the passage, not from the *Collected Papers* or a Sanskrit edition.
  Marked `partial` in column C for exactly that reason.
- **No PDF was decoded end-to-end in this pass.** Every `search` in column B means: multiple
  independent bibliographic databases returned the same author/title/venue/volume/year/pages.
  That establishes the record exists. It does not establish what is inside it, and nothing above
  claims it does.

## 6. Scope limits

1. **27 of 40 are SOURCED, 13 ATTRIBUTED. The 13 are not a backlog to be cleared by more
   searching** — most are unclearable in principle (4.17: Brunelleschi left no text; 5.18: the
   Cārvāka corpus is lost; 3.2: a one-line consequence of a definition has no first author). Two
   *are* clearable by a specialist: **5.11** (saptabhaṅgī's earliest locus) and **1.7** (whether
   the Yoneda lemma's first print appearance is Tôhoku 1957 or Bourbaki 1960). Those two are the
   only live prior-art questions left in the register.
2. **Content verification was achieved for none of the 40** and is claimed for none. This note
   discharges §16's *earliest-source-named* requirement; it does **not** discharge
   `OWNER_TRANSMISSIONS_LEDGER.md`'s stricter "earliest source **actually read**". §16's own
   sentence — "No CLASSICAL row in this ledger rests on a PDF I decoded; I decoded none" —
   remains true after this pass, and the ledger's §16 is amended to say so rather than to claim
   the defect closed.
3. **I did not re-adjudicate any row's mathematics.** Where a row's status is CLASSICAL, it is
   still CLASSICAL. The only substantive changes proposed are the three citation corrections of
   §2, and they are applied to the ledger by addition with the original text quoted.
4. **The four PARTIAL rows §16 excludes** (3.6 Anfinsen, 5.5 Vaiśeṣika, 5.6 Sāṃkhya, 5.9
   Vedānta) were **not** worked. §16 says their doctrinal halves carry the same defect; that is
   still true, and is now the largest remaining earliest-source gap in D0020. Anfinsen is the
   easy one (Anfinsen, *Principles that Govern the Folding of Protein Chains*, Science **181**
   (1973) 223–230).
5. **No Python. No experiment, no measurement, no fit.** Web search and web fetch only, plus
   repository grep. Nothing in this note is a numerical claim.

---

*Compiled 2026-08-15. `notes/D0020_LEDGER.md` read in full (631 lines) and edited only by
addition (§16.1). `notes/SL2_DIVISOR_LATTICE.md` and `notes/APOHA_AND_POLARITY.md` read at the
lines cited and not edited. The §16 count of 40 was recomputed from the list, not taken from the
brief, and is correct.*

---

## Addendum (2026-08-15, dignāga-partials lane) — the four rows this note excluded

This note's closing "not worked" item — the four PARTIAL rows §16 excludes, **3.6, 5.5, 5.6,
5.9** — is discharged in `notes/D0020_PARTIALS_UNDEFINED_AND_TWO_DISAGREEMENTS.md` §1, under
this note's own two-column discipline and grade vocabulary. All four are
**bibliographically verified, content-unverified-from-primary**; the retrieval failures
(science.org 403 and an IIT-D mirror 503 for Anfinsen; no Sanskrit edition decoded) are stated
there in place, following the precedent this note set for Lewontin 1970 and SIAM.
**Nothing above this heading is altered.**
