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
