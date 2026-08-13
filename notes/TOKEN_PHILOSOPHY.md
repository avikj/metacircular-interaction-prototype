# What the collective-token view forgets: my own guess, refuted

**Status: proved, and machine-replayed.** `machinery/token_philosophy.py`,
`machinery/test_token_philosophy.py` (13/13, three hostile controls).
Companion and correction to `notes/STATEBOX.md` §7, written the same day by the
same worker. Nothing here is measured; the derivations are checked term
rewritings and the separation is a model.

## 0. The guess, and why it was worth killing fast

`STATEBOX.md` §7 asked for the fibre of the token-forgetting map

$$q:\ \{\text{individual-token executions}\}\longrightarrow
\{\text{collective-token executions}\}$$

and guessed — flagged, correctly, as a guess — that the fibre over an execution
$a\to b$ is an orbit of $\prod_s\mathfrak S_{a(s)}\times\prod_s\mathfrak
S_{b(s)}$ acting at the boundary, i.e. that *the only thing lost when tokens
stop having identities is the labelling of the tokens present at the start and
at the end*. The note recorded the worry that "interior symmetries need a
normal-form argument that may fail".

The worry was the right one and the guess is false, for a reason with nothing
to do with normal forms. **The collective quotient does not merely relabel the
boundary; it erases causality.** One equation does it, and it is forced.

## 1. The one equation

A **commutative monoidal category** is a symmetric strict monoidal category
whose symmetry is the identity: $\sigma_{A,B}=\mathrm{id}_{A\otimes B}$, which
presupposes $A\otimes B=B\otimes A$ on objects. This is the collective-token
semantics of a net: objects are markings in $\mathbb N[S]$ — multisets, where
tokens in a place have no order and hence no identity.

> **Lemma 1.** In a commutative monoidal category, $f\otimes g=g\otimes f$ for
> all morphisms $f:A\to B$, $g:C\to D$.

*Proof.* Naturality of the symmetry is
$\sigma_{B,D}\circ(f\otimes g)=(g\otimes f)\circ\sigma_{A,C}$. Substitute
$\sigma=\mathrm{id}$. $\square$

That is the entire mechanism. The symmetry was supposed to be *forgotten*; but
a forgotten symmetry is still natural, and naturality turns its triviality into
a commutation law on morphisms — a law about *processes*, not about tokens.

Throughout, $;$ denotes composition in diagrammatic order ($f;g$ = first $f$,
then $g$), and the interchange law is functoriality of $\otimes$:
$(f\otimes g);(h\otimes k)=(f;h)\otimes(g;k)$.

## 2. Two executions that differ causally and are collectively equal

Let $N$ have one place $s$ and two transitions $t_1,t_2:s\to s$. Both of

$$f=(t_1;t_1)\otimes(t_2;t_2),\qquad g=(t_1;t_2)\otimes(t_2;t_1)$$

run from the marking $2s$ to $2s$ and use each transition twice. They differ in
who does what: in $f$ one token fires $t_1$ twice while the other fires $t_2$
twice; in $g$ each token fires both, in opposite orders.

> **Theorem 2.** $f=g$ in the free commutative monoidal category on $N$.

*Proof.* Three steps, each an instance of one axiom:

$$(t_1;t_1)\otimes(t_2;t_2)
\;\overset{\text{interchange}}{=}\;(t_1\otimes t_2);(t_1\otimes t_2)
\;\overset{\text{Lemma 1}}{=}\;(t_1\otimes t_2);(t_2\otimes t_1)
\;\overset{\text{interchange}}{=}\;(t_1;t_2)\otimes(t_2;t_1).\ \square$$

Lemma 1 is applied to the *second factor only*; that asymmetry is the whole
trick, and it is why the identification is invisible to any argument that only
moves permutations across the boundary.

> **Theorem 3 (causal collapse).** For $u:s\to s$,
> $(u;u)\otimes\mathrm{id}_s=u\otimes u$ in the free commutative monoidal
> category.

*Proof.* $(u;u)\otimes\mathrm{id}=(u;u)\otimes(\mathrm{id};\mathrm{id})
=(u\otimes\mathrm{id});(u\otimes\mathrm{id})
=(u\otimes\mathrm{id});(\mathrm{id}\otimes u)
=(u;\mathrm{id})\otimes(\mathrm{id};u)=u\otimes u$, using unit, interchange,
Lemma 1, interchange, unit. $\square$

"One token fires twice" and "two tokens fire once each" are the same collective
execution. Both theorems are replayed step-by-step by
`check_derivation` in `machinery/token_philosophy.py`; the checker verifies
that each step is a typed instance of the named axiom at the named position and
that the boundary is preserved, and refuses planted-false steps.

## 3. They are not boundary-equivalent

For the refutation it is enough to exhibit **one model** of the individual-token
theory that separates them: equational logic is sound, so a model in which two
terms differ witnesses that no derivation equates them. No free object, no
normal-form theorem, and no unread prior art is needed.

**The thread category $W$.** Let $A$ be the free monoid on the transition
names. Objects of $W$ are natural numbers; $W(n,m)=\varnothing$ for $n\ne m$
and

$$W(n,n)=\mathfrak S_n\times A^n,$$

a morphism $(\beta,\lambda)$ meaning: the token entering at position $i$ leaves
at position $\beta(i)$ having traversed the word $\lambda_i$. Composition,
tensor and symmetry are

$$(\beta,\lambda);(\beta',\lambda')=\bigl(\beta'\beta,\;
i\mapsto\lambda_i\lambda'_{\beta(i)}\bigr),\qquad
(\beta,\lambda)\otimes(\gamma,\mu)=(\beta\oplus\gamma,\;\lambda\mu),\qquad
\sigma_{n,m}=(\text{block transposition},\ \varepsilon).$$

> **Proposition 4.** $W$ is a strict symmetric monoidal category.

*Proof.* Associativity and units for $;$ are associativity and units for
concatenation of words together with composition in $\mathfrak S_n$. Interchange
holds because $\oplus$ is blockwise and the two blocks never exchange strands.
For naturality, let $f=(\beta,\lambda)\in W(n,n)$, $g=(\gamma,\mu)\in W(m,m)$
and follow strands: in $\sigma_{n,m};(g\otimes f)$ the strand $i<n$ is carried
to $m+i$, then by $f$ to $m+\beta(i)$, collecting $\lambda_i$; in
$(f\otimes g);\sigma_{n,m}$ it is carried to $\beta(i)$ collecting $\lambda_i$,
then to $m+\beta(i)$. The strands $n+j$ agree likewise, and no symmetry carries
a label. $\sigma_{n,m};\sigma_{m,n}=\mathrm{id}$ by the same count. Every
remaining coherence condition is an equation between block permutations, hence
an equation in a symmetric group. $\square$

Sending $t\mapsto((0),(t))$ therefore extends to a strict symmetric monoidal
interpretation $\Phi$ of the individual-token theory in $W$. Define the
**thread multiset** $\theta(x)=$ the multiset $\{\lambda_i\}$ of $\Phi(x)$.

> **Theorem 5.** $\theta(f)=\{t_1t_1,\ t_2t_2\}$ and
> $\theta(g)=\{t_1t_2,\ t_2t_1\}$. Since $\theta$ is invariant under
> pre- and post-composition with boundary symmetries, $g$ lies in no boundary
> orbit of $f$; a fortiori $f\ne g$ individually.

*Proof.* Compute $\Phi$: $\Phi(f)=(\mathrm{id},(t_1t_1,t_2t_2))$ and
$\Phi(g)=(\mathrm{id},(t_1t_2,t_2t_1))$. A boundary symmetry contributes the
empty word to every strand and only permutes positions, so it permutes the
tuple $\lambda$ without altering any $\lambda_i$; hence $\theta$ is constant on
boundary orbits. The two multisets differ. $\square$

> **Corollary 6.** The fibre of $q$ is strictly larger than a boundary orbit.
> The guess in `STATEBOX.md` §7 is false, and Lemma 1 says why: the fibre is
> the congruence generated by an equation on *morphisms*, and morphism-level
> commutativity is not induced by any action on the boundary.

Theorem 3 gives the sharper reading: what the collective view retains is the
multiset of transition occurrences — constant along both derivations, checked
in `test_occurrence_multiset_survives_every_step` — and what it destroys is the
assignment of occurrences to threads. Collective-token semantics is
occurrence-counting; individual-token semantics is threading. The received
slogan ("the collective philosophy loses causality") is here derived, with a
two-element witness, rather than cited.

## 4. Where this leaves the corpus

- The compression $q$ is **not** a quotient by a group acting on the states it
  visibly forgets. It is a quotient by a congruence generated by one equation
  between morphisms — an *operation-level* relation. This is
  `COMPOSITIONAL_CRYSTAL_THEOREM` read in the direction that note does not
  emphasise: the greatest congruence inside a kernel can be strictly larger
  than the evident symmetry of the observation, because contexts propagate the
  identification. Lemma 1 is exactly "one identification, closed under all
  contexts, reaches further than it looks".
- For `LENS_ORDER_COMMUTATION`: this is a compression whose fibres are not
  equidistributed over any boundary lens, and Theorem 3 exhibits fibres of
  different sizes over the same pair of markings (the class of $u\otimes u$
  contains an execution with one active thread and one with two). Any counting
  obstruction phrased on boundary data alone cannot see it.
- For `STATEBOX.md`: the individual-token philosophy is not a decoration on top
  of the collective one. Theorem 2 shows the collective object has strictly
  less structure than "the same thing with tokens named", which is why the
  pre-net repair changes the *syntax* — one cannot recover threading by
  quotienting or by naming boundary tokens afterwards.

## 5. Queue

- `PROVE` — **Is a collective execution exactly its occurrence multiset?**
  Theorems 2 and 3 identify every pair I have tried that shares an occurrence
  multiset and a boundary. Conjecture: for markings $a,b$ and $m\in\mathbb
  N[T]$ with $b=a-\partial_0m+\partial_1m$, the hom-set of the free commutative
  monoidal category is in bijection with the set of such $m$ that are fireable
  from $a$. Existence needs a fireability argument (the empty marking admits no
  execution with a nonempty occurrence multiset, so realizability is a real
  constraint); uniqueness needs an induction on derivations using Lemma 1.
  *Stated as a conjecture; two instances are not a theorem, and the last guess
  in this lane lasted an hour.*
- `PROVE` — **The exact fibre.** Granted the conjecture, the fibre of $q$ over
  $m$ is the set of individual-token executions with occurrence multiset $m$,
  i.e. all threadings of $m$ compatible with the causal constraints — which
  would make "what is forgotten" a combinatorial object (a set of threadings)
  rather than a group orbit.
- `DEMONSTRATE` (optional) — extend the checker to a decision procedure for the
  commutative theory on bounded terms, which would let the conjecture be
  falsified cheaply on a finite fragment before anyone tries to prove it.

## 6. Honesty ledger

| claim | grade |
|---|---|
| Lemma 1 | **proved**, one line from naturality |
| Theorems 2, 3 | **proved**; each step machine-checked as a typed axiom instance |
| Proposition 4 ($W$ is an SSMC) | **proved**; exhaustively re-checked on a finite fragment |
| Theorem 5, Corollary 6 | **proved** by soundness — a model, not a normal-form theorem |
| "collective = occurrence counting" | **conjecture** (§5), two supporting instances |
| The `STATEBOX.md` §7 guess | **refuted** here; struck through there |
