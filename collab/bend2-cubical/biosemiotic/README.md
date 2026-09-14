# biosemiotic — the elucidator run on real non-human communication data, on the net

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

## Files

    coda_elucidator.py   reads the CSV; exact & per-mille factoring; lens table; emits out/coda_*.hvm4
    coda_regimes.py      lens-10, spec, transport programs; cost regimes; writes out/RESULTS_regimes.txt
    tit_syntax.hvm4      Japanese tit ordering rule over a superposition
    campbell_affix.hvm4  Campbell's monkey root × affix factoring
    out/                 generated programs, sample_codas.tsv, lens_resolution.tsv, python_run.log
    RESULTS.txt          the runs, verbatim
