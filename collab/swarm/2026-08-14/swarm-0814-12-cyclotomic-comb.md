---
from: swarm-0814-12
date: 2026-08-14
type: theorem
object: the cyclotomic comb — bounded teeth, unique decomposition, multiplicative chart depth
formal: formal/cubical/Swarm/S12CyclotomicChain.agda  (agda --cubical --safe, EXIT=0)
answers: R0025 successor seeds 2 and 3
---

# The cyclotomic comb

## 0. What I drew, and where the two lenses disagree

Draw: `0013-codex-global-cyclotomic.md`, `data/liouville_weights_40.npy`,
`code/exp8_adelic.py`, `machinery/ported_twelve_step_compiler.py`,
`code/exp22_kbody.py`, `R0002/…boundary-refutation.json`,
`figures/exp14_fresnel.png`, `0259-codex-lyra-constructor-grammar-…`,
`runtime/crystallize/antiunify.py`, `R0006/…blind-breaker.json`,
`R0025-cyclotomic-sensor-bounded-chart.md`.
Frontier field: quantum information (channel capacities, combs).
Ancient field: Sunzi and the dàyǎn qiúyī tradition, Qin Jiushao.
Lenses: **Mahāvīra** (classify the problem types exhaustively, then solve
the classification) and **Euler** (compute boldly, then find why the
computation was allowed).

R0025 asks whether the observation depth of an arithmetic sensor is
coupled to the size of the answer it returns. The two lenses give
**opposite verdicts on the same function**, and that disagreement is the
whole assignment.

*Euler's answer — decoupled.* Take $v_p(a^n-1)$ as the thing to compute.
Lifting-the-exponent gives $e+v_p(n)$ on $d\mid n$; the supremum over $n$
is infinite, while R0025 Theorem 2 proves the base chart depth is the
fixed finite $K=e+1$. So depth and answer come apart, and the *reason it
was allowed* is that $F(p,a)=\{a^n-1\}$ is not closed under the
perturbations $b\mapsto b+p^k$ that the generic lower bound needs. This
is exactly R0025 clause (3), and it is correct.

*Mahāvīra's answer — coupled.* Do not compute on $n$ at all. Classify
$n$ by its position in the divisor lattice relative to $(d,p)$. The types
are: (i) $d\nmid n$; (ii) $n=d$; (iii) $n=dp^k$, $k\ge1$; and *nothing
else carries $p$-adic content*. Solve the classification and every type
returns an answer bounded by $K$. On this indexing depth $\ge$ answer
holds, with no perturbation argument needed.

Both are right about different functions. The object below is the exact
bridge, and it settles R0025's own successor seed: *"state the sensor law
directly for $v_p(\Phi_m(a))$; the indicator $[d\mid n]$ should disappear
into the indexing, which would confirm the cyclotomic chart is the
correct one."* It does, and it is.

## 1. The object

Fix an odd prime $p$ and $a\in\mathbb Z$ with $p\nmid a$. Let
$d=\operatorname{ord}_p(a)$ and $e=v_p(a^d-1)\ge1$.

> **Theorem (cyclotomic comb).**
> $$v_p(\Phi_n(a))=\begin{cases} e & n=d\\ 1 & n=dp^k,\ k\ge1\\ 0&\text{otherwise.}\end{cases}$$
> Consequently $\sup_n v_p(\Phi_n(a))=\max(e,1)=e<K=e+1$, while
> $\sup_n v_p(a^n-1)=\infty$. Moreover the sequence $(e,1,1,1,\dots)$ is
> the **unique** sequence of local contributions compatible with the
> lifting-the-exponent totals.

For $p=2$ and $a$ odd the same statement holds with a two-term head:
$d=1$, and the teeth are $(e_-,e_+,1,1,\dots)$ where $e_-=v_2(a-1)$,
$e_+=v_2(a+1)$; the partial sums reproduce
$v_2(a^n-1)=e_-+e_++v_2(n)-1$ for $n$ even. R0025's preservation ledger
records the $p=2$ branch as "genuinely different in shape". On the
cyclotomic chart it is not: it is the same comb with a head of length 2
instead of 1. That is the Mahāvīra classification, and it is exhaustive
— every prime yields a tooth sequence that is a head of length 1 or 2
followed by the constant 1.

## 2. Proof

Four classical inputs, then one induction which is the formal module.

**(C1)** $x^n-1=\prod_{m\mid n}\Phi_m(x)$ in $\mathbb Z[x]$; hence
$v_p(a^n-1)=\sum_{m\mid n}v_p(\Phi_m(a))$. Additive, no defect.

**(C2)** *(support)* If $p\mid\Phi_m(a)$ then $m=dp^i$ for some $i\ge0$.
Classical: $p\mid\Phi_m(a)\Rightarrow p\mid a^m-1\Rightarrow d\mid m$;
and if $m\ne d$ then $a$ is a repeated root of $x^m-1$ mod $p$, forcing
$p\mid m$, and iterating gives $m/d$ a power of $p$.

**(C3)** *(LTE, = R0025 Theorem 1)* For $d\mid n$,
$v_p(a^n-1)=e+v_p(n)$.

**(C4)** *(chain arithmetic)* $d\mid p-1$ so $p\nmid d$. The divisors of
$n=dp^{\,j}$ lying in the support (C2) are exactly $dp^0,\dots,dp^{\,j}$
— a **totally ordered chain** of length $j+1$ — and $v_p(dp^{\,j})=j$.

Now write $g(k)=v_p(\Phi_{dp^k}(a))$. By (C1)+(C2)+(C4), the total over
the first $j+1$ teeth is $\sum_{k\le j}g(k)=v_p(a^{dp^j}-1)$, which by
(C3)+(C4) equals $e+j$, for **every** $j\ge0$. The theorem's tooth
values, and their uniqueness, are then a two-line induction over $j$:

- `lteFromCyc  : ∀ e j → chain (cyc e) j ≡ e + j`
- `cycUnique   : ∀ g e → (∀ j → chain g j ≡ e + j) → ∀ k → g k ≡ cyc e k`
- `cycBound    : ∀ e k → cyc e k ≤ suc e`
- `chainGrows  : ∀ e j → j ≤ chain (cyc e) j`
- `lteFromCyc₂ : ∀ e₋ e₊ j → chain (cyc₂ e₋ e₊) (suc j) ≡ (e₋ + e₊) + j`
- `cyc₂Bound   : ∀ e₋ e₊ k → cyc₂ e₋ e₊ k ≤ suc (e₋ + e₊)`

in `formal/cubical/Swarm/S12CyclotomicChain.agda`,
`--cubical --guardedness --safe --no-import-sorts`, no postulates, no
holes, **EXIT=0**. `cycUnique` is the load-bearing one: it derives the
value $1$ at every $k\ge1$ from the totals rather than importing a
second cyclotomic theorem, so the only arithmetic assumed is
(C1)–(C4).

*Worked check.* $p=11$, $a=2$: $d=10$, $e=v_{11}(1023)=1$.
$\Phi_{10}(2)=16-8+4-2+1=11$, so the head tooth is $1=e$. ✓
$v_{11}(2^{110}-1)=e+v_{11}(110)=2$, and the support divisors of $110$
are $\{10,110\}$: teeth $1+1=2$. ✓ Wieferich case $p=1093$, $a=2$:
$d=364$, $e=2$, head tooth $2$, all later teeth $1$.

## 3. Corollary A — the chart depth multiplies (dàyǎn qiúyī)

This answers R0025 successor seed 3 ("does the compiled Euclidean batch
gcd extend to a composite-modulus sensor?") exactly, and in the
affirmative.

> **Corollary.** Let $m=\prod_i p_i^{\,a_i}$ with $p_i\nmid a$, and let
> the $m$-sensor be the function
> $n\mapsto\bigl(v_{p_i}(a^n-1)\bigr)_i$. The least $M$ such that
> $a\bmod M$ determines it is
> $$M=\prod_{p\mid m}p^{K(p)},\qquad K(p)=\begin{cases}e_p+1&p\text{ odd}\\ e_-+e_+&p=2.\end{cases}$$

*Proof.* Sufficiency: $a'\equiv a\ (M)$ implies $a'\equiv a\
(p^{K(p)})$ for each $p$, so R0025 Theorem 2 pins each component.
Necessity: if $M'$ is deficient at $p$, i.e. $v_p(M')<K(p)$, then by CRT
choose $a'$ with $a'\equiv a$ mod $M'$ and $a'\equiv$ (R0025's blocking
base) mod $p^{K(p)}$; the coprimality of the moduli makes the
perturbation at $p$ free of the other components. $\square$

This is the Sunzi shape exactly: **independent per-prime charts,
recombined multiplicatively, with zero interaction defect**. The
repository already has the Indian sibling of the recombination step
formalised (`formal/cubical/KuttakaValli.agda`, Āryabhaṭa's *vallī*);
what the Chinese side contributes here is the *statement about the
moduli* rather than the algorithm — Qin Jiushao's dàyǎn qiúyī is
organised around which moduli may be combined and at what cost, and the
non-coprime case is where a defect appears. The exact defect law: for
moduli $M_1,M_2$ the recombined chart is $\operatorname{lcm}$, so the
information defect is exactly $\log\gcd(M_1,M_2)$ — **always
$\ge 0$, never negative**.

## 4. Corollary B — no homometric ambiguity on the chain (QIT lens)

The frontier field pays here. Read the divisor chain
$d, dp, dp^2,\dots$ as a **comb**: slot $k$ contributes $g(k)$, and the
observable totals are the partial sums. `cycUnique` says the comb is
**tomographically complete from its chain marginals**: the family of
totals $\{v_p(a^{dp^j}-1)\}_{j\ge0}$ determines every individual slot,
with no residual ambiguity.

That is not automatic, and my own draw contains the counterexample.
`code/exp8_adelic.py` item (4) is built on the homometric pair
$\{0,1,2,6,8,11\}$ and $\{0,1,6,7,9,11\}$: two distinct sets with
*identical* autocorrelations — the phase problem. The structural reason
the comb escapes it is exact and worth stating as the invariant:

> The divisor-chain transform $g\mapsto(\sum_{k\le j}g(k))_j$ is
> **triangular with unit diagonal**, hence invertible over $\mathbb Z$
> with an integral inverse. The difference-multiset transform behind
> homometry is not.

So exp8's item (4) — symmetrisation restores injectivity — and this
corollary are the same question with opposite answers, and the
discriminant is total order, not size. In quantum-information terms:
the classical residue comb is perfectly additive and never
superadditive; the defect law of §3 is $\log\gcd\ge0$ in every case, so
nothing resembling superactivation is available on this chart. That is a
**precisely stated obstruction**: any attempt in this corpus to gain
information by tensoring residue charts is blocked by the triangularity
above, and the place to look for a genuine non-additivity is a lattice
that is not a chain.

## 5. Reconciliation with R0025 clause (3)

R0025(3) says the depth-equals-answer coupling "fails on the family
$F(p,a)$". True and unchanged. What is now exact is *why*: the failure
is a chart artefact. The unbounded answer $e+v_p(n)$ is a partial sum of
$v_p(n)+1$ teeth each $\le e$, and

$$K \;=\; e+1 \;=\; 1+\sup_n v_p(\Phi_n(a)),$$

so on the cyclotomic chart the observation depth is exactly one more
than the largest answer the sensor can ever return. `cycBound` is that
inequality; `chainGrows` is the unboundedness it coexists with. Nothing
in R0025 is weakened; its clause (3) is re-derived with the constant it
was missing.

## 6. Contradictions with conspicuous documents (reporting obligation)

1. **R0025's replay instruction is now unexecutable.** The claim's audit
   section prescribes `python3 -m unittest machinery.test_cyclotomic_sensor_audit`
   as the fresh replay, and its Evidence section is two `.py` files.
   `CLAUDE.md` (owner, 2026-08-13) bans Python repo-wide and enforces the
   ban with a tool hook, a pre-commit hook, and CI. A claim whose only
   named verification path is a banned command has, as of yesterday, no
   verification path. The present module replaces the load-bearing part
   — the tooth values and their uniqueness — with a checked term, which
   is the substitution `CLAUDE.md` §"The substrate" asks for.

2. **`code/exp22_kbody.py` prints a fitted slope whose value it derives
   in its own docstring.** It reports `measured slope … (predicted
   -(k-1)/2)` after stating the stationary-phase derivation that forces
   $-(k-1)/2$. This is the exact pattern `CLAUDE.md` forbids: a
   derivable exponent measured over one decade. The docstring is the
   result; the run is decoration. Same for the "coherent fraction"
   log-log fit.

3. **`R0002`'s refutation and `0013`'s claim sit in tension unless the
   quantifier is read carefully.** `0013` states
   $\Phi_m\mid F_X\iff(X,m)=(3,2),(11,6)$ "for real $X$", with tie
   intervals $3\le X<5$, $11\le X<13$; `R0002`'s blind-breaker refutes
   the unqualified all-real-$X$ form because for $X<2$ the prefix
   polynomial is zero and everything divides it. The two are compatible
   only with $X\ge2$ attached. `0013` does not carry that hypothesis in
   its displayed formula.

4. **`machinery/ported_twelve_step_compiler.py` is the one drawn `.py`
   whose content is a theorem, not a measurement** — `respond`/`decode`
   are mutually inverse bijections $\{0,1\}^n\leftrightarrow$
   $\{\sum b_k3^k\}$, i.e. the level-$n$ Cantor coding, exact and
   positional (the same recombination shape as §3). Its `main` then
   prints `hours in twelve Julian years`, which is numerology attached
   to a correct lemma. Recorded so that a later reader keeps the lemma
   and drops the ornament.

## 7. Prior art (searched before writing, per protocol)

The cyclotomic form of LTE — $p\mid\Phi_n(a)$ iff $n=dp^k$, with
$v_p(\Phi_{dp^k}(a))=1$ for $k\ge1$ — is classical (Zsigmondy's
apparatus; Nagell; Roitman, *On Zsigmondy primes*, 1997; Bang 1886).
**No novelty is claimed for the Theorem.** R0025 already registers
`novelty: known` for the surrounding sensor material and its own prior-art
search found no LTE occurrence elsewhere in this corpus. What is new
*here* is (a) the derivation of the tooth values from the totals alone
via `cycUnique`, which removes one classical input from the dependency
list; (b) the depth formula $M=\prod p^{K(p)}$ of §3 with its CRT
necessity proof, which R0025 listed as an open `PROVE`; (c) the
triangularity invariant of §4 and the resulting obstruction. None of
(a)–(c) is asserted as novel against the literature; (b) and (c) are
asserted as *new to this corpus*, which is a bounded claim.

## 8. Successor queue

- `PROVE` §4's obstruction is stated for chains. Give the exact
  characterisation of finite posets $P$ for which the zeta transform
  $g\mapsto\sum_{q\le p}g(q)$ has an integral inverse of bounded
  coefficient size — the divisor lattice of a general $n$ is not a
  chain, and R0025 seed 1 (families $a^n-b^n$, $\Phi_m(a)$) lands there.
- `PROVE` The $\log\gcd$ defect law of §3 in the non-coprime
  (Qin Jiushao) case, stated as a capacity identity rather than a
  counting remark, and formalised.
- `SEARCH` Whether the depth formula $M=\prod p^{K(p)}$ appears in the
  literature on the *base* chart (as opposed to the exponent chart) for
  Wieferich-type conditions.

## 9. Seeder appends, and two defects in the seeder itself

Appended (mandatory step): to `frontier_fields.txt`, *phase retrieval and
homometry* (met via `code/exp8_adelic.py` item 4 and
`figures/exp14_fresnel.png`; §4 above is about exactly this and the list
lacked it). To `method_lenses.txt`, *Plotkin* (met via
`runtime/crystallize/antiunify.py`, whose thesis — the consistent
variable map, not the pattern, is what separates a theorem from a
falsehood — is a method and not in the list) and *Zsigmondy* (the
primitive-part lens, which is the lens the object in §1 is written
under).

Two defects found while doing it, reported rather than silently fixed:

1. **`seed.sh` draws its own comments.** `draw()` is
   `shuf -n "$1" … "$2"` over the raw file, with no comment filter, while
   all three list files carry `#` headers and footers — currently 4, 3
   and 20 lines. So a `method lens` draw returns a comment fragment with
   probability $20/183\approx11\%$, and a two-lens draw contains at least
   one with probability $\approx21\%$. An agent drawing
   "`#    read 115 as licensing EXACT symbolic cases only.`" as a method
   lens gets no lens, and the failure is silent. One-line fix:
   `grep -v '^#' "$2" | shuf -n "$1" …`. Not applied here — `seed.sh` is
   not my file.

2. **These files are not safe to edit non-atomically during a swarm.**
   My append was correct; my subsequent *reposition* of the two lines
   above the footer read the file, rewrote it, and in the interval
   another agent appended one line, which my rewrite then dropped. The
   file grew 151 → 183 lines during my session. I cannot recover the lost
   line's text (it was an uncommitted working-tree append, so it exists
   in no object store). **If you appended a lens to
   `random_entry_seeder_so_agents_dont_cluster/method_lenses.txt` on
   2026-08-14 and it is missing, this is why — please re-append.**
   The safe protocol for these three files is append-only, single
   `>>` per agent, never read-modify-write.
