# The coinductive calculus and the braid fabric, carried to Bend and run

## What the object is (read from the corpus)

- **Interaction** (`Prasna`): `Q : X → Type`, `δ : (x : X) → Q x → X` — every
  state *asks*, the environment answers, the step consumes the answer. A
  history `IExec x` is now / receipt `now ≡ x` / answer / rest; the
  environment's bare contribution `Answers x` is answer / more.
  **`run-is-answers`: `IExec x ≃ Answers x`** — a history is exactly its
  answer stream, receipts weigh nothing (the interactive face of
  `trace-is-fiber`). **`silence-is-determinism`**: every question
  contractible ⇒ one history; the Turing machine is the interaction with
  nothing to ask (`Prashna`: receipts collapse the ISC to a point, a free
  event opens it, and the *event type* is what measures the gap).
- **Braid fabric** (`VeniBandha`, `AnantaVeni`): strands are coinductive
  streams of interdependent pairs `Sūtra = Bool × Bool`; a crossing σᵢ is the
  twisted swap with the quarter turn `(a,b) ↦ (¬b, a)`; every relation of
  every braid group holds at every position by a path of streams built field
  by field. Independent interactions commute (σᵢσⱼ, |i−j| ≥ 2); dependent
  ones cross (σᵢσᵢ₊₁σᵢ = σᵢ₊₁σᵢσᵢ₊₁).
- **On the net** these are the interaction rules themselves: a question with
  two answers is a superposition; the environment's answer is a dup; two
  questions on independent labels commute, two on the same label are
  correlated by the dup (below, measured).

## What is carried (`interaction.bend` 36 ✓, `braid.bend` 16 ✓)

Bend2 has no coinduction, so the coinductive records are carried at every
finite depth `n` (their ω-limit is exactly the corpus's
`ProductiveObservabilityBridge`: bisimilar = equal at every depth); on HVM
the unfolding is lazy, so any depth is reachable on demand.

| corpus | Bend | status |
|---|---|---|
| `IExec`, `Answers` | `IExec(X,Q,δ,n,x)`, `Answers(X,Q,δ,n,x)` (Σ-chains by recursion on `n`) | ✓ |
| `forgetStates`, `replay` | same | ✓ |
| `run-is-answers` | `runIsAnswers(n) : Equiv(IExec, Answers)` — a **coherent** equivalence (contractible fibres via `lemIso`), round trips by the same ∨-square that collapses a receipt onto refl | ✓ definitional |
| `silence-is-determinism` (closed machine) | `silenceIsDeterminism(f, n, x) : isContr(Answers …)` for `Q x = Unit` | ✓ |
| `veṇī∞`, `veṇī-sūtra`, `dūra-sūtra` | `veni(i, s)`, `veniRel(i, s, n)`, `duraRel(i, k, s, n)` — pointwise paths by the same induction (peel to the base at i = 0; head preserved, tail recurses) | ✓ definitional at every leaf |

## Run on HVM (`--to-hvm4-full`, values identical to the normaliser)

| observation | value | itrs |
|---|---|---|
| closed counter from 0, unique history replayed, `now` at step 2 | `2` | 114 |
| open machine from 1, answers `True,False,True` (`+1`, reset, `+1`), last state | `1` | 85 |
| open machine, answers `True,True,&L{True,False}` (the last answer a **superposition**) | `4` and `0` — two histories | 117 / 120 |
| answers `&L{…},True,&M{…}` (two **independent** labels) | `{0, 4, 2}` over four histories | 107–139 |
| answers `&L{…},True,&L{…}` (the **same** label: the dup correlates them) | `4` and `0` — two histories | 125 / 128 |
| braid: `σ₀σ₁σ₀` vs `σ₁σ₀σ₁` on the rope `n ↦ (even n, True)`, depth 0..3 | `(0,0)/(0,0)`, `(0,0)/(0,0)`, `(1,1)/(1,1)`, `(0,1)/(0,1)` — equal | 350–1163 |

The superposition rows are the thesis measured: a question is a
superposition, an answer is a dup, and whether two answers are independent
or one is decided by their labels — the net's own DUP-SUP rule.

## Checker changes this needed (in `cubical-paths.patch`)

- `rewrite` descends into the *head* of an application: after a Nat
  refinement a goal can sit as `(λp. body)(p)` (Soft whnf keeps the
  application when the body is a stuck match) and the matched Σ-variable
  lives inside `body`; previously only arguments were rewritten, so
  `match s: case (a, b)` never refined goals mentioning `f(…, s)`.
- conversion tries **same-head applications with convertible arguments**
  before unfolding: unfolding a recursive type family (a depth-indexed Σ) on
  a variable depth regressed forever, one fresh variable per level (the
  checker hung on `mute`).
