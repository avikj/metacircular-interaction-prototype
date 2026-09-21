# What the cubical core gives an engineer

`README.md` says what the port is and `REPORT.md` says how every line of
it works. This document says what it is *for*: what a Bend programmer can
now write that they could not, what can no longer go wrong, and what it
costs. Each point names the test in `tests/cubical/` that demonstrates it,
so every claim here is a program you can run.

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

## 1. Equality proofs compute

**Before.** `%e : P; f` ran only when `e` was literally `{==}`. A proof of
equality built any other way (by induction, by symmetry, by transitivity)
was accepted by the checker and dead at runtime: a program could not use it
to move a value from one type to the other.

**Now.** Any proof of `a == b` is a conversion that runs (`coe`, and J on
every path). `tests/cubical/j.bend`, `coe.bend`.

**Where it shows up.**
- *Index arithmetic.* A function over `Vec(n + 0)` and a value at `Vec(n)`:
  prove `n + 0 == n` once (Base has it), transport, and the transport
  compiles to the identity. Every dependently typed codebase is full of
  these mismatches; this is the difference between dependent types being
  usable and being friction.
- *Matrix and tensor shapes.* `Mat(r, c) * Mat(c, k) : Mat(r, k)`; a reshape
  from `(2*n, m)` to `(n, 2*m)` is a proof about arithmetic and the value
  moves without a copy. Shape-indexed kernels live here.
- *Protocol state machines.* `Conn(next(Handshake))` is `Conn(Established)`
  by a proof, so `send` accepts it with no cast and no runtime check.
- *Schema versions.* A row at version `v` and a proof `v + 1 == v'` cross
  without re-decoding.
- *Bit widths.* `Word(8 + 8)` is `Word(16)`; concatenating two bytes is a
  transport that compiles to nothing.
- *Runtime-computed sizes.* A buffer of `len(xs)` elements against a
  declared capacity: the proof they agree is the bounds check, done once,
  at the type.

## 2. Function extensionality

**Before.** Two functions that agree on every input were not provably
equal (upstream's `proof/no_funext_000` asserts exactly this). So a
refactored function could not be shown equal to the original, and every
theorem about the original had to be re-proved.

**Now.** Funext is a four-line path: `i => x => p(x)(i)`.
`tests/cubical/funext.bend`.

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

**Now.** `ua` turns an equivalence into an equality, and transport along it
runs the equivalence. `tests/cubical/ua.bend`, `ua_round.bend`,
`fibre.bend`, `compiled_coe.bend`, `compiled_path.bend`.

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
- *API versioning.* If v2 of a type is equivalent to v1 (renamed,
  reordered fields), clients verified against v1 are verified against v2.
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

**Now.** `path` constructors declare the relation; a `match` on the type
must supply the path arm, so a function out of the quotient is refused
unless it respects the relation. `tests/cubical/hit_quot.bend`,
`hit_circle.bend`, `hit_trunc.bend`, `hit_susp_torus.bend`,
`hit_mustfail_loop.bend`.

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

**Now.** A self-call under a constructor's delayed field, observed only
through dimensions, is productive; the definition is marked corecursive and
prints one unfolding. `tests/cubical/stream.bend`, `stream_mustfail.bend`.

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

**Now.** A function into an equation has its domain's kind: over `Data` it
is `Data`. `isContr`, `isEquiv`, `Equiv` are ordinary Base definitions.
The omega attack this could open is closed by positivity
(`tests/cubical/positivity_mustfail.bend`).

**Where it shows up.**
- *Reusable specifications:* a `sorted` predicate and its proofs passed to
  many consumers.
- *Equivalence libraries:* composition, inverses, the fibre law, all reuse
  proofs freely.
- *Certificates:* a proof that a hash matches or a bound holds, attached to
  a value and read by every pipeline stage.

## 7. Runtime transport on the native lanes

**Before.** Not applicable: nothing transported.

**Now.** A universe path compiles to its equivalence; `coe` along a
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
