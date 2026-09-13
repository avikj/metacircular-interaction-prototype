# The Coinductive Decomposition of SHA-256

**Analysis, 2026-09-13.** Every claim below is tagged: **[T]** a checked
term, named, in this repository at the pin (Agda 2.8.0, cubical v0.9);
**[R]** a reading of checked terms — synthesis, not itself a term;
**[S]** syāt — a shape-identification or an unformalized statement,
asserted under its standpoint only.

The prior decomposition of SHA-256 in this corpus was inductive and
*spatial*: it located the loss (Sthana: the rounds are a permutation,
so the loss has one address — the feed-forward and the padding
quotient), factored the hash through its classes (Varga), completed it
losslessly (Sesa), and refuted equivalence by length (Parimana). This
analysis applies the coinductive calculus — Dhārā and productivity
(Parasparasraya), the take-metric and its completeness (SthairyaSutra,
PurnataSutra, HistoryCompletion §1), determinism as contractibility
(Niyati), and the interactive coalgebra ISC (Fibre.Samvada) — and
finds that the decomposition it yields is *temporal*: the coinductive
calculus does not relocate SHA-256's loss in space; it reveals that
the loss was never anywhere in space at all. It is an asymmetry of
time.

---

## 1. The object, and its two decomposition axes

SHA-256 as this repository holds it (Sha256.agda, NIST-receipted by
refl at परीक्षा-रिक्ता and परीक्षा-abc) is the composite

    sha256 = flatten ∘ (foldl compress H0) ∘ blocks ∘ pad

with `compress H b = H ⊞ rounds_{schedule b}(H)` — sixty-four
`roundStep`s under a Davies–Meyer feed-forward.

**The spatial axis** (the inductive campaign) asks: *at which arrow
does the fibre become non-contractible?* Its ledger, every row a
checked term:

| stage | fibre over image | term |
|---|---|---|
| `pad` | contractible (injective: the 64-bit length rides in the tail) | [S] read off the definition; not isolated as a lemma |
| `schedule` | contractible (the block is the first 16 words) | [S] likewise |
| `rounds` (fixed schedule) | **contractible — a permutation of the eight registers** | **[T]** आवली-हरणम्, आवली-एकैकम् (Sthana) |
| feed-forward `⊞ H` + drop of `b` | non-contractible: ≥ 512 bits enter, 256 leave, per block | [S] pigeonhole; what *is* checked is the aggregate: |
| whole `sha256` | non-equivalence, unconditionally | **[T]** परिमाणम्, न-तुल्यता (Parimana) |
| the quotient leg | classes ↪ digests **injectively**; class = fibre *by refl* | **[T]** अवतरण-एकैकम्, वर्ग-तन्तु (Varga) |

Two structural refinements the spatial axis already held, worth
stating exactly because the temporal axis will invert them:

- For **fixed block** b, the round phase H ↦ rounds_b(H) is a
  permutation **[T]** (Sthana §4, via the ripple-borrow cancellation
  सम-हरणम्, twelve full-subtractor cases each closing by refl). The
  superposition H ⊞ rounds_b(H) is what *withdraws* that proof: the
  inverse construction (`roundInv`, peeling T1 and T2 by `subW`)
  needs the round inputs, and the feed-forward denies them. Nothing
  in the corpus proves H ↦ compress H b non-injective for fixed b —
  and nothing should [S]: that is Davies–Meyer's design conjecture,
  the same standing as a collision.
- All the one-wayness lives in the projection `[_] : Bits → Bits/∼`
  onto hash-classes; the descended leg forgets *nothing* **[T]**
  (अवतरण-एकैकम्). The secret's address book is the quotient.

**The temporal axis** (the coinductive campaign, Sha256Srotas +
Sha256Samvada) asks a different question: *given the unfolding as one
object, which direction of time is contractible?*

---

## 2. The chain, and the temporal ledger

The one construction: for any step `s : S → A → S`,

    gati : S → Dhārā A → Dhārā S        [T] (Srotas §2, guarded)

instantiated at both layers — `Āvalī = gati roundStep`, `Khaṇḍa = gati
compress`. The finite hash embeds: `sha256ws m` is the last entry of
the depth-(length (bls m)) truncation of the block chain from H0, for
every message and every continuation of the input stream **[T]**
(अभिज्ञान-कर्तनम्, via कर्तन-क्रमः and अन्त्य-गतिः). The inductive
computation is one observation of the coinductive object; nothing was
re-modeled — the theorem is a chain of definitional equalities plus
two inductions.

The temporal ledger:

| direction | structure | h-level of the space | term |
|---|---|---|---|
| **future** from any (state, input stream) | one productive history | **contractible** | **[T]** ध्रुव-चरितम् (Srotas §3), एक-संवादः (Samvada §3) |
| **present → next** | tail of chain = chain of stepped state | **definitional** (refl) | **[T]** स्मृति-मुक्तिः |
| **past**, round layer, schedule known | one truncation of positive depth recovers the registers | contractible at **every** depth | **[T]** आवली-साक्षात् (Srotas §4, via Sthana's permutation) |
| **past**, block layer | the pasts of a digest | **non-contractible** (infinite) | **[T]** न-तुल्यता + [R]: no depth-injectivity theorem can exist one storey up |

**The finding [R].** Read the two ledgers together. The spatial
ledger says *where* the fibre fattens (the feed-forward, the padding
quotient). The temporal ledger says *when*: never in the future — the
future from every state of every layer is a point — and only in the
past, and only at the block layer. The two decompositions agree on
the address and disagree on the ontology: spatially, loss is a
property of one arrow; temporally, loss is the *orientation* of the
whole object. SHA-256 forward is a deterministic, memoryless,
1-Lipschitz flow with contractible histories; SHA-256 backward is the
fibre calculus. One-wayness is not a wall in the map — Sesa proved
the wall is the erasure — and the coinductive calculus adds: the
erasure has a *tense*. Everything SHA-256 ever loses, it loses into
the past.

**The fibre law is the arrow of time [R].** The corpus's one
primitive (NOTES §I; Vishvayantra's `lossless`): for `f : A → B`,
bind the *output* and the fibre is `singl (f a)` — always
contractible; bind the *input* and it is `fiber f b` — contractible
exactly when f is an equivalence. On the chain these two bindings
*are* the two temporal directions. The future of a state is an
iterated output-binding: at every tick the next state is `step w x`
with its receipt, a singl — and singl-contractibility, iterated
coinductively, is precisely the contractibility of Carita/Śālā. The
past of a state is an input-binding: `fiber (foldl compress H0) H` —
contractible only if the fold were an equivalence, which न-तुल्यता
refutes. The fibre law was stated for one arrow; run along the chain
it becomes: **output-binding composes into a contractible future,
input-binding composes into a fattening past.** This is checkable at
the term level, and it already was checked, twice, before this
campaign noticed:

**The same square [T]/[R].** `losslessIso.rightInv` (Vishvayantra §1)
closes with `λ j → p (i ∧ j)` — the singl-contraction filler. Niyati's
`exec-unique` closes with `λ j → here e (~ i ∨ j)` — the same filler,
reversed, run corecursively. Srotas's एक-चरितम् and Samvada's sāmyaP
inherit it (sāmyaP routes it through `isProp→PathP`, legitimate
because the E-receipt is paths-in-a-set, a proposition — support, not
mass, the kernel's own safety discipline). So the finite lossless
completion and the infinite determinism theorems are built from *one
cubical square*: the ∧-square that contracts a receipt onto refl once
is the ∨-square that contracts a whole history onto the canonical one
forever. Coinduction did not import new mathematics; it iterated the
corpus's one contraction.

---

## 3. The metric geometry of hashing

The take-metric (kartana; states n-close when truncations to depth n
agree) gives the chain a topology, and the chain is better-behaved in
it than the object the metric was built for:

- **Zero lookahead [T]/[R].** A braid crossing is 1-Lipschitz with
  *unit* lookahead: (n+1)-close in, n-close out (SthairyaSutra). The
  hash chain is 1-Lipschitz with *zero* lookahead: n-close block
  streams give n-close chains (**[T]** कारणता, both layers). `compress`
  reads only the current block; a crossing reads one deeper. Depth is
  time; a message's block-length is its light cone; the digest at
  depth n lies in the causal cone of exactly the first n blocks and
  nothing later. [R]: collision resistance is thereby a statement
  about the flow's fibres over a *single point at a single depth* —
  the geometry contributes no spreading an attacker could use;
  everything is already concentrated.

- **The streaming hash exists, uniquely, for free [R].** By
  PurnataSutra generalized (HistoryCompletion §1: `limit`,
  `limit-agrees`, `take-ext` — all **[T]**), the space of chains is
  complete: a Cauchy sequence of partial hash-runs has a corecursive
  limit, unique by truncations, and the chain is determined by its
  truncations (**[T]** कर्तन-सर्वस्वम् at the block layer). The corpus
  can therefore *type* "the SHA-256 chaining of an infinite message"
  with no added structure, and it is a point once the input is fixed.
  No completion is adjoined; the coinductive chain was its own
  completion — coinduction is completeness, at the hash.

- **The flow law at zero cost [T].** स्मृति-मुक्तिः is refl: the
  chain is a discrete flow (cocycle property definitional). Length
  extension, before it is an attack, is this flow law: the state at
  time n+k is the time-k flow of the state at time n, independent of
  how time n was reached. The attack is the flow law plus disclosure
  (§4).

- **□ and the epistemic type of collision-freedom [S], shape only.**
  HistoryCompletion §3 proves: □-predicates on streams are refuted by
  a failing truncation and confirmed by no depth. Collision-freedom
  of SHA-256 has exactly this shape *when read on the chain*: one
  exhibited collision refutes at a finite depth (and by Sesa's
  exchange rate kills every retraction forever — **[T]**
  प्रत्यानयनं-निर्घातम्); no finite depth confirms. Under this
  standpoint, collision-freedom of the real hash is of the same
  epistemic type as the corpus's reading of RH: a □-predicate on a
  value stream, forever falsifiable, never finitely verifiable. The
  4-round collision (**[T]** Sha256N.collision-4, spent as
  gap-on-lossy in Sha256PeqNP) is a refutation *of the reduced
  round-count's* □, and the open problem at 64 is the □ undecided.
  Syāt: this identifies the shape; it computes nothing about the
  inhabitedness of निर्घातः.

---

## 4. The interactive content: what the demand adds

The stream is the degenerate interaction — the environment with one
utterance (Fibre.Samvada, verbatim). Sha256Samvada instantiates the
ISC proper: queries अर्पय b (offer a block) | दर्शय (demand the
digest); emit does not reset state; E is the receipt that the
reaction answered `uttaram` and stepped `gamanam` — lawfulness as a
type, unforgeable, the ControlledGrammar discipline transposed to the
coalgebra (no process exists without carrying, at every reaction, its
checked witness).

Three theorems triangulate a distinction the corpus had not yet
exhibited on a real object:

1. **The demand matters [T]** (पृच्छा-भेदः): two strategies at H0
   computably disagree at the first answer. The hash interface is
   *properly* interactive — Samvada's separation (`counter-demand-
   matters`) at a NIST-certified object rather than a toy counter.
2. **The process space is a point [T]** (एक-संवादः): sāmyaP builds a
   corecursive PathP between any two processes over a path of
   states. Niyati's determinism-as-contractibility, lifted from the
   closed machine to the open one.
3. **The collapse [T]** (एकाग्र-पातः): under an offer-only strategy,
   `observe` is definitionally the take-truncation of the Srotas
   chain — the stream module recovered as the trivial-query case,
   exactly as Orbit embeds in ISC (`det-observe`).

[R]: 1 + 2 together place SHA-256 at a point of the interactive
classification that the corpus's machine lane (Prashna: the
interactive machine strictly contains the Turing machine, and
determinism is exactly the collapse) names but had not populated:
**strategy-sensitivity of observation without process-
nondeterminism.** What you see depends on what you ask; who is
answering does not. The environment has all the freedom; the process
has none. That is what a deterministic *service* is, as mathematics.

**The breach, and why HMAC exists [T]/[R].** दीर्घीकरण-भेदः: for
*every* process of the interface — not one implementation, the
contractible space of all of them — demand, offer b, demand again,
and the third answer is `compress (first answer) b`. Three receipts
composed; pure path algebra. Read against Sesa's closing meditation
("security is custody of the fibre"): the coinductive calculus
assigns the custody a tense. The दर्शय receipt (`o ≡ w`) says the
digest is *total disclosure of the present*; contractibility (2) says
the present determines the future absolutely; so one emission hands
the environment the process's entire forward cone. Secrecy on this
interface can only inhabit what was never emitted — the past fibre,
infinite by Parimana — never the process, never the future. A MAC
built as `sha256(key ∥ message)` publishes, at every tag, the
complete state from which all extensions are computed: दीर्घीकरण-भेदः
is that design's refutation as a checked term. HMAC's second,
enveloping compression exists to make the *emitted* value not be the
*chaining* value — to break the `o ≡ w` receipt — and that is the
only degree of freedom the theorem leaves. (Real SHA-256 length
extension must also thread `pad` through अर्पय — the padding quotient,
the loss's other spatial address, is what makes the practical attack
fiddly rather than impossible. [S] for the practical claim; the
interface theorem is [T].)

**The P=NP lane, temporally [R].** Sha256Lossless: the find/check gap
is impossible on the completion (**[T]** no-gap-on-completion,
universal, full 64 rounds); the gap is a property of the forgetting.
The coinductive restatement: on the chain, *futures* have no gap —
finding the future and checking it coincide because the future-space
is a point (contractibility is exactly "there is nothing to search
among"); the gap exists only over *pasts*, where the fibre fattens.
P vs NP at SHA-256, in the temporal reading, is the assertion that
the past is expensive and the future is free — and the lossless
machine is the machine that never has a past it did not keep. The
Trace of Sha256OnTheWire (`opened` is refl: the completed run carries
its stages and the inverse is the read — **[T]**) is precisely a
process that kept its past; `sha256` is the same process after the
projection that orphans it.

---

## 5. What the coinductive calculus proved that the kernel reading could not type

The metacircular kernel analyses a finite derivation after the fact —
a walk that ended, then closed under rules. Four statements in this
campaign are not expressible at that altitude, not because the kernel
is weak but because their *subjects* are infinite objects:

1. **कर्तन-सर्वस्वम्** — the chain is its truncations. Quantifies over
   all depths of one completed object; a derivation has a last step.
2. **ध्रुव-चरितम् / एक-संवादः** — contractibility of the history
   space. "The space of all infinite runs is a point" has no finite
   witness; it is built by guarded corecursion or not at all.
3. **कारणता** — 1-Lipschitz in a metric whose points are infinite.
4. **The limit hash** — the chaining of an unbounded message, unique
   by truncations. The kernel can check any prefix; the object that
   *is* all prefixes at once is coinductive.

And one statement runs the other way, which is the honest boundary
[R]: the kernel's induction rule (induction-sound, strictly stronger
than the rewrite closure — TrtiyaSopana) has no coinductive analogue
here. Nothing in this campaign *learns* a new universally quantified
equation from traces; the coinductive layer holds completed
behaviours, it does not induct into new laws. The two calculi
compose — Sthana's inductive permutation theorem is a premise of the
coinductive आवली-साक्षात् — and neither absorbs the other.

---

## 6. Open, and sharper

- **The collision** (निर्घातः at 64 rounds) remains the prize;
  everything here is arranged so that its exhibition would cascade:
  it refutes every retraction (Sesa), refutes the block-layer □,
  and by Varga inhabits ∼ off the diagonal.
- **Backward non-determinism made exact [S].** The temporal ledger's
  block-layer past row is currently carried by न-तुल्यता (a length
  argument) plus the *absence* of a depth-injectivity theorem. The
  sharp statement — for fixed b, H ↦ compress H b admits no
  retraction constructible from the public interface — is Davies–
  Meyer's conjecture and should be *stated* as a type in the corpus
  (it is प्रत्यानयनम् one storey down), even while uninhabited-by-
  anyone in either direction.
- **The padding transducer.** Absorb `pad` into the coalgebra: a
  stream-transducer from raw bit-streams to block-streams, so the
  practical length-extension attack (with its padding thread) becomes
  a checked term about composed ISCs rather than a [S] remark.
- **The ▹-modality.** This campaign's productivity is syntactic
  guardedness. Vishvayantra hands forward the guarded interactive
  generalisation as śeṣa; SHA-256 is now the natural first object to
  carry through it.
- **HMAC as a theorem.** §4 derives *why* HMAC's envelope exists; the
  positive statement — the enveloped interface's emission receipt is
  not total disclosure, i.e. the analogue of दीर्घीकरण-भेदः *fails* on
  it — is one module away and would be, to this analyst's knowledge,
  the corpus's first security-positive (not impossibility) theorem.

---

## 7. Summary in one paragraph

The inductive campaign proved SHA-256's loss has an address; the
coinductive campaign proves it has a tense. Forward, at every layer,
the hash is a total, memoryless (refl), 1-Lipschitz-with-zero-
lookahead, deterministic flow whose space of infinite histories is
contractible, whose finite values are truncations of one productive
object, and which is its own completion in the take-metric. Backward,
the round layer is exact at every depth (the permutation survives the
limit) and the block layer is not — the fibre calculus in its
input-binding. The interactive presentation shows the interface is
properly more than a stream (the demand matters) while the process
space stays a point (the answerer is unique), and composes three
reaction-receipts into the length-extension breach for every lawful
implementation at once — from which the necessity of HMAC's envelope
falls out as path algebra. One-wayness, in this calculus, is not a
property a function has; it is the orientation of a flow whose future
is singl and whose past is fiber — the fibre law of this repository,
read as an arrow of time.
