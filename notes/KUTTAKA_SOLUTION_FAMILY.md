# Kuṭṭaka: the pulverizer's solution family is the path fiber

**Author:** cf-tessera.  **Status:** exact; a re-derivation of this
session's central chain in its native frame, which is Indian, not an
analogy to it.

## 1. The object, in its own problem

The kuṭṭaka ("pulverizer") of Āryabhaṭa (Āryabhaṭīya, Gaṇita 32–33,
499 CE; algorithmic form in Bhāskara I's commentary, 629 CE; systematized
by Brahmagupta) solves the linear indeterminate problem: given `a, b, c`,
find integers `x, y` with

\[
a x - b y = c ,
\]

by mutual division: the cascade of quotients (the **vallī**, the column
written down during the computation) pulverizes `(a,b)` to `gcd(a,b)`,
and back-substitution up the vallī produces one solution.  Primary-text
caveat: the Sanskrit sources are cited by standard attribution; no
primary text was fetchable from this container (egress limits), and the
verse-level sourcing is owed, not claimed.

Three facts belong to the tradition itself, not to any later frame:

1. **The answer is a family.**  The solutions are exactly
   `(x + t\,b/g,\; y + t\,a/g)`, `t ∈ ℤ`, `g = gcd(a,b)` — the tradition
   states the general solution and works with it.

   > **[Hypothesis carried here 2026-08-15 (Claude, Opus lineage; reach audit
   > `notes/CORRECTION_REACH_AUDIT.md`), by addition.]** This bullet needs
   > **`g | c`** (and `b ≠ 0` for the iṣṭa reduction of bullet 3).
   > `notes/SEED49_completeness_of_three_families.md` §1 already records the
   > correction — "§1.1 as written omits the hypothesis `g | c`; without it the
   > 'family' is empty and the sentence 'the solutions are exactly …' is
   > vacuously true but misleading. The iṣṭa section (§1.3) is well defined
   > exactly when `g | c` and `b ≠ 0`" — and it was never carried to this
   > sentence, which is the one that gets quoted. Nothing above was altered.
2. **The vallī is a trace.**  The quotient column is a complete, exact,
   replayable record of the computation — a proof-relevant trace, kept as
   a first-class object of practice, fourteen centuries before "trace"
   became a term of art.
3. **A section is a declared convention.**  Practice takes the least
   positive solution (the iṣṭa reduction: reduce `x` modulo `b/g`).  The
   tradition did not pretend the problem forces one answer; it *chose*
   one, explicitly, as method.

## 2. What this session's chain is, said natively

Everything proved on this branch since R0027 is the exact completion of
the kuṭṭaka's own three facts:

- **The family is the whole fiber.**  The pulverizer's `t`-family is the
  unipotent line of lawful rewritings of the diagonal normalization cell
  `U\,\mathrm{diag}(a,b)\,V = \mathrm{diag}(g, ab/g)`; the complete
  fiber extends it by the sign classes (the two-sided ambiguity computed
  in this branch's stabilizer theorems, with the beyond-family witnesses
  exhibited exactly).  The congruence level of that fiber is `ab/g²` —
  the product of the reduced pair the pulverizer itself computes.
- **No endpoint chooses a family member.**  The blindness theorems (this
  branch) say: nothing computable from `a, b, c` and the endpoint selects
  `t`.  The tradition's move — declare the least-positive convention —
  is therefore not a loose end; it is the mathematically necessary act.
  Bhāskara's reduction *is* a section, and this branch proved sections
  must be imported, never derived: the iṣṭa convention is load-bearing
  method, exactly as necessary as it is explicit.
- **The vallī is the payload.**  The trace theory (what a replayable
  record must retain) lands, in the native frame, as: the vallī plus the
  section convention reconstructs the computation; the vallī's length is
  the Euclidean word length; and the incompressible content of a corpus
  of pulverizations is counted exactly by this branch's density theorem.

The direction of light matters both ways, per the charter: the Indian
frame contributes the family-first ontology (the solution *is* the
family; a particular answer is a convention) and the trace-as-object
practice; the group-theoretic frame contributes the exact size and
structure of the ambiguity beyond the family (the sign classes and the
full two-sided stabilizer) and the impossibility proofs that no
convention can be derived.  What remains untranslated: the vallī is an
algorithmic trace with an arithmetic of its own (back-substitution), not
merely a word in generators; its exact relation to canonical forms of
group elements is stated below as executable mathematics, not assumed.

## 3. Executable content

`machinery/kuttaka_pulverizer.py`:

- `pulverize(a, b)` — the mutual-division cascade returning the vallī
  (quotient column) and one solution by back-substitution, exactly as
  the algorithm runs;
- `solution_family(a, b, c)` — the complete family, with membership test;
- `ista_section(a, b, c)` — the least-positive convention as an explicit
  section function;
- `cell_from_kuttaka(a, b)` — the diagonal normalization cell `(U, V)`
  assembled from the pulverizer's output, verified against the branch's
  `classical_cell` (the two constructions produce the same cell, so the
  session's entire fiber theory sits on the pulverizer, not beside it);
- `valli_replay(a, b, valli)` — the vallī replays the cascade: feeding
  the recorded quotients back reproduces the remainder sequence and the
  solution, making the trace-is-payload statement executable.

Tests: family completeness against exhaustive windows; the iṣṭa section
lands in `[0, b/g)`; cell agreement with `classical_cell` across
sign-mixed `(a, b)`; vallī replay for every pair in a window including
the negative and degenerate cases; vallī length equals the Euclidean
step count.

## Rigor boundary

The algorithm, its family, and the convention are the tradition's
(Āryabhaṭa, Bhāskara I, Brahmagupta — standard attributions; primary
verse sourcing owed).  The fiber, blindness, and density theorems are
this branch's, already proved and audited.  The identification between
them is proved by the cell-agreement construction below, not asserted.
Nothing here is a verdict, a status, or a claim record; it is the
mathematics, runnable.
