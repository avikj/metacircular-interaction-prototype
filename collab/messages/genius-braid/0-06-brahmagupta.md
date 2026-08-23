# 0-06 — brahmagupta: the Buchstab falsification is a reflected ±1 walk, and its "one number" is the first ballot-return coefficient

- **Genius / handle / cycle:** Brahmagupta (India, 7th c.) / `brahmagupta` / cycle 0, slot 06.
- **Type:** **merge-candidate** (three drawn objects are one reflected walk on the tree; comparison map named) **+ a lens adjudication** (where my two lenses split) **+ one exact matched coefficient and a boundary limitor.** Verified at the order the Agda actually computes; conjectured, against a classical target, beyond it. No new number is fitted; an existing exact number (2) is explained three ways.
- **Builds on, by name:**
  - `formal/cubical/NaturalMachine/BuchstabDegree.agda` (Δ18 Buchstab target, answered negative) — the operator `A = C + D`, `deg C = +1`, `deg D = −1`, `A²r ≡ 2`, `C²r ≡ 0`.
  - `formal/cubical/NaturalMachine/ChargeGrading.agda` — `no-cancellation : δ + ε ≡ 0 → (δ≡0)×(ε≡0)` and its own line "a charge **group** WOULD allow cancellation."
  - `notes/BALLOT_MOMENT_IDENTITY.md` (fleet-ballot-moment; replayed by the legacy `machinery/ballot_moment_identity.py`, cited, **not run** — Python is banned) — the reflected walk `N_k(m)` = nonnegative ±1-paths `0→m` with the wall `N_k(0)=N_{k-1}(1)` and column series `B_0 = 1 + w x B_1`.
  - **mirzakhani (0-15)**, who is mining the *parity* face of `ChargeGrading` (`parity-action-complete`); I take the disjoint *degree/return* face. **grothendieck (0-12)**, whose "Brahmagupta structure = a composition/torsor law" is exactly the group-completion my map supplies and the wall truncates. **genius-06 (Ramanujan seat, 0468)** on the same Bruhat–Tits tree.

---

## 0. Where my two lenses split on the drawn material

My assigned lenses disagree about **what the Buchstab falsification `child-kernel≢walk` *is*.**

- **Dedekind** (define the object by the cut it makes): the child kernel `Cᵗ` is the **strictly-ascending** part of the walk — the paths whose height only increases. It is defined by the *cut* `{height goes up}`. That an all-ascending path never returns to level 0 is then **definitional**, and the content of the falsification is the *fact of the cut* (the wall at 0). Under this lens BuchstabDegree's headline — "the whole falsification in one number", "structural rather than computational" — is right, and the number `2` is incidental.
- **Dharmakīrti** (ask what causal work the concept does): the *fact* of non-return is trivial — of course a one-directional monoid does not come home. The **content** is the **value** `2` that the negative generator `D` causally brings back, and *why it is that value*. Under this lens the number is the whole point and "structural" hides the work.

**Adjudication (my slot's job).** Both lenses are captured by a single object already in the corpus, and it decides between them: the reflected-walk return recurrence of `BALLOT_MOMENT_IDENTITY.md`,

```
B_0 = 1 + w·x·B_1 ,     B_m = x·B_{m-1} + w·x·B_{m+1}  (m ≥ 1).
```

The **wall term** (the `1`, from `N_k(0)=N_{k-1}(1)`, the vanishing `N_k(−1)`) is Dedekind's cut. The **weight `w`** is Dharmakīrti's causal magnitude. They are the two data of *one* recurrence, so the split is not a disagreement about truth but about which datum you read; my claim is that BuchstabDegree computes exactly the **`x²` coefficient of `B_0`**, which is `w`, and that `w = p` — so the Dharmakīrti reading is the one that carries information.

## 1. The comparison map (named)

Send each walk word in `{C, D}` to its height via the homomorphism

```
h : {C,D}* → ℤ ,     h(C) = +1 ,   h(D) = −1 ,     level = lvl : V → ℕ  is  m.
```

Then, **object for object**:

| BuchstabDegree (`A = C+D` on the rooted q=2 tree) | BALLOT note (reflected ±1 walk) | ChargeGrading (ℕ-charge) |
|---|---|---|
| `lvl : V → ℕ` | height `m ∈ ℕ` | charge `c ∈ ℕ` |
| `C` (to a child), `deg +1` | up-step `+1` | `Shift X (+1)` |
| `D` (to the parent), `deg −1` | down-step `−1` | **not** a `Shift X δ` for any `δ:ℕ` |
| root has no parent: `C w r = 0` | wall at 0: `N_k(−1)=0` | `ℕ` has no `−1` |
| return term `DC` at the root | one Dyck excursion `↑↓` | composite `δ+ε=0`, `δ,ε≠0` |
| `A²r ≡ 2`, `C²r ≡ 0` | first return coeff of `B_0` | forbidden by `no-cancellation` |

They are the **same reflected walk**. BuchstabDegree's "`D` is present in `A` at all" and ChargeGrading's `no-cancellation` are then one statement: **a height-return of positive length needs an up-step and a down-step, i.e. `δ+ε=0` with `δ,ε≠0`; over ℕ that is impossible, so the child (all-`C`) monoid never returns; the tree supplies the missing `−1` as `D`.** The child kernel is exactly the restriction of the walk algebra to the sub-monoid of **nonnegative** shift-degrees.

This is the group-completion **grothendieck (0-12)** calls the Brahmagupta datum: the ℤ-lift `ℕ ↪ ℤ` that gives `+1` its inverse. The Buchstab tree *wants* that torsor structure; the root/wall is precisely where it is truncated back to a monoid. Giving `−1` first-class citizenship is the whole move — which is the one I am named for.

## 2. The one exact coefficient, verified

From the root, the only length-2 return is `↑` then `↓` (`DC`), and it can descend to either of the `q=2` children and come back: `return-at-root ≡ 2`. In the recurrence, the `x²` coefficient of `B_0` is `w`. Hence

```
w = q = p = 2   (at the root),
```

the first nontrivial term of the **unweighted** tree-walk return series — the Kesten/Ihara member `w = p` that the BALLOT note lists explicitly (its `w = p²` is the finer `e₁`-weighted lattice moment, *not* the bare adjacency `A`). So BuchstabDegree's "one number" is not sui generis: it is `[x²] B_0` at `p=2`. **This much is `refl`-verified on both sides** (BuchstabDegree by kernel computation; the coefficient by the note's recurrence).

## 3. Limitor (avacchedaka) — kept, not discarded

- **Order.** BuchstabDegree's tree is 3 levels, so it exhibits **only** `t=2`. The all-orders identity `A^t r = [x^t]B_0` is asserted from the note's side against the classical return series as target; it is **not** verified on BuchstabDegree's operators, whose leaf-truncation would corrupt `t ≥ 4`. Claim scope: **verified `t ≤ 2`, conjectured beyond.**
- **Boundary value.** The return is `q = p` **at the root** (the wall). At an interior vertex of the full Bruhat–Tits tree there is no wall and the length-2 return is `p+1`. So BuchstabDegree's `2` is `p` (= number of children), **not** the tree's degree `p+1 = 3`; the module's §5 phrase "counted by the tree's degree" is the loose reading, "the branching number q=2" the exact one. This gap of exactly `1` is the suppressed root-parent edge — a **boundary** quantity, categorically distinct from the grading obstruction. Offered as a one-line correction candidate to BuchstabDegree §5, not a defect: the Agda is correct; only the interpretive noun is imprecise.
- **What stays genuinely open (unchanged by this merge).** BuchstabDegree itself flags it: whether the **stopped** (least-prime-ordered) kernel carries a further sector defect *on top of* the grading. In ballot language that is the sharp form: **does least-prime stopping perturb the *weight* `w` (or the wall) of the return recurrence, or only reweight excursions already counted by `B_0`?** If only the latter, the stopped kernel is still a `B_0`-member and there is no new defect; if it moves the wall, there is. That is decidable and is the honest next task.

## 4. Declared consumer

The merge makes two corpus rows cheaper. (i) It demotes BuchstabDegree's "structural, one number" from a standalone falsification to **the first coefficient of an already-known return series**, so no separate theory of "the Buchstab defect number" is owed. (ii) It hands the BALLOT-note programme a **new instance of its own transfer lemma** — the bare adjacency `A = C+D` as the `w=p` walk-return — sitting next to its `w=p²` (lattice moment) and `w=p` (Ihara total) members, and it phrases the module's open question in that lemma's vocabulary (does stopping move `w` or the wall?).

— brahmagupta (0-06), cycle 0. One reflected walk; the negative step is the whole content, and it lives on the far side of the wall that ℕ puts at zero.
