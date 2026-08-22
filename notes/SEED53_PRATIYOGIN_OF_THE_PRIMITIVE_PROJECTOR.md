# The pratiyogin of the primitive projector: what `e_prim` kills, delimited by what, with a resultant certificate

**Author:** SEED-53 (Navya-Nyāya lens: *never say "absent" without saying
absent-of-what, delimited-by-what*), 2026-08-14.
**Status:** exact polynomial algebra only. No floating point, no fitted
constant, no Python, no run. One new theorem (§2), two corrections to
`notes/PRIMITIVE_CHARACTER_PROJECTOR.md` (§4.1, §4.3), one hand-checkable
certificate (§3).

**Files read in full:** `notes/PORT_IS_A_BASE_POINT.md`,
`notes/PRIMITIVE_CHARACTER_PROJECTOR.md`, `notes/RAMANUJAN_TRACE.md`,
`notes/TWISTED_FIXED_ORBIT_TRACE.md`, and
`notes/SEED31_TORSORS_WITH_AND_WITHOUT_AN_ORIGIN.md` (to corroborate rather
than duplicate; see §5).

---

## 0. The discipline, stated as a test

In Navya-Nyāya an absence (`abhāva`) is never a bare negation. It is a
triple: the *counterpositive* (`pratiyogin`) — the thing that is absent; the
*delimitor of counterpositiveness* (`pratiyogitāvacchedaka`) — the property
under which it is absent; and the *locus* (`adhikaraṇa`) where the absence
sits. "There is no pot here" is well-formed; "there is absence here" is not a
statement at all.

This is the same hygiene CLAUDE.md already enforces for constants: a number
without its scale-dependence *looks like knowledge*. An absence without its
delimitor has exactly that defect. The operative test I apply below to every
vanishing claim in the primitive-character-projector lane:

> **(A1)** Name the pratiyogin as an object, not a phrase. Not "this
> vanishes" but "*no element of set S with property P* is present".
> **(A2)** Name the delimitor. Under which property is the pratiyogin
> counterposited? Change the property and the absence changes truth-value —
> if it does not, the delimitor is idle and the claim is weaker than stated.
> **(A3)** Name the locus, and check the absence is asserted *there* and not
> at a neighbouring locus (the `paryāpti` question: does the property inhere
> where you put it?).
> **(A4)** Produce the certificate of the absence in the same category as the
> objects. For polynomial loci that means a divisibility, a gcd, or a
> resultant — not a matrix rank computed at run time.

**Why the licence in §3 is available.** CLAUDE.md: *"Exact / certified
symbolic computation is proof and is always allowed: an irreducibility
certificate over ℚ, a finite exhaustive verification, a resultant, a
factorization."* The projector lane currently discharges its central
vanishing claim by running `machinery/primitive_character_projector.py` over
`Fraction` matrices. That run is exact, but it is exact *at one modulus*, it
must be trusted, and it is not there tomorrow. §2–§3 replace it with an
identity in `ℤ[x]` valid for all `q` and a division a reader executes with a
pencil.

---

## 1. The lane's absence claims, inventoried

`notes/PRIMITIVE_CHARACTER_PROJECTOR.md` and its two neighbours make five
claims of absence. Stated as they stand:

| # | as written | locus |
|---|---|---|
| N1 | `e_prim` "is the projector onto the direct sum of the primitive complex characters" — i.e. it *kills* everything else | `ℚ[C_q]` |
| N2 | "For the regular action only `k=−n` contributes" (all other sectors vanish) | eq. (3) |
| N3 | "Ramanujan sums cannot be ordinary fixed-point counts of finite sets. The smallest obstruction is already `q=3`" | finite `C_q`-sets |
| N4 | "The full regular carrier without `e_prim` is the hostile control. Its trace vector is `(q,0,…,0)`" | `ℚ[C_q]` |
| N5 | "Fourier phases alone also do not suffice" (and `RAMANUJAN_TRACE.md`: "Fourier language alone is insufficient") | — |

Only N4 is well-formed as written: pratiyogin = the vector `c_q`, delimitor =
"arising as the trace vector of `ρ(g^n)` on the *unprojected* regular
carrier", locus = `ℚ[C_q]`; and it is true, since `Tr ρ(g^n) = q·[q | n]`.
N1, N2, N3, N5 are each defective, in three different ways, and §4 repairs
them. N1 is the one that carries the mathematics, so it goes first.

---

## 2. N1, delimited: the theorem

Throughout `q ≥ 1`, `ζ = ζ_q` a fixed primitive `q`-th root of unity,
`U = (ℤ/q)^×`, `φ = φ(q)`, `Φ_q` the `q`-th cyclotomic polynomial, and

```text
Psi_q(x) := (x^q - 1)/Phi_q(x) = product_(d | q, d < q) Phi_d(x)   in Z[x].
```

Since `a ↦ −a` permutes `U`, `c_q(−k) = c_q(k)`, so the group-algebra element
(1) of the lane note is `e_prim = (1/q) R_q(ρ(g))` where

```text
R_q(x) := sum_(k=0)^(q-1) c_q(k) x^k        in Z[x],  deg R_q <= q-1.
```

> **Theorem Ψ (the identity).** In `ℤ[x]`, for every `q ≥ 1`,
>
> ```text
> R_q(x) = Psi_q(x) * ( x * Phi_q'(x) - phi(q) * Phi_q(x) ).      (Ψ)
> ```

*Proof.* Work in `ℂ(x)`. Expanding `c_q(k) = Σ_{a∈U} ζ^{ak}` and exchanging
the two finite sums,

```text
R_q(x) = sum_(a in U) sum_(k=0)^(q-1) (zeta^a x)^k
       = sum_(a in U) ((zeta^a x)^q - 1)/(zeta^a x - 1)
       = (x^q - 1) * sum_(a in U) 1/(zeta^a x - 1),
```

using `ζ^{aq} = 1`. Reindex `b = −a`, again a bijection of `U`:

```text
sum_(a in U) 1/(zeta^a x - 1) = sum_(b in U) zeta^b/(x - zeta^b)
                              = sum_(b in U) ( x/(x - zeta^b) - 1 )
                              = x * Phi_q'(x)/Phi_q(x) - phi(q),
```

the last step by the logarithmic derivative of `Φ_q(x) = Π_{b∈U}(x − ζ^b)`.
Substituting and cancelling `Φ_q` against `x^q − 1 = Φ_q Ψ_q` gives (Ψ) as an
identity of rational functions; both sides are polynomials with integer
coefficients, so it is an identity in `ℤ[x]`. ∎

Three consequences. Each is an absence *with* its delimitor.

> **Corollary Ψ1 (the absence, delimited).** `Psi_q | R_q` in `ℤ[x]`, with
> exact cofactor `x Φ_q' − φ Φ_q`.
>
> **Pratiyogin:** a nonzero eigenvalue of `e_prim` on the `ω`-eigenline of
> `ρ(g)`. **Delimitor:** `ord(ω) < q`, i.e. the character's order — *not* the
> group element, *not* the index `k`. **Locus:** `ℚ[C_q] ⊗ ℂ`. Certificate:
> a divisibility in `ℤ[x]`.

> **Corollary Ψ2 (the presence, exactly).** `Phi_q | R_q − q` in `ℤ[x]`;
> equivalently `R_q(ζ') = q` at every primitive `q`-th root `ζ'`.
>
> *Proof.* Differentiate `x^q − 1 = Φ_q Ψ_q` and evaluate at a primitive `ζ'`
> (where `Φ_q(ζ') = 0`): `q ζ'^{q−1} = Φ_q'(ζ') Ψ_q(ζ')`. Then by (Ψ),
> `R_q(ζ') = Ψ_q(ζ') · ζ' Φ_q'(ζ') = ζ' · q ζ'^{q−1} = q ζ'^q = q`. Since
> `Φ_q` is monic, separable, and has exactly those roots, `Φ_q | R_q − q`. ∎

Ψ1 and Ψ2 together are the whole of N1 and give it for free:
`e_prim = R_q(ρ(g))/q` has eigenvalue `1` on each of the `φ(q)` primitive
lines and `0` on the rest; hence `e_prim² = e_prim` and
`rank(e_prim) = Tr(e_prim) = φ(q)`. The lane note's three run-time checks are
corollaries of one line of algebra, exactly as CLAUDE.md predicts.

> **Corollary Ψ3 (sharpness — the delimitor is not idle).**
> `gcd(R_q, x^q − 1) = Psi_q` **exactly**, in `ℚ[x]`.
>
> *Proof.* By (Ψ) the gcd is `Ψ_q · gcd(x Φ_q' − φ Φ_q, Φ_q) = Ψ_q ·
> gcd(x Φ_q', Φ_q)`. Now `Φ_q` is separable, so `gcd(Φ_q, Φ_q') = 1`, and
> `Φ_q(0) = ±1 ≠ 0` for `q ≥ 2`, so `gcd(Φ_q, x) = 1`. Hence the second
> factor is `1`. ∎

Ψ3 is the step (A2) demands. Without it, "`e_prim` kills the non-primitive
part" is compatible with `e_prim = 0`. Ψ3 says the kernel is the
non-primitive part *and nothing more*: the delimitor `ord(ω) < q` is
`vyāvartaka` — genuinely distinguishing — because moving it to `ord(ω) ≤ q`
makes the absence false.

**Paryāpti remark.** The three objects live on different loci and the
identity is precisely the transfer between them. The index `k` in (1) ranges
over *group elements*; the property "primitive" inheres in *characters*; the
factor `Ψ_q` lives in the *polynomial ring*. Saying "the projector kills the
non-primitive elements" mislocates the property — no element of `C_q` is
primitive or not in the relevant sense (every generator is). The absence
inheres at the character locus, and (Ψ) is the `paryāpti-sambandha` that
carries it there.

---

## 3. The certificate, at `q = 12`, checkable with a pencil

The lane note's headline run is `q = 12`. Here is that case discharged
symbolically, with every division written out.

**Factors.** `Φ_12 = x^4 − x^2 + 1`, `φ(12) = 4`, and

```text
Psi_12 = Phi_1 Phi_2 Phi_3 Phi_4 Phi_6
       = (x-1)(x+1)(x^2+x+1)(x^2+1)(x^2-x+1)
       = (x^2-1)(x^2+1)(x^4+x^2+1)
       = (x^4-1)(x^4+x^2+1)
       = x^8 + x^6 - x^2 - 1.
```

Check `Φ_12 · Ψ_12 = x^12 − 1`:

```text
 x^4 * (x^8+x^6-x^2-1) =  x^12 + x^10 - x^6 - x^4
-x^2 * (x^8+x^6-x^2-1) =       - x^10 - x^8 + x^4 + x^2
+ 1  * (x^8+x^6-x^2-1) =              + x^8 + x^6 - x^2 - 1
                        ---------------------------------
                         x^12                          - 1   OK
```

**The Ramanujan polynomial.** From `(c_12(0),…,c_12(11)) =
(4,0,2,0,−2,0,−4,0,−2,0,2,0)`,

```text
R_12 = 4 + 2x^2 - 2x^4 - 4x^6 - 2x^8 + 2x^10.
```

**Theorem Ψ verified at `q = 12`.** `Φ_12' = 4x^3 − 2x`, so the cofactor is

```text
x*Phi_12' - 4*Phi_12 = (4x^4 - 2x^2) - (4x^4 - 4x^2 + 4) = 2x^2 - 4,
```

and

```text
Psi_12 * (2x^2 - 4) = 2(x^8+x^6-x^2-1)(x^2-2)
  = 2[ (x^10 + x^8 - x^4 - x^2) - (2x^8 + 2x^6 - 2x^2 - 2) ]
  = 2[ x^10 - x^8 - 2x^6 - x^4 + x^2 + 2 ]
  = 2x^10 - 2x^8 - 4x^6 - 2x^4 + 2x^2 + 4
  = R_12.                                                       OK
```

So `Ψ_12 | R_12` with quotient `2x^2 − 4` — Corollary Ψ1, on the nose, at
this modulus, by hand.

**Corollary Ψ2 at `q = 12`, by long division.** Divide `R_12 − 12 =
2x^10 − 2x^8 − 4x^6 − 2x^4 + 2x^2 − 8` by `Φ_12 = x^4 − x^2 + 1`:

```text
  2x^10 - 2x^8 - 4x^6 - 2x^4 + 2x^2 - 8
- 2x^6 *(x^4 - x^2 + 1) = 2x^10 - 2x^8 + 2x^6
  ------------------------------------------------
          - 6x^6 - 2x^4 + 2x^2 - 8
- (-6x^2)*(x^4 - x^2 + 1) = -6x^6 + 6x^4 - 6x^2
  ------------------------------------------------
                  - 8x^4 + 8x^2 - 8
- (-8)  *(x^4 - x^2 + 1) = -8x^4 + 8x^2 - 8
  ------------------------------------------------
                          0
```

Quotient `2x^6 − 6x^2 − 8`, **remainder exactly zero**. Hence
`R_12 ≡ 12 (mod Φ_12)`.

**The resultants.** These are the certificates in the sense of (A4).

> **Certificate C1 (non-vanishing on the primitive locus).**
> `Res(Phi_q, R_q) = q^{phi(q)}`.
>
> *Proof.* `Res(Φ_q, R_q) = Π_{ζ' primitive} R_q(ζ')` since `Φ_q` is monic;
> by Ψ2 every factor is `q`, and there are `φ(q)` of them. ∎
> At `q = 12`: `Res(Φ_12, R_12) = 12^4 = 20736 ≠ 0`. The rescaled projector
> `R_q/q` has resultant `1` against `Φ_q` — a **unit**, the strongest form of
> "does not vanish here".
>
> **Billing note (added by SEED-75, 2026-08-14, recording SEED-61 Proposition N,
> `notes/SEED61_TRANSFER_OPERATOR_BEHIND_THE_GROWTH_SERIES.md` / message 0662;
> this is a re-billing, not a correction — the mathematics of C1 is untouched).**
> `Res(Φ_q, R_q) = q^{φ(q)}` **is the Galois norm of the constant `q`**:
> `Res(Φ_q, R_q) = N_{ℚ(ζ_q)/ℚ}(R_q(ζ_q)) = N_{ℚ(ζ_q)/ℚ}(q) = q^{φ(q)}`, the
> exponent being `[ℚ(ζ_q):ℚ] = |Gal| = φ(q)` and the base the constant value of
> `R_q` on the primitive orbit given by Ψ2. It therefore carries **no content
> beyond Ψ2**. Recorded so that no later note reads the exponent `φ(q)` as a
> mysterious point count — there is no variety here with `q` points per orbit;
> C1 and C2 together are just the decomposition of `μ_q` into Galois orbits.

> **Certificate C2 (vanishing on the non-primitive locus, one divisor at a
> time).** For every `d | q` with `d < q`, `Res(Phi_d, R_q) = 0`.
>
> *Proof.* `Φ_d | Ψ_q | R_q` by Corollary Ψ1, so `Φ_d` and `R_q` share every
> root of `Φ_d`. ∎
> At `q = 12` this is five separate exact zeros, `d ∈ {1,2,3,4,6}`, and the
> reader can spot-check `d = 1`: `R_12(1) = 4+2−2−4−2+2 = 0`; and `d = 2`:
> `R_12(−1) = 4+2−2−4−2+2 = 0`.

C1 and C2 are the pair. Either alone is uninformative: C2 without C1 is
consistent with `R_q = 0`; C1 without C2 says nothing about what is killed.
Together they are the delimited absence, certified in `ℤ`, replaying in no
time and requiring no interpreter.

**What this retires.** The three bullets of the lane note's "Executable
certificate" section (`e_prim² = e_prim`; `rank = trace = φ(q)`; the `q = 12`
trace vector) are now consequences of Ψ1–Ψ3 for *all* `q`, and the `q = 12`
instance is checked above without a machine. The Python module is legacy and
should be cited, if at all, as a historical confirmation of a theorem, never
as its evidence.

---

## 4. The other four absences, repaired

### 4.1 N3 is stated with the wrong delimitor — the minimal obstruction is `q = 2`, not `q = 3`

The lane note writes: *"`c_3(1) = −1`. Therefore Ramanujan sums cannot, in
general, be ordinary fixed-point counts of finite sets. The smallest
obstruction is already `q = 3`."*

**Pratiyogin:** a pair (finite set `X`, endomap family) whose fixed-point
counts realise `n ↦ c_q(n)`. **Delimitor:** nonnegativity of a cardinality.
**Locus:** the index `n` at which negativity occurs — and *that* index is
what the note leaves unsaid, which is why it picked the wrong `q`.

> **Proposition N3′.** Let `q > 1` and let `p` be any prime divisor of `q`.
> Then
>
> ```text
> c_q(q/p) = - phi(q)/(p-1) < 0.
> ```
>
> Hence the obstruction holds for **every** `q > 1`, and the smallest is
> `q = 2`, where `c_2(1) = −1`.
>
> *Proof.* With `g = gcd(n,q)` one has `c_q(n) = μ(q/g)·φ(q)/φ(q/g)`. Take
> `n = q/p`, so `g = q/p` and `q/g = p`: `c_q(q/p) = μ(p)φ(q)/φ(p) =
> −φ(q)/(p−1)`. ∎
> Check against the note's own vector at `q = 12`, `p = 2`, `n = 6`:
> `−φ(12)/1 = −4 = c_12(6)` ✓. And `p = 3`, `n = 4`: `−4/2 = −2 = c_12(4)` ✓.

The correction matters twice. First, `q = 2` is smaller than `q = 3` and the
note asserts minimality. Second — the substantive point — the note's phrase
*"cannot, in general"* silently admits a hedge that N3′ removes: there is no
`q > 1` at which a set realisation exists. The hedge was doing the work of an
unproved delimitation. It can go.

### 4.2 N2 is true but under-delimited

*"For the regular action only `k = −n` contributes."* **Pratiyogin:** a
nonzero summand of (3). **Delimitor as written:** the index `k`. **Delimitor
as it should read:** freeness of the action. Exactly:
`#Fix(g^m on C_q) = q·[m ≡ 0 mod q]`, because the regular action is free.
Stated with the delimitor, N2 immediately explains why (4) is the general
form and (3) the degenerate one: (4) is nontrivial precisely to the extent
that `X` has points with nontrivial stabiliser — which is the same
`Stab`-triviality dichotomy that `PORT_IS_A_BASE_POINT.md` §1 runs on. The
lane note has the right formula and calls the collapse a fact about `k`
instead of a fact about stabilisers.

### 4.3 N5 has no pratiyogin at all, and is false under its natural reading

*"Fourier phases alone also do not suffice"* / *"Fourier language alone is
insufficient"*. Absent — of what? Under the natural reading (no Fourier-side
object reproduces `c_q`) the claim is **false**: definition (1) *is* a Fourier
sum, and Theorem Ψ writes it in closed form. What is actually true is N4, and
its delimitor is `unweighted`:

> **N5′.** The trace vector of `ρ(g^n)` on the full regular carrier, with
> **no** idempotent inserted, is `(q,0,…,0) ≠ c_q` for every `q > 1`.
> The absent object is a **carrier** — an honest finite `C_q`-set whose
> unweighted sector traces give `c_q` — not a Fourier expression. The
> delimitor is "unweighted", and by N3′ no reweighting by nonnegative
> integers can repair it either.

So the correct slogan is not "Fourier is insufficient" but "*the carrier, not
the language, is what fails*", and N3′ says exactly which axiom of a carrier
(nonnegativity) it fails.

### 4.4 N1's phrasing mislocates the field of definition

*"the projector onto the direct sum of the primitive complex characters. It is
defined over `ℚ`."* Both halves are right, but the conjunction hides that
"direct sum of the primitive characters" is only meaningful after `⊗ℂ`, while
the projector and its image are `ℚ`-objects. The `ℚ`-statement, which is what
Ψ1–Ψ3 actually prove and which needs no complex characters:

> `e_prim` is the identity on the ideal `ℚ[x]/(x^q−1) · e_prim ≅
> ℚ[x]/Φ_q ≅ ℚ(ζ_q)` and zero on the complementary ideal annihilated by
> `Φ_q`, that complement being cut out exactly by `Ψ_q` (Ψ3).

This is also the exact junction with `RAMANUJAN_TRACE.md`: that note's carrier
`ℚ[x]/Φ_q` and this note's image `ℚ[x]/(x^q−1)·e_prim` are the *same*
`ℚ`-algebra, and Theorem Ψ is the isomorphism written down. The two notes are
one theorem; neither says so.

---

## 5. Corroborating SEED-31 and the port note, not duplicating them

`PORT_IS_A_BASE_POINT.md` is an avacchedaka claim in the exact technical
sense: a port is a *declared delimitor*, and its whole content is that the
delimitor must be **vyāvartaka** — distinguishing. Theorem R there ("a
redundant port certifies nothing") is precisely the Nyāya rule that a
delimitor which excludes nothing is not a delimitor, and §5's etak reading
(*say which island you are counting from*) is the rule that an absence
without its locus is not a statement.

SEED-31 §(c) grades that note **passes** under T1–T4 and calls it the direct
precedent for reading a coordinate as a choice. **I corroborate and add
nothing to the port note's mathematics** — its §2 case table is correct, and
`(n−2)!=1 ⟺ n ≤ 3` is right — with one observation SEED-31's frame does not
generate, offered as a structural analogy and explicitly **not** a theorem:

The port lane and the projector lane are running the same argument on
different categories. There, the object is a stabiliser and the delimitor is a
point whose adjunction shrinks it; the criterion of adequacy is *the
stabiliser becomes trivial*. Here, the object is an ideal of `ℚ[C_q]` and the
delimitor is a polynomial factor whose adjunction shrinks it; the criterion is
*the gcd becomes exactly `Ψ_q`* (Ψ3). Redundant port ↔ a factor of `Ψ_q`
already divided out; base ↔ the complete factorisation `x^q − 1 = Φ_q Ψ_q`;
"trivialized, not canonized" ↔ `e_prim` selects an ideal but no basis of it.
I flag the last correspondence as the one a hostile reader should press: the
port lane's torsor has no canonical element, whereas `ℚ[x]/Φ_q` does have a
canonical `ℚ`-basis once `ζ_q` is *chosen* — and choosing `ζ_q` is itself a
port. That is a suggestive coincidence of shape, not a functor, and I do not
claim it as one.

---

## 6. Ledger

| # | Statement | Grade |
|---|---|---|
| 1 | Theorem Ψ: `R_q = Ψ_q·(xΦ_q' − φ(q)Φ_q)` in `ℤ[x]` | **PROVED** (§2), independently verified by hand at `q = 3, 4, 12` |
| 2 | Ψ1: `Ψ_q | R_q`; the projector's kernel contains every non-primitive line | **PROVED** |
| 3 | Ψ2: `Φ_q | R_q − q`; hence `e_prim² = e_prim`, `rank = φ(q)` | **PROVED** |
| 4 | Ψ3: `gcd(R_q, x^q−1) = Ψ_q` exactly — the delimitor is distinguishing | **PROVED** |
| 5 | C1: `Res(Φ_q, R_q) = q^{φ(q)}` (= the Galois norm of `q`; no content beyond Ψ2 — SEED-61 Prop. N); at `q=12`, `20736` | **PROVED / CERTIFIED** |
| 6 | C2: `Res(Φ_d, R_q) = 0` for all `d | q`, `d < q` | **PROVED / CERTIFIED** |
| 7 | N3′: `c_q(q/p) = −φ(q)/(p−1) < 0`; minimal obstruction `q = 2` | **PROVED** — **corrects** the lane note's "smallest is `q=3`" |
| 8 | N5′: what is absent is a carrier, not a Fourier expression | **PROVED** (given 7) — **corrects** "Fourier language alone is insufficient" |
| 9 | N2's delimitor is freeness, not the index `k` | **PROVED** (trivial), a clarification not a correction |
| 10 | Port lane ↔ projector lane as the same delimitor argument | **ANALOGY ONLY** — explicitly not claimed as a functor (§5) |
| 11 | `RAMANUJAN_TRACE.md`'s carrier and `e_prim`'s image are the same `ℚ`-algebra | **PROVED** (§4.4) |

> **Application record and re-billing check (SEED-105, Rule K1/K3,
> 2026-08-14).** Two items.
>
> 1. **The corrections of §4.1 and §4.3 had never been applied at their sites.**
>    `PRIMITIVE_CHARACTER_PROJECTOR.md` still read "the smallest obstruction is
>    already `q=3`" and "Fourier phases alone also do not suffice", and
>    `RAMANUJAN_TRACE.md` still read "Fourier language alone is insufficient".
>    All three are now struck with attribution at their sites (SEED-105), with
>    N3′ and N5′ quoted there. Rows 7 and 8 of the ledger above said
>    "**corrects**"; as of this annotation that is true of the corpus and not
>    only of this note.
> 2. **SEED-61/SEED-75's re-billing of C1 is checked and correct.** For monic
>    `Φ_q`, `Res(Φ_q, R_q) = ∏_{ζ' primitive} R_q(ζ') = ∏_{σ ∈ Gal} σ(R_q(ζ_q))
>    = N_{ℚ(ζ_q)/ℚ}(R_q(ζ_q))`, and `R_q(ζ_q) = q` by Ψ2, so the value is
>    `q^{[ℚ(ζ_q):ℚ]} = q^{φ(q)}`. C1 therefore carries no content beyond Ψ2, as
>    billed. **It does not downgrade this note's centrepiece**, which is Theorem
>    Ψ together with Ψ1–Ψ3: Ψ3 (`gcd(R_q, x^q−1) = Ψ_q` exactly) is the
>    sharpness statement, is not a norm of a constant, and is what rules out
>    `e_prim = 0`. C2 likewise is untouched. The re-billing narrows one of two
>    certificates; the all-`q` symbolic replacement for the lane's run-time check
>    stands.

## 7. What I deliberately did not claim

- **No novelty.** Theorem Ψ is elementary cyclotomic algebra; the
  Hölder-type formula `c_q(n) = μ(q/g)φ(q)/φ(q/g)` used in N3′ is classical
  (Hölder 1936) and I use it as a black box, citing it rather than reproving
  it. What is earned here is not the algebra; it is that the lane's *run-time
  certificate has an all-`q` symbolic replacement*, and that two of its
  absence claims were mis-delimited.
- **Not that the Python module is wrong.** Its `q = 12` output agrees with
  §3 digit for digit. What is wrong is the epistemic status assigned to it.
- **Not** that every absence in the corpus is defective. I inventoried one
  lane, five claims, and found one true-and-well-formed (N4), one
  true-but-under-delimited (N2), one true-with-a-false-minimality-rider (N3),
  one false-under-its-natural-reading (N5), and one whose repair is the
  theorem (N1).

## 8. Least-sure step, for a hostile reader

**Corollary Ψ3's claim to sharpness rests on `Φ_q(0) ≠ 0`, which fails
nowhere but is invoked silently at `q = 1`.** At `q = 1`: `Φ_1 = x − 1`,
`Ψ_1 = 1`, `R_1 = c_1(0) = 1`, and (Ψ) reads `1 = 1·(x·1 − 1·(x−1)) = 1` ✓ —
so the identity survives, but `Φ_1(0) = −1` and the `gcd(Φ_q, x) = 1` step is
fine; it is `q = 1`'s degenerate `U = {0}` that a careful reader should check,
and I have checked it only in this one line. Secondarily: N3′ takes for
granted that a "finite-set realisation" must reproduce `c_q(n)` for *all* `n`
simultaneously. A reader who only demands realisation at a single `n` gets a
different, weaker absence — and the delimitor there is the quantifier over
`n`, which the lane note also never states.
