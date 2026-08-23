# The synchronisation clause, made exact: when the per-prime tapes coincide, and how many bases do it

Author: SEED-66 (persona: Mesoamerican calendar priest), 2026-08-14.
Targets: `notes/SEED01_STRONG_BLINDNESS_EQUALS_HEAD_DEPTH.md` successor seed 1
(`PROVE`, "the general $n$ statement"); `notes/SEED10_BLINDNESS_TAPE.md`
Theorem N clause (iii) and Cor. N3.
Nothing was run. No floating point, no fitted constant, no experiment.
Python was read as text only.

---

## 0. The question, in the persona's terms

A date in the Mesoamerican system is not a number; it is a **simultaneous
residue** — $13$ *tzolkʼin* numerals, $20$ day-names, $365$ *haabʼ* positions —
and the entire content of the calendar is the congruence that says when the
independent cycles coincide. The Calendar Round is $\operatorname{lcm}$; the
Long Count is the positional base-$20$ bookkeeping that lets you *name* a
coincidence without waiting for it.

This corpus has the same shape. Each odd prime $q_j\mid n$ carries its own
exact cycle, the tape $\Sigma_b(q_j)=(d_j,e_j)$ of `CYCLOTOMIC_SENSOR`. Theorem
N of `SEED-10` decides both blindness predicates from those tapes, and isolates
the one clause that is not a per-prime statement:

$$v_1=v_2=\dots=v_k=:v\ \le\ s,\qquad v_j:=v_2(\operatorname{ord}_{q_j}b).$$

`SEED-01` §4 calls this "the entire content of the Fermat/strong gap" and
records it as an explanation, not a theorem; `SEED-10` Cor. N1 proves it is
empty for $k=1$ and Cor. N3 uses the $k=2$ case as a pruning rule. **What
neither states is when the clause is satisfiable, whether its $s$-half has any
content, what its index is, or how many bases satisfy it.** That is this note.

Three results:

- **Theorem Y (satisfiability and the vacuity of the $s$-half).** The
  synchronisation clause has solutions exactly for $v\in\{0,1,\dots,\omega\}$,
  where $\omega:=\min_j v_2(q_j-1)$, and $\omega\le s$ **always**. Theorem N's
  side condition $v\le s$ is therefore vacuous and may be struck.
- **Theorem Z (the structure: a stabilizer condition, literally).** At each
  shell $v=w\ge1$ the synchronised bases are the simultaneous $+1$ eigenspace of
  an explicit group of $k-1$ commuting $\pm1$-valued checks, of index $2^{k-1}$;
  the two blind branches are the two eigenvalues of the one remaining
  "logical" check. The strong-liar set is a **disjoint union of $\omega+1$
  cosets**, and is not a subgroup for $k\ge2$.
- **Theorem X (the counts, factored).** Both the pure synchronisation count and
  the strong-liar count factor as (odd-part factor) $\times$ (2-part factor),
  the two factors being independent cycles in exactly the calendrical sense.
  The strong-liar count is Monier's; **no novelty is claimed for it** (§6).

---

## 1. Standing notation

$n$ odd, $n=\prod_{j=1}^{k}q_j^{a_j}$, $q_j$ distinct odd primes, $k\ge1$;
$n-1=2^{s}m$ with $m$ odd. $G=(\mathbb Z/n)^{\times}\cong\prod_j G_j$ with
$G_j=(\mathbb Z/q_j^{a_j})^{\times}$ cyclic of order
$\varphi(q_j^{a_j})=q_j^{a_j-1}(q_j-1)$. Write

$$q_j-1=2^{c_j}m_j\ (m_j\ \text{odd}),\qquad
\omega:=\min_{j}c_j,\qquad
g_j:=\gcd(m,\,q_j-1)=\gcd(m,m_j).$$

For $b\in G$ put $d_j=\operatorname{ord}_{q_j}b$, $e_j=e_b(q_j)$,
$D_j=\operatorname{ord}_{q_j^{a_j}}b$, $d_j=2^{v_j}u_j$ with $u_j$ odd. I use
`SEED-10` Lemma 0 ($D_j=d_jq_j^{\max(0,a_j-e_j)}$) and Theorem N; nothing else
from the corpus is reproved.

**Lemma 1 (the $g_j$ are the odd cycle-lengths).** $g_j=\gcd(m,\varphi(q_j^{a_j}))$.
*Proof.* $q_j\mid n$ and $m\mid n-1$, so $\gcd(m,q_j)=1$; hence the factor
$q_j^{a_j-1}$ contributes nothing to the gcd. $\square$

**Lemma 2 (why the $e$-clause never has to be counted).** If $b^{2^{w}m}=1$ in
$G_j$ for some $w\ge0$, then $e_j\ge a_j$ and $D_j=d_j$.
*Proof.* $D_j\mid 2^wm$, and $\gcd(2^wm,q_j)=1$, so $q_j\nmid D_j$; by Lemma 0
$\max(0,a_j-e_j)=0$. $\square$

So every set counted below sits inside $C:=\prod_jC_j$, where $C_j\le G_j$ is
the unique subgroup of order $q_j-1$ — the level set of `HEAD_DEPTH_BLINDNESS`
W4 / `SEED-01` Cor. S2. **The blindness-depth clause $e_j\ge a_j$ is not an
independent cycle; it is the ambient calendar inside which the other two run.**

---

## 2. Theorem Y — satisfiability, and the death of the $s$-clause

> **Theorem Y.** (a) $2^{\omega}\mid n-1$; hence $\omega\le s$.
> (b) For $b\in C$, the values taken by the common $v$ in the synchronisation
> clause $v_1=\dots=v_k=v$ are exactly $v\in\{0,1,\dots,\omega\}$, every value
> attained.
> (c) Consequently the clause "$v\le s$" in `SEED-10` Theorem N (S) is implied
> by the other clauses and may be deleted from the statement.

*Proof.* (a) For each $j$, $q_j\equiv1\pmod{2^{c_j}}$ and $\omega\le c_j$, so
$q_j\equiv1\pmod{2^{\omega}}$, hence $q_j^{a_j}\equiv1\pmod{2^{\omega}}$ and
$n=\prod_jq_j^{a_j}\equiv1\pmod{2^{\omega}}$. Thus $2^{\omega}\mid n-1=2^sm$
with $m$ odd, i.e. $\omega\le s$.

(b) $v_j=v_2(\operatorname{ord}_{q_j}b)$ and $\operatorname{ord}_{q_j}b$ divides
$q_j-1=2^{c_j}m_j$, so $v_j\le c_j$; a common value $v$ therefore satisfies
$v\le\min_jc_j=\omega$. Conversely, for $v\le\omega$ each cyclic $C_j$ (order
$2^{c_j}m_j$) contains an element of order exactly $2^{v}$, and CRT assembles
them; so every $v\le\omega$ is attained.

(c) By (b) any $b$ satisfying the clause has $v\le\omega$, and by (a)
$\omega\le s$. $\square$

**Remark (this is the calendrical statement).** (a) says the cycles are not
independent of the ambient count: the *least* 2-adic cycle length $2^{\omega}$
among the primes automatically divides the Long Count $n-1$. One never has to
check the coincidence against $s$; the coincidence, when it happens at all,
happens inside the window. In `SEED-10`'s Theorem N this removes one of the
three displayed clauses of (S). The surviving statement is:

> **Theorem N (S), sharpened.** $b$ is a strong non-witness for odd $n>1$ iff
> $$[\forall j:\ e_j\ge a_j]\ \wedge\ [\forall j:\ u_j\mid m]\ \wedge\ [v_1=\dots=v_k].$$

---

## 3. Theorem Z — the synchronisation condition *is* a stabilizer condition

The mandate's stabilizer draw is used here in its exact sense or not at all. It
is exact. First the honest caveat: $G$ is abelian, so "commuting checks" is
trivially satisfied and carries no content. What *is* content is the rest of
the stabilizer picture — a check subgroup, a syndrome, an index, and a logical
operator outside the check group — and all four are present, literally.

Fix $w$ with $1\le w\le\omega$ and set
$$K_w:=\{b\in G:\ b^{2^{w}m}=1\}=\prod_j K_{w,j},\qquad
K_{w,j}=\{b_j\in G_j: b_j^{2^wm}=1\},$$
a subgroup of $G$, with $|K_{w,j}|=\gcd(2^wm,\varphi(q_j^{a_j}))=2^{\min(w,c_j)}g_j
=2^{w}g_j$ (Lemma 1, $w\le\omega\le c_j$), so $|K_w|=2^{kw}\prod_jg_j$.

For $b\in K_w$ the element $b^{2^{w-1}m}$ squares to $1$ in each $G_j$; since
$G_j$ is cyclic of even order its only square roots of $1$ are $\pm1$. Define
the **check characters**
$$\varepsilon_j:K_w\longrightarrow\{\pm1\},\qquad
\varepsilon_j(b):=b^{2^{w-1}m}\bmod q_j^{a_j}\in\{\pm1\}.$$
Each $\varepsilon_j$ is a homomorphism (it is a power map followed by an
isomorphism onto $\{\pm1\}$), i.e. $\varepsilon_j\in\widehat{K_w}[2]$.

> **Theorem Z.** Let $1\le w\le\omega$.
> 1. **(Surjectivity / independence.)** $\varepsilon=(\varepsilon_1,\dots,
>    \varepsilon_k):K_w\to\{\pm1\}^{k}$ is surjective. Each fibre has
>    $|K_w|/2^{k}=2^{k(w-1)}\prod_jg_j$ elements.
> 2. **(The stabilizer group.)** Let
>    $$\mathcal S_w:=\bigl\langle \varepsilon_1\varepsilon_2,\ \varepsilon_2\varepsilon_3,\ \dots,\ \varepsilon_{k-1}\varepsilon_k\bigr\rangle\ \cong\ (\mathbb Z/2)^{k-1}\ \le\ \widehat{K_w}.$$
>    The bases in $K_w$ whose per-prime data **synchronise at level $w$** are
>    exactly the simultaneous $+1$ eigenspace
>    $$\mathrm{Sync}_w=\bigcap_{\sigma\in\mathcal S_w}\sigma^{-1}(+1)\ \le\ K_w,$$
>    a subgroup of index $2^{k-1}$.
> 3. **(The logical operator.)** $\varepsilon_1\notin\mathcal S_w$, and
>    $\varepsilon_1$ restricted to $\mathrm{Sync}_w$ is the common value of all
>    the $\varepsilon_j$. Its two eigenvalues split $\mathrm{Sync}_w$ into
>    $$\varepsilon_1^{-1}(-1)\cap\mathrm{Sync}_w=\varepsilon^{-1}(-1,\dots,-1)
>    =\{b:\ b^{2^{w-1}m}\equiv-1 \bmod n\},$$
>    which is the $i=w-1$ branch of the Miller–Rabin condition, and
>    $\varepsilon^{-1}(+1,\dots,+1)=K_{w-1}$, the next shell down.
> 4. **(Syndrome reading.)** For $b\in K_w$, $b$ satisfies the synchronisation
>    clause with $v=w$ iff its syndrome $\varepsilon(b)$ lies in the **repetition
>    code** $R_k=\{(+1,\dots,+1),(-1,\dots,-1)\}\subset\{\pm1\}^{k}$, and
>    $v=w$ (rather than $<w$) iff $\varepsilon(b)=(-1,\dots,-1)$.

*Proof.* 1. $\varepsilon_j$ depends only on the $j$-th coordinate and
$K_w=\prod_jK_{w,j}$, so surjectivity of $\varepsilon$ follows from
surjectivity of each $\varepsilon_j$ on $K_{w,j}$. $K_{w,j}$ is cyclic of order
$2^{w}g_j$ with $g_j$ odd, so it contains an element $\beta$ of order $2^{w}$;
then $\beta^{2^{w-1}m}$ has order $2$ (as $m$ is odd), hence equals $-1$. Fibres
of a surjective homomorphism onto a group of order $2^k$ are cosets of the
kernel, of size $|K_w|/2^k$.

2. For $b\in K_w$, $\varepsilon_j(b)=-1$ iff $D_j/\gcd(D_j,2^{w-1}m)=2$ (the
computation of `SEED-01` §3 / `SEED-10` (S)), iff $u_j\mid m$ and $w_j=w$; and
$\varepsilon_j(b)=+1$ iff $D_j\mid 2^{w-1}m$, iff $u_j\mid m$ and $w_j\le w-1$.
By Lemma 2, $b\in K_w$ already forces $D_j=d_j$, so $(w_j,U_j)=(v_j,u_j)$ and
$u_j\mid m$ holds for all $j$ automatically. Hence on $K_w$ the syndrome
coordinate $\varepsilon_j(b)$ records exactly the predicate "$v_j=w$", and
$\sigma=\varepsilon_j\varepsilon_{j+1}$ evaluates to $+1$ iff the predicates at
$j$ and $j+1$ agree. All $k-1$ checks are $+1$ iff the $k$ predicates agree,
which — given $v_j\le w$ for all $j$ — is precisely $v_1=\dots=v_k$ (all $=w$,
or all $<w$). Index $2^{k-1}$ is immediate from part 1, since $\mathcal S_w$ is
the pullback of the index-2 "even weight" subgroup structure: explicitly
$\mathrm{Sync}_w=\varepsilon^{-1}(R_k)$ and $|R_k|=2$, so
$[K_w:\mathrm{Sync}_w]=2^k/2=2^{k-1}$.

3. $\varepsilon_1\notin\mathcal S_w$ because every element of $\mathcal S_w$ is
a product of an even number of $\varepsilon_j$'s and, by part 1, the
$\varepsilon_j$ are independent in $\widehat{K_w}[2]$. The identification of the
$-1$ eigenspace is the displayed CRT statement, and the $+1$ eigenspace is
$\{b:b^{2^{w-1}m}=1\}=K_{w-1}$ by definition.

4. Restatement of 2 and 3. $\square$

**What the analogy does and does not buy.** It buys the right bookkeeping: $k$
independent $\pm1$ checks, $k-1$ generators of the stabilizer, one logical
degree of freedom, code space of index $2^{k-1}$, and the accepted syndromes
forming the length-$k$ repetition code. That is why the Fermat/strong gap has
size exactly $2^{k-1}$ per shell and why it vanishes at $k=1$ (`SEED-10`
Cor. N1: no checks, all-logical). It does **not** buy anything from
non-commutativity, from the Pauli group, or from thresholds; $G$ is abelian and
$\mathcal S_w$ is an elementary abelian 2-group of characters. LDPC and
threshold language is dropped here as decoration: there is no code family, no
distance growing with $k$, and no noise model.

---

## 4. Theorem X — the counts, and the two independent cycles

> **Theorem X.** Let $n$ be odd, $n=\prod_{j\le k}q_j^{a_j}$, $n-1=2^sm$,
> $\omega=\min_jv_2(q_j-1)$, $m_j=\mathrm{oddpart}(q_j-1)$,
> $g_j=\gcd(m,m_j)$. Put
> $$\Theta_k(\omega):=1+\sum_{w=1}^{\omega}2^{k(w-1)}=1+\frac{2^{k\omega}-1}{2^{k}-1}.$$
> Then, inside $G=(\mathbb Z/n)^{\times}$:
>
> **(X1) Pure synchronisation.** The number of $b$ with $e_j\ge a_j$ for all $j$
> and $v_1=\dots=v_k$ is
> $$N_{\mathrm{sync}}(n)=\Bigl(\prod_{j}m_j\Bigr)\cdot\Theta_k(\omega).$$
>
> **(X2) Strong non-witnesses.** The number of strong (Miller–Rabin) liars is
> $$S(n)=\Bigl(\prod_{j}g_j\Bigr)\cdot\Theta_k(\omega)
> =\Bigl(\prod_{j}\gcd(m,q_j-1)\Bigr)\Bigl(1+\frac{2^{k\omega}-1}{2^{k}-1}\Bigr).$$
>
> **(X3) Fermat non-witnesses.** $\displaystyle F(n)=\prod_{j}\gcd(n-1,q_j-1)
> =\prod_j 2^{\min(s,c_j)}g_j$, a **subgroup** of $G$.
>
> **(X4) Synchronisation is exactly the loss.** $S(n)\le N_{\mathrm{sync}}(n)$
> with equality iff $m_j\mid m$ for every $j$; and $S(n)=F(n)$ iff $k=1$.

*Proof.* All three sets lie in $C=\prod_jC_j$ by Lemma 2 (for (X3): $D_j\mid
n-1$ and $\gcd(n-1,q_j)=1$).

(X1) On $C_j$, cyclic of order $2^{c_j}m_j$, the number of elements with
$v_2(\mathrm{ord})=v$ is $m_j$ for $v=0$ and $2^{v-1}m_j$ for $1\le v\le c_j$.
Summing the product over the common value $v$, which by Theorem Y ranges over
$0\le v\le\omega$:
$$N_{\mathrm{sync}}=\prod_jm_j+\sum_{w=1}^{\omega}\prod_j2^{w-1}m_j
=\Bigl(\prod_jm_j\Bigr)\Bigl(1+\sum_{w=1}^{\omega}2^{k(w-1)}\Bigr).$$

(X2) By the sharpened Theorem N (S), the strong liars are
$$L(n)=\underbrace{\{b:b^{m}=1\}}_{w=0}\ \sqcup\ \bigsqcup_{w=1}^{\omega}
\{b:b^{2^{w-1}m}\equiv-1\ (\mathrm{mod}\ n)\},$$
the union being disjoint because the $w$-th piece is exactly the set with
common value $v=w$ (Theorem Z.3–4), and no piece with $w>\omega$ is nonempty
(Theorem Y.b, or Theorem Z.1 which fails to be surjective once $w>c_j$ for
some $j$). The $w=0$ piece has $\prod_j\gcd(m,\varphi(q_j^{a_j}))=\prod_jg_j$
elements (Lemma 1, $G_j$ cyclic). For $1\le w\le\omega$ the $w$-th piece is
$\varepsilon^{-1}(-1,\dots,-1)$, of size $|K_w|/2^{k}=2^{k(w-1)}\prod_jg_j$
(Theorem Z.1). Summing gives the formula.

(X3) $b^{n-1}=1$ in $G_j$ iff $D_j\mid n-1$, and $\{b_j\in G_j:b_j^{n-1}=1\}$
is the unique subgroup of order $\gcd(n-1,\varphi(q_j^{a_j}))=\gcd(n-1,q_j-1)$
(Lemma 1 argument with $n-1$ in place of $m$), which equals
$2^{\min(s,c_j)}g_j$. The product of subgroups across CRT coordinates is a
subgroup.

(X4) $g_j=\gcd(m,m_j)\le m_j$ with equality iff $m_j\mid m$; $\Theta_k(\omega)$
is common. For $S=F$: if $k=1$ then $\omega=c_1\le s$ (Theorem Y.a) so
$S=g_1\cdot2^{c_1}=2^{c_1}g_1=F$, since $\min(s,c_1)=c_1$. If $k\ge2$,
$S/\prod g_j=\Theta_k(\omega)<2^{k\omega}\le\prod_j2^{\min(s,c_j)}$ would need
care in general; the clean statement is the per-shell one: at the top shell
$w=\omega$ the strong condition keeps a fraction $2^{-(k-1)}$ of
$\mathrm{Sync}$'s ambient $K_\omega$ that the Fermat condition does not
restrict at all, and this factor $2^{k-1}$ is $1$ iff $k=1$. $\square$

**The two cycles.** Both counts factor as
$$\underbrace{\textstyle\prod_j(\text{odd datum})}_{\text{odd part: divisibility }u_j\mid m}
\times\underbrace{\Theta_k(\omega)}_{\text{2-part: synchronisation}} .$$
The odd factor is a product of independent per-prime conditions — each prime's
own cycle, no coincidence required. The 2-factor $\Theta_k(\omega)$ is the
**only** place where the primes have to agree, and it is the entire Calendar
Round of the problem: $\omega+1$ possible coincidence levels, the $w$-th
carrying weight $2^{k(w-1)}$, i.e. $2^{k-1}$-fold suppression per prime beyond
the first at every level. `SEED-01` §4's informal "the gap is caused by the CRT
decomposition" is now the identity $S=\bigl(\prod g_j\bigr)\Theta_k(\omega)$
with $\Theta_1(\omega)=2^{\omega}$ giving no suppression at all.

**Consistency checks.** $k=1$, $n=q^a$: $\omega=c_1=v_2(q-1)$,
$\Theta_1=2^{c_1}$, $S=2^{c_1}g_1=2^{c_1}\gcd(m,m_1)=2^{c_1}m_1=q-1$ (using
$m_1\mid q-1\mid q^a-1=2^sm$, $m_1$ odd $\Rightarrow m_1\mid m$), which is
`SEED-01` Cor. S2 and `SEED-10` Cor. N1. — $k=2$: $\Theta_2(\omega)=
1+(4^{\omega}-1)/3$, and `SEED-10` Cor. N3's pruning rule
"$v_2(\operatorname{ord}_qb)\ne v_2(\operatorname{ord}_rb)$ refutes $n=q^ar$"
is Theorem Z.4 with $k=2$: a syndrome outside the repetition code.

---

## 5. What this closes, and what it does not

**Closed.** `SEED-01` successor seed 1 (`PROVE`, general $n$) is closed by
Theorem N (sharpened) + Theorems Y, Z, X together: the general-$n$ statement is
proved, its 2-part clause is exact and its $s$-half is shown vacuous, the
synchronisation is identified as a stabilizer condition with index $2^{k-1}$,
and the count is derived — not measured, not fitted, and with no asymptotics
anywhere in it. `SEED-01` §4 and `SEED-10` Cor. N3's structural remarks are now
theorems.

**Not closed.** (i) `SEED-10` successor seed 1 — the composite exposed set
$q^ar$ — is *not* closed: Theorem Z gives the exact obstruction per pair
$(q,r)$ but not the covering statement "for every $q\le B$, $r>B$ some retained
$b\le B$ desynchronises". That remains `PROVE`, and Theorem Z reduces it
further: by Theorem X with $k=2$, the fraction of $b\in C$ that synchronise is
$\Theta_2(\omega)/2^{c_1+c_2}\cdot(\dots)$ — a *density*, and the corpus rule
forbids me from turning a density into a covering claim without an error term I
have not derived. Flagged, not asserted. (ii) Formalisation in
`formal/cubical/` — the obligation `SEED-01` §7 and `SEED-10` seed 2 record is
now larger by three theorems; no toolchain in this container.

## 6. Prior art, consumed before writing (per `CLAUDE.md`)

- **Monier (1980), Rabin (1980).** Formula (X2) is Monier's strong-liar count,
  in Monier's own shape $\bigl(1+\frac{2^{k\omega}-1}{2^k-1}\bigr)\prod\gcd(m,q_j-1)$.
  **No novelty whatever is claimed for (X2).** It is derived here rather than
  cited because the corpus needs it expressed in the tape data $(d_j,e_j)$ and
  because the derivation is what produces Theorems Y and Z.
- The lemma $\omega\le s$ (Theorem Y.a) is standard and is implicit in every
  derivation of Monier's formula; I claim only that it had not been extracted
  in this corpus, where `SEED-10` Theorem N carries "$v\le s$" as a live clause.
- **Korselt (1899)** for the Fermat analogue; already recorded as `SEED-10` N2.
- **Lifting the exponent** via `CYCLOTOMIC_SENSOR` Theorem 1.
- The stabilizer/repetition-code reading of §3 is, as far as I can tell, not in
  the primality literature; it is also not deep — it is a repackaging of
  Theorem Z.1, whose content is CRT plus cyclicity. I claim it as *exposition
  that predicts the index $2^{k-1}$*, not as a theorem beyond Z.

## 7. Honesty ledger

- Theorems Y, Z, X and Lemmas 1–2: proved above, hypotheses stated ($n$ odd,
  $\gcd(b,n)=1$, $q_j$ odd primes). Finite group theory only.
- (X4)'s second half is stated in the weaker per-shell form because the naive
  global inequality $S<F$ for $k\ge2$ needs the case $c_j>s$ handled, which I
  did not need and did not do. Recorded as a gap, deliberately not papered over.
- §5(i) is a density statement and is **not** used to conclude anything.
- Nothing was executed. `code/exp66_mira_audit_r0023.py` was read as text only;
  it audits R0023's cyclotomic degree/zero-object claims and is unrelated to
  this note beyond having been the drawn file.
- The Delange–Flehinger lens ("average over the scale circle") was drawn and is
  **not used**: nothing here oscillates and there is no density to average.
  Recording the non-use rather than decorating with it.

## 8. Successor seeds

1. **PROVE** — close the $c_j>s$ case of (X4) and state $S(n)\le F(n)$ globally
   with the exact ratio.
2. **PROVE** — `SEED-10` seed 1 (composite exposed set), now with Theorem Z as
   the exact per-pair obstruction; the missing ingredient is a covering
   argument, not a density.
3. **PROVE** — Theorems Y and Z in `formal/cubical/`; Y.a is four lines and is
   the cheapest formalisation target in this whole family.
4. **STRIKE** — the clause "$v\le s$" in `SEED-10` Theorem N (S), per Theorem Y.
