#!/usr/bin/env python3
"""Experiment 40: certify the constants in the twisted compensated formula.

Preferred invocation:

    /tmp/avikj-math-venv/bin/python code/exp40_dirichlet_Achi_normalization.py

python-flint/Arb is the certificate path.  If python-flint is unavailable,
the script can use mpmath, but labels that result DISCOVERY ONLY.  This
experiment certifies the finite constants and elementary-function tails
tested below; it does not certify a truncation tail for any nontrivial-zero
sum.
"""

from __future__ import annotations

import sys


if not __debug__:
    raise RuntimeError("exp40 refuses python -O: validation must remain enabled")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise RuntimeError(message)


CHI4_TARGET = (
    "0.7831887854136735529438906937982220561804202315400532966106619187113886"
)
CHI5_TARGET = (
    "-0.02202465783872691842463476000992357551451102372799625211789285875353303"
)


def run_arb() -> None:
    from flint import acb, acb_series, arb, ctx, dirichlet_char

    ctx.prec = 256
    tolerance = arb("1e-65")
    identity_tolerance = arb(2) ** -180

    def close(z, target, tolerance_ball, label: str) -> None:
        error = abs(z - target)
        require(
            error.upper() < tolerance_ball.lower(),
            f"{label}: error {error} is not below {tolerance_ball}",
        )

    def l_series(character, center, length=4):
        s = acb_series([acb(center), acb(1)], length)
        return acb_series.dirichlet_l(s, character).coeffs()

    def character_value(character, n: int, expected: int, label: str) -> None:
        close(character(n), acb(expected), identity_tolerance, label)

    chi4 = dirichlet_char(4, 3)
    chi5 = dirichlet_char(5, 4)
    chi10 = dirichlet_char(10, 9)

    require(chi4.is_primitive() and chi4.conductor() == 4, "chi4 metadata")
    require(chi4.parity() == 1, "chi4 must be odd")
    require(chi5.is_primitive() and chi5.conductor() == 5, "chi5 metadata")
    require(chi5.parity() == 0, "chi5 must be even")
    require(not chi10.is_primitive() and chi10.conductor() == 5, "chi10 metadata")
    require(chi10.parity() == 0, "induced chi10 must be even")
    for n, expected in enumerate((0, 1, 0, -1)):
        character_value(chi4, n, expected, f"chi4({n})")
    for n, expected in enumerate((0, 1, -1, -1, 1)):
        character_value(chi5, n, expected, f"chi5({n})")
    for n, expected in enumerate((0, 1, 0, -1, 0, 0, 0, -1, 0, 1)):
        character_value(chi10, n, expected, f"chi10({n})")

    # At s=0: odd L(0) != 0, while even nonprincipal L(s)=a1*s+a2*s^2+...
    # Thus c_odd=a1/a0 and c_even=a2/a1=L''(0)/(2L'(0)).
    l4_at_zero = l_series(chi4, 0)
    l5_at_zero = l_series(chi5, 0)
    c4 = l4_at_zero[1] / l4_at_zero[0]
    c5 = l5_at_zero[2] / l5_at_zero[1]
    close(c4, acb(CHI4_TARGET), tolerance, "c_chi4 stable decimal")
    close(c5, acb(CHI5_TARGET), tolerance, "c_chi5 stable decimal")

    # Independent closed form for the Dirichlet beta constant.
    quarter = acb(1) / 4
    c4_gamma = -acb(4).log() + 2 * quarter.lgamma() - 2 * (3 * quarter).lgamma()
    close(c4, c4_gamma, identity_tolerance, "chi4 gamma closed form")

    # Functional-equation normalization:
    # c_chi = gamma + log(2*pi/f) - (L'/L)(1, conjugate chi).
    # Both test characters are real, so conjugation fixes them.
    euler_gamma = -acb(1).digamma()
    for label, character, conductor, c_at_zero in (
        ("chi4", chi4, 4, c4),
        ("chi5", chi5, 5, c5),
    ):
        l_at_one = l_series(character, 1)
        c_at_one = (
            euler_gamma
            + (2 * acb.pi() / conductor).log()
            - l_at_one[1] / l_at_one[0]
        )
        close(c_at_zero, c_at_one, identity_tolerance, f"{label} functional equation")

    # Closed elementary terms versus their positive series, with a rigorous
    # geometric majorant for each omitted tail.
    # Stop while the analytic tail remains wider than 256-bit rounding noise,
    # so the inclusion test certifies the stated tail rather than comparing
    # two numerically saturated 256-bit values.
    series_lengths = {2: 90, 3: 50, 10: 20}
    for x_integer in (2, 3, 10):
        x = acb(x_integer)
        inv = 1 / x
        delta0_closed = 1 - x * inv.atanh() - (1 - inv**2).log() / 2
        delta1_closed = inv.atanh() + x * (1 - inv**2).log() / 2
        j0_closed = -x.log() - 1 + delta0_closed
        j1_closed = delta1_closed

        terms = series_lengths[x_integer]
        delta0_series = acb(0)
        for k in range(1, terms + 1):
            delta0_series += x ** (-2 * k) / (2 * k * (2 * k + 1))
        delta1_series = acb(0)
        for k in range(0, terms + 1):
            delta1_series += x ** (-(2 * k + 1)) / ((2 * k + 1) * (2 * k + 2))

        tail0 = (arb(x_integer) ** (-2 * (terms + 1))) / (
            1 - arb(x_integer) ** -2
        )
        tail1 = (arb(x_integer) ** (-(2 * terms + 3))) / (
            1 - arb(x_integer) ** -2
        )
        require(
            abs(delta0_closed - delta0_series).upper() < tail0.upper(),
            f"J0 series tail failed at X={x_integer}",
        )
        require(
            abs(delta1_closed - delta1_series).upper() < tail1.upper(),
            f"J1 series tail failed at X={x_integer}",
        )
        close(
            j0_closed,
            -x.log() - 1 + delta0_series,
            tail0.upper(),
            f"J0 closed/series X={x_integer}",
        )
        close(j1_closed, delta1_series, tail1.upper(), f"J1 closed/series X={x_integer}")

    # chi10 is induced from chi5 after deleting the p=2 Euler factor:
    # L(s,chi10)=L(s,chi5)(1-chi5(2)2^-s).  Therefore
    # -L'/L(s,chi10)=-L'/L(s,chi5)
    #   - chi5(2) log(2) 2^-s/(1-chi5(2)2^-s).
    l5_at_two = l_series(chi5, 2)
    l10_at_two = l_series(chi10, 2)
    d5 = -l5_at_two[1] / l5_at_two[0]
    d10 = -l10_at_two[1] / l10_at_two[0]
    chi5_at_two = acb(-1)
    two_to_minus_s = acb(2) ** -2
    deleted_prime_term = (
        chi5_at_two * acb(2).log() * two_to_minus_s
        / (1 - chi5_at_two * two_to_minus_s)
    )
    close(
        d10,
        d5 - deleted_prime_term,
        identity_tolerance,
        "imprimitive minus sign in -L'/L",
    )

    # At X=3 the min-kernel sum is
    # sum_{k>=1} (-1)^k min(1,3/2^k)=-1/2, so the correction in (3.3d)
    # is -log(2)*(-1/2)=+log(2)/2.
    correction_x3 = acb(2).log() / 2
    direct_x3 = -acb(2).log() * (
        -1 + 3 * ((acb(1) / 4) / (1 + acb(1) / 2))
    )
    close(correction_x3, direct_x3, identity_tolerance, "imprimitive Phi sign at X=3")

    print("backend: python-flint/Arb (256-bit rigorous ball arithmetic)")
    print(f"c_chi4 = {c4}")
    print(f"c_chi5 = {c5}")
    print("verified: both parity formulas, functional equation, J0/J1 tails")
    print("verified: chi5 -> chi10 deleted-Euler-factor and Phi correction signs")
    print("PASS (finite normalization certificate)")
    print("OPEN: rigorous certification of the nontrivial-zero truncation tail")


def run_mpmath() -> None:
    import mpmath as mp

    mp.mp.dps = 90
    # mpmath's numerical differentiation of dirichlet() loses substantial
    # precision at s=0 and s=1.  This loose threshold is intentional: the
    # entire branch is a discovery smoke test, never a certificate.
    tolerance = mp.mpf("1e-8")

    def close(z, target, tolerance_value, label: str) -> None:
        error = abs(z - target)
        require(error < tolerance_value, f"{label}: error {error}")

    def l_function(s, values):
        return mp.dirichlet(s, values)

    chi4_values = (0, 1, 0, -1)
    chi5_values = (0, 1, -1, -1, 1)
    chi10_values = (0, 1, 0, -1, 0, 0, 0, -1, 0, 1)
    l4 = lambda s: l_function(s, chi4_values)
    l5 = lambda s: l_function(s, chi5_values)
    l10 = lambda s: l_function(s, chi10_values)

    c4 = mp.diff(l4, 0) / l4(0)
    c5 = mp.diff(l5, 0, 2) / (2 * mp.diff(l5, 0))
    close(c4, mp.mpf(CHI4_TARGET), tolerance, "c_chi4 stable decimal")
    close(c5, mp.mpf(CHI5_TARGET), tolerance, "c_chi5 stable decimal")
    c4_gamma = -mp.log(4) + 2 * mp.loggamma(mp.mpf(1) / 4) - 2 * mp.loggamma(
        mp.mpf(3) / 4
    )
    close(c4, c4_gamma, tolerance, "chi4 gamma closed form")
    for label, fun, conductor, c_at_zero in (
        ("chi4", l4, 4, c4),
        ("chi5", l5, 5, c5),
    ):
        c_at_one = (
            mp.euler + mp.log(2 * mp.pi / conductor) - mp.diff(fun, 1) / fun(1)
        )
        close(c_at_zero, c_at_one, tolerance, f"{label} functional equation")

    for x in map(mp.mpf, (2, 3, 10)):
        delta0_closed = 1 - x * mp.atanh(1 / x) - mp.log(1 - x**-2) / 2
        delta1_closed = mp.atanh(1 / x) + x * mp.log(1 - x**-2) / 2
        terms = 200
        delta0_series = mp.fsum(
            x ** (-2 * k) / (2 * k * (2 * k + 1)) for k in range(1, terms + 1)
        )
        delta1_series = mp.fsum(
            x ** (-(2 * k + 1)) / ((2 * k + 1) * (2 * k + 2))
            for k in range(terms + 1)
        )
        close(delta0_closed, delta0_series, mp.mpf("1e-80"), f"J0 X={x}")
        close(delta1_closed, delta1_series, mp.mpf("1e-80"), f"J1 X={x}")

    d5 = -mp.diff(l5, 2) / l5(2)
    d10 = -mp.diff(l10, 2) / l10(2)
    deleted_prime_term = -mp.log(2) * mp.power(2, -2) / (1 + mp.power(2, -2))
    close(d10, d5 - deleted_prime_term, tolerance, "imprimitive sign")

    print("backend: mpmath")
    print(f"c_chi4 = {mp.nstr(c4, 75)}")
    print(f"c_chi5 = {mp.nstr(c5, 75)}")
    print("PASS (DISCOVERY ONLY; not a rigorous certificate)")
    print("Install python-flint and rerun for Arb ball certification.")
    print("OPEN: rigorous certification of the nontrivial-zero truncation tail")


def main() -> None:
    try:
        import flint  # noqa: F401
    except ImportError:
        try:
            import mpmath  # noqa: F401
        except ImportError as error:
            raise RuntimeError(
                "Neither python-flint nor mpmath is installed. "
                "Use /tmp/avikj-math-venv/bin/python."
            ) from error
        run_mpmath()
    else:
        run_arb()


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"FAIL: {error}", file=sys.stderr)
        raise
