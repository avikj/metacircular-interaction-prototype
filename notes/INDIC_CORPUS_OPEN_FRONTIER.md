# Open frontier of the decisionless / Indic corpus

An honest ledger, for the next agent, of what is *not* done — kept separate
from the index of what is (`DECISIONLESS_INDIC_CORPUS_INDEX.md`). The repo
values corrections over results; this is the corrections surface.

## Proved, do not re-do

The whole `Jiva` closure (~31 modules) is kernel-checked (`--safe`, no
postulates, no holes), clean-rebuilds EXIT 0. In particular these were once
"open" or "hard" and are now **done** — do not deferentially re-defer them:

- `∑k³ = (∑k)²` (`Sankalita.घन-सङ्कलितम्`) — proved by hand (the ℕ solver
  chokes on `suc`, so a distributivity chain over an abstract base was used).
- The full prastāra bijection `छन्दस् ≃ ℕ` (`Pingala`) — via `मूल्य` injective
  (two parity lemmas), not just the one-sided reconstruction.
- mātrāmeru soundness *and* completeness (`Matramerus.साधु`, `.पूर्णता`).
- bhāvanā **associativity** (`BhavanaSamuha`) and the वर्गप्रकृति
  (varga-prakṛti, mis-called "Pell") **infinitude** (`VargaprakritiSreni`).

## Genuinely open (tagged, honestly)

1. **Kerala school (Mādhava, Nīlakaṇṭha, Jyeṣṭhadeva).** The one major
   tradition absent. The arctan/π series, the correction terms, convergence
   acceleration — all need real analysis (limits, ℝ or ℚ with order). Not
   attempted here because a clean Agda development needs the analytic
   substrate the `Lean` lane (`formal/pairfield/`) is better suited to.
   *This is the biggest gap and the most valuable next target.*
2. **Meru diagonal = Fibonacci.** Halāyudha's observation that the shallow
   diagonals of the meru-prastāra (`Meru`) sum to the mātrāmeru (`Matramerus`)
   — `Fib(n+1) = ∑ₖ C(n−k,k)`. Would unify the two combinatorics modules.
   Open because the diagonal reindexing over the list representation is
   fiddly; a `मेरु n k` *function* form (Pascal refl) plus a bounded diagonal
   sum is the clean route.
3. **Cakravāla, the algorithm.** `Cakravala.चक्रीय-पद` proves the cyclic
   step *is* bhāvanā with (m,1); NOT proved: that `k ∣ (a+bm)` (the m-choice)
   makes `k ∣ A'`, `k ∣ B'`, `k ∣ K'` so the new triple is integral, nor the
   |m²−N|-minimisation, nor termination. These are the number-theoretic and
   algorithmic heart Bhāskara added; they need modular reasoning over ℤ.
4. **Bhāvanā group, the two easy laws.** `BhavanaSamuha` proves
   associativity; identity `(1,0)` and inverse `(a,−b)` are stated as "by
   direct computation" but not checked — the ℤ solver balked at the
   bare-variable RHS (`… ≡ a`). A hand proof (`·IdR`, `·AnnihilR`) would
   close them.
5. **Permanent vs temporary avaktavya.** `Satyayantra` requires *total*
   completeness (the un-said is always temporary). A weaker interface
   (soundness + stability, no completeness) would capture genuinely partial
   honest machines where the un-said is *permanent* — the Jain
   asaṃkhyāta/ananta distinction at the level of computation. Not built.

## Method note

The `discreteℕ`-free discipline held for the *cognition* lane (kuṭṭaka,
prastāra, honest machine). The *revival* lane (Brahmagupta, Śulba, Vargana,
Sankalita, Cantor) uses the ℤ/ℕ solvers and ordinary induction — sound, but
a different register (`KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md` §"Adjacent
lane" states the distinction). A future agent should not conflate "checked"
with "decisionless": most of the revival lane is checked-but-decision-using,
and that is stated, not hidden.
