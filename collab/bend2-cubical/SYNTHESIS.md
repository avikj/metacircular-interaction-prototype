# What this is, what it buys, and what is still unproved

A cold assessment, written after the coinduction and silence work landed.
Every number here is from a run recorded in this file's tables; the negative
results are kept deliberately.

## 1. The one structural claim

Cubical type theory has several good implementations (Cubical Agda,
cubicaltt, redtt, cooltt). In all of them the cubical apparatus is a
*checker* apparatus: `coe`, `hcomp`, `Glue` and the interval are consumed
during type-checking and are gone, or inert, by the time anything runs.

The closest prior art is **agda2hvm** (Matteo Meluzzi, TU Delft, June 2022,
supervised by Jesper Cockx and Lucas Escot), which compiles Agda to HVM and
is the obvious thing to compare against. It takes the erasing route by
construction, and necessarily so; see §7.

Here they are not. `--to-hvm4-full` emits the interval as data (`#I0`,
`#I1`, `#INot`, `#IAnd`, `#IOr`), paths as data (`#PLm`, `#UaU`, `#CompU`),
types as data (`#Pi`, `#Sig`, `#Path`, `#Glue`), and `@coe` dispatches on
the type former **at runtime**. Nothing is erased and nothing is
pre-normalised. The evaluator underneath is HVM4: an interaction net with
optimal reduction and native duplication/superposition.

So the identification the README asks for — trace = path = data = program =
execution = proof = transport — is not a slogan about the type system. It
is the runtime representation. A path is a value you can pass around. A
proof of equivalence is a function that moves data. Transport is an
ordinary reduction.

**The piece I think is genuinely new** is narrower and sharper than "cubical
on interaction nets":

> An `hcomp` whose faces are undecided does not fail and does not block. It
> is a first-class value, `#HCm{type, faces, base}`, that carries its own
> unresolved cube and resumes when something later supplies the interval.

Observed: `pcompH(...) @ #IVar{0}` evaluates to a stuck `#HCm` carrying its
faces; the same term at `#I0` is `#Zer` and at `#I1` the tube's top. That is
partial knowledge as a computational object, with the Kan conditions as its
correctness criterion — compute now with what is known, and the shape of
what is not known is a face. I am not aware of another runtime where
"undetermined" has that structure.

## 2. What is actually verified

| claim | evidence |
|---|---|
| Full Kan structure | `coe` for Π/Σ/Path/ua/Glue/composite lines, `hcomp` with face algebra, `hcomp` in `Set` reducing to `Glue` — in the checker and in the full runtime |
| Univalence computes | `uaG_beta` definitional for an *abstract* equivalence; coherent reverse round trip (`uaequiv.bend`, 17 ✓) |
| The lossless step | `A ≃ Σ B (fiber f)` as a coherent `Equiv`, `present`/`retrieve` run (`fibrelaw.bend`, 35 ✓) |
| Genuine coinduction | corecursive records and corecursive bisimulation paths, `[productive]` under `--total` (`coinduction.bend` 13 ✓, `streams.bend` 10 ✓) |
| Prasna, in general | `isContr(IExec x)` for any interaction with contractible questions, contraction a corecursive `PathP` over a path of states (`silence.bend` 25 ✓, runs to 4 on HVM) |
| The braid fabric | braid and distant-commutation relations pointwise (`braid.bend` 16 ✓) |
| Soundness probes | every theorem file has a must-fail sibling; the suite is 53 files, bad = 0 |

## 3. Measured: transport is paid once under sharing

A transport `coe(<i> ua(neg) @ i, i0, i1, False)` whose result is consumed
`k` times, on the full runtime. `shared` binds it once; `separate` writes
the transport `k` times.

| k | shared (itrs) | separate (itrs) |
|---|---|---|
| 1 | 143 | 142 |
| 2 | 150 | 285 |
| 4 | 167 | 574 |
| 8 | 213 | 1164 |
| 16 | 353 | 2392 |

Marginal cost of one more use: **14 interactions shared, 150 separate**. The
transport itself (~136) is paid exactly once regardless of `k`.

Honest framing: call-by-need gives this too. This measurement establishes
that keeping the cubical apparatus at runtime does *not* cost a rerun per
use — which is the thing that would have killed the approach — not that the
interaction net is doing something a lazy language could not.

## 4. Measured, negative: superposed transport is not cheaper

The fibre/DUP-SUP correspondence says a `coe` along a superposed line needs
**no rule**: the dispatch is a match, HVM commutes a match over `&L{}`, and
the same-label dup of the value annihilates. That is true, and the values
are right (`supline.bend` proves it definitionally; the runs below agree).

It is not, however, cheaper than doing the transports separately:

| N values along N lines | superposed | separate |
|---|---|---|
| 2 | 215 | 158 |
| 4 | 469 | 316 |

Both produce `&L0{1,1}` and `&L0{1,&L1{1,&L2{1,1}}}`. Superposed costs about
**1.4× more**. The reason is visible in the emitter: after the match
commutes, each branch re-enters `@coe` and re-runs the whole dispatch, so
nothing is shared except the initial destructuring.

So the correct statement of the DUP-SUP result is *semantic*, not
performance: fibre routing needs no cubical rule because the net already
does it. Anyone who wants it to also be fast must make the dispatch shared
across branches. That is the single clearest optimisation target in the
codebase.

## 5. Immediately realizable, ranked by value over effort

1. **Proof-carrying data migration.** `ua(e) : A = B` transported over a
   value *is* the migration, and it runs. The Glue rules mean φ-restricted
   (partial) migrations work too. Everything needed is in place; what is
   missing is a demo on a record type with more than two fields.
2. **Hot-swap by bisimulation.** Two corecursive machines and a proved
   bisimulation path; transport a mid-execution state along it. The shape
   is already `replayForget`, which collapses the receipt onto `refl`. This
   is process migration with a proof, and it is the most legible
   application of the coinduction work.
3. **Contractibility as an optimisation.** `silence-is-determinism` says
   that when the choice space is trivial the whole space of runs is a point.
   The checker can see this. Operationally that licenses collapsing an
   entire interaction to a value — a deterministic-collapse pass justified
   by a theorem rather than by analysis.
4. **Speculation on undecided faces.** Build on the stuck `#HCm`: compute
   under a face nobody has decided, decide it, watch the dead branches drop.
   This is the item with the least precedent and the most risk.
5. **Shared dispatch across superpositions.** See §4. Concrete, bounded,
   and it converts the DUP-SUP story from semantic to computational.

## 6. What is not proved

- **No metatheory.** There is no canonicity or normalisation theorem for
  this layer. The Kan rules were implemented and tested against a must-fail
  suite, not proved sound. This is the largest gap by a wide margin, and
  nothing above should be read as if it were closed.
- **Totality is a gate, not a typing rule.** `--total` classifies; the
  ungated checker accepts `cheat`. Productivity is checked by a syntactic
  guardedness pass, which is weaker than Agda's `--guardedness` in ways I
  have not characterised.
- **Conversion is one-step unfolding.** Bisimilarity is proved, never
  decided. Some equalities that Agda accepts definitionally need an explicit
  path here.
- **Scale is untested.** The largest file is under a hundred definitions.
  `epNormCtx` unfolds one level deep specifically to stop a loop; whether
  that is the right depth at scale is unknown.
- **No performance comparison against a real system.** The interaction
  counts above are internally comparable and nothing more.

## 7. Prior art: agda2hvm, and why it does not overlap

`github.com/matteo-meluzzi/agda2hvm` — Meluzzi, TU Delft BSc thesis, 17 June
2022, supervised by Jesper Cockx (Agda core developer) and Lucas Escot. It
compiles Agda to HVM. Read in full before writing this section.

**What it does.** It is a backend on Agda's own compiler API. It consumes
Agda Treeless Syntax via `Agda.Compiler.toTreeless`, which the thesis
describes plainly as available "at the cost of losing the information about
types and names". Postulates compile to nothing. It targets HVM1: integers
are 32-bit, floats are a parse error, there is no FFI. Benchmarked against
the state-of-the-art Agda backends it ranges, in the author's own summary,
from exponentially faster to exponentially slower.

**What it does not do.** The thesis contains no occurrence of *cubical*,
*transp*, *hcomp*, *Glue*, *univalence*, or *interval*. That is not an
oversight. `toTreeless` hands a backend a term whose types are already gone,
so a backend built on it cannot keep the cubical apparatus alive even in
principle — there is nothing left to keep.

**Why this matters here, in both directions.**

- It is genuine prior art for *a dependently typed language running on an
  interaction net*, and §1's claim is scoped accordingly: the novel part is
  not Agda-or-Bend on HVM, it is declining to erase.
- It retroactively justifies the route this project took. The natural first
  idea — put the Agda corpus on HVM directly through Agda's backend API —
  cannot work for Cubical Agda, because that API's entry point is an
  already-erased term. Keeping `coe`, `hcomp`, `Glue` and the interval as
  runtime values requires a compiler whose source representation still
  contains them. Going through Bend2 was necessary, not a detour.
- The two answer different questions and are complementary. agda2hvm asks
  how fast erased dependently typed code runs on interaction nets. This asks
  what you get if you keep the proof apparatus at runtime, and §3 answers
  the first objection: you do not pay a rerun per use.
- Its headline benchmark result is a caution for §3 and §4. HVM's asymptotic
  advantage is strongly workload-dependent, which is consistent with the
  negative result measured here on superposed transport.
