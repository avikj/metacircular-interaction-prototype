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
---

## Independent audit by opus-vestigial

# Delta 17 audit: the split torus is correct, standard, and already closed here as a no-go

**Auditor:** `opus-vestigial` (Claude Opus 5), 2026-08-14.
**Target:** *Prime-Pair Atlas — Delta 17*, "Split torus, invariant theory, and
adelic relative geometry", supplied by the human owner from the external
Prime-Pair library.
**Disposition:** INGESTED AS NAVIGATION, NOT VERIFICATION — the precedent
`STATE.md` already set for `PRIME_PAIR_FIELD_PROGRAM_LIBRARY_INDEX`.
**Every citation below was opened and read this session, not quoted from
recall** (`FAILURES.md` F34 is what that rule is for).

---

## 0. Verdict, first

The algebra is right. Almost none of it is new to this repository, and the
part that looks most like a discovery — *"the same rank-one center/relative
pattern appears at the archimedean place and at every finite place"* — is
this corpus's own most expensive recurring illusion, in a new costume.

Precisely:

| Delta 17 | status here |
|---|---|
| §17.1–17.5 split torus, Weyl, invariant | correct, standard, and **already closed as a no-go**: `REPORT.md` Lemma 1.3 |
| §17.4 one-leg reflection ≠ Weyl | already an **operator identity**: `ADELIC.md`:82 `JSJ=D`, `JDJ=S` |
| §17.7–17.9 local valuation cone `(s_ℓ,d_ℓ)` | correct; the "self-similarity" is one linear map applied twice |
| §17.10–17.11 Mellin as Fourier on the divisor lattice | **already done and audited**: `ADELIC.md` §1, `papers/crossover.md` §2 |
| §17.13–17.14 SU(1,1) | flagged by its own author as unmatched; the rank-one coincidence is a null comparison until a map is exhibited |
| §17.16–17.20 additive vs multiplicative `A_{k−1}`, logarithm | correct and classical |
| **§17.21 the descent-obstruction question** | **the one item worth taking**, and it is a genuinely better question than the one it replaces |
| C17.34 humility boundary | correct, and it is the document's best sentence |

---

## 1. The no-go the document walks past

Delta 17's T17.3 reads: *"The connected split orthogonal group SO⁺(1,1) is
isomorphic to G_m over appropriate base."*

"Over appropriate base" is carrying the entire arithmetic content, and this
repository has already computed what happens over the base that matters.
`REPORT.md`:55, verbatim:

> **Lemma 1.3 (no arithmetic Lorentz group).** The group of ℤ-linear maps
> preserving the form `q(S,D)=S²−D²` and orientation is `{±I}`.

That is **V3** — machine-checked in Lean, `formal/pairfield/Pairfield/Lorentz.lean`
(`LEAN_STATUS.md`; `STATE.md` row "V3 formalization"). And `REPORT.md`:59
closes the lane in terms that anticipate Delta 17 exactly:

> So there is no discrete boost dynamics acting on prime pairs: the
> "Lorentzian" reading of `S²−D²=4Q` is **inert**. … We looked for more and
> found nothing; we consider this angle closed unless a specific
> non-functorial computation is proposed.

Delta 17 half-arrives at this itself, at P17.10: *"the ambient torus symmetry
is broken arithmetically by the integral prime-supported lattice."* That is
the right instinct and the weak form. The sharp form is a theorem with a
Lean proof: over ℤ the group is not "broken", it is **`{±I}`** — the orbit
through an integral point is a single point up to sign, so there is no
torus action left to break.

**Consequence for §17.5 and §17.8.** T17.8 (the fiber `pq=c` is a
`G_m`-torsor after choosing a point) is true over a field and is the standard
picture. Over ℤ the torsor has, generically, *one* point up to sign — which
is why C17.9's "ratio is the orbit coordinate" buys nothing arithmetically:
the orbit is a point. The document's §17.6 says the prime condition "is not
invariant under continuous `G_m` scaling"; the stronger true statement is
that there is no nontrivial integral scaling to be non-invariant under.

---

## 2. The genericity diagnosis, which is the main return

`REPORT.md` §1 exists to mark a line, and it names this precise failure mode:

> every displayed identity (`Z = P P̄ ≥ 0`, `S²−D²=4Q`) holds for **arbitrary
> sequences** and carries **zero arithmetic content**.

Delta 17's C17.14 — *"a genuine self-similarity between additive pair
coordinates and multiplicative valuation coordinates"* — is an instance.
Unfold it:

- archimedean: `(p,q) ↦ (W,R) = (p+q, q−p)`;
- at `ℓ`: `(v_ℓ(p),v_ℓ(q)) ↦ (s_ℓ,d_ℓ) = (v_ℓ(p)+v_ℓ(q), v_ℓ(q)−v_ℓ(p))`.

These are **the same 2×2 integer matrix** `[[1,1],[−1,1]]` applied to two
different pairs of numbers. That the sum/difference change of basis is
available wherever there are two coordinates is not self-similarity of
arithmetic; it is one linear map used twice. T17.13's cone
`{(s,d) : s ≥ |d|, s ≡ d mod 2}` is the image of `ℕ²` under that map, and
the `mod 2` parity constraint is its determinant `2` — not an arithmetic
phenomenon but the index of the sublattice.

The corpus already priced this class of observation. `FIVE_FACES.md` answers
the analogous question about FLT/RH/Goldbach/twins/Collatz with:

> they share a *shape* … and that shape is a real observation with **no
> technical content**, predicting nothing about method, difficulty, or
> barrier type.

Same verdict here, and it is not a dismissal of the section: §17.7's
valuation *action* (T17.11: `d_ℓ ↦ d_ℓ + 2v_ℓ(t)` with `s_ℓ` invariant) is
correct and is the honest content. What must not be inferred from it is that
the archimedean and finite pictures are *the same object*. They are two
applications of one change of basis.

**Sharpening to C17.15, which is correct.** I began writing this up as a
scope error and it is not one. `Σ_ℓ s_ℓ = Ω(p)+Ω(q)` and
`Σ_ℓ d_ℓ = Ω(q)−Ω(p)`; imposing **both** `= 2` and `= 0` gives
`Ω(p)=Ω(q)=1`, i.e. both prime, and the converse holds. So C17.15's
"is a fixed sector" is an equality, correctly. Worth stating because it is
load-bearing: the `d`-charge is **not** decorative — the `s`-charge alone
admits `(6,1)` (`Ω(6)=2, Ω(1)=0`), which is not a prime pair.

---

## 3. Already answered, with the location

`ALREADY_ANSWERED.md` and `LEAKAGE_LANDINGS_WERE_ALREADY_NAMED.md` record
that the highest-yield first move in this corpus is the lookup, not the
build. Two Delta 17 programs are already discharged:

**P17.16 / Program 17.23** — *"could make the Mellin/zeta representation a
Fourier transform on the divisor/valuation lattice rather than an unrelated
analytic trick"*, and *"identify what singular series and archimedean factor
become in this language."*

This is done. `ADELIC.md` §1 is the machine-verified identity of the
Hardy–Littlewood singular series with a renormalized critical Bost–Connes
correlator on `Ẑ = ∏_p ℤ_p` (`exp8`), and it credits the spectral
Wiener–Khintchine/Ramanujan–Fourier reading to **Gadiyar–Padma, Physica A
269 (1999) 503–510** (`ADELIC.md`:31). `papers/crossover.md` then carries it
further than Delta 17 asks: the singular series as an *anchored* KMS_β
correlator, with the archimedean factor separated as the critical
temperature `β=1`, plus the exact crossover law. `BUCHSTAB_WINDOW.md`
supplies the one-body archimedean correction the local model misses.

So Program 17.23's translation is not pending; the result of doing it is
`papers/crossover.md`, and the correct successor question is the one that
paper already poses.

**C17.7** — one-leg reflection versus Weyl. Correct, and the corpus has it
as an operator identity rather than a coordinate observation:
`ADELIC.md`:82 gives `JSJ = D`, `JDJ = S`, `J(W⊗W)J = W⊗W`. So the "swaps
sum/gap foliations" reading is exactly `J` conjugating `S` to `D`, and
`ADELIC.md` adds what Delta 17 does not: the Goldbach/gap difference is
**archimedean only** — they agree at every finite place.

---

## 4. What is worth taking

**§17.21, and it is the document's real contribution.** Replacing

> *why can't addition and multiplication be unified?*

with

> *given the local equivalences (real log on `ℝ_{>0}`; formal log over
> `ℚ`-algebras; `log_p` on `1 + pℤ_p`), what is the exact **descent
> obstruction** to gluing them into a global arithmetic equivalence?*

is a strict improvement, because the second question has a *type*: it names
a gluing problem with local data, so it can have an answer, be found to be
already answered, or be shown vacuous. The first cannot.

Two cautions from this corpus's own record before anyone runs at it:

1. **`TOY_OBSTRUCTION.md` is the warning.** Its verdict was
   *annihilation, not obstruction* — every receptacle it built for the
   parity charge (`lim¹`, Čech `H^{≥1}` for all coefficients, the charge
   torsor) **vanished structurally**, so the thing being sought had no home
   rather than a nonzero home. A descent obstruction can be zero for
   uninteresting reasons, and Delta 17's Program 17.33 should register that
   as its leading forecast branch.
2. **`MOONSHOT_PORTFOLIO.md` forbids the conflation** this section risks:
   *"There is no single 'information-loss' theorem behind all the
   problems"*; it separates set-fiber/descent failure from cohomological
   local-to-global obstruction from spectral sign failure, and says
   *"conflating them recreates the old corpus."* §17.21 is asking a
   type-3 question; it must not absorb the type-1 and type-4 material in
   §§17.13–17.14.

**C17.34** — *"Geometry can unify the ambient spaces without solving the
arithmetic measure."* This is right, it is the correct humility boundary,
and it is the sentence that should govern the rest of the document. It is
also, almost verbatim, `REPORT.md` §1's line about the minor-arc obstruction
being untouched by any of the ambient identities.

---

## 5. Standing SEARCH obligations before any novelty language

`PROTOCOL.md` §4: novelty claims require a **recorded** search. None of the
following may be called new without one, and all are almost certainly
classical:

- rank-one split torus, Weyl `ℤ/2`, `SO⁺(1,1) ≅ G_m` (any algebraic-groups
  text; Springer, Borel);
- the `A_{k−1}` root lattice as the character lattice of the diagonal torus
  modulo the diagonal character (T17.24);
- `G_m ≅ G_a` formally over `ℚ`-algebras via `log(1+X)` (T17.28 — the
  document already labels this "Known", correctly);
- `log_p` on principal units (C17.30);
- the exponential/logarithm exact sequences and idelic cohomology of
  Program 17.33 — this is mature arithmetic geometry and the search should
  precede, not follow, the work.

Delta 17 itself says *"search automorphic/prehomogeneous-vector-space
literature first"* (Program 17.17) and *"translate before claiming novelty"*
(Program 17.23). Both instructions are correct and are hereby the binding
form of this ingestion.

---

## 6. Rigor boundary

**Verified this session by opening the file:** `REPORT.md` Lemma 1.3 and the
§1 "angle closed" paragraph; the existence of
`formal/pairfield/Pairfield/Lorentz.lean`; `ADELIC.md`:82 (`JSJ=D`) and
`ADELIC.md`:31 (Gadiyar–Padma citation); `FIVE_FACES.md`'s "shape with no
technical content" verdict.

**Checked by hand:** the `(6,1)` witness for §2's sharpening
(`Ω(6)=2, Ω(1)=0`, so `Σs=2` with `Σd=−2`); the light-cone identities
`u_∓ = W∓R = 2p, 2q` and `W²−R²=4pq`; that the hyperbolic-rotation formulas
of §17.2 are correct as written, so the document's "(up to sign convention)"
hedge is unnecessary.

**Not verified:** that `Lorentz.lean` currently builds — this container has
no Lean toolchain, and `LEAN_STATUS.md`'s green is a past claim, which
`FAILURES.md` F39/F40 say is not present evidence. The *mathematics* of
Lemma 1.3 is three lines and is checked by reading; the formalization's
current status is an open replay.

**Not claimed:** any assessment of §§17.12–17.14 (SU(1,1), discrete series)
beyond noting that the document declines to claim a theorem there itself.
That restraint is correct and I am not overriding it in either direction.
Whether the Hahn/SU(1,1) branch has a genuine split-torus origin is Program
17.20's question and it is open.
