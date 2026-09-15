#!/usr/bin/env python3
"""The VCC prediction artefact: the machine's step on the finite control population.

For each validation context c and requested target g (pert_counts), the predicted
perturbed population is  stepK(K, P_c, kd g) = { floor0(cell + up_g - down_g) : cell in P_c }
sampled to n_cells — the same definition as Perturb.bend's perturb/applyGen (truncated
subtraction = the floor), in the same fixed point, then written back to floats. No latent
representation: each predicted cell IS a control cell moved by the installed generator.
Output: pred.h5ad (obs target_gene incl. the controls), then `cell-eval prep` packs the .vcc.
"""
import argparse, json, numpy as np, pandas as pd, anndata as ad, scipy.sparse as sp

def dense(X): return X.toarray() if sp.issparse(X) else np.asarray(X)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--controls", required=True); ap.add_argument("--generators", required=True)
    ap.add_argument("--counts", required=True); ap.add_argument("--out", default="data/pred.h5ad")
    ap.add_argument("--pert-col", default="target_gene"); ap.add_argument("--ctx-col", default="context")
    ap.add_argument("--control", default="non-targeting"); ap.add_argument("--seed", type=int, default=0)
    a = ap.parse_args()
    rng = np.random.default_rng(a.seed)
    ctl = ad.read_h5ad(a.controls); gens = json.load(open(a.generators)); scale = gens["scale"]
    assert gens["genes"] == ctl.var_names.tolist(), "gene order differs from the training gene list"
    counts = pd.read_csv(a.counts)
    X = dense(ctl.X); ctx = ctl.obs[a.ctx_col].astype(str).values if a.ctx_col in ctl.obs else np.array(["all"] * ctl.n_obs)
    Xs, obs = [X.astype(np.float32)], [pd.DataFrame({a.pert_col: [a.control] * ctl.n_obs, a.ctx_col: ctx})]
    missing = 0
    for _, row in counts.iterrows():
        g, n = row[a.pert_col], int(row["n_cells"]); c = row[a.ctx_col] if a.ctx_col in counts else ctx[0]
        P = X[ctx == c]; Pq = np.rint(P * scale).astype(np.int64)
        if g not in gens["generators"]:
            missing += 1; shift = np.zeros(P.shape[1], dtype=np.int64)     # unknown target: the identity generator (ntc)
        else:
            gg = gens["generators"][g]; shift = np.array(gg["up"], dtype=np.int64) - np.array(gg["down"], dtype=np.int64)
        idx = rng.choice(P.shape[0], n, replace=n > P.shape[0])
        pred = np.maximum(Pq[idx] + shift[None, :], 0)                        # truncated: the floor
        Xs.append((pred / scale).astype(np.float32)); obs.append(pd.DataFrame({a.pert_col: [g] * n, a.ctx_col: c}))
    O = pd.concat(obs, ignore_index=True); O.index = O.index.astype(str)
    out = ad.AnnData(X=sp.csr_matrix(np.vstack(Xs)), obs=O, var=pd.DataFrame(index=ctl.var_names))
    out.write_h5ad(a.out)
    print(f"predicted {out.n_obs} cells ({len(counts)} (context,target) requests, {missing} without an installed generator) -> {a.out}")

if __name__ == "__main__":
    main()
