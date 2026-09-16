# Lossless interaction, observation, and exact geodesics

Persistent theorem ledger / transcription handoff — 2026-09-16, revision 3.

## Working edge and evidence convention

The working question is Avik's original one: computational irreducibility as native evolution attaining a geodesic, and what the resulting interaction geometry says about deterministic versus nondeterministic computation. Neither P=NP nor P!=NP is a target assumption. The construction is the lossless interaction calculus, not an application-specific problem-solving component. Preserve the whole dependent object; use its existing constructions before introducing another vocabulary.

This revision replaces incorrect inferences in the earlier assistant-written ledger. Earlier versions remain in Git history at ed8e26332c6926efa83e03cc924b8c3f5e074492 and 8b02225e1ca128e72f3509b51ff3bed0a2950ba9. In particular, do not transcribe their assertion that positive computational cost can occur only in noninvertible transformations.

Source snapshot inspected: 8b02225e1ca128e72f3509b51ff3bed0a2950ba9. Source terms were read; Agda was NOT run in this session. SOURCE below means a declaration and its implementation were inspected. DERIVED means the mathematical proof is given here for later transcription, not that a new checked module has been installed or that the result is historically novel. INTERFACE means an additional specifically named hypothesis is required. No theorem below claims a standard P/NP resolution.

The principal completed result of this revision is G3: the rope transformation bringing cell n to the head has minimum crossing length exactly n. Its proof is a direct composition of the repository's crossing equations, prefix-continuity theorem, and injectivity of the quarter-turn. It is reversible and has positive geodesic length. This simultaneously gives the requested concrete irreducibility theorem and fixes the previous conflation of information loss with execution cost.

## Source manifest

All paths below are relative to the repository root at the snapshot above. These are source anchors, not assertions that every sentence in a module's explanatory header is a checked theorem.

**S1 — forced completion.** `fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`: `Conservative`, `fiberize`, `canonical`, `fibre-of-run`, `trace-is-forced`, `canonical-run`, `canonical-recovers`.

**S2 — classifier.** `fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda`: universal family, canonical pullback, classifier, `invisible≃contractible`, finite tower flattening. The classifier is universal at the stated universe levels; it is not an assertion that inequivalent types become equal or that encodings preserve operational cost without structure.

**S3 — truncation fibre.** `fibre/src/Fibre/Avaccheda_TheTruncationsFibreIsTheWholeSourceSoTheSeamConjectureIsATheorem.agda`: `अवच्छेदः` (avaccheda), explicitly `fiber |_| p ≃ A`.

**S4 — composite fibre.** `punaragamana/src/Punaragamana/SamyogaSesa_TheResidualOfACompositeIsTheResidualOfTheResidual.agda`: `संयोगशेष` (samyoga-sesa), the fibre-of-composite equivalence.

**S5 — coinductive histories.** `formal/cubical/theorems/residue/Prasna_TheMachineThatAsksItsRunIsItsAnswerStreamAndSilenceOfQuestionsIsDeterminism.agda`: `Interaction`, `IExec`, `Answers`, `forgetStates`, `replay`, `run-is-answers`, `silence-is-determinism`. The last theorem is a sufficient condition, not an unrestricted iff about every state in every interaction.

**S6 — interactive coalgebra.** `fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda`: `ISC.react`, `det-observe`, `det-strategy-independent`, `counter-demand-matters`.

**S7 — the crossing equations.** `formal/cubical/theorems/physics/AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce.agda`: `Rajju`, `saṃyoga`, `veṇī∞`, `veṇī-sūtra`, `dūra-sūtra`.

**S8 — prefix locality.** `formal/cubical/theorems/physics/SthairyaSutra_EveryCrossingIsOneLipschitzWithUnitLookaheadSoEveryWordIsUniformlyContinuousWithModulusItsLength.agda`: `kartana`, `kartana-hrāsa`, `veṇī-sthairya`, `śabda-sthairya`, `catur-sthairya`.

**S9 — finite order.** `formal/cubical/theorems/physics/AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid.agda`: `gāḍha`, off-pair locality, `aṣṭa-cakra∞`, `na-catuṣka∞`. Quarter-turn identities are imported there from `CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare`.

**S10 — grading versus inverse.** `formal/cubical/theorems/grammar/Laghava_TheCostAndTheInverseCannotCoexistSoNoNontrivialGroupIsGradedAndTransportHasNoPrice.agda`: `Matra` is an exactly additive natural-valued grading; `Laghava` additionally detects the unit. Read those fields, not an unrestricted interpretation of the title.

**S11 — reconstruction direction.** `formal/cubical/theorems/logic/NKSUnivalence_CoordinatizationIsAPathTheMergeIsATruncationWithNoSectionAndTheBoundedObserverSeparatesNoCoTerminalRuns.agda`: `निर्देशान्तर` is a path of structured systems; `पुनरुद्धार-नास्ति` refutes `sel(|r|)=r`, a LEFT inverse of truncation. Its type does not refute selecting any one representative of an inhabited fibre.

**S12 — sections.** `formal/cubical/theorems/physics/Varanam_ASectionIsAChoiceOfReceiptEverywhereAndForALossyMapTheChoiceIsReal.agda`: the type `(b:B) -> fiber f b`, contractible for an equivalence, with two distinct sections of Bool -> Unit.

**S13 — uniqueness, not a time bound.** `formal/cubical/theorems/residue/Anveshana_TheMiddleGradeIsWhereAnAlgorithmHasContentBecauseUniquenessIsFreeAndExistenceIsTheWork.agda`: propositional fibres identify any two hits. Its closing scope note explicitly says that no notion of algorithm, cost, or decidability is proved there.

**S14 — native work discipline.** `formal/cubical/theorems/cost/CountedDigitsEdge.agda`: cost is threaded through the execution being priced; an exact carry identity relates the count to the same recursion. This is a concrete implementation result, not a universal optimality theorem.

## A. The dependent object, without complexity being smuggled into its formation

### A1. Completion preserves the visible map [SOURCE S1]

For f:A->B, define

    Fib_f(b) = Sigma a:A. (f(a)=b)
    hat_f(a) = (f(a), (a,refl)).

Then hat_f:A ~= Sigma b:B. Fib_f(b) is an equivalence. Its inverse returns a. The first projection is f itself. Any conservative completion over the same f has an equivalent fibre family.

The phrase 'over the same f' is essential. An arbitrary equivalence between the total spaces need not commute with the specified visible projection.

This classifies the omitted structure. It does not set the execution time of f, its presentation map, or its inverse.

### A2. The fibre of existential truncation is the whole source [SOURCE S3]

Let tau:E->||E||. For every p:||E||,

    Fib_tau(p) ~= E.

Forward: (e,r) |-> e. Backward: e |-> (e,squash(|e|,p)). The first round trip is reflexivity; the second uses that equalities in a proposition are propositions.

This theorem is CONDITIONAL ON p:||E||. It gives no p from the description of E. Forming a type, furnishing an inhabitant, and deciding inhabitation remain distinct judgments.

### A3. Candidate verification, accepting data, and language decision [DERIVED]

Let X be finite-string inputs, W(x) a finitely encoded certificate type, and

    v_x : W(x) -> Bool
    E_x = Sigma w:W(x). (v_x(w)=true)
    L_x = ||E_x||.

An NP interface additionally supplies a polynomial certificate-size bound and a polynomial-time implementation of v. Merely defining a proposition-valued relation is not that interface.

Verification is evaluation of v_x on a supplied CANDIDATE w, returning true OR false. Receiving (w,p):E_x already supplies both an accepting candidate and evidence of acceptance; it is stronger than the ordinary input to verification.

The total accepting space is E_total = Sigma x:X. E_x, with projection pi:E_total->X. Its fibre at x is E_x. Its image is Sigma x:X. ||E_x||. These are direct instances of A1 and S2.

Language decision, internally, supplies Dec(L_x)=L_x + (L_x->Empty), or a Boolean function with a proof of equivalence between output=true and L_x. A1/A2 do not construct Dec(L_x).

### A4. No restoration is not no selection [DERIVED; checks S11/S12]

For tau:E->||E||:

    LeftInverse(tau) = Sigma s:||E||->E. forall e:E, s(tau(e))=e.
    RightInverse(tau) = Sigma s:||E||->E. forall p:||E||, tau(s(p))=p.

If E has distinct e0,e1, LeftInverse(tau) is empty. Proof: tau(e0)=tau(e1), and applying s followed by the two left-inverse laws makes e0=e1.

If an e0:E is supplied, RightInverse(tau) is inhabited: take s(p)=e0 and use propositionality of ||E|| for the right-inverse equation. In fact RightInverse(tau) is equivalent to the type (||E||->E), since its equation is automatic.

Consequently the two explicitly distinct NKS histories refute restoration of the ORIGINAL history, not the existence of a constant choice of one of those histories. Uniform or resource-bounded selection over an input family is a separate statement.

### A5. Contractibility is not a running-time theorem [DERIVED]

A term c:isContr(E) includes c.center:E and paths from that center to every point. Given c, a center is obtained by projection. Neither isProp(E) nor the assertion that some such c exists in an unspecified presentation supplies a time bound for constructing c or computing its center.

Likewise, isProp(E) identifies two supplied inhabitants by a path, not necessarily by definitional equality. E_x generally has many certificate points even though L_x is propositional. Finding ANY accepting certificate needs no uniqueness hypothesis on E_x.

## B. The coinductive fibre, unfolded only as far as demanded

### B1. Runs equal answer streams [SOURCE S5]

For I=(X,Q,delta),

    IExec_I(x) ~= Answers_I(x).

The source maps are forgetStates and replay. The replay builds each next state by delta and each receipt by refl; the round trips are guarded paths. This is an equivalence of the represented histories. It does not assert that replaying n state transitions costs zero.

S6 gives the richer continuing interface:

    react : (q:Q(w)) -> Sigma w'. Sigma o:O(w,q,w'). E(w,q,w',o) x ISC(w').

Keep the successor, observation, dependent event and continuation together.

### B2. Finite answers and their endpoint [DERIVED]

Define, recursively in n,

    Ans_0(x) = Unit
    Ans_(n+1)(x) = Sigma q:Q(x). Ans_n(delta(x,q)).
    end_0(x,*) = x
    end_(n+1)(x,(q,a)) = end_n(delta(x,q),a).

A finite IExec with the redundant now/here singleton at each stage is equivalent to Ans_n(x), by the same receipt contractions as B1 and induction in n.

This construction describes a family; it does not enumerate all its inhabitants. Conversely, having a compact description of the family does not supply the answer to every observation of that family.

### B3. Prefix/suffix composition is an exact dependent equivalence [DERIVED]

For m,n and x,

    Ans_(m+n)(x)
      ~= Sigma a:Ans_m(x). Ans_n(end_m(x,a)).

Split peels m constructors and leaves the suffix at its actual endpoint. Join concatenates those m constructors with that suffix. Both round trips follow by induction on m. The endpoint equation is

    end_(m+n)(join(a,b)) = end_n(end_m(x,a),b).

No choice principle and no enumeration are involved. This is the finite-demand version of coinductive composition.

### B4. Endpoint-conditioned branches are precisely endpoint fibres [DERIVED]

For y:X,

    Fib_(end_(m+n)(x,-))(y)
      ~= Sigma a:Ans_m(x). Fib_(end_n(end_m(x,a),-))(y).

Apply B3 to the domain, use its endpoint equation, and reassociate Sigma. This is the exact statement behind 'compatible answer chain equals composite residual'. The source of the endpoint map includes the answers; it is not just the bare initial state.

The general version already exists as S4:

    Fib_(g o f)(c) ~= Sigma (b,q):Fib_g(c). Fib_f(b).

Forward sends (a,r) to ((f(a),r),(a,refl)). Backward sends ((b,q),(a,p)) to (a, ap(g,p) concatenated q). The inverse equations follow by path induction on p.

### B5. Deterministic and nondeterministic specializations [DERIVED / INTERFACE]

If all Q(x) are contractible, each Ans_n(x) is contractible, by induction; B1 supplies the corresponding infinite statement. This says there is one represented execution from x, not that its endpoint after n steps is available at zero cost.

To encode an ordinary time-bounded NTM, let Q(c) enumerate its finitely many legal outgoing transitions and let delta execute the selected transition. Make halting configurations idle through a single dummy answer. A polynomial bound on ALL branches then lets acceptance be observed at one fixed horizon p(|x|):

    Accept(x) = || Sigma a:Ans_(p(|x|))(init(x)). Accepting(end(a)) ||.

There is no exponential total-work charge in the NTM convention; this is not an implementation of free physical parallel hardware. The equivalence with the ordinary model still includes finite alphabets, encodings and per-transition simulation costs.

## C. Exact descent: what an observation is sufficient to determine

### C1. Kernel collision forbids descent [DERIVED]

Let q:X->Y, f:X->Bool. Define

    Factor(q,f) = Sigma h:Y->Bool. forall x, h(q(x))=f(x).

If q(x)=q(y) and f(x)!=f(y), Factor(q,f) is empty: any factor h would identify f(x) and f(y).

This is the basic observation obstruction. It refers to the DECLARED q, not automatically every possible computation.

### C2. On the image, fibre constancy is sufficient and necessary [DERIVED]

Assume X,Y are sets; replace Y by Im(q)=Sigma y:Y. ||Fib_q(y)||. Let qbar:X->Im(q) be the canonical surjection. Then

    Factor(qbar,f) is inhabited
      iff forall x,y, q(x)=q(y) -> f(x)=f(y).

Moreover Factor(qbar,f) is a proposition and hence contractible when inhabited.

Construction without assuming a chosen preimage: for u=(y,p):Im(q), define

    Val(u) = Sigma b:Bool.
               || Sigma x:X. (q(x)=y) x (f(x)=b) ||.

Fibre constancy makes any two b components equal, by eliminating the two truncated preimages into equality in Bool. The evidence components are propositions, so Val(u) is a proposition. Map p into Val(u), now a permissible propositional elimination. The decoder h(u) is the first component of that value. This gives Factor(qbar,f). Surjectivity makes any two decoders agree everywhere; function extensionality and propositional correctness identify the factorization packages.

The equivalent set-quotient statement is: f factors through X/ker(q) exactly when it respects ker(q).

This closes semantic sufficiency. It does NOT bound the cost of evaluating q or h. In particular f=f o id is always a semantic factorization and says nothing about efficient execution.

### C3. Symmetry is an obstruction certificate [DERIVED]

Suppose T:X->X satisfies q(T(x))=q(x) for every x. If f(T(x0))!=f(x0), Factor(q,f) is empty by C1 at x0,T(x0).

If q is specifically an orbit quotient, invariance under the generating action supplies descent by the quotient eliminator. For another q, invariance under some selected symmetries need not exhaust its fibres.

This is the exact route by which a holonomy/symmetry calculation can become an observation obstruction. A physical interpretation is not needed for the mathematical inference; transferring it to a different observation requires a commuting map.

## D. Cost: keep the realization, do not erase it by a semantic argument

### D1. What the grading theorem actually forbids [SOURCE S10 / DERIVED]

An exactly additive c:G->N on a group satisfies

    c(e)=0,
    c(g h)=c(g)+c(h),
    0=c(g g^-1)=c(g)+c(g^-1),

so c is identically zero. A grading that also detects the identity cannot exist on a nontrivial group.

This does NOT forbid positive geodesic length on a group. For a fixed generator set, minimum word length satisfies

    length_min(g h) <= length_min(g)+length_min(h),

not unconditional equality. Cancellation makes that inequality strict. Even the two-element group has length(id)=0, length(flip)=1.

A run and its reverse can take time while their composed EFFECT is identity. Exact additive length belongs to retained executions; a minimized effect length is generally subadditive. This is compatible with lossless semantics and univalence.

### D2. Reversible completion does not remove arbitrary evaluation [DERIVED]

For every Boolean f:X->Bool,

    U_f(x,b) = (x, b xor f(x))

is an involution: U_f(U_f(x,b))=(x,b). Its fibres are contractible, but

    f(x) = second(U_f(x,false)).

An implementation of U_f therefore gives an implementation of f by initializing one bit and projecting the result; an implementation of f gives U_f by the displayed formula. This does not by itself specify a reversible gate implementation of the evaluation of f, but it proves that bijectivity alone cannot identify the amount of evaluation required.

G3 below supplies a more directly native example: an actual reversible rope transformation with exact positive crossing distance.

### D3. Transport cost spectra, not just carriers [DERIVED / INTERFACE]

Let Real_A and Real_B be realization types for two corresponding tasks, with costs c_A,c_B. If e:Real_A ~= Real_B satisfies c_B(e(r))=c_A(r), then for every k the cost-k fibres are equivalent:

    (Sigma r:Real_A. c_A(r)=k)
      ~= (Sigma s:Real_B. c_B(s)=k).

Map by e and transport the cost equation; invert by e^-1. Attained minima and geodesicity transfer immediately.

This is ordinary dependent transport applied to a COSTED structure. A carrier equivalence by itself supplies no equation between execution costs. The relevant structured-system record must include the primitive operations, observation, input encoding and cost interpretation being transported.

## G. A completed geodesic from the rope itself

### G0. Exact native data and scope

Let C=Sutra, rho=caturamsa, and S=Rajju=Stream(C). Write s[j] for the source's gadha j s and take_n for kartana n. Rho has order four and is injective: rho^3 is its inverse. In particular each rho^n is injective.

The primitive crossing sigma_i is the source's veni-infinity i. Its active pair is

    (a,b) |-> (rho(b),a),

with all other cells unchanged. Hence sigma_i is reversible, with active-pair inverse

    (a,b) |-> (b,rho^-1(a)).

For a positive word w=[i0,...,ik-1], Act(w,s) applies the crossings from left to right:

    Act([],s)=s
    Act(i::w,s)=Act(w,sigma_i(s)).

In this section one active-pair crossing costs one unit. This is the generator-count semantics of the rope action. It is NOT a claim that traversing an encoded index i in HVM or on a TM is free. A runtime comparison must price routing/encoding separately through D3.

### G1. The exact transport word [DERIVED from S7]

Define

    Bring(0)=[]
    Bring(n+1)=n :: Bring(n).

Thus Bring(n)=[n-1,n-2,...,0]. Its length is exactly n, by induction.

Define T_n(s)=Act(Bring(n),s). Then

    T_n(s)[0] = rho^n(s[n]);
    T_n(s)[k+1] = s[k]          for k<n;
    T_n(s)[k] = s[k]            for k>n.

Proof of the head equation: the n=0 case is reflexivity. For n+1, sigma_n first places rho(s[n+1]) at position n. Apply the n-th induction hypothesis to the resulting rope. The other reader equations follow by the same active-pair case split. Thus T_n rotates the initial n+1 cells, depositing n quarter-turns on the cell transported to the head, and leaves the entire tail unchanged.

T_n is an equivalence because it is a composite of equivalences. Its lossless-completion fibres are contractible.

### G2. The prefix theorem gives the obstruction [SOURCE S8 / DERIVED]

S8 proves for every word w and requested prefix r:

    take_(|w|+r)(s)=take_(|w|+r)(t)
      -> take_r(Act(w,s))=take_r(Act(w,t)).

Specialize r=1. A word of k crossings cannot make its head distinguish two inputs agreeing in the first k+1 cells.

For any n, choose a!=b in C, fix a common filler cell, and make ropes s_a,s_b agreeing at every position except n, where they contain a,b. Then:

    take_n(s_a)=take_n(s_b),
    T_n(s_a)[0]=rho^n(a) != rho^n(b)=T_n(s_b)[0].

The second statement uses injectivity of rho^n. No estimate or numerical experiment is involved.

### G3. Bringing depth n to the head is geodesic [DERIVED, CLOSED HAND PROOF]

Define

    HeadRealises(n,w) = forall s:S,
      Act(w,s)[0] = rho^n(s[n]).

Then

    forall n,w, HeadRealises(n,w) -> n <= |w|,
    HeadRealises(n,Bring(n)),
    |Bring(n)|=n.

Proof of the lower statement: suppose k=|w|<n. The ropes s_a,s_b of G2 agree through k+1 because k+1<=n. S8 therefore makes the heads of Act(w,s_a), Act(w,s_b) equal. HeadRealises rewrites these heads to rho^n(a),rho^n(b), contradicting injectivity. Thus n<=k. G1 supplies attainment.

Consequently:

    minimum { |w| : HeadRealises(n,w) } = n.
    minimum { |w| : forall s, Act(w,s)=T_n(s) } = n.

The first is stronger as an obstruction: it charges only the requested head observation, not reconstruction of an entire prescribed trace. The second follows because full equality implies equality of heads and Bring(n) supplies the full transformation.

This is the original irreducibility question answered exactly for this native transformation class. The exhibited evolution realizes the distance; the lower statement ranges over EVERY word in the specified generator alphabet, not merely the displayed implementation.

### G4. Signed crossings and parallel layers [DERIVED]

The explicit inverse active-pair formula in G0 also has one-cell lookahead. Repeating the S8 prefix proof therefore extends G2/G3 to words over positive AND negative elementary crossings, each with unit generator cost.

For parallel depth, admit layers of disjoint active pairs. One layer still maps (r+1)-prefix agreement to r-prefix agreement: each output cell has inputs only in its own cell or its adjacent partner, and disjointness prevents within-layer cascading. Induction on d layers gives a d-cell dependency cone. The separating ropes in G2 then require at least n layers for HeadRealises(n,-). The sequential Bring(n) uses exactly n layers, so its minimal depth is also n in this layer model.

Work and depth coincide for this transport task, not in general. Disjoint operations elsewhere can have work greater than depth.

### G5. A supplied modulus is not always a least modulus [SOURCE S9 / DERIVED]

S9 gives sigma_i^8=id as an action. That eight-letter word has the length-based bound supplied by S8, but its least lookahead and its minimum effect-realizing word length are both zero.

Thus neither confluence, equivalence, finite-order structure, nor an available length modulus proves every trajectory geodesic. G3 closes the equality by adding the separating-input proof. This distinction prevents a definition of 'irreducible' from masquerading as a proof that a particular evolution is irreducible.

### G6. Transcription specification

Use the existing Rajju, gadha, kartana, veni-infinity and veni-gana. Do not create a lookalike stream interpreter.

Suggested declarations:

    bring : N -> List N
    bring-length : forall n, length(bring n)=n
    rhoPow : N -> Sutra -> Sutra
    rhoPow-injective : forall n a b, rhoPow n a=rhoPow n b -> a=b
    crossing-reader : forall n s, gadha n (veni-infinity n s)
                                  =rho(gadha (n+1) s)
    bring-head : forall n s, gadha 0 (veni-gana (bring n) s)
                            =rhoPow n (gadha n s)
    varyAt : N -> Sutra -> Rajju
    varyAt-prefix : forall n a b, kartana n (varyAt n a)
                                 =kartana n (varyAt n b)
    varyAt-read : forall n a, gadha n (varyAt n a)=a
    no-shorter-head : forall n w, HeadRealises n w -> n<=length w
    bring-geodesic : forall n w,
      (forall s, veni-gana w s=veni-gana (bring n) s) -> n<=length w

The only structural inductions are on n and the prefix-weakening proof. The decisive lower-bound step is S8 at requested prefix 1. The signed/layer extension should be a separate module with its own explicitly stated generators.

## E. The resource-indexed observation issue, with the quantifiers fixed

### E1. A common observation obstruction is sufficient only with coverage [DERIVED / INTERFACE]

Suppose every computation in a declared resource class has output factoring through one q:X->Y. If q has an opposite-label collision for f, C1 excludes every computation in that class.

The premise that all those computations factor through q is the coverage theorem. A restricted local-prefix observer does not become all deterministic computation just by calling it 'universal'.

G3 has exactly the required coverage: S8 quantifies over all words of the declared cost. That is why its indistinguishable pair proves the claimed local distance.

### E2. The intersection of all cheap observers can already be equality [DERIVED]

For X_n=Bool^n, suppose the observer class contains each coordinate projection b_i(x)=x_i. Define

    x ~ y iff forall cheap observers o, o(x)=o(y).

Then x~y implies x_i=y_i for all i, hence x=y. The common equivalence has no distinct pair at all. Nonetheless this supplies no small implementation of an arbitrary target function f:X_n->Bool: it has not computed the decoder of the joint information.

With explicit n-bit TM inputs each coordinate can be read within linear traversal time; in a query model it is one query. Thus the earlier proposal of a fixed yes/no pair invisible to EVERY polynomial-time reader cannot work in that form. The pair needed in a per-computation adversary argument may depend on the computation and its transcript. Alternatively an obstruction may have to concern the cost of the decoder rather than missing information.

Do not exchange

    forall computation, exists a defeating configuration

with

    exists a configuration pair defeating all computations.

### E3. Semantic factorization and costed factorization are different fibres [DERIVED]

A semantic factorization f=h o q carries no price. A costed factorization also carries implementations qhat,hhat, correctness, and for each x the cost of the composed execution:

    c_comp(x) = c_qhat(x) + c_hhat(q(x)) + c_interface(x).

The interface term is zero only when the chosen execution calculus proves it zero. Define a budgeted factorization by the displayed cost fitting the declared budget.

Both directions must be priced. Collecting all cheap observations into one huge tuple is not a free operation, and an arbitrary function on that tuple is not a free decoder.

If the implementation calculus is closed under composition and includes identity, allowing all intermediate representations makes budgeted factorizations equivalent to budgeted realizations: compose in one direction; use identity then the original realization in the other. This is an exact reorganization, not a lower-bound result by itself.

## F. One exact finite classification of adaptive observation

### F1. The minimax equation is fibre decomposition [DERIVED]

Fix a finite input set X, a Boolean target f, a finite library of tests q:X->O_q with finite outcomes, and positive integer test prices c(q). A computation here is an adaptive TEST TREE. This is a specified query model, not the whole universal interaction calculus.

At information state S subset X, a leaf is correct iff f is constant on S. A test q replaces S by its actual nonempty fibre S_(q,o)={x in S:q(x)=o}. Let D(S) be the minimum worst-case total test price of a correct tree. Assume the test family separates opposite-label inputs. Then:

    D(S)=0                                      if f is constant on S;
    D(S)=min_q [ c(q)+max_(o:S_(q,o) nonempty) D(S_(q,o)) ] otherwise,

where the minimum ranges over tests splitting S into at least two nonempty proper fibres.

Proof: a non-leaf tree first chooses q and must contain a correct subtree for every possible outcome, so its worst-case price is at least the corresponding displayed expression. Conversely choose a minimizing q and recursively attach minimizing subtrees, giving equality. Induct on |S|; splitting makes every successor smaller. A test constant on S can be removed because it produces a known answer and has positive price. Finite extrema produce both an optimal tree and an adversarial response strategy attaining the cost.

This theorem holds all continuations at once. There is no privileged sequential enumeration of candidate witnesses.

### F2. Closed instance: parity under coordinate questions [DERIVED]

For coordinate tests of unit price on Bool^n, take f=parity. After k distinct coordinates have been read, any unqueried coordinate can be flipped without changing the transcript, while changing f. Therefore every correct branch needs all n coordinates. Reading all coordinates attains n:

    D(Bool^n)=n.

For OR the all-zero transcript likewise requires n queries, although a positive instance can have a one-coordinate certificate. These facts are exact for the stated query model. They demonstrate the supplied-certificate / worst-case-decision distinction without claiming an NP-complete lower bound.

## H. The uniform realization fibre is the correct P/NP interface

### H1. Keep the program uniform and the specification global [DERIVED / INTERFACE]

Let Code be one explicitly represented program type. Let out(p,x) and cost(p,x) describe its terminating executions, with termination supplied where needed. For a budget b:X->N and a total Boolean function f, define

    Real_b(f) = Sigma p:Code.
      (forall x, p terminates on x)
      x (forall x, out(p,x)=f(x))
      x (forall x, cost(p,x)<=b(x)).

Equivalently package b-bounded codes first, then take the fibre of their semantics map at the WHOLE function f. The crucial object is

    Fib_(Sem_b)(f),

not a shortest path to a pre-known answer on one chosen input. A p in this fibre is one implementation valid on every input. Its certificate of correctness and resource bound can be propositionally truncated externally without changing the requirement.

For standard finite-string encodings:

    f in P iff there exist one p and constants c,k
                 with p in Real_(x |-> c*(|x|+1)^k)(f).

The order of quantifiers is part of the theorem.

### H2. Pointwise minimization over globally correct programs loses uniformity [DERIVED]

Suppose f has any total implementation p0. For a fixed input x0, make p_x0 compare its input with x0, return the hard-coded correct bit f(x0) on equality, and otherwise run p0. It remains globally correct and takes only comparison time on x0.

Thus minimizing execution time separately over all correct programs at EACH x can give small values even without one small-time program for all x. Different x use different descriptions p_x. A pointwise endpoint-distance formula is not automatically the complexity of a uniform language decider.

G3 avoids this issue by quantifying over words that realize the head transformation on EVERY rope. H1 is the corresponding global specification for decision functions.

### H3. Projection of executions versus realization of an observation [DERIVED]

A conventional decider need only return the specified Boolean. It need not recreate another implementation's witness, history, or full final fibre point. Therefore a lower bound for reconstructing a PRESCRIBED trace is not a decision lower bound unless every correct decision realization is proved to incur it.

G3 again uses the stronger correct method: the lower bound already applies to the requested head observation, before any demand for the rest of the trace.

### H4. Complexity transfer is a structured simulation theorem [INTERFACE]

To transfer a native lower bound to a standard model, supply input/output commuting maps and a simulation sending each standard computation to an allowed native realization with a specified resource overhead. A lower bound in the native target can then exclude standard computations whose simulations would violate it. For an exact equality, use D3's cost-preserving equivalence of realizations. For polynomial-class preservation, explicit polynomial overhead and encoding-size control suffice.

Universality as representability does not alone provide this resource theorem. Conversely, once a suitable structured theorem exists, use dependent transport rather than re-prove every instance.

## I. Precise frontier after this revision

Completed in the source: lossless completion and forced fibres; the truncation-fibre identity; coinductive run/answer equivalence; local crossing equations; all-word prefix continuity; order-eight crossings; the additive-grading obstruction.

Completed as hand proofs here: finite answer concatenation and endpoint-fibre decomposition; selection/restoration separation; exact descent and uniqueness on the image; the reversible cost counterexample; cost-spectrum transport; the attained rope geodesic G3; its signed/layer extension under the declared generators; the coordinate-observer obstruction to the earlier global-pair proposal; finite adaptive-query minimax; the uniformity correction.

Not established by these results: a superpolynomial lower bound for a standard NP-complete language, a polynomial deterministic realization of all NP languages, or an identification of arbitrary standard computations with the locally bounded rope-word class. None follows from fibre cardinality, noninjectivity, the existence of a causal modulus, or losslessness alone.

The next exact object is the costed semantic fibre H1 for a chosen observation, together with a source-backed structural characterization of its inhabitants. G3 shows what a genuine closure looks like: coverage of the entire permitted realization class, a separating-input obstruction below the claimed cost, and an explicit realization attaining it. That is the reusable theorem, not a promise that every input domain has the same distance.

## J. Transcription order and negative guards

1. Import the existing fibre and coinductive modules. Transcribe A4 and B2-B4 with their actual input families and maps.
2. Transcribe G1-G3 using the native rope definitions, then extend to signed crossings and disjoint layers separately.
3. Transcribe C1-C3 for set-valued Boolean observations, with the image assumption explicit.
4. Transcribe D1-D3 and H1-H3 so all later complexity claims retain their resource and uniformity indices.
5. F1/F2 are a separate finite-test instantiation, not an assumed characterization of all programs.

Required guards / expected refutations:

- Distinct histories forbid a left inverse of truncation; do NOT refute the explicit constant right inverse on an inhabited history type.
- isProp(E) does not produce E or Dec(E).
- A term of E_x is not the ordinary candidate-only input to verification.
- A reversible transformation can have positive generator distance: G3 at n=1 is the minimal guard.
- sigma_0 repeated eight times is not geodesic despite the length-eight continuity bound.
- Once all coordinate projections are present, their common observational equivalence on Bool^n is equality.
- A semantic decoder has no automatically inherited small execution cost.
- Do not replace one globally correct program by a different hard-coded program for each input.
- Do not claim machine checking for the DERIVED blocks until the resulting modules have actually compiled.
