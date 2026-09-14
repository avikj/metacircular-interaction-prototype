# biosemiotic — the fibre-law factoring run on real non-human communication data, on the net

*Naming, corrected after reading the Agda: what runs here is the fibre law
(`fibre/src/Fibre/Carrier.agda`, `SarvavibhagaH`, `Vishvayantra.lossless`)
applied to the map ICIs ↦ rhythm, in the form `../elucidator.bend` gives it.
It is not `formal/cubical/kernel/Vivarana`, the corpus's elucidator proper,
which is the unique fold of the initial derivation type (`AdiBija`) across a
lens family. The lens table in §3 is `ApurvaIndriyam` measured (a coarser
lens descends along a finer one and is blind on its fibres; `1+1+3` vs `5R1`
is an `अपूर्वम्` pair certifying tempo as a sense distinct from rhythm), and
§7 is a `NerodeYantra` failure measured through a set-valued shadow. See
`research/NONHUMAN_COMMUNICATION_20260914.md` §0.2.*

The corpus's factoring `m ≃ (start, shape)` (`../elucidator.bend`, the fibre law
`A ≃ Σ B (fiber f)` of `../fibrelaw.bend`) applied to published animal
communication data, executed on the real HVM4 interaction-net runtime
(HigherOrderCO/HVM4, `gcc -O2 -o src/hvm src/hvm.c`), with the same program
shape as `../supfugue.bend` and `../supgen_synthesize.hvm4`: the whole sample
is handed in as ONE superposition, the factoring commutes over it, failing
branches erase, and the survivors are enumerated by `-C`.

Every number below was produced by running the files in this directory; the
runs are reproduced by

    HVM=/path/to/hvm4/src/hvm python3 coda_elucidator.py DominicaCodas.csv   # writes out/*.hvm4 and runs the analysis
    HVM=/path/to/hvm4/src/hvm python3 coda_regimes.py                       # writes out/RESULTS_regimes.txt
    hvm tit_syntax.hvm4 -s -C20 ; hvm campbell_affix.hvm4 -s -C20

`DominicaCodas.csv` is the public dataset of Sharma, Gero, Payne, Gruber, Rus,
Torralba & Andreas, *Contextual and combinatorial structure in sperm whale
vocalisations*, Nature Communications 15:3617 (2024), from
https://github.com/pratyushasharma/sw-combinatoriality (Dominica Sperm Whale
Project, 2005–2018; 8,718 codas; nine inter-click-interval columns; annotated
`CodaType`; clan; social unit). The paper's own factoring of a coda into
**rhythm** (the inter-click-interval vector normalised by total duration,
tempo-invariant) and **tempo** (the duration) IS the elucidator's
(shape, fibre) reading: shape = rhythm, fibre = tempo.

## 1. The factoring is an identity on every real coda (Python, then the net)

Inter-click intervals in milliseconds; exact shape = the vector divided by its
gcd; fibre = the gcd. `coda == gcd * shape` holds for **8,696 / 8,696** codas
(22 rows with a zero/absent interval are excluded). On the net,
`out/coda_exact_roundtrip.hvm4` reconstructs each coda of an 18-coda
superposition from its `#Coda{fibre, shape}` pair and compares it structurally
(`===`) with the original: **1 on every branch, 1,624 interactions** total.

## 2. The elucidation runs over the superposition (`out/coda_superposition.hvm4`)

18 real codas (types 5R3, 1+1+3, 4R2, 5R1, 3R, 4D; three each) as one
`&L{…}` superposition; `@elucidate = λ&c. #Coda{@tempo(c), @shape(c)}` applied
once. Output (collapse): 18 `#Coda{tempo_ms, rhythm_permille}` terms,
3,843 interactions. `out/coda_shape_only.hvm4` reads only the shape: 2,803.

## 3. What the data actually says about "the rhythm class" — the lens result

At millisecond resolution almost every coda is its own shape node:
8,696 codas → **8,440 distinct exact shapes** (8,360 per-mille rhythms); only
252 exact shapes carry more than one coda, and those are mostly literal
repeats at the same tempo. The annotated rhythm *classes* (34 `CodaType`
labels; 24 non-noise in clan EC1) are therefore **not** an identity of shapes
at the data's own resolution. They are a quotient by a coarser observation —
exactly the corpus's statement that the class lives in the lens, and the exact
fibre is unbounded (abstract 16, "pruning by observational equivalence
collapses an unbounded fibre"). Reading the 7,268 EC1 non-noise codas through
lenses of decreasing resolution R (bins per unit of normalised duration):

| lens R | shape nodes | largest node | purity (nodes of one annotated type) |
|---|---|---|---|
| 1000 | 6,950 | 3 | 0.999 |
| 200 | 5,066 | 17 | 0.979 |
| 100 | 3,086 | 86 | 0.935 |
| 50 | 1,632 | 333 | 0.886 |
| 20 | 632 | 1,428 | 0.869 |
| 10 | 216 | 3,230 | 0.727 |
| 5 | 160 | 3,002 | 0.800 |
| 3 | 97 | 2,702 | 0.701 |
| 2 | 45 | 4,741 | 0.422 |

At R = 10 the largest node, shape `(3,3,2,2)`, holds 2,068 codas annotated
`1+1+3` and 1,136 annotated `5R1`: the two annotated types have the SAME
rhythm and differ in TEMPO (1+1+3 ≈ 0.8–1.2 s; 5R1 ≈ 0.33 s). The annotation
scheme mixes the shape with the fibre; the factoring separates them. This is
Sharma et al.'s own finding (rhythm × tempo are independent axes) recovered
from the raw intervals by the elucidator with no clustering step.

`out/coda_lens10.hvm4` runs the R = 10 lens over the 18-coda superposition on
the net (2,813 interactions): the collapse prints equal terms for codas of one
class — `[3,3,2,2]` three times, `[5,3,2]` three times, `[4,3,3]` and
`[3,2,2,3]` twice.

## 4. Search inside evaluation (`out/coda_spec.hvm4`) and transport (`out/coda_transport.hvm4`)

Spec: keep the codas whose R = 10 shape is `[3,3,2,2]`; every other branch
erases (`&{}`). Survivors: the 1+1+3 coda `[242,231,171,145]` and the two 5R1
codas `[89,92,77,71]`, `[102,95,75,66]` — 2,745 interactions for the whole
search, the answer certified by the erasure of the alternatives (SupGen's
mechanism, `../SUPGEN_DEMO.md`).

Transport along the fibre: the rhythm of a 5R3 coda (`[357,350,347,363]`,
tempo 1,417 ms) re-expressed at a 5R1 coda's tempo (329 ms) gives
`[83,81,81,84]` (148 interactions) — next to the real 5R1 coda
`[81,77,74,80]`. "5R1 is 5R3 transported along the tempo fibre" is the
dataset's own naming (5 regular clicks, tempo 1 vs 3) computed rather than
annotated.

## 5. Cost regimes, measured (the honest part; cf. `../SYNTHESIS.md` §4)

| regime | superposed | separate | ratio |
|---|---|---|---|
| 18 different codas down 18 different lines (R = 1000 lens) | 2,803 | 1,326 | **2.11** |
| plain coda vs its ornamented twin (shared prefix, superposed tail), 6 pairs | 1,230 | 1,164 | **1.06** |

Superposition does **not** pay for factoring independent codas: the branches
share nothing, and the corpus's measured penalty for that regime (~1.4×)
reappears here larger (2.1×) because the per-branch work is tiny. The
ornamentation case (Sharma et al.'s ornament = an extra terminal click; the
plain and ornamented coda share every interval but the last) shares the prefix
sum but not the normalisation, whose divisor differs — break-even. The sharing
that pays is one LINE over many values (a proved equivalence moving a batch),
not many values down many lines. The claim this directory supports is
therefore exactly: the factoring, the class-as-lens, the spec-search and the
transport all *run* on the net over real data; the parallel-superposition
saving is available only where downstream work is invariant across branches.

## 6. Discrete syntax: two more published systems, hand-encoded

`tit_syntax.hvm4` — Japanese tit call combinations (Suzuki, Wheatcroft &
Griesser 2016, Nature Communications 7:10986): ABC-D is understood, D-ABC is
not. The ordering rule as a two-state acceptor (the Nerode classes) run over a
superposition of six candidate utterances: survivors `[ABC,D]`, `[ABC]`,
`[ABC,D,ABC,D]`, `[ABC,ABC,D]`; `[D,ABC]` and `[D]` erase. 514 interactions.

`campbell_affix.hvm4` — Campbell's monkey `-oo` suffixation (Ouattara,
Lemasson & Zuberbühler 2009, PNAS 106:22026): six calls as one superposition
factored to `#Call{root, affix}` in one pass, 114 interactions.

Both are the elucidator on symbols instead of intervals; neither adds a claim
beyond the published finding it encodes.

## 7. The exchange: rubato is the fibre moving while the shape holds (`coda_exchange.py`, `out/coda_exchange.hvm4`)

The dataset's second file, `sperm-whale-dialogues.csv` (3,840 codas, 2014–2018,
with whale identity, recording and onset time), is the temporally ordered
subset. Sharma et al. define **rubato** as the smooth drift of tempo across
consecutive codas of one rhythm by one whale inside an exchange. In the
corpus's terms an exchange is an interaction history (README §6, §13);
consecutive codas are its states; the interaction's transport witness at
each step is *what stayed* (the shape) and *what moved* (the fibre).

Measured on the 2,637 consecutive same-whale coda pairs within 6 s (Sharma
et al.'s window), against a null of random same-whale pairs:

| | consecutive pairs | random same-whale pairs |
|---|---|---|
| lens-10 shape preserved across the step | **51.0 %** (1,344 / 2,637) | 36.9 % |
| median \|tempo drift\| when the shape is preserved | **17 ms** | 116 ms |
| median \|tempo drift\| when the shape changes | 34 ms | — |

The shape crosses the step more often than chance and, when it does, the
fibre moves by a few percent of the tempo: that small, signed motion of the
fibre along the braid *is* rubato, read off the factoring with no feature
engineering. On the net, `out/coda_exchange.hvm4` hands 16 real consecutive
pairs (8 shape-kept, 8 shape-changed) to one function `@step` returning
`#Step{shapeKept, drift}` per interaction step — the transport witness of
each step as data — 9,178 interactions; every branch agrees with the Python
table in `out/exchange_pairs.tsv`. (Structural `===` on two lazily built
lists stays stuck under a superposition in collapse mode; list equality is
therefore written as a strict recursion, `@eqL`.)

## 8. The whole instrument, run (`full_instrument.py`, `nerode_net.py`; log in `out/instrument_run.log`)

Each reading below is named by the checked term that licenses it. All
numbers are from one run on the two public files.

### 8.1 The rhythm types are Piṅgala metres (`theorems/metre`: `MatraVarnaGuru`, `PrastaraPankti`, `Matramerus`, `Meru`)

Read each coda's intervals in units of its shortest interval: an interval of
one unit is laghu, of two or more is guru. A coda is then a laghu/guru
word, a mātrā-vṛtta, and its mātrā is `matraOf` (laghu 1, guru 2). The
annotated rhythm types come out as single metres with no clustering:

| annotated type | dominant metre | share | distinct metres |
|---|---|---|---|
| 1+1+3 | GGLL | 0.95 | 5 |
| 5R1 / 5R2 / 5R3 | LLLL | 0.56 / 0.99 / 0.99 | 10 / 3 / 3 |
| 4R2 | LLL | 0.98 | 4 |
| 4D | GLL | 0.65 | 3 |
| 7D1 | GGGLLL | 0.44 | 10 |

The repertoire against Piṅgala's counts: for 4-interval codas (6,383 of
them) the whales use 14 of the 16 metres of saṅkhyā 2⁴; the Meru row is
occupied 1/1, 4/4, 5/6, 4/4, 0/1 for k = 0…4 guru (the all-guru row is
unreachable by construction, since the shortest interval is always laghu).
By mātrā weight, against Virahāṅka's count `length (सर्व n)`: weight 5 uses
8 / 8, weight 6 uses 9 / 13 (and carries 3,921 codas, the GGLL type),
weight 7 uses 16 / 21, weight 8 uses 19 / 34, and above weight 10 the
repertoire thins to a few percent of the prastāra. The Nārāyaṇa samāsa over
{1,2,3,…} (the full mora vector) has 405 distinct vectors; the top four are
(2,2,1,1), (1,1,1,1), (1,1,1), (2,1,1,1).

On the net, `out/prastara_meru.hvm4` hands all 16 four-syllable metres to
`@meru` as one superposition and sorts each into its Meru cell
`#Cell{varṇa, guru, mātrā}` in one pass (3,056 interactions; the cells
enumerate C(4,k) with mātrā = varṇa + guru on every branch, the theorem
`मात्रा-वर्ण-गुरु` observed branch by branch). `out/prastara_spec.hvm4` keeps
only the metres that real 4-interval codas use most: survivors `[2,2,1,1]`,
`[2,1,1,1]`, `[1,1,1,1]`; the other 13 erase (3,387 interactions).

### 8.2 The readout does not factor along time (`NerodeYantra`)

`nerode-saṅkoca` says: if `out ∘ δ ≡ g ∘ out`, the Nerode relation is the
kernel of one observation. On each whale's ordered codas (lens-10 class,
257 classes):

| k | H(next \| last k) bits | shuffled null |
|---|---|---|
| 0 | 4.324 | 4.324 |
| 1 | 2.479 | 3.463 |
| 2 | 1.615 | 2.188 |
| 3 | 1.003 | 1.107 |

The next class is the most likely one given the current in 54 % of steps;
a factoring would give 100 %. The state of a whale in an exchange exceeds
its readout at every window measured. `nerode_net.py` learns the k = 1
transition support from half the dialogues (156 classes, 522 transitions)
and runs it on the net as an acceptor over a superposition of held-out
sequences: 4 of 10 survive, the rest erase (16,314 interactions), agreeing
with the Python check.

### 8.3 What crosses between whales is the metre, at the receiver's own tempo (`TheEncounterOfTwoPeers`, README §6)

A coda by whale B within 6 s of a coda by whale A, against same-whale steps
and random pairs:

| step | n | lens-10 shape kept | metre kept | same click count | median rel. \|Δtempo\| when metre kept |
|---|---|---|---|---|---|
| same whale | 1,211 | 51.0 % | 71.9 % | 81.8 % | 0.021 |
| cross whale, overlapping (chorus) | 906 | 19.3 % | 51.0 % | 63.9 % | 0.077 |
| cross whale, non-overlapping | 1,210 | 23.0 % | 50.4 % | 65.0 % | 0.082 |
| random pairs | 6,000 | 18.8 % | 35.7 % | 60.9 % | 0.214 |

At the fine lens nothing crosses between whales (19–23 % against a 19 %
null). At the metre lens half of all cross-whale steps carry the metre
over (51 % against 36 %), and the receiver re-expresses it at its own tempo
(8 % apart, against 2 % within a whale and 21 % at random). Whether the
codas overlap or not makes no difference. So the encounter's transport is
the metre and its fibre is the tempo, and which lens shows the transport is
itself a finding: the transported invariant is coarser than the invariant a
single whale keeps. Revelation (README §6, "B now has A's shape") is
measurable here; generation (a new shape appearing at B) is the other half
of every cross-whale step.

### 8.4 Sign birth: the lens where compression stops paying (hieroglyphics II, `Laghava`)

`चिह्नजन्म ⟺ संरचनासंपीडनलाभ > 0`: a sign is born only when it compresses more
than it costs. A two-part code of the 7,268 EC1 codas (10 bits per class
centroid coordinate; per coda `log₂ K` for the sign plus a residual per
interval in per-mille): total bits by lens R — 194.3k at R = 1 (12 signs),
192.6k at R = 3 (97), **185.3k at R = 8 (144 signs, 25.5 bits per coda)**,
199.6k at R = 10 (216), 205.9k at R = 20 (632), 267.0k at R = 100 (3,086).
The code is a reading; the shape of its minimum is the point: adding signs
pays until roughly 140 of them and costs thereafter. Sharma et al.'s 18
rhythms × 5 tempos is 90 composite signs, in the same range.

### 8.5 The Zipf slope is a function of the lens (abstracts 21, 28)

Rank–frequency slope of class frequencies: −2.04 at R = 2, −1.96 at R = 3,
−1.60 at R = 10, −1.23 at R = 20, −0.96 at R = 50, −0.71 at R = 100, −0.10
at R = 1000. The one number the field reports as a property of a species is
a decategorified count whose value is set by the analyst's lens.

### 8.6 The tempo trajectory's modulus (`SthairyaSutra`)

Same-whale steps with the shape kept: relative |Δtempo| median 0.021, p90
0.065, p99 0.130 (absolute: median 17 ms, p90 50 ms, p99 123 ms, max 546 ms).
Rubato is a small, bounded motion of the fibre per crossing.

## Files

    coda_elucidator.py   reads the CSV; exact & per-mille factoring; lens table; emits out/coda_*.hvm4
    coda_regimes.py      lens-10, spec, transport programs; cost regimes; writes out/RESULTS_regimes.txt
    coda_exchange.py     rubato as fibre motion along real exchanges; emits out/coda_exchange.hvm4
    full_instrument.py   metre/prastāra, Nerode deficit, encounter, sign-birth MDL, Zipf-vs-lens, Lipschitz; emits out/prastara_*.hvm4
    nerode_net.py        a Nerode acceptor learned from half the dialogues, run on the net over held-out sequences
    tit_syntax.hvm4      Japanese tit ordering rule over a superposition
    campbell_affix.hvm4  Campbell's monkey root × affix factoring
    out/                 generated programs, sample_codas.tsv, lens_resolution.tsv, python_run.log
    RESULTS.txt          the runs, verbatim
