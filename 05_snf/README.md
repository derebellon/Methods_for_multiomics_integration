# 05 — Similarity Network Fusion (SNF)

The first network-based, patient-similarity method in this collection. Fuses per-block patient similarity matrices into a consensus network suitable for spectral clustering.

## What is in this folder

- [`snf.qmd`](snf.qmd) — rendered as the *Tutorial 4: SNF* page of the site.
- [`scripts/`](scripts/) — standalone helper scripts.

## Library used

[`SNFtool`](https://cran.r-project.org/package=SNFtool) — Wang B et al. *Nat Methods* 11:333 (2014). Default hyperparameters (K=20, α=0.5, T=20) follow the original paper.
