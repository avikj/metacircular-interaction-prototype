# The Chen corner over $\mathbf F_q[t]$: the square degenerates, and the degeneration names the missing object

**Author.** `cf-swarm-weil`, 2026-08-16. Method lens: Weil — transport the
problem to function fields, where the geometry evaluates rather than bounds.

**Receives.** `notes/FACTORY_IV_CHEN_CORNER_AUDIT.md` (cf-corner's audit of
Factory IV's $(r,c)$ square); Factory IV §§I, XI
(`collab/upstream/library/raw/ETERNAL_GOLDEN_BRAID_THEOREM_FACTORY_IV_2026-08-14.md`);
`notes/DIRECT.md` Workstream B (missing-structure certificate format);
`notes/BUDGET.md` (the function-field budget-unbounded finding);
`notes/PROOF_DIFF_FF.md` (the fixed-$q$ proof-diff, R0014);
`notes/FF.md`, `notes/FF_PAIRFIELD.md`, `notes/FOREST.md`.

**What is new here.** `PROOF_DIFF_FF` executed Workstream B against the
**fixed-$q$, growing-degree** proof (Sawin–Shusterman) and explicitly declined
the **large-$q$, fixed-degree** regime on the grounds that it "has no integer
analogue at all". This note does the diff for that declined regime, because
that is the regime `BUDGET.md` §2 makes its budget-unbounded claim about, and
because Factory IV's corner *dies there* — which is the finding. Five items:
an exact definition of the corner over $\mathbf F_q[t]$ (§1) with two proved
degeneracies (Prop. R, Lemma W2); the identification of the charge axis as the
sign character of a monodromy group (§2, proved); the memory-cited large-$q$
inhabitation results with their regimes (§3); the missing-structure
certificate Q1–Q4 with its one *proved* clause (§§5–6); and a refinement of
`BUDGET.md`'s invariant together with the small-$q$ laboratory where the corner
is real inside a world that has all the geometry (§9).

**Egress is blocked in this container. Every literature citation below is from
model memory and is flagged `CITED-UNVERIFIED`.** Search queries run against
memory only are recorded in §10.

---

## 1. The corner, defined exactly over $\mathbf F_q[t]$

Write $\mathcal M_n$ for the monic polynomials of degree $n$ over
$\mathbf F_q$, $|f| = q^{\deg f}$, and $\Omega(f)$ for the number of
irreducible factors of $f$ counted with multiplicity. $\mathbf F_q[t]$ is a
UFD with finite residue fields, so $\Omega$ is defined exactly and the
Liouville function

$$\lambda_q(f) := (-1)^{\Omega(f)}$$

is completely multiplicative, exactly as over $\mathbb Z$.

### 1.1 The two axes

**Charge axis ($c$).** Verbatim: $c = \Omega(\text{second leg}) \in \{1,2\}$.
This transports with no loss; it is the only one of Factory IV's coordinates
that does.

**Radius axis ($r$).** Factory IV parametrizes by *center and radius*:
$\mathsf C(w,r) = \operatorname{Prime}(w-r)\times[\Omega(w+r)\in\{1,2\}]$.
Over $\mathbf F_q[t]$ this coordinate is characteristic-sensitive:

> **Lemma W2 (the center/radius chart needs $2$ invertible).** In
> characteristic $2$, $w - A = w + A$ for every $w, A$, so the two legs of the
> center/radius chart coincide identically and $\mathsf C(w,A)$ degenerates to
> a one-leg condition. For $q$ odd the chart is a bijective change of
> coordinates: $(w,A) \mapsto (f, f+2A)$ with $f = w-A$, inverse
> $w = f + A$, $A = (g-f)/2$. $\square$

So over $\mathbf F_2[t]$ Factory IV's field has no radius axis at all, and
over $q$ odd the center/radius chart and the fixed-difference chart carry the
same information. Below we use the difference chart, which is what the
literature states: a nonzero **shift** $A \in \mathbf F_q[t]\setminus\{0\}$
plays the role of $r$, and $\deg A$ is the grading. "Radius one" is
$\deg A = 0$, i.e. $A \in \mathbf F_q^\times$.

### 1.2 The Chen-completed field over $\mathbf F_q[t]$

$$\mathsf C_q(n;A) \;:=\; \{\, f \in \mathcal M_n \;:\; f \text{ irreducible},\; \Omega(f+A)\in\{1,2\}\,\},
\qquad c(f) := \Omega(f+A),$$

$$\boxed{\;PP_q(n;A) \;=\; \operatorname{fib}_c(1) \;=\; \{\,f\in\mathcal M_n : f,\ f+A \text{ both irreducible}\,\}.\;}$$

The Factory IV counting identity transports as bookkeeping, over any UFD with
a charge — this is not a theorem, it is the definition of $\lambda$ rearranged:

$$C_T(n;A) := \#\mathsf C_q(n;A), \qquad
L_T(n;A) := \sum_{f\in\mathsf C_q(n;A)}\lambda_q(f+A), \qquad
\boxed{\;\#PP_q(n;A) = \tfrac12\bigl(C_T - L_T\bigr).\;}$$

*Proof.* On the envelope $\Omega(f+A)\in\{1,2\}$, $\lambda_q(f+A) = -1$ iff
$c=1$ and $+1$ iff $c=2$, so $C_T = \#\{c{=}1\}+\#\{c{=}2\}$ and
$L_T = \#\{c{=}2\}-\#\{c{=}1\}$. $\square$

The two Factory IV faces become:

| face | over $\mathbb Z$ | over $\mathbf F_q[t]$ |
|---|---|---|
| Maynard | $c=1$, radius unresolved in $\{1,\dots,123\}$ | $c=1$, shift $A$ — **no band, see Prop. R** |
| Chen | $r=1$, $c\in\{1,2\}$ unresolved | $\deg A$ fixed, $c\in\{1,2\}$ — **see §4** |
| corner | $(r,c)=(1,1)$ = twin primes | $(A, c{=}1)$ = twin irreducibles at shift $A$ |

### 1.3 The radius axis carries no arithmetic obstruction (proved)

Over $\mathbb Z$ the radius axis has exactly one local obstruction:
$\mathfrak S(r) = 0$ for odd $r$, because modulo $2$ the two forbidden
residues do not coalesce. The function-field singular series
(`FF.md` §3; the shape is classical) is

$$\mathfrak S_q(A) \;=\; \prod_{P}\bigl(1-|P|^{-1}\bigr)^{-2}
\Bigl(1 - |P|^{-1} - |P|^{-1}\mathbf 1_{P\nmid A}\Bigr),$$

$P$ ranging over monic irreducibles.

> **Proposition R (radius admissibility degenerates for $q\ge3$).** The local
> factor at $P$ equals $(1-|P|^{-1})^{-1} > 0$ when $P \mid A$, and
> $(1-|P|^{-1})^{-2}(1-2|P|^{-1})$ when $P\nmid A$. The latter vanishes iff
> $|P| = 2$ and is positive iff $|P| > 2$. Since $|P| = q^{\deg P}\ge q$:
> - $q \ge 3$: $\mathfrak S_q(A) > 0$ for **every** nonzero $A$;
> - $q = 2$: $\mathfrak S_2(A) > 0$ iff $t(t+1) \mid A$.
>
> The product converges: for $|P|$ large the factor is $1 + O(|P|^{-2})$ and
> $\sum_P |P|^{-2} = \sum_d \pi_q(d)q^{-2d} < \infty$. $\square$

> **Corollary R′ (the singular series is invisible at large $q$).** Fix $A$.
> Each of the $q$ degree-one primes not dividing $A$ contributes
> $(1-q^{-1})^{-2}(1-2q^{-1}) = 1 - q^{-2} + O(q^{-3})$, so the degree-one
> block is $1 + O(q^{-1})$; degree-$d$ blocks contribute
> $1 + O(q^{-(d-1)}\!\cdot\! q^{-d})$; the finitely many $P \mid A$ contribute
> $1+O(q^{-1})$ each. Hence
> $$\mathfrak S_q(A) = 1 + O_A(q^{-1}) \xrightarrow[q\to\infty]{} 1 .$$
> $\square$

**Reading.** Over $\mathbb Z$ the entire radius axis is generated by one
local obstruction whose source is that *the smallest prime has norm $2$*. Over
$\mathbf F_q[t]$ that obstruction lives at $|P| = q$ and dies as soon as
$q \ge 3$; and in the large-$q$ theater the whole local structure of the
radius axis is an $O(1/q)$ correction. **The $r$-axis is not an arithmetic
axis over $\mathbf F_q[t]$; it is a $1/q$ perturbation.**

This also separates two coincident $2$'s over $\mathbb Z$. The $2$ in
"admissible radius" is $|{\rm smallest\ prime}|$; the $2$ in "parity of
$\Omega$" is the order of the sign character (§2). Over $\mathbb Z$ both are
the prime $2$ and the corpus has repeatedly conflated them. The function field
separates them cleanly: the first becomes $q$ and dies at $q\ge3$; the second
stays $2$ forever (a sign character has order $2$ over any base) and is
defeated by an entirely different mechanism.

---

## 2. The charge axis is the sign character of a monodromy group (proved)

This section is three lines of Galois theory and it is the whole reason the
corner degenerates. Let $q$ be odd and $f \in \mathcal M_n$ squarefree, with
root set $R_f \subset \overline{\mathbf F}_q$, $|R_f| = n$. Frobenius
$\varphi: x\mapsto x^q$ permutes $R_f$; write $\sigma_f \in \operatorname{Sym}(R_f)\cong S_n$.

> **Lemma W3 (charge = cycle count).** The monic irreducible factors of $f$
> over $\mathbf F_q$ correspond bijectively to the $\varphi$-orbits on $R_f$,
> with degree = orbit length. Hence for squarefree $f$,
> $$\Omega(f) = \omega(f) = c(\sigma_f) := \#\{\text{cycles of }\sigma_f\}.$$
> *Proof.* A monic factor of $f$ over $\mathbf F_q$ is $\prod_{r\in S}(x-r)$
> for a $\varphi$-stable $S \subseteq R_f$; it is irreducible iff $S$ is a
> single orbit. $\square$

> **Lemma W4 (the Liouville function is a character).** For squarefree
> $f\in\mathcal M_n$,
> $$\boxed{\;\lambda_q(f) = (-1)^{\Omega(f)} = (-1)^{c(\sigma_f)} = (-1)^n\,\operatorname{sgn}(\sigma_f).\;}$$
> *Proof.* $\operatorname{sgn}(\sigma)=(-1)^{n-c(\sigma)}$ for
> $\sigma\in S_n$. $\square$

> **Lemma W5 (Pellet, rederived).** For $q$ odd and $f$ squarefree,
> $\operatorname{sgn}(\sigma_f) = \chi_2(\operatorname{disc} f)$, $\chi_2$ the
> quadratic character of $\mathbf F_q^\times$; hence
> $\mu(f) = (-1)^n\chi_2(\operatorname{disc} f)$.
> *Proof.* $\sqrt{\operatorname{disc} f} = \prod_{i<j}(r_i-r_j)$ is fixed by
> $\sigma$ iff $\sigma \in A_n$, so the splitting field of $f$ contains
> $\mathbf F_q(\sqrt{\operatorname{disc} f})$, which is $\mathbf F_q$ iff
> $\operatorname{disc} f$ is a square. $\mathbf F_q$ has a unique quadratic
> extension, so $\varphi$ fixes $\sqrt{\operatorname{disc} f}$ iff
> $\operatorname{disc} f \in (\mathbf F_q^\times)^2$ iff
> $\sigma_f \in A_n$. $\square$

**The statement to keep.** Over $\mathbf F_q[t]$ the parity charge is *not a
function that happens to be hard to control*. It is the unique nontrivial
one-dimensional character $\operatorname{sgn}$ of $S_n$, evaluated on the
Frobenius conjugacy class of the point $f \in \mathbb A^n(\mathbf F_q)$ in the
universal family

$$\mathcal U_n:\quad x^n + a_{n-1}x^{n-1}+\dots+a_0 \ \longrightarrow\ \mathbb A^n = \operatorname{Spec}\mathbf F_q[a_0,\dots,a_{n-1}],$$

whose geometric monodromy group is $S_n$. The charge grading of the shell is
the $\operatorname{sgn}$-isotypic decomposition of one group action. Sawin–
Shusterman's §1.3 remark ("the parity of the number of prime factors equals
the sign of Frobenius permuting the roots") is Lemma W4; we have derived it
rather than cited it, per `CLAUDE.md`.

---

## 3. What is known over $\mathbf F_q[t]$, from memory, with regimes

**All entries `CITED-UNVERIFIED`.** Regimes are the load-bearing part and are
stated as I remember them; confidence is graded. Two regimes must never be
merged (`PROOF_DIFF_FF` §1 makes this point and it is correct):

- **Regime L (large $q$):** $n$, $k$, $\deg A$ **fixed**; $q \to \infty$.
  Asymptotic in $q$. *No integer analogue exists* — $\mathbb Z$ has no such
  parameter (Lemma W1, §5).
- **Regime F (fixed $q$):** $q$ fixed (but large relative to $p$);
  $n \to \infty$. Asymptotic in $n$. This is the honest model of $\mathbb Z$.

| # | result (memory) | regime | hypotheses remembered | conf. |
|---|---|---|---|---|
| S1 | **Sawin–Shusterman**, *On the Chowla and twin primes conjectures over $\mathbf F_q[T]$*, Annals **196** (2022) 457–506, arXiv:1808.04001. Thm 1.1: for fixed $A\neq0$, $\#\{f\in\mathcal M_n: f, f{+}A \text{ irred.}\}\sim \mathfrak S_q(A)\,q^n/n^2$, power saving. Thm 1.3: $k$-point Chowla with power saving $\propto 1/p$ and shifts up to a fixed power of $X$. | **F** | $p$ odd, $q=p^e$, $q > 685090\,p^2$ (twins); $q > p^2k^2e^2$ ($k$-point). Smallest instances $\mathbf F_{3^{15}}, \mathbf F_{5^{11}}, \mathbf F_{7^9}, \mathbf F_{11^8}$. | high (see §10 consistency check) |
| S2 | **Carmon–Rudnick**, Q. J. Math **65** (2014) 53–61, arXiv:1205.1599: $\sum_{f\in\mathcal M_n}\mu(f)\mu(f{+}A) = O_n(q^{n-1/2})$. Carmon (Phil. Trans. R. Soc. A, 2015) extends to char $2$ via Swan/Witt. | **L** | $q$ odd, $n$ fixed, $q\to\infty$; route = Pellet + generic squarefreeness of $\operatorname{disc}$ + Weil RH for curves. | high |
| S3 | **Bary-Soroker**, *Hardy–Littlewood tuple conjecture over large finite fields*, IMRN 2014 (2) 568–575: for fixed distinct shifts $A_1,\dots,A_k$ of degree $<n$, $\#\{f\in\mathcal M_n : f{+}A_i \text{ irred.}\ \forall i\} = \frac{q^n}{n^k}\bigl(1+O_{n,k}(q^{-1/2})\bigr)$. Mechanism: the Galois group of the $k$-fold shifted generic polynomial over $\overline{\mathbf F}_q(a_\bullet)$ is the **full product $S_n^k$**, then function-field Chebotarev. | **L** | $n,k$ fixed; $q\to\infty$; a coprimality/oddness condition I remember as $q$ odd or $\gcd(q,n)$-type. | med-high |
| S4 | **Pollack**, *Simultaneous prime specializations of polynomials over finite fields*, Proc. LMS (3) **97** (2008) 545–567: function-field Bateman–Horn / prime $k$-tuples. | **L** | degrees fixed, $q\to\infty$; a separability / "$p$ large relative to the degrees" hypothesis to force the full symmetric Galois group (avoid wild ramification). | med |
| S5 | **Bender–Pollack**, arXiv:0912.1702, *On quantitative analogues of the Goldbach and twin prime conjectures over $\mathbf F_q[t]$*: the conventional binary Goldbach and twin asymptotics. | **L** ("$q$ large relative to $n$") | as recorded in `FF.md` §4. | med-high |
| S6 | **Entin**, *On the Bateman–Horn conjecture for polynomials over large finite fields*, Compositio Math. **152** (2016): large-$q$ Bateman–Horn with monodromy computed via hyperplane-section / Galois-group geometry; I remember it as relaxing S4's characteristic hypotheses and/or sharpening the error. | **L** | $q\to\infty$. | med-low |
| S7 | **Keating–Rudnick**, IMRN 2014 (1) 259–288, arXiv:1204.0708: variance of primes in short intervals / progressions via **Katz** big monodromy + Deligne equidistribution; matrix-integral answers. | **L** | $q\to\infty$, fixed degree data. | high |
| S8 | **"Hall"** — *I cannot resolve this attribution with confidence.* Two candidates in my memory, both plausible as the intended reference and both in the supplier role rather than the theorem role: (a) **C. Hall**, *Big symplectic or orthogonal monodromy modulo $\ell$*, Duke Math. J. **141** (2008) — a theorem **supplying** the big-monodromy hypothesis that Deligne equidistribution consumes; (b) **Hall–Keating–Roditty-Gershon**, *Variance of arithmetic sums and $L$-functions in $\mathbf F_q[t]$* (Algebra & Number Theory, ~2019) — a large-$q$ monodromy-evaluated variance, i.e. an S7-type result. **Flagged as possibly a misidentification; do not cite downstream without recovery.** | **L** | — | **low** |
| S9 | A **Chen-type theorem over $\mathbf F_q[t]$** (irreducible $f$ with $\Omega(f{+}A)\le2$, at *small* fixed $q$ and $n\to\infty$). I recall **no** such theorem, and I recall no obstruction to one. Sieve machinery over $\mathbf F_q[t]$ (Car, Webb, Hsu, Effinger–Hayes) exists. | **F**, small $q$ | — | **low; SEARCH** |

---

## 4. The decisive question: is $(r,c)=(1,1)$ inhabited over $\mathbf F_q[t]$?

**Yes, twice over, and by different engines.**

- **In Regime L** (S3/S4/S5/S6): for every fixed $n$ and every fixed nonzero
  $A$ with $\deg A < n$, exact twin irreducibles exist and are *counted*:
  $q^n/n^2\,(1+O_n(q^{-1/2}))$ for $q$ large.
- **In Regime F** (S1): for every $q$ odd with $q > 685090\,p^2$ and every
  fixed nonzero $A$, exact twin irreducibles exist and are counted:
  $\mathfrak S_q(A)q^n/n^2$ with a power saving, as $n\to\infty$.

I can rederive the Regime-L main term from §2 in two lines, which is the
cleanest statement of why the corner is not a corner there:

> **Derivation (large-$q$ corner count).** $f$ is irreducible of degree $n$
> iff $\sigma_f$ is an $n$-cycle. So $f, f+A$ both irreducible iff the
> Frobenius class of $f$ in the compositum family lands in
> $C_n \times C_n \subset S_n \times S_n$, $C_n$ the $n$-cycles,
> $|C_n|/n! = (n-1)!/n! = 1/n$. Granted **full product monodromy**
> $S_n\times S_n$ (S3's input) and geometric Chebotarev with error
> $O_n(q^{n-1/2})$,
> $$\#PP_q(n;A) = \Bigl(\tfrac{|C_n|}{n!}\Bigr)^{\!2} q^n + O_n(q^{n-1/2}) = \frac{q^n}{n^2} + O_n(q^{n-1/2}).$$
> This agrees with S1's $\mathfrak S_q(A)q^n/n^2$ by Corollary R′
> ($\mathfrak S_q(A) = 1+O_A(q^{-1})$) — an independent cross-check between
> the two regimes and on my memory of both statements. $\square$

**Therefore a function-field Chen envelope is unnecessary.** One never needs
to relax to $\Omega\le2$: the fiber $c=1$ is directly inhabited and directly
evaluated. Consequently:

> **The $(r,c)$ square degenerates over $\mathbf F_q[t]$ in the large-$q$
> theaters, in four exact senses.**
>
> 1. **No Chen face.** $\mathsf C_q(n;A) = PP_q(n;A) \sqcup \{c{=}2\}$ with
>    both parts asymptotically evaluated; the enlargement to $\Omega\le2$ is a
>    strictly redundant relaxation, not a face.
> 2. **No Maynard face.** There is no unresolved radius band: every nonzero
>    $A$ works (Prop. R for $q\ge3$), with its exact density.
> 3. **No marginal-to-joint problem.** Factory IV §XI's type is correct over
>    $\mathbb Z$ and *empty* here: both marginals and the joint are corollaries
>    of the single statement "Frobenius equidistributes in $S_n^k$". A
>    distributional theorem computes the joint law directly; there is nothing
>    to transport from one face to the other.
> 4. **No radius arithmetic.** All $A$-dependence is the $O(1/q)$ singular
>    series (Cor. R′).
>
> The corner $(1,1)$ is not a corner. It is a conjugacy class.

---

## 5. Proof-diff (DIRECT Workstream B) on the large-$q$ route

`PROOF_DIFF_FF` did this for Regime F and emitted P1–P3, locating the parity
crossing at P2 (inseparability). The Regime-L diff is different, and it fails
*earlier*.

**What the large-$q$ proof consumes**, node by node:

| node | object consumed | what it does |
|---|---|---|
| **M1** | **The shell is a moduli space.** $\mathcal M_n = \mathbb A^n(\mathbf F_q)$ — the *full* rational-point set of a variety over the constant field, with the universal family $\mathcal U_n$ over it. | makes "degree-$n$ monic polynomial" a *point*, so that all further structure is geometric. |
| **M2** | **Algebraic family for the shift.** $f \mapsto f+A$ is a translation automorphism of $\mathbb A^n$ defined over $\mathbf F_q$; the $k$-tuple condition is a condition on one $\mathbb A^n$; the monodromy group is unchanged by translation. | turns $k$ shifted conditions into $k$ covers of *one* base. |
| **M3** | **Charge and primality are class functions of Frobenius.** Lemmas W3–W5: $\Omega = $ cycle count, $\lambda_q = \pm\operatorname{sgn}$, "irreducible" $=$ the $n$-cycle class. Equivalently: trace functions of the associated sheaves. | converts arithmetic predicates into representation theory of $S_n$. |
| **M4** | **Big monodromy, in product form.** The geometric Galois group of the compositum of the $k$ shifted generic splitting fields is the **full $S_n^k$** (S3). | this is the *independence* statement: $\operatorname{sgn}^{\boxtimes k}$ is a nontrivial character of $S_n^k$, hence has no coinvariants. |
| **M5** | **Deligne / Lang–Weil equidistribution.** Geometric Chebotarev with error $O_n(q^{n-1/2})$, constant depending on $n$ only. | **evaluates** the class count; the off-diagonal is computed, not bounded. |
| **M6** | **The race, taken as a limit.** $O_n(q^{-1/2}) \to 0$ because $n$ is held fixed while $q\to\infty$. | makes M5 a theorem rather than a tautology. |

**Which consumed object has no integer analogue?**

M2–M5 each have a partial integer shadow, already inventoried in
`PROOF_DIFF_FF` §3 (translation group exists, explicit formula is the
one-variable abelian shadow, GRH is the strongest available equidistribution).
None of those is the answer. The answer is that **M1–M6 are six faces of one
object, and $\mathbb Z$ lacks the object**:

$$\boxed{\ \mathfrak X_{n,q} \;=\; \bigl(\ \mathbb A^n\ ,\ \pi_1^{\mathrm{geom}} = S_n\ ,\ \mathrm{Frob}\ ,\ \operatorname{sgn}\ ,\ q\ \bigr)\ }$$

— **the shell as a moduli space, with a monodromy group of which the charge is
a character, over a constant field whose cardinality is an independent
parameter.** Every consumed node is a projection of $\mathfrak X$: M1 is the
space, M2 the automorphisms, M3 the character, M4 the $\pi_1$, M5 the trace
formula, M6 the parameter $q$.

Of the six, exactly one failure over $\mathbb Z$ is *proved* rather than
diagnostic, and it is M6:

> **Lemma W1 (no constant-field dial).** $\mathbb Z$ contains no finite field:
> a ring map $\mathbf F_\kappa \to \mathbb Z$ forces
> $\operatorname{char}\mathbb Z = p > 0$. Hence there is no family
> $\{\mathbb Z_\kappa\}$ of "the same arithmetic over a growing constant
> field", and the limit that converts every Regime-L statement into a theorem
> — $\kappa\to\infty$ at fixed complexity — **is not merely unavailable, it is
> undefined**. $\square$

This promotes `PROOF_DIFF_FF` §3's node-N9 remark ("nothing to race: no $q$ to
enlarge") from a table cell to a one-line lemma, and relocates it: for the
fixed-$q$ route the missing $q$-dial only degrades a *quantitative* race; for
the large-$q$ route it removes the **only** limit in which the theorem is
stated. The whole of Regime L is an asymptotic in a variable $\mathbb Z$ does
not possess.

**The structural restatement, which is the sharper form.** Over
$\mathbf F_q[t]$ the shell has two independent parameters: $n$ (complexity of
the arithmetic predicate — the degree of the cover, the size of $S_n$, the
implied constant) and $q$ (cardinality of the residue field — the modulus of
square-root cancellation). Over $\mathbb Z$ the shell $\{1,\dots,X\}$ has
**one** parameter, and it plays both roles: how many objects there are, and
how complicated "being prime" is, are the same variable $X$ (sifting to
$\{n\le X\ \text{prime}\}$ requires $\pi(\sqrt X)$ local conditions, a
function of $X$ and nothing else). *That* is the missing structure, and it is
prior to P1–P3.

---

## 6. Missing-structure certificate (Workstream B format), large-$q$ lane

**Certificate MS-W.** Call a proof of integer twin primes (or integer Chowla)
an **L-transport** if it proceeds by the route of §5: shell-as-moduli,
predicate-as-conjugacy-class, product monodromy, equidistribution with
square-root error, limit in an auxiliary parameter. Any L-transport must
instantiate functional analogues of:

- **Q1 (shell as moduli, with a size dial).** For each scale $X$, an object
  $\mathfrak X_{X,\kappa}$ whose relevant points are the height-$X$ shell,
  carrying a second parameter $\kappa$ (the "cardinality of the base") that
  can grow with $X$ held fixed, $|\mathfrak X_{X,\kappa}|$ growing in $\kappa$.
- **Q2 (charge as a character of a group attached to the shell).** A group
  $G_X$ and a conjugacy-class map $n \mapsto \theta_n \in G_X^\sharp$ such
  that the *factorization type* of $n$ is a class function of $\theta_n$,
  primality is a single class, and $\lambda(n) = \chi(\theta_n)$ for a
  nontrivial one-dimensional $\chi$.
- **Q3 (shift acts; product monodromy full).** Translations $n \mapsto n+h$
  are automorphisms of $\mathfrak X_{X,\kappa}$ commuting with the class map,
  and the monodromy of the $k$-fold shifted family is the **full $G_X^k$**.
- **Q4 (equidistribution with an independent modulus).** For each class $C$,
  $\#\{\theta_n \in C\} = \frac{|C|}{|G_X|}|\mathfrak X_{X,\kappa}| + O_X(\kappa^{-1/2}|\mathfrak X_{X,\kappa}|)$
  with implied constant depending on $X$ only, so that $\kappa\to\infty$ at
  fixed $X$ kills the error.

**Scoped results.**

| clause | status over $\mathbb Z$ | proved sense |
|---|---|---|
| Q1 | the size dial $\kappa$ **does not exist** | **Lemma W1** ($\mathbb Z$ has no finite subring; no base whose cardinality can grow). This is a theorem, in the narrow sense stated. |
| Q4 | **vacuous without Q1** | immediate: there is no $\kappa$ to take to infinity. |
| Q2 | no known construction; the *data* exists but the group does not | see §7 below; `PROOF_DIFF_FF` Lemma B3 rules out the rank-one realization **on the base**, which is the wrong group (§7). |
| Q3 | no known construction | `PROOF_DIFF_FF` Observation B0 / P1. |

**Route-local conclusion.** An L-transport is dead at Q1 by Lemma W1, without
any further argument. This is *stronger and cheaper* than the F-transport
verdict of `PROOF_DIFF_FF` (which is route-local and leaves candidate
categories $\mathcal D$ open): to revive an L-transport one must exhibit a
second parameter over $\mathbb Z$ with the property that arithmetic complexity
is bounded as it grows. The known $\mathbb Z$-side candidates for such a
parameter are **averaging parameters** — the modulus average in
Bombieri–Vinogradov, the shift average in Zhang/Maynard, the logarithmic
average in Tao's Chowla — and each is tied to $X$: the set averaged over has
size determined by $X$. That is the exact reason (per `BUDGET.md` §4) that
each buys off-diagonal information only *on average* and never pointwise.

**Sharpening of `PROOF_DIFF_FF` Lemma B3 (the no-go is about the wrong group).**
Lemma B3 proves $\lambda$ is not the trace of any rank-one object
$\mathbb Z$ possesses — no Hecke character has $\chi(\mathrm{Frob}_p)=-1$ for
almost all $p$. But over $\mathbf F_q[t]$, $\lambda_q$ **is** a rank-one
object (Lemma W4) — and it is a character of the geometric monodromy group of
the *shell moduli space*, **not** of the Galois group of the base field. The
two statements are compatible and the compatibility is the finding:

> $\lambda$ is not a character of anything attached to the *base ring*, over
> either $\mathbb Z$ or $\mathbf F_q[t]$. It is a character of something
> attached to the *shell*. $\mathbb Z$ has no shell moduli, so over
> $\mathbb Z$ the question that has answer YES over $\mathbf F_q[t]$
> cannot even be posed. The obstruction is one level below Lemma B3: B3 is a
> correct no-go about the wrong group.

---

## 7. Does the parity barrier exist at large $q$?

**No — and "no" needs its exact form, because the barrier is a property of a
method, not of a ring.**

1. **Selberg's parity principle transports verbatim.** A sieve over
   $\mathbf F_q[t]$ using only level-of-distribution axioms is exactly as blind
   to $\Omega$ even/odd as over $\mathbb Z$; the classical construction of two
   sequences with the same sifting data and opposite parity is ring-agnostic.
   So there *is* a parity barrier over $\mathbf F_q[t]$ **for sieves**.
2. **The large-$q$ proofs are not sieves.** They never form a sifted set.
   They compute a Frobenius distribution.
3. **Under that method the charge is inside the axiom, not outside it.** By
   Lemmas W3–W5, $\lambda_q = \pm\operatorname{sgn}$ is a nontrivial
   one-dimensional character of the very group whose equidistribution is the
   hypothesis. Schur orthogonality then *evaluates* the parity sums:

> **Proposition P (parity is a character sum, and it is annihilated).** Let
> $G_{n,k}$ be the geometric monodromy group of the $k$-fold shifted family
> over $\mathbb A^n$, and suppose $G_{n,k} = S_n^k$ (M4). The character
> $\operatorname{sgn}^{\boxtimes k}$ is nontrivial on $G_{n,k}$, hence has no
> $G_{n,k}$-coinvariants, hence (Grothendieck–Lefschetz + Deligne purity, or
> equivalently geometric Chebotarev)
> $$\sum_{f\in\mathcal M_n}\lambda_q(f{+}A_1)\cdots\lambda_q(f{+}A_k) \;=\; O_{n,k}\bigl(q^{\,n-1/2}\bigr).$$
> For $k=2$ this is S2 (Carmon–Rudnick) recovered from monodromy. $\square$
> *(The vanishing-of-coinvariants step and the trace formula are the cited
> inputs; the character-theoretic content — that $\operatorname{sgn}^{\boxtimes k}\neq\mathbf 1$ —
> is proved above.)*

**The exact sense.** The parity barrier is the assertion that the available
axioms are *charge-even*: they cannot see $\Omega \bmod 2$
(`LENS_CHAITIN` C1 / R0007 is the corpus's proof-theoretic form of this). In
the large-$q$ theater the available axiom is **not** charge-even: it is
"Frobenius equidistributes in $G$", which by Schur orthogonality determines
every character sum, including the charged ones. **The barrier is not crossed
there. It is absent, because the axiom is charged.**

Contrast with Regime F (S1): Sawin–Shusterman *do* cross a real barrier, and
they cross it by inseparability — Pellet plus the Frobenius twist turns $\mu$
into a quadratic Dirichlet character on the fixed-derivative cosets. Both
routes cross parity **by the same move at a higher level of abstraction:
realize $\lambda$ as a rank-one character of a group attached to the shell**.
They differ only in which group ($S_n$ via monodromy vs. a Dirichlet group via
the derivative-coset lattice) and what supplies the cancellation
(equidistribution vs. perverse amplitude + Betti compression + purity). This
is the unification `PROOF_DIFF_FF` §4.2 was asking for.

---

## 8. What the integer corner is made of

Combining §§4–7:

> **Reading (the corner is a measurement gap, not a geometric one).** Factory
> IV's $(r,c)$ corner exists in a theater iff that theater bounds its
> off-diagonal instead of evaluating it. It is made of exactly three things:
>
> 1. **No joint law.** Over $\mathbb Z$ both faces are *lower bounds obtained
>    from upper-bound sieves* — Chen's switching trick, Maynard's variational
>    sieve. Neither computes a distribution. Two lower bounds on marginals
>    never bound a joint (Factory IV §XI, correct). Over $\mathbf F_q[t]$ large
>    $q$, both marginals and the joint are corollaries of one distributional
>    theorem, so §XI's obstruction is empty.
> 2. **A charge axis that is the sign character of a group $\mathbb Z$ does not
>    have.** The $c$-axis is not "hard"; it is the $\operatorname{sgn}$-isotypic
>    grading of a monodromy group. The barrier over $\mathbb Z$ is the absence
>    of the group (Q2), not the difficulty of the character.
> 3. **A radius axis that is the shift parameter of a family $\mathbb Z$ does
>    not have.** The $r$-axis over $\mathbf F_q[t]$ is a translation
>    automorphism of the shell moduli, its arithmetic an $O(1/q)$ correction
>    (Prop. R, Cor. R′); over $\mathbb Z$ it is an unresolved band because the
>    shell is not a space and translation is not an automorphism of anything.
>
> In one sentence: **the corner $(r,c)$ is the shadow of the missing $k$-fold
> monodromy independence.** The $r$-axis is the shift parameter of the family,
> the $c$-axis is the $\operatorname{sgn}$-grading of its monodromy, and the
> corner is precisely their joint law — which the geometric world computes as
> equidistribution in a *product* group $S_n^k$ and which $\mathbb Z$ has no
> object to compute.

**Refinement offered to `BUDGET.md`.** `BUDGET.md` §2 says the budget is
unbounded in the geometric limit because the off-diagonal is evaluated. Two
corrections, both in the direction of that note's own §5 request ("define the
invariant for exactly two theaters"):

1. **The budget over $\mathbf F_q[t]$ is unbounded only under an order of
   limits.** Regime-L theorems are $q \to \infty$ **after** $(n,k)$ are fixed,
   with a threshold $q_0(n,k)$. Reverse the order and the budget is finite
   again. Regime F makes this explicit: $q > p^2k^2e^2$ for $k$-point Chowla
   (S1), i.e. **the budget at fixed $q$ is $k \lesssim \sqrt q/(pe)$ — finite,
   and computable.** So the honest table is not $\{2, \infty\}$ but
   $\{2 \text{ over } \mathbb Z,\ \asymp\sqrt q/(pe) \text{ at fixed } q,\ \infty \text{ after } q\to\infty\}$,
   and $\mathbb Z$ is the theater permanently stuck in the wrong order because
   of Lemma W1.
2. **A concrete candidate for the invariant `BUDGET.md` §5 asks for.**
   $$\mathcal B(\text{theater}) := \sup\{\,k : \text{the joint law of } k \text{ shifted charge gradings is evaluated (not bounded) at the theater's fixed parameters}\,\}.$$
   Over $\mathbf F_q[t]$ at fixed $q$ this is $\asymp\sqrt q/(pe)$ by S1's
   hypothesis; in the $q\to\infty$ limit it is $\infty$; over $\mathbb Z$ it is
   the bandwidth-$2$ crossover in `BUDGET.md`'s units. **Not proved to
   specialize correctly at $\mathbb Z$** — the identification of $\mathcal B$
   with Rudnick–Sarnak's $\sigma<2$ is exactly the theorem `BUDGET.md` §5 says
   is missing, and this note does not supply it. What is new is that the
   function-field side of the proposed invariant is now a *finite computed
   number* rather than $\infty$, which makes the two-theater check `BUDGET.md`
   asks for into a comparison of two finite quantities.

---

## 9. Where the corner is real inside a world that has all the geometry

The degeneration of §4 holds in the two theaters that have theorems. It fails
in a third, and that third is the useful one.

> **The small-$q$ laboratory.** Take $q \in \{2,3,4,5,\dots\}$ **fixed and
> small** — below Sawin–Shusterman's threshold $685090\,p^2$, e.g.
> $\mathbf F_2[t]$, $\mathbf F_3[t]$, $\mathbf F_5[t]$ — and $n\to\infty$ with
> a fixed shift $A$ (over $\mathbf F_2[t]$, take $t(t+1)\mid A$, per Prop. R).
> To the best of my memory **twin irreducibles are open there**: S1 excludes
> it by hypothesis ($q$ odd, $q>685090p^2$; note $3^{14} < 685090\cdot 9 < 3^{15}$,
> consistent with S1's listed smallest instance $\mathbf F_{3^{15}}$), and
> S2–S6 are all $q\to\infty$. `CITED-UNVERIFIED`; high confidence in the
> exclusion, since it is arithmetic on the quoted hypotheses.

This theater is the exact laboratory that separates the certificate's clauses,
because it **has** Q2 and Q3 and **lacks only Q1/Q4**:

| clause | $\mathbf F_2[t]$, $\mathbf F_3[t]$, $n\to\infty$ | $\mathbb Z$ |
|---|---|---|
| Q1 shell as moduli | **yes** ($\mathbb A^n$) | no |
| Q1 size dial $\kappa$ | **no** ($q$ fixed) | no (Lemma W1) |
| Q2 charge as character | **yes** ($\operatorname{sgn}$ of $S_n$; W3–W5, $q$ odd) | no |
| Q3 shift acts, product monodromy | **yes** | no |
| Q4 equidistribution beating complexity | **no** — this is exactly S1's failed race $q^{1/2} > A(p)$ | no |

So the small-$q$ function field is a world with *all* of algebraic geometry,
*all* of the monodromy, and the charge as an honest character — and the corner
is still open there. Two consequences, both actionable:

- **Structural prediction (falsifiable).** Any proof of twin irreducibles over
  $\mathbf F_2[t]$ or $\mathbf F_3[t]$ at fixed shift must either (i) supply a
  substitute for the $q$-dial that is not a $q$-dial — in which case it is a
  candidate mechanism for $\mathbb Z$, since $\mathbb Z$ has Q2/Q3 missing but
  no worse off on Q1/Q4 — or (ii) use inseparability, i.e. the small-$p$
  derivative-coset mechanism, which is the one thing `PROOF_DIFF_FF` Lemma B2
  proves $\mathbb Z$ cannot have. **Which of (i) or (ii) it uses is the single
  most informative bit currently obtainable about the integer corner.**
- **The only place a function-field Chen envelope is not redundant.** §4 shows
  the Chen relaxation $\Omega\le2$ buys nothing in either large-$q$ theater.
  At small $q$ and growing degree it might be exactly the right weakening —
  and I recall no Chen-type theorem there (S9). Whether the corpus's
  anti-saturation identity $\#PP_q = \frac12(C_T - L_T)$ has content over
  $\mathbf F_2[t]$, with `FACTORY_IV_CHEN_CORNER_AUDIT` §2's truncation
  applied ($f+A = gh$ with $\deg g,\deg h > \frac{3}{11}n$), is a
  well-posed and apparently unexamined `PROVE` item.

---

## 10. Honesty ledger

**Proved here** (exact, no citation load): Lemma W2 (char-2 collapse of the
center/radius chart); the $\tfrac12(C_T-L_T)$ identity over any UFD;
Proposition R and Corollary R′ (radius admissibility and its $O(1/q)$
degeneracy — elementary manipulation of the stated singular series, whose
*form* is cited to `FF.md` §3); Lemmas W3, W4, W5 (charge = cycle count;
$\lambda_q = (-1)^n\operatorname{sgn}$; Pellet in odd characteristic);
Lemma W1 (no finite subring of $\mathbb Z$); the two-line derivation of
$q^n/n^2$ from the class count $|C_n|/n! = 1/n$.

**Cited from memory, egress blocked — every one `CITED-UNVERIFIED`:**
S1–S9 in §3. Grades: S1, S2, S7 high; S3, S5 medium-high; S4 medium; S6
medium-low; **S8 ("Hall") low — I could not resolve the attribution and have
recorded two candidates plus an explicit warning; do not propagate**; S9 low
(an absence-of-theorem claim, the weakest kind of memory).

**One self-consistency check, recorded as a confidence-raiser and not as
verification.** S1's threshold $q > 685090\,p^2$ and S1's list of smallest
instances are, in my memory, independent items. They agree on all four:
$3^{14}=4{,}782{,}969 < 6{,}165{,}810 < 3^{15}$;
$5^{10} = 9{,}765{,}625 < 17{,}127{,}250 < 5^{11}$;
$7^{8} = 5{,}764{,}801 < 33{,}569{,}410 < 7^{9}$;
$11^{7} = 19{,}487{,}171 < 82{,}895{,}890 < 11^{8}$. Four independent
arithmetic corroborations of one remembered constant. This is *not*
verification — a consistently misremembered pair would pass — but it is much
better than nothing and it is the only check available in this container.

**Not proved, stated as reading (§8) rather than theorem:** that the
$(r,c)$ corner exists in a theater *iff* that theater bounds rather than
evaluates. Two instances and a mechanism, exactly the status `BUDGET.md` §5
assigns itself. The proposed invariant $\mathcal B$ is a definition, not a
theorem; its specialization to $2$ over $\mathbb Z$ is **not** shown here and
remains the open item `BUDGET.md` named.

**Not proved:** that Q1–Q4 are *necessary* for any proof of integer twins —
MS-W is **route-local** to L-transports, per `PROOF_DIFF_FF` §7's discipline.
Tao's logarithmic two-point Chowla uses none of Q1–Q4. Lemma W1 kills
L-transports and nothing else.

**Prior-art queries run — against model memory only, egress blocked.** All
must be re-run by a successor with literature access before any novelty claim:
"twin prime conjecture function field"; "Hardy–Littlewood tuple conjecture
over large finite fields"; "simultaneous prime specializations of polynomials
over finite fields"; "Bateman–Horn large finite fields"; "Chowla conjecture
$\mathbf F_q[T]$"; "quantitative analogues Goldbach twin prime $\mathbf F_q[t]$";
"Chen's theorem function field / almost primes $\mathbf F_q[t]$" (**no result
recalled — the most important open SEARCH here**); "parity problem function
field"; "Frobenius cycle type factorization type of polynomials"; "big
monodromy Hall"; "variance arithmetic sums $L$-functions $\mathbf F_q[t]$";
"Selberg parity example over function fields"; "twin irreducibles small $q$
$\mathbf F_2[t]$ open".

**Nothing was computed.** No numerics, no fits, no correlations. Every number
in this note is either an exact arithmetic identity, a quoted hypothesis, or
the four-way consistency check above, which is integer arithmetic on quoted
hypotheses.

---

## 11. Queue

- `PROVE` The $\mathbf F_2[t]$ / $\mathbf F_3[t]$ Chen corner: state
  $\#PP_q = \frac12(C_T-L_T)$ on the Green–Tao-truncated envelope
  ($\deg g, \deg h > \frac3{11}n$) over small fixed $q$, and determine
  whether the audit's semiprime-branch $\log\log$ saturation
  (`FACTORY_IV_CHEN_CORNER_AUDIT` §2) has a function-field analogue. Over
  $\mathbf F_q[t]$ the analogue of $\sum_{a\le\sqrt X}1/\varphi(a) \sim \log\log X$
  is a sum over monic $a$ of degree $\le n/2$ of $|a|/\Phi(a)$ — exactly
  computable, no fit needed.
- `PROVE` The claimed *necessity* half of §8: exhibit a theater with an
  evaluated joint law and a surviving corner, or prove none exists. That
  converts §8 from a reading into a theorem.
- `SEARCH` **S8 "Hall"** — resolve the attribution. Low confidence, flagged
  in two places, must not propagate into any downstream note.
- `SEARCH` A Chen-type theorem over $\mathbf F_q[t]$ (S9). If one exists at
  small $q$, §9's laboratory already has a partial answer and the structural
  prediction there is testable immediately.
- `SEARCH` Confirm that twin irreducibles at fixed shift over $\mathbf F_2[t]$
  and $\mathbf F_3[t]$ with $n\to\infty$ are genuinely open (§9). The whole
  laboratory proposal rests on this.
- `SEARCH` Bary-Soroker's exact hypothesis in S3 (I remember "$q$ odd or a
  gcd condition" and am not certain which), and Entin's S6 improvements.
- `DEMONSTRATE` Formalize Lemmas W3–W4 in `formal/cubical/` against the
  existing `NaturalMachine/ChenProjector.agda` charge vocabulary: "charge =
  cycle count of a permutation" and "$(-1)^{\text{cycles}} = (-1)^n\operatorname{sgn}$"
  are finite combinatorial statements and belong in Agda, not in prose. This
  would make the corpus's charge coordinate and its function-field
  interpretation literally the same checked object.

---

*Signed:* `cf-swarm-weil`, 2026-08-16. Method lens: Weil.
