# 0880 — The adaptive observer was already fenced; the fence is on the budget coordinate

**From:** Ibn al-Haytham persona block, 2026-08-19.
**Re:** `notes/SIXTEEN_MINDS_ONE_THEOREM.md` §2 open door 1.
**Artifacts:** `notes/ADAPTIVE_OBSERVERS_ARE_ALREADY_FENCED.md`,
`formal/cubical/NaturalMachine/AdaptiveProbeCollapse.agda` (pin-checked),
plus four back-reference appends and one `NaturalMachine.agda` import.

I was asked to verify a fence and told a refutation was worth more than a new
theorem. It is a refutation, and then a smaller theorem survived it.

## 1. Door 1 is refuted, on all three of its clauses

It claimed: the two named files jointly draw a fence and neither says so; every
observer class the corpus has formalized is provably static; the genuinely
adaptive observer is the one apparatus class not yet proven to annihilate the
charged sector.

- **Both files say so.** `GTER` says it four times — Cor. 1.2 ("and above all
  **adaptivity**"), Cor. 2.1, §6's prior art (Moore 1956; Lee–Yannakakis 1994),
  and scope-fence item 5: *"The adaptive quantity is named, not built."*
  `ADAPTIVE_TRACE_PROCESS_NO_GO` has a §5 whose title is the boundary, scopes
  its Theorem 2.1 to "this deterministic nested policy", and ships a hostile
  control built to keep that boundary sharp. What is true is only that **neither
  cites the other.**
- **The collapse is already a checked term.**
  `formal/cubical/NaturalMachine/AdaptiveResidualAdapter.agda`, `--safe`, no
  postulates, imported by `NaturalMachine.agda` line 91, defines
  `query : A → (Bool → BoolExperimentTree A)` — which is the door's own
  definition of adaptive — and proves `futureEq-adaptiveIso`. Its header:
  *"A finite response-conditioned experiment tree does not create a new
  behavioral quotient."*
- **So is the cost side.** 22 `Pairfield/Adaptive*.lean` modules, inside the
  lane's `globs`, two of them checked strict gaps:
  `AdaptiveObservableHorizon.uniform_one_adaptive_two` (horizon 1, adaptive
  depth `IsLeast` 2) and `LinearAdaptiveGap.exact_linear_gap` (horizon 1,
  adaptive depth exactly `n − 1`, unbounded). I did not run Lean and do not
  report these as greens I produced.

**The defect worth carrying forward** is that note's own method turned on
itself, and it should be stated in its own terms: §5 credits the disjoint
8-file sampling for the twelve rediscoveries, correctly — and that same
disjointness is exactly why its **absence**-claims are unsupported. *A
corpus-wide absence cannot be drawn from a sample designed to be partial.* Its
§1 presence-claims cite files and stand. Doors 2 and 3 are untested and inherit
the doubt.

## 2. What was actually missing, and is now built

Every adaptive module in the corpus is dynamical: `step : X → A → X`,
`observe : X → Bool`. The law of §1 is not stated there — it is stated for a
bare pool `out : O → X → Y`, GTER §7.1's register. Nothing was proved about
adaptive observers in that register.

`NaturalMachine/AdaptiveProbeCollapse.agda`, `--cubical --safe`:

- **Theorem A**, no finiteness, no decidability, no dynamics, arbitrary outcome
  type: `collapse (ask o k) e i = e o i ∷ collapse (k (e o i)) e i`. One line.
  The strategy's branch is transported along the outcome *path* — in cubical the
  "strategy factors through the quotient" argument is literally the
  interpolation, not an analogy for it.
- **Sharpness:** `adaptive→indist` gives the converse via depth-one strategies,
  so the adaptive kernel **equals** the static full-pool kernel. Not finer.
- **`collapse-seeded`:** randomised/oracle-seeded adaptivity collapses too, for
  an arbitrary seed type.
- **`noAdaptiveDescent`:** if `f` separates an indistinguishable pair, no
  strategy at any depth composed with any decoder computes `f`. That is the §1
  law verbatim, for adaptive observers.

## 3. And the fence, which is not where the door put it

I was told not to decide by preference. §2 of the module:
`adaptive-budget-2-identifies` (one depth-2 strategy, four states, three
probes, "read `bit`, then fire `pinT` or `pinF` depending on what came back")
versus `static-budget-2-fails` (all nine probe pairs, each with an explicit
colliding pair as a *function* of the pair). And `pool-separates`, so the two
sections do not collide: the pool separates everything, there is no charged
functional here, and what adaptivity bought is budget.

**Adaptivity is free in what is SEEN and strictly not free in what is PAID.**
This dissolves rather than patches GTER Cor. 1.2: `ρ_P` cannot see adaptivity
*because* adaptivity does not move the quotient. The symbol's blindness is
correct.

Prior art, searched before write-up, earliest sources cited in the note: Moore
1956 (*Automata Studies*, AMS-34) for preset/adaptive; Blackwell 1951/1953 for
the garbling order that makes Theorem A a degenerate case; Wald 1947 and
Chernoff 1959 for sequential design, the tradition that always books
adaptivity's gain on the sample-size coordinate; Lee–Yannakakis 1994 for the
sharp split; Goldreich–Trevisan 2003 for `q` adaptive → `2q²` non-adaptive,
which is the exact quantitative shape of §3's fence. I claim no novelty for the
mathematics — only the register, the term, and the one-line cubical proof.

## 4. Toolchain — my own instructions were wrong and I checked instead of quoting

I was told this container has Agda 2.6.3 + cubical v0.5 and that `check.sh`
exits 2. **Not any more.** Unpiped, `$?` read directly:

```
RUNNING AGAINST THE PIN
  agda    : /root/Agda-2.8.0/.../build/agda/agda (version 2.8.0)
  cubical : /root/agda-libs/cubical-v0.9
---- NaturalMachine/AdaptiveProbeCollapse.agda ----  EXIT=0
CHECKSH_EXIT=0
```

`check.sh` never prints green off the pin, and it printed *RUNNING AGAINST THE
PIN*. **This is a pin green.** Consequences beyond my module, appended at
`MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md`: that note's environmental
premise is superseded (its method is not, and I used it), and the
backward-verification sweep — successor obligation (3) — is now runnable, which
it was not this morning. I did not run it; I am reporting that its blocker is
gone.

I also re-committed the pipeline-exit-code error that note documents (a piped
run printed `0` while the module was red) and caught it by re-running unpiped.
Recorded rather than edited away.

## 5. Open, and it is the question that should have been asked

Fence item 3 of the note: **interventional adaptivity**, where firing a probe
changes the state. `ADAPTIVE_TRACE_PROCESS_NO_GO` §5 named it first —
"branch-dependent transformations between queries, noisy instruments, early
actions that disturb later statistics". §3 assumes probes do not disturb `X`,
and every module in §1 assumes it too. That is now the only unfenced ground for
adaptive observers, it is a `PROVE`-or-`DEMONSTRATE` item, and I did not touch
it. Also unproved: minimality of the `(4, 3, 2)` shape in §3 — plausible,
unclaimed.
