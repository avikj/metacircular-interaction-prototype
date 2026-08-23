# Peres–Mermin: section failure and cocycle phase under one typed diagram

**Status: exact finite construction, executed and hostile-tested (12/12);
`machinery/pm_section_cocycle.py`. Executes madhavi's 0366 physics spark;
claim `PM_SECTION_VS_COCYCLE` (msg 0368, forecast 0.6/0.3/0.1 — the
leading branch occurred, in a sharper form than forecast). Every sign is
derived from exact Gaussian-integer Pauli matrices; nothing postulated.**

## The typed diagram, as executed

\[
(\varphi,\ \mu)
\;\xrightarrow{\ \text{evaluate on closed contexts}\ }\;
s \in \mathbb F_2^{6}
\;\xrightarrow{\ \text{class}\ }\;
[s] \in \operatorname{coker}(\delta) \cong \mathbb F_2
\]

- **Upstream** lives the operator phase structure, and it is a *pair*:
  the 2-cocycle `μ : F₂⁴ × F₂⁴ → ℤ₄` of the canonical Weyl representatives
  `P_v = X^aZ^b ⊗ X^aZ^b` (cocycle identity verified over all 4096
  triples), together with the **gauge 1-cochain** `φ(A) = #Y(A)` recording
  that the physical observables differ from the canonical representatives
  by `A = i^{φ} P_{sym(A)}` (law checked on all nine observables).
- **Midstream**: for each closed commuting triple `u+v+w = 0`, the product
  sign is `i^{φ(u)+φ(v)+φ(w) + μ(u,v)+μ(u+v,w)}`. This *derives* the
  Peres–Mermin sign vector `s = (+,+,+ | +,+,−)` — the same vector the
  exact matrix products give.
- **Downstream**: `δ : F₂⁹ → F₂⁶` is the incidence map of the 9
  observables in the 6 contexts. Rank 5, cokernel dimension exactly 1,
  with the parity functional as the class evaluator.

## Theorem (all parts executed, none asserted)

1. **Local sections abound, global sections vanish.** Each context has
   exactly 4 local sections; global sections number 0 (linear solver and
   512-fold exhaustion agree). Because each observable lies in exactly two
   contexts, a compatible family *is* a global section — so for PM,
   *missing compatible section* and *nonzero cocycle class* are not two
   phenomena: `[s] = 1` in `coker(δ) ≅ F₂` **is** the section failure, by
   exactness of `F₂⁹ → F₂⁶ → coker → 0`.
2. **The operator phase is strictly upstream and does not reduce to the
   class.** The rows-only cover keeps every operator and every phase and
   admits sections (class 0). The obstruction is a property of the
   *cover*, i.e. genuinely cohomological — of the nerve, not of the
   operator set.
3. **The class is local-system-relative.** Twisting the identification of
   one observable between its row and its column occurrence (a one-edge
   local-system flip on `ZZ`) kills the class and produces exactly
   `2^{9-5} = 16` twisted global sections. Contextuality is a statement
   about the *gluing data*, not about the values: the charge lives in the
   identification of the two occurrences — `TWO_IDENTITIES.md` §1
   instantiated in physics, literally (same observable, two contexts, and
   the obstruction is carried by the identity between them).
4. **The gauge term is load-bearing.** The pushforward computed from `μ`
   alone (dropping `φ`) disagrees with the true signs — kept as a
   permanent planted-false control, because that was this construction's
   own caught defect: the phase *splits* as gauge + cocycle, and only the
   sum on closed contexts is representative-independent.

## Verdict against the registered forecast

Branch 1 (0.6) occurred, refined: *both* structures are present, but they
are not parallel alternatives — the section failure IS the cocycle class
(one object seen through exactness), while the operator phase `(φ, μ)` is
a distinct upstream object connected by the evaluation map, with a
nontrivial kernel witnessed two ways (cover restriction; local-system
twist). "Missing section or cocycle phase?" dissolves into: **one
downstream class with two upstream presentations, and the class is
relative to cover and local system.** Madhavi's caution (0366: don't call
every noncommutation quantum) gets an exact form: the phases `(φ, μ)` are
noncommutation; contextuality is only their nonzero image in the
cover's cokernel.

## Boundary

Finite, one scenario, ℤ₂ coefficients, state-independent version only.
Not done: state-dependent models, higher scenarios (Kochen–Specker in
dimension 3), ~~the K3,3 torus reading~~ — **done (same day,
`machinery/pm_torus.py`)**: the incidence graph is certified K₃,₃,
nonplanar by the bipartite Euler bound (9 > 2·6−4), embedded on the torus
by an explicit 3-hexagon rotation system (every edge twice, χ = 0), so
genus 1 is minimal — the square is intrinsically a torus diagram, its
cycle space is 4-dimensional, and the obstruction class is the parity
pairing with the unique connected component; the derived/limit-coefficient
computation 0366 lists as open ("no theorem computing derived gluing
obstruction with local-system coefficients" — this note supplies the
smallest worked instance, not the theorem), and any Agda/Lean form. The
natural checked target: `coker(δ) ≅ F₂` and the exactness step — pure
finite linear algebra over F₂, no matrices over ℤ[i] needed.

## Checked status (2026-08-13): the named target is discharged

`formal/cubical/NaturalMachine/PMCokernel.agda` — `--cubical --safe`,
exit 0, no postulates, no holes — discharges this note's closing line
("the natural checked target: `coker(δ) ≅ F₂` and the exactness step —
pure finite linear algebra over `F₂`"):

- **parity kills the image**, and not by enumeration: the proof is the
  identity *a 3×3 array has the same total by rows as by columns*, so it
  covers all 512 assignments at once — a better proof than the Python's
  512-fold exhaustion, which is what generalizes;
- `total s ≡ true` by one `refl`, hence no global section;
- **each observable occurs exactly twice** is *computed* from the context
  data with a certified equality test, not transcribed — the hypothesis of
  the parity argument is checked rather than assumed;
- **exactness both ways** (`im δ = ker total`, plus `total` onto), which is
  `coker δ ≅ F₂` in usable form;
- the **one-edge ZZ twist gives exactly `2⁴ = 16` sections**, as an
  equivalence `TwistedSection ≃ (Fin 4 → Bool)` *derived* from the cycle
  structure, not measured. Theorem 3 of this note is therefore checked.

Honest limits, all in that file's header: no `SetQuotient` (the cokernel
is delivered as exactness + surjectivity, the convention `PMTorus` already
uses); ~~the sign vector `s` is a **datum transcribed from this note**, not
derived from the Gaussian-integer Pauli matrices — the upstream operator
layer `(φ, μ)` remains unformalized~~; §Theorem-4 (the gauge term is
load-bearing) is *not* in the checked lane; `rows-only-section` is trivial
for this `s` and says so.

**UPDATE 2026-08-14 — the sign vector is no longer transcribed.**
`formal/cubical/NaturalMachine/PauliWeyl.agda` (cf-tessera, `--safe`, no
postulates, exit 0 standalone and through the root aggregate) builds the
two-qubit Pauli group in the Weyl/symplectic presentation —
$i^{e}\,X^{a_1}Z^{b_1}\otimes X^{a_2}Z^{b_2}$ with $e\in\mathbb Z_4$ — and
computes the six line products of *this corpus's* grid
`[[XI,IX,XX],[IY,YI,YY],[XY,YX,ZZ]]`. Each is one `refl`, `C2` lands on
$-I$, and `derived-s ≡ PMCokernel.s` pointwise. Everything `PMCokernel`
proves downstream of `s` now rests on operator algebra rather than on a
printout of `machinery/pm_section_cocycle.py`.

Two further things came with it, both previously unchecked anywhere:

- **The 2-cocycle identity is now a proof, not an exhaustion.** This note
  records it as "verified over all 4096 triples". Associativity of the
  Pauli product (`·P-assoc`) reduces, after the $\mathbb Z_4$ part
  cancels, to the $\mathbb F_2$ identity
  $b a' \oplus (b\oplus b')a'' \equiv b' a'' \oplus b(a'\oplus a'')$ —
  distributivity of $\wedge$ over $\oplus$ — which is a sixteen-row truth
  table applied once per qubit. This is `CLAUDE.md`'s rule landing exactly
  where it says it should: the page of algebra existed and was shorter
  than the enumeration.
- **The physical hypotheses are checked.** `lines-commute` (all 18 pairs)
  and `obs-involutive` (all 9): the lines are commuting triples and each
  observable squares to the identity. The Peres–Mermin argument needs
  both and the corpus had assumed both.

Still open, and stated in that file's header rather than hidden: the
**φ/μ split is not exhibited** — the gauge cochain $\varphi=\#Y$ is
absorbed into each observable's phase field, so the total is right but
Theorem 4 stays outside the checked lane; and nothing constructs $4\times4$
matrices over $\mathbb Z[i]$ or proves the Weyl presentation faithful, so
what was removed is the Python dependency, not the modelling assumption.
The assumption is now a written definition instead of an invisible one,
which is the whole of the difference.

One methodological point worth keeping: the author ran a **sensitivity
check**, flipping `s C2` to `false` in a scratch copy and confirming
`total-s` then fails to typecheck. So the module is demonstrably not
proving an obstruction for every sign vector — the checked theorem knows
which square it is about.
