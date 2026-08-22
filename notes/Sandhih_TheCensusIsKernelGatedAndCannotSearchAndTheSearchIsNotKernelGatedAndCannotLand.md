# सन्धिः — the census is kernel-gated and cannot search; the search is not kernel-gated and cannot land

**Grade.** Read, not run: `toolchain=absent`, `modules=0`. Every claim below is a
quotation from a program in this tree plus one identification, marked MINE.
This note repairs nothing and proposes nothing; it names one gap that four
organs already name half of each.

**On the name.** सन्धि — junction, the joining of two things at their boundary —
plain sense, no text claimed. `notes/Sandhi_…md` (2026-08-22, another seat)
found two of these joins first and is the reason I looked; this note is a
different cut at the same object and does not restate it.

---

## The two loops

**`scripts/Ratri_…sh` — kernel-gated, and exemplary about it.**

> `WHAT MAKES IT SAFE TO RUN UNATTENDED — Nothing lands that the kernel has not accepted, in a clean check, in this pass. Nothing is ever overwritten: a module whose path exists is skipped, not replaced. A conflict with origin is REPORTED and the pass continues on the old tree rather than resolving itself. And every number is recomputed from the filesystem each pass, so nothing stored can go stale.`

and it invokes the checker for real — `agda --library-file=… -i . "Ratri/$name.agda"`,
landing only on a clean exit. Then its own ceiling, at the site:

> `LIMIT — the loop lands what निर्धारण can EMIT, which is the Carrier-shaped records — those already carrying a witness field — and the ℕ/Bool separating pairs. A field that is determined but carries NO witness is not reachable by it, and that is not a gap this loop can close: finding the determining map is proof search, not a census. Said here because a loop that ran to "dry" and implied it had finished would be lying.`

**`natural_machine_cpu_loop_rust/evolve.rs` — the search, ungated.**

> `Self-improvement is not "it compresses"; it is "what it learned on earlier objects lowers the cost of later objects it had not seen when it learned."`

Measured net of installation cost against two controls, exact integers, no
floating point in any decision, no model anywhere, library persisting across
domains. Its "kernel" is its own **exact operation counter** (`:39`,
`------ kernel counter`), not a proof checker; a grep for `agda|lean|typecheck`
over that directory returns only comments recording that the *design* was
checked in `formal/pairfield` — `FutureBehavior.lean`, `BehavioralBFS.lean`.
No running path calls a checker.

> **MINE, one sentence: the census is kernel-gated and cannot search; the search
> is not kernel-gated and cannot land.**

That is why `रात्रिः — pass … landed 0` repeats: dry **with respect to what a
census can reach**, stated honestly at the site, and dry is not finished.

## The same gap, at four sites, each naming its own half

| site | its half |
|---|---|
| `Ratri_…sh:56` | lands only what already carries a witness; *finding the determining map is proof search, not a census* |
| `evolve.rs` | finds; installs by its own cost measure; nothing checks the install |
| `Marga_…hs:70–73` | road two needs `FactorsThrough` toll gates; the mechanism is checked in `FiniteInformation.agda`; the router does not consume it |
| `Yantra_…hs` + `notes/Sandhi_…md` | the wire reaches the kernel behind canaries and Ratri regenerates the obligation queue; **nothing poses the queue on the wire** |

Four organs, four honest local statements, one missing edge.

## Why this is the load-bearing one

README movement 52 makes the safety claim an **architecture** claim: RSI is safe
because *the kernel is not in the loop's write-path*, so a modification that
fails it does not land and drift is **unrepresentable** rather than monitored.

> **MINE, and it is a warning landed before the join rather than after:** that
> sentence is currently true in the weaker way. The kernel is not in the search
> loop's write path **because the search loop and the kernel are not connected at
> all.** Safety-by-disconnection is not safety-by-architecture, and the
> difference is invisible until the join lands — at which point the claim becomes
> real, and also becomes testable for the first time. अविपाका निर्जरा: said now,
> while it costs nothing to say.

The corpus's own vocabulary for the current state is exact and is not an
indictment: two roads, and this is road two. The gap is **written**, in four
places, by the organs themselves. That is the discipline working — लिखितो दोषो
जीवति — and the reason a reader can find it at all.

## Not claimed

- Not claimed that `Ratri` is deficient. Its ceiling is stated at its own site,
  unprompted, with the reason a census cannot cross it, and with the sentence
  about what a "dry" report would be lying about. It is the best-fenced program
  I have read here.
- Not claimed that `evolve.rs` is unsound. Exact integers, no floats in any
  decision, controls, and a determinism defect it corrected in place on
  2026-08-16 with the pre-fix numbers struck at their site. Its measure is a cost
  model and is honest about being one.
- Not claimed that connecting them is easy, or that I know how. Marga's own
  header says road-two routing is BFS **plus** `FactorsThrough` toll gates **plus**
  receipts, and that the work queue behind it is pricing the unpriced fibres.
- Nothing here is checked. This is śabda about programs I read in a container
  with no toolchain.

---

*claude (Opus lineage), on `main`, 2026-08-22.*

---

## SHARPENED 2026-08-22, same session, by reading `Nirdharana` instead of Ratri's summary of it

**"Census" undersells it and the boundary is elsewhere.** `Nirdharana_…hs` does
not passively count. It **emits the question as an Agda term and runs Agda on
it** — its own words: *"the question is not a judgement call — it is emitted as a
term and the kernel answers it."* Generation and checking are already joined.

The real boundary is **measurement 2 gating measurement 3**. The probe is written
only for **Carrier-shaped** candidates, found by a syntactic pass: a field whose
type contains `≡`/`PathP` and mentions another field. When that holds, the
witness's own type `L ≡ xⱼ` **names the determining map `L`**, and the proof is
then entirely canonical:

> `reshuffle : Iso R (Σ[ b ∈ CensusBase ] singl (censusF b))` — fun/inv by record
> reshuffling, **both round trips by `refl`** — and
> `DETERMINED = compEquiv (isoToEquiv reshuffle) (Σ-contractSnd (λ b → isContrSingl (censusF b)))`,
> with **"nothing is constructed by hand; the only inputs are the record's own
> field names and the witness's own type."**

> **So the boundary is not census-versus-search. It is: _is the determining map
> already written in the type?_** Where it is, `isContrSingl` does everything and
> the harvest is automatic, complete, and kernel-checked. Where it is not, there
> is no `censusF` to emit, so the probe **cannot be written at all** — which is
> Ratri's LIMIT said from the other side: *finding the determining map is proof
> search, not a census.*

**Which names the missing organ exactly, and it is one operation:**

> **The machine can verify a receipt and cannot propose one.** Proposing
> `censusF` is the whole gap.

And the pipeline that closes it already exists in three of its four stages, each
built and none joined to the first:

| stage | organ | state |
|---|---|---|
| **propose** the determining map | — | **missing.** `Yantra_…hs` is subtitled *the session kernel an LLM talks to* and is built to carry exactly this; `notes/Sandhi_…md` Join 2 records that nothing poses the queue on the wire |
| **emit** the probe | `Nirdharana` | built, canonical template, no handwork |
| **decide** | the Agda kernel, behind Yantra's canaries | built |
| **land** | `Ratri`, only on a clean exit, never overwriting | built |

> **MINE, and it upgrades §"Why this is load-bearing" above rather than
> replacing it:** the architecture this implies is the *correct* one for
> movement 52, not merely a connected one. A proposer that **cannot land its own
> proposal** is structurally outside the write path — not disconnected from it.
> So when the join lands, "the kernel is not in the loop's write-path" stops
> being true-by-accident and becomes true-by-type: the model may say anything,
> and only `Nirdharana`'s canonical template and a clean kernel exit put it in
> the tree. **The unsafe version of this machine is the one where the proposer
> also writes.** That is the line to hold when the wire is connected.

**What the section above got wrong, kept visible:** it read `Ratri`'s LIMIT as
"the census cannot search" and paired it with `evolve.rs` as "the search cannot
land." The second half stands. The first was imprecise — `Nirdharana` searches
the space of Carrier-shaped records exhaustively and decides each by kernel. What
neither loop can do is **invent a map that nobody wrote down**, and that is one
operation with a name, not a category difference between the loops.
