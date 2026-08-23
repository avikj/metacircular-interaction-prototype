# The weight a substitution check cannot see: fundamentality of a Pell solution, decided without search

**Agent:** `swarm-0814-08` (2026-08-14)
**Object:** a complete, search-free decision procedure for *fundamentality* of a
Pell solution, with the load-bearing algebraic lemma kernel-checked in Agda.
**Agda:** `formal/cubical/Swarm/S08ChebyshevWeight.agda` — `agda -i . Swarm/S08ChebyshevWeight.agda` → `EXIT=0`.

---

## 0. The draw, and where the lenses split

Eleven files, uniform + rare-corner. Two of them implement the *same ancient
algorithm* under different names — `runtime/panini/cakravala.py` (Bhāskara's
cyclic method for `x² − Dy² = 1`, exact integers) and
`machinery/crystal/chakravala.py` (the cyclic method *abstracted*: "the residual
selects the next move"). A third, `notes/PROOF_EVIDENCE_TERMINOLOGY_AUDIT.md`,
supplies the taxonomy that convicts the first. The rest of the draw
(`data/exp45_reciprocal_decic_ledger.json`, two `claude_ananta` worker messages,
`code/exp26_fresnel_deep.py`, `figures/exp20_product.png`,
`runtime/demo/vocabulary_demo.py`, `machinery/operational_site.py`,
`collab/daemon/madhavi/.gitignore`) is read below only where it bears.

`collab/daemon/madhavi/.gitignore` carries no mathematical content: two lines,
`config.local` and `runtime/`. Recorded and dropped.

`runtime/panini/cakravala.py` states, in its own words, the problem this note
solves:

> That counterexample is kept as a test […] because it is precisely the failure
> a verification-by-substitution check cannot see: the answer is *true* and
> *wrong*.

and concedes its screen is incomplete:

> This is a *necessary* condition for non-minimality of the commonest kind, not
> a decision procedure for minimality; the full check in this module is
> agreement with `pell_continued_fraction`.

**The two drawn lenses answer that concession differently, and the difference is
not stylistic.**

* **Robinson — take the nonstandard model seriously as a place to compute.**
  `verify_solution` tests a *quantifier-free* formula. By transfer it means
  exactly the same thing in ℤ and in any `*ℤ`: it is complete for what it
  checks, and "fundamental" is simply not a satisfaction property of the tuple —
  it is `¬∃(u,v)(1 < u < x ∧ u² − Dv² = 1)`, one quantifier deeper. Robinson's
  answer: *then search the model.* Produce the certificate the way the module
  already does — `pell_brute_force`, and `compare()` cross-checking two solvers.
  Internally that search is legitimate. In `*ℤ` with nonstandard `x` it is
  hyperfinite: internally finite, externally never done. The certificate is
  correct and unbounded, and its size is exponential in the bit-length of `x`.

* **Deligne — purity: weights control what can appear.** Refuse the search.
  The solution set is a group; grade it by the index `n` in `ε = ε₁ⁿ`; and the
  archimedean absolute value bounds the weight. Then membership of a graded
  piece is a polynomial identity, not a search, and only finitely many — indeed
  `O(log x / log D)` — pieces can occur at all.

They give opposite verdicts on the same tuple. At `D = 3`, the pair `(26, 15)`
satisfies `26² − 3·15² = 1`. Robinson's lens: an unimpeachable solution; nothing
in the tuple is wrong; fundamentality was never visible here. Deligne's lens:
**weight 3**, and a weight-3 class cannot appear in the weight-1 graded piece —
the tuple is disqualified by its grading, with no search performed and no second
solver consulted.

The Deligne answer turns out to be *complete*, and that is the object.

---

## 1. The grading (Agda-checked)

Write `(a, b)` for `a + b√D` in ℤ[√D]; `N(a,b) = a² − Db²`; and let

    mulS D (a,b) (c,d) = (ac + Dbd, ad + bc)

be Brahmagupta's *samāsa-bhāvanā* (628 CE), the composition the drawn module
implements as `bhavana`.

**Lemma 0 (Brahmagupta's identity).** `N(p·q) = N(p)·N(q)`.
Agda: `bhavana-norm`.

**Lemma 1 (Chebyshev grading) — the load-bearing statement.**
Let `δ = (u,v)` with `N(δ) = 1`. Then for every `n ≥ 0`

        fst (δⁿ)  =  Tₙ(u),        T₀ = 1, T₁ = u, T_{n+2} = 2u·T_{n+1} − Tₙ.

`D` and `v` do not appear on the right. Agda: `trace-is-Chebyshev`.

*Proof (the one in the Agda, stated once here because it is short).* Set
`(xₙ, yₙ) = δⁿ`. Then `x_{n+1} = xₙu + D yₙ v` and `y_{n+1} = xₙ v + yₙ u`, so

    x_{n+2} = (xₙu + Dyₙv)u + D(xₙv + yₙu)v = u²xₙ + 2uDvyₙ + Dv²xₙ,
    2u·x_{n+1} − N(δ)·xₙ = 2u²xₙ + 2uDvyₙ − (u² − Dv²)xₙ = u²xₙ + 2uDvyₙ + Dv²xₙ.

These are *equal as polynomials in* `D, u, v, xₙ, yₙ` — the module's `step-raw`
is exactly this identity, with the norm displayed rather than assumed. Setting
`N(δ) = 1` turns it into the Chebyshev recurrence, and two-step induction
finishes. ∎

The point of writing it with the norm displayed: the recurrence is *not* a fact
about Pell solutions, it is a fact about ℤ[√D] that degenerates to Chebyshev
exactly on the norm-one locus. That is what "purity" buys here — the grading is
visible in the first coordinate alone, so the index survives forgetting `D`.

---

## 2. The weight bound

**Lemma 2.** If `ε = x + y√D = ε₁ⁿ` with `(x,y)` a positive solution and `ε₁`
fundamental, then

        n  <  log(2x) / log(2 + √D).

*Proof.* `x₁² = 1 + D y₁² ≥ 1 + D ≥ 3`, so `x₁ ≥ 2` and `y₁ ≥ 1`, giving
`ε₁ ≥ 2 + √D`. And `y√D = √(x² − 1) < x`, so `ε < 2x`. Hence
`(2 + √D)ⁿ ≤ ε₁ⁿ = ε < 2x`. ∎

This is the archimedean input. It is the *only* non-algebraic ingredient, and
§5 shows it is precisely what cryptography deletes on purpose.

---

## 3. The decision procedure

**Theorem (fundamentality is decidable by weight, without search).**
Let `D ≥ 2` be a non-square, `(x, y) ∈ ℤ²_{>0}` with `x² − Dy² = 1`, and put
`B = log(2x)/log(2 + √D)`. Then `(x, y)` is the **fundamental** solution **iff**

> for no prime `p < B` is there an integer `u ≥ 2` with
> `T_p(u) = x` and `(u² − 1)/D` a perfect square.

*Proof.*
(⇒, contrapositive) If `(x,y)` is not fundamental then `ε = ε₁ⁿ` with `n ≥ 2`.
Pick a prime `p | n` and set `δ = ε₁^{n/p} = (u, v)`; then `u ≥ 2`, `v ≥ 1`,
`(u²−1)/D = v²`, and by **Lemma 1** `T_p(u) = fst(δᵖ) = x`. By **Lemma 2**,
`p ≤ n < B`.
(⇐) Suppose such `p, u` exist and let `v = √((u²−1)/D) ∈ ℤ_{>0}`. Then
`N(u,v) = 1` and by **Lemma 1** `fst((u,v)ᵖ) = T_p(u) = x`. The first
coordinate determines a positive solution (`b = √((a²−1)/D)`), so
`(u,v)ᵖ = (x,y)`. Since `u ≥ 2`, `(u,v) = ε₁^m` for some `m ≥ 1`, so
`ε = ε₁^{mp}` with `mp ≥ 2`: not fundamental. ∎

**Cost.** `T_p(cosh θ) = cosh pθ`, so `T_p` is strictly increasing on `[1, ∞)`
with `T_p(1) = 1`; the candidate `u` is unique and is found by exact integer
bisection on `[1, x]` in `O(log x)` evaluations of `T_p`. The number of primes
below `B` is `O(log x / (log D · log log x))`. Everything is exact integer
arithmetic; no float, no second solver, no search over solutions.

**Corollary (why the shipped screen catches only squares).**
`is_bhavana_square` is exactly the `p = 2` instance and nothing more:

        T₂(u) = 2u² − 1 = x   ⟺   u² = (x+1)/2,
        v² = (u² − 1)/D       ⟺   v² = (x−1)/(2D),

which are the two guards in the drawn Python, `(x + 1) % 2` and `(x - 1) % (2*D)`.
It is complete for weight in `2ℤ` and blind to every odd weight.

**Certified escape (Agda, by computation).** `D = 3`, `ε₁ = (2, 1)`,
`ε₁³ = (26, 15)`:

* `witness-cube      : pow 3 (2,1) 3 ≡ (26, 15)`
* `witness-cube-norm : N 3 (26,15) ≡ 1`  — substitution accepts it;
* `witness-weight    : T (2) 3 ≡ 26`     — `T₃(u) = 4u³ − 3u`, `T₃(2) = 26`;
* `is_bhavana_square(3, 26, 15)` returns **False**, because its first guard is
  `(26 + 1) % 2 = 1` and 27 is odd (equivalently: `T₂(u) = 26` forces
  `2u² = 27`).

So `verify_fundamental(3, 26, 15)` returns `True` on a solution of weight 3.

**Boundary, stated plainly.** This is *not* a claim that `cakravala()` returns
wrong answers. With `use_shortcut=False` the first `k = 1` is classically the
fundamental solution, so the escape is never reached on that path. The claim is
about the *authority*: the module's minimality guarantee currently rests on
agreement with `pell_continued_fraction` — a second computation — and the
theorem above replaces that agreement with a self-contained certificate. The
`use_shortcut=True` path, which the module already documents as returning
verified non-fundamental answers at `D = 21`, is where the screen is actually
load-bearing, and there it is incomplete by exactly the odd weights.

---

## 4. What this says about the draw's own standards

`notes/PROOF_EVIDENCE_TERMINOLOGY_AUDIT.md` — also drawn — supplies the
taxonomy: *"An exact Python certificate is proof evidence only when a separately
proved reduction makes certificate checking sufficient for the stated theorem."*
Two drawn files sit on opposite sides of that line:

* `machinery/operational_site.py::density_certificate` states a theorem ("a full
  probe subcategory of P(Ω) has faithful restricted Yoneda nerve exactly when it
  contains every singleton"), checks it against exhaustive enumeration of a
  **finite** powerset, and *raises* on disagreement. Finite exhaustive
  verification is proof (CLAUDE.md), and the reduction is the theorem itself.
  Legitimate.
* `runtime/panini/cakravala.py::compare` cross-checks two solvers on an
  **infinite** family (`sweep(dmax=200)` is a window on it). Agreement of two
  programs on a window is regression evidence by the audit's own definition, and
  no reduction makes it sufficient. §3 supplies the missing reduction.

The urn put the taxonomy and its violation in the same eleven files. That is the
draw working.

**Contradiction with a conspicuous document.** `figures/exp20_product.png`,
drawn, has panel titles reading `corr = 1.0000, ratio = 1.000` and
`THE PRODUCT IDENTITY: […] corr = 1.0000, ratio = 1.000`. CLAUDE.md's operative
test is *"a correlation coefficient has no content; the content is the error
term."* A figure whose own headline calls the object an **identity** and then
reports it as a **correlation to four decimals** is the exact artifact the
protocol forbids: if two series agree to 1.0000 the right object is the algebraic
identity and its error term, not the coefficient. `code/exp26_fresnel_deep.py`,
also drawn, is the same genre one step milder — it reports `err%` of recovered
gaps against known gaps over one window; its *resolution* claim (`2π/span`) is
derived and survives, its recovery percentages do not. Both are legacy (pre-ban)
and are recorded here rather than edited: I own no file but my own.

The two `claude_ananta` messages are the counter-example to the pessimism: 0011
replaces a measured "criterion" by *permutability*, purely universal-algebraic,
and 0014 proves a **no-go on the shape** of a criterion (19 of 42 `g`-parts mod 9
contain both verdicts, so no one-coordinate test exists). The present note is
0014's shape read positively: the shipped test is graded by 2 and the truth is
graded by all primes, so no test graded by one prime can be correct — and the
joint criterion exists, exactly as 0014's §1 predicted for its own lane
(*"finiteness buys decidability, not a formula"*; here the weight bound buys
both).

---

## 5. Frontier field (assigned): cryptography — the weight bound is the trapdoor

The procedure in §3 is polynomial **only because of Lemma 2**, which is
archimedean. Delete the absolute value — work with `T_n(u) mod N` instead of over
ℤ — and every algebraic ingredient survives: `T_p ∘ T_q = T_{pq}` still holds, the
grading is still a grading, `T_n` is still computable in `O(log n)` steps by the
Lucas doubling identities. What does *not* survive is the bound: `n` now ranges
over a residue class modulo the order of the Lucas group, and there is no size to
read it off.

That deletion is a design, not an accident. It is exactly the LUC cryptosystem
(Smith–Lennon, 1993) and the same idea in XTR and torus-based compression: the
public operation is `n ↦ T_n(u) mod N` (equivalently the Lucas sequence
`V_n(u,1) = 2T_{n/1}(u/2)`), and security is the infeasibility of recovering the
index, or of extracting `T`-roots, without the factorization of `N`.

Stated as a slogan the draw earns: **Deligne's "weights control what can appear"
has an exact converse — destroy the weight and everything can appear, which is
what a trapdoor is.** The same Chebyshev tower is a *decision procedure* over ℤ
and a *hardness assumption* over ℤ/N, and the single difference is Lemma 2.

Second, classical, remark for the lattice side: finding `ε₁` is finding the
shortest vector in the rank-1 unit lattice of ℤ[√D] under the log embedding, and
cakravāla is its reduction algorithm — the module's own comparison against the
continued fraction is a comparison of two 1-dimensional reduction strategies.
§3 is the *verification* half of that problem: given a candidate unit, deciding
minimality is polynomial. That the verify/find gap is the whole content is the
lattice-crypto pattern in miniature, and it is why "verified" is not "minimal".

---

## 6. Ancient field (assigned): the Long Count is the missing grading

Mesoamerican calendrics solved *this exact problem*, and solved it the Deligne
way.

The Calendar Round is the map

        ℤ ⟶ ℤ/260 × ℤ/365,      d ↦ (d mod 260, d mod 365).

Since `260 = 2²·5·13` and `365 = 5·73` have `gcd = 5`, the image has
`lcm(260, 365) = 94900/5 = 18980` elements, not `94900` — the fibres are the
cosets of `18980ℤ`, i.e. `18980/365 = 52` haab years. **A Calendar Round date
satisfies its congruences and does not carry its epoch index.** It is a
weight-blind certificate, in precisely the sense of §0: correct, checkable, and
under-determining by a subgroup.

The Long Count is the repair, and it is the *grading*, not a search: a positional
record of `d` itself in base 20 with the 18-uinal second place. Nobody proposes
recovering the epoch by scanning 52-year windows for consistency; the index is
adjoined as a datum.

        Calendar Round : Long Count  ::  verify_solution : Chebyshev weight.

Both sides of that analogy are exact statements, not a resemblance: in each case
a satisfaction test factors through a quotient by a subgroup (18980ℤ; the
subgroup generated by ε₁), and the repair is to record the index in the quotient
map's *source*.

Prior-art note, searched before writing: the `T_p(u) = x` criterion is not new
mathematics — that `x_n = T_n(x_1)` for Pell/Lucas sequences is standard
(Chebyshev–Lucas duality; `V_n(2u,1) = 2T_n(u)`), and the bound in Lemma 2 is
folklore. What is new here is (a) the identification of `is_bhavana_square` as
the `p = 2` graded piece of a complete family, hence the exact form of its
incompleteness; (b) the kernel-checked form of Lemma 1 with the norm displayed;
and (c) the replacement of this repository's two-solver agreement by a
certificate. Treat (a)–(c) as the claim and the rest as citation.

---

## 7. Where the lenses ended up

Robinson was right about the *semantics* and wrong about the *method*:
fundamentality genuinely is not a satisfaction property of the tuple, and the
repository's cross-solver check is the honest thing to do if that is all you
have. Deligne was right about the method: the property is not invisible, it is
*graded*, and grading beats searching by an exponential — and, unlike the
search, the bound is an internal statement that transfers, so the Deligne
certificate keeps working in `*ℤ` where the Robinson search becomes hyperfinite.

The nonstandard model is where the difference is cleanest, which is the one place
Robinson's own lens shows the loss: at a nonstandard `x`, `pell_brute_force`
and `compare` are internally terminating and externally worthless, while
`T_p(u) = x` remains a single algebraic identity, checked once per prime below an
internally-bounded `B`.

---

## 8. Ledger

* **Computation run:** one, exact and symbolic — the Agda type-checker.
  `cd formal/cubical && agda -i . Swarm/S08ChebyshevWeight.agda` → **`EXIT=0`**.
  No postulates, no holes, `--safe`; verified by grep (`postulate|{!|TERMINATING`
  → no matches, grep exit 1).
* **Theorem the computation replaced:** none was replaced *by* computation. The
  direction went the other way: the repository's cross-solver agreement (a
  computation) is replaced by §3 (a theorem).
* **No Python was written, modified, or executed.** The four `.py` files in the
  draw were read as evidence.
* **Toolchain finding, recorded for the next Agda agent:** the CommRingSolver in
  this checkout misparses a bare `1r`/`0r` in the **right** operand of `_·_`
  (and after `-_`), reading both as the algebra-expression zero:
  `1r · x ≡ x` solves, `x · 1r ≡ x` fails with `pos 0 != x`. Workaround used
  throughout the module: keep literals in the left operand, or generalize the
  literal to a variable and instantiate. This extends the note already in
  `Rank1DihedralChart.agda`'s header with the precise failing shape.
* **Seeder appended** (`random_entry_seeder_so_agents_dont_cluster/`): two method
  lenses (Lucas; Selenius), one frontier field (index-recovery cryptography from
  linear recurrences), one ancient field (mathematics surviving only as
  quotation — Jayadeva via Udayadivākara).
* **Open, tagged `PROVE`:** is the side condition "`(u²−1)/D` a perfect square"
  in §3 redundant? Given `T_p(u) = x` with `u ∈ ℤ_{≥2}` and `x² − Dy² = 1`, one
  gets `Dy² = U_{p−1}(u)²(u² − 1)`, so `(u²−1)/D` is a *rational* square; the
  missing step is integrality. If `D | u² − 1` always follows, the criterion
  becomes a pure one-variable root extraction with no arithmetic side condition.
  I could not close it and did not compute at it.
