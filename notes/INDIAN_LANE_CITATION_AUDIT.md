# Indian-lane citation audit — 15 modules in `formal/cubical/`

**Auditor:** read-only pass, 2026-08-18. No `.agda` or `.hs` file was edited.
**Scope:** `Kuttaka`, `Bhavana`, `BhavanaSemiring`, `BhavanaGenerative`,
`CakravalaDescent`, `Pingala`, `Sivasutra`, `Anekanta`, `JainSankhya`,
`AbhavaAvacchedaka`, `MachineCurriculum`, `BhedaAvatarana`, `Punaragamana`,
`KuttakaValli`, `Saptabhangi`.

**The defect class hunted** (stated in `Bhavana.agda`:15–19 and
`CakravalaDescent.agda`:20–24, and adopted here as the audit's own standard):

> A dangling citation is a bare label — a claim carrying no evidence, in a
> form a reader takes as "it is handled over there".

The audit extends that standard in three directions, because all three turned
out to be populated: a reference whose *target* exists but whose *content* is
not what the citing line says; a header "Contents" entry with no definition
behind it; and a measured number quoted as a standing fact after the file it
was measured from has moved.

---

## 0. Honest counts

| quantity | count |
|---|---|
| modules audited | 15 |
| `agda` runs performed | 15 |
| modules with exit code 0 | **14** |
| modules with nonzero exit | **1** (`KuttakaValli`, exit 42) |
| `postulate` occurrences across all 15 | **0** |
| holes `{!` across all 15 | **0** |
| `TODO` / `FIXME` / `XXX` across all 15 | **0** |
| OPTIONS pragmas carrying `--cubical --safe` | **15 of 15** |
| distinct reference targets checked | **29** |
| targets that resolve correctly | **25** |
| **dangling references found** | **3** |
| partially-resolving references | 1 (`R0035`) |
| path-ambiguous references | 1 (`BUILD.md`) |
| findings raised (all severities) | 17 |
| modules with **no finding at all** | **5** (`Kuttaka`, `Pingala`, `BhedaAvatarana`, `Punaragamana`, `AbhavaAvacchedaka` — the last has one minor, F16) |
| header claims checked and found **CORRECT** | **31** (listed in §4) |

---

## 1. Per-file verdict table

| file | agda exit | postulates / holes | dangling refs | findings |
|---|---|---|---|---|
| `Kuttaka.agda` | 0 | 0 / 0 | 0 | **none** — every header item present, `iṣṭa` honestly excluded, and the fallback-build claim at :19–24 is *verified true* |
| `Bhavana.agda` | 0 | 0 / 0 | 0 | F3 (propagated), path-ambiguous `BUILD.md` |
| `BhavanaSemiring.agda` | 0 | 0 / 0 | 0 | **F3**, F9 |
| `BhavanaGenerative.agda` | 0 | 0 / 0 | 0 | **F5**, F3, F10 |
| `CakravalaDescent.agda` | 0 | 0 / 0 | **2** | **F6**, F7 |
| `Pingala.agda` | 0 | 0 / 0 | 0 | **none** |
| `Sivasutra.agda` | 0 | 0 / 0 | **1** | **F4** |
| `Anekanta.agda` | 0 | 0 / 0 | 0 | **F1**, F13, F14 |
| `JainSankhya.agda` | 0 | 0 / 0 | 0 | F11, F17 |
| `AbhavaAvacchedaka.agda` | 0 | 0 / 0 | 0 | F16 (minor) |
| `MachineCurriculum.agda` | 0 | 0 / 0 | 0 | F8 |
| `BhedaAvatarana.agda` | 0 | 0 / 0 | 0 | **none** |
| `Punaragamana.agda` | 0 | 0 / 0 | 0 | **none** |
| `KuttakaValli.agda` | **42** | 0 / 0 | 0 | F18 (build, not the file's own fault) |
| `Saptabhangi.agda` | 0 | 0 / 0 | 0 | **F2**, F12, F15 |

Exit codes are from `cd /home/user/math/formal/cubical && LC_ALL=C.UTF-8 agda
<file>.agda`, Agda 2.6.3, library `natural-machine` with `depend: cubical`
(the container's cubical pin is v0.5).

---

## 2. Findings

### F1 — SEVERE. `Anekanta.agda`:41 — the `अस्ति` constructor's "witness" witnesses nothing about the objects it is indexed by

```agda
data भङ्ग : वल्ली → वल्ली → Type where
  अस्ति : {a b : वल्ली} (n : ℕ) {p q : ℕ} → ¬ (p ≡ q) → भङ्ग a b
  अवक्तव्यम् : {a b : वल्ली} (शेषa शेषb : वल्ली) → भङ्ग a b
```

The header glosses this at :35 as

> `अस्ति : नये n दृष्टः भेदः (a witnessed difference at नय n)`

and at :56–57 as

> `discreteℕ ददाति नकारं (खण्डनम् = साक्षी भेदस्य) वा स्वीकारम्`
> ("discreteℕ gives a refutation — the refutation is the *witness of the
> difference* — or an acceptance")

and the whole file is written against bare labels: :17–18,

> `Dec, न तु Bool: नकारः खण्डनं ददाति, स्वीकारः साक्षिणम् — क्वापि न शून्यबोधः
> (no bare truth-value anywhere).`

But `p` and `q` are implicit and **unconstrained by `a`, `b`, or `n`**. Nothing
ties them to the entries of the two vallīs at depth `n`. Consequently:

- `¬ (p ≡ q)` is a disequality between two arbitrary naturals of the
  constructor's own choosing, not evidence about `a` and `b`;
- `भङ्ग a b` is inhabited for **every** pair `a b` — by `अस्ति 0 znots` with
  `p := 0, q := 1`, and independently by `अवक्तव्यम् [] []`, whose `a b` are
  likewise free;
- the type `भङ्ग a b` therefore carries **zero** information about `a` and `b`.

This is precisely the defect the file exists to abolish, one level down: the
"witness" is a bare label wearing a witness's clothes. The *functions* are
sound — `प्रक्षेपे-जन्म` (:171–182) is a genuine theorem about `जननम्`, because
`जननम्` instantiates `p, q` to the actual heads — but the datatype's own
advertised guarantee does not hold.

Note the repository already found this by other means: `BhedaAvatarana.agda`
was written to replace `जननम्` and its `भङ्ग` (:38–40) is a plain
non-indexed datatype with `अस्ति (n r : ℕ)`, which *does not* claim to carry a
witness and therefore does not lie about one. `Anekanta.agda` remains checked
in with the claim intact.

### F2 — SEVERE. `Saptabhangi.agda`:99–103 — four measured counts, quoted as facts read off a log, none of which the log now shows

The file, §1:

```
-- these are the three provers the machine actually runs, read
-- off `machine/machine.log`'s own tactic vocabulary:
--
--     663  trace replay          (the machine's own rewriter, exported)
--     480  induction on x, step = refl
--     420  induction on x, step = ih
--     255  induction on x, step = cong suc
--      43  refl
```

Counted against `machine/machine.log` at audit time:

| quoted | actual |
|---|---|
| 663 `trace replay` | **778** |
| 480 `induction on x, step = refl` | **566** |
| 420 `induction on x, step = ih` | **490** |
| 255 `induction on x, step = cong suc` | **305** |

`machine/machine.log` mtime is 2026-08-18 19:44; `Saptabhangi.agda` mtime is
2026-08-18 08:49. The log grew after the numbers were taken. That is not
misconduct — but the numbers are written in the present tense as properties of
a named, live, still-growing file, with no as-of stamp and no line count of the
log they were taken from. This is CLAUDE.md's own corollary in miniature: *a
number without its scaling looks like knowledge*. The fix is one word — an
as-of line count — not a re-measurement.

The same class of staleness affects F8 and F15.

### F3 — SEVERE. `BhavanaSemiring.agda`:89–92 and `BhavanaGenerative.agda`:200–205 — "commutativity is what makes the solutions a monoid" is false, and it has propagated across two files

`BhavanaSemiring.agda`:89–92:

> `-- COMMUTATIVITY OF THE COMPOSITION — samāsa-bhāvanā is symmetric in the two`
> `-- composed pairs, which is what makes the solutions a monoid rather than`
> `-- merely a set closed under an operation.  This is the structural half of`
> `-- what cakravāla stands on.`

`BhavanaGenerative.agda`:200–205:

> `-- 7.  The composition is commutative, which is what makes the solutions a`
> `-- MONOID rather than merely a set closed under an operation — the fact`
> `-- \`BhavanaSemiring.agda\` records over ℕ for the coordinates alone.`

Commutativity is not what makes a monoid; **associativity** and a two-sided
identity are. Grep for `assoc` in `Bhavana.agda`, `BhavanaSemiring.agda`,
`BhavanaGenerative.agda` returns only the *library's* `·Assoc` /
`·CommAssocSwap` used inside unrelated ring chains — there is **no**
associativity statement for `_⊛_`, for `_∙₁_`, or for `cx`/`cy` anywhere in the
lane. So the monoid is claimed twice and established zero times, and the second
occurrence cites the first as its authority. This is exactly the `exp27`
propagation pattern CLAUDE.md's preamble describes.

What *is* proved: closure with the norm multiplying (`_⊛_`, `bhavana`), the
identity element (`cxUnit`/`cyUnit`, `unit`), and commutativity of the
coordinates. That is a commutative *magma with unit*. The missing lemma is one
`⊛AssocA`/`⊛AssocB` pair of ring chains — short, and its absence is the only
reason the word "monoid" is unearned.

### F4 — SEVERE, and a genuine dangling reference. `Sivasutra.agda`:41 — a Contents entry with nothing behind it

Header, under `Contents (no postulates, no holes, --safe)`:

```
--   marker-free                no pratyāhāra contains an it-marker
```

and, restating it as checked, :28–29:

> `The pratyāhāras aṆ, aK, aC then compute to exactly`
> `the traditional classes, by refl; and no it-marker ever appears in a`
> `pratyāhāra (the anubandha is a boundary, not a member).`

`grep -rn "marker-free\|markerFree"` over the whole repository returns **one
hit: this line**. There is no such definition in `Sivasutra.agda` or anywhere
else. The file ends at :125 with a prose paragraph; the last definition is `aC`
at :118–119.

The corroborating evidence that the theorem was intended and then dropped is in
the import list, :48–50:

```agda
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; true≢false)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)
```

`true≢false`, `⊥rec` and `¬_` each occur **exactly once** in the file — on the
import line. They are the exact toolkit a `marker-free` proof would need, left
behind when the proof was not written. A reader who takes the Contents list at
face value believes the anubandha-exclusion is checked. It is not.

### F5 — SEVERE. `BhavanaGenerative.agda` — "GROUP", "monoid", and "three distinct solutions", none of them proved

Three separate unearned claims in one file.

**(a) GROUP.** :147–149:

> `-- 5b.  THE INVERSE.  Unit-norm solutions are a GROUP, and the reason is`
> `-- Brahmagupta's second composition rather than any extra hypothesis.`

What is proved is `invCoefA` (:165–169) and `invCoefB` (:171–174) — that the
*coordinates* of `s ⊛ inv s` are `1r` and `0r`. The group law itself,
`s ∙₁ inv s ≡ unit D`, is never stated (grep for `∙₁` returns only :143, :144,
:186, :196). Associativity is absent (F3). So neither group axiom beyond the
identity is available. The file even supplies the reason it cannot be closed as
stated — :202–204, "`Sol` is not a set without further hypotheses on R and a
path between records would need one" — which makes the flat assertion "are a
GROUP" five sections earlier the wrong sentence, not a missing proof.

**(b) monoid.** :127, section heading: `-- 5.  The trivial solution (1, 0), and
unit-norm solutions as a monoid`. Same gap as F3.

**(c) three distinct solutions.** :270–273:

> `-- The three members are pairwise distinct, so the family at D = 2 is not`
> `-- the constant family.  This is a fact about D = 2, established by`
> `-- computation on three members; it is NOT the injectivity of \`chain\`,`
> `-- which is not proved anywhere in this file.`

and in the header, :42–45:

> `What is exhibited instead, at the end, is the first stretch of the D = 2`
> `chain over ℤ with its members computed and their norms checked — three`
> `distinct solutions`

The only definition following that comment is `seedA : coefA seed ≡ pos 3`
(:274–275). `grep "≢\|¬" BhavanaGenerative.agda` returns **nothing** — there is
no disequality term anywhere in the file. So "established by computation" names
a computation that was not performed, in a comment that is otherwise
scrupulous about what it does not claim. Three `pos m ≢ pos n` terms would
close it.

This one is the most instructive finding in the set, because the sentence
*disclaims* the stronger result (injectivity) in the same breath as it asserts
the weaker one without evidence. Careful hedging on the right flank is not a
substitute for a term on the left.

### F6 — MODERATE, and two genuine dangling references. `CakravalaDescent.agda`:16–19 — a repair note that has itself gone stale

```
-- WHY THIS FILE EXISTS, which is the part worth reading.  `Bhavana.agda`
-- line 287 says, of the step where coprimality enters: "that step is in
-- CakravalaDescent".  There was no `CakravalaDescent`.  Line 14 says
-- "See notes/CAKRAVALA.md"; there is no such note.
```

Both file:line citations are now wrong, in the present tense:

- **`Bhavana.agda`:287** currently reads
  `  -- 5.  Why ONE congruence suffices (Bhāskara's choice rule)`.
  The quoted text `that step is in CakravalaDescent).` is at **:292** — the
  repair block inserted at `Bhavana.agda`:15–19 shifted every line below it by
  five.
- **`Bhavana.agda`:14** currently reads
  `-- never worked on the equation.  The step itself is \`CakravalaDescent\`.`
  It has not said `See notes/CAKRAVALA.md` since the repair. The audit trail
  for that is right there at `Bhavana.agda`:15–19, written in the past tense
  and correctly — which is the model this file should follow.

The content claim (that these two references once dangled) is true and
well-attested. Only the tense and the line numbers are wrong. But a file whose
stated purpose is "the repair is to make the reference true" now carries two
references that are not, which is the audit's most quotable irony.

*General note:* every absolute line-number citation in this lane is a
maintenance liability of exactly this kind. Citing a definition name, or
quoting the text with `grep`-able uniqueness, survives edits; a line number does
not.

### F7 — MODERATE. `CakravalaDescent.agda`:159–161 contradicts :242–255 and the file's own header

§3's closing comment:

> `-- This is what makes the cakravāla an algorithm rather than a search.`
> `-- The remaining factor b is removed by gcd(k, b) = 1, which is a`
> `-- kuṭṭaka; that join is not made here and is not claimed.`

But §3b, twenty lines later, makes exactly that join — `oneCongruenceCoprime`
(:246–257) — and the header advertises it at :55–62 as "THE JOIN". §3b's own
preamble at :191–192 even says so: "The commit that landed §3 said so and left
it open. Closing it is one lemma."

So the file contains a live sentence saying a result is not claimed, five
sections above the result. A reader who stops at §3 — the natural stopping
point, since §3 is where `oneCongruence` is proved — leaves believing the lane
is one lemma short when it is not. The remedy is one word ("§3 alone does not
make the join; §3b does").

### F8 — MODERATE. `MachineCurriculum.agda` — a module titled "answered" that leaves one of its own top five unanswered, and quotes counts it does not date

**(a)** :4 — `-- MachineCurriculum — the lemmas the engine asked for, answered.`
The header's ranking, :18–22:

```
--     unblocks 14   0 = y·0
--     unblocks  8   x·0 = 0
--     unblocks  5   x = x+0
--     unblocks  3   0 = 0∸y
--     unblocks  2   x = x + 0·x
```

`0 = 0∸y` is never addressed. `∸` is not imported (:44 imports only
`ℕ ; zero ; suc ; _+_ ; _·_`) and the string `∸` occurs nowhere in the file
except that header row. The fourth-ranked demand is silently dropped from a
module whose title is "answered".

**(b)** :47 — `-- the four that carry the ranking` — is followed by **three**
definitions (`+zero` :50, `·zero` :57, `+·zero` :64). Five rows are listed
above, four are announced, three are proved.

**(c)** :54 — `-- unblocks 8 (and 14, and 6, as \`0 = y·0\` and \`0 = z·0\` …)`.
The count `6` appears nowhere in the header table it is glossing.

**(d)** The counts at :19–21 (`130`, `78`, `54`) and :36 ("a live round
submitted 179 proofs and got 6 back") are not reproducible from the log as it
now stands. Partial corroboration: `round=4` in `machine/machine.log` shows
**6 accepts** — matching exactly — against **165 rejects**, i.e. 171
submissions, not 179. The `6` is a real and striking number; the `179` has
drifted, same mechanism as F2.

### F9 — MODERATE, source attribution. `BhavanaSemiring.agda`:99 — "the Pell identity element" in the one lane that exists to refuse that name

```agda
-- COMPOSITION WITH THE UNIT (1,0) fixes the pair: the Pell identity element.
```

Three sibling files in the same lane are explicit that this is a
misattribution. `Bhavana.agda`:12–13: *"Euler's misattribution to Pell is later
still and concerns a man who never worked on the equation."*
`CakravalaDescent.agda`:13–14: *"'Pell's equation' is Euler's misattribution to
a man who never worked on it, and the name has outlived every correction
since."* CLAUDE.md's own table: *"'Pell's equation' — Pell never solved it;
Euler misattributed it"*.

The equation `x² − D y² = 1` has a name in this lane already — it is
Brahmagupta's `varga-prakṛti`, whose unit is the trivial solution `(1, 0)`. The
directive's whole point is that a later restatement must not stand as the first
citation; here it stands as the *only* citation, at the exact line where the
identity element is named.

### F10 — MODERATE, source attribution. `BhavanaGenerative.agda`:230–233 — "Brahmagupta's own worked numbers for D = 2", unsourced and probably wrong

```
--     3² − 2·2²  = 9 − 8      = 1
--    17² − 2·12² = 289 − 288  = 1
--    99² − 2·70² = 9801 − 9800 = 1
--
-- and each is the previous one composed with the seed by samāsa-bhāvanā.
-- These are Brahmagupta's own worked numbers for D = 2 and every equation
-- below is `refl`
```

The mathematics is correct and machine-checked. The attribution is asserted
with no chapter, verse, or date — in a lane that elsewhere gives
`Brāhmasphuṭasiddhānta, 628 CE, ch. 18 (kuṭṭakādhyāya)` for every other
Brahmagupta claim. Two specific reasons to doubt it as written:

1. The *Brāhmasphuṭasiddhānta* ch. 18's celebrated worked instances of
   varga-prakṛti are **D = 83** and **D = 92**, not D = 2 — D = 2 being too
   easy to be a showcase for bhāvanā.
2. The convergents `3/2, 17/12, 99/70` of √2 have a demonstrably **older**
   Indian home: the Śulba-sūtra tradition (Baudhāyana, Āpastamba,
   Kātyāyana, c. 800–600 BCE) works this exact ladder, giving √2 ≈ 577/408 —
   the very next term after 99/70.

So this is the directive's error running in *both* directions at once: a
citation to a later source standing in for an earlier one, and a specific
textual attribution asserted without the check. Either give the verse, or
write "the standard D = 2 ladder", or — best — cite the Śulba-sūtras, which
would be a genuine strengthening of the lane.

### F11 — MODERATE, source attribution. `JainSankhya.agda`:12–19 — four primary sources, zero dates, and a taxonomy coarser than the tradition's

```
-- the doctrine is systematized in Umāsvāti's Tattvārthasūtra and, with the
-- salākā ("counting-pit") operations that generate the jumps between
-- orders, in Yativṛṣabha's Tiloyapaṇṇattī and Vīrasena's Dhavalā.
```

**(a) No dates.** The *Anuyogadvāra-sūtra*, the *Tattvārthasūtra*, the
*Tiloyapaṇṇattī* and the *Dhavalā* are all named with no date attached, against
CLAUDE.md's operative rule: *"When you name a structure, give the earliest
statement you can establish, with text and date."* Compare `Saptabhangi.agda`
:10–49, which dates every one of its seven sources and even flags a recension
disagreement in the sūtra numbering — that is the standard the lane can already
meet.

**(b) The stratification is coarser than the source.** :7–12 presents the
doctrine as three kinds × three grades = nine magnitudes. The canonical
enumeration in the *Anuyogadvāra* is **twenty-one**: `saṃkhyāta` has three,
but `asaṃkhyāta` and `ananta` each subdivide into three sub-kinds
(`parīta-`, `yukta-`, and `-asaṃkhyāta` / `-ananta`) *before* the
jaghanya/madhyama/utkṛṣṭa grading, giving 3 + 9 + 9. The file's crown theorem
`infinite-is-not-one` (:142–150) exhibits **three** ordered infinities where
the tradition it cites specifies **nine**.

The file is unusually careful about what it does not claim (:21–30, the
disclaimer about not identifying grades with outside cardinals is exactly
right). This is not a claim of falsity — it is a claim that the header presents
a simplification *as* the doctrine, and the simplification is in the direction
that makes the crown theorem weaker than the source supports. Flagged for
verification against the primary text, which is the cheap fix and would
strengthen the result.

### F12 — MODERATE. `Saptabhangi.agda`:467–472 calls "measured" what `machine/Obstruction.hs`:726 calls "by construction"

`Saptabhangi.agda`, §8.3:

> `-- 3. Bhaṅgas 5 and 7 are DEFINABLE (they are in \`saptabhangi-iso\`) but no`
> `--    instance of either is constructed here, and none was found in the`
> `--    machine's data — see the census in \`machine/Obstruction.hs\`.`
> `--    Their emptiness in the data is reported there as a measured fact and`
> `--    is not evidence that they are incoherent.`

`machine/Obstruction.hs`:722–727, at the census:

```haskell
--   * over REJECTION LINES        — every position is reachable
--   * over DISTINCT RESIDUALS     — `avaktavya` is 0 BY CONSTRUCTION, since
--                                   being one of the distinct residuals
--                                   already means the message parsed.
```

For one of the two census populations the emptiness is **definitional**, not
measured — `Obstruction.hs` says so in capitals precisely so nobody reports it
as a measurement. `Saptabhangi.agda` then reports it as a measurement. The
citation resolves; the content on the other end says the opposite of the
sentence citing it. This is the "reference whose target exists but does not say
what the citing line says" case, and it is harder to catch than a missing file
because `ls` cannot find it.

Note that `Obstruction.hs` maintains *two* populations "deliberately, because
they answer different questions and only reporting one of them would mislead"
(:721–722). §8.3 collapses them back into one. The fix is a clause naming which
population.

### F13 — MODERATE. `Anekanta.agda`:94–112 — a seven-constructor `सप्तभङ्गी` of which only four are reachable

`सप्तभङ्गी` is declared with all seven bhaṅgas (:94–101), in the correct
classical order and correctly annotated (`क्रमेण` on the third, `सह :
जिह्वाभेदः` on the fourth). But the only thing that produces a `सप्तभङ्गी` is
`अर्पणम्` (:106–112), whose six clauses reach exactly **four** constructors:
`स्यात्-अस्ति`, `स्यात्-नास्ति`, `स्यात्-अस्ति-नास्ति`, `स्यात्-अवक्तव्यम्`.

`स्यात्-अस्ति-अवक्तव्यम्`, `स्यात्-नास्ति-अवक्तव्यम्` and
`स्यात्-अस्ति-नास्ति-अवक्तव्यम्` (:99–101) have no introduction rule, no
theorem, and no use anywhere in the file. They are three bare labels in a file
whose header line :17–18 declares `क्वापि न शून्यबोधः` — "no bare truth-value
anywhere".

Nothing here is *false*; a datatype may have unreached constructors. But the
header at :4 announces `तस्य सप्तभङ्गी वाणी` — the sevenfold as the file's
speech — and what the file actually operates is a fourfold. Contrast
`Saptabhangi.agda`:335–415, which proves the seven-ness (`saptabhangi-iso`,
`Bhanga ≃ NEBasis`, the non-empty subsets of a three-element set, 2³−1 = 7) and
is explicit at :467–472 about which bhaṅgas have no instances and why. The
later file did this correctly; the earlier one is still asserting it.

### F14 — MINOR. `Anekanta.agda`:140–145 — an uncited empirical number in a header

> `(identity ⟹ silence … That is life: the boolean machine died at a wall`
> `grinding 380 grants with a frozen genome; this does not.)`

Also at :122: `the boolean corpse that ground bits forever`, and at :140:
`शून्यबोधयन्त्रं भित्तौ अम्रियत (bits ३८०, genome स्तब्धः)`.

`380` is a measurement presented as an established fact with no source file, no
log line, and no date — in a lane where `Saptabhangi.agda` demonstrates the
right form (`machine/machine.log` line 146 / line 174, quoted verbatim, both
checked exact by this audit). One `machine/…:NNN` would fix it.

### F15 — MINOR. `Saptabhangi.agda`:483 — "35 claims" does not reproduce

> `--    this repository is empirical — 35 claims in \`machine/machine.log\``
> `--    appear in both the accept and the reject stream`

Audit extraction (claim text between `round=N ` and `  (`, `sort -u` on each
stream, `comm -12`) gives **40**, from 94 distinct accepted and 391 distinct
rejected claims. My extraction may differ in detail from
`Obstruction.hs`'s `claimOfAcceptLine`, so this is not a contradiction — but
the direction and magnitude of the drift match F2 and F8(d) exactly, which is
what makes it worth recording rather than dismissing.

### F16 — MINOR, source attribution. `AbhavaAvacchedaka.agda`:19–23 — three formalizers credited with a claim the repo's own map attributes to one

```
-- (INDIC_FORMAL_TRADITIONS_MAP.md §3.3, §6.3): the tradition's own
-- formalizers — Ganeri, Bhattacharyya, and Panday–Ghosh (Cubical Type
-- Theoretic Navya-Nyāya) — establish that the avacchedaka delimiting a
-- pratiyogin is a TYPE-LEVEL BINDER, not a free variable, which is exactly
-- why higher-order logic cannot hold it and a dependent Π can.
```

Both cited sections exist and were read. `INDIC_FORMAL_TRADITIONS_MAP.md`:481–484
attributes that sentence to **one** source:

> `[ŚABDA] arXiv:2605.12548 states the point in one sentence: an avacchedaka
> delimiting a pratiyogin is **a type-level binder, not a free variable**, which
> is why HOL cannot hold it and Martin-Löf's Π can.`

and `notes/PRIOR_ART_SWEEP_COMPLETE.md`:150 separates the three:
*"Matilal (first-order, HUP 1968, xi+208), Ganeri (higher-order), Bhattacharyya
(Martin-Löf)"*. Ganeri's formalization is **higher-order** — which is precisely
the framework the quoted sentence says *cannot* hold the avacchedaka. So Ganeri
is credited with establishing the inadequacy of his own formalism. The sentence
should credit Panday for the claim and name Ganeri and Bhattacharyya as the
prior formalizations it is a claim *about*.

Everything else in this file checks out, including the exemplary :35–36 —
*"No primary Sanskrit text was opened this session; the slot doctrine is
carried from ABHAVA.md, the repo's own source-critical note"* — which is the
best single sentence of provenance discipline in the fifteen files.

### F17 — MINOR. `JainSankhya.agda`:44–45, :156–157 — `least` is stated at the rank level and is definitionally free

Header Contents:

```
--   least                    jaghanya saṃkhyāta is ≤ every magnitude
--                            (the floor of number)
```

The term:

```agda
least : (a : Magnitude) → rank (saṃkhyāta , jaghanya) ≤ rank a
least a = zero-≤
```

Two gaps between the gloss and the term. The gloss says "≤ every *magnitude*";
the term is about `rank`s, and the file has no `≼` on `Magnitude` to state it
otherwise — which matters because :29–30 insists the rank "is an internal
device for ORDER only; it is not a claim that these magnitudes ARE the numbers
0..8", and `least` is the one result stated only in the device. And the proof
is `zero-≤`: it holds because `rank (saṃkhyāta , jaghanya)` *reduces to* `0`, so
the theorem is definitional bookkeeping rather than a fact about the
stratification. Both are small; neither is wrong; the Contents line reads
stronger than the term.

### F18 — CONTEXT, not a defect of the file. `KuttakaValli.agda` does not build in this container, and one note says it does

```
=== KuttakaValli EXIT=42
Checking KuttakaValli (/home/user/math/formal/cubical/KuttakaValli.agda).
 Checking Gamma0Partner (/home/user/math/formal/cubical/Gamma0Partner.agda).
/home/user/math/formal/cubical/Gamma0Partner.agda:55,23-29
Not in scope: solve!
```

The failure is in a **dependency** (`Gamma0Partner.agda`:55 uses the cubical
v0.9 spelling `solve!`; the container carries v0.5, where it is `solve`), not
in `KuttakaValli.agda` itself, which has no postulates, no holes, and a correct
`--safe` pragma.

**This is a point of credit, not blame, for `Kuttaka.agda`**, whose header
:19–24 predicts it exactly:

> `(It is self-contained over ℤ — no matrix/continuant dependency — so it
> checks under the v0.5 cubical pin this container carries, on which
> KuttakaValli.agda's \`solve!\`-bearing dependencies do NOT build. … 
> Fallback-checked, not pin-green — stated per protocol.)`

Verified true in both halves: `Kuttaka` exits 0, `KuttakaValli` exits 42 for the
stated reason. `formal/cubical/BUILD.md`:160 independently records the same
version skew. This is what a correct claim about build state looks like.

**The adjacent problem** is in a note, not a module, and is recorded here
because `Kuttaka.agda`:14 cites that very section:
`notes/INDIC_FORMAL_TRADITIONS_MAP.md` §5.2 states *"The module checks under
`--safe`"* of `KuttakaValli.agda`. In this container it does not. Since
`Kuttaka.agda` points a reader at §5.2 as the authority on `KuttakaValli`'s
status, the note's unqualified green propagates. One clause naming the pin
would fix it.

---

## 3. Reference-resolution ledger

Every "see X" / named module / named note / named log line in the fifteen
files, checked. **3 dangle.**

| # | citing site | target | status |
|---|---|---|---|
| 1 | `Kuttaka.agda`:13, :125 | `notes/KUTTAKA_SOLUTION_FAMILY.md` | ✅ exists; §"The answer is a family" present as claimed |
| 2 | `Kuttaka.agda`:14 | `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §5.2 | ✅ exists at :379; content matches the summary given |
| 3 | `Kuttaka.agda`:15, :21 | `KuttakaValli.agda` | ✅ exists; build claim verified (F18) |
| 4 | `Kuttaka.agda`:38, `BhavanaSemiring.agda`:35 | `CLAUDE.md` | ✅ |
| 5 | `Bhavana.agda`:14 | `CakravalaDescent` | ✅ exists (this is the 2026-08-18 repair) |
| 6 | `Bhavana.agda`:15 | `notes/CAKRAVALA.md` | ✅ correctly self-reported as never having existed |
| 7 | `Bhavana.agda`:45 | `CayleyPairChart` | ✅ exists; the `1r`-inside-`solve!` hazard is at :34–39 as claimed |
| 8 | `Bhavana.agda`:46 | `BUILD.md` | ⚠️ resolves to `formal/cubical/BUILD.md` (same dir), **not** repo root; content verified at :160 |
| 9 | `Bhavana.agda`:292 | `CakravalaDescent` | ✅ |
| 10 | `BhavanaSemiring.agda`:12 | `Bhavana.agda` | ✅ |
| 11 | `BhavanaSemiring.agda`:19 | `machine/thoughts.bhavana.math` | ✅ exists; the `(0,1,0,1)` witness is at :38 and `28561 of 28561` at :53 |
| 12 | `BhavanaGenerative.agda`:12,:31,:90 | `Bhavana.agda` | ✅ |
| 13 | `BhavanaGenerative.agda`:16,:202 | `BhavanaSemiring.agda` | ✅ (but see F3 — the *content* cited is wrong) |
| 14 | `BhavanaGenerative.agda`:71–73 | `Anekanta.agda`, quoting `नकारः खण्डनं ददाति, स्वीकारः साक्षिणम्` | ✅ verbatim at `Anekanta.agda`:17 |
| 15 | `CakravalaDescent.agda`:17 | `Bhavana.agda` **line 287** | ❌ **DANGLING** — quoted text is at :292 (F6) |
| 16 | `CakravalaDescent.agda`:18–19 | `Bhavana.agda` **line 14** = `See notes/CAKRAVALA.md` | ❌ **DANGLING** — :14 has said otherwise since the repair (F6) |
| 17 | `CakravalaDescent.agda` body | `Bhavana.Form.{cakravalaCleared, choiceToNumerator, choiceToDiscriminant, normScale}`, `Kuttaka.{Run, bezout}` | ✅ all six exist and are used |
| 18 | `Sivasutra.agda`:12 | `INDIC_FORMAL_TRADITIONS_MAP.md` §1.1 | ✅ exists at :45 |
| 19 | `Sivasutra.agda`:14 | Petersen's optimality theorem | ✅ named, and honestly marked NOT proved |
| 20 | `Sivasutra.agda`:41 | `marker-free` | ❌ **DANGLING** — no such definition anywhere in the repo (F4) |
| 21 | `AbhavaAvacchedaka.agda`:14,:36 | `ABHAVA.md` §1 | ✅ exists at :15, "Absence is a relation, not a predicate" |
| 22 | `AbhavaAvacchedaka.agda`:19 | `INDIC_…MAP.md` §3.3, §6.3 | ✅ at :270 and :479 |
| 23 | `AbhavaAvacchedaka.agda`:20 | Panday–Ghosh, arXiv:2605.12548 | ✅ cited with full detail in 4 repo notes (see F16 for the attribution issue) |
| 24 | `MachineCurriculum.agda`:6, `Saptabhangi.agda`:53,:469 | `machine/Obstruction.hs` | ✅ exists; `Bhanga` census at :621–685, :719–741 |
| 25 | `MachineCurriculum.agda`:7, `Saptabhangi.agda`:56,:97,:483 | `machine/machine.log` | ✅ exists (902 KB); numbers stale (F2, F8, F15) |
| 26 | `Saptabhangi.agda`:59–60 | `machine.log` **lines 146 and 174** | ✅ **exact, verbatim, both lines** — the model citation of the set |
| 27 | `Saptabhangi.agda`:486 | `notes/ANEKANTA_THE_MACHINE_HAS_THREE_STANDPOINTS.md` | ✅ |
| 28 | `KuttakaValli.agda`:131 | `notes/KUTTAKA_TRACE_MACRO.md` + gain law `(m-1)(r-1) > 1` | ✅ exists; the law is at :29–31 exactly as quoted |
| 29 | `KuttakaValli.agda`:12 | `R0035` | ⚠️ partial — a real repo trace-vocabulary token (`notes/TRACE_CORPUS_GROWTH_DENSITY.md`:11,:19), no defining file located |

---

## 4. Checked and found CORRECT — 31 items

An audit that reports only problems cannot be calibrated. These were each
checked against the artefact and hold.

**Build and hygiene (5).** All 15 OPTIONS pragmas carry `--cubical --safe`. Zero
`postulate` in 15/15. Zero holes in 15/15. Zero `TODO`/`FIXME` in 15/15. 14/15
exit 0, and the fifteenth fails for the reason another file in the set
predicted in writing.

**Kuttaka (5).** Every "WHAT IS PROVED" item (`Run`, `bezout`, `inhomogeneous`,
`gcdDivides`, `gcdGreatest`) is present and is what it says. The `iṣṭa`
exclusion at :47–50 is honest and correct. The fallback-build prediction at
:19–24 is verified in both directions. The source is dated to the verse
(`Āryabhaṭīya, Gaṇitapāda 32–33, 499 CE`) with the expositor named
(`Bhāskara I, Āryabhaṭīyabhāṣya, 629 CE`). The worked vallī at :209–220
(7 = 1·5+2, 5 = 2·2+1, 2 = 2·1+0) is arithmetically right and `bezout` is
actually applied to it. **This file has no findings against it.**

**Bhavana / CakravalaDescent (6).** `bhavana`, `bhavanaMinus`,
`cakravalaCleared`, `choiceToNumerator`, `choiceToDiscriminant`, `normScale` —
all present, all solver-free as claimed at :43–49, and the reason given for
avoiding the solver is independently confirmed by `BUILD.md`:160 and
`CayleyPairChart.agda`:34. `CakravalaDescent`'s six advertised results all
exist. The `D = 13` worked step at :260–345 is Bhāskara's own and every premise
is `refl`. The termination/minimality/existence exclusions at :69–72 are stated
rather than implied. Brahmagupta is dated to chapter (628 CE, ch. 18,
kuṭṭakādhyāya); Jayadeva (~950, via Udayadivākara's *Sundarī*, 1073) and
Bhāskara II (*Bījagaṇita*, 1150) are both given with the transmission path.

**Pingala (3).** The header claim at :7–8, `न discreteℕ, न Dec, न Bool`, is
verified against the import list — none of the three appears. `छन्दस्≡ℕ` is a
genuine univalence path resting on a real injectivity proof (`मूल्य-एकैकम्`),
not on a `Dec`. Piṅgala (`~300 BCE`) and Halāyudha (*Mṛtasañjīvanī*,
meru-prastāra) are both credited. **No findings.**

**Punaragamana (2).** Every header claim is proved: `पुनरागमनम्` (descent→ascent
round-trip), `अवतरण-उत्थान` (the other direction), and the univalence path
`युग्म≡विवेक`. The critique it levels at `BhedaAvatarana`'s `भेद` (:11–13, that
it dropped the side and the shared magnitude) is accurate on inspection.
**No findings.**

**BhedaAvatarana (1).** Every claim holds; `भेद`'s decisionlessness is real
(no `discreteℕ`, no `Dec`, no `Bool` in the imports), and `प्रक्षेपे-जन्म` /
`प्रक्षेपे-जन्म′` prove the naya-relativity in both orientations. **No findings.**

**Saptabhangi (6).** The best-sourced file in the set: seven sources, each with
a date, and a recension disagreement flagged (TS 1.33 Digambara vs the
Śvetāmbara 1.34–1.35 split, :19–23). `machine.log` lines 146 and 174 quoted
**verbatim and exactly**. §6's combinatorics is a real theorem — `saptabhangi-iso :
Iso Bhanga NEBasis`, seven constructors ≃ non-empty subsets of a 3-set,
2³−1 = 7, matching Akalaṅka's 3+3+1. `krama≢yugapat` (:194–195) is a genuine
cubical result and the file is right that it is why the file is cubical. §8's
five explicit non-claims — including :474–478, "this file should not be cited
as formalising it" — are the strongest disclaimer discipline in the lane.

**Sivasutra (2).** The four śiva-sūtras and their it-markers (a i u Ṇ / ṛ ḷ K /
e o Ṅ / ai au C) are correctly ordered, and `aṆ`, `aK`, `aC` compute by `refl`
to exactly the traditional classes (a i u / a i u ṛ ḷ / all nine vowels).
Petersen's optimality theorem is correctly identified as the deeper object and
correctly excluded.

**JainSankhya (1).** Every Contents item is present and proved, and the
parenthetical `jaghanya saṃkhyāta = 2` at :27 is the correct Jain value (unity
is not a `saṅkhyā` in that scheme) — correctly marked as *not* encoded.

---

## 5. What the pattern says

Sorting the seventeen findings by mechanism rather than by file:

1. **Line-number citations rot; name citations do not.** Both of F6's dangling
   references are line numbers, and both were broken *by the very commit that
   repaired the reference they describe*. Every name-based reference in the
   lane resolved.
2. **A repair that documents itself in the present tense creates the next
   dangling reference.** `Bhavana.agda`:15–19 got this right (past tense,
   "until 2026-08-18"). `CakravalaDescent.agda`:16–19 got it wrong (present
   tense) and is now false.
3. **Measured numbers in headers have no as-of stamp anywhere in the lane.**
   F2, F8(d) and F15 are one defect with three instances, and the fix is a
   log line count, not a re-measurement. `Saptabhangi.agda`:59–60 shows the
   form that survives: quote the *line*, not the *aggregate*.
4. **The algebraic-structure vocabulary is running ahead of the proofs.**
   "Monoid" (twice), "group" (once), "pairwise distinct" (once) are asserted;
   associativity, the group law, and any disequality term are absent from the
   lane entirely. F3 and F5 are one missing lemma-pair away from being true.
5. **The Contents block is trusted and unverified.** F4 (`marker-free`) is the
   only outright phantom in the fifteen files, and it lives in a Contents list
   headed "no postulates, no holes, --safe" — the exact place a reader stops
   checking.
6. **The attribution errors run in both directions, as the directive predicts.**
   F9 lets a European misattribution name the identity element in the one lane
   that exists to refuse it; F10 attaches a specific Indian source to numbers
   that probably belong to an *older* Indian source; F11 gives four primary
   texts with no dates and a taxonomy coarser than the texts'; F16 credits a
   higher-order formalizer with establishing that higher-order logic is
   inadequate. None of the four is decoration-for-its-own-sake — the lane does
   not have the opposite failure of Sanskrit terms hung on structures that are
   not those structures. Where a Sanskrit name is used, the structure under it
   is the right one; `samāsa-bhāvanā`, `antara-bhāvanā`, `tulya-bhāvanā`,
   `prastāra`, `pratyāhāra`, `vallī`, `avacchedaka`, `saptabhaṅgī`,
   `durnaya` and `avaktavyam` are each carried by machinery that genuinely
   does what the term names.

The most serious finding is **F1**, because it is the only one where a *type*
lies rather than a comment: `भङ्ग a b` is inhabited for every `a` and `b` and
its "witness" witnesses an unrelated disequality. Second is **F3/F5**, because
the same unearned word crossed from one file into another citing the first as
authority — the propagation pattern this repository exists to prevent. Third is
**F4**, the one true phantom.

---

*Read-only audit. No `.agda` or `.hs` file was modified; nothing was committed;
`./sync` was not run. Every file:line in this note was read at audit time and
every exit code was produced by an actual run.*
