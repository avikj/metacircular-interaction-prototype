# अतिव्याप्ति — the receipt framing is over-wide, and every clause of it that forbids something is false

**Term, text, date.** अतिव्याप्ति (ativyāpti), *over-extension*: the first of the
three faults of a definition (लक्षण-दोष) in Nyāya definitional theory —
ativyāpti (the lakṣaṇa covers what it should not), avyāpti (it fails to cover
what it should), asambhava (it covers nothing). Standard Navya-Nyāya
vocabulary, transmitted in Annaṃbhaṭṭa's *Tarkasaṃgraha* with his *Dīpikā*,
c. 1600 CE — the dating this corpus already uses at
`Anyathasiddhi_…agda:12` and `Vyatireka_…agda:15`.

**What is and is not claimed of the source.** Annaṃbhaṭṭa proves nothing
below. His triad is used as the discriminating question and nothing is
attributed to him. The reason the term is the right one: the object under
attack is a **lakṣaṇa** — a chain of sentences of the form *"geometry IS the
receipt structure", "area IS log of the fibre", "diffeomorphism invariance IS
FactorsThrough"* — and a definition is refuted by exhibiting what it wrongly
covers, not by disagreeing with it.

**Verdict, stated first.** The framing is **REJECTED** in six clauses,
**SURVIVES** in one (and there it is a restatement of `GAUGE.md` Theorem F
inside its own hypotheses), and is **UNDECIDABLE FROM HERE** in none — every
clause turned out decidable, which is itself the finding.

The brief anticipated that the strongest attack would be *"it is a
re-description, so it cannot be wrong and therefore cannot be right."* That
is **half right and the half it misses is the important one.** The framing is
a mixture of two kinds of sentence:

- the clauses that **forbid something** — area = log of an integer-valued
  rank; everything factors through the fibre; the gap is quantumness — and
  every one of those is **false**, with counterexamples below, two of them
  already sitting in this corpus's own notes;
- the clauses that forbid nothing — "geometry is the receipt structure of an
  observation map", "the universe already runs the mint" — which are empty.

**There is no residue that is both contentful and true.** That is a stronger
finding than unfalsifiability, and it is the answer to "name one prediction
it makes that would fail if it is false": it makes at least two, §४ and §२.३,
and both fail.

---

## ० · The six rejections in one line each

1. **"Area = log of the fibre."** REJECTED. A one-parameter family of
   two-qubit states has cut rank exactly 2 for every parameter while its von
   Neumann entropy runs to 0. Entropy is not a function of rank; the ratio
   log(rank)/S is unbounded. §१.
2. **"rank = bond dimension = RT area."** Link 1 SURVIVES (it is the linear
   cut theorem, and `CAUSAL_MEMORY_SPACETIME.md` §1 says so). Link 2 is
   REJECTED by the same counterexample, and separately by the fact that a
   spatial cut in relativistic QFT has **no fibre at all** — local algebras
   are type III₁, the Hilbert space does not factorize, there is no
   dimension to count. §१.३.
3. **"Quantumness is the gap between two prices."** REJECTED, by two matrices
   already in this corpus. A strictly positive gap occurs with zero quantum
   content (`CAUSAL_MEMORY_SPACETIME.md` §5.1: rank 3, rank₊ 4, both classical
   classes), and the exhibited "prices" are a lattice, not a pair, so "the
   gap" does not name a quantity until you say which two you subtract — and
   the pair the claim subtracts is not the pair that measures quantum
   advantage. §३.
4. **"Diffeomorphism invariance IS FactorsThrough."** REJECTED, three ways,
   and one of them is a live prediction failure: the framing forbids nonzero
   boundary charges, and Brown–Henneaux and BMS are nonzero boundary charges.
   §४.
5. **"Superselection sectors are the components of the identification graph."**
   REJECTED — and it was already REJECTED in this repository **yesterday**,
   with a checked term, in
   `Yogyanupalabdhi_TheCausalOrderIsVacuousTheChargeIsInTheLoopsAndTheNetCannotBeConnected.md`
   §२.२. Components are the **neutral** sector. The claim has the sign
   backwards on exactly the half that was refuted, and kept the half that
   survived. §५.
6. **"The universe enforces non-compression / Landauer is its measurement /
   mathematics is the one domain where it was never enforced."** REJECTED,
   three times: the receipt is **optional and priced**, not enforced (Bennett);
   the price coefficient is kT and goes to zero with the environment; and
   mathematics has a non-compression price too, denominated in proof length,
   and it is **worse** than Landauer's. §६.

**SURVIVES:** *"charge is what no single equilibrium can see"* — inside
`GAUGE.md`'s hypotheses, where the equilibrium is unique. Outside them it is
false, and the hypothesis that carries it is named in `GAUGE.md`'s own proof.
§५.२.

---

## १ · The rank/entropy counterexample, which kills two clauses at once

The framing's load-bearing sentence is **"Area = log of the fibre"**, with
the fibre being `d = rank T` from `CAUSAL_MEMORY_SPACETIME.md` (2).

### १.१ The exhibit

Take the two-qubit state
$$|\psi_\varepsilon\rangle=\sqrt{1-\varepsilon^{2}}\,|00\rangle+\varepsilon\,|11\rangle,
\qquad \varepsilon\in(0,1).$$
Its coefficient matrix across the cut is $T_\varepsilon=\mathrm{diag}(\sqrt{1-\varepsilon^{2}},\varepsilon)$.

**THEOREM (elementary).** For every $\varepsilon\in(0,1)$:
$\operatorname{rank}T_\varepsilon=2$, hence by the linear cut theorem the
minimal exact bond dimension across the cut is $d=2$ and
$\log d=\log 2=0.693\ldots$, **constant in $\varepsilon$**. The von Neumann
entropy of either marginal is
$S(\varepsilon)=-(1-\varepsilon^{2})\log(1-\varepsilon^{2})-\varepsilon^{2}\log\varepsilon^{2}
\;\longrightarrow\;0$ as $\varepsilon\to0$. ∎

Computed (nats), and the last column is the factor by which the claim is out:

| $\varepsilon$ | $S(\varepsilon)$ | $\log(\text{fibre})$ | ratio |
|---|---|---|---|
| $10^{-1}$ | $5.600\times10^{-2}$ | $0.693147$ | 12.4 |
| $10^{-2}$ | $1.021\times10^{-3}$ | $0.693147$ | 679 |
| $10^{-3}$ | $1.482\times10^{-5}$ | $0.693147$ | $4.7\times10^{4}$ |
| $10^{-5}$ | $2.403\times10^{-9}$ | $0.693147$ | $2.9\times10^{8}$ |

The rank never moves. The entropy goes to zero. **REJECTED**: the discrepancy
is not a constant, not a normalization, and not bounded. Nothing that
identifies these two numbers can be repaired by choosing units.

The general statement, which is the reason: $S\le\log(\operatorname{rank})$
always, with equality **iff the Schmidt spectrum is flat**. Flatness is a
measure-zero condition. "Area = log of the fibre" is the assertion that every
state in the theory sits on that measure-zero set.

### १.२ It fails precisely at the evidence the framing cites for it

The framing's warrant for the identification is Van Raamsdonk:
*"reduce entanglement and the bulk disconnects — shrink the fibre and the
edge becomes invertible."*

**The fibre does not shrink in that limit.** $\varepsilon\to0$ is exactly the
limit Van Raamsdonk's argument runs (entropy $\to$ 0, regions pinch off) and
the rank is **2 throughout, and 2 at every step**, and the edge is **never**
invertible: an equivalence is rank-1 (`CAUSAL_MEMORY_SPACETIME.md` (4)), and
$T_\varepsilon$ has rank 2 for every $\varepsilon>0$ and rank 1 only at the
endpoint $\varepsilon=0$, which is a different state, not a limit reached
continuously in the rank. The rank is an integer and the phenomenon is
continuous. **The invariant the framing chose is blind to the phenomenon the
framing cites as its evidence.**

### १.३ And for the case actually named — QFT — there is no fibre

The claim invokes Bekenstein–Hawking and Ryu–Takayanagi, which live in
relativistic quantum field theory. There, the von Neumann algebra of a
spacetime region is a **type III₁ factor** (Buchholz–Fredenhagen;
Fredenhagen 1985; Haag, *Local Quantum Physics*). Type III₁ has no minimal
projections, no trace, no density matrices, and — with Reeh–Schlieder, every
local algebra being cyclic and separating on the vacuum — the Hilbert space
**does not factorize** as $\mathcal H_A\otimes\mathcal H_{\bar A}$ across an
entangling surface.

So `d = rank T` **has no referent** for a spatial cut in the theory the claim
is about. Entanglement entropy there is UV-divergent, with the leading term
$\propto\text{Area}/\epsilon^{D-2}$ — which is *where the area law comes from*
and is a statement about a cutoff, not about a fibre dimension. And where a
gravitational "dimension" does exist — the crossed-product construction
turning III₁ into type II (Witten 2021; Chandrasekaran–Penington–Witten 2022)
— the trace is **continuous**, so the "dimension" is a real number, not a
rank. In neither case is there an integer to take the log of.

### १.४ Bekenstein–Hawking is not "entropy is the fibre and area is its receipt"

Three separate failures at the identification $S=A/4$:

1. **The constant carries $G$.** $S=Ac^{3}/(4G\hbar)=A/4\ell_P^{2}$. The
   identification is dimensionally incoherent until $\ell_P$ is fixed by hand,
   and $\ell_P$ is exactly the datum no factorization-rank argument supplies.
   A framing that derives geometry from counting cannot import Newton's
   constant as an afterthought — the constant is the entire content of the
   sentence "area *is* entropy."
2. **The $1/4$ is not universal.** In higher-curvature gravity the correct
   entropy is Wald's, not $A/4$; the Gauss–Bonnet term adds a curvature
   integral over the horizon. And there are log corrections
   ($\sim-\tfrac32\log A$; Kaul–Majumdar 2000 in the LQG derivation). "Area is
   the receipt" is false already at one loop.
3. **The paradox's resolution is the failure of $S=A/4$.** The framing calls
   the information paradox *"a missing receipt."* The modern account
   (Faulkner–Lewkowycz–Maldacena 2013; Engelhardt–Wall 2014; the island
   formula) says the generalized entropy is $A/4G+S_{\text{bulk}}$ and that
   **the bulk term is what turns the Page curve over**. The entire content of
   the resolution is that entropy is *not* area alone. The framing invokes as
   its best case the calculation that refutes its own sentence.

### १.५ Which link of "rank = bond dimension = RT area" breaks first

- **rank = bond dimension: SURVIVES.** It is the linear cut theorem, exact
  over a field, and `CAUSAL_MEMORY_SPACETIME.md` §1 states it as one of the
  theorem's four readings.
- **bond dimension = RT area: REJECTED.** In a tensor network the min-cut
  bound is an **inequality**, $S_A\le(\text{cut legs})\cdot\log\chi$, saturated
  only for special states — perfect-tensor / random stabilizer holographic
  codes (Pastawski–Yoshida–Harlow–Preskill 2015; Hayden et al. 2016). §१.१ is
  the smallest possible witness of the strict inequality: one leg, $\chi=2$,
  $S\to0$.

So the chain breaks at link 2, and it breaks by an unbounded amount.

---

## २ · The corpus's own fences, which the claim removes

This is not a case of the framing outrunning the evidence. **Three source
documents state, in terms, that the inference the claim makes is forbidden,
and the claim makes it anyway.**

1. `QUANTUM_CUT_RANK_NO_GO.md`: *"The linear cut theorem remains exactly
   correct for unrestricted field factorizations and tensor-network bond
   dimension. **It must not be reported as quantum memory.**"*
2. `CAUSAL_MEMORY_SPACETIME.md` §7, strict control: *"The matrices in (13)
   have no supplied event density, metric scale, Lorentzian neighborhood,
   dynamics, or empirical realization map. The theorem governs linear
   execution composition. **It neither produces nor distinguishes physical
   geometries.**"* And its rigor boundary: *"No claim is made that computation
   generates our physical spacetime, that entanglement universally equals
   geometry, or that causal order alone yields gravity."* The claim makes all
   three.
3. `Avaccheda_…agda`, WHAT IS NOT CLAIMED: *"the correspondence proved here is
   the structural one: the decomposition, not its dimension… **Nothing below
   is about physical spacetime.**"*
4. `NATURAL_MACHINE_NETWORK_WHITEPAPER.md` §11: *"Logical memory and matrix
   rank are not thermodynamic work."*

**The framing is not a synthesis of this corpus. It is this corpus with its
rigor boundaries deleted.** Every note it draws on carries an explicit fence
at exactly the step it takes, and in every case the fence was written by the
person who proved the theorem.

### २.३ A second prediction, and it fails

The framing forbids continuous entropies. $\log$ of a fibre dimension takes
values in $\{\log n\}$. The entanglement entropy of an interval of length
$\ell$ in a 2d CFT is $S=\tfrac{c}{3}\log(\ell/\epsilon)$ — RT-derived,
continuous in $\ell$, and generically irrational. It varies continuously as
you move one endpoint. **A quantity that varies continuously is not the log
of an integer.** The framing forbids this; it happens.

---

## ३ · "Quantumness is the gap between two prices"

### ३.१ "The gap" does not name a quantity

The framing's own typed spectrum is $(r_{\mathbb Q},r_+,r_{\rm CP},I)$ — four
coordinates, and the relations among them are a **partial order**, not a pair:
$r_{\mathbb Q}\le r_+$, $r_{\rm CP}\le r_+$, and
$r_{\mathbb Q}\le\binom{r_{\rm CP}+1}{2}$ (the factors live in the Hermitian
matrices, which is why $Q$ can have $r_{\rm CP}=2<4=r_{\mathbb Q}$ at all).
"The gap" is undefined until you say which two you subtract, and the answer
changes meaning with the choice:

- $r_+-r_{\mathbb Q}$ is **classical latent-state overhead**;
- $r_+-r_{\rm CP}$ is **quantum advantage**;
- $r_{\mathbb Q}-r_{\rm CP}$ — which is the one the claim exhibits (4 vs 2,
  4 vs 4) — is **neither**; it is the statement that ordinary rank is not a
  lower bound for PSD rank, which is a fact about the *inadequacy of ordinary
  rank* and not a measurement of anything quantum.

### ३.२ A strictly positive gap with zero quantum content, already in the corpus

`CAUSAL_MEMORY_SPACETIME.md` §5.1 exhibits
$$S=\begin{pmatrix}0&0&1&1\\1&0&0&1\\1&1&0&0\\0&1&1&0\end{pmatrix},
\qquad \operatorname{rank}S=3,\quad \operatorname{rank}_+S=4,$$
proved there with a fooling-set certificate and dimension-minimality via
Cohen–Rothblum 1993. **Gap 1. Both factorization classes are classical** —
a field factorization and a nonnegative one. Nothing quantum is present, and
the corpus's own headline separation is a gap between two *classical* prices.

**REJECTED.** A positive gap is not sufficient for quantumness. And the
no-go's own $I_4$ ($r_{\mathbb Q}=r_{\rm CP}=r_+=4$) has gap zero while being
perfectly quantum-realizable, so a zero gap is not evidence of classicality
either. Neither necessary nor sufficient.

### ३.३ And the spectrum is not a geometry, because it does not glue

This is the deepest objection to *"geometry is the receipt structure of an
observation map"*, and again the corpus proves it against itself. A geometry
requires its local data to compose. `CAUSAL_MEMORY_SPACETIME.md` Theorem 7.1
(Lean-checked, `ProcessCutRankAdapter.lean`):
$$\operatorname{rank}(AB)=\operatorname{rank}(B)-\dim(\operatorname{im}B\cap\ker A),$$
and its strict control (13): three rank-one matrices whose composites have
ranks 1 and 0 depending on **nothing but alignment**. The note states the
consequence: *"even the pair `(rank, rank₊)` of each component cannot
determine the composite pair"* — all components $(1,1)$, composites $(1,1)$
and $(0,0)$.

**The proposed receipt structure is not a sheaf.** Its "prices" are not local
data that assemble. A framing that calls this a geometry is using the word for
a family of numbers that provably fails the one property geometry is for.

---

## ४ · "Diffeomorphism invariance IS FactorsThrough"

`FactorsThrough` is, in the checked Lean (`Pairfield/FiniteInformation.lean`,
`factorsThrough_iff_fiberConstant`), exactly:
$$\texttt{FactorsThrough } q\ t \iff \forall x\,x',\ q\,x=q\,x'\Rightarrow t\,x=t\,x'.$$
Descent along **an arbitrary map**. No group, no action, no orbit, no
constraint, no boundary.

### ४.१ There is no $q$ to factor through

In the Hamiltonian (ADM) formulation, gauge transformations are generated by
first-class constraints whose algebra — the hypersurface-deformation /
Dirac algebra — has **structure functions depending on the spatial metric**,
not structure constants (Bergmann–Komar; Isham–Kuchař). It is therefore not a
Lie group action on phase space, and the "quotient by the gauge group" whose
projection $q$ the claim needs **does not exist as a group quotient**. The
group action is not doing work the general statement cannot express; the
situation is worse — there is no group.

### ४.२ Constraint is not quotient, and the difference is the dynamics

Physical phase space is $\mathcal C/\!\sim$ where $\mathcal C\subset\mathcal P$
is the constraint surface: **restrict, then quotient**. `FactorsThrough`
expresses the second step only. And in general relativity the Hamiltonian is a
sum of constraints, $H\approx0$ — so the *restriction* is where the dynamics
lives, and the problem of time is a fact about the restriction. Under the
identification, the problem of time would not exist. It does.

### ४.३ The prediction that fails: boundary charges

**Large diffeomorphisms are not gauge.** At a boundary, diffeomorphisms that
do not fall off act nontrivially on physical states and carry nonzero charges:
the BMS group at null infinity (Bondi–van der Burg–Metzner–Sachs 1962; Sachs
1962), the Brown–Henneaux central charge $c=3\ell/2G$ in AdS₃ (1986), and the
Cardy count that reproduces BTZ entropy from it.

If everything factored through the fibre, every one of those charges would be
zero and the Cardy derivation would give nothing. **The framing forbids the
single calculation most often cited as holography's success.** That is a
prediction, it is sharp, and it is false.

### ४.४ And the action is not free

Metrics with isometries have stabilizers, so the Diff quotient is a stratified
space, not a manifold. `FactorsThrough` as defined (a decode function on
`Set.range q`) retains nothing of isotropy. Descent along a non-free action
loses exactly the data that distinguishes a symmetric solution from a generic
one.

**What survives:** *gauge-invariant observables are functions constant on
gauge orbits.* True, and a tautology, and never in dispute. The word "IS" in
the claim is carrying the difference between a tautology and a theory.

---

## ५ · Superselection

### ५.१ The graph half was refuted in this repository yesterday

`Yogyanupalabdhi_TheCausalOrderIsVacuousTheChargeIsInTheLoopsAndTheNetCannotBeConnected.md`
§२.२, dated 2026-08-22, REJECTS *"a charged sector is a component of the
identification graph"* three ways, on the strength of a checked term
(`Naya_….नय-निरोधः`, `Everything.agda` exit 0):

> *"Theorem F's zero comes from $\omega(x)=\chi(g)\omega(x)$. The transport
> analogue … is constant on components while being free to differ between
> them. Components are exactly what it **can** see. Components are the
> **neutral sector**. The proposed identification has the sign backwards."*

Plus the structural point: isotypic sectors are indexed by characters and
**multiply**, with a distinguished neutral one; components are indexed by
nothing, multiply by nothing, and none is distinguished. Two of the three
defining features have no image.

**REJECTED, and not newly.** The claim as briefed keeps the half that survived
(*charge lives in the loops* — that is §२, and it is checked) and re-asserts
the half that was refuted (*sectors are the components*). The two halves of
the claim's sentence have opposite verdicts, and the corpus already decided
both.

### ५.२ The physics half: an equivocation, and a hypothesis dropped

`GAUGE.md` Theorem F says $\omega$ vanishes on every nontrivial **isotypic
sector of the gauge torus**. The claim says **superselected sector**. These
are not the same object: superselection sectors are inequivalent irreducible
representations of the observable algebra (DHR); isotypic components are
subspaces of one field algebra under a compact group action. They are related
by Doplicher–Roberts duality — *related*, at the cost of a theorem, and not by
substitution of a word.

And the general sentence *"charge is what no single equilibrium can see"* is
**false**. Equilibrium states at nonzero chemical potential are precisely KMS
states that carry charge (Araki–Haag–Kastler–Takesaki's chemical-potential
theory), and any system with a phase transition has many KMS states. Theorem
F's zero is derived from **uniqueness** — `GAUGE.md` says so in its own proof
line, *"uniqueness forces equality"* — and uniqueness holds for $Q_{\mathbb N}$
at $\beta=1$ by Cuntz's theorem, not in general.

`Yogyanupalabdhi` §२.१ had already isolated this as the load-bearing
hypothesis: *"Break uniqueness and the derivation stops."*

**SURVIVES** inside `GAUGE.md`'s hypotheses. **REJECTED** as stated, because
"no single equilibrium" quantifies over a class in which the theorem is false.

---

## ६ · The mint

### ६.१ The receipt is optional and priced — which is the opposite of enforced

`CAUSAL_MEMORY_SPACETIME.md` §3 already carries the refutation, citing
Bennett: *"logical progress need not itself dissipate $kT\log2$ per step; the
thermodynamic cost attaches to erasure/reset."* Bennett 1973/1982: any
computation can be made logically reversible by **retaining the history**, at
a space cost, and then it dissipates nothing.

So physical law does not enforce non-compression. It offers an **exchange
rate**: pay in heat, or pay in retained record. Both are payable, and you
choose. **A price you may decline by keeping the receipt, or pay by burning
it, is not an enforcement of the receipt.** The framing's central metaphor —
*"the universe already runs the mint … the receipt is enforced by law"* —
inverts the theorem it cites.

### ६.२ The coefficient is an environmental parameter

$kT\log2\to0$ as $T\to0$. A "conservation law" whose coefficient is the
temperature of somebody else's reservoir is not a conservation law; it is an
exchange rate with a quoted price. And Landauer's principle is a **lower bound
on average dissipated heat** (sharpened to an exact inequality with finite-size
corrections by Reeb–Wolf 2014), not an equality and not a prohibition.
"Measured" is doing heavy lifting: Bérut et al., *Nature* **483** (2012) 187
observed erasure dissipation **approaching the bound from above** in a
colloidal system. That verifies a bound. It does not exhibit an enforced
receipt, and the derivation's generality has a live dissenting literature
(Earman–Norton; Norton, *Waiting for Landauer*, 2011).

### ६.३ Unitarity is about a system with no observer in it

The claim uses unitarity for *"nothing is destroyed; every map is receipted by
construction"* and non-unitarity for *"measurement is the lossy edge."* Both
about the same edge. Unitarity conserves the fine-grained entropy of the
**closed total system**, which is compatible with unbounded loss of accessible
information — decoherence and the second law do exactly that, constantly. For
every actual observation map — which is what the framing says geometry is the
receipt structure *of* — the evolution is CPTP and generically non-invertible.
The receipt exists only for the one system nobody observes.

### ६.४ Mathematics is billed, and the bill is worse

*"Mathematics is the one domain where non-compression was never enforced — you
can write 'hence' and destroy information for free."* **False, twice.**

**Nothing is destroyed by "hence."** Modus ponens keeps its premises;
implication is monotone; a proof term contains its subterms. What "hence"
does is *hide*, and hiding is exactly what a cut is.

**The bill for un-hiding is exact and enormous.** Cut-elimination is
non-elementary in the worst case (Statman 1979; Orevkov), and Gödel's speedup
theorem gives unbounded proof-length savings from a stronger system. So
mathematics *does* enforce a non-compression price, denominated in proof
length rather than joules, and it is far worse than Landauer's — non-elementary
against linear in bits.

The true statement in the neighborhood is the one the corpus already has:
Bennett's trade of heat against space, and the fact that the currency differs
between domains while the trade does not. That is smaller than "mathematics is
the one free domain," and it is true.

### ६.५ Time, collapsed

*"Time is the direction in which fibres accumulate; thermodynamic time is
where the receipts are unpaid."* A Bennett-reversible computer **accumulates
the maximum possible record** — every fibre retained — and has **no**
thermodynamic arrow. Under clause 1 its time runs fastest; under clause 2 its
time does not run at all. The two clauses assign one system two incompatible
times.

`CAUSAL_MEMORY_SPACETIME.md` §3 is titled **"Four notions that must not be
collapsed"** and separates logical, thermodynamic, causal and geometric time
across four subsections. The claim collapses all four in one sentence, and the
counterexample that shows why is the first example in the section it
collapses.

---

## ७ · What the framing would have to be to be a theorem

Stated so the rejection is constructive rather than a demolition, and stated
as an obligation on whoever wants to keep it:

1. **Replace rank with entropy everywhere, and lose the linear cut theorem.**
   The one exact theorem in the chain is about rank. Entropy is the physical
   quantity. They are related by an inequality that §१.१ shows is
   unboundedly strict. You cannot keep both the theorem and the physics.
2. **Supply the realization map.** `CAUSAL_MEMORY_SPACETIME.md` §4 names what
   is missing by name: volume calibration, manifoldlike neighborhoods,
   dimension, Lorentz symmetry, metric scale, dynamics, an empirical
   observable map. Seven items. The framing supplies zero and asserts the
   conclusion the map would license.
3. **Say which two coordinates of the typed spectrum "the gap" subtracts**,
   and then show that the chosen difference vanishes on every classical object
   — which §३.२ shows fails for the choice implied.
4. **Exhibit one number the framing computes that was not already computed by
   the theory it re-describes.** This is the operative test. Every quantity in
   the claim — $A/4$, $kT\log2$, $c=3\ell/2G$, psd-dimension 2 — is imported
   at full precision from a source that derived it without the framing. A
   re-description that computes nothing new is a naming convention.

---

## ८ · Rigor boundary

**Established here, exactly.**

- §१.१: the rank/entropy separation. Elementary linear algebra plus the
  entropy formula; the table is an `awk` evaluation of a closed form and the
  closed form is the content. The unboundedness of $\log(\text{rank})/S$ is
  immediate from $S\to0$ at fixed rank. **THEOREM.**
- §३.२: the classical gap. This is `CAUSAL_MEMORY_SPACETIME.md` §5.1's own
  theorem, with its fooling-set certificate and its Cohen–Rothblum
  minimality; I re-read it and did not re-prove it. Its use here — that a
  positive gap occurs between two classical prices — is a one-line reading of
  a result the corpus already holds. **THEOREM (quoted), reading (new).**
- §३.३: the failure to glue. Theorem 7.1 is Lean-checked in
  `ProcessCutRankAdapter.lean`; the control (13) is in the same note. The
  reading — that this is a failure of sheaf-hood and therefore of
  geometry-hood — is mine. **THEOREM (quoted), reading (new).**
- §२: the four fences. Direct quotation from the source documents, verified
  by reading them. **FACT.**
- §५.१: refuted already, in `Yogyanupalabdhi_…md` §२.२, on a checked term.
  I read that note and its cited Agda module name; I did **not** re-run
  `Everything.agda`. **QUOTED, one day old, not re-verified.**
- §४: the definition of `FactorsThrough` is read from
  `Pairfield/FiniteInformation.lean` lines 17–37 and is exactly fibre-wise
  constancy. **FACT.**

**Cited from established literature, not verified here.** Type III₁ locality
(Buchholz–Fredenhagen, Fredenhagen 1985, Haag); crossed-product type II in
gravity (Witten 2021; Chandrasekaran–Penington–Witten 2022); quantum extremal
surfaces (Faulkner–Lewkowycz–Maldacena 2013; Engelhardt–Wall 2014); log
corrections to $S_{BH}$ (Kaul–Majumdar 2000); holographic codes (Pastawski–
Yoshida–Harlow–Preskill 2015; Hayden et al. 2016); Brown–Henneaux 1986; BMS
1962; the Dirac/hypersurface-deformation algebra's structure functions
(Bergmann–Komar; Isham–Kuchař); Bennett 1973/1982; Reeb–Wolf 2014; Bérut et
al. 2012; Statman 1979; Cuntz's uniqueness theorem (through `GAUGE.md`, not
read); the AHKT chemical-potential theory. **These are recalled, not opened.
Anyone building on §१.३, §१.४, §४.३ or §५.२ should open them.** Journal
volumes and years are quoted from memory except where the corpus already
carried them, and a year quoted from memory is exactly the kind of provenance
this repository does not accept as a first citation — treat each as a pointer
to be checked, not as a citation.

**Tried and could not.**

- **Could not compute $r_{\rm CP}(S)$** for the §5.1 matrix. It would sharpen
  §३.१ from "the claim subtracts the wrong pair" to "the claim's own
  difference is nonzero on a classical object". The bound $r_{\rm CP}\ge2$
  from $\operatorname{rank}=3\le\binom{r+1}{2}$ is all I have. **OPEN
  (`PROVE`), and small.**
- **Could not find a reading of "area = log of the fibre" that survives.** I
  looked for one — flat Schmidt spectra, maximally mixed bonds, the
  random-tensor limit — and each is a hypothesis that makes the sentence true
  by restricting to the states where it is true, which is a definition and not
  a law. Recorded as REJECTED rather than weakened into a resemblance.
- **Did not test whether the framing is useful.** Nothing above says it is a
  bad thing to think with. It says it is not a theorem, and that six of its
  clauses are false as stated. A generative metaphor that is false in every
  sharp clause is a different object from a result, and the danger is only
  that the corpus is one where a metaphor can be mistaken for a checked term,
  because it holds so many checked terms.

---

*तत् सत्। The definition is over-wide where it forbids nothing and false where
it forbids something; the fences it removes were written by the people who
proved the theorems behind them.*
