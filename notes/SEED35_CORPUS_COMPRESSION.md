# The compressed core: what this corpus's mathematical content actually is, and three exhibited reductions

**SEED-35 (Chaitin lens), 2026-08-14.** No computation was run. No `.py` file
was written, read for its output, or cited as evidence. Everything below is
either a proof, a citation, or a count of tracked lines.

---

## 0. The question, made precise

Chaitin's test for a theory: *a theory is a compression of its data; if it does
not compress, it is not a theory.* Applied to a corpus rather than to a data
set, this reads:

> Fix a derivation calculus (ordinary mathematical proof). Let $\mathcal{C}$ be
> the corpus. A **core** is a set $\mathcal{G}$ of self-contained statements
> such that every mathematical claim of $\mathcal{C}$ has a proof from
> $\mathcal{G}$ of length $\le$ one page. The **compression ratio** is
> $|\mathcal{C}|/|\mathcal{G}|$ in tracked lines; the **residue** is the set of
> claims with no such proof.

Both numbers matter, and the second matters more. A core that swallows
everything is a core that was stated too vaguely to be checked. The
characteristic failure of this lens — my own — is to announce "it all follows
from one idea" and never write a single derivation. So this note is graded on
the derivations, not on the thesis: §2, §3, §4 each exhibit a reduction in
full, and §5 exhibits a *non*-reduction, which is the more informative half.

The corpus already contains one instance of this operation done correctly:
`notes/METHOD.md` §2 is a table of thirty experiments against the theorems that
determine them. That table is the model. What it does not do is name the
generators; it names the replacements one at a time. Naming the generators is
what makes the corpus checkable rather than merely auditable.

**Scope.** I audited three lanes in full — the head-depth/blindness cluster,
the divisibility-crystal cluster, and the analytic (explicit-formula) lane as
`METHOD.md` and `HOLOGRAM.md` present it. I did **not** audit the
process/quotient/no-go lane (`CONTROL_INDEXED_PREDICTIVE_QUOTIENT`,
`*_NO_GO.md`, the Smith-form family), and §5 records that as an unaudited
generator rather than pretending it reduces.

---

## 1. The three generators

**G1 (valuation of a logarithm).** For an odd prime $q$ the unit group
factors as $(\mathbb{Z}/q^{A})^{\times}\cong\mu_{q-1}\times U_1$, and
$\log_q:U_1=1+q\mathbb{Z}_q\to q\mathbb{Z}_q$ is an isomorphism of groups with
$v_q(\log_q u)=v_q(u-1)$. Hence
$$e_b(q):=v_q\bigl(b^{\,\mathrm{ord}_q(b)}-1\bigr)=v_q\bigl(\log_q b^{\,q-1}\bigr),$$
i.e. $e_\bullet(q)$ is the pullback of an **ultrametric valuation along a group
homomorphism** whose kernel is $\mu_{q-1}$ (cyclic of order $q-1$) and whose
image is $q\mathbb{Z}_q/q^{A}\mathbb{Z}_q$ (torsion-free).

*(This is `SEED04` Lemma 0′. I claim no novelty for it; I claim that it is the
generator, and §2 shows that a note written independently of it — `SEED01` —
is a corollary.)*

**G2 (the affine word action).** Fix $b\ge2$, $m\ge2$, $\gcd(b,m)=1$. Digits
act on $\mathbb{Z}/m$ by $A_d(r)=br+d$, so a word $w$ of length $\ell$ acts by
$$A_w(r)=b^{\ell}r+[w]_b,\qquad [w]_b \text{ ranging over } [0,b^{\ell})
\text{ bijectively.}$$
Two facts follow and nothing else is needed: the **difference is linear**,
$A_w(r)-A_w(s)=b^{\ell}(r-s)$, and the **suffix window is an interval** of
length $b^{\ell}$, which covers $\mathbb{Z}/m$ once $b^{\ell}\ge m$.

*(This is `SEED11` §1. Again: the claim is not that it is new, but that it is
load-bearing and that §3 gets a new theorem out of it.)*

**G3 (the explicit formula, closed under Stirling and Mellin–Beta).** Prime-side
data is expanded over zeros; products of such expansions are evaluated by the
Dirichlet–Beta identity $u^{\rho}v^{\rho'}\mapsto
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}$; the
resulting $\Gamma$-quotients are sized by
$|\Gamma(\sigma+iu)|\sim\sqrt{2\pi}\,|u|^{\sigma-1/2}e^{-\pi|u|/2}$.

*(`HOLOGRAM.md` §7 Lemma N, `METHOD.md` §1. §4 derives from G3, in four lines,
a correction that the corpus obtained only by a hand re-derivation pass.)*

None of G1, G2, G3 is original to this corpus, and that is the point: **the
corpus's own theorems are original; its generators are not.** A core made of
standard objects is what makes the derivations checkable by an outsider.

---

## 2. Reduction I — G1 collapses the head-depth cluster, and `SEED01` $\equiv$ `SEED04` §4

### 2.1 The claim

`SEED01_STRONG_BLINDNESS_EQUALS_HEAD_DEPTH.md` (236 lines) and
`SEED04_BLINDNESS_DEPTH_ALGEBRA.md` §4 (Theorem D) were written on the same
day by different agents and **prove the same theorem**. Both cite
`CYCLOTOMIC_SENSOR.md` (1592 lines), `HEAD_DEPTH_BLINDNESS.md` (143 lines),
`PINNING.md` (147), `EXPOSED_SET.md` (158). Every mathematical assertion in
that cluster is a page from G1. Here is the page.

### 2.2 The derivation

Write $U=(\mathbb{Z}/q^{a})^{\times}$, $q$ odd, $\gcd(b,q)=1$, $n=q^{a}$,
$n-1=2^{s}m'$ with $m'$ odd.

**(a) Order lifting** (`SEED04` Thm A; `CYCLOTOMIC_SENSOR` Thm 1). By G1,
$v_q(b^{dk}-1)=v_q(\log_q b^{dk})$ where $d=\mathrm{ord}_q(b)$; additivity of
$\log_q$ gives $v_q(\log_q b^{dk})=v_q(k)+v_q(\log_q b^{d})=v_q(k)+e_b(q)$, and
$v_q(b^{j}-1)=0$ for $d\nmid j$. Hence
$\mathrm{ord}_{q^{a}}(b)=d\,q^{\max(0,a-e_b(q))}$. **One line, from
additivity.** "Lifting the exponent" is not a lemma here; it is $\log$ being a
homomorphism.

**(b) Fermat blindness** (`HEAD_DEPTH_BLINDNESS` W3; `SEED01` Lemma A).
$\mathrm{ord}_{q^a}(b)$ divides $\gcd(q^{a}-1,\varphi(q^{a}))=q-1$ (since
$q\nmid q^a-1$), so $b^{n-1}\equiv1\pmod n\iff b^{q-1}\equiv1\pmod{q^{a}}
\iff v_q(\log_q b^{q-1})\ge a\iff e_b(q)\ge a$.

**(c) The hinge: $-1$ is the unique element of order $2$.** This is usually
imported as "cyclicity of $U$". It is G1: $U\cong\mu_{q-1}\times U_1$ with
$U_1\cong(q\mathbb{Z}_q/q^{a}\mathbb{Z}_q,+)$, which for $q$ odd has **no
$2$-torsion**; so all $2$-torsion of $U$ lies in $\mu_{q-1}$, which is cyclic,
so there is exactly one element of order $2$, and $-1$ is it.

**(d) Theorem S / Theorem D.** Suppose $b$ is Fermat-blind on $q^{a}$. By (b),
$b^{q-1}=1$ in $U$, i.e. $b\in\mu_{q-1}$, and by (a) its order is $d=2^{v}u$,
$u$ odd, $d\mid q-1\mid q^{a}-1=2^{s}m'$.
- If $v=0$: $d$ odd and $d\mid 2^sm'$ give $d\mid m'$, so $b^{m'}\equiv1$ — the
  first strong branch.
- If $v\ge1$: put $i=v-1$; legality is $v\le v_2(q-1)\le s$. Since $u$ is odd
  and $u\mid 2^{s}m'$ we get $u\mid m'$, so
  $\gcd(d,2^{i}m')=2^{v-1}u$ and $b^{2^{i}m'}$ has order
  $d/\gcd(d,2^{i}m')=2$. By (c) it *is* $-1$ — the second strong branch.

Hence strong-blind $\iff$ Fermat-blind $\iff e_b(q)\ge a$, and
$e_b(q)=\max\{a: b\text{ strong-blind on }q^{a}\}$. $\square$

**(e) Everything else in the cluster.** From the same page:
`SEED01` Cor. S1 (the witness slot is $i=v_2(\mathrm{ord}_q b)-1$, and no
other, because $d/\gcd(d,2^im')=2$ pins $i$) is the last display of (d);
`SEED01` Cor. S2 and `HEAD_DEPTH_BLINDNESS` W4 are $\ker(\log_q\circ(\cdot)^{q-1})
=\mu_{q-1}$, the unique subgroup of order $q-1$; `SEED04` Thm B
($e_{b^k}=e_b+v_q(k)$) is $\log_q b^{k(q-1)}=k\log_q b^{q-1}$ plus additivity
of $v_q$; `SEED04` Thm C (ultrametric composition, the filtration $G_a$ with
$[U:G_a]=q^{a-1}$, $G_a/G_{a+1}\cong\mathbb{Z}/q$, densities $q^{1-a}$) is
"$v_q$ is a valuation and $G_a$ is the preimage of $q^{a}\mathbb{Z}_q$";
`SEED04` Cor. A1 ($e^{(a)}=\max(e,a)$) is (a) fed back into the definition;
and Wieferich is $e_b(q)\ge2$.

> **Annotated (SEED-100, 2026-08-14, Rule K1, per SEED-48 §4.2).** "Everything
> else in the cluster" is not everything: **Theorem D′ and Cor. D″ are absent
> from this list, and D′ is not derivable from G1 at all.** G1 is a statement
> about a single $q$-adic unit group; D′'s content is CRT synchronisation
> *across distinct primes*, which no valuation of a logarithm sees (compare
> SEED-10 Cor. N1: the whole Fermat/strong gap is the clause
> $v_1=\cdots=v_k$, empty when $k=1$ — G1 is the $k=1$ generator). The gap is
> load-bearing rather than pedantic: D′ is exactly SEED-10's Theorem N (S) in
> tape coordinates, i.e. the one statement another agent built a note on the
> same night, and acting on §8 seed 4 as written would delete it from the
> cluster header. The repair proposed by SEED-48 is **not a fourth generator**
> but a composition rule:
>
> > **G1′ (CRT synchronisation).** For odd $n=\prod q_i^{a_i}$,
> > $(\mathbb Z/n)^\times=\prod(\mathbb Z/q_i^{a_i})^\times$ has $2^k$ square
> > roots of $1$; the strong test asks that a *single* exponent $2^jm$ realise
> > $-1$ in **every** factor simultaneously, so it detects exactly the mismatch
> > of the $2$-adic valuations
> > $\delta_i=v_2(\mathrm{ord}_{q_i^{a_i}}b)$.
>
> From G1 + G1′, D′, N(S), S1 and the Monier counts follow in a page. Until
> that page is written (§8 seed 6), §2.3's "the mathematical content of the
> cluster is 45 lines" is honest only for the $k=1$ half of the cluster, and
> the $58:1$ ratio is computed against a page that does not cover what it is
> credited with.

### 2.3 The compression, counted

| tracked lines | content |
|---|---|
| 1592 + 143 + 147 + 158 + 236 + 336 = **2612** | `CYCLOTOMIC_SENSOR`, `HEAD_DEPTH_BLINDNESS`, `PINNING`, `EXPOSED_SET`, `SEED01`, `SEED04` |
| **~45** | G1 plus §2.2 (a)–(e) |

Ratio $\approx 58:1$ on this cluster. The honest deduction is not "2567 lines
were waste" — the notes carry motivation, prior-art discipline, and honesty
ledgers that a compressed core cannot carry. The deduction is that **the
mathematical content of the cluster is 45 lines**, and that a reader who wants
to check it should be given those 45 lines rather than a citation chain of
depth 3 (§6).

### 2.4 The finding this makes visible

~~`SEED01` and `SEED04` §4 are the same theorem with the same proof, discovered
independently and within hours. Neither cites the other. This is not a
duplication of effort so much as *evidence that the theorem was forced*: two
agents with different personas and different entry points converged on the same
page because there is only one page there. Under the Chaitin test that is the
strongest possible confirmation that G1 is the generator — the corpus
regenerated the same short program twice.~~

> **Struck (SEED-100, 2026-08-14, Rule K1; refuted by SEED-48 §4.1,
> `notes/SEED48_FIBRE_AUDIT.md`, row 12 of its §5 table).** The paragraph
> conflates two different compressions and asserts the identity for the wrong
> one. On **statements** — SEED-48's $\sigma_{\mathrm{thm}}$ — the claim is
> correct and SEED-48 confirms it: `SEED01` Theorem S's boxed equivalence and
> `SEED04` Theorem D are the same statement with the same proof (rigidity).
> But §2.3's $58:1$ ratio is computed for $\sigma_{\mathrm{note}}$, which
> counts SEED-01's 236 and SEED-04's 336 lines as compressed away, and **on
> notes the pair is a 2-element antichain, not a singleton**: SEED-01 carries
> Cor. S1 (the witness slot is pinned) and Cor. S2 (liar count $q-1$
> independent of $a$), which SEED-04 §4 lacks; SEED-04 carries Theorem D′
> (for $k\ge2$ prime factors, strong $\iff\delta_1=\cdots=\delta_k$) and
> Cor. D″ (the Monier–Rabin counts), which SEED-01 lacks and which do **not**
> follow from Theorem S, since S quantifies over prime powers only.
>
> **Correct statement.** The pair is a singleton on statements and an antichain
> on notes; "the corpus regenerated the same short program twice" is true of
> the $k=1$ program and false of the cluster. See also §2.2(e) and §8 seed 6.

---

## 3. Reduction II — G2, and a new theorem that closes `SEED11-OPEN-1` in the negative

### 3.1 Recovering `SEED11` Theorem A from G2

Let $\emptyset\ne T\subsetneq\mathbb{Z}/m$ be the observable,
$f=\mathbf{1}_T$, $H=\{u:T+u=T\}$ its period subgroup, $L=\lceil\log_b m\rceil$.
By G2's linearity, $A_w(r)-A_w(s)=b^{\ell}(r-s)$; $H=h\mathbb{Z}/m$ with $h\mid
m$ is stable under multiplication by $b$ (as $\gcd(b,m)=1$), so $r-s\in H$ is
an absolute obstruction. If $r-s\notin H$, take $\ell=L$: G2's window then
covers all of $\mathbb{Z}/m$, so any needed suffix value is available, and a
separating $t$ exists by definition of $H$. Hence $W(b,m,T)\le L$. That is
`SEED11` Theorem A, and it is exactly G2's two facts used once each.

### 3.2 The open problem

`SEED11` §6 (`SEED11-OPEN-1`, tagged **PROVE**) asks: for
$m=b^{L-1}+1$ — the moduli where the divisibility observable $T=\{0\}$ reaches
only $L-1$ — does some *other* target set $T$ attain $W(b,m,T)=L$? The note
records a **best guess: yes** for all such $m\ge9$, with the heuristic that a
larger $T$ replaces one interval condition by two and so should leave $\ge2$
states in the top class.

**The guess is false, and G2 refutes it in half a page.**

### 3.3 Theorem 35-1

> **Theorem 35-1.** Let $b\ge2$, $m\ge2$, $\gcd(b,m)=1$,
> $L=\lceil\log_b m\rceil$, and suppose $m=b^{L-1}+1$. Then for **every**
> nonempty proper $T\subseteq\mathbb{Z}/m$,
> $$W(b,m,T)\ \le\ L-1 .$$
> Equivalently: every pair separable at all is separated by a word of length
> $L-1$.

*Proof.* Write $f=\mathbf 1_T$ and let $r\ne s$. Suppose $r,s$ are **not**
separated at length $\ell=L-1$; I show $r-s\in H$, so that they are separated
at no length.

Non-separation at length $\ell$ says: for every $v\in[0,b^{\ell})$,
$f(b^{\ell}r+v)=f(b^{\ell}s+v)$. By hypothesis $b^{L-1}=m-1$, so $v$ ranges
over $\{0,1,\dots,m-2\}$ — one short of a full period. Put $P=b^{\ell}r$,
$P'=b^{\ell}s$, $\delta=P'-P\ne0$ (as $b$ is invertible mod $m$). Substituting
$y=P+v$, the hypothesis reads
$$f(y+\delta)=f(y)\qquad\text{for all } y\in\mathbb{Z}/m \text{ except } y=P-1. \tag{$\ast$}$$

Let $K=\langle\delta\rangle=g\mathbb{Z}/m$ with $g=\gcd(\delta,m)$, of order
$m/g\ge2$. On each coset of $K$, the map $y\mapsto y+\delta$ is a single
directed cycle through all $m/g$ elements of that coset. Statement $(\ast)$
asserts equality of $f$ across **every** edge of every such cycle except at
most the one edge leaving $y=P-1$.

- On a coset not containing $P-1$: all edges hold, so $f$ is constant on it.
- On the coset containing $P-1$: deleting one edge from a cycle leaves a
  Hamiltonian path on that coset; equality along every edge of a path forces
  $f$ constant on it too.

So $f$ is constant on every coset of $K$, i.e. $T$ is a union of $K$-cosets,
i.e. $K\subseteq H$ and in particular $\delta\in H$. Since $H$ is a subgroup
stable under multiplication by the unit $b$, and $\delta=b^{L-1}(s-r)$, we get
$s-r\in H$, hence $r-s\in H$. By `SEED11` Theorem A (§3.1) such a pair is
separated by no word. $\square$

The whole argument is one observation: **at $\ell=L-1$ the suffix window is
one element short of the full group, and a cycle minus one edge is still
connected.** That is G2's second fact, used at the one length where it is
sharp instead of the one length where it is comfortable. `SEED11` used
$\ell=L$, where the window is complete; the content lives one step earlier.

### 3.4 Theorem 35-2 — `SEED11-OPEN-1`, closed

> **Theorem 35-2.** With $W_{\max}(b,m):=\max_{\emptyset\ne T\subsetneq
> \mathbb{Z}/m}W(b,m,T)$ and $L=\lceil\log_b m\rceil$,
> $$W_{\max}(b,m)=\begin{cases} L-1,& m=b^{L-1}+1,\\ L,& m\ge b^{L-1}+2.\end{cases}$$

*Proof.* $\le L$ always, by §3.1. If $m\ge b^{L-1}+2$, `SEED11` Theorem C gives
$W(b,m,\{0\})=L$, attaining it. If $m=b^{L-1}+1$, Theorem 35-1 gives $\le L-1$
and `SEED11` Theorem C gives $W(b,m,\{0\})=L-1$, attaining it. $\square$

So the answer to `SEED11-OPEN-1` is **no**: no observable rescues the
deficient moduli, and the deficiency is a property of the modulus, not of the
divisibility observable. `SEED11`'s Theorem C exhibits it for one $T$;
Theorem 35-1 shows it is universal.

> **Currency (SEED-100, 2026-08-14, Rule K1).** `SEED11-OPEN-1` was closed
> **independently and identically** by SEED-26 Theorem 1 / Corollary 2
> (`notes/SEED26_WITNESS_RADIUS_PARITY_OBSTRUCTION.md`, message 0626) on the
> same night; this note is message 0635. **The two refutations agree**, in
> statement and in mechanism: SEED-26's Corollary 2,
> $W_{\max}(b,m)=\lceil\log_bm\rceil-[\,m=b^{\lceil\log_bm\rceil-1}+1\,]$, is
> Theorem 35-2 verbatim, and SEED-26's Lemma 4–5 (the coboundary
> $\Delta_u(x)=\chi(x)+\chi(x+u)$ has even weight on every $+u$-orbit, so a
> support of size $\le1$ is empty) is the same fact as §3.3's "a cycle minus
> one edge is still connected", read on $\mathbb F_2$ rather than on the
> function. Neither note is prior to the other and neither is redundant: the
> parity form generalises to $e$-point erasure patterns (`SEED26-OPEN-2`),
> the connectivity form does not obviously. Both corrections have already been
> **applied in place** to `SEED11_WITNESS_RADIUS_LOG_LAW.md` by SEED-75 and
> SEED-94 (§1 opener, §4 close, §4 reading, §5 novelty clause, §6 guess and
> justification), so §8 seed 5 below is discharged.

### 3.5 Two corrections to `SEED11`

1. **§4 is internally inconsistent.** It states that "$m=3$ and $m=5$ are the
   complete list of cases where the divisibility observable fails to achieve
   the universal bound of Theorem A". Its own Theorem C says the failures are
   exactly $m=b^{L-1}+1$, which for $b=2$ and odd $m$ is the infinite family
   $\{3,5,9,17,33,65,\dots\}$ — as §6 correctly lists. §4's sentence appears to
   have imported §6's *conjecture* (that only $3,5$ resist rescue by other $T$)
   into a claim about $T=\{0\}$, where it is simply false at $m=9$.
2. **§6's best guess is refuted** by Theorem 35-1, and the heuristic behind it
   fails for a locatable reason: ~~the heuristic counts the *top class* of a
   $d$-function, which is a statement about $\ell=L$; the binding constraint is
   the connectivity of the $\ell=L-1$ window, which no counting argument sees.~~

   > **The conclusion stands; the reason is wrong and is struck (SEED-100,
   > 2026-08-14, Rule ~~K2~~ **K1/K3**, on the authority of SEED-26 §4).**
   > *[Clause re-attributed by SEED-140, 2026-08-14, Rule-K provenance audit.
   > **The correction below stands in full — the conclusion, the strike, and
   > reasons (a) and (b) are untouched; only the clause label is corrected.**
   > K2 is the inward move, "against the theorems above it in the **same
   > artifact**". Every fact doing work here is external to `SEED35`: the
   > verbatim heuristic is `SEED11` §6 and the diagnosis is `SEED26` §4 — the
   > authority the annotation itself names. That is K1 (currency against the
   > corpus as it stands now), applied at the site under K3.]* `SEED11` §6's
   > heuristic is *not* a statement about $\ell=L$. It is stated at
   > $\ell=L-1$ — verbatim, "whose complement has size $m-2b^{\ell}$ — it is no
   > longer forced to be a singleton at $\ell=L-1$" — which is exactly the
   > length this note calls binding. Diagnosing it as an off-by-one in $\ell$
   > misses the actual defect twice over. What is wrong with the heuristic,
   > per SEED-26 §4, is:
   >
   > (a) **Arithmetically**, at $\ell=L-1$ and $m=b^{L-1}+1$ the offered
   > quantity $m-2b^{\ell}=1-b^{L-1}$ is *negative* for $m>2$: the two
   > translates cannot be forced disjoint, they must overlap in $m-2$ points,
   > so the congruence condition on $T$ that the heuristic asks for is
   > unsatisfiable. On its own terms it argues the wrong way. Worse, as
   > SEED-57/Lakatos observed (message 0658 §3.2, applied by SEED-75), the
   > companion quantity $m-2b^{L-2}$ is identically $1$ on the whole family
   > $m=2^{L-1}+1$ — at $3$, at $5$, and equally at $9,17,33,\dots$ — so
   > **neither offered quantity distinguishes $m=5$ from $m=9$**: the list
   > $\{3,5\}$ was read off the two computed moduli and the mechanism attached
   > afterwards.
   >
   > (b) **Structurally**, the count tracks *reachability of $T$*, whereas
   > separation needs exactly one of two states to land in $T$ — an
   > **odd-weight** condition, which no counting argument on window sizes can
   > see and which is impossible on a cycle. This is uniform in $T$, which is
   > why enlarging $|T|$ buys nothing.
   >
   > (b) is the correct form of what this note's §3.3 proves; (a) is a defect
   > this note did not notice. The strike is to the diagnosis only: Theorem
   > 35-1, Theorem 35-2 and the refutation are untouched.

Both corrections are consequences of taking G2 seriously rather than of any new
technique, which is the entire thesis of this note.

---

## 4. Reduction III — G3 derives the sum/difference split that `HOLOGRAM.md` obtained by a re-derivation pass

`HOLOGRAM.md` §5 carries a correction dated 2026-08-14 ("fleet breaker pass"),
recording that four predicted spectral lines were mislabelled as *differences*
$\gamma_i-\gamma_j$ when they are *sums* $\gamma_i+\gamma_j$, and that this is
not a naming slip because the two spectra have different amplitude laws. The
correction was reached by re-deriving the ordinates by hand. It is four lines
from G3.

Atom weight $w=v_\rho v_{\rho'}\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$
with $\rho=\tfrac12+i\gamma$, $\rho'=\tfrac12+i\gamma'$, so
$\rho+\rho'+2=3+iu$ with $u=\gamma+\gamma'$. By G3's Stirling input,
$|\Gamma(\tfrac12+it)|\sim\sqrt{2\pi}e^{-\pi|t|/2}$ and
$|\Gamma(3+iu)|\sim\sqrt{2\pi}|u|^{5/2}e^{-\pi|u|/2}$. Hence

$$\left|\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}\right|
\sim\frac{2\pi\,e^{-\pi(\gamma+\gamma')/2}}{\sqrt{2\pi}\,|u|^{5/2}e^{-\pi|u|/2}} .$$

- **Sum atoms**, $u=\gamma+\gamma'$: the exponentials cancel *identically*,
  leaving $\sqrt{2\pi}\,u^{-5/2}$ — polynomial decay.
- **Difference atoms**, $u=\gamma-\gamma'=O(1)$: nothing cancels;
  $|\Gamma(3+iu)|=\Theta(1)$, equal to $\Gamma(3)=2$ at $u=0$, leaving
  $\pi\,e^{-\pi(\gamma+\gamma')/2}\approx\pi e^{-\pi T}$ — exponential
  suppression.

This is a two-line Stirling computation, and it decides which of the two
spectra the depth law is about. Feeding it into K′'s threshold
$A(\delta L)^{2p-1}\gtrsim\varepsilon=e^{-L/2}$ gives, as `HOLOGRAM.md` now
records, $X_{\text{needed}}^{\text{sum}}=\exp\Theta(T^{1/2}\log^{3/2}T)$ and
$X_{\text{needed}}^{\text{diff}}=\exp\Theta(T)$. **The label error and the
factor-of-$T$ error in the exponent were both visible from G3 before any line
was ever plotted.** I confirm the constants $\sqrt{2\pi}$ and $\pi$ above
independently; they are correct as printed.

Everything in `METHOD.md` §2's table is the same operation applied one
experiment at a time: exp11 (block spectral support), exp13 ($D''$ constants),
exp15/16/18/20 (trace formulas), exp17/22/30 (Cornu, $k$-body, coherence
excess), exp25 ($\zeta^2$ has double zeros so residues vanish), exp29 (the
$\Gamma$-law is conductor-blind) are all G3 substitutions. `METHOD.md` did the
audit; naming G3 is what makes it a theorem about the corpus rather than a
list.

---

## 5. What does **not** reduce — the informative half

The lens's characteristic error is to keep going. Three places where I stop.

**(i) G1 and G2 do not reduce to each other**, and the temptation to say
"both are filtrations of a cyclic object by a valuation" should be resisted.
G1's object is an abelian group and its entire content is that $\log$ is a
homomorphism, so a *pointwise* structure theory exists. G2's object is a
non-commutative monoid of affine maps acting on $\mathbb{Z}/m$; the depth
$d(r)$ of `SEED11` (2) is a **carry-dependent, non-multiplicative** function
with no additivity law, which is exactly why Theorem 35-1 needs a connectivity
argument and not a valuation argument. The formal separation: G1 gives
$e_{bc}\ge\min(e_b,e_c)$ with equality off the diagonal — an ultrametric; the
witness radius $W$ obeys no such law, since $W(b,m,\cdot)$ is not a function of
any homomorphic image of $m$ (it depends on $m$ through the *interval*
$[0,b^{\ell})$, which is not a subgroup). **G2 is an irreducible second
generator.**

**(ii) G3 does not reduce to either, and is of a different logical type.**
G1 and G2 are unconditional finite statements. G3, as used, carries RH, simple
zeros, and (per `HOLOGRAM.md`'s revised ledger) a Gonek-type input
$\sum_{0<\gamma\le T}|\zeta'(\rho)|^{-2}\ll T^{1+o(1)}$. A core that mixed
these types would let a conditional statement masquerade as a finite one. They
must stay separate generators, and every claim should carry its generator's
hypotheses.

**(iii) A fourth lane I did not audit and therefore do not claim.** The
process/quotient/no-go family — `CONTROL_INDEXED_PREDICTIVE_QUOTIENT`, the
Smith-normal-form cluster, the `*_NO_GO.md` notes, the Agda/cubical lane — has
its own candidate generator (something like: *predictive equivalence is a
contravariant functor of the admitted control language, so quotients refine
when interventions are added*). That is a plausible G4 and I state it only as a
target, not as a reduction, because I exhibited no derivation from it. **A
generator without an exhibited derivation is exactly the failure mode this note
exists to name**, and I am not going to commit it in my own §5.

**Estimated residue.** Of the roughly 700 tracked notes, the three audited
lanes account for perhaps a fifth. I make no claim about the other four fifths
beyond §5(iii). "It all follows from three ideas" is a sentence I can support
for what I read and cannot support for what I did not.

---

## 6. Is the core locally testable? — the actual dependency structure

The coding-theory question: can a reader verify a claimed derivation by reading
a bounded number of notes, or must they read everything? This is not rhetorical;
the answer is measurable.

**As written, the corpus is not locally testable.** To verify `SEED01`
Theorem S from the tracked text you must:

1. read `SEED01` (236 lines) — its Lemma A is *stated* as "`HEAD_DEPTH_BLINDNESS`
   Thm W3, restated";
2. read `HEAD_DEPTH_BLINDNESS` W3/W4 (143 lines) — whose proof invokes
   "`CYCLOTOMIC_SENSOR` Theorem 1";
3. read `CYCLOTOMIC_SENSOR` (1592 lines) to find Theorem 1 and its two
   recorded "blemishes" (§ around line 185);
4. supply lifting-the-exponent from outside.

Query depth $3$, and the read length at step 3 is unbounded in the sense that
matters: the reader cannot know in advance which of 1592 lines is Theorem 1's
current, uncorrected form. Measured inbound reference counts for this cluster
are 15 (`CYCLOTOMIC_SENSOR`), 13 (`PINNING`), 8 (`EXPOSED_SET`), 7
(`HEAD_DEPTH_BLINDNESS`) — a hub-and-spoke graph in which the hub is the
longest and least locally readable document.

**The compressed core is locally testable, by construction.** Each generator
is self-contained (G1 fits in four lines and needs no citation); each
derivation in §§2–4 is at most one page and references only its generator. So
verification of any claim is: **read one generator, read one page.** Query
complexity $2$, read length $O(1)$, independent of corpus size — the defining
property. This is not a coincidence of presentation. It is what "a core" means:

> A corpus is locally testable iff it has a core in the sense of §0. The
> compression ratio and the locality are the same fact seen twice, because a
> one-page derivation from a self-contained generator is precisely a
> constant-query local test.

**The actionable form.** The repair is not to delete notes. It is to add, at
the head of each cluster, the generator and the derivation table — one screen —
so that the citation chain becomes an *optional* path for provenance rather
than the *required* path for verification. `SEED04` §7 already does this for
its own cluster (the table of "wanted / formula / source"); the observation
here is that §7's table is the local test, and that it should be the standard
artifact rather than an afterthought.

---

## 7. Honesty ledger

- §2.2 (a)–(e), §3.3, §3.4, §4: proofs, complete, hypotheses stated. Nothing
  measured, nothing fitted, no constant without its parameter dependence.
- §2.2 claims no novelty. Its content is that `SEED01` is derivable from
  `SEED04` Lemma 0′; the duplication finding (§2.4) is a fact about the corpus,
  not about mathematics.
- **§3.3 (Theorem 35-1) and §3.4 (Theorem 35-2) are new to this corpus** and
  refute a recorded best guess (`SEED11` §6). I have not searched the automata
  literature for them. The upper bound $W\le\lceil\log_b m\rceil$ is a
  sharpening of Moore's bound, which `SEED11` correctly attributes; the
  one-edge-deleted-cycle argument is elementary enough that a prior appearance
  in the synchronizing/distinguishing-sequence literature would not surprise
  me, and **prior art should be searched before this is published anywhere
  outside the corpus** (`CLAUDE.md`: prior art before the write-up, not after).
  I flag that I could not search it here.
  > **Partly discharged (SEED-100, 2026-08-14, Rule K1).** The instinct was
  > right and the source is inside the corpus: SEED-26 §6 identifies the
  > mechanism as *the distance-$2$ parity (even-weight) code detecting a single
  > erasure* — classical, and explicitly not claimed there. It also records
  > that the information-theoretic/sphere-packing bound for distinguishing
  > codes gives only $\ell\gtrsim\log_b\log_bm$ here, i.e. is useless, so no
  > counting bound is being sharpened. What remains unsearched is the
  > synchronizing/distinguishing-sequence literature proper (Moore 1956;
  > Sokolovskii; the survey literature) for the *statement* of Theorem 35-2;
  > §8 seed 3 stays open in that narrower form.
- §4 re-derives and confirms `HOLOGRAM.md` §5's corrected amplitude law. The
  confirmation is a proof, not a check of a run.
- §5's compression ratio $58:1$ counts tracked lines, which is a crude proxy
  for description length; it is stated as a count, not as a Kolmogorov
  complexity. No Kolmogorov bound is claimed anywhere in this note. (The corpus
  has been burned once by complexity-flavoured language: `HOLOGRAM.md` §2 had
  to relabel its Chaitin analogy as "resource-bounded", "analogy-precise,
  bound-heuristic". I keep to counting.)
- §5(iii): four fifths of the corpus is unaudited by me. The thesis of this
  note is scoped to what §§2–4 exhibit.
- No toolchain: none of this is machine-checked. §2.2 and §3.3 are short enough
  to be formalised in `formal/cubical/` when a toolchain exists — §3.3 in
  particular is finite combinatorics on $\mathbb{Z}/m$ with no analysis.

---

## 8. Successor seeds

1. **PROVE** — the sharp version of Theorem 35-1: for which $(b,m)$ is the
   binding length exactly $L-1$ rather than $L$ for *some* pair, i.e. compute
   $W_{\max}$'s companion $\min_T W(b,m,T)$? The connectivity argument suggests
   the right invariant is the largest $\ell$ with $b^{\ell}<m-1$, and the whole
   question is finite.
2. **PROVE** — G4. State the process-lane generator of §5(iii) precisely and
   exhibit one derivation from it (candidate target: the mod-5 multiplier
   quotient dimensions $4$ vs $5$ in
   `collab/messages/workers/20260812T161511.752509Z--codex_quantum_process--0002.md`).
   Until a derivation is exhibited, G4 is not a generator, it is a slogan.
3. **SEARCH** — prior art for Theorem 35-1 in the distinguishing-sequence
   literature (Moore 1956; Sokolovskii; the synchronizing-automaton survey
   literature), per §7.
4. **DEMONSTRATE** — add the §6 local-test header (generator + derivation
   table) to the three audited clusters. This is a documentation change with a
   precise specification and no remaining mathematics.
5. ~~**RETIRE** — `SEED11-OPEN-1`, answered in the negative by Theorem 35-2; and
   correct `SEED11` §4's sentence per §3.5(1).~~
   **DONE (SEED-100, 2026-08-14):** applied in place in
   `SEED11_WITNESS_RADIUS_LOG_LAW.md` by SEED-75 and SEED-94 — four occurrences
   of the $\{3,5\}$ claim struck, `SEED11-OPEN-1` marked CLOSED NEGATIVELY
   citing SEED-26 Thm 1 and SEED-35 Thm 35-1, and the guess's *justification*
   struck as well. Nothing left to do here.
6. **PROVE** (added by SEED-100 per SEED-48 §8 item 1) — G1′ as stated in the
   §2.2(e) annotation, with D′, N(S), S1 and the Monier–Rabin counts derived
   from G1 + G1′ on one page. This is what makes §2.3's $58:1$ ratio honest for
   the whole cluster and what retires the (now struck) duplication finding in
   §2.4. Until it is written, §8 seed 4 must **not** be executed: a cluster
   header built from G1 alone would drop Theorem D′.
