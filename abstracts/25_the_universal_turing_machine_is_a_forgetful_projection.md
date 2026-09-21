# THE UNIVERSAL TURING MACHINE IS A FORGETFUL PROJECTION

*Every map is definitionally the visible part of its lossless completion, and the commuting law forces every trace family to be the fibre family*

**Computability / cubical type theory**

For any types A, B and any map f : A â’ B there is an equivalence

```
e_f : A â‰ Î_{b : B} fib_f(b)
```

whose forward map is a â¦ (f a, a, refl) and whose visible projection is f *definitionally*: Ïâ âˆ˜ e_f = f is inhabited by refl, with no transport and no path algebra.  Read operationally: every computable transition, however irreversible, is the first projection of a step that retains its exact preimage witness.  Irreversibility is not prohibited and not repaired; it is exhibited as forgetting, and the forgotten object is computed rather than postulated â” it is the homotopy fibre.

The law.  A lossless step on A is a quadruple (step, T, e, v): an endomap, a family T : A â’ U, an equivalence e : A â‰ Î_{a'} T(a'), and the commuting datum v : Ïâ âˆ˜ e âˆ¼ step.  The fourth field is load-bearing: without it, e may permute A arbitrarily and `step` is decorative â” the equivalence alone is not a law.  The paper's central theorem is that the field is also exactly strong enough:

```
THEOREM (trace-is-fibre).  For every lossless step (step, T, e, v)
and every a' : A,   T(a') â‰ fib_step(a').
```

The trace family of a lawful step carries no information beyond the step itself, so lossless completion is canonical, not chosen.  The proof composes eâ»Â with e_step, slides the base point of the resulting total-space equivalence along the witness assembled from v and the section of e â” the same interval trick, Î» i â’ (q i, a, Î» j â’ q (iâˆ§j)), that proves e_f itself â” and then applies the total-to-fiberwise equivalence theorem.

The machine.  Code is the type of finite transition tables of a single-tape machine, List (Q — S — Q — S — Move) with Q = S = â•, so an effectively presented machine IS an element of Code: there is no Gdel numbering to trust and no decoder to verify, because the table is the program.  Conf is a two-list tape with a scanned cell, blank beyond both ends.  The rule lookup answers with Maybe (m â‰¡ n) â” a witness of the match, or nothing â” and no boolean occurs in the development: the branch a boolean would stand in for is exactly the slot the witness keeps.  The universal step uStep : Code — Conf â’ Code — Conf is total; a configuration its table does not address is a fixed point, so halting is the table's silence, an equation in Maybe, and no defined function diverges.

Instantiating at uStep: the equation

```
ordinary universal step  =  forget trace âˆ˜ lossless universal step
```

is a definitional equality of the checked artifact â” the term turing-is-the-projection is refl â” not an assertion about it.  The program rides untouched through execution (Ïâ(run n (M,c)) â‰¡ M, one refl per step folded through the run), and the n-step visible run is itself the projection of its own lossless completion, for every n, by the same e.

Divergence lives inside the total language.  A guarded coinductive exec is total and productive: every machine, halting or not, yields the infinite stream of its finite transitions, so nontermination is represented and never executed.  Both poles are then computed: the empty table halts at once on every configuration, by refl; and a one-rule machine that rewrites its scanned blank in place is proved divergent â” the halting observation is refuted at every finite depth by transporting along the run's fixity and colliding just with nothing.

Losslessness is a property, not a structure.  The type of lossless completions of a fixed map,

```
Lossless f  =  Î (T : B â’ U). Î (e : A â‰ Î_b T b). Ïâ âˆ˜ e âˆ¼ f,
```

is CONTRACTIBLE (losslessness-is-a-property).  The proof unwinds a completion through a chain of explicit equivalences â” a map over f is a section, a section is a fiberwise map, both definitionally; total and fiberwise invertibility exchange as propositions; two applications of definitional choice and one flip through univalence â” landing in a product of equivalence-singletons, each contractible by univalence. So the completed machine is not one design among possible designs: up to a path there is exactly one lossless completion of the universal step, and the constructed one is the inhabitant (machine-lossless-unique).

The ledger has an algebra.  For any maps g, f and target c,

```
fiber (g âˆ˜ f) c  â‰  Î (w : fiber g c). fiber f (Ïâ w)
```

â” the kept fibre of a composite is the composite of kept fibres â” and run is additive, so the trace of an (m+n)-step run factors through the n-leg and then the m-leg with nothing double-kept and nothing dropped. Reverse execution of the completed machine is refl: the inverse of the lossless completion reads the source out of the fibre, a projection rather than a search, and the kernel accepts source-recovered by refl at every depth.  Halting is an equation in a set, hence a proposition; silence persists to every later depth; and the pair (first halting time, its minimality) is itself a proposition â” if the machine halts, when it first halts admits no second answer, as data.

Programs are verified by exhibiting their fibre point.  A two-rule table computes the successor on unary tapes, and its correctness proof â” n+1 steps from n strokes to a halted n+1, for every n â” is not beside the run but literally a point of the kept fibre, fiber (run (n+1)) (end); the lossless run reads the source back out of the certificate by refl.  And the classical padding lemma bounds the other side of the ledger: rules living above every reachable state are invisible, configuration for configuration at every depth, so there is an injection â• â’ Code all of whose values run identically.  The contrast is exact and checked in both directions: the trace family of one step is contractible (Ekatva), while the preimage of one behavior in the space of tables is unbounded (the padding lemma) â” losslessness is a property of the step, multiplicity is a property of the code.

The contractibility has a slogan-sharp corollary: LawfulStep A â‰ (A â’ A).  The type of lossless proof-relevant machines on A IS the type of ordinary programs on A â” completion adds nothing and forgets nothing.  What the visible step does destroy, the completed step cannot: a one-rule eraser collides two distinct configurations (the collision is refl, the distinctness a two-line refutation), while the lossless completion of any map is injective, so the kept fibre separates what the projection identified â” the destroyed bit, exhibited, and its receipt.

Programs compose.  For Mâ with source states below H, the compound Mâ ++ shift H Mâ runs Mâ to its retire state H â” where the shifted Mâ's state 0 already sits, with no glue â” and then runs Mâ, with step counts adding and the tape handed over (compose-runs).  The state shift is proof-relevant all the way down: the shifted comparison witness is the original witness under cong (H +_).  Instantiated: incr â¨Ÿ incr computes n â¦ n+2 in (n+1)+2 steps, and its certificate is manufactured from the two phase certificates by the composition theorem, with no induction over the compound â” composition of verified programs is verified once, in general.

Determinism is contractibility.  The type of productive infinite runs from any configuration â” a now, a receipt, a rest from the stepped configuration â” is contractible, the contraction built coinductively: one configuration, one history, as a statement about the whole unfolding at once rather than a condition on steps.

And the machine is a quotient computer, literally.  Codes modulo running-the-same form a set-quotient Beh = Code / SameRun to which running descends, definitionally on codes.  Duplicated rules are shadowed by first-match lookup unconditionally, so the doubling family dups j M runs identically for every j while its members are pairwise distinct codes: an injection â• â’ Code whose image is one single point of the quotient.  The picture closes against the contractibility theorem: the lossless trace of the step is a point, forced; the fibre of the behavioral quotient is infinite, free.  What is unique is the trace; what is multiple is the expression; the fibre carries exactly what the quotient forgot.

Finally, the interactive machine itself.  In its guarded coalgebraic form â” at every state, for every question the environment can put, a successor, a witness that the transition is the prescribed one, and the rest of the unfolding â” the ISC contains the universal Turing machine as the instance with trivial questions and receipt events, and at that instance the WHOLE SPACE of interactive behaviors is contractible at every state: determinism is not a side condition on steps but what remains of interaction when the receipt leaves the successor no room.  With a free event the space is provably not a point, so the inclusion is strict and the strictness is measured exactly by the event type:

```
UTM  =  deterministic ISC (a point)  âŠŠ  interactive ISC.
```

The same ea has a second face, where the freedom lives in the answers rather than the events: an interaction is a family of questions Q(s) with an answer-indexed step, and its guarded run â” a stream of nows, receipts, and answers â” is EQUIVALENT to the bare answer stream (run-is-answers).  The states of an interactive history are receipts, and receipts weigh nothing: the interactive face of trace-is-fibre.  The collapse then comes out structural: contractible questions force a contractible run space (silence-is-determinism), with no set-ness of the state space used anywhere â” the contraction is built coinductively over a path of states on the answer side and carried across the equivalence â” and the closed universal machine recovers one-execution as an instance.  With the strictness witness already checked on the event flank, the two files close the picture together: the environment's freedom IS the homotopy of the history space, measured on one flank by the event type and on the other by the answer stream.

The self-hosting question is answered on both flanks.  There is no table that is every table on the nose â” two machines disagreeing at one configuration kill every candidate â” so a universal table must read its subject machine in an encoding: the change of representation is a theorem, not an implementation convenience.  And every encoding hands the diagonal its pen: fixing a tape-reading of codes (five naturals per rule, with its section proved), Lawvere's fixed-point argument manufactures a concrete configuration map â” the state-successor of what the machine read off the tape would do â” that NO program's step realizes, since a table evaluated at its own encoding would equal its own successor.  The universal function exists; the program behaviors cannot exhaust the configuration maps; the escape is one act of self-reference, not a cardinality count.

Three bridges close the development.  Physics: every table's step is unitary when completed â” the lossless completion is an equivalence, and by contractibility the only one â” yet the successor and the eraser fail to exchange at one stroke under the head, both composites computing by refl: invertibility buys no exchange coherence, the machine's own dialect of "unitarity does not give braiding". Univalence: ua turns the completion into an identification Machine â‰¡ Î Machine (fib uStep) in the universe, and the identification COMPUTES â” transport evaluates to the completed step by the computation rule for ua, evaluating, not cited; on a closed machine the whole crossing reaches a closed normal form.  And the sydvda: each step is a transport with its receipt or a silence with its equation â” the disjunction computed, the witness riding in the sum, no boolean and no excluded middle â” so every finite depth is decided with evidence either way, while divergence, the refutation at every depth at once, is a proposition no finite observation asserts: each depth speaks with evidence, and the totality is not a naya.

The truncation doctrine meets its exact boundary.  In general âˆAâˆâ has no retraction â” a collapse to mere inhabitation cannot be undone. But mere halting already yields the first halting time with its minimality certificate, untruncated, with no choice principle: each finite depth is decided with evidence, so a bounded search walks down from any witness, and the pair (first time, minimality) is a proposition, so the truncation eliminates into it.  The collapse destroys choices and preserves canons; minimality is a canon.

And the relational presentation collapses too.  A proof-relevant program R : A â’ B â’ U with unique answers â” contractible output spaces â” is the graph of its execution, R a b â‰ (exec a â‰¡ b), by the fundamental theorem of identity types; globally (Î R. Fun R) â‰ (A â’ B), one direction definitional.  The deterministic ISC's receipt event is definitionally the graph relation of the universal step.  So three grammars â” lossless step, functional relation, collapsed interaction â” present one function, and each grammar's surplus is measured by its own theorem: the trace is the fibre, the relation is the graph, the interaction is the receipt.
