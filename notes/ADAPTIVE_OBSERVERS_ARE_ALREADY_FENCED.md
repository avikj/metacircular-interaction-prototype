# Adaptive observers are already fenced, and the fence is on the other coordinate

**Ibn al-Haytham persona block, 2026-08-19.**
**Mark: ⊢** for §3 (a checked term on the pin) and **T1 / refutation at type**
for §1 (`NEGATIVE_KNOWLEDGE_IS_TYPED` — the certificate is an exhibited
counterexample to a stated claim, namely the claim's own named files).

**Assignment.** `notes/SIXTEEN_MINDS_ONE_THEOREM.md` §2 open door 1, verbatim:

> "Adaptive observers are the unfenced ground. GTER Thm 1 × ADAPTIVE_TRACE_PROCESS_NO_GO
> Thm 2.1: every observer class this corpus has formalized is provably STATIC.
> The genuinely adaptive observer — next probe chosen from last outcome — is the
> one apparatus class not yet proven to annihilate the charged sector. The two
> files jointly draw the fence and neither says so."

Step 1 of the assignment was to verify that fence, with the instruction that a
refutation is worth more than a new theorem. **It is a refutation, on three
counts, and it is not close.** §§1–2 are the refutation; §3 is the theorem that
survives it and the one that was actually missing.

---

## 1. The fence claim is false, three times over

### 1.1 Both named files say exactly what the synthesis says neither says

Absence claimed: *"neither says so"*.
Counterpositive: a sentence in each file naming adaptivity as the boundary of
its own scope. Locus: the two files. Delimitor: read in full, this session.
Both are present.

- `GTER_REVELATION_AND_THE_TWO_COORDINATE_DEFECT.md` says it **four times**.
  Corollary 1.2 is titled "what ρ_P therefore cannot see" and its content is:
  *"and above all **adaptivity** — choosing `r_{k+1}` after seeing `r_k`'s
  outcome."* Corollary 2.1: *"A genuinely temporal τ would need the filtration
  to depend on outcomes already observed, i.e. exactly the adaptive structure
  Corollary 1.2 shows ρ_P cannot express."* §6 names the prior art for it
  (Moore 1956; Lee–Yannakakis 1994). Scope fence §7 item 5, in full: *"**The
  adaptive quantity is named, not built.** Cor. 1.2 says what ρ_P cannot see;
  it does not define the sequential cost, and this note does not."*
  It also credits `ACTIVE_OBSERVER_DESIGN` §6 for having recorded the same
  thing first.
- `ADAPTIVE_TRACE_PROCESS_NO_GO.md` has a section §5 whose *title* is "What
  would create genuine process memory", and whose content is the exact
  boundary: *"A trace becomes load-bearing if later state or admissible
  interventions depend on earlier outcomes in a way not reconstructible from
  the terminal record."* Its Theorem 2.1 is explicitly scoped — *"That
  inference is false **for this deterministic nested policy**"* — and its own
  checked adapter carries a hostile control (`the identity Bool history does
  not factor through a constant Unit terminal record`) built precisely to keep
  that boundary sharp.

So the two files do not "jointly draw a fence and fail to say so". Each draws
its own fence and says so in its own scope section. What is true, and is all
that survives of the sentence, is that **neither cites the other** — a
reachability defect of the kind `MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS`
§"Second self-audit" names, not a mathematical gap.

### 1.2 The collapse for genuinely adaptive observers is already a checked term

Absence claimed: *"the one apparatus class not yet proven to annihilate the
charged sector"*.
Counterpositive: a checked Agda term proving the collapse for observers whose
next probe is chosen from the last outcome. Locus:
`formal/cubical/NaturalMachine/AdaptiveResidualAdapter.agda`, in the same
directory as the corpus's other cited cubical results, imported by
`NaturalMachine.agda` line 91. Delimitor: read in full.

That module defines

```agda
data BoolExperimentTree (A : Type ℓA) : Type ℓA where
  done  : BoolExperimentTree A
  query : A → (Bool → BoolExperimentTree A) → BoolExperimentTree A
```

— the `Bool →` **is** "next probe chosen from last outcome", which is the
synthesis's own definition of the genuinely adaptive observer — and proves
`futureEq-adaptiveIso : Iso (FutureEq …) (AdaptiveEq …)`: agreement under
*every* finite adaptive experiment tree is the *same relation* as agreement on
every fixed word. Its own header states the theorem in one line: *"A finite
response-conditioned experiment tree does not create a new behavioral
quotient."* `--cubical --safe`, no postulates, no holes. It further proves
`adaptiveEq-step` (the relation is a congruence, "because it is the existing
future congruence, not a new quotient") and, via `QuotientAdapter`, an `Iso`
with the path space of the quotient itself.

That is the theorem the assignment asked me to prove, already in the corpus,
in the Moore-machine register, before this block started.

### 1.3 The cost side is also already checked, including two strict gaps

The Lean lane holds **22** `Pairfield/Adaptive*.lean` modules. Two of them are
checked strict separations between static and adaptive cost:

- `AdaptiveObservableHorizon.lean`, `uniform_one_adaptive_two`:
  `globalObservableHorizon automaton alphabet = 1 ∧ IsLeast {fuel | IdentifiesAtDepth step observe fuel} 2`.
  Its own comment calls it "The promised strict cost separation."
- `LinearAdaptiveGap.lean`, `exact_linear_gap`: an all-state-reachable family
  with uniform horizon `1` and adaptive identification depth *exactly* `n − 1`,
  both as `IsLeast` — an unbounded gap, not one instance.

`lakefile` sets `globs = ["Pairfield", "Pairfield.+"]`, so these are inside the
lane's build (the `globs` check `CLAUDE.md` demands before believing a green).
I did not run Lean; the claim here is about what the files state and that they
are in the build closure, and I say so rather than reporting a green I did not
produce.

**Verdict.** Open door 1 was not a door. Of its three clauses — "neither file
says so", "no adaptive class formalized", "not yet proven to annihilate the
charged sector" — all three are false. The synthesis is a fan-out over sixteen
*disjoint* 8-file samples; §5 of that note credits the disjointness for its
successes, and this is the matching cost, stated in its own terms: **a claim of
corpus-wide absence cannot be drawn from a sample designed to be partial.** The
other eleven rows of its table cite specific files and stand; only the
absence-claims in §2 inherit this defect, and only door 1 was checked here.

---

## 2. What was actually missing

All of the corpus's adaptive work is **dynamical**: a carrier `X`, an alphabet
`A`, a transition `step : X → A → X`, a single Boolean Moore output
`observe : X → Bool`. Every module in §1.2–1.3 has that shape.

The law of `SIXTEEN_MINDS_ONE_THEOREM` §1 is not stated in that register. It is
stated for a **closed observation class** over a bare state space — GTER §7.1's
`E(P) = ⋂_{o ∈ P} kerpair(o)` with `o : X → Y_o`, no dynamics, no alphabet, no
distinguished output, arbitrary outcome type. In *that* register nothing was
proved about adaptive observers, and GTER's scope fence item 5 says so in as
many words.

That is the gap, and it is a real one, though much smaller than advertised. §3
closes it.

---

## 3. The theorem: `NaturalMachine.AdaptiveProbeCollapse`

`formal/cubical/NaturalMachine/AdaptiveProbeCollapse.agda`, `--cubical --safe`,
no postulates, no holes, no `--guardedness`. Added to `NaturalMachine.agda`'s
import list.

**Setting.** `X : Type ℓX` (states), `O : Type ℓO` (the pool), `Y : Type ℓY`
(outcomes), `out : O → X → Y`. No finiteness, no decidability, no h-level
hypothesis anywhere.

```agda
Indist x x' = (o : O) → out o x ≡ out o x'          -- what the closed class sees

data Strategy : ℕ → Type (ℓ-max ℓO ℓY) where
  stop : Strategy zero
  ask  : {n : ℕ} → O → (Y → Strategy n) → Strategy (suc n)

run : {n : ℕ} → Strategy n → X → List Y
run stop      x = []
run (ask o k) x = out o x ∷ run (k (out o x)) x
```

`ask o k` fires `o`, reads the outcome `y`, and continues with `k y`. A static
observer is the sub-class where every `k` is constant. This is the definition
the assignment asked for, with the branching in the type.

**Theorem A (collapse).**

```agda
collapse : {n : ℕ} (s : Strategy n) {x x' : X} → Indist x x' → run s x ≡ run s x'
collapse stop      e   = refl
collapse (ask o k) e i = e o i ∷ collapse (k (e o i)) e i
```

The proof is one line and the line is the whole argument. `e o : out o x ≡ out
o x'` is a *path*; `k (e o i)` transports the strategy's own choice of next
probe along it. The strategy can branch on the outcome precisely because
branching on the outcome is a function of the outcome — so the branch travels
with the path. This is the "the strategy is itself a function of the quotient"
argument, and in cubical it is not an analogy: the interpolation *is* the
factorization.

**Theorem A is sharp, not merely an inclusion.** The converse holds, witnessed
by the depth-one strategies `probeStrategy o = ask o (λ _ → stop)`:

```agda
adaptive→indist : ({n : ℕ} (s : Strategy n) → run s x ≡ run s x') → Indist x x'
```

So the adaptive observer's kernel **equals** the static full-pool kernel. Not
finer, not coarser. Adaptivity does not move the quotient at all.

**Randomised adaptivity too.** `collapse-seeded` quantifies over an arbitrary
seed type `S` and a strategy family `σ : S → Strategy n`; the collapse holds
seedwise. A coin, an oracle, or arbitrary prior side advice changes nothing, so
long as the *probes* come from the pool.

**Theorem A′ (the charged sector), which is the corpus's law:**

```agda
noAdaptiveDescent :
    {A : Type ℓA} (f : X → A) (x x' : X)
  → Indist x x' → ¬ (f x ≡ f x')
  → {n : ℕ} (s : Strategy n) (decode : List Y → A)
  → ¬ ((z : X) → decode (run s z) ≡ f z)
```

If a functional separates an indistinguishable pair, then **no** adaptive
strategy at **any** depth, composed with **any** decoder, computes it. That is
"no post-processing of the quotient manufactures the fiber" — the §1 law
verbatim — now for adaptive observers, in the register the law is stated in.

### 3.1 And the fence, which is on the budget coordinate

The strongest available outcome was named in the assignment as the general
collapse. It is proved. But it would be a misreading to stop there, and §2 of
the module says why with a witness.

Four states `St = Bool × Bool`; three probes: `bit` reads the first
coordinate, `pinT` fires only at `(true , true)`, `pinF` only at
`(false , true)`.

- `adaptive-budget-2-identifies` — the depth-2 strategy "read `bit`; **if it
  came back `true` fire `pinT`, otherwise fire `pinF`**" recovers the state
  exactly, via an explicit decoder, four `refl`s.
- `static-budget-2-fails` — for **every** pair of probes `(p , q)`, all nine
  including the repeats, an explicit colliding pair of distinct states.
  Nine `refl`s and nine appeals to three `Bool` disequalities. No search, no
  quantifier left implicit: the collision is a *function* of the probe pair.
- `static-budget-3-identifies` and `pool-separates` — the whole pool does
  separate everything. So §2 never contradicts §1: the pool's `Indist` here is
  trivial, there is no charged functional to annihilate, and what adaptivity
  bought is **budget**, never visibility. The adaptive strategy reached the
  pool's own quotient sooner; it never reached past it.

**This is the fence, and it is where the mathematics put it, not where I would
have preferred it.** Adaptivity is *free* with respect to what is SEEN — exact
kernel equality, no hypotheses, arbitrary outcome type, randomisation included.
Adaptivity is *not* free with respect to what is PAID — a strict separation at
budget 2 on four states.

And this dissolves the tension between the two named files rather than leaving
it: GTER Cor. 1.2 is right that `ρ_P` cannot see adaptivity, and that is *not*
a gap in the law. It is a theorem about which coordinate adaptivity lives on.
`ρ_P` measures the quotient; adaptivity does not move the quotient; therefore
`ρ_P` cannot see it. The symbol's blindness is exactly correct.

### 3.2 Toolchain — and a correction to my own instructions

My task statement said this container has Agda 2.6.3 + cubical v0.5 via a
scratchpad clone, that the declared pin is absent, and that `check.sh` exits 2.
**That is no longer true, and I verified it rather than quoting it.**

```
cd formal/cubical && LC_ALL=C.UTF-8 \
  NM_MODULES="NaturalMachine/AdaptiveProbeCollapse.agda" ./check.sh
```

```
======================================================================
RUNNING AGAINST THE PIN
  agda    : /root/Agda-2.8.0/.../build/agda/agda (version 2.8.0)
  cubical : /root/agda-libs/cubical-v0.9
  locale  : LC_ALL=C.UTF-8
======================================================================
---- NaturalMachine/AdaptiveProbeCollapse.agda ----
EXIT=0  (errors: 0, warning lines: 0)
SUMMARY
  EXIT 0   --  NaturalMachine/AdaptiveProbeCollapse.agda
```

`CHECKSH_EXIT=0`, read from `$?` on an unpiped run — the pipeline-exit-code
error that `MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS` documents was in fact
committed once here (a piped run reported `0` while the module was red) and
caught by re-running unpiped. `check.sh`'s contract is that it never prints
green off the pin, and it printed "RUNNING AGAINST THE PIN" and named both
halves. **So this is a pin green.**

Consequence for the corpus, which is larger than this module: that note's
conclusion ("here the pin is unreachable, and the ~409 modules reachable only
from `NaturalMachine.agda` or `Everything.agda` cannot be checked on this
container by anybody") is **superseded by the environment, not by any
argument**. Its method stands entirely and this block used it. But any note or
message that still says the pin is unreachable should be re-checked before it
is relied on, and the backward-verification sweep listed as successor
obligation (3) in `SIXTEEN_MINDS_ONE_THEOREM` §5 is now *runnable*, which it
was not this morning. I did not run it; I am reporting that the blocker named
for it is gone.

---

## 4. Prior art, run both ways

Per `PRIOR_ART_RUNS_BOTH_WAYS_AN_AUDIT.md`, searched **before** write-up, and
the corpus-side search (§1) is the half that produced the refutation.

**Sources, earliest first, cited as sources.**

- **E. F. Moore, "Gedanken-Experiments on Sequential Machines", in *Automata
  Studies* (C. E. Shannon and J. McCarthy, eds.), Annals of Mathematics Studies
  no. 34, Princeton University Press, 1956, pp. 129–153.** The origin of the
  preset/adaptive distinction for machine identification experiments. This is
  the earliest source for §3.1's phenomenon, and GTER §6 had already named it —
  which is a second way in which the "unfenced ground" claim was wrong: the
  fence had a citation.
- **D. Blackwell, "Comparison of Experiments", *Proceedings of the Second
  Berkeley Symposium on Mathematical Statistics and Probability*, 1951,
  pp. 93–102**; and **"Equivalent Comparisons of Experiments", *Annals of
  Mathematical Statistics* 24(2), 1953, pp. 265–272.** Sufficiency and the
  garbling order. Theorem A is the degenerate deterministic case of the
  standing fact that a decision procedure adapted to an experiment cannot be
  more informative than the experiment: the adaptive strategy is a garbling of
  the full pool, never a refinement of it. `COORDINATION_THEOREMS_XLIV`
  1419–23 already carries the Blackwell order (per `SIXTEEN_MINDS` §1's Noether
  row), so the corpus holds the abstract statement too.
- **A. Wald, *Sequential Analysis*, Wiley, 1947** (from "Sequential Tests of
  Statistical Hypotheses", *Ann. Math. Statist.* 16(2), 1945), and
  **H. Chernoff, "Sequential Design of Experiments", *Ann. Math. Statist.*
  30(3), 1959, pp. 755–770.** Sequential experimental design: the discipline
  in which adaptivity's gain is *always* accounted on the sample-size
  coordinate and never on the identifiability coordinate. §3.1 is that
  accounting, in the corpus's own register.
- **D. Lee and M. Yannakakis, "Testing Finite-State Machines: State
  Identification and Verification", *IEEE Transactions on Computers* 43(3),
  1994, pp. 306–320.** The sharp adaptive/preset split: an adaptive
  distinguishing sequence is computable in polynomial time while the preset
  problem is PSPACE-hard. The quantitative version of §3.1's separation, and
  the reason a *linear* gap (`LinearAdaptiveGap`) is the honest shape rather
  than a constant one.
- **O. Goldreich and L. Trevisan, "Three Theorems Regarding Testing Graph
  Properties", *Random Structures & Algorithms* 23(1), 2003, pp. 23–57.** In
  the dense-graph model any `q`-query adaptive tester is simulated by a
  `2q²`-query non-adaptive one. This is the exact quantitative shape of the
  fence: adaptivity is a real but *bounded* gain, and only on the budget
  coordinate — never a gain in what is decidable.
- **S. L. Goldman and M. J. Kearns, "On the Complexity of Teaching", *Journal
  of Computer and System Sciences* 50(1), 1995, pp. 20–31** (teaching
  dimension), already named in GTER §6 for the static side.

**Assessment.** Theorem A is folklore in every one of these neighbourhoods and
I claim no novelty for the mathematics. What is new is (a) the register — bare
pool, arbitrary outcome type, no dynamics, no finiteness — in which the
corpus's own law is stated and in which it had not been proved; (b) that it is
a **term** rather than a paragraph, so that the charged-sector corollary is
checkable rather than assertable; and (c) the cubical proof, in which the
"strategy factors through the quotient" argument is literally a path
interpolation, `k (e o i)`, one line long.

---

## 5. Scope fence

1. **The `--safe` green is a pin green** (§3.2), and it covers
   `AdaptiveProbeCollapse.agda` alone. I did not re-check `NaturalMachine.agda`
   whole, so the effect of my one-line import addition on the rest of the
   closure is unverified. I did not run Lean at all; §1.3's claims are about
   the *statements* in those files and their presence in the `globs` closure,
   not about a build I produced.
2. **`Strategy` is finite-depth.** An unbounded or streaming adaptive observer
   is not formalized; the collapse holds at every finite depth `n`, and a
   coinductive observer's collapse follows on every finite prefix, which is not
   the same as a checked coinductive statement and I do not claim it as one.
3. **Outcomes are honest, and probes are pointwise.** `out : O → X → Y` is
   deterministic and outcome-faithful. A *noisy* instrument is outside this
   theorem, and GTER §1's own fence gives the reason the restriction is not
   removable by editing: a probe universe whose separating power is joint
   cannot be presented as a family of maps `o : X → Y_o` at all. This is also
   the one boundary `ADAPTIVE_TRACE_PROCESS_NO_GO` §5 names that I have **not**
   crossed: "branch-dependent transformations between queries, noisy
   instruments, early actions that disturb later statistics". §3 assumes the
   probes do not disturb the state. **Interventional adaptivity — where firing
   a probe changes `X` — is genuinely open and is the real successor to this
   note.** It is not what the synthesis asked, and it is what the synthesis
   should have asked.
4. **§3.1's separation is one shape, `(4 states, 3 probes, budget 2)`.** I did
   not prove that shape minimal (contrast `GTER` Thm 6, which does prove
   minimality for its witnesses). Minimality is plausible and unproved; saying
   so costs nothing and claiming it would cost the note.
5. **No experiment, no fitted constant, no floating-point number, no Python.**

---

## 6. Declared consumers

- **`notes/SIXTEEN_MINDS_ONE_THEOREM.md` §2 open door 1** — refuted; §5's
  successor obligation (4), "the adaptive observer question (the only open
  ground on which a parity-breaking method could stand)", is discharged as
  stated and should be re-posed as scope-fence item 3 above (interventional
  adaptivity). A pointer is appended at that file.
- **`notes/GTER_REVELATION_AND_THE_TWO_COORDINATE_DEFECT.md` §7 item 5** ("the
  adaptive quantity is named, not built") — built, in §3, in that note's own
  register. Pointer appended.
- **`notes/ADAPTIVE_TRACE_PROCESS_NO_GO.md` §5** — its boundary condition is
  now the *only* remaining open case (fence item 3), which is a promotion, not
  a correction. Pointer appended.
- **`notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md`** — its
  environmental premise is superseded (§3.2); its method is not. Pointer
  appended.
- **`formal/cubical/NaturalMachine/AdaptiveResidualAdapter.agda`** — is the
  Moore-register instance of §3's general theorem; the two should be related by
  an adapter, which is not built here and is the obvious next term.

---

*Refutation, theorem, module and prior art: this block. The law refuted-against
and the twelve-register table it sits in: `SIXTEEN_MINDS_ONE_THEOREM.md`
(cf-sakshi). No experiment was run.*
