# The clause-order trade, both sides, with the numbers

**2026-08-18.** `machine/Certificate.hs` Note A records a measurement with no
number and no reproduction. `notes/THE_SEAM_ASKS_THE_WRONG_NAYA.md` §8 — called
**SEAM §8** below, so that it is never confused with a section of this note —
priced the opposite side of the same trade and said, correctly, that Note A's
side had not been re-run and might come out worse. This note re-runs it.

Both numbers are here. Neither of them licenses the choice, and the reason
is more interesting than either number: **each was measured on a population
that its own standpoint generated.** The third section is the part that
matters.

New file: `machine/ClauseOrder.hs` (importable, `module ClauseOrder`, no
Python, nothing under `formal/cubical/` or `machine/MathMachine.hs` touched).

---

## 1. What Note A says, and what was missing from it

`machine/Certificate.hs`, header, Note A:

> Agda's `+` and `·` recurse on the FIRST argument; MathMachine's symDefs
> recurse on the second (x+0=x, x+s y = s(x+y)) … The clause order differs
> only in which equations hold *definitionally*, and the first-argument order
> was measured to certify strictly more of the machine's library than a
> transcription of the symDefs would (it makes `(s x + y) = s (x + y)` and
> `(s x · y) = y + x · y` refl, which the second-argument order does not).

Which symbols the emitted preamble **transcribes** from MathMachine's own
`symDefs` and which it **imports**, read off `Certificate.preambleCore` and
`Certificate.preambleWith` directly:

| symbol | where it comes from in the emitted module | clause order |
|---|---|---|
| `zero`, `suc` | `Cubical.Data.Nat` | identical to symDefs |
| `_+_` | `Cubical.Data.Nat` (= `Agda.Builtin.Nat`) | **Agda's — first argument** |
| `_·_` | `Cubical.Data.Nat` | **Agda's — first argument** |
| `_∸_` | `Cubical.Data.Nat` | agrees with the symDefs clause for clause |
| `max` | **LOCAL**, `preambleCore.localMax`, transcribed from symDefs | machine's |
| `le` | **LOCAL**, `preambleCore.localLe`, transcribed from symDefs | machine's |
| `gcd` | `Cubical.Data.Nat.GCD`, only when the equation needs it | reduces on no open term |
| invented `cN` | **LOCAL**, `preambleWith.emit`, from the caller's `Definition`s | the machine's own |

So the emitted module is already a **mixture of standpoints**: `max`, `le`
and every invented concept speak the machine's clause order; `+` and `·`
speak Agda's; `∸` happens to be the same sentence in both languages. Note A's
claim is about `_+_` and `_·_` alone, and it carried no count.

---

## 2. Method — the two arms, and the one line that separates them

`ClauseOrder.hs` runs the gate's own search twice, over the same equations,
with one line of the preamble different and nothing else.

`Certificate.preambleCore` emits

```
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)
```

**Arm (i), `FirstArg`** — verbatim `Certificate.agdaCertificateWith` /
`Certificate.agdaInductionCertificate` output. This is what the gate emits
today.

**Arm (ii), `SecondArg`** — the same emitter's output with exactly that one
line replaced by nine (`ClauseOrder.retune`, `ClauseOrder.transcribedPreambleLines`):

```
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _∸_)
infixl 6 _+_
infixl 7 _·_
_+_ : ℕ → ℕ → ℕ
a + zero = a
a + (suc b) = suc (a + b)
_·_ : ℕ → ℕ → ℕ
a · zero = zero
a · (suc b) = (a · b) + a
```

which is `MathMachine.hs:722–727` transcribed clause for clause, in that
order. The names are **shadowed, not renamed**, so every term
`Certificate.agdaTermWith` renders, every proof term, the telescope, the
`max`/`le`/`gcd` transcriptions and the `--safe` line are byte-identical
across the two arms. That is the whole experimental control.

A worked example — the flagship residual `x ≡ x + 0`, which the seam harvested
27 times and submitted to the kernel 0 times:

| arm (i) | arm (ii) |
|---|---|
| `candidate : (x : ℕ) → x ≡ (x + zero)` | `candidate : (x : ℕ) → x ≡ (x + zero)` |
| `candidate x = refl` — **rejected** | `candidate x = refl` — **accepted** |

`∸` is left as the builtin in **both** arms. Certificate's header already
establishes that MathMachine's `-` symDefs and `Agda.Builtin.Nat._-_` are the
same clauses in the same order; varying it would confound the measurement.

**Population.** The 42 distinct equations of `machine/library.terms` (97
lines; 42 distinct left/right pairs; 0 unparsed), the machine's real proved
library. Plus `Certificate.falsehoods`, all four, in both arms.

**Search protocol, identical in both arms.** For each equation: the gate's own
search (`refl`, then the induction skeleton with each of
`Certificate.stepShapes`, stopping early when agda blames the base clause),
run once per variable of the equation in ascending index order, first success
wins. Trying **every** variable rather than only `x` is the point at which a
careless protocol hands the answer to one arm: the disagreement is about which
argument column reduces, so a search fixed to one induction column is not
neutral.

No verdict is read from or written to `machine/.certcache`; `ClauseOrder`
calls `Certificate.runAgda`, not `runAgdaCached`. Identical module sources
inside one run are memoised in process, which changes no verdict.

---

## 3. Side A — Note A's number, reproduced

Over the 42 distinct equations of `machine/library.terms`:

| | certified | of 42 | of the 97 lines |
|---|---|---|---|
| **(i) `FirstArg`** — Cubical's `_+_`, `_·_` | **36** | 86% | 86 |
| **(ii) `SecondArg`** — symDefs transcribed | **35** | 83% | 85 |

| | refl **alone** (definitional) |
|---|---|
| (i) `FirstArg` | **5** / 42 |
| (ii) `SecondArg` | **0** / 42 |

Certified by **(i) only**, 4 equations:

```
0                 = *(le(x,0),x)
le(x,+(x,y))      = s(0)
*(s(x),y)         = +(y,*(x,y))        ← Note A's own example
+(x,y)            = max(+(x,y),x)
```

Certified by **(ii) only**, 3 equations:

```
0                 = *(x,le(x,0))       ← the mirror of (i)'s first
le(x,0)           = le(+(x,y),y)
le(+(x,y),+(z,y)) = le(x,z)
```

Definitional in (i) only, 5 equations (definitional in (ii) only: none):

```
x                 = +(0,x)
0                 = *(0,x)
s(x)              = +(s(0),x)
+(s(x),y)         = s(+(x,y))          ← Note A's other example
*(s(x),y)         = +(y,*(x,y))
```

Falsehood controls: 4/4 refused in arm (i), 4/4 refused in arm (ii).
`Certificate.kernelIsChecking` PASS. So neither positive count is the output
of a checker that had stopped checking.

**Note A's word "strictly" survives. Its force does not.** The margin is one
equation out of 42, and it is not a margin in the sense of one arm dominating:
four equations swap one way and three the other. Note A's two cited examples
are both real — they are in the "definitional in (i) only" list — but being
definitional and being certifiable are different, and the gate's induction
search recovers `+(s(x),y) = s(+(x,y))` in arm (ii) anyway (`induction on y,
step = cong suc`).

---

## 4. Side B — SEAM §8's number, reproduced

SEAM §8's number, re-run here from the committed log:

```
distinct lemmas the kernel's refusals demand: 137
definitional under the MACHINE's clause order:  87
definitional under AGDA's clause order:         13
definitional under machine ONLY:                75
definitional under agda ONLY:                    1
genuine missing mathematics on both readings:   49
```

75 of 137 — 55% — of the lemmas the residual stream demands exist **only**
because the two standpoints disagree about `+` and `·`. The mirror class is
1.

**Methodological difference worth stating, since the two sides are being put
next to each other.** Side A asks *agda* (one process per module, exit
status). Side B asks the *machine's rewriter* with the two clause sets
substituted (`provedByRewriting theirs` vs `provedByRewriting mirrored`,
`MathMachine.hs:4735–4736`). The rewriter is not agda: it applies rules at
any position on open terms with no precedence, so it is strictly stronger
than definitional unfolding, and §6 explains why that gap cannot be closed by
any choice of clauses. Side B's 87 and 13 are therefore upper bounds on what
the corresponding preamble would make `refl`-true, not the counts agda would
give. Nobody has re-run side B against agda, and this note does not.

---

## 5. Both numbers are confounded, in opposite directions

This is the finding. Neither published number is a fact about the clause
orders; each is a fact about a population its own standpoint produced.

**Side A's population is selected twice in arm (i)'s favour.**

1. `machine/library.terms` is appended **only inside the kernel-accepted
   loop** — `forM_ checkedWithNaya` at `MathMachine.hs:3948–3965`. Every one
   of the 42 equations passed the kernel under the first-argument preamble
   already — through either the `Certificate` search this note re-runs, or
   `TraceReplay`, which it does not. The population is arm (i)'s own accept
   set.

2. Worse, and this is the one that shows up as a 5–0: a conjecture the
   machine's **rewriter** closes never becomes a theorem. `MathMachine.hs`
   says so at line 3452, in the comment on `rewriterSays`:

   > the highest-leverage lemmas in the curriculum are `x·0 = 0`, `0 = y·0`
   > and `x = x+0`, and every one of them is a DEFINING EQUATION of the
   > machine's own vocabulary. `provedByRewriting rules c` therefore
   > discharges them, they never reach `fresh` …

   The machine's defining equations *are* the second-argument clause order.
   So `machine/library.terms` is, by construction, disjoint from the set of
   equations that hold definitionally under arm (ii). The measured
   **0 / 42** is not evidence that the second-argument order makes fewer
   things definitional; it is the construction of the file, read back.

   Two greps over the committed file settle it:

   ```
   $ grep -c '+(x,0)\|\*(x,0)\|max(x,0)' machine/library.terms
   0
   $ grep -c '+(0,x)\|\*(0,x)' machine/library.terms
   2
   ```

   The machine's own defining orientations appear **zero** times in its
   library; Agda's appear. `x = +(0,x)` is line 1 of `library.terms` and
   `x = +(x,0)` is nowhere in it — not because the machine cannot prove it,
   but because its rewriter closes it before it can become a conjecture.
   Measuring "which clause order makes more of this file definitional" on
   this file is measuring the filter that built it.

**Side B's population is selected in arm (ii)'s favour, by the mirror-image
mechanism.** The 137 lemmas are extracted from `KERNEL-REJECT` lines — i.e.
they are, by definition, exactly what arm (i) got *stuck on*. That a residual
harvested from arm (i)'s stalls is rarely definitional under arm (i) is not a
discovery; it is what "residual" means. 87 vs 13 is that tautology with a
number on it.

Each side measured the other standpoint on its own home ground and reported
a win. This is the *durnaya* the Jain logicians named — a naya is not false,
it becomes a *durnaya* by asserting itself as the whole view (Siddhasena
Divākara, *Sanmatitarka*; Samantabhadra, *Āptamīmāṃsā*). The offending word
in Note A is not "measured", it is "**only**": *"the clause order differs
only in which equations hold definitionally."* Which equations hold
definitionally is which residuals get produced, is the whole curriculum. SEAM §8
already made that point about Note A. It applies to SEAM §8's own number
symmetrically, and SEAM §8 did not say so.

---

## 6. There is no third preamble — this part is a proof, not a measurement

SEAM §8's proposed repair is: transcribe the symDefs "so that the two standpoints
share a definition rather than sharing only a name. Then either orientation
is provable on both sides and the residual stream stops being an artefact."

The first clause is true and was already true — both orientations are
*provable* in both arms, by induction, which is what §3's 36 and 35 count.
The second clause is false, and it is false for a reason no measurement is
needed for.

**Proposition.** Let `f : ℕ → ℕ → ℕ` be defined in Agda by a case tree whose
root splits on one of its two arguments. Then at most one of `f x zero ≡ x`
and `f zero x ≡ x` is closed by `refl` for a free variable `x`.

*Proof.* Weak-head reduction of an application of `f` at the root of its case
tree requires the argument in the split column to be in constructor form. If
the root splits column 1, then in `f x zero` that column holds the free
variable `x`, which is neutral; the application is stuck, `f x zero` is its
own whnf, and it is not syntactically `x`. Symmetrically for column 2 and
`f zero x`. ∎

The residual case — a definition with no split at all, `f a b = t` — is not
an escape. If `t` is built only from `a`, `b`, `zero`, `suc`, then `t` is
`sucᵏ(s)` with `s ∈ {a, b, zero}`, and no such `t` satisfies **both**
equations: `t = a` gives `f x zero ⟶ x` but `f zero x ⟶ zero`; `t = b` gives
the reverse; `t = zero` and any `k > 0` give neither. If `t` delegates to
another defined function,
the same argument applies at that function's root, and the delegation chain
is finite. *(Stated as a sketch: I have checked the root-split case
rigorously and the delegation case by induction on the call graph, and I have
**not** ruled out an exotic `--cubical` definition using `transp`/`hcomp`
rather than pattern matching. That gap is real and is not closed here.)*

This is `Certificate.hs`'s own Note B, generalised. Note B already says it for
`max`: *"No Agda case tree reproduces MathMachine's `max` reductions exactly
… a case tree must commit to splitting one column first."* The same sentence
settles `+` and `·`, and settles them against the possibility of a preamble
that wins on both axes.

In the vocabulary this repository has been using: successive assertion of the
two standpoints (*krama*, the third bhaṅga) is available — it is exactly what
this measurement did, two modules, one per preamble, and both typecheck.
Simultaneous assertion (*sahārpaṇa*, the fourth — *avaktavyam*) is not
available from a case tree. SEAM §8's repair asks the fourth position of a
mechanism that can only give the third. That is not a bug in the repair; it
is the shape of the object.

The machine's **rewriter** does give the fourth position — `max(x,0) → x` and
`max(0,x) → x` are both installed, unconditionally, on open terms — which is
precisely why the rewriter and the kernel cannot be made to agree by choosing
a preamble. It is also why `Certificate.hs`'s Note B calls that "a real
residual gap".

**Where the difference actually lives, stated in the older vocabulary that
has a word for it.** Both the rewriter and the case tree are rule systems
with overlapping rules; they differ in their *conflict-resolution metarule*.
Pāṇini's *Aṣṭādhyāyī* names the choices explicitly: *vipratiṣedhe paraṁ
kāryam* (A 1.4.2) — where two rules of equal scope conflict, the later
prevails — and *utsarga/apavāda*, where a specific rule blocks a general one
independently of order. A case tree is a system with a conflict metarule
(earlier clause wins, after committing to a split column), so `max a zero = a`
and `max zero b = b` cannot both fire on an open term: the second is dead
wherever the first's column is neutral. MathMachine's rewriter is a system
with **no** conflict metarule — both equations are unconditional rewrite
rules in both argument positions — which is why it is strictly stronger here
and why no amount of choosing a clause order will make the kernel match it.
The gap between the two standpoints is not the *order* of the clauses; it is
that one system has a precedence rule and the other does not. Choosing arm
(i) or arm (ii) permutes which equations fall on the dead side of the
precedence rule. It does not remove the precedence rule.

---

## 7. The involution test — a prediction, made before the run

Arm (ii)'s `+` and `·` are arm (i)'s with the two argument columns exchanged,
clause for clause. Let `mirrorTerm` be the involution that swaps the
arguments of every `+` and `*` node and fixes everything else.
`Certificate.stepShapes` is closed under it (the four `cong`-section shapes
come in left/right pairs; `refl`, `ih`, `cong suc` are fixed) and the search
above tries every induction variable, so the search is closed under it too.

**Prediction, printed with its outcome either way:** arm (i) run on
`mirrorTerm`-image of the library certifies exactly what arm (ii) certifies
on the library itself — same count, same equations up to the mirror. If it
holds, the difference in §3 is a measurement of how far
`machine/library.terms` is from being closed under the mirror, and of nothing
else.

**Outcome: the prediction HELD, exactly.**

```
  arm (i) on mirror(library): 35 / 42
  arm (ii) on library:        35 / 42
  PREDICTION HELD: same equations, up to the mirror.
```

Not merely the same count — the same set:
`{ e : mirror(e) certifies under arm (i) }` = `{ e : e certifies under arm (ii) }`,
all 35, checked as sets rather than as totals
(`ClauseOrder.main`, the `agree` binding).

**This is the strongest statement in the note.** The two arms are one gate
composed with an involution of the term language. There is no sense in which
one of them is a better checker; they are the same checker looking at the
mirror. Consequently the 36-vs-35 of §3 measures exactly one thing: **how far
`machine/library.terms` is from being closed under `mirrorTerm`.** Four
equations in it have their mirror image missing one way, three the other.
That is a fact about a file, not about a clause order, and it is the entire
content of Note A's "strictly more".

Corollary, and it is the practically useful one: a measurement of this trade
taken over a population closed under `mirrorTerm` should come out **tied**.
So the question "which clause order certifies more?" has no answer that is
not an answer about the sample. The right question is the one §6 settles and
SEAM §8 restates.

*Scope, honestly.* What is established is the set equality above, over these
42 equations, in a run anyone can repeat with the command in §10. The
corollary is the involution argument extrapolated; I
have not proved that agda's reduction and unification are equivariant under
`mirrorTerm` in general, only that `Certificate`'s emitter, its step shapes
and this search are, and that the one population tested behaved accordingly.
A population where it failed would be a genuine and interesting refutation
and the test above is written so anyone can run it.

---

## 8. Conclusion — what this supports and what it refutes

**Against the repair I was asked to price.** Transcribing the symDefs does
*not* make the residual stream stop being an artefact. It **mirrors** the
artefact. Under arm (ii) the kernel stalls on `0 + x ≡ x` and `0 · x ≡ 0`
instead of on `x + 0 ≡ x` and `x · 0 ≡ 0` — the measured refl sets are 5 and
0 on this file, and §7 shows the two arms are mirror images, so the stalls
are too. (`max` and `le` are unaffected: they are transcribed from the
symDefs identically in both arms.) SEAM §8's sentence "then
either orientation is provable on both sides and the residual stream stops
being an artefact" is half right and the important half is wrong.

**Against Note A.** "Strictly more" is 36 vs 35 out of 42, on a population
constructed out of arm (i)'s own kernel acceptances and disjoint by
construction from arm (ii)'s definitional set. The word "strictly" is
defensible; the sentence is not usable as a reason, because the measurement
does not distinguish the clause orders from the population.

**Both numbers should be published side by side, and neither should decide
anything.** They are:

| standpoint | its number | its population | who generated that population |
|---|---|---|---|
| Note A (this note, §3) | 36 vs 35 of 42 certified; 5 vs 0 definitional | `machine/library.terms` | arm (i), twice over |
| SEAM §8 (this note, §4) | 87 vs 13 of 137 definitional; 75 vs 1 exclusive | `KERNEL-REJECT` residuals in `machine/machine.log` | arm (i)'s stalls, i.e. arm (ii)'s home ground |
| neither (this note, §7) | **35 vs 35** | the same 42, mirrored | the involution — the only neutral population tested |

**What actually follows.** The choice of preamble is not the lever. §6 shows
no preamble makes both orientations definitional, so any preamble leaves a
residual class where it removed one; §7 shows the two arms are one gate seen
through a mirror; §3 shows the certification counts barely move. The lever is
the one `machine/KernelContext.hs`
already builds: put the missing orientation into the module **as a named,
checked lemma**, once, so that `plusZero` is in scope and the stall does not
recur. That is orthogonal to the clause order and it is the only move in this
area that is not a rotation.

If the decision has to be made anyway, the honest ranking is: **keep arm (i)**
— and for a reason that is not mathematical and should not be dressed as one.
One equation out of 42, measured on arm (i)'s own home ground, is not a
mathematical reason. What is a reason: every entry in `machine/library.terms`,
every `KERNEL-ACCEPT` line in `machine/machine.log`, and every one of the 2126
entries in `machine/.certcache` was produced under arm (i). Those records stay
true of the past under either choice, but under arm (ii) none of them is
reproducible by the gate that then exists, and the whole cache misses. That is
a compatibility argument. Note A stated a compatibility-sized fact in
mathematical clothes, which is why SEAM §8 had to spend a session finding out what
it had cost.

---

## 9. What is NOT shown

- **Not shown: that either preamble makes the obstruction seam pay.** Nothing
  here submits a residual to the kernel. SEAM §8's claim that the seam has never
  paid stands untouched.
- **Not shown: anything about the trace-replay emission path.** Of the 2362
  `KERNEL-ACCEPT` lines in `machine/machine.log`, **820** name `trace
  replay`, i.e. came from `MathMachine.tryReplay` →
  `TraceReplay.replayWithRules`, which emits a module citing the machine's own
  lemmas by name. Neither arm here exercises it. A replay module *is* a
  derivation in the machine's clause order, so it is the path most likely to
  behave differently under arm (ii) — plausibly much better — and that is
  untested. This is the largest hole in this note.
- **Not shown: any effect of the clause order on `∸`, `max`, `le`, `gcd`.**
  These are identical in both arms by construction.
- **Not shown: stability of the 36–35 gap under a wider search.** The search
  is `refl` plus 12 fixed step shapes with `kMaxCongArguments = 2`. One more
  step shape could move the gap either way. The gap is one equation; four
  equations swap one way and three the other; nothing here establishes an
  ordering that survives a change of budget.
- **Not shown: that `--cubical` cannot define a `+` making both orientations
  definitional.** §6's proposition covers case trees. A definition built from
  `transp`/`hcomp` is not covered. I believe none exists; I have not proved
  it.
- **Not shown: what agda says about side B's 137 lemmas.** §4's counts come
  from the machine's rewriter with the two clause sets substituted, not from
  agda. Re-running side B through the two preambles here would be the natural
  companion measurement and is not done.
- **Not measured: the 98 distinct claims on the 2362 `KERNEL-ACCEPT` lines of
  `machine/machine.log`.** That population is larger than 42, but it is
  selected by arm (i) acceptance even more directly than `library.terms` is,
  and it is written in MathMachine's `Show` notation, for which no exported
  parser exists (`Obstruction.parseAgdaTerm` reads Agda's notation,
  `KernelContext.parsePrefixTerm` reads `showTermP`'s). Adding a ninth reader
  for the same term type to measure a more biased population was not worth
  it. Stated so the omission is a decision, not a gap someone finds later.

---

## 10. Commands and exit codes, exactly as observed

Agda 2.6.3. Repository root `/home/user/math`. Every arm's individual kernel
call is `Certificate.agdaArgs`, i.e.

```
agda -i formal/cubical -i <tmpdir> --library=cubical <tmpdir>/Candidate.agda
```

with `cwd` = repository root and `LC_ALL=LANG=C.UTF-8` forced in the child.
Exit 0 = certified.

**Side A** (this note's new measurement):

```
$ mkdir -p /tmp/clause-order-build
$ ghc -O0 -imachine -outputdir /tmp/clause-order-build \
      -o /tmp/clause-order-build/clause-order \
      -main-is ClauseOrder machine/ClauseOrder.hs
[6 of 6] Linking /tmp/clause-order-build/clause-order          exit 0

$ /tmp/clause-order-build/clause-order .
  ClauseOrder — reproducing Certificate.hs Note A, both sides.
  kernel controls (Certificate.kernelIsChecking): PASS
  machine/library.terms: 97 lines, 97 parsed, 42 distinct equations, 0 unparsed
  …
  == COUNTS ==
  distinct equations: 42
  (i)  FirstArg  certified 36 / 42   (86 of 97 library.terms lines)
  (ii) SecondArg certified 35 / 42   (85 of 97 library.terms lines)
  (i)  FirstArg  refl alone  5 / 42
  (ii) SecondArg refl alone  0 / 42
  (i)  FirstArg  on mirror(library) 35 / 42   involution prediction HELD
  certified by (i) only:  4
  certified by (ii) only: 3
  agda processes launched this run: 409

  falsehoods: 4/4 refused in arm (i), 4/4 refused in arm (ii)
  CLAUSE ORDER TRADE MEASURED                                   exit 0
```

409 agda processes, 5 m 38 s wall clock, everything cold (no `.certcache`
read or written).

Run four times during development, each from a cold cache. Exactly what was
reproduced, stated rather than implied: the certification counts 36 and 35
and the two difference sets (4 and 3 named equations) came out identical in
all four runs; the refl-only counts 5 and 0 in the three runs that computed
them; the involution outcome HELD in the two runs that computed it. The only
figure that changed between runs was the reported *process count*, because
the first version of the reporting double-counted each equation's last
attempt and omitted the refl and mirror passes from the total. Both were
reporting bugs, both are fixed, and the wrong numbers (395) are named here
rather than quietly replaced.

**Side B** (SEAM §8's measurement, reproduced):

```
$ mkdir -p /tmp/mm-build
$ ghc -O0 -imachine -outputdir /tmp/mm-build -o /tmp/mm-build/mm \
      machine/MathMachine.hs
[12 of 12] Linking /tmp/mm-build/mm                             exit 0

$ LC_ALL=C.UTF-8 /tmp/mm-build/mm --convention-cost
  distinct lemmas the kernel's refusals demand: 137
  definitional under the MACHINE's clause order:  87
  definitional under AGDA's clause order:         13
  definitional under machine ONLY (pure artefact of the split): 75
  definitional under agda ONLY:                   1
  genuine missing mathematics on both readings:   49        exit 0
```

Nothing was committed and `./sync` was not run.
