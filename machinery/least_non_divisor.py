#!/usr/bin/env python3
"""The walk's forced sensor, computed from the theorem instead of by scanning.

    python3 machinery/least_non_divisor.py

`runtime/walk.py` finds its next forced sensor with

    q = 2
    while lcm % q == 0: q += 1          # q-1 divisions of a big integer
    assert prime_power_certificate(q)   # trial division, every install

Both lines are replaced by one theorem, proved in
`formal/pairfield/Pairfield/LeastNonDivisor.lean`:

    the least positive non-divisor of L IS the least prime power not
    dividing L

(`isPrimePow_of_least_non_divisor` + `least_of_least_primePow`).  So the
producer below enumerates prime powers, never composites, and never has to
re-derive the prime-power property: it is inherited.

This file is a FALSIFIER and a reference producer, not the certificate bridge.
The bridge is the Lean module; what runs here only exercises it and would
expose a disagreement between the two implementations.
"""

from __future__ import annotations

import sys
from math import gcd


# -------------------------------------------------------------------------
# the scan the machine currently performs (kept only as the control)
# -------------------------------------------------------------------------

def least_non_divisor_scan(L: int) -> int:
    """Least q >= 1 with q not dividing L.  q-1 divisions of a big integer."""
    q = 1
    while L % q == 0:
        q += 1
    return q


# -------------------------------------------------------------------------
# the theorem-driven producer
# -------------------------------------------------------------------------

def prime_powers(limit: int):
    """Prime powers 2,3,4,5,7,8,9,... up to `limit`, by a sieve on the base."""
    sieve = bytearray([1]) * (limit + 1)
    sieve[0:2] = b"\x00\x00"
    out = []
    for p in range(2, limit + 1):
        if sieve[p]:
            for m in range(p * p, limit + 1, p):
                sieve[m] = 0
            r = p
            while r <= limit:
                out.append(r)
                r *= p
    out.sort()
    return out


def least_non_divisor(L: int, pool=None) -> tuple[int, int, int, list[int]]:
    """Return (q, p, e, witness): the least non-divisor of L, its prime-power
    certificate, and the prime powers below q that were checked.

    By `least_of_least_primePow`, testing prime powers alone is complete."""
    limit = 4
    while True:
        pool = prime_powers(limit)
        witness = []
        for r in pool:
            if L % r:
                p = r
                while p * p <= r and r % p:
                    p += 1
                # r is a prime power; recover its base
                b = 2
                while r % b:
                    b += 1
                e, t = 0, r
                while t % b == 0:
                    t //= b
                    e += 1
                return r, b, e, witness
            witness.append(r)
        limit *= 2


def walk_sensor(frontier: int) -> int:
    """For the walk's own state, L = lcm(1..frontier), so the forced sensor is
    simply the least prime power ABOVE the frontier -- zero divisions."""
    n = frontier + 1
    while True:
        b = 2
        t = n
        while t % b:
            b += 1
        while t % b == 0:
            t //= b
        if t == 1:
            return n
        n += 1


# -------------------------------------------------------------------------
# differential falsifier: three implementations must agree
# -------------------------------------------------------------------------

def main() -> int:
    bad = 0

    # (a) scan vs theorem-driven producer, on every L in a box
    for L in range(1, 3000):
        q_scan = least_non_divisor_scan(L)
        q_thm, p, e, _ = least_non_divisor(L)
        if q_scan != q_thm or p ** e != q_thm:
            print("DISAGREE at L=%d: scan %d, theorem %d" % (L, q_scan, q_thm))
            bad += 1
    print("(a) scan vs theorem on L in [1,3000): %s" % ("FAIL" if bad else "agree"))

    # (b) the walk's own trace: L = lcm(1..k) at every install
    L, frontier, stream = 1, 1, []
    for _ in range(40):
        q_scan = least_non_divisor_scan(L)
        q_thm, p, e, wit = least_non_divisor(L)
        q_walk = walk_sensor(frontier)
        if not (q_scan == q_thm == q_walk):
            print("DISAGREE at frontier %d: %d %d %d" % (frontier, q_scan, q_thm, q_walk))
            bad += 1
        # the real content: no prime power lies strictly between the frontier
        # and the forced sensor, so the compressed certificate over the
        # UNCHECKED range is empty -- every witness already divides L by
        # construction (it is <= frontier and L = lcm(1..frontier)).
        fresh = [r for r in wit if r > frontier]
        if fresh:
            print("  UNCHECKED prime powers at frontier %d: %s" % (frontier, fresh))
            bad += 1
        stream.append(q_scan)
        L = L // gcd(L, q_scan) * q_scan
        frontier = max(frontier, q_scan)
    print("(b) walk trace, 40 installs: %s" % ("FAIL" if bad else "agree"))
    print("    stream = %s" % ", ".join(map(str, stream[:20])))

    # (c) known-false control: the scan must NOT be replaceable by primes only
    #     (4 is the first place prime-only search would answer wrongly)
    prime_only = 2
    while 6 % prime_only == 0:
        prime_only += 1 if prime_only == 2 else 2
    print("(c) control -- prime-only search on L=6 gives %d, true answer %d: %s"
          % (prime_only, least_non_divisor_scan(6),
             "control fires" if prime_only != least_non_divisor_scan(6) else "CONTROL FAILED"))

    # (d) the exact cost statement, exhibited rather than fitted
    L, frontier, scan_ops, thm_ops = 1, 1, 0, 0
    for _ in range(29):                       # the 10^30 walk
        q = least_non_divisor_scan(L)
        scan_ops += q - 1                     # divisions of an len(L)-bit int
        thm_ops += q - frontier               # prime-power tests on small ints
        L = L // gcd(L, q) * q
        frontier = max(frontier, q)
    print("(d) to the 10^30 frontier (%d): scan does %d big-integer divisions;"
          % (frontier, scan_ops))
    print("    the theorem does %d small prime-power tests (lcm has %d bits)."
          % (thm_ops, L.bit_length()))

    return 1 if bad else 0


if __name__ == "__main__":
    raise SystemExit(main())
