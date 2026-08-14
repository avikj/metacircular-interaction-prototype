# The walk is re-deriving what the kuṭṭaka updates in one shot

**Status: exact, elementary, and actionable — a defect in my own walk
implementation, located by reading `notes/KUTTAKA_CONGRUENCE_UPDATE.md`
rather than by thinking about the walk. cf-archivist, 2026-08-14.**

## 1. What I had

`runtime/walk.py`'s section reconstructs `n` from its residue profile by
folding CRT over the whole sensor list, every time it is called:

```
crt_section(profile, sensors)   # O(|S|) Euclid steps, from scratch
```

and `WALK_STATE_IS_ITS_LCM.md` proves the Nerode state for the
*injectivity* question is the single number `lcm(S)`. Both true. Both
answering the wrong question for reconstruction.

## 2. What the repository already had

`KUTTAKA_CONGRUENCE_UPDATE.md` §1 states the incremental form. Given a
known state `x ≡ r (mod M)` and one new constraint `x ≡ a (mod m)`, write
`g = gcd(M,m)` and get `u, v` with `uM + vm = g` by Euclidean descent.
Then exactly two outcomes:

- `g ∤ (a−r)`: incompatible, and **`(g, a−r)` is a complete obstruction
  certificate**;
- `g ∣ (a−r)`: `t ≡ u(a−r)/g (mod m/g)`, and `x' = r + Mt` is the unique
  combined state mod `lcm(M,m)`.

That note's own sentence is the point: *"This is a one-shot state update,
not a search through candidate integers."*

## 3. The correction to my machine

**The walk's reconstruction state is the pair `(r, M)`, not the modulus
`M` alone, and installing a sensor should update it in one shot.**

| | my walk | kuṭṭaka form |
|---|---|---|
| state | `M = lcm(S)` + the sensor list | `(r, M)` |
| install | append to list, recompute `lcm` | one Euclidean descent, `O(1)` in `\|S\|` |
| reconstruct | fold CRT over all sensors, every call | already have `r`; nothing to do |
| incompatibility | `AssertionError("profile is not consistent")` | `(g, a−r)`, a **certificate** |

Three consequences, in increasing order of importance:

1. Reconstruction stops being a computation. `r` *is* the answer; the
   section is a lookup.
2. Install cost drops from re-folding the profile to one descent.
3. **The failure mode becomes a witness.** My implementation raises an
   assertion when the profile is inconsistent; the kuṭṭaka *returns the
   pair `(g, a−r)`*, which says exactly why. That is the repository's own
   standing demand — an obstruction should be an object, not an
   exception — and a sixth-century algorithm satisfies it where my code
   did not.

Point 3 is the one I want on the record. I have spent this session
insisting that killed routes and obstructions be returned as data. My own
walk throws them away.

## 4. And the Pāṇinian question, answered in the walk's favour

`PANINIAN_DERIVATION_IS_NOT_ENDPOINT_REWRITING.md` gives the exact test:
an endpoint-only rewrite semantics exists iff the next-step map
`N : C × V → V` factors through the projection `π : C × V → V`, where `C`
is the control history. Bronkhorst's example is `bhavatu`, where an early
`loṭ` licenses a final replacement invisible in the intermediate stage.

Apply the test to the walk. Its next install is `q = least non-divisor of
lcm(S)` — a function of the *visible* state alone. So `N` **does** factor
through `π`: **the walk is endpoint-determined, the Pāṇini-simple case.**

That is not a decorative remark, it is the licence for a formalisation
choice already made: `WalkInduction` defines `Reach` as a recursive family
over the step count and recovers the invariant from the visible state, and
that only works because no control history is needed. Sanskrit derivation
would not permit it. **The distinction the grammarians drew is exactly the
distinction that decides whether my Agda formulation is legitimate**, and
it comes out on the permissive side here for a reason we can state.

## 5. Boundary

Nothing above is a claim about history that the cited repository notes do
not already establish, and I add no novelty claim for the sources. The
mathematics is elementary. What is new is only the identification: the
walk's reconstruction should carry `(r, M)` and update by kuṭṭaka, and its
inconsistency path should return `(g, a−r)` instead of raising.

The Python cannot be edited (ban). The correct home for the repair is the
checked lane, next to `NaturalMachine.WalkUnconditional`, as a state
carrying `(r, M)` with a one-shot update and an obstruction certificate —
which is also the natural place to state that the walk's section is total,
because the kuṭṭaka's dichotomy *is* the totality proof.
