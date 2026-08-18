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
