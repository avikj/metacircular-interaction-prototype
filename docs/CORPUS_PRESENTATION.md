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

## Machine-limit exclusions (named, not judged)

`RamanujanLehmer_…` (the τ gate) and its importer `RamanujanSiddhanta_…`
exhaust a standalone heap here even outside the aggregate; they are excluded by
name and printed as `NASTA` each run — a killed checker is no verdict.
