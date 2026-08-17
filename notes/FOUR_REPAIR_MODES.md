# The four repair modes, made precise

*Derived from the human owner's transmission `collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md`, §B, flagged in its own triage §J1 as the most immediately actionable content of the three transmissions D0016–D0018. The classification $\Gamma_\varnothing,\Gamma_\Uparrow,\Gamma_\circlearrowleft,\Gamma_{\widehat{\phantom X}}$, the Eichler-shaped spelling of the completion mode, the corollary $D_1\simeq D_2\Rightarrow\widehat X_{D_1}\simeq\widehat X_{D_2}$, the sequence $X\to\widehat X\to D[1]$, the slogan "X known + D known ⇒ $\widehat X$ reconstructible", and the definition of a self-classifying obstruction are all the owner's. What is below is proof, refutation, and scope-fixing for them; nothing here is a restatement offered as a result (D0018 §J8).*

Seed 152, 2026-08-14.

---

## 0. Summary of what is settled here

| claim | status |
|---|---|
| $\Gamma_\varnothing$ and $\Gamma_\circlearrowleft$ are distinct operations | **proved distinct** (Thm 6); they collapse exactly when $H^1=0$ |
| completion exists iff the class dies | **proved** (Thm 1) |
| $\Gamma_{\widehat{\phantom X}}$ is $\Gamma_\varnothing$ performed by enlarging coefficients | **proved** (Thm 2) — the two modes are not independent |
| $D_1\simeq D_2\Rightarrow\widehat X_{D_1}\simeq\widehat X_{D_2}$ | **proved** under the reading "cohomologous ⇒ isomorphic as extensions" (Thm 4) |
| the converse $\Leftarrow$ | **refuted**, explicit counterexample (Thm 4′) |
| "X known + D known ⇒ $\widehat X$ reconstructible" | **false as stated** (Thm 3); true iff $V^\Gamma=0$ or a lift is chosen |
| self-classifying obstruction $D\simeq\operatorname{Code}(\widehat X/X)$ is an extra condition | **refuted**: it is *equivalent to* completability (Thm 5), not an additional hypothesis |
| $D$ is THE shadow of the standard theory | **refuted**: $D$ is the *image of* the shadow under the period/Eichler map (§3) |
| the classification discriminates on real corpus defects | **yes**, 3 defects → 3 different verdicts, one of them "none of the four applies" (§4) |

Scope limit, stated up front: everything proved below lives at the level of **1-cocycles with coefficients in an abelian $\Gamma$-module**, plus one $2$-cocycle instance in §4.1. $\Gamma_\Uparrow$ is the one mode I do **not** prove theorems about — its cost is a coherence obligation that this note only names (§1.2). No Agda or Lean was authored; nothing here is claimed typechecked.

---

## 1. The four modes as operations, with hypotheses and cost

Fix throughout: a group $\Gamma$, an abelian $\Gamma$-module $V$ (written multiplicatively/with a slash action as convenient), and
$$
Z^1(\Gamma,V)=\{D:\Gamma\to V\ :\ D_{\gamma\gamma'}=D_\gamma|\gamma'+D_{\gamma'}\},\qquad
B^1=\{\partial R:\gamma\mapsto R|\gamma-R\ :\ R\in V\},\qquad H^1=Z^1/B^1 .
$$
A **defect** $\delta$ is a cocycle $D\in Z^1(\Gamma,V)$ arising as $D_\gamma=f|\gamma-f$ for an object $f$ of a larger ambient in which the $\Gamma$-action is defined but $f$ is not invariant. (This is the D0018 §B situation verbatim, with $f|_k\gamma-f=D_\gamma$.)

### 1.1 The table, refilled

| mode | operation | hypothesis for availability | preserves | destroys |
|---|---|---|---|---|
| $\Gamma_\circlearrowleft$ | $D\mapsto[D]\in H^1$ | none — always available | the full cohomological content of $D$ | the choice of representative (the "gauge") |
| $\Gamma_\varnothing$ | $[D]\mapsto 0$ | needs a *datum*: a quotient of $H^1$, a coefficient enlargement, or an added hypothesis | the object $f$ | the invariant $[D]$, hence any theorem that used it |
| $\Gamma_{\widehat{\phantom X}}$ | $f\mapsto\widehat f=f+R$, $R\in V$, $\partial R=-D$ | $[D]=0$ in $H^1(\Gamma,V)$ | $[D]$, recoverable from $\widehat f-f$ (Thm 5) | the ambient: $\widehat f\notin$ the category $f$ lived in |
| $\Gamma_\Uparrow$ | $D\mapsto$ a 2-cell $\alpha:f\Rightarrow g$ | the ambient admits enrichment, **and** the coherence tower can be filled | everything (no information discarded) | flatness: all downstream equations become coherence obligations |

Note what the second column already shows and the transmission's one-line table hides: **$\Gamma_\circlearrowleft$ and $\Gamma_{\widehat{\phantom X}}$ are the only two modes that cost nothing in information.** $\Gamma_\varnothing$ is lossy by construction and $\Gamma_\Uparrow$ is lossless but unbounded in obligation.

### 1.2 The cost of $\Gamma_\Uparrow$, named but not discharged

Replacing a failed equation $f=g$ by a chosen 2-cell $\alpha:f\Rightarrow g$ never loses information, because the old situation is recovered by truncating. Its cost is that every composite that previously commuted on the nose now needs a filler, and those fillers need fillers: this is D0018 §D's own tower $\alpha_{012},\beta_{0123},\dots$. Whether the tower terminates, and at what level, is exactly the question Mac Lane coherence answers in the monoidal case and $A_\infty$/operadic machinery answers in general. **I prove nothing about it here**, and I flag that "categorify it" is therefore the one mode whose availability cannot be checked by a finite computation in the general case. Stating it as a peer of the other three, as the §B table does, understates it.

---

## 2. Theorems

### Theorem 1 (completion exists iff the class dies)
*Let $f$ satisfy $f|\gamma-f=D_\gamma$ with $D\in Z^1(\Gamma,V)$. There exists $R\in V$ with $\widehat f:=f+R$ satisfying $\widehat f|\gamma=\widehat f$ for all $\gamma$ **iff** $[D]=0$ in $H^1(\Gamma,V)$.*

**Proof.** $\widehat f|\gamma-\widehat f=(f|\gamma-f)+(R|\gamma-R)=D_\gamma+(\partial R)_\gamma$. This vanishes for all $\gamma$ iff $D=-\partial R$, i.e. iff $D\in B^1(\Gamma,V)$. $\square$

That is the entire content of the completion mode, and it says the mode is not a technique but a *test*: $\Gamma_{\widehat{\phantom X}}$ is available precisely on coboundaries.

### Theorem 2 ($\Gamma_{\widehat{\phantom X}}$ is $\Gamma_\varnothing$ bought honestly)
*Let $V_0\hookrightarrow V$ be an inclusion of $\Gamma$-modules and $D\in Z^1(\Gamma,V_0)$. Then $f$ admits a completion with $R\in V$ iff $\iota_*[D]=0$ in $H^1(\Gamma,V)$, where $\iota_*:H^1(\Gamma,V_0)\to H^1(\Gamma,V)$.*

**Proof.** Theorem 1 applied in $V$, plus the fact that $\iota$ is a map of cochain complexes so $[D]_V=\iota_*[D]_{V_0}$. $\square$

**Reading.** $\Gamma_{\widehat{\phantom X}}$ *is* "kill the class" — but killed by moving to a larger coefficient module rather than by fiat, and the larger module is exhibited, so nothing is lost: $[D]_{V_0}$ is still there, in $V_0$. This is why the two modes are not independent, and why the completion mode is the good one: it pays for $\Gamma_\varnothing$ with an enlargement instead of with an amputation.

**Corollary 2.1 (the Eichler instance, which is where the shape comes from).** With $\Gamma=\mathrm{SL}_2(\mathbb Z)$, $V_0=$ polynomials of degree $\le k-2$ with the weight-$(2-k)$ action, $V=$ smooth functions on $\mathfrak H$ with the same action: a period cocycle is generally non-trivial in $H^1(\Gamma,V_0)$ (Eichler–Shimura) while its image in $H^1(\Gamma,V)$ vanishes. The passage $f\rightsquigarrow\widehat f$ of D0018 §B is exactly the coboundary witnessing that vanishing.

**Corollary 2.2 (two widenings of opposite sign — and this is D0018 §D's clause, corrected in its variance).**
Widening the *coefficient* module can only **kill** obstructions: if $[D]=0$ in $H^1(\Gamma,V_0)$ then $\iota_*[D]=0$ in $H^1(\Gamma,V)$, since $\iota_*$ is a homomorphism. Widening the *observable* field can only **reveal** them: $\operatorname{Obs}_{\mathcal O_\alpha}(X)=0\not\Rightarrow\operatorname{Obs}_{\mathcal O_{\alpha+1}}(X)=0$, because more tests can only fail more. Both are called "widening" in the transmission; they are covariant and contravariant respectively and must never be conflated. The direction of §D's non-implication is correct; the reason it is correct is that observables are tests, not coefficients.

### Theorem 3 (reconstructibility fails; the exact condition)
*The set $\mathcal C(f,D)$ of completions of $f$ is either empty or a **torsor under $V^\Gamma$**, the module of $\Gamma$-invariants of $V$. Consequently the claim "X known + D known $\Rightarrow$ $\widehat X$ reconstructible" is **false** as stated. It is true iff $V^\Gamma=0$, and otherwise only after a normalisation (a chosen lift) is added to the data.*

**Proof.** If $\widehat f=f+R$ and $\widehat f'=f+R'$ are both invariant then $\partial(R-R')=0$, i.e. $R-R'\in V^\Gamma$; conversely adding any $z\in V^\Gamma$ to $R$ preserves invariance. Nonempty by Theorem 1. $\square$

**Concretely.** For a mock modular form $h$ of weight $k$, $V^\Gamma$ contains $M_k(\Gamma)$: the completion $\widehat h$ is determined only modulo genuine holomorphic modular forms of weight $k$. The standard theory does not "reconstruct" $\widehat h$ from $h$ and its cocycle either; it *stipulates* the non-holomorphic part to be the Eichler integral $g^*$ of the shadow. That stipulation is the chosen lift, and it is precisely the missing datum. **Said plainly: without a chosen lift the slogan is false, and its falsity is not exotic — it is the reason "the" completion is a definition and not a theorem.**

### Theorem 4 (the completion corollary, proved)
*Let $\widehat X_D$ denote the extension of $\Gamma$-modules classified by $D$, i.e. the class $[D]\in H^1(\Gamma,V)\cong\operatorname{Ext}^1_{\mathbb Z[\Gamma]}(\mathbb Z,V)$ realised as $V\to\widehat X_D\to\mathbb Z$. If $D_1$ and $D_2$ are **cohomologous** then $\widehat X_{D_1}\cong\widehat X_{D_2}$ as extensions (an isomorphism restricting to the identity on $V$ and on $\mathbb Z$).*

**Proof.** This is the classification of extensions by $\operatorname{Ext}^1$: the assignment $[D]\mapsto[\widehat X_D]$ is a bijection between $H^1(\Gamma,V)$ and isomorphism classes of extensions of $\mathbb Z$ by $V$, and equal classes therefore give isomorphic extensions. Concretely, with $D_2=D_1+\partial R$, the map $\widehat X_{D_1}\to\widehat X_{D_2}$ sending $(v,n)\mapsto(v+nR,n)$ is $\Gamma$-equivariant, and is the identity on both ends. $\square$

This is exactly the sequence $X\to\widehat X\to D[1]$ of §B, read as the extension it is. **Hypothesis that must be stated and is not stated in §B:** "$\simeq$" on the left must mean *cohomologous*, not merely "isomorphic as objects". Under the latter reading the statement is a different one, and:

### Theorem 4′ (the converse is false — a clean negative)
*$\widehat X_{D_1}\cong\widehat X_{D_2}$ (as objects, or even as extensions up to an automorphism of the ends) does **not** imply $[D_1]=[D_2]$.*

**Proof.** Take $\Gamma$ trivial and work in abelian groups, where the same $\operatorname{Ext}^1$ classification applies: $\operatorname{Ext}^1_{\mathbb Z}(\mathbb Z/p,\mathbb Z/p)\cong\mathbb Z/p$ has $p-1$ distinct nonzero classes, and **every one of them** is realised by the extension $\mathbb Z/p\to\mathbb Z/p^2\to\mathbb Z/p$. For $p\ge3$ take $D_2=2D_1$ with $[D_1]\ne0$: the classes differ, the middle objects are isomorphic groups, and the extensions differ only by the automorphism $x\mapsto2x$ of the kernel. $\square$

**Why this matters here and not only as pedantry:** standing check (e) of tonight's fleet is that an announced $\Rightarrow$ must not be silently upgraded to $\leftrightarrow$. §B states the implication and only the implication, and it is right to. Theorem 4′ says the upgrade is unavailable, so the completion does **not** determine the defect up to cohomology — only up to the automorphisms of its ends. Any future claim that "the completion remembers the obstruction exactly" needs Theorem 5's hypotheses, not Theorem 4's.

### Theorem 5 (self-classifying = completable)
*Define $\operatorname{Code}(\widehat X/X):=\partial(\widehat f-f)$, the cocycle of the difference. Then for every completable $f$, $D\simeq\operatorname{Code}(\widehat X/X)$ holds, with $\simeq$ equality of cocycles up to sign. Conversely if no completion exists there is no $\widehat X$ and the condition is vacuous. Hence "self-classifying obstruction" is not an extra property: it is equivalent to $[D]=0$, i.e. to the availability of $\Gamma_{\widehat{\phantom X}}$.*

**Proof.** $\widehat f-f=R$ and $\partial R=-D$ by Theorem 1. Well-definedness modulo the ambiguity of Theorem 3: $R$ is well-defined in $V/V^\Gamma$, and $\partial$ descends to an **isomorphism** $V/V^\Gamma\xrightarrow{\ \sim\ }B^1(\Gamma,V)$ — surjective by definition of $B^1$, injective because $\partial R=0$ iff $R\in V^\Gamma$. So $\operatorname{Code}$ is independent of the choice of completion and recovers $D$ on the nose. $\square$

**Consequence for D0018 §B.** The definition *self-classifying obstruction $:\iff D\simeq\operatorname{Code}(\widehat X/X)$* does not carve out a subclass of obstructions. It restates completability. If a *nontrivial* notion is wanted, the place to put the condition is elsewhere — for instance requiring $\operatorname{Code}$ to recover $[D]$ from $\widehat X$ **without** reference to $f$, which Theorem 4′ shows is generally impossible. I record that as the open item, replacing the definition-as-stated.

### Theorem 6 ($\Gamma_\varnothing\ne\Gamma_\circlearrowleft$, sharply)
*(i) $\Gamma_\circlearrowleft:Z^1\to H^1$ is a canonical, natural, surjective map requiring no choices, and it is **injective on cohomology** — it discards representatives, not classes.
(ii) $\Gamma_\varnothing$ is not a map out of $Z^1$ at all: it is a choice of either a coefficient enlargement $V\to V'$ with $\iota_*[D]=0$, or a quotient $H^1\to H^1/\langle[D]\rangle$, or an added hypothesis. Different choices give different results, so it is not natural.
(iii) $\Gamma_\circlearrowleft$ repairs $\delta$ iff $[\delta]=0$, i.e. iff there was nothing to repair. $\Gamma_\varnothing$ repairs by construction, always.
(iv) The two coincide as operations on defects iff $H^1(\Gamma,V)=0$.*

**Proof.** (i) is the definition of the quotient map. (ii): existence of two enlargements with non-isomorphic results follows from Theorem 2 plus any pair $V\subset V'\subset V''$ with $\iota_*[D]=0$ in $V'$; naturality would force a preferred one, and none is given. (iii) restates Theorem 1. (iv) if $H^1=0$ then every class is already $0$ and both maps send $\delta\mapsto0$; if $H^1\ne0$ pick $[\delta]\ne0$, then $\Gamma_\circlearrowleft(\delta)=[\delta]\ne0=\Gamma_\varnothing(\delta)$. $\square$

**So the distinction is real, and it is this:** $\Gamma_\circlearrowleft$ *relocates* the defect one level up, from a cocycle to a class, and is honest because it is forced; $\Gamma_\varnothing$ *removes* it, and is dishonest unless the removing datum is displayed. The transmission is right to separate them. The interesting corollary of Theorem 2 is that the fourth mode is the good way to perform the second.

---

## 3. Prior art: is $D$ THE shadow?

**Verdict: no. $D$ is the image of the shadow under the period map, not the shadow.** The distinction is not cosmetic — they live in different objects, of different weights, and the map between them is not surjective.

What I actually read (HTML only; no PDF was decoded, and I claim none):

1. **Wikipedia, *Mock modular form*.** Read. It defines: a mock modular form is "the holomorphic part of a harmonic weak Maass form"; $F=h+g^*$ with $h$ holomorphic; "the weight-$(2-k)$ modular form $g$ corresponding to a mock modular form $h$ is called its **shadow**"; $g=y^k\,\overline{\partial F/\partial\tau}$; and the non-holomorphic completion is the explicit integral
$$
g^*(\tau)=\Bigl(\tfrac{i}{2}\Bigr)^{k-1}\int_{-\bar\tau}^{i\infty}(z+\tau)^{-k}\,\overline{g(-\bar z)}\,dz .
$$
2. **Wikipedia, *Eichler–Shimura isomorphism*.** Read. Statement obtained: "an isomorphism between the space of cusp forms on $G$ of weight $n+2$ and the first Eichler cohomology of the group $G$ with coefficients in the $G$-module $X_n$". The page does **not** state injectivity of the cusp-form map separately, does not treat the antiholomorphic summand, and does not treat Eisenstein series; I record that as a limit of what I read, not as absence in the literature.
3. **`ar5iv.labs.arxiv.org/html/1107.0573`** (Bringmann–Diamantis–Raum, *Mock period functions, sesquiharmonic Maass forms, and non-critical values of L-functions*). Rendered and read. It gives $\xi_k:=2iy^k\overline{\partial/\partial z}$ as the weight-$k\to(2-k)$ operator, and the cocycle assignment on generators $\phi_f(T)=0$, $\phi_f(S)=r_f(-z)$ with $r_f$ the period polynomial, together with a *completed* period function $\hat r_{f,2}$ for non-critical values. **Caveat on ground, per standing check (d):** the $\xi_k$ formula and the generator assignment are quoted; the fetch also returned an interpretive sentence about what the cocycle "contains", which is the summariser's phrasing and not a quotation, so I do not lean on it. What I lean on instead is the algebra below, which needs no citation.
4. A web search returned Bringmann–Guerzhoy–Kent–Ono, *Eichler–Shimura theory for mock modular forms*, and Guerzhoy–Kent–Ono, *p-adic coupling of mock modular forms and shadows* (PNAS). **I did not read either in source** and cite them only as the located lineage.

**The algebra that settles it.** Let $F=h+g^*$ be the harmonic completion, so $F|_k\gamma=F$. Then
$$
D_\gamma\ :=\ h|_k\gamma-h\ =\ -\bigl(g^*|_k\gamma-g^*\bigr)\ =\ -(\partial g^*)_\gamma .
$$
So $D=-\partial g^*$, and by the integral formula $g^*$ is a linear functional of $g$: the cocycle is obtained from the shadow by (a) forming the non-holomorphic Eichler integral and (b) taking its coboundary. Both steps are needed and neither is the identity. In particular:

- **the shadow $g$ is a modular form of weight $2-k$; the defect $D$ is a 1-cocycle of weight $k$.** Different type, different weight, different space.
- $D$ is a coboundary *in the smooth module* — that is Theorem 1/Corollary 2.1 — and its content is entirely in its class in the smaller polynomial-like module. The shadow is a form; the defect is a class.
- The map $g\mapsto D$ has a kernel exactly when $g^*$ is itself weight-$k$ modular; whether that kernel is zero for cusp-form shadows is the Eichler–Shimura injectivity statement, which is standard but which I did **not** verify in a source I read (the Wikipedia page did not state it). **I therefore do not assert injectivity;** I assert only that $D$ is determined by $g$, which the displayed algebra proves.

**Therefore the D0018 phrase $D=$ "the shadow of the completion" ($\text{पूर्णतायाः छाया}$) is an accurate *metaphor* and an inaccurate *identification*.** It resembles the standard term closely enough that a reader will assume the standard term; a note using it must say "the cocycle attached to the shadow" or accept the error. This is the whole yield of the prior-art step and I state it as the finding.

---

## 4. Does the classification do work? Three real corpus defects

Selected by searching `notes/` for *stated* defects, not invented ones.

### 4.1 The carry cocycle — `notes/ATLAS_OF_N.md` §2.11 / `formal/cubical/NaturalMachine/CarryObstruction.agda`

**The defect.** For a section $s$ of $\mathbb Z/b^{n+1}\to\mathbb Z/b^n$, the carry $c(u,v)=s(u)+s(v)-s(u+v)$ is a normalised 2-cocycle valued in $\ker=\mathbb Z/b$. The note records: the module proves $c$ cannot be made to vanish for **any** section, i.e. "no choice of digit set eliminates carrying", and that the identification $[c_n]\ne0$ in $H^2(\mathbb Z/b^n;\mathbb Z/b)$ **remains open** because cubical Agda has no $H^2$ of a cyclic group.

- $\Gamma_\varnothing$: **provably unavailable.** `no-carry-free`/`carry-unremovable` is exactly a theorem that the class cannot be killed within the given coefficients. This is the strongest possible negative answer for a mode, and it is already checked.
- $\Gamma_\circlearrowleft$: **available, and it is precisely the open item.** Passing from the cocycle $c_n$ to its class $[c_n]$ is what the note says is missing. Cost, exactly: construct $H^2(\mathbb Z/m;A)$ constructively and identify it with $A/mA$. The note surveys cubical v0.5, agda-unimath and 1lab and finds it absent. So the cost is a library, and the classification correctly prices it.
- $\Gamma_{\widehat{\phantom X}}$: **already performed, unnoticed.** The extension $\mathbb Z/b\to\mathbb Z/b^{n+1}\to\mathbb Z/b^n$ *is* $X\to\widehat X\to D[1]$ with $D=c_n$. Positional notation at length $n+1$ is the completion of positional notation at length $n$. Theorem 4 then says: cohomologous carry cocycles (different digit sets) give isomorphic extensions — which is why every digit set computes the same arithmetic, and is a one-line proof of a fact the note obtains by hand.
- $\Gamma_\Uparrow$: available in principle (carry as the associator of a monoidal structure on digit words) and its cost is the coherence tower; nothing in the corpus needs it.

**Verdict: $\Gamma_\circlearrowleft$, with $\Gamma_\varnothing$ refuted by an existing theorem and $\Gamma_{\widehat{\phantom X}}$ already silently taken.**

### 4.2 The action residual — `notes/ACTION_RESIDUAL_FORMATION.md` §2

**The defect.** $\delta_p(x)$ measures failure of the square $q\circ s=p\circ q$; the note states "nonzero `delta_p` is failed equivariance/descent" and proves $\delta_p(x)=0\iff q(sx)=p(q(x))$. It further proves that changing the predictor $p$ changes the displayed residual by an old-observable function but does **not** change the induced joint quotient.

That last sentence is a coboundary statement in the corpus's own words: *the residual is a gauge, its class is the invariant.* Then:

- $\Gamma_\circlearrowleft$: **already performed** — "every $D_p$ is reversibly interdecodable with the same behavior carrier $B$" is the assertion that the class is $p$-independent. The note's own closing worry ("calling a particular residual canonical still requires a reason to choose that gauge") is Theorem 3's torsor ambiguity, arrived at independently.
- $\Gamma_{\widehat{\phantom X}}$: **also performed, and this is the corpus's one genuine self-classifying instance.** The refined observable $(q,\delta_p)$ is $\widehat X$: it makes the square commute, and the note proves it is the *coarsest* such — a universal completion. And $\operatorname{Code}(\widehat X/X)=\delta_p$ literally: the extra coordinate of $\widehat X$ over $X$ *is* the defect. By Theorem 5 this is not a bonus property, it is the completability that was already proved.
- $\Gamma_\varnothing$: unavailable unless $q$ was equivariant to begin with.
- $\Gamma_\Uparrow$: available (fill the square with a 2-cell) and strictly worse here, since the completion is universal and finite while the 2-cell incurs coherence.

**Verdict: $\Gamma_{\widehat{\phantom X}}$, with $\Gamma_\circlearrowleft$ as its shadow-bookkeeping. Two modes, both already used, neither previously named.**

### 4.3 The shifted-prime barrier — `notes/SEED64_BOUNDARY_FACTORIZATION_AT_U2.md` §4

**The defect.** To upgrade Theorem C from $u_1\to\infty$ to every fixed $u_1>2$ one needs an asymptotic evaluation of $\#\{q\le X\text{ prime}:P^-(q-h)>X^{1/u_1}\}$; the note names the barrier as the level of distribution $1/2$ for the shifted-prime sieve.

- $\Gamma_\circlearrowleft$: **not applicable.** There is no group, no coefficient module, no equivalence to quotient by. The defect is an error term $O(e^{-s\log s})$, a *magnitude*, not a class.
- $\Gamma_{\widehat{\phantom X}}$: **not applicable.** There is no object $\widehat X$ whose difference from $X$ is the defect; the defect is not a cocycle of anything.
- $\Gamma_\Uparrow$: not applicable, for the same reason.
- $\Gamma_\varnothing$: applicable **only in the degenerate sense** of assuming Elliott–Halberstam and thereby making the barrier vanish by hypothesis. Cost: conditionality of every downstream statement. That is a real move, but note it is $\Gamma_\varnothing$ in its worst form — killing by fiat, with the killing datum being an unproved conjecture.

**Verdict: the classification does not apply.** And this is the reportable finding of §4, so I state it flatly: **the four modes classify *structural* defects — those that are cocycles for some action — and say nothing about *quantitative* defects, which are the majority of the analytic corpus.** D0018 §B does not claim otherwise, but it also does not scope itself, and without the scope a reader will try to apply the four modes to an error term and find that only $\Gamma_\varnothing$ formally fits, which is the wrong answer dressed as an answer.

### 4.4 Does it discriminate?

Yes. Three defects, three verdicts: $\Gamma_\circlearrowleft$ (4.1), $\Gamma_{\widehat{\phantom X}}$ (4.2), none (4.3). In two of the three the classification identified a mode the corpus had *already used without naming*, which is the triage's own claim (§J1: "the corpus has been doing all four without naming them") and it is confirmed for two of the four modes. $\Gamma_\Uparrow$ was not the answer anywhere and I did not find a corpus defect where it is. That is not evidence against it; it is a gap in the sample of three, and I flag it as such rather than concluding the mode is idle.

---

## 5. What this leaves open

1. **`PROVE`** — Is there a nontrivial strengthening of "self-classifying" that survives Theorem 5? Candidate: $[D]$ recoverable from $\widehat X$ alone, without $f$; Theorem 4′ says not in general; find the class of $(\Gamma,V)$ where it holds.
2. **`PROVE`** — Construct $H^2(\mathbb Z/m;A)\cong A/mA$ constructively, discharging §4.1's $\Gamma_\circlearrowleft$.
3. **`SEARCH`** — Eichler–Shimura injectivity in a source that renders as HTML, to close the caveat in §3.
4. **`PROVE`** — Is there a corpus defect whose correct mode is $\Gamma_\Uparrow$? A negative answer over a larger sample would be evidence that the fourfold is really a threefold plus an aspiration.

## 6. Honesty ledger

- Nothing here was computed; every statement is a proof from definitions or a quotation from a source named in §3. No Python, no measurement, no fitted quantity. D0018 §J5's $\chi_\alpha$ is untouched, as its triage demands.
- No Agda or Lean was authored and nothing is claimed typechecked. §4.1's statements about `CarryObstruction.agda` are **read off `notes/ATLAS_OF_N.md`**, not re-verified against the source file or a typechecker; the exit-0 claims are that note's, cited as its claim.
- Theorem 4′ uses trivial $\Gamma$; it refutes the general converse, which is all it is asked to do. It does not show the converse fails for the modular $\Gamma$ of §3.
- §3's determination that $D$ is not the shadow rests on the displayed algebra $D=-\partial g^*$ plus the quoted definition of shadow; it does not rest on the ar5iv fetch, whose interpretive sentence I explicitly declined to use.
- §4's sample is three. The generalisation in §4.3 — structural vs quantitative — is offered at the generality I can defend from three instances plus the definitional observation that a cocycle requires an action, and is subject to audit.
