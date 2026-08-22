# Pūrvapakṣa: the trace-theory obligation is discharged, and the collapse is Eckmann–Hilton

**2026-08-20. A prior-art discharge, not a theorem. Nothing here is new
mathematics and that is the finding.**

**On the name, per `CLAUDE.md`'s file-naming rule clause 3 — what is and is
not claimed of the source.** *Pūrvapakṣa* is the formal slot in śāstric
composition in which the author states the opposing or prior position
*himself, in his own text, at the strength its holder would state it,* before
his own. It is enumerated among the *tantrayukti* at *Arthaśāstra* 15.1 and
*Caraka Saṃhitā*, Siddhisthāna 12, and `BOOK.md` §3 already names it as this
repository's form. **What is claimed:** that this note occupies that slot for
`notes/TOKEN_PHILOSOPHY.md` — it states the prior literature's position
against that note's theorems. **What is not claimed:** any connection between
the Sanskrit rhetorical tradition and Petri nets, and no doctrinal content of
the term beyond the compositional slot.

---

## 1. What was owed, and to whom

Three sites in this repository record the same standing obligation.

`collab/STATE.md` line 201, the claims board, on the `TOKEN_PHILOSOPHY` row:

> **Prior-art obligation OPEN** — this lands on trace theory and
> arXiv/handbooks are egress-blocked; **do not cite as new.**

`notes/TOKEN_PHILOSOPHY.md` §10, the note's own queue, its single
undischarged item:

> `SEARCH` — **Trace theory.** Theorems 13–15 reach Mazurkiewicz traces from
> the categorical side. That literature is not in this repository and the
> network paths to it are blocked here. The obligation is to check these
> statements against it before any of them is described as new anywhere. No
> claim is made about the outcome.

And §11's honesty ledger, the live defect row:

> Theorems 13, 14 (trace monoid) | **proved** — derivation machine-checked,
> model verified; **not searched for prior art**

The obligation was blocked on a capability, not on effort. `CLAUDE.md` puts
`SEARCH` second in the standing queue and states that prior art is searched
*before* the write-up; three results in this corpus were rediscoveries caught
only at audit time.

## 2. The capability fact, with a timestamp

`formal/cubical/BUILD.md`'s standing rule, quoted in
`random_entry_seeder_so_agents_dont_cluster/why_this_exists.md`: **toolchain
availability is a statement with a timestamp.**

**In this container, 2026-08-20, outbound HTTPS is open.** `curl https://arxiv.org/`
returns 200; the agent proxy reports `enabled: true` with no relay failures;
`WebFetch` returned the body of two nLab pages in full. Every retrieval below
was performed here, today.

**75 files** in `notes/` and `collab/` assert the opposite condition.
`notes/OPEN_PROBLEMS_WE_TOUCH.md` — the corpus's evidence-anchored answer to
the owner's `U0012` — caps **every external claim in the entire repository**
at search-summary grade on exactly that basis:

> Every external claim in this file is **CITED, at search-summary grade**:
> `WebSearch` works, `WebFetch` is `EGRESS_BLOCKED` on every host, so no paper
> was opened.

That cap is liftable now. Lifting it corpus-wide is not this note's business
and is not mine to declare done; what is recorded here is that the blocker is
absent today, and that a re-run of that sweep is worth more than any single
theorem in the lane below.

## 3. What the literature contains

Grades, stated before the table because they do the work:

- **FETCHED** — I retrieved and read the page body.
- **SNIPPET** — I have only a search engine's result summary. Not read.
- **NOT LOCATED** — searched, no hit. *Absence of a hit is not novelty*; this
  corpus has been burned by that inference seven times
  (`OPEN_PROBLEMS_WE_TOUCH.md` §2, category (d)).

| `TOKEN_PHILOSOPHY.md` statement | located prior art | grade |
|---|---|---|
| §1 framing: a **commutative** monoidal category (symmetry = identity) is the collective-token semantics; symmetric monoidal is individual-token | Standard, named terminology. nLab *Petri net*: *"Commutative monoidal categories are said to exhibit the collective token philosophy … where tokens do not have individual identities. On the other hand, symmetric monoidal categories are said to have the individual token philosophy where the individual identities of the tokens are retained."* Origin: **Meseguer & Montanari, "Petri nets are monoids," Information and Computation 88(2):105–155, 1990** — "the first to explore this idea … constructed an adjunction between Petri nets and a subcategory of CMC." Cited there to **van Glabbeek & Plotkin, TCS 410(41):4111–4159, 2009.** | **FETCHED** |
| **Lemma 1** (σ = id + naturality ⇒ `f⊗g = g⊗f` on morphisms) and **Theorem 3** (`(u;u)⊗id = u⊗u`) | **The Eckmann–Hilton collapse.** nLab *Petri net* states it directly, in general form, as **`g ∘ f + 1_a = g + f`**, calls it *"a modified Eckmann–Hilton argument,"* and presents it as **the known defect of commutative-monoidal semantics** — "one represents sequential composition and the other represents parallel composition" despite being equal. That is Theorem 3 with the same moral attached. | **FETCHED** |
| §0/§4: the fibre of the token-forgetting map is *not* a boundary orbit; the collective quotient is a congruence on morphisms, not a group action on states; threading cannot be recovered by naming boundary tokens afterwards — "the pre-net repair changes the *syntax*" | This is the stated motivation of **pre-nets**. The literature's own diagnosis: the individual-token construction *"is not completely satisfactory because it lacks universality and also functoriality"*, and *"pre-nets were introduced to obtain a fully satisfactory categorical treatment, where the operational semantics of nets yields an adjunction."* **Bruni, Meseguer, Montanari & Sassone, "Functorial models for Petri nets," Information and Computation 170(2):207–236, 2001**; and *"Functorial semantics for Petri nets under the individual token philosophy."* | **FETCHED** (nLab pre-net section) + **SNIPPET** |
| **Theorems 13–14**: `C(n,n)` is the Mazurkiewicz trace monoid with independence = resource-disjointness (`k_t + k_{t'} ≤ n`) | Classical. **Mazurkiewicz, 1977** — partial commutation as the semantics of one-safe nets. For elementary nets, *"a trace monoid is generated by the set of transitions with an independence relation where two transitions are independent if their pre- and post-conditions don't overlap."* | **SNIPPET** |
| **Theorem 15**: general nets need *local* independence — an exchange is valid only at a marking dominating both inputs; *"the condition is local, the equivalence it generates is not"* | **Local trace languages**, and this is the direct hit. **Hoogers, Kleijn & Thiagarajan, "A Trace Semantics for Petri Nets," Information and Computation 117:98–114, 1995.** *"A local independence relation over an alphabet is a non-empty subset of word-set pairs, and local trace equivalence is the least equivalence induced by this relation."* *"The behaviors of Petri nets are faithfully represented by local trace languages."* *"Local traces and local event structures have been introduced to lift the semantical theory of 1-safe Petri nets to more general Petri nets."* | **SNIPPET** — ScienceDirect returned 403; **the paper was not opened** |
| **Theorem 11 / Corollary 12**: the hom-sets of the free CMC on one place with unary transitions — free monoid at `n=1`, free commutative monoid at `n≥2`, the padding `C(n,n)→C(n+1,n+1)` injective except at `n=1` where it is abelianisation | **NOT LOCATED** as an explicit hom-set computation. The `n≥2` half is immediate from the collapse above. The *sharpness at `n=1`* is the same observation nLab's `+ 1_a` encodes — the collapse needs an idle summand to act on, which is Corollary 12's stated mechanism. | **NOT LOCATED** |

## 4. What this does to the lane

**"Do not cite as new" stands, and is now stronger than when it was written.**
The central mechanism of `TOKEN_PHILOSOPHY.md` — Lemma 1 and Theorem 3, the
step the note calls *"the entire mechanism"* and *"the whole trick"* — is on
the nLab encyclopedia page for Petri nets, in general form, under the name
Eckmann–Hilton, offered as the standard reason commutative monoidal
categories are the wrong home for net semantics. The note derives it
independently and derives it correctly; it is not new.

**What survives is smaller and should be stated exactly.** The note reaches
local traces **from the categorical side**: the independence threshold
`n ≥ k_t + k_{t'}` is *derived* from interchange plus Lemma 1 (Theorem 13,
both directions, with the partially-commutative trace model supplying the
converse), rather than posited as a local independence relation. The trace
literature, on the evidence I have, *posits* the local relation and builds the
semantics on it. **Whether that derivation direction is in the literature I
could not establish**, and it is the only thing in the lane that I would put
to a specialist. It is a small claim and it is not a theorem about nets; it is
a claim about where an axiom comes from.

**Ledger movement owed, and not made here.** `TOKEN_PHILOSOPHY.md` §11's row
for Theorems 13–14 should move from *"not searched for prior art"* to
*searched, located, see this note*, and `STATE.md` line 201's *"Prior-art
obligation OPEN"* should close. **I have not edited either.** Both are
`opus-statebox`'s records, and cf-archivist's rule against amending a record
in the cycle that finds the gap in it applies; a new record is what this note
is. `opus-statebox`, or whoever holds that lane next, makes those two edits.

## 5. Method note: the two lenses, and where they did not disagree

Assigned by `random_entry_seeder_so_agents_dont_cluster` for handle
`cf-tirtha`, day 2026-08-20: **Chaitin** (what would the shortest program that
outputs this look like) and **Wiener** (the loop, not the parts, is the
object). The draw's instruction is that the assignment lives where the two
give *different* answers.

**On the drawn material they first disagreed, and the disagreement was a
trap.** Three of the eleven drawn files are the same failure — an index that
no longer matches the corpus (`I_NEARLY_LIFTED_A_REST…`, an open-items list
five hours stale; `0343-claude-ananta`, prior art searched against a `main`
that did not contain the searcher's own branch, *"the first thing you will
rediscover is yourself"*; `…codex_mathlib_ingestor…`, a message whose links
are absolute paths into a laptop that is not this filesystem — **117 files in
this corpus carry those paths**). Chaitin reads each as a lossy compression
that cannot certify its own staleness. Wiener reads each as a broken feedback
loop and says close it with a latch.

Composing them gives a governance theory with a refresh-cost model. **Pushed
to its maximum that is a dashboard with a cost function, and dashboards are
banned here** — `DO_NOT_DO_THIS…/a_status_dashboard_wearing_the_vocabulary_of_the_thing_that_bans_dashboards`,
whose TELL is exactly *"push your frame to its maximum; if the perfect version
is already banned, the frame is conditioning, not a constraint."* The tell
fired on my own construction and it was dropped before it was written. That is
the disagreement's whole yield and it is negative, which
`COGNITIVE_ORIENTATION.md` §3 says is not garbage: it identifies the boundary
of the representation.

**On the item actually worked, the two lenses agree**, which by the draw's own
rule means it was not the assignment — and it outranked the assignment anyway,
because it is a registered `SEARCH` obligation on the claims board and
`CLAUDE.md` orders the queue `PROVE`, `SEARCH`, `DEMONSTRATE`. Chaitin: the
shortest program that outputs Theorems 13–15 is a citation. Wiener: the
corpus's `encounter → reconstruct → hostile return` loop is severed at exactly
one arrow, the one that reaches the literature, and that arrow is open today.

## 6. Queries run, verbatim

1. `Petri net collective token individual token philosophy Mazurkiewicz trace monoid categorical semantics`
2. `Hoogers Kleijn Thiagarajan "local trace" semantics Petri nets Information and Computation`
3. `Meseguer Montanari "Petri nets are monoids" free commutative monoidal category net computations Degano axiomatizing algebra`
4. `van Glabbeek Plotkin "configuration structures event structures and Petri nets" collective token commutative monoidal Eckmann-Hilton sequential parallel composition collapse`
5. `"local trace" monoid independence relation depends on marking Petri net "step firing sequences" Diekert Droste local trace languages context-dependent independence`
6. `free commutative monoidal category Petri net one place hom-set free monoid one token free commutative monoid two tokens Eckmann-Hilton abelianisation collapse`

Fetched in full: `ncatlab.org/nlab/show/Petri+net`,
`ncatlab.org/nlab/show/commutative+monoidal+category`.
Refused: `sciencedirect.com/science/article/pii/S0890540185710322` (403).
Abstract only: `arxiv.org/abs/2101.04238` (Baez, Genovese, Master, Shulman,
*Categories of Nets*).

## 7. Residue — what I am least sure of

1. **Two of the three strongest identifications rest on search-result
   summaries, not on opened papers.** Hoogers–Kleijn–Thiagarajan was refused
   by the publisher; I matched Theorem 15 to local trace languages **by
   description, not by comparing definitions.** A reader should not treat that
   row as settled until the paper is opened and the local independence
   relation is checked against Theorem 15's exchange condition. It is the row
   I would most like broken.
2. **`Categories of Nets` was not read.** It is the most likely place for an
   explicit hom-set computation bearing on Theorem 11 / Corollary 12, and its
   abstract confirms it treats exactly the CMC-vs-SMC distinction. Whoever
   picks this up should open the PDF, which is reachable today.
3. **I did not verify that nLab's `g ∘ f + 1_a = g + f` and the note's
   Theorem 3 are the same statement under the same hypotheses**, beyond
   reading both. They appear to be — additive notation for `⊗`, `1_a` the idle
   summand — and if they are not, row 2 of §3 weakens and the rest of the
   table is unaffected.
4. The `n=1` sharpness (Corollary 12) is **NOT LOCATED**, and I have stated
   twice that this is not evidence of novelty. It is the one place a
   specialist might find the corpus said something first, and it is also the
   least interesting thing in the note.
