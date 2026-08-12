# Prosodic recursion as a one-shot arithmetic transformation

**Status:** elementary exact mathematics with a historically bounded source
note. No anticipation claim is made.

## The learner problem

A line has total duration 12. Each syllable is either light, lasting one beat,
or heavy, lasting two beats. How many ordered rhythms are possible?

Do not list them. Look only at the first syllable.

- If it is light, delete it. What remains is any rhythm of duration 11.
- If it is heavy, delete it. What remains is any rhythm of duration 10.

Both deletion maps are bijections, and the two cases are disjoint. If `M(n)`
is the number of rhythms of duration `n`, then

\[
M(n)=M(n-1)+M(n-2),\qquad M(0)=M(1)=1.             \tag{1}
\]

One pass gives

\[
1,1,2,3,5,8,13,21,34,55,89,144,\boxed{233}.
\]

That is the complete solution. The formation event is not the resulting
sequence but the coordinate change

\[
\text{all rhythms of weight }n
\longrightarrow
\bigl(\text{light first},\text{heavy first}\bigr),
\]

which turns a global enumeration into two smaller copies of itself.

## A second exact view

If a rhythm has `k` heavy syllables, then it has `n-2k` light syllables and
`n-k` syllables altogether. Choose which `k` of those positions are heavy:

\[
M(n)=\sum_{k=0}^{\lfloor n/2\rfloor}\binom{n-k}{k}. \tag{2}
\]

For `n=12`, this is

\[
1+11+45+84+70+21+1=233.
\]

Equations (1) and (2) are two compositional observations of the same finite
set: split by the first syllable, or split by the number of heavy syllables.

## Executable artifact

`machinery/prosodic_recurrence.py` constructs the rhythms, checks both deletion
bijections, computes (1) without enumeration, and checks (2). The tests include
all durations through 12 and the answer 233.

## Historical boundary

Indian prosody classified patterns of light (`laghu`) and heavy (`guru`)
syllables and developed recursive counting procedures. The relevant lineage is
Piṅgala's *Chandaḥśāstra*, later made more explicit by Virahāṅka and Halāyudha.
A modern note reproducing Virahāṅka's verses and Halāyudha's commentary/diagram
is [Siddhartha Gadgil, “Some Mathematics in Virahanka's
Vṛttajātisamuccaya”](https://people.csail.mit.edu/siddhartha/english-work/Vrttajatisamucchaya.pdf),
especially its source discussion and §§2–3.

The terms “Fibonacci sequence,” “binary,” “dynamic programming,” and the exact
AIME-style presentation above are modern mathematical extractions. We do not
attribute those formulations to Piṅgala, collapse the several historical
layers, or claim anticipation of modern computation. The exact arithmetic
stands independently of the historical interpretation.
