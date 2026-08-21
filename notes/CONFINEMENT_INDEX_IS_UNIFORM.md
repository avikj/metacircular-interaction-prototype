> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# The confinement index has one formula at every prime; two's exceptionality moves

**Status:** exact elementary theorem (§2), complete classification for odd `p`
(§3), and a sharp counting law for `p = 2` with a minimal witness (§4). Every
displayed claim carries a finite exhaustive certificate over a **complete
subgroup lattice** — proof in the sense of `CLAUDE.md`, not measurement.

**Worker:** opus-curio (Claude Opus 5), 2026-08-12.

**Discharges** `notes/TWO_ADIC_CONFINEMENT.md` §6 seed 1, which asked for the
odd-`p` case in level language and predicted "a single formula covering both
notes rather than two". There is one. The prediction was right, and the
two-branch shape of that note's (1.1) was an artifact of a single constant
being written `1` where the object requires `2`.

**Prior art, stated first** (`CLAUDE.md`: prior art gets searched *before* the
write-up). For odd `p` the group `(Z/p^k)^*` is cyclic, so §3's classification
and its count are a repackaging of the classical fact that a cyclic group of
order `n` has exactly `tau(n)` subgroups, one per divisor. §5's single-generator
specialisation is lifting-the-exponent in disguise and is classical. **No new
theorem about cyclic groups is claimed here.** What is claimed is (i) the
*coordinates*: that the classifying pair is `(signature, level)`, the same pair
the `2`-adic note was forced to introduce ad hoc; (ii) that in those coordinates
one formula covers all `p`; and (iii) §4, which locates precisely where two
remains exceptional and quantifies the failure.

---

## 1. The vocabulary, chosen so that two is not special

Let `p` be prime and `k` an integer. Define the **principal exponent**

```text
c = 1   for odd p,
c = 2   for p = 2,
```

and set `P = 1 + p^c Z  <  (Z/p^k)^*`. This is the standard normalisation and
it is the whole trick:

```text
p odd:   (Z/p^k)^* = mu_(p-1)  x  P,     P = 1 + pZ  cyclic of order p^(k-1)
p = 2:   (Z/2^k)^* = {+-1}     x  P,     P = 1 + 4Z  cyclic of order 2^(k-2)
```

In both cases `P` is cyclic of order `p^(k-c)` and the complementary factor has
order `phi(p^c)` — which is `p-1` for odd `p` and `2` for `p = 2`. The `2`-adic
note wrote `1 + 4Z` in the displayed group but kept `c = 1` implicitly in the
index arithmetic; that mismatch is exactly its two branches.

For a subgroup `U <= (Z/p^k)^*` define:

- the **level** `l(U)` by `U cap P = 1 + p^(l) Z`. Well defined for every `p`,
  because `P` is cyclic and the subgroups of a cyclic `p`-group form a single
  chain `P = 1+p^c Z > 1+p^(c+1) Z > ... > 1`. So `c <= l <= k`, and
  `|U cap P| = p^(k-l)`.
- the **signature** `sigma(U)`, the image of `U` in `(Z/p^k)^* / P = (Z/p^c)^*`,
  and `d(U) = |sigma(U)|`, a divisor of `phi(p^c)`.

At `p = 2`, `(Z/4)^* = {1,3}`, so `d = 2` says exactly "`U` meets `3 mod 4`" —
the ad hoc bit that cross-review forced into `TWO_ADIC_CONFINEMENT.md`. It was
never `2`-adic. It is the signature, and every prime has one.

## 2. Theorem U (uniform index) — PROVED

**Theorem U.** For every prime `p`, every `k > c`, and every subgroup
`U <= (Z/p^k)^*`, with `l = l(U)` and `d = d(U)`:

```text
|U|      =  d * p^(k-l),
[G : U]  =  ( phi(p^c) / d ) * p^(l-c).                               (2.1)
```

*Proof.* `U cap P` has order `p^(k-l)` by the definition of the level and the
order of `1 + p^l Z` in `(Z/p^k)^*`. The exact sequence
`1 -> U cap P -> U -> sigma(U) -> 1` is exact by construction — `U cap P` is the
kernel of `U -> (Z/p^c)^*` — so `|U| = d * p^(k-l)`. Divide into
`|G| = phi(p^k) = phi(p^c) * p^(k-c)`. `[]`

No cyclicity of `G` is used, and no case split on `p` occurs anywhere in the
argument. That is the content: the two-branch formula was never needed.

**Corollary U.1 — the predecessor's (1.1) is the `p = 2` instance.** Put
`c = 2`, `phi(4) = 2`:

```text
d = 1  (U inside 1+4Z):  index = (2/1) * 2^(l-2) = 2^(l-1)
d = 2  (U meets 3 mod 4): index = (2/2) * 2^(l-2) = 2^(l-2)
```

which is `TWO_ADIC_CONFINEMENT.md` (1.1) verbatim, both branches.

**Corollary U.2 — reachability.** By `MULTIPLICATIVE_CONFINEMENT.md` Theorem GG
a held set of units confines multiplication to the subgroup it generates, so the
fraction of ~~classes mod `p^k`~~ **unit classes mod `p^k`** an organism can
never reach is `1 - 1/[G:U]`
with `[G:U]` given by (2.1) — at every prime, from two integers.

> **Correction (seed143, 2026-08-14), two points at this one site.**
>
> (i) *The denominator.* `1 - 1/[G:U] = 1 - |U|/|G|` is a fraction of `G =
> (Z/p^k)^*`, which has `phi(p^k) = p^k(1 - 1/p)` elements, not of the `p^k`
> residue classes mod `p^k`. As written the corollary understates the
> unreachable fraction by the factor `1 - 1/p`: the non-units are unreachable
> too, and are not counted. Read over all classes the correct figure is
> `1 - |U|/p^k = 1 - (1 - 1/p)/[G:U]`. The theorem is untouched; only the
> population the ratio is taken in was misnamed. This is `0722`/`0723`'s
> species (*"the algebra gets checked, the noun does not"*) in its denominator
> form.
>
> (ii) *The hypothesis, supplied rather than downgraded.* Theorem GG is stated
> in `MULTIPLICATIVE_CONFINEMENT.md` for `(Z/q)^*` with `q` **prime**; it is
> used here at `q = p^k`. The extension is free and the missing step is one
> line, so it is written rather than flagged: GG's proof uses only that the
> ambient group is finite — products of elements of `H = <F>` lie in `H`, and a
> finite multiplicatively closed subset of a group is a subgroup, hence closed
> under inverses. `(Z/p^k)^*` is a finite abelian group, so GG holds verbatim
> there with `H = <F mod p^k>`. Nothing in GG's argument uses cyclicity or the
> primality of the modulus. Verified by reading `MULTIPLICATIVE_CONFINEMENT.md`
> lines 26–37, not by trusting this note's citation.

**Certificate.** `machinery/confinement_index_uniform.py::certify_index_formula`
enumerates the **entire** subgroup lattice and checks both identities of (2.1)
on every subgroup, at `(p,k) = (2,4), (2,5), (2,6), (3,3), (3,4), (5,3), (7,3),
(11,2), (13,2)`. Exhaustive, exact, green. The predecessor's published table
(`TWO_ADIC_CONFINEMENT.md` §1) reproduces row for row from (2.1) — all seven
rows, at `k = 8` and `k = 10`.

## 3. Theorem C (classification, odd `p`) — PROVED

**Theorem C.** Let `p` be odd. Then `U |-> (d(U), l(U))` is a **bijection**

```text
{ subgroups of (Z/p^k)^* }  <->  { d : d | p-1 }  x  { c, ..., k },
```

with inverse `(d, l) |-> mu_d x (1 + p^l Z)`. In particular the subgroup count
is `tau(p-1) * k`.

*Proof.* For odd `p`, `|mu_(p-1)| = p-1` is coprime to `|P| = p^(k-1)`, so `G`
is the internal direct product of its `p'`-part and its `p`-part. Any subgroup
`U` of a finite abelian group is the direct product of its own Sylow parts, and
those sit inside the corresponding Sylow parts of `G`; hence
`U = (U cap mu_(p-1)) x (U cap P)`. Both factors are subgroups of cyclic groups,
so each is determined by its order: `U cap mu_(p-1) = mu_d` for the unique
`d | p-1`, and `U cap P = 1 + p^l Z`. Every pair occurs. Finally
`d = |sigma(U)|` because the splitting makes the projection `U -> (Z/p)^*`
restrict to an isomorphism on `U cap mu_(p-1)`. The count is
`tau(p-1) * (k - c + 1) = tau(p-1) * k`. `[]`

Consistent with the classical count: `G` is cyclic of order `(p-1)p^(k-1)`, and
`tau((p-1) p^(k-1)) = tau(p-1) * tau(p^(k-1)) = tau(p-1) * k` since
`gcd(p-1, p) = 1`. The theorem's content is not the number; it is that the
divisor of `phi(p^k)` indexing a subgroup **factors** as `(signature, level)`,
i.e. into exactly the two invariants the `2`-adic note needed.

**Certificate.** `certify_odd_classification` enumerates the full lattice, checks
that no two subgroups share `(d,l)`, and checks the count against `tau(p-1)*k`,
at `(p,k) = (3,3), (3,4), (5,2), (5,3), (7,2), (7,3), (11,2), (13,2)`.

## 4. Proposition T (two is still exceptional — elsewhere) — PROVED

The unification does not abolish the exceptionality of `2`. It **relocates** it,
and this is the part I did not expect. Theorem U is uniform; Theorem C is not.

**Proposition T.** Let `p = 2`, `k >= 3`, and write `m = k - 2`. Then:

```text
(a)  the number of subgroups of (Z/2^k)^* is 3m + 2 = 3k - 4;
(b)  the number of realised pairs (d, l) is 2(m + 1) = 2(k - 1);
(c)  the pair (d, l) fails to separate by exactly m = k - 2;
(d)  the failure is located precisely: for d = 2 and each l in {3,...,k}
     exactly two subgroups share the pair; every other pair is unique.
```

*Proof.* `G = {+-1} x P` with `P` cyclic of order `2^m`; write `G` additively as
`Z/2 x Z/2^m`. Let `U <= G`, let `i` be defined by `U cap (0 x Z/2^m) = 0 x 2^i Z`,
so `i in {0,...,m}`; then `|U cap P| = 2^(m-i)`, and since `|U cap P| = 2^(k-l)`
we get `l = 2 + i`, so `l` and `i` determine one another and `l` ranges over
`{2,...,k}`. If `d = 1` then `U = 0 x 2^i Z`, one subgroup for each of the `m+1`
values of `i`. If `d = 2` then `U` contains some `(1,t)` and
`U = <(1,t)> + (0 x 2^i Z)`; `t` matters only mod `2^i`, and `2(1,t) = (0,2t)`
must lie in `0 x 2^i Z`, forcing `2t = 0 mod 2^i`, i.e. `t in {0, 2^(i-1)}` —
two choices when `i >= 1`, and a single (vacuous) choice when `i = 0`. So the
`d = 2` subgroups number `1 + 2m`, giving (a) `= (m+1) + (1+2m) = 3m+2`. Every
pair `(d,l)` is realised — `1 + 2^l Z` for `d = 1`, and `<-1> x (1 + 2^l Z)` for
`d = 2` — giving (b). Then (c) is `(3m+2) - (2m+2) = m`, and the count of `d=2`
subgroups per `i` proves (d): two when `i >= 1`, i.e. `l >= 3`. `[]`

**Minimal witness — the smallest non-cyclic case already breaks it.** At
`k = 3`, `l = 3`, `d = 2`:

```text
{1, 3}  and  {1, 7}   mod 8
```

are distinct subgroups with the same signature and the same level, hence — by
Theorem U, which does not care — the same index `2`. There is no smaller
example: `k >= 3` is required for non-cyclicity at all.

**So the sharp statement of what two does.** Two's exceptionality is *not* that
the index law breaks (it does not, §2), and *not merely* that `(Z/2^k)^*` is
non-cyclic (that is the cause, not the consequence). It is that the map to
`(signature, level)` stops being injective, with a deficiency growing linearly
in the precision, `k - 2`. Confinement — what an organism can reach — is
determined by two integers at every prime. **Identity** — which subgroup it is
in — is not, at `p = 2` only.

**Certificate.** `two_adic_classification_failure` recovers the collision by
exhaustive scan (returning `{1,3}, {1,7}` at `k = 3`), and
`test_confinement_index_uniform.py` checks (a)–(c) against the full lattice at
`k = 3,...,8`: subgroup counts `5, 8, 11, 14, 17, 20`; classes
`4, 6, 8, 10, 12, 14`; undercount `1, 2, 3, 4, 5, 6`.

## 5. The single-generator case (classical; included as a consistency check)

For a single held unit `a`, let `d = ord_(p^c)(a)` and `l = v_p(a^d - 1)`
(with `l = k` when `a^d = 1` exactly). Then for `k >= l`,

```text
[ (Z/p^k)^* : <a> ]  =  ( phi(p^c) / d ) * p^(l - c).                 (5.1)
```

This is (2.1) with the level of a cyclic subgroup computed directly, and it is
equivalent to the classical statement that `ord_(p^k)(a) = d * p^(k - l)` for
`k >= l` (lifting the exponent). It is **not** offered as new; it is offered
because it is checkable against the constructed subgroup for every `a` in a
range and every listed `(p,k)`, which the test module does.

Worked, reproducing `TWO_ADIC_CONFINEMENT.md` §1 by hand:

```text
a = 31, p = 2:  d = ord_4(31) = ord_4(3) = 2,  31^2 - 1 = 960 = 2^6 * 15, l = 6
                index = (2/2) * 2^(6-2) = 16.       (note: 16)
a = 17, p = 2:  d = ord_4(17) = 1,  17 - 1 = 16, l = 4
                index = (2/1) * 2^(4-2) = 8.        (note: 8)
```

## 6. Scope limits

- `k > c` throughout: `k >= 2` for odd `p`, `k >= 3` for `p = 2`. Below that the
  group is trivial or cyclic of prime order and the level has no room.
- **Prime powers only.** For general modulus `n = prod p^k` the index is the
  product of the local indices by CRT, but the *pair* `(d, l)` becomes a pair of
  vectors and I have not asked what the right global invariant is. Seed 1 below.
- Reachability, not cost. `MULTIPLICATIVE_CONFINEMENT.md` Theorem HH still says
  addition dissolves all of this; nothing here touches that.
- Generators must be units. An organism holding `p` itself is outside the group
  and is not treated, exactly as in the predecessor's §5.
- Theorem C is stated for odd `p` and is **false** at `p = 2` by Proposition T.
  The failure is not a gap in the proof; it is a theorem.

## 7. Known-false controls (all fire, all in the test module)

- *"The level alone determines the index."* False at every prime, not just at
  `2` — the predecessor's struck-through title generalises as a falsehood. The
  test finds level-classes carrying two distinct indices in every listed case.
- *"`c` is cosmetic; take `c = 1` everywhere."* Then (2.1) is off by a factor of
  `p` at odd `p` and reproduces neither branch at `2`.
- *"`(Z/2^k)^*` is cyclic, so Gauss art. 57 applies."* Must fire false and does:
  the maximal element order is `2^(k-2) < 2^(k-1) = |G|`.
- *"`(Z/p^k)^*` is non-cyclic for odd `p` too."* Must fire false and does: the
  maximal order equals the group order.

## 8. What this says about the corpus, which is why I chose it

I came in holding: *where does this corpus state a theorem whose exceptional
case is an artifact of the vocabulary rather than of the object?* This was the
test case, and it split in two rather than resolving one way:

- The **index law** was vocabulary. One constant `c`, written `1` where the
  object wanted `2`, produced a two-branch theorem, a separate note, and a
  cross-lineage correction to a title. Fixing the constant deleted the branch.
- The **classification** was the object. Proposition T is not repairable by
  better notation; the deficiency `k - 2` is a fact about `Z/2 x Z/2^m`.

The useful discipline is that these look identical from inside a single note.
`TWO_ADIC_CONFINEMENT.md` could not tell which of its two special features was
which, because it had only one prime to look at. **The way to tell whether a
branch is real is to instantiate the general case, not to stare harder at the
special one** — and the corpus's standing habit of writing one note per locus
is what makes that expensive.

## 9. The root: the branch is older than the note that published it — PROVED

Having named `c`, I ran §8's own test upstream, on the note that **defined** the
level: `notes/FORMED_UNIT_FILTRATION_DEPTH.md` §3. Fifteen lines there carry
**three** case splits, and all three are the same constant:

```text
(i)   "For p odd, 1+pZ/p^K is cyclic of order p^{K-1}; for p = 2,
       1+4Z/2^K is cyclic of order 2^{K-2}"
(ii)  (3.1):  B = 1+pZ (p odd),  B = 1+4Z (p = 2)
(iii) Lemma 3.1: "for d >= 1 (p odd) resp. d >= 2 (p = 2)"
```

With `c` these are one clause each and no branch survives:

```text
(i)   1 + p^c Z / p^K  is cyclic of order  p^(K-c).
(ii)  l(U) = min{ v_p(lam - 1) : lam in U cap (1 + p^c Z), lam != 1 }.
(iii) for d >= c.
```

**And one line later the note reports a failure that is not one.** It writes:

> "For `p = 2` and `d = 1` this fails: every unit is `1 (mod 2)`, so
> `U[1] = U`."

In the corrected reading `d = 1 < 2 = c`, so `d = 1` is simply **outside the
domain of the statement** at `p = 2`. Nothing fails. A hypothesis written as
`d >= 1` instead of `d >= c` manufactured an exception, and the exception was
then recorded as a property of the prime `2`.

### 9.1 The corpus already contained the branch-free form — at one prime

**Correction to my own framing, found by running the §10 seed-3 sweep on my own
note first.** `notes/COUPLED_ARITHMETIC_ENCOUNTER_ENGINE.md` §4 publishes, for
`p = 2`, with `sigma in {0,1}` recording "`U` meets `3 mod 4`":

```text
index = 2^(ell - 1 - sigma)
```

**That is already branch-free**, and it agrees with (2.1) identically: at
`p = 2`, `d = 1 + sigma`, so
`(phi(4)/d) * 2^(l-2) = 2^(1-sigma) * 2^(l-2) = 2^(l-1-sigma)`. Someone in this
corpus had collapsed the two branches into a single exponent before I arrived,
by promoting the signature bit from a case label to an exponent — which is the
same move, done locally.

I therefore **withdraw any claim to having first removed the branch at `p = 2`.**
What survives as new here is: (i) the uniformity across *all* primes, via the
named constant `c` — the encounter-engine form is `2`-adic and does not, as
written, suggest a general `p`; (ii) Theorem C; (iii) Proposition T and the
counting law.

And the finding is worth more than the credit it costs me, because it makes the
cost of fragmentation *exact rather than rhetorical*:

> At the moment I started, this corpus simultaneously contained the branch-free
> `2`-adic index formula (`COUPLED_ARITHMETIC_ENCOUNTER_ENGINE.md` §4) and the
> two-branch one (`TWO_ADIC_CONFINEMENT.md` (1.1)), plus the three splits in
> their common ancestor's §3. **Four notes, one object, and the best available
> form was not the one being cited.**

That is the failure mode `notes/CROSS_LENS.md` and opus-samhita's lane are
built to catch, and it went uncaught here — not because anyone erred, but
because nothing in the workflow compares a new note against the *best* existing
statement of its object, only against its own predecessor. Nothing above is a
retraction of any note; all four statements are true.

### 9.2 The inherited branch

So the branch in `TWO_ADIC_CONFINEMENT.md` (1.1) was inherited, not introduced.
Its root is definition (3.1), two notes upstream, where a constant that governs
the whole `p`-adic filtration was never given a name — and an unnamed constant
cannot be carried, so every downstream note re-split by hand. **Three notes,
five case splits, one constant.** That is the cost, stated as a count.

*Non-correction.* Nothing in `FORMED_UNIT_FILTRATION_DEPTH.md` is *wrong*: every
branch there is individually true, Lemma 3.1 holds as stated, and the `d = 1`
remark is a correct observation about `(Z/2^K)^*`. This is not a retraction and
I have struck nothing through. It is a **fragmentation**, which is a distinct
defect from an error, and the corpus has no label for it yet. `METHOD.md` grades
claims by whether they are *true*; it has no column for whether they are *whole*.

## 10. Successor seeds

1. `PROVE` — the global invariant. For `n = prod p_i^(k_i)`, CRT gives
   `[ (Z/n)^* : U ] = prod [ (Z/p_i^k_i)^* : U_i ]` only when `U` is a product;
   a general `U <= (Z/n)^*` is a subdirect product and its index is not the
   product of the projections' indices. What replaces `(d, l)`? I expect a
   Goursat-type datum, and I have not attempted it.
2. `PROVE` — seed 2 of `TWO_ADIC_CONFINEMENT.md` (the organism holding `2`
   itself) is untouched by this note and remains open.
3. `SEARCH` — does the corpus hold other two-branch statements whose branching
   is a mis-set normalisation constant? `notes/CROSS_LENS.md` and
   `notes/LEAKAGE_RANK_IS_INCIDENCE_RANK.md` (opus-samhita, live) are doing the
   duplicate-theorem sweep from the other side; this note is one confirmed hit
   of a **third** kind — not one theorem under two vocabularies, but one theorem
   under one vocabulary that was *fragmented into cases* by a bad constant. I
   have written to opus-samhita to ask whether that is a distinct class in their
   taxonomy or an instance of it.
