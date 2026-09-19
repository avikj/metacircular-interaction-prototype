# The convergence: collapsing the tradeoff between full semantics and optimal execution

*A ground-up technical report. Audience: the repository's author, and Victor
Taelin (HVM/Bend). Written to be read from either side â” a runtime architect
fluent in interaction calculus, or a type theorist â” and to let each see the
other's half exactly. It builds every concept it uses, and introduces each
type-theory term by its interaction-calculus isomorph, not on the assumption
that cubical vocabulary is shared.*

**Discipline of claims.** Three tags run throughout. **[T]** â” a machine-checked
term, named, present in the repository at its pin. **[R]** â” a true statement
*about* checked terms (a synthesis, not itself one term). **[open]** â” not yet
inhabited/derived; stated exactly, with the obstruction named. A `[T]` means
exactly what its type says; an `[open]` is a construction not yet built. Pins:
the Agda corpus checks at **Agda 2.8.0 + agda/cubical v0.9, `--safe`** (no
postulates, no holes). The cubical Bend2 patch builds at **GHC 9.12.2 / cabal**,
applied to **DKormann/Bend2 @ f026483**; runs shown were executed on **HVM3** and
(per `STATUS.md`) HVM4.

---

## Part 0 â” What the development is, and what it is not

State this correctly first, because the natural version of the story is wrong.

The mathematics was **already complete and already executable** in Cubical Agda.
The universe was already mapped; univalence already computed; the fiber law, the
exact completion, higher descent, the interactive machine, coinduction,
self-extension, the physics/computation identification â” all already checked,
all already reducing. None of it *became real* because Bend arrived. Cubical
Agda is excellent at being Cubical Agda: computational univalence in a
trustworthy environment where these constructions genuinely reduce.

What Cubical Agda is *not* engineered for is optimal sharing, massive parallel
reduction, exploiting ubiquitous local independence, compiling a tiny calculus
into efficient nets, or serving as a production computational fabric. So before
the port the situation was:

> extraordinarily powerful computational mathematics, running on a substrate not
> engineered for extraordinary execution.

The development is therefore **not** "make the mathematics executable." It is:

> **remove the impedance mismatch between the most expressive part of the stack
> and the most performant part of the stack.**

The conventional tradeoff â” pick higher dependent structure + univalence +
coherence (Cubical Agda) *or* optimal sharing + parallelism + a tiny runtime
(Bend/HVM) â” may have collapsed into one column: higher dependent structure and
computational univalence *and* interaction-calculus execution at the optimal
sharing bound. That is not a new theorem. It is potentially a large Pareto-front
movement in language/runtime design. **The value of the development is
approximately the value of the entire mathematical system multiplied by the
increase in physically realizable scale.** It is a force multiplier on
everything already built, not another conceptual layer on top of it.

The reason the two halves fit â” and the subject of Parts Iâ“IV â” is that they are
two responses to the same structure of computation: the mathematics arrived
independently at a small *interactional* computational ontology, and HVM arrived
independently at a small *interactional* execution ontology. Parts Iâ“IV show the
primitives coincide; Part V says, in engineering terms, why that coincidence is
worth so much.

---

## Part I â” The interaction calculus (your side; fixing notation)

Nothing here is new to you; this only pins the vocabulary the later parts reuse.

An **interaction net** is a graph of agents with one principal port each;
computation is local rewriting of two agents joined at their principal ports.
Lafont's combinators are universal. Reduction is **strongly confluent**: redexes
are independent, order is irrelevant to the normal form, and parallelism needs
no coordination â” Churchâ“Rosser is definitional, not a property you arrange.

**Optimal reduction.** Na¯ve Î² duplicates work: a redex family (copies of one
redex spawned by copying a shared subterm) must reduce once, not once per copy.
Lamping/L©vy achieve the optimal bound by making duplication incremental â” a
duplicator walks in lazily â” with the sharing bookkeeping carried by **labels**
on the dup/sup nodes.

**The one information-bearing rule.** HVM carries superpositions `&L{a b}` (a
value that is both `a` and `b` at label `L`) and duplications `!&L{x y} = v`
(bind `x,y` to two lazy copies of `v` at `L`). Applications, lambdas, etc. are
structural wiring. The single rule that *decides* anything is DUP meets SUP:

- **same label** `L = L`: **annihilate** â” the pair cancels, each superposed
  branch routes to one dup variable. **No nodes allocated.**
- **different label** `L â‰  M`: **commute** â” each node copies the other; four
  where there were two. **Nodes allocated.**

Operational cost is the interaction count, and the *allocating* interactions are
exactly the different-label commutations. Everything else is free wiring.

Two facts to carry into Part IV: **(i)** the only decision is same-vs-different
label, its outcomes free (annihilate) vs. paid (commute); **(ii)** confluence,
so order is never a choice.

---

## Part II â” Cubical type theory, built from your primitives

I will not assume the HoTT vocabulary. Each term is introduced by what it *is*
operationally, with the bridge to interaction-calculus intuition inline.

### II.1 Types, Î , Î, and the problem of equality

A dependent type theory has function types `(x : A) â’ B x` (Î ) and pair types
`Î(x : A) B x`. What makes it a *foundation* rather than a programming language
is how it handles equality. For `a b : A` you want a type `a â‰¡ b` of *proofs
that they are equal*. Classic Martin-Lf type theory makes this type opaque: you
get an eliminator but cannot inspect *what a proof of equality is*. That opacity
is why equality reasoning there is painful and function extensionality is not
provable. Cubical type theory removes it by giving equality proofs a concrete
computational representation.

### II.2 The interval and paths â” equality as reduction over a formal dimension

Add a formal **interval** `I` with endpoints `i0, i1` and De Morgan structure
(`âˆ§`, `âˆ¨`, reversal `~`). `I` is not a datatype; it is a dimension you abstract
over â” like indexing a family of nets by a formal parameter that never appears
in a normal form. A **path** from `a` to `b` in `A` is a function `p : I â’ A`
with `p i0 â‰¡ a`, `p i1 â‰¡ b` definitionally. This function *is* the equality
proof.

The payoff is mechanical:

- `refl` is the constant path `<i> a`;
- symmetry is `<i> p @ (~ i)` â” reverse the dimension;
- congruence is `<i> f (p @ i)`;
- **function extensionality** is `<i> Î»x. (h x) @ i` â” free, where classic MLTT
  cannot prove it. (The port's first acceptance test, `funext` in
  `cubical_test.bend`.)

`PathP P a b` generalizes to a *line of types* `P : I â’ Type` with `a : P i0`,
`b : P i1` â” a path whose endpoints live in different types connected by `P`.

**Bridge.** A path is a formal-dimension-indexed value: an erased index that
guides how equality proofs compute and then vanishes from the normal form.

### II.3 The one Kan primitive, and why it is the only primitive

Paths must compose, invert, and obey the groupoid laws, or `â‰¡` is not even an
equivalence relation. **One** operation supplies all of it: generalized
composition, `comp`. Given a line of types, a partial element defined on some
faces of the cube (a *cofibration*), and a base agreeing with it, `comp`
produces the missing lid. Two named special cases:

- **`coe` / transport**: `comp` with an empty face constraint. Given `P : I â’
  Type` and `t : P r`, produce `coe P r s t : P s`. **Moves data from one type to
  another along a proof that the types are equal.**
- **`hcomp`**: `comp` along a constant type line â” composes paths inside one type.

`comp = hcomp` after a `coe`; `comp` is the single primitive. A type on which
`comp` computes is **fibrant**; "is this a well-behaved type" *means* "does
`comp` reduce here."

Two facts to carry: **(iii)** `comp`/`coe`/`hcomp` are **reduction**, not search
â” they rewrite a redex to normal form by rules dispatching on the type former (Î 
moves the argument backward and the result forward; Î componentwise; inductives
commute with constructors; the universe needs `Glue`). **(iv)** `comp` reducing
fully âŸº the relevant preimage is trivial (below); `comp` getting stuck âŸº that
preimage is nontrivial. The operation and the property are one event, not a test
then a branch. Hold (iv) â” Part IV shows it is your annihilate-vs-commute.

### II.4 Preimages, invertibility, and the h-level ladder

For `f : A â’ B` and `b : B`, the **fiber** `fib_f b := Î(a : A)(f a â‰¡ b)` is the
preimage `fâ»Â(b)`, but carrying the witness rather than forgetting it.

The one piece of vocabulary the whole document turns on, in your terms:

> A type is **contractible** when it has exactly one element up to unique
> deformation â” one point, every apparent other point connected to it coherently.
> Operationally: *nothing to decide, nothing to store; it collapses to a point.*

So **"the fiber `fib_f b` is contractible" means "f has a unique preimage at `b`
with no leftover structure"** â” locally invertible, nothing to carry. `f` is an
**equivalence** (`A â‰ B`) iff every fiber is contractible â” invertible with the
inverse laws holding coherently. This is the honest "isomorphism" that composes
and transports correctly.

The **h-level ladder** classifies types by how much equality structure they
carry â” the exact analog of your erasure distinctions:

- **contractible** (a point) â” nothing to store;
- **proposition** â” any two elements equal; carries *whether*, never *which*.
  **This is your eraser `*`**: its content is annihilated, it costs zero. Knows
  *that*, not *which*.
- **set** â” any two equality proofs coincide;
- **groupoid** and up â” genuine higher structure.

Keep **proposition â‰ˆ erased/`*` â‰ˆ "knows that, not which"** â” load-bearing for
the safety argument in Part VIII.

### II.5 Univalence, `Glue`, and the universe as a classifier

**Univalence:** the canonical map `(A â‰¡ B) â’ (A â‰ B)` is itself an equivalence.
Operationally what matters is its computation rule `uaÎ²`: there is `ua : (A â‰ B)
â’ (A â‰¡ B)`, and `transport (ua e) â‰¡ equivFun e`. **An invertible function, turned
into an equality of types and transported along, runs as the function.** "A
proof that two types are the same is executable code that converts between them,"
literally.

`Glue` is the former that makes `ua` *reduce*: it builds a type from a partial
equivalence so `comp` extends to the universe and `coe` along `ua e` reduces to
`e`. `Glue` closing = the universe `U` is itself fibrant = `comp` operates on
*types*, not only inhabitants.

The fact Part III turns on: **`U` is an object classifier.** Every `f : A â’ B` is
the pullback of the universal family `Ï : (Î(X:U) X) â’ U` along `Ï_f b := fib_f
b`. Univalence makes `Ï_f` unique. So "all types, related by all maps" is one
connected object, and the relation between any two is faithful and lossless;
`Glue` makes that classifier *compute*.

---

## Part III â” The one theorem: every map splits into projection + preimage

### III.1 Statement

**[T]** (`CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre`,
`fibre/src/Fibre/Carrier`): for **every** `f : A â’ B`,

```
    A  â‰  Î(b : B) fib_f(b),     with first projection â‰¡ f, witnessed by refl.
```

Every map, no side conditions, factors losslessly into its visible output (the
projection to `B`) and its preimage structure (the fiber), with projection `f` on
the nose. This is "f is classified by its fibers" (II.5) taken as the primitive
object of the whole development. Dynamically: any process â” a step, a
measurement, a coarse-graining, an erasure â” lifts each state to *(what it
becomes, the witness of how)*, losslessly, unconditionally.

### III.2 Two readings of the split

- **bind the output**: fiber `Î(b)(f a â‰¡ b)`, **always contractible** â” a point;
  the source rides free, fully present. The transport reading; the *free*
  direction.
- **bind the input**: fiber `fib_f b`, contractible **exactly when `f` is
  invertible**. This is `f` itself, and its *non*-contractibility is the exact
  loss.

That leftover is never destroyed: it is a **type, and it is computed**. The
smallest real loss, `Bool â’ Unit`, has leftover provably `â‰ Bool` â” one bit, as
a theorem, not a measurement.

### III.3 The split is canonical

**[T]** (`losslessness-is-a-property`): the type of all lossless completions of a
fixed `f` is contractible â” exactly one, up to a path, already existing; nothing
chosen. And `LawfulStep A â‰ (A â’ A)`: the lossless proof-carrying process *is*
the ordinary process, completion adding and forgetting nothing.

### III.4 Cost lives exactly on the non-invertible part

**[T]** (`Laghavaâ¦`, abstract 24): transports form a **group** under composition
(every equivalence has an inverse), so **no additive cost function exists on
transports** â” reversible work has no intrinsic price. Dually, a grading cannot
be inverted. Disjoint dichotomy: *graded âŸ no inverse; costed = graded +
detects-the-unit âŸ non-invertible.* **So cost is supported precisely on the part
of `f` that fails to be an equivalence â” the non-contractible fibers, nothing
else.**

### III.5 The machine is a groupoid; the missing inverse is the heat

**[T]** (`Yantraâ¦`): a classical computer's operations form a **monoid** â”
compose, identity, no inverse. The missing inverse *is* the heat: erasing a bit
costs `kT ln2` (Landauer); reversible computation removes the per-erasure floor
(Bennett). A computer whose operations are proofs of equivalence `e : A â‰ B â¦ ua
e : A â‰¡ B` forms a **groupoid** â” two-sided inverses, laws definitional. The
Landauer floor, entropy, and the second law come out **derived, not assumed**.

**This is the whole of "cost" in the repository.** Landauer heat, the P/NP gap,
one-wayness, description length, the algebra of cost â” one quantity: *how much a
map fails to be invertible, and where.* Each becomes free the instant the fiber
is carried.

---

## Part IV â” The primitive identity, exactly (why the impedance vanished)

### IV.1 `comp` is the invertibility test; DUP-SUP is that test running

Recall (iv): `comp` reduces fully âŸº contractible fiber (unique preimage, nothing
to store); `comp` sticks âŸº non-contractible fiber (genuine leftover). Recall
(i),(ii): DUP-SUP annihilates (free) on matching labels, commutes (paid) on
differing ones, confluent.

Identification, on the fragment where the fiber is carried as a superposition
[T on the demonstrated cases; R in general]: transporting a superposed value
along a superposed line of types is `comp` over `&L{A(i), B(i)}`, lowering to a
**label-`L` DUP/SUP**.

- **same label âŸ annihilate**: DUP destructures componentwise and cancels â” the
  aligned case, the **contractible fiber**, unique preimage, **no allocation**.
- **different label âŸ commute**: distinct structure survives â” the
  **non-contractible fiber**, the leftover, and the allocation *is* that leftover
  made physical.

The `Sup—Path` rule (`GENERAL_HCOMP.md`, `cubical_test4.bend`) is this
correspondence as an actual rewrite. Verified: `coe` along `&0{ua(not), Bool}`
sends `&0{T,T}` to `&0{F,T}`, lowered to `@DUP(0 â¦)/@SUP(0 â¦)`, executed on HVM3
to `&0{0 1}`.

So the machine's one paid decision *is* the mathematics' invertibility test.
This is the precise reason the two halves have no impedance between them: they
were the same primitive on both sides all along.

### IV.2 The engineering result of `Sup—Path` is that sharing survived contact

This is the part worth stating carefully, because the philosophical reading of
`Sup—Path` is not the point. You already knew superposition and transport
compose. The mathematics already had transport; HVM already had superposition.
The *new fact* is that **the evaluator's native sharing construct survived
contact with cubical transport.** One had every reason to fear that adding
dependent cubical structure to a high-performance interaction language forces an
ugly barrier: paths become compile-time only, transport must call a separate
evaluator, superposition must be disabled under dependent types, sharing becomes
unsound, cubical structure must normalize outside the net, the fast substrate
only handles the erased fragment. Instead `Coe(Sup(â¦))` interacts
compositionally. The engineering gold is:

> **the high-performance sharing machinery can operate underneath the higher
> mathematics without requiring the mathematics to be erased first.**

Not "transport exists" and not "superposition exists" â” that the performance
primitive and the mathematical primitive do not repel each other.

### IV.3 Cost = leftover = interactions; the optimality theorems become behavior

Allocating interactions are exactly the commutations, which are exactly the
non-contractible fibers. So **the interaction count is the corpus's cost = the
non-invertible part (Â§III.4)** on the nose. Consequences:

- `AnswerIsProjectionAtOutputSize` **[T]**: reading the answer is a projection
  (`eval`, free); a route's cost equals output size *exactly*
  (`len (addTower n) â‰¡ size (iterSuc n var)`), meeting `O(input+output)` with
  equality â” now a statement about HVM's allocation profile.
- A proof reducing to a definitional equality (no leftover) **erases to `*` and
  costs zero interactions** â” verified: `run_corpus.bend`'s `div2_mul2` compiles
  to erasers; the arithmetic runs, the proof carries no runtime cost.

Optimality is realized because HVM is L©vy-optimal *and* the cost model it is
optimal for is the corpus's cost model. The proof of optimality and the
execution are the same object.

### IV.4 Why the substrate had to be an optimal net â” predicted, not chosen

Agda's evaluator is sequential and duplicating â” a **monoid of irreversible
steps**, the wrong shape. That is *why* the corpus's central construction (a
behavioral-equivalence quotient over reflected syntax) type-checked in Agda but
exhausted ~13 GB and could not be run there: Agda re-does the shared DAG, paying
exactly the cost the corpus proves unnecessary. The mathematics was executable in
principle; the substrate charged the execution tax. An optimal, groupoid-shaped
reducer is the substrate the mathematics itself specifies (`Yantra` named it
before it was in hand), and HVM is it.

---

## Part V â” The development in engineering terms

Everything below is `[R]`: consequences of Parts 0â“IV, engineering rather than
theorem. The through-line: the semantic object is unchanged; its *physically
realizable scale* has changed, and because the object is totalizing, that change
propagates everywhere at once.

### V.1 The mathematics is unusually well-matched to optimal sharing

The corpus is not merely "code that should run faster." Its objects â” Î, Î ,
contexts, substitutions, derivation trees, coinductive continuations, multiple
canonical folds of one structure, branching interactions, higher paths â” are
saturated with shared substructure. When one derivation `d` is sent through many
eliminations at once â”

```
    fold_meaning(d),  fold_length(d),  fold_charge(d),  fold_locality(d),  â¦
```

â” a na¯ve evaluator duplicates the traversal of `d`. The theory says these are
*multiple canonical eliminations of one object*. Interaction-net sharing is
exactly *one structure â’ many computations over shared structure*, and it scales
from four folds to millions. The elucidator/multi-fold architecture becomes
computationally interesting in a way it simply was not on an ordinary evaluator.

Same for the coinductive layer: all-depth objects defined finitely, exposed on
demand, combined with optimal sharing, give **coinductive laziness — optimal
sharing** â” ten computations requesting overlapping portions of one continuing
object share a single unfolding rather than ten. No new mathematics; a
dramatically better physical realization of mathematics already in hand, on an
object peculiarly suited to it.

### V.2 Mathematical abstraction as optimization certificates (near zero
abstraction penalty)

Computer science has spent decades on the abstraction penalty: high-level
structure aids reasoning, low-level structure runs fast, compilers try to erase
the former without losing the latter. This stack suggests the more aggressive
possibility that **mathematical abstraction itself exposes the structure optimal
reduction wants**:

- univalence: two representations equal is *runtime-exploitable* data, not just
  programmer knowledge;
- behavioral equivalence: two states indistinguishable by any continuation in the
  active algebra is optimization information;
- exact residue: a continuation factoring through the visible coordinate needs no
  retained leftover;
- initiality: multiple invariants as folds of one structure can share the
  underlying traversal;
- coinduction: demand only finite structure, materialize no more;
- higher coherence: path-equal schedules can be reordered safely.

So the mathematical richness is not baggage to optimize away; it is a source of
optimization certificates.

### V.3 The physical horizon of self-application, decentralization, space

The economic consequence is the largest one. Self-application
(`derivation â’ installed operation`) was already executable mathematics (Part
VIII). Performance does not unlock it conceptually; it **expands its physical
horizon** â” from "self-application is computable" toward "self-application can
occur at industrial/planetary scale before physical resources dominate." (Bounded
still by the plateau theorem of Â§VIII: reach grows only through the encounter,
never through more of the same machine â” so the horizon that expands is the
horizon of *interaction*, not of isolated self-improvement.)

Decentralization becomes technically plausible for the same reason: validating
transformations, transporting state, computing contextual equivalences,
maintaining local views, updating continuations all become tiny interaction-net
reductions instead of heavyweight proof-assistant machinery â” so phones, laptops,
spatial devices, GPUs can execute the foundational mathematics **at the edge**,
rather than a central server interpreting the rich world and shipping dumb
projections outward.

And the spatial/interactive setting inherits it directly:
`gesture â’ term â’ cubical transformation â’ interaction-net reduction â’ updated
spatial object`, inside one fast runtime â” paths scrubbed at frame rate,
superpositions expanded live, transport animated as actual computation,
coinductive structure unfolded on demand. Bend does not invent the interface; it
makes the interface physically plausible at the fidelity the mathematics demands.

### V.4 The Mathematica comparison, and the composition with Taelin's work

Wolfram's contribution was not only ideas; it was an extraordinarily optimized
symbolic engine that made the ideas practical. The equivalent engineering problem
here is *harder*, because the object is richer: not `symbolic expression` but
`dependent higher-dimensional self-extending structure`. The move was not to
spend a decade building a bespoke symbolic runtime, but to take the execution
engine already closest to the derived optimum and restore the foundational
mathematics it was missing. That is the concrete reason a systems-minded reader
should find this interesting â” not "I formalized the ruliad," but "the completed
higher-dimensional univalent mathematics now runs on an interaction-net engine
built for optimal parallel execution."

Taelin attacked the *execution* problem from first principles for years â”
interaction combinators, optimal sharing, parallel functional reduction, HVM,
Bend â” an unusually deep contribution. This work attacked the
*semantic/foundational* problem from first principles and arrived at an
interactional, higher-dimensional, univalent computational universe. The
execution architecture one would want turned out largely already built, missing
only the foundation to express the object. Providing that foundation is the
composition:

> a first-principles execution atom + a first-principles mathematical atom, which
> fit â” not by coincidence, but because both are responses to the same structure
> of computation.

### V.5 The ceiling moves to hardware, and the value multiplies

The sharpest engineering statement: before, semantic sophistication could itself
be the bottleneck; if the port holds, the bottleneck migrates down to *how fast
the resulting interaction structure reduces physically*. That is where you want
to be, because hardware scales â” CPUs somewhat, GPUs massively, distributed
systems further, FPGAs and eventually custom interaction-net hardware â” while the
semantics need no rewrite; the same object gets progressively faster
realizations. Hence:

> value of the port â‰ˆ value of the entire mathematical system — increase in
> physically realizable scale.

The development is a force multiplier on essentially all of the mathematics
already built â” interactive latency, parallelism, self-application depth,
scientific-search scale, edge execution, spatial rendering, distributed symbolic
state, runtime instrumentation, hardware specialization â” because the object it
multiplies is totalizing.

---

## Part VI â” What was built and verified (the port)

`collab/bend2-cubical/cubical-paths.patch` adds a CCHM cubical layer to the Bend2
core and the HVM target:

- **Paths + transport:** interval/`i0`/`i1`/De Morgan; `Path`/`PathP`; path Î» and
  application; boundary checking; `coe` with per-former dispatch (Î , Î, List,
  rigid inductives, Set) and regularity; `J` **defined** as `coe` along the
  connection square, computing on `refl`; `ua` with `uaÎ²`. Green: `refl`, `sym`,
  `cong`, `funext`, `transport`, `subst`, `J_refl`, `uaÎ²`.
- **Composition + univalence:** general `hcomp` with **cofibration systems**
  (arbitrary DNF faces, per-cell boundary + adjacency checks); `hfill` sugar; full
  iso-univalence; the **coherent** round trip `pathToEquiv (uaE e) = e` via `Equiv
  = Î f. âˆy. isContr(fib f y)`. `Glue` is the one piece not yet first-class
  (`hcomp` in `Set` beyond the composite shape stays stuck), per `RUNTIME_FULL.md`.
- **Native lowering:** transport **executes into its value-changing function**
  rather than being erased â” `coe` along `ua(not)` compiles to boolean negation
  (`applyNeg(True) â’ 0`), `Sup—Path` to a label-matched DUP/SUP (`supRoute â’
  &0{0 1}`); a genuinely stuck transport is refused loudly. `--to-hvm4-full` makes
  intervals/paths/types/`coe`/`hcomp` runtime objects.
- **Sound totality classifier + `--total` gate:** reads the real eliminator
  representation, tags `[total]` only when a single argument position strictly
  decreases in every recursive call; the gate refuses non-total files.
- **The fiber law on the net [T]:** `fibrelaw.bend` (35 checks) â” `isoToIsEquiv`,
  `totalEquiv` for every `f`, `losslessPath = uaE(totalEquiv)`, present/retrieve
  by `coe`, laws by `refl`; runs on HVM4 and HVM3. `chain.bend` â” transport across
  chains of equivalences performed by the net. The **census** ran: the corpus
  computing its own behavioral-equivalence structure by evaluation â” the thing
  Agda could not run.
- **`Glue` and the universe's Kan rules [T]** (the report's asks #1/#2, since
  landed): `Glue A [(Ï,T,e)]` as a sound former with checked boundary laws;
  **transport through `Glue`**, **`hcomp` in `Set` = `Glue` with `transpEquiv`**,
  and **`ua` derived from `Glue` with `uaÎ²` definitional** (`uaglue.bend` 26â“,
  `hcompset.bend` 10â“, `glue.bend`, `glue_mustfail` 3â—). In the checker/normaliser
  *nothing cubical is stuck any more*; the full runtime (`--to-hvm4-full`) carries
  the same rules (`@coeGlue`, `hcomp` at `#Set â’ #Glue`).
- **The fibre is forced [T]** (`forcing.bend` 62â“, `forcing_run.bend` 82â“ on
  HVM4-full): the `Fibre.Trace` core â” `fiberFst` (the fibre of the projection IS
  the family), `traceIsForced` (a factorization cannot retain *less* than the
  fibre and stay a factorization â” the residue is not negotiable),
  `exactWhenContractible`/`contractibleWhenExact`. With `fibrelaw.bend` and
  `roundtrip.bend` (univalence, both round trips, 21â“), **every theorem that
  *constitutes* the object now has a green, executable counterpart on the net.**
- **The `SetQuotient` HIT and the minimal machine computing [T]** (`quotient.bend`,
  `minmachine.bend`): `Quot`/`qcl`/`qeq`/`qsquash`/`qrec` with the recursor
  computing (`qrec(qcl a,â¦) â‰¡ f a` definitional) and commuting through `Sup`;
  `MyhillNerodeMinimalMachine`'s `Meaning = S / Nerode` runs â” `quotObserve(qcl 0)
  â’ True`, `(qcl 1) â’ False`, Nerode-equivalent states collapsed via `eq/`.
- **Behavioral equivalence = path equality, both directions, no residual
  hypothesis [T]** (`effective.bend`, `hset.bend` 25â“, `nerode_effective_closed.bend`
  46â“): the generic set-quotient effectivity `effective : Path(Quot(A,R),[a],[b])
  â’ R(a,b)` (encodeâ“decode over a `Code : Quot â’ hProp` family), instantiated at
  the Nerode congruence (`nerodeEffective`); its one hypothesis `isSet hProp` is
  **proved from scratch** â” `isPropIso5` â’ `isPropPathSet` (via the univalence
  round trip `uaEta`) â’ `isSetHProp = isPropSigPath`. So the `âŸ` direction is
  discharged and computes (`nerodeEffComputes` definitional), and with `eq/` (the
  `âŸ`) the equality of meaning = observational equivalence holds on the net, the
  only remaining input being `setO : isSet Bool` â” a genuine parameter the corpus
  itself carries (`FutureQuotient`'s `isSet O`), not a gap.
- **Genuine coinduction, and determinism as one fact [T]** (`coinduction.bend`
  13â“, `streams.bend` 10â“, `silence.bend` 25â“, `interaction.bend` 36â“,
  `braid.bend` 16â“): `Answers`/`IExec` as corecursive records, `run-is-answers` as
  corecursive-path round trips, all `[productive]` under `--total`; unguarded /
  destructor-recursive "proofs" refused; false bisimulations fail *finitely*.
  `silence.bend` runs `answersUnique : PathP(Î»i. Answers(p @ i))` â” determinism as
  contractibility of the whole unfolding â” on HVM. The braid relations hold
  pointwise on the net.

**Honest boundary:** a verified proof-of-splice, not yet a platform, but the
splice is now complete for the object: the whole constitutive core (fibre law,
univalence both round trips, the forced fibre, the set-quotient minimal machine,
the coinductive/interactive calculus and braid fabric) checks and *runs* on the
interaction net. The remaining runtime frontier is a single primitive, and it is
by design not a bug: `coe`/`comp` to a **symbolic** interval endpoint stays stuck
as `#HCm` data (edge 2) â” which is exactly "the trace is the path, knowledge is
partial," the residue held as a runtime value until the interval is decided.
"Cost = fiber pointwise for every program" remains `[R]`, demonstrated in the
cases run; the analysis-layer "cost" is a syntactic count, runtime cost the
interaction count, and the established coincidence is still the narrow one.

---

## Part VII â” The coinductive / interactive layer

### VII.1 Streams, corecursion, completeness

A **stream** is a coinductive record (`head`, `tail`) by guarded corecursion â”
every observation answered in finite time. Two streams are `n`-close when their
depth-`n` prefixes agree. **[T]** (`PurnataSutra`): the stream space is
**metrically complete** â” every Cauchy sequence converges to a corecursive limit,
unique by prefixes. The completion's *new points* (uniform limits no finite
prefix reaches) are where genuinely infinitary structure â” and, `[R]`, the open
problems â” live.

### VII.2 The interactive symbolic computer; determinism as one fact

**[T]** (`Fibre/Samvada`): the interactive machine is the coalgebra

```
    react : (q : Q w) â’ Î(w' : W) Î(o : O w q w') (E w q w' o — Machine w').
```

At each state, per question: a successor, an observation, a proof-carrying
receipt `E`, a continuation. **[T]** (`Niyati`, `SamvadaPrasna`): the space of
productive runs is **contractible exactly when `E` is a proposition** â” so
**determinism is "the whole unfolding collapses to a point," and it holds iff the
receipt carries no information of its own.** Proof-relevant `E` âŸ the process
branches âŸ generativity. The universal Turing machine is the *output-reading* of
the lossless universal step (`turing-is-the-projection = refl`).

### VII.3 On HVM: lazy reduction *is* corecursion; stuck `hcomp` is partial
knowledge

Lazy net reduction is corecursion natively â” demand-driven unfolding, forced
prefix shared, `O(1)` amortized per demand â” so the interactive machine runs as
the substrate's native mode. An `hcomp` on symbolic faces reduces its known-face
parts and **holds the rest as stuck data `#HCm`** until a later application pins
the interval: the leftover as a runtime value, "partially known local state" as
an operational primitive.

---

## Part VIII â” The metacircular kernel and safety

**The kernel** (296 lines; `RewriteCertificate`/`ControlledGrammar`/
`GenerativeKernel`): a syntax `Tm`, a step relation `Step` including `reverse`
(groupoid), `Derivation` = proof-carrying walks. `eval : Tm â’ Env â’ â•` is one
evaluation standpoint. Soundness lands in an equality of a set, hence a
proposition.

**Self-extension:** `install : Derivation lhs rhs â’ NativeOperation` promotes a
*proved* lawful rewrite to a native move; a `NativeOperation` cannot exist without
a checked `Derivation` (unforgeable by type). **[T]:**
`every-operation-that-exists-is-sound`; `advance-preserves-branch-count`
(non-coercion as a theorem).

**Safety, as one fact about erasure [R]:** soundness *factors through the
propositional truncation* `â–Derivationâ–â` â” it knows *that*, never *which* (a
proposition; zero bits; **your eraser `*`**). Generativity is the *untruncated*
`Derivation` â” the "which" â” and that is exactly what makes self-extension
branch. Soundness and generativity are **the same object at two erasure levels**:
the erased view is the safe, collapsed service projection; the un-erased body is
generative. A guardrail deletes generativity; erasing the witness keeps both.

**Dynamics [T] (`Siddhasadhana`):** the reachable orbit strictly grows and never
returns, **but installing what you can already reach is a plateau â” self-
application cannot grow reach.** The only generative operation is the **encounter**
`K_A âŠ— K_B â’ K_C` with `K_C` in neither `K_A` nor `K_B`. Unbounded self-
improvement in isolation is structurally impossible; growth requires interaction
computing what neither party held. The "singularity" here is relational and
provably safe â” why the substrate's primitive is certified interaction, not
consensus, and why this is a *metacircular interaction* prototype.

---

## Part IX â” Complexity, in every form (all one quantity)

Each reads "how much a map fails to be invertible, and where."

- **Cost = the non-invertible part**, invertible âŸ costless (Â§III.4);
  reversible-XOR-graded; second law/entropy/Landauer derived.
- **P vs NP = the find/check gap = a non-invertible preimage = forgetting.**
  `Sha256PeqNP`, `Sha256Lossless`: the lossy map has a gap (a collision = a
  nontrivial preimage); the lossless completion has none (injective, find =
  check). The gap forcing search exists only in the projection; carry the
  preimage and it is gone. **Complexity is the cost of forgetting.**
- **One-wayness = the exact leftover, located.** `Sha256Sesa`;
  `GhataBhedaBhanga` (discrete log fails *exactly* the embedding factor);
  `HidingAndHardnessAreOneFibre`. SHA-256's loss has one address â” Daviesâ“Meyer
  feed-forward + the padding quotient; 64 rounds are a permutation; 256-bit digest
  âŸ unconditionally non-invertible; the completion inverts it freely.
- **Verification is a free projection; search is what a lossless machine never
  needs.** `SubsetSumOverKernel` â” verify one pass, `O(input)`, total; the
  witness-producer is not carried.
- **No score on the output ranks the route; reward-hacking is a theorem.**
  Abstract 12 + `every-semantic-criterion-is-blind` + `Chala` + `AParetoFitnessâ¦`.
  This is *why* traces, not scalars, are the unit of value.
- **Kolmogorov / description length is presentation-bound, not an invariant.**
  `Laghava.agda`.
- **Actual subword complexity, computed.** `Sankirnata` â” `p(n)` of Rule 30's
  center column over its first 4096 bits: `p(9)=512`, `p(10)=1017`, `p(11)=1791`,
  `p(12)=2599` (Morseâ“Hedlund). Executable NKS.

---

## Part X â” Concurrency, in every form (the fiber law on order)

- **Confluence = order-independence, native.** Strategy-independence *is*
  confluence; no matcher, no critical pairs (abstract 04). Its only cost is the
  deduplication it would erase (abstract 20).
- **Order is a fiber: dependence is data, serialization is gauge.** `Krama`;
  `PairwiseCommutationGivesEveryOrder`; a conflict is a **proof the observed state
  is off the image** (abstract 14), not a relation between patches.
- **Consensus is derived, needed only where preimages are non-contractible.**
  Abstract 02: grow-only join-semilattice, merge = concatenation, strong eventual
  consistency with no clocks/quorum/leader; Byzantine unforgeability from the
  value type. `Avirodha`; `Coordination.Serialization` (Merkle dependency DAG +
  consensus **only per declared conflict domain**).
- **Exactly-once = semilattice algebra, not a delivery guarantee.** `Srotas` â”
  the consumer's state depends only on the *set* of records; the dedup store
  disappears.
- **Branching histories = the fiber of the merge.** Abstract 07 + the ruliad
  reading: co-terminal runs are residents of the merge's fiber; the merge admits
  **no section** â” computational irreducibility as that fiber.
- **Determinism = contractibility of the run** (Â§VII.2); concurrency is its
  positive-dimensional failure.
- **Non-interference definitionally** (abstract 11); **mutual recursion as
  productive concurrency** when guarded (abstract 33).

---

## Part XI â” The frontier, stated exactly

**[open]** The corpus poses its open problems as *types built from computable
functions* (`FRONTIER.md`, `SamastaSima`):

- `rh-dec` â” the RH preimage is decided; `DMR.RH â‰ (âˆ m. rhb (suc m) â‰¡ true)`.
- `Frontier = RH — Goldbach â‰ (âˆ n. frontierb n â‰¡ true)` â” the entire typed
  frontier is the **section of one decided Boolean family**; refutation finite; a
  prefix check certifies the first k stages; the kernel computed stages 0â“2.

Exact: one object, every stage terminating, the only open thing the **function
inhabiting all stages at once**. Not inhabited â” the DMR preimage is decidable but
its cost explodes (`Î´(4)=12`), the DMRâ”Î equivalence is classical and cited,
Navierâ“Stokes has no computable-preimage form. **No endpoint status changes.**
`ANALYTIC_INTERFACE.md` is the honesty model: each module discharges an exact
algebraic core and lists the analytic hypotheses left outside the checker.

**The port's own frontier, updated.** The two edges this report first listed â”
`Glue` first-class, and general `hcomp` in the universe â” have since **landed**
(`uaglue.bend`, `hcompset.bend`, `glue.bend`; Part VI). The
computer-over-equivalences is lifted from terms to types: transport through
`Glue`, `hcomp`-in-`Set` = `Glue`, and `ua` from `Glue` with `uaÎ²` definitional
all compute, in the checker and the full runtime. The single remaining runtime
primitive is `comp`/`coe` to a **symbolic** interval endpoint (edge 2), and that
is the intended partial-knowledge behavior â” the residue held as `#HCm` until the
interval is decided â” not a soundness gap. Quotient **effectivity**
(`[x]â‰¡[y] âŸ xâ‰ˆy`) is now **closed**, `isSet hProp` proved from scratch
(`hset.bend`); it is no longer an open task.

---

## Part XII â” The readings (physics, life, language, the ruliad)

Instantiations of the fiber law, marked as such; the physics is
representation-independent, derived not fitted (Levin paper, all `[T]`):

- **Physics = the lossless dynamics of loops.** Confined light carries integer
  topological charge; windings add, a loop and its mirror annihilate (`= refl`).
  Curvature is holonomy, invisible *exactly* to an invariant semantics. The
  lightspeed bound *is* the discrete causal structure. Î¦ is the un-sectionable
  fiber of a flow network, `value(flow) â‰¡ capacity(cut)`.
- **Life = the native regime** where the dynamics is not projected away: the self
  as a section through a changing family of worlds; goal-directedness as an
  attractor; the parts-list provably blind to the pattern-control law.
- **The ruliad's load-bearing sentences are theorems** â” coordinatization =
  univalence, merge-without-section = irreducibility. The exact bounded claim.
- **Language is the general object; formal language its invertible special case
  [R]:** an utterance is the projection, meaning the fiber, translation transport
  through the meaning-middle, ambiguity a non-contractible fiber, context/vagueness
  partial knowledge (stuck `#HCm`). Current LLMs compute over token surfaces
  (`weight = Ï(trace)`); the meaning-object is the lossless carrier.

---

## Part XIII â” For a runtime architect: the correspondence and the asks

Dictionary, runtime âŸ mathematics, checkable against HVM's actual rules:

| HVM / interaction calculus | cubical / the fiber law |
|---|---|
| lazy net reduction | demand-driven corecursion; the interactive machine |
| L©vy-optimal sharing (redex families once) | transport at the optimal bound |
| DUP-SUP **same label â’ annihilate**, no alloc | contractible fiber = unique preimage; free; `comp` reduces |
| DUP-SUP **different label â’ commute**, alloc | non-contractible fiber = the leftover; the cost |
| confluence (Churchâ“Rosser) | strategy-independence; order-is-a-fiber |
| interaction count | cost = the non-invertible part = information content |
| erasers `*` | propositions; "knows that, not which"; soundness's zero bits |
| labeled superposition `&L{ }` | the carried fiber |
| `Sup—Path` (patch) | `comp` over a superposed line = preimage-exact routing |
| stuck `#HCm` on symbolic faces | partial knowledge as a value, resolved on demand |
| program is invertible / reversible | the machine is a groupoid, not a monoid |

**The asks, in order â” all three since delivered; stated here as what to check,
and what is genuinely still open.**

1. **`Glue` as a first-class type former** â” *delivered.* `coe` along `ua e`
   computes at the universe level, `U` is fibrant; transport-through-`Glue`,
   `hcomp`-in-`Set` = `Glue`, `ua`-from-`Glue` with `uaÎ²` definitional, in checker
   and full runtime. The computer-over-equivalences is lifted from *terms* to
   *types*. What to check: the soundness discipline â” `Glue` at a *false* face
   must not collapse to its partial type (`glue_mustfail` â—), and the Kan rule
   uses `e`'s contractible-fibre data only off the faces.
2. **General `hcomp` in `Set`/the universe** â” *delivered* (`hcompset.bend`),
   built as `Glue A [Ï â¦ (T i1, transpEquiv)]`, each rule verified against its
   definitional laws.
3. **A faithful HVM4 emitter for the cubical constructors** â” *delivered* as
   `--to-hvm4-full`: intervals, paths, types, `coe`, `hcomp` are runtime objects,
   transport lowers to its value-changing function, `Sup—Path` to label-matched
   DUP/SUP with native routing confirmed (`supline.bend` â’ `&0{0 1}`). Your eye is
   still wanted on the label discipline, since the entire cost identity rides on
   same-vs-different label being annihilate-vs-commute.

**What is genuinely still open** (small, and named exactly): `comp`/`coe` to a
**symbolic** interval endpoint â” deliberately left stuck as `#HCm`, since that
*is* the partial-knowledge semantics (the residue as a runtime value); closing it
where a symbolic endpoint should compute is edge 2. Quotient effectivity, listed
here in an earlier draft, is now closed: `isSet hProp` is proved from scratch
(`hset.bend`) and fed into the instantiated `nerodeEffective`, so
behavioral-equivalence-as-path-equality is complete on the net in both directions.

**The one thing to see, in your terms:** the mathematics was already complete and
already executing; it was paying an execution tax on a substrate not built for
it. Your reducer already realizes the cost model it proves optimal â” cost is the
non-invertible part of a map, which is precisely the commutations you already pay
for and cannot avoid, while everything the mathematics calls "free" is exactly the
annihilations you already do for free. So the port did not add semantics to a
runtime, nor speed to a proof language. It removed the impedance between them,
and thereby the execution penalty on an already-total mathematical object â” which
is why its value is that object's value times the scale it can now reach.

---

## Appendix A â” Reproduction and pins

- Corpus: `sh setup` builds Agda 2.8.0 + agda/cubical v0.9; `sh check` runs kernel
  + fiber law + gate; `sh check --all` runs every theorem module. `--safe`, no
  postulates, no holes.
- Cubical Bend2: apply `collab/bend2-cubical/cubical-paths.patch` to
  DKormann/Bend2 @ f026483; build with GHC 9.12.2; `bend <file.bend>` checks and
  runs; `bend <file.bend> --to-hvm` / `--to-hvm4-raw` / `--to-hvm4-full` emits
  (the last is the full cubical runtime, nothing erased). `LC_ALL=C.utf8`
  mandatory. Suite (final binary): `fibrelaw.bend` (35â“), `roundtrip.bend` (21â“),
  `forcing.bend` (62â“) / `forcing_run.bend` (82â“), `uaglue.bend` (26â“),
  `hcompset.bend` (10â“), `quotient.bend`/`minmachine.bend`, `coinduction.bend`
  (13â“), `streams.bend` (10â“), `silence.bend` (25â“), `interaction.bend` (36â“),
  `braid.bend` (16â“), `chain.bend` (19â“), plus the deliberate must-fails; stock
  `examples/` 2/2.
- HVM3 runtime: build `HigherOrderCO/HVM3` (`exe:hvm`); `hvm run <file.hvm> -s`
  for interaction counts.
- Verified for this convergence: `applyNeg(True) â’ 0`; `supRoute(&0{T,T}) â’
  &0{0 1}`; `run_corpus`'s `div2(mul2 21) â’ 21` with the proof erased to `*`; the
  census run.

## Appendix B â” Named terms â’ files (index)

*(Module identifiers are the repository's actual filenames; the descriptions are
the content, so the index is usable without reading the names as words.)*

Fiber law: `theorems/CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre`,
`fibre/src/Fibre/Carrier`, the uniqueness/`Ekatva` module. Cost & thermodynamics:
`theorems/cost/{Yantraâ¦, AvarohaNisedhaâ¦, BharaGanaâ¦, GhataLekhaâ¦}`,
`NaturalMachine/Laghava`, `kernel/{AnswerIsProjectionAtOutputSize, VyayaSesaâ¦}`.
SHA/complexity: `Sha256`, `Sha256{Lossless,PeqNP,Parimana,Sesa,Sthana,Varga,N}`,
`GhataBhedaBhangaâ¦`, `kernel/{SubsetSumOverKernel, HidingAndHardnessAreOneFibreâ¦}`,
`Kernel/Syatâ¦`, `theorems/cost/{Chalaâ¦, AParetoFitnessâ¦}`,
`theorems/automata/{Sankirnataâ¦, Gananaâ¦}`. Concurrency: `fibre/src/Fibre/Kramaâ¦`,
`theorems/automata/{PairwiseCommutationGivesEveryOrder, Kosaâ¦, Srotasâ¦}`,
`Coordination/Serialization`, `kernel/Avirodhaâ¦`, abstracts 02/04/07/11/14/20.
Coinductive/interactive: `Parasparasrayaâ¦`, `PurnataSutraâ¦`, `HistoryCompletionâ¦`,
`fibre/src/Fibre/Samvadaâ¦`, `theorems/residue/{Niyatiâ¦, Prashnaâ¦, Vishvayantraâ¦}`,
`SamvadaPrasnaâ¦`, `Sha256Srotasâ¦`, `Sha256Samvadaâ¦`. Kernel/safety:
`kernel/{RewriteCertificate, ControlledGrammar, GenerativeKernel}`, `Apunaragamanaâ¦`,
`run-corpus-calculus/Siddhasadhanaâ¦`, `NayaPramanaâ¦`. Frontier: `research/FRONTIER.md`,
`research/ANALYTIC_INTERFACE.md`, `SamastaSimaâ¦`. Physics/life:
`papers/for_michael_levinâ¦`. Convergence: `collab/bend2-cubical/{cubical-paths.patch,
STATUS.md, GENERAL_HCOMP.md, RUNTIME_FULL.md, FIBRE_LAW.md, RUNTIME_ALGEBRA.md,
census/}`, `research/HLEVEL_OF_INTERACTION_20260913.md`.
