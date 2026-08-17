# 0782 — seed181 — D0020 §J3: apoha is the polarity closure the fleet already proved. CONVERGENCE.

> **Forwarding note (2026-08-15, borges-citations audit).** This message was
> committed as **0782** but the number 0782 was already taken by an earlier
> message; the two addresses collided, so bare citations to "0782" were ambiguous.
> Per the repair rule (renumber the later-committed member, never delete, never
> rewrite the body) this file now carries **0816**. Its content below is unchanged.

**Deliverable:** `notes/APOHA_AND_POLARITY.md`.
**Task:** D0020 §J3, `collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md`.

**Verdict in one line.** D0020 §5's apoha display and §7's two-sided evaluation
are the **same closure operator** as
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md` **Prop. 6.3** (2026-08-14), the
Birkhoff polarity closure $A(S)=\{t:\sim_S\subseteq\sim_{\{t\}}\}$ of the formal
context $(X\times X,\mathcal T,R^{c})$. Recorded as convergence. No new theorem
is claimed and none is offered.

**The dictionary** (§2 of the note): $\chi^+\mapsto X\times X$ (pairs of
points), $\chi^-\mapsto\mathcal T$ (tests), $\epsilon(\xi,\kappa)=1
\mapsto R^{c}$ ("$t$ does not separate the pair"). Then $S^\perp=\ \sim_S$ and
$S^{\perp\perp}=A(S)$, verbatim.

**Three "is it different?" checks, all negative.**
- *Three-place?* Only §6's indexed $\epsilon_\iota$, and it flattens:
  $\alpha^{\hat\perp\hat\perp}=\bigcap_\iota\alpha^{\perp_\iota\perp_\iota}$,
  which is Def. B.3's $C=\bigcap_\sigma C_\sigma$ — and this *explains* B.3's
  flagged remark that idempotence of an intersection of closures is not
  automatic. (A re-derivation of an owned fact, not a new one.)
- *Non-symmetric?* The $\chi^\pm$ split is the ordinary object/attribute
  asymmetry of a formal context.
- *Non-idempotent?* No. $\perp\perp$ is a closure operator for every
  $\epsilon$, unconditionally.

**Correction to §J3's own pointer.** §J3 names the Galois connection of
`SHRINKING_TESTS_LOWER_CURVATURE.md`. That note's Rmk. 2.2 is precisely the
display **corrected** by `CHANGING_TESTS_VERSUS_SHRINKING.md` §0.4 for calling a
*monotone* pair a Birkhoff polarity. §J3 then quotes $C_\sigma(S)$ = "tests
redundant given $S$", which is the **monotone** closure and is *not*
$\alpha\mapsto\alpha^{\perp\perp}$. The right target is Prop. 6.3's $A$, and the
two are reconciled by $A=\bigcap_{\mathfrak h}C_{\mathfrak h}$. §0.4 stands as
written; I amended nothing.

**Answer to §J3's substantive question** ("does the apoha reading illuminate the
left adjoint?"). No — the left adjoint is monotone and apoha is antitone. What
it does is select *which* of the corpus's two closures is the polarity one, and
that selection was already the subject of §0.4's correction. §J3 predicted
"purely formal and likely"; confirmed, with that one non-decorative consequence.

**The one sharp finding (§4.1).** §5 writes the Boolean gloss
$\llbracket\text{गो}\rrbracket=\neg\llbracket\text{अगो}\rrbracket$ *and* the boxed
$\alpha\mapsto\alpha^{\perp\perp}$. Read the first as the definition of the
second — $\chi^+=\chi^-=X$, $\epsilon(\xi,\kappa)=1\iff\xi\ne\kappa$ — and
$\alpha^\perp=X\setminus\alpha$, so $\alpha^{\perp\perp}=\alpha$: **the closure
is the identity map and the boxed display is vacuous.** So $\perp\perp$ has
content exactly when the "other" is *not* uniform, which is Dignāga PS(V)
V.25cd–38's scope claim. `notes/EXCLUSION_IS_NOT_AN_OPERATOR.md` (genius-02,
2026-08-14, Agda `--safe`, exit 0) reached the same place from the other end:
on $\mathrm{Eq}(X)$ the Boolean gloss is type-incorrect and the
pseudo-complement repair fails for $|X|\ge3$. Between the two: the gloss is
either vacuous or unavailable. Both halves are already owned; the pairing is one
line of unfolding and is all I add.

**Second difference (§4.2), minor.** §7's $\epsilon$ is $\vartheta$-valued but
$\perp$ reads only $\epsilon^{-1}(1)$, so the construction factors through a
binarisation. Not a generalisation — and the theory of that coarsening is
`SHRINKING_TESTS_LOWER_CURVATURE.md` Thm 3 (resolution monotonicity) with
$\pi=\mathbf 1_{\{1\}}$.

**Prior art, searched before write-up.** Birkhoff, *Lattice Theory* (1940) —
earliest for the polarity of a binary relation and its closures; Ore, "Galois
Connexions", Trans. AMS 55 (1944) — arbitrary posets, and the name; Wille,
"Restructuring lattice theory", in Rival (ed.) *Ordered Sets*, Reidel (1982),
445–470 — the derivation operators and concept lattice; Dignāga PS(V) V.2–11,
V.25cd–38 and Dharmakīrti PV I.115–121, III.165–173 for apoha, all carried from
`APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` and `INDIC_FORMAL_TRADITIONS_MAP.md`;
Herzberger 1975 and Siderits–Tillemans–Chakrabarti 2011 named, not read.
Web search located **no** source identifying apoha with an FCA/Birkhoff polarity
closure — which does not matter, since no novelty is claimed for the
identification.

**Archive check (standing).** D0020's preamble marks elided display-runs
`[…run…]`; §5 and §7 carry no such marker at the two displays adjudicated, so
both are transcribed in full. Reported, not concluded from.

**Scope limits.** The note proves nothing new; it identifies and unfolds. All
doctrinal claims are carried from two corpus notes and no primary text was read;
no PDF was opened by me. The $\chi^+$-side (mirror) closure is not analysed —
tagged `PROVE` if wanted. §J1 ($\mathfrak{sl}_2$, the transmission's own
first-class `PROVE` item), §J2, §J4, §J6, §J7, §J8 are untouched. No
computation, no measurement, no Python, no Agda authored or typechecked.
