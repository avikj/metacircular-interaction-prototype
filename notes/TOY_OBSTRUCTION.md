# TOY_OBSTRUCTION: the finite toy model — annihilation, not obstruction

Executes `UNIFICATION.md` §3, Machine 2: the review's "collapse the bridge"
experiment. Organize the exact local Liouville-weighted prime-avoidance data
(`FAREY_TRANSFER.md` §1(c)) as a presheaf on finite sets of primes, and decide
whether the parity sector's disappearance is a **nontrivial gluing cocycle**
(a genuine Čech H¹ class) or a **vanishing section** (nothing left to
obstruct). Everything below is computed exactly (`code/exp36_toy.py`,
33/33 checks in `fractions.Fraction` arithmetic, k=2 through S = {2,…,19}).

**Verdict up front: annihilation, not obstruction.** The λ-twisted section is
killed by a zero *bonding map* at the place p\* = 2k−1 — the local partition
function there is exactly the gauge-averaging idempotent — while every
candidate obstruction group (Čech H¹ of any cover with any coefficient
presheaf including the ℤ/2 charge system; lim¹ of every tower over ℚ or ℤ/2)
vanishes identically for structural reasons. The one nonvanishing derived
invariant (integral lim¹) is a completion artifact that exists equally for
k with 2k−1 composite, where no annihilation occurs: it cannot see the parity
zero. The toy model's theorem is a sharp deflation, stated as Theorem 3 below,
with its prediction for the K-computation in §5.

---

## 1. The site, the presheaf, and the neutral subpresheaf

**Site.** Let 𝒫 be the poset of finite sets S of primes ordered by inclusion,
viewed as a category. (Equivalently one may use the site of basic clopens of
Ẑ = ∏ₚ ℤₚ; §4 shows the clopen site adds nothing — its covers refine to
partitions.) A presheaf is a functor F: 𝒫^op → Vect_ℚ; "restriction along
S′ ⊆ S" will mean *forgetting the places in S∖S′*.

**Charge groups.** At each place p the toy gauge group is the sign subgroup
{±1} ⊂ 𝕋 of GAUGE.md's multiplicative torus (the ℤ/2 charge of `UNIFICATION.md`
§2). Over S the gauge group is C_S = {±1}^S; its character group is
{χ_T : T ⊆ S}, χ_T(z) = ∏_{p∈T} z_p; the *Liouville element* is
λ_S = (−1,…,−1) ∈ C_S.

**The presheaf of charge-weighted admissibility data.**
$$F(S) \;=\; \mathrm{Fun}(C_S,\;\mathbb Q)\;=\;\bigoplus_{T\subseteq S}\mathbb Q\,\chi_T,$$
with restriction map for S′ ⊆ S
$$\mathrm{res}^S_{S'} f\,(z') \;=\; f(z' \text{ extended by } z_p=1 \text{ for } p\in S\setminus S')
\qquad\Longleftrightarrow\qquad \chi_T \mapsto \chi_{T\cap S'} .$$
*Functoriality, which is two obligations and not one, and which everything in
§§3–4 rests on (Čech H¹ and lim¹ are defined only for a functor):* on the
character basis, $\mathrm{res}^S_S(\chi_T)=\chi_{T\cap S}=\chi_T$, so
$\mathrm{res}^S_S=\mathrm{id}$ by idempotence of $\cap$ against a superset; and
for $S''\subseteq S'\subseteq S$,
$\mathrm{res}^{S'}_{S''}\mathrm{res}^S_{S'}(\chi_T)=\chi_{(T\cap S')\cap S''}
=\chi_{T\cap S''}=\mathrm{res}^S_{S''}(\chi_T)$, using $S''\subseteq S'$. Both
maps are ℚ-linear because they are defined on a basis, so $F$ is a genuine
presheaf of ℚ-vector spaces. [Clauses supplied in place by seed132,
2026-08-14: the identity and composition laws of a functor are independent
obligations, and neither was on the page; both hold, so no claim changes.]
Forgetting a place = evaluating its fugacity at the neutral value 1. This is
the toy of the corpus's conditional expectation onto fewer places.

**Neutral subpresheaf.** F⁰(S) = ℚ·χ_∅ (the constants — total charge zero).
Restriction preserves it, and more generally never raises charge
(χ_T ↦ χ_{T∩S'}), so the charge filtration is a filtration by subpresheaves.
Note the top (fully charged) characters are carried to top characters:
res χ_S = χ_{S'} — the "Liouville line" L(S) = ℚ·χ_S is itself a subpresheaf,
*trivialized* by its canonical generator. As a presheaf of lines it is
constant; there is no twisting in the line itself.

**The section (local data).** Fix k affine legs. For p with the legs in
distinct residues mod p, the local charge partition function at common
fugacity z (all legs twisted by the same local gauge sign, as in GAUGE.md
where one completely multiplicative g twists every leg) is
$$J_p(z) \;=\; 1-\frac kp+\frac kp\,\frac{z(p-1)}{p-z},
\qquad J_p(1)=1,\qquad
\iota_p := J_p(-1)=\frac{p+1-2k}{p+1},$$
which vanishes **iff p = 2k−1** (`FAREY_TRANSFER.md` §1(c); re-verified in
exp36 V1–V2 against exact enumeration over ℤ/p^M). For twins (k=2) the place
p=2 is collided (n, n+2 share a residue); the honest collided factor is
$$J_2^{\mathrm{twin}}(z)=\tfrac12+\frac{z^{3}}{2(2-z)},\qquad
J_2^{\mathrm{twin}}(1)=1,\quad J_2^{\mathrm{twin}}(-1)=\tfrac13$$
(exp36 V1b–V1d; nonzero — the collided place is *not* annihilating).

The **admissibility section** over S is
$$\sigma_S(z)\;=\;\prod_{p\in S}J_p(z_p)\;\in\;F(S),$$
whose charge decomposition is σ_S = Σ_T (∏_{p∈T} b_p)(∏_{p∉T} a_p) χ_T with
$$a_p=\tfrac{1+\iota_p}2=\frac{p+1-k}{p+1}\ (\text{neutral coefficient}),\qquad
b_p=\tfrac{1-\iota_p}2=\frac{k}{p+1}\ (\text{charged coefficient}).$$
Twin table on the chain S₁={2} ⊂ … ⊂ S₈={2,…,19} (exp36 Part 2):

| p | 2 | 3 | 5 | 7 | 11 | 13 | 17 | 19 |
|---|---|---|---|---|----|----|----|----|
| ι_p | 1/3 | **0** | 1/3 | 1/2 | 2/3 | 5/7 | 7/9 | 4/5 |
| a_p | 2/3 | 1/2 | 2/3 | 3/4 | 5/6 | 6/7 | 8/9 | 9/10 |
| b_p | 1/3 | 1/2 | 1/3 | 1/4 | 1/6 | 1/7 | 1/9 | 1/10 |

Because J_p(1)=1, forgetting a place multiplies by a_p+b_p = 1:
**σ = (σ_S) is a strictly compatible family** — a section of F over the whole
ind-poset, i.e. an element of lim_S F(S), with no gluing condition to check
(exp36 V4). The full charge-resolved local theory extends to the inverse
limit with no obstruction whatsoever.

## 2. The twisted section and the lifting/gluing question

The λ-twist is translation by the Liouville element:
σ^λ_S(z) := σ_S(λ_S·z) = ∏_p J_p(−z_p). The lifting/gluing question posed by
UNIFICATION §3: *does the Liouville-twisted section extend/glue compatibly as
S grows, and is its failure at p = 2k−1 a nontrivial cocycle with ℤ/2-charge
coefficients?*

Exact answer (exp36 V5a): restriction now costs a scalar,
$$\mathrm{res}^{S\cup\{p\}}_{S}\,\sigma^\lambda_{S\cup\{p\}}
\;=\;\iota_p\,\sigma^\lambda_{S},$$
so the twisted family is *not* compatible as given; the twisted line
L^λ(S) = ℚ·σ^λ_S is a subpresheaf whose bonding maps are multiplication by
ι_p. Three exhaustive facts (k=2):

1. **The p\*=3 step is the zero map.** ι₃ = 0: every composite bonding map
   from any level containing 3 down to any level not containing 3 is
   identically zero (exp36 V5b). The twisted evaluation ∏_{p∈S} ι_p vanishes
   for every S ∋ 3 (V5c). Equivalently: the inverse limit lim L^λ ≅ ℚ is
   *nonzero* (threads: zero below the 3-step, determined by their tail above
   it), but its structure map to every level below the 3-step is zero. The
   twisted section **glues perfectly — to zero**. Existence of the extension
   is trivial; what dies is its value. That is a section-level (H⁰)
   phenomenon, not a gluing-level (H¹) one.
2. **The charged content never vanishes.** The top-charge Fourier coefficient
   of σ_S is ∏_{p∈S} b_p ≠ 0 at every level — indeed b₃ = 1/2 is the
   *largest* charged amplitude on the chain (exp36 V5d, V3c). The
   annihilation at λ is destructive interference of nonzero charge
   amplitudes at one point of the gauge group, not vanishing of the charged
   sector as a subspace.
3. **The mechanism is an idempotent, and it is unique.** At p\* = 2k−1,
   a_{p\*} = b_{p\*} = 1/2, i.e.
   $$J_{p^*}(z)\;=\;\frac{1+z}2\;=\;\mathbf 1_{\{z=1\}}
   \;=\;\text{the Haar/twirl idempotent of the local charge group }\mathbb Z/2 .$$
   The local partition function at p\* **is** the local gauge-averaging
   projector: the local state is exactly maximally twirled, so it transmits
   zero charge information — the local parity bit (parity of the total
   p-adic valuation of the k-tuple) is an exactly fair coin, and p\* is the
   only place where it is fair: P(even) − P(odd) = ι_p = 0 iff p = 2k−1
   (exp36 V7, verified by direct enumeration at p = 3, 5, 7). In quantum
   information language (see UNIFICATION §3 Machine 1): the p\*-place channel
   is the complete depolarizer on the charge bit; a product of local channels
   containing one depolarizer has zero distinguishing power for the global
   charge. Nothing is blocked in transit between places; one place simply
   erases the bit.

## 3. The obstruction computation: every candidate H¹ vanishes

We now check *honestly* that there is no cohomological formulation in which
the p\*-failure becomes a nontrivial class. Two candidate theories exist for
this site; both vanish, for structural reasons independent of the section.

**(a) Derived limits over the poset (the only "Čech H¹" a directed poset
has).** 𝒫 is directed, so its nerve is contractible and the only derived
functors in play are lim^i over cofinal towers; the obstruction-theoretic
question is precisely whether lim¹ of the relevant tower is nonzero. Over ℚ:
every tower of finite-dimensional vector spaces satisfies the Mittag–Leffler
condition (image chains stabilize — descending subspaces of finite-dimensional
spaces), so lim¹ = 0 for *every* subquotient tower of F, including the
twisted line (whose image chains are computed and seen to stabilize after at
most one step in exp36 V6a). With ℤ/2-charge coefficients: towers of finite
groups are likewise Mittag–Leffler, so lim¹ vanishes there too. A tower
containing a zero bonding map is still Mittag–Leffler — a zero map *kills the
image*, it does not create a lim¹ class. **Annihilation and obstruction are
disjoint mechanisms, and the toy exhibits only the first.**

**(b) Čech cohomology of the limit space.** At the space level the toy sits
on X_S = ∏_{p∈S} ℤ/p (or its pro-version Ẑ). These are profinite: *every
open cover refines to a finite clopen partition*. The Čech complex of a
partition has no nonempty pairwise intersections, hence is concentrated in
degree 0; partitions are cofinal among covers; therefore
$$\check H^n(X,\mathcal A)=0\quad (n\ge1)\quad\text{for every presheaf of
abelian coefficients }\mathcal A,$$
in particular for the ℤ/2 charge system. There is no cover and no coefficient
system on the profinite side in which the parity failure can be a nontrivial
cocycle — the receptacle itself is zero. exp36 Part 6 dramatizes this: on the
3-point fiber X_{{3}} the cyclic cover {01},{12},{20} has cover-level
H¹(𝔘; ℤ/2) = ℤ/2 ≠ 0 (a manufacturable cocycle), and the class dies under
refinement to the partition {0},{1},{2} — any apparent cocycle here is a
cover artifact, not a class of the space.

**(c) The ℤ/2-charge local system is honestly trivial.** The requested
coefficient system — the charge — would enter as the local system / double
cover defined by the parity of the total valuation, with λ as its
trivializing section. At every finite level S, λ_S = ∏_{p∈S}(−1)^{v_p} is a
genuine locally constant function on ∏_{p∈S}(ℤ_p∖{0}) (exp36 V8c exhibits
the trivialization on cylinders: no monodromy anywhere). A trivialized torsor
carries no H¹ class by definition. What fails in the limit S ↗ 𝒫 is
*pointwise convergence of the trivializing section* (the infinite product
∏_p(−1)^{v_p} does not converge on Ẑ; only on ℕ ⊂ Ẑ, the points with finitely
many prime factors) — an analytic/convergence failure of a section, which is
exactly Lemma F.2 of GAUGE.md ("λ does not factor through the profinite
boundary") in toy form, and again an H⁰ phenomenon.

**(d) The integral caveat — the only nonvanishing derived invariant, and why
it is not the parity class.** Over the integral lattice ℤ·σ^λ (bonding maps
= multiplication by the numerators p+1−2k), the image chains
(p₁+1−2k)⋯(p_r+1−2k)ℤ strictly decrease, the tower is *not* Mittag–Leffler,
and lim¹ ≠ 0 (a countable tower of countable abelian groups has lim¹ = 0 iff
ML — Gray's theorem; the class is an uncountable divisibility-completion
quotient of the type lim¹(ℤ, ×m) ≅ ℤ̂_{(m)}/ℤ). But exp36 V6b/V6d shows this
non-ML behavior is **identical for k = 5**, where 2k−1 = 9 is composite and
ι_p ≠ 0 at every place — no annihilation anywhere, same integral lim¹. The
integral lim¹ measures the *decay* of the twisted weights (a Mertens-type
completion phenomenon shared by every twisted sector, zero or no zero); it
neither detects nor localizes the exact zero at p = 2k−1. Even the one
obstruction group that survives is blind to the parity phenomenon.

## 4. The toy model's theorem

**Theorem (annihilation, not obstruction).** In the presheaf F of
charge-weighted admissibility data on the poset of finite prime sets, with
restriction = forgetting places:

1. The untwisted charge-resolved section σ extends to the inverse limit with
   no condition (normalization a_p + b_p = 1).
2. The λ-twisted section generates a line subpresheaf L^λ with bonding
   scalars ι_p = (p+1−2k)/(p+1); for p\* = 2k−1 prime this includes exactly
   one zero bonding map, and J_{p\*} = (1+z)/2 is the twirl idempotent of the
   local charge group: the parity bit at p\* is an exactly fair coin, the
   unique fair place.
3. Every candidate obstruction group vanishes: lim¹ over ℚ and over ℤ/2 (all
   towers Mittag–Leffler), and Čech H^n (n ≥ 1) of the profinite fiber with
   *any* coefficient presheaf (clopen partitions are cofinal). The ℤ/2-charge
   local system is explicitly trivialized at every finite level. The only
   nonvanishing derived invariant, the integral lim¹, is a
   divisibility-completion artifact present identically when 2k−1 is
   composite; it does not localize at the parity zero.

**Consequently: the parity sector of the toy is not obstructed but
annihilated — there is nothing left to obstruct.** The exact zero at
p = 2k−1 is a zero of a section/bonding map (an H⁰ statement), and the
infinite-place failure of λ is a convergence failure of an explicitly
trivialized section (also H⁰). No formulation makes it a cocycle.

## 5. Inverse limit, the Toeplitz comparison, and the K-prediction

**The limit object.** lim_S F(S) = Fun(colim_S C_S, ℚ) = functions on
⊕_p ℤ/2 (finitely supported sign patterns). The Liouville element
λ = (−1,−1,…) lies in ∏_p ℤ/2 ∖ ⊕_p ℤ/2 — it is a point of the Bohr-type
completion of the dual, *not* of the colimit the inverse limit can see. The
limit object therefore contains the full neutral-and-finitely-charged theory
and sees λ only as a non-convergent net of finite twists whose values are
eventually zero (every net member containing the place 3 already evaluates
to 0). This is the exact toy of GAUGE.md Lemma F.2 and of CORE_KMS: the
boundary/equilibrium world is complete for finitely-supported charge and
constitutively blind to the infinitely-charged point.

**Structural comparison with the Toeplitz extension picture**
(0 → I → 𝒯(ℕ⋊ℕ^×) → Q_ℕ → 0; FAREY_TRANSFER §3).
The dictionary suggested by the toy:

| toy object | operator object |
|---|---|
| lim F (functions on ⊕ℤ/2) | boundary quotient side: gauge-isotypic data of Q_ℕ, finitely-charged sectors |
| the compatible section σ | the KMS/equilibrium weight (unique, neutral-supported: Theorem F) |
| twisted line L^λ with bonding ι_p | the α_λ-twisted sector transported through the filtration |
| zero bonding at p\* = 2k−1 | exact finite-place annihilation of FAREY_TRANSFER §1(c) |
| integral lim¹ (completion artifact) | Milnor lim¹ terms in K of an inductive/inverse limit |

**Prediction for the K-computation** — *[INTERFACE: fleet-kboundary's
KBOUNDARY note has not landed at time of writing; this section is the agreed
interface and should be reconciled against it when it lands.]*
*[RECONCILED 2026-08-11 by fleet-kboundary; narrowed by Codex audit
2026-08-12: the homotopy/KK prediction is confirmed — α_λ is outer but
connected to the identity, so every invariant factoring through that class
agrees with the identity twist, while ∂ itself is faithful. The order-two
parity-core K-groups and their no-torsion conclusion remain conditional on a
named stage-action lemma. See notes/KBOUNDARY.md §7 and
notes/KBOUNDARY_AUDIT.md.]*
The toy predicts the deflationary branch of the K-question:
**∂[λ-twist] = 0** in the six-term sequence — the λ-twisted class should die
not by hitting a nontrivial boundary class but because the twisted sector is
annihilated by an exact local projector before any index/boundary invariant
can be charged. Two sharp caveats delimit the prediction's reach:
(i) K-theory has ℤ coefficients, and the one integral invariant the toy could
not kill is a lim¹/completion term (Milnor sequence); if the K-computation
finds a nonzero contribution, the toy predicts it will be of this completion
type — *not localized at p = 2k−1, present equally for twist data with
2k−1 composite* — and therefore not identifiable with the parity barrier.
(ii) The toy is abelian/commutative (functions on the gauge group); the
Toeplitz lift is where scale-ordering is remembered (the non-self-adjoint
layer of FAREY_TRANSFER §1(b)), and torsion phenomena invisible to the
ℚ-linear toy could in principle live there. Falsifier: a nonzero boundary
class that (a) is torsion or otherwise invisible rationally AND (b) provably
localizes at the p = 2k−1 places would refute the toy's deflation and
identify genuine gluing content in the parity barrier. Absent that, the
expected theorem is a no-go one level deeper than Theorem F: *K-theory sees
the extension's topology, not the analytic barrier* — decided, as the review
asked, before the program builds on it.

**What the toy predicts for the program.** The parity barrier's operator
formalization is consistently an *annihilation* phenomenon — twirl
(Theorem F), unique trace (CORE_KMS), exact local depolarizer (here) — and
never a *gluing* phenomenon. The productive continuation is therefore not
obstruction theory over the neutral world (its obstruction groups are
structurally zero) but the minimal-enlargement question of UNIFICATION §3 Q:
what added observable restores the erased bit. In QI terms (Machine 1): the
sieve is a channel with a depolarizing local factor; no post-processing
recovers an erased bit, one must enlarge the channel's input — exactly the
Friedlander–Iwaniec "extra input", now with an exact information-theoretic
meaning at a single finite place.

## 6. Verification ledger

`code/exp36_toy.py` — exact rationals throughout; 33/33 checks pass:
V1 local factors vs enumeration mod p^M (distinct and collided);
V2 closed form + zero locus k=2..6, p≤50; V3 charge coefficients and the
twirl idempotent at p\*; V4 untwisted compatibility (all 2^|S| gauge points,
all steps to S={2,…,19}); V5 twisted defect = ι_p exactly, zero composite
bonding, nonvanishing top-charge coefficients; V6 ML certificates over ℚ,
non-ML over ℤ for k=2 *and* k=5; V7 parity-bit fairness iff p=3 (enumerated);
V8 cover-level ℤ/2 cocycle on Z/3 killed by partition refinement (GF(2) rank
computation), and explicit triviality of the charge torsor at finite level.
