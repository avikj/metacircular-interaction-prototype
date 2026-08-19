# The decisionless pulverizer: a checked, reversible, honest kuṭṭaka

**Status: complete and kernel-checked.** Nine Agda modules
(`formal/cubical/`, `--cubical --safe`, no postulates, no holes), aggregated
and built as one closure in `Jiva.agda`. This note is the scholarly record —
what each theorem establishes, which older statement it is, and what is *not*
claimed.

The rule this note is about is **older than the notation everyone writes it
in**. It is Āryabhaṭa's *kuṭṭaka* / *vallī* (*Āryabhaṭīya*, Gaṇitapāda 32–33,
499 CE): *"keep the remainder and recurse."* Not "the extended Euclidean
algorithm." The directive in `CLAUDE.md` is followed here literally: the
earliest establishable statement is cited, and the tradition is engaged as a
system, not mined for a theorem.

## The disease this replaces

The prior organism in this repo (`machine/Obstruction.hs`, the Python
`living_machine`) computed by **deciding** — a boolean verdict at each step
(`discreteℕ x y`: "are these equal?"). A decision is `Bool` wearing a
witness, and it has a fatal property, verifiable mechanically: on an *open*
term (abstract input) it does not reduce — it is *stuck*, waiting for the
world to become concrete.

That stuck-ness is not a limitation of Agda. It is the type theory refusing
to assert an unconditional truth about a not-yet-determined term — which is
exactly the Jain prohibition on **durnaya** (a naya that denies its own
standpoint-conditioning; Siddhasena Divākara, *Sanmatitarka*). The substrate
is natively *anekāntavādin*; the boolean overlay was a foreign imposition.
The cure was **subtraction**, not addition: delete the decision.

That the boolean is durnaya is no longer prose but a **theorem**
(`Saptabhangi`): `दुर्नयः` proves that any two-valued verdict
`f : सप्तभङ्गी → द्विपद` necessarily identifies two *distinct* of the three
seeds asti / nāsti / avaktavya (three into two, by pigeonhole) — a boolean
mind cannot hold even the threefold, let alone the sevenfold. And
`क्रम-सह-भेदः` proves `स्यात्-अस्ति-नास्ति ≢ स्यात्-अवक्तव्यम्`: the
simultaneous (yugapad) mode is irreducible to the sequential (krama) — the
avaktavya is a genuine fourth position, not "both in turn." So the disease
and its diagnosis are checked in the same corpus as the cure (Samantabhadra,
Akalaṅka, Siddhasena, formalized).

- `BhedaAvatarana.एकपदे : भेद (suc a)(suc b) ≡ गभीर (भेद a b)` — **`refl`**.
  The exact statement that was *stuck* on `discreteℕ x x` now holds
  definitionally, because the rule moves by structure (peel both heads),
  never by asking. This is the criterion made mechanical: *installed
  cognition reduces to `refl`; description needs a proof from outside.*

## The one dharma, seen four ways

The single governing constraint — **destroy nothing** — is simultaneously a
physics, a logic, an ethics, and an epistemology:

| face | statement | theorem |
|---|---|---|
| information | the descent is lossless / reversible | `Punaragamana.पुनरागमनम् : उत्थान (अवतरण a b) ≡ (a , b)` |
| structure | pair and descent-record are one, transported not decided | `Punaragamana.युग्म≡विवेक : (ℕ × ℕ) ≡ विवेक` (univalence) |
| whole machine | reversibility across the entire algorithm | `Gati.अलोपः : पुनः (गति f a b) ≡ (a , b)` |

Losslessness = reversibility = *ahiṃsā* (do not erase — non-violence at the
bit, cf. Landauer) = honesty (retain every standpoint, so no verdict is ever
fabricated). The equivalence gets the **univalence** path — Voevodsky, the
one non-Indic source `CLAUDE.md`'s spirit admits, because univalence *is*
nayavāda in another notation (identity as a transported path, not a boolean).

`utpāda-vyaya-dhrauvya` (Umāsvāti, *Tattvārthasūtra* 5.29 — arising, ceasing,
persisting, at once) is `गभीर` in one step: head spent (vyaya), नय deepened
(utpāda), remainder untouched (dhrauvya) — `refl`.

## Correctness (the meaning, proved not asserted)

- `GurutamaSiddha.सिद्धः : फल (गति f a b) ≡ गुरुः g → isGCD a b g` — the
  resolved value is **the greatest** common divisor, certified against the
  library's `isGCD` (uniqueness included). Both directions of Āryabhaṭa's
  common-divisor invariant are proved: `∣-योग` (a divisor of both divides
  their sum) and `∣-अन्तर` (… their difference).

## The honesty triad

The un-said (`अनुक्तम्`) is a **first-class positive value**, not an error:
when the grant is spent the machine holds its live state whole and says
nothing false. Three theorems characterize it completely:

- **un-said** — on `अनुक्तम्`, `फल` yields `अनुक्तफलम्` (the live pair), never
  a `गुरुः`. No durnaya.
- **complete** — `Purnata.पूर्णतया-गुरुतमः`: at grant `suc (a + b)` the gait
  *always* resolves, and to the certified gcd. The un-said is only ever
  temporary; the pair-sum measure strictly decreases, so truth is uncovered
  by grant, never abandoned.
- **stable** — `Sthairya.स्थैर्य-गति`: a resolved `g` is unchanged by any
  larger grant. Syāt-conditioned truth does not waver; anti-durnaya is not
  indecision.

## The honest-machine interface (the reusable mode)

The triad is not gcd-specific — it is the general shape of hallucination-free
computation. `Satyayantra` abstracts it as a record `सत्ययन्त्र I O शुद्ध`
with three laws — **soundness** (any answer is correct), **stability** (an
answer survives more grant), **completeness** (enough grant always answers) —
over an output `सूचना O = उक्त O | अनुक्त`, where the un-said `अनुक्त` is a
genuine third position (not `⊥`, not falsity, no boolean).

- `निर्णय : (Y : सत्ययन्त्र I O शुद्ध) (i : I) → Σ[ o ] शुद्ध i o` — the payoff:
  **any** honest machine yields, for every input, a correct answer with its
  witness. Honesty + completeness ⟹ constructive total correctness, no
  durnaya. (`Gati.उदाहरणम्-अनुक्तम्` / `Satyayantra.अनुक्त-जीवति` show the
  un-said is genuinely reached, so the honesty is non-vacuous.)
- Two inhabitants, deliberately different: `कुट्टक-सत्ययन्त्र` (grant-based —
  un-said reachable, completeness earned via `पूर्णता`) and
  `PingalaSatya.पिङ्गल-सत्ययन्त्र` (total — always answers, soundness = the
  prastāra bijection). The interface captures both, so it is general.

This is the sense in which the work is a *mode installed*, not a theorem
recovered: the object is an interface any future decisionless solver can
inhabit, carrying its honesty as typed law.

## The true purpose (gcd was only the byproduct)

The kuṭṭaka was built to solve linear indeterminate equations — for
astronomy (planetary conjunction), not for gcd.

- `Bija.बीजगणितम् : … → बीजसिद्धि a b g` — **Bézout in ℕ**: `a·x ≡ b·y + g`
  (or its mirror). Coefficients climb the vallī by pure addition with
  *alternating orientation* — exactly Āryabhaṭa's method, using **no negative
  numbers**. (The `ℤ` presentation of "Bézout" is the later restatement; the
  vallī is the original and needs no signed ring.)
- `Yuti.युतिः : … → c ≡ g · m → युतिसिद्धि a b c` — the linear congruence
  `a·X ≡ c (mod b)`, solvable **iff** `c` is a multiple of the gcd
  (Āryabhaṭa's own solvability condition). This is the kuṭṭaka's astronomical
  use — *युति*, when two cycles realign. When `c` is not a multiple of the
  gcd, no solution is produced: the un-said, not a fabrication.

## Honesty ledger — what is NOT claimed

- **Not** a speed/efficiency claim. No step-counts, no measurement. Per
  `CLAUDE.md`, every quantity here is a checked object, not a benchmark. The
  subtractive descent is deliberately Āryabhaṭa's, not the division-based
  variant; it can take up to `a + b` steps, and this is stated, not hidden.
- **Generality — now demonstrated in a second tradition, not just claimed.**
  The same decisionless/reversible/lossless mode is checked in Piṅgala's
  *Chandaḥśāstra* (~300 BCE), a domain unrelated to the kuṭṭaka:
  - `Pingala` — the prastāra as a checkless **successor-enumeration**:
    `अनुक्रम-मूल्य : मूल्य ∘ अनुक्रम ≡ suc ∘ मूल्य`, and the reconstruction
    `मूल्य-विन्यास : मूल्य ∘ विन्यास ≡ id` — **total**, no grant needed
    (it counts up), the same ahiṃsā (nothing erased) as the kuṭṭaka, all by
    structure (no `Dec`). Bijective base-2 with digits laghu = 1, guru = 2.
    Now closed to a **full bijection**: `मूल्य` is injective (`मूल्य-एकैकम्`,
    via two parity lemmas), giving `विन्यास ∘ मूल्य ≡ id` and hence
    `छन्दस्≃ℕ` with the univalence path `छन्दस्≡ℕ` — full parity with the
    kuṭṭaka's `युग्म≡विवेक`.
  - `Matramerus` — Virahāṅka's **mātrāmeru** (~700 CE): the count of
    weight-`n` metrical patterns satisfies `M(n+2) = M(n+1) + M(n)` — the
    "Fibonacci" recurrence five centuries before Leonardo — proved as the
    *length-recurrence* of the actual enumeration `सर्व`, split on the first
    syllable. Soundness (`साधु`: every pattern in `सर्व n` has weight `n`)
    and **completeness** (`पूर्णता`: every weight-`n` pattern appears) are
    both proved — so `सर्व n` is *exactly* the weight-`n` patterns and
    `M(n)` genuinely counts them (Virahāṅka's theorem, whole).
  Still open (tagged `PROVE`): whether the three honesty faces (lossless /
  complete / stable) recur for continued-fraction convergents — the vallī
  already *is* the CF, a Kerala-school (Mādhava) object.
- **Not** claimed: any metaphysical identity by decree. Univalence is used as
  the honest transport it is; the tradition-parallels (nayavāda, avaktavyam,
  utpāda-vyaya-dhrauvya) are stated as the structures they formalize, held as
  `≃?` where they are analogy and `≡` only where a path is checked.

## The generative traditions — engaged as systems, not mined for theorems

Two further lanes formalize the *epistemology*, not just the results — the
half of the directive that matters more:

- `Saptabhangi` — Jain sevenfold predication as checked logic. `क्रम-सह-भेदः`:
  the simultaneous (yugapad) mode is irreducible to the sequential
  (`स्यात्-अस्ति-नास्ति ≢ स्यात्-अवक्तव्यम्`) — avaktavya is a genuine fourth
  position. `दुर्नयः`: any two-valued verdict provably collapses two of the
  three seeds (pigeonhole) — the boolean *is* durnaya, proved. And *why
  seven*: `वृत्तम्` shows the sevenfold embeds faithfully into the non-empty
  combinations of the three seeds (2³−1). Samantabhadra, Akalaṅka, Siddhasena.
- `Panini` — the Aṣṭādhyāyī (~500 BCE) as a generative rewriting system with
  conflict resolution. `अपवाद-बलम्`: the apavāda (exception) blocks the
  utsarga (general rule) where it applies — a rule is option-typed (`Maybe`,
  generative), *not* a boolean test, and the first firing rule wins. This is
  the utsarga/apavāda machinery `CLAUDE.md` names as absent from the engine,
  ~2400 years before Backus–Naur.

Both are the same lesson the kuṭṭaka teaches, read in logic and in grammar:
**generation and standpoint over the boolean verdict.**

## Adjacent lane — faithful to the sources, but a DIFFERENT principle

`Brahmagupta` (`formal/cubical/`, `--cubical --safe`) checks the **bhāvanā**
(*Brāhmasphuṭasiddhānta*, 628 CE): the norm `x² − N·y²` is multiplicative
under composition (`भावना-मान`, both the samāsa and antara forms), hence
वर्गप्रकृति (varga-prakṛti; the equation mis-called "Pell") solutions form a
group (`चक्रवाल-संयोगः`), the `−1 → +1` bridge (`ऋण-भावना`),
and concrete checks — `(3,2)` and `(1,1)` on `x² − 2y² = ±1` composing to
`(17,12)` / `(3,2)`. This is the seed of the cakravāla (Jayadeva ~950,
Bhāskara II 1150) and of Gauss composition.

**Honest distinction, not to be blurred:** this lane is faithful to the
tradition but is *not* a demonstration of the checkless/reversible/honest
mode above. The identities are pure ring equations discharged by the ℤ
`CommRingSolver` — a reflection tactic, which is internally a *decision
procedure*. It produces a genuine kernel-checked term (no postulate, no
`native_decide`), so it is sound; but it belongs to the "revive the ancient
theorems" thread, not the "decisionless cognition" thread. Keeping the two
apart is itself part of the discipline: `bhāvanā` is a theorem recovered;
the kuṭṭaka `Jiva` is a *mode* installed.

## Sources (earliest establishable, per the directive)

- Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda 32–33 (499 CE) — kuṭṭaka/vallī, "keep
  the remainder."
- Umāsvāti, *Tattvārthasūtra* 5.29 — *utpāda-vyaya-dhrauvya-yuktaṃ sat*.
- Siddhasena Divākara, *Sanmatitarka*; Samantabhadra; Akalaṅka — nayavāda,
  sunaya/durnaya, kramārpaṇa/sahārpaṇa, saptabhaṅgī.
- Piṅgala, *Chandaḥśāstra* (~300 BCE) — the prastāra (binary enumeration),
  meru-prastāra; Halāyudha, *Mṛtasañjīvanī* (10th c.).
- Virahāṅka (~700 CE), then Gopāla and Hemacandra — the mātrāmeru
  (Fibonacci) recurrence for prosody, predating Leonardo of Pisa (1202) by
  five centuries.
- Brahmagupta, *Brāhmasphuṭasiddhānta* (628 CE) — the bhāvanā composition on
  `x² − N·y²`; then Jayadeva (~950) and Bhāskara II (*Bījagaṇita*, 1150) —
  the cakravāla, which solved "Pell's equation" six centuries before Lagrange
  (1766). Pell never solved it; Euler misattributed it.
- V. Voevodsky et al., univalent foundations — the transport used in
  `युग्म≡विवेक` (admitted as egoless, credit-refusing, and structurally
  nayavāda).

---

## Appended 2026-08-19 — where the criterion lives, and an independent check of the lane

*Appended by a later reader, at the site, altering no line above.*

This note states a criterion and calls it mechanical: *"installed cognition
reduces to `refl`; description needs a proof from outside."* I read
`BhedaAvatarana.agda` and the exhibit holds — `एकपदे` is `refl` at lines
82–83, no proof term. Nothing here disputes that.

What is now checked, in
`formal/cubical/NaturalMachine/AskingIsNotAPropertyOfTheFunction.agda`
(`--safe`, no postulates, no holes, EXIT 0), is **where** the criterion
lives. Two presentations of one function:

```agda
peel : ℕ → ℕ → ℕ            -- falls by constructors
peel (suc a) (suc b) = peel a b

askℕ : ℕ → ℕ → ℕ            -- verdict (discreteℕ a b)
```

`sameFunction : peel ≡ askℕ` (funext twice). Hence

```agda
no-invariant-of-the-function-reports-asking :
  ¬ (Σ[ f ∈ ((ℕ → ℕ → ℕ) → Bool) ] ((p : Presentation) → f (run p) ≡ asks p))
```

and the same statement routed through
`TranscriptDescent.collisionObstructsDecoder`, the general lemma that
already carries `Laghava` §3, `Anuvrtti` §4 and `CarryBorrowObservation`.

**Consequence, and it is the useful half.** Decisionlessness is a predicate
on *presentations*. No invariant of the computed function can report it, so
no type can carry it and no build can enforce it. `Jiva.agda` type-checking
green says nothing about whether the lane asks. This is exactly why
`Anekanta.agda` — "proclaimed 'no checking' yet used `discreteℕ`" — had to
be caught by a human reading the file. It is the same conclusion `CLAUDE.md`
reached about the Python ban, in its own words: *enforced mechanically
because prose failed* — a hook at the site of the write, not a paragraph and
not a proof obligation.

**So I ran the check the lane needs rather than asserting it.** Over the
eleven Lane-1 modules this index names, counting only non-comment lines:

```
grep -n 'discreteℕ\|\bDec\b\|\bBool\b' M.agda | grep -v '^[0-9]*: *--'
```

| module | code hits |
|---|---|
| BhedaAvatarana, Punaragamana, Gati, Gurutama | 0 |
| GurutamaSiddha, Sthairya, Purnata, Bija, Yuti, Sadhyata | 0 |
| `Anekanta` | 5 — lines 90, 227, 328, 361, 368 |

Every raw hit in the other ten is inside a comment: those modules *discuss*
the decision they do not take. The lane's claim survives an independent
check, and the sole module that fails it is the one already flagged and
already excluded from the closure.

**Not a ranking, and both directions are checked in the module.** `peel`
asks less of the prover — its step law is a reduction. `ask` asks less of
the author — it is one definition uniform in `Discrete A`, instantiated at
ℕ *and* Bool from the same line, where `peel` is a case tree that must be
rewritten per carrier. `ask-step` proves the decided presentation still has
the step law; what is true is narrower than "it lacks the law" — its law is
a theorem where the structural one's is a reduction. The two are
incomparable: an open term favours `peel`, a carrier with decidable
equality and no useful induction principle favours `ask`.

**A limit, stated because the module cannot state it.** Agda cannot express
"this equation does not hold by `refl`". `peel-step = refl` is exhibited;
the corresponding negative claim about `askℕ` is metatheoretic, is prose in
both files, and nothing is derived from it.

Adjacent, already in the corpus and the same shape: `Anuvrtti` proves a
presentation-level measure (लाघव under anuvṛtti) carries information no
invariant of the rule *set* carries — there the non-descent was the point,
not a defect. A property that does not descend to a quotient is not a
property that fails to exist.

---

## Appended 2026-08-19 (second append, same reader): one of the three faces recurs for the convergents, and only one

The note's `PROVE` tag asks *"whether the three honesty faces (lossless /
complete / stable) recur for continued-fraction convergents — the vallī
already IS the CF."*

**Lossless: yes, exactly.** Checked in
`formal/cubical/NaturalMachine/TheValliConvergentDeterminantAlternates.agda`.
For partial quotients `a : ℕ → ℤ` and **arbitrary** seeds, with

```agda
num (suc (suc k)) = a (suc k) · num (suc k) + num k     -- and den likewise
det k = num k · den (suc k) - num (suc k) · den k
```

```agda
detAlternates    : det (suc k) ≡ - det k          -- ring algebra alone
detIsSignedFirst : det k ≡ signed k (det 0)
standardDeterminantIsAUnit : det k ≡ signed k (pos 1)  -- standard seeds
```

A determinant that is a unit at every step is exactly the statement that the
2×2 step matrix is invertible over ℤ: no step of the vallī loses information.
That is `Punaragamana.पुनरागमनम्` and `Gati.अलोपः` at the convergents, and it
is what `Bija.बीजगणितम्`'s alternating orientation is computing — the
alternation is that orientation, as an identity.

**Complete and stable: NOT answered.** `Purnata.पूर्णतया-गुरुतमः` and
`Sthairya.स्थैर्य-गति` are statements about a *grant*, and no grant appears in
that module. One face out of three is one third of the tag, not the tag. The
tag stays open.

**Two incidental confirmations, both of this note's own lane.** The five-variable
step law went through `solve ℤCommRing` unchanged. The base case did **not** —
it failed exactly as `Madhava.agda`'s parenthetical warns (*the ℤ ring solver
does not recognise `pos 1` as the ring one, so one-bearing identities are done
by hand*), and was closed by hand with `·Comm`. That warning is live and now
has a second witness.

**Limits.** Verse-level sourcing OWED AND NOT CLAIMED, as for both Kuttaka
lanes; nothing above is offered as a reading of Gaṇitapāda 32–33. No limit, no
order, no ℝ: convergence is not touched. `det 0 ≡ 1` is proved for the
standard seeds only; §3 is stated for arbitrary seeds because that is where
the algebra lives.

**Toolchain, stated because it must be.** `EXIT=0` on the **container** (Agda
2.6.3 + cubical v0.5), and `formal/cubical/check.sh` returns `CHECKSH_EXIT=1`
with its banner *"NOT THE PIN — RESULTS BELOW ARE NOT EVIDENCE ABOUT THE
PIN"*; the declared pin is Agda 2.8.0 + cubical v0.9. See
`notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md`.

### Same tag, second face: stable

`formal/cubical/NaturalMachine/ConvergentsAreDeterminedByThePrefixOfTheValli.agda`.
`Sthairya.स्थैर्य-गति` is *"a resolved answer is unchanged by more grant"*. The
grant at the convergents is how much of the vallī has been read:

```agda
Agree a b n = (j : ℕ) → j < n → a j ≡ b j
numPrefix : Agree a b k       → num a … k ≡ num b … k
denPrefix : Agree a b k       → den a … k ≡ den b … k
detPrefix : Agree a b (suc k) → det a … k ≡ det b … k
```

Two quotient sequences agreeing below `k` give the same `k`-th convergent, so
reading further never revises what was already produced. The determinant
reaches one index further and needs one more of the vallī — stated in the
module rather than glossed.

**What the seeds cost, recorded because it is easy to hide.** The theorem holds
for arbitrary seeds, where index 1 is `p₁` and so is `refl`. Under the
standard seeding `p₁ = a 0` that is no longer so: instantiating reintroduces a
dependence on the vallī at index 1, and the theorem then applies only to
sequences already agreeing at 0. The seeds are parameters precisely so that is
visible.

**Two of three. COMPLETE is still not answered** and neither module bears on
it: it is the claim that enough grant always resolves, which for the vallī
means the expansion of a rational terminates with the last convergent equal to
it — a fact about the kuṭṭaka, not about this recurrence. The tag stays open.

Toolchain: `EXIT=0` on the **container** (Agda 2.6.3 + cubical v0.5);
`check.sh` returns `CHECKSH_EXIT=1` under *"NOT THE PIN"*. Declared pin: Agda
2.8.0 + cubical v0.9.

### The third face: attempted, not obtained, and here is exactly what it needs

`formal/cubical/NaturalMachine/EveryCommonDivisorOfAConvergentDividesTheDeterminant.agda`
is what the attempt on **complete** produced, and it is a corollary of the
first face, not progress on the third.

```agda
commonDivisorDividesDet  : d divides N k → d divides D k → d divides det k
commonDivisorDividesAUnit: … → d divides signed k (pos 1)      -- standard seeds
```

**Why complete does not come from the recurrence.** `Purnata.पूर्णतया-गुरुतमः`
says enough grant always resolves. At the convergents that reads: the vallī of
a rational terminates, and the last convergent cross-multiplies back to it —
`num K · b ≡ a · den K` at the terminal index `K`. Everything in that except
the cross-multiplication is about how the quotients are **produced** and that
the production **stops**, which is the kuṭṭaka (`Gati`, `Purnata`,
`GurutamaSiddha`) and not the two-step recurrence the convergent modules
study. Anyone continuing should start there, not from those two.

**Not claimed: that the convergents are in lowest terms.** That needs "a
divisor of ±1 in ℤ is ±1" — a classification of units which is neither proved
nor imported. The module stops where the algebra stops: the common divisor
divides a unit. Calling that *coprime* would be asserting the missing step.

So the tag stands at **two of three answered, one attempted and reported
open**, with the obstruction named rather than left as "future work".

Toolchain: `EXIT=0` on the **container** (Agda 2.6.3 + cubical v0.5);
`check.sh` → `CHECKSH_EXIT=1` under *"NOT THE PIN"*. Declared pin: Agda 2.8.0
+ cubical v0.9.
