# What the collective-token view forgets: causality, exactly up to concurrency

**Status: proved, and machine-replayed.** `machinery/token_philosophy.py`,
`machinery/test_token_philosophy.py` (37/37, eight hostile controls). Two
conjectures were stated and killed in this note's own lifetime — §0's and
§3's — and the third, stated with its guard rails visible, was then **proved**
for the class in question (§6, Theorem 11). The instrument that closed it was
the falsifier built after the second death, and its first run found a gap in
my own axiom set.

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
$n=0$ both sides are $f;h$. Identities tensor to identities — *and this is the
clause that consumes $\mathrm{ab}$'s **unit** law, not its multiplicativity*:
$\mathrm{id}_1=\varepsilon\in A$, $\mathrm{id}_n=0\in\mathbb N[A_1]$ for
$n\ge2$, so $\mathrm{id}_1\otimes\mathrm{id}_1
=\mathrm{ab}(\varepsilon)+\mathrm{ab}(\varepsilon)=\mathrm{id}_2$ exactly
because $\mathrm{ab}(\varepsilon)=0$, which is the defining value of the map
$A\to\mathbb N[A_1]$ induced from the generators by the universal property of
the free monoid. [Clause supplied in place by seed132, 2026-08-14: the
monoid-unit law of $\mathrm{ab}$ is independent of its operation law and is
what the identity clause of Proposition 7 actually uses. Nothing else moves;
Theorems 8 and 9 use only the interchange computation.] The object monoid
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

## 6. The class is determined, and the falsifier found the gap first

I said in §6 that a falsifier was now worth more than a proof attempt, and
built one: `rewrite_component` explores every axiom rewrite in both directions
from a seed, under a size bound, with no reference to any invariant. Its first
run reported classes of terms that ought to have been connected and were not.
The cause was not mathematics: **the axiom set in the checker was missing
associativity of $\circ$ and of $\otimes$**. My hand derivations were shallow
enough never to need them, so nothing had caught it. That is what a falsifier
is for, and it paid for itself in one run.

With `ASSOC_COMP` and `ASSOC_TENS` in place the search closes, and the picture
it showed is a theorem.

> **Theorem 11.** Let $N$ have one place $s$ and transitions $T$, all unary
> ($s\to s$). Then in the free commutative monoidal category $C(N)$:
> $C(n,m)=\varnothing$ for $n\ne m$, $C(0,0)=\{*\}$, $C(1,1)$ is the **free
> monoid** on $T$, and $C(n,n)=\mathbb N[T]$, the **free commutative** monoid,
> for every $n\ge2$. In other words $C(N)\cong X$: the spectator category of §5
> is not merely a model, it is the free object.

*Proof.* Every morphism is a composite of padded generators: $f\otimes
g=(f\otimes\mathrm{id});(\mathrm{id}\otimes g)$ reduces a tensor to a
composite, and induction on the term does the rest. Since no generator changes
the token count, $C(n,m)=\varnothing$ for $n\ne m$, and $C(0,0)=\{*\}$ because
no generator has arity $0$.

*Arity 1.* A morphism $1\to1$ cannot use $\otimes$ nontrivially (the other
factor would have arity $0$, and $C(0,0)$ is trivial), so it is a word in $T$,
and the counting model together with $X$ shows distinct words stay distinct.
Hence $C(1,1)=T^*$.

*Arity $\ge2$.* Adjacent padded steps commute:

$$(t\otimes\mathrm{id}_{n-1});(t'\otimes\mathrm{id}_{n-1})
=\bigl((t;t')\otimes\mathrm{id}\bigr)\otimes\mathrm{id}_{n-2}
\overset{\text{Thm 9}}{=}(t\otimes t')\otimes\mathrm{id}_{n-2}
\overset{\text{Lem 1}}{=}(t'\otimes t)\otimes\mathrm{id}_{n-2}
=(t'\otimes\mathrm{id}_{n-1});(t\otimes\mathrm{id}_{n-1}),$$

using interchange at both ends. Adjacent transpositions generate every
permutation, so a composite of padded steps depends only on its multiset of
occurrences; the counting model shows the multiset is a complete invariant.
$\square$

**The mechanism, in one sentence.** Theorem 9 needs an idle strand to act on;
padding by $\mathrm{id}_{n-1}$ supplies one exactly when $n\ge2$, and at $n=1$
there is none. So:

> **Corollary 12 (answer to §6's first question, for this class).** The padding
> $C(n,n)\to C(n+1,n+1)$ is injective for every $n$ **except** $n=1$, where it
> is the abelianisation $T^*\twoheadrightarrow\mathbb N[T]$. All of the
> collective view's forgetting happens in one step, when the second token
> arrives.

`normal_form` is therefore a decision procedure for this class: a word at one
token, a multiset at two or more. The search remains in the module as the
falsifier it was built to be — `test_rewriting_never_crosses_a_normal_form`
verifies that no rewrite from any seed ever reaches a different normal form,
which is what would break if the invariant were unsound.

**What the search does *not* establish.** It is a bounded, one-sided
instrument: within `max_leaves` and a node cap it can fail to connect terms
that the theory does equate (at three occurrences on three strands it does, and
raising the bound to 5 leaves and 3000 nodes leaves 2 of 18 members of one
class unreached at 44 s). Non-connection is never evidence of inequality here;
inequality comes from the models $X$ and $W$ only. Reported so the numbers
cannot be mistaken for a completeness claim.

## 7. What the mechanism was measuring: concurrency

Theorem 11 used unarity twice, and I flagged a transition $2s\to2s$ as the
first case I could not call. Dropping unarity does not break the mechanism. It
says what the mechanism was about.

Let $N$ have one place and arity-preserving transitions $t:k_t\to k_t$.

> **Theorem 13.** Two padded steps commute at $n$ tokens if and only if
> $n\ge k_t+k_{t'}$ — exactly when the marking is large enough to host both
> firings at once.

*Proof (if).* Place the second pad on the left, which costs one application of
Lemma 1, and the two tensor decompositions both become $(k_t,\,n-k_t)$:

$$(t\otimes\mathrm{id}_{n-k_t});(\mathrm{id}_{k_t}\otimes t'\otimes
\mathrm{id}_{n-k_t-k_{t'}})
\;=\;(t;\mathrm{id})\otimes(\mathrm{id};t'\otimes\mathrm{id})
\;=\;t\otimes t'\otimes\mathrm{id}_{n-k_t-k_{t'}},$$

by interchange and units; the same computation in the other order gives
$t'\otimes t\otimes\mathrm{id}$, and Lemma 1 closes the square. The pad
$\mathrm{id}_{n-k_t-k_{t'}}$ exists precisely when $n\ge k_t+k_{t'}$.

*(only if).* The trace model: put on $n$ tokens the free partially commutative
monoid $M_n$ on $\{t:k_t\le n\}$ with $t\leftrightarrow t'$ iff
$k_t+k_{t'}\le n$, tensor $=$ concatenation. This is a commutative monoidal
category. Interchange needs $\pi(y)\pi(u)=\pi(u)\pi(y)$ in $M_{m+n}$ for
$y\in M_n,u\in M_m$, and every letter of $y$ has arity $\le n$ while every
letter of $u$ has arity $\le m$, so each such pair sums to $\le m+n$ and
commutes; Lemma 1's requirement $x\otimes y=y\otimes x$ is the same
computation. Below the threshold the two words differ in $M_n$. $\square$

> **Theorem 14.** Hence $C(n,n)$ is the **Mazurkiewicz trace monoid**
> $$C(n,n)\;=\;M\bigl(\{t:k_t\le n\},\ \ t\leftrightarrow t'\iff k_t+k_{t'}\le n\bigr),$$
> and $C(n,m)=\varnothing$ for $n\ne m$.

*Proof.* Every morphism is a composite of padded generators, and all placements
of a pad are equal by Lemma 1 and associativity, so $C(n,n)$ is generated by
one letter per fitting transition. Theorem 13 supplies exactly the commutations,
and the model supplies no more. $\square$

Theorem 11 is the case $k\equiv1$: free at one token, fully commutative from
two. Corollary 12's "$n=1$ is the only failure" becomes: **the padding
$C(n,n)\to C(n+1,n+1)$ forgets exactly the order of those pairs whose arities
sum to $n+1$.** The forgetting is not one event; it is spread across the
thresholds, one pair at a time.

So the answer to the question this note opened with, which began as "does the
collective view forget which token" and passed through "does it keep only the
counts", is:

> **The collective-token view remembers the order of two firings exactly while
> the marking is too small to run them concurrently.** Collective-token
> semantics is trace semantics whose independence relation is
> resource-disjointness, and causality survives in it only where concurrency is
> impossible.

The machine-checked form of this is the pair
`test_derivation_exists_exactly_at_the_threshold` and
`test_the_same_script_is_refused_one_token_short`: for two binary transitions,
the four-step script goes through at four tokens and the *identical* script is
refused at three, because the two tensor splits are $(2,1)$ and $(1,2)$ and
interchange has nothing to act on. That refusal is the theorem's content, and
it is a control, not a proof — the proof is the model.

## 8. Arbitrary nets: the condition is local, the equivalence is not

Nothing in §7 needed one place, and nothing needed $\partial_0t=\partial_1t$.
For a general net, call a word of transitions a *firing sequence from $a$* if
each letter is enabled where it stands.

> **Theorem 15.** For any net $N$ and markings $a,b$,
> $$C(a,b)\;=\;\{\text{firing sequences }a\to b\}\big/\!\sim,$$
> where $\sim$ is generated by exchanging adjacent letters $t,u$ at a point
> where the current marking $m$ satisfies $m\ge\partial_0t+\partial_0u$.

*Proof.* Each such exchange is Theorem 13's derivation applied at that point:
the two tensor splits align because $m$ dominates both inputs. Conversely the
quotient is a commutative monoidal category — concatenation descends because an
exchange's validity depends only on the marking where it happens, and $\otimes$
descends because tensoring only *adds* tokens, which can enable an exchange but
never disable one; the same observation gives interchange and Lemma 1, since
every letter of one factor meets every letter of the other at a marking
dominating both inputs. Every morphism is a firing sequence, so the induced
functor is a bijection on hom-sets. $\square$

**The condition is local; the equivalence it generates is not.** Take one place
and $p:\varnothing\to s$, $a:s\to s$, $b:s\to s$. At the marking $s$ the
transitions $a$ and $b$ compete, and no exchange of $ab$ is available — their
order is real. Yet

$$ab\,p\;\sim\;a\,p\,b\;\sim\;p\,ab\;\sim\;p\,ba\;\sim\;b\,p\,a\;\sim\;ba\,p,$$

because $p$ needs nothing and so commutes with everything, and once it has been
scheduled first there are two tokens and $a,b$ exchange freely. So §5's
spectator does not have to be *present*: it is enough that it can be
*produced*. The six-element class is computed in
`test_locality_is_not_a_technicality`.

This kills the last plausible simplification — that $C(a,b)$ is a trace monoid
for the independence relation read off the source marking $a$. It is not; it is
a *local* trace object, and §7's clean monoid is exactly the degenerate case
where the marking never changes, so locality cannot be seen.

## 9. Corollary 6 is an object this corpus already owns

Corollary 6 — the boundary relation is strictly finer than the collective one —
was argued by hand in §3. It did not need to be. The boundary relation is the
**compositional crystal** of the two symmetry operations, and
`notes/COMPOSITIONAL_CRYSTAL_THEOREM.md` already proves that object exists, is
the greatest congruence inside the kernel of the observation, carries the
operations, and has a universal factorisation; `machinery/compositional_crystal.py`
already computes it together with a minimum separating context basis. So it is
computed there, not re-argued here.

The algebra is finite and closed with no truncation and no sink: the symmetry
is an involution, so pre- and post-composition generate $(\mathbb Z/2)^2$
acting on the eight terms $\sigma^i x\sigma^j$, $x\in\{f,g\}$. The observation
is the thread invariant $\theta$. `crystallize_algebra` returns:

| | |
|---|---|
| elements | $8$ |
| fibres | $2$, of size $4$ each — **exactly the two boundary orbits** |
| fibre observations | $\{t_1t_1,t_2t_2\}$ and $\{t_1t_2,t_2t_1\}$ |
| invisible equations | $12=2\binom42$ |
| minimum separating context basis | $\mathbf 1$ — one context distinguishes the orbits |

Then `factor_map` is applied to the collective normal form. It **succeeds**,
which is the statement that the collective relation is coarser than the
boundary one; and the two fibres receive the **same** collective value, which is
the statement that it is strictly coarser. That is Corollary 6, computed by the
corpus's runtime under its own universal property rather than asserted by me.
The control is that `factor_map` *refuses* an observation separating two
members of one orbit.

The reading that matters for the corpus: $\mathrm{cdim}=1$ here says one
context suffices to see everything the individual theory distinguishes at this
boundary — and the collective theory does not have that context, because the
context is a symmetry and it has set every symmetry to the identity. **A theory
does not lose information by having fewer objects; it loses information by
having fewer contexts.**

## 10. Queue

Every mathematical item this note opened is closed by construction. What
remains is one obligation that cannot be discharged from inside this container,
stated flatly and with no expectation attached to it.

- **Done, by construction, with pointers:** the fibre of the token-forgetting
  map (§0–§3, refuted and replaced); what the collective view retains (§5,
  refuted and replaced); the one-place unary class (§6, Theorem 11); the
  padding maps (§6, Corollary 12 and §7); non-unary transitions (§7, Theorems
  13–14); several places and non-marking-preserving transitions (§8, Theorem
  15); the decision procedure (`normal_form`, `local_trace_class`); the
  boundary relation as a crystal (§9, computed by
  `machinery/compositional_crystal.py`).
- `SEARCH` — **Trace theory.** Theorems 13–15 reach Mazurkiewicz traces from
  the categorical side. That literature is not in this repository and the
  network paths to it are blocked here. The obligation is to check these
  statements against it before any of them is described as new anywhere. No
  claim is made about the outcome.

## 11. Honesty ledger

| claim | grade |
|---|---|
| Lemma 1 | **proved**, one line from naturality |
| Theorems 2, 3 | **proved**; each step machine-checked as a typed axiom instance |
| Proposition 4 ($W$ is an SSMC) | **proved**; exhaustively re-checked on a finite fragment |
| Theorem 5, Corollary 6 | **proved** by soundness — a model, not a normal-form theorem |
| ~~"collective = occurrence counting" — **conjecture** (§5), two supporting instances~~ | **REFUTED** the same session, §5 Theorem 8 |
| Proposition 7 ($X$ is a commutative monoidal category) | **proved**; exhaustively re-checked on a fragment |
| Theorems 8, 9, Corollary 10 | **proved** — a model, and a checked derivation |
| ~~§6 third conjecture (collapse is complete from two tokens on) — **guess**~~ | **PROVED** for the one-place unary class, §6 Theorem 11; open in general |
| Theorem 11, Corollary 12 | **proved**; the engine derivation is machine-checked |
| Theorem 15 (general nets, local traces) | **proved**; the locality example is machine-computed |
| Theorems 13, 14 (trace monoid) | **proved** — derivation machine-checked, model verified; **not searched for prior art**, see §8 |
| §9 crystal, fibres, `cdim`=1, `factor_map` behaviour | **computed** by `machinery/compositional_crystal.py`, an already-verified corpus construction |
| The bounded rewrite search | **falsifier only** — one-sided, bound-limited; it found the missing associativity axioms and establishes no inequality |
| The `STATEBOX.md` §7 guess | **refuted** here; struck through there |
