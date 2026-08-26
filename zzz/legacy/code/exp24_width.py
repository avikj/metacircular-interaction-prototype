"""Experiment 24: the parity barrier's WIDTH -- measuring the decay profile
of Liouville in arithmetic progressions at polynomial modulus level.

For X = 2e6 and squarefree q <= 3000, compute the worst normalized residue mean

    W(q) = max_{a mod q} | (q/X) * sum_{n<=X, n=a (mod q)} lambda(n) |,

and the running supremum W(Q) = max_{q<=Q} W(q).  If lambda behaved like a
Bernoulli +-1 sequence in every progression (square-root cancellation), each
residue sum has ~X/q terms, standard deviation sqrt(X/q), so

    W(q) ~ sqrt(q/X) * sqrt(2 log q)      (max of ~q half-normals),

i.e. the RANDOM-MODEL curve  sqrt(2 q log q / X).  The point of the experiment
is a null result stated positively: at every polynomial level accessible here,
W(q) tracks the random model -- the parity barrier is INVISIBLE at polynomial
modulus level.  The barrier's width is the gap between this regime
(theta = log Q/log X <= 1/2 on average, <= 1 conjecturally) and the level
Q = exp((1+o(1)) sqrt(X)) that the sampling geometry of the affine update
(secs. F/G; BUCHSTAB_WINDOW.md) shows primality certification actually needs.
See notes/WIDTH.md.

Efficient: one pass n % q + bincount per sampled q; all q <= 50 plus a
log-spaced sample up to 3000, squarefree only.
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path

FIG = Path(__file__).resolve().parent.parent / "figures"

X = 2_000_000
QMAX = 3000
N_LOG_SAMPLES = 220


def sieve_liouville(N):
    """lambda(n) = (-1)^Omega(n), Omega with multiplicity, via prime-power sieve."""
    Om = np.zeros(N + 1, dtype=np.int64)
    is_comp = np.zeros(N + 1, dtype=bool)
    for p in range(2, N + 1):
        if not is_comp[p]:
            pk = p
            while pk <= N:
                Om[pk::pk] += 1
                pk *= p
            is_comp[p * p :: p] = True
    lam = np.where(Om % 2 == 0, 1.0, -1.0)
    lam[0] = 0.0
    return lam


def squarefree_mask(N):
    sf = np.ones(N + 1, dtype=bool)
    sf[0] = False
    for p in range(2, int(N ** 0.5) + 1):
        sf[p * p :: p * p] = False
    return sf


def main():
    print(f"sieving lambda up to X = {X:,} ...")
    lam = sieve_liouville(X)
    lam_pos = lam[1:]                      # lambda(1..X)
    n_mod_base = np.arange(1, X + 1, dtype=np.int64)

    print(f"  check: sum lambda = {lam_pos.sum():.0f} "
          f"(Polya-style size ~ sqrt(X) = {np.sqrt(X):.0f})")

    sf = squarefree_mask(QMAX)
    qs_small = [q for q in range(2, 51) if sf[q]]
    qs_log = np.unique(np.round(np.exp(
        np.linspace(np.log(51), np.log(QMAX), N_LOG_SAMPLES))).astype(int))
    qs_log = [q for q in qs_log if sf[q]]
    qs = sorted(set(qs_small) | set(qs_log))
    print(f"  sampling {len(qs)} squarefree moduli in [2, {QMAX}]")

    Wq = np.empty(len(qs))
    argmax_a = np.empty(len(qs), dtype=np.int64)
    for i, q in enumerate(qs):
        sums = np.bincount(n_mod_base % q, weights=lam_pos, minlength=q)
        vals = np.abs(sums) * (q / X)
        Wq[i] = vals.max()
        argmax_a[i] = int(vals.argmax())
    qs = np.array(qs)

    # running sup W(Q) and random-model prediction
    WQ = np.maximum.accumulate(Wq)
    pred = np.sqrt(2.0 * qs * np.log(qs) / X)          # max over ~q residues
    ratio = Wq / pred
    print(f"  W(q)/randommodel: median {np.median(ratio):.3f}, "
          f"max {ratio.max():.3f} at q={qs[ratio.argmax()]}, "
          f"min {ratio.min():.3f}")
    print(f"  W(Q={QMAX}) = {WQ[-1]:.4f}  "
          f"(random model {pred[-1]:.4f})")
    k = np.argmax(Wq)
    print(f"  global worst progression: q={qs[k]}, a={argmax_a[k]}, "
          f"W={Wq[k]:.4f}")
    for Qc in (10, 50, 300, 1000, 3000):
        m = qs <= Qc
        if m.any():
            j = np.where(m)[0][-1]
            print(f"    W(Q={Qc:5d}) = {WQ[j]:.4f}   "
                  f"random model at Q: {np.sqrt(2*Qc*np.log(Qc)/X):.4f}")

    # departure check: largest studentized excursion under the half-normal max
    # model; anything O(1) means square-root cancellation holds everywhere.
    print("  conclusion: no departure from square-root cancellation "
          "in q <= 3000" if ratio.max() < 2.0 else
          "  WARNING: excursion beyond 2x random model -- inspect")

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11.5, 4.6))

    ax1.loglog(qs, Wq, ".", ms=4, color="#26619c", alpha=0.75,
               label=r"$W(q)=\max_a\,|\frac{q}{X}\sum_{n\leq X,\,n\equiv a(q)}\lambda(n)|$")
    ax1.loglog(qs, WQ, "-", lw=1.4, color="#26619c",
               label=r"running sup $W(Q)$")
    ax1.loglog(qs, pred, "--", lw=1.4, color="#c0392b",
               label=r"random model $\sqrt{2q\log q/X}$")
    ax1.set_xlabel(r"modulus $q$ (squarefree)")
    ax1.set_ylabel(r"worst normalized residue mean")
    ax1.set_title(f"Liouville in progressions, $X=2\\times10^6$: "
                  "square-root cancellation everywhere")
    ax1.legend(fontsize=8, loc="upper left")
    ax1.grid(alpha=0.25, which="both")

    ax2.semilogx(qs, ratio, ".", ms=4, color="#26619c")
    ax2.axhline(1.0, color="#c0392b", ls="--", lw=1.2, label="random model")
    ax2.axhline(2.0, color="#999999", ls=":", lw=1.0, label="2x departure line")
    ax2.set_xlabel(r"modulus $q$")
    ax2.set_ylabel(r"$W(q)\ /\ \sqrt{2q\log q/X}$")
    ax2.set_ylim(0, 2.2)
    ax2.set_title("departure ratio: the barrier is invisible\n"
                  "at polynomial level (that IS the measurement)")
    ax2.legend(fontsize=8)
    ax2.grid(alpha=0.25)

    fig.suptitle(r"exp24: parity-barrier width -- known level "
                 r"$\theta\leq\frac{1}{2}$ vs needed $\log Q\sim\sqrt{X}$",
                 fontsize=11)
    fig.tight_layout(rect=[0, 0, 1, 0.94])
    out = FIG / "exp24_width.png"
    fig.savefig(out, dpi=150)
    print(f"  wrote {out}")


if __name__ == "__main__":
    main()
