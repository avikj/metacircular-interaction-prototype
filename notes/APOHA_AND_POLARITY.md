# Apoha and polarity: CONVERGENCE, not a new result

**CONVERGENCE.** D0020 §5's apoha display and §7's two-sided evaluation are the
**same closure operator** this repository already proved theorems about in
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md` (2026-08-14), Proposition 6.3 — the
Birkhoff polarity closure $A(S)=\{t:\ \sim_S\subseteq\ \sim_{\{t\}}\}$ of the
formal context $(X\times X,\ \mathcal T,\ R^{c})$. Nothing below is offered as a
new theorem. The dictionary is exhibited in §2, and §4 records the two places
where the transmission's version genuinely differs — one of which makes one of
its own displays vacuous.

**Adjudicated at the request of** D0020 §J3
(`collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md`), which
asked for exactly this verdict and predicted it. It is confirmed, with one
correction to §J3's own pointer (§3).

**Status of every claim below:** definitional unfolding and standard
lattice theory. No experiment, no measurement, no fitted constant, no
floating-point number, no Python. No Agda or Lean was authored or typechecked.

---

## 0. The two transmission displays, quoted

**§5 (दर्शनमण्डलम्, बौद्ध, apoha):**

$$
\llbracket\text{गो}\rrbracket=\neg\llbracket\text{अगो}\rrbracket,\qquad
\alpha^\perp:=\{\tau\mid\tau\ \text{अल्फेतरविभेदकः}\},\qquad
\boxed{\ \alpha\longmapsto\alpha^{\perp\perp}\ }
$$

**§7 (सन्धान–विघ्न–नवव्याकरणम्, "Two-sided evaluation, and the polarity closure
again"):**

$$
\epsilon:\chi^+\times\chi^-\to\vartheta;\quad
\alpha^\perp:=\{\kappa\mid\forall\xi\in\alpha:\epsilon(\xi,\kappa)=1\};\quad
\boxed{\ \alpha\mapsto\alpha^{\perp\perp}\ };\quad
\boxed{\text{साक्षी}\leftrightarrow\text{प्रतिसाक्षी}}
$$

Both are present in the archive as transcribed. **Standing check on the
archive.** D0020's own preamble warns that it is "structurally faithful but not
display-complete" and that runs of standard displays are elided `[…run…]`; §5
and §7 carry no such marker at the apoha and two-sided-evaluation displays, so
these two are transcribed in full. I report that; I do not conclude from any
absence elsewhere.

---

## 1. What the repository already has

Two closure operators, and the corpus was already careful to keep them apart.

**(i) The monotone one, holonomy-relative.** `CHANGING_TESTS_VERSUS_SHRINKING.md`
Theorem B: $\delta_\sigma\dashv\delta^{*}_\sigma$ is a **monotone** Galois
connection, and

$$C_\sigma(S)=\{\,t\in\mathcal T:\ \forall x,\ t\in D_\sigma(x)\Rightarrow D_\sigma(x)\cap S\ne\emptyset\,\}$$

— *the tests redundant given $S$*. This is **not** a polarity: it is the
composite of an adjoint pair of *monotone* maps.

**(ii) The antitone one, holonomy-free.** Same note, Proposition 6.3:

$$A(S):=\{\,t\in\mathcal T:\ \sim_S\ \subseteq\ \sim_{\{t\}}\,\},\qquad
A(S)=\bigcap_{\mathfrak h\in\operatorname{Aut}(X)}C_{\mathfrak h}(S),$$

stated there to be "the derivation-closure of the formal context
$(X\times X,\mathcal T,R^{c})$ with $R^{c}=$ '$t$ does not separate the pair'".
$A$ is the composite of two **antitone** maps. This is the Birkhoff polarity.

That the two are different, and that conflating them is an error, is not my
observation: it is `CHANGING_TESTS_VERSUS_SHRINKING.md` §0.4, which corrects
`notes/SHRINKING_TESTS_LOWER_CURVATURE.md` Remark 2.2 for calling
$(\operatorname{Sep},\sim)$ "the standard Birkhoff polarity" when
$\operatorname{Sep}$ is monotone. §0.4's repair — *$\sim_{(-)}$ is one half of
the Birkhoff polarity of the complementary relation $R^{c}$* — is precisely the
half the transmission is writing.

---

## 2. The dictionary

Take the transmission's §7 datum $\epsilon:\chi^+\times\chi^-\to\vartheta$ and
its incidence $I:=\epsilon^{-1}(1)$. Then $\alpha\mapsto\alpha^{\perp}$ is
verbatim the derivation operator $(-)'$ of the formal context $(\chi^+,\chi^-,I)$
(Wille 1982), and $\alpha\mapsto\alpha^{\perp\perp}$ is the extent closure.

**Substitute:**

| transmission | repository |
|---|---|
| $\chi^+$ (witnesses, साक्षी) | $X\times X$, ordered pairs of points |
| $\chi^-$ (counter-witnesses, प्रतिसाक्षी) | $\mathcal T$, the tests |
| $\epsilon(\xi,\kappa)=1$ | $R^{c}$: $e(x,t)=e(x',t)$, "$t$ does **not** separate the pair" |

Then, unfolding both sides:

- For $S\subseteq\chi^-=\mathcal T$:
  $S^{\perp}=\{(x,x'):\forall t\in S,\ e(x,t)=e(x',t)\}\ =\ \sim_S$ — the
  repository's separation relation (H2), unchanged.
- $S^{\perp\perp}=\{t:\forall (x,x')\in\ \sim_S,\ e(x,t)=e(x',t)\}
  =\{t:\ \sim_S\subseteq\ \sim_{\{t\}}\}\ =\ A(S)$.

$$\boxed{\ \alpha\mapsto\alpha^{\perp\perp}\ \text{on the }\chi^-\text{ side}\ =\ A,\ \text{Prop. 6.3 of }\texttt{CHANGING\_TESTS\_VERSUS\_SHRINKING.md}\ }$$

The $\chi^+$-side closure is the mirror half of the same polarity (the set of
pairs identified by every test that identifies all of $\alpha$); the repository
used only the $\chi^-$ half, and the other half is free.

**Idempotence.** $\perp$ is antitone with $\alpha\subseteq\alpha^{\perp\perp}$
and $\alpha^{\perp}=\alpha^{\perp\perp\perp}$, so $\perp\perp$ is extensive,
monotone and idempotent — a closure operator, for any $\epsilon$ whatsoever.
So the answer to §J3's "is the closure idempotent?" is **yes, unconditionally**,
and no hypothesis on $\epsilon$ is needed.

**Is it three-place / non-symmetric?** §7's $\epsilon$ is two-place; the two
sorts $\chi^\pm$ are distinct, which is the ordinary asymmetry of a formal
context (objects vs. attributes) and not a difference. §6 *does* carry an
**indexed** family $\epsilon_\iota(\xi,\kappa)$ — a genuinely three-place datum
— but it flattens: put $\hat\epsilon(\xi,(\iota,\kappa)):=\epsilon_\iota(\xi,\kappa)$
on $\chi^+\times(I\times\chi^-)$. Since
$\alpha^{\hat\perp}=\coprod_\iota\{\iota\}\times\alpha^{\perp_\iota}$, one gets

$$\alpha^{\hat\perp\hat\perp}=\bigcap_{\iota}\ \alpha^{\perp_\iota\perp_\iota},$$

which is Definition B.3's $C(S)=\bigcap_\sigma C_\sigma(S)$ in the polarity
case. So the indexed version is covered too, and it *explains* — rather than
re-proves — B.3's flagged remark that idempotence of the intersection "does not
follow from intersecting closure operators in general": here it does, because
the intersection is itself the double-polar of the disjoint-union context.
That explanation is a re-derivation of a fact the repository already proved by
the tupled adjunction; I claim no more for it than that.

**Verdict:** same closure operator, under the dictionary above. Recorded as
convergence.

---

## 3. Correction to §J3's pointer

§J3 says the construction "is exactly the Galois connection of
`notes/SHRINKING_TESTS_LOWER_CURVATURE.md` and
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md`". Read strictly this is wrong in one
half and right in the other, and the wrong half is a display the corpus has
already repaired.

- `SHRINKING_TESTS_LOWER_CURVATURE.md` Rmk. 2.2 is the display §J3 is pointing
  at, and it is **the one corrected** by `CHANGING_TESTS_VERSUS_SHRINKING.md`
  §0.4 as not a polarity. Citing it as the polarity repeats the corrected error.
- The correct target is `CHANGING_TESTS_VERSUS_SHRINKING.md` **Prop. 6.3**, the
  closure $A$. That note's own §3 Theorem B closure $C_\sigma$ — which §J3 then
  quotes, "tests redundant given $S$" — is the **monotone** one and is *not*
  what $\alpha\mapsto\alpha^{\perp\perp}$ is.

The two are reconciled, not opposed, by Prop. 6.3's identity
$A=\bigcap_{\mathfrak h}C_{\mathfrak h}$: the polarity closure is the
holonomy-**uniform** intersection of the redundancy closures. So:

> **Answer to §J3's question** ("does the apoha reading illuminate that
> $\delta$ is a left adjoint and $C_\sigma(S)$ is redundancy?"). It does not
> illuminate the left adjoint at all — the left adjoint is monotone and apoha is
> antitone. What it does is **select which of the corpus's two closures is the
> polarity one**, and that selection was already the subject of a correction
> (§0.4). §J3 predicted the correspondence would be "purely formal"; it is, with
> that one non-decorative consequence.

No corpus result is amended by this note; §0.4 already stands as written.

---

## 4. Where the transmission's version genuinely differs

Two places. The first is the only sharp finding here.

### 4.1 §5's own gloss makes §5's own boxed display vacuous

§5 writes two things in one breath: $\llbracket\text{गो}\rrbracket=\neg\llbracket\text{अगो}\rrbracket$
(the popular double-negation gloss, Boolean complement in a pre-given universe)
and $\alpha^\perp:=\{\tau\mid\tau\text{ is a differentiator of what is other
than }\alpha\}$ with the boxed $\alpha\mapsto\alpha^{\perp\perp}$.

Take the first display literally as the definition of the second. Then
$\chi^+=\chi^-=X$ and $\epsilon(\xi,\kappa)=1$ iff $\xi\ne\kappa$, so

$$\alpha^{\perp}=\{\kappa:\forall\xi\in\alpha,\ \kappa\ne\xi\}=X\setminus\alpha,
\qquad \alpha^{\perp\perp}=X\setminus(X\setminus\alpha)=\alpha.$$

**The closure is the identity map.** Under §5's own Boolean gloss the boxed
display carries exactly zero content — every set is closed, the concept lattice
is the whole powerset, and $\perp\perp$ says nothing about anything.

So $\alpha\mapsto\alpha^{\perp\perp}$ is a non-trivial operator **precisely when
$\epsilon$ is not inequality on a pre-given universe** — that is, precisely when
the "other" is *not* uniform. Which is the doctrinal content of Dignāga PS(V)
V.25cd–38 as reported in `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` §2
(synonyms need not exclude one another; sub- and superordinate terms interact
asymmetrically; incompatible coordinate terms exclude directly). §5's two
displays therefore pull against each other: the first is the gloss the tradition
rejects, the second is non-vacuous only if the first is false.

This is not a new argument in the corpus, only a new route to it.
`notes/EXCLUSION_IS_NOT_AN_OPERATOR.md` (genius-02, 2026-08-14, Agda
`--cubical --safe`, exit 0) reached the same conclusion from the other end: on
$\mathrm{Eq}(X)$, the repository's actual meaning-carriers, the Boolean gloss is
type-incorrect and the relative-pseudo-complement repair **fails** for
$|X|\ge3$ (T3), while exclusion does exist relative to a declared vocabulary
(T4a) and not beyond it (T4b). The present §4.1 adds only that on
$\mathcal P(X)$ — where the Boolean gloss *is* type-correct — the operator
exists and is trivial. Between the two: the gloss is either vacuous or
unavailable. Both are already-owned results; the pairing is the only thing new
and it is one line of unfolding.

### 4.2 The value set is discarded, and the corpus owns the discarding

§7 gives $\epsilon:\chi^+\times\chi^-\to\vartheta$ — many-valued, into the
rationals of §1's tower — but $\alpha^\perp$ reads only the fibre
$\epsilon^{-1}(1)$. The construction therefore factors through a binarisation
and the rest of $\vartheta$ is inert. That is not an error, but it is not a
generalisation either, and the theory of exactly this coarsening is already
proved: `SHRINKING_TESTS_LOWER_CURVATURE.md` Theorem 3 (resolution
monotonicity) treats $\pi:Q\to Q_r$ and shows $\delta$ is monotone under
coarsening of the value set, with the exact difference set. A $\vartheta$-valued
$\epsilon$ collapsed to a two-valued incidence is that theorem's setting with
$\pi=\mathbf 1_{\{1\}}$.

### 4.3 What is *not* a difference

Checked and negative, because §J3 asked specifically:

- **Three-place?** Only §6's $\epsilon_\iota$, and it flattens to a two-place
  polarity (§2). Not a difference.
- **Non-symmetric?** The $\chi^+/\chi^-$ asymmetry is the object/attribute
  asymmetry of any formal context. Not a difference.
- **Non-idempotent?** No. $\perp\perp$ is a closure operator for every
  $\epsilon$ (§2). Not a difference.

---

## 5. Prior art, searched before write-up

Web search only; I opened no PDF and read no primary text. Everything below is
cited from search-result summaries and is graded accordingly. Earliest source
named for each claim.

- **The polarity of a binary relation, and the induced closure operators:**
  **G. Birkhoff, *Lattice Theory*, AMS Colloquium Publications XXV, 1940.**
  Search summary: "Garrett Birkhoff observed that any binary relation between
  two sets determines a Galois connection between the powersets, or equivalently
  closure operators on the powersets … he named the binary relations
  polarities." This is the earliest source for §2's construction and for
  idempotence. *(Cited from summary; Birkhoff 1940 not read.)*
- **Extension to arbitrary posets, and the name:** **Ø. Ore, "Galois
  Connexions", Trans. AMS 55 (1944).** Search summary: "Ore extended Birkhoff's
  notion to arbitrary posets and called them Galois connexions." The repository
  already cites Ore 1944 for "the composite of an adjoint pair is a closure
  operator" (`CHANGING_TESTS_VERSUS_SHRINKING.md` §10). *(Cited from summary.)*
- **The derivation operators of a formal context $(G,M,I)$ and the concept
  lattice:** **R. Wille, "Restructuring lattice theory: an approach based on
  hierarchies of concepts", in I. Rival (ed.), *Ordered Sets*, Reidel, 1982,
  pp. 445–470.** This is the earliest source for the FCA form used in §2's
  table; Ganter–Wille 1999 is the textbook. *(Cited from summary.)*
- **Apoha, the doctrine:** **Dignāga, *Pramāṇasamuccaya(vṛtti)* V.2–11 and
  V.25cd–38** (c. 5th–6th c. CE) — the earliest source; V.11
  *tenānyāpohakṛc chrutiḥ*. **Dharmakīrti, *Pramāṇavārttika* I.115–121,
  III.165–173** (7th c.). All Sanskrit and all verse attributions here are
  carried from `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` §§2–3 and
  `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §2.1, which are the corpus's own
  source-critical notes. **I read no primary or secondary text.**
- **Modern formal treatments of apoha:** **H. Herzberger, 1975** ("resourceful
  nominalism", via Post's theory of twofold propositions), located by
  `EXCLUSION_IS_NOT_AN_OPERATOR.md` §4.3 and not read by anyone in this chain;
  and the collection **Siderits–Tillemans–Chakrabarti, *Apoha: Buddhist
  Nominalism and Human Cognition*, Columbia UP, 2011**, named from general
  knowledge and not located in this search.
- **Apoha identified with an FCA/Birkhoff polarity closure specifically:**
  **nothing located.** Query
  *"apoha Dignaga formal semantics double exclusion closure operator Galois
  connection formal concept analysis"* returned the apoha double-negation gloss
  and the FCA/Galois material as two separate bodies, with the search's own
  summary stating that "the specific connections between Dignāga's apoha theory
  and modern formal concept analysis frameworks with Galois connections are not
  explicitly addressed in these particular sources." **Absence of a located
  source is not evidence of novelty** — and here it does not matter, because
  this note claims no novelty for the identification: it is recording that a
  transmission arrived at a construction the repository had already proved
  theorems about.

---

## 6. Scope limits

- **This note proves nothing.** It is an identification plus an unfolding.
  The theorems it cites — Prop. 6.3, Theorem B, Def. B.3, Theorem 3, T3/T4a/T4b
  — are proved elsewhere and are not re-proved here; I read them in full and
  re-derived §2's two unfoldings by hand, and nothing else.
- **§4.1's collision is between two *displays*, not a refutation of anything.**
  I do not claim the owner intends the Boolean gloss as the definition of
  $\perp$; I claim that if it is read as one, the boxed display is the identity.
  The owner holds the original and the archive is a transcription.
- **The doctrinal half is not mine and is not verified.** Every claim about what
  Dignāga or Dharmakīrti says is carried from two corpus notes, both of which
  flag their own source limits. I read no Sanskrit text and no translation.
- **The $\chi^+$-side closure is not analysed.** §2 identifies it as the mirror
  half; the repository has never used it, and I do not know whether it has
  content on the pair-context $(X\times X,\mathcal T,R^c)$ beyond the obvious.
  Tagged `PROVE` if anyone wants it.
- **Untouched:** everything else in D0020. §J1's $\mathfrak{sl}_2$ action
  (the transmission's own first-class `PROVE` item), §J2's number tower,
  §J4's splicing defect $\curlywedge_{\Sigma_1}$, §J5, §J6, §J7's unmeasured
  quantities, §J8's $\Theta_\infty$. Nothing here bears on any of them.
- **No machine verification, no computation, no measurement, no Python.**

---

*Question and framework: the repository owner, D0020 §5, §7 and §J3, 2026-08-15.
Earlier result converged upon: `notes/CHANGING_TESTS_VERSUS_SHRINKING.md`
Prop. 6.3, 2026-08-14; with `notes/SHRINKING_TESTS_LOWER_CURVATURE.md`
(2026-08-14) and its §0.4 correction, and `notes/EXCLUSION_IS_NOT_AN_OPERATOR.md`
(genius-02, 2026-08-14). Recorded as convergence.*
