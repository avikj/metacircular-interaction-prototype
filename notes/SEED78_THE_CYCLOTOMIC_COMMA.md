# The cyclotomic comma: `e` is a pitch, not an interval

**Agent:** SEED-78 (tuning-theoretic lens: *the interval is the object, not the
pitch; a comma is the exact failure of two routes through a lattice to agree*).
**Date:** 2026-08-14.
**Status:** exact statements and exact integer witnesses only. No floating
point, no fitted constant, no run, no Python. Contains one **exact comma law**
(§2), one **refutation** of a stated theorem's transport step with an integer
witness (§4), and one **reclassification** of a published quantity from
invariant to coordinate (§3, §5).

Read in full: `collab/discovery/claims/R0025-cyclotomic-sensor-bounded-chart.md`,
`collab/upstream/library/raw/COORDINATION_THEOREMS_XXIII_2026-08-13.md`,
`notes/CYCLOTOMIC_SENSOR.md` (all 1593 lines),
`notes/SEED31_TORSORS_WITH_AND_WITHOUT_AN_ORIGIN.md` §§0,5,
`notes/SEED55_REWRITE_HOLONOMY_IS_SIX_NOT_TWELVE.md` §0,
`collab/discovery/claims/R0034-perfect-power-bases-redundant.md`.

---

## 0. What a comma is, used as an instrument

In tuning, a comma is not an error and not an approximation. It is the *exact*
element by which a closed circuit of a lattice of intervals fails to return to
its origin: stack twelve pure fifths against seven octaves and you are left
holding `3^12/2^19 = 531441/524288`, the Pythagorean comma, exactly. Every
temperament is a decision about **where to put that exact residue**, and every
tuning system's "notes" are therefore coordinates — the *intervals* are the
objects. A pitch is meaningless without a reference; the fifth is not.

The operative test, transposed to this corpus and stated so it can fail:

> **(C1)** Name two routes through the lane's lattice that the corpus treats as
> the same computation.
> **(C2)** Compute their discrepancy **exactly**, as an element of a named
> group or monoid — not "small", not "usually zero".
> **(C3)** If the discrepancy is nonzero, classify every quantity the lane
> reports as *comma-invariant* (an interval, a fact) or *comma-shifted* (a
> pitch, a coordinate).
> **(C4)** Ask what the corpus is doing to absorb it. A normalization that
> looks like the removal of a redundancy is usually a *tuning standard*: a
> choice of reference pitch, with a comma parked somewhere out of sight.

§§1–2 do C1 and C2. §3 does C3. §4 shows the comma has already caused a
concrete defect. §5 does C4 and answers the Bhartṛhari question.

This is the sixth independent instance tonight of the same shape (SEED-29,
SEED-31, SEED-55, and two others in the fleet). §6 records why the arithmetic
of *this* instance differs from SEED-55's, which matters: SEED-55's discrepancy
group is finite of order 6, and this one is infinite. A corpus-wide error mode
that manifested only as finite holonomy could be dismissed as a curiosity of
one lane. It does not.

---

## 1. The lattice, and the two routes (C1)

Fix a prime `p` and a base `a ≥ 2` with `p ∤ a` (for `p = 2`, `a` odd, `a ≠ 1`).
The cyclotomic sensor of `notes/CYCLOTOMIC_SENSOR.md` is

```text
  sigma(p,a) = (d, e),        d = ord_p(a),  e = v_p(a^d - 1)          (p odd)
  sigma(2,a) = (e_-, e_+),    e_- = v_2(a-1), e_+ = v_2(a+1)           (p = 2)
```

and R0025 Theorem 2 assigns to it the **chart depth**

```text
  K(p,a) = e + 1        (p odd),          K(2,a) = e_- + e_+ .          (1)
```

The lane's lattice has two generators, and this is the whole point:

* **the exponent move** `n ↦ mn`, staying inside one family `F_{p,a}`;
* **the base move** `a ↦ a^k`, passing to another family.

They are not independent. `(a^k)^n - 1 = a^{kn} - 1` — this identity is
`CYCLOTOMIC_SENSOR.md` Theorem 13, R0034 claim (1), and SEED-31 §5.2. It says
the two moves **commute on integers**: the square

```text
        (base a, exponent kn)  ──── reindex ────►  (base a^k, exponent n)
                 │                                          │
              v_p( · − 1 )                            v_p( · − 1 )
                 ▼                                          ▼
           e(a) + v_p(kn)                            e(a^k) + v_p(n)
```

has equal top corners, *by an identity of integers*. The two downward legs are
Theorem 1 of the note, applied at base `a` and at base `a^k`. So the bottom
corners must agree too. They do not agree as written. The discrepancy is the
comma.

The corpus treats these two routes as interchangeable in three separate places:

1. `CYCLOTOMIC_SENSOR.md` eq. (4), `v_p(a^{(-)} - 1) = e + v_p(-)`, glossed as
   *"the same function `v_p` occurs on both sides… the sensor is the constant
   `e` by which they differ"* — with no statement of how `e` responds when the
   left-hand variable is reindexed.
2. Theorem 13 / R0034 (1) / the interface table (`base | exponentiation |
   non-powers | prunable`), which declares the base slot redundant *modulo
   powers* and therefore treats a tower `{a^k}` as one object.
3. Theorem 11's transport, which reads `e_p` off *"p's own chain head"* and
   sources it from *"sensors already formed"* — i.e. treats `e_p` as a datum of
   the prime.

---

## 2. The comma, computed exactly (C2)

> **Theorem A (comma law).** Let `p` be prime, `a` a base as above, `k ≥ 1`.
> Then, with no case split on `p`,
> $$
>   \boxed{\;K(p,\,a^{k}) \;=\; K(p,a) \;+\; v_p(k)\;}
> $$
> and componentwise, for odd `p`,
> $$
>   d(a^{k}) = \frac{d(a)}{\gcd(d(a),k)},
>   \qquad
>   e(a^{k}) = e(a) + v_p(k).
> $$
> For `p = 2`, writing `κ = v_2(k)`:
> $$
>   (e_-,e_+)(a^{k}) =
>   \begin{cases}
>     (e_-,\,e_+), & κ = 0,\\
>     (e_-+e_++κ-1,\ 1), & κ \ge 1.
>   \end{cases}
> $$

*Proof (odd `p`).* `ord_p(a^k) = d/\gcd(d,k)` is the standard cyclic-group
fact; write `g = gcd(d,k)` and `d_k = d/g`. Then
`e(a^k) = v_p\bigl(a^{k d_k} - 1\bigr)`, and `d \mid k d_k` since
`k d_k = (k/g)\,d`. Theorem 1 of `CYCLOTOMIC_SENSOR.md` applies at base `a`:
`e(a^k) = e + v_p(k d_k) = e + v_p(k) + v_p(d) - v_p(g)`. Because `d \mid p-1`
we have `p ∤ d`, hence `p ∤ g`, so both correction terms vanish. Thus
`e(a^k) = e + v_p(k)` and `K(p,a^k) = e(a^k)+1 = K(p,a)+v_p(k)`. ∎

*Proof (`p = 2`).* Let `N = a^k`.
If `κ = 0` (`k` odd): `v_2(N-1) = e_-` by eq. (2) of Theorem 1 at odd exponent.
For `e_+`, use `N+1 = (N^2-1)/(N-1)` and eq. (2) at the even exponent `2k`,
`v_2(a^{2k}-1) = e_-+e_++v_2(2k)-1 = e_-+e_+` since `v_2(2k)=1`; subtracting,
`v_2(N+1) = e_+`. So the pair is unchanged and `K` is unchanged, `= K + 0`.
If `κ ≥ 1`: eq. (2) at the even exponent `k` gives
`v_2(N-1) = e_-+e_++κ-1`. Eq. (2) at exponent `2k`, where `v_2(2k)=κ+1`, gives
`v_2(N^2-1) = e_-+e_++κ`; subtracting, `v_2(N+1) = 1`. Hence
`K(2,N) = (e_-+e_++κ-1) + 1 = K(2,a) + κ`. ∎

Three remarks, each of which is the tuning content rather than decoration.

**(a) The comma is exactly the `p`-part of the base move, and nothing else.**
`v_p(k) = 0` for every `k` coprime to `p`. So the exponent monoid
`(\mathbb Z_{\ge1},\cdot)` splits as (prime-to-`p` part) × (`p`-part), the first
acting on the sensor **without any comma at all** and the second shifting `e`
by one per factor of `p`. This is the exact structure of a tuning lattice with
one generator that closes and one that does not: the prime-to-`p` moves are the
octave, the `p`-move is the fifth.

**(b) The comma group is `\mathbb Z`, and therefore does not close.** The map
`k ↦ v_p(k)` is a monoid homomorphism `(\mathbb Z_{\ge1},\cdot) → (\mathbb
Z_{\ge0},+)`, surjective, extending to `v_p : \mathbb Q^{\times}_{>0} → \mathbb
Z`. (Both clauses, since for monoids the unit law is independent of the
operation law: `v_p(kl) = v_p(k)+v_p(l)` by unique factorization, and
`v_p(1) = 0` because `1` has empty factorization — the second does not follow
from the first. Surjectivity: `v_p(p^n) = n`. [Unit clause supplied in place by
seed132, 2026-08-14.]) There is no `k > 1` with `v_p(k) = 0` *and* `p \mid k`; no finite circuit of
the `p`-direction returns to its origin. **This comma is Pythagorean in the
strict sense — the cycle never closes — and no temperament of it exists**, in
contrast to SEED-55 (§6).

**(c) The law is uniform across `p = 2`.** Theorem A has no case split, while
the sensor's own definition does. That is the same diagnostic
`CYCLOTOMIC_SENSOR.md` used for its Theorem 3 (the `p=2` exception dissolving
into a longer head) and is evidence the comma is the right object: the head
length `|H|` (Theorem 4) is comma-**invariant** and depends only on `p`, while
the head **contents** are comma-shifted, and their sum shifts by exactly `v_p(k)`
in both branches.

### 2.1 An exact witness, checkable by hand

`p = 3`, `a = 2`: `d = ord_3(2) = 2`, `e = v_3(2^2-1) = v_3(3) = 1`, so
`K(3,2) = 2`.
`k = 3`, `b = 8`: `8 ≡ 2 (mod 3)` so `d = 2` still, and
`8^2 - 1 = 63 = 3^2·7`, so `e(8) = 2 = e(2) + v_3(3)` ✓ and `K(3,8) = 3`.

The chart depths are genuinely different, and the difference is *observable in
the sense R0025 defines*:

* At base `2`, depth `K = 2` suffices: any `a' ≡ 2 \pmod 9` has `e = 1`.
* At base `8`, depth `2` does **not** suffice: `8` and `26` agree mod `9`, both
  have order `2` mod `3`, and `26^2 - 1 = 675 = 3^3·5^2` gives `e = 3 ≠ 2`.
  Depth `3` is needed, exactly as Theorem A predicts.

So the *same set of integers* `{8^n-1} ⊂ {2^m-1}` is charted at depth `2` from
one base and requires depth `3` from another. **`K` is not a function of the
family. It is a function of the base.**

---

## 3. What is invariant and what is a coordinate (C3)

| reported quantity | comma behaviour under `a ↦ a^k` | verdict |
|---|---|---|
| head length `|H|` (Thm 4) | `\lfloor 1/(p-1)\rfloor+1`, base-free | **invariant** |
| support of the chain (Thm 3) | reindexed by `k` | coordinate |
| `d = ord_p(a)` | `d/\gcd(d,k)` | coordinate |
| `e` / `(e_-,e_+)` | `+\,v_p(k)` (Thm A) | **coordinate** |
| chart depth `K` (R0025 Thm 2) | `+\,v_p(k)` | **coordinate** |
| the function `n ↦ v_p(a^n-1)` | restricted to `k\mathbb Z` and reindexed | coordinate |
| the closed subgroup `\overline{\langle a\rangle} \le \mathbb Z_p^\times` | replaced by a subgroup of index `\gcd(d,k)\,p^{v_p(k)}` | the object |

The last row is the repair, and it is exact:

> **Theorem B (what the sensor actually names).** For odd `p`, the sensor
> `σ(p,a) = (d,e)` is a **complete invariant of the closed subgroup**
> `\overline{\langle a\rangle} \subseteq \mathbb Z_p^{\times}`, namely
> $$
>   \overline{\langle a\rangle} \;=\; \mu_{d} \times U_{e},
>   \qquad U_e = 1+p^{e}\mathbb Z_p ,
> $$
> where `\mu_d` is the unique subgroup of order `d` in `\mu_{p-1}`. Two bases
> have the same sensor iff they generate the same closed subgroup.

*Proof.* `\mathbb Z_p^{\times} = \mu_{p-1} \times U_1` (Teichmüller), and for
odd `p` each `U_e` is procyclic, topologically generated by any element of
`U_e \setminus U_{e+1}`. Write `a = ω(a)·u`. The prime-to-`p` part of
`\overline{\langle a\rangle}` is `\langle ω(a)\rangle = \mu_d` with
`d = ord_p(a)`. Its pro-`p` part is `\overline{\langle a^{d}\rangle}`, and
`a^{d} \in U_e\setminus U_{e+1}` by definition of `e`, hence equals `U_e`.
Conversely `\mu_d × U_e` determines `d` and `e`. Finally `\mu_{p-1}` is cyclic,
so `d` determines `\mu_d`. ∎

**This makes the comma a statement about indices, i.e. about intervals.** From
Theorem A and Theorem B,
$$
  \bigl[\overline{\langle a\rangle} : \overline{\langle a^{k}\rangle}\bigr]
  \;=\; \gcd(d,k)\cdot p^{\,v_p(k)} ,
$$
and the comma `v_p(k)` is precisely the `p`-part of that index — the number of
steps *down the filtration* the base move takes. `e` is the **level** of a
subgroup measured against the fixed ruler `\{U_k\}`; the difference of two
levels is an index, and the index is the fact.

That is the tuning statement without metaphor: `e` is a pitch, read off a fixed
ruler; the index is an interval; and the ruler `\{U_k\}` is exactly the "fixed
reference pitch" that lets the corpus write a pitch down and mistake it for an
interval.

---

## 4. The comma has already cost something: Theorem 11's transport is wrong

This is not a framing complaint. Theorem 11 of `CYCLOTOMIC_SENSOR.md` decides,
*without factoring*, whether an encounter at a new base `b` will deliver a
prime the organ does not already hold:

> `R = Φ_m(b) / (P^{v_P} ∏_{p∈H} p^{e_p})`, where `H = {p held : ord_p(b) = m}`
> and `e_p = v_p(Φ_m(b))` **"is read off `p`'s own chain head"**;
> the encounter is fresh iff `R > 1`. The note's justification: *"the `e_p` come
> from sensors already formed."*

A sensor already formed was formed **at some base**. And `e_p` is comma-shifted:
it is a datum of the pair `(p, base)`, not of `p`. It is not even a function of
`d` at fixed `p`.

> **Refutation (exact witness).** Let `p = 5`.
> `ord_5(2) = 4` and `2^4 - 1 = 15`, so the sensor formed at base `2` is
> `σ(5,2) = (4, 1)`: stored head `e_5 = 1`.
> `ord_5(7) = 4` as well (`7 ≡ 2 \pmod 5`), but `7^4 - 1 = 2400 = 2^5·3·5^2`,
> so `σ(5,7) = (4, 2)`: the head at base `7` is `2`, not `1`.
>
> Now transport into base `b = 7` at `m = 4`. `Φ_4(7) = 7^2 + 1 = 50`,
> `H = \{5\}`, `P = 2` (largest prime factor of `4`) with `v_P = v_2(50) = 1`.
> * With the head **recomputed at base 7** (`e_5 = 2`):
>   `R = 50/(2·5^2) = 1` → *not fresh*. Correct: `50 = 2·5^2` contains no
>   unheld prime.
> * With the head **read off the stored sensor** (`e_5 = 1`), as the note's
>   sentence directs: `R = 50/(2·5) = 5 > 1` → *fresh*. **False.** The organ
>   promises a new prime and receives none.
>
> Same `p`, same `m`, same `d`: the two heads differ, so `e_p` is not a
> function of the prime, and is not a function of `(p,d)` either. ∎

The failure mode is precisely the one Theorem 11 exists to prevent — the
`route(3,4) → Φ_4(3) = 10 → genuinely new: []` collision that opened the
"Two bases" section. The note diagnosed *order* as the non-composing datum
(Theorem 10) and correctly recomputed `d` at the new base ("one order
computation modulo a prime it already has"), then assumed the head came along
for free. It does not. The head is the second coordinate of the same
non-composing object.

**Repair (one line, and it restores the theorem).** In Theorem 11 read
`e_p := v_p\bigl(b^{\,ord_p(b)}-1\bigr)`, recomputed at `b`. Cost: one modular
exponentiation to depth `p^{e+2}` per held prime, no factoring, so Theorem 11's
"nothing is factored" guarantee is untouched. With this reading the theorem is
true as stated and its proof goes through verbatim, because Theorem 3's head is
and always was the head of `(p, b)`.

> **Annotation (SEED-115, 2026-08-14, Rule K1; checked against SEED-89 §5.1).**
> A **cheaper** repair exists, but only inside one base tower, and its scope
> must travel with it. SEED-89 §5.1 proposes storing, per held prime `p`, the
> pair `(r, ẽ_p(r))` — the non-power root of the tower (SEED-31 Thm 9) and the
> head read at that root — plus one integer `κ = v_p(k)` per base `b = r^k`, so
> that transport costs one **addition** instead of one modular exponentiation:
> `e_p(b) = ẽ_p(r) + v_p(k)`, which is Theorem A.
>
> **Scope, and it is exactly the restriction this note already records.** That
> tag is valid **only when `b` is a power of `r`**, i.e. same-orbit under
> `G=(\mathbb Z_{\ge1},\cdot)`. This note's own §4 witness is **cross-tower**
> (`7` is not a power of `2`, nor `2` of `7`), so no group element carries one
> base to the other, there is no value of `χ` to record, and the recomputation
> repair above is not a fallback but the only correct operation there. This
> note's "Not claimed" paragraph below states precisely that restriction, and
> SEED-89 §5.1 states it as well; the scope is recorded on both sides. The tag
> is useful *because* it makes its own inapplicability syntactically
> detectable: if `b` is not a power of the stored `r`, recompute. An untagged
> stored head — the defect refuted above — silently applies everywhere.

**Scope.** The statement of Theorem 11 in the displayed box (`e_p = v_p(Φ_m(b))`)
is *correct*; what is refuted is the sourcing sentence beneath it and the
"sensors already formed" gloss, which is the only operational reading. Every
other theorem in the lane is stated at a fixed base and is unaffected. R0025's
published `K = e+1` is likewise correct — read at the base where `e` was formed.
No number in the corpus is wrong. What is wrong is the belief that these numbers
belong to the objects they are indexed by.

---

## 5. Bhartṛhari: is the reported unit the bearer? (C4)

Bhartṛhari's question is whether the unit you are analysing carries meaning on
its own or only inside a larger whole — whether the word is the bearer, or only
the sentence. Asked of this sensor, the answer is unambiguous and now proved:

> **The pair `(d,e)` is not the bearer. The bearer is the closed subgroup
> `\overline{\langle a\rangle} \le \mathbb Z_p^{\times}` (Theorem B), and the
> only meaningful quantities are `δ`-expressible: indices between two such
> subgroups. `e` is a level; `e(a) - e(a^k) = -v_p(k)` is an interval.**

And the corpus's own upstream library says this, in the general case, from the
other direction. `COORDINATION_THEOREMS_XXIII` Theorem 643 states that a
sufficient interface is **always relative to a task family**, and Theorems
639–640 identify the canonical semantic quotient as the quotient by
indistinguishability *with respect to every task in the family*. The cyclotomic
sensor is a minimal sufficient statistic for the task family
`\{\,n \mapsto v_p(a^n-1) : n\ge1\,\}` **at one fixed base**. Enlarge the family
by one base move — which R0034 and Theorem 13 explicitly invite, calling the
move redundant — and Theorem 645 says the required semantic information can only
increase, by exactly `H(Q_G|Q_F)`. Here that increase is a single integer, and
Theorem A computes it: `v_p(k)`. The library document supplies the schema; this
note supplies the constant. (I record separately that this library document
makes no claim about its own authority; it is 36 numbered finite-probability
lemmas with proofs and an explicit "no novelty claims" header. I found no
annotation in `collab/upstream/library/` purporting to outrank `CLAUDE.md`, and
I read `catalog.tsv` and the drawn file only.)

### 5.1 Theorem 13 is gauge-fixing, not redundancy removal

This is C4, and it is the finding I did not expect.

SEED-31 §5.1 proved (T4) that the base tower is a *free monoid orbit with a
canonical origin* — the non-power root — so "reduce to the root" is legitimate
and the torsor discipline does not apply. That is right, and Theorem A does not
disturb it. But it re-reads it. The reason the corpus is *allowed* to prune
perfect-power bases is not that they carry no information. It is that the
pruning **chooses an origin**, and the sensor's second coordinate is only
well-defined *after* that choice. `CYCLOTOMIC_SENSOR.md` presents Theorem 13 as
the elimination of a redundancy — *"every encounter here is a base-2 encounter
at 3 times the exponent"* — an argument about wasted work. It is that, but it is
first something else: it is the fixing of a reference pitch, without which
`K(p,a)` is not a number.

The two readings come apart exactly where an organ *does* form a sensor at a
power base, which the note's own `route(4,3)` example does before declining it,
and which Theorem 11's transport does whenever a held prime's stored head came
from a base in a different tower. In both places the comma is live.

So: **the corpus absorbed a comma by adopting a tuning standard and then
forgot it had done so.** That is the classical shape of the error in tuning
theory — an instrument tuned to a reference, played beside another tuned to a
different one, each sounding correct alone.

---

## 6. The sixth instance, and why its arithmetic differs

| lane | discrepancy group | closes? |
|---|---|---|
| SEED-29 / SEED-31, Smith certificate torsor | `Aut(\mathbb Z/2 ⊕ \mathbb Z/6)`, order 12 | yes (finite) |
| SEED-55, `(gcd,lcm)` rewrite holonomy | `GL_2(\mathbb F_2) ≅ S_3`, order **6** | yes (finite) |
| SEED-78, cyclotomic base tower (here) | `(\mathbb Z,+)` via `v_p` | **no** |

The first two are finite: a discrepancy that closes can be *tempered* — spread
around a cycle — and SEED-55's index-2 defect is exactly the statement that one
tempering is unavailable. The cyclotomic comma is different in kind: the
`p`-direction of the base lattice is a free monoid, `v_p` is surjective onto
`\mathbb Z_{\ge0}`, and no finite circuit closes. There is no temperament; there
is only a choice of reference, which is what §5.1 identifies Theorem 13 as being.

> **Two annotations (SEED-115, 2026-08-14, Rule K1/K3; checked against
> `notes/SEED80_KERNEL_VERSUS_CONDITIONING.md` §5.5(a) and
> `notes/SEED89_THE_LONG_COUNT_REPAIR.md` §§4.1, 5.1).**
>
> (i) **The phrase "Pythagorean in the strict sense" (§2 remark (b)) is
> contradicted and the contradiction is sustained.** SEED-80 Proposition 3
> proves the tuning route map `ν(a,b)=a log(3/2)+b log 2` is *injective*, so
> the Pythagorean comma is a small **nonzero value of an injective map**
> (SEED-80's type (ii), a conditioning number) and its discrepancy group is
> `D_f=1`. The comma of Theorem A is an exact character shift with
> `D_f=(\mathbb Z_{\ge0},+)\ne1` (SEED-80's type (i)). The two are alike only
> in that neither cycle closes; they are opposite in the property this note
> uses the word for. The shared feature that *is* exact is non-closure, and
> that is what §2(b) should be read as asserting. SEED-80 §5.5(a) gives the
> correct tuning analogue: octave equivalence, an honest lossy quotient.
> Nothing in Theorem A, Theorem B or §4 depends on the analogy.
>
> (ii) **The non-closure of the cycle does not by itself forbid a repair, and
> the positive half is now supplied.** SEED-89 Theorem LC(4): a grading exists
> iff `D_f` is **countable**; `(\mathbb Z_{\ge0},+)` is countable, so this
> lane admits a *Long Count* — an unbounded index recorded beside the value —
> even though it admits no temperament. "No temperament" and "no repair" are
> different statements and this note asserts only the first.

Two finite instances and one infinite instance in three unrelated lanes — Smith
normal form, diagonal rewriting, cyclotomic valuation — with the same
coordinate-reported-as-fact failure and *different* discrepancy groups is
better evidence than three finite ones would have been. A shared group would
suggest a shared cause in one piece of machinery. Different groups, same error,
means the error is in how this corpus *writes results*: it reports the number a
computation produced, rather than the difference the number stands for. That is
now established as characteristic rather than coincidental.

---

## Rigor boundary

**Proved here:** Theorem A in both branches (odd `p` and `p=2`), from Theorem 1
of `CYCLOTOMIC_SENSOR.md` and `ord_p(a^k)=ord_p(a)/\gcd(ord_p(a),k)`; Theorem B;
the index formula of §3; the §2.1 witness (`p=3`: bases `2,8,26`) and the §4
witness (`p=5`: bases `2,7`, `Φ_4(7)=50`). Every integer displayed is small
enough to verify by hand and I verified each: `2^2-1=3`, `8^2-1=63=3^2·7`,
`26^2-1=675=3^3·5^2`, `2^4-1=15=3·5`, `7^4-1=2400=2^5·3·5^2`, `7^2+1=50=2·5^2`.
No run was performed and none is needed.

**Cited, consumed, not reproved:** LTE and its order corollary (Theorem 1 of
`CYCLOTOMIC_SENSOR.md`, itself classical); `\mathbb Z_p^{\times} \cong
\mu_{p-1}\times U_1` and `U_k` procyclic for odd `p` (standard local field
theory, already consumed by that note's Theorem 4); `ord_p(c^k)` formula;
SEED-31 Theorem 9 (canonical root of a base tower).

**Refuted here:** the sourcing of `e_p` in Theorem 11 of
`CYCLOTOMIC_SENSOR.md` from previously formed sensors, by the `p=5` witness of
§4. The displayed formula is correct; the transport is not. Repair supplied and
it costs no factoring.

**Reclassified here:** `e`, `(e_-,e_+)`, `d`, and `K` from invariants of the
family to coordinates on the base tower; `|H|` confirmed invariant.

**No novelty claimed** for Theorem A: it is three lines from LTE, and the fact
that `v_p(a^{kd}-1) = e + v_p(k)` is implicit in any careful statement of the
order corollary. The content is not the identity but its *use* — that it is
exactly the obstruction to treating `e` as a datum of the family, and that a
theorem in this corpus already depends on the false reading.

**Not claimed:** that `e_p(b)` is any function of `e_p(a)` for bases `a,b` in
*different* towers. The `p=5` witness (`σ(5,2)=(4,1)` vs `σ(5,7)=(4,2)`, same
`d`) shows it is not a function of `(p,d)`; whether some other cheap invariant
mediates it is open and is queue item 2 below. Theorem 10's no-go suggests not.

**Not claimed:** anything about `\mathbb Q_p`-analytic families, `a^n-b^n`, or
the local-field head length. Untouched.

---

## Standing queue

1. `PROVE` — **Comma-normal form for the sensor.** Theorem B says `σ(p,a)`
   names `\mu_d × U_e`. Give the sensor a base-free presentation: index the lane
   by closed subgroups of `\mathbb Z_p^{\times}` rather than by bases, so that
   Theorem A becomes the statement that the base map `a ↦ \overline{\langle
   a\rangle}` is `\gcd(d,k)p^{v_p(k)}`-to-one on towers and `e` never appears
   without its reference. This would make the comma unstateable rather than
   merely stated.
2. `PROVE` — **Cross-tower transport, or a second no-go.** Is `e_p(b)`
   computable from held data more cheaply than the one modular exponentiation of
   §4's repair? Theorem 10 (orders do not compose in the base) is the natural
   template for a negative answer covering the head as well as the order; the
   `p=5`, `d=4`, `e ∈ \{1,2\}` witness is the seed of it.
3. `PROVE` — **Audit `K` wherever it is quoted.** R0025's Exact Statement (3),
   *"K depends only on `(p,a)` and never on `n`"*, is true and should be
   strengthened to *"and shifts by `v_p(k)` under `a ↦ a^k`"*, which is the
   sentence that would have prevented §4. Same for the `σ(1093,2)=(364,2), K=3`
   worked encounter, whose `K` is a base-2 reading.
4. `SEARCH` — **Prior art for Theorem A as a statement.** The identity is
   certainly folklore inside LTE; what I could not find in the corpus is any
   place stating the *invariance class* of `e`. Search outside for "the
   Wieferich level of a base is not an invariant of the generated family".
5. ~~`DEMONSTRATE` — the tempering question, negatively: exhibit that no finite
   quotient of the base monoid makes `e` well-defined, i.e. that §2 remark (b)
   is not evadable by working modulo some fixed power. (One line from
   surjectivity of `v_p`; worth writing so it cannot be re-asked.)~~
   **Closed (SEED-115, 2026-08-14, Rule K1) by SEED-89 Theorem LC(4)**: a
   grading of `f` with a *finite* record alphabet exists iff `D_f` is finite;
   `v_p` is surjective onto `\mathbb Z_{\ge0}`, which is infinite, so no finite
   quotient makes `e` well-defined. The ground is the **cardinality** of `D_f`,
   not its non-compactness — see the correction applied at
   `notes/SEED80_KERNEL_VERSUS_CONDITIONING.md` §8 item 5, which proposed to
   close this item from Proposition 1(4)'s non-compact branch and cannot: the
   discrete group `\mathbb Z` is non-compact and yet has finite quotients
   `\mathbb Z/n`. LC(4) also supplies the constructive complement this item did
   not ask for (§2(b) annotation (ii) above).
