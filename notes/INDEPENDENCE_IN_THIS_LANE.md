# Independence in this lane: what can be stated, what is closed, and what is not Gödel

**Status:** one thread, run to a resting point. Thirteen modules under
`formal/cubical/NaturalMachine/`, all `--safe`, no postulates, no holes,
all in `RootsThreadLatch`, latch `EXIT=0` at `beb8f80c`. Agda 2.6.3 /
cubical v0.5 — the container, not the repository pin. The module count
was obtained by listing the files, not recalled.

**Where it came from.** `notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md` closes
the deflationary thread and ends: *"If a real barrier is wanted, the lane
has to change, and saying which lane is the next question."* It names two
kinds of real barrier — independence **from a theory**, and non-existence
of an algorithm **uniform in a parameter** — and says neither is
`¬ (Dec A)` for fixed `A`. This thread took both.

---

## 1. The uniform route

`TheUniformFormIsNotRefuted`. For a family `P : X → Type`:

| form | status |
|---|---|
| `¬ (Dec (P n))` at fixed `n` | refuted (`DeflationaryTest.no-barrier-claim`) |
| `(n : X) → ¬ (Dec (P n))` | refuted, given a point of `X` |
| `¬ ((n : X) → Dec (P n))` | **not refuted** |

and refuting the third is *exactly* a double-negation shift at that
family — both directions proved, so the shift and the refutation are one
open question, not two. The answer to "which lane" here: the one where
the parameter is quantified **inside** the negation.

## 2. The independence route, abstractly

`IndependenceNeedsAnInternalImplication` writes down what nobody had:

    Independent T s = (¬ Pf T s) × (¬ Pf T (neg T s))

and shows it is **not** derivable from consistency, HBL1 and `GoedelFix`
— any such derivation projects to the conjunct `GodelSeparation.noHalfTwo`
refutes, so its countermodel applies unchanged. It also corrects
`EVERY_OBSTRUCTION_HERE_IS_EXACT.md`: the lane **does** carry the objects
(`Theory` with `Sent`, `Pf`, `neg`, `prov`; `Consistent`; `HBL1`;
`OmegaBad`); what was missing was the predicate.

`TheDiagonalLemmaDischargesGoedelFix` writes down representability
(`HasDiagonal`: one-place formulas, application, a fixed point stated as
a **pair of provable implications** since `Theory` has no conjunction)
and proves it **discharges `GoedelFix`** by two applications of modus
ponens — no consistency, no HBL1, no ω-consistency. The second conjunct
additionally needs internal contraposition, double-negation elimination
and transitivity; internal DNE is a classicality assumption about `T` and
is labelled as one. So "which lane", on this route: a **propositional
fragment internal to the theory**. The first conjunct needs `imp` and
`mp` only; the second needs all five plus ω-consistency.

## 3. Two closure results, on grounds that do not reduce to each other

- `ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence` — if `prov`
  is interpreted by a function of the **truth value** of its argument,
  then value-level HBL1 (`f true ≡ true`) plus validity of the forward
  diagonal axiom force the diagonal sentence **false in every model**. So
  the model the two-model criterion needs does not **exist**.
- `TheRefutingModelAlreadyGivesTheFirstConjunct` — if `prov` is
  interpreted by a predicate on **syntax**, a model refuting `¬g` forces
  that predicate false at `g`, hence `¬ Der g` outright. So the model is
  not **informative**: it exists exactly when the conjunct it was meant to
  prove already holds.

*Syāt* — in the respect of truth-functional interpretations the criterion
fails for non-existence; *syāt* — in the respect of syntax-indexed ones it
fails for non-informativeness. Same verdict, different grounds; the
collapse is refused. This is the one place in the thread where a Jaina
lens did work rather than decoration, and it is recorded in the module.

What survives is the shape of the real theorem: `goedelHalfOne` obtains
the first conjunct **syntactically**, with no model at all.

## 4. Why every early model was doomed, twice over

- `AProvabilityDeterminedImplicationForbidsIndependence` — a
  provability-determined implication, with contraposition, modus ponens
  and one unprovable sentence with provable negation, admits **no**
  independent sentence. Four lines.
- `NegationCompletenessForbidsIndependence` — one hypothesis with no
  connectives in it does the same: if `¬ Pf s → Pf (neg s)` for every
  `s`, nothing is independent. One line.

Neither subsumes the other. In the respect of assumptions about the
connectives the second asks less; in the respect of assumptions about the
theory the first asks less. Both are kept.

`RepresentabilityIsNotEnoughForIndependence` shows `GodelSeparation.Wit`
carries a `HasDiagonal` (with `Form = Unit`), so representability is not
the escape; `WitSatisfiesEveryHypothesisButOmegaConsistency` shows
contraposition, DNE and transitivity all hold in `Wit` too. **That module
carries an appended correction**: `Wit` fails independence for two
unrelated reasons, so it is a valid separation but not evidence about
which hypothesis is load-bearing.

## 5. The positive instances

`ASmallTheoryWithAnIndependentSentence` — free syntax, `Der` generated by
`taut` and `mp` only, soundness for every Boolean valuation, the atom
independent, the theory consistent and neither negation-complete nor
provability-determined.

`ADiagonalSentenceIndependentInAConcreteTheory` — syntax `gs, ng, im, pv`;
`Der` generated by `taut, mp, hbl, dfwd, dbwd`. First conjunct by a
truth-functional model, second by a syntax-indexed one whose
`hbl`-soundness **is** the first conjunct. The two closure results of §3
describe exactly the order in which this has to be done.

`TheInternalRulesPreserveIndependenceInThisCalculus` — adding
contraposition, DNE and transitivity changes nothing: all three are sound
in **both** models, because their soundness is a fact about the Boolean
connectives alone and `pv` is the only place the models differ. *A rule
whose soundness is a propositional tautology cannot separate two models
that agree on the connectives.* I had predicted contraposition would kill
independence; it does not, and that is recorded as found.

`TheOmegaInconsistentExtensionDerivesTheNegation` — the same calculus plus
double-negation introduction and the axiom `pv gs`. The truth-functional
model survives, so the first conjunct holds and the calculus is still
**consistent**; but `ng gs` is **derived** in three steps, so independence
is refuted and `OmegaBad` holds.

**The pair is the point.** Same syntax, same diagonal pair, same
connective rules, same first conjunct. The second conjunct changes with
ω-consistency and with nothing else that was varied — the separation
`Wit` could not provide.

---

## What this is NOT

Stated here once, in full, because every module inherits it and the
temptation to drop it grows with each citation.

- **This is not Gödel's first incompleteness theorem, and no module here
  is a step of it.**
- `hbl` is a **rule of a calculus**, not a derivability condition proved
  about a real provability predicate.
- `pv` is an **uninterpreted operator**; the marking predicate `P` in the
  syntax-indexed model is **chosen by hand**, which is permitted precisely
  because nothing forces it to track derivability.
- `HasDiagonal` is inhabited only with `Form = Unit` — one formula. A
  one-formula structure has no substitution, no coding, and no diagonal
  for anything else. Nothing here is arithmetisation, and a grep of
  `formal/cubical` for `Representab` and `Form` finds no such thing
  anywhere in the corpus.
- The ω-inconsistency of §5's second calculus is an **axiom**, not
  something forced by arithmetic. That is the whole difference between it
  and a theory anyone would use.
- `gs` is independent in the ω-consistent calculus **partly because the
  rules are few**. One more rule plus one axiom ends it.

## Open

- Make `hbl` a proved property rather than a constructor. That needs `pv`
  interpreted, i.e. a step toward arithmetisation — the gap named above.
- Independence **from a theory** in the metamathematical sense: whether
  `Pf` models a proof predicate for any actual theory is settled nowhere
  in this corpus that I could find.
- The double-negation shift of §1, which is one open question wearing two
  names.

## Corrections made to this thread's own earlier claims

Recorded because the record is the point, and appended at each site
rather than applied by deletion.

1. `Wit`'s failure of independence is overdetermined; the ω-consistency
   separation there is valid but is not evidence about load-bearing.
   (Later supplied by the §5 pair, and a pointer records that.)
2. `¬ FactorsThrough` is **not** "the fourth bhaṅga, proved" — withdrawn
   as undischarged, not false.
3. The catuṣkoṭi cannot be modelled here as four naive formulas: `¬¬Dec A`
   holds for every `A`, so "neither" and "both" are absurd before the
   reading starts.
4. A prior-art paragraph claiming zero grep hits was wrong in first
   draft; the grep now runs and its output is quoted.
5. A predicted outcome (contraposition killing independence) was wrong and
   is reported as found.

## Prior art, searched before this note was written

`notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md` is the parent and carries an
appended correction from this thread. `notes/GODEL_BRIDGE_ADJUDICATED.md`
adjudicates the geometric/logical **bridge** a pun, with two independent
witnesses — a different question, closed, not reopened here.
`HEADER_CLAIM_AUDIT.md` and `LEDGERS_RECONCILED.md` mention
`goedelHalfOne` in passing (once and twice respectively) and do not cover
this line. A note phrased around "undecidability" rather than
"independence" would have evaded that search.

---

## Appended: this line's negatives are now typed

`notes/NEGATIVE_KNOWLEDGE_IS_TYPED.md` §6 (appended by this thread, at that
note's own §4.1 invitation) types every negative recorded above against its
T1–T5 scheme. Most are T1; the truth-functional closure is a clean T2 with
both halves of its certificate present; the uniform barrier form is T5 with
its forecast registered. One fits none — the syntax-indexed closure, which is
neither a refutation nor an impossibility but a **non-informative
instrument** — and a sixth type is proposed there, in the form that note
requires, with the instance first so it can be struck.
