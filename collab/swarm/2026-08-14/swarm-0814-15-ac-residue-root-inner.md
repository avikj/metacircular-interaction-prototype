---
from: swarm-0814-15
date: 2026-08-14
type: result (correction + theorem + obstruction)
object: formal/cubical/Swarm/S15ACResidue.agda  (agda -i . Swarm/S15ACResidue.agda -> EXIT=0)
corrects: runtime/execute/acmatch.py, module docstring "THE SEMANTICS, STATED BEFORE THE CODE"
---

# The AC residue: sound at the root by congruence, obstructed at an inner node by non-uniformity — and `acmatch.py` gives the wrong reason

## 0. The draw, and where the two lenses split

Eleven files, read in full before planning. Uniform 8: `machinery/test_primitive_split_mobius_count.py`,
`notes/ROSETTA_ENGINE.md`, `collab/messages/0298-…`, `figures/exp27_running.png`,
`collab/messages/0054-fleet-archeology-orchestration-diff.md`, `code/path_harvest.py`,
`collab/messages/0081-cf-mathematical-runtime-seed.md`, `collab/messages/0314-…`.
Rare corners: `collab/discovery/channel_partition.py`, `runtime/execute/acmatch.py`,
`collab/discovery/events/R0015/20260811T211605Z-builder.json`.
Frontier field: PDE regularity. Ancient field: Ibn al-Haytham's controlled method.
Lenses: **Poincaré** (when the equation is unsolvable, study the qualitative flow) and
**Gauss** (do not publish the scaffolding, but do build it).

Seven of the eleven are scaffolding — a manifest validator, a ledger-classifier, an
orchestration diff, an event record, a discovery grammar, a matcher, a unit test.
On `acmatch.py` the lenses give opposite verdicts, which is where the assignment is.

- **Poincaré's verdict on `acmatch.py`.** The AC match search has no closed form; the
  file says so and quantifies it (`n!/(n-p)!` root assignments, measured through
  `ACResult.top`). The right move is therefore to study the *qualitative* structure —
  what is invariant along the search, what the boundaries of the sound region are. The
  file does precisely this, in a 113-line docstring placed **before** the code, and it
  names the boundary: **residue allowed at the root, forbidden at every inner AC node**.
- **Gauss's verdict.** That docstring *is* the scaffolding, published. The boundary it
  names is a theorem or it is nothing. Gauss says: prove the boundary, delete the prose,
  and check whether the reason given is the reason that holds.

It is not. That is the object.

Ibn al-Haytham's contribution to the draw is the operative test rather than ornament:
his method is to *vary one factor and hold the rest*, and to prefer the intervention
that could discriminate between two proposed causes. Applied here: the docstring's
stated cause ("the instantiated left side is a different term from the subject") and the
actual cause are told apart by holding everything fixed except the *position* of the
residue. The witness in §3 is exactly that controlled variation.

## 1. What `acmatch.py` claims

Sub-multiset matching with residue is permitted at the root of a pattern (`ac_match`,
`residue=True`) and refused at every inner AC node (`_sub_match` → `_assign(...,
residue=False)`). The stated reason, verbatim:

> **At every inner AC node** the match is a *bijection*: same arity, any permutation, no
> residue. This is not a budget, it is the semantics — an inner residue would make the
> instantiated left side a *different term* from the subject (`(#0+#1)` matched against
> `a+b+c` with residue `c` claims the subject is `a+b`, which it is not), so an inner
> residue is unsound for a rewrite, not merely expensive.

**The argument refutes the module's own root case.** At the root, `mul ?a ?a` matched
against `mul x y x z` also "claims the subject is `mul x x`", which it is not. The module
does not treat this as unsound; it repairs it, by building a **derived lemma** whose left
side is the pattern *extended by fresh residue variables* — the `skeleton` of `ACMatch`,
gated by `derive_ac_lemma` G1–G5. The identical extension is available at an inner node:
replace the inner node `q` by `q` with residue variables appended. Gate G3
(`ac_canonical` agreement) and gate G4 (`poly_equal`) both remain meaningful there. So
"different term from the subject" is a property the two cases *share*, and cannot be
what separates them.

The restriction is nevertheless **correct**. Below is why, and it is a different reason.

## 2. Theorem (root): the residue construction is congruence, and it is uniform

`derive_ac_lemma` builds the derived right side as

```
rhs' = base.rhs                       if there is no residue
rhs' = mk(lhs.kind, (base.rhs,) + rvars)   otherwise        (acmatch.py sec. 4)
```

— **a function of the base right side and the residue alone**. It never reads
`base.lhs`. Formalised (`Swarm.ACRoot`, module parameters: any `_⊕_` with associativity,
commutativity, and a left unit; arguments of an AC node are a `List A`; `⊙` is the fold;
`Perm` is the AC-rearrangement relation that G3's `ac_canonical` test decides):

```
Ψroot : A → List A → A
Ψroot r zs = r ⊕ (⊙ zs)

rootSound : (ps rs zs ts : List A)
          → (⊙ ps) ≡ (⊙ rs)          -- gate G4 on the base lemma
          → Perm (ps ++ zs) ts        -- gate G3 on the derived left side
          → ⊙ ts ≡ Ψroot (⊙ rs) zs
```

The conclusion does not mention `ps`. Hence

```
rootUniform : (ps ps' rs zs ts ts' : List A)
            → (⊙ ps) ≡ (⊙ rs) → (⊙ ps') ≡ (⊙ rs)
            → Perm (ps ++ zs) ts → Perm (ps' ++ zs) ts'
            → ⊙ ts ≡ ⊙ ts'
```

Two base lemmas with the *same right side* and the *same residue* force the same derived
value, whatever their left sides. This is nothing but congruence: the derived left side
is `C[base.lhs]` for the context `C = (·) ⊕ Z`, so the derived right side is `C[base.rhs]`,
uniformly and for free. `rootSound` is the exact statement that **G3 + G4 ⟹ the AC step
is valid**, for any AC operator, any arity, any permutation, any residue — which is the
soundness `acmatch.py` asserts in prose across sections 2, 4 and 7 and never states.

## 3. Obstruction (inner): no uniform derived right side exists

Not "the module has not implemented one" — **none exists**, and the witness needs only
one lemma.

Take the base lemma over ℕ

```
baseLhs x y = (x + y) + ((x + y) · x)
baseRhs x y = (x + y) + ((x · x) + (y · x))          baseLemma : baseLhs ≡ baseRhs
```

The AC node `(x + y)` occurs **twice, as literally the same subterm**, under two
different contexts: bare at the first occurrence, under `_· x` at the second. Match that
node against `(x + y + z)` with residue `z`. Both extensions are legitimate inner AC
matches and both pass G3 at their position:

```
ext₁ x y z = ((x + y) + z) + ((x + y) · x)        -- residue into occurrence 1
ext₂ x y z = (x + y) + (((x + y) + z) · x)        -- residue into occurrence 2
```

Both have a correct derived right side, so *derivability* is not the obstruction:

```
ext₁-correct : ext₁ x y z ≡ ((x + y) + z) + ((x · x) + (y · x))
ext₂-correct : ext₂ x y z ≡ (x + y) + (((x · x) + (y · x)) + (z · x))
```

The residue enters **additively** at one occurrence and **scaled by `x`** at the other.
Same lemma, same node, same residue, two unequal answers: at `(x,y,z) = (2,0,1)` they are
`7` and `8`. Therefore

```
noUniformInner : (Ψ : ℕ → ℕ → ℕ → ℕ)
               → ((x y z : ℕ) → ext₁ x y z ≡ Ψ x y z)
               → ((x y z : ℕ) → ext₂ x y z ≡ Ψ x y z)
               → ⊥
```

for **any** candidate `Ψ` whatsoever, and in particular for anything computed from
`(base.rhs, residue, kind)` — the exact input of the root construction. `innerNotUniform`
states the same as the direct failure of `rootUniform`'s inner analogue.

## 4. The corrected statement of the boundary

> **Root residue is an instance of congruence.** The derived left side is `C[base.lhs]`
> for the context `C = (·) ⊕ Z`, so the derived right side is `C[base.rhs]`, uniformly in
> the base lemma and computable without reading `base.lhs`.
>
> **Inner residue is not a congruence instance at all.** The derived left side is
> `base.lhs[p := q ⊕ Z]` — a *substitution into* the pattern, not a *context around* it.
> No rule of equational logic sends `base.lhs = base.rhs` to any statement about
> `base.lhs[p := q ⊕ Z]`. A derived right side must be solved for afresh, and it depends
> on how the surrounding context acts at position `p`; by §3 that dependence is real, so
> no position-blind construction is available.

Two things follow for the file, neither of which changes a line of its search:

1. **G5 has no inner analogue, and cannot get one.** G5 ("every residue variable of the
   left side occurs in the right side") is meaningful only because at the root the
   residue *must* survive. At an inner node under an annihilating context the residue is
   correctly dropped, and under `_· x` it is correctly multiplied; "occurs in the right
   side" is not the invariant there.
2. **`ac_permutation_matches` (sec. 8) is right for the right reason.** Its comment —
   "`EMatch` has nowhere to put a residue, and a match whose residue has no home is
   exactly the AC rewriting bug this module exists to avoid" — is the *correct* argument,
   stated for the kernel hook and not for the inner-node case that needs it. §3 is what
   "no home" means precisely: the home is not determined by the data the construction has.

## 5. Honesty ledger

- Everything in §2 and §3 is machine-checked: `formal/cubical/Swarm/S15ACResidue.agda`,
  `--cubical --guardedness --safe --no-import-sorts`, no postulates, no holes,
  Agda 2.6.3 + cubical v0.5. **`agda -i . Swarm/S15ACResidue.agda` → `EXIT=0`.**
  `7≢8` type-checks only because Agda normalises the two sides to `suc⁷ zero` and
  `suc⁸ zero`; `znots` would not apply otherwise. The arithmetic is certified by the
  checker, not by a run.
- §2 abstracts the substrate: it models an AC node as its argument list modulo `Perm`
  and gives it a value by folding an associative-commutative operator with a unit. That
  is exactly `crystallize.derivation`'s flat n-ary `Sum`/`Prod` under `poly_equal`'s
  semantics; it does **not** model pattern variables, `_sub_match`'s recursion, or the
  skeleton construction. The claim proved is about the *equational* content of the step
  (G3+G4 ⟹ valid), which is the part the docstring calls "the semantics".
- §3 is a refutation over ℕ. It refutes the existence of a uniform derived right side.
  It does **not** claim inner AC matching is unimplementable — a position-aware
  construction that re-solves for the right side per occurrence would be sound. Cost is
  not analysed and is not claimed.
- No prior-art search was performed on AC matching itself; residue-carrying AC matching
  is classical (Peterson–Stickel, Bachmair–Dershowitz–Plaisted) and the root/inner
  asymmetry may well be folklore there. **What is repo-specific and is the deliverable
  is that `acmatch.py`'s stated reason is provably not the operative one.** Treat §4 as
  a correction to this repository's document, not as a claim of novelty in rewriting.
  `PROVE`/`SEARCH` follow-up: `SEARCH` — locate the standard name for §4's distinction
  before anyone cites it as new.

## 6. Things in the draw that contradict conspicuous documents

1. **`code/path_harvest.py` vs. `CLAUDE.md`'s Python ban.** The ban is enforced by
   `.claude/hooks/no-python.sh`, `.githooks/`, and CI, and 660 legacy `.py` files are
   grandfathered. But `path_harvest.py` and `collab/discovery/channel_partition.py` are
   not dead legacy: they are *the running validators of the claim registry and the
   failure ledger*, invoked as `python3 collab/discovery/channel_partition.py` in their
   own docstrings. The corpus's integrity machinery is written in the banned language and
   cannot be modified under the current rule. No document I read acknowledges this. This
   is a governance fact, not a mathematical one, and I take no action on it.

2. **`collab/discovery/channel_partition.py` vs. `CLAUDE.md`'s "a correlation coefficient
   has no content".** The script computes a *partition* — a census of what a ledger says
   — and its own closing text states the limit honestly ("it cannot distinguish 'caught
   by channel X' from 'written up citing X'… the ledger is itself authored inside the
   distribution under test"). Under CLAUDE.md this is exactly a measurement standing in
   for an error analysis. But the error analysis is *unavailable in principle*, not
   merely undone: the observable is the ledger's own prose. That case — a measurement
   whose error term is not derivable because the instrument is inside the system — is not
   covered by CLAUDE.md's single distinction, and the script is more honest than the rule
   requires. Recommend `notes/METHOD.md`'s triage record this as a third category rather
   than force it into "correlation".

3. **`figures/exp27_running.png` vs. `CLAUDE.md` §"The rule".** CLAUDE.md cites exp27's
   fitted `0.362`–`0.421` against a true `1/4`. The figure is still in the tree and its
   right panel is labelled `0.362 log²Q + 0.192 logQ + 0.332` with no caption marking it
   as the corpus's canonical error. Message `0081` §1 independently reports the same
   failure mode from the other side (`M1`'s "exact-rational check … could not fail, so it
   wasn't one"). The figure should carry the retraction inline; as it stands it is a
   plot of a known-wrong constant, indistinguishable from a result.

4. **`notes/ROSETTA_ENGINE.md` §4 vs. §5.** The discovery grammar demands a `CERTIFICATE`
   and a `FALSIFIER` per packet; §5's selection order ranks "an exact numerical constant
   with a stable basis and independent precision" *fourth*, above a language rotation.
   Under the current CLAUDE.md an exact numerical constant is not a certificate type at
   all unless derived. Item 4 is a survival from the withdrawn four-licence scheme.

5. **`collab/messages/0054` §3.1 requests an edit to `DIRECT.md` that CLAUDE.md has since
   overruled.** The proposal — "a scan is admissible iff it computes a declared exact
   quantity that confirms-or-kills a stated candidate statement AND ships with a control
   where the statement is known false" — is a fifth licence. CLAUDE.md's current text
   withdrew the four-licence scheme entirely. The message is still open ("Requesting
   cf-prime/Codex review"); it should be closed as superseded rather than left pending.

## 7. What I did not do

No computation was run other than type-checking. The theorem `noUniformInner` is what a
measurement of "how often does inner AC matching help?" would have stood in for, and it
answers the prior question the measurement presupposes. No Python was created, modified,
or executed; the four `.py` files in my draw were read as evidence. No git commands.
