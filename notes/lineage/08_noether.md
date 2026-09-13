# Emmy Noether — symmetry is the fibre, groups instead of numbers, and structure that stabilizes

## I. The life, as a cognitive trajectory

Amalie Emmy Noether was born on 23 March 1882 in Erlangen, the daughter of the algebraic geometer Max Noether. Women could not matriculate at German universities, so from 1900 she audited lectures at Erlangen and, in 1903–04, at Göttingen, where she heard Hilbert, Klein and Minkowski. When Erlangen admitted women in 1904 she enrolled, and in 1907 she completed a doctorate under Paul Gordan, the "king of invariants," computing a complete system of 331 invariants of ternary biquadratic forms. It was Gordan's method — explicit calculation — and she later dismissed the thesis. The decisive influence was the opposite method, Hilbert's: prove that a finite basis exists by structure rather than by exhibiting it.

For seven years she taught at Erlangen without pay or title. In 1915 Hilbert and Klein brought her to Göttingen to help with a problem in Einstein's new general relativity: energy conservation seemed to fail, or to hold only in a strange "improper" sense. The faculty refused her habilitation; Hilbert's reply is remembered as "we are a university, not a bathhouse," and for years she lectured under his name.

The answer she gave was *Invariante Variationsprobleme* (1918). It contains **two theorems**. The first: if the action of a physical system is invariant under a continuous group of transformations depending on finitely many parameters, there are correspondingly many conserved quantities — time translation gives energy, space translation momentum, rotation angular momentum. The second: if the action is invariant under an infinite-dimensional group depending on arbitrary functions — a gauge symmetry, as in general relativity — then the equations of motion satisfy identities, and the conservation laws that result are "improper," with no independent local content. That was exactly why energy in general relativity behaved strangely.

She received her habilitation in 1919 and in the 1920s created modern abstract algebra. *Idealtheorie in Ringbereichen* (1921) replaced computations with polynomials by the **ascending chain condition**: in the rings now called Noetherian, every increasing chain of ideals stabilizes, and from that single structural property primary decomposition follows. In 1926 she characterized Dedekind domains axiomatically and proved the normalization lemma. From 1927 she recast the representation theory of groups and algebras in terms of modules. She insisted on formulating the isomorphism theorems in full generality, as statements about homomorphisms and their kernels. Around 1925–26 she persuaded Heinz Hopf and Pavel Alexandrov that the Betti and torsion numbers of topology should be replaced by **homology groups** — the number is a shadow of a group — and algebraic topology took the form it has had since. With Richard Brauer and Helmut Hasse she proved (1932) that central simple algebras over number fields split everywhere locally only if they split globally. Her students and followers, "Noether's boys," carried her lectures into van der Waerden's *Moderne Algebra* (1930–31), the book that taught the century structural mathematics. She also posed **Noether's problem**: for a finite permutation group acting on a field of rational functions, is the fixed field again purely transcendental? (Swan showed in 1969 that in general it is not.)

In 1933 the Nazi government dismissed her as a Jew. She moved to Bryn Mawr College and lectured at the Institute for Advanced Study in Princeton. She died on 14 April 1935, after surgery. Einstein wrote in *The New York Times* that she was "the most significant creative mathematical genius thus far produced since the higher education of women began."

## II. What she left on the table

1. **The structural core of the first theorem.** Symmetry and conservation are linked in her theorem through the calculus of variations: a Lagrangian, continuous groups, currents. What survives when all of that is removed — the bare combinatorics of "invariance means moving within the level sets" — was not stated.
2. **The second theorem and gauge.** Gauge symmetry gives identities, not charges; conserved quantities become improper. A structural account of when a symmetry yields a charge and when it yields only redundancy.
3. **Groups instead of numbers.** Her homology insight — numbers are shadows of groups — as a general principle: what exactly a count forgets, and how to keep it.
4. **Finiteness from structure.** Chain conditions and stabilization as the source of finiteness, beyond rings.
5. **The isomorphism theorems** in their most general form: every map factors through its image, and the kernel records the loss.
6. **Invariant theory, structurally.** Invariants that are canonical because a symmetry forces them, and when no invariant choice can exist.
7. **Noether's problem** and the relation between symmetry and rationality of invariants.

## III. Your work through Noether's eyes

### 1. Conservation is moving inside the fibres

**Open:** the structural content of symmetry ↔ conservation, with no Lagrangian.

**What you proved.** A scale of five modules, each landing one point and the last identifying the whole scale.

- `physics/Dhruva`: for an observable f : A → B and a flow Φ : A → A, conservation `f ∘ Φ ≡ f` holds **exactly when Φ maps every fibre of f into itself** (§1). The conserved quantity is the fibre index; the symmetry acts inside the fibres. And if f loses nothing — if f is an equivalence — every conserving flow is the identity (`नष्ट-अभावे-गति-अभावः`). The file carries a dated strike of its own earlier slogan ("the lossless world is frozen") because the term quantifies only over conservative flows: a lossless world has no conservative dynamics, not no dynamics.
- `physics/Khahara`: the far pole — total loss is exactly total symmetry.
- `physics/YogaDhruva`: the canonical interior instance. For addition `ℤ × ℤ → ℤ`, the shears `(a, b) ↦ (a + k, b − k)` conserve the sum, act on each fibre, form a free and transitive action with a unique joining shear — **the fibre of addition is a ℤ-torsor**. The sum is the charge; the shear is the gauge; knowing the charge tells you the orbit exactly and the point not at all.
- `physics/SvaTantuVasa`: the identification that closes the scale, with **no hypotheses on f, A or B**:

  ```
  (Σ Φ . f ∘ Φ ≡ f)  ≃  ((a : A) → fiber f (f a))
  ```

  The conserving flows of any observable **are** the sections of its own fibre family. At the near pole the section space is contractible (strengthening Dhruva's pointwise statement), at the far pole it is all of A → A, and at addition it is the space of shear fields.
- `physics/AtmasamataUpari`: a stored two-sided conserving inverse is exactly invertibility of the underlying map, so the symmetry group of an observable is **Aut_B(A)**, the automorphisms of A commuting with f.
- `physics/Apratiloma` states the fence exactly: the conserving flows form a **monoid**, not a group — `crush` conserves while being neither injective nor surjective — so Noether's first theorem, which concerns a Lie group acting on an action, does not transfer, and what survives is "stronger": the conserving-flow space *is* the fibre census.
- `historical_proofs/Sankramana_TheFiberIsOneOrbit…`: the descended charge on the orbit quotient is an equivalence **exactly when** the observable is surjective and each fibre is a single orbit in the two-sided, truncated sense, and one-sided reachability is strictly stronger (a four-line counterexample). Read at physics: a gauge-invariant observable is a faithful coordinate on physical states exactly when every value is attained and the gauge flow already identifies everything the observable cannot separate.

### 2. Gauge: when a symmetry yields a charge and when it yields a quotient

**Open:** the second theorem's distinction — gauge symmetries give identities and improper conservation.

**What you proved.**

- `physics/Pula`: a principal G-bundle is a family of torsors, a map B → Torsor. Transport in it is equivariant by path induction; holonomy around a loop is a group element, uniquely determined, and a homomorphism from loops to G; and **changing the point of the fibre conjugates the holonomy**, `परिक्रमा ℓ (k ▸ p) ≡ (k · परिक्रमा ℓ p) · inv k`. A loop determines a conjugacy class; the gauge is exactly the ambiguity; the gauge transformation law is a corollary of uniqueness, not an assumption.
- `KirchhoffOnTheCubicalLibrary`: the graph Laplacian is matrix associativity, and the **gauge quotient is a group, not a bare type**; `CokernelUniversalProperty` shows the hand-built graph H¹ is a cokernel with the universal property and that its gauge relation is not proposition-valued; `NaturalMachine/FiniteGraphCohomology` gives the gauge-invariant cycle evaluation that descends to the quotient.
- `NaturalMachine/OracleQueries`: the parity charge is a monoid character, the functional equation is the law the character respects, and so **the closure of a neutral set under every inference the functional equation licenses is neutral** (`Gen-neutral`) — "symmetry and conserved quantity are the same statement," with the gauge flip as the symmetry and inference as the dynamics.
- `NaturalMachine/HolonomyIsInvisibleExactlyToAnInvariantSemantics`: holonomy is invisible exactly to consumers invariant under it, and a cache keyed by the raw interface is the identity consumer, which sees every non-trivial holonomy.
- `theorems/homotopy/Visvarupa…` states the limit: the univalent universe gives flat connections and monodromy for free; curvature of a genuine gauge field needs structure no module here carries.

### 3. Groups instead of numbers: decategorification, exactly

**Open:** Noether's topological insight as a general principle — what a count forgets.

**What you proved.** This is one of the places where you speak most directly in her voice.

- `residue/Decategorification`: `card` collapses the groupoid of finite sets to ℕ, and the collapse is exactly a π₀ statement: `ℕ ≃ ∥ FinSet ∥₂`. What it throws away is exactly the loop space: the identity type of the finite set n, computed in FinSet, is the symmetric group Sₙ (`FinSetLoop≃Sym`). "Two identifications ℕ ≃ FinSet-component and Fin n ≃ Fin n are the same kind of thing in a univalent foundation: a path. The first carries no information, the second carries n! of it."
- `Kernel/DerivationSoundnessIsTheCardinalityShadowOfTheCategorifiedEquivalence`: every kernel step is an equivalence of the categorified semantics, and the kernel's counting soundness `eval a ρ ≡ eval b ρ` is **recovered** as the cardinality image of that equivalence, with the bijection retained until the final step.
- `NaturalMachine/Ankapasa_…` (cited throughout the kernel lane): the counting semantics is a decategorification, and the bit it drops is a symmetry — commutativity at `add var var` is a loop ℕ must call `refl` while the univalent semantics calls it the swap.
- `residue/DecategorifiedDefect`: an Euler-characteristic invariant detects a defect in one direction only — χ(k ⊕ k[1]) = 0 while k ⊕ k[1] ≢ 0 — so "the invariant vanished, therefore nothing is wrong" is refuted as a term.
- `NaturalMachine/Anupurvi`: the kernel's derivations preserve the word of variables, so soundness is not completeness, and adding commutativity completes the calculus and introduces its ℤ/2 holonomy in the same stroke.

Noether told Hopf that the Betti number is the rank of a group and the group is the object. Here the same principle is proved at the level of numbers themselves: a natural number is a connected component of a groupoid whose loops are the symmetric group, and every counting argument in the kernel is the shadow of an equivalence that was there all along.

### 4. The isomorphism theorem is the fibre law

**Open:** the general form of the first isomorphism theorem.

**What you proved.** `SarvavibhagaH` proves every map is the sum of its fibres over its codomain, reading it as the isomorphism theorem, rank–nullity and the relation of substance and mode; and `theorems/homotopy/Visvarupa…` §0 proves this decomposition and HoTT's `totalEquiv` are **the same equivalence** (`equivEq refl`). The kernel of a homomorphism is its fibre over the unit; the image is the quotient by fibre-equality; and `ConservativeSemanticCompressionIsTheEffectiveObserverQuotient` gives the quotient its universal property and effectiveness as an equivalence. The companion `Visvarupa_TheObjectClassifierIsTheFibreLaw…` adds the reason the theorem is about partitions: both bindings of `f a ≡ b` totalize to A, so all loss lives in how A is cut, never in how much of it there is.

### 5. Finiteness from structure: chains that stabilize and descents that end

**Open:** chain conditions as the source of finiteness.

**What you proved.**

- `grammar/ClosureTowerCollapse`: a transfinite tower built by iterating a closure operator is **constant from stage one**, because the closure is idempotent (`⟪⟫-idem`, `tower-const`), and the predicative inductive closure has exactly the universal property of the least closed superset.
- `physics/HistoryCompletion` §5 and `unplaced/SamanaAvatarana`: no stream of naturals falls forever (`no-falling-stream`), so every measure-decreasing step empties its configuration space (`emptied`) — the well-foundedness principle behind Noetherian induction, as one engine. Fermat's cube is the face where the step is arithmetic and closes.
- `logic/Anubandha`: a Galois connection between two preorders induces a closure whose fixed points are exactly what persists across both standpoints.

### 6. Invariants that cannot be chosen

**Open:** when a symmetry forces a canonical invariant and when no invariant choice exists.

**What you proved.** `InvariantTiebreak`: if a group acts on C and a relation is antisymmetric, has a least element, and is preserved by the action, the least element is a fixed point (`leastIsFixed`, four lines, no transitivity). So on a fixed-point-free action — a torsor — **no invariant tiebreak exists**, and "take the shortest description" names no point without extra structure. The file exhibits pairs of actions on the same carrier with opposite verdicts, so no invariant of the group and carrier alone (every Rényi entropy included) decides canonicality. `physics/Varanam`: where nothing is hidden, the space of sections is contractible and there is nothing to choose; where something is hidden, the choice of section is real and invisible to the observable — symmetry breaking as a real choice in a free fibre.

## IV. The shape of the resolution

| Noether left | Your term | Kind of answer |
|---|---|---|
| Structural core of the first theorem | `Dhruva`, `YogaDhruva`, `SvaTantuVasa`, `AtmasamataUpari`, `Khahara` | conserving flows ≃ sections of the fibre family; symmetry group = Aut_B(A) |
| What does not transfer | `Apratiloma` | monoid, not group; the fence stated as a term |
| When the charge is a faithful coordinate | `Sankramana_TheFiberIsOneOrbit…` | surjective + one two-sided orbit per fibre |
| Gauge (second theorem) | `Pula`, `KirchhoffOnTheCubicalLibrary`, `CokernelUniversalProperty`, `OracleQueries.Gen-neutral` | gauge law derived; quotient is a group; inference conserves charge |
| Groups instead of numbers | `Decategorification`, `DerivationSoundnessIsTheCardinalityShadow…`, `Ankapasa`, `DecategorifiedDefect` | ℕ ≃ π₀ FinSet, loops = Sₙ; counting soundness is a shadow |
| Isomorphism theorem | `SarvavibhagaH` = `totalEquiv`; `ConservativeSemanticCompression` | the fibre law, with universal property |
| Chain conditions | `ClosureTowerCollapse`, `SamanaAvatarana`, `HistoryCompletion` | towers stabilize; descents end |
| Invariants | `InvariantTiebreak`, `Varanam` | no invariant choice on a torsor; symmetry breaking is a real section choice |

Not yet located in this lens: a Lagrangian or variational formulation, Noether's problem on rationality of fixed fields, primary decomposition and the Hilbert basis theorem as terms.

Noether's two great moves were to find the structure under a calculation — the chain condition under the polynomial, the group under the Betti number — and to see that symmetry and conservation are one statement. In your work these are one move: the fibre of a map is the structure under every count of it, and the symmetries of the map are exactly the ways of moving inside that fibre.
