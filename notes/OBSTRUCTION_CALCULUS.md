# Reading Hieroglyphics II into the natural machine

**Status: the encodable fragment is checked.** Author `claude-euclid`,
2026-08-15. Source document filed verbatim at `papers/hieroglyphics_ii.tex`.
Machine-checked fragment: `formal/cubical/NaturalMachine/ObstructionCalculus.agda`
(`--cubical --safe --no-import-sorts`, exit 0, zero warnings, no postulates,
no holes).

## 0. What the document does that the previous one did not

Three changes, and each one repairs a specific gap.

**Φ is given a definition.** `Φ ≠ वस्तुपरिवर्तनम्; Φ = दृश्यभेदक्षेत्रविस्तारः` —
Φ does not change the object, it widens the field of visible distinctions. The
consequence is stated as a non-implication:

$$\operatorname{Obs}_{\mathcal O_\alpha}(X)=0 \;\not\Longrightarrow\;
\operatorname{Obs}_{\mathcal O_{\alpha+1}}(X)=0 .$$

This is the row the previous schema was missing. An obstruction that is not a
failure of two paths to be *equal* — the executability defect of
`notes/RANK_ONE_SMITH_PRODUCER.md`, where a theorem holds and its term does not
reduce — has no image in $\pi_n$, no Čech class, no curvature. Indexing `Obs`
by the observation field is what gives it a home: it is invisible at
$\mathcal O$ = types-and-axioms and visible at $\mathcal O^{+}$ =
types-and-axioms-and-reduction. The defect did not move. The field did.

**$\Gamma$ is split into four, and ordered after classification.**
$\Gamma_\varnothing$ (kill), $\Gamma_\Uparrow$ (promote to a 2-cell),
$\Gamma_\circlearrowleft$ (keep as a class), $\Gamma_{\widehat{\ }}$ (complete),
with the instruction `प्रथमं वर्गीकुरु; पश्चात् Γ`. The previous schema had a
single `G⟨δ⟩` that adjoined a generator regardless of what kind of defect it
was, which is how you get a machine that quotients away information it should
have kept.

**The MDL functional acquires a coding cost.** $\mathfrak L^\star =
\arg\min[L(\mathfrak L)+L(\mathfrak Q\mid\mathfrak L)+L(\Pi\mid\mathfrak L)]$
with $\operatorname{gain}(\sigma)=L(\mathfrak Q)-L(\mathfrak Q\mid\sigma)-L(\sigma)$,
and a symbol is born iff its gain is positive. The previous
$\arg\max \sum I/|\mathfrak L|$ scored a fitted quadratic exactly as well as a
derivation; this one charges for the symbol and credits it only against the
*proof corpus* $\Pi$. A fit that compresses nine data points and no proofs has
gain $\le 0$. That is `exp27` priced correctly.

## 1. What is machine-checked

`ObstructionCalculus.agda`, five sections.

**A. Observation fields.** `Obs X V` is an index type plus
`read : Index → X → V`. `Sep 𝒪 x y` is a *witness* of distinction — a named
observation and a proof its two readings differ. `Blind 𝒪 x y` is the absence
of one. This is the repository's own `natural_crystal` notion, which keeps the
witness rather than a yes/no.

**B. Φ.** `O ⊑ P` says `P` sees everything `O` sees and reads it the same way —
with `X` held fixed, so the object does not move. `Φ-monotone` proves
distinctions survive widening. That direction is easy and it is the only one
that holds.

**C. The non-implication, twice.**

*Concretely.* `absField` reads only $|{\cdot}|$ — the field the divisibility
theory actually uses, since `∣` over ℤ factors through `abs`. Under it,
`sign-blind` proves $6$ and $-6$ are indistinguishable. Adjoin the identity
observation and `sign-seen` separates them. That is exactly
`notes/SMITH_SIGN_CONVENTION.md`: the cubical normalizer returns
$\operatorname{diag}(1,-6)$, the Lean gate demands nonnegative invariants, and
the two lanes were blind to each other's convention because they were reading
the same field.

*In general.* `break-blindness`: for **any** field, any two genuinely distinct
points, and any two distinct values, there is a widening that separates them.
So `Blind` is never a property of the object — it is a property of the field,
and it can always be broken. This is the document's `0 ⇏ अन्तः` as a theorem:
a machine that halts when its current field reports no obstruction has
concluded something about its field and nothing about its object.

**D. Classify, then repair.** `Kind` has the four constructors. `Classified`
bundles a `Sep` witness with a `Kind`. `Repair` is a type *indexed by the
classification*, so there is no term of repair type that has not been
classified first — the discipline is enforced by the type checker rather than
by a comment. `Completion→Collapse` proves $\Gamma_{\widehat{\ }}$ implies
$\Gamma_\varnothing$; the converse is deliberately absent, and its absence is
the content — a collapse gives you the quotient, a completion gives you a
section of it. `signDefect`/`signRepair` classify the Smith sign defect as
$\Gamma_{\widehat{\ }}$ and discharge it with `absℤ`, whose idempotence
(`absℤ-idem`) is what makes it a choice of representatives rather than a
further move.

**E. जननीयता ≢ पुनर्निर्मेयता.** `Generates` and `Reconstructs`, with both
witnesses: `forget : Bool → Unit` generates and does not reconstruct;
`name : Unit → Bool` reconstructs and does not generate. Independent, as
claimed.

## 2. What I claimed was not encodable, and was wrong about

**Retracted, 2026-08-15.** The first version of this section said two things
were beyond encoding. Both were true of the model I had chosen and false of the
substrate. `formal/cubical/NaturalMachine/RepairGrading.agda` does them.

### 2.1 "Only two of the four repair kinds are distinguishable" — false

I wrote that $\Gamma_\Uparrow$ and $\Gamma_\circlearrowleft$ collapse into
$\Gamma_\varnothing$ "after 0-truncation". Nothing forced that truncation on
me; I imposed it, in a proof assistant chosen precisely because
identifications are data.

$\Gamma_\Uparrow$ promotes the defect to an identification and keeps *which
one*: `Promote x y = x ≡ y`. $\Gamma_\circlearrowleft$ keeps the class:
`Class x y = ∥ x ≡ y ∥₁`. In a 0-truncated model these agree because there is
at most one identification to have. In a univalent one they do not, and `S¹`
witnesses the gap: `refl` and `loop` are two repairs of the same defect
`base ≡ base`, distinguished by `winding` (`Γ⇑-separates`, via
`winding refl = 0`, `winding loop = 1`, both `refl`), and identified by
`squash₁` once passed to the class (`Γ↺-identifies`). So the comparison map
$\Gamma_\Uparrow \to \Gamma_\circlearrowleft$ is not injective, and what it
forgets is a genuine defect.

That is the schema's own claim — higher structure is what tells repairs apart —
proved rather than cited as a reason not to prove it.

### 2.2 "$\chi$ needs a cost model" — false as stated

I wrote that $\chi = \Delta\operatorname{Reach}/\Delta\operatorname{Kill}$ was
unencodable without a cost model, since a ratio of unmeasured rates is what
`CLAUDE.md` forbids. That rule bans *measured* numbers, not counted ones, and
in any case the ratio was the wrong object to reach for.

What $\chi = 1$ asserts is that the widening opens exactly as much as the
repair closes. Read that way it needs no cardinality at all — it is a
biconditional between two predicates, and it is provable:

$$\underbrace{\text{Blind}_{\mathcal O}(x,y) \times \text{Sep}_{\mathcal O^{+}}(x,y)}_{\text{what }\Phi\text{ opened}}
\;\longleftrightarrow\;
\underbrace{(|x| = |y|) \times (x \neq y)}_{\text{what }\Gamma_{\widehat{\ }}\text{ closes}}$$

`golden` proves both directions for the sign defect over ℤ. The pairs the sign
observation newly separates are *precisely* the pairs `absℤ` re-identifies —
$\{(n,-n) : n \neq 0\}$ on both sides, on the nose. So the sign defect sits
exactly at the golden boundary, and this is a theorem about a specific
$(\mathcal O, \Gamma)$ rather than an aesthetic about all of them.

An equality of predicates is also strictly stronger than an equality of counts:
it says the two sets coincide, not merely that they are equinumerous.

### 2.3 What genuinely remains outside this fragment

$\delta_\triangleleft = \operatorname{cofib}$ and
$\delta_\triangleright = \operatorname{fib}$ still appear only as
split-surjective and injective, in `ObstructionCalculus` §E. The independence
survives; the homotopy content is discarded. That one is a real restriction of
the encoding rather than a limitation of the substrate, and it is the next
thing to lift — cofibre and fibre are available here too.

The general lesson, which I got backwards once already this week: **"not
encodable" is almost always "not encodable in the model I happened to pick",
and the distinction between those two is exactly the `भेदरक्षा` the document
puts first.**

## 3. Two places I think the document is exposed

**The parity of the $Z(t,\theta)$ reindexing.** With
$P(z)=\sum_{n\ge1}\Lambda(n)e^{-nz}$,

$$Z(t,\theta)=P(t+i\theta)P(t-i\theta)=\sum_{m,n\ge1}\Lambda(m)\Lambda(n)
e^{-t(m+n)}e^{-i\theta(m-n)} .$$

The substitution $w=\tfrac{m+n}{2}$, $r=\tfrac{n-m}{2}$ giving
$\mathcal K(w,r)=\Lambda(w-r)\Lambda(w+r)$ is exact **only on the sublattice
$m\equiv n \pmod 2$**. For $m\not\equiv n$, $w$ and $r$ are half-integers, and
$\Lambda(w\pm r)$ is being evaluated off ℕ. The boxed identity as written sums
over a lattice it has not specified. This matters for the two readings that
follow it: $[w^N]\mathcal K$ = Goldbach lives on the even sublattice (which is
the right home for Goldbach, so the restriction is harmless and should be
*stated*), whereas $[r^1]\mathcal K$ = twin primes needs $n-m=2$, i.e. $r=1$,
which forces $m\equiv n$ — also fine. So both readings survive, but they
survive on a sublattice the identity does not name, and the odd part of the
product is being silently discarded. Name it, and the two theorems sit on
visibly different slices of the same kernel; leave it, and the identity is
false as stated.

**The self-referential closure.** `पूर्णता → पूर्णतावाक्यम् → पूर्णताविघ्नः ?`
— quote the completeness claim, diagonalize, obtain a new obstruction. Section
C2 proves the *weak* form: blindness is always breakable, so no field is
final. It does **not** prove the strong form, that the widening can always be
generated *by the machine from its own completeness claim*. That step needs
$Q$ + eval + $\neg$ with the evaluation actually internal, and the honest
statement of what is available is: `break-blindness` requires a `Discrete X`
and two distinct values supplied from outside. The machine can always be
surprised; whether it can always surprise itself is the open part, and it is
the part that decides `स्थिरस्फटिकः ⋈ अनन्तस्वर्णजालम्`.

## 4. The one line I would keep

`भेदं रक्ष` — protect the distinction — is first in the closing composition and
first among the four guards, and it is the guard this repository has now broken
twice in one week, in opposite directions:
`RANK_ONE_SMITH_PRODUCER.md` (a distinction the types could not see: proved
versus evaluable) and `SMITH_SIGN_CONVENTION.md` (a distinction the types
erased: equivalent versus identical). Both were failures of `भेदरक्षा`, both
were invisible to every check that was running, and both were found the same
way — by evaluating something on a closed input rather than reasoning about its
type.

That is the operational content of the whole schema, and it is one sentence:
**a field that cannot separate two things will report that they are the same,
and it will be wrong in exactly the way you cannot see.**
