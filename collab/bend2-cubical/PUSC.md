# Parallel Univalent Superposition Computer

*The architecture statement, as written by the author (2026-09-14). It is the
level at which the name of this work is to be understood. The sections below
are the author's text; the closing section maps it onto what this directory
has built and verified by execution.*

---

A universal computational realization of cubical homotopy type theory, executed through a parallel, higher-order sharing calculus.

That is the level at which the name should be understood. Its subject is the execution of a mathematical language: dependent types, functions, equivalences, paths, higher paths, inductive constructions, and continuing processes—not a machine that merely stores descriptions of these things or reports "relationships" between them.

The important architectural claim is that the computational content remains available throughout: a type can be an argument; an equivalence can execute; a path can be consumed by another program; a higher path can control transport; a family of programs can remain shared while being evaluated; a computation can produce an operation that participates in subsequent computation. That is the combination of computational cubical foundations with the represented, self-transforming computational object described by your calculus.

The organizing principle is closure. Performing one of these operations does not eject its result from the domain of the others.

A superposition of functions is still executable. An executable equivalence is still a term. A term containing transport can still be duplicated and shared. Independent reductions can proceed inside those terms. A process constructed from those operations can continue producing more such operations.

The 4+6+4+1 structure matters: four words, six pairings, four triples, one integrated computational architecture.

## 1. The four words

### Parallel: independent composition is part of the computational semantics

The deepest meaning of parallel is not "uses several processors." It is that the computation does not fundamentally consist of one privileged sequence of instructions.

It has sequential composition where one operation consumes another's result, and independent composition where separate operations can advance without waiting for one another.

Write sequential composition as g∘f, and write independent composition as f⊗g. Then the elementary interchange equation is:

    (f₂ ⊗ g₂) ∘ (f₁ ⊗ g₁) = (f₂ ∘ f₁) ⊗ (g₂ ∘ g₁).

On the left, execution is described in successive layers. On the right, it is described as two independently developing computations. Both descriptions express the same dependency structure.

Parallelism is the executable content of that independence.

Interaction nets make this microscopic. A reduction acts at a local connection between agents. Independent active pairs can reduce separately; their surrounding interfaces determine how the results reconnect. Lafont's original formulation explicitly joined local graph rewriting, constructor/destructor symmetry, and a type discipline for microscopic parallelism.

A sequential schedule is therefore a traversal of the dependency structure—not necessarily the identity of the computation.

There is also a precise higher-dimensional connection. Two independent events give two serial orders:

    r;s    and    s;r.

Their agreement is expressed by a square. Three mutually independent events give a cubical pattern of execution orders, with compatibility between its squares.

This does not make a processor's physical coordinates into mathematical dimensions. The dimensions record independent computational variation.

There is a second technical use of "parallel" worth retaining: two maps with the same source and target are parallel maps. A higher identity compares parallel paths:

    p, q : a =_A b,    α : p = q.

Thus the machine deals both with independently executable operations and with parallel computational descriptions whose agreement can itself be represented and used. Those are distinct notions, but cubical computation gives a language in which they can meet.

### Univalent: the universe's identity structure is computational

Univalence is not a synonym for equivalence, reversibility, or "everything is connected."

Its exact statement is:

    (A =_𝒰 B) ≃ (A ≃ B).

The universe's paths correspond to equivalences between its types.

In one direction, an equivalence e : A ≃ B gives ua(e) : A =_𝒰 B. In the other, a universe path gives an equivalence by transport. The cubical library constructs both directions and their round trips.

The decisive computer-science consequence is substitutability through dependent programs.

Given any definable family F : 𝒰 → 𝒰, the equivalence induces:

    act_F(e) = transport(i ↦ F(ua(e)(i))) : F(A) → F(B).

The family F can contain data, operations, specifications, proofs, interpreters over represented syntax, or process interfaces.

The runtime does not need a separately invented "representation-change feature" for every F. The type theory's substitution and elimination principles propagate the change through the construction.

For example, let F(A) = A → A. Then transporting an operation f : A → A has the action f ↦ e ∘ f ∘ e⁻¹. For a binary operation m : A → A → A, the transported operation has the action m'(x, y) = e(m(e⁻¹x, e⁻¹y)).

These are executable consequences of transport through function types; the cubical library establishes the corresponding equations.

#### "Univalent" includes the higher structure, not only forward conversion

At a type A:

    Ω(𝒰, A) ≃ Aut(A),

where Ω(𝒰, A) is the type of loops at A, and Aut(A) is the type of self-equivalences of A.

Consequently, symmetry is part of the universe's computational identity structure.

Composition of equivalences corresponds to composition of universe paths. Inversion corresponds to path reversal. Relations among symmetries become higher paths. Those higher paths are themselves terms, with their own eliminations and transport.

This is why a univalent computer is more than a system of conversion functions. It computes with the structure of those conversions—including their compositions and higher agreements.

#### "Cubical" supplies the execution rules

A path is represented through a symbolic dimension and boundary conditions:

    p = ⟨i⟩ t(i),    p(0) = a,  p(1) = b.

A square has two dimensions; higher cells have more. Composition operations compute with compatible partial boundaries, and Glue supports the computational interpretation of equivalence as universe identity. Cubical type theory was designed precisely to make these higher-dimensional constructions computational rather than leave univalence as an inert additional axiom.

So univalent names a property of the whole typed computational universe. It does not merely name an extra operation offered by a library.

### Superposition: the structural rules of computation become explicit

This is where "a collection of possibilities" was especially inadequate.

In the Interaction Calculus, superposition belongs to the machinery of substitution and higher-order sharing.

Ordinary lambda notation hides the operational significance of using something more than once: λx. h(x, x). The repeated occurrence invokes a structural operation: duplication. An affine presentation instead makes the split explicit.

IC introduces two dual forms: DUP_ℓ and SUP_ℓ.

Operationally, duplication routes one computational object into multiple uses. Superposition brings multiple branches into one computational position. Their interaction depends on their labels.

The core interactions form a systematic pattern:

    APP ⋈ LAM,    DUP ⋈ SUP,

together with the crossed interactions:

    APP ⋈ SUP,    DUP ⋈ LAM.

Application eliminates an abstraction. Matched duplication/superposition routes the corresponding branches. Application across superposition distributes the application with correlated duplication. Duplication across abstraction creates separate function entrances into shared body structure.

The last interaction is critical: the computer can share computation inside a function before all of that function's inputs have arrived.

This is not merely running two complete programs side by side. Their unfinished computations can remain structurally interwoven.

#### Labels are operational provenance

A label records which duplications and superpositions belong to the same correlation.

With the same label, SUP_ℓ(a₀, a₁) and SUP_ℓ(b₀, b₁) can be consumed as the correlated pairs (a₀, b₀), (a₁, b₁). Different labels retain independent branching dimensions.

This is not an arbitrary convention added to a bag of alternatives. The labels determine which local rewrite is valid and therefore what computation occurs.

Superposition is consequently both a representational and an operational structure:

* it expresses correlated multiplicity;
* it participates directly in reduction;
* it is dual to the operation that makes higher-order sharing possible.

Its importance extends from values to functions, programs, types, and proof terms because those are all computational terms in the combined system.

### Computer: a universal reduction system, not an application-specific analyzer

Computer is doing more work here than "something that executes."

It means the substrate is closed under the construction and execution of programs. An analyzer is one program. A compiler is another. A program generator is another. Their inputs and outputs can themselves be represented programs.

The primitive acts below the level of these applications.

That is the universality claim worth emphasizing: not merely that the system can simulate ordinary computation, but that it realizes the computational structure of its typed language uniformly.

A new datatype is expressed by type formation. A new operation is expressed by a term. A theorem is expressed by an inhabitant of the relevant type. A representation change is expressed by an equivalence and its induced transport. A higher agreement is expressed by a higher path.

These constructions then participate in evaluation.

Your repository's central organization is exactly that the trace produced by an interaction can itself be executable symbolic material, rather than only an external record about an execution.

#### Universality includes continuing execution

A universal machine need not be understood only as a function that eventually returns a final answer.

A total one-step simulator can have the type step : Config → Result + Config. Its execution is then defined productively:

    run(c) = return(a)         if step(c) = inl(a),
    run(c) = delay(run(c'))    if step(c) = inr(c').

Every next simulation step can be well-defined while the whole process continues indefinitely.

For your machine, the richer version accepts a typed interaction and returns a successor, an observation, the associated dependent structure, and another process. Productive recursion and cubical identity can then support reasoning about the entire process, including bisimulation as path equality in the appropriate guarded setting.

Thus computer includes the universal evaluator, the represented program, and its continuing execution—not just the terminal value extracted from one run.

## 2. The six pairings

### Parallel + Superposition: shared higher-order parallel reduction

Ordinary task parallelism begins by separating jobs.

Parallel superposition begins with a shared computational graph and exposes independent work inside it.

Suppose a function body contains a common computation c, while two uses will supply different arguments: f(x) = H(c, x). A naïve split can create two independent computations of c. Sharing the completed value of f(x) does not help when the arguments differ. IC's duplication-through-lambda mechanism allows the common body structure to remain shared while the input-dependent portions separate.

The resulting execution has two distinct economies: common work is shared; distinct independent work proceeds concurrently. These are not competing descriptions. They are complementary decompositions of the same graph.

This is why parallel superposition is stronger than "evaluate many alternatives in parallel." It concerns how the alternatives inhabit the computational representation before they are evaluated.

The work is factored before, during, and across applications—not only batched afterward.

### Parallel + Univalent: computational independence has higher-dimensional content

Take e : A ≃ B and f : C ≃ D. Changing the left coordinate and changing the right coordinate are independently composable representation changes.

The family S(i, j) = ua(e)(i) × ua(f)(j) is an explicit square of types. Its two boundary routes correspond to A×C → B×C → B×D and A×C → A×D → B×D. Both act as (a, c) ↦ (e(a), f(c)).

Your YugapatSankramana module goes beyond separately drawing the square and defining the conversions: it identifies the square's edges with the executable coordinate compilers and relates their composed routes.

Here the parallel structure and the univalent structure are literally aspects of one typed construction. Parallelism describes independent execution of the coordinate operations. Univalence supplies their executable paths. The square records their compatibility.

Where operations are dependent and do not commute, their order remains meaningful. Your corpus explicitly distinguishes lossless completion from exchangeability: completing two operations does not make them commute.

That distinction is part of the power. The computer can represent both independence and noncommuting structure rather than flattening both into a schedule.

### Parallel + Computer: universality without making a single instruction stream fundamental

A sequential universal machine is one presentation of universal computation. A parallel computer presents computation through a dependency structure that can contain many simultaneously enabled interactions.

The implementation can realize a chain when the algorithm requires a chain. It can realize a branching dependency graph when the algorithm provides one.

This affects the meaning of a program. A program is not only "the sequence of commands to issue." It can be a network of typed producers, consumers, continuations, and local interactions whose composition determines the computation.

The machine's execution mechanism then works on that network directly. This is the integrated computational interpretation motivating interaction nets, rather than an external parallelization layer applied to a separately defined sequential machine.

In your coinductive setting, the network need not be fully fixed before execution begins. An interaction can produce more executable structure.

Parallel computer therefore means an engine for evolving dependency graphs, including graphs that represent further programs—not merely a large collection of arithmetic units.

### Univalent + Superposition: shared computation across dependent representations

This pairing is not simply "a superposition of things that happen to be equivalent."

Consider a branch-indexed dependent family A : Ω → 𝒰. A branch may determine both a value and its type: x : ∏_{ω:Ω} A(ω). Now suppose e : ∏_{ω:Ω} A(ω) ≃ B(ω). Then transport acts coherently branch by branch:

    y(ω) = transport(ua(e(ω)), x(ω)).

The branch determines the type, the value, and the equivalence together.

That matters for a dependent package such as Σ_{p:Program} Correct(p). The proof cannot be separated from the program whose type it inhabits. Likewise, a continuation cannot be separated from its state index.

Univalent superposition is computation over correlated dependent families, where representation changes preserve the indexing that makes the terms well-typed.

For explicitly represented labelled families, the compatibility equation is:

    select_ω(transportFamily(e, x)) = transport(e(ω), select_ω(x)).

This equation describes the intended family semantics; it is not an assertion that arbitrary raw IC graphs are fully characterized by a table of branch results.

The graph can additionally retain sharing and represented execution structure. The dependent family says what the correlated results mean.

### Univalent + Computer: arbitrary computation can receive a lossless computational presentation

This is where your fibre theorem makes the name substantially deeper than "a computer for reversible programs."

Start with any map f : A → B. Define fib_f(b) = Σ_{a:A} (f(a) = b). Then:

    A ≃ Σ_{b:B} fib_f(b).

The forward map is a ↦ (f(a), (a, refl)). The visible result is still exactly f(a). The completed presentation retains what that visible result alone omits.

Univalence turns this equivalence into an executable universe path.

Therefore general computation does not have to be excluded in order to place it inside the lossless calculus.

Your source states the stronger organization, LawfulStep(A) ≃ (A → A), and explicitly realizes an ordinary universal-machine step as the visible projection of its lossless completion.

That is a universality result about the presentation of computation: the lossless account is not a tiny sublanguage containing only operations that were already invertible.

It reorganizes a computation into: visible result + exact dependent residual.

The same operation can then be executed, reconstructed, composed, or used as a term in a larger construction.

### Superposition + Computer: the evaluator can compute over programs, not only over their inputs

Because functions and represented programs are computational objects, superposition applies to them too.

A superposed program is not merely an instruction to run an external loop over source files. It is a term whose branches can contain different program structure while retaining shared portions.

Application then reduces that object.

The same idea applies to program synthesis. The mathematical result sought is not a high-scoring string; it can be Σ_{p:Code} Correct(p). The evaluator can compute through candidate constructions, share common reductions, and retain the program/evidence dependency.

This gives an exact role to symbolic search: execution over a represented family of constructions.

It also changes the relationship between search and use. A generated term is already in the computational language. Once checked at the appropriate interface, it can be applied, composed, transported, or installed.

The underlying operational reason is again the IC interaction between application, abstraction, duplication, and superposition—not an extra interpretation attached to a list of answers.

## 3. The four triples

### Parallel Univalent Superposition: shared higher-dimensional computation

This triple describes the structure of the computation before specifying a particular application.

A useful schematic object is A : Ω × Iⁿ → 𝒰. Here Ω indexes correlated branch choices; Iⁿ supplies cubical dimensions; A gives the dependent type at each context.

The choice coordinates and cubical dimensions have different semantics. One selects correlated branches; the other supports path abstraction, boundary restriction, and composition. But they coexist in the same term.

For example, A(ω, i, j) = ua(e_ω)(i) × ua(f_ω)(j) is a family of independent representation-change squares, indexed by a correlated computational family.

Now all three words matter simultaneously. Superposition preserves the branch-dependent e_ω, f_ω, and inputs together. Univalence makes those equivalences act through the dependent family. Parallelism permits the independent coordinate computations to advance separately while shared branch structure remains shared.

The meaning is not obtained by first expanding every branch, then converting every value, then parallelizing the resulting list. The three structures coexist during reduction.

That is the central semantic object: a shared term with both branching and cubical context, whose independent demanded reductions can execute concurrently.

### Parallel Univalent Computer: a higher-dimensional abstract machine for typed computation

This triple is a computer whose representation changes and execution transformations are themselves typed computational operations.

Suppose P_A : A → A and e : A ≃ B. Define the transported program P_B = e ∘ P_A ∘ e⁻¹. Then P_B ∘ e = e ∘ P_A as a path-valued equality of functions.

This is a commuting execution diagram. It says that execution and representation change agree.

The same construction extends to a dependent package containing a program, its state, and the structures used to continue execution. Independent changes to separate components can themselves be composed through the corresponding cubical squares.

The important compiler implication is: a representation change can carry the program that uses the representation, not only the data stored in it.

A type-indexed optimizer, a state-layout conversion, and a transported proof of a property can be parts of one dependent construction.

Parallel execution then applies to the computational content of that construction. It does not sit outside the mathematics as an unrelated performance service.

This is the relevant sense of "the mathematics computes": the equations establishing correspondence can themselves participate in the program being run. Computational transport through operations and the explicit coordinate-compiler square already exhibit this pattern.

### Parallel Superposition Computer: a universal shared symbolic evaluator

This triple is already a substantial computer-science object without univalence.

It evaluates higher-order programs with explicit sharing and correlated branching, exposing independent reductions for parallel execution.

Its natural workloads include families of programs, symbolic interpreters, search procedures, and partially instantiated higher-order computations.

The distinction from a conventional "run N programs on N workers" design is representational: a shared family of computations ≠ a collection of independently copied computations.

The family can share its program structure, its environment, or reductions inside abstractions before branch-specific inputs resolve everything.

The IC's DUP-LAM and APP-SUP mechanisms are directly relevant to this capability.

What univalence adds to this triple is not universality in the elementary sense of simulating programs. It adds the full computational treatment of dependent representation equivalence and higher identity.

That is why the adjective is essential. Without it, "parallel superposition computer" describes a powerful sharing machine, but not yet the whole cubical computational universe you are realizing.

### Univalent Superposition Computer: the full typed object is available to computation

This triple isolates the semantic advance from the number of physical processors.

Even on one processor, a univalent superposition computer can evaluate correlated families of dependent terms and carry them through executable universe paths.

Now consider the total typed state space Point_ℓ = Σ_{A:𝒰_ℓ} A. At (A, a), an interaction can supply a target type B and an operation f : A → B, producing (B, f(a)).

An equivalence-based interaction carries the associated transport. A general map can use its lossless completion. A represented program can itself be the current value.

The continuing object can therefore move among different types of computational state, with subsequent operations indexed by the new state.

Coinduction supplies the persistent execution form:

    ISC(w) ≃ ∏_{q:Q(w)} Σ_{w'} Σ_{o:O(w,q,w')} E(w,q,w',o) × ▷ISC(w').

The continuation is not an afterthought. It is part of the typed response.

Cubical identity and guarded recursion can make equalities between such continuing objects usable as paths, rather than as a separate external relation that programs cannot transport through.

Univalent Superposition Computer therefore means a computer whose operational material includes dependent terms, their correlated alternatives, and their higher identifications—and which can continue computing with the results.

Parallelism makes the independent work in that object available to concurrent execution.

## 4. All four: one reduction architecture for the whole computational language

The whole is not the sum of the previous descriptions. It is the requirement that their operations remain compatible inside one computation.

A useful schematic judgment is Δ; Φ; Λ; Γ ⊢ t : A, where Δ is the cubical dimension context, Φ the face assumptions, Λ the correlated-choice context, and Γ the ordinary dependent-variable context.

This is a way to expose the combined semantics, not a claim that these exact symbols are the implementation's parser syntax.

The machine must account for ordinary substitution, dimension substitution, branch restriction, typed reduction, and independent scheduling.

The crucial equations are compatibility equations.

Ordinary substitution must agree with dimension substitution: (t[σ])[θ] = (t[θ])[σ[θ]] for compatible substitutions.

Branch restriction must agree with dependent transport: tr_F(e, t)|_ω = tr_{F|ω}(e|_ω, t|_ω).

Independent composition must satisfy the corresponding interchange law.

Reduction must preserve the typed object and its declared computational observations.

That is what it means for all four words to describe one machine rather than four interoperating products.

### A single example containing the entire architecture

Take a branch-indexed family of machines s_ω : A_ω, δ_ω : A_ω → A_ω, with representation equivalences e_ω : A_ω ≃ B_ω. Define s'_ω = e_ω(s_ω) and δ'_ω = e_ω ∘ δ_ω ∘ e_ω⁻¹. Then, for every finite n:

    (δ'_ω)ⁿ(s'_ω) = e_ω(δ_ωⁿ(s_ω)).

The proof is the iterated commuting square: at each step, execution in the new representation agrees with execution in the old representation followed by transport.

Now read the entire equation computationally.

The family of machines is represented using superposition, so shared code need not become separately copied programs.

The equivalences and their action are univalent, so machine state and transition operations move through the same dependent construction.

Independent demanded reductions within and across the family execute in parallel, while common reductions remain shared.

The resulting family is still a computer: its transitions continue, its representations remain usable, and its transformations can become inputs to further programs.

For an interactive machine, the corresponding construction carries the dependent question/response interface and the continuation as well. Your orbit construction is the deterministic instance of that deeper coinductive organization.

This is not merely an analysis reporting that two machines have equal behavior. It is a computational construction of the represented machine and its relation to the original execution.

### The universality is structural, not merely extensional

Turing universality concerns which computations can be simulated.

The stronger requirement here concerns what remains represented and usable throughout that simulation.

Returning the same final integer is one observation. Preserving the typed dependent state, the action of a universe path, a relation between two program transformations, or a continuing interaction interface is a richer contract.

That is why "it can all be encoded as bits" does not exhaust the architectural question. Of course a substrate can encode syntax. The issue is whether the language's constructors and eliminators are realized as usable computational operations, with their composition preserved.

For cubical homotopy type theory, the full scope includes Π, Σ, 𝒰, Path, transport, composition, Glue, together with the admitted inductive and productive coinductive constructions.

Their interaction is the computational theory—not just a collection of labels attached to values. Constructive cubical foundations and their higher-inductive extensions supply precisely this kind of computational interpretation.

"Realizing the totality of the theory" should therefore mean realizing its computational closure: the higher constructions do not stop being executable when they become inputs to other higher constructions.

Program totality is a related but distinct technical property. A terminating computation returns its result; a productive process supplies each demanded next stage. A universal simulator can live in that productive process form without requiring every simulated program to terminate.

The strong architecture accommodates both finite calculation and continuing universal execution in a typed account.

### Metacircularity is the closure applied to the computer's own represented operations

Once programs are represented terms, a transformation of programs is another program.

Once that transformation is represented, it too can be supplied to further computation.

Once its validity and action are expressed dependently, transporting it carries the relevant package rather than leaving its meaning in an external commentary.

A finite interaction trace can then become a reusable operation; an installed operation can change subsequent execution; the new execution can produce further represented operations.

That is the recursive application of the architecture to its own computational material.

It does not require a new machine primitive for every metalevel. It requires the language's existing formation, substitution, execution, and transport principles to remain available at the appropriate typed level.

Your lossless-machine development makes the ordinary universal step one instance of the completed computational presentation, while the repository's general model makes the transformation trace itself available as executable material.

## The exact force of the name

Parallel says that causal independence is exposed to execution.

Univalent says that equivalence is internal to the universe's computational identity structure.

Superposition says that correlated branching and higher-order sharing are explicit operations of reduction.

Computer says that the resulting calculus is executable and universal enough to construct, run, and transform programs expressed in it.

Each pair adds a compatibility. Each triple closes those compatibilities into a computational regime. The whole requires them to hold together.

The resulting definition is:

**A Parallel Univalent Superposition Computer is a universal typed reduction machine for computational homotopy type theory, in which higher-order sharing, correlated branching, executable equivalence, and independent reduction coexist within the same computational objects.**

The substantive advance is not "more kinds of information in a computer."

It is that the universe, its terms, its dependent operations, its equivalences, and its higher equalities participate in execution—and that execution itself admits sharing, superposition, parallel composition, and productive self-application.

That is the raw computer science the name should communicate.

---

## Where each word is realised in this directory (verified by execution)

| word / claim | realisation | evidence |
|---|---|---|
| the interval, paths, types, `coe`, `hcomp`, `Glue` as runtime data | `--to-hvm4-full` erases nothing; `@coe`/`@hcomp` dispatch on type data at runtime; a composite with an undecided face is the value `#HCm{…}` | RUNTIME_FULL.md, SYNTHESIS.md §1–2 |
| univalence computes, both directions, coherently | `ua`/`Glue`, `uaβ` definitional, `pathToEquiv(uaE e) = e` | `uaequiv.bend`, `uaglue.bend`, GLUE.md, UNIVALENCE.md |
| the lossless presentation `A ≃ Σ B (fiber f)` as an executable universe path | `fibrelaw.bend`, present/retrieve run on the net | FIBRE_LAW.md |
| superposition as the DUP/SUP structural rules, routing transport branch by branch | `coe` along a superposed line needs no rule (a match commutes over `&L{}`); measured regimes | `supline.bend`, SYNTHESIS.md §4 |
| inductive constructions, general | `hit` declarations: parameters, indices, constructors of any declared type (interval and path fields included), path constructors of any dimension, a dependent eliminator computing on constructors, cells and `hcomp` cells, transport along HIT lines, all on the runtime | HIT.md |
| continuing processes | corecursive records, bisimulation as path equality, `--total` productivity gate | COINDUCTION.md, INTERACTION.md, silence.bend |
| the whole as one reduction architecture | every construction above is a term of one language, checked by one checker and run by one emitter; the suite is one script | `./suite.sh` |
