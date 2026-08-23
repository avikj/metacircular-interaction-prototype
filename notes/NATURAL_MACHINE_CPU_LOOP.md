# The natural machine runs, on a CPU, with no model in the loop — and its first honest report is a negative

**Author:** cf-sakshi, 2026-08-14. **Status:** executable; two results, one
negative and one exact-finite. The exhaustive classification of §4 is a finite
exhaustive verification and is therefore proof under `CLAUDE.md`; the cost
figures of §3 are measurements of a program and are labelled as such.

`natural_machine_cpu_loop_rust/main.rs` — build `rustc -O main.rs -o
natural_machine`, run `./natural_machine`. Deterministic: same binary, same
output. Exact integers throughout, no floating point, no model anywhere.
`verify.rs` is an independent re-derivation of §4 by a different algorithm.

## 0. Substrate disclosure, up front

`CLAUDE.md` says the substrate is Agda or Lean. **This binary is Rust, and that
is a real deviation.** The reason is not preference: this container has no Agda
and no Lean, `.lake` is absent, and egress to `elan.lean-lang.org` returns 403,
so nothing can be fetched. Python is banned outright, so the choice was between
a language that runs here and no running machine at all. The human owner asked
for a machine that executes on its own on a CPU; I built one and am flagging the
substrate rather than quietly spending the exemption.

What that costs, exactly, and what it does not:

- **It costs nothing in truth.** The program decides no mathematics. Every
  mathematical statement it depends on is either proved here, proved elsewhere
  in the corpus, or already Lean-checked — and §4's classification is a finite
  exhaustive verification, which `CLAUDE.md` admits as proof and which is
  re-derived by a second, independent implementation.
- **It costs replay confidence.** A reader must run the binary or read the
  source; they cannot typecheck it. That is precisely the objection the ban
  exists to raise, and it stands.
- **The port is well defined.** The loop's soundness half is already checked:
  `formal/pairfield/Pairfield/FutureBehavior.lean` (`run`, `behavior`,
  `FutureEq`, `futureSetoid`, `quotientStep`) and `BehavioralBFS.lean`
  (`shortestDistinguishingUpTo` with soundness and minimality). This binary is
  the executable face of those constructions. What it adds is the one thing
  those files deliberately do not assert — `InvariantCorrectiveClosure.lean`
  says so in its own docstring: *"No finite-dimensional termination, rank,
  stochastic lumpability, or partition-quotient theorem is asserted here."*
  The counters supply exactly that missing half.

## 1. What the machine is

`runtime/CRYSTAL.md` §7's loop, executed, on a domain that is **generated from
constructors, never written down as a table**:

| phase | what runs | checked counterpart |
|---|---|---|
| GENERATE | reachable closure from the seed under the constructors | — |
| DISTINGUISH | Moore refinement to the Myhill–Nerode/`FutureEq` quotient; shortest separating witnesses retained | `FutureBehavior`, `BehavioralBFS` |
| ROUTE | direct vs compiled route chosen by exact horizon cost | the amortized theorem |
| CRYSTALLIZE | mine the most-reused action block; install iff `(m−1)(r−1) > 1` | `KUTTAKA_TRACE_MACRO` |
| REOPEN | admit a new action; price the correction **both ways** | `LEAKAGE_PAST_IDEMPOTENCE` Thm C |

The domain is the divisibility crystal of `MATHEMATICS_THAT_LEARNS`: states are
residues mod `m`, the base-`b` digit `d` acts by `r ↦ br + d`, the observation is
`r = 0`. Three kernel counters — transitions, observations, comparisons — are the
experiment, per `CRYSTAL.md` §0.

Two internal checks worth naming. A macro's transition table is **constructed**
by composing its block on every state, and the replay law (`run(macro) =
run(block)` pointwise) is then re-verified exhaustively — this is
`KuttakaValli.replayHom`'s content as a finite check, not an assertion. And the
installed law is confronted with the machine's own output: base 2, `m = 2^a q`
with `q` odd needs `q + a` states; at `m = 12 = 2^2·3` the law says `5` and the
refinement finds `5`.

## 2. What ROUTE decides (positive, and unsurprising)

On the home domain with a four-query workload: direct route `528` kernel steps,
compilation `36` plus compiled queries `220` = `256`. Installation is chosen
because it is cheaper, not because compiling is a virtue.

## 3. The seed criterion, run honestly — and it FAILS at one pass

`CRYSTAL.md` §0 is the only claim that matters: a fact enters; an **independent**
problem thereafter solves in strictly fewer kernel steps; a null control must not
reduce it.

The mined block is `[1,0,1,1]` (reuse 8 on the home corpus, syntax gain 20). The
independent problem is `divisibility(base 2, modulus 35)` — a different, coprime
modulus, not used in deriving the block and not an instance of it. **The
independent workload is the binary expansion of 1000, 12345, 65535 and 99991,
fixed in advance and not built from the block.** That last clause is the whole
difficulty: my first version generated the independent workload *out of the
mined block*, which guarantees a saving and measures nothing. Replaced.

```
before installation                   total  2275
transport of the installed fact       total   350
after installation                    total  2170
strictly fewer steps on the workload: true (saved 105)
SEED CRITERION including installation: FALSE
```

The block occurs **once** in the unseen input. It saves 105 steps and costs 350
to transport, so at one pass over this workload **installation loses**, and the
machine says so. It reports the break-even itself: from 4 repetitions onward it
pays.

This reproduces, unprompted and on itself, two things the corpus already knows:

- `FAILURES.md` **F32** — *a true theorem does not automatically become a
  capability.* The replay law is exhaustively checked and still not worth
  installing here.
- `KUTTAKA_TRACE_MACRO`'s threshold, with the term the earlier work could not
  supply: the reuse count that matters is reuse on **unseen** input, and it was
  `1`, not the `8` measured on the corpus the block was mined from. Mining
  reuse and predicting reuse are different quantities and the first overstates
  the second.

**The null control is genuine, because it is searched for rather than assumed.**
My first control was `[0,0,0]` — which *occurs* in those binary expansions, so it
folded and reduced, and would have been a control that silently worked. The
machine now searches for the shortest block with zero occurrences (`[0,0,0,1,0]`)
and confirms the cost is unchanged at `2275`.

## 4. What REOPEN proves: the one-step price is wrong on a quarter of the actions

This is the exact-finite result, and it is an exhaustive verification.

Take the installed 5-class carrier of the base-2 crystal on `ℤ/12`. Admit, one at
a time, **every** affine action `r ↦ ar + c mod 12` — all 144 of them — and price
each correction two ways: the *one-step* cost (distinctions forced by applying the
action once) and the *persistent* cost (distinctions forced by the closure under
all future uses).

> **Classification (exhaustive, 144 of 144).**
> 86 actions are sound — the installed compression survives them with no
> correction. 58 reopen it. Of those 58, **36 have persistent > one-step**: the
> one-step price is strictly wrong. The maximal gap is 5, attained by 8 actions,
> the least of which is
> $$r \mapsto r+1 \pmod{12}: \qquad \text{one-step } 2, \qquad \text{persistent } 7 .$$

Three things follow, and the third is the one I did not expect.

1. It is the first *executed* instance of `LEAKAGE_PAST_IDEMPOTENCE` Theorem C's
   regime. That theorem says the one-step rank is exact when the admitted action
   has at most two spectral sectors and a strict undercount past it. Here the
   undercount is not a witness someone constructed — it is a quarter of all
   admissible actions on the simplest carrier in the corpus.
2. It fixes the live cost model. `REPRESENTATION_REOPENING_CYCLE` and
   `LEAKAGE_COST_VECTOR` price compression by the one-step rank; on this carrier
   that price is too low for 36 actions and too low by 5 for 8 of them. The
   machine therefore quotes both numbers and never the cheaper one.
3. **The maximal reopening action is the successor.** `r ↦ r+1` takes the
   5-class carrier all the way back to the discrete 12-state carrier —
   persistent 7, the largest possible — while a one-step pricer charges 2. The
   digit crystal is a compression of the *multiplicative* presentation of `ℤ/12`,
   and the thing that maximally destroys it is chart (a), the successor, which
   `ATLAS_OF_N` identifies as the residual of exactly this transition. I did not
   design that; the exhaustive scan returned it.

**Independent replication.** `verify.rs` shares no code with `main.rs`. Where
`main.rs` computes the quotient by Moore refinement, `verify.rs` computes each
state's behavior function by brute force and groups by equality of the tables —
a different algorithm. It returns the same 5 classes, the same 86/58/36, and the
same extremal `one-step 2, persistent 7, gap 5`.

## 5. Rigor boundary

- **Proof (finite exhaustive verification, doubly implemented):** §4's
  classification of all 144 affine actions, the 5-class identification, and the
  extremal witness.
- **Proved elsewhere and consumed, not re-derived:** the `q + a` state law
  (`BINARY_DIVISIBILITY_CRYSTAL`); Myhill–Nerode soundness and BFS minimality
  (Lean-checked, `FutureBehavior`/`BehavioralBFS`); the macro gain law
  (`KUTTAKA_TRACE_MACRO`); Theorem C (`LEAKAGE_PAST_IDEMPOTENCE`).
- **Measurement, not proof:** every kernel-step count in §§2–3. They are counts
  of this program's operations under this program's cost model. A different cost
  model gives different numbers, and the seed criterion's verdict is
  model-relative — which is why the break-even is reported rather than a verdict
  alone.
- **Not claimed:** that the loop discovers its own objectives or its own next
  action; it does not. It generates, distinguishes, prices, installs, and
  reopens within a declared domain. Nothing here is autonomous research.
- **Not claimed:** any novelty. Partition refinement, Krylov/invariant closure,
  and macro amortization are all classical; no search was performed.

## 6. Successor seeds

1. **Port to Lean when a toolchain exists.** §4 is a finite decidable
   classification and should be a `decide`-checked theorem, not a binary's
   stdout. That is the honest resolution of §0, and until it happens this note
   carries the substrate defect openly.
2. **Which affine actions are sound?** 86 of 144 is a number, not a criterion.
   The sound set is a unital subalgebra by `LEAKAGE_RANK_IS_INCIDENCE_RANK`
   Cor F, so it is generated — by what, on this carrier?
3. **Is the successor maximal on every divisibility crystal**, or is `ℤ/12` a
   coincidence? Finite check per modulus; a proof would connect the reopening
   price directly to `ATLAS_OF_N`'s residual for the `(f) → (b)` transition.
