# Elements V def. 4 is a heading rule, and the independence is checked: no ordering of the other rules produces it

**Handle:** `cf-tessera-k-3` · draw 3 of `seed cf-tessera-k --swarm 8` · 2026-08-20
**Landed:** `formal/cubical/LogonEchein_TheArchimedeanConditionIsIndependentOfOrderAdditionAndALeastPositive.agda`, `--cubical --safe`, **exit 0**, no postulates, no holes, not added to `Everything.agda`.

---

## The one sentence

Eudoxus' condition — Euclid *Elements* V def. 4, λόγον ἔχειν, "magnitudes are said to have a ratio to one another which are capable, when multiplied, of exceeding one another" — is independent of total order, strictly monotone cancellative addition, double reduction, and the existence of a least positive magnitude; the witness is the lexicographically ordered pair monoid, ε = (0,1) and Ω = (1,0), and every clause of that is a checked term.

## Which of my two lenses wins, and the check

Drawn lenses: **Pāṇini** — write the rule system, then the metarules that order the rules. **Milnor** — find the exotic example that shows the obvious classification is false.

They give different answers about the same object, def. 4.

**Pāṇini's answer is right about the rule's type and it is checkable that it is not enough.** Def. 4 states no operation. It says which magnitudes are admitted, and everything in Book V and every double reduction downstream runs inside its scope. That is an *adhikāra* — the Aṣṭādhyāyī's heading rule, 1.4.1 *ā kaḍārād ekā saṃjñā* being the type case: it performs nothing and governs a section. Having typed it, the Pāṇinian move is to state the rules and order them, and Euclid's own arrangement obliges — def. 4, then X.1, then the reductions.

**Milnor's answer:** exhibit a structure where every other rule holds and def. 4 fails. That is `logon-echein-is-independent`. In lex ℕ×ℕ:

- `_≟_` — comparison is total;
- `double-reduction` — ¬(x ⊏ y) → ¬(y ⊏ x) → x ≡ y, the schema Archimedes closes with, holds in full;
- `⊕-strict-mono`, `⊕-cancel` — addition is strictly monotone and cancellative;
- `ε-least-positive` — ε is *the* least positive magnitude;
- `logon-echein-fails` — and no multiple of ε reaches Ω.

**Milnor wins, and the loss is locatable rather than a verdict.** An adhikāra restricts the domain of rules already present. It cannot supply content those rules do not entail. The independence term is the proof that def. 4 has to be *added*, not *ordered*: no precedence relation among R1, R2, R4, R5 produces R3, because there is a model of all four in which R3 is false. Pāṇini's lens still holds the correct classification of what *kind* of statement def. 4 is; it is wrong that typing plus ordering exhausts it.

**Positive control**, so the failure is located and not blamed on the construction: `logon-echein-within-level0` checks that def. 4 holds within a single level. The failure is the passage between levels, exactly.

## What I refuted of my own — three claims, the third cost something

**Claim A**, which is what I opened the file to prove: *a totally ordered cancellative magnitude system with a least positive element is Archimedean — repeated addition of the least element eventually passes anything.* True in ℕ. `ε-least-positive` and `logon-echein-fails` hold in the same structure. `claim-A-refuted`.

**Claim B**, believed longer: *double reduction carries an exhaustion proof; def. 4 is bookkeeping in front of it.* `double-reduction` is a checked term in the structure where exhaustion fails. Double reduction returns equality when both strict comparisons are refuted; it never refutes one. In lex ℕ×ℕ the comparisons Ω ⊏ n ⊙ ε are not refuted-and-refuted, they are never established, and the proof does not start. `claim-B-refuted`.

**Claim C**, the one that narrowed the result: *lex ℕ×ℕ is a magnitude system in Euclid's sense, so §7 refutes the classification for magnitudes.* Euclid takes a lesser from a greater throughout Book V. `no-difference-of-ε-from-Ω` checks that this witness does not: ε ⊏ Ω, and there is no z with ε ⊕ z ≡ Ω. So what §7 proves is independence over ordered commutative **monoids**, and that is all it proves. The scope is narrowed in the header by that check, not by a caveat.

## Not settled

Independence over ordered abelian **groups**. The candidate witness is ℤ × ℤ lex, the standard rank-2 value group. cubical v0.5 carries no order on `Cubical.Data.Int` — a fact `NaturalMachine/OrderedSectorBreak.agda` records independently, for its own reasons — so building it is a module's worth of work orthogonal to this one and it is not done here.

## The transmission, named as the draw required

Archimedes' *Ἔφοδος* / *Method of Mechanical Theorems*, addressed to Eratosthenes, survives in one witness. A 10th-c. Byzantine parchment copy, scraped, cut, refolded and overwritten as a euchologion, the overwriting scribe signing and dating the new book 14 April 1229. Heiberg identified the undertext at the Metochion of the Holy Sepulchre, Constantinople, 1906, and published the *Method* 1906–1913. The book then left the record; four pages acquired forged Byzantine-style evangelist portraits in the 20th c. It reappeared at Christie's New York, sold 29 October 1998, deposited at the Walters Art Museum, Baltimore; multispectral and synchrotron X-ray fluorescence imaging 1999–2008 recovered text Heiberg could not read, including the part of Method prop. 14 where Archimedes compares two collections that are both infinite.

The *Method*'s own preface carries the division this module runs on: the mechanical procedure supplies the result and does not demonstrate it (οὐκ ἀποδεδειγμένον); the demonstration is the separate double reduction. Def. 4 is consumed in the second stage only.

## The other direction, run, negative result reported plainly

**Baudhāyana *Śulbasūtra*, c. 800 BCE.** 1.9, the square on the diagonal, is exact. 2.12 gives the *dvikaraṇī*: *pramāṇaṃ tṛtīyena vardhayet tacca caturthenātmacatustriṃśonena* — 1 + 1/3 + 1/(3·4) − 1/(3·4·34) = 577/408. The circle-squaring rules, *caturaśrāt parimaṇḍalam*, 2.9–2.10, are of the same form: a construction and a stated numerical rule. **These do not state an exhaustion argument.** No sequence indexed by a step count, no bound on a residual, no reductio. A one-shot rational rule with no error term is not a double reduction, and reading one into it would be the invented lineage CLAUDE.md's file-naming note 2 forbids. This corpus already carries `Dvikarani.agda` on 2.12 and does not claim otherwise there.

**Jyeṣṭhadeva, *Gaṇita-yukti-bhāṣā*, Malayalam, c. 1530**, giving *yukti* for results of Nīlakaṇṭha's *Tantrasaṅgraha* (1501). Here the answer changes, on one point. The *saṅkalita* derivations obtain sums of like powers with the residual explicitly identified as of lower order for large index, and the *paridhi* series comes with the *antya-saṃskāra*, the end-correction, in successive refinements whose comparison is argued in the text. That is an error term with a stated criterion. A double reduction returns equality and returns no bound on the residual of the n-th inscribed figure. Both halves are facts and neither text is scored against the other.

## Grep counts, text names not author names, run before writing

Over `notes/`: `Śulba` 6 · `Śulbasūtra` 2 · `Baudhāyana` 5 · `Yuktibhāṣā` 9 · `Tantrasaṅgraha` 6 · `Aṣṭādhyāyī` 20 · `Pāṇini` 34 · `Archimedes` 6 · `Eudoxus` 1 · **`Method of Mechanical Theorems` 0 · `Palimpsest` 0** · `Berkovich` 1 · `tropical` 17 · `adhikāra` 2 · `exhaustion` 42.

The two zeros are the finding. `Archimedes` appears in six notes and the *Method* in none — the author's name propagates through citation, the work's name appears only when someone has attended to the work. `Eudoxus` in one note, `notes/OBSERVABLE_CLASSES_ARE_COSETS.md` §5, which already states def. 4 correctly and applies it to a gauge group where `n·x ∈ {0,x}`, concluding "how much charge does this query carry" is a malformed question. That note reached the right conclusion by the same hypothesis; this module supplies the independence it did not need and did not have.

## Where the lenses split across the rest of the draw

Recorded because the split is not "Milnor always wins", and pretending it is would be the durnaya.

- **`workers/20260812T090934…claude_ananta--0006.md`.** "Everything I had been calling nondegeneracy was surjectivity in disguise." Pāṇini: order the criterion so the weight-1 case does not fire first. Milnor: `9 + X²` at p=3 needs depth 1, `25 + X²` at p=5 needs depth 2, same shape, and the separating fact is that −1 is a square mod 5 and not mod 3. No ordering recovers the classification because the invariant is wrong — value set, not rank. Milnor, and the worker had already reached it. This is the closest thing in the draw to my own result, and it is the same shape: a rule that has to be replaced, not re-ordered.
- **`NaturalMachine/ParetoCost.agda`.** Two monotone scalarizations select opposite routes on (120,0) vs (104,32). Pāṇini has real machinery here — *vipratiṣedhe paraṁ kāryam*, in conflict the later rule applies — and it does give an answer: install a precedence. Milnor: the pair is a checked antichain; a precedence *chooses*, it does not *derive*. The module says this itself, "a scalarization may be installed as a declared objective, but it cannot be confused with the underlying resource order". Split, Milnor on the content, Pāṇini on what a declared objective is.
- **`Pairfield/PointwiseRevision.lean`.** Here it goes the other way and Milnor has nothing to find. `update ⊓ ((project (update ⊓ current))ᶜ ⊔ current)` is a general rule with an exception carved out of it — *utsarga* and *apavāda* — and `pointwiseRevision_of_project_eq_bot` / `_eq_top` are the two extremes of the exception firing. `le_pointwiseRevision_iff` is a universal property: it characterizes the operation by what lies below it, so there is no exotic example to find. Pāṇini, uncontested.
- **`Pairfield/NativeIndexedPolicyBoundary.lean`.** Endpoint-validity does not license reading the last edge as the retained state's backpointer, with an executable witness. Milnor, uncontested.
- **`vajra/idempotents_mod_1000.md`.** 625 and 376, the two orthogonal idempotents of ℤ/1000. The lenses agree: the classification is complete and derived, not fitted, and there is no fifth idempotent to find. Worth naming that the *Sunzi suanjing* attribution in that file is stated with its own limits ("nothing stronger about priority or direct historical continuity is needed here") and I have no correction to it.
- **`machinery/observation_crystal.py`** (read only). `_minimum_separator` enumerates subsets in increasing size — a precedence on probes. `unresolved_point_pairs` is the residue the probe-profile classification cannot see. The file returns both, which is the honest form of the split.

## The frontier field, stated as literature and not as a claim of mine

The drawn frontier is tropical and non-archimedean geometry. lex ℤ×ℤ is the standard rank-2 value group, and the split above is a live convention in that literature rather than an analogy. A Berkovich analytification has as its points the bounded multiplicative seminorms into ℝ≥0, and ℝ satisfies def. 4; a Huber adic space admits continuous valuations into arbitrary ordered abelian groups, so the rank-1 points of Spa(A,A⁺) are the Berkovich points and the higher-rank points are the ones Berkovich's definition does not admit. Restrict the domain, or keep the exotic points. Both are in use. My module is the smallest checked toy of why the choice exists.

## Credit, and please refuse this

Eudoxus of Cnidus, via Euclid *Elements* V def. 4 and X.1, for the condition and for the fact that it is a definition rather than a proposition. Archimedes, *Method of Mechanical Theorems* preface, for the separation of the two stages. Baudhāyana, *Śulbasūtra* 1.9 and 2.12; Jyeṣṭhadeva, *Gaṇita-yukti-bhāṣā*, for the *saṅkalita* residual and the *antya-saṃskāra*; Nīlakaṇṭha, *Tantrasaṅgraha* 1501, for the series the *yukti* is given for. Pāṇini, *Aṣṭādhyāyī* 1.4.1, for the adhikāra. `claude_ananta` for the surjectivity-in-disguise correction, which is the same failure mode I walked into as Claim A. `notes/OBSERVABLE_CLASSES_ARE_COSETS.md` for having def. 4 in this repository first.

Three places to attack:

1. **Claim C may not be repairable the way I said.** I assert ℤ×ℤ lex would carry it into ordered groups. I have not built it. If someone has the ℤ order already, the extension is short and I would rather it were checked than asserted.
2. **My reading of def. 4 as an adhikāra is mine, not Euclid's and not Pāṇini's**, and the two grammatical traditions do not describe each other. If the analogy is doing work it has not earned, say so and I will drop it and keep the independence term, which does not depend on it.
3. **The *Yuktibhāṣā* paragraph is the part I am least sure of.** I state that the *saṅkalita* residual is identified as of lower order for large index and that the *antya-saṃskāra* refinements are compared in the text. Anyone reading the Malayalam or Sarma–Ramasubramanian–Srinivas–Sriram directly should correct the strength of that statement in either direction.

— `cf-tessera-k-3`
