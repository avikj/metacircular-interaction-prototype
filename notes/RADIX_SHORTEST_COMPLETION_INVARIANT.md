# The shortest completion is the whole invariant

*ARCHIMEDES lane, genius-00, 2026-08-14. Two phases, kept separate: the
mechanical method that found it, then the proof, which does not mention it.*

`notes/GENERAL_RADIX_DIVISIBILITY.md` classifies the states of the base-`b`
divisibility automaton by a signature with `K+1` coordinates,

```text
  Sigma(r) = ( e_0(r), ..., e_{K-1}(r),  r mod (m / gcd(m, b^K)) ),
  K = least k with b^k >= m,
  e_k(r) = (-b^k r) mod m   if that value is < b^k,   else  BOT.
```

This note replaces it by a signature with **two** coordinates, which mentions
neither `K`, nor the interval `[0, b^k)`, nor the fact that the digit alphabet
is `{0,...,b-1}`:

```text
  sigma(r) = ( kappa(r),  (b^{kappa(r)} * r) mod m )
```

where `kappa(r)` is the least length of a digit word that carries `r` to a
multiple of `m`. Read arithmetically the second coordinate names exactly the
set of shortest such words, so the theorem is:

> **Two states of the divisibility automaton are behaviourally equal if and
> only if they have the same set of shortest completions.**

The Agda module `formal/cubical/NaturalMachine/RadixSymptoma.agda` checks this
for an **arbitrary** digit alphabet (`agda NaturalMachine/RadixSymptoma.agda`,
exit 0, `--cubical --safe`, 0 warnings, no postulates, no holes).

---

## Phase 1 — the mechanical method (how it was found; not a proof)

Put the states of the automaton on a ruler. A state `r in [0,m)` reached after
some digits is a *claim on an interval*: appending `j` more digits multiplies
the running value by `b^j` and adds something in `[0, b^j)`, so after `j` more
digits the value lies somewhere in

```text
  [ r*b^j ,  (r+1)*b^j ).
```

That interval has width `b^j` and slides right as `r` grows. Lay the multiples
of `m` down as a second, uniform ruler. Then:

> *`r` can be completed to a multiple of `m` in `j` more digits exactly when
> the interval of width `b^j` starting at `r*b^j` covers a mark of the `m`-ruler.*

This is a weighing statement, not an algebraic one, and three things fall out of
it immediately.

**(i) The conditions are nested, so only the first one counts.** As `j` grows
the interval gets wider and can only become easier to satisfy; once it covers a
mark it covers one for every larger `j` too (slide the extra width in by
appending zeros). So the list `e_0, e_1, e_2, ...` is `BOT, ..., BOT` and then
never `BOT` again. A list that is a threshold is a number: its threshold.

**(ii) The congruences weaken as `j` grows, so the first non-`BOT` one is the
strongest.** The `k`-th coordinate, when it is not `BOT`, pins `r` modulo
`m/gcd(m,b^k)`, and `gcd(m,b^k)` only grows with `k`. Weighing again: each later
coordinate is a *lighter* constraint hanging on the same beam. The beam
balances at the first one.

Together (i) and (ii) say the whole `(K+1)`-tuple is carried by the pair
(threshold, constraint at the threshold) — which is `sigma`.

**(iii) Reading the ruler backwards gives the level sets for free.** "The
interval `[r b^j, (r+1) b^j)` covers `n*m`" says `r = floor(n*m / b^j)`. So the
states with threshold at most `j` are *exactly the floors of the `m`-ruler
sampled at spacing `b^j`*, and when `b^j < m` those floors are strictly
increasing, hence exactly `b^j` of them.

**What the mechanical method got wrong, and how the second phase corrected it.**
Every step above uses the interval `[0, b^j)` of digit words, i.e. it presumes
the alphabet is complete. When the argument was written out for the proof, the
interval turned out to be needed only for the *computation* of `kappa`, never
for the *theorem*: the proof below uses only that `run(r,u) = b^{|u|} r + val(u)`
and that `kappa` is a behavioural minimum. So the theorem survives the loss of
the ruler, and holds for any digit set. That is the part the coordinates hid.

---

## Phase 2 — the proof

### Setting

Fix `b, m` in `N`. Let `D` be any set of digits with a weight `w : D -> N`.
The machine has state set `N`, one action per digit, and one observation:

```text
  step(r, d)  =  b*r + w(d)
  obs(r)      =  [ r == 0  (mod m) ]
  run(r, [])  =  r
  run(r, d:u) =  run(step(r,d), u)
```

Behavioural equality `r ~ s` is `NaturalMachine.FutureBehavior.FutureEq`:
`obs(run(r,u)) = obs(run(s,u))` for every finite word `u`. On the reachable
states this is the Myhill–Nerode relation of the language
`{ u : m divides val_b(u) }`.

**Lemma 1 (the machine is affine in its state).**
`run(r,u) = b^{|u|} * r + val(u)`, where `val([]) = 0` and
`val(d:u) = b^{|u|} * w(d) + val(u)`.
*Proof.* Induction on `u`. For `d:u`,
`run(r,d:u) = run(b r + w d, u) = b^{|u|}(b r + w d) + val(u)
            = b^{|u|+1} r + (b^{|u|} w d + val u)`. ∎

**Definition.** `u` *completes* `r` when `m | run(r,u)`. The **symptoma**
`kappa(r) in N u {infinity}` is the least length of a completing word.
For `kappa(r) < infinity` set `sigma(r) = (kappa(r), b^{kappa(r)} r mod m)`;
for `kappa(r) = infinity` set `sigma(r) = infinity`.

### Theorem

`r ~ s` if and only if `sigma(r) = sigma(s)`.

*Proof.*

**(<=) Degenerate case.** Suppose `kappa(r) = kappa(s) = infinity`. Then no word
completes `r` and none completes `s`, so `obs(run(r,u)) = false = obs(run(s,u))`
for every `u`.

**(<=) Main case.** Suppose `kappa(r) = kappa(s) = k` and
`b^k r == b^k s (mod m)`. Let `u` be any word, `n = |u|`.

* If `n < k`: by minimality of `k` for `r`, `u` does not complete `r`; by
  minimality of `k` for `s`, `u` does not complete `s`. Both observations are
  `false`.
* If `n >= k`: write `n = j + k`. Multiplying the hypothesis by `b^j` gives
  `b^n r == b^n s (mod m)`. Adding `val(u)` and applying Lemma 1,
  `run(r,u) == run(s,u) (mod m)`, so the two observations agree.

**(=>)** Suppose `r ~ s`. Then a word completes `r` iff it completes `s`, so the
two sets of completing words coincide, hence so do their length sets, hence
`kappa(r) = kappa(s) =: k`. If `k = infinity` we are done. Otherwise choose `u0`
completing `r` with `|u0| = k`; it completes `s` too. By Lemma 1,

```text
  m | b^k r + val(u0)      and      m | b^k s + val(u0),
```

so `m | b^k r - b^k s`, i.e. `b^k r == b^k s (mod m)`. ∎

**Remark (what the proof does not use).** It never counts words, never compares
`b^k` with `m`, never uses that lengths of completing words are upward closed,
and never uses that `0` is a digit. Hence it holds verbatim for `D = {0,2,4,6,8}`
in base ten, for `D = {0,1}` in base ten, and for infinite `D`. The Agda proof
additionally avoids subtraction: `mod-+cancel` derives
`x == y (mod n)` from `x + v == 0` and `y + v == 0` by adding the two hypotheses
to each other in the two associations, `(x+v)+y` and `x+(y+v)`.

### Corollary 1 (gcd form)

`b^k r == b^k s (mod m)` iff `r == s (mod m/gcd(m,b^k))`. So one may equally
write `sigma(r) = (kappa(r), r mod m/gcd(m, b^{kappa(r)}))`. The `b^k`-scaled
form is preferred because it needs no gcd.

### Corollary 2 (the invariant is the shortest completion set)

For `k = kappa(r) < infinity`, the completing words of length `k` from `r` are
exactly `{ u : |u| = k, val(u) == -b^k r (mod m) }`, a set determined by
`b^k r mod m`; and when `kappa(r) = infinity` the set is empty. Hence `r ~ s`
iff `r` and `s` have the same set of shortest completions.

### Corollary 3 (the `(K+1)`-coordinate signature factors through `sigma`)

Take `D = {0,...,b-1}` complete, `b >= 2`, and `K` least with `b^K >= m`.
Appending a zero multiplies by `b`, so completing lengths are upward closed;
therefore `e_k(r) = BOT` exactly for `k < kappa(r)`, and for `k >= kappa(r)`,
`e_k(r) = (-b^k r) mod m`, which is a function of `b^{kappa(r)} r mod m`. So
`Sigma = F o sigma` for a function `F`, and the two signatures have the same
fibres. `sigma` is the shorter of the two by `K-1` coordinates, and `K` grows
like `log_b m`.

### Corollary 4 (exact level sets, complete alphabet)

For `0 <= j`,

```text
  { r in [0,m) : kappa(r) <= j }  =  { floor(n*m / b^j) : 0 <= n < b^j }.
```

*Proof.* By upward closure, `kappa(r) <= j` iff some length-`j` word completes
`r`, iff some multiple `n*m` lies in `[r b^j, (r+1) b^j)`, iff
`r = floor(n m / b^j)`; and `n m / b^j in [0,m)` forces `n in [0,b^j)`. ∎

For `j < K` we have `b^j < m`, so consecutive samples `n m / b^j` differ by more
than `1` and the floors are strictly increasing: the set has exactly `b^j`
elements. Since every `r` has `kappa(r) <= K`, the fibres of `kappa` have sizes

```text
  |kappa^{-1}(0)| = 1,
  |kappa^{-1}(j)| = b^j - b^{j-1}      (1 <= j <= K-1),
  |kappa^{-1}(K)| = m - b^{K-1}.
```

### Corollary 5 (class count, split by depth)

Write `r_n = floor(n m / b^j)` and `s_n = n*m mod b^j`, so `b^j r_n == -s_n
(mod m)`. For `j < K` we have `s_n < b^j < m`, so two depth-`j` states are
equivalent iff their `s_n` agree; and `kappa(r_n) = j` iff `b` does not divide
`n`. Hence for `1 <= j < K` the number of Nerode classes at depth `j` is

```text
  |{ (n*m) mod b^j : 0 <= n < b^j,  b does not divide n }|,
```

depth `0` contributes exactly one class (that of `0`), and depth `K` contributes
`|{ b^K r mod m : kappa(r) = K }|`.

### Worked controls (exact, by hand)

`b = 2, m = 12` (`K = 4`). Depth fibres `{0} | {6} | {3,9} | {1,4,7,10} |
{2,5,8,11}` of sizes `1,1,2,4,4`, matching Corollary 4
(`1, 2-1, 4-2, 8-4, 12-8`). Classes per depth `1,1,1,1,1`. Total **5**, which is
`q + a = 3 + 2` — the binary theorem of `BINARY_DIVISIBILITY_CRYSTAL.md`.

`b = 10, m = 12` (`K = 2`). Depth fibres `{0} | {1,2,3,4,6,7,8,9,10} | {5,11}`
of sizes `1, 9, 2`, matching `1, 10-1, 12-10`. Classes per depth: `1`; then
`|{12n mod 10 : n = 1..9}| = |{0,2,4,6,8}| = 5`; then
`|{100r mod 12 : r in {5,11}}| = |{8}| = 1`. Total **7** — the negative control
of `GENERAL_RADIX_DIVISIBILITY.md`, which is not `q + K = 3 + 2`.

---

## What is machine-checked and what is not

**PROVED (Agda, `formal/cubical/NaturalMachine/RadixSymptoma.agda`, exit 0):**
Lemma 1 (`run≡`); the Theorem in both directions for an arbitrary digit
alphabet (`symptoma→≈`, `≈→sameDepth`, `≈→symptoma`); the degenerate class
(`noEscape→≈`, `≈→noEscape`); and the supporting modular arithmetic
(`mod-+congˡ`, `mod-·congʳ`, `mod-+cancel`, `^-+`, `scale-mod`), all valid for
every modulus including `0`. `kappa` is formalised as a *relation* (`Escape r k`)
rather than a function, because for infinite `D` the least completing length
need not be computable and the theorem does not need it to be.

**PROVED on paper only (not Agda):** Corollaries 1–5. Corollary 3 needs upward
closure of completing lengths (i.e. `0` is a digit); Corollary 4 additionally
needs that length-`j` words realise exactly `[0,b^j)`. Formalising Corollary 4
would go through `NaturalMachine/Digits.agda`, which already has certified
base-`b` expansion; that is an open `PROVE` item, not a claim.

**CITED (search-summary grade; `WebFetch` is EGRESS_BLOCKED, so the paper was
not read).** Boris Alexeev, *Minimal DFA for testing divisibility*, JCSS 69
(2004) 235–243, gives the exact closed state count `f_b(m)`, already recorded in
`GENERAL_RADIX_DIVISIBILITY.md`, which also says his "strict-solution-set
packages remove redundant signature coordinates". Searches run:
`"Alexeev minimal DFA testing divisibility base b Myhill-Nerode shortest
completion invariant"` and `"Nerode equivalence 'shortest accepted word'
invariant residual automaton digit set incomplete alphabet divisibility"`.
Neither located a statement in the two-coordinate / shortest-completion form,
**and absence of a located source is not evidence of novelty** — the redundancy
elimination here is very plausibly Alexeev's, differently packaged. **No novelty
is claimed for the classification or for the counts.** What is claimed is (a) an
independently derived two-coordinate normal form for this corpus, strictly
shorter than the one `GENERAL_RADIX_DIVISIBILITY.md` records, (b) its
alphabet-independence, and (c) a machine-checked proof.

**OPEN.** Nothing here computes `kappa` inside Agda; that needs decidable search
over `D`. For the complete alphabet it is decidable and bounded by `K`.

---

## Why this note exists, in the terms of the draw

Two lenses were assigned so that they would disagree. **Kolmogorov** asks for the
complexity of the *individual object*: what is the shortest description of *this*
state of *this* automaton? The answer is `sigma` — two numbers, whatever `b` and
`m` are, and in particular of size independent of `K ~ log_b m`. **Chaitin** asks
for the shortest program that outputs the thing; if the thing is the *state
count* `f_b(m)`, the shortest program is Alexeev's gcd chain, whose length grows
with the gcd tower of `m` against `b` and which cannot be shortened to a fixed
number of terms. The lenses disagree because they disagree about what the object
is, and the disagreement is real content: **the per-state description is `O(1)`
coordinates while the per-automaton count is not `O(1)` terms.** The
`(K+1)`-coordinate signature is the artifact of answering Kolmogorov's question
with Chaitin's instrument — one coordinate per level, because the count needs one
term per level.

**Apollonius** supplies the name. A conic was classified before coordinates by
its *symptoma*, the relation its ordinate satisfies against a fixed segment.
`kappa(r)` is a symptoma in exactly that sense: it is defined by the relation
"the interval of width `b^j` at `r b^j` meets the `m`-ruler", stated about the
state and the modulus, with no automaton coordinate and no residue class in
sight; the residue-theoretic form (Corollary 1) is the later coordinate
translation. That the symptoma survives deletion of the alphabet, while the
coordinate form does not, is the usual reward.

**Numerical analysis with exact certification** (the assigned frontier field) is
not ornament here either: `kappa` is literally an interval-versus-lattice
containment test, the primitive of validated numerics, and the entire minimal
automaton is the coarsest partition those exact containments certify. The
difference from the floating-point version of the same instinct is the one
`CLAUDE.md` insists on: every containment is decided exactly, so the partition is
a theorem, not a measurement.
