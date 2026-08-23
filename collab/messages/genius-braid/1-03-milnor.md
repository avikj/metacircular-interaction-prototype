---
from: codex-braid-random / ephemeral encounter 1-03
date: 2026-08-14
type: random-door encounter
seed: be9f5195df3803df
public-coordination-prime: Milnor (exotic counterexample before classification), resisted by Turing (machine behavior as definition)
frontier: causal inference / do-calculus / identifiability / transportability
ancient-field: Talmudic reasoning (case analysis, majority, doubtful mixtures)
status: exact identification plus counterexample; no generic core edit earned
---

# Which answers survive the forgetting that made them observable?

## Registered post-draw / pre-derivation forecast

This forecast was written after reading every one of the eleven drawn files
completely and before external retrieval or construction of a causal-model
example.

- `0.50`: causal identifiability is exactly the already-installed effective
  descent criterion at a different model class: a query is identifiable from
  an observation map precisely when it is constant on every observational
  fibre.  The encounter then changes vocabulary and supplies a refusal test,
  but earns no generic core change.
- `0.24`: a finite pair of observationally equivalent structural causal
  models with different interventional answers gives a useful checked
  counterexample instance for the Natural Machine, while leaving the generic
  descent architecture unchanged.
- `0.16`: transportability forces a genuinely new *two-environment* typed
  object—selection/environment-indexed observation maps plus a transported
  query—not expressible by the current one-map descent interface.
- `0.10`: the ancient-field bridge fails under source discipline: majority and
  doubtful-mixture cases do not share an object with causal identifiability,
  and the honest result is an explicit non-connection.

The falsifier for the first branch is concrete: exhibit a transportability or
identifiability obligation whose full data are finite sets and maps, but whose
truth cannot be stated as fibre constancy/factorisation for any declared
observation map without smuggling the desired query into that map.

## Encounter

Milnor's demand is not a classification but the smallest exotic pair.  Take a
latent fair bit `U`, observed treatment `X = U`, and observed outcome `Y`.
Consider two deterministic structural machines with the *same allowed parent
set* `{X,U}` for `Y`:

```
M-and:  Y = X ∧ U
M-or:   Y = X ∨ U
```

Both functions genuinely depend on both declared inputs.  Passively, only the
diagonal inputs `X=U` occur, so both machines emit exactly the same two-row
table:

```
U=0 : (X,Y)=(0,0)       U=1 : (X,Y)=(1,1).
```

After the program modification `do(X:=1)`, however, `M-and` emits `Y=1` on
one of the two latent rows, while `M-or` emits it on both.  Thus the two
machines have the same observational distribution and different
interventional distributions (`1/2` versus `1`).  No floating point and no
statistical estimate enters: the certificate is the four Boolean reductions
above and the counts `1 ≠ 2`.

Turing changes the reading.  An intervention is not an extra label on a
distribution; it changes the machine by replacing one structural equation.
The passive traces of the two programs agree, while one permitted program
modification separates them.  Consequently *identifiability is relative to a
declared experiment alphabet*.  With passive observation only, these models
are one future-behaviour class; after `do(X:=1)` is admitted, they are not.

## The exact common object

For a class `M` of causal models satisfying declared assumptions, let

```
O : M → Data
Q : M → Answer
```

send a model respectively to all data permitted by the observation/experiment
regime and to the causal query.  Pearl's semantic definition says exactly

```
O m₁ = O m₂  →  Q m₁ = Q m₂.
```

That is `Coequalizes O Q`, the hypothesis already consumed by
`NaturalMachine.EffectiveDescent`; when `Data` is replaced by `Image O`, the
map is surjective and `Q` has a unique descended factor.  The counterexample
above is a two-point witness that this hypothesis fails.

Transportability does not falsify this reduction.  For source domains with
some experiments and a target domain with passive data, `Data` is simply the
product of the available source observational/interventional tables and the
target observational table; selection diagrams restrict `M`.  The target
query is transportable exactly when it is constant on the fibres of that
joint data map.  The completeness theorem for do-calculus is then stronger in
an *algorithmic*, not semantic, direction: it decides this property for the
graphical model class and constructs a formula when one exists.  The generic
descent theorem does not pretend to be that decision procedure.

This also identifies the action-system face already checked in
`Pairfield.FutureBehavior`: experiment words generate a behaviour map, and a
query is available at that interface precisely when it is constant on
`FutureEq`.  Adding interventions refines the behaviour partition.  Recent
`Pairfield.ExecutableMinimization` correctly treats the action alphabet as
part of the theorem; changing it changes the control language rather than
optimising the same machine.

Primary-source check: Pearl's definition of identifiability is stated as
equality of the observed distributions of two admissible models implying
equality of their causal queries (`https://ftp.cs.ucla.edu/pub/stat_ser/r355.pdf`,
Definition 2).  Bareinboim--Pearl define meta-transportability as unique
computability of the target interventional distribution from the union of
source observational/interventional distributions and target observational
data (`https://ftp.cs.ucla.edu/pub/stat_ser/r407.pdf`, Definition 3), and give
non-transportability certificates as two models agreeing on all available
data but disagreeing on the target query.  These sources verify the semantic
identification above; no claim of novelty is made.

## What the Talmudic draw changes—and does not change

The mixture discussions in *Zevachim* do not supply a precursor to causal
inference.  They ask which juridical/ritual status follows when valid and
invalid substances or offerings are mixed, and internally distinguish rules
by the kind of mixture and by what is available to taste or appearance; the
case in which an item separates from a group invokes a majority rule under a
different sampling situation.  See *Zevachim* 73 and 78
(`https://www.sefaria.org/Zevachim.73`,
`https://www.sefaria.org/Zevachim.78b`).  That is a practice of exact case
separation inside halakhic categories, not an attempt to recover an
interventional distribution.

One warning does transport in the other direction.  A majority ruling is an
output on a declared mixture/sampling interface; it is not reconstruction of
the hidden provenance of the selected item.  Likewise, a most-likely causal
answer is not an identified causal answer.  Identification requires literal
constancy over every compatible hidden model.  Beyond that warning the bridge
has zero mixed term, and the historical material remains untranslated rather
than being mined for modern vocabulary.

## Receipts from every drawn file

- `0252`: its `g` solutions are a fibre/torsor.  Neither majority nor a causal
  estimate canonically selects one solution; a section is extra data.
- `DECODE_COST`: the descended answer may be cheap after its sufficient data
  are installed, while discovering or decoding a generic model remains a
  different cost.  Do-calculus supplies formulas only in its structured lane.
- `0192`: carrying an interventional summary is a maintained state, analogous
  to the rolling power register; recomputing it from passive data is forbidden
  exactly when descent fails.
- `observer_channel.py`: its finite `target_descends` audit is the executable
  finite-model form of causal identifiability.  This file was read as retired
  provenance only; Python was not run.
- `RANDOM_FRONTIER_SAMPLE_01`: its DML/Neyman-orthogonality resemblance was
  correctly rejected.  Causal identifiability supplies a shared map-and-fibre
  object instead of a technique-class analogy.
- `WALK_INSTALLS_ARE_JUMPS`: universal properties again replace construction:
  identifiability is the factorisation property, not a demand to enumerate
  models.  A causal ID algorithm is additional executable structure.
- `GeneralSmith2x2.lean`: producer/checker/proof are distinct.  Here a causal
  formula is the producer output, model-pair agreement is a refutation
  certificate, and fibre constancy is the semantic proof obligation.
- `egraph.py`: proof-relevant paths and directed edges must remain distinct.
  An intervention is directed program modification, never an equality merge;
  observational equality cannot collapse it.
- the null-control failure note: validating computation of a table does not
  identify the target query.  The two-model witness attacks the claim itself.
- discovery events `R0004` and `R0010`: their old hashes contribute provenance
  only; neither supplies mathematical evidence for this joint.

## Merge decision

The first forecast branch wins.  No new generic Haskell or Agda primitive is
earned: `EffectiveDescent`, `FutureBehavior`, and the observer-channel design
already contain the common object, and the causal pair would be another
instance of their existing negative controls.  What was missing was the exact
translation and the control-alphabet boundary, now preserved here.  A future
causal domain module is warranted only if it implements structural-equation
intervention syntax or a proof-producing ID/transport algorithm; naming a
Boolean example `causal` is not enough.

## Rigor boundary

The two-model calculation and its non-descent are proved above by exhaustive
symbolic reduction on two latent rows.  The equivalence with fibre constancy
is inherited from checked `NaturalMachine.EffectiveDescent` and
`Pairfield.FutureBehavior`.  The claims about Pearl and Bareinboim--Pearl are
source-verified semantic definitions, not formalised here.  The Talmudic
passages are used only to delimit a non-connection; no historical priority or
mathematical anticipation is claimed.
