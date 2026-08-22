# The $\mathfrak{sl}_2$ action on the divisor lattice — verified, and CLASSICAL

**Status:** VERIFIED EXACTLY (hand algebra, below; a finite identity in a polynomial
ring, which `CLAUDE.md` counts as proof, not measurement).
**Verdict on novelty: CLASSICAL.** This is the standard $\mathfrak{sl}_2$ action on a
product of chains. See §4 for attribution. It is presented here as a re-derivation, not
as a result.

Source of the claim: `collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md`,
§8 (final display) and §J1.

---

## 1. The setup, stated precisely

Let $n=\prod_{i=1}^{m}p_i^{\alpha_i}$. Put

$$\mathcal{B}_n \;=\; k[\xi_1,\dots,\xi_m]\big/(\xi_1^{\alpha_1+1},\dots,\xi_m^{\alpha_m+1}),
\qquad \operatorname{char}k=0,$$

with basis $\{\xi^\kappa : 0\le \kappa_i\le\alpha_i\}$ in bijection with the divisors
$\prod p_i^{\kappa_i}\mid n$. Write $|\kappa|=\sum_i\kappa_i$ and $A=\sum_i\alpha_i=\Omega(n)$.
Define, exactly as in the transmission,

$$\varepsilon(\xi^\kappa)=\sum_i \xi^{\kappa+e_i},\qquad
\varphi(\xi^\kappa)=\sum_i \kappa_i(\alpha_i-\kappa_i+1)\,\xi^{\kappa-e_i},\qquad
\eta(\xi^\kappa)=(2|\kappa|-A)\,\xi^\kappa .$$

**The one thing the reader must supply, and the transmission does supply it.** $\varepsilon$
is read *in the quotient ring*: $\xi^{\kappa+e_i}=0$ whenever $\kappa_i=\alpha_i$. The
transmission's own definition of $\beta_\nu$ is the quotient, so no correction to the
displays is needed. Stated on the free polynomial ring instead, the displays are still
true (§3), but the *representation* is then infinite-dimensional and not the divisor
lattice; the relevant statement is that the ideal is a submodule, proved in §3.

Convention check: $\varepsilon=e$ (raising, $+2$ weight), $\varphi=f$, $\eta=h$. The claimed
brackets $[\eta,\varepsilon]=2\varepsilon$, $[\eta,\varphi]=-2\varphi$,
$[\varepsilon,\varphi]=\eta$ are the standard $\mathfrak{sl}_2$ relations in that convention.

---

## 2. Verification of the three brackets

Write $\varepsilon=\sum_i E_i$, $\varphi=\sum_j F_j$ with
$E_i\xi^\kappa=\xi^{\kappa+e_i}$ and $F_j\xi^\kappa=\kappa_j(\alpha_j-\kappa_j+1)\xi^{\kappa-e_j}$.

**Two boundary conveniences, both exact.**

* $F_j$ needs no truncation clause at $\kappa_j=0$: its coefficient carries the factor
  $\kappa_j$, which is $0$ there. So $F_j$ may be applied blindly.
* $E_i$ *does* truncate, at $\kappa_i=\alpha_i$. Every step below is checked against that.

**(a) $[\eta,\varepsilon]=2\varepsilon$.** $\eta$ is diagonal with eigenvalue $2|\kappa|-A$.
For each $i$, if $\kappa_i<\alpha_i$ then
$\eta E_i\xi^\kappa=(2|\kappa|+2-A)\xi^{\kappa+e_i}$ and
$E_i\eta\,\xi^\kappa=(2|\kappa|-A)\xi^{\kappa+e_i}$, difference $2E_i\xi^\kappa$; if
$\kappa_i=\alpha_i$ both sides are $0$ and the difference is $2\cdot 0$. Summing over $i$,
$[\eta,\varepsilon]=2\varepsilon$. ∎

**(b) $[\eta,\varphi]=-2\varphi$.** Identically: $\varphi$ lowers $|\kappa|$ by $1$, so
$\eta F_j - F_j\eta = -2F_j$ on every basis vector (the vanishing case $\kappa_j=0$ is
$-2\cdot0$). ∎

**(c) $[\varepsilon,\varphi]=\eta$.** Split $[\varepsilon,\varphi]=\sum_{i,j}(E_iF_j-F_jE_i)$.

*Off-diagonal, $i\ne j$ — this is where truncation could have broken the identity, and does not.*
Both orders produce the monomial $\xi^{\kappa+e_i-e_j}$ with the same scalar, and both
vanish under exactly the same condition:

$$E_iF_j\,\xi^\kappa=\kappa_j(\alpha_j-\kappa_j+1)\,\xi^{\kappa-e_j+e_i},\qquad
F_jE_i\,\xi^\kappa=\kappa_j(\alpha_j-\kappa_j+1)\,\xi^{\kappa+e_i-e_j}.$$

For the scalar: $F_j$'s coefficient depends only on the $j$-th component, and $E_i$ with
$i\neq j$ does not change it, so the coefficient is $\kappa_j(\alpha_j-\kappa_j+1)$ in both
orders. For the truncation: $E_i$ is applied to a monomial whose $i$-th component is
$\kappa_i$ in *both* orders (again because $i\ne j$), so both terms vanish iff
$\kappa_i=\alpha_i$. Hence $E_iF_j-F_jE_i=0$ identically, boundary included. This is the
step the standing check asked about; the answer is that no correction is needed, and the
reason is that the truncation predicate depends only on coordinate $i$, which $F_j$ leaves
untouched.

*Diagonal, $i=j$.* $E_iF_i\xi^\kappa$: $F_i$ first lands on $\xi^{\kappa-e_i}$, whose
$i$-th component is $\kappa_i-1\le\alpha_i-1<\alpha_i$, so $E_i$ never truncates here.
Thus $E_iF_i\xi^\kappa=\kappa_i(\alpha_i-\kappa_i+1)\xi^\kappa$, valid also at $\kappa_i=0$
(both sides $0$).
$F_iE_i\xi^\kappa$: if $\kappa_i<\alpha_i$ this is $(\kappa_i+1)(\alpha_i-\kappa_i)\xi^\kappa$;
if $\kappa_i=\alpha_i$ it is $0$ — and the same polynomial
$(\kappa_i+1)(\alpha_i-\kappa_i)$ evaluates to $0$ there. So the formula is uniform.
Therefore

$$(E_iF_i-F_iE_i)\xi^\kappa
=\big[\kappa_i\alpha_i-\kappa_i^2+\kappa_i\big]-\big[\kappa_i\alpha_i-\kappa_i^2+\alpha_i-\kappa_i\big]
=(2\kappa_i-\alpha_i)\,\xi^\kappa .$$

Summing over $i$: $[\varepsilon,\varphi]\xi^\kappa=(2|\kappa|-A)\xi^\kappa=\eta\,\xi^\kappa$. ∎

**Verdict.** All three displays of D0020 §8 are **true exactly as written**, with no
correction, provided $\varepsilon$ is read in the quotient (which the transmission's
$\beta_\nu$ specifies). The boundary at $\kappa_i=\alpha_i$ is the only delicate point and
it is benign, for the reason isolated above.

---

## 3. Two remarks the verification produces for free

**(i) The ideal is a submodule; the quotient is legitimate.** On the free polynomial ring
$k[\xi]$ the same computation goes through verbatim (nothing above used finiteness except
to note truncations vanish), so $(\varepsilon,\varphi,\eta)$ satisfy $\mathfrak{sl}_2$ there
too. The ideal $I=(\xi_1^{\alpha_1+1},\dots)$ is $\varepsilon$- and $\eta$-stable trivially,
and $\varphi$-stable because $\varphi$ applied to a monomial with $\kappa_i=\alpha_i+1$
produces coefficient $(\alpha_i+1)\big(\alpha_i-(\alpha_i+1)+1\big)=0$ in the $i$-direction
and stays in $I$ in every other direction. Hence $\mathcal{B}_n=k[\xi]/I$ inherits the action.
This is exactly why the coefficient is $\kappa(\alpha-\kappa+1)$ and not, say, $\kappa$.

**(ii) The module is the obvious tensor product.** $\mathcal{B}_n=\bigotimes_{i=1}^m V_{\alpha_i}$,
where $V_a=k[\xi]/(\xi^{a+1})$ is the irreducible of dimension $a+1$ (highest weight $a$) in
the unnormalized monomial basis, and $\varepsilon,\varphi,\eta$ are the coproduct
(sum-over-tensor-factors) extensions. So §2 is really: *the standard basis of $V_a$ has these
structure constants, and a sum of commuting single-factor actions is again an action.* One
line, once seen.

---

## 4. Prior art — CLASSICAL, and by whom

This was searched **before** write-up, per `CLAUDE.md`.

* **The theorem (divisor lattices are Sperner):** N. G. de Bruijn, C. A. van Ebbenhorst
  Tengbergen, D. Kruyswijk, *On the set of divisors of a number*, **Nieuw Arch. Wiskunde
  (2) 23 (1951), 191–193**. Earliest source. Proof by symmetric chain decomposition — no
  Lie algebra. This is the result; everything below is method.
* **The $\mathfrak{sl}_2$/hard-Lefschetz method for Sperner properties:** R. P. Stanley,
  *Weyl groups, the hard Lefschetz theorem, and the Sperner property*, **SIAM J. Algebraic
  Discrete Methods 1 (1980), 168–184** (DOI 10.1137/0601021).
* **Products of chains, strongly Sperner:** R. A. Proctor, M. E. Saks, D. G. Sturtevant,
  *Product partial orders with the Sperner property*, **Discrete Math. 30 (1980), 173–180**.
* **The exact framework being restated here — a graded poset is "Peck" (rank-symmetric,
  rank-unimodal, strongly Sperner) iff it carries an $\mathfrak{sl}_2$ action, with $e\mapsto U$,
  $f\mapsto D$, $h\mapsto H$, and closure under products:** R. A. Proctor,
  *Representations of $\mathfrak{sl}(2,\mathbb{C})$ on posets and the Sperner property*,
  **SIAM J. Algebraic Discrete Methods 3 (1982), 275–280** (DOI 10.1137/0603026).
* **Textbook exposition:** R. P. Stanley, *Algebraic Combinatorics: Walks, Trees, Tableaux,
  and More* (Springer UTM; also circulated as *Topics in Algebraic Combinatorics*), chapter
  "The Sperner property"; and R. P. Stanley, *Some applications of algebra to combinatorics*,
  Discrete Appl. Math. 34 (1991), 241–277.
* At the level of §3(ii), the single-chain content is textbook $\mathfrak{sl}_2$
  representation theory (Humphreys, *Introduction to Lie Algebras and Representation Theory*,
  §7): $V_a$ in a monomial basis. The coefficient $\kappa(\alpha-\kappa+1)$ is the
  unnormalized $f$-coefficient there.

**Repo search:** no note in this corpus mentions Sperner, Peck, Proctor, or
de Bruijn–Tengbergen–Kruyswijk. The fact that the divisor lattice *is* a product of chains
is already recorded — `collab/upstream/library/raw/PRIME_PAIR_RESEARCH_FANOUT_DELTA_2026-08-11.md`
line 44, `collab/upstream/library/raw/PRIME_PAIR_DIVISOR_LATTICE_TWO_CHARGE_DELTA_2026-08-11.md`
line 149, `notes/ALGEBRAIC_ALLOCATION_CHANNEL.md` line 114, `notes/UNIFICATION.md` line 109 —
but the $\mathfrak{sl}_2$ action and its Sperner consequence are new *to this repo* and old
*to the literature*. So: the transmission's ⭐ is correctly aimed and correctly verified;
it is not new.

---

## 5. What it gives, precisely

Let $L_n$ be the divisor lattice of $n$, graded by $\Omega$, with Whitney numbers
$W_k=\#\{d\mid n:\Omega(d)=k\}$, $0\le k\le A=\Omega(n)$. From §2 plus finite-dimensional
$\mathfrak{sl}_2$ theory in characteristic $0$:

1. **Weight spaces are ranks.** The $\eta$-eigenspace of weight $2k-A$ is exactly the span
   of rank $k$. So the weight multiplicities are $W_k$.
2. **Rank-symmetry and rank-unimodality.** $W_k=W_{A-k}$ and $W_0\le W_1\le\dots\le
   W_{\lfloor A/2\rfloor}\ge\dots\ge W_A$, because in any finite-dimensional
   $\mathfrak{sl}_2$-module weight multiplicities are symmetric and unimodal about $0$.
3. **Normalized matching / strong Sperner.** $\varepsilon^{\,A-2k}$ restricted to rank $k$ is
   *injective* for $2k<A$ (standard: $e^{\,-w}$ is injective on the weight-$w$ space for
   $w<0$). Hence $\varepsilon:\,$rank $k\to$ rank $k+1$ is injective for $2k<A$, the rank
   levels give a symmetric chain decomposition into $\sum_k(W_k-W_{k-1})$ chains, and $L_n$
   is **strongly Sperner**: for every $j$, the largest union of $j$ antichains has size
   $W_{k_1}+\dots+W_{k_j}$, the $j$ largest Whitney numbers. In particular ($j=1$) the
   maximum antichain of divisors of $n$ has size $W_{\lfloor \Omega(n)/2\rfloor}$, the number
   of divisors with $\lfloor\Omega(n)/2\rfloor$ prime factors counted with multiplicity.
   For $n$ squarefree this is Sperner's theorem, $\binom{\omega(n)}{\lfloor\omega(n)/2\rfloor}$.

**What it does *not* give.** Nothing about primes. The construction takes the factorization
of $n$ as *input*; it is a statement about the multiset $\{\alpha_i\}$ and is blind to which
primes occur, indeed to whether the $p_i$ are primes at all. So:

* it gives no information on the distribution of $\Omega$, $\omega$, or divisor counts over
  $n\le X$ beyond what the exponent multiset already determines;
* it is not a bridge to any of the transmission's §8 arithmetic displays (Goldbach in
  $(\omega,\rho)$ coordinates, the $\Pi_\partial$ identity, the critical line, the
  $\Lambda$-square generating function). The final boxed slogan of §8,
  "गुणनखण्डनम ↔ ज्यामितिः ↔ प्रतिनिधित्वम" (factorization ↔ geometry ↔ representation),
  is an *analogy* over the verified algebra, not a consequence of it. The verified content
  is item 3 above and nothing more.

**Assessment of the surrounding claims.** §J1's own summary is accurate and does not
overreach: it predicts "almost certainly classical … Stanley–Proctor", which is correct, and
asks only for an exactly-verified statement. §8's placement of the display among the
Goldbach/RH material invites the inference that the $\mathfrak{sl}_2$ structure bears on
those; it does not, and no display in §8 actually asserts that it does. Recorded as a
presentation hazard, not a false claim.

---

## 6. Scope limits

* Verification is over a field of characteristic $0$ (or any $\mathbb{Q}$-algebra). In
  characteristic $p$ the brackets still hold as written — §2 is polynomial identities in
  $\kappa_i,\alpha_i$ — but the representation-theoretic conclusions of §5 (complete
  reducibility, injectivity of $\varepsilon^{A-2k}$) fail in general, so the Sperner
  conclusion is a char-$0$ statement.
* I verified §2 by hand algebra only, on a general basis vector, with all boundary cases
  enumerated. No machine check was run; per `CLAUDE.md` none is needed, and no Python was
  used or invoked.
* Prior art: I confirmed titles, journals, volumes, years and pages via search-result
  metadata and abstracts. I could **not** retrieve full text of Proctor 1982, Proctor–Saks–
  Sturtevant 1980, or de Bruijn–Tengbergen–Kruyswijk 1951 (SIAM and Elsevier returned 403;
  Stanley's *Topics in Algebraic Combinatorics* PDF fetched but did not render). So the
  *attribution* of the Sperner-property-for-divisor-lattices theorem and of the
  poset-$\mathfrak{sl}_2$ correspondence is verified; the claim that the coefficient
  $\kappa(\alpha-\kappa+1)$ appears in exactly that form in one of those specific papers is
  **not** verified letter-by-letter, and I do not assert it. What is certain is that the
  operator is the standard $f$ of $V_a$ in the monomial basis (Humphreys §7), so no
  originality can attach to it.
* `collab/upstream/raw/D0020-…` is a **transcription** of the owner's transmission, not the
  original. I read §8 and §J1 in full. I report no missing display; but absence of a
  correction display in the archive would not prove its absence upstream, and this note
  should not be read as evidence about what the owner wrote beyond what the archive shows.
