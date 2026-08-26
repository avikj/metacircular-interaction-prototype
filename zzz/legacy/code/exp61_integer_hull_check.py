"""Is 'spectrum lives on positive integers' stronger than m^2 >= 2m-1
for the functionals the frontier argument actually uses?

Setting: distinct zeros with integer multiplicities m_i >= 1,
N = sum m_i (zeros with multiplicity), S = sum m_i^2 (known <= (4/3)N in band 1).
Targets: (a) #atoms (distinct zeros), (b) #simple atoms (m_i = 1).
Question: given (N,S), does exact integer programming beat the two
convex bounds  #atoms >= N^2/S  and  #simple >= 2N - S ?"""
from itertools import count

def exact_min_atoms(N, S):
    # min k such that exists integers m_1..m_k >=1, sum=N, sum sq <= S
    for k in range(1, N+1):
        # minimal possible sum of squares with k atoms summing to N: as equal as possible
        q, r = divmod(N, k)
        minsq = r*(q+1)**2 + (k-r)*q**2
        if minsq <= S:
            return k
    return None

def exact_min_simple(N, S):
    # min #(m_i = 1) over integer configs with sum=N, sumsq <= S
    best = None
    # dp over (#atoms used) is unnecessary; search configs by multiset of big parts
    # minimize count of 1s => use as few 1s as possible, i.e. big multiplicities
    # but sum sq <= S caps bigness. DP on remaining N and budget S.
    from functools import lru_cache
    @lru_cache(None)
    def f(n, s):           # min ones to represent n with parts>=1, sumsq<=s
        if n == 0: return 0
        best = 10**9
        for m in range(1, n+1):
            if m*m > s: break
            sub = f(n-m, s-m*m)
            best = min(best, sub + (1 if m == 1 else 0))
        return best
    return f(N, S)

print(f"{'N':>4} {'S':>5} | {'CS bound':>9} {'exact atoms':>12} | {'2N-S':>6} {'exact simple':>13}")
for N in (12, 18, 24, 30, 36):
    S = (4*N)//3                      # the band-1 ceiling sum m^2 <= (4/3)N
    cs   = N*N/S
    ints = 2*N - S
    print(f"{N:>4} {S:>5} | {cs:>9.3f} {exact_min_atoms(N,S):>12} | {ints:>6} {exact_min_simple(N,S):>13}")
