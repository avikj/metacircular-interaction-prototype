> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# `runtime/render` — perceptual compilation

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

Implementation of the perceptual arm of **CRYSTAL.md §7 REALIZE** ("compile to
symbolic / executable / **perceptual** surfaces"), built to the discipline the
rest of the runtime uses for everything else, and reporting against **§0**
(measured, with a null control) and **§4** (say what is omitted).

The whole package exists to make one sentence mechanical:

> **A channel is a projection of one object, with explicit information loss and
> stated round-trip guarantees. Never an independent semantic copy. Never a
> truth authority.**

CPU-only. Pure Python 3 standard library. Exact integer and `Fraction`
arithmetic — **no float in any semantic path**, enforced by an AST walk over
this package's own sources in the test suite. No ML, no network, no
randomness beyond one printed integer recurrence. Deterministic: the demo and
all three SVG artifacts are byte-identical across processes and across
`PYTHONHASHSEED` values, checked in the suite.

**Independence.** This package imports nothing from `runtime/kernel/`,
`runtime/crystallize/` or `runtime/distinguish/`, and nothing outside the
standard library. The test suite asserts this on the parsed import graph.
The *vocabulary* of `runtime/distinguish/` — task-relative sufficiency,
collisions as data, exhaustive proof rather than sampling — is deliberately
shared; the code is not. `svg.py` additionally imports nothing from its own
package, so a colour bug cannot hide behind a rendering bug.

```
runtime/render/channel.py     the abstraction: languages, tasks, fibres, certificates
runtime/render/chroma.py      the chromatic channel: exact colour, five layers, precedence
runtime/render/svg.py         a minimal exact SVG writer, integer geometry, hand written
runtime/demo/render_demo.py   the artifacts and the measured report
runtime/tests/test_render.py  68 tests, adversarial, with planted-false controls
```

Run:

```
python3 runtime/demo/render_demo.py     # ~2 s; writes runtime/demo/out/*.svg
python3 runtime/tests/test_render.py    # 68 tests, ~30 s
```

---

## 1. What a channel must be able to say

`Channel` is not "a function that returns a colour". It is an object that can
produce, **by exhaustive check over a declared finite `Language`**, four
certificates. Nothing here is sampled and nothing is asserted.

| certificate | claim | how it is obtained |
|---|---|---|
| `InjectivityCertificate` | injective on this language, or not | every state encoded; first collision in language order retained as a witness |
| `LossCertificate` | image size, full fibre histogram, a **collision witness** | fibres built and counted |
| `RoundTripCertificate` | fibres exact; and, if injectivity is *declared*, an **implemented** inverse that is right on every state | fibres **recomputed from scratch**, never read from the channel's cache |
| `PreservationCertificate` | which declared distinctions survive | all `C(n,2)` unordered pairs |
| `ClaimCertificate` | recognition-cost, or rejected | see §2 |

Two design decisions carry most of the discipline.

**`decode` returns the fibre, and cannot do otherwise.** It is implemented once,
on the base class, as "every state of the declared language mapping to this
code". It is not a hook a subclass is invited to reinterpret. A lossy channel
therefore cannot return a single guess without overriding a method whose
contract forbids it — and `validate_channel` catches exactly that override, on
two independent grounds (an element that is not a state of the language, and
fibres that fail to cover the language). The single-valued inverse lives on a
separate method, `decode_exact`, which **refuses to run** until an exhaustive
injectivity check has passed.

**Preservation is reported as four populations, not one boolean**, because they
are four different statements:

| column | meaning |
|---|---|
| `required_separations` | pairs the task separates and the code separates — what the channel *preserves* |
| `violations` | pairs the task separates and the code identifies — refutes the claim; a witness is kept |
| `permitted_collisions` | pairs the task does not separate and the code identifies — the compression working |
| `over_separations` | pairs the task does not separate but the code does — recognition cost bought for nothing |

The last column is the one that is usually omitted elsewhere. It is
`runtime/distinguish/` step 6 in perceptual clothing: a channel with large
`over_separations` is spending code on distinctions no declared task uses.

---

## 2. The proposition that bounds every claim here

> **A channel cannot gain information.** A channel is a function `encode` on
> the declared language `L`. Hence `|image(encode)| ≤ |L|`, and the partition
> of `L` it induces is a coarsening of equality. So no channel can separate
> two states the raw representation does not separate, and no channel can
> answer a query the raw state cannot answer.

`certify_claim` enforces this. A channel declaring `INFORMATION_GAIN` is
rejected, and the rejection is a theorem about functions rather than a house
style. The demo runs that rejection live. Consequently the **only** admissible
claim in this package is **recognition-cost reduction** — fewer operations to
reach an answer the state already implies — and every claim certificate says so
in words, with the exact compression attached.

This is where the package "knows the difference and can state which it is
claiming".

---

## 3. Colour is exact, and what is approximated is named

A colour is three integers in `0..255`. Where a perceptual notion is needed —
"are these far enough apart" — the arithmetic happens in an **exact rational
opponent space**:

```
Y  = (299 R + 587 G + 114 B) / 1000        (Rec.601 luma, exact Fractions)
Co = (R - B) / 2
Cg = (2G - R - B) / 4

S  = 2Y - (37/100)Co - (587/250)Cg   (= R + B)
R  = S/2 + Co,   B = S/2 - Co,   G = 2Cg + S/2
```

The inverse is exact and is tested to be the identity on every integer colour
of the lattice, every grey and every primary.

**What is approximated, and how.** This is **not** CIELAB. CIELAB's lightness
step is a cube root, which has no exact rational form. It is therefore not
approximated here — it is *replaced* by a linear surrogate that is exactly
computable in ℚ. The consequences, stated rather than buried:

* the surrogate is a linear transform of gamma-encoded sRGB, so it inherits
  sRGB's own nonlinearity and is **not perceptually uniform**;
* the surrogate's ordering of two colour pairs is **not guaranteed** to match
  CIELAB's;
* every distinguishability **proof** rests on exact code inequality — integers
  being different — never on the surrogate. The surrogate supplies a
  **measured** minimum separation, printed beside the proof precisely so the
  two are never confused.

Distance weights are `(4, 1, 1)` on `(Y, Co, Cg)`: a declared modelling choice,
not a derived fact. `CHROMA_WEIGHTS = (0, 1, 1)` exists for palettes that must
survive a higher layer overwriting `Y` (§4).

**Three loss sources, all counted.** Fibres (many states → one code);
quantisation (rational → 8 bits, round-half-to-even, implemented with integer
arithmetic only); and **gamut clamping** when components taken from different
layers compose to a point outside the sRGB cube. The third is loss introduced
by rendering rather than by mathematics, so the demo prints it per channel
(`chroma_orbit` clamps on 168 of 256 states) and the suite asserts that no
clamp collapses a distinction a declared task needs.

---

## 4. Layers and precedence

Ascending precedence, fixed in `CANONICAL_PRECEDENCE`:

| # | layer | reads |
|---|---|---|
| 0 | `ancestry` | position in the term DAG — the **lexical/syntactic** layer |
| 1 | `sort` | the sort/type of the node |
| 2 | `family` | the dependency family |
| 3 | `symmetry` | which automorphism orbit (symmetry sector) |
| 4 | `semantic` | an explicit override attached to meaning |

Composition is **component-wise in ascending precedence**: every layer proposes
a whole colour but contributes only the opponent components it *claims*, and a
higher layer overwrites the components it claims. A layer may **decline**
(return `None`), in which case lower layers show through — so precedence is
visible in the rendered artifact, not only in the source.

`Layer.precedence` is stored explicitly rather than derived, so a **wrong**
precedence is representable and therefore catchable. A discipline nothing can
violate is a discipline nothing tests.

`certify_precedence` checks three things, and the second is the real one:

1. each layer's declared precedence equals the canonical precedence for its role;
2. every resolution is recomputed by an **independent descending-precedence
   walk** sharing no code path with the ascending one, and the two must agree
   colour for colour on every state;
3. wherever the semantic layer proposes, it wins **every** component and the
   resolved colour is exactly its proposal.

**Semantic beats lexical — the direction's own example, as a test.** The
lexical layer maps the letter `b` to yellow `#ffcc00`.

| token | sort | ancestry | sort | semantic | resolved | winners |
|---|---|---|---|---|---|---|
| `beta` | Word | `#ffcc00` | declines | declines | **`#ffcc00`** | all ancestry |
| `blue` | Word | `#ffcc00` | declines | `#0000ff` | **`#0000ff`** | all semantic |
| `gamma_3` | Digit | `#cc00cc` | `#404040` | declines | **`#b800b8`** | Y=sort, Co/Cg=ancestry |

`blue` renders blue although `b` is yellow. `gamma_3` shows a genuine partial
layer: the sort layer claims `Y` alone and declines on `Word`, so it tints
without repainting.

---

## 5. The mathematics, and the theorem each picture makes visible

The state model is `notes/DIGIT_CRYSTAL.md` §0–§1: little-endian base-`b` digit
words, `b = 4`, `n = 4`, so **256 states**, with the odometer `T (v ↦ v+1)`, the
digit complement `E (c_i ↦ b-1-c_i`, i.e. `v ↦ b^n-1-v`, Props 1.2/1.3) and word
reversal `D` (§1.1) present as a *symmetry*, never as an action. `b = 4, n = 4`
is chosen so the state space is a **16 × 16 grid** in which the row is the high
digit pair, the column is the low digit pair, and `E` is exactly the **point
reflection through the centre**.

### `out/carry_cocycle.svg`

Two panels, identical layer stacks and identical palettes, so any difference
between them is mathematics and not styling. Left: the carry count
`c_n(w)` = trailing `(b-1)` digits = the carries `T` produces = `v_b(L(w)+1)`.
Right: the borrow count `z_n(w)` = trailing zeros = `v_b(L(w))`.

> **Theorem made visible — DIGIT_CRYSTAL (2.2): `c_n(E x) = z_n(x)`.**
> The digit complement exchanges carry with borrow. Since `E(v) = b^n-1-v` is
> the point reflection of the grid, the claim is: **the right panel is the left
> panel rotated by half a turn.**

The demo does not invite the reader to believe this. It checks the identity on
the **exact colours written into the file** — `right(v) = left(255-v)` for all
256 cells — and the test suite re-checks it by parsing the SVG back and
comparing every `<rect fill=…>` against the channel. The file is not allowed
to say something the channel did not compute. A separate control asserts the
two panels differ on 128 cells, so "rotated by half a turn" is not vacuous.

The nesting visible in the columns is the ruler sequence `c_n(x) = v_b(x+1)`:
every 4th column carries, every 16th carries twice.

**Legends are channel-derived, not palette-derived.** Every swatch is the
*resolved* colour of a representative state — after every layer, override,
quantisation and clamp — so a legend cannot paint a colour the picture never
uses. The demo checks the two agree as sets (5 cell colours, 5 swatches; 7 and
7) and aborts if they do not. Painting the palette instead would have shown a
pale-yellow `c = 4` swatch that appears nowhere in the file, because the
semantic layer overrides that one cell; the check is what caught it.

**What a reader could misread, printed in the artifact itself:**

* (a) the reflection symmetry does **not** make `E` an additive automorphism of
  `ℤ/256`; `E(v) = -1-v` is minus the identity followed by a translation
  (Prop 1.2);
* (b) equal colour steps are **not** equal magnitude steps — the ramp is linear
  in the non-uniform surrogate of §3;
* (c) the pink cells are the two states where cocycle (2.1) is not stated
  (it holds for `x < b^n-1`), marked by the semantic layer — not a fifth carry
  class of a different kind;
* (d) the picture is **not invertible**: 256 states are shown in 5 colours and
  the largest fibre holds 192 of them.

### `out/symmetry_sectors.svg`

Colour = which `⟨D,E⟩` symmetry sector the word lies in, with the ancestry layer
showing through on generic orbits and the semantic layer overriding on the
constant words.

> **Theorem made visible — DIGIT_CRYSTAL Thm 3.4 and Thm 4.2(2).**
> `|Fix D| = b^⌈n/2⌉ = 16` palindromes (orange); `|Fix DE| = b^⌊n/2⌋ = 16`
> antipalindromes (purple); `|Fix E| = 0` since `b` is even, so the two sets are
> disjoint; Burnside gives `(256+16+0+16)/4 = 72` orbits, verified against a
> direct orbit count. The 4 cyan cells are the constant words — exactly the
> agreement locus of Thm 4.2(2), where `π R = R π` — and they sit on the grid
> diagonal.

This is also where **layer precedence is something you can point at**: generic
cells fall through to the ancestry (lexical) layer and are coloured by the root
constructor `γ_{c_0}` of the term DAG; the symmetry layer paints only the two
fixed sectors; the semantic layer then overrides symmetry on the 4 constant
words — 4 cyan cells inside the 16 orange ones.

Misreadings, again printed in the file: the four ancestry colours encode `c_0`
only, so two generic cells of the same colour are **not** in the same orbit
(56-state fibres); and orange and purple are disjoint here only because `b` is
even.

### `out/layer_precedence.svg`

The token table of §4, drawn: every layer's proposal, which layer declined,
the resolved colour and the per-component winner.

---

## 6. Task-distinguishability, proved

`certify_distinguishability` proves — exhaustively, over every unordered pair —
that codes assigned to states a declared task must distinguish are pairwise
distinct, and reports that codes for task-equivalent states are *allowed* to
collide. Then, separately, it measures the exact minimum surrogate separation
between codes of different classes.

| channel | task | classes | codes | distinguishes | min surrogate separation |
|---|---|---:|---:|---|---|
| `chroma_carry` | carry class `c_n` | 5 | 5 | **yes** | `689587469/62500` |
| `chroma_carry` | exact value `L(w)` | 256 | 5 | **no**, with witness | `0` |
| `chroma_borrow` | borrow class `z_n` | 5 | 5 | **yes** | `689587469/62500` |
| `chroma_orbit` | symmetry sector | 3 | 7 | **yes** | `1556445261/250000` |
| `chroma_low2 \| low2` | low pair `(c_0,c_1)` | 16 | 16 | **yes** | `590741721/62500` |

The second row is the point: **the same channel** proves one task and provably
fails another, with a witness. A channel is never good in the abstract. Same
discipline as `runtime/distinguish/`, applied to a perceptual surface.

The same duality appears in the round trip. `chroma_low2` is **one** channel
seen on two declared languages:

| language | states | codes | injective | round trip |
|---|---:|---:|---|---|
| `W_4^4[low2]` (the declared sublanguage `c_2 = c_3 = 0`) | 16 | 16 | **yes**, exhaustive over 120 pairs | **exact**: an implemented inverse, checked on all 16 states |
| `W_4^4` (ambient) | 256 | 16 | no | `decode` returns a **16-state fibre**, never a guess |

That is the homometry result of `notes/CROSS_LENS.md` §2 made executable: one
projection identifies distinct objects, so `decode` *cannot* be single-valued
there, and the type of `decode` says so.

---

## 7. The measurement — a machine-side proxy, and only that

**Query.** "Is state `w` in carry class `k`?" — the recognition query the
picture serves. **Unit:** one comparison of two integers. Both paths get every
arithmetic shortcut: the raw path stops scanning at the first digit that is not
`b-1`, exactly as `carry_count` does. **Batch:** 1024 queries, states and
targets drawn by the printed recurrence `x ← (1103515245x + 12345) mod 2^31`,
seed 20260812.

| quantity | value |
|---|---:|
| comparisons, RAW state | 2398 |
| comparisons, CHROMATIC CODE (already rendered) | **1472** |
| comparisons, NULL CONTROL (`chroma_carry × chroma_low2`) | 6826 |
| answers agree with the raw computation | YES |
| saved per query | `463/512` |
| one-time cost of encoding all 256 states | 596 |
| break-even | **660 queries** |
| worst fibre (what the reduction costs in information) | 192 states → 1 code |

**Null control.** `chroma_low2` is a true channel and irrelevant to this task.
Reading it alongside `chroma_carry` does not speed the query up: it makes the
class a 12-code set instead of a single code, and the batch costs **+5354**
comparisons. A surface that made every query cheaper would be measuring its own
cache, not its mathematics (`CRYSTAL.md` §0). This is the same shape as
`runtime/distinguish/`'s `+616`-step null channel.

**The cost of the code.** Encoding all 256 states costs 596 comparisons —
strictly more than answering once from the raw state, because encoding
*contains* the raw scan. The reduction is therefore real only when the code
already exists, which is exactly the situation a rendered picture is in.

### The caveat, in the README as well as in the output

> These are **machine-side comparison counts**. They are a **proxy** for
> recognition cost and nothing more. No human looked at anything here; no
> reaction time, error rate or visual-search measurement was taken, and none is
> possible from this program. **Nothing here establishes that a person
> recognises the carry class faster from the colour than from the digits.** The
> honest statement is: the channel reduces the number of comparisons a machine
> performs, loses 192-to-1 in its worst fibre, and its value to a human reader
> is *unmeasured*.

Per the brief: the value of a channel may be recognition-cost reduction rather
than information gain, and the system must know which it is claiming. It claims
recognition cost, it proves the information-gain claim impossible (§2), and it
declines to convert a comparison count into a claim about eyes.

---

## 8. Adversarial testing

68 tests. Every capability is paired with a planted-false control that **must**
be caught:

| control | what is planted | what must catch it |
|---|---|---|
| `test_planted_injective_channel_with_a_collision` | a channel declaring injectivity that collides | exhaustive check; witness is the first pair in language order; `decode_exact` raises |
| `test_planted_lossy_decode_returns_a_single_value` | a subclass whose `decode` returns one state | `validate_channel`, on both the type and the partition test |
| `test_planted_precedence_violation_lexical_over_semantic` | lexical wired above semantic, so `blue` renders **yellow** | `certify_precedence`, twice: canonical order *and* semantic dominance |
| `test_planted_float_is_caught_by_the_scanner` | a file with a float literal, and one with true division | the AST scanner itself, so a green scan means something |
| `test_planted_information_gain_claim_is_rejected` | a channel claiming to add information | `certify_claim` |
| `test_planted_wrong_inverse` | an inverse returning the wrong preimage | `certify_round_trip` |
| `test_planted_distinguishability_claim_on_a_colliding_task` | a task the channel cannot separate | `certify_distinguishability`, with a witness |
| `test_planted_base_layer_*` | a layer stack that leaves a component unset | construction-time coverage check |
| `test_the_panels_are_not_identical_…` | the risk that the rendered theorem is vacuous | 128 cells must differ |

**Mutation-tested.** A green suite that has not been mutation-tested is an
untested suite. Twelve deliberate defects were injected into copies of the
package — injectivity never witnessing, preservation miscounting violations as
permitted collisions, `decode` truncating the fibre, the canonical-precedence
check disabled, the clamp flag never raised, rounding degraded to floor, the
carry count reading the wrong end of the word, the SVG writer accepting
non-integer geometry, the information-gain claim accepted, the round trip never
checking the inverse, the layer-coverage check removed, and semantic dominance
never checked — and the suite kills all of them.

---

## 9. Reachability discipline (§4): what this surface omits

For the installed `chroma_carry` channel:

| slot | value |
|---|---|
| generated locus | all 256 states of `W_4^4` |
| exact image | 5 colours |
| equivalence kernel | the level sets of `c_n`, of sizes 192, 48, 12, 3, 1 |
| closure/completion | `ℤ_4` (DIGIT_CRYSTAL §0); `c_n` extends, since `c_n(x) = v_b(x+1)` is defined on `ℤ_b` |
| **omitted locus** | everything above the trailing `(b-1)`-run: the picture cannot see any digit past the first non-`(b-1)` one |
| operations that extend | `T`, `E` (and `E` exchanges the two channels, which is the rendered theorem) |
| operations that do not | `D` = word reversal — `c_n(D x) = ℓ_n(x)`, the *leading* count, which has no limit (Thm 4.2/4.4) |
| may not claim | anything about a task that reads `D`, or any task finer than the carry class |

`D` is present in `chroma_orbit` as a *symmetry sector* and never as an action,
for exactly the reason `runtime/distinguish/` gives: the residual is the endian
class.

---

## 10. What breaks first at scale

In the order it bites, measured or derived from the implementation.

1. **`certify_preservation` is `O(|L|²)` per task.** 256 states is 32 640
   pairs; the demo already spends 326 520 pair visits across its certificates.
   At 10⁴ states it is 5·10⁷ pairs per task, and at 10⁵ it is infeasible. The
   fix is the class-count identity `refines` already uses (`O(|L|)` by
   comparing partition sizes) — it decides *whether* preservation holds in
   linear time but does **not** produce the witness or the four-population
   counts, and the counts are most of the value. So the honest statement is
   that the cheap check and the informative check are different checks, and
   only the expensive one is currently implemented.
2. **`categorical_palette` is `O(|lattice| · k²)` and, worse, is capped at 216
   colours.** Beyond ~30 categories a farthest-point palette on the web-safe
   lattice stops separating anything: the minimum pairwise separation falls off
   and the "distinguishable" claim would have to be downgraded to "distinct
   integers", which is what the proof actually rests on anyway. Categorical
   colour does not scale, and no amount of exactness fixes that — it is a
   property of the medium.
3. **`Channel._build` materialises every fibre.** One dict entry per state.
   Fine at 256, dominant at 10⁶, and it is the memory wall before the time
   wall.
4. **The SVG grows linearly in cells with a large constant** (~400 bytes per
   cell with a `<title>` tooltip): 256 cells is 104 KB, so 10⁴ cells would be
   ~4 MB and 10⁶ cells is not a document. The escape is a colour-run encoding
   or a raster, and a raster would give up the exact-text property that makes
   these files checkable.
5. **`certify_distinguishability`'s separation scan is `O(codes²)` with the
   class cross-product inside it.** Cheap here (32 794 comparisons) because the
   channels have 5–16 codes; quadratic in the code count in general.
6. **Layer resolution allocates a `Fraction` triple per layer per state.**
   Exactness is not free: `chroma.layer` fires 13 348 times in the demo. A
   fixed-point integer representation with a declared denominator would be
   ~10× cheaper and equally exact, and is the obvious next optimisation.
7. **Nothing here is incremental.** A new task recompiles every certificate
   from scratch. The certificates are pure functions of `(channel, language,
   task)` and could be cached on those three addresses — which is precisely
   what `CRYSTAL.md` L0 content addressing is for, and is not wired up.
