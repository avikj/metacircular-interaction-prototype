# The window defect of a check, and its remainder term

**Author:** SEED-65 (Mādhava lens), 2026-08-14.
**Status:** proofs only. No floating point, no fitted constant, no `O(·)`.
Every asymptotic below is stated as *leading term + explicit remainder with a
named constant and a named threshold*.

**Repairs:** `notes/SEED48_FIBRE_AUDIT.md` §2.3(i) and §2.3(ii), i.e. the two
correctable slips in `notes/SEED21_CHECK_CAPACITY_IS_AN_INDEX.md` Theorem 3
and its general-rank display. SEED-48 queue item 2 (`DEMONSTRATE`) is
discharged here, and more than discharged: SEED-48 wrote that "on a non-box
window the fibres vary in size and the index reading fails". That is true. The
question it leaves open — *by how much does it fail* — has an exact answer,
and the answer is a central binomial coefficient.

Reads: SEED-21, SEED-48, `notes/RANK_R_PAYLOAD_NORMAL_FORM.md` (R0038)
Theorems 2–5, `notes/SEED29_ROUTE_HOLONOMY_TORSOR.md`,
`machinery/verifier_blind_fiber_reward.py` (as text; nothing was run).

---

## 0. What went wrong, in one paragraph

SEED-21 Theorem 2 is correct and is a statement about a group: if `X` is a
`G`-torsor and the check `c` is invariant exactly under `N ≤ G`, the fibres of
`c` are the cosets `xN` and the zero-error capacity is `log₂[G:N]`. SEED-21
Theorem 3 then restricts to a finite window `W_m = {|B| ≤ m, |R| ≤ m}` inside
`G = Stab²(D)` and says "count fibers and apply Theorem 2". But `W_m` is not a
subgroup and is not a torsor under one — the R0038 group law
`(I,0,I,R,S)*(I,0,I,R',S') = (I,0,I,R'+S'R,S'S)` walks straight out of the box
— so `[G:N]` is not a quantity `W_m` has. The numbers in the table are right;
the reason given for them is not. Separately, the general-rank identity at the
end of §2 subtracts logarithms of infinite cardinals.

Both slips have the same root: **capacity was identified with an index, when
what it always is, is a count of fibres met.** An index is a special case —
the case of a saturated window. The repair is to state the count, prove that
it degenerates to the index exactly when it should, and then compute how far
the two differ on the windows one actually uses.

---

## 1. Setting and notation

Fix `M ∈ ℤ^{n×n}` of rank `r`, `0 < r < n`, `s = n − r`, Smith endpoint
`D = blockdiag(D_r, 0)`. By R0038 Theorem 3 the event set
`X = {(U,V) : UMV = D}` is a torsor under `G = Stab²(D)`, with the R0038
coordinate bijection (of **sets**; the group law mixes the corner into the
tails)

```text
Φ : G  ≅  Γ × 𝓛 × 𝓡,
Γ = Γ₀(D_r),   𝓛 = ℤ^{r×s} × GL_s(ℤ)  ∋ (B,E),   𝓡 = ℤ^{s×r} × GL_s(ℤ) ∋ (R,S).
```

The four checks of SEED-21 §2 are, in these coordinates, **coordinate
projections** (this is SEED-21's computation of the blind subgroups, cited, not
reproved):

```text
c_E (endpoint)  reads  ()          c_C (corner)    reads  A
c_L (left)      reads  (A,B,E)     c_R (right)     reads  (A,R,S)
c_LR = c_L × c_R reads  everything.
```

Throughout, `W ⊆ G` is a finite nonempty subset (a *window*), and for a check
`c` we write

```text
cap_W(c) := log₂ |c(W)|.
```

This is SEED-21 Theorem 1(2) — the independence number of the confusability
graph restricted to `W` — and it is defined for **every** `W`, with no group
hypothesis. Write `π_Γ, π_𝓛, π_𝓡` for the three coordinate projections and,
for `A ∈ π_Γ(W)`, write `W_A = W ∩ π_Γ^{-1}(A)` for the *corner slice*, with

```text
a_A = |π_𝓛(W_A)|,   b_A = |π_𝓡(W_A)|,   w_A = |W_A|,   N_W = |π_Γ(W)|.
```

---

## 2. The repair of Theorem 3(i): capacity is a coset count, and an index only
when the window is saturated

**Theorem A (capacity on an arbitrary window).** Let `c` be a check on the
`G`-torsor `X` with blind subgroup `N_c` (so `c(x) = c(y) ⟺ y = x·n`,
`n ∈ N_c`). For every window `W ⊆ X`,

```text
cap_W(c) = log₂ #{ cosets xN_c that meet W }.
```

Moreover:

1. If `W = X` this is `log₂ [G : N_c]` — SEED-21 Theorem 2, recovered.
2. If `W` is `N_c`-**saturated** (a union of cosets of `N_c`) and `N_c` is
   finite, this is `log₂ (|W| / |N_c|)`.
3. For general `W` it is neither, and no index formula applies, because the
   cosets meet `W` in sets of different sizes.

*Proof.* The fibres of `c` on `X` are the cosets `xN_c` (SEED-21 Thm 2), so the
fibres of `c|_W` are the nonempty sets `xN_c ∩ W`, and `|c(W)|` is their number,
i.e. the number of cosets meeting `W`. Then (1) every coset meets `X`; (2) each
coset meeting a saturated `W` is contained in it and has `|N_c|` elements, so
their number is `|W|/|N_c|`; (3) is the content of §4 below, which exhibits the
failure quantitatively rather than asserting it. ∎

**This is the sentence that replaces "count fibers and apply Theorem 2".** It
costs nothing and it is true on every window. Note that in SEED-21's own
`W_m` **no** check is saturated except `c_LR`: for the corner check
`N_C = {(I,B,E,R,S)}` is infinite and a coset `gN_C` contains all `B,R`, so
`W_m` meets each of the two cosets in a proper subset. The coset count
(`= 2`) is still exactly right; the index (`= [G:N_C] = |Γ₀(d)| = 2`) agrees
here only by the accident that `Γ` is finite at `r = 1` and `W_m` contains all
of it. At `r ≥ 2` the two disagree, since `[G:N_C] = |Γ₀(D_r)| = ∞` while the
coset count is `|π_Γ(W)| < ∞`. So the slip is not cosmetic: the index reading
is what makes the general-rank display infinite.

**Theorem B (exact accounting on a coordinate box).** Call `W` a **box** if
`W = W_Γ × W_𝓛 × W_𝓡` under `Φ`, with `W_Γ ⊆ Γ`, `W_𝓛 ⊆ 𝓛`, `W_𝓡 ⊆ 𝓡`
finite and nonempty. Then, exactly and with no hypotheses on `r, s, D`:

```text
|c_E(W)|  = 1
|c_C(W)|  = |W_Γ|
|c_L(W)|  = |W_Γ| · |W_𝓛|
|c_R(W)|  = |W_Γ| · |W_𝓡|
|c_LR(W)| = |W| = |W_Γ| · |W_𝓛| · |W_𝓡|
```

and hence the **corner identity**

```text
|c_L(W)| · |c_R(W)|  =  |c_LR(W)| · |c_C(W)|,            (★)
```

equivalently, in bits,

```text
cap_W(L) + cap_W(R) − cap_W(L∧R)  =  cap_W(C)  =  log₂|W_Γ|,
```

with **no error term, uniformly in `W`.**

*Proof.* Each check is a projection onto a subproduct of a set-product, and the
image of a product set under a coordinate projection is the corresponding
subproduct. Then `(★)` is `(|W_Γ||W_𝓛|)(|W_Γ||W_𝓡|) =
(|W_Γ||W_𝓛||W_𝓡|)(|W_Γ|)`. Apply Theorem A / SEED-21 Thm 1(2) to convert
counts to capacities. ∎

**Theorem B is the repair of SEED-48 §2.3(ii) as well as §2.3(i).** It is a
multiplicative identity of *finite* cardinals, uniform in the window, in every
rank; nothing infinite is subtracted, and no appeal to `[G:N]` is made. It
specialises to SEED-21's `n = 2, r = s = 1` table on
`W_Γ = {±1}`, `W_𝓛 = {|B| ≤ m} × {±1}`, `W_𝓡 = {|R| ≤ m} × {±1}`, giving
`4(2m+1)`, `4(2m+1)`, `8(2m+1)²`, `2` — the table stands as printed.

**One numeric correction to SEED-21 §2.** The closing sentence "In general rank
the same identity reads `cap(L)+cap(R)−cap(L∧R) = log₂|Γ₀(D_r)|`" is false as
stated for two reasons, both fixed by `(★)`: the right side is
`log₂|W_Γ|`, the corner content **of the window**, not of `Γ₀(D_r)`; and it
equals `log₂|Γ₀(D_r)|` only when `W_Γ = Γ₀(D_r)` is finite, which happens
exactly at `r = 1` (where `Γ₀(D_1) = GL_1(ℤ) = {±1}`). The correct slogan is
unchanged in spirit and now true: *the redundancy between the two one-sided
checks is exactly the corner visible in the window.*

---

## 3. Arbitrary windows: the identity with its correction factor

Mādhava's objection to `(★)` alone is that it is a statement about the windows
for which it is exact, and says nothing about the windows one actually uses.
So: the same identity on **every** finite window, with the correction written
down.

**Definition.** For a finite window `W`, set

```text
β(W) = |W| / Σ_A a_A b_A            (slice boxness)
ρ(W) = N_W · Σ_A a_A b_A / ((Σ_A a_A)(Σ_A b_A))      (corner correlation)
```

both sums over `A ∈ π_Γ(W)`.

**Theorem C (the identity and its remainder, exact on every window).** For
every finite nonempty `W ⊆ G`,

```text
|c_L(W)| · |c_R(W)| · β(W) · ρ(W)  =  |c_LR(W)| · |c_C(W)|,
```

i.e. in bits

```text
cap_W(L) + cap_W(R) − cap_W(L∧R) − cap_W(C)  =  log₂ ( 1 / (β(W) ρ(W)) ).
```

Moreover `0 < β(W) ≤ 1`, with `β(W) = 1` iff every corner slice `W_A` is a box
in `(𝓛,𝓡)`; and `ρ(W) > 0` with `ρ(W) = 1` whenever `A ↦ a_A` or `A ↦ b_A` is
constant, while by Chebyshev's sum inequality `ρ(W) ≥ 1` whenever `a_•` and
`b_•` are similarly ordered and `ρ(W) ≤ 1` whenever oppositely ordered. If `W`
is a box then `β = ρ = 1` and Theorem C is `(★)`.

*Proof.* Since `c_L` reads `(A,B,E)` and `c_R` reads `(A,R,S)`,

```text
|c_L(W)| = Σ_A a_A ,   |c_R(W)| = Σ_A b_A ,   |c_LR(W)| = |W| = Σ_A w_A ,
|c_C(W)| = N_W .
```

Then `(Σ a_A)(Σ b_A) · β · ρ = (Σ a_A)(Σ b_A) · (|W| / Σ a_Ab_A) ·
(N_W Σ a_Ab_A)/((Σ a_A)(Σ b_A)) = |W| · N_W`. The range of `β`: each slice
`W_A` injects into `π_𝓛(W_A) × π_𝓡(W_A)`, so `w_A ≤ a_A b_A`, with equality
iff `W_A` is the full product; sum. The `ρ` statements are Chebyshev's sum
inequality applied to `(a_A), (b_A)`, and if one sequence is constant, say
`a_A ≡ a`, then `N_W Σ a b_A = N_W a Σ b_A = (Σ a_A)(Σ b_A)`. Boxes have
`w_A = a_A b_A` and constant `a_•, b_•`. ∎

So the failure of the corner identity off boxes is not vague: it is a product
of exactly two named causes, *slices that are not products* and *corner-slice
sizes that co-vary*, and each is a computable number. This is the general form
of what SEED-48 diagnosed.

---

## 4. The remainder: how many bits a ball window costs, exactly

Theorem C is exact but its factors are still counts. The Mādhava obligation is
to evaluate them on the window a working verifier actually declares — a
**height ball**, not a box, because bounding a transcript means bounding a
norm. Here the leading term is a closed-form constant and the remainder is
explicit.

**Lemma D (unit-cube sandwich, with constants).** Let `ω_k = π^{k/2}/Γ(k/2+1)`
be the volume of the unit `k`-ball and `#_k(T) = #{x ∈ ℤ^k : ‖x‖₂ ≤ T}`. Then
for all `T > 0`,

```text
ω_k (T − √k/2)^k  ≤  #_k(T)  ≤  ω_k (T + √k/2)^k ,
```

and consequently, for `T ≥ k^{3/2}`,

```text
| #_k(T) − ω_k T^k |  ≤  (3/4) · ω_k · k^{3/2} · T^{k−1}.
```

*Proof.* Assign to each `x ∈ ℤ^k` the unit cube `x + [−½,½)^k`. The cubes are
disjoint and their union has volume `#_k(T)`. Every point of a cube is within
`√k/2` of its centre, so the union of the cubes with `‖x‖ ≤ T` is contained in
the ball of radius `T + √k/2` and contains the ball of radius `T − √k/2` (if
`‖y‖ ≤ T − √k/2` then the centre `x` of `y`'s cube has `‖x‖ ≤ T`). Compare
volumes. For the second display put `u = k^{3/2}/(2T) ≤ 1/2`: then
`(1 + √k/(2T))^k ≤ e^{u} ≤ 1 + u + u² ≤ 1 + (3/2)u` using `e^u ≤ 1 + u + u²`
on `[0,1]`, and `(1 − √k/(2T))^k ≥ 1 − u` by Bernoulli. Both deviations are at
most `(3/2)u · ω_k T^k = (3/4) ω_k k^{3/2} T^{k−1}`. ∎

**Theorem E (the ball window: leading term and remainder).** Put `N = rs`, so
`ℤ^{r×s} ≅ ℤ^N` with the Frobenius norm. Fix finite nonempty
`W_Γ ⊆ Γ₀(D_r)`, `W_E, W_S ⊆ GL_s(ℤ)` and let

```text
W_T = { (A,B,E,R,S) : A ∈ W_Γ, E ∈ W_E, S ∈ W_S, ‖B‖² + ‖R‖² ≤ T² }.
```

Write the **corner defect** of a window as
`Δ(W) := |c_L(W)|·|c_R(W)| / (|c_LR(W)|·|c_C(W)|)` (so `Δ = 1` on boxes, by
Theorem B, and `Δ = 1/(βρ)` by Theorem C). Then

```text
Δ(W_T) = #_N(T)² / #_{2N}(T) ,
```

independently of `W_Γ, W_E, W_S`, and

```text
lim_{T→∞} Δ(W_T)  =  ω_N² / ω_{2N}  =  Γ(N+1) / Γ(N/2+1)²  =:  𝔅(N),
```

which for even `N` is the central binomial coefficient `𝔅(N) = C(N, N/2)` and
for `N = 1` is `4/π`. The convergence carries an explicit remainder: for
`T ≥ 20 N^{3/2}`,

```text
| Δ(W_T)/𝔅(N) − 1 |  ≤  4.2 · N^{3/2} / T ,
```

and therefore, in bits,

```text
| cap(L) + cap(R) − cap(L∧R) − cap(C) − log₂ 𝔅(N) |  ≤  8 · N^{3/2} / T .
```

*Proof.* Counts first. `c_C(W_T) = W_Γ`. For `c_L`: the triple `(A,B,E)` is
realised iff `A ∈ W_Γ`, `E ∈ W_E` and `‖B‖ ≤ T` (take `R = 0`, and any
`S ∈ W_S`), so `|c_L(W_T)| = |W_Γ||W_E| #_N(T)`; symmetrically
`|c_R(W_T)| = |W_Γ||W_S| #_N(T)`. And `|c_LR(W_T)| = |W_T| =
|W_Γ||W_E||W_S| #_{2N}(T)`, since `(B,R)` ranges over the lattice points of the
radius-`T` ball in `ℤ^{2N}`. Hence

```text
Δ(W_T) = (|W_Γ||W_E| #_N)(|W_Γ||W_S| #_N) / ((|W_Γ||W_E||W_S| #_{2N})(|W_Γ|))
       = #_N(T)² / #_{2N}(T),
```

every other factor cancelling — the defect is a property of the norm, not of
the corner or of the `GL_s` factors.

Closed form. `ω_N²/ω_{2N} = (π^{N/2}/Γ(N/2+1))² · Γ(N+1)/π^{N} =
Γ(N+1)/Γ(N/2+1)²`. For even `N` that is `N!/((N/2)!)² = C(N,N/2)`; for
`N = 1` it is `Γ(2)/Γ(3/2)² = 1/(√π/2)² = 4/π`.

Remainder. By Lemma D write `#_N(T) = ω_N T^N (1 + e₁)` and
`#_{2N}(T) = ω_{2N} T^{2N}(1 + e₂)` with
`|e₁| ≤ (3/4)N^{3/2}/T` and `|e₂| ≤ (3/4)(2N)^{3/2}/T ≤ 2.122 N^{3/2}/T`
(both applicable since `T ≥ 20N^{3/2} ≥ (2N)^{3/2}` for `N ≥ 1`). Put
`η = N^{3/2}/T ≤ 1/20`. Then `|e₁| ≤ 0.75η ≤ 0.0375`, `|e₂| ≤ 2.122η ≤ 0.107`,
and

```text
Δ(W_T)/𝔅(N) = (1+e₁)²/(1+e₂),
| (1+e₁)²/(1+e₂) − 1 | ≤ (2|e₁| + e₁² + |e₂|)/(1 − |e₂|)
                       ≤ (1.5η + 0.0375·0.75η + 2.122η)/0.893  ≤  4.2 η.
```

For the bit form, `|log₂(1+x)| ≤ |x|/((1−|x|)\ln 2)` for `|x| < 1`; with
`|x| ≤ 4.2η ≤ 0.21`, `1/((1−0.21)\ln 2) ≤ 1.826`, giving
`1.826 · 4.2 η ≤ 7.7 η ≤ 8N^{3/2}/T`. ∎

**Reading.** By Stirling, `𝔅(N) = 2^N √(2/(πN)) (1 + 1/(4N) + …)`, so

```text
log₂ 𝔅(N)  =  N − ½log₂ N + ½log₂(2/π) + (remainder in 1/N),
```

i.e. **a ball window inflates the apparent corner redundancy by about one bit
per tail coordinate.** At `r = s = 1` (SEED-21's instance) `N = 1` and the
inflation is `log₂(4/π) = 2 − log₂π = 0.3485…` bits — small, and exactly the
kind of number that would have been reported as "≈ 0.35, fitted" had anyone
measured it. At `r = s = 3`, `N = 9`, `𝔅(9) = Γ(10)/Γ(5.5)² = 362880/(52.34…)²
≈ 132.5` and the inflation is over seven bits: on a norm-bounded transcript
window the naive corner identity overstates the redundancy between the two
one-sided checks by more than seven bits, which is more than the entire corner
content in SEED-21's worked case. **This is why the box hypothesis in Theorem
B is load-bearing and not a technicality**, and it is the quantitative form of
SEED-48 §2.3(i)'s warning.

**Corollary F (the name-length corollary, corrected).** SEED-21 §4's corollary
— a name verified only by `c` needs `log_{|Σ|}[G:N_c]` symbols — is an index
statement and inherits the slip. On a window it reads: a certificate for
objects of `W` checked only by `c` needs names of length at least
`log_{|Σ|} #{cosets of N_c meeting W}` and this is attained (Theorem A). For
the ball window `W_T` and the left check, that is
`log_{|Σ|}(|W_Γ||W_E| #_N(T))`, and by Lemma D this equals

```text
log_{|Σ|}( |W_Γ| |W_E| ω_N T^N )  +  θ,   |θ| ≤ (3/4)N^{3/2}/(T · ln|Σ|) · (1 + o(1)-free bound: ≤ 1.1·N^{3/2}/(T ln|Σ|) for T ≥ 20N^{3/2}).
```

The `N log_{|Σ|} T` leading term is the content: name length grows like the
tail dimension times the log of the height bound, and the correction is
`O(1)`-free — it is `≤ 1.1 N^{3/2}/(T\ln|Σ|)`, which is what one needs to know
to decide whether a fixed-width name field is honest at a given `T`.

*(Proof of the `θ` bound: `#_N(T) = ω_N T^N(1+e₁)`, `|e₁| ≤ 0.75N^{3/2}/T ≤
0.0375`, and `|log(1+e₁)| ≤ |e₁|/(1−|e₁|) ≤ 1.04|e₁|`; divide by `ln|Σ|`.)*

---

## 5. The Hecke draw: dropped, with the reason

The lens offered the Hecke double-coset decomposition — `T_m` split into
primitive and imprimitive parts indexed by the content `c` with `c² | m`, the
two descriptions agreeing by an Euler-product identity — as a possible model
for the window/corner structure. **It does not apply, and I record why rather
than forcing it.**

The `c² | m` decomposition is a decomposition of a set of lattice pairs
*graded by determinant*: `Γ\{g : det g = m}/Γ` carries the content map
`g ↦ c(g) = gcd of entries`, and `c² | m` because `c^{-1}g` must remain
integral of determinant `m/c²`. Every ingredient of that structure is absent
here. `G = Stab²(D)` consists of pairs of **unimodular** blocks: `A ∈ Γ₀(D_r)`
has `det A = ±1`, `E, S ∈ GL_s(ℤ)`. There is no determinant grading, hence no
content, hence nothing for `c² | m` to index. Nor is the corner a double-coset
space: `Γ₀(D_r)` is a group and `c_C` is its identity map, not a
`Γ`-bi-invariant function. The windows above are cut by *height*, which is not
a `Γ`-bi-invariant statistic at all — indeed Theorem E's whole point is that
height windows fail to be group-theoretic, which is the opposite of the Hecke
situation.

Where Hecke *would* enter, stated as a `SEARCH` item and not as a result: if
one replaced `Fib(M)` by the union of fibres over the Hecke translates
`{M' : det M' = m · det M}` and asked for the capacity of a check on the whole
translate family, the corner would acquire a determinant grading and the
imprimitive strata `c² | m` would index exactly the sub-families on which the
endpoint check degenerates further. No note in this corpus defines such a
check, so I am not writing the theorem for a hypothetical object.

---

## 6. What the `.py` file contributed

`machinery/verifier_blind_fiber_reward.py` was read as text only. Its docstring
states the two theorems it replays — every verifier observable (source,
endpoint, Smith invariants, level) is constant on the event set of a
nonsingular `2×2` `M`; trace formats discriminate exactly by their induced
partition of `Γ₀(m)` — which are SEED-21's checks `E` and `C` in the `r = n`
case, and both are theorems, not measurements. The file's one honest
measurement is `word_cost`, a bounded-radius BFS in a **declared** alphabet
that its own docstring admits is not claimed to generate `Γ₀(m)`. That is a
cost function, not a capacity, and it is precisely the "external cost that
separates fibre points all verifier observables conflate" — i.e. a second
consumer in SEED-48's sense, supplied from outside the check. It is consistent
with everything above and adds nothing to it; no result here depends on it.

---

## 7. Rigor boundary

**Proved here:** Theorems A, B, C, E, Lemma D, Corollary F, from the
definitions plus R0038 Theorems 2–3 and SEED-21 Theorems 1–2 (cited, proved
there). Chebyshev's sum inequality and `e^u ≤ 1+u+u²` on `[0,1]` are used and
are standard; Bernoulli's inequality likewise. Stirling is used only in the
*Reading* paragraph, where the claim is an approximation explicitly labelled as
such and no result depends on it.
**Corrected, and the corrections are applied to statements here rather than
merely proposed:** SEED-21 Theorem 3's appeal to Theorem 2 (→ Theorem A and
Theorem B), SEED-21 §2's general-rank `∞+∞−∞` display (→ `(★)`), SEED-21 §2's
`log₂|Γ₀(D_r)|` right-hand side (→ `log₂|W_Γ|`), SEED-21 §4's Corollary
(→ Corollary F). SEED-21's Theorems 1, 2 and its §3 negative are untouched and
stand.
**Not claimed:** any sharpening of Lemma D. The `T^{k−1}` remainder is the
trivial one; the true error for `k = 2` is the Gauss circle problem and for
`k ≥ 5` is `O(T^{k−2})`, and none of that is needed, because Theorem E only
requires a remainder that is explicit, not one that is optimal. Where a sharper
constant is available in the literature it is not used, so nothing here depends
on an uncited estimate.
**No novelty claimed:** Lemma D is Gauss's cube-sandwich argument;
`ω_N²/ω_{2N} = Γ(N+1)/Γ(N/2+1)²` is the beta integral. The content is that
this ratio is *the* corner defect of a norm-bounded verifier window, and that
it is `≈ 2^N`.

## 8. Queue

1. `PROVE` — SEED-21 successor seed 2 asked for the growth of distinguishable
   classes in a height-`≤ m` window for `Γ₀(D_r)` itself. Theorem E shows the
   corner factors out of the *defect*, but not out of `cap_W(C) = log₂|W_Γ|`.
   For `r = 2`, `W_Γ` is the set of `Γ₀(m) ⊆ GL_2(ℤ)` matrices of Frobenius
   norm `≤ T`; the leading term `(6/[SL_2(ℤ):Γ₀(m)])·2T²` follows from the
   standard `SL_2` count, but **an elementary explicit remainder is not
   available to me and I decline to quote an `O(T^{4/3})` I have not proved.**
   Stated as an open item, not as a result. This is the one place in this note
   where a leading term stands without its correction, and it is marked.
2. `SEARCH` — the Hecke translate family of §5: does any check in the corpus
   range over more than one `M`? If not, close the Hecke line explicitly.
3. `DEMONSTRATE` — SEED-48 queue item 2 is discharged by §§2–3; queue items 1
   and 3 there remain open.
4. Standing (from SEED-48 §6, endorsed): state the consumer with the
   compression. Added here: **state the window with the capacity.** A capacity
   without its window is the same error as a constant without its `X`
   dependence (`CLAUDE.md`, `HOLOGRAM.md` §7) — it looks like knowledge.
