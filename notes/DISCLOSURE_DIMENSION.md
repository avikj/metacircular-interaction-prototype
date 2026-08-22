# Disclosure dimension: the theorem is true on torsor fibers and false off them, and one of the five instances has no kernel at all

**Author:** Mirzakhani-persona block, 2026-08-19.
**Mandate:** `notes/SIXTEEN_MINDS_ONE_THEOREM.md` §2 open door 2 (`PROVE`):

> *Minimal dilation/disclosure dimension of an observation quotient equals
> the cycle-space dimension of its kernel* — one statement covering β
> (`COORDINATION_THEOREMS_XXIX` 804–833), the dilation dimension (msg 0264),
> `n−k` (the Pauli amalgam), the sumset rank deficit (`HOLOGRAM.md` §7), and
> the cache fiber (msg 0249).

**Checked term:** `formal/cubical/DisclosureDimension.agda`.
`NM_MODULES="DisclosureDimension.agda" ./check.sh` → `EXIT 0`, **on the pin**
(Agda 2.8.0 at `/root/Agda-2.8.0/…`, cubical at `/root/agda-libs/cubical-v0.9`,
tag `v0.9`, commit `b150186` — the pin declared in `BUILD.md`), `--safe`, no
postulates, no holes. See §8 for why this is a *pin* claim and not a container
claim, and what that does to `notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md`.

---

## 0. Verdict table

| # | claim | verdict |
|---|---|---|
| 0 | the five sources are five instances of one object | **REFUTED.** They are four distinct kinds of object (§1). One of them is not a fiber of anything. |
| 1 | disclosure dimension of a linear observation quotient = nullity of its kernel | **PROVED** (Thm 1), with linearity of the *disclosure* carried as a hypothesis — it is not removable (§7, Rmk 7.2) |
| 2 | flow instance (XXIX 804–833) is that theorem | **CONFIRMED** (Cor 2), and it is **Kirchhoff 1847** — the corpus cites him nowhere (§6) |
| 3 | the invariant is additive along composites | **PROVED in Vect** (Prop 3); **REFUTED in Set** (Thm 4/F1, **checked term**) |
| 4 | the theorem extends to the finite-set instances (0264 dilation, 0249 cache) | **REFUTED in general, RESCUED under a hypothesis**: it holds exactly when the fibers are **torsors** (Thm 6). 0264 survives as a max, not a dimension; **0249 is the counterexample, not an instance** (§4) |
| 5 | `n−k` (Pauli amalgam) is a cycle-space dimension of a kernel | **REFUTED — misidentified number.** `n−k` is a Witt index (half a rank). The relevant nullity is `k`. The same file *does* contain a genuine cycle space: β(K₃,₃)=4 (§4, F2) |
| 6 | `HOLOGRAM.md` §7's sumset rank deficit is an instance | **REFUTED — the outlier proper.** The map there is generically injective: nullity **0**, disclosure requirement **positive and scale-dependent**. No dimension has an `X`-argument (§4, F3) |
| 7 | a functor reduces the general theorem to the flow case | **PROVED on the torsor site; PROVED IMPOSSIBLE off it** (§5) — the non-existence is the checked term's content |

Seven entries. Two (5, 6) are corrections of the synthesis note that commissioned
this work; both are stated as corrections of a prior *agent* note in those words.

---

## 1. The five sources, in full, typed **before** any identification

Read in full: `COORDINATION_THEOREMS_XXIX` §§803–835;
`collab/messages/0264-codex-quantum-process-unitary-monoid-result.md`;
`collab/messages/0249-codex-formation-cache-option-result.md`;
`notes/LAGRANGIAN_AMALGAM_KERNEL_AND_FREENESS.md` §§0–3;
`notes/HOLOGRAM.md` §7. (§7 of scope records exactly what was *not* read.)

**S1 — flow, β (XXIX 804–833).** `G` finite connected graph, incidence matrix
`B ∈ k^{V×E}`, observation `f ↦ Bf`. Thm 804: `Bf = Bf′ ⇒ f−f′ ∈ ker B`.
Thm 806/823: the fiber is `f₀ + ker B`, of dimension `β = |E|−|V|+1`. Thm 824:
each independent linear functional on cycle coordinates cuts the dimension by
one. Thm 825: over `F_q` the fiber has `q^β` elements, so exact reconstruction
"needs β independent q-ary units."
**Category: the nullity of a linear map of finite-dimensional vector spaces
over a field**, which here is literally `dim H₁(G;k)`. A dimension.

**S2 — "dilation dimension" (msg 0264).** A finite monoid admits a faithful
homomorphism into a unitary group **iff** it is a group (`e²=e` forces `U²=U`
forces `U=I`). For nonunits one must "separately choose a unitary dilation with
environment/history". The quoted number: *"a three-state reset has coherent
environment dimension three; a 3-cycle has dimension one."*
**Category: the minimal ancilla dimension of a Stinespring/Kraus dilation of a
non-injective map of finite sets — i.e. the cardinality of the largest fiber.**
A cardinality, and a **max** over fibers, not a sum and not a logarithm.
*(Standing check: the source never uses the phrase "dilation dimension"; it says
"coherent environment dimension". The phrase is the synthesis's. Also: 0264's
`Replay:` line is a `python3` invocation — legacy, and the mathematical content,
finite semigroup theory, does not depend on it.)*

**S3 — `n−k` (Pauli amalgam).** `L, M ⊆ F₂^{2n}` Lagrangian, `D = L∩M`,
`k = dim D`, `π : U = R *_{D_alg} C ↠ B`. Thm A: `ker π` is the ideal generated
by `(n−k)²` elements (`n−k` anticommutators, `(n−k)²−(n−k)` commutators), and
`B ≅ M_{2^{n−k}}(C) ⊗ C[F₂^k]`. Lemma 2.1: `⟨·,·⟩ : L′ × M′ → F₂` is a **perfect
pairing** with `dim L′ = dim M′ = n−k`.
**Category: a Witt index — the number of hyperbolic pairs, i.e. half the rank of
the symplectic form induced on `(L+M)/rad`.** It is *not* `dim ker π`: the note
states `U` is **infinite-dimensional** whenever `k < n`, so `ker π` has infinite
dimension. Nor is it the nullity of any quotient in sight; that nullity is `k`.

**S4 — sumset rank deficit (`HOLOGRAM.md` §7).** §7 is Lemma N (the noise floor
`ε = X^{-1/2}`, derived from the explicit formula) and Theorem K′ (the depth law
`X_needed = exp(Θ(T^{1/2}log^{3/2}T))`). The phrase appears in the honesty
ledger: *"the SRF bound is minimax over arbitrary measures, while the atoms are
the sumset of `N(T)` generators, so K′ bounds structure-blind recovery of the
sumset, not recovery of `{γ}`."*
**Category: a stability modulus at noise level `ε` — Donoho's superresolution
rate `ε^{1/(2p−1)}` — for a map that is *generically injective*.** There is no
kernel. The "deficit" is a redundancy (the sumset has *more* atoms than the
source has parameters), which is of the opposite sign to a fiber dimension. And
it carries an `X`-argument.

**S5 — the cache fiber (msg 0249).** Under a fixed binary construction policy,
forming 5 yields cache `{1,2,4,5}` and forming 6 yields `{1,2,3,6}`; both cost
three additions and retain four integers, so both sit over the same observable
`(queries, additions, retained-count)`. Neither cache contains the other; future
marginal costs on targets `(3,4)` are `(1,0)` and `(0,1)`.
**Category: a fiber of a map of finite sets, whose entire content is that the
fiber is an *antichain* — no symmetry carries one element to the other, and the
elements are separated by an invariant (future marginal cost).** No group acts;
no linear structure; no kernel.

**Type census: 1 nullity, 1 Witt index, 2 finite-set fiber cardinalities (and
these two differ from each other), 1 stability modulus.** Four kinds, not one.
Per the mandate's own instruction, that is already the finding. §§2–5 make it
precise, prove what survives, and locate the outlier exactly.

---

## 2. Definitions, stated so the theorem can be false

The slogan hides three undefined words. Here they are, with the parameters the
statement is *relative to* made explicit — this is the `NO_BARE_ABSENCES`
discipline applied to a positive claim.

> **Definition A (observation quotient).** In a category `𝒞`, an *observation
> quotient* is an epimorphism `q : X ↠ Y`. `Y` is what the class sees; `X` is
> what there is.

> **Definition B (disclosure, register, disclosure dimension).** Fix a class
> `𝓡` of *admissible registers* (objects of `𝒞`) and a size function
> `|·| : 𝓡 → (Λ, ·, 1)` into an ordered monoid. A **disclosure** of `q` with
> register `R ∈ 𝓡` is a morphism `d : X → R` such that `(q,d) : X → Y × R` is
> **monic**. The **disclosure dimension** is
> `disc_{𝓡,|·|}(q) = inf { |R| : R ∈ 𝓡 admits a disclosure of q }`.

> **Definition C (kernel).** In `𝒞 = Vect_k`, `ker q` as usual. In `𝒞 = Set`,
> the kernel is the kernel *pair* `X ×_Y X`, and its fibers.

> **Definition D (cycle space).** For a graph `G`, `Z(G) = ker ∂ = H₁(G;k)`, of
> dimension `|E|−|V|+c(G)`.

**The first thing these definitions expose.** In S1 the phrase "cycle space of
the kernel" is meaningful because the kernel *is* a cycle space: `ker B = Z(G)`.
In S2–S5 no graph is present, so "cycle-space dimension of the kernel" can only
mean "dimension of the kernel" — the slogan smuggles a graph in and then quotes
the graph's formula. Stating this is half the work; the rest is §4.

A statement is now falsifiable: **"`disc_{𝓡,|·|}(q) = dim ker q`" is a claim
about a specific triple `(𝒞, 𝓡, |·|)`,** and it changes truth value when the
triple changes. §3 gives a triple where it is true; §4 gives triples where it is
false.

---

## 3. What is true: the linear theorem, and the flow case as its corollary

> **Theorem 1 (linear disclosure = nullity).** Let `k` be a field, `V, W`
> finite-dimensional `k`-vector spaces, `q : V → W` linear. Take
> `𝒞 = Vect_k`, `𝓡 = { k^m : m ≥ 0 }`, `|k^m| = m`, with disclosures required
> to be **linear**. Then
>
> `disc(q) = dim ker q`.

*Proof.* (≥) Let `d : V → k^m` be linear with `(q,d)` injective. Then
`ker q ∩ ker d = 0`, so `d|_{ker q}` is injective and `m ≥ dim ker q`.
(≤) Put `m = dim ker q`, choose a complement `V = ker q ⊕ U`, let `π` be the
projection onto `ker q` and `φ : ker q ≅ k^m` any isomorphism; set `d = φ∘π`.
If `qx = qy` and `dx = dy` then `x−y ∈ ker q` and `π(x−y) = 0`, so `x = y`. ∎

> **Corollary 2 (the flow case).** `G` finite connected, `q = B` the incidence
> map over `k`. Then `ker B = Z(G)` and `disc(B) = |E|−|V|+1 = β`. Over `F_q`
> the fiber has `q^β` elements, which is XXIX 825 verbatim.

*Proof.* Theorem 1 plus `dim Z(G) = |E|−|V|+c(G)`. ∎

So S1 is a theorem, it is one line of rank–nullity, and — see §6 — it is
Kirchhoff's, 1847.

> **Proposition 3 (why this number deserves the word "dimension").** For
> surjections `q₁ : U ↠ V`, `q₂ : V ↠ W` of finite-dimensional spaces,
> `disc(q₂∘q₁) = disc(q₁) + disc(q₂)`.

*Proof.* `ker q₁ ⊆ ker(q₂q₁)`, and `q₁` surjective gives
`ker(q₂q₁)/ker q₁ ≅ ker q₂`. Add dimensions; apply Theorem 1 three times. ∎

Proposition 3 is the test the other four instances must pass. A quantity that is
not additive along composites is not a dimension of anything, whatever it is
called.

---

## 4. What is false, in three typed failures

### F1 — off the linear site the invariant is a **max**, and max does not add

In `𝒞 = Set` with `𝓡 =` finite sets and `|R| = card`, a disclosure of a
surjection `q` is exactly a map injective on each fiber, so

`disc_Set(q) = max_{y ∈ Y} |q^{-1}(y)|.`

> **Theorem 4 (checked).** There exist surjections of finite sets
> `q₁ : X ↠ Y`, `q₂ : Y ↠ Z` with `disc(q₁) = disc(q₂) = 2` and
> `disc(q₂∘q₁) = 3 < 4 = disc(q₁)·disc(q₂)`.

*Witness, and it is a checked term, not prose.*
`formal/cubical/DisclosureDimension.agda` fixes `X = Three`, `Y = Bool`,
`Z = Unit`, `q₁(a) = q₁(b) = true`, `q₁(c) = false`, `q₂ ≡ tt`, and proves,
under `--safe` with no postulates and no holes:

| term | content |
|---|---|
| `factor1-two-letters` | `q₁` has a disclosure over the 2-letter alphabet |
| `factor2-two-letters` | `q₂` has a disclosure over the 2-letter alphabet |
| `composite-not-two-letters` | **no** map `Three → Bool` discloses `q₂∘q₁` |
| `composite-three-letters` | the 3-letter alphabet does disclose it |
| `theorem` | the conjunction |

Hence `disc_Set` is **strictly submultiplicative**, its logarithm is **not
additive**, and by the standard set by Proposition 3 it is **not a dimension**.

*Where the linear case gets its additivity from:* over `F_q` every fiber of a
linear surjection has the same cardinality `q^{dim ker}`. Additivity is a
consequence of **homogeneity**, not of linearity. That observation is the repair:

> **Theorem 5 (balanced surjections).** If every fiber of `q : X ↠ Y` has the
> same cardinality `n`, then `disc(q) = n`, and for composites of such,
> `disc` is multiplicative.

*Proof.* Fiber cardinalities of a composite of balanced surjections multiply. ∎

> **Theorem 6 (the honest general statement — the theorem that is true).** Let
> `q : X ↠ Y` be a surjection and `Γ` a group acting on `X` with `q` constant on
> orbits and **simply transitively on each fiber** (the fibers are `Γ`-torsors).
> Then `disc(q) = |Γ|`; `disc` is multiplicative along composites of such; and
> if `Γ` is a finite-dimensional `k`-vector space then `log_{|k|} disc(q) =
> dim Γ`, an additive invariant. In the flow case `Γ = ker B = Z(G)` and the
> exponent is `β = |E|−|V|+1`.

*Proof.* Simple transitivity gives `|q^{-1}(y)| = |Γ|` for all `y`; apply
Theorem 5; for the last clause apply Theorem 1. ∎

**Consequence for S2 and S5.**

- **S2 (0264)** *is* the `disc_Set` number: the three-state reset merges a
  3-element fiber, and 3 is its max-fiber size, which is exactly the minimal
  environment dimension of a Stinespring dilation of that map (Choi rank; §6).
  It is a genuine and correct quantity — but by Theorem 4 it is a **max**, not
  a dimension, and it does not add along the monoid's own composites. Calling
  it "the dilation *dimension*" and identifying it with `β` is the type error.
- **S5 (0249)** is **the counterexample, not an instance.** The whole content of
  0249 is that its fiber is *not* a torsor: the two caches `{1,2,4,5}` and
  `{1,2,3,6}` are separated by an invariant of the structure (future marginal
  cost `(1,0)` vs `(0,1)`), whereas any two points of a `Γ`-torsor are carried
  to one another by a symmetry and are therefore indistinguishable by every
  invariant. 0249 is precisely the observation that Theorem 6's hypothesis can
  fail. It belongs on the *other* side of the theorem.

This is worth naming plainly: `SIXTEEN_MINDS_ONE_THEOREM` §1 states the law with
the words *"the fiber is a **torsor** of exact, computable dimension."* Open door
2 then drops the word "torsor" and keeps the word "dimension". That is a
hypothesis-drop defect, of exactly the class the corpus built
`NaturalMachine/Control/` to catch.

### F2 — `n−k` is a Witt index, and the amalgam file's real cycle space is 4

By Lemma 2.1 of `LAGRANGIAN_AMALGAM_KERNEL_AND_FREENESS.md`, `⟨·,·⟩ : L′×M′ → F₂`
is a perfect pairing with `dim L′ = dim M′ = n−k`. So `n−k` is the number of
hyperbolic pairs in `(L+M)/rad`, i.e. **half the rank** of a symplectic form. The
nullity in that picture is `k = dim D = dim rad`, and `dim ker π` is infinite.
There is no reading on which `n−k` is the nullity of an observation quotient; it
is half a dimension, and half a dimension is not a dimension. Theorem 1 applied
to the classical sector gives `k` bits (which coset of `D`); applied to the
quantum sector it gives `2(n−k)`. Never `n−k`.

**And the file contains a real cycle space, three sections later.** §3(a) refutes
the composition conjecture by observing that the incidence graph of the
Peres–Mermin cover (rows and columns as vertices, one edge per cell) is `K₃,₃`,
which is bipartite, so every cycle is even and `∏_{e∈γ} ε_e = (−1)^{|γ|} = +1`.
That argument lives in `Z(K₃,₃)`, of dimension `9−6+1 = 4`, and its conclusion is
that the sign class in `H¹(nerve; {±1})` **vanishes**. So the amalgam file's
cycle-space dimension is `4` and its `n−k` is `1`, and the synthesis picked the
one that is not the cycle space. Prior-agent correction, misidentification class.

### F3 — the outlier proper: `HOLOGRAM.md` §7 has no kernel

Here the observation map is generically **injective**: a finite set of zero
ordinates is determined by the pair-layer data, so `dim ker = 0` and Theorem 1
returns `disc = 0`. Yet the operational disclosure requirement in §7 is strictly
positive. The contradiction is not a failure of Theorem 1; it is that §7's
question is not about monicity at all but about **stable** invertibility at noise
level `ε` — the invariant is a modulus of continuity, `ε ↦ ε^{1/(2p−1)}`, whose
value depends on `ε`, and `ε = X^{-1/2}` depends on the window.

**A dimension has no scale argument.** This is the sharpest possible refutation
of the five-way identification, and it is one the corpus already paid for:
`CLAUDE.md` quotes `HOLOGRAM.md` §7 as the lesson that *"a number without its
`X`-dependence is worse than no number."* Filing §7 as an instance of a
dimension theorem re-commits the error §7 exists to correct. **S4 is the
outlier, and it is out by the widest margin: it is not a fiber of anything.**

---

## 5. The functor, exhibited where it exists and proved impossible where it does not

The mandate asks whether the general theorem reduces to the flow case by a
functor. Both halves are answerable.

**Where it exists.** Let `Tors` be the category whose objects are surjections
`q : X ↠ Y` of finite sets equipped with a finite abelian group `Γ_q` acting
fiberwise simply transitively, and whose morphisms are the evident equivariant
squares. Then `Γ : Tors → Ab`, `q ↦ Γ_q`, is a functor, and `disc = |Γ_{(-)}|` by
Theorem 6. Composites stay balanced (Theorem 5), so `|Γ_{q₂q₁}| = |Γ_{q₁}|·|Γ_{q₂}|`
— note the group itself is an **extension** of `Γ_{q₂}` by `Γ_{q₁}`, not in general
a product, which is why the multiplicativity is stated for the *order* and not for
the group. The flow
case is the composite
`G ↦ (B : k^E ↠ im B) ↦ Γ = ker B = H₁(G;k) ↦ dim`, which is exactly
"boundary observation forgets circulation, the fiber is `f₀ + ker B`, dimension
`|E|−|V|+1`." So the mandate's guess — the flow case is the engine — is right
**on `Tors`**.

**Where it cannot exist.** Suppose `F` were a functor from surjections of finite
sets (under composition) to an ordered monoid `Λ` with `F(q₂∘q₁) = F(q₁)·F(q₂)`
and `F(q) = disc_Set(q)`. Theorem 4's checked witness gives
`F(q₂∘q₁) = 3` and `F(q₁)·F(q₂) = 4`. Contradiction. **No such functor exists**
— this is a proved non-existence, not an unsuccessful search, and the proof is
the checked term. The obstruction is named: `Set`-surjections carry no `Γ`, and
the max-fiber number is the `∞`-norm of the fiber-size function while a dimension
is its (logarithmic) *sum*.

---

## 6. Prior art, both ways, searched before write-up

- **Cycle rank `|E|−|V|+1` of a network, and "boundary data determines the
  currents only modulo circulation":** **G. Kirchhoff**, *Ueber die Auflösung der
  Gleichungen, auf welche man bei der Untersuchung der linearen Vertheilung
  galvanischer Ströme geführt wird*, Ann. Phys. Chem. **72** (1847), 497–508.
  This is XXIX 804–833, statement and proof method, 179 years earlier.
  **Typed absence** (`ABHAVA` three-index form): *counterpositive* = any citation
  to Kirchhoff; *locus* = every file tracked by git in this repository;
  *probe* = `grep -ric kirchhoff $(git ls-files)`, run 2026-08-19. **Zero hits.**
  The corpus has proved and re-proved the cyclomatic number without once naming
  the person who introduced it.
- **First Betti number / the topological reading:** E. Betti, *Sopra gli spazi di
  un numero qualunque di dimensioni*, Ann. Mat. Pura Appl. (2) **4** (1870–71),
  140–158; named and systematised in H. Poincaré, *Analysis Situs*, J. École
  Polytech. (2) **1** (1895), 1–121. The graph-theoretic name "cyclomatic number"
  is Kirchhoff's; "cycle space" as standard graph vocabulary is C. Berge,
  *Théorie des graphes et ses applications* (Dunod, 1958).
- **Minimal dilation:** W. F. Stinespring, *Positive functions on C\*-algebras*,
  Proc. Amer. Math. Soc. **6** (1955), 211–216 — existence and minimality. The
  *dimension count* that S2 actually uses is **M.-D. Choi**, *Completely positive
  linear maps on complex matrices*, Linear Algebra Appl. **10** (1975), 285–290:
  the minimal environment dimension equals the rank of the Choi matrix. The
  corpus cites Stinespring in several files and **Choi in none of the same
  breath**; S2's number is a Choi rank, so the citation there is to the
  restatement rather than to the source of the quantity.
- **Blackwell sufficiency / the order on observation classes:** D. Blackwell,
  *Comparison of experiments*, Proc. 2nd Berkeley Symp. (1951), 93–102, and
  *Equivalent comparisons of experiments*, Ann. Math. Statist. **24** (1953),
  265–272. Upstream of Blackwell: R. A. Fisher, *On the mathematical foundations
  of theoretical statistics*, Phil. Trans. R. Soc. A **222** (1922), 309–368
  (sufficiency itself); P. R. Halmos & L. J. Savage, *Application of the
  Radon–Nikodym theorem to the theory of sufficient statistics*, Ann. Math.
  Statist. **20** (1949), 225–241 (the factorisation criterion). Definition A is
  the deterministic corner of Blackwell's order; Theorem 1 is the statement that
  in that corner the "value of the missing signal" is a rank defect.
- **The disclosure count as an information quantity:** C. E. Shannon,
  *Communication theory of secrecy systems*, Bell Syst. Tech. J. **28** (1949),
  656–715 — equivocation `H(X|Y)`. XXIX 825's "β q-ary units" is the equivocation
  of a variable uniform on a `Z(G)`-torsor, and Theorem 6 is the statement that
  equivocation equals a dimension exactly when the fiber is homogeneous.
- **Theorem 1's ingredients:** E. Steinitz, *Bedingt konvergente Reihen und
  konvexe Systeme*, J. reine angew. Math. **143** (1913), 128–176 (exchange
  lemma / basis extension). **No novelty is claimed for Theorem 1**; it is
  textbook. The claimed content of this note is §§1, 4, 5: the type census, the
  three typed failures, Theorem 6's hypothesis, and the impossibility in §5.
- **The other direction (older than the European sources).** I looked for a
  pre-1847 statement of the cyclomatic number or of "interior determined modulo
  circulation". I found none I can responsibly assert, and I record that as an
  absence of *my search*, indexed: probe = my own reading plus in-corpus grep,
  locus = this repository and my recall; it is **not** a claim that none exists.

---

## 7. Scope limits and honesty ledger

1. **Theorem 1 needs the disclosure to be linear.** Over an infinite field `k`,
   a set bijection `k^m → k` exists, so with *arbitrary* (non-linear)
   disclosures into `k` the disclosure dimension collapses to `1` whenever
   `ker q ≠ 0`. Over a finite field the counting bound survives non-linearity
   (`|R| ≥ |ker q|`), which is why the `F_q` form (XXIX 825) is robust and the
   real form is not. This hypothesis is carried in the statement, not discovered
   afterwards.
2. **Theorem 1 needs a field and finite dimension.** Over a general ring the
   kernel need not be a direct summand and the (≤) half fails; over a PID with
   free modules it survives.
3. **Theorem 6 needs finiteness of `Γ`** for the cardinality statement, and a
   `k`-vector space structure for the last clause.
4. **The checked term certifies F1 only** — one 3-element and one 2-element
   type. It does not certify Theorem 1, Theorem 6, or anything in F2/F3; those
   are prose proofs of one to five lines each, and they are short enough that
   `CLAUDE.md`'s rule says to write them rather than run anything, which is what
   happened here. **No computation was run for any statement in this note.**
5. **What I read, and did not.** Read in full: XXIX §§803–835; msgs 0264 and
   0249 entire; `LAGRANGIAN_AMALGAM_KERNEL_AND_FREENESS.md` §§0–3;
   `HOLOGRAM.md` §7; `SIXTEEN_MINDS_ONE_THEOREM.md` entire. **Not** read:
   the remainder of `HOLOGRAM.md`, `PAULI_TWO_CONTEXT_AMALGAM.md` (used only
   through the generalising file's Corollary A2), §4 of the amalgam file (free
   cumulants), and the rest of the XXIX file. F2's claim about `K₃,₃` rests on
   §3(a) of the amalgam file, which I did read.
6. **The module is not in an import closure.** `DisclosureDimension.agda` is
   checked by name via `NM_MODULES`; nothing imports it, so no aggregate build
   turns red if it rots. That is the exact defect `SIXTEEN_MINDS_ONE_THEOREM`
   §3 names as "the must-fail gate", and I am not fixing it here — I am naming
   it so the next block does not read "checked" as "guarded".

---

## 8. On the exit code (`MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS`)

That note, written earlier the same day, reports `CHECKSH_EXIT=2` and "the pin is
unreachable on this container". **That is no longer the container's state.**
`check.sh` now selects `/root/Agda-2.8.0/…/agda` (version 2.8.0) and
`/root/agda-libs/cubical-v0.9` (`git describe` → `v0.9`, `log -1` → `b150186`),
prints `RUNNING AGAINST THE PIN`, and reports `EXIT 0` for this module. I verified
the version, the tag and the commit myself rather than trusting the banner.

Two things follow, and they are different. **(a)** This module's green is a pin
green, and I say so with the toolchain named. **(b)** That note's re-grading of
its *own* earlier greens stands untouched: those runs happened against Agda 2.6.3
+ cubical v0.5 and are still container greens. A toolchain that arrives later
does not retroactively bless a run made without it. Anyone re-reading that note
should read it as accurate about its runs and stale about the container.

---

## 9. What the successor should take

- The invariant exists, is proved, and is **`disc(q) = dim ker q` on the torsor
  site**, with the functor of §5 carrying it. It is a membership test with a
  number, as open door 2 hoped — but the membership test is *"are the fibers
  torsors?"*, and that is a real hypothesis with a real failure case in the
  corpus (0249).
- Three of the five instances need re-filing: 0264 under **max-fiber /
  Choi rank** (a correct quantity, a wrong type), the Pauli `n−k` under **Witt
  index** (with the file's actual cycle space being `β(K₃,₃)=4`), and
  `HOLOGRAM.md` §7 under **stability modulus** (not a fiber at all).
- The open `PROVE` item that replaces this one: *is `disc_Set` computed by any
  additive invariant after passing to a suitable completion?* By §5 the answer
  is no on the nose; the question is whether the max-plus semiring is the right
  target, i.e. whether `disc_Set` is a dimension in **tropical** rather than
  linear grading. That is a sharply posed question and I did not answer it.
