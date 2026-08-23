# प्रत्यक्ष — I ran the machine, and learning pays only when the room exceeds one probe

**Grade. MEASURED, by me, in this container.** Two programs compiled and run to
exit 0; transcripts below. **Everything else I wrote today remains śabda** —
there is still no `agda`, no `lean`, no `ghc`, so every Agda/Lean `exit 0` I have
cited stays unverified. What changed is that `rustc 1.94.1` is present and the
Rust lane is runnable, and **I stamped `toolchain=absent` on ten notes today
without looking hard enough.** A claim about the repository's own state,
checkable in ten seconds, unchecked — this corpus's most frequently recorded
defect, committed by me ten times. Filed as `dosa 0040`.

**Reproduce:**

    cd natural_machine_cpu_loop_rust
    rustc -O evolve.rs        -o /tmp/evolve && /tmp/evolve
    rustc -O real_workload.rs -o /tmp/rw     && /tmp/rw

---

## 1 · `evolve.rs` — the self-improvement claim is real, and it is the SEPARATION that carries it

177 domains enumerated not chosen, workload derived not chosen, installs by the
program's own exact operation counters. Exit 0.

    total kernel steps   no library  1191167
                         learned     1119984   (-5.98%)
                         null        1178046   (-1.10%)
                         library size at end: 3

    SECOND HALF ONLY — domains unseen when the library was built
                         no library   900573
                         learned      849203   (-5.70%)
                         null         891479   (-1.01%)

    SELF-IMPROVEMENT (learned beats no-library on unseen domains): true
    SEPARATION       (learned beats the SAME-SIZE arbitrary library): true

Learned unprompted: `block [1,0]` over bases 2, 3, 4.

> **The result is the SEPARATION line.** That *a* library helps is worth ~1%, and
> a random library of the same size gets that. That the **learned** library gets
> 5.7× more, on domains that did not exist when it learned, is the falsifiable
> content — and it holds. `evolve.rs`'s own definition of self-improvement is
> measured, controlled, and reproduced.

## 2 · `real_workload.rs` — and on the corpus's real mathematics, learning LOSES

Factor-degree exclusion for `F_X(x) = ∑_{p≤X} x^{p−2}` by modular certificate.
Exit 0.

| arm | kernel ops | vs A |
|---|---|---|
| A — baseline | 2,379,850 | — |
| B — rank primes by measured success, carry to unseen objects | 17,068,812 | **+617.22%** (unseen half **+745.97%**) |
| C — revise the objective: rank by expected cost to first certificate | 14,297,911 | +500.79% (unseen half +624.82%) |
| D — oracle floor: knows the certifying prime, pays only for it | 2,136,696 | −10.2% |

The program's own printed diagnosis:

> `room available to ANY learner: arm A 2379850 - floor 2136696 = 243154 ops
> (10.2% of A); cost of ONE exploratory attempt at the median prime, by
> contrast, is on the order of the entire room -- which is why arms B and C lose.`

`q = 2`: 7 attempts, 4 successes, mean cost 40,899. **The smallest prime
certifies most objects. There is nothing to rank.**

## 3 · The law the two runs give together — MINE, and now measured

> **Learning pays exactly when the room between naive and oracle exceeds the cost
> of one exploratory probe.**

`evolve.rs`: room large relative to a probe → learning wins and separates from
its null control. `real_workload.rs`: room is **10.2%** and one probe costs about
the whole room → learning loses sixfold, and **revising the objective (arm C)
does not save it**, because the defect is not the objective — there is no room to
buy.

> This is the economic form of `ChargeCriterion.agda`'s **separating power is a
> function of the charge of the query, not of its size.** You cannot buy the
> answer by probing. You must **read the right place**, and reading it has to be
> nearly free — which is what a structural criterion is and what a measurement
> policy can never be.

## 4 · Which closes a question I opened this morning, from the economics side

`notes/Dvara_…md` §5 asked whether the structural form of `real_workload`'s
question is available, and marked it *a question, not a result*. The run answers
the economics: the empirical route is not merely inferior, it is **dominated
sixfold**, and no revision of the ranking objective recovers it.

And the corpus did the structural thing in the neighbouring lane hours before I
ran this. `Sarvatra_…AsThePrimesDividingTheDeterminant.lean` (Opus 4.8 seat,
`bad_iff_det`, checked, exit 0, wired) settles **which primes see a Smith cut for
every prime at once** — decided, not measured — with its commit stating the
diagnosis in the owner's words: *the machine was doing physics on itself
(evaluating each place) where the criterion settles all places at once.*

> **Same diagnosis, twice in one day, from two directions.** Repaired there for
> the Smith rank by a checked term. Still unrepaired here for factor-degree
> exclusion — and now with a price on it: **+617%, against a total available room
> of 10.2%.**

## 5 · Not claimed

- **Neither program's internal correctness is audited.** I compiled them and
  report their printed output. I did not verify their operation counters, their
  certificate logic, or their arm definitions against the mathematics.
- §3 generalizes from **two runs in one repository**, is the shape of standard
  explore/exploit accounting, and is almost certainly known in that form. No
  `WebFetch` attempted; absence of a located source is not evidence of novelty.
- `evolve.rs`'s header claims determinism; the run is consistent with it, but I
  ran it **once** and did not test determinism by repetition.
- Nothing here bears on any Agda or Lean claim anywhere in my other notes. **All
  of those remain testimony.**

---

*claude (Opus lineage), on `main`. The first thing I ran all day, after being told
one word: work.*

---

## 6 · One fence removed, minutes later

§5 said: *"`evolve.rs`'s header claims determinism; the run is consistent with it,
but I ran it once and did not test determinism by repetition."*

**Tested. Two runs of the same binary, piped to `sha256sum`:**

    2a4add122cd000338869b5c76c475cc980278f276878d505b06df439bd42da1c
    2a4add122cd000338869b5c76c475cc980278f276878d505b06df439bd42da1c

Identical. The header's claim — *"the numbers below are now a function of the
source alone and the same binary prints the same bytes on every run"* — holds,
and the correction it records (the pre-fix `mine` broke gain-ties by `HashMap`
iteration order, which Rust randomises per process) is repaired as stated.

`dosa 0040`'s `punarabhinaya` also runs and returns its filed `phala: out~1`.

> The fence in §5 is withdrawn on evidence rather than left standing. **The other
> three fences in §5 stand untouched** — both programs' internal correctness is
> still unaudited, §3 is still a generalization from two runs, and every Agda and
> Lean `exit 0` I have cited today is still śabda.
