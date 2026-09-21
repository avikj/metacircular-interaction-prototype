# What the cubical core gives an engineer

`README.md` says what the port is and `REPORT.md` says how every line of
it works. This document says what it is *for*: what a Bend programmer can
now write that they could not, what can no longer go wrong, and what it
costs. Each point names the test in `tests/cubical/` that demonstrates it,
so every claim here is a program you can run.

One idea underlies everything below. Every rule the core adds is the
same question asked at a boundary: *what is the runtime content of this
thing?* A path over data has none and is erased; a path between types is
an equivalence, a pair of closures, and is affine; a function into a
proof has none and copies freely; a host may hand over only what its
runtime representation fully describes; a compiled node is taken through
its refcount tag exactly when its kind says it may be copied. If you
remember one thing, remember the question.

Two facts frame everything below:

- **A program that uses none of this is unchanged.** The runtime
  elaboration pass returns immediately for a definition with no path
  operation, which is every pre-existing program; upstream's whole test
  suite compiles to the same behavior, and upstream's benches (`bfs`,
  `queens`, `tree-matmul`, sequential) run within 1% of upstream.
- **Transport compiles to the code you would have written.** Along a
  proof about indices it is the identity; along a list of equivalences it
  is a map; along a function line it is a wrapper. You pay only for work
  the mathematics says exists, and you no longer write or trust that code
  by hand.

## Every claim below was checked against upstream

Each section states what upstream cannot do, the feature of upstream that
prevents it, how the core resolves it, and what it costs. "Verified"
means the program was run on pristine upstream `2.0.21` and on the fork,
and the outputs are as stated. Where upstream already had something, the
section says so.

## 0. What upstream already had (not claimed as new)

**Transport along an index proof.** Upstream's J (`%e : T[_]; v`) already
moves a value from `Vec<n + 0>` to `Vec<n>` given a proof, and compiles it
to the identity. `tests/cubical/j_index.bend` pins this and it prints the
same on both trees. So "index mismatch friction" is *not* a cubical
contribution: matrix reshapes, protocol state proofs, bit-width
concatenation and schema-version moves were all available as J rewrites.
What the core changes about J is the next section.

## 1. Equality proofs compute on every path, definitionally

**Upstream.** `%e : P; f` steps only when `e` normalizes to `{==}`. On a
closed proof that is usually the case. On an *open* one (a hypothesis `p`,
a lemma applied to a variable) the rewrite is stuck at check time, so
nothing can be proved *about* a rewrite, and no proof can be *built* by
abstraction: the only way to introduce an equation is `{==}` (check-rfl is
the sole introduction rule for `Eql` in upstream's `bend.ts`), so every
equation ever constructed is, up to J, reflexivity.

**Why that blocks things.** Funext, univalence, quotients and bisimulation
all need equations that are not reflexivity: a path *between* two distinct
functions, two distinct types, two distinct representatives.

**Resolution.** An equation is a path: `i => t` introduces one by
abstraction with its faces checked by conversion, `p(r)` eliminates it,
and J steps on every path (as transport along the connection square). The
faces of `Equal.sym(p)`, `Equal.trans(p, q)`, a `coe` along a line of path
types, all compute. `tests/cubical/j.bend`, `coe.bend`.

**Cost.** None at runtime: a path is erased to `{==}` and a path at a
literal endpoint is the endpoint, read off its annotation. At check time,
interval conversion is a table of at most 4^8 cases.

**Verified.** Upstream on `funext.bend`, `ua.bend`, `hit_quot.bend`: parse
errors or undefined names (`-`, `coe`, `path` do not exist). The
engineering value of this section is realized through sections 2 to 6.

## 2. Function extensionality

**Before.** Two functions that agree on every input were not provably
equal (upstream's `proof/no_funext_000` asserts exactly this). So a
refactored function could not be shown equal to the original, and every
theorem about the original had to be re-proved.

**Why upstream cannot.** An equation between functions can only be
`{==}`, and two syntactically different functions are not convertible;
there is no way to build the equation from pointwise evidence.

**Resolution.** Funext is a four-line path: `i => x => p(x)(i)`, checked
by its faces. `tests/cubical/funext.bend`. **Cost:** none; the path is
erased. **Verified:** upstream's `proof/no_funext_000` asserts
unprovability and is the one intended divergence of the suite.

**Where it shows up.**
- *Refactor safety.* Replace a recursive fold by a tail-recursive one,
  prove pointwise agreement, rewrite once; every downstream theorem holds.
- *Interface conformance.* A mock and the production implementation are
  provably equal on the observable API; tests against the mock are
  theorems about production.
- *Compiler passes.* `eval ∘ opt == eval` is one equality you compose
  across passes.
- *Caches.* A memoized function equals the unmemoized one; that is the
  whole specification of a cache.
- *Numerics.* Horner and naive polynomial evaluation are equal functions;
  prove once, ship the fast one.

## 3. Univalence: equivalent types are equal

**Before.** Two types interchangeable in every way (a record and a tuple,
a list of pairs and a pair of lists, a state machine and its table) were
different types; every proof about one had to be redone for the other.

**Why upstream cannot.** `{A == B : Type}` has one inhabitant, `{==}`,
which requires `A` and `B` convertible; transport along it is the
identity. There is no term that turns two functions and two round-trip
proofs into an equation of types.

**Resolution.** `ua(e) : {A == B : Kind(q)}` is a definition (a `Glue`
line), transport along it runs `e`'s function, and `Equiv.of_path(ua(e))`
is `e` again. `tests/cubical/ua.bend`, `ua_round.bend`, `fibre.bend`,
`compiled_coe.bend`, `compiled_path.bend`. **Cost:** a universe path is a
pair of closures at runtime; a transport along it is one call, along a
list of them one map, which is the hand-written conversion. **Verified:**
upstream refuses `coe` and `ua` as undefined names.

**Where it shows up.**
- *Representation change with proof transfer.* Verified over
  `List<Pair>`, shipped as `Pair<List, List>` (struct of arrays for SIMD):
  one equivalence, every invariant carried, and the transport compiles to
  the transpose you would write anyway.
- *Encoding and decoding.* A serializer and parser with round-trip proofs
  *are* an equivalence; `ua` makes "the wire form equals the in-memory
  form" a fact, and every property of the in-memory type a property of
  the bytes.
- *Newtypes.* `UserId` over `U32` is equivalent to `U32`; lemmas transport
  without wrapping by hand.
- *API versioning and schema migration.* If v2 of a row or message type
  is equivalent to v1 (fields renamed, reordered, split or merged without
  loss), the equivalence is the migration function, `ua` makes the two
  types equal, and every invariant proved of v1 rows holds of v2 rows by
  transport, which compiles to that function. Three cases to keep apart:
  a migration by an index proof (`Row<v + 1>` is `Row<v'>`) was already a
  J rewrite upstream (section 0); a migration by equivalence is this
  section and is new; a migration that adds or drops information (a new
  column with a default) is an embedding, and no equality theory makes it
  an equality. The rows are Bend values inside the program; nothing here
  reaches a database outside it.
- *Numeric representations.* Montgomery form and standard form of a field
  element are equivalent; prove the arithmetic once in the convenient form.
- *Hardware and software views.* A register file as a record and as a bit
  vector are equal types; the ISA spec proved over the record applies to
  the bits.
- *The fibre law.* `A ≃ (&b:B -> fiber f b)` for every `f`, so any function
  is losslessly a family of fibres; `present` is the factoring and
  `retrieve` its inverse, by computation, on the C and JS lanes
  (`compiled_fibre.bend`).

## 4. Higher inductive types: quotients and truncation

**Before.** "A set of things modulo a relation" meant picking a canonical
form and maintaining it by hand; nothing checked that functions respected
the relation.

**Why upstream cannot.** A `type` declares constructors whose tip is the
family; there is no way to declare an equation as a constructor, so a
quotient can only be simulated by a chosen normal form nothing enforces.

**Resolution.** `path c{fields}: {a == b : K<..>}` declares a path
constructor; `match` on the family must supply its arm at the path over
the motive, so a function out of the quotient is refused unless it
respects the relation. `tests/cubical/hit_quot.bend`, `hit_circle.bend`,
`hit_trunc.bend`, `hit_susp_torus.bend`, `hit_mustfail_loop.bend`.
**Cost:** none at runtime; a path constructor is erased, so a quotient is
represented by its underlying data. **Verified:** upstream's parser
rejects `path` in a `type` block.

**Where it shows up.**
- *Money.* Amounts modulo currency-rounding; a formatter or a sum must
  respect the rule or it does not typecheck.
- *Normalized identifiers.* Email domains modulo case, paths modulo `.`
  and `..`, strings modulo Unicode normalization: equality is the semantic
  one, and every function must respect it.
- *Sets and multisets.* `List<T>` modulo permutation is a multiset, modulo
  permutation and duplication a set; a function out of a set cannot depend
  on insertion order, by type.
- *Rationals, redundant-digit integers.* Quotients of pairs; arithmetic is
  checked well defined.
- *Terms modulo alpha, graphs modulo isomorphism.* A compiler IR where
  bound names do not matter, enforced.
- *Truncation.* "Some worker is idle" without exposing which, so a
  scheduler cannot become deterministic on an internal ordering; the right
  type for a search result whose identity you may not depend on.

## 5. Coinduction: productive infinite structures

**Before.** The descent check refused any self-call that did not shrink an
argument, so streams, servers and event loops as *values* could not be
typed; they were imperative loops outside the checked world.

**Why upstream cannot.** Every live self-call must descend on a column
of the definition's case tree (`term_descend`); a self-call under a
constructor's lambda descends on nothing and is refused.

**Resolution.** A self-call under a constructor's delayed field, observed
only through dimensions, is productive: each observation unfolds one
constructor. The definition is marked corecursive, stays folded while
printed or compared, and a bisimulation is a corecursive path checked
one unfolding at a time. `tests/cubical/stream.bend`,
`stream_mustfail.bend`. **Cost:** none; the closure is the same closure.
**Verified:** upstream refuses `ones = mk{1n, _ => ones}` with its descent
error, and its own `halt/strict_descent` pins that refusal (the second
intended divergence).

**Where it shows up.**
- *Servers and event loops* as infinite request-response sequences with a
  type, and a proof that no request is dropped.
- *Signal processing and reactive streams:* filters, windows, debouncing,
  with bisimulation proofs that a fused pipeline equals the composed one.
- *Generators:* primes, Fibonacci, pseudo-random sequences as values, not
  closures over mutable state.
- *Simulation loops:* a physics step or game tick whose per-step invariant
  is checked once.
- *Tokenizers over infinite input,* productive by construction.

## 6. Proof-valued functions are copyable

**Before.** Functions were affine (used once) and a proof about a function
is itself a function, so a theorem was a resource consumed by its first
use. An equivalence (a function plus a proof it is invertible) could not be
used twice.

**Why upstream cannot.** No function type is `Data` (`infer-all` gives
every `All` the kind `Type`), so a proof-valued function is affine: not a
`+` binder, not a field of a `Data` type.

**Resolution.** A function into an equation is `Data`, whatever its
domain, since it has no runtime content to copy; the omega attack this
could open (a copyable function inside its own domain) is closed by a
positivity check on datatype fields. `isContr`, `isEquiv`, `Equiv` are
ordinary Base definitions. `tests/cubical/proof_fn_copy.bend`,
`proof_fn_kind.bend` (a proof function over closures, used twice and
stored in a record), `positivity_mustfail.bend`. **Cost:** none; the function is erased.
**Verified:** upstream refuses `+h: @x:Nat -> {x == x : Nat}` and a `Data`
field of that type, both with "expected Data, observed Type".

**Where it shows up.**
- *Reusable specifications:* a `sorted` predicate and its proofs passed to
  many consumers.
- *Equivalence libraries:* composition, inverses, the fibre law, all reuse
  proofs freely.
- *Certificates:* a proof that a hash matches or a bound holds, attached to
  a value and read by every pipeline stage.

## 7. Runtime transport on the native lanes

**Why upstream cannot.** Nothing to transport: the only type path is
`{==}`.

**Resolution.** A universe path compiles to its equivalence; `coe` along a
datatype line to a minted structural map; along a function line to a
wrapper; a path applied to an endpoint to that endpoint; a path
constructor at literal dimensions to its boundary. The C, JS and
interpreter lanes agree. `tests/cubical/compiled*.bend`,
`hit_susp_torus.bend` on all lanes.

**Where it shows up.**
- *Proof-carrying data paths:* the verified conversion is the shipped
  conversion; no extraction step, no C re-implementation that drifts.
- *Zero cost when trivial,* one map when not.
- *GPU lanes:* the same elaborated code goes to Metal and CUDA.

## What can no longer go wrong

- **Foreign code cannot deliver evidence** (issue #874, closed uniformly).
  A C library cannot return "this buffer is null-terminated" as a proof;
  it returns the buffer and the proof is built in Bend. A JS callback
  cannot return "these types are equal." A host may return data, a
  handle, a kind, a callback that returns data, or an equation the checker
  can already close; never a path with distinct ends, a universe path, a
  dependent codomain or an empty type. Checked at the declaration and at
  every call that instantiates a type parameter. `issue_874*.bend`.
- **Template binder names cannot collide** (#905). `def cast(~T, ~x: T,
  ~T)` no longer typechecks as an unsafe cast. `issue_905.bend`.
- **A raw read of a shared node cannot be emitted** (#901). Any program
  over an indexed family (matrices, sized vectors, protocol states) that
  the C emitter's ownership analysis mishandles now runs or stops with an
  error; it cannot corrupt memory. The reporter's matrix product runs at
  every depth. `issue_901.bend`, `issue_853.bend`.
- **The interval decision procedure is mechanized** (`bend2/cubical.lean`).
  Stating its specification in Lean found that the first version decided
  a Boolean algebra, not the free De Morgan algebra the theory requires;
  the fix is proved sound and strictly finer. `demorgan.bend`.

## What it costs

| what | cost |
| --- | --- |
| a program with no path operation | none: same code, same speed (benches within 1%) |
| checking a proof with dimension variables | a table of at most 4^8 cases; real proofs have two or three atoms |
| a transport along an index proof | the identity |
| a transport along a list of equivalences | one map over the list |
| a transport along a function line | one wrapper |
| a universe path at runtime | a pair of closures, spent once or passed as a `~` template |
| a read of a `Data` node on the C lane | one predictable branch |

The one rule that shapes new code: a path between *types* is affine, like
the closures it holds. It constrains nothing that existed before.
