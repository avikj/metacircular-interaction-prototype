# The alignment defect is a fibre, and exactly when it is a mutual information

**Status.** Four tagged claims. §1 THEOREM with a checked term (exit 0). §2
THEOREM, proof here. §3 THEOREM, proof here. §4 REJECTED, with the named
inequality that kills it. Nothing measured; no constant fitted; no floating
point anywhere.

**What was handed in.** A unification claim: *"area = log of the fibre",* with
`Avaccheda_…agda`'s `A ≃ Σ[ b ∈ B ] fiber f b` read at cardinality as
`log|A| = log|B| + log|fibre|` (additive), set against
`notes/CAUSAL_MEMORY_SPACETIME.md` Theorem 7.1,

    rank(AB) = rank(B) − dim(im B ∩ ker A),                            (11)

read as *composition is not additive*, with the question: **is the defect
`dim(im B ∩ ker A)` a mutual information?**

---

## 1. THEOREM — there is no conflict. (11) *is* the fibration, on a different map

**Checked:**
`formal/cubical/Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd.agda`,
`--cubical --safe`, no postulates, no holes, **exit 0** (Agda 2.8.0 + the
installed agda/cubical). Wired into `Everything.agda`.

    शेष     : fiber (g ∘ f) z ≃ Σ[ p ∈ fiber g z ] fiber f (fst p)
    शेषसमता : (∀ y → fiber f y ≃ Φ) → fiber (g ∘ f) z ≃ fiber g z × Φ
    शून्यशेष : all fibres of f contractible → all of g contractible
              → all of g ∘ f contractible

**The bridge, and it is one line:** (11) is rank–nullity applied to `A`
restricted to `im B`. That restriction `A| : im B → K^H` has image `im(AB)`
and kernel `im B ∩ ker A`. So the defect is *the dimension of a fibre* — and
**a linear map's fibres are uniform**, every nonempty one a coset of the
kernel. That is precisely the hypothesis of `शेषसमता`, which looked like a
restriction and is in fact what linearity supplies for free. Over `𝔽_q`:

    q^{dim im B}  =  q^{rank AB}  ·  q^{dim(im B ∩ ker A)}
    ⇒  dim im B  =  rank(AB) + dim(im B ∩ ker A)                       (11)

**So the "non-additivity of composition" is the additivity of the fibration,
read on the restricted map.** The two files were never in tension. What (11)
is not additive in is the *image dimension of a composite*, which is not the
quantity the fibration law is about.

**Verified on the note's own control (its eq. 13).** `A = diag(1,0)`,
`B_⊥ = diag(0,1)`. `im B_⊥ = ⟨e₂⟩ = ker A`, intersection dimension 1;
`rank B_⊥ = 1`, `rank(AB_⊥) = 0 = 1 − 1`. Over `𝔽₂`: `|im B_⊥| = 2 = 1 × 2`.

---

## 2. THEOREM — the defect is exactly a mutual information, over `𝔽_q`, and it is an equality

Fix `𝔽_q`. For subspaces `U, V ⊆ 𝔽_q^n` pick matrices `M, N` with row spaces
`U, V`. Let `Z` be uniform on `𝔽_q^n` and set `X := MZ`, `Y := NZ`. Then
`X` is uniform on a space of size `q^{dim U}`, so in `q`-ary units

    H(X) = dim U,   H(Y) = dim V,   H(X,Y) = dim(U + V),

because `(X,Y)` is uniform on the image of the stacked matrix. Hence

    I(X;Y) = dim U + dim V − dim(U+V) = dim(U ∩ V),                    (∗)

the last step being the **modular law** for the subspace lattice — an
*equality*, where von Neumann and Shannon entropy give only submodularity.
Taking `U = im B`, `V = ker A`:

> **The alignment defect `dim(im B ∩ ker A)` is `I(X;Y)` in `q`-ary units for
> explicitly constructible linear random variables.**

**The seam, stated because it is where the reading is unearned.** `X` and `Y`
are built *from the subspaces*, not from the process. (∗) is an exact identity;
calling it "the correlation between `A` and `B`" requires supplying a joint
distribution on the process, which neither `CAUSAL_MEMORY_SPACETIME.md` nor
`(11)` does. **Identity: earned. Interpretation: not.**

**Char. 0 kills the entropy reading outright.** The corpus's ranks are over
`ℚ`, where there is no uniform measure and `dim` is the log of nothing. The
counting reading exists only after reduction mod `p` — and rank *drops* mod
`p`. By `notes/SMITH_TORSION_BOUNDARY_MEMORY.md`'s invariant, if
`T` over `ℤ` has Smith form `diag(d₁,…,d_k)` then

    rank_{𝔽_p}(T) = #{ i : p ∤ d_i },     rank_ℚ(T) = k = sup_p rank_{𝔽_p}(T).

**THEOREM.** *The "area" of an integer cut is not a number but a function of
`p`, and the divisor chain determines it completely; the bad primes are exactly
those dividing some `d_i`.* This is the sharpest thing the Smith note's
receipt format buys: the free rank is the generic area, and the torsion is the
list of primes at which the area is smaller.

---

## 3. THEOREM — composing three cuts gives the data-processing inequality, not strong subadditivity

The handed-in guess was that three composed cuts should give SSA. It does not.
The three-map law over a field is **Frobenius**:

    rank(AB) + rank(BC) ≤ rank(B) + rank(ABC).

Write the defect `D(A;B) := rank(B) − rank(AB) = dim(im B ∩ ker A) ≥ 0`.
Frobenius rearranges, with no loss, to

    D(A; BC) ≤ D(A; B).                                                (†)

**Precomposition cannot increase the alignment defect.** That is the shape of
the data-processing inequality `I(X;Z) ≤ I(X;Y)` for `X → Y → Z`, and under
§2's dictionary it *is* one, for the linear random variables of (∗).

Note the sign. SSA reads `S(ABC) + S(B) ≤ S(AB) + S(BC)`; Frobenius reads the
**reverse**. So `rank` under *composition* is not an entropy — it is the
defect, not the rank, that behaves entropically.

SSA itself is available in this picture and is not the interesting statement:
for subspaces `U,V,W`, `I(X;Y|Z) ≥ 0` reads
`dim(U+W) + dim(V+W) ≥ dim(U+V+W) + dim W`, which follows in one line from the
modular law plus `W ⊆ (U+W) ∩ (V+W)`. **SSA here is a triviality; the content
under composition is (†).**

*(`_/_` note: (†) and Frobenius are classical linear algebra and are not
claimed as new. What is claimed is the identification of the defect with a
mutual information and hence of Frobenius with DPI.)*

---

## 4. REJECTED — "area = log of the fibre" as a statement about *entropy* in general

Rank-based entropies are a **proper subcone** of the entropy cone, and the
separating inequality is named and classical.

- Every set of random variables of the linear form `X_i = M_i Z` satisfies
  **Ingleton's inequality** (Ingleton 1971; the linear rank inequalities of
  Dougherty–Freiling–Zeger). Equivalently: the rank function of a
  representable matroid is an Ingleton function.
- **Ingleton is false for entropy.** The four-atom distribution
  (Matúš–Studený; Zhang–Yeung) violates it. So there are entropy vectors no
  configuration of subspaces can realise.

**Consequence for the handed-in claim.** `d = rank T` can be read as an
entropy only inside the linear class. A holographic or von Neumann entropy —
the thing `S = A/4` is about — lives outside it in general. So:

> **"Area = log of the fibre" is a THEOREM about linear cuts (§1, §2) and is
> REJECTED as a statement about entanglement entropy**, because the linear
> cut spectrum satisfies an inequality that entanglement entropy does not.

This is the same no-go one level up from `notes/QUANTUM_CUT_RANK_NO_GO.md`,
which showed ordinary rank is not PSD dimension on a single table. §4 shows the
whole *cone* of rank-entropies is too small, for a reason independent of that
example, and names the inequality that measures the gap.

**The test that would decide the remaining open piece (CONJECTURE).** The
holographic entropy cone additionally satisfies monogamy of mutual information
`I(A:BC) ≥ I(A:B) + I(A:C)`, which general quantum states violate. Whether the
linear/rank cone satisfies MMI, and therefore whether rank-entropies sit
*inside* the holographic cone rather than merely beside it, is a decidable
question about the four- and five-variable linear rank cones and is not settled
here. Decide it before any further sentence in this corpus pairs `rank T` with
Ryu–Takayanagi.

---

## Rigor boundary

Proved: §1 (checked term plus the one-line bridge), §2's (∗) and the
`rank_{𝔽_p}` formula, §3's (†) from Frobenius. Cited as established: Ingleton's
inequality for linear rank functions; its failure for entropy; Frobenius' rank
inequality; the Smith normal form. Not claimed: that any of this is about
physical spacetime, black holes, or gravity. `Landauer`, `Bekenstein–Hawking`,
`Van Raamsdonk` and `diffeomorphism invariance` appear in the handed-in claim
and in none of the four results above; nothing here licenses them.
