# Non-human communication: the datasets, the literature, the mathematics, and what this corpus executes on them

*2026-09-14. Companion files: `communication/DATASETS_ANIMAL.md`,
`communication/DATASETS_PLANT_FUNGAL_MICROBIAL.md`,
`communication/MATHEMATICS_OF_NONHUMAN_COMMUNICATION.md`,
`communication/REGISTRY.json`; the executed work is in
`collab/bend2-cubical/biosemiotic/` (README there has every run).*

## 0. The claim, exactly

What was asked: find all animal / plant / fungal communication ("language")
datasets, the literature, and the mathematics; connect them to this corpus's
mathematical endgame (the elucidator, the fibre law, the superposition
computer); and execute.

What is delivered, and nothing more:

1. **A registry** of the public datasets across taxa and modalities (acoustic,
   gestural, chemical, electrical), with access URLs, sizes, annotation type,
   and whether sequence structure is annotated — and a registry of what is
   *not* public (`communication/`).
2. **The literature map by mathematical construct**: information theory
   (Zipf, Menzerath–Altmann, entropy rate, mutual-information decay), formal
   language theory (Chomsky-hierarchy tests, k-reversible automata,
   compositionality tests), sequence models and latent spaces, unsupervised
   alignment / "translation" mathematics (Procrustes, Gromov–Wasserstein,
   the isomorphism assumption and its documented failures), compression and
   algorithmic information, symbolic dynamics — and, per method, exactly which
   conclusions the mathematics licenses (`communication/MATHEMATICS_…md`).
3. **The mapping** from those constructs onto the corpus's checked objects (§2
   below). Every row names the corpus term it refers to; none of the rows
   asserts a theorem the corpus has not checked.
4. **Execution on real data** (§3): the elucidator factoring
   `coda ≃ (tempo, rhythm)` run on the 8,718-coda Dominica sperm-whale dataset
   (Sharma et al. 2024), exactly in integers, verified on every coda, and run
   on the HVM4 interaction-net runtime as one superposition: elucidation,
   spec-driven search with erasure of failing branches, transport along the
   tempo fibre, the rhythm *class* recovered as a quotient by a lens with the
   lens resolution measured, and the cost regimes of superposition measured
   (including the one where it loses). Two discrete systems (Japanese tit
   ordering rule, Campbell's monkey affixation) as superposed acceptors.

**Not claimed.** No new theorem is added to the cubical corpus in this pass
(the pinned Agda toolchain is not installed in this container; the executable
is the raw HVM4 net plus a Python reference, the same pair `SUPGEN_DEMO.md`
uses). No "translation" of any non-human signal into meaning is claimed: what
the mathematics below licenses, and what was executed, is the *factoring* of
signal spaces into transport-invariant shape × fibre, the *quotient* that a
class label is, and *transport* between representations along an equivalence
that must be **supplied** — the corpus's own abstract 52/53 discipline: the
extractor runs; the collision is given. Plant and fungal signal datasets are
registered but not executed (their hosts — figshare, Zenodo — are blocked from
this container; the animal data came from GitHub).

## 1. What the corpus has that the field is reaching for

The field's stated program (Andreas et al. 2022 iScience, the CETI roadmap;
Earth Species Project) is: collect signal corpora → discover units → find
sequential/combinatorial structure → ground units in behavioural context →
"translate". Its mathematics, as actually used, is: clustering (units),
information theory (structure), latent embeddings (representation), and
cross-space alignment (translation). Each of these is a **projection** in the
README's sense (`weight = π(trace)`): a scalar or a point summarising a
process, with the process discarded.

The corpus holds, as checked terms, the objects those projections discard:

| corpus object | where | what it is |
|---|---|---|
| the fibre law `A ≃ Σ B (fiber f)` | `fibre/src/Fibre/Carrier.agda`; `collab/bend2-cubical/fibrelaw.bend` (35 ✓, runs on the net) | every map factors losslessly as (its visible projection, the fibre it forgot); the completion is unique (contractible) |
| the elucidator `m ≃ (start, shape)` | `collab/bend2-cubical/elucidator.bend`, `supfugue.bend`; abstract 50 | a sequence is its transport-invariant shape plus the fibre saying which transport; every fugue voice is one subject transported |
| observational equivalence is the truncation | abstracts 06, 12, 16, 22 | any evaluator into a discrete outcome domain factors through `‖derivation‖`; no function of the outcome separates two routes to it; the class is the *quotient*, the route is the fibre |
| the Nerode congruence computed | abstract 15; `port/MyhillNerodeMinimalMachine.bend` | the minimal observable state of a sensor family is an equality of types, not a bound; two readings each blind can be jointly faithful (abstract 18) |
| the unbounded fibre under pruning | abstracts 16, 28 | dedup / clustering selects one representative of an unbounded family by a criterion that is provably not a function of behaviour; counts, lengths and meaning are three different orders |
| superposed evaluation with erasure | `supgen_synthesize.hvm4`, `SUPGEN_DEMO.md`, `PUSC.md` | a candidate family is one term; a spec runs over it once with shared work; failing branches annihilate; survivors arrive certified by the erasure |
| transport across `ua` | `chain.bend`, `uaequiv.bend`, `RUNTIME_ALGEBRA.md` | a proved equivalence is a runtime path; moving data along it is a reduction; composite / inverse / Π / Σ lines run on the net |
| the lens as the observer boundary | abstract 45 | a quotient is lossless for the declared exact observers and lethal to the undeclared ones; quotienting before declaring the observer class is the error |
| generalisation vs shareability | abstract 03 | a skill carrying its training-state identification fires at exactly one state; the generalising form fires everywhere and costs nothing |

## 2. The mapping, construct by construct

Each row: the field's construct → what it computes → the corpus reading → what
that reading *adds or forbids*. Citations to papers are in
`communication/MATHEMATICS_OF_NONHUMAN_COMMUNICATION.md`.

### 2.1 Zipf / Zipf–Mandelbrot / Menzerath–Altmann fits

*Computes:* a rank–frequency (or length–constituent) slope over a unit
inventory; used as a "language-likeness" score (McCowan–Hanser–Doyle 1999 on
dolphin whistles; Semple 2010 gelada; Heesen 2019 chimp gesture; Youngblood
2024/Arnon 2025 humpback song; Ferrer-i-Cancho's critiques).

*Corpus reading:* a generating function of the unit-count fibre. Abstract 21:
"a generating function does not determine a bijection, and the difference is
a group action". A Zipf slope is a decategorified count; two inventories with
the same slope may differ by any relabelling and any grammar. Abstract 28:
cardinality is the wrong measure — "how many units", "how long is this
utterance", and "what does the family mean" are three orders on one object.

*What it forbids:* inferring structure (let alone meaning) from the slope.
The field's own critiques (Ferrer-i-Cancho; the random-typing argument) say
the same in statistical terms; the corpus says it as a type: the slope is a
function out of a truncation.

### 2.2 Entropy rate, Markov order, mutual-information decay

*Computes:* conditional entropies `H(x_n | x_{n-k}…x_{n-1})` and their limit;
MI(k) between symbols at distance k (Sainburg et al. 2019: power-law decay in
birdsong and speech; Kershenbaum 2014: vocal sequences are not the Markov
chains they were thought to be — renewal / hierarchical processes fit better).

*Corpus reading:* an entropy is `π(trace)` for the observer "next-symbol
predictor at window k". The Nerode congruence (abstract 15) is the exact
version: the minimal state is the kernel of the joint observation, and
whether the next observation factors through the current one *is* the
Markov question, decided as an equivalence of types rather than estimated.
Kershenbaum's finding that a renewal process fits better than a Markov chain
is, in this vocabulary, the statement that the observable *does not* factor
through the last k symbols — the Nerode class is larger than any k-window.

*What it adds:* the minimal automaton is computed, not fitted; two
observation families with the same lcm (same kernel) are indistinguishable by
theorem (abstract 15's "same multiple, same observations").

### 2.3 Formal-language tests and "syntax"

*Computes:* whether animals discriminate strings of an (AB)ⁿ vs AⁿBⁿ grammar
(Fitch & Hauser 2004; Gentner 2006; the Beckers–Berwick–Bolhuis critique that
finite-state strategies suffice for every published result); k-reversible
automata for birdsong (Berwick et al. 2011); ordering rules with behavioural
readout (Suzuki 2016 Japanese tit ABC-D; Engesser 2016).

*Corpus reading:* every one of these is an acceptor and its Nerode classes.
`collab/bend2-cubical/biosemiotic/tit_syntax.hvm4` runs the tit ordering rule
as a two-state acceptor over a superposition of candidate utterances: the
ungrammatical ones erase. The critique (finite-state suffices) is abstract
16 seen from the other side: the behavioural specification (accept / reject
on the tested strings) does not determine the grammar — the fibre of
grammars over the spec is unbounded, and "context-free" is a selection
inside that fibre by a criterion that is not a function of the behaviour.

*What it forbids:* attributing a grammar class from a finite accept/reject
table. What it adds: the ordering rule itself is an executable object that
composes (a spec over a superposition), not a p-value.

### 2.4 Compositionality tests (Berthet 2025 bonobo; Leroux 2023 chimp; Girard-Buttoz 2022)

*Computes:* whether the "meaning" (a behavioural-context vector) of a
combination is a function of the meanings of its parts — trivial (additive)
vs non-trivial (one part modifies the other) — via distances in a
context-feature embedding.

*Corpus reading:* compositionality is exactly "the readout factors through
the parts": `read(AB) = φ(read A, read B)`. The fibre law says every map
factors, and the question is only whether the factoring's fibre is
contractible (trivial composition) or not (the residue is where the
non-trivial part lives, `śeṣa`). Abstract 18 gives the shape: two readings
each blind that are jointly faithful — the pair carries what neither
component does.

*What it adds:* the test is a fibre-contractibility question, decidable on a
finite context table, rather than a distance threshold in an embedding.
The published critique of the bonobo result (Wartel et al. 2026, *PeerJ*
14:e21651: re-running the multiple-correspondence-analysis pipeline on
randomised data gives 35–84 % false positives; a permutation test that
recomputes the embedding gives p = 0.26) is the lens warning of abstract 45
in statistical form — the quotient (the embedding) was taken before the
observer class (the null that preserves the dependence structure) was
declared.

### 2.5 Latent spaces, UMAP / VAE repertoires, foundation models

*Computes:* a point per vocalisation (Sainburg 2020; Goffinet 2021; AVES,
BioLingual, NatureLM-audio, animal2vec); clusters = units; distances =
similarity.

*Corpus reading:* the embedding is a map `f : Signal → ℝⁿ`; the fibre law says
the lossless object is `Σ (y : ℝⁿ). fiber f y`, and the embedding alone is
lossless iff every fibre is a point. It never is (the encoder is a
projection by construction). Clustering on the embedding is the merge that
abstract 07/16's scheduler is forbidden to perform: it selects a
representative of the fibre. The corpus does not say "do not cluster"; it
says (abstract 45) declare the observer class first — the quotient is lossless
for exactly the observers that factor through it and lethal to the rest.

*What it adds:* a per-lens accounting. §3.3 below performs it on the whale
data: the number of shape nodes as a function of lens resolution, the purity
of each node against the human annotation, and the discovery that the
annotation mixes shape with fibre.

### 2.6 Alignment / "translation" (Conneau–Lample 2018; Alvarez-Melis–Jaakkola 2018; Søgaard–Ruder–Vulić 2018; Earth Species Project; CETI)

*Computes:* an orthogonal map (Procrustes) or an optimal-transport coupling
(Gromov–Wasserstein) between two embedding spaces, assuming they are
approximately isomorphic; adversarial refinement without parallel data.

*Corpus reading:* this is transport along `ua(e)` for an equivalence
`e : A ≃ B` — the README's "certified equivalence induces a path; a value
crosses the representation boundary by transport". The unsupervised
literature's "isomorphism assumption" is the assumption that `e` *exists*;
its documented failures (non-isomorphic spaces across typologically distant
languages, Søgaard 2018; Vulić 2020) are the statement that the fibre of the
best alignment is not contractible. Gromov–Wasserstein is a scalar
(`π(trace)`) of the relational structure; the corpus keeps the coupling as
the object. Abstract 24 (cost and inverse cannot coexist) and abstract 30
(the transpose is a dagger, never an inverse) bound what a learned map can be:
a Procrustes solution is a dagger; the inverse exists only on the
contractible-fibre locus.

*What it forbids:* calling a Procrustes/GW alignment a translation. What it
adds: when an equivalence *is* supplied (a proved one, or one certified by a
round trip on the data), transport along it runs on the net, composes, and
inverts (`chain.bend`; §3.4 executes the tempo-fibre transport on real
codas). The discipline is abstract 52/53's: the extractor is a function; the
collision — here the equivalence between two species' signal spaces — is
**given**, and finding it is the frontier the field names honestly (Yovel &
Rechavi 2023; Rendall–Owren–Ryan 2009's "influence, not information").

### 2.7 Compression, MDL, algorithmic information

*Computes:* Lempel–Ziv / NCD / grammar-induction (ADIOS) complexity of a
sequence corpus as a structure measure; MDL for repertoire size.

*Corpus reading:* "compression is transport" — `elucidator.bend`'s header. A
compressor that keeps the decoder is a lossless factoring; its "subject" is
the shape and its dictionary is the fibre; abstract 20: the deduplication
store is the expensive object. Kolmogorov complexity of a single string is
the length lens of abstract 50 (the elucidator's three lenses: length, depth,
meaning — the length lens separates routes the meaning lens identifies).

### 2.8 Plant electrophysiology and fungal spike trains (Adamatzky 2022; Volkov; Khait 2023)

*Computes:* spike detection, inter-spike-interval clustering into "words",
word-length distributions compared to human languages.

*Corpus reading:* identical to the coda case — inter-spike intervals are
inter-click intervals; the "word" is a lens quotient on the interval vector;
the Zipf comparison is §2.1. The executed coda pipeline applies verbatim to
Adamatzky's Zenodo recordings (records 5790768, 3997031, 1451496) and to
Khait et al.'s plant ultrasonic clicks (Dryad 10.5061/dryad.jwstqjqf7) once
fetched (blocked here; see the registry's access column). The sceptic
literature — Blatt, Pullum, Draguhn, Bowman, Robinson & Taiz 2024 (*Fungal
Ecology* 68:101326: the "words" are analyst-chosen thresholds on a signal
that may be electrode artefact, with no receiver test); Buffi et al. 2025
(*FEMS Microbiol. Rev.*: shielding, drift, no identified channel); Karst,
Jones & Hoeksema 2023 on mycorrhizal-network overclaims — is the lens
warning of abstract 45 in biological dress: the word boundary is a lens,
the lens was not declared, and the Zipf-like length distribution that
survives it is §2.1's decategorified count. The one independent,
Faraday-caged confirmation that *some* fungal electrical activity is
biological (biocide-sensitive) is Buffi et al. 2025 *iScience* 28:113484.

### 2.9 The receiver's invariances, not the analyst's

The elucidator's "shape" is whatever the declared transport leaves fixed.
For codas the transport is tempo scaling and the invariant is Sharma et
al.'s rhythm, which their playback-free analysis treats as the whales'
category; the biology has not yet tested it by playback. For birdsong the
obvious transport (pitch transposition) is the wrong one: starlings
generalise on spectral shape, not pitch (Bregman, Patel & Gentner 2016,
*PNAS* 113:1666), and songbirds weight absolute pitch far more than humans
(Hulse & Cynx 1985; Weisman et al. 2004). A factoring is a claim about
which fibre the receiver discards; the corpus can compute any declared one
and certify its losslessness, but which one is *the animal's* is an
empirical datum the registry's "pairs signal with context" column tracks.

## 3. What was executed (summary; details and every number in `collab/bend2-cubical/biosemiotic/README.md`)

### 3.1 The factoring is an identity on real data

Dominica codas (8,718 rows; 8,696 with all intervals present), intervals in
ms, exact shape = vector / gcd, fibre = gcd: `coda == gcd * shape` for
8,696 / 8,696. On the HVM4 net, `coda_exact_roundtrip.hvm4` reconstructs an
18-coda superposition from its `#Coda{fibre, shape}` pairs and returns 1 on
every branch (1,624 interactions).

### 3.2 The elucidation over a superposition

`@elucidate = λ&c. #Coda{@tempo(c), @shape(c)}` over 18 real codas as one
`&L{…}`: 18 `#Coda{tempo, rhythm}` terms in one pass (3,843 interactions).

### 3.3 The class is the lens (the substantive result)

At the data's own resolution, 8,696 codas are 8,440 distinct exact shapes.
The 34 annotated rhythm types are a quotient by a coarser observation. The
lens table (EC1 clan, 7,268 non-noise codas):

| lens R (bins / unit) | shape nodes | largest node | purity vs annotation |
|---|---|---|---|
| 1000 | 6,950 | 3 | 0.999 |
| 100 | 3,086 | 86 | 0.935 |
| 20 | 632 | 1,428 | 0.869 |
| 10 | 216 | 3,230 | 0.727 |
| 3 | 97 | 2,702 | 0.701 |
| 2 | 45 | 4,741 | 0.422 |

At R = 10 the largest node `(3,3,2,2)` holds 2,068 codas annotated `1+1+3`
and 1,136 annotated `5R1`: same rhythm, different tempo (≈1 s vs ≈0.33 s).
**The human annotation scheme mixes shape with fibre**; the factoring
separates them, recovering Sharma et al.'s own rhythm × tempo independence
from the raw intervals with no clustering. On the net (`coda_lens10.hvm4`)
the collapse prints equal terms for codas of one class.

### 3.4 Search inside evaluation, and transport along the fibre

`coda_spec.hvm4`: keep the codas whose R = 10 shape is `[3,3,2,2]`; the rest
erase. Survivors: one 1+1+3 coda and two 5R1 codas (2,745 interactions), the
answer certified by the erasure. `coda_transport.hvm4`: a 5R3 coda's rhythm
at a 5R1 coda's tempo → `[83,81,81,84]` beside the real 5R1 `[81,77,74,80]`:
"5R1 is 5R3 transported along the tempo fibre", computed.

### 3.5 Cost regimes, measured honestly

18 independent codas down 18 independent lines: superposed 2,803 vs separate
1,326 interactions (ratio 2.11 — superposition **loses**, as
`SYNTHESIS.md` §4 predicts for branches that share no work). Plain vs
ornamented coda (shared prefix, superposed tail): 1,230 vs 1,164 (1.06,
break-even: the prefix sum is shared, the normalisation is not). The
saving the corpus measured (one line over many values, 0.37 at N = 8) is not
available for factoring independent signals; it is available for moving a
batch of signals along one proved equivalence, which is the translation
step, not the factoring step.

### 3.6 Discrete systems

Japanese tit ABC-D ordering rule as a Nerode acceptor over six candidate
utterances: `[D,ABC]` and `[D]` erase, four survive (514 interactions).
Campbell's monkey `-oo` affixation: six calls factored to `#Call{root,
affix}` in one pass (114 interactions).

## 4. The frontier, stated exactly (what would make "translation" a term)

Translation between signal spaces `A` (species / individual / context 1) and
`B` (2) is, in this calculus, `transport(ua e)` for `e : A ≃ B` — or, when no
equivalence exists, the fibre law's completion `A ≃ Σ b:B. fib_f(b)` for a
map `f`, with the residue `fib_f` carried rather than dropped. Three things
are therefore required, and the corpus supplies the first two:

1. **The factoring of each space** into shape × fibre by its own
   transport-invariants (executed above for temporal codas; the same program
   applies to any interval sequence, and to symbol sequences via the
   acceptor).
2. **The transport machinery** once `e` is given (`chain.bend`,
   `uaequiv.bend`, `fibrelaw.bend`: composite, inverse, Π/Σ lines, all on
   the net).
3. **The equivalence `e` itself**, or the map `f` and its grounding. This is
   the field's open problem and it is not a computation over the signal
   corpus alone: abstracts 06/12/22 prove that no function of the outcome
   (behaviour, context vector, embedding) selects the route; Piantadosi–Hill
   2022 and Mollo–Millière 2023 say the same about distributional meaning.
   What the corpus adds is the *shape* of the missing datum: it is a fibre
   over the behavioural readout, and abstract 18 says two blind readings
   (e.g. acoustic structure and behavioural context) can be jointly faithful
   where each alone is not. That is a concrete instruction for dataset
   design — record the paired readings, not the marginals — and every
   dataset in the registry is tagged by whether it does.

Absences the survey established, each a construction the corpus could
supply because it already holds the object: no peer-reviewed application of
ε-machines / computational mechanics, of persistent homology, of normalised
compression distance, or of ADIOS-style grammar induction to any animal
vocal repertoire; no CETI or Earth Species Project paper that performs an
actual cross-species embedding alignment (the "translation" framing lives
in programme statements). The Nerode machine (abstract 15) *is* the
ε-machine's causal-state construction done as an equality of types, and
`port/MyhillNerodeMinimalMachine.bend` runs it.

Next constructions, in order: (i) the coda pipeline as a Bend2 file under
`--total` with the per-mille lens as a `Path` (the Python + raw-HVM4 pair
here is the same trust level as `SUPGEN_DEMO.md`; the cubical certificate is
the next rung); (ii) the same run on Adamatzky's fungal inter-spike intervals
and Khait's plant ultrasonic emissions when the hosts are reachable; (iii)
the Nerode machine of `port/MyhillNerodeMinimalMachine.bend` instantiated on
Bengalese-finch syllable sequences (Koumura 2016; Nicholson 2017) — the
k-reversible claim of Berwick 2011 as a computed minimal automaton rather
than a fitted one; (iv) the joint-reading construction of abstract 18 on a
dataset that pairs signal with context (the registry marks which do).
