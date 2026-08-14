# Runtime → Cubical: the migration map

**Status of this document.** Executable plan, written for agents. The
collaboration's binding decision: the Python runtime hand-rolls an untyped,
trusted-by-hand kernel — `runtime/STATUS.md` admits in its own words that
only `Eq` (proof paths), `Iso` (round-trip normalization) and β are genuinely
machine-checked, and for `Quotient`/`Embed`/`Implies`/`Approx`/`Refine`/
`Interp`/`Dual` the checker "verifies that a matching certificate was
*declared* — not that the mathematics holds." Cubical Agda gives
identity-as-equivalence natively and CHECKED (`--safe`, no postulates, no
holes; toolchain pinned in `formal/cubical/BUILD.md`: Agda 2.6.3 + cubical
**v0.5**). The machine belongs there. This note maps every Python capability
to its Cubical status and gives the retirement order.

Sources read for this map: `runtime/STATUS.md`, `runtime/SCALE.md` headers,
every `runtime/**/*.py` module docstring, full text of
`runtime/kernel/{term,edges,check}.py`, and every module header + theorem
inventory of `formal/cubical/NaturalMachine/*.agda`,
`formal/cubical/ProjectionChargeAudit.agda`, and the installed cubical v0.5
tree (`~/agda-libs/cubical`).

---

## 1. Inventory: what the Python runtime claims, module by module

Legend for each row: **[code]** = enforced by executing Python (still
trusted-by-hand in the sense that the enforcing Python is itself unverified);
**[decl]** = verified only that a certificate was declared, the mathematics
is taken on faith; **[conv]** = enforced by convention/discipline only
(docstrings, review, "imports run strictly downward").

### 1.1 `runtime/kernel/term.py` (652 loc) — L0 exact identity
Claims: hash-consed de Bruijn STLC over opaque constants; address =
blake2b(head ‖ sort ‖ child addresses); names as a mutable non-authoritative
view (`NameTable`); capture-avoiding `subst_top`, `subst_consts`; fuelled
normal-order `beta_normal`; ill-sorted construction impossible.
- **[code]** sort discipline at construction (`App` rejects `fn.sort.dom is not arg.sort`; `Lam` rejects binder/occurrence conflicts; `_merge_demands` rejects one index at two sorts); address determinism (blake2b, never `hash()`); exact `Counters`.
- **[conv/trusted]** T1 (blake2b collision resistance / injective encoding) and T2 (correctness of shift/subst/β) are *stated trust assumptions*, not theorems. `recompute_addr` is the mitigation, not a proof. Termination of β is fuel, not a theorem.

### 1.2 `runtime/kernel/edges.py` (559 loc) — L1 typed edge algebra
Claims: 10 kinds + `Conjecture`; total partial composition (39/100 ordered
pairs licensed, rest `None`); preservation as intersection over a 9-tag
lattice (`ALL_PROPERTIES`); limitors (avacchedaka) for `Approx` (exact
`Fraction` ε, adds), `Dual` (pairing, must match), `Order` (ordering, must
match); `Iso` preserves everything except `presentation` and `sign`.
- **[code]** payload validation (floats rejected; ε ≥ 0; limitor names non-empty); the composition table itself; `combine_limitors`; `limitor_census`.
- **[conv/trusted]** *every semantic claim of every kind*: nothing checks that an `Embed` edge is injective, that a `Quotient` is sufficient, that an `Order` edge respects its named ordering. The table's licensing choices ("Iso is absorbed") are commentary, not theorems.

### 1.3 `runtime/kernel/egraph.py` (1000 loc) — L2 proof-relevant e-graph
Claims: union-find + congruence closure + Nieuwenhuis–Oliveras proof forest;
`explain` emits a checkable path; `explanation_classes` enumerates homotopy
classes of proofs (paths quotiented by multiset of axiom justifications) as a
guarded `ClassEnumeration` that raises `IncompleteEnumeration` rather than
pass off a partial answer; directed edges never merge; local retraction.
- **[code]** the guard semantics of `ClassEnumeration`; the depth-bound discipline (via `kernel/bounded.py`); the `is`-identity locality assertions.
- **[conv/trusted]** the e-graph is *explicitly declared untrusted* by `check.py`; its outputs are only as good as re-checking. Known open defects (STATUS): O(n²) `merge` scan, retraction cone width, exponential class-enumeration work.

### 1.4 `runtime/kernel/check.py` (330 loc) — L5 trusted heart
Claims: re-derives every step from terms alone; recomputes every address
(T1); β-witnesses normalized itself; `Iso` verified by running the round trip
**on fresh probes**; `Conjecture` never accepted; certificate limitor must
match edge limitor.
- **[code]** `Eq` paths (contiguity, endpoints, congruence arity, axiom sides), β (normal forms compared), `Iso` (transport of endpoints + invertibility on one probe per sort — note: probes, NOT all points; this is weaker than an equivalence proof).
- **[decl]** everything reached through `Certificate`: `Quotient`, `Embed`, `Implies`, `Approx`, `Refine`, `Interp`, `Dual`, `Order` — T3 verbatim.
- **[conv/trusted]** T1, T2, T4 (Python's integer/Fraction arithmetic), and the correctness of this 330-line file itself.

### 1.5 `runtime/kernel/bounded.py` (242 loc), `runtime/kernel/limitor_audit.py` (129 loc)
`bounded.py`: the shared prune-branch/iterative-deepening/report-the-bound
discipline used by `egraph.explanation_classes` and
`propagate.invalidate.justification_classes`. **[code]** for the reporting
semantics; no mathematics. `limitor_audit.py`: AST audit proving the runtime
**originates zero limitors** across 71 files (before `order/witness.py`
supplied the first `Order` one). **[code]** (static, exact) — and it is the
load-bearing fact that makes `Approx`/`Dual` migration unnecessary (§3).

### 1.6 `runtime/execute/` (3550 loc) — L3 geodesic engine
`rewrite.py` (equality → checked rewrite, every application emits a
kernel-checkable justification), `ematch.py` + `acmatch.py` (e-matching,
recursive + automaton engines held equal by a differential test),
`saturate.py` (budget-honest saturation), `extract.py` (Pareto frontier under
a 4-component exact cost vector; `extract_class_frontier` over the class
DAG; `RouteFinder` Dijkstra as the only legal metric).
- **[code]** every emitted rewrite justification is re-checked by `check.py`; budget honesty; the differential test between match engines.
- **[conv/trusted]** the cost model itself ("four independent costs" admitted not established — `verify` near-collinear with `steps`); e-matching completeness; the automaton's 12 newest tests not mutation-tested.

### 1.7 `runtime/propagate/` (1288 loc) — L4 consequence propagation
`cone.py` (exact forward cone), `invalidate.py` (survival by homotopy class —
a consequence dies only when every justification class passes through the
retracted fact), `recompute.py` (refuses to act on `UNDECIDED`).
- **[code]** cone-vs-full-rebuild equality assertions; stale-vs-dead separation (`verify_no_stale_reuse`); `is`-identity outside the cone.
- **[conv/trusted]** "dies" is relative to the *recorded* justification set, not to provability — an unprovability claim was never checked mathematics, only bookkeeping.

### 1.8 `runtime/crystallize/` (1612 loc) — §3.1 lemma mining
Derivation DAGs, contiguity-windowed sub-DAG mining, Plotkin/Reynolds
anti-unification, 7-gate lemma install, `LemmaIndex` discrimination net.
Self-contained: **deliberately does not import `runtime.kernel`** — it
carries its *own second term/derivation substrate* (`derivation.py`:
`check_derivation`, `poly_equal`, `normalize`). So the runtime has two
kernels, and this one is checked only by its own Python.
- **[code]** the 7 admission gates; rebuild-and-check of mined lemmas; null-book controls.
- **[conv/trusted]** the entire second substrate; the equivalence of its notion of proof with the kernel's.

### 1.9 `runtime/distinguish/` (1900 loc) — §3.2 distinction compilation
Collision finder, exact minimum-cardinality channel search, Moore partition
refinement, `check_sufficient` / `check_coarsest`, reachability-discipline
declarations (generated locus / omitted locus — the omitted locus of the
digit quotient identified as **the endian class**).
- **[code]** sufficiency/coarsest verified by exhaustive check over the declared finite state set.
- **[conv/trusted]** sufficiency-for-the-task-family semantics beyond the declared set (that is the point of the omitted-locus declaration, which is honest but still prose-in-code).

### 1.10 `runtime/vocabulary/` (1732 loc) — definitional self-extension
`define.py` (constructor arrives only as `c(#0..#k-1) := body`),
`conservativity.py` (7 syntactic admission gates; **elimination executed**:
every theorem unfolded and re-checked in the base vocabulary;
`base_answers_unchanged`), `propose.py` (candidates from recurring subterms
and proved quotients; null pool control).
- **[code]** the gates; the unfold-and-recheck loop.
- **[conv/trusted]** that the hand-rolled unfold *is* eliminability — the standard conservativity metatheorem is re-implemented, per theorem, in Python, forever.

### 1.11 `runtime/generate/` (1910 loc) — the generative loop
`multiway.py` (proof-carrying multiway system; corrupt rewrites refused),
`propose.py` (channel collisions → `Conjecture` edges, discharged or refuted
by exact separating point), `loop.py` (GENERATE→…→REFLECT with held-out
benchmark + leakage check).
- **[code]** each accepted edge is a kernel `Eq` edge; conjectures never enter accepted derivations.
- **[conv/trusted]** the loop's methodology claims (leakage, benchmarks) are experimental discipline, not theorems.

### 1.12 The remaining substrate, briefly
- `runtime/atlas/` (2819 loc): the six charts of ℕ executable; transitions as typed kernel edges "verified exhaustively on a stated finite range" **[code, finite range only]**; residuals as computed groups/torsors/cocycles.
- `runtime/curriculum/` (2390 loc): dependency graph with theorem-cited edges, choice metric, derived order. **[code]** for the graph arithmetic; the forcing theorems live in `notes/ATLAS_OF_N.md`, not in the code.
- `runtime/render/` (2323 loc): perceptual channels; preservation/loss/round-trip certificates by exhaustive check; `decode` returns the **fibre**; INFORMATION_GAIN claims structurally rejected. **[code]** on declared finite sets.
- `runtime/physics/` (2119 loc): exact dimensions, exact optics, geodesic bridge. **[code]** exactness (no float, no `/`, AST-asserted); the physics identification is a demonstration.
- `runtime/order/witness.py` (167 loc): the **first and only originated limitor** — an `Order` index on K = ℚ[x]/(x³−4x−1) (disc 229, non-Galois, Aut(K/ℚ)=1, totally real), chosen precisely so the index is not annihilated by Theorem E (`notes/INDEX_LAW.md`). **[code]** finite integer certificates; **[conv]** the field-theoretic framing.
- `runtime/walk.py` (312 loc): the 1 + X walk; sensors = prime powers generated by the least non-divisor of lcm; frontier-optimality "checked at every state" **[code, per-state runtime check — not a proof of the ∀-statement]**.
- `runtime/prefix_closure.py` (44 loc): infinitude of certified return histories at a prefix point **[code]** (enumerator).
- `runtime/engine.py` (355 loc): orchestration + persistent book; every load re-verified through the 7 gates. **[code]** for re-verification; no mathematics of its own.
- **Quarantined, NOT landed** (STATUS.md §Quarantine): `runtime/nerve/`, `runtime/capability/`, `runtime/panini/` — no tests, no demo output, must not be cited; deletion is one of the listed correct dispositions.

---

## 2. Capability-by-capability status in Cubical

"NM" = `formal/cubical/NaturalMachine/`. "v0.5" = installed cubical library.
Every NM theorem named below is in the checked build (`--safe`, exit 0,
2026-08-13) except where noted.

| # | Capability (Python site) | Cubical status |
|---|---|---|
| C1 | Exact identity of constructions; ill-sorted unbuildable (`kernel/term.py`) | **Native**: intrinsic typing + judgmental equality; the Agda elaborator *is* the hash-cons. No theorem needed. Content addresses are an implementation detail of not having a checker. |
| C2 | Names as non-authoritative views (`NameTable`) | **Native**: Agda module system / `renaming`; a name never enters a term's identity. |
| C3 | β-witness checking (`check.py Beta`) | **Native**: definitional equality; cf. `NM/CountedExecution.agda` `run-suc … = refl`. |
| C4 | `Eq` proof paths, composition, congruence, symmetry (`check.py`, `egraph.explain`) | **Native**: `_∙_`, `cong`, `sym` in `Cubical.Foundations.Prelude`; checked by the type checker, not by a 330-line Python file. |
| C5 | Proof-relevance: distinct proofs retained, homotopy classes (`egraph.explanation_classes`, `ClassEnumeration`) | **Present in NM**: paths are proof-relevant natively. `PathIsSymmetry.pathIsSymmetry : (X ≡ X) ≃ (X ≃ X)`; `SymmetryEnumeration.loopEnum : (Fin n ≡ Fin n) ≃ Fin (n !)` — a **total, checked** enumeration of the loop classes, where Python's `ClassEnumeration` is guarded-incomplete by design. `SmithPathCountedExecution.same-endpoint-at-two` + `different-fiber-at-two`: two schedules, same endpoint, distinct holonomy — "distinct automorphisms survive as distinct paths", checked. |
| C6 | `Iso` (probe-based round trip, `check.py`) | **Present in v0.5, strictly stronger**: `Cubical.Foundations.Isomorphism` (`Iso`, `isoToEquiv`) proves invertibility at *all* points, not probes. Used throughout NM (`Digits.ℕ≃CanWord`). |
| C7 | "Iso preserves everything but presentation" (`edges.py PRESERVES`) | **Present as a theorem, not a table**: univalence `ua` + transport. `Transport.transport-+-is-⊕` (transporting ℕ's `+` along `ua` *is* schoolbook ripple-carry), `FreeMonoid.transport-+-is-++`. The exception for `sign` is honest in Python and would be a theorem about order-structures in Agda (absent, see A7). |
| C8 | `Quotient` certificates (`check.py` [decl]) | **Present in v0.5**: `Cubical.HITs.SetQuotients` (`_/_`, `[_]`, `rec`, universal property); finite cardinality via `Cubical.Data.FinSet.Quotients`. Already used by `formal/cubical/ProjectionChargeAudit.agda`. Sufficiency = the factoring map, checked. |
| C9 | `Embed` certificates [decl] | **Present in v0.5**: `Cubical.Functions.Embedding` (`isEmbedding`, `_↪_`). |
| C10 | `Implies` [decl] | **Native**: `→`. Truth preservation is application. |
| C11 | `Interp` (theory-to-theory semantics) [decl] | **Present**: the SIP. `Cubical.Foundations.Structure`, `Cubical.Algebra.Monoid` `MonoidPath`; used in `FreeMonoid.ℕ-Monoid≡Tally-Monoid`, `Transport.ℕ-Monoid≡CanWord-Monoid` — the two monoids are EQUAL, not certified-interpretable. |
| C12 | `Approx` (exact ε), `Dual` (pairing) [decl] | **Absent — and inert in Python**: `kernel/limitor_audit.py` proves the runtime never originates one. ℚ exists (`Cubical.HITs.Rationals`), no metric/approx framework. **Verdict: drop, do not migrate.** |
| C13 | `Order` + the originated index (`order/witness.py`) | **Partially absent**: `Cubical.Relation.Binary.Poset` exists (v0.5); the specific non-Galois-cubic witness is absent → A7. |
| C14 | Conjectures carried but never accepted (`Conjectural`, `check.py`) | **Native**: `--safe` refuses postulates; a hole fails the build. The *designed-annihilation control* pattern is already established: `NM/Control/WrongEquivalence.agda` must fail to type-check, and `Controls.agda` C1/C2 prove the negations. |
| C15 | Congruence closure / e-matching / saturation as proof *search* (`egraph`, `execute/`) | **Absent as a verified procedure; largely superseded**: v0.5 ships reflection solvers `Cubical.Tactics.NatSolver` (already used by the corpus per BUILD.md), `Cubical.Tactics.CommRingSolver`, `Cubical.Tactics.MonoidSolver` — the checked *end product* of what saturation was for, on the domains the runtime actually exercises (arithmetic identities). Generic e-graph search is generation, not checking; it does not belong in the kernel (see §3, A9). |
| C16 | Counted execution, exact counters (`Counters`, demo step counts) | **Present in NM**: `CountedExecution.run/run-suc/compile`; `CountedDigits.run-suc`; `SmithPathCountedExecution` (counted schedules). Also `Cubical.HITs.Cost` (v0.5): a cost monad with propositionally erased counts — the germ of checked cost claims. |
| C17 | Retraction / dependency cone / survival (`propagate/`) | **Dissolves**: in a `--safe` development an assumption is a module parameter or hypothesis; "retract" = don't apply; "survives through an independent proof" = exhibit a proof term not mentioning the hypothesis (checked). "Dies" (no proof avoids it) is metatheoretic and was never checked in Python either — it was bookkeeping over recorded justifications. No Agda kernel needed; the honest residue is a note. |
| C18 | Definitional extension + conservativity (`vocabulary/`) | **Native, free**: an Agda definition unfolds by δ-reduction; `fold/unfold` are `refl`; definitional extension is conservative *by construction of the theory*, not by a 1732-line re-verifier. See A1 for the 20-line demonstrator that authorizes deletion. |
| C19 | Lemma crystallization (`crystallize/`) | **Splits**: *stating and checking* the generalized lemma = an ordinary Agda lemma (native). *Mining* which lemma to state (anti-unification, sub-DAG frequency) = agent-side search whose output is an Agda file; it needs no trusted substrate at all. The second term substrate (`derivation.py`) has no Cubical counterpart and needs none. |
| C20 | Coarsest sufficient quotient (`distinguish/`) | **Pattern present, instance absent**: image factorization = `Cubical.Functions.Image` (`restrictToImage`, `imageInclusion`) + `SetQuotients`; the kernel-quotient ≃ image statement is A6. Finite cardinalities: `Cubical.Data.FinSet.Cardinality`. The endian omitted-locus residual is **already formalized**: `Endian.chartSymmetry`, `noRevDescent`, `noCompDescent`, `noRevπEquivariance`. |
| C21 | Digit chart, carry, odometer, transport of addition (`atlas/charts.py` digit chart) | **Present in NM**: `Digits.ℕ≃CanWord`/`ℕ≡CanWord`, `value-sucw`, `digits-value`, `value-inj`; `Transport.sucC`, `_⊕_`, `transport-+-is-⊕`; `Controls` C1/C2. Parameterized over every base b = 2+k, instantiated at `Base2`/`Base10` in `NaturalMachine.agda`. |
| C22 | Tally / free-monoid chart | **Present in NM**: `FreeMonoid` (`ℕ≃Tally`, SIP equality of monoids). |
| C23 | Cardinal chart / decategorification | **Present in NM**: `Decategorification.card≡MereEq`, `card-Fin`, `FinSetLoop≃Sym`; `SymmetryCardinality.symmetryCount≡factorial`. |
| C24 | Smith normal form as proof-carrying execution (ARITHMETIC_LIFE lane) | **Present in v0.5 + NM**: `Cubical.Algebra.IntegerMatrix.Smith.smith`, wrapped as `SmithCapability.normalizeSmith`; path holonomy in `SmithPathCountedExecution` (`Up`/`Uq`, `p-action-at-two`, `q-action-at-two`). |
| C25 | Residue/CRT observations compiled to the digit chart (`walk.py` sensors; `atlas/`) | **Interface present**: `ResidueTransport.compile`, `compile-generated`, `compile-injective`, `compileCosted`/`complexity-preserved`. The CRT *theorems* behind walk.py are absent → A2–A5. |
| C26 | Symmetry as executable capability (`capability/` quarantined) | **Present in NM** (superseding the quarantined Python): `SymmetryArithmeticAction.permuteRegisters(-comp)`, `loopRegisters(-comp)`; `CapabilityGraph.SymmetryCapability` (count certificate + action + stabilizer, with intentionally no count→action edge); `SymmetryEnumeration.rank/unrank`. |
| C27 | Fibre-returning decode, collision witnesses (`render/channel.py`) | **Concepts native**: `fiber` (Prelude); a collision witness is a proof of ¬injectivity — exactly `Controls.value-not-injective-on-Word`. SVG production itself does not migrate (not mathematics). |
| C28 | Infinitude of certified return histories (`prefix_closure.py`) | **Present in kind**: the object is the free groupoid on retained generators — `Cubical.HITs.FreeGroup` / `FreeGroupoid` (v0.5). In a set-level e-graph the histories are syntactic; in Cubical the honest statement is about the free groupoid, where it is a theorem, not an enumerator. |
| C29 | Walk theorems: least non-divisor of lcm is a prime power; frontier optimality; profile injectivity iff lcm > n (`walk.py`) | **Absent** (v0.5 has `Cubical.Data.Nat.Divisibility/GCD/Coprime/Mod` but **no lcm**) → A2, A3, A4, A5. |
| C30 | Curriculum order, choice metric (`curriculum/`) | **Absent as formalization; not kernel material.** The forcing theorems live in `notes/ATLAS_OF_N.md`; the graph arithmetic is finite and could be a `Dec`-computation, but it earns no trust it doesn't already have. Retire with the notes. |
| C31 | Cost-vector Pareto extraction, geodesic bridge (`execute/extract.py`, `physics/`) | **Absent — recommend not migrating.** Cost claims are measurements; per `CLAUDE.md`, derive the complexity or drop the number. `Cubical.HITs.Cost` is available if a checked cost claim is ever wanted. |

---

## 3. Absent capabilities: smallest checked Agda kernels, ranked smallest-first

Each item is a concrete statements-to-prove list against Agda 2.6.3 +
cubical v0.5, `--safe`, in `formal/cubical/NaturalMachine/` unless said
otherwise. Ranked by estimated proof size, smallest first.

### A1 — Definitional extension is judgmental (retires `runtime/vocabulary/`) — ~20 lines
New module `NaturalMachine/DefinitionalExtension.agda`. Not deep — it is the
*documented demonstration* that the entire 1732-line vocabulary guard
collapses to δ-reduction, which authorizes the deletion:

```agda
sqr : ℕ → ℕ
sqr n = n · n

unfold-sqr : (n : ℕ) → sqr n ≡ n · n
unfold-sqr n = refl                       -- elimination IS the checker

-- a theorem stated with sqr, re-proved after unfolding, both by one solver call
sqr-expand : (a b : ℕ) → sqr (a + b) ≡ sqr a + 2 · a · b + sqr b
```
The `base_answers_unchanged` / 7-gate apparatus has no residue: a defined
symbol *cannot* constrain old symbols in Agda (its defining equation is not
an axiom), and admission gate D3 is the language's grammar.

### A2 — `lcm` with its universal property (unblocks A3–A5) — ~60 lines
v0.5 has `Cubical.Data.Nat.GCD` but no lcm. New module
`NaturalMachine/Lcm.agda` (candidate upstream contribution):

```agda
lcm : ℕ → ℕ → ℕ                          -- via m · n ≡ gcd m n · lcm m n
∣-lcm-ˡ : (m n : ℕ) → m ∣ lcm m n
∣-lcm-ʳ : (m n : ℕ) → n ∣ lcm m n
lcm-least : (m n k : ℕ) → m ∣ k → n ∣ k → lcm m n ∣ k
lcmList : List ℕ → ℕ                      -- fold, same three lemmas lifted
```

### A3 — The least non-divisor is a prime power (`walk.py`'s install theorem) — ~80 lines
The theorem `walk.py` re-checks at every install, proved once:

```agda
IsPrimePower : ℕ → Type₀
IsPrimePower q = Σ[ p ∈ ℕ ] Σ[ e ∈ ℕ ] IsPrime p × (0 < e) × (q ≡ p ^ e)

leastNonDiv : (n : ℕ) → 1 ≤ n → Σ[ q ∈ ℕ ] (¬ q ∣ n) ×
              ((r : ℕ) → 1 ≤ r → r < q → r ∣ n)

leastNonDiv-isPrimePower : (n : ℕ) (h : 1 ≤ n)
                         → IsPrimePower (fst (leastNonDiv n h))
```
Proof: if q = a·b with a, b coprime, 1 < a, b < q, then a ∣ n and b ∣ n by
minimality, hence q ∣ n by coprimality (`Cubical.Data.Nat.Coprime`) —
contradiction. This turns the sensor stream 2,3,4,5,7,8,9,… from a per-state
runtime check into a theorem.

### A4 — Frontier optimality of the walk — ~60 lines given A2
```agda
lcmTo : ℕ → ℕ                             -- lcm (1..k)
frontier-bound : (S : List ℕ) (k : ℕ) → All (_≤ k) S → lcmList S ∣ lcmTo k
-- and the attainment statement for the least-section sensor set:
sensors-attain : (k : ℕ) → lcmList (sensors k) ≡ lcmTo k
```
`sensors` defined by iterating A3's `leastNonDiv`. "Self-knowledge as a
running certificate" becomes a closed theorem.

### A5 — Profile injectivity (the CRT losslessness invariant) — ~120 lines given A2
The single invariant `walk.py` preserves, as one statement:

```agda
profile : (S : List ℕ) → ℕ → All (λ m → Fin m) S      -- n mod each sensor
profile-inj : (S : List ℕ) (n : ℕ) → n < lcmList S
            → (i j : ℕ) → i ≤ n → j ≤ n
            → profile S i ≡ profile S j → i ≡ j
-- converse (collision at the lcm), making the iff of walk.py:
profile-collides : (S : List ℕ) → profile S 0 ≡ profile S (lcmList S)
```
Needs only: agreement mod every m ∈ S ⇒ (i∸j) divisible by every m ⇒ by
`lcm-least` divisible by `lcmList S` ⇒ zero since |i−j| < lcm. Uses
`Cubical.Data.Nat.Mod`. **A2+A3+A4+A5 together retire `runtime/walk.py`.**

### A6 — Coarsest sufficient quotient = image factorization (retires the checked core of `runtime/distinguish/`) — ~150 lines
New module `NaturalMachine/SufficientQuotient.agda`, on v0.5's
`Cubical.HITs.SetQuotients` + `Cubical.Functions.Image` +
`Cubical.Data.FinSet.Quotients`:

```agda
kerRel : {A : Type ℓ} {B : Type ℓ'} (f : A → B) → A → A → Type ℓ'
kerRel f x y = f x ≡ f y

-- sufficiency: the observation factors through the quotient, checked
factor : (f : A → B) (isSetB : isSet B)
       → Σ[ g ∈ (A / kerRel f → B) ] ((x : A) → g [ x ] ≡ f x)

-- the factoring map is an embedding onto the image (coarsest-ness):
quotient≃image : (f : A → B) (isSetB : isSet B) → (A / kerRel f) ≃ Image f

-- any sufficient quotient refines it:
coarsest : (f : A → B) (isSetB : isSet B)
           (R : A → A → Type ℓ'') (h : A / R → B)
         → ((x : A) → h [ x ] ≡ f x)
         → Σ[ π ∈ (A / R → A / kerRel f) ] ((x : A) → π [ x ] ≡ [ x ])
```
The Python demo's "46656 states → 216 blocks" becomes a `card` computation
(`Cubical.Data.FinSet.Cardinality`) on a decidable instance. The
omitted-locus half is already carried by `Endian.agda`.

### A7 — The originated `Order` index, certified (retires `runtime/order/witness.py`) — ~150 lines, scoped honestly
The finite, exact part of the witness — allowed as certified symbolic
computation under `CLAUDE.md`:

```agda
f : ℤ → ℤ
f x = x ³ - 4 · x - 1                       -- ℤCommRing arithmetic

-- three real roots: sign changes on ℤ, four point evaluations, all refl-checkable
sign-changes : (f (- 2) < 0) × (0 < f (- 1)) × (f 0 < 0) × (0 < f 3)

-- irreducibility over ℚ: cubic with no rational root; candidates are ±1
no-rational-root : ¬ (f 1 ≡ 0) × ¬ (f (- 1) ≡ 0)

disc-is-229 : discriminant ≡ 229            -- one evaluated integer identity
```
The field-theoretic conclusion (two orderings, Aut(K/ℚ) = 1, Theorem E does
not annihilate the index) stays in `notes/INDEX_LAW.md` /
`notes/POSITIVITY_HAS_A_PLACE.md` — real embeddings of number fields are
beyond what should be built here. The Python module's *checked content* is
exactly the three certificates above.

### A8 — An intrinsically typed STLC kernel (retires `kernel/term.py` + `check.py`'s Eq/β fragment) — ~400–600 lines; **audit before building**
Only needed if the corpus still wants a *generic* λ-object language after
A1–A6; the arithmetic the runtime actually exercises is already carried by
the Tactics solvers (C15). If wanted:

```agda
data Ty : Type₀ where base : ℕ → Ty ; _⇒_ : Ty → Ty → Ty
data Ctx : Type₀ where ∅ : Ctx ; _,_ : Ctx → Ty → Ctx
data Tm : Ctx → Ty → Type₀                 -- var/const/app/lam, intrinsically sorted
  -- C1 (ill-sorted unbuildable) holds by the data declaration alone

_[_] : Tm (Γ , A) B → Tm Γ A → Tm Γ B      -- single substitution
data _↝_ : Tm Γ A → Tm Γ A → Type₀         -- β + congruence closure
data Normal : Tm Γ A → Type₀

eval : (fuel : ℕ) (t : Tm Γ A)
     → Maybe (Σ[ v ∈ Tm Γ A ] (t ↝* v) × Normal v)   -- fuelled, sound by type
```
This single module subsumes T1 (no hashing exists), T2 (subst/β are checked
definitions), and the entire `check.py` Eq/β/Refl/Axiom/Instantiate case
analysis (axioms = hypotheses; instantiation = application).

### A9 — Verified e-graph / saturation / Pareto extraction — large; **recommend: never**
Congruence-closure *search* produces candidates; the checked artifact is the
resulting equational proof, which A8/C15 already carry. Pareto cost claims
are measurements (§2 C31). Building a verified e-graph would be migrating
the scaffolding instead of the building.

---

## 4. Verdict: the retirement order

Each stage names the Agda landing that triggers it and the Python that dies.
"Delete" means delete — STATUS.md's own quarantine text identifies leaving
dead-looking-alive modules in the tree as the failure mode to prevent.

**R0 — now, no landing required.**
Delete `runtime/nerve/`, `runtime/capability/`, `runtime/panini/`
(quarantined, untested, uncited; deletion is a disposition STATUS.md itself
lists — and `capability/`'s subject matter is already better covered by
`NM/CapabilityGraph.agda` + `SymmetryArithmeticAction.agda`, checked).

**R1 — after A1 (~20 lines of Agda).**
Delete `runtime/vocabulary/` (1732 loc): `define.py`, `conservativity.py`,
`propose.py`. Constructor *proposal* becomes agents writing Agda
definitions; the guard is the language. **This is the first landed,
tested, cited Python package to become fully deletable, and the exchange
rate (20 lines for 1732) is the migration's thesis in miniature.**

**R2 — after A2+A3+A4+A5.**
Delete `runtime/walk.py` and `runtime/prefix_closure.py` (the latter's
content is C28, a remark about free groupoids to be added to the note that
cites it). `runtime/engine.py` loses its walk duties.

**R3 — after A6.**
Delete `runtime/distinguish/` (1900 loc). Its two seed-criterion numbers are
preserved in STATUS.md/notes as history; sufficiency/coarsest-ness are
library theorems; the endian residual already lives in `Endian.agda`.

**R4 — after A7.**
Delete `runtime/order/witness.py`; `runtime/kernel/limitor_audit.py` goes
with it (its audit subject no longer exists).

**R5 — after A8 (if the audit says A8 is wanted) plus solver bridging (C15).**
Delete, in dependency order: `runtime/execute/` and `runtime/propagate/`
(consumers first), then `runtime/kernel/egraph.py`, `runtime/kernel/bounded.py`,
`runtime/kernel/edges.py`, `runtime/kernel/term.py`, and **last**
`runtime/kernel/check.py` — the trust anchor is retired only when nothing
remains that it anchors. `runtime/crystallize/` and `runtime/generate/`
retire in the same stage: their checked substrates dissolve (C19, C14);
their search loops become agent behavior emitting Agda. `runtime/engine.py`
dies with the book it drives.

**R6 — no landing required, retire with pointers to notes.**
`runtime/atlas/` (its two deepest charts already landed as C21–C23; the
remaining charts' claims live in `notes/ATLAS_OF_N.md` — formalize from the
note if ever wanted, not from the Python), `runtime/curriculum/` (C30),
`runtime/render/` (C27; keep the SVGs as artifacts, delete the machinery),
`runtime/physics/` (C31), `runtime/demo/`, `runtime/tests/`, `runtime/state/`
as their subjects disappear. `runtime/STATUS.md` and `runtime/SCALE.md` are
converted to historical record with a header pointing here.

**Invariant during migration**: at every stage the deleted Python's *checked
content* must exist as a green `--safe` module cited in this note, or as an
explicit "dropped, and why" line (C12, C31, A9). Nothing else is deleted;
nothing not deleted may be cited as authority once its stage has landed.
