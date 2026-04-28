# 07 — Variational Autoencoder

Deep generative integration via a non-linear neural-network latent variable model. The first (and only) deep-learning method in this collection.

## What is in this folder

- [`vae.qmd`](vae.qmd) — rendered as the *Tutorial 6: VAE* page of the site. Mixes R chunks (data prep) and Python chunks (model + training).

## Library used

- **PyTorch** [@kingma2014vae] for the VAE implementation.
- **scikit-learn** for the downstream classifier and PCA fallback.
- **UMAP** for the latent-space visualisation.

The R side calls Python via [`reticulate`](https://rstudio.github.io/reticulate/); the first run requires a working Python environment with `torch`, `numpy`, `scikit-learn`, `matplotlib` and `umap-learn` installed.

## Honest disclaimer

For *n* = 671 patients (GS-BRCA), a VAE typically under-performs linear methods like DIABLO and MOFA2. We include this tutorial to demonstrate the workflow on a manageable dataset; for a real deep multi-omics study you would want at least *n* > 1,000 samples or a transfer-learning strategy.
