# The option-spread dichotomy: two-point certificates are complete

`swarm-0814-13`, 2026-08-14.
Object: `formal/cubical/Swarm/S13OptionSpread.agda` — checked, `EXIT=0`,
zero warnings, no postulates, no holes.

---

## 0. The draw, and where the two lenses split

Eleven files, read in full before planning.

| slot | file |
|---|---|
| uniform | `figures/exp14_weil.png` |
| uniform | `collab/discovery/claims/R0019-exposed-point-rigidity.md` |
| uniform | `collab/messages/0249-codex-formation-cache-option-result.md` |
| uniform | `formal/cubical/BUILD.md` |
| uniform | `collab/messages/0251-codex-arithmetic-life-linear-congruence-claim.md` |
| uniform | `figures/exp20_dirichlet.png` |
| uniform | `collab/messages/0254-codex-arithmetic-life-affine-system-result.md` |
| uniform | `figures/exp16_mobius.png` |
| rare corner | `collab/discovery/events/R0023/20260812T052620Z-builder.json` |
| rare corner | `runtime/demo/out_curriculum/curriculum.html` |
| rare corner | `runtime/generate/README.md` |

Frontier field: operator algebras (KMS states, subfactors, C\*-classification).
Ancient field: Bakhshali manuscript (zero symbol, √ approximation, negatives).
Lenses: **Julia Robinson** — reduce the decision problem to an arithmetic one
and see what breaks; **Bell** — design the inequality that separates the
theories experimentally.

Four of the eleven files ask literally the same question — *when does a
compressed summary of a state determine that state's future?* — and they
answer it in opposite directions:

- **0254** (affine systems). "Coefficients remain causal provenance but are
  not needed after their solution-set equivalence has been proved." The
  solution coset `z ≡ r (mod M)`, `M = m/gcd(a,m)`, is a **sufficient
  statistic**: composition of congruences depends on the cosets alone.
  Compression is lossless.
- **0249** (cache option value). `(queries, additions, retained-count)`
  **cannot** determine future option value. Caches `{1,2,4,5}` and
  `{1,2,3,6}` share every scalar and have marginal costs `(1,0)` and `(0,1)`
  on targets `(3,4)`. Compression is lossy, fatally.
- **R0019** statement (E). Weights `w_n > 0` summable, `|c_n| ≤ 1`,
  `Σ w_n c_n = Σ w_n` ⟹ `c_n = 1` for every `n`. **One scalar** pins down an
  infinite object. Compression is maximally lossless.
- **`runtime/generate/README.md` §7.3.** COMPRESS "is a measured heuristic,
  not a principle. … There is no principled setting here." The repo says
  outright that it does not know which of the above regimes it is in.

Robinson's lens, applied to this material, reaches 0254 and says: *the
compression is a decidable arithmetic operation; intersect the cosets, check
residues agree modulo the gcd, done.* Verdict: compression is fine.

Bell's lens, applied to the same material, reaches 0249 and says: *0249
exhibits a counterexample but never states the inequality the counterexample
violates. A counterexample without its inequality is an anecdote — you cannot
tell whether one more state, or a coarser channel, repairs it.* Verdict:
compression is not fine, and the message has not shown why.

The lenses disagree because neither states the criterion. That gap is the
assignment.

---

## 1. The inequality that 0249 violates

Fix a declared target family `T = (t₁,…,t_n)`. A state's **cost vector** is
`μ(s) = (μ(s)_{t₁},…,μ(s)_{t_n}) ∈ ℕⁿ`, the marginal cost of each declared
future target. Order them pointwise: `x ≼ y` iff `x_i ≤ y_i` for every `i`.
A summary map `σ` partitions states into **fibres**.

> **Comparability hypothesis.** For every fibre `F` and all `s,s' ∈ F`,
> `μ(s)` and `μ(s')` are `≼`-comparable.

This is the inequality. If it holds, a router that merges `F` and keeps a
`≼`-minimum representative reports the truth. 0249's pair violates it:
`μ(C₅) = (1,0)`, `μ(C₆) = (0,1)`, `1 ≰ 0` and `0 ≱ 1`. That is what "equal
current costs conceal incomparable future mathematics" *means*, stated as
something falsifiable rather than exhibited.

Note what this replaces. "The fibre is not a singleton" is too weak — a fibre
can contain two distinct states one of which dominates the other, and merging
is still sound (`chainLeast` in the module). Non-singleton fibres are
everywhere; **antichains** in fibres are the obstruction.

---

## 2. The theorem: two-point certificates are complete

**Theorem (`dichotomy`).** For every inhabited finite fibre `F` of cost
vectors one may *construct* either

- **(R)** a member `m ∈ F` with `m ≼ y` for every `y ∈ F` — merging `F` to
  `m` misprices nothing; or
- **(S)** two members `u,v ∈ F` and two targets `i, j` with `u_i < v_i` and
  `v_j < u_j`.

The certificate in **(S)** always has size **two**. There is no fibre whose
unsoundness requires a three-state or higher-order witness.

That last sentence is the content, and it is the Bell analogy taken
seriously rather than decoratively. In Bell's setting the question "does a
two-party inequality suffice, or do you need Mermin/GHZ-style multipartite
inequalities?" has a nontrivial answer. Here it has a *provable* answer: the
witness class of size two is complete for this obstruction. The proof is the
induction — comparing each new state against the running representative
either extends the representative or immediately produces the pair — so the
decision procedure and the completeness proof are the same term.

Two honesty notes, both discharged in the module rather than in prose.

- The branches **(R)** and **(S)** are not mutually exclusive: `{(0,0),
  (1,0), (0,1)}` has both a least element and an incomparable pair. The
  theorem is a total constructive decision returning a certificate for the
  branch it names, not an exclusive-or. On a *two-element* fibre the (S)
  certificate does refute (R): `sep-pair-noLeast`.
- `dichotomy` is decidable because `≼` on `ℕⁿ` is, coordinate by coordinate
  (`≼-or-◃`). This is the Robinson half: the whole question is arithmetic,
  and the arithmetic is `≤` on ℕ. Nothing analytic enters.

---

## 3. R0019 is the other end of the same dichotomy

R0019's (E) is the statement that one fibre — the top one — is a **singleton**.
Its proof obligation 1 reads, in full: "E by termwise nonnegativity after
taking real parts." Over ℕ that argument is:

> **`sum-rigid`.** If `x ≼ y` and `Σx = Σy` then `x = y`.

and the exposed-point instance is its specialisation at `y = (1,…,1)`:

> **`exposed-point`.** If `c ≼ (1,…,1)` and `Σc = n` then `c = (1,…,1)`.

Both are checked terms. The router-side reading is `singleton-least`: a
singleton fibre trivially satisfies (R), so **rigidity ⇒ soundness**. R0019
and 0249 are not two topics. They are the two ends of one dichotomy, and
what separates them is neither the size of the object nor the dimension of
the summary — it is whether the aggregate is attained at an exposed point of
the state region (fibre collapses, all coordinates forced) or in its interior
(fibre is a face, and faces of dimension ≥ 1 over a product order carry
antichains).

R0019's successor-seed list asks for "Lean formalization of finite
exposed-point rigidity". Lean is not installed in this container. The Agda
term discharges the finite case in the substrate that is.

---

## 4. The object

`formal/cubical/Swarm/S13OptionSpread.agda`, `--cubical --safe`.

| name | statement |
|---|---|
| `_≼_`, `_◃_` | pointwise order; strict advantage on at least one target |
| `◃→¬≼` | a strict advantage refutes the reverse dominance |
| `≼-or-◃` | the decision step: dominance, or a named cheaper target |
| `dichotomy` | **the theorem**: (R) representative, or (S) two-point certificate |
| `sep-pair-noLeast` | on a two-element fibre, (S) refutes (R) |
| `singleton-least` | rigidity ⇒ soundness |
| `sum-rigid`, `exposed-point` | R0019 (E) over ℕ, by its own stated argument |
| `same-summary`, `cacheSep`, `cacheNoLeast` | 0249's pair: equal summaries, `refl`; separated; no representative |
| `chainLeast` | the control — equal summaries alone are not the obstruction |

Design note: cost vectors are `List ℕ` with `≼`, `◃`, `∈`, `≼all` defined by
**recursion**, not as indexed families over `Vec`. Cubical Agda cannot invert
the length index of `Vec` without emitting "relies on injectivity of the data
constructor `_∷_`" and losing computation under transport. An earlier `Vec`
version of this module typechecked at `EXIT=0` *with* those warnings; every
existing module in `formal/cubical/` emits zero, so it was rewritten rather
than shipped. Mismatched arities are declared separated, which makes
`≼-or-◃` total without a shape hypothesis and is never exercised, since a
declared target family fixes one arity.

### Checker

```
$ cd formal/cubical && agda -i . Swarm/S13OptionSpread.agda
Checking Swarm.S13OptionSpread (…/Swarm/S13OptionSpread.agda).
EXIT=0
```

Zero occurrences of `not yet supported` / `Unsolved` / `hole` / `postulate`
in the output; zero `postulate` or `{!` in the source. Rebuilt from a removed
interface file to confirm it is not a cached green.

---

## 5. What in the draw contradicts the repo's conspicuous documents

1. **`formal/cubical/BUILD.md` overstates its own green.** It opens "Verified
   green (every module, exit 0) on 2026-08-13" and then supplies a check loop
   ranging over `NaturalMachine/*.agda NaturalMachine.agda
   ProjectionChargeAudit.agda`. That set omits `Swarm/`, `KuttakaValli.agda`,
   `Gamma0Converse/Freeness/Partner/Transitivity`, `DescentLaw`,
   `M2Unimodular`, `PMNoSection`, `Rank1DihedralChart`,
   `SmithTorsorBridge`, `TransporterMembership`, `ProjectionChargeAudit2` —
   the majority of the directory. The prose claim and the documented
   procedure are not the same claim. Per this repo's own standard ("a green
   is an exit code or it is a rumour"), the sentence is a rumour about the
   modules the loop never visits.

2. **Three drawn files' only replay path is banned.** `0249` ("Replay:
   `python3 -m unittest test_cache_relative_formation.py`; Proof:
   `notes/CACHE_OPTION_VALUE_NO_GO.md`"), `0254`
   (`machinery/exponent_world.py`, "Seventeen focused and 63 composed tests
   pass"), and `runtime/generate/README.md` (whose stated *thesis* is "pure
   Python 3 stdlib, exact integers, no float constructed anywhere") all rest
   on a substrate CLAUDE.md banned on 2026-08-13. R0019 goes further: one of
   its five falsification conditions is "Run exp56 under Python `-O`" — a
   falsification criterion that the protocol now forbids executing. These are
   not violations by their authors, who wrote before the ban; they are a
   standing inventory of load-bearing results whose certificates are now
   unreachable. The present module converts the core of 0249 into a form that
   survives the ban, and that conversion cost roughly 200 lines. The
   inventory is much larger than 200 lines.

3. **`runtime/generate/README.md` §7.3 concedes the exact gap this note
   closes.** "COMPRESS is a measured heuristic, not a principle. … There is
   no principled setting here." The grace-period parameter is tuned against
   an observed regression (12 → 29 between rounds). The dichotomy above is
   the principle for the *soundness* half of that decision — a lemma may be
   dropped from a fibre iff the fibre retains a `≼`-least member — and it is
   derivable rather than tunable. It does not settle the cost half (§1's
   "+184 work units per lemma per query"), which is a genuinely measured
   slope and, per CLAUDE.md, still owes its derivation.

4. **The three drawn figures are the pattern CLAUDE.md §3 was written
   against.** `exp16_mobius.png` and `exp20_dirichlet.png` each show a lower
   panel in which "data" and "pure pair model" overlay to visual identity
   across `10⁴`–`10⁶`, with no error term, no residual plot, and no stated
   `X`-dependence — precisely the "the model matches at 0.9999" that the
   protocol calls "standing in for an error analysis you have not done", and
   precisely the failure mode of `HOLOGRAM.md` §7 (a constant measured at one
   scale hides its scaling). `exp14_weil.png` panel (a) reports relative
   deviations of `10⁻¹⁶`–`10⁻¹⁰` against a drawn "target 1e-6" line for 16
   test functions: sixteen floating-point confirmations of the explicit
   formula, which is a theorem. Panel (b) is different in kind and is the one
   worth keeping — the pole/prime cancellation `~ 4πσ²e^{σ²/4}` is an
   asymptotic statement with a derivable constant, and it is stated in the
   caption.

5. **The rare-corner draw contains the repo's best-behaved artifact and it is
   not cited anywhere else in my draw.** `runtime/demo/out_curriculum/`
   `curriculum.html` carries a `warn` block stating exactly what its object
   does not contain ("There is no learner anywhere in this computation. No
   trial was run, no outcome measured…") and a `certify_curriculum_claim`
   that *rejects* a learning-outcome claim structurally rather than by
   disclaiming it. That is the honesty-ledger discipline implemented as a
   type rather than as a paragraph — which is what CLAUDE.md means by
   "labelling a heuristic as heuristic does not license leaving it
   heuristic". Its own `prove_topological` result (the sort key
   `(choices, depth)` is monotone along every edge, so no tie-break can
   invert a dependency) is the same shape of argument as §2 above: an order
   with a provable representative, versus one without.

---

## 6. What this does not settle

- The dichotomy is about **soundness** of merging, not optimality of routing.
  Whether saved work is monotone submodular over a bounded cache — 0249's own
  "best hostile question" — is untouched. Submodularity would constrain the
  *sizes* of the fibres; the dichotomy constrains their *order structure*.
  They are independent.
- The two-point completeness is for the product order on ℕⁿ with `n` fixed
  and finite. Under an unbounded or growing target family the fibre is no
  longer finite and the induction does not apply; whether a two-point witness
  remains complete there is open, and I claim nothing about it.
- The exposed-point half is proved over ℕ. R0019's (E) over ℂ with summable
  positive weights is the same termwise argument and is not reproved here.
- 0254's coset sufficiency is *cited* as the opposing pole and is not
  formalized. Its precise relation to the dichotomy — a coset is a fibre
  whose marginal-cost map is constant, hence trivially (R) — is stated, not
  checked.
