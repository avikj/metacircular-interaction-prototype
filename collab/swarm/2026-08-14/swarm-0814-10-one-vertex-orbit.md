# The root cage has exactly one vertex orbit — the step `cage.rs` takes without proof, proved

**Author:** swarm-0814-10, 2026-08-14.
**Object:** a theorem, machine-checked. `formal/cubical/Swarm/S10VertexOrbit.agda`,
`--cubical --guardedness --safe --no-import-sorts`, no postulates, no holes.

```
$ cd formal/cubical && LC_ALL=C.UTF-8 agda -i . Swarm/S10VertexOrbit.agda
Checking Swarm.S10VertexOrbit (...).
EXIT=0
```

---

## 0. The draw, and where the two lenses split

Drawn (uniform, 8): `runtime/atlas/charts.py`,
`notes/SHARP_CAGE_DOES_NOT_MAKE_DEGREE_TEN_TRACTABLE.md`,
`kernel/nodes/005-techniques.md`, `figures/exp31_product_carrier.png`,
`collab/discovery/channel_partition.py`, `runtime/vocabulary/propose.py`,
`collab/messages/vigil/20260812T150414Z-vigil-delta.md`,
`collab/upstream/raw/U0001.txt`. Rare corners (3):
`collab/discovery/events/R0010/20260811T193040Z-builder.json`,
`natural_machine_cpu_loop_rust/cage.rs`, `machinery/evolution/validator.py`.
Frontier field: random matrix theory. Ancient field: kolam / sona drawing.
Lenses: **Bourgain** — estimate everything, the estimate is the structure;
**Feynman** — sum over all the histories, including the absurd ones.

Two of the eleven are one object: `SHARP_CAGE_DOES_NOT_MAKE_DEGREE_TEN_TRACTABLE.md`
and the program `cage.rs` it reports. That note is the purest **Bourgain** artifact
in the draw. It answers a standing question (`CROSS_LENS` §6 item 5) with a single
number — the sharp cage buys $10^{0.92}$ against a gap of $10^{8}$ — and declares the
question dead. Nothing about the *structure* of degree ten is described; the estimate
is offered as the structure, and it is enough.

**Feynman disagrees at exactly one place, and it is a real place.** The note says:

> Each Vieta modulus majorant $|a_k|$ is an elementary symmetric function … a
> symmetric convex function of the log radii, hence **maximized at a vertex** of
> $\{B \le r \le A,\ \sum \log r = 0\}$.

The program does something else. `cage.rs`'s `vertex()` searches `for s in 0..m` and
`return`s on the **first feasible** $s$; `main` then reads **every** coefficient
bound off that one vertex, from the single product $\prod_k(1+r_kz)^2$. "Maximized at
a vertex" and "maximized at *this* vertex" are different statements: distinct convex
functions on a polytope are maximized at distinct vertices in general, and $e_1,\dots,e_{2m-1}$
are $2m-1$ different convex functions. Feynman's instruction — sum over all the
histories, take the max coordinatewise over every vertex, including the ones that look
absurd — is the correct procedure, and it is *not* what was run.

So: is the published majorant vector `[10, 51, 143, 258, 313, 259, 145, 52, 10]` a
majorant, or only a value?

## 1. The theorem

Work in log coordinates. A totally nonreal degree-$2m$ divisor with unit constant term
has $m$ conjugate pairs of radii with $\prod_k r_k = 1$; the cage $B \le r \le A$ with
$B \le 1 \le A$ makes the admissible log-radius set

$$\Delta_m(\alpha,\beta) \;=\; \Bigl\{x \in [\beta,\alpha]^m \;:\; \textstyle\sum_k x_k = 0\Bigr\},
\qquad \beta = \log B \le 0 \le \alpha = \log A .$$

A vertex pins $n := m-1$ coordinates at bounds — say $s$ at $\alpha$ and $u = n-s$ at
$\beta$ — and the last coordinate compensates: $c_s = -s\alpha - u\beta$. Feasibility is
$\beta \le c_s \le \alpha$. Writing $a = \alpha \ge 0$ and $b = -\beta \ge 0$ this is

$$\mathrm{Feas}(s,u)\;:\;\qquad s\,a \;\le\; (u+1)\,b \qquad\text{and}\qquad u\,b \;\le\; (s+1)\,a . \tag{F}$$

> **Theorem (one vertex orbit).** For every $n \ge 0$ and every $a,b \ge 0$:
>
> 1. **(existence)** some $(s,u)$ with $s+u=n$ satisfies (F);
> 2. **(degeneracy is forced)** if $(s,u)$ and $(s',u')$ both satisfy (F) with $s<s'$,
>    then $(s+1)\,a = u\,b$ — equivalently $c_s = \alpha$ and $c_{s+1} = \beta$;
> 3. **(converse)** if $(s+1)\,a = (u'+1)\,b$ then $(s,u'+1)$ and $(s+1,u')$ both satisfy (F);
> 4. **(dichotomy)** any two feasible indices are equal, or one of them is degenerate;
> 5. **(adjacency)** if moreover $a>0$, a second feasible index is $s+1$ and nothing else.
>
> Consequently the feasible set is $\{s\}$ or $\{s,s+1\}$, and in the second case the
> two indices name the multisets $\{\alpha^{s},\beta^{u},\alpha\}$ and
> $\{\alpha^{s+1},\beta^{u-1},\beta\}$ — **the same multiset** $\{\alpha^{s+1},\beta^{u}\}$.
> So $\Delta_m$ has exactly one vertex up to the $S_m$-action, every symmetric convex
> function on it is maximized there, and reading all $2m-1$ majorants off one feasible
> vertex is valid.

**Why it is true, in one sentence.** $c_s$ is arithmetic in $s$ with common difference
$-(\alpha-\beta)$ — *exactly* the width of the feasibility window $[\beta,\alpha]$ — so
the sequence can neither step over the window (existence) nor sit inside it twice
except by hitting both endpoints simultaneously (degeneracy).

**Formalized.** All five parts are `Cage.exists`, `Cage.degen`, `Cage.degen→both`,
`Cage.dichotomy`, `Cage.adjacent` in `formal/cubical/Swarm/S10VertexOrbit.agda`. Only
the ordered-abelian-group structure of the exponents is used, so ℕ constrains the
*scale* in which $\alpha,\beta$ are written, not the argument. The multiset coincidence
is the two substitutions displayed above and is stated, with its derivation, in the
module's closing comment rather than formalized — that is a deliberate line, drawn at
the point where a multiset library would cost more than the fact.

## 2. What it says about the drawn note — the answer is: the note is right, and it did not know why

Instantiate.

**Sharp cage $(A,B) = (\sqrt2,\varphi^{-1})$.** Two feasible indices would need
$A^{s+1}B^{\,n-s} = 1$, i.e. $2^{s+1} = \varphi^{2(n-s)}$ with $s+1 \ge 1$. If $n=s$ the
right side is $1$ and the left is $\ge 2$. If $n>s$ then
$\varphi^{2k} = \tfrac12\bigl(L_{2k}+F_{2k}\sqrt5\bigr)$ with $F_{2k}\ne0$ is irrational
while $2^{s+1}$ is rational. **No degeneracy at any degree**: the feasible index is
unique, `cage.rs`'s loop never had a choice, and the sharp column of the note's table is
a genuine majorant vector.

**Generic cage $(A,B) = (2,\tfrac12)$.** Degeneracy reads $s+1 = n-s$, i.e. $n = m-1$
odd, i.e. **$m$ even — degrees 4, 8 and 12.** At those degrees there really are two
feasible indices; `cage.rs` silently returns the first (at $m=4$: $s=1$ with
$c_1 = 2 = A$, while $s=2$ has $c_2 = \tfrac12 = B$). It is only part (2)+the multiset
coincidence that makes the choice immaterial. The note's generic column at degrees 4, 8
and 12 was therefore standing on an unproved step, and now is not.

**The asymmetry of the printed vector is explained, exactly.** `[10, 51, 143, 258, 313,
259, 145, 52, 10]` is not palindromic, and the note attributes its one-off disagreement
with `NONRECIPROCAL_DECIC_FRONTIER` (2.3) to "the coarser rational enclosure". The
asymmetry itself is not rounding. Since $\prod_k r_k = 1$, the reversal of
$\prod_k(1+r_kz)^2$ is $\prod_k(1+z/r_k)^2$, so $b_{2m-k}$ is $e_k$ at the **reciprocal**
radii. At the sharp degree-ten vertex $\{\sqrt2,\sqrt2,\varphi^{-1},\varphi^{-1},\varphi^2/2\}$:

$$b_1 = 2\bigl(2\sqrt2 + 2\varphi^{-1} + \tfrac{\varphi^2}{2}\bigr), \qquad
b_9 = 2\bigl(\sqrt2 + 2\varphi + 2\varphi^{-2}\bigr),$$

and $\tfrac12(b_9-b_1) = \tfrac{17-5\sqrt5}{4}-\sqrt2 > 0$ exactly, because
$196^2 = 38416 > 36992 = 2\cdot 136^2$. Both floor to $10$; at $k \in \{2,3,4\}$ the same
gap survives the floor and produces $51/52$, $143/145$, $258/259$. The vector is
asymmetric *because the cage is not reciprocal-symmetric*, and by exactly that amount.

## 3. Corollary: the free sharpening is vacuous, and provably so

The reversal $q^*(x) = x^{2m}q(1/x)$ has $|a_{2m-k}(q)| = |a_k(q^*)|$ and root radii in
$[1/A,1/B]$ with product $1$ — no closure hypothesis on the admissible class is needed,
only that reversal is a bijection on coefficient vectors. So the cage $(1/B,1/A)$ gives a
second, free bound $b'_k$ on every coefficient, and one expects
$\min(b_j,\, b'_{2m-j}) < b_j$ somewhere. Reciprocation sends $x \mapsto -x$ on log
radii, i.e. $(a,b) \mapsto (b,a)$, and under that swap the two halves of (F) exchange
places **verbatim**:

$$\mathrm{Feas}_{a,b}(s,u) \;\cong\; \mathrm{Feas}_{b,a}(u,s), \qquad (p,q)\mapsto(q,p).$$

By the Theorem each side has one vertex orbit, so these are the same orbit reciprocated,
hence $b'_k = b_{2m-k}$ and $\min(b_j,b'_{2m-j}) = b_j$. **Reciprocation buys nothing.**
(`reciprocal`, `reciprocal-involutive` in the module; the proof is the swap map and
`refl`.) This is the Feynman move — sum over the reciprocal history too — completed and
returning null, which is a result and not a failure: it forecloses the one cage-side
improvement that was still free, and it does so without a single new computation.

Combined with the drawn note's own arithmetic: the cage direction is now **closed from
both sides**. Tightening the box is worth $10^{0.92}$ (the note); reciprocating it is
worth $10^{0}$ (here). Item 5 of `CROSS_LENS` §6 should be struck for the reason the note
gives, and the successor idea "well then also use the reciprocal cage" should be struck
before anyone spends a run on it.

## 4. Two files in my draw I cannot read, and one that reads itself as unreadable

`figures/exp31_product_carrier.png` (468009 bytes) is binary. I have no way to see it
without Python, and `MATH_ALLOW_PYTHON=1` exists so in-flight work is never destroyed,
not so a data file can be opened. **I did not read it and I have invented nothing about
it.** No note in my draw claims anything about its contents, so there is not even a
claim to hold against it; what I can say is the structural point, which belongs in the
object: a `.png` in `figures/` is, under this repository's own rule, a measurement whose
error term is not merely underived but *unstatable* by a reader — and the repository
has 660 legacy `.py` files and a hook that forbids the only tool that could open it. The
gap between "the figure exists" and "the figure is checkable" is total, and permanent.

`collab/upstream/raw/U0001.txt` is the exact opposite failure and is *honest* about it.
Its entire content is

> `see opportunity in tension, take the idea …50 tokens truncated… 15 years in monastary meditating/studying`

— an upstream directive that ships its own truncation marker, catalogued as
`"completeness":"partial"` with `"truncation"` naming the harness. `collab/upstream/README.md`
adds: *"Missing text is not reconstructed."* That is the correct discipline and it is the
same discipline as the `.png`: a record that says exactly how much of itself is missing is
worth more than a record that looks complete. The difference is that U0001 has a
`body_sha256` over the bytes that *do* exist, and the figure has nothing. Contrast is
deliberate: this is what `machinery/evolution/validator.py` enforces mechanically
(`_reject_float`, canonical JSON, framed hashes) for genome records and what
`figures/` enforces for nothing.

I note without resolving it that the first sentence of the highest-ranked document in the
repository is, in the only form available to any agent, unreadable — and that this is
recorded rather than papered over.

## 5. Contradictions and tensions with the repository's conspicuous documents

1. **`cage.rs` vs its own note (resolved here).** The note's stated argument
   ("maximized at a vertex") is strictly weaker than what the program computes ("this
   vertex"). At degrees 4, 8, 12 in the generic cage the gap is inhabited by an actual
   second feasible index. The note's numbers survive; its argument, as written, did not
   entail them. This is the third documented instance in the corpus of the same shape:
   *a correct prohibition/computation defended by a reason that does not reach it*
   (compare `method_lenses.txt`, swarm-0814-15's entry).

2. **`CLAUDE.md` "Python is banned" vs. eight of my eleven drawn files.** Four drawn
   files are `.py` (`charts.py`, `channel_partition.py`, `propose.py`, `validator.py`)
   and one is a `.png` that only Python can read. The ban is real and I obeyed it. But
   `runtime/atlas/charts.py` is 1450 lines of *exact, float-free, deterministic*
   construction that ends with an exhaustive contractibility check and an S_n-torsor —
   which under CLAUDE.md's own operative test ("exact / certified symbolic computation
   **is** proof") is not the thing the ban targets. The ban is enforced by file
   extension; the rule it enforces is about exactness. Those two are not the same
   predicate, and `charts.py` is the standing witness that they diverge. I am not asking
   for the ban to be relaxed — it is mechanical for good reasons — only recording that
   the mechanism and the principle have different extensions, and `charts.py` sits in
   the difference.

3. **`kernel/nodes/005-techniques.md` is falsified by this note, in the smallest possible
   way.** Its eight-entry library is declared "empirically sufficient for every
   structural law this repository produced". The theorem above is none of Stirling,
   explicit formula, stationary phase, Mellin–Laplace, integral-domain/UFD, standard
   asymptotics, Tauberian transfer, or sampling theory. It is **convex geometry of a
   transportation polytope / an exchange argument on a bounded simplex slice** — one line
   of monotone arithmetic. Node 005 says "library growth is itself a derivation: adding an
   entry is an ordinary node", so this is that derivation, submitted: the drawn note
   itself *invokes* the missing technique ("a symmetric convex function … maximized at a
   vertex") while the library that is supposed to cover the corpus does not list it.

4. **`collab/discovery/channel_partition.py`, read against my own result.** It tests
   whether audit channels are exchangeable, and warns it "cannot distinguish 'caught by
   channel X' from 'written up citing X'". This finding is a datum for that test with the
   ambiguity absent: the gap in `cage.rs` was caught by neither same-lineage nor
   cross-lineage audit but by **exact computation forced by a uniform random draw** — the
   `exact` channel, arrived at through a mechanism (`why_this_exists.md`) that is outside
   every channel the script enumerates. If SS1 is to be tested honestly, `CHANNELS` needs a
   sixth signature for the seeder, because the seeder is not an audit channel and it
   produced an audit result.

5. **Upstream U0013 vs `notes/COGNITIVE_ORIENTATION.md` §8** — the standing conflict named
   in my brief. Nothing in my object bears on it. Recorded so the ledger is complete.

## 6. Rigor boundary

**Proved and machine-checked:** parts (1)–(5) of the Theorem and the reciprocation
corollary, over ℕ, in `--safe` cubical Agda, no postulates, no holes, `EXIT=0`.

**Proved on paper, in this note, not formalized:** the multiset coincidence in the
degenerate case (two substitutions); the sharp cage's non-degeneracy at every degree (via
irrationality of $\varphi^{2k}$); the generic cage's degeneracy exactly at even $m$; the
sign of $b_9 - b_1$ at degree ten (an exact inequality between algebraic numbers, reduced
to $38416 > 36992$).

**Consumed, not re-derived:** that $e_k$ is convex in the log radii and $S_m$-invariant
(the drawn note's premise, and standard); the cage (1.1) of
`NONRECIPROCAL_DECIC_FRONTIER`; the published census counts; the drawn note's box volumes.

**Not claimed:** that the majorant vectors are *tight*; that any of this makes degree ten
tractable — it does not, and the drawn note's verdict stands unchanged and is now better
founded; any novelty against the literature (the vertex structure of
$\{x\in[\beta,\alpha]^m : \sum x = 0\}$ is elementary transportation-polytope geometry and
should be assumed known, though I found no prior statement of it *in this repository*).

**Not run:** any experiment, any fitted quantity, any Python. Zero measurements were
taken. The only numbers in this note are exact integers, exact algebraic comparisons, or
quotations from the drawn note.

**Provenance.** I did not choose this problem; a uniform draw did, and it handed me the
program and the note that describes it in the same envelope. That is the mechanism working
exactly as `why_this_exists.md` says it should.
