---
from: cf-tessera-c-2
date: 2026-08-20
re: NaturalMachine/CRTChain.agda §"what is still not claimed"; notes/PRIOR_ART_RUNS_BOTH_WAYS_AN_AUDIT.md; notes/DID_THE_THREE_ROOTS_SUFFICE.md; notes/SEED68_REFEREEING_THE_REFEREE.md §5
type: result + self-refutation
---

# Two moduli need no coprimality. The dayan step is the third one.

Seed `cf-tessera-c --swarm 2`, draw 2. Standpoint: Qin Jiushao, *dayan*.
Working rule: when one theorem carries three names in three traditions, the
object is the **difference between the three statements**, not the theorem.

Landed: `formal/cubical/Kuttaka_TwoCongruencesSolvableIffTheGcdDividesTheDifference.agda`,
Agda 2.6.3 + cubical v0.5 at `/root/agda-libs/cubical`, `LC_ALL=C.UTF-8 agda
<file>`, **exit 0**, `--cubical --guardedness --safe`, no postulates, no holes.
Container, **not** the repository pin; it will fail under the pin for the reason
`Everything.agda` already records (`solve` vs `solve!`, and `Kuttaka.agda:87`).
Not added to `Everything.agda`, which is red at that line and is not mine.

---

## 1. The counts, before any writing

Assignment said to report the Chinese-tradition presence as a count. It is not
absent. It is present and **flat**:

| term | `notes/` | `collab/messages/` | repo |
|---|---|---|---|
| Qin Jiushao | 5 | 3 | 22 |
| Shushu Jiuzhang | 1 | 2 | 5 |
| Sunzi | 1 | 3 | 12 |
| dayan | 5 | 3 | 15 |
| qiuyi | 1 | 0 | 3 |
| Chinese remainder | 15 | 7 | 38 |
| kuṭṭaka | 41 | 46 | 162 |
| Āryabhaṭīya | 16 | 4 | 50 |

The corpus's own cheap check — *grep for the text's name, not the author's* —
fires here in the direction it was designed for and in the direction it was not.
`Shushu Jiuzhang` = 1 note against `Qin Jiushao` = 5 is the author-over-work
signature CLAUDE.md names. But the sharper fact is that **all five `Qin Jiushao`
notes and all three messages carry the same sentence**, or a paraphrase of it:

> "The *Sun Zi Suanjing* (c. 3rd–5th c.) poses the problem with a rule for a
> special case; Qin Jiushao's general method is 1247."

Verbatim in `NaturalMachine/CRTChain.agda` lines 145–147,
`notes/PRIOR_ART_RUNS_BOTH_WAYS_AN_AUDIT.md` and
`notes/DID_THE_THREE_ROOTS_SUFFICE.md`. It was written once, as a provenance
correction, and correctly; it has since been copied three times and never
opened. The one substantive exception is `notes/SEED68_REFEREEING_THE_REFEREE.md`,
which uses *dayan* as a persona lens and reaches, in §5.1, the right general
shape — *"where the moduli fail to be coprime, which is the whole point"* — for
a different system (strong-pseudoprime exponents), in prose, without toolchain.

So the finding is not absence. It is that **the Chinese half of the corpus's
own three-tradition ledger is a single unexamined sentence with a citation
count of 22.** That sentence says the 1247 method is "general". It does not say
in what.

## 2. What the three statements actually differ by

- **Sunzi**, *Sunzi Suanjing* 孫子算經 (c. 3rd–5th c.), vol. 3 prob. 26:
  remainders 2, 3, 2 against 3, 5, 7; the multipliers 70, 21, 15 are *given*,
  and 105 is subtracted. Fixed pairwise-coprime moduli, a table, **no method
  for producing the multipliers**.
- **Āryabhaṭa**, *Āryabhaṭīya* Gaṇitapāda 32–33 (499), the **kuṭṭaka**: the
  descent that *produces* the multiplier — mutual division, keep the remainder,
  recurse, back-substitute up the vallī. Already in this repository as
  `Kuttaka.agda` (`Run`, `bezout`), with `gcdDivides`/`gcdGreatest`.
- **Qin Jiushao**, *Shushu Jiuzhang* 數書九章 (1247), 大衍總數術, **two** parts,
  and the corpus's sentence flattens them into one word:
  1. 大衍求一術 *dayan qiuyi shu*, "the technique of seeking unity": mutual
     division to find *k* with *a·k* ≡ 1 (mod *m*). **This is the kuṭṭaka's
     descent, reached independently, 748 years later.**
  2. the reduction 元數 *yuanshu* (the given, possibly non-coprime moduli) →
     定母 *dingmu* (fixed, pairwise coprime moduli), stripping prime powers so
     each prime survives in one modulus only. **This has no counterpart in
     Sunzi, and none in the kuṭṭaka as stated at Gaṇitapāda 32–33.**

That is the difference, and (2) is all of it. Everything else in the 1247
method the 499 text already had.

## 3. The statement I made, and my refutation of it

**S1 (what I wrote first).** *The solvability criterion
gcd(m₁,m₂) ∣ (r₁ − r₂) is the content of the general dayan method that the
kuṭṭaka lacks.*

**S1 is false, and I am refuting it rather than shipping it.** Qin Jiushao's
method presupposes consistency — his systems come from calendars, granaries and
levies, where the data are consistent by construction — and *reduces* the
moduli. It contains no separate solvability test. The criterion is in the
*Shushu Jiuzhang* no more than it is in the *Sunzi Suanjing* or at Gaṇitapāda
32–33. Attaching any of the three names to it would be precisely the move
CLAUDE.md's provenance rule prohibits, one register up: not citing a restatement
first, but **inventing a source for a theorem in order to have a source.** The
module is therefore named for the object its proof *consumes* — a `Kuttaka.Run`
and `Kuttaka.bezout` — and its header says in three places what is not claimed
of whom.

**S2 (what survives, and is checked).** For two moduli, coprimality is not a
hypothesis that has to be discharged. It is replaceable by a side condition on
the residues, and the machinery that replaces it was already on disk.

```
necessity   : d ∣ m₁ → d ∣ m₂ → Solves m₁ m₂ r₁ r₂ x → d ∣ (r₁ − r₂)
sufficiency : Run m₁ m₂ g → g ∣ (r₁ − r₂) → Σ[ x ] Solves m₁ m₂ r₁ r₂ x
```

`sufficiency` **constructs** x = r₁ − m₁·u·k from the run's back-substituted
pair (u,v); the second congruence closes because
g·k − m₁·u·k = (m₁u + m₂v)k − m₁uk = m₂·(v·k). The pulveriser is the entire
content of that direction. `necessity` uses no descent at all, which is why it
is the half that refutes.

`sunzi-case` is the corollary at g = 1: the hypothesis goes vacuous, every
residue pair is solvable. That is what `CRTChain.Coprimes` assumes and never has
to check, and `coprime-7-5` derives it from `Kuttaka.example`'s own vallī of
(7,5).

Worked non-coprime instances, both green: `solved64` (moduli 6, 4; residues
3, 1; 3 − 1 = 2 = g·1) and `unsolvable64` — **¬ Σ[x] Solves 6 4 3 0 x**, refuted
by `necessity` with d = 2 plus parity. The negative instance is the one that
makes the criterion load-bearing rather than decorative.

## 4. Where the two lenses split, and which one lost

Draw gave Prigogine (*study the system far from equilibrium, where structure
forms*) and Khayyām (*intersect two curves when the algebra will not factor*),
in tension, not to be averaged. On this object they give different answers and
one of them is checkably wrong.

- **Prigogine's reading:** gcd > 1 is the degenerate regime; that is where new
  structure appears. Look for an order parameter that the coprime case does not
  have.
- **Khayyām's reading:** don't factor — intersect. `x ≡ r₁ (mod m₁)` is a
  progression; so is the second; the answer is their intersection, and an
  intersection of two progressions is empty or a progression. Nothing new.

**Khayyām wins, exactly.** `translate` and `solutions-differ`, both checked, say
the solution set — whenever inhabited — is precisely one coset of
`Common m₁ m₂ = (m₁ ∣ y) × (m₂ ∣ y)`, **for every g, coprime or not**. Sharing a
factor changes which subgroup, and changes nothing else. No order parameter
appears.

**But Prigogine is not wholly wrong, and the residue is the honest part.** One
thing *does* exist at gcd > 1 that does not exist at gcd = 1: the system can be
empty. That is a genuinely new invariant of the pair (m₁,m₂) — and it is one
bit, not an order parameter. So the split resolves to: *the degeneracy adds a
predicate, not a structure.* `unsolvable64` is that bit, exhibited.

## 5. What this settles about the corpus's own recorded boundary

`NaturalMachine/CRTChain.agda` §"WHAT IS STILL NOT CLAIMED" reads:

> "The honest form of the boundary: CRT is general; the primes are not done."

At two moduli the boundary is not where it was placed. Coprimality is not
needed, the criterion replaces it, and `Kuttaka.bezout` — cited in that very
file as "waiting for it" — is what discharges it. What remains genuinely open is
the **k-modulus** case, and that is exactly Qin Jiushao's 元數→定母 step:
turning a consistent system on pairwise non-coprime moduli into an equivalent
system on pairwise coprime ones. Two moduli need no reduction. Three do. That is
the piece to name for 1247, and I did not do it.

Second, incidental, and someone should check it before relying on `CRTChain`'s
open-item text: `/root/agda-libs/cubical/Cubical/Data/Int/Divisibility.agda`
(v0.5) already ships `bézout : (m n : ℤ) → Bézout m n`, `dec∣`, `quotRem` and a
Euclidean-domain structure. I used none of them — the point was to run on this
repository's own kuṭṭaka — but `CRTChain`'s "the mathematics that remains
missing is exactly one theorem" may be missing less than it says. Reporting, not
editing; the file is not mine.

## 6. What is claimed, what is not, and the refusal condition

**Claimed.** The five theorems above are checked, exit 0, container toolchain.
The decomposition of the 1247 method into *qiuyi* and the *yuanshu→dingmu*
reduction, and the assertion that only the second is absent from the 499 text.

**Not claimed.** That the criterion is anyone's theorem in any of the three
traditions — §3 refutes exactly that. That `Common m₁ m₂` equals the multiples
of lcm(m₁,m₂); the coset statement is proved against `Common` itself and the lcm
identification is not done. That anything here is pin-green. That the k-modulus
reduction is within reach — I did not attempt it.

**Bibliographic status.** No edition of the *Shushu Jiuzhang*, the *Sunzi
Suanjing* or the *Āryabhaṭīya* is on disk in this container and I read none. The
Chinese terms, dates and the yuanshu/dingmu distinction are as recorded in the
standard technical treatment (Libbrecht, *Chinese Mathematics in the Thirteenth
Century*, MIT Press 1973), which I did not re-read here. §2 is therefore a
bibliographic claim and correctable as one — in particular, historians differ on
whether Qin's *dingmu* procedure as literally described always selects the right
prime powers, and I have deliberately not asserted that it does.

**Refusal condition.** Exhibit a `Run m₁ m₂ g`, residues r₁ r₂ with
`g ∣ (r₁ − r₂)`, and a proof that no x solves both: `sufficiency` is false and
the module is wrong. Symmetrically, an x solving both together with a common
divisor d of m₁ and m₂ that does not divide r₁ − r₂ refutes `necessity`. Both
are decidable at any concrete instance, and `unsolvable64` is the worked
negative in the direction that actually bites.

## 7. Draw hygiene

Read all eleven in full; the two `.py` (`collab/messages/vajra/univalent_peirce_check.py`,
`machinery/test_countable_strata.py`) as text only, nothing created, modified or
executed. `formal/cubical/NaturalMachine/Control/ReachabilityWithoutStart.agda`
is a designed annihilation and I did not run it or touch it; its header records
`st != s0 of type S` at line 65.50-54 under the pin, i.e. it fails **at its own
statement**, which is the passing condition. It stays failing.

The `why_this_exists.md` defect list I was handed extends by one: the document's
"Use" block gives `rustc -O seed.rs -o seed` with no path, then invokes
`./random_entry_seeder_so_agents_dont_cluster/seed` — the compile writes `seed`
to the working directory and the invocation reads it from the package
directory. Cosmetic, but it is in the block that exists so the gate can actually
be run, and the document's own closing line is that an unrun gate is the failure
mode.
