"""Shared utilities for the prime pair field project.

The pair field is K(w,d) = a_{w-d} a_{w+d}, i.e. the rank-one tensor a (x) a
read in center/difference coordinates u = w-d, v = w+d.
"""
import numpy as np
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"


def sieve_lambda(N):
    """von Mangoldt Lambda(n) for 0 <= n <= N, as float64 array."""
    lam = np.zeros(N + 1)
    is_comp = np.zeros(N + 1, dtype=bool)
    for p in range(2, N + 1):
        if not is_comp[p]:
            lp = np.log(p)
            pk = p
            while pk <= N:
                lam[pk] = lp
                pk *= p
            is_comp[p * p :: p] = True
    return lam


def sieve_primes(N):
    """Boolean prime indicator for 0 <= n <= N."""
    is_p = np.ones(N + 1, dtype=bool)
    is_p[:2] = False
    for p in range(2, int(N ** 0.5) + 1):
        if is_p[p]:
            is_p[p * p :: p] = False
    return is_p


def load_zeros(k=None):
    """First 100k positive imaginary parts of nontrivial zeta zeros (Odlyzko)."""
    g = np.loadtxt(DATA / "odlyzko_zeros_100k.txt")
    return g if k is None else g[:k]


def additive_convolution(a):
    """r(N) = sum_{m+n=N} a_m a_n via FFT. Returns array of length 2*len(a)-1."""
    n = len(a)
    L = 1
    while L < 2 * n:
        L *= 2
    fa = np.fft.rfft(a, L)
    r = np.fft.irfft(fa * fa, L)[: 2 * n - 1]
    return r


def autocorrelation(a):
    """c(h) = sum_n a_n a_{n+h} via FFT, h = 0..len(a)-1."""
    n = len(a)
    L = 1
    while L < 2 * n:
        L *= 2
    fa = np.fft.rfft(a, L)
    c = np.fft.irfft(np.abs(fa) ** 2, L)[:n]
    return c
