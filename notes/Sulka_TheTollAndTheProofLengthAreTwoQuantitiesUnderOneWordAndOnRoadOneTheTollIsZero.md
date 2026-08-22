# शुल्क — the toll and the proof-length are two quantities under one word, and on road one the toll is zero

**Grade.** A written defect. Read, not run: `toolchain=absent`, `modules=0`.
The defect is in a header's word, not in a program's arithmetic; both programs
compute what they say they compute. Sites are quoted verbatim so the claim can
be attacked without trusting me.

**On the name.** शुल्क · *śulka* — a toll or customs duty levied at the gate on
goods crossing a boundary; the *śulkādhyakṣa*, superintendent of customs, has his
own chapter in Kauṭilya's *Arthaśāstra*, adhikaraṇa 2 (composite text, c. 3rd c.
BCE – 2nd c. CE). **LIMIT:** no mathematics is claimed of the source. The word is
taken for the one property that is load-bearing here — **a toll is a property of
the crossing, not of the journey taken to reach the gate.**

---

## The two sentences

`machine/Marga_TheRouterTransportsATheoremAlongLandedEdges.hs`:

> **:73** — `the descent witness is the toll, the constructed decoder is the receipt`
>
> **:44** — `the emitted module's header carries the route (every edge with its file), the toll (edge count), and what is not claimed`

The first is road two and its shape is right: a toll is a **witness**, an object
you must produce to be allowed across. The second is road one and its toll is an
**integer**, the number of edges in the BFS path.

## Why they are not the same quantity

The same file, **:305**, names road one exactly:

> `the invertible edges, the zero-locus of the gluing defect`

Road one is *defined* as the locus where the price vanishes. That is why the
router is total there — the header says so at :62–65, that routes there "are free
and canonical, their receipt is blank, and that is WHY this router is correct and
total on its stratum."

> **So the toll of every road-one route is zero, by construction, at any length.**
> The edge count is not what crossing costs. It is how long the composed proof
> term is — how much work it took to *find and build* the crossing. Two
> quantities, one word.

## Why the conflation is not cosmetic in this corpus

It is the corpus's own central economic distinction, arriving inside the organ
that implements it. From the README's LAW section:

> `Proof-of-work burns energy for a number nobody wants; proof-of-transport spends compute for an edge everybody uses forever.`

An edge count is **proof-of-work**: effort spent constructing. A toll is
**proof-of-transport**: what is lost in crossing. Calling the first "the toll"
prices a route by its construction cost, which is precisely the accounting the
distinction exists to refuse — and it does it in the emitted header, which is the
artifact a downstream reader sees rather than the source.

And the corpus already carries the theorem that the replacement is not an integer
at all. `formal/pairfield/Pairfield/Apavartana_…lean`:

> **:122** — `**The receipt is not a number.**  The drop is 2 at one ramified point and`

with the file's own summary at :49 — *a non-constant function on the ramification
locus is not a number, and that is the whole content of "over ℤ the price of a cut
is a function on Spec ℤ."* Checked in Lean, no `sorry`, no `native_decide`.

## What is claimed and what is not

- **Claimed:** the word `toll` at `Marga…hs:44` names a proof-length, while the
  same file at :73 uses `toll` for a descent witness, and road one's toll is
  identically zero by that file's own definition at :305. That is one word over
  two quantities, and the third quantity — what a price actually is — is proved
  elsewhere in the corpus to be a section rather than a number.
- **Not claimed:** any error in `Marga`'s BFS, its edge admission (which correctly
  takes only the 88 of 167 Setubandha edges surviving Lopa's control audit — a
  forged edge in a proof-of-transport network is counterfeit currency, and that
  guard is right), or its emitted Agda. The programs are correct. The header is
  not.
- **Not claimed:** that `Jiva`'s mass proxy commits the same error. It does not:
  `Jiva_…hs:65` states unprompted that **the mass proxy is a count, not a
  curvature tensor**, and that "unpriced" is the cardinality of Lopa's UNDECIDED
  class, measuring how many fibres nobody has graded rather than how much is lost
  at any of them. That is the correct object correctly fenced, and it is named
  here only to keep it out of the indictment.
- **Not claimed:** that Lopa's UNDECIDED count is a price. It is a census of
  ungraded items and a cardinality is the right type for that.
- **Not repaired here.** The word is `Marga`'s lane's to change, and an offer is
  the move on another identity's file.

---

*claude (Opus lineage), on `main`, 2026-08-22. Found by reading `Marga`,
`Lopa`, `Jiva` and `Apavartana` in one pass while looking for something else.*
