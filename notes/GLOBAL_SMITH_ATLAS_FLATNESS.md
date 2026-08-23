# Global Smith charts are flat

**Status:** exact standard no-go, author-proved in safe Cubical Agda;
independent audit unassigned. No novelty is claimed.

This note closes the loop question left by `SMITH_KERNEL_QUANTUM_BOUNDARY.md`.
It also makes one part of `NO_PRIVILEGED_CHART.md` precise without importing
that note's broader philosophical reading: transitions can carry real
information even when no chart is preferred, but nontrivial transitions do
not by themselves imply curvature or holonomy.

## 1. Global charts and their transitions

Let `K` be one Smith kernel type. A global coordinate chart is an isomorphism

```text
c_i : K ≅ C_i.
```

The transition from chart `i` to chart `j` is not extra data. It is forced:

```text
t_ij = c_j c_i^-1 : C_i ≅ C_j.                 (1)
```

This is exactly the situation after a Smith certificate has globally
identified every solution fibre with one presented kernel. The charts may
order generators differently, change signs, or choose other bijective labels;
all such choices are included in the `c_i`.

## 2. The cocycle theorem

**Theorem 2.1 (global-atlas flatness).** For three global charts,

```text
t_jk t_ij = t_ik,                               (2)
t_ki t_jk t_ij = id.                            (3)
```

**Proof.** Substitute (1):

```text
t_jk t_ij
  = (c_k c_j^-1)(c_j c_i^-1)
  = c_k c_i^-1
  = t_ik.
```

Composing with `t_ki=c_i c_k^-1` gives the identity. ∎

In intensional type theory these equalities need not be definitional. The
formal proof is propositional because an arbitrary `Iso` supplies its inverse
laws as paths. That is forecast branch `0.12`, and it does not weaken the
no-go: a path to the identity still refutes a nonidentity loop witness.

**Corollary 2.2 (holonomy no-go).** A nonidentity kernel-coordinate holonomy
cannot be generated solely by composing globally defined Smith coordinate
changes on one fibre. Any such claimed witness contradicts (3).

This is a coboundary statement: globally chosen coordinates make every
transition `c_j c_i^-1`, so the resulting Čech 1-cocycle is exact.

## 3. Quantum/process correspondence

For a finite kernel, every `t_ij` is a basis permutation. Its canonical linear
extension is a unitary and needs no discarded state. Equivalently, the exact
recorded update

```text
x |-> (t_ij(x), tt)
```

is injective, so `Unit` is an attaining coherent environment. A route change
can be nonidentity while costing one environment level.

Thus R0075's two coordinates separate two resources:

```text
kernel erasure:      |K| environment levels,
kernel relabelling:  1 environment level.
```

The transition automorphism is operational information, but it is reversible
control information rather than garbage.

### Phase scope

A unitary implementation may deliberately multiply permutation basis states
by route-dependent phases. Coherent superposition of routes can then observe a
relative phase around a loop. Such a phase is **additional connection data**;
it is not determined by the Smith charts or their set-level transitions.
The theorem kills coordinate holonomy and the canonical permutation-unitary
lift, not every possible projective or phase-decorated quantum control.

## 4. Non-vacuous four-state control

Take

```text
K = (Z/2)^2
```

and three global charts:

```text
c0(a,b) = (a,b),
c1(a,b) = (b,a),
c2(a,b) = (not a,b).
```

The transition `t_01` is coordinate swap and `t_02` flips the first bit. Both
are nonidentity: at `(0,1)` they return `(1,0)` and `(1,1)`, respectively.
Nevertheless

```text
t_20 t_12 t_01 (0,1) = (0,1),
```

and Theorem 2.1 proves the same equality at every point without enumeration.
Each of the three edges attains a `Unit` environment.

`NaturalMachine.GlobalSmithAtlasFlatness` checks the generic transition
isomorphism, cocycle, triangle identity, nonidentity-edge witnesses,
holonomy no-go, and all three singleton-environment certificates.

## 5. What changed

R0075 proposed composing three route trivialisations and asking whether a
nontrivial loop remained. Under its declared global-coordinate interface, that
search is now closed negatively. More examples cannot change the answer.

A genuine successor must change a hypothesis explicitly:

1. **Local charts:** no single global trivialisation `K≅C_i` exists across the
   whole base of outputs; transition functions live only on overlaps.
2. **Path-dependent transport:** the map assigned to a route is not determined
   by its endpoint charts, i.e. a connection has been installed.
3. **Phase-decorated lift:** quantum implementations carry relative phases not
   present in the classical Smith coordinate map.
4. **Fibre-changing intervention:** an observation, quotient, or action changes
   which kernel/fibre is being transported.

Until one of these objects is earned by live arithmetic, “Smith holonomy” is
the wrong next search. The organism should retain explicit transition maps for
interoperability, but it should stop expecting curvature from global
relabelings.

## 6. Rigor boundary

- The theorem is about global isomorphisms of one kernel and their induced
  transitions.
- It does not prove a global Smith chart exists for every family of matrices.
- It does not classify local Smith families, singular parameter loci, Berry
  phases, projective representations, or indefinite causal order.
- It makes no gate-count, timing, thermodynamic, or quantum-advantage claim.
- The mathematics is the standard cancellation law for changes of coordinates;
  the repository contribution is its exact placement at R0075's process seam.

