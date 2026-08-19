# S4: widening the certificate language — multiplication, and the dependency chain behind everything else

**Author:** al-khwarizmi build worker, 2026-08-16. Task S4 of
`notes/D0026_BUILD_QUEUE.md` §4. This container has **no agda, no ghc, no
python**; everything below lands **AWAITING KERNEL**. A green is an exit code
or it is a rumour.

**Deliverable:** `formal/cubical/NaturalMachine/RewriteCertificateMul.agda`
(new), plus one line in `formal/cubical/NaturalMachine.agda` (root import, so
the module is not an orphan — Q8's defect). `RewriteCertificate.agda` is **not
touched**: the gate lane owns the live perimeter, and `Tm` is a closed
datatype, so the only conservative move is to mirror and then *prove* the
mirroring conservative.

---

## 0. The gap this closes, in one number

`MathMachine.start` sets `mVocab = 3` — the machine boots speaking exactly
`{0, s, +}`, which is exactly the certificate language of
`RewriteCertificate.agda`. Those two were once in sync.

They are not in sync now. `runMachine` (MathMachine.hs 2351) overwrites the
horizon with `requiredVocabulary batch`, and the current
`machine/thoughts.math` mentions `*`, `-`, `max`, `gcd` and `le`; `le` is
index 7 in `vocabulary`, so `requiredVocabulary = 8`. **The machine boots
conjecturing over eight symbols and certifying over three.** Five symbols of
the mouth have no kernel behind them. S4 closes the first of the five.

This is not the same gap as S1's. S1 (landed tonight, `S1-S3-gate-wiring.md`)
found that the live gate is no longer refl-only and that the missing piece is
*trace* expressiveness — multi-step rewriting where the 11-shape skeleton of
`Certificate.hs` allows one `cong`. S4 is orthogonal and downstream-composing:
S1 widens *how much you may say* about `{0,s,+}`; S4 widens *what you may say
it about*. The two multiply: §5b of the new module is a certificate that needs
both (a six-step trace, over `*`).

---

## 1. (a) Why multiplication first: no new trusted input

The whole vocabulary program has one hard constraint — every symbol admitted to
the certificate language must arrive with defining equations that are already
**axioms of the Haskell proof search** and already **checked against ℕ**.
Anything else smuggles a new trusted input into the kernel under cover of an
engineering task.

Multiplication is the unique symbol currently satisfying both:

| requirement | where it already is |
|---|---|
| defining equations in `symDefs` | `MathMachine.hs` 615–617: `x*0 = 0`, `x*s(y) = (x*y)+x` |
| equations audited by the firewall | `definitionAudit` (767–769) runs over all of `vocabulary` |
| equations proved against ℕ in the kernel | `HaskellDefinitionBoundary.agda` 68–74: `haskell-mul-zero`, `haskell-mul-suc` |
| symbol declared in the emitted manifest | `expectedDefinitionManifest` lines 41–42 |
| computational semantics (`symSem`) | `MathMachine.hs` 614 |

So `mul-zero` and `mul-suc` in `RewriteCertificateMul.Step` are the machine's
own axioms *re-indexed by their endpoints*. Nothing new is being trusted; the
same two equations are simply now available as certificate steps instead of
only as Haskell rewrite rules. `step-sound` for them is not new mathematics
either — it is `haskell-mul-zero` / `haskell-mul-suc` used pointwise.

By contrast `mod`, `div`, `min`, `Omega`, `omega`, `musq` have **no `symSem`
and no `symDefs`** anywhere in `MathMachine.hs`. Each is a genuinely new
trusted input, and §3 gives the order in which they can stop being one.

### 1.1 Scope fence on the library lemmas

`step-sound (mul-suc …)` cites `·-suc` and `+-comm`; `step-sound (mul-zero …)`
cites `0≡m·0`. `CERTIFICATE_REACH.md` §2 forbids the *emitted candidate module*
from citing `+-comm`/`·-comm`, because then "the engine's contribution
collapses from proof to discovery, and nothing in the log would say so."

That prohibition is not violated here, and the reason is structural rather
than a promise: **`Step` has no commutation constructor.** The library lemmas
live in the interpretation `eval : Tm → Env → ℕ`, which no certificate can
reach. A certificate is a term of `Derivation`/`HypDerivation`; the only
inhabitants are the ten `Step` constructors and the six `HypStep` ones. So
`x*1 = x` in §5b is genuinely derived from the machine's two defining
equations plus congruence and reverse — the library is used to say what `*`
*means*, never to say that the theorem is *true*.

---

## 2. (b) Ordering discipline: what LPO does, and the one thing that would break it

`precedence` (MathMachine.hs 1049–1061) is **positional in `vocabulary`**:

```
0→0   s→1   +→2   *→3   max→4   -→5   gcd→6   le→7      (invented cN → −2−N)
```

### 2.1 Both new rules are already LPO-oriented, left to right

- `*(x,0) ⇒ 0`. In `lpo (F "*" [x, 0]) (F "0" [])` the first LPO clause fires:
  the subterm `0` of the left-hand side *equals* the right-hand side. True.
  `vars r = ∅ ⊆ vars l`. `orient` returns `(l, r)`.
- `*(x,s(y)) ⇒ +(*(x,y), x)`. `precedence "*" = 3 > precedence "+" = 2`, so
  the second clause needs `lpo l t` for each argument `t` of the right side.
  `lpo *(x,s(y)) *(x,y)`: same head, `lexGt [x,s(y)] [x,y]` reduces to
  `lpo (s y) y`, true by the subterm clause. `lpo *(x,s(y)) x`: true because
  `x ∈ vars l`. Both hold; `orient` returns `(l, r)`.

**Nothing about `precedence` changes.** The `Step` constructors take these two
equations in exactly the direction LPO already orients them, so a certificate
step and a rewrite step point the same way, and `reverse` supplies the other
direction *inside* the calculus — where termination is the bounded BFS's
responsibility, not the order's. (`MathMachineInductionGate.hs` 126–128 already
states this for `add-zero`: "Reverse add-zero increases size, so the bounded
search below is the termination argument rather than an unstated orientation
heuristic.")

### 2.2 The invariant that made this free — and how to keep it

The certificate language spoke `{0, s, +}` = `vocabulary` indices **0,1,2**; it
now speaks indices **0,1,2,3**. That is a *prefix* of `vocabulary`. The prefix
property is precisely why no precedence changed and no existing rule
re-oriented.

**Discipline, stated so it survives the next widening: `vocabulary` is
append-only, and the certificate language must remain a prefix of it.**
`precedence` is positional, so *inserting* a symbol anywhere but the end
silently renumbers everything after it and re-orients every rule mentioning
those symbols — including rules already installed, already certified, and
already replayed from `library.terms` at boot. That would be a silent
soundness-adjacent regression with no log line. Appending is also what the
module's own comment asks for ("a symbol defined later outranks the ones it
was defined from"), and it is correct for the queued demands: `min` is defined
from `-`, `mod`/`div` from `-` and comparison, so all of them belong after the
symbols they are built from.

Consequence for the ordering: the next two extensions (`max` at 4, `-` at 5)
preserve the prefix property for free. `min`, `mod`, `div`, `Omega`, `omega`,
`musq` are **not in `vocabulary` at all** and must be appended at indices 8+.

### 2.3 FINDING — one new rule is infinitely branching backwards, and the BFS must be told

This is a search-completeness matter, not a soundness matter, and it is the
one place the multiplicative case genuinely differs from the additive one.

In `stepTransitions` (InductionGate 129–154), every node emits
`addZeroExpansion = (Add term Zero, Reverse (AddZero term))` — the backward
`add-zero`. That is **determined**: reversing `x + 0 → x` at a term `t` gives
exactly one successor, `t + 0`.

Reversing `mul-zero` does not behave that way. `mul-zero x : Step (mul x zero)
zero` read backwards is

```
zero  ⟶  mul X zero        for ARBITRARY X
```

— an infinite branching point at every occurrence of `zero`. A naive
transcription of the additive pattern (`mulZeroExpansion` at every node) makes
the BFS diverge at the first `zero` it meets.

**Mitigation, and it must be in the S4 Haskell hunk:** draw `X` only from the
finite set of subterms of the two goal endpoints (the standard relevant-terms
restriction). In `x*1 = x` (§5b of the module) that set is
`{var, suc var, zero, suc zero, mul var (suc zero), …}` and the needed instance
`X := var` is in it. This restricts *completeness*, never *soundness*: the Agda
side accepts `mul-zero` at any `X`, so a certificate found under the restriction
is still a certificate.

The other three new rules are safe. `reverse (mul-suc x y)` matches the
determined pattern `add (mul x y) x`; `mul-left` / `mul-right` are ordinary
congruence descents. So the branching-factor cost of S4 is: two new forward
transitions, one determined backward transition, two new context descents, and
one restricted backward transition.

---

## 3. (c) Which queued demands become expressible, and the exact chain for the rest

Current standing demands, from `machine/thoughts.math` (last six lines) and
D0026 §5 via queue §3 Q6.

### 3.1 Expressible **after S4**, with no further primitive

Everything over `{0, s, +, *}`. From `thoughts.math` that is, verbatim:

```
*(*(x,y),z) = *(x,*(y,z))          associativity of *
*(x,+(y,z)) = +(*(x,y),*(x,z))     left distributivity
*(+(x,y),z) = +(*(x,z),*(y,z))     right distributivity
*(s(s(0)),x) = +(x,x)
```

**Expressible is not provable.** Each of these needs a multi-step trace and
several need `+`-associativity/commutativity as a *lemma*, and the calculus
carries exactly **one** induction hypothesis (`HypStep ihL ihR`). Associativity
and both distributivities are three-variable statements whose successor branch
wants a previously-proved `+` fact under a context. So the honest reading is:

- S4 removes the *language* obstruction to these four;
- a **lemma environment** (a list of previously certified equations usable as
  extra `HypStep`-like constructors) removes the remaining one. That is a
  distinct, nameable item — call it **S6, lemma environment** — and
  `CERTIFICATE_REACH.md` §3 already ranked it second by measured value
  ("re-emitting previously certified lemmas as usable equations"). S4 should be
  read as making S6 worth doing, not as delivering these four.

The one thing S4 *does* deliver outright is §5b of the module: `x * 1 = x`,
proved, with `x·1 ≡ x` as a checked corollary. See §4 below for why that is
the right size of example.

### 3.2 Cheap next, and why: `max` and `-` (monus)

Both have `symDefs` (MathMachine.hs 619–629), both are at `vocabulary` indices
4 and 5 (prefix property preserved), and — the decisive point — **both are
already proved against ℕ in `HaskellDefinitionBoundary.agda` 76–93**, where
five of the six clauses are literally `refl` and the sixth is `zero∸`. Their
`step-sound` cases are therefore one line each. Neither needs a new
interpretation function: `Cubical.Data.Nat` exports `max` and `_∸_`.

`min` is then **not a primitive at all.** The residual states its own
definition:

```
min(x,y) = -(x,-(x,y))
```

so `min` is a *derived* symbol over `{-}`, exactly the `conceptRule` /
`mInvented` mechanism (MathMachine.hs 1521–1555). It needs no `Tm`
constructor, no `Step` rule and no soundness case — only monus. **`min` is
discharged by S4-next, not by a further widening.** (Recording this because it
is the kind of distinction that otherwise gets a ticket of its own for a year.)

### 3.3 The comparison/remainder chain — the machine's own firewall named it first

The `gcd` entry in `vocabulary` (MathMachine.hs 631–639) carries the comment
that settles this, and it is worth quoting because it is the machine's own
diagnosis of its own limit:

> The former recursive clause `gcd (s x) (s y) = gcd ((s x) - (s y)) (s y)` was
> false when x < y: at x=1, y=2 it asserted gcd 2 3 = gcd 0 3, hence 1 = 3. A
> correct Euclidean step needs a comparison/guard or remainder operation. Until
> the term language can express one, gcd remains computationally visible to
> conjecture generation but only its sound base cases are available to proof
> search.

(The counterexample itself is in the kernel:
`HaskellDefinitionBoundary.old-gcd-rule-fails-at-two-three`.)

The chain, in dependency order. Each arrow is "cannot be admitted before":

```
  *              ← S4 (this patch)                    [no new trusted input]
  max, -         ← next; symDefs + ℕ-proofs exist      [no new trusted input]
  min            ← derived from -, via conceptRule     [not a primitive]
  le             ← symDefs exist (639–648); ℕ-side needs `leFlag`,
                   already written at HaskellDefinitionBoundary 97–109
                   [no new trusted input, but a new eval clause]
  mod, div       ← need le AND -, AND a TOTALITY CONVENTION at y = 0,
                   AND a new symSem/symDefs pair that does not exist yet
                   [FIRST GENUINELY NEW TRUSTED INPUT]
  gcd (Euclid)   ← needs mod (or le-guarded subtraction); the two base
                   cases already admitted are sound and stay
  Omega, omega   ← need divisibility, hence mod; AND a recursion scheme
                   the calculus does not have (see 3.4)
  musq           ← μ²(n) = [Ω(n) = ω(n)]; needs Omega, omega, and equality-
                   as-a-value, i.e. le in both directions
```

Two things must be said precisely about `mod`/`div`, because they are the first
real cost:

1. **Totality convention.** `x = div(x,y)*y + mod(x,y)` is the residual's own
   demand and it is false at `y = 0` unless a convention is pinned. The
   machine's `symSem` would have to choose (`div(x,0) = 0`, `mod(x,0) = x` is
   the usual one), the firewall must audit it, and the Agda side must interpret
   it with the *same* convention. `Cubical.Data.Nat.Mod` is the candidate
   carrier and its zero convention must be **read, not assumed** before any
   `Step` is written. A mismatch here is precisely the old-gcd bug wearing new
   clothes.
2. **Recursion shape.** `mod`/`div` are not structurally recursive on `suc`;
   the natural definitions recurse on `x ∸ y` with a guard. The existing `Step`
   constructors are all "one redex of a fixed constructor shape". A guarded
   rule is a *conditional* rewrite, which the calculus has no constructor form
   for. Either the guard is compiled away (fuelled recursion, as
   `SieveRoughBridge.agda`'s `modF`/`divF` already do in this repo) or `Step`
   gains a conditional constructor — a real design decision, and the point at
   which S4-style "mirror and prove" stops being mechanical.

### 3.4 FINDING — Ω, ω, μ² are **not** a vocabulary problem

The queue (§3 Q6) files `Omega`, `omega`, `musq` alongside `div`/`mod` as
vocabulary demands. They are not the same kind of demand, and the difference
should be recorded before someone budgets them as "three more symbols".

`Tm` is a first-order term algebra over finitely many finite-arity
constructors, and `Step` is a rewrite calculus whose every rule matches a fixed
constructor pattern. Ω and ω are defined by recursion **on the factorization**,
e.g.

```
Ω(1) = 0        Ω(n) = 1 + Ω(n / lpf(n))     for n > 1
```

The argument on the right is **not a subterm** of the argument on the left, so:

- the rule is not LPO-orientable (`orient` returns `Nothing` — it is not that
  the machine would orient it badly; it cannot orient it at all);
- the BFS has no structural descent to follow;
- adding `Omega` as a `Tm` constructor buys nothing, because no `Step` can fire
  on it.

So the honest statement is: **Ω, ω, μ² need a recursion scheme, not a symbol.**
Either

- **(i)** `Tm` gains a bounded-recursion / bounded-fold combinator (a real
  extension of the *shape* of the language, with its own soundness argument and
  its own termination story), or
- **(ii)** the D0026 §5 consumers are served by **finite instances** instead —
  `Φ_n(t) = t^{Ω−ω}(t−1)^ω` and the Chen projector `1_P = μ² − (ω−1)` checked
  by exhaustive `refl` over a bounded range, which is the house pattern and
  which `CLAUDE.md` explicitly rates as proof ("a finite exhaustive
  verification … produces mathematical objects, not measurements").

Recommendation: **(ii) first.** Queue Q3's stated consumer is "land each as a
note in house form … with finite instances kernel-checked where the pattern
fits (Φ_n(t) and the Chen projector are ideal refl-certificate material)" —
that is already the queue's own preference, and it does not require the machine
to grow a new recursion scheme to serve it. Option (i) remains the right answer
if and only if the machine is to *conjecture* over Ω and ω, which is a much
larger claim than expressing D0026 §5 natively.

---

## 4. The worked certificate, and why this one

`x * 1 = x`, as a full `InductionCertificate` (module §5b). Also included: a
ground `1 * 1 = 1` `Derivation` (§5a) as the smallest interlock witness, and
the additive `accepted` example re-checked verbatim (§4 of the module).

The reason `x * 1 = x` is the right example rather than a soft one: in
MathMachine's orientation `*` recurses on the **right**, so

```
x * 1  =  x * s 0  ⟶  x * 0 + x  ⟶  0 + x
```

and **`0 + x` is irreducible in this calculus.** `add-zero` strips a zero on
the right (`x + 0 → x`); `add-suc` needs a successor on the right. Left
identity of `+` is itself an induction here. So the successor branch cannot be
closed by any one-shape skeleton; it runs six steps and has to use `mul-zero`
and `mul-suc` **backwards** to refold `0 + x` into `x * 1` so the hypothesis
can fire under a `suc` context:

```
  s x * 1
    ⟶ s x * 0 + s x            lift  mul-suc (suc var) zero
    ⟶ 0 + s x                  lift  add-left (mul-zero (suc var)) (suc var)
    ⟶ s (0 + x)                lift  add-suc zero var
    ⟶ s (x * 0 + x)            hyp-suc ∘ lift ∘ reverse (add-left (mul-zero var) var)
    ⟶ s (x * 1)                hyp-suc ∘ lift ∘ reverse (mul-suc var zero)
    ⟶ s x                      hyp-suc hypothesis
```

Base branch: `0 * 1 ⟶ 0 * 0 + 0 ⟶ 0 + 0 ⟶ 0`.

This is exactly the class `Certificate.hs`'s eleven-shape list cannot express
(one `cong`, not a trace) — i.e. it is an S1-lane theorem — and it is over a
symbol S1 explicitly excluded ("`*` is out of the calculus's vocabulary —
widening `Tm`/`Step` is S4, deliberately not smuggled in here",
`S1-S3-gate-wiring.md` §0). It is therefore the smallest object that
demonstrates S1 ∘ S4 rather than either alone.

Right-distributivity was considered and rejected as the headline example: it is
a three-variable statement whose successor branch needs `+`-associativity as a
lemma, and the calculus carries one hypothesis. It is an **S6** (lemma
environment) example, not an S4 one. Claiming it here would have needed either
a second hypothesis slot or a citation of `+-assoc` from the library — the
latter being exactly the proof-to-discovery collapse `CERTIFICATE_REACH.md` §2
forbids.

---

## 5. (d) Migration path: this module IS S3's retry event

`S1-S3-gate-wiring.md` §3.1 defines

```haskell
kCertificateLanguageVersion :: Int          -- Certificate.hs, next to kMaxAgdaCalls
kCertificateLanguageVersion = 2   -- 1: refl + skeleton; 2: + S1 derivation search

certLanguageEpoch :: Machine -> Int         -- MathMachine.hs, near usableRules
certLanguageEpoch m = 1000 * C.kCertificateLanguageVersion + length (mInvented m)
```

and stores that epoch in every `mUnspeakable` entry, retrying an entry **iff
the epoch changed** — "more rules do not widen the kernel's mouth, only a wider
language does."

S4 is a wider language. The migration is therefore three mechanical facts and
one theorem.

### 5.1 The bump

```diff
-kCertificateLanguageVersion = 2   -- 1: refl + skeleton; 2: + S1 derivation search
+kCertificateLanguageVersion = 3   -- 1: refl + skeleton; 2: + S1 derivation
+                                  -- search; 3: + S4 multiplication in Tm/Step
```

One line, hand-bumped, in the same place S3 put it. Every `mUnspeakable` entry
stamped `2xxx` now differs from `certLanguageEpoch` and is retried exactly
once — which is the whole point of the S3 split. The `*`-shaped rejections
listed in `CERTIFICATE_REACH.md` §1 (`(s(x)*y) = (y+(y*x))`, `(x*(y*z)) =
(x*(z*y))`, `s(s((x*y))) = s(s((y*x)))`, `(x*y) = (y*x)`, and the invented-concept
one) are precisely the population this retry re-presents to the kernel.

**Prediction discipline:** do not predict how many of them clear.
`CERTIFICATE_REACH.md` §4 already states the rule for this exact measurement —
"the count after each step must be re-measured with the same self-test, not
predicted." Commutativity in particular is expected to stay rejected until S6,
because one hypothesis slot is not enough; that is stated here so nobody
records it later as a regression.

### 5.2 The three Haskell edits (S4's own hunks, for the gate lane)

1. **`InductionSearch.hs`** (S1.0's extraction) gains, additively:
   `Term` ← `Mul Term Term`; `StepCertificate` ← `MulZero Term`,
   `MulSuc Term Term`, `MulLeft StepCertificate Term`,
   `MulRight Term StepCertificate`; `HypStepCertificate` ← `HypMulLeft`,
   `HypMulRight`; matching `renderTerm`/`renderStep`/`renderHypStep` arms;
   `termSize` and `substituteX` arms; and the transitions of §2.3 above —
   **with the relevant-subterms restriction on backward `mul-zero`**, which is
   the only non-mechanical line in the whole hunk.
2. **`renderModuleNamed`** changes exactly one string:
   `NaturalMachine.RewriteCertificate` → `NaturalMachine.RewriteCertificateMul`.
   Everything else in the emitter is byte-identical, because the new Agda
   module uses **the same names for the same constructors**. That was a
   deliberate interface constraint, and it is why S4 is an additive diff on top
   of S1 rather than a fork of it.
3. **The translation guard** in the rescue lane admits `F "*" [a,b] ↦ Mul`
   alongside `+`/`s`/`0`. S1's fail-closed reasoning survives verbatim:
   "`Untranslatable` gets no rescue on purpose: the BFS vocabulary `{0,s,+}` is
   a strict subset of the emitter's" — after S4 it is `{0,s,+,*}`, still a
   strict subset of the emitter's eight, so the implication is unchanged.

### 5.3 What does **not** need migrating, and the theorem that says so

S2's boot replay re-admits `library.terms` through the kernel at start. A
natural fear on a language change is that the replay must be re-litigated, or
that rules installed under language 2 are now of doubtful status.

They are not, and this is checked rather than asserted. Module §6 proves:

```agda
embed              : A.Tm → Tm
embed-eval         : (t : A.Tm) (ρ : Env) → eval (embed t) ρ ≡ A.eval t (toBase ρ)
embed-step         : A.Step a b → Step (embed a) (embed b)
embed-derivation   : A.Derivation a b → Derivation (embed a) (embed b)
embed-hyp-step     : A.HypStep ihL ihR a b → HypStep (embed ihL) (embed ihR) (embed a) (embed b)
embed-hyp-derivation, embed-certificate, embed-certificate-sound
```

i.e. **every certificate the additive kernel ever accepted is a certificate
here, over the embedded endpoints, with the same meaning.** So:

- widening cannot retroactively unsay anything installed;
- the replay needs no epoch awareness for *accepted* rules;
- only `mUnspeakable` — the things the kernel could not say — is reopened, and
  reopening exactly that set is what S3's split was built to make possible.

Conservativity is the reason S4 can be a mirror module at all rather than a
migration. Without it, "conservative extension" is a word in a commit message.

### 5.4 Controls the toolchain-bearing session must run

Nothing here is claimed green. In order:

1. `agda --library=cubical formal/cubical/NaturalMachine/RewriteCertificateMul.agda`
   — exit 0, no postulates, no holes (the file has neither by construction; the
   `--safe` flag is on).
2. `machine/check-natural-machine.sh` (or the root
   `formal/cubical/NaturalMachine.agda`) — the new root import must not turn it
   red. **If it does, the finding outranks the module**: fix or drop the import
   line and record it; do not leave the root red.
3. Only then the Haskell hunks of §5.2, then `Certificate.hs`'s self-test
   against `machine/library.snapshot.txt`, re-measured, with the before/after
   counts reported and *not* predicted.
4. A negative control for the widening: a false `*`-equation (e.g.
   `x*(s y) = x*y`) must still be refused by the firewall and, if it reaches
   the gate, by the kernel.
5. A negative control for §2.3: run the BFS on a goal containing `zero` with
   the relevant-subterms restriction **disabled**, and confirm it diverges /
   exhausts the node budget. If it does not, my §2.3 analysis is wrong and that
   is the finding.

---

## 6. Honesty ledger

- **AWAITING KERNEL.** No agda, no ghc, no python in this container. The Agda
  module is written to typecheck and is hand-checked step by step (every
  `Step`/`HypStep` index in §5a and §5b was verified against its constructor
  signature by hand), but hand-checking is not the kernel.
- **The Haskell hunks of §5.2 are specified, not written.** S1's own rule — "a
  blind edit to the live Haskell on main is not acceptable" — applies with
  equal force here, and the gate lane owns `InductionSearch.hs`. The one line
  I did land outside the new module is the root import in
  `formal/cubical/NaturalMachine.agda`, with an AWAITING KERNEL comment on it.
- **No count is claimed** for how many of the 13 snapshot rejections clear.
- **§2.3 (infinite backward branching of `mul-zero`) and §3.4 (Ω/ω/μ² are a
  recursion-scheme problem, not a vocabulary problem) are the two findings**
  that a mechanical reading of the task would have missed. Both are stated so
  they can be refuted; §5.4 control 5 is the refutation procedure for the
  first.
- **Prior art searched before writing**, per `CLAUDE.md`:
  `HaskellDefinitionBoundary.agda` (the ℕ-side multiplication proofs — reused,
  not re-derived), `ConservativePrimitiveExtension.agda` (the general
  signature-extension machinery — deliberately *not* used: it is a different,
  more abstract object, and mirroring the concrete `Tm`/`Step` is what keeps
  the Haskell renderer diff to one string), `CERTIFICATE_REACH.md` (the
  argument-order finding, which turned out to be the exact cost of `mul-zero`
  and `mul-suc` soundness), `S1-S3-gate-wiring.md` (epoch semantics, and its
  explicit hand-off of `*` to S4).

*— al-khwarizmi, build worker, 2026-08-16*
