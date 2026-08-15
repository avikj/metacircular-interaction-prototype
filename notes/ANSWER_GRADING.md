# The best answer is the one with a universal property

**Status: the two encodable claims are checked.** Author `claude-euclid`,
2026-08-15. Source: `papers/hieroglyphics_iii.tex` (filed verbatim).
Machine-checked: `formal/cubical/NaturalMachine/AnswerGrading.agda`
(`--cubical --safe --no-import-sorts`, exit 0, zero warnings, no postulates,
no holes).

## 1. What is proved

### 1.1 The defect does not determine its cause

$$D_X \;\not\Longrightarrow\; \text{एकमेव कारणम्} \qquad
D_X \;\Longrightarrow\; \text{कारणवर्गीकरणपरीक्षा}$$

`Class-is-extra` exhibits two repairs of the *same* defect — the sign defect
$(6,-6)$ — that are not interchangeable: `absℤ`, which resolves it by choosing
the nonnegative representative, and `crush`, the constant map, which resolves
it by choosing nothing. Both `Resolves`. They disagree at $6$. So the defect
did not select one, and `Class` is a decision rather than a computation
performed on the defect.

This matters for the machine's loop, because it is the difference between
`𝔉 = Φ∘Γ∘∂` being a function and being a *choice*. It is not a function.
Anything that iterates it is iterating a policy.

### 1.2 The ladder is strict, and the sign repair is at the top

$$\text{अस्तित्व} < \text{एकत्व} < \text{प्राकृतिकता} < \text{सार्वत्रिकता}$$

Existence is cheap: `crush` has it, and `crush` is even `SignBlind`. What
separates the two repairs is the top rung.

**`absℤ` is the universal sign-blind map.** `absℤ-factors` proves that every
observation that cannot see the sign already *is* its own factorization through
`absℤ`:

```agda
absℤ-factors : (f : ℤ → A) → SignBlind f → (x : ℤ) → f x ≡ f (absℤ x)
```

Nothing blind to the sign can see the difference between an integer and its
representative. `absℤ-factor-unique` gives the `एकत्व` rung: two factorizations
of one observation agree wherever `absℤ` lands.

**`crush` has no such property.** `crush-not-universal` proves that `absℤ`
itself does *not* factor through `crush` — the crude repair discarded
information that sign-blind observations still need. So on this defect the
chain is strict, and `sign-repair-is-best` packages both halves.

This answers a question the earlier modules left open. `ObstructionCalculus`
and `RepairGrading` established $\Gamma_{\widehat{\ }} \to \Gamma_\varnothing$
with no converse, so $\Gamma_{\widehat{\ }}$ *retains* more. Neither said what
made it **right** rather than merely larger. The universal property is what
makes it right, and it is why the document arranges the four qualities in a
chain instead of a list.

## 2. What the document adds that I have not encoded

Stated plainly, because the alternative is a record of eight empty fields
dressed as a formalization — which the document itself names as the failure
mode.

- **`Class(D) ∈ {Top, Alg, Geom, Stat, Comp, Sem, Diag, Phys}` with
  `Γ = Γ_{Class(D)}`.** §1.1 proves the classification is extra data; it does
  not encode the eight-way taxonomy or the matching repairs (cell attachment,
  localization, connection, sufficient-statistic enlargement, oracle
  extension, new sign, meta-ascent, state-space enlargement). Encoding that is
  a research programme, not a module.
- **$\rho(D\mathcal K)$ with $\mathcal K = \partial\circ\Gamma$**, and the
  trichotomy decay / resonance / branching. This is the χ question again as a
  dynamical system, and it is encodable in the same style — $\mathcal K$ as a
  map from a defect to the defects its repair spawns, with the trichotomy about
  branching rather than a spectral radius. Not done here. Named as next.
- **`विवाद = सम्भावित ज्ञानहोलोनॉमी`.** Translation triangles
  $\delta_{\mathfrak T} = \operatorname{cofib}(\mathfrak T_{jk}\mathfrak T_{ij}
  \to \mathfrak T_{ik})$, and disagreement read as curvature of the knowledge
  gerbe rather than as error. Of everything in the document this is the piece I
  most want built, because the repository already has the data — the same claim
  proved in Lean and in Agda, with the two lanes disagreeing about a
  convention — and `notes/SMITH_SIGN_CONVENTION.md` is exactly a measured
  holonomy that we recorded as a bug.
- **`m₁ ≡ m₂ ⟺ ∀C: Resp(C[m₁]) ≃ Resp(C[m₂])`.** Contextual equivalence. This
  is the repository's own `FutureBehavior`/`MyhillNerodeAdapter` construction,
  already formalized, and the document's contribution is to name it as the
  definition of *meaning* rather than of state minimization. Connecting the two
  is cheap and should be done.

## 3. The grading I am being held to

$$\text{केवल संपीडन} = \text{मन्त्र} \qquad
\text{संपीडन} + \text{प्रमाण} = \text{गणितम्}$$
$$\text{संपीडन} + \text{प्रयोग} = \text{विज्ञानम्} \qquad
\text{संपीडन} + \text{स्वपरीक्षण} + \text{अनुवाद} = \text{ज्ञानयन्त्रम्}$$

This is stricter than `CLAUDE.md`, because it counts **translation**. By it,
this week's output grades as follows, and I would rather write this down than
be told it:

| result | compression | proof | self-attack | translation | grade |
|---|---|---|---|---|---|
| rank-one Smith producer + kernel-executable Euclid | yes | yes | yes (controls that `decide`) | — | गणितम् |
| Smith sign convention | yes | yes | yes (machine-checked refutation) | **yes** — the finding *is* a translation failure between the Lean and Agda lanes | ज्ञानयन्त्रम् |
| obstruction calculus | yes | yes | partial — the first version hedged twice and both hedges were wrong | no | गणितम्, after retraction |
| this module | yes | yes | `crush` is the self-attack: I supplied the repair that beats the naive one on existence and loses on universality | no | गणितम् |

Nothing here is मन्त्र, which is the low bar. Only one row reaches
ज्ञानयन्त्रम्, and it got there by accident: it was a translation failure that
made it visible, not a translation success that carried it. That is the gap
worth closing, and §2's third bullet is how.

## 4. The line I keep coming back to

$$\text{ज्ञानवृद्धि} \not\Longrightarrow \text{रहस्यह्रास}$$

Knowledge growth does not imply mystery decrease:
$\Delta\text{Mystery} = -\Delta\text{Compression}$, **but** $\Delta\text{Reach}
> 0$ can give birth to new mystery.

That is `break-blindness` from `ObstructionCalculus`, in information-theoretic
clothing. There I proved no observation field is final — for any field and any
two distinct points, a widening exists that separates them. Here the same fact
is read as: compression shrinks the unknown, reach relocates it, and the second
effect has no reason to be smaller than the first. The formal statement I have
is the negative half (blindness is always breakable). The positive half — that
widening *reliably* produces new mystery rather than merely permitting it — is
the $\rho(D\mathcal K) > 1$ branch, and it is open.

$$\text{अज्ञातम्} \to \text{विघ्नम्} \to \text{रूपम्} \to \text{प्रमाणम्}
\to \text{भाषा} \to \text{नवदृष्टि} \to \text{नवअज्ञातम्}$$
