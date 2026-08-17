# The splicing defect $\curlywedge_{\Sigma_1}$, adjudicated against D0019 §D's $\delta_{\mathfrak T}$

**Source of the question.** The human owner,
`collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md` **§7**
(सन्धान–विघ्न–नवव्याकरणम्), which displays

$$
\omega_{02}^{\text{साक्षात}}\ \text{(direct)};\qquad
\omega_{02}^{\text{सन्धान}}:=\int^{\Sigma_1}\omega_{01}\otimes\omega_{12}\ \text{(spliced through }\Sigma_1)
$$
$$
\boxed{\ \curlywedge_{\Sigma_1}:=\omega_{02}^{\text{साक्षात}}-\omega_{02}^{\text{सन्धान}}\ }
$$

and the owner's triage **§J4**, which asserts: *"§7's splicing defect $\curlywedge_{\Sigma_1}$ is
new and distinct from D0019 §D. D0019's $\delta_{\mathfrak T}$ measures failure of composition
of translations; this measures whether an intermediate object is sufficient — direct versus
spliced-through-$\Sigma_1$. That is a Segal/descent condition, not an associator, and
`notes/TRANSLATION_GERBE_ADJUDICATED.md`'s verdicts do not transfer automatically. Checkable."*

The framework, the notation and the triage are the owner's. Nothing below amends the artifact.
§J9's guard is in force, and §5's own rule — **समता प्रमाणेन, साम्येन न**, *equality by proof,
not by resemblance* — is the standard this note is held to, in both directions: a claimed
identity of two defects must be a proved natural isomorphism, and a claimed distinctness must
be a witness, not a difference of glyph.

**Substrate.** Reading and pen. No Python written, modified or executed; no `MATH_ALLOW_PYTHON`.
No Agda or Lean authored, none typechecked. No PDF decoded, no external fetch this pass. Every
classical fact used is named and is standard; no theorem number is quoted from an unread source.

seed181, 2026-08-15.

---

## 0. Verdict, stated first

| claim | status |
|---|---|
| $\curlywedge_{\Sigma_1}$ and $\delta_{\mathfrak T}$ are **distinct**, as §J4 asserts | **Not proved, and the stated ground is false** (§3). No witness exists in the archive because no *instance* exists in the archive. |
| $\curlywedge_{\Sigma_1}$ and $\delta_{\mathfrak T}$ are **identical** | **Not proved either** (§2). $\omega_{ij}$ — the two-index $\omega$ — **is undefined in D0020 and in every prior transmission.** This is the missing definition. |
| §J4's ground: "$\delta_{\mathfrak T}$ is an associator" | **Refuted** (Prop. 3.1). §D contains no quadruple index and hence no associator at all; $\delta_{\mathfrak T}$ is the cofibre of the **compositor**, i.e. of exactly the direct-versus-composite comparison. Both objects compare a composite with a direct. |
| §J4's ground: "the coend makes it a Segal/descent condition rather than §D's kind of object" | **Refuted** (Prop. 3.2). §D fixes **no ambient bicategory** (`TRANSLATION_GERBE_ADJUDICATED.md` §1). $\mathbf{Prof}$ is therefore an admissible ambient for §D, and in $\mathbf{Prof}$ composition **is** the coend $\int^{b}P(a,b)\otimes Q(b,c)$. A coend in the definiens is a fact about how the ambient composes, not about which defect is being taken. |
| Under (H) — the unique reading on which §7's display denotes — the two are **naturally isomorphic** | **Refuted** (Thm 4.2 + Witness 4.3). |
| Under (H): $\curlywedge_{\Sigma_1}$ is the **class of $\delta_{\mathfrak T}$ in $K_0$** of the hom-category; $\delta_{\mathfrak T}\simeq0\Rightarrow\curlywedge_{\Sigma_1}=0$, converse false | **Proved** (Thm 4.2), with an explicit two-line witness in $D^b(\mathrm{Vect}_k)$ (4.3). |
| $\Sigma_1$ is a free variable of $\curlywedge_{\Sigma_1}$ | **Refuted as displayed** (Prop. 1.1). $\Sigma_1$ is *bound* in the definiens and *free* in the definiendum: variable capture. The subscript is either vacuous or the integral is not a coend. |
| §7's minus sign is a step forward from D0019 §D's $\operatorname{cofib}$ | **Refuted** (Cor. 4.4). It is a regression to D0017 §C's additivity requirement, which `TRANSLATION_GERBE_ADJUDICATED.md` Prop. 4.2 credited D0019 with removing. |
| §7's coend passes the occurrence test that D0016 §B's failed | **Yes, conditionally** (Prop. 2.2) — and the condition forces $\omega_{ij}$ to be a *two-variable kernel*, not a defect. |

**Overall.** The two objects cannot be proved equal and cannot be proved distinct, because
$\omega_{ij}$ has no definition; *an undefined quantity cannot be proved equal to anything, nor
unequal to anything.* But the disposition is **not** symmetric agnosticism. Under the only
reading that makes the display denote at all, the two are the **same comparison morphism**,
packaged twice — once as a cofibre (D0019) and once as a difference (D0020) — and the second
packaging is the first one decategorified. The residual distinctness that survives is therefore
real but is the *opposite* of §J4's: not "two different conditions", but **one condition measured
by a coarser invariant that loses information**, with the implication running
$\delta_{\mathfrak T}\simeq0\Rightarrow\curlywedge=0$ and not back.

---

## 1. What the archive actually displays, read before it is interpreted

### 1.1 The two-index $\omega$ occurs exactly three times, all inside §7, and is never defined

Searched across `collab/upstream/raw/` (grep, this pass). $\omega$ carries a subscript in
exactly these forms:

- **§0**, defined: $\boxed{\omega_\chi:=\delta(\partial\chi)}$ — **one** subscript, and it is an
  *object* $\chi$, not an index. This is the transmission's only definition of the glyph.
- **§6**, defined: $\omega_{\iota\kappa\lambda}:=\eta_{\iota\kappa\lambda}-1$ where
  $\eta_{\iota\kappa\lambda}:=\tau_{\lambda\iota}\tau_{\kappa\lambda}\tau_{\iota\kappa}$ —
  **three** subscripts, a loop holonomy defect on the net $\circledast$.
- **§10**: $\omega_{\text{विश्व}}$ — one subscript, an object, instance of §0.
- **§7**: $\omega_{01},\ \omega_{12},\ \omega_{02}$ — **two** subscripts. **Nowhere defined,
  here or in D0016–D0019.**

### Proposition 1.1 (variable capture in the boxed display)
As displayed, $\Sigma_1$ is a bound variable of $\omega_{02}^{\text{सन्धान}}$ and a free variable
of $\curlywedge_{\Sigma_1}$.

*Proof.* $\int^{\Sigma_1}$ binds $\Sigma_1$; the resulting object depends on the *category* over
which the coend is taken, not on any particular $\Sigma_1$. Hence
$\omega_{02}^{\text{साक्षात}}-\omega_{02}^{\text{सन्धान}}$ contains no free occurrence of
$\Sigma_1$, while the definiendum $\curlywedge_{\Sigma_1}$ displays one. $\square$

**Corollary 1.2 (the two readings, and the archive does not choose).**
Either

- **(R-coend)** the integral is a genuine coend over a category of intermediates, and then
  $\curlywedge$ carries *no* dependence on $\Sigma_1$ — the subscript is decoration and the object
  measures whether the *whole family* of intermediates suffices; or
- **(R-fixed)** $\Sigma_1$ is a fixed intermediate object and the integral is not a coend but a
  pairing/tensor at that object, in which case $\int^{\Sigma_1}$ is a misuse of the coend symbol
  (it is the coend over the one-object discrete category, i.e. just $\otimes$).

§7's prose ("spliced through $\Sigma_1$") and §J4's gloss ("whether an *intermediate object* is
sufficient") both read **(R-fixed)**; the display reads **(R-coend)**. This is standing check (c)
— a summary refuted by its body — running between a display and its own gloss. **I do not choose
for the owner.** §2 proceeds under (R-coend), because it is the only reading on which the coend
denotes and hence the only one under which anything can be proved.

### 1.3 Transcription status of §7, reported and not concluded from

D0020's preamble marks §§1, 2 and 4 as abbreviated runs (`[…run…]`). **§7 carries no such mark**
and is displayed apparently in full. That makes it *more likely*, not certain, that the absence of
a definition of $\omega_{ij}$ within §7 is faithful. But §2 **is** a marked run, and §2 is where
the natural home of a two-index $\omega$ lies: it contains the spin-foam gluing
$\boxed{\Phi_{\Omega_1\cup_\Sigma\Omega_2}=\int_{\psi_\Sigma}\Phi_{\Omega_2}\Phi_{\Omega_1}\,\delta\psi_\Sigma}$,
which is §7's splicing display in physics dress. **A definition of $\omega_{ij}$ may have been
dropped from §2's abbreviated run. I report the absence; I do not conclude from it.** The owner
holds the original, and if such a definition exists this note's §2–§4 must be re-run against it.

---

## 2. Hypotheses: the unique reading on which §7's display denotes

### 2.1 The occurrence test, applied

`notes/OBSTRUCTION_COEND_REPAIR.md` §0.1 (seed180, this corpus) re-derived the standing
requirement: $\int^{c\in\mathcal C}F(c,c)$ denotes only for
$F:\mathcal C^{op}\times\mathcal C\to\mathcal D$, the coend being the coequalizer of
$\coprod_{u:c\to c'}F(c',c)\rightrightarrows\coprod_cF(c,c)$; the two parallel maps act on one of
**two** occurrences of the bound variable. D0016 §B's $\int^\sigma\delta_\sigma$ **failed** this
test — one occurrence.

### Proposition 2.2 (§7's coend passes, and the passing has a price)
In $\int^{\Sigma_1}\omega_{01}\otimes\omega_{12}$ the bound index $1$ occurs **twice** — once as
the second index of $\omega_{01}$, once as the first of $\omega_{12}$. The display therefore
passes the occurrence test **provided** $\omega_{01}$ is contravariant and $\omega_{12}$
covariant in that index. Equivalently: $\omega_{ij}$ must be a **profunctor**
$\omega_{ij}:\mathfrak L_i^{op}\times\mathfrak L_j\to\mathcal V$ (a two-variable kernel), not a
morphism $\mathfrak L_i\to\mathfrak L_j$ and not an object.

*Proof.* Immediate from the coequalizer above, matching variances. $\square$

**Remark 2.2.1 — this is a genuine credit, and a genuine cost.** Credit: §7's coend is
*better-formed* than D0016 §B's, and that should be recorded as an improvement in the
transmissions, exactly as `TRANSLATION_GERBE_ADJUDICATED.md` §4.2 recorded $\operatorname{cofib}$
as one. Cost: the only reading that makes it denote types $\omega_{ij}$ as a **kernel**, whereas
the glyph $\omega$ is the transmission's own glyph for a **defect** ($\omega_\chi=\delta\partial\chi$,
§0; $\omega_{\iota\kappa\lambda}=\eta-1$, §6). Under (H) the $\omega_{ij}$ of §7 are *not* defects
in the transmission's sense; they are the things whose composite one takes a defect *of*. The
glyph is overloaded, as is $\curlywedge$ itself (§2's constraint anomaly $\curlywedge_{\Theta\Theta}$
and §7's $\curlywedge_{\Sigma_1}$ are unrelated objects sharing a symbol; §J5 treats the former).

### (H) — the standing hypothesis for §§3–4

**(H1)** There is a bicategory $\mathcal B$ whose objects are the interfaces $\Sigma_i$
($=\mathfrak L_i$ in D0019's notation) and whose 1-cells $\mathcal B(\Sigma_i,\Sigma_j)$ are the
$\omega_{ij}$, with composition computed by the coend of Prop. 2.2. Canonically:
$\mathcal B=\mathbf{Prof}$, or a bicategory of bimodules/amplitudes, which is what §2's gluing
display and §7's प्रोसे both point at.

**(H2)** The hom-categories $\mathcal B(\Sigma_i,\Sigma_k)$ are **additive** (indeed stable). This
is not optional: §7 writes a **minus sign**, and subtraction of 1-cells is available in no
weaker setting. Cf. `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §1 on D0017 §C's minus.

**(H3)** D0019 §D is read with its forced repair, `TRANSLATION_GERBE_ADJUDICATED.md` Cor. 4.1.1:
the comparison $\alpha_{ijk}:\mathfrak T_{jk}\mathfrak T_{ij}\Rightarrow\mathfrak T_{ik}$ is a
**chosen, not-necessarily-invertible** 2-cell, and
$\delta_{\mathfrak T}:=\operatorname{cofib}(\alpha_{ijk})$. Without this repair §D is empty
(Prop. 4.1 there: line 1 forces $\delta_{\mathfrak T}\equiv0$), and an empty object is trivially
distinct from everything, which would settle §J4 for the wrong reason.

Every statement in §§3–4 carries (H). **(H) is mine, not the archive's.** Its status is: the
weakest set of choices under which both displays denote simultaneously. That there is essentially
only one such set is itself the finding of §1–§2.

---

## 3. §J4's ground is false, and this is provable without (H)

### Proposition 3.1 ($\delta_{\mathfrak T}$ is not an associator)
D0019 §D contains no quadruple index anywhere; hence it contains no associator, no tetrahedron
and no coherence 3-cell. $\alpha_{ijk}$ is the **compositor** — the comparison of the composite
$\mathfrak T_{jk}\mathfrak T_{ij}$ with the direct $\mathfrak T_{ik}$ — and $\delta_{\mathfrak T}$
is its cofibre. Therefore $\delta_{\mathfrak T}$ *is itself* a direct-versus-composite defect.

*Proof.* By inspection of §D's four displays (read in full, lines 95–119 of the D0019 archive):
the indices occurring are $i,j$ (on $\mathfrak T$) and $i,j,k$ (on $\delta$). This is the finding
already recorded at `TRANSLATION_GERBE_ADJUDICATED.md` Prop. 5.1, where the *absence* of the
quadruple condition is proved load-bearing: without it there is no cocycle, no class, and
$\operatorname{Hol}_{\mathbb G}$ depends on bracketing. An associator is precisely the datum §D
lacks. $\square$

**So §J4's contrast — "a Segal/descent condition, not an associator" — contrasts $\curlywedge$
with something D0019 §D does not contain.** $\delta_{\mathfrak T}=0$ is likewise a Segal-type
condition: it says the composite-through-$j$ comparison to the direct is an equivalence. The two
objects are on the same side of the contrast §J4 draws.

### Proposition 3.2 (the coend does not distinguish)
§D fixes **no ambient bicategory** (`TRANSLATION_GERBE_ADJUDICATED.md` §1, which supplies
$\mathcal B$ as a hypothesis precisely because §D does not). Hence $\mathbf{Prof}$ is an
admissible ambient for §D. In $\mathbf{Prof}$, composition of 1-cells is *by definition* the
coend $(Q\circ P)(a,c)=\int^{b}P(a,b)\otimes Q(b,c)$ (Bénabou; standard). Therefore, in that
admissible ambient, §D's composite $\mathfrak T_{jk}\circ\mathfrak T_{ij}$ **is literally** §7's
$\int^{\Sigma_1}\omega_{01}\otimes\omega_{12}$.

*Proof.* Substitution. $\square$

**Corollary 3.3.** "One is a coend, the other is a composition" is not a distinction between two
defects. It is a distinction between two *notations for composition in the ambient*, and §D's
ambient is unfixed, so the notation of §7 is one of §D's own available readings. A distinctness
claim resting on it is a claim about glyphs — **साम्येन**, resemblance-reasoning run in the
negative direction, which §5's rule forbids as firmly as it forbids the positive direction.

### 3.4 What would have been a witness, and why the archive contains none

§J4 says "Checkable." To check it one needs an instance: a triple $(\Sigma_0,\Sigma_1,\Sigma_2)$
with $\omega_{01},\omega_{12},\omega_{02}^{\text{साक्षात}}$ exhibited, on which one defect vanishes
and the other does not. The archive supplies **no instance of $\omega_{ij}$ at all** — not one,
in any section, in any of the five transmissions. There is therefore no witness to be found and
none to be constructed: not because the search failed, but because the domain of the search is
empty. **This is the same disposition as `TRANSLATION_GERBE_ADJUDICATED.md` Cor. 2.3 gave to "is
$\mathbb G$ a gerbe?" and as D0019 §J5 gave to $\rho(D\mathcal K)$: under-specified definition,
not open conjecture.** And it is the disposition this fleet failed to hold once, when
$\rho(D\mathcal K)$ and $\chi_\alpha$ were treated as candidates for identification although
neither is defined; the correction is recorded at `notes/SURVIVING_LADDER_FRAGMENT.md` (scope
limits) and `TRANSLATION_GERBE_ADJUDICATED.md` §6, and is not repeated here.

**The missing definition, stated in one line, which is what this note owes the owner:**

> **$\omega_{ij}$ — the two-index $\omega$ of §7 — has no definition in the archive. Give it a
> type (object of $\mathcal B$? 1-cell $\Sigma_i\to\Sigma_j$? profunctor
> $\Sigma_i^{op}\times\Sigma_j\to\mathcal V$?) and §7 becomes checkable in a page. Prop. 2.2 shows
> only the third makes the boxed display denote.**

---

## 4. What *can* be proved: under (H), one comparison, packaged twice

### 4.1 Both displays name the same morphism

Under (H1) put $\alpha_{012}:\omega_{02}^{\text{सन्धान}}\Rightarrow\omega_{02}^{\text{साक्षात}}$
for the comparison of the spliced 1-cell with the direct one. This is D0019 §D's compositor
(Prop. 3.1) and it is the only morphism §7's display can be about, since §7 offers nothing else
relating its two objects. So:

$$\delta_{\mathfrak T}=\operatorname{cofib}(\alpha_{012}),\qquad
\curlywedge_{\Sigma_1}=\omega_{02}^{\text{साक्षात}}-\omega_{02}^{\text{सन्धान}} .$$

### Theorem 4.2 ($\curlywedge$ is the $K_0$-shadow of $\delta_{\mathfrak T}$)
Assume (H). Write $\mathcal H:=\mathcal B(\Sigma_0,\Sigma_2)$, a stable (hence additive) category,
and $K_0(\mathcal H)$ its Grothendieck group. Then:

1. The expression $\omega_{02}^{\text{साक्षात}}-\omega_{02}^{\text{सन्धान}}$ does not denote an
   **object** of $\mathcal H$ — objects of an additive category do not subtract — but denotes an
   element of $K_0(\mathcal H)$.
2. In $K_0(\mathcal H)$,
   $$\boxed{\ \curlywedge_{\Sigma_1}=[\delta_{\mathfrak T}]\ }$$
   i.e. $\curlywedge$ is exactly the class of the cofibre.
3. Consequently $\delta_{\mathfrak T}\simeq0\ \Rightarrow\ \curlywedge_{\Sigma_1}=0$.

*Proof.* (1) is the definition of an additive category: hom-sets are abelian groups, object-sets
are not. (2) In a stable category every cofibre sequence
$A\xrightarrow{\alpha}B\to\operatorname{cofib}(\alpha)$ is exact, and $K_0$ is generated by
objects modulo $[B]=[A]+[\operatorname{cofib}\alpha]$; with $A=\omega_{02}^{\text{सन्धान}}$,
$B=\omega_{02}^{\text{साक्षात}}$ this is $[B]-[A]=[\operatorname{cofib}\alpha]$, which is the
display. (3) $[0]=0$. $\square$

This is precisely `TRANSLATION_GERBE_ADJUDICATED.md` Prop. 4.2(2)–(3) read in the other
direction: that note proved D0017's minus sign is the *additive special case* of D0019's
$\operatorname{cofib}$; D0020 §7 writes the minus sign again, so §7 is the additive special case
of §D. **The two displays are the same defect, one of them decategorified.**

### 4.3 Witness: the converse of 4.2(3) fails

Take $\mathcal H=D^b(\mathrm{Vect}_k)$, $k$ a field — a stable category with
$K_0\cong\mathbb Z$ by Euler characteristic. Take
$\omega_{02}^{\text{सन्धान}}=\omega_{02}^{\text{साक्षात}}=k$ (concentrated in degree $0$) and
$\alpha_{012}=0$. This is admissible under (H3): the comparison 2-cell is chosen and not assumed
invertible. Then
$$\operatorname{cofib}(0)=k\oplus k[1]\ \not\simeq\ 0,\qquad
\chi(k\oplus k[1])=1-1=0 .$$

So $\delta_{\mathfrak T}\ne0$ while $\curlywedge_{\Sigma_1}=0$. $\square$

**This is the witness §J4 asked for, and it establishes a distinctness — but not §J4's.** It shows
$\curlywedge$ is a *lossy invariant of $\delta_{\mathfrak T}$*: the splicing datum can be
insufficient ($\alpha$ not an equivalence, the intermediate $\Sigma_1$ genuinely failing) while
$\curlywedge$ reports $0$ and calls $\Sigma_1$ "पर्याप्तम (sufficient)". §7's own conditional
$\curlywedge_{\Sigma_1}=0\Rightarrow\Sigma_1\ \text{पर्याप्तम}$ is therefore **unsound under (H)**,
in the direction that matters: it certifies sufficiency it has not established. The sound half is
the contrapositive, $\curlywedge_{\Sigma_1}\ne0\Rightarrow\Sigma_1$ insufficient, which does
follow from 4.2(3).

### Corollary 4.4 (§7 is a regression on the one point D0019 was credited for)
`TRANSLATION_GERBE_ADJUDICATED.md` §4.2 credited D0019 §D with replacing D0017 §C's minus by
$\operatorname{cofib}$, the credit being that $\operatorname{cofib}$ needs only pointedness plus
pushouts on hom-categories, whereas the minus needs $\mathbf{Ab}$-enrichment. D0020 §7 writes the
minus. By 4.2(1) the ambient must be additive again, and by 4.3 the invariant is strictly weaker.
**The fleet's earlier objection to the minus sign, answered by D0019, is re-opened by D0020 §7.**
The repair is one line and is the owner's own: write
$\curlywedge_{\Sigma_1}:=\operatorname{cofib}(\alpha_{012})$.

### Corollary 4.5 (no natural isomorphism, and none is to be sought)
Under (H) there is no natural isomorphism $\curlywedge\cong\delta_{\mathfrak T}$: they are not
even objects of the same kind (an element of $K_0$ versus an object of $\mathcal H$). The
comparison that *does* exist is the class map $\mathcal H\to K_0(\mathcal H)$, which is natural
in the triple $(\Sigma_0,\Sigma_1,\Sigma_2)$ because $K_0$ is functorial for exact functors and
$\alpha_{012}$ is natural in the triple by construction. That map is the whole relation, and it is
not invertible. $\square$

---

## 5. Answer to §J4, in the form it was asked

> *"§7's splicing defect $\curlywedge_{\Sigma_1}$ is new and distinct from D0019 §D."*

- **"New":** the *notation* is new; the *comparison* is not (Prop. 3.1, 3.2). Under (H) it is
  D0019 §D's comparison computed in an ambient where composition is a coend.
- **"Distinct":** **not proved, and its stated grounds are false.** The distinction offered —
  Segal/descent versus associator — misdescribes $\delta_{\mathfrak T}$, which is not an
  associator; and the coend is a property of the ambient's composition, which §D leaves free.
- **A distinctness that *is* proved, under (H):** $\curlywedge$ is the decategorification of
  $\delta_{\mathfrak T}$; one-directional implication with an explicit witness for the failure of
  the converse (Thm 4.2, 4.3). The direction of loss makes §7's sufficiency conditional unsound.
- **Unconditionally:** neither identity nor distinctness is provable from the archive, because
  $\omega_{ij}$ is undefined (§3.4). Define $\omega_{ij}$ and every statement above becomes a
  finite check.
- **`TRANSLATION_GERBE_ADJUDICATED.md`'s verdicts:** §J4 is right that they "do not transfer
  automatically" — but the reason is not that the objects differ. Four of them transfer *under
  (H)*, with proof, and are used above: Prop. 4.1 (line-1/line-2 inconsistency, whose analogue
  §7 avoids by not asserting $\simeq$ — a genuine improvement), Cor. 4.1.1 (the chosen non-invertible
  2-cell, needed here as (H3)), Prop. 4.2 (minus versus cofibre, which is the crux), Prop. 5.1
  (no associator). One does **not** transfer and should not be assumed to: Thm 2.1's "no site"
  verdict says nothing about §7, which makes no gerbe claim.

---

## 6. Scope: what this note does not settle

- **Everything in §§2–5 is conditional on (H)**, which is my hypothesis, not the owner's. If the
  owner supplies a definition of $\omega_{ij}$ incompatible with Prop. 2.2's profunctor typing,
  §§4–5 lapse entirely and only §1 and §3 survive.
- **I do not choose between (R-coend) and (R-fixed)** (Cor. 1.2). The proofs above are run under
  (R-coend); under (R-fixed) the symbol $\int^{\Sigma_1}$ is simply wrong and §7 needs re-display
  before anything can be said. Prop. 1.1 stands under both.
- **§2's abbreviated run may contain the missing definition** (§1.3). Absence reported, not
  concluded from. This note must be re-run if the owner's original defines $\omega_{ij}$.
- **$\curlywedge_{\Theta\Theta}$ (§2's constraint-algebra anomaly) is untouched.** It shares only
  the glyph. §J5 disposes of it correctly and nothing here bears on it.
- **$\tau_\star:=\Gamma\langle\curlywedge_{\Sigma_1}\rangle$ and the closure
  $\kappa_{\nu+1}:=\overline{\kappa_\nu\cup\{\tau_\star\}}$ are untouched.** They inherit
  `notes/ORDINAL_LADDER_SMALLNESS.md` Thm 1 ($\Gamma$ is not a function) verbatim, as §J8 already
  says of $\Theta_\infty$; I add nothing and cite rather than redo, per §J8's own instruction.
- **§5's $\Delta_{\lambda\mu}(\chi):=\tau_{\mu\lambda}\tau_{\lambda\mu}(\chi)-\chi$** is a *third*
  translation-defect in D0020 — a round-trip defect, shape distinct from both objects adjudicated
  here — and is **not** examined. Whether it too collapses onto $\delta_{\mathfrak T}$ is open and
  is the obvious successor item.
- **No prior-art search was run on "Segal condition for profunctor composition"** beyond the
  standard facts named (Bénabou's composition coend; $K_0$ of a stable category). The two
  classical facts used are textbook and I claim no novelty for any of §4; the novelty claimed is
  only the *adjudication*.
- **No numerical computation, no measurement, no fitted constant** appears above, and none was
  needed: every statement is a typing argument or a two-line exact witness.

## 7. Ledger

| Claim | Status | Where |
|---|---|---|
| $\omega_{ij}$ (two-index) is defined in the archive | **Refuted** — three occurrences, all in §7, no definition anywhere | §1.1 |
| $\curlywedge_{\Sigma_1}$'s subscript is a free variable | **Refuted** — bound in the definiens | Prop. 1.1 |
| §7's coend passes the occurrence test | **Proved, conditionally** — iff $\omega_{ij}$ is a profunctor | Prop. 2.2 |
| $\delta_{\mathfrak T}$ is an associator (§J4's ground) | **Refuted** — §D has no quadruple index | Prop. 3.1 |
| The coend distinguishes the two defects (§J4's ground) | **Refuted** — §D fixes no ambient; $\mathbf{Prof}$ composes by that coend | Prop. 3.2 |
| A witness for §J4's distinctness exists in the archive | **Refuted** — no instance of $\omega_{ij}$ exists | §3.4 |
| $\curlywedge_{\Sigma_1}=[\delta_{\mathfrak T}]$ in $K_0$; $\delta_{\mathfrak T}\simeq0\Rightarrow\curlywedge=0$ | **Proved** under (H) | Thm 4.2 |
| Converse | **Refuted**, explicit witness in $D^b(\mathrm{Vect}_k)$ | 4.3 |
| §7's $\curlywedge=0\Rightarrow\Sigma_1$ sufficient | **Unsound** under (H); contrapositive sound | 4.3 |
| §7's minus improves on §D's $\operatorname{cofib}$ | **Refuted** — regression to D0017's additivity | Cor. 4.4 |
| $\curlywedge\cong\delta_{\mathfrak T}$ naturally | **Refuted** — different kinds of object; the class map is the whole relation | Cor. 4.5 |
| The two are distinct | **Not proved** unconditionally; under (H), distinct *as invariants*, by decategorification — not as §J4 states | §5 |
