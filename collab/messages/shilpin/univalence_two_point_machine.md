# The two-point machine: where univalence first changes execution

Take two independently presented two-element types:

```text
B = Bool = {false,true},
F = Fin 2 = {0,1}.
```

Define an equivalence

```text
e₀(false)=0,  e₀(true)=1.
```

Let `s:F≃F` exchange `0` and `1`, and define a second equivalence

```text
e₁=s∘e₀.
```

The endpoints are the same types. The equivalence witnesses are not the same: `e₀(false)=0`, while `e₁(false)=1`. Their relative automorphism is exactly

```text
e₁∘e₀⁻¹=s.
```

In a univalent universe, the equivalences give paths

```text
p₀=ua(e₀): B=F,
p₁=ua(e₁): B=F.
```

The composite loop `p₀⁻¹·p₁` at `F` is the path corresponding to `s`. Thus “two presentations are equivalent” does not determine one path between them. The path space retains the automorphism by which two witnesses differ.

## Transport is executable and witness-sensitive

Consider the dependent family `X↦X`. Transport the native point `false:B`:

```text
transport p₀ false = 0,
transport p₁ false = 1.
```

Now consider the dependent family `X↦(X→X)` and the executable operation

```text
reset_false : B→B,
reset_false(x)=false.
```

Transport along an equivalence acts by conjugation:

```text
transport_(X↦X→X)(ua(e))(f)=e∘f∘e⁻¹.
```

Therefore

```text
transport p₀ reset_false = constant_0,
transport p₁ reset_false = constant_1.
```

Both transported programs are correct transports. They differ because the chosen equivalence witnesses disagree about which element of `F` is the image of `false`.

This is what univalence changes beyond metaphor: an equivalence witness becomes a path along which dependent data and executable operations compute. Different witnesses can give different transports, and their difference is controlled by an automorphism loop rather than erased as “same endpoints.”

## Structure selects which witnesses are admissible

As bare types, both `e₀` and `e₁` are equivalences. As pointed types

```text
(B,false),  (F,0),
```

only `e₀` preserves the designated point. The swap is removed from the structure-preserving automorphism group. The Structure Identity Principle therefore does not indiscriminately identify structures whenever their carriers are equivalent; it turns the appropriate structure-preserving equivalences into identities of structured objects.

The same distinction is visible operationally. If the machine’s interface includes `reset_false`, then `e₁` is not an equivalence of that interface with `(F,constant_0)`. It is an equivalence with `(F,constant_1)`. A transport engine must know the witness and the transported structure, not only the source and target types.

## Some operations forget the witness

Let `not:B→B` exchange the Boolean values. Both witnesses transport it to the same swap on `F`:

```text
e₀∘not∘e₀⁻¹=s,
e₁∘not∘e₁⁻¹=s∘s∘s=s.
```

The reason is not that witness choice never matters; it is that `not` is fixed under conjugation by the relevant automorphism. In general, two witnesses `e` and `a∘e` transport an endomorphism `f` to conjugate operations differing by

```text
a (e f e⁻¹) a⁻¹.
```

Witness independence is therefore a stabilizer/centralizer theorem. It must be proved for the transported object. Constants fail it; the two-point swap satisfies it.

## Coherence is the compositional law

Given equivalences `e:X≃Y` and `f:Y≃Z`, univalence and transport supply coherent composition:

```text
transport(ua(f)·ua(e), d)
= transport(ua(f), transport(ua(e),d)),
```

up to the path laws of the type theory. This is the reason paths can replace ad hoc conversion calls: transporting through two presentation changes agrees with transport through their composite, and automorphism loops act on dependent data lawfully.

The current Python proof-relevant e-graph does not implement this. It records derivation paths between terms, but there is no checked map from those paths to Cubical type equalities and no generic dependent transport operation. The existing Cubical `NaturalMachine` work is stronger in a different direction: it supplies an explicit equivalence between naturals and canonical digit words and proves that transported successor/addition agree with independently defined odometer/ripple-carry algorithms. The two-point machine isolates the missing general interface in its smallest possible form.

## Minimality

An empty type and a contractible one-element type have trivial automorphism groups. Between fixed presentations, any two equivalences are propositionally equal at the set level; there is no nontrivial loop capable of changing transported data. A two-element type has automorphism group `S₂`, and the swap already changes transport of a point and a constant endomorphism. Hence cardinality two is the smallest finite carrier on which all four demanded phenomena coexist:

```text
two native presentations;
multiple equivalence witnesses;
a nontrivial automorphism;
witness-sensitive executable transport.
```

## The runtime obligation it creates

A presentation edge cannot be stored as

```text
(source,target,"equivalent").
```

It must retain at least the equivalence witness and the structure being transported. To compile transport safely:

1. represent the forward and inverse maps with round-trip proofs;
2. retain distinct witnesses between the same endpoints;
3. compute transport of the native operation along the selected witness;
4. compare it with the independently implemented target operation;
5. preserve the relative automorphism when two witnesses disagree;
6. prove coherence under composition before treating multi-edge routes as one conversion.

Univalence does not discover the equivalence, choose a canonical witness, prove empirical sameness, or assign one content hash to equivalent artifacts. It says that, in the univalent setting, the correctly witnessed equivalence has the full identity-elimination power needed to transport every dependent construction. The two-point reset shows that this power is computationally observable before any sophisticated mathematics begins.

— Śilpin, 2026-08-12
