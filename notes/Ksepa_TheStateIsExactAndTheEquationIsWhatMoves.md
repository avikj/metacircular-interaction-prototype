# क्षेप — the state is exact and the equation is what moves

*Set down 2026-08-20, branch `claude/iteration-cognition-framework-55nit5`.
Answering the owner's reduction of the cognition loop to a numerical
iteration. No experiment was run; every numerical statement below is exact.*

---

## 0 · The claim being answered, in his notation

> $$x_{n+1}=x_n+\Delta(r_n),\qquad r_n=F(x_n)$$
>
> "the basic numerical algorithm is precisely the whole solution … the
> revolution entirely in what $x,F,DF,/,-,=$ are allowed to mean."

The skeleton is right. What follows is one place where the wider semantics is
not hypothetical: it was written down, worked, and terminated, and the
repository already holds part of it as checked Agda.

---

## 1 · वर्गप्रकृति and its क्षेप

Brahmagupta, *Brāhmasphuṭasiddhānta* ch. 18, **628 CE**. The equation is
**वर्गप्रकृति** (*varga-prakṛti*, "square-nature"): $N$ is the **प्रकृति**, the
multiplier; $k$ is the **क्षेप** (*kṣepa*), the additive quantity thrown in.

$$a^2 - N b^2 = k.$$

Fix a non-square $N$ and read $k$ as an index over a family of sets:

$$\mathrm{Sol}_N(k) \;=\; \{\,(a,b)\in\mathbb Z^2 \;:\; a^2 - Nb^2 = k\,\}.$$

The problem is to inhabit $\mathrm{Sol}_N(1)$ at some $(a,b)$ with $b\neq 0$.

**भावना** (*bhāvanā*), Brahmagupta's composition law, is a map **between
different members of the family**:

$$\mathrm{Sol}_N(k_1)\times \mathrm{Sol}_N(k_2)\;\longrightarrow\;\mathrm{Sol}_N(k_1k_2),\qquad
\big((a,b),(a',b')\big)\mapsto (aa'+Nbb',\;ab'+a'b).$$

[in-repo, checked: `formal/cubical/Brahmagupta.agda`, `भावना-मान`;
`formal/cubical/Bhavana.agda`; `formal/cubical/BhavanaSemiring.agda`.]

**चक्रवाल** (*cakravāla*, "the wheel"): Jayadeva ~950 CE, surviving through
Udayadivākara's *Sundarī* 1073; in full with worked cases $N=61,67,103$ in
Bhāskara II, *Bījagaṇita*, **1150 CE**. From $(a,b)\in\mathrm{Sol}_N(k)$ with
$\gcd(a,b)=1$, choose $m\in\mathbb Z$ subject to

$$|k| \;\big|\; (a+bm), \qquad |m^2-N| \text{ minimal among such } m,$$

and step

$$(a,b)\;\longmapsto\;\left(\frac{am+Nb}{|k|},\;\frac{a+bm}{|k|}\right)\;\in\;\mathrm{Sol}_N\!\left(\frac{m^2-N}{k}\right).$$

The step factors as *compose, then divide*. The composing half is the checked
part in this repository — `Cakravala.agda`, `चक्रीय-पद-रूपम्`:

$$\text{norm}\big((a,b)\cdot(m,1)\big) \;=\; k\cdot(m^2-N),$$

the interpolator $(m,1)$ carrying norm $m^2-N$. The module header states, and
this note repeats rather than papers over, that the $m$-choice and the exact
division by $k$ are **not** formalized there.

---

## 2 · Every intermediate state is an exact solution of a different equation

This is the whole point and it is easy to read past.

$(a_n, b_n)$ is never an approximate solution of $a^2-Nb^2=1$. It is an
**exact** solution of $a^2-Nb^2=k_n$. There is no error, no residual
magnitude, no tolerance. Nothing is approximate about the state.

What is approximate is **which equation the state solves**. The iteration
walks the index:

$$k_0 \to k_1 \to k_2 \to \cdots \to 1 .$$

Set against the loop of §0:

| | the equation | the state | what the iteration moves |
|---|---|---|---|
| **cakravāla** (950 / 1150) | moves: $k_n$ | exact at every step | the index |
| Newton–Raphson (1669 / 1690) | fixed: $F(x)=0$ | approximate at every step | the point |

Neither is a version of the other. They are the two ways to arrange the same
four slots, and only one of them has been treated as the shape of iteration.

---

## 3 · What the fixed-space skeleton silently assumes

$x_{n+1}=x_n+\Delta(r_n)$ requires all of:

1. $x_n$ and $x_{n+1}$ inhabit **one** set,
2. that set carries $+$, so a correction can be *added* to a state,
3. $F$ has one domain and one codomain, so $r_n$ and $r_{n+1}$ are comparable,
4. $=$ is that one set's equality, so $x_{n+1}-x_n$ is typed,
5. convergence is a metric on that set.

The cakravāla satisfies none of the five, and terminates in finitely many
steps with an exact integer answer.

**The general shape**, of which the fixed-space loop is the degenerate case:

- an index set $I$ and a family $S : I \to \mathsf{Type}$,
- a step $(\sigma,\, f)$ with $\sigma : I \to I$ and
  $f_i : S(i) \to S(\sigma i)$,
- a target $i^\star \in I$; **termination** is $\sigma^n(i_0)=i^\star$ for some $n$.

Newton is $I=\mathbf 1$. Then $\sigma=\mathrm{id}$, every $f$ is an endomap of
one space, the target index is reached at step zero, and *the entire content
migrates into a metric on $S(\star)$* — which is why the fixed-space picture
has to be asymptotic. Cakravāla is $I=\mathbb Z$, $S=\mathrm{Sol}_N$,
$i^\star=1$, $\sigma_m(k)=(m^2-N)/k$.

So: **the difference between optimization and cognition, in his terms, is
whether the diagram of state-spaces is constant.** That is one line, it is
checkable, and it is where transport stops being decoration.

---

## 4 · Subtraction is the operation that does not survive

$x_{n+1}-x_n$ is not typed when $\sigma(i)\neq i$. Comparing consecutive
states requires a *map* between two different sets, and which map is not
given for free. In the constant diagram that map is the identity, which is why
nothing in the received picture ever asks what it is.

Here the map is bhāvanā, and it is **directed**:

- **upward is free.** $\mathrm{Sol}(k_1)\times\mathrm{Sol}(k_2)\to\mathrm{Sol}(k_1k_2)$
  is total. Indices multiply, always.
- **downward is conditional.** Dividing the index — getting from
  $\mathrm{Sol}(k(m^2-N))$ into $\mathrm{Sol}((m^2-N)/k)$ — requires
  $|k|$ to divide $a+bm$, which is the congruence the $m$-choice enforces.

The family is a monoid acting, not a groupoid. **The entire difficulty of the
algorithm is the backward transports**, and the congruence is what buys them.
Composition is never the hard part; descent is.

That is the precise content of "transport" in
$C_{n+1}=C_n+\operatorname{transport}(\operatorname{correction}(\partial C_n))$:
not a coherence chore, but the only reason consecutive states are comparable at
all, and the step whose *availability* is the mathematics.

---

## 5 · The index lives in a finite window — so convergence is combinatorial, not analytic

`formal/cubical/CakravalaBound.agda`, in this repository, checked:
Bhāskara's minimality choice keeps

$$|k| < 2\sqrt{N}$$

at every turn. The choice rule is not a speed heuristic. It is what confines
the index to a **finite** set, so the state ranges over finitely many
possibilities and some state must recur.

This is the structural payoff of moving the approximation from the point to
the index. A residual in a continuum can only be driven to zero
asymptotically. An index in a finite set is subject to pigeonhole. The
convergence question changes kind: not *how fast does the error decay* but
*does the wheel come back to the unit*.

**Honest scope, stated because the repository has already had to correct a
lapse here.** The bound is not termination. `CakravalaBound.agda` says so in
its own words; `notes/DosaLekha_TheCakravalaTurnCapIsNotABound.md` records
that a 400-turn cap in `machine/Nalanda.hs` was standing in for the missing
proof and fails at $D=73516$. Recurrence of *some* state does not yet give
return to $k=\pm 1$. Bhāskara II asserts termination; a European proof exists
for continued fractions, a different algorithm (Lagrange). **This repository dates
that two ways** — `notes/NOT_PELL_IT_IS_VARGAPRAKRITI.md` says 1766 (Mémoires,
Berlin), `CakravalaDescent.agda` and `CakravalaBound.agda` say 1768. Recorded,
not resolved; neither source is checkable from this container.

---

## 6 · Objective and invariant are two different things, and the algorithm has both

The cakravāla carries:

- **invariant** — $a_n^2 - N b_n^2 = k_n$, exactly, at every step, no
  tolerance, never traded for progress;
- **objective** — reach $k=1$.

An optimizer has only the second. This is the exact sense in which
$\Omega=\mathrm{ahi\dot{m}s\bar{a}}$ is not a loss term:

> A quantity minimized over a trajectory permits arbitrary local violation so
> long as the sum is small. A condition that is a **type** on every
> intermediate state cannot be locally violated at all, because the violating
> state is not constructible.

Relaxing the invariant here would not even buy speed. The exactness is what
makes the divisibility argument available; approximate states have no
congruences. **The constraint is the mechanism, not a tax on it.**

---

## 7 · What the residual is — and the two schools disagree, which is the content

$k_n$ is determined by $(a_n,b_n,N)$. It need not be stored. Every
implementation stores it.

- **Nyāya-Vaiśeṣika.** *Abhāva* is a *padārtha* in its own right, and every
  absence has a *pratiyogin*, a determinate counterpositive. On this reading
  $k_n$ — the failure of the state to solve the target equation — is a real
  relatum, a thing the cognition is *of*. Store it; it is an entity.
  (Nyāya does not admit *anupalabdhi* as a separate *pramāṇa*; it treats the
  absence as perceived in a qualified locus. Bhāṭṭa Mīmāṃsā does admit it.
  [recalled])
- **Jaina.** No separate absence-entity. *Syād-nāsti* is the same substance
  under another standpoint, grounded fourfold in *dravya, kṣetra, kāla,
  bhāva*. On this reading $k_n$ is not an object beside $(a_n,b_n)$; it is
  $(a_n,b_n)$ read under a different *naya*. Derive it; there is nothing else
  there.

What they would say to each other: the Naiyāyika holds that unless the
residual is an entity it cannot be the *content* of a cognition, and an
algorithm that cannot cognize its own discrepancy cannot be said to correct
anything. The Jaina holds that reifying the discrepancy is what licenses the
*durnaya* — treating $k_n$ as **the** truth about the state, when the state is
in fact an exact solution and $k_n$ merely says of which equation.

The algorithm sides operationally with the first (it caches $k$) and
ontologically with the second ($k$ is redundant). Recorded; not scored.

The Jaina reading also states the thing §2 makes structural: $(a_n,b_n)$ is
never false. It is exact, in its own equation, at every step. Nothing in the
run is discarded as error, and nothing needs forgiving into truth.

---

## 8 · The statement, in the shape it would be checked in

Not compiled — **no Agda toolchain in this container, 2026-08-20**. This is a
target, tagged DEMONSTRATE below, not a result.

```agda
Sol : (N k : ℤ) → Type
Sol N k = Σ[ a ∈ ℤ ] Σ[ b ∈ ℤ ] (मान N a b ≡ k)

-- the composing half: free, total, index multiplies.  Cakravala.agda's
-- चक्रीय-पद-रूपम् is exactly this at (m , 1).
भावना-पद : (N k m : ℤ) → Sol N k → Sol N (k · ((m · m) - N))

-- the descending half: conditional on the congruence.  This is the step the
-- module headers record as not done, and it is the one that matters.
अवतरण : (N k m : ℤ) (s : Sol N k) → |k| ∣ (a s + b s · m)
       → Sol N (((m · m) - N) / k)
```

The asymmetry between the two type signatures — one total, one carrying a
hypothesis — is the whole §4.

---

## 9 · What is not claimed

- Bhāskara II did not have a type family, an index set, or a colimit. §3 is a
  description of what his algorithm does, in this repository's substrate, and
  is marked as mine.
- No one is being said to have anticipated anything. The direction of the
  claim is the reverse: the fixed-space loop is the **narrower** object, and
  a worked instance of the wider one is 1150 CE.
- **क्षेप** as the tradition's word for the additive $k$ in vargaprakṛti:
  [recalled], high confidence, **not verified against the text in this
  container** — egress is blocked here (tested 2026-08-20: `curl` on
  `en.wikipedia.org` → CONNECT tunnel 403), matching the caveat re-armed in
  `notes/MADHAVA_THE_SERIES_AND_ITS_END_CORRECTION.md`. Verify against
  *Brāhmasphuṭasiddhānta* 18 and *Bījagaṇita* before it is quoted as
  vocabulary rather than used as a label.
- The §7 attributions are [recalled] and carry no verse.
- No correlation, no fitted constant, no run. §1's recurrences, §5's bound and
  §6's invariant are exact statements, and the two that are checked are marked
  as checked in this repository, not by me.

---

## 10 · Open

- **PROVE** — termination of the cakravāla. Open in-repo. `CakravalaBound`
  gives $|k|<2\sqrt N$, hence a finite state set, hence recurrence of some
  state; return to $k=\pm 1$ is not derived. This is the concrete form of
  "does the wheel come round", and it is the convergence theorem for the
  indexed skeleton.
- **PROVE** — Bhāskara's lemma as `अवतरण` in §8: that the congruence
  $|k| \mid (a+bm)$ makes all three of $a', b', k'$ integral. Named as open in
  `Cakravala.agda`'s header and `CakravalaDescent.agda`'s.
- **SEARCH** — **अविशेष** (*aviśeṣa*, "non-difference") and **असकृत्**
  (*asakṛt*, "not once") as the siddhānta tradition's technical vocabulary for
  iterating a computation until successive values stop differing, i.e. for
  the fixed-point test itself. [recalled, unverified; zero hits in `notes/`
  today apart from *saviśeṣa* in `BhavanaKrida.agda`.] If this is right, the
  tradition names the *convergence criterion* as an operation, and this note
  is missing its first citation. Needs egress or a text.
- **SEARCH** — whether the indexed-family reading of vargaprakṛti (§1–§4) is
  already in the literature. Asked before writing, unanswerable in this
  container; asked again by whoever has egress next.
- **SEARCH** — the Lagrange date, 1766 or 1768, which this repository currently
  asserts both of. One of the four places is wrong and no reader can tell which.
- **DEMONSTRATE** — §8, once there is a toolchain.
