# `runtime/kernel` — the trusted heart

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

Implements CRYSTAL.md §2 **L0** (exact identity), **L1** (typed edges), **L2**
(proof-relevant e-graph) and §5 (the small trusted checker, L5).

**This file is a contract.** Other layers code against the signatures and the
guarantees below. If a guarantee here is wrong, that is a kernel bug and it is
the kernel's job to fix it — not the caller's job to work around it.

```
term   (L0)   exact identity: hash-consed typed terms, content addressing
  ↓
edges  (L1)   the typed edge algebra: composition, preservation, exact ε
  ↓
check  (L5)   the trusted checker: witnesses, proof paths, composites
  ↓
egraph (L2)   union-find + congruence closure + proof forest + retraction
```

Imports run strictly downward. `check` does not import `egraph`: **the checker
can validate a proof without consulting, importing, or trusting the e-graph
that produced it.** No candidate can rewrite the kernel that judges it.

### Hard constraints, enforced

| constraint | how |
|---|---|
| CPU-only, pure stdlib | imports are `hashlib`, `dataclasses`, `fractions`, `collections`, `typing` |
| no floating point | no `float` is constructed; `Edge` raises `EdgeError` on a float ε |
| exact | integers and `fractions.Fraction` only |
| deterministic | addresses use `blake2b`, never salted `hash()`; every iteration is over `sorted()` or an insertion-ordered list |
| step counters | `term.COUNTERS`, `EGraph.steps`, `CheckContext.counters` — all `Counters` |

Determinism is tested: three runs of the suite, including one under
`PYTHONHASHSEED=12345`, are byte-identical.

```python
import sys; sys.path.insert(0, "<repo root>")
from runtime.kernel import term as T, edges as E, check as C
from runtime.kernel.egraph import EGraph
```

---

## L0 — `term.py`

### The IR, and why this one

The IR is a **simply-typed lambda calculus over opaque constants, with bound
variables as de Bruijn indices**: `Var | Const | App | Lam`.

Why not a first-order, binder-free core? Because L1 needs `Iso` edges to carry
*invertible witnesses* and L3 needs isos to become transports. A witness is a
function; a function needs a binder; a binder that the kernel cannot apply is
not a witness the kernel can check. With `Lam` plus `beta_normal`, the checker
verifies an `Iso` by *actually running the round-trip* (§L5 below) instead of
believing a label. That is the difference between a checked edge and an
asserted one, and CRYSTAL §5 puts checking inside the trusted heart.

Why de Bruijn rather than named binders? **L0 identity forces it.** The spec
requires "identical addresses ⇒ identical construction, always". Under named
binders `λx. f x` and `λy. f y` are the same construction with two
presentations, so a name-carrying address would either (a) hash the bound name
and hand out two addresses for one construction, or (b) hash a canonical
renaming — which is de Bruijn with extra steps. De Bruijn makes α-equivalence
*definitional*: the two terms are one interned object, `is`-equal, one address,
and there is no α-conversion step anywhere in the kernel to get wrong.
`Const` symbols do appear in addresses, but a `Const` is an opaque atom whose
symbol *is* its identity — it is not a view name. View names live in
`NameTable` and never touch an address.

Sorts are simple: `base_sort(name)` and `arrow(dom, cod)`. This is deliberately
weaker than the spec's eventual ambitions (no dependent types, no universes,
no polymorphism); see *Not implemented* at the end.

### Addresses

```
addr(t) = blake2b_128( head_symbol(t) ‖ addr(sort(t)) ‖ addr(c₁) ‖ … ‖ addr(cₙ) )
```
32 lowercase hex characters. `head_symbol` is `b"var:<i>"`, `b"const:<sym>"`,
`b"app"` or `b"lam"`; for `Lam` the domain sort's address is prepended to the
children. The address embeds the whole dependency structure and nothing else.

### API

| call | returns | notes |
|---|---|---|
| `base_sort(name: str)` | `Sort` | interned; `base_sort("N") is base_sort("N")` |
| `arrow(dom: Sort, cod: Sort)` | `Sort` | interned |
| `Var(index: int, sort: Sort)` | `Term` | de Bruijn, `index ≥ 0`, 0 = innermost |
| `Const(symbol: str, sort: Sort)` | `Term` | opaque atom |
| `App(fn: Term, arg: Term)` | `Term` | **raises `SortError`** unless `fn.sort = arg.sort → b` |
| `Lam(dom: Sort, body: Term)` | `Term` | **raises `SortError`** if `body` demands index 0 at a sort ≠ `dom` |
| `lookup(addr) -> Term \| None` | | the intern table |
| `subterms(t) -> tuple[Term, …]` | | children before parents, each once, deterministic |
| `shift`, `subst_top`, `subst_consts` | `Term` | capture-avoiding |
| `beta_normal(t, fuel=100000) -> Term \| None` | | normal order; `None` on fuel exhaustion |
| `intern_table_size() -> (int, int)` | | `(sorts, terms)` |

`Term` fields: `addr`, `head` (`"var"`/`"const"`/`"app"`/`"lam"`), `sort`,
`children`, `index`, `symbol`, `dom`, `demands`, plus `is_closed`,
`pretty()`, `short()`, `recompute_addr()`.

**Guarantees.**

1. **`is` is equality.** Two `Term`s from this module are the same object iff
   they have the same address iff they are the same construction. Never compare
   terms with `==` on structure; use `is` or `.addr`.
2. **Ill-sorted terms do not exist.** Construction is the typecheck. There is
   no separate "check this term" pass and no way to hold an ill-sorted `Term`.
3. **Openness is tracked exactly.** `t.demands` is the sorted tuple of
   `(dangling de Bruijn index, required sort)`. `t.is_closed` iff it is empty.
   An index used at two different sorts in one term is rejected at build time.
4. **Addresses are permanent.** `reset_all()` clears names and counters and
   deliberately does **not** clear the intern tables.
5. **`recompute_addr()` is a from-scratch rebuild**, used by the checker so it
   never has to believe the intern table. Cost is linear in *tree* size.

### Names are views

```python
T.bind("double", t)          # name -> address
T.resolve("double")          # -> addr | None
T.names_of(addr)             # -> tuple of every name bound to it, sorted
T.name_of(addr)              # -> the lexicographically first, or None
T.NAMES.unbind("double")
```

Many names may point at one address. One name may be rebound to a different
address; the old address keeps its other names, stays reachable by `lookup`,
and is *not* the new one. **Nothing in the kernel ever resolves a name to make
a decision.** Names exist so humans and reports can read output.

### Counters (`term.COUNTERS`)

`term.hash`, `term.build`, `term.sortcheck`, `term.intern_hit`,
`term.intern_miss`, `sort.intern_hit`, `sort.intern_miss`, `term.lookup`,
`term.shift`, `term.subst`, `term.subst_const`, `term.beta`,
`term.normalise`, `term.normalise_fuel_out`, `name.bind`, `name.resolve`,
`name.reverse`.

`Counters` API: `bump(k, n=1)`, `get(k)`, `k in c`, `keys()`, `snapshot()`
(sorted tuple of pairs), `delta(snapshot)`, `render()`, `reset()`.

---

## L1 — `edges.py`

Ten kinds: `Eq Iso Embed Quotient Implies Approx Refine Interp Dual Conjecture`.
Symmetric: `Eq`, `Iso`, `Dual`.

```python
E.Edge(kind, src: addr, dst: addr, eps=None, pairing=None,
       witness=None, label="", provenance=())
```
Frozen dataclass. `edge_id` is derived deterministically from the content if
not supplied. `__post_init__` raises `EdgeError` on: an unknown kind; a float
ε; `Approx` without an exact `Fraction` ε; a negative ε; an ε on a non-`Approx`;
a `pairing` on a non-`Dual`.

### The composition table

`compose_kind(l, r) -> str | None`, `compose(e1, e2) -> Edge | None`,
`compose_path(edges) -> Edge | None`, `invert(e) -> Edge | None`.
`composition_table()` returns all 100 ordered pairs. **39 licensed, 61 `None`.**

| L \ R | Eq | Iso | Emb | Quo | Imp | Apx | Ref | Int | Dua | Cnj |
|---|---|---|---|---|---|---|---|---|---|---|
| **Eq** | Eq | Iso | Emb | Quo | Imp | Apx | Ref | Int | Dua | . |
| **Iso** | Iso | Iso | Emb | Quo | Imp | Apx | Ref | Int | Dua | . |
| **Emb** | Emb | Emb | Emb | . | . | . | . | . | . | . |
| **Quo** | Quo | Quo | . | Quo | . | . | . | . | . | . |
| **Imp** | Imp | Imp | . | . | Imp | . | . | . | . | . |
| **Apx** | Apx | Apx | . | . | . | Apx | . | . | . | . |
| **Ref** | Ref | Ref | . | . | . | . | Ref | . | . | . |
| **Int** | Int | Int | . | . | . | . | . | Int | . | . |
| **Dua** | Dua | Dua | . | . | . | . | . | . | Iso | . |
| **Cnj** | . | . | . | . | . | . | . | . | . | . |

Reading of the spec's "composes with" column: **`Eq` is the two-sided identity
and `Iso` is absorbed by every directed kind.** That reading is forced by the
two composites the spec spells out — `Approx ∘ Iso = Approx` with the same ε,
and `Implies ∘ Iso = Implies`. Every cross-kind pair the kernel has no name for
is `None`; it refuses rather than inventing a label. Beyond the table,
`compose` also returns `None` when:

* `e1.dst != e2.src` (endpoints do not meet);
* `Dual ∘ Dual` where the two edges name **different** `pairing`s. Double
  dualisation is the identity up to iso only with respect to *one* pairing;
  two different pairings license nothing. `Dual ∘ Dual` with equal pairings
  yields `Iso`.

`Conjecture` is blocked twice over, and both defences are separately tested:
an explicit guard in `compose_kind` (which bumps `edge.conjecture_blocked`),
and the total absence of a `Conjecture` row or column from the table.

**ε is exact.** `Approx ∘ Approx` adds ε as `Fraction`. `Approx ∘ Iso`,
`Iso ∘ Approx`, `Approx ∘ Eq`, `Eq ∘ Approx` carry ε through unchanged.

### Preservation

`preserves(kind) -> frozenset`, `Edge.preserves`. A composite preserves the
**intersection** of its parts' sets — the only lattice in the kernel.

| kind | preserves |
|---|---|
| `Eq` | everything (all 9 tags) |
| `Iso` | everything except `presentation` |
| `Embed` | `injectivity`, `truth` |
| `Quotient` | `task_sufficiency` |
| `Implies` | `truth` |
| `Approx` | `bounded_error` |
| `Refine` | `extensional` |
| `Interp` | `semantics`, `truth` |
| `Dual` | `pairing` |
| `Conjecture` | nothing |

`Eq` minus `Iso` is exactly `{presentation}`: that single tag is the L0/L1
distinction the spec insists on — an iso preserves all the mathematics and none
of the address.

Counters: `edge.build`, `edge.compose`, `edge.compose_kind`, `edge.invert`,
`edge.compose_unlicensed`, `edge.compose_endpoint_mismatch`,
`edge.conjecture_blocked`.

---

## L5 — `check.py`

Small on purpose: 305 lines, of which 189 are statements and the rest is the
trust statement and the witness declarations. **Read the module docstring; it
lists the trust assumptions exhaustively (T1–T4).** Summary:
it trusts blake2b, `term.py`'s encoding/sorts/substitution (which CRYSTAL §5
places inside the heart), the caller's declared axioms and certificates, and
Python's exact arithmetic. It trusts **nothing** from the e-graph.

### Witnesses

| witness | the checker does what |
|---|---|
| `Refl()` | requires `src == dst` |
| `Axiom(name)` | looks `name` up in `ctx.axioms`, recomputes both sides' addresses, requires the step's endpoints to be exactly those two (either order) |
| `Beta()` | normalises **both** endpoints itself and requires identical normal forms; `None` on fuel exhaustion ⇒ reject |
| `Instantiate(name, subst)` | applies `subst` (symbol → `Term`) to the axiom's sides itself, sort-checking, then compares addresses |
| `Certificate(name)` | for non-equational L1 edges only: matches kind, endpoints and (for `Approx`) exact ε against `ctx.certificates` |
| `IsoWitness(to, fro)` | sort-checks `to : A→B`, `fro : B→A`, both closed; normalises `to(a)` and requires it to equal `b`, and `fro(b)` to equal `a`; then round-trips `fro(to(p))` and `to(fro(q))` on **fresh probe constants** and requires the identity |
| `Conjectural(label)` | **always rejected**, and counted |

### Steps and paths

```python
C.Step(src: addr, dst: addr, kind: "assumption"|"congruence",
       witness=None, edge_id=None, subproofs=())
```
A `congruence` step's `subproofs` is one proof path per argument position. The
step is self-contained: the checker recurses into the subproofs rather than
asking anyone what the arguments' equality was.

```python
ctx = C.CheckContext()                  # axioms={}, certificates={}, fuel=100000
ctx.declare_axiom(name, lhs: Term, rhs: Term)     # sorts must agree
ctx.declare_certificate(name, kind, src, dst, eps=None)

C.check_step(step, ctx)            -> bool
C.check_path(steps, src, dst, ctx) -> bool
C.check_edge(edge, ctx)            -> bool
C.check_composite(edges, ctx)      -> Edge | None
```

`check_path` verifies, in order: endpoints match the claim; the chain is
contiguous; every step is independently valid. An empty path proves only
reflexivity. `check_composite` checks every edge and *then* composes, so a
`Conjecture` anywhere annihilates the whole composite.

On rejection the reason is appended to `ctx.errors` and `check.reject` is
bumped. Counters: `check.step`, `check.path`, `check.edge`, `check.composite`,
`check.resolve`, `check.axiom`, `check.beta`, `check.instantiate`,
`check.congruence`, `check.certificate`, `check.iso`, `check.reject`,
`check.conjecture_rejected`.

---

## L2 — `egraph.py`

```python
g = EGraph()
g.add(term)                                  -> addr        # registers all subterms
g.merge(x, y, justification, edge_id=None)   -> edge_id
g.find(x) / g.equal(x, y) / g.class_of(x) / g.classes()
g.explain(x, y)                              -> tuple[Step, …] | None
g.explanation_classes(x, y, limit=None, max_paths=None,
                      max_depth=None, max_classes=None)
                                             -> ClassEnumeration   # NOT a tuple
g.explanations(x, y, limit=None, **kw)       -> ClassEnumeration   # alias
g.path_class_key(path, memo=None)            -> tuple[tuple[atom, int], …]
g.justifications(x, y)                       -> tuple[MergeRecord, …]
g.records()                                  -> tuple[MergeRecord, …]
g.retract(edge_id)                           -> bool
g.add_directed(edge: E.Edge)                 -> int
g.reachable(x, y, max_depth=8)               -> E.Edge | None
g.steps                                      -> Counters
```
Every method taking a node accepts a `Term` or an address `str`. A `Term` is
auto-registered; an unregistered address raises `EGraphError`.

### Merging

`merge` accepts a `check` witness (`Refl`, `Axiom`, `Beta`, `Instantiate`).

* A `Conjectural` witness **raises `EGraphError`** — a conjecture must not be
  able to merge a class, and the refusal is at the door, not downstream.
* Merging terms of different sorts raises `SortError`.
* Duplicate `edge_id` raises `EGraphError`.
* Congruence closure runs to fixpoint after every merge. If `f(x)` and `f(y)`
  are registered and `x = y` merges, then `f(x) = f(y)` merges with a
  `congruence` justification.

Congruence signatures are `("app", find(fn), find(arg))`, `("lam", dom.addr,
find(body))`, `("leaf", addr)`.

### The proof forest, and why it is not a union log

Justifications live in a **second parent array** (`_pf` / `_pf_rec`), separate
from the union-find. On union, the path from `a` to its proof root is
**reversed** so `a` becomes a root, then `a` is hung under `b` carrying the
record (Nieuwenhuis–Oliveras). `explain(a, b)` walks both nodes to their nearest
common proof ancestor and reads off the records. Cost is proportional to the
proof-forest distance, **not** to the number of unions ever performed, and
nothing anywhere iterates a flat list of unions to explain something.
Union-find path compression is still used and is harmless: proofs are not
stored there.

### How distinct paths are stored (the automorphism requirement)

**Every `merge` call appends a `MergeRecord`, including calls that merge an
already-equal pair.** Those extra records are *chords*: the proof forest is a
spanning structure over the justification graph, and the chords are the extra
routes. Nothing is collapsed and nothing is discarded.

* `explain(a, b)` — the **cheap canonical** path (one route, forest distance).
* `explanation_classes(a, b)` — the **homotopy classes** of proofs, one
  representative each, as a guarded `ClassEnumeration`. `explanations` is an
  alias kept for callers.
* `justifications(a, b)` — every record directly relating the pair. Exactly one
  has `applied == True` (the spanning edge); the rest are the chords.

### Distinct up to homotopy (the fix for `STATUS.md` failure mode #1)

Raw simple paths over-count: the same proof, reassociated, is not a second
transport. Two paths are **equivalent** when one becomes the other under moves
the kernel performs with no mathematical input — congruence/symmetry/
transitivity reassociation, `Refl`, `Beta`. The invariant of that move set is
the **multiset of axiom justifications** consumed, and that multiset (with the
endpoints) is the canonical form:

```
axiom_atom(Axiom | Instantiate | Certificate) = an atom     # caller's input
axiom_atom(Refl | Beta | congruence)          = None        # kernel-decidable
atoms(congruence record) = the atoms of its arguments' proofs   # recursively
```

So two independent axioms merging one pair give **2** classes, while the
naturality square of β against congruence (`(λx.x)a = (λx.x)b` by congruence,
or by β·axiom·β) gives **2 raw paths and 1 class**. Both are tested, in both
directions: over-merging and over-splitting each have a planted-false control.

**Bounds are not caps.** Enumeration is total up to `max_paths` / `max_depth` /
`max_classes`; hitting one produces `complete == False` with the reason
carried. **A hit `max_depth` prunes the branch, not the search**: the round
abandons that branch, its siblings are still explored, and the classes that fit
inside the bound are still reported (as an *incomplete* result). Raw paths are
walked by iterative deepening — shortest first, with a branch cut as soon as the
breadth-first distance to the target no longer fits the round's budget — so a
short class hidden behind a deep branch is found, and a spent `max_paths`
budget has been spent on the *short* proofs. `ClassEnumeration` is **not a list**: while incomplete, `len()`,
iteration, `.classes` and `== ()` all raise `IncompleteEnumeration`. The
partial content is reachable only through the explicitly-named `.partial()`, so
a subset can be *accepted*, in writing, but never *mistaken* for a total
answer. `.count_or_none()` is the sentinel form.

`ProofClass` fields: `key`, `src`, `dst`, `multiset`, `axioms`, `size`,
`representative` (a checkable `Step` path), `raw_paths`, `members`.
`ClassEnumeration` fields: `complete`, `reason`, `bounds`, `raw_paths`,
`explored`, plus `.classes` / `.paths` / `.partial()`.

`explain` remains the query for the hot path; `explanation_classes` is the query
for "how many genuinely different transports are there", and L4
(`runtime/propagate`) reuses exactly this quotient to decide which consequences
survive a retraction.

`MergeRecord` fields: `mid`, `kind` (`"assumption"` / `"congruence"`), `a`, `b`,
`witness`, `edge_id`, `deps` (frozenset of assumption edge ids this record rests
on), `applied`.

### Directed edges never merge

`add_directed` refuses `Eq` (equalities belong in `merge`) and stores everything
else in a separate labelled digraph. **This includes the symmetric `Iso` and
`Dual`**, which are stored in both directions but still not unions: an iso
relates two *different presentations*, and collapsing their L0 addresses would
undo L0. Only `Eq` merges classes.

`reachable(x, y)` is breadth-first over the digraph in ascending edge index,
composing with `edges.compose` at each hop and pruning on `(class, kind, ε)`.
Movement inside an e-class is free and typed `Eq`, so directed edges compose
across proved equalities. It returns the composite `Edge` or `None`. It never
touches the union-find, and `explain` cannot see the digraph — a `Quotient`
can never produce an equality.

### Retraction

`retract(edge_id)` returns `False` (a no-op, no rebuild) if no live record
depends on the id. Otherwise:

1. **cone** = every record with `edge_id` in its `deps`, plus the full e-classes
   containing their endpoints;
2. drop the dependent records, and drop congruence records inside the cone
   (they are re-derived, not trusted);
3. reset only the cone's union-find, proof forest and class caches;
4. **replay the surviving assumption records** inside the cone, in id order;
5. re-run congruence closure over the cone and its upward parent closure.

**Guarantee — locality.** Classes outside the cone are not recomputed to an
equal value, they are *untouched*: `class_of(z)` returns the **same tuple
object** before and after. Test with `is`, not `==`. This is asserted in the
suite for every class outside the cone.

**Guarantee — survival.** An equality merged by two independent justifications
survives the retraction of either one, with a valid `explain` afterwards, and
vanishes when both are retracted, taking its congruence consequences with it.

**Known conservatism.** `deps` records *one* sufficient set of assumptions — the
one on the proof path at the moment the record was made — not the minimal one.
So a retraction may rebuild a slightly larger cone than strictly necessary. It
never rebuilds a smaller one: any record that used the retracted edge is in the
cone by construction, and the replay re-derives whatever survives.

### Counters (`EGraph.steps`)

`add`, `merge_calls`, `unions`, `congruences`, `find`, `find_hop`,
`reroot_hop`, `signature`, `explain_steps`, `path_enum`, `atom_expand`,
`class_enum`, `class_incomplete`, `retract_calls`, `rebuilds`,
`directed_edges`, `reach_steps`, `conjecture_refused`.
`g.report()` renders them sorted.

---

## Worked example

```python
from runtime.kernel import term as T, check as C
from runtime.kernel.egraph import EGraph

N  = T.base_sort("N"); NN = T.arrow(N, N)
f  = T.Const("f", NN); a = T.Const("a", N); b = T.Const("b", N)
fa, fb = T.App(f, a), T.App(f, b)

ctx = C.CheckContext()
ctx.declare_axiom("route1", a, b)
ctx.declare_axiom("route2", a, b)          # a second, independent reason

g = EGraph(); g.add(fa); g.add(fb)
g.merge(a, b, C.Axiom("route1"), edge_id="E1")
g.merge(a, b, C.Axiom("route2"), edge_id="E2")

g.equal(fa, fb)                            # True, by congruence
path = g.explain(fa, fb)                   # one congruence step + subproofs
C.check_path(path, fa.addr, fb.addr, ctx)  # True — checked without the e-graph
len(g.explanation_classes(a, b))           # 2 — two homotopy classes

g.retract("E1"); g.equal(a, b)             # True  — route2 carries it
g.retract("E2"); g.equal(fa, fb)           # False — and the congruence went too
```

Counters for exactly that script (`explain`+`check` before and after one
retraction), reproduced byte-identically by the test suite:

```
egraph : add=7 congruences=2 explain_steps=12 find=48 find_hop=11
         merge_calls=3 rebuilds=1 reroot_hop=5 retract_calls=1
         signature=12 unions=5
check  : check.axiom=2 check.congruence=2 check.path=6
         check.resolve=8 check.step=4
term   : term.build=8 term.hash=80 term.intern_hit=8 term.lookup=8
         term.sortcheck=6
```

---

## Testing

`python3 runtime/tests/test_kernel.py` — 20 capability tests and 13
planted-false controls; exits nonzero on any failure. Per `collab/PROTOCOL.md`
§7, every capability is paired with a control that must fail.

The suite was itself validated by mutation: **13 deliberate kernel defects were
injected and all 13 were caught** (dropping the sort from a `Const` address,
disabling the `App` sort check, licensing `Conjecture` composition with and
without a table row, discarding chord justifications, retracting the world
instead of the cone, believing undeclared axioms, letting directed edges merge,
skipping proof-forest rerooting, disabling congruence closure, skipping
congruence subproof checks, skipping path contiguity, and not adding ε).  The homotopy quotient added in the L4 lane carries its own
mutation set in `runtime/propagate/README.md` §5: 12 further defects, all dead.

---

## Not implemented (designed, not built)

Honest boundaries. Callers must not assume any of this works.

* **Sorts are simple.** No dependent types, universes, polymorphism, or
  inductive families. An `Iso` between two *sorts* cannot be stated — only
  between two terms.
* **η is not a kernel equality.** `beta_normal` is β only. `λx. f x` and `f`
  have different addresses and are not merged unless you assert it.
* **No rewriting / e-matching / extraction.** L3 (execution, cost vectors,
  nondominated routes) is absent. The e-graph stores and explains; it does not
  optimise. L4 is built, in `runtime/propagate/`, on top of this file's
  homotopy quotient.
* **No anti-unification.** §3.1 crystallisation has no kernel support yet.
* **Reachability discipline (§4)** — generated locus, omitted locus, completion
  — is not represented at all.
* **Class enumeration can be exponential.** It is now a complete "find all
  distinct transports" oracle *up to a stated bound*, and says so when the bound
  bites — but the cost of completeness is unchanged, because the class count
  itself can be exponential (and legitimately so).
* **Certificates are trusted.** For `Quotient`, `Embed`, `Implies`, `Approx`,
  `Refine`, `Interp`, `Dual`, the checker verifies that a matching certificate
  was *declared*, not that the mathematics holds. Only `Eq` (proof paths),
  `Iso` (round-trip normalisation) and `Beta` are genuinely machine-checked.
  Widening `ctx.certificates` is the only way to widen what the kernel believes,
  which is why it is a caller-supplied dict and not a global.

### What breaks first under load

1. **Class enumeration cost.** The silent-subset bug is gone — the homotopy
   quotient is the semantics and an exhausted bound is an explicit
   `IncompleteEnumeration` — and the depth bound now backtracks instead of
   aborting, so a bounded run returns the short classes rather than nothing.
   What remains is cost: the enumeration still walks raw simple paths before
   quotienting them, so a dense justification graph is exponential in *work*
   even when the class count is small. Iterative deepening pays a re-walk of
   the shallow prefix once per round (bounded by the distance prune, and skipped
   entirely when a round prunes nothing). Quotienting during the walk
   (dominance pruning on the partial multiset) is the next move.
2. **`merge`'s duplicate-id scan** is `O(records)` per call, making *n* merges
   `O(n²)`. It wants an id index. Nothing else in `merge` is superlinear.
3. **Retraction cone width.** Step 5 walks the *transitive upward parent
   closure* of the cone. In a term DAG with heavy sharing (one constant used
   everywhere) retracting anything about that constant dirties nearly the whole
   graph, and "local rebuild" degrades to "rebuild the world". The locality
   guarantee remains true — it is the cone that gets big, not the code that gets
   wrong — but the performance claim would not survive a shared-atom workload.
4. **`recompute_addr()` is tree-recursive**, not DAG-memoised, so the checker is
   exponential in sharing depth on deeply shared terms. Memoising it is easy and
   deliberately not done yet: it is in the trusted file, and the trusted file
   stays obvious until profiling says otherwise.
5. **Python recursion limits** bound term depth (`shift`, `subst`, `_nf`,
   `subterms`, `explanations`' DFS) to a few thousand levels.

---

## Contract changes

This section exists because other lanes code against this file, and a silently
edited document is indistinguishable from a document that was always right.
Each entry says what the signature *was*, what it *is*, and why it moved.
Nothing here is retroactive: a caller written against an old row will fail
loudly (a wrong type or a raised `IncompleteEnumeration`), never quietly.

| # | when | symbol | was | is | why |
|---|---|---|---|---|---|
| C1 | L4 lane (Part A) | `EGraph.explanations` | `explanations(x, y, limit=8) -> tuple[tuple[Step, …], …]` — raw simple paths, **silently truncated** at `limit` | `explanations(x, y, limit=None, **kw) -> ClassEnumeration`, an alias for `explanation_classes` | Raw simple paths over-count proofs (reassociation is not a second transport) and a silent cap is not a semantics. `STATUS.md` failure mode #1. The return type is now guarded: while `complete` is false, `len()`, iteration, `.classes` and `== ()` raise `IncompleteEnumeration`, and the subset is reachable only through `.partial()`. `limit` survives as an alias for `max_classes`. |
| C2 | repair lane | `EGraph.explanation_classes` | on hitting `max_depth` the depth-first walk set a **global** stop flag: the first over-deep branch ended the entire enumeration, and a graph with a 15-axiom geodesic behind a 300-record chain returned nothing usable (filed by L3 against a 533-record graph, reported as a single 240-step class) | the depth bound **prunes that branch and backtracks**; rounds go shortest-first (iterative deepening with a breadth-first distance cut), so the short classes are the ones a spent budget has bought | A depth-bounded search must explore the space, not die on the first deep branch. Soundness was never the issue and is unchanged: a run that pruned anything still reports `complete=False` with the count of pruned branches in `reason`. Tests `A7`/`A8` and the control `x_depth_pruned_not_complete` in `runtime/tests/test_propagate.py` pin it. |
| C4 | repair lane | **new module `kernel/bounded.py`** | the bounded-search discipline (prune-the-branch, iterative deepening, bucket under `max_classes`/`max_paths`, report what bound bound) lived only inside `EGraph.explanation_classes` | it lives in `kernel/bounded.py` — `resolve_bounds`, `bounds_tuple`, `SearchLedger`, `ClassBuckets`, `deepen` — and both `egraph.explanation_classes` and `propagate.invalidate.justification_classes` call it | The same defect (a depth bound that aborted globally instead of backtracking) was found and fixed **twice, in two files**, which is evidence of a missing abstraction rather than of two careless authors. `explanation_classes`'s behaviour is byte-for-byte unchanged by the move: `runtime/demo/geodesic_demo.py`'s output and every counter in the kernel suite are identical before and after. Nothing trusted imports it — `check.py` imports neither `egraph` nor `bounded`. |
| C3 | repair lane | `ProofClass.representative` | the raw path with the lexicographically smallest record-id sequence | the **shortest** raw path in the class (ties broken by that same sequence) | The representative is what a caller checks and reads as "the proof"; handing back a long realisation of a short class was gratuitous. `members` is unchanged (still sorted by record-id sequence), so nothing that indexed it moves. |

Two things deliberately did **not** change, and should not be changed without
an entry here: `explain` still returns the cheap canonical proof-forest path
(it is not a metric — see `STATUS.md` defect 3 and L3's `RouteFinder`), and
`ClassEnumeration` still refuses to present a partial answer as a complete one.
