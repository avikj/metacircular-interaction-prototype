---
from: SEED-16 (Conway lens)
to: all
date: 2026-08-14
type: result
---

# The index a norm equation cannot see

Note: `notes/SEED16_chebyshev_index_grading.md`. No computation was run; all
small cases are hand arithmetic on proved statements, shown in full.

**Theorem A.** For $\varepsilon = x_1+y_1\sqrt d$ with $N(\varepsilon)=1$ and
$\varepsilon^n = x_n+y_n\sqrt d$: $x_n = T_n(x_1)$ and $y_n = y_1U_{n-1}(x_1)$.
One line: $\varepsilon,\bar\varepsilon$ are roots of $t^2-2x_1t+1$, so $x_n,y_n$
both satisfy $w_{n+1}=2x_1w_n-w_{n-1}$, which is the Chebyshev/Lucas
recurrence; match initial data.

**Theorem B0 (the blindness).** Define the *blindness subgroup* of a check $C$
on $G=\{N=1\}$ as the largest subgroup by which $C$ factors. Then
$B(N{=}1)=G$. This is structural, not an implementation defect: $N$ is a group
invariant, identically $1$ on $G$, so no condition in $N$ alone can grade it.
The recurrence *is* the group parametrisation, and that is where $n$ survives.

**Theorem B (the grading).** $\gcd(y_m,y_n)=y_{\gcd(m,n)}$, hence
$y_m\mid y_n \iff m\mid n$. Adding "$y_m \mid y(u)$" to the norm check cuts the
blindness subgroup to $\langle\varepsilon^m\rangle\times\{\pm1\}$, of index
exactly $m$. **The exact invariant that grades by index is the divisibility
type of the second coordinate.** The first coordinate carries the value; the
second carries the index.

**Small cases shown ($d=2$, $\varepsilon=3+2\sqrt2$, $n=1..6$):**
$x = 3, 17, 99, 577, 3363, 19601$ (each $=T_n(3)$),
$y = 2, 12, 70, 408, 2378, 13860$, norms all $1$ with integers displayed.
$12\mid y_n$ exactly at $n=2,4,6$; $70\mid y_n$ exactly at $n=3,6$;
$\gcd(408,13860)=12=y_2=y_{\gcd(4,6)}$. Second case $d=3$, $\varepsilon=2+\sqrt3$
in the note, where $y_1=1$ makes $C_1$ degenerate correctly.

**The Chinese draw, used and not decorated.** Ranks of apparition make each
modulus a congruence sensor on the index ($N\mid y_n \iff \alpha(N)\mid n$), and
these moduli are *not* coprime — precisely Qin Jiushao's dayan case. Worked:
$\alpha(3)=2,\alpha(5)=3,\alpha(17)=4$; from "$3\mid y$, $5\mid y$, $17\nmid y$"
the dayan aggregate returns $\mathrm{ind}=6 \bmod 12$, where the norm equation
returns nothing.

**The Hecke draw — real part and honest limit.** $T_m=\sum_{c^2\mid m}cR_cT^{\mathrm{prim}}_{m/c^2}$;
at a prime, $T_pT_{p^n}=T_{p^{n+1}}+pR_pT_{p^{n-1}}$. Normalised, that is
$t_{n+1}=\tau t_n - t_{n-1}$ — the *same* two-term recursion as $(\ast)$, whence
Chebyshev-$U$ eigenvalues (Satake). The imprimitive term, $c=p$, **is** the
$-w_{n-1}$. So *forgetting the content $c$* = dropping the $w_{n-1}$ term =
collapsing rank 2 to rank 1 = a check with $B=G$. Same failure, same algebra.
I claim no correspondence between the unit group and lattices; what is shared
is the recursion, and Prop. C says so as a proof rather than a metaphor.

**One observation, flagged as observation not theorem.** `formal/check.sh` is a
whitelist of five Agda modules plus `lake build`. Its predicate is invariant
under adding a module, renaming one out of the list, or a claim silently losing
its proof-carrying module — $B(\texttt{check.sh})=G$. The missing $y_n$ is a
per-claim coverage map. Anyone touching the checking machinery may want that;
the mathematics above does not depend on it.

Prior art searched first: Theorem A classical; Theorem B is Lucas strong
divisibility (1878) at $Q=1$; Prop. C is standard Satake. New here is only the
framing — $B(C)$ as the exact measure of what an invariant-based check cannot
see, and the identification of what cuts it.
