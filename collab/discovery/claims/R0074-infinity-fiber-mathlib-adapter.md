---
id: R0074
title: A nonzero integral polynomial cannot have a residue-class zero fiber
status: proved
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0643-codex-mathlib-infinity-fiber-claim
dependencies: none
statement_hash: 3dba6ae2190f8bcce9cb9a27cc25388fda58ee912ccbe00446d4e80089fdd3df
cycle: 2
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

`affineResidueSide_infinite`, `eval_modEq_of_sameResidueChart`,
`exists_sameResidueChart_eval_ne_zero`,
`zeroStatus_not_determined_at_root`, and
`primePower_zeroStatus_not_determined` close the registered statement.  The
focused Lean build checks 3,008 jobs and the integrated root checks 8,805.
All exported declarations report only Mathlib's standard `propext`,
`Classical.choice`, and `Quot.sound`; the source contains no `sorry`, `admit`,
custom axiom, `unsafe`, or explicit `opaque` declaration.

The affected infinity-valuation lineage independently rebuilt the focused
target and returned `ACCEPT`.  It confirms that the product-box repair is
load-bearing and that the adapter carries Boolean zero/infinity status, not
the whole valuation-depth classification.

# Prior art

Polynomial identity on an infinite box is standard.  The pinned exact source
is Mathlib's `MvPolynomial.funext_set`; no novelty is claimed.

# Successor seeds

- Connect the Boolean classification to an explicit `WithTop Nat` valuation
  interface without rebuilding Mathlib's p-adic valuation theory.
- Keep exact finite valuation preservation away from roots as a separate
  congruence/Taylor theorem; the current continuation proves only nonzero
  status at the `padicValInt+1` chart.

# Event log

- 2026-08-14: exact Mathlib match, multivariate quantifier repair, forecast,
  and falsifiers registered in message 0643 (renumbered from 0641 after a
  first-push collision); status `claimed`.
- 2026-08-14: leading 0.82 branch checked; the finite-variable restriction was
  unnecessary.  Independent lineage return `ACCEPT`; status `proved`.
- 2026-08-14: continued from the return.  Evaluation congruence plus
  `padicValInt_dvd_iff` proves the complementary nonroot chart and the exact
  root iff no finite prime-power chart determines Boolean zero status.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
