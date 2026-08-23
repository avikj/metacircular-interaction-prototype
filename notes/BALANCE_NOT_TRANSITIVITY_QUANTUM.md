# Fibre balance, not transitivity, is the exact quantum cost criterion

**Status.** Exact finite no-go, author-proved in safe Cubical Agda; independent
audit unassigned.  This corrects a mechanism claim, not `INDEX_LAW` Theorems I
or E.  Both the maximum-fibre theorem and the orbit argument survive.

## 1. The distinction the new synthesis blurred

For a finite surjection `q : X -> Y`, exact coherent overwrite has minimum
environment dimension

```text
d_E(q) = max_y |q^-1(y)|.
```

Consequently its index floor is attained exactly when the fibres are balanced
(equal when `|Y|` divides `|X|`, otherwise differing by at most one).  A group
acting equivariantly on `q` and transitively on `Y` forces equal fibres, so it
is one sufficient proof of balance.

Those statements do not make transitivity necessary.  `INDEX_LAW` itself
keeps the logical direction correct, but its later sentence calling
transitive equivariance *the criterion* and the subsequent organism synthesis
promoting it to *the mechanism* overstate Theorem E.

## 2. A balanced quotient with no structure-preserving target swap

Let

```text
X = Bool x Bool,
q(a,b) = a.
```

Both fibres are canonically `Bool`.  The certificate `c(a,b)=b` makes
`(q,c)` the identity coordinate map, so a two-level environment attains the
bound.  Conversely, the false fibre embeds into every valid certificate
alphabet, so no smaller alphabet can work.

Now retain one bit of source structure:

```text
mark(false,false) = true,
mark(x)            = false otherwise.
```

There is no map `g : X -> X`—even before requiring bijectivity—such that

```text
q(g x)    = not(q x),
mark(g x) = mark(x)
```

for every `x`.  Indeed, the unique marked point lies over `false`, whereas
every point over `true` is unmarked.  A lift of target negation would have to
carry that point into the true fibre while preserving its mark, a
contradiction.

This excludes every structure-preserving transitive group action compatible
with `q`: on the two-point target, an action element carrying `false` to
`true` is the swap, and equivariance would supply exactly the forbidden lift.

The hostile control locates the obstruction.  If the mark is erased, the map

```text
(a,b) -> (not a,b)
```

is an involutive lift of target negation.  Thus the quotient is balanced and
quantum-cheap both before and after forgetting the mark; only the claimed
symmetry mechanism changes.

## 3. The exact dichotomy

There are two readings of “some transitive symmetry.”

1. **A declared symmetry preserving the retained object.** It is not
   necessary, by the marked counterexample.
2. **An arbitrary bare-set symmetry invented after forgetting structure.**
   Equal fibres let one choose coordinatizations and manufacture such an
   action.  This is noncanonical restatement of balance, not a causal
   explanation and not state the organism has earned.

So Theorem E remains useful proof provenance: a natural transitive action
certifies balance without counting.  It is not the resource carrier and it
must not authorize erasing source structure merely to manufacture symmetry.

This is parallel to, but distinct from,
`CONSTANCY_NOT_TRANSITIVITY`: constancy is the criterion for verdict
invisibility; fibre balance is the criterion for attaining the reversible
index floor.  Both reject transitivity as necessary, for different typed
questions.

## 4. The requested coarsening law was already present

`INDEX_LAW` asks for a general coarsening penalty.  It is equation (1) of
`QUANTUM_QUOTIENT_COMPOSITION`.  For

```text
X -q-> Y -r-> Z,
a_y = |q^-1(y)|,
```

the exact composite cost is

```text
d_E(r q) = max_z sum_(y in r^-1(z)) a_y.
```

This identifies the state a compiler needs: the first-stage fibre histogram
and its incidence with the coarsening blocks.  Scalar stage costs do not
compose; the existing `(2,2,1,1)` example yields composite cost `4` or `3`
under two coarsenings with identical stage maxima.

## 5. Changed next move

- Carry the fibre histogram and a fibrewise certificate/trivialisation.
- Price coarsening by weighted block maxima, not by the presence or absence of
  a group.
- Retain natural group actions when transfer or equivariance is itself used;
  treat them as proof provenance for balance when only memory is priced.
- Do not build a symmetry field into the quantum compiler merely to explain
  an index equality that the histogram already decides exactly.

The next live quantum question is therefore incremental maintenance of the
histogram/incidence certificate under formed observations, not recovery of an
otherwise absent transitive group.

## 6. Checked certificate and scope

`NaturalMachine.BalanceWithoutTransitivity` checks:

- explicit isomorphisms from both fibres to `Bool`;
- the embedding lower bound into every exact certificate alphabet;
- the attaining second-coordinate certificate;
- impossibility of every mark-preserving lift of target negation;
- the bare involutive swap and its failure to preserve the mark.

Focused and root `--cubical --safe --no-import-sorts` builds exit zero.  The
root warnings are the repository's pre-existing unsupported-indexed-match
boundary; the new module emits none.  No gate-count, thermodynamic,
infinite-dimensional, approximate, or physical-symmetry claim is made.

The underlying finite-set facts are standard and no novelty is claimed.  The
result is the exact repository correction and routing consequence.

