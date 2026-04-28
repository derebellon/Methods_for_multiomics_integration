# 02 — sparse PLS-DA

A single-omic, supervised, sparse latent-variable method. **Not multi-omics integration in itself** — we run it first as a primer because DIABLO (next folder) is its multi-block extension, and because single-omic sPLS-DA is the obligatory baseline in any multi-omics paper.

## What is in this folder

- [`splsda.qmd`](splsda.qmd) — rendered as the *Tutorial 1: Sparse PLS-DA* page of the site.
- [`scripts/`](scripts/) — standalone helper scripts (e.g. results-extraction utilities).

## What you do here

1. Read the tutorial.
2. Run it locally with `quarto render 02_splsda/splsda.qmd` from the repository root after restoring the R environment.

## Library used

[`mixOmics`](http://mixomics.org/) — Rohart F, Gautier B, Singh A, Lê Cao K-A. *PLOS Comput Biol* 13(11):e1005752 (2017). Documentation followed verbatim.
