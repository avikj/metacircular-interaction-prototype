# असिद्धत्व — the complexity barriers are the fibre of generality, and blindness is what buys a proof its finiteness

**Grade.** A reading, MINE throughout, offered as a conjecture with its fence.
Nothing checked, nothing run: `toolchain=absent`, `modules=0`. No `WebFetch`
attempted; outside claims are at recall grade with a name and date.
**Absence of a located source is not evidence of novelty** —
`OPEN_PROBLEMS_WE_TOUCH.md` §0 binds here.

**Why this note exists.** `SamagraDarsana_…md` lists complexity in its
one-law-nine-scripts table with the entry *"not in this corpus; the three
barriers are this statement three times,"* and then poses a question and marks it
unasked: **whether the barriers in complexity are constitutive in Pāṇini's sense
— the price of the finiteness a proof would exploit.** This is an attempt at it.

**On the name.** असिद्धत्व · *asiddhatva*, Pāṇini, *Aṣṭādhyāyī* 8.2.1 and the
*tripādī* (8.2–8.4), c. 500 BCE: the rules of that section are treated as **not
having applied** with respect to each other and to what precedes — a
stratification in which one stratum cannot see another's output. Nothing
mathematical is claimed of Pāṇini beyond the metarule as stated.

---

## 1 · The three barriers, hypotheses stripped

**Relativization** (Baker–Gill–Solovay 1975). There are oracles `A` with
`P^A = NP^A` and `B` with `P^B ≠ NP^B`, so any technique whose conclusions are
invariant under the oracle cannot decide the question.

> Read as an observation class: the class is *techniques that treat the machine
> as a black box*, the two oracle worlds are two objects producing **identical
> transcripts** under every query the class admits, and therefore no decision
> procedure separates them. That is `NaturalMachine/ParitySeparator.agda`'s shape
> exactly — `obs-agree` as an equality, then `no-decision` by `cong`, *"there is
> nothing to separate."* **Baker–Gill–Solovay is that theorem in another field**,
> and its 1975 proof is the same move: exhibit the pair, not bound the difficulty.

**Natural proofs** (Razborov–Rudich 1994). A property that is constructive and
large, if it gave circuit lower bounds, would break pseudorandom generators.

> Read in this vocabulary it is not a blindness theorem at all — it is a
> **conservation law on separating power.** A natural property *is* a separating
> query, and the theorem says a separator of that form cannot be obtained without
> destroying an inseparability we are relying on elsewhere. Separating power is
> not created; it is moved. And the corpus's own criterion says where it lives:
> **charge is in what a method reads**, and a constructive-and-large property
> reads the truth table, which is precisely what a distinguisher does.

**Algebrization** (Aaronson–Wigderson 2008) extends the first to algebraic
oracle access, and the field's standard conclusion from all three — that a
technique must use more of the machine's specific structure — is CLASSICAL and is
not what this note claims.

## 2 · The claim

> **Every proof technique is an observation class over the objects it reasons
> about, and its generality is exactly the size of its fibres.**

A proof is a **finite** object asserting something about an **infinite** class.
Finiteness forces it to factor through what the members share — a quotient. The
quotient has a fibre. **The barrier is that fibre.** A technique with no fibres
sees every machine individually, and that is a case analysis, not a proof.

> **So the barriers are not obstacles standing between us and a proof. They are
> the shadow cast by proof being finite.** MINE, and stated as a conjecture: I
> have no formalization of "technique as observation map," and without one this
> is a reading and not a theorem. What would make it one is a statement of
> `QuotientFiberLaw` whose query family is a class of proof techniques, with the
> oracle pair as the exhibited `obs-agree` — and that is a real formalization
> question, not a rhetorical one.

## 3 · Which answers the flagged question in the affirmative, with a price

Pāṇini's *asiddhatva* is the constructive case and the corpus already has it
checked: `Asiddhatva.noStrictOrder` (CHECKED-ELSEWHERE) proves the k→g→k cycle
admits **no strict order at all**, so RPO, KBO, polynomial and matrix
interpretations and Knuth–Bendix completion all fail on it — **and Pāṇini
terminates the system anyway, by making one stratum unable to see another.**

> **Blindness is a resource that buys termination.** And §2 says generality buys
> finiteness by the same purchase. Same trade, opposite affect: the grammarian
> **installs** the blindness deliberately and gets a terminating system; the
> complexity theorist **inherits** it as the price of a general technique and
> calls it a barrier.
>
> **The constitutive answer, then: yes — but the barrier is not the price of
> proving P ≠ NP. It is the price of proving anything about all machines at
> once.** You do not get past it with a cleverer general technique, because
> generality is the fibre. You get past it by reading what the class does not,
> which means a technique that is **less** general — and that is exactly what the
> field concluded from the other direction, without the reason.

## 4 · What this buys, if it holds

`ChargeCriterion.agda` is an **iff** with the separator constructed, and its
header states the transferable asymmetry: **the criterion is on the query set,
not on the post-processing.** The corresponding question here is not "is P ≠ NP
provable" but the decidable-shaped one:

> **does a given technique class contain a query that separates the two oracle
> worlds?**

Which is a membership question about what a technique **reads**, of the same
shape the corpus decides for parity at the smallest nontrivial scale. Whether it
is answerable here I do not know and do not claim; naming it as that shape is the
whole of what this note does.

## 5 · Not claimed

- Nothing is proved. §2 is a conjecture and says so; §3's answer is conditional
  on §2.
- The standard conclusion of the barriers literature — that non-relativizing,
  non-natural, non-algebrizing techniques are needed — is **not** claimed as
  novel. It is CLASSICAL and predates this by decades. What is offered is the
  identification of the barriers with the fibre of a proof technique, the reading
  of Razborov–Rudich as a conservation law on separating power, and the
  asiddhatva answer to the constitutive question.
- No claim that this makes any complexity question easier. It reclassifies where
  the difficulty lives; a reclassification is not a lower bound.
- The three barriers are **not** claimed to be one theorem among themselves. §1
  reads relativization and algebrization as blindness and Razborov–Rudich as
  conservation, and those are different statements.

---

*claude (Opus lineage), on `main`, 2026-08-22, answering a question
`SamagraDarsana` flagged as unposed.*
