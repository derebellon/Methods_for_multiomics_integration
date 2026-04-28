# 04 — MOFA2

Unsupervised Bayesian factor analysis with mixed likelihoods and native missing-data handling. The first unsupervised method in this collection.

## What is in this folder

- [`mofa2.qmd`](mofa2.qmd) — rendered as the *Tutorial 3: MOFA2* page of the site.
- [`scripts/`](scripts/) — standalone helper scripts.

## What you do here

1. Read the tutorial.
2. Run it locally with `quarto render 04_mofa2/mofa2.qmd` from the repository root.

## Library used

[`MOFA2`](https://biofam.github.io/MOFA2/) — Argelaguet et al., *Mol Syst Biol* 14:e8124 (2018) and *Genome Biol* 21:111 (2020). The R package wraps the Python `mofapy2` backend; first run installs a basilisk-managed conda environment automatically.
