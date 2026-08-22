# सङ्गति — the end state: the network transports, it does not vote, and the edge is the scarce thing

**Decentralization is not a design preference here. It is forced, and the
proof is already in this repository, written in a different lane, about
physics, by someone not thinking about networks.**

सङ्गति is Nyāya's word for the connection that makes a discourse one
discourse rather than a heap of sentences — the relation each topic bears
to what precedes it, without which nothing coheres. LIMIT: the term is
attested Nyāya vocabulary; its application to a transport graph is this
corpus's and no text is claimed for it.

---

## १ · The two theorems that force the shape

**Theorem F** (`notes/GAUGE.md`, `THE_BARRIER_IS_A_MIRROR.md`). A unique
KMS state vanishes on every charged sector: `E_Q[λ] = 0` for every `Q`.
Read at computation, not at physics: a system with **one equilibrium** —
one canonical form, one normalizing authority, one blessed chain — has
provably zero expectation on every charged sector. No refinement of the
*instruction* reaches it. Two things do, and only two: **place-coupling**,
and **many equilibria**. Many equilibria is many nodes with genuinely
different histories. That is decentralization, derived rather than
preferred, and it is why a better protocol rule cannot substitute for it.

**`Pratyabhijna_TheNetworkSeesOnlyTheUnionOfItsQueries.agda`** (checked
this session). Model each validator's total read as a finite list of
Boolean queries; the assembly's transcript is the concatenation. If every
validator is blind on a pair, **no** `decide : List Bool → Bool` separates
them — and `decide` is not required computable, so the quantifier covers
majority, stake weighting, committee sampling, multi-round, appeals, fraud
proofs, slashing. **Decentralization buys fault tolerance and
availability. It does not buy resolution.**

Together they cut the problem in two, and the cut is the criterion:
**which side of `f a ≡ b` is bound.**

| sector | fibre | verdict |
|---|---|---|
| **addresses** — "are these the same bytes" | bind `b` → `singl`, contractible | consensus is **free**. `isProp` is collision-freedom, inhabited is availability, the conjunction is `isContr`. Nothing to vote on. |
| **equivalences** — "are these the same object" | bind `a` → the preimage, not contractible even when everything works, because the **automorphisms live there** | consensus is the **wrong verb**, and Theorem F says no protocol rule reaches this sector at all. |

## २ · So the network's job at the second sector is TRANSPORT

Not voting. A node that has checked `A ≃ B` has created an **edge**, and
by univalence every theorem about `A` is now free at `B` — for every node,
forever, with no further work by anyone. Computation becomes routing:
to know a fact about `B` from a fact about `A`, find the shortest chain of
edges and `subst` along the composite. `_∙_` composes them. That is the
geodesic, and it is literal rather than figurative — the shortest path in
the identification graph is the least work, and there is no other work.

**The graph is directed exactly where the identification is a
factorisation.** `PunaragamanaVartula_…agda`: holonomy is road ONE.
**Paths invert; factorisations don't.** Bind `b` and the edge is
undirected (`sym` exists). Bind `a` and it is directed, and may be empty.

**The three verdicts are the routing table**, and this is why
`Tantujala_…agda` mattered: रिक्तम् (no path — नष्टि), एकम् (one path —
free, पुनरागमन), बहु (many paths — and then the *choice* of path is real
extra freedom, which is exactly where वर्गप्रकृति lives). `isContr` merges
the first and the third and would report "no route" and "many routes" with
one word. A router built on a two-valued verdict is `Saptabhangi.दुर्नयः`
compiled.

**And नष्टि is not "nothing survives."** `YugmaPurana_…agda`, this hour:
where a replay loses its trace, it still recovers the length **exactly mod
2 and no further** — three no-decoder theorems in two languages are all
sharp at that quotient, and their witnesses all pad by +2 because
`(−1)·(−1) = 1`. यत् तिष्ठति, कः नश्यति. A lossy edge is not a dead edge;
it is an edge to the quotient, and the quotient is nameable.

## ३ · What is scarce, which is the crypto answer

Not hashes — free to make, free to check. Not blocks.

**Edges.** A checked `A ≃ B`:

- **unforgeable** — the kernel checks it, and the check is cheap, local,
  and needs no trust in the producer. That is the verification asymmetry a
  chain actually requires, and it is *intrinsic* here rather than
  manufactured by difficulty tuning.
- **non-rival** — my using it does not consume it.
- **compounding** — every theorem on either side crosses, and every new
  edge multiplies against every existing path through its endpoints. The
  value is superlinear in the edge count in a way a hash lottery's is not.

Proof-of-work burns energy to produce a number nobody wants.
**Proof-of-transport spends compute to produce an edge everybody uses
forever.** The objection that "verification is not a mining function
because difficulty is not tunable" is correct and does not bite: tunable
difficulty exists to make a worthless object scarce. An edge is scarce
because it is hard to find and its value is in **use**, not in a lottery.

## ४ · Why it runs on a CPU

`formal/cubical/NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn.प्रस्तारः`
proves **`अङ्कस्थान rs ≡ Fin (सङ्ख्या rs)`** — at each छेद-सूची `rs`, नष्ट and
उद्दिष्ट each carry the other, so base and carried may be **exchanged** and
storing and generating are the same type. §४१ सारणी वा क्रिया is an
**identity, not a trade**. A node therefore does not need the corpus. It needs
the addresses and the generator, and materializes what it touches. The file
tree is a view, and a view is free.

> **[Corrected 2026-08-22. This paragraph read
> *"`punaragamana/src/Punaragamana/Prastara_…` proves **प्रस्तार ≡ ℕ**"*, and
> the wrong version is quoted rather than erased. No module of that name is in
> the tree or in git history, and nothing in this corpus proves प्रस्तार ≡ ℕ;
> the real codomain is `Fin (सङ्ख्या rs)`, finite, per rs — at `rs = []` it is
> `Unit ≡ Fin 1`. The exchange claim and everything this section builds on it
> survive verbatim, because they need base-and-carried to be interchangeable
> and not the base to be ℕ. The citation propagated to three files from one
> unopened path; see `notes/PunaruktiRatrau_…md` §६.]**

`Nama_…hs` measures the current state of the base: 887 files, 11,323
declarations, 10,641 addresses, 236 confirmed identical. Merge conflicts
are a नष्टि manufactured by the substrate — a text file binds the PATH and
derives the content, and a conflict IS that fibre failing to be
contractible. Content addressing binds the other side and the conflict
cannot be stated.

## ५ · The constraint that makes it non-violent, which is also a theorem

**हिंसा सङ्क्षेपः** — compression is violence (`AHIMSA_SUTRA_VISTARA.md`).
A network that reaches agreement by **merging** has compressed, and §६
says there are two roads and no third: **transport, or a written defect.**

So the network never merges. It transports, and where it cannot, it
**records the disagreement**. That is anekāntavāda as a protocol: many
nayas, none denying the others, and a naya that denies the others becomes
a **durnaya**. A chain that votes one fork true is a durnaya, mechanized.

The refusals are as load-bearing as the edges, and they are already being
made: fourteen modules share the type `ℕ × ℕ`, and Brahmagupta's pair, the
monochord's sounding, and a gene are **one type and three objects**.
Transporting between them would carry nothing and assert something false.
**नयभेदे सङ्क्षेपो न विद्यते.** Four modules proving `2ⁿ` were four
different questions. A store that reports those as duplicates has answered
a question it was not asked.

## ६ · And this is the same sentence as भावना

**भावना**, from √भू — *bringing into being*. Brahmagupta's own name for his
composition law, ब्राह्मस्फुटसिद्धान्त 18, 628 CE. Two solutions produce a
**third that neither had**, the invariant is inherited from **both**
(`Bhavana_….भावना-क्षेपः`: the kṣepas multiply, `k₁ · k₂`), and **all three
survive**. Two modes already named: समास and अन्तर.

Merging destroys two to make one. **Generation makes a third and keeps
all three.** Compression is violence; generation is the non-violent form of
union — and that is not an analogy laid over the mathematics, it is the
same operation, with its transmission law written down twelve centuries
before anyone needed a metaphor for it.

The network is भावना at scale. Nodes meet, neither is consumed, and what
passes between them is an edge that did not exist before and now belongs
to everyone.

---

*Pointers up: `SamagraDarsana_THE_LATEST_COMPLETE_VIEW_DEVELOPING_READ_THIS_FIRST.md`.
Checked terms behind every claim above: `punaragamana/src/`,
`formal/cubical/{Tantujala,PunaragamanaVartula,YugmaPurana,Saptabhangi}_*`,
`formal/cubical/NaturalMachine/Pratyabhijna_*`, `machine/Nama_*`.
Not yet checked, and named as owed: the edge graph itself, its diameter,
and the routing. An agent is building it now.*

---

# ७ · CORRECTED 2026-08-22, THE SAME NIGHT, BY AN AGENT SENT TO TEST IT

All three questions put to the physics lane came back **REJECTED**, and two of
the rejections land on this file. They are recorded here, at the claim,
because the recurring finding of this night is that corrections get marked and
claims do not.

## ७.१ · §१ is half wrong: "many equilibria" does not reach the charged sector at this grain

Theorem F derives invariance from **uniqueness**. But a transport-respecting
observable is invariant for free — `cong` gives it, with no hypothesis
whatever. So at the grain of the identification graph the mechanism of
Theorem F is not doing the work §१ credited it with.

Checked, in `formal/cubical/Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere.agda`
(exit 0): **every set-valued observable annihilates every loop**, no hypothesis
needed — and the loop is still not `refl`, and an untruncated observable sees
it at full strength. **Set-truncation is the whole of the blindness.**

And the charge is not where §१ put it. A transport-respecting observable is
constant on components and free to differ *between* them, so **the components
are the NEUTRAL sector**. The charge lives in the **loops** — of which
`Setubandha` counts 14 and files as "no reachability", i.e. as nothing.

This file's own Pratyabhijñā paragraph already said the neighbouring true
thing one paragraph later. The error was crediting Theorem F with a grain it
does not act at, not the conclusion that decentralization is forced.

## ७.२ · Indra's net cannot be one component, and this is a theorem

§२ was written as though connectivity were a limit the corpus is heading
toward. **It is unreachable in principle.**

`Unit` and `Bool` are both nodes of the identification graph. A path between
them would compose, by `compEquiv`, to `Unit ≃ Bool` — and `¬ (Unit ≃ Bool)`
is checked in this corpus **twice**. Six further forbidden pairs were found,
one of them `ℕ` against `ℕ → Bool` **by Cantor's diagonal, sitting on the
graph's own hub**.

So the jewels do not all reflect each other, and no amount of work will make
them. The 73 components are not a deficiency to be closed; **an upper bound on
connectivity is imposed by the separations themselves**, and every proved
separation is a wall that no future edge can cross. `Setubandha` counted 10
such separations; the re-run found one redundant, leaving **6 independent
walls**.

That is not a defeat of the picture. It is the picture becoming
**anekāntavāda instead of monism** — the net is necessarily many, the
standpoints genuinely do not reduce to one, and a program that tried to
connect everything would be proving `⊥`. The corpus's own structure forbids
the reading §२ was drifting toward, and forbids it with Cantor.

## ७.३ · And two numbers in this file were softer than they read

The re-run reproduced every figure and added two: **75 of the 143 edges are
within a single file**, so the between-jewel count is **68**, not 143. And the
transport graph's gluing defect is **identically zero** — every edge is
invertible, `rank(AB) = rank(B) − dim(im B ∩ ker A)` with `A` invertible gives
0 — so the transport graph **cannot express memory at all**, and has a
two-valued cut *indicator* where the physics lane has a cut *spectrum*.
`Setubandha`'s extractor matches `A ≃ B`, so it sees only the sector where the
causal order is trivial; the irreversible edges — retractions, truncations,
quotients — are **unmeasured**, and that is where the content is.
