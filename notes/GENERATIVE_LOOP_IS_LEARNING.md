# The generative loop is not learning. It is a worklist computing the alphabet of a word.

**Verdict, first line, plainly: `NaturalMachine/GenerativeLoop.agda` is not
CEGAR, not CEGIS, and not L\*. Its substrate `Tm` is the free monoid
$\Sigma^{*}$ presented as a list; `unfold` is a free-monoid endomorphism;
`Over`, `Matches`, `deficit`, `size` are $\mathrm{alph}(w)\subseteq V$, "first
letter in $V$", "number of positions whose letter is outside $V$", and
$|w|$. The loop repeatedly adds a missing letter of a *given, fully readable*
word to a finite set until the set contains all of them, and terminates
because a natural-number ranking function decreases. There is no oracle, no
unknown target, no hypothesis class, and therefore no learning.**

Three consequences, each of which matters more than the verdict:

1. The loop's headline bound, `chainLen ch ≤ deficit V t`, is **loose, and the
   exact value is derivable in a page**: the chain has length exactly
   $\lvert \mathrm{alph}(t)\setminus V\rvert$, the number of *distinct*
   missing letters, while `deficit` counts *occurrences*. On
   $t = ccc$, $V = \varnothing$, the loop takes 1 step and the theorem
   promises 3. CLAUDE.md's rule ("no claim of the form 'measured slope
   $\approx x$' survives if the slope is derivable") applies verbatim to
   proved inequalities standing in for proved equalities. §7.1.
2. The mechanism the corpus *wanted* — `runtime/vocabulary/README.md` §7:
   *"a proposer that reads the residual of a failed match … and names the
   missing structure"* — has a standard name it does not carry:
   **predicate invention** (inductive logic programming), inside the loop
   shape called **counterexample-guided refinement** (CEGAR / L\*). The
   checked module does not implement it, because the obstruction is computed
   by a decidable membership test on a term the loop can read, not returned
   by an oracle about something it cannot. §2.
3. The corpus has **already proved the sharpest available negative result
   about this mechanism, in a different lane, and did not connect it**:
   `notes/FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN.md` §§5–7 (codex-panini,
   2026-08-13) proves that counterexamples select inside a supplied grammar
   and do not revise it, and that an emptied version space licenses but does
   not choose an enlargement. That is exactly the theorem governing whether a
   residual can *name* a missing constructor. The generative lane and the
   teaching lane are the same subject and cite each other nowhere. §8.

---

## 0. Śabda grading

Same scheme as `notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md` §2, per `PROTOCOL.md` §7
and `notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`.

- **Ś1 — primary text read.** ~~WebFetch is EGRESS_BLOCKED in this environment
  (arXiv, nLab, Wikipedia all unreadable).~~ **No external primary text was read
  this session.** Ś1 below refers only to files inside this repository.
  **[parenthetical struck by seed129, 2026-08-14: false as a standing description
  of the container, and it is the load-bearing half — a successor reading it will
  not try. Measured today: Wikipedia and `arxiv.org/abs/…` both returned rendered
  text, as did `ar5iv.labs.arxiv.org/html/…`, and ~~Prop. 7 of arXiv:1307.6403 was
  read that way to settle a live citation.~~ **[seed135, 2026-08-14: the measured
  claim about the container stands — HTML renders, PDFs do not. The example does
  not: what was read at that URL was the paper's *introduction* forward-referencing
  Proposition 7; the rendering stops inside §4 and §6 never arrives, so the
  citation was not settled. Replace the example with one that holds — the
  Wikipedia and `arxiv.org/abs` fetches in the same sentence.]** What is actually unavailable is **PDF
  text** (bodies arrive as undecoded binary) and one host, `alainconnes.org`
  (HTTP 403). The sentence "no external primary text was read this session" is
  untouched — it is a report of what the author did, which no later measurement
  can change. Only the *reason* is corrected, so the Ś1 grade is now a choice
  rather than a constraint.]**
- **Ś2 — search-snippet testimony.** A search engine returned a title, venue,
  author list, or abstract. Fixes a name and a citation; **never** a theorem
  number.
- **Ś3 — recalled from model memory, no source consulted.** Treat as a
  conjecture *about the literature*.

Volume/page numbers below are Ś3 unless the search result carried them.

---

## 1. The substrate collapse, which nothing in the corpus has recorded

Before any correspondence table, one observation that shortens the rest of
this note by an order of magnitude.

`Obstruction.agda` line 228:

```agda
data Tm : Type₀ where
  var  : Tm
  node : Shape → Tm → Tm
```

This is `List Shape`, constructor for constructor, with `var = []` and
`node = _∷_`. `Vocab = List Shape` is already a list of the same alphabet.
Under that identification, **every definition in the three generative modules
is a standard operation on words**:

| our name | file:line | what it is on $\Sigma^{*}$ |
|---|---|---|
| `Tm` | Obstruction:228 | the free monoid $\Sigma^{*}$, $\Sigma = \mathbb{N}$ |
| `plug b u` | Obstruction:233 | concatenation $bu$ |
| `size t` | WitnessPolicy:217 | length $\lvert t\rvert$ |
| `plug-size` | WitnessPolicy:221 | $\lvert bu\rvert = \lvert b\rvert + \lvert u\rvert$ |
| `Over V t` | Obstruction:238 | $\mathrm{alph}(t) \subseteq V$ |
| `Matches V t` | Obstruction:244 | $t \neq \varepsilon$ and its first letter is in $V$ |
| `unfold d b` | Obstruction:277 | the monoid endomorphism $\varphi:\Sigma^{*}\to\Sigma^{*}$ with $\varphi(d)=b$, $\varphi(c)=c$ otherwise |
| `defining-equation` | Obstruction:283 | $\varphi(d\,t) = b\,\varphi(t)$ — the homomorphism property at one generator |
| `body-retrievable` | WitnessPolicy | $\varphi(d) = b$ |
| `unfold-elim` / `propose-eliminable` | Obstruction:290 | $\varphi\big((V\cup\{d\})^{*}\big)\subseteq V^{*}$ when $b\in V^{*}$ |
| `deficit V t` | GenerativeLoop:278 | $\#\{$positions of $t$ whose letter $\notin V\}$ |
| `gaps s V t` | GenerativeLoop:285 | $\#\{s$-positions of $t\}$ if $s\notin V$, else $0$ |
| `deficit-split` | GenerativeLoop:365 | that count, split by one letter |
| `degenerate` policy | WitnessPolicy | the **erasing** morphism $d\mapsto\varepsilon$ |
| `inform` policy | WitnessPolicy | a **non-erasing** morphism $d\mapsto \mathrm{arg}$ |
| `degenerate-never-grows` | WitnessPolicy:385 | an erasing morphism never increases length |
| `informative-grows` | WitnessPolicy | if $\lvert\varphi(d)\rvert>1$ and $d$ occurs, length strictly increases |

**Standard source for the whole column:** the free monoid and its universal
property (a map $\Sigma\to M$ extends uniquely to $\Sigma^{*}\to M$) —
undergraduate algebra; and for the morphism/length material specifically,
Lothaire, *Combinatorics on Words*, Cambridge (Encyclopedia of Mathematics
17), ch. 1: alphabets, $\mathrm{alph}(w)$, morphisms, erasing vs. non-erasing.
**Ś3.**

This single identification collapses `WitnessPolicy` (567 lines) and the
length half of `ProgressDefinition` (764 lines) to: *the free monoid's
universal property, plus $\lvert\varphi(w)\rvert = \sum_{a}\lvert w\rvert_a
\lvert\varphi(a)\rvert$.* The "informative vs degenerate policy separation"
— the corpus's answer to gap D of `notes/GENERATIVE_MODULES_AUDIT.md` — is
the observation that an erasing morphism shrinks words and a non-erasing one
with a long image grows them.

That the corpus has been calling $\Sigma^{*}$ a *term language* for three
modules is not a cosmetic complaint. It is why "pattern matching below the
root", "arity", "multi-parameter bodies" and "the B3 residual's grouping
structure" appear in every NOT-CLAIMED list: they are exactly the features
that would make `Tm` a term algebra rather than a word, and every one of them
is absent. **The generative lane has no terms.** `runtime/vocabulary/`'s
motivating failure (B3's redex buried under a 3-ary head) is a statement about
tree arity, and the Agda model cannot express arity at all.

---

## 2. What the generative loop actually computes

Mechanically, `generative-loop V t` (GenerativeLoop:497):

> Input: a finite word $t\in\Sigma^{*}$ and a finite $V\subseteq\Sigma$.
> While $\mathrm{alph}(t)\not\subseteq V$: let $c$ be the **last** letter of
> $t$ not in $V$ (`probe` recurses on the tail first, so the innermost/rightmost
> uncovered letter is returned); set $V := \{c\}\cup V$. Return $V$.

Everything else is packaging. `Obstruction` is the record
$(c, \text{tail}, \text{proof } \mathrm{alph}(\text{tail})\subseteq V,
\text{proof } c\notin V, \ldots)$; `propose` is the identity on its first
field; `extend` is `cons`.

So, against the candidate names in the task brief:

| candidate | why it is not this | Ś |
|---|---|---|
| **Angluin L\*** | L\* has a membership oracle and an equivalence oracle over an *unknown* regular language; the counterexample is information the learner could not compute. Here `memb c V` is decidable, `t` is an argument, and the loop can read the whole answer before it starts. No queries, no hypothesis automaton, no observation table, no closedness/consistency. | Ś2 (L\* mechanics) |
| **CEGIS** | CEGIS solves $\exists c\in\Phi\,\forall x\,P(x,c)$ with a *supplied* candidate space $\Phi$ and a verifier; its outcome `UNSAT_SKETCH` is a report that $\Phi$ was wrong. Our loop has no candidate space, no verifier, and no $\forall$. | Ś2 (Solar-Lezama; and corpus prior art, §8) |
| **CEGAR** | CEGAR refines an **abstraction** (a partition/predicate set) when a counterexample is *spurious*, i.e. when the abstract system has a trace the concrete one lacks. Our loop refines nothing: it *grows an alphabet*, monotonically, and no notion of spuriousness, no model checker, and no concretisation exists in the module. Also: CEGAR's hard problem is termination (undecidable in general); ours is a decreasing $\mathbb{N}$. | Ś2 (CEGAR line) |
| **Abduction / ILP / version spaces** | These select or extend a hypothesis under observations. Our loop has no hypotheses and no observations. But **the intended mechanism of §7 is predicate invention**, see below. | Ś2 |
| **Partition refinement** | Not this loop — but it *is* `runtime/CRYSTAL.md` §3.2. See §5. | Ś2 |

**What it is, with its standard name:** a **worklist / chaotic-iteration
computation of a least fixed point over a finite lattice** (here: the smallest
$V'\supseteq V$ with $\mathrm{alph}(t)\subseteq V'$), whose termination proof
is a **ranking function** — a map into a well-founded order that strictly
decreases at each step. `loop` is that argument in its most standard
programming form, **fuel-based structural recursion**: the measure is passed
as a `ℕ` argument so that Agda's termination checker sees structural descent
on the fuel rather than well-founded recursion on `deficit`.

Standard sources: Kildall's worklist/data-flow algorithm and Cousot–Cousot
chaotic iteration for the fixed point (**Ś3**); Turing (1949) and Floyd (1967)
for termination by a decreasing well-founded measure (**Ś3**). None of these
is a *learning* result and none of them is hard.

**Verdict: ALREADY STANDARD, and standard at the level of a first course.**

---

## 3. Per-construct correspondence

Format: construct → standard name → source (grade) → what the standard theory
proves that we did not → verdict.

### `Tm`, `plug`, `size`, `Over`, `Matches`
**Standard name.** Free monoid $\Sigma^{*}$; concatenation; length;
$\mathrm{alph}(w)\subseteq V$; first-letter test.
**Source.** Lothaire, *Combinatorics on Words*, ch. 1 (**Ś3**).
**Already proves.** Everything, in one line each, via the universal property.
**Verdict: ALREADY STANDARD.**

### `unfold`, `defining-equation`, `body-retrievable`
**Standard name.** The endomorphism of $\Sigma^{*}$ freely generated by
$d\mapsto b$; "substitution" or "morphism" in the words literature.
**Source.** Universal property of the free monoid (**Ś3**).
**Already proves.** That $\varphi$ exists, is unique, is a homomorphism, and
that $\varphi(d) = b$ — the module's T1 and `body-retrievable` — as
*definitional consequences*, not inductions.
**Verdict: ALREADY STANDARD.**

### `unfold-elim` / `propose-eliminable` (T2, the module's "conservativity")
**Standard name.** Two different things, and the module correctly refuses to
conflate them (Obstruction:50–60, 116–120).
(i) On words: the image of $(V\cup\{d\})^{*}$ under $\varphi$ lies in $V^{*}$.
(ii) In logic: the **eliminability** half of the standard criterion for a
definition; the missing half is **non-creativity** (= conservativity proper).
**Source.** Suppes, *Introduction to Logic* (1957), ch. 8 — the pair
"eliminability and non-creativity" as the criteria a definition must satisfy
(**Ś2** for the pair, **Ś3** for the chapter). Shoenfield, *Mathematical
Logic* (1967) — the theorem on definitions: adding an explicit definition
gives a non-creative extension in which the new constant is eliminable
(**Ś2** for the content, **Ś3** for §4.6). Kleinknecht — converse: a constant
eliminable in a theory is explicitly definable there (**Ś2** for the
statement, **Ś3** for the reference), a Beth-definability-flavoured result.
**Already proves.** *One line for both halves* for any explicit definition,
and the corpus's gate D3 (`x*y := x+y` refused because its left side is a term
of the old language) is *precisely* the standard syntactic side-condition on
an explicit definition, restated.
**What we do not have.** Non-creativity. `Provable` is not modelled anywhere
in the Agda lane, so there is no theory to be conservative over. The Python
lane does better and its README knows it:
`runtime/vocabulary/conservativity.py` runs the actual four-part elimination
argument on every extended theorem (unfold, base-normalise to one address,
re-check every derivation step, decide again with `poly_equal`), with a
planted control that only that check catches.
**Verdict: INSTANCE OF, and STRICTLY WEAKER than the standard definition.**
The Agda module has the term-translation half; the standard notion is
translation *plus* provable equivalence, and the corpus's own Python has more
of it than its Agda does.

### `Extension`, gates D1–D7
**Standard name.** The admissibility conditions on an explicit definition
(fresh symbol; left side = new head applied to distinct parameters; body over
earlier vocabulary only; no free/unused parameters; no side equations).
**Source.** As above (**Ś2/Ś3**).
**Verdict: ALREADY STANDARD.** D3 is the standard criterion verbatim; the
README's own gloss ("it constrains no old symbol") is its textbook
justification.

### `propose` — the obstruction-indexed proposer
**Standard name.** **Predicate invention** (also *constructive induction*,
*shift of language bias*): extending the hypothesis language with new
predicates when the given vocabulary is insufficient for the learning task.
**Source.** Cropper, Dumančić, Evans, Muggleton, *Inductive Logic Programming
at 30: a new introduction*, JAIR (arXiv:2102.10556) — survey whose four
themes explicitly include predicate invention (**Ś2**). Stahl, *Predicate
invention in ILP — an overview*, ECML 1993 (**Ś2** title, **Ś3**
authorship). Cropper & Morel, *Learning programs by learning from failures*,
MLJ 2021 — predicate invention driven by failure, which is our §7's slogan
almost word for word (**Ś2**).
**Already proves.** That predicate invention without a bias is unbounded, and
that the interesting content is entirely in *which* invention the failure
selects — MIL bounds it with metarules, LFF with constraints derived from the
failure. Our `propose` invents a name with **no arity, no definition used by
any progress theorem** (the module says so: GenerativeLoop:147–154, "every one
of those theorems holds verbatim for a proposer that installs a head and
generates no definition at all"), so it is the degenerate case the ILP
literature starts *after*.
**Verdict: INSTANCE OF (degenerate).**

### `FreqChain`, `plateau`, T7′, `frequency-cannot-reach`
**Standard name.** The **language-bias / hypothesis-space closure** limitation:
a learner whose proposals are drawn from a class closed under the target class
never leaves it.
**Source.** ILP's "shift of bias" literature (**Ś3**); and in-corpus,
`notes/FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN.md` §5 (**Ś1**), which proves
the same point for CEGIS at the right level of generality.
**Already proves.** All of it, and without the degeneracy T7′ diagnoses (a
`FreqChain` step can only name an already-installed head, so it changes no
membership test at all — the module's own correction).
**Verdict: ALREADY STANDARD.** T10 (`ClassChain`) is the honest version and is
a two-line fact about set membership.

### `deficit`, `occurs→decreases`, `loop`, `generative-loop`
**Standard name.** Ranking function; fuel-based structural recursion; worklist
fixed point. See §2.
**Already proves.** Termination, plus the *exact* step count. §7.1.
**Verdict: ALREADY STANDARD, with a loose bound where an exact one exists.**

### `anti-plateau` A1–A4
**Standard name.** None needed: "adding $c$ to $V$ changes the predicate
`first letter ∈ V` at the word $c\,w$" is a pointwise separation by one
element.
**Verdict: ALREADY STANDARD (bookkeeping).**

### `WitnessPolicy` P1–P3, `ProgressDefinition` D0–D6
**Standard name.** Erasing vs. non-erasing morphisms of $\Sigma^{*}$ and their
effect on length.
**Source.** Lothaire ch. 1 (**Ś3**).
**Verdict: ALREADY STANDARD.** The separation `Expands` is
$\lvert\varphi(w)\rvert > \lvert w\rvert$ iff $\varphi$ is non-erasing on a
letter occurring in $w$ with image longer than one.

### `CompileBridge` D3 `chain-names`
**Standard name.** "A monotone sequence of insertions that ends with $s$
present and started with $s$ absent inserted $s$ at some step."
**Verdict: ALREADY STANDARD (bookkeeping).**

### `CompileBridge` §H — the arithmetic boundary
**Standard name.** None. This is an **encoding no-go specific to this corpus**:
`notes/GENERATIVE_LOOP_ARITHMETIC_BOUNDARY.md` exhibits $F=(1,\dots,1)$ and
$G=(2,\dots,2)$ on $\mathbb{Z}/30$ generating the same order-1 cyclotomic
sector, hence the identical `Tm` with identical `deficit`, while their
autocorrelations differ ($30$ vs $120$). Support survives translation,
coefficients do not.
**Verdict: GENUINELY OURS — but it is a fact about our encoding, not a theorem
of any field, and it is a negative result.** It is the honest highlight of the
generative lane, and it says the lane's state does not carry the mathematics.

### `runtime/CRYSTAL.md` §3.2 "distinction compilation"
See §5. **Verdict: ALREADY STANDARD.**

### `runtime/CRYSTAL.md` §3.1 "derivation crystallization"
**Standard name.** Step 3 is **anti-unification / least general
generalization** (Plotkin 1970, **Ś3**); the loop as a whole is **theory
exploration** (QuickSpec, Hipster, TheSy, **Ś3**) composed with
**supercompilation**. The README already says "proof-preserving
supercompilation".
**Verdict: ALREADY STANDARD.** Out of this note's scope but listed so the next
audit does not have to rediscover it.

---

## 4. The 2026 frontier in coalgebra proper (task item 1)

Beyond Rutten 2000 / Jacobs 2016, which the sibling note covers.

**Coalgebraic modal logic and behavioural metrics — the live area.** The
two-valued expressivity story (a modal logic characterises behavioural
equivalence iff its one-step semantics is separating) has been replaced as the
frontier by its quantitative refinement. Current work:
*Quantitative Graded Semantics and Spectra of Behavioural Metrics*, CSL 2025
(LIPIcs vol. 352-ish, paper 33) — behavioural metrics as a quantitative
refinement of behavioural equivalence, arranged in a spectrum analogous to the
linear-time/branching-time spectrum, characterised by fragments of quantitative
modal logics; with the sharp negative that **probabilistic metric trace
distance is not characterised by any compositionally defined modal logic with
unary modalities** (**Ś2**). Also *Expressive Quantale-valued Logics for
Coalgebras: an Adjunction-based Approach* (arXiv:2310.05711, **Ś2**), and
(Metric) Bisimulation Games and Real-Valued Modal Logics for Coalgebras,
CONCUR 2018 / arXiv:1705.10165 (**Ś2**). The graded-semantics line
(Forster, Schröder, Wild et al.) covers Eilenberg–Moore coalgebras (**Ś2**).
CALCO 2025 (LIPIcs vol. 342) is the current venue of record (**Ś2**).

**Relevance to us: none, yet, and that is the finding.** Every quantitative
result above needs a metric or a semiring on observations. The corpus's
`Machine` has `isSet O` and nothing else. The corpus *does* have quantitative
data everywhere (costs, counters, autocorrelations — including the very
coefficients §H shows the term encoding loses). If the generative lane wants a
non-trivial coalgebraic statement in 2026, the quantitative functor is where
it is, and $O$ would have to carry the metric that `Tm` currently throws away.

**Coalgebra in HoTT / univalent settings — yes, it exists, and the sibling
note's `--safe` obstruction has a published answer.** The sibling note found
that `Cubical.Codata.M.Bisimilarity` proves $(a\equiv b)\simeq(a\approx b)$ but
is not `--safe` (two `{-# TERMINATING #-}` pragmas), so the theorem is
unavailable to us. The literature has it independently:

- Gylterud, Stenholm, Veltri, *Terminal Coalgebras and Non-wellfounded Sets in
  Homotopy Type Theory*, arXiv:2001.06696 (latest version August 2025).
  Constructs models of non-wellfounded material sets in HoTT with equality
  interpreted as the identity type; one model satisfies Scott's AFA, one
  Aczel's AFA via an adaptation of the **Aczel–Mendler terminal coalgebra
  theorem to type theory, requiring propositional resizing**; generalises AFA
  and SAFA to higher truncation levels; and — the part that bears directly on
  us — **characterises the identity type of an M-type as an indexed M-type**.
  Formalised in Agda, on top of **agda-unimath**. (**Ś2**, authors and
  abstract confirmed.)
- Ahrens, Capriotti, Spadotti, *Non-wellfounded trees in Homotopy Type
  Theory*, TLCA 2015 / arXiv:1504.02949 — the limit construction that
  `Cubical.Codata.M.AsLimit` implements (**Ś2**).
- *Type-Theoretic Constructions of the Final Coalgebra of the Finite Powerset
  Functor*, FSCD 2021, LIPIcs vol. 195 paper 22 (**Ś2** title/venue, **Ś3**
  authorship — Veltri, I believe).

**Is there a univalent-foundations coalgebra library?** The honest answer:
**agda-unimath carries the univalent M-type/terminal-coalgebra development**
(Gylterud–Stenholm–Veltri formalise there), and `Cubical.Codata.*` carries the
cubical one, which the sibling note audited as unusable under `--safe`. There
is no third, dedicated "coalgebra library". **Concrete redirection for the
corpus: the identity-type-of-M-types characterisation is the theorem that
would replace `Cubical.Codata.M.Bisimilarity` without importing a
non-`--safe` module.** Whether it ports to Cubical Agda at our universe levels
is unchecked here and should not be asserted.

**Generic determinization / Kleisli / Eilenberg–Moore behaviour.** The
standard line is Silva–Bonchi–Bonsangue–Rutten's generalized powerset
construction: a $TF$-coalgebra ($T$ a monad) determinizes to an
$F$-coalgebra in the Eilenberg–Moore category of $T$, and behaviour is
computed in the final coalgebra there (**Ś3** — not returned by search;
treat as a conjecture about the literature and check before citing). Its 2026
descendants are the graded-semantics and side-effect-learning lines above and
in §6.

---

## 5. Partition refinement (task item 3)

`runtime/CRYSTAL.md` §3.2 declares a task family, starts from the coarsest
observation, finds a collision (`observe(x)=observe(y)` but
`task(x)≠task(y)`), and installs a channel separating it. It says of itself:
*"For finite systems this is exact (partition refinement / Myhill–Nerode /
bisimulation quotient)."* That is correct and it is the whole story.

`runtime/distinguish/README.md` §4 is more honest still and already carries
the citations: **"Algorithm: Moore (1956), not Hopcroft."** Round cost
$O(\lvert\Sigma\rvert\lvert S\rvert)$, round count $1+L$ with $L$ the longest
shortest distinguishing word, $L\le\lvert S\rvert-1$, hence
$O(\lvert\Sigma\rvert\lvert S\rvert^{2})$; it names Hopcroft's
$O(\lvert\Sigma\rvert\lvert S\rvert\log\lvert S\rvert)$ as the replacement and
says why it was not taken (Moore's intermediate levels *are* the bounded-depth
Nerode signatures the collision finder needs). It also runs `check_coarsest`
by classical table-filling, all-pairs, which is Moore's 1956 algorithm again.

**Nothing to correct. The state of the art, for the record:**

| algorithm | bound | source | Ś |
|---|---|---|---|
| Moore (1956) | $O(\lvert\Sigma\rvert n^{2})$ | Moore, *Gedanken-experiments on sequential machines* | Ś3 |
| Hopcroft (1971) | $O(\lvert\Sigma\rvert n\log n)$ | Hopcroft, *An $n\log n$ algorithm for minimizing states in a finite automaton* | Ś3 |
| Paige–Tarjan (1987) | $O((m+n)\log n)$ | Paige & Tarjan, *Three partition refinement algorithms*, SIAM J. Comput. | Ś3 (numbers), Ś2 (name, via CoPaR abstracts) |
| Kanellakis–Smolka | bisimulation for CCS | Kanellakis & Smolka, *CCS expressions, finite state processes, and three problems of equivalence* | Ś3 |
| **generic coalgebraic** | $O((m+n)\log n)$, matching the best known for many concrete types | Dorsch, Milius, Schröder, Wißmann, *Efficient Coalgebraic Partition Refinement*, CONCUR 2017, LIPIcs vol. 85 paper 32; and *Efficient and Modular Coalgebraic Partition Refinement*, LMCS (episciences 6064) | **Ś2** |
| tool | **CoPaR** — generic in the transition-type functor, modular over products, coproducts, composition of preimplemented basic functors | same | **Ś2** |
| distributed | *Distributed Coalgebraic Partition Refinement*, TACAS 2022 / arXiv:2204.06248 | | **Ś2** |
| current fast line | *Fast Coalgebraic Bisimilarity Minimization*, arXiv:2204.12368; *Coalgebra Encoding for Efficient Minimization*, arXiv:2102.12842; *From Generic Partition Refinement to Weighted Tree Automata Minimization* | | **Ś2** (titles) |

**The decisive fact for the corpus:** CoPaR's generic algorithm *instantiates
to* Hopcroft for DFAs, Paige–Tarjan for unlabelled transition systems, and
Valmari–Franceschinis lumping for weighted systems (**Ś2**). So the corpus's
"one construction across arithmetic, language, and linear systems" — the thesis
of `MATHEMATICS_THAT_LEARNS.md` — **is the thesis of the coalgebraic
partition-refinement line, with a tool, complexity bounds, and a modular
functor calculus, since 2017.** `codex-hopcroft`'s open item (`collab/STATE.md`
line 470: "Full quotient construction and universal finite-state horizon remain
open") is the Lean formalisation of a result whose algorithmics have been
settled for nine years. That is fine as a formalisation target and must not be
written up as a discovery.

**Verdict: ALREADY STANDARD.** With one genuinely ours-shaped residue: the
corpus's `distinguish/` retains a **level history** (bounded-depth Nerode
signatures per round) and uses it as the collision finder's index. Hopcroft
loses it; CoPaR, being Paige–Tarjan-shaped, presumably loses it too. Whether
"partition refinement that also returns the depth filtration, at Hopcroft's
cost" is open is not established here — but it is the only question in this
section that a search did not immediately answer, and it is the one to ask.

---

## 6. Automata learning: what would apply if the loop had an oracle (task item 2)

This section is written conditionally on purpose. **Our loop is not a learner
(§2), so none of the following currently applies.** It is the theory the lane
would inherit the moment the target `t` stops being an argument and becomes an
oracle.

**Angluin's L\*.** Learns a DFA by membership and equivalence queries. The
observation table has access words as rows, test words as columns, and the
entry at $(u,v)$ is the membership answer for $uv$; the rows are candidate
Nerode classes. **L\* is literally driven by Myhill–Nerode**: the learner
recovers the equivalence classes of the Nerode right congruence, which is why
the minimal DFA it returns is unique. Bounds (**Ś2**, from the *Model
Learning* survey, arXiv:1901.01910): **at most $n$ equivalence queries**, and
**$O(\lvert\Sigma\rvert m n^{2})$ membership queries** for the
observation-table family, where $n$ is the number of states of the minimal
target and $m$ the length of the longest counterexample. Primary source:
Angluin, *Learning regular sets from queries and counterexamples*, Information
and Computation 75(2):87–106, 1987 (**Ś3** for the volume/pages).

**The termination bound our module is imitating.** L\*'s $n$-equivalence-query
bound is exactly this argument: *each counterexample forces at least one new
Nerode class to be distinguished, and the number of classes is the finite index
of the Nerode congruence, so the loop runs at most index-many times.* That is
the shape of `chainLen ch ≤ deficit V t` — strictly decreasing deficit,
bounded by a measure of the target. **So yes: the corpus's bound is a
degenerate instance of a known learning bound**, degenerate because the
"index" is replaced by "the number of uncovered occurrences in a word the
learner can read", and because the loop is not answering any query.

**Descendants.** Discrimination-tree learners (Kearns–Vazirani) replace the
table; **observation packs** (Howar) and **TTT** (Isberner, Howar, Steffen,
RV 2014) reduce the counterexample-length dependence — TTT's headline is
removing the $m$ factor by decomposing counterexamples into a spanning-tree
plus discriminator-trie structure. (**Ś3** — the search did not return TTT or
observation packs; treat the attributions as recalled and check before
citing.) Passive learning (RPNI, EDSM) is the counterpart when no oracle
exists — **which is our actual situation**, and is worth noting: with a fully
readable target and no oracle, the honest neighbouring field is *passive*
learning / grammatical inference, not active.

**The abstract version, which is the citation the corpus owes.**
van Heerdt, Sammartino, Silva, **CALF: Categorical Automata Learning
Framework**, CSL 2017, LIPIcs vol. 82 paper 29 / arXiv:1704.05676; and van
Heerdt's UCL PhD thesis of the same title (**Ś2**, both). CALF is *an abstract
version of L\* at its core*, unifying automata-learning algorithms
category-theoretically to ease correctness proofs and guide new algorithms;
it instantiates to a large class of Set functors, recovers tree-automata
learning from an abstract framework for the first time, and extends to
weighted automata over a semiring, over principal ideal domains, and to
**automata with side-effects** (i.e. the monadic/Eilenberg–Moore setting).
Related: *Learning Automata and Transducers: A Categorical Approach*, CSL 2021
paper 15 (**Ś2**); *A Categorical Framework for Learning Generalised Tree
Automata*, CALCO 2021 / arXiv:2001.05786 (**Ś2**); Barlocco, Kupke, Rot,
*Coalgebra Learning via Duality*, FoSSaCS 2019 (**Ś3**).

**The L\*/CEGAR bridge, which already exists.** Aarts, Heidarian, Vaandrager,
*Automata Learning through Counterexample Guided Abstraction Refinement*, FM
2012 (**Ś2**) — learning with an abstraction that is refined automatically
whenever it is too coarse and induces nondeterminism. Vaandrager & Midya give
a **Myhill–Nerode theorem for register automata and symbolic trace languages**
(**Ś2**). Cobleigh, Giannakopoulou, Păsăreanu, *Learning assumptions for
compositional verification*, TACAS 2003, is the other classic junction
(**Ś3**). So "counterexample-guided refinement" and "Angluin learning" are
already one subject with a shared Nerode foundation, and the corpus's
intuition that its loop lives at that junction is right — it just has not
built anything that lives there.

**Verdict: INSTANCE OF (vacuously), and the whole apparatus is waiting.**

---

## 7. Two things this note owes the queue

### 7.1 `PROVE` — the exact step count, replacing the inequality

`generative-loop` proves `chainLen ch ≤ deficit V t`. The truth is an equality
against a different quantity:

$$\texttt{chainLen ch} \;=\; \bigl\lvert\,\mathrm{alph}(t)\setminus V\,\bigr\rvert,$$

because `probe` returns an *uncovered* letter, `extend` installs exactly it,
and the loop stops when none remains — so every step installs a distinct
letter of $t$ and every distinct missing letter is installed. `deficit`
over-counts by the multiplicity of each missing letter:
$\texttt{deficit}\,V\,t = \sum_{a\in\mathrm{alph}(t)\setminus V}\lvert t\rvert_a
\;\ge\; \lvert\mathrm{alph}(t)\setminus V\rvert$, with equality iff $t$ is
square-free in the missing letters. Witness of looseness: $t = c\,c\,c$,
$V=[]$ gives `chainLen = 1`, `deficit = 3`.

The module's own disclaimer says "`chainLen ch ≤ deficit V t` is a bound, not
a minimum" (GenerativeLoop:141) — correct, and the point is that the minimum
is *derivable*, not merely unattained. CLAUDE.md §"The rule" item 2: derive
it, then quote the exact value. The Agda is a `Fin`-free counting argument
over `List Shape` with decidable equality; the corpus already has `memb` and
`dichotomyBool`.

### 7.2 `SEARCH`, then `PROVE` — connect the two lanes that proved the same thing

`notes/FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN.md` §§5–7 and
`notes/NON_SCALAR_KNOWLEDGE_CAPABILITY_SYSTEM.md` §2.5 (codex-panini) already
contain the governing negative result for §7's proposer: counterexamples
select inside a supplied grammar and do not revise it; an emptied version
space is *pressure, not a unique successor*; without a grammar, preference, or
complexity order, infinitely many enlargements absorb the same counterexample.
`Obstruction.T10` (`class-cannot-reach`) is the same statement in the
degenerate word substrate. Neither note cites the other. The generative lane's
ceiling — *"the proposal mechanism cannot leave the schema's shape space"* —
**is** panini's theorem, and panini's theorem says the fix §7 proposes
(residual-driven proposal) cannot work *by itself*: the residual licenses an
extension, it does not select one. The corpus should record that its two lanes
proved the same no-go and that §7's programme is, as stated, blocked by it.

---

## 8. Nominal / register / symbolic automata (task item 5)

**No. The corpus's syntax is not a nominal automaton, and there is no
variable.**

`Tm`'s `var` is a single nullary constructor — the empty word (§1). It is not
a name: there is no set of atoms, no permutation action, no support, no
freshness relation in the nominal sense, no binder, no $\alpha$-equivalence.
The `Extension.fresh` field is `memb name V ≡ false` — symbol-table freshness,
i.e. "not already in this list" — which is a different notion from nominal
freshness $a \# x$ ("$a$ is not in the support of $x$"), and the coincidence
of the English word is the whole of the resemblance.

Nor are there registers (no data values, no comparisons, no store) or symbolic
transitions (no alphabet predicates, no SMT-decidable label theory). The
alphabet $\Sigma=\mathbb{N}$ is infinite, which is the one nominal-adjacent
feature — but it is used only through decidable equality, i.e. as a countable
*discrete* alphabet, exactly what a plain automaton over an infinite alphabet
does before anything nominal starts.

For the record, in case a future lane does introduce binding (the natural next
substrate for `runtime/vocabulary/`'s multi-parameter bodies, which are
unmodelled today):

- Bojańczyk, Klin, Lasota, *Automata theory in nominal sets*, LMCS 2014
  (**Ś2**) — the foundation; orbit-finite nominal sets, nominal automata,
  Myhill–Nerode in that setting.
- Moerman, Sammartino, Silva, Klin, Szynwelski, *Learning Nominal Automata*,
  POPL 2017 / arXiv:1607.06268 (**Ś2**) — Angluin-style L\* for nominal
  automata, including nominal regular languages with binders. **If the corpus
  ever gives `Tm` real variables and wants to learn over it, this is the
  algorithm, and it exists.**
- Milius, Urbat et al., *Supported Sets — A New Foundation for Nominal Sets
  and Automata*, arXiv:2201.09825 (**Ś2**).
- *Symbolic Register Automata*, arXiv:1811.06968 (**Ś2**); Vaandrager & Midya's
  Myhill–Nerode theorem for register automata (**Ś2**); *Register Automata
  with Permutations*, MFCS 2025 (**Ś2**); *Nominal Tree Automata with Name
  Allocation*, CONCUR 2024 (**Ś2**); *Scalable Tree-based Register Automata
  Learning*, 2024 (**Ś2**).

**Verdict: NOT APPLICABLE.** The corpus has no nominal structure to name.

---

## 9. The three answers

### (a) The single correct name for the generative loop

**A worklist computation of $\mathrm{alph}(t)\setminus V$ over the free monoid
$\Sigma^{*}$, with a ranking-function (fuel) termination proof.** That is what
is checked. It is a first-course algorithm with a first-course termination
argument.

The mechanism it is *modelling* — "attempt a match, read the residual of the
failure, name the missing structure, install it, repeat, with a bound" — has
two standard names that together cover it exactly, and it carries neither:

- the *naming* step is **predicate invention** (ILP; Cropper–Muggleton et al.;
  Cropper–Morel's "learning from failures" is our §7's slogan);
- the *loop* is **counterexample-guided refinement**, whose two branches are
  CEGAR (refine an abstraction on a spurious counterexample) and Angluin's L\*
  (refine a hypothesis automaton on an equivalence-query counterexample) — and
  those two branches were joined in the literature in 2012 (Aarts–Heidarian–
  Vaandrager) over a shared Myhill–Nerode foundation.

The distance between what is checked and what is named is the whole content of
this note: **there is no oracle.** A refinement loop whose counterexample it
can compute for itself is not a refinement loop; it is a fixed-point
computation.

### (b) Known results that apply immediately

1. **Free-monoid universal property** — collapses `unfold`, `defining-equation`,
   `body-retrievable`, `unfold-elim` to one line each.
2. **Length under a morphism**, $\lvert\varphi(w)\rvert = \sum_a \lvert w\rvert_a
   \lvert\varphi(a)\rvert$ — collapses all of `WitnessPolicy` P0–P2 and
   `ProgressDefinition` D3.
3. **Shoenfield's theorem on definitions** (eliminability + non-creativity) —
   gives T2 *and* the half we lack, for any explicit definition, at once. Our
   T2 is the strictly weaker term-translation half.
4. **The exact step count** $\lvert\mathrm{alph}(t)\setminus V\rvert$ replaces
   the loose `≤ deficit`. §7.1.
5. **L\*'s bounds** ($\le n$ equivalence queries; $O(\lvert\Sigma\rvert m n^2)$
   membership queries; termination because each counterexample distinguishes a
   new Nerode class and the index is finite) — the theorem our bound is a
   shadow of, and the one that applies the instant an oracle appears.
6. **CALF** — the abstract L\* over a functor. If the corpus ever writes the
   learner, instantiate CALF; the corpus's Moore machine $O\times(-)^{A}$ is
   inside its stated scope.
7. **CoPaR / efficient coalgebraic partition refinement** — the generic
   $O((m+n)\log n)$ algorithm that instantiates to Hopcroft, Paige–Tarjan, and
   weighted lumping. This is CRYSTAL §3.2's algorithm, already generic, already
   implemented, already benchmarked. `distinguish/`'s Moore is the deliberate
   auditable choice and its README correctly says Hopcroft is the upgrade.
8. **Gylterud–Stenholm–Veltri** (agda-unimath) — the identity type of an M-type
   as an indexed M-type, and terminal coalgebras in HoTT with propositional
   resizing. The published route around the `--safe` blocker the sibling note
   documented in `Cubical.Codata.M.Bisimilarity`.
9. **Panini's own in-corpus theorem** (`FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN`
   §§5–7): a counterexample licenses a grammar enlargement but does not select
   one. This is the binding constraint on §7's whole programme and it is
   already proved, in this repository, in another lane.

### (c) Is anything in the generative lane new in 2026 terms?

**No.**

Itemised, so the claim can be attacked:

- The substrate is the free monoid. (§1)
- "Conservativity" is the eliminability half of a 1957–1967 criterion, without
  the other half, over a theory that does not exist because `Provable` is not
  modelled. (§3)
- The proposer is degenerate predicate invention: it invents a name with no
  arity, and no progress theorem in either module mentions the body it
  generates — the modules say so themselves. (§3, and
  `notes/GENERATIVE_MODULES_AUDIT.md` gap D)
- The plateau theorem is, by its own T7′, a fact about a datatype whose steps
  cannot install anything; the non-degenerate version (T10) is set membership.
- The termination bound is a ranking function, and it is loose where the exact
  count is a page away.
- The distinction-compilation algorithm is partition refinement, generically
  solved with a tool since 2017, and `runtime/distinguish/README.md` already
  cites Moore and names Hopcroft as its upgrade.
- Nothing is nominal.

Two residues that are *not* claims of novelty but are the only places worth
looking:

- **`CompileBridge` §H / `GENERATIVE_LOOP_ARITHMETIC_BOUNDARY.md`.** The
  $\mathbb{Z}/30$ collision ($F=(1,\dots,1)$, $G=(2,\dots,2)$: same order-1
  cyclotomic sector, same `Tm`, same `deficit`, autocorrelations $30$ vs
  $120$) is genuinely ours and genuinely negative: the generative lane's state
  does not determine the arithmetic answer. It is a fact about our encoding,
  not a theorem of coalgebra, learning theory, or words. It is also the single
  most useful thing the lane has produced, because it forecloses a whole class
  of bridges.
- **The level history in `distinguish/`.** Moore's intermediate partitions are
  the bounded-depth Nerode signatures, retained and used as an index; Hopcroft
  and (by construction) the Paige–Tarjan-shaped generic algorithms do not
  produce them. "Partition refinement that also returns the depth filtration,
  at Hopcroft's cost" is the one question in this note that a search did not
  settle. It is a `SEARCH` item, not a result.

Neither is in the generative loop.

---

## 10. Sources

**Ś1 (read this session, inside this repository):**
`formal/cubical/NaturalMachine/{Obstruction,GenerativeLoop,WitnessPolicy,ProgressDefinition,CompileBridge,FutureBehavior}.agda`;
`notes/{FUTURE_BEHAVIOR_IS_COALGEBRA,MATHEMATICS_THAT_LEARNS,GENERATIVE_MODULES_AUDIT,FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN,NON_SCALAR_KNOWLEDGE_CAPABILITY_SYSTEM}.md`;
`runtime/CRYSTAL.md` §§3.1–3.2; `runtime/distinguish/README.md` §§3–5, 8;
`runtime/vocabulary/README.md` §§1–2, 7; `collab/STATE.md`; `collab/ROSTER.md`.

**Ś2 (search-snippet testimony only — no primary text was fetched; WebFetch is
EGRESS_BLOCKED):**

*Automata learning.*
Angluin, *Learning regular sets from queries and counterexamples*, Inf. &
Comput. 75(2), 1987 (bounds via the survey below).
*Model Learning: A Survey on Foundation, Tools and Applications*,
[arXiv:1901.01910](https://arxiv.org/pdf/1901.01910) — source of the
$\le n$ equivalence-query and $O(\lvert\Sigma\rvert mn^{2})$ membership-query
figures.
van Heerdt, Sammartino, Silva, *CALF: Categorical Automata Learning
Framework*, CSL 2017, LIPIcs 82:29 —
[DROPS](https://drops.dagstuhl.de/storage/00lipics/lipics-vol082-csl2017/LIPIcs.CSL.2017.29/LIPIcs.CSL.2017.29.pdf) ·
[arXiv:1704.05676](https://arxiv.org/abs/1704.05676) ·
[thesis](https://discovery.ucl.ac.uk/10110356/1/thesis_final_ucl.pdf).
*Learning Automata and Transducers: A Categorical Approach*, CSL 2021, 15.
*A Categorical Framework for Learning Generalised Tree Automata*,
[arXiv:2001.05786](https://arxiv.org/pdf/2001.05786).
Aarts, Heidarian, Vaandrager, *Automata Learning through Counterexample Guided
Abstraction Refinement*, FM 2012 —
[Springer](https://link.springer.com/content/pdf/10.1007/978-3-642-32759-9_4.pdf).

*CEGAR / CEGIS.*
*25 Years of Counterexample Guided Abstraction Refinement*, Springer collection
— [link](https://link.springer.com/collections/jcchhbfcgh).
Solar-Lezama, *Program Synthesis by Sketching* — via corpus prior art
(`FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN.md`, where the source boundary was
already checked).

*Predicate invention / ILP.*
Cropper, Dumančić, Evans, Muggleton, *Inductive Logic Programming at 30: a new
introduction*, JAIR — [PDF](https://www.jair.org/index.php/jair/article/download/13507/26814/30883) ·
[arXiv:2102.10556](https://arxiv.org/abs/2102.10556).
Stahl (authorship Ś3), *Predicate invention in ILP — an overview*, ECML 1993.
Cropper & Morel, *Learning programs by learning from failures*, MLJ 2021.
*Generalisation Through Negation and Predicate Invention*,
[arXiv:2301.07629](https://arxiv.org/pdf/2301.07629).

*Partition refinement.*
Dorsch, Milius, Schröder, Wißmann, *Efficient Coalgebraic Partition
Refinement*, CONCUR 2017, LIPIcs 85:32 —
[DROPS](https://drops.dagstuhl.de/storage/00lipics/lipics-vol085-concur2017/LIPIcs.CONCUR.2017.32/LIPIcs.CONCUR.2017.32.pdf) ·
[arXiv:1705.08362](https://arxiv.org/pdf/1705.08362).
Wißmann et al., *Efficient and Modular Coalgebraic Partition Refinement*, LMCS
— [episciences](https://lmcs.episciences.org/6064/pdf) (the CoPaR tool).
*Distributed Coalgebraic Partition Refinement*, TACAS 2022 —
[arXiv:2204.06248](https://arxiv.org/pdf/2204.06248).
*Fast Coalgebraic Bisimilarity Minimization*,
[arXiv:2204.12368](https://arxiv.org/pdf/2204.12368).
*Coalgebra Encoding for Efficient Minimization*,
[arXiv:2102.12842](https://arxiv.org/pdf/2102.12842).
*From Generic Partition Refinement to Weighted Tree Automata Minimization.*

*Coalgebra in HoTT.*
Gylterud, Stenholm, Veltri, *Terminal Coalgebras and Non-wellfounded Sets in
Homotopy Type Theory*, [arXiv:2001.06696](https://arxiv.org/abs/2001.06696)
(v. Aug 2025; Agda / agda-unimath).
Ahrens, Capriotti, Spadotti, *Non-wellfounded trees in Homotopy Type Theory*,
TLCA 2015, [arXiv:1504.02949](https://arxiv.org/abs/1504.02949) ·
[project page](https://hott.github.io/M-types/).
*Type-Theoretic Constructions of the Final Coalgebra of the Finite Powerset
Functor*, FSCD 2021, LIPIcs 195:22.

*Quantitative coalgebra / coalgebraic modal logic.*
*Quantitative Graded Semantics and Spectra of Behavioural Metrics*, CSL 2025,
[DROPS](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.CSL.2025.33).
*Expressive Quantale-valued Logics for Coalgebras: an Adjunction-based
Approach*, [arXiv:2310.05711](https://arxiv.org/pdf/2310.05711).
*(Metric) Bisimulation Games and Real-Valued Modal Logics for Coalgebras*,
CONCUR 2018, [arXiv:1705.10165](https://arxiv.org/abs/1705.10165).
CALCO 2025 proceedings, LIPIcs vol. 342.

*Nominal / register / symbolic.*
Bojańczyk, Klin, Lasota, *Automata theory in nominal sets*, LMCS 2014 —
[episciences](https://lmcs.episciences.org/1157).
Moerman, Sammartino, Silva, Klin, Szynwelski, *Learning Nominal Automata*,
POPL 2017, [arXiv:1607.06268](https://arxiv.org/pdf/1607.06268).
*Supported Sets — A New Foundation for Nominal Sets and Automata*,
[arXiv:2201.09825](https://arxiv.org/pdf/2201.09825).
*Symbolic Register Automata*, [arXiv:1811.06968](https://arxiv.org/pdf/1811.06968).
*Register Automata with Permutations*, MFCS 2025, LIPIcs —
[DROPS](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.MFCS.2025.14).
*Nominal Tree Automata with Name Allocation*, CONCUR 2024.
Vaandrager & Midya, Myhill–Nerode for register automata and symbolic trace
languages.

*Definitions.*
Suppes, *Introduction to Logic* (1957) — eliminability and non-creativity.
Shoenfield, *Mathematical Logic* (1967) — the theorem on definitions.
Kleinknecht — eliminable ⇒ explicitly definable.
[Conservative extension](https://en.wikipedia.org/wiki/Conservative_extension)
(search summary only; not fetched).

**Ś3 (recalled, no source consulted — verify before citing):** Lothaire,
*Combinatorics on Words*; Moore 1956; Hopcroft 1971; Paige–Tarjan 1987;
Kanellakis–Smolka 1990; Kearns–Vazirani discrimination trees; Isberner–Howar–
Steffen TTT (RV 2014); Howar observation packs; RPNI / EDSM; Plotkin 1970
(least general generalization); Kildall / Cousot–Cousot (worklist, chaotic
iteration); Turing 1949 / Floyd 1967 (ranking functions);
Silva–Bonchi–Bonsangue–Rutten generalized powerset construction;
Cobleigh–Giannakopoulou–Păsăreanu TACAS 2003; Barlocco–Kupke–Rot,
*Coalgebra Learning via Duality*, FoSSaCS 2019.

---

## 11. Queue items generated

| tag | item |
|---|---|
| `PROVE` | `chainLen ch ≡ card (alph t \ V)` — the exact step count, replacing `≤ deficit V t`. §7.1. Counting argument over `List Shape`; the machinery (`memb`, `dichotomyBool`, `deficit-split`) is already in `GenerativeLoop`. |
| `PROVE` | Restate `Obstruction` §§1–3 and all of `WitnessPolicy` as free-monoid facts: exhibit `Tm ≃ List Shape`, `plug ≡ _++_`, `size ≡ length`, `unfold d b` as the morphism freely generated by `d ↦ b`, and derive T1, T2, `body-retrievable`, `plug-size`, `degenerate-never-grows`, `informative-grows` from the universal property. Estimated net: −400 lines. |
| `SEARCH` | Does any partition-refinement algorithm return the depth filtration (bounded-depth Nerode signature levels) at Hopcroft's $O(\lvert\Sigma\rvert n\log n)$? `runtime/distinguish/README.md` §4 asserts Moore is used *because* Hopcroft loses it; that trade-off is unverified against the literature. |
| `SEARCH` | Does Gylterud–Stenholm–Veltri's identity-type-of-M-types characterisation port to Cubical Agda under `--safe` at our universe levels? If yes it replaces the blocked `Cubical.Codata.M.Bisimilarity` import the sibling note ruled out. |
| `DEMONSTRATE` | Merge the generative and teaching lanes: record in both `notes/FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN.md` and `runtime/vocabulary/README.md` §7 that the residual-driven proposer is blocked by panini's own theorem (a counterexample licenses but does not select a grammar enlargement), and state what additional signal the corpus proposes to supply. §7.2. |
| `PROVE` | If the lane wants a real conservativity theorem: model `Provable` (an equational theory over `Tm`) and prove non-creativity, i.e. base-derivable equality of unfoldings ⟺ extended derivability. `runtime/vocabulary/conservativity.py` already runs this argument on real theorems; the Agda lane has only the translation half. |
