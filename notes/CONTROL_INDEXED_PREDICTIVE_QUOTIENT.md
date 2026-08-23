# Predictive memory is indexed by the control language

A closed transformation monoid does not determine which of its elements are
available as future interventions. Let `C` be a declared family of experiments
on installed configurations. Define

`x ~_C y` iff every `c in C` gives the same observation from `x` and `y`.

If `C subset D`, then `~_D` refines `~_C`: equality under more experiments
implies equality under fewer. Consequently the number of predictive classes,
and hence the exact zero-error memory dimension, is monotone nondecreasing as
controls are added. This elementary contravariance is the finite core of the
distinction between autonomous dynamics and an intervention-bearing process.

## One monoid, two process interfaces

For multipliers `mu_a(x)=ax` on `Z/5Z`, use installed configurations
`(a,x)` with initial point `x=1` and observation `zero/one/other`.

**Autonomous control.** After installation, the only evolution is repeated
application of that same `mu_a`. Complete power traces have four classes

`{0}`, `{1}`, `{4}`, `{2,3}`.

Exact classical and zero-error quantum predictive dimension is four.

**Selectable-scalar control.** At the future port, any multiplier `mu_b` may
be selected independently. The response of installed `a` is `h(ba)`. Every
pair of units is separated by choosing `b=a^{-1}`; zero is already separate.
The quotient is discrete and exact dimension is five. In particular `b=2`
separates installed `2` and `3`, producing `4` versus `1`.

Both processes use the same finite carrier, closed monoid, seed, and
observation. They differ only in causal interface. Therefore these algebraic
data do not determine a unique predictive quotient or quantum memory cost.

## Decisive no-go and changed motion

There is no functor from an untyped closed action monoid plus observation to
“the” process memory that returns both values: the same input data support the
two exact dimensions `4` and `5`. One must additionally declare who or what
may choose future controls.

The correct common carrier is the family `C |-> Q_C` of predictive quotients,
ordered contravariantly by inclusion of control languages. Autonomous reuse
and adversarial intervention are two points in that family, not rival claims
about one quotient. Installation authority remains separate again: computing
the response under `b` does not authorize applying `b`.

This changes the organism's next move. Every compiled action family must ship
with a typed continuation interface:

1. fixed autonomous evolution;
2. externally selectable interventions;
3. or an explicitly stated mixture with provenance and causal order.

Only after that declaration should it minimize predictive memory. Algebraic
closure says compositions exist; it says neither that the environment can
select them nor that the installed system will select only itself.

## Rigor boundary

The refinement theorem and both finite dimensions are proved. “Quantum” here
means only the zero-error dimension forced by orthogonal response laws. This
is not a physical process tensor, coherent-control advantage, thermodynamic
cost, indefinite causal order, or spacetime claim.
