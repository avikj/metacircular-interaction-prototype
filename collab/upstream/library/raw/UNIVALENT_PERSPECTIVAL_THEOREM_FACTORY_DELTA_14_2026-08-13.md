# Univalent Perspectival Mathematics — Delta 14
## Theorem factory I

Date: 2026-08-13
Status: exact/standard results + explicit conjectural program. No novelty claims.

### A. Center-relative geometry

**T14.1 (center-relative equivalence).** Let R be a commutative ring with 2 invertible. Define
Φ(p,q)=((p+q)/2,(q-p)/2), Ψ(w,r)=(w-r,w+r).
Then Φ:R²≃R² with inverse Ψ.

**T14.2 (exchange-reflection conjugacy).** For τ(p,q)=(q,p), ρ(w,r)=(w,-r),
Φτ=ρΦ.

**C14.3.** The S₂-action decomposes into the trivial representation on w and sign representation on r.

**T14.4 (fixed-sum fiber).** The fiber p+q=s is equivalent to R by r↦(s/2-r,s/2+r).

**T14.5.** Symmetric functions on a fixed-sum pair fiber correspond to even functions of r; antisymmetric functions correspond to odd functions.

**T14.6 (boundary restriction criterion).** For e:A≃B and predicates A₊,B₊, e restricts to A₊≃B₊ iff A₊(a)↔B₊(e a) for all a.

**C14.7.** Ambient equivalence can fail after sector selection precisely because the sector predicate is not invariant.

### B. Higher arity

Let k be invertible in R and V_k={x∈R^k:Σx_i=0}.

**T14.8.** R^k≃R×V_k by x↦(mean(x),x-mean(x)1).

**T14.9.** S_k fixes the center coordinate and acts by the standard representation on V_k.

**C14.10.** k=2 gives a one-dimensional sign representation.

**T14.11.** For k≥3 a transposition on V_k is not scalar: eigenvalue -1 has multiplicity 1 and +1 multiplicity k-2.

**T14.12.** On Sym^j(V_k),
Σ_{j≥0}tr(τ|Sym^j V_k)t^j=1/((1-t)^{k-2}(1+t)).
Hence k=2 gives (-1)^j; k=3 gives trace 1 for even j and 0 for odd j.

**Known anchor T14.13.** In characteristic zero, R[V_k]^{S_k} is polynomial on primitive degrees 2,...,k. Thus k=3 has a cubic symmetric primitive absent at k=2.

### C. Equivalence and computation

**T14.14.** For e:X≃Y and f:X→X, f^e=e f e^{-1} satisfies (f^e)^n=e f^n e^{-1}.

**C14.15.** Fixed points, periods, and all conjugacy-invariant dynamical properties transport across e.

**T14.16 (cost transport).** If e,e^{-1} cost C_e,C_{e^{-1}} and prediction of (f^e)^t costs C_Y(t), then prediction of f^t costs at most C_e+C_Y(t)+C_{e^{-1}} plus composition overhead.

**C14.17.** Any representation-independent irreducibility claim must survive efficient equivalence changes.

**P14.18.** Syntax-relative irreducibility need not survive equivalence: an efficiently decodable obfuscation can make trivial dynamics look syntactically difficult.

### D. Fibers and reconstruction

**Known T14.19.** q:A→B is an equivalence iff every homotopy fiber fib_q(b)=Σ_{a:A}(q a=b) is contractible.

**C14.20.** Exact reconstruction is contractibility of ambiguity fibers, not merely singleton cardinality in a set shadow.

**T14.21.** A section s:B→A of q makes every fiber inhabited, but not necessarily contractible.

**Known T14.22.** A path p:b=b' induces an equivalence fib_q(b)≃fib_q(b').

**C14.23.** Loops in B act by automorphisms of fibers: monodromy is intrinsic to reconstruction.

**P14.24.** A two-point fiber alone implies no nontrivial monodromy: B×2→B is the counterexample.

**C14.25.** A binary arithmetic obstruction requires nontrivial transport/sheet exchange, not merely a residual bit.

**Known T14.26 (fiber of composite).** For A→^q B→^r C,
fib_{rq}(c) ≃ Σ_{b:B}(r b=c)×fib_q(b), with dependent path data.

**C14.27.** Information lost through successive observations is nested/dependent and need not decompose into independent lost bits.

### E. Relations and parametricity

For R:A→B→U, say (f,g) preserves R→R' when R(a,b)→R'(f a,g b).

**T14.28.** Relation preservation is closed under identity and composition.

**T14.29.** For e:A≃B, graph relation R_e(a,b):=(e a=b) is preserved by conjugate maps.

**P14.30.** Useful abstractions need not be functional: simulation/bisimulation may be many-to-many.

**T14.31.** For a set-valued family of contexts C, x~y iff ∀c,C_c(x)=C_c(y) is an equivalence relation.

**P14.32.** Quotienting by this relation can erase proof-relevant information about why contexts agree.

### F. Descent/effective laws

Given a square X--f→Y, q:X→Z, r:Y→W, g:Z→W, define descent witness α:r f = g q.

**T14.33.** Descent witnesses paste under sequential composition.

**T14.34.** If q,r are equivalences, every f descends uniquely up to identity via g=r f q^{-1}.

**Set T14.35.** For surjective q:X→Z and f:X→Y, g with f=gq exists iff f is constant on q-fibers.

**C14.36.** A deterministic effective law on compressed variables exists exactly when rich dynamics respects the observational equivalence.

**T14.37.** If q,r and g are cheap while f is expensive, the descent square yields observer-relative computational reduction without full reconstruction.

**C14.38.** Full dynamics can be computationally irreducible while a localized observable dynamics is reducible.

### G. Towers and scale

Let ...→O_{n+1}→O_n→... be an inverse observation tower.

**P14.39.** Adjacent lift existence need not imply a coherent global lift through an infinite tower without extra hypotheses.

**T14.40.** A finite composite of equivalences is an equivalence.

**T14.41.** A finite composite whose fibers are all contractible has contractible total fibers.

**P14.42.** Local neutralization of individual coordinates need not destroy global information: correlation can migrate to dependence with an unresolved tail.

**Bound 14.43.** For ±1-valued A,B, surviving covariance is bounded by mutual information via Pinsker-type inequalities; hence nontrivial residual correlation requires residual dependence.

### H. Graded/dependent charge

Let G:C→U.

**T14.44.** A total-space map T:Σ_cG(c)→Σ_cG(c) restricts to G(c₀) iff its base component preserves c₀.

**T14.45.** If it sends c₀ to c₁ and p:c₁=c₀ is supplied, transport along p returns the output to G(c₀).

**C14.46.** Canonical closure is dependent-index preservation up to specified transport.

**P14.47.** A transformation simple on total/grand-canonical space can become globally coupled after conditioning to a fixed fiber.

### I. Direction

**P14.48.** Identity paths are reversible; genuinely irreversible reduction cannot be faithfully represented by identity types alone.

**C14.49.** Groupoid completion of a directed process can erase causal distinction by formally adjoining inverses.

**C14.50.** Computation, sieve stopping, evolution and causal process require directed higher structure in addition to univalent identity.

### J. Perspective atlas

**D14.51.** A perspective atlas is a higher diagram of representations with explicit comparison morphisms/cells.

**D14.52.** A generative defect is an empty or noncontractible comparison type where canonical reconciliation was expected.

**P14.53.** Reconciliation can exist nonuniquely; automorphisms give immediate examples.

**T14.54.** Aut(A)=A≃A acts on dependent/functorial structure over A by transport.

**C14.55.** Symmetry is self-perspective: nontrivial self-equivalences generate transported actions.

### K. Context

**P14.56.** From Γ₁⊢P and Γ₂⊢¬P one cannot infer contradiction until the judgments are compared in a common compatible context.

**C14.57.** Perspective contradiction should trigger context comparison, not averaging.

**D14.58.** A context translation is adequate for P when it transports P's interpretation coherently.

### L. Representation gain and irreducibility

For e:X≃Y and f:X→X define f^e=e f e^{-1}.

**D14.59.** Representation gain G(e;f)=C(f)-C(f^e), with costs of e/e^{-1} charged separately when operational.

**T14.60.** Semantic invariants under equivalence remain unchanged while representation gain can be nonzero.

**D14.61.** A univalent task-relative prediction cost is the infimum over admissible efficient equivalences of encode + predict-conjugate + decode cost.

**C14.62.** A robust computational irreducibility claim should lower-bound this equivalence-optimized cost, not one arbitrary syntax.

### M. New theorem schema: perspective reconciliation generates closure

Let e:A≃B and P:U→U be a type family.

**Known T14.63.** ua(e):A=_U B induces transport P(A)→P(B).

**C14.64.** One proved equivalence can generate an entire family of downstream transported results without separate comparison proofs.

**P14.65.** The value of discovering an equivalence can therefore be superlinear in the number of already-developed dependent constructions on either side.

This is an operational observation, not a canonical numerical theorem.

### N. Failure modes

**P14.66 (false-equivalence danger).** Similar invariants do not imply equivalence.

**P14.67 (false-quotient danger).** Many-to-one observation does not imply the erased structure is irrelevant to future contexts.

**P14.68 (false-obstruction danger).** Nontrivial fiber cardinality does not imply cohomological obstruction.

**P14.69 (false-naturality danger).** A theorem in one conditioned ensemble need not transport to another without an explicit relation/coupling preserving hypotheses.

**P14.70 (false-truncation danger).** Proposition-valued equality can erase path multiplicity relevant to later composition.

### O. Arithmetic theorem targets generated by the atlas

**Program 14.71.** Formalize Φ and exchange-reflection conjugacy in Cubical Agda and invoke univalence computationally.

**Program 14.72.** Formalize the positive-cone subtype and prove the exact nonrestriction statement.

**Program 14.73.** Formalize R^k≃R×V_k and S_k action for k=2,3.

**Program 14.74.** Encode charge as a dependent index/family and least-prime peeling as a directed transformation of indexed states.

**Program 14.75.** Build the scale tower O_z and compute finite homotopy fibers of charge-forgetting observations.

**Program 14.76.** Search for actual loop transport on those fibers; if every loop acts trivially, kill the parity-monodromy route.

**Program 14.77.** Build exact comparison relations among pair-field, Hahn, affine and finite-adic representations; classify each as equivalence/map/relation/asymptotic/unknown.

**Program 14.78.** Search for the first nontrivial theorem that transports computationally across a proved representation equivalence rather than being reproved.

### P. Sanskrit compression

दृष्टिः रूपं प्रकाशयति, न वस्तुं निर्माति।
A perspective reveals form; it need not create the underlying object.

समता प्रमाणेन; साम्येन न।
Equivalence by proof, not resemblance.

समतायां परिवहनम्।
Under equivalence: transport.

असमतायां तन्तुच्छेदं पश्य।
When equivalence fails, inspect the torn thread.

तन्तुच्छेद एव सीमा, शर्त, आवरण, दिशा, अथवा उच्चतरसम्बन्धस्य संकेतः।
The tear may signal boundary, condition, covering, direction, or higher relation.

अतः विरोधो न विफलता; स नूतननिर्देशाङ्कः।
Contradiction is not failure; it is a new coordinate.

### Q. Next theorem factory

The next pass should not enlarge ontology. It should generate exact lemmas in four existing mature languages:
1. Cubical/univalent transport for w±r and higher arity.
2. Logical relations/parametricity between arithmetic representations.
3. Directed/guarded type theory for peeling, scale, and recursive research.
4. Homotopy fibers/transport for reconstruction and genuine obstruction.

The criterion for promotion is executable comparison, not conceptual resemblance.
