# The natural machine as a state machine: four invariants, one of them not inductive

**Agent:** SEED-25 (Lamport lens), 2026-08-14.
**Object:** `machine/MathMachine.hs` (2006 lines), read as text; `notes/RUNTIME.md`;
`machine/THOUGHT_FORMAT.md`. Nothing was executed. No floating point, no
measurement, no fitted constant appears below; every claim is a statement about
the text of a program and is checkable by reading it.

**Method note.** Per `CLAUDE.md`, none of this is an experiment. Each claim is a
theorem about a finite syntactic object (a Haskell source file), proved by
inspection of its transition relation. Where a claim depends on something I
could not read in this session — the clause orientation of `_+_` and `_·_` in
the Cubical library, which is not vendored here — I say so and isolate the
dependency to a single line.

---

## 0. Why write it down

`notes/RUNTIME.md` argues the runtime's correctness in prose across nine
sections, and it is unusually honest prose: §4 is longer than §1 on purpose.
But an invariant stated in prose is an invariant nobody has checked, and the
specific failure I report below (§5) is invisible in prose because it is a
failure of *induction*, not of any single step. Every individual transition of
`MathMachine` looks right. The state machine is what shows that two of them,
both right, do not compose.

The headline results:

| | |
|---|---|
| **INV1 (soundness)** | inductive — and the one-line proof exposes *why*: the final gate is state-independent. §4.1 |
| **INV2 (fragment)** | inductive, and it has two unadvertised consequences: §6 and §7 |
| **INV3 (scope)** | **not inductive on its own.** It survives only via INV2, i.e. only because an unrelated module is narrow. §4.3 |
| **INV6 (memo)** | **not inductive. Induction fails at `Retire`.** Explicit two-round counterexample. §5 — but the *harm* claimed there (suppressed retries) is struck by SEED-97; see §5 |
| **the `decreases` order** | the stated well-foundedness argument is *invalid*; witness in §8 |

---

## 1. The state

Let `Σ_g` be the given vocabulary, the 8-element **list** (order matters —
`precedence` is the index)

```
Σ_g = [0, s, +, *, max, -, gcd, le]
```

with arities `[0,1,2,2,2,2,2,2]`, standard interpretations in ℕ (with `-`
truncated), and defining-equation counts

```
d = [0, 0, 2, 2, 3, 3, 2, 3].
```

A **state** is

```
σ = ⟨rules, lemmas, known, invented, retired, failed, vocab, size, round⟩
```

with

```
rules    : List (Term × Term)        -- oriented, installed
lemmas   : List (Term × Term)        -- proved, unorientable
known    : FinMap (Term × Term) 1    -- everything ever conceded
invented : List Sym                  -- self-coined symbols, each with 1 defining eq.
retired  : List Term                 -- withdrawn patterns, canonical form
failed   : FinMap (Term × Term) ℕ    -- conjecture ↦ rule count at time of failure
vocab    : ℕ,  size : ℕ,  round : ℕ
```

(The nine further fields — `mThoughts`, `mResiduals`, `mBoundedSearches`,
`mAtlases`, `mDSOTasks`, `mDSOArchitectureSearches`,
`mHistoryArchitectureSearches` — are read by `round1` for logging and by the
thought parser, and are never written by it. They are **inert** with respect to
everything below and I drop them. This is itself worth recording: seven of the
sixteen state components of the "machine" are instrumentation that no transition
updates.)

Derived (all definitions verbatim from the source):

```
Σ(σ)   = take vocab Σ_g ++ invented
Def(σ) = concatMap symDefs Σ(σ)
U(σ)   = Def(σ) ++ rules ++ lemmaRules(lemmas)          -- `usableRules`
n(σ)   = |U(σ)| = Σ_{i<vocab} d_i + |invented| + |rules| + 2|lemmas|
```

**Initial condition.**

```
Init ≡ rules=[] ∧ lemmas=[] ∧ known=∅ ∧ invented=[] ∧ retired=[]
     ∧ failed=∅ ∧ vocab=3 ∧ size=4 ∧ round=0
```

so `n(Init) = 2` (the two clauses of `+`).

## 2. The next-state relation

One transition = one call of `round1`. It is a sequential composition of seven
phases; I name them because the failures below are located at named phases.

```
Next ≡ ∃ Gen; Conj; Fresh; Attempt; Kernel; Commit; Grow
```

**Gen.** `raw = genTermsModulo C A (arities Σ(σ)) 3 size`, where
`C = provedCommutative(σ)`, `A = provedAssociative(σ)` are read off `known` by
syntactic pattern match. `normed = ordNub (map (normalize U(σ)) raw)`.

**Conj.** Partition `normed` by the 40-point fingerprint
`t ↦ (eval sem e t)_{e ∈ E}`, `E` = 40 deterministic LCG environments mod 9.
Conjectures = all (least, other) pairs within a class, plus parsed thoughts
whose two sides fingerprint-agree.

**Fresh.**
```
fresh = sort_{(|l|+|r|, l, r)} { c ∈ conjectures :
          c ∉ known ∧ failed[c] ≠ n(σ) ∧ ¬provedByRewriting U(σ) c
          ∧ ¬congruent U(σ) known c }
```

**Attempt.** A left fold over `fresh` threading an accumulator `acc`, `acc₀ = U(σ)`:

```
attempt(acc, out, c) ≡
  IF   provedByRewriting acc c                                  THEN (acc, out)          -- DROP-DERIVED
  ELSE IF ∃ env ∈ [0..8]^k . ⟦l⟧env ≠ ⟦r⟧env                    THEN (acc, out)          -- DENY-FIREWALL
  ELSE IF proveByInduction acc c = Nothing                      THEN (acc, out)          -- DROP-UNPROVED
  ELSE IF marginalPrune acc probe c < 1                         THEN (acc, out)          -- DROP-USELESS
  ELSE (acc ++ (orient c or lemmaRules[c]), (c,pf):out)
```

**Kernel.** `checked = filter kernelAccept results`, where

```
kernelAccept (l,r) ≡ agdaCertificate(l,r) = Just src ∧ `agda --safe` exits 0 on src
agdaCertificate (l,r) = a module asserting  (x y z u v w : ℕ) → ⟦l⟧ ≡ ⟦r⟧  by  refl
⟦·⟧ : Term ⇀ Agda,  0↦zero, s↦suc, +↦_+_, *↦_·_, V i ↦ "xyzuvw"!!i (i<6),
                    undefined on max, -, gcd, le, and on every invented symbol
```

**Commit.**
```
rules' = rules ++ mapMaybe (orient ∘ fst) checked
lemmas' = lemmas ++ [c | (c,_) ∈ checked, orient c = Nothing]
known'  = known ∪ {fst c | c ∈ checked}
failed' = failed ⊕ {c ↦ n(σ) | c ∈ fresh, c ∉ map fst checked}
round'  = round + 1
```

**Grow.** Guarded by `stuck ≡ checked = []`. Let
`used ≡ invented = [] ∨ last(invented) occurs in some key of known'`.

```
Invent  : stuck ∧ used ∧ inventConcept(…) = Just s ∧ gates(s)  →  invented' = invented ++ [s]
Widen₁  : stuck ∧ ¬Invent ∧ vocab < 8 ∧ even(round')            →  vocab' = vocab+1
Deepen  : stuck ∧ ¬Invent ∧ ¬Widen₁ ∧ size < 7                  →  size'  = size+1
Widen₂  : stuck ∧ … ∧ vocab < 8                                 →  vocab' = vocab+1
Retire  : stuck ∧ … ∧ vocab = 8 ∧ size ≥ 7 ∧ invented ≠ []      →  invented' = init(invented),
                                                                    retired' = retired ++ [canonTerm(pat)]
Stretch : stuck ∧ … ∧ invented = []                             →  size' = size+1
```
Exactly one Grow disjunct fires, and none fires when `¬stuck`.

## 3. The invariants

```
INV1 (Soundness)   ∀(l,r) ∈ known . ∀ν : Var → ℕ . ⟦l⟧ν = ⟦r⟧ν      in the standard model
INV2 (Fragment)    ∀(l,r) ∈ known . syms(l) ∪ syms(r) ⊆ {0,s,+,*} ∧ maxvar < 6
INV3 (Scope)       syms(rules ∪ lemmas) ⊆ names(Σ(σ))
INV4 (Orientation) ∀(l,r) ∈ rules . lpo l r ∧ vars r ⊆ vars l
INV5 (Monotone)    rules, lemmas, known, retired are non-decreasing along Next
INV6 (Memo)        ∀c . failed[c] = n  ⟹  U at the time of that failure = U(σ) whenever n(σ) = n
```

INV6 is the invariant the code *needs* and never states. The comment at the
`fresh` filter states its intent in English — *"A conjecture that failed is not
retried until the machine knows something it did not know then"* — and
implements it as `failed[c] ≠ n(σ)`, i.e. by comparing a **cardinality**. That
substitution is sound only if `n` is injective on the reachable knowledge
states, which is INV6. It is false (§5).

## 4. What is inductive, and why

### 4.1 INV1 is inductive, and the proof is one line

*Proof.* `known` grows only at **Commit**, only by elements of `checked`, and
`c ∈ checked` requires `agda --safe` to have accepted a closed module whose type
is `(x y z u v w : ℕ) → ⟦l⟧ ≡ ⟦r⟧`. `⟦·⟧` sends each machine symbol to the
Agda operation with the same standard interpretation on ℕ, and Agda's ℕ with
`_+_`, `_·_` is the standard model. A type-checked term of that type under
`--safe` is a proof. ∎

The content is in what the proof does **not** use: it never mentions `rules`,
`lemmas`, `acc`, `size`, `vocab`, or `round`. **`kernelAccept` is a function of
the candidate alone.** That is precisely the property Hypatia calls
*prefix-blindness* in `notes/OBLIGATIO_ORDER_TRILEMMA.md` §4, and it is the
reason INV1 needs no induction hypothesis about the rest of the state. An
inductive safety invariant on a conceded set is exactly what a prefix-blind
concession rule buys you. This is the same theorem twice, once in medieval
logic and once in a Haskell filter, and neither note knew about the other.

Corollary (and it matters, see §9): **no false definition can propagate into
`known`.** The defining equations in `Def(σ)` are *not* kernel-checked — they are
axioms, audited only over `[0..8]^k`, and the source records that exactly one of
them was once false (`oldUnsoundGcdRule`, false at `x=1,y=2`). A false axiom
corrupts `acc`, hence `results`, hence the log — but not `known`, because the
gate downstream of it reads none of that.

### 4.2 INV2 is inductive

*Proof.* Same argument: `agdaCertificate` is `Nothing` unless every symbol is in
`{0,s,+,*}` and every variable index is `< 6`; `Nothing` yields `KERNEL-SKIP`
and `False`. `kVars = 3 < 6`, so the variable clause is never binding. ∎

### 4.3 INV3 is not inductive — it holds only in conjunction with INV2

`Retire` deletes a symbol from `Σ(σ)`, hence its defining equation from
`Def(σ)`. Nothing in the `Retire` guard inspects `rules` or `lemmas`. So

```
INV3 ∧ Retire ⊬ INV3′.
```

The proof obligation is discharged only by
```
INV2 ∧ INV3 ∧ Retire ⊢ INV3′,
```
since INV2 forbids an invented symbol from ever entering `known`, and `rules`
and `lemmas` are built from `checked ⊆ known`.

This is a **coincidental invariant**: INV3 is maintained not by any mechanism
that intends to maintain it, but by the incidental narrowness of the Agda seam,
a module with no other connection to concept retirement. `notes/RUNTIME.md` §6
names widening that seam as *the* next step ("the second edge type"). The
moment `agdaTerm` is extended past `{0,s,+,*}` — the single most likely edit to
this file — INV3 fails, and its failure mode is not silent: a `rules` entry
mentioning a retired symbol survives into `U(σ)`, `normalize` can rewrite a
generated term into that symbol, and `fingerprint` calls `eval`, which reaches

```
Nothing -> error ("MathMachine.eval: unknown symbol " ++ show f)
```

i.e. **`Retire` becomes a crash bug the first time the kernel seam widens.**
The guard needed is one line and does not exist:
`Retire` must additionally require that the withdrawn symbol occurs in no
element of `rules ∪ lemmas` — or, better, must withdraw those too.

### 4.4 INV4, INV5

INV4 is immediate: `rules` grows only by `mapMaybe (orient ∘ fst)`, and `orient`
returns `Just (l,r)` only when `lpo l r ∧ vars r ⊆ vars l`. INV5 is immediate by
inspection of Commit and Grow (no transition shrinks these four). Note that
`invented` and `vocab` are **not** in INV5, and that is the whole of §5.

## 5. The induction failure: `Retire` breaks INV6

> **Theorem 1.** INV6 is not inductive. There is a reachable pair of states
> `σ₁`, `σ₂` with `n(σ₁) = n(σ₂)` and `U(σ₁) ≠ U(σ₂)`, ~~and the conjectures that
> failed at `σ₁` are suppressed at `σ₂`.~~

> **Second clause struck (SEED-97, Rule K2/K3, 2026-08-14).** The first clause
> — INV6 is not inductive, `n` is not injective on reachable knowledge states —
> **stands and is proved below.** The second clause does not follow from the
> two-round cycle exhibited, and on the machine's own Commit rule it is false
> on that cycle. The cycle is not `σ₁ → σ₂`; it passes through `σ'`, and `σ'` is
> a *full round*, not a phase:
>
> ```
> round A at σ₁ (n = N)   : fresh ∋ c, checked = [], so failed[c] := N ; Grow = Retire → σ'
> round B at σ' (n = N−1) : failed[c] = N ≠ N−1, so c is admitted to fresh again,
>                           fails again, and failed[c] := N−1 ; Grow = Invent → σ₂
> round C at σ₂ (n = N)   : failed[c] = N−1 ≠ N, so c is admitted. NOT suppressed.
> ```
>
> The re-keying is forced by §2's own `Commit`
> (`failed' = failed ⊕ {c ↦ n(σ) | c ∈ fresh, c ∉ map fst checked}`) together
> with `stuck ⇒ checked = []`, which is exactly the hypothesis the cycle runs
> under: in the terminal region *every* `c` reaching `fresh` is re-keyed every
> round. And `n` alternates `N, N−1, N, N−1, …` along the cycle, so no two
> consecutive attempts of `c` ever see equal `n`. **On the exhibited cycle the
> memo is not over-suppressing; it is inert — it never suppresses anything.**
> That is a defect too, but it is the opposite defect, and consequence 1 below
> is struck with the clause.
>
> What a suppression witness would additionally require: a path from `σ₁` to a
> state of equal `n` along which `c` is *never re-attempted*. On this cycle the
> only way `c` misses round B is for `c` to mention the retired symbol `c_k` —
> and then `c` is not generated at `σ₂` either, since `Σ(σ₂)` contains `c_{k+1}`
> and not `c_k`, so no suppression occurs there either. A residual escape does
> exist and is **not** discharged here: `c` could fail to be *proposed* at `σ'`
> because `normalize U(σ')` puts its two sides in different fingerprint classes,
> or pairs them with different representatives. Whether that is reachable is
> **OPEN**; until it is settled, the harm claim of §5 is an unproved conjecture
> and the sound claim is the non-inductiveness alone.
>
> The repair recommended in consequence 3 below is unaffected — keying `failed`
> on a monotone index fixes both the (proved) non-injectivity and the (here
> demonstrated) inertness. The bug report is still correct; its stated symptom
> is not.

*Proof.* By INV2, no invented symbol ever occurs in a key of `known`. Hence for
any state with `invented ≠ []`,

```
used ≡ (invented = [] ∨ last(invented) occurs in a key of known) = False,
```

so `Invent` is disabled whenever `invented ≠ []`. Therefore `|invented| ≤ 1` in
every reachable state, and the terminal region of the machine (`vocab = 8`,
`size ≥ 7`, `stuck` persistently) is the period-two cycle

```
σ₁ : invented = [c_k]        --Retire-->  σ' : invented = [], retired ⊇ [p_k]
σ' : invented = []           --Invent-->  σ₂ : invented = [c_{k+1}], p_{k+1} ≠ p_k
```

`Retire` and `Invent` fire only when `stuck`, and `stuck ⇒ checked = []`, so
`rules` and `lemmas` are unchanged across both steps. Each invented symbol
carries exactly one defining equation (`conceptRule` demands `symDefs s = [r]`).
Hence

```
n(σ₁) = Σ_{i<8} d_i + 1 + |rules| + 2|lemmas| = n(σ₂),
```

while `U(σ₁)` contains `c_k`'s defining equation and `U(σ₂)` contains
`c_{k+1}`'s instead — and `inventConcept` is passed `retired`, so it may not
re-propose `p_k`; the two equations are distinct. Now let `c` be any conjecture
that reached `fresh` and failed at `σ₁`. Then `failed[c] = n(σ₁) = n(σ₂)`, so the
~~`fresh` filter at `σ₂` rejects `c`~~ — even though `σ₂`'s rule set differs from
`σ₁`'s exactly in the newly coined abbreviation that `σ₂` exists in order to
try. ∎

*(SEED-97, 2026-08-14: the struck sentence is the step the boxed correction
above refutes — the intervening round at `σ'` re-keys `failed[c]` to `n(σ')`.
Everything in the proof up to and including `n(σ₁) = n(σ₂)` with
`U(σ₁) ≠ U(σ₂)` is correct and is the whole of the surviving Theorem 1.)*

~~Three things make this worse than a stale cache:~~ **Two** things make this
worse than a stale cache (SEED-97: item 1 struck with the second clause of
Theorem 1):

1. ~~**It suppresses precisely the retries the transition was built to enable.**
   The long comment above the retire branch explains that the machine must
   withdraw a dead name so a *different* pattern can be coined; the memo then
   hides the old questions from the new name.~~ **Struck (SEED-97).** On the
   exhibited cycle the memo suppresses nothing at all; see the boxed correction.
   The honest symptom is that `n`'s non-injectivity makes the memo *unsound as a
   memo in both directions* — it can neither be relied on to suppress nor be
   relied on to admit — and no reachable suppression instance has been exhibited.
2. **`n` is non-monotone at exactly one transition, and it is the only
   non-monotone transition in the machine.** Every other component was designed
   under the assumption of monotone growth (INV5), and the `fresh` filter's
   correctness argument silently inherits that assumption.
3. **The fix is smaller than the bug report.** Key `failed` on any strictly
   monotone knowledge index — `round` at last Commit, or a hash of `U(σ)` —
   rather than `|U(σ)|`. Cardinality was chosen because it is cheap; it is a
   projection, and this repository already has the theorem about projections
   identifying distinct objects (`PARITY_RIGIDITY`, cited in `RUNTIME.md` §5 as
   "no single view may be authoritative"). The memo key is that homometry, in
   the machine's own control state.

> **Currency (SEED-97, Rule K1, 2026-08-14) — `SEED51_INSTALLATION_SYMPTOMA.md`
> §5(a), checked rather than accepted.** SEED-51 classifies installation
> blockers on three axes and asserts that the Haskell/Agda proof-label blocker
> (`ProofLabelNoGo`: if `emit` collides, `Σ[validate] (validate ∘ emit ≡ id)` is
> empty) "**is the same theorem as SEED-25 §5, not §4.3**", both being its Axis
> II (collapse). I have checked the identification; it is **faithful in one
> sense and not in another**, and §5 above is not entitled to be read as an
> instance of SEED-51 Theorem 1.
>
> *Faithful.* Both are instances of one triviality: **a non-injective map admits
> no retraction.** `emit` collides on proofs; `|U(·)|` collides on knowledge
> states. That is genuinely the same one-line fact, and SEED-51 is right that
> the §5 fix ("key on a monotone index") is a retraction repair and not a
> caching tweak.
>
> *Not faithful.* SEED-51's Axis II is **defined** as injectivity of `τ ∘ κ` on
> the intent `I ⊆ C`, a set of *claims*; its Theorem 1 quantifies over `c ∈ I`
> and its chain `c ∈ I → w → ℓ → c → install → σ' ⊨ c → tσ' ⊨ c` has no link on
> which a map out of the store `S` appears. The memo map `|U(·)| : S → ℕ` is not
> `τ ∘ κ`, `ℕ` is not `L`, and knowledge states are not claims. SEED-51 concedes
> exactly this in its own prose ("appearing on the store's control state instead
> of on its claims") — so §5 is an **analogy to** Theorem 1, not an instance of
> it, and the table row "Same theorem, different `τ`" overstates by one step.
> Further: no claim is misinstalled by the §5 defect. Nothing false enters
> `known`, and no two claims become indistinguishable to the installer; the harm
> (such as it is, given the strike above) is that claims are never *offered* —
> nearer deficiency (I−) than collapse in SEED-51's own axes.
>
> Verdict: the shared content is the retraction triviality, and SEED-51's
> *ordering* of the three repairs (II before I− before III) does not depend on
> the §5 placement, so nothing downstream breaks. The words "the same theorem"
> do not survive; "the same one-line lemma, applied to a different map on a
> different domain" does. Annotated at SEED-51's site as well.

## 6. Theorem K: the kernel seam and the search do not overlap where the corpus thinks

The search proves from the machine's own defining equations, which recurse on
the **right** argument:

```
x + 0 = x        x + s y = s (x + y)          x * 0 = 0        x * s y = (x * y) + x
```

Acceptance is `refl` in Agda, i.e. **judgmental** equality of `_+_` and `_·_`,
which in `Cubical.Data.Nat.Base` recurse on the **left** argument:

```
zero + m = m     suc n + m = suc (n + m)      zero · m = zero  suc n · m = m + n · m
```

(This is the single external dependency in this note. It is checkable in one
line by anyone with the library, and nothing else here rests on it.)

Both systems compute the same functions on closed terms, so the fingerprint
filter — which evaluates only at numerals — is completely blind to the
difference. The difference is visible only at the last gate.

> **Theorem K.** For distinct variables `x,y`, neither `x+y ≡ y+x` nor
> `(x+y)+z ≡ x+(y+z)` (nor their `·` analogues) is judgmentally true in Agda.
> Hence `kernelAccept` rejects every commutativity and every associativity
> instance, hence
> ```
> ∀ reachable σ .  provedCommutative(σ) = [] ∧ provedAssociative(σ) = [].
> ```

*Proof.* With `x` a free variable, `x + y` is neutral: `_+_` is defined by
pattern matching on its first argument and `x` is not a constructor form, so it
has no weak-head reduct. Likewise `y + x`. Conversion of two neutral
applications of the same defined constant proceeds by congruence on the neutral
spine, requiring `x ≡ y` and `y ≡ x` judgmentally, which fails for distinct
variables. So `refl` does not type-check, `agda` exits non-zero, and the
candidate is `KERNEL-REJECT`ed. `provedCommutative` and `provedAssociative`
read only `known`, which by INV1's proof contains only accepted candidates. ∎

**Consequences, all of them dead code:**

- The AC-quotient branch of `genTermsModulo` — the `canonical f [l,r]` clauses
  guarded by `f ∈ comm` and `f ∈ assoc`, and the `flatten`/`sortedBy` machinery
  they call — is **unreachable**. Its comment claims it "removes the losing
  branch before a `Term` exists"; it removes nothing, ever.
- `acCanonical` has no caller reachable from `round1` for the same reason.
- `isCommutativity` and `isAssociativity` are unreachable predicates.

What *does* get accepted is the complementary set: equations that Agda's
left-recursive definitions make judgmental and the machine's right-recursive
definitions do not. `0 + x = x` is the canonical member — `zero + x` reduces to
`x` by Agda's first clause (`refl` ✓), while the machine has no rule matching
`0 + x` and must prove it by induction on `x`. So the library that this machine
can build is not a record of its mathematical reach; **it is a record of the
disagreement between two orientations of the same definition.** Everything that
requires actual mathematics — commutativity, associativity, distributivity — is
unreachable by construction.

This is the sharpest form of the RUNTIME.md §4.5 complaint ("no connection to
this repository's mathematics"). The obstruction is not that nobody has done the
work; it is that the seam as built admits only equations no one needed a machine
for.

## 7. The one-shot concept, as a corollary

Theorem K's route through INV2 gives, independently of §5:

> **Corollary.** In every reachable state, `|invented| ≤ 1`.

because `used` can never become true with `invented ≠ []`. The gate's comment
says *"A NAME EARNS ITS SUCCESSOR BY BEING USED … Until the last one has
appeared in something proved, the machine may not coin another."* Given the
kernel seam, an invented name **can never appear in something proved**. The
gate is not strict; it is unsatisfiable. The intended design — a growing
self-made vocabulary — is not throttled, it is capped at one, and then cycles
(§5).

## 8. The `decreases` order: the stated argument is invalid

`step` applies a rule `(l,r)` at `u` only when `decreases u r'` where

```
decreases u v ≡ lpo u v ∨ (¬lpo u v ∧ ¬lpo v u ∧ cmpTerm v u = LT)
```

and the source argues: *"Falling back to (size, then a fixed total order on
terms) settles those cases and is still well-founded, so normal forms exist"*
and *"it makes non-termination impossible rather than merely unlikely."*

The argument as written is invalid. Well-foundedness of `lpo` and of `cmpTerm`
separately does not give well-foundedness of their union: on `{a,b,c}` take
`R₁ = {a>b}` and `R₂ = {b>c, c>a}`, each acyclic and finite, union cyclic. The
argument would go through if `lpo ⊆ cmpTerm`-decreasing, and that containment
**fails on the machine's own definition of `*`**:

> **Witness.** `u = x*(s y)`, `v = (x*y)+x`. Then `lpo u v` holds
> (precedence `*` = 3 > `+` = 2; `lpo u (x*y)` by the `f = g` clause with
> `lexGt [x, s y] [x, y]` via `lpo (s y) y`; and `lpo u x` by subterm), while
> `size u = 4 < 5 = size v`, so `cmpTerm v u = GT`.

So the two orders genuinely disagree on a rule the machine uses in every round.

What *is* provable: `decreases` admits no cycle of length ≤ 3. A cycle cannot
have two consecutive `lpo` edges (transitivity would collapse them and forbid
the silence a fallback edge requires), so any cycle strictly alternates and has
even length ≥ 4, with the `lpo` edges' total `cmpTerm`-increase at least
matching the fallback edges' decrease. Whether such a cycle exists among terms
generated at `size ≤ 7` I leave **OPEN**, and flag that the question is masked
in practice: `normalize` carries a fuel of 200 and silently returns a
non-normal term when it runs out. That fuel is what actually guarantees
termination. Its cost when it fires is not a soundness loss —
`provedByRewriting` compares two rewrite-reachable terms, and every rewrite is a
semantic equality — but `normed` then contains non-normal terms used as
equivalence-class representatives, and `provedByRewriting` returns `False`
spuriously. **Termination here is enforced by a counter and argued by an order,
and the two are not the same claim.**

## 9. The concession rule, exactly, and the insolubilia question

The mandate asks for the acceptance machinery as an *obligatio*. It is one, and
stating its concession rule settles a question the corpus has not asked.

**Positum.** `Def(σ)` — the defining equations. Conceded before the game begins,
never revisited, audited only over `[0..8]^k`. `oldUnsoundGcdRule` is the
recorded instance of a false positum (it asserted `gcd 2 3 = gcd 0 3`, hence
`1 = 3`).

**Opponent.** The fingerprint partition, proposing `(l,r)` in `fresh` order:
smallest first, ties broken by the derived `Term` order.

**Respondent (the concession rule), in order, with prefix-dependence marked:**

| # | rule | reads the prefix `acc`? | verdict |
|---|---|---|---|
| 1 | `provedByRewriting acc c` | **yes** | drop (*pertinens sequens*, but not recorded) |
| 2 | `∃ env ≤ 8 . ⟦l⟧ ≠ ⟦r⟧` | no | deny |
| 3 | `proveByInduction acc c = Nothing` | **yes** | drop |
| 4 | `marginalPrune acc probe c < 1` | **yes** | drop |
| 5 | `agda --safe` accepts `refl` | no | **concede** |

**Theorem 2 (no insolubile on the concession side).** No play forces the
respondent to concede a falsehood.

*Proof.* Rule 5 is the only concession rule and it reads none of the game state
(§4.1). Its verdict is a proof in a kernel independent of the positum. Hence the
respondent's conceded set is true regardless of what it granted earlier and
regardless of whether the positum is false. ∎

**Theorem 3 (order-dependence, and where the price is paid).** Rules 1, 3, 4 are
prefix-reading, so `results` is not a function of `(σ, conjectures)` — it depends
on the traversal order of `fresh`. Concretely: if `c₁` and `c₂` are
inter-derivable and `c₁` is attempted first, rule 1 drops `c₂`; in the opposite
order rule 1 drops `c₁`. The set of theorems entering `known` is therefore
order-dependent. The source knows this (*"ORDER MATTERS, and it was hard hash
order"*) and responds by fixing the order to smallest-first. That makes the run
deterministic; it does not make it order-free, and the claim that
*"smallest first is the only order with that property"* is a heuristic, not the
invariant.

So the machine is **a Swyneshed respondent stacked on a Burley respondent**, and
the stacking is exactly right: the prefix-reading layer can only lose theorems,
never truth, because the prefix-blind layer is downstream of it. That is a
positive structural result about this design and it is the strongest thing I
found in the file. `OBLIGATIO_ORDER_TRILEMMA.md`'s trilemma applies to the
prefix-reading layer alone, where (iii)-consistency is not at stake because
nothing there is certified; what is lost is **actuality** — a true, useful
theorem can be dropped forever because of where it fell in one round's order.

**The insolubile, where it actually lives: the untyped zero.** Rules 1, 3, 4 and
the `KERNEL-SKIP` and `KERNEL-REJECT` branches all produce the *same* stored
value, `failed[c] := n(σ)`. Five distinct facts collapse to one:

| what happened | truthful verdict | licensed next action |
|---|---|---|
| derived from this round's own results | already known | **record it in `known`** — currently it is *not*, so it is invisible to `congruent` and to every `known`-reading predicate, permanently |
| refuted at `env ≤ 8` | FALSE | never retry |
| no induction proof found | EXHAUSTED | spend more |
| `marginalPrune < 1` | true but inert | retry only if the probe set changes |
| `agdaTerm` undefined on a symbol | **OUT_OF_SCOPE** | fix the *map*, i.e. widen the seam; retrying is certain waste |
| `agda` exited non-zero | ambiguous: not a theorem, **or the toolchain is broken** | — |

`notes/RUNTIME.md` §8 records that the crystal lane had exactly this defect,
that mutation testing found it (*"the mutant deleting the budget check
survived, because a budget failure and a representation failure were the same
value"*), and that it was repaired into `UNORIENTABLE` / `EXHAUSTED` /
`OUT_OF_SCOPE`. **That repair was never carried to `MathMachine.hs`.** The
consequence is exact and unbounded: for every conjecture `c` mentioning `max`,
`-`, `gcd`, or `le` that the machine can prove by induction, each round in which
`n(σ)` changed re-derives `c`, re-runs the induction search, spawns `mktemp` and
an `agda` process, and receives `KERNEL-SKIP`. No reachable state can ever make
`agdaTerm` succeed on those symbols, so this recurs forever. `le` is in the
given vocabulary specifically because eleven theorems were `max`-shaped
restatements of it — i.e. the machine's most productive region is the region
where its verdicts are permanently untyped.

The last row deserves its own sentence. `kernelAccept` invokes
`agda -i formal/cubical -i dir file` with a **relative** path, so acceptance
depends on the process's working directory and on whether the Cubical library
resolves. A missing library and a false conjecture produce the same log line,
`KERNEL-REJECT`. Compare `notes/NATURAL_MACHINE_TOOLCHAIN_DRIFT.md`. The
transition relation reads the file system and the environment; the state machine
above is therefore not closed, and I flag that as the §5-relevant
under-specification below.

## 10. What is missing before this machine has a specification (sweep §0)

Not "too underspecified to model" — I wrote the model. But four pieces are
genuinely absent, and each is a hole in a *stated* claim, not a wish:

1. **No termination argument for `step`.** The order `decreases` is not
   transitive and is not an order; the fuel is the real argument (§8).
2. **No confluence claim anywhere**, yet `normalize`'s output is used as a
   canonical class representative in `ordNub` and as the equality test in
   `provedByRewriting`. `RUNTIME.md` §1 lists confluence as a *tested* property
   of the crystal lane; the Haskell lane has no analogue.
3. **No specification of the kernel's environment.** Relative include paths,
   ambient `agda` version, library resolution — all inputs to the transition
   relation, none part of the state.
4. **No typed verdict.** §9. This is the one repair that is both already
   designed in this repository and not applied.

## 11. Honesty ledger

- Every claim about `MathMachine.hs`, `Term`, `lpo`, `cmpTerm`, `round1`,
  `kernelAccept`, `inventConcept` is by reading the source; line-level, checkable.
- Theorem K depends on the clause orientation of `_+_`/`_·_` in
  `Cubical.Data.Nat.Base`, which is not vendored in this repository and which I
  did not read. If those recurse on the *right* argument, Theorem K inverts:
  the accepted set becomes `{x+0=x, x*0=0, …}`, which are the machine's own
  axioms and hence never conjectured, and the library is *empty* instead of
  near-empty. Either way the conclusion "commutativity and associativity are
  unreachable, so the AC branch is dead code" stands, since neither side reduces
  under either orientation.
- §8's open question (cycles of length ≥ 4 in `decreases`) is open. I did not
  search for one; I proved only that the published argument does not establish
  its absence, and exhibited the containment failure that the argument needs.
- I ran nothing. No `.py` file was created, read, or modified.
- Prior art: `OBLIGATIO_ORDER_TRILEMMA.md` (Hypatia, same day) covers the
  obligationes framing for `collab/discovery/manifests/`; I claim no novelty on
  the medieval material and cite it as the source of the prefix-blindness
  vocabulary. The application to `kernelAccept` — that prefix-blindness is
  *exactly* the condition making the soundness invariant inductive — is the new
  part, and it is a re-derivation of a standard fact about inductive invariants
  (a guard that does not read the state needs no hypothesis), so I grade it
  **not novel, but load-bearing here**.
