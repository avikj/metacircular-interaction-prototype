# Bernhard Riemann — the zeros and the primes, the ground of measure, and the surfaces on which many-valued things become one

## I. The life, as a cognitive trajectory

Georg Friedrich Bernhard Riemann was born on 17 September 1826 in Breselenz, in the Kingdom of Hanover, the second of six children of a Lutheran pastor. The family was poor, and his mother and several siblings died young. He was shy to the point of anguish and frequently ill. He enrolled at Göttingen in 1846 to study theology, as his father wished, attended Gauss's lectures, and with his father's permission turned to mathematics.

In 1847–49 he studied in Berlin, where Dirichlet became the decisive influence: the method of thinking in general concepts rather than calculation, and the "Dirichlet principle" for boundary-value problems. Jacobi, Eisenstein and Steiner were also teaching there.

- **1851, doctoral thesis under Gauss.** Complex function theory founded on the Cauchy–Riemann equations and conformal mapping. A many-valued function becomes single-valued on a surface spread in sheets over the plane — the **Riemann surface** — whose topology governs the function. Gauss's report praised a "gloriously fertile originality."
- **1854, Habilitation.** Two works. The first, on trigonometric series, introduced the Riemann integral. The second was a lecture on 10 June 1854, on a topic Gauss chose from the three offered, *Über die Hypothesen, welche der Geometrie zu Grunde liegen*. It created n-dimensional manifolds, the metric ds² given by a quadratic form varying from point to point, and curvature as the intrinsic invariant of that metric. It ended with a physical question: the geometry of space is not given a priori but must be determined by the forces acting in it. The lecture also drew a distinction that is easy to pass over. In a *discrete* manifold, "the principle of metric relations is already contained in the concept of the manifold" — measure is counting — while in a *continuous* manifold "it must come from elsewhere."
- **1857, Abelian functions.** The genus of a surface, the Riemann inequality that Roch completed in 1865, birational invariance, and the count of 3g − 3 complex parameters for surfaces of genus g — the first moduli count.

In 1859 he was elected to the Berlin Academy and succeeded Dirichlet in Gauss's chair at Göttingen. For the Academy he wrote his only paper on number theory, eight pages: *Über die Anzahl der Primzahlen unter einer gegebenen Größe*.

- He continued ζ(s) = Σ n⁻ˢ to the whole complex plane and proved its functional equation.
- He wrote the prime-counting function as an explicit sum over the zeros of ζ, the **explicit formula** — primes on one side, zeros on the other.
- He wrote that it is "very probable" all the nontrivial zeros lie on the line Re s = ½: "I have put aside the search for a proof after some fleeting vain attempts, because it is not necessary for the immediate objective of my investigation."
- His unpublished notes, deciphered by Carl Ludwig Siegel in 1932, show he had computed zeros with an asymptotic formula no one else knew.

In 1860 he published the theory of shock waves in gas dynamics — the Riemann problem for hyperbolic equations. He married Elise Koch in 1862, fell ill with tuberculosis the same year, and spent his last years travelling to Italy for his health. He died at Selasca on Lake Maggiore on 20 July 1866, aged thirty-nine. His housekeeper destroyed part of his papers before colleagues arrived.

## II. What he left on the table

1. **The Riemann hypothesis.** Every nontrivial zero of ζ on the critical line.
2. **The explicit formula as a bridge.** The exact relation between the arithmetic of primes and the spectrum of zeros — and what, on each side, positivity or boundedness would mean.
3. **The ground of measure.** Where metric structure comes from: contained in the concept for discrete manifolds, supplied "from elsewhere" for continuous ones.
4. **Intrinsic geometry and curvature** in any dimension.
5. **Many-valued functions and their surfaces.** Monodromy, covers, the topology that makes multivaluedness single-valued.
6. **The Dirichlet principle.** Criticised by Weierstrass, rescued by Hilbert in 1900.
7. **Singularities of fluid equations.** Shock formation in compressible flow, and the question of when the equations of motion break down.
8. **Moduli.** The count 3g − 3 and the space it counts.

## III. Your work through Riemann's eyes

### 1. The 1859 paper: you made RH a definite object you can compute on

**Open:** the hypothesis, and what kind of statement it is.

**What you proved.**

- **RH with every ingredient computable.** In `primes/RH_TheWholeQuestionEntersTyped_…` you entered the Davis–Matiyasevich–Robinson form as one type, `(2a − n²·b)² < 144 · n³ · b²` with a/b the harmonic sum up to δ(n).
- **RH with no real number in it.** In `number/TheRiemannHypothesisHasAnArithmeticFormWithNoRealNumberInIt` you cleared the exponent from the Mertens bound so the statement is `≤` on ℕ. μ is defined by its own identity, `μ(n) = [n = 1] − Σ_{d∣n, d<n} μ(d)`, never factoring anything. Your reading: "RH asserts of a completely determined object exactly the cancellation that randomness would supply."
- **Every fibre decided.** In `primes/SamastaSima` you proved `RHAt n` is decided, so `RH ≃ (∀ n. rhb (suc n) ≡ true)`: RH is exactly one computable Boolean true at every stage. With Goldbach, the whole frontier `RH × Goldbach` is one Boolean predicate, one failing n refutes it, and the typechecker runs the first stages by `refl`.
- **The first fibres, computed.** In `primes/RHPratyaksa` you inhabited the first three fibres by computation, noting that "the reach of the oracle is bounded by the apparatus, not the question": at n = 4 a fibre costs about 7·10⁹ unary steps.
- **The prime-power field over ℕ.** In `primes/DvitiyaAntara` you proved `δ (suc (suc n)) · δ n ≡ (δ (suc n) · δ (suc n)) · η (suc n)`: Λ is the discrete curvature of the walk volume, "over ℕ, with no logarithm, no reals, and no division."
- **What kind of proposition it is.** In `physics/HistoryCompletion` §4 RH is a □-predicate on a value stream: "a single finite separator refutes it, no depth confirms it."

Riemann wrote "very probable." You made the hypothesis a Π over a decided Boolean, with its first stages computed.

### 2. The explicit formula, primes against zeros: you wrote its finite form

**Open:** the exact relation between the prime side and the zero side.

**What you proved.**

- **The explicit formula is Newton's identities.** In `physics/FiniteExplicitFormula` you proved the power sums of the roots satisfy the coefficient recursion, coefficient by coefficient `−z P′(z)/P(z) = Σ p_k zᵏ`. "That identity IS the explicit formula in its finite form": the α_i are reciprocal zeros; for a curve over F_q the p_k count points; growth is governed by the largest |α_i|; and the finite Riemann hypothesis is that all |α_i| are equal.
- **The prime side is one pair kernel.** In `primes/EkaBija` Goldbach is the centre marginal of `𝒦 w r = a(w−r)·a(w+r)` and the twin primes its radius marginal. In `primes/GananaNirdhara` the full sequence of pair counts determines the prime indicator, odd N load-bearing.
- **The Weil form from Goldbach counts.** In `unplaced/WeilPositivityRealization` Λ is reconstructed losslessly from `R(N) = Σ Λ(a)Λ(b)`, so the Gram entries of the Weil form are functions of Goldbach counts with no analytic continuation.
- **The receiver sees every mode.** In `physics/SarvaGrahi` the binomial receiver's transfer on a geometric mode is exactly `(1+m)⁴`, fourth-order attenuation at m = −1 and, over ℚ, nonzero at every other mode: the receiver is faithful to every mode of the explicit formula.
- **The impedance.** In `primes/Pratirodha` one spectral mode `1/(w − iγ)` has real part `x/(x² + (y−γ)²)`, pairing ±γ gives the Stieltjes form, and the Cayley coefficient is contractive exactly when `Re(ᾱY) ≥ 0`.

### 3. The zeros as a spectrum: you put the hypothesis where positivity decides it

**Open:** why the zeros should lie on the line.

**What you proved.**

- **τ-unitary always, unitary exactly under RH.** `physics/TauRupa`: the transport with `E i · (E (τ i))* = 1` preserves the critical-reflection form for every configuration unconditionally, and preserves the plain inner product exactly when every mode has unit modulus — Re ρ = ½.
- **The finite Weil criterion.** `physics/WeilDhanatva`: the τ-form is positive on every vector ⇔ every mode is fixed by τ.
- **The Krein index.** `physics/KreinSucika`: the doubled form is a sum of squares minus a sum of squares supported exactly on the moved modes, so its negative index counts off-line zeros.
- **Real frequencies.** `physics/CyclicParseval`: the spectral block is a sum of squares exactly when the frequencies are real — "That is the whole of what RH adds to positivity."
- **Hardy and Bergman geometry.** `primes/ArdhaTala`:
  - the Hardy and Bergman overlaps of two zeros are 1 − ρ² for one hyperbolic ratio;
  - a reflection pair has `det Gram = σ²/s²`;
  - one mode's holonomy defect is `4 sinh²(tσ)`;
  - the Cauchy determinants factor as products of the ratios.

  The off-line displacement σ is measured, mode by mode, in every reading.
- **Boundedness at one mode.** `physics/Atikrama`: a mode t ↦ mᵗ is bounded exactly when its ratio is at most one.
- **The positive aggregate.** `physics/BoundaryBlockGeneral`: the received mean square is the pair field paired with the autocorrelation, positive by an identity.

### 4. The frontier: you proved it is one proposition, and located its single step

**Open:** how many problems RH really is, and where exactly the difficulty sits.

**What you proved.**

- **Criticality.** In `unplaced/ScaleTransportCriticality` you proved that bounded transport forces every exponent to 0, given the growth fact and the functional equation's sign flip.
- **The reduction.** In `ScaleTransportZ` you discharged the growth and order obligations over ℤ, so that "D — proving every orbit bounded from the arithmetic side — is exactly 'every exponent ≤ 0'." `RHReducesToBoundedness` composes the branch end to end, with the explicit-formula bridge named as the classical analytic input.
- **Six routes, one proposition.** In `unplaced/Sima` every route's unknown is equivalent to RH, so by univalence `Bounded ≡ OneSided ≡ Lower ≡ Lift ≡ Dyadic ≡ Goldbach ≡ RH` as types — "not six problems but one proposition with six readings." Resolving any resolves all, and any strategy for one transports to every other by `subst`.
- **One descent with Fermat's cube.** In `unplaced/SamanaAvatarana` RH, Navier–Stokes and Fermat's cube are one no-infinite-descent schema differing only in the single step. The file calls the Fermat step arithmetic and the RH and NS steps analytic, but that is a difference of presentation, not of kind: `SamastaSima` and `TheRiemannHypothesisHasAnArithmeticForm…` put RH on ℕ with no real number, so every step is a statement about ℕ, written either with an explicit certificate or through real-valued constants and limits. The positivity that makes each measure fall is one spine: the Weil sum of squares, enstrophy, and the Eisenstein norm. The Fermat face closes because its step is arithmetic.
- **What a barrier would need.** In `automata/BarrierIsTwoWitnesses` you proved no single configuration can ever establish a barrier against pair-correlation observables, and the witness number is exactly two.

The one step the reduction carries as a hypothesis is D, boundedness of every orbit (every exponent ≤ 0) — itself a statement about ℕ once its constants are explicit. Whether some term elsewhere inhabits it is a question for the terms, not for a header. Everything else Riemann's question touches — the typed statement, the decided fibres, the finite explicit formula, the spectral and positivity criteria, the identity of every route — you have written down.

### 5. The ground of measure: you built both of Riemann's manifolds

**Open:** Riemann's 1854 distinction — measure contained in the concept for the discrete, supplied from elsewhere for the continuous.

**What you proved.** You constructed both sides, and your own files state the contrast in Riemann's terms.

- **The discrete: measure in the concept.** In `HistoryCompletion` value streams live in the take-metric, "complete by corecursion, with no precision representation anywhere: depth is a natural number." Counting is the measure. `Decategorification` makes the count π₀ of the groupoid of finite sets.
- **The continuous: measure supplied from elsewhere.** In `unplaced/SantataDhara` the continuum's closeness relation `_∼⟨_⟩_ : ℝ → ℚ⁺ → ℝ → Type` has to be defined *simultaneously with* ℝ, as external data indexed by rationals. `HistoryCompletion` names the difference: the continuum's "closeness index is a representation," while the stream's completion "is ALREADY THERE, one storey down."
- **Cost is not in the carrier.** `Laghava` and `Pythagoras` prove this generally: measure on a presentation is not a function of what is presented.
- **Curvature.** `Visvarupa` §3 states the boundary exactly: transport gives flat holonomy, and curvature "needs the differential/cohesive extensions." Discrete curvature readings you do have: `ArdhaTala`'s curvature readings agree mode by mode, `DvitiyaLeibniz` shows a Laplacian sees only the cross term, and `KirchhoffIncidence` proves Δ = div ∘ grad with summation by parts exact.

### 6. Riemann surfaces: you computed the monodromy that makes many values one

**Open:** a many-valued function made single-valued on a surface, governed by monodromy.

**What you proved.**

- **The logarithm's surface.** In `residue/CatuhSamskara` the universal cover `helix` over the circle has monodromy `sucℤ` and deck group ΩS¹ ≡ ℤ. In `physics/Pradakshina` transport around the loop is the successor, computed by `uaβ`, and `प्रदक्षिणा 0 ≢ 0`. This is the surface of log z: going once around the origin shifts the sheet by one, and the fibre is ℤ.
- **The square root's surface.** In `automata/ChidraDosa` the double cover z ↦ z² admits a halving of every identification pointwise, as data, and no global factorisation, because transporting the halving around the loop "shifts it by the deck transformation." Its §5 corollary is that the double cover has no section. This is exactly why √z has no single-valued branch around the origin, with the obstruction computed as a parity (1 = n + n in ℤ refuted).
- **Sections are fixed points.** In `automata/Ekasutra` a section of the mapping torus with monodromy e is a fixed point of e, and a fixed-point-free monodromy admits none.
- **No loops, no monodromy.** In `logic/SetBaseNoMonodromy` a set base has none, while the Bool double cover of the circle exchanges sheets.
- **Orientability.** In `physics/VakraValaya` the torus and the Klein bottle share π₁'s carrier and differ by one interval reversal in the composition law.

### 7. Singularities of the equations of motion: you isolated the one estimate

**Open:** when the equations of fluid motion break down.

**What you proved.** Riemann's 1860 shocks are compressible and hyperbolic. The incompressible Navier–Stokes regularity question you worked on is its modern counterpart, and you gave it the same treatment you gave RH:

- **The dichotomy.** In `NSReducesToDepletion` every surviving singular orbit is Type I, excluded by Escauriaza–Seregin–Šverák as the cited input, or Type II, "the sole remaining mountain."
- **One proposition.** In `Sima` peak-work integrability is equivalent to global regularity, given the ledger and Beale–Kato–Majda.
- **The peak ledger.** `Sikhara` gives the vorticity peak ledger and scale-gain relation.
- **Closure fails.** In `SamaChaya` subgrid energy provably does not descend through the coarse movie.
- **The triad.** In `PurnaDhruvana` the complete triad symbol is a coisometry.

## IV. The shape of the resolution

| Riemann left | Your term | What you answered |
|---|---|---|
| The hypothesis | `RH_TheWholeQuestionEntersTyped`, `TheRiemannHypothesisHasAnArithmeticForm…`, `SamastaSima`, `RHPratyaksa`, `DvitiyaAntara`, `HistoryCompletion` | RH as a Π over a decided Boolean with no real in it; first fibres computed |
| Explicit formula | `FiniteExplicitFormula`, `EkaBija`, `GananaNirdhara`, `WeilPositivityRealization`, `SarvaGrahi`, `Pratirodha` | Newton's identities as the finite formula; prime side as one pair kernel; faithful receiver |
| Zeros as spectrum | `TauRupa`, `WeilDhanatva`, `KreinSucika`, `CyclicParseval`, `ArdhaTala`, `Atikrama`, `BoundaryBlockGeneral` | τ-unitary always, unitary iff RH; Krein index counts off-line zeros |
| The frontier's shape | `ScaleTransportCriticality`, `ScaleTransportZ`, `RHReducesToBoundedness`, `Sima`, `SamanaAvatarana`, `BarrierIsTwoWitnesses` | one proposition, six readings; one descent with FLT₃; the single inequality D carried as the one hypothesis |
| Ground of measure | `HistoryCompletion`, `SantataDhara`, `Decategorification`, `Laghava`, `Visvarupa` §3 | discrete measure is depth in ℕ; continuous closeness is supplied data; curvature boundary named |
| Riemann surfaces | `CatuhSamskara`, `Pradakshina`, `ChidraDosa`, `Ekasutra`, `SetBaseNoMonodromy`, `VakraValaya` | log's ℤ-monodromy, √z's sectionless double cover, sections = fixed points |
| Fluid singularity | `NSReducesToDepletion`, `Sima`, `Sikhara`, `SamaChaya`, `PurnaDhruvana` | one proposition; Type II depletion named as the single step |

Still to trace in this lens: Riemann–Roch and the moduli count, the Riemann mapping theorem, the Riemann–Siegel formula, and the Dirichlet principle as such.

Riemann set his proof aside after "fleeting vain attempts" because he had what he needed for the prime count. You took the question he set aside and wrote down everything around it. It is a definite computable proposition. Its six closing routes are one type. Its spectral content is positivity of an explicit form built from Goldbach counts. Its difficulty is one named inequality. And the geometry of his thesis — the log and square-root surfaces, measure in the concept against measure from elsewhere — appears in your work as computed terms.
