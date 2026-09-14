# The convergence: an optimal interaction-net runtime for a univalent foundation

*A ground-up technical report. Audience: the repository's author, and Victor
Taelin (HVM/Bend). Written to be read from either side — a runtime architect
fluent in interaction calculus, or a type theorist — and to let each see the
other's half exactly. It builds every concept it uses, and it introduces each
type-theory term by its interaction-calculus isomorph, not on the assumption
that cubical vocabulary is shared.*

**Discipline of claims.** Three tags run throughout. **[T]** — a machine-checked
term, named, present in the repository at its pin. **[R]** — a true statement
*about* checked terms (a synthesis, not itself one term). **[open]** — not
inhabited/derived; stated exactly, with the obstruction named. A `[T]` means
exactly what its type says; an `[open]` is a construction not yet built, not a
vague aspiration. Pins: the Agda corpus checks at **Agda 2.8.0 + agda/cubical
v0.9, `--safe`** (no postulates, no holes). The cubical Bend2 patch builds at
**GHC 9.12.2 / cabal**, applied to **DKormann/Bend2 @ f026483**; runs shown were
executed on **HVM3** and (per `STATUS.md`) HVM4.

---

## 0. The one sentence

You built a reducer whose only paid operation is a specific local graph
rewrite, and whose reduction is optimal — no redex family is ever duplicated.
This repository proves, independently, that a single mathematical quantity
governs *all* of cost, complexity, concurrency, and irreversibility, and that
this quantity is decided by a single local operation. **The claim of this
document is that your paid operation and that mathematical operation are the
same operation.** Not analogous — the same, up to a definitional equality. When
that is true, your reducer is not "a fast backend for a proof language." It is
the native machine of the mathematics, running at the information-theoretic
floor, in parallel, and the mathematics' optimality theorems stop being
statements about an idealized cost model and become descriptions of your
allocator.

The rest of this document earns that, from the ground up on both sides.

---

## Part I — The interaction calculus (your side; fixing notation)

Nothing here is new to you; this section only pins the vocabulary the later
parts reuse.

An **interaction net** is a graph of agents with one principal port each;
computation is local rewriting of two agents joined at their principal ports.
Lafont's combinators are universal. Reduction is **strongly confluent**: redexes
are independent, order is irrelevant to the normal form, and parallelism needs
no coordination — Church–Rosser is definitional here, not a property you arrange.

**Optimal reduction.** Naïve β duplicates work: a redex family (copies of one
redex spawned by copying a shared subterm) must reduce once, not once per copy.
Lamping/Lévy achieve the optimal bound by making duplication incremental — a
duplicator walks in lazily — with the sharing bookkeeping (the brackets and
croissants) carried by **labels** on the dup/sup nodes.

**The one information-bearing rule.** HVM carries superpositions `&L{a b}` (a
value that is both `a` and `b` at label `L`) and duplications `!&L{x y} = v`
(bind `x,y` to two lazy copies of `v` at `L`). Applications, lambdas, etc. are
structural wiring. The single rule that *decides* anything is DUP meets SUP:

- **same label** `L = L`: **annihilate** — the pair cancels, each superposed
  branch routes to one dup variable. **No nodes allocated.**
- **different label** `L ≠ M`: **commute** — each node copies the other; four
  where there were two. **Nodes allocated.**

Operational cost is the interaction count, and the *allocating* interactions are
exactly the different-label commutations. Everything else is free wiring. You
compile this to C/CUDA/Metal; the reduction is the machine.

Two facts to carry into Part IV: **(i)** the only decision is same-vs-different
label, its outcomes free (annihilate) vs. paid (commute); **(ii)** confluence,
so order is never a choice.

---

## Part II — Cubical type theory, built from your primitives

I will not assume the HoTT vocabulary. Each term is introduced by what it *is*
operationally, with the bridge to interaction-calculus intuition stated inline.

### II.1 Types, Π, Σ, and the problem of equality

A dependent type theory has function types `(x : A) → B x` (write Π) and pair
types `Σ(x : A) B x`. The thing that makes it a *foundation* rather than a
programming language is how it handles equality. For `a b : A` you want a type
`a ≡ b` of *proofs that they are equal*. Classic Martin-Löf type theory makes
this type opaque: you get an eliminator but you cannot inspect *what a proof of
equality is*. That opacity is exactly why equality reasoning there is painful
and why function extensionality is not provable. Cubical type theory removes the
opacity by giving equality proofs a concrete computational representation.

### II.2 The interval and paths — equality as a reduction over a formal dimension

Add a formal **interval** `I` with endpoints `i0, i1` and De Morgan structure
(`∧`, `∨`, reversal `~`). `I` is not a datatype; it is a dimension you abstract
over, the way you might index a family of nets by a formal parameter that never
appears in a normal form. A **path** from `a` to `b` in `A` is a function
`p : I → A` with `p i0 ≡ a`, `p i1 ≡ b` definitionally. This function *is* the
proof of equality.

The payoff is immediate and mechanical:

- `refl` is the constant path `<i> a`;
- symmetry is `<i> p @ (~ i)` — reverse the dimension;
- congruence is `<i> f (p @ i)`;
- **function extensionality** is `<i> λx. (h x) @ i` — free, where classic MLTT
  cannot prove it. (This is the port's first acceptance test, `funext` in
  `cubical_test.bend`.)

`PathP P a b` generalizes to a *line of types* `P : I → Type`, with `a : P i0`,
`b : P i1` — a path whose endpoints live in different types connected by `P`.

**Bridge.** A path is a formal-dimension-indexed value. If you have seen a term
abstract over an erased index that guides reduction but vanishes from the normal
form, you have the right mental model: `I` guides how equality proofs compute
and then erases.

### II.3 The one Kan primitive, and why it is the only primitive

Paths must compose, invert, and obey the groupoid laws, or `≡` is not even an
equivalence relation and the theory is dead. **One** operation supplies all of
it: generalized composition, `comp`. Given a line of types, a partial element
defined on some faces of the cube (a *cofibration*), and a base agreeing with
it, `comp` produces the missing lid. Two named special cases:

- **`coe` / transport**: `comp` with an empty face constraint. Given a line of
  types `P : I → Type` and `t : P r`, produce `coe P r s t : P s`. **This moves
  data from one type to another along a proof that the types are equal.**
- **`hcomp`**: `comp` along a constant type line — composes paths inside one type.

`comp = hcomp` after a `coe`; `comp` is the single primitive. A type on which
`comp` computes is **fibrant**. "Is this a well-behaved type" *means* "does
`comp` reduce here."

Two facts to carry: **(iii)** `comp`/`coe`/`hcomp` are **reduction**, not search
— they rewrite a redex to normal form by rules that dispatch on the type former
(Π moves the argument backward and the result forward; Σ componentwise; inductive
types commute with constructors; the universe needs `Glue`, below). **(iv)**
`comp` *reducing all the way* is precisely the relevant preimage being trivial
(defined below); `comp` *getting stuck* is that preimage being nontrivial. The
operation and the property are one event, not a test followed by a branch. Hold
(iv) — Part IV shows it is your annihilate-vs-commute.

### II.4 Preimages, invertibility, and the h-level ladder

For `f : A → B` and a point `b : B`, the **fiber** `fib_f b := Σ(a : A)(f a ≡ b)`
is the set of inputs `f` sends to `b`, *each packaged with the path proving it*.
This is just the preimage `f⁻¹(b)`, but carrying the witness rather than
forgetting it.

Now the one piece of vocabulary the whole document turns on, stated in your
terms rather than HoTT's:

> A type is **contractible** when it has exactly one element up to unique
> deformation — one point, and every other apparent point is connected to it by
> a path, coherently. Operationally: *nothing to decide, nothing to store; it
> collapses to a point.*

So **"the fiber `fib_f b` is contractible" means "f has a unique preimage at
`b`, with no leftover structure"** — locally invertible there, nothing to carry.
`f` is an **equivalence** (`A ≃ B`) iff *every* fiber is contractible — i.e. `f`
is invertible with the inverse laws holding coherently. This is the honest
definition of "isomorphism" that composes and transports correctly; it is not
heavier than "bijection with proofs," just precise.

The **h-level ladder** classifies types by how much equality structure they
carry, and it is the exact analog of your erasure/sharing distinctions:

- **contractible** (a point) — nothing to store;
- **proposition** — any two elements are equal; the type carries *whether*
  something holds, never *which* witness. **This is your eraser `*`**: a
  proposition's content is annihilated, it costs zero. It knows *that*, not
  *which*.
- **set** — any two equality proofs coincide (no nontrivial paths-between-paths);
- **groupoid** and up — genuine higher structure.

Keep the identification **proposition ≈ erased/`*` ≈ "knows that, not which."**
It is load-bearing for the safety argument in Part VII.

### II.5 Univalence, `Glue`, and the universe as a classifier

**Univalence:** the canonical map `(A ≡ B) → (A ≃ B)` is itself an equivalence.
What matters operationally is its computation rule, `uaβ`: there is
`ua : (A ≃ B) → (A ≡ B)`, and `transport (ua e) ≡ equivFun e`. **An invertible
function, turned into an equality of types and transported along, runs as the
function.** This is what makes "a proof that two types are the same is executable
code that converts between them" literally true, not a slogan.

The mechanism that makes `ua` *reduce* is `Glue`: a type former that builds a
type out of a partial equivalence, so that `comp` extends to the universe and
`coe` along `ua e` reduces to `e`. `Glue` closing = the universe `U` is itself
fibrant = `comp` operates on *types*, not only their inhabitants.

The fact Part III turns on: **`U` is an object classifier.** Every `f : A → B`
is the pullback of the universal family `π : (Σ(X:U) X) → U` along its
classifying map `χ_f b := fib_f b`. Univalence makes `χ_f` *unique*: families
with equivalent fibers are equal. So "all types, related by all maps between
them" is one connected object, and the relation between any two is faithful and
lossless. `Glue` is what makes that classifier *compute*.

---

## Part III — The one theorem: every map splits into projection + preimage

### III.1 Statement

**[T]** (`CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre`,
`fibre/src/Fibre/Carrier`): for **every** `f : A → B`,

```
    A  ≃  Σ(b : B) fib_f(b),     with first projection ≡ f, witnessed by refl.
```

Every map, with no side conditions, factors losslessly into its visible output
(the projection to `B`) and its preimage structure (the fiber), and the
factorization's projection *is* `f` on the nose. This is exactly "f is classified
by its fibers" (II.5), taken as the primitive object of the whole development.

Read dynamically: any process — a step, a measurement, a coarse-graining, an
erasure — lifts each state to *(what it becomes, the witness of how it became
that)*, losslessly, unconditionally.

### III.2 Two readings of the split

- **bind the output**: the fiber is `Σ(b)(f a ≡ b)`, which is **always
  contractible** — a point. The source rides along for free, fully present. This
  is the transport reading; it is the *free* direction.
- **bind the input**: the fiber is `fib_f b`, contractible **exactly when `f` is
  invertible**. This is `f` itself, and its *non*-contractibility is the exact
  loss — what a lossy map appears to destroy.

That leftover is never destroyed: it is a **type, and it is computed**. The
smallest real loss, `Bool → Unit`, has leftover provably `≃ Bool` — one bit, as
a theorem, not a measurement (`PraksepaTantu` in the index: the fiber of a
projection is the discarded factor).

### III.3 The split is canonical

**[T]** (`losslessness-is-a-property`): the type of all lossless completions of a
fixed `f` is contractible — there is exactly one, up to a path, and it already
exists; nothing is chosen. And `LawfulStep A ≃ (A → A)`: the lossless
proof-carrying process *is* the ordinary process, completion adding nothing and
forgetting nothing.

### III.4 Cost lives exactly on the non-invertible part

**[T]** (`Laghava…`, corpus abstract 24): transports form a **group** under
composition (every equivalence has an inverse, filled by `invEquiv`), so **no
additive cost function can exist on transports** — reversible work has no
intrinsic price. Dually, a length/grading cannot be inverted. The dichotomy is
disjoint: *graded ⟹ no inverse; costed = graded + detects-the-unit ⟹
non-invertible.* An arrow that becomes invertible inside *any* additive-ℕ cost
model has cost zero there. **So cost is supported precisely on the part of `f`
that fails to be an equivalence — the non-contractible fibers, nothing else.**

### III.5 The machine is a groupoid, and the missing inverse is the heat

**[T]** (`Yantra…`): a classical computer's operations form a **monoid** —
compose, identity, no inverse. The missing inverse *is* the heat: erasing a bit
is irreversible and costs `kT ln2` (Landauer); reversible computation removes the
per-erasure floor (Bennett). A computer whose operations are proofs of
equivalence `e : A ≃ B ↦ ua e : A ≡ B` forms a **groupoid** — two-sided
inverses, laws definitional. The Landauer floor, entropy, and the second law
then come out **derived, not assumed**: mass conserved by merging and permuted by
reversible maps (the pre-log second law); entropy as the exponent, exact on
powers of two, additive because mass multiplies (no reals needed); erasure as
displacement into the environment, `kT ln2` = a counting theorem × a unit of
account (Levin paper).

**This is the whole of "cost" in the repository.** Landauer heat, the P/NP gap,
one-wayness, description length, the algebra of cost under composition — one
quantity: *how much a map fails to be invertible, and where.* Each becomes free
the instant the fiber is carried.

---

## Part IV — The convergence, exactly

### IV.1 `comp` is the invertibility test; DUP-SUP is that test running

Recall fact (iv): `comp` reduces fully ⟺ the fiber is contractible (unique
preimage, nothing to store); `comp` sticks ⟺ the fiber is non-contractible
(genuine leftover). Recall (i),(ii): DUP-SUP annihilates (free) on matching
labels, commutes (paid) on differing ones, and reduction is confluent.

Identification, on the fragment where the fiber is carried as a superposition
[T on the demonstrated cases; R in general]: transporting a superposed value
along a superposed line of types is `comp` over `&L{A(i), B(i)}`, and it lowers
to a **label-`L` DUP/SUP**.

- **same label ⟹ annihilate**: the DUP destructures the input componentwise and
  cancels. This is the *aligned* case — the **contractible fiber**, the unique
  preimage, **no allocation**.
- **different label ⟹ commute**: genuinely distinct structure survives. This is
  the **non-contractible fiber** — the leftover — and the allocation *is* that
  leftover made physical.

The `Sup×Path` reduction rule (`GENERAL_HCOMP.md`, `cubical_test4.bend`) is this
correspondence as an actual rewrite. Verified: `coe` along `&0{ua(not), Bool}`
sends `&0{T,T}` to `&0{F,T}`, lowered to `@DUP(0 …)/@SUP(0 …)`, executed on HVM3
to `&0{0 1}`.

So: **your one information-bearing decision is the invertibility test of the
mathematics.** Annihilate/commute *is* `comp` deciding trivial/nontrivial
preimage. There is no bridge between "the model" and "the machine" because they
are one object.

### IV.2 Cost = leftover = interactions; the optimality theorems become behavior

The allocating interactions are exactly the commutations, which are exactly the
non-contractible fibers. So **your interaction count is the corpus's cost = the
non-invertible part (§III.4)**, on the nose. Consequences:

- `AnswerIsProjectionAtOutputSize` **[T]**: reading the answer is a projection
  (`eval`, free); a route's cost equals output size *exactly*
  (`len (addTower n) ≡ size (iterSuc n var)`), meeting the universal
  `O(input+output)` lower bound with equality. This is now a statement about your
  allocation profile, not an idealized bound.
- A proof that reduces to a definitional equality (no leftover) **erases to `*`
  and costs zero interactions** — verified: in `run_corpus.bend`, `div2_mul2`
  compiles to erasers, the arithmetic runs, the proof carries no runtime cost.

The optimality is real because HVM is Lévy-optimal (shares redex families) *and*
the cost model it is optimal for is the corpus's cost model. Provably-optimal
execution of verified programs, where "optimal" is the information floor and the
proof of optimality and the execution are the same object.

### IV.3 Why the substrate had to be an optimal net — predicted, not chosen

Agda's evaluator is sequential and duplicating — a **monoid of irreversible
steps** (§III.5), the wrong shape. That is *why* the corpus's central
construction (a behavioral-equivalence quotient over its own reflected syntax)
type-checked in Agda but exhausted ~13 GB and would not run: Agda re-does the
shared DAG, paying the cost the corpus proves unnecessary. An optimal,
groupoid-shaped reducer — redex families never duplicated — is the required
substrate, and HVM is it. `Yantra` did not describe a metaphor; it specified the
machine, before the machine was in hand. A metatheory with no machine of the
right shape and a machine with no metatheory were each other's missing half.

### IV.4 "Everything is math, and every math relates totally to every other" — precisely

`U` is the object classifier (III.1 = II.5); univalence makes classification
faithful. So all mathematical objects form one connected object under one
operation (`comp`), and the relation between any two is a computed transport —
an equivalence carrying every theorem across on the nose (`uaβ`) where one
exists, and the **exact leftover** (computed, a type) where it does not.
"Totally related" = lossless where invertible, exactly accounted where not,
never approximate, never absent — the fiber law gives *every* `f` its
completion. **This is not a solver and there is no search.** It is a **computer
over equivalences**: `comp`/`coe`/`Glue` are its operations, DUP-SUP is its ALU,
reduction is execution, cost is the leftover. Search is what a machine does when
it has thrown the fiber away and must reconstruct it.

---

## Part V — What was built and verified (the port)

`collab/bend2-cubical/cubical-paths.patch` adds a CCHM cubical layer to the
Bend2 core and to the HVM target:

- **Paths + transport:** interval / `i0` / `i1` / De Morgan; `Path` / `PathP`;
  path λ and application; boundary checking; `coe` with per-former dispatch (Π,
  Σ, List, rigid inductives, Set) and regularity (constant lines transport as
  identity); `J` **defined** as `coe` along the connection square, computing on
  `refl`; `ua` with `uaβ`. Green: `refl`, `sym`, `cong`, `funext`, `transport`,
  `subst`, `J_refl`, `uaβ`.
- **Composition + univalence:** general `hcomp` with **cofibration systems**
  (arbitrary DNF faces, per-cell boundary + adjacency checks, false faces
  dropped); `hfill` as sugar; full iso-univalence; the **coherent** round trip
  `pathToEquiv (uaE e) = e` via `Equiv = Σ f. ∀y. isContr(fib f y)`. `Glue` is
  the one piece not yet first-class (`hcomp` in `Set` beyond the composite shape
  stays stuck), per `RUNTIME_FULL.md`.
- **Native lowering:** transport **executes into its value-changing function**
  rather than being erased — `coe` along `ua(not)` compiles to boolean negation
  (`applyNeg(True) → 0` on HVM3), `Sup×Path` to a label-matched DUP/SUP
  (`supRoute → &0{0 1}`); a genuinely stuck transport is refused loudly, never
  silently dropped. `--to-hvm4-full` makes intervals/paths/types/`coe`/`hcomp`
  runtime objects.
- **Sound totality classifier + `--total` gate:** reads the real eliminator
  representation, tags `[total]` only when a single argument position strictly
  decreases in every recursive call (`loop(n,p)` correctly `[unchecked]`;
  `mul2`/`div2`/`add` `[total]`); the gate refuses non-total files.
- **The fiber law on the net [T]:** `fibrelaw.bend` (35 checks) —
  `isoToIsEquiv`, `totalEquiv` for every `f`, `losslessPath = uaE(totalEquiv)`,
  present/retrieve by `coe`, laws by `refl`; the negation instance and the
  contraction run on HVM4 and HVM3. `chain.bend` — transport across chains of
  equivalences performed by the net (composite/inverse/Π/Σ lines as runtime
  paths). The **census** ran: the corpus computing its own behavioral-equivalence
  structure by evaluation — the thing Agda could not run.

**Honest boundary:** this is a verified proof-of-splice, not a platform. `Glue`
closing is the last piece lifting transport from terms to arbitrary types.
"Cost = fiber pointwise for every program" is `[R]`, demonstrated in the cases
run. The analysis-layer "cost" is a syntactic count; runtime cost is the
interaction count; the only established coincidence so far is the narrow one (a
definitional proof erases and costs 0).

---

## Part VI — The coinductive / interactive layer

### VI.1 Streams, corecursion, completeness

A **stream** is a coinductive record (`head : A`, `tail : Stream A`) by guarded
corecursion — every observation answered in finite time (productivity; HVM's
`--guardedness`/`Fix`). Two streams are `n`-close when their depth-`n` prefixes
agree. **[T]** (`PurnataSutra`, "coinduction is completeness"): the stream space
is **metrically complete** — every Cauchy sequence of streams converges to a
corecursive limit, unique by prefixes. The infinite-object space carries a native
topology and a completion, and the completion's *new points* (uniform limits no
finite prefix reaches) are where genuinely infinitary structure — and, `[R]`, the
open problems — live.

### VI.2 The interactive symbolic computer, and determinism as a single fact

**[T]** (`Fibre/Samvada`, `Prashna`): the interactive machine is the coalgebra

```
    react : (q : Q w) → Σ(w' : W) Σ(o : O w q w') (E w q w' o × Machine w').
```

At each state, for each question the environment poses: a successor, an
observation, a proof-carrying **receipt** `E` that the transition was the
prescribed one, and the continuation. **[T]** (`Niyati`, `SamvadaPrasna`): the
space of productive runs of such a machine is **contractible exactly when the
receipt `E` is a proposition** — i.e. **determinism is not a per-step condition;
it is "the whole unfolding collapses to a point," and it holds iff the receipt
carries no information of its own.** When `E` is proof-relevant, the process
**branches** — that is generativity. The interactive machine strictly contains
the deterministic one; the universal Turing machine is the *output-reading* of
the lossless universal step (`turing-is-the-projection = refl`).

### VI.3 On HVM: lazy reduction *is* corecursion; a stuck `hcomp` is partial knowledge

Lazy net reduction is corecursion natively — demand-driven unfolding, forced
prefix shared, `O(1)` amortized per demand. So the interactive machine runs as
your substrate's native mode, not as a batch simulator. And an `hcomp` on
symbolic faces reduces its known-face parts and **holds the rest as stuck data
`#HCm`** that resolves when a later application pins the interval
(`RUNTIME_FULL.md`). That is the leftover as a runtime value — computation making
progress on what it knows and carrying the residue exactly. "Partially known
local state," as an operational primitive.

---

## Part VII — The metacircular kernel and safety

**The kernel** (296 lines; `RewriteCertificate` / `ControlledGrammar` /
`GenerativeKernel`): a syntax `Tm` (six variables, `zero`, `suc`, `add`), a step
relation `Step` including `reverse` (so it is a groupoid), and `Derivation` =
proof-carrying walks. `eval : Tm → Env → ℕ` is one evaluation standpoint; the
six coordinates are kept distinct on purpose. Soundness lands in an equality of a
set, hence a proposition.

**Self-extension** (`ControlledGrammar`): `install : Derivation lhs rhs →
NativeOperation` promotes a *proved* lawful rewrite to a native move; a
`NativeOperation` cannot exist without a checked `Derivation` (unforgeable by
type). **[T]:** `every-operation-that-exists-is-sound`;
`advance-preserves-branch-count` (the larger scale offers every continuation with
multiplicity conserved; the subunit disposes — non-coercion as a theorem).

**Safety, as one fact about erasure [R]:** soundness *factors through the
propositional truncation* `‖Derivation‖₁` — it knows *that* a derivation exists,
never *which* (a proposition; zero bits; **your eraser `*`**, §II.4).
Generativity is the *untruncated* `Derivation` — the "which," proof-relevant —
and that is exactly what makes the self-extension process branch. Soundness and
generativity are **the same object at two erasure levels**: the erased view is
the safe, collapsed, service projection; the un-erased body is the generative
one. This is the only way to be generative and safe at once — a guardrail
deletes generativity; erasing the witness keeps both.

**Dynamics [T] (`Siddhasadhana`, `Apunaragamana`):** the reachable orbit strictly
grows and never returns (generativity), **but installing what you can already
reach is a plateau — self-application cannot grow reach.** The only generative
operation is the **encounter** `K_A ⊗ K_B → K_C` with `K_C` contained in neither
`K_A` nor `K_B`. Consequence: unbounded self-improvement in isolation is
structurally impossible; genuine growth requires interaction that computes what
neither party held. The "singularity" here is *relational and provably safe* —
which is why the substrate's primitive is certified interaction, not consensus,
and why this is a *metacircular interaction* prototype.

---

## Part VIII — Complexity, in every form (all one quantity)

Each item reads "how much a map fails to be invertible, and where."

- **Cost = the non-invertible part**, invertible ⟹ costless (§III.4);
  reversible-XOR-graded (abstract 24); second law / entropy / Landauer derived.
- **P vs NP = the find/check gap = a non-invertible preimage = forgetting.**
  `Sha256PeqNP`, `Sha256Lossless`: the lossy map has a gap
  (`Gap f = Σ x y. ¬ x≡y × f x ≡ f y` — a collision, i.e. a nontrivial preimage);
  the lossless completion has *no* gap (injective, find = check). The gap that
  forces search exists only in the projection; carry the preimage and it is
  gone. **Complexity is the cost of forgetting.**
- **One-wayness = the exact leftover, located.** `Sha256Sesa` (one-way =
  non-invertible; an inverter = collision-freedom); `GhataBhedaBhanga` (discrete
  log fails *exactly* the embedding factor, not surjection);
  `HidingAndHardnessAreOneFibre` (hiding = hardness = one leftover; concealment
  costs a proposition). SHA-256's loss has one address — the Davies–Meyer
  feed-forward plus the padding quotient; the 64 rounds are a permutation, the
  digest is 256 bits so the map is unconditionally non-invertible, and the
  completion inverts it freely.
- **Verification is a free projection; search is what a lossless machine never
  needs.** `SubsetSumOverKernel` — verify is one pass, `O(input)`, total; the
  witness-producer is simply not carried.
- **No score on the output ranks the route; reward-hacking is a theorem.**
  Abstract 12 + `every-semantic-criterion-is-blind` + `Chala` (specification
  gaming is forced, because the route is invisible to any function of the
  outcome) + `AParetoFitness…` (no best; every scalarization is an unlicensed
  decision). This is *why* traces, not scalars, are the unit of value.
- **Kolmogorov / description length is presentation-bound, not an invariant.**
  `Laghava.agda`; a gauge-free shortest description would be a fixed point on a
  torsor, so none exists.
- **Actual subword complexity, computed.** `Sankirnata` — the complexity function
  `p(n)` of Rule 30's center column over its first 4096 bits, by the kernel:
  `p(9)=512`, `p(10)=1017`, `p(11)=1791`, `p(12)=2599` (Morse–Hedlund), with each
  6/8/9-bit word by exact depth. Executable NKS.

---

## Part IX — Concurrency, in every form (the fiber law on order)

- **Confluence = order-independence, native.** The calculus is Church–Rosser;
  strategy-independence *is* that confluence; rewriting has no matcher and no
  critical pairs (abstract 04). Concurrency-by-confluence is free; its only cost
  is the deduplication it would erase (abstract 20).
- **Order is a fiber: dependence is data, serialization is gauge.** `Krama` — a
  machine keeping only the final state discards independence; one imposing a
  global sequence invents order that isn't there; the honest object keeps the
  difference and carries the commutation proof. `PairwiseCommutationGivesEveryOrder`
  derives order-independence of every permutation from pairwise commutation; a
  conflict is a **proof that the observed state is off the image** (abstract 14),
  not a relation between patches.
- **Consensus is derived, needed only where preimages are non-contractible.**
  Abstract 02: a grow-only join-semilattice, merge = concatenation (total,
  idempotent, commutative), strong eventual consistency with no clocks / quorum /
  leader; Byzantine unforgeability straight from the value type (no inhabitant
  without its licensing derivation). `Avirodha` (the kernel's join is
  conflict-free ⟹ consensus on meaning is vacuous); `Coordination.Serialization`
  (global chain replaced by a Merkle dependency DAG + consensus **only per
  declared conflict domain**).
- **Exactly-once = semilattice algebra, not a delivery guarantee.** `Srotas` —
  under at-least-once with arbitrary duplication and reordering, the consumer's
  state depends only on the *set* of records; the dedup store disappears.
- **Branching histories = the fiber of the merge.** Abstract 07 + the ruliad
  reading: two co-terminal runs are two residents of the merge's fiber; the merge
  admits **no section** — that is computational irreducibility. Branchial space
  as that exact fiber.
- **Determinism = contractibility of the run** (§VI.2); concurrency is its
  positive-dimensional failure.
- **Non-interference definitionally** (abstract 11): make the high input an open
  type family and the transition constant in it.
- **Mutual recursion as productive concurrency:** admissible exactly when guarded
  (abstract 33).

---

## Part X — The frontier, stated exactly

**[open]** The corpus poses its open problems as *types built from computable
functions*, not prose conjectures (`FRONTIER.md`, `SamastaSima`):

- `rh-dec` — the RH preimage is decided; `DMR.RH ≃ (∀ m. rhb (suc m) ≡ true)`
  (Davis–Matiyasevich–Robinson at every stage).
- `Frontier = RH × Goldbach ≃ (∀ n. frontierb n ≡ true)` — the entire typed
  frontier is the **section of one decided Boolean family**. Refutation is finite
  (`frontier-refuted-by`); a prefix check certifies the first k stages; the
  kernel computed stages 0–2.

What is exact: the frontier is one object, every stage a terminating computation,
and the only open thing is the **function inhabiting all stages at once**. It is
*not* inhabited — the DMR preimage is decidable but its cost explodes (`δ(4)=12`
already puts the harmonic fraction beyond unary evaluation), so the oracle reaches
only the first stages; the DMR↔ζ equivalence is classical and cited, not
formalized; Navier–Stokes has no computable-preimage form. **No endpoint status
changes.** In the coinductive reading these are always-eventually predicates no
finite depth decides — refutable at a finite stage, confirmable only in the limit.

`ANALYTIC_INTERFACE.md` is the model of honesty for the whole enterprise: each
physics / number-theory module discharges an exact algebraic core and lists, per
claim, the analytic hypotheses that stay outside the checker. Maximal reach, zero
hand-waving.

**Two open edges of the convergence itself:** (a) `Glue` as a first-class former,
lifting the computer-over-equivalences from terms to types (the object classifier
computing); (b) general `hcomp` in the universe beyond the composite shape. Both
are, per `STATUS.md`, the last named gaps; the rest is green.

---

## Part XI — The readings (physics, life, language, the ruliad)

Instantiations of the fiber law, marked as such; the physics is the
representation-independent content, derived not fitted (Levin paper, all `[T]`):

- **Physics = the lossless dynamics of loops.** Light confined to a loop carries
  integer topological charge; windings add (`charge-adds = winding-hom`), a loop
  and its mirror annihilate (`mirror-cancels = refl`). Curvature is holonomy,
  invisible *exactly* to an invariant semantics. The lightspeed bound *is* the
  discrete causal structure. Integrated information Φ is the un-sectionable fiber
  of a flow network, `value(flow) ≡ capacity(cut)`.
- **Life = the native regime** where the dynamics is not projected away: the self
  as a section through a changing family of worlds (identity = recoverability of
  the biography from the origin), goal-directedness as an attractor, the
  parts-list provably blind to the pattern-control law.
- **The ruliad's load-bearing sentences are theorems** of lossless information
  dynamics — coordinatization = univalence, the merge-without-section =
  irreducibility. The exact, bounded claim, not "the ruliad is formalized."
- **Language is the general object; formal language its invertible special case
  [R]:** an utterance is the visible projection, meaning is the fiber, translation
  is transport through the meaning-middle, ambiguity is a non-contractible fiber,
  context/vagueness is partial knowledge (the stuck `#HCm`), standpoint-relative
  assertion is the fiber conditioned on a projection. Formal language is where the
  fiber is contractible (unambiguous). Current LLMs compute over token surfaces
  (shadows, `weight = π(trace)`); the meaning-object is the lossless carrier.

---

## Part XII — For a runtime architect: the correspondence and the asks

Dictionary, runtime ⟷ mathematics, stated so it can be checked against HVM's
actual rules:

| HVM / interaction calculus | cubical / the fiber law |
|---|---|
| lazy net reduction | demand-driven corecursion; the interactive machine |
| Lévy-optimal sharing (redex families once) | transport at the optimal bound |
| DUP-SUP **same label → annihilate**, no alloc | contractible fiber = unique preimage; free; `coe`/`comp` reduces |
| DUP-SUP **different label → commute**, alloc | non-contractible fiber = the leftover; the cost |
| confluence (Church–Rosser) | strategy-independence; order-is-a-fiber |
| interaction count | cost = the non-invertible part = information content |
| erasers `*` | propositions; "knows that, not which"; soundness's zero bits |
| labeled superposition `&L{ }` | the carried fiber |
| `Sup×Path` (patch) | `comp` over a superposed line = preimage-exact routing |
| stuck `#HCm` on symbolic faces | partial knowledge as a value, resolved on demand |
| program is invertible / reversible | the machine is a groupoid, not a monoid |

**The asks, in order:**

1. **`Glue` as a first-class type former**, so `coe` along `ua e` computes at the
   universe level and `U` becomes fibrant. This is the one piece lifting the
   computer-over-equivalences from *terms* to *types* — from "transport a value
   across a known equivalence" to "form the equivalence between two types and
   compute across it." Operationally, it is "every math relates totally to every
   other" made to reduce.
2. **General `hcomp` in `Set` / the universe beyond the composite shape** — the
   remaining stuck case; the CCHM rule per former, each verified against its
   definitional laws before shipping (a wrong composite is unsound — worse than
   stuck).
3. **A faithful HVM4 emitter for the cubical constructors** that lowers transport
   to its value-changing function and `Sup×Path` to label-matched DUP/SUP (done
   in prototype for the closed/monomorphic fragment; the general lowering wants
   your eye on the label discipline, since the entire cost identity rides on
   same-vs-different label being annihilate-vs-commute).

**The one thing to see, in your terms:** the corpus proves the cost model an
optimal reducer *already* realizes. Cost is the non-invertible part of a map, and
the non-invertible part is precisely the commutations you already pay for and
cannot avoid, while everything the mathematics calls "free" is exactly the
annihilations you already do for free. You built, independently, the machine
whose thermodynamics *is* this mathematics. Cubical transport makes the identity
checkable and runnable rather than asserted. The remaining work is `Glue`, and
then pointing the machine at objects outside this repository's closure — where,
by the plateau theorem, the generative step is the encounter, not more of the
same machine.

---

## Appendix A — Reproduction and pins

- Corpus: `sh setup` builds Agda 2.8.0 + agda/cubical v0.9; `sh check` runs kernel
  + fiber law + gate; `sh check --all` runs every theorem module. `--safe`, no
  postulates, no holes.
- Cubical Bend2: apply `collab/bend2-cubical/cubical-paths.patch` to
  DKormann/Bend2 @ f026483; build with GHC 9.12.2; `bend <file.bend>` checks and
  runs; `bend <file.bend> --to-hvm` / `--to-hvm4-full` emits. `LC_ALL=C.utf8`
  required. Suite: `cubical_test*.bend`, `fibrelaw.bend` (35✓), `chain.bend`
  (19✓), `applypath.bend`, the deliberate must-fails; stock `examples/` 2/2.
- HVM3 runtime: build `HigherOrderCO/HVM3` (`exe:hvm`); `hvm run <file.hvm> -s`
  for interaction counts. (A two-line weak-symbol stub links the interpreter on
  stock GCC.)
- Verified for this convergence: `applyNeg(True) → 0`; `supRoute(&0{T,T}) →
  &0{0 1}`; `run_corpus`'s `div2(mul2 21) → 21` with the proof erased to `*`; the
  census run.

## Appendix B — Named terms → files (index)

*(Module identifiers are the repository's actual filenames; the descriptions are
the content, so the index is usable without reading the names as words.)*

Fiber law: `theorems/CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre`,
`fibre/src/Fibre/Carrier`, the uniqueness/`Ekatva` module. Cost & thermodynamics:
`theorems/cost/{Yantra…, AvarohaNisedha…, BharaGana…, GhataLekha…}`,
`NaturalMachine/Laghava`, `kernel/{AnswerIsProjectionAtOutputSize, VyayaSesa…}`.
SHA / complexity: `Sha256`, `Sha256{Lossless,PeqNP,Parimana,Sesa,Sthana,Varga,N}`,
`GhataBhedaBhanga…`, `kernel/{SubsetSumOverKernel, HidingAndHardnessAreOneFibre…}`,
`Kernel/Syat…`, `theorems/cost/{Chala…, AParetoFitness…}`,
`theorems/automata/{Sankirnata…, Ganana…}`. Concurrency:
`fibre/src/Fibre/Krama…`, `theorems/automata/{PairwiseCommutationGivesEveryOrder,
Kosa…, Srotas…}`, `Coordination/Serialization`, `kernel/Avirodha…`, abstracts
02/04/07/11/14/20. Coinductive / interactive: `Parasparasraya…`, `PurnataSutra…`,
`HistoryCompletion…`, `fibre/src/Fibre/Samvada…`,
`theorems/residue/{Niyati…, Prashna…, Vishvayantra…}`, `SamvadaPrasna…`,
`Sha256Srotas…`, `Sha256Samvada…`. Kernel / safety:
`kernel/{RewriteCertificate, ControlledGrammar, GenerativeKernel}`,
`Apunaragamana…`, `run-corpus-calculus/Siddhasadhana…`, `NayaPramana…`. Frontier:
`research/FRONTIER.md`, `research/ANALYTIC_INTERFACE.md`, `SamastaSima…`.
Physics / life: `papers/for_michael_levin…`. Convergence:
`collab/bend2-cubical/{cubical-paths.patch, STATUS.md, GENERAL_HCOMP.md,
RUNTIME_FULL.md, FIBRE_LAW.md, RUNTIME_ALGEBRA.md, census/}`,
`research/HLEVEL_OF_INTERACTION_20260913.md`.
