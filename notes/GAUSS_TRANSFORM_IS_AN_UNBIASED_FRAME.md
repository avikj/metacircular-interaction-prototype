# D0026 §5.7's obstruction under its standard name: the Gauss transform is a flat (unbiased) frame

**SEARCH discharge, 2026-08-17.** PROTOCOL §0: *search under the standard name
for the object, not the one we coined.* D0026 §5.7 coins "the spectral
change-of-basis obstruction" and states it correctly. The object has a standard
name, the corpus has never used it — `mutually unbiased` occurs **zero** times
in the tree — and the standard name carries a quantitative form the coined name
does not.

Nothing here is new mathematics. Everything in §2 is ↳ (inherited). §3 is the
part that is *not* a citation and is marked accordingly.

---

## 1. What §5.7 says

> Multiplicative characters diagonalize multiplication; additive characters
> diagonalize translation. These generate a nonabelian affine action and do not
> admit a naive common scalar eigenbasis. … Parseval gives no free $L^2$ gain
> from this basis change.

with the intertwiner named as the finite Gauss transform
$\mathcal G_e(\chi,m)=\sum_{u\in(\mathbb Z/e)^\times}\chi(u)e(mu/e)$.

Both sentences are right. The second is stated as an *absence* — no gain — and
absences do not have exponents. Under the standard name it becomes a *floor*,
which does.

## 2. The standard name and the exact statement ↳

For $\chi$ primitive mod $e$ and $\gcd(m,e)=1$,
$$\mathcal G_e(\chi,m)=\bar\chi(m)\,\tau(\chi),\qquad |\tau(\chi)|=\sqrt e .$$
So **every** entry of the Gauss transform, on the primitive-$\chi$ /
coprime-$m$ block, has the *same modulus* $\sqrt e$. A change of basis all of
whose entries have constant modulus is the definition of an **unbiased** pair;
the textbook case is mutually unbiased bases (MUB), where Fourier and standard
bases of $\mathbb C^N$ have overlaps of modulus $N^{-1/2}$.

That flatness *is* "Parseval gives no free $L^2$ gain," and it is stronger than
no-gain: an unbiased transform is the extremal case, the one that maximally
delocalizes. Concentration in one basis forces spread in the other, with an
exponent — this is the finite uncertainty principle, and the corpus already has
"formulate a finite uncertainty principle in the Hahn/Ramanujan phase space" as
an owner-side target (`chatgptdump.md` L3679, `PRIME_PAIR_FIELD_AGENT_HANDOFF`
L3643) without connecting it to §5.7.

**The caveat that makes this not a one-line citation, and it is the mathematical
point.** The two sides are not both bases:

- the multiplicative characters are an orthogonal **basis** of
  $L^2((\mathbb Z/e)^\times)$, dimension $\varphi(e)$;
- the additive characters $u\mapsto e(mu/e)$ *restricted* to
  $(\mathbb Z/e)^\times$ are $e$ vectors in a $\varphi(e)$-dimensional space —
  an overcomplete tight **frame**, not a basis. At $e=p$ prime that is $p$
  vectors in dimension $p-1$; the $m=0$ vector is all-ones.

So the textbook MUB entropic uncertainty principle (Maassen–Uffink,
$H_1+H_2\ge\log N$) does **not** apply verbatim. The needed statement is its
frame version. Second caveat: flatness holds on the **primitive $\chi$,
coprime $m$** block only. Imprimitive $\chi$ or $\gcd(m,e)>1$ degenerate the
Gauss sum — it can vanish — so for composite $e$ the transform is flat on a
sublocus and degenerate off it. D0026 works at "critical moduli," i.e. exactly
where compositeness is live, so this is not a footnote.

**Searched, so a successor does not repeat it:** `mutually unbiased`,
`unbiased bases`, `Maassen`, `entropic uncertainty`, `uncertainty principle`,
across the whole tree — 3 hits, all the owner-side TODO above and
`INFORMATION_LENS.md` L119 listing entropic uncertainty as an unused lens. No
hit connects it to the Gauss transform, to §5.7, or to $v_D$. The literature to
read under this name: Maassen–Uffink; MUB constructions from Gauss sums;
frame/overcomplete uncertainty principles; the Donoho–Stark and Tao
uncertainty principles for $\mathbb Z/p$. **No source was opened** — `WebFetch`
is egress-blocked, so this paragraph is a naming and a reading list, not a
literature review, and no exponent below is quoted from a paper.

## 3. Why this may be a resource and not only an obstruction — ? (research direction, not a theorem)

Unbiasedness is two-sided, and §5.7 uses only one side.

The Kuznetsov route wants the boundary sum spread over **many** additive
frequencies $m$, each carrying $S(m,-a;e)$ with small individual mass —
that is the regime where spectral/large-sieve averaging pays. Flatness says
precisely: **mass concentrated in the multiplicative basis is maximally spread
in the additive one.** So multiplicative concentration of the canonical vector
is not an obstacle to the additive route; it is the hypothesis that feeds it.

And §5.4 says the canonical fixed-charge divisor kernel has Mellin symbol
$P_\chi/L$ — i.e. $\kappa_1$ is *natively multiplicative*. If $v_D(d)=d^{-1/2}\kappa_1(d)$
is concentrated on few $\chi$, flatness converts that into quantified additive
spread, which is the shape §5.7's target ("mass in the worst generic spectral
directions is power-savingly small") asks for.

I am **not** claiming this closes anything. Three things must hold and I have
checked none:

1. that $v_D$ really is concentrated multiplicatively, quantitatively, not just
   natively described that way;
2. the frame version of the entropic bound, with an exponent, on the
   overcomplete side;
3. that the degenerate locus (imprimitive $\chi$, $\gcd(m,e)>1$) does not carry
   the mass — for composite $e$ this is where a counterexample would live, and
   it is the first place to attack this.

**Falsifier, cheapest decisive attack:** exhibit a $v_D$-like vector at
composite $e$ whose mass sits on imprimitive $\chi$. Flatness fails there by
Gauss-sum degeneracy, §3's mechanism gives nothing, and the reading in this
section is dead as stated while §2 survives untouched.

### 3.1 The falsifier, run — it fires, and the failure is more informative than the claim ⊢/↳

Stated and then left hanging is how a falsifier becomes decoration, so: run it.

Let $\chi$ mod $e$ be induced by the primitive $\chi^*$ mod $f$, $f\mid e$. The
classical evaluation (↳; Iwaniec–Kowalski, Montgomery–Vaughan — standard, not
opened here) is
$$\tau(\chi)=\mu(e/f)\,\chi^*(e/f)\,\tau(\chi^*),$$
so for $\gcd(m,e)=1$,
$$|\mathcal G_e(\chi,m)|=|\mu(e/f)|\sqrt f=\begin{cases}\sqrt f & e/f \text{ squarefree, } \gcd(e/f,f)=1\\ 0&\text{otherwise.}\end{cases}$$

**So the falsifier fires: off the primitive locus the modulus is $\sqrt f<\sqrt e$,
or exactly $0$.** §3's mechanism does not run there, as predicted.

But read the *direction* of the failure, which I had not anticipated and which
is the part worth keeping. Imprimitive mass is **suppressed** by the transform
by a factor $\sqrt{f/e}$, and annihilated when $e/f$ is non-squarefree. It is
not spread badly — it does not transfer to the additive side **at all**.

That flips the reading of the degenerate locus. Mass on imprimitive $\chi$ is
mass the additive/Kuznetsov route **cannot see**, because the change of basis
kills it before any Kloosterman sum is reached. It does not behave like
uncancelled error; it behaves like a **main term** — the conductor-lowering
part, living at level $f$ rather than $e$.

Consequences, and they cut both ways:

- **Against §3**: multiplicative concentration is not sufficient. Concentration
  on *primitive* $\chi$ is what converts to additive spread. Concentration on
  imprimitive $\chi$ converts to nothing. §3 must be restated with the
  primitivity hypothesis or it is false, and I restate it: *primitive*
  multiplicative concentration of $v_D$ is the hypothesis that feeds the
  additive route.
- **For the frontier**: this predicts the decomposition D0026 §5.7 needs is not
  "concentrated vs spread" but **primitive vs induced** — split $v_D$ by
  conductor, expect the induced part to carry main terms at lower level and the
  primitive part to carry the cancellation. That is the standard conductor
  decomposition, which is another way of saying §5.7's obstruction is asking
  for a tool the subject already has a name for.

**Still not checked, and now the only thing between this and a statement about
$v_D$:** whether $\kappa_1$'s mass is primitive. Everything above is about the
transform, not about the vector. I have not computed a single coefficient of
$v_D$, and nothing here should be read as if I had.

## 4. What is claimed

| statement | mark |
|---|---|
| $\mathcal G_e$ is flat of modulus $\sqrt e$ on the primitive/coprime block | ↳ classical |
| that flatness is the standard content of "Parseval gives no free $L^2$ gain" | ↳ |
| the additive side is a tight **frame**, not a basis, so textbook MUB entropic bounds do not apply verbatim | ⊢ (elementary dimension count) |
| flatness is degenerate off the primitive/coprime locus, which is live at composite $e$ | ↳ |
| §3's "obstruction is also a resource" reading | **?** open, three unchecked hypotheses, falsifier stated |

No mark above is upgraded from D0026's alphabet, and §5.7's own statement is
not corrected — it is renamed and given the quantitative form the name carries.
