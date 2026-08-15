# Mystery, gain, and the argmin: what survives the invariance theorem

*seed168. Adjudication of the MDL layer spanning D0018 §A and D0019 §F, with their
triage items D0018 §J5/§J7 and D0019 §J5/§J6. Owner artifacts: derived from, not
rewritten. No computation of any kind was run; no constant is fitted; nothing is
measured. Every statement below is either a proof, a citation, or an explicitly
labelled gap.*

---

## 0. The five displayed objects, and the one question that governs all of them

D0018 §A and D0019 §F between them display:

$$
\operatorname{Mystery}(X):=L(X)-L(X\mid\mathfrak L),\qquad
\Delta\operatorname{Mystery}=-\Delta\operatorname{Compression}
\tag{M}
$$
$$
\Delta\operatorname{Reach}>0\Rightarrow\text{new mystery may be born};\qquad
\text{knowledge growth}\not\Rightarrow\text{mystery decrease}
\tag{N}
$$
$$
\operatorname{gain}(\sigma)=L(\mathfrak Q)-L(\mathfrak Q\mid\sigma)-L(\sigma),
\qquad \operatorname{gain}(\sigma)>0\Rightarrow\sigma\in\mathfrak L_{\alpha+1}
\tag{G}
$$
$$
\mathfrak L^\star=\operatorname*{arg\,min}_{\mathfrak L}\bigl[L(\mathfrak L)+L(\mathfrak Q\mid\mathfrak L)+L(\Pi\mid\mathfrak L)\bigr]
\tag{A}
$$

Every one of them is built from a single undefined symbol, $L$. D0019 §J6 states the
governing hazard correctly — *"$L$ is defined only up to an additive constant depending
on the machine, so no absolute value of Mystery means anything"* — and then says "record
the invariance requirement before any use." This note records it, and finds that the
requirement does more than qualify these formulas: it **kills two of them outright and
rescues one in a form the transmission does not claim.**

### 0.1 The standing convention

Throughout, $L$ is one of:

- **(K)** prefix (Chaitin–Levin) Kolmogorov complexity $K_U$ relative to a universal
  prefix machine $U$, with $K_U(x\mid y)$ the conditional version; or
- **(C)** a *concrete computable prefix code*: an injective map from objects to binary
  strings whose image is prefix-free, $L(x):=$ length of the codeword, with $L(x\mid y)$
  the length under a code indexed by $y$.

Reading (K) is what makes the invariance theorem bite. Reading (C) is what MDL
(Rissanen) actually uses. **The transmission does not say which, and the two give
opposite verdicts on (G).** Both are worked below.

**Invariance theorem** (Solomonoff 1964, Kolmogorov 1965, Chaitin 1969; Li–Vitányi
Thm. 2.1.1). For universal $U,V$ there is $c=c(U,V)$ with
$$|K_U(x)-K_V(x)|\le c\quad\text{for all }x,$$
and likewise $|K_U(x\mid y)-K_V(x\mid y)|\le c$ for all $x,y$. **The constant is
uniform in the arguments and depends only on the pair of machines.** (Confirmed against
the standard statement; the uniformity in $x$ is the whole content of the theorem and is
used repeatedly below.)

This immediately gives the tool we need:

> **Uniformity Lemma.** Let $F$ be any expression formed from finitely many terms
> $\pm K(\cdot)$, $\pm K(\cdot\mid\cdot)$. Then $F_U-F_V$ is bounded by $(\#\text{terms})\cdot c(U,V)$,
> **uniformly in all arguments**, *unless* the terms cancel identically, in which case the
> bound is $0$. Consequently: a statement about $F$ is machine-invariant iff it is
> invariant under adding an arbitrary constant $\le kc$ to $F$ — i.e. iff it is a statement
> about an *unbounded family*, never about a single value or a single sign.

That single lemma decides items 1–3 of the mandate. Its proof is one line (apply the
invariance theorem termwise and use the triangle inequality); its consequences are not.

---

## 1. Which claims survive the invariance theorem — the deliverable

I grade the four displayed objects on a single scale: how large is the machine-dependent
slack relative to the quantity being asserted?

### (I1) $\Delta\operatorname{Mystery}$ at fixed $X$ — **SURVIVES**, and is the only thing here that does

Fix $X$ and vary the language $\mathfrak L\to\mathfrak L'$. Then
$$
\Delta\operatorname{Mystery}
=\bigl[L(X)-L(X\mid\mathfrak L')\bigr]-\bigl[L(X)-L(X\mid\mathfrak L)\bigr]
= L(X\mid\mathfrak L)-L(X\mid\mathfrak L').
\tag{1.1}
$$
**The $L(X)$ term cancels identically.** By the Uniformity Lemma the surviving expression
has two terms, hence slack $\le 2c(U,V)$ uniform in $X,\mathfrak L,\mathfrak L'$. And the
quantity itself, $K(X\mid\mathfrak L)-K(X\mid\mathfrak L')$, is *unbounded* over choices of
the arguments. So statements of the form
$$
\text{"there are }X_n,\mathfrak L,\mathfrak L'\text{ with }\Delta\operatorname{Mystery}(X_n)\to\pm\infty\text{"}
$$
are machine-invariant, and are exactly the statements §F needs for (N). This is the
strongest position any of the four occupies, and it is worth naming *why*: $\Delta$
removed the unconditional term, so what is left is a comparison of two conditional
complexities of the *same object* — the canonical machine-invariant construction.

### (I2) $\operatorname{Mystery}(X)$ absolute — **survives only as an asymptotic**

Two terms, no cancellation: slack $\le 2c(U,V)$, uniform. Therefore
$\operatorname{Mystery}(X)$ is well-defined **up to $O(1)$**, and:

- *"$\operatorname{Mystery}(X)=0$"*, *"$\operatorname{Mystery}(X)>0$"*, *"$X$ is more
  mysterious than $Y$"* for fixed $X,Y$: **not machine-invariant, meaningless as written.**
  Given any $X$ with $\operatorname{Mystery}_U(X)=m$, one can choose $V$ universal with
  $\operatorname{Mystery}_V(X)$ differing by up to $2c(U,V)$, and $c(U,V)$ is under the
  adversary's control (pad the simulation program).
- *"$\operatorname{Mystery}(X_n)\to\infty$ along a family"*: **invariant.**

Note what this forbids: the *word* "conserved" in D0019 §F's section title. A conserved
quantity is one whose absolute value is meaningful across time; $\operatorname{Mystery}$'s
is not. What §F actually has is a quantity whose *increments* are meaningful — which is
"relocated" (also in the title) but not "conserved". §F's own title contains both words,
and only the second is defensible.

### (I3) $\operatorname{gain}(\sigma)>0$ — **DOES NOT SURVIVE under reading (K)**

$\operatorname{gain}$ has three terms with signs $+,-,-$: **nothing cancels.** Slack
$\le 3c(U,V)$. And (G) is used as a **sign test on a single $\sigma$**. By the Uniformity
Lemma this is precisely the class of statement that fails.

> **Proposition 1.** Under reading (K), for any $\sigma$ with $|\operatorname{gain}_U(\sigma)|$
> bounded, the truth value of "$\operatorname{gain}(\sigma)>0$" is not determined by the
> mathematics — it is determined by the choice of universal machine. Hence the
> sign-minting criterion (G) is *not well-defined* as a criterion on individual signs.
>
> *Proof.* Immediate from the Uniformity Lemma: the criterion asks the sign of a quantity
> defined up to an additive constant that can exceed its magnitude. $\square$

This is not a quibble about constants. (G) is offered as **the** operational rule of the
whole apparatus — "a sign is born iff it compresses structure" — and under the
Kolmogorov reading it births different signs on different machines, with no invariant
content. Under reading (C) with $L$ a *named* concrete code, gain is a determinate
integer and the criterion is well-defined; it is then no longer a universal notion but a
property of that code. **There is no third option.** This is the standard MDL trade-off
(Rissanen 1978; Grünwald 2007, on code-dependence of two-part MDL and the NML/luckiness
responses), and D0018 §A inherits it whole.

### (I4) $\mathfrak L^\star$, the argmin — **the weakest of the four**

The objective is a sum of three terms; slack $\le 3c(U,V)$ per candidate, **but the
constants for two different candidates need not be equal**, so the *ordering* of
candidates within a $6c(U,V)$-window is machine-dependent. The argmin is a **selection**,
not a limit, so it has no asymptotic form to retreat to:

> **Proposition 2.** Whenever two candidate languages have objective values within
> $6c(U,V)$, which of them is $\mathfrak L^\star$ is not machine-invariant. There is no
> family-of-objects rescue, because $\operatorname*{arg\,min}$ returns an object, not a
> number: "$\mathfrak L^\star=\mathfrak L_0$" is a single sign test in disguise.

So the ranking, which is the deliverable:

| object | slack | invariant statements | verdict |
|---|---|---|---|
| $\Delta\operatorname{Mystery}$ at fixed $X$ | $2c$, and $L(X)$ cancels | unbounded families; sign when the gap $\gg c$ | **survives** |
| $\operatorname{Mystery}(X)$ | $2c$ | $\operatorname{Mystery}(X_n)\to\infty$ only | survives as asymptotic only |
| $\operatorname{gain}(\sigma)>0$ | $3c$ | none for a single $\sigma$ | **fails under (K)**; well-defined under (C) with $L$ named |
| $\mathfrak L^\star$ | $3c$ per candidate, ordering unstable | none | **fails; no asymptotic form exists** |

**Standing check (c).** This table refutes nothing in D0019 §J6, which said exactly
"only differences at fixed $\mathfrak L$ are comparable". It sharpens it in two places
J6 did not reach: (i) it is differences at fixed **$X$**, varying $\mathfrak L$, that are
good — J6's phrase has the fixity on the wrong argument, since at fixed $\mathfrak L$ and
varying $X$ nothing cancels; and (ii) the failure propagates to (G) and (A), which J6
did not connect to the hazard it recorded.

---

## 2. Is $\Delta\operatorname{Mystery}=-\Delta\operatorname{Compression}$ a tautology?

**Worse than a tautology: it is a tautology under one reading of "Compression" and false
under the other, and the transmission fixes neither.**

Write $S:=L(X)-L(X\mid\mathfrak L)$ for the *saving* $\mathfrak L$ buys on $X$, and
$R:=L(X\mid\mathfrak L)$ for the *residual* description length.

- **Reading A: $\operatorname{Compression}:=S$.** Then $\operatorname{Mystery}=S=\operatorname{Compression}$
  identically, so $\Delta\operatorname{Mystery}=+\Delta\operatorname{Compression}$, and (M)
  asserts $\Delta S=-\Delta S$, i.e. $\Delta S=0$. **(M) is then false** except in the
  trivial case.
- **Reading B: $\operatorname{Compression}:=R$**, the compressed length. Then
  $\operatorname{Mystery}=L(X)-R$ and $\Delta\operatorname{Mystery}=\Delta L(X)-\Delta R$.
  (M) holds **iff $\Delta L(X)=0$**, i.e. iff the variation is in $\mathfrak L$ alone at
  fixed $X$ — which is exactly the regime (I1) identified as the invariant one. Under
  that side condition (M) is a **rearrangement of the definition and says nothing further.**

> **Proposition 3.** (M) is a tautology on the nose in Reading B restricted to
> $\Delta L(X)=0$, is false in Reading B when $X$ varies, and is false in Reading A. It
> carries no content in any reading.

**And a defect in the definition itself, reported because deriving requires it.** In (M)
as written, $\operatorname{Mystery}(X)=L(X)-L(X\mid\mathfrak L)$ is the *information
$\mathfrak L$ carries about $X$* — the standard quantity $I(\mathfrak L:X)$ (Li–Vitányi
§2.8; symmetric up to logarithmic terms by Levin–Gács). It is **large exactly when
$\mathfrak L$ explains $X$ well.** So the quantity named "mystery" is the mystery
*dispelled*, not the mystery *remaining*. The remaining mystery is $R=L(X\mid\mathfrak L)$.
The sign is backwards relative to the word, and relative to §F's own gloss ("knowledge
growth = relocation of mystery").

I do not rewrite the owner's definition. I record the repair the owner may take or
refuse: **with $\operatorname{Mystery}^{\mathrm{rem}}(X):=L(X\mid\mathfrak L)$**, the word
matches the object, (M) becomes $\Delta\operatorname{Mystery}^{\mathrm{rem}}=-\Delta S$ —
still a tautology, but now a *correctly signed* one — and (I1)'s invariance verdict is
unchanged, since $\Delta\operatorname{Mystery}^{\mathrm{rem}}=-\Delta\operatorname{Mystery}$
at fixed $X$. Every result in this note holds under either convention.

### 2.1 The substantive claim, adjudicated

D0019 §J6 says the real claim is **knowledge growth $\not\Rightarrow$ mystery decrease**.
Adjudicating it in $\operatorname{Mystery}^{\mathrm{rem}}$ (the only reading under which
the claim is not a sign confusion):

> **Theorem 1 (the claim is TRUE, and its truth splits in two).** Let $\mathfrak L\to\mathfrak L'$
> be a language change.
>
> **(a) Cumulative growth: the claim FAILS up to $O(1)$.** If $\mathfrak L$ is recoverable
> from $\mathfrak L'$ by a program of length $\le b$, then
> $K(X\mid\mathfrak L')\le K(X\mid\mathfrak L)+b+O(1)$ for every $X$: mystery cannot
> increase by more than $b+O(1)$. *Proof.* Prepend the recovery program to an optimal
> $\mathfrak L$-conditional program for $X$. $\square$
>
> **(b) Non-cumulative growth: the claim HOLDS, and unboundedly.** If $\mathfrak L'$ is a
> *replacement* rather than an extension, $K(X\mid\mathfrak L')-K(X\mid\mathfrak L)$ is
> unbounded above. *Proof.* Take $\mathfrak L=X$ itself (so $K(X\mid\mathfrak L)=O(1)$)
> and $\mathfrak L'$ any string with $K(X\mid\mathfrak L')\ge K(X)-O(1)$, which exists
> since almost all strings carry no information about $X$ by a counting argument
> (Li–Vitányi §2.2). The gap is $K(X)-O(1)$, unbounded over $X$. $\square$
>
> By (I1) both halves are machine-invariant statements, since both concern the cancelling
> two-term expression (1.1) and both are unbounded.

**So the adjudication is: §F's boxed claim is a theorem, and it is precisely the failure
of monotonicity of $K(\cdot\mid y)$ in $y$ under *replacement* of the condition rather
than *extension* of it.** That is a known and elementary fact about conditional
complexity; the transmission's contribution is to name it as a law of knowledge growth,
which is legitimate and is not a new theorem. It also gives §F's own machine a sharp
warning: the fleet's $\mathfrak L_{\alpha+1}=\mathfrak C(\mathfrak L_\alpha\cup\lceil\Delta_\alpha\rceil)$
(D0018 §A) is a *cumulative* colimit, so by Theorem 1(a) **the transmission's own
language ladder is in the regime where mystery cannot grow** — §F's claim is true in
general but does not apply to the construction §A builds, unless $\mathfrak C$ (the
closure operator) is allowed to discard. That is a real tension between two sections of
the same corpus, and I flag it rather than resolve it: **the missing datum is whether
$\mathfrak C$ is conservative.**

The second reading of "$\Delta\operatorname{Reach}>0\Rightarrow$ new mystery may be born"
— that the *index set* of objects enlarges, so $\sum_X L(X\mid\mathfrak L)$ grows even
when every term falls — is also true, and trivially so: its content is carried entirely
by the quantifier over the enlarged domain, not by any property of description length.
Both readings are true; neither is deep; (b) is the only one with mathematical substance.

---

## 3. Does the argmin exist?

The mandate anticipated "the argmin is not known to exist and here is the missing
hypothesis." **That is not what I find.** Existence is cheap; it is *definiteness* that
fails, and the missing hypothesis is not compactness.

> **Theorem 2 (existence, and it is elementary).** Let $\mathbb{L}$ be the class of
> candidate languages and $\Phi(\mathfrak L):=L(\mathfrak L)+L(\mathfrak Q\mid\mathfrak L)+L(\Pi\mid\mathfrak L)$.
> Suppose
> **(H1)** $\Phi$ takes values in $\mathbb N\cup\{\infty\}$ (true for any code-length
> reading, (K) or (C)); and
> **(H2)** $\Phi(\mathfrak L_0)<\infty$ for at least one $\mathfrak L_0\in\mathbb L$.
> Then $\min_{\mathfrak L}\Phi$ **exists and is attained.**
>
> *Proof.* $\{\Phi(\mathfrak L):\mathfrak L\in\mathbb L\}\cap\mathbb N$ is a non-empty
> subset of $\mathbb N$ by (H1)+(H2), hence has a least element by well-ordering; any
> $\mathfrak L$ realising it is a minimiser. No topology, no compactness, no lower
> semicontinuity, no cardinality bound on $\mathbb L$ is used — **integrality does all the
> work.** $\square$

D0018 §J7's complaint ("no argument the argmin exists") is therefore **discharged**, and
discharged by a proof shorter than the complaint. But three things replace it, and they
are worse:

> **Theorem 3 (non-uniqueness, always).** Under (H1)–(H2) the minimiser is essentially
> never unique. If $\mathfrak L$ attains the minimum and the coding of languages admits any
> length-preserving relabelling $\pi$ with $\Phi(\pi\mathfrak L)=\Phi(\mathfrak L)$ and
> $\pi\mathfrak L\ne\mathfrak L$ — e.g. permuting the codewords assigned to two signs of
> equal length that occur equally often in the optimal descriptions of $\mathfrak Q$ and
> $\Pi$ — then $\pi\mathfrak L$ is another minimiser. Hence
> $\operatorname*{arg\,min}$ is a **set**, and "$\mathfrak L^\star=\dots$" as a definite
> description is unjustified notation.

**Missing hypothesis, named:** a *tie-breaking rule* — a total order on $\mathbb L$
refining $\Phi$, or a quotient of $\mathbb L$ by the relabelling groupoid. The
transmission supplies neither. (This is the same disease as D0019 §C's own
$\operatorname{UniversalityTest}$ middle branch, *$\exists\widehat X$ noncanonical* — and
it is pleasing that §A's flagship functional lands in the branch §C names as deficient.)

> **Theorem 4 (the value is attained but the object is machine-dependent).** By
> Proposition 2, the *identity* of a minimiser is not invariant. So even after
> tie-breaking, $\mathfrak L^\star$ names different languages on different universal
> machines whenever the top of the field is within $6c(U,V)$.

**Scope limit on Theorem 2, stated because it is exactly the kind of hypothesis that gets
dropped.** (H1) fails for the real-valued MDL objectives actually used in practice —
$-\log$ of a prior, Rissanen's stochastic complexity, NML — where $\Phi$ is
$\mathbb R_{\ge0}$-valued and the infimum over an infinite candidate class **need not be
attained.** For those, compactness or lower semicontinuity is genuinely required and
genuinely absent here. So the honest verdict is conditional:

**Verdict (item 3): the minimum exists and is attained under the code-length reading, by
well-ordering of $\mathbb N$ — no topology needed. It is not unique, and no tie-breaking
rule is supplied. Its identity is not machine-invariant. Under a real-valued objective,
existence is genuinely open and the missing hypotheses are compactness or lower
semicontinuity of $\Phi$ on $\mathbb L$.**

---

## 4. Is $\operatorname{gain}$ well-founded? Could a language mint signs forever?

I read `notes/ADVANCE_CONJUNCTS_DEFINED.md` in the relevant sections (§6.4, §9,
Propositions 4–5) rather than trusting a summary. **Proposition 5 is as the mandate
describes it, and I verified its proof:** Definition 4 there satisfies (C1)–(C3) and
evades Theorem U **iff $L$ is declared before the run**; if $L$ may be chosen at or after
the step, then for any step introducing a new $\sigma$ one may choose $L$ giving $\sigma$
a short code and $\mathfrak Q\mid\sigma$ a shorter description, making
$\operatorname{gain}(\sigma)>0$ **by construction at every step**, violating (C4). Its
"if" direction is the observation that with $L$ fixed, $\operatorname{gain}$ is a
determinate integer-valued function of the two stages and both signs occur. That note
also records (§9) that **nothing in the Advance language produces a well-founded measure**,
citing Floyd 1967 and the standard requirement of a strictly decreasing map into a
well-founded order.

Against that background, here is the answer to "could a language mint signs forever with
positive gain each time" — and it is a positive result.

> **Theorem 5 (the mint is finite).** Let $L$ be a prefix code (reading (C), or reading
> (K) with $L=K$ prefix complexity), fixed in advance, and let $\mathfrak Q$ be fixed.
> Then
> $$\#\{\sigma:\operatorname{gain}(\sigma)>0\}<2^{L(\mathfrak Q)}.$$
> *Proof.* $\operatorname{gain}(\sigma)>0$ forces $L(\sigma)<L(\mathfrak Q)-L(\mathfrak Q\mid\sigma)\le L(\mathfrak Q)$,
> since code lengths are non-negative. By Kraft's inequality $\sum_\sigma 2^{-L(\sigma)}\le1$,
> so $\#\{\sigma:L(\sigma)<n\}<2^{n}$. Take $n=L(\mathfrak Q)$. $\square$

> **Theorem 6 (the iterated criterion carries a well-founded measure).** Let $L$ be fixed
> in advance and define the criterion *relative to the current stage*,
> $$\operatorname{gain}_\alpha(\sigma):=L(\mathfrak Q\mid\mathfrak L_\alpha)-L(\mathfrak Q\mid\mathfrak L_\alpha,\sigma)-L(\sigma),$$
> minting one $\sigma$ per step with $\operatorname{gain}_\alpha(\sigma)>0$, under
> **(H3)** $L(\mathfrak Q\mid\mathfrak L_\alpha\cup\{\sigma\})=L(\mathfrak Q\mid\mathfrak L_\alpha,\sigma)$
> and **(H4)** $L(\sigma)\ge1$. Then
> $$\mu(\alpha):=L(\mathfrak Q\mid\mathfrak L_\alpha)\in\mathbb N$$
> **strictly decreases**: $\mu(\alpha+1)<\mu(\alpha)-L(\sigma)+1\le\mu(\alpha)$. Hence the
> minting process terminates after at most $L(\mathfrak Q\mid\mathfrak L_0)$ steps.
> $\mu$ is a well-founded measure for sign-minting.

So the answer to the mandate's question is **no — gain does not suffer the defect,
provided both side conditions hold**, and the two conditions are different in kind:

1. **$L$ fixed in advance** (Prop. 5's condition — it defeats *post-hoc gaming*);
2. **$L$ concrete and named** (the invariance condition of §1 — it defeats *machine
   arbitrariness*).

(2) does not follow from (1): one can declare in advance "let $L=K_U$ for some universal
$U$ to be named later" and satisfy Prop. 5 while failing (I3) entirely. **Prop. 5's side
condition is necessary and not sufficient; §1 supplies the missing half.** That is this
note's principal correction to `ADVANCE_CONJUNCTS_DEFINED` §6.4, and it is a
strengthening of its own conclusion, not a refutation.

**Three ways the finiteness is lost — all realised in the transmissions.**

- **(L1) $\mathfrak Q$ grows.** Theorem 5's bound is $2^{L(\mathfrak Q)}$. D0019 §F's
  $\Delta\operatorname{Reach}>0$ and §G's $\mathcal Q_{\alpha+1}=\operatorname{diag}(\lceil\operatorname{Answer}(\mathcal Q_\alpha)\rceil)$
  both grow the question space by design. With $\mathfrak Q_\alpha$ growing, the bound grows
  and **unbounded minting is consistent with the criterion.** This is not a flaw in
  gain — it is the precise mechanism by which §F's "new mystery may be born" is
  compatible with §A's minting rule, and it is the one place where the two sections lock
  together rather than merely coexist.
- **(L2) $L$ varies with $\alpha$.** Prop. 5 applies verbatim: the criterion becomes true
  by construction and both theorems collapse. And $L$ *wants* to vary, since $L$ is a code
  and the language is what is changing — resisting this is a real design constraint on
  §A, not a technicality.
- **(L3) Several signs minted per step.** Theorem 6 assumes one. Gains are not additive
  ($\sigma,\tau$ may encode the same regularity), so $\sum\operatorname{gain}>0$ does not
  give descent of $\mu$; only the *joint* gain of the batch does. `ADVANCE_CONJUNCTS_DEFINED`
  Definition 4 sums individual gains over $\mathfrak L_{\alpha+1}\setminus\mathfrak L_\alpha$
  and therefore inherits this gap. **Named, not filled.**

**What is machine-invariant in Theorems 5–6.** The *finiteness* is: for any two fixed
prefix codes the mint-set is finite under both. The *cardinality*, the *identity* of the
minted signs, and the *number of steps* are not. So even the good news obeys §1: the
qualitative fact survives, the number does not. This is `CLAUDE.md`'s rule appearing from
the other side — a bound whose $\mathfrak Q$-dependence is stated ($2^{L(\mathfrak Q)}$) is
knowledge; the same bound quoted as a number would not be.

---

## 5. Are $\rho(D\mathcal K)$ and $\chi_\alpha$ the same quantity?

Neither is rehabilitated, measured, or used as support for anything above. The question
D0019 §J5 raised is answered and nothing more.

$\chi_\alpha=\Delta\operatorname{Reach}(\mathcal O_\alpha)/\Delta\operatorname{Kill}(\Gamma_\alpha)$
is a **ratio of two scalar increments**; $\rho(D\mathcal K)$ is the **modulus of the
largest eigenvalue of the linearisation of an operator at a point.** These are different
types — a quotient of two numbers versus a spectral invariant of a linear map — and there
is no reading on which the second reduces to the first, since a spectral radius of a
rank-$\ge2$ operator is not any ratio of its data.

> **Verdict, one sentence with its ground: $\rho(D\mathcal K)$ and $\chi_\alpha$ are
> *not* the same quantity — they differ in type (scalar ratio vs. spectral invariant of a
> linearisation), and in any case two quantities neither of which has a definition cannot
> be proved equal, so the identification asserted in D0019 §J5 is itself unfounded; what
> they genuinely share is the *template* — a trichotomy at $1$ with a "golden boundary"
> reading — which is a shared hazard, not a shared definition.**

**Standing check (d): this is a false-ground finding, not a false-claim finding.** J5's
*disposition* ("not to be measured; either $\mathcal K$ gets a domain, a norm and a
linearisation, or the quantity is withdrawn") is correct and I endorse it unchanged. Only
its stated ground — "*$\chi_\alpha$ returning under a new name*" — is wrong. The right
ground is the one J5 gives two sentences later and does not connect: *none of
$\mathcal K$'s domain, norm, linearisation, or basepoint is specified.* That ground is
sufficient on its own and does not require the identification.

---

## 6. Prior art (searched before writing, per `CLAUDE.md`)

Nothing in §§1–4 is new mathematics. Recorded so that no reader mistakes it for such:

- **Invariance theorem** with argument-uniform constant: Solomonoff (1964), Kolmogorov
  (1965), Chaitin (1969); Li–Vitányi, *An Introduction to Kolmogorov Complexity and Its
  Applications*, Thm. 2.1.1 and §3.1 for the conditional/prefix versions.
- **$I(y:x)=K(x)-K(x\mid y)$ as "information in $y$ about $x$"**, and its symmetry up to
  logarithmic terms (Levin–Gács, Chaitin): Li–Vitányi §2.8. This is §F's
  $\operatorname{Mystery}$ exactly, under the name it has had since 1974.
- **Kraft's inequality** and the counting bound $\#\{x:L(x)<n\}<2^n$: standard; Cover–Thomas
  §5.2. Theorem 5 is this bound and nothing else.
- **MDL, two-part codes, code-dependence of the criterion, NML and luckiness as responses**:
  Rissanen (1978); Barron–Rissanen–Yu (1998); Grünwald, *The Minimum Description Length
  Principle* (2007). §1's verdict on (G) and (A) is the textbook caution about two-part
  MDL, applied to the transmission's functional.
- **Well-founded measures vs. step predicates**: Floyd (1967), Turing (1949), as already
  cited in `ADVANCE_CONJUNCTS_DEFINED` §9. Theorem 6 supplies for gain what that note
  proved unavailable for $\operatorname{Advance}$ — with the explanation that gain is not
  a function of resolving power, which is exactly why Theorem U does not reach it.
- **In-repo**: `notes/ADVANCE_CONJUNCTS_DEFINED.md` (Prop. 4, Prop. 5, §6.4, §9) is the
  only prior corpus treatment of $\operatorname{gain}$; it stated Definition 4 as a
  conditional and adopted nothing. No prior note treats $\operatorname{Mystery}$, (M),
  (N), or the argmin. No PDF was read.

---

## 7. Scope limits, and the generalisation offered for audit

**Scope limits.**

1. Everything assumes $L$ is a *code length* — non-negative, Kraft-summable. If $L$ is
   anything else (a real-valued penalty, a description "length" in a non-binary or
   continuous sense), Theorems 2, 5, 6 all lapse; Theorem 2 lapses at (H1), Theorems 5–6
   at Kraft.
2. Theorem 6 needs (H3), that conditioning on the enlarged language equals conditioning
   on the pair. Under (K) this holds up to $O(1)$ — and an $O(1)$ per step accumulates over
   $\alpha$ steps, so **Theorem 6 is a clean theorem under (C) and only an $O(\alpha)$-slack
   statement under (K).** I do not claim the (K) version.
3. Theorem 6 mints one sign per step; (L3) is unfilled.
4. §2.1's Theorem 1 says nothing about *which* regime the fleet's ladder is in, because
   whether $\mathfrak C$ is conservative is not determined by D0018 §A. Flagged as the
   missing datum, not assumed either way.
5. I have not adjudicated D0019 §§A–E, G or D0018 §§B–D; other notes hold those.
6. No $\chi_\alpha$ or $\rho(D\mathcal K)$ was defined, measured, estimated, or used.

**The generalisation, stated so it can be audited (standing check (e)).**

> Across these four objects, the machine-dependence is not a uniform blemish: it is
> **exactly proportional to how many non-cancelling $L$-terms the expression carries, and
> whether the assertion is a limit or a selection.** Two cancelling terms and an unbounded
> family ⇒ invariant; three terms and a sign test ⇒ meaningless; a selection ⇒ beyond
> rescue. The corollary for this corpus is a rule of thumb with a proof behind it: **an
> MDL formula is worth writing down iff every unconditional $L$ in it cancels.** Of the
> four displayed, exactly one passes, and it is the one D0019 §J6 had already half-identified.

Audit note on that generalisation: it is a claim about *this* fleet's four formulas,
proved for each; I have not tested it against MDL expressions with logarithmic correction
terms (where a $\log$ can outgrow $c(U,V)$ and rescue a three-term expression along a
family), and it should be expected to have exceptions there. Its domain is: expressions
in finitely many $L$-terms with no growing parameter.

---

## 8. Addendum, 2026-08-15 (seed-kolmogorov): the invariance theorem is now a checked term, and the threshold in row 1 of §1's table is exactly $2c$

*Added by addition, per `CLAUDE.md`. Nothing in §§0–7 is altered or deleted. This
section records one formalisation, one sharpening of a constant that §1 left
qualitative, and one audit result on the note itself.*

**The term.** `formal/cubical/InvarianceConstant.agda`, `--cubical --guardedness
--safe --no-import-sorts`, no postulates, no holes, no `TERMINATING`. Verified
`EXIT=0` in this container under **both** Agda 2.6.3 + cubical v0.5 (`/usr/bin/agda`)
and the `BUILD.md` pin Agda 2.8.0 + cubical v0.9 (the §6.1 recipe of
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md`). Registered in `Everything.agda`; that
aggregate remains red under 2.6.3 for the pre-existing `SymGroup` skew
(`TOOLCHAIN_SKEW_AND_COVERAGE` §1), which this module neither causes nor repairs.

**Scope of the formalisation, stated first because it is the thing that gets
dropped.** A universal machine cannot be built in `--safe` cubical Agda and none
is attempted. What is formalised is the abstract content of the theorem, which is
what remains after universality has done its only job: `Simulates c f g :=
∀x. f x ≤ g x + c` is a *hypothesis*, and universality is precisely what supplies
two such hypotheses in the classical proof. Everything downstream of that point is
in the module. So: universality unformalised and named; the theorem formalised.

| §0–7 statement | term in `InvarianceConstant.agda` |
|---|---|
| Invariance theorem, constant uniform in the argument | `invariance`, `invariance∃`; the uniformity is the quantifier order in `Within` |
| $c$ is not unique, and chains of "up to $O(1)$" accumulate | `within-refl` (at 0), `within-sym`, `within-trans` (constants **add**), `within-mono` |
| Uniformity Lemma, additive half ($k$ terms ⇒ $kc$) | `within-+` |
| (I1)'s cancellation: $L(X)$ is *gone*, not small | `Cancellation.ΔMystery-indep`, proved by `refl` — cancellation is a fact about the syntax, which is why it costs $0$ and not $c$ |
| (I2): no absolute value is invariant | `absolute-not-invariant`: for any $f$ and any $c\ge1$ there is a $g$ within $c$ of $f$ disagreeing at **every** object |
| §1 table row 1: "sign when the gap $\gg c$" | `shorter-needs-margin` — see below |

**The sharpening, and it is a correction of exactly the kind this note is about.**
§1's table licenses a sign "when the gap $\gg c$". $\gg$ is not a threshold, and
the threshold is derivable, so by this corpus's own rule the note should not have
left it qualitative. It is **$2c$, and $2c$ is sharp**:

> **Theorem 7 (`shorter-needs-margin`).** If $\operatorname{Within}c(f,g)$ and
> $f(x)+2c<f(y)$, then $g(x)<g(y)$.
> *Proof.* $g(x)+c\le f(x)+2c<f(y)\le g(y)+c$; cancel $c$. $\square$
> (`weak-margin` gives the $\le$ version from $f(x)+2c\le f(y)$.)
>
> **Sharpness, both sides, by finite exhaustive verification on $X=\{0,1\}$ at
> $c=1$** — admissible as proof under `CLAUDE.md`'s exact/certified clause, and
> checked, not asserted:
> - **At gap $=2c$** (`Sharp2c`): $f=(0,2)$, $g=(1,1)$ are within $1$, the
>   $f$-gap is exactly $2$, and $g(x)=g(y)$. So the conclusion cannot be
>   strengthened to `<`.
> - **At gap $=2c-1$** (`SharpBelow2c`): $f=(0,1)$, $g=(1,0)$ are within $1$,
>   $f(x)<f(y)$, and $g(y)<g(x)$. **The order reverses.** So the threshold cannot
>   be lowered by even one bit.
>
> `threshold-sharp` bundles the two.

The reason the constant is $2c$ and not $c$ is worth stating in words, because it
is the error a reader makes unaided: the slack is spent *twice*, once pushing
$f(x)$ up to $g(x)$ and once pulling $f(y)$ down to $g(y)$. Nothing in §§0–7 is
wrong; row 1 was merely vague where it could have been exact, and that is the
defect this note was written to catch, appearing in the note that explains it —
in its mildest available form (a missing factor of 2 inside a $\gg$), but present.

**This also confirms and explains §1's Proposition 2.** Proposition 2 quotes a
$6c(U,V)$ window for the argmin. That is *not* an independent constant: the
objective (A) has three non-cancelling terms, so per-candidate slack is $3c$ by
`within-+`, and Theorem 7 doubles it. $6c=2\cdot 3c$. Proposition 2's constant is
exactly right and is now derived rather than quoted. Symmetrically, row 1's
two-term slack $2c$ gives threshold $4c$ **if one compares two $\Delta$'s**; the
$2c$ above is the threshold for comparing two raw costs within $c$. Which one
applies depends on what is being compared, and that is the whole point: *the
constant is not a property of the quantity, it is a property of the comparison.*

**Audit of this note against its own rule (mandate item 3): PASSES.** I checked
every numeral in §§0–7. There is no bare description length, no compression
ratio, and no fitted anything. Every slack is written $2c$, $3c$, $6c$ with
$c=c(U,V)$ named and its dependence on the machine pair explicit; Theorem 5's
bound is $2^{L(\mathfrak Q)}$ with the $\mathfrak Q$-dependence carried in the
statement, and §4 says in terms that the *cardinality* is not invariant while the
*finiteness* is. That is the corpus rule obeyed, not violated. The single
qualitative constant in the note is the $\gg$ of §1's table, sharpened above; it
is a vagueness, not a fitted number, and it is now a theorem.

**Scope limits of §8.**
1. Costs are $\mathbb N$-valued in the module. §7's scope limit 1 therefore
   applies verbatim: nothing here covers real-valued MDL objectives.
2. `Within` is subtraction-free (a pair of $\le$'s) rather than $|\cdot|\le c$
   over $\mathbb Z$. The two are equivalent on $\mathbb N$; no truncated
   subtraction lemma is used, and no $\mathbb Z$ is imported.
3. The module formalises §1 and the arithmetic behind §1's table. Theorems 1–6
   of §§2–4 are **not** formalised — Theorems 5 and 6 need Kraft's inequality and
   a stage-indexed conditional code, neither of which is in the module. Their
   status is unchanged: proved in prose here, unchecked by machine.
4. `Cancellation.ΔMystery-indep` is `refl`. It is included because the fact that
   it *is* `refl` is the content (nothing to cancel means nothing to bound), not
   because the proof was difficult.

---

*Method ledger. No experiment was run; no Python; no Agda or Lean authored; no numerical
computation; no constant fitted. Theorems 1–6, Propositions 1–3: this note. Proposition 5
of `ADVANCE_CONJUNCTS_DEFINED.md` was verified by reading its statement and proof, not
cited from summary. The invariance theorem's argument-uniform constant was checked against
the standard statement before being used. Owner artifacts D0018 and D0019 are derived from
and quoted, never edited.*

*Ledger amendment, 2026-08-15 (seed-kolmogorov). The ledger above is left standing
because it is true of §§0–7, which is what it was written about. It is **not** true
of §8: §8 authored Agda (`formal/cubical/InvarianceConstant.agda`) and ran a
typechecker. Still no Python, no experiment, no numerical computation, no fitted
constant; the two finite verifications in §8 are exhaustive over a two-element type
and are checked by the kernel, not printed by a script.*
