# The barrier belongs to the line, not to arithmetic

**Status:** two checked Agda modules and one retraction.
**Artifacts:** `formal/cubical/NaturalMachine/SuccessorIsNotTropical.agda`
(exists, checks), `formal/cubical/NaturalMachine/PythagoreanTransition.agda`
(new, checks — Agda 2.6.3 / cubical v0.5, `--safe`, no postulates, no holes,
exit 0).
**Sources:** Brahmagupta, *Brāhmasphuṭasiddhānta* ch. 18 (kuṭṭakādhyāya), 628 CE
— samāsa-bhāvanā and antara-bhāvanā. Voevodsky, univalence.

---

## 1. What this corpus claimed

`SuccessorIsNotTropical` proves `disjoint-support`: no prime divides two
consecutive integers, so `n` and `n+1` share **not one coordinate** in the
multiplicative chart. The module then says, in its own words, that this is
"the parity barrier … a chart incompatibility", that "`disjoint-support`
below is its whole content", and it closes with

> The object to build is the transition itself.

Two of those three sentences are over-claims and the third was never acted
on. This note retracts the over-claims and builds the object.

## 2. The retraction

`disjoint-support` is a theorem about **ℕ equipped with the successor**. It
is not a theorem about arithmetic, and it does not identify a barrier
intrinsic to having both an additive and a multiplicative structure on one
set.

The reason it looked intrinsic is that ℕ's additive generator is `1`, which
is a **unit**: multiplicatively invisible, norm one. An additive law whose
generator is invisible in the multiplicative chart will of course produce
steps with no multiplicative locality. That is a property of the chosen
generator, not a fact about the coexistence of the two structures.

The test is immediate: keep the arithmetic, change the additive law, and see
whether the incompatibility survives. It does not.

## 3. The conic, where the transition exists

Take pairs `(a,b)` over any commutative ring, the norm `N(a,b) = a² + b²`,
and the composition

```
(a₁,b₁) ⊗ (a₂,b₂) = (a₁a₂ − b₁b₂ , a₁b₂ + a₂b₁).
```

This is **samāsa-bhāvanā at D = −1** — Brahmagupta's composition law for
`x² − D y²`, 628 CE, whose entire content is that the norm is multiplicative.
`Bhavana.agda` already checks the general `D` in this repository; the case
`D = −1` is the one that is a *circle*, and it is the case nobody here ran.

The circle's additive law is `rot g u = u ⊗ g`, translation by a fixed point.
Against `disjoint-support`, its behaviour in the multiplicative chart is the
exact opposite:

```
rot-norm :  N (u ⊗ g)  ≡  N u · N g
```

The conic's successor is not merely visible in the multiplicative chart. It
**is multiplication by a constant there.** Zero locality on the line; total
locality on the circle; same ring, same norm, same chart. So the obstruction
`SuccessorIsNotTropical` measured is the line's.

## 4. The transition map, built

A Pythagorean triple is a pair whose norm is a square, `N u ≡ z · z`. Three
theorems, all checked:

| statement | content |
|---|---|
| `triple-⊗` | triples are **closed** under bhāvanā, with hypotenuse `z·w` |
| `euclid` | `gen t = t ⊗ t` sends any pair to a triple with hypotenuse `N t` |
| `gen-hom` | `gen (s ⊗ t) ≡ gen s ⊗ gen t` |

`euclid` says Euclid's parametrisation `(p²−q², 2pq, p²+q²)` is the single
word **squaring**, once the pair rather than the number is the object.

`gen-hom` is the transition map the earlier module asked for. The parameter
chart and the triple chart carry the *same* composition law, and the
parametrisation intertwines them. There is no defect to measure: the chart
change is a monoid homomorphism, exactly.

Concretely, checked by `refl` over ℤ:

```
gen (2,1)         = (3,4)                      the 3–4–5 triple, by squaring
(3,4) ⊗ (5,12)    = (−33,56)                   33² + 56² = 65² = (5·13)²
```

Triples are not a list to be enumerated. They are a **monoid**, and its law
was written down in 628.

## 5. Where univalence is load-bearing

When `N g ≡ 1`, `rot g` is invertible and its inverse is composition with the
conjugate — which is **antara-bhāvanā**, Brahmagupta's second law, present in
the same chapter for exactly this purpose. So:

- `rotEquiv g h : Pair ≃ Pair`,
- `rotPath  g h : Pair ≡ Pair` by univalence,
- `defect-vanishes : (λ u → N (rot g u)) ≡ N`.

That last term is Delta 15's structured defect `Def_Str` computed for the
norm along the identification, and it vanishes. The circle's translations are
**identifications of the circle carrying its structure with itself**.

The line has no such family, and `disjoint-support` is the proof that it does
not. So the honest statement of the difference between the two additive laws
is not about primes at all:

> One additive law is a family of structure-preserving identifications.
> The other is not. That is the whole of it.

`ua` is doing real work here. Without it "the translations are identifications"
is a slogan; with it, `rotPath` is a term and `defect-vanishes` is its
structured-defect computation.

## 6. What is *not* claimed

Nothing here bears on the distribution of primes, on the parity obstruction
in sieve theory, or on the walk's asymptotics. The walk runs on the line.
Whether the walk can be made to run on a conic — whether there is a machine
whose state moves by bhāvanā rather than by successor — is open, is the
question this note leaves, and is not touched by anything above.

What *is* settled: the sentence "the barrier is a chart incompatibility" was
wrong as stated, and the object that sentence said was missing exists,
is elementary, and predates every European name attached to any of it.

## 7. Ledger

- Proved: §3, §4, §5 — all terms in `PythagoreanTransition.agda`, ring
  identities discharged by the CommRingSolver (exact symbolic computation,
  which CLAUDE.md admits as proof), the ℤ instances by `refl`.
- Retracted: the reading of `disjoint-support` as an obstruction intrinsic to
  arithmetic. The theorem stands; its interpretation in that module's §4 does
  not, and should be read as scoped to the line.
- Open: does the walk admit a conic form? `SumProductTorus` gives the
  multiplicative chart, `PythagoreanTransition` gives an additive law
  compatible with it, and nothing yet connects the walk's `lcm` state to
  either.
