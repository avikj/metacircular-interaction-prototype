# Translation futures reform the residue forgotten by valuation

Fix a prime (p), a depth (k\ge1), and

\[
R_k=\mathbb Z/p^k\mathbb Z.
\]

The present sensor is truncated valuation

\[
\tau_k(r)=\min(v_p(r),k),                               \tag{1}
\]

where (	au_k(0)=k). It forgets the unit part of every nonzero residue. Let
the current action language contain all translations (T_c(r)=r+c),
(c\in R_k). The complete observable future is

\[
B_k(r):R_k\to\{0,\ldots,k\},\qquad
B_k(r)(c)=\tau_k(r+c).                                  \tag{2}
\]

## One-shot formation theorem

**Theorem 1.** The behavior map (B_k) is injective. More precisely, (r)
is reconstructed from (B_k(r)) by locating its unique depth-(k) response:

\[
\boxed{r=-c_0\pmod {p^k}},\qquad
c_0\text{ is the unique }c\text{ with }B_k(r)(c)=k.     \tag{3}
\]

**Proof.** By (1), (B_k(r)(c)=k) exactly when
(r+c=0) in (R_k). There is exactly one such continuation, (c=-r).
Equation (3) follows. ∎

Thus the Myhill--Nerode quotient for truncated valuation under the full
translation action is not a proper quotient at all: every residue state has a
different future. The action language reforms, in one shot, the complete
prime-power residue observable that the present valuation sensor forgot.

This is stronger than saying residues are useful extra data. It is a universal
property. If a carrier (q:R_k\to Q) is sufficient for every future response,
so that every (B_k(-)(c)) factors through (q), then
(q(r)=q(s)) implies (B_k(r)=B_k(s)), hence (r=s) by Theorem 1. Every
future-sufficient carrier is therefore injective. The residue chart is the
coarsest transferable state representation for this action/observation pair.

## Why the present valuation profile does not compose

For a labeled tuple, record the truncated valuations of all nonempty subset
sums currently available. Common multiplication by a unit preserves this
profile, but its orbits are far smaller than the profile classes.

**Theorem 2 (noncongruence).** At every prime there are two pairs with the
same complete present subset-valuation profile which become distinguishable
after adjoining one common input.

- (p=2), depth (3): ((1,2)) and ((1,6)) both have profile
  ((0,1,0)). Adjoin (1); the total depths are (2) and (3).
- (p=3), depth (2): ((1,1)) and ((1,4)) both have profile
  ((0,0,0)). Adjoin (4); the total depths are (1) and (2).
- (p\ge5), depth (2): ((1,1)) and ((1,2)) both have profile
  ((0,0,0)). Adjoin (p-2); the total depths are (1) and (0).

All displayed sums are nonzero in the integers; the distinction is not a
zero-typing artifact. The first coordinate is (1) in each pair, so a common
unit multiplier carrying the left pair to the right would have to equal (1)
modulo (p^k), contradicting the second coordinate. Hence common-unit scaling
is not the complete present equivalence, and present profile equivalence is
not a congruence for the append/addition action.

## Formation, compression, and changed frontier

The two theorems give one exact motion:

```text
present truncated valuations
→ compress many residue tuples together
→ adjoining an input exposes noncongruence
→ close observation under every translation continuation
→ recover the exact residue chart by the unique zero-producing action
```

This is an executable observable-formation event. No new sensor codomain was
guessed externally: the current action language and current coarse sensor
generate the behavior function (2), whose universal quotient is proved to be
(R_k). The obstruction changes the frontier from searching for a scalar
valuation-profile carrier to compiling residue actions efficiently.

The swarm's witness results sharpen the causal boundary. Formula (3) proves
semantic sufficiency using the continuation (-r); an organism must still
locate and construct that continuation. Residue/kuṭṭaka can locate critical
representatives and an addition chain can construct them in logarithmically
many events. Semantic identity, acquisition time, and reversible memory remain
separate quantities.

## Rigor boundary

Proved: Theorems 1--2 and the universal factorization consequence. These are
elementary finite arithmetic facts; no novelty is claimed.
`machinery/valuation_future_residue.py` builds and checks behavior signatures,
reconstructs residues, and emits the uniform noncongruence controls. Its finite
tests replay the proof consequences; enumeration is not the evidence.

Not proved: a smaller representation when only a restricted translation
submonoid is reachable; the minimal number of adaptive translation queries
needed to identify a residue; or a comparable reconstruction theorem for
non-additive polynomial action languages.

## Addendum: restricted translations form a perception staircase

The first open boundary has an exact classification. For (0\le s\le k),
let

\[
H_s=p^sR_k
\]

act by translation, and let (B_{k,s}(r)) be the restriction of (2) to
continuations (c\in H_s).

**Theorem 3.** Two residues have the same (H_s)-future exactly in the
following cases:

1. both have the same valuation (t<s); or
2. they are the same residue and lie in (H_s).

Consequently the quotient has exactly

\[
\boxed{s+p^{k-s}}                                      \tag{7}
\]

classes: (s) shallow valuation strata and (p^{k-s}) singleton residues
inside (H_s).

**Proof.** If (v_p(r)=t<s), then every (c\in H_s) has valuation at least
(s>t), so the unequal-depth ultrametric equality gives
(v_p(r+c)=t). Thus the behavior is the constant function (t), depending
only on the shallow depth.

If (r\in H_s), write (r=p^su) modulo (p^k). Every continuation is
(p^sh), and

\[
\tau_k(r+p^sh)=s+\tau_{k-s}(u+h),                      \tag{8}
\]

with saturation at (k). Theorem 1 at depth (k-s) says this full translated
future determines (u\pmod {p^{k-s}}), hence determines (r). A shallow
constant behavior cannot equal an (H_s) behavior because choosing
(c=-r\in H_s) produces depth (k). The count follows. ∎

**Theorem 4 (one-action formation event).** For (1\le s\le k), adjoining
one translation (c) with (v_p(c)=s-1) to the action group (H_s) generates
exactly (H_{s-1}). The quotient transition leaves every depth (<s-1)
class unchanged, leaves every singleton in (H_s) unchanged, and splits the
former depth-((s-1)) class into its individual residues.

**Proof.** Write (c=p^{s-1}u) with (u) a unit modulo (p^{k-s+1}).
The additive cyclic subgroup generated by (c) is (p^{s-1}R_k=H_{s-1}).
Apply Theorem 3 at consecutive values of (s). The only canonical label that
changes type is depth (s-1): it becomes the singleton part of
(H_{s-1}). ∎

At (s=k), only the zero translation is available and there are (k+1)
valuation meanings. At (s=0), all translations are available and all
(p^k) residues are distinct. Thus each newly formed valuation layer of
actions converts exactly one qualitative depth stratum into exact residue
addresses. This is an explicit changed frontier, not merely monotonic
refinement.
