# The q = 2 analogue of W3 is a collapse: blindness at 2 reads only e₋

**2026-08-14.** Executes `HEAD_DEPTH_BLINDNESS` seed 2 (restated as
`HEAD_DEPTH_MERGE` successor seed 2), the last untouched seed of that
note: the $q=2$ analogue of Theorem W3, where the cyclotomic head is the
two-entry pair $(e_-,e_+)=(v_2(b-1),\,v_2(b+1))$ of `CYCLOTOMIC_SENSOR`
eq. (2).

Substrate: `formal/cubical/HeadDepthTwo.agda`, `--cubical --safe`, no
postulates, no holes, exit 0 standalone in 2.4 s under the pinned
toolchain (Agda 2.6.3 + cubical v0.5), mirroring
`HeadDepthMerge.agda`'s computational style (`Agda.Builtin.Nat`
primitives, `refl` certificates).

## 1. The seed expected a two-parameter statement. It does not exist.

`HEAD_DEPTH_BLINDNESS` seed 2 reads: *"The two-entry head $(e_-,e_+)$
should correspond to a two-parameter blindness statement."* The seed
dissolves, and the dissolution is itself the theorem. The whole content
is one parity:

> the Fermat exponent at modulus $2^a$ is $2^a-1$, which is **odd**.

`CYCLOTOMIC_SENSOR` eq. (2) says, for odd $b$:
$$
  v_2(b^m-1)=
  \begin{cases}
    e_-, & m\text{ odd},\\
    e_-+e_++v_2(m)-1, & m\text{ even}.
  \end{cases}
$$
Only the odd branch can ever fire on the Fermat exponent of an even
modulus, and the odd branch reads $e_-$ alone. So $e_+$ **never
enters**, and the analogue of W3 is a one-parameter collapse:

> **Theorem W3₂.** Let $b$ be odd and $a\ge1$. Then
> $$b\text{ fails to refute }2^{a}\text{ by the Fermat test}
>   \iff e_-\ge a \iff b\equiv1\pmod{2^{a}},$$
> and consequently, for odd $b\ge3$,
> $$\boxed{\,e_- \;=\; v_2(b-1)\;=\;\max\{a: b\text{ is blind on }2^{a}\}\,.}$$

Two one-line proofs, one per organ.

*Proof (group; no LTE needed).* Blindness means
$b^{2^a-1}\equiv1\pmod{2^a}$, so $\operatorname{ord}(b)$ in
$(\mathbb Z/2^a)^\times$ divides the odd number $2^a-1$; but the group
has order $2^{a-1}$, a $2$-power, so the order is $1$ and $b\equiv1$.
Conversely $1^{2^a-1}=1$. $\square$

*Proof (sensor).* Blindness $\iff v_2(b^{2^a-1}-1)\ge a$; the exponent
is odd, so eq. (2) gives $v_2(b^{2^a-1}-1)=e_-$; and $e_-\ge a\iff
2^a\mid b-1$. $\square$

The case $a=1$ is vacuous exactly as at odd $q$: $2$ is prime, every
odd $b$ is blind on it, and $e_-\ge1$ always. Content begins at $a=2$:
$b$ is blind on $4$ iff $b\equiv1\pmod4$.

## 2. Why the dissolution is a result, not a disappointment

The seed's hope was reasonable: `CYCLOTOMIC_SENSOR` Theorem 4 shows the
head at $2$ is genuinely two entries long, forced by the torsion element
$-1\in U_1$. The dissolution locates *exactly* why that anomaly does
not propagate into the blindness organ:

- **$e_+$ lives on even exponents.** By Theorem 3 there, $e_+$ is the
  chain entry at $\Phi_2(b)=b+1$, and it contributes to $v_2(b^m-1)$
  only when $2\mid m$.
- **Every even modulus has an odd Fermat exponent.** $n$ even $\implies$
  $n-1$ odd. So no Fermat-type anatomy at *any* even modulus — not just
  prime powers of $2$ — can read $e_+$.
- Sharper, in one sentence: the head is two entries long because the
  involution $-1$ has order $2$, and an odd exponent fixes $-1$
  ($(-1)^{\text{odd}}=-1\ne1$), so the very torsion that lengthens the
  head can never masquerade as $1$ under a Fermat exponent. The
  exception of LTE at $p=2$ and its invisibility to the Fermat test are
  the same fact about $-1$.

So the boxed dictionary of W3 — *head depth $=$ blindness depth* —
survives at $q=2$ only after truncating the head to its first
coordinate. $e_-$ keeps its operational meaning; $e_+$ is a different
observable, sensed by even exponents (e.g. $v_2(b^2-1)=e_-+e_+$) and
invisible to this organ entirely.

Kernel witnesses of the invisibility (both `refl`):

- bases $3$ and $7$: same $e_-=1$, different $e_+$ ($2$ vs $3$),
  **identical** blindness columns for all $a\le8$
  (`ePlusInvisible-3-7`);
- base $255\equiv-1\pmod{256}$: the maximal second entry in range,
  $e_+=8$, yet $e_-=1$ and blind only at the vacuous depth $a=1$
  (`deepPlusNotBlind-255`). A deep $\Phi_2$-head buys no blindness at
  all.

## 3. The strong test at 2^a degenerates before arithmetic starts

Write $n=2^a$, $n-1=2^s d$ with $d$ odd. Then $s=v_2(2^a-1)=0$: the
Miller–Rabin window $\{b^{2^rd}\equiv-1 : 0\le r<s\}$ is **empty**, and
the strong test *is* the Fermat test by the shape of its definition —
`strongBlind` and `fermatBlind` coincide syntactically, before any
group theory. (Miller–Rabin as usually stated presupposes $n$ odd; at
even $n$ its formula degenerates exactly like this.) So

> strong blindness on $2^a$ $\iff$ Fermat blindness on $2^a$ $\iff$
> $b\equiv1\pmod{2^a}$,

which closes the $q=2$ case of `HEAD_DEPTH_MERGE` §2 trivially — at odd
prime powers the strong=Fermat collapse needed cyclicity and the unique
involution; at $2^a$ it needs only $s=0$. Both the collapse and its
reason ($v_2(2^a-1)=0$) are certified separately
(`strongCollapseTheorem`, `sZeroTheorem`).

## 4. W4 survives verbatim, with one word deleted

> **Corollary W4₂.** $\{b\bmod 2^a : b\text{ blind on }2^a\}$ is the
> unique subgroup of order $q-1=1$ — the trivial group $\{1\}$ — of
> index $q^{a-1}=2^{a-1}=\varphi(2^a)$: a fraction $2^{1-a}$ of bases
> is blind at depth $a$.

W4's index formula $q^{a-1}$ and subgroup order $q-1$ continue to
$q=2$ without change; only the word "cyclic" must be dropped from its
proof ($(\mathbb Z/2^a)^\times$ is not cyclic for $a\ge3$), and
uniqueness of the *trivial* subgroup needs no cyclicity. Certified as
`blindCountTwo a ≡ 1` for all $a\le8$ (`w4TwoTheorem`).

## 5. Kernel certificates

All in `formal/cubical/HeadDepthTwo.agda`, over **all odd $b<256$, all
$1\le a\le8$** (1024 pairs), each a checked term by `refl` — finite
exhaustive verification is proof (`CLAUDE.md`):

| term | statement on the range |
|---|---|
| `w3TwoTheorem` | Fermat-blind on $2^a$ $\iff a\le e_-$ |
| `residueTheorem` | Fermat-blind on $2^a$ $\iff b\equiv1\pmod{2^a}$ |
| `strongCollapseTheorem` | strong-blind $\iff$ Fermat-blind |
| `sZeroTheorem` | $v_2(2^a-1)=0$ for $1\le a\le8$ |
| `w4TwoTheorem` | exactly one blind residue mod $2^a$, $1\le a\le8$ |
| `ePlusInvisible-3-7`, `ePlus-255`, `eMinus-255`, `deepPlusNotBlind-255` | the dissolution witnesses of §2 |

## 6. Rigor boundary

- **Kernel-checked:** every row of the table above, on the declared
  finite range. The module is exit 0 standalone; `Everything.agda`
  currently fails on this container for a pre-existing reason unrelated
  to this landing (`NaturalMachine/PathIsSymmetry.agda` uses the
  cubical v0.9 name `SymGroup` while the installed library is v0.5 —
  the skew `BUILD.md` documents; verified present on the clean tree
  before this landing).
- **Prose-proved (this note, all $a$, all odd $b$):** W3₂ (two
  independent one-line proofs), the strong-test degeneration ($s=0$),
  W4₂. All elementary; the sensor-side proof consumes
  `CYCLOTOMIC_SENSOR` eq. (2) (classical LTE at $p=2$).
- **Not claimed:** anything about even moduli with an odd prime factor
  ($n=2^am$, $m>1$ odd — there the unit group is a product and the
  question changes character); any density statement; any novelty —
  "the only Fermat liar base modulo $2^a$ is $1$" is elementary and
  surely folklore (`SEARCH` obligation below). What is new to the
  *corpus* is only the exact fate of the two-entry head under the
  blindness dictionary: first entry operational, second entry
  invisible, and the parity reason why.

## 7. Successor seeds

1. `SEARCH` — prior art for W3₂'s residue form (Fermat liars modulo
   $2^a$). Expected verdict: folklore/exercise; record the citation and
   demote §1 to it. Same obligation class as `HEAD_DEPTH_MERGE` seed 3
   (Monier/Rabin).
2. `PROVE` — which anatomy *does* read $e_+$? $v_2(b^2-1)=e_-+e_+$, so
   $e_+$ is sensed by squaring — the same $\pm1$ arithmetic that powers
   the strong test's window at odd moduli. Is there a
   compositeness-test organ in the corpus whose blindness depth at some
   modulus family is $e_-+e_+$ (or $e_+$ alone)? If yes, the two head
   entries get two *different* operational meanings, which would be the
   true two-parameter statement seed 2 was groping for.
3. `PROVE` — the composite-even-modulus boundary: for $n=2^am$
   ($m>1$ odd), $n-1$ is still odd, so $e_+$ is still invisible; but
   blindness now factors through CRT and the odd part re-enters via
   W3 at each odd prime. State the exact product formula (elementary)
   and certify it; that would close the last gap between W3/W3₂ and
   blindness on arbitrary moduli.
