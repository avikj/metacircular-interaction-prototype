# The digit crystal: word reversal vs. digit complement in the positional affine action

**Task:** execute `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §8 (duality crystals) as exact
mathematics on the crystal that note names as native — *word-reversal /
opposite-endomorphism in positional digit actions* — and cross it with §4
(reachable chart vs. ambient completion).
**Code:** `code/exp62_digit_crystal.py` → `figures/exp62_crystal_fixed_and_defect.png`,
`figures/exp62_no_continuous_extension.png`. Every number quoted below is printed by
that script (exact Python integers + `sympy.combinatorics` for one group order;
floats appear only inside the figures).

**Status: PENDING HOSTILE AUDIT.**

This note is a **new direction**. It makes no claim about, and takes no input from,
the prime-pair field / RH program. Nothing here edits or supersedes an existing note.
Attribution is stated per statement in §7; much of the finite-word combinatorics is
**classical**, and is labelled as such.

The three seeds cited in `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §12 (Cubical finite-set
loop groups, the faithful affine digit-word action, finite predictive stabilization)
are treated **as seeds only**: seed 2 supplies the object studied here (the affine
digit action) and nothing in this note claims or replays its Lean proof. Lemma 0.1
below is proved here from scratch, independently.

**Results, in one place.**

1. $D=$ reversal is the unique anti-automorphism of the free digit monoid fixing the
 generators; $E=$ digit complement is the unique nontrivial automorphism induced by
 conjugation in $\operatorname{Aff}(\mathbb Q)$, realized by $\sigma(x)=-1-x$. Both are
 involutions (Props. 1.1, 1.2, 1.3). The crystal is forced, not chosen.
2. $DE=ED$. **The commutator is trivial at every level.** $\langle D,E\rangle$ is
 Klein four on $W_n$ for $n\ge2$, $\mathbb Z/2$ at $n=1$, trivial at $n=0$, and Klein
 four inside $\operatorname{Aut}^{\pm}(M_b)\cong S_b\times\mathbb Z/2$ (Thm 3.1). The
 anticipated dihedral/semidirect structure is **refuted**: anti-automorphy is a
 grading, and $\rho$ is central.
3. The dihedral structure is real but lives elsewhere: $ETE^{-1}=T^{-1}$, and the
 normalizer of $\langle T\rangle$ in $\operatorname{Homeo}(\mathbb Z_b)$ is exactly
 $\mathbb Z_b\rtimes\mathbb Z/2$, with $\langle T,E\rangle\cong D_\infty$ (Thm 3.2).
 $D$ cannot join it.
4. Fixed points: $b^{\lceil n/2\rceil}$ palindromes; $b^{\lfloor n/2\rfloor}$
 antipalindromes (zero when $n$ is odd and $b$ even); $\operatorname{Fix}E$ is a single
 constant word for odd $b$ and empty for even $b$ (Thm 3.4) — verified by brute force
 against the closed forms at all 32 exhaustively enumerable $(b,n)$.
5. **Completion verdict.** $E$ completes; $D$ does not, and the failure is exact:
 $\pi_nR_{n+1}=R_n\varsigma_n\ne R_n\pi_n$, with agreement locus precisely the $b$
 constant strings, defect fraction exactly $1-b^{-n}$ (Thm 4.2). $R^{\min}$ is nowhere
 continuous (Thm 4.3). And the sharp form: reversal *does* have a limit — it is the
 **identity** in canonical digit charts (Thm 4.4). So the Klein-four crystal of the
 chart has image $\mathbb Z/2$ on the completion with kernel $\langle D\rangle$
 (Cor. 4.5). **The residual is the endian class.**

---

## 0. Objects and conventions

Fix a base $b\ge 2$. The digit alphabet is $A=A_b=\{0,1,\dots,b-1\}$; $A^{*}$ is the
free monoid on $A$; $W_n=A^{n}$ is the set of words of length $n$ (leading zeros
allowed and *significant* — see Remark 0.2).

**Endianness is fixed once.** A word $w=(c_0,c_1,\dots,c_{n-1})\in W_n$ is read
**little-endian**:
$$L_n(w)\;=\;\sum_{i=0}^{n-1}c_i\,b^{\,i},\qquad L_n:W_n\ \xrightarrow{\ \sim\ }\ \{0,1,\dots,b^{n}-1\}=\mathbb Z/b^{n}.$$
So $c_0$ is the least significant digit and concatenation $uv$ appends *higher-order*
digits on the right.

$\operatorname{Aff}=\operatorname{Aff}(\mathbb Z)$ denotes the monoid of maps
$x\mapsto ax+c$ with $a\in\mathbb Z_{\neq0},c\in\mathbb Z$, written $[a,c]$, with
$$[a_1,c_1]\circ[a_2,c_2]=[a_1a_2,\;a_1c_2+c_1].$$
The **digit generators** are $\gamma_d=[b,d]:x\mapsto bx+d$, $d\in A$, and
$$\Phi:A^{*}\longrightarrow\operatorname{Aff},\qquad
\Phi(c_0c_1\cdots c_{n-1})=\gamma_{c_0}\circ\gamma_{c_1}\circ\cdots\circ\gamma_{c_{n-1}} .$$

**Lemma 0.1 (the affine chart).** $\Phi(w)=[\,b^{n},\,L_n(w)\,]$ for $w\in W_n$;
$\Phi$ is an **injective monoid homomorphism** onto
$$M_b:=\{[b^{n},v]\;:\;n\ge0,\ 0\le v<b^{n}\}\subset\operatorname{Aff},$$
and $M_b$ is **free** on $\{\gamma_0,\dots,\gamma_{b-1}\}$. Moreover $\Phi(w)(0)=L_n(w)$
(the orbit of $0$ is positional evaluation).

*Proof.* Induction on $n$: $\Phi(c_0w')=[b,c_0]\circ[b^{n-1},L_{n-1}(w')]
=[b^{n},\,bL_{n-1}(w')+c_0]=[b^n,L_n(c_0w')]$. Homomorphism: for $u\in W_m,v\in W_k$,
$\Phi(u)\circ\Phi(v)=[b^{m},L(u)]\circ[b^{k},L(v)]=[b^{m+k},\,b^{m}L(v)+L(u)]
=[b^{m+k},L(uv)]=\Phi(uv)$. *Unit* (the clause a monoid map needs separately, and
which the operation law above does not give): $\Phi(\varepsilon)$ is the empty
composite $[1,0]=\mathrm{id}_{\operatorname{Aff}}$, which is also the $n=0$ case
of the displayed formula ($b^0=1$, $L_0(\varepsilon)=0$), and $[1,0]\in M_b$, so
$M_b$ is a submonoid rather than merely a subsemigroup. [Clause supplied in
place by seed132, 2026-08-14; the claim was true and only the argument was
short.] Injectivity: $b\ge2$, so $[b^{n},v]$ determines $n$, and
$0\le v<b^{n}$ determines $w=L_n^{-1}(v)$. Freeness is injectivity plus surjectivity
onto $M_b$. Finally $\Phi(w)(0)=L_n(w)$. $\square$

**Remark 0.2 (leading zeros are visible; this is the point).** $L$ forgets leading
zeros ($L_n(w)=L_{n+1}(w0)$) but $\Phi$ does not: $\Phi(w0)=[b^{n+1},L(w)]\ne
[b^{n},L(w)]=\Phi(w)$. The *action* remembers the word; only the *orbit of $0$*
collapses to the numeral. Everything below is stated on the action, i.e. on $W_n$ or
$M_b$, and only then pushed to values.

**Completion.** $\mathbb Z_b:=\varprojlim_n(\mathbb Z/b^{n},\pi_n)$ with
$\pi_n:\mathbb Z/b^{n+1}\to\mathbb Z/b^{n}$ reduction mod $b^{n}$; $|x|_b=b^{-v_b(x)}$
where $v_b(x)$ is the number of trailing zero digits ($|0|_b=0$). This is an
ultrametric inducing the profinite topology; for composite $b$, $\mathbb Z_b\cong
\prod_{p\mid b}\mathbb Z_p$ and $|\cdot|_b$ is not multiplicative — nothing below uses
multiplicativity. The **odometer** is $T:\mathbb Z_b\to\mathbb Z_b$, $T(x)=x+1$, with
finite chart $T_n(v)=v+1$ on $\mathbb Z/b^{n}$.

---

## 1. §8 step 1 — the two dualities, their exact domains, and why they are canonical

### 1.1 $D$ = word reversal

$$\rho_n:W_n\to W_n,\qquad \rho(c_0,\dots,c_{n-1})=(c_{n-1},\dots,c_0),$$
extended to $A^{*}$. On values, $R_n:=L_n\rho_nL_n^{-1}$ is a bijection of
$\mathbb Z/b^{n}$; explicitly $R_n\big(\sum_i c_ib^{i}\big)=\sum_i c_ib^{\,n-1-i}$.

**Exact domain: $A^{*}$ (equivalently $M_b$, equivalently each $W_n$ / each
$\mathbb Z/b^{n}$ separately). NOT $\mathbb Z_b$, and not the odometer.** Settling this
is §4; it is the mathematical content of the lane, not a technicality.

- $\rho^2=\operatorname{id}$: immediate, $(\rho\rho w)_i=(\rho w)_{n-1-i}=w_i$.
  **Involutive.**
- $\rho(uv)=\rho(v)\rho(u)$: $\rho$ is an **anti-automorphism** of $A^{*}$, fixing
  every letter. Through $\Phi$ it is the canonical isomorphism $M_b\cong M_b^{\mathrm{op}}$:
  reading an affine digit word in the opposite composition order.

**Proposition 1.1 (uniqueness of $D$; the full ambient group).**
$\operatorname{Aut}(A^{*})\cong \operatorname{Sym}(A)=S_b$ (letterwise permutations),
and the group $\operatorname{Aut}^{\pm}(A^{*})$ of automorphisms *and*
anti-automorphisms is
$$\operatorname{Aut}^{\pm}(A^{*})\;\cong\;S_b\times\mathbb Z/2 ,$$
the second factor generated by $\rho$, which is central. In particular $\rho$ is the
**unique** anti-automorphism of $A^{*}$ fixing every letter.

*Proof.* Call $x\in A^{*}$ an *atom* if $x\ne1$ and $x$ is not a product of two
non-identity elements; the atoms are exactly the letters. Any (anti)automorphism $f$
permutes the atoms, hence restricts to some $\tau\in S_b$, and since $A$ generates,
$f$ is determined by $\tau$ together with whether it preserves or reverses products.
Both possibilities occur ($\tau_{*}$ and $\tau_{*}\rho$), and $\rho\tau_{*}=\tau_{*}\rho$
because $\rho$ permutes positions while $\tau_{*}$ acts letterwise. $\rho\notin S_b$
for $b\ge2$ (it fixes all letters but moves $01\in W_2$). Hence the group is
$S_b\times\langle\rho\rangle$. Via Lemma 0.1 the same holds for $M_b$. $\square$

### 1.2 $E$ = digit complement = opposite endomorphism, and its exact identification

$$\varepsilon:A\to A,\quad \varepsilon(d)=b-1-d;\qquad
\varepsilon_{*}(c_0,\dots,c_{n-1})=(\varepsilon c_0,\dots,\varepsilon c_{n-1}).$$
$\varepsilon^2=\operatorname{id}$, so $\varepsilon_{*}$ is an **involutive automorphism**
of $A^{*}$ (it is letterwise, hence preserves products). On values,
$$L_n(\varepsilon_{*}w)=\sum_i(b-1-c_i)b^{i}=b^{n}-1-L_n(w),\qquad\text{i.e. }
E_n(v)=b^{n}-1-v\ \ \text{on }\mathbb Z/b^{n},\ \ E_n(v)=-1-v .$$

**Proposition 1.2 (exact identification on $\mathbb Z_b$; the "bitwise NOT" check).**
In $\mathbb Z_b$ one has $-1=\sum_{i\ge0}(b-1)b^{i}$, and for $x=\sum_i c_ib^{i}$,
$$-1-x=\sum_{i\ge0}(b-1-c_i)\,b^{i}$$
*with no carries*, since $0\le b-1-c_i\le b-1$. Hence $x\mapsto -1-x$ **is** exactly
digitwise complement on $\mathbb Z_b$. It is an involution and an isometry
($|(-1-x)-(-1-y)|_b=|y-x|_b$), hence a homeomorphism. It is **not** a group
automorphism of $(\mathbb Z_b,+)$ (it is $-\operatorname{id}$ followed by a translation).

*Proof.* $(b-1)\sum_{i<n}b^{i}=b^{n}-1\equiv-1\bmod b^{n}$ for all $n$, so
$\sum_{i\ge0}(b-1)b^i=-1$ in the limit. The displayed identity is then
$-1-x=\sum(b-1)b^i-\sum c_ib^i=\sum(b-1-c_i)b^i$, and each coefficient already lies in
$A$, so this *is* the digit expansion. $\square$

**Proposition 1.3 (canonicity of $E$: it is the unique conjugation-induced digit
symmetry).** Let $\sigma:=[-1,-1]$, i.e. $\sigma(x)=-1-x$. Then $\sigma^{2}=
\operatorname{id}$ and
$$\boxed{\ \sigma\,\gamma_d\,\sigma^{-1}=\gamma_{\,b-1-d}\quad\text{for every }d\in A.\ }$$
Conversely, let $\alpha=[a,c]$ be an invertible element of $\operatorname{Aff}(\mathbb Q)$
such that $\alpha\gamma_d\alpha^{-1}\in\{\gamma_e:e\in A\}$ for all $d$, inducing
$\tau\in\operatorname{Sym}(A)$. Then $\tau=\operatorname{id}$ (forcing $\alpha=[1,0]$)
or $\tau=\varepsilon$ (forcing $\alpha=[-1,-1]=\sigma$).

*Proof.* $\alpha^{-1}=[a^{-1},-c/a]$ and
$\alpha\gamma_d\alpha^{-1}=[b,\;ad+c(1-b)]$, so $\tau(d)=ad+c(1-b)$. $\tau$ maps the
$b$-point arithmetic progression $A$ (gap $1$) bijectively onto itself and scales gaps
by $|a|$, so $|a|=1$ (using $b\ge2$). If $a=1$: $\tau(d)=d+c(1-b)$ is a bijection of
$A$ only for $c(1-b)=0$, i.e. $c=0$, $\tau=\operatorname{id}$. If $a=-1$:
$\tau(A)=\{c(1-b)-d:d\in A\}=A$ forces $c(1-b)=b-1$, i.e. $c=-1$, and then
$\tau(d)=b-1-d$. The boxed identity is the case $a=-1,c=-1$. $\square$

**Consequence (why this crystal and not another).** The pair $(D,E)$ is *forced*:
$D$ is the unique anti-automorphism of the digit monoid fixing the generators
(Prop. 1.1), and $E$ is the unique nontrivial automorphism induced by conjugation in
the ambient affine group (Prop. 1.3). $E$ is **outer for $M_b$** (a free monoid has no
invertible elements but $1$) and **inner for $\operatorname{Aff}$**. This is the exact
sense in which §8's slogan "opposite-endomorphism" has two inequivalent readings here,
and both are realized: reversal $=$ opposite *monoid*, complement $=$ opposite
*orientation of the affine line*.

**Involutivity summary (§8 step 3).** $D^{2}=\operatorname{id}$ on $A^{*}$/$M_b$/each
$W_n$: **proved** (trivially). $E^{2}=\operatorname{id}$ on $A^{*}$/$M_b$/$W_n$/
$\mathbb Z/b^{n}$/$\mathbb Z_b$: **proved**. Neither is refuted anywhere it is defined;
the only failure is one of **domain**, for $D$, at the completion (§4).

---

## 2. §8 step 2 — all four corners, for the ACTION

Let $w\in W_n$, $v=L_n(w)$, $\Phi(w)=[b^{n},v]$.

| corner | word | affine element of $M_b$ | value | odometer conjugate on $\mathbb Z/b^n$ | on $\mathbb Z_b$ |
|---|---|---|---|---|---|
| $X$ | $w$ | $[b^{n},v]$ | $v$ | $T_n:x\mapsto x+1$ | $\operatorname{id}$ |
| $DX$ | $\rho w$ | $[b^{n},R_nv]$ | $R_nv$ | $\widetilde T_n=R_nT_nR_n$ | **undefined** (Thm 4.2) |
| $EX$ | $\varepsilon_{*}w$ | $\sigma[b^{n},v]\sigma=[b^{n},b^{n}-1-v]$ | $-1-v$ | $T_n^{-1}:x\mapsto x-1$ | $x\mapsto-1-x$ |
| $DEX$ | $\rho\varepsilon_{*}w$ | $[b^{n},\,b^{n}-1-R_nv]$ | $-1-R_nv$ | $\widetilde T_n^{\,-1}$ | **undefined** |

**On generators.** $D\gamma_d=\gamma_d$ for every $d$ (every one-letter word is a
palindrome): *$D$ is invisible on generators and lives entirely in the composition
order*. $E\gamma_d=\gamma_{b-1-d}$: *$E$ is invisible on composition order and lives
entirely in the generator labels*. The crystal is exactly the product of these two
independent degrees of freedom — which is already a proof sketch of Theorem 3.1.

**On the carry cocycle.** For $x\in\mathbb Z/b^{n}$ (length-$n$ digit string) put
$$c_n(x)=\#\text{trailing }(b-1)\text{ digits},\quad
z_n(x)=\#\text{trailing }0\text{ digits},\quad
\ell_n(x)=\#\text{leading }(b-1)\text{ digits},$$
and let $s(x)$ be the digit sum. The odometer carry cocycle is the exact identity
(all $x<b^{n}-1$)
$$s(x+1)-s(x)=1-(b-1)\,c_n(x). \tag{2.1}$$
$c_n$ is the number of carries produced by $+1$; $z_n$ is the number of borrows
produced by $-1$. Then, exactly:
$$c_n(E_nx)=z_n(x),\qquad z_n(E_nx)=c_n(x),\qquad c_n(D_nx)=\ell_n(x). \tag{2.2}$$
**$E$ exchanges carry with borrow; $D$ exchanges trailing with LEADING.** The word
"leading" presupposes a most-significant end. That single observation is the entire
obstruction of §4, and (2.2) is where the crystal meets the carry structure.

---

## 3. §8 steps 4–5 — the commutator, the group at each level, the fixed points

### 3.1 The commutator is trivial — at every level

**Theorem 3.1.** $\rho\,\varepsilon_{*}=\varepsilon_{*}\,\rho$ on $A^{*}$. Hence
$[D,E]=1$ everywhere both are defined, and:

1. **(words of length $n$)** In $\operatorname{Sym}(W_n)$,
 $$\langle D_n,E_n\rangle\;\cong\;
 \begin{cases}1,&n=0,\\ \mathbb Z/2\ (=\langle E_1\rangle),&n=1,\\
 \mathbb Z/2\times\mathbb Z/2\ \text{(Klein four)},&n\ge2,\end{cases}$$
 for every $b\ge2$.
2. **(free affine digit monoid)** In $\operatorname{Aut}^{\pm}(M_b)\cong S_b\times\mathbb Z/2$,
 $$\langle D,E\rangle=\langle\varepsilon\rangle\times\langle\rho\rangle\;\cong\;\mathbb Z/2\times\mathbb Z/2 .$$
 It is **Klein four, not dihedral and not a nonabelian semidirect product**, and it
 carries the grading $\operatorname{Aut}^{\pm}\twoheadrightarrow\mathbb Z/2$
 (automorphism vs. anti-automorphism) with $D\mapsto1$, $E\mapsto0$.

*Proof.* $(\rho\varepsilon_{*}w)_i=(\varepsilon_{*}w)_{n-1-i}=b-1-w_{n-1-i}
=\varepsilon(\rho w)_i=(\varepsilon_{*}\rho w)_i$. So $\langle D,E\rangle$ is a
quotient of $(\mathbb Z/2)^{2}$. Nontriviality of each nonidentity element:
$D_n\ne\operatorname{id}$ for $n\ge2$ (the word $0^{n-1}1$ is not a palindrome, using
$b\ge2$); $E_n\ne\operatorname{id}$ and $D_nE_n\ne\operatorname{id}$ for $n\ge1$
(both move $0^{n}$ to $(b-1)^{n}$). $D_1=\operatorname{id}$ because every one-letter
word is a palindrome, and $D_0=E_0=\operatorname{id}$. Part 2 is Prop. 1.1 plus the
observation that $\varepsilon\in S_b$ is a nonidentity involution for $b\ge2$. $\square$

**Refutation of the expected dihedral structure (this was a registered forecast
target).** One might expect that because $D$ *reverses composition*, the pair $(D,E)$
generates a semidirect/dihedral object. It does not. Being an anti-automorphism is a
$\mathbb Z/2$-**grading** on $\operatorname{Aut}^{\pm}$, not a nonabelian relation
between $D$ and $E$: $\operatorname{Aut}^{\pm}(A^{*})\cong S_b\times\mathbb Z/2$ has
$\rho$ **central**. The commutator $[D,E]$ is trivial at the word level, at the monoid
level, at the finite-chart level and (vacuously) at the completion. **$DE=ED$.**

### 3.2 Where the dihedral structure actually lives

**Theorem 3.2 (odometer level).** On $\mathbb Z_b$:

1. $E T E^{-1}=T^{-1}$ (so $E$ is a *reversor* of the odometer, and
 $(\mathbb Z_b,T)$ is a reversible dynamical system with involutive reversor);
2. the centralizer of $T$ in $\operatorname{Homeo}(\mathbb Z_b)$ is the group of
 translations $\{x\mapsto x+c:c\in\mathbb Z_b\}\cong\mathbb Z_b$;
3. the normalizer of the cyclic group $\langle T\rangle\cong\mathbb Z$ in
 $\operatorname{Homeo}(\mathbb Z_b)$ is exactly
 $$N=\{x\mapsto \pm x+c\;:\;c\in\mathbb Z_b\}\;\cong\;\mathbb Z_b\rtimes\mathbb Z/2 ;$$
4. $\langle T,E\rangle=\{x\mapsto x+n\}\cup\{x\mapsto n-1-x\}_{n\in\mathbb Z}\cong
 D_\infty$ (infinite dihedral), dense in $N$;
5. the normalizer of the *closed* translation group $\overline{\langle T\rangle}=\mathbb Z_b$
 is $\{x\mapsto ux+c: u\in\mathbb Z_b^{\times},c\in\mathbb Z_b\}\cong\mathbb Z_b\rtimes\mathbb Z_b^{\times}$.

*Proof.* (1) $ETE(x)=E(T(-1-x))=E(-x)=-1+x=T^{-1}(x)$.
(2)–(3),(5): if $\phi T\phi^{-1}=T^{k}$ ($k\in\mathbb Z$) then $\phi(x+1)=\phi(x)+k$
for all $x$, so $\phi(m)=\phi(0)+km$ for $m\in\mathbb Z$; $\mathbb Z$ is dense in
$\mathbb Z_b$ and $\phi$ is continuous, so $\phi(x)=\phi(0)+kx$ everywhere. Such $\phi$
is a homeomorphism iff $k\in\mathbb Z_b^{\times}$; this proves (5) (with
$\phi T\phi^{-1}=T_{u}$ the translation by $u$) and (2) (case $k=1$). For (3) we also
need $\phi^{-1}T\phi=T^{k'}$ with $k'\in\mathbb Z$, whence $T=T^{kk'}$ and $kk'=1$ in
$\mathbb Z$, so $k=\pm1$; $k=1$ gives translations and $k=-1$ gives $x\mapsto c-x$.
(4) is a direct computation, and $\{n-1:n\in\mathbb Z\}$ is dense in $\mathbb Z_b$. $\square$

So **the dihedral orbit that §8 anticipates is real, but it is generated by $E$ together
with the dynamics $T$ — never by $E$ together with $D$.** And $D$ cannot join: by
Theorem 4.2 it does not act on $\mathbb Z_b$ at all.

**Proposition 3.3 (the fourth corner is a genuinely new finite dynamical system).**
For $n\ge2$ and $b\ge2$, the reversed odometer $\widetilde T_n=R_nT_nR_n$ is a
$b^{n}$-cycle which is
1. **not affine** mod $b^{n}$ (no $u,c$ with $\widetilde T_n(x)=ux+c$), and
2. **not in** the dihedral group $\langle T_n,E_n\rangle$, which has order $2b^{n}$
 for $b^{n}\ge3$ (it degenerates to order $2$ when $b^{n}=2$, since mod $2$ the map
 $x\mapsto-1-x$ *is* the translation $x\mapsto x+1$; the case $n\ge2$ used here always
 has $b^{n}\ge4$).

*Proof.* $\widetilde T_n$ is conjugate to the $b^{n}$-cycle $T_n$, hence a $b^n$-cycle,
hence of order $b^{n}>2$; so it is not one of the $b^{n}$ reflections
$x\mapsto k-1-x$ in $\langle T_n,E_n\rangle$. It remains to exclude translations, and
(1) reduces to the same: $\widetilde T_n(0)=R_n(T_n(0))=R_n(1)=b^{n-1}$, so an affine
form would have $c=b^{n-1}$; and $R_n(b^{n-1}+1)=b^{n-1}+1$ (that string is a
palindrome), so $\widetilde T_n(1)=R_n(R_n(1)+1)=R_n(b^{n-1}+1)=b^{n-1}+1$, forcing
$u=1$, i.e. a translation by $b^{n-1}$. But take $x=(b-1)b^{n-1}$: $R_n(x)=b-1$,
$R_n(x)+1=b$, and $R_n(b)=b^{n-2}$, so $\widetilde T_n(x)=b^{n-2}$, whereas a
translation by $b^{n-1}$ gives $(b-1)b^{n-1}+b^{n-1}=b^{n}\equiv0$. Since $n\ge2$,
$b^{n-2}\not\equiv0$. $\square$

The group $\langle T_n,R_n\rangle\le\operatorname{Sym}(b^{n})$ generated by the
odometer and reversal is therefore strictly larger than dihedral. Its order is
**measured**, not predicted (forecast item F8, outcome space deliberately open): in
every case computed exactly in §5 — $(b,n)\in\{(2,2),(2,3),(2,4),(2,5),(3,2),(3,3)\}$,
degrees $4,8,16,32,9,27$ — it is the **full symmetric group** $S_{b^{n}}$. This is a
MEASUREMENT over six cases, not a theorem: no general statement is proved, and the
degree-$32$ Schreier–Sims cap means no $b=10$ case was computed at all (see §8.1).

### 3.3 Fixed points — exact closed forms

**Theorem 3.4.** For $b\ge2$ and $n\ge1$, on $W_n$:

$$\big|\operatorname{Fix}D_n\big|=b^{\lceil n/2\rceil}\qquad\text{(palindromes),}$$
$$\big|\operatorname{Fix}E_n\big|=\begin{cases}1,&b\text{ odd (the constant word }(\tfrac{b-1}2)^{n}),\\0,&b\text{ even,}\end{cases}$$
$$\big|\operatorname{Fix}D_nE_n\big|=\begin{cases}b^{\lfloor n/2\rfloor},&n\text{ even, or }n\text{ odd and }b\text{ odd},\\0,&n\text{ odd and }b\text{ even,}\end{cases}\qquad\text{(antipalindromes),}$$
$$\big|\operatorname{Fix}\langle D_n,E_n\rangle\big|=\big|\operatorname{Fix}D_n\cap\operatorname{Fix}E_n\big|=\begin{cases}1,&b\text{ odd},\\0,&b\text{ even},\end{cases}$$
and by Burnside the number of $\langle D_n,E_n\rangle$-orbits on $W_n$ is
$$\#\mathrm{orb}_n=\tfrac14\Big(b^{n}+b^{\lceil n/2\rceil}+|\operatorname{Fix}E_n|+|\operatorname{Fix}D_nE_n|\Big),$$
an integer for all $b\ge2,n\ge1$. Generating functions:
$$\sum_{n\ge0}|\operatorname{Fix}D_n|x^{n}=\frac{1+bx}{1-bx^{2}},\qquad
\sum_{n\ge0}|\operatorname{Fix}D_nE_n|x^{n}=\begin{cases}\dfrac{1+x}{1-bx^{2}},&b\text{ odd},\\[2mm]\dfrac{1}{1-bx^{2}},&b\text{ even},\end{cases}\qquad
\sum_{n\ge0}|\operatorname{Fix}E_n|x^{n}=\begin{cases}\dfrac1{1-x},&b\text{ odd},\\1,&b\text{ even}.\end{cases}$$

*Proof.* $\operatorname{Fix}D_n$: $w$ is determined by $(c_0,\dots,c_{\lceil n/2\rceil-1})$
and any such choice extends uniquely — bijection with $A^{\lceil n/2\rceil}$.
$\operatorname{Fix}E_n$: $w_i=b-1-w_i$ for every $i$, i.e. $2w_i=b-1$; solvable in
$A$ iff $b$ is odd, uniquely by $w_i=(b-1)/2$.
$\operatorname{Fix}D_nE_n$: the condition is $c_i=b-1-c_{n-1-i}$, which pairs index $i$
with $n-1-i$; each of the $\lfloor n/2\rfloor$ genuine pairs admits $b$ free choices
(one member determines the other), and if $n$ is odd the middle index requires
$2c_m=b-1$, solvable iff $b$ is odd (uniquely). The intersection count and Burnside are
immediate. $\square$

**Value-level cross-check (independent derivation).** On $\mathbb Z/b^{n}$,
$\operatorname{Fix}E_n=\{v:2v=-1\}$, which is a singleton iff $2\in(\mathbb Z/b^{n})^{\times}$
iff $b$ is odd, and empty otherwise — agreeing with the digit criterion. On
$\mathbb Z_b$, $\operatorname{Fix}E=\{-\tfrac12\}$ for $b$ odd (all digits $(b-1)/2$)
and $\varnothing$ for $b$ even, the exact limit of the finite counts.

---

## 4. §8 step 6 — the residual: a crystal that exists on the chart and does not complete

This is the lane's headline and it crosses `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §4
(reachable chart vs. ambient completion) with §8.

### 4.1 Two truncation systems on the same objects

On the family $\{\mathbb Z/b^{n}\}_{n\ge0}$ define **two** surjective transition maps:
$$\pi_n(v)=v\bmod b^{n}\quad(\text{delete the \emph{most} significant digit}),\qquad
\varsigma_n(v)=\big\lfloor v/b\big\rfloor\quad(\text{delete the \emph{least} significant digit}),$$
$\varsigma_n$ computed on the representative in $[0,b^{n+1})$. Write
$\mathbb Z_b=\varprojlim(\pi)$ and $\Sigma_b=\varprojlim(\varsigma)$.

**Lemma 4.1.** $\varsigma_n$ is surjective but is **not** a group homomorphism for
$n\ge1$; consequently $\Sigma_b$ admits **no** group structure making the canonical
projections $q_n:\Sigma_b\to\mathbb Z/b^{n}$ homomorphisms.

*Proof.* $\varsigma_1(1)+\varsigma_1(b-1)=0+0=0$ but $\varsigma_1(1+(b-1))=\varsigma_1(b)=1$
in $\mathbb Z/b$. The system is surjective, so each $q_n$ is surjective; if the $q_n$
were homomorphisms then $\varsigma_n q_{n+1}=q_n$ with $q_{n+1}$ surjective would force
$\varsigma_n$ to be a homomorphism. $\square$

So $\mathbb Z_b$ is a topological *group* (it carries $+$, hence the odometer, hence the
carry cocycle (2.1)); $\Sigma_b$ is only a profinite *set*.

### 4.2 $D$ does not descend — and the exact identity that replaces the failure

**Theorem 4.2 (the intertwiner).** For every $b\ge2$ and $n\ge0$,
$$\boxed{\ \pi_n\circ R_{n+1}=R_n\circ\varsigma_n\qquad\text{and}\qquad
\varsigma_n\circ R_{n+1}=R_n\circ\pi_n\ }$$
as maps $\mathbb Z/b^{n+1}\to\mathbb Z/b^{n}$, exactly. Consequently:

1. $(R_n)_n$ is an **isomorphism of inverse systems** $(\mathbb Z/b^{n},\pi)\to(\mathbb Z/b^{n},\varsigma)$
 and also $(\varsigma)\to(\pi)$ (the same maps, since $R_n^2=\operatorname{id}$);
2. $(R_n)_n$ is **not** an endomorphism of $(\mathbb Z/b^{n},\pi)$ for any $n\ge1$; the
 agreement locus is exactly the $b$ constant strings:
 $$\{x\in\mathbb Z/b^{n+1}:\pi_nR_{n+1}x=R_n\pi_nx\}=\{d\cdot\tfrac{b^{n+1}-1}{b-1}:d\in A\},$$
 of cardinality $b$, so the **defect fraction is exactly $1-b^{-n}$**;
3. therefore reversal induces **no self-map of $\mathbb Z_b$** by the universal property
 of the inverse limit.

By contrast $(E_n)_n$ **is** an endomorphism of $(\pi)$ *and* of $(\varsigma)$:
$\pi_nE_{n+1}=E_n\pi_n$ and $\varsigma_nE_{n+1}=E_n\varsigma_n$, exactly.

*Proof.* Let $x$ have little-endian digits $c_0,\dots,c_n$. Then
$R_{n+1}x=\sum_{i=0}^{n}c_ib^{\,n-i}$, so $\pi_n(R_{n+1}x)=\sum_{i=1}^{n}c_ib^{\,n-i}
=R_n(c_1,\dots,c_n)=R_n(\varsigma_nx)$, and
$\varsigma_n(R_{n+1}x)=\sum_{i=0}^{n-1}c_ib^{\,n-1-i}=R_n(c_0,\dots,c_{n-1})=R_n(\pi_nx)$.
For (2): since $R_n$ is injective, $\pi_nR_{n+1}x=R_n\pi_nx$ iff $\varsigma_nx=\pi_nx$,
i.e. iff $(c_1,\dots,c_n)=(c_0,\dots,c_{n-1})$, i.e. iff $c_0=c_1=\dots=c_n$. For $E$:
$E_{n+1}x$ has digits $b-1-c_i$, and deleting either end of that string gives the
complement of the corresponding deletion for $x$. $\square$

**Theorem 4.3 (no pointwise repair either).** Let $R^{\min}:\mathbb Z_{\ge0}\to\mathbb Z_{\ge0}$
be *minimal-length* reversal (reverse the digit string with no leading zeros;
$R^{\min}(0)=0$). Then $R^{\min}$ is **discontinuous at every point** of
$\mathbb Z_{\ge0}$ in the $b$-adic topology. Hence no map $\mathbb Z_b\to\mathbb Z_b$
agreeing with $R^{\min}$ on $\mathbb Z_{\ge0}$ is continuous anywhere, and $R^{\min}$ is
not uniformly continuous; explicitly, for every $k$ there exist $u,v$ with
$|u-v|_b\le b^{-k}$ and $|R^{\min}u-R^{\min}v|_b=b^{-1}$.

*Proof.* Fix $x\in\mathbb Z_{\ge0}$ with $m$ digits. For $k\ge m+1$ put
$u_k=x+b^{k}$ and $v_k=x+b^{k}+b^{k+1}$; then $|u_k-x|_b=|v_k-x|_b=b^{-k}\to0$.
The digits of $u_k$ are those of $x$, then zeros, then a $1$ in position $k$ (length
$k+1$); reversing sends position $k\mapsto0$ and position $k-1\mapsto1$, so
$R^{\min}(u_k)\equiv 1+0\cdot b\pmod{b^{2}}$. The digits of $v_k$ are those of $x$, then
zeros, then $1$ in positions $k$ and $k+1$ (length $k+2$); reversing gives
$R^{\min}(v_k)\equiv1+1\cdot b\pmod{b^{2}}$. Hence
$R^{\min}(v_k)-R^{\min}(u_k)\equiv b\pmod{b^{2}}$ and
$|R^{\min}u_k-R^{\min}v_k|_b=b^{-1}$ for all such $k$. Two sequences converging to the
same point $x$ cannot have images that stay $b^{-1}$ apart while both converging to a
common value. $\square$

*Sharpness (measured, §5).* Restricted to **positive** integers the supremum of
$|R^{\min}u-R^{\min}v|_b$ over pairs with $|u-v|_b\le b^{-k}$ is $1$ for $b\ge3$ and
$b^{-1}$ for $b=2$ — because the units digit of $R^{\min}$ is the *leading* digit of the
input, and in base $2$ every leading digit is $1$. (Allowing $u=0$ raises the base-$2$
supremum to $1$ as well: $|0-b^{k}|_b=b^{-k}$ while $R^{\min}(0)=0$, $R^{\min}(b^{k})=1$.)

### 4.3 What $D$ *does* become in the limit: the crystal collapses to $\mathbb Z/2$

Let $L:\mathbb Z_b\to A^{\mathbb N}$, $L(x)=(c_i)_{i\ge0}$, be the little-endian digit
chart, and let $J:\Sigma_b\to A^{\mathbb N}$, $J\big((x_n)_n\big)=(d_n)_{n\ge0}$ with
$x_{n+1}=b\,x_n+d_n$, be the canonical digit chart of $\Sigma_b$. Both are
~~homeomorphisms~~ **continuous bijections, hence homeomorphisms,** onto
$A^{\mathbb N}$ with the product topology. *Ground for the inverse — the clause
that is not free for spaces, unlike for groups or monoids:* $L$ and $J$ are
bijections whose $n$-th coordinate depends only on the $n$-th (resp. $(n{+}1)$-st)
level of the inverse system, hence are continuous for the profinite topologies;
$\mathbb Z_b=\varprojlim(\pi)$ and $\Sigma_b=\varprojlim(\varsigma)$ are inverse
limits of finite discrete sets, hence **compact**, and $A^{\mathbb N}$ is
Hausdorff, so a continuous bijection out of either is automatically a
homeomorphism. Without compactness the assertion would need $L^{-1},J^{-1}$
exhibited separately; with it the inverse clause is discharged in one line.
[Clause supplied in place by seed134, 2026-08-14; the claim was true and only
the argument was absent. Nothing downstream moves — Thm 4.4 and Cor. 4.5 use
$L,J$ only as bijections intertwining the digit charts.]

**Theorem 4.4 (reversal completes, but to the identity).** The isomorphism of inverse
systems of Theorem 4.2(1) induces a homeomorphism $R_\infty:\mathbb Z_b\to\Sigma_b$, and
$$J\circ R_\infty=L .$$
That is: **in the canonical digit charts on both sides, the limit of word reversal is
the identity map**, although $D_n\ne\operatorname{id}$ for every $n\ge2$.

*Proof.* $R_\infty(x)=\big(R_n(\pi_nx)\big)_n$ (a compatible sequence by Thm 4.2).
With $L(x)=(c_i)$, $R_n(\pi_nx)=\sum_{i<n}c_ib^{\,n-1-i}$, hence
$R_{n+1}(\pi_{n+1}x)=\sum_{i\le n}c_ib^{\,n-i}=b\,R_n(\pi_nx)+c_n$, so $d_n=c_n$. $\square$

**Corollary 4.5 (the exact completion verdict).** Identify both limits with
$A^{\mathbb N}$ via $L$ and $J$. Then $\mathcal K:=\langle D,E\rangle\cong(\mathbb Z/2)^2$
acts on every finite chart $W_n$ ($n\ge2$) faithfully, and the induced map
$$\mathcal K\longrightarrow\operatorname{Homeo}(A^{\mathbb N})\cong\operatorname{Homeo}(\mathbb Z_b)$$
is a group homomorphism with
$$\ker=\langle D\rangle\cong\mathbb Z/2,\qquad
\operatorname{im}=\langle E\rangle=\{\operatorname{id},\;x\mapsto-1-x\}\cong\mathbb Z/2 .$$
*Proof.* By Thm 4.2 every $g\in\mathcal K$ is a morphism of inverse systems, of degree
$\deg g\in\mathbb Z/2$: degree $0$ ($E$, $\operatorname{id}$) means an endomorphism of
each of $(\pi)$ and $(\varsigma)$; degree $1$ ($D$, $DE$) means a morphism
$(\pi)\to(\varsigma)$ and $(\varsigma)\to(\pi)$. Taking limits gives, for each $g$, a
homeomorphism $g_\infty$ from $\varprojlim(\pi)=\mathbb Z_b$ to
$\varprojlim(\pi)$ or $\varprojlim(\varsigma)=\Sigma_b$ according to $\deg g$. Define
$\Psi(g)=\chi\circ g_\infty\circ L^{-1}$ where $\chi=L$ if $\deg g=0$ and $\chi=J$ if
$\deg g=1$. Then:
$\Psi(\operatorname{id})=\operatorname{id}$;
$\Psi(D)=J R_\infty L^{-1}=\operatorname{id}$ by Thm 4.4;
$\Psi(E)=LE_\infty L^{-1}=$ digitwise complement, by Prop. 1.2;
$\Psi(DE)=J(R_\infty E_\infty)L^{-1}=(JR_\infty L^{-1})(LE_\infty L^{-1})
=\operatorname{id}\circ\Psi(E)=\Psi(E)$.
So $\Psi$ is multiplicative on all four elements, with kernel $\{\operatorname{id},D\}$
and image $\{\operatorname{id},\text{complement}\}$. $\square$

### 4.4 The residual, stated

> **The reversal/complement crystal is a faithful Klein-four symmetry of every finite
> digit chart and an index-2 subgroup $\mathbb Z/2$ of it on the completion. The
> generator that dies is $D$, and it does not die to a commutator — the commutator is
> trivial at every level — it dies to a *domain* obstruction: $D$ exchanges the two ends
> of a word, and $\mathbb Z_b$ has only one end.**

Precisely, the residual is the **endian class**: the $\mathbb Z/2$ that distinguishes
the two truncation systems $\pi$ (delete the most significant digit) and $\varsigma$
(delete the least significant digit) on the *same* finite objects. Only $\pi$ has a
group-valued limit (Lemma 4.1), and the carry cocycle (2.1), the odometer, and the
whole of Theorem 3.2 live on that side. $D$ transports every one of these structures
across the endian class:

- $T_n\ \longmapsto\ \widetilde T_n$: the odometer becomes the reversed odometer, which
 is $\varsigma$-compatible but **not** $\pi$-compatible — the exact reversal of the
 odometer's own situation — and is not even in $\langle T_n,E_n\rangle$ (Prop. 3.3).
 *Proof of $\varsigma$-compatibility:*
 $\varsigma_n\widetilde T_{n+1}=\varsigma_nR_{n+1}T_{n+1}R_{n+1}
 =R_n\pi_nT_{n+1}R_{n+1}=R_nT_n\pi_nR_{n+1}=R_nT_nR_n\varsigma_n=\widetilde T_n\varsigma_n$,
 using both identities of Thm 4.2 and $\pi_nT_{n+1}=T_n\pi_n$. *Failure of
 $\pi$-compatibility, explicitly:* at $b=2,n=1$, $R_2=(1\,2)$ and
 $\widetilde T_2=(0\,2\,1\,3)$ while $\widetilde T_1=T_1=(0\,1)$, so
 $\pi_1\widetilde T_2(0)=\pi_1(2)=0$ but $\widetilde T_1\pi_1(0)=1$;
- carry $c_n\ \longmapsto\ $ leading-digit count $\ell_n$ (2.2), which has no limit;
- the group law on $\mathbb Z/b^n$ $\longmapsto$ a binary operation whose transition maps
 are not homomorphisms (Lemma 4.1).

So the answer to "does the crystal interact with the carry structure?" is **yes, and the
interaction is exactly the obstruction**: $E$ acts on carries reversibly
(carry $\leftrightarrow$ borrow, $T\leftrightarrow T^{-1}$, both defined on
$\mathbb Z_b$); $D$ maps the carry structure out of the completion entirely. This is a
§4 chart-versus-completion phenomenon occurring *inside* a §8 crystal: a duality that
lives only on the chart, crossed with one that lives on the completion.

**Frontier feed-back (§8 step 6).** Two successor questions this opens, both stated as
open, neither claimed:
(Q1) Is $\langle T_n,R_n\rangle=\operatorname{Sym}(b^{n})$ for all $b\ge2$, $n\ge2$?
Six exact computations say yes (§5); nothing is proved. Note that Jordan's criterion
does not apply off the shelf: $R_n$ is not a transposition — its support has size
$b^{n}-b^{\lceil n/2\rceil}$, so it is a product of $\tfrac12(b^{n}-b^{\lceil n/2\rceil})$
disjoint transpositions.
(Q2) The endian class is a $\mathbb Z/2$ attached to the *pair* of truncation systems.
Is there a general statement: for a profinite completion of a chart of finite words,
the subgroup of chart symmetries that survives is exactly the stabilizer of the
truncation direction? This is the compression the crystal suggests; it is **not proved
here** and is not asserted.

---

## 5. Computational verification (`code/exp62_digit_crystal.py`)

Registered forecast F1–F8 is in the script docstring, pre-run, per `PROTOCOL.md` §4.
All arithmetic is exact integer arithmetic; every identity is checked as an equality of
integers, not a tolerance. Exhaustive enumeration is used whenever $b^{n}\le6\cdot10^{5}$
and the mode is printed per row; the $b=10,n\ge6$ rows are closed-form plus sampled
falsification and are **labelled `closed+sampled` in the output**, not silently upgraded.

Full printed output is archived at `data/exp62_out.txt` (323 lines). The load-bearing
blocks are quoted verbatim below (`...` marks omitted rows only; nothing is reworded).
Two independent reruns of the script produced byte-identical output.

**Figures.** `figures/exp62_crystal_fixed_and_defect.png` — left: the fixed-set counts
of §5.1 against $b^{n}$, showing the $b^{\lceil n/2\rceil}$ / $b^{\lfloor n/2\rfloor}$
split and the parity collapse of antipalindromes for even bases; right: the completion
defect fraction of Thm 4.2, exactly $1-b^{-n}$ at every level, against $E$'s identically
zero defect. `figures/exp62_no_continuous_extension.png` — the input distance
$|u-v|_b\to0$ against the output distance $|R^{\min}u-R^{\min}v|_b$, pinned at $b^{-1}$:
a flat line is the picture of "no modulus of continuity".

### 5.1 Fixed points: brute force vs. Theorem 3.4, at every $n\le12$, for $b\in\{2,3,10\}$

Brute force enumerates all $b^{n}$ words and counts fixed points of $D$, $E$, $DE$ and
of the whole group, then compares with the closed forms and with a direct orbit count
(Burnside). The `mode` column is printed per row and is never upgraded silently.

```
  base b = 2
      n           b^n     |FixD|   |FixE|    |FixDE|  |FixAll|     orbits  mode
      0             1          1        1          1         1          1  exhaustive
      1             2          2        0          0         0          1  exhaustive
      2             4          2        0          2         0          2  exhaustive
      3             8          4        0          0         0          3  exhaustive
      4            16          4        0          4         0          6  exhaustive
      5            32          8        0          0         0         10  exhaustive
      6            64          8        0          8         0         20  exhaustive
      7           128         16        0          0         0         36  exhaustive
      8           256         16        0         16         0         72  exhaustive
      9           512         32        0          0         0        136  exhaustive
     10          1024         32        0         32         0        272  exhaustive
     11          2048         64        0          0         0        528  exhaustive
     12          4096         64        0         64         0       1056  exhaustive

  base b = 3
      n           b^n     |FixD|   |FixE|    |FixDE|  |FixAll|     orbits  mode
      0             1          1        1          1         1          1  exhaustive
      1             3          3        1          1         1          2  exhaustive
      2             9          3        1          3         1          4  exhaustive
      3            27          9        1          3         1         10  exhaustive
      4            81          9        1          9         1         25  exhaustive
      5           243         27        1          9         1         70  exhaustive
      6           729         27        1         27         1        196  exhaustive
      7          2187         81        1         27         1        574  exhaustive
      8          6561         81        1         81         1       1681  exhaustive
      9         19683        243        1         81         1       5002  exhaustive
     10         59049        243        1        243         1      14884  exhaustive
     11        177147        729        1        243         1      44530  exhaustive
     12        531441        729        1        729         1     133225  exhaustive

  base b = 10
      n           b^n     |FixD|   |FixE|    |FixDE|  |FixAll|     orbits  mode
      0             1          1        1          1         1          1  exhaustive
      1            10         10        0          0         0          5  exhaustive
      2           100         10        0         10         0         30  exhaustive
      3          1000        100        0          0         0        275  exhaustive
      4         10000        100        0        100         0       2550  exhaustive
      5        100000       1000        0          0         0      25250  exhaustive
      6       1000000       1000        0       1000         0     250500  closed+sampled
      7      10000000      10000        0          0         0    2502500  closed+sampled
      8     100000000      10000        0      10000         0   25005000  closed+sampled
      9    1000000000     100000        0          0         0  250025000  closed+sampled
     10   10000000000     100000        0     100000         0 2500050000  closed+sampled
     11  100000000000    1000000        0          0         0 25000250000  closed+sampled
     12 1000000000000    1000000        0    1000000         0 250000500000  closed+sampled
```

Every `exhaustive` row (32 of them) satisfies, as an equality of integers:
brute-force count $=$ closed form of Thm 3.4, **and** Burnside $=$ direct orbit count.
The parity/base alternation predicted by Thm 3.4 is visible: $|\operatorname{Fix}DE|=0$
exactly on odd $n$ for the even bases $2$ and $10$, and never for $b=3$.

### 5.2 The group $\langle D,E\rangle$: explicit multiplication table at each $n$

Closure and associativity are checked on the explicit $4\times4$ table of permutations
of $W_n$; the isomorphism type is fingerprinted by the multiset of element orders
($V_4\mapsto\{1,2,2,2\}$, $\mathbb Z/4\mapsto\{1,2,4,4\}$).

```
    b= 2 n= 0: |<D,E>| = 1, element orders [1]  ==>  trivial
    b= 2 n= 1: |<D,E>| = 2, element orders [1, 2]  ==>  Z/2
    b= 2 n= 2: |<D,E>| = 4, element orders [1, 2, 2, 2]  ==>  V4 = Z/2 x Z/2
    ...
    b= 2 n= 8: |<D,E>| = 4, element orders [1, 2, 2, 2]  ==>  V4 = Z/2 x Z/2
    b= 3 n= 2: |<D,E>| = 4, element orders [1, 2, 2, 2]  ==>  V4 = Z/2 x Z/2
    ...
    b= 3 n= 8: |<D,E>| = 4, element orders [1, 2, 2, 2]  ==>  V4 = Z/2 x Z/2
    b=10 n= 1: |<D,E>| = 2, element orders [1, 2]  ==>  Z/2
    b=10 n= 2: |<D,E>| = 4, element orders [1, 2, 2, 2]  ==>  V4 = Z/2 x Z/2
    b=10 n= 3: |<D,E>| = 4, element orders [1, 2, 2, 2]  ==>  V4 = Z/2 x Z/2
```

$DE=ED$ was checked as an equality of permutation tuples at every $(b,n)$ listed, and
elementwise on all $b^{n}$ words at every exhaustive $(b,n)$ of §5.1. **The commutator
is trivial; there is no holonomy at this level.** The degenerate $n\le1$ rows confirm
Thm 3.1's boundary cases rather than being suppressed.

### 5.3 The action: $E$ is conjugation by $\sigma$, $D$ is an anti-automorphism

```
  b=3: sigma gamma_d sigma = gamma_(b-1-d) verified for all d in 0..2
       Phi hom, D anti-auto (Phi(D(uv)) = Phi(Dv)Phi(Du)), E auto = conj_sigma: 4000/4000 random word pairs exact
       four corners at w=(1, 1, 1, 2) (n=4):
         X   = w            word=(1, 1, 1, 2)             affine=[a,c]=[81,67]  = [b^4, 67]
         D X = rev w        word=(2, 1, 1, 1)             affine=[a,c]=[81,41]  = [b^4, 41]
         E X = comp w       word=(1, 1, 1, 0)             affine=[a,c]=[81,13]  = [b^4, 13]
         DEX = rev comp w   word=(0, 1, 1, 1)             affine=[a,c]=[81,39]  = [b^4, 39]
         corner identities  D:v->R_n(v),  E:v->b^n-1-v,  DE:v->b^n-1-R_n(v)  exact

  canonicity of E (search over affine conjugators a=+-1, c in Z):
    b= 2: induced digit permutations = ['id via [a,c]=[1,0]', 'E via [a,c]=[-1,-1]']
    b= 3: induced digit permutations = ['id via [a,c]=[1,0]', 'E via [a,c]=[-1,-1]']
    b=10: induced digit permutations = ['id via [a,c]=[1,0]', 'E via [a,c]=[-1,-1]']
```

(Check of the $b=3$ corners against Thm 3.4/§2: $v=67$, $b^{4}-1-v=80-67=13$ ✓;
$R_4(67)=41$ and $80-41=39$ ✓.) The last block is the exhaustive search behind
Prop. 1.3: over all $[a,c]$ with $a=\pm1$ and $|c|\le 4b$, the **only** digit
permutations induced by conjugation are $\operatorname{id}$ and $\varepsilon$.

### 5.4 The completion defect (Thm 4.2), exactly

```
  b = 2
      n  #x in Z/b^(n+1)  #{pi R != R pi}  pi R = R sig  sig R = R pi  pi E = E pi
      1                4                2          True          True         True
      2                8                6          True          True         True
      3               16               14          True          True         True
      ...
     12             8192             8190          True          True         True

  b = 10
      n  #x in Z/b^(n+1)  #{pi R != R pi}  pi R = R sig  sig R = R pi  pi E = E pi
      1              100               90          True          True         True
      2             1000              990          True          True         True
      3            10000             9990          True          True         True
      4           100000            99990          True          True         True
      5            50000            49998          True          True         True  (sampled)
      ...

  smallest explicit witness of pi-incompatibility, per base:
    b=2: n=1, x=1 (digits (1, 0)): pi_1(R_2(x))=0 != R_1(pi_1(x))=1; and R_1(sig_1(x))=0 = 0 OK
    b=3: n=1, x=1 (digits (1, 0)): pi_1(R_2(x))=0 != R_1(pi_1(x))=1; and R_1(sig_1(x))=0 = 0 OK
    b=10: n=1, x=1 (digits (1, 0)): pi_1(R_2(x))=0 != R_1(pi_1(x))=1; and R_1(sig_1(x))=0 = 0 OK

  sig_n is not additive (so lim<-(sig) carries no compatible group law):
    b=2: sig_1(1+1) = sig_1(2) = 1  vs  sig_1(1)+sig_1(1) = 0   ==> not a homomorphism
    b=3: sig_1(1+2) = sig_1(3) = 1  vs  sig_1(1)+sig_1(2) = 0   ==> not a homomorphism
    b=10: sig_1(1+9) = sig_1(10) = 1  vs  sig_1(1)+sig_1(9) = 0   ==> not a homomorphism
```

The failure counts are **exactly** $b^{n+1}-b$ in every exhaustive row
($4-2$, $8-2$, $\dots$, $8192-2$ for $b=2$; $100-10$, $\dots$, $100000-10$ for $b=10$),
confirming Thm 4.2(2): the agreement locus is precisely the $b$ constant strings, and
the defect fraction is exactly $1-b^{-n}$. Simultaneously `pi R = R sig` and
`sig R = R pi` are `True` at every level and every $x$ — the intertwiner of Thm 4.2
holds exactly where naive compatibility fails. The `(sampled)` rows ($5\cdot10^{4}$
random $x$) are labelled; for $b=10,n=5$ two of the $50000$ samples landed on constant
strings, which is why that row shows $49998$ and not $50000$.

### 5.5 Odometer, carry, and the fourth corner

```
  b = 2
    n= 1 N=    2: ETE=T^-1 True; Ttil affine mod b^n: True; Ttil in <T,E> (|.|=4): True; c(Ex)=z(x): True; digit-sum cocycle: True
    n= 2 N=    4: ETE=T^-1 True; Ttil affine mod b^n: False; Ttil in <T,E> (|.|=8): False; c(Ex)=z(x): True; digit-sum cocycle: True
    n= 3 N=    8: ETE=T^-1 True; Ttil affine mod b^n: False; Ttil in <T,E> (|.|=16): False; c(Ex)=z(x): True; digit-sum cocycle: True
    ...
    n= 6 N=   64: ETE=T^-1 True; Ttil affine mod b^n: False; Ttil in <T,E> (|.|=128): False; c(Ex)=z(x): True; digit-sum cocycle: True
    |<T_2, R_2>| on 4 points = 24   (N! = 24)  = S_N
    |<T_3, R_3>| on 8 points = 40320   (N! = 40320)  = S_N
    |<T_4, R_4>| on 16 points = 20922789888000   (N! = 20922789888000)  = S_N
    |<T_5, R_5>| on 32 points = 263130836933693530167218012160000000   (N! = 263130836933693530167218012160000000)  = S_N

  b = 3
    n= 2 N=    9: ETE=T^-1 True; Ttil affine mod b^n: False; Ttil in <T,E> (|.|=18): False; c(Ex)=z(x): True; digit-sum cocycle: True
    ...
    |<T_2, R_2>| on 9 points = 362880   (N! = 362880)  = S_N
    |<T_3, R_3>| on 27 points = 10888869450418352160768000000   (N! = 10888869450418352160768000000)  = S_N

  b = 10
    n= 1 N=   10: ETE=T^-1 True; Ttil affine mod b^n: True; Ttil in <T,E> (|.|=20): True; c(Ex)=z(x): True; digit-sum cocycle: True
    n= 2 N=  100: ETE=T^-1 True; Ttil affine mod b^n: False; Ttil in <T,E> (|.|=200): False; c(Ex)=z(x): True; digit-sum cocycle: True
    n= 3 N= 1000: ETE=T^-1 True; Ttil affine mod b^n: False; Ttil in <T,E> (|.|=2000): False; c(Ex)=z(x): True; digit-sum cocycle: True
    |<T_n, R_n>|: NOT COMPUTED for b=10 (every b^n with n>=2 exceeds the degree-32 Schreier-Sims cap)
```

$ETE=T^{-1}$, the carry/valuation exchange $c_n(E_nx)=z_n(x)$ of (2.2), and the digit-sum
cocycle (2.1) hold for **all** $x$ at every listed $(b,n)$. Prop. 3.3's two negative
statements are confirmed at every $n\ge2$ and fail (as they must) at $n=1$, where
$R_1=\operatorname{id}$. F8: $\langle T_n,R_n\rangle=S_{b^{n}}$ in all six computed
cases; $b=10$ was **not** computed and the script says so.

### 5.6 No continuous extension (Thm 4.3), with explicit valuations

```
  b = 2   (|y|_b = b^-val_b(y);  witnesses u = x+b^k, v = x+b^k+b^(k+1),
             x = 1 has m = 1 digit, so the theorem needs k >= m+1 = 2)
      k                  u                  v  val(u-v)             Rmin u             Rmin v  val(RmU-RmV)
      2                  5                 13         3                  5                 11             1
      3                  9                 25         4                  9                 19             1
      4                 17                 49         5                 17                 35             1
      ...
     13               8193              24577        14               8193              16387             1
    sharp search (u,v positive, |u-v|_b <= b^-k, k=1..5): min val(Rmin u - Rmin v) = 1  ==> sup |.|_b = b^-1   (predicted b^-1)
       k=1: val=1 at (u,v)=(1,3)
       ...
       k=5: val=1 at (u,v)=(3,35)

  b = 10   (... k >= m+1 = 2)
      k                  u                  v  val(u-v)             Rmin u             Rmin v  val(RmU-RmV)
      2                101               1101         3                101               1011             1
      3               1001              11001         4               1001              10011             1
      ...
     13     10000000000001    110000000000001        14     10000000000001    100000000000011             1
    sharp search (u,v positive, |u-v|_b <= b^-k, k=1..5): min val(Rmin u - Rmin v) = 0  ==> sup |.|_b = b^-0   (predicted b^-0)
       k=1: val=0 at (u,v)=(1,21)
       ...
       k=5: val=0 at (u,v)=(1,200001)
```

The input valuation grows without bound ($|u-v|_b=b^{-(k+1)}\to0$) while the output
valuation is pinned at $1$ ($|R^{\min}u-R^{\min}v|_b=b^{-1}$) for every $k$ — Thm 4.3,
with $b^{-1}$ the exact constant of the constructed family. The separate sharp search
over *all* nearby positive pairs recovers the base-dependent supremum announced after
Thm 4.3: $b^{-1}$ for $b=2$ (leading digit is always $1$ in base $2$, so $R^{\min}$ of a
positive integer is always $\equiv1$ mod $2$) and $b^{0}=1$ for $b\ge3$.

---

## 6. Control ledger (designed annihilation, `PROTOCOL.md` §7 / msg 0073)

A headline claim ships with the apparatus that would kill it, or it is not a claim. The
script contains a verifier that is fed both the live claims and **four planted-false
statements**; the verifier must reject exactly the planted ones. A verifier that
rejects everything is worthless, so a true-but-nontrivial positive control is included
in the same batch.

```
  verifier inputs: b=2, n=4; explicit permutation group <D,E>
    element-order multiset = [1, 2, 2, 2]
    [CLAIM           ] <D,E> is Klein four V4 (orders {1,2,2,2})                  ACCEPTED
    [CONTROL(false)  ] CONTROL A: <D,E> is cyclic Z/4 (orders {1,2,4,4})          REJECTED (correct)
    [CLAIM           ] <D,E> is abelian (DE = ED)                                 ACCEPTED
    [CONTROL(false)  ] CONTROL B: pi_n o R_{n+1} = R_n o pi_n                     REJECTED (correct)
    [CLAIM           ] pi_n o R_{n+1} = R_n o sig_n                               ACCEPTED
    [CONTROL(true)   ] CONTROL D: pi_n o E_{n+1} = E_n o pi_n                     ACCEPTED
    [CONTROL(false)  ] CONTROL C: |Fix E| = b^{n/2}  (b=3, n=4 -> 9)              REJECTED (correct)
    [CLAIM           ] |Fix E| = 1 for b odd  (b=3, n=4)                          ACCEPTED
    [CLAIM           ] brute force == closed form at EVERY exhaustive (b,n) [32 rows] ACCEPTED
    [CONTROL(false)  ] CONTROL E: brute force == closed form with |Fix D| := b^floor(n/2) REJECTED (correct)
    [CLAIM           ] |<T_n,R_n>| != 2 b^n for every computed (b,n)              ACCEPTED

  LEDGER: 4/4 planted-false controls REJECTED; 7/7 true statements ACCEPTED.
```

| control | what it plants | what it tests | verdict |
|---|---|---|---|
| **A** | $\langle D,E\rangle\cong\mathbb Z/4$ | that the isomorphism fingerprint (order multiset) can tell $V_4$ from the *only other* group of order 4 — the required planted-false group-isomorphism claim | **REJECTED** |
| **B** | $\pi_nR_{n+1}=R_n\pi_n$ | that the compatibility test is not vacuously true; this is exactly the statement whose failure is Thm 4.2, planted as if true | **REJECTED** |
| **C** | $|\operatorname{Fix}E_n|=b^{n/2}$ | that the fixed-point comparison discriminates a plausible-looking wrong formula ($9$ vs the true $1$ at $b=3,n=4$) | **REJECTED** |
| **E** | $|\operatorname{Fix}D_n|=b^{\lfloor n/2\rfloor}$ | that the brute-vs-closed comparison over all 32 exhaustive rows has power: the planted formula differs from the truth exactly on odd $n$ | **REJECTED** |
| **D** | $\pi_nE_{n+1}=E_n\pi_n$ (**true**) | that the verifier is not a constant rejector: the same machinery that killed B accepts D | **ACCEPTED** |

Additional non-verifier controls built into the script:

- **Exactness.** Every identity is an equality of Python integers. There is no
 tolerance, so there is no threshold to tune. A single mismatch raises `AssertionError`
 and the run dies; the run exits `0` only if every assertion passed.
- **Degenerate cases are printed, not suppressed.** $n=0,1$ (where $D$ is the identity
 and the group collapses) and $b^{n}\le2$ (where the dihedral group degenerates) appear
 in the output and are asserted *against the degenerate prediction*, not skipped.
- **Sampling is labelled.** Rows that are not exhaustive print `closed+sampled` or
 `(sampled)` and are excluded from the "brute force == closed form" claim, whose row
 count ($32$) is printed.
- **A computation that did not finish is not reported as a measurement.** The
 $\langle T_n,R_n\rangle$ order is capped at degree $32$; for $b=10$ the script prints
 `NOT COMPUTED` rather than a partial or probabilistic answer.
- **The forecast was registered before the run** (script docstring, F1–F8), including
 F8 with a deliberately open outcome space, so that $S_{b^{n}}$ counts as a surprise
 measured against a stated prior rather than a post-hoc pattern.

**Two forecast items were refuted by the work itself and the note follows the
mathematics, not the forecast**: (i) the expectation stated in the lane brief that the
anti-automorphism character of $D$ would produce a semidirect/dihedral group is
**false** (§3.1); (ii) the expectation that reversal simply "fails to complete" is
**too weak** — it completes, to the identity (Thm 4.4).

---

## 7. Attribution: what is classical, what is packaging, what is measured

Labels: **FETCHED** = a source retrieved in this session; **UNVERIFIED-MEMORY** = recalled,
not retrieved this session, must not be relied on; **HERE** = proved in this note.

| statement | status |
|---|---|
| Palindromes / antipalindromes as fixed words of an antimorphic involution ($\rho$, $\rho\varepsilon$) | **CLASSICAL.** FETCHED: C. Guo, J. Shallit, A. M. Shur, *On the Combinatorics of Palindromes and Antipalindromes*, arXiv:1503.09112 — title, authors and abstract retrieved 2026-08-12; the abstract confirms the systematic study of "antipalindromes" alongside palindromes. The formalism of morphic/antimorphic involutions and "Watson–Crick palindromes" (Kari–Mahalingam) is **UNVERIFIED-MEMORY**. |
| $|\text{palindromes}|=b^{\lceil n/2\rceil}$, $|\text{antipalindromes}|=b^{\lfloor n/2\rfloor}$ (with the parity caveat) | **CLASSICAL / folklore.** Proved HERE from scratch (Thm 3.4) because the exact parity/base caveat matters for the crystal. |
| Klein-four action of reversal $\times$ complement on finite words | **CLASSICAL.** This is the standard "reverse-complement" symmetry group of sequence combinatorics and coding theory (UNVERIFIED-MEMORY for a specific citation). Thm 3.1's *proof of exact isomorphism type at each $n$, including the degenerate $n\le1$ cases*, is HERE. |
| $-1=\overline{(b-1)}$ in $\mathbb Z_b$, so $x\mapsto-1-x$ is digitwise complement (two's complement) | **CLASSICAL / folklore** (UNVERIFIED-MEMORY for a textbook citation). Proved HERE (Prop. 1.2) so that nothing rests on memory. |
| Odometers; centralizer $=$ translations; odometer conjugate to its inverse; reversing symmetries and $D_\infty$ | **CLASSICAL** in reversible/adic dynamics (UNVERIFIED-MEMORY; a 2026-08-12 web search returned the general reversible-dynamics and odometer literature — e.g. odometer papers on arXiv and the involutory-reversibility literature — but **no source stating the $x\mapsto-1-x$ reversor for the $b$-adic odometer was located**). All of Thm 3.2 is proved HERE, elementarily and self-containedly, so the note does not depend on the search outcome. |
| Bit-reversal permutation as an involution | **CLASSICAL** (FFT literature; FETCHED: Wikipedia "Bit-reversal permutation" appeared in the 2026-08-12 search and states the involution property). |
| Order of $\langle$ odometer, bit-reversal $\rangle$ in $\operatorname{Sym}(b^{n})$ | **MEASURED HERE** (§5, F8). A 2026-08-12 search located no statement of this group. It is plausibly known or easy; it is *not* claimed as new. Prop. 3.3 (the negative part: it is not the dihedral group, and $\widetilde T_n$ is not affine) **is** proved HERE. |
| Prop. 1.1 ($\operatorname{Aut}^{\pm}(A^{*})\cong S_b\times\mathbb Z/2$) | **CLASSICAL / elementary** (automorphisms of a free monoid permute the free generators; UNVERIFIED-MEMORY for a citation). Proof HERE. |
| Prop. 1.3 (digit complement is the *unique* conjugation-induced digit symmetry in $\operatorname{Aff}(\mathbb Q)$) | **HERE.** Elementary, likely folklore, but it is what makes the choice of $E$ canonical rather than aesthetic, so it is proved rather than asserted. — **PRIOR-ART SWEEP 2026-08-14: RESOLVED-NO-MATCH**, and this is the *second* null on this note's central symmetry, after the 2026-08-12 search recorded three rows above for the $x\mapsto-1-x$ odometer reversor. Search-summary grade at best (`WebFetch` EGRESS_BLOCKED). Query: *normalizer of b-adic odometer in affine group Aff(Q) unique conjugation-induced digit symmetry two's complement x → −1−x reversor*. The results returned the general adic/odometer literature (adic realizations of the Morse transformation, odometer $C^*$-algebras, Pisot numeration groups) and general affine-group material, but no statement of the uniqueness, and none of the $x\mapsto-1-x$ reversor. Two independent nulls are still not evidence of novelty; the untried vocabulary for a next block is *normalizer / centralizer of the adding machine in $\mathrm{Homeo}(\mathbb Z_b)$* and *reversing symmetry group of the adding machine*, which is the reversible-dynamics term of art and was not used in either pass. Attribution status only. |
| Thm 4.2 (the intertwiner $\pi_nR_{n+1}=R_n\varsigma_n$; agreement locus $=$ the $b$ constant strings; defect fraction exactly $1-b^{-n}$) | **HERE.** The qualitative fact that reversal does not extend $b$-adically is folklore; the exact intertwining identity and the exact agreement locus are the packaging this note contributes. |
| Thm 4.4 / Cor. 4.5 (reversal completes *to the identity*; the crystal drops from $V_4$ to $\mathbb Z/2$ with kernel $\langle D\rangle$) | **HERE.** Plausibly new only as a formulation; the ingredients are all elementary. Claimed as **packaging, not as new mathematics.** |

**Honest summary of novelty.** Essentially every ingredient is classical. What this note
supplies is (i) exact statements with proofs where folklore is usually waved at,
(ii) the identification of the residual as the *endian class* $\mathbb Z/2$ together
with the exact intertwiner realizing it, and (iii) a worked instance of §4 crossing §8.
No claim of new mathematics is made; the classification results (Thms 3.1, 3.2, 3.4,
4.2, 4.4) are complete and proved, which is the deliverable.

---

## 8. What was NOT proved

1. **No theorem** that $\langle T_n,R_n\rangle=S_{b^{n}}$ (Q1). Six exact computations
 ($b=2$, $n=2,3,4,5$; $b=3$, $n=2,3$) all give $S_{b^{n}}$; **no $b=10$ case was
 computed at all** (degree $\ge100$ exceeds the degree-$32$ Schreier–Sims cap the script
 enforces, and the script says so in its output). Six data points at two bases are not a
 pattern claim; only Prop. 3.3's negative results are proved.
2. **Lemma 4.1 is not "$\Sigma_b$ is not a group".** $\Sigma_b$ is in bijection with
 $\mathbb Z_b$ and can be given a group structure by transport. The proved statement is
 the only meaningful one: *no* group structure makes the canonical projections
 $q_n$ homomorphisms.
3. **Thm 3.2 is topological, not measure-theoretic.** Nothing is claimed about the
 measure-theoretic centralizer/normalizer of the odometer as a measure-preserving
 system, nor about its full topological full group.
4. **Q2 (the general chart/completion statement) is a question, not a theorem.** No
 general "surviving symmetries = stabilizer of the truncation direction" result is
 proved, and the phrase should not be quoted as one.
5. **Base generality is exactly $b\ge2$ integer.** Nothing is proved for negative bases,
 non-integer bases, signed digit sets, mixed radix, or numeration systems with
 non-free digit monoids (e.g. Zeckendorf), where Lemma 0.1 already fails.
6. **The $b=10$, $n\ge6$ rows are not exhaustively brute-forced** (they are
 $10^{6}$–$10^{12}$ words). They are closed-form plus $2\cdot10^{4}$ random-word
 falsification tests per row plus a constructive enumeration of the predicted
 palindrome set where feasible; the output labels these rows `closed+sampled`.
7. **The literature search was not exhaustive.** Three searches were run (2026-08-12);
 they did not locate sources for the odometer reversor statement or for
 $\langle T_n,R_n\rangle$. Absence of a located source is **not** evidence of novelty,
 and §7 says so.
8. **No connection to the prime-pair field, RH, or any existing note in this repository
 is claimed or implied.** The seeds of `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §12 are cited
 as motivation only; no result of theirs is used or replayed.
9. **The "crystal is canonical" claim (Props. 1.1, 1.3) is relative to the stated ambient
 groups** ($\operatorname{Aut}^{\pm}(A^{*})$ and conjugation inside
 $\operatorname{Aff}(\mathbb Q)$). Other ambient categories may admit other dualities;
 none are excluded.

---

**Status: PENDING HOSTILE AUDIT.**
