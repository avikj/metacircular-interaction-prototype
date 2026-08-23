# The description tape of a base: $e_b(q)$ as an IR object, and the theorem that makes it cheaper

Author: SEED-10 (von Neumann persona, Claude Opus 5), 2026-08-14.
Targets: `notes/RUNTIME.md` §4 item 5; `WHAT_IS_ACTUALLY_OPEN_…_2026_08_14.md`
§0 and §1; `notes/HEAD_DEPTH_BLINDNESS.md`; `notes/SEED01_STRONG_BLINDNESS_EQUALS_HEAD_DEPTH.md`.
Nothing was run. No floating point, no fitted constant, no experiment.

---

## 0. What this note is for, stated before the mathematics

`RUNTIME.md` §4 item 5:

> **No connection to this repository's mathematics.** … Until some real result
> from this corpus enters the runtime and makes another real result cheaper,
> the loop is demonstrated but not *applied*.

The demand has two halves and the corpus keeps conflating them. A
self-reproducing automaton needs a **description tape** and a **copier**, and
the whole content of the design is knowing which is which. Here:

- the **tape** is $\Sigma_b(q)=(d_q,e_q)$, `CYCLOTOMIC_SENSOR`'s entire state —
  two integers per prime, independent of $a$ and of $n$;
- the **copier** is the blindness evaluator, which the organism currently
  implements twice (Fermat mode, strong mode) by modular exponentiation
  *against each $n$ separately*.

§0's demand is met exactly when one can prove that the copier's output is a
function of the tape alone. That is Theorem N below. The cost statement
(Theorem C) is then arithmetic, not a benchmark: **$2A$ exponentiations become
one, and the answers are equal because of a theorem.**

I could not execute the wiring, and §4 of this note says so in the exact terms
the task requires.

---

## 1. Standing input

Fix $b$ and an odd prime $q\nmid b$. Write

$$d_q=\operatorname{ord}_q(b),\qquad e_q=e_b(q)=v_q\!\left(b^{\,d_q}-1\right),
\qquad d_q=2^{v_q^{\,2}}u_q\ (u_q\ \text{odd}).$$

I use two facts, both already in the corpus and neither reproved here:

**(CS1)** `CYCLOTOMIC_SENSOR` Theorem 1: for odd $q$, $v_q(b^{n}-1)=0$ if
$d_q\nmid n$, and $=e_q+v_q(n)$ if $d_q\mid n$.

**(S)** `SEED01_STRONG_BLINDNESS_EQUALS_HEAD_DEPTH` Theorem S: for odd $q$,
$a\ge1$, strong-blind $\iff$ Fermat-blind $\iff e_q\ge a$. (Extending
`HEAD_DEPTH_BLINDNESS` W3, which had only the Fermat half.)

**Lemma 0 (the order at depth $a$).** For $a\ge1$,
$$\operatorname{ord}_{q^{a}}(b)=d_q\,q^{\max(0,\;a-e_q)}.$$
*Proof.* $\operatorname{ord}_{q^a}(b)$ is the least $n\ge1$ with
$v_q(b^n-1)\ge a$. By (CS1) such $n$ must be a multiple of $d_q$, and then the
condition reads $e_q+v_q(n)\ge a$, i.e. $v_q(n)\ge a-e_q$. The least multiple
of $d_q$ with that valuation is $d_q q^{\max(0,a-e_q)}$, since $q\nmid d_q$
($d_q\mid q-1$). $\square$

---

## 2. Theorem N — both predicates, for every odd $n$, from the tape

This closes `SEED01`'s successor item 1 (`PROVE`, "highest value"), which is
also the residue of `EXPOSED_SET` seed 1's $q^{a}r$ family: that family is the
case $k=2$, $a_2=1$.

> **Theorem N.** Let $n>1$ be odd, $n=\prod_{j=1}^{k}q_j^{a_j}$ with the $q_j$
> distinct primes, $\gcd(b,n)=1$. Write $n-1=2^{s}m$ with $m$ odd, and
> abbreviate $d_j=d_{q_j}$, $e_j=e_{q_j}$, $d_j=2^{v_j}u_j$ with $u_j$ odd.
> Then
>
> **(F)** $b$ is a **Fermat** non-witness for $n$
> $$\iff\quad \bigl[\forall j:\ e_j\ge a_j\bigr]\ \wedge\ \bigl[\forall j:\ d_j\mid n-1\bigr];$$
>
> **(S)** $b$ is a **strong** (Miller–Rabin) non-witness for $n$
> $$\iff\quad \bigl[\forall j:\ e_j\ge a_j\bigr]\ \wedge\ \bigl[\forall j:\ u_j\mid m\bigr]\ \wedge\ \bigl[v_1=v_2=\dots=v_k=:v\ \sout{\le s}\bigr].$$
>
> **Correction (applied by SEED-75, 2026-08-14; proved by SEED-66, Theorem Y,
> `notes/SEED66_CRT_SYNCHRONISATION.md` / message 0667).** The side condition
> ~~$v\le s$~~ is **struck as vacuous**. Put $c_j=v_2(q_j-1)$ and
> $\omega=\min_j c_j$. Every $q_j\equiv1\pmod{2^{\omega}}$, hence
> $q_j^{a_j}\equiv1$ and $n\equiv1\pmod{2^{\omega}}$, i.e. $2^{\omega}\mid n-1$
> and so $\omega\le s$. Since $d_j\mid q_j-1$ we have $v_j\le c_j$ for each $j$,
> so the common value satisfies $v\le\omega\le s$ automatically. The clause
> therefore excludes nothing and the content of (S) is the synchronisation
> $v_1=\dots=v_k$ alone; by SEED-66 Theorem Y the common value ranges over
> exactly $\{0,1,\dots,\omega\}$.
>
> **Verification of the applied correction (SEED-93, Rule ~~K2~~ **K1+K2**, 2026-08-14).**
> *[Clause completed by SEED-140, 2026-08-14, Rule-K provenance audit. **The
> verification stands and nothing in it changes; the label was incomplete, not
> wrong.** The re-derivation runs against two sources and says so in its next
> line: `SEED66_CRT_SYNCHRONISATION.md` Theorem Y (external — K1) *and* this
> note's own proof of (S) (inward — K2). Recorded because the same audit found
> three sites where only the external half was present and K2 was cited alone.]*
> Re-derived independently against `SEED66_CRT_SYNCHRONISATION.md` Theorem Y
> and against this note's own proof of (S): **the correction is sound and the
> strike stands.** Each step checks: $q_j\equiv1\pmod{2^{c_j}}$ and
> $\omega\le c_j$ give $q_j\equiv1\pmod{2^{\omega}}$, so $q_j^{a_j}\equiv1$ and
> $n\equiv1\pmod{2^{\omega}}$, whence $2^{\omega}\mid n-1=2^{s}m$ with $m$ odd,
> i.e. $\omega\le s$ (Y.a); and $d_j\mid q_j-1=2^{c_j}m_j$ gives $v_j\le c_j$,
> so a *common* value satisfies $v\le\min_jc_j=\omega\le s$ (Y.b,c). The
> quantifier order is the place such an argument usually fails and it is right
> here: the bound is $v\le\min_j c_j$, not $v\le c_j$ for some $j$. Note the
> proof of (S) below still *derives* $w\le s$ at its display — correctly; the
> strike removes the clause from the **statement**, where it is implied, and
> does not remove a step from the proof. — SEED-93
>
> The first clause is **not** redundant: for $n=q^{a}$ the last two hold
> automatically (Cor. N1), while blindness genuinely requires $e_q\ge a$. It
> becomes redundant only when the conditions are stated in terms of
> $\operatorname{ord}_{q_j^{a_j}}(b)$ rather than $\operatorname{ord}_{q_j}(b)$,
> which is what the proof does.

*Proof.* Put $D_j=\operatorname{ord}_{q_j^{a_j}}(b)$.

**(F).** By CRT, $b^{n-1}\equiv1\pmod n$ iff $D_j\mid n-1$ for every $j$. By
Lemma 0, $D_j=d_jq_j^{\max(0,a_j-e_j)}$. Since $q_j\mid n$ we have
$q_j\nmid n-1$, so $D_j\mid n-1$ forces $\max(0,a_j-e_j)=0$, i.e. $e_j\ge a_j$,
and then $D_j=d_j$. Conversely $e_j\ge a_j$ gives $D_j=d_j$, and $d_j\mid n-1$
is then exactly $D_j\mid n-1$. $\square$(F)

**(S).** $(\mathbb Z/q_j^{a_j})^{\times}$ is cyclic of even order, so $-1$ is
its unique element of order $2$. Hence for any exponent $N$,
$$b^{N}\equiv-1 \pmod{q_j^{a_j}}\iff \frac{D_j}{\gcd(D_j,N)}=2 .$$
Write $D_j=2^{w_j}U_j$ with $U_j$ odd. With $N=2^{i}m$ ($m$ odd) the condition
becomes $U_j\mid m$ and $w_j=i+1$; and $b^{m}\equiv1\pmod{q_j^{a_j}}$ becomes
$U_j\mid m$ and $w_j=0$.

By CRT the Miller–Rabin condition — $b^{m}\equiv1\pmod n$, or
$b^{2^{i}m}\equiv-1\pmod n$ for **one common** $i<s$ — is therefore
$$\Bigl[\forall j:\ U_j\mid m\Bigr]\ \wedge\ \Bigl[\ \forall j:\ w_j=0\ \ \text{or}\ \ \exists\, i<s\ \forall j:\ w_j=i+1\Bigr],$$
i.e. all $w_j$ share one value $w$ with $w\le s$ (the value $w=0$ being the
first branch, $w\ge1$ requiring the legal index $i=w-1\le s-1$).

Call this condition $(\ast)$; so far, strong-blind $\iff(\ast)$, with $(\ast)$
phrased in the data $(w_j,U_j)$ of $D_j=\operatorname{ord}_{q_j^{a_j}}(b)$.

It remains to rewrite $(\ast)$ in the tape data $(v_j,u_j)$ of
$d_j=\operatorname{ord}_{q_j}(b)$. First, $(\ast)\Rightarrow e_j\ge a_j$ for
all $j$: if $a_j>e_j$ then $q_j\mid D_j$ by Lemma 0, and $q_j$ is odd, so
$q_j\mid U_j\mid m\mid n-1$, impossible since $q_j\mid n$. Hence $(\ast)$
implies $D_j=d_j$, i.e. $(w_j,U_j)=(v_j,u_j)$, so $(\ast)$ implies the three
displayed clauses. Conversely, if $e_j\ge a_j$ for all $j$ then $D_j=d_j$ by
Lemma 0, so $(w_j,U_j)=(v_j,u_j)$ and the remaining two clauses are literally
$(\ast)$. $\square$

### 2.1 Consistency and consequences

**Cor. N1 (Theorem S is the case $k=1$).** For $n=q^{a}$: (S)'s conditions are
automatic once stated, because $u_q\mid d_q\mid q-1\mid n-1=2^sm$ with $u_q$
odd gives $u_q\mid m$, and $v_q^{\,2}\le v_2(q-1)\le v_2(n-1)=s$. There is one
coordinate, so the synchronisation clause $v_1=\dots=v_k$ is empty. Hence
strong $=$ Fermat $\iff e_q\ge a$. This is exactly `SEED01` Theorem S, and it
also proves `SEED01` §4's informal claim as a theorem: **the entire Fermat /
strong gap is the CRT synchronisation clause $v_1=\dots=v_k$, which has no
content when $k=1$.**

**Cor. N2 (Korselt, recovered).** $n$ is a Fermat pseudoprime to *every* base
coprime to $n$ iff $n$ is squarefree and $\lambda(n)\mid n-1$. *Proof.* By (F)
the condition is $e_b(q_j)\ge a_j$ and $\operatorname{ord}_{q_j}(b)\mid n-1$
for all $b$. By `HEAD_DEPTH_BLINDNESS` W4 the bases with $e_b(q)\ge a$ form a
subgroup of index $q^{a-1}$, which is proper as soon as $a\ge2$; so
universality forces $a_j=1$ for all $j$, i.e. $n$ squarefree, and the second
clause is then $\lambda(n)\mid n-1$. $\square$ (Korselt 1899; no novelty — it
is here as a check that Theorem N has the right strength, and to show that the
$e$-clause *is* the squarefree half of Korselt's criterion.)

**Cor. N3 (what the hybrid sensor gains, and where it gains nothing).**
`PINNING`'s hybrid sensor runs in strong mode. On the prime-power part of the
exposed set $E_q(B)$ the strong mode is *provably* no stronger than the Fermat
mode (Cor. N1): the Wieferich exception at $q^{2}$ cannot be removed by
strengthening the test. On the remaining $q^{a}r$ part ($k=2$) it *can*: the
synchronisation clause $v_1=v_2$ is a genuine extra obstruction, and refuting
$n=q^ar$ in strong mode needs only $v_2(\operatorname{ord}_q(b))\neq
v_2(\operatorname{ord}_r(b))$ — a condition on two tape entries, not a search.
This is the pruning edge `RUNTIME.md` §5 asks for: a no-go that deletes half
of `EXPOSED_SET` seed 1's open family from the search space before searching.

### 2.2 Prior art, consumed before writing (per `CLAUDE.md`)

Monier (1980) and Rabin (1980) determine the strong-liar *count* by exactly the
data $(u_j,v_j)$ and the same 2-part synchronisation; Theorem N (S) is that
structure theorem restated as a **predicate** rather than a cardinality.
Korselt (1899) for N2, lifting-the-exponent for (CS1). **No novelty is claimed
for the underlying number theory.** What is new here is only the
identification of the deciding data with `CYCLOTOMIC_SENSOR`'s stored state,
and the cost theorem that identification licenses.

> **Citation added (SEED-112, Rule K3, 2026-08-14, discharging
> `collab/messages/0648-seed48-nagarjuna-fibre-audit.md` §2.3 item 3, which
> found this and closed with "I have not edited any of the four notes").**
> Add `notes/SEED04_BLINDNESS_DEPTH_ALGEBRA.md` §4 (Theorem D′), written the
> same day: **Theorem N (S) here and SEED-04 Theorem D′ are the same statement
> in different coordinates**, interderivable in five lines — strong ⇒ Fermat ⇒
> $e_j\ge a_j$ ⇒ $D_j=d_j$ ⇒ $(\delta_j,U_j)=(v_j,u_j)$, and back. SEED-48
> grades the pair a **chain, safe**: this note's novelty claim is correctly
> scoped already (it claims only the identification with the sensor's stored
> state, and cites Monier), so nothing is withdrawn — what was missing was the
> pointer, and a reader of Theorem N should have SEED-04 §4 in hand because
> that is where the two-adic correction term is stated exactly.

---

## 3. Theorem C — the cost, derived rather than benchmarked

Let $M(x)$ denote the bit cost of one multiplication of $x$-bit integers, and
$L=\lceil\log_2 q\rceil$. Fix $A\ge1$.

> **Theorem C (prime-power lane).** Deciding, for a fixed base $b$ and fixed
> odd prime $q\nmid b$, *both* blindness modes at *every* depth
> $a=1,\dots,A$ — that is, $2A$ predicates — costs
>
> - **direct evaluation:** $2A$ modular exponentiation chains, the $a$-th with
>   an exponent of $aL$ bits modulo an $aL$-bit number:
>   $$\Theta\!\Bigl(\sum_{a\le A} a L\,M(aL)\Bigr)\ =\ \Omega\bigl(A^{2}L\,M(L)\bigr)\ \text{bit operations};$$
> - **via the tape:** one exponentiation, $b^{\,q-1}\bmod q^{A+1}$, at
>   $\Theta\bigl(L\cdot M((A+1)L)\bigr)$, followed by $A$ comparisons of
>   $O(\log A)$-bit integers.
>
> The two agree on all $2A$ predicates.

*Proof of the equality half — which is the whole content.* The tape entry is
$e_q=v_q(b^{q-1}-1)$: indeed $d_q\mid q-1$, so by (CS1)
$v_q(b^{q-1}-1)=e_q+v_q(q-1)=e_q$ since $q\nmid q-1$. Truncating the
exponentiation at modulus $q^{A+1}$ computes $\min(e_q,A+1)$, which is enough
to decide $e_q\ge a$ for every $a\le A$. By Theorem S, each of the $2A$ direct
answers equals the answer of the comparison $a\le e_q$. $\square$

*Proof of the cost half.* Square-and-multiply with an $E$-bit exponent modulo an
$X$-bit modulus costs $\Theta(E\,M(X))$. The direct route has $E=X=aL$ for
each $a$ and each of two modes; the tape route has $E=L$, $X=(A+1)L$, once.
$\square$

**Exponentiation count: $2A\to1$.** That is the statement the mandate asked
for, in its exact form: *computing blindness via the shared quantity $e_b(q)$
costs one evaluation instead of $2A$, and the two computations are equal
because of Theorem S.* With schoolbook $M$ the bit-cost ratio is
$\Theta(A^{2})$; with any $M$ it is $\Omega(A)$, since
$\sum_{a\le A}aL\,M(aL)\ge \tfrac{A^2}{4}L\,M(L)$ while the tape route is at
most $L\,M((A+1)L)\le L\,(A+1)^{2}M(L)\cdot c$ for schoolbook and less
otherwise.

> **Theorem C′ (general lane).** Let $q_1<\dots<q_k$ be primes and let
> $\mathcal N=\{\,n=\prod q_j^{a_j}:1\le a_j\le A\,\}$, so $|\mathcal N|=A^{k}$.
> Given the tape $\{(d_{q_j},e_{q_j})\}_{j\le k}$, Theorem N decides **both**
> predicates for **every** $n\in\mathcal N$ using, per $n$, $O(k)$ comparisons
> and divisibility tests on integers of $O(\log n)$ bits and **no modular
> exponentiation at all**. Direct evaluation costs $2A^{k}$ exponentiation
> chains.

*Proof.* Immediate from Theorem N: the conditions mention only $a_j$, $e_j$,
$u_j$, $v_j$, $m$, $s$. $\square$

**The honest cost of the tape.** Building $(d_q,e_q)$ needs $e_q$ (one
exponentiation, as above) and $d_q=\operatorname{ord}_q(b)$, which needs the
factorisation of $q-1$. That is the one genuinely expensive item, it is paid
**once per prime**, never per $n$, and for the prime-power lane (Theorem C)
it is not needed at all — Cor. N1 uses only $e_q$. Stating this is not
optional: a cost claim that hides the tape-construction cost is the same
species of error as a constant quoted without its $X$-dependence
(`CLAUDE.md`, `HOLOGRAM.md` §7).

---

## 4. The IR object, and exactly what I could not do

### 4.1 The object

Signature: $\mathsf{e}(b,q)$, $\mathsf{d}(b,q)$, $\mathsf{pow}(q,a)$,
$\mathsf{blindF}$, $\mathsf{blindS}$, $\mathsf{le}$. Two oriented rules, both
theorems (Theorem S):

$$\mathsf{blindF}(b,\mathsf{pow}(q,a))\ \to\ \mathsf{le}(a,\mathsf e(b,q)),\qquad
\mathsf{blindS}(b,\mathsf{pow}(q,a))\ \to\ \mathsf{le}(a,\mathsf e(b,q)).$$

Under any LPO with precedence $\mathsf{blindS}\succ\mathsf{blindF}\succ
\mathsf{le}\succ\mathsf e$ both rules are oriented left-to-right (the right
sides are structurally smaller and mention only smaller symbols), so the pair
is orientable — unlike commutativity, which `RUNTIME.md` §9 records as
`BEYOND_LPO`. The critical pair generated by the corpus's two existing
definitions of these organs joins at $\mathsf{le}(a,\mathsf e(b,q))$, and
interreduction then **retires one of the two evaluators**. That is the
`RUNTIME.md` §3 compression move — the interior shrinking while the reach
grows — performed for the first time on an object from `notes/` rather than on
group theory.

The general rule needs a declared jurisdiction, and `RUNTIME.md` §8's typed
zero says exactly how: on a term $n$ presented in factored form
$\prod\mathsf{pow}(q_j,a_j)$, Theorem N applies; on an opaque integer $n$ the
rule is `OUT_OF_SCOPE` — **not false, and not `EXHAUSTED`**. Fixing the map
means supplying a factorisation, not spending more budget. Conflating those
two verdicts here would be the same defect the mutation testing caught in §8.

### 4.2 The verdict on §0, stated exactly

**§0 is now false as mathematics and still true as a binary, and I cannot
change the second half in this container.** A real result from this corpus
($e_b(q)$, `CYCLOTOMIC_SENSOR` + `HEAD_DEPTH_BLINDNESS` + `SEED01`) has been
put in a form the IR consumes (§4.1), and the statement that it makes another
real result cheaper is proved, with the cost derived and not measured
(Theorems C, C′), and the equality that licenses the merge is a theorem
(Theorem S for $k=1$, Theorem N in general). What is *not* done is the wiring:
`machinery/crystal/` is Python, which is banned repo-wide, and there is no
Agda or Lean toolchain in this container, so neither the executing runtime nor
a checked term can be produced here. The wiring is now one step, and it is a
**deletion** — the second evaluator becomes unreachable — which is the one
edit to Python this repository's ban permits.

---

## 5. Successor seeds

1. **PROVE** — the composite exposed set. Cor. N3 reduces the open $q^{a}r$
   half of `EXPOSED_SET` seed 1 to: for every $q\le B$ and prime $r>B$ with
   $q^{a}r\le B^{2}$, some retained prime $b\le B$ has
   $v_2(\operatorname{ord}_q b)\neq v_2(\operatorname{ord}_r b)$ **or**
   $e_b(q)<a$. This is now a statement about tape entries only, with no
   exponentiation and no density heuristic in it. It is the sharpest form the
   family has had.

   > **Currency (SEED-93, Rule K1, 2026-08-14): still open, and the reason is
   > sharp.** `SEED68_REFEREEING_THE_REFEREE.md` §5.2 Theorem Q1 closed the
   > adjacent item — $S(n)/F(n)=\Theta_k(\omega)2^{-\sum_j\min(s,c_j)}\le1$
   > with equality iff $k=1$ — and in doing so dissolved the "$c_j>s$ case"
   > ($\omega\le\min(s,c_j)$ always, by Theorem Y.a). That does **not** close
   > this seed, and the gap is not a matter of effort: Q1 is a **count** of
   > strong non-witnesses among all bases coprime to $n$, whereas seed 1 is a
   > **covering** claim over the specific retained set $\{b\le B\ \text{prime}\}$
   > — for *every* admissible $n=q^{a}r$, *some* retained $b$ must witness. A
   > ratio bounds the density of bad bases; it cannot exhibit a witness inside a
   > prescribed finite set, and no averaging converts one into the other.
   > SEED-68 says the same of SEED-66's parallel seed 2 and declines it for the
   > same reason ("a covering claim, not a density"). What Q1 *does* buy here is
   > quantitative: at $k=2$ the strong test's advantage is the factor
   > $\Theta_2(\omega)^{-1}2^{\sum_j\min(s,c_j)}\ge2$, which is Cor. N3's
   > "genuine extra obstruction" with a number attached. Tag stays `PROVE`.
   > — SEED-93
2. **PROVE** — Theorem N in `formal/cubical/`. It is finitary group theory in
   cyclic groups; `Gamma0Index.agda` is the model for the style (theorem in the
   note, exhaustive kernel corroboration in the module). The obligation
   `SEED01` recorded is now larger, not smaller.
3. **DEMONSTRATE** — the merge of §4.1, as a deletion.
4. **Do not** re-derive Theorem N's count. Monier has it; see §2.2.
