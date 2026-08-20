# शेषपरीक्षा — the six lemmas behind the induction wall, and which of the three things they are

**Verdict, before the method. Of the six lemmas the Agda kernel demanded and
no composition law reaches, ZERO need a proof principle stronger than
structural induction on one ℕ. Three were already inside the emitter's reach
and had never been asked, because `Certificate.certifyWith` read the induction
variable off the caller's proof note and a residual harvested from the kernel
carries no note. Asking each variable in turn — the shape menu untouched —
certifies all three, including `x = x + (0·x)`, the residual this engine
circled for 239 rounds. The other three are inside the emitted fragment and a
witness for each type-checks; what they need is path composition, `sym`, a
lemma in scope, and a congruence at a position the menu does not offer. Every
number below was obtained from agda on this container with
`MATH_CERTCACHE=0`, and both roads run the two controls before any acceptance
is honoured.**

Instrument:
`machine/SesaPariksa_WhichOfTheSixOutstandingDemandsInductionReaches.hs`.

---

## 1. Where the six come from, and what was and was not established about them

`notes/SamasaBhavana_TheEnginesGenerationStepMadeCompositionAndWhatItCost.md`
§§6–9 scores three composition hands — *samāsa*, *prakṣepa*, *tulya* — against
`Obstruction.curriculum`, the lemmas the kernel actually stalled on:

    distinct truths, three hands:     119489
    lemmas the kernel demanded:            9
      already known outright:              3
      reached ONLY with tulya:             1     (x = x + (0 · x))
      still out of reach:                  5

and establishes, as algebra rather than as a budget claim, that none of the
five is an equational consequence of the 47 base facts, so no composition law
whatever reaches them. That note closes with *"they need induction"* and
stops there.

**Between "needs induction" and "the emitter cannot produce it" are three
different objects.** Reporting them as one is the collapse this parīkṣā
exists to refuse:

| | |
|---|---|
| **(a)** | the emitter reaches it and was never ASKED |
| **(b)** | the proof lives inside the emitted fragment and the shape menu cannot SPELL it |
| **(c)** | the statement needs a stronger principle — course-of-values, a generalised hypothesis, nested induction, a side condition |

Only (c) is a mathematical gap. (a) is a wiring question and (b) prices itself,
because the witness that settles it IS the shape that was missing.

The six examined are the five above plus the one tulya reached, since the
kernel had refused that one too:

    x            = x + (0 · x)
    x · (y + 0)  = (x · y) + (x · 0)
    max(x,y) + 0 = max(x + 0, y + 0)
    max(0,x) + 0 = max(0 + 0, x + 0)
    0            = le(s(x + y), y)
    0            = le(s(s(s(x))), x)

## 2. What the generator can emit — the whole inventory

`Certificate.agdaInductionCertificate` emits exactly this and nothing else:

* induction on **one** variable, and **the caller names it**
  (`inductionVariable proofNote`; no note, no induction module at all);
* base clause **hardwired `refl`** — §3a of `machine/CERTIFICATE_REACH.md`
  measured a searched base clause and reverted it, at +60 agda calls for +0
  theorems;
* step clause: one member of `stepShapes`, which is

      refl · ih · cong suc ih
      cong (_+ k) ih · cong (k +_) ih · cong (_· k) ih · cong (k ·_) ih

  for `k` among the first two variables of the equation.

Four properties of that list are load-bearing and each is independently
binding:

1. **The induction variable is not chosen, it is read.**
2. **Every step is ONE application.** No `_∙_`, no `sym`.
3. **Congruence sections exist for `+` and `·` only**, and only with a bare
   variable in the hole — no `max`, no `le`, no `∸`, no `cong₂`, no
   non-variable context.
4. **Nothing is in scope but the vocabulary.** No previously certified lemma,
   and not the defining equations `a + 0 ≡ a`, `a + suc b ≡ suc (a + b)`,
   `a · 0 ≡ 0`.

## 3. Road one — the shipped emitter, asked with the empty note

Each of the six is submitted through `certifyWith` with the note a residual
actually carries, which is nothing. The first run of this file returned 0 of 6,
all six rejected after one agda call each, no induction module emitted.

**Property 1 is the whole of that 0.** With the fallback in `certifyWith` —
try each variable of the equation in turn, shape menu untouched, bounded by
`kMaxAgdaCallsUnannotated` — the same six give:

    REACHED   x = x + (0 * x)                  induction on x, step = cong suc  (4 calls)
    REACHED   max(0,x) + 0 = max(0 + 0, x + 0) induction on x, step = refl      (2 calls)
    REACHED   0 = le(s(s(s(x))), x)            induction on x, step = ih        (3 calls)
    open      x * (y + 0) = (x * y) + (x * 0)
    open      max(x,y) + 0 = max(x + 0, y + 0)
    open      0 = le(s(x + y), y)

    controls: 4/4 deliberate falsehoods refused

`x = x + (0·x)` is the flagship. `MathMachine.hs`'s own comment on the
residual seam records its predecessor sitting there 27 times over 239 rounds;
§9.1 of the SamasaBhavana note records that composition REACHED it and it
still did not become a theorem, and gives the reason as the prover rather than
the generator. That is confirmed and located: the prover was never run on it.
It closes on `cong suc` — a shape that has been in `stepShapes` since the day
the file was written.

`max(0,x) + 0 = max(0 + 0, x + 0)` closing on `step = refl` was not predicted
by hand before the run; the hand analysis had it as a road-two case. The
measurement is what is reported.

## 4. Road two — a witness inside the same fragment

For the remaining three, a module is emitted with the same `preambleWith`, the
same local `max`/`le` transcriptions, and the machine's own defining equations
**proved in the module by induction from the library's definitions, never
imported**. That restriction is `machine/CERTIFICATE_REACH.md` §2's rule: a
module that may cite `+-comm` certifies by the library already knowing the
answer, and the engine's contribution collapses from proof to discovery with
nothing in the log saying so.

    addZero : (a : ℕ) → (a + zero) ≡ a
    addSuc  : (a b : ℕ) → (a + suc b) ≡ suc (a + b)
    mulZero : (a : ℕ) → (a · zero) ≡ zero

All three witnesses type-check, one agda call each:

    x · (y + 0) ≡ (x · y) + (x · 0)
      cong (x ·_) (addZero y) ∙ sym (cong ((x · y) +_) (mulZero x) ∙ addZero (x · y))

    max x y + 0 ≡ max (x + 0) (y + 0)
      addZero (max x y) ∙ sym (cong₂ max (addZero x) (addZero y))

    0 ≡ le (suc (x + y)) y
      sesa x zero    = refl
      sesa x (suc y) = sesa x y ∙ sym (cong (λ t → le t y) (addSuc x y))

Control: the same lemma block used to "prove" `(a + 0) ≡ suc a` — refused. It
is carried separately from the shared kernel canary because the canary does not
import the block, so a block quietly made inconsistent would not be caught by it.

**Read the three proof terms against §2's inventory and the shortfall is
exact.** Two `∙` and a `sym` (property 2). A `cong₂` and a `le`-section
(property 3). Three lemmas that must be in scope (property 4). The induction in
the third is structural, on one ℕ, with the other variable fixed — nothing
`agdaInductionCertificate` cannot already spell.

**So: (c) is empty. Six of six are (a) or (b).** The wall is the proof-term
language, not the induction principle.

## 5. The price of property 1, measured on the traffic

A bound never measured against the traffic is a bound and not a price.
`machine/library.snapshot.txt` is read from disk and **every note is
stripped**, which is precisely the shape a residual arrives in:

| | certified | agda calls |
|---|---:|---:|
| note-less, before | **5 / 28** | 28 |
| note-less, after | **15 / 28** | 144 |
| annotated, after | **15 / 28** | 123 |

The before row is exact and derived, not measured: `inductionVariable "" =
Nothing` refused after exactly one call, so the note-less reach was precisely
the lines that close by `refl`, and there are five. The other two rows are
measured on this container.

**The annotated row is byte-identical to the run before the change** — same
fifteen lines, same shapes, same 123 calls, falsehoods 4/4. An annotated
candidate tries one variable and pays one variable's budget, exactly as
before. `machine/MargaRaksana_...hs` re-measures the published union at
**20/28, falsehoods 4/4 refused by both routes**, unchanged.

So the proof note is no longer load-bearing for REACH. It is worth 21 agda
calls over the snapshot, and the whole of that difference is search the note
would have skipped.

## 6. Why this is not the search §3a refuses

`CERTIFICATE_REACH.md` §3a refuses extending the menu, in its own words:
*"a menu that did would be a search over compositions — which is a proof
search, badly, in another process."* That refusal is about the space of proof
TERMS, which is unbounded. This searches over the **≤ 6 variables of the
equation** with the menu fixed; the bound is stated
(`kMaxAgdaCallsUnannotated = 1 + 3 × 11`) and derived rather than guessed, and
§5 measures what it actually costs.

The three of §4 are the ones §3a is about, and nothing here proposes searching
for them. `CERTIFICATE_REACH.md` §10.4 already names the route that reaches
past the menu — transcription of the trace the engine already found, not more
shapes — and these three are now three concrete, type-checked targets for it,
each with the proof term written out.

## 7. What is NOT claimed

* Not that 3/6 is a property of the engine. It is a property of these six
  demands, this container, this menu, and this variable order. The demands are
  read from the SamasaBhavana note's §9 listing, not re-derived from a live
  `Obstruction.curriculum` run.
* Not that the wire is measured. The fallback is measured against the snapshot
  with its notes stripped; whether the engine's round loop proves MORE THEOREMS
  with it has not been run. §9.1's standing prediction is that it will not move
  yield at these budgets, and that prediction is now testable on a prover that
  can actually be asked.
* Not that soundness moved. It did not. Both roads end in `runAgdaCached`,
  which runs `vetSuccess`; five deliberate falsehoods here plus the shared
  canary are five falsehoods and a canary, and are not a proof of soundness.
* Not that (c) is empty for the engine. It is empty for these six.
* The road-two witnesses are hand-written. That is the point of them — they
  measure what the fragment can express, not what the emitter produces — and
  the emitter still cannot produce any of the three.

## Replay

```sh
ghc -O1 -imachine -outputdir /tmp/sp-build -o /tmp/sesa-pariksa \
    -main-is SesaPariksa_WhichOfTheSixOutstandingDemandsInductionReaches \
    machine/SesaPariksa_WhichOfTheSixOutstandingDemandsInductionReaches.hs
MATH_CERTCACHE=0 /tmp/sesa-pariksa .

# the annotated path, which must not have moved
ghc -O1 -imachine -outputdir /tmp/cert-build -o /tmp/cert-selftest \
    -main-is Certificate machine/Certificate.hs
MATH_CERTCACHE=0 /tmp/cert-selftest .        # 15/28, 123 calls, falsehoods 4/4

# the published union
ghc -O1 -imachine -outputdir /tmp/mr-build -o /tmp/mr \
    -main-is MargaRaksana_TheProofPathIsKeptNotSearchedAgain \
    machine/MargaRaksana_TheProofPathIsKeptNotSearchedAgain.hs
MATH_CERTCACHE=0 /tmp/mr .                   # 20/28, falsehoods 4/4 both routes

sh machine/run-yantra.sh                     # exit 0
```

Agda 2.8.0, cubical registered via `~/.agda/defaults`, GHC 9.12.2,
macOS/arm64.

---

**शेष.** Three demands are handed forward with their proof terms written out
and type-checked, and they are handed to transcription rather than to a wider
menu. `यत् न विभजते तत् रक्ष्यते । रक्षितं तत् अग्रिमस्य पदस्य उपादानम् ।`
