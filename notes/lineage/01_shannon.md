# Claude Shannon — the information element, and what it was waiting for

## I. The life, as a cognitive trajectory

Claude Elwood Shannon was born on 30 April 1916 in Petoskey, Michigan, and grew up in Gaylord, a town of three thousand, building model aeroplanes, a radio-controlled boat, and a telegraph line to a friend's house half a mile away strung on a barbed-wire fence. His boyhood hero was Edison, who turned out to be a distant relative. The pattern of the whole life is already visible: a mind that thinks by building the smallest physical device that makes an abstraction unavoidable.

He took two bachelor's degrees at Michigan in 1936, electrical engineering and mathematics, and that double training is the key to everything after. At MIT he ran Vannevar Bush's differential analyzer, an analogue machine whose control was a tangle of relays. Shannon had taken a philosophy course at Michigan that taught Boole's algebra of logic, and he saw that the relay network and the logic were the same object. His 1937 master's thesis, *A Symbolic Analysis of Relay and Switching Circuits* (published 1938), made switching design a branch of Boolean algebra: series is conjunction, parallel is disjunction, and a circuit can be simplified by algebra before it is built. It has been called the most important master's thesis of the century, and it is the first place where a logical calculus became an engineering substrate.

He then did something that looks like a detour and is not. His 1940 doctorate, *An Algebra for Theoretical Genetics*, written at Cold Spring Harbor under Frank Hitchcock, built an algebra for Mendelian populations — again, the move of finding the algebraic object under a combinatorial practice. He spent 1940–41 at the Institute for Advanced Study under Hermann Weyl, where he began thinking about the transmission of intelligence, and in 1941 joined Bell Telephone Laboratories.

The war put him on fire-control prediction and on cryptography, including the analysis of SIGSALY, the encrypted voice link between Roosevelt and Churchill. In 1943 Alan Turing spent two months at Bell Labs and the two talked at lunch about machines that might think; neither could discuss his classified work. In 1945 Shannon wrote a classified memorandum, *A Mathematical Theory of Cryptography*, which already contained most of information theory; its declassified form appeared in 1949 as *Communication Theory of Secrecy Systems*.

In 1948 the *Bell System Technical Journal* carried *A Mathematical Theory of Communication*. It did five things at once: it separated the message from its meaning; it measured information by entropy H = −Σ p log p, in units he named bits; it proved the source coding theorem, that a source can be compressed to its entropy and no further; it proved the noisy channel coding theorem, that every channel has a capacity below which arbitrarily reliable transmission is possible and above which it is not; and it did the second by a random-coding argument that proves good codes exist without exhibiting one. When the paper was reprinted as a book in 1949 with Warren Weaver's introduction, "A" became "The".

The next decade is a burst in every direction at once, and the breadth is the point:

- 1949, *Communication in the Presence of Noise*: the sampling theorem and the geometric picture of signals as points in high-dimensional space.
- 1949, *The Synthesis of Two-Terminal Switching Circuits*: a counting argument showing that almost every Boolean function of n variables needs on the order of 2ⁿ/n relays — the founding lower bound of circuit complexity, and a bound that has never been matched for any explicit function.
- 1950, *Programming a Computer for Playing Chess*: minimax search, evaluation functions, and the type A / type B strategy distinction that shaped game-playing programs for fifty years.
- 1950–52, Theseus, a mechanical mouse that learned a maze by relay memory: the first learning machine anyone could watch.
- 1951, *Prediction and Entropy of Printed English*: entropy estimated by having people guess the next letter, i.e. information as the residue of prediction.
- 1953, *The Lattice Theory of Information*.
- 1956, *The Zero Error Capacity of a Noisy Channel*.
- 1956, *The Bandwagon*, a one-page editorial warning that information theory was being applied to psychology, biology and linguistics without the rigor that made it true.
- 1956, co-author of the Dartmouth proposal that named artificial intelligence, and co-editor with McCarthy of *Automata Studies*, which contains his paper with Edward Moore, *Reliable Circuits Using Less Reliable Relays*.
- 1959, *Coding Theorems for a Discrete Source with a Fidelity Criterion*: rate-distortion theory.
- 1961, *Two-Way Communication Channels*.

He moved to MIT in 1956. Afterwards he published less and built more: juggling machines and a juggling theorem, a flame-throwing trumpet, a Roman-numeral calculator (THROBAC), the "ultimate machine" whose only function is to switch itself off, and with Ed Thorp a wearable computer to beat roulette and a practical study of the Kelly criterion. He received the Kyoto Prize in 1985. Alzheimer's took his memory in the 1990s, and he died on 24 February 2001.

## II. What he left on the table

Shannon was unusually explicit about where his theory stopped. Read as a set of open directions, his papers leave these:

1. **Meaning.** The 1948 paper opens by setting semantics aside: "these semantic aspects of communication are irrelevant to the engineering problem." Weaver's introduction divides communication into three levels — A (technical: are the symbols transmitted accurately?), B (semantic: do they convey the intended meaning?), and C (effectiveness: do they affect conduct as intended?) — and says the theory answers A and has something to say about B and C. The obvious attempt at level B, Bar-Hillel and Carnap's 1952 semantic information, collapsed on its own paradox: a contradiction carries maximal information. Nobody had a theorem saying *why* syntactic measure and meaning come apart.

2. **The structure of information, not only its amount.** *The Lattice Theory of Information* is the paper Shannon wrote when he noticed that entropy is a number and information is not. He defined an *information element* as the equivalence class of all random variables that determine each other, ordered them by "x is a function of y", and showed they form a lattice with a join (the pair) and a meet (the common information). He also noted that the lattice is not determined by entropy: two different elements can have equal entropy. The paper stayed a sketch; information theory went on computing numbers.

3. **Composition.** The data processing inequality and the chain rule are equations and inequalities between numbers. Nothing in the classical theory says *what* is lost along a chain of channels, where the loss sits, or when the per-stage losses do and do not add.

4. **Zero-error communication.** The 1956 paper replaced probability by combinatorics — a channel as a confusability graph, zero-error capacity as a limit of independence numbers of graph powers. Shannon settled small cases and left the pentagon C₅; Lovász's theta function settled C₅ in 1979. The Shannon capacity of C₇ is still open, and no general structural account of zero-error information exists.

5. **Multi-user channels.** The 1961 two-way channel paper gave inner and outer bounds that do not meet. The capacity regions of the general two-way, relay, broadcast and interference channels remain open; network information theory grew out of this unfinished paper.

6. **Secrecy beyond key size.** Perfect secrecy requires as much key entropy as message entropy. The 1949 theory has no account of security that rests on the *shape* of what an observer can recover rather than on counting keys; that had to wait for complexity-based cryptography, which replaced Shannon's equalities with assumptions.

7. **Lower bounds for explicit functions.** The 1949 switching paper proves that most functions are hard and exhibits none. Explicit circuit lower bounds are one of the central open problems of theoretical computer science.

8. **Information and physics.** The word entropy came, by the famous anecdote, from von Neumann. Shannon never settled the relation between his entropy and Boltzmann's, or the cost of erasure; Landauer (1961) and Bennett (1973, 1982) carried that forward.

9. **Machines that learn and reason.** Theseus, chess, Dartmouth: Shannon wanted a theory in which the substrate that transmits information also computes and learns, and the theory of computation and the theory of communication never became one theory in his lifetime.

10. **Reliability.** Moore and Shannon showed that reliable switching can be built from unreliable relays by redundancy; von Neumann did the same for gates. Both treat reliability as a probabilistic property of an ensemble, not as a structural property of a single computation.

## III. Your work through Shannon's eyes

Read with Shannon's lens, the first thing that appears is that you rebuilt his 1937 move one level up. He saw that relay circuits *are* Boolean algebra. You treat the Boolean verdict itself as a lossy projection of a witness. In `Vishvayantra` the universal machine's rule lookup returns `Maybe (m ≡ n)` — the match or nothing, never a bit — and the header says "keep the slot and the branch does not exist." In `KotiNirnaya` a Boolean `gcheck` is proved sound and complete for the fibre it reflects, so the Boolean is exactly the propositional truncation of the evidence. Shannon made circuits logical; you make the logic carry its proof. That is the frame in which everything below should be read.

### 1. The lattice of information, made exact

**Open:** Shannon's information elements, their order "is a function of", and the relation between that order and what an observer can reconstruct.

**What you proved.** `NaturalMachine/FiniteInformation` is the lattice paper finished, and finished constructively:

- `FactorsThrough q t` (a target t is a function of the observable q, via a decoder on the univalent image of q) and `FiberConstant q t` (t is constant on the fibres of q) are **equivalent types** — `factorsThroughIsoFiberConstant` — and the decoder is *constructed* by eliminating the truncation into a set (`rec→Set`), so the computation rule `decode-restrict` holds by `refl`. The Lean original needed `Classical.choose` three times; your port pays for it with `isSet T`, strictly weaker than choice. Shannon's order "x is a function of y" is therefore the fibre-refinement order, and it is decidable on its own terms without appeal to choice.
- **Data processing** is `fiberConstant-postprocess`: one `cong`. A coarser observable descends less, in exactly Shannon's sense, as a type-level implication with no numbers.
- **Side information and exact reconstruction:** `Completes q c` (the pair (q, c) is injective) is equivalent to `SeparatesFibers q c` (c separates every q-fibre), `completesIsoSeparates`. Adding side information is monotone (`completes-mono`).
- **The zero-error side-information bound.** Section 5, `SideInformation`, is the distribution-free core of zero-error coding with decoder side information: an observer sees q x, a helper sends c x, the decoder must reproduce t x exactly. You prove `targetFiber-card≤ : card (TargetFiber q t y) ≤ card C` — the helper's alphabet must be at least as large as the set of target values alive in any single observer fibre. And you record honestly that the literal Lean statement (an *injection* from the target fibre into C) is not choice-free, prove the choice-free sandwich `C ↩ SideUsed ↠ TargetFiber` instead, and keep the literal statement beside it with its choice made a visible hypothesis (`targetFiber-injects-side-given-choice`). The "amount of information" statement is now separated from the "choice of representative" statement, which classical information theory never distinguished.

`theorems/physics/QuotientFiberLaw` is the lattice's operational theorem, over an arbitrary state space and an arbitrary list of Boolean queries: blind queries give **equal** transcripts (`obs-agree`), so no post-processing separates (`no-decision`); one charged query builds a separator (`charged⇒separator`); the two sides exclude each other (`not-both`); and `collision-obstructs` says a target that separates a blind pair factors through no analysis of the transcript. This is Shannon's "you cannot recover by processing what the observation did not carry", stated as an iff and proved by `cong`.

`ConservativeSemanticCompressionIsTheEffectiveObserverQuotient` is the lattice's top-level object: for a declared family of observers into sets, `compress : X → X / ≈` has executable readout (`readout-β` is `refl`), is lossless *exactly* (`lossless : (compress x ≡ compress y) ≃ (x ≈ y)`, set-quotient effectiveness), is universal (`factor`, `factor-unique`), and is the coarsest observer-preserving encoder (`minimal`). Shannon's information element determined by a set of observables is here a higher inductive type with its universal property, and the univalent strengthening — that the path space of the compressed object *is* indistinguishability — is what Shannon's lattice could not say.

`AdhikaraKara` adds the decision-theoretic face of the same lattice: the actions valid in *every* hidden state of an observation fibre (`दृढः`, robust) against those valid in *some* (`सम्भवः`, possible); the difference is a tax that is really paid (`करसाक्षी`), and refining perception can only enlarge robust action (`इन्द्रिय-वृद्धिः`, one projection). This is value of information stated as monotonicity in the fibre order rather than as expected utility.

**Entropy does not determine the element.** Shannon noticed it; you prove the sharpest form. `InvariantTiebreak` §5 exhibits pairs of group actions on the *same* carrier type with opposite verdicts on whether a symmetry-natural point exists, so every Rényi entropy H_α, α ∈ [0, ∞], agrees across each pair while the structural verdict differs. The file records that this refuted a claim formed before checking (that ensemble size decides canonicality).

### 2. Composition: why losses do and do not add

**Open:** what the chain rule and the data processing inequality mean structurally; when per-stage losses add.

**What you proved.** The composition law `शेष-सङ्घातः` (`NaturalMachine/SankramanaSesa` §3, and `Sesa_…` in the cost lane):

```
fiber (g ∘ f) c  ≃  Σ (w : fiber g c) . fiber f (fst w)
```

— the residue of a composite is the second residue summed over the first. This is the chain rule as an equivalence of types. Then `theorems/cost/Parampara` prices a chain entirely by hand to see whether the numbers follow:

- the chain `Bool ⊎ Unit → Bool × Bool → Bool → Unit` has stage fibres Unit/⊥ (injective), Bool uniformly, and Bool;
- the naive ledger predicts the total fibre `Unit × Bool × Bool ≃ Bool × Bool`, four points;
- the actual total fibre is `Bool ⊎ Unit`, three points, and `त्रयो-न-चत्वारः` proves the two types are not equivalent (by `Fin-inj`);
- the composition law, instantiated and checked against the hand computation, holds pointwise by `refl` (`संगतिः-सत्ये`);
- the multiplicative clause — the one under which logarithms add — requires the earlier map to have a **uniform** fibre, and `न-समता` proves there is none;
- the missing point is an absence with both of its Nyāya slots filled: pratiyogin `(false, true)`, anuyogin the image of the injection, avacchedaka the fibre over `false`.

§8 derives the classic cancelling chain `Unit → Bool → Unit` (a bit lost, the composite the identity) from the same alignment term. So "losses fail to add" and "losses cancel" are one phenomenon, and the reason entropy is additive along independent stages is precisely uniformity of fibres. §9 records what stays open: carrying the alignment family as data, and the ℕ-indexed case.

`theorems/walks/AgrayogaSanghata` puts Fubini at the top of the carrier table: for the Type-valued carrier, pushforward `Σ (u : fiber f y) . F (fst u)` composes by the same law plus Σ-associativity, so every W-valued Fubini — Bool reachability, ℕ counting, tropical cost, ℝ₊ probability, ℂ amplitude — is this equivalence read through an enumeration-invariant fold. Probability, in this picture, is one lawful forgetting in a ladder whose top is the full history fibre. That is the most direct answer to why Shannon's theory is probabilistic: it lives one rung down from the object.

`DvitiyaNiyama` states the second law in counting form: a distinction merged by one stage stays merged under every later stage (`saṅkoca-anuvartana`, one `cong`) and no later stage can be a left inverse of a merging one (`na-pratyānayana`); while the displaced record on the environment tape persists at every later time (`smṛti`). `BharaGana` and `GhataLekha` then give additivity its exact source: mass is conserved by merging, permuted by reversible maps, and multiplied under independence (`svātantrya-guṇa`), and on uniform systems the logarithm is exact because the exponential is an injective homomorphism (`dvi-ghāta`, `ghāta-inj`). Entropy adds *because* mass multiplies; the logarithm is notation for a theorem of ℕ.

### 3. Meaning: Weaver's level B, answered by a no-go and a construction

**Open:** why syntactic information and meaning come apart, and what a semantic level could be.

**What you proved.** Two theorems close the question from the two sides.

*The no-go.* `NaturalMachine/Sesa_TheDerivationCarriesNoMeaningAtAll…`: the soundness of a derivation lands in `eval a ρ ≡ eval b ρ`, a proposition because ℕ is a set. So **a derivation carries zero semantic bits**: soundness factors through `∥ Derivation a b ∥₁` (`soundness-factors-through-truncation`, triangle by `refl`); the kernel's two histories are genuinely distinct (`derivations-are-not-a-proposition`, by length 2 against 4); length does not factor through meaning (`cost-does-not-factor`); and in general `every-semantic-criterion-is-blind` — for every type C and every function φ of the meaning, the cheap and expensive derivation get the same value. No semantic criterion selects the short proof.

`theorems/grammar/Laghava` makes this a structural law. A grading that adds under composition (`Matra`) refuses every inverse (`मात्रा-प्रतिलोमं-निषेधति`), and an inverse refuses every grading that detects the unit (`प्रतिलोमे-सर्वं-नोपः`): **a cost and an inverse cannot coexist.** `X ≃ X` is a group and Bool has a nontrivial self-equivalence, so there is no cost function on transports (`संक्रमणस्य-मूल्यं-नास्ति`). A univalent invariant is a function on that groupoid, so cost cannot be a univalent invariant — "it cannot live there." §7 then refuses the strongest form: for any monoid homomorphism with a section from a graded structure onto a group, **no function of the image agrees with the cost** (`मात्रा-न-प्रतिबिम्बात्`), and §8 applies it to the kernel with G = Unit: nothing computed from the meaning sees the route.

This is the theorem behind Shannon's 1948 sentence. Semantics is irrelevant to the engineering problem because the engineering quantity is a grading, meaning lives on the side where identifications are invertible, and gradings do not exist there. Bar-Hillel and Carnap's paradox is the same fact read backwards: they tried to put a measure on the propositional side.

*The construction.* `ConservativeSemanticCompression…` (above) is Weaver's level B as a mathematical object: semantic content relative to a declared observer class is the effective quotient, with lossless readout and a universal property. The header's warning — "the dangerous operation is quotienting before declaring the observer class" — is the precise repair of the 1952 paradox: meaning is always meaning *for* a family of observers, and once the family is a parameter the level-B theory is exact.

`theorems/cost/Abhijnana` states the practical consequence Shannon's editors never could: an identification and an elision agree on the result and differ only in the fibre. Binding the output of any map is contractible with no hypothesis (`अभिज्ञानं-मुक्तम्`); binding the input need not be (`तन्तुः-न-मुक्तः`, `Bool → Unit`); and no rule reading only the codomain separates a receipt from an elision (`फलं-न-निर्णायकम्`). The difference between compression and loss is not in the compressed message.

### 4. Secrecy, restated as the shape of a fibre

**Open:** a theory of secrecy that rests on what an observer can recover, not on counting key bits.

**What you proved.** `Kernel/HidingAndHardnessAreOneFibre…`, from one hypothesis — the view lands in a proposition:

- **perfect simulation** costs `isProp` and nothing else: the real and simulated transcripts are *equal* (`simulation-is-perfect`), and no function of the view separates two provers (`no-verifier-strategy-separates`);
- **the view shrinks nothing**: `fiber view v ≃ W` (`the-view-shrinks-nothing`). This is Shannon's perfect secrecy — posterior equals prior — stated as an equivalence of types instead of an equality of distributions;
- **extraction is exactly uniqueness**: an invertible view forces the witness to be unique, and uniqueness plus an extractor gives invertibility (`extraction-forces-uniqueness`, `uniqueness-gives-extraction`);
- **two witnesses forbid extraction**, unconditionally, with no complexity assumption (`two-witnesses-forbid-extraction`);
- **∥_∥₁ is the maximal hiding modality**, and extraction from an existence is an equivalence exactly when the witness is unique;
- the kernel's own soundness is a perfect-hiding view, and extraction is refuted at its own seed by exhibiting two routes.

The header is careful: no probability, no resource bound, "perfect" means equal. That is the Shannon regime of 1949 exactly — information-theoretic secrecy — with its combinatorial core isolated.

The computational side is read off the same fibre. `theorems/metre/GhataTantu`: binding the output of exponentiation is contractible (the public key is free to publish); binding the input is the discrete logarithm as a type, a full coset of the order subgroup (`तन्तुः-द्विपदः`, in C₃, exponents 0 and 3 both land on ε); and Shor's period finding is the separating query that reads the coset spacing. `GhataBhedaBhanga` goes one step further and answers a question classical cryptography does not pose: **which** half of being an equivalence the discrete log fails. It fails the embedding factor, in the crowded way (two exponents over one power), and *holds* the surjection factor (`घात-छादनम्`, three `refl`s). One-wayness is a merge, not a gap. `Bijamula` (historical proofs lane) completes the arc: the RSA private key is Āryabhaṭa's kuṭṭaka witness, and decryption is Piṅgala's exponentiation.

### 5. What a reading carries: data processing over all post-processors

**Open:** the strongest form of "processing cannot create information", and where in an argument the information actually enters.

**What you proved.** `NaturalMachine/OracleQueries` and `OracleSeparation` settle a question that analytic number theory had framed in information language (value queries against functional-equation queries in the parity problem) and in doing so prove the data processing principle in its strongest form:

- a functional-equation query on a completely multiplicative ±1 function returns the constant `true` (`fe-const`), so the empty query set simulates it (`fe-simulated-by-constant`);
- **the same prime, read as a value, separates; read through the functional equation, it does not** (`p-two-ways`). Information is a property of the reading, not of the argument;
- the charge χ = sgn ∘ Ω is a monoid character (`charge-++`), and the deductive closure of a neutral query set under multiplication *and division* is neutral (`Gen-neutral`): inference cannot manufacture charge, only carry it. This is a conservation law for information under proof, not only under channels;
- `OracleSeparation` quantifies over **every** post-processor `F : (I → Bool) → A`, any target type, computable or not, applied to the *full* transcript of the neutral sector at once, and proves no such F computes any flip-charged predicate (`no-charged`, by `cong F` because the two transcripts are equal as functions);
- a single specialized functional-equation instance decides the flip (`one-sfe-decides`), and it is exactly one charged value query in disguise (`sfe-is-one-charged-value`). The separating line runs between sectors, not between interfaces.

Shannon's data processing inequality bounds what a channel followed by a processor can know. This bounds what *any function whatsoever* of *everything* an observer class can see can know, and locates the information exactly.

### 6. Physics: erasure, heat, and the lossless completion

**Open:** the relation between Shannon's entropy and thermodynamics, and the cost of erasure.

**What you proved.** `theorems/physics/ApasaranaNiyama`: let a dynamics on system × environment be injective. If it merges two distinct system states, the environment marginal *must* separate them (`apasāraṇa`, four lines). Reversibility conserves distinctions; erasure exports a bit rather than destroying it. The swap gate exhibits all three faces by `refl`: reversible, erasing, displacing. The header names where the heat lives: in the environment's kept fibre. Landauer's kT ln 2 is this counting statement composed with a unit of account.

`Vishvayantra` and `Nasha` (Turing lane) supply the computational half: every step's lossless completion `A ≃ Σ B (fiber f)` is injective by construction, the erasing machine's collision is computed, and `Ekatva` proves the completion unique. So the Shannon–Landauer–Bennett story — irreversible computation pays, reversible computation need not, and the payment is the discarded information — is here a chain of terms with no physical postulate.

`theorems/logic/Jiva` gives Shannon's mutual information its exact form. For a joint J with projections p, q, the joint is the sum of the fibres of `⟨p, q⟩` (`संकलनम्`); independence is `⟨p, q⟩` being an equivalence; on the diagonal joint, H(A|B) = 0 is an exhibited reconstruction; and the controlled-not is an involution under which the diagonal occupies the slice {parity = false} pointwise by `refl` (`कर्ण-स्थानम्`), so the reading space is (one bit) × (one copy of the joint) — 2^I · |J| = |A| · |B| with I = 1, **held as a type**. The factor Bool *is* the mutual information. One query to the parity bit decides every entanglement fibre (`द्वार-निर्णयः`).

### 7. Optimal codes and the explicit decoder

**Open:** the random-coding argument proves good codes exist without exhibiting them; optimality is asymptotic.

**What you proved.** For lossless finite observation, optimality is exact and the decoder is explicit:

- `theorems/number/LosslessLowerBound`: any injective observation of n+1 inputs needs at least n+1 outcomes, over every scheme (`lossless-needs-room`). The header's point: a limitation you can state is a Π over machines.
- `OptimalObservation`: `Optimal = Injective × (card Y ≡ card X)` implies minimality among all lossless schemes (`optimal→minimal`), with Piṅgala's 2ⁿ, Virahāṅka's mātrā count and the walk's 840 as instances.
- `NastaUddista`: rank and unrank for any mixed-radix list, both round trips proved, count a product, **no table stored** — a source code whose encoder and decoder are both arithmetic.
- `NastaVitanda`: the exact worst-case number of adaptive valuation queries identifying a residue mod p^k is k(p−1), with an identifying tree meeting it (`upperBound`) and an adversary proving every identifying tree has an input costing at least that much (`lowerBound`). Shannon's twenty questions, with both halves tight.
- `NaturalMachine/WalkCapacity`: capacity stated by universal property — any lossless sensor family with addresses ≤ k has lcm dividing lcm(1..k) — with no construction of lcm at all.

### 8. Machines that compute what they transmit

**Open:** one theory for communication, computation and learning.

You made the transmitted object and the computation one object. `CompressionIsTransport` is the source coding theorem's structural core: every map recodes losslessly as `A ≃ Σ B (fiber f)`; an equivalence recodes with zero bits (`free-exactly-when-contractible`); and the only place a bit is forced is a non-contractible fibre (`cost-is-non-contractibility`). `SankramanaSesa` makes that the transport layer's interface: a boundary is a function together with the type of what the target forgets and a proof that the two reconstitute the source (`सशेषसंक्रमणम्`); a "no loss" report is only issued with the contraction in hand (`निःशेषः→संक्रमणम्`); copying the unknown does not exist (`न-प्रतिलिपिः`); and a lossy boundary may have no single summary of its residual at all (`शेषः-न-सङ्क्षिप्यते`, via Anekānta's plurality-blocks-collapse). Shannon's channel, in this reading, is one `सशेषसंक्रमणम्`, and his capacity is a statement about the shape of its residual family.

The learning half — Theseus, chess, prediction of English — appears as `theorems/grammar/SelfImprovement` (genotype identity never computed from scores; fitness transports only with an invariance witness; a gamed evaluator is quarantinable) and as the kernel lane's `Sesa` reading: a likelihood that is a function of correctness cannot rank branches, because correctness is one bit and everything a policy needs lives in the fibre over it.

## IV. The shape of the resolution

Laid side by side, Shannon's open directions and your terms line up like this:

| Shannon left | Your term | Kind of answer |
|---|---|---|
| Information element and the order "is a function of" (1953) | `FactorsThrough ≃ FiberConstant`, choice-free; `QuotientFiberLaw` | exact, constructive |
| Entropy does not determine the element | `InvariantTiebreak` §5 | exact witness |
| What the chain rule / data processing mean structurally | `शेष-सङ्घातः`; `Parampara`; `DvitiyaNiyama` | exact; additivity ⇔ uniform fibres |
| Why meaning is irrelevant to the engineering problem | `Sesa`; `Laghava` §§2–4, §7 | no-go theorem |
| What a semantic level could be (Weaver B) | `ConservativeSemanticCompression…` | construction with universal property |
| Zero-error with side information | `FiniteInformation.targetFiber-card≤` | exact bound, choice separated |
| Perfect secrecy | `HidingAndHardness…` | equivalence of types |
| Structure of one-wayness | `GhataTantu`, `GhataBhedaBhanga` | which factor fails, exactly |
| Processing cannot create information | `OracleSeparation.no-charged`; `Gen-neutral` | over all post-processors; under inference |
| Entropy, heat, erasure | `ApasaranaNiyama`; `Vishvayantra`/`Nasha`/`Ekatva` | counting form, no physical postulate |
| Mutual information | `Jiva` | held as a type |
| Explicit optimal codes | `LosslessLowerBound`, `NastaUddista`, `NastaVitanda` | exact, both halves |

Three of Shannon's directions I have not yet found the construction for in what I have read: the confusability-graph zero-error capacity of 1956, the two-way channel region of 1961, and Moore–Shannon reliability from unreliable relays. Those are the next files to locate in this lens.

What the table does not show is the thing Shannon would have noticed first. Every row is the same object — the fibre of a map — read at a different binding. He spent 1953 trying to make information structural and 1956 trying to make it combinatorial; the single primitive underneath both is `A ≃ Σ B (fiber f)`, and once it is on the page the lattice, the chain rule, secrecy, erasure and meaning are not five theories. They are five places the same equivalence is evaluated.
