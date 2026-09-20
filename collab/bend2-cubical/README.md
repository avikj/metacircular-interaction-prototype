# Cubical Bend / HVM: Universal Executable Identity

This directory is the executable convergence of computational cubical type theory, the repository's coinductive fibre / universal-identity machinery, and the Interaction Calculus / HVM execution lineage.

It is not a theorem prover attached to Bend and not cubical syntax beside an unrelated evaluator. The central identification is

```text
proof = transport = inference = computation = factorization
```

as different orientations of one executable identity structure. Cubical paths make identity computational; univalence makes equivalence executable as identity; higher cubes retain coherence among alternative transports; fibres retain exactly the distinctions hidden by observations; coinduction returns the whole process as continuation; HVM realizes the object by local interaction with explicit sharing and superposition.

The later cost/geodesic work closes the operational side: cost is a reading of the same represented interaction, and lower-bound/attainment proofs identify geodesic realizations in the declared primitive interaction geometry. Optimization is factorization inside a semantic fibre, not an unrelated heuristic pass.

**Lineage.** This port targets the pre-launch Bend2 interaction-net lineage (DKormann/Bend2, forked from HigherOrderCO-archive/Bend2-old), not the September 2026 `bendlang/bend` implementation, whose primary runtime is BendRT. The mathematics is not contingent on HVM: HVM is the existing interaction-net realization; a lower-order C/Metal/CUDA/JS backend can be another realization of the same cubical semantic object.

## Universal identity, lossless completion, and closure

For every map (f:A\to B),

[
\boxed{A\simeq\sum_{b:B}\operatorname{fib}_f(b)},\qquad
\operatorname{fib}_f(b)=\sum_{a:A}(f(a)=b).
]

The visible value is what an observation determines; the fibre is exactly the realization structure it does not determine. The complete event retains both. The development proves that the space of lawful lossless completions of a fixed map is contractible:

[
\boxed{\operatorname{isContr}(\operatorname{Lossless}(f))}.
]

Thus the residual is forced, up to identity, by the declared computation rather than selected as arbitrary optimizer metadata. At process level, lawful lossless steps are equivalent to the maps themselves.

Cubical structure is what makes this identity computational at every dimension. For an equivalence (e:A\simeq B), univalence supplies a universe path and transport along that path executes the equivalence. Paths have paths; independent dimensions form squares, cubes, and higher coherence. Data, operations, proofs, interpreters, compiler states, representations, and continuing processes can therefore be transported together through one dependency-preserving operation.

The universal family classifies dependent families, so once a mathematical/computational object is represented in the universe, its valid identities and transports inhabit this same executable foundation. This is the sense in which the construction is a **universal executable identity system**, not merely a dependently typed language.

## One operation, many readings

The system is not a stack of independent prover, solver, optimizer, and runtime engines.

- **proof** is witnessed transport;
- **inference** is the same structure with coordinates unspecified;
- **evaluation** is transport read operationally;
- **reconstruction** is reverse presentation;
- **factorization** exposes decomposition forced by identity/fibre structure;
- **optimization** reads equivalent realizations through cost;
- **program transformation** is transport of executable structure.

The machine is also in its own domain. Derived identities, equivalences, factorizations, proofs, and programs remain terms available to later interaction. Parser, elaborator, checker, lowering, optimizer, runtime representation, and backend can themselves be represented and queried. “Prove the compiler correct” is one static projection of the stronger capability: **the compiler is queryable mathematics inside the same executable identity universe.**

## Exact cost semantics and geodesic execution

For primitive interaction cost (c(e)) and a reduction path (\gamma),

[
C(\gamma)=\sum_{e\in\gamma}c(e).
]

If a potential (\Phi) is zero at the demanded terminal observation and satisfies

[
\Phi(u)\le c(u,v)+\Phi(v)
]

for every primitive edge, then every realization path from (s) to that observation obeys

[
\boxed{\Phi(s)\le C(\gamma)}.
]

If a native path attains equality edge-by-edge, it attains the lower bound exactly and is minimum-cost in the declared realization class. Under unit interaction cost this is minimum interaction count; vector costs give the corresponding componentwise/Pareto statement.

The rope development closes this pattern exactly: the all-word prefix theorem forces at least (n) crossings to bring depth (n) to the head, and the native `Bring(n)` construction uses exactly (n). Hence the displayed execution realizes the interaction geodesic rather than merely supplying one implementation.

This cost theorem is why “cubical machinery adds overhead” is the wrong model here. Cubicalization does not mean ordinary computation plus proof bookkeeping. A pre-existing realization remains available after installing additional certified identities/factorizations. If (R_K(F)) is the realization space before installation and (R_{K'}(F)) after,

[
R_K(F)\subseteq R_{K'}(F),
]

so under the same cost interpretation,

[
\boxed{\min_{r\in R_{K'}(F)} C(r)\le \min_{r\in R_K(F)} C(r)}.
]

Additional identity can leave the geodesic unchanged or expose a shorter factorization; it does not force a longer realization. Proof-only structure may erase at a selected runtime interface, but before erasure its identities can remove mediation, duplicated work, conversions, and representation detours. If an observable genuinely depends on a transport, that transport is the requested computation, not a separate cubical surcharge.

## Compiler/runtime consequence

A conventional verified-language architecture has preservation boundaries between paper theory, external formal model, production checker, compiler, and runtime. Cubical Bend can internalize those arrows: the implementation and each transformation can themselves inhabit the universal cubical object.

This does **not** mean that merely writing a compiler in Bend proves it correct. It means compiler correctness is not a fundamentally separate proof technology. Correctness, counterexamples, representation preservation, optimization, and cost are instances of the same executable identity/factorization machinery.

That observation applies directly to launch Bend2 even though it no longer runs on interaction nets. Cubicalizing its semantic core does not require restoring HVM first; BendRT can remain a target whose transformations are objects of the cubical theory. HVM remains the existing realization in which cubical operations themselves reduce on the interaction substrate.


`cubical-paths.patch` applies to DKormann/Bend2 (fork of HigherOrderCO-archive/Bend2-old,
snapshot 2025-07-07) and adds a CCHM-style path layer to the Bend2 core:

    Interval, i0, i1, inot(r), iand(r,s), ior(r,s)
    Path(A, a, b)      -- path type
    <i> t              -- path lambda
    p @ r              -- path application

Semantics implemented:
  - beta: (<i> t) @ r reduces to t[i := r]; connection algebra on i0/i1
  - boundary: checking <i> t against Path(A,a,b) requires t[i0] = a, t[i1] = b
    definitionally, with endpoint reduction of neutral var-headed path spines
    read from the context (h(x) @ i0 reduces to the codomain endpoint)
  - conversion: path-lambda eta, lambda eta

Checked green by the patched binary (build: GHC 9.12.2, cabal 3.18, LC_ALL=C.utf8):
  - cubical_test.bend: prefl, psym (via inot), pcong, funext (unprovable with
    Bend2's native Eql), connection square, and the corpus lossless-presentation
    rightInv transliterated term-for-term from cubical Agda:
      Agda:  Iso.rightInv losslessIso (b , a , p) i = p i , a , Î» j â’ p (i âˆ§ j)
      Bend2: <i> (e @ i, a, <j> e @ iand(i, j))
  - corpus_lossless.bend: the Eql-based version (encode/decode/section/retract)
  - no regressions: examples/main.bend 39/39

Layer 2 (same patch): PathP (paths are lines P : Interval -> Set throughout;
Path(A,a,b) is the constant-line sugar), coe(P,r,s,t) -- generalized transport
with per-type-former dispatch (Pi, Sigma, List, rigid inductives, Set) and
regularity (constant lines transport as the identity, decided on the deep
normal form of the line applied to a fresh marker), and ua(A,B,f,g) : Path(Set,A,B)
with transport along ua computing to f (and to g backwards). J is DEFINED by
coe along the connection square

    J(...) = coe(lambda i. C(p @ i, <j> p @ iand(i, j)), i0, i1, d)

and computes definitionally on refl (J_refl is <i> d). Checked green in
cubical_test2.bend: transport, subst, J, J_refl, pathp_const, ua_beta,
ua_beta_inv, transport_pi, transport_sig. No regressions (39/39 stock).

Layer 4 (same patch):
  - hcomp(A, r, u0, u1, base): homogeneous composition with the binary face
    system (r=i0 -> u0, r=i1 -> u1); faces reduce definitionally, giving
    definitional path composition pcompH (cubical_test4.bend). refl.refl=refl
    stays propositional, matching cubical Agda.
  - ua upgraded to full iso-univalence: ua(A,B,f,g,gf,fg) carries both
    homotopies (this is isoToPath, which is what the corpus's Carrier uses);
    transport still computes to f forwards and g backwards.
  - Sup x Path: coe along a superposed line &L{A(i),B(i)} dups the value at
    label L and transports each universe along its own line -- the corpus's
    fibre-exactness theorem as a reduction rule. Checked: transport along
    &0{ua(not), Bool} sends &0{True,True} to &0{False,True} definitionally.
    Typing: a superposed value checks componentwise against a superposed
    type at the same label.
  - Totality classifier (Core/Totality.hs): every definition is tagged
    [total] (no recursion, or structural descent), [productive]
    (constructor-guarded corecursion), or [unchecked]. An analysis, not a
    gate -- it makes the trust boundary per-definition visible.

Layer 5 (same patch): UNIVALENCE COMPLETE at the iso level. The three laws:
  uaBeta     transport along ua e computes to e -- definitional, both ways
  uaIdEquiv  ua(idIso) = refl -- definitional (identity-ua collapses to the
             constant path in conversion, decided semantically; this is the
             equation Glue exists to justify, valid in the model)
  uaEta      ua(pathToIso p) = p for every p -- proved by J, with pathToIso
             defined by transporting idIso through the Iso family (coe
             regularity reduces through Sigma/Pi/Path components at refl)
See cubical_test5.bend. At the raw Iso level only the path-side round trip
(uaEta) holds; the Iso-side one fails (uaroundtrip.bend), as it must.

Coherent level (uaequiv.bend, 17 checks green): Equiv(A,B) = Î f. âˆy.
isContr(fiber f y); uaE builds the path from the contractible-fibre data;
pathToEquiv transports idEquiv; uaEquivRoundTrip : pathToEquiv(uaE e) = e
CHECKS for arbitrary e, via isPropIsEquiv (pointwise isPropIsContr, a 4-face
hcompN â” see GENERAL_HCOMP.md). hcomp with general cofibration systems is
present (hcompN). fibrelaw.bend (32 green): isoToIsEquiv (lemIso), the fibre
law A â‰ Î B (fiber f) as a coherent Equiv for every f, its uaE path, and
transport along it run natively on HVM4/HVM3 â” FIBRE_LAW.md. --to-hvm4-full
keeps every cubical object at runtime (RUNTIME_FULL.md). hfill is
parser sugar over hcompN (hfill.bend); `bend f.bend --total` refuses a file
with any [unchecked] definition. Not done, not asked: Glue as a first-class
type former (ua is primitive; all its consequences are present).


## Analysis layer (Core/Analysis.hs, same patch)

Every checked definition now prints a mathematical report, not pass/fail:

    totality        [total] / [productive] / [unchecked]
    shape           theorem(=) / theorem(path) / family / program
    proof cost      "definitional" when the kernel pays only computation,
                    else measured rewrite steps and transport cells (coe/
                    hcomp/ua occurrences) -- the cost-lives-in-the-non-
                    contractible-fibre theorem as a per-proof number
    unused args     hypotheses the body never consumes (the erasure signal)
    sup labels      superposition labels touched
    Set-binders     impredicativity load of the type

## The closed loop

run_corpus.bend: mul2/div2 with the proof div2(mul2(n)) == n.
  - checks: proof costs "rewrites: 1, cells: 0"
  - runs in-process: div2(mul2(21n)) = 21
  - extracts (--to-hvm): the PROOF compiles to erasers (*) -- theorems
    ride with programs at zero runtime cost
run_corpus.hvm4: the same program in HVM4 surface syntax, executed on the
  real HVM4 C runtime: div2(mul2(3)) = 3n in 26 interactions.
  (--to-hvm targets the HVM3 dialect; an HVM4 emitter is a mechanical
  printer variant, not yet written.)

## General higher inductive types (same patch) â” HIT.md

`hit Name<params>(indices): case @tag(fields) -> Name(â¦) | path @tag(fields): T`
declares a HIT at the generality of a Cubical Agda `data`: uniform
parameters, indices, fields of any type (intervals and paths included),
path constructors of any dimension with any well-typed faces. The compiler
generates the constructors; `Name/elim` is the dependent eliminator (motive
over the indices), computing on every constructor, on cells of any dimension
and on `hcomp` cells; transport along HIT lines computes on constructors and
commutes with hcomp; `hcomp` in a HIT stays stuck. Everything is runtime data
on `--to-hvm4-full`. Declared and verified, checker and HVM4 agreeing: the
circle, the suspension (transport along `Susp(ua(neg))`), the pushout,
propositional and SET truncation, the quotient's generators, the interval
(funext from it), trees with swap and associativity paths, the torus, an
indexed reachability family and an indexed family with an interval-argument
constructor â” 189 â“ and a 7-probe must-fail. PUSC.md: the architecture
statement (Parallel Univalent Superposition Computer).


## Recent theorem spine

The original port notes above record the cubical surgery and runtime evidence. The later repository work strengthens the interpretation of that implementation. In particular:

- `fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda` — the residual family is forced to be the fibre;
- `fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda` — universal-family/classifier closure;
- `formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda` — contractibility of lawful completion;
- `formal/cubical/theorems/residue/VerifyIsDecide_ThereIsNoGapBetweenFindingAndCheckingBecauseBothAreProjectionsOfOneEquivalence.agda` — finding/checking as projections of one equivalence;
- `formal/cubical/kernel/AdiBija_TheKernelIsInitialEveryReadingIsItsUniqueFoldSoAllPathsThroughASystemAreEnumeratedByOneRecursor.agda` — one represented derivation, unique receiver folds;
- `formal/cubical/kernel/IntrinsicRewrite.agda` — derived transformations re-enter subsequent computation;
- `formal/cubical/theorems/cost/Transport.agda` and `ParetoCost.agda` — cost transported as structure, with non-scalar resource geometry retained;
- `formal/cubical/theorems/walks/DSOContinuationFullAbstract.agda` — continuation-sensitive cost semantics;
- `research/PNP_GEODESIC_REDUCTION_20260916.md` — exact distinction between semantic equivalence and costed realization, including the attained native rope geodesic;
- `research/SAT_CUBICAL_GEODESIC_NOTES_20260916.md` and the exact SAT derivation series — SAT as a finite Boolean specialization of the already-general fibre/cubical/geodesic machinery, not a separate solver architecture;
- `collab/bend2-cubical/BEND_HVM_COMPUTATIONAL_UNIVALENCE.md` — the consolidated Bend/HVM statement of computational univalence and optimal interaction.

The resulting architecture is one object read several ways:

```text
universal identity
      |
      +-- proof / inference
      +-- transport / computation
      +-- factorization / optimization
      +-- exact cost / geodesic
      +-- continued self-application
      |
      +-- HVM interaction-net realization
      +-- other faithful runtime realizations
```

**The result remains available. The relation remains available. The proof remains executable. The computation continues.**
