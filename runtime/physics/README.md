> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# `runtime/physics` — the light layer, and the geodesic thesis

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

> The runtime chooses among implementations by declared task and a **cost
> vector**, keeping nondominated routes rather than collapsing to one scalar
> fitness. — `CRYSTAL.md` §2 L3

**Status: BUILT.** `python3 runtime/tests/test_physics.py` → **58/58**, and the
suite kills every one of **17** injected defects. `python3
runtime/demo/fermat_demo.py` → exit 0, ~2.5 s, byte-identical under
`PYTHONHASHSEED` unset / 12345 / 999.

Pure Python 3 stdlib, CPU only. **Exact arithmetic only**: `int`,
`fractions.Fraction`, and exact sums of rational multiples of square roots. No
float is constructed anywhere; no square root is ever evaluated numerically;
there is no `/` operator in any source file of this package. All three are
asserted by an AST walk over this package, the demo, and the test file itself
(§7), not by grepping for `"float("`.

Built **on** `runtime/kernel` (BUILT) and `runtime/execute` (BUILT), which are
imported and never modified. Nothing here is trusted by the checker.

---

## 0. The thesis, and its exact scope

The claim under test was: *the machinery that extracts proof geodesics is the
machinery that finds light geodesics — a theorem about the engine, not a
metaphor.* After building it, the honest statement splits into four parts,
three earned and one killed.

| | claim | verdict |
|---|---|---|
| **A** | one search algorithm serves both | **earned**, and checked: `geodesic()` given L3's adjacency and L3's weight function reproduces `RouteFinder.route` **step for step** on all 99 targets of L3's own `3^8` graph |
| **B** | one frontier: L3's Pareto code ranks light unmodified | **earned**: `dominates`, `is_nondominated`, `pareto`, `scalarize`, `frontier_diff`, `Route`, `Scalarization` are *imported* from `runtime.execute.extract` and used on optical costs; a test asserts each one's `__module__` is still L3's |
| **C** | Snell's law falls out of routing rather than being written down | **earned**: exact rational identity `n₁ sin θ₁ = n₂ sin θ₂ = 24/25` at the found crossing; no search function mentions Snell, asserted by AST |
| **D** | "Fermat's principle **is** cost minimisation" | **killed as stated.** Fermat is stationarity; extraction is minimisation. On a concave mirror the engine returns 2 of the 4 physical rays and the 2 it drops are maxima. The identification is valid *exactly* on families where the action is strictly convex, and `convexity_certificate` checks that with exact second differences and **refuses to issue** on the mirror. |

D is the deliverable that matters most, and §5 is written for it.

---

## 1. The exactness problem, and how it is removed

An optical path length is `Σ nᵢ·√(dxᵢ² + dyᵢ²)`. With rational indices and
rational coordinates it lives in `Q(√p₁, …, √p_r)`, and every such number has a
canonical form

```
Σ aᵢ √mᵢ        aᵢ ∈ Q,  mᵢ distinct squarefree positive integers
```

which is `Surd`. Comparison is exact and **total** because two facts hold:

* **Zero is decided syntactically.** Square roots of distinct squarefree
  positive integers are linearly independent over `Q` (Besicovitch 1940), so a
  canonical `Surd` is zero **iff every coefficient is zero** — a finite check on
  `Fraction`s. There is no tolerance anywhere and no epsilon to tune.
  `√2 + √8 − 3√2` canonicalises to the empty term list, i.e. to the integer 0.
* **Nonzero is decided by rational bracketing.** Enclose each `√m` in
  `[s/2ᵏ, (s+1)/2ᵏ]` with `s = isqrt(m·4ᵏ)` — an *integer* square root, computed
  by Newton on integers with no `math` import — and refine `k` until the
  interval around the sum excludes 0. It always terminates, because the
  previous bullet has already established the value is nonzero.

The primitive the brief names is `compare_scaled_sqrt(a, x, b, y)`: compare
`a√x` with `b√y` by resolving signs and then comparing `a²x` with `b²y`. It is
exact, total, and it is the decision procedure for the two-term case — which is
where most of the work lands, because both the reflection-law residual and the
sign of a two-surd difference are two-term.

`Surd.render_approx` produces a decimal-looking **string** from an exact
rational bracket by integer division. It is a rendering. No decision in this
package is taken from it, and no float is constructed to make it.

---

## 2. Dimensions: a construction-time guarantee, obtained twice

`kernel/README.md` L0 guarantee 2 says *ill-sorted terms do not exist;
construction is the typecheck*. `dimension.py` copies that rule:

```python
quantity(1, LENGTH) + quantity(1, TIME)
# DimensionError: cannot form 1 [L] + 1 [T]: [L] + [T] is not a construction
```

There is no `check_dimensions(expr)` pass in this package because there is
nothing for it to check — an ill-dimensioned value was never built. Exponents
are `Fraction`, so `AREA^(1/2)` is `LENGTH` exactly, and a float magnitude or a
float exponent raises.

**The dimension is inside the content address.** `addr = blake2b(magnitude ‖
dimension address)`, so `1 metre` and `1 second` have different addresses
(`0d413901…` vs `1de290be…` in the demo). Equal magnitude with a different
dimension is a different construction, permanently.

**And the kernel enforces it too, without being modified.** `sort_of(dim)`
injects the dimension into a kernel `Sort`; `term_of(q)` builds the magnitude as
a `Const` *of that sort*. Since a kernel address is `H(head ‖ sort address ‖
children)`, the dimension is in the kernel address as well, and since `T.App`
sort-checks at build time:

```
App(App(plus_L, 1m), 1s)  ->  T.SortError: argument sort Q[T] does not match domain Q[L]
```

That refusal comes out of the trusted file, not out of this package. Both
mechanisms carry a planted-false control in the suite, and mutating either
(`dimension-check-dropped`, `dimension-out-of-address`, `sort-loses-dimension`)
kills the run.

---

## 3. Snell's law, derived

### The set-up

Source `(0,4)` in `n = 8/5`, target `(11,−6)` in `n = 6/5`, interface `y = 0`,
candidate crossings = the integer lattice `x ∈ [−5, 16]`. The router is given
the source, the target, the indices, and the candidates. It is **not** given
angles, sines, Snell, or any preference among crossings. Its only physics is
"the optical length of a straight segment in a homogeneous medium is `n·|d|`",
which is the definition of the OPL functional, not a solution of it.

The routing finds `x = 3`, with `OPL = 20` exactly. Measured afterwards:

| | |
|---|---|
| leg 1 | `d = (3, −4)`, `|d|² = 25`, `|d| = 5` exactly (perfect square) |
| leg 2 | `d = (8, −6)`, `|d|² = 100`, `|d| = 10` exactly |
| `n₁ sin θ₁` | `24/25` |
| `n₂ sin θ₂` | `24/25` |
| residual | **`0`** — a canonical `Surd` with no terms |

With three media (`8/5 | 6/5 | 26/25`, interfaces at `y=8` and `y=0`) the same
call over a family of **1813** rays returns crossings `(6, 50/3)`, `OPL =
1138/25`, and `n sin θ = 24/25` in **all three** media with both residuals
exactly zero — the Snell invariant, never written down.

### What "exactly" means, stated precisely

It means two different things and the runtime distinguishes them:

**(a) When the true Fermat crossing is a lattice point.** Then the residual is
the exact integer `0`. This is not "zero to within the discretisation": the
geometry above is chosen so both legs are Pythagorean, so both sines are exact
rationals, and the residual `Surd` canonicalises to the empty term list. Zero is
decided *syntactically* (§1). Note this is a property of the geometry, not an
input to the search — `x = 3` was found by comparing optical path lengths.

**(b) Otherwise.** The true crossing is irrational, hence in the family's
**omitted locus**, and no lattice can contain it. The runtime then does not
claim a zero residual. It states a bound, exactly:

> `g(x) = n₁ sin θ₁(x) − n₂ sin θ₂(x)` is `d(OPL)/dx` and is strictly
> increasing. If `x̂` minimises OPL on a lattice of spacing `h`, then
> `OPL(x̂) ≤ OPL(x̂ ± h)`, so `g` changes sign on `[x̂−h, x̂+h]`, so
> **`g(x̂−h) ≤ 0 ≤ g(x̂+h)`** and the true crossing lies in `[x̂−h, x̂+h]`.

Both endpoints are exact `Surd`s and both inequalities are *checked*, not
argued. On a deliberately non-Pythagorean geometry (`(0,3) → (7,−4)`,
`n = 3/2` into air):

| step `h` | `x̂` | residual | certified bound `g(x̂+h) − g(x̂−h)` | brackets 0 | convexity |
|---|---|---|---|---|---|
| 1 | 2 | 0.051181484 | 0.711262035 | yes | licensed |
| 1/4 | 7/4 | −0.039625182 | 0.189097175 | yes | licensed |
| 1/16 | 15/8 | 0.006682626 | 0.045394016 | yes | licensed |
| 1/64 | 119/64 | 0.000994597 | 0.011404485 | yes | licensed |

The residual is not monotone in `h` and is not claimed to be; the **bound** is,
and that is the certified quantity. The decimals are renderings of exact
rationals.

### Snell is not hardcoded, and that is tested

`snell_residual` / `snell_invariant` / `reflection_residual` exist only on the
*measurement* side. `test_no_search_function_mentions_snell` walks the ASTs of
`geodesic.py` and `optics.py`, collects every identifier used inside the bodies
of `geodesic`, `arcs`, `_seg`, `route`, `opl`, `ray`, `optical_path_length`,
`paths` and `crossings`, and asserts that none of them contains `snell`,
`residual`, `sine`, `invariant`, `asin`, `angle` or `refract`.

---

## 4. The unification, measured

### What is literally the same code

```python
from ..execute.extract import (RouteFinder, dominates, frontier_diff,
                               is_nondominated, pareto, scalarize,
                               Route, Scalarization)
```

`SHARED_CODE` names them and `test_shared_code_is_literally_l3s` asserts
`obj.__module__ == "runtime.execute.extract"` for each, plus `pareto is
X.pareto` object identity. They work on light with no wrapper because
`extract.dominates` consumes a cost only through `as_tuple()` and componentwise
`<=`; `OpticalCost.as_tuple()` puts a `Surd` in the leading slot and the *same
comparison code* runs. `scalarize` needed `Surd.__rmul__` / `__radd__`, which is
a coercion in this package, not a change to L3.

`ProofRouteProblem` holds an `execute.extract.RouteFinder` and reads its `adj`
table and calls its `_step_for` for **every** weight — including the recursive
congruence weighting, memoised in L3's memo table. Reaching for a
leading-underscore method is deliberate: if L3 changes how a proof step is
weighted, this bridge changes with it, because there is no second copy. (The
mutant `proof-problem-reimplements-weight`, which substitutes a constant weight,
dies.)

### The shared interface, in both instantiations

| | proof routing (L3) | light routing (here) |
|---|---|---|
| node | e-graph address (`str`) | `SOURCE` / interface lattice point / `TARGET` |
| arc | a retained `MergeRecord` | a straight segment in one medium |
| weight | kernel proof steps (`int`) | `n·√(dx²+dy²)` (`Surd`) |
| zero | `0` | `Surd.zero()` |
| route | a checkable proof path | a piecewise-linear ray |
| `cost[0]` | `steps` — the action minimised | `opl` — the action minimised |
| `cost[1]` | `size` (term DAG nodes) | `hops` (segments) |
| `cost[2]` | `width` (bits in literals) | `width` (bits in coordinates) |
| `cost[3]` | `verify` (checker's counter delta) | `verify` (certifier's counter delta) |

Both `cost[3]`s are *measured*, not modelled: L3 runs `check.py` and reads its
counters; here `certify_optical_length` independently recomputes the OPL from
the ray, compares exactly, and reads `optics.COUNTERS`' delta. The certification
gate is load-bearing and injectable so the suite can prove it
(`test_the_certification_gate_is_load_bearing`).

### The measurement

`geodesic()` run on L3's `3^8` justification graph (517 records, e-class of 99):

| | |
|---|---|
| targets where `geodesic()` reproduces `RouteFinder.route` **exactly** (path equality, not length equality) | **99 / 99** |
| those routes re-verified by `kernel/check.py` | accepted |
| light frontier on the 22-crossing family | 3 nondominated of 22, 19 dominated and all refused by `is_nondominated` |
| two named scalarizations of that one frontier | `least-action → (3,0)`, `cheap-coordinates → (0,0)` — different winners |

The light frontier is genuinely multi-objective for the same reason L3's is: the
physical optimum `x = 3` costs more bits of exact coordinate (`width` 18) than
the arithmetically cheap `x = 0` (`width` 16), and neither dominates. This is
the optical analogue of L3's `#6561` versus `sqr(sqr(sqr #3))`.

### What is NOT shared, stated plainly

`RouteFinder._dijkstra` itself is **not** called on the optics problem and
cannot be: its weights are Python `int`s accumulated as `d + w`, and an optical
path length is not an integer. Making L3 weight-generic is a small change to a
BUILT, mutation-tested layer and this lane did not have the mandate to make it.
So the accurate statement is: **the shared abstraction is implemented here and
L3's extractor is shown to be an instance of it, by running L3's adjacency and
L3's weights through it and asserting route equality.** That is a checked claim.
It is not a copy-paste, and it is not "we both use Dijkstra".

`extract.measure_route` and `extract.extract_routes` are also not shared, for
reasons `NOT_SHARED` records in the module: there is no proof object to check
for a light ray, and the optics family is a lattice rather than an e-class.

---

## 5. The disanalogy — the deliverable that matters

Fermat's principle is **stationarity**, `δ(OPL) = 0`. Cost extraction is
**minimisation**. Minimal ⇒ stationary; the converse is false, and the failure
is not exotic.

### The construction

Mirror = the circle `x² + y² = 16`. Source `(−3, 0)`, target `(3, 0)`. Those are
the foci of the ellipse `a=5, b=4` through `(0,4)`, whose radius of curvature
there is `a²/b = 25/4 > 4`. So the mirror lies **inside** the ellipse near
`(0,4)`, and the reflection there is a path-length **maximum**.

The reflection points are generated by the rational chart
`t ↦ (R(1−t²)/(1+t²), 2Rt/(1+t²))` over `t = k/4, |k| ≤ 16`, **plus** the
chart's omitted point `(−R, 0)` supplied as a second chart — `CRYSTAL.md` §4's
reachability discipline, with `notes/RATIONAL_CIRCLE_ATLAS.md`'s exact-finite /
dense / measure-zero situation restated for a mirror. Every generated point is
verified to satisfy `x² + y² = R²` exactly. The omitted locus is declared: every
irrational point of the circle and every rational point off the lattice.

### What the exact analysis finds

| index | point | OPL | kind | reflection-law residual |
|---|---|---|---|---|
| 0 | `(−4, 0)` | 8 | **minimum** | `0` (exactly) |
| 13 | `(0, −4)` | 10 | **maximum** | `0` (exactly) |
| 17 | `(4, 0)` | 8 | **minimum** | `0` (exactly) |
| 21 | `(0, 4)` | 10 | **maximum** | `0` (exactly) |

All four are genuine physical rays. The residual used is the law of reflection
cleared of denominators — `(u·t)√(v·v) − (v·t)√(u·u)`, a two-term `Surd`, so its
vanishing is decided by exactly the `a²x` vs `b²y` primitive. Every one of the
30 non-stationary points has a nonzero residual, which is the planted control
(`test_a_non_stationary_mirror_point_is_not_physical`).

### What the machinery did

* `geodesic()` returned `(−4, 0)`, OPL 8 — a minimum. Correct as a minimiser.
* `pareto()` returned **2** routes, `(−4,0)` and `(4,0)`: both tied minima
  survive, because equal cost is not domination. The plurality `CRYSTAL.md` §2
  L1 protects is preserved — **but it is plurality among minima only.**
* **The frontier misses 2 of the 4 physical rays**, and the 2 it misses are
  exactly the ones an optical designer cares about: the focusing rays of a
  concave mirror.

This is not a rounding error and not a bound that could be raised. Dijkstra's
optimal substructure is a statement about minima; "longest path" is NP-hard on a
general graph; and stationarity is not an optimisation problem at all, so there
is no cost vector under which the maxima become extractable.
`critical_points()` *does* find all four — by an `O(n)` scan of exact first
differences over the enumerated family — and it is deliberately **not** the
extraction machinery: it enumerates rather than searches, and it has no analogue
once the family is a graph rather than a line.

### The repair: state the licence, and refuse to issue it

`convexity_certificate` checks **strict discrete convexity** exactly —
`v[i+1] − 2v[i] + v[i−1] > 0` at every interior lattice point, by `Surd` sign —
and that is precisely the condition under which the only stationary point is the
minimum:

```
plane refraction: 22 samples, strict discrete convexity HOLDS -- minimisation == stationarity here
concave mirror:   34 samples, strict discrete convexity FAILS at 14 interior point(s)
```

So the scope of the unification is exact and machine-checked:

> **Cost-minimal route == physical ray exactly when the action over the path
> family is strictly convex, and the runtime checks that rather than assuming
> it.** Where it fails, the runtime is required to say "the cheapest member of
> the family", not "the physical ray" — and the demo says exactly that.

A second, quieter failure of the identification, worth recording: even *within*
the licensed case, the geodesic is a minimum over the **discrete family only**.
The true crossing is generally in the omitted locus (§3b). A proof geodesic has
the same shape of limitation — "a proof the e-graph never recorded cannot be
found", `execute/README.md` §0 — so this part of the analogy holds, including
its defect.

---

## 6. The `Realize` edge

L1 has ten fixed edge kinds and this lane does not modify the kernel, so
`Realize` is built as an **`Interp`** edge — "theory-to-theory semantics", which
is what a physical interpretation of a mathematical object is — carrying:

* a `C.Certificate` witness that must be *declared* before `check_edge` accepts;
* a dimensional signature (the reading is a `Quantity`, so it has one by
  construction);
* its modelling assumptions, in `provenance` and in `trust_note()`.

**In `STATUS.md`'s own trust-boundary terms**: `Interp` is on the declared-only
side of the line. What the kernel confirms is *a certificate of kind `Interp`
with these exact endpoints was declared*. What it does not confirm is any
physics whatsoever — not that light obeys Fermat's principle, not that the media
are homogeneous, not that the index is really 8/5.

`machine_verified` is not a settable claim. Constructing a `Realization` that
asserts it raises `TrustBoundaryError`, because no code path in this runtime
could make it true for an `Interp` edge. So does constructing one with no stated
assumptions. Both are planted controls, and so is a certificate declared for the
wrong endpoints.

---

## 7. Testing

`python3 runtime/tests/test_physics.py` — **58/58**, every capability paired
with a control that must fail. The four the brief names:

| control | test |
|---|---|
| adding metres to seconds | `test_metres_plus_seconds_is_a_construction_time_error`, `test_the_kernel_itself_refuses_the_ill_dimensioned_sum` |
| a claimed Snell solution that is not the exact optimum | `test_a_claimed_snell_solution_that_is_not_the_optimum_is_refused`, `test_no_non_optimal_crossing_has_a_zero_residual` |
| a float sneaking into a semantic path | `test_no_float_no_division_no_math_in_the_physics_sources` (AST walk), `test_the_ast_walker_itself_can_fail` |
| a `Realize` edge claiming verification it lacks | `test_realize_edge_claiming_machine_verification_is_refused`, `test_realize_edge_does_not_check_until_declared`, `test_realize_edge_certificate_must_match_its_endpoints` |

The AST walk is not a grep. It flags float/complex literals, the true-division
operator `/` (which turns two exact ints into a float), the names `float` and
`complex`, `**` with a negative or non-integer literal exponent (`2 ** -1` is
`0.5`), and any import of `math`, `cmath`, `decimal`, `numpy`, `statistics`,
`random` or `scipy`. It runs over `runtime/physics/*.py`, the demo **and the
test file itself**. A line may be exempted only by carrying an explicit
`EXACT-CONTROL` marker, every exemption is a planted float that something
refuses, and `test_the_exemptions_are_few_and_all_are_controls` caps and audits
them. The walker is itself controlled: eight planted bad sources must all be
flagged, and the exemption marker must not work when exemptions are disabled.

Plus: the routing must not consult Snell (AST, §3); the shared code must really
be L3's (`__module__` and object identity); a dominated light route must be
refused by the frontier; a forged optical length must fail certification; the
certification gate must be load-bearing (injected refusing certifier); the
optical geodesic and frontier must be deterministic; every `Surd` operation must
stay exact; the mirror's maxima must be absent from the frontier (the failure,
asserted); the convexity certificate must refuse on the mirror and issue on
refraction; and the demo must be deterministic and exit 0.

**Mutation-tested. 17 deliberate defects injected into copies, all 17 die:**
a tolerant `Surd.is_zero`; `compare_scaled_sqrt` dropping the sign flip;
`_require_same` disabled; the dimension dropped from the quantity address; the
dimension dropped from the kernel sort; Dijkstra made greedy; a maximum
classified as a minimum; the convexity certificate always licensed; the
`machine_verified` guard removed; `certify_optical_length` always true;
`_sign_by_bracket` guessing; `snell_residual` always zero; `optical_routes`
skipping certification; `ProofRouteProblem` inventing its own weight instead of
calling L3's; the stationarity scan made non-cyclic; the mirror chart dropping
its omitted point; and `lattice` off by one.

---

## 8. Files

| file | contents |
|---|---|
| `dimension.py` | `Dimension` (exact rational exponent vectors, interned, addressed), `Quantity` (dimension-checked arithmetic, dimension in the address), `sort_of` / `term_of` / `plus_of` / `add_terms` (the same guarantee from the kernel), `exact` (the float gate) |
| `optics.py` | `integer_sqrt`, `squarefree_part`, `compare_scaled_sqrt`; `Surd` (exact, total order, syntactic zero); `Vec`, `Medium`, `Ray`, `optical_path_length`; `InterfaceStack` (the discrete family, with its reachability declaration), `MirrorArc` (the rational chart plus its omitted point); `snell_residual`, `snell_invariant`, `reflection_residual` (measurement only); `critical_points`; `reset_caches` |
| `geodesic.py` | `RouteProblem` / `Arc` / `geodesic` (the shared Dijkstra); `ProofRouteProblem` (L3's adjacency and weights), `OpticsRouteProblem`, `MirrorRouteProblem`; `OpticalCost`, `optical_routes`, `mirror_routes`, `optical_frontier`, `certify_optical_length`; `convexity_certificate`, `snell_bracket`; `Realization` / `realize`; `SHARED_CODE`, `NOT_SHARED` |
| `../demo/fermat_demo.py` | the measured demonstration; exits 0 iff every claim above holds |
| `../tests/test_physics.py` | 58 tests, every planted-false control, the AST auditor |

### A naming wart, documented

`dimension.py` exports a function `dimension()` and `geodesic.py` a function
`geodesic()`. Re-exporting those names from `runtime/physics/__init__.py` would
shadow the submodules of the same name, so at package level they are
`make_dimension` and `find_geodesic`, and `runtime.physics.dimension` /
`runtime.physics.geodesic` stay the **modules**. Inside the submodules the
natural names are unchanged: `from runtime.physics.geodesic import geodesic`.

---

## 9. What breaks first at scale

Ordered by how soon it bites.

1. **`Surd` sign determination is the whole cost model, and it is not cheap.**
   The demo does 16 929 sign decisions and 12 093 bracket refinements for a
   2 500-arc problem. Every heap comparison in Dijkstra is a `Surd` subtraction
   plus a sign, versus an `int` compare in L3 — so the *same* algorithm is two
   to three orders of magnitude more expensive on light than on proofs. The
   memo on `(radicand, precision)` and on canonical term tuples is doing heavy
   lifting and is unbounded (see 5). The real fix is to compare OPLs
   incrementally along the search rather than recomputing whole sums, and to
   keep a cheap rational bracket alongside each `Surd` so most comparisons never
   reach the exact path.
2. **The path family is exponential in the number of interfaces.** A stack of
   `k` interfaces with `L` lattice points each has `L^k` rays. Dijkstra reaches
   the optimum with `O(k·L²)` arcs, which is the whole reason to phrase it as
   routing — but the Pareto frontier is `O(n²)` over *routes*, so
   `optical_frontier` is only run on single-interface families in the demo. A
   frontier over the layered family needs bottom-up Pareto extraction over the
   layer DAG, which is exactly the fix `execute/README.md` §10.2 names for L3's
   materialisation cliff. The same fix, twice.
3. **Lattice refinement is the only accuracy knob and it is linear.** The
   certified Snell bound shrinks like `h`, so ten more bits of accuracy costs
   `2¹⁰` lattice points per interface. Newton on the exact residual would be
   quadratic and stays inside exact arithmetic — but its iterates leave the
   rational lattice, so it needs `Surd`-valued coordinates, and then the
   radicands stop being small integers and `squarefree_part`'s trial division
   (currently `O(√n)`) becomes the bottleneck instead.
4. **`squarefree_part` is trial division.** Fine for `dx² + dy²` with small
   rational coordinates; hopeless for coordinates with large denominators, where
   it is factoring `p·d`. Squarefree decomposition does not actually require
   full factorisation, and the current code does more work than the answer
   needs.
5. **The memo tables never evict.** `_SQUAREFREE`, `_BRACKET`, `_SIGN` grow for
   process lifetime — correct, deterministic, unbounded, and exactly the failure
   mode `execute/README.md` §10.5 records for its own caches. `reset_caches()`
   exists so demos are reproducible from a cold cache, not as a memory policy.
6. **Only two dimensions of space.** `Vec` is planar. Nothing in the routing
   cares, but `sine_to_normal` assumes the interface normal is the `y` axis, so
   3-D or curved interfaces need the residual restated, not just a third
   coordinate.
7. **The convexity certificate is a statement about the *sampled* family.**
   Strict convexity at every lattice point does not imply convexity of the
   continuum functional. For a plane interface it happens to be true and
   provable by hand; the certificate does not prove it, it checks the samples,
   and it says "on the sampled family" rather than pretending otherwise. A
   family whose OPL is convex at every lattice point and non-convex between them
   would be certified wrongly, and nothing here would catch it.
