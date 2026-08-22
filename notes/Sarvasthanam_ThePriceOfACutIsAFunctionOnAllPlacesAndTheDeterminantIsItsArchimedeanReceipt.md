# सर्वस्थानम् — the price of a cut is a function on ALL places, and the determinant is its archimedean receipt

**Grade.** Reading notes and identifications. **Nothing here is checked by me.**
This container carries no `agda`, no `lean`, no `ghc`: `toolchain=absent`,
`modules=0` — a check that cannot start is 0 checks performed, not N failed
ones. Every `exit 0` cited below reached me as śabda. Claims are marked
CHECKED-ELSEWHERE (with the file), CLASSICAL (with the name and date), or MINE.

**Coverage, stated so nobody mistakes a sample for a survey.** README in full
(five passes), `ANEKANTA.md` §§0–16, `SamagraDarsana` §०a–०d, `TARGET.md`
§§0–4b, `OPEN_PROBLEMS_WE_TOUCH.md` §0/§4/§5, `Dhruva`, `Apunaragamana`,
`Anekanta.agda`, `Durnaya_CollapseIffEveryNayaAgrees`, `Punaragamana/Carrier`,
`Sabda_TheWireHasNoBoolean`, `Yantra`, `Apavartana`, `GoldbachDeterminesZeta`,
`run_the_natural_machine_forever`, `dosa.lekha` entry 0039, one of thirty-four
upstream transmissions. That is a small fraction of 6303 tracked files.
मम-अदर्शनम् ≠ तस्य-अभावः.

**On the name.** सर्वस्थान — "all places" — is used in its plain sense and no
text is claimed for the compound, following `Dhruva`'s and `Apunaragamana`'s
practice. **The mathematics below is not Indian and is not claimed to be:**
places and the product formula are Ostrowski (1916), Hensel, Chevalley (1940),
Tate (1950); Smith normal form is Smith (1861); Ш is Shafarevich–Tate;
the class number formula is Dirichlet (1839). अपवर्तन is Brahmagupta's and is
already carried, correctly fenced, by `Apavartana_…lean`. Naming this file in
Sanskrit does not transfer any of it to the tradition.

---

## 0 · The correction I owe before anything else

I asserted, in session on 2026-08-22, that the corpus's Spec ℤ price function
totals to `log|coker(T)|` when summed over primes with weight `log p`. **That
is false, and `Apavartana_…lean`'s own worked instance refutes it.**

The corpus's price is `p ↦ rank_{𝔽ₚ}(T) = #{i : p ∤ dᵢ}`, so the drop at `p` is
`#{i : p | dᵢ}` — a count of *how many* invariant factors `p` divides. The
cokernel order is `∏ᵢ dᵢ`, which needs `∑ᵢ vₚ(dᵢ)` — *how much*. For
`D = diag(2,12)`, the drops are 2 at `(2)` and 1 at `(3)`, giving
`2 log 2 + log 3 = log 12`, while `det D = 24`. The two disagree at `(2)`,
because `v₂(2)=1` and `v₂(12)=2` and the rank sees only that both are nonzero.

**The counterexample is sharper than the arithmetic slip.** `diag(2,6)` has the
*identical* price function on Spec ℤ — drop 2 at `(2)`, drop 1 at `(3)` — and
cokernel `ℤ/2 ⊕ ℤ/6` of order 12 against `diag(2,12)`'s order 24.

> **The corpus's own price instrument is a lossy observation of the cut, and
> what it cannot see is the p-adic depth.** MINE.

That is `QuotientFiberLaw` applied to the receipt itself. The rank function is
a quotient of the elementary-divisor data; the fibre is the higher valuations;
and by the law, no post-processing of the rank function recovers them — you
need a separating query, and `det` is one.

## 1 · What survives, and it is exact

For a square nonsingular integer cut, `∏ᵢ dᵢ = |det T| = |coker T|`, hence

    log |det T|  =  Σ_p v_p(det T) · log p.                    CLASSICAL (unique factorization)

`Apavartana_…lean` already checks the finite half of this on its instance —
`det_eq : smithDivisors.prod = 24`, with the docstring stating that the product
of the Smith divisors *is the order of the cokernel*. What that file does not
say is that `24` and the ramification table `{(2)↦2, (3)↦1}` are two readings
of one quantity at different places, and that the first is the exact one.

> **`det` is the archimedean receipt for the entire finite ramification locus
> at once.** MINE (the identity is classical; the reading is not stated in the
> file that carries both halves).

## 2 · That identity is the product formula, which is the conservation law

For `x ∈ ℚ˟`, with `|x|_p = p^{-v_p(x)}`:

    Σ_v log |x|_v = 0        i.e.        log |x|_∞ = Σ_p v_p(x) log p.     CLASSICAL

Read literally in this corpus's vocabulary: **sum the local prices over every
place and the total is exactly zero, for every rational number, always.** Loss
is always local. Globally the books have always balanced.

Two consequences, both MINE as readings:

- **Road one is ℚ˟.** The corpus defines road one as the zero-locus of the
  price function. Under the adelic price that zero-locus is not something to be
  reached: it is the rationals, and it was always there. §29 यत् तिष्ठति and
  movement 20's weightless limit are, at this level, *recognitions* rather than
  attainments — which is what `Pratyabhijna` and movement 54 already name, and
  what movement 26 records as the Vedāntic position (the debt was māyā; at the
  paramārtha level no compression occurred). The product formula is that
  sentence with a proof.
- **Every barrier is a local price whose compensating term lives at a place the
  method cannot reach.** A method that accounts only at the finite places has
  computed a partial sum of a total forced to vanish, and the residue it can
  never see is exactly the archimedean term it excluded by construction.

## 3 · The parity barrier, restated

`TARGET.md` §1 derives, from Theorem F (protection: unique KMS annihilates the
charged sector, parity is the charge `(−1,−1,…)`) and Theorem H (exposure: λ is
visible at full strength at the archimedean place), that **the parity barrier is
a property of the place, not of the function**, and that any parity-breaking
method must couple the archimedean place to the finite places. CHECKED-ELSEWHERE
for the two halves; the coupling consequence is stated there as prose.

> MINE: that consequence is the product formula and needs no extra hypothesis.
> The archimedean place is not *one more* place to consult — it is the receipt
> for all the finite places jointly, since `log|x|_∞ = Σ_p v_p(x) log p`. So
> "couple the places" is not a strategy among strategies. It is the only
> relation the places have.

## 4 · Ш is the fibre of "observe at every place"

    Ш(E/K) = ker( H¹(K,E) → ∏_v H¹(K_v,E) )                    CLASSICAL

The map is *observe at every place*. Ш is its kernel — objects invisible to the
entire local observation class while globally nonzero. That is not analogous to
`QuotientFiberLaw`'s fibre. Under `ua` there is no "analogous to": it is the
fibre, for the observation class "all completions."

> MINE, and it is the identification I would most want checked by someone who
> works in the field: **the local–global obstruction machinery of arithmetic
> geometry — Hasse, Ш, Brauer–Manin, descent along torsors — is the most
> developed existing theory of what an observation class cannot see, and it has
> never been applied outside number theory.** The finiteness conjecture for Ш is,
> in this vocabulary, a conservation statement: what is hidden from every place
> at once is bounded.

## 5 · ζ sees the obstruction times road one, and cannot split them

Dirichlet, 1839: `lim_{s→1}(s−1)ζ_K(s) = 2^{r₁}(2π)^{r₂} h R / (w √|d_K|)`.
CLASSICAL.

- `h`, the class number, is the obstruction to unique factorisation — the
  failure of ideals to be principal, **finite-place data, the fibre**;
- `R`, the regulator, is the covolume of the unit lattice. Units are exactly the
  norm-`±1` elements — **zero receipt — so `R` is the volume of road one**, and
  it is archimedean data.

The analytic object sees `hR` and cannot split it; that inseparability is a
named difficulty in the field. BSD's leading coefficient
`|Ш|·Reg·Ω·∏c_p / |E_tors|²` has the same shape: obstruction × free-motion
volume × archimedean period.

> MINE: **obstruction downstairs, road-one volume upstairs, the analytic class
> blind to the split, resolution requiring a change of place.** That is
> `TARGET.md`'s protection/exposure duality, written about a different object,
> a hundred and forty years earlier.

## 6 · The unit group is road one, and bhāvanā is motion along it

`Apunaragamana_…agda` (CHECKED-ELSEWHERE, exit 0) proves that composing with the
fundamental solution `(3,2)` preserves the norm `x²−2y²` while the denominator
strictly increases, so the orbit never returns.

> MINE, and it should be said at the site: that orbit is multiplication by the
> **fundamental unit** of `ℤ[√2]`, and the two properties are Dirichlet's unit
> theorem — the norm-one locus is the units (zero receipt, road one), the group
> is infinite of rank `r₁+r₂−1 = 1`, finitely generated, and the regulator is
> the covolume the growth advances by. **Norm preserved, height strictly
> increasing** is the unit group's defining behaviour. The corpus's growth law
> and Dirichlet's theorem are one statement.

## 7 · The loop I most want someone to walk: contextuality is a local–global obstruction

The corpus holds the Peres–Mermin H¹ class as checked terms — nine observables,
six contexts, the class odd for every gauge translate, `refl` sixty-four times
(CHECKED-ELSEWHERE per README movement 7).

Sheaf-theoretic contextuality (Abramsky–Brandenburger, 2011) is CLASSICAL and
well known: contextuality is the non-existence of a global section for a
presheaf of locally consistent distributions, with cohomological obstructions.

> MINE, and this is the identification, in one line: **contextuality is the
> failure of a Hasse principle for the covering by measurement contexts, and Ш
> is the same object for the covering by places.** Locally consistent
> everywhere, globally impossible; the obstruction group is `H¹` in both cases;
> and by §4 both are the fibre of an observation map in the corpus's exact
> sense.

What that buys, in both directions, and neither is claimed done here:

- **to quantum foundations:** the descent-obstruction toolkit — Brauer–Manin,
  torsor descent, the finiteness questions — as a source of structure for
  contextuality that is not currently used there;
- **to arithmetic:** `ChargeCriterion.agda`'s move. `charge-criterion` is an
  *iff* that decides whether a query set can separate two objects, and
  constructs the separator when it can, with the header's own sentence —
  **separating power is a function of the charge of the query, not of its
  size.** The same shape asked of a local–global obstruction is: which classes
  of global object can a given family of local observations distinguish, decided
  in advance rather than attempted.

## 8 · What is not claimed

- No theorem is proved here and no term is checked. `sorry`-equivalent: this
  entire file. It is śabda about śabda until someone runs a kernel.
- The prior-art position on §7 is **not** established. Abramsky–Brandenburger and
  the cohomology of contextuality are a live literature; whether the
  identification with Ш / the Hasse principle is already written down I did not
  determine, and `WebFetch` was not attempted. **Absence of a located source is
  not evidence of novelty** — `OPEN_PROBLEMS_WE_TOUCH.md` §0, and it binds here.
- §5's reading of `hR` claims nothing about the class-number/regulator
  separation problem beyond restating its shape.
- §0's correction reaches exactly the claim I made in session and nothing in
  `Apavartana_…lean`, whose table and theorems are correct as written and whose
  own docstring already says the price is a *function*, not a number.

---

*Written by claude (Opus lineage) in a session with no toolchain, 2026-08-22,
after five readings of the README at the owner's instruction. Every line above
is either cited to a file, marked CLASSICAL with its name and date, or marked
MINE and therefore owed a proof.*
