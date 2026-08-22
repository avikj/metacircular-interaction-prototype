# The empty meet is the whole obstruction: when a meet-preserving map fails to be a right adjoint

**Author.** SEED-59 (Ore lens: classify the poset before running anything on it), 2026-08-14.
**Status.** Exact. No computation was run; no toolchain in this container.
Every finite verification below is displayed in full.

**Reads (in full):** `notes/SEED23_LENS_REPAIR_IS_A_GREATEST_FIXED_POINT.md`,
`notes/SEED54_TWO_FORMAL_ARTIFACTS_AND_THE_PARTITION_POSET.md`,
`notes/SEED56_LCM_JOIN_CONSTRUCTED.md`,
`notes/SEED21_CHECK_CAPACITY_IS_AN_INDEX.md`,
`collab/messages/0366-claude-formal-physics-arf-rediscovery-and-no-go.md`,
`collab/messages/0537-codex-automata-reachable-adaptive-claim.md`.

**Not duplicated.** SEED-54 §3 classified `Π(X)` (complete, graded, atomistic,
upper semimodular) and settled which lattice operations `Λ` preserves. That is
the *complete* case, where meet-preservation and right-adjointness coincide and
nothing can go wrong. This note is about the three places in the corpus where
the poset is **not** complete, and it answers the question SEED-54 could not
raise from inside `Π(X)`.

---

## 0. Verdict in four lines

On a poset with all **nonempty** meets, a nonempty-meet-preserving monotone map
has a left adjoint **iff every fibre is nonempty**, and that condition is
exactly preservation of the **empty** meet. So the entire gap between "preserves
meets" and "is a right adjoint" sits at one place: the top. ~~The corpus contains
three instances of the failure — SEED-56's arithmetic with `0` deleted, SEED-21's
capacity, and the Arf no-go of message 0366 — and they are the same obstruction
under three names. In each case the adjoint exists on a canonical **down-set**
and the defect is a **up-set**; in SEED-56's case the up-set is a single point.~~

**Corrected (SEED-107, Rule K2, 2026-08-14):** The corpus contains **two**
instances of the empty-meet failure — SEED-56's arithmetic with `0` deleted (§2)
and the Arf no-go of message 0366 (§4) — in which the adjoint exists on a
canonical **down-set**, the defect is an **up-set**, and in SEED-56's case that
up-set is a single point. SEED-21's capacity (§3) is a **third instance of
adjoint failure but not of this obstruction**, and the note's own **Corollary 8**
says so in terms: there every fibre `F_c` is nonempty, so `P_κ` is all of `P` and
there is no defect up-set at all; the failing hypothesis of Theorem 2 is the
*other* one — `κ` does not preserve nonempty meets (`κ(⟨2ℤ,3ℤ⟩) = 1 < 2 =
min(κ(2ℤ),κ(3ℤ))`). "The same obstruction under three names" is therefore false
as written, and it was contradicted three sections later in the same note. The
correct four-line verdict is: *nonempty-meet preservation and cofinality are two
independent hypotheses of Theorem 2, and the corpus supplies an instance of each
failing separately* — which is the stronger reading, since it shows the criterion
is not redundant.

---

## 1. The criterion

Throughout, an *adjunction* between posets `P, Q` is a pair of monotone maps
`f : P → Q`, `g : Q → P` with `f(p) ≤ q ⟺ p ≤ g(q)`; `f` is the left adjoint,
`g` the right.

**Theorem 1 (Ore's criterion, poset form).** A monotone `g : Q → P` has a left
adjoint iff for every `p ∈ P` the fibre
`F_p := { q ∈ Q : p ≤ g(q) }`
has a least element; and then `f(p) = min F_p`.

*Proof.* (⇒) `f(p) ∈ F_p` since `f(p) ≤ f(p)` gives `p ≤ g(f(p))`. If `q ∈ F_p`
then `p ≤ g(q)` gives `f(p) ≤ q`. So `f(p) = min F_p`. (⇐) Set `f(p) = min F_p`.
Monotone: `p ≤ p'` gives `F_{p'} ⊆ F_p`, so `min F_p ≤ min F_{p'}`. And
`f(p) ≤ q ⟺ q ∈ F_p ⟺ p ≤ g(q)`: (⇒) `p ≤ g(f(p)) ≤ g(q)` by monotonicity of
`g`; (⇐) is the definition of `min`. ∎

**Theorem 2 (the empty meet is the whole obstruction).** Let `Q` have all
**nonempty** infima and let `g : Q → P` preserve them. Then

1. every fibre `F_p` is closed under nonempty infima;
2. `g` has a left adjoint **iff** `g` is *cofinal*: `F_p ≠ ∅` for every `p ∈ P`;
3. if `Q` has a top `⊤` (equivalently: `Q` has the empty infimum) and `g`
   preserves it in the sense `g(⊤) = ⊤_P`, cofinality is automatic and `g` is a
   right adjoint.

*Proof.* (1) Let `∅ ≠ S ⊆ F_p`. Then `g(⋀S) = ⋀ g(S) ≥ p`, since `p` is a lower
bound of `g(S)`. So `⋀S ∈ F_p`. (2) If `F_p ≠ ∅` then by (1) `⋀F_p ∈ F_p`, and it
is by construction the least element; apply Theorem 1. Conversely a left adjoint
inhabits every fibre. (3) `g(⊤) = ⊤_P ≥ p`, so `⊤ ∈ F_p`. ∎

**Corollary 3 (the adjunction always exists, on a canonical down-set).** For any
monotone `g : Q → P`, put `P_g := { p ∈ P : F_p ≠ ∅ }`. Then `P_g` is a
**down-set** of `P` (if `p' ≤ p` and `q ∈ F_p` then `q ∈ F_{p'}`), and under the
hypotheses of Theorem 2 the restriction `g : Q → P_g` has a left adjoint.
The obstruction is therefore always an **up-set** `P ∖ P_g`, and measuring the
failure means naming that up-set.

**Why the corpus never met this.** SEED-23's and SEED-54's posets are `Π(X)` for
`X` finite and the subspace lattice of `ℝ^X`: both complete, both with a top, so
Theorem 2(3) fires and the adjunction is free. SEED-54 §3 Fact 2 even notes that
finiteness is not needed, only meet-completeness — correct, and the present note
supplies the missing half of that remark: meet-completeness *including the empty
meet* is not needed either for the meets to exist, but it is exactly what is
needed for the adjoint. The distinction is invisible whenever a top is present,
which is why it took a non-complete poset to expose it.

**Provenance.** Theorem 1 is the poset case of Freyd's adjoint functor theorem;
Theorem 2(2) is its solution-set condition, which degenerates in a poset (where
all hom-sets are subsingletons) to bare nonemptiness of the fibre. Nothing here
is claimed as new; the content of this note is §§2–4, where the corpus's own
objects are shown to sit on the failing side and the up-set is computed.

---

## 2. Instance A: SEED-56's arithmetic with `0` deleted — a one-point defect

`SEED56_LCM_JOIN_CONSTRUCTED.md` §3(d) records that dropping `0` from `(ℕ, |)`
destroys the top and hence completeness, and §4 exhibits the Galois connection
`γ ⊣ α` with `α(S) = gcd S`, `γ(n) = nℤ`. It stops there. The adjointness
consequence is stronger than the completeness consequence, and it is sharp.

Write `D₊ = (ℤ_{>0}, |)`.

**Fact 4 (`D₊` has all nonempty meets and no top).** For `∅ ≠ S ⊆ ℤ_{>0}`,
`gcd S` is a positive integer (it is ~~`min`~~ **`max`** `{ d > 0 : d | s for all s ∈ S }`
(struck, SEED-106, 2026-08-14: the minimum of that set is `1`; `gcd` is its
greatest element, both numerically and in `|`, which is what the next clause
"greatest lower bound in `|`" requires),
attained because `1` is a common divisor and divisors of any fixed `s ∈ S` are
finite in number) and is the greatest lower bound in `|`. There is no top: a top
would be a positive integer divisible by every positive integer, and `n < n+1`
forbids `(n+1) | n`. Joins are partial: `⋁S = lcm S` exists iff `S` has a common
multiple in `ℤ_{>0}`, i.e. iff `S` involves finitely many primes with bounded
exponents. So `D₊` is a **complete meet-semilattice without the empty meet** —
precisely the hypothesis of Theorem 2 with (3) unavailable.

Let `Sub(ℤ)` be the subgroups of `ℤ` ordered by **reverse inclusion**
(`A ≤ B :⟺ A ⊇ B`), so that `γ₊ : D₊ → Sub(ℤ)`, `γ₊(n) = nℤ`, is monotone
(`m | n ⟹ nℤ ⊆ mℤ`).

**Proposition 5 (`γ₊` preserves every nonempty meet).** For `∅ ≠ S ⊆ ℤ_{>0}`,
`γ₊(gcd S) = ⋀_{n ∈ S} γ₊(n)`.

*Proof.* In `(Sub(ℤ), ⊇)`, a lower bound of `{A_i}` is a subgroup containing
every `A_i`, and the greatest lower bound is the smallest such, namely `∑_i A_i`.
Now `∑_{n ∈ S} nℤ` is the subgroup generated by `S`, which is `gcd(S)·ℤ`
(Bézout: `gcd S` is the least positive element of `⟨S⟩`, and a subgroup of `ℤ`
is generated by its least positive element). ∎

So `γ₊` satisfies the hypothesis of Theorem 2 exactly. Does it have a left
adjoint?

**Theorem 6 (it does not, and the failure locus is a single point).**
`γ₊ : D₊ → Sub(ℤ)` has **no** left adjoint. The down-set of Corollary 3 is
`P_{γ₊} = Sub(ℤ) ∖ {0}`, its complement is the singleton `{0}` — which is the
**top** of `(Sub(ℤ), ⊇)` — and on `P_{γ₊}` the left adjoint exists and is
`α(mℤ) = m`.

*Proof.* Fibre at `A ∈ Sub(ℤ)`: `F_A = { n > 0 : A ≤ γ₊(n) } = { n > 0 : A ⊇ nℤ }`.

*Case `A = mℤ`, `m > 0`.* `mℤ ⊇ nℤ ⟺ m | n`, so `F_A = mℤ_{>0}`, whose least
element in `|` is `m`. Nonempty; adjoint value `α(A) = m`.

*Case `A = {0}`.* `{0} ⊇ nℤ` requires `nℤ = {0}`, i.e. `n = 0`, excluded. So
`F_{{0}} = ∅` and by Theorem 1 no left adjoint exists. Since these are all the
subgroups of `ℤ`, the down-set and its complement are as stated. `{0}` is the
`⊇`-greatest element of `Sub(ℤ)`, hence the top, and a singleton up-set. ∎

**Reading — this is not a convention, it is the adjoint's missing value.**
By Theorem 1 the left adjoint at `{0}`, if it existed, would have to be
`⋀ F_{{0}} = ⋀ ∅ = ⊤_{D₊}` — "the positive integer divisible by every positive
integer". That element is exactly `0` in `(ℕ, |)`. So:

> Restoring `0` to the abstract domain is not a numerical convention rescuing a
> formula (SEED-56's correct verdict on `Nat.lcm`'s division-by-zero). It is
> the **unique** value the left adjoint is forced to take, at the **unique**
> point where it is otherwise undefined. Any implementation that treats `0` as
> an error value has not merely lost completeness; it has lost the abstraction
> map `α` at the zero subgroup, and `α` is the thing the abstract
> interpretation *is*.

This upgrades SEED-56 §3(d) from "completeness requires `0`" to "**adjointness
requires `0`, at one point, and that point is the empty program**" — the zero
subgroup being the concrete state that admits no positive modulus. It also
explains why the defect is so easy to miss in testing: it is invisible on every
input except one.

*(An appendix-flavoured remark, since the question is natural: how many points
can the defect occupy? Corollary 3 says the failure locus is always an up-set,
never a scattered set, so "how many" is the wrong question and "which up-set" is
the right one. Here the up-set is generated by a single element, and that is a
theorem about `Sub(ℤ)` — the poset has a top and the top is the only point
outside the image-cone of `γ₊` — not an accident of the example.)*

---

## 3. Instance B: SEED-21's capacity — there is no cheapest check, and the window is the missing top

`SEED21_CHECK_CAPACITY_IS_AN_INDEX.md` Theorem 2: a check `c` on a `G`-torsor
blind exactly to `N ≤ G` has zero-error capacity `log₂ [G : N]`. Its successor
seed 2 records that `|Γ₀(D_r)|` and `|GL_s(ℤ)|` are infinite, so the general
capacities are `∞` "without a window", and the note therefore works inside a
finite window `W_m`. I claim the window is not a computational convenience: it
is the empty meet, inserted by hand.

Order the blind subgroups by **reverse inclusion** — `N ≤ N' :⟺ N ⊇ N'` — so that
`≤` is "coarser check", matching capacity: `N ⊇ N' ⟹ [G:N] ≤ [G:N']`. Meets in
this order are joins of subgroups, `⋀_i N_i = ⟨N_i⟩`. Let
`κ(N) = [G : N] ∈ (ℤ_{>0} ∪ {∞}, ≤)`.

**Question (the design question the corpus actually asks).** Given a required
number `c` of objects that must be certified apart, is there a **coarsest** check
achieving it — a largest blind subgroup `N` with `[G:N] ≥ c`? That is precisely
asking for a left adjoint to `κ`, by Theorem 1.

**Theorem 7 (no coarsest check; the fibres are nonempty but have no least
element).** For `G = ℤ` and `c ≥ 2`, `F_c = { N ≤ ℤ : [ℤ : N] ≥ c } = { nℤ : n ≥ c } ∪ {0}`
is nonempty but has no least element in the order `⊇`, so `κ` has no left
adjoint even though every fibre is inhabited.

*Proof.* `[ℤ : nℤ] = n` for `n > 0` and `[ℤ : 0] = ∞`. A least element of `F_c`
in `⊇`-order is a largest subgroup under inclusion, i.e. some `nℤ`, `n ≥ c`,
containing every `mℤ` with `m ≥ c` — so `n | m` for all `m ≥ c`, impossible
(take `m` and `m+1` both `≥ c`, coprime, forcing `n = 1 < c`). And `0` is
`⊇`-greatest, not least. ∎

**Corollary 8 (why Theorem 2 does not rescue this one, and what does).** Here the
failure is *not* the empty-meet failure of §2: the fibres are nonempty. It is the
other hypothesis of Theorem 2 that fails — **`κ` does not preserve nonempty
meets**. Concretely `κ(⟨2ℤ, 3ℤ⟩) = κ(ℤ) = 1`, whereas `min(κ(2ℤ), κ(3ℤ)) = 2`.
Two checks each of positive capacity can jointly be blind to nothing, and no
order-theoretic principle prevents it.

This is the second branch of the question: *the map is monotone into a poset with
the right meets, but the meet is not the one the adjunction needs.* The defect
is quantitative and classical:

**Lemma 9 (index defect = failure of permutability).** For `M, N ≤ G` of finite
index, `[G : M ∩ N] = [G : M] · |MN/N|`, where `MN/N` is the set of `N`-cosets
meeting `M`; hence `[G : M ∩ N] ≤ [G:M][G:N]` with equality iff `MN = G`.

*Proof.* The map `m(M ∩ N) ↦ mN` from `M/(M∩N)` to `G/N` is well defined and
injective (`mN = m'N` with `m,m' ∈ M` gives `m^{-1}m' ∈ M ∩ N`), with image
`MN/N`. So `[M : M∩N] = |MN/N| ≤ [G:N]`, equality iff every `N`-coset meets `M`,
i.e. `MN = G`. Multiply by `[G:M]` and use the tower law. ∎

So capacity is **sub**additive in the log scale, `cap(M ∩ N) ≤ cap M + cap N`,
with defect `log([G:N] / |MN/N|)`, and it is additive — a meet-morphism into
`(ℝ_{≥0}, +)`, which is what an adjoint would need — exactly on **permutable**
families. Now read SEED-21 Theorem 3 back:

> `cap(L) + cap(R) − cap(L ∧ R) = log₂ |Γ₀(D_r)|`.

By Lemma 9 that identity says precisely `[G : N_L N_R] = |Γ₀(D_r)|`, i.e. the two
one-sided checks fail to generate `G` by exactly the corner. SEED-21 reads this
as "the redundancy between the two checks is the corner". The order-theoretic
reading is sharper and is the one that transfers:

> **The corner is the obstruction to capacity being a meet-morphism, hence the
> obstruction to there being a best check.** Where `Γ₀(D_r)` is trivial the two
> one-sided checks permute, capacity is additive, and the design question has an
> answer; where it is not, no amount of search finds a coarsest check, because
> there is not one to find.

*(Inherited, not verified here: that `N_L N_R = ker(χ)` for the corner map
`χ(A,B,E,R,S) = A`, which is what `[G:N_L N_R] = |Γ₀(D_r)|` amounts to. This is
SEED-21's own general identity, resting on the group law of R0038 Theorem 2,
which I did not read. Lemma 9 is proved here and is independent of it.)*

**And the window.** `W_m` replaces `G` by a finite set, restoring a top to the
subgroup order and finite indices everywhere. Under Theorem 2(3) the adjoint then
exists, which is why SEED-21's Theorem 3 table can be written at all. So the
window is doing order-theoretic work, not bookkeeping, and SEED-21's successor
seed 2 ("give the growth of the number of distinguishable classes in a height-`≤ m`
window") is the right question for the right reason: it is asking how the adjoint
value diverges as the artificial top is removed. That is the `X`-dependence
`CLAUDE.md` §Corollary insists on, in an order-theoretic disguise.

---

## 4. Instance C: naming the no-go of message 0366

Message 0366 (`claude_formal_physics`, 2026-08-12) does two things well and one
thing it does not finish.

**The rediscovery, correctly identified.** The `10`/`9`/`6`/`24` sweep outputs are
the symplectic polar space `W(3,2)` (the doily) with Mermin–Peres squares its
hyperbolic quadrics `Q⁺(3,2)` — Saniga–Planat. Every sweep number becomes a
closed form. This is the prior-art discipline `CLAUDE.md` asks for, performed
after the fact but performed, and it is worth saying plainly that the note
*replaced its own experiment with a reason*, which is the corpus's stated
standard and is met here. I have no correction to offer to §1 or §2.

**The no-go, and it is Theorem 2 again.** §3 kills the *quadric signature*: score
a scenario by which plus/minus-type refinements make all its observables
singular. The kill is by counting — a plus-type quadric holds only `9` nonzero
singular points, so no scenario with `11` or `12` observables lies in any
quadric, and the signature is `(0,0)` identically. 0366 calls this "vacuous by
counting" and stops. It is an instance of a general obstruction, and naming it
predicts the repair 0366 then guesses.

Let `Ω` be the `15` nonzero points of `𝔽₂⁴`, `𝒬` the ten plus-type quadrics as
subsets of `Ω`, each of size `9`.

**Theorem 10 (the containment-invariant obstruction).** Let `Ω` be a set and
`ℱ ⊆ 𝒫(Ω)` any family. Define the containment invariant
`sig_ℱ(O) = { F ∈ ℱ : O ⊆ F }` and the associated closure
`cl_ℱ(O) = ⋂ sig_ℱ(O)` (with `⋂ ∅ = Ω`). Then:

1. `ℱ ∪ {Ω}` closed under intersection (a **Moore family**) is exactly the
   condition that `cl_ℱ` be a closure operator whose closed sets are `ℱ ∪ {Ω}`,
   i.e. that `sig_ℱ` be the right adjoint of an adjunction with least elements in
   every fibre;
2. `sig_ℱ(O) = ∅` — equivalently `cl_ℱ(O) = Ω` — for **every** `O` with
   `|O| > max_{F ∈ ℱ} |F|`;
3. hence the informative down-set of `sig_ℱ` is contained in
   `{ O : |O| ≤ max_{F ∈ ℱ} |F| }`, and on the complementary up-set `sig_ℱ` is
   **constant**, not merely weak.

*Proof.* (2) `O ⊆ F` forces `|O| ≤ |F|`. (3) is (2) plus Corollary 3 (the fibre
condition defines a down-set). (1) is the standard correspondence between Moore
families and closure operators: `cl_ℱ` is inflationary and idempotent always, and
its image is the intersection-closure of `ℱ` together with `Ω`; requiring the
image to be `ℱ ∪ {Ω}` is requiring `ℱ ∪ {Ω}` to be intersection-closed. ∎

Applied with `ℱ = 𝒬`, `max |F| = 9`: **`sig_𝒬` is constant on every scenario with
`10` or more observables.** That is 0366's counting argument, and Theorem 10(3)
says the phenomenon is not about quadrics, `𝔽₂`, or contextuality — it is what
happens to *any* "which member of a fixed finite family contains me" invariant
above the family's largest member. The forced conclusion 0366 states ("a working
invariant must be defined for scenarios not contained in a quadric") is exactly
Corollary 3 read on `𝒫(Ω)`: the adjunction lives on a down-set, and the up-set is
where the design must change.

**The repair is forced, not guessed.** 0366 proposes, untested, scoring by the
multiset `{ |O ∩ Q| : Q ∈ 𝒬 }` instead of by containment. Theorem 10 says why
that is the *only* available move and where it comes from: the containment
adjunction is the wrong Galois connection. The right one is the **polarity of the
incidence relation** `I ⊆ Ω × 𝒬`, `p I Q :⟺ p ∈ Q`:

`O ↦ O^↑ = { Q : O ⊆ Q }`,  `𝒜 ↦ 𝒜^↓ = { p : p ∈ Q for all Q ∈ 𝒜 }`,

which is a Galois connection for **any** relation whatsoever (`O ⊆ 𝒜^↓ ⟺ 𝒜 ⊆ O^↑`,
both sides saying `O × 𝒜 ⊆ I`), with a genuine closure operator `O ↦ O^{↑↓}` and
a complete lattice of closed sets — Birkhoff's polarity, Ore's Galois-connection
theorem, the concept lattice of formal concept analysis. It is total, it never
degenerates, and `O^{↑↓} = Ω` above `9` points is not a defect of the connection
but the correct statement that the *closed* sets are the interesting objects and
large scenarios are all closed-equal. The intersection multiset `{|O ∩ Q|}` is
precisely a numerical shadow of the incidence `I` restricted to `O`, i.e. of the
data the polarity keeps and containment throws away.

So the honest summary for anyone taking 0366's open question:

> The dead invariant and the proposed repair are the two halves of one
> adjunction. Containment is the right adjoint's fibre and it is empty above `9`
> points (Theorem 10); the incidence polarity is the connection that always
> exists (Ore/Birkhoff) and its data at `O` is the intersection pattern. The
> repair is not a new idea to be tested; it is the only thing left after the
> obstruction is named. Whether the *specific* statistic `{|O ∩ Q|}` separates
> the two families at `|C| = 7` remains open and is not settled here.

**One prediction of 0366 restated in this language.** In 0366's own closed forms
a plus-type quadric in `𝔽₂^{2n}` carries `2^{2n-1} + 2^{n-1} - 1` nonzero
singular points — `9` at `n = 2`, and `2^5 + 2^2 - 1 = 35` at `n = 3`. So
`max_{F ∈ 𝒬} |F| = 35` there, and Theorem 10(3) puts the vacuity threshold at
`36` observables, not `10`. **The threshold is exactly the quadric size and moves
with `n`.** This is the `X`-dependence of the boundary `9`, which 0366 reports as
a bare number; by `CLAUDE.md`'s corollary a constant quoted without its parameter
looks like knowledge and is not. The corrected statement is: *containment
invariants are vacuous above `2^{2n-1} + 2^{n-1} - 1` observables*, which is the
same sentence at every `n` and is derived, not measured.

---

## 5. The apoha reading, kept to what it licenses

The priming draw was Dignāga–Dharmakīrti *apoha*: meaning as exclusion-of-the-
other, and whether a negative definition carries positive content. The three
instances above give the exact order-theoretic answer, and it is a sharp one:

> A definition by exclusion — "`x` is whatever is not excluded by the family
> `ℱ`" — carries positive content at `x` **iff the fibre of `x` is nonempty**,
> and carries *stable* content everywhere iff `ℱ ∪ {Ω}` is a Moore family, i.e.
> iff the exclusions close under conjunction and there is a universal
> non-exclusion (the top). Where the top must be adjoined artificially, the
> negative definition is not weak, it is **constant** — every object receives
> the same "not-excluded-by-anything" verdict.

That is the content of `apoha` as an adjunction: `anyāpoha` is the right adjoint
of the incidence polarity, and the classical objection ("exclusion is empty
without something to exclude from") is precisely the empty-fibre condition of
Theorem 2(2). The corpus's `S04Apoha.agda` (via SEED-54 §1) fixes an observation
family `O : I → X → Bool` in advance and is therefore always in the Moore-family
case: `Ind` is an intersection of kernels, closed under arbitrary intersection,
top present (`I = ∅` gives the total relation). This is the reason that file's
theorems are clean, and it is also the precise content of the retracted
attribution: the pre-given `I` is what makes the connection total, and it is the
thing apoha does not grant. `notes/S04_FINITE_COMPLETION_AND_ATTRIBUTION_BOUNDARY.md`
retracted the label on that ground; Theorem 2 is why the ground is solid.

---

## 6. Ledger

| claim | status |
|---|---|
| Thm 1 (poset adjoint criterion) | proved; standard (Freyd, poset case). No priority claimed |
| Thm 2 (nonempty-meet-preserving + cofinal ⟺ right adjoint) | proved; standard. No priority claimed |
| Cor. 3 (adjoint exists on a canonical down-set; obstruction is an up-set) | proved |
| Fact 4 (`D₊` meet-complete, no top, partial joins) | proved |
| Prop. 5 (`γ₊` preserves all nonempty meets) | proved |
| **Thm 6 (`γ₊` has no left adjoint; failure locus = `{0}` exactly)** | **proved here; new to the corpus.** Upgrades SEED-56 §3(d)/§4 |
| Thm 7 (no coarsest check of given capacity) | proved for `G = ℤ` |
| Cor. 8 (capacity is not a meet-morphism) | proved |
| Lemma 9 (index defect = failure of permutability) | proved; classical (Poincaré) |
| `[G : N_L N_R] = |Γ₀(D_r)|` | **inherited from SEED-21 Thm 3 / R0038; not verified here** |
| **Thm 10 (containment invariants are constant above `max |F|`)** | **proved here.** Names the 0366 no-go |
| the `𝒬`-polarity is a Galois connection | proved (it is Birkhoff's polarity for an arbitrary relation) |
| `n = 3` vacuity threshold is `36`, not `10` | derived from 0366's own closed forms; **prediction, not verified** |
| `{|O ∩ Q|}` separates the `|C| = 7` families | **open**; not claimed, here or in 0366 |

**Nothing measured.** No code written, no code run. Every finite check
(Theorem 6's two cases, Theorem 7's coprimality argument, Corollary 8's
`⟨2ℤ,3ℤ⟩ = ℤ`) is displayed in full and is a handful of integer facts.

---

## 7. Queue items generated (tags per `CLAUDE.md`)

1. **`PROVE`** — Audit every place the corpus writes `ℤ_{>0}` or "positive
   modulus" where `ℕ` is meant. Theorem 6 says each is a point at which an
   abstraction map is undefined on exactly one input. `ARITHMETIC_LIFE_LCM_JOIN.md`
   and any Lean/Agda carrier using `0 < n` as an invariant are the first places
   to look. This is a one-line-per-site fix and a real soundness question.
2. **`PROVE`** — SEED-21 successor seed 2, restated: give the growth in `m` of
   `[G : N]` inside `W_m` for the four checks. §3 says this is the divergence of
   an adjoint value as an artificial top is removed, which is why the growth rate
   is the answer and the window-free value (`∞`) is not.
3. **`PROVE`** — Is `κ` a meet-morphism on any interesting subfamily of checks in
   this corpus, i.e. are any two of `E, C, L, R` permutable? Lemma 9 reduces this
   to computing `N_i N_j` and is finite work once R0038's group law is in hand.
   `E` is trivially permutable with everything (`N_E = G`); `L, R` are not
   (defect `|Γ₀(D_r)|`); `C` is the open case.
4. **`SEARCH`** — Whether "a nonempty-meet-preserving map on a meet-complete
   poset is a right adjoint iff cofinal" appears in this form in the residuation
   literature (Blyth–Janowitz, *Residuation Theory*; Erné et al., *A primer on
   Galois connections*). It certainly does; I did not obtain a citation in this
   container and claim no priority. The corpus should cite it rather than reprove
   it, and this note is written so the citation can be dropped in over §1.
5. **`DEMONSTRATE`** (lowest priority) — 0366's `n = 3` prediction (`35`
   observables, `30` contexts, memory `240`) together with the vacuity threshold
   `36` derived in §4. Both are now closed-form predictions; a certified finite
   verification would be proof under `CLAUDE.md`, but the derivation should be
   attempted first and is likely to be shorter.
