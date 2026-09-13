# The corpus as one mathematical object

The compact object by which to understand the whole repo is **not** any
file/import structure (an accident of how sources are filed, carrying no
mathematics). It is the corpus collapsed by **equivalence of the mathematics
itself** — the normal form of each declaration's type. `Fibre.CorpusNF`
computes it: `getType` then `normalise` gives a declaration's definitional
normal form; a canonical de-Bruijn serialisation is the key; two declarations
are the **same proposition** iff their keys are equal, independent of module.
`scripts/corpus-probe-run.py --nf` runs it; `scripts/nf-relate.py` reads the
relations off the normal forms.

## The quotient (pin: Agda 2.8.0 / cubical v0.9)

- declarations normalised     : **28608**
- distinct propositions (nf)  : **16843**   (collapse ratio **1.70×**)
- excluded (normalise exceeded the per-chunk/-single timeout — types that
  embed heavy computation; an honest machine limit, ~574 declarations)

The corpus is mostly **non-redundant** (16843 genuinely distinct
propositions); the 1.70× collapse is real restatement — the same proposition
proven or posited in more than one place.

## What the corpus is *made of* (relations, read off the normalised types)

The named objects that occur most in the **types** of the propositions — this
is a mathematical relation (A is an ingredient of B's statement), not an import:

Library alphabet: `PathP` 10629 (identity/paths — the corpus is, first of all,
about *equality*), `Σ` 7208 (structures/existentials), `ℕ` 7932, `Bool` 3873,
`List` 3527, `⊥` 2835 (refutation — much of the corpus states impossibilities),
`ℤ` 1674, `isEquiv` 940, propositional truncation `∥_∥₁` 599.

**Corpus-internal spine** — the repo's own concepts recurring across theorem
*types*, i.e. the objects the mathematics is actually built on:

| in the type of … propositions | object | meaning |
|--:|---|---|
| 387 (+ variants) | `RewriteCertificate.Tm` | the term language of the certified rewrite kernel — THE central object |
| 200 | `RewriteCertificate.Derivation` | its certificate/derivation calculus |
| 133/107/102/80 | `Tm.add / .var / .zero / .suc` | that term language's constructors |
| 236/122 | `KarmaKanda….Tm / .eval` | a compiled, path-free body of the same term calculus |
| 119 | `Vishvayantra…` | Turing step = visible projection of a lossless step |
| 108 | `PingalaPrastara.Syllable` | Pingala's prosody / positional combinatorics |
| 107 | `FutureBehavior.run` | the coinductive behaviour (future-equality) |
| 104 | `Nirjara….Sutra` | primitive-shedding cost calculus |
| 90 | `Saptabhangi.सप्तभङ्गी` | the sevenfold (Jain) logic of standpoints |

So the whole corpus, read as one object, is: **a body of ~16800 distinct
propositions, overwhelmingly about identity (`PathP`) and impossibility (`⊥`)
over a certified term-rewriting kernel (`RewriteCertificate.Tm` and its
derivations), specialised through a lossless machine model, positional
combinatorics, and many-valued logic.** That is the mathematical content, and
it is recovered by collapsing equivalences — not by looking at the file tree.

---

# Corpus self-presentation (chunked, memory-safe)

The corpus presents itself: every checked public declaration is reflected
through the corpus's own machinery (`Fibre.CorpusReflection` /
`Fibre.CorpusLoci`) and grouped by the finite observation it exposes.

## The problem this solves

The whole-corpus readout (`generated/CorpusRepository.agda`) imports every
module into one Agda process and `quoteTC`s one giant reflected term. That
holds every transitive interface in a single heap — **~12 GB, and dead on any
red module**. That ceiling is a property of *aggregating in one process*, not
of the machine: no amount of RAM makes a single `import`-everything module
scale.

## The design

`Fibre.CorpusProbe` keeps the same checked reflection semantics but **never
aggregates**: it folds `debugPrint` over the declarations and quotes nothing.
`scripts/corpus-probe-run.py` drives it in chunks:

- reuse `run-corpus-calculus`'s exact importable module set (1957 modules);
- split into `CHUNKSZ`-module chunks; each chunk imports **only its own slice**
  and streams one row per declaration;
- run chunks in parallel, each in its own temp dir against the **warm** library
  cache (only the tiny chunk compiles);
- self-heal inaccessible source-scraped names (drop the `NotInScope` line and
  retry — the trailing-`∷` list stays valid);
- **singleton recovery**: a chunk lost whole to one module's hard error is
  re-run one module per chunk, so a red module costs only itself;
- group rows into meaning-loci here, outside Agda.

A red module fails only its own chunk. **Peak memory stays ~1.9 GB across the
whole corpus** — flat and independent of corpus size.

Two readouts share the harness:

    python3 scripts/corpus-probe-run.py                  # whole corpus (DECL)
    python3 scripts/corpus-probe-run.py --loci --limit N # realization families

- `emitDecls` (O(n)) — `DECL <Π-arity> <conclusion-head> <def-kind> <name>`:
  the observation `q(decl) = (dependent Π-arity, elaborated conclusion head)`,
  plus the reflected definition kind.
- `emitLoci` (O(n²) per chunk) — `LOCUS <Π-arity> <result-head> <generator>
  <realized-on>`: `Fibre.CorpusLoci`'s exact Agda-accepted realization family
  for each generator (which applications type-check, and to what normalized
  result). Bounded with `--limit`.

## Result (pin: Agda 2.8.0 / cubical v0.9)

- modules presented: **1957**
- checked declarations: **29182**
- meaning-loci (arity, head): **4771**  (singleton loci: **2875**)
- by definition kind: function **26258**, constructor **2058**, data **481**,
  record **385**
- peak memory: **~1.9 GB** (vs. ~12 GB for a single whole-corpus import)

Largest meaning-loci (residual fibre = declarations sharing the observation):

| Π-arity | conclusion head | residual |
|--------:|-----------------|---------:|
| 0 | `_≡_` (Path) | 2524 |
| 1 | `_≡_` | 1803 |
| 2 | `_≡_` | 1205 |
| 0 | `¬_` | 1172 |
| 0 | `Sort` | 1030 |
| 3 | `_≡_` | 1025 |
| 2 | `Nat` | 894 |
| 1 | `Nat` | 657 |
| 2 | `Sort` | 626 |
| 1 | `Sort` | 588 |
| 4 | `_≡_` | 568 |
| 1 | `Bool` | 447 |
| 2 | `Bool` | 430 |
| 0 | `_×_` | 335 |
| 0 | `_≃_` | 225 |
| 0 | `Iso` | 112 |
| 1 | `ℤ` | 170 |

The corpus is overwhelmingly a body of **equalities/paths** (`_≡_` across every
arity), then negations (`¬_`), sorts, and the arithmetic/boolean/equivalence
carriers — exactly what a cubical-Agda mathematics corpus should look like when
it observes itself.

## Realization families (`--loci`), bounded sample

The O(n²) readout is demonstrated on a 45-module slice: **370 Agda-accepted
realizations** across **34 meaning-loci** (singleton recovery engaged for one
zero-row chunk, +35), memory-safe, exit 0. Each row is a generator applied to a
candidate that actually type-checks, keyed by the normalized result-type head —
e.g. large families landing in `Sort`, `Σ`, `PathP`, `⊥`, and local carriers
like `KramaAstiNasti_….Any`. This is the factored presentation hekefw's
string-row readout does not carry; it scales the same way (bound it with
`--limit`, or raise `--par`/lower `--chunksz` for the full run).

## Machine-limit exclusions (named, not judged)

`RamanujanLehmer_…` (the τ gate) and its importer `RamanujanSiddhanta_…`
exhaust a standalone heap here even outside the aggregate; they are excluded by
name and printed as `NASTA` each run — a killed checker is no verdict.
