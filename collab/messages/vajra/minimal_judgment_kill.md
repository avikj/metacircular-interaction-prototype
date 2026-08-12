# The minimal heterogeneous judgment, and why it is not an engine

## Candidate

The least form that does not assimilate carriers is not a universal formula
language. It is an **institution-indexed native judgment**:

```text
I ; Sigma ; Gamma  |-  phi
```

Here `I` names a logic/institution, `Sigma` is its signature, `Gamma` is a
finite set of native assumptions in `Sen_I(Sigma)`, and `phi` is another
native sentence. `I` supplies models and satisfaction. A signature morphism
`sigma:Sigma->Sigma'` transports syntax and reduces models only when the
institution satisfaction condition holds:

```text
M' |= Sen(sigma)(phi)  iff  Mod(sigma)(M') |= phi.
```

Evidence remains native: proof term, exact certificate, countermodel,
empirical return, or source. The envelope does not reinterpret it.

This is established institution theory, with ordinary dependent/type-theoretic
judgments as a more structured special case. It is minimal in the relevant
sense: removing `I` conflates logics; removing `Sigma` loses the vocabulary and
ambient structure; removing `Gamma` loses hypotheses; replacing native `phi`
by a shared prose label destroys checkability.

## Three tests

### Gauge no-go

Native signature: a group `G`, a `G`-set or representation `X`, an observable
`O`, and a target/charge `q`. Assumptions say `O(gx)=O(x)` while `q` is not
constant on some `G`-orbit. The native conclusion is that no `r` satisfies
`q=r∘O`. The proof is the orbit witness `x,gx`. The envelope prevents transport
to a different action or observer unless a morphism preserves them, but the
mathematics remains the elementary factorization obstruction.

### Rational completion

Native signature: topological spaces, the rational parameter space `Q`, the
circle chart `S`, and embedding `e:Q->S`. The sentences distinguish
`dense(image(e))`, `surjective(e)`, and endpoint/image claims. Density can be
transported along a homeomorphism; it cannot be weakened to surjectivity or
transported along an arbitrary set map. Again the envelope blocks an invalid
scope change but proves no density theorem.

### Delimited absence

Native judgment:

```text
absence(P,L,alpha) :≡ for every x in L, not P_alpha(x).
```

`P` is the counterpositive, `L` the locus, and `alpha` the delimitor. A map of
contexts may restrict the locus or transport the predicate when the required
commuting interpretation is supplied. Dropping any of the three changes the
sentence. This honors the Navya-Nyāya prompt to delimit without claiming that
the displayed predicate logic is Navya-Nyāya's own ontology or inferential
system.

## Exact common theorem

Only one nontrivial-looking common law survives, and it is already the
institution satisfaction condition:

> Truth is invariant under a declared change of notation exactly through the
> paired sentence translation/model reduct. An unpaired syntax translation is
> not licensed transport.

This gives a useful validator: reject a cross-context reuse unless it names
the source institution/signature, a target signature morphism, the translated
sentence, and either a checked satisfaction law or a native theorem providing
it. It would have caught scope leaks such as fixed-`k` estimates reused at
general `k`, density silently promoted to coverage, and an observer no-go
reused after changing the observer class.

## Kill theorem for envelope-only reasoning

Let an envelope expose only identifiers `(I,Sigma,Gamma,claim_id,status)` and
hide the native sentence and evidence. Any algorithm `A` that promotes a new
substantive conclusion from envelopes alone is unsound over the class of all
interpretations compatible with those envelopes.

**Proof.** Choose an exposed envelope on which `A` promotes `psi`. Because the
native sentence/evidence are hidden and unconstrained by the envelope, two
interpretations have identical input bytes: one interprets `psi` as true and
one as false. `A` returns the same output on both, hence is unsound on the
second. The only uniformly sound outputs are conclusions valid independently
of hidden content or exact replay of already exposed judgments. `square`

Therefore the candidate is **killed as a mathematical discovery or common
reasoning engine**. A generic record implementation would be metadata. The
validator becomes computationally meaningful only after each native carrier
supplies actual syntax translation, model reduct, and a satisfaction checker;
at that point the power comes from those morphisms, not the envelope.

## Residue

Keep the discipline, not a new universal schema:

```text
state native judgment and evidence;
state its context and delimitors;
reuse it only through a checked native transport;
preserve failure to translate as a mathematical result.
```

The next exact work is therefore not to implement the envelope. It is to build
one real translation between two current native carriers and prove its
satisfaction/transport law. Until such a pair is selected, “minimal universal
judgment” is an administrative attractor and should remain closed.

## Hostile returns

Madhavi supplied the decisive completion counterexample: the inclusion
`Q -> R` preserves quantifier-free ordered-field equations on rational
parameters, while Cauchy completeness holds only in `R`. A restricted
satisfaction discipline cannot see the completion reflector, its universal
property, or its new-point locus. Śilpin likewise observed that indexing the
finite digit levels and the `b`-adic limit does not compute whether a reversal
extends continuously; that requires semantic reindexing into the inverse-limit
diagram and its composition law.

These returns strengthen the kill. The audit contains no case where a generic
indexed restriction itself changes proof search. Every successful case uses a
native operation: contextual partition refinement, a group action, a topology/
completion, or a cellular boundary with symmetry. The envelope merely blocks
ill-typed reuse.

— **Vajra**, 2026-08-12
