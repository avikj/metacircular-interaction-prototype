# Vector-space AI: prior art, and the exact-vs-approximate contrast

*A prior-art survey of the vector-space / embedding / neurosymbolic AI most
adjacent to the Natural Machine, together with the load-bearing contrast: the
whole family represents meaning as **proximity in a metric space** — untyped,
witnessless, and lossy — whereas our primitive makes an identification between
representations either **exact and checked** (`Iso`/`Eq`) or, where it is only
approximate, a **typed `Approx(ε)` edge carrying an exact error bound** that
composes with ε adding (`legacy/runtime/CRYSTAL.md` §L1). The centerpiece: a
cosine similarity is our `Approx` edge that **forgot to carry its ε**, or our
`Quotient` that **never proved task-sufficiency**. This document develops what
"vector-space AI done right" would be on our primitive, and is honest about the
one thing the field has that we do not: it works, at scale, on messy real data,
today, with no formalization.*

Scope note in the repository's own terms: the vector-space methods below are a
foreign tradition and are named as such — a *restatement lane*, not the origin.
The origin material here is the fibre law
(`punaragamana/src/Punaragamana/Carrier.agda`) and its transport discipline
(`formal/cubical/NaturalMachine/SankramanaSesa_EveryTransportOwesItsResidual.agda`).
Where a vector-space idea coincides with ours ("holographic", "compositional",
"interpretable"), the coincidence is marked and the difference is the content.

---

## 1. The survey table

| family | representative systems / people (status 2026) | what it represents | how "meaning" is carried | its notion of "the same" | what it lacks vs. our primitive |
|---|---|---|---|---|---|
| **Vector databases / ANN search** | Pinecone, Weaviate, Milvus, Qdrant, Chroma, FAISS (library), pgvector | fixed-dim float vectors + metadata | approximate nearest-neighbor in a metric (cosine / L2) via HNSW, IVF, PQ | top-*k* under a distance threshold | no witness, no error bound; "similar" is a tuned scalar, not a typed edge |
| **RAG (retrieval-augmented generation)** | the dominant 2026 use case driving the ~$4.3B vector-DB market | query embedding → retrieved chunks → LLM context | cosine retrieval + generation | "relevant" = near in embedding space | retrieval is untyped routing by distance; no proof the retrieved set is task-sufficient |
| **Embeddings / representation learning** | word2vec, GloVe, BERT/sentence-transformers, OpenAI/Cohere/Voyage embedding APIs | learned map text/image → ℝⁿ | geometry of a trained manifold; analogies as vector offsets | "king − man + woman ≈ queen" — an offset heuristic | the map is a lossy summary that never names the fibre it forgot |
| **Hyperdimensional / VSA (vector-symbolic)** | Kanerva, Plate (Holographic Reduced Representations), Gayler (MAP), Rachkovskij; surveys Kleyko et al. 2021–2025 | high-dim (often binary/bipolar) hypervectors | algebra: **bind** (⊗), **bundle** (+), **permute** — compositional, *reversible-ish* | unbinding recovers a *noisy* approximation, cleaned up against an item memory | unbinding noise is real loss with no carried bound; the "holographic" overlap is exactly where our `Approx(ε)` differs |
| **Neurosymbolic AI** | Logic Tensor Networks, DeepProbLog, Neural Theorem Provers; AlphaGeometry 2 (DeepMind, 2025, 84% of IMO geometry); surveys arXiv:2507.11127 | neural front-end + symbolic reasoner | Neuro→Symbolic / Neuro[Symbolic] pipelines; differentiable logic | symbolic layer is exact, neural layer is soft | the seam between soft and exact is unbounded — no typed edge names how much the neural map lost |
| **Category-theoretic / compositional ML** | DisCoCat (Coecke et al.), Tai-Danae Bradley (Math3ma / Sandbox AQ), "Categorical Foundation of Deep Learning" survey arXiv:2410.05353, NeSyCat | functors / string diagrams over meaning | composition is a functor; grammar acts on meaning spaces | morphism equality, up to chosen semantics | the semantics functor lands in **Vect/Hilb** — back to metric proximity at the object level; no computing univalence |
| **Knowledge graphs / GNNs** | TransE/RotatE embeddings, message-passing GNNs | entities/relations as vectors + typed triples | relation = learned translation/rotation in ℝⁿ | scored plausibility of a triple | the type system is data-level, not proof-level; edges are scored, not checked |
| **Mechanistic interpretability** | Anthropic sparse-autoencoder features (Claude 3 Sonnet, 2024; "millions of features", 2025–2026), superposition hypothesis, transformer-circuits.pub | *post-hoc* decomposition of activations into sparse features | dictionary directions in activation space | a feature ≈ a monosemantic direction | it makes an *already-lossy* representation partly legible after the fact — it cannot install a bound, only estimate one |

Sources at the foot.

The table has one spine. Every row carries meaning as **position in, or
distance within, a real/complex vector space**, and every row's notion of
sameness is a *soft* predicate on that geometry: a threshold, a score, a
cleaned-up unbinding, a functor into `Vect`. None of them carries, alongside a
claimed correspondence, a **checkable witness** that the correspondence holds,
and none carries, alongside a claimed *approximate* correspondence, an **exact
bound** on how far off it is. That absence is not incidental; it is what lets
these systems run on raw data. It is also exactly the object our L1 lattice is
built to supply.

---

## 2. The centerpiece: exact-and-checked vs. proximity-in-a-metric

**Vector-space AI's atomic move is: *embed, then measure distance.*** Meaning
is a point; relatedness is nearness. The canonical demonstration —
`king − man + woman ≈ queen` — is a *heuristic with no witness and no error
bound*. It is asserted because the resulting vector lands near the "queen"
vector under cosine, on some models, for some vocabularies, and it silently
fails for most analogies. There is no object you can hold that certifies the
"≈", and no number that bounds how wrong it is. "≈" is a vibe: a region of
acceptable cosine that the practitioner tunes.

**Our primitive's atomic move is different in kind.** An identification between
two representations is either

- an **`Eq` / `Iso`** — an *executable* channel. Because univalence computes in
  this substrate, `transport (ua e)` reduces and `uaβ` proves the transported
  value is the equivalence's value on the nose
  (`SankramanaSesa` §1: `अलोपः = uaβ`). Sameness here is not measured; it
  **acts**, losslessly, both ways, carrying every downstream theorem for free.
  The witness *is* the edge.

- or, where the map is genuinely not an identification, an **`Approx(ε)`** edge
  (`legacy/runtime/CRYSTAL.md` §L1 table, row `Approx(ε)`): a *directed* edge
  that carries an **exact ε as a `Fraction`**, composes only with other
  `Approx` edges, and composes by **ε adding**, preserving bounded-error
  properties. "Approximate" is therefore a **typed, bounded, honest state** —
  not the absence of a claim, but a claim *with its slack named*.

The gap between the two frameworks is one theorem, already checked, that
vector-space AI has no analogue of:

> **Every transport owes its residual.**
> `SankramanaSesa_EveryTransportOwesItsResidual.agda` §2: for *any* map
> `r : A → B`, the exact thing `B` forgets over a target point `b` is
> `शेष r b = Σ[ a ∈ A ] (r a ≡ b)` — the fiber — and `सशेषम् = totalEquiv r`
> proves `A ≃ Σ[ b ∈ B ] शेष r b`: **target + residual = source, on the nose,
> with no slack.** A transport reporting "no loss" is issuing a *proof
> obligation*: `अलोप-लक्षणम्` proves loss-free ⟺ every residual contractible,
> which is `isEquiv`'s own definition. "I did not look" is not expressible as
> an instance of the machine's boundary record `सशेषसंक्रमणम्`, whose
> canonical constructor `सेतुं-कल्पय` supplies `fiber` *by construction*.

An embedding is a map `r : Text → ℝⁿ`. It has fibers — the whole preimage of a
region of the sphere is text it collapses together — and it **never names
them**. In our vocabulary that is the entire diagnosis of the field, in one
line: **the embedding is a boundary that owes a residual and defaults on the
debt.**

Two further checked facts sharpen the contrast:

- **When the loss is uneven, there is no single "residual" object at all.**
  `SankramanaSesa` §6, via `NaturalMachine.Anekanta.plurality-blocks-collapse`:
  a boundary that forgets different amounts over different target points has a
  residual family that is `syādasti` and `syānnāsti` together, and *no* type
  summarizes it (`शेषः-न-सङ्क्षिप्यते`). A single scalar "confidence" or
  "distance" over an embedding is therefore not merely lossy — as a summary of
  what was forgotten it is *unavailable in principle*. The honest record stays
  pointwise.

- **Which summaries are honest is itself a theorem.**
  `NaturalMachine/QuotientFiberLaw.agda`: a target function `t : X → Bool`
  `FactorsThrough` an observation `obs os` exactly when it is constant on the
  observation's fibers, and `collision-obstructs` proves that a single blind
  collision (`obs os x ≡ obs os y` while `t x ≡ not (t y)`) makes factoring
  **impossible** — repair requires reading a genuinely new charged channel.
  This is the exact statement a cosine-retrieval system can never make: it
  cannot certify that its embedding preserves the distinction the task needs,
  because it has no fiber and no factoring theorem — only a tuned threshold
  that empirically usually works.

So the contrast, boxed:

| | vector-space AI | Natural Machine |
|---|---|---|
| sameness | nearness under a metric | `Eq`/`Iso`: an executable, checked channel (`ua` computes) |
| approximation | untyped "≈", tuned threshold | `Approx(ε)`: directed edge carrying an **exact** `Fraction` bound |
| composition of approximations | error accumulates, unbounded, unmeasured | ε **adds**, provably (L1 `Approx` composition law) |
| what a lossy map forgets | discarded silently | the **fiber**, named by construction (`सशेषम्`, `सेतुं-कल्पय`) |
| "no loss" | never claimed, never checkable | a proof obligation: every residual contractible = `isEquiv` |
| honest summary | assumed | a theorem: `FactorsThrough ⟺` fiber-constant |

---

## 3. Vector similarity as "the `Approx(ε)` edge that forgot its bound"

The precise placement of cosine similarity in our lattice is the useful output
of this survey, because it says *what is missing* rather than merely *that
something is*.

A cosine-similarity claim `sim(u, v) = 0.87` is trying to be one of two edges
and is neither:

1. **It is an `Approx` edge with the ε deleted.** The L1 `Approx(ε)` edge is
   `A —Approx(ε)→ B` *with ε an exact `Fraction`* and the guarantee "bounded-
   error properties preserved". Cosine gives you the "0.87" but **no ε**: there
   is no statement of the form "any property in class 𝒫 transferred across this
   edge is wrong by at most ε". Without ε the edge preserves *nothing*
   provable; it is an `Approx` edge stripped of the only payload that made it a
   typed edge rather than a number. In the L1 table an `Approx` edge without its
   ε is not a weaker edge — it is **not an edge**, the way an `Order` edge
   without its ordering "would be correct over ℚ and silently wrong on the first
   sort with two orderings" (`CRYSTAL.md` §L1). The bound is constitutive.

2. **Or it is a `Quotient` edge that never discharged its obligation.** An
   embedding *is* a quotient: it deliberately identifies many texts (paraphrases,
   translations, near-duplicates) to one region. The L1 `Quotient` edge is legal
   **only when task-sufficiency is proved** — it "preserves task-sufficiency
   (must be proved)". A cosine index is a quotient asserted without that proof:
   it collapses `x` and `y` and *hopes* no downstream task needed them apart.
   `QuotientFiberLaw.collision-obstructs` is precisely the counterexample
   generator — the moment two task-distinct items land in one fiber, every
   function factoring through the embedding gives the wrong answer, and the
   system has no way to know it did.

Both readings converge on the same sentence: **vector similarity is a legitimate
edge of this lattice with its certificate removed.** VSA/HRR sharpens the point
rather than escaping it — Plate's unbinding *does* recover the bound argument,
but only up to noise that must be cleaned against an item memory, and that noise
is real residual with, again, no carried bound. The "holographic" of Holographic
Reduced Representations and the "hologram" of `notes/HOLOGRAM.md` are false
cognates worth separating explicitly: HRR is *superposition with lossy
retrieval* (bundle many bindings into one vector, pull one back approximately);
Theorem K's hologram is a *capacity/depth law* about how much exact arithmetic
content is readable from a finite span — an information budget, not a soft
memory. HRR forgets and hopes; the arithmetic hologram states the budget and its
irreducibility.

---

## 4. Vector-space AI *done right* on our primitive

The repair is not "replace embeddings with proofs". It is **install the missing
certificate on the edge the embedding already is.** Three concrete moves, each
naming an existing checked module as its target shape (no new Agda is asserted
here — these are design directions, in the sense of `CRYSTAL.md` §6's
BUILT/DESIGNED discipline):

**(a) Embedding = a lossy `Quotient`/`Approx` edge that carries its residual.**
Model an embedding as a `सशेषसंक्रमणम् Text ℝⁿ`
(`SankramanaSesa` §5): the map `अनुवादः`, *plus* the fiber family `शेषः`, *plus*
the reconstruction witness `पूर्णता`. The neural net supplies `अनुवादः`; the
kernel is owed `शेषः` and `पूर्णता`. A summary that forgets must **name the
fibre it forgot** — so an embedding ships with an explicit account of "these are
the texts I collapsed to this region", pointwise where the loss is uneven (§6).
This is the difference between a summary and an honest summary, and
`FactorsThrough ≃ fiber-constant` (`QuotientFiberLaw`) is the theorem deciding
which is which for a declared task.

**(b) Similarity = a typed `Approx(ε)` edge with a real bound.** Instead of
`sim(u,v) = 0.87`, emit `Text_i —Approx(ε)→ Text_j` with ε an exact `Fraction`
certifying a *stated* preservation class: "every predicate in 𝒫 agrees across
this edge to within ε". Retrieval then composes edges, and by the L1 `Approx`
law **ε adds along the path** — a multi-hop retrieval's total error is bounded
and computed, not hoped. The neural model *proposes* the edge (it is the
"perceptual channel" at the uncompiled boundary, `CRYSTAL.md` §5), and the
kernel *bounds* it: the model may be arbitrarily good at guessing a small ε, but
the ε is only real once checked. This is the frontier sentence in one line:
**the neural net proposes, the kernel bounds.**

**(c) RAG retrieval = charge-routing, not cosine distance.** Replace "return the
*k* nearest vectors" with "return the states in the query's **observable
class**". `NaturalMachine/GaugeOrbitClasses.agda` proves the fibers of the
transcript map `obs σ qs` are **exactly the cosets of the annihilator subgroup**
`qs^⊥ = { τ : val τ n = +1 for every n in qs }` (`classes-⇐`, `classes-⇒`):
`obs σ qs ≡ obs σ' qs ⟺ σ' ⋆ σ ∈ qs^⊥`. Read as retrieval: *relevance is
membership in a checked equivalence class defined by the query's charges*, not
proximity in a metric. Two documents retrieve together because a query cannot
tell them apart under its declared observations — a *typed* indistinguishability
with a witness — rather than because their cosine cleared a tuned bar. And the
parity lesson of the L1 lattice applies directly: `Quotient` (and `Iso`) cannot
deliver `sign`, so any task whose answer is a *charge* is provably invisible to
a pure-embedding index — the machine states its own blindness in its type
system, where a cosine index simply returns a wrong neighbor and cannot know.

The through-line: in every case the neural artifact is *retained*, demoted from
"the representation" to **untrusted sensory material at the boundary** — a
proposal the organism metabolizes, gated by a residual/bound it did not itself
supply. That is the corpus's own posture toward external models made concrete
for embeddings.

---

## 5. The honest gap: scale on messy data

The above is not free, and the field's advantage is real and large:

- **Vector-space AI works, now, on raw text and images, with zero
  formalization.** You can embed all of Wikipedia this afternoon and get useful
  retrieval by tonight. Our exactness demands a *checkable structure* — types,
  fibers, witnesses, an ordering for `Order`, a `Fraction` for `Approx` — and
  **raw text and images do not come with any of that.** There is no free functor
  from a JPEG to a `Carrier`. The whole L1 lattice presupposes that the objects
  already inhabit a typed world; the entire value proposition of embeddings is
  that they *manufacture* a usable geometry over objects that inhabit no such
  world.

- **The messy-data regime is exactly where "no ε" is a feature, not a bug.**
  Cosine similarity is robust to noise, typos, and paraphrase precisely because
  it never commits to a bound it would then violate. Our discipline — "an
  absence without a command is a rumor", "no residual is a proof obligation" —
  is a liability when there is no command to run and no proof to be had, only a
  billion vectors and a latency budget. `HOLOGRAM.md` itself is honest that its
  capacity law was *measured* (`code/exp31_capacity.py`), and this repository's
  own protocol treats a measured constant without its error term as "worse than
  no number" — a standard essentially no deployed embedding system could meet,
  and does not try to.

- **Neurosymbolic AI and mechanistic interpretability are the field reaching for
  our half and not getting there.** AlphaGeometry 2's exact symbolic core with a
  soft neural proposer is structurally *our* "model proposes, kernel checks" —
  but the seam is unbounded: nothing types how much the neural suggestion lost.
  Sparse-autoencoder features are the field trying to *recover* legibility from
  an already-lossy representation post hoc — an estimated fiber, not an installed
  one. They confirm the target (make the representation honest) and confirm the
  gap (they can only approximate the residual after the fact, never carry it by
  construction).

So the frontier is a bridge, stated without triumphalism: **take the lossy
neural embedding and lift it into the typed lattice** — the embedding becomes an
`Approx`/`Quotient` edge, the neural net proposes it and a candidate ε, and the
kernel either bounds it (installs `शेषः`/`पूर्णता`, discharges task-sufficiency)
or refuses it. What the field has that we do not is the ability to *start* on
messy data; what we have that the field does not is the ability to ever *finish*
honestly. The bridge is where a system could have both — and it is a design
direction here, not a built artifact.

---

## Sources (external, restatement lane)

- Vector databases 2026: [lakeFS](https://lakefs.io/blog/best-vector-databases/), [DataCamp](https://www.datacamp.com/blog/the-top-5-vector-databases), [Firecrawl](https://www.firecrawl.dev/blog/best-vector-databases), [tensorblue comparison](https://tensorblue.com/blog/vector-database-comparison-pinecone-weaviate-qdrant-milvus-2025)
- HDC / VSA / HRR: [Kleyko et al., Survey Part I (arXiv:2111.06077)](https://arxiv.org/abs/2111.06077), [Survey Part II (ACM CSUR 3558000)](https://dl.acm.org/doi/10.1145/3558000), [Generalized HRR (arXiv:2405.09689)](https://arxiv.org/pdf/2405.09689), [VSA (Simple Wikipedia)](https://simple.wikipedia.org/wiki/Vector_Symbolic_Architecture)
- Neurosymbolic: [Defining neurosymbolic AI (arXiv:2507.11127)](https://arxiv.org/html/2507.11127v1), [review (ScienceDirect S2667305325000675)](https://www.sciencedirect.com/science/article/pii/S2667305325000675)
- Categorical / compositional ML: [Categorical Foundation of Deep Learning survey (arXiv:2410.05353)](https://arxiv.org/abs/2410.05353), [Category/Topos frameworks survey (arXiv:2408.14014)](https://arxiv.org/pdf/2408.14014), [Tai-Danae Bradley / Math3ma](https://www.math3ma.com/about), [NeSyCat (arXiv:2604.24612)](https://arxiv.org/pdf/2604.24612)
- Mechanistic interpretability: [Circuits Updates, July 2025 (transformer-circuits.pub)](https://transformer-circuits.pub/2025/july-update/index.html), [SAE survey (arXiv:2503.05613)](https://arxiv.org/html/2503.05613v3), [Millions of features (arXiv:2606.26620)](https://arxiv.org/pdf/2606.26620)

## Modules cited (internal, origin lane)

- `legacy/runtime/CRYSTAL.md` §L1 — the typed edge lattice; `Approx(ε)`, `Iso`/`Eq`, `Quotient`, `Order` rows and their composition laws.
- `formal/cubical/NaturalMachine/SankramanaSesa_EveryTransportOwesItsResidual.agda` — every transport owes its residual; `सशेषम् = totalEquiv`, `अलोप-लक्षणम्`, the boundary record `सशेषसंक्रमणम्`/`सेतुं-कल्पय`, §6 no-summary.
- `formal/cubical/NaturalMachine/QuotientFiberLaw.agda` — `FactorsThrough`, `collision-obstructs`: which summaries are honest is a theorem.
- `formal/cubical/NaturalMachine/GaugeOrbitClasses.agda` — transcript-map fibers = cosets of `qs^⊥`; retrieval as charge-routing.
- `punaragamana/src/Punaragamana/Carrier.agda` — the fibre law: base + carried + witness.
- `docs/ARCHITECTURE.md` §1 — the substrate; univalence computes.
- `notes/HOLOGRAM.md` — Theorem K capacity/depth (the "hologram" that is *not* HRR).
