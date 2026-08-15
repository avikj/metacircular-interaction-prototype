# The closure tower collapses at stage one

**Audit of the seed-grammar transmission $\Theta_0$, 2026-08-15.**
Source preserved verbatim at
[`notes/SEED_GRAMMAR_TRANSMISSION_SOURCE.md`](SEED_GRAMMAR_TRANSMISSION_SOURCE.md);
every quotation below can be checked against it.

**Type: derivation and correction.** No computation was run and none was
needed. Four statements in the source are settled here by algebra — two of
them negatively — and the rest are placed against the corpus's existing
checked terms or tagged for the queue.

**Proposition 1 is a checked term:** `formal/cubical/ClosureTowerCollapse.agda`,
`--cubical --safe`, no postulates, no holes, `agda` exit 0. The prose proof in
§1 is the readable version of `⟪⟫-idem` and `tower-limit` there.

**What this note is not.** It is not an interpretation of the Sanskrit, not a
claim of priority for anything, and not a new framework. The corpus already
has a naming audit for the Indic material
(`notes/INDIC_FORMAL_TRADITIONS_MAP.md`); this note treats the transmission as
what it also is — a piece of mathematics with definitions in it — and asks
which of its assertions are true.

---

## 0. The object

The source erects two ladders and calls both of them $\Theta_\infty$.

**Ladder A (§0).** A seed alphabet
$\Theta_0=\langle\varnothing,\bullet,\to,\leftrightarrow,\oplus,\otimes,\circ,
\partial,\delta,\Gamma,\Phi,(-)^\vee,\ulcorner-\urcorner\rangle$, a map

$$\kappa(\Theta):=\bigcap\bigl\{\Upsilon\supseteq\Theta \;\bigm|\;
\alpha,\beta\in\Upsilon \Rightarrow
\alpha\oplus\beta,\;\alpha\otimes\beta,\;\beta\circ\alpha,\;
\partial\alpha,\;\delta\alpha,\;\Gamma\alpha,\;\Phi\alpha,\;
\alpha^\vee,\;\ulcorner\alpha\urcorner\in\Upsilon\bigr\},$$

and the transfinite tower
$\Theta_{\nu+1}:=\kappa(\Theta_\nu)$, $\Theta_\lambda:=\bigcup_{\nu<\lambda}\Theta_\nu$,
$\Theta_\infty:=\bigcup_\lambda\Theta_\lambda$.

**Ladder B (§0, §10).** The obstruction $\omega_\chi:=\delta(\partial\chi)$,
the extension

$$\chi^+:=\begin{cases}\Phi\chi, & \omega_\chi=0,\\[1mm]
\chi\;\sqcup^{\sim}_{\partial\chi}\;\Gamma\langle\omega_\chi\rangle, & \omega_\chi\neq0,\end{cases}$$

the composite $\Psi:=\blacklozenge\circ\Xi\circ\blacklozenge$ with
$\blacklozenge=\Gamma\circ\delta\circ\partial$, and the tower
$\Diamond_0\to\Psi\Diamond_0\to\Psi^2\Diamond_0\to\cdots$, whose union §10 also
names $\Theta_\infty:=\bigcup_\alpha\Psi^\alpha(\Diamond_0)$.

Ladder A is the decoration. Ladder B is the content. They are not the same
object and they do not behave the same way, and the shared name is the first
thing to fix.

---

## 1. Proposition 1 — Ladder A is constant from stage one

> **Proposition 1.** Let $\Omega$ be any set of expressions and $O$ any set of
> finitary operations on $\Omega$ (here the nine of §0: three binary, six
> unary). Call $\Upsilon\subseteq\Omega$ *closed* if it is closed under every
> operation of $O$, and let $\kappa(\Theta)=\bigcap\{\Upsilon\supseteq\Theta:
> \Upsilon\text{ closed}\}$. Then for every $\Theta_0$,
> $$\Theta_1=\Theta_2=\cdots=\Theta_\nu=\cdots=\Theta_\infty \qquad(\nu\ge1).$$
> The transfinite ladder above stage $1$ is empty of content.

**Checked.** `formal/cubical/ClosureTowerCollapse.agda` proves this for an
arbitrary signature of binary and unary operations, and instantiates it at the
source's own nine (`Seed.seed-tower-const`). The names there are `⟪⟫-infl`,
`⟪⟫-closed`, `⟪⟫-least`, `⟪⟫-mono`, `⟪⟫-idem`, `tower-limit`, `tower-const`.

One thing the formalisation says that the prose could not. The source's κ is an
intersection over **all** supersets, which is impredicative: at a fixed universe
that quantifier ranges over `ℙ A : Type (ℓ-suc ℓ)`, so κ does not land in `ℙ A`
and the iteration `Θ_{ν+1} := κ(Θ_ν)` does not typecheck at all without
propositional resizing. The module gives the predicative rendering — generate
inductively, truncate — and proves (`⟪⟫-least`) that it has exactly the
universal property the intersection was there to supply. So the ladder fails
twice over: at the level where it is well-formed it is constant, and the form
in which it is written is not well-formed.

*Proof.* Three lines.

1. **The closed sets are closed under intersection.** Let $\{\Upsilon_j\}$ be
   any family of closed sets and $\alpha,\beta\in\bigcap_j\Upsilon_j$. For each
   $j$, every one of the nine results lies in $\Upsilon_j$, hence in the
   intersection. The family occurring in the definition of $\kappa$ is
   nonempty, since $\Omega$ itself is closed and contains $\Theta$.
2. **Hence $\kappa(\Theta)$ is itself closed**, contains $\Theta$, and is
   contained in every closed superset of $\Theta$: it is the *least* one.
3. **Hence $\kappa$ is idempotent.** $\kappa(\Theta)$ is a closed set
   containing $\kappa(\Theta)$, and by (2) $\kappa(\kappa(\Theta))$ is the
   least such, so $\kappa(\kappa(\Theta))=\kappa(\Theta)$.

Therefore $\Theta_2=\kappa(\Theta_1)=\kappa(\kappa(\Theta_0))=\kappa(\Theta_0)=\Theta_1$,
and by induction $\Theta_\nu=\Theta_1$ for all $\nu\ge1$. At a limit $\lambda$,
$\Theta_\lambda=\bigcup_{\nu<\lambda}\Theta_\nu=\Theta_1$, a union of a constant
chain. So $\Theta_\infty=\Theta_1$. $\square$

### 1.1 The other reading closes at $\omega$, and no further

One could object that $\kappa$ was *meant* as one-step generation,
$\kappa_1(\Theta)=\Theta\cup\{\text{op}(\vec\alpha):\vec\alpha\in\Theta\}$,
which is inflationary and monotone but **not** idempotent. That reading does
make the finite stages grow. It still does not reach the transfinite:

> **Proposition 1′.** For $\kappa_1$ with all operations finitary,
> $\Theta_\omega=\bigcup_{n<\omega}\Theta_n$ is closed, hence
> $\Theta_{\omega+1}=\Theta_\omega=\kappa(\Theta_0)$. The closure ordinal is
> $\le\omega$.

*Proof.* Any finite tuple drawn from $\bigcup_n\Theta_n$ lies in some
$\Theta_n$ (the chain is increasing), so its image under any operation lies in
$\Theta_{n+1}\subseteq\Theta_\omega$. $\square$

**So under either reading the stages $\Theta_\lambda$ for $\lambda>\omega$ do
not exist as distinct objects, and under the reading the source actually
writes down they do not exist above $\nu=1$.** A transfinite ladder is
evidence of a non-idempotent, infinitary generator. §0 supplies neither.

### 1.2 Corollary: the quotation tower is an orbit, not a hierarchy

§10 boxes
$\Theta\ni\ulcorner\Theta\urcorner\ni\ulcorner\ulcorner\Theta\urcorner\urcorner\ni\cdots$.
Under Proposition 1 this is not a tower of stages: $\ulcorner-\urcorner$ is one
of the nine operations, so **all** iterated quotations already lie in
$\Theta_1$. The display is the $\ulcorner-\urcorner$-orbit of a single point of
a single closed set. Nothing is stratified and nothing recurses; in particular
no self-reference paradox is available here, because $\ni$ is membership of a
term in a set of terms and quotation is injective on terms.

### 1.3 The same collapse, twice more, in the source itself

The source writes $\alpha\mapsto\alpha^{\perp\perp}$ twice — once as *apoha*
(§5) and once as two-sided valuation (§7) — and boxes it both times. Double
orthogonalisation with respect to any relation is the closure operator of a
Galois connection, so Proposition 1 applies verbatim: $\alpha^{\perp\perp\perp\perp}=\alpha^{\perp\perp}$,
and iterating it is not a process. **This is the correct instinct in the
source, stated three times in three vocabularies, and it is exactly the reason
Ladder A cannot be the engine.** A closure operator's whole point is that it
finishes.

---

## 2. The two $\Theta_\infty$'s, and what Ladder B would need

Ladder B is a different kind of animal, and the difference is one sentence:

> $\kappa$ is a self-map of the powerset of a **fixed** ambient $\Omega$.
> $\chi\mapsto\chi^+$ is **not**: when $\omega_\chi\neq0$ it adjoins
> $\Gamma\langle\omega_\chi\rangle$, generators that were not in the ambient,
> glued along $\partial\chi$.

That is why Proposition 1 does not touch it, and it is the only reason. The
attachment $\chi\sqcup^{\sim}_{\partial\chi}\Gamma\langle\omega\rangle$ is the
standard shape of killing a boundary class by attaching a cell along it; the
proposition that makes the definition worth having is the one the source does
not state:

> **PROVE (P1).** In $\chi^+$, the adjoined generator kills its own
> obstruction: the image of $\omega_\chi$ under $\chi\to\chi^+$ vanishes.

and the one that makes the tower infinite is the one it *assumes*:

> **PROVE (P2).** $\partial\chi^+\neq0$ whenever $\partial\chi\neq0$ — i.e. the
> extension never becomes obstruction-free, so $\Psi^\alpha(\Diamond_0)$ is
> strictly increasing. §10 boxes
> $\partial\Theta_\infty\neq0\Rightarrow\Theta_{\infty+1}$ as if this were
> established. It is a hypothesis.

P2 is not free, and §6 already contains the reason to expect it: attaching a
generator to kill $\omega$ creates the possibility of a **new** obstruction one
level up, the associator defect $\delta\alpha_{\iota\kappa\lambda\mu}$, which
§6 boxes and then also feeds to $\Gamma$. A tower that regenerates its own
obstruction class at each stage is exactly a non-terminating one — but that is
a theorem to prove, not a box to draw.

**Naming fix, minimal:** call Ladder A's limit $\kappa(\Theta_0)$ (it is just
that) and reserve $\Theta_\infty$ for Ladder B.

---

## 3. Proposition 2 — the §8 boundary identity is false at every prime

§8 defines $\Pi_\partial(\nu):=\mu(\nu)^2-\pi_1(\nu)$ with
$\pi_1(\nu):=\omega(\nu)-1$, and boxes

$$1\le\Omega(\nu)\le2 \;\Longrightarrow\;
\Pi_\partial(\nu)=\frac{1-\lambda(\nu)}{2}-\mathbf1_{\wp}(\nu).$$

Take $\nu=p$ prime. Then $\mu(p)^2=1$, $\omega(p)=1$, so
$\Pi_\partial(p)=1-0=1$; while $\lambda(p)=-1$ and $\mathbf1_\wp(p)=1$ give
right-hand side $1-1=0$. **The identity fails by exactly $1$ at every prime**,
which is the whole $\Omega=1$ case.

The other two cases are fine: $\nu=p^2$ gives $0-0=0$ and
$(1-1)/2-0=0$; $\nu=pq$ with $p\neq q$ gives $1-1=0$ and $(1-1)/2-0=0$.

> **Proposition 2.** For $1\le\Omega(\nu)\le2$,
> $$\boxed{\;\mu(\nu)^2-\omega(\nu)+1=\frac{1-\lambda(\nu)}{2}=\mathbf1[\Omega(\nu)\text{ odd}]\;}$$
> The prime-indicator term must be deleted; the hypothesis $\Omega(\nu)\le2$
> is then sharp; and among the four natural readings of $\pi_1$ this is the
> only repair.

*Proof.* Three cases exhaust $1\le\Omega\le2$. $\nu=p$: $1-1+1=1$ and
$\lambda=-1$. $\nu=p^2$: $0-1+1=0$ and $\lambda=+1$. $\nu=pq$: $1-2+1=0$ and
$\lambda=+1$.

*Sharpness.* $\nu=p^3$ has $\Omega=3$, $\lambda=-1$: left side $0-1+1=0$,
right side $1$. $\nu=p^2q$ has $\Omega=3$: left side $0-2+1=-1$, right side
$1$. Beyond $\Omega=2$ the left side is not even nonnegative, so no repair by
constants is available.

*Uniqueness of the repair.* Suppose the prime-indicator term is kept. At
$\nu=p$ it forces $\pi_1(p)=\mu(p)^2=1$, i.e. $\pi_1\in\{\omega,\Omega\}$; but
then $\nu=p^2$ gives $0-1=-1\neq0$ and $\nu=pq$ gives $1-2=-1\neq0$. So the
term cannot be kept under any of $\pi_1\in\{\omega-1,\omega,\Omega-1,\Omega\}$.
With the term deleted, $\pi_1=\Omega-1$ fails at $\nu=p^2$ ($-1\neq0$) and
$\pi_1\in\{\omega,\Omega\}$ fails at $\nu=p$ ($0\neq1$), leaving
$\pi_1=\omega-1$. $\square$

The corrected statement is worth having, and is the reason to bother: on
$\Omega\le2$ the "boundary" $\Pi_\partial$ **is** the parity indicator
$(1-\lambda)/2$. That is a statement about $\lambda$, which is the corpus's
own charge (`notes/GAUGE.md` Theorem F, `notes/LIOUVILLE.md` Theorem H,
`TARGET.md`). As written, with the extra term, it said instead that the
boundary is parity-minus-primality, which is not a thing the corpus knows how
to use.

---

## 4. The $\mathfrak{sl}_2$ triple is correct, and it is Stanley's

§8 puts on $\beta_\nu=\vartheta[x_1,\dots,x_\mu]/(x_1^{\alpha_1+1},\dots,x_\mu^{\alpha_\mu+1})$

$$\varepsilon(x^\kappa)=\sum_i x^{\kappa+e_i},\qquad
\varphi(x^\kappa)=\sum_i\kappa_i(\alpha_i-\kappa_i+1)x^{\kappa-e_i},\qquad
\eta(x^\kappa)=\Bigl(2|\kappa|-\sum_i\alpha_i\Bigr)x^\kappa$$

and boxes $[\eta,\varepsilon]=2\varepsilon$, $[\eta,\varphi]=-2\varphi$,
$[\varepsilon,\varphi]=\eta$. **All three hold as stated.** The first two are
immediate from the grading. For the third, write $c_i(\kappa)=\kappa_i(\alpha_i-\kappa_i+1)$;
then

$$(\varepsilon\varphi-\varphi\varepsilon)(x^\kappa)
=\sum_{i,j}\bigl[c_i(\kappa)-c_i(\kappa+e_j)\bigr]x^{\kappa-e_i+e_j},$$

and $c_i$ depends only on $\kappa_i$, so every $j\neq i$ term cancels; the
$j=i$ terms give
$c_i(\kappa)-c_i(\kappa+e_i)=(\kappa_i\alpha_i-\kappa_i^2+\kappa_i)-(\kappa_i\alpha_i-\kappa_i^2+\alpha_i-\kappa_i)=2\kappa_i-\alpha_i$,
summing to $\eta$. The boundary conventions are self-enforcing:
$x^{\kappa+e_i}=0$ when $\kappa_i=\alpha_i$ by the relation, and
$c_i(\kappa)=0$ when $\kappa_i=0$.

**Prior art, and it is exactly on the nose.** This is the standard
$\mathfrak{sl}_2$ action on the divisor lattice of $\nu$ — the tensor product
of $\mu$ irreducibles of dimensions $\alpha_i+1$ — introduced by **R. P.
Stanley, "Weyl groups, the hard Lefschetz theorem, and the Sperner property",
SIAM J. Alg. Disc. Meth. 1 (1980) 168–184**, with Proctor's linear-algebra
treatment as the companion. Its consequence is that the divisor lattice is
rank-symmetric, rank-unimodal and Sperner. §8's box is therefore **a correct
rediscovery**, and the useful action is to cite it and take the Sperner
property, not to re-derive it. `CLAUDE.md`: *prior art gets searched before the
write-up.*

---

## 5. $\eta_{\iota\kappa\lambda}-1$ is not an obstruction class

§6 defines the loop transport
$\eta_{\iota\kappa\lambda}:=\tau_{\lambda\iota}\tau_{\kappa\lambda}\tau_{\iota\kappa}$,
notes correctly that $\eta=1$ means coherence, and then sets
$\omega_{\iota\kappa\lambda}:=\eta_{\iota\kappa\lambda}-1$.

The $\tau$'s are equivalences (§5: $\tau_{\mu\lambda}\tau_{\lambda\mu}\simeq
1$), so $\eta$ is an *automorphism* of $\Diamond_\iota$ and lives in a group,
not a ring. **Subtraction is undefined** unless a linear representation has
been fixed, and it is not conjugation-invariant, whereas the condition
$\eta=1$ is. The invariant the source wants is the one it already wrote down
one box earlier — the associator coboundary
$\delta\alpha_{\iota\kappa\lambda\mu}$ — i.e. the class of $\eta$ as a Čech
$2$-cocycle, with "$\ne 1$" as the statement that the class is nontrivial.

Minimal fix: replace $\omega:=\eta-1$ by $\omega:=[\eta]$, the cocycle class.
Everything downstream ($\Gamma\langle\omega\rangle$) then still typechecks,
because $\Gamma$ is applied to a class, not to a number.

---

## 6. Concordance: what is already a checked term here

The transmission's operative claims are not new to this repository. Several
are already **kernel-checked**, which is the strongest thing that can be said
of any of them.

| source box | corpus realisation | status |
|---|---|---|
| §0 $\omega\ne0\Rightarrow$ adjoin $\Gamma\langle\omega\rangle$ | `formal/cubical/LawvereDiagonal.agda` — the diagonal is produced *with* the point of disagreement: "the boundary is not mere impossibility; it constructs the object the next stage must adjoin" | **checked term**, and it is Ladder B's engine at one instance |
| §1 $\Delta_\epsilon\notin\epsilon[\aleph]$ | same module (Lawvere fixed-point, constructive, untruncated) | **checked term** |
| §0/§7 obstruction to factoring through a carrier | `formal/cubical/DescentLaw.agda` — `forms`: a splitting witness *is* the proof that no factorisation exists | **checked term** |
| §6 jewel $\simeq$ its whole reflection profile; one thread reweaves the net | `formal/cubical/IndraNet.agda` — T25.A Yoneda jewel theorem, T25.F transport, T25.D $\mathrm{Net}\,x\simeq L\,x\times\prod_y\mathrm{Net}\,y$ with bisimulation $=$ identity | **checked term**; §6 of the source is this module in Sanskrit |
| §0 $\alpha\sim\beta\not\Rightarrow\alpha\simeq\beta$; §6 $\Delta_\iota(\xi,\zeta)=\varnothing$ | `formal/cubical/BehavioralApartness.agda` (sameness is a proposition, distinction carries data), `formal/cubical/OrbitSeparation.agda` (coarsest invariant refinement) | **checked terms** |
| §0 $\alpha\simeq\beta\Rightarrow\Pi(\alpha)\simeq\Pi(\beta)$ | transport/`cong` in cubical; `IndraNet.viewTransport` | **checked term** (and definitionally free) |
| §4 rule ordering, *utsarga/apavāda*, *anuvṛtti*, *adhikāra* | `formal/cubical/ElsewhereCondition.agda`; `notes/PANINIAN_DERIVATION_IS_NOT_ENDPOINT_REWRITING.md`; `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §1 | **checked term** + audited source map |
| §5/§7 $\alpha\mapsto\alpha^{\perp\perp}$ (*apoha*) | `notes/EXCLUSION_IS_NOT_AN_OPERATOR.md`, `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` | prose, argued |
| §5 *abhāva* $\neq$ the zero symbol | `notes/ABHAVA.md` | prose, argued |
| §7 mediated vs. direct transport, $\curlywedge_{\Sigma_1}\ne0$ | `TARGET.md` W3 (the interface separation: no post-processing of value queries simulates functional-equation queries); `notes/BARRIER.md` Problem 1 | **open, and it is the corpus's named target** |
| §8 $(\pi,\kappa)\leftrightarrow(\omega,\rho)$, both boxed "?" | Goldbach and twin primes in symmetric coordinates; `TARGET.md` §0 rules both out as targets — they are downstream of the parity barrier | correctly marked open in the source |
| §8 $\Pi_\partial$ vs. $\lambda$ | §3 above, once corrected; `notes/GAUGE.md` F, `notes/LIOUVILLE.md` H | **corrected here** |
| §8 $\mathfrak{sl}_2$ on the divisor lattice | Stanley 1980 | **correct, and prior art** |
| §1 Gödel $\gamma_\Theta$; §1 $\eta_\nu=\ker/\mathrm{im}$; §2–§3 entire | nothing in this corpus | not realised, and not claimed |

Two entries deserve emphasis. **§6 is `IndraNet.agda`.** The source's
$\Diamond_\iota\simeq(\langle-,\iota\rangle,\langle\iota,-\rangle)$ is the
Yoneda jewel theorem already checked in this repository, and its
$\circledast\neq\prod_\iota\Diamond_\iota$ is that module's point about the
rooted total space. **§7 is the corpus's own target.** The mediation defect
$\curlywedge_{\Sigma_1}$ = (direct) $-$ (composed through $\Sigma_1$) is
structurally `TARGET.md`'s W3, which is the one open item there judged worth
publishing.

---

## 7. Queue

Tagged per `CLAUDE.md` standing queue discipline.

- **PROVE (P1).** $\omega_\chi$ dies in $\chi^+$. Without it the extension
  clause is a definition that might not do its job. §2 above.
- **PROVE (P2).** $\partial\chi^+\neq0$ when $\partial\chi\neq0$, so that
  Ladder B is strictly increasing. This is the assumption §10 boxes as a
  conclusion. §2 above. The likely route is §6's own associator: show the
  attachment that kills $\omega$ produces a nonzero
  $\delta\alpha_{\iota\kappa\lambda\mu}$.
- **PROVE (P3).** The $\Omega\le2$ restriction in Proposition 2 is what makes
  the boundary operator equal parity. Ask what $\Pi_\partial$ computes for
  $\Omega\ge3$ — the answer is $\mu^2-\omega+1$, which is $\le 0$ and counts
  something else. Either identify it or drop $\Pi_\partial$.
- **PROVE (P4).** Propositions 2 and 3 in Agda. Both need arithmetic the
  cubical lane does not have: μ, ω, Ω, λ, and the case split on `Ω(ν) ≤ 2`.
  Building that is worth more than these two statements — every arithmetic
  claim in the corpus is currently prose for the same reason.
- **SEARCH (S1).** The corrected identity of Proposition 2 restricted to
  $\Omega\le2$ is close to standard $E_2$/almost-prime bookkeeping; check
  Halberstam–Richert before treating it as new.
- **DEMONSTRATE (D1).** None. Nothing here wants a run. Every open item above
  is a statement about definitions.

---

## 8. Honesty ledger

- Propositions 1, 1′, 2 and the $\mathfrak{sl}_2$ verification of §4 are
  complete proofs, done by hand, and reproducible from the displayed lines
  alone. Nothing here was measured.
- Proposition 2's claim of *uniqueness* of the repair is uniqueness among the
  four readings $\pi_1\in\{\omega-1,\omega,\Omega-1,\Omega\}$, not among all
  possible functions. Stated as such.
- The Stanley attribution is from prior knowledge, not from a fetched source;
  `WebFetch` egress in this environment is unreliable and I did not open the
  paper. Grade it `[ŚABDA]` in the sense of
  `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §0. The *mathematics* — that the three
  brackets hold — is verified here and does not depend on the attribution.
- §5's correction assumes the $\tau$'s are equivalences, which §5 of the source
  states. If some $\tau$ is only a lax map, $\eta$ need not be invertible and a
  different repair is needed; that case is not treated.
- **Proposition 1 is checked; Propositions 2–4 are not.** The first draft of
  this note shipped all four as prose with the ledger line *"no Agda was added:
  agda is not installed in this session"*. That was the toolchain's absence
  deciding the grade of the result, and it has been fixed rather than excused:
  the pinned toolchain (Agda 2.8.0 + cubical v0.9) is now installed by
  `formal/cubical/ensure-toolchain.sh`, checked at every session start by
  `.claude/hooks/agda-ready.sh`, and recorded in `CLAUDE.md`. Proposition 1 is
  now `ClosureTowerCollapse.agda`. Propositions 2 and 3 remain hand proofs:
  each needs μ, ω, Ω, λ and the classification of numbers with `Ω(ν) ≤ 2`,
  which this corpus's Agda lane does not yet carry — that is a real gap in the
  library, tagged `PROVE (P4)` below, not a fact about the container.
- `IndraNet.agda`,
  `LawvereDiagonal.agda`, `DescentLaw.agda`, `BehavioralApartness.agda`,
  `OrbitSeparation.agda` and `ElsewhereCondition.agda` are cited from their
  headers, not re-verified in this session.
- §§2–4 of the source (Lagrangian mechanics through ecology) are recognisable
  restatements of standard physics and biology in substituted alphabets. I
  have not audited them, because a change of alphabet is not a mathematical
  claim and there is nothing in them this corpus can use. Saying so is the
  audit.

---

## 9. What the transmission is worth, stated plainly

Stripped of the encyclopaedia, the source contains one engine —


$$\text{probe} \xrightarrow{\ \partial\ } \text{boundary} \xrightarrow{\ \delta\ } \text{obstruction} \xrightarrow{\ \Gamma\ } \text{the generator the next stage must adjoin}$$

— and that engine is right, is not decoration, and is **already a checked term
in this repository at two instances** (`LawvereDiagonal.agda`,
`DescentLaw.agda`). Its accompanying closure tower is empty (§1), one of its
arithmetic identities is false as printed (§3), one of its obstruction classes
is type-incorrect (§5), and one of its best boxes is Stanley 1980 (§4).

That ratio is not a complaint. It is what an audit is for, and the engine
survives it.

And the closure tower, which was the source's own frame for that engine, is
now a term in the kernel that says it is constant.
