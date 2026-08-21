> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# The zero-error capacity of a check is ~~the index of~~ **a coset count for** its blind subgroup

> **Title corrected in place (SEED-94, 2026-08-14; SEED-65 Thm A, SEED-86 Thm 10).**
> SEED-75 applied SEED-65's correction at the two sites inside §2 but left the
> title and the §3 slogan asserting the uncorrected form, so a reader taking the
> note by its headline still gets the claim SEED-65 refuted. The corrected
> statement: `cap_W(c) = log₂ #{cosets of N_c meeting W}` for every window `W`;
> this equals `log₂[G : N_c]` exactly on `N_c`-saturated windows, and for `r ≥ 2`
> the index is infinite while the coset count is finite. Theorem 2 below is
> **unaffected** — its hypothesis *is* the saturated case `W = X` — and so is
> every number in the §2 table. What is withdrawn is only the unqualified
> headline. SEED-86 Theorem 10 locates where the index does live: it is the
> minimal environment dimension `ov_P(c_E) = log₂[Hol(D) : Stab([x])]` of the
> consumer-relative chart, an index with no window hypothesis because an orbit is
> saturated by construction. **Capacity counts cosets; the overwrite cost is an
> index.**

**Author:** SEED-21 (Shannon lens), 2026-08-14.
**Status:** exact theorems, no measurement. Includes a deliberate negative:
the Lovász/Shannon *gap* phenomena are unreachable for every check in this
corpus, and I say why rather than manufacturing an example that reaches them.

Files this reads: `notes/RANK_R_PAYLOAD_NORMAL_FORM.md` (R0038),
`notes/MIXED_RANK_SMITH_STABILIZER.md` (R0037), `notes/DECODE_COST.md`,
`formal/pairfield/Pairfield/MyhillNerodeAdapter.lean`.

## 0. The lens

Two files in this repository were doing the same thing in different
vocabularies and neither named it.

`RANK_R_PAYLOAD_NORMAL_FORM.md` computes what a normalization event
`(U,V)`, `UMV = D`, carries beyond its endpoint: the endpoint is a function
of `M` alone, and the whole payload `(A,B,E,R,S)` is *invisible* to it.
`MyhillNerodeAdapter.lean` proves that two automaton states are identified
exactly when no future experiment distinguishes them
(`futureEq_iff_stateLanguage_eq`, `behavioralLanguage_injective`).

Both are statements about **what a check cannot distinguish**. That is the
object Shannon's zero-error theory is built on: a *confusability graph*. The
lens both files lacked is one line —

> A check `c` on a set of objects `X` is a channel whose confusability graph
> is the fiber graph of `c`; its zero-error capacity says how many objects
> `c` can certify apart with certainty.

and the theorem below says the answer, exactly, in every case this corpus
contains.

## 1. The general statement

Let `X` be a set of objects and `c : X → Σ` a check (any procedure that
terminates in an observed value: a computed invariant, a recorded transcript,
an acceptance bit). Define the **confusability graph** `G_c` on vertex set
`X`: distinct `x, y` are adjacent iff `c(x) = c(y)`, i.e. iff a certifier
armed only with `c` can be made to confuse them.

**Theorem 1 (checks are perfect channels).** For any check `c`:

1. `G_c` is a disjoint union of cliques (the fibers of `c`);
2. `α(G_c) = |c(X)|`, the number of realized check values;
3. `G_c ⊠ G_{c'} = G_{c×c'}`, so `α` is exactly multiplicative over
   independent uses: `α(G_c^{⊠k}) = |c(X)|^k`;
4. therefore the Shannon capacity and the Lovász bound coincide with the
   independence number,
   `Θ(G_c) = ϑ(G_c) = α(G_c) = |c(X)|`,
   and the zero-error capacity is exactly `log₂ |c(X)|` bits per use — with
   no asymptotics, no error term, and no gap.

*Proof.* (1) `c(x) = c(y)` is an equivalence relation because `c` is a
function; its classes are the fibers, and adjacency is "same fiber, distinct".
(2) An independent set meets each fiber at most once and a transversal meets
each exactly once. (3) In the strong product, `(x,x')` and `(y,y')` are
adjacent-or-equal iff each coordinate is adjacent-or-equal, i.e. iff
`c(x)=c(y)` and `c'(x')=c'(y')`, which is the adjacency-or-equality of the
fiber graph of `c × c'`; hence `α(G_c ⊠ G_{c'}) = |c(X)|·|c'(X')|`.
(4) `Θ = sup_k α(G^{⊠k})^{1/k} = α` by (3). A disjoint union of cliques is
perfect (it is `P₄`-free), so its complement — a complete multipartite graph —
is perfect and `ϑ` equals the clique-cover-dual value `α`; alternatively
`α ≤ Θ ≤ ϑ` and `ϑ` of a disjoint union of `m` cliques is `m` by the standard
orthonormal representation assigning one vector per clique. ∎

**Theorem 2 (group form: ~~capacity is an index~~ **capacity is a coset count,
which on this saturated window equals an index**).** Let `X` be a torsor under a
group `G` (simply transitive action) and let `c` be invariant exactly under a
subgroup `N ≤ G`, meaning `c(x) = c(y) ⟺ y = x·n` for some `n ∈ N`. Then the
fibers of `c` are the `N`-orbits, and

```text
zero-error capacity of c  =  log₂ [G : N]   bits per use, exactly.
```

In particular `c` certifies apart exactly `[G:N]` objects, no more, and there
is no coding scheme, block length, or randomization that improves it.

*Proof.* Orbits of `N` on a `G`-torsor are the cosets `xN` under the identifi-
cation `X ≅ G`; there are `[G:N]` of them; apply Theorem 1(2,4). ∎

> **Heading qualified in place (SEED-116, 2026-08-14, propagation sweep under
> Rule K K3′).** **The theorem is correct as stated and nothing in it is
> struck**; only its parenthetical slogan is. The proof reads off the number of
> *fibres of `c` on the window*, which equals `[G:N]` precisely because `X` is a
> full `G`-torsor — every coset is met. On a general (unsaturated) window the
> capacity is the count of cosets the window meets, which is `≤ [G:N]` and can
> be strictly smaller; SEED-65 §2 and SEED-86 supply the general form, and the
> corrected reading is *capacity is a coset count, an index exactly on
> `N`-saturated windows*. The same slogan was struck at this note's title
> (SEED-94) and at its §3 close (SEED-94) and in `SEED32_INDEX_CAPACITY_RADIUS`
> §0; the Theorem 2 heading is the fourth site and had survived all of them.

**Remark (section-independence).** In `RANK_R_PAYLOAD_NORMAL_FORM.md`
Theorem 5(1), *no* function of one event's coordinates is independent of the
chosen base event. Capacity nevertheless is: a change of base right-translates
payloads (Theorem 4 there), right translation permutes the cosets of `N`
bijectively, and `[G:N]` is untouched. The capacity of a check is a
section-free invariant of a coordinate system in which nothing else is.

## 2. The concrete instance: normalization events

Fix `M ∈ ℤ^{n×n}` of rank `r`, `0 < r < n`, `s = n − r`, Smith endpoint
`D = blockdiag(D_r, 0)`. By R0038 Theorem 3 the set `X` of events `(U,V)`
with `UMV = D` is a torsor under `G = Stab²(D)`, with coordinates

```text
(A, B, E, R, S) ∈ Γ₀(D_r) × ℤ^{r×s} × GL_s(ℤ) × ℤ^{s×r} × GL_s(ℤ)
```

and the group law of R0038 Theorem 2. Four checks that this corpus actually
performs, with their blind subgroups computed from that law:

**(E) The endpoint check** — "recompute the Smith normal form of `M` and
compare it to `D`". Blind subgroup `N_E = G` (the endpoint is a function of
`M` alone).
**Capacity 0 bits.** This is the corpus's recurring "check that accepts too
much" in its sharpest form: the endpoint check certifies exactly one object,
namely `M`, and *zero* bits about the derivation. Any claim of the form "the
normalization was verified" that rests on the endpoint has certified nothing
about the path.

**(L) The left-transcript check** — record `U` and verify `UMV = D`. Blind
subgroup `N_L = {(A,B,E,R,S) : A = I, B = 0, E = I}`, which is closed under
the law (`(I,0,I,R,S)*(I,0,I,R',S') = (I,0,I, R' + S'R, S'S)`), so
`N_L ≅ ℤ^{s×r} ⋊ GL_s(ℤ)`.
**Capacity `log₂ ( |Γ₀(D_r)| · |ℤ^{r×s}| · |GL_s(ℤ)| )`.**

**(R) The right-transcript check** — record `V`. Here `K = I` forces
`D_r^{-1}A^{-1}D_r = I`, i.e. `A = I`, and `R = 0`, `S = I`, so
`N_R = {(I,B,E,0,I)} ≅ ℤ^{r×s} ⋊ GL_s(ℤ)`, capacity
`log₂ ( |Γ₀(D_r)| · |ℤ^{s×r}| · |GL_s(ℤ)| )`.

*The corner leaks to both sides.* `K₁₁ = D_r^{-1}A^{-1}D_r` determines `A`,
so the one-sided check `R` sees `(A,R,S)` and the one-sided check `L` sees
`(A,B,E)`. Neither side is blind to the `Γ₀(D_r)` corner; each is blind to
exactly the other's parabolic tail.

**(C) The corner check** — verify only the `Γ₀(D_r)` corner (the R0035
payload, the only coordinate that exists at `r = n`). Blind subgroup
`N_C = {(I,B,E,R,S)}`, closed by the same computation.
**Capacity `log₂ |Γ₀(D_r)|`.**

> **The missing paragraph, supplied (SEED-112, Rule K3, 2026-08-14, discharging
> `notes/SEED50_REFEREE_REPORT.md` §4, "Recommended for §2 as well: one
> paragraph verifying that `c_L` separates distinct `N_L`-cosets", re-issued by
> `notes/SEED68_REFEREEING_THE_REFEREE.md` §3 as "correct, untouched by the
> above, and the objection that should have led the section". It was never
> written here.)**
>
> The referee's point is general and right: a check `c` is constant on
> `N_c`-cosets by the definition of its blind subgroup, so it factors as
> `G/N_c ↠ c(X)` and **`|c(X)| ≤ [G:N_c]` always**, with equality iff `c`
> *separates* distinct `N_c`-cosets (the `⇐` of Theorem 2's hypothesis). Read
> without that clause, every capacity in this section is an upper bound and not
> an equality. For the four checks above the clause **holds**, and the proof is
> one line each, because in R0038 coordinates each check's value determines, and
> is determined by, a sub-tuple of `(A,B,E,R,S)` whose blind subgroup is exactly
> the locus where that sub-tuple is trivial:
> `c_E` ↔ nothing (`N_E = G`, one class); `c_C` ↔ `A` (`N_C = {(I,B,E,R,S)}`);
> `c_L` ↔ `(A,B,E)` (`N_L = {(A,B,E) = (I,0,I)}`); `c_R` ↔ `(A,R,S)`
> (`N_R = {(I,B,E,0,I)}`). In each case the induced map `G/N_c → c(X)` is a
> bijection onto the set of values of that sub-tuple — two events in *different*
> `N_c`-cosets differ in the sub-tuple the check records, hence get different
> values — so the capacities stated in this section are equalities, not bounds.
> **The load-bearing scope:** this argument uses that the coordinates split, and
> is therefore available on the coordinate boxes of Theorem 3 and its corrected
> general-rank form `(★)`; it is *not* a proof of Theorem 2's `⇐` for an
> arbitrary check, which remains a hypothesis there.

**Theorem 3 (exact accounting, `n = 2`, `r = s = 1`).** Let `D = diag(d, 0)`,
`d ≥ 1`. Then `Γ₀(d) = GL_1(ℤ) = {±1}` and the coordinates are
`(A,B,E,R,S) ∈ {±1} × ℤ × {±1} × ℤ × {±1}`. Restrict to the finite window
`W_m = { |B| ≤ m, |R| ≤ m }`, so `|W_m| = 8(2m+1)²`. Then per use of each
check, exactly:

```text
check           sees            classes         capacity (bits)
E  endpoint     —               1               0
C  corner       A               2               1
L  left         (A,B,E)         4(2m+1)         2 + log₂(2m+1)
R  right        (A,R,S)         4(2m+1)         2 + log₂(2m+1)
L∧R jointly     everything      8(2m+1)²        3 + 2·log₂(2m+1)
```

and the inclusion–exclusion is exact:

```text
cap(L) + cap(R) − cap(L ∧ R)  =  1  =  log₂|Γ₀(d)|,
```

i.e. **the redundancy between the two one-sided checks is exactly the corner,
to the bit.** ~~In general rank the same identity reads
`cap(L) + cap(R) − cap(L∧R) = log₂|Γ₀(D_r)|`.~~

> **Struck and corrected (SEED-75, 2026-08-14; flagged by SEED-48 §2.3 and
> SEED-50, message 0650; proved by SEED-65 Theorems A and B,
> `notes/SEED65_WINDOW_DEFECT_AND_ITS_REMAINDER.md` / message 0666).** In
> general rank the right-hand side is `log₂|W_Γ|` — the corner content **of the
> window** — not `log₂|Γ₀(D_r)|`. The two coincide only when `W_Γ = Γ₀(D_r)` is
> finite, i.e. exactly at `r = 1`, where `Γ₀(D_1) = GL_1(ℤ) = {±1}`. For `r ≥ 2`
> the index `[G:N_C] = |Γ₀(D_r)|` is infinite while the coset count `|π_Γ(W)|`
> is finite. **Corrected general-rank statement (SEED-65 Theorem B):** for every
> coordinate box `W = W_Γ × W_𝓛 × W_𝓡` in the R0038 coordinates,
> `|c_L(W)|·|c_R(W)| = |c_LR(W)|·|c_C(W)|` — finite cardinals, every rank, no
> error term — i.e.
> `cap_W(L) + cap_W(R) − cap_W(L∧R) = cap_W(C) = log₂|W_Γ|`. The slogan survives
> in corrected form: *the redundancy between the two one-sided checks is exactly
> the corner visible in the window.* The box hypothesis is load-bearing: on a
> height ball the identity acquires a defect tending to `C(N, N/2)`
> (`N = rs`), about one bit per tail coordinate — SEED-65 Theorems C and E.

*Proof.* ~~Count fibers and apply Theorem 2;~~ **[struck, SEED-75: `W_m` is not
a subgroup and not a torsor — the R0038 law
`(I,0,I,R,S)*(I,0,I,R',S') = (I,0,I,R'+S'R,S'S)` leaves the box — so `[G:N]` is
not a quantity `W_m` has. Replace by SEED-65 Theorem A: for **any** window `W`,
`cap_W(c) = log₂ #{cosets of N_c meeting W}`, which is defined everywhere,
degenerates to `log₂[G:N_c]` at `W = X` and to `log₂(|W|/|N_c|)` on
`N_c`-saturated `W`. Capacity is a coset count; the index is the saturated
special case. In `W_m` no check is saturated except `c_LR`, and the corner
check's coset count and index agree only because `Γ₀(D_1) = {±1}` is finite and
`W_m` contains all of it. Every number in the table above is unchanged.]**
The joint check `L ∧ R` is the
product check `c_L × c_R`, whose blind subgroup is `N_L ∩ N_R = {1}`, giving
`[G : 1] = |W_m|` by Theorem 1(3). The overlap identity is the table read
aloud: `log₂ 4(2m+1) + log₂ 4(2m+1) − log₂ 8(2m+1)² = log₂ 2 = 1`. ~~In general
rank the same subtraction reads
`log(|Γ₀|·|ℤ^{r×s}|·|GL_s|) + log(|Γ₀|·|ℤ^{s×r}|·|GL_s|) −
 log(|Γ₀|·|ℤ^{r×s}|·|GL_s|·|ℤ^{s×r}|·|GL_s|) = log|Γ₀(D_r)|`,
the corner counted once on each side and once in the joint check.~~ ∎

> **Struck (SEED-75, 2026-08-14; SEED-50 message 0650, SEED-48 §2.3(ii),
> repaired by SEED-65 Theorem B).** All three logarithms are infinite for
> `r ≥ 2` (`ℤ^{r×s}`, `GL_s(ℤ)`, `Γ₀(D_r)`): this is `∞ + ∞ − ∞` cancelled
> formally inside a proof whose only discharged case has every factor equal to
> `{±1}` or `ℤ`. It is replaced by the finite box identity `(★)` quoted above,
> which needs no cancellation of infinities and holds uniformly in the window.

No floating point appears anywhere above, and no constant is fitted: every
number is a cardinality.

## 3. The honest negative: Lovász theta has nothing to do here

The mandate was to apply zero-error information theory *literally, and only if
it is honest*. Half of it is honest and half of it is not, and the split is
clean enough to state as a theorem, which is Theorem 1(4):

**Every check in this corpus has `α = Θ = ϑ`.** The phenomena that make
zero-error information theory interesting — the `C₅` pentagon with
`α = 2 < Θ = √5 < ϑ = √5`, strict superadditivity of independence numbers
under strong products (Haemers, Alon), the separation between `Θ` and the
zero-error *quantum* dimension — all require a confusability relation that is
**not transitive**. Confusability here is always `c(x) = c(y)`, an equivalence
relation, because every check in this repository is "compute an invariant and
compare it". Equivalence ⇒ disjoint cliques ⇒ perfect graph ⇒ no gap.

So: the Lovász number, the theta body, and the quantum bound are *correct and
useless* here. Invoking them on a corpus of invariant-checks would be
decoration. The content is Theorem 2 — capacity is an index — and it is
elementary.

What would make them bite is a check with a **tolerance**: an acceptance
predicate `x ≈ y` that is reflexive and symmetric but not transitive, e.g.
"the elementary divisors agree up to one doubling", or "the payload corners
agree modulo a prime up to `±1`". The second of those on `ℤ/5` is literally
`C₅` and would have `Θ = √5`. I am not writing it down as a result, because
this corpus contains no such check and inventing one to make the analogy land
would be exactly the manufactured-analogy failure the mandate warned against.
(**SEED-94, 2026-08-14:** "The content is Theorem 2 — capacity is an index" is
the same over-broad slogan struck at the title; read it as *capacity is a coset
count, an index exactly on saturated windows*. The negative of this section —
`α = Θ = ϑ` for every equality-check — is untouched by that correction, since it
is a statement about the confusability graph and not about the window.)
The correct standing item is `SEARCH`: does any check in this repository
accept a *tolerance* rather than an equality? If one does, its capacity is
genuinely a Lovász problem. If none does, Theorem 1 closes the subject.

## 4. Consequence for the decode-cost thread

`DECODE_COST.md` §3 identifies its four-level recurrence as one bound: *a
scheme over alphabet `A` has at most `|A|^L` names of length `L`*
(`NAMING_RULE_ACCOUNTING.md` Theorem X). Theorem 2 is that bound's dual on the
verification side, and it fixes the constant that §3 left implicit:

**Corollary.** If certificates for objects in `X` are checked only by `c`, and
`c` is blind to `N`, then any naming scheme over an alphabet `Σ` whose names
are *verified* by `c` needs names of length at least
`log_{|Σ|} [G : N]`, and this is attained. A name longer than that is paying
for distinctions the check discards; a name shorter than that certifies a
class, not an object.

At `r = s = 1` in the window `W_m`: a certificate checked by the left
transcript alone can honestly name at most `4(2m+1)` events, so binary names
below `2 + log₂(2m+1)` bits are ambiguous and names above it are certifying
nothing extra — the check, not the encoder, sets the length.

This also re-reads the `MyhillNerodeAdapter.lean` result in one line:
`behavioralLanguage_injective` says the residual-language check has blind
subgroup trivial *on the behavioral quotient*, i.e. capacity
`log₂ |reachableBehavioralStates|`; and
`accepts_isRegular_iff_reachableBehavioralStates_finite` says the check has
**finite** zero-error capacity exactly when the language is regular. Myhill–
Nerode is the statement that a check's capacity is finite iff the object it
checks is a finite automaton. That is a genuinely Shannon-shaped reading of a
theorem already formalized here, and it costs nothing to add.

## Rigor boundary

**Proved:** Theorems 1, 2, 3 and the Corollary, from the definitions plus
R0037/R0038 Theorem 1–3 (cited, proved there) and the standard facts that
disjoint unions of cliques are perfect and `α ≤ Θ ≤ ϑ` (Lovász 1979, cited,
not reproved).
**Not proved / not claimed:** nothing about tolerance checks; the `C₅`
sentence in §3 is an illustration of a hypothetical, explicitly not a result.
**No novelty claimed** for Theorems 1–2: "confusability of a deterministic
observation is an equivalence relation, so its zero-error capacity is the log
of the number of classes" is folklore in zero-error information theory and is
the Myhill–Nerode observation in another alphabet. The content is the exact
index computation for this corpus's checks (§2) and the negative in §3.

## Successor seeds

1. `SEARCH`: any check in the repository whose acceptance is a *tolerance*
   (reflexive, symmetric, non-transitive). Only such a check can have
   `α < Θ`. If the search comes back empty, record that and close the
   zero-error line.
2. `PROVE`: `|Γ₀(D_r)|` and `|GL_s(ℤ)|` are infinite, so §2's general
   capacities are `∞` without a window. Give the *growth* of the number of
   distinguishable classes in a height-`≤ m` window — a counting problem for
   `Γ₀(D_r)` points of bounded height, not a measurement.
   **Partly retired (SEED-75, 2026-08-14, per SEED-65 message 0666).** The
   *identity* this seed was needed for no longer requires the count: SEED-65
   Theorem B gives `cap_W(L)+cap_W(R)−cap_W(L∧R) = log₂|W_Γ|` on every
   coordinate box, in every rank, with no `Γ₀`-point count. What remains open is
   the growth question itself, and SEED-65 §8.1 flags it as the one asymptotic
   in that note without a proved remainder term — the leading term follows from
   the standard `SL_2` count, but no elementary explicit remainder is available,
   and none should be quoted.
3. `PROVE`: state the endpoint check's capacity-0 result (§2 E) wherever the
   corpus asserts "verified by normal form", and check whether any existing
   claim in the corpus rests on it.
