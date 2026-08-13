# What the collective-token view forgets: my own guess, refuted

**Status: proved, and machine-replayed.** `machinery/token_philosophy.py`,
`machinery/test_token_philosophy.py` (18/18, four hostile controls). Two
conjectures were stated and killed in this note's own lifetime — §0's and
§3's; §5 is what replaced them and §6 states the third one with its guard
rails visible.

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
assignment of occurrences to threads. ~~Collective-token semantics is
occurrence-counting; individual-token semantics is threading.~~
**[OVERSTATED — §5 Theorem 8. Occurrence-counting is what survives *here*, at
the marking $2s$; at the marking $s$ the collective category still separates
$t_1;t_2$ from $t_2;t_1$. The correct slogan is §5's.]** The received
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

## 5. The successor conjecture, also false: a spectator token erases the order

§3 ended by conjecturing that a collective execution is *exactly* its
occurrence multiset (subject to fireability), and warned that two instances are
not a theorem. They were not. The conjecture is false, and the way it fails is
worth more than the conjecture would have been.

**The spectator category $X$.** Objects $\mathbb N$; $X(n,m)=\varnothing$ for
$n\ne m$; and, writing $A$ for the free monoid on the transition names and
$\mathbb N[A_1]$ for the free commutative monoid on the names,

$$X(0,0)=\{*\},\qquad X(1,1)=A,\qquad X(n,n)=\mathbb N[A_1]\ (n\ge2).$$

Composition is concatenation on one strand and addition above it; the tensor is
$f\otimes g=\mathrm{ab}(f)+\mathrm{ab}(g)$ when both factors have at least one
strand, and is strictly unital against $n=0$. One strand remembers the order of
what it did; two or more strands remember only how much was done.

> **Proposition 7.** $X$ is a commutative monoidal category.

*Proof.* Composition is associative and unital in each arity (concatenation;
addition). Interchange: for $f,h\in X(m,m)$ and $g,k\in X(n,n)$ with
$m,n\ge1$, both sides of $(f\otimes g);(h\otimes k)=(f;h)\otimes(g;k)$ equal
$\mathrm{ab}(f)+\mathrm{ab}(g)+\mathrm{ab}(h)+\mathrm{ab}(k)$, because
$\mathrm{ab}$ is a monoid homomorphism and the target arity is $\ge2$; when
$n=0$ both sides are $f;h$. Identities tensor to identities. The object monoid
$\mathbb N$ is commutative, so the identity is a legitimate symmetry, and its
naturality is $f\otimes g=g\otimes f$, which holds because $\mathrm{ab}$ lands
in a commutative monoid. All remaining coherence is trivial by strictness.
$\square$

> **Theorem 8.** For $t_1,t_2:s\to s$, the collective theory does **not** prove
> $t_1;t_2=t_2;t_1$. Hence a collective execution is not determined by its
> occurrence multiset, and the §3 conjecture is false.

*Proof.* Interpret $s\mapsto1$, $t_i\mapsto$ the corresponding generator of
$A$. By Proposition 7 and soundness, any derivable equation holds in $X$; but
$t_1t_2\ne t_2t_1$ in the free monoid $A=X(1,1)$. The two executions have the
same source $s$ and the same occurrence multiset $\{t_1,t_2\}$. $\square$

> **Theorem 9 (one idle token is enough).** Nevertheless
> $(t_1;t_2)\otimes\mathrm{id}_s=(t_2;t_1)\otimes\mathrm{id}_s$ in the
> collective theory.

*Proof.* Six steps, twice: by unit, interchange, Lemma 1, interchange, unit,
unit, $(g_1;g_2)\otimes\mathrm{id}_s=g_1\otimes g_2$ for any unary $g_1,g_2$ —
this is Theorem 3's derivation with the two generators left distinct. Apply it
to both sides and close with Lemma 1: $t_1\otimes t_2=t_2\otimes t_1$.
$\square$

> **Corollary 10.** The information that distinguishes $t_1;t_2$ from
> $t_2;t_1$ exists at the marking $s$ and is destroyed at the marking $2s$. The
> collective quotient's kernel is therefore not a function of the execution: it
> grows when idle context is added.

This is the opposite of the usual direction. In this corpus a richer context
*refines* — "adding a new operation adds new contexts and may split old
classes" (`COMPOSITIONAL_CRYSTAL_THEOREM`, engine law). Here adding an inert
spectator token *merges* two previously distinct executions. There is no
contradiction, and saying exactly why is the useful part: $(-)\otimes
\mathrm{id}_s$ is not a context in the crystal sense. A crystal context is an
endo-operation on one carrier, and refinement is monotone on that carrier;
$(-)\otimes\mathrm{id}_s$ is a *map between different hom-sets*,
$C(s,s)\to C(2s,2s)$, and nothing makes such a map injective. The engine law's
monotonicity is a statement about observations of a fixed object, not about
embedding an object into a larger one.

So the honest slogan for the collective-token philosophy is neither "it forgets
which token" (§3) nor "it keeps only the counts" (this section's dead
conjecture), but:

> **A collective execution remembers the order of its transitions exactly as
> far as the tokens carrying them are the only tokens present.**

## 6. Queue

- `PROVE` — **What is $C(a,b)$?** Both easy answers are dead. What survives:
  for $a=s$ the hom-set contains the free monoid's worth of distinctions
  (Theorem 8), for $a=2s$ Theorems 2, 3 and 9 collapse everything with the same
  occurrence multiset that I have tested. Conjecture, third attempt, and stated
  as *strictly weaker than the last two*: the collapse is complete from
  $|a|\ge2$ tokens on, i.e. $C(a,b)\cong\{m$ fireable from $a\}$ whenever $a$
  has at least two tokens in some place used by $m$. I have not tested the
  boundary of this and will not report it as anything but a guess.
- `PROVE` — **Which $\otimes\mathrm{id}$ maps are injective?** Corollary 10
  makes this the sharp question: the loss of the collective view is the failure
  of injectivity of $C(a,b)\to C(a+r,b+r)$, and the two theorems above locate
  one failure at $r=s$. A criterion would be the exact loss statement this
  lane has been circling since `STATEBOX.md`.
- `DEMONSTRATE` (optional) — a decision procedure for the collective theory on
  bounded terms, which would let the third conjecture be falsified cheaply
  before anyone tries to prove it. The first two guesses died in two hours and
  one hour respectively; a falsifier is now clearly worth more than a proof
  attempt.

## 6. Honesty ledger

| claim | grade |
|---|---|
| Lemma 1 | **proved**, one line from naturality |
| Theorems 2, 3 | **proved**; each step machine-checked as a typed axiom instance |
| Proposition 4 ($W$ is an SSMC) | **proved**; exhaustively re-checked on a finite fragment |
| Theorem 5, Corollary 6 | **proved** by soundness — a model, not a normal-form theorem |
| ~~"collective = occurrence counting" — **conjecture** (§5), two supporting instances~~ | **REFUTED** the same session, §5 Theorem 8 |
| Proposition 7 ($X$ is a commutative monoidal category) | **proved**; exhaustively re-checked on a fragment |
| Theorems 8, 9, Corollary 10 | **proved** — a model, and a checked derivation |
| §6 third conjecture (collapse is complete from two tokens on) | **guess**, deliberately weaker, untested at its boundary |
| The `STATEBOX.md` §7 guess | **refuted** here; struck through there |
