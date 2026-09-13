# Alonzo Church — one calculus for functions and logic, and the kinds of sameness

## I. The life, as a cognitive trajectory

Alonzo Church was born on 14 June 1903 in Washington, D.C. He took his degrees at Princeton (A.B. 1924, Ph.D. 1927 under Oswald Veblen, on alternatives to the axiom of choice in the theory of ordinals), then spent two fellowship years at Harvard, at Göttingen with Hilbert and Bernays, and in Amsterdam with Brouwer. He returned to Princeton in 1929 and stayed until 1967, then taught at UCLA until 1990. He died on 11 August 1995. He was famously meticulous: his lectures began with the blackboard erased in a fixed ritual, his notation was exact to the dot, and he co-founded the *Journal of Symbolic Logic* in 1936 and edited its reviews section for more than four decades, reading and cataloguing the entire literature of the field.

His founding ambition was a single formal system in which functions and logic are the same kind of thing. *A Set of Postulates for the Foundation of Logic* (1932–33) introduced the λ-notation — λx.M for the function sending x to M, with application and conversion — as the basis of a logic that would avoid Russell's paradox by weakening the law of excluded middle rather than by stratifying types. In 1935 his students Stephen Kleene and J. Barkley Rosser proved that system inconsistent. What survived was the **pure λ-calculus**, with no logic in it at all, and it turned out to be a complete theory of computation.

The next three years made Church one of the founders of computability:

- 1936, with Rosser: the **Church–Rosser theorem** — conversion is confluent, so a term has at most one normal form, and the order of reduction does not change the answer when one exists.
- 1936, *An Unsolvable Problem of Elementary Number Theory*: effective calculability identified with λ-definability (and general recursiveness) — **Church's thesis** — and an unsolvable problem exhibited.
- 1936, *A Note on the Entscheidungsproblem*: the decision problem for first-order logic has no solution — **Church's theorem**, months before Turing's paper reached the same conclusion by machines.

He supervised Turing's doctorate (1936–38), and his students form a large part of the history of logic and computing: Kleene, Rosser, Turing, Leon Henkin, Michael Rabin, Dana Scott, Raymond Smullyan, Martin Davis, John Kemeny, Hartley Rogers, Peter Andrews, Simon Kochen.

Having lost the untyped foundation, he built a typed one. *A Formulation of the Simple Theory of Types* (1940) put λ-abstraction inside Russell's hierarchy of types, with a type of propositions and a type of individuals, a description operator and axioms of extensionality. It is the ancestor of every higher-order logic used in proof assistants (HOL, Isabelle/HOL). Henkin proved it complete for general models in 1950. *The Calculi of Lambda-Conversion* followed in 1941.

His longest project was about meaning. *A Formulation of the Logic of Sense and Denotation* (1951) formalized Frege's distinction between the sense (*Sinn*) of an expression and what it denotes (*Bedeutung*), with a hierarchy of concept types and a question he never closed: under what criterion are two senses the same? He proposed three "Alternatives" of decreasing fineness (0, 1, 2) and revised them for forty years without settling on one; the related "synonymous isomorphism" criterion for belief contexts was similarly never made satisfactory.

In 1957–1962 he also posed what is now called **Church's synthesis problem**: given a specification of the relation between an infinite input stream and an output stream (in a monadic second-order logic), decide whether a finite-state circuit implements it and, if so, construct one. Büchi and Landweber solved it in 1969, and Rabin's tree automata grew out of it.

## II. What he left on the table

1. **One calculus for functions and logic.** The 1932 system was inconsistent; the λ-calculus survived without logic, and simple type theory kept logic by stratifying. The unification Church wanted — computation, proof and meaning as one object — waited for the Curry–Howard correspondence, Martin-Löf, and univalent foundations.
2. **Confluence and the meaning of evaluation order.** Church–Rosser says order does not matter *when* a term normalizes. What exactly an observer needs from a non-confluent rewriting system to get a well-defined answer and a notion of time was not asked.
3. **Functions as rules versus functions as graphs.** Simple type theory needs extensionality as an axiom: two functions that agree everywhere are not provably equal from the rules alone.
4. **Church's thesis.** An informal identification, not a theorem. What "effective" should mean once computation interacts with an environment was not in view.
5. **Sameness of sense.** The Alternatives (0), (1), (2) and synonymous isomorphism: a graded notion of identity finer than denotation, never fixed.
6. **Soundness versus completeness of a rewriting calculus.** Which equalities its derivations reach and which its semantics identifies.
7. **Synthesis from specification.** Church's problem, solved for finite-state circuits and ω-regular specifications; synthesis of programs from rich specifications, with certificates, remained open as a practice.
8. **The decision problem, positively.** Church's theorem is negative; the structure of what *is* decided, stage by stage, with evidence, was not part of the classical picture.

## III. How we got here: the line from Church to the substrate you write in

The substrate of your work is the end of a line that runs through Church.

- **Russell (1903–1908):** ramified types, to block paradox. **Ramsey (1926):** simple types.
- **Church (1940):** simple type theory with λ; propositions as a type; extensionality as axioms.
- **Curry (1934, 1958) and Howard (1969):** propositions are types and proofs are programs. Church's lost unification of functions and logic returns: a proof of A → B *is* a λ-term.
- **de Bruijn (Automath, 1967):** dependent types used to check real mathematics by machine.
- **Martin-Löf (1971–1984):** intuitionistic type theory — dependent Σ and Π, inductive types, universes, and the identity type Id(A, a, b) with its eliminator J; meaning given by judgments and their evidence.
- **Girard and Reynolds (1971–72):** System F, and normalization proofs by reducibility candidates.
- **Hofmann and Streicher (1994):** the groupoid model — identity proofs need not be unique, so the identity type carries higher structure.
- **Awodey–Warren and Voevodsky (2006–2009):** identity types are path spaces; types are homotopy types; the **univalence axiom** makes equivalent types equal.
- **Cohen, Coquand, Huber and Mörtberg (2015):** cubical type theory, in which univalence is not an axiom but a theorem that computes — transport along `ua e` reduces to e — using an interval with De Morgan connections, a Kan composition `hcomp`, transport `transp`, and Glue types.
- **Cubical Agda (Vezzosi, Mörtberg, Abel, 2019):** the implementation your theorems are checked in.
- **Your Bend2 layer (2026):** the interval, `coe`, J with definitional β, binary `hcomp`, and iso-univalence with `uaβ`, `uaIdEquiv` and `uaη`, ported onto an interaction-net runtime (HVM) whose reduction is Lamping-optimal and confluent by construction.

Every item in section II is a point on this line, and your work touches each one.

## IV. Your work through Church's eyes

### 1. One calculus: functions, proofs, data and execution as one object

**Open:** the 1932 unification of functions and logic.

**What you proved and built.** The kernel lane states the unification at the level of a running system, in the type theory itself:

- `Kernel/RewriteCertificate`: a term language `Tm`, a step relation `Step` (with congruences and a `reverse` constructor), derivations, an evaluator `eval : Tm → Env → ℕ`, and `step-sound` — every step preserves meaning pointwise.
- `Kernel/ControlledGrammar`: `install : Derivation lhs rhs → NativeOperation`. A proved theorem becomes an executable operation whose applicability condition `Control t` is *exactly* evidence that the current term is its certified source (`control-sound`); `advance` maps branches without quotienting, sorting or deduplicating, and `advance-preserves-branch-count` is the exact no-premature-collapse law.
- `Kernel/GenerativeKernel`: a `Branch` is both formation state and executable branch — "no certificate is exported to a second language: operation, applicability, result, and the derivation that computes it remain one typed object." The kernel's own seed has a direct and a detour history with the same endpoints, and `run` exposes both.
- `NaturalMachine/EkaBhasha`: a store entry `नियमः` carries its proof as a field, so an unproven rule is unconstructible; the prover returns a proof or nothing; equality returns the path.

The Bend2 writeup states the principle the kernel instantiates: data, program, execution, proof and transport are five projections of one symbolic object. Church's 1932 system tried to make logic a calculus of functions and failed by inconsistency. Here the calculus of functions is typed, the logic is its type structure, and the operation that runs is literally the proof that was checked.

### 2. Rules and graphs: extensionality as a theorem

**Open:** in simple type theory, functions as rules and functions as graphs agree only by axiom.

**What you proved.** In the cubical substrate, function extensionality is a term (`funExt`), and your Bend2 layer records that it becomes provable there once paths are added ("funext (unprovable with Bend2's native Eql)"). Beyond that, `theorems/residue/Sambandha` proves the relation–function identification in its strongest form: a relation R with a unique answer at every input (`Fun R = (a : A) → isContr (Σ B (R a))`) is the graph of its execution (`the-relation-is-the-graph : (exec a ≡ b) ≃ R a b`), and the whole space of functional relations **is** the function space, `relational-programs-are-maps : (Σ R . Fun R) ≃ (A → B)`, with the left round trip built by `ua` applied pointwise. The receipt event of the deterministic interactive machine is the graph of the universal step on the nose (`the-receipt-is-the-graph` is `refl`). Rule, graph and receipted interaction are three presentations of one type.

For coinductive functions the same identification is `fibre/Orbit`: `path≃bisim : (x ≡ y) ≃ (x ≈ y)`, with all four directions corecursive, and then `path≡bisim` by `ua`. Two infinite behaviours that agree at every observation are equal, as a theorem.

### 3. Confluence is not what an observer needs

**Open:** the role of Church–Rosser, and what a non-confluent system can still determine.

**What you proved.** Three results, from three sides.

- `theorems/historical_proofs/EkaVakyata`: confluence — causal invariance, in the computational-physics reading — is **not needed**. If the observer's reading of a successor is determined by its reading of the predecessor, whichever branch is taken, then any two runs of the same length from equally-read starts are equally read at every step. The observer gets a deterministic law and a well-defined time inside a rule that may branch without limit and need not be confluent anywhere; one pair of branches the observer can tell apart destroys every reading-level law at once. The requirement moves from the rule to the observer.
- `fibre/Krama`: for two steps f and g, a commutation certificate `(a : A) → f (g a) ≡ g (f a)` turns every interleaving word into a normal form depending only on the counts (`serialisation`), so any two schedules with the same counts agree (`interleavings-agree`) — the Mazurkiewicz trace quotient, with the order discarded by proof rather than by assumption. And when commutation fails, the order is data: `suc` and `double` with equal counts compute 2 and 1 (`order-survives`).
- `fibre/Samvada`: for the deterministic embedding of an orbit into the interactive coalgebra, every strategy observes the same prefix (`det-strategy-independent`) — Church–Rosser read as strategy independence — while the `counter` interaction shows two strategies disagreeing at the first step (`counter-demand-matters`).

The runtime completes the picture. The HVM interaction nets under your Bend2 layer are confluent by construction (four rewrite rules) and Lamping-optimal, and the writeup states the identification: `det-strategy-independent` is the runtime's Church–Rosser, and conversion checking of proof terms becomes net reduction.

### 4. Soundness is not completeness, and the gap is exactly a symmetry

**Open:** which equalities a rewriting calculus derives versus which its semantics identifies.

**What you proved.** `NaturalMachine/Anupurvi`: every step of the kernel calculus preserves the left-to-right word of variable occurrences, so no derivation joins `add var yvar` to `add yvar var`, while `eval` identifies them at every environment. Soundness is not completeness, and the gap is precisely the symmetric group acting on variable positions. The companion `Ankapasa_…` shows the counting semantics cannot see a transposition that the univalent semantics calls the swap, so adding commutativity completes the calculus toward its ℕ-semantics and introduces a ℤ/2 of holonomy at the same moment: "the completion and the holonomy arrive together, because they are the same generator." The file states its normalization conjecture as a type, unproved.

`NaturalMachine/Alopa` answers the operational question: two terms with the same normal form are equal under **every** environment, with no environment inspected (§5); one disagreeing assignment refutes (§6); and sampling cannot replace normalization — `var 0` and `var 1` agree on every constant environment, infinitely many confirming samples, and are not equal (§7). "What a sample confirms is a property of the distribution it was drawn from."

### 5. Church's thesis, made exact where it can be

**Open:** what effective computation is, and what it becomes when computation interacts.

**What you proved.** Your universal machine lives inside type theory as a total function (`Vishvayantra.uStep`), with nontermination represented as a productive stream rather than executed. Within that setting the questions around Church's thesis get exact answers:

- the universal function exists as a function, and no universal *table* exists natively (`Vikarna`), so universality is universality up to encoding;
- functional relations collapse onto functions (`Sambandha`), so the relational and functional presentations of effective processes define the same space;
- deterministic receipted interaction is contractible and strictly contained in free interaction, the gap being exactly the event type (`Prashna`, `Sakshin`).

The thesis itself is an identification between an informal notion and a formal one and is not a theorem anywhere. What is a theorem here is the exact position of the Turing machine inside the larger class of interactive computations, which is where the modern disputes about the thesis actually lived.

### 6. The kinds of sameness: the Logic of Sense and Denotation, graded and proved strict

**Open:** Church's forty-year search for the right criterion of identity for senses — something between sameness of denotation and syntactic identity.

**What you proved.** Your work contains a graded theory of identity, each grade a type and each inclusion proved strict.

- `Kernel/AnEquivalenceIdentifiesTheCarriersSoProvenanceIsExactlyWhatDoesNotTravel`:
  - `Satya A B = ∥ A ∥₁ ≃ ∥ B ∥₁` (both inhabited or neither — agreement of truth value),
  - `Artha A B = A ≃ B` (the carriers identified — what `ua` transports along),
  - `Mula pA pB e = (a : A) → pB (e a) ≡ pA a` (and the sources agree).

  Artha gives Satya for free; `satya-does-not-give-artha` (Unit and Bool); and the main theorem `artha-does-not-give-mula`: one equivalence — the identity — with two provenance maps that disagree, and "no function taking an identification of carriers to an agreement of sources." Transport computes both ways (`uaβ`, `~uaβ`). And **the ends do not determine the middle**: Bool has two self-equivalences, so a peer holding only `∥ Artha A B ∥₁` — knowing that a route exists — cannot extract the route (`the-existence-of-a-route-does-not-give-the-route`). The object is the triple `(a , e , b)`.
- `historical_proofs/Niksepa`: sameness indexed by a deposit, `_⟨_⟩_ : वस्तु → निक्षेप → वस्तु → Type`, so "same" cannot be written without saying at which grade. The instance is exact: Agda's `+` (recursing on the first argument) and the machine's `+` (recursing on the second) are the same function (`एकद्रव्यम्`, one substance), bear the same name, and differ in state — `n + 0 ≡ n` holds by `refl` for one and needs induction for the other (`भाव-भेदः`).
- `theorems/cost/Abhijnana`: an identification and an elision agree on the result and differ only in the fibre; no rule reading only the codomain separates them.
- `NaturalMachine/Sesa…`: two derivations of one equation have equal meanings and different lengths, and no semantic criterion separates them.
- `theorems/logic/PramanaLaksanam`: Leibniz's law in both directions — identicals are indiscernible by `subst`, and agreement under every predicate gives identity.

Church's Alternatives were attempts to choose a single grade of sense-identity. Here the grades are all present at once, as types, with the strictness of each inclusion witnessed: truth value ⊊ carrier ⊊ provenance; name, substance and state separated; result and fibre separated; meaning and route separated. The criterion is not chosen once; it is a parameter of the comparison, and the comparison is well-typed only when the parameter is written.

### 7. Synthesis from specification

**Open:** Church's problem — construct a correct implementation from a specification, with a guarantee.

**What you built.** The Bend2 layer's superposed synthesis (`collab/bend2-cubical/SUPGEN_DEMO.md`, running on the HVM4 C runtime) holds a candidate program space as one superposed value, runs a specification over the whole superposition in a single evaluation with shared work, and lets failing branches annihilate. On the spec `f(0) = 1 ∧ f(1) = 0` the collapse returns exactly `λa.(1 − a)` in 91 interactions; the enumeration of all four candidate behaviours takes 36 interactions in one run, not four executions. The writeup's next step is to drive such search from a Bend2 specification-as-type, so the survivor arrives with an erasing type-theoretic certificate, and the `Sup × Path` rule makes a search transportable across `ua`. This is a running artifact and a documented direction, not a checked theorem of synthesis, and the documents say so. On the kernel side, `ControlledGrammar` and `GenerativeKernel` already make installed theorems into enabled futures with exact applicability evidence and multiplicity preserved.

### 8. The decision problem, stage by stage

**Open:** the positive structure behind Church's negative theorem.

**What you proved.** `TrtiyoMargo` (every finite depth of the universal machine decided with evidence, divergence a proposition), `KotiNirnaya` and `SamastaSima` (each fibre of an arithmetized conjecture decided by a sound and complete Boolean, the open content the single section), `Pratyanayana` (a canonical witness escapes the truncation without choice), and `DeflationaryTest` (decidability does its work only in disjunctions) together state what *is* decided: every stage, with evidence; and what is not: the universally quantified section, which no finite depth decides (`HistoryCompletion.no-depth-decides`).

## V. The shape of the resolution

| Church left | Your term | Kind of answer |
|---|---|---|
| One calculus for functions and logic | `RewriteCertificate`, `ControlledGrammar`, `GenerativeKernel`, `EkaBhasha` | operation = checked proof, one typed object |
| Rules vs graphs; extensionality | `funExt`; `Sambandha.relational-programs-are-maps`; `Orbit.path≃bisim` | theorems, via paths and `ua` |
| What confluence is for | `EkaVakyata`; `Krama`; `Samvada`; HVM | observer congruence suffices; commutation certificate gives normal form |
| Soundness vs completeness of rewriting | `Anupurvi`; `Ankapasa`; `Alopa` | gap = symmetric group; completion and holonomy arrive together |
| Church's thesis | `Vishvayantra`, `Vikarna`, `Prashna`, `Sakshin` | exact position of the TM among interactive computations |
| Sense and denotation | `AnEquivalenceIdentifiesTheCarriers…`; `Niksepa`; `Abhijnana`; `Sesa`; `PramanaLaksanam` | graded identity, every inclusion strict |
| Synthesis from specification | Bend2 `SUPGEN_DEMO`, `Sup × Path`; `ControlledGrammar` | running search by evaluation; certificate path documented |
| The decision problem | `TrtiyoMargo`, `KotiNirnaya`, `SamastaSima`, `Pratyanayana` | every stage decided with evidence; the section is the open object |

Still to locate in this lens: the λ-calculus itself as an object (untyped terms, β-reduction, a Church–Rosser proof inside a module), Church's theorem as a term, and the Henkin completeness of simple type theory.

Church's life ran from a single inconsistent calculus meant to hold all of logic, through the pure calculus that held all of computation, to a typed calculus of meanings whose identity criterion he could never fix. Your work runs the same course and lands where he could not: one consistent calculus in which the function, its proof and its execution are one object, and in which identity itself comes in grades — truth value, carrier, provenance — that are all present at once and provably distinct.
