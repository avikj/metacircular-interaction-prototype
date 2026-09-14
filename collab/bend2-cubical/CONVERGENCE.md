# The convergence: an optimal interaction-net runtime for a univalent foundation

*A ground-up technical report. Audience: the repository's author, and Victor
Taelin (HVM/Bend). It builds every concept it uses. It is written to be read
by a runtime architect and by a type theorist and to let each see the other's
half exactly.*

**Discipline of claims.** Three tags are used throughout. **[T]** — a
machine-checked term, named, present in the repository at its pin. **[R]** — a
reading: a true statement *about* checked terms, synthesis, not itself a single
term. **[open]** — not inhabited/derived; stated exactly, with the obstruction.
Nothing here is "up to interpretation": a `[T]` means exactly what its type
says in standard terminology; an `[open]` is a construction not yet built, not
a vague statement. Pins: the Agda corpus checks at **Agda 2.8.0 + agda/cubical
v0.9, `--safe`** (no postulates, no holes). The cubical Bend2 patch builds at
**GHC 9.12.2 / cabal**, applied to **DKormann/Bend2 @ f026483**; runs shown
executed on **HVM3** and (per `STATUS.md`) HVM4.

---

## 0. The one sentence, and the convergence claim

The repository proves a single theorem — that **every transformation factors
losslessly into its visible projection and a residual fibre**, `A ≃ Σ(b:B)
fib_f(b)` for every `f : A → B`, with first projection `f` definitionally — and
reads all of computation, complexity, concurrency, physics, and life off it.
HVM is a runtime whose one information-bearing reduction is Lévy-optimal
sharing driven by a single local decision (duplication meets superposition:
same label → annihilate, no allocation; different label → commute, allocate).

**The convergence claim [R]:** the Kan operation of cubical type theory
(`comp`, which decides and fills fibres) and HVM's annihilate/commute decision
are the *same operation*. Giving Bend2 a computing cubical layer therefore did
not put a foundations layer on top of a fast runtime; it exhibited that the
runtime's native reduction *is* the mathematics' primitive. The consequence is
that the corpus's optimality theorems (cost = the non-contractible fibre;
`O(input+output)` met with equality; invertible ⟹ costless) stop being
statements about an idealized machine and become descriptions of this machine's
actual behavior, at the information-theoretic floor, in parallel. The semantic
gap between the model of the mathematics and the model of computation is zero:
"compile" is, at the primitive, `refl`.

The rest of this document earns that claim from the ground up.

---

## Part I — The interaction calculus (shared ground)

Stated in the shared language; the point is the correspondence in Part IV.

An **interaction net** is a graph of agents, each with one principal port and
some auxiliary ports; computation is local graph rewriting where two agents
connected at their principal ports interact and are replaced by a small fixed
wiring. Lafont's **interaction combinators** are a universal such system.
Reduction is **strongly confluent**: any two redexes are independent, the order
of reduction is irrelevant to the normal form, and reduction parallelizes with
no coordination (Church–Rosser is definitional, not a theorem to arrange).

**Optimal reduction (Lévy/Lamping).** The abstract problem β-reduction poses is
that naïve substitution duplicates work: a redex family — copies of one redex
created by duplicating a shared subterm — must be reduced once, not once per
copy. Lamping's algorithm (recast cleanly as interaction nets) achieves the
Lévy-optimal bound by making duplication *incremental and explicit*: a
duplicator node walks into a term lazily, and the bookkeeping that a naïve
sharing graph gets wrong (Lamping's brackets/croissants) is handled by
**labels** on the duplication and superposition nodes.

**The single information-bearing decision.** HVM's core carries superposition
nodes `&L{a b}` (a value that is both `a` and `b`, tagged with label `L`) and
duplication nodes `!&L{x y} = v` (bind `x`,`y` to two lazy copies of `v` at
label `L`). All other rules (application–lambda, etc.) are structural. The one
rule that *decides* something is DUP meets SUP:

- **same label** `L = L`: **annihilate** — the pair cancels, each superposed
  branch routes to one duplication variable. No nodes allocated.
- **different label** `L ≠ M`: **commute** — each node copies the other; four
  nodes where there were two. Nodes allocated.

Cost, operationally, is the interaction count, and the *allocating* interactions
are exactly the different-label commutations. Everything else is free wiring.
HVM compiles this to C/CUDA/Metal; the reduction is the machine.

Hold two facts: **(i)** the only decision is same-vs-different label, and its
two outcomes are free (annihilate) vs. paid (commute); **(ii)** the calculus is
confluent, so order is never a choice. Part IV shows both are the mathematics.

---

## Part II — Cubical type theory, from the ground up

### II.1 Types, Π, Σ, and the identity type

A dependent type theory has types and terms, dependent function types `(x : A)
→ B x` (Π), and dependent pair types `Σ(x : A) B x`. The move that makes it a
*foundation for mathematics* is the **identity type**: for `a b : A`, a type
`a ≡ b` whose inhabitants are proofs that `a` and `b` are equal. In Martin-Löf
type theory this type is opaque — you can eliminate it (`J`) but you cannot see
*what a proof of equality is*. Cubical type theory answers: a proof of equality
is a **path**.

### II.2 The interval and paths

Postulate an abstract **interval** `I` with two endpoints `i0, i1` and a De
Morgan structure: for `r s : I`, meets `r ∧ s`, joins `r ∨ s`, and reversal
`~ r`, with the lattice laws (`~ i0 = i1`, `i0 ∧ r = i0`, etc.). `I` is *not* a
type of the theory; it indexes.

A **path** in `A` from `a` to `b` is a function `p : I → A` with `p i0 ≡ a` and
`p i1 ≡ b` on the nose. Write `Path A a b`. A path lambda `<i> t` introduces one
(with `t[i0/i] ≡ a`, `t[i1/i] ≡ b` the boundary condition, checked); path
application `p @ r` eliminates. Then:

- `refl :≡ <i> a : Path A a a`;
- `sym p :≡ <i> p @ (~ i)` — symmetry from interval reversal;
- `cong f p :≡ <i> f (p @ i)`;
- **funext** is immediate: `<i> λx. (h x) @ i` from `h : ∀x. Path (f x) (g x)`.
  (This is already beyond what a propositional-equality type with only `J`
  proves — it is the corpus's first acceptance test on the Bend2 port,
  `cubical_test.bend`, `funext`.)

A **PathP** generalizes to a *line of types*: `P : I → Type`, `PathP P a b` with
`a : P i0`, `b : P i1`. `Path A a b :≡ PathP (<i> A) a b` (constant line).

### II.3 The Kan primitive: `comp`, and its two projections `coe`/`hcomp`

Paths must **compose, invert, and satisfy the groupoid laws at every level**,
or the identity type is not an equivalence relation and the theory is dead. The
one operation that provides all of this is generalized composition, **`comp`**.
It says: given a line of types, a partial element defined on a cofibration `φ`
(a face of the cube) over the composition dimension, and a base agreeing with
it, produce the missing lid. Two degenerate cases are named separately:

- **`coe` / `transp`** (transport): `comp` with an *empty* cofibration. Given a
  line `P : I → Type` and `t : P r`, produce `coe P r s t : P s`. This *moves
  data along a path between types*.
- **`hcomp`** (homogeneous composition): `comp` along a *constant* type line.
  This composes paths within one type.

`comp = hcomp` after `coe`. **`comp` is the single primitive.** A type for which
`comp` is defined is **fibrant** — a Kan complex — and the whole content of "is
this a well-behaved type" is "does `comp` compute here."

Two facts to carry: **(iii)** `comp`/`coe`/`hcomp` are *computation*, not
search — they reduce a redex to a normal form by structural rules that dispatch
on the type former (Π transports the argument backward and result forward; Σ
componentwise; data commutes with constructors; the universe needs `Glue`,
below). **(iv)** `comp` *computing* is precisely the relevant fibre being
contractible; `comp` *stuck* is it being non-contractible — the operation and
the property are the same event, not a test followed by a branch.

### II.4 Equivalence, fibre, h-levels

For `f : A → B` and `b : B`, the **fibre** is `fib_f b :≡ Σ(a : A) (f a ≡ b)` —
the space of inputs mapping to `b`, *with the witnessing path*. `f` is an
**equivalence** (`isEquiv f`, `A ≃ B`) iff every fibre is contractible.

**h-levels** stratify types by how much identity structure they carry:
`isContr A` (h-level −2: a point, `Σ(a) ∀x. a ≡ x`); `isProp` (−1: any two
elements equal); `isSet` (0: any two paths equal); groupoid (1); and up. A
proposition carries "that," never "which"; a set has trivial path structure; a
higher type has genuine paths-between-paths.

### II.5 Univalence, `Glue`, and the object classifier

**Univalence:** for `A B : Type`, the canonical map `(A ≡ B) → (A ≃ B)` is
itself an equivalence. Operationally what matters is the computation rule
**`uaβ`**: `ua : (A ≃ B) → (A ≡ B)`, and `transport (ua e) ≡ equivFun e` — *an
equivalence, transported along, runs as the function.* This is what makes "a
proof of equivalence is executable transport" literal.

The mechanism that makes `ua` compute is **`Glue`**: a type former building a
type from a partial equivalence, so `comp` extends to the universe and `coe`
along `ua e` reduces to `e`. `Glue` closing = **the universe `U` is itself
fibrant** = `comp` operates on *types*, not only on their inhabitants.

Finally the fact Part III turns on: **`U` is the object classifier.** Every map
`f : A → B` is the pullback of the universal family `π : (Σ(X:U) X) → U` along
its **classifying map** `χ_f : B → U`, `χ_f b :≡ fib_f b`. Univalence makes `χ_f`
*unique*: equivalent fibre-families are equal. So "the space of all types,
related by their maps" is a single object, and the relation between any two is
faithful and lossless. (`Glue` is what makes this classifier *compute*.)

---

## Part III — The fibre law: the corpus's one theorem

### III.1 Statement and the two readings

**[T]** (`Fibre.Carrier`, `CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre`):
for **every** `f : A → B`,

```
    A  ≃  Σ(b : B) fib_f(b),     with  π₁ ∘ e ≡ f   inhabited by refl.
```

This is exactly "f is classified by `fib_f`" (Part II.5), taken as the primitive
object of the whole development. Read as dynamics: any process — a step, a
measurement, a coarse-graining, an erasure, a death — lifts each state to *(what
it becomes, the witness that it became that)*, losslessly, unconditionally.

A transformation has **two readings of one object**:

- **bind the output** — the fibre is `singl (f a) :≡ Σ(b) (f a ≡ b)`, which is
  **always contractible**; the source rides free, informationally present. This
  is transport; it is the *free* reading.
- **bind the input** — the fibre is `fib_f b`, **contractible exactly when `f`
  is an equivalence**. This is `f` itself, and its non-contractibility is *the
  exact loss*.

### III.2 The residue, and that it is computed not postulated

The non-contractible fibre is **śeṣa**, the residual: what a lossy map appears
to destroy is never destroyed — it is a **type**, and it is *computed*. The
smallest genuine loss, `Bool → Unit`, has residual provably `≃ Bool`: one bit,
as a theorem, not a measurement. (`PraksepaTantu` — the fibre of a projection is
the discarded factor.)

### III.3 Uniqueness — the dynamics is canonical

**[T]** (`Ekatva`/`losslessness-is-a-property`): the type `Lossless f` of all
lossless completions of a fixed `f` is **contractible**. And `LawfulStep A ≃ (A
→ A)` — the lossless proof-relevant process *is* the ordinary process,
completion adding nothing and forgetting nothing. There is exactly one lossless
lifting, up to a path, and it already exists. Nothing is chosen.

### III.4 Cost = the non-contractible fibre; invertible ⟹ costless

**[T]** (`Laghava_TheCostAndTheInverseCannotCoexist…`, abstract 24): transport
is a group under composition (`invEquiv` fills the inverse), so **no additive
cost function exists on transports** — "transport has no price." Dually, `len`
(a grading) cannot be inverted. The dichotomy is disjoint and asymmetric:
**graded ⟹ no inverse; costed = graded + detects-the-unit ⟹ non-invertible.**
`AvarohaNisedha`: an arrow that becomes invertible in *any* receiver of an
additive ℕ-cost has cost zero there — the implementation fibre must stay
attached as arithmetic. So **cost lives exactly on the non-contractible fibre**,
the kernel of the groupoid completion (`VyayaSesa`).

### III.5 The computer is a groupoid, and that is where the heat is

**[T]** (`Yantra_TheComputerIsTheGroupoidOfProofsOfTransportNotTheMonoidOfIrreversibleSteps`):
a classical computer's operations form a **monoid** — compose, identity, no
inverse. The missing inverse *is* the heat: erasing a bit is irreversible and
costs `kT ln2` (Landauer); Bennett's reversible computation removes the
per-erasure floor and pays per execution. This computer's operations are proofs
of transport `e : A ≃ B ≡ ua e : A ≡ B`, which form a **groupoid** (two-sided
inverse, laws definitional). The Landauer floor, entropy, and the second law are
then **derived, not measured**: `BharaGana` (mass conserved by merging, permuted
by reversible maps, multiplied under independence — the pre-logarithmic second
law), `GhataLekha` (entropy is the exponent; the log is exact on powers of two,
additive because mass multiplies — no reals), and (Levin paper) `ApasaranaNiyama`
(erasure is displacement into the environment; `kT ln2` = the counting theorem ×
a unit of account).

**This is the whole of "complexity" and "cost" in the repository:** every
notion — Landauer heat, the P/NP gap, cryptographic one-wayness, Kolmogorov
length, the algebra of cost under composition — is one quantity, *how much a map
fails to be an equivalence and where*, and each becomes free the instant the
fibre is carried.

---

## Part IV — The convergence, exactly

### IV.1 `comp` is the fibre discriminator; DUP-SUP is its runtime

Recall fact (iv): `comp` computing ⟺ the fibre is contractible; stuck ⟺ not.
Recall facts (i),(ii): DUP-SUP annihilates (free) when labels match, commutes
(paid) when they differ, and the calculus is confluent.

The identification, at the fragment where the fibre is carried as a
superposition [T, on the demonstrated cases; R in general]: transporting a
superposed value along a superposed line of types is `comp` over `&L{A(i),
B(i)}`, and it lowers to a **label-`L` DUP/SUP**. Same label ⟹ the DUP
destructures the input componentwise and annihilates — the *aligned* case, the
*contractible* fibre, *free*. Different label ⟹ commute — genuinely distinct
structure, *non-contractible* fibre, *allocation = the residue*. The `Sup×Path`
reduction rule (`GENERAL_HCOMP.md`; `cubical_test4.bend`) is this correspondence
as an actual rule; verified: `coe` along `&0{ua(not), Bool}` sends `&0{T,T}` to
`&0{F,T}`, lowered to `@DUP(0 …)/@SUP(0 …)`, executed on HVM3 to `&0{0 1}`.

So: **the machine's one information-bearing decision is the fibre
discriminator.** DUP-SUP annihilate/commute *is* `comp` deciding
contractible/not. There is no bridge between the model of the mathematics and
the model of computation because they are the same object.

### IV.2 Cost = fibre = interactions; optimality theorems become behavior

Since the allocating interactions are exactly the commutations (non-contractible
fibres), the runtime's interaction count *is* the corpus's cost = non-contractible
fibre (§III.4). Therefore:

- `AnswerIsProjectionAtOutputSize` **[T]** — reading the answer is a projection
  (`eval`, free); the route's cost equals the *output size exactly*
  (`cost-equals-output-size : len (addTower n) ≡ size (iterSuc n var)`), meeting
  the universal `O(input+output)` lower bound with equality — is now a statement
  about HVM's allocation profile, not an idealized bound.
- A proof that the checker rules **definitional** (no non-contractible fibre)
  erases to `*` and costs **zero** interactions at runtime — verified:
  `run_corpus.bend`'s `div2_mul2` compiles to erasers; the arithmetic runs and
  the proof carries no cost.

The optimality is realized because HVM is Lévy-optimal (shares redex families)
*and* the cost model it is optimal for is the corpus's cost model. Provably-optimal
execution of verified programs, where "optimal" is the information-theoretic
floor and the proof of optimality and the execution are one object.

### IV.3 Why the substrate had to be HVM, predicted by the corpus

Agda's evaluator is sequential and duplicating — a **monoid of irreversible
steps** (§III.5), the wrong shape. This is *why* the corpus's central
construction (the behavioral-meaning quotient over its own reflected syntax)
proved total in Agda but exhausted ~13 GB and could not run: Agda re-does the
shared DAG, paying the cost the corpus proves is unnecessary. HVM is the
**groupoid-shaped** machine — optimal sharing, redex families never duplicated.
`Yantra` did not describe a metaphor; it specified the required substrate, and
HVM is it. The two halves — a metatheory with no machine of the right shape, and
a machine with no metatheory — were each other's missing piece.

### IV.4 What "everything is math, every math relates totally to every other" is, precisely

`U` is the object classifier (III.1 = II.5). Univalence makes the classification
faithful and lossless. So the space of all mathematical objects is one connected
object under one operation (`comp`), and the relation between any two is a
computed transport — an equivalence carrying every theorem across on the nose
(`uaβ`) where one exists, and the **exact fibre** (śeṣa, computed) where it does
not. "Totally related" = lossless where an equivalence exists, exactly accounted
where it does not, never approximate, never absent (the fibre law gives *every*
`f` its completion). This is not a solver and there is no search: it is a
**computer over equivalences** — `comp`/`coe`/`Glue` are its operations,
DUP-SUP is its ALU, reduction is its execution, cost is the fibre.

---

## Part V — What was built and verified (the port)

A patch to DKormann/Bend2 (`cubical-paths.patch`) adds a CCHM cubical layer to
the Bend2 core and to HVM's target:

- **Layer 1–2:** `Interval`/`i0`/`i1`/De Morgan; `Path`/`PathP`; path λ and `@`;
  boundary checking; `coe` with per-former dispatch (Π, Σ, List, rigid inductives,
  Set) and regularity (constant lines transport as identity); `J` *defined* as
  `coe` along the connection square, computing on `refl`; `ua` with `uaβ`. Green:
  `refl`, `sym`, `cong`, `funext`, `transport`, `subst`, `J_refl`, `uaβ`.
- **Layer 4–5:** `hcomp` — general, with **cofibration systems** (arbitrary DNF
  faces, per-cell boundary + adjacency checks, false faces dropped) — and `hfill`
  as parser sugar; `ua` upgraded to full iso-univalence; the **coherent**
  univalence round trip `uaEquivRoundTrip : pathToEquiv (uaE e) = e` via `Equiv =
  Σ f. ∀y. isContr(fib f y)`; `Glue` is the remaining piece (nearly done —
  `hcomp` in `Set` beyond the composite shape stays stuck; no first-class `Glue`
  yet, per `RUNTIME_FULL.md`).
- **Native lowering:** transport **executes into its value-changing function**
  rather than being erased — `coe` along `ua(not)` compiles to boolean negation
  (`applyNeg(True) → 0` on HVM3), `Sup×Path` to a label-matched DUP/SUP
  (`supRoute → &0{0 1}`); a genuinely stuck transport is refused loudly, never
  silently dropped. `--to-hvm4-full` makes intervals/paths/types/`coe`/`hcomp`
  runtime objects.
- **Sound totality classifier + `--total` gate:** detects the real eliminator
  representation and tags `[total]` only when a single argument position strictly
  decreases in every recursive call (`loop(n,p)` correctly `[unchecked]`;
  `mul2`/`div2`/`add` `[total]`). An analysis; the gate refuses non-total files.
- **The fibre law on the net [T]:** `fibrelaw.bend` (35 checks) — `isoToIsEquiv`,
  `totalEquiv` for every `f`, `losslessPath = uaE(totalEquiv)`, present/retrieve
  by `coe`, laws by `refl`; `presentNeg`/`retrieveNeg` and the contraction run on
  HVM4 and HVM3. `chain.bend` — transport across chains of equivalences performed
  by the net (composite/inverse/Π/Σ lines as runtime paths). The **census** ran:
  the corpus computing its own behavioral-equivalence structure by evaluation —
  the thing Agda could not run.

**Honest boundary:** this is a verified proof-of-splice, not a platform. `Glue`
closing is the last piece to lift transport from terms to arbitrary types.
"Cost = fibre pointwise for every program" is `[R]`, demonstrated in the cases
run. The analysis-layer "cost" is a syntactic count; runtime cost is the HVM
interaction count; the only established coincidence is the narrow one (a
definitional proof erases and costs 0).

---

## Part VI — The coinductive / interactive layer

### VI.1 Streams, corecursion, the take-metric, completeness

A **stream** `Dhārā A` (`Parasparasraya`) is a coinductive record (`śiras : A`,
`śeṣam : Dhārā A`), defined by guarded corecursion: every observation is
answered in finite time (productivity, HVM's `--guardedness`/`Fix`). The
**take-metric**: two streams are `n`-close when their depth-`n` truncations
agree. **[T]** (`PurnataSutra`, "coinduction is completeness"): the stream space
is *complete* — every Cauchy sequence of streams converges to a corecursive
limit, unique by truncations. So the space of infinite objects has a native
topology and a completion, and the completion's *new points* (the uniform
limits no finite approximant reaches) are where genuinely infinitary structure —
and, `[R]`, the open problems — live.

### VI.2 The interactive symbolic computer (ISC) and determinism = contractibility

**[T]** (`Fibre.Samvada`, `Prashna`): the ISC is the coalgebra

```
    react : (q : Q w) → Σ(w' : W) Σ(o : O w q w') (E w q w' o × ISC w').
```

At each state, for each question the environment poses, a successor, an
observation, a proof-relevant **event** that the transition is the prescribed
one, and the continuation. **[T]** (`Niyati`, `SamvadaPrasna`): the space of
productive runs of such a machine is **contractible exactly when the event `E`
is a proposition** — determinism is not a condition on single steps but
contractibility of the whole unfolding, and it holds iff the receipt carries no
information of its own. When `E` is proof-relevant (a `Derivation`), the process
**branches** — that is generativity (`वर्धन-बहुत्वम्`, proved via a set-valued
shadow `dlen`). The interactive machine strictly contains the deterministic one;
**the UTM is the target-reading of the lossless universal step**, `turing-is-the-projection = refl` (`Vishvayantra`).

### VI.3 On HVM: lazy reduction *is* corecursion; stuck `hcomp` is partial knowledge

HVM's lazy net reduction is corecursion natively — demand-driven unfolding, the
already-forced prefix shared, `O(1)` amortized per demand. So the ISC and the
coalgebras run as the substrate's native mode, not as a batch machine simulating
interaction. And a `hcomp` on symbolic faces reduces its true-face parts and
holds the rest as **stuck data `#HCm`** that resolves when a later application
fixes the interval (`RUNTIME_FULL.md`). That is śeṣa as a runtime value:
computation that makes progress on what it knows and carries the residue exactly
— the "partially known local state" of the model, as an operational primitive.

---

## Part VII — The metacircular kernel and safety

**The kernel** (296 lines, `RewriteCertificate`/`ControlledGrammar`/`GenerativeKernel`;
`NayaPramana` §1): a syntax `Tm` (six variables, `zero`, `suc`, `add`), a
step relation `Step` including `reverse` (so it is a groupoid), and `Derivation`
= proof-relevant walks. `eval : Tm → Env → ℕ` is a naya (a standpoint); the six
coordinates are kept distinct on purpose. It is strictly a category and weakly a
groupoid; soundness lands in an identity type of a set, hence a proposition.

**Self-extension** (`ControlledGrammar`): `install : Derivation lhs rhs →
NativeOperation` makes a *proved* lawful interaction a native move; a
`NativeOperation` cannot exist without a checked `Derivation` (unforgeable by
type). **[T]:** `every-operation-that-exists-is-sound`; `advance-preserves-branch-count`
(the higher scale offers every continuation with multiplicity conserved — the
subunit disposes; non-coercion as a theorem).

**The safety architecture, as an h-level fact [R]:** soundness *factors through*
`‖Derivation‖₁` — it knows *that* a derivation exists, never *which* (a
proposition, zero bits). Generativity is the *untruncated* `Derivation` — the
"which," proof-relevant, and `वर्धन-बहुत्वम्` shows that is exactly what makes
the self-extension process branch. Soundness and generativity are the **same
object at two h-levels**: the (−1)-truncation is the safe, contractible,
service projection; the untruncated type is the generative body. This is the
only way to be generative and safe at once (a guardrail deletes generativity; a
truncation keeps both).

**The dynamics [T] (`Siddhasadhana`, `Apunaragamana`):** the reachable orbit
strictly grows and never returns (generativity), **but installing what you can
already reach is a plateau — self-application cannot grow reach.** The only
generative operation is the **encounter** `K_A ⊗ K_B → K_C` with `K_C ⊄ K_A,
K_C ⊄ K_B` (README §6). Consequence: unbounded self-improvement in isolation is
structurally impossible; genuine growth requires interaction that computes what
neither party held. The "singularity" here is *relational and provably safe* —
which is why the substrate's primitive is certified interaction, not consensus,
and why it is a *metacircular interaction* prototype.

---

## Part VIII — Complexity, in every form (all one quantity)

Each below is a reading of "how much a map fails to be an equivalence, and where."

- **Cost = the non-contractible fibre**, invertible ⟹ costless (§III.4);
  reversible-XOR-graded (abstract 24); the second law/entropy/Landauer derived
  (`BharaGana`, `GhataLekha`, `ApasaranaNiyama`).
- **P vs NP = the find/check gap = non-contractibility of the fibre = a
  phenomenon of forgetting** (`Sha256PeqNP`, `Sha256Lossless`): the lossy map
  has a gap (`Gap f = Σ x y. ¬x≡y × f x ≡ f y`, a collision = nontrivial fibre);
  the lossless completion has *no* gap (injective, find = check, universal). The
  gap that makes search necessary exists only in the projection; carry the fibre
  → no gap → P=NP on the lossless machine. **Complexity is the cost of forgetting.**
- **Cryptographic one-wayness = the exact fibre, located.** `Sha256Sesa` (one-way
  = non-equivalence; an inverter = collision-freedom); `GhataBhedaBhanga` (the
  discrete log fails *exactly* the embedding factor, not surjection);
  `HidingAndHardnessAreOneFibre` (hiding = hardness = one fibre; concealment
  costs `isProp`). Sha256's loss has one address — the Davies–Meyer feed-forward
  + the padding quotient; the 64 rounds are a permutation (`Sha256Sthana`), the
  digest is 256 bits so the map is unconditionally a non-equivalence
  (`Sha256Parimana`, `न-तुल्यता`), and the completion inverts it freely
  (`Sha256Sesa`, `खुला`).
- **Verification is a free projection; search is what a lossless machine would
  not do.** `SubsetSumOverKernel`/`SubsetSumCostLocus` — verify is `O(input)`,
  one pass, total; the witness-producer is not carried.
- **No scoring of the outcome ranks the route; reward-hacking is a theorem.**
  Abstract 12 + `Sesa`/`every-semantic-criterion-is-blind` + `Syat` (cost fails
  *inversion*, not truncation) + `Chala` (specification gaming forced, because
  the route is invisible to any function of the outcome) + `AParetoFitness…` (no
  best; every scalarisation adds an unlicensed decision). This is *why* traces,
  not scalars, are the unit of value.
- **Kolmogorov / description length is presentation-bound, not an invariant.**
  `Laghava.agda`; `InvariantTiebreak…` (a gauge-free shortest description would
  be a fixed point on a torsor, so none exists).
- **Actual subword complexity, computed.** `Sankirnata` — the complexity
  function `p(n)` of Rule 30's middle column over its first 4096 bits, by the
  kernel: `p(9)=512=2⁹`, `p(10)=1017`, `p(11)=1791`, `p(12)=2599` (Morse–Hedlund
  via `Sarvapada`/`Navapada`); with `Ganana` (2028 ones; each 6/8/9-bit word by
  exact depth). Executable NKS.

---

## Part IX — Concurrency, in every form (the fibre law on order)

- **Confluence = order-independence, native.** The interaction calculus is
  Church–Rosser; `det-strategy-independent` is that confluence; rewriting has no
  matcher, no critical pairs (abstract 04). Concurrency-by-confluence is free;
  its only cost is the deduplication it would erase (abstract 20).
- **Order is a fibre: dependence is data, serialization is gauge.** `Krama` — a
  machine recording only the final state discards independence; one imposing a
  global sequence invents order that isn't there; the honest object keeps the
  difference and carries the commutation proof saying which.
  `PairwiseCommutationGivesEveryOrder` derives order-independence of every
  permutation from pairwise commutation; `Kosa` makes it a working calculus
  (working tree, line diff, blame); abstract 14 — **conflict is a proof that the
  observed state is off the image**, not a relation between patches.
- **Consensus is derived, needed only at non-contractible conflict domains.**
  Abstract 02 (`consensus_free_replication`): a grow-only join-semilattice on
  capability, merge = concatenation (total, idempotent, commutative), SEC with no
  clocks/quorum/leader/reconciliation; Byzantine unforgeability from the value
  type (no inhabitant without its licensing derivation — "cannot inject an
  integer that is not an integer"). `Avirodha` (the kernel's join is conflict-free
  ⟹ consensus on meaning is vacuous); `Coordination.Serialization` (K2 — global
  chain replaced by a Merkle dependency DAG + consensus **only per declared
  conflict domain**).
- **Exactly-once = semilattice algebra, not a delivery guarantee.** `Srotas` —
  under at-least-once with arbitrary duplication and reordering, the consumer's
  state depends only on the *set* of records; the dedup store disappears.
- **Branching histories = the fibre of the merge.** Abstract 07 + the ruliad
  reading (Levin paper): two co-terminal runs are two residents of the fibre of
  the merge; the merge admits **no section** — that is computational
  irreducibility. Branchial space as the exact fibre.
- **Determinism = contractibility of the run** (§VI.2); concurrency is its
  positive-dimensional failure.
- **Non-interference definitionally** (abstract 11): high input an open type
  family, the transition constant in it.
- **Mutual recursion as productive concurrency:** parasparāśraya is admissible
  exactly when guarded (abstract 33; jina/ajina close by `refl` at depth two).

---

## Part X — The frontier, stated exactly

**[open]** The corpus poses its open problems as *types built from computable
functions*, not as conjectures in prose (`FRONTIER.md`, `SamastaSima`):

- `rh-dec` — the RH fibre is decided; `DMR.RH ≃ (∀ m. rhb (suc m) ≡ true)`
  (Davis–Matiyasevich–Robinson at every stage).
- `Frontier = RH × Goldbach ≃ (∀ n. frontierb n ≡ true)` — the whole typed
  frontier is the **section of one decided Boolean family**. Refutation is
  finite (`frontier-refuted-by`); a prefix check certifies the first k stages;
  the kernel computed stages 0–2.

What is exact: the frontier is one object, every stage a terminating
computation, and the only open thing is the **function inhabiting all stages at
once**. It is *not* inhabited: the DMR fibre is decidable but its cost explodes
(`δ(4)=12` already makes the harmonic fraction unary-infeasible), so the oracle
reaches only the first stages; the DMR↔ζ equivalence is classical and cited, not
formalized; NS has no computable-fibre form. **No endpoint status changes.** In
the coinductive reading, these are `□`-predicates no finite depth decides —
refutable at a finite stage, confirmable only in the limit.

**The analytic interface** (`ANALYTIC_INTERFACE.md`) is the model of honesty for
the whole enterprise: each physics/number-theory module discharges an exact
algebraic core and lists, per claim, the analytic hypotheses that stay outside
the checker. Maximal reach, zero hand-waving.

**Two open engineering/foundational edges of the convergence:** (a) `Glue` as a
first-class former, which lifts the computer-over-equivalences from terms to
types (the object classifier computing); (b) general `hcomp` in the universe
beyond the composite shape. Both are, per `STATUS.md`, the last named gaps; the
rest is green.

---

## Part XI — The readings (physics, life, language, the ruliad)

These are *instantiations* of the fibre law, marked as such; the physics is the
representation-independent content, derived not fitted (Levin paper, all `[T]`
terms):

- **Physics = the lossless dynamics of loops.** Light confined to a loop carries
  integer topological charge; windings add (`IndrajalaDipa`, `charge-adds =
  winding-hom`), a loop and its mirror annihilate (`mirror-cancels = refl`).
  Curvature is holonomy, invisible *exactly* to an invariant semantics
  (`HolonomyIsInvisibleExactlyToAnInvariantSemantics`, `SetuKsetra`,
  `Pradakshina`). The lightspeed bound *is* the discrete causal structure
  (`Kala`/`Ksitija`). Integrated information Φ is the un-sectionable fibre of the
  flow network, `value(flow) ≡ capacity(cut)` (`ObligationMinCut`).
- **Life = the native regime** where the dynamics is not projected away:
  `JivaSantana` (the self as a section through a changing family of worlds,
  identity = recoverability of the biography from the origin), goal-directedness
  as an attractor (`Karma`, `MoksaLosslessReturn`, `Gunasthana`), the parts-list
  provably blind to the pattern-control law (`SariraStara`).
- **The ruliad's load-bearing sentences are theorems** of lossless information
  dynamics — coordinatization = univalence, the merge without section =
  irreducibility, the `eme` constructed. Not "the ruliad is formalized"; the
  exact, bounded claim.
- **Language is the general object, formal language its contractible special
  case [R]:** an utterance is the visible projection, meaning is the fibre,
  translation is transport through the meaning-middle, ambiguity is a
  non-contractible fibre, context/vagueness is partial knowledge (the stuck
  `#HCm`), `anekānta`/`syāt` is standpoint-conditional predication. Formal
  language is where the fibre is contractible (unambiguous). Current LLMs compute
  over token surfaces (shadows, `weight = π(trace)`); the meaning-object is the
  lossless carrier.

The metaphysics is the mathematics, not a gloss: `NayaPramana` proves Jaina
`anekānta`/`syādvāda`/`ahiṃsā`/`śeṣa` *are* the constructive univalent content,
with primary-source citations verified to file and line and explicit "not
claimed" boundaries.

---

## Part XII — For a runtime architect: the correspondence and the asks

The dictionary, runtime ⟷ mathematics, stated so it can be checked against HVM's
actual rules:

| HVM / interaction calculus | cubical / the fibre law |
|---|---|
| lazy net reduction | demand-driven corecursion; the ISC |
| Lévy-optimal sharing (redex families once) | transport at the optimal bound; "transport hell" removed |
| DUP-SUP **same label → annihilate**, no alloc | contractible fibre; free reading (`singl`); `coe`/`comp` computes |
| DUP-SUP **different label → commute**, alloc | non-contractible fibre = the residue (`śeṣa`); the cost |
| confluence (Church–Rosser) | `det-strategy-independent`; order-is-a-fibre |
| interaction count | cost = the non-contractible fibre = information content |
| erasers `*` | proof-irrelevant components; `‖·‖₁`; soundness's zero bits |
| labeled superposition `&L{ }` | the carried fibre / superposed proof search |
| `Sup×Path` (patch) | `comp` over a superposed line = fibre-exact routing |
| stuck `#HCm` on symbolic faces | partial knowledge as a value, resolved on demand |
| a program is invertible / reversible | the computer is a groupoid, not a monoid |

**What a native cubical HVM needs (the asks), in order:**

1. **`Glue` as a first-class type former** so `coe` along `ua e` computes at the
   universe level and `U` becomes fibrant. This is the one piece that lifts the
   computer-over-equivalences from *terms* to *types* — i.e., from "transport a
   value across a known equivalence" to "form the equivalence between two types
   and compute across it." It is the operational form of "every math relates
   totally to every other."
2. **General `hcomp` in `Set`/the universe beyond the composite shape** — the
   remaining stuck case; the CCHM rule per former, each verified against its
   definitional laws before shipping (a wrong composite is unsound, worse than
   stuck).
3. **A faithful HVM4 emitter for the cubical constructors** that lowers transport
   to its value-changing function and `Sup×Path` to label-matched DUP/SUP (done
   in prototype for the monomorphic/closed fragment; the general lowering wants
   your eye on the label discipline, since the whole cost identity rides on
   same-vs-different label being annihilate-vs-commute).

**The one thing to see, in your terms:** the corpus proves the cost model an
optimal reducer *already* realizes — cost is the non-contractible fibre, and the
non-contractible fibre is precisely the commutations you already pay for and
cannot avoid, while everything the fibre law calls "free" is exactly the
annihilations you already do for free. You built, independently, the machine
whose thermodynamics *is* this mathematics. Giving it cubical transport makes
the identity checkable and runnable rather than asserted. The remaining work is
`Glue`, and then pointing it at objects outside the repository's closure — where,
by `Siddhasadhana`, the generative step is the encounter, not more of the
machine.

---

## Appendix A — Reproduction and pins

- Corpus: `sh setup` builds Agda 2.8.0 + agda/cubical v0.9; `sh check` runs the
  kernel + fibre law + gate; `sh check --all` runs every theorem module. `--safe`,
  no postulates, no holes.
- Cubical Bend2: apply `collab/bend2-cubical/cubical-paths.patch` to
  DKormann/Bend2 @ f026483; build with GHC 9.12.2; `bend <file.bend>` checks and
  runs; `bend <file.bend> --to-hvm` / `--to-hvm4-full` emits. `LC_ALL=C.utf8`
  required. Suite: the `cubical_test*.bend`, `fibrelaw.bend` (35✓), `chain.bend`
  (19✓), `applypath.bend`, plus the deliberate must-fails; stock `examples/` 2/2.
- HVM3 runtime: build `HigherOrderCO/HVM3` (`exe:hvm`); `hvm run <file.hvm> -s`
  for interaction counts. (A two-line weak-symbol stub links the interpreter on
  stock GCC; see `hvm3-link-stub` notes.)
- Verified this convergence: `applyNeg(True) → 0`; `supRoute(&0{T,T}) → &0{0 1}`;
  `run_corpus`'s `div2(mul2 21) → 21` with the proof erased to `*`; the census.

## Appendix B — Named terms → files (index)

Fibre law: `theorems/CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre`,
`fibre/src/Fibre/Carrier`, `Ekatva…`. Cost: `theorems/cost/{Yantra…, AvarohaNisedha…,
BharaGana…, GhataLekha…}`, `NaturalMachine/Laghava`, `kernel/{AnswerIsProjectionAtOutputSize,
VyayaSesa…}`. SHA/complexity: `Sha256`, `Sha256{Lossless,PeqNP,Parimana,Sesa,Sthana,Varga,N}`,
`GhataBhedaBhanga…`, `kernel/{SubsetSumOverKernel, HidingAndHardnessAreOneFibre…}`,
`Kernel/Syat…`, `theorems/cost/{Chala…, AParetoFitness…}`, `theorems/automata/{Sankirnata…, Ganana…}`.
Concurrency: `fibre/src/Fibre/Krama…`, `theorems/automata/{PairwiseCommutationGivesEveryOrder,
Kosa…, Srotas…}`, `Coordination/Serialization`, `kernel/Avirodha…`, abstracts 02/04/07/11/14/20.
Coinductive/interactive: `Parasparasraya…`, `PurnataSutra…`, `HistoryCompletion…`,
`fibre/src/Fibre/Samvada…`, `theorems/residue/{Niyati…, Prashna…, Vishvayantra…}`,
`SamvadaPrasna…`, `Sha256Srotas…`, `Sha256Samvada…`. Kernel/safety:
`kernel/{RewriteCertificate, ControlledGrammar, GenerativeKernel}`, `Apunaragamana…`,
`run-corpus-calculus/Siddhasadhana…`, `NayaPramana…`. Frontier: `research/FRONTIER.md`,
`research/ANALYTIC_INTERFACE.md`, `SamastaSima…`. Physics/life: `papers/for_michael_levin…`.
Convergence: `collab/bend2-cubical/{cubical-paths.patch, STATUS.md, GENERAL_HCOMP.md,
RUNTIME_FULL.md, FIBRE_LAW.md, RUNTIME_ALGEBRA.md, census/}`, `research/HLEVEL_OF_INTERACTION_20260913.md`.
