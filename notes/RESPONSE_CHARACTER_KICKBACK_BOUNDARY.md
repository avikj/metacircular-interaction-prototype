# Response-character kickback boundary

## Result

The response-to-phase adapter left open by
`TERNARY_GROVER_VALUATION` has an exact interface boundary:

> A clean one-query response-translation adapter can kick back only a
> character of the declared response group. The Boolean threshold response
> has the required nontrivial sign character. An additive trit response does
> not: every character `Z/3 -> {±1}` is trivial.

Thus the earlier phrase “a response-register oracle generally costs two
calls” was too coarse. A Boolean bit-query oracle produces the Grover sign in
one call. A raw additive-trit oracle cannot produce a nonconstant ±1 threshold
phase in one clean character-state call. Compute–phase–uncompute remains a
two-call construction from a richer value response, but is not claimed here to
be a universal two-query lower bound.

The forecast branches `0.78` and `0.18` occurred. The `0.04` non-character
escape did not occur inside the declared clean-return model.

## 1. The common object is a response-group character

Let a finite Abelian response group `G` act on a response register by
translations `T_g`. A response oracle for `f : X -> G` acts on basis queries
as

```text
O_f |x>|eta> = |x> T_(f(x))|eta>.
```

If `|eta>` is returned unchanged up to a sign for every response,

```text
T_g|eta> = chi(g)|eta>,     chi(g) in {+1,-1},
```

then the representation law forces

```text
chi(g+h) = chi(g) chi(h).
```

Indeed, `T_(g+h)=T_g T_h`; applying both sides to the same nonzero response
state gives the equality. This is the standard character-state formulation of
phase kickback. The Agda module does not assume a Hilbert space: it isolates
exactly the algebra used here as a translation representation, a faithful sign
action at the returned state, and the common-eigenstate equations. The theorem
`clean-kickback-character` derives the character laws from those data.

## 2. Boolean response: one call really is one call

For `Z/2`, the map

```text
chi(0) = +1
chi(1) = -1
```

is a character. In the ordinary qubit realization its character state is
`|->=(|0>-|1>)/sqrt(2)`. Therefore the bit-query oracle

```text
|x>|b> -> |x>|b xor f(x)>
```

acts in one call as

```text
|x>|-> -> (-1)^f(x) |x>|->.
```

`bit-character` and `bit-character-is-nontrivial` check the finite algebra.
So if the organism's primitive response is already the Boolean predicate
`v_3(r+c) >= ell+1`, the exact ternary Grover step costs one response call,
not two.

## 3. Additive trit response: the sign phase is impossible

Let `chi : Z/3 -> {±1}` be a character. Since `3·1=0`,

```text
chi(1)^3 = chi(0) = +1.
```

But every sign satisfies `s^3=s`, so `chi(1)=+1`, and then
`chi(2)=chi(1)^2=+1`. Hence `chi` is trivial.

The checked theorem `trit-character-trivial` proves this pointwise, and
`no-clean-trit-threshold` composes it with `clean-kickback-character`. No
nonconstant ±1 predicate on an additive trit response can therefore be kicked
back by a single clean returned character state.

This is not a cardinality obstruction: both response alphabets are finite and
small. It is a representation obstruction. `Z/2` has an index-two character;
`Z/3` does not.

## 4. What changes in the ternary valuation protocol

The query count must now be reported by response type:

| installed oracle interface | exact phase-adapter verdict |
|---|---|
| Boolean threshold bit under XOR | one call by the nontrivial `Z/2` character |
| additive trit response | no nonconstant clean ±1 phase in one character-state call |
| integer valuation/value register | unspecified until its group law, encoding, and threshold extraction circuit are named |

For the third row, compute the value, reversibly evaluate the threshold, apply
the sign, and uncompute the value gives a generic two-response-call upper
bound. This note does not prove it minimal. A response encoding that installs
the threshold as a character coordinate can again use one call; that is an
interface change, not free post-processing of an unnamed “response oracle.”

The exact `k` versus `2k` ternary separation therefore survives under the
Boolean threshold oracle used in the theorem. It is not automatically a
separation against a raw valuation-value oracle. The organism's next move is
to choose and build the response representation, not to keep pricing an
untyped generic adapter.

## 5. Designed annihilation and scope

The cheapest killer is a nonconstant sign character of `Z/3`; the checked
theorem rules it out. At the circuit level, a clean one-query additive-trit
translation circuit that returns one fixed response state and produces a
nonconstant ±1 phase would attack the modelling implication. It would have to
violate one of the explicit representation, phase-compatibility, or
faithfulness hypotheses in the Agda record.

Not claimed:

- no lower bound for adapters that leave response garbage, measure, postselect,
  use a different output encoding, or access extra gates inside the oracle;
- no physical speedup, fault-tolerance estimate, process tensor, or indefinite
  causal order;
- no novelty for phase kickback, character states, or the elementary `Z/3`
  calculation.

The formal module checks the algebraic interface, not complex normalization or
laboratory realization.

## 6. Prior art

Character queries for finite Abelian response groups explicitly generalize the
phase-kickback trick in Asif Shakeel, *An Improved Query for the Hidden
Subgroup Problem* ([arXiv:1101.1053](https://arxiv.org/abs/1101.1053)). The
translation/character-state identity `T_a|chi> = chi(a)|chi>` is stated
directly in Milad Ghadimi, Hesam Soltanpanahi, and Vahid Salari,
*An Information-Theoretic Characterization of Optimal Value-Readout in
Response-Register Quantum Oracles*
([arXiv:2607.13198](https://arxiv.org/abs/2607.13198)). Both are primary
sources read before formalization. No prior-art search found or was needed for
the elementary fact `Hom(Z/3,Z/2)=0`; no novelty is claimed.

## 7. Checked evidence

```sh
cd formal/cubical
agda ResponseCharacterKickback.agda
```

`ResponseCharacterKickback.agda` is `--cubical --safe`, with no postulates and
no holes, and checks exit 0 on the current host. `Everything.agda` imports it,
so aggregate coverage is wired. The attempted aggregate replay did **not** exit
0 on this host: it stopped earlier at the unrelated
`Gamma0Partner.agda:55` toolchain-skew boundary, where the installed
Agda/Cubical exports `solve!` but the pinned source asks for `solve`. Therefore
no aggregate-green claim is made here; the new theorem's present evidence is
its standalone safe check.
