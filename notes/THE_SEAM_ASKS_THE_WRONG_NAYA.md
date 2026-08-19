# The obstruction seam routes the kernel's question to the rewriter, and it dies there

**2026-08-18.** Measured, then explained, then the explanation checked against
the source. This refutes the premise of the obstruction seam as implemented,
and with it the practical value of `arohana`, which I built this morning.

## 1. The seam has never paid, once, in the machine's whole recorded history

`machine/machine.log`, 239 rounds:

| | |
|---|---|
| residuals recovered | **1696** |
| distinct residuals | 155 |
| distinct lemmas demanded | 114 |
| `RESIDUAL-THEOREM` lines | **0** |
| `RESIDUAL-CLOSES-PARENT` lines | **0** |

Not "few". Zero. The whole apparatus — harvest the kernel's refusal, parse the
residual, triage it, queue it, track its parent, verify dependence — has never
produced one lemma that closed one parent.

And nothing recorded why, because `residualTally` — the binding that tallies
each residual by the reason it will or will not reach the prover, and which
this file's own source comment calls *"the diagnostic that decides whether the
wire can pay at all"* — was **computed every round and never used.** One
occurrence in the source: its definition. Now logged as `RESIDUAL-FATE`.

## 2. The first hypothesis was wrong

I expected the descent not to terminate: Āryabhaṭa's kuṭṭaka bottoms out
because each division leaves `r` strictly smaller than `b`, and
`Obstruction.hs`'s own header notes that the flagship residual `x = x + 0·x`
is *bigger* than the goal that produced it. A descent with no decreasing
measure cannot reach a bottom, and a climb seeded at the bottom can never
fire.

**Refuted by measurement.** Residual sizes over the whole log: min 2, median
6, max 24. The ten most-demanded:

```
  0 = (y*0)              size=4   unblocks=18
  (x*(xle0)) = 0         size=6   unblocks=12
  0 = (z*0)              size=4   unblocks=9
  (x*0) = 0              size=4   unblocks=8
  x = (x+0)              size=4   unblocks=6
```

The descent terminates immediately and bottoms out at the simplest facts about
the vocabulary. The vallī is three rows deep, not infinite.

## 3. What actually happens

`x = (x+0)` is demanded as a residual **27 times**. It is submitted to the
kernel **zero** times — no `KERNEL-ACCEPT` and no `KERNEL-REJECT` line in
239 rounds so much as mentions it.

`RESIDUAL-FATE`, from a run with the instrument turned back on, reports one
status and only one:

```
  RESIDUAL-FATE  follows-by-rewriting       4
  RESIDUAL-FATE  follows-by-rewriting       4
```

Every queued residual, every round, dies at `provedByRewriting rules c`. None
reaches `stated`.

And it is right to. `machine/library.terms` line 1 is `x = 0 + x`, and lines
15, 22 and 33 are `x + y = y + x`. From those two the rewriter derives
`x = x + 0` in one step. The residual *does* follow from what the machine
knows.

## 4. Why the kernel stalls there anyway, and why this is a naya collision

Agda's `_+_` recurses on its **first** argument. So `0 + x` reduces to `x` by
computation and `x + 0` does not reduce at all. `x ≡ x + 0` is the first thing
anyone proves about ℕ and it needs induction; it is not definitional, and no
amount of the machine knowing it changes that.

Can the kernel be told? No:

- `REWRITE` occurs **0 times** in `machine/MathMachine.hs`. The machine's
  theorems are never emitted as reduction rules for Agda — and under `--safe`
  they cannot be, since `{-# REWRITE #-}` requires `--rewriting`.
- `lemmaRules` (MathMachine.hs:2742) installs every proved equation into the
  **rewriter's** rule set in *both* directions: `\(a,b) -> [(a,b),(b,a)]`.

So there are two rule sets and they diverge permanently, by construction. The
rewriter accumulates every theorem the machine ever proves. The kernel gets
none of them, ever. **Every lemma the machine learns widens the gap between
the two standpoints.**

The seam then does this: it takes a question the *kernel* asked — "I stalled
at `x ≡ x + 0`" — and tests the answer against the *rewriter*, which replies
"already settled," so the question is dropped. It is never asked of the one
naya that could act on it.

Both standpoints are correct. From the rewriter's, `x = x+0` follows and there
is nothing to do. From kernel-refl's, `x ≡ x + 0` is exactly where everything
stops. The residual is annihilated in transit between two views each of which
is right — which is not a metaphor imported to decorate a bug report. It is
`Saptabhangi.agda`'s subject matter occurring as a live engineering fault, in
the seam built to fix the machine.

## 5. The corroborating number

`(x+y) = (y+x)` appears on a `KERNEL-ACCEPT` line **56 times**.

The machine has proved the commutativity of addition fifty-six separate times.
It has no way to make the kernel remember it once. That is the same defect seen
from the other end, and it is most of what the 54% re-proof waste measured
earlier in this corpus actually is.

## 6. What this does to `arohana`

`arohana` (landed 2026-08-18) climbs the vallī when a residual becomes a
theorem, summoning the parents it unblocks. It is correctly built — the
function is checked on three vallī shapes and the empty seed — and it is
**inert**, because it is seeded from `residualTheorems`, which is drawn from
`checkedResults`, which contains only what the *kernel* accepted. No residual
has ever been submitted to the kernel, so none has ever been accepted, so the
seed set has always been empty and always will be under the present routing.

The ascent is built and the descent bottoms out. What is missing is between
them: nothing carries the bottom of the vallī across the standpoint boundary.

## 7. The repair, stated but not taken

The kernel cannot receive lemmas as rewrite rules, but it can receive them as
**definitions**: emit each proved lemma into the generated Agda file as a
checked term, and extend the tactic language so a proof can invoke one by
name. The machine already emits tactics (`induction on x, step = cong suc`);
what it does not emit is a context.

That is the change. It is not made here — this note is the diagnosis, and the
diagnosis is what was missing. Two smaller things follow from it and are
independent:

1. `provedByRewriting` is answering the wrong question in this one position.
   The seam should ask *"does the kernel have this?"*, and it asks *"do I have
   this?"*. Those are different questions and the code conflates them.
2. `residualStatus` should distinguish `follows-by-rewriting` (the rewriter
   derives it) from `known-to-the-kernel` (the kernel has closed it). It
   cannot currently tell them apart, which is why this took a log audit rather
   than a glance.

---

## 8. Correction, same day: the mechanism above is wrong, and the real one is sharper

§4 said the cause is that the rewriter accumulates every theorem while the
kernel gets none, so the two rule sets diverge. That is true and it is not the
cause. Found by asking the prover directly (`--prove-residuals`) instead of
inferring from aggregate counts, which is what §1–§7 were doing.

**The two standpoints define the same symbol by opposite recursions.**

| | clauses | reduces on |
|---|---|---|
| machine, `MathMachine.hs:722` | `x + 0 = x`, `x + suc y = suc (x + y)` | the **second** argument |
| Agda, `Agda/Builtin/Nat.agda:19` | `zero + m = m`, `suc n + m = suc (n + m)` | the **first** argument |

and the same for `·`. So `x + 0 ≡ x` is, to the machine, a **defining
equation** — nothing to prove, `provedByRewriting` returns `True` at the start
machine with two rules — and to Agda the standard first lemma about ℕ,
requiring induction. `0 + x ≡ x` is `refl` for Agda and needs work for the
machine. They are the same function and not the same definition.

That is why the curriculum looks the way it does. The most-demanded residuals
across 239 rounds:

```
  0 = (y*0)     unblocks 18      machine: x · 0 = 0        definitional
  0 = (z*0)     unblocks  9      machine: x · 0 = 0        definitional
  (x*0) = 0     unblocks  8      machine: x · 0 = 0        definitional
  x = (x+0)     unblocks  6      machine: x + 0 = x        definitional
  x = (0maxx)   unblocks  3      machine: max 0 x = x      definitional
```

Every one is a machine axiom in the mirrored orientation. The kernel stalls
exactly where the two definitions disagree, so the residual stream is
*dominated by statements the machine considers axioms* — before any lemma is
learned, by construction, on round one.

**And it was known.** `machine/Certificate.hs`, Note A:

> Agda's `+` and `·` recurse on the FIRST argument; MathMachine's symDefs
> recurse on the second… The clause order differs only in which equations hold
> *definitionally*, and the first-argument order was measured to certify
> strictly more of the machine's library than a transcription of the symDefs
> would.

The measurement is real and the trade is defensible. The word doing the damage
is *only*. Which equations hold definitionally is precisely what the kernel
stalls on, hence which residuals are produced, hence the whole curriculum. A
local optimisation — certify more of the library — was paid for with a global
property nobody priced: **the obstruction seam can never pay, because its input
is generated by the very mismatch it is trying to close.**

**What this does to §7's repair.** Emitting lemmas as definitions
(`machine/KernelContext.hs`, built) is still right and still needed. It is not
sufficient, and on its own it would not have moved the number: citing
`plusZero` helps only once `plusZero` is something the machine will submit, and
the machine will not submit an axiom. The missing piece is to transcribe the
machine's own `symDefs` for `+` and `·` into the emitted module, as
`Certificate` already does for `max` and `le` (Note B), so that the two
standpoints share a definition rather than sharing only a name. Then either
orientation is provable on both sides and the residual stream stops being an
artefact.

**What is still not claimed.** That doing so makes the seam pay. The
measurement Note A records — first-argument order certifies strictly more of
the library — would have to be re-run against a transcribed `+`, and it may
well come out worse on that axis. This is a trade with two sides and I have
now priced one of them.

**Method note, recorded because it is the recurring failure.** §1–§7 were built
by grepping aggregate counts and reasoning about what the filter *would* do.
The answer took four minutes once I added a flag that asks the prover what it
*does*. `RESIDUAL-REACHED-PROVER` and `--prove-residuals` exist now for that
reason.

---

## 9. The repair proposed in §8 is refuted, and so is Note A's justification

See `notes/CLAUSE_ORDER_TRADE.md` for the full measurement. Three results, and
the first one kills §8's fix.

### 9.1 There is no third preamble — and this is a proof, not a measurement

A case tree splits **one** column at the root. So for a binary `f`, at most one
of

```
    f x zero ≡ x          f zero x ≡ x
```

can hold definitionally. This is `Certificate.hs`'s own Note B — stated there
for `max`, where the machine uses both orientations as unconditional rewrite
rules and no Agda case tree reproduces it — generalised from `max` to `+` and
`·`, where it applies for exactly the same reason.

Therefore transcribing MathMachine's `symDefs` does **not** stop the residual
stream. It **mirrors** it: the 75 artefacts become a different 75. §8 ended
"either orientation is provable on both sides and the residual stream stops
being an artefact" — the first half is true and was already true, the second
half is false, and I did not check it before writing it.

### 9.2 Note A's measurement does not survive reproduction either

Reproduced over the 42 distinct equations of `machine/library.terms`:

| preamble | certified | `refl` alone |
|---|---|---|
| first-argument (what the gate emits) | **36 / 42** | 5 / 42 |
| symDefs transcribed | **35 / 42** | 0 / 42 |

"Strictly more" is one equation. And the two arms are **one gate composed with
an involution**: run the first-argument preamble against the mirror-image
library and it certifies 35 — *the same 35*. So 36-vs-35 measures how far
`library.terms` is from being closed under the mirror, and is not a fact about
clause orders at all.

### 9.3 Both populations are circular, including mine

`library.terms` is appended only inside the kernel-accepted loop
(`MathMachine.hs:3948`), and a conjecture the machine's rewriter closes never
reaches the kernel to begin with. So the file cannot contain the zero-laws:

```
    grep -c '+(x,0)\|\*(x,0)\|max(x,0)' machine/library.terms   →   0
```

The 5–0 `refl` split is the file's own construction read back.

**And §8's 75 of 137 is confounded the same way, symmetrically.** Those 137
lemmas are, by definition, what the first-argument gate stalled on. So the
honest statement is not "55% of the mathematics the machine needs is an
artefact". It is: **55% of what this convention causes to stall is caused by
this convention** — which is nearly a tautology once said plainly, and I
published it as though it were a discovery about the machine's mathematics.
The 49 that are definitional under neither reading are the part that survives,
and they remain the real curriculum.

### 9.4 What is actually left

The lever is the one `machine/KernelContext.hs` already builds: a proved lemma
emitted as a **named checked definition** the goal can cite. That is orthogonal
to clause order — once `x + 0 ≡ x` is in scope as a citable term, which
orientation reduces definitionally stops mattering. Keep the first-argument
preamble, for compatibility rather than for mathematics: 2126 `.certcache`
entries, `library.terms` and the whole of `machine.log` were produced under it.

**The largest hole, unmeasured by either arm:** `TraceReplay` accounts for 820
of the 2362 `KERNEL-ACCEPT` lines and neither preamble exercises it. It is the
path most likely to behave differently under a transcribed `+`, and nothing
here says anything about it.

---

## 10. The whole mechanism on one goal, every link checked

`x ≡ 1 · x` is the flagship case — `Obstruction.hs`'s own header opens with its
refusal text. Here is what happens to it, end to end, with each step verified
rather than argued.

**1. The machine proves it.** `--prove-residuals`, full vocabulary, 29 rules:

```
  x = 1 * x        rewriting=False  induction=induction on x
```

Not definitional, and the prover finds the induction. Base `0 = 1·0 = 0`; step
uses the machine's `·`, which is `x · suc y = x·y + x`, and its `+`, which is
`x + suc y = suc (x + y)`. Both recurse on the **second** argument.

**2. The emitter renders it with Agda's `·`**, which recurses on the **first**:

```
    _*_ : Nat → Nat → Nat          (Agda/Builtin/Nat.agda:31)
    zero  * m = zero
    suc n * m = m + n * m
```

**3. So Agda unfolds `1 · x` to `x + 0 · x` and stalls**, which is verbatim the
line the header quotes:

```
    x != x + 0 · x of type ℕ   when checking that refl has type x ≡ 1 · x
```

Under the machine's `·` this unfolding does not arise at all: `1 · x` is `·`
applied to a *variable* second argument and simply does not reduce, so the
machine never meets this subgoal.

**4. The residual is harvested** — `x ≡ x + 0·x`, 27 occurrences.

**5. And it is dropped**, correctly, because modulo `0·x = 0` it is `x + 0 ≡ x`,
which is the machine's own defining equation for `+`.

**6. Loop closed. Nothing learned. Repeat.**

Every arrow is checked: the prover's verdict by `--prove-residuals`, the two
definitions by their source lines, the stall text by the log, the drop by
`RESIDUAL-FATE`, the count by the census.

**What this shows that §9 did not.** The clause order is not merely generating
noise alongside real work — it is generating the residual *of a goal the
machine had already proved*. The machine solved `x = 1·x` and then received,
from the kernel, a demand for a lemma it regards as an axiom, because the proof
it had was in a language the kernel reads differently. That is the whole failure
in one line, and it is why §9.4's remedy is the right shape: the kernel does not
need a different `·`, it needs `x + 0 ≡ x` in scope as a citable name.
