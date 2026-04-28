# 03 — DIABLO

The first tutorial that performs **genuine multi-omics integration**. DIABLO (Singh et al., *Bioinformatics* 35:3055, 2019) extends sPLS-DA to multiple blocks with a cross-block correlation constraint controlled by a *design matrix*.

## What is in this folder

- [`diablo.qmd`](diablo.qmd) — rendered as the *Tutorial 2: DIABLO* page of the site.
- [`scripts/`](scripts/) — standalone helper scripts.

## What you do here

1. Read the tutorial.
2. Run it locally with `quarto render 03_diablo/diablo.qmd` from the repository root.

## Library used

[`mixOmics`](http://mixomics.org/mixDIABLO/) — DIABLO is part of the `mixOmics` package; the canonical entry point is `block.splsda()`. We use the package-default weighted design ($D = 0.1$).
