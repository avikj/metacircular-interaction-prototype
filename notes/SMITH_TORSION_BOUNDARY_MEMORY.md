# The boundary of an integer cut is a group, and its torsion is memory

**Status:** exact algebra plus receipts already checked in the constructive
lane; interpretive readings are graded MINE below. Nothing here is measured;
every symbol quoted from a file was read in that file, and every line number
carries the command that produces it.

**Position:** this is the **numerical companion** to the checked
identification landed in commit `990d75aa` —
`formal/cubical/Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFibreFailingToBeContractible.agda`.
That module proves the *structural* half of the cut theorem: the history set
decomposes over the boundary as base-plus-fibre
(`अवच्छेदः : (Σ[ b ∈ B ] स्मृतिः b) ≃ A` with `स्मृतिः b = fiber f b`), "no
memory" is exactly `isEquiv` (`स्मृत्यभावः : isEquiv f → (b : B) → isContr
(fiber f b)`, then `सीमा-सर्वम् : isEquiv f → A ≡ B`), and memory is the
fibre failing to be contractible, with Tantujala's three verdicts
(रिक्तम्/एकम्/बहु) showing a boolean verdict on a cut conflates
"unreachable" with "remembered". This note does not restate any of that.
Its own §४ names what it leaves open: *"the rank. `d = rank T` is a
dimension and §१ is a decomposition, so the numerical half of the cut
theorem is still only in prose."* The numerical half is what follows.

**Terms (plain dictionary senses only; no text is claimed):**
*śeṣa* — remainder, what is left over; *koṣṭha* — cell, compartment. Used
below only as names for "the retained remainder at a cut" and "the cell of a
normal form". No Sanskrit source is cited and no historical claim is made.

---

## 1. What this note translates

`notes/CAUSAL_MEMORY_SPACETIME.md` prices a cut of a process table
\(T : H\times F\to K\) by its **Linear cut theorem** (its eq. 2):
over a field, the least boundary dimension in a factorization
\(T(h,f)=\sum_{b=1}^d A(h,b)B(b,f)\) is \(d=\operatorname{rank} T\).
Its §5 then proposes a **typed boundary spectrum**
\((r_{\mathbb Q}(C),\,r_+(C),\,r_{\rm CP}(C),\,I(C))\) (its eq. 8) and asks
(quoting its lines 210–213):

> "It is a comparison theorem or strict separation among these cut spectra on
> explicit processes, followed by a gluing law under process composition."

The structural half of that program is now a checked term (अवच्छेद, cited
above). The numerical half — the invariant that prices the cut — is still
prose, and over a field it is the rank. But the corpus's actual tables are
exact over \(\mathbb Z\), not over a field. Over \(\mathbb Z\) the
classifying invariant of a linear map is not the rank but the **Smith
normal form**, and the translation this note performs is:

> **The first coordinate \(r_{\mathbb Q}(C)\) of the typed boundary spectrum
> is only the free part of a finer, already-computable invariant. The
> integer cut classifies as
> \(\mathbb Z^r \oplus \mathbb Z/d_1 \oplus \cdots \oplus \mathbb Z/d_k\)
> with \(d_1\mid d_2\mid\cdots\mid d_k\), and the invariant factors
> \(d_i\) are a retained datum the rank cannot see.**

The three lanes of the translation, each with its receipt:

1. **producer** — the Cubical library ships a total, proof-carrying Smith
   normalizer, exposed in this repo (§3);
2. **instance** — the corpus has already computed a *pure-torsion* boundary
   without naming it as such: `KuttakaValli.agda`'s determinant law is a cut
   whose retained datum is valued in \(\mathbb Z/2\cong\{\pm1\}\) — zero
   free rank, one invariant factor \(d_1=2\) (§4);
3. **ask** — §5's requested gluing law has an uncited skeleton already in
   the collab library: the sheaf items of `COORDINATION_THEOREMS_XLVI` (§6).

## 2. The exact statement, with the module named

Let \(T\) be an \(H\times F\) matrix over \(\mathbb Z\), i.e. a
\(\mathbb Z\)-linear map \(T:\mathbb Z^F\to\mathbb Z^H\) of free
\(\mathbb Z\)-modules. Smith's theorem: there exist
\(U\in GL_{|H|}(\mathbb Z)\), \(V\in GL_{|F|}(\mathbb Z)\) with
\(UTV = \operatorname{diag}(d_1,\dots,d_k,0,\dots)\) and
\(d_1\mid d_2\mid\cdots\mid d_k\), \(d_i\neq 0\); the \(d_i\) (up to units)
are invariants of \(T\).

**Which module the invariant factors are of** — stated precisely, because
this is where loose talk goes wrong:

- They are the invariant factors of the finitely generated abelian group
  \[
  \operatorname{coker} T \;=\; \mathbb Z^H / T(\mathbb Z^F)
  \;\cong\; \mathbb Z^{\,|H|-k}\;\oplus\;\mathbb Z/d_1\oplus\cdots\oplus\mathbb Z/d_k .
  \]
  Equivalently they classify the pair \((\mathbb Z^H,\ \operatorname{im} T)\)
  — the embedding of the image sublattice in the target — up to
  \(GL(\mathbb Z)\) change of basis on \(\mathbb Z^H\).
- \(k=\operatorname{rank}_{\mathbb Q} T\): the rank of eq. (2) of the
  CAUSAL note is exactly the number of nonzero invariant factors, and the
  factors with \(d_i=1\) are invisible to it too. Only the \(d_i>1\)
  contribute torsion.

**Honest seam, stated up front:** over a PID the image
\(\operatorname{im} T\subseteq\mathbb Z^H\) is itself free of rank \(k\), so
\(T\) still factors through \(\mathbb Z^k\)
(\(\mathbb Z^F\twoheadrightarrow\operatorname{im}T\hookrightarrow\mathbb Z^H\)).
The minimal boundary *dimension* in eq. (1) of the CAUSAL note is therefore
unchanged over \(\mathbb Z\). What the invariant factors refine is not the
price \(d\) but the **classification of the interface**: two cuts of equal
rank with different \(d_i\) are inequivalent as integer cuts, because their
cokernels — the target distinctions the process cannot realize, and how far
they are from being realizable — differ as groups.

**MINE (interpretive reading, not a theorem):** call the torsion part
\(\bigoplus_i\mathbb Z/d_i\) of \(\operatorname{coker}T\) **torsion
memory**: a retained distinction valued in a finite cyclic group. A torsion
class is a distinction that is *not* realizable by the process but whose
\(d_i\)-th multiple is — a phase-like, wrap-around remainder (*śeṣa*)
rather than a magnitude. Under this reading the typed spectrum's first
coordinate should be reported as the pair
\((k;\ d_1\mid\cdots\mid d_k)\), the free rank together with the divisor
chain, i.e. the isomorphism type of \(\operatorname{coker}T\), not the
single number \(r_{\mathbb Q}\).

**Third axis.** अवच्छेद's §४ already flags, from the physics note itself,
that nonnegative rank can *exceed* ordinary rank — "two verdicts there
already" (linear factorization vs. classical latent variable). The
\(\mathbb Z\)-refinement here is a **third axis**, orthogonal to that one:
it does not change the field over which factorizations are sought, it
changes the *ring of exactness* of the table, and it separates cuts the
scalar \(r_{\mathbb Q}\) identifies even before the nonnegativity question
is posed.

## 3. Receipt: the producer exists and carries its own proofs

The Agda cubical library (as installed:
`/opt/homebrew/Cellar/agda/2.8.0/share/agda/cubical/`) ships a **total**
Smith normalizer for integer matrices, returning the normal form together
with the invertible transformations, the replay equation, and the normality
proof. Quoted from
`Cubical/Algebra/IntegerMatrix/Smith/Normalization.agda` (line 267; command:
`grep -n "smith :" .../Smith/Normalization.agda`):

```agda
smith : (M : Mat m n) → Smith M
```

and from `Cubical/Algebra/IntegerMatrix/Smith/NormalForm.agda`
(lines 55–56, 89–96, 123–126; command:
`grep -n "ConsDivs : Type\|record isSmithNormal\|record Smith" .../Smith/NormalForm.agda`):

```agda
ConsDivs : Type
ConsDivs = Σ[ xs ∈ List ℤ ] isConsDivs xs        -- the chain d₁ ∣ d₂ ∣ …

record isSmithNormal (M : Mat m n) : Type where
  field
    divs : ConsDivs
    rowNull : ℕ
    colNull : ℕ
    ...

record Smith (M : Mat m n) : Type where
  field
    sim : Sim M
    isnormal : isSmithNormal (sim .result)
```

`divs` *is* the divisor chain of §2 — the invariant factors, packaged with
their consecutive-divisibility proof (`isConsDivs`).

The repo exposes this at
`formal/cubical/NaturalMachine/SmithCapability.agda`, whose exported names
(read in full) are: `normalizeSmith`, `normalMatrix`, `leftTransform`,
`rightTransform`, `replaySmith`, `leftTransform-invertible`,
`rightTransform-invertible`, `normalMatrix-isSmith`, `withSmith`. The replay
is a returned path, not a test (its lines 39–41):

```agda
replaySmith : (M : Mat m n)
            → normalMatrix M
             ≡ leftTransform M ⋆ M ⋆ rightTransform M
```

So the finer first coordinate \((k;\ d_1\mid\cdots\mid d_k)\) is not a
proposal for future machinery. It is one `withSmith` away for any integer
process table the corpus already holds, with the certificate attached.
(Build-health record: `notes/FORMAL_LANE_HEALTH_2026_08_13.md` lists
`NaturalMachine/SmithCapability.agda` PASS under `--guardedness`;
`notes/CUBICAL_SKEW.md` records a FAIL for the same file under a skewed
library snapshot — the citation here is to the file as it stands, not to
any particular toolchain pin.)

## 4. Receipt: the corpus has already computed a pure-torsion boundary

`formal/cubical/KuttakaValli.agda` proves, for the vallī (list of quotients)
of Āryabhaṭa's pulverizer with replay into \(2\times2\) integer matrices
(quoted; command: `grep -n "sgn :\|detReplay" formal/cubical/KuttakaValli.agda`
→ lines 75–77, 86):

```agda
sgn : Valli → R
sgn [] = 1r
sgn (q ∷ v) = (- 1r) · sgn v

detReplay : (v : Valli) → det (replay v) ≡ sgn v
```

That is: \(\det(\mathrm{replay}\ v) = (-1)^{\operatorname{length} v}\). The
composite \(\det\circ\mathrm{replay}\) factors exactly through the length
mod 2 — it retains the vallī's parity and, being a function of parity
alone, nothing further.

**MINE (interpretive identification):** read \(\det\) as a cut on the
replay process. The retained datum is valued in
\(\{\pm1\}\cong\mathbb Z/2\): **zero free rank, one invariant factor
\(d_1=2\)**. Under the §2 reading, this is the corpus's first computed
*pure-torsion* boundary coordinate — a remainder-cell (*śeṣa-koṣṭha*)
carrying one bit of orientation memory, with no magnitude component at all.
The CAUSAL note's scalar \(r_{\mathbb Q}\) assigns this cut nothing
distinctive; the divisor-chain coordinate names it exactly.

**Fence (do not overclaim):** `detReplay` is a statement about what the
**determinant** sees. It does *not* say the fibres of `replay` are
classified by parity — `replay v` retains the full matrix, from which far
more than parity is recoverable (the module's own `convergent` and
`macroSound` laws use exactly that). The \(\mathbb Z/2\) here is the
boundary datum of one declared observable, not the predictive quotient of
the process.

**Sharpness, landed 2026-08-22 while this note was in draft** —
`formal/cubical/YugmaPurana_TheValliRecoversItsLengthModuloTwoAndNoFurther.agda`
(commit `08f944fb`; the file entered this working tree mid-draft, which is why
an earlier check missed it — the locus, not the tree). It proves the mod-2
statement is TIGHT, as theorems rather than a reading:
`चिह्नं-दैर्घ्यात् : (v w : Valli) → length v ≡ length w → sgn v ≡ sgn w`
(the sign sees only the length); `युग्म-पूरणम्` (an even padding is invisible,
because (−1)·(−1) ≡ 1); `विषम-पूरणम् … = refl` (one step negates — every odd
padding is separated on the spot); `यत्-तिष्ठति` (what survives, exactly).
So d₁ = 2 is not an upper bound on what this cut retains; it is the exact
invariant factor, with both directions checked.


## 5. The three levels, compared on a deterministic table (MINE)

अवच्छेद's §४ owes "a finite instance where the fibre census and the rank
are both computed and compared." The comparison is derivable in full for a
**deterministic** response map, so it is derived here rather than run
(CLAUDE.md rule 1); the observation is graded MINE — grepping the notes
found no prior statement of it.

Let \(f : H \to F\) be deterministic and let \(T\) be its process table:
\(T(h,\cdot)\) is the indicator row of \(f(h)\), i.e. the standard basis
vector \(e_{f(h)}\). Then:

- **Census (structural, अवच्छेद):** the fibre census over \(F\) has
  रिक्तम् columns (profiles outside \(\operatorname{im} f\)) and inhabited
  columns (एकम् + बहु), with \(|H| = \sum_{b\in F} |\mathrm{fibre}\ f\ b|\)
  as the cardinality shadow of the decomposition
  \(A \simeq \Sigma_b\,\mathrm{fibre}\ f\ b\).
- **Rank (field):** the distinct rows of \(T\) are exactly the basis
  vectors \(\{e_b : b \in \operatorname{im} f\}\), which are linearly
  independent, so
  \[
  \operatorname{rank} T \;=\; |\operatorname{im} f|
  \;=\; \#\{\text{inhabited columns}\} \;=\; \#(\text{एकम्}) + \#(\text{बहु}).
  \]
  The rank is the census's inhabited-column count; it forgets the fibre
  *sizes*, i.e. exactly the बहु amounts — the memory.
- **\(r_+\) collapses here:** each distinct row is itself a nonnegative
  rank-one summand, so \(r_+ = \operatorname{rank}\) for indicator tables.
  The physics note's \(r_+ > r_{\mathbb Q}\) separation (its §5.1)
  therefore *requires* genuinely stochastic tables — this sharpens where
  that warning bites.
- **Smith collapses here too, and that is the honest point:** the nonzero
  Smith form of a matrix whose distinct rows are standard basis vectors is
  \(\operatorname{diag}(1,\dots,1)\) — every invariant factor is 1, no
  torsion. So exactly as \(r_+\) needs stochasticity to separate, **torsion
  memory needs non-indicator integer tables** (weights, multiplicities,
  signed counts — the determinant table of §4 is of this kind). The three
  levels form a strict refinement chain
  census \(\to\) rank \(\to\) Smith, and each new level's added invariant
  is trivial precisely on the class of tables the previous level already
  handles exactly.

## 6. Receipt: the asked-for gluing law has an uncited skeleton

§5 of the CAUSAL note asks (quoted in §1 above) for a comparison/separation
theorem **"followed by a gluing law under process composition."** Its own
Theorem 7.1 already shows the scalar rank does not glue from component
scalars — the defect \(\dim(\operatorname{im}B\cap\ker A)\) is a relative
position, not a size. A fortiori the divisor chain will not glue from
component chains.

The shape such a law must take is already written down, uncited by the
CAUSAL note, in
`collab/upstream/library/raw/COORDINATION_THEOREMS_XLVI_2026-08-13.md`
(read; items quoted by their own numbering):

- **1481. Compatible family** — local states agreeing on overlaps
  (definition);
- **1482. Gluing** — a global state restricting to each local state
  (definition);
- **1483. Separatedness** — restrictions to a cover determine a global
  section (definition);
- **1484. Sheaf condition** — every compatible family glues uniquely
  (definition);
- **1485. Functions form a sheaf on subsets** (proved there);
- **1486. Local assignments with shared-variable equality glue exactly**
  (proved there, by 1485).

**Located, not proved:** the open item this note sharpens is — *for a cover
of a process by sub-processes with shared boundaries, when do local Smith
data \((k_i;\ d^{(i)}_1\mid\cdots)\) on the pieces, plus compatibility data
on overlaps, determine the global divisor chain?* Items 1481–1486 supply
the compatibility/gluing vocabulary; item 1487 of the same file (pairwise
agreement can be insufficient) and the CAUSAL note's own alignment defect
(its eqs. 11–14) predict that the answer requires retaining identified
intermediate boundaries or factor maps, not invariants alone. No such
theorem is claimed here.

## What is not claimed / seams

- **No probability layer.** Tables are treated as raw \(\mathbb Z\)-matrices;
  nothing here chooses or needs a normalization, and eq. (3)–(5) of the
  CAUSAL note (predictive quotients, Markovity) are untouched.
- **\(r_+\) and \(r_{\rm CP}\) untouched.** This note refines only the
  first coordinate of the typed spectrum. The nonnegative-rank separation
  (CAUSAL §5.1) and the quantum coordinate are as that note leaves them.
- **The quantum-coordinate correction stands.** The CAUSAL note's own
  2026-08-13 correction — that the mature quantum object is global comb
  memory cost, not a cutwise `r_CP` — is unaffected; torsion memory as
  defined here is a classical, exact-arithmetic datum.
- **The structural identification is not restated here.** The
  base-plus-fibre decomposition, "no memory = `isEquiv`", and the
  three-verdict census are अवच्छेद's checked theorems (commit `990d75aa`),
  cited, not reproved. This note adds only the numerical layer its §४
  declares open.
- **§5's deterministic comparison is MINE-grade** (elementary, derived
  above, no run); its collapse results cut both ways: they locate where
  \(r_+\) and torsion can separate, and they prove neither separates on
  deterministic tables.
- **The gluing law is not proved here**, only located (§6). Citing items
  1481–1486 is a pointer to vocabulary, not a claim that Smith data form a
  sheaf; 1487 of the same file is a standing counterweight.
- **The minimal factorization dimension over \(\mathbb Z\) is still the
  rank** (image of a map into a free module over a PID is free, §2). Anyone
  quoting this note as "torsion raises the cut price \(d\)" is misquoting
  it: torsion refines the classification of the interface, not the bond
  count.
- **KuttakaValli's \(\mathbb Z/2\) is about the determinant** (§4 fence):
  the identification of it as "the first computed torsion boundary
  coordinate" is a MINE-grade reading of a real theorem, not a new theorem.
- **The two interpretive moves are marked MINE** where they occur:
  "torsion = cyclic/phase memory" (§2) and the §4 identification. The
  mathematically exact content is only: Smith invariants classify
  \(\operatorname{coker}T=\mathbb Z^H/\operatorname{im}T\) (equivalently the
  pair \((\mathbb Z^H,\operatorname{im}T)\)); the library produces them
  totally with proofs; `detReplay` is the quoted equation.

- **Unexplored lead (owner, 2026-08-22; not developed here):** MDL and
  Chaitin's incompleteness theorem may bear on this circle — a boundary
  datum is a description, torsion memory is a description valued in a
  finite group, and Chaitin-style limits constrain *proving* minimality of
  a retained description. No claim is made; this line records the lead so
  it is not lost, and any development must start by writing down the
  theorem it would replace.

## Receipts index

| claim | file | what was checked |
|---|---|---|
| cut theorem eq. 2, typed spectrum eq. 8, §5 ask, Thm 7.1 | `notes/CAUSAL_MEMORY_SPACETIME.md` | read in full; ask quoted from lines 210–213 |
| structural half checked: `स्मृतिः`, `अवच्छेदः`, `स्मृत्यभावः`, `सीमा-सर्वम्`, three verdicts, §४ "rank still prose" | `formal/cubical/Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFibreFailingToBeContractible.agda` (commit `990d75aa`) | read in full (`git show 990d75aa`); names and §४ sentence quoted verbatim |
| `smith : (M : Mat m n) → Smith M` | `/opt/homebrew/Cellar/agda/2.8.0/share/agda/cubical/Cubical/Algebra/IntegerMatrix/Smith/Normalization.agda` line 267 | read; type quoted verbatim |
| `ConsDivs`, `isSmithNormal.divs`, `record Smith` | same tree, `.../Smith/NormalForm.agda` lines 55–56, 89–96, 123–126 | read; quoted verbatim |
| repo exposure, nine exports, `replaySmith` path | `formal/cubical/NaturalMachine/SmithCapability.agda` | read in full; names listed, type quoted |
| `detReplay`, `sgn`, `Valli`, `replay` | `formal/cubical/KuttakaValli.agda` lines 50, 53, 75–77, 86 | read in full; quoted verbatim |
| sheaf skeleton, items 1481–1486 (and 1487) | `collab/upstream/library/raw/COORDINATION_THEOREMS_XLVI_2026-08-13.md` | read items 1481–1487; titles quoted with their numbering |
| build-health cross-references | `notes/FORMAL_LANE_HEALTH_2026_08_13.md`, `notes/CUBICAL_SKEW.md` | grepped for `SmithCapability` rows (PASS / FAIL respectively) |
