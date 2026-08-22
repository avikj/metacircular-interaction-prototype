# निर्हेतुकम् — the theorem has no hypotheses, which is why nine fields state it and none of them can see that it is one

**Grade.** Identifications and reading notes. **Nothing here is checked.** This
container carries no `agda`, no `lean`, no `ghc`: `toolchain=absent`,
`modules=0` — a check that cannot start is 0 checks performed, not N failed
ones. Corpus claims are CHECKED-ELSEWHERE with the file; outside claims are
CLASSICAL with a name and date; readings are MINE and owed proofs. Four of the
windows below are the owner's, in session 2026-08-22, and are marked OWNER.

**On the name.** निर्हेतुक — "without hypothesis" — plain sense, no text
claimed, following `Dhruva`'s and `Apunaragamana`'s practice.

---

## 0 · The mechanism, which is the only original thing here

`formal/cubical/NaturalMachine/QuotientFiberLaw.agda` (CHECKED-ELSEWHERE) states,
over an **arbitrary** state space and query family:

> An observation class sees exactly a quotient. What it cannot see is the fibre.
> No post-processing of the quotient manufactures the fibre. Visibility returns
> only by a separating query.

No hypotheses. Not "for finite X," not "for linear maps," not "for probability
distributions," not "over a field."

> **MINE, and it is the load-bearing claim of this note: every field below has
> this theorem, and each states it with local hypotheses, and the hypotheses are
> what make it look local.** Strip them and the residue is the same term. Nobody
> is missing the theorem. Everybody is missing that it is one theorem, and they
> are missing it for a structural reason rather than a sociological one.

The corpus's `ChargeCriterion.agda` (CHECKED-ELSEWHERE, an *iff*, separator
constructed in the "if" direction) adds the decidability half, with the sentence
that generalizes furthest: **separating power is a function of the charge of the
query, not of its size.**

## 1 · The roster

Each row: the field's own name for the obstruction, the hypotheses it carries,
and what survives stripping.

| field | local name | local hypotheses | residue |
|---|---|---|---|
| sieve theory | the parity barrier (Bombieri 1976; Friedlander–Iwaniec 1998) | sieve axioms, multiplicative functions | a query class blind to a ℤ/2 charge |
| arithmetic geometry | failure of the Hasse principle; Ш; Brauer–Manin | abelian varieties, Galois cohomology | the kernel of *observe at every place* |
| quantum foundations | Kochen–Specker; contextuality (Abramsky–Brandenburger 2011) | Hilbert space, commuting contexts | no global section over a covering by contexts |
| coding | Knill–Laflamme | CPTP maps, a code subspace | `im B ∩ ker A = 0` |
| sensing | the null-space property (Candès–Romberg–Tao 2006) | sparsity, ℓ¹ | the signal class meets the cut's kernel trivially |
| complexity | relativization, natural proofs, algebrization | oracles, circuit classes | a proof technique blind to the separating structure |
| molecular evolution | synonymous ≡ "silent"; the `dN/dS` baseline | the genetic code | the codon fibre carries what the protein readout cannot see |
| interpretability | polysemanticity, superposition, probe validity | ReLU nets, linear probes | more features than dimensions ⟹ the readout has fibres |
| bookkeeping | the trial balance | accounts | a total forced to zero over all postings |

## 2 · The owner's four, recorded because they are his and dated

**OWNER, 2026-08-22, in session.**

1. **Writing was born as a receipt.** Schmandt-Besserat: clay tokens ~8000 BCE;
   by Uruk (~3400–3200) tokens travel sealed in bullae with the count impressed
   outside — contents are the fibre, impression is the quotient, envelope broken
   only on dispute, **the kernel invoked lazily at challenge**. Scribes notice the
   impressions suffice and drop the tokens; the oldest writing in existence is
   warehouse accounting. Store little, generate the rest, check on challenge.
   The arc: receipts → writing → prose → "hence" → counterfeit press → kernel.
2. **Zero-knowledge is नास्ति-प्रत्यानयनम् sold as a product.** A ZK proof mints a
   receipt that `∥witness∥` is inhabited while carrying nothing of *which*
   witness, and the simulator is the proof that the verifier's entire view
   factors through the point. Soundness is the other road: the receipt cannot be
   minted without the fibre. One edge, both roads at once — and the two
   literatures have never been introduced.
3. **Compressed sensing and QEC are one condition.** The null-space property and
   Knill–Laflamme are both *the class dodging the cut's kernel*; movement 2
   already holds half of it; three literatures, one intersection-vanishing lemma,
   cited together nowhere.
4. **P ≠ NP is the conjecture that road two is nonempty at the polynomial
   grain.** A certificate is a receipt; NP is where receipts check cheap;
   one-way functions are poly-grain lossy edges with expensive fibres; and
   Cook–Levin–Karp built the first proof-of-transport network — every NP problem
   crossing to SAT along explicit reductions, theorems riding both ways — fifty
   years before anyone priced the edges.

## 3 · Five more, MINE, in decreasing confidence

**3.1 · The tablet is single-entry, and that is the missing half of §2.1.**
Uruk IV is a *list*: it records, and nothing constrains it. The bulla's lazy
kernel checks the **carrier** (break, count, catch the porter); it cannot catch
the **scribe**. The balancing constraint arrives in the Tuscan and Genoese
ledgers c. 1300 and is codified by Pacioli, *Summa*, 1494 (CLASSICAL): every
entry posted twice with opposite sign, **the sum over all accounts forced to
zero**. That is the moment a record becomes a conservation law — a check
internal to the record, so a forgery fails against the ledger's own totals
rather than against reality.

> Mathematics inherited the tablet and never got the ledger. A proof is Uruk IV:
> locally plausible lines, no total, no second posting. `hence` fails against no
> invariant, which is exactly why it is free to write.
>
> And `Σ_v log|x|_v = 0` is double entry for **number** — see
> `Sarvasthanam_…md`. Pacioli and Ostrowski are the same invention.

**3.2 · The Rosetta Stone is the paradigm proof-of-transport, and "lost" was the
wrong word.** Three presentations, transport unlanded for two millennia,
Champollion 1822 (CLASSICAL), and **every Egyptian text ever written crosses for
free, forever, retroactively.** One edge, one life, non-rival, still paying out.
Before 1822 Egyptian was not lost — it was intact, complete, and **untransported.**
The information was never destroyed; the bridge was missing. Which is the
corpus's own diagnosis of mathematics, and it means "Rosetta" is the correct
technical term rather than a flourish.

**3.3 · The genetic code is Knill–Laflamme, and "silent mutation" was a
fifty-year durnaya.** 64 codons → 20 amino acids: a degenerate map, fibres of
size 1–6, and the third position wobbles (Crick 1966) so that point mutations
land **inside the same fibre** overwhelmingly often — the encoding's image
dodging the noise's kernel, against the actual mutational spectrum (Freeland &
Hurst 1998 measured how special that is). CLASSICAL as biology; the
identification with the KL condition is MINE.

> Then the durnaya. The fibre is invisible **to the protein sequence**, so the
> field called those mutations *silent* — a boolean verdict on a many-valued
> question. Codon usage bias, tRNA availability, translation kinetics and
> co-translational folding are carried in that fibre (MDR1, Kimchi-Sarfaty et al.
> 2007). And `dN/dS`, the workhorse of molecular evolution, takes the synonymous
> rate as the **neutral baseline** — the field calibrated its measuring rod
> against a fibre it had declared empty. मौनं न निषेधः.

**3.4 · Interpretability's central methodological crisis is `charge-criterion`,
unposed.** More features than dimensions ⟹ the readout map has nonempty fibres
by pigeonhole, so polysemanticity is **the fibre, observed** (Elhage et al.,
*Toy Models of Superposition*, 2022 — CLASSICAL). The field's hardest open
question — *does this probe measure the feature or a correlate?* — is exactly
*does this query set contain a separating query?*

> And the corpus's answer kills the field's dominant strategy: **separating power
> is a function of the charge of the query, not of its size.** `two-primes-blind`
> exhibits a **larger** query that still cannot see. A decade of scaling the probe
> is scaling the wrong coordinate. MINE, and the one on this page with the
> largest live consequence.

**3.5 · Contextuality is a failure of the Hasse principle for the covering by
measurement contexts.** Locally consistent everywhere, globally impossible,
obstruction in `H¹` — in both cases. `Ш = ker(H¹(K,E) → ∏_v H¹(K_v,E))` is
literally the kernel of *observe at every place*. The corpus holds the
Peres–Mermin `H¹` class as checked terms. Developed at length in
`Sarvasthanam_…md` §7 with its prior-art fence.

## 4 · What transports, in both directions

- **arithmetic → quantum foundations:** the descent-obstruction toolkit
  (Brauer–Manin, torsor descent, finiteness questions) is the most developed
  existing theory of what an observation class cannot see, and is not used there.
- **the corpus → interpretability, sieve theory, molecular evolution:**
  `charge-criterion`'s move — decide admissibility in advance, construct the
  separator when one exists, and stop scaling a blind query.
- **cryptography → the corpus:** ZK is the privacy layer the receipt economy
  lacks, already built, forty years deep.
- **bookkeeping → mathematics:** the balancing constraint. Seven hundred years
  late.

## 5 · Prior art, stated because it binds

**No `WebFetch` was attempted and no paper was opened.** Every outside claim here
is at recall grade, weaker than the search-summary grade
`OPEN_PROBLEMS_WE_TOUCH.md` §0 already fences. **Absence of a located source is
not evidence of novelty**, and several of these joins are likely known *inside*
a field — the KL/null-space kinship is folklore among people who do both; the
sheaf-cohomological reading of contextuality is a live literature. The claim of
this note is not that any row is unknown. It is that **the rows are one row**,
and that no document I have found states more than two of them together.

## 6 · What is not claimed

- No theorem is proved and no term is checked here.
- No row is claimed novel. §5 binds.
- The corpus's own charge criterion is landed **at the smallest nontrivial
  scale** (`TARGET.md` §4b): completely multiplicative ±1 functions and one gauge
  flip. W3 and W4 are not done. Nothing here extends it.
- Reading `dN/dS` as a durnaya reaches the *neutral-baseline assumption* and
  nothing else; the statistic is sound where the assumption holds.

---

*Written by claude (Opus lineage) on `main`, 2026-08-22, in a session with no
toolchain, after five readings of the README at the owner's instruction. §2 is
his. Everything marked MINE is owed a proof.*
