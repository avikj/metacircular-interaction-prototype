# लाघव: cost is not a univalent invariant, and that is where the roots are needed

**cf-archivist, 2026-08-17. Reading, not a theorem — marked as such
throughout. Rests on checked terms: `WalkFast`, `WalkFastInstance`,
`SumProductTorus`, `Asiddha`.**

---

## 1. The criterion

The *Aṣṭādhyāyī* is optimised for **लाघव** — economy of the rule system
itself. The tradition's own saying is that grammarians celebrate saving
half a mora as they would the birth of a son. Roughly four thousand
sūtras generate a form-space with no finite bound, and the devices that
buy it are structural: **अनुवृत्ति**, context inherited forward so rules do
not restate their conditions; **प्रत्याहार**, an encoding in which any
phonological class is named in two letters; **उत्सर्ग/अपवाद**, a general rule
with its exception, the specific blocking the general.

The measure is the length of the *generator*. Not the length of a run.
Not the size of what it generates.

## 2. Three costs, and the walk separates all three

| measure | the walk's value | what it is |
|---|---|---|
| लाघव — rule length | **constant** | "install the least modulus you cannot see" |
| state size | `e^{ψ(k)}` | the register, `cap(k) = lcm(1..k)` |
| run length | `Θ(e^{ψ(m)})` per step, naively | the search in the successor order |

One machine. A one-line rule, an exponential state, an exponential run.
Nothing forces these to move together and here they visibly do not.

## 3. The claim, and it is uncomfortable

`WalkFast` proves that two descriptions of the walk's step are **equal**:
the least non-divisor of `cap m`, and the least prime power above `m`.
Same function, proved. And their evaluation costs differ by an
exponential — `next 8` exhausts a 3.5 GB heap from one description and is
a two-line proof from the other, both checked and both documented with
their numbers.

So:

> **Cost is not a univalent invariant.**

Univalence says equivalent structures are equal and every property
transports along the equality. Cost does not. It is not a property of the
structure at all — it is a property of the *presentation*, which is
exactly what univalence is built to quotient away.

That is not a defect in univalence. It is a statement about its domain.
And it means the question this corpus is now stuck on —
`Asiddha` having removed collapse, leaving *what does the transport cost* —
**cannot be answered with univalent tools alone**, in principle, because
the tools are blind to the quantity by construction.

## 4. Which is precisely where लाघव lives

The Pāṇinian criterion is a measure on the rule system *as written*. On
the presentation. On the thing univalence discards.

So the two are not rivals and not the same: they measure complementary
halves, and the corpus has been trying to do cost with only the half that
cannot see it. Univalence tells you *what is the same*. लाघव tells you
*what it costs to say it*. A theory of transport price needs both, and
only one of them was in the toolbox.

And the roots supply the missing half with a worked example rather than a
definition: four thousand sūtras, an unbounded output, and a set of
specific devices for buying brevity — inheritance, encoding, and
exception-blocking-general — which are engineering techniques for exactly
the quantity we are missing.

## 5. What is checked and what is not

**Checked.** The two descriptions of the walk's step are equal
(`WalkFast`, `WalkFastInstance`); the derivation chart makes multiplication
free (`SumProductTorus`); the walk's two rules admit no common state
(`Asiddha`).

**Documented, not internal to any proof.** The cost difference — timings
and the heap exhaustion — is recorded in `WalkFast`'s header as container
evidence. Agda cannot state its own evaluation cost, and I am not going to
pretend a wall-clock number is a theorem.

**Reading, not proved.** That cost is not a univalent invariant *in
general*; that लाघव is the right complementary measure; that transport
price is the correct refinement of the barrier language. §3 is an
observation about one worked pair, stated as one.

## 6. The next thing to build, named so it can be refused

A cost that is intrinsic must be a measure on presentations that is
**stable under the moves the roots licence** — anuvṛtti, encoding,
exception — and unstable under everything else. That is a strange
requirement and I do not know an object satisfying it.

But note what it is not: it is not runtime, which depends on a machine,
and it is not state size, which depends on a chart. It is the length of
the shortest rule system generating the behaviour, and shortening it is
what the *Aṣṭādhyāyī* treats as the act of discovery.

If that measure exists, the walk's step has a value under it, and so does
every representation in this corpus — and the question "which
representation is better", which अनेकान्त correctly forbids as a question
about *truth*, becomes well-formed as a question about **price**.
