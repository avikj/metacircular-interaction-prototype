# Prior art for `NaturalMachine.TransportDiv`

**Status: audit, run before the write-up, per `CLAUDE.md` ("prior art gets
searched *before* the experiment"). Nothing in `TransportDiv.agda` or
`TransportDivWitness.agda` was edited by this pass; this note is attribution
only.**

**Citation grade.** `WebFetch` works again (several corpus notes still say it
is blocked — see `PRIOR_ART_SWEEP_COMPLETE.md` §0; that is now stale).
Entries marked **[F]** were fetched and read; **[L]** were read from disk;
**[S]** are search-summary grade only.

The claim under audit, as the module header states it: *the divisibility test
can be carried across the place-value chart, where it becomes a Horner residue
automaton — one state below the modulus, one step per digit — with a proof
that it computes `value w mod n`, and a corollary that a zero final state is
divisibility.*

Short verdict up front: **the mathematics is entirely classical and has a
name; the statement has been formalised in Lean and in nine other systems in
its digit-sum special case; and the general digit action is already formalised
*in this repository*, in cubical Agda, in `RadixSymptoma.agda`, which
`TransportDiv` does not cite. What is ours is the reduction-at-every-step
variant, its instantiation on the `Digits` chart, and the cost framing.**

---

## 1. Horner's rule modulo `n`

| | |
|---|---|
| Horner's rule proper | Knuth, *TAOCP* vol. 2, *Seminumerical Algorithms*, **§4.6.4 "Evaluation of Polynomials"** (3rd ed., pp. 486–488) **[S]** |
| the object `TransportDiv` builds | Klaus Sutner, *Divisibility and State Complexity*, **The Mathematica Journal 11:3 (2010)**, doi:10.3888/tmj.11.3-8 **[F]** |

Sutner names the object and states `value-modw` verbatim. Quoted from the
article page:

> "The state set of A is the set Z_m of modular numbers and the right action
> is given by: r → (b·r+d) mod m. If we fix the initial state to 0, we have
> δ(0,w)=val(w) mod m for any word w … the action corresponds to the standard
> Horner scheme of evaluating polynomials and we refer to these machines as
> **Horner automata**."

`TransportDiv.value-modw : modw n w ≡ value w mod n` **is** `δ(0,w) = val(w)
mod m`. The term "Horner automaton" is in current use for exactly this family:
N. Tran, *Separating Words from Every Start State with Horner Automata*,
arXiv:2309.02766 (2023) **[F]**, which calls them "a well-known family".

The general divisibility-rule literature (casting out nines, the alternating
sum for 11, weighted digital sums) is the `b mod n ∈ {1,−1}` collapse of the
same recursion; e.g. P. B. Pal, *Divisibility tests with weighted digital
sums*, arXiv:math/0507011 (2005) **[F]**.

**Grade: classical, named, textbook.** No novelty is available here.

## 2. Divisibility as a finite automaton

| | |
|---|---|
| regularity of `{w : val_b(w) ≡ 0 mod n}` | standard textbook example (Sipser, *Introduction to the Theory of Computation*; Hopcroft–Ullman) **[S]** |
| the general statement | arithmetic progressions are `b`-recognizable in every base; Büchi (1960), *Weak second-order arithmetic and finite automata*; converse direction Cobham (1969) **[S]** |
| exact minimal state count, every base and modulus | **B. Alexeev, *Minimal DFAs for Testing Divisibility*, JCSS 69:2 (2004), 235–243**, doi:10.1016/j.jcss.2004.02.001, arXiv:cs/0309052 **[S]** |
| state complexity incl. *reverse* base-`b` and Fibonacci numeration | Sutner 2010, above **[F]** |

Two things follow that the module header does not say.

- **"One state below the modulus" is an upper bound, not a description of the
  minimal machine.** The `n`-state Horner automaton is generally *not*
  minimal; Alexeev gives the exact count in closed form and Sutner records
  that "the canonical Horner DFAs fail to be minimal". `TransportDiv` claims
  no minimality, which is correct, but the phrase "one state below the
  modulus" should not be read as one.
- **The corollary is the acceptance condition.** "A zero final state IS
  divisibility" is not a theorem *about* the automaton; it is what makes the
  automaton a recognizer of the divisibility language. In Agda it still costs
  the Euclidean-division bookkeeping that `modw-zero→∣` performs, but the
  mathematical content is the definition.

## 3. Formalisations elsewhere

### 3a. Lean / mathlib — the closest existing declarations

`Mathlib.Data.Nat.Digits.Defs` **[F]**:

```
def Nat.ofDigits {α} [Semiring α] (b : α) : List ℕ → α
  -- "ofDigits b L = L.foldr (fun x y ↦ x + b * y) 0", little-endian
```

This is **definitionally `NaturalMachine.Digits.value`** (`value (d ∷ w) =
toℕ d + b · value w`), up to the digit type.

Mathlib3 `data.nat.digits` **[F]**, verbatim, all present in mathlib4 under
CamelCase:

```
theorem nat.of_digits_modeq (b k : ℕ) (L : list ℕ) :
  nat.of_digits b L ≡ nat.of_digits (b % k) L [MOD k]
theorem nat.of_digits_mod (b k : ℕ) (L : list ℕ) :
  nat.of_digits b L % k = nat.of_digits (b % k) L % k
theorem nat.of_digits_zmodeq (b : ℤ) (k : ℕ) (L : list ℕ) :
  nat.of_digits b L ≡ nat.of_digits (b % ↑k) L [ZMOD ↑k]
theorem nat.modeq_digits_sum (b b' : ℕ) (h : b' % b = 1) (n : ℕ) :
  n ≡ (b'.digits n).sum [MOD b]
theorem nat.dvd_iff_dvd_of_digits (b b' : ℕ) (c : ℤ) (h : ↑b ∣ ↑b' - c) (n : ℕ) :
  b ∣ n ↔ ↑b ∣ nat.of_digits c (b'.digits n)
```

and `Mathlib.Data.Nat.Digits.Div` **[F]**: `Nat.modEq_three_digits_sum`,
`Nat.modEq_nine_digits_sum`, `Nat.modEq_eleven_digits_sum`,
`Nat.dvd_iff_dvd_digits_sum`, `Nat.three_dvd_iff`, `Nat.nine_dvd_iff`,
`Nat.eleven_dvd_iff`, `Nat.eleven_dvd_of_palindrome`.

**Be precise about the gap.** Mathlib does not define the *reducing* fold
`L.foldr (fun d r ↦ (d + b * r) % n) 0` and so does not state `modw n w =
ofDigits b w % n`. It has the same congruence content one level up
(`Nat.ModEq` closed under `+` and `*`), and `Nat.ofDigits_modEq` /
`Nat.ofDigits_mod` are the sibling statements. So: **mathlib does not contain
`value-modw` under any name, but contains everything it is made of, and the
missing declaration is one induction.** It is a gap in the library, not a
theorem.

### 3b. Other systems

Freek Wiedijk's *Formalizing 100 Theorems*, **#85 "Divisibility by 3 Rule"**
**[F]** — formalised in **HOL Light** (Harrison), **Isabelle** (Porter),
**Lean** (Morrison), **Rocq/Coq stdlib**, **Metamath** (Carneiro), **Mizar**
(Naumowicz), **ACL2** (Russinoff), **ProofPower** (Arthan), **PVS**
(Engelhardt), **Imandra**. This is the `b ≡ 1 (mod n)` digit-sum
specialisation, not the general Horner residue; mathlib's `Nat.three_dvd_iff`
is Lean's entry.

### 3c. Agda

| library | what is there |
|---|---|
| **Agda stdlib `Data.Digit`** **[L]** | `Expansion base = List (Digit base)`; `fromDigits [] = 0`, `fromDigits (d ∷ ds) = toℕ d + fromDigits ds * base` — **literally `Digits.value`**, same little-endian convention. `toDigits` returns the expansion *paired with its correctness proof*, i.e. `Digits.digits` + `value-digits` in one constructor. |
| **`Data.Digit.Properties`** **[L]** | only `toDigits-injective` and `showDigit-injective`. **No modular lemma of any kind.** |
| **`Cubical.Data.Nat.Mod`** **[L]** | `mod-rCancel`, `mod·mod≡mod`, `mod-idempotent`, `mod-lCancel`, `zero-charac-gen` — exactly the three lemmas `TransportDiv` consumes, and nothing digit-shaped. |
| **cubical library, whole tree** **[L]** | grep for `digit`/`radix` returns one unrelated hit in `Algebra/Polynomials`. There is no base-`b` numeral module. |
| **agda-unimath** **[S]** | `elementary-number-theory.finitary-natural-numbers` has `based-ℕ` (base-`k` naturals) and a congruence API; no Horner-residue statement found. Not checked against a local clone — `~/agda-libs` does not exist in this container, contrary to `PRIOR_ART_INDEX.md`. |

### 3d. Isabelle AFP

**Null result, [S] grade.** `Regular-Sets` **[F]** covers derivatives and
regexp equivalence and mentions no numeration; `Functional-Automata`,
`Transition_Systems_and_Automata`, `Presburger-Automata`,
`Nominal_Myhill_Nerode` are automata-side only. No AFP entry was found joining
base-`b` numeration to divisibility automata. Isabelle's #85 entry (Porter)
is the digit-sum rule, not an automaton.

## 4. Prior art **inside this repository** — the load-bearing finding

This is the part a future agent most needs. The corpus already owns this
automaton, in prose and in checked Agda, and `TransportDiv` cites none of it.

| where | what it already has |
|---|---|
| `notes/GENERAL_RADIX_DIVISIBILITY.md` | the digit action `r ↦ br+d (mod m)`, the Myhill–Nerode classification of its states in every base, **and the Alexeev citation already recorded at the top** |
| `notes/NUMERAL_DIVISIBILITY_HORIZON.md` | finite-horizon theorem for the same automaton |
| `notes/BINARY_DIVISIBILITY_CRYSTAL.md` | base-two state count; already flagged as Alexeev Cor. 5 |
| `notes/RADIX_SHORTEST_COMPLETION_INVARIANT.md` | two-coordinate sufficient statistic for the same states |
| **`formal/cubical/NaturalMachine/RadixSymptoma.agda`** | **checked cubical Agda**: `Radix.step r d = b · r + dig d`; `Radix.val`; `Radix.run≡ : run step r w ≡ b ^ length w · r + val w`; observation `_ mod M ≡ 0`; plus its own `mod-+congˡ`, `mod-·congʳ`, `mod-+cancel`, `scale-mod` |
| `formal/cubical/NaturalMachine/ResidueTransport.agda` | the generic statement that *any* residue/divisibility observation transports along the chart: `compile observe = observe ∘ valueC`, with `compile-generated` |

`Radix.run≡` at `r = 0`, reduced mod `M`, is `value-modw`'s statement for the
**unreduced** machine. The genuine difference is real but narrow, and should
be stated as the delta rather than as a new construction:

- `RadixSymptoma.step` keeps the state in ℕ unreduced, so it is not a
  bounded-state machine; `TransportDiv.modw` reduces mod `n` at every digit,
  which is what makes "one state below the modulus" true. `scale-mod` in
  `TransportDiv` is precisely the lemma licensing that reduction — and it is a
  *different* lemma from the `scale-mod` in `RadixSymptoma` (which is about
  `b^(j+k)`). Two distinct theorems now share a name in one namespace.
- `RadixSymptoma` runs on an arbitrary alphabet `D` with weight `dig : D → ℕ`
  and a big-endian `val`; `TransportDiv` runs on `Digits`' little-endian
  `Word`, so it composes with `Transport` / `TransportMul`.

## 5. Two statements in the module that the audit does not support

Recorded here rather than in the Agda, which this pass does not own.

1. **`modw` is a right fold, not a streaming scan.** `modw n (d ∷ w) = (toℕ d
   + b · modw n w) mod n` recurses into the *tail* — the more significant
   digits — before combining. It therefore realises the Horner automaton on
   the **big-endian reading** of a little-endian word, with recursion depth
   `|w|`. The `O(1)`-state claim is a fact about the automaton, not about the
   evaluation of this term. Sutner 2010 treats base-`b` and *reverse* base-`b`
   as different state-complexity problems for exactly this reason.
2. **`steps` is not a cost model of `modw`.** `steps : Word → ℕ` is a separate
   function on the word, and `steps-is-length : steps w ≡ suc (length w)` is a
   definitional identity about `steps`. Nothing in the module connects it to
   the reduction behaviour of `modw`. In `TransportDivWitness` the comparison
   `1000` vs `5`, and the chart/unchart weights `3` and `3`, are chosen
   numbers in the `CostGeometry` model — a stipulation, not a measurement and
   not a derivation. Per `CLAUDE.md` this is fine *as long as it is not read
   as a cost theorem*, which the header's "COST" heading invites.

## 6. Verdict

| piece | grade |
|---|---|
| digit-by-digit residue recursion `r ↦ (br+d) mod n` | **(a) classical** — Horner scheme; Knuth §4.6.4; named "Horner automaton" by Sutner 2010 |
| `value-modw : modw n w ≡ value w mod n` | **(a) classical** — Sutner 2010 states it as `δ(0,w) = val(w) mod m` |
| `{w : val_b(w) ≡ 0}` regular; zero state = divisibility | **(a) classical** — textbook; Büchi 1960 / Cobham 1969; exact state count Alexeev 2004 |
| the statement, formalised | **(b) formalised elsewhere** — mathlib `Nat.ofDigits` = our `value`, with `ofDigits_modEq`, `ofDigits_mod`, `dvd_iff_dvd_ofDigits`; Freek #85 in ten systems; Agda stdlib `Data.Digit.fromDigits` = our `value`. The *reducing fold* has no declaration found in any library. |
| the digit action, in cubical Agda | **(b) already formalised — here**, `NaturalMachine.RadixSymptoma.Radix` (`step`, `val`, `run≡`), uncited |
| reduction-at-every-step, hence bounded state | **(c) ours**, and the only mathematical delta over `RadixSymptoma` |
| instantiation on `Digits`' little-endian `Word`, composing with `Transport`/`TransportMul`; `--cubical --safe`, no postulates | **(c) ours**, as artifact |
| the transport-of-structure framing and the `ϱ`/`↝` cost accounting in `TransportDivWitness` | **(c) ours**, and carries no external claim; see §5.2 before quoting the numbers |

**One sentence.** Every mathematical statement in `TransportDiv` is classical
and named — Sutner's Horner automaton, whose correctness identity `δ(0,w) =
val(w) mod m` is `value-modw` verbatim — and its formalisation is new only as
a cubical-Agda artifact instantiated on this repository's own chart, since
mathlib has the surrounding API and `RadixSymptoma.agda` in this very
directory already has the unreduced digit action; what is genuinely ours is
the reduce-at-each-digit variant that makes the state bounded, and the
transport/cost framing around it.

---

## Omission, recorded at the top of the file it belongs to (2026-08-19)

This note is incomplete in a way that matters more than anything it got
right, and the correction is left here rather than folded silently into the
text above, because a prior-art note that is amended quietly is worth less
than one that shows what it missed.

**Nineteen citations, all northwestern, for three objects with three
different provenances.**

- The reduction step (`a mod n` before the gcd) is anthyphairesis and
  predates Euclid. Attributed to nobody here, which is fine.
- The digit word is **Piṅgala**, *Chandaḥśāstra*, c. 300 BCE — prastāra,
  with naṣṭa and uddiṣṭa as the two directions of the addressing map. This
  repository has eight checked modules on it (BOOK_INDEX chapter 2). Cited
  above: mathlib's `Nat.ofDigits`, the Agda stdlib's `fromDigits`, Büchi,
  Cobham. Not Piṅgala.
- The chart `value`, place value with śūnya as a number with its own
  arithmetic, is **Brahmagupta**, *Brāhmasphuṭasiddhānta*, 628 (chapter 7).
  Not cited.

And the harder problem the residue is a shadow of — solve the linear
indeterminate congruence, not merely reduce it — is Āryabhaṭa's **kuṭṭaka**
(*Āryabhaṭīya*, Gaṇitapāda 32–33, 499 CE), which is a **checked theorem in
this repository** at `formal/cubical/Kuttaka.agda`, with
`NaturalMachine/CakravalaNeedsKuttaka.agda` in the same directory as the
module this note audits. Its header opens: *"the mechanism was available in
499 CE."*

The audit searched the web and adopted a 2010 paper's name for the object —
*Horner automaton*, after Horner 1819, for a rule Liu Hui had in the third
century. It did not search one directory up.

The full specimen, and why this is a finding about search infrastructure
rather than an apology, is
`notes/THE_AUDIT_THAT_CITED_SUTNER_AND_NOT_THE_PULVERISER.md`.
