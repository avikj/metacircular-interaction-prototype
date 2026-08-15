# Sufficient-statistic audit of four compressions: the fibre is not an object until an order is supplied

**Agent:** SEED-48 (Nāgārjuna lens). **Date:** 2026-08-14.
**Status:** proofs only. Nothing was run; no `.py` file was written or read for
its output; no floating-point quantity appears below.

Audited: `notes/SEED10_BLINDNESS_TAPE.md`, `notes/SEED21_CHECK_CAPACITY_IS_AN_INDEX.md`,
`notes/SEED29_ROUTE_HOLONOMY_TORSOR.md`, `notes/SEED35_CORPUS_COMPRESSION.md`,
with `notes/SEED01_STRONG_BLINDNESS_EQUALS_HEAD_DEPTH.md` and
`notes/SEED04_BLINDNESS_DEPTH_ALGEBRA.md` as the disputed pair.

---

## 0. The lens, and the thing the lens reifies

The mandate:

> For every compression the project relies on, write the map explicitly and ask
> what the fibres look like. A fibre that is a singleton is rigidity; a fibre
> that is a chain is still safe; a fibre containing an antichain is a no-go.
> Most reported compression failures are the third case reported as the second.

Taken literally this presupposes that a fibre *has* a shape. It does not. A
fibre is a set. "Chain" and "antichain" are properties of a set **together with
a partial order**, and no compression map carries an order on its fibres. The
order always arrives from a second place — the consumer — and the four notes
audited here disagree about compressions largely because they have different
consumers in mind and no vocabulary for saying so.

So before the audit, the definition the lens needs.

**Definition (audited compression).** An *audited compression* is a pair
$(c,P)$: a map $c:X\to Y$ (the compression) and a map $P:X\to Q$ into a poset
(the *consumer*: the downstream thing the corpus wants to conclude). For
$y\in c(X)$ write $F_y=c^{-1}(y)$ and $P(F_y)\subseteq Q$.

**Definition (the trichotomy, made well-formed).**

- **Rigidity** at $y$: $|P(F_y)|=1$. $P$ is constant on the fibre; the
  compression is lossless *for this consumer*.
- **Safe** at $y$: $P(F_y)$ is a chain.
- **No-go** at $y$: $P(F_y)$ contains a $2$-element antichain.

**Proposition 0 (why "chain" is the exact meaning of "safe").** If $P(F_y)$ is
a finite chain then it has a least and a greatest element, both attained by
actual objects of $F_y$, and the interval $[\min P(F_y),\max P(F_y)]$ is the
sharpest sound conclusion available from $y$ alone: a one-sided certificate
("$P\ge$ this", "$P\le$ that") exists and is attained. If $P(F_y)$ contains an
antichain $\{p,p'\}$ then no element of $Q$ is a sound one-sided bound attained
by the fibre — the only sound conclusion is the *set* $P(F_y)$ itself. $\square$

This is the whole content of the trichotomy, and it is a statement about $Q$'s
order, not about $c$. **The corollary that matters for the audit:** the same
compression is rigid, safe, or a no-go depending on the consumer, so "does this
compression work?" is not a question with an answer. Every one of the four
disagreements examined below dissolves at exactly this point, and the four
corners — it works / it fails / it both works and fails (on different lanes) /
it neither works nor fails (the question is ill-posed) — are four ways of
declining to name $P$.

**The empirical claim I am testing.** *Most reported compression failures are
antichains reported as chains.* On these four: **false**, and instructively so.
Three of the four notes classify their own fibres correctly and explicitly.
The one real failure (§4) is not a misclassified fibre at all — it is an
**unstated map**: two different compressions were conflated, and the fibre of
the one actually used contains an antichain while the fibre of the one
described is a singleton. Revised slogan, offered as the finding of this audit:

> Most reported compression failures are not misclassified fibres. They are
> unstated maps. Naming $c$ and $P$ resolves them before any classification is
> needed.

---

## 1. SEED-10 — blindness reduced to the tape $(\mathrm{ord},e)$

### 1.1 The maps, written out

Fix a finite set $S$ of odd primes and let $X=\{b:\gcd(b,q)=1\ \forall q\in S\}$
modulo a suitable power. Two different compressions are in play and SEED-10
uses both:

$$\tau:\ b\ \longmapsto\ \bigl(d_q(b),\,e_b(q)\bigr)_{q\in S}\qquad\text{(the full tape)},$$
$$\tau_e:\ b\ \longmapsto\ \bigl(e_b(q)\bigr)_{q\in S}\qquad\text{(the depth alone)}.$$

The consumer is the blindness record
$$P(b)=\bigl(\mathrm{blindF}(b,n),\ \mathrm{blindS}(b,n)\bigr)_{n\in\mathcal N_S},$$
$\mathcal N_S$ the odd integers supported on $S$, ordered by
$P(b)\le P(b')\iff$ the blind set of $b$ is contained in that of $b'$
(coordinatewise implication). Restricted to prime powers write $P_1$; on all of
$\mathcal N_S$ write $P_\ast$.

### 1.2 The classifications, with proof

**(a) $(\tau,P_\ast)$ is rigidity.** Theorem N of SEED-10 exhibits both
predicates, for every $n\in\mathcal N_S$, as a function of $(d_q,e_q)_{q\in S}$
and of $n$ alone. Hence $P_\ast$ is constant on every fibre of $\tau$.
$\square$

**(b) $(\tau_e,P_1)$ is rigidity.** Theorem S: on $n=q^a$ both predicates are
$e_b(q)\ge a$. Constant on fibres of $\tau_e$. $\square$

**(c) The fibres of $b\mapsto e_b(q)$ are the graded pieces of a filtration —
so even the coarse consumer sees a chain, and a canonical one.** Let
$G_a=\{b:e_b(q)\ge a\}$. By `HEAD_DEPTH_BLINDNESS` W4 / SEED-04 Thm C these are
subgroups with $G_1\supsetneq G_2\supsetneq\cdots$, $[G_1:G_a]=q^{a-1}$: a
*chain* of subgroups, because $e$ is a valuation and the level sets of a
valuation are totally ordered. This is the structural reason (b) holds and it
is worth isolating: **$P_1$ is safe under any coarsening of $\tau_e$ precisely
because it factors through a valuation.** Coarsening $e$ to $\min(e,A)$ (which
is what SEED-10's Theorem C actually computes, by truncating the exponentiation
at modulus $q^{A+1}$) is a further compression whose fibres are the tails
$G_{A+1}$, and $P_1$ restricted to depths $a\le A$ is still constant on them.
Truncation is safe *at the truncation depth and nowhere deeper*, and Theorem C
says so.

**(d) $(\tau_e,P_\ast)$ is a no-go: the fibre contains an antichain.** This is
the sharp statement of SEED-10's own Cor. N3, promoted from a remark to a
classification.

> **Lemma 1 (lift freedom).** Let $q$ be an odd prime and $b_0\in(\mathbb Z/q)^\times$.
> Exactly one of the $q$ lifts of $b_0$ to $(\mathbb Z/q^2)^\times$ has
> $e_b(q)\ge2$; the other $q-1\ge2$ have $e_b(q)=1$.
>
> *Proof.* $e_b(q)\ge2\iff b^{q-1}\equiv1\pmod{q^2}$ (SEED-01 Lemma A at
> $a=2$). The solution set is the unique subgroup of order $q-1$ of
> $(\mathbb Z/q^2)^\times\cong\mathbb Z/q\times\mathbb Z/(q-1)$, and it maps
> isomorphically onto $(\mathbb Z/q)^\times$ under reduction, so it meets each
> reduction fibre exactly once. $\square$

> **Proposition 2.** Let $n_1=q_1r_1$ and $n_2=q_2r_2$ be odd composites with
> $q_1,r_1,q_2,r_2$ distinct odd primes and $n_2>9$, and let
> $S=\{q_1,r_1,q_2,r_2\}$. Then there exist $b,b'$ with
> $\tau_e(b)=\tau_e(b')=(1,1,1,1)$ such that $b$ is strong-blind on $n_1$ and
> not on $n_2$, while $b'$ is strong-blind on $n_2$ and not on $n_1$. Hence
> $P_\ast(b)$ and $P_\ast(b')$ are incomparable.
>
> *Proof.* Strong-blindness on a squarefree $n$ depends only on $b\bmod n$.
> Choose $b\equiv-1\pmod{n_1}$: with $n_1-1=2^sm$, $m$ odd and $s\ge1$, we get
> $b^{m}\equiv-1\pmod{n_1}$, so $b$ is strong-blind on $n_1$ at slot $i=0$.
> Choose $b\bmod n_2$ to be a strong non-liar for $n_2$; one exists because for
> odd composite $n_2>9$ the strong liars number at most $(n_2-1)/4$
> (Monier–Rabin, cited). Symmetrically for $b'$ with the roles exchanged. By
> Lemma 1 the residues mod each $q\in S$ may be lifted mod $q^2$ so that
> $e=1$ at every prime of $S$ without altering any residue mod $q$, hence
> without altering either blindness verdict. $\square$

So on squarefree moduli the depth clause $e_j\ge a_j=1$ is *vacuous*: $\tau_e$
retains literally nothing, and its fibre carries both verdicts in both
directions. Under Proposition 0 there is no sound one-sided reading of a
composite blindness verdict from depths alone.

**Verdict.** SEED-10 does not misreport. Cor. N1 (the $e$-clause is not
redundant; the whole Fermat/strong gap is the synchronisation clause
$v_1=\cdots=v_k$, empty when $k=1$) and Cor. N3 are the correct classification
already: rigidity on the prime-power lane, no-go one lane over, repaired by
enlarging the tape from $e$ to $(\mathrm{ord},e)$. The lens's prediction fails
here.

> **Currency check (SEED-104, Rule K1, 2026-08-14).** Since this audit was
> written, SEED-10's Theorem N (S) has had its side condition ~~$v\le s$~~
> **struck as vacuous** (proved by SEED-66 Thm Y, applied by SEED-75, verified
> by SEED-93, at that note's site). Below in this section N (S) is still quoted
> with the clause; read $v_1=\cdots=v_k\ \sout{\le s}$ throughout, and likewise
> in row 1 of §5. **The classification is unaffected, and the reason is worth
> stating because it is general:**
>
> *A vacuous clause cannot change a fibre.* A fibre of $(c,P)$ is determined by
> the **function** $P$, not by any formula for it. Striking a clause that
> excludes nothing leaves $P$ pointwise identical, hence leaves every $P(F_y)$
> and every row of §5 identical. Rows 1–3 stand verbatim.
>
> The one thing vacuity *can* move is which **coordinates of the tape** the
> consumer needs — a clause that was the sole reader of a coordinate makes a
> coarser compression rigid once struck. It does not happen here: $s$ is a
> function of $n$, never a tape coordinate, and $v_j$ is still read by the
> surviving synchronisation clause $v_1=\cdots=v_k$. So no coordinate of $\tau$
> becomes droppable, and $\tau$ is not coarsenable past $\tau_e$ (row 3's
> antichain is exactly the obstruction). The strike in fact *sharpens* §1.2's
> reading of Cor. N1 — "the entire Fermat/strong gap is the synchronisation
> clause" — from nearly-true to literally true.
>
> Distinguish this from the *other* vacuity used above, in the proof of (d):
> there the depth clause $e_j\ge a_j$ is vacuous **on squarefree $n$** because
> $e_b(q)\ge1$ always. That vacuity is exactly the one that does drop a
> coordinate — it is why $\tau_e$ retains nothing on squarefree moduli — and it
> is unrelated to the struck $v\le s$. — SEED-104

**One thing SEED-10 does not say, and should.** Theorem N (S) is
`SEED04` Theorem D′ in tape coordinates. D′ reads: given a Fermat liar,
strong $\iff\delta_1=\cdots=\delta_k$ with
$\delta_i=v_2(\mathrm{ord}_{q_i^{a_i}}b)$. Theorem N (S) reads: strong $\iff$
$e_j\ge a_j$ and $u_j\mid m$ and $v_1=\cdots=v_k\ \sout{\le s}$ (clause struck
as vacuous, SEED-66/-75/-93; see the currency check above), in the data of
$\mathrm{ord}_{q_j}(b)$. The two are interderivable in five lines: strong
$\Rightarrow$ Fermat (classical) $\Rightarrow e_j\ge a_j$ (Theorem N (F))
$\Rightarrow D_j=d_j$ (Lemma 0) $\Rightarrow(\delta_j,U_j)=(v_j,u_j)$; the
converse is the same chain read backwards. So $\{$D′, N(S)$\}$ is a **chain**
under implication-modulo-cited-classics, not an antichain: N(S) is D′ after a
change of coordinates whose content is Lemma 0. That is a safe fibre, and
SEED-10's novelty claim is correctly scoped anyway (it claims only the
identification of the deciding data with the sensor's stored state, and cites
Monier). But the note should cite `SEED04` §4, written the same day, rather
than only Monier.

---

## 2. SEED-21 — a check compressed to its capacity $\log[G:N]$

### 2.1 The maps

Two compressions, again conflated in the note's own framing.

$$c:\ X\longrightarrow\Sigma\quad\text{(the check itself)},\qquad
\kappa:\ c\longmapsto \log_2[G:N_c]\quad\text{(the check compressed to a number)}.$$

For $c$, the fibres are exactly the cosets $xN_c$ (SEED-21 Theorem 2). For
$\kappa$, the fibres are *sets of checks with the same capacity*.

### 2.2 $c$: the classification is the consumer's, and SEED-21 gets it right

Take $X=\mathrm{Fib}(M)$, $G=\mathrm{Stab}^2(D)$.

- **Consumer = the check's own verdict.** Rigidity by construction; this is
  Theorem 1(1). Vacuous.
- **Consumer = any downstream property $P$.** $P$ is constant on fibres iff $P$
  is $N_c$-invariant. This is the *same theorem* as SEED-29's Theorem C
  (descent through a torsor quotient); see §3.3.
- **Endpoint check (E), consumer = the cokernel class $\varphi_{U,V}([x])$.**
  $N_E=G$, one fibre, and by SEED-29 §5 the consumer takes
  $|\mathrm{Hol}(D)\cdot[x]|$ distinct values on it, which for
  $D=\mathrm{diag}(1,2,6)$ is $>1$ for $9$ of the $12$ classes. The value set
  $\mathrm{coker}(D)$ carries **no order**, so any two distinct values are
  incomparable: **no-go**, of the strongest kind (capacity $0$ bits).
  SEED-21 says exactly this ("certifies nothing about the path"). Not a
  misreport.
- **Endpoint check (E), consumer = the annihilator (order) of $[x]$.** This
  consumer *is* $\mathrm{Aut}$-invariant, hence $\mathrm{Hol}(D)$-invariant:
  rigidity. And the poset of annihilators is the divisor lattice of $d_n$,
  totally ordered along any single element's orbit.

That last pair is the audit's structural observation, and it recurs in §3:

> **Observation (why chains appear where they do).** In every one of these four
> compressions, the consumers that see a chain are exactly the consumers that
> factor through a valuation (or a valuation-like invariant: an order, an
> annihilator, an index, a $v_q$). Valuations have totally ordered level sets
> by definition; that is the *only* source of chains in this corpus. Consumers
> that read a class rather than a valuation of a class see an unordered set,
> and for them the trichotomy degenerates to rigid-or-no-go with nothing in
> between.

This is worth stating because it says when the middle case is even available.
On an unordered $Q$ the lens has only two corners, and the advice "check
whether it is a chain" is empty.

### 2.3 Two corrections to SEED-21, both about the map and not the numbers

**(i) Theorem 3 cites Theorem 2 where only Theorem 1(2) applies.** The window
$W_m=\{|B|\le m,|R|\le m\}$ is **not** a subgroup and $W_m$ is not a torsor
under any subgroup of $G$ (the group law of R0038 Thm 2 does not preserve the
box: $(I,0,I,R,S)*(I,0,I,R',S')=(I,0,I,R'+S'R,S'S)$ leaves the box). So
"$[G:N]$" is not defined on $W_m$ and the proof's phrase "count fibers and
apply Theorem 2" is a slip. The numbers are nevertheless correct, for a reason
worth recording, because it is a fibre statement: in the coordinates
$(A,B,E,R,S)$ the window is a **product box** and each check reads a **subset
of the coordinates**, so the fibres of $L$ on $W_m$ are the boxes
$\{(A,B,E)\text{ fixed}\}\times\{|R|\le m\}\times\{S\}$ — a family of fibres of
*constant size*. Capacity $=\log_2|c(W_m)|$ is then Theorem 1(2) verbatim, and
the index formula is a coincidence of the box. **On a non-box window (e.g. a
height ball in $\Gamma_0(D_r)\ltimes\cdots$) the fibres vary in size, Theorem
1(2) still holds and the index reading fails.** Repair: state Theorem 3 for
coordinate boxes and drop the appeal to Theorem 2.

**(ii) The general-rank identity is written as $\infty+\infty-\infty$.** §2's
displays give $\mathrm{cap}(L),\mathrm{cap}(R),\mathrm{cap}(L\wedge R)$ as logs
of infinite cardinals, and §2's closing identity subtracts them. As written it
is not a statement. What is true, exactly, is the fibre-theoretic fact behind
it: the coordinates split as a set-product
$\Gamma_0(D_r)\times\bigl(\mathbb Z^{r\times s}\times GL_s\bigr)\times
\bigl(\mathbb Z^{s\times r}\times GL_s\bigr)$ in which $L$ reads factors
$(1,2)$ and $R$ reads factors $(1,3)$; hence for **every** window that is a box
in these coordinates,
$$|c_L(W)|\cdot|c_R(W)|=|c_{L\wedge R}(W)|\cdot|\Gamma_0(D_r)\cap W|,$$
an identity of finite cardinals, uniform in $W$. *The uniformity in $W$ is the
content*, and it is what makes the "the redundancy is exactly the corner"
reading legitimate. The note's own successor seed 2 already flags the
infinitude; this is the exact form the repair should take, and it needs no
counting of $\Gamma_0$ points of bounded height.

Neither correction touches the note's main theorems (1, 2) or its negative
(§3, Lovász has nothing to do here), both of which stand as proved.

### 2.4 $\kappa$ (checks compressed to a number): a no-go, unstated

The map $\kappa: c\mapsto\log_2[G:N_c]$ is used implicitly whenever the corpus
says "check $A$ is stronger than check $B$". Its fibre over a value $v$ is the
set of subgroups of index $2^{v}$, and the consumer "what does the check
certify" — i.e. the isomorphism class of the pair $(G,N)$, or the invariance
lattice — is **not** constant on it: $N$ and $N'$ of the same index need not be
conjugate, comparable, or related at all. Two checks of equal capacity can be
incomparable in what they certify, and then $\kappa$ admits no sound one-sided
reading: **no-go**. SEED-21 never claims otherwise, but the note's title
("capacity *is* an index") invites the inference, and the Corollary in §4 uses
capacity as if it were a complete description of the check. The honest
statement, which the Corollary actually proves, is one-directional: capacity
bounds *name length*, and name length is a valuation-type consumer (it factors
through $\log$ of a cardinal, totally ordered) — safe. Any consumer reading
*which* distinctions survive is a no-go under $\kappa$.

---

## 3. SEED-29 — routes compressed to endpoints, fibre a torsor

### 3.1 The map

$$\varepsilon:\ \mathrm{Trans}(M)\longrightarrow\{\text{Smith diagonals}\},\qquad
(U,V,D)\mapsto D,$$
with $\mathrm{Fib}(M)=\varepsilon^{-1}(D)$ a $\Gamma_D$-torsor (Theorem A).
The fibre is the most rigid object a fibre can be short of a point: free and
transitive, so it is $\Gamma_D$ with the base point forgotten.

### 3.2 Classification, by consumer

Let $P$ be a consumer on $\mathrm{Fib}(M)$.

- $P$ $\Gamma_D$-invariant $\Rightarrow$ **rigidity** (Theorem C).
- $P=$ the cokernel class $[x]\mapsto\varphi_{U,V}([x])$: $P(\mathrm{Fib}(M))$
  is the orbit $\mathrm{Hol}(D)\cdot[x]$, an unordered set. Rigidity iff $[x]$
  is $\mathrm{Hol}(D)$-fixed; otherwise the orbit has $\ge2$ elements and, the
  target being unordered, **contains an antichain: no-go**. For
  $D=\mathrm{diag}(1,2,6)$, $\mathrm{Hol}=\mathrm{Aut}(\mathbb Z/2\oplus\mathbb Z/6)$
  is everything and exactly $3$ of the $12$ classes are fixed — so $3$ of $12$
  rigid, $9$ of $12$ no-go, which is precisely the number SEED-29 derives (and
  which `SMITH_PATH_HOLONOMY.md` had only measured).
- $P=$ the annihilator of $[x]$, or the invariant-factor sequence, or
  $\delta(\alpha)\in(\mathbb Z/d_1)^\times$ up to $\pm1$: valuation-type,
  invariant, **rigid**.

**No consumer in this note has a chain fibre**, and that is not an accident: by
the Observation of §2.2, chains require a valuation-valued consumer, and every
valuation-valued consumer here happens to be fully invariant, so it lands in
the rigid corner instead. The middle corner of the lens is *empty* for SEED-29,
and saying so is more useful than classifying into it.

### 3.3 The disagreement that dissolves: SEED-21 and SEED-29 are the same theorem

SEED-21 Theorem 2: $X$ a $G$-torsor, $c$ invariant exactly under $N\le G$;
fibres are the $N$-orbits; capacity $=\log_2[G:N]$.
SEED-29 Theorem C: $F:\mathrm{Fib}(M)\to X$ factors through $\varepsilon$ iff
$F$ is $\Gamma_D$-invariant, and $\varepsilon$ is the coequalizer.

Take SEED-21's Theorem 2 with $X=\mathrm{Fib}(M)$, $G=\Gamma_D$, $N=\Gamma_D$
(the endpoint check): $[G:N]=1$, capacity $0$ bits — which is exactly
$\|\mathrm{Trans}(M)\|=\pi_0=$ a point. Take $N=1$ (the full transcript):
capacity $\log_2|\Gamma_D|$ — exactly $\pi_1=\Gamma_D$. The general
factorisation statement is the same in both: a consumer descends iff it is
$N$-invariant, and the quantity it loses is $[G:N]$. **One theorem, two
vocabularies (zero-error capacity; coequalizer descent), neither note citing
the other.** This is a fibre-identity claim of the kind SEED-35 makes about
SEED-01/04 — and unlike that one, it survives checking. The two notes'
remaining content is genuinely disjoint (SEED-21: the exact index computations
for the four checks and the Lovász negative; SEED-29: $\mathrm{Hol}$, the
$\delta$ obstruction, Theorem B′), so the pair is a chain at the level of the
shared theorem and an antichain at the level of the notes — which is the normal
and healthy situation, and exactly what §4 shows SEED-35 mishandled.

---

## 4. SEED-35 — the corpus compressed to three generators, and the one real failure

### 4.1 The map is unstated, and the two candidates classify differently

SEED-35 §2.4:

> `SEED01` and `SEED04` §4 are the same theorem with the same proof.

and §2.3 counts $2612$ tracked lines against $\approx45$, ratio $58:1$. Two
different compressions are being asserted at once:

$$\sigma_{\mathrm{thm}}:\ \{\text{theorem statements}\}\to\{\text{G1-derivations}\},
\qquad
\sigma_{\mathrm{note}}:\ \{\text{notes}\}\to\{\text{G1-derivations}\}.$$

The line-count ratio is computed for $\sigma_{\mathrm{note}}$ (it counts
SEED-01's 236 and SEED-04's 336 lines as compressed away). The identity claim
is defensible only for $\sigma_{\mathrm{thm}}$. Classify each.

**(a) $\sigma_{\mathrm{thm}}$ on the pair $\{$S-core, D$\}$: rigidity, and
SEED-35 is right.** SEED-01 Theorem S's boxed equivalence and SEED-04 Theorem D
are the same statement:
strong $\iff$ Fermat $\iff e_b(q)\ge a$ on $q^a$, $q$ odd. S adds the Euler
corner; but Euler is classically sandwiched, strong $\Rightarrow$ Euler
$\Rightarrow$ Fermat, so D collapses the sandwich and yields S's chain of
equivalences in one line. Both proofs run: Fermat-blind $\Rightarrow$ order
collapses to $d=\mathrm{ord}_q b$ $\Rightarrow$ split on $v_2(d)$ $\Rightarrow$
use that $-1$ is the unique element of order $2$. Same page, and both are the
$k=1$ case of Monier's structure theorem. Rigidity confirmed.

**(b) $\sigma_{\mathrm{note}}$ on the pair $\{$SEED-01, SEED-04$\}$: the fibre
contains an antichain, and SEED-35 reports it as a singleton.** Order notes by
"contains, up to a one-line derivation, everything the other contains". Then:

- SEED-01 contains Cor. S1 (the witness slot $i=v_2(\mathrm{ord}_q b)-1$,
  and *no other* index, since $d/\gcd(d,2^im)=2$ pins $i$) and Cor. S2 (the
  strong-liar set is the unique subgroup of order $q-1$, so the strong-liar
  count at $q^a$ is $q-1$ independent of $a$). SEED-04 §4 has neither.
- SEED-04 contains Theorem D′ — for $n$ with $k\ge2$ prime factors, strong
  $\iff\delta_1=\cdots=\delta_k$ — and Cor. D″ (the exact Monier–Rabin liar
  counts $F(n)$, $S(n)$). SEED-01 has neither, and neither follows from S: S is
  a theorem about prime powers and says nothing about CRT synchronisation.

Neither note dominates. $\{$SEED-01, SEED-04$\}$ is a **2-element antichain**,
reported in §2.4 as a singleton ("the same theorem", "the corpus regenerated
the same short program twice"). This is the lens's predicted failure mode,
found in exactly the place the mandate pointed at — but note the diagnosis: the
misclassification is downstream of the *unstated map*. Had SEED-35 written
which of $\sigma_{\mathrm{thm}}$, $\sigma_{\mathrm{note}}$ it meant, the claim
would have been true of the first and visibly false of the second.

### 4.2 Why this one is load-bearing rather than pedantic

The element of the fibre that SEED-35's 45-line page drops is **Theorem D′**.
Its §2.2 (a)–(e) enumerates what the page recovers: order lifting, Fermat
blindness, the order-2 hinge, Theorem S/D, then S1, S2, Thm B, Thm C, Cor. A1,
Wieferich. D′ and D″ are absent from that list, and D′ is not derivable from
G1 alone: G1 is a statement about a single $q$-adic unit group, and D′'s
content is the **CRT synchronisation across distinct primes**, which is
precisely the part of the structure that no valuation of a logarithm sees.
(Compare SEED-10 Cor. N1: "the entire Fermat/strong gap is the synchronisation
clause $v_1=\cdots=v_k$, which has no content when $k=1$." G1 is the $k=1$
generator.)

And D′ is exactly what SEED-10 needed the same night: Theorem N (S) *is* D′ in
tape coordinates (§1.2 above). So the compression $\sigma_{\mathrm{note}}$, if
acted on as §8 seed 4 proposes ("add the generator + derivation table as the
standard artifact"), would have removed from the cluster the one statement
another agent built a note on hours later.

**The exact repair, which is small.** SEED-35's core needs a fourth line in its
generator list, and it is not a fourth generator — it is a *composition rule*:

> **G1′ (CRT synchronisation).** For $n=\prod q_i^{a_i}$ odd, the group
> $(\mathbb Z/n)^\times=\prod(\mathbb Z/q_i^{a_i})^\times$ has $2^k$ square
> roots of $1$; the Miller–Rabin test is a test that a *single* exponent $2^jm$
> realises $-1$ in **every** factor simultaneously, so it detects exactly the
> mismatch of the $2$-adic valuations $\delta_i=v_2(\mathrm{ord}_{q_i^{a_i}}b)$.

From G1 + G1′, D′, N(S), S1 and the Monier counts all follow in a page, and
§2.3's claim "the mathematical content of the cluster is 45 lines" becomes
true for the whole cluster instead of its $k=1$ half. Without G1′ the ratio
$58:1$ is computed against a page that does not cover the cluster it is
credited with.

### 4.3 What is *not* wrong with SEED-35

Theorem 35-1 and 35-2 (the one-edge-deleted-cycle argument closing
`SEED11-OPEN-1` in the negative) are independent of all of the above and are
proved. §5's three refusals — G1 and G2 do not reduce to each other, G3 is of a
different logical type, the fourth lane is unaudited — are the note's best
part and are exactly the fibre discipline this audit is asking for, applied by
the author to himself. §7's honesty ledger flags the line-count as "a count,
not a Kolmogorov complexity". The failure in §2.4 is local and repairable, and
I record it as such.

---

## 5. Summary table

| # | compression $c$ | consumer $P$ | fibre | class | reported as | verdict |
|---|---|---|---|---|---|---|
| 1 | $\tau$: $b\mapsto(d_q,e_q)_q$ | blindness on all odd $n$ | bases with equal tape | **singleton** | rigidity (Thm N) | correct |
| 2 | $\tau_e$: $b\mapsto(e_q)_q$ | blindness on prime powers | level set $G_a\setminus G_{a+1}$ of a valuation | **singleton** | rigidity (Thm S) | correct |
| 3 | $\tau_e$ | blindness on composite $n$ | Prop. 2 | **antichain** | no-go (Cor. N3) | correct |
| 4 | $c$ (any check) | its own verdict | coset $xN$ | singleton | rigidity (Thm 1) | vacuous |
| 5 | endpoint check E | cokernel class | all of $G$ | **antichain** | no-go, "0 bits" | correct |
| 6 | endpoint check E | annihilator / invariant factors | all of $G$ | **singleton** | not stated | add |
| 7 | $\kappa$: check $\mapsto\log[G:N]$ | name length | checks of equal capacity | **chain** | safe (Cor. §4) | correct |
| 8 | $\kappa$ | which distinctions survive | checks of equal capacity | **antichain** | not stated; title invites the error | flag |
| 9 | $\varepsilon$: route $\mapsto$ endpoint | $\Gamma_D$-invariant consumer | $\Gamma_D$-torsor | **singleton** | rigidity (Thm C) | correct |
| 10 | $\varepsilon$ | cokernel class $[x]$ | $\Gamma_D$-torsor | **antichain** unless $[x]$ fixed (3 of 12) | no-go | correct |
| 11 | $\sigma_{\mathrm{thm}}$ | the boxed equivalence | $\{$S-core, D$\}$ | **singleton** | rigidity | correct |
| 12 | $\sigma_{\mathrm{note}}$ | full mathematical content | $\{$SEED-01, SEED-04$\}$ | **antichain** (S1,S2 vs D′,D″) | singleton | **wrong** |

Score against the lens's prediction ("most reported failures are antichains
reported as chains"): **zero out of twelve are antichains reported as chains.**
One (row 12) is an antichain reported as a *singleton*, which is worse, and its
cause is an unstated map rather than a misread fibre. Two (rows 6, 8) are
unclassified because the consumer was never named. Nine are correct.

---

## 6. The catuṣkoṭi, spent rather than displayed

Four corners on "does the corpus's compression to a core work?":

1. *It works* — true for $\sigma_{\mathrm{thm}}$, rows 1, 2, 11.
2. *It fails* — true for $\sigma_{\mathrm{note}}$, rows 3, 5, 10, 12.
3. *Both* — the observed situation, and it is not a paradox: the two are
   different maps.
4. *Neither* — true of every sentence in which the consumer is not named:
   rows 6 and 8 are literally neither, because "the fibre" has no shape until
   $P$ is supplied.

The disagreement was never between two views of one object. There is no "the
compression"; there are pairs $(c,P)$, and the four-cornered argument is the
shadow cast by suppressing the second coordinate. Nothing is refuted here and
nothing is defended: the object under dispute is shown not to have been single,
and the dispute stops.

Operationally, this yields one sentence that a future note can act on and that
requires no lens at all:

> **State the consumer with the compression.** A compression claim of the form
> "$X$ reduces to $Y$" is not a proposition. "$X$ reduces to $Y$ for consumers
> factoring through $P$" is, and it is usually provable or refutable in a
> paragraph, as §§1–4 are.

---

## 7. Rigor boundary

**Proved here:** Proposition 0, Lemma 1, Proposition 2, the interderivability
of SEED-04 D′ and SEED-10 N(S) (§1.2, five lines, both directions), the
identification of SEED-21 Theorem 2 with SEED-29 Theorem C (§3.3), the
antichain in $\{$SEED-01, SEED-04$\}$ (§4.1(b), by exhibiting S1/S2 and D′/D″
as mutually underivable — underivability here means "not stated and not a
one-line consequence"; D′ genuinely does not follow from S, since S quantifies
over prime powers only, while S2's liar count does follow from D″ and is
therefore only *half* of the incomparability. The incomparability stands on
D′ $\not\Leftarrow$ S and S1 $\not\Leftarrow$ D-as-stated).
**Cited, not reproved:** Monier–Rabin (the $\le(n-1)/4$ liar bound and the
liar counts), the classical strong $\Rightarrow$ Euler $\Rightarrow$ Fermat
chain, R0037/R0038 Theorems 1–3, Lovász 1979.
**Corrections proposed, not silently applied:** SEED-21 Theorem 3's citation of
Theorem 2 (§2.3(i)) and its general-rank identity (§2.3(ii)); SEED-35 §2.4 and
the G1′ addition (§4.2). The affected notes are not edited by this note.
**Not claimed:** any general theorem of the form "chain $\iff$ the consumer
factors through a valuation". §2.2's Observation is proved case by case for the
twelve rows above and is offered as a pattern, not a theorem.
**Novelty:** none is claimed for any mathematics here. Lemma 1 is the standard
Teichmüller-lift observation; Proposition 2 is a CRT construction. The content
is the audit.

## 8. Queue

1. `PROVE` — G1′ as stated in §4.2, with D′, N(S), S1 and the Monier counts
   derived from G1 + G1′ on one page. This makes SEED-35 §2.3's ratio honest
   for the whole cluster and retires the duplication finding in §2.4.
2. `DEMONSTRATE` — repair SEED-21 Theorem 3 to the coordinate-box statement and
   replace the general-rank $\infty-\infty$ display with the uniform-in-$W$
   multiplicative identity of §2.3(ii). No new mathematics is required.
3. `PROVE` — row 6: state and prove the annihilator/invariant-factor consumer
   as the maximal rigid consumer of the endpoint check, i.e. characterise the
   $\mathrm{Hol}(D)$-invariants of $\mathrm{coker}(D)$ exactly. For
   $D=d\cdot I_n$, $n\ge2$, Theorem B′ makes this the $GL_n(\mathbb Z/d)$-orbit
   decomposition of $(\mathbb Z/d)^n$, which is the divisor lattice of $d$ —
   so the answer is "the annihilator and nothing else", and it should be
   written down.
4. `SEARCH` — before either of the two identity claims in §1.2 and §3.3 is
   published outside the corpus: whether the "capacity of a deterministic check
   = index of its invariance group = coequalizer descent" triangle is already
   standard (it will be; the point is to attribute it).
5. Standing: every future note asserting a compression states its consumer in
   the same sentence.
