# Cubical Bend: the Fibre Law and the Coinductive Computer

## Executable univalence, lossless relational factorization, and the geometry of continuing computation

**The primitive is a lossless change of presentation of a computational object. Its result is another object that can continue computing.**

For every map

$$
f:A\to B,
$$

the whole source has the canonical presentation

$$
\boxed{A\simeq\sum_{b:B}\operatorname{fib}_f(b)},
\qquad
\operatorname{fib}_f(b)=\sum_{a:A}(f(a)=b).
$$

The value $b$ is what the operation exposes. The fibre is the exact realization structure over that value. The total object retains the source, its exposed coordinate, and their relationship. Computational univalence turns the equivalence into a path whose transport executes. Coinduction makes the object persistent: an interaction exposes a response and returns a continuation to which the same mathematics applies again.

**This is a primitive for constructing computations, not a claim that every computation returns only a scalar result.** Values, programs, interpreters, derivations, observation interfaces, and representation changes can all occur as the types and terms to which the construction is applied. The machine can compute with the mathematical organization of its own execution.

The ambition is a **Parallel Univalent Superposition Computer**: a universal symbolic machine, implemented through Cubical Bend and the HVM interaction substrate, in which exact analysis, reconstruction, representation change, shared evaluation, and continuing interaction are internally connected. Its persistent, distributed realization is the operating-system direction of the project, not merely a mathematics application hosted above an unrelated semantic world.

This README develops the mathematics behind that claim. It also makes **optimal relational factorization** precise: retain a shared model and an exact residual; select sufficient presentations relative to admitted continuations; compare certified realizations under an explicit description-length or resource objective. Canonical factorization, minimum description length, and efficient execution are related constructions, not interchangeable definitions.

### Read by purpose

- **The primitive and its proof:** [1–7](#part-i-the-lossless-primitive).
- **Continuing objects and final semantics:** [8–12](#part-ii-the-coinductive-computer).
- **Gcd/lcm over computational observations:** [13–17](#part-iii-relational-factorization-and-gcdlcm).
- **Minimum description length, cost, and self-extension:** [18–24](#part-iv-optimal-realization).
- **What actually runs in Bend/HVM:** [25–29](#part-v-the-bendhvm-realization).
- **Networking, operating systems, and applications:** [30–33](#part-vi-the-persistent-networked-machine).
- **Verification scope and exact source map:** [34–36](#part-vii-verification-and-sources).

The source baseline for this account is [`6a215a121e08f710393f570abfac58513d53eecc`](https://github.com/avikj/metacircular-interaction-prototype/tree/6a215a121e08f710393f570abfac58513d53eecc). Links are relative to this directory unless marked external. The [previous README](README_IMPLEMENTATION_HISTORY.md) is preserved as implementation history; [HANDOFF.md][handoff], [STATUS.md][status], [AUDIT.md][audit], and [port/PORT.md][port] record engineering details. Historical entries in those files are chronological evidence, not independent current guarantees.

The mathematical formulas below use predicative universes $\mathcal U_\ell$, with level joins suppressed where harmless. Literal Bend examples use the target's current `Set` syntax. The distinction matters and is recorded in [Verification scope](#34-what-is-proved-what-is-executed-and-what-is-specified).

---

# Part I. The lossless primitive

## 1. One equality, two bindings

The judgment

$$
f(a)=b
$$

has two dependent readings.

Fix the source $a$. The possible output together with evidence that it is the output forms

$$
C_f(a)=\sum_{b:B}(f(a)=b).
$$

This type is contractible. Its centre is $(f(a),\mathrm{refl})$. Every other pair $(b,p)$ is connected to that centre by its own path $p$ and the appropriate connection square.

Fix the result $b$ instead. The realization type is

$$
R_f(b)=\sum_{a:A}(f(a)=b)=\operatorname{fib}_f(b).
$$

This fibre need not be contractible. It can have several source realizations, nontrivial paths between them, and higher identities. It can also be empty when $b$ is not realized by the map. A completed event originating from an actual $a$ always lies over an inhabited fibre.

The two bindings are not two ontologies. Their total spaces are the same graph reorganized:

$$
\sum_{a:A}\sum_{b:B}(f(a)=b)
\simeq A
\simeq
\sum_{b:B}\sum_{a:A}(f(a)=b).
$$

The first reading says that adjoining determined output does not create an independent choice. The second says exactly what remains unresolved when only the output is exposed.

**Determination and residual information are the two orientations of one dependent relation.**

Sources: [Fibre.Carrier][carrier], [Fibre.Trace][trace], [EkaSutra][ekasutra].

## 2. The entire fibre-law proof

Define

$$
\operatorname{Total}(f)=\sum_{b:B}\operatorname{fib}_f(b).
$$

The forward and backward functions are

$$
\eta_f(a)=(f(a),a,\mathrm{refl}),
\qquad
\rho_f(b,a,p)=a.
$$

One round trip is immediate:

$$
\rho_f(\eta_f(a))=a.
$$

For the other, a point $(b,a,p)$ includes $p:f(a)=b$. The cubical path is

$$
H_{b,a,p}(i)=\bigl(p(i),a,\;j\mapsto p(i\wedge j)\bigr).
$$

At $i=0$, it is $(f(a),a,\mathrm{refl})$. At $i=1$, it is $(b,a,p)$. The inner path always has the correct endpoints, because

$$
p(i\wedge0)=f(a),\qquad p(i\wedge1)=p(i).
$$

Consequently,

$$
\boxed{\eta_f:A\simeq\operatorname{Total}(f)}.
$$

Nothing in this construction enumerates all preimages of $b$. The source realization is already present. Reconstruction is possible because it was retained, not because an inverse search became free.

The executable Bend core, excerpted from [fibrelaw.bend][fibrelaw-bend], is:

```text
def Total(A: Set, B: Set, f: A -> B) -> Set:
  any b: B. fiber(A, B, f, b)

def tot(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  (f(a), a, <_> f(a))

def untot(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  match w:
    case (b, a, q):
      a

def tot_sec(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> Path(Total(A, B, f), tot(A, B, f, untot(A, B, f, w)), w):
  match w:
    case (b, a, q):
      <i> (q @ i, a, <j> q @ iand(i, j))
```

These excerpts use definitions from the source file; they are not standalone programs. The same file constructs coherent equivalence data through `isoToEquiv`, then exposes `losslessPath`, `present`, and `retrieve`.

The conceptual core is small. Its breadth comes from the unrestricted types and maps to which it applies.

## 3. The residual is forced by the actual computation

A conservative presentation consists of

$$
T:B\to\mathcal U,
\qquad
E:A\simeq\sum_{b:B}T(b).
$$

It induces its visible map:

$$
\operatorname{run}(a)=\pi_1(E(a)).
$$

The theorem is

$$
\boxed{T(b)\simeq\operatorname{fib}_{\operatorname{run}}(b)}.
$$

Proof: transport the source of the fibre through $E$:

$$
\operatorname{fib}_{\operatorname{run}}(b)
\simeq
\sum_{s:\sum_{b':B}T(b')} (\pi_1s=b)
\simeq
\sum_{b':B}\sum_{t:T(b')}(b'=b).
$$

Reassociate and transport $t$ along the retained path. The base pair $(b',b'=b)$ is a singleton, so its contraction leaves exactly $T(b)$.

The requirement that the equivalence lie **over the specified map** is essential. An equivalence $A\simeq\sum_bT(b)$ whose first projection is some other function conserves a different computation. It does not certify the desired $f$ merely because the total types happen to be equivalent.

The [Fibre.Trace source][trace] contains both the theorem and an explicit Boolean counterexample to omitting this condition. Its Bend counterparts are `fibreOfRun`, `traceIsForced`, `exactWhenContractible`, and `contractibleWhenExact` in [forcing.bend][forcing-bend].

Therefore,

$$
\operatorname{isEquiv}(\operatorname{run})
\quad\Longleftrightarrow\quad
\prod_{b:B}\operatorname{isContr}(T(b)).
$$

An equivalence has no independent realization ambiguity in its fibres. A general map may. Univalence does not turn a many-to-one projection into an invertible map; it makes its **completed presentation** executable.

## 4. Canonical does not mean physically unique encoding

For a fixed $f:A\to B$, define the type of completions

$$
\operatorname{Lossless}(f)=
\sum_{T:B\to\mathcal U}
\sum_{E:A\simeq\sum_bT(b)}
(\pi_1\circ E=f).
$$

The development identifies this with

$$
\prod_{b:B}\sum_{Z:\mathcal U}
\bigl(Z\simeq\operatorname{fib}_f(b)\bigr).
$$

Each factor is an equivalence-singleton, contractible by univalence. Hence

$$
\boxed{\operatorname{isContr}(\operatorname{Lossless}(f))}.
$$

In particular,

$$
\operatorname{LawfulStep}(A)
\simeq
\sum_{f:A\to A}\operatorname{Lossless}(f)
\simeq(A\to A).
$$

The completion adds no independent mathematical choice to the map. This is the precise force of the statement that the lossless machine is the map carried with its canonical realization structure.

Contractibility is a statement about the complete typed completion space. It does not say that every serializer emits the same bytes, that every implementation has the same time cost, or that every useful representation has been discovered. Different encodings are related inside the mathematical object; their resource observations need not agree.

Source: [Ekatva, especially `lossless-unwound`, `losslessness-is-a-property`, and `lawful-steps-are-the-maps`][ekatva].

## 5. Reversibility conserves the declared whole

Consider exclusive-or:

$$
f(x,y)=x\oplus y.
$$

The result alone has two realizations. A compact complete presentation is

$$
(x,y)\longmapsto(z=x\oplus y,\;x),
$$

with inverse

$$
(z,x)\longmapsto(x,x\oplus z).
$$

The first coordinate remains the original computation. The second is a residual sufficient to reconstruct the source. It need not be a verbatim copy of the entire source: it need only realize the exact fibre family.

This is pure lossless computation in its simplest nontrivial form. The visible projection is many-to-one; the completed event is reversible.

The scope of the retained source is explicit. If the program $f$ itself is variable data whose identity must survive, the source is not just $a:A$ but a package containing $f$ and $a$. The completed event then retains that package. Likewise, conserving an external interaction requires including the relevant environment state or event history in the source contract. A pure function that models only a screen image cannot reconstruct an unrecorded physical action on the strength of the fibre theorem.

There are three distinct inverses:

1. The inverse of a completed presentation recovers its declared source.
2. A reverse constructor can reverse a represented derivation in its proof-relevant calculus.
3. Physically reversing an external process requires the inverse dynamics and the relevant physical state.

The first two are mathematical/programming operations. They do not by themselves reverse heat dissipation, delete information already disclosed to another party, or undo a physical actuator. The operating system must model those effects at their actual interfaces.

**Conservation means that every distinction in the declared whole remains reconstructible—not that every projection is injective or every physical action is undoable.**

## 6. The law preserves higher structure

A homotopy fibre is not merely a set of possible inputs.

Let $u=(a,p)$ and $v=(a',p')$ inhabit $\operatorname{fib}_f(b)$. Then

$$
(u=v)
\simeq
\sum_{\alpha:a=a'}
\bigl(\operatorname{ap}_f(\alpha)\mathbin{\cdot}p'=p\bigr).
$$

An identification in the fibre contains a source identification and the square showing compatibility with the exposed result. Relations among those identifications carry further coherence.

Thus a projection can hide not only which point occurred, but which path, loop, symmetry action, or higher realization occurred. Applying the same construction to induced path maps continues the account at higher dimensions.

This matters computationally. Two implementations can agree as result functions while their derivations have different length, provenance, or transport action. A consumer that only asks for a set-valued endpoint may identify those derivations. Another consumer can inspect the retained route.

Calling the fibre “metadata” understates its role. It is the part of the source that the selected observation does not determine. Depending on the object, that part can be the very input to the next computation.

## 7. Maps, families, composition, and context are one factorization geometry

At appropriate universe levels, the object-classifier equivalence is

$$
\boxed{
\left(\sum_{E:\mathcal U}(E\to B)\right)
\simeq(B\to\mathcal U).
}
$$

A map to $B$ is sent to its fibre family. A family $T:B\to\mathcal U$ is sent to its total space with the projection $\sum_bT(b)\to B$. The fibre law gives one round trip; contraction of the fibre of a dependent projection gives the other. See the standard [cubical fibration library][external-fibration].

Composition stays inside this geometry. For $A\xrightarrow fB\xrightarrow gC$,

$$
\boxed{
\operatorname{fib}_{g\circ f}(c)
\simeq
\sum_{(b,q):\operatorname{fib}_g(c)}\operatorname{fib}_f(b).
}
$$

The forward reconstruction sends $(b,q,a,p)$ to $(a,\operatorname{ap}_g(p)\cdot q)$. The reverse chooses the determined intermediate $b=f(a)$. Path induction supplies the round trips.

For independent maps,

$$
\operatorname{fib}_{f\times g}(b,d)
\simeq\operatorname{fib}_f(b)\times\operatorname{fib}_g(d).
$$

For a local context $h:C\to B$, a family restricts by precomposition:

$$
T\longmapsto T\circ h,
\qquad
\sum_{c:C}T(h(c)).
$$

This is base change, or pullback. Dependent interfaces use dependent versions of these same constructions rather than pretending correlated fields are independent products.

A sequence of interactions therefore does not need an unrelated trace-composition semantics. A local view does not need a separate meaning of “residual.” Their maps determine their fibres; composition and restriction determine how those fibres move.

---

# Part II. The coinductive computer

## 8. A response returns another whole process

A process is not only an input/output function. It can retain a state-dependent ability to answer again.

Let $W$ index states or interfaces. Let $Q(w)$ specify questions at $w$, $O(w,q,w')$ the response data at a successor, and $E(w,q,w',o)$ its proof-relevant event structure. The interaction shape is

$$
\boxed{
\operatorname{ISC}(w)
\simeq
\prod_{q:Q(w)}
\sum_{w':W}
\sum_{o:O(w,q,w')}
E(w,q,w',o)\times\triangleright\operatorname{ISC}(w').
}
$$

The delay notation emphasizes productive continuation. The Agda implementation uses guarded coinductive records; it does not introduce an explicit clock modality with this glyph.

The fields belong together. The answer is typed over the actual question and successor. The event is typed over that answer. The continuation lives at that successor. Incorrectly mixing the state of one branch with the evidence of another does not form the intended dependent object.

The [Samvada module][samvada] defines `react`, `visit`, `continue`, and finite-demand `observe`. It proves that predetermined orbits embed when the environment has only a trivial question, and exhibits a counter whose increment/reset question genuinely changes the next state.

A finite demand of length $n$ unfolds the needed $n$ interactions. It does not request a global normal form of every possible future. Productivity of the continuation and termination of each demanded local operation are the relevant obligations.

## 9. Final coalgebra: the universal property of complete behavior

For an endofunctor $F$, a coalgebra is $c:X\to F(X)$. A final coalgebra has a destructor

$$
\operatorname{out}:\nu F\to F(\nu F)
$$

and a unique compatible unfolding from every $c$:

$$
\operatorname{beh}_c:X\to\nu F,
\qquad
\operatorname{out}\circ\operatorname{beh}_c
=F(\operatorname{beh}_c)\circ c.
$$

In the homotopy formulation, finality is

$$
\operatorname{isContr}\left(
\sum_{h:X\to\nu F}
(\operatorname{out}\circ h=F(h)\circ c)
\right).
$$

**The compatible unfolding is determined; its source realizations need not be.**

For the indexed interaction above, $F$ acts on families $Z:W\to\mathcal U$ by

$$
(FZ)(w)=
\prod_{q:Q(w)}\sum_{w'}\sum_{o:O(w,q,w')}
E(w,q,w',o)\times Z(w').
$$

The generic unfolding takes one supplied step and recursively unfolds its successor. Indexed $M$-types provide a standard setting for this final-coalgebra account; see [Ahrens, Capriotti, and Spadotti][external-mtypes].

A recursive equation $Z\simeq FZ$ alone is not the finality theorem. The compatible-morphism contractibility is the theorem. Nor does a coinductive declaration automatically prove finality for every conceivable functor. This README uses finality where the appropriate construction and hypotheses are supplied; the repository's concrete coinductive programs are identified separately in the source map.

“Final” does not mean last in time. It names the terminal semantic object for a specified one-step interface.

## 10. Canonical behavior plus the exact implementation fibre

Apply the fibre law to the behavior map itself:

$$
\boxed{
X\simeq\sum_{b:\nu F}\operatorname{fib}_{\operatorname{beh}_c}(b).
}
$$

This is the meeting point of final-coalgebra semantics and lossless realization.

Finality determines the map from an implementation to complete behavior. Several implementations can still realize the same behavior. Their difference remains in the fibre. If $X$ is a represented derivation or machine-state space, the fibre can retain routes, internal state, and other distinctions that the behavioral interface identifies.

For a deterministic observed system,

$$
c:X\to O\times X^A,
$$

the final behavior object is $O^{A^*}$, with

$$
\operatorname{beh}_c(x)(w)=o(\delta_w(x)).
$$

A particular machine realizes only the image of that map. For set-valued observations, its quotient by complete future equality is the corresponding minimal realized behavioral machine. The final coalgebra and the image of one machine are not the same object unless that machine realizes every behavior.

A cost receiver need not descend through this behavior map. Two behaviorally equal programs can consume different time. The theory retains both the behavioral coordinate and the realization structure on which such costs depend.

## 11. The state type can change without leaving the machine

The [CorpusSamvada source][corpus-samvada] uses

$$
\operatorname{Point}_\ell=\sum_{A:\mathcal U_\ell}A.
$$

A question at $(A,a)$ contains a target type and an operation:

$$
(B,f),\qquad f:A\to B.
$$

The reaction produces $(B,f(a))$ and continues from that typed point. Programs, operation libraries, syntax trees, interpreters, and interface descriptions can themselves be values in the state.

This generic target update is not automatically a lossless record of the previous point. To execute $f$ losslessly, use the existing question mechanism with

$$
\bigl(\operatorname{Total}(f),\eta_f\bigr).
$$

The resulting state is

$$
\left(\operatorname{Total}(f),\;f(a),a,\mathrm{refl}\right),
$$

and the continuation can inspect the result, the retained realization, or the whole. No additional reaction constructor is required. The completed operation is an ordinary operation supplied to the coinductive machine.

If the machine later changes its signature or observation interface, those changes require their own interpretation and preservation maps. Encoding signatures as data internalizes that work; it does not make unrelated interfaces equal by naming them together.

## 12. Re-presentation commutes with continuing execution

Let $e:X\simeq Y$ and $c:X\to F(X)$. Define

$$
d=F(e)\circ c\circ e^{-1}:Y\to F(Y).
$$

Then

$$
d\circ e=F(e)\circ c.
$$

Both $\operatorname{beh}_d\circ e$ and $\operatorname{beh}_c$ are compatible maps into the final coalgebra. Finality gives

$$
\boxed{\operatorname{beh}_d\circ e=\operatorname{beh}_c}.
$$

The deterministic instance is proved directly in [Fibre.Nucleus][nucleus]. If $\Phi$ is a transition and the carrier change is induced by an observation $f$,

$$
\operatorname{mapO}(\operatorname{carryTransport}_f)
(\operatorname{unfold}(\Phi,a))
=
\operatorname{unfold}(\Phi_{\mathrm{carrier}},\operatorname{descend}_f(a)).
$$

Its proof is corecursive: the head is the transport computation equation; the tail continues the same proof at the next state. It is not a claim inferred from testing a few prefixes.

The [Bend coinduction program][coinduction-bend] gives a complementary equivalence. Given a fixed transition law and initial state, `forgetStates` removes the states and receipts from an execution, and `replay` reconstructs them from the environmental answer stream. Both round trips are corecursive paths.

$$
\operatorname{IExec}(x)\simeq\operatorname{Answers}(x).
$$

When each answer type is contractible, the [silence construction][silence-bend] contracts the entire execution type. There can still be indefinitely much activity; there is simply no independent answer choice. Determined evolution and independently supplied interaction are separated by the actual types.

---

# Part III. Relational factorization and gcd/lcm

## 13. Divisibility of observations

Fix a source $X$. An observation is a map $p:X\to P$. Define the proof-relevant factorization type

$$
\operatorname{Factors}(p,q)=
\sum_{h:Q\to P}(p=h\circ q),
\qquad q:X\to Q.
$$

It retains the decoder and its compatibility path. Taking existence of such a factorization gives the information preorder

$$
p\preceq q
\quad\text{meaning}\quad
\text{$q$ determines $p$}.
$$

This is computational divisibility. A common factor is a view computable independently from either input view. A common refinement is a view sufficient for both.

The gcd/lcm roles are their universal properties:

$$
r\preceq p\wedge q
\iff r\preceq p\;\land\;r\preceq q,
$$

$$
p\vee q\preceq r
\iff p\preceq r\;\land\;q\preceq r.
$$

The order convention is part of the statement. Ordering by refinement in the opposite direction exchanges the names meet and join. In this README, more informative views lie above less informative ones, matching the divisibility order on residue moduli.

For higher types, the full mapping and coherence data should be retained instead of prematurely truncating factorization to a Boolean. Universal properties then concern equivalences of mapping types, not just inequalities.

The [ActionRefinement module][action-refinement] implements this order through the existing descent type and proves the least-common-refinement property directly.

## 14. The lcm of two views is their least joint refinement

Given $p:X\to P$ and $q:X\to Q$, define

$$
j(x)=(p(x),q(x)).
$$

It recovers both coordinates. If $r:X\to R$ recovers them via $h$ and $k$, then

$$
j=\langle h,k\rangle\circ r.
$$

Thus the joint observation has the lcm universal property. At the set-valued level, use its realized image when describing its state space; an arbitrary pair in $P\times Q$ need not come from one source.

Writing $\ker p$ for the indistinguishability relation induced by $p$,

$$
\ker(p\vee q)=\ker p\cap\ker q.
$$

The greatest common quotient, when formed in the set-level setting, has

$$
\ker(p\wedge q)=\operatorname{EqClosure}(\ker p\cup\ker q).
$$

The joint view distinguishes everything either view distinguishes. The common view identifies everything either view already identifies, together with the equivalence consequences.

The proof-relevant gluing object for $f:A\to C$ and $g:B\to C$ is

$$
A\times_C B=\sum_{a:A}\sum_{b:B}(f(a)=g(b)).
$$

Its compatibility witness is part of the object. A source mapping to both sides can still have a nontrivial fibre over this pullback; pairwise compatibility alone does not prove complete reconstruction. In the CRT case below, a theorem identifies exactly when compatibility characterizes the realized joint.

**Generalized gcd/lcm means these universal factorization operations, with their structure retained. It does not mean every computational object is replaced by an integer and fed to Euclid.**

## 15. Non-coprime CRT: overlap, joint realization, and residual

Let $q_n:\mathbb Z\to\mathbb Z/n$ be the residue observation, with positive moduli. Then

$$
q_d\preceq q_n\iff d\mid n.
$$

One direction uses the reduction map. For the converse, $0$ and $n$ agree modulo $n$, so a modulo-$d$ observation factoring through it must identify them: $d\mid n$.

Consequently,

$$
q_m\wedge q_n\simeq q_{\gcd(m,n)},
\qquad
q_m\vee q_n\simeq q_{\operatorname{lcm}(m,n)}.
$$

The generalized Chinese remainder theorem gives

$$
\boxed{
\mathbb Z/\operatorname{lcm}(m,n)
\simeq
\mathbb Z/m\times_{\mathbb Z/\gcd(m,n)}\mathbb Z/n.
}
$$

The gcd is the overlap on which the views must agree. The lcm is the complete compatible joint view.

For $m=4$ and $n=6$, the overlap is modulo $2$ and the joint view is modulo $12$. On a larger source $\mathbb Z/24$, the states $0$ and $12$ have the same pair of readings. The original source is not reconstructed until the two-point residual is retained. These exact finite facts are computed and reflected into paths in [EGBResidueGlue][crt].

For compatible residues $a\bmod4$ and $b\bmod6$, a reconstruction is

$$
x=3a-2b\pmod{12}.
$$

Compatibility means $a\equiv b\pmod2$. Modulo $4$, $3a-2b\equiv a$; modulo $6$, $3a-2b\equiv b$. The compatible pair has a unique solution modulo $12$.

For a source $\mathbb Z/M$ with $\operatorname{lcm}(m,n)\mid M$, the remaining fibre has $M/\operatorname{lcm}(m,n)$ elements. It equals the gcd only in special ambient choices, such as $M=mn$.

### Join saves precisely the duplicated overlap

For positive integers,

$$
\operatorname{lcm}(m,n)\gcd(m,n)=mn.
$$

In prime valuations, the identity is

$$
\max(v_p(m),v_p(n))+\min(v_p(m),v_p(n))
=v_p(m)+v_p(n).
$$

This compares independent accumulation with the least joint requirement. It does not count overlap twice.

A new residue observation updates $L$ to

$$
L'=\operatorname{lcm}(L,n)=L\frac{n}{\gcd(L,n)}.
$$

The additional factor is exactly $n/\gcd(L,n)$. If $n\mid L$, it is $1$: the new observation is already determined.

[LCMExists][lcm] supplies the constructive arithmetic operation and its universal property. [WalkCapacity][capacity] uses that universal property to prove the attained capacity of a bounded sensor family.

## 16. General residual refinement and the limits of scalar arithmetic

For a current view $q:X\to Q$ and new observation $r:X\to R$, fix $u:Q$. The next observation acts on the current fibre:

$$
r_u:\operatorname{fib}_q(u)\to R,
\qquad r_u(x,p)=r(x).
$$

After receiving $v:R$,

$$
\boxed{
\operatorname{fib}_{r_u}(v)
\simeq
\operatorname{fib}_{\langle q,r\rangle}(u,v).
}
$$

The additional information is therefore naturally dependent on the old observation. There need not be one globally independent scalar cofactor.

The operation adds nothing exactly when the new observation descends:

$$
r\preceq q\iff q\vee r\simeq q
$$

at the information-order level. A witnessed collision

$$
q(x)=q(y),\qquad r(x)\ne r(y)
$$

proves that refinement is necessary. `ActionRefinement` retains the two states, the common old view, and the separating action rather than reducing the failure to an unexplained score.

General observation lattices need not be distributive. On three points, the partitions $12|3$, $13|2$, and $23|1$ form a nondistributive sublattice under information refinement. Integer divisibility is distributive. Therefore no injective encoding can preserve both operations of this entire partition lattice as ordinary integer gcd/lcm.

That is why the universal property, rather than a numerical analogy, is the primitive. Depending on the structured presentation, an implementation may use pairing, quotient formation, pullback, a Euclidean algorithm, or another certified construction. A general factorization witness need not be decidable or cheaply discoverable.

The lattice also sees less than a proof-relevant history. Repeating the same observation is idempotent; repeating an operation can still produce a second event, a nontrivial loop, or additional cost. The history stays in the richer object.

## 17. Complete future behavior is the joint of all admitted views

Let

$$
o_w(x)=o(\delta_w(x)).
$$

The complete behavior is the response function

$$
B(x):w\mapsto o_w(x).
$$

In the information order,

$$
\boxed{B\simeq\bigvee_{w\in A^*}o_w},
\qquad
\ker B=\bigcap_{w\in A^*}\ker o_w.
$$

It is the least observation sufficient for every admitted continuation. Its minimal realized presentation is the behavioral quotient, while its fibre retains the original source realizations.

Finite observation windows satisfy the recurrence

$$
B_0=o,
\qquad
B_{n+1}=o\vee\bigvee_{a\in A}(B_n\circ\delta_a)
$$

up to their canonical observational presentation. If the bounded indistinguishability relation is preserved by every action, it already agrees with complete future equality. The [ObservableHorizon module][horizon] proves this condition in both directions through the native congruence interface.

Adding an action can require a strictly finer behavioral presentation. Adding a cheaper implementation of an already admitted action need not change behavior at all, while changing the resource frontier. Capability growth and implementation improvement are distinct changes that the same machine can represent.

For response-conditioned deterministic experiment trees, equality under every fixed word is equivalent to equality under every finite adaptive experiment. The [adaptive adapter][adaptive] proves this at its stated interface. Adaptivity changes the cost of exposing a distinction, not the complete distinction relation. Probabilistic or quantum adaptations require their outcome distributions and state updates in that interface.

**The gcd/lcm account and final-coalgebra account meet here: complete behavior is the universal joint observation, and the original implementation remains its exact realization fibre.**

---

# Part IV. Optimal realization

## 18. What an optimal relational factorizer returns

A relational factorizer should return a usable mathematical object, not only a compressed string or a similarity score.

For a whole $X$ and a selected visible type $Y$, a complete factorization contains

$$
\mathsf{Factor}(X,Y)=
\sum_{T:Y\to\mathcal U}
\left(X\simeq\sum_{y:Y}T(y)\right).
$$

When a particular observation $q:X\to Y$ is required, include the equation that the first projection is $q$. The forced-fibre theorem then determines the residual family up to equivalence.

For a particular source value $x$, the result gives $y$, its residual realization, and an executable inverse reconstructing $x$. For several consumers, it also carries the factorizations that show which operations can run on $y$ alone and which must use the residual.

An optimal result additionally specifies a candidate class, a cost interpretation, and evidence that the selected realization is minimal or nondominated in that class. This is the **optimal relational factorizer contract** developed in this README. The existing fibre, descent, and cost modules supply constituent constructions; the contract is not an assertion that every candidate-space optimizer has already been implemented.

### Why relational is substantive

Two marginal views may share no nonconstant common factor while their joint determines a new observable. Let $x,y$ be two Boolean coordinates. Their common deterministic view over the full four-state source is constant, but their joint determines $x\oplus y$. A factorizer that keeps only commonality loses this relational computation.

The correct object retains common factors, joint structure, compatibility paths, and residuals. Common-factor extraction is not a substitute for the complete relation.

## 19. Minimum description length requires a code and a decoder

For an installed library $K$, let a model code $m$ specify a typed decoder

$$
D_{K,m}:R_{K,m}\to X.
$$

An exact description of $x:X$ is

$$
\mathsf{Desc}_K(x)=
\sum_{m:\mathsf{ModelCode}_K}
\sum_{r:R_{K,m}}
(D_{K,m}(r)=x).
$$

The residual type depends on the model. This is the fibre organization again: the model and residual together realize the data, and the equality is the exact reconstruction contract.

A two-part description-length objective is

$$
L_K(m,r)=L_K(m)+L_K(r\mid m),
$$

with framing, indices, and referenced content charged according to the actual code. A total transmitted package may also include checked evidence, or enough data to reconstruct it; proof storage and verification are charged where the contract requires them.

A locally short pointer is not a universally short description when its referent or dictionary must be sent as well. Conversely, an already installed, identified library can be legitimate shared side information. The receiver's prior state must be specified rather than smuggled into the length function.

This is an exact two-part coding formulation of MDL, not an assumption that all residuals are probability distributions. Stochastic MDL uses a declared probability model to induce a residual code; exact symbolic MDL uses an explicit decoder. See [Grünwald's tutorial][external-mdl] for the established coding principle.

The fibre theorem supplies admissibility and reconstruction. **It does not select the code, language, cost policy, or shortest representative for free.** Those are additional explicit components of the optimization object.

## 20. Optimality is a typed claim, not a synonym for correctness

Let $\mathcal D_K(x)$ be the admitted exact descriptions and $L$ their declared lengths. A globally minimal description consists of

$$
\sum_{d:\mathcal D_K(x)}\prod_{d':\mathcal D_K(x)}L(d)\le L(d').
$$

For a finite nonempty candidate archive with computable lengths, exact minimization is a finite fold. Retaining all tied descriptions preserves their realization differences. For an unrestricted class, a global result needs an appropriate completeness theorem, a lower-bound certificate, or an effective reduction to an exhaustive search.

An unrestricted shortest-program problem is not made decidable by expressing its specification in a type. The useful operational distinction is between a correct candidate, an exact archive-relative minimum, and a certified global minimum over a named space.

This does not make the universal theory weak. It makes the result type say exactly what was obtained. The same language represents the description, its reconstruction, the cost, and its optimality evidence.

Description length is also representation-relative. The [InvarianceConstant module][invariance] formalizes the consequences of supplied bounded-overhead simulations: comparison constants are uniform in the object; they accumulate under composition; and a strict comparison transfers across a two-sided slack $c$ when its margin exceeds $2c$.

Contractibility of a mathematical completion does not turn code length into an intrinsic number independent of a coding machine.

## 21. One history, many resource receivers

A represented derivation is an object before any scalar readout. A receiver supplies the interpretations of its generators and composition. Initiality forces the compatible fold.

The [AdiBija module][initiality] has the essential equations

```text
fold R (done t)        = epsilon_R(t)
fold R (then-step s d) = stepAction_R(s, fold R d)
```

and proves uniqueness of any reading satisfying them. Soundness, length, and signed evaluator integrals are instantiated as receivers of the same derivation.

A resource profile can be

$$
C_H(d)=
\bigl(\mathrm{work},\mathrm{span},\mathrm{memory},
\mathrm{communication},\mathrm{energy},\mathrm{code}\bigr).
$$

Each coordinate needs its actual semantics. Peak memory requires allocation/liveness data. Span requires a dependency graph. Communication depends on placement and previously shared data. Energy requires a hardware interpretation. They are not automatically additive counters of source syntax.

Under componentwise order, realizations can be incomparable. [ParetoCost][pareto] computes the exact example $(120,0)$ versus $(104,32)$ and proves that two monotone scalarizations choose differently. A scalar policy may be supplied; it is not the underlying order.

The full optimizing object is therefore a frontier of **realizations**, not just a set of cost vectors. Equal-cost histories may remain distinguishable by a later receiver.

## 22. Bellman composition retains the optimizing fibre

For finite intermediate states and extended-natural costs,

$$
(K\star L)(a,c)=\min_b(K(a,b)+L(b,c)).
$$

For a continuation value $V$,

$$
\mathcal B_K(V)(a)=\min_b(K(a,b)+V(b)),
\qquad
\mathcal B_{K\star L}=\mathcal B_K\circ\mathcal B_L.
$$

The optimizer must retain witnesses:

$$
\operatorname{Argmin}(K,V,a)=
\sum_b\bigl(K(a,b)+V(b)=\mathcal B_K(V)(a)\bigr).
$$

A finite cost is accompanied by a realizing route when execution is required. An all-infinite row records unreachability, not an executable path manufactured from an arbitrary minimizer index.

The Dirac continuation $\delta_c$ is zero at $c$ and infinite elsewhere. Therefore

$$
\boxed{\mathcal B_K(\delta_c)(a)=K(a,c)}.
$$

Complete continuation observations recover every finite cost-matrix entry. The [full-abstraction module][bellman] proves this and exhibits the difference between locally and continuation-adjusted optimal choices. [DSOMinPlusFinite][minplus] develops the finite min-plus algebra.

Scalar minimization need not preserve path multiplicity, phase, or provenance. Those require the richer receiver or retained argmin fibre. A sum of quantum amplitudes, a probability sum, and a minimum cost are different algebras even when they operate over the same underlying history graph.

## 23. Zero-overhead abstraction and the geometry of execution

For a contractible dependent family,

$$
\left(\prod_a\operatorname{isContr}(P(a))\right)
\Longrightarrow
\sum_aP(a)\simeq A.
$$

The richer presentation contributes no independent semantic choice. Consumers can use its projections without requiring every component to be separately materialized in advance.

There is also an exact algebraic observation. If a nonnegative additive cost is defined on equivalence actions and respects their identity and composition, then

$$
0=c(\mathrm{id})=c(e^{-1}\circ e)=c(e)+c(e^{-1}),
$$

hence $c(e)=0$. A nontrivial additive nonnegative grading cannot live on the invertible semantic action itself.

A realized forward execution followed by its inverse can still have nonzero length. That length belongs to its history, not to an additive invariant of the composite equivalence. Likewise, determined output can require genuine computation even though it is not an independent input.

Thus zero-overhead abstraction has two connected interpretations: the mathematics identifies representational redundancy; the implementation removes unnecessary mediation, repeated work, and materialization without discarding demanded structure.

For $e:A\simeq B$,

$$
(ege^{-1})(efe^{-1})=e(gf)e^{-1}
$$

as the appropriate function path. A compiler can use the identity to eliminate the intermediate round trip. A consumer that needs the represented derivation can still retain it as shared executable data.

A geodesic realization minimizes a declared execution cost within an admissible semantic fibre. With multiple resources, the appropriate object is a Pareto frontier. Neither a semantic equivalence nor its shortest descriptive name guarantees zero physical latency. The substantive target is no compulsory tax for unnecessary representational detours.

## 24. Discovery and installation change future realization space

Let $\mathcal R_K(F)$ be the realizations of demand $F$ available from installed knowledge $K$. A new certified factorization, equivalence, rewrite, or implementation can enlarge that space:

$$
\mathcal R_K(F)\subseteq\mathcal R_{K'}(F).
$$

Under an unchanged cost interpretation, the achievable resource upper set expands. A new frontier can improve strictly while every previous realization remains available. Setup, discovery, checking, and migration costs belong in an end-to-end or amortized comparison.

A conservative new primitive is an old-language body with a new callable name. [ConservativePrimitiveExtension][extension] constructs `unfold` and proves

$$
\operatorname{eval}_{\operatorname{extend}(\alpha,D)}(t)
=
\operatorname{eval}_{\alpha}(\operatorname{unfold}_D(t)).
$$

A specialized implementation requires its own corresponding correctness equation. Naming a body does not assert constant-time execution of that body.

The [intrinsic rewrite module][intrinsic] also represents installation as splicing a new typed delta before a shared existing run. Querying after installation agrees with transporting only the delta through the requested context and reusing the old view.

The operational loop is

$$
\text{interaction}
\to\text{represented result}
\to\text{new lawful operation}
\to\text{changed future computation}.
$$

This is the metacircular contribution: the products of mathematical work become part of the machine's subsequent organization. Validity, usefulness, behavioral novelty, and resource improvement remain separately stated properties.

---

# Part V. The Bend/HVM realization

## 25. Computational univalence makes the factorization act

An equivalence

$$
e:A\simeq B
$$

induces a universe path

$$
\operatorname{ua}(e):A=B.
$$

Transport obeys the corresponding action equation

$$
\operatorname{transport}(\operatorname{ua}(e),a)=e_{\mathrm{forward}}(a).
$$

The exact judgmental versus path-valued computation rule depends on the formulation and the API. The source records which concrete examples close definitionally and which use an explicit path.

For an arbitrary definable family $P:\mathcal U\to\mathcal U'$, the same mechanism gives

$$
\boxed{
\operatorname{act}_P(e):P(A)\to P(B),
\qquad
\operatorname{act}_P(e)=\operatorname{transport}_{P}(\operatorname{ua}(e)).
}
$$

The [EkaSutra operator][ekasutra] is exactly `subst P (ua e)`. The family can package data, operations, laws, stateful interfaces, and programs over those fields. Transport preserves their dependencies rather than changing the data and leaving its consumers stranded.

For $P(A)=A\to A$, the action is conjugation:

$$
f\longmapsto e\circ f\circ e^{-1}.
$$

For a binary operation, it is

$$
m'(x,y)=e\bigl(m(e^{-1}x,e^{-1}y)\bigr).
$$

The [arithmetic transport development][arithmetic-transport] defines ripple-carry addition on canonical digit words independently, then identifies it with transported natural-number addition. The proof identifies the operations; a native implementation can be selected using that identity rather than eagerly converting through an inefficient coordinate system.

Apply this to the fibre law itself:

$$
\operatorname{losslessPath}(f)=\operatorname{ua}(\eta_f).
$$

`present` transports forward, and `retrieve` transports backward. The theorem becomes the running re-presentation. An established equivalence is not merely permission for a programmer to invent a conversion afterward.

## 26. Why the core is cubical

A path is a term varying over a formal dimension:

$$
p=\langle i\rangle t(i),
\qquad p(0)=a,\quad p(1)=b.
$$

Two dimensions describe a square; more dimensions describe higher compatibility. Interval expressions carry De Morgan operations $\wedge$, $\vee$, and reversal. They are not ordinary Boolean decisions: $i\vee\neg i$ need not reduce to $1$ for a symbolic dimension.

The core includes type-directed composition and transport. Partial systems specify values on declared faces; compatibility is required where faces meet. Composition computes the missing face of the relevant open-box problem. Dependent composition follows the changing type family. Glue supports the universe-level computation of equivalences.

A supplied Kan composition structure gives these specified operations. This does not declare every arbitrary closed boundary fillable or every possible filler unique. Higher obstruction remains meaningful where the requested construction is not licensed by the rules or its hypotheses.

A coherent equivalence uses contractible fibres:

$$
\operatorname{Equiv}(A,B)=
\sum_{f:A\to B}\prod_{b:B}\operatorname{isContr}(\operatorname{fib}_f(b)).
$$

A raw pair of inverse functions with two chosen homotopies is not automatically the same record as this coherent equivalence. The port explicitly builds `isoToIsEquiv` and uses the coherent structure for the reverse univalence round trip. See [roundtrip.bend][roundtrip] and [FORCING.md][forcing-doc].

Higher inductive types extend declarations with path constructors and their higher compatibility. A consumer must specify its action on those constructors. In [hit_tree.bend][hit-tree], the size of an associativity path computes to the associativity path of addition:

$$
\operatorname{size}(\operatorname{assoc}(x,y,z)(i))
=
\operatorname{addAssoc}(\operatorname{size}(x),\operatorname{size}(y),\operatorname{size}(z))(i).
$$

The input transformation is consumed as data, and its image transformation is computed. [HITS.md][hits] describes the declaration schema and generated eliminators.

External foundations: [CCHM cubical type theory][external-cchm] and [higher inductive types in cubical type theory][external-hits].

## 27. Interaction Calculus supplies execution with explicit sharing

Taelin's Interaction Calculus extends the lambda-calculus setting with labelled duplication and superposition. Its central interactions are

$$
\mathrm{APP}\bowtie\mathrm{LAM},\quad
\mathrm{DUP}\bowtie\mathrm{SUP},\quad
\mathrm{APP}\bowtie\mathrm{SUP},\quad
\mathrm{DUP}\bowtie\mathrm{LAM}.
$$

Application consumes an abstraction. Matched duplication/superposition routes corresponding branches. Application across superposition propagates into the branches. Duplication across abstraction creates distinct entrances into shared unfinished body structure.

This is not only memoization of completed calls. The graph can retain common higher-order computation while separate inputs arrive. Labels determine whether choices are correlated or independent. See the upstream [Interaction Calculus specification][external-ic].

Cubical operations are higher-order terms on that engine. A type line, its transporter, a represented proof, and a continuation can remain subjects of reduction and sharing.

The [supline.bend example][supline] makes the composition explicit:

```text
def supLine() -> Interval -> Set:
  lambda i. &0{negPath() @ i, Bool}

def main() -> &0{Bool, Bool}:
  coe(lambda i. supLine()(i), i0, i1, &0{True, True})
```

The logical result is `&0{False, True}`. The two uses of label `0` correlate each value with its corresponding type line. The full runtime implements this instance through the existing match/superposition and labelled duplication behavior; the example's source records that no additional bespoke full-runtime rule is required there.

Symbolic superposition is not a physical quantum amplitude. Linear combinations, probabilities, proof-relevant branches, and labelled IC sharing have distinct algebras. They can all be represented and computed, but one cannot be substituted for another merely because it has several alternatives.

Mathematical factorization identifies legal common structure. The graph machinery shares the represented computation. Neither automatically discovers every semantic equality or attains every hardware-resource optimum.

## 28. What the full target retains

The full target is

```text
--to-hvm4-full
```

The [runtime account][runtime] describes a generated HVM program containing representations for dimensions, paths, types, transport, composition, and the relevant higher constructors. The cubical prelude implements the type-directed operations over that data. It is not a new CPU instruction for every mathematical theorem.

| Mathematical operation | Current source-level realization | Main evidence |
|---|---|---|
| Fibre formation and totalization | `fiber`, `Total`, `tot`, `untot`, `totalEquiv` | [fibrelaw.bend][fibrelaw-bend] |
| Executable univalent presentation | `losslessPath`, `present`, `retrieve` | [fibrelaw.bend][fibrelaw-bend] |
| Forced residual of a conservative map | `fibreOfRun`, `traceIsForced` | [forcing.bend][forcing-bend] |
| Inverse obtained from contractibility | `exactWhenContractible`, executed `runInverse` | [forcing_run.bend][forcing-run] |
| Correlated transport | superposed universe line plus labelled values | [supline.bend][supline] |
| Continuing execution | `Answers`, `IExec`, `replay`, `forgetStates` | [coinduction.bend][coinduction-bend] |
| Dependent contraction of continuing behavior | `answersUnique`, silence theorem | [silence.bend][silence-bend] |
| Higher constructors and consumers | `type ... path`, `hrec`, `helim` | [HITS.md][hits] |
| Behavioral quotient and its elimination | ported minimal-machine modules | [port/PORT.md][port] |
| Native operation installation | ported controlled grammar and derivations | [port/PORT.md][port] |

The patch, rather than loose compiler-source copies in this directory, is the compiler change set. The [handoff][handoff] records how to apply it to the Bend2 base and the dependencies needed by that build.

The erased and normalized targets remain useful comparison points. They implement a different readout policy: information unavailable to their emitted program cannot be inspected later merely because it existed in the source. The full target is the relevant one when paths and residual structures remain active computational data.

At the cited baseline, [RUNTIME_FULL.md][runtime] also records symbolic-endpoint limitations. [AUDIT.md][audit] records `Set : Set`, explicit parameters, and conversion differences. These boundaries belong in any claim about the implementation; the mathematical theory below and above is not a claim that every target-level case has an independently proved simulation theorem.

## 29. Run the actual objects

### With the patched binaries already available

From the repository root, set absolute paths to the patched Bend binary and HVM4 binary:

```bash
export BEND=/absolute/path/to/patched/bend
export HVM4=/absolute/path/to/hvm
export LC_ALL=C.utf8
export LANG=C.utf8

cd collab/bend2-cubical

# The checker suite includes registered definitions that MUST fail.
bash suite.sh "$BEND"

# Positive examples: checks plus evaluation in the patched frontend.
"$BEND" fibrelaw.bend --total
"$BEND" coinduction.bend --total
"$BEND" silence.bend --total

# Emit the computational object without pre-normalizing it into a result.
"$BEND" fibrelaw.bend --to-hvm4-full > /tmp/fibrelaw.hvm4
"$HVM4" /tmp/fibrelaw.hvm4 -s

"$BEND" supline.bend --to-hvm4-full > /tmp/supline.hvm4
"$HVM4" /tmp/supline.hvm4 -s

"$BEND" coinduction.bend --to-hvm4-full > /tmp/coinduction.hvm4
"$HVM4" /tmp/coinduction.hvm4 -s
```

`bend check` is not the command recorded for this port. The frontend takes a file. `--total` is a separate admission gate; emission should not be confused with a whole-program safety certificate. The [suite script][suite] documents its registered negative probes.

Logical results for the checked-in `main` definitions include:

| Program | Observation | Logical result |
|---|---|---|
| `fibrelaw.bend` | forward presentation of Boolean negation | `False` |
| `supline.bend` | correlated transport through two type lines | `&0{False, True}` |
| `coinduction.bend` | five alternating increment/reset answers | `1` |
| `silence.bend` | the recorded deterministic counter observation | `4` |
| `hit_tree.bend` | size through an associativity path | `4` |

Concrete HVM constructor printing may differ from these human-readable logical values. Use `-s` for runtime statistics and compare like-for-like observations, not a full normal-form print against a demand for one result.

The full-runtime execution of the forcing theorem is documented in [FORCING.md][forcing-doc]. Those records include inverse construction from a contractible trace. The theorem's computational fields, including coherence operations, are being consumed on the net.

### Rebuilding the port

[HANDOFF.md][handoff] is the detailed build guide. A robust start preserves the repository path before entering the separate compiler checkout:

```bash
ROOT=$(git rev-parse --show-toplevel)
git clone https://github.com/DKormann/Bend2 /tmp/Bend2
cd /tmp/Bend2
git checkout f026483

git apply --check "$ROOT/collab/bend2-cubical/cubical-paths.patch"
git apply "$ROOT/collab/bend2-cubical/cubical-paths.patch"
```

Then configure the local HVM3 and `hs-highlight` packages, C compiler, and compatible GHC/Cabal toolchain as recorded in the handoff. The checked-in project has historical environment-specific workarounds; do not apply dependency changes blindly to an already configured installation. Verify `git apply --check` rather than silently accepting a partly applied patch.

Build HVM4 according to its own checked-out source and record that commit too. A benchmark report should identify the compiler patch, upstream source revisions, compiler flags, machine, observation, and emitted target.

Printing a recursive function as a complete value can demand infinite expansion. Consuming it at a finite input is a different computation. Do not classify a productive object as broken merely because a normal-form printer was asked to print its entire unbounded unfolding.

---

# Part VI. The persistent networked machine

## 30. Distributed interaction exchanges the missing distinction

Suppose a receiver possesses $k(x):K$ and requires $o(x):O$. A message function $m:X\to M$ is sufficient if there is a decoder

$$
d:K\times M\to O
$$

with

$$
\boxed{d(k(x),m(x))=o(x)}.
$$

If $o=h\circ k$, no additional source-dependent information is required to determine the output. Control messages, authentication, acknowledgments, and physical routing can still have costs. If $k(x)=k(y)$ but $o(x)\ne o(y)$, a correct interaction must preserve that distinction in its new contribution or already retained side information.

When the message type depends on the receiver's state, use a dependent family rather than an unrelated Cartesian payload. The fibre law is already designed for that interface.

Two peers need not hold identical complete memory images. A shared equivalence or decoder can relate their local presentations. For $e_i:M\simeq R_i$, translations are derived through the common middle:

$$
T_{ij}=e_j\circ e_i^{-1},
\qquad T_{jk}\circ T_{ij}=T_{ik}
$$

with the corresponding paths. A common mathematical middle is not a mandatory central physical server.

Nor must all computation be serialized into one global history. Independent operations may proceed locally; noncommuting operations retain their order and their conflict or coherence data. Actual distributed execution additionally needs its resource, failure, and authority contracts. Mathematical equivalence is not authentication, and a locally held reconstruction witness is not a permission to disclose it.

The lossless requirement is compatible with privacy: a participant can retain a private fibre while exposing only an authorized view. Exact reconstruction of the whole need not be available to every observer.

## 31. The VM becomes the operating-system architecture

The VM is virtual relative to its hardware realization. It need not be secondary relative to the applications inhabiting it.

The native object can include a suspended process, its current state, represented code, a derivation, a transformation, and the dependent interface through which it continues. Persistence, execution, inspection, migration, scheduling, and communication become operations on that retained object.

The intended OS does not repeatedly force a living computation to become a dead interchange file merely to keep it or hand it to another program. A filesystem can be one view; a debugger another; a spatial interface another. Their observations have declared scope and residuals.

Updating the system can itself be a typed transformation of state and operations. Corecursive transport addresses the relation between continuing executions before and after the change. Conservative extension addresses newly installed operations. Resource receivers govern where and how execution occurs.

The smallest trusted foundation still has to enforce its actual rules. Hardware isolation, durable storage, cryptographic identity, finite resources, device control, and crash recovery require concrete implementations. Expressing their policies within the language internalizes their semantics; it does not eliminate their physical obligations.

**The OS direction is a persistent computational world whose own transformations remain available as computational objects.** Its evolution can be internal without requiring every future service to become a new trusted primitive.

## 32. Harmonic and symbolic analysis produce executable structure

A mathematical analysis can identify a representation in which a computation decomposes.

For an equivalence $e:X\simeq Y$ and an operation $T:X\to X$,

$$
T_Y=e\circ T\circ e^{-1}.
$$

In a harmonic representation, this can expose independent modes or blocks. For a finite cyclic shift, the discrete Fourier transform conjugates the shift to diagonal multiplication by roots of unity. Compositions then act modewise; the inverse transform reconstructs the original object.

The gain depends on the request and on the cost of obtaining and using the representation. A formula for a diagonalization is not automatically a free algorithm for discovering it. Once available, its equivalence and operation equations are executable knowledge rather than a report awaiting manual translation into code.

For symbolic music, a simple exact instance is

$$
(x_0,\ldots,x_n)
\longmapsto
\left(x_0,\;x_1-x_0,\ldots,x_n-x_{n-1}\right).
$$

Cumulative summation is the inverse. The interval pattern exposes transposition-invariant structure; the starting pitch is a reconstruction coordinate. Rhythm, voice, spelling, and articulation remain additional fields of a fuller musical object.

Relations among transformations also compute. For pitch transposition $T_k(p)=p+k$ and inversion $I_c(p)=2c-p$,

$$
T_k\circ I_c=I_c\circ T_{-k}.
$$

An analysis can return the transformation and this compatibility, not only a similarity score. That result can become an operation used in subsequent analysis.

The same language can therefore be an analytical engine and a generative instrument. Analysis exposes a presentation; synthesis follows an inverse or another lawful operation through it.

## 33. Quantum and relational examples expose why fibres matter

For the qubit family

$$
|\psi_\phi\rangle=
\frac{|0\rangle+e^{i\phi}|1\rangle}{\sqrt2},
$$

computational-basis probabilities are always $(1/2,1/2)$. After a Hadamard transformation, they become

$$
\left(\cos^2\frac\phi2,\sin^2\frac\phi2\right).
$$

The first observation is insufficient for the second continuation. The relative phase lives in the first observation's residual. This is an exact algebraic instance of continuation-relative sufficiency, not an argument that probabilities should never be used.

A reduced density operator is similarly sufficient for its declared local measurements but not for arbitrary renewed access to correlations with the omitted subsystem. Tensor-network gauges can change local factors without changing the contracted state. A non-Clifford operation can require leaving a compact stabilizer representation. Each case asks for an actual preservation, descent, or reconstruction witness at the intended interface.

A pure mathematical description can retain an exact phase or derivation. Physical measurement, finite precision, environmental loss, and unknown-state no-cloning constraints belong to their own specified process models. The logical fibre law does not supply a forbidden physical operation on an unknown quantum state.

These examples demonstrate the force of a universal computational language: a new application supplies its state, transformations, observations, and cost algebra. The fibre/coinductive machinery then operates on those objects without replacing their physics or domain semantics with a generic score.

---

# Part VII. Verification and sources

## 34. What is proved, what is executed, and what is specified

The strength of the architecture depends on retaining the scope of each claim.

| Kind of statement | What establishes it | Scope in this README |
|---|---|---|
| The fibre decomposition and forced-residual laws | Explicit terms in the Agda development; corresponding Bend constructions | The named types, maps, paths, and universe assumptions |
| Contractibility of the completion space | `Ekatva` and its imports | Completions over the fixed visible map, not arbitrary serializers |
| Whole-process transport | Corecursive terms such as `Nucleus` | The stated indexed/coinductive objects |
| Final-coalgebra semantics | A compatible-morphism contractibility theorem for the specified functor | Standard mathematical account; not inferred solely from a recursive datatype declaration |
| Behavioral sufficiency | Descent and congruence witnesses | The admitted observation and continuation interface |
| Gcd/lcm over observations | Actual factorization order and universal constructions | Integer arithmetic is one instance, not the encoding of every higher object |
| MDL optimum | A coding model, exact decoder, search scope, and minimality certificate | A precise factorizer specification; constituent primitives are source-linked |
| Runtime execution | Emitted programs and recorded observations on a particular binary | The runs recorded in the engineering documents |
| Whole compiler soundness or optimal hardware performance | A separate metatheorem or exhaustive performance contract | Not inferred from a passing example suite |

The Agda mathematical core cited here uses its declared cubical library and safety options. The target audit explicitly records unstratified `Set : Set`, conversion differences, and a syntactic totality/productivity classifier. These are not identical metatheoretic contracts. A port can execute substantial constructive mathematics without a passing target checker establishing consistency of the entire implementation.

The full-runtime notes retain symbolic-endpoint caveats. The engineering records also contain superseded stages, competing historical HIT syntaxes, and different recorded file counts. Follow the actual source, the current schema, and the suite for the checkout being used; do not combine historical counts into a release guarantee.

This README was written from source inspection and recorded execution evidence. It does not claim a new successful GHC/Agda/HVM build performed while drafting it. The local validation accompanying the documentation checks its finite worked examples and Markdown structure, not the compiler metatheory.

## 35. Worked invariants to preserve when extending the system

A contribution should state its source object, visible map, retained family, reconstruction map, and the equations relating them. If it changes the declared observation or continuation family, that change must be visible in the type or contract.

For a proposed optimization, identify the semantic interface and the resource receiver. A smaller printed term is not automatically a cheaper evaluation. A smaller behavioral state is not automatically the least code description. A faster core computation is not automatically a faster end-to-end result after conversion and communication.

For a new runtime rule, positive examples should be paired with rejected wrong boundaries, wrong correlations, or wrong dependent indices. Successful frontend normalization and successful full-runtime execution are separate observations and should agree at the requested readout.

For continuing objects, test finite demanded observations and prove the coinductive relationship where required. Do not replace a claimed whole-process equation by an arbitrary finite testing horizon. Conversely, do not demand infinite materialization merely to observe one productive step.

For a new factorizer, retain the decoder and reconstruction certificate. Name its candidate grammar, installed dictionary, and cost model. Report whether its result is correct, archive-minimal, Pareto-nondominated, or globally certified. They are not synonyms.

For a new interface to the physical world, state what is observed, what is retained locally, what is transmitted, and what irreversible effects occur. A lossless local representation does not imply universal access, universal reversibility, or permission to act.

These rules preserve the project's central objective: **the mathematical claim and the executable object should be the same identified construction, rather than prose attached to an unrelated implementation.**

## 36. Source map and terminology

### Mathematical sources

| Source | Relevant object or theorem |
|---|---|
| [Fibre.Carrier][carrier] | Determined enrichment, carrier equivalence, transport, one-step square |
| [Fibre.Trace][trace] | `Conservative`, `fibre-of-run`, `trace-is-forced`, canonical completion |
| [Ekatva][ekatva] | Contractible completion space; lawful steps equivalent to maps |
| [EkaSutra][ekasutra] | Singleton contraction, derived identity elimination, generic transport of structure |
| [Samvada][samvada] | Indexed interactive coalgebra, finite demand, fixed-orbit specialization |
| [CorpusSamvada][corpus-samvada] | Universe-indexed state and representation-changing questions |
| [Nucleus][nucleus] | Corecursive transport of complete deterministic trajectories |
| [ActionRefinement][action-refinement] | Least common refinement and witnessed reopening |
| [EGBResidueGlue][crt] | Mod-4/mod-6 compatibility, hidden mod-24 fibre, mod-12 reconstruction |
| [LCMExists][lcm] | Constructive finite lcm with its universal property |
| [WalkCapacity][capacity] | Attained observation capacity from universal properties |
| [ObservableHorizon][horizon] | Bounded congruence closure equivalent to complete future sufficiency |
| [AdaptiveResidualAdapter][adaptive] | Complete fixed-word and adaptive-trace equivalence |
| [AdiBija][initiality] | Unique receiver folds of generated derivations |
| [IntrinsicRewrite][intrinsic] | Intrinsically typed runs, contextual reweaving, incremental installation |
| [ConservativePrimitiveExtension][extension] | Signature extension and evaluation-preserving unfolding |
| [Transport][arithmetic-transport] | Native digit arithmetic identified with transported arithmetic |
| [InvarianceConstant][invariance] | Explicit comparison slack under bounded-overhead simulations |
| [ParetoCost][pareto] | Resource antichain and scalar-policy dependence |
| [DSOContinuationFullAbstract][bellman] | Dirac reconstruction, cost full abstraction, proof-relevant argmin |
| [DSOMinPlusFinite][minplus] | Finite min-plus relations and composition |

### Executable and engineering sources

| Source | Purpose |
|---|---|
| [fibrelaw.bend][fibrelaw-bend] | The full fibre-law construction as executable Bend |
| [forcing.bend][forcing-bend] and [forcing_run.bend][forcing-run] | Forced residual and theorem-derived inverse execution |
| [coinduction.bend][coinduction-bend] | Corecursive replay and both round trips |
| [silence.bend][silence-bend] | Dependent contraction of deterministic interaction |
| [supline.bend][supline] | Native correlated transport through superposition |
| [hit_tree.bend][hit-tree] and [HITS.md][hits] | Higher constructors and executable elimination |
| [RUNTIME_FULL.md][runtime] | Runtime representation, evidence, and caveats |
| [FORCING.md][forcing-doc] | Recorded full-runtime observations of the fibre theorems |
| [port/PORT.md][port] | Module-to-module port inventory; counts include imports |
| [AUDIT.md][audit] | Language feature coverage and metatheoretic differences |
| [HANDOFF.md][handoff], [STATUS.md][status], [suite.sh][suite] | Rebuild instructions, chronological status, regression probes |
| [cubical-paths.patch][patch] | Compiler and full-runtime implementation changes |

### Names for the different scopes

**Fibre law** names the canonical presentation of a map by its dependent realization family.

**Coinductive interaction calculus** names the state-indexed continuing process and its observable evolution.

**Univalent realization calculus** is a descriptive name for the combined use of executable equivalence, complete events, and transformations of computational realizations. It is not a replacement attribution for the established lambda or Interaction Calculus.

**Optimal relational factorizer** names the certified model/residual and resource-minimization contract, relative to a declared description system, continuation, and realization class.

**Parallel Univalent Superposition Computer** names the architecture that executes these objects with explicit higher-order sharing and correlated branching.

**Cubical Bend** names this language/compiler port. **HVM** is the underlying interaction-machine realization. The **operating-system** direction sustains persistent computation, storage, resource use, communication, and human interaction through these native objects.

### Attribution and mathematical lineage

The fibre decomposition, dependent type theory, univalence, coinduction, categorical universal properties, gcd/lcm, CRT, MDL, and Bellman algebra have established mathematical histories. This work develops their particular executable organization, source-level constructions, and integration into a persistent symbolic computer. A standard theorem does not become newly invented because it is ported; neither does using a standard theorem make its systems realization automatic.

Avik Jain's project supplies the fibre/coinductive computational organization and its formal development. Taelin and the HigherOrderCO work supply the Interaction Calculus and HVM lineage on which the Bend realization is built. Voevodsky's univalence and the cubical work of Cohen, Coquand, Huber, Mörtberg, and others supply the constructive higher-dimensional foundation. The source files record more local dependencies and attributions.

The foundational sources linked below support those respective mathematical and implementation claims. The worked derivations in this README are explanations of the specified constructions, not new machine-checked declarations unless an exact source symbol is named.

---

## The whole in one equation and one continuation

$$
\boxed{
A\simeq\sum_{b:B}\operatorname{fib}_f(b)
}
$$

The exposed result and its exact residual are one lossless presentation.

$$
\boxed{
\operatorname{react}:
\operatorname{Process}(w)\to
\prod_{q:Q(w)}
\sum_{w'}\sum_o
\operatorname{Event}(w,q,w',o)\times
\triangleright\operatorname{Process}(w')
}
$$

The next interaction produces another whole process.

Everything else is a construction over those objects: factorization, reconstruction, observation, higher identity, abstraction, common refinement, behavioral meaning, model selection, resource evaluation, installation, and distributed execution.

**The result remains available. The relation remains available. The computation continues.**

<!-- Reference definitions: paths are relative to collab/bend2-cubical/. -->

[carrier]: ../../fibre/src/Fibre/Carrier.agda
[trace]: ../../fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda
[ekatva]: ../../formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda
[ekasutra]: ../../formal/cubical/theorems/grammar/EkaSutra_JTheGraphAndTheFundamentalTheoremAreInstancesOfSingletonContractionSoAuthorsRetireIntoInstantiation.agda
[samvada]: ../../fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda
[corpus-samvada]: ../../fibre/src/Fibre/CorpusSamvada.agda
[nucleus]: ../../fibre/src/Fibre/Nucleus.agda
[action-refinement]: ../../formal/cubical/theorems/lattices/ActionRefinement.agda
[crt]: ../../formal/cubical/EGBResidueGlue.agda
[lcm]: ../../formal/cubical/theorems/number/LCMExists.agda
[capacity]: ../../formal/cubical/theorems/walks/WalkCapacity.agda
[horizon]: ../../formal/cubical/theorems/automata/ObservableHorizon.agda
[adaptive]: ../../formal/lean/Pairfield/AdaptiveResidualAdapter.lean
[initiality]: ../../formal/cubical/kernel/AdiBija_TheKernelIsInitialEveryReadingIsItsUniqueFoldSoAllPathsThroughASystemAreEnumeratedByOneRecursor.agda
[intrinsic]: ../../formal/cubical/kernel/IntrinsicRewrite.agda
[extension]: ../../formal/cubical/theorems/physics/ConservativePrimitiveExtension.agda
[arithmetic-transport]: ../../formal/cubical/theorems/cost/Transport.agda
[invariance]: ../../formal/cubical/theorems/automata/InvarianceConstant.agda
[pareto]: ../../formal/cubical/theorems/cost/ParetoCost.agda
[bellman]: ../../formal/cubical/theorems/walks/DSOContinuationFullAbstract.agda
[minplus]: ../../formal/cubical/theorems/unplaced/DSOMinPlusFinite.agda
[fibrelaw-bend]: fibrelaw.bend
[forcing-bend]: forcing.bend
[forcing-run]: forcing_run.bend
[coinduction-bend]: coinduction.bend
[silence-bend]: silence.bend
[supline]: supline.bend
[roundtrip]: roundtrip.bend
[hit-tree]: hit_tree.bend
[hits]: HITS.md
[runtime]: RUNTIME_FULL.md
[forcing-doc]: FORCING.md
[port]: port/PORT.md
[audit]: AUDIT.md
[handoff]: HANDOFF.md
[status]: STATUS.md
[suite]: suite.sh
[patch]: cubical-paths.patch
[external-fibration]: https://github.com/agda/cubical/blob/v0.9/Cubical/Functions/Fibration.agda
[external-cchm]: https://arxiv.org/abs/1611.02108
[external-hits]: https://arxiv.org/abs/1802.01170
[external-mtypes]: https://hott.github.io/M-types/
[external-mdl]: https://arxiv.org/abs/math/0406077
[external-ic]: https://github.com/HigherOrderCO/HVM4/blob/main/docs/theory/interaction_calculus.md
