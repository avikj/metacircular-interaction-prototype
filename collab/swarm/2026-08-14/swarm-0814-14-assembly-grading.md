# The vallī has no content: a free-monoid grading for the Smith assembly

**Agent:** `swarm-0814-14` · 2026-08-14 · one object, checked.

**Object:** `formal/cubical/Swarm/S14AssemblyGrading.agda`
(`--cubical --guardedness --safe --no-import-sorts`, no postulates, no holes)

```
cd formal/cubical && LC_ALL=C.UTF-8 agda -i . Swarm/S14AssemblyGrading.agda
EXIT=0
```

---

## 1. The draw

Eight uniform: `collab/discovery/claims/R0029-situated-port-engine-integration.md`,
`machinery/test_bijective_smith_assembly.py`, `formal/cubical/KuttakaValli.agda`,
`machinery/smith_solver_adapter.py`, `code/exp19_lambda_fresnel.py`,
`runtime/crystallize/mine.py`,
`collab/messages/workers/20260812T090836.491254Z--claude_history--0005.md`,
`collab/discovery/events/R0001/20260811T180100Z-builder.json`.
Three rare-corner: `kernel/nodes/003-validity-B.md`,
`runtime/LIVING_STATE.died.1786590851.json`, `collab/discovery/harvest/R0001.json`.
Frontier field: motivic cohomology and K-theory (descent, trace methods, cyclotomic
spectra). Ancient field: Omar Khayyám (cubics by conic intersection, the parallel
postulate). Lenses: **Narayana Pandita** — enumerate by a generating rule, not a
formula; **Riemann** — move to the complex plane and let the singularities speak.

Four of the eleven files are the same object seen four times: 2×2 integer matrices.
`KuttakaValli.agda` types Āryabhaṭa's vallī as a monoid morphism
`replay : List ℤ → M₂(ℤ)` with `det ∘ replay = ±1`. `test_bijective_smith_assembly.py`
replays the Hermite/Smith stratification of index-`m` sublattices of ℤ².
`smith_solver_adapter.py` transports a Smith certificate `U A V = D`. And the
*dead runtime organism* `LIVING_STATE.died.1786590851.json` has genome
`[["det"],["entry",i,j],["hentry",i,j]]` over `value_pool 2..8` — a 2×2 matrix with
a determinant sensor, which died at epoch 190 with `ported: false`. The draw handed
me one subject from four directions.

## 2. Where the two lenses disagree

The Smith assembly's arithmetic content is the bijection
Φ(L) = (c, L/c), c = first Smith invariant, c² | m, giving

  σ₁(m) = Σ_{c²|m} ψ(m/c²).

**Riemann's answer.** This is one equation between Dirichlet series:

  Σ σ₁(m) m^{−s} = ζ(s)ζ(s−1) = ζ(2s) · ( ζ(s)ζ(s−1)/ζ(2s) ),

the left factor being Σ_c c^{−2s} (the content) and the right being Σ ψ(n) n^{−s}
(the primitive part). The identity *is* the cancellation of ζ(2s); the poles at
s = 2 and s = 1 carry everything else. Under this lens the assembly is a two-factor
Euler product and there is nothing to enumerate.

Riemann's lens is **totally blind to the vallī**. Āryabhaṭa's division step is
unimodular; it contributes 1 to every Dirichlet series and does not appear in the
factorization at all. Yet it is the whole content of `KuttakaValli.agda` and of the
`replayHom`/`detReplay`/`convergent`/`macroSound` laws already proved there.

**Narayana's answer.** Generate the objects by a rule. The vallī is a word, append
is the rule, and the invariant the rule preserves is length parity — exactly
`detReplay : det (replay v) ≡ sgn v`. Under this lens the content c is a *degenerate*
invariant: it is identically 1, because every letter of the alphabet is unimodular.
Narayana's lens sees only `pulv`, because that is the letter with a recurrence, and
concludes there is no arithmetic to grade.

So: one lens says content is the entire story, the other says content is constantly 1.
Both are right about their own alphabet. **The disagreement is about the alphabet,
not about the theorem** — and that is the object below.

## 3. The object

Extend the vallī alphabet from one letter to three, keeping the same evaluator (fold
by matrix multiplication):

| letter | matrix | determinant | vocabulary |
|---|---|---|---|
| `pulv q` | `L q = (q 1 / 1 0)` | `−1` | one kuṭṭaka division step |
| `scal c` | `dia c c` | `c · c` | one unit of content — the `c²` of the assembly |
| `heck n` | `dia 1 n` | `n` | one unit of primitive (cyclic) index — the ψ-part |

`run : Word → M₂(ℤ)`. Then (all checked):

- **`runHom`** — concatenation is multiplication on the wider alphabet: the vallī's
  own structural law survives the extension unchanged.
- **`detRun : det (run w) ≡ wt w`** — the determinant is a monoid morphism from the
  free monoid on `Step` to (ℤ, ·).
- **`split`** — `wt` factors through three independent characters `eps`, `cont`, `prim`.
- **`epsSq : eps w · eps w ≡ 1r`** — the orientation character is a unit.

**Main theorem (`assemblyGrading`).** For every word `w`,

  `det (run w) ≡ eps w · ((cont w · cont w) · prim w)`  and  `eps w · eps w ≡ 1r`.

The index of anything the extended pulverizer builds is
(sign) · (content)² · (primitive index). This is the Smith assembly as a **grading of
syntax**: the free monoid on three letters carries exactly the three characters whose
Dirichlet series are (nothing), ζ(2s), and ζ(s)ζ(s−1)/ζ(2s).

**The obstruction (`pulverizerContentless`).** `val = map pulv` embeds the classical
vallī (`embed : run (val v) ≡ replay v`, so this is genuinely the drawn module's
object). Then for **every** vallī `v`, of any length:

  `cont (val v) ≡ 1r`  and  `prim (val v) ≡ 1r`,

hence `pulverizerIndex : det (replay v) ≡ eps (val v)` and the grading collapses to
its orientation factor (`pulverizerGradingCollapse`). Āryabhaṭa's algorithm lives
entirely in the eps-graded part. It cannot produce the c² or the n of the assembly —
not because it is short, but because its alphabet has one letter and that letter is
unimodular. Content must be supplied by a generator outside the trace calculus.

**Completeness of the wider alphabet (`assembleSmith`).** The two-letter word
`scal c ∷ heck n ∷ []` evaluates to

  `dia c (c · n)`,

the Smith normal form with invariants (c, c·n) and index c²n — i.e. Φ⁻¹(c, n) on the
diagonal representative of the stratum, with `assembleCharacters` reading the three
characters back off as (1, c, n) and `assembleIndex : det ≡ (c · c) · n`.

**Strata invariance (`strataInvariance`).** Prefixing any vallī to an assembly leaves
`cont` and `prim` unchanged. In the assembly's language: the pulverizer can normalize
a basis inside a stratum but cannot move it between strata. That is the typed form of
the drawn test's `test_each_stratum_is_one_orbit_via_witnesses` — with the direction
the test does not check, namely that the unimodular action *cannot* leave the orbit.

### What this replaces

Nothing was computed. Per CLAUDE.md the theorem was written first: the statement
"det ∘ run is a morphism to (ℤ,·) factoring through eps · cont² · prim" is a two-line
induction with `detMul` (already proved in `M2Unimodular`) at each step, and the
obstruction is one more induction. No measurement would have established it and no
measurement would have distinguished it from its negation at any finite length.

## 4. Contradictions with conspicuous documents

1. **`code/exp19_lambda_fresnel.py` (drawn) is a live violation of CLAUDE.md, not
   legacy.** Its docstring advertises "the arithmetic weights **calibrated from the
   data itself**"; the code fits a cubic to detrend, windows, and reports gap-recovery
   `err%` with no error term, then annotates its own failure in a comment — "w_3, w_4
   are corrupted by spectral crowding". That is exactly the `exp27` failure mode
   CLAUDE.md was written to stop: a fitted constant over one decade with the
   X-dependence unstated. Two of the eight measured weights are admitted noise **in
   the source**, and nothing in the file says which theorem the calibration stands in
   for. Under the current protocol the file's claims should be marked withdrawn, not
   merely frozen as legacy Python.

2. **`kernel/nodes/003-validity-B.md` claims the fitted 0.362 was caught by
   "conservation", i.e. by redundancy without a verification layer.** The node's own
   "Strength" paragraph says soundness emerges *because independent preparations
   agree*. But CLAUDE.md records that 0.362 propagated into two notes, a paper
   section, and a round of cross-review before anyone noticed — redundancy did not
   catch it in time; a page of algebra did, afterwards. Node 003 is citing as evidence
   for itself the case that most sharply refutes it. Its "Weakness" line ("soundness
   is statistical and can drift") is the accurate summary and the "Status in this
   repository" paragraph overstates the test.

3. **The Smith assembly is very likely a rediscovery of the primitive/imprimitive
   Hecke decomposition.** σ₁(m) = Σ_{c²|m} ψ(m/c²) with c the content, and the
   `second_moment_totient` form S(m) = Σ_{d²|m} φ(d) σ₁(m/d²), are the coset-counting
   shadow of T_m = Σ_{c²|m} c^{k−1} T'_{m/c²}. `notes/BIJECTIVE_SMITH_ASSEMBLY.md`
   should carry that attribution; CLAUDE.md requires the prior-art search *before* the
   experiment and the drawn test file shows no sign of one. I flag this rather than
   assert it — I did not read the note, on budget grounds.

4. **The dead organism is evidence, not detritus.** `LIVING_STATE.died…json` has a
   genome that senses `det` and the four entries, over `value_pool 2..8`, and died at
   epoch 190 with `ported: false`. Its alphabet is exactly the one that this note
   proves is *insufficient*: entries and determinant, with no letter for content.
   A 2×2 organism with only those sensors cannot see the Smith stratification, because
   `cont` is not a function of `det` — `dia 2 2` and `dia 1 4` share `det = 4` and
   differ in content. If the runtime is revived, the genome needs a `content` (gcd)
   sensor; `S14AssemblyGrading` says precisely what it is missing.

## 5. Ledger

- Frontier field (motivic cohomology / K-theory, trace methods) was **assigned and not
  used**. The honest reason: the object I found is a grading of a free monoid by three
  characters, and the trace-method vocabulary would have added names without adding a
  theorem. I record the non-use rather than dress the result in it. The one real
  contact point, unpursued: `eps`, `cont`, `prim` are the K₀-style rank/content
  decomposition of the Hecke correspondence, and asking whether the grading lifts to
  the cyclotomic-trace level is a genuine question I did not touch.
- Ancient field (Khayyám) was **assigned and not used**. Contact point, unpursued:
  Khayyám's method is "cross two curves when one equation will not factor" — the
  assembly's Φ crosses the divisor condition c² | m with the cyclic count ψ, which is
  formally the same move one dimension down. That is a resemblance, not a result, and
  I am not writing it up as one.
- Seeder appended (mandatory): one entry to `frontier_fields.txt` (Hecke
  correspondences on lattices: double cosets, primitive vs imprimitive decomposition,
  the Euler-product identity) and one to `method_lenses.txt` (free-monoid grading —
  ask which characters of the free monoid an evaluator factors through; the letters a
  legacy algorithm lacks are the exact obstruction). Both were met in this block and
  neither was listed.
- Files touched: `formal/cubical/Swarm/S14AssemblyGrading.agda` (new),
  this note (new), the two seeder files (append only). Nothing else edited. No git
  commands run. No Python created, modified, or executed; `exp19` and the two
  `machinery/*.py` files were read as evidence only.
- The solver note, for whoever hits it next: `Cubical.Tactics.CommRingSolver` in this
  checkout does **not** parse `1r` inside a goal (it mis-normalizes it to `0`), and it
  rejects a telescope containing a variable that does not occur in the equation. Both
  cost a compile cycle here. Use `·IdR`/`·IdL` by hand for unit laws, and give the
  solver only the variables it will actually see.
