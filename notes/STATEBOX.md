# Statebox: prior art, and a source audit of what was actually built

**Status: `SEARCH` item, executed. Prior-art survey plus a line-level audit of
the only public implementation of the project's categorical core.** Audit date
2026-08-13, handle `opus-statebox`. No numerics were run and none are called
for: every claim below is a statement about a text, a git history, or standard
type theory. Two propositions (§5) are proved.

The reason this note belongs in *this* repository is stated in §6, and it is
not analogy. Statebox's public formalization stops at exactly one construction
— *the quotient of a free structure by its intended laws, carrying its
operations* — and that construction is the one already proved here
(`notes/COMPOSITIONAL_CRYSTAL_THEOREM.md`) and machine-checked here
(`formal/pairfield/Pairfield/FutureBehavior.lean`). The two holes left in the
Statebox code, `?preserveId` and `?preserveComposition`, are literally the
Lean lemma this corpus already has.

---

## 1. Provenance and reachability

- Statebox (Stichting Statebox, Amsterdam) was a project — company plus
  research group — building a visual, compositional, formally verified process
  language on Petri nets and category theory. Announced to the categorical
  community by Baez in January 2018 ([Azimuth][az2018], mirrored at the
  [n-Category Café][ncc2018]).
- **Direct fetches of `arxiv.org`, `semanticscholar.org`, `ncatlab.org`,
  `golem.ph.utexas.edu`, `math.ucr.edu` and `researchgate.net` are all egress
  blocked in this environment; `git` over HTTPS to GitHub is not.** Everything
  in §2–§3 below is therefore reported from search-engine abstracts and is
  marked *reported*, not *read*. Everything in §4 is **read**: it is quoted
  from a clone.
- Clone: `https://github.com/statebox/idris-ct.git`, full history, 361 commits
  across all refs. Referenced commits:
  `master` = `fbc7f63` (2020-04-20), `free-marcosh` = `d696bf6` (2019-06-11),
  `free-andrek` = `3c54b5f` (2019-09-11), `quotients` = `5a9201e`
  (2019-09-02), `span` = `f1e522f` (2019-10-30), `idris2` = `ff2dfc6`
  (2020-05-05).
- Repository probing: of the plausible names tried, only `statebox/idris-ct`,
  `statebox/statebox` (14 commits, unrelated Lamassu process diagrams, last
  2018-08-17), `statebox/awesome-applied-ct` and `statebox/cql` resolve
  publicly. The PureScript stack (`stbx-*`) was not reachable under the names
  tried; **it may exist under names I did not guess, or be private.** §4's
  negative claims are scoped to `idris-ct`, and say so.
- Company status: Crunchbase lists the organization as permanently closed
  (reported). Independently, every public repository above is dormant since
  2020; the mathematical output stops in 2021.

## 2. What Statebox was trying to be

*Reported.* A "universal language of distributed systems": Petri nets as the
process notation, string/brick diagrams as the surface syntax, free symmetric
monoidal categories as the semantics of executions, dependent types
(Idris, and the `typedefs` format) for data, open games for incentives, and a
blockchain for the execution log. Jelle Herold originated the idea — Petri-net
process tooling for businesses in the mid-2000s — and Fabrizio Genovese led the
mathematics.

The published corpus (all *reported*, none read here):

| year | paper | content |
|---|---|---|
| 2018 | Genovese–Herold, *Executions in (Semi-)Integer Petri Nets are Compact Closed Categories* (QPL 2018) | places may hold negative token counts; the category of executions is compact closed, and the construction is **functorial** |
| 2019 | Genovese–Gryzlov–Herold–Perone–Post–Videla, *Computational Petri Nets: Adjunctions Considered Harmful* (arXiv:1904.12974) | reviews net→FSMC constructions, argues previous approaches fail because they chase an adjunction; states requirements for implementability; announces an Idris library |
| 2019 | Genovese, *The Essence of Petri Net Gluings* (arXiv:1909.03518) | net duality as a functor; tensor product of nets; category of nets symmetric monoidal closed |
| 2019 | Statebox Team (Genovese–Herold), *The Mathematical Specification of the Statebox Language* (arXiv:1906.07629) | the whole stack; cubical-pasting-diagram variant used for the visual language |
| 2020 | Genovese–Herold(–Gryzlov?), *A Categorical Semantics for Guarded Petri Nets* (ACT/ICGT) | guards via functorial semantics |
| 2021 | *A Categorical Semantics for Hierarchical Petri Nets* (arXiv:2102.00096) | parent-net transitions refine to child-net executions; functorial semantics into **spans of sets** |

## 3. The mathematical problem the project ran into

*Reported, and standard.* It is worth stating precisely, because it is a
quotient problem and this corpus is about quotients.

A Petri net has places $S$, transitions $T$, and input/output maps
$T\to\mathbb{N}[S]$ into the free commutative monoid on places: a transition
consumes and produces *multisets* of tokens. An execution should be a morphism
in a monoidal category whose objects are markings and whose tensor is
concurrency. Two readings of what an execution *is*:

- **Collective token philosophy.** Tokens in a place are indistinguishable. The
  executions form the free **commutative** monoidal category on the net — a
  symmetric monoidal category in which the symmetry is the *identity*. This
  assignment is a left adjoint, hence functorial.
- **Individual token philosophy.** Tokens carry identity, so it matters *which*
  of the two tokens in a place was consumed — this is what distinguishes causal
  independence from causal dependence (van Glabbeek, *The Individual and
  Collective Token Interpretations of Petri Nets*, CONCUR 2005). Executions
  should form the free **symmetric strict** monoidal category. This assignment
  is **not** functorial in the net and admits no universal property: to name a
  transition's input as a *word* rather than a multiset one must choose a
  linear order, and net morphisms — which may merge places, changing
  multiplicities — do not preserve the choice.

Bruni–Meseguer–Montanari–Sassone repaired this by changing the *syntax*, not
the semantics: a **pre-net** equips each transition with ordered input/output
lists, i.e. carries the choice in the object, and pre-nets do generate free
strict monoidal categories functorially (*Functorial Models for Petri Nets*,
Inf. Comput. 170(2), 2001). Baez–Genovese–Master–Shulman later unified the
zoo: **Σ-nets** interpolate, and the three left adjoints are
pre-nets → strict monoidal, Σ-nets (including Kock's whole-grain nets) →
symmetric strict monoidal, Petri nets → commutative monoidal
(*Categories of Nets*, LICS 2021, arXiv:2101.04238).

The Statebox position (*Adjunctions Considered Harmful*) was that for an
*implementation* the adjunction is the wrong thing to want: one needs a
computable normal form for executions, and pre-nets give it. Stated in this
corpus's vocabulary: **forgetting token identity is compositional; restoring it
requires a section, and sections do not compose.**

## 4. What was actually built: `statebox/idris-ct`, read

`idris-ct` is the categorical core: literate Idris 1 (75 `.lidr` files on
`master`), plus an incomplete Idris 2 port. It is AGPL, © Stichting Statebox.
The following are verified statements about the clone in §1.

**(a) There is no Petri net in it.** The string `petri`, case-insensitive,
occurs in **zero** of the 361 commits reachable from all refs; no file in any
branch's history is named for nets. What exists on `master` is the standard
scaffolding — categories, functors, natural transformations, (co)limits, comma
categories, monads, spans-of-nothing, monoidal/symmetric monoidal categories,
lenses, profunctors, Day convolution. The library that *Adjunctions Considered
Harmful* announces (*reported*: "introduces an Idris library which implements
them") is, in its public form, the scaffolding without the nets. If net code
exists it is elsewhere and was not reachable under the names tried (§1).

**(b) `master`'s symmetric monoidal category is stated with a hole.**
`src/MonoidalCategory/SymmetricMonoidalCategory.lidr:58`, in the *type* of the
constructor:

```idris
-> ((a, b, c : obj (cat monoidalCategory)) -> AssociativityCoherence
       (cat monoidalCategory) (tensor monoidalCategory)
       ?associator -- should be (associator monoidalCategory)
       symmetry a b c)
```

So on `master` the hexagon that a symmetric monoidal category must satisfy is
demanded of an unelaborated metavariable. The `idris2` branch fixes it
(`associator monoidalCategory`, `idris2/.../SymmetricMonoidalCategory.idr:35`).
This is the only hole on `master`.

**(c) The free symmetric monoidal category exists only on unmerged branches,
and it is not a quotient.** `free-marcosh`/`free-andrek` add
`src/MonoidalCategory/FreeMonoidalCategory.lidr`, which builds the term type

```idris
data PreFreeMorphism : (t : Type) -> (generatingMorphisms : List (List t, List t))
                    -> (domain, codomain : List t) -> Type where
  MkIdFreeMorphism, MkSymmetryFreeMorphism, MkCompositionFreeMorphism,
  MkJuxtapositionFreeMorphism, MkGeneratingFreeMorphism
```

and then, with the comment *"define the real data type which will represent the
quotient"*, defines

```idris
FreeMorphism = PreFreeMorphism
```

— the quotient is not taken. Its constructors are made `private` ("so that we
don't leak implementation details") and re-exported as smart constructors, and
then **all ten categorical laws are `postulate`d as propositional equalities of
terms**: `freeLeftIdentity`, `freeRightIdentity`, `freeAssociativity`,
`freeTensorPreserveId`, `freeTensorPreserveCompose`, `freeTensorAssociative`,
`freeTensorPreserveSwap`, `freeSymmetryIsInvolution`, `freeUnitCoherence`,
`freeAssociativityCoherence`. These postulates *are* the fields of the
`Category`, `StrictMonoidalCategory` and `StrictSymmetricMonoidalCategory`
records the file exports. §5 shows they are refutable.

The universal property — the point of the word "free" — is the last thing in
the file and is unfinished:

```idris
fold : ... -> CFunctor (cat (smcat (generateFreeSymmetricMonoidalCategory t generatingMorphisms)))
                       (cat (smcat ssmc))
fold {ssmc} onObj onGeneratingMor = MkCFunctor
  onObj (foldOnMorphisms {ssmc} onObj onGeneratingMor)
  (\a => ?preserveId)
  ?preserveComposition
  -- TODO: this should really be a symmetric monoidal functor
```

Two holes, and a `TODO` conceding that a functor of underlying categories is
not what freeness requires. `foldOnMorphisms` moreover passes sub-terms
unrecursed in its composition and juxtaposition clauses
(`compose ... g1 g2` with `g1 : PreFreeMorphism a b`), so the file cannot
typecheck as committed; the branch tip is titled *"progress with free monoidal
category fold"* and was never merged. Idris 1 is no longer readily runnable, so
this was not re-typechecked — it is read off the types.

**(d) The honest re-do was started and abandoned.** Branch `quotients`
(2019-09-02) adds `src/Quotient/Quotient.idr`: a genuine quotient *specified by
its universal property* — a carrier, a projection that is a `RespectingMap`,
existence and uniqueness of factorizations — with `QuotientUnique` proved.
`UnsafeQuotient.idr` then supplies a witness: a private one-constructor wrapper
`InternalWrap`, an exported `Wrap`, and the single axiom

```idris
postulate QuotientEquality : (x : Type) -> (eq : EqRel x) -> (rel eq a b) -> Wrap a = Wrap b
```

Branch `free-andrek` begins rebuilding the free monoidal category on top of it
(`FreeQuotients.idr`: `FreeMorphism a b = UnsafeQuotient' (PreFreeMorphism a b)
(PreFreeMorphismEquality a b)`), gets as far as unit, associativity and
`FreeTensorIdEq`, and leaves the symmetric extension commented out. Nothing
from `quotients` or `free-*` reached `master`.

**(e) Same for the 2021 paper's semantics.** The `span` branch (2019-10-30,
"some progress on span bicategories") is the unfinished ingredient that the
hierarchical-nets paper's functorial semantics into spans of sets would need.

## 5. Two propositions

The interesting thing about (c) versus (d) is that both say `postulate`, and
they are not in the same position. Making that precise is the mathematical
content of this note.

### Proposition S1 (the free-monoidal postulates are refutable, not merely unproved)

*Fix `t : Type` and `gens : List (List t, List t)`. In*
`free-marcosh:src/MonoidalCategory/FreeMonoidalCategory.lidr`, *the axiom*
`freeLeftIdentity` *implies `Void` in Idris's own propositional equality.*

**Proof.** Instantiate at `as = bs = []` and `fm = idFreeMorphism []`. Since
`freeIdentity`, `compositionFreeMorphism` and `FreeMorphism` are definitionally
`MkIdFreeMorphism`, `MkCompositionFreeMorphism` and `PreFreeMorphism`, the
axiom yields

$$p \;:\; \mathsf{MkComp}\,(\mathsf{MkId}\,[])\,(\mathsf{MkId}\,[])
\;=\; \mathsf{MkId}\,[]
\qquad\text{in } \mathsf{PreFreeMorphism}\ t\ \mathit{gens}\ [\,]\ [\,].$$

Define $D:\mathsf{PreFreeMorphism}\ t\ \mathit{gens}\ [\,]\ [\,]\to\mathsf{Type}$
by pattern matching, $D(\mathsf{MkComp}\ \_\ \_)=\mathsf{Unit}$ and $D\,\_
=\mathsf{Void}$ on a catch-all clause; this is total. Then
`replace {P = D} p () : Void`. $\square$

The same instantiation refutes `freeRightIdentity`, `freeAssociativity`,
`freeTensorPreserveId`, `freeSymmetryIsInvolution` and `freeUnitCoherence`
(each equates distinct constructor applications), and `freeTensorAssociative`
and `freeAssociativityCoherence` follow with one further instantiation. This is
no-confusion for inductive families; it is not a subtlety of Idris.

The postulates are exactly the equations that hold in the **quotient** and fail
in the **carrier**. Asserting them of the carrier is not an unproved lemma; it
is a false axiom. Note that the constructors' being `private` does not repair
this — privacy bounds who can *exhibit* the contradiction, not whether the
theory has one — and the file's own comment shows the author knew which object
was wanted.

`UnsafeQuotient`'s `QuotientEquality` is refutable by the same route
(`InternalWrap` is an inductive constructor, hence injective, and the private
`unwrap` extracts the injectivity; take `x = Bool` with `True` related to
`False`). The difference is not consistency, it is **firewalling**: a real
quotient type is *primitive* (Lean's `Quot`, whose `Quot.sound` is an axiom
about a type with no exposed constructor), and Idris 1 has none, so the library
emulates one and names it `Unsafe`. What makes the emulation usable is that
every exported way out of the quotient demands a `RespectingMap`. Which is the
general fact:

### Proposition S2 (hiding implements the quotient's *observations*, never its equalities)

*Let $T$ be the term algebra of a signature, $\approx$ the congruence generated
by a set $E$ of intended equations, and let a module export the constructors
together with, for every model $M\models E$, an interpretation
$\mathrm{fold}_M:T\to M$ commuting with the operations. Then:*

1. *(soundness) $f\approx g \Rightarrow \mathrm{fold}_M f=\mathrm{fold}_M g$
   for every $M$ — by induction on the derivation of $\approx$, since each
   equation of $E$ holds in $M$;*
2. *(completeness) taking $M=T/{\approx}$ gives the converse;*
3. *hence no exported context separates $\approx$-related terms — the exported
   interface is observationally $T/{\approx}$ — while the internal equality of
   $T$ is strictly finer, and asserting $E$ of $T$ is refutable (S1).*

**Proof.** (1) is the induction; (2) is the projection $T\to T/{\approx}$,
which is a model interpretation because $T/{\approx}$ carries the operations —
and *that* is `COMPOSITIONAL_CRYSTAL_THEOREM` clauses (1)–(2), with $E$
generating a congruence contained in the kernel of every model observation. (3)
is (1)+(2) plus S1. $\square$

So the design in §4(c) had the right *instinct* — hide the constructors, and
observationally you have the quotient — and then destroyed it by additionally
asserting the laws inside. The instinct alone would have been sound; it needed
the eliminator (`fold`) to be finished, not the equations to be postulated.

## 6. What this corpus already has that the failure needed

Three items, in the order the Statebox code would have consumed them.

1. **The quotient exists and carries the operations.**
   `notes/COMPOSITIONAL_CRYSTAL_THEOREM.md`: $\equiv_o$ is the greatest
   $\Sigma$-congruence contained in $\ker(o)$; every basic operation descends
   uniquely; the projection has the universal factorization property. Take
   $\Sigma=\{\circ,\otimes\}$, $o=$ interpretation in models, and this *is*
   the free symmetric monoidal category on generators, with the universal
   property that `fold` was reaching for.
2. **Executing before quotienting equals executing after.**
   `formal/pairfield/Pairfield/FutureBehavior.lean`, machine-checked: the
   behavioral equivalence is an equivalence relation, is preserved by every
   action, the quotient carries the induced actions and observation, and
   running any action-word before quotienting gives the same result as running
   the induced actions afterwards. Under the dictionary
   *action-word* $\mapsto$ *composite of generators and symmetries*, that last
   clause is `?preserveComposition`, and the induced-identity clause is
   `?preserveId`.
3. **The loss is part of the result.** README's discipline, and
   `notes/LENS_ORDER_COMMUTATION.md`'s criterion, are the right frame for the
   token philosophies: collective-token semantics is the compression,
   individual-token semantics the refinement, and the pre-net is a *section* of
   the compression chosen at the syntax level. Sections do not compose — which
   is the whole content of "not functorial", and is the same phenomenon this
   corpus records when a compression fails to commute with another.

The transferable moral, and the reason a `SEARCH` item earned a note: **an
applied-category-theory stack failed at the same joint this repository
identified independently — the difference between a quotient and a hidden
carrier — and it failed by postulating what should have been proved.** That is
the `CLAUDE.md` rule with the sign flipped: there, a measurement stood in for a
derivation; here, an axiom did.

## 7. Queue

Both mathematical items this note opened are closed by construction, one of
them by refutation. What remains is reachability, not mathematics.

- ~~`PROVE` — **Fibers of the token-forgetting map** … the natural guess is
  boundary orbits.~~ **[REFUTED, and replaced by a theorem —
  `notes/TOKEN_PHILOSOPHY.md`. In a commutative monoidal category the symmetry
  is the identity, so naturality forces $f\otimes g=g\otimes f$ on morphisms;
  the collective quotient erases causality rather than boundary labels, and the
  final statement (Theorems 13–15) is that two firings commute exactly when the
  marking can host both at once. The fibre is a local trace class.]**
- ~~`PROVE` — **S2 with a restricted export list.** … compute the greatest
  congruence for the restricted class and check it still equals $\approx$.~~
  **[DISCHARGED by construction, not by argument. The question "is this export
  list observationally complete" is `COMPOSITIONAL_CRYSTAL_THEOREM`'s
  $\mathrm{cdim}$, and `machinery/compositional_crystal.py` computes it: an
  export list is complete exactly when the crystal it induces is discrete, the
  minimum complete sublist is `separating_contexts`, and `factor_map` decides
  whether a candidate observation factors. Run on the boundary algebra of
  `TOKEN_PHILOSOPHY.md` §9 it returns two fibres, twelve invisible equations
  and $\mathrm{cdim}=1$. Nothing here needed a new construction.]**
- `SEARCH` — **The three unread papers.** arXiv is egress-blocked from this
  container. §2–§3 are abstracts only. Before any of §3 is cited as established
  in a paper of this corpus, `1906.07629`, `1904.12974` and `2101.04238` must
  be read from primary source.
- `SEARCH` — **The PureScript stack.** Whether `stbx-core`/`stbx-lang` exist
  publicly under other names decides whether §4(a) reads "the nets were never
  formalized" or only "the nets were never formalized *in Idris*". This note
  claims only the latter.
- `SEARCH` — **Trace theory**, inherited from `TOKEN_PHILOSOPHY.md` §10: the
  theorems that lane produced reach Mazurkiewicz traces from the categorical
  side and must be checked against that literature before being described as
  new.

## 8. Honesty ledger

| claim | grade |
|---|---|
| §4(a)–(e): file contents, holes, postulates, branch tips, commit hashes | **verified** — quoted from the clone |
| §4(c) "cannot typecheck as committed" | **read off the types**, not re-run; Idris 1 unavailable |
| §5 S1, S2 | **proved** here |
| §2, §3: papers, adjunction results, token philosophies, pre-nets, Σ-nets | **reported** from abstracts; primaries unreachable (§7) |
| §1 company status | **reported** (Crunchbase); corroborated only by repository dormancy |
| §4(a) "no Petri net code" | **verified for `idris-ct`**; scoped — other repositories were not reachable |
| §7 fiber guess | ~~**conjecture**, flagged as such~~ **REFUTED** — `notes/TOKEN_PHILOSOPHY.md`, Theorems 2 and 5 |

[az2018]: https://johncarlosbaez.wordpress.com/2018/01/22/statebox-a-universal-language-of-distributed-systems/
[ncc2018]: https://golem.ph.utexas.edu/category/2018/01/statebox_a_universal_language.html
