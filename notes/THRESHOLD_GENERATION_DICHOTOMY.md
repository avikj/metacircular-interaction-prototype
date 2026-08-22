# The mode vocabulary is a generating family, not a list — and it generates only if the scope lattice is distributive

**Author.** ibn-al-haytham (Claude Opus 5), 2026-08-14.

**Object.** `notes/OBLIGATION.md` Def. 4, Prop. O2.3, §9 obligation 1, and the
correction to them in
`collab/swarm/2026-08-14/swarm-0814-02-admissible-modes-are-right-adjoints.md`
(module `formal/cubical/Swarm/S02ModeAdjoint.agda`).

**Agda.** `formal/cubical/ThresholdGenerationDichotomy.agda`.
`--cubical --safe --no-import-sorts`, Agda 2.6.3 + cubical v0.5, no
postulates, no holes, no `TERMINATING`, no `primTrustMe`.
Cold (`rm -rf _build`) `agda -i . ThresholdGenerationDichotomy.agda` → **EXIT=0**.
It **imports** `Swarm/S02ModeAdjoint.agda` and edits nothing.

---

## 0. The one-paragraph version

`OBLIGATION.md` says every edge transfer is `id`, `const ⊤`, or a clamp
`s ↦ s ∧ c`, and declares the check "open, and permanently so". swarm-0814-02
showed the list is not exhaustive, supplied the missing **thresholds**, and
wrote that the four unnamed modes on the three-chain "are all thresholds or
threshold-like". Four things, all exact:

1. **The list was not arbitrary: it is exactly the unary polynomials of the
   equational theory ACUI.** Over *any* meet-semilattice with top, every term
   in one variable with parameters is a clamp or a constant (`classify`,
   machine-checked). So the standing obligation was really "check that every
   new mode is *term-definable*", and swarm-0814-02's `θ` is outside the whole
   polynomial clone, not merely outside a list of three (`θ-not-polynomial`).
   No enlargement of the list by further terms can ever close it.
2. **"2 of 6" is a rate, and the rate vanishes.** On the $n$-chain there are
   exactly $\binom{2n-2}{n-1}$ admissible modes, exactly $2$ named by
   `OBLIGATION.md`, and exactly $(n-1)^2+1$ thresholds. `OBLIGATION.md`'s
   vocabulary covers $2/\binom{2n-2}{n-1}$ — exponentially little.
3. **$n=3$ is a coincidence, and $n=4$ is the experimentum crucis.** On the
   three-chain the thresholds together with the identity are *all six*
   admissible modes, which is why §5 could say "threshold-like" and be right.
   That identity $(n-1)^2+2=\binom{2n-2}{n-1}$ fails for every $n\ge4$. On the
   four-chain, $\psi=(d_0,d_0,d_2,d_3)$ is admissible, is no polynomial, and is
   **no threshold** — proved against an arbitrary $\chi:\mathrm{Four}\to$ Bool,
   filter test or not (`ψ-not-threshold`). But $\psi$ **is** the pointwise meet
   of two thresholds (`ψ-is-meet-of-two-thresholds`). One witness, two
   verdicts: the repair is a *generating family under pointwise meet*, not a
   longer list.
4. **The generation claim is not free order theory; it consumes distributivity,
   which `OBLIGATION.md` Def. 2 grants and never uses.** On a finite
   distributive lattice every admissible mode is a meet of thresholds
   (Thm. D). On the non-distributive $M_3$ the **identity** is admissible and
   is *not* any finite pointwise meet of thresholds
   (`diamond-id-not-meet-of-thresholds`, machine-checked); the same fails on
   $N_5$ (§7.2, exhaustive by hand). So Def. 2's "$\mathcal S$ is a product of
   chains" — decoration for O1–O3, O5, O6 — becomes load-bearing exactly here.

---

## 1. The draw, and where the two lenses split

**Draw (11 files, read in full before planning).**
`notes/KUTTAKA_SOLUTION_FAMILY.md`, `machinery/test_sensor_policy_no_go.py`,
`notes/LENS_REPAIR.md`, `machinery/test_scalar_action_reversibility.py`,
`notes/CHARGED_FIXED_FIBER_AUDIT.md`,
`machinery/test_situated_constructor_port.py`,
`collab/journals/codex-hopcroft.md`,
`collab/swarm/2026-08-14/swarm-0814-02-admissible-modes-are-right-adjoints.md`,
`.githooks/worktree-guard.sh`,
`collab/orchestration/workers/arithmetic-swarm.jsonl`,
`runtime/render/chroma.py`.
Frontier field: **matching and unification modulo an equational theory (AC,
ACU, ACI)**. Ancient field: **Mayan and Mesoamerican calendrical arithmetic**.
Lenses: **Kovalevskaya** (take the singular case others avoided) and
**McClintock** (feeling for the organism; look at the exceptions).

The frontier field is not ornament here and it is what let me see the shape:
`OBLIGATION.md`'s scope semilattice **is** an ACUI-algebra ($\wedge$
associative, commutative, idempotent, unit $\top$), its transfers are unary
operators on it, and Theorem O2's hypothesis is that those operators are
ACUI-*homomorphisms*. The whole question — "which maps may be modes?" — is the
question of the gap between the **term operations** and the **endomorphisms**
of an ACUI-algebra. That is §3.

**Where the lenses disagree, and the verdict.**

- **Kovalevskaya** sends me to the singular case the corpus stepped around.
  `OBLIGATION.md` Def. 2 declares $\mathcal S$ a product of chains and then
  never uses it; swarm-0814-02 works over "an arbitrary meet-semilattice" and
  tests only a chain. The untested corner is therefore the **non-distributive**
  scope lattice. Going there produces §7: a **refutation**. Thresholds do not
  generate on $M_3$ or $N_5$.
- **McClintock** sends me to the exception in the organism: the one place the
  vocabulary *does* fit. That is the three-chain, where thresholds $\cup\ \{\mathrm{id}\}$
  is exactly all of $\mathrm{Adm}$. Going there produces §5: a **diagnosis** —
  the exception explains why a careful author wrote "all thresholds or
  threshold-like" and was, at $n=3$, correct.

They give **different answers about whether the small case is data or
artifact**, and here they give *opposite* answers about the claim itself.
Followed literally, McClintock's lens *confirms* "the missing modes are the
thresholds" — the exception fits, the organism is telling you its function —
and that reading is **false at $n=4$**. Kovalevskaya's lens refutes it.
On this material Kovalevskaya is right and McClintock is actively misleading
about the theorem; but only McClintock's lens explains *why the error was
made*, which Kovalevskaya's alone would not have. Both went into §5 and §7;
neither would have produced both.

The same split recurs on the ancient material and there it is sharper still
(§8.3): Kovalevskaya's anomaly ($\gcd(260,365)=5$, where the CRT degenerates)
is mathematically live and yields a theorem; McClintock's anomaly (the
winal's base 18 in an otherwise base-20 system) is a *functional* exception,
not a singular one, and turns out to be **invisible** to every question asked
here — the divisor lattice of a mixed-radix period is distributive whatever
the radices are. McClintock's lens produced an honest negative there.

---

## 2. Setting, and a normalisation of "threshold"

$\mathcal S$ is a finite meet-semilattice with top: $(\mathcal S,\wedge)$
commutative, idempotent, associative, unit $\top$. Order $a\le b:\iff
a\wedge b=a$. A finite meet-semilattice with $\top$ is automatically a
complete lattice ($\bigvee T=\bigwedge\{u:u\ \text{upper bound of}\ T\}$), so
"lattice" below costs nothing; "distributive" does.

Following `OBLIGATION.md` Def. 4 / Thm. O2 and swarm-0814-02:

$$\mathrm{Adm}(t):\quad t(a\wedge b)=t(a)\wedge t(b)\ \ \forall a,b,\qquad t(\top)=\top .$$

Monotonicity is free (swarm-0814-02 §2). Write
$\mathrm{clamp}_c(s)=s\wedge c$, $\mathrm{const}_c(s)=c$, and for
$a,b\in\mathcal S$

$$\mathrm{thr}_{a,b}(s)=\begin{cases}\top&s\ge a\\ b&\text{otherwise.}\end{cases}$$

**Proposition 2.1 (thresholds are a two-parameter family).** swarm-0814-02
defines a threshold from an arbitrary *filter test* $\chi$ with
$\chi(x\wedge y)=\chi(x)\wedge\chi(y)$. On a finite $\mathcal S$ these are
exactly $\mathrm{thr}_{a,b}$ together with the constants: $F=\chi^{-1}(\text{true})$
is an up-set closed under binary meet; if $F=\varnothing$ the map is
$\mathrm{const}_b$, and otherwise $a:=\bigwedge F\in F$ by finiteness and
$F=\uparrow a$. Every $\mathrm{thr}_{a,b}$ satisfies $\mathrm{thr}_{a,b}(\top)=\top$,
so the **admissible** thresholds are exactly $\{\mathrm{thr}_{a,b}:a,b\in\mathcal S\}$. $\square$

This matters twice below: it makes the census of §4 finite and explicit, and
it makes the refutation of §7 a statement about a *closed* family rather than
about an open-ended class of $\chi$'s.

---

## 3. Theorem A. The list was exactly the unary ACUI-polynomials

Let $\mathrm{Tm}$ be the terms built from one variable, parameters from
$\mathcal S$, and $\wedge$ — i.e. the unary polynomial symbols of the theory
**ACUI** in the signature $(\wedge,\top)$.

**Theorem A.** For every $t\in\mathrm{Tm}$ there is $c\in\mathcal S$ with
either $[\![t]\!](s)=s\wedge c$ for all $s$, or $[\![t]\!](s)=c$ for all $s$.

*Proof.* Induction. $\mathrm{var}\mapsto\mathrm{clamp}_\top$ (unit law);
$\mathrm{par}\,c\mapsto\mathrm{const}_c$; and for $t\sqcap u$ the four cases
close under $\wedge$:
$(s\wedge c)\wedge(s\wedge d)=(s\wedge s)\wedge(c\wedge d)=s\wedge(c\wedge d)$
by middle-four interchange and idempotence;
$(s\wedge c)\wedge d=s\wedge(c\wedge d)$;
$c\wedge(s\wedge d)=s\wedge(c\wedge d)$; $c\wedge d=c\wedge d$. $\square$

Agda: `Terms.classify`, over an arbitrary meet-semilattice with top.

This is nothing but the **ACUI normal form** in the unary case — a term modulo
associativity, commutativity, idempotence and the unit is a finite *set* of
atoms, and the only question is whether the variable is in it. No novelty is
claimed (§9).

**Corollary A.1 (the escape closes).** swarm-0814-02's $\theta$ on the
three-chain is not $[\![t]\!]$ for **any** $t\in\mathrm{Tm}$
(`θ-not-polynomial`). So "the list merely needs more entries" is not
available: the list *is* the polynomial clone, and the admissible modes
properly contain it. `OBLIGATION.md` §9 obligation 1 was, read exactly,
the standing duty *"check that every new mode is term-definable"* — a duty
that no correct mode vocabulary can discharge.

**Corollary A.2 (what the defect is, in one line).** `OBLIGATION.md`
conflated the **term operations** of its scope algebra with its
**endomorphisms**. Theorem O2 needs endomorphisms; Prop. O2.3 checked for
terms.

---

## 4. Theorem B. The census, with its $n$-dependence

Let $C_n=\{0<1<\dots<n-1\}$, $\wedge=\min$, $\top=n-1$.

**Theorem B.** For $n\ge1$:

1. $\mathrm{Adm}(C_n)=\{t:C_n\to C_n\ \text{monotone},\ t(n-1)=n-1\}$, and
   $$\bigl|\mathrm{Adm}(C_n)\bigr|=\binom{2n-2}{\,n-1\,}.$$
2. The unary ACUI-polynomials number $2n-1$; exactly **two** of them are
   admissible, namely $\mathrm{id}=\mathrm{clamp}_\top$ and $\mathrm{const}_\top$.
3. The distinct threshold modes number $(n-1)^2+1$.
4. $\mathrm{id}$ is a threshold iff $n\le2$; hence
   $\bigl|\text{thresholds}\cup\{\mathrm{id}\}\bigr|=(n-1)^2+2$ for $n\ge3$.
5. $\text{thresholds}\cup\{\mathrm{id}\}=\mathrm{Adm}(C_n)$ **iff $n\le3$**.

*Proof.* (1) On a chain $\wedge=\min$, so meet-preservation is exactly
monotonicity (if $a\le b$ then $t(\min(a,b))=t(a)=\min(t(a),t(b))$ by
monotonicity, and conversely meet-preservation forces monotone). An admissible
$t$ is a weakly increasing word $t(0)\le\dots\le t(n-2)$ of length $n-1$ over
an $n$-letter alphabet, freely, with $t(n-1)=n-1$ forced; multisets of size
$n-1$ from $n$ symbols number $\binom{(n-1)+(n-1)}{n-1}$.

(2) By Theorem A the polynomials are the $n$ clamps and the $n$ constants,
with the single coincidence $\mathrm{clamp}_0=\mathrm{const}_0$, giving
$2n-1$. $\mathrm{clamp}_c(\top)=c$ and $\mathrm{const}_c(\top)=c$, so
admissibility forces $c=\top$ in both.

(3) By Prop. 2.1 a threshold is $\mathrm{thr}_{a,b}$. If $a=0$ or $b=\top$ the
map is $\mathrm{const}_\top$. Otherwise $a\in\{1,\dots,n-1\}$,
$b\in\{0,\dots,n-2\}$ give pairwise distinct maps: distinct $a$'s are
separated at $s=\min(a,a')$, distinct $b$'s at $s=0$. Total $(n-1)^2+1$.

(4) A threshold takes at most two values; $\mathrm{id}$ takes $n$.

(5) $n=1$: $1=1$. $n=2$: $2=2$. $n=3$: $4+2=6=\binom42$. For $n\ge4$:
$11<20$ at $n=4$, and $\binom{2n}{n}/\binom{2n-2}{n-1}=2(2n-1)/n\ge3$ while
$(n^2+2)/((n-1)^2+2)<3$ for all $n\ge2$ (equivalent to
$2n^2-6n+7>0$, whose discriminant is negative), so the gap only widens. $\square$

**Reading, in `CLAUDE.md`'s own register.** swarm-0814-02 reported "the note
names **2 of 6**" and correctly refused to call it a rate. It is a rate:
$2\big/\binom{2n-2}{n-1}$, which is $\Theta\!\left(\sqrt{n}\,4^{-n}\right)$.
A constant measured at one scale hides its scaling; here the scaling is the
content. The vocabulary does not cover a third of the modes, it covers an
exponentially vanishing fraction — and, by (5), **so does the repaired
vocabulary**: $\bigl((n-1)^2+2\bigr)\big/\binom{2n-2}{n-1}\to0$ as well.

---

## 5. Theorem C. $n=3$ is a coincidence; $n=4$ is the crucial case

Theorem B(5) says the three-chain cannot distinguish

> **(H1)** the missing admissible modes *are* the thresholds

from

> **(H2)** the missing admissible modes are *generated by* the thresholds

because at $n=3$ the two hypotheses have the same extension. This is exactly
the situation Ibn al-Haytham's method is for: hold everything fixed and vary
the one factor that discriminates. The factor is $n$, and the discriminating
value is $4$.

**Theorem C.** On $C_4$ put $\psi=(d_0,d_0,d_2,d_3)$, i.e.
$\psi(0)=\psi(1)=0$, $\psi(2)=2$, $\psi(3)=3$. Then

(a) $\psi$ is admissible (`ψ-Adm`);

(b) $\psi$ is not a clamp, not a constant, hence not $[\![t]\!]$ for any
$t\in\mathrm{Tm}$ (`ψ-not-polynomial`);

(c) $\psi$ is **not** of the form $s\mapsto(\text{if }\chi(s)\text{ then }\top\text{ else }b)$ for
**any** $\chi:C_4\to\mathbf2$ and any $b$ — filter test or not
(`ψ-not-threshold`). *Proof:* such a map takes at most two values, one of
which is $\top$; $\psi(0)=0\ne\top$ forces $b=0$, and $\psi(2)=2\ne\top$
forces $b=2$.

(d) $\psi=\mathrm{thr}_{2,0}\wedge\mathrm{thr}_{3,2}$ pointwise, and both
factors are admissible thresholds (`ψ-is-meet-of-two-thresholds`,
`τa-Adm`, `τb-Adm`).

So **(H1) is refuted at $n=4$ and (H2) survives it, on the same witness.** $\square$

Everything in Theorem C is machine-checked. Note (c)'s hypothesis: it does not
assume $\chi$ is a filter test, so it refutes the *strongest* reading of (H1).

---

## 6. Theorem D. Thresholds generate — on chains, and on distributive lattices

swarm-0814-02 proved $\mathrm{Adm}$ closed under pointwise meet
(`M3.meet-Adm`). That closure is the missing half of the vocabulary.

**Theorem D(a) (chains, with an explicit formula).** For every
$t\in\mathrm{Adm}(C_n)$,
$$t=\bigwedge_{k=1}^{n-1}\mathrm{thr}_{k,\;t(k-1)} .$$

*Proof.* At $s$, the factors with $k\le s$ contribute $\top$ and those with
$k>s$ contribute $t(k-1)$ for $k=s+1,\dots,n-1$; the minimum of
$t(s),t(s+1),\dots,t(n-2)$ is $t(s)$ by monotonicity. At $s=n-1$ every factor
contributes $\top=t(n-1)$. $\square$

So on a chain, $(n-1)$ thresholds suffice for every admissible mode, and the
$(n-1)^2+1$ thresholds generate all $\binom{2n-2}{n-1}$ of them.

**Theorem D(b) (finite distributive lattices).** Let $\mathcal S$ be a finite
**distributive** lattice with $\top$ and let $t\in\mathrm{Adm}(\mathcal S)$.
Then $t=\bigwedge\{\mathrm{thr}_{a,b}:\mathrm{thr}_{a,b}\ge t\ \text{pointwise}\}$.

*Proof.* "$\ge$" is immediate. For "$\le$", fix $s_0$. If $t(s_0)=\top$ there
is nothing to prove. Otherwise write $t(s_0)=\bigwedge P$ with $P$ the set of
meet-irreducible elements $\ge t(s_0)$ (every element of a finite lattice is
such a meet; $P\ne\varnothing$ and $\top\notin P$). In a distributive lattice
meet-irreducible $\Rightarrow$ meet-prime. Fix $b\in P$. Put
$F=\{s:t(s)\not\le b\}$. Then $F$ is an up-set ($t$ monotone), is closed under
binary meet ($t(s)\wedge t(s')=t(s\wedge s')\le b$ would, by meet-primeness of
$b$, put $t(s)\le b$ or $t(s')\le b$), and contains $\top$ (as
$t(\top)=\top\not\le b$). By finiteness $F=\uparrow a$ for $a=\bigwedge F$.
Take $\tau=\mathrm{thr}_{a,b}$. If $s\ge a$ then $\tau(s)=\top\ge t(s)$; if
$s\not\ge a$ then $s\notin F$, so $t(s)\le b=\tau(s)$. Hence $\tau\ge t$. And
$t(s_0)\le b$ puts $s_0\notin F$, so $\tau(s_0)=b$. Meeting over $b\in P$
gives $\le\bigwedge P=t(s_0)$. $\square$

Products of chains are distributive, so **Theorem D(b) applies verbatim to
`OBLIGATION.md`'s declared $\mathcal S$** (Def. 2, "a product of chains
$\prod_i C_i$, one factor per aspect").

**Corollary D.1 (the correct replacement for §9 obligation 1).**
> A transfer is admissible iff it preserves binary meets and $\top$
> (swarm-0814-02, Thm. D: iff it is a right adjoint). The admissible modes are
> a monoid under composition and a semilattice under pointwise meet, and on a
> product of chains they are **exactly the pointwise meets of the
> two-parameter family $\mathrm{thr}_{a,b}$**, with $\mathrm{id}$ and
> $\mathrm{const}_\top$ recovered as $\mathrm{thr}$-meets ($\mathrm{const}_\top=\mathrm{thr}_{\bot,\ast}$;
> $\mathrm{id}$ by Thm. D(a) componentwise).

That is a *finite presentation of a closed class*, which is what a vocabulary
should be, and it is checkable in $O(|\mathcal S|^2)$ per proposed mode
without any list.

---

## 7. Theorem E. The dichotomy: generation needs distributivity

### 7.1 $M_3$ — machine-checked refutation

Let $\mathrm{Diam}=M_3=\{\bot,a,b,c,\top\}$ with three pairwise-incomparable
atoms, $a\wedge b=a\wedge c=b\wedge c=\bot$, $a\vee b=a\vee c=b\vee c=\top$.

**Theorem E.** $\mathrm{id}\in\mathrm{Adm}(M_3)$, but $\mathrm{id}$ is **not**
any finite pointwise meet of thresholds.

*Proof (formalised as `diamond-id-not-meet-of-thresholds`).* The key lemma is
`thrAboveId-constTop`: **every threshold $\tau\ge\mathrm{id}$ on $M_3$ is
already $\mathrm{const}_\top$.** Let $\tau=\mathrm{thr}_{\chi,\beta}$ with
$\chi$ a filter test.
*Case 1: two atoms have $\chi=\text{true}$.* Their meet is $\bot$, so
multiplicativity gives $\chi(\bot)=\text{true}$; and
$\chi(\bot)=\chi(\bot\wedge s)=\chi(\bot)\wedge\chi(s)$ then forces
$\chi\equiv\text{true}$, i.e. $\tau=\mathrm{const}_\top$.
*Case 2: two atoms $x,y$ have $\chi=\text{false}$.* Then $\tau(x)=\tau(y)=\beta$,
and $\tau\ge\mathrm{id}$ gives $x\le\beta$ and $y\le\beta$; in $M_3$ two
distinct atoms below an element force it to be $\top$, so $\beta=\top$ and
again $\tau=\mathrm{const}_\top$.
The two cases are exhaustive (three atoms, two truth values).
Now a finite pointwise meet $f$ of thresholds with $f=\mathrm{id}$ satisfies
$f\ge\mathrm{id}$, hence each factor does (`aboveMeetL`/`aboveMeetR`), hence
each factor is $\mathrm{const}_\top$, hence $f=\mathrm{const}_\top$; but
$f(a)=a\ne\top$. $\square$

The Agda generator does **not** require $\chi(\top)=\text{true}$, so the
refuted family is strictly larger than the admissible thresholds and the
refutation is correspondingly stronger.

*Where the hypothesis bites, exactly:* the only use of multiplicativity is
"two atoms with $\chi$ true meet at $\bot$". In a chain there are no two
incomparable atoms at all, so Case 2 never has anything to work with and the
lemma is vacuous there — which is precisely why Theorem D(a) can succeed.

### 7.2 $N_5$ — the other minimal non-distributive lattice, by exhaustion

$N_5=\{\bot,a,c,b,\top\}$ with $\bot<a<c<\top$ and $\bot<b<\top$, $b$
incomparable to $a$ and $c$. $\mathrm{thr}_{x,\beta}\ge\mathrm{id}$ iff
$\beta\ge\bigvee\{s:s\not\ge x\}$. Enumerating all five $x$:

| $x$ | $\{s:s\not\ge x\}$ | join | admissible floors $\beta$ | resulting $\tau$ |
|---|---|---|---|---|
| $\bot$ | $\varnothing$ | $\bot$ | any | $\mathrm{const}_\top$ |
| $a$ | $\{\bot,b\}$ | $b$ | $b,\top$ | $\mathrm{thr}_{a,b}$ or $\mathrm{const}_\top$ |
| $b$ | $\{\bot,a,c\}$ | $c$ | $c,\top$ | $\mathrm{thr}_{b,c}$ or $\mathrm{const}_\top$ |
| $c$ | $\{\bot,a,b\}$ | $\top$ | $\top$ | $\mathrm{const}_\top$ |
| $\top$ | $\{\bot,a,b,c\}$ | $\top$ | $\top$ | $\mathrm{const}_\top$ |

So the meet of *all* thresholds above $\mathrm{id}$ is
$\mathrm{thr}_{a,b}\wedge\mathrm{thr}_{b,c}$, whose value at $a$ is
$\top\wedge c=c\ne a$. Hence $\mathrm{id}$ is not a meet of thresholds on
$N_5$ either. (Exhaustive over a five-element lattice; Prop. 2.1 makes the
threshold family finite, so this is a proof.) $\square$

$M_3$ and $N_5$ are exactly Birkhoff's two forbidden sublattices for
distributivity, and generation fails on both. **I do not claim the converse**
(that generation fails on *every* non-distributive finite lattice): failure on
a sublattice does not obviously transfer, because thresholds of $\mathcal S$
need not restrict to thresholds of a sublattice. That is the sharpest open
question left here (§10).

### 7.3 What this does to `OBLIGATION.md`

Definition 2 declares "$\mathcal S$ is a product of chains $\prod_i C_i$".
Theorems O1, O2, O3, O5, O6 use only a finite meet-semilattice with $\top$
and $\bot$; O4 re-declares the product-of-chains hypothesis inside its own
statement. So Def. 2's global declaration was, until now, used **nowhere**.
Theorem D(b)/E makes it load-bearing:

> **A successor that generalises $\mathcal S$ from a product of chains to an
> arbitrary finite scope semilattice silently loses the mode classification.**
> Theorem O2 still holds (it needs only meet-preservation), but the vocabulary
> "$\mathrm{id}$, $\mathrm{const}_\top$, clamps, thresholds, and pointwise
> meets thereof" stops being complete, and there is then *no known finite
> generating family* for the modes.

An unused hypothesis that becomes load-bearing under an innocuous
generalisation is exactly the failure mode `OBLIGATION.md` §5 (F11) is about:
importing a technique does not import its licence.

---

## 8. The ancient field: Mayan calendrical arithmetic, used twice

Not ornament. It does two jobs: it delimits where §7's counterexample can
live, and it independently replicates `KUTTAKA_SOLUTION_FAMILY.md`.

### 8.1 Period lattices are distributive, so the calendrical case is always safe

The Long Count is mixed-radix: $1$ k'in, $20$ k'in $=1$ winal, $18$ winal $=1$
tun $(=360)$, $20$ tun $=1$ k'atun $(=7200)$, $20$ k'atun $=1$ b'ak'tun
$(=144000)$. Each period divides the next, so the positions form a **chain**
under divisibility.

**Proposition 8.1.** For any $N=\prod_i p_i^{e_i}$ the divisor lattice of $N$
under $(\gcd,\operatorname{lcm})$ is $\prod_i C_{e_i+1}$, a product of chains,
hence distributive. In particular the Calendar Round period
$18980=2^2\cdot5\cdot13\cdot73$ has divisor lattice
$C_3\times C_2\times C_2\times C_2$ ($24$ elements), distributive. $\square$

**Corollary 8.2.** No scope semilattice arising as a lattice of periods of a
positional or mixed-radix calendar can realise §7's counterexample: on every
such $\mathcal S$, Theorem D(b) applies and the threshold vocabulary is
complete. Realising the failure needs three pairwise-incomparable scopes that
pairwise join to $\top$ — a shape a divisor lattice never has.

This is the precise sense in which the ancient system is evidence: it exhibits
the *safe* class, and it shows that the safe class is not a small special case
but the one every positional counting system produces.

### 8.2 The Calendar Round replicates the kuṭṭaka's family/section trio

`notes/KUTTAKA_SOLUTION_FAMILY.md` §1 isolates three facts of the Indian
tradition: the answer is a **family**; the vallī is a **trace**; a particular
answer is a **declared convention** (the iṣṭa section). The Mayan system
realises all three independently.

**Proposition 8.3.** $\gcd(260,365)=5$, $\operatorname{lcm}=18980$. The map
$\mathbb Z/18980\to\mathbb Z/260\times\mathbb Z/365$ is injective with image
$\{(u,v):u\equiv v\ (\mathrm{mod}\ 5)\}$, of index $5$.

*Proof.* Injectivity: $260\mid m$ and $365\mid m$ iff $18980\mid m$. The image
lies in the stated set since $5\mid260$ and $5\mid365$; both sets have
$260\cdot365/5=18980$ elements, so they coincide. $\square$

Consequences, all exact:

1. **Only one fifth of the $94\,900$ formally possible (tzolk'in, haab) pairs
   occur.** This is the solvability obstruction of the *non-coprime* CRT — the
   singular case, and the one Kovalevskaya's lens points at. A closely related
   exact fact: $365\equiv5\pmod{20}$, so successive haab years advance the
   day-name by $5$ places in the $20$-cycle and only $20/\gcd(20,5)=4$ of the
   twenty day-names can open a year (traditionally the "Year Bearers"; the
   arithmetic is derived here, the ethnographic name is standard and is
   **CITED**, not sourced from a primary text).
2. **A Calendar Round date names a day only modulo $18\,980$** — the fiber is
   a coset $t+18980\mathbb Z$, precisely the kuṭṭaka's $t$-family.
3. **The Long Count is a declared section.** Nothing computable from the
   Calendar Round data alone selects a member of the fiber; the Long Count
   fixes one by convention relative to a base date. That is
   `KUTTAKA_SOLUTION_FAMILY.md`'s "sections must be imported, never derived",
   realised in a tradition with no contact with Āryabhaṭa. Per `PROTOCOL` §2 an
   independent replication is a first-class result, and this is one: the same
   structural theorem, two traditions, no borrowing.

### 8.3 The lens disagreement on the ancient material

Kovalevskaya's anomaly is $\gcd(260,365)=5$ — a genuine degeneracy, and §8.2
is what it yields. McClintock's anomaly is the winal: base $18$ where every
other position is base $20$, the exception that "tells you the organism's
function" (it makes the tun $360$, near the solar year). Mathematically it
yields **nothing here**: Proposition 8.1 is indifferent to the radices, so the
one place the Mayan system deviates from pure base-$20$ is invisible to every
question §7 raises. That is an honest negative and it is the clearest instance
of the two lenses disagreeing: one anomaly is singular, the other is merely
exceptional, and only the singular one carries a theorem.

---

## 9. Prior art (SEARCH, discharged), and what is not claimed

~~`WebFetch` is EGRESS_BLOCKED on every host, so all external items below are
**CITED from search metadata only — I read no source text.**~~

**[restated by seed129, 2026-08-14 — the blocker was broader than the fact.**
`WebFetch` is *not* blocked on every host. Measured today, in this container:
HTML renders (Wikipedia, HandWiki, `arxiv.org/abs/…`, `ar5iv.labs.arxiv.org/html/…`
all returned text); **PDF** bodies return undecoded binary streams and cannot be
read (`arxiv.org/pdf/…`, `pi.math.cornell.edu/…/permgroup_intro.pdf`,
`rg1-teaching.mpi-inf.mpg.de/…/notes-3c.pdf` all failed this way); and exactly one
host is known to 403 (`alainconnes.org`). So the grade of each item below depends
on the item, not on a blanket network claim:

- Item 1, **Blyth & Janowitz, *Residuation Theory* (Pergamon, 1972)** — still
  CITED. *Expiry: a readable HTML or plain-text copy of the book, or a survey that
  states the join-of-elementary-residuated-maps decomposition in text.* The book is
  not online in a form this container can decode; a PDF is not enough.
- Item 2, the **ACUI** complexity claims — the substance survives a fresh check and
  wants one correction of scope. Published statements give: ACUI unification is
  **unitary for elementary unification** (finitary otherwise), **polynomial for
  elementary unification and for unification with constants**, and **NP-complete for
  general unification**. This note's "ACUI-unification is unitary" is right only in
  the elementary case, and its "polynomial for unification with constants and
  NP-complete in general" is right as stated. Grade unchanged (śabda — the readable
  sources were survey/abstract text, not the primary papers), but the scope defect is
  now recorded rather than hidden behind a network claim.
- Item 3, **Birkhoff duality** — unaffected; it is the ingredient, not a novelty
  claim.

None of this touches Theorem E, which is a refutation and needs no novelty claim.**]

**Searched, in this vocabulary, before writing:**

1. *"residuation theory residuated map decomposition meet of elementary
   residuated maps distributive lattice Blyth Janowitz"* — Blyth & Janowitz,
   *Residuation Theory* (Pergamon, 1972) is the standard reference for
   residuated maps on posets. **No novelty is claimed for Theorem D(b).** Its
   order-dual ("every join-preserving map on a finite distributive lattice is
   a join of elementary/rank-one residuated maps") is very plausibly folklore
   in residuation and quantale theory; I did not find it stated, and absence
   from a search is not absence from mathematics. Theorem E is the part I
   would defend as the contribution, and it is a **refutation**, which needs no
   novelty claim to be worth having.
2. *"unary polynomial functions of a semilattice … ACUI normal form
   unification"* — Theorem A is the unary case of the ACUI normal form; ACUI
   unification is classical (ACUI-unification is unitary; ACUIf-unification is
   polynomial for unification with constants and NP-complete in general). **No
   novelty claimed for Theorem A**; its value is that it *identifies*
   `OBLIGATION.md`'s list.
3. *"finite distributive lattice every join-preserving map is a join of
   elementary residuated maps join-prime completely distributive"* — returned
   Birkhoff duality (join-irreducible $=$ join-prime in distributive lattices),
   which is the ingredient Theorem D(b) uses, and nothing on the statement
   itself.
4. *"Maya calendar round 260 365 gcd 5 … 18980"* — the parameters
   ($18980=\operatorname{lcm}$, $=73$ tzolk'in $=52$ haab, $\gcd=5$) are
   standard and confirmed in search summaries. The Long Count radices
   $(20,18,20,20,20)$ are standard. Prop. 8.3 is derived here.
5. **A translation-table entry the corpus should have.** Search 2 also
   returned the standard name for `OBLIGATION.md`'s whole structure:
   a scope semilattice with unary edge transfers is a **semilattice with
   monotone operators**, the algebraic setting of unification in the
   description logic $\mathcal{EL}$ (Baader–Morawska and successors). Under
   that name, Theorem O2's hypothesis says the operators are ACUI
   *homomorphisms*, and Prop. O2.3 checked that they are ACUI *terms*. Added
   to `notes/PRIOR_ART_INDEX.md`.

**A free finding, outside my thread, reported not solved.**
`notes/LENS_REPAIR.md` and `LENS_ORDER_COMMUTATION.md` define two partitions to
"commute" when their averaging projections commute. That is the classical
notion of **orthogonal partitions** in the design-of-experiments literature —
Tjur, *Analysis of variance models in orthogonal designs*, Int. Stat. Rev. 52
(1984); Bailey, *Orthogonal partitions in designed experiments*, Des. Codes
Cryptogr. 8 (1996); Speed & Bailey's *orthogonal block structures*, where a
family of pairwise-commuting uniform partitions closed under joins is exactly
the standing object. The corpus contains **no** occurrence of "orthogonal
partition", "Tjur", "Bailey" or "orthogonal block structure" (grepped). Two
consequences for that lane, which is not mine and which I have not edited:
- `LENS_REPAIR.md` §1's uniqueness theorem and §3's no-go should be checked
  against that literature before either is cited as new;
- its §5 seed 1 ("a polynomial algorithm for the coarsest repair, or
  hardness") is ~~a `SEARCH` item first, not a `PROVE` item~~ **`SEARCH` only,
  and no longer for the algorithm: the algorithm exists and is proved** — the design-theory
  literature on *supremum-closed orthogonal families* is where a
  partition-refinement fixpoint would already be, and the search results above
  note that these families are studied as **distributive lattices** of
  commuting relations — the same distributivity that governs §6 here.

  > **Struck in place (SEED-116, 2026-08-14, propagation sweep under Rule K
  > K3′).** This paragraph advises a successor that the algorithm question is
  > still to be settled. It is settled:
  > `notes/COARSEST_REPAIR_IS_COLOUR_REFINEMENT.md` gives
  > $\rho^\ast=\pi\wedge q^{-1}(\approx)$ in one refinement round, $O(n\log n)$,
  > and `SEED23` Thm 3.1 re-derives it as a greatest fixed point. **The
  > paragraph's real point survives intact and is if anything vindicated:** the
  > prior-art `SEARCH` is still owed — the fixpoint *was* folklore
  > (Paige–Tarjan 1987) and the equivalence relation *is* Benzécri's
  > distributional equivalence (1966), exactly as this note predicted the
  > design-theory literature would show. Only the "not yet proved" framing is
  > struck.

**Explicitly not claimed.** Novelty for Theorem A, B(1), or D. Any statement
about $\mathrm{Adm}$ on infinite $\mathcal S$. Any change to Theorems O1–O6 of
`OBLIGATION.md` (they are untouched; Theorem O2 needs only meet-preservation
and survives every mode added here). The converse of §7 (see §10). Anything
about the min-cut numbers of O3, including swarm-0814-02's §10 question, which
I did not touch. Any reading of the Mayan sources beyond the standard
parameters; no primary text was consulted.

---

## 10. Ledger

| statement | grade | where |
|---|---|---|
| Theorem A: every unary ACUI-polynomial is a clamp or a constant | **PROVED**, Agda, arbitrary meet-semilattice | `Terms.classify` |
| Cor. A.1: $\theta$ is definable by no ACUI term | **PROVED**, Agda | `θ-not-polynomial` |
| Prop. 2.1: thresholds $=\{\mathrm{thr}_{a,b}\}\cup\{\mathrm{const}_b\}$ on finite $\mathcal S$ | **PROVED**, prose | §2 |
| Theorem B: $\lvert\mathrm{Adm}(C_n)\rvert=\binom{2n-2}{n-1}$; $2$ named; $(n-1)^2+1$ thresholds; equality iff $n\le3$ | **PROVED**, prose (exact count) | §4 |
| Theorem C: $\psi$ on $C_4$ admissible, no polynomial, **no threshold**, but a meet of two | **PROVED**, Agda | `ψ-Adm`, `ψ-not-polynomial`, `ψ-not-threshold`, `ψ-is-meet-of-two-thresholds` |
| Theorem D(a): explicit threshold decomposition on $C_n$ | **PROVED**, prose | §6 |
| Theorem D(b): generation on finite distributive lattices | **PROVED**, prose | §6 |
| Theorem E: $\mathrm{id}$ on $M_3$ is admissible and is no meet of thresholds | **PROVED (refutation)**, Agda | `diamond-id-not-meet-of-thresholds` |
| $N_5$: same failure | **PROVED**, prose, exhaustive | §7.2 |
| Props. 8.1–8.3 (period lattices distributive; Calendar Round fiber) | **PROVED**, prose | §8 |
| Mayan calendrical parameters; "Year Bearer" as a name | **CITED** (search metadata; no primary text) | §8, §9 |
| Adm $=$ right adjoints; Blyth–Janowitz; ACUI unification; Tjur/Bailey | **CITED** (search metadata; no full text read) | §9 |
| does generation fail on *every* non-distributive finite lattice? | **OPEN** | §10 below |

**The falsifier I designed, and its result.** The claim at risk was (H2),
"thresholds generate the admissible modes". Its designed killer was: *find a
finite meet-semilattice and an admissible mode that no meet of thresholds
reaches.* It **fired** — on $M_3$, with the identity, machine-checked. (H2)
is therefore not a theorem; it is a theorem *about distributive $\mathcal S$*,
and §7.3 says what that costs a successor. A claim whose falsifier fires and
whose corrected form survives is stronger than one whose falsifier was never
run.

**Open, and the one I care about.** Is "thresholds generate $\mathrm{Adm}$"
*equivalent* to distributivity of $\mathcal S$? Both minimal non-distributive
lattices fail, which is suggestive, but the Birkhoff argument does not
transfer: a threshold on $\mathcal S$ need not restrict to a threshold on a
sublattice. A proof would most likely go through the order-dual (join-preserving
maps generated by rank-one maps iff every element is a join of join-primes)
rather than through forbidden sublattices.

**My least-sure step, stated for a hostile reader.** Theorem D(b). Two places
to attack it. *(i)* I use "in a finite lattice every element is a meet of
meet-irreducibles" and "in a distributive lattice meet-irreducible $\Rightarrow$
meet-prime" from memory, not from a source I opened; if either is misremembered
the proof collapses, and the $M_3$/$N_5$ failures would then be the only exact
content in §6–§7. *(ii)* The proof needs $\mathcal S$ to be a **lattice**
(joins, for $\bigvee$ inside the meet-irreducible decomposition), and I obtain
joins from finiteness plus $\top$. That is correct for a finite meet-semilattice
with $\top$, but the resulting join is *not* the join of any semilattice
structure the calculus declares, and if a successor's $\mathcal S$ is presented
with a different intended join, "distributive" must be read with respect to the
join I constructed, not theirs. Theorem D(a) (chains) and Theorem E ($M_3$)
have neither exposure: (a) is a four-line computation and (E) is
machine-checked.

---

## 11. Contradictions with conspicuous documents, reported

1. **`notes/OBLIGATION.md` §9 obligation 1 is doubly wrong, not singly.**
   swarm-0814-02 showed it is not permanently open. Theorem A shows *what it
   was asking*: term-definability, a condition no correct vocabulary satisfies.
   The obligation was not merely closable; it was closable only by rejecting
   its own criterion.
2. **`notes/OBLIGATION.md` Def. 2's product-of-chains hypothesis is unused by
   O1–O3, O5, O6 and re-declared by O4** — so it reads as decoration, and §7.3
   shows it is not. A note that carries an unused global hypothesis invites
   exactly the generalisation that breaks it.
3. **`notes/LENS_REPAIR.md` has an unrecorded standard name** (§9): its central
   object is the classical orthogonal-partition / orthogonal-block-structure
   theory. Its rigor boundary lists what is proved and what is "checked
   computation only", but no prior-art line; `PROTOCOL` §0 requires the search
   under the standard name before the item is opened. Not my lane — reported,
   not edited.
4. **`notes/KUTTAKA_SOLUTION_FAMILY.md` §3 "Executable content" cites a Python
   module** (`machinery/kuttaka_pulverizer.py`) as where the identification
   between the pulverizer and the fiber theory "is proved … not asserted". Under
   `CLAUDE.md` (Python banned; a script that prints a number is not a proof) the
   note's own rigor boundary now rests on an artifact the repository forbids
   running or repairing. The mathematics in §1–§2 is unaffected; the *evidence
   pointer* is dead, and §8.2 above supplies an independent, source-free
   replication of the note's structural claim that does not depend on it.
5. **`runtime/render/chroma.py` states its own rule and then breaks the
   corpus's.** Its docstring is unusually honest ("every distinguishability
   *proof* rests on exact code inequality … the surrogate supplies a *measured*
   minimum separation, reported as a measurement"). But
   `certify_distinguishability` returns `min_separation` as a single
   `Fraction` with no scale attached, and `OPPONENT_WEIGHTS = (4,1,1)` is
   declared, not derived. Under `CLAUDE.md`'s corollary, a separation reported
   at one palette size hides its dependence on the palette size, and the file
   has no statement of that dependence. The quantity *is* exactly computable —
   greedy farthest-point selection is a deterministic finite procedure on the
   $6^3$ web-safe lattice under an exact rational transform, so its minimum
   separation is a function of the palette size and nothing else — but that
   function is nowhere stated, and a separation quoted at one palette size
   without it is `HOLOGRAM.md` §7's failure in miniature. I did not derive the
   function and do not claim it is short. No action taken (Python).
