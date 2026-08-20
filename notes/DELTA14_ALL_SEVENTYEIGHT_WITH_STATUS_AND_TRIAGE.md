# Delta 14, all seventy-eight, with status and triage

Handle: `cf-tessera-z-3`. Snapshot date: **2026-08-20**, taken *before* the
module this note ends with was written. That ordering matters and is stated
first because **this check erases its own reading**: T14.4 and T14.5 were
UNNAMED when the count was taken and are CHECKED by the time you read it.

Source: **Delta 14**, owner transmission, session transcript
**2026-08-14T04:09:27Z**, "Univalent Perspectival Mathematics — Theorem
factory I", preserved verbatim at
`notes/reflection_ground--owner-messages-FULL-TRANSCRIPT-20260812-to-20260820.md`
(message n=56). Its preface: *"You must write this into the natural machine
core."* His own status line on it: *"exact/standard results + explicit
conjectural program. No novelty claims."*

---

## 0. The measurement, and the three defects in the measurement I was handed

The count that opened this task was **30 cited / 14 checked / 48 unnamed**.
Mine differs, and the difference is entirely in *how the grep was written*.
Three separate defects, all found by re-running:

1. **Substring false nonzero (mine, caught and discarded).** My own first
   pass used a bare boundary-anchored `(^|[^0-9.])14\.N([^0-9]|$)` across the
   whole repo. It matched *decimals*: `10.92--14.20 ms` in
   `collab/FAILURES.md`, `14.5` in `notes/DIVISOR.md`, `14.1` in
   `code/exp25_divisor_null.py`, and every `14.x` in
   `collab/upstream/library/raw/PRIME_PAIR_FIELD_AGENT_HANDOFF_2026-08-11.md`
   — a file dated **two days before Delta 14 existed**. That pass reported
   T14.4 and T14.5 as cited in seven and fifteen files. They are cited in
   none. I discarded the pass rather than the finding.

2. **Homonym, live in the corrected pass.** After context-gating, T14.4 and
   T14.5 still showed one hit each, in
   `notes/Anirnita_TheOwnersStatedOpenProblemsAcrossTheWholeUpstreamCorpus.md`.
   Lines 190–191 of that file are **rows 14.4 and 14.5 of a different table**
   ("Global Net", "Physics comparison maps"). Not Delta 14 at all. Both are
   genuinely UNNAMED.

3. **Undercount from the other side, and this is the more interesting one.**
   A letter-anchored grep (`T14\.N`, `C14\.N`, …) misses
   `NaturalMachine.agda:421`, *"Programs 14.74-14.76"*, and
   `SetBaseNoMonodromy.agda:125`, *"14.76's search"* — range notation and a
   possessive. Gating on Delta-14 context instead of on the letter recovers
   both.

**And the defect that matters most is not a grep defect at all.**
`NaturalMachine/CenterRelative.agda` proves T14.1, T14.2, C14.3 and
discharges Program 14.71 — `ΦEquiv`, `Pair≡Centre = ua ΦEquiv`,
`Φ∘τ≡ρ∘Φ`, `transport-τ-is-ρ` — and **never writes a single theorem
number**. It quotes the directive's prose instead. Any count of "reaches a
checked lane" that greps for numbers reports that file as absent. Four items
were checked and invisible.

Conversely, `NaturalMachine/PerspectiveCore.agda` *writes* T14.19, T14.22,
D14.59, D14.61, P14.48, P14.65, C14.64, P14.67 — in an honesty ledger that
says each is **not** proved there. A count of "the number appears in a
`.agda` file" reports eight items as checked that are not.

So the number-grep is wrong in **both directions**, and neither error is
small. The table below therefore separates three things that the single word
"checked" was collapsing:

- **CHECKED** — a term exists in a module that typechecks.
- **CITED** — the number is written somewhere, and is not checked.
- **UNNAMED** — no file names it.

## Snapshot counts, 2026-08-20, pre-write

| | count |
|---|---|
| CHECKED (theorem numbers with a term) | **17** of 78 |
| Programs (§O) discharged | **6** of 8 (14.71–14.76) |
| CITED, not checked | **20** of 78 |
| UNNAMED | **41** of 78 |

Post-write, this session: CHECKED 19, UNNAMED 39.

Reproducing it. Gate the file set on Delta-14 context first —

```
grep -rlE "(T14\.|C14\.|P14\.|D14\.|DELTA 14|Delta 14|Program 14\.|Programs 14\.|Theorem factory)" \
  --exclude-dir=.git . | grep -vE '<the three copies of the transmission itself>'
```

— 19 files; then per `i`, boundary-anchored `(^|[^0-9.])14\.$i([^0-9]|$)`
inside that set only. Raw result: **39 cited, 39 unnamed**. Subtract the two
homonyms of defect (2) above and it is **37 cited, 41 unnamed**. The
CHECKED/CITED split inside the 37 is not greppable at all and was read by
hand out of the module headers, which is what §1 records.

---

## 1. The seventy-eight

His statements, quoted. Section letters are his.

### A. Center-relative geometry

| # | statement (his words) | status |
|---|---|---|
| T14.1 | "Let R be a commutative ring with 2 invertible. Define Φ(p,q)=((p+q)/2,(q-p)/2), Ψ(w,r)=(w-r,w+r). Then Φ:R²≃R² with inverse Ψ." | **CHECKED** `formal/cubical/NaturalMachine/CenterRelative.agda` (`ΦIso`, `ΦEquiv`, `Pair≡Centre`) — *number not written there*; written in `CenterRelativeIntegral.agda`, `PerspectiveCore.agda` |
| T14.2 | "For τ(p,q)=(q,p), ρ(w,r)=(w,-r), Φτ=ρΦ." | **CHECKED** `CenterRelative.agda` (`Φ∘τ≡ρ∘Φ`, `transport-τ-is-ρ`, `ρ-is-conjugate`) |
| C14.3 | "The S₂-action decomposes into the trivial representation on w and sign representation on r." | **CHECKED** `CenterRelative.agda` (`ρ`), `MeanStandardRep.agda` (`sign-rep₂`) |
| T14.4 | "The fiber p+q=s is equivalent to R by r↦(s/2-r,s/2+r)." | **UNNAMED at snapshot** → **CHECKED this session**, `NaturalMachine/TheFixedSumFibreIsTheRadiusLineAndHalfBuysOnlyTheInvolution.agda` (`fixedSumEquiv`) |
| T14.5 | "Symmetric functions on a fixed-sum pair fiber correspond to even functions of r; antisymmetric functions correspond to odd functions." | **UNNAMED at snapshot** → **CHECKED this session**, same module (`symmetricIsoEven`, `antisymIsoOdd`) |
| T14.6 | "For e:A≃B and predicates A₊,B₊, e restricts to A₊≃B₊ iff A₊(a)↔B₊(e a) for all a." | **CHECKED** (split, not as an iff — that file says so) `PerspectiveCore.agda` (`restricts-suff`, `restricts-nec`), `OrderedSectorBreak.agda` (`cone-restricts`), `PairReflectionSector.agda` |
| C14.7 | "Ambient equivalence can fail after sector selection precisely because the sector predicate is not invariant." | **CHECKED** `PerspectiveCore.agda` (`sector-not-inv`), `OrderedSectorBreak.agda` (`break-diagonal`, `sector-break`) |

### B. Higher arity

| # | statement | status |
|---|---|---|
| T14.8 | "R^k≃R×V_k by x↦(mean(x),x-mean(x)1)." | **CHECKED** `MeanStandardRep.agda` (`split₂`, `split₃`, general k §4) |
| T14.9 | "S_k fixes the center coordinate and acts by the standard representation on V_k." | **CHECKED at k=2,3 only** `MeanStandardRep.agda` (`mean₂-inv`, `dev₂-equivariant`, §3.3); general k explicitly not |
| C14.10 | "k=2 gives a one-dimensional sign representation." | **CHECKED** `MeanStandardRep.agda` (`sign-rep₂`) |
| T14.11 | "For k≥3 a transposition on V_k is not scalar: eigenvalue -1 has multiplicity 1 and +1 multiplicity k-2." | **CHECKED** `MeanStandardRep.agda` (`sw01ₖ-scalar→char2` at all k≥3; sharp form at k=3) |
| T14.12 | "Σ_{j≥0}tr(τ|Sym^j V_k)t^j=1/((1-t)^{k-2}(1+t))." | **CITED, explicitly not proved** `MeanStandardRep.agda` §5 ("NOT PROVED, AND NOT FAKED") |
| T14.13 | "In characteristic zero, R[V_k]^{S_k} is polynomial on primitive degrees 2,…,k." | **CITED** as his own "Known anchor"; not proved. `MeanStandardRep.agda`, `README.md`, five notes |

### C. Equivalence and computation

| # | statement | status |
|---|---|---|
| T14.14 | "For e:X≃Y and f:X→X, f^e=e f e^{-1} satisfies (f^e)^n=e f^n e^{-1}." | **CHECKED** `PerspectiveCore.agda` (`conj-iterate`) |
| C14.15 | "Fixed points, periods, and all conjugacy-invariant dynamical properties transport across e." | **CHECKED** (fixed points, periods) `PerspectiveCore.agda` (`conj-fixed`) |
| T14.16 | "If e,e^{-1} cost C_e,C_{e^{-1}} … prediction of f^t costs at most C_e+C_Y(t)+C_{e^{-1}} plus composition overhead." | **UNNAMED** |
| C14.17 | "Any representation-independent irreducibility claim must survive efficient equivalence changes." | **UNNAMED** |
| P14.18 | "Syntax-relative irreducibility need not survive equivalence: an efficiently decodable obfuscation can make trivial dynamics look syntactically difficult." | **UNNAMED** |

### D. Fibers and reconstruction

| # | statement | status |
|---|---|---|
| Known T14.19 | "q:A→B is an equivalence iff every homotopy fiber fib_q(b)=Σ_{a:A}(q a=b) is contractible." | **CITED, explicitly not re-proved** `PerspectiveCore.agda` (library fact) |
| C14.20 | "Exact reconstruction is contractibility of ambiguity fibers, not merely singleton cardinality in a set shadow." | **UNNAMED** |
| T14.21 | "A section s:B→A of q makes every fiber inhabited, but not necessarily contractible." | **CHECKED** `PerspectiveCore.agda` (`section→inhabited`) |
| Known T14.22 | "A path p:b=b' induces an equivalence fib_q(b)≃fib_q(b')." | **CITED, explicitly not re-proved** `PerspectiveCore.agda` |
| C14.23 | "Loops in B act by automorphisms of fibers: monodromy is intrinsic to reconstruction." | **UNNAMED** |
| P14.24 | "A two-point fiber alone implies no nontrivial monodromy: B×2→B is the counterexample." | **CHECKED** `PerspectiveCore.agda` (`constMonodromy`) |
| C14.25 | "A binary arithmetic obstruction requires nontrivial transport/sheet exchange, not merely a residual bit." | **CHECKED** `PerspectiveCore.agda` (`twoPointNoObstr`), `SetBaseNoMonodromy.agda`, `SieveScaleTower.agda` |
| Known T14.26 | "For A→^q B→^r C, fib_{rq}(c) ≃ Σ_{b:B}(r b=c)×fib_q(b), with dependent path data." | **UNNAMED** |
| C14.27 | "Information lost through successive observations is nested/dependent and need not decompose into independent lost bits." | **UNNAMED** |

### E. Relations and parametricity

| # | statement | status |
|---|---|---|
| T14.28 | "Relation preservation is closed under identity and composition." | **UNNAMED** |
| T14.29 | "For e:A≃B, graph relation R_e(a,b):=(e a=b) is preserved by conjugate maps." | **UNNAMED** |
| P14.30 | "Useful abstractions need not be functional: simulation/bisimulation may be many-to-many." | **UNNAMED** |
| T14.31 | "For a set-valued family of contexts C, x~y iff ∀c,C_c(x)=C_c(y) is an equivalence relation." | **UNNAMED** |
| P14.32 | "Quotienting by this relation can erase proof-relevant information about why contexts agree." | **UNNAMED** |

### F. Descent / effective laws

| # | statement | status |
|---|---|---|
| T14.33 | "Descent witnesses paste under sequential composition." | **UNNAMED** |
| T14.34 | "If q,r are equivalences, every f descends uniquely up to identity via g=r f q^{-1}." | **UNNAMED** |
| Set T14.35 | "For surjective q:X→Z and f:X→Y, g with f=gq exists iff f is constant on q-fibers." | **UNNAMED** |
| C14.36 | "A deterministic effective law on compressed variables exists exactly when rich dynamics respects the observational equivalence." | **UNNAMED** |
| T14.37 | "If q,r and g are cheap while f is expensive, the descent square yields observer-relative computational reduction without full reconstruction." | **CITED** only, `notes/reflection_stream--cf-tessera--20260819T212627Z.md`, and there as an *example of a header claim that would need checking* |
| C14.38 | "Full dynamics can be computationally irreducible while a localized observable dynamics is reducible." | **UNNAMED** |

### G. Towers and scale

| # | statement | status |
|---|---|---|
| P14.39 | "Adjacent lift existence need not imply a coherent global lift through an infinite tower without extra hypotheses." | **CITED, honoured not proved** `SieveScaleTower.agda` §6 (that file says so in its own words) |
| T14.40 | "A finite composite of equivalences is an equivalence." | **UNNAMED** |
| T14.41 | "A finite composite whose fibers are all contractible has contractible total fibers." | **UNNAMED** |
| P14.42 | "Local neutralization of individual coordinates need not destroy global information: correlation can migrate to dependence with an unresolved tail." | **UNNAMED** |
| Bound 14.43 | "For ±1-valued A,B, surviving covariance is bounded by mutual information via Pinsker-type inequalities; hence nontrivial residual correlation requires residual dependence." | **UNNAMED** |

### H. Graded / dependent charge

| # | statement | status |
|---|---|---|
| T14.44 | "A total-space map T:Σ_cG(c)→Σ_cG(c) restricts to G(c₀) iff its base component preserves c₀." | **CHECKED** `PerspectiveCore.agda` (`restrict-fibre`), `ChargeGradedPeeling.agda` §4 |
| T14.45 | "If it sends c₀ to c₁ and p:c₁=c₀ is supplied, transport along p returns the output to G(c₀)." | **CHECKED** `PerspectiveCore.agda` (`transport-back`) |
| C14.46 | "Canonical closure is dependent-index preservation up to specified transport." | **CHECKED** `PerspectiveCore.agda`, `ChargeGradedPeeling.agda` §5 (`P¹`, `P²`) |
| P14.47 | "A transformation simple on total/grand-canonical space can become globally coupled after conditioning to a fixed fiber." | **UNNAMED** |

### I. Direction

| # | statement | status |
|---|---|---|
| P14.48 | "Identity paths are reversible; genuinely irreversible reduction cannot be faithfully represented by identity types alone." | **CITED, explicitly absent** `PerspectiveCore.agda` ledger ("Nothing from §I") |
| C14.49 | "Groupoid completion of a directed process can erase causal distinction by formally adjoining inverses." | **UNNAMED** |
| C14.50 | "Computation, sieve stopping, evolution and causal process require directed higher structure in addition to univalent identity." | **UNNAMED** |

### J. Perspective atlas

| # | statement | status |
|---|---|---|
| D14.51 | "A perspective atlas is a higher diagram of representations with explicit comparison morphisms/cells." | **UNNAMED** |
| D14.52 | "A generative defect is an empty or noncontractible comparison type where canonical reconciliation was expected." | **UNNAMED** |
| P14.53 | "Reconciliation can exist nonuniquely; automorphisms give immediate examples." | **UNNAMED** |
| T14.54 | "Aut(A)=A≃A acts on dependent/functorial structure over A by transport." | **UNNAMED** |
| C14.55 | "Symmetry is self-perspective: nontrivial self-equivalences generate transported actions." | **UNNAMED** |

### K. Context

| # | statement | status |
|---|---|---|
| P14.56 | "From Γ₁⊢P and Γ₂⊢¬P one cannot infer contradiction until the judgments are compared in a common compatible context." | **UNNAMED** |
| C14.57 | "Perspective contradiction should trigger context comparison, not averaging." | **UNNAMED** |
| D14.58 | "A context translation is adequate for P when it transports P's interpretation coherently." | **UNNAMED** |

### L. Representation gain and irreducibility

| # | statement | status |
|---|---|---|
| D14.59 | "Representation gain G(e;f)=C(f)-C(f^e), with costs of e/e^{-1} charged separately when operational." | **CITED, explicitly absent** `PerspectiveCore.agda` ledger |
| T14.60 | "Semantic invariants under equivalence remain unchanged while representation gain can be nonzero." | **UNNAMED** |
| D14.61 | "A univalent task-relative prediction cost is the infimum over admissible efficient equivalences of encode + predict-conjugate + decode cost." | **CITED, explicitly absent** `PerspectiveCore.agda` ledger |
| C14.62 | "A robust computational irreducibility claim should lower-bound this equivalence-optimized cost, not one arbitrary syntax." | **UNNAMED** |

### M. Perspective reconciliation generates closure

| # | statement | status |
|---|---|---|
| Known T14.63 | "ua(e):A=_U B induces transport P(A)→P(B)." | **UNNAMED** (the mechanism is used throughout `NaturalMachine/`; the number is written nowhere) |
| C14.64 | "One proved equivalence can generate an entire family of downstream transported results without separate comparison proofs." | **CITED** `PerspectiveCore.agda`, `notes/DELTA14_PROGRAMS_72_73.md` |
| P14.65 | "The value of discovering an equivalence can therefore be superlinear in the number of already-developed dependent constructions on either side." (his own note: "an operational observation, not a canonical numerical theorem") | **CITED** `PerspectiveCore.agda` |

### N. Failure modes

| # | statement | status |
|---|---|---|
| P14.66 | "Similar invariants do not imply equivalence." | **UNNAMED** |
| P14.67 | "Many-to-one observation does not imply the erased structure is irrelevant to future contexts." | **CITED** `PerspectiveCore.agda` |
| P14.68 | "Nontrivial fiber cardinality does not imply cohomological obstruction." | **UNNAMED** |
| P14.69 | "A theorem in one conditioned ensemble need not transport to another without an explicit relation/coupling preserving hypotheses." | **UNNAMED** |
| P14.70 | "Proposition-valued equality can erase path multiplicity relevant to later composition." | **UNNAMED** |

### O. Programs

| # | statement | status |
|---|---|---|
| 14.71 | "Formalize Φ and exchange-reflection conjugacy in Cubical Agda and invoke univalence computationally." | **DISCHARGED** by `CenterRelative.agda`, which does not write the number; `PerspectiveCore.agda` and `Anirnita…md` both record it as not found |
| 14.72 | "Formalize the positive-cone subtype and prove the exact nonrestriction statement." | **DISCHARGED** `OrderedSectorBreak.agda`, `notes/DELTA14_PROGRAMS_72_73.md` |
| 14.73 | "Formalize R^k≃R×V_k and S_k action for k=2,3." | **DISCHARGED** `MeanStandardRep.agda` |
| 14.74 | "Encode charge as a dependent index/family and least-prime peeling as a directed transformation of indexed states." | **DISCHARGED (partly)** `ChargeGradedPeeling.agda`; the *directed* half is P14.48's gap |
| 14.75 | "Build the scale tower O_z and compute finite homotopy fibers of charge-forgetting observations." | **DISCHARGED** `SieveScaleTower.agda` |
| 14.76 | "Search for actual loop transport on those fibers; if every loop acts trivially, kill the parity-monodromy route." | **DISCHARGED, verdict negative** `SetBaseNoMonodromy.agda` (`setNoMonodromy`) |
| 14.77 | "Build exact comparison relations among pair-field, Hahn, affine and finite-adic representations; classify each as equivalence/map/relation/asymptotic/unknown." | **CITED, not worked** `Mula…md`, `Anirnita…md` |
| 14.78 | "Search for the first nontrivial theorem that transports computationally across a proved representation equivalence rather than being reproved." | **CITED, not worked** `Anirnita…md`, `reflection_stream--cf-tessera…md` |

---

## 2. Triage of the forty-one unnamed

### (a) One module away — everything needed already exists as a checked term here, or in cubical v0.5 on this container

**Fifteen** of the forty-one. Listed first because that is where the
deliverable is.

| # | what it needs, all present | where |
|---|---|---|
| **T14.4** | `CommRing`, `Σ≡Prop`, `is-set`, `solve` | **taken this session** |
| **T14.5** | T14.4 + `isPropΠ` + `funExt` | **taken this session** |
| T14.26 | `fiber`, `Σ-assoc-Iso`, `ΣPathP` | `Cubical.Foundations.Prelude`, `Cubical.Data.Sigma` |
| T14.28 | nothing but composition | pure |
| T14.29 | `_≃_`, `funExt`; and `NaturalMachine.PerspectiveCore.conj-iterate` for the conjugate side | `PerspectiveCore.agda` |
| T14.31 | `isSet` codomain, `funExt`; the equivalence-relation record | `Cubical.Relation.Binary` |
| T14.33 | `_∙_`, `cong`, `GroupoidLaws` | `Cubical.Foundations.GroupoidLaws` |
| T14.34 | `compEquiv`, `invEquiv`, `isContrSingl`, `preCompEquiv` — the uniqueness half is contractibility of a singleton and is the part worth doing | `Cubical.Foundations.Equiv` |
| T14.40 | `compEquiv`; state it over a `List`/`Vec` of equivalences or it is a green triviality | `Cubical.Foundations.Equiv`, `Cubical.Data.Vec` |
| T14.41 | T14.19 (`isEquiv` ⇔ contractible fibres, `Cubical.Foundations.Equiv`) + T14.40 | library |
| T14.54 | `ua`, `transport`, `pathToEquiv`; `NaturalMachine.PathIsSymmetry.agda`, `StructuredSymmetryTransport.agda`, `Transport.agda` already carry the idiom | `Cubical.Foundations.Univalence` |
| P14.53 | a **witnessed** non-uniqueness: `notEquiv : Bool ≃ Bool` and `notEq ≢ refl` | `Cubical.Data.Bool` |
| P14.66 | two types with a shared coarse invariant and no equivalence; `Unit` vs `Bool`, invariant "inhabited" | `Cubical.Data.Unit`, `Cubical.Data.Bool` |
| P14.70 | `∥_∥₁` collapsing `refl` and `notEq` on `Bool ≡ Bool` | `Cubical.HITs.PropositionalTruncation` |
| T14.63 | `ua`, `subst` — one line as literally stated | `Cubical.Foundations.Univalence` |

A warning attached to five of these. **T14.28, T14.40, T14.63, T14.29, T14.31
are green trivialities as literally stated.** Each is one library lemma
renamed. Writing them for the checkmark would grow the count and nothing
else. They belong in group (a) because they are reachable, not because they
are worth reaching, and the honest form of each is the *guarded* form —
T14.40 over an arbitrary finite chain rather than a pair; T14.28 with a
witnessed non-preservation to show the closure is not vacuous.

### (b) Needs one missing object

**Twenty-two** of the forty-one. The missing object, named exactly, per
cluster.

| # | missing object |
|---|---|
| T14.16, C14.17, P14.18, C14.38, T14.60, C14.62 | **a cost model that charges `e` and `e⁻¹` separately** — i.e. a type of admissible efficient equivalences carrying a cost, and an order on costs. `NaturalMachine.TransportCost.agda`, `CostGeometry.agda`, `TransportPrice.agda` exist and none of them is that; `PerspectiveCore.agda`'s own ledger records D14.59 and D14.61 as absent, which is why this whole cluster is blocked on one definition |
| Set T14.35, C14.36 | **a surjection with the choice-free universal property**. `Cubical.Functions.Surjection` IS present on this container, so this may collapse into (a) on inspection; what is genuinely missing is the *fibre-constancy* side, `f` constant on `q`-fibres as a `∃`-truncated statement whose eliminator lands in a set |
| C14.20, C14.23, C14.27 | **an "ambiguity fibre" object** distinct from the set-shadow — i.e. the reconstruction map named as a map, not as a count. `SieveFiber.agda` and `LiftingFiberResidue.agda` are the nearest |
| D14.51, D14.52, C14.55, C14.57, D14.58, P14.56 | **a perspective atlas as a type**: a diagram of representations with comparison *cells*, not comparison functions. `AtlasResiduals.agda` names atlases and does not carry 2-cells |
| P14.30, P14.32 | **a simulation relation type** that is not required to be functional. `RelationalProcessCore.agda`, `ObservabilityQuotient.agda` are close |
| P14.47 | **conditioning as an operation** on a graded/total space |
| P14.68 | **a cohomology functor to compare against**. `GroupCohomologyH2.agda`, `PMGaugeCohomology.agda` exist; what is missing is the statement that binds fibre cardinality to a class |
| P14.69 | **two conditioned ensembles and a coupling between them** |

### (c) Needs a lane this container does not have

**Four** of the forty-one. 15 + 22 + 4 = 41.

| # | the absent lane |
|---|---|
| **Bound 14.43** | ℝ with a logarithm, mutual information, and Pinsker's inequality. **Not reachable in any lane on this disk** — see §4 |
| P14.42 | the same measure-theoretic lane, plus a limit over the tower |
| C14.49, C14.50 | **directed type theory**. Cubical v0.5 has no directed interval and no hom-type with a direction; the repository has no such lane. `PerspectiveCore.agda` records §I as untouched for this reason |

Three already-CITED items sit behind the same walls and are recorded here so
the walls are counted once: **P14.48** (directed type theory, same as
C14.49/C14.50), **T14.12** (a graded symmetric power with a group action and
a formal power series in `t` over it), **T14.13** (characteristic-zero
invariant theory).

---

## 3. What was taken, and what it refutes of mine

`formal/cubical/NaturalMachine/TheFixedSumFibreIsTheRadiusLineAndHalfBuysOnlyTheInvolution.agda`
— **T14.4 and T14.5**, `--cubical --safe`, Agda 2.6.3 / cubical v0.5, **EXIT 0**,
no postulates, no holes.

Six sections. §1 is T14.4 by his own map, over any `(R, half)` with
`half + half ≡ 1r`. §3 is the conjugacy at the fibre. §4 is T14.5, both
halves, as isomorphisms of Σ-types — function *together with* its
invariance proof, because dropping the proof is his own P14.70. §5 is the
guards. §6 discharges the guards' hypothesis at ℚ.

**The refutation, and it is of my own reading of the transmission.** I began
the module believing T14.4 needs `2` invertible, because it sits in §A after
T14.1 and is stated with `s/2`. It does not. §2 of the module proves

> `fixedSumEquiv-noHalf : (s : ⟨ R ⟩) → FixedSum s ≃ ⟨ R ⟩`

over **any** commutative ring, no hypothesis at all, by `q ↦ (s − q , q)`.
The `s/2` is not in the theorem. This is not new mathematics — it is the
standard translation-equivalence, `is-binary-equiv-add-Ring` at
`/root/agda-libs/agda-unimath/src/ring-theory/rings.lagda.md:233`, and I name
it there rather than claim it.

What `half` actually buys is stated and checked, and it is the useful part:
under the free coordinate `q`, the exchange `τ(p,q) = (q,p)` becomes the
**affine** involution `q ↦ s − q`, whose fixed point moves with `s`
(`NoHalf.τF-free`). Under his centred coordinate `r` it becomes `r ↦ −r`,
**linear**, fixed point at 0, the same in every fibre (`toR-τ`,
`fromR-neg`). So `half + half ≡ 1r` at T14.4 is not buying the equivalence.
It is buying a **simultaneous linear normal form for the exchange across all
fibres** — which is exactly what T14.5 then consumes, and it is why T14.5
cannot even be *stated* in the free coordinate: "even function of `r`" has no
meaning for `q ↦ s − q`.

**Guard negatives.** T14.5 is an isomorphism of function spaces over the
fibre and would be green and empty over a one-point fibre, so:

- `fibre-two-points` — a **witnessed non-identity**, two named points of the
  fibre and a proof they differ, from `¬ (0r ≡ 1r)` alone. Not a cardinality
  count.
- `two≡zero→trivial` — in any ring carrying `half`, `1r + 1r ≡ 0r` forces
  `0r ≡ 1r`. Characteristic 2 is excluded by the hypothesis, not by taste.
- `even-not-odd` — the **control**: the constant `1r` is even and *not* odd,
  so `antisymIsoOdd` is not `symmetricIsoEven` renamed. A version of §4 in
  which the two classes coincided would still typecheck and would be
  worthless.
- §6 discharges all three hypotheses at **ℚ**: `half = [1/2]`,
  `half + half ≡ 1` by `eq/ _ _ refl`, and `¬ (0 ≡ 1)` through `eq/⁻¹` into
  `QuoInt` and `abs` into ℕ. So the guards are not conditionals waiting on a
  ring nobody supplies.

**How it could be true and irrelevant.** Nothing downstream consumes
`fixedSumEquiv` or `symmetricIsoEven`. The honest description is "a section
of §A closed, with one instantiation", not "a tool in service". The §2
finding is the part that carries content independently of use, because it
changes what T14.4 asserts.

**Container note.** `CenterRelative.agda` is cited, not imported: it is
written against the repository pin (Agda 2.8.0, cubical v0.9) and uses
`solve!`, which does not exist here (the macro is `solve`, in the ∀-form).
The `(R, half)` setting is restated, minimally. Nothing re-proves T14.1 or
T14.2.

---

## 4. The largest thing nobody can currently reach

**Bound 14.43.** *"For ±1-valued A,B, surviving covariance is bounded by
mutual information via Pinsker-type inequalities; hence nontrivial residual
correlation requires residual dependence."*

It is the only item in the forty-one that is a **quantitative inequality**
rather than a structural statement, and it is the load-bearing half of §G:
without it, P14.42's "correlation can migrate to dependence" is a slogan and
the scale tower has no bound on what survives coarse-graining. It is what
`SieveScaleTower.agda` would need to say anything about the *tail* rather
than about adjacent lifts.

Why nobody can reach it, checked rather than assumed:

- **The cubical lane has no ℝ.** Cubical v0.5 on this container has ℚ
  (`Cubical.HITs.Rationals.QuoQ`) and no reals, no logarithm, no
  entropy. agda-unimath has Dedekind reals but is not on this repository's
  include path.
- **The Lean lane does not have Pinsker either.** `mathlib4` on this disk has
  `Mathlib/InformationTheory/KullbackLeibler/{Basic,ChainRule,DataProcessing}.lean`
  — KL divergence, its chain rule, and the data-processing inequality — and
  a grep for `Pinsker` across all of `Mathlib/` returns **nothing**. So the
  inequality is not available to import; it would have to be proved.
- And `formal/pairfield/` does not import mathlib's `InformationTheory` at
  all.

So Bound 14.43 needs, in order: a real-number lane, a logarithm with its
convexity, a definition of mutual information, and then Pinsker — none of
which exists in either lane here, and the last of which is not in mathlib
either. That is four objects, not one, which is why it is (c) and not (b),
and why it is the largest.

Its twin **P14.42** is blocked by the same lane and would additionally need a
limit over the tower.

---

## 5. One defect in a live hook, reported not fixed

`.claude/hooks/source-coverage.sh:61`:

```
report 'Bhāskara|Bhaskara'  'Bījagaṇita|…|Siddhānta-Śiromaṇi|…' 'Bhāskara II' 'Siddhānta-Śiromaṇi'
```

The author pattern matches **Bhāskara I** (c. 629, the *Āryabhaṭīyabhāṣya*
and the *Mahābhāskarīya*) and **Bhāskara II** (1114–1185) identically, and
then reports the pooled author count against Bhāskara II's works alone. Every
mention of Bhāskara I in `notes/` inflates the coverage figure for a man born
five centuries later. That is the homonym defect, live, in the hook whose
whole job is to catch under-attention to sources.

Line 60's `'Brahmagupta|Brahmagupt'` is redundant rather than wrong (the
second alternative is a prefix of the first), and line 62's `Chandah`
alternative will match any word beginning `Chandah`.

It is another identity's file. Reported here; not touched.
