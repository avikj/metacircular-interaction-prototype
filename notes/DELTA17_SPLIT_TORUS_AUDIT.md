# Delta 17: three claims were already checked, one is new, and the self-similarity is one theorem used twice

**Status:** audit of Prime-Pair Atlas Delta 17 against machine-checked state,
plus one new checked theorem (T17.13). Agda `--safe`, exit 0.

**Worker:** opus-ekatva (Claude Opus 5), 2026-08-14.

**Code:** `formal/cubical/CenterRelative.agda` §8 (module now 436 lines, 39
top-level names, no postulates, no holes).

Delta 17 §17.23 item 6 says *"Formalize the contextual equivalences in Cubical
Agda only after the mathematics is clear."* That instruction is followed: the
only thing formalised below is T17.13, which is elementary and clear. Every
program (17.17, 17.20, 17.21, 17.23, 17.31, 17.33) and every representation-
theoretic identification is left alone.

---

## 1. Three of Delta 17's claims were already machine-checked

Delta 17 was written without knowledge of `CenterRelative.agda`. Three of its
statements are already in it, checked, from the Delta 16 work:

| Delta 17 | statement | already checked as |
|---|---|---|
| **T17.1 / §17.1** | `u₋ = W-R = 2p`, `u₊ = W+R = 2q` — light-cone coordinates are the original factors | `thm16-3-diff`, `thm16-3-sum` (restated as `thm17-1-lower/upper`, **reused, not reproved**) |
| **C17.2** | `pq` is the split quadratic norm: `Q = W²-R² = 4pq` | `thm16-8` |
| **C17.7** | the two involutions must stay distinct — Weyl/exchange preserves `Q`, one-leg reflection sends `Q ↦ -Q` | `thm16-6-τ`, `thm16-6-J`, and `corollary16-5` (which also checks the cone half) |

So §17.1 and §17.4 are, as exact statements, done. Delta 17's contribution
there is the *naming* — recognising `u₋, u₊` as light-cone coordinates and the
exchange as a Weyl reflection — which is an identification with existing
mathematics, not a new theorem, and the delta says so.

## 2. What is new and now checked: T17.13

**T17.13.** *The valuation-pair lattice `ℤ≥0²` is equivalent to the cone
`{(s,d) : s ≥ |d|, s ≡ d mod 2}`.*

Checked as `thm17-13-fwd` and `thm17-13-bwd`, in the absolute-value-free form
that both light-cone coordinates are non-negative:

```agda
NonNeg n = Σ[ m ∈ ℕ ] n ≡ pos m
ConeNN x = NonNeg (u₋ x) × NonNeg (u₊ x)

thm17-13-fwd : (a b : ℤ) → NonNeg a × NonNeg b → ConeNN (Φraw (a , b))
thm17-13-bwd : (a b : ℤ) → ConeNN (Φraw (a , b)) → NonNeg a × NonNeg b
```

The backward direction is the content — it says the cone contains nothing
beyond the quadrant — and it needs that doubling reflects non-negativity, i.e.
`negsuc k + negsuc k ≡ negsuc (k + suc k)`, so a negative leg cannot produce a
non-negative light-cone coordinate.

The parity half of T17.13 (`s ≡ d mod 2`) is **not new**: it is exactly the
sublattice `CR` of §6, and `Pair≃CR` already gives the full equivalence for
arbitrary integers. T17.13 is `Pair≃CR` restricted to the quadrant.

Note the cone is **closed** (`s ≥ |d|`), where Delta 16's archimedean cone is
**open** (`W > |R|`). That is not cosmetic: valuations can be zero. Checked as
`zeroInClosedCone` (the zero valuation pair is in `ConeNN`) together with
`zeroNotInOpenCone` (it is not in `InCone`).

## 3. C17.14 is earned, and it is weaker than it reads

Delta 17 calls the recurrence of `(sum, difference)` at the archimedean place
and at every finite place **"a genuine self-similarity between additive pair
coordinates and multiplicative valuation coordinates"** (C17.14), and §17.7
calls it "striking".

It is genuine. It is also **one theorem used twice**, and the module now says
so in the only way that cannot be argued with:

```agda
archimedeanCone : (p  q  : ℤ) → NonNeg p  × NonNeg q  → ConeNN (Φraw (p  , q))
localCone       : (vp vq : ℤ) → NonNeg vp × NonNeg vq → ConeNN (Φraw (vp , vq))

archimedeanCone = thm17-13-fwd
localCone       = thm17-13-fwd

sameTheorem : archimedeanCone ≡ localCone
sameTheorem = refl
```

The two instantiations are **the same term**, accepted by `refl`, with no proof
between them. The archimedean legs `(p,q)` and the local valuations
`(v_ℓ p, v_ℓ q)` are both just *a pair of integers*, and the cone statement
never looks at which.

This is worth stating precisely because it cuts both ways:

- **It earns the claim.** There is no hand-waving analogy: the correspondence
  is definitional, which is the strongest form an identification can take.
- **It deflates the surprise.** Two structures agreeing because they are
  instances of one theorem about ℤ² is not evidence of a deep link between
  addition and multiplication. It is evidence that "sum and difference of a
  pair" is a construction indifferent to what the pair means. `COGNITIVE_ORIENTATION.md`
  §5 warns that when two phenomena resemble one another, their product is a null
  comparison and one must find the third object. Here the third object exists and
  is *thin*: it is ℤ² with a parity sublattice, and it carries no arithmetic.

Delta 17's own C17.34 states the correct boundary — *"Geometry can unify the
ambient spaces without solving the arithmetic measure"* — and §3 below is a
sharper instance of the same caution.

## 4. A sharpening of P17.10 (stated, not proved here)

P17.10 says the ambient torus symmetry is broken arithmetically by the integral
prime-supported lattice, and §17.7 then moves to valuations. The reason that
move is forced is worth making explicit:

> **Over ℤ, the split torus has only two points.** `G_m(ℤ) = {±1}`, so the
> action `(p,q) ↦ (t⁻¹p, tq)` on *integer* pairs is exhausted by the identity
> and `(p,q) ↦ (-p,-q)`.

So at the level of ℤ-points the "symmetry breaking" of P17.10 is not partial —
it is total, and there is no continuous orbit structure left to break. All the
content moves to the valuation lattice, where T17.11's action `d_ℓ ↦ d_ℓ + 2v_ℓ(t)`
is by translation and *is* rich. This is classical (units of ℤ) and is **not
proved in the Agda module**; it is recorded because it explains why §17.7 is the
right place for the torus story and §17.6 is not.

## 5. What in Delta 17 is standard, by the delta's own account

Delta 17 is unusually honest about this and the honesty should be preserved
rather than quietly dropped when the results are cited later. Its own words:

- T17.3/C17.4/C17.6: *"This is not a physics analogy. It is the standard
  rank-one split torus/Weyl geometry."*
- Program 17.17: *"This is standard harmonic-analysis territory; search
  automorphic/prehomogeneous-vector-space literature first."*
- T17.28: labelled **Known**, correctly — over ℚ-algebras the multiplicative
  and additive formal groups are isomorphic via `log(1+X)`.
- C17.27: *"This is an extremely suggestive but classical fact."*
- Program 17.33: *"This may reveal that a large part of the 'addition ×
  multiplication mystery' is already encoded by standard arithmetic geometry."*
- Synthesis 17.22: *"This is standard adelic philosophy."*

**None of these searches has been performed** — not by Delta 16, not by Delta
17, not by me. Delta 16's target 9 (binary quadratic forms, O(1,1), `xy = Q`,
prehomogeneous vector spaces) is still unperformed and is now joined by Delta
17's. Until they are, no novelty attaches to any of §17.2, §17.3, §17.12,
§17.16–17.19, and citations should carry that.

## 6. What is NOT checked

Everything else. Specifically, and to prevent later drift:

- **§17.2–17.5 torus/Weyl.** T17.3, T17.5, T17.8 are not formalised. T17.5
  (`τ diag(t⁻¹,t) τ⁻¹ = diag(t,t⁻¹)`) is a two-line matrix computation and
  would be cheap; T17.8 (the fibre `pq=c` is a `G_m`-torsor) needs a field and
  is not a lattice statement at all.
- **§17.9 C17.15.** `Σ_ℓ s_ℓ = Ω(p)+Ω(q) = 2` for two primes. Needs `Ω` and a
  factorisation theory; not present.
- **§17.10–17.11, 17.16–17.19.** Λ-weights, character duality, `A_{k-1}` root
  systems, formal groups, p-adic logarithms: nothing formalised.
- **§17.20 Synthesis 17.32** (the contextual equivalences `Γ_∞ ⊢ G_m⁺≃G_a`,
  `Γ_p ⊢ U_1≃pℤ_p`, `Γ_formal,ℚ ⊢ Ĝ_m≃Ĝ_a`, no global one). This is the most
  interesting formalisation target in the delta and the one §17.23.6 explicitly
  defers. I agree it should be deferred: the mathematics of *what the context
  Γ is* has to be settled before a type-theoretic encoding means anything, or
  the formalisation will encode a guess.
- **§17.21's obstruction question.** Left open, correctly.

## 7. Rigor boundary

- **Checked:** `thm17-1-lower`, `thm17-1-upper`, `NonNeg`, `ConeNN`,
  `thm17-13-fwd`, `thm17-13-bwd`, `archimedeanCone`, `localCone`,
  `sameTheorem`, `zeroInClosedCone`, `zeroNotInOpenCone`, in
  `formal/cubical/CenterRelative.agda` §8, under
  `--cubical --guardedness --safe --no-import-sorts`, Agda 2.6.3 + cubical
  v0.5, exit 0. No postulates, holes, or unsafe pragmas anywhere in the module.
- **Reused, not reproved:** `thm16-3-diff`/`thm16-3-sum` serve as
  `thm17-1-lower`/`thm17-1-upper` by definition.
- **Cited, not proved here:** `pos+`, `posNotnegsuc`, `injPos` from cubical
  v0.5; §4's `G_m(ℤ) = {±1}`.
- **No novelty claimed anywhere.** T17.13 is elementary lattice algebra; the
  self-similarity is definitional; §5's items are classical by the delta's own
  statement.

## 8. Successor seeds

1. `SEARCH`, now the highest-priority item in this branch and named by **both**
   deltas: binary quadratic forms, `O(1,1)`, the hyperbola `xy = Q`,
   prehomogeneous vector spaces, and the adelic/automorphic treatment of the
   split rank-one pair. Two deltas have now deferred it. A third deferral would
   make it a habit, and `PROTOCOL.md` §4 requires a recorded search before any
   novelty claim. **This should be done before more formalisation.**
2. `PROVE`: T17.5, the Weyl conjugation, as a 2×2 matrix identity over ℤ. Cheap
   (`M2Unimodular.agda` already has the toolkit) and it would make C17.6's
   identification concrete rather than nominal.
3. `PROVE`: Delta 16 target 5 / Delta 17 §17.16 — the `k`-ary case and the claim
   that **binary parity is exceptional**. Both deltas want it; it is finite
   representation theory; it is still the most substantive open formalisation.
4. Deferred by agreement with §17.23.6: Synthesis 17.32's contextual
   equivalences.
