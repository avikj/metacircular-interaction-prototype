# Draft 8 — HoTT/UF 2027 abstract (deadline ~March 2027; verify at hott-uf.github.io)

Format: 1–2 pages not including references, PDF via EasyChair, intended
speaker named on submission (2026 rules). Object B, plus the coinductive
result and the geodesic — the parts of the corpus a HoTT audience will
not call textbook.

---

## Losslessness is a property: forced completions, interactive coalgebras, and a geodesic, in Cubical Agda

**[Author]**

Start from the fibre law: for `f : A → B`, `A ≃ Σ (b : B), fib f b`
(HoTT book §4.8). We use it as the primitive of a machine calculus and
report three consequences that we could not find in the literature and
would be glad to be pointed to.

**1. The completion of a machine step is unique.** Call a *completion* of
`f` an extension of its codomain that retains what `f` forgets and
retracts onto `f`. Define `Lossless f` as the type of such completions.
For the universal step `uStep : Machine → Machine` of the calculus,
```
machine-lossless-unique : isContr (Lossless uStep)
```
so losslessness is a *property* of the step, not extra structure on it,
and the canonical completion `canonical-lossless` is the only one.
Consequently, with `complete≃ : Machine ≃ Σ Machine (fiber uStep)`, the map
`decide` (run the step, keep the witness) and the map `verify` (project
the witness back) are the two directions of one equivalence, and
`witness-self-certifies : snd (snd (decide mc)) ≡ refl`. The module's
header says what this is not: "a step-count separation theorem in some
external succinct measure". It is the statement that, over the lossless
machine, finding and checking are projections of one thing.

**2. Interaction as a coalgebra whose run is its answer stream.** An
`Interaction` is a coalgebra with a query type at each state; `IExec` is
its depth-indexed execution and `Answers` the corecursive stream of
answers; `run-is-answers` is a coherent equivalence between them (both
round trips as corecursive paths, under `--guardedness`). The result:
```
silence-is-determinism : contractible query type at every reachable state
                       → isContr (IExec x)
```
stated as a sufficient condition (not an iff). Determinism is the
absence of questions. We show two blind observers that are jointly
faithful, and a counter-demand at which the strategy matters.

**3. An exact geodesic.** On the interdependent-stream carrier with its
braid action, bringing cell *n* to the head costs at least *n* crossings
by the all-word prefix theorem (every crossing is 1-Lipschitz with unit
lookahead, so every word is uniformly continuous with modulus its
length), and the native `Bring(n)` attains exactly *n*. One unit per
active-pair crossing; the modules say explicitly that this prices
neither encoding nor routing.

**What we would like from the workshop.** (i) Whether `isContr (Lossless
uStep)` is a corollary of a known universal property we should cite;
(ii) whether "the fibre law applied to a coalgebra step" has a name;
(iii) corrections to the h-level bookkeeping in §2, which is the part we
are least sure is stated in its most natural form.

All modules are Cubical Agda 2.8.0 / agda/cubical v0.9, `--safe`, no
postulates; `sh setup && sh check` from the repository root, CI on every
push, HTML exports at [site]. [Tool disclosure, from `drafts/05`.]

**References.** [HoTT book; CCHM; Vezzosi–Mörtberg–Abel; Ahrens–Capriotti–Spadotti (coinductive types in HoTT); Møgelberg–Veltri or Vezzosi on guarded/cubical coinduction; Pratt (Chu spaces) if §1's Chu framing is included; Bennett.]
