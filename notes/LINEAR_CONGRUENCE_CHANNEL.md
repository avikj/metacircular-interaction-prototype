# The gcd is the channel kernel

**Status.** Standard finite cyclic-group mathematics, packaged as a checked
Mathlib adapter in
`formal/pairfield/Pairfield/LinearCongruenceChannel.lean`. No novelty claim.

## 1. The sampled object

A literal no-redraw corpus sample selected
`ARITHMETIC_LIFE_LINEAR_CONGRUENCE_DESCENT.md`. That note proves the classical
criterion for

\[
  az\equiv b\pmod m:
  \qquad g=\gcd(a,m)\mid b,
\]

and shows that every compatible right-hand side has exactly `g` solutions
modulo `m`. The encounter here does not prove that theorem again. It asks what
the theorem says about observation and decoding.

Let

\[
  \mu_a:\mathbb Z/m\mathbb Z\longrightarrow\mathbb Z/m\mathbb Z,
  \qquad z\longmapsto az.
\]

This is a deterministic channel and an additive-group homomorphism. Its exact
information boundary is

\[
 \boxed{
 |\ker\mu_a|=g,
 \qquad
 |\operatorname{im}\mu_a|=m/g,
 \qquad
 |\ker\mu_a|\,|\operatorname{im}\mu_a|=m.
 }
\]

Every occupied fibre is a translate of the kernel, not merely a set with the
same cardinality. Thus the output identifies precisely one kernel coset.

## 2. Three different decoding questions

The phrase “solve the congruence” can hide three distinct maps.

1. **Was the received value possible?** A value `b` is possible exactly when
   `b` belongs to `im μ_a`, equivalently when `g | b`.
2. **Which observational class produced it?** The first isomorphism theorem
   gives a canonical additive equivalence

   \[
     (\mathbb Z/m\mathbb Z)/\ker\mu_a
       \;\cong\; \operatorname{im}\mu_a.
   \]

   The output therefore decodes the input class exactly.
3. **Which original residue produced it?** A decoder `D` satisfying
   `D(μ_a(z))=z` for every `z` exists exactly when `g=1`. For `g>1`, any
   function choosing one representative from each occupied fibre is a right
   section onto the image, not recovery of the input.

This distinction answers the live section/retraction warning in a native
arithmetic object. A bare section can coexist with maximal information loss:
the zero channel on a finite cyclic group has one output, its whole domain as
kernel, and still permits choosing a representative of that one occupied
fibre. What fails is the left-inverse equation on inputs.

## 3. The sampled example

For `a=12` and `m=30`,

\[
 g=6,\qquad |\operatorname{im}\mu_{12}|=5.
\]

The possible outputs are the five multiples of six. The fibre over `18` is

\[
 \{4,9,14,19,24,29\}\pmod {30},
\]

which is the single input class `z=4 mod 5`. Six is the ambiguity, while five
is the number of distinguishable outputs. Calling `g` the channel capacity
would exchange the forgotten and retained quantities.

The opposite controls are exact. Multiplication by `7` on `Z/30` has kernel
size one, range size thirty, and an exact decoder. Multiplication by zero has
kernel size thirty and range size one.

## 4. Checked interface

For any finite cyclic additive group `G` and natural number `d`, the Lean
module checks:

- `sameOutput_iff_sub_mem_kernel`: equal outputs are exactly differences in
  the kernel;
- `outputCard` and `kernelCard`: the two gcd cardinality formulas;
- `occupiedFiberEquivKernel` and `occupiedFiberCard`: every occupied fibre is
  equivalent to the kernel and has the same cardinality;
- `observableClassesEquivOutputs`: the quotient by the kernel is additively
  equivalent to the range;
- `ambiguity_mul_outputCard`: exact finite information balance;
- `hasExactDecoder_iff`: full input reconstruction is equivalent to
  `gcd(|G|,d)=1`;
- the `12 mod 30`, unit, and zero controls above.

The proof reuses Mathlib's first isomorphism theorem and its cardinality
theorems for power maps on finite cyclic groups, transported additively to
`nsmulAddMonoidHom`. The repository contribution is the typed interface
between the classical congruence result, sufficient-statistic language, and
the decoder boundary; it is not a new cyclic-group theorem.

## 5. Search and rigor boundary

Search was performed before opening the sampled note under the standard terms
“linear congruence solvability”, “gcd”, “solution fibre”, `Int.ModEq`, and
finite cyclic-group kernel/range. The prescribed local `~/agda-libs` surface
was absent on this host. `notes/PRIOR_ART_INDEX.md` points to UniMath's
congruence and Bézout modules. Local Mathlib source supplies
`IsAddCyclic.card_nsmulAddMonoidHom_{ker,range}`,
`AddMonoidHom.fiberEquivKer`, and
`QuotientAddGroup.quotientKerEquivRange`. Web search summaries independently
reported the classical `gcd(a,m)|b` criterion and exactly `gcd(a,m)` solution
classes; no webpage text is used as proof.

**Proved by the checked module:** every statement in §4 and its three finite
controls.

**Established prior art:** the solvability criterion, fibre count, and first
isomorphism theorem.

**Interpretive but exact:** “retained output count” means the cardinality of
the deterministic channel range; “ambiguity” means occupied-fibre
cardinality. If the input is uniform, their base-two logarithms are the usual
output and conditional entropies, but no probability distribution or entropy
identity is formalized here.

**Not claimed:** a canonical representative of a nontrivial fibre, a group
splitting of the image inclusion, a new coding theorem, or minimality for any
task not explicitly invariant under the kernel relation.
