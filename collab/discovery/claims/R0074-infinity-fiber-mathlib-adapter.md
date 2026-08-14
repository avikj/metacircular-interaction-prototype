---
id: R0074
title: A nonzero integral polynomial cannot have a residue-class zero fiber
status: claimed
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0641-codex-mathlib-infinity-fiber-claim
dependencies: none
statement_hash: 0caa626869e9f46d342d626ca8226c8187fb770efcc26f8b645c7ccbb3b42f43
cycle: 1
max_cycles: 3
owner: codex_mathlib_ingestor
breaker: infinite-valuation-native-lineage-return
source: formal/pairfield/Pairfield/InfiniteValuationFiberAdapter.lean
supersedes: none
updated: 2026-08-14
---

# Tension

`INFINITE_VALUATION` makes `v_p(0)=infinity` part of the observable and claims
that a root of a nonzero integral polynomial has no finite sufficient residue
chart.  Its prose says vanishing on the whole chart class is impossible
because that class is infinite.  For a multivariate polynomial, infinitude
alone is insufficient: a nonzero polynomial may vanish on an infinite set.
The load-bearing object is the full product of infinite residue classes.

# Rosetta bridge

Mathlib's `MvPolynomial.funext_set` proves that two multivariate polynomials
over an integral domain are equal when their evaluations agree on a coordinate
box whose every side is infinite.  For nonzero integer modulus `m`, each class
`x_i + m * Z` is an infinite side.  If a polynomial vanished throughout their
product, `funext_set` would force it to be zero.

# Exact statement

For every nonzero `f : MvPolynomial sigma Int`, nonzero `m : Int`, and root
`x`, there exists `y` coordinatewise congruent to `x` modulo `m` with
`eval y f != 0`.  Therefore the Boolean zero/infinity status at `x` is not
determined by any nonzero residue chart.  Prime-power charts are a direct
specialization.

# Preservation ledger

- Preserved: arbitrary variable type, integral coefficients, the native root,
  a single shared nonzero modulus, coordinatewise congruence, and an explicit
  nonroot adversary in the same chart.
- Strengthened: the proof uses the exact product-box hypothesis needed in
  several variables rather than the insufficient fact that the chart is
  merely infinite.
- Not retained: finite valuations away from the zero locus, the `e+1` upper
  bound, Taylor/tangent criteria, formed-world incidence, hitting time, or an
  executable equality decision.
- Not implied: any measure- or lens-theoretic visibility of the zero locus.

# Proof obligations

1. Prove every affine integer class `a + m*Z` infinite when `m != 0`.
2. Apply `MvPolynomial.funext_set` to the product of those classes.
3. Extract a same-chart point where the nonzero polynomial does not vanish.
4. Package the result as failure of finite zero-status determination at a root.
5. Specialize to prime-power residue charts.
6. Fire both hypotheses: the zero polynomial is constant-zero on every chart,
   and modulus zero collapses a chart to the original point.

# Falsification

- Produce a nonzero multivariate integral polynomial vanishing on one entire
  nonzero-modulus product residue class.
- Remove `f != 0` or `m != 0` without making the corresponding control true.
- Replace the product box by an arbitrary infinite set; e.g. `X` vanishes on
  the infinite `Y`-axis, so that stronger reading must fail.

# Evidence

Pending checked Lean adapter and independent infinite-valuation lineage return.

# Prior art

Polynomial identity on an infinite box is standard.  The pinned exact source
is Mathlib's `MvPolynomial.funext_set`; no novelty is claimed.

# Successor seeds

- Connect zero-status nondetermination to an explicit `WithTop Nat` valuation
  interface without rebuilding Mathlib's p-adic valuation theory.
- Keep finite-depth sufficiency away from roots as a separate congruence/Taylor
  theorem.

# Event log

- 2026-08-14: exact Mathlib match, multivariate quantifier repair, forecast,
  and falsifiers registered in message 0641; status `claimed`.

