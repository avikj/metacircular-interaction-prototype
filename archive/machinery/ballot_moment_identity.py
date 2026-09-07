"""Exact replay for notes/BALLOT_MOMENT_IDENTITY.md (fleet-ballot-moment).

Successor seed 3 of R0042 (notes/DIVISOR_FLAG_LABEL_AUTOMATON.md), joining
it to seed 2 (notes/BIJECTIVE_SMITH_ASSEMBLY.md): the exact identity
connecting the ballot path counts

    C_p(i,k) = sum_{j<=i} (binom(k,j) - binom(k,j-1)) p^j

(chains Z^2 = L_0 > ... > L_k to a fixed endpoint of label i) to the
Smith-label moment

    S(p^k) = sum_{[Z^2:L]=p^k} e_1(L) = sum_i p^i psi(p^{k-2i})
           = (p^{k+1} + p^k - p^{ceil(k/2)} - p^{floor(k/2)}) / (p - 1).

Laws replayed here (proofs in the note; the tree combinatorics is
classical -- Kesten, Ihara, P. Hall -- no novelty claimed):

* Resummation (note, Lemma 1): sum_{i>=j} p^i psi(p^{k-2i})
  = p^j S(p^{k-2j}) -- the self-similarity of S under label shift.

* Chain-side weighted count (note, Theorem 2).  The uniform-chain moment
  W(k) := sum_L e_1(L) C_p(label(L), k) = sum_i p^i psi(p^{k-2i}) C_p(i,k)
  equals the p^2-weighted ballot transform of S,

      W(k) = sum_j (binom(k,j)-binom(k,j-1)) p^{2j} S(p^{k-2j}),

  with closed form ((p^{k+1}+p^k) binom(k,floor(k/2))
  - (p^{ceil(k/2)}+p^{floor(k/2)}) B_p(k)) / (p-1), where
  B_p(k) = C_p(floor(k/2), k), and half-sum evaluation
  W(2t+1) = p^t (p+1) sum_{r<=t} binom(2t+1,r) p^r, W(2t+2) = 2p W(2t+1).
  The radial law: P(label = i) = psi(p^{k-2i}) C_p(i,k) / (p+1)^k
  (the distance distribution of the uniform walk on the (p+1)-regular
  tree, classical), and E[p^label] = W(k)/(p+1)^k.

* Ballot transfer lemma (note, Theorem 3).  For any weight w and any
  sequence G: sum_k x^k sum_j ballot(k,j) w^j G_{k-2j}
  = C_w(x) Ghat(x C_w(x)), C_w = 1 + w x^2 C_w^2 (Catalan).  Instances:
    - w = p^2, G_m = S(p^m):    V(x) = sum W(k) x^k = C Shat(xC);
    - w = p^2, G_m = 1+...+p^{floor(m/2)}: U(x) = sum_k sum_i p^i C_p(i,k) x^k
      = C / ((1 - xC)(1 - p x^2 C^2));
    - w = p,  G_m = sigma_1(p^m): recovers 1/(1-(p+1)x) (Ihara identity).

* Rationality split (note, Theorem 4).  Shat(x) = sum S(p^k) x^k
  = (1+x)/((1-px)(1-px^2)) is RATIONAL; V and U are algebraic of degree
  exactly 2 (irrational), certified by the Galois conjugation
  u -> 1/(p^2 u) of u = x C(x); so V, U differ from Shat and from every
  rational substitution of it.  Minimal counterexamples: U_1 = 1 while
  S(p) = p+1; W(2) - S(p^2) = p^2.  The exact bridge is the Ihara
  substitution x = u/(1+p^2 u^2):

      Shat(u) = V(u/(1+p^2 u^2)) / (1+p^2 u^2),

  and in the u-variable V = (1+p^2u^2)(1+u)/((1-pu)(1-pu^2)),
  U = (1+p^2u^2)/((1-u)(1-pu^2)), so V (1-pu) = U (1-u^2).

All computations are exact integers / Fractions.
"""

from fractions import Fraction
from math import comb

from bijective_smith_assembly import second_moment_prime_power
from divisor_flag_label_automaton import ballot, chain_count_closed
from hecke_coset_smith_assembly import psi

__all__ = [
    "stratum_size",
    "chain_counts_by_label",
    "chain_weighted_moment_dp",
    "chain_weighted_moment_stratum",
    "chain_weighted_moment_ballot",
    "balanced_chain_count",
    "chain_weighted_moment_closed",
    "chain_weighted_moment_halfsum",
    "label_distribution",
    "expected_p_label",
    "per_state_sum",
    "geometric_label_sum",
    "per_state_ballot",
    "series_mul",
    "catalan_series",
    "ballot_transfer_series",
    "euler_factor_series",
    "V_series",
    "U_series",
    "U_series_closed",
    "total_chain_series",
    "inverse_ihara_series",
    "phi_V",
    "phi_U",
    "galois_conjugate",
]


# ----------------------------------------------------------------------
# the chain ensemble by label (exact DP on the automaton)

def stratum_size(p, i, k):
    """N_k(i) = psi(p^{k-2i}): number of index-p^k lattices of label i."""
    if not 0 <= 2 * i <= k:
        raise ValueError("not a state: need 0 <= 2i <= k")
    return psi(p ** (k - 2 * i))


def chain_counts_by_label(p, k):
    """[M_k(i)]_i: number of length-k chains whose ENDPOINT has label i,
    by the forward automaton DP (R0042 Theorem 1: p keepers + 1 raiser
    from an unbalanced state, p+1 keepers from the balanced state).
    The note proves M_k(i) = psi(p^{k-2i}) C_p(i,k)."""
    counts = {0: 1}
    for level in range(k):
        nxt = {}
        for i, c in counts.items():
            keep = (p + 1) if 2 * i == level else p
            nxt[i] = nxt.get(i, 0) + keep * c
            if 2 * i < level:
                nxt[i + 1] = nxt.get(i + 1, 0) + c
        counts = nxt
    return [counts.get(i, 0) for i in range(k // 2 + 1)]


# ----------------------------------------------------------------------
# W(k) = sum_L e_1(L) C_p(label(L), k): five exact expressions

def chain_weighted_moment_dp(p, k):
    """W(k) = sum_i p^i M_k(i) by the automaton DP (the 'experiment')."""
    return sum(p ** i * m for i, m in enumerate(chain_counts_by_label(p, k)))


def chain_weighted_moment_stratum(p, k):
    """W(k) = sum_i p^i psi(p^{k-2i}) C_p(i,k) (stratum sizes x ballot
    closed form)."""
    return sum(p ** i * stratum_size(p, i, k) * chain_count_closed(p, i, k)
               for i in range(k // 2 + 1))


def chain_weighted_moment_ballot(p, k):
    """Theorem 2: W(k) = sum_j ballot(k,j) p^{2j} S(p^{k-2j}) -- the
    p^2-weighted ballot transform of the moment S."""
    return sum(ballot(k, j) * p ** (2 * j)
               * second_moment_prime_power(p, k - 2 * j)
               for j in range(k // 2 + 1))


def balanced_chain_count(p, k):
    """B_p(k) = C_p(floor(k/2), k) = sum_{j<=floor(k/2)} ballot(k,j) p^j:
    chains to the most-balanced endpoint (the full ballot polynomial)."""
    return chain_count_closed(p, k // 2, k)


def chain_weighted_moment_closed(p, k):
    """Theorem 2 closed form, mirroring S(p^k)'s:

        W(k) = ( (p^{k+1}+p^k) binom(k, floor(k/2))
                 - (p^{ceil(k/2)}+p^{floor(k/2)}) B_p(k) ) / (p-1)."""
    num = ((p ** (k + 1) + p ** k) * comb(k, k // 2)
           - (p ** ((k + 1) // 2) + p ** (k // 2)) * balanced_chain_count(p, k))
    assert num % (p - 1) == 0, (p, k)
    return num // (p - 1)


def chain_weighted_moment_halfsum(p, k):
    """Theorem 2 half-sum evaluation: W(0) = 1,
    W(2t+1) = p^t (p+1) sum_{r=0}^{t} binom(2t+1, r) p^r,
    W(2t+2) = 2p W(2t+1)."""
    if k == 0:
        return 1
    if k % 2 == 1:
        t = k // 2
        return p ** t * (p + 1) * sum(comb(k, r) * p ** r for r in range(t + 1))
    return 2 * p * chain_weighted_moment_halfsum(p, k - 1)


# ----------------------------------------------------------------------
# the radial law (classical: distance distribution on the tree)

def label_distribution(p, k):
    """P(I_k = i) = psi(p^{k-2i}) C_p(i,k) / (p+1)^k as exact Fractions:
    the label of the endpoint of a uniform random length-k chain,
    equivalently (k - D_k)/2 for the distance D_k of the uniform walk on
    the (p+1)-regular tree (classical radial distribution)."""
    total = (p + 1) ** k
    return {i: Fraction(stratum_size(p, i, k) * chain_count_closed(p, i, k),
                        total)
            for i in range(k // 2 + 1)}


def expected_p_label(p, k):
    """E[p^{I_k}] = W(k) / (p+1)^k, exactly."""
    return Fraction(chain_weighted_moment_closed(p, k), (p + 1) ** k)


# ----------------------------------------------------------------------
# the per-state sum U_k = sum_i p^i C_p(i,k) (one summand per label)

def per_state_sum(p, k):
    """U_k = sum_{2i<=k} p^i C_p(i,k)."""
    return sum(p ** i * chain_count_closed(p, i, k)
               for i in range(k // 2 + 1))


def geometric_label_sum(p, m):
    """R_m = 1 + p + ... + p^{floor(m/2)} (the G-sequence for U)."""
    return (p ** (m // 2 + 1) - 1) // (p - 1)


def per_state_ballot(p, k):
    """U_k = sum_j ballot(k,j) p^{2j} R_{k-2j}: the same p^2-weighted
    ballot transform, with S replaced by the geometric sum R."""
    return sum(ballot(k, j) * p ** (2 * j) * geometric_label_sum(p, k - 2 * j)
               for j in range(k // 2 + 1))


# ----------------------------------------------------------------------
# exact power series (lists of coefficients, degree 0..n)

def series_mul(a, b, n):
    """Product of two series truncated at degree n, exact."""
    out = [0] * (n + 1)
    for i, x in enumerate(a[: n + 1]):
        if x:
            for j, y in enumerate(b[: n + 1 - i]):
                out[i + j] += x * y
    return out


def catalan_series(w, n):
    """C_w(x) = 1 + w x^2 C_w(x)^2 truncated at degree n:
    C_w = sum_t Catalan_t w^t x^{2t}, exact integers."""
    c = [0] * (n + 1)
    for t in range(0, n + 1, 2):
        m = t // 2
        c[t] = (comb(2 * m, m) // (m + 1)) * w ** m
    return c


def ballot_transfer_series(w, G, n):
    """Theorem 3: sum_k x^k sum_j ballot(k,j) w^j G[k-2j]
    = C_w(x) * sum_m G[m] (x C_w(x))^m, truncated at degree n.
    G is a list of length >= n+1."""
    c = catalan_series(w, n)
    xc = [0] + c[:n]
    power = [1] + [0] * n
    acc = [0] * (n + 1)
    for m in range(n + 1):
        for d in range(n + 1):
            acc[d] += G[m] * power[d]
        power = series_mul(power, xc, n)
    return series_mul(c, acc, n)


def euler_factor_series(p, n):
    """Shat(x) = (1+x)/((1-px)(1-px^2)) to degree n, by exact geometric
    convolution; equals [S(p^k)]_k (Theorem 2 of R0042 seed 2)."""
    geo1 = [p ** a for a in range(n + 1)]
    geo2 = [p ** (b // 2) if b % 2 == 0 else 0 for b in range(n + 1)]
    e = series_mul(geo1, geo2, n)
    return [e[d] + (e[d - 1] if d >= 1 else 0) for d in range(n + 1)]


def V_series(p, n):
    """V(x) = sum_k W(k) x^k to degree n, from the automaton DP."""
    return [chain_weighted_moment_dp(p, k) for k in range(n + 1)]


def U_series(p, n):
    """U(x) = sum_k U_k x^k to degree n, from the closed form of C_p."""
    return [per_state_sum(p, k) for k in range(n + 1)]


def U_series_closed(p, n):
    """U(x) = C / ((1 - xC)(1 - p x^2 C^2)), C = C_{p^2}(x), as an exact
    truncated series: computed as C * (sum_m R_m (xC)^m) via Theorem 3."""
    G = [geometric_label_sum(p, m) for m in range(n + 1)]
    return ballot_transfer_series(p * p, G, n)


def total_chain_series(p, n):
    """Ihara instance (w = p, G = sigma_1(p^m)): must equal
    [(p+1)^k]_k, i.e. 1/(1-(p+1)x)."""
    G = [(p ** (m + 1) - 1) // (p - 1) for m in range(n + 1)]
    return ballot_transfer_series(p, G, n)


def inverse_ihara_series(p, n):
    """The inverse substitution: V(u/(1+p^2 u^2)) / (1+p^2 u^2) as a
    series in u to degree n.  Theorem 4: this equals Shat(u), i.e. the
    Euler factor of S is recovered exactly from the chain ensemble."""
    v = V_series(p, n)
    inv = [(-p * p) ** (t // 2) if t % 2 == 0 else 0 for t in range(n + 1)]
    xu = [0] + inv[:n]                       # u/(1+p^2u^2)
    power = [1] + [0] * n
    comp = [0] * (n + 1)
    for k in range(n + 1):
        for d in range(n + 1):
            comp[d] += v[k] * power[d]
        power = series_mul(power, xu, n)
    return series_mul(comp, inv, n)


# ----------------------------------------------------------------------
# irrationality certificate (Theorem 4): Galois conjugation u -> 1/(p^2 u)

def phi_V(p, t):
    """Phi_V(T) = (1+p^2T^2)(1+T)/((1-pT)(1-pT^2)): V(x) = Phi_V(u) at
    u = x C(x).  Exact Fraction evaluation."""
    t = Fraction(t)
    return (1 + p * p * t * t) * (1 + t) / ((1 - p * t) * (1 - p * t * t))


def phi_U(p, t):
    """Phi_U(T) = (1+p^2T^2)/((1-T)(1-pT^2)): U(x) = Phi_U(u)."""
    t = Fraction(t)
    return (1 + p * p * t * t) / ((1 - t) * (1 - p * t * t))


def galois_conjugate(p, t):
    """The nontrivial conjugate of u = x C(x) over Q(x): u -> 1/(p^2 u)
    (the two roots of p^2 x u^2 - u + x = 0 have product 1/p^2)."""
    return Fraction(1, p * p * Fraction(t))
