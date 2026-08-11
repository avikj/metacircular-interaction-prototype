#!/usr/bin/env python3
"""Finite-window checks for notes/BUCHSTAB_WINDOW.md.

Computes the centered additive fourth energy by FFT at the square-root sieve
threshold and compares it with:

  (1) the limiting constant C_infinity * I_arch;
  (2) the finite-log archimedean profile, which explains slow convergence.

It also prints the corrected L2 variance for several Buchstab depths.
No zeta-zero data is used.
"""

from __future__ import annotations

import argparse
import math

import numpy as np
from scipy.integrate import quad
from scipy.signal import fftconvolve


C_INFINITY = 2.300961544695801


def prime_and_mangoldt_sieve(n: int) -> tuple[np.ndarray, np.ndarray]:
    is_prime = np.ones(n + 1, dtype=bool)
    is_prime[:2] = False
    for p in range(2, math.isqrt(n) + 1):
        if is_prime[p]:
            is_prime[p * p :: p] = False
    primes = np.flatnonzero(is_prime)
    mangoldt = np.zeros(n + 1, dtype=float)
    for p0 in primes:
        p = int(p0)
        q = p
        logp = math.log(p)
        while q <= n:
            mangoldt[q] = logp
            if q > n // p:
                break
            q *= p
    return primes, mangoldt


def rough_indicator(n: int, primes: np.ndarray, w: float) -> np.ndarray:
    rough = np.ones(n + 1, dtype=bool)
    rough[0] = False
    for p0 in primes[primes <= w]:
        p = int(p0)
        rough[p::p] = False
    return rough


def additive_energy(f: np.ndarray) -> float:
    n = len(f) - 1
    fft_len = 1 << (2 * n + 1).bit_length()
    spectrum = np.fft.rfft(f, fft_len)
    convolution = np.fft.irfft(spectrum * spectrum, fft_len)[: 2 * n + 1]
    return float(convolution @ convolution)


def i_arch() -> float:
    def convolution(s: float) -> float:
        lo, hi = max(0.0, s - 1.0), min(1.0, s)
        if lo >= hi:
            return 0.0
        return quad(
            lambda x: (1.0 + math.log(x)) * (1.0 + math.log(s - x)),
            lo,
            hi,
            epsabs=2e-11,
            limit=300,
        )[0]

    return quad(lambda s: convolution(s) ** 2, 0.0, 1.0, epsabs=1e-10)[0] + quad(
        lambda s: convolution(s) ** 2, 1.0, 2.0, epsabs=1e-10
    )[0]


def finite_profile_energy(log_x: float, c_x: float, grid_power: int = 19) -> float:
    """Integral of the exact finite-log profile by discrete convolution."""
    count = 1 << grid_power
    x = (np.arange(count) + 0.5) / count
    profile = np.zeros(count)
    mask = x >= math.exp(-log_x / 2.0)
    profile[mask] = log_x * (1.0 - c_x / (log_x + np.log(x[mask])))
    convolution = fftconvolve(profile, profile, mode="full") / count
    return float((convolution @ convolution) / count)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--x", type=int, default=1_000_000)
    parser.add_argument("--profile-grid-power", type=int, default=19)
    args = parser.parse_args()

    x_max = args.x
    primes, mangoldt = prime_and_mangoldt_sieve(x_max)
    log_x = math.log(x_max)
    integral = i_arch()
    print(f"X={x_max:,}, log X={log_x:.8f}")
    print(f"I_arch={integral:.12f}")
    print(f"C_infinity*I_arch={C_INFINITY * integral:.12f}")
    print()

    for u in (2.0, 2.2, 2.5, 2.8):
        w = x_max ** (1.0 / u)
        rough = rough_indicator(x_max, primes, w)
        phi = int(rough.sum())
        c_x = x_max / phi
        f = mangoldt - c_x * rough
        variance = float(f @ f)
        energy = additive_energy(f)
        connected = energy - 2.0 * variance**2 + float((f * f) @ (f * f))
        print(
            f"u={u:3.1f}  Phi={phi:8d}  c_X={c_x:10.6f}  "
            f"variance/(X log X)={variance/(x_max*log_x):.7f}  "
            f"E_conn log^4/X^3={connected*log_x**4/x_max**3:.7f}"
        )

        if u == 2.0:
            finite_i = finite_profile_energy(
                log_x, c_x, grid_power=args.profile_grid_power
            )
            print(
                " " * 7
                + f"finite-profile prediction={C_INFINITY*finite_i:.7f}; "
                + f"limiting prediction={C_INFINITY*integral:.7f}"
            )


if __name__ == "__main__":
    main()

