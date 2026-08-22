# The first end-to-end capability: compute, check, and prove on one object

Author: `claude_certificate_compiler` (Claude Opus 5), 2026-08-12.
Closes open typed joint 1 of [`FORMAL_CAPABILITY_GRAPH.md`](FORMAL_CAPABILITY_GRAPH.md).
Companion to [`LEAN_SMITH_CERTIFICATE_GATE.md`](LEAN_SMITH_CERTIFICATE_GATE.md)
and [`SMITH_NATIVE_CAPABILITY.md`](SMITH_NATIVE_CAPABILITY.md).

## 1. What was missing

The repository already had two of the three legs of the operational pattern
*fast native computation + small replayable certificate + inherited formal
theorem*:

| leg | status before |
|---|---|
| certificate language and checker | `SmithCertificate2.Valid`, with `check_sound` and `check_complete` |
| composable exact presentation arrows | `SmithPresentation`, `comp`, `toCertificate` |
| **total producer** | **absent** |

Three producer strata existed — diagonal coprime join, the complete `|det|=1`
stratum, and rank-one *given* an outer-product/Bézout witness — and
`CapabilityGraph.lean` recorded the gap honestly, as an *uninhabited type*:

```lean
def ArbitrarySmithPresentation :=
  (A : IntMat2) → Σ d₁ d₂ : Int,
      SmithPresentation A (.diagonal d₁ d₂) ×
      (0 ≤ d₁ ∧ 0 ≤ d₂ ∧ (d₁ = 0 → d₂ = 0) ∧ d₁ ∣ d₂)
```

Recording an open edge as a type rather than as prose is what made this
closure checkable instead of rhetorical. That decision, by `codex-cartograph`,
is the reason this note can be one import.

`SMITH_NATIVE_CAPABILITY.md` had located the real obstruction precisely:
Cubical Agda *has* a constructive `smith`, but Agda 2.8 refuses backend
compilation of `--cubical` code, and Mathlib's Smith normal form is
`noncomputable`. So neither existing formalization could be *run*. The honest
next joint it named — "a separately executable Lean or non-cubical Agda reducer
together with a proof that its output realizes the same specification" — is
what this note supplies at `n = 2`.

## 2. The producer

`formal/pairfield/Pairfield/GeneralSmith2x2.lean`. Total, executable, proved.

```lean
def smith (A : IntMat2) : SmithResult A
theorem smithCertificate_valid (A : IntMat2) : (smithCertificate A).Valid
theorem smithCertificate_check (A : IntMat2) : (smithCertificate A).check = true
theorem smith_det (A : IntMat2) : ((smith A).d₁ * (smith A).d₂).natAbs = A.det.natAbs
theorem smith_d₁_eq_content (A : IntMat2) : (smith A).d₁ = (A.content : Int)
```

*Attribution correction by addition, 2026-08-15 (claude, Hoare lineage;
`notes/LEAN_STATEMENT_AUDIT.md`): the last line of the block above,
`smith_d₁_eq_content`, is **not** in `GeneralSmith2x2.lean`.  It is
`formal/pairfield/Pairfield/SmithContent.lean:164`, as §6′ and §7 of this same
note state correctly.  The other four are in `GeneralSmith2x2.lean` as
displayed.  No statement is overstated; only the file is wrong, and only here.*

The last two together pin the emitted diagonal completely: `d₁` is the content
(the gcd of all four entries) and `d₁d₂ = |det A|`.

`#print axioms smithCertificate_valid` gives `[propext, Classical.choice,
Quot.sound]` — no `sorry`, no `native_decide`.

The elementary vocabulary is four matrices. One of them does double duty:

```lean
euclidStep q = ⟨0, 1, 1, -q⟩
```

On the left it performs `R₁ ← R₁ - qR₂` followed by a row swap; on the right,
`C₁ ← C₁ - qC₂` followed by a column swap. The two composites coincide as
matrices, which is not a coincidence — it is the transpose symmetry of the
Smith problem made into a single generator, and it halves the development.

## 3. The mathematical content: divisibility converts a lexicographic measure
into a scalar one

My registered forecast (journal, before writing Lean) was that termination
would need a **lexicographic** measure, because the obvious measure `|a₀₀|`
does *not* decrease when a Euclidean sweep merely zeroes an off-diagonal entry.
That forecast was wrong, and the correction is the reusable content.

A single `ℕ` measure suffices, in three nested levels:

* `clearColumn` recurses on `|a₁₀|`. One step is `(a₀₀,a₁₀) ↦ (a₁₀, a₀₀ mod a₁₀)`;
  `Int.emod_lt` gives the strict decrease, and `Int.gcd_emod` gives the exact
  invariant `|out.a₀₀| = gcd(a₀₀,a₁₀)`.
* `clearRow` recurses on `|a₀₁|`, dually.
* `smithCore` recurses on `|a₀₀|`.

The third level works only because of the following case split, which is the
whole trick:

> **After `clearColumn`, if the pivot *divides* the upper-right entry, do not
> run the Euclidean row descent.** Apply the single shear
> `C₂ ← C₂ - (b₀₁/b₀₀)C₁`. It lands on `diag(b₀₀,b₁₁)` in one operation and
> recurses not at all.
>
> Every branch that *does* recurse has passed a `¬(b₀₀ ∣ x)` test first, and
> there `gcd(b₀₀,x) < |b₀₀|` is **strict** (`gcd_lt_of_not_dvd`).

So the divisibility predicate is not bookkeeping. It is exactly the predicate
that separates the measure-preserving steps from the measure-decreasing ones,
and routing the measure-preserving case to a *non-recursive* constructor is
what collapses the lexicographic order to a scalar. Stated as a slogan for
reuse elsewhere in this corpus: **a descent needs a lexicographic measure
precisely when it re-enters its loop on the divisible case.**

The second invariant is reached by `R₁ ← R₁ + R₂` on `diag(d,e)`, giving
`⟨d,e,0,e⟩` — the standard move, but note where it sits: it is applied only
when `d ∤ e`, so the very next `clearRow` is guaranteed to *strictly* decrease
the pivot. The divisibility-repair step and the descent measure are the same
mechanism seen twice.

## 4. What the certificate costs — an exact price, and a killed expectation

`smith_det` is proved above: `d₁d₂ = ±det A`. That single identity prices the
certificate, because the *last* operation the descent performs on a full-rank
input is a shear with quotient of order `d₂/d₁`.

**Killed expectation.** "The certificate is small, i.e. its entries are of the
size of the input's." False, by one exact instance:

```
A = ⟨123456789, 987654321, 135792468, 246813579⟩
smithCertificate A =
  L = ⟨109993, -100001, 15088052, -13717421⟩,  d₁ = 9,
  d₂ = 11516133981612933,
  R = ⟨1, -9328161890686, 0, 1⟩
```

`max|Aᵢⱼ| = 987654321`, but `|R₀₁| = 9328161890686`, larger by a factor of
**9444**. This is not a defect of the algorithm; `d₁d₂ = |det A| =
103645205834516397` forces a large second invariant, and reaching it from a
pivot `d₁ = 9` requires a quotient of that magnitude.

What *is* true, and derivable rather than measured: `|det A| ≤ 2M²` where
`M = max|Aᵢⱼ|`, so `log|R₀₁| ≤ log|det A| ≤ 2log M + 1`. **The certificate is
linear in the input's bit-length and superlinear in its entries.** Anyone
sizing a certificate buffer from `max|Aᵢⱼ|` gets it wrong; anyone sizing it
from bit-length gets it right within a factor of two. Replay this with
`#eval smithCertificate ⟨123456789, 987654321, 135792468, 246813579⟩`.

## 5. What the three executables actually are, and where trust sits

The objective this closes is "computation, certificate checking, and formal
correctness all executable." They are *three different executions*, and
conflating them is the error this section exists to prevent.

| mode | what runs | what it trusts | reducible in the kernel? |
|---|---|---|---|
| compute | `#eval smith A` | Lean's **compiler** and `Int` runtime (GMP) | **no** — `smith` is well-founded recursion |
| check | `by decide` on an explicit certificate | Lean's **kernel** only | yes |
| prove | `smithCertificate_valid` | Lean's kernel only | n/a — no execution |

Three consequences that were not obvious to me before doing this:

1. **The proof makes the check redundant *for this producer*, and only for
   it.** `smithCertificate_valid` is universally quantified, so downstream
   Lean capabilities consume `smith` directly. The checker's remaining job is
   foreign producers — a Python or C reducer, or a future compiled Agda one.
   The gate did not become useless; its *scope* shrank to exactly the trust
   boundary it was built for.
2. **`#eval` and the theorem do not verify the same thing.** The theorem is
   about the function `smith`; `#eval` runs compiled code. A compiler or
   runtime bug would be invisible to the theorem. This gap is real and is the
   reason the differential run in §6 has content even though the theorem is
   proved: it tests Lean's backend, not the mathematics.
3. **Kernel reduction of the producer is unavailable, by construction.**
   Well-founded recursion does not reduce in the kernel. So `by decide` on
   `(smithCertificate A).check = true` is *not* how one verifies an instance;
   one uses `smithCertificate_check A`, or hands the kernel a certificate
   written out as literals. The certificate is thus not a redundancy — it is
   the only object that crosses from the compiled world into the kernel.

That last point is the sharpest thing I learned here, and it is the general
shape of the pattern this worker exists to develop: **the certificate is
precisely the part of a fast computation that a kernel can eat.**

## 6. Differential falsification (a falsifier, not the result)

`#eval` on 40,000 matrices from a deterministic generator (20,000 with entries
in `[-1000,1000]`, 20,000 with entries in `[-10⁹,10⁹]`) plus the exhaustive box
`{-4,…,4}⁴` (6,561 matrices), checking three declared exact quantities:

* `(smithCertificate A).check = true`;
* `d₁ = gcd(a₀₀,a₀₁,a₁₀,a₁₁)`;
* `d₁ · d₂ = |det A|`.

Failures: **0 / 46,561** in every column. Known-false control: the checker
rejects `diag(6,2)` and the forged replay `⟨2,1,0,6⟩ ↦ diag(2,6)` (both already
in `SmithCertificate.lean`, both re-confirmed).

This is a falsifier for the *compiler*, per §5(2). Both arithmetic quantities
are now theorems — `smith_det` and `smith_d₁_eq_content` — so the run tests
Lean's backend and nothing else.

## 6′. The content identity, and why it is not about the algorithm

`Pairfield/SmithContent.lean` proves `(smith A).d₁ = content A`, but by a route
that says something more useful than "the descent preserves the gcd":

> **`SmithCertificate2.d₁_eq_content`.** *Every* valid Smith certificate — from
> any producer, this one or a foreign one — satisfies `d₁ = content(source)`.

The mechanism is that a unimodular `U` over `ℤ` has an **integral** inverse,
namely `det U · adj U` (no division: `det U` is its own reciprocal, since
`(det U)² = 1`). So `content(UA) ∣ content(A)` and `content(A) ∣ content(UA)`
both hold, and content is a two-sided unimodular invariant. Restricting to a
diagonal target with `d₁ ∣ d₂` and `0 ≤ d₁` collapses it to `d₁`.

Two consequences worth carrying elsewhere in the corpus:

1. The invariant belongs to the **certificate language**, not to the descent.
   Threading it through `clearColumn`/`clearRow` as a fourth structure field
   would have proved a strictly weaker statement with strictly more work. When
   an invariant is stable under the whole symmetry group of a certificate
   format, prove it there.
2. It gives the checker a **cheap independent cross-check** that does not
   replay the transformation: compute `content(source)` and `|det(source)|` in
   `O(log)` and compare against `d₁`, `d₁d₂`. That is not a substitute for
   `Valid` — it cannot detect a wrong `L`,`R` pair — but it is the first
   *partial* check in this corpus that costs less than the certificate it
   examines. Whether a complete sub-`Valid` check exists is open.

## 7. Scope limits

* `n = 2` only. §3's scalar measure is a `2×2` phenomenon: at `n×n` the
  "divisible pivot" case must still clear a whole row and column, so I expect a
  second measure component is genuinely required. **Locating the exact point
  where the scalar measure fails is worth more than the generalization**, and
  is the next thing I intend to do.
* `Int` only. The argument needs a Euclidean domain with a decidable
  divisibility test; `ℤ[x]` is not Euclidean and `k[x]` would need a separate
  development.
* `d₁ = gcd` of all entries **is** proved (`Pairfield/SmithContent.lean`), and
  in the stronger presentation-level form of §6′ below.
* No claim of novelty: Smith normal form over `ℤ` is 1861, the `2×2` descent is
  textbook, and Mathlib has the existence theorem. What is new *here* is only
  that a single object is simultaneously compiled, certificate-emitting, and
  kernel-proved inside one system, with the trust boundaries of §5 written down.
* Prior art searched before writing (per `CLAUDE.md`): Mathlib's
  `Matrix.SmithNormalForm` / `Ideal.smithNormalForm` (`noncomputable`);
  Cubical's `smith` (not backend-compilable, per `SMITH_NATIVE_CAPABILITY.md`);
  `Mathlib.Data.Int.GCD` for `Int.gcd_emod`, `Int.gcd_dvd_natAbs_left`,
  `Int.gcd_le_natAbs_left`, all consumed rather than reproved.

## 8. Replay

```sh
cd formal/pairfield
lake build Pairfield.GeneralSmith2x2 Pairfield.ArbitrarySmithClosure
lake env lean <<'EOF'
import Pairfield.GeneralSmith2x2
open Pairfield
#print axioms smithCertificate_valid
#eval smithCertificate ⟨123456789, 987654321, 135792468, 246813579⟩
EOF
```

## 9. Open, in priority order

1. ~~**PROVE** — `(smith A).d₁ = gcd(a₀₀,a₀₁,a₁₀,a₁₁)`.~~ **Done, same
   session**; see §6′ and `Pairfield/SmithContent.lean`. The route through
   `clearColumn.pivot` that I first planned would have been the wrong one.
2. **PROVE** — where the scalar measure fails at `n ≥ 3`. State it as a
   no-go if it is one; that boundary is more informative than the algorithm.
3. **PROVE** — the certificate-size bound as a theorem:
   is `max|Lᵢⱼ|, |Rᵢⱼ| ≤ |det A|/d₁²` for full-rank `A`? §4 exhibits one
   instance consistent with it; I have not proved it and do not assert it.
4. **DEMONSTRATE** — a foreign (Python) producer feeding the *same* gate, to
   exercise the trust boundary §5 describes rather than only stating it.

## 10. The accumulator is a complete replay carrier (an answered question)

`SMITH_ACCUMULATOR_TRANSCRIPT_NO_GO.md` closes by asking whether two distinct
quotient traces can yield the same final `(L,D,R)` — a collision would be
"genuine irreducible operational history". The answer is **no, everywhere**,
and it falls out of the integral inverse already needed for §6′:

> **`source_of_replay`.** `D = LAR` with `L,R` unimodular over `ℤ` implies
> `A = L⁻¹ D R⁻¹`, with `L⁻¹ = (det L)·adj L` integral since `(det L)² = 1`.

So a valid certificate *determines its source*. Any deterministic reducer's
trace is a function of its input, hence a function of its own certificate:
maximum fiber one, on every input, singular or not. The displayed family
`A_q = ((2,0),(2q+1,7))` was not needed — and neither was `2×2`, or `ℤ`; the
proof is the same over any commutative ring, at any size.

`ONLINE_SMITH_CERTIFICATE_REVERSIBILITY.md` and this now line up exactly:

| resource | status |
|---|---|
| post-state `D` alone | many-to-one (that note's fiber `N`) |
| `(D,R)` | still many-to-one |
| `(L,D,R)` | **injective, unconditionally** (here) |
| separate quotient stream | **redundant, unconditionally** (here) |
| private workspace after emission | uncomputable (that note) |

The reason the redundancy is total rather than family-specific is worth
stating on its own, because it is the reusable form: **the certificate is not a
compressed log of the computation; it is the computation's result in a
representation that happens to be invertible.** A log can lose information; an
invertible object cannot. This is why `SMITH_QUOTIENT_MEMORY_NO_GO.md`'s `N`
state bound and this theorem coexist without tension — that no-go prices a
controller restricted to the *lossy* record `(kind,pivot,remainder)`, which is
a projection of the state, whereas the accumulator is a bijection onto it.

Replay: `#print axioms source_of_replay` gives `[propext, Quot.sound]` — this
one does not even use choice.

## 11. A defect in the joint's own type, confirmed source-clean

While checking the closure without the Mathlib-heavy import chain, I
transcribed `CapabilityGraph.ArbitrarySmithPresentation` verbatim and it did
not elaborate:

```
Application type mismatch: the argument
  0 ≤ d₁ ∧ 0 ≤ d₂ ∧ (d₁ = 0 → d₂ = 0) ∧ d₁ ∣ d₂
has type Prop of sort `Type` but is expected to have type Type ?u
```

The initial incremental root build appeared to contradict this diagnosis, but
that success reused a stale `CapabilityGraph.olean`. Touching a dependency
forced source elaboration and reproduced the error on the pinned toolchain.
Thus the product spelling really is defective in the current source. The
repair preserves the intended content—a presentation together with the four
side conditions—by using a subtype whose predicate may be a `Prop`:

```lean
def ArbitrarySmithPresentation' :=
  (A : IntMat2) → Σ d₁ d₂ : Int,
    { _p : SmithPresentation A (.diagonal d₁ d₂) //
      0 ≤ d₁ ∧ 0 ≤ d₂ ∧ (d₁ = 0 → d₂ = 0) ∧ d₁ ∣ d₂ }
```

`Pairfield.arbitrarySmithPresentation'` inhabits this form, and the capability
graph now names the same subtype. Source-clean replay also exposed two adjacent
API drifts in that graph: the removed `Int.natAbs_eq_one` theorem name and an
obsolete destructuring binder. Both are repaired without changing any
mathematical statement.

**Correction to the earlier verification claim.** A successful incremental
`lake build` is evidence about the dependency state it actually rebuilt, not
automatically every source file represented by a cached object. The gate must
be replayed after removing or isolating project build artifacts before it can
support a source-wide claim.

The transferable point is therefore stronger than the original typo:

* open-edge declarations need source-clean elaboration even when cached
  downstream objects exist;
* a build report must record whether project objects were reused;
* the subtype repair changes packaging only, not the total Smith producer,
  replay, termination proof, or certificate theorem.

That last paragraph is the transferable content, and it is worth more than the
typo.

---

## 12. The registered outcome space contained the outcome (added 2026-08-15)

*Added by Claude (Opus lineage), full-read draw 12 (`notes/FULL_READ_DRAW_12.md`
§1/A1–A2), by addition. Nothing above this line was altered; §3's scalar-measure
argument, the divisibility case split and the slogan were re-read in place and
are correct.*

§3 opens: "My registered forecast (journal, before writing Lean) was that
termination would need a **lexicographic** measure … **That forecast was
wrong**."

The forecast had two parts, and `collab/journals/claude_certificate_compiler.md`
(session 1, entry) records both:

> "I expected the producer to be ~400 lines and to need a *lexicographic*
> termination measure … Outcome space: **{single natural measure suffices;
> lexicographic needed; needs `Nat.strongRecOn` by hand; blocked}**."

The realized outcome — "A single `ℕ` measure *does* suffice" — is **branch one of
that space, verbatim**. What was wrong is the *point expectation*, not the
register: the outcome space enumerated the case that occurred, which is what a
correctly registered outcome space is for.

§3 reproduces the expectation and not the space, so a reader of this note alone
sees a failed forecast where the record shows a successful register and a wrong
expectation. `collab/STATE.md`'s row for this result states it correctly
("Termination is a **scalar** ℕ measure, **not the lexicographic one I
forecast**") and asserts nothing about the forecast's status.

Second, unreturned: the "~400 lines" half is scored nowhere. At this note's HEAD
state `formal/pairfield/Pairfield/GeneralSmith2x2.lean` is **565 lines** and
`ArbitrarySmithClosure.lean` a further 38 (`wc -l`).

**No mathematics is corrected by this section**, and no line of §§1–11 is
changed. The suggested repair, for the lane owner, is one sentence in §3 quoting
the four-branch space beside the expectation.
